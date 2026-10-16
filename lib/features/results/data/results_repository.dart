import 'package:studify/core/network/api_client.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/results/domain/question.dart';
import 'package:studify/features/results/domain/result.dart';
import 'package:studify/features/results/domain/test_summary.dart';

/// Test attempt results: a student's own, or (without `studentId`) every
/// result in the school for a teacher.
class ResultsRepository {
  ResultsRepository(this._client);

  final ApiClient _client;

  /// `GET /result/list`: summaries, newest first. `studentId` is
  /// teacher-only; a student always gets their own results regardless.
  Future<List<Result>> list({int? testId, int? studentId}) async {
    final body = await _client.get(
      '/result/list',
      query: {'testId': ?testId, 'studentId': ?studentId},
    );
    final raw = body['results'];
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map<String, dynamic>) Result.fromJson(item),
    ];
  }

  /// `GET /result/{id}`: a result with its full per-question breakdown.
  Future<Result> get(int resultId) async {
    final body = await _client.get('/result/$resultId');
    final result = body['result'];
    if (result is! Map<String, dynamic>) throw const ApiException();
    return Result.fromJson(result);
  }

  /// `GET /test/list` (any role): every test of the school, for
  /// resolving a result's `testId` to a title and for the test filter.
  Future<List<TestSummary>> listTests() async {
    final body = await _client.get('/test/list');
    final raw = body['tests'];
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map<String, dynamic>) TestSummary.fromJson(item),
    ];
  }

  /// `GET /question/list/{testId}`: note the response key is `data`, not
  /// `questions`.
  Future<List<Question>> listQuestions(int testId) async {
    final body = await _client.get('/question/list/$testId');
    final raw = body['data'];
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map<String, dynamic>) Question.fromJson(item),
    ];
  }
}
