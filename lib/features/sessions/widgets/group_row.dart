import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/core/theme/app_theme.dart';
import 'package:studify/features/sessions/domain/group.dart';
import 'package:studify/features/sessions/timetable_controller.dart';
import 'package:studify/features/sessions/widgets/group_form_sheet.dart';
import 'package:studify/l10n/app_localizations.dart';

/// One row in the Groups tab: the group's name and member count.
/// Teachers can tap through to the member roster, and rename/delete the
/// group from a menu; a student just sees the row.
class GroupRow extends StatelessWidget {
  const GroupRow({required this.group, required this.controller, super.key});

  final Group group;
  final TimetableController controller;

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.groupsDeleteConfirmTitle(group.name)),
        content: Text(l10n.groupsDeleteConfirmDescription),
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
            child: Text(l10n.groupsDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await controller.deleteGroup(group.id);
    } on ApiException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (error.isNetworkError || error.isServerError)
                ? l10n.groupsServerUnavailable
                : error.message ?? l10n.groupsDeleteError,
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
    final isTeacher = controller.isTeacher;

    return ListTile(
      onTap: isTeacher
          ? () => context.push('/sessions/groups/${group.id}')
          : null,
      leading: Container(
        width: 38,
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        ),
        child: Icon(
          CupertinoIcons.person_2_fill,
          size: 18,
          color: scheme.primary,
        ),
      ),
      title: Text(group.name, style: theme.textTheme.titleSmall),
      subtitle: Text(l10n.groupMembers(group.memberCount)),
      trailing: isTeacher
          ? PopupMenuButton<_RowAction>(
              icon: Icon(
                CupertinoIcons.ellipsis_vertical,
                color: scheme.onSurfaceVariant,
              ),
              onSelected: (action) {
                // See SessionRow: deferred so this doesn't race the
                // menu's own closing animation.
                unawaited(
                  Future<void>.delayed(Duration.zero).then((_) {
                    if (!context.mounted) return Future<void>.value();
                    switch (action) {
                      case _RowAction.rename:
                        return showGroupFormSheet(
                          context,
                          controller: controller,
                          editing: group,
                        );
                      case _RowAction.delete:
                        return _confirmDelete(context);
                    }
                  }),
                );
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: _RowAction.rename,
                  child: Text(l10n.groupsRename),
                ),
                PopupMenuItem(
                  value: _RowAction.delete,
                  child: Text(
                    l10n.groupsDelete,
                    style: TextStyle(color: scheme.error),
                  ),
                ),
              ],
            )
          : null,
    );
  }
}

enum _RowAction { rename, delete }
