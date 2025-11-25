import 'dart:async';

import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
import 'package:academy_2_app/app/view/edit_text_widget.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../core/auth/join_repository.dart';
import '../../core/storage/secure_storage.dart';

class JoinGroupPage extends StatefulWidget {
  const JoinGroupPage({super.key});

  @override
  State<JoinGroupPage> createState() => _JoinGroupPageState();
}

class _JoinGroupPageState extends State<JoinGroupPage> {
  final _codeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _restorePending();
  }

  Future<void> _restorePending() async {
    final storage = SecureStorage();
    final pending = await storage.read('pendingJoinId');
    if (pending != null && pending.isNotEmpty && mounted) {
      context.go('/wait-approval');
    }
  }

  bool _submitting = false;
  bool _scanPaused = false;
  String? _error;

  @override
  void dispose() {
    _codeCtrl.dispose();
    super.dispose();
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
      if (!mounted) return;
      context.go('/wait-approval');
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: BasePageWithToolbar(
        title: l10n.joinGroupTitle,
        subtitle: l10n.joinGroupSubtitle,
        stickChildrenToBottom: true,
        showBackButton: true,
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
                        controller:
                            MobileScannerController(torchEnabled: false),
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
    );
  }
}
