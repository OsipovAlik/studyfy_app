import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:studify/features/auth/data/session_storage.dart';
import 'package:studify/features/auth/domain/user_profile.dart';

import 'support/fakes.dart';

Finder _field(String label) => find.widgetWithText(TextFormField, label);

Future<void> _signIn(
  WidgetTester tester, {
  String email = 'tina@example.com',
  String password = 'Password1',
}) async {
  await tester.enterText(_field('Email'), email);
  await tester.enterText(_field('Password'), password);
  await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
  await settle(tester);
}

void main() {
  testWidgets('signing in opens the home screen', (tester) async {
    final app = await TestApp.create();
    app.api
      ..on('POST /login', [
        const FakeResponse(200, {'token': 'tok'}),
      ])
      ..on('GET /user/details', [
        const FakeResponse(200, {'user': teacherJson}),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await openLogin(tester);

    await _signIn(tester);

    expect(find.text('Welcome back, Tina'), findsOneWidget);
    expect(find.text('Teacher'), findsOneWidget);
    expect(find.text('Acme Language School'), findsOneWidget);
    expect(app.storage.session?.token, 'tok');
  });

  testWidgets('form checks email and password before calling the API', (
    tester,
  ) async {
    final app = await TestApp.create();
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await openLogin(tester);

    await _signIn(tester, email: 'not-an-email', password: '');

    expect(find.text('Enter a valid email address.'), findsOneWidget);
    expect(find.text('Enter your password.'), findsOneWidget);
    expect(app.api.requests, isEmpty);
  });

  testWidgets('wrong password shows an error and stays on login', (
    tester,
  ) async {
    final app = await TestApp.create();
    app.api.on('POST /login', [
      const FakeResponse(401, {'message': 'Invalid email or password'}),
    ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await openLogin(tester);

    await _signIn(tester);

    expect(find.text('Incorrect email or password.'), findsOneWidget);
    expect(find.text('Welcome back 👋'), findsOneWidget);
  });

  testWidgets('a locked account counts down and offers a reset', (
    tester,
  ) async {
    final app = await TestApp.create();
    app.api.on('POST /login', [
      const FakeResponse(429, {'message': 'locked'}, {'retry-after': '90'}),
    ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await openLogin(tester);

    await _signIn(tester);

    expect(find.text('Too many attempts. Please try again later.'), findsOne);
    // 90 s from the Retry-After header, shown on the banner and button.
    expect(find.textContaining('Try again in 1:2'), findsNWidgets(2));
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);

    await tester.pump(const Duration(seconds: 30));
    expect(find.textContaining('Try again in 0:5'), findsNWidgets(2));

    await tester.tap(find.text('Reset your password'));
    await settle(tester);
    expect(find.text('Send code'), findsOneWidget);
    // The email is carried over.
    expect(find.text('tina@example.com'), findsOneWidget);
  });

  testWidgets('admin accounts get an explanation', (tester) async {
    final app = await TestApp.create();
    app.api
      ..on('POST /login', [
        const FakeResponse(200, {'token': 'tok'}),
      ])
      ..on('GET /user/details', [
        const FakeResponse(200, {'user': adminJson}),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await openLogin(tester);

    await _signIn(tester);

    expect(
      find.textContaining('Administrator accounts are managed'),
      findsOneWidget,
    );
    expect(app.storage.session, isNull);
  });

  testWidgets('password reset in two steps, back to login', (tester) async {
    final app = await TestApp.create();
    app.api
      ..on('POST /password/forgot', [
        const FakeResponse(200, {'message': 'sent'}),
      ])
      ..on('POST /password/reset', [
        const FakeResponse(400, {
          'message': 'The code is incorrect or has expired.',
        }),
        const FakeResponse(200, {'message': 'Password reset'}),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await openLogin(tester);

    await tester.tap(find.text('Forgot?'));
    await settle(tester);
    await tester.enterText(_field('Email'), 'tina@example.com');
    await tester.tap(find.text('Send code'));
    await settle(tester);

    expect(find.text('Enter the code'), findsOneWidget);
    expect(find.text('Send a new code (59s)'), findsOneWidget);

    // Client-side checks first.
    await tester.enterText(_field('Code from the email'), '12a');
    await tester.enterText(_field('New password'), 'short');
    await tester.enterText(_field('Confirm new password'), 'other');
    await tester.ensureVisible(find.text('Reset password'));
    await tester.tap(find.text('Reset password'));
    await settle(tester);
    expect(find.text('Enter the 6-digit code from the email.'), findsOneWidget);
    expect(find.text("Passwords don't match."), findsOneWidget);
    expect(app.api.requestsTo('POST /password/reset'), isEmpty);

    // A wrong code is reported by the API.
    await tester.enterText(_field('Code from the email'), '123456');
    await tester.enterText(_field('New password'), 'NewPass1!');
    await tester.enterText(_field('Confirm new password'), 'NewPass1!');
    await tester.ensureVisible(find.text('Reset password'));
    await tester.tap(find.text('Reset password'));
    await settle(tester);
    expect(find.textContaining('The code is incorrect'), findsOneWidget);

    // The right code resets and returns to login with the email filled in.
    await tester.ensureVisible(find.text('Reset password'));
    await tester.tap(find.text('Reset password'));
    await settle(tester);

    final reset = app.api.requestsTo('POST /password/reset').last;
    expect(app.api.bodyOf(reset), {
      'email': 'tina@example.com',
      'code': '123456',
      'password': 'NewPass1!',
      'confirmPassword': 'NewPass1!',
    });
    expect(find.text('Password reset. Log in with the new one.'), findsOne);
    expect(find.text('tina@example.com'), findsOneWidget);
  });

  testWidgets('reset opened directly still ends on login with the notice', (
    tester,
  ) async {
    final app = await TestApp.create();
    app.api
      ..on('POST /password/forgot', [const FakeResponse(200)])
      ..on('POST /password/reset', [const FakeResponse(200)]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await openLogin(tester);

    // Like a deep link: the reset screen with nothing underneath.
    GoRouter.of(
      tester.element(find.byType(Scaffold).first),
    ).go('/forgot-password?email=tina%40example.com');
    await settle(tester);
    await tester.tap(find.text('Send code'));
    await settle(tester);
    await tester.enterText(_field('Code from the email'), '654321');
    await tester.enterText(_field('New password'), 'NewPass1!');
    await tester.enterText(_field('Confirm new password'), 'NewPass1!');
    await tester.ensureVisible(find.text('Reset password'));
    await tester.tap(find.text('Reset password'));
    await settle(tester);

    expect(find.text('Password reset. Log in with the new one.'), findsOne);
    expect(find.text('tina@example.com'), findsOneWidget);
  });

  testWidgets('saved session opens home; expired token returns to login', (
    tester,
  ) async {
    final app = await TestApp.create(
      session: const StoredSession(
        token: 'saved',
        user: UserProfile(
          id: 3,
          name: 'Tina',
          email: 'tina@example.com',
          role: UserRole.teacher,
        ),
      ),
    );
    app.api.on('GET /user/details', [
      const FakeResponse(401, {'message': 'Not authorized'}),
    ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    expect(find.text('Welcome back, Tina'), findsOneWidget);

    unawaited(app.dependencies.auth.refreshProfile());
    await settle(tester);

    expect(
      find.text('Your session has ended. Please sign in again.'),
      findsOneWidget,
    );
    expect(find.text('tina@example.com'), findsOneWidget);
    expect(app.storage.session, isNull);
  });

  testWidgets('log out asks first, then returns to login', (tester) async {
    final app = await TestApp.create(
      session: StoredSession(
        token: 'saved',
        user: UserProfile.fromJson(teacherJson),
      ),
    );
    await tester.pumpWidget(app.widget);
    await settle(tester);

    await tester.tap(find.byTooltip('Log out'));
    await settle(tester);
    expect(find.text('Log out of Studyfy?'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Log out'));
    await settle(tester);

    expect(find.text('Welcome back 👋'), findsOneWidget);
    expect(app.storage.session, isNull);
  });
}
