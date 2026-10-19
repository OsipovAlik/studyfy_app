/// A row of `GET /subject/list` (any role): one of the school's subjects.
class Subject {
  const Subject({
    required this.id,
    required this.name,
    this.isActive = false,
    this.createdAt,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
    id: (json['ID'] as num?)?.toInt() ?? 0,
    name: json['name'] as String? ?? '',
    isActive: json['isActive'] as bool? ?? false,
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
  );

  final int id;
  final String name;

  /// New subjects start inactive. This doesn't hide a subject from
  /// students — it's only shown to teachers as a status they manage.
  final bool isActive;
  final DateTime? createdAt;
}
