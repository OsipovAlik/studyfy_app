/// A reusable roster of students (`GET /group/list`).
class Group {
  const Group({
    required this.id,
    required this.name,
    required this.memberCount,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
    id: (json['ID'] as num?)?.toInt() ?? 0,
    name: json['name'] as String? ?? '',
    memberCount: (json['memberCount'] as num?)?.toInt() ?? 0,
  );

  final int id;
  final String name;
  final int memberCount;
}
