import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studify/features/auth/data/session_storage.dart';
import 'package:studify/features/auth/domain/user_profile.dart';

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

const List<Object?> _sessions = [
  {
    'ID': 1,
    'type': 'individual',
    'dayOfWeek': 'thursday',
    'startTime': '15:00',
  },
  {
    'ID': 2,
    'type': 'group',
    'dayOfWeek': 'monday',
    'startTime': '09:00',
    'groupId': 7,
  },
];

void main() {
  // Thursday 2026-10-15, 09:00: this week runs Mon 10/12 – Sun 10/18.
  final thursdayMorning = Clock.fixed(DateTime(2026, 10, 15, 9));

  testWidgets("Home shows the next session and this week's days", (
    tester,
  ) async {
    await withClock(thursdayMorning, () async {
      final app = await TestApp.create(session: _session(_studentJson));
      app.api.on('GET /session/my', [
        const FakeResponse(200, {'sessions': _sessions}),
      ]);
      await tester.pumpWidget(app.widget);
      await settle(tester);

      expect(find.text('Next session'), findsOneWidget);
      expect(find.textContaining('Thursday · 15:00'), findsOneWidget);
      expect(find.text('Join call'), findsOneWidget);

      // Several of the 7 day cards have no sessions (the strip scrolls,
      // so not every card is necessarily built).
      expect(find.text('No sessions'), findsWidgets);
      // Today is Thursday the 15th.
      expect(find.text('Today'), findsOneWidget);
    });
  });

  testWidgets('Home shows an empty state with no sessions at all', (
    tester,
  ) async {
    await withClock(thursdayMorning, () async {
      final app = await TestApp.create(session: _session(_studentJson));
      await tester.pumpWidget(app.widget);
      await settle(tester);

      expect(find.text('No sessions yet'), findsOneWidget);
      expect(find.text('Next session'), findsNothing);
    });
  });

  testWidgets('Sessions tab groups this week by day', (
    tester,
  ) async {
    await withClock(thursdayMorning, () async {
      final app = await TestApp.create(session: _session(_studentJson));
      app.api.on('GET /session/my', [
        const FakeResponse(200, {'sessions': _sessions}),
      ]);
      await tester.pumpWidget(app.widget);
      await settle(tester);

      await tester.tap(find.text('Sessions'));
      await settle(tester);

      expect(find.text('Monday'), findsOneWidget);
      expect(find.text('Thursday'), findsOneWidget);
      // A student sees the type, not a numbered id, shown twice per row
      // (the name slot, with nothing resolved, repeats the type below it).
      expect(find.text('Group'), findsNWidgets(2));
      expect(find.text('Individual'), findsNWidgets(2));
      expect(find.byTooltip('Join call'), findsNWidgets(2));
    });
  });

  testWidgets('the type filter narrows the list to one day', (tester) async {
    await withClock(thursdayMorning, () async {
      final app = await TestApp.create(session: _session(_studentJson));
      app.api.on('GET /session/my', [
        const FakeResponse(200, {'sessions': _sessions}),
      ]);
      await tester.pumpWidget(app.widget);
      await settle(tester);
      await tester.tap(find.text('Sessions'));
      await settle(tester);

      expect(find.text('Monday'), findsOneWidget);
      expect(find.text('Thursday'), findsOneWidget);

      await tester.tap(find.text('All types'));
      await settle(tester);
      await tester.tap(find.text('Group').last);
      await settle(tester);

      // Only Monday has a group session; Thursday's individual one is
      // filtered out.
      expect(find.text('Monday'), findsOneWidget);
      expect(find.text('Thursday'), findsNothing);
    });
  });

  testWidgets('the Groups tab lists groups with their member count', (
    tester,
  ) async {
    await withClock(thursdayMorning, () async {
      final app = await TestApp.create(session: _session(teacherJson));
      app.api.on('GET /group/list', [
        const FakeResponse(200, {
          'groups': [
            {'ID': 7, 'name': 'Beginners A1', 'memberCount': 5},
            {'ID': 8, 'name': 'Advanced C1', 'memberCount': 3},
          ],
        }),
      ]);
      await tester.pumpWidget(app.widget);
      await settle(tester);
      await tapNavTab(tester, 'Sessions');

      await tester.tap(find.text('Groups'));
      await settle(tester);

      expect(find.text('Beginners A1'), findsOneWidget);
      expect(find.text('5 members'), findsOneWidget);
      expect(find.text('Advanced C1'), findsOneWidget);
      expect(find.text('3 members'), findsOneWidget);
    });
  });

  testWidgets('a teacher sees resolved group and student names', (
    tester,
  ) async {
    await withClock(thursdayMorning, () async {
      final app = await TestApp.create(session: _session(teacherJson));
      app.api
        ..on('GET /session/list', [
          const FakeResponse(200, {
            'sessions': [
              {
                'ID': 1,
                'type': 'group',
                'dayOfWeek': 'thursday',
                'startTime': '15:00',
                'groupId': 7,
              },
            ],
          }),
        ])
        ..on('GET /group/list', [
          const FakeResponse(200, {
            'groups': [
              {'ID': 7, 'name': 'Beginners A1'},
            ],
          }),
        ]);
      await tester.pumpWidget(app.widget);
      await settle(tester);

      expect(find.textContaining('Beginners A1'), findsWidgets);
    });
  });
}
