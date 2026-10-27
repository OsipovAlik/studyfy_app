// Reached via AppDependencies.pushNotifications -> main.dart, not by a
// local constructor call this lint's reachability check follows across
// files.
// ignore_for_file: unreachable_from_main

import 'dart:async';
import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/auth/data/auth_repository.dart';
import 'package:studify/notification/notification_service.dart';
import 'package:studify/notification/push_router.dart';

/// Where the device's push token lands locally; read it back with
/// `SharedPreferences.getInstance().then((p) => p.getString(deviceTokenPrefsKey))`.
const deviceTokenPrefsKey = 'deviceToken';

/// Runs in a separate isolate when a data message arrives while the app
/// is backgrounded or terminated. Needs its own Firebase init — nothing
/// from the main isolate (including this file's other state) carries
/// over to it.
@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling background message: ${message.messageId}');
}

/// Push notifications: requests permission, keeps the device's FCM
/// token registered with the server (`POST`/`DELETE /devices`), and
/// shows/routes incoming messages.
class FirebasePushService {
  FirebasePushService(this._authRepository);

  final AuthRepository _authRepository;

  // Lazy: evaluated the first time it's used, inside activate — not at
  // construction, which happens whether or not Firebase (and a
  // default app) has actually been set up, e.g. in a widget test.
  FirebaseMessaging get _firebaseMessaging => FirebaseMessaging.instance;
  final NotificationsService _notifications = NotificationsService();

  /// Guards attaching a second full set of FCM listeners if [activate]
  /// is called again in the same app life (e.g. logout then log back
  /// in) — without this, every push would fire its local notification
  /// once per call. Token registration itself isn't guarded by this:
  /// it's meant to run every time a session becomes active.
  bool _listening = false;

  /// True once the user has said no — [activate] still re-registers
  /// the token on every call otherwise, but there's no point retrying
  /// permission every time within the same app life.
  bool _permissionDenied = false;

  /// Sets up push notifications and registers this device with the
  /// server. Call every time a session becomes active: a fresh login,
  /// a restored session at app start, and (automatically, via
  /// `onTokenRefresh`) whenever Firebase rotates the token.
  Future<void> activate() async {
    if (!_listening) {
      _listening = true;
      // Registering the device token below must not depend on this
      // succeeding — they're independent concerns, and a plugin-level
      // hiccup here (seen in practice: two plugins prompting for the
      // same Android runtime permission back to back) must not silently
      // skip registration too.
      try {
        await _startListening();
      } on Exception catch (error) {
        debugPrint('FirebasePushService: could not start listening: $error');
      }
    }
    if (!_permissionDenied) await _registerCurrentToken();
  }

  Future<void> _startListening() async {
    FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

    // The one place notification permission is requested — on Android
    // 13+ this also triggers the real system POST_NOTIFICATIONS prompt
    // (not just a status read, despite what the package's own doc
    // comment claims). NotificationsService.init, below, must not ask
    // again.
    final settings = await _firebaseMessaging.requestPermission();
    debugPrint(
      'Notification permission status: ${settings.authorizationStatus}',
    );
    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('User denied permission for notifications.');
      _permissionDenied = true;
      return;
    }

    await _notifications.init();

    // Attached unconditionally, before the token fetch in activate() —
    // on iOS, APNs registration can easily take longer than a few
    // seconds on a real device (first launch, poor network), and if
    // that eager fetch times out, onTokenRefresh is the only remaining
    // way the token (and every future rotation of it) ever gets
    // captured.
    _firebaseMessaging.onTokenRefresh.listen(_saveAndRegisterToken);

    _handleForegroundMessages();
    _handleBackgroundMessageTaps();
    unawaited(_handleLaunchFromTerminatedMessage());
  }

  Future<void> _registerCurrentToken() async {
    // A failure/timeout here doesn't abort anything — onTokenRefresh
    // picks the token up once registration eventually completes.
    try {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        var apnsToken = await _firebaseMessaging.getAPNSToken();
        var attempts = 0;
        while (apnsToken == null && attempts < 10) {
          await Future<void>.delayed(const Duration(seconds: 1));
          apnsToken = await _firebaseMessaging.getAPNSToken();
          attempts++;
        }
        if (apnsToken == null) {
          debugPrint(
            'No APNs token yet after waiting; relying on onTokenRefresh.',
          );
          return;
        }
      }
      final token = await _firebaseMessaging.getToken();
      if (token != null) await _saveAndRegisterToken(token);
    } on Exception catch (error) {
      debugPrint('FirebasePushService: could not fetch the FCM token: $error');
    }
  }

  Future<void> _saveAndRegisterToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(deviceTokenPrefsKey, token);
    final platform = _platformName;
    if (platform == null) return;
    try {
      await _authRepository.registerDevice(token: token, platform: platform);
    } on ApiException catch (error) {
      debugPrint('FirebasePushService: could not register device: $error');
    }
  }

  /// Unregisters this device's saved token, if any. Best-effort — a
  /// failure (e.g. offline) just leaves a stale token registered until
  /// it's replaced by the next login or evicted server-side.
  Future<void> unregisterCurrentDevice() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(deviceTokenPrefsKey);
    if (token == null) return;
    try {
      await _authRepository.unregisterDevice(token);
    } on ApiException catch (error) {
      debugPrint('FirebasePushService: could not unregister device: $error');
    }
  }

  /// `android`, `ios` or `web` — the only platforms `POST /devices`
  /// accepts. Null elsewhere (desktop), where there's nothing to
  /// register.
  String? get _platformName {
    if (kIsWeb) return 'web';
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'android',
      TargetPlatform.iOS => 'ios',
      _ => null,
    };
  }

  void _handleForegroundMessages() {
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      unawaited(_showLocalNotification(notification, message.data));
    });
  }

  /// The app was backgrounded, not terminated, and got opened back up
  /// by tapping the system notification.
  void _handleBackgroundMessageTaps() {
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      PushRouter.handleData(message.data);
    });
  }

  /// The app was launched cold by tapping the system notification.
  Future<void> _handleLaunchFromTerminatedMessage() async {
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage == null) return;
    PushRouter.handleData(initialMessage.data);
  }

  Future<void> _showLocalNotification(
    RemoteNotification notification,
    Map<String, dynamic> data,
  ) {
    const maxNotificationId = 2147483647;
    final notificationId =
        DateTime.now().millisecondsSinceEpoch % maxNotificationId;
    return _notifications.show(
      id: notificationId,
      title: notification.title ?? '',
      body: notification.body ?? '',
      payload: data.isEmpty ? null : jsonEncode(data),
    );
  }
}
