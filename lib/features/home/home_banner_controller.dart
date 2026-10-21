import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/auth/auth_controller.dart';
import 'package:studify/features/auth/domain/user_profile.dart';
import 'package:studify/features/subjects/data/subjects_repository.dart';
import 'package:studify/features/subjects/domain/subject.dart';

/// The home banner's picture: the first of the current user's subjects
/// that has one set (a teacher's own, or a student's own via
/// `/subject/my`, which — unlike `/subject/list` — returns their real
/// `mainImageUrl`). Also owns the teacher-only "Banner picture" dialog's
/// data: every subject, and setting/removing a subject's picture.
class HomeBannerController extends ChangeNotifier {
  HomeBannerController({
    required SubjectsRepository subjects,
    required AuthController auth,
  }) : _subjects = subjects,
       _auth = auth,
       _lastUserId = auth.user?.id {
    _auth.addListener(_handleAuthChange);
  }

  final SubjectsRepository _subjects;
  final AuthController _auth;
  int? _lastUserId;

  bool _loading = false;
  bool _loaded = false;
  bool _hasError = false;
  List<Subject> _subjectList = const [];
  bool _mutating = false;

  bool get isTeacher => _auth.user?.role == UserRole.teacher;
  bool get isLoading => _loading;
  bool get hasError => _hasError;
  bool get isMutating => _mutating;

  /// Every subject (teachers only — this is what the management dialog's
  /// picker lists).
  List<Subject> get subjects => _subjectList;

  /// The first subject's picture, in list order; null for the default
  /// banner art.
  String? get bannerImageUrl {
    for (final subject in _subjectList) {
      if (subject.mainImageUrl.isNotEmpty) return subject.mainImageUrl;
    }
    return null;
  }

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
    _subjectList = const [];
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
      _subjectList = isTeacher
          ? await _subjects.list()
          : await _subjects.listMine();
      _loaded = true;
    } on ApiException {
      _hasError = true;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> setMainImage(int subjectId, XFile image) async {
    _mutating = true;
    notifyListeners();
    try {
      final updated = await _subjects.setMainImage(subjectId, image: image);
      _replace(updated);
    } finally {
      _mutating = false;
      notifyListeners();
    }
  }

  Future<void> removeMainImage(int subjectId) async {
    _mutating = true;
    notifyListeners();
    try {
      final updated = await _subjects.removeMainImage(subjectId);
      _replace(updated);
    } finally {
      _mutating = false;
      notifyListeners();
    }
  }

  void _replace(Subject subject) {
    _subjectList = [
      for (final existing in _subjectList)
        if (existing.id == subject.id) subject else existing,
    ];
    notifyListeners();
  }
}
