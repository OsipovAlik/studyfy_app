import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/router/app_router.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/features/home/weekly_activity_controller.dart';
import 'package:studify/features/results/domain/result.dart';
import 'package:studify/features/results/results_list_controller.dart';
import 'package:studify/l10n/app_localizations.dart';

/// "This week's activity": test attempts over the trailing 7 days, with
/// the running attempt count, average score and best score. Hidden on
/// error — it's a secondary summary, not worth showing broken.
class WeeklyActivityCard extends StatelessWidget {
  const WeeklyActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WeeklyActivityController>();
    if (controller.hasError) return const SizedBox.shrink();

    final resultsList = context.watch<ResultsListController>();
    final recent = resultsList.recent();
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  CupertinoIcons.chart_bar_alt_fill,
                  color: scheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.homeActivityTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          if (controller.isLoading && controller.days.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (!controller.hasActivity)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                l10n.homeActivityEmpty,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            )
          else
            _ActivityChart(controller: controller),
          if (recent.isNotEmpty) ...[
            const SizedBox(height: 18),
            Divider(color: scheme.outlineVariant),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.resultsRecentTitle,
                    style: theme.textTheme.titleSmall,
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () => context.push(AppRoutes.results),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 4,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.resultsViewAll,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: scheme.primary,
                          ),
                        ),
                        Icon(
                          CupertinoIcons.chevron_right,
                          size: 13,
                          color: scheme.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            for (final result in recent)
              _RecentResultTile(result: result, resultsList: resultsList),
          ],
        ],
      ),
    );
  }
}

class _ActivityChart extends StatelessWidget {
  const _ActivityChart({required this.controller});

  final WeeklyActivityController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final days = controller.days;
    final counts = controller.counts;
    final maxCount = counts.fold(0, (m, c) => c > m ? c : m);
    // The most recent day with attempts: the one annotated above the
    // chart, same as the site shows only today's (or the latest) count.
    final peakIndex = counts.lastIndexWhere((c) => c > 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (peakIndex >= 0) ...[
          Align(
            alignment: Alignment.centerRight,
            child: _AttemptsBadge(
              text: l10n.homeActivityAttempts(counts[peakIndex]),
            ),
          ),
          const SizedBox(height: 8),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _AxisColumn(max: maxCount),
            const SizedBox(width: 8),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  for (var i = 0; i < days.length; i++)
                    Expanded(
                      child: _DayColumn(
                        day: days[i],
                        count: counts[i],
                        maxCount: maxCount,
                        isToday: i == days.length - 1,
                        locale: locale,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _StatTile(
                key: const ValueKey('activity-attempts'),
                value: '${controller.totalAttempts}',
                label: l10n.homeActivityTotal,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatTile(
                key: const ValueKey('activity-average'),
                value: '${controller.averageScore}%',
                label: l10n.homeActivityAverage,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _StatTile(
                key: const ValueKey('activity-best'),
                value: '${controller.bestScore}%',
                label: l10n.homeActivityBest,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _AxisColumn extends StatelessWidget {
  const _AxisColumn({required this.max});

  final int max;

  @override
  Widget build(BuildContext context) {
    final style =
        Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        );
    return SizedBox(
      height: 90,
      width: 16,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$max', style: style),
          Text('0', style: style),
        ],
      ),
    );
  }
}

class _DayColumn extends StatelessWidget {
  const _DayColumn({
    required this.day,
    required this.count,
    required this.maxCount,
    required this.isToday,
    required this.locale,
  });

  final DateTime day;
  final int count;
  final int maxCount;
  final bool isToday;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final labelColor = isToday ? scheme.primary : scheme.onSurfaceVariant;
    final labelWeight = isToday ? FontWeight.w700 : FontWeight.w400;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 90,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: maxCount == 0 ? 0 : count / maxCount,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: count > 0 ? AppColors.indigo400 : Colors.transparent,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          DateFormat.E(locale).format(day),
          style: theme.textTheme.labelSmall?.copyWith(
            color: labelColor,
            fontWeight: labelWeight,
          ),
        ),
        Text(
          '${day.day}',
          style: theme.textTheme.labelSmall?.copyWith(
            color: labelColor,
            fontWeight: labelWeight,
          ),
        ),
      ],
    );
  }
}

class _AttemptsBadge extends StatelessWidget {
  const _AttemptsBadge({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.inverseSurface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: scheme.onInverseSurface),
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label, super.key});

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

class _RecentResultTile extends StatelessWidget {
  const _RecentResultTile({required this.result, required this.resultsList});

  final Result result;
  final ResultsListController resultsList;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final isTeacher = resultsList.isTeacher;
    final testTitle = resultsList.testTitle(result.testId, l10n);
    final created = result.createdAt;
    final dateLabel = created == null
        ? ''
        : DateFormat.yMMMd(locale).format(created.toLocal());
    final primary = isTeacher
        ? resultsList.studentName(result.studentId, l10n)
        : testTitle;
    final subtitle = [
      if (dateLabel.isNotEmpty) dateLabel,
      if (isTeacher) testTitle,
    ].join(' · ');
    final percent = result.percentage.round();
    final color = percent >= 70
        ? AppColors.emerald500
        : percent >= 40
        ? AppColors.amber500
        : AppColors.red500;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.push('${AppRoutes.results}/${result.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            if (isTeacher)
              _InitialsAvatar(name: primary)
            else
              Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  CupertinoIcons.doc_text,
                  size: 18,
                  color: scheme.primary,
                ),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    primary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall,
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 4,
              ),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$percent%',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              CupertinoIcons.chevron_right,
              size: 14,
              color: scheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final initial = name.trim().isEmpty ? '?' : name.trim()[0].toUpperCase();
    return CircleAvatar(
      radius: 19,
      backgroundColor: AppColors.indigo600,
      child: Text(
        initial,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }
}
