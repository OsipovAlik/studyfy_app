import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:studify/core/config/app_config.dart';
import 'package:studify/core/network/api_exception.dart';

/// Thin wrapper around [Dio] for the Studyfy REST API.
///
/// Every request either returns the decoded JSON body or throws an
/// [ApiException]. Authenticated requests carry the token from
/// [tokenProvider]; when one of them gets a `401`, [onUnauthorized] is
/// called so the session can be closed.
class ApiClient {
  ApiClient({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: AppConfig.apiBaseUrl,
              connectTimeout: const Duration(seconds: 15),
              receiveTimeout: const Duration(seconds: 30),
              contentType: Headers.jsonContentType,
            ),
          ) {
    _dio.interceptors.add(
      InterceptorsWrapper(onRequest: _addToken, onError: _reportUnauthorized),
    );
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(requestBody: true, maxWidth: 100),
      );
    }
  }

  static const _authKey = 'auth';
  static const _sentTokenKey = 'sentToken';

  final Dio _dio;

  /// Returns the current token, or null when signed out.
  String? Function() tokenProvider = () => null;

  /// Called with the error of an authenticated request that got a `401`.
  void Function(ApiException error)? onUnauthorized;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
    bool auth = true,
  }) => _send('GET', path, query: query, auth: auth);

  Future<Map<String, dynamic>> post(
    String path, {
    Object? data,
    bool auth = true,
    Duration? receiveTimeout,
  }) => _send(
    'POST',
    path,
    data: data,
    auth: auth,
    receiveTimeout: receiveTimeout,
  );

  Future<Map<String, dynamic>> put(
    String path, {
    Object? data,
    bool auth = true,
  }) => _send('PUT', path, data: data, auth: auth);

  Future<Map<String, dynamic>> patch(
    String path, {
    Object? data,
    bool auth = true,
  }) => _send('PATCH', path, data: data, auth: auth);

  Future<Map<String, dynamic>> delete(
    String path, {
    Object? data,
    bool auth = true,
  }) => _send('DELETE', path, data: data, auth: auth);

  Future<Map<String, dynamic>> _send(
    String method,
    String path, {
    required bool auth,
    Object? data,
    Map<String, dynamic>? query,
    Duration? receiveTimeout,
  }) async {
    try {
      final response = await _dio.request<Object?>(
        path,
        data: data,
        queryParameters: query,
        options: Options(
          method: method,
          extra: {_authKey: auth},
          receiveTimeout: receiveTimeout,
        ),
      );
      final body = response.data;
      return body is Map<String, dynamic> ? body : const {};
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  void _addToken(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (options.extra[_authKey] != false) {
      final token = tokenProvider();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
        options.extra[_sentTokenKey] = token;
      }
    }
    handler.next(options);
  }

  void _reportUnauthorized(
    DioException error,
    ErrorInterceptorHandler handler,
  ) {
    final sentToken = error.requestOptions.extra[_sentTokenKey];
    // Ignore answers to requests made with an older token, e.g. one that
    // was replaced after a password change while the request was running.
    if (error.response?.statusCode == 401 &&
        sentToken != null &&
        sentToken == tokenProvider()) {
      onUnauthorized?.call(ApiException.fromDio(error));
    }
    handler.next(error);
  }
}
