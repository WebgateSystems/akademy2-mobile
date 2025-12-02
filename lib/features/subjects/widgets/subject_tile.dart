import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/core/db/entities/subject_entity.dart';
import 'package:academy_2_app/core/db/isar_service.dart';
import 'package:academy_2_app/core/network/api.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SubjectTile extends StatefulWidget {
  final SubjectEntity subject;
  final VoidCallback? onTap;

  const SubjectTile({
    super.key,
    required this.subject,
    this.onTap,
  });

  @override
  State<SubjectTile> createState() => _SubjectTileState();
}

class _SubjectTileState extends State<SubjectTile> {
  int _bestScore = 0;

  @override
  void initState() {
    super.initState();
    _loadScore();
  }

  Future<void> _loadScore() async {
    final isar = IsarService();
    final score = await isar.getBestQuizScoreForSubject(widget.subject.id);
    if (mounted) setState(() => _bestScore = score);
  }

  @override
  Widget build(BuildContext context) {
    final completed = _bestScore > 0;
    final cardColor =
        AppColors.subjectCardColor(context, widget.subject, completed);
    final rezultCardColor =
        AppColors.subjectCardColor(context, widget.subject, false);
    return InkWell(
      onTap: widget.onTap,
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
                    _SubjectIcon(url: widget.subject.iconUrl),
                    SizedBox(height: 12.h),
                    Center(
                      child: Text(
                        widget.subject.title,
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
                  bgColor: rezultCardColor, bestScore: _bestScore),
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
