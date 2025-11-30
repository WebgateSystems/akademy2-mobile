import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/core/db/entities/subject_entity.dart';
import 'package:academy_2_app/core/network/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubjectTile extends StatelessWidget {
  final SubjectEntity subject;
  final VoidCallback? onTap;

  const SubjectTile({
    super.key,
    required this.subject,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.subjectCardColor(context, subject),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _SubjectIcon(url: subject.iconUrl),
                SizedBox(height: 16.h),
                Text(subject.title,
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

class _SubjectIcon extends StatelessWidget {
  const _SubjectIcon({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    final size = 56.w;
    final bg = AppColors.surfaceIcon(context);
    final fullUrl =
        (url == null || url!.isEmpty) ? null : Api.baseUploadUrl + url!;

    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bg,
          shape: BoxShape.circle,
        ),
        child: ClipOval(
          child: fullUrl == null
              ? const Icon(Icons.book)
              : SvgPicture.network(
                  fullUrl,
                  fit: BoxFit.contain,
                  placeholderBuilder: (_) =>
                      const CircularProgressIndicator(strokeWidth: 2),
                ),
        ),
      ),
    );
  }
}
