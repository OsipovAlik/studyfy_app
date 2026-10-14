import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/fakes.dart';

void main() {
  testWidgets('first launch shows onboarding; Sign in leads to login', (
    tester,
  ) async {
    final app = await TestApp.create(prefs: {});
    await tester.pumpWidget(app.widget);
    await settle(tester);

    expect(find.text('Built for language schools'), findsOneWidget);
    expect(find.text('Sign in'), findsNothing);

    await tester.tap(find.text('Skip'));
    await settle(tester);

    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Registration'), findsOneWidget);

    await tester.tap(find.text('Sign in'));
    await settle(tester);

    expect(find.text('Welcome back 👋'), findsOneWidget);
  });

  testWidgets('Registration opens the contact form', (tester) async {
    final app = await TestApp.create(prefs: {});
    await tester.pumpWidget(app.widget);
    await settle(tester);

    await tester.tap(find.text('Skip'));
    await settle(tester);
    await tester.tap(find.text('Registration'));
    await settle(tester);

    expect(find.text('Get in touch'), findsOneWidget);

    await tester.tap(find.text('Send request'));
    await tester.pump();

    expect(find.text('Enter a valid email address.'), findsOneWidget);
    expect(
      find.text('Enter a valid phone number (e.g. +374 55 123456).'),
      findsOneWidget,
    );
  });

  for (final code in ['hy', 'en', 'fr', 'ru']) {
    testWidgets('all slides fit a small phone in "$code"', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final app = await TestApp.create(prefs: {'language_code': code});
      await tester.pumpWidget(app.widget);
      await settle(tester);

      for (var page = 0; page < 3; page++) {
        await tester.tap(find.byType(FilledButton));
        await settle(tester);
      }
      // Last slide: Sign in + Registration.
      expect(find.byType(OutlinedButton), findsOneWidget);
    });
  }

  testWidgets('every signed-out launch starts with onboarding', (tester) async {
    // Even after the user has been through it and opened login before.
    final app = await TestApp.create(prefs: {'onboarding_seen': true});
    await tester.pumpWidget(app.widget);
    await settle(tester);

    expect(find.byType(PageView), findsOneWidget);
    expect(find.text('Built for language schools'), findsOneWidget);
  });
}
