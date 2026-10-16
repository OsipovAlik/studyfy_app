import 'package:studify/features/results/domain/result.dart';

/// A row of `GET /test/list`, reduced to what the Results screen needs:
/// resolving a [Result.testId] to a title, and the test filter picker.
class TestSummary {
  const TestSummary({required this.id, required this.title});

  factory TestSummary.fromJson(Map<String, dynamic> json) => TestSummary(
    id: (json['ID'] as num?)?.toInt() ?? 0,
    title: json['title'] as String? ?? '',
  );

  final int id;
  final String title;
}
