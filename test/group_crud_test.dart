import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studify/features/auth/data/session_storage.dart';
import 'package:studify/features/auth/domain/user_profile.dart';

import 'support/fakes.dart';

StoredSession _session(Map<String, Object?> json) =>
    StoredSession(token: 'tok', user: UserProfile.fromJson(json));

Future<void> _openGroupsTab(WidgetTester tester) async {
  await tapNavTab(tester, 'Sessions');
  await tester.tap(find.text('Groups'));
  await settle(tester);
}

void main() {
  testWidgets('a teacher creates a group with an initial member', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api
      ..on('GET /group/list', [
        const FakeResponse(200, {'groups': <Object?>[]}),
        const FakeResponse(200, {
          'groups': [
            {'ID': 7, 'name': 'Beginners A1', 'memberCount': 1},
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
      ..on('POST /group', [
        const FakeResponse(201, {
          'group': {'ID': 7, 'name': 'Beginners A1', 'memberCount': 1},
        }),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openGroupsTab(tester);

    expect(find.text('Add group'), findsOneWidget);
    await tester.tap(find.text('Add group'));
    await settle(tester);

    expect(find.text('Add group'), findsNWidgets(2)); // button + title
    await tester.enterText(
      find.byKey(const ValueKey('group-form-name')),
      'Beginners A1',
    );
    await settle(tester);
    await tester.tap(
      find.byKey(const ValueKey('group-form-student-4')),
    );
    await settle(tester);

    await tester.tap(find.text('Create group'));
    await settle(tester);

    final request = app.api.requestsTo('POST /group').single;
    final body = app.api.bodyOf(request);
    expect(body['name'], 'Beginners A1');
    expect(body['studentIds'], [4]);

    // The sheet closed and the new group shows up in the list.
    expect(find.text('Add group'), findsOneWidget);
    expect(find.text('Beginners A1'), findsOneWidget);
  });

  testWidgets('renaming a group saves with PUT', (tester) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api
      ..on('GET /group/list', [
        const FakeResponse(200, {
          'groups': [
            {'ID': 7, 'name': 'Old name', 'memberCount': 0},
          ],
        }),
        const FakeResponse(200, {
          'groups': [
            {'ID': 7, 'name': 'New name', 'memberCount': 0},
          ],
        }),
      ])
      ..on('PUT /group/7', [
        const FakeResponse(200, {
          'group': {'ID': 7, 'name': 'New name', 'memberCount': 0},
        }),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openGroupsTab(tester);

    await tester.tap(find.byIcon(CupertinoIcons.ellipsis_vertical));
    await settle(tester);
    await tester.tap(find.text('Rename'));
    await settle(tester);

    expect(find.text('Rename group'), findsOneWidget);
    expect(
      tester
          .widget<TextField>(find.byKey(const ValueKey('group-form-name')))
          .controller!
          .text,
      'Old name',
    );

    await tester.enterText(
      find.byKey(const ValueKey('group-form-name')),
      'New name',
    );
    await settle(tester);
    await tester.tap(find.text('Save changes'));
    await settle(tester);

    final request = app.api.requestsTo('PUT /group/7').single;
    expect(app.api.bodyOf(request)['name'], 'New name');
    expect(find.text('New name'), findsOneWidget);
  });

  testWidgets('deleting a group asks first, then calls DELETE', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api
      ..on('GET /group/list', [
        const FakeResponse(200, {
          'groups': [
            {'ID': 7, 'name': 'Beginners A1', 'memberCount': 2},
          ],
        }),
      ])
      ..on('DELETE /group/7', [
        const FakeResponse(200, {'message': 'ok'}),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openGroupsTab(tester);

    await tester.tap(find.byIcon(CupertinoIcons.ellipsis_vertical));
    await settle(tester);
    await tester.tap(find.text('Delete'));
    await settle(tester);

    expect(find.text('Delete "Beginners A1"?'), findsOneWidget);
    // After deleting, the follow-up list load returns none left.
    app.api.on('GET /group/list', [
      const FakeResponse(200, {'groups': <Object?>[]}),
    ]);

    await tester.tap(find.text('Delete').last);
    await settle(tester);

    expect(app.api.requestsTo('DELETE /group/7'), isNotEmpty);
    expect(find.text('No groups yet'), findsOneWidget);
  });

  testWidgets(
    'tapping a group opens its roster, where a teacher can add and remove students',
    (tester) async {
      final app = await TestApp.create(session: _session(teacherJson));
      app.api
        ..on('GET /group/list', [
          const FakeResponse(200, {
            'groups': [
              {'ID': 7, 'name': 'Beginners A1', 'memberCount': 1},
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
        ])
        ..on('GET /group/7', [
          const FakeResponse(200, {
            'group': {
              'ID': 7,
              'name': 'Beginners A1',
              'students': [
                {'ID': 4, 'name': 'Anna', 'surname': 'K.'},
              ],
            },
          }),
          const FakeResponse(200, {
            'group': {
              'ID': 7,
              'name': 'Beginners A1',
              'students': [
                {'ID': 4, 'name': 'Anna', 'surname': 'K.'},
                {'ID': 5, 'name': 'Bob', 'surname': 'B.'},
              ],
            },
          }),
          const FakeResponse(200, {
            'group': {
              'ID': 7,
              'name': 'Beginners A1',
              'students': [
                {'ID': 4, 'name': 'Anna', 'surname': 'K.'},
              ],
            },
          }),
        ])
        ..on('POST /group/7/students', [
          const FakeResponse(200, {'message': 'ok'}),
        ])
        ..on('DELETE /group/7/students/5', [
          const FakeResponse(200, {'message': 'ok'}),
        ]);
      await tester.pumpWidget(app.widget);
      await settle(tester);
      await _openGroupsTab(tester);

      await tester.tap(find.text('Beginners A1'));
      await settle(tester);

      expect(find.text('Anna K.'), findsOneWidget);
      expect(find.text('Bob B.'), findsNothing);

      // Add Bob.
      await tester.tap(find.text('Student'));
      await settle(tester);
      await tester.tap(find.text('Bob B.'));
      await settle(tester);
      await tester.tap(find.text('Add'));
      await settle(tester);

      final addRequest = app.api.requestsTo('POST /group/7/students').single;
      expect(app.api.bodyOf(addRequest)['studentId'], 5);
      expect(find.text('Bob B.'), findsOneWidget);

      // Remove Bob again.
      await tester.tap(find.widgetWithText(TextButton, 'Remove').last);
      await settle(tester);

      expect(app.api.requestsTo('DELETE /group/7/students/5'), isNotEmpty);
      expect(find.text('Bob B.'), findsNothing);
      expect(find.text('Anna K.'), findsOneWidget);
    },
  );

  testWidgets('a missing group shows the not-found state', (tester) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api
      ..on('GET /group/list', [
        const FakeResponse(200, {
          'groups': [
            {'ID': 9, 'name': 'Ghost', 'memberCount': 0},
          ],
        }),
      ])
      ..on('GET /group/9', [
        const FakeResponse(404, {'message': 'Group not found'}),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openGroupsTab(tester);

    await tester.tap(find.text('Ghost'));
    await settle(tester);

    expect(find.text('Group not found'), findsOneWidget);
    expect(
      find.text('It may have already been deleted.'),
      findsOneWidget,
    );
  });
}
