import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/router/app_router.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/features/results/domain/result.dart';
import 'package:studify/features/results/results_list_controller.dart';
import 'package:studify/features/sessions/widgets/picker_pill.dart';
import 'package:studify/features/shell/sub_page.dart';
import 'package:studify/l10n/app_localizations.dart';

/// Every test attempt result, filterable by student (teachers) and
/// test. Reached from the home screen's "This week's activity" card.
class ResultsScreen extends StatefulWidget {
  const ResultsScreen({super.key});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  int? _studentId;
  int? _testId;

  @override
  void initState() {
    super.initState();
    unawaited(context.read<ResultsListController>().ensureLoaded());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final controller = context.watch<ResultsListController>();

    final filtered = controller.results.where((result) {
      if (_studentId != null && result.studentId != _studentId) return false;
      if (_testId != null && result.testId != _testId) return false;
      return true;
    }).toList();
    final percentages = filtered.map((r) => r.percentage).toList();
    final average = percentages.isEmpty
        ? 0
        : (percentages.reduce((a, b) => a + b) / percentages.length).round();
    final best = percentages.isEmpty
        ? 0
        : percentages.reduce((a, b) => a > b ? a : b).round();

    return SubPage(
      title: l10n.resultsPageTitle,
      children: [
        Text(
          controller.isTeacher
              ? l10n.resultsPageSubtitleTeacher
              : l10n.resultsPageSubtitleStudent,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 18),
        if (controller.isLoading && controller.results.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 60),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (controller.hasError)
          _ErrorState(
            message: l10n.resultsLoadError,
            onRetry: controller.reload,
          )
        else ...[
          if (controller.isTeacher) ...[
            PickerPill<int?>(
              value: _studentId,
              label: _studentId == null
                  ? l10n.resultsFilterAllStudents
                  : controller.studentNames[_studentId] ??
                        l10n.resultsFilterAllStudents,
              options: [
                (value: null, label: l10n.resultsFilterAllStudents),
                for (final entry in controller.studentNames.entries)
                  (value: entry.key, label: entry.value),
              ],
              onChanged: (id) => setState(() => _studentId = id),
            ),
            const SizedBox(height: 10),
          ],
          PickerPill<int?>(
            value: _testId,
            label: _testId == null
                ? l10n.resultsFilterAllTests
                : controller.tests
                          .where((t) => t.id == _testId)
                          .firstOrNull
                          ?.title ??
                      l10n.resultsFilterAllTests,
            options: [
              (value: null, label: l10n.resultsFilterAllTests),
              for (final test in controller.tests)
                (value: test.id, label: test.title),
            ],
            onChanged: (id) => setState(() => _testId = id),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  value: '${filtered.length}',
                  label: l10n.homeActivityTotal,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatTile(
                  value: '$average%',
                  label: l10n.resultsAverage,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatTile(value: '$best%', label: l10n.resultsBest),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (filtered.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Center(
                child: Text(
                  l10n.resultsEmptyTitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          else
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: scheme.outlineVariant),
              ),
              child: Column(
                children: [
                  for (var i = 0; i < filtered.length; i++) ...[
                    if (i > 0) Divider(height: 1, color: scheme.outlineVariant),
                    _ResultRow(result: filtered[i], controller: controller),
                  ],
                ],
              ),
            ),
        ],
      ],
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({required this.result, required this.controller});

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
      '${result.score} / ${result.total}',
      if (dateLabel.isNotEmpty) dateLabel,
      if (result.timeTakenSeconds case final seconds?) _formatDuration(seconds),
    ].join(' · ');

    return ListTile(
      onTap: () => context.push('${AppRoutes.results}/${result.id}'),
      leading: Container(
        width: 44,
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '$percent%',
          style: theme.textTheme.labelMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Text(
        controller.testTitle(result.testId, l10n),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleSmall,
      ),
      subtitle: Text(
        subtitle,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelSmall?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
      ),
      trailing: Icon(
        CupertinoIcons.chevron_right,
        size: 16,
        color: scheme.onSurfaceVariant,
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

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 8),
          TextButton(onPressed: onRetry, child: Text(l10n.callTryAgain)),
        ],
      ),
    );
  }
}
