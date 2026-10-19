import 'package:flutter/foundation.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/subjects/data/levels_repository.dart';
import 'package:studify/features/subjects/data/tests_repository.dart';
import 'package:studify/features/subjects/domain/level.dart';
import 'package:studify/features/subjects/domain/test.dart';

/// Owns one subject's levels and the tests of whichever level is
/// selected. The subject itself (name, active status) is managed by the
/// shared `SubjectsController`; this controller only covers what's
/// scoped to the detail page's Tests/Levels tabs.
class SubjectDetailController extends ChangeNotifier {
  SubjectDetailController({
    required this.subjectId,
    required LevelsRepository levels,
    required TestsRepository tests,
  }) : _levels = levels,
       _tests = tests;

  final int subjectId;
  final LevelsRepository _levels;
  final TestsRepository _tests;

  bool _loadingLevels = false;
  bool _levelsError = false;
  List<Level> _levelList = const [];
  int? _selectedLevelId;

  bool _loadingTests = false;
  bool _testsError = false;
  List<Test> _testList = const [];

  bool _generating = false;

  bool get isLoadingLevels => _loadingLevels;
  bool get hasLevelsError => _levelsError;
  List<Level> get levels => _levelList;
  int? get selectedLevelId => _selectedLevelId;

  bool get isLoadingTests => _loadingTests;
  bool get hasTestsError => _testsError;
  List<Test> get tests => _testList;

  bool get isGenerating => _generating;

  Future<void> loadLevels() async {
    _loadingLevels = true;
    _levelsError = false;
    notifyListeners();
    try {
      _levelList = await _levels.list(subjectId);
      if (_selectedLevelId == null ||
          !_levelList.any((l) => l.id == _selectedLevelId)) {
        _selectedLevelId = _levelList.firstOrNull?.id;
      }
    } on ApiException {
      _levelsError = true;
    } finally {
      _loadingLevels = false;
      notifyListeners();
    }
    await _loadTests();
  }

  Future<void> selectLevel(int? levelId) async {
    if (levelId == _selectedLevelId) return;
    _selectedLevelId = levelId;
    notifyListeners();
    await _loadTests();
  }

  Future<void> _loadTests() async {
    final levelId = _selectedLevelId;
    if (levelId == null) {
      _testList = const [];
      _testsError = false;
      notifyListeners();
      return;
    }
    _loadingTests = true;
    _testsError = false;
    notifyListeners();
    try {
      _testList = await _tests.list(levelId: levelId);
    } on ApiException {
      _testsError = true;
    } finally {
      _loadingTests = false;
      notifyListeners();
    }
  }

  Future<void> reloadTests() => _loadTests();

  Future<void> createLevel(String name) async {
    final level = await _levels.create(subjectId: subjectId, name: name);
    _levelList = [..._levelList, level];
    final selectNewOne = _selectedLevelId == null;
    if (selectNewOne) _selectedLevelId = level.id;
    notifyListeners();
    if (selectNewOne) await _loadTests();
  }

  Future<void> renameLevel(int levelId, String name) async {
    final level = await _levels.rename(levelId, name: name);
    _levelList = [
      for (final existing in _levelList)
        if (existing.id == level.id) level else existing,
    ];
    notifyListeners();
  }

  Future<void> deleteLevel(int levelId) async {
    await _levels.delete(levelId);
    _levelList = [
      for (final existing in _levelList)
        if (existing.id != levelId) existing,
    ];
    if (_selectedLevelId == levelId) {
      _selectedLevelId = _levelList.firstOrNull?.id;
      notifyListeners();
      await _loadTests();
    } else {
      notifyListeners();
    }
  }

  Future<void> createTest({
    required String title,
    int? timeLimitMinutes,
  }) async {
    final levelId = _selectedLevelId;
    if (levelId == null) throw const ApiException();
    final test = await _tests.create(
      title: title,
      subjectId: subjectId,
      levelId: levelId,
      timeLimitMinutes: timeLimitMinutes,
    );
    _testList = [..._testList, test];
    notifyListeners();
  }

  Future<void> updateTest(
    int testId, {
    String? title,
    bool? isActive,
    int? timeLimitMinutes,
  }) async {
    final test = await _tests.update(
      testId,
      title: title,
      isActive: isActive,
      timeLimitMinutes: timeLimitMinutes,
    );
    _testList = [
      for (final existing in _testList)
        if (existing.id == test.id) test else existing,
    ];
    notifyListeners();
  }

  Future<void> deleteTest(int testId) async {
    await _tests.delete(testId);
    _testList = [
      for (final existing in _testList)
        if (existing.id != testId) existing,
    ];
    notifyListeners();
  }

  /// Returns how many questions the AI actually produced vs. asked for,
  /// so the caller can tell the teacher if it fell short.
  Future<GeneratedTest> generateTest({
    required String topic,
    required String cefrLevel,
    required int questionCount,
    required String questionType,
    String? title,
    String? instructions,
    int? timeLimitMinutes,
  }) async {
    final levelId = _selectedLevelId;
    if (levelId == null) throw const ApiException();
    _generating = true;
    notifyListeners();
    try {
      final result = await _tests.generate(
        subjectId: subjectId,
        levelId: levelId,
        topic: topic,
        cefrLevel: cefrLevel,
        questionCount: questionCount,
        questionType: questionType,
        title: title,
        instructions: instructions,
        timeLimitMinutes: timeLimitMinutes,
      );
      _testList = [..._testList, result.test];
      return result;
    } finally {
      _generating = false;
      notifyListeners();
    }
  }
}
