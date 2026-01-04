import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/action_outlinedbutton_widget.dart';
import 'package:academy_2_app/app/view/action_textbutton_widget.dart';
import 'package:academy_2_app/app/view/base_wait_approval_page.dart';
import 'package:academy_2_app/core/auth/pending_join_storage.dart';
import 'package:academy_2_app/core/utils/error_utils.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_provider.dart';
import '../../core/auth/join_repository.dart';

class WaitApprovalPage extends ConsumerWidget {
  const WaitApprovalPage({super.key});

  Future<void> _retry(BuildContext context, WidgetRef ref) async {
    await JoinRepository().clearPending();
    final owner = ref.read(authProvider).userId;
    await PendingJoinStorage.clearCurrent(owner: owner);
    ref.read(authProvider.notifier).setPendingJoin(false);
    if (!context.mounted) return;
    context.go('/join-group');
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(authProvider.notifier).logout(clearPendingJoin: false);
    context.go('/login');
  }

  Future<void> _handleCancel(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => const CancelEnrollmentDialog(),
    );
    if (confirmed != true || !context.mounted) return;

    final loc = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    try {
      final currentOwner = ref.read(authProvider).userId;
      final pendingId = await PendingJoinStorage.readId(owner: currentOwner);
      debugPrint(
          'WaitApprovalPage: cancelEnrollment owner=$currentOwner pendingId=$pendingId');
      await JoinRepository().cancelEnrollment();
      if (!context.mounted) return;
      final owner = ref.read(authProvider).userId;
      await PendingJoinStorage.clearCurrent(owner: owner);
      ref.read(authProvider.notifier).setPendingJoin(false);
      await ref.read(authProvider.notifier).clearSchoolBinding();
      ref.read(authProvider.notifier).requireUnlock();
      messenger.showSnackBar(
        SnackBar(content: Text(loc.waitApprovalCancelSuccess)),
      );
      context.go('/join-group');
      // Ensure navigation happens even if ScaffoldMessenger is mid-animation.
      await Future<void>.delayed(Duration.zero);
      if (context.mounted) {
        context.go('/join-group');
      }
    } on DioException catch (e) {
      if (!context.mounted) return;
      final status = e.response?.statusCode;
      final fallbackByStatus = switch (status) {
        401 => 'Unauthenticated',
        403 => 'User is not a student',
        404 => 'Enrollment belongs to another student',
        422 => 'Enrollment not pending',
        _ => null,
      };
      final errorMessage = extractDioErrorMessage(e) ??
          fallbackByStatus ??
          e.message ??
          e.toString();
      messenger.showSnackBar(
        SnackBar(content: Text(loc.waitApprovalCancelFailed(errorMessage))),
      );
    } catch (e) {
      if (!context.mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(loc.waitApprovalCancelFailed(e.toString()))),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loc = AppLocalizations.of(context)!;
    return Stack(
      children: [
        BaseWaitApprovalPage(
          title: loc.waitApprovalTitle,
          subtitle: loc.waitApprovalSubtitle,
          retry: () => _retry(context, ref),
          footer: ActionTextButtonWidget(
            color: AppColors.contentError(context),
            fullWidth: false,
            text: loc.waitApprovalCancelButton,
            onPressed: () => _handleCancel(context, ref),
          ),
          topRightAction: IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(
              minWidth: 32.w,
              minHeight: 32.w,
            ),
            icon: Image.asset(
              'assets/images/ic_close.png',
              color: AppColors.contentOnAccentPrimary(context),
              width: 20.r,
              height: 20.r,
            ),
            onPressed: () => _logout(context, ref),
          ),
        ),
      ],
    );
  }
}

class CancelEnrollmentDialog extends StatelessWidget {
  const CancelEnrollmentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(20.w),
      child: Container(
        constraints: BoxConstraints(maxWidth: 400),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.surfacePrimary(context),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.waitApprovalCancelDialogTitle,
              style: AppTextStyles.h3(context),
            ),
            SizedBox(height: 10.h),
            Text(
              l10n.waitApprovalCancelDialogMessage,
              textAlign: TextAlign.center,
              style: AppTextStyles.b1(context)
                  .copyWith(color: AppColors.contentSecondary(context)),
            ),
            SizedBox(height: 40.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 1,
                  child: ActionOutlinedButtonWidget(
                    height: 48.r,
                    onPressed: () => Navigator.pop(context, false),
                    text: l10n.waitApprovalCancelDialogCancel,
                  ),
                ),
                SizedBox(width: 20.w),
                Flexible(
                  flex: 1,
                  child: ActionButtonWidget(
                    height: 48.r,
                    onPressed: () => Navigator.pop(context, true),
                    text: l10n.waitApprovalCancelDialogConfirm,
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
