enum UserRole {
  student,
  teacher,
  admin,
  unknown
  ;

  static UserRole parse(Object? value) => switch (value) {
    'student' => UserRole.student,
    'teacher' => UserRole.teacher,
    'admin' => UserRole.admin,
    _ => UserRole.unknown,
  };
}

/// The signed-in user, from `GET /user/details`.
///
/// Note: this object uses a lowercase `id`, unlike most API objects.
class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.surname = '',
    this.partnerId,
    this.partnerName = '',
    this.createdAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    id: (json['id'] as num?)?.toInt() ?? 0,
    name: json['name'] as String? ?? '',
    surname: json['surname'] as String? ?? '',
    email: json['email'] as String? ?? '',
    role: UserRole.parse(json['role']),
    partnerId: (json['partnerId'] as num?)?.toInt(),
    partnerName: json['partnerName'] as String? ?? '',
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
  );

  final int id;
  final String name;
  final String surname;
  final String email;
  final UserRole role;

  /// The user's school. Admins have none.
  final int? partnerId;
  final String partnerName;
  final DateTime? createdAt;

  String get fullName => [name, surname].where((s) => s.isNotEmpty).join(' ');

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'surname': surname,
    'email': email,
    'role': role.name,
    'partnerId': partnerId,
    'partnerName': partnerName,
    'created_at': createdAt?.toUtc().toIso8601String(),
  };
}
