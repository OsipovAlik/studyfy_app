import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:studify/features/homework/domain/assignment.dart';
import 'package:studify/features/homework/homework_controller.dart';
import 'package:studify/features/homework/widgets/assign_homework_sheet.dart';
import 'package:studify/features/homework/widgets/homework_row.dart';
import 'package:studify/features/sessions/timetable_controller.dart';
import 'package:studify/features/sessions/widgets/picker_pill.dart';
import 'package:studify/l10n/app_localizations.dart';

/// The Homework tab. Teachers assign, track and grade; students see and
/// act on their own.
class HomeworkScreen extends StatefulWidget {
  const HomeworkScreen({super.key});

  @override
  State<HomeworkScreen> createState() => _HomeworkScreenState();
}

class _HomeworkScreenState extends State<HomeworkScreen> {
  final _search = TextEditingController();
  AssignmentStatus? _statusFilter;
  AssignmentType? _typeFilter;
  int? _studentFilter;

  @override
  void initState() {
    super.initState();
    unawaited(context.read<HomeworkController>().ensureLoaded());
    _search.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final controller = context.watch<HomeworkController>();

    final query = _search.text.trim().toLowerCase();
    final base = controller.assignments.where((a) {
      if (_typeFilter != null && a.type != _typeFilter) return false;
      if (_studentFilter != null && a.studentId != _studentFilter) {
        return false;
      }
      if (query.isNotEmpty && !a.title.toLowerCase().contains(query)) {
        return false;
      }
      return true;
    }).toList();
    final counts = {
      for (final status in AssignmentStatus.values)
        status: base.where((a) => a.status == status).length,
    };
    final filtered = _statusFilter == null
        ? base
        : base.where((a) => a.status == _statusFilter).toList();

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
                    controller.isTeacher
                        ? l10n.homeworkTitleTeacher
                        : l10n.homeworkTitleStudent,
                    style: theme.textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    controller.isTeacher
                        ? l10n.homeworkSubtitleTeacher
                        : l10n.homeworkSubtitleStudent,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _SearchField(controller: _search),
                  const SizedBox(height: 12),
                  if (controller.isTeacher) ...[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => unawaited(
                          showAssignHomeworkSheet(
                            context,
                            controller: controller,
                          ),
                        ),
                        icon: const Icon(CupertinoIcons.add, size: 18),
                        label: Text(l10n.homeworkAssignButton),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  _StatusGrid(
                    counts: counts,
                    selected: _statusFilter,
                    onChanged: (status) =>
                        setState(() => _statusFilter = status),
                  ),
                  const SizedBox(height: 12),
                  PickerPill<AssignmentType?>(
                    value: _typeFilter,
                    label: switch (_typeFilter) {
                      AssignmentType.test => l10n.homeworkKindTest,
                      AssignmentType.task => l10n.homeworkKindTask,
                      _ => l10n.homeworkFilterAllTypes,
                    },
                    options: [
                      (value: null, label: l10n.homeworkFilterAllTypes),
                      (
                        value: AssignmentType.test,
                        label: l10n.homeworkKindTest,
                      ),
                      (
                        value: AssignmentType.task,
                        label: l10n.homeworkKindTask,
                      ),
                    ],
                    onChanged: (type) => setState(() => _typeFilter = type),
                  ),
                  if (controller.isTeacher) ...[
                    const SizedBox(height: 10),
                    _StudentFilter(
                      value: _studentFilter,
                      onChanged: (id) => setState(() => _studentFilter = id),
                    ),
                  ],
                  const SizedBox(height: 18),
                  if (controller.isLoading && controller.assignments.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (controller.hasError)
                    _ErrorState(
                      message: l10n.homeworkLoadError,
                      onRetry: controller.reload,
                    )
                  else if (filtered.isEmpty)
                    _EmptyState(
                      title: controller.assignments.isEmpty
                          ? (controller.isTeacher
                                ? l10n.homeworkEmptyTitleTeacher
                                : l10n.homeworkEmptyTitleStudent)
                          : l10n.homeworkNoMatches,
                    )
                  else
                    _HomeworkList(
                      assignments: filtered,
                      controller: controller,
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

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: l10n.homeworkSearchHint,
        prefixIcon: const Icon(CupertinoIcons.search, size: 20),
        filled: true,
        fillColor: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
      ),
    );
  }
}

class _StatusGrid extends StatelessWidget {
  const _StatusGrid({
    required this.counts,
    required this.selected,
    required this.onChanged,
  });

  final Map<AssignmentStatus, int> counts;
  final AssignmentStatus? selected;
  final ValueChanged<AssignmentStatus?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final total = counts.values.fold(0, (a, b) => a + b);

    Widget tile(AssignmentStatus? status, String label, int count) {
      final isSelected = selected == status;
      return Expanded(
        child: Material(
          color: isSelected
              ? scheme.primary.withValues(alpha: 0.16)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => onChanged(isSelected ? null : status),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: isSelected ? scheme.primary : null,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 1,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? scheme.primary
                          : scheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '$count',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: isSelected ? scheme.onPrimary : null,
                      ),
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
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          Row(
            children: [
              tile(null, l10n.homeworkStatusAll, total),
              tile(
                AssignmentStatus.pending,
                l10n.homeworkStatusPending,
                counts[AssignmentStatus.pending] ?? 0,
              ),
            ],
          ),
          Row(
            children: [
              tile(
                AssignmentStatus.overdue,
                l10n.homeworkStatusOverdue,
                counts[AssignmentStatus.overdue] ?? 0,
              ),
              tile(
                AssignmentStatus.completed,
                l10n.homeworkStatusCompleted,
                counts[AssignmentStatus.completed] ?? 0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StudentFilter extends StatelessWidget {
  const _StudentFilter({required this.value, required this.onChanged});

  final int? value;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final studentNames = context.watch<TimetableController>().studentNames;
    return PickerPill<int?>(
      value: value,
      label: value == null
          ? l10n.homeworkFilterAllStudents
          : studentNames[value] ?? l10n.homeworkFilterAllStudents,
      options: [
        (value: null, label: l10n.homeworkFilterAllStudents),
        for (final entry in studentNames.entries)
          (value: entry.key, label: entry.value),
      ],
      onChanged: onChanged,
    );
  }
}

class _HomeworkList extends StatelessWidget {
  const _HomeworkList({required this.assignments, required this.controller});

  final List<Assignment> assignments;
  final HomeworkController controller;

  @override
  Widget build(BuildContext context) {
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
          for (var i = 0; i < assignments.length; i++) ...[
            if (i > 0) Divider(height: 1, color: scheme.outlineVariant),
            HomeworkRow(
              assignment: assignments[i],
              showStudentName: controller.isTeacher,
              onTap: () => context.push('/homework/${assignments[i].id}'),
            ),
          ],
        ],
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
      padding: const EdgeInsets.only(top: 40),
      child: Column(
        children: [
          DottedBorderBox(
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: scheme.primaryContainer.withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    CupertinoIcons.doc_text,
                    size: 26,
                    color: scheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style:
                      Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(
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

/// A dashed-border placeholder card, matching the screenshot's empty
/// state frame.
class DottedBorderBox extends StatelessWidget {
  const DottedBorderBox({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: child,
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

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
          TextButton(
            onPressed: () => unawaited(onRetry()),
            child: Text(l10n.callTryAgain),
          ),
        ],
      ),
    );
  }
}
