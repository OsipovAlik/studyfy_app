import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/auth/auth_controller.dart';
import 'package:studify/features/students/data/students_repository.dart';
import 'package:studify/features/students/domain/student.dart';
import 'package:studify/features/subjects/data/subjects_repository.dart';
import 'package:studify/features/subjects/domain/subject.dart';

/// The school's student roster (teachers only): the subject filter, the
/// list itself, and registering or removing a student.
class StudentsController extends ChangeNotifier {
  StudentsController({
    required StudentsRepository students,
    required SubjectsRepository subjects,
    required AuthController auth,
  }) : _students = students,
       _subjects = subjects,
       _auth = auth,
       _lastUserId = auth.user?.id {
    _auth.addListener(_handleAuthChange);
  }

  final StudentsRepository _students;
  final SubjectsRepository _subjects;
  final AuthController _auth;
  int? _lastUserId;

  bool _loading = false;
  bool _loaded = false;
  bool _hasError = false;
  List<Student> _roster = const [];
  List<Subject> _subjectList = const [];
  int? _subjectFilter;

  bool get isLoading => _loading;
  bool get hasError => _hasError;
  List<Student> get students => _roster;
  List<Subject> get subjects => _subjectList;
  int? get subjectFilter => _subjectFilter;

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
    _roster = const [];
    _subjectList = const [];
    _subjectFilter = null;
    notifyListeners();
  }

  Future<void> ensureLoaded() => _loaded || _loading ? Future.value() : _load();

  Future<void> reload() => _load();

  /// Changes the subject filter and reloads (`GET /students?subjectId=`
  /// is a server-side filter, not something the app can do locally).
  Future<void> setSubjectFilter(int? subjectId) {
    _subjectFilter = subjectId;
    return _load();
  }

  Future<void> _load() async {
    _loading = true;
    _hasError = false;
    await Future<void>.delayed(Duration.zero);
    notifyListeners();
    try {
      final fetched = await Future.wait([
        _students.list(subjectId: _subjectFilter),
        _subjects.list(),
      ]);
      _roster = fetched[0] as List<Student>;
      _subjectList = fetched[1] as List<Subject>;
      _loaded = true;
    } on ApiException {
      _hasError = true;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Registers a student, then reloads the roster. Lets [ApiException]
  /// through so the form can show the server's own validation message.
  Future<void> addStudent({
    required String name,
    required String email,
    required String password,
    required int subjectId,
    String? surname,
  }) async {
    final partnerId = _auth.user?.partnerId;
    if (partnerId == null) throw const ApiException();
    await _students.register(
      name: name,
      surname: surname,
      email: email,
      password: password,
      partnerId: partnerId,
      subjectId: subjectId,
    );
    await _load();
  }

  /// Deletes a student. The API requires the *caller's* (teacher's) own
  /// password to confirm. Lets [ApiException] through so the dialog can
  /// show the server's own message (e.g. a wrong password) and let the
  /// teacher retry instead of just closing.
  Future<void> deleteStudent(int studentId, {required String password}) async {
    await _students.delete(studentId, password: password);
    await _load();
  }
}
