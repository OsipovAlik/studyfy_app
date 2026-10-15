import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/auth/auth_controller.dart';
import 'package:studify/features/auth/domain/user_profile.dart';
import 'package:studify/features/sessions/data/sessions_repository.dart';
import 'package:studify/features/sessions/domain/call_ticket.dart';
import 'package:studify/features/sessions/domain/class_session.dart';
import 'package:studify/features/sessions/domain/group.dart';
import 'package:studify/features/sessions/session_display.dart';
import 'package:studify/l10n/app_localizations.dart';

/// When a [ClassSession] next meets, counting from now.
class NextOccurrence {
  const NextOccurrence({
    required this.session,
    required this.date,
    required this.isHappeningNow,
  });

  final ClassSession session;

  /// The calendar date of that occurrence.
  final DateTime date;

  /// Started in the last hour and hasn't ended yet (the API gives no
  /// class length, so the app assumes one hour).
  final bool isHappeningNow;
}

/// Loads the signed-in user's class schedule (their own for a student,
/// the whole school for a teacher) and resolves group/student names.
class TimetableController extends ChangeNotifier {
  TimetableController({
    required SessionsRepository repository,
    required AuthController auth,
  }) : _repository = repository,
       _auth = auth,
       _lastUserId = auth.user?.id {
    _auth.addListener(_handleAuthChange);
  }

  /// A class is treated as still running for this long after it starts,
  /// since the API has no end time.
  static const assumedDuration = Duration(hours: 1);

  final SessionsRepository _repository;
  final AuthController _auth;
  int? _lastUserId;

  bool _loading = false;
  bool _loaded = false;
  bool _hasError = false;
  List<ClassSession> _sessions = const [];
  List<Group> _groups = const [];
  Map<int, String> _groupNames = const {};
  Map<int, String> _studentNames = const {};

  bool get isLoading => _loading;
  bool get hasError => _hasError;
  List<ClassSession> get sessions => _sessions;

  /// Every group of the school (`GET /group/list`; available to any
  /// signed-in role).
  List<Group> get groups => _groups;

  bool get _isTeacher => _auth.user?.role == UserRole.teacher;

  @override
  void dispose() {
    _auth.removeListener(_handleAuthChange);
    super.dispose();
  }

  /// A different account signed in (or out): forget the previous
  /// account's schedule so [ensureLoaded] fetches it again.
  void _handleAuthChange() {
    final userId = _auth.user?.id;
    if (userId == _lastUserId) return;
    _lastUserId = userId;
    _loaded = false;
    _hasError = false;
    _sessions = const [];
    _groups = const [];
    _groupNames = const {};
    _studentNames = const {};
    notifyListeners();
  }

  /// Loads once; later calls are no-ops while already loaded or loading.
  Future<void> ensureLoaded() => _loaded || _loading ? Future.value() : _load();

  Future<void> reload() => _load();

  Future<void> _load() async {
    _loading = true;
    _hasError = false;
    // ensureLoaded() is normally called from initState(): yield first, so
    // this notification never lands mid-build.
    await Future<void>.delayed(Duration.zero);
    notifyListeners();
    try {
      final isTeacher = _isTeacher;
      final sessionsFuture = isTeacher
          ? _repository.listSessions()
          : _repository.mySessions();
      final results = await Future.wait([
        sessionsFuture,
        _repository.listGroups(),
        if (isTeacher) _repository.studentNames(),
      ]);
      final groups = results[1] as List<Group>;
      _sessions = results[0] as List<ClassSession>;
      _groups = groups;
      _groupNames = {for (final group in groups) group.id: group.name};
      _studentNames = isTeacher ? results[2] as Map<int, String> : const {};
      _loaded = true;
    } on ApiException {
      _hasError = true;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// This week's sessions on [day] (Monday-first weeks), sorted by time.
  List<ClassSession> onDay(Weekday day) {
    final result = _sessions.where((s) => s.dayOfWeek == day).toList()
      ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
    return result;
  }

  /// The earliest session from now, searching forward up to 7 days
  /// (always found if [sessions] is non-empty, since the schedule
  /// repeats weekly).
  NextOccurrence? get next {
    if (_sessions.isEmpty) return null;
    final now = clock.now();
    final today = DateTime(now.year, now.month, now.day);
    final nowMinutes = now.hour * 60 + now.minute;

    for (var offset = 0; offset < 7; offset++) {
      final date = today.add(Duration(days: offset));
      final day = Weekday.fromDate(date);
      final candidates = onDay(day);
      for (final session in candidates) {
        final startsAt = session.startMinutes;
        if (offset == 0) {
          final elapsed = nowMinutes - startsAt;
          if (elapsed < 0) {
            return NextOccurrence(
              session: session,
              date: date,
              isHappeningNow: false,
            );
          }
          if (elapsed < assumedDuration.inMinutes) {
            return NextOccurrence(
              session: session,
              date: date,
              isHappeningNow: true,
            );
          }
          // Already ended today: keep looking at later days.
          continue;
        }
        return NextOccurrence(
          session: session,
          date: date,
          isHappeningNow: false,
        );
      }
    }
    return null;
  }

  /// The group name, student name, or just the type, for display.
  String label(ClassSession session, AppLocalizations l10n) {
    // Only teachers get group/student names (see [groupNames],
    // [studentNames]); a student always just sees the type.
    if (_isTeacher) {
      if (session.type == SessionType.group) {
        final id = session.groupId;
        if (id != null) return _groupNames[id] ?? l10n.sessionUnknownGroup(id);
      } else if (session.type == SessionType.individual) {
        final id = session.studentId;
        if (id != null) {
          return _studentNames[id] ?? l10n.sessionUnknownStudent(id);
        }
      }
    }
    return session.type.label(l10n);
  }

  Future<CallTicket> join(int sessionId) => _repository.join(sessionId);
}
