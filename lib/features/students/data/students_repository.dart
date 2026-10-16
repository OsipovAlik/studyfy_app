import 'package:studify/core/network/api_client.dart';
import 'package:studify/features/students/domain/student.dart';

/// The school's student roster (teachers only).
class StudentsRepository {
  StudentsRepository(this._client);

  final ApiClient _client;

  /// `GET /students`: every user of the school, teachers included, so
  /// this filters to `role: student`. `subjectId` narrows to students
  /// enrolled in that subject.
  Future<List<Student>> list({int? subjectId}) async {
    final body = await _client.get(
      '/students',
      query: {'subjectId': ?subjectId},
    );
    final raw = body['users'];
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map<String, dynamic> && item['role'] == 'student')
          Student.fromJson(item),
    ];
  }

  /// `POST /register` (teachers): registers a student in the teacher's
  /// own school. The response omits the new user's ID, so the caller
  /// reloads [list] afterwards rather than trying to use it directly.
  Future<void> register({
    required String name,
    required String email,
    required String password,
    required int partnerId,
    required int subjectId,
    String? surname,
  }) => _client.post(
    '/register',
    data: {
      'name': name,
      if (surname != null && surname.isNotEmpty) 'surname': surname,
      'email': email,
      'password': password,
      'role': 'student',
      'partnerId': partnerId,
      'subjectId': subjectId,
    },
  );

  /// `DELETE /user/{id}` (teachers, students only). A teacher deleting a
  /// student must confirm with their own password.
  Future<void> delete(int studentId, {required String password}) =>
      _client.delete('/user/$studentId', data: {'password': password});
}
