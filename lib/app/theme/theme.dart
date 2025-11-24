import 'package:flutter/material.dart';

import 'tokens.dart';

class AppTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary, surface: AppColors.blue05),
    scaffoldBackgroundColor: AppColors.blue05,
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.primary),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.blue90),
      bodyMedium: TextStyle(color: AppColors.blue90),
      bodySmall: TextStyle(color: AppColors.blue90),
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      surface: AppColors.blue90,
    ),
    scaffoldBackgroundColor: AppColors.blue90,
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.primary),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.blue05),
      bodyMedium: TextStyle(color: AppColors.blue05),
      bodySmall: TextStyle(color: AppColors.blue05),
    ),
  );
}
