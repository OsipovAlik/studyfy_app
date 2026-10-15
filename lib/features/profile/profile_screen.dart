import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/router/app_router.dart';
import 'package:studify/core/theme/app_colors.dart';
import 'package:studify/core/widgets/brand_backdrop.dart';
import 'package:studify/core/widgets/grouped_list.dart';
import 'package:studify/features/auth/auth_controller.dart';
import 'package:studify/features/auth/domain/user_profile.dart';
import 'package:studify/l10n/app_localizations.dart';

/// The Profile tab: who is signed in, links to settings and the legal
/// pages, and Log out.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _confirmSignOut(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final auth = context.read<AuthController>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.logoutConfirmTitle),
        content: Text(l10n.logoutConfirmDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.logout),
          ),
        ],
      ),
    );
    if (confirmed ?? false) unawaited(auth.signOut());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final user = context.watch<AuthController>().user;
    if (user == null) return const Scaffold();

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: BrandBackdrop()),
          // The bottom safe area includes the floating tab bar.
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              children: [
                Text(l10n.tabProfile, style: theme.textTheme.headlineLarge),
                const SizedBox(height: 24),
                _Card(
                  child: Row(
                    children: [
                      _Avatar(user: user),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.homeWelcome(user.name),
                              style: theme.textTheme.titleLarge,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              user.email,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                GroupedSection(
                  children: [
                    GroupedTile(
                      icon: CupertinoIcons.settings,
                      label: l10n.settingsTitle,
                      onTap: () => context.go(AppRoutes.settings),
                    ),
                    GroupedTile(
                      icon: CupertinoIcons.lock_shield_fill,
                      color: scheme.secondary,
                      label: l10n.privacyPolicy,
                      onTap: () => context.go(AppRoutes.privacyPolicy),
                    ),
                    GroupedTile(
                      icon: CupertinoIcons.doc_text_fill,
                      color: scheme.tertiary,
                      label: l10n.termsOfUse,
                      onTap: () => context.go(AppRoutes.termsOfUse),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () => _confirmSignOut(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: scheme.error,
                    side: BorderSide(
                      color: scheme.error.withValues(alpha: 0.4),
                    ),
                  ),
                  icon: const Icon(CupertinoIcons.square_arrow_right),
                  label: Text(l10n.logout),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: child,
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final initials = [user.name, user.surname]
        .where((part) => part.isNotEmpty)
        .map((part) => part.characters.first.toUpperCase())
        .join();
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: AppColors.brandGradient,
        shape: BoxShape.circle,
      ),
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: Theme.of(
          context,
        ).textTheme.titleLarge?.copyWith(color: Colors.white),
      ),
    );
  }
}
