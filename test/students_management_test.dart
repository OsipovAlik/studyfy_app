import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studify/features/auth/data/session_storage.dart';
import 'package:studify/features/auth/domain/user_profile.dart';

import 'support/fakes.dart';

StoredSession _session(Map<String, Object?> json) =>
    StoredSession(token: 'tok', user: UserProfile.fromJson(json));

Future<void> _openStudents(WidgetTester tester) =>
    tapNavTab(tester, 'Students');

void main() {
  testWidgets('a teacher filters students by subject', (tester) async {
    final app = await TestApp.create(session: _session(teacherJson));
    // Several of Home's own widgets (the timetable card, the stats
    // grid, the results list) load /students as soon as the app
    // starts too, ahead of this screen — a single value that answers
    // every call keeps this test from depending on how many of those
    // there are.
    app.api
      ..on('GET /subject/list', [
        const FakeResponse(200, {
          'subjects': [
            {'ID': 1, 'name': 'English'},
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
            },
            {
              'ID': 5,
              'name': 'Bob',
              'surname': 'B.',
              'email': 'b@b.c',
              'role': 'student',
            },
          ],
        }),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openStudents(tester);

    expect(find.text('Anna K.'), findsOneWidget);
    expect(find.text('Bob B.'), findsOneWidget);

    await tester.tap(find.text('All subjects'));
    await settle(tester);
    await tester.tap(find.text('English'));
    await settle(tester);

    // The fake always answers the same way regardless of the filter, so
    // what actually proves the filter took effect is the request it
    // sent — the real API would be the one doing the filtering.
    final request = app.api.requestsTo('GET /students').last;
    expect(request.queryParameters['subjectId'], 1);
  });

  testWidgets('a teacher registers a new student', (tester) async {
    final app = await TestApp.create(session: _session(teacherJson));
    // A constant answer for every /students call (see the filter test
    // above for why) — the real assertions below are the POST body and
    // that a reload fires afterwards, not a simulated before/after diff.
    app.api
      ..on('GET /subject/list', [
        const FakeResponse(200, {
          'subjects': [
            {'ID': 2, 'name': 'French'},
          ],
        }),
      ])
      ..on('GET /students', [
        const FakeResponse(200, {'users': <Object?>[]}),
      ])
      ..on('POST /register', [
        const FakeResponse(201, {
          'user': {
            'name': 'Nora',
            'surname': 'T.',
            'partnerId': 1,
            'email': 'nora@example.com',
            'role': 'student',
          },
        }),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openStudents(tester);

    expect(find.text('No students yet'), findsOneWidget);
    final requestsBeforeAdding = app.api.requestsTo('GET /students').length;

    await tester.tap(find.text('Add student'));
    await settle(tester);

    expect(find.text('Add student'), findsNWidgets(2)); // button + title
    await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Nora');
    await tester.enterText(
      find.widgetWithText(TextField, 'Surname (optional)'),
      'T.',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Email'),
      'nora@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Password'),
      'Sup3r!Secret',
    );
    await tester.tap(find.byKey(const ValueKey('add-student-subject')));
    await settle(tester);
    await tester.tap(find.text('French'));
    await settle(tester);

    await tester.ensureVisible(find.text('Register student'));
    await tester.tap(find.text('Register student'));
    await settle(tester);

    final request = app.api.requestsTo('POST /register').single;
    final body = app.api.bodyOf(request);
    expect(body['name'], 'Nora');
    expect(body['surname'], 'T.');
    expect(body['email'], 'nora@example.com');
    expect(body['password'], 'Sup3r!Secret');
    expect(body['role'], 'student');
    expect(body['partnerId'], 1); // the signed-in teacher's own school
    expect(body['subjectId'], 2);

    // The sheet closed and the roster was reloaded (the real API would
    // now include the new student; the fake just answers the same way).
    expect(find.text('Add student'), findsOneWidget);
    expect(
      app.api.requestsTo('GET /students').length,
      greaterThan(requestsBeforeAdding),
    );
  });

  testWidgets('registering with a taken email shows the server message', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api
      ..on('GET /subject/list', [
        const FakeResponse(200, {
          'subjects': [
            {'ID': 2, 'name': 'French'},
          ],
        }),
      ])
      ..on('POST /register', [
        const FakeResponse(409, {'message': 'Email already registered'}),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openStudents(tester);

    await tester.tap(find.text('Add student'));
    await settle(tester);
    await tester.enterText(find.widgetWithText(TextField, 'Name'), 'Nora');
    await tester.enterText(
      find.widgetWithText(TextField, 'Email'),
      'taken@example.com',
    );
    await tester.enterText(
      find.widgetWithText(TextField, 'Password'),
      'Sup3r!Secret',
    );
    await tester.tap(find.byKey(const ValueKey('add-student-subject')));
    await settle(tester);
    await tester.tap(find.text('French'));
    await settle(tester);

    await tester.ensureVisible(find.text('Register student'));
    await tester.tap(find.text('Register student'));
    await settle(tester);

    // The app's own copy for a 409, not the raw server message.
    expect(find.text('That email is already registered.'), findsOneWidget);
  });

  testWidgets('the subject picker shows a hint when there are no subjects', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(teacherJson));
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openStudents(tester);

    await tester.tap(find.text('Add student'));
    await settle(tester);

    expect(
      find.text('Create a subject first before registering a student.'),
      findsOneWidget,
    );
  });

  testWidgets(
    "deleting a student asks for the teacher's password, then calls DELETE",
    (tester) async {
      final app = await TestApp.create(session: _session(teacherJson));
      app.api
        ..on('GET /students', [
          const FakeResponse(200, {
            'users': [
              {
                'ID': 4,
                'name': 'Anna',
                'surname': 'K.',
                'email': 'a@b.c',
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
      await _openStudents(tester);

      await tester.tap(find.byIcon(CupertinoIcons.trash));
      await settle(tester);

      expect(find.text('Delete "Anna K."?'), findsOneWidget);
      // The DELETE route (a teacher deleting a student) requires the
      // caller's own password — the dialog collects it rather than just
      // asking yes/no.
      await tester.enterText(
        find.widgetWithText(TextField, 'Password'),
        'MyOwnPass1',
      );
      await tester.pump();
      // After deleting, the follow-up list load returns none left.
      app.api.on('GET /students', [
        const FakeResponse(200, {'users': <Object?>[]}),
      ]);

      await tester.tap(find.text('Delete').last);
      await settle(tester);

      final request = app.api.requestsTo('DELETE /user/4').single;
      expect(app.api.bodyOf(request)['password'], 'MyOwnPass1');
      expect(find.text('No students yet'), findsOneWidget);
    },
  );

  testWidgets('a wrong password on delete shows an inline error and stays open', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api
      ..on('GET /students', [
        const FakeResponse(200, {
          'users': [
            {
              'ID': 4,
              'name': 'Anna',
              'surname': 'K.',
              'email': 'a@b.c',
              'role': 'student',
            },
          ],
        }),
      ])
      ..on('DELETE /user/4', [
        const FakeResponse(400, {'message': 'Password is incorrect'}),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openStudents(tester);

    await tester.tap(find.byIcon(CupertinoIcons.trash));
    await settle(tester);
    await tester.enterText(
      find.widgetWithText(TextField, 'Password'),
      'wrong',
    );
    await tester.pump();
    await tester.tap(find.text('Delete').last);
    await settle(tester);

    expect(find.text('That password is incorrect.'), findsOneWidget);
    // Still there to retry — the dialog did not close, and the student
    // was not removed.
    expect(find.text('Delete "Anna K."?'), findsOneWidget);
    expect(find.text('Anna K.'), findsOneWidget);
  });
}
