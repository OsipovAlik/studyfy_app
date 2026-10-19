import 'package:studify/core/network/api_client.dart';
import 'package:studify/features/subjects/domain/test.dart';

/// The result of `POST /test/generate`: the drafted (inactive) test,
/// plus how many questions were asked for vs. actually produced — the
/// AI can fall short of [requested].
class GeneratedTest {
  const GeneratedTest({
    required this.test,
    required this.requested,
    required this.generated,
  });

  final Test test;
  final int requested;
  final int generated;
}

/// A subject's tests; teachers manage them, students only ever see
/// active ones.
class TestsRepository {
  TestsRepository(this._client);

  final ApiClient _client;

  /// AI generation "takes up to about a minute" per the API docs; the
  /// client's default receive timeout (30s) would cut that off.
  static const _generateTimeout = Duration(minutes: 2);

  /// `GET /test/list` (any role). Omitting [levelId] returns every test
  /// of the school (used by the homework "assign a test" picker);
  /// students only ever get active ones either way.
  Future<List<Test>> list({int? levelId}) async {
    final body = await _client.get(
      '/test/list',
      query: {'levelId': ?levelId},
    );
    final raw = body['tests'];
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map<String, dynamic>) Test.fromJson(item),
    ];
  }

  /// `POST /test` (teachers): created inactive.
  Future<Test> create({
    required String title,
    required int subjectId,
    required int levelId,
    int? timeLimitMinutes,
  }) async {
    final body = await _client.post(
      '/test',
      data: {
        'title': title,
        'subjectId': subjectId,
        'levelId': levelId,
        'timeLimitMinutes': ?timeLimitMinutes,
      },
    );
    return Test.fromJson(body['test'] as Map<String, dynamic>);
  }

  /// `PATCH /test/{testId}` (teachers): renames, retimes (0 removes the
  /// limit) and/or activates/deactivates.
  Future<Test> update(
    int testId, {
    String? title,
    bool? isActive,
    int? timeLimitMinutes,
  }) async {
    final body = await _client.patch(
      '/test/$testId',
      data: {
        'title': ?title,
        'isActive': ?isActive,
        'timeLimitMinutes': ?timeLimitMinutes,
      },
    );
    return Test.fromJson(body['test'] as Map<String, dynamic>);
  }

  /// `DELETE /test/{testId}` (teachers): also deletes its questions.
  Future<void> delete(int testId) => _client.delete('/test/$testId');

  /// `POST /test/generate` (teachers): drafts an inactive test with AI
  /// questions for the teacher to review and publish. Rate-limited to
  /// 20/hour/teacher (`429`); `503` means AI generation is switched
  /// off; `502` is a transient failure worth retrying.
  Future<GeneratedTest> generate({
    required int subjectId,
    required int levelId,
    required String topic,
    required String cefrLevel,
    required int questionCount,
    required String questionType,
    String? title,
    String? instructions,
    int? timeLimitMinutes,
  }) async {
    final body = await _client.post(
      '/test/generate',
      receiveTimeout: _generateTimeout,
      data: {
        'subjectId': subjectId,
        'levelId': levelId,
        'topic': topic,
        'cefrLevel': cefrLevel,
        'questionCount': questionCount,
        'questionType': questionType,
        'title': ?(title != null && title.isNotEmpty ? title : null),
        'instructions': ?(instructions != null && instructions.isNotEmpty
            ? instructions
            : null),
        'timeLimitMinutes': ?timeLimitMinutes,
      },
    );
    return GeneratedTest(
      test: Test.fromJson(body['test'] as Map<String, dynamic>),
      requested: (body['requested'] as num?)?.toInt() ?? questionCount,
      generated: (body['generated'] as num?)?.toInt() ?? 0,
    );
  }
}
