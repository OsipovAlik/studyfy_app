import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/router/app_router.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/features/home/home_stats_controller.dart';
import 'package:studify/l10n/app_localizations.dart';

/// The "Subjects / Students / Groups / Sessions" overview grid, teachers
/// only: each tile is this week's running total and how many of those
/// were added since Monday.
class HomeStatsGrid extends StatelessWidget {
  const HomeStatsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeStatsController>();
    if (!controller.isTeacher) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  key: const ValueKey('home-stat-subjects'),
                  icon: CupertinoIcons.book_fill,
                  color: AppColors.indigo500,
                  count: controller.subjects,
                  label: l10n.tabSubjects,
                  onTap: () => context.go(AppRoutes.subjects),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  key: const ValueKey('home-stat-students'),
                  icon: CupertinoIcons.person_2_fill,
                  color: AppColors.blue500,
                  count: controller.students,
                  label: l10n.tabStudents,
                  onTap: () => context.go(AppRoutes.students),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  key: const ValueKey('home-stat-groups'),
                  icon: CupertinoIcons.person_3_fill,
                  color: AppColors.emerald500,
                  count: controller.groups,
                  label: l10n.sessionsSegmentGroups,
                  onTap: () => context.go(AppRoutes.sessions),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  key: const ValueKey('home-stat-sessions'),
                  icon: CupertinoIcons.calendar,
                  color: AppColors.red500,
                  count: controller.sessions,
                  label: l10n.tabSessions,
                  onTap: () => context.go(AppRoutes.sessions),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.color,
    required this.count,
    required this.label,
    required this.onTap,
    super.key,
  });

  final IconData icon;
  final Color color;
  final StatCount count;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, size: 16, color: color),
                  ),
                  const Spacer(),
                  Icon(
                    CupertinoIcons.chevron_right,
                    size: 14,
                    color: scheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('${count.total}', style: theme.textTheme.headlineSmall),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              if (count.newThisWeek > 0) ...[
                const SizedBox(height: 4),
                Text(
                  l10n.homeStatsNewThisWeek(count.newThisWeek),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.emerald500,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
