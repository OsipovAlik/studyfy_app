import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studify/features/sessions/domain/class_session.dart';
import 'package:studify/features/sessions/session_display.dart';
import 'package:studify/features/sessions/timetable_controller.dart';
import 'package:studify/features/sessions/widgets/group_form_sheet.dart';
import 'package:studify/features/sessions/widgets/group_row.dart';
import 'package:studify/features/sessions/widgets/picker_pill.dart';
import 'package:studify/features/sessions/widgets/session_form_sheet.dart';
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
          SafeArea(
            child: RefreshIndicator(
              onRefresh: controller.reload,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  Text(
                    l10n.sessionsTitle,
                    style: theme.textTheme.headlineLarge,
                  ),
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
                  if (controller.isLoading &&
                      controller.sessions.isEmpty &&
                      controller.groups.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (controller.hasError)
                    _ErrorState(
                      message: _tab == _Tab.sessions
                          ? l10n.sessionsLoadError
                          : l10n.groupsLoadError,
                      onRetry: controller.reload,
                    )
                  else if (_tab == _Tab.sessions)
                    _SessionsTab(
                      controller: controller,
                      typeFilter: _typeFilter,
                      dayFilter: _dayFilter,
                      onTypeChanged: (type) =>
                          setState(() => _typeFilter = type),
                      onDayChanged: (day) => setState(() => _dayFilter = day),
                      onAdd: () => unawaited(
                        showSessionFormSheet(context, controller: controller),
                      ),
                    )
                  else
                    _GroupsTab(
                      controller: controller,
                      onAdd: () => unawaited(
                        showGroupFormSheet(context, controller: controller),
                      ),
                    ),
                ],
              ),
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
                    color: selected
                        ? scheme.onPrimary
                        : scheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: selected
                          ? scheme.onPrimary
                          : scheme.onSurfaceVariant,
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
    required this.onAdd,
  });

  final TimetableController controller;
  final SessionType? typeFilter;
  final Weekday? dayFilter;
  final ValueChanged<SessionType?> onTypeChanged;
  final ValueChanged<Weekday?> onDayChanged;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final days = dayFilter == null ? Weekday.values : [dayFilter!];
    final sections = [
      for (final day in days)
        (
          day: day,
          sessions: controller
              .onDay(day)
              .where((s) => typeFilter == null || s.type == typeFilter)
              .toList(),
        ),
    ].where((section) => section.sessions.isNotEmpty).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: PickerPill<SessionType?>(
                value: typeFilter,
                label: typeFilter == null
                    ? l10n.sessionsFilterAllTypes
                    : typeFilter!.label(l10n),
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
              child: PickerPill<Weekday?>(
                value: dayFilter,
                label: dayFilter == null
                    ? l10n.sessionsFilterAllDays
                    : dayFilter!.label(l10n),
                options: [
                  (value: null, label: l10n.sessionsFilterAllDays),
                  for (final day in Weekday.values)
                    (value: day, label: day.label(l10n)),
                ],
                onChanged: onDayChanged,
              ),
            ),
          ],
        ),
        if (controller.isTeacher) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onAdd,
              icon: const Icon(CupertinoIcons.add, size: 18),
              label: Text(l10n.sessionsAddSession),
            ),
          ),
        ],
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
                for (final session in sessions)
                  SessionRow(session: session, controller: controller),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GroupsTab extends StatelessWidget {
  const _GroupsTab({required this.controller, required this.onAdd});

  final TimetableController controller;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final groups = controller.groups;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (controller.isTeacher)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onAdd,
              icon: const Icon(CupertinoIcons.add, size: 18),
              label: Text(l10n.groupsAddGroup),
            ),
          ),
        if (groups.isEmpty)
          _EmptyState(
            icon: CupertinoIcons.person_2,
            title: l10n.groupsEmptyTitle,
            description: controller.isTeacher
                ? l10n.groupsEmptyDescription
                : null,
          )
        else ...[
          if (controller.isTeacher) const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerLowest.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
            child: Column(
              children: [
                for (var i = 0; i < groups.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  GroupRow(group: groups[i], controller: controller),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.title,
    this.description,
  });

  final IconData icon;
  final String title;
  final String? description;

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
          if (description case final text?) ...[
            const SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
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
