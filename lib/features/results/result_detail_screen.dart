import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/core/theme/app_theme.dart';
import 'package:studify/features/results/data/results_repository.dart';
import 'package:studify/features/results/domain/question.dart';
import 'package:studify/features/results/domain/result.dart';
import 'package:studify/features/results/results_list_controller.dart';
import 'package:studify/features/shell/sub_page.dart';
import 'package:studify/l10n/app_localizations.dart';

/// One test attempt's full per-question breakdown.
class ResultDetailScreen extends StatefulWidget {
  const ResultDetailScreen({required this.resultId, super.key});

  final int resultId;

  @override
  State<ResultDetailScreen> createState() => _ResultDetailScreenState();
}

class _ResultDetailScreenState extends State<ResultDetailScreen> {
  late Future<(Result, List<Question>)> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<(Result, List<Question>)> _load() async {
    final repository = context.read<ResultsRepository>();
    final result = await repository.get(widget.resultId);
    final questions = await repository.listQuestions(result.testId);
    return (result, questions);
  }

  Future<void> _reload() async {
    final future = _load();
    setState(() => _future = future);
    await future;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder<(Result, List<Question>)>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const SubPage(
            title: '',
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          );
        }
        if (snapshot.hasError) {
          final error = snapshot.error;
          final scheme = Theme.of(context).colorScheme;
          if (error is ApiException && error.isNotFound) {
            return SubPage(
              title: l10n.resultDetailNotFoundTitle,
              children: [
                Text(
                  l10n.groupDetailNotFoundDescription,
                  style:
                      Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                ),
              ],
            );
          }
          return SubPage(
            title: l10n.resultsPageTitle,
            onRefresh: _reload,
            children: [
              Text(
                l10n.resultsLoadError,
                style:
                    Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
              ),
            ],
          );
        }

        final (result, questions) = snapshot.data!;
        final controller = context.watch<ResultsListController>();
        final questionById = {for (final q in questions) q.id: q};

        return SubPage(
          title: controller.testTitle(result.testId, l10n),
          onRefresh: _reload,
          children: [
            _SummaryHeader(result: result, controller: controller),
            const SizedBox(height: 20),
            for (final answer in result.answers ?? const <AnswerBreakdown>[])
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _AnswerCard(
                  answer: answer,
                  question: questionById[answer.questionId],
                ),
              ),
          ],
        );
      },
    );
  }
}

class _SummaryHeader extends StatelessWidget {
  const _SummaryHeader({required this.result, required this.controller});

  final Result result;
  final ResultsListController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final percent = result.percentage.round();
    final color = percent >= 70
        ? AppColors.emerald500
        : percent >= 40
        ? AppColors.amber500
        : AppColors.red500;
    final created = result.createdAt;
    final dateLabel = created == null
        ? ''
        : DateFormat.yMMMd(locale).add_jm().format(created.toLocal());
    final subtitle = [
      if (controller.isTeacher) controller.studentName(result.studentId, l10n),
      if (dateLabel.isNotEmpty) dateLabel,
      if (result.timeTakenSeconds case final seconds?) _formatDuration(seconds),
    ].join(' · ');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            ),
            child: Text(
              '$percent%',
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${result.score} / ${result.total}',
                  style: theme.textTheme.titleSmall,
                ),
                if (subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  const _AnswerCard({required this.answer, required this.question});

  final AnswerBreakdown answer;
  final Question? question;

  String _label(String key) => answer.type == QuestionType.multipleChoice
      ? (question?.optionLabel(key) ?? key)
      : key;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = answer.isCorrect ? AppColors.emerald500 : AppColors.red500;
    final rightAnswer = answer.rightAnswer;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(answer.question, style: theme.textTheme.titleSmall),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                answer.isCorrect
                    ? CupertinoIcons.check_mark_circled_solid
                    : CupertinoIcons.xmark_circle_fill,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  '${l10n.resultDetailYourAnswer}: ${_label(answer.answer)}',
                  style: theme.textTheme.bodyMedium?.copyWith(color: color),
                ),
              ),
            ],
          ),
          if (!answer.isCorrect && rightAnswer != null) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 22),
              child: Text(
                '${l10n.resultDetailCorrectAnswer}: ${_label(rightAnswer)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

String _formatDuration(int seconds) {
  if (seconds < 60) return '${seconds}s';
  final minutes = seconds ~/ 60;
  final remaining = seconds % 60;
  return remaining == 0 ? '${minutes}m' : '${minutes}m ${remaining}s';
}
