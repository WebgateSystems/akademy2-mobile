import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditTextWidget extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController controller;
  final TextInputType keyboard;
  final String? errorText;
  final bool readOnly;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final int? maxLength;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? contentPadding;

  const EditTextWidget({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.suffixIcon,
    required this.controller,
    this.keyboard = TextInputType.text,
    this.onChanged,
    this.readOnly = false,
    this.maxLength = null,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(label ?? '',
                style: AppTextStyles.b2(context).copyWith(
                  color: theme.textTheme.bodyMedium?.color,
                )),
          if (label != null) SizedBox(height: 4.h),
          TextField(
            style: textStyle ?? AppTextStyles.b2(context),
            textAlign: textAlign,
            controller: controller,
            keyboardType: keyboard,
            focusNode: focusNode,
            readOnly: readOnly,
            onChanged: onChanged,
            maxLength: maxLength,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surface(context),
              hintText: hint,
              hintStyle: AppTextStyles.b2(context).copyWith(
                color: AppColors.contentPlaceholder,
              ),
              errorText: errorText,
              errorStyle: AppTextStyles.b3(context).copyWith(
                color: AppColors.contentError(context),
              ),
              suffixIcon: suffixIcon,
              counterText: '',
              counter: const SizedBox.shrink(),
              contentPadding: contentPadding,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide: BorderSide(
                  color: AppColors.borderPrimary(context),
                  width: 1.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide: BorderSide(
                  color: AppColors.borderFocused(context),
                  width: 1.w,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide: BorderSide(
                  color: AppColors.borderError(context),
                  width: 1.w,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide: BorderSide(
                  color: AppColors.borderError(context),
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
