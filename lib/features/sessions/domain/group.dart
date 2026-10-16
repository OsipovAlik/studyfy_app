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

/// One student in a [GroupDetail]'s roster.
class GroupMember {
  const GroupMember({
    required this.id,
    required this.name,
    required this.surname,
  });

  factory GroupMember.fromJson(Map<String, dynamic> json) => GroupMember(
    id: (json['ID'] as num?)?.toInt() ?? 0,
    name: json['name'] as String? ?? '',
    surname: json['surname'] as String? ?? '',
  );

  final int id;
  final String name;
  final String surname;

  String get fullName =>
      [name, surname].where((part) => part.isNotEmpty).join(' ');
}

/// `GET /group/{groupId}`: a group with its member roster.
class GroupDetail {
  const GroupDetail({
    required this.id,
    required this.name,
    required this.students,
  });

  factory GroupDetail.fromJson(Map<String, dynamic> json) => GroupDetail(
    id: (json['ID'] as num?)?.toInt() ?? 0,
    name: json['name'] as String? ?? '',
    students: [
      for (final item in json['students'] as List? ?? const [])
        if (item is Map<String, dynamic>) GroupMember.fromJson(item),
    ],
  );

  final int id;
  final String name;
  final List<GroupMember> students;
}
