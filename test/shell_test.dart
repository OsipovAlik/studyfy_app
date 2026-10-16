import 'dart:ui' show Tristate;

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:studify/core/widgets/language_button.dart';
import 'package:studify/features/auth/data/session_storage.dart';
import 'package:studify/features/auth/domain/user_profile.dart';
import 'package:studify/features/shell/glass_nav_bar.dart';

import 'support/fakes.dart';

StoredSession _session(Map<String, Object?> json) =>
    StoredSession(token: 'tok', user: UserProfile.fromJson(json));

const Map<String, Object?> _studentJson = {
  'id': 4,
  'name': 'John',
  'surname': 'Doe',
  'email': 'john@example.com',
  'role': 'student',
  'partnerId': 1,
  'partnerName': 'Acme Language School',
};

Finder _barItem(String label) => find.descendant(
  of: find.byType(GlassNavBar),
  matching: find.text(label),
);

void main() {
  testWidgets('five tabs; tapping one shows its page', (tester) async {
    final app = await TestApp.create(session: _session(_studentJson));
    await tester.pumpWidget(app.widget);
    await settle(tester);

    for (final label in [
      'Home',
      'Subjects',
      'Sessions',
      'My homework',
      'Profile',
    ]) {
      expect(_barItem(label), findsOneWidget);
    }
    // Starts on Home, an empty page for now.
    final router = GoRouter.of(tester.element(find.byType(GlassNavBar)));
    expect(router.state.matchedLocation, '/home');

    await tester.tap(_barItem('Subjects'));
    await settle(tester);
    expect(router.state.matchedLocation, '/subjects');

    await tester.tap(_barItem('Sessions'));
    await settle(tester);
    expect(router.state.matchedLocation, '/sessions');

    await tester.tap(_barItem('My homework'));
    await settle(tester);
    expect(router.state.matchedLocation, '/homework');

    await tester.tap(_barItem('Profile'));
    await settle(tester);
    expect(find.text('Welcome back, John'), findsOneWidget);
    expect(find.text('john@example.com'), findsOneWidget);

    final selected = tester.getSemantics(
      find
          .ancestor(of: _barItem('Profile'), matching: find.byType(Semantics))
          .first,
    );
    expect(selected.flagsCollection.isSelected, Tristate.isTrue);
  });

  testWidgets('Home shows the welcome banner with the school', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(_studentJson));
    await tester.pumpWidget(app.widget);
    await settle(tester);

    expect(find.text('Welcome back, John 👋'), findsOneWidget);
    expect(
      find.text('Another week of amazing progress. Keep going!'),
      findsOneWidget,
    );
    expect(find.text('Acme Language School'), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
  });

  testWidgets('teachers see "Homework" instead of "My homework"', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(teacherJson));
    await tester.pumpWidget(app.widget);
    await settle(tester);

    expect(_barItem('Homework'), findsOneWidget);
    expect(_barItem('My homework'), findsNothing);
  });

  testWidgets('only a teacher sees the Students tab', (tester) async {
    final app = await TestApp.create(session: _session(_studentJson));
    await tester.pumpWidget(app.widget);
    await settle(tester);
    expect(_barItem('Students'), findsNothing);
  });

  testWidgets('a teacher opens Students and sees the roster', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api.on('GET /students', [
      const FakeResponse(200, {
        'users': [
          {
            'ID': 4,
            'name': 'John',
            'surname': 'Doe',
            'email': 'john@example.com',
            'role': 'student',
          },
          {
            'ID': 3,
            'name': 'Tina',
            'surname': 'Teach',
            'email': 'tina@example.com',
            'role': 'teacher',
          },
        ],
      }),
    ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);

    expect(_barItem('Students'), findsOneWidget);
    await tester.tap(_barItem('Students'));
    await settle(tester);

    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('john@example.com'), findsOneWidget);
    // The teacher in the same response is filtered out.
    expect(find.text('Tina Teach'), findsNothing);
  });

  testWidgets('a student is bounced home from the Students route', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(_studentJson));
    await tester.pumpWidget(app.widget);
    await settle(tester);

    GoRouter.of(tester.element(find.byType(GlassNavBar))).go('/students');
    await settle(tester);

    final router = GoRouter.of(tester.element(find.byType(GlassNavBar)));
    expect(router.state.matchedLocation, '/home');
  });

  testWidgets('page content stays clear of the floating bar', (tester) async {
    final app = await TestApp.create(session: _session(_studentJson));
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await tester.tap(_barItem('Profile'));
    await settle(tester);

    // Scroll to the end: the last item must end above the bar.
    await tester.drag(find.byType(ListView), const Offset(0, -2000));
    await settle(tester);
    final logOut = tester.getRect(
      find.widgetWithText(OutlinedButton, 'Log out'),
    );
    final bar = tester.getRect(
      find.descendant(
        of: find.byType(GlassNavBar),
        matching: find.byType(ClipRRect),
      ),
    );
    expect(logOut.bottom, lessThanOrEqualTo(bar.top));
  });

  testWidgets('Settings changes the theme and the language, and saves them', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(_studentJson));
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await tester.tap(_barItem('Profile'));
    await settle(tester);

    // The language moved from the Profile header into Settings.
    expect(find.byType(LanguageButton), findsNothing);
    await tester.tap(find.text('Settings'));
    await settle(tester);

    ThemeMode themeMode() =>
        tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode!;
    expect(themeMode(), ThemeMode.system);
    await tester.ensureVisible(find.text('Dark'));
    await settle(tester);
    await tester.tap(find.text('Dark'));
    await settle(tester);
    expect(themeMode(), ThemeMode.dark);
    expect(app.dependencies.preferences.themeMode, 'dark');
    expect(
      Theme.of(tester.element(find.text('Dark'))).brightness,
      Brightness.dark,
    );

    await tester.ensureVisible(find.text('Français'));
    await settle(tester);
    await tester.tap(find.text('Français'));
    await settle(tester);
    expect(find.text('Paramètres', skipOffstage: false), findsWidgets);
    expect(find.text('Sombre', skipOffstage: false), findsOneWidget);
    expect(app.dependencies.preferences.languageCode, 'fr');

    // Back to the Profile page.
    await tester.tap(find.byIcon(CupertinoIcons.back));
    await settle(tester);
    expect(find.text('Paramètres'), findsOneWidget);
    expect(find.byIcon(CupertinoIcons.back), findsNothing);
  });

  testWidgets('a saved theme is used on launch', (tester) async {
    final app = await TestApp.create(
      prefs: {'theme_mode': 'light'},
      session: _session(_studentJson),
    );
    await tester.pumpWidget(app.widget);
    await settle(tester);
    expect(
      tester.widget<MaterialApp>(find.byType(MaterialApp)).themeMode,
      ThemeMode.light,
    );
  });

  for (final title in ['Privacy policy', 'Terms of use']) {
    testWidgets('Profile opens "$title"', (tester) async {
      final app = await TestApp.create(session: _session(_studentJson));
      await tester.pumpWidget(app.widget);
      await settle(tester);
      await tester.tap(_barItem('Profile'));
      await settle(tester);

      await tester.tap(find.text(title));
      await settle(tester);
      expect(find.text(title), findsOneWidget);
      expect(find.text('Welcome back, John'), findsNothing);
      // The tab bar stays.
      expect(_barItem('Profile'), findsOneWidget);

      await tester.tap(find.byIcon(CupertinoIcons.back));
      await settle(tester);
      expect(find.text('Welcome back, John'), findsOneWidget);
    });
  }

  for (final code in ['hy', 'en', 'fr', 'ru']) {
    testWidgets('bar labels fit a small phone in "$code"', (tester) async {
      tester.view.physicalSize = const Size(320, 640);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final app = await TestApp.create(
        prefs: {'language_code': code},
        session: _session(teacherJson),
      );
      await tester.pumpWidget(app.widget);
      await settle(tester);

      // A teacher sees all 6 tabs, Students included.
      final itemCount = tester
          .widgetList(
            find.descendant(
              of: find.byType(GlassNavBar),
              matching: find.byType(InkResponse),
            ),
          )
          .length;
      expect(itemCount, 6);
      for (var i = 0; i < itemCount; i++) {
        await tester.tap(
          find
              .descendant(
                of: find.byType(GlassNavBar),
                matching: find.byType(InkResponse),
              )
              .at(i),
        );
        await settle(tester);
      }
      // Any overflow would have failed the test already.
      expect(find.byType(GlassNavBar), findsOneWidget);
    });
  }
}
