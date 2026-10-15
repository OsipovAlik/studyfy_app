import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studify/core/l10n/locale_controller.dart';
import 'package:studify/l10n/app_localizations.dart';

/// Compact language switcher: shows the current language code and opens
/// a sheet with the four app languages.
class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key});

  static const _shortLabels = {
    'hy': 'ՀՅ',
    'en': 'EN',
    'fr': 'FR',
    'ru': 'RU',
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final code = Localizations.localeOf(context).languageCode;

    return Semantics(
      button: true,
      label: AppLocalizations.of(context).languageLabel,
      child: Material(
        color: theme.colorScheme.surfaceContainerLowest,
        shape: StadiumBorder(
          side: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: () => _showPicker(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.globe,
                  size: 18,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Text(
                  _shortLabels[code] ?? code.toUpperCase(),
                  style: theme.textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showPicker(BuildContext context) {
    final current = Localizations.localeOf(context).languageCode;
    final controller = context.read<LocaleController>();

    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      builder: (sheetContext) {
        final theme = Theme.of(sheetContext);
        return Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                child: Text(
                  AppLocalizations.of(sheetContext).languageLabel,
                  style: theme.textTheme.titleLarge,
                ),
              ),
              for (final language in LocaleController.languages)
                ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  selected: language.code == current,
                  selectedTileColor: theme.colorScheme.primaryContainer
                      .withValues(alpha: 0.5),
                  title: Text(
                    language.nativeName,
                    style: theme.textTheme.titleMedium,
                  ),
                  trailing: language.code == current
                      ? Icon(
                          CupertinoIcons.checkmark_circle_fill,
                          color: theme.colorScheme.primary,
                        )
                      : null,
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    unawaited(controller.setLanguage(language.code));
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}
