import 'package:flutter/material.dart';

/// Brand palette, taken from the Studyfy website (Tailwind tokens).
abstract final class AppColors {
  // Indigo — primary brand colour.
  static const indigo50 = Color(0xFFF0EFFE);
  static const indigo100 = Color(0xFFE3E1FD);
  static const indigo200 = Color(0xFFCBC8FB);
  static const indigo300 = Color(0xFFAAA5F8);
  static const indigo400 = Color(0xFF8A82F4);
  static const indigo500 = Color(0xFF766CF1);
  static const indigo600 = Color(0xFF6459EE);
  static const indigo700 = Color(0xFF5246D6);
  static const indigo800 = Color(0xFF4339AD);
  static const indigo900 = Color(0xFF393289);
  static const indigo950 = Color(0xFF221D52);

  // Stone — warm neutrals.
  static const stone50 = Color(0xFFFAFAF9);
  static const stone100 = Color(0xFFF5F5F4);
  static const stone200 = Color(0xFFE7E5E4);
  static const stone300 = Color(0xFFD6D3D1);
  static const stone400 = Color(0xFFA6A09B);
  static const stone500 = Color(0xFF79716B);
  static const stone600 = Color(0xFF57534D);
  static const stone700 = Color(0xFF44403B);
  static const stone800 = Color(0xFF292524);
  static const stone900 = Color(0xFF1C1917);
  static const stone950 = Color(0xFF0C0A09);

  // Emerald — success, correct answers.
  static const emerald50 = Color(0xFFECFDF5);
  static const emerald400 = Color(0xFF00D294);
  static const emerald500 = Color(0xFF00BB7F);
  static const emerald600 = Color(0xFF009767);

  // Amber — highlights.
  static const amber400 = Color(0xFFFCBB00);
  static const amber500 = Color(0xFFF99C00);

  static const red500 = Color(0xFFFB2C36);
  static const red400 = Color(0xFFFF6568);

  /// The gradient of the app mark (indigo → violet → fuchsia).
  static const brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4F46E5), Color(0xFF7C3AED), Color(0xFFC026D3)],
  );
}
