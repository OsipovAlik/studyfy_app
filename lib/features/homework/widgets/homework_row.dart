import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/features/homework/domain/assignment.dart';
import 'package:studify/l10n/app_localizations.dart';

/// One row in the Homework list: the assignment's title, who it's for
/// (teachers only), due date and status.
class HomeworkRow extends StatelessWidget {
  const HomeworkRow({
    required this.assignment,
    required this.showStudentName,
    required this.onTap,
    super.key,
  });

  final Assignment assignment;
  final bool showStudentName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final statusColor = statusColorOf(assignment.status);
    final dueDate = assignment.dueDate;

    final subtitleParts = [
      if (showStudentName) assignment.studentFullName,
      if (dueDate != null)
        l10n.homeworkDueOn(DateFormat.yMMMd(locale).format(dueDate.toLocal())),
    ];

    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.14),
          shape: BoxShape.circle,
        ),
        child: Icon(
          assignment.type == AssignmentType.test
              ? CupertinoIcons.doc_text_fill
              : CupertinoIcons.pencil_outline,
          size: 18,
          color: scheme.primary,
        ),
      ),
      title: Text(
        assignment.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleSmall,
      ),
      subtitle: subtitleParts.isEmpty
          ? null
          : Text(
              subtitleParts.join(' · '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          statusLabelOf(assignment.status, l10n),
          style: theme.textTheme.labelSmall?.copyWith(color: statusColor),
        ),
      ),
    );
  }
}

Color statusColorOf(AssignmentStatus status) => switch (status) {
  AssignmentStatus.completed => AppColors.emerald500,
  AssignmentStatus.overdue => AppColors.red500,
  AssignmentStatus.pending || AssignmentStatus.unknown => AppColors.amber500,
};

String statusLabelOf(AssignmentStatus status, AppLocalizations l10n) =>
    switch (status) {
      AssignmentStatus.completed => l10n.homeworkStatusCompleted,
      AssignmentStatus.overdue => l10n.homeworkStatusOverdue,
      AssignmentStatus.pending ||
      AssignmentStatus.unknown => l10n.homeworkStatusPending,
    };
