/// Whether a homework item is an existing test, or a task the student
/// hands in for the teacher to grade.
enum AssignmentType {
  test,
  task,
  unknown
  ;

  static AssignmentType fromJson(String? value) => switch (value) {
    'test' => AssignmentType.test,
    'task' => AssignmentType.task,
    _ => AssignmentType.unknown,
  };
}

/// Computed by the server: `overdue` is `pending` past its due date;
/// `completed` covers a submitted/graded task or a taken test.
enum AssignmentStatus {
  pending,
  overdue,
  completed,
  unknown
  ;

  static AssignmentStatus fromJson(String? value) => switch (value) {
    'pending' => AssignmentStatus.pending,
    'overdue' => AssignmentStatus.overdue,
    'completed' => AssignmentStatus.completed,
    _ => AssignmentStatus.unknown,
  };
}

/// A row of `GET /assignment/list` or `GET /assignment/{id}`: one
/// homework item for one student (even one created for a whole group
/// becomes one of these per member).
class Assignment {
  const Assignment({
    required this.id,
    required this.type,
    required this.title,
    required this.status,
    required this.studentId,
    required this.studentName,
    required this.studentSurname,
    this.testId,
    this.testIsActive = false,
    this.testTimeLimitMinutes,
    this.dueDate,
    this.note,
    this.isLate = false,
    this.resultId,
    this.submissionText,
    this.isGraded = false,
    this.maxGrade,
    this.grade,
    this.feedback,
    this.score,
    this.total,
    this.percentage,
    this.createdAt,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) => Assignment(
    id: (json['ID'] as num?)?.toInt() ?? 0,
    type: AssignmentType.fromJson(json['type'] as String?),
    title: json['title'] as String? ?? '',
    status: AssignmentStatus.fromJson(json['status'] as String?),
    studentId: (json['studentId'] as num?)?.toInt() ?? 0,
    studentName: json['studentName'] as String? ?? '',
    studentSurname: json['studentSurname'] as String? ?? '',
    testId: (json['testId'] as num?)?.toInt(),
    testIsActive: json['testIsActive'] as bool? ?? false,
    testTimeLimitMinutes: (json['testTimeLimitMinutes'] as num?)?.toInt(),
    dueDate: DateTime.tryParse(json['dueDate'] as String? ?? ''),
    note: json['note'] as String?,
    isLate: json['isLate'] as bool? ?? false,
    resultId: (json['resultId'] as num?)?.toInt(),
    submissionText: json['submissionText'] as String?,
    isGraded: json['isGraded'] as bool? ?? false,
    maxGrade: (json['maxGrade'] as num?)?.toInt(),
    grade: (json['grade'] as num?)?.toInt(),
    feedback: json['feedback'] as String?,
    score: (json['score'] as num?)?.toInt(),
    total: (json['total'] as num?)?.toInt(),
    percentage: (json['percentage'] as num?)?.toDouble(),
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
  );

  final int id;
  final AssignmentType type;

  /// The test's own title for `test` homework; the teacher's own title
  /// for `task` homework.
  final String title;
  final AssignmentStatus status;

  final int studentId;
  final String studentName;
  final String studentSurname;

  /// `test` homework only.
  final int? testId;
  final bool testIsActive;
  final int? testTimeLimitMinutes;

  final DateTime? dueDate;
  final String? note;
  final bool isLate;

  /// `test` homework only, once taken: the result to show full detail.
  final int? resultId;

  /// `task` homework only.
  final String? submissionText;
  final bool isGraded;
  final int? maxGrade;
  final int? grade;
  final String? feedback;

  /// Filled once completed, for either type.
  final int? score;
  final int? total;
  final double? percentage;

  final DateTime? createdAt;

  String get studentFullName => [
    studentName,
    studentSurname,
  ].where((p) => p.isNotEmpty).join(' ');
}
