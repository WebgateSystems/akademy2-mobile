import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubjectTile extends StatelessWidget {
  final String id;
  final String title;
  final int moduleCount;
  final Color? color;
  final VoidCallback? onTap;

  const SubjectTile({
    super.key,
    required this.id,
    required this.title,
    required this.moduleCount,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: color,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 56.w / 2,
                  backgroundColor: AppColors.surfaceIcon(context),
                  child: Text(
                    moduleCount.toString(),
                    style: AppTextStyles.h4(context).copyWith(
                      color: AppColors.surfaceIcon(context),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(title,
                    style: AppTextStyles.h4(context),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
