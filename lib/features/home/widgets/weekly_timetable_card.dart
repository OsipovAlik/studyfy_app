import 'package:clock/clock.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/router/app_router.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/core/theme/app_theme.dart';
import 'package:studify/features/call/call_screen.dart';
import 'package:studify/features/sessions/domain/class_session.dart';
import 'package:studify/features/sessions/session_display.dart';
import 'package:studify/features/sessions/timetable_controller.dart';
import 'package:studify/features/sessions/widgets/time_range_legend.dart';
import 'package:studify/l10n/app_localizations.dart';

/// "This week's timetable": the next session to join, then a day-by-day
/// look at the current week.
class WeeklyTimetableCard extends StatelessWidget {
  const WeeklyTimetableCard({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final controller = context.watch<TimetableController>();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconBadge(icon: CupertinoIcons.calendar, color: scheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.homeTimetableTitle,
                      style: theme.textTheme.titleMedium,
                    ),
                    Text(
                      l10n.homeTimetableSubtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              _ViewCalendarLink(label: l10n.homeTimetableViewCalendar),
            ],
          ),
          const SizedBox(height: 18),
          if (controller.isLoading && controller.sessions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            )
          else if (controller.hasError)
            _ErrorState(
              message: l10n.homeTimetableLoadError,
              onRetry: controller.reload,
            )
          else if (controller.sessions.isEmpty)
            _EmptyState(title: l10n.homeTimetableEmptyTitle)
          else
            _Loaded(controller: controller),
        ],
      ),
    );
  }
}

class _Loaded extends StatelessWidget {
  const _Loaded({required this.controller});

  final TimetableController controller;

  @override
  Widget build(BuildContext context) {
    final next = controller.next;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (next != null) ...[
          _NextSessionCard(controller: controller, next: next),
          const SizedBox(height: 18),
        ],
        const TimeRangeLegend(),
        const SizedBox(height: 12),
        _DayStrip(controller: controller),
      ],
    );
  }
}

class _NextSessionCard extends StatelessWidget {
  const _NextSessionCard({required this.controller, required this.next});

  final TimetableController controller;
  final NextOccurrence next;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final session = next.session;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.indigo950.withValues(alpha: 0.6)
            : AppColors.indigo50,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Row(
        children: [
          _IconBadge(
            icon: CupertinoIcons.video_camera_solid,
            color: scheme.primary,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  next.isHappeningNow
                      ? l10n.homeTimetableLiveNow
                      : l10n.homeTimetableNextSession,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${session.dayOfWeek.label(l10n)} · ${session.startTime} '
                  '— ${session.type.label(l10n)}',
                  style: theme.textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  controller.label(session, l10n),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _JoinCallButton(session: session),
        ],
      ),
    );
  }
}

class _JoinCallButton extends StatelessWidget {
  const _JoinCallButton({required this.session});

  final ClassSession session;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return FilledButton.icon(
      onPressed: () => CallScreen.open(context, session),
      style: FilledButton.styleFrom(
        backgroundColor: scheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: const StadiumBorder(),
      ),
      icon: const Icon(CupertinoIcons.video_camera_solid, size: 17),
      label: Text(l10n.sessionJoinCall),
    );
  }
}

class _DayStrip extends StatelessWidget {
  const _DayStrip({required this.controller});

  final TimetableController controller;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final today = DateUtils.dateOnly(clock.now());
    final monday = today.subtract(Duration(days: today.weekday - 1));

    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 7,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final date = monday.add(Duration(days: index));
          final day = Weekday.values[index];
          return _DayCard(
            date: date,
            isToday: date == today,
            sessions: controller.onDay(day),
            controller: controller,
            locale: locale,
          );
        },
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.date,
    required this.isToday,
    required this.sessions,
    required this.controller,
    required this.locale,
  });

  final DateTime date;
  final bool isToday;
  final List<ClassSession> sessions;
  final TimetableController controller;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final day = Weekday.fromDate(date);
    const shown = 2;

    return Container(
      width: 152,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isToday
            ? scheme.primaryContainer.withValues(alpha: 0.35)
            : scheme.surfaceContainerLow.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(
          color: isToday ? scheme.primary : scheme.outlineVariant,
          width: isToday ? 1.4 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  day.label(l10n),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelLarge,
                ),
              ),
              if (isToday) _TodayPill(label: l10n.sessionToday),
            ],
          ),
          Text(
            DateFormat.MMMd(locale).format(date),
            style: theme.textTheme.bodySmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          if (sessions.isEmpty)
            Text(
              l10n.sessionNoSessionsDay,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            )
          else
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  for (final session in sessions.take(shown))
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Material(
                        color: scheme.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(5),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          onTap: () => CallScreen.open(context, session),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Row(
                              children: [
                                Container(
                                  width: 7,
                                  height: 7,
                                  decoration: BoxDecoration(
                                    color: session.timeRange.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Expanded(
                                  child: Text(
                                    '${session.startTime}  '
                                    '${session.type.label(l10n)}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (sessions.length > shown)
                    Text(
                      '+${sessions.length - shown}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _TodayPill extends StatelessWidget {
  const _TodayPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: scheme.onPrimary,
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}

class _ViewCalendarLink extends StatelessWidget {
  const _ViewCalendarLink({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => context.go(AppRoutes.sessions),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: scheme.primary),
              ),
            ),
            Icon(
              CupertinoIcons.chevron_forward,
              size: 14,
              color: scheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          Icon(
            CupertinoIcons.calendar_badge_plus,
            size: 36,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
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
      padding: const EdgeInsets.symmetric(vertical: 12),
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
