import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studify/features/auth/data/session_storage.dart';
import 'package:studify/features/auth/domain/user_profile.dart';
import 'package:studify/features/results/results_screen.dart';

import 'support/fakes.dart';

/// Home stays mounted (just not visible) underneath a route pushed on
/// top of it, so its own "This week's activity" card — percent badges,
/// test titles and all — can still be found by a plain `find.text`.
/// Scope to the screen itself wherever that could collide.
Finder _onResultsScreen(String text) => find.descendant(
  of: find.byType(ResultsScreen),
  matching: find.text(text),
);

StoredSession _session(Map<String, Object?> json) =>
    StoredSession(token: 'tok', user: UserProfile.fromJson(json));

const Map<String, Object?> _studentJson = {
  'id': 7,
  'name': 'Alik',
  'surname': 'Osipov',
  'email': 'alik@example.com',
  'role': 'student',
  'partnerId': 1,
  'partnerName': 'Acme Language School',
};

/// Scrolls Home down to the activity card, then taps "View all" to open
/// the Results screen.
Future<void> _openResults(WidgetTester tester) async {
  await tester.drag(find.byType(ListView), const Offset(0, -600));
  await settle(tester);
  await tester.tap(find.text('View all'));
  await settle(tester);
}

void main() {
  testWidgets(
    'a teacher lists, filters, and opens a result to see its breakdown',
    (tester) async {
      final app = await TestApp.create(session: _session(teacherJson));
      app.api
        ..on('GET /result/list', [
          const FakeResponse(200, {
            'results': [
              {
                'ID': 1,
                'testId': 10,
                'userId': 4,
                'score': 4,
                'total': 10,
                'percentage': 40,
                'timeTakenSeconds': 12,
                'created_at': '2026-10-16T08:00:00Z',
              },
              {
                'ID': 2,
                'testId': 11,
                'userId': 5,
                'score': 9,
                'total': 10,
                'percentage': 90,
                'timeTakenSeconds': 300,
                'created_at': '2026-10-15T08:00:00Z',
              },
            ],
          }),
        ])
        ..on('GET /test/list', [
          const FakeResponse(200, {
            'tests': [
              {'ID': 10, 'title': 'Flutter interview'},
              {'ID': 11, 'title': 'Dart basics'},
            ],
          }),
        ])
        ..on('GET /students', [
          const FakeResponse(200, {
            'users': [
              {
                'ID': 4,
                'name': 'Alik',
                'surname': 'Osipov',
                'email': 'a@b.c',
                'role': 'student',
              },
              {
                'ID': 5,
                'name': 'Mia',
                'surname': 'K.',
                'email': 'm@b.c',
                'role': 'student',
              },
            ],
          }),
        ])
        ..on('GET /result/1', [
          const FakeResponse(200, {
            'result': {
              'ID': 1,
              'testId': 10,
              'userId': 4,
              'score': 4,
              'total': 10,
              'percentage': 40,
              'timeTakenSeconds': 12,
              'created_at': '2026-10-16T08:00:00Z',
              'answers': [
                {
                  'questionId': 1,
                  'question': 'What is 2+2?',
                  'type': 'multiple_choice',
                  'answer': 'a2',
                  'rightAnswer': 'a1',
                  'isCorrect': false,
                },
              ],
            },
          }),
        ])
        ..on('GET /question/list/10', [
          const FakeResponse(200, {
            'data': [
              {
                'ID': 1,
                'testId': 10,
                'question': 'What is 2+2?',
                'type': 'multiple_choice',
                'a1': '4',
                'a2': '5',
                'a3': '',
                'a4': '',
                'rightAnswer': 'a1',
              },
            ],
          }),
        ]);
      await tester.pumpWidget(app.widget);
      await settle(tester);
      await _openResults(tester);

      expect(find.text('Results'), findsOneWidget);
      expect(find.text('Test attempts by your students.'), findsOneWidget);
      expect(_onResultsScreen('Flutter interview'), findsOneWidget);
      expect(_onResultsScreen('Dart basics'), findsOneWidget);

      // Filter to one student: only their result remains.
      await tester.tap(find.text('All students'));
      await settle(tester);
      await tester.tap(find.text('Alik Osipov'));
      await settle(tester);

      expect(_onResultsScreen('Flutter interview'), findsOneWidget);
      expect(_onResultsScreen('Dart basics'), findsNothing);

      // Open it: the per-question breakdown, with options resolved to
      // their text (not the raw "a1"/"a2" keys).
      await tester.tap(_onResultsScreen('Flutter interview'));
      await settle(tester);

      expect(find.text('4 / 10'), findsOneWidget);
      expect(find.text('What is 2+2?'), findsOneWidget);
      expect(find.text('Your answer: 5'), findsOneWidget);
      expect(find.text('Correct answer: 4'), findsOneWidget);
    },
  );

  testWidgets('a student sees their own results with no student filter', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(_studentJson));
    app.api
      ..on('GET /result/list', [
        const FakeResponse(200, {
          'results': [
            {
              'ID': 3,
              'testId': 10,
              'userId': 7,
              'score': 8,
              'total': 10,
              'percentage': 80,
              'created_at': '2026-10-16T08:00:00Z',
            },
          ],
        }),
      ])
      ..on('GET /test/list', [
        const FakeResponse(200, {
          'tests': [
            {'ID': 10, 'title': 'Flutter interview'},
          ],
        }),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openResults(tester);

    expect(find.text('Your test attempts.'), findsOneWidget);
    expect(find.text('All students'), findsNothing);
    expect(_onResultsScreen('Flutter interview'), findsOneWidget);
  });

  testWidgets('a result deleted after the list loaded shows not-found', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api
      ..on('GET /result/list', [
        const FakeResponse(200, {
          'results': [
            {
              'ID': 9,
              'testId': 10,
              'userId': 4,
              'score': 1,
              'total': 10,
              'percentage': 10,
              'created_at': '2026-10-16T08:00:00Z',
            },
          ],
        }),
      ])
      ..on('GET /test/list', [
        const FakeResponse(200, {
          'tests': [
            {'ID': 10, 'title': 'Flutter interview'},
          ],
        }),
      ])
      ..on('GET /result/9', [
        const FakeResponse(404, {'message': 'Result not found'}),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openResults(tester);

    await tester.tap(_onResultsScreen('Flutter interview'));
    await settle(tester);

    expect(find.text('Result not found'), findsOneWidget);
  });
}
