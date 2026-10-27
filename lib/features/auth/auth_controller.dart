import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:studify/core/network/api_client.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/auth/data/auth_repository.dart';
import 'package:studify/features/auth/data/session_storage.dart';
import 'package:studify/features/auth/domain/user_profile.dart';

/// Why a sign-in attempt failed, in terms the login screen can show.
sealed class SignInFailure implements Exception {
  const SignInFailure();
}

/// Wrong email or password (or input the API rejected).
class InvalidCredentials extends SignInFailure {
  const InvalidCredentials();
}

/// Too many attempts: the account or device is locked for [retryAfter].
class TooManyAttempts extends SignInFailure {
  const TooManyAttempts(this.retryAfter);
  final Duration retryAfter;
}

/// The user's school has been switched off.
class SchoolInactive extends SignInFailure {
  const SchoolInactive();
}

/// Admins have no school; the app is for teachers and students.
class AdminNotSupported extends SignInFailure {
  const AdminNotSupported();
}

/// The server could not be reached or failed.
class ServiceUnavailable extends SignInFailure {
  const ServiceUnavailable();
}

/// A message for the login screen left by something that happened
/// elsewhere (a session that ended, a password that was reset).
enum AuthNotice { sessionExpired, schoolInactive, passwordReset }

/// Owns the session: the token, the signed-in user, and whether they
/// asked to stay signed in.
class AuthController extends ChangeNotifier {
  AuthController({
    required ApiClient client,
    required AuthRepository repository,
    required SessionStorage storage,
    StoredSession? restored,
    Future<void> Function()? onSignOut,
  }) : _repository = repository,
       _storage = storage,
       _onSignOut = onSignOut,
       _token = restored?.token,
       _user = restored?.user,
       _remember = restored != null {
    client
      ..tokenProvider = (() => _token)
      ..onUnauthorized = _handleUnauthorized;
  }

  /// Retry delay when a `429` comes without a `Retry-After` header.
  static const defaultLockout = Duration(seconds: 60);

  final AuthRepository _repository;
  final SessionStorage _storage;

  /// Called right before a voluntary [signOut] clears the token — e.g.
  /// to unregister this device's push token, which needs that token to
  /// authenticate. Not called from [_handleUnauthorized]: a session the
  /// server already ended can't authenticate that call either way.
  final Future<void> Function()? _onSignOut;

  String? _token;
  UserProfile? _user;
  bool _remember;
  AuthNotice? _notice;
  String? _noticeEmail;

  bool get isSignedIn => _token != null && _user != null;
  UserProfile? get user => _user;

  /// Signs in with `POST /login`, then loads the profile to learn the role.
  ///
  /// Throws a [SignInFailure].
  Future<void> signIn({
    required String email,
    required String password,
    required bool remember,
  }) async {
    try {
      final token = await _repository.login(email: email, password: password);
      // Requests below are authenticated with the new token.
      _token = token;
      final user = await _repository.fetchProfile();
      if (user.role == UserRole.admin) throw const AdminNotSupported();

      _user = user;
      _remember = remember;
      if (remember) {
        await _storage.write(StoredSession(token: token, user: user));
      } else {
        await _storage.clear();
      }
      notifyListeners();
    } on SignInFailure {
      _token = null;
      rethrow;
    } on ApiException catch (error) {
      _token = null;
      throw _failureFor(error);
    }
  }

  /// Logging out only forgets the token: the API has no logout call.
  Future<void> signOut() async {
    // Best-effort: signing out must never get stuck because, say, the
    // device is offline — [_onSignOut] is expected not to throw, but
    // this doesn't rely on that.
    try {
      if (_onSignOut case final onSignOut?) await onSignOut();
    } on Exception catch (error) {
      debugPrint('AuthController: onSignOut hook failed: $error');
    }
    await _endSession();
  }

  /// Reloads the profile (e.g. at startup, to check the saved token).
  /// A `401` signs the user out through [_handleUnauthorized]; network
  /// errors keep the saved profile.
  Future<void> refreshProfile() async {
    final token = _token;
    if (token == null) return;
    try {
      final user = await _repository.fetchProfile();
      if (_token != token) return;
      _user = user;
      if (_remember) {
        await _storage.write(StoredSession(token: token, user: user));
      }
      notifyListeners();
    } on ApiException catch (error) {
      debugPrint('refreshProfile failed: $error');
    }
  }

  /// Leaves a message for the next login screen, and optionally the email
  /// to fill in.
  void setNotice(AuthNotice notice, {String? email}) {
    _notice = notice;
    _noticeEmail = email;
  }

  /// Returns the pending notice once, then forgets it.
  ({AuthNotice notice, String? email})? takeNotice() {
    final notice = _notice;
    if (notice == null) return null;
    final result = (notice: notice, email: _noticeEmail);
    _notice = null;
    _noticeEmail = null;
    return result;
  }

  void _handleUnauthorized(ApiException error) {
    if (!isSignedIn) return;
    final email = _user?.email;
    setNotice(
      error.isSchoolInactive
          ? AuthNotice.schoolInactive
          : AuthNotice.sessionExpired,
      email: email,
    );
    unawaited(_endSession());
  }

  Future<void> _endSession() async {
    _token = null;
    _user = null;
    _remember = false;
    notifyListeners();
    await _storage.clear();
  }

  static SignInFailure _failureFor(ApiException error) {
    if (error.isTooManyRequests) {
      return TooManyAttempts(error.retryAfter ?? defaultLockout);
    }
    if (error.isSchoolInactive) return const SchoolInactive();
    if (error.isNetworkError || error.isServerError) {
      return const ServiceUnavailable();
    }
    // 400 (input the API rejects) and 401 (wrong email or password) look
    // the same to the user, as on the website.
    return const InvalidCredentials();
  }
}
