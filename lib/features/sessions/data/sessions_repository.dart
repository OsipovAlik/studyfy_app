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
}
