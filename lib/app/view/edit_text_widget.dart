import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditTextWidget extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController controller;
  final TextInputType keyboard;
  final String? errorText;
  final Widget? suffixIcon;
  final Function(String)? onChanged;

  const EditTextWidget({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.suffixIcon,
    required this.controller,
    this.keyboard = TextInputType.text,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label ?? '',
              style: AppTextStyles.B2.copyWith(
                color: theme.textTheme.bodyMedium?.color,
              )),
          SizedBox(height: 4.h),
          TextField(
            controller: controller,
            keyboardType: keyboard,
            onChanged: onChanged,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfacePrimary,
              hintText: hint,
              hintStyle: AppTextStyles.B2.copyWith(
                color: AppColors.contentPlaceholder,
              ),
              errorText: errorText,
              errorStyle: AppTextStyles.B3.copyWith(
                color: AppColors.contentError,
              ),
              suffixIcon: suffixIcon,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide: BorderSide(
                  color: AppColors.borderPrimary,
                  width: 1.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide: BorderSide(
                  color: AppColors.borderFocused,
                  width: 1.w,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide: BorderSide(
                  color: AppColors.borderError,
                  width: 1.w,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide: BorderSide(
                  color: AppColors.borderError,
                  width: 1.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
