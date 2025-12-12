import 'dart:async';

import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
import 'package:academy_2_app/app/view/edit_text_widget.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:dio/dio.dart';

import '../../app/theme/tokens.dart';
import '../../app/view/action_outlinedbutton_widget.dart';
import '../../core/auth/auth_provider.dart';
import '../../core/auth/join_repository.dart';
import '../../core/storage/secure_storage.dart';

class JoinGroupPage extends ConsumerStatefulWidget {
  const JoinGroupPage({super.key});

  @override
  ConsumerState<JoinGroupPage> createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends ConsumerState<JoinGroupPage>
    with WidgetsBindingObserver {
  final _codeCtrl = TextEditingController();
  late final MobileScannerController _scannerController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scannerController = MobileScannerController(torchEnabled: false);
    _restorePending();
  }

  Future<void> _restorePending() async {
    final storage = SecureStorage();
    final pending = await storage.read('pendingJoinId');
    if (pending != null && pending.isNotEmpty && mounted) {
      ref.read(authProvider.notifier).setPendingJoin(true);
      context.go('/wait-approval');
    }
  }

  bool _submitting = false;
  bool _scanPaused = false;
  String? _error;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _codeCtrl.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!_scanPaused) {
        _scannerController.start();
      }
    } else {
      _scannerController.stop();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void deactivate() {
    _scannerController.stop();
    super.deactivate();
  }

  bool get _canSubmit => _codeCtrl.text.trim().isNotEmpty && !_submitting;

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final code = _codeCtrl.text.trim().toUpperCase();
    if (code.isEmpty) return;
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final repo = JoinRepository();
      final pendingId = await repo.joinWithCode(code);
      await SecureStorage().write('pendingJoinId', pendingId);
      await SecureStorage().write('pendingJoinCode', code);
      ref.read(authProvider.notifier).setPendingJoin(true);
      await ref.read(authProvider.notifier).logout();
      if (!mounted) return;
      context.go('/login');
    } on DioException catch (e) {
      final message = _extractServerError(e) ?? e.message ?? e.toString();
      setState(() => _error = l10n.joinGroupSubmitError(message));
    } catch (e) {
      setState(() => _error = l10n.joinGroupSubmitError(e.toString()));
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (_scanPaused) return;
    final raw =
        capture.barcodes.isNotEmpty ? capture.barcodes.first.rawValue : null;
    if (raw != null && raw.isNotEmpty) {
      setState(() {
        _scanPaused = true;
        _codeCtrl.text = raw;
      });
      _scannerController.stop();
    }
  }

  String? _extractServerError(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final err = data['error'] ?? data['message'];
      if (err is String && err.isNotEmpty) return err;
    } else if (data is String && data.isNotEmpty) {
      return data;
    }
    return null;
  }

  Future<void> _confirmLogout() async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(20.w),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary(context),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.profileLogoutTitle,
                  style: AppTextStyles.h3(context),
                ),
                SizedBox(height: 10.h),
                Text(
                  l10n.profileLogoutMessage,
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
                        height: 48.h,
                        onPressed: () => Navigator.pop(context, false),
                        text: l10n.profileLogoutCancel,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Flexible(
                      flex: 1,
                      child: ActionButtonWidget(
                        height: 48.h,
                        onPressed: () => Navigator.pop(context, true),
                        text: l10n.profileLogoutConfirm,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (confirm == true) {
      await ref.read(authProvider.notifier).logout();
      if (mounted) {
        context.go('/login');
      }
    }
  }

  Future<void> _handleBackPressed() async {
    if (Navigator.of(context).canPop()) {
      context.pop();
      return;
    }
    await _confirmLogout();
  }

  Future<bool> _handleWillPop() async {
    if (Navigator.of(context).canPop()) {
      return true;
    }
    await _confirmLogout();
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return WillPopScope(
      onWillPop: _handleWillPop,
      child: Scaffold(
        body: BasePageWithToolbar(
          title: l10n.joinGroupTitle,
          subtitle: l10n.joinGroupSubtitle,
          stickChildrenToBottom: true,
          showBackButton: true,
          onBack: _handleBackPressed,
          children: [
            SizedBox(height: 32.h),
            EditTextWidget(
              controller: _codeCtrl,
              onChanged: (_) => setState(() {}),
              hint: l10n.joinGroupHint,
              errorText: _error,
            ),
            const Spacer(),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 240.w,
                  height: 240.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16.r),
                    child: Stack(
                      children: [
                        MobileScanner(
                          onDetect: _onDetect,
                          controller: _scannerController,
                        ),
                        if (_scanPaused)
                          Positioned.fill(
                            child: Container(
                              color: Colors.black45,
                              child: Center(
                                child: Text(
                                  l10n.joinGroupCodeCaptured,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            ActionButtonWidget(
              onPressed: _canSubmit ? _submit : null,
              text: l10n.next,
            ),
          ],
        ),
      ),
    );
  }
}
