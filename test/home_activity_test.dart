import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studify/features/auth/data/session_storage.dart';
import 'package:studify/features/auth/domain/user_profile.dart';

import 'support/fakes.dart';

StoredSession _session(Map<String, Object?> json) =>
    StoredSession(token: 'tok', user: UserProfile.fromJson(json));

/// The activity card sits at the bottom of Home's list, below the
/// default test viewport's scroll cache extent, so it isn't kept
/// mounted until scrolled into view.
Future<void> _revealActivityCard(WidgetTester tester) async {
  await tester.drag(find.byType(ListView), const Offset(0, -600));
  await settle(tester);
}

void main() {
  // Matches the mock: "today" is Friday 2026-10-16, this week running
  // from Saturday 2026-10-10.
  final friday = Clock.fixed(DateTime(2026, 10, 16, 9));

  testWidgets(
    "the activity card totals this week's attempts and hides older ones",
    (tester) async {
      await withClock(friday, () async {
        final app = await TestApp.create(session: _session(teacherJson));
        app.api.on('GET /result/list', [
          const FakeResponse(200, {
            'results': [
              // Today, in the window.
              {'ID': 1, 'percentage': 40, 'created_at': '2026-10-16T08:00:00Z'},
              // Tuesday, in the window.
              {'ID': 2, 'percentage': 60, 'created_at': '2026-10-13T08:00:00Z'},
              // Before the window: excluded from every figure below.
              {
                'ID': 3,
                'percentage': 100,
                'created_at': '2026-10-01T08:00:00Z',
              },
            ],
          }),
        ]);
        await tester.pumpWidget(app.widget);
        await settle(tester);
        await _revealActivityCard(tester);

        expect(find.text("This week's activity"), findsOneWidget);
        expect(
          find.descendant(
            of: find.byKey(const ValueKey('activity-attempts')),
            matching: find.text('2'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byKey(const ValueKey('activity-average')),
            matching: find.text('50%'), // (40 + 60) / 2
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byKey(const ValueKey('activity-best')),
            matching: find.text('60%'),
          ),
          findsOneWidget,
        );
        expect(find.text('1 attempts'), findsOneWidget); // today's badge

        // Today's column is labelled Fri / 16.
        expect(find.text('Fri'), findsOneWidget);
        expect(find.text('16'), findsOneWidget);
      });
    },
  );

  testWidgets('no attempts this week shows the empty state', (tester) async {
    await withClock(friday, () async {
      final app = await TestApp.create(session: _session(teacherJson));
      app.api.on('GET /result/list', [
        const FakeResponse(200, {'results': <Object?>[]}),
      ]);
      await tester.pumpWidget(app.widget);
      await settle(tester);
      await _revealActivityCard(tester);

      expect(find.text('No attempts yet this week.'), findsOneWidget);
    });
  });
}
