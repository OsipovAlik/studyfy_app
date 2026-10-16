import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/auth/auth_controller.dart';
import 'package:studify/features/auth/domain/user_profile.dart';
import 'package:studify/features/sessions/timetable_controller.dart';
import 'package:studify/features/students/data/students_repository.dart';
import 'package:studify/features/students/domain/student.dart';
import 'package:studify/features/subjects/data/subjects_repository.dart';
import 'package:studify/features/subjects/domain/subject.dart';

/// One tile of the home screen's overview grid.
class StatCount {
  const StatCount({required this.total, required this.newThisWeek});

  static const zero = StatCount(total: 0, newThisWeek: 0);

  final int total;

  /// How many of [total] were created since the most recent Monday.
  final int newThisWeek;
}

/// Loads the counts behind the home screen's "Subjects / Students /
/// Groups / Sessions" overview grid (teachers only).
///
/// Groups and sessions are already loaded by [TimetableController] (for
/// the timetable card and the Sessions screen), so this only fetches
/// what nobody else does — subjects and the full student roster — and
/// reads the rest from there, rather than hitting the same endpoints a
/// second time.
class HomeStatsController extends ChangeNotifier {
  HomeStatsController({
    required SubjectsRepository subjects,
    required StudentsRepository students,
    required TimetableController timetable,
    required AuthController auth,
  }) : _subjects = subjects,
       _students = students,
       _timetable = timetable,
       _auth = auth,
       _lastUserId = auth.user?.id {
    _auth.addListener(_handleAuthChange);
    _timetable.addListener(_handleTimetableChange);
  }

  final SubjectsRepository _subjects;
  final StudentsRepository _students;
  final TimetableController _timetable;
  final AuthController _auth;
  int? _lastUserId;

  bool _loading = false;
  bool _loaded = false;
  bool _hasError = false;
  StatCount _subjectsCount = StatCount.zero;
  StatCount _studentsCount = StatCount.zero;

  bool get isTeacher => _auth.user?.role == UserRole.teacher;
  bool get isLoading => _loading;
  bool get hasError => _hasError;

  StatCount get subjects => _subjectsCount;
  StatCount get students => _studentsCount;
  StatCount get groups => _countOf(_timetable.groups.map((g) => g.createdAt));
  StatCount get sessions =>
      _countOf(_timetable.sessions.map((s) => s.createdAt));

  @override
  void dispose() {
    _auth.removeListener(_handleAuthChange);
    _timetable.removeListener(_handleTimetableChange);
    super.dispose();
  }

  void _handleTimetableChange() => notifyListeners();

  void _handleAuthChange() {
    final userId = _auth.user?.id;
    if (userId == _lastUserId) return;
    _lastUserId = userId;
    _loaded = false;
    _hasError = false;
    _subjectsCount = StatCount.zero;
    _studentsCount = StatCount.zero;
    notifyListeners();
  }

  Future<void> ensureLoaded() =>
      !isTeacher || _loaded || _loading ? Future.value() : _load();

  Future<void> reload() => isTeacher ? _load() : Future.value();

  Future<void> _load() async {
    _loading = true;
    _hasError = false;
    await Future<void>.delayed(Duration.zero);
    notifyListeners();
    try {
      final results = await Future.wait([_subjects.list(), _students.list()]);
      final subjectsList = results[0] as List<Subject>;
      final studentsList = results[1] as List<Student>;
      _subjectsCount = _countOf(subjectsList.map((s) => s.createdAt));
      _studentsCount = _countOf(studentsList.map((s) => s.createdAt));
      _loaded = true;
    } on ApiException {
      _hasError = true;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  static StatCount _countOf(Iterable<DateTime?> createdAts) {
    final since = _startOfWeek(clock.now());
    var total = 0;
    var newThisWeek = 0;
    for (final createdAt in createdAts) {
      total++;
      if (createdAt != null && !createdAt.isBefore(since)) newThisWeek++;
    }
    return StatCount(total: total, newThisWeek: newThisWeek);
  }

  /// Midnight of the most recent Monday (the school week starts there).
  static DateTime _startOfWeek(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    return today.subtract(Duration(days: today.weekday - DateTime.monday));
  }
}
