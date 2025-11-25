import 'dart:async';

import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_provider.dart';
import '../../core/auth/join_repository.dart';
import '../../core/storage/secure_storage.dart';

class WaitApprovalPage extends ConsumerStatefulWidget {
  const WaitApprovalPage({super.key});

  @override
  ConsumerState<WaitApprovalPage> createState() => _WaitApprovalPageState();
}

class _WaitApprovalPageState extends ConsumerState<WaitApprovalPage> {
  Timer? _timer;
  String? _requestId;
  String? _code;
  String _status = 'pending';

  @override
  void initState() {
    super.initState();
    _loadPending();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadPending() async {
    final storage = SecureStorage();
    final id = await storage.read('pendingJoinId');
    final code = await storage.read('pendingJoinCode');
    if (id == null || id.isEmpty) {
      if (mounted) context.go('/join-group');
      return;
    }
    setState(() {
      _requestId = id;
      _code = code;
    });
    _startPolling();
  }

  void _startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _poll());
    _poll();
  }

  Future<void> _poll() async {
    if (_requestId == null) return;
    final repo = JoinRepository();
    final status = await repo.checkStatus(_requestId!);
    if (!mounted) return;
    setState(() => _status = status.status);
    if (status.status == 'approved' && status.accessToken != null) {
      await repo.clearPending();
      _timer?.cancel();
      await ref.read(authProvider.notifier).setTokens(
            status.accessToken!,
            refreshToken: status.refreshToken,
          );
      if (!mounted) return;
      context.go('/home');
    }
  }

  Future<void> _retry() async {
    await JoinRepository().clearPending();
    if (!mounted) return;
    context.go('/join-group');
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final rejected = _status == 'rejected';

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
                loc.waitApprovalTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.h1(context)
                    .copyWith(color: AppColors.contentOnAccentPrimary(context)),
              ),
              SizedBox(height: 16.h),
              Text(
                loc.waitApprovalSubtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.b1(context).copyWith(
                  color: AppColors.contentOnAccentSecondary(context),
                ),
              ),
              if (rejected) SizedBox(height: 16.h),
              if (rejected)
                ActionButtonWidget(
                  onPressed: _retry,
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
