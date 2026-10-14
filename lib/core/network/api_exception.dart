import 'package:dio/dio.dart';

/// A failed API call, reduced to what the UI needs.
///
/// The API answers errors as `{"message": "..."}` (a few use `"error"`).
/// [statusCode] is null when the server could not be reached at all.
class ApiException implements Exception {
  const ApiException({
    this.statusCode,
    this.message,
    this.code,
    this.retryAfter,
  });

  factory ApiException.fromDio(DioException error) {
    final response = error.response;
    if (response == null) return const ApiException();

    final data = response.data;
    String? message;
    String? code;
    if (data is Map) {
      final value = data['message'] ?? data['error'];
      if (value is String && value.isNotEmpty) message = value;
      final codeValue = data['code'];
      if (codeValue is String && codeValue.isNotEmpty) code = codeValue;
    }

    final retryAfterHeader = response.headers.value('retry-after');
    final retrySeconds = int.tryParse(retryAfterHeader?.trim() ?? '');

    return ApiException(
      statusCode: response.statusCode,
      message: message,
      code: code,
      retryAfter: retrySeconds == null || retrySeconds <= 0
          ? null
          : Duration(seconds: retrySeconds),
    );
  }

  /// Message the API sends when the user's school has been switched off.
  static const schoolInactiveMessage = 'Something went wrong';

  final int? statusCode;
  final String? message;
  final String? code;
  final Duration? retryAfter;

  bool get isNetworkError => statusCode == null;
  bool get isValidation => statusCode == 400;
  bool get isUnauthorized => statusCode == 401;
  bool get isNotFound => statusCode == 404;
  bool get isTooManyRequests => statusCode == 429;
  bool get isServerError => (statusCode ?? 0) >= 500;

  /// The user's school is switched off: the API answers `401 Something
  /// went wrong` (and `403 partner_inactive` in some versions), not the
  /// usual `401 Not authorized`.
  bool get isSchoolInactive =>
      (statusCode == 401 && message == schoolInactiveMessage) ||
      (statusCode == 403 && code == 'partner_inactive');

  @override
  String toString() => 'ApiException($statusCode, $message)';
}
