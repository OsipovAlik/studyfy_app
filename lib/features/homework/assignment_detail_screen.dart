import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/core/router/app_router.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/features/homework/domain/assignment.dart';
import 'package:studify/features/homework/domain/homework_attachment.dart';
import 'package:studify/features/homework/homework_controller.dart';
import 'package:studify/features/homework/widgets/attachments_section.dart';
import 'package:studify/features/homework/widgets/edit_assignment_sheet.dart';
import 'package:studify/features/homework/widgets/grade_sheet.dart';
import 'package:studify/features/homework/widgets/homework_row.dart';
import 'package:studify/features/shell/sub_page.dart';
import 'package:studify/l10n/app_localizations.dart';

/// One assignment: its due date/note, the test or task itself, and —
/// for a task — the submission and grading.
class AssignmentDetailScreen extends StatelessWidget {
  const AssignmentDetailScreen({required this.assignmentId, super.key});

  final int assignmentId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final controller = context.watch<HomeworkController>();
    final assignment = controller.assignments
        .where((a) => a.id == assignmentId)
        .firstOrNull;

    if (assignment == null) {
      return SubPage(
        title: l10n.homeworkDetailNotFoundTitle,
        onRefresh: controller.reload,
        children: [
          Text(
            l10n.homeworkDetailNotFoundDescription,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      );
    }

    return SubPage(
      title: assignment.title,
      onRefresh: controller.reload,
      children: [
        _StatusHeader(assignment: assignment),
        const SizedBox(height: 16),
        if (assignment.note case final note? when note.isNotEmpty) ...[
          _NoteCard(note: note),
          const SizedBox(height: 16),
        ],
        if (assignment.type == AssignmentType.test)
          _TestSection(assignment: assignment, controller: controller)
        else
          _TaskSection(assignment: assignment, controller: controller),
        if (controller.isTeacher) ...[
          const SizedBox(height: 20),
          _TeacherActions(assignment: assignment, controller: controller),
        ],
      ],
    );
  }
}

class _StatusHeader extends StatelessWidget {
  const _StatusHeader({required this.assignment});

  final Assignment assignment;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final color = statusColorOf(assignment.status);
    final dueDate = assignment.dueDate;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              statusLabelOf(assignment.status, l10n),
              style: theme.textTheme.labelMedium?.copyWith(color: color),
            ),
          ),
          const Spacer(),
          if (dueDate != null)
            Text(
              l10n.homeworkDueOn(
                DateFormat.yMMMd(locale).format(dueDate.toLocal()),
              ),
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note});

  final String note;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.homeworkNoteLabel,
            style: theme.textTheme.labelSmall?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(note, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

class _TestSection extends StatelessWidget {
  const _TestSection({required this.assignment, required this.controller});

  final Assignment assignment;
  final HomeworkController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final percentage = assignment.percentage;
    final resultId = assignment.resultId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (assignment.testTimeLimitMinutes case final minutes?)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              l10n.homeworkTimeLimitMinutes(minutes),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        if (assignment.status == AssignmentStatus.completed &&
            percentage != null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Row(
              children: [
                Text(
                  '${percentage.round()}%',
                  style: theme.textTheme.headlineSmall,
                ),
                const SizedBox(width: 12),
                Text(
                  '${assignment.score} / ${assignment.total}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                if (resultId != null)
                  TextButton(
                    onPressed: () =>
                        context.push('${AppRoutes.results}/$resultId'),
                    child: Text(l10n.homeworkViewResult),
                  ),
              ],
            ),
          ),
        ] else if (!controller.isTeacher) ...[
          if (!assignment.testIsActive)
            _Hint(l10n.homeworkTestUnavailable)
          else ...[
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: null,
                child: Text(l10n.homeworkStartTest),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.homeworkStartTestComingSoon,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ],
    );
  }
}

class _TaskSection extends StatelessWidget {
  const _TaskSection({required this.assignment, required this.controller});

  final Assignment assignment;
  final HomeworkController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isTeacher = controller.isTeacher;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (assignment.maxGrade case final maxGrade?)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              l10n.homeworkMaxGradeValue(maxGrade),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        AttachmentsSection(
          assignmentId: assignment.id,
          kind: AttachmentKind.material,
          title: l10n.homeworkMaterialsLabel,
          canUpload: isTeacher,
          canDelete: isTeacher,
        ),
        const SizedBox(height: 18),
        if (isTeacher)
          _SubmissionReview(assignment: assignment, controller: controller)
        else
          _SubmissionForm(assignment: assignment, controller: controller),
        const SizedBox(height: 12),
        AttachmentsSection(
          assignmentId: assignment.id,
          kind: AttachmentKind.submission,
          title: l10n.homeworkSubmissionFilesLabel,
          canUpload: !isTeacher && !assignment.isGraded,
          canDelete: !isTeacher && !assignment.isGraded,
        ),
        if (assignment.isGraded) ...[
          const SizedBox(height: 18),
          _GradeCard(assignment: assignment, controller: controller),
        ],
      ],
    );
  }
}

class _SubmissionReview extends StatelessWidget {
  const _SubmissionReview({required this.assignment, required this.controller});

  final Assignment assignment;
  final HomeworkController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final text = assignment.submissionText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.homeworkSubmissionLabel,
          style: theme.textTheme.labelMedium,
        ),
        const SizedBox(height: 8),
        if (text == null || text.isEmpty)
          Text(
            l10n.homeworkNoSubmissionYet,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Text(text, style: theme.textTheme.bodyMedium),
          ),
        if (text != null && text.isNotEmpty && !assignment.isGraded) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => unawaited(
                showGradeSheet(
                  context,
                  controller: controller,
                  assignment: assignment,
                ),
              ),
              child: Text(l10n.homeworkGradeButton),
            ),
          ),
        ],
      ],
    );
  }
}

class _SubmissionForm extends StatefulWidget {
  const _SubmissionForm({required this.assignment, required this.controller});

  final Assignment assignment;
  final HomeworkController controller;

  @override
  State<_SubmissionForm> createState() => _SubmissionFormState();
}

class _SubmissionFormState extends State<_SubmissionForm> {
  late final TextEditingController _text = TextEditingController(
    text: widget.assignment.submissionText ?? '',
  );
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    final l10n = AppLocalizations.of(context);
    try {
      await widget.controller.submitTask(
        widget.assignment.id,
        text: _text.text.trim(),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(
        () => _error = (error.isNetworkError || error.isServerError)
            ? l10n.homeworkServerUnavailable
            : error.message ?? l10n.homeworkSubmitError,
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isGraded = widget.assignment.isGraded;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.homeworkSubmissionLabel, style: theme.textTheme.labelMedium),
        const SizedBox(height: 8),
        TextField(
          controller: _text,
          maxLines: 4,
          enabled: !isGraded,
          decoration: InputDecoration(
            hintText: l10n.homeworkSubmissionHint,
            filled: true,
            fillColor: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: scheme.outlineVariant),
            ),
          ),
        ),
        if (_error case final error?) ...[
          const SizedBox(height: 8),
          Text(error, style: TextStyle(color: scheme.error)),
        ],
        if (!isGraded) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submitting ? null : () => unawaited(_submit()),
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
                      widget.assignment.submissionText == null ||
                              widget.assignment.submissionText!.isEmpty
                          ? l10n.homeworkSubmitButton
                          : l10n.homeworkResubmitButton,
                    ),
            ),
          ),
        ],
      ],
    );
  }
}

class _GradeCard extends StatelessWidget {
  const _GradeCard({required this.assignment, required this.controller});

  final Assignment assignment;
  final HomeworkController controller;

  Future<void> _unlock(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      await controller.unlockGrade(assignment.id);
    } on ApiException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (error.isNetworkError || error.isServerError)
                ? l10n.homeworkServerUnavailable
                : error.message ?? l10n.homeworkUnlockError,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final max = assignment.maxGrade ?? 100;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.emerald500.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.emerald500.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${assignment.grade} / $max',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.emerald500,
                ),
              ),
              const Spacer(),
              if (controller.isTeacher)
                TextButton(
                  onPressed: () => unawaited(_unlock(context)),
                  child: Text(l10n.homeworkUnlockButton),
                ),
            ],
          ),
          if (assignment.feedback case final feedback?
              when feedback.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(feedback, style: theme.textTheme.bodyMedium),
          ],
        ],
      ),
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
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
      ),
    );
  }
}

class _TeacherActions extends StatelessWidget {
  const _TeacherActions({required this.assignment, required this.controller});

  final Assignment assignment;
  final HomeworkController controller;

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.homeworkDeleteConfirmTitle(assignment.title)),
        content: Text(l10n.homeworkDeleteConfirmDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.homeworkDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await controller.deleteAssignment(assignment.id);
      if (context.mounted) context.pop();
    } on ApiException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (error.isNetworkError || error.isServerError)
                ? l10n.homeworkServerUnavailable
                : error.message ?? l10n.homeworkDeleteError,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => unawaited(
              showEditAssignmentSheet(
                context,
                controller: controller,
                assignment: assignment,
              ),
            ),
            icon: const Icon(CupertinoIcons.pencil, size: 16),
            label: Text(l10n.homeworkEdit),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => unawaited(_confirmDelete(context)),
            style: OutlinedButton.styleFrom(
              foregroundColor: scheme.error,
              side: BorderSide(color: scheme.error.withValues(alpha: 0.4)),
            ),
            icon: const Icon(CupertinoIcons.trash, size: 16),
            label: Text(l10n.homeworkDelete),
          ),
        ),
      ],
    );
  }
}
