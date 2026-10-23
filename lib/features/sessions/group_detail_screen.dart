import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/core/theme/app_theme.dart';
import 'package:studify/features/sessions/data/sessions_repository.dart';
import 'package:studify/features/sessions/domain/group.dart';
import 'package:studify/features/sessions/timetable_controller.dart';
import 'package:studify/features/sessions/widgets/picker_pill.dart';
import 'package:studify/features/shell/sub_page.dart';
import 'package:studify/l10n/app_localizations.dart';

/// A group's member roster (teachers only): add or remove students.
class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({required this.groupId, super.key});

  final int groupId;

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen> {
  late Future<GroupDetail> _future;
  int? _addingStudentId;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<GroupDetail> _load() =>
      context.read<SessionsRepository>().getGroup(widget.groupId);

  Future<void> _reload() async {
    final future = _load();
    setState(() {
      _future = future;
      _error = null;
    });
    await future;
  }

  Future<void> _addMember(int studentId) async {
    final l10n = AppLocalizations.of(context);
    final timetable = context.read<TimetableController>();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await context.read<SessionsRepository>().addGroupMember(
        widget.groupId,
        studentId,
      );
      if (!mounted) return;
      await _reload();
      unawaited(timetable.reload());
      setState(() => _addingStudentId = null);
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(
        () => _error = (error.isNetworkError || error.isServerError)
            ? l10n.groupsServerUnavailable
            : error.message ?? l10n.groupDetailAddMemberError,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _removeMember(int studentId) async {
    final l10n = AppLocalizations.of(context);
    final timetable = context.read<TimetableController>();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await context.read<SessionsRepository>().removeGroupMember(
        widget.groupId,
        studentId,
      );
      if (!mounted) return;
      await _reload();
      unawaited(timetable.reload());
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(
        () => _error = (error.isNetworkError || error.isServerError)
            ? l10n.groupsServerUnavailable
            : error.message ?? l10n.groupDetailRemoveMemberError,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FutureBuilder<GroupDetail>(
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
          if (error is ApiException && error.isNotFound) {
            return SubPage(
              title: l10n.groupDetailNotFoundTitle,
              children: [
                Text(
                  l10n.groupDetailNotFoundDescription,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            );
          }
          return SubPage(
            title: l10n.groupsTitle,
            onRefresh: _reload,
            children: [
              Text(
                l10n.groupsLoadError,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => unawaited(_reload()),
                child: Text(l10n.callTryAgain),
              ),
            ],
          );
        }

        final detail = snapshot.data!;
        return SubPage(
          title: detail.name,
          onRefresh: _reload,
          children: [
            _MembersSection(
              detail: detail,
              busy: _busy,
              error: _error,
              onRemove: _removeMember,
            ),
            const SizedBox(height: 20),
            _AddMemberRow(
              detail: detail,
              studentId: _addingStudentId,
              busy: _busy,
              onStudentChanged: (id) => setState(() => _addingStudentId = id),
              onAdd: _addMember,
            ),
          ],
        );
      },
    );
  }
}

class _MembersSection extends StatelessWidget {
  const _MembersSection({
    required this.detail,
    required this.busy,
    required this.error,
    required this.onRemove,
  });

  final GroupDetail detail;
  final bool busy;
  final String? error;
  final Future<void> Function(int studentId) onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.groupMembers(detail.students.length),
          style: theme.textTheme.labelMedium,
        ),
        const SizedBox(height: 10),
        if (detail.students.isEmpty)
          Text(
            l10n.groupDetailNoMembers,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Column(
              children: [
                for (var i = 0; i < detail.students.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: scheme.outlineVariant),
                  ListTile(
                    title: Text(detail.students[i].fullName),
                    trailing: TextButton(
                      onPressed: busy
                          ? null
                          : () => unawaited(onRemove(detail.students[i].id)),
                      child: Text(l10n.groupDetailRemoveMember),
                    ),
                  ),
                ],
              ],
            ),
          ),
        if (error case final message?) ...[
          const SizedBox(height: 12),
          Text(message, style: TextStyle(color: scheme.error)),
        ],
      ],
    );
  }
}

class _AddMemberRow extends StatelessWidget {
  const _AddMemberRow({
    required this.detail,
    required this.studentId,
    required this.busy,
    required this.onStudentChanged,
    required this.onAdd,
  });

  final GroupDetail detail;
  final int? studentId;
  final bool busy;
  final ValueChanged<int?> onStudentChanged;
  final Future<void> Function(int studentId) onAdd;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final memberIds = detail.students.map((s) => s.id).toSet();
    final available = context
        .watch<TimetableController>()
        .studentNames
        .entries
        .where((entry) => !memberIds.contains(entry.key))
        .toList();

    if (available.isEmpty) {
      return Text(
        l10n.groupDetailAllAdded,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }

    final selected = available.any((e) => e.key == studentId)
        ? studentId
        : null;

    return Row(
      children: [
        Expanded(
          child: PickerPill<int?>(
            value: selected,
            label:
                available.where((e) => e.key == selected).firstOrNull?.value ??
                l10n.groupDetailSelectStudent,
            options: [
              for (final entry in available)
                (value: entry.key, label: entry.value),
            ],
            onChanged: onStudentChanged,
          ),
        ),
        const SizedBox(width: 10),
        FilledButton(
          onPressed: (selected != null && !busy)
              ? () => unawaited(onAdd(selected))
              : null,
          child: Text(l10n.groupDetailAddMember),
        ),
      ],
    );
  }
}
