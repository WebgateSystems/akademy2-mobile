import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:flutter/material.dart';

class ToolbarWidget extends StatelessWidget {
  Widget? leftIcon;
  Widget? rightIcon;
  String title;

  ToolbarWidget({
    super.key,
    this.leftIcon,
    this.rightIcon,
    this.title = "",
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        if (leftIcon != null) leftIcon!,
        if (leftIcon != null) Spacer(),
        Text(
          title,
          style: AppTextStyles.h1(context).copyWith(
            color: theme.textTheme.bodyMedium?.color,
          ),
        ),
        if (rightIcon != null) Spacer(),
        if (rightIcon != null) rightIcon!,
      ],
    );
  }
}
