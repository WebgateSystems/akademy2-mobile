import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckboxWidget extends StatelessWidget {
  final String text;
  final bool value;
  final ValueChanged<bool?>? onChanged;

  const CheckboxWidget({
    super.key,
    required this.text,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => onChanged?.call(!value),
          child: Image.asset(
            value
                ? 'assets/images/ic_checkbox_checked.png'
                : 'assets/images/ic_checkbox_unchecked.png',
            width: 24.w,
            height: 24.w,
          ),
        ),
        SizedBox(width: 8.w),
        Flexible(
          child: Text(
            text,
            style: AppTextStyles.B2.copyWith(
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
      ],
    );
  }
}
