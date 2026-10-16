/// A row of `GET /subject/list` (any role): one of the school's subjects.
class Subject {
  const Subject({required this.id, required this.name, this.createdAt});

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
    id: (json['ID'] as num?)?.toInt() ?? 0,
    name: json['name'] as String? ?? '',
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
  );

  final int id;
  final String name;
  final DateTime? createdAt;
}
