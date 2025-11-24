import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppColors {
  static const primary = Color(0xFF3F51B5);
  static const accent = Color(0xFFFFC107);
  static const contentPlaceholder = Color(0xFF929292);

  static const backgroundLight = Color(0xFFF2F7FD);
  static const backgroundLightAccent = Color(0xFF040E1A);
  static const contentPrimaryLight = Color(0xFF040E1A);
  static const borderPrimary = Color(0xFFD0E2F8);
  static const borderFocused = Color(0xFF4A90E2);
  static const borderError = Color(0xFFD32F2F);
  static const contentError = Color(0xFFD32F2F);
  static const surfacePrimary = Color(0xFFFFFFFF);
  static const buttonPrimary = Color(0xFF4A90E2);
  static const buttonPrimaryDisabled = Color(0xFF929292);
  static const contentOnButtonPrimary = Color(0xFFFFFFFF);
  static const contentOnButtonPrimaryDisabled = Color(0xFFE0E0E0);

  static const backgroundDark = Color(0xFF040E1A);
  static const contentPrimaryDark = Color(0xFFF2F7FD);
}

class AppSpacing {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
}

class AppTextStyles {
  static TextStyle H1 = TextStyle(
    fontSize: 24.sp,
    fontFamily: 'Rubik',
    fontWeight: FontWeight.w500,
    color: AppColors.contentPrimaryLight,
    height: 1.5,
    letterSpacing: -0.24,
  );

  static TextStyle B2 = TextStyle(
    fontSize: 14.sp,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    color: AppColors.contentPrimaryLight,
    height: 1.3,
  );

  static TextStyle B3 = TextStyle(
    fontSize: 12.sp,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
    color: AppColors.contentPrimaryLight,
    height: 1.3,
  );

  static TextStyle BUTTON = TextStyle(
    fontSize: 14.sp,
    fontFamily: 'Rubik',
    fontWeight: FontWeight.w400,
    color: AppColors.contentPrimaryLight,
    height: 1.3,
    letterSpacing: 1.2,
  );
}
