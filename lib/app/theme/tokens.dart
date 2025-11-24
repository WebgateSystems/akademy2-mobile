import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppColors {
  static const primary = Color(0xFF3F51B5);
  static const accent = Color(0xFFFFC107);
  static const contentPlaceholder = Color(0xFF929292);

  static const blue05 = Color(0xFFF2F7FD);
  static const blue10 = Color(0xFFD0E2F8);
  static const blue20 = Color(0xFFAFCEF2);
  static const blue30 = Color(0xFF8DB9ED);
  static const blue40 = Color(0xFF6CA5E7);
  static const blue50 = Color(0xFF4A90E2);
  static const blue60 = Color(0xFF206EC9);
  static const blue70 = Color(0xFF174E8E);
  static const blue80 = Color(0xFF0E2E54);
  static const blue85 = Color(0xFF081A2D);
  static const blue90 = Color(0xFF040E1A);

  static const grey05 = Color(0xFFFFFFFF);
  static const grey10 = Color(0xFFF0F0F0);
  static const grey20 = Color(0xFFE0E0E0);
  static const grey30 = Color(0xFFD4D4D4);
  static const grey40 = Color(0xFFC9C9C9);
  static const grey50 = Color(0xFFBDBDBD);
  static const grey60 = Color(0xFF929292);
  static const grey70 = Color(0xFF666666);
  static const grey80 = Color(0xFF3B3B3B);
  static const grey90 = Color(0xFF0F0F0F);

  static const red05 = Color(0xFFFFEBEE);
  static const red10 = Color(0xFFFFCDD2);
  static const red20 = Color(0xFFEF9A9A);
  static const red30 = Color(0xFFE57373);
  static const red40 = Color(0xFFEF5350);
  static const red50 = Color(0xFFF44336);
  static const red60 = Color(0xFFE53935);
  static const red70 = Color(0xFFD32F2F);
  static const red80 = Color(0xFFB71C1C);
  static const red90 = Color(0xFF7F0000);

  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? blue90 : blue05;

  static Color contentPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? blue05 : blue90;

  static Color contentButtonPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? grey90 : grey05;

  static Color contentOnPrimaryDisabled(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? grey20 : grey20;

  static Color contentError(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? red60 : red70;

  static Color surface(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? blue85 : grey05;

  static Color borderFocused(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? blue50 : blue50;

  static Color borderPrimary(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? blue10 : blue10;

  static Color borderError(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? red60 : red70;

  static Color button(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? blue50 : blue50;

  static Color buttonDisabled(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? grey60 : grey60;
}

class AppSpacing {
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
}

class AppTextStyles {
  static TextStyle h1(BuildContext context) => TextStyle(
        fontSize: 24.sp,
        fontFamily: 'Rubik',
        fontWeight: FontWeight.w500,
        color: AppColors.contentPrimary(context),
        height: 1.5,
        letterSpacing: -0.24,
      );

  static TextStyle b2(BuildContext context) => TextStyle(
        fontSize: 14.sp,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        color: AppColors.contentPrimary(context),
        height: 1.3,
      );

  static TextStyle b3(BuildContext context) => TextStyle(
        fontSize: 12.sp,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        color: AppColors.contentPrimary(context),
        height: 1.3,
      );

  static TextStyle button(BuildContext context) => TextStyle(
        fontSize: 14.sp,
        fontFamily: 'Rubik',
        fontWeight: FontWeight.w400,
        color: AppColors.contentPrimary(context),
        height: 1.3,
        letterSpacing: 1.2,
      );
}
