/// Whether a [ClassSession] is a group class or a one-on-one.
enum SessionType {
  group,
  individual,
  unknown
  ;

  static SessionType parse(Object? value) => switch (value) {
    'group' => SessionType.group,
    'individual' => SessionType.individual,
    _ => SessionType.unknown,
  };
}

/// Matches [DateTime.weekday] via [dateWeekday] (Monday = 1 … Sunday = 7).
enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday
  ;

  factory Weekday.fromDate(DateTime date) => Weekday.values[date.weekday - 1];

  static Weekday? parse(Object? value) => switch (value) {
    'monday' => Weekday.monday,
    'tuesday' => Weekday.tuesday,
    'wednesday' => Weekday.wednesday,
    'thursday' => Weekday.thursday,
    'friday' => Weekday.friday,
    'saturday' => Weekday.saturday,
    'sunday' => Weekday.sunday,
    _ => null,
  };

  int get dateWeekday => index + 1;
}

/// A weekly slot a class meets in ("every Tuesday 15:00"), not a dated
/// event. `GET /session/my` and `/session/list` return these; the API
/// has no dates or durations, so the app works those out itself from
/// [dayOfWeek] and [startTime].
class ClassSession {
  const ClassSession({
    required this.id,
    required this.type,
    required this.dayOfWeek,
    required this.startTime,
    this.groupId,
    this.studentId,
    this.createdAt,
  });

  factory ClassSession.fromJson(Map<String, dynamic> json) => ClassSession(
    id: (json['ID'] as num?)?.toInt() ?? 0,
    type: SessionType.parse(json['type']),
    dayOfWeek: Weekday.parse(json['dayOfWeek']) ?? Weekday.monday,
    startTime: json['startTime'] as String? ?? '00:00',
    groupId: (json['groupId'] as num?)?.toInt(),
    studentId: (json['studentId'] as num?)?.toInt(),
    createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
  );

  final int id;
  final SessionType type;
  final Weekday dayOfWeek;

  /// `"HH:MM"`, 24-hour, with no time zone: the school's local time,
  /// shown as written and never converted.
  final String startTime;
  final int? groupId;
  final int? studentId;
  final DateTime? createdAt;

  /// Minutes since midnight, for sorting and "next session" math.
  int get startMinutes {
    final parts = startTime.split(':');
    final hours = int.tryParse(parts.elementAt(0)) ?? 0;
    final minutes = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return hours * 60 + minutes;
  }
}
