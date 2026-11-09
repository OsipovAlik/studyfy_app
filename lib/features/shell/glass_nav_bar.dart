import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';

/// One tab of [GlassNavBar].
class GlassNavDestination {
  const GlassNavDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

/// A floating, real Liquid Glass bottom bar (`liquid_glass_widgets`'s
/// [GlassTabBar], styled `ios27`) — the Android/desktop counterpart of
/// the native iOS tab bar, now built on the same refraction/blur glass
/// rendering instead of a flat `BackdropFilter` approximation.
class GlassNavBar extends StatelessWidget {
  const GlassNavBar({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  /// Height of the bar itself, without the space around it.
  static const barHeight = 64.0;

  /// Gap between the bar and the bottom of the safe area.
  static const bottomGap = 0.0;

  final List<GlassNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      top: false,
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: GlassTabBar.bottom(
            selectedIndex: selectedIndex,
            onTabSelected: (index) {
              if (index != selectedIndex) {
                unawaited(HapticFeedback.selectionClick());
              }
              onSelected(index);
            },
            settings: isDark ? LiquidGlassSettings.ios27Dark : LiquidGlassSettings.ios27Light,
            selectedIconColor: scheme.primary,
            selectedLabelColor: scheme.primary,
            unselectedIconColor: scheme.onSurfaceVariant,
            unselectedLabelColor: scheme.onSurfaceVariant,
            tabs: [
              for (final destination in destinations)
                GlassTab(
                  icon: Icon(destination.icon, size: 22),
                  activeIcon: Icon(destination.selectedIcon, size: 22),
                  label: destination.label,
                  semanticLabel: destination.label,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
