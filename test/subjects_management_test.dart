import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
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

Future<void> _openSubjects(WidgetTester tester) =>
    tapNavTab(tester, 'Subjects');

void main() {
  testWidgets('a teacher sees the subject list with its active status', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api.on('GET /subject/list', [
      const FakeResponse(200, {
        'subjects': [
          {'ID': 1, 'name': 'English', 'isActive': true},
          {'ID': 2, 'name': 'French', 'isActive': false},
        ],
      }),
    ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openSubjects(tester);

    expect(find.text('English'), findsOneWidget);
    expect(find.text('French'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('Inactive'), findsOneWidget);
    expect(find.text('Add subject'), findsOneWidget);
  });

  testWidgets('a student sees a read-only list, with no management controls', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(_studentJson));
    app.api.on('GET /subject/list', [
      const FakeResponse(200, {
        'subjects': [
          {'ID': 1, 'name': 'English', 'isActive': true},
        ],
      }),
    ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openSubjects(tester);

    expect(find.text('English'), findsOneWidget);
    // No teacher-only affordances: no add button, no status badge, no
    // per-row menu.
    expect(find.text('Add subject'), findsNothing);
    expect(find.text('Active'), findsNothing);
    expect(find.byIcon(CupertinoIcons.ellipsis_vertical), findsNothing);
  });

  testWidgets('a teacher adds a subject', (tester) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api
      ..on('GET /subject/list', [
        const FakeResponse(200, {'subjects': <Object?>[]}),
      ])
      ..on('POST /subject', [
        const FakeResponse(201, {
          'subject': {'ID': 5, 'name': 'German', 'isActive': false},
        }),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openSubjects(tester);

    await tester.tap(find.text('Add subject'));
    await settle(tester);
    expect(find.text('Add subject'), findsNWidgets(2)); // button + title

    await tester.enterText(
      find.byKey(const ValueKey('subject-form-name')),
      'German',
    );
    await tester.pump();
    await tester.tap(find.text('Create subject'));
    await settle(tester);

    final request = app.api.requestsTo('POST /subject').single;
    expect(app.api.bodyOf(request)['name'], 'German');
    // The sheet closed and the new subject — straight from the POST
    // response, no reload needed — is in the list.
    expect(find.text('Add subject'), findsOneWidget);
    expect(find.text('German'), findsOneWidget);
    expect(find.text('Inactive'), findsOneWidget);
  });

  testWidgets('a teacher renames a subject', (tester) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api
      ..on('GET /subject/list', [
        const FakeResponse(200, {
          'subjects': [
            {'ID': 1, 'name': 'English', 'isActive': true},
          ],
        }),
      ])
      ..on('PUT /subject/1', [
        const FakeResponse(200, {
          'subject': {'ID': 1, 'name': 'English Literature', 'isActive': true},
        }),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openSubjects(tester);

    await tester.tap(find.byIcon(CupertinoIcons.ellipsis_vertical));
    await settle(tester);
    await tester.tap(find.text('Rename'));
    await settle(tester);

    expect(find.text('Rename subject'), findsOneWidget);
    final field = find.byKey(const ValueKey('subject-form-name'));
    expect(tester.widget<TextField>(field).controller?.text, 'English');

    await tester.enterText(field, 'English Literature');
    await tester.pump();
    await tester.tap(find.text('Save changes'));
    await settle(tester);

    final request = app.api.requestsTo('PUT /subject/1').single;
    expect(app.api.bodyOf(request)['name'], 'English Literature');
  });

  testWidgets('a teacher deactivates and reactivates a subject', (
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
      ..on('PATCH /subject/activate/1', [
        const FakeResponse(200, {
          'subject': {'ID': 1, 'name': 'English', 'isActive': false},
        }),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openSubjects(tester);

    expect(find.text('Active'), findsOneWidget);

    await tester.tap(find.byIcon(CupertinoIcons.ellipsis_vertical));
    await settle(tester);
    await tester.tap(find.text('Deactivate'));
    await settle(tester);

    expect(app.api.requestsTo('PATCH /subject/activate/1'), hasLength(1));
    expect(find.text('Inactive'), findsOneWidget);

    // The row's menu now offers "Activate" instead; toggling again flips
    // it back, straight from the PATCH response (no reload needed).
    app.api.on('PATCH /subject/activate/1', [
      const FakeResponse(200, {
        'subject': {'ID': 1, 'name': 'English', 'isActive': true},
      }),
    ]);
    await tester.tap(find.byIcon(CupertinoIcons.ellipsis_vertical));
    await settle(tester);
    await tester.tap(find.text('Activate'));
    await settle(tester);

    expect(app.api.requestsTo('PATCH /subject/activate/1'), hasLength(2));
    expect(find.text('Active'), findsOneWidget);
  });

  testWidgets('deleting a subject asks first, then calls DELETE', (
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
      ..on('DELETE /subject/1', [
        const FakeResponse(200, {'message': 'Subject deleted successfully'}),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openSubjects(tester);

    await tester.tap(find.byIcon(CupertinoIcons.ellipsis_vertical));
    await settle(tester);
    await tester.tap(find.text('Delete'));
    await settle(tester);

    expect(find.text('Delete "English"?'), findsOneWidget);

    await tester.tap(find.text('Delete').last);
    await settle(tester);

    expect(app.api.requestsTo('DELETE /subject/1'), isNotEmpty);
    expect(find.text('No subjects yet'), findsOneWidget);
  });
}
