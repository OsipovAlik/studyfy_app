import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/core/router/app_router.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/core/theme/app_theme.dart';
import 'package:studify/features/auth/widgets/auth_widgets.dart';
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
    final assignment = controller.assignments.where((a) => a.id == assignmentId).firstOrNull;

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
        _HeroHeader(assignment: assignment, controller: controller),
        const SizedBox(height: 16),
        _DetailsCard(assignment: assignment, isTeacher: controller.isTeacher),
        const SizedBox(height: 16),
        if (assignment.note case final note? when note.isNotEmpty) ...[
          _NoteCard(note: note),
          const SizedBox(height: 16),
        ],
        if (assignment.type == AssignmentType.test)
          _TestSection(assignment: assignment, controller: controller)
        else
          _TaskSection(assignment: assignment, controller: controller),
      ],
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.assignment, required this.controller});

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
            (error.isNetworkError || error.isServerError) ? l10n.homeworkServerUnavailable : error.message ?? l10n.homeworkDeleteError,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final statusColor = statusColorOf(assignment.status);
    final dueDate = assignment.dueDate;
    final isTeacher = controller.isTeacher;
    final isTest = assignment.type == AssignmentType.test;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.primary.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isTest ? CupertinoIcons.doc_text_fill : CupertinoIcons.pencil_outline,
              size: 20,
              color: scheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Badge(
                      label: isTest ? l10n.homeworkKindTest : l10n.homeworkKindTask,
                      color: scheme.onSurfaceVariant,
                      background: scheme.surfaceContainerHigh,
                    ),
                    _Badge(
                      label: statusLabelOf(assignment.status, l10n),
                      color: statusColor,
                      background: statusColor.withValues(alpha: 0.14),
                      dot: true,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(assignment.title, style: theme.textTheme.titleLarge),
                if (isTeacher) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _InitialsAvatar(name: assignment.studentFullName),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          assignment.studentFullName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
                if (dueDate != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.calendar,
                        size: 14,
                        color: scheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          l10n.homeworkDueOn(
                            DateFormat.yMMMd(
                              locale,
                            ).add_jm().format(dueDate.toLocal()),
                          ),
                          maxLines: 2,

                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          if (isTeacher) ...[
            IconButton(
              key: const ValueKey('assignment-detail-edit'),
              onPressed: () => unawaited(
                showEditAssignmentSheet(
                  context,
                  controller: controller,
                  assignment: assignment,
                ),
              ),
              icon: const Icon(CupertinoIcons.pencil, size: 18),
              tooltip: l10n.homeworkEdit,
            ),
            IconButton(
              key: const ValueKey('assignment-detail-delete'),
              onPressed: () => unawaited(_confirmDelete(context)),
              icon: Icon(CupertinoIcons.trash, size: 18, color: scheme.error),
              tooltip: l10n.homeworkDelete,
            ),
          ],
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.color,
    required this.background,
    this.dot = false,
  });

  final String label;
  final Color color;
  final Color background;
  final bool dot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  const _InitialsAvatar({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final initials = name.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty).take(2).map((part) => part[0].toUpperCase()).join();

    return Container(
      width: 26,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: scheme.primary, shape: BoxShape.circle),
      child: Text(
        initials,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: scheme.onPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  const _DetailsCard({required this.assignment, required this.isTeacher});

  final Assignment assignment;
  final bool isTeacher;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dateFormat = DateFormat.yMMMd(locale).add_jm();
    final isTest = assignment.type == AssignmentType.test;

    final rows = [
      _DetailRowData(
        icon: CupertinoIcons.checkmark_seal,
        label: l10n.homeworkStatusLabel,
        value: statusLabelOf(assignment.status, l10n),
        valueColor: statusColorOf(assignment.status),
      ),
      _DetailRowData(
        icon: isTest ? CupertinoIcons.doc_text : CupertinoIcons.pencil_outline,
        label: l10n.homeworkTypeLabel,
        value: isTest ? l10n.homeworkKindTest : l10n.homeworkKindTask,
      ),
      if (isTeacher)
        _DetailRowData(
          icon: CupertinoIcons.person,
          label: l10n.homeworkStudentLabel,
          value: assignment.studentFullName,
        ),
      if (assignment.createdAt case final createdAt?)
        _DetailRowData(
          icon: CupertinoIcons.calendar,
          label: l10n.homeworkAssignedLabel,
          value: dateFormat.format(createdAt.toLocal()),
        ),
      if (assignment.dueDate case final dueDate?)
        _DetailRowData(
          icon: CupertinoIcons.calendar,
          label: l10n.homeworkDueDateLabel,
          value: dateFormat.format(dueDate.toLocal()),
        ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.homeworkDetailsLabel, style: theme.textTheme.labelLarge),
          const SizedBox(height: 10),
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0) Divider(height: 20, color: scheme.outlineVariant),
            _DetailRow(data: rows[i]),
          ],
        ],
      ),
    );
  }
}

class _DetailRowData {
  const _DetailRowData({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.data});

  final _DetailRowData data;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: scheme.surfaceContainerHigh,
            shape: BoxShape.circle,
          ),
          child: Icon(data.icon, size: 16, color: scheme.onSurfaceVariant),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              Text(
                data.value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: data.valueColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14, color: scheme.primary),
              ),
              const SizedBox(width: 8),
              Text(title, style: theme.textTheme.labelLarge),
            ],
          ),
          const SizedBox(height: 10),
          child,
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
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
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
    final isTeacher = controller.isTeacher;

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
        if (assignment.status == AssignmentStatus.completed && percentage != null) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
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
                    onPressed: () => context.push('${AppRoutes.results}/$resultId'),
                    child: Text(l10n.homeworkViewResult),
                  ),
              ],
            ),
          ),
        ] else if (isTeacher) ...[
          _SectionCard(
            icon: CupertinoIcons.doc_text,
            title: l10n.homeworkKindTest,
            child: Text(
              l10n.homeworkTestNotHandedIn,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
        ] else ...[
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
        const SizedBox(height: 18),
        AttachmentsSection(
          assignmentId: assignment.id,
          kind: AttachmentKind.material,
          title: l10n.homeworkFilesLabel,
          canUpload: isTeacher,
          canDelete: isTeacher,
        ),
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
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              border: Border.all(color: scheme.outlineVariant),
            ),
            child: Text(text, style: theme.textTheme.bodyMedium),
          ),
        if (text != null && text.isNotEmpty && !assignment.isGraded) ...[
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsetsDirectional.only(start: 24, end: 6),
              ),
              onPressed: () => unawaited(
                showGradeSheet(
                  context,
                  controller: controller,
                  assignment: assignment,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      l10n.homeworkGradeButton,
                      overflow: TextOverflow.fade,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const CtaArrowBadge(),
                ],
              ),
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
        () => _error = (error.isNetworkError || error.isServerError) ? l10n.homeworkServerUnavailable : error.message ?? l10n.homeworkSubmitError,
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
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
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
            child: BusyButton(
              label:
                  widget.assignment.submissionText == null || widget.assignment.submissionText!.isEmpty
                      ? l10n.homeworkSubmitButton
                      : l10n.homeworkResubmitButton,
              busy: _submitting,
              showArrow: true,
              onPressed: () => unawaited(_submit()),
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
            (error.isNetworkError || error.isServerError) ? l10n.homeworkServerUnavailable : error.message ?? l10n.homeworkUnlockError,
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
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
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
          if (assignment.feedback case final feedback? when feedback.isNotEmpty) ...[
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
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
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
