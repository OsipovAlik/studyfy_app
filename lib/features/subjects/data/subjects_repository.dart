import 'package:studify/core/network/api_client.dart';
import 'package:studify/features/subjects/domain/subject.dart';

/// The school's subjects (teachers manage them; students only see their
/// own via `/subject/my`, not used here).
class SubjectsRepository {
  SubjectsRepository(this._client);

  final ApiClient _client;

  /// `GET /subject/list` (any role): every subject of the school.
  Future<List<Subject>> list() async {
    final body = await _client.get('/subject/list');
    final raw = body['subjects'];
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map<String, dynamic>) Subject.fromJson(item),
    ];
  }

  /// `POST /subject` (teachers): creates a subject, switched off by
  /// default until activated.
  Future<Subject> create({required String name}) async {
    final body = await _client.post('/subject', data: {'name': name});
    return Subject.fromJson(body['subject'] as Map<String, dynamic>);
  }

  /// `PUT /subject/{id}` (teachers): renames a subject.
  Future<Subject> rename(int subjectId, {required String name}) async {
    final body = await _client.put(
      '/subject/$subjectId',
      data: {'name': name},
    );
    return Subject.fromJson(body['subject'] as Map<String, dynamic>);
  }

  /// `PATCH /subject/activate/{id}` (teachers): toggles `isActive`.
  Future<Subject> toggleActive(int subjectId) async {
    final body = await _client.patch('/subject/activate/$subjectId');
    return Subject.fromJson(body['subject'] as Map<String, dynamic>);
  }

  /// `DELETE /subject/{id}` (teachers): also deletes its levels, tests
  /// and questions.
  Future<void> delete(int subjectId) => _client.delete('/subject/$subjectId');
}
