import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF0A5D4B);
  static const mint = Color(0xFFE2F3EE);
  static const gold = Color(0xFFC5A84C);
  static const background = Color(0xFFF8F3EB);
  static const card = Color(0xFFFFFFFF);
  static const text = Color(0xFF1C2433);
  static const whiteText = Color(0xFFFFFFFF);
  static const muted = Color(0xFF8A9BA8);
  static const border = Color(0xFFE5DDD2);
  static const violet = Color(0xFF7C6FD4);
  static const violetBg = Color(0xFFEDE8FF);
  static const warmBg = Color(0xFFFEF3E2);
}

class AppDimens {
  static const padding = 16.0;
  static const radius = 20.0;
}

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.gold,
      surface: AppColors.card,
      onSurface: AppColors.text,
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontWeight: FontWeight.w800),
      titleLarge: TextStyle(fontWeight: FontWeight.w700),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.card,
      foregroundColor: AppColors.text,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
    ),
    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimens.radius),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
    ),
  );
}
