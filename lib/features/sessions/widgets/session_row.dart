import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:studify/core/network/api_exception.dart';
import 'package:studify/core/theme/app_theme.dart';
import 'package:studify/features/call/call_screen.dart';
import 'package:studify/features/sessions/domain/class_session.dart';
import 'package:studify/features/sessions/session_display.dart';
import 'package:studify/features/sessions/timetable_controller.dart';
import 'package:studify/features/sessions/widgets/session_form_sheet.dart';
import 'package:studify/l10n/app_localizations.dart';

/// One row in the Sessions list: the start time, the group/student name
/// (or just the type) with a small type tag, and a Join call button.
/// Tapping anywhere on the row joins the call, same as the button.
class SessionRow extends StatelessWidget {
  const SessionRow({
    required this.session,
    required this.controller,
    super.key,
  });

  final ClassSession session;
  final TimetableController controller;

  Future<void> _confirmDelete(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.sessionsDeleteConfirmTitle),
        content: Text(l10n.sessionsDeleteConfirmDescription),
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
            child: Text(l10n.sessionsDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await controller.deleteSession(session.id);
    } on ApiException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            (error.isNetworkError || error.isServerError)
                ? l10n.sessionsServerUnavailable
                : error.message ?? l10n.sessionsDeleteError,
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

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => CallScreen.open(context, session),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: scheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                ),
                child: Text(
                  session.startTime,
                  style: theme.textTheme.labelLarge,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.label(session, l10n),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    _TypeTag(session: session),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: scheme.primary,
                shape: const CircleBorder(),
                child: IconButton(
                  onPressed: () => CallScreen.open(context, session),
                  tooltip: l10n.sessionJoinCall,
                  icon: Icon(
                    CupertinoIcons.video_camera_solid,
                    color: scheme.onPrimary,
                    size: 18,
                  ),
                ),
              ),
              if (controller.isTeacher) ...[
                const SizedBox(width: 4),
                PopupMenuButton<_RowAction>(
                  icon: Icon(
                    CupertinoIcons.ellipsis_vertical,
                    color: scheme.onSurfaceVariant,
                  ),
                  onSelected: (action) {
                    // Wait a frame: opening another route (the form
                    // sheet, the confirm dialog) in the same callback
                    // that closes this menu races its own pop animation.
                    unawaited(
                      Future<void>.delayed(Duration.zero).then((_) {
                        if (!context.mounted) return Future<void>.value();
                        switch (action) {
                          case _RowAction.edit:
                            return showSessionFormSheet(
                              context,
                              controller: controller,
                              editing: session,
                            );
                          case _RowAction.delete:
                            return _confirmDelete(context);
                        }
                      }),
                    );
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: _RowAction.edit,
                      child: Text(l10n.sessionsEdit),
                    ),
                    PopupMenuItem(
                      value: _RowAction.delete,
                      child: Text(
                        l10n.sessionsDelete,
                        style: TextStyle(color: scheme.error),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

enum _RowAction { edit, delete }

class _TypeTag extends StatelessWidget {
  const _TypeTag({required this.session});

  final ClassSession session;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            session.type == SessionType.group
                ? CupertinoIcons.person_2_fill
                : CupertinoIcons.calendar,
            size: 11,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            session.type.label(l10n),
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
