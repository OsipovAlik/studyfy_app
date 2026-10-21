import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/results/domain/question.dart';
import 'package:studify/features/results/domain/result.dart';
import 'package:studify/features/subjects/data/levels_repository.dart';
import 'package:studify/features/subjects/data/questions_repository.dart';
import 'package:studify/features/subjects/data/tests_repository.dart';
import 'package:studify/features/subjects/domain/test.dart';

/// One test's own detail (title, status, time limit) and its questions.
/// Results and Homework, shown as this screen's other two tabs, come
/// from the app-wide `ResultsListController`/`HomeworkController`
/// instead, filtered by [testId] — they're already loaded there.
class TestDetailController extends ChangeNotifier {
  TestDetailController({
    required this.testId,
    required TestsRepository tests,
    required QuestionsRepository questions,
    required LevelsRepository levels,
    Test? initialTest,
  }) : _tests = tests,
       _questions = questions,
       _levels = levels,
       _test = initialTest;

  final int testId;
  final TestsRepository _tests;
  final QuestionsRepository _questions;
  final LevelsRepository _levels;

  Test? _test;
  bool _loadingTest = false;
  bool _testError = false;
  String? _levelName;

  bool _loadingQuestions = false;
  bool _questionsError = false;
  List<Question> _questionList = const [];

  bool _mutatingTest = false;

  Test? get test => _test;
  bool get isLoadingTest => _loadingTest && _test == null;
  bool get hasTestError => _testError;

  bool get isLoadingQuestions => _loadingQuestions;
  bool get hasQuestionsError => _questionsError;
  List<Question> get questions => _questionList;

  bool get isMutatingTest => _mutatingTest;

  /// The test's level name (e.g. "A1"), once resolved; null until then.
  String? get levelName => _levelName;

  /// Loads whatever the constructor's `initialTest` didn't already
  /// provide, then the level name and the questions.
  Future<void> ensureLoaded() async {
    if (_test == null) await _loadTest();
    await Future.wait([_loadLevelName(), _loadQuestions()]);
  }

  Future<void> reload() async {
    await _loadTest();
    await Future.wait([_loadLevelName(), _loadQuestions()]);
  }

  Future<void> _loadTest() async {
    _loadingTest = true;
    _testError = false;
    notifyListeners();
    try {
      // There's no `GET /test/{id}`; the full list (no `levelId`)
      // covers every test of the school.
      final all = await _tests.list();
      _test = all.where((t) => t.id == testId).firstOrNull;
      if (_test == null) _testError = true;
    } on ApiException {
      _testError = true;
    } finally {
      _loadingTest = false;
      notifyListeners();
    }
  }

  Future<void> _loadLevelName() async {
    final subjectId = _test?.subjectId;
    final levelId = _test?.levelId;
    if (subjectId == null || levelId == null) return;
    try {
      final levels = await _levels.list(subjectId);
      _levelName = levels.where((l) => l.id == levelId).firstOrNull?.name;
      notifyListeners();
    } on ApiException {
      // The level chip just stays blank; not worth a retry affordance.
    }
  }

  Future<void> _loadQuestions() async {
    _loadingQuestions = true;
    _questionsError = false;
    notifyListeners();
    try {
      _questionList = await _questions.list(testId);
    } on ApiException {
      _questionsError = true;
    } finally {
      _loadingQuestions = false;
      notifyListeners();
    }
  }

  Future<void> setActive({required bool isActive}) async {
    _mutatingTest = true;
    notifyListeners();
    try {
      _test = await _tests.update(testId, isActive: isActive);
    } finally {
      _mutatingTest = false;
      notifyListeners();
    }
  }

  Future<void> updateTest({String? title, int? timeLimitMinutes}) async {
    _mutatingTest = true;
    notifyListeners();
    try {
      _test = await _tests.update(
        testId,
        title: title,
        timeLimitMinutes: timeLimitMinutes,
      );
    } finally {
      _mutatingTest = false;
      notifyListeners();
    }
  }

  /// Deletes the test itself (and its questions) — used both for
  /// discarding a draft and for a regular delete.
  Future<void> deleteTest() => _tests.delete(testId);

  Future<void> addQuestion({
    required String question,
    required QuestionType type,
    required String rightAnswer,
    String? a1,
    String? a2,
    String? a3,
    String? a4,
    PlatformFile? image,
    String? video,
  }) async {
    final created = await _questions.create(
      testId: testId,
      question: question,
      type: type,
      rightAnswer: rightAnswer,
      a1: a1,
      a2: a2,
      a3: a3,
      a4: a4,
      image: image,
      video: video,
    );
    _questionList = [..._questionList, created];
    notifyListeners();
  }

  Future<void> editQuestion(
    int questionId, {
    required String question,
    required QuestionType type,
    required String rightAnswer,
    String? a1,
    String? a2,
    String? a3,
    String? a4,
    PlatformFile? image,
    String? video,
  }) async {
    final updated = await _questions.update(
      questionId,
      question: question,
      type: type,
      rightAnswer: rightAnswer,
      // Clearing an option means sending an empty string, not omitting
      // it, since a null `a3`/`a4` here always means "unused".
      a1: a1 ?? '',
      a2: a2 ?? '',
      a3: a3 ?? '',
      a4: a4 ?? '',
      image: image,
      video: video ?? '',
    );
    _questionList = [
      for (final existing in _questionList)
        if (existing.id == questionId) updated else existing,
    ];
    notifyListeners();
  }

  Future<void> deleteQuestion(int questionId) async {
    await _questions.delete(questionId);
    _questionList = [
      for (final existing in _questionList)
        if (existing.id != questionId) existing,
    ];
    notifyListeners();
  }
}
