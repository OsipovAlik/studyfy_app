import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/widgets/brand_backdrop.dart';
import 'package:studify/features/sessions/domain/class_session.dart';
import 'package:studify/features/sessions/domain/group.dart';
import 'package:studify/features/sessions/session_display.dart';
import 'package:studify/features/sessions/timetable_controller.dart';
import 'package:studify/features/sessions/widgets/session_row.dart';
import 'package:studify/features/sessions/widgets/time_range_legend.dart';
import 'package:studify/l10n/app_localizations.dart';

enum _Tab { sessions, groups }

/// The Sessions tab: this week's schedule (filterable by type and day),
/// or the school's Groups, behind a segmented toggle.
class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  _Tab _tab = _Tab.sessions;
  SessionType? _typeFilter;
  Weekday? _dayFilter;

  @override
  void initState() {
    super.initState();
    unawaited(context.read<TimetableController>().ensureLoaded());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final controller = context.watch<TimetableController>();

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: BrandBackdrop()),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              children: [
                Text(l10n.sessionsTitle, style: theme.textTheme.headlineLarge),
                const SizedBox(height: 4),
                Text(
                  l10n.sessionsSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 18),
                _SegmentedTabs(
                  tab: _tab,
                  onChanged: (tab) => setState(() => _tab = tab),
                ),
                const SizedBox(height: 16),
                if (controller.isLoading && controller.sessions.isEmpty && controller.groups.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (controller.hasError)
                  _ErrorState(
                    message: _tab == _Tab.sessions ? l10n.sessionsLoadError : l10n.groupsLoadError,
                    onRetry: controller.reload,
                  )
                else if (_tab == _Tab.sessions)
                  _SessionsTab(
                    controller: controller,
                    typeFilter: _typeFilter,
                    dayFilter: _dayFilter,
                    onTypeChanged: (type) => setState(() => _typeFilter = type),
                    onDayChanged: (day) => setState(() => _dayFilter = day),
                  )
                else
                  _GroupsTab(groups: controller.groups),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentedTabs extends StatelessWidget {
  const _SegmentedTabs({required this.tab, required this.onChanged});

  final _Tab tab;
  final ValueChanged<_Tab> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    Widget segment({
      required _Tab value,
      required IconData icon,
      required String label,
    }) {
      final selected = tab == value;
      return Expanded(
        child: Material(
          color: selected ? scheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => onChanged(value),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 16,
                    color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          segment(
            value: _Tab.sessions,
            icon: CupertinoIcons.calendar,
            label: l10n.tabSessions,
          ),
          segment(
            value: _Tab.groups,
            icon: CupertinoIcons.person_2_fill,
            label: l10n.sessionsSegmentGroups,
          ),
        ],
      ),
    );
  }
}

class _SessionsTab extends StatelessWidget {
  const _SessionsTab({
    required this.controller,
    required this.typeFilter,
    required this.dayFilter,
    required this.onTypeChanged,
    required this.onDayChanged,
  });

  final TimetableController controller;
  final SessionType? typeFilter;
  final Weekday? dayFilter;
  final ValueChanged<SessionType?> onTypeChanged;
  final ValueChanged<Weekday?> onDayChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final days = dayFilter == null ? Weekday.values : [dayFilter!];
    final sections = [
      for (final day in days)
        (
          day: day,
          sessions: controller.onDay(day).where((s) => typeFilter == null || s.type == typeFilter).toList(),
        ),
    ].where((section) => section.sessions.isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _FilterPill<SessionType?>(
                value: typeFilter,
                label: typeFilter == null ? l10n.sessionsFilterAllTypes : typeFilter!.label(l10n),
                options: [
                  (value: null, label: l10n.sessionsFilterAllTypes),
                  (value: SessionType.group, label: l10n.sessionTypeGroup),
                  (
                    value: SessionType.individual,
                    label: l10n.sessionTypeIndividual,
                  ),
                ],
                onChanged: onTypeChanged,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _FilterPill<Weekday?>(
                value: dayFilter,
                label: dayFilter == null ? l10n.sessionsFilterAllDays : dayFilter!.label(l10n),
                options: [
                  (value: null, label: l10n.sessionsFilterAllDays),
                  for (final day in Weekday.values) (value: day, label: day.label(l10n)),
                ],
                onChanged: onDayChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (controller.sessions.isEmpty)
          _EmptyState(
            icon: CupertinoIcons.calendar_badge_plus,
            title: l10n.sessionsEmptyTitle,
          )
        else if (sections.isEmpty)
          _EmptyState(
            icon: CupertinoIcons.search,
            title: l10n.sessionsNoMatches,
          )
        else ...[
          const TimeRangeLegend(),
          const SizedBox(height: 18),
          for (final section in sections)
            _DaySection(
              day: section.day,
              sessions: section.sessions,
              controller: controller,
            ),
        ],
      ],
    );
  }
}

class _FilterPill<T> extends StatelessWidget {
  const _FilterPill({
    required this.value,
    required this.label,
    required this.options,
    required this.onChanged,
  });

  final T value;
  final String label;
  final List<({T value, String label})> options;
  final ValueChanged<T> onChanged;

  Future<void> _open(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return showModalBottomSheet<void>(
      useRootNavigator: true,
      context: context,
      useSafeArea: true,
      // The day list (8 options) can be taller than the sheet's default
      // cap; let it take more room, and scroll past that instead of
      // overflowing.
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.6,
          ),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              for (final option in options)
                ListTile(
                  title: Text(option.label),
                  trailing: option.value == value
                      ? Icon(
                          CupertinoIcons.checkmark_alt,
                          color: scheme.primary,
                        )
                      : null,
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    onChanged(option.value);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Material(
      color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => _open(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: scheme.outlineVariant),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              Icon(
                CupertinoIcons.chevron_down,
                size: 14,
                color: scheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DaySection extends StatelessWidget {
  const _DaySection({
    required this.day,
    required this.sessions,
    required this.controller,
  });

  final Weekday day;
  final List<ClassSession> sessions;
  final TimetableController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: scheme.primary,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  day.label(l10n),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: scheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${sessions.length}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Divider(color: scheme.outlineVariant)),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Column(
              children: [
                for (final session in sessions) SessionRow(session: session, controller: controller),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupsTab extends StatelessWidget {
  const _GroupsTab({required this.groups});

  final List<Group> groups;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (groups.isEmpty) {
      return _EmptyState(
        icon: CupertinoIcons.person_2,
        title: l10n.groupsEmptyTitle,
      );
    }

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          for (var i = 0; i < groups.length; i++) ...[
            if (i > 0) Divider(height: 1, color: scheme.outlineVariant),
            ListTile(
              leading: Container(
                width: 38,
                height: 38,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  CupertinoIcons.person_2_fill,
                  size: 18,
                  color: scheme.primary,
                ),
              ),
              title: Text(groups[i].name, style: theme.textTheme.titleSmall),
              subtitle: Text(l10n.groupMembers(groups[i].memberCount)),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 60),
      child: Column(
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: scheme.primaryContainer.withValues(alpha: 0.7),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: scheme.primary),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: scheme.onSurfaceVariant),
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
      padding: const EdgeInsets.only(top: 60),
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
