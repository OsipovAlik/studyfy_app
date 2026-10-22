import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/homework/data/homework_repository.dart';
import 'package:studify/features/homework/homework_controller.dart';
import 'package:studify/features/sessions/timetable_controller.dart';
import 'package:studify/features/subjects/subjects_controller.dart';
import 'package:studify/l10n/app_localizations.dart';

enum _Kind { test, task }

/// Opens the "Assign" sheet: a test already in the subject catalog, or a
/// new task, to one or more students and/or whole groups.
Future<void> showAssignHomeworkSheet(
  BuildContext context, {
  required HomeworkController controller,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => _AssignHomeworkSheet(controller: controller),
  );
}

class _AssignHomeworkSheet extends StatefulWidget {
  const _AssignHomeworkSheet({required this.controller});

  final HomeworkController controller;

  @override
  State<_AssignHomeworkSheet> createState() => _AssignHomeworkSheetState();
}

class _AssignHomeworkSheetState extends State<_AssignHomeworkSheet> {
  _Kind _kind = _Kind.test;
  int? _testId;
  final _title = TextEditingController();
  final _maxGrade = TextEditingController();
  final _note = TextEditingController();
  DateTime? _dueDate;
  final Set<int> _studentIds = {};
  final Set<int> _groupIds = {};
  PlatformFile? _attachment;
  bool _submitting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    unawaited(context.read<SubjectsController>().ensureLoaded());
    unawaited(context.read<TimetableController>().ensureLoaded());
  }

  @override
  void dispose() {
    _title.dispose();
    _maxGrade.dispose();
    _note.dispose();
    super.dispose();
  }

  bool get _canSubmit {
    if (_submitting) return false;
    if (_studentIds.isEmpty && _groupIds.isEmpty) return false;
    return switch (_kind) {
      _Kind.test => _testId != null,
      _Kind.task => _title.text.trim().isNotEmpty,
    };
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 2)),
    );
    if (picked != null) {
      // Due by the end of that day.
      setState(
        () => _dueDate = DateTime(picked.year, picked.month, picked.day, 23, 59),
      );
    }
  }

  Future<void> _pickAttachment() async {
    final file = await FilePicker.pickFile();
    if (file == null) return;
    setState(() => _attachment = file);
  }

  Future<void> _submit() async {
    if (!_canSubmit) return;
    setState(() {
      _submitting = true;
      _error = null;
    });

    final l10n = AppLocalizations.of(context);
    final studentIds = _studentIds.isEmpty ? null : _studentIds.toList();
    final groupIds = _groupIds.isEmpty ? null : _groupIds.toList();
    final note = _note.text.trim();
    try {
      final created = _kind == _Kind.test
          ? await widget.controller.createTestHomework(
              testId: _testId!,
              studentIds: studentIds,
              groupIds: groupIds,
              dueDate: _dueDate,
              note: note.isEmpty ? null : note,
            )
          : await widget.controller.createTaskHomework(
              title: _title.text.trim(),
              maxGrade: int.tryParse(_maxGrade.text.trim()),
              studentIds: studentIds,
              groupIds: groupIds,
              dueDate: _dueDate,
              note: note.isEmpty ? null : note,
            );
      // The task/test itself is created at this point; a failure past
      // here shouldn't block closing the sheet or imply nothing happened.
      if (!mounted) return;
      if (_attachment case final file? when created.isNotEmpty) {
        try {
          await context.read<HomeworkRepository>().uploadAttachment(
            assignmentIds: [for (final assignment in created) assignment.id],
            file: file,
          );
        } on ApiException {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.homeworkUploadError)),
            );
          }
        }
      }
      if (mounted) Navigator.of(context).pop();
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = (error.isNetworkError || error.isServerError) ? l10n.homeworkServerUnavailable : error.message ?? l10n.homeworkAssignError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final timetable = context.watch<TimetableController>();
    final subjects = context.watch<SubjectsController>();
    final subjectNameById = {for (final s in subjects.subjects) s.id: s.name};

    InputDecoration decoration(String hint) => InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
    );

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
              Text(
                l10n.homeworkAssignModalTitle,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _KindToggle(
                kind: _kind,
                onChanged: (kind) => setState(() => _kind = kind),
              ),
              const SizedBox(height: 16),
              if (_kind == _Kind.test) ...[
                if (widget.controller.assignableTests.isEmpty)
                  _Hint(l10n.homeworkNoActiveTests)
                else
                  DropdownButtonFormField<int>(
                    key: const ValueKey('assign-homework-test'),
                    initialValue: _testId,
                    decoration: decoration(l10n.homeworkTestLabel),
                    isExpanded: true,
                    items: [
                      for (final test in widget.controller.assignableTests)
                        DropdownMenuItem(
                          value: test.id,
                          child: Text(
                            subjectNameById[test.subjectId] != null ? '${test.title} — ${subjectNameById[test.subjectId]}' : test.title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                    onChanged: (id) => setState(() => _testId = id),
                  ),
              ] else ...[
                TextField(
                  key: const ValueKey('assign-homework-title'),
                  controller: _title,
                  decoration: decoration(l10n.homeworkTaskTitlePlaceholder),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _maxGrade,
                  keyboardType: TextInputType.number,
                  decoration: decoration(l10n.homeworkMaxGradeHint),
                ),
                const SizedBox(height: 16),
                _FieldLabel(l10n.homeworkAttachmentLabel),
                const SizedBox(height: 8),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => unawaited(_pickAttachment()),
                      icon: const Icon(CupertinoIcons.paperclip, size: 16),
                      label: Text(l10n.homeworkUploadFile),
                    ),
                    if (_attachment case final file?) ...[
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          file.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(() => _attachment = null),
                        icon: const Icon(
                          CupertinoIcons.xmark_circle_fill,
                          size: 18,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
              const SizedBox(height: 16),
              _FieldLabel(l10n.homeworkDueDateLabel),
              const SizedBox(height: 8),
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _pickDueDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: scheme.outlineVariant),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.calendar,
                        size: 18,
                        color: scheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _dueDate == null ? l10n.homeworkNoDueDate : DateFormat.yMMMd(locale).format(_dueDate!),
                        ),
                      ),
                      if (_dueDate != null)
                        IconButton(
                          icon: const Icon(
                            CupertinoIcons.xmark_circle_fill,
                            size: 18,
                          ),
                          onPressed: () => setState(() => _dueDate = null),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _note,
                maxLines: 3,
                decoration: decoration(l10n.homeworkNoteHint),
              ),
              const SizedBox(height: 16),
              _FieldLabel(l10n.homeworkAssignToLabel),
              const SizedBox(height: 8),
              if (timetable.groups.isEmpty && timetable.studentNames.isEmpty)
                _Hint(l10n.homeworkNoStudentsHint)
              else
                Container(
                  constraints: const BoxConstraints(maxHeight: 240),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: scheme.outlineVariant),
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    children: [
                      if (timetable.groups.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                          child: Text(
                            l10n.homeworkGroupsLabel,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        for (final group in timetable.groups)
                          CheckboxListTile(
                            key: ValueKey('assign-homework-group-${group.id}'),
                            dense: true,
                            value: _groupIds.contains(group.id),
                            title: Text(group.name),
                            onChanged: (checked) => setState(() {
                              if (checked ?? false) {
                                _groupIds.add(group.id);
                              } else {
                                _groupIds.remove(group.id);
                              }
                            }),
                          ),
                      ],
                      if (timetable.studentNames.isNotEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                          child: Text(
                            l10n.homeworkStudentsLabel,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                        for (final entry in timetable.studentNames.entries)
                          CheckboxListTile(
                            key: ValueKey(
                              'assign-homework-student-${entry.key}',
                            ),
                            dense: true,
                            value: _studentIds.contains(entry.key),
                            title: Text(entry.value),
                            onChanged: (checked) => setState(() {
                              if (checked ?? false) {
                                _studentIds.add(entry.key);
                              } else {
                                _studentIds.remove(entry.key);
                              }
                            }),
                          ),
                      ],
                    ],
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
                      : Text(l10n.homeworkAssignButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KindToggle extends StatelessWidget {
  const _KindToggle({required this.kind, required this.onChanged});

  final _Kind kind;
  final ValueChanged<_Kind> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;

    Widget segment(_Kind value, String label) {
      final selected = kind == value;
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
          segment(_Kind.test, l10n.homeworkKindTest),
          segment(_Kind.task, l10n.homeworkKindTask),
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
        borderRadius: BorderRadius.circular(14),
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
