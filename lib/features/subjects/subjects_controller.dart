import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/auth/auth_controller.dart';
import 'package:studify/features/auth/domain/user_profile.dart';
import 'package:studify/features/subjects/data/subjects_repository.dart';
import 'package:studify/features/subjects/domain/subject.dart';

/// The school's subjects: every signed-in role can see the list, but only
/// a teacher may add, rename, activate/deactivate or delete one.
class SubjectsController extends ChangeNotifier {
  SubjectsController({required SubjectsRepository repository, required AuthController auth})
    : _repository = repository,
      _auth = auth,
      _lastUserId = auth.user?.id {
    _auth.addListener(_handleAuthChange);
  }

  final SubjectsRepository _repository;
  final AuthController _auth;
  int? _lastUserId;

  bool _loading = false;
  bool _loaded = false;
  bool _hasError = false;
  List<Subject> _subjects = const [];

  bool get isLoading => _loading;
  bool get hasError => _hasError;
  List<Subject> get subjects => _subjects;
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
    _subjects = const [];
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
      _subjects = await _repository.list();
      _loaded = true;
    } on ApiException {
      _hasError = true;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Each mutation below applies the resource the server just handed
  /// back straight to the local list instead of reloading, so the UI
  /// reflects exactly what the server did, with no extra round trip.

  Future<void> createSubject(String name) async {
    final subject = await _repository.create(name: name);
    _subjects = [..._subjects, subject];
    notifyListeners();
  }

  Future<void> renameSubject(int subjectId, String name) async {
    final subject = await _repository.rename(subjectId, name: name);
    _replace(subject);
  }

  Future<void> toggleActive(int subjectId) async {
    final subject = await _repository.toggleActive(subjectId);
    _replace(subject);
  }

  void _replace(Subject subject) {
    _subjects = [
      for (final existing in _subjects)
        if (existing.id == subject.id) subject else existing,
    ];
    notifyListeners();
  }

  Future<void> deleteSubject(int subjectId) async {
    await _repository.delete(subjectId);
    _subjects = [
      for (final existing in _subjects)
        if (existing.id != subjectId) existing,
    ];
    notifyListeners();
  }
}
