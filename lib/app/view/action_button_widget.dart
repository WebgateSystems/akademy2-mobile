import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionButtonWidget extends StatelessWidget {
  final String text;
  final bool loading;
  final double? height;
  final VoidCallback? onPressed;

  const ActionButtonWidget({
    super.key,
    required this.text,
    this.loading = false,
    this.height,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 56.h,
      width: double.infinity,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: onPressed != null || loading
              ? AppColors.button(context)
              : AppColors.buttonDisabled(context),
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
                              ? AppColors.button(context)
                              : AppColors.buttonDisabled(context)
                                  .withValues(alpha: 0.6))),
                )
              : Text(
                  text.toUpperCase(),
                  style: AppTextStyles.button(context).copyWith(
                    color: onPressed != null
                        ? AppColors.contentButtonPrimary(context)
                        : AppColors.contentOnPrimaryDisabled(context),
                  ),
                ),
        ),
      ),
    );
  }
}
