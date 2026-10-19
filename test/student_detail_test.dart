import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studify/features/auth/data/session_storage.dart';
import 'package:studify/features/auth/domain/user_profile.dart';

import 'support/fakes.dart';

StoredSession _session(Map<String, Object?> json) =>
    StoredSession(token: 'tok', user: UserProfile.fromJson(json));

Future<void> _openStudentDetail(WidgetTester tester, String name) async {
  await tapNavTab(tester, 'Students');
  await tester.tap(find.text(name));
  await settle(tester);
}

void main() {
  testWidgets('opening a student shows their header and info', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api.on('GET /students', [
      const FakeResponse(200, {
        'users': [
          {
            'ID': 4,
            'name': 'Pro',
            'surname': 'Bagh',
            'email': 'probagh@gmail.com',
            'role': 'student',
            'created_at': '2026-10-16T09:00:00Z',
          },
        ],
      }),
    ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openStudentDetail(tester, 'Pro Bagh');

    expect(find.text('Back to students'), findsOneWidget);
    expect(find.text('PB'), findsOneWidget);
    expect(find.text('Pro Bagh'), findsWidgets);
    expect(find.text('probagh@gmail.com'), findsWidgets);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Registered'), findsOneWidget);
    expect(find.text('October 16, 2026'), findsOneWidget);
    expect(find.text('Test results'), findsOneWidget);
    expect(
      find.text('Results appear here once students complete tests.'),
      findsOneWidget,
    );
  });

  testWidgets('deleting a student from the detail page returns to the list', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api
      ..on('GET /students', [
        const FakeResponse(200, {
          'users': [
            {
              'ID': 4,
              'name': 'Pro',
              'surname': 'Bagh',
              'email': 'probagh@gmail.com',
              'role': 'student',
            },
          ],
        }),
      ])
      ..on('DELETE /user/4', [
        const FakeResponse(200, {'message': 'User deleted successfully'}),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openStudentDetail(tester, 'Pro Bagh');

    await tester.tap(find.text('Delete'));
    await settle(tester);
    expect(find.text('Delete "Pro Bagh"?'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextField, 'Password'),
      'MyOwnPass1',
    );
    await tester.pump();
    app.api.on('GET /students', [
      const FakeResponse(200, {'users': <Object?>[]}),
    ]);
    await tester.tap(find.text('Delete').last);
    await settle(tester);

    final request = app.api.requestsTo('DELETE /user/4').single;
    expect(app.api.bodyOf(request)['password'], 'MyOwnPass1');
    // Back on the list, now empty — the detail page popped itself.
    expect(find.text('Back to students'), findsNothing);
    expect(find.text('No students yet'), findsOneWidget);
  });

  testWidgets(
    "a student's own results show on their page and link to the full result",
    (tester) async {
      final app = await TestApp.create(session: _session(teacherJson));
      app.api
        ..on('GET /students', [
          const FakeResponse(200, {
            'users': [
              {
                'ID': 4,
                'name': 'Pro',
                'surname': 'Bagh',
                'email': 'probagh@gmail.com',
                'role': 'student',
              },
              {
                'ID': 5,
                'name': 'Other',
                'surname': 'Student',
                'email': 'other@gmail.com',
                'role': 'student',
              },
            ],
          }),
        ])
        ..on('GET /result/list', [
          const FakeResponse(200, {
            'results': [
              {
                'ID': 20,
                'testId': 1,
                'userId': 4,
                'score': 8,
                'total': 10,
                'percentage': 80,
                'created_at': '2026-10-15T09:00:00Z',
              },
              {
                'ID': 21,
                'testId': 1,
                'userId': 5,
                'score': 3,
                'total': 10,
                'percentage': 30,
                'created_at': '2026-10-15T09:00:00Z',
              },
            ],
          }),
        ])
        ..on('GET /test/list', [
          const FakeResponse(200, {
            'tests': [
              {'ID': 1, 'title': 'Midterm'},
            ],
          }),
        ])
        ..on('GET /result/20', [
          const FakeResponse(200, {
            'result': {
              'ID': 20,
              'testId': 1,
              'userId': 4,
              'score': 8,
              'total': 10,
              'percentage': 80,
              'created_at': '2026-10-15T09:00:00Z',
              'answers': <Object?>[],
            },
          }),
        ])
        ..on('GET /question/list/1', [
          const FakeResponse(200, {'data': <Object?>[]}),
        ]);
      await tester.pumpWidget(app.widget);
      await settle(tester);
      await _openStudentDetail(tester, 'Pro Bagh');

      // Only this student's own result shows, not the other student's.
      expect(find.text('80%'), findsOneWidget);
      expect(find.text('30%'), findsNothing);
      expect(find.text('Midterm'), findsOneWidget);

      await tester.tap(find.text('Midterm'));
      await settle(tester);

      expect(find.text('8 / 10'), findsOneWidget);
    },
  );

  testWidgets("a student doesn't get a Students tab at all", (tester) async {
    const studentJson = {
      'id': 9,
      'name': 'Learner',
      'surname': '',
      'email': 'learner@example.com',
      'role': 'student',
      'partnerId': 1,
      'partnerName': 'Acme Language School',
    };
    final app = await TestApp.create(session: _session(studentJson));
    await tester.pumpWidget(app.widget);
    await settle(tester);

    // Students don't even get a Students tab.
    expect(find.byIcon(CupertinoIcons.person_3), findsNothing);
  });
}
