import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:studify/features/auth/domain/user_profile.dart';

/// A saved sign-in: the token and the profile it belongs to.
class StoredSession {
  const StoredSession({required this.token, required this.user});

  final String token;
  final UserProfile user;
}

/// Keeps the session in the Keychain / Android Keystore so "Keep me
/// signed in" survives app restarts. The profile is kept too, so the app
/// opens straight to the home screen, even offline.
class SessionStorage {
  SessionStorage([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const _tokenKey = 'auth_token';
  static const _userKey = 'auth_user';

  final FlutterSecureStorage _storage;

  Future<StoredSession?> read() async {
    try {
      final token = await _storage.read(key: _tokenKey);
      final userJson = await _storage.read(key: _userKey);
      if (token == null || token.isEmpty || userJson == null) return null;
      final user = UserProfile.fromJson(
        jsonDecode(userJson) as Map<String, dynamic>,
      );
      return StoredSession(token: token, user: user);
    } on Object catch (error) {
      // Unreadable data (e.g. restored from a backup on another device):
      // start signed out rather than crash.
      debugPrint('SessionStorage.read failed: $error');
      await clear();
      return null;
    }
  }

  Future<void> write(StoredSession session) async {
    await _storage.write(key: _tokenKey, value: session.token);
    await _storage.write(
      key: _userKey,
      value: jsonEncode(session.user.toJson()),
    );
  }

  Future<void> clear() async {
    try {
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _userKey);
    } on Object catch (error) {
      debugPrint('SessionStorage.clear failed: $error');
    }
  }
}
