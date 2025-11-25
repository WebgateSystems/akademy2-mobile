import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionTextButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const ActionTextButtonWidget({
    super.key,
    required this.text,
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
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: TextButton(
          onPressed: onPressed,
          child: Text(
            text.toUpperCase(),
            style: AppTextStyles.button(context).copyWith(
              color: AppColors.contentOnSecondaryButton(context),
              decoration: TextDecoration.underline,
              decorationColor: AppColors.contentOnSecondaryButton(context),
            ),
          ),
        ),
      ),
    );
  }
}
