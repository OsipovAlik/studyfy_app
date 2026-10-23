import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/core/theme/app_theme.dart';
import 'package:studify/features/homework/domain/assignment.dart';
import 'package:studify/features/homework/homework_controller.dart';
import 'package:studify/l10n/app_localizations.dart';

/// Opens the sheet to edit an assignment's due date and note (and, for a
/// task, its title and max grade).
Future<void> showEditAssignmentSheet(
  BuildContext context, {
  required HomeworkController controller,
  required Assignment assignment,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) =>
        _EditAssignmentSheet(controller: controller, assignment: assignment),
  );
}

class _EditAssignmentSheet extends StatefulWidget {
  const _EditAssignmentSheet({
    required this.controller,
    required this.assignment,
  });

  final HomeworkController controller;
  final Assignment assignment;

  @override
  State<_EditAssignmentSheet> createState() => _EditAssignmentSheetState();
}

class _EditAssignmentSheetState extends State<_EditAssignmentSheet> {
  late final TextEditingController _title = TextEditingController(
    text: widget.assignment.title,
  );
  late final TextEditingController _maxGrade = TextEditingController(
    text: widget.assignment.maxGrade?.toString() ?? '',
  );
  late final TextEditingController _note = TextEditingController(
    text: widget.assignment.note ?? '',
  );
  late DateTime? _dueDate = widget.assignment.dueDate?.toLocal();
  bool _submitting = false;
  String? _error;

  bool get _isTask => widget.assignment.type == AssignmentType.task;

  bool get _canSubmit =>
      !_submitting && (!_isTask || _title.text.trim().isNotEmpty);

  @override
  void dispose() {
    _title.dispose();
    _maxGrade.dispose();
    _note.dispose();
    super.dispose();
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
      setState(
        () =>
            _dueDate = DateTime(picked.year, picked.month, picked.day, 23, 59),
      );
    }
  }

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _error = null;
    });

    final l10n = AppLocalizations.of(context);
    try {
      await widget.controller.updateAssignment(
        widget.assignment.id,
        note: _note.text.trim(),
        title: _isTask ? _title.text.trim() : null,
        maxGrade: _isTask ? int.tryParse(_maxGrade.text.trim()) : null,
        dueDate: _dueDate,
        clearDueDate: _dueDate == null,
      );
      if (mounted) Navigator.of(context).pop();
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = (error.isNetworkError || error.isServerError)
            ? l10n.homeworkServerUnavailable
            : error.message ?? l10n.homeworkUpdateError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toLanguageTag();

    InputDecoration decoration(String hint) => InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
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
                l10n.homeworkEditModalTitle,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              if (_isTask) ...[
                TextField(
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
                const SizedBox(height: 12),
              ],
              InkWell(
                borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                onTap: _pickDueDate,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius),
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
                          _dueDate == null
                              ? l10n.homeworkNoDueDate
                              : DateFormat.yMMMd(locale).format(_dueDate!),
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
              const SizedBox(height: 12),
              TextField(
                controller: _note,
                maxLines: 3,
                decoration: decoration(l10n.homeworkNoteHint),
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
                      : Text(l10n.subjectsSave),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
