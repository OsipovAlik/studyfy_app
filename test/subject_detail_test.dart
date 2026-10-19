import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studify/features/auth/data/session_storage.dart';
import 'package:studify/features/auth/domain/user_profile.dart';

import 'support/fakes.dart';

StoredSession _session(Map<String, Object?> json) =>
    StoredSession(token: 'tok', user: UserProfile.fromJson(json));

Future<void> _openSubjectDetail(WidgetTester tester) async {
  await tapNavTab(tester, 'Subjects');
  await tester.tap(find.text('English'));
  await settle(tester);
}

void main() {
  testWidgets('opening a subject shows its header and info', (tester) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api
      ..on('GET /subject/list', [
        const FakeResponse(200, {
          'subjects': [
            {
              'ID': 1,
              'name': 'English',
              'isActive': true,
              'created_at': '2026-10-13T09:00:00Z',
            },
          ],
        }),
      ])
      ..on('GET /level/list/1', [
        const FakeResponse(200, {'levels': <Object?>[]}),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openSubjectDetail(tester);

    expect(find.byIcon(CupertinoIcons.back), findsOneWidget);
    expect(find.text('English'), findsWidgets);
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('Created'), findsOneWidget);
    expect(find.text('October 13, 2026'), findsOneWidget);
    expect(find.text('Deactivate'), findsOneWidget);
    expect(find.text('Rename'), findsOneWidget);
    // No levels yet, so the Tests tab shows the "create a level" hint.
    expect(
      find.text('Add a level (e.g. A1) before creating tests.'),
      findsOneWidget,
    );
  });

  testWidgets('a teacher adds, renames and deletes a level', (tester) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api
      ..on('GET /subject/list', [
        const FakeResponse(200, {
          'subjects': [
            {'ID': 1, 'name': 'English', 'isActive': true},
          ],
        }),
      ])
      ..on('GET /level/list/1', [
        const FakeResponse(200, {'levels': <Object?>[]}),
      ])
      ..on('POST /level', [
        const FakeResponse(201, {
          'level': {'ID': 9, 'subjectId': 1, 'name': 'A1'},
        }),
      ])
      ..on('GET /test/list', [
        const FakeResponse(200, {'tests': <Object?>[]}),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openSubjectDetail(tester);

    await tester.tap(find.text('Levels'));
    await settle(tester);
    await tester.tap(find.text('Add level'));
    await settle(tester);

    await tester.enterText(
      find.byKey(const ValueKey('level-form-name')),
      'A1',
    );
    await tester.pump();
    await tester.tap(find.text('Create level'));
    await settle(tester);

    var request = app.api.requestsTo('POST /level').single;
    expect(app.api.bodyOf(request)['subjectId'], 1);
    expect(app.api.bodyOf(request)['name'], 'A1');
    expect(find.text('A1'), findsOneWidget);

    // Rename it.
    app.api.on('PUT /level/9', [
      const FakeResponse(200, {
        'subject': {'ID': 9, 'subjectId': 1, 'name': 'A1 Beginners'},
      }),
    ]);
    await tester.ensureVisible(find.byIcon(CupertinoIcons.ellipsis_vertical));
    await settle(tester);
    await tester.tap(find.byIcon(CupertinoIcons.ellipsis_vertical));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('level-rename-9')));
    await settle(tester);
    await tester.enterText(
      find.byKey(const ValueKey('level-form-name')),
      'A1 Beginners',
    );
    await tester.pump();
    await tester.tap(find.text('Save changes'));
    await settle(tester);

    request = app.api.requestsTo('PUT /level/9').single;
    expect(app.api.bodyOf(request)['name'], 'A1 Beginners');
    expect(find.text('A1 Beginners'), findsOneWidget);

    // Delete it.
    app.api.on('DELETE /level/9', [
      const FakeResponse(200, {'message': 'Level deleted successfully'}),
    ]);
    await tester.ensureVisible(find.byIcon(CupertinoIcons.ellipsis_vertical));
    await settle(tester);
    await tester.tap(find.byIcon(CupertinoIcons.ellipsis_vertical));
    await settle(tester);
    await tester.tap(find.byKey(const ValueKey('level-delete-9')));
    await settle(tester);
    expect(find.text('Delete "A1 Beginners"?'), findsOneWidget);
    await tester.tap(find.text('Delete').last);
    await settle(tester);

    expect(app.api.requestsTo('DELETE /level/9'), isNotEmpty);
    expect(find.text('No levels yet'), findsOneWidget);
  });

  testWidgets(
    'a teacher adds, edits, deactivates and deletes a test for the selected level',
    (tester) async {
      final app = await TestApp.create(session: _session(teacherJson));
      app.api
        ..on('GET /subject/list', [
          const FakeResponse(200, {
            'subjects': [
              {'ID': 1, 'name': 'English', 'isActive': true},
            ],
          }),
        ])
        ..on('GET /level/list/1', [
          const FakeResponse(200, {
            'levels': [
              {'ID': 9, 'subjectId': 1, 'name': 'A1'},
            ],
          }),
        ])
        ..on('GET /test/list', [
          const FakeResponse(200, {'tests': <Object?>[]}),
        ])
        ..on('POST /test', [
          const FakeResponse(201, {
            'test': {
              'ID': 20,
              'title': 'Midterm',
              'subjectId': 1,
              'levelId': 9,
              'isActive': false,
            },
          }),
        ]);
      await tester.pumpWidget(app.widget);
      await settle(tester);
      await _openSubjectDetail(tester);

      expect(find.text('A1'), findsOneWidget); // the level chip

      await tester.tap(find.text('Add test'));
      await settle(tester);
      await tester.enterText(
        find.byKey(const ValueKey('test-form-title')),
        'Midterm',
      );
      await tester.pump();
      await tester.tap(find.text('Create test'));
      await settle(tester);

      var request = app.api.requestsTo('POST /test').single;
      var body = app.api.bodyOf(request);
      expect(body['title'], 'Midterm');
      expect(body['subjectId'], 1);
      expect(body['levelId'], 9);
      expect(body.containsKey('timeLimitMinutes'), isFalse);
      expect(find.text('Midterm'), findsOneWidget);
      expect(find.text('Inactive'), findsOneWidget);

      // Edit its title and give it a time limit.
      app.api.on('PATCH /test/20', [
        const FakeResponse(200, {
          'test': {
            'ID': 20,
            'title': 'Midterm exam',
            'subjectId': 1,
            'levelId': 9,
            'isActive': false,
            'timeLimitMinutes': 45,
          },
        }),
      ]);
      await tester.ensureVisible(find.byKey(const ValueKey('test-edit-20')));
      await settle(tester);
      await tester.tap(find.byKey(const ValueKey('test-edit-20')));
      await settle(tester);
      await tester.enterText(
        find.byKey(const ValueKey('test-form-title')),
        'Midterm exam',
      );
      await tester.enterText(
        find.byKey(const ValueKey('test-form-time-limit')),
        '45',
      );
      await tester.pump();
      await tester.tap(find.text('Save changes'));
      await settle(tester);

      request = app.api.requestsTo('PATCH /test/20').single;
      body = app.api.bodyOf(request);
      expect(body['title'], 'Midterm exam');
      expect(body['timeLimitMinutes'], 45);
      expect(find.text('Midterm exam'), findsOneWidget);

      // Activate it.
      app.api.on('PATCH /test/20', [
        const FakeResponse(200, {
          'test': {
            'ID': 20,
            'title': 'Midterm exam',
            'subjectId': 1,
            'levelId': 9,
            'isActive': true,
          },
        }),
      ]);
      await tester.ensureVisible(
        find.byKey(const ValueKey('test-toggle-active-20')),
      );
      await settle(tester);
      await tester.tap(find.byKey(const ValueKey('test-toggle-active-20')));
      await settle(tester);
      expect(app.api.requestsTo('PATCH /test/20'), hasLength(2));
      expect(app.api.bodyOf(app.api.requestsTo('PATCH /test/20').last)['isActive'], true);
      // The subject itself is also Active, so now both say so.
      expect(find.text('Active'), findsNWidgets(2));

      // Delete it.
      app.api.on('DELETE /test/20', [
        const FakeResponse(200, {'message': 'Test deleted successfully'}),
      ]);
      await tester.ensureVisible(find.byKey(const ValueKey('test-delete-20')));
      await settle(tester);
      await tester.tap(find.byKey(const ValueKey('test-delete-20')));
      await settle(tester);
      expect(find.text('Delete "Midterm exam"?'), findsOneWidget);
      await tester.tap(find.text('Delete').last);
      await settle(tester);

      expect(app.api.requestsTo('DELETE /test/20'), isNotEmpty);
      expect(find.text('No tests yet'), findsOneWidget);
    },
  );

  testWidgets('generating a test with AI shows the result and adds it', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api
      ..on('GET /subject/list', [
        const FakeResponse(200, {
          'subjects': [
            {'ID': 1, 'name': 'English', 'isActive': true},
          ],
        }),
      ])
      ..on('GET /level/list/1', [
        const FakeResponse(200, {
          'levels': [
            {'ID': 9, 'subjectId': 1, 'name': 'A1'},
          ],
        }),
      ])
      ..on('GET /test/list', [
        const FakeResponse(200, {'tests': <Object?>[]}),
      ])
      ..on('POST /test/generate', [
        const FakeResponse(201, {
          'test': {
            'ID': 30,
            'title': 'Past tense practice',
            'subjectId': 1,
            'levelId': 9,
            'isActive': false,
          },
          'requested': 10,
          'generated': 8,
        }),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openSubjectDetail(tester);

    await tester.tap(find.text('Generate with AI'));
    await settle(tester);
    await tester.enterText(
      find.widgetWithText(TextField, 'Topic, e.g. Past tense irregular verbs'),
      'Past tense irregular verbs',
    );
    await tester.pump();
    await tester.ensureVisible(find.text('Generate'));
    await tester.tap(find.text('Generate'));
    await settle(tester, frames: 40);

    final request = app.api.requestsTo('POST /test/generate').single;
    final body = app.api.bodyOf(request);
    expect(body['topic'], 'Past tense irregular verbs');
    expect(body['subjectId'], 1);
    expect(body['levelId'], 9);
    expect(body['cefrLevel'], 'A1');
    expect(body['questionCount'], 10);
    expect(body['questionType'], 'mixed');

    expect(
      find.text('Generated 8 of 10 questions. Review it before publishing.'),
      findsOneWidget,
    );
    expect(find.text('Past tense practice'), findsOneWidget);
  });

  testWidgets('a student cannot open a subject', (tester) async {
    const studentJson = {
      'id': 4,
      'name': 'John',
      'surname': 'Doe',
      'email': 'john@example.com',
      'role': 'student',
      'partnerId': 1,
      'partnerName': 'Acme Language School',
    };
    final app = await TestApp.create(session: _session(studentJson));
    app.api.on('GET /subject/list', [
      const FakeResponse(200, {
        'subjects': [
          {'ID': 1, 'name': 'English', 'isActive': true},
        ],
      }),
    ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await tapNavTab(tester, 'Subjects');

    await tester.tap(find.text('English'));
    await settle(tester);

    // No navigation happened: still on the Subjects list, not the
    // detail page's back button.
    expect(find.byIcon(CupertinoIcons.back), findsNothing);
  });
}
