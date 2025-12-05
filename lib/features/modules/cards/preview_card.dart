import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PreviewCard extends StatelessWidget {
  const PreviewCard({
    required this.thumbnail,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final Widget thumbnail;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.transparent,
      child: Column(
        children: [
          SizedBox(height: 200.h, width: double.infinity, child: thumbnail),
          SizedBox(height: 8.h),
          ListTile(
            title: Text(
              title,
              style: AppTextStyles.h5(context),
            ),
            subtitle: Text(
              subtitle,
              style: AppTextStyles.b3(context).copyWith(
                color: AppColors.contentSecondary(context),
              ),
            ),
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
