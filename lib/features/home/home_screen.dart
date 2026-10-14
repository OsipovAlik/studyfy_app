import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/widgets/brand_backdrop.dart';
import 'package:studify/core/widgets/language_button.dart';
import 'package:studify/core/widgets/studyfy_logo.dart';
import 'package:studify/features/auth/auth_controller.dart';
import 'package:studify/features/auth/domain/user_profile.dart';
import 'package:studify/l10n/app_localizations.dart';

/// Signed-in landing screen. The student and teacher homes come next;
/// for now it shows who is signed in and lets them log out.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
    final user = context.watch<AuthController>().user;
    if (user == null) return const Scaffold();

    final roleLabel = switch (user.role) {
      UserRole.teacher => l10n.roleTeacher,
      UserRole.student => l10n.roleStudent,
      UserRole.admin => l10n.roleAdmin,
      UserRole.unknown => '',
    };

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: BrandBackdrop()),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 12, 0),
                  child: Row(
                    children: [
                      const Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: StudyfyLogo(markSize: 28),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const LanguageButton(),
                      IconButton(
                        tooltip: l10n.logout,
                        onPressed: () => _confirmSignOut(context),
                        icon: const Icon(Icons.logout_rounded),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      Text(
                        l10n.homeWelcome(user.name),
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (roleLabel.isNotEmpty)
                            Chip(
                              avatar: Icon(
                                user.role == UserRole.teacher
                                    ? Icons.co_present_rounded
                                    : Icons.backpack_rounded,
                                size: 18,
                              ),
                              label: Text(roleLabel),
                            ),
                          if (user.partnerName.isNotEmpty)
                            Chip(
                              avatar: const Icon(
                                Icons.school_outlined,
                                size: 18,
                              ),
                              label: Text(user.partnerName),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        user.email,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
