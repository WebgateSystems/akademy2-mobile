import 'dart:async';

import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
import 'package:academy_2_app/app/view/edit_text_widget.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/network/dio_provider.dart';
import 'auth_flow_models.dart';

class VerifyPhonePage extends ConsumerStatefulWidget {
  const VerifyPhonePage({super.key, required this.args});

  final VerifyPhoneArgs args;

  @override
  ConsumerState<VerifyPhonePage> createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends ConsumerState<VerifyPhonePage> {
  final _controllers = List.generate(4, (_) => TextEditingController());
  final _focusNodes = List.generate(4, (_) => FocusNode());
  bool _invalid = false;
  bool _loading = false;
  int _resendSeconds = 59;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _resendSeconds = 59;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_resendSeconds == 0) {
        timer.cancel();
        setState(() {});
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  String get _code => _controllers.map((c) => c.text).join();

  bool get _isCodeComplete =>
      _code.length == 4 && RegExp(r'^\d{4}$').hasMatch(_code);

  bool get _canResend => !_loading && _resendSeconds == 0;

  Future<void> _verify() async {
    if (_loading) return;

    if (!_isCodeComplete) {
      setState(() => _invalid = true);
      return;
    }

    setState(() {
      _invalid = false;
      _loading = true;
    });

    try {
      final dio = ref.read(dioProvider);
      await dio.post(
        'v1/register/verify_phone',
        data: {
          'flow_id': widget.args.flowId,
          'code': _code,
        },
      );
      if (!mounted) return;
      context.push('/create-pin', extra: widget.args.flowId);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _invalid = true;
      });
    }
  }

  void _resend() {
    if (!_canResend) return;

    final l10n = AppLocalizations.of(context)!;

    for (final c in _controllers) {
      c.clear();
    }
    setState(() {
      _invalid = false;
    });
    _startTimer();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.verifyPhoneCodeResentSnack)),
    );
  }

  void _onDigitChanged(int index, String value) {
    if (value.length > 1) {
      _controllers[index].text = value.substring(0, 1);
      _controllers[index].selection = const TextSelection.collapsed(offset: 1);
    }

    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    setState(() {});

    if (_isCodeComplete && !_loading) {
      _verify();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final phone = widget.args.phone;

    final String buttonText;
    if (_loading) {
      buttonText = '';
    } else if (_resendSeconds > 0) {
      final seconds = _resendSeconds.toString().padLeft(2, '0');
      buttonText = l10n.verifyPhoneResendCountdown(seconds);
    } else {
      buttonText = l10n.verifyPhoneResendButton;
    }

    return Scaffold(
      body: BasePageWithToolbar(
        title: l10n.verifyPhoneTitle,
        subtitle: l10n.verifyPhoneSubtitle(phone),
        showBackButton: true,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_controllers.length, (index) {
              return SizedBox(
                height: 90.w,
                width: 60.w,
                child: EditTextWidget(
                  controller: _controllers[index],
                  focusNode: _focusNodes[index],
                  keyboard: TextInputType.number,
                  maxLength: 1,
                  textAlign: TextAlign.center,
                  onChanged: (v) => _onDigitChanged(index, v),
                  errorText: _invalid ? "" : null,
                  textStyle: AppTextStyles.h1(context),
                ),
              );
            }),
          ),
          SizedBox(height: 12.h),
          if (_invalid)
            Text(
              l10n.verifyPhoneInvalidCode,
              textAlign: TextAlign.center,
              style: AppTextStyles.b2(context)
                  .copyWith(color: AppColors.contentError(context)),
            ),
          SizedBox(height: 12.h),
          ActionButtonWidget(
            onPressed: _canResend ? _resend : null,
            text: buttonText,
            loading: _loading,
          ),
        ],
      ),
    );
  }
}
