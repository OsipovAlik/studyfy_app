import 'package:flutter/material.dart';

/// Brand palette, built on a violet scale anchored on the app colour,
/// #6656E9, with Twilight Indigo → Cool Steel still used for neutrals.
abstract final class AppColors {
  // Indigo — primary brand colour, anchored on the app violet, #6656E9.
  static const indigo50 = Color(0xFFF6F5FE);
  static const indigo100 = Color(0xFFEBE9FC);
  static const indigo200 = Color(0xFFD9D5FA);
  static const indigo300 = Color(0xFFC2BBF6);
  static const indigo400 = Color(0xFFA69DF2);
  static const indigo500 = Color(0xFF887BEE);
  static const indigo600 = Color(0xFF6656E9); // App Violet
  static const indigo700 = Color(0xFF5548C4);
  static const indigo800 = Color(0xFF43389A);
  static const indigo900 = Color(0xFF312971);
  static const indigo950 = Color(0xFF241E54);

  /// The darkest violet stop, below indigo950 — used for near-black
  /// surfaces (e.g. the call screen's backdrop) rather than true black.
  static const deepAbyss = Color(0xFF141339);

  /// Inline links, underlined — a darker stop of the app violet.
  static const deepLinkPurple = Color(0xFF5548C4); // indigo700

  // Stone — neutrals. The mid stops are tinted with the navy scale's
  // greys (Cool Steel → Twilight Indigo); the light/dark anchors stay
  // true grey.
  static const stone50 = Color(0xFFF5F5F7); // Pure Canvas
  static const stone100 = Color(0xFFE2E2E5); // Mist
  static const stone200 = Color(0xFFD6D6D6); // Fog
  static const stone300 = Color(0xFFBDBDBD);
  static const stone400 = Color(0xFF979DAC); // Cool Steel
  static const stone500 = Color(0xFF7D8597); // Slate Grey
  static const stone600 = Color(0xFF5C677D); // Blue Slate
  static const stone700 = Color(0xFF33415C); // Twilight Indigo
  static const stone800 = Color(0xFF26262A);
  static const stone900 = Color(0xFF1D1D1F); // Obsidian
  static const stone950 = Color(0xFF000000); // Void

  static const Color pureCanvas = stone50;
  static const Color paperWhite = Colors.white;
  static const Color mist = stone100;
  static const Color fog = stone200;
  static const Color ironGray = stone500;
  static const Color slate = stone600;
  static const Color charcoal = stone700;
  static const Color obsidian = stone900;
  static const Color voidBlack = stone950;

  // Blue — used for the Students stat tile; Apple's Lagoon Teal.
  static const blue500 = Color(0xFF00A1B3);

  // Emerald — success, correct answers; Apple's Pulse/Deep Green.
  static const emerald50 = Color(0xFFE7F8EC);
  static const emerald400 = Color(0xFF1FBD5C);
  static const emerald500 = Color(0xFF03AA49); // Pulse Green
  static const emerald600 = Color(0xFF03873A); // Deep Green

  // Amber — highlights, warnings; Apple's Ember Orange.
  static const amber400 = Color(0xFFFF8A3D);
  static const amber500 = Color(0xFFED6300); // Ember Orange

  // Red — errors; Apple's iOS system red.
  static const red400 = Color(0xFFFF6961);
  static const red500 = Color(0xFFFF3B30);

  /// Tag/divider accent, used sparingly for tinted words — Apple's
  /// Ultraviolet. Never a background or large fill.
  static const ultraviolet = Color(0xFF8668FF);

  /// The app mark's fill. Apple's style is flat: a single brand colour,
  /// never a gradient.
  static const Color brandGradient = indigo600;
}
