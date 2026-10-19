/// A row of `GET /test/list` (any role; students only ever get active
/// tests) or the result of creating/updating/generating one.
class Test {
  const Test({
    required this.id,
    required this.title,
    required this.subjectId,
    required this.levelId,
    required this.isActive,
    this.timeLimitMinutes,
  });

  factory Test.fromJson(Map<String, dynamic> json) => Test(
    id: (json['ID'] as num?)?.toInt() ?? 0,
    title: json['title'] as String? ?? '',
    subjectId: (json['subjectId'] as num?)?.toInt() ?? 0,
    levelId: (json['levelId'] as num?)?.toInt() ?? 0,
    isActive: json['isActive'] as bool? ?? false,
    timeLimitMinutes: (json['timeLimitMinutes'] as num?)?.toInt(),
  );

  final int id;
  final String title;
  final int subjectId;
  final int levelId;

  /// New and AI-drafted tests start inactive; students never see one
  /// until a teacher publishes it.
  final bool isActive;

  /// Null means untimed.
  final int? timeLimitMinutes;
}
