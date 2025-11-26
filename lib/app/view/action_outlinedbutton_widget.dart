import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionOutlinedButtonWidget extends StatelessWidget {
  final String text;
  final bool loading;
  final Color? color;
  final VoidCallback? onPressed;

  const ActionOutlinedButtonWidget({
    super.key,
    required this.text,
    this.loading = false,
    this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56.h,
      width: double.infinity,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: color ?? AppColors.contentOnSecondaryButton(context),
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
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
            : TextButton(
                onPressed: onPressed,
                child: Text(
                  text.toUpperCase(),
                  style: AppTextStyles.button(context).copyWith(
                    color: color ?? AppColors.contentOnSecondaryButton(context),
                  ),
                ),
              ),
      ),
    );
  }
}
