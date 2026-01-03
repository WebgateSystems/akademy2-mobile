import 'dart:async';

import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
import 'package:academy_2_app/app/view/edit_text_widget.dart';
import 'package:academy_2_app/core/utils/error_utils.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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
  bool _keyboardVisible = false;
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
      context.go('/wait-approval');
    } on DioException catch (e) {
      final message = extractDioErrorMessage(e) ?? e.message ?? e.toString();
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

  void _updateScannerForKeyboard(bool isKeyboardOpen) {
    if (_keyboardVisible == isKeyboardOpen) return;
    _keyboardVisible = isKeyboardOpen;
    if (isKeyboardOpen) {
      _scannerController.stop();
    } else if (!_scanPaused) {
      _scannerController.start();
    }
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
                        height: 48.r,
                        onPressed: () => Navigator.pop(context, false),
                        text: l10n.profileLogoutCancel,
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Flexible(
                      flex: 1,
                      child: ActionButtonWidget(
                        height: 48.r,
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
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _updateScannerForKeyboard(isKeyboardOpen),
    );

    return WillPopScope(
      onWillPop: _handleWillPop,
      child: Scaffold(
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: BasePageWithToolbar(
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
                if (!isKeyboardOpen)
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 240.r,
                        height: 240.r,
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
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            l10n.joinGroupCodeCaptured,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          SizedBox(height: 20.h),
                                          Padding(
                                            padding: EdgeInsets.all(20.h),
                                            child: ActionOutlinedButtonWidget(
                                              height: 36.r,
                                              color: Colors.white,
                                              onPressed: () {
                                                setState(() {
                                                  _scanPaused = false;
                                                  _error = null;
                                                });
                                                _scannerController.start();
                                              },
                                              text: l10n.joinGroupScanAgain,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  SizedBox(height: 24.h),
                const Spacer(),
                ActionButtonWidget(
                  onPressed: _canSubmit ? _submit : null,
                  text: l10n.next,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
