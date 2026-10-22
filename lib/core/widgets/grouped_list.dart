import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:studify/core/theme/app_theme.dart';

/// A rounded card of rows, with an optional small heading above it,
/// like the groups in iOS Settings.
class GroupedSection extends StatelessWidget {
  const GroupedSection({required this.children, this.title, super.key});

  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (title case final title?)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              title.toUpperCase(),
              style: theme.textTheme.labelMedium?.copyWith(
                color: scheme.onSurfaceVariant,
                letterSpacing: 0.6,
              ),
            ),
          ),
        Material(
          color: scheme.surfaceContainerLowest,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            side: BorderSide(color: scheme.outlineVariant),
          ),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0)
                  Divider(
                    height: 1,
                    indent: 64,
                    color: scheme.outlineVariant,
                  ),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// A row of a [GroupedSection]: a tinted icon, a label, and a chevron
/// (or a checkmark when [selected] is set).
class GroupedTile extends StatelessWidget {
  const GroupedTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
    this.selected,
    super.key,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// The icon's tint; the primary color by default.
  final Color? color;

  /// `null` for a row that opens a page; otherwise whether this option
  /// is the chosen one.
  final bool? selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final tint = color ?? scheme.primary;
    return Semantics(
      selected: selected,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: tint.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 19, color: tint),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(label, style: theme.textTheme.titleMedium),
              ),
              const SizedBox(width: 8),
              switch (selected) {
                null => Icon(
                  CupertinoIcons.chevron_forward,
                  size: 18,
                  color: scheme.onSurfaceVariant,
                ),
                true => Icon(
                  CupertinoIcons.checkmark_alt,
                  size: 22,
                  color: scheme.primary,
                ),
                false => const SizedBox(width: 22),
              },
            ],
          ),
        ),
      ),
    );
  }
}
