import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionButtonWidget extends StatelessWidget {
  final String text;
  final bool loading;
  final VoidCallback? onPressed;

  const ActionButtonWidget({
    super.key,
    required this.text,
    required this.loading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 56.h,
      width: double.infinity,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: onPressed != null || loading
              ? AppColors.buttonPrimary
              : AppColors.buttonPrimaryDisabled,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: TextButton(
          onPressed: onPressed,
          child: loading
              ? SizedBox(
                  height: 16.w,
                  width: 16.w,
                  child: CircularProgressIndicator(
                      strokeWidth: 1.w,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          onPressed != null || loading
                              ? AppColors.contentOnButtonPrimary
                              : AppColors.contentOnButtonPrimaryDisabled)),
                )
              : Text(
                  text.toUpperCase(),
                  style: AppTextStyles.BUTTON.copyWith(
                    color: onPressed != null
                        ? AppColors.contentOnButtonPrimary
                        : AppColors.contentOnButtonPrimaryDisabled,
                  ),
                ),
        ),
      ),
    );
  }
}
