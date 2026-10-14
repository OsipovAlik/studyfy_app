import 'package:flutter/material.dart';
import 'package:studify/core/theme/app_colors.dart';

/// The bundled fonts are variable fonts, so a weight has to be applied
/// as a `wght` variation as well as a [FontWeight].
extension FontWeightX on TextStyle {
  TextStyle weight(FontWeight weight) => copyWith(
    fontWeight: weight,
    fontVariations: [FontVariation.weight(weight.value.toDouble())],
  );
}

abstract final class AppTheme {
  static const fontFamily = 'Geist';
  static const fontFallback = ['NotoSansArmenian'];

  static ThemeData get light => _build(
    const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.indigo600,
      onPrimary: Colors.white,
      primaryContainer: AppColors.indigo100,
      onPrimaryContainer: AppColors.indigo900,
      secondary: AppColors.emerald600,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.emerald50,
      onSecondaryContainer: AppColors.emerald600,
      tertiary: AppColors.amber500,
      onTertiary: AppColors.stone900,
      error: AppColors.red500,
      onError: Colors.white,
      surface: AppColors.stone50,
      onSurface: AppColors.stone900,
      onSurfaceVariant: AppColors.stone600,
      surfaceContainerLowest: Colors.white,
      surfaceContainerLow: Colors.white,
      surfaceContainer: AppColors.stone100,
      surfaceContainerHigh: AppColors.stone200,
      outline: AppColors.stone300,
      outlineVariant: AppColors.stone200,
      shadow: AppColors.indigo900,
    ),
  );

  static ThemeData get dark => _build(
    const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.indigo400,
      onPrimary: AppColors.indigo950,
      primaryContainer: AppColors.indigo900,
      onPrimaryContainer: AppColors.indigo100,
      secondary: AppColors.emerald400,
      onSecondary: AppColors.stone950,
      secondaryContainer: Color(0xFF00382A),
      onSecondaryContainer: AppColors.emerald400,
      tertiary: AppColors.amber400,
      onTertiary: AppColors.stone950,
      error: AppColors.red400,
      onError: AppColors.stone950,
      surface: AppColors.stone950,
      onSurface: AppColors.stone100,
      onSurfaceVariant: AppColors.stone400,
      surfaceContainerLowest: AppColors.stone900,
      surfaceContainerLow: AppColors.stone900,
      surfaceContainer: AppColors.stone800,
      surfaceContainerHigh: AppColors.stone700,
      outline: AppColors.stone700,
      outlineVariant: AppColors.stone800,
      shadow: Colors.black,
    ),
  );

  static ThemeData _build(ColorScheme scheme) {
    final textTheme = _textTheme(scheme.onSurface);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
    );
    const buttonPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 16);
    final buttonText = textTheme.labelLarge?.copyWith(fontSize: 16);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: scheme.brightness,
      scaffoldBackgroundColor: scheme.surface,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      textTheme: textTheme,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: shape,
          padding: buttonPadding,
          textStyle: buttonText,
          minimumSize: const Size(64, 54),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: shape,
          padding: buttonPadding,
          textStyle: buttonText,
          minimumSize: const Size(64, 54),
          side: BorderSide(color: scheme.outline),
          foregroundColor: scheme.onSurface,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: textTheme.labelLarge,
          foregroundColor: scheme.onSurfaceVariant,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
      ),
    );
  }

  static TextTheme _textTheme(Color color) {
    TextStyle style(
      double size,
      FontWeight weight, {
      double height = 1.3,
      double letterSpacing = 0,
    }) => TextStyle(
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      fontSize: size,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    ).weight(weight);

    return TextTheme(
      displaySmall: style(36, FontWeight.w700, height: 1.1, letterSpacing: -1),
      headlineLarge: style(
        32,
        FontWeight.w700,
        height: 1.15,
        letterSpacing: -0.8,
      ),
      headlineMedium: style(
        28,
        FontWeight.w700,
        height: 1.15,
        letterSpacing: -0.6,
      ),
      headlineSmall: style(
        24,
        FontWeight.w700,
        height: 1.2,
        letterSpacing: -0.4,
      ),
      titleLarge: style(20, FontWeight.w600, letterSpacing: -0.2),
      titleMedium: style(16, FontWeight.w600),
      titleSmall: style(14, FontWeight.w600),
      bodyLarge: style(16, FontWeight.w400, height: 1.5),
      bodyMedium: style(14, FontWeight.w400, height: 1.45),
      bodySmall: style(12, FontWeight.w400, height: 1.4),
      labelLarge: style(14, FontWeight.w600),
      labelMedium: style(12, FontWeight.w600),
      labelSmall: style(11, FontWeight.w500, letterSpacing: 0.2),
    );
  }
}
