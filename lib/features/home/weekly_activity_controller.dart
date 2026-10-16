import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:studify/features/results/results_list_controller.dart';

/// Derives the home screen's "This week's activity" card — attempts
/// over the trailing 7 days (today included) — from [ResultsListController],
/// which already loads every result (a student's own, or the whole
/// school's for a teacher). No fetch of its own: just a different view
/// of the same data the "Recent results" teaser and the Results screen
/// use.
class WeeklyActivityController extends ChangeNotifier {
  WeeklyActivityController({required ResultsListController resultsList})
    : _resultsList = resultsList {
    _recompute();
    _resultsList.addListener(_handleChange);
  }

  final ResultsListController _resultsList;

  List<DateTime> _days = const [];
  List<int> _counts = const [];
  int _averageScore = 0;
  int _bestScore = 0;

  bool get isLoading => _resultsList.isLoading;
  bool get hasError => _resultsList.hasError;

  /// The trailing 7 calendar days, oldest first, today last.
  List<DateTime> get days => _days;

  /// Attempts per day, same order and length as [days].
  List<int> get counts => _counts;

  int get totalAttempts => _counts.fold(0, (sum, count) => sum + count);
  int get averageScore => _averageScore;
  int get bestScore => _bestScore;
  bool get hasActivity => totalAttempts > 0;

  @override
  void dispose() {
    _resultsList.removeListener(_handleChange);
    super.dispose();
  }

  Future<void> ensureLoaded() => _resultsList.ensureLoaded();
  Future<void> reload() => _resultsList.reload();

  void _handleChange() {
    _recompute();
    notifyListeners();
  }

  void _recompute() {
    final today = _dayOf(clock.now());
    final days = [
      for (var offset = 6; offset >= 0; offset--)
        today.subtract(Duration(days: offset)),
    ];
    final windowStart = days.first;
    final inWindow = <int, List<double>>{};
    for (final result in _resultsList.results) {
      final createdAt = result.createdAt;
      if (createdAt == null) continue;
      final day = _dayOf(createdAt);
      if (day.isBefore(windowStart) || day.isAfter(today)) continue;
      (inWindow[day.millisecondsSinceEpoch] ??= []).add(result.percentage);
    }

    _days = days;
    _counts = [
      for (final day in days) inWindow[day.millisecondsSinceEpoch]?.length ?? 0,
    ];
    final allPercentages = inWindow.values.expand((p) => p).toList();
    if (allPercentages.isEmpty) {
      _averageScore = 0;
      _bestScore = 0;
    } else {
      _averageScore =
          (allPercentages.reduce((a, b) => a + b) / allPercentages.length)
              .round();
      _bestScore = allPercentages.reduce((a, b) => a > b ? a : b).round();
    }
  }

  /// Midnight of [d]'s calendar day in the device's local time zone
  /// (`created_at` is UTC; the device's "today" is what the user means).
  static DateTime _dayOf(DateTime d) {
    final local = d.toLocal();
    return DateTime(local.year, local.month, local.day);
  }
}
