import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/core/theme/app_theme.dart';
import 'package:studify/features/sessions/data/sessions_repository.dart';
import 'package:studify/features/sessions/domain/class_session.dart';
import 'package:studify/features/sessions/session_display.dart';
import 'package:studify/features/sessions/timetable_controller.dart';
import 'package:studify/features/sessions/widgets/picker_pill.dart';
import 'package:studify/l10n/app_localizations.dart';

/// Opens the add/edit session sheet. Pass [editing] to edit that
/// session; omit it to create a new one.
Future<void> showSessionFormSheet(
  BuildContext context, {
  required TimetableController controller,
  ClassSession? editing,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => _SessionFormSheet(controller: controller, editing: editing),
  );
}

class _SessionFormSheet extends StatefulWidget {
  const _SessionFormSheet({required this.controller, this.editing});

  final TimetableController controller;
  final ClassSession? editing;

  @override
  State<_SessionFormSheet> createState() => _SessionFormSheetState();
}

class _SessionFormSheetState extends State<_SessionFormSheet> {
  late SessionType _type;
  int? _groupId;
  int? _studentId;
  Weekday? _day;
  TimeOfDay? _time;
  bool _submitting = false;
  String? _error;

  bool get _isEditing => widget.editing != null;

  @override
  void initState() {
    super.initState();
    final editing = widget.editing;
    _type = editing?.type ?? SessionType.group;
    _groupId = editing?.groupId;
    _studentId = editing?.studentId;
    _day = editing?.dayOfWeek;
    _time = editing == null ? null : _parseTime(editing.startTime);
  }

  static TimeOfDay? _parseTime(String value) {
    final parts = value.split(':');
    final hour = int.tryParse(parts.elementAtOrNull(0) ?? '');
    final minute = int.tryParse(parts.elementAtOrNull(1) ?? '');
    if (hour == null || minute == null) return null;
    return TimeOfDay(hour: hour, minute: minute);
  }

  bool get _canSubmit {
    if (_day == null || _time == null || _submitting) return false;
    return switch (_type) {
      SessionType.group => _groupId != null,
      _ => _studentId != null,
    };
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
      // A class's exact start time (e.g. 14:30) is faster to type than
      // to find on a dial.
      initialEntryMode: TimePickerEntryMode.input,
    );
    if (picked != null) setState(() => _time = picked);
  }

  Future<void> _submit() async {
    final day = _day;
    final time = _time;
    if (day == null || time == null) return;

    setState(() {
      _submitting = true;
      _error = null;
    });
    final draft = SessionDraft(
      type: _type,
      dayOfWeek: day,
      startTime:
          '${time.hour.toString().padLeft(2, '0')}:'
          '${time.minute.toString().padLeft(2, '0')}',
      groupId: _type == SessionType.group ? _groupId : null,
      studentId: _type == SessionType.individual ? _studentId : null,
    );

    final l10n = AppLocalizations.of(context);
    try {
      final editing = widget.editing;
      if (editing == null) {
        await widget.controller.createSession(draft);
      } else {
        await widget.controller.updateSession(editing.id, draft);
      }
      if (mounted) Navigator.of(context).pop();
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = (error.isNetworkError || error.isServerError)
            ? l10n.sessionsServerUnavailable
            : error.message ??
                  (_isEditing
                      ? l10n.sessionsUpdateError
                      : l10n.sessionsCreateError);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final controller = widget.controller;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Center(
              //   child: Container(
              //     width: 36,
              //     height: 4,
              //     margin: const EdgeInsets.only(bottom: 16),
              //     decoration: BoxDecoration(
              //       color: scheme.outlineVariant,
              //       borderRadius: BorderRadius.circular(999),
              //     ),
              //   ),
              // ),
              Text(
                _isEditing
                    ? l10n.sessionsEditModalTitle
                    : l10n.sessionsAddModalTitle,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              _FieldLabel(l10n.sessionsTypeLabel),
              const SizedBox(height: 8),
              _TypeToggle(
                type: _type,
                onChanged: (type) => setState(() => _type = type),
              ),
              const SizedBox(height: 16),
              // The picker itself shows what it's for (its placeholder
              // is the same field name) while empty, so these need no
              // separate label above them.
              if (_type == SessionType.group) ...[
                if (controller.groups.isEmpty)
                  _Hint(l10n.sessionsNoGroups)
                else
                  PickerPill<int?>(
                    key: const ValueKey('session-form-group-or-student'),
                    value: _groupId,
                    label:
                        controller.groups
                            .where((g) => g.id == _groupId)
                            .firstOrNull
                            ?.name ??
                        l10n.sessionsGroupLabel,
                    options: [
                      for (final group in controller.groups)
                        (value: group.id, label: group.name),
                    ],
                    onChanged: (id) => setState(() => _groupId = id),
                  ),
              ] else ...[
                if (controller.studentNames.isEmpty)
                  _Hint(l10n.sessionsNoStudents)
                else
                  PickerPill<int?>(
                    key: const ValueKey('session-form-group-or-student'),
                    value: _studentId,
                    label:
                        controller.studentNames[_studentId] ??
                        l10n.sessionsStudentLabel,
                    options: [
                      for (final entry in controller.studentNames.entries)
                        (value: entry.key, label: entry.value),
                    ],
                    onChanged: (id) => setState(() => _studentId = id),
                  ),
              ],
              const SizedBox(height: 16),
              PickerPill<Weekday?>(
                key: const ValueKey('session-form-day'),
                value: _day,
                label: _day?.label(l10n) ?? l10n.sessionsDayLabel,
                options: [
                  for (final day in Weekday.values)
                    (value: day, label: day.label(l10n)),
                ],
                onChanged: (day) => setState(() => _day = day),
              ),
              const SizedBox(height: 16),
              Material(
                key: const ValueKey('session-form-time'),
                color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                  onTap: _pickTime,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                      border: Border.all(color: scheme.outlineVariant),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _time?.format(context) ?? l10n.sessionsTimeLabel,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ),
                        Icon(
                          CupertinoIcons.clock,
                          size: 16,
                          color: scheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_error case final error?) ...[
                const SizedBox(height: 16),
                Text(error, style: TextStyle(color: scheme.error)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _canSubmit ? _submit : null,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _submitting
                      ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: scheme.onPrimary,
                          ),
                        )
                      : Text(
                          _isEditing ? l10n.sessionsSave : l10n.sessionsCreate,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeToggle extends StatelessWidget {
  const _TypeToggle({required this.type, required this.onChanged});

  final SessionType type;
  final ValueChanged<SessionType> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    Widget segment(SessionType value, String label) {
      final selected = type == value;
      return Expanded(
        child: Material(
          color: selected ? scheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
          child: InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () => onChanged(value),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: selected ? scheme.onPrimary : scheme.onSurfaceVariant,
                ),
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
          segment(SessionType.group, l10n.sessionTypeGroup),
          segment(SessionType.individual, l10n.sessionTypeIndividual),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      label,
      style: Theme.of(
        context,
      ).textTheme.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
    );
  }
}

class _Hint extends StatelessWidget {
  const _Hint(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
      ),
    );
  }
}
