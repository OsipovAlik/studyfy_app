import 'package:clock/clock.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/widgets.dart';
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

void main() {
  // Thursday of the week of Mon 2026-10-12.
  final thisWeek = Clock.fixed(DateTime(2026, 10, 15, 9));

  void stubCounts(FakeApi api) {
    api
      ..on('GET /subject/list', [
        const FakeResponse(200, {
          'subjects': [
            {'ID': 1, 'name': 'English', 'created_at': '2026-09-01T10:00:00Z'},
          ],
        }),
      ])
      ..on('GET /students', [
        const FakeResponse(200, {
          'users': [
            {
              'ID': 4,
              'name': 'Anna',
              'surname': 'K.',
              'email': 'a@b.c',
              'role': 'student',
              'created_at': '2026-10-13T09:00:00Z', // this week
            },
            {
              'ID': 5,
              'name': 'Bob',
              'surname': 'B.',
              'email': 'b@b.c',
              'role': 'student',
              'created_at': '2026-09-01T09:00:00Z', // before
            },
          ],
        }),
      ])
      ..on('GET /group/list', [
        const FakeResponse(200, {
          'groups': [
            {
              'ID': 7,
              'name': 'Beginners A1',
              'memberCount': 2,
              'created_at': '2026-10-14T09:00:00Z', // this week
            },
          ],
        }),
      ])
      ..on('GET /session/list', [
        const FakeResponse(200, {
          'sessions': [
            {
              'ID': 9,
              'type': 'group',
              'dayOfWeek': 'tuesday',
              'startTime': '10:00',
              'groupId': 7,
              'created_at': '2026-09-01T09:00:00Z', // before
            },
          ],
        }),
      ]);
  }

  testWidgets(
    "a teacher sees this week's overview grid, with a delta only where something is new",
    (tester) async {
      await withClock(thisWeek, () async {
        final app = await TestApp.create(session: _session(teacherJson));
        stubCounts(app.api);
        await tester.pumpWidget(app.widget);
        await settle(tester);

        // Four tappable tiles.
        expect(
          find.byIcon(CupertinoIcons.chevron_right),
          findsNWidgets(4),
        );

        // Totals: 1 subject, 2 students, 1 group, 1 session.
        expect(
          find.descendant(
            of: find.byKey(const ValueKey('home-stat-subjects')),
            matching: find.text('1'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byKey(const ValueKey('home-stat-students')),
            matching: find.text('2'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byKey(const ValueKey('home-stat-groups')),
            matching: find.text('1'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byKey(const ValueKey('home-stat-sessions')),
            matching: find.text('1'),
          ),
          findsOneWidget,
        );

        // Only the student and the group were created since Monday; the
        // subject and the session both predate this week, so no badge.
        expect(
          find.descendant(
            of: find.byKey(const ValueKey('home-stat-students')),
            matching: find.text('+1 this week'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byKey(const ValueKey('home-stat-groups')),
            matching: find.text('+1 this week'),
          ),
          findsOneWidget,
        );
        expect(
          find.descendant(
            of: find.byKey(const ValueKey('home-stat-subjects')),
            matching: find.textContaining('this week'),
          ),
          findsNothing,
        );
        expect(
          find.descendant(
            of: find.byKey(const ValueKey('home-stat-sessions')),
            matching: find.textContaining('this week'),
          ),
          findsNothing,
        );
      });
    },
  );

  testWidgets('tapping the Students tile opens the Students tab', (
    tester,
  ) async {
    await withClock(thisWeek, () async {
      final app = await TestApp.create(session: _session(teacherJson));
      stubCounts(app.api);
      await tester.pumpWidget(app.widget);
      await settle(tester);

      await tester.tap(find.byKey(const ValueKey('home-stat-students')));
      await settle(tester);

      expect(find.text('Students of your partner.'), findsOneWidget);
    });
  });

  testWidgets('a student does not see the overview grid', (tester) async {
    final app = await TestApp.create(session: _session(_studentJson));
    await tester.pumpWidget(app.widget);
    await settle(tester);

    expect(find.byIcon(CupertinoIcons.chevron_right), findsNothing);
  });
}
