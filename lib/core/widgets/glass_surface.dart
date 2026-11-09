import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:studify/core/theme/app_theme.dart';

/// The single corner language for every glass panel: a continuous
/// (squircle) curve, not a plain rounded rectangle — this is what makes
/// iOS 26 surfaces read as "glass" rather than a card with rounded
/// corners.
ShapeBorder glassShape({
  double radius = AppTheme.cardRadius,
  BorderRadius? borderRadius,
  BorderSide side = BorderSide.none,
}) => ContinuousRectangleBorder(
  borderRadius: borderRadius ?? BorderRadius.circular(radius),
  side: side,
);

/// A translucent Liquid-Glass panel.
///
/// Two distinct uses, controlled by [blurred]:
///  - Floating chrome (nav bars, sheets, dialogs, floating headers) sits
///    independently over content that scrolls or moves underneath it —
///    [blurred] (the default `true`) gives it a real `BackdropFilter`
///    blur, which is the only case where a blur actually reads as glass.
///  - In-flow content (a card inside the same list it's drawn in) has
///    nothing distinct moving behind it to blur; passing `blurred:
///    false` skips the `BackdropFilter` (real jank on a long list if
///    every row carries one) and keeps only the tint, highlight border
///    and soft shadow that make the material still read as glass.
class GlassSurface extends StatelessWidget {
  const GlassSurface({
    required this.child,
    this.shape,
    this.radius = AppTheme.cardRadius,
    this.borderRadius,
    this.padding = const EdgeInsets.all(16),
    this.blurred = true,
    this.elevated,
    this.tintOpacity,
    this.onTap,
    super.key,
  });

  final Widget child;

  /// Overrides [radius]/[borderRadius] entirely when given (e.g. a
  /// sheet's top-only rounding).
  final ShapeBorder? shape;
  final double radius;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry padding;
  final bool blurred;

  /// Soft drop shadow under the panel. Defaults to [blurred]: floating
  /// chrome casts one, in-flow cards on a flat background don't need it.
  final bool? elevated;

  final double? tintOpacity;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final effectiveShape =
        shape ?? glassShape(radius: radius, borderRadius: borderRadius);

    final tint = scheme.surfaceContainerLowest.withValues(
      alpha:
          tintOpacity ?? (blurred ? (dark ? 0.46 : 0.62) : (dark ? 0.7 : 0.86)),
    );
    final highlight = (dark ? Colors.white : Colors.white).withValues(
      alpha: dark ? 0.06 : 0.75,
    );
    final borderColor = dark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.white.withValues(alpha: 0.85);

    final borderedShape = switch (effectiveShape) {
      ContinuousRectangleBorder(:final borderRadius) =>
        ContinuousRectangleBorder(
          borderRadius: borderRadius,
          side: BorderSide(color: borderColor),
        ),
      _ => effectiveShape,
    };

    Widget panel = ClipPath(
      clipper: ShapeBorderClipper(shape: effectiveShape),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          if (blurred)
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: AppTheme.glassBlurSigma,
                  sigmaY: AppTheme.glassBlurSigma,
                ),
                child: const SizedBox(),
              ),
            ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: ShapeDecoration(
                shape: borderedShape,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color.alphaBlend(
                      highlight.withValues(alpha: dark ? 0.03 : 0.5),
                      tint,
                    ),
                    tint,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: padding,
            // A Material ancestor for anything inside that needs one
            // (InkWell rows, text fields) — there's otherwise none
            // between here and the app's root Material.
            child: Material(type: MaterialType.transparency, child: child),
          ),
        ],
      ),
    );

    if (onTap != null) {
      panel = Material(
        type: MaterialType.transparency,
        child: InkWell(
          customBorder: effectiveShape,
          onTap: onTap,
          child: panel,
        ),
      );
    }

    if (elevated ?? blurred) {
      panel = DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: dark ? 0.32 : 0.1),
              blurRadius: 28,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: panel,
      );
    }

    return panel;
  }
}

/// A small circular glass button — the floating back/close/action
/// buttons iOS 26 draws over content instead of a flat toolbar icon.
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.size = 40,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double size;

  @override
  Widget build(BuildContext context) {
    final button = GlassSurface(
      radius: size / 2,
      padding: EdgeInsets.zero,
      onTap: onPressed,
      elevated: true,
      child: SizedBox(
        width: size,
        height: size,
        child: Icon(icon, size: size * 0.45),
      ),
    );
    if (tooltip case final tooltip?) {
      return Tooltip(message: tooltip, child: button);
    }
    return button;
  }
}

/// Shows [builder]'s content in a glass sheet: blurred, rounded only at
/// the top, with its own drag handle drawn on the glass instead of the
/// default flat one. Drop-in replacement for a direct
/// `showModalBottomSheet` call — same signature, same return value.
Future<T?> showGlassSheet<T>(
  BuildContext context, {
  required WidgetBuilder builder,
  bool isScrollControlled = false,
  bool useRootNavigator = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    useRootNavigator: useRootNavigator,
    useSafeArea: true,
    showDragHandle: false,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.38),
    builder: (sheetContext) => _GlassSheetPanel(child: builder(sheetContext)),
  );
}

class _GlassSheetPanel extends StatelessWidget {
  const _GlassSheetPanel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: GlassSurface(
        shape: glassShape(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 4),
              child: Container(
                width: 36,
                height: 5,
                decoration: BoxDecoration(
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}

/// A frosted, glass-shelled replacement for [AlertDialog], with the same
/// constructor shape — a drop-in rename at every call site.
class GlassAlertDialog extends StatelessWidget {
  const GlassAlertDialog({this.title, this.content, this.actions, super.key});

  final Widget? title;
  final Widget? content;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: GlassSurface(
        radius: 28,
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title case final title?)
                DefaultTextStyle(
                  style: theme.textTheme.headlineSmall!,
                  child: title,
                ),
              if (title != null && content != null) const SizedBox(height: 12),
              if (content case final content?)
                DefaultTextStyle(
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  child: content,
                ),
              if (actions case final actions?) ...[
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (var i = 0; i < actions.length; i++) ...[
                      if (i > 0) const SizedBox(width: 4),
                      actions[i],
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
