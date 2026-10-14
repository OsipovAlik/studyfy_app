import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:studify/app.dart';
import 'package:studify/core/network/api_client.dart';
import 'package:studify/core/storage/app_preferences.dart';
import 'package:studify/features/auth/data/session_storage.dart';

/// A canned API answer.
class FakeResponse {
  const FakeResponse(this.status, [this.body = const {}, this.headers]);

  /// The server could not be reached.
  const FakeResponse.offline() : status = 0, body = const {}, headers = null;

  final int status;
  final Map<String, dynamic> body;
  final Map<String, String>? headers;
}

/// Answers requests from a table of `"METHOD /path"` → response, and
/// records every request it sees.
class FakeApi implements HttpClientAdapter {
  final Map<String, List<FakeResponse>> _routes = {};
  final List<RequestOptions> requests = [];

  /// Queue [responses] for a route; the last one repeats.
  void on(String route, List<FakeResponse> responses) =>
      _routes[route] = [...responses];

  List<RequestOptions> requestsTo(String route) =>
      requests.where((r) => routeOf(r) == route).toList();

  static String routeOf(RequestOptions options) =>
      '${options.method} ${options.uri.path.replaceFirst('/api/v1', '')}';

  Map<String, dynamic> bodyOf(RequestOptions request) =>
      request.data as Map<String, dynamic>;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final route = routeOf(options);
    final queue = _routes[route];
    if (queue == null || queue.isEmpty) {
      throw StateError('No fake response for $route');
    }
    final response = queue.length > 1 ? queue.removeAt(0) : queue.first;
    if (response.status == 0) {
      throw const SocketException('offline');
    }
    return ResponseBody.fromString(
      jsonEncode(response.body),
      response.status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
        for (final entry in (response.headers ?? {}).entries)
          entry.key: [entry.value],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

/// Session storage kept in memory instead of the Keychain / Keystore.
class MemorySessionStorage extends SessionStorage {
  MemorySessionStorage([this.session]);

  StoredSession? session;

  @override
  Future<StoredSession?> read() async => session;

  @override
  Future<void> write(StoredSession session) async => this.session = session;

  @override
  Future<void> clear() async => session = null;
}

ApiClient fakeClient(FakeApi api) => ApiClient(
  dio: Dio(BaseOptions(baseUrl: 'https://api.test/api/v1'))
    ..httpClientAdapter = api,
);

const Map<String, Object?> teacherJson = {
  'id': 3,
  'name': 'Tina',
  'surname': 'Teach',
  'email': 'tina@example.com',
  'role': 'teacher',
  'partnerId': 1,
  'partnerName': 'Acme Language School',
  'created_at': '2026-09-01T10:00:00Z',
};

const Map<String, Object?> adminJson = {
  'id': 1,
  'name': 'Ada',
  'surname': '',
  'email': 'admin@example.com',
  'role': 'admin',
  'partnerId': null,
  'partnerName': '',
};

/// Everything a widget test needs to start the app.
class TestApp {
  TestApp._(this.api, this.storage, this.dependencies);

  static Future<TestApp> create({
    Map<String, Object> prefs = const {},
    StoredSession? session,
  }) async {
    SharedPreferences.setMockInitialValues(prefs);
    final api = FakeApi();
    final storage = MemorySessionStorage(session);
    final dependencies = await AppDependencies.create(
      preferences: AppPreferences(await SharedPreferences.getInstance()),
      sessionStorage: storage,
      client: fakeClient(api),
    );
    return TestApp._(api, storage, dependencies);
  }

  final FakeApi api;
  final MemorySessionStorage storage;
  final AppDependencies dependencies;

  StudyfyApp get widget => StudyfyApp(dependencies: dependencies);
}

/// Pumps real frames for a while. pumpAndSettle would never return:
/// some headlines animate forever.
Future<void> settle(WidgetTester tester, {int frames = 20}) async {
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 60));
  }
}

/// Signed-out launches start on the onboarding; jump to the login screen.
Future<void> openLogin(WidgetTester tester) async {
  GoRouter.of(tester.element(find.byType(Navigator).first)).go('/login');
  await settle(tester);
}
