import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/auth/auth_controller.dart';
import 'package:studify/features/auth/domain/user_profile.dart';
import 'package:studify/features/homework/data/homework_repository.dart';
import 'package:studify/features/homework/domain/assignment.dart';
import 'package:studify/features/subjects/data/tests_repository.dart';
import 'package:studify/features/subjects/domain/test.dart';

/// Homework: a teacher sees and manages every assignment of their
/// school; a student sees only their own (the API already narrows the
/// list for them). Lists are complete — filtering by status, type,
/// student or search happens client-side in the screen, not here.
class HomeworkController extends ChangeNotifier {
  HomeworkController({
    required HomeworkRepository homework,
    required TestsRepository tests,
    required AuthController auth,
  }) : _homework = homework,
       _tests = tests,
       _auth = auth,
       _lastUserId = auth.user?.id {
    _auth.addListener(_handleAuthChange);
  }

  final HomeworkRepository _homework;
  final TestsRepository _tests;
  final AuthController _auth;
  int? _lastUserId;

  bool _loading = false;
  bool _loaded = false;
  bool _hasError = false;
  List<Assignment> _assignments = const [];
  List<Test> _assignableTests = const [];

  bool get isLoading => _loading;
  bool get hasError => _hasError;
  List<Assignment> get assignments => _assignments;

  /// Active tests only — the API refuses to assign an inactive one.
  List<Test> get assignableTests => _assignableTests;

  bool get isTeacher => _auth.user?.role == UserRole.teacher;

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
    _assignments = const [];
    _assignableTests = const [];
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
      final isTeacherRole = isTeacher;
      final results = await Future.wait([
        _homework.list(),
        if (isTeacherRole) _tests.list(),
      ]);
      _assignments = results[0] as List<Assignment>;
      if (isTeacherRole) {
        _assignableTests = (results[1] as List<Test>)
            .where((t) => t.isActive)
            .toList();
      }
      _loaded = true;
    } on ApiException {
      _hasError = true;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> createTestHomework({
    required int testId,
    List<int>? studentIds,
    List<int>? groupIds,
    DateTime? dueDate,
    String? note,
  }) async {
    final created = await _homework.createTestHomework(
      testId: testId,
      studentIds: studentIds,
      groupIds: groupIds,
      dueDate: dueDate,
      note: note,
    );
    _assignments = [..._assignments, ...created];
    notifyListeners();
  }

  Future<void> createTaskHomework({
    required String title,
    int? maxGrade,
    List<int>? studentIds,
    List<int>? groupIds,
    DateTime? dueDate,
    String? note,
  }) async {
    final created = await _homework.createTaskHomework(
      title: title,
      maxGrade: maxGrade,
      studentIds: studentIds,
      groupIds: groupIds,
      dueDate: dueDate,
      note: note,
    );
    _assignments = [..._assignments, ...created];
    notifyListeners();
  }

  Future<void> updateAssignment(
    int id, {
    String note = '',
    String? title,
    int? maxGrade,
    DateTime? dueDate,
    bool clearDueDate = false,
  }) async {
    final updated = await _homework.update(
      id,
      note: note,
      title: title,
      maxGrade: maxGrade,
      dueDate: dueDate,
      clearDueDate: clearDueDate,
    );
    _replace(updated);
  }

  Future<void> deleteAssignment(int id) async {
    await _homework.delete(id);
    _assignments = [
      for (final existing in _assignments)
        if (existing.id != id) existing,
    ];
    notifyListeners();
  }

  Future<void> submitTask(int id, {String? text}) async {
    final updated = await _homework.submit(id, text: text);
    _replace(updated);
  }

  Future<void> gradeAssignment(
    int id, {
    required int grade,
    String? feedback,
  }) async {
    final updated = await _homework.grade(id, grade: grade, feedback: feedback);
    _replace(updated);
  }

  Future<void> unlockGrade(int id) async {
    final updated = await _homework.unlockGrade(id);
    _replace(updated);
  }

  void _replace(Assignment assignment) {
    _assignments = [
      for (final existing in _assignments)
        if (existing.id == assignment.id) assignment else existing,
    ];
    notifyListeners();
  }
}
