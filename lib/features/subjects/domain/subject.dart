/// A row of `GET /subject/list` (owner/teacher) or `GET /subject/my`
/// (a student's own).
class Subject {
  const Subject({
    required this.id,
    required this.name,
    this.isActive = false,
    this.mainImageUrl = '',
    this.createdAt,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
    id: (json['ID'] as num?)?.toInt() ?? 0,
    name: json['name'] as String? ?? '',
    isActive: json['isActive'] as bool? ?? false,
    mainImageUrl: json['mainImageUrl'] as String? ?? '',
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
  );

  final int id;
  final String name;

  /// New subjects start inactive. This doesn't hide a subject from
  /// students — it's only shown to teachers as a status they manage.
  final bool isActive;

  /// Shown on the right of the home banner, to the owner/teacher and to
  /// this subject's students. Empty when none is set. `GET /subject/list`
  /// always blanks this for a student — fetch `GET /subject/my` for
  /// their real one. The link is temporary (12 h); don't cache it.
  final String mainImageUrl;
  final DateTime? createdAt;
}
