import 'package:flutter/material.dart';

class AppTheme {
  // Soft Lavender & Modern Palette
  static const Color background = Color(0xFFF6F2FB);
  static const Color surface = Color(0xFFFFFEFF);
  static const Color surfaceSubtle = Color(0xFFF0E8FA);
  static const Color darkText = Color(0xFF1B1726);
  static const Color mutedText = Color(0xFF6E667A);
  static const Color subtleText = Color(0xFF9C94AA);

  // Pastel Accents
  static const Color primaryPurple = Color(0xFF8B63DA);
  static const Color lavenderTint = Color(0xFFEDE4FB);

  static const Color mintGreen = Color(0xFF2EA775);
  static const Color mintTint = Color(0xFFE2F6EE);

  static const Color coralRed = Color(0xFFE55656);
  static const Color coralTint = Color(0xFFFEECEB);

  static const Color amberOrange = Color(0xFFE5872B);
  static const Color amberTint = Color(0xFFFFF0E2);

  static const Color borderLight = Color(0xFFECE4F7);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryPurple,
        primary: primaryPurple,
        surface: surface,
        brightness: Brightness.light,
      ),
      fontFamily: 'Inter',
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: borderLight, width: 1),
        ),
      ),
    );
  }
}
