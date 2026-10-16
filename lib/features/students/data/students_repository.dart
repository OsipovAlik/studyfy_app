import 'package:studify/core/network/api_client.dart';
import 'package:studify/features/students/domain/student.dart';

/// The school's student roster (teachers only).
class StudentsRepository {
  StudentsRepository(this._client);

  final ApiClient _client;

  /// `GET /students`: every user of the school, teachers included, so
  /// this filters to `role: student`.
  Future<List<Student>> list() async {
    final body = await _client.get('/students');
    final raw = body['users'];
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map<String, dynamic> && item['role'] == 'student')
          Student.fromJson(item),
    ];
  }
}
