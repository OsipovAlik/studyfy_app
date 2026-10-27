import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:studify/notification/push_router.dart';

/// The one channel every local (and FCM-triggered) notification posts
/// to. Declared once here and created explicitly in `NotificationsService
/// .init` — Android otherwise falls back to a default-importance
/// channel the first time a notification arrives, silently, which this
/// avoids.
const _channelId = 'studyfy_notifications';
const _channelName = 'Studyfy';
const _channelDescription = 'Homework, results and other updates from Studyfy.';

/// Wraps `flutter_local_notifications`: shows a notification now, and
/// routes a tap on it (local or FCM-triggered) via `PushRouter`.
class NotificationsService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Idempotent — safe to call more than once (e.g. on every sign-in).
  Future<void> init() async {
    if (_isInitialized) return;

    const initSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const initSettingsIOS = DarwinInitializationSettings();
    const initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    await notificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Android 13+ (API 33) requires the POST_NOTIFICATIONS permission at
    // runtime — declared in AndroidManifest.xml, and requested via
    // FirebasePushService's call to FirebaseMessaging.requestPermission
    // before this runs. Asking again here, through this plugin's own
    // requestNotificationsPermission, would prompt for the same OS
    // permission a second time while the first prompt may still be in
    // flight, which Android doesn't handle cleanly.
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            _channelId,
            _channelName,
            description: _channelDescription,
            importance: Importance.max,
          ),
        );

    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    _isInitialized = true;
  }

  NotificationDetails get _notificationDetails => const NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.max,
      priority: Priority.high,
    ),
    iOS: DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    ),
  );

  /// Shows a notification right away. [payload], if given, is handed to
  /// [PushRouter] when the notification is tapped — see
  /// `PushRouter.pathFor` for its shape.
  Future<void> show({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) {
    return notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: _notificationDetails,
      payload: payload,
    );
  }

  static void _onNotificationTapped(NotificationResponse response) {
    PushRouter.handlePayload(response.payload);
  }
}
