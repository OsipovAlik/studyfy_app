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

Map<String, Object?> _taskAssignment({
  int id = 1,
  String status = 'pending',
  String title = 'Record yourself reading p.12',
  int? grade,
  bool isGraded = false,
  String? submissionText,
  String? note,
  String? dueDate,
}) => {
  'ID': id,
  'type': 'task',
  'title': title,
  'testId': null,
  'testIsActive': false,
  'studentId': 4,
  'studentName': 'John',
  'studentSurname': 'Doe',
  'dueDate': dueDate,
  'note': note,
  'status': status,
  'isLate': false,
  'submissionText': submissionText,
  'isGraded': isGraded,
  'maxGrade': 100,
  'grade': grade,
  'feedback': null,
  'score': null,
  'total': null,
  'percentage': null,
};

Map<String, Object?> _testAssignment({
  int id = 2,
  String status = 'completed',
  String title = 'Midterm',
  int? resultId = 9,
  int? score = 8,
  int? total = 10,
  double? percentage = 80,
}) => {
  'ID': id,
  'type': 'test',
  'title': title,
  'testId': 55,
  'testIsActive': true,
  'testTimeLimitMinutes': 45,
  'studentId': 4,
  'studentName': 'John',
  'studentSurname': 'Doe',
  'dueDate': null,
  'note': null,
  'status': status,
  'isLate': false,
  'resultId': resultId,
  'isGraded': false,
  'score': score,
  'total': total,
  'percentage': percentage,
};

Future<void> _openHomework(WidgetTester tester, {bool isTeacher = true}) =>
    tapNavTab(tester, isTeacher ? 'Homework' : 'My homework');

void main() {
  testWidgets('a teacher sees the homework list, matching the empty state', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(teacherJson));
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openHomework(tester);

    // "Homework" also names the nav bar tab, so this scopes to the
    // headline on the page itself.
    expect(find.text('Homework'), findsNWidgets(2));
    expect(
      find.text('Assign homework to students and follow their progress.'),
      findsOneWidget,
    );
    expect(find.text('Search homework…'), findsOneWidget);
    expect(find.text('Assign'), findsOneWidget);
    expect(find.text('All students'), findsOneWidget);
    expect(
      find.text('No homework yet. Assign a test to your students.'),
      findsOneWidget,
    );
  });

  testWidgets('a teacher assigns a task to one student', (tester) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api
      ..on('GET /students', [
        const FakeResponse(200, {
          'users': [
            {
              'ID': 4,
              'name': 'John',
              'surname': 'Doe',
              'email': 'john@example.com',
              'role': 'student',
            },
          ],
        }),
      ])
      ..on('POST /assignment', [
        FakeResponse(201, {
          'result': {
            'assignments': [_taskAssignment()],
          },
        }),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openHomework(tester);

    await tester.tap(find.text('Assign'));
    await settle(tester);

    // Task kind (the second segment).
    await tester.tap(find.text('Task'));
    await settle(tester);
    await tester.enterText(
      find.byKey(const ValueKey('assign-homework-title')),
      'Record yourself reading p.12',
    );
    await tester.pump();
    final studentCheckbox = find.byKey(
      const ValueKey('assign-homework-student-4'),
    );
    await tester.ensureVisible(studentCheckbox);
    await tester.tap(studentCheckbox);
    await settle(tester);

    await tester.ensureVisible(find.text('Assign').last);
    await tester.tap(find.text('Assign').last);
    await settle(tester);

    final request = app.api.requestsTo('POST /assignment').single;
    final body = app.api.bodyOf(request);
    expect(body['title'], 'Record yourself reading p.12');
    expect(body['studentIds'], [4]);
    expect(find.text('Record yourself reading p.12'), findsOneWidget);
  });

  testWidgets('a teacher assigns an active test to a whole group', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api
      ..on('GET /group/list', [
        const FakeResponse(200, {
          'groups': [
            {'ID': 3, 'partnerId': 1, 'name': 'Beginners'},
          ],
        }),
      ])
      ..on('GET /test/list', [
        const FakeResponse(200, {
          'tests': [
            {
              'ID': 55,
              'title': 'Midterm',
              'subjectId': 1,
              'levelId': 9,
              'isActive': true,
            },
          ],
        }),
      ])
      ..on('POST /assignment', [
        FakeResponse(201, {
          'result': {
            'assignments': [
              _testAssignment(
                status: 'pending',
                score: null,
                total: null,
                percentage: null,
                resultId: null,
              ),
            ],
          },
        }),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openHomework(tester);

    await tester.tap(find.text('Assign'));
    await settle(tester);

    final testPicker = find.byKey(const ValueKey('assign-homework-test'));
    await tester.ensureVisible(testPicker);
    await tester.tap(testPicker);
    await settle(tester);
    await tester.tap(find.text('Midterm').last);
    await settle(tester);

    final groupCheckbox = find.byKey(
      const ValueKey('assign-homework-group-3'),
    );
    await tester.ensureVisible(groupCheckbox);
    await tester.tap(groupCheckbox);
    await settle(tester);

    await tester.ensureVisible(find.text('Assign').last);
    await tester.tap(find.text('Assign').last);
    await settle(tester);

    final request = app.api.requestsTo('POST /assignment').single;
    final body = app.api.bodyOf(request);
    expect(body['testId'], 55);
    expect(body['groupIds'], [3]);
  });

  testWidgets('the status tabs filter the list and update their counts', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api.on('GET /assignment/list', [
      FakeResponse(200, {
        'assignments': [
          _taskAssignment(title: 'Essay'),
          _taskAssignment(id: 2, status: 'overdue', title: 'Worksheet'),
          _taskAssignment(
            id: 3,
            status: 'completed',
            title: 'Reading log',
            isGraded: true,
            grade: 90,
          ),
        ],
      }),
    ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openHomework(tester);

    expect(find.text('Essay'), findsOneWidget);
    expect(find.text('Worksheet'), findsOneWidget);
    expect(find.text('Reading log'), findsOneWidget);

    // "Overdue" also labels the Worksheet row's own status badge; the
    // tab itself is built first.
    await tester.tap(find.text('Overdue').first);
    await settle(tester);

    expect(find.text('Essay'), findsNothing);
    expect(find.text('Worksheet'), findsOneWidget);
    expect(find.text('Reading log'), findsNothing);
  });

  testWidgets('a teacher opens, edits and deletes an assignment', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api
      ..on('GET /assignment/list', [
        FakeResponse(200, {
          'assignments': [_taskAssignment(note: 'Read slowly.')],
        }),
      ])
      ..on('GET /assignment/1/attachments', [
        const FakeResponse(200, {'attachments': <Object?>[]}),
      ])
      ..on('PUT /assignment/1', [
        FakeResponse(200, {
          'assignment': _taskAssignment(note: 'Read slowly, twice.'),
        }),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openHomework(tester);

    await tester.tap(find.text('Record yourself reading p.12'));
    await settle(tester);

    await tester.scrollUntilVisible(find.text('Read slowly.'), 200);
    expect(find.text('Read slowly.'), findsOneWidget);

    final editButton = find.byKey(const ValueKey('assignment-detail-edit'));
    await tester.ensureVisible(editButton);
    await settle(tester);
    await tester.tap(editButton);
    await settle(tester);
    await tester.enterText(
      find.widgetWithText(TextField, 'Note for the student (optional)'),
      'Read slowly, twice.',
    );
    await tester.pump();
    await tester.tap(find.text('Save changes'));
    await settle(tester);

    final request = app.api.requestsTo('PUT /assignment/1').single;
    expect(app.api.bodyOf(request)['note'], 'Read slowly, twice.');
    await tester.scrollUntilVisible(find.text('Read slowly, twice.'), 200);
    expect(find.text('Read slowly, twice.'), findsOneWidget);

    app.api.on('DELETE /assignment/1', [
      const FakeResponse(200, {'message': 'Assignment deleted successfully'}),
    ]);
    final deleteButton = find.byKey(const ValueKey('assignment-detail-delete'));
    await tester.ensureVisible(deleteButton);
    await settle(tester);
    await tester.tap(deleteButton);
    await settle(tester);
    expect(find.text('Delete "Record yourself reading p.12"?'), findsOneWidget);
    await tester.tap(find.text('Delete'));
    await settle(tester);

    expect(app.api.requestsTo('DELETE /assignment/1'), isNotEmpty);
    // Back on the list, now empty.
    expect(
      find.text('No homework yet. Assign a test to your students.'),
      findsOneWidget,
    );
  });

  testWidgets('a teacher grades a submitted task, then unlocks it', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api
      ..on('GET /assignment/list', [
        FakeResponse(200, {
          'assignments': [
            _taskAssignment(submissionText: 'I read it twice.'),
          ],
        }),
      ])
      ..on('GET /assignment/1/attachments', [
        const FakeResponse(200, {'attachments': <Object?>[]}),
      ])
      ..on('POST /assignment/1/grade', [
        FakeResponse(200, {
          'assignment': _taskAssignment(
            submissionText: 'I read it twice.',
            isGraded: true,
            grade: 85,
            status: 'completed',
          ),
        }),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openHomework(tester);

    await tester.tap(find.text('Record yourself reading p.12'));
    await settle(tester);
    await tester.scrollUntilVisible(find.text('I read it twice.'), 200);
    expect(find.text('I read it twice.'), findsOneWidget);

    await tester.ensureVisible(find.text('Grade'));
    await settle(tester);
    await tester.tap(find.text('Grade'));
    await settle(tester);
    await tester.enterText(
      find.byKey(const ValueKey('grade-sheet-grade')),
      '85',
    );
    await tester.pump();
    await tester.tap(find.text('Save grade'));
    await settle(tester);

    final request = app.api.requestsTo('POST /assignment/1/grade').single;
    expect(app.api.bodyOf(request)['grade'], 85);
    expect(find.text('85 / 100'), findsOneWidget);

    app.api.on('DELETE /assignment/1/grade', [
      FakeResponse(200, {
        'assignment': _taskAssignment(submissionText: 'I read it twice.'),
      }),
    ]);
    await tester.ensureVisible(find.text('Unlock'));
    await settle(tester);
    await tester.tap(find.text('Unlock'));
    await settle(tester);
    expect(app.api.requestsTo('DELETE /assignment/1/grade'), isNotEmpty);
  });

  testWidgets('a student sees "My Homework" and submits a task', (
    tester,
  ) async {
    final app = await TestApp.create(session: _session(_studentJson));
    app.api
      ..on('GET /assignment/list', [
        FakeResponse(200, {
          'assignments': [_taskAssignment()],
        }),
      ])
      ..on('GET /assignment/1/attachments', [
        const FakeResponse(200, {'attachments': <Object?>[]}),
      ])
      ..on('POST /assignment/1/submit', [
        FakeResponse(200, {
          'assignment': _taskAssignment(submissionText: 'Done!'),
        }),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openHomework(tester, isTeacher: false);

    expect(find.text('My Homework'), findsOneWidget);
    expect(find.text('Your homework, all in one place.'), findsOneWidget);
    expect(find.text('Assign'), findsNothing);
    expect(find.text('All students'), findsNothing);

    await tester.tap(find.text('Record yourself reading p.12'));
    await settle(tester);

    await tester.enterText(
      find.widgetWithText(TextField, 'Write your answer…'),
      'Done!',
    );
    await tester.pump();
    await tester.ensureVisible(find.text('Submit'));
    await settle(tester);
    await tester.tap(find.text('Submit'));
    await settle(tester);

    final request = app.api.requestsTo('POST /assignment/1/submit').single;
    expect(app.api.bodyOf(request)['text'], 'Done!');
  });

  testWidgets(
    'a student sees a disabled start button for a pending test, and a result link for a completed one',
    (tester) async {
      final app = await TestApp.create(session: _session(_studentJson));
      app.api.on('GET /assignment/list', [
        FakeResponse(200, {
          'assignments': [
            _testAssignment(
              status: 'pending',
              score: null,
              total: null,
              percentage: null,
              resultId: null,
            ),
            _testAssignment(id: 3, title: 'Final'),
          ],
        }),
      ]);
      await tester.pumpWidget(app.widget);
      await settle(tester);
      await _openHomework(tester, isTeacher: false);

      await tester.tap(find.text('Midterm'));
      await settle(tester);
      final startButton = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Start test'),
      );
      expect(startButton.onPressed, isNull);
      expect(
        find.text('Taking tests from here is coming soon.'),
        findsOneWidget,
      );
      await tester.tap(find.byIcon(CupertinoIcons.back));
      await settle(tester);

      await tester.tap(find.text('Final'));
      await settle(tester);
      expect(find.text('80%'), findsOneWidget);
      expect(find.text('View result'), findsOneWidget);
    },
  );

  testWidgets('a teacher deletes a homework attachment', (tester) async {
    final app = await TestApp.create(session: _session(teacherJson));
    app.api
      ..on('GET /assignment/list', [
        FakeResponse(200, {
          'assignments': [_taskAssignment()],
        }),
      ])
      ..on('GET /assignment/1/attachments', [
        const FakeResponse(200, {
          'attachments': [
            {
              'ID': 10,
              'assignmentId': 1,
              'kind': 'material',
              'uploadedBy': 2,
              'fileName': 'instructions.pdf',
              'contentType': 'application/pdf',
              'sizeBytes': 1024,
              'downloadUrl': 'https://example.com/instructions.pdf',
            },
          ],
        }),
      ])
      ..on('DELETE /assignment/attachments/10', [
        const FakeResponse(200, {'message': 'Attachment deleted successfully'}),
      ]);
    await tester.pumpWidget(app.widget);
    await settle(tester);
    await _openHomework(tester);

    await tester.tap(find.text('Record yourself reading p.12'));
    await settle(tester);

    await tester.scrollUntilVisible(find.text('instructions.pdf'), 200);
    expect(find.text('instructions.pdf'), findsOneWidget);
    app.api.on('GET /assignment/1/attachments', [
      const FakeResponse(200, {'attachments': <Object?>[]}),
    ]);

    final deleteAttachmentButton = find.byKey(
      const ValueKey('attachment-delete-10'),
    );
    await tester.ensureVisible(deleteAttachmentButton);
    await settle(tester);
    await tester.tap(deleteAttachmentButton);
    await settle(tester);

    expect(app.api.requestsTo('DELETE /assignment/attachments/10'), isNotEmpty);
    expect(find.text('instructions.pdf'), findsNothing);
  });
}
