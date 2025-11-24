import 'package:flutter/material.dart';

import 'tokens.dart';

class AppTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary, surface: AppColors.backgroundLight),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.primary),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.contentPrimaryLight),
      bodyMedium: TextStyle(color: AppColors.contentPrimaryLight),
      bodySmall: TextStyle(color: AppColors.contentPrimaryLight),
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      surface: AppColors.backgroundDark,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.primary),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.contentPrimaryDark),
      bodyMedium: TextStyle(color: AppColors.contentPrimaryDark),
      bodySmall: TextStyle(color: AppColors.contentPrimaryDark),
    ),
  );
}
