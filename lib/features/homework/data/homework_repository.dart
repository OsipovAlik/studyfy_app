import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:studify/core/network/api_client.dart';
import 'package:studify/features/homework/domain/assignment.dart';
import 'package:studify/features/homework/domain/homework_attachment.dart';

/// Homework: assignments (a test or a task) and their files. Teachers
/// create, update, grade and delete; students submit and upload their
/// own files.
class HomeworkRepository {
  HomeworkRepository(this._client);

  final ApiClient _client;

  List<Assignment> _assignmentsFrom(Map<String, dynamic> body) {
    final raw = body['assignments'];
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map<String, dynamic>) Assignment.fromJson(item),
    ];
  }

  /// `GET /assignment/list` (any role): a student gets only their own.
  /// Lists are complete (no pagination, no status filter needed here —
  /// filtering happens client-side so the status tabs' counts stay in
  /// sync with each other).
  Future<List<Assignment>> list() async {
    final body = await _client.get('/assignment/list');
    return _assignmentsFrom(body);
  }

  /// `GET /assignment/{id}` (any role).
  Future<Assignment> get(int id) async {
    final body = await _client.get('/assignment/$id');
    return Assignment.fromJson(body['assignment'] as Map<String, dynamic>);
  }

  /// `POST /assignment` (teachers), test variant: assigns an existing
  /// active test to students and/or whole groups. One [Assignment]
  /// comes back per student.
  Future<List<Assignment>> createTestHomework({
    required int testId,
    List<int>? studentIds,
    List<int>? groupIds,
    DateTime? dueDate,
    String? note,
  }) async {
    final body = await _client.post(
      '/assignment',
      data: {
        'testId': testId,
        'studentIds': ?studentIds,
        'groupIds': ?groupIds,
        'dueDate': ?dueDate?.toUtc().toIso8601String(),
        'note': ?note,
      },
    );
    return _assignmentsFrom(
      body['result'] as Map<String, dynamic>? ?? const {},
    );
  }

  /// `POST /assignment` (teachers), task variant: a written/file task
  /// the teacher grades later.
  Future<List<Assignment>> createTaskHomework({
    required String title,
    int? maxGrade,
    List<int>? studentIds,
    List<int>? groupIds,
    DateTime? dueDate,
    String? note,
  }) async {
    final body = await _client.post(
      '/assignment',
      data: {
        'title': title,
        'maxGrade': ?maxGrade,
        'studentIds': ?studentIds,
        'groupIds': ?groupIds,
        'dueDate': ?dueDate?.toUtc().toIso8601String(),
        'note': ?note,
      },
    );
    return _assignmentsFrom(
      body['result'] as Map<String, dynamic>? ?? const {},
    );
  }

  /// `PUT /assignment/{id}` (teachers). The API always expects `note`
  /// (clearing it means sending an empty string); [dueDate] of `null`
  /// with [clearDueDate] removes the due date, omitting both leaves it
  /// unchanged.
  Future<Assignment> update(
    int id, {
    String note = '',
    String? title,
    int? maxGrade,
    DateTime? dueDate,
    bool clearDueDate = false,
  }) async {
    final body = await _client.put(
      '/assignment/$id',
      data: {
        'note': note,
        'title': ?title,
        'maxGrade': ?maxGrade,
        if (clearDueDate)
          'dueDate': null
        else
          'dueDate': ?dueDate?.toUtc().toIso8601String(),
      },
    );
    return Assignment.fromJson(body['assignment'] as Map<String, dynamic>);
  }

  /// `DELETE /assignment/{id}` (teachers).
  Future<void> delete(int id) => _client.delete('/assignment/$id');

  /// `POST /assignment/{id}/submit` (students): hands in a task; can be
  /// re-sent to edit until graded.
  Future<Assignment> submit(int id, {String? text}) async {
    final body = await _client.post(
      '/assignment/$id/submit',
      data: {'text': ?text},
    );
    return Assignment.fromJson(body['assignment'] as Map<String, dynamic>);
  }

  /// `POST /assignment/{id}/grade` (teachers): locks the submission.
  Future<Assignment> grade(
    int id, {
    required int grade,
    String? feedback,
  }) async {
    final body = await _client.post(
      '/assignment/$id/grade',
      data: {'grade': grade, 'feedback': ?feedback},
    );
    return Assignment.fromJson(body['assignment'] as Map<String, dynamic>);
  }

  /// `DELETE /assignment/{id}/grade` (teachers): unlocks it.
  Future<Assignment> unlockGrade(int id) async {
    final body = await _client.delete('/assignment/$id/grade');
    return Assignment.fromJson(body['assignment'] as Map<String, dynamic>);
  }

  /// `GET /assignment/{id}/attachments` (any role): the `downloadUrl`s
  /// are freshly signed on every call — don't cache this list.
  Future<List<HomeworkAttachment>> listAttachments(int assignmentId) async {
    final body = await _client.get('/assignment/$assignmentId/attachments');
    final raw = body['attachments'];
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map<String, dynamic>) HomeworkAttachment.fromJson(item),
    ];
  }

  /// `POST /assignment/attachments` (teachers, students): one file,
  /// attached to one or more assignments at once (e.g. a teacher's
  /// material sent to a whole group's copies) — one [HomeworkAttachment]
  /// comes back per assignment it landed on.
  Future<List<HomeworkAttachment>> uploadAttachment({
    required List<int> assignmentIds,
    required PlatformFile file,
  }) async {
    final bytes = await file.readAsBytes();
    final body = await _client.post(
      '/assignment/attachments',
      data: FormData.fromMap({
        'assignmentIds': assignmentIds,
        'file': MultipartFile.fromBytes(bytes, filename: file.name),
      }),
    );
    final raw = body['attachments'];
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map<String, dynamic>) HomeworkAttachment.fromJson(item),
    ];
  }

  /// `DELETE /assignment/attachments/{attachmentId}` (teachers; students
  /// for their own file, until the task is graded).
  Future<void> deleteAttachment(int attachmentId) =>
      _client.delete('/assignment/attachments/$attachmentId');
}
