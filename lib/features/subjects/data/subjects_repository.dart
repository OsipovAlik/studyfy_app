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
}
