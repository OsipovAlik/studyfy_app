import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/auth/auth_controller.dart';
import 'package:studify/features/auth/domain/user_profile.dart';
import 'package:studify/features/results/data/results_repository.dart';
import 'package:studify/features/results/domain/result.dart';
import 'package:studify/features/results/domain/test_summary.dart';
import 'package:studify/features/students/data/students_repository.dart';
import 'package:studify/features/students/domain/student.dart';
import 'package:studify/l10n/app_localizations.dart';

/// Every test attempt result (a student's own, or the whole school's for
/// a teacher): the Home screen's "Recent results" teaser and the full
/// Results screen share this one load.
class ResultsListController extends ChangeNotifier {
  ResultsListController({
    required ResultsRepository results,
    required StudentsRepository students,
    required AuthController auth,
  }) : _results = results,
       _students = students,
       _auth = auth,
       _lastUserId = auth.user?.id {
    _auth.addListener(_handleAuthChange);
  }

  final ResultsRepository _results;
  final StudentsRepository _students;
  final AuthController _auth;
  int? _lastUserId;

  bool _loading = false;
  bool _loaded = false;
  bool _hasError = false;
  List<Result> _all = const [];
  List<TestSummary> _tests = const [];
  Map<int, String> _studentNames = const {};

  bool get isTeacher => _auth.user?.role == UserRole.teacher;
  bool get isLoading => _loading;
  bool get hasError => _hasError;

  /// Every result, newest first (as the API returns them).
  List<Result> get results => _all;

  /// Every test of the school, for the test filter and for resolving a
  /// result's `testId` to a title.
  List<TestSummary> get tests => _tests;

  /// Student id → full name (teachers only; empty for a student, who
  /// only ever sees their own results).
  Map<int, String> get studentNames => _studentNames;

  /// The newest few, for the home screen's teaser.
  List<Result> recent([int count = 3]) => _all.take(count).toList();

  @override
  void dispose() {
    _auth.removeListener(_handleAuthChange);
    super.dispose();
  }

  void _handleAuthChange() {
    final userId = _auth.user?.id;
    if (userId == _lastUserId) return;
    _lastUserId = userId;
    _loaded = false;
    _hasError = false;
    _all = const [];
    _tests = const [];
    _studentNames = const {};
    notifyListeners();
  }

  Future<void> ensureLoaded() => _loaded || _loading ? Future.value() : _load();

  Future<void> reload() => _load();

  Future<void> _load() async {
    _loading = true;
    _hasError = false;
    await Future<void>.delayed(Duration.zero);
    notifyListeners();
    try {
      final isTeacher = this.isTeacher;
      final fetched = await Future.wait([
        _results.list(),
        _results.listTests(),
        if (isTeacher) _students.list(),
      ]);
      _all = fetched[0] as List<Result>;
      _tests = fetched[1] as List<TestSummary>;
      _studentNames = isTeacher
          ? {
              for (final student in fetched[2] as List<Student>)
                student.id: student.fullName,
            }
          : const {};
      _loaded = true;
    } on ApiException {
      _hasError = true;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// The test's title, or a placeholder if it was deleted since.
  String testTitle(int testId, AppLocalizations l10n) =>
      _tests.where((t) => t.id == testId).firstOrNull?.title ??
      l10n.resultsUnknownTest(testId);

  /// The student's name (teachers only; a student never needs this —
  /// every result shown to them is already their own).
  String studentName(int studentId, AppLocalizations l10n) =>
      _studentNames[studentId] ?? l10n.sessionUnknownStudent(studentId);
}
