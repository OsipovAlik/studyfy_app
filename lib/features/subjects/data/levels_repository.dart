import 'package:studify/core/network/api_client.dart';
import 'package:studify/features/subjects/domain/level.dart';

/// A subject's levels (e.g. A1, A2…); teachers manage them.
class LevelsRepository {
  LevelsRepository(this._client);

  final ApiClient _client;

  /// `GET /level/list/{subjectId}` (any role).
  Future<List<Level>> list(int subjectId) async {
    final body = await _client.get('/level/list/$subjectId');
    final raw = body['levels'];
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map<String, dynamic>) Level.fromJson(item),
    ];
  }

  /// `POST /level` (teachers).
  Future<Level> create({required int subjectId, required String name}) async {
    final body = await _client.post(
      '/level',
      data: {'subjectId': subjectId, 'name': name},
    );
    return Level.fromJson(body['level'] as Map<String, dynamic>);
  }

  /// `PUT /level/{levelId}` (teachers): renames a level. The response
  /// puts the level under the key `subject`, not `level`.
  Future<Level> rename(int levelId, {required String name}) async {
    final body = await _client.put('/level/$levelId', data: {'name': name});
    return Level.fromJson(body['subject'] as Map<String, dynamic>);
  }

  /// `DELETE /level/{levelId}` (teachers): also deletes its tests and
  /// questions.
  Future<void> delete(int levelId) => _client.delete('/level/$levelId');
}
