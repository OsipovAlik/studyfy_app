import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/l10n/locale_controller.dart';
import 'package:studify/core/theme/theme_controller.dart';
import 'package:studify/core/widgets/glass_surface.dart';
import 'package:studify/core/widgets/grouped_list.dart';
import 'package:studify/features/auth/auth_controller.dart';
import 'package:studify/features/shell/sub_page.dart';
import 'package:studify/l10n/app_localizations.dart';

/// App settings: the language and the theme.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final auth = context.read<AuthController>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => GlassAlertDialog(
        title: Text(l10n.deleteAccountConfirmTitle),
        content: Text(l10n.deleteAccountConfirmDescription),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.deleteAccount),
          ),
        ],
      ),
    );
    if (confirmed ?? false) unawaited(auth.signOut());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = context.read<LocaleController>();
    final theme = context.watch<ThemeController>();
    final scheme = Theme.of(context).colorScheme;
    final language = Localizations.localeOf(context).languageCode;

    return SubPage(
      title: l10n.settingsTitle,
      children: [
        GroupedSection(
          title: l10n.languageLabel,
          children: [
            for (final option in LocaleController.languages)
              GroupedTile(
                icon: CupertinoIcons.globe,
                label: option.nativeName,
                selected: option.code == language,
                onTap: () => unawaited(locale.setLanguage(option.code)),
              ),
          ],
        ),
        const SizedBox(height: 28),
        GroupedSection(
          title: l10n.settingsAppearance,
          children: [
            for (final (mode, icon, label) in [
              (
                ThemeMode.system,
                CupertinoIcons.device_phone_portrait,
                l10n.themeSystem,
              ),
              (ThemeMode.light, CupertinoIcons.sun_max_fill, l10n.themeLight),
              (ThemeMode.dark, CupertinoIcons.moon_fill, l10n.themeDark),
            ])
              GroupedTile(
                icon: icon,
                label: label,
                selected: mode == theme.mode,
                onTap: () => unawaited(theme.setMode(mode)),
              ),
          ],
        ),
        const SizedBox(height: 28),
        GroupedSection(
          children: [
            GroupedTile(
              icon: CupertinoIcons.trash_fill,
              color: scheme.error,
              label: l10n.deleteAccount,
              onTap: () => _confirmDeleteAccount(context),
            ),
          ],
        ),
      ],
    );
  }
}
