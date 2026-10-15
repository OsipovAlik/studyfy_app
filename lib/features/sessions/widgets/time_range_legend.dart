import 'package:flutter/material.dart';
import 'package:studify/features/sessions/session_display.dart';
import 'package:studify/l10n/app_localizations.dart';

/// The three coloured dots explaining morning/afternoon/evening, as on
/// the website.
class TimeRangeLegend extends StatelessWidget {
  const TimeRangeLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Wrap(
      spacing: 14,
      runSpacing: 6,
      children: [
        for (final range in SessionTimeRange.values)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: range.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                range.label(l10n),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 10,
                ),
              ),
            ],
          ),
      ],
    );
  }
}
