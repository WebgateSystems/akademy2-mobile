import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
import 'package:academy_2_app/features/auth/auth_flow_models.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key, required this.args});

  final VerifyEmailArgs args;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: BasePageWithToolbar(
            title: l10n.verifyYourAccount,
            subtitle: l10n.verifyEmailMessage(args.email),
            showBackButton: true,
            children: [
              Text(
                l10n.checkSpam,
                style: AppTextStyles.b1(context).copyWith(
                  color: AppColors.contentSecondary(context),
                ),
              ),
              SizedBox(height: 32.h),
              ActionButtonWidget(
                onPressed: () =>
                    context.push('/create-pin', extra: args.flowId),
                text: l10n.next,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
