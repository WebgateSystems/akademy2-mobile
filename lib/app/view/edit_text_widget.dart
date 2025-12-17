import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditTextWidget extends StatelessWidget {
  final String? label;
  final String? hint;
  final TextEditingController controller;
  final TextInputType keyboard;
  final String? errorText;
  final String? infoText;
  final bool readOnly;
  final bool obscureText;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final int? maxLength;
  final int? maxLines;
  final FocusNode? focusNode;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? contentPadding;

  const EditTextWidget({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.infoText,
    this.suffixIcon,
    required this.controller,
    this.keyboard = TextInputType.text,
    this.onChanged,
    this.readOnly = false,
    this.obscureText = false,
    this.onTap,
    this.maxLength,
    this.maxLines,
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
            onTap: onTap,
            maxLength: maxLength,
            maxLines: maxLines ?? 1,
            obscureText: obscureText,
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfacePrimary(context),
              hintText: hint,
              hintStyle: AppTextStyles.b2(context).copyWith(
                color: AppColors.contentPlaceholder(context),
              ),
              errorText: infoText ?? errorText,
              errorStyle: AppTextStyles.b3(context).copyWith(
                color: infoText == null
                    ? AppColors.contentError(context)
                    : AppColors.contentWarning(context),
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
                  color: infoText == null
                      ? AppColors.borderError(context)
                      : AppColors.contentWarning(context),
                  width: 1.w,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide: BorderSide(
                  color: infoText == null
                      ? AppColors.borderError(context)
                      : AppColors.contentWarning(context),
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
