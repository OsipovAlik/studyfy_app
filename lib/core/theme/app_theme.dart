import 'package:flutter/material.dart';
import 'package:studify/core/theme/app_colors.dart';

/// Use this to change a text weight: Inter and the Armenian fallback are
/// both variable fonts, so a weight change only has to move the `wght`
/// axis — no separate font file to switch to.
extension FontWeightX on TextStyle {
  TextStyle weight(FontWeight weight) => copyWith(
    fontFamily: AppTheme.fontFamily,
    fontFamilyFallback: AppTheme.fontFallback,
    fontWeight: weight,
    fontVariations: [FontVariation.weight(weight.value.toDouble())],
  );
}

abstract final class AppTheme {
  /// Inter, bundled as a single variable font in `assets/fonts/`.
  static const fontFamily = 'Inter';

  /// Inter has no Armenian letters; they come from Noto Sans Armenian,
  /// also bundled as a variable font.
  static const fontFallback = ['NotoSansArmenian'];

  /// The pill shape Apple's flat language uses for every button.
  static const pillShape = StadiumBorder();

  /// The radius Apple's flat language uses for cards and sheets.
  static const cardRadius = 28.0;

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
      outline: AppColors.stone200,
      outlineVariant: AppColors.stone100,
      shadow: Colors.transparent,
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
      shadow: Colors.transparent,
    ),
  );

  static ThemeData _build(ColorScheme scheme) {
    final textTheme = _textTheme(scheme.onSurface);
    const buttonPadding = EdgeInsets.symmetric(horizontal: 24, vertical: 14);
    final buttonText = textTheme.labelLarge;
    final hairline = BorderSide(color: scheme.outline);
    final inputRadius = BorderRadius.circular(12);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: scheme.brightness,
      scaffoldBackgroundColor: scheme.surface,
      fontFamily: fontFamily,
      fontFamilyFallback: fontFallback,
      textTheme: textTheme,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      dividerTheme: DividerThemeData(
        color: scheme.outline,
        thickness: 1,
        space: 1,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineSmall,
        iconTheme: IconThemeData(color: scheme.onSurface),
      ),
      cardTheme: CardThemeData(
        color: scheme.surfaceContainerLowest,
        elevation: 0,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: hairline,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: pillShape,
          padding: buttonPadding,
          textStyle: buttonText,
          minimumSize: const Size(64, 50),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: pillShape,
          padding: buttonPadding,
          textStyle: buttonText,
          minimumSize: const Size(64, 50),
          backgroundColor: scheme.surfaceContainer,
          foregroundColor: scheme.onSurface,
          side: BorderSide.none,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: pillShape,
          textStyle: textTheme.bodyLarge,
          foregroundColor: AppColors.deepLinkBlue,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: scheme.onSurface),
      ),
      chipTheme: ChipThemeData(
        shape: pillShape,
        side: hairline,
        backgroundColor: scheme.surfaceContainer,
        selectedColor: scheme.primary,
        labelStyle: textTheme.labelMedium,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainer,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: BorderSide(color: scheme.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: inputRadius,
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: scheme.surfaceContainerLowest,
        modalBackgroundColor: scheme.surfaceContainerLowest,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        modalElevation: 0,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(cardRadius),
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: scheme.onSurface,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: scheme.surface,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.white
              : scheme.surface,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.surfaceContainerHigh,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.primary
              : Colors.transparent,
        ),
        side: hairline,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? scheme.primary
              : scheme.outline,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: scheme.primary,
        linearTrackColor: scheme.surfaceContainerHigh,
        circularTrackColor: scheme.surfaceContainerHigh,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        indicatorColor: scheme.primary.withValues(alpha: 0.12),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: scheme.onSurfaceVariant,
        textColor: scheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
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
      fontSize: size,
      height: height,
      letterSpacing: letterSpacing,
      color: color,
    ).weight(weight);

    return TextTheme(
      displaySmall: style(34, FontWeight.w600, height: 1.1, letterSpacing: -0.8),
      headlineLarge: style(
        28,
        FontWeight.w600,
        height: 1.15,
        letterSpacing: -0.4,
      ),
      headlineMedium: style(
        24,
        FontWeight.w600,
        height: 1.18,
        letterSpacing: -0.3,
      ),
      headlineSmall: style(
        21,
        FontWeight.w600,
        height: 1.25,
        letterSpacing: -0.2,
      ),
      titleLarge: style(17, FontWeight.w600, letterSpacing: -0.2),
      titleMedium: style(15, FontWeight.w600),
      titleSmall: style(13, FontWeight.w600),
      bodyLarge: style(17, FontWeight.w400, height: 1.47, letterSpacing: -0.27),
      bodyMedium: style(
        14,
        FontWeight.w400,
        height: 1.43,
        letterSpacing: -0.14,
      ),
      bodySmall: style(12, FontWeight.w400, height: 1.33, letterSpacing: -0.04),
      labelLarge: style(16, FontWeight.w600, height: 1.2, letterSpacing: -0.2),
      labelMedium: style(13, FontWeight.w600, height: 1.2),
      labelSmall: style(11, FontWeight.w500, height: 1.15, letterSpacing: 0.2),
    );
  }
}
