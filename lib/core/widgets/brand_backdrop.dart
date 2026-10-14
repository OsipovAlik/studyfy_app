import 'package:flutter/material.dart';
import 'package:studify/core/theme/app_colors.dart';

/// Soft brand-coloured glows behind full-screen pages (onboarding, login).
class BrandBackdrop extends StatelessWidget {
  const BrandBackdrop({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Widget glow(Color color, double size) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: isDark ? 0.22 : 0.16),
            color.withValues(alpha: 0),
          ],
        ),
      ),
    );

    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -140,
            right: -120,
            child: glow(AppColors.indigo500, 420),
          ),
          Positioned(
            bottom: -160,
            left: -140,
            child: glow(const Color(0xFFC026D3), 380),
          ),
        ],
      ),
    );
  }
}
