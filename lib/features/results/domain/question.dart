import 'package:studify/features/results/domain/result.dart';

/// A row of `GET /question/list/{testId}`, used to resolve a
/// multiple-choice [AnswerBreakdown.answer]/[AnswerBreakdown.rightAnswer]
/// option key ("a1".."a4") to its text.
class Question {
  const Question({
    required this.id,
    required this.question,
    required this.type,
    required this.options,
  });

  factory Question.fromJson(Map<String, dynamic> json) => Question(
    id: (json['ID'] as num?)?.toInt() ?? 0,
    question: json['question'] as String? ?? '',
    type: QuestionType.parse(json['type']),
    options: {
      for (final key in const ['a1', 'a2', 'a3', 'a4'])
        if ((json[key] as String? ?? '').isNotEmpty) key: json[key] as String,
    },
  );

  final int id;
  final String question;
  final QuestionType type;

  /// Option key ("a1".."a4") → its text; empty for a [QuestionType.text]
  /// question.
  final Map<String, String> options;

  /// The text for option [key], or the key itself if this question has
  /// no such option (e.g. it was edited or deleted since the attempt).
  String optionLabel(String key) => options[key] ?? key;
}
