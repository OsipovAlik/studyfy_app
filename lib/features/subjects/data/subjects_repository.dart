import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studify/core/network/api_client.dart';
import 'package:studify/features/subjects/domain/subject.dart';

/// The school's subjects: teachers manage them; students only see their
/// own via `/subject/my` (used for the home banner picture, where a
/// student's real `mainImageUrl` only comes back from that endpoint).
class SubjectsRepository {
  SubjectsRepository(this._client);

  final ApiClient _client;

  List<Subject> _subjectsFrom(Map<String, dynamic> body) {
    final raw = body['subjects'];
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map<String, dynamic>) Subject.fromJson(item),
    ];
  }

  /// `GET /subject/list` (any role): every subject of the school. A
  /// student's own `mainImageUrl` always comes back blank here — use
  /// [listMine] for that.
  Future<List<Subject>> list() async {
    final body = await _client.get('/subject/list');
    return _subjectsFrom(body);
  }

  /// `GET /subject/my` (students): just their own subjects, with their
  /// real `mainImageUrl`.
  Future<List<Subject>> listMine() async {
    final body = await _client.get('/subject/my');
    return _subjectsFrom(body);
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

  /// `PUT /subject/{id}/main-image` (owner, teacher): multipart/form-data.
  /// JPEG, PNG, GIF or WebP, up to 10 MB. The old image, if any, is
  /// deleted automatically.
  Future<Subject> setMainImage(int subjectId, {required XFile image}) async {
    final body = await _client.put(
      '/subject/$subjectId/main-image',
      data: FormData.fromMap({
        'image': MultipartFile.fromBytes(
          await image.readAsBytes(),
          filename: image.name,
        ),
      }),
    );
    return Subject.fromJson(body['subject'] as Map<String, dynamic>);
  }

  /// `DELETE /subject/{id}/main-image` (owner, teacher).
  Future<Subject> removeMainImage(int subjectId) async {
    final body = await _client.delete('/subject/$subjectId/main-image');
    return Subject.fromJson(body['subject'] as Map<String, dynamic>);
  }
}
