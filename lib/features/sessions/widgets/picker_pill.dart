import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:studify/core/widgets/glass_surface.dart';

/// A tappable pill showing the current choice; tapping it opens a sheet
/// to pick another from [options]. Used for the Sessions list's type/day
/// filters and the add/edit session form's pickers.
class PickerPill<T> extends StatelessWidget {
  const PickerPill({
    required this.value,
    required this.label,
    required this.options,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });

  final T value;
  final String label;
  final List<({T value, String label})> options;
  final ValueChanged<T> onChanged;
  final bool enabled;

  Future<void> _open(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return showGlassSheet<void>(
      context,
      useRootNavigator: true,
      // A long option list (e.g. every weekday, or every student) can be
      // taller than the sheet's default cap; let it take more room, and
      // scroll past that instead of overflowing.
      isScrollControlled: true,
      builder: (sheetContext) => ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.6,
        ),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 20),
          children: [
            for (final option in options)
              ListTile(
                title: Text(option.label),
                trailing: option.value == value
                    ? Icon(CupertinoIcons.checkmark_alt, color: scheme.primary)
                    : null,
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  onChanged(option.value);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GlassSurface(
      blurred: false,
      tintOpacity: enabled ? null : 0.4,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      onTap: enabled ? () => _open(context) : null,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: enabled ? null : scheme.onSurfaceVariant,
              ),
            ),
          ),
          Icon(
            CupertinoIcons.chevron_down,
            size: 14,
            color: scheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
