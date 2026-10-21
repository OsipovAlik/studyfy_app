import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:studify/core/network/api_client.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/results/domain/question.dart';
import 'package:studify/features/results/domain/result.dart';

/// A test's questions; any role can list them (students don't receive
/// [Question.rightAnswer]), only the test's owner or a teacher can
/// manage them.
class QuestionsRepository {
  QuestionsRepository(this._client);

  final ApiClient _client;

  /// `GET /question/list/{testId}`: note the response key is `data`,
  /// not `questions`.
  Future<List<Question>> list(int testId) async {
    final body = await _client.get('/question/list/$testId');
    final raw = body['data'];
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map<String, dynamic>) Question.fromJson(item),
    ];
  }

  /// `GET /question/{qId}`.
  Future<Question> get(int questionId) async {
    final body = await _client.get('/question/$questionId');
    final question = body['question'] ?? body['data'];
    if (question is! Map<String, dynamic>) throw const ApiException();
    return Question.fromJson(question);
  }

  /// `POST /question` (owner, teacher): multipart/form-data. For
  /// [QuestionType.multipleChoice], [a1] and [a2] are required, [a3]
  /// and [a4] optional, and [rightAnswer] must be one of "a1".."a4";
  /// for [QuestionType.text], the options are unused and [rightAnswer]
  /// is the expected answer.
  Future<Question> create({
    required int testId,
    required String question,
    required QuestionType type,
    required String rightAnswer,
    String? a1,
    String? a2,
    String? a3,
    String? a4,
    PlatformFile? image,
    String? video,
  }) async {
    final body = await _client.post(
      '/question',
      data: FormData.fromMap({
        'testId': '$testId',
        'question': question,
        'type': type.wireValue,
        'a1': ?a1,
        'a2': ?a2,
        'a3': ?a3,
        'a4': ?a4,
        'rightAnswer': rightAnswer,
        'video': ?video,
        if (image != null)
          'image': MultipartFile.fromBytes(
            await image.readAsBytes(),
            filename: image.name,
          ),
      }),
    );
    return Question.fromJson(body['question'] as Map<String, dynamic>);
  }

  /// `PATCH /question/{qId}` (owner, teacher): JSON, or multipart when
  /// [image] replaces the current one.
  Future<Question> update(
    int questionId, {
    String? question,
    QuestionType? type,
    String? a1,
    String? a2,
    String? a3,
    String? a4,
    String? rightAnswer,
    PlatformFile? image,
    String? video,
  }) async {
    final fields = <String, dynamic>{
      'question': ?question,
      'type': ?type?.wireValue,
      'a1': ?a1,
      'a2': ?a2,
      'a3': ?a3,
      'a4': ?a4,
      'rightAnswer': ?rightAnswer,
      'video': ?video,
    };
    final body = await _client.patch(
      '/question/$questionId',
      data: image == null
          ? fields
          : FormData.fromMap({
              ...fields,
              'image': MultipartFile.fromBytes(
                await image.readAsBytes(),
                filename: image.name,
              ),
            }),
    );
    return Question.fromJson(body['question'] as Map<String, dynamic>);
  }

  /// `DELETE /question/{qId}` (owner, teacher).
  Future<void> delete(int questionId) =>
      _client.delete('/question/$questionId');
}
