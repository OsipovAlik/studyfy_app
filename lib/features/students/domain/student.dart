/// A row of `GET /students` (teachers only), filtered to `role: student`.
class Student {
  const Student({
    required this.id,
    required this.name,
    required this.surname,
    required this.email,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    id: (json['ID'] as num?)?.toInt() ?? 0,
    name: json['name'] as String? ?? '',
    surname: json['surname'] as String? ?? '',
    email: json['email'] as String? ?? '',
  );

  final int id;
  final String name;
  final String surname;
  final String email;

  String get fullName => [name, surname].where((s) => s.isNotEmpty).join(' ');
}
