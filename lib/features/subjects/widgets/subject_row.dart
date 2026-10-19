import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/features/subjects/domain/subject.dart';
import 'package:studify/features/subjects/subjects_controller.dart';
import 'package:studify/features/subjects/widgets/subject_form_sheet.dart';
import 'package:studify/l10n/app_localizations.dart';

/// One row in the Subjects tab: the subject's name and active/inactive
/// status. A student just sees the row; a teacher can rename, activate
/// or deactivate, and delete it from a menu.
class SubjectRow extends StatelessWidget {
  const SubjectRow({required this.subject, required this.controller, super.key});

  final Subject subject;
  final SubjectsController controller;

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.subjectsDeleteConfirmTitle(subject.name)),
        content: Text(l10n.subjectsDeleteConfirmDescription),
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
            child: Text(l10n.subjectsDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await controller.deleteSubject(subject.id);
    } on ApiException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (error.isNetworkError || error.isServerError)
                ? l10n.subjectsServerUnavailable
                : error.message ?? l10n.subjectsDeleteError,
          ),
        ),
      );
    }
  }

  Future<void> _toggleActive(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      await controller.toggleActive(subject.id);
    } on ApiException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (error.isNetworkError || error.isServerError)
                ? l10n.subjectsServerUnavailable
                : error.message ?? l10n.subjectsActivateError,
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

    return ListTile(
      onTap: controller.isTeacher
          ? () => context.push('/subjects/${subject.id}')
          : null,
      leading: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(CupertinoIcons.book_fill, size: 18, color: scheme.primary),
      ),
      title: Text(subject.name, style: theme.textTheme.titleSmall),
      subtitle: controller.isTeacher
          ? _StatusBadge(isActive: subject.isActive)
          : null,
      trailing: controller.isTeacher
          ? PopupMenuButton<_RowAction>(
              icon: Icon(
                CupertinoIcons.ellipsis_vertical,
                color: scheme.onSurfaceVariant,
              ),
              onSelected: (action) {
                // Deferred so this doesn't race the menu's own closing
                // animation (same reason as GroupRow/SessionRow).
                unawaited(
                  Future<void>.delayed(Duration.zero).then((_) {
                    if (!context.mounted) return Future<void>.value();
                    switch (action) {
                      case _RowAction.toggleActive:
                        return _toggleActive(context);
                      case _RowAction.rename:
                        return showSubjectFormSheet(
                          context,
                          controller: controller,
                          editing: subject,
                        );
                      case _RowAction.delete:
                        return _confirmDelete(context);
                    }
                  }),
                );
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: _RowAction.toggleActive,
                  child: Text(
                    subject.isActive
                        ? l10n.subjectsDeactivate
                        : l10n.subjectsActivate,
                  ),
                ),
                PopupMenuItem(
                  value: _RowAction.rename,
                  child: Text(l10n.subjectsRename),
                ),
                PopupMenuItem(
                  value: _RowAction.delete,
                  child: Text(
                    l10n.subjectsDelete,
                    style: TextStyle(color: scheme.error),
                  ),
                ),
              ],
            )
          : null,
    );
  }
}

enum _RowAction { toggleActive, rename, delete }

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final color = isActive ? Colors.green : scheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 7,
          height: 7,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Text(
          isActive ? l10n.subjectsActiveLabel : l10n.subjectsInactiveLabel,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: color),
        ),
      ],
    );
  }
}
