import 'package:studify/core/network/api_client.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/auth/domain/user_profile.dart';

/// Account endpoints that do not need a screen of their own.
class AuthRepository {
  AuthRepository(this._client);

  final ApiClient _client;

  /// `POST /login` → the token (valid 60 days).
  Future<String> login({
    required String email,
    required String password,
  }) async {
    final body = await _client.post(
      '/login',
      data: {'email': email, 'password': password},
      auth: false,
    );
    final token = body['token'];
    if (token is! String || token.isEmpty) {
      throw const ApiException(statusCode: 500);
    }
    return token;
  }

  /// `GET /user/details` → the signed-in user's own profile.
  Future<UserProfile> fetchProfile() async {
    final body = await _client.get('/user/details');
    final user = body['user'];
    if (user is! Map<String, dynamic>) {
      throw const ApiException(statusCode: 500);
    }
    return UserProfile.fromJson(user);
  }

  /// `POST /password/forgot`: always 200, whether or not the email exists.
  Future<void> requestPasswordReset(String email) =>
      _client.post('/password/forgot', data: {'email': email}, auth: false);

  /// `POST /password/reset` with the 6-digit code from the email.
  Future<void> resetPassword({
    required String email,
    required String code,
    required String password,
  }) => _client.post(
    '/password/reset',
    data: {
      'email': email,
      'code': code,
      'password': password,
      'confirmPassword': password,
    },
    auth: false,
  );
}
