import 'package:studify/features/results/domain/result.dart';

/// A row of `GET /question/list/{testId}` or `GET /question/{id}`. Used
/// both to resolve a multiple-choice [AnswerBreakdown.answer]/
/// [AnswerBreakdown.rightAnswer] option key ("a1".."a4") to its text,
/// and (for owners/teachers, who alone receive [rightAnswer]) to manage
/// a test's questions.
class Question {
  const Question({
    required this.id,
    required this.testId,
    required this.question,
    required this.type,
    required this.options,
    this.rightAnswer,
    this.image,
    this.imageUrl,
    this.video,
    this.createdAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final video = json['video'] as String?;
    return Question(
      id: (json['ID'] as num?)?.toInt() ?? 0,
      testId: (json['testId'] as num?)?.toInt() ?? 0,
      question: json['question'] as String? ?? '',
      type: QuestionType.parse(json['type']),
      options: {
        for (final key in const ['a1', 'a2', 'a3', 'a4'])
          if ((json[key] as String? ?? '').isNotEmpty) key: json[key] as String,
      },
      // Only present for owners and teachers; never sent to students.
      rightAnswer: json['rightAnswer'] as String?,
      image: json['image'] as String?,
      imageUrl: json['imageUrl'] as String?,
      video: (video == null || video.isEmpty) ? null : video,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
    );
  }

  final int id;
  final int testId;
  final String question;
  final QuestionType type;

  /// Option key ("a1".."a4") → its text; empty for a [QuestionType.text]
  /// question.
  final Map<String, String> options;

  /// For [QuestionType.multipleChoice], the correct option key
  /// ("a1".."a4"); for [QuestionType.text], the expected answer text.
  /// Only present for owners and teachers.
  final String? rightAnswer;

  /// Storage path of the optional image; use [imageUrl] to display it.
  final String? image;

  /// A temporary (12 h) link to [image]; re-fetch the question for a
  /// fresh one.
  final String? imageUrl;
  final String? video;
  final DateTime? createdAt;

  /// The text for option [key], or the key itself if this question has
  /// no such option (e.g. it was edited or deleted since the attempt).
  String optionLabel(String key) => options[key] ?? key;
}
