import 'package:flutter/material.dart';

/// Brand palette, retuned to Apple's flat design language (Signal Blue,
/// Pure Canvas neutrals, restrained chromatic accents for tints only).
abstract final class AppColors {
  // Indigo — primary brand colour, anchored on Apple's Signal Blue.
  static const indigo50 = Color(0xFFEAF4FE);
  static const indigo100 = Color(0xFFD6E9FD);
  static const indigo200 = Color(0xFFAED3FB);
  static const indigo300 = Color(0xFF7FB8F8);
  static const indigo400 = Color(0xFF4D9AF2);
  static const indigo500 = Color(0xFF1C82EC);
  static const indigo600 = Color(0xFF0071E3); // Signal Blue
  static const indigo700 = Color(0xFF005BB8);
  static const indigo800 = Color(0xFF00468C);
  static const indigo900 = Color(0xFF003866);
  static const indigo950 = Color(0xFF00213D);

  /// Inline links, underlined, à la Apple's Deep Link Blue.
  static const deepLinkBlue = Color(0xFF0066CC);

  // Stone — neutrals, mapped 1:1 onto Apple's Pure Canvas → Void scale.
  static const stone50 = Color(0xFFF5F5F7); // Pure Canvas
  static const stone100 = Color(0xFFE2E2E5); // Mist
  static const stone200 = Color(0xFFD6D6D6); // Fog
  static const stone300 = Color(0xFFBDBDBD);
  static const stone400 = Color(0xFF9E9E9E);
  static const stone500 = Color(0xFF707070); // Iron Gray
  static const stone600 = Color(0xFF474747); // Slate
  static const stone700 = Color(0xFF333336); // Charcoal
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
