import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:flutter/material.dart';

class ToolbarWidget extends StatelessWidget {
  final Widget? leftIcon;
  final Widget? rightIcon;
  final String title;

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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leftIcon != null) ...[
          leftIcon!,
          const SizedBox(width: 12),
        ],
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.h1(context).copyWith(
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
        ),
        if (rightIcon != null) ...[
          const SizedBox(width: 12),
          rightIcon!,
        ],
      ],
    );
  }
}
