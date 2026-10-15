import 'dart:async';
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

/// A floating, frosted-glass bottom bar: the Android counterpart of the
/// native iOS Liquid Glass tab bar.
class GlassNavBar extends StatelessWidget {
  const GlassNavBar({
    required this.destinations,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  /// Height of the bar itself, without the space around it.
  static const barHeight = 66.0;

  /// Gap between the bar and the bottom of the safe area.
  static const bottomGap = 12.0;

  final List<GlassNavDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = scheme.brightness == Brightness.dark;
    final radius = BorderRadius.circular(28);

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: bottomGap),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Center(
          heightFactor: 1,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: radius,
                boxShadow: [
                  BoxShadow(
                    color: scheme.shadow.withValues(
                      alpha: isDark ? 0.45 : 0.12,
                    ),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: radius,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerLowest.withValues(
                        alpha: isDark ? 0.62 : 0.74,
                      ),
                      borderRadius: radius,
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    child: SizedBox(
                      height: barHeight,
                      child: Row(
                        children: [
                          for (var i = 0; i < destinations.length; i++)
                            Expanded(
                              child: _GlassNavItem(
                                destination: destinations[i],
                                selected: i == selectedIndex,
                                onTap: () {
                                  if (i != selectedIndex) {
                                    unawaited(HapticFeedback.selectionClick());
                                  }
                                  onSelected(i);
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassNavItem extends StatelessWidget {
  const _GlassNavItem({
    required this.destination,
    required this.selected,
    required this.onTap,
  });

  final GlassNavDestination destination;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final color = selected ? scheme.primary : scheme.onSurfaceVariant;
    const duration = Duration(milliseconds: 260);

    return Semantics(
      container: true,
      button: true,
      selected: selected,
      child: InkResponse(
        onTap: onTap,
        containedInkWell: true,
        highlightShape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: duration,
              curve: Curves.easeOutCubic,
              width: selected ? 58 : 40,
              height: 30,
              decoration: BoxDecoration(
                color: selected
                    ? scheme.primary.withValues(alpha: 0.14)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: AnimatedSwitcher(
                duration: duration,
                child: Icon(
                  selected ? destination.selectedIcon : destination.icon,
                  key: ValueKey(selected),
                  size: 22,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final style = _labelStyle(
                    destination.label,
                    theme.textTheme.labelSmall!.copyWith(
                      color: color,
                      height: 1.15,
                    ),
                    constraints.maxWidth,
                    MediaQuery.textScalerOf(context),
                  );
                  return AnimatedDefaultTextStyle(
                    duration: duration,
                    style: style,
                    child: Text(
                      destination.label,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Long labels ("Պարապմունքներ", "Տնային առաջադրանքներ") must not be
/// broken inside a word. Picks the largest size from 11 down to 8.5 at
/// which the longest word fits on one line; the label may then wrap
/// between words onto a second line.
TextStyle _labelStyle(
  String label,
  TextStyle base,
  double maxWidth,
  TextScaler textScaler,
) {
  final words = label.split(RegExp(r'\s+'));
  double widest(double fontSize) {
    var result = 0.0;
    for (final word in words) {
      final painter = TextPainter(
        text: TextSpan(
          text: word,
          style: base.copyWith(fontSize: fontSize),
        ),
        textDirection: TextDirection.ltr,
        textScaler: textScaler,
        maxLines: 1,
      )..layout();
      if (painter.width > result) result = painter.width;
      painter.dispose();
    }
    return result;
  }

  var fontSize = 11.0;
  while (fontSize > 8.5 && widest(fontSize) > maxWidth) {
    fontSize -= 0.5;
  }
  return base.copyWith(fontSize: fontSize);
}
