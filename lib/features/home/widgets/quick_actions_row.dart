import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/router/app_router.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/core/widgets/glass_surface.dart';
import 'package:studify/features/auth/auth_controller.dart';
import 'package:studify/features/auth/domain/user_profile.dart';
import 'package:studify/l10n/app_localizations.dart';

/// Three quick-jump tiles under the greeting — a teacher's or student's
/// most common next step, one tap away, in the icon-tile-row pattern
/// reference apps use instead of burying everything in menus.
class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final role = context.read<AuthController>().user?.role;
    final isTeacher = role == UserRole.teacher;

    // Labels here deliberately differ from the bottom bar's own tab
    // names (e.g. "Add student", not "Students") — these are shortcuts
    // to a specific next step, not a second way to say the tab's name.
    final actions = isTeacher
        ? [
            (
              icon: CupertinoIcons.person_2_fill,
              label: l10n.studentsAddStudent,
              color: AppColors.blue500,
              onTap: () => context.go(AppRoutes.students),
            ),
            (
              icon: CupertinoIcons.calendar,
              label: l10n.sessionsAddSession,
              color: AppColors.emerald500,
              onTap: () => context.go(AppRoutes.sessions),
            ),
            (
              icon: CupertinoIcons.doc_text_fill,
              label: l10n.homeworkAssignButton,
              color: AppColors.amber500,
              onTap: () => context.go(AppRoutes.homework),
            ),
          ]
        : [
            (
              icon: CupertinoIcons.doc_text_fill,
              label: l10n.homeworkTitleStudent,
              color: AppColors.amber500,
              onTap: () => context.go(AppRoutes.homework),
            ),
            (
              icon: CupertinoIcons.calendar,
              label: l10n.homeTimetableViewCalendar,
              color: AppColors.emerald500,
              onTap: () => context.go(AppRoutes.sessions),
            ),
            (
              icon: CupertinoIcons.chart_bar_alt_fill,
              label: l10n.resultsPageTitle,
              color: AppColors.indigo500,
              onTap: () => context.push(AppRoutes.results),
            ),
          ];

    return Row(
      children: [
        for (var i = 0; i < actions.length; i++) ...[
          if (i > 0) const SizedBox(width: 10),
          Expanded(child: _QuickActionTile(action: actions[i])),
        ],
      ],
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  const _QuickActionTile({required this.action});

  final ({IconData icon, String label, Color color, VoidCallback onTap}) action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassSurface(
      blurred: false,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      onTap: action.onTap,
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: action.color.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(action.icon, size: 19, color: action.color),
          ),
          const SizedBox(height: 8),
          Text(
            action.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
