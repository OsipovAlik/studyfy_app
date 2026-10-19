/// A row of `GET /level/list/{subjectId}` (any role): one level of a
/// subject (e.g. A1, A2…).
class Level {
  const Level({required this.id, required this.subjectId, required this.name});

  factory Level.fromJson(Map<String, dynamic> json) => Level(
    id: (json['ID'] as num?)?.toInt() ?? 0,
    subjectId: (json['subjectId'] as num?)?.toInt() ?? 0,
    name: json['name'] as String? ?? '',
  );

  final int id;
  final int subjectId;
  final String name;
}
