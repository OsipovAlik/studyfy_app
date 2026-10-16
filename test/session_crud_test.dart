import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studify/features/auth/data/session_storage.dart';
import 'package:studify/features/auth/domain/user_profile.dart';

import 'support/fakes.dart';

StoredSession _session(Map<String, Object?> json) =>
    StoredSession(token: 'tok', user: UserProfile.fromJson(json));

Future<void> _openSessions(WidgetTester tester) =>
    tapNavTab(tester, 'Sessions');

/// Fills in the Material time picker's input-mode fields and confirms.
/// Forces AM explicitly: the picker starts on whatever period the real
/// wall clock is in (it isn't on the fake `clock`, unlike the rest of
/// the app), so leaving it alone would make `02:30` mean 14:30 half the
/// day.
Future<void> _pickAnyTime(WidgetTester tester) async {
  final fields = find.byType(TextFormField);
  await tester.enterText(fields.at(0), '02');
  await tester.enterText(fields.at(1), '30');
  await tester.tap(find.text('AM'));
  await tester.tap(find.text('OK'));
  await settle(tester);
}

void main() {
  testWidgets('a teacher creates a group session', (tester) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api
      ..on('GET /group/list', [
        const FakeResponse(200, {
          'groups': [
            {'ID': 7, 'name': 'Beginners A1', 'memberCount': 5},
          ],
        }),
      ])
      // The first load (before creating) has nothing; the reload right
      // after creating picks up the new session, same as the real API.
      ..on('GET /session/list', [
        const FakeResponse(200, {'sessions': <Object?>[]}),
        const FakeResponse(200, {
          'sessions': [
            {
              'ID': 9,
              'type': 'group',
              'dayOfWeek': 'tuesday',
              'startTime': '02:30',
              'groupId': 7,
            },
          ],
        }),
      ])
      ..on('POST /session', [
        const FakeResponse(201, {
          'session': {
            'ID': 9,
            'type': 'group',
            'dayOfWeek': 'tuesday',
            'startTime': '02:30',
            'groupId': 7,
          },
        }),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openSessions(tester);

    expect(find.text('Add session'), findsOneWidget);
    await tester.tap(find.text('Add session'));
    await settle(tester);

    expect(find.text('Add session'), findsNWidgets(2)); // button + title
    // Create is disabled until a group, a day and a time are chosen.
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );

    await tester.tap(
      find.byKey(const ValueKey('session-form-group-or-student')),
    );
    await settle(tester);
    await tester.tap(find.text('Beginners A1'));
    await settle(tester);

    await tester.tap(find.byKey(const ValueKey('session-form-day')));
    await settle(tester);
    await tester.tap(find.text('Tuesday'));
    await settle(tester);

    await tester.tap(find.byKey(const ValueKey('session-form-time')));
    await settle(tester);
    await _pickAnyTime(tester);

    await tester.tap(find.text('Create session'));
    await settle(tester);

    final request = app.api.requestsTo('POST /session').single;
    final body = app.api.bodyOf(request);
    expect(body['type'], 'group');
    expect(body['groupId'], 7);
    expect(body['dayOfWeek'], 'tuesday');
    expect(body['startTime'], '02:30');

    // The sheet closed and the new session shows up in the list.
    expect(find.text('Add session'), findsOneWidget);
    expect(find.text('Beginners A1'), findsOneWidget);
  });

  testWidgets(
    'the group picker shows a hint instead when there are no groups',
    (tester) async {
      final app = await TestApp.create(session: _session(teacherJson));
      await tester.pumpWidget(app.widget);
      await settle(tester);
      await _openSessions(tester);

      await tester.tap(find.text('Add session'));
      await settle(tester);

      expect(
        find.text('Create a group first to schedule a group session.'),
        findsOneWidget,
      );
    },
  );

  testWidgets('editing a session pre-fills the form and saves with PUT', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api
      ..on('GET /session/list', [
        const FakeResponse(200, {
          'sessions': [
            {
              'ID': 5,
              'type': 'individual',
              'dayOfWeek': 'monday',
              'startTime': '09:00',
              'studentId': 4,
            },
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
          ],
        }),
      ])
      ..on('PUT /session/5', [
        const FakeResponse(200, {
          'session': {
            'ID': 5,
            'type': 'individual',
            'dayOfWeek': 'monday',
            'startTime': '09:00',
            'studentId': 4,
          },
        }),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openSessions(tester);

    await tester.tap(find.byIcon(CupertinoIcons.ellipsis_vertical));
    await settle(tester);
    await tester.tap(find.text('Edit'));
    await settle(tester);

    // Pre-filled from the existing session.
    expect(find.text('Edit session'), findsOneWidget);
    expect(find.text('Anna K.'), findsWidgets);
    expect(find.text('Monday'), findsWidgets);

    await tester.tap(find.text('Save changes'));
    await settle(tester);

    final request = app.api.requestsTo('PUT /session/5').single;
    final body = app.api.bodyOf(request);
    expect(body['type'], 'individual');
    expect(body['studentId'], 4);
    expect(body['dayOfWeek'], 'monday');
    expect(body['startTime'], '09:00');
  });

  testWidgets('deleting a session asks first, then calls DELETE', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api
      ..on('GET /session/list', [
        const FakeResponse(200, {
          'sessions': [
            {
              'ID': 5,
              'type': 'individual',
              'dayOfWeek': 'monday',
              'startTime': '09:00',
              'studentId': 4,
            },
          ],
        }),
      ])
      ..on('DELETE /session/5', [
        const FakeResponse(200, {'message': 'ok'}),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openSessions(tester);

    await tester.tap(find.byIcon(CupertinoIcons.ellipsis_vertical));
    await settle(tester);
    await tester.tap(find.text('Delete'));
    await settle(tester);

    expect(find.text('Delete this session?'), findsOneWidget);
    // After deleting, the follow-up list load returns none left.
    app.api.on('GET /session/list', [
      const FakeResponse(200, {'sessions': <Object?>[]}),
    ]);

    await tester.tap(find.text('Delete').last);
    await settle(tester);

    expect(app.api.requestsTo('DELETE /session/5'), isNotEmpty);
    expect(find.text('No sessions yet'), findsOneWidget);
  });
}
