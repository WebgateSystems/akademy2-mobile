import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppColors {
  static const primary = Color(0xFF3F51B5);
  static const accent = Color(0xFFFFC107);
  static const backgroundLight = Color(0xFFF2F7FD);
  static const contentPrimaryLight = Color(0xFF040E1A);

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

  static const TextStyle body = TextStyle(
    fontSize: 16.0,
    color: AppColors.contentPrimaryLight,
  );
}
