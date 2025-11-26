import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BaseWaitApprovalPage extends StatelessWidget {
  const BaseWaitApprovalPage(
      {super.key,
      required this.title,
      required this.subtitle,
      this.rejected = false,
      this.retry});

  final String title;
  final String subtitle;
  final bool rejected;
  final VoidCallback? retry;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundAccent(context),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(),
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.h1(context)
                    .copyWith(color: AppColors.contentOnAccentPrimary(context)),
              ),
              SizedBox(height: 16.h),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.b1(context).copyWith(
                  color: AppColors.contentOnAccentSecondary(context),
                ),
              ),
              if (rejected) SizedBox(height: 16.h),
              if (rejected)
                ActionButtonWidget(
                  onPressed: retry,
                  text: loc.waitApprovalRetryButton,
                ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
