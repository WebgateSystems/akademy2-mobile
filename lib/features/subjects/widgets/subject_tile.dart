import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/circular_progress_widget.dart';
import 'package:academy_2_app/core/services/student_api_service.dart';
import 'package:academy_2_app/features/shared/centered_icon.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SubjectTile extends StatelessWidget {
  final DashboardSubject subject;
  final VoidCallback? onTap;

  const SubjectTile({
    super.key,
    required this.subject,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final completed = subject.completionRate > 0 && subject.averageScore > 0;
    final cardColor = AppColors.subjectCardColor(context, subject, completed);
    final rezultCardColor =
        AppColors.subjectCardColor(context, subject, false);

    return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6.w),
            child: Card(
              elevation: 0,
              color: cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _SubjectIcon(url: subject.iconUrl),
                    SizedBox(height: 12.h),
                    Center(
                      child: Text(
                        subject.title,
                        style: AppTextStyles.h4(context),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (completed)
            Positioned(
              left: 16.r,
              top: 0,
              child: ResultQuizWidget(
                bgColor: rezultCardColor,
                bestScore: subject.completionRate,
              ),
            ),
        ],
      ),
    );
  }
}

class ResultQuizWidget extends StatelessWidget {
  const ResultQuizWidget({
    super.key,
    required this.bgColor,
    required int bestScore,
  }) : _bestScore = bestScore;

  final int _bestScore;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        AppLocalizations.of(context)!.quizScoreLabel(_bestScore),
        style: AppTextStyles.h5(context).copyWith(
          color: AppColors.contentPrimary(context),
        ),
      ),
    );
  }
}

class _SubjectIcon extends StatelessWidget {
  const _SubjectIcon({
    this.url,
  });

  final String? url;

  @override
  Widget build(BuildContext context) {
    final size = 56.w;
    final bg = AppColors.surfaceIcon(context);
    final iconUrl = (url == null || url!.isEmpty) ? null : url;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: iconUrl == null
                ? Icon(
                    Icons.book,
                    size: size * 0.5,
                    color: AppColors.contentSecondary(context),
                  )
                : CenteredIcon(
                    url: iconUrl,
                    size: size * 0.6,
                    placeholder: const CircularProgressWidget(),
                    fallbackColor: AppColors.contentSecondary(context),
                  ),
          ),
        ),
      ),
    );
  }
}
