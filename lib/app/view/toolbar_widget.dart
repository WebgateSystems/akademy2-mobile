import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:flutter/material.dart';

class ToolbarWidget extends StatelessWidget {
  final String title;

  const ToolbarWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: AppTextStyles.h1(context).copyWith(
        color: theme.textTheme.bodyMedium?.color,
      ),
    );
  }
}
