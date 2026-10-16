import 'package:studify/core/network/api_client.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/sessions/domain/call_ticket.dart';
import 'package:studify/features/sessions/domain/class_session.dart';
import 'package:studify/features/sessions/domain/group.dart';

/// Class-schedule and video-call endpoints.
class SessionsRepository {
  SessionsRepository(this._client);

  final ApiClient _client;

  /// `GET /session/my`: the student's own individual + group classes.
  Future<List<ClassSession>> mySessions() async =>
      _parseSessions(await _client.get('/session/my'));

  /// `GET /session/list`: every class of the school (teachers).
  Future<List<ClassSession>> listSessions() async =>
      _parseSessions(await _client.get('/session/list'));

  static List<ClassSession> _parseSessions(Map<String, dynamic> body) {
    final raw = body['sessions'];
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map<String, dynamic>) ClassSession.fromJson(item),
    ];
  }

  /// `POST /session/{id}/join` → a LiveKit join ticket.
  Future<CallTicket> join(int sessionId) async {
    final body = await _client.post('/session/$sessionId/join');
    final call = body['call'];
    if (call is! Map<String, dynamic>) throw const ApiException();
    final ticket = CallTicket.fromJson(call);
    if (!ticket.isValid) throw const ApiException();
    return ticket;
  }

  /// `GET /group/list`: every group of the school, with member counts.
  Future<List<Group>> listGroups() async {
    final body = await _client.get('/group/list');
    final raw = body['groups'];
    if (raw is! List) return const [];
    return [
      for (final item in raw)
        if (item is Map<String, dynamic>) Group.fromJson(item),
    ];
  }

  /// Student id → full name (teachers only; `GET /students`).
  Future<Map<int, String>> studentNames() async {
    final body = await _client.get('/students');
    final raw = body['users'];
    if (raw is! List) return const {};
    return {
      for (final item in raw)
        if (item is Map<String, dynamic> && item['role'] == 'student')
          (item['ID'] as num).toInt(): [
            item['name'],
            item['surname'],
          ].whereType<String>().where((part) => part.isNotEmpty).join(' '),
    };
  }

  /// `POST /session` (teachers): schedules a new weekly class.
  Future<ClassSession> createSession(SessionDraft draft) async {
    final body = await _client.post('/session', data: draft.toJson());
    return _parseSession(body);
  }

  /// `PUT /session/{id}` (teachers): a full replace, same fields as
  /// [createSession].
  Future<ClassSession> updateSession(int sessionId, SessionDraft draft) async {
    final body = await _client.put(
      '/session/$sessionId',
      data: draft.toJson(),
    );
    return _parseSession(body);
  }

  /// `DELETE /session/{id}` (teachers).
  Future<void> deleteSession(int sessionId) =>
      _client.delete('/session/$sessionId');

  static ClassSession _parseSession(Map<String, dynamic> body) {
    final session = body['session'];
    if (session is! Map<String, dynamic>) throw const ApiException();
    return ClassSession.fromJson(session);
  }

  /// `POST /group` (teachers): creates a reusable roster, optionally
  /// with an initial set of members.
  Future<Group> createGroup({
    required String name,
    List<int>? studentIds,
  }) async {
    final body = await _client.post(
      '/group',
      data: {
        'name': name,
        if (studentIds != null && studentIds.isNotEmpty)
          'studentIds': studentIds,
      },
    );
    return _parseGroup(body);
  }

  /// `PUT /group/{id}` (teachers): renames a group.
  Future<Group> renameGroup(int groupId, String name) async {
    final body = await _client.put('/group/$groupId', data: {'name': name});
    return _parseGroup(body);
  }

  /// `DELETE /group/{id}` (teachers): also deletes the group's sessions.
  Future<void> deleteGroup(int groupId) => _client.delete('/group/$groupId');

  /// `GET /group/{id}` (any role): a group with its member roster.
  Future<GroupDetail> getGroup(int groupId) async {
    final body = await _client.get('/group/$groupId');
    final group = body['group'];
    if (group is! Map<String, dynamic>) throw const ApiException();
    return GroupDetail.fromJson(group);
  }

  /// `POST /group/{id}/students` (teachers): adding the same student
  /// twice is a no-op on the server.
  Future<void> addGroupMember(int groupId, int studentId) => _client.post(
    '/group/$groupId/students',
    data: {'studentId': studentId},
  );

  /// `DELETE /group/{id}/students/{studentId}` (teachers).
  Future<void> removeGroupMember(int groupId, int studentId) =>
      _client.delete('/group/$groupId/students/$studentId');

  static Group _parseGroup(Map<String, dynamic> body) {
    final group = body['group'];
    if (group is! Map<String, dynamic>) throw const ApiException();
    return Group.fromJson(group);
  }
}

/// What `POST /session` and `PUT /session/{id}` take: a weekly slot,
/// either [SessionType.group] (with [groupId]) or [SessionType.individual]
/// (with [studentId]).
class SessionDraft {
  const SessionDraft({
    required this.type,
    required this.dayOfWeek,
    required this.startTime,
    this.groupId,
    this.studentId,
  });

  final SessionType type;
  final Weekday dayOfWeek;

  /// `"HH:MM"`, 24-hour.
  final String startTime;
  final int? groupId;
  final int? studentId;

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'dayOfWeek': dayOfWeek.name,
    'startTime': startTime,
    if (type == SessionType.group) 'groupId': groupId,
    if (type == SessionType.individual) 'studentId': studentId,
  };
}
