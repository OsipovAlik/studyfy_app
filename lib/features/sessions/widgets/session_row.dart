import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:studify/features/call/call_screen.dart';
import 'package:studify/features/sessions/domain/class_session.dart';
import 'package:studify/features/sessions/session_display.dart';
import 'package:studify/features/sessions/timetable_controller.dart';
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
                  borderRadius: BorderRadius.circular(10),
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
            ],
          ),
        ),
      ),
    );
  }
}

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
