import 'package:flutter/material.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/core/theme/app_theme.dart';
import 'package:studify/features/auth/widgets/auth_widgets.dart';
import 'package:studify/features/homework/domain/assignment.dart';
import 'package:studify/features/homework/homework_controller.dart';
import 'package:studify/l10n/app_localizations.dart';

/// Opens the grading sheet for a task homework's submission.
Future<void> showGradeSheet(
  BuildContext context, {
  required HomeworkController controller,
  required Assignment assignment,
}) {
  return showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    builder: (_) => _GradeSheet(controller: controller, assignment: assignment),
  );
}

class _GradeSheet extends StatefulWidget {
  const _GradeSheet({required this.controller, required this.assignment});

  final HomeworkController controller;
  final Assignment assignment;

  @override
  State<_GradeSheet> createState() => _GradeSheetState();
}

class _GradeSheetState extends State<_GradeSheet> {
  late final TextEditingController _grade = TextEditingController(
    text: widget.assignment.grade?.toString() ?? '',
  );
  late final TextEditingController _feedback = TextEditingController(
    text: widget.assignment.feedback ?? '',
  );
  bool _submitting = false;
  String? _error;

  int get _maxGrade => widget.assignment.maxGrade ?? 100;

  bool get _canSubmit {
    if (_submitting) return false;
    final value = int.tryParse(_grade.text.trim());
    return value != null && value >= 0 && value <= _maxGrade;
  }

  @override
  void dispose() {
    _grade.dispose();
    _feedback.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final value = int.tryParse(_grade.text.trim());
    if (value == null) return;

    setState(() {
      _submitting = true;
      _error = null;
    });

    final l10n = AppLocalizations.of(context);
    final feedback = _feedback.text.trim();
    try {
      await widget.controller.gradeAssignment(
        widget.assignment.id,
        grade: value,
        feedback: feedback.isEmpty ? null : feedback,
      );
      if (mounted) Navigator.of(context).pop();
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = (error.isNetworkError || error.isServerError)
            ? l10n.homeworkServerUnavailable
            : error.message ?? l10n.homeworkGradeError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

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
                l10n.homeworkGradeModalTitle,
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 20),
              TextField(
                key: const ValueKey('grade-sheet-grade'),
                controller: _grade,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: decoration(l10n.homeworkGradeHint(_maxGrade)),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _feedback,
                maxLines: 3,
                decoration: decoration(l10n.homeworkFeedbackHint),
              ),
              if (_error case final error?) ...[
                const SizedBox(height: 16),
                Text(error, style: TextStyle(color: scheme.error)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: BusyButton(
                  label: l10n.homeworkSaveGrade,
                  busy: _submitting,
                  showArrow: true,
                  onPressed: _canSubmit ? _submit : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
