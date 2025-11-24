import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/toolbar_widget.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 44.h),
            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: ToolbarWidget(
                leftIcon: IconButton(
                  icon: Image.asset(
                    'assets/images/ic_chevron_left.png',
                    color: AppColors.contentPrimary(context),
                  ),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ToolbarWidget(
                        title: l10n.verifyYourAccount,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        l10n.verifyEmailMessage(email),
                        style: AppTextStyles.b1(context).copyWith(
                          color: AppColors.contentSecondary(context),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        l10n.checkSpam,
                        style: AppTextStyles.b1(context).copyWith(
                          color: AppColors.contentSecondary(context),
                        ),
                      ),
                      SizedBox(height: 32.h),
                      ActionButtonWidget(
                        onPressed: () => context.go('/create-pin'),
                        text: l10n.next,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
