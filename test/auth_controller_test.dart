import 'package:flutter_test/flutter_test.dart';
import 'package:studify/features/auth/auth_controller.dart';
import 'package:studify/features/auth/data/auth_repository.dart';
import 'package:studify/features/auth/data/session_storage.dart';
import 'package:studify/features/auth/domain/user_profile.dart';

import 'support/fakes.dart';

void main() {
  late FakeApi api;
  late MemorySessionStorage storage;

  AuthController controller({StoredSession? restored}) {
    final client = fakeClient(api);
    return AuthController(
      client: client,
      repository: AuthRepository(client),
      storage: storage,
      restored: restored,
    );
  }

  Future<SignInFailure> failureOf(AuthController auth) async {
    try {
      await auth.signIn(email: 'a@b.co', password: 'Password1', remember: true);
    } on SignInFailure catch (failure) {
      return failure;
    }
    fail('signIn should have failed');
  }

  setUp(() {
    api = FakeApi();
    storage = MemorySessionStorage();
  });

  group('signIn', () {
    test('stores the session and sends the token', () async {
      api
        ..on('POST /login', [
          const FakeResponse(200, {'message': 'ok', 'token': 'tok-1'}),
        ])
        ..on('GET /user/details', [
          const FakeResponse(200, {'user': teacherJson}),
        ]);
      final auth = controller();

      await auth.signIn(
        email: 'tina@example.com',
        password: 'Password1',
        remember: true,
      );

      expect(auth.isSignedIn, isTrue);
      expect(auth.user!.role, UserRole.teacher);
      expect(auth.user!.partnerName, 'Acme Language School');
      expect(storage.session!.token, 'tok-1');

      final login = api.requestsTo('POST /login').single;
      expect(login.headers['Authorization'], isNull);
      expect(api.bodyOf(login), {
        'email': 'tina@example.com',
        'password': 'Password1',
      });
      final details = api.requestsTo('GET /user/details').single;
      expect(details.headers['Authorization'], 'Bearer tok-1');
    });

    test('without "keep me signed in" nothing is stored', () async {
      storage.session = const StoredSession(
        token: 'old',
        user: UserProfile(
          id: 9,
          name: 'Old',
          email: 'o@b.co',
          role: UserRole.student,
        ),
      );
      api
        ..on('POST /login', [
          const FakeResponse(200, {'token': 'tok-2'}),
        ])
        ..on('GET /user/details', [
          const FakeResponse(200, {'user': teacherJson}),
        ]);
      final auth = controller();

      await auth.signIn(
        email: 'a@b.co',
        password: 'Password1',
        remember: false,
      );

      expect(auth.isSignedIn, isTrue);
      expect(storage.session, isNull);
    });

    test('401 wrong password → InvalidCredentials', () async {
      api.on('POST /login', [
        const FakeResponse(401, {'message': 'Invalid email or password'}),
      ]);
      final auth = controller();
      expect(await failureOf(auth), isA<InvalidCredentials>());
      expect(auth.isSignedIn, isFalse);
    });

    test('400 rejected input → InvalidCredentials', () async {
      api.on('POST /login', [
        const FakeResponse(400, {
          'message':
              'password must be at least 8 characters and meet complexity '
              'requirements',
        }),
      ]);
      expect(await failureOf(controller()), isA<InvalidCredentials>());
    });

    test('429 uses the Retry-After header', () async {
      api.on('POST /login', [
        const FakeResponse(
          429,
          {'message': 'Too many'},
          {'retry-after': '754'},
        ),
      ]);
      final failure = await failureOf(controller());
      expect(
        (failure as TooManyAttempts).retryAfter,
        const Duration(seconds: 754),
      );
    });

    test('429 without Retry-After waits 60 s', () async {
      api.on('POST /login', [const FakeResponse(429)]);
      final failure = await failureOf(controller());
      expect(
        (failure as TooManyAttempts).retryAfter,
        AuthController.defaultLockout,
      );
    });

    test('server error and no network → ServiceUnavailable', () async {
      api.on('POST /login', [const FakeResponse(500)]);
      expect(await failureOf(controller()), isA<ServiceUnavailable>());

      api.on('POST /login', [const FakeResponse.offline()]);
      expect(await failureOf(controller()), isA<ServiceUnavailable>());
    });

    test('school switched off at login → SchoolInactive', () async {
      api.on('POST /login', [
        const FakeResponse(401, {'message': 'Something went wrong'}),
      ]);
      expect(await failureOf(controller()), isA<SchoolInactive>());

      api.on('POST /login', [
        const FakeResponse(403, {'code': 'partner_inactive'}),
      ]);
      expect(await failureOf(controller()), isA<SchoolInactive>());
    });

    test('school switched off when loading the profile', () async {
      api
        ..on('POST /login', [
          const FakeResponse(200, {'token': 'tok'}),
        ])
        ..on('GET /user/details', [
          const FakeResponse(401, {'message': 'Something went wrong'}),
        ]);
      final auth = controller();
      expect(await failureOf(auth), isA<SchoolInactive>());
      expect(auth.isSignedIn, isFalse);
      expect(storage.session, isNull);
      // Not a session that ended: nothing to tell the login screen.
      expect(auth.takeNotice(), isNull);
    });

    test('admin accounts are refused', () async {
      api
        ..on('POST /login', [
          const FakeResponse(200, {'token': 'tok'}),
        ])
        ..on('GET /user/details', [
          const FakeResponse(200, {'user': adminJson}),
        ]);
      final auth = controller();
      expect(await failureOf(auth), isA<AdminNotSupported>());
      expect(auth.isSignedIn, isFalse);
      expect(storage.session, isNull);
    });
  });

  group('session', () {
    const saved = StoredSession(
      token: 'saved-token',
      user: UserProfile(
        id: 3,
        name: 'Tina',
        email: 'tina@example.com',
        role: UserRole.teacher,
      ),
    );

    test('a saved session starts signed in', () {
      final auth = controller(restored: saved);
      expect(auth.isSignedIn, isTrue);
      expect(auth.user!.name, 'Tina');
    });

    test('an expired token signs out and leaves a notice', () async {
      storage.session = saved;
      api.on('GET /user/details', [
        const FakeResponse(401, {'message': 'Not authorized'}),
      ]);
      final auth = controller(restored: saved);
      var notified = 0;
      auth.addListener(() => notified++);

      await auth.refreshProfile();

      expect(auth.isSignedIn, isFalse);
      expect(storage.session, isNull);
      expect(notified, greaterThan(0));
      final notice = auth.takeNotice()!;
      expect(notice.notice, AuthNotice.sessionExpired);
      expect(notice.email, 'tina@example.com');
      expect(auth.takeNotice(), isNull);
    });

    test('a school switched off mid-session leaves its own notice', () async {
      api.on('GET /user/details', [
        const FakeResponse(401, {'message': 'Something went wrong'}),
      ]);
      final auth = controller(restored: saved);
      await auth.refreshProfile();
      expect(auth.isSignedIn, isFalse);
      expect(auth.takeNotice()!.notice, AuthNotice.schoolInactive);
    });

    test('offline refresh keeps the saved session', () async {
      api.on('GET /user/details', [const FakeResponse.offline()]);
      final auth = controller(restored: saved);
      await auth.refreshProfile();
      expect(auth.isSignedIn, isTrue);
    });

    test('refresh updates the saved profile', () async {
      storage.session = saved;
      api.on('GET /user/details', [
        const FakeResponse(200, {'user': teacherJson}),
      ]);
      final auth = controller(restored: saved);
      await auth.refreshProfile();
      expect(auth.user!.surname, 'Teach');
      expect(storage.session!.user.partnerName, 'Acme Language School');
      expect(storage.session!.token, 'saved-token');
    });

    test('sign out forgets everything', () async {
      storage.session = saved;
      final auth = controller(restored: saved);
      await auth.signOut();
      expect(auth.isSignedIn, isFalse);
      expect(storage.session, isNull);
      expect(auth.takeNotice(), isNull);
    });
  });

  test('profile JSON round-trips through storage', () {
    final user = UserProfile.fromJson(teacherJson);
    final copy = UserProfile.fromJson(user.toJson());
    expect(copy.id, 3);
    expect(copy.fullName, 'Tina Teach');
    expect(copy.role, UserRole.teacher);
    expect(copy.partnerId, 1);
    expect(copy.createdAt, DateTime.utc(2026, 9, 1, 10));
  });
}
