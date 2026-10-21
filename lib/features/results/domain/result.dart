/// Whether a question is multiple-choice or free text.
enum QuestionType {
  multipleChoice,
  text,
  unknown
  ;

  static QuestionType parse(Object? value) => switch (value) {
    'multiple_choice' => QuestionType.multipleChoice,
    'text' => QuestionType.text,
    _ => QuestionType.unknown,
  };

  /// The API's own spelling, for creating/editing a question.
  String get wireValue => switch (this) {
    QuestionType.multipleChoice => 'multiple_choice',
    QuestionType.text || QuestionType.unknown => 'text',
  };
}

/// One graded question in a [Result]'s breakdown.
class AnswerBreakdown {
  const AnswerBreakdown({
    required this.questionId,
    required this.question,
    required this.type,
    required this.answer,
    required this.isCorrect,
    this.rightAnswer,
  });

  factory AnswerBreakdown.fromJson(Map<String, dynamic> json) =>
      AnswerBreakdown(
        questionId: (json['questionId'] as num?)?.toInt() ?? 0,
        question: json['question'] as String? ?? '',
        type: QuestionType.parse(json['type']),
        answer: json['answer'] as String? ?? '',
        rightAnswer: json['rightAnswer'] as String?,
        isCorrect: json['isCorrect'] as bool? ?? false,
      );

  final int questionId;
  final String question;
  final QuestionType type;

  /// The option key ("a1".."a4") for a multiple-choice question, or the
  /// typed text for a text one.
  final String answer;

  /// Same shape as [answer]; null unless the API chose to include it.
  final String? rightAnswer;
  final bool isCorrect;
}

/// A test attempt: `GET /result/list` returns these without [answers];
/// `POST /result` and `GET /result/{id}` include the full breakdown.
class Result {
  const Result({
    required this.id,
    required this.testId,
    required this.studentId,
    required this.score,
    required this.total,
    required this.percentage,
    required this.isOvertime,
    this.startedAt,
    this.timeTakenSeconds,
    this.timeLimitMinutes,
    this.answers,
    this.createdAt,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    final rawAnswers = json['answers'];
    return Result(
      id: (json['ID'] as num?)?.toInt() ?? 0,
      testId: (json['testId'] as num?)?.toInt() ?? 0,
      // The API spells this userId; the app's own naming is studentId.
      studentId: (json['userId'] as num?)?.toInt() ?? 0,
      score: (json['score'] as num?)?.toInt() ?? 0,
      total: (json['total'] as num?)?.toInt() ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0,
      isOvertime: json['isOvertime'] as bool? ?? false,
      startedAt: DateTime.tryParse(json['startedAt'] as String? ?? ''),
      timeTakenSeconds: (json['timeTakenSeconds'] as num?)?.toInt(),
      timeLimitMinutes: (json['timeLimitMinutes'] as num?)?.toInt(),
      answers: rawAnswers is List
          ? [
              for (final item in rawAnswers)
                if (item is Map<String, dynamic>)
                  AnswerBreakdown.fromJson(item),
            ]
          : null,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
    );
  }

  final int id;
  final int testId;
  final int studentId;
  final int score;
  final int total;

  /// 0–100.
  final double percentage;
  final bool isOvertime;
  final DateTime? startedAt;

  /// Null when the test was submitted without being started (untimed
  /// tests only).
  final int? timeTakenSeconds;
  final int? timeLimitMinutes;

  /// Only present from `POST /result` and `GET /result/{id}`.
  final List<AnswerBreakdown>? answers;
  final DateTime? createdAt;
}
