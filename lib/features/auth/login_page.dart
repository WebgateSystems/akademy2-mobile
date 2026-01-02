import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/action_textbutton_widget.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
import 'package:academy_2_app/app/view/edit_text_widget.dart';
import 'package:academy_2_app/core/network/api.dart';
import 'package:academy_2_app/core/utils/phone_formatter.dart';
import 'package:academy_2_app/features/shared/parental_gate_dialog.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import 'auth_flow_models.dart';
import 'pin_pages.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, this.redirect});

  final String? redirect;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _phoneCtl = TextEditingController();
  String? _phoneError;

  @override
  void dispose() {
    _phoneCtl.removeListener(_onPhoneChanged);
    _phoneCtl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _phoneCtl.addListener(_onPhoneChanged);
  }

  void _goToPin() {
    FocusScope.of(context).unfocus();
    final l10n = AppLocalizations.of(context)!;
    final phone = _phoneCtl.text.trim();

    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.loginPhoneRequired)),
      );
      return;
    }
    if (_phoneError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.loginPhoneInvalid)),
      );
      return;
    }

    context.push(
      '/login-pin',
      extra: LoginPinArgs(phone: phone, redirect: widget.redirect),
    );
  }

  String _prevPhone = '';

  void _onPhoneChanged() {
    final raw = _phoneCtl.text;
    final formatted = PlPhoneFormatter.format(raw, previousValue: _prevPhone);
    _prevPhone = formatted;

    if (formatted != raw) {
      final newValue = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
      _phoneCtl.value = newValue;
    }

    setState(() {
      _phoneError = (_phoneCtl.text.trim().isEmpty ||
              PlPhoneFormatter.isValid(_phoneCtl.text.trim()))
          ? null
          : AppLocalizations.of(context)!.loginPhoneInvalid;
    });
  }

  void _openPrivacyPolicy() async {
    final approved = await ParentalGateDialog.show(context);
    if (mounted && approved) {
      final locale = Localizations.localeOf(context).languageCode;
      final url = locale.toLowerCase().startsWith('pl')
          ? Api.privacyPolicyPlUrl
          : Api.privacyPolicyEnUrl;
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: BasePageWithToolbar(
            stickChildrenToBottom: true,
            showBackButton: false,
            title: l10n.loginTitle,
            children: [
              SizedBox(height: 16.h),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    children: [
                      EditTextWidget(
                        controller: _phoneCtl,
                        hint: l10n.phoneHintField,
                        label: l10n.phoneField,
                        keyboard: TextInputType.phone,
                        errorText: _phoneError,
                      ),
                      SizedBox(height: 16.h),
                      ActionButtonWidget(
                        onPressed: _goToPin,
                        text: l10n.loginTitle,
                        loading: isLoading,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              ActionTextButtonWidget(
                onPressed: () => context.go('/forgot-password'),
                text: l10n.loginForgotPassword,
                fullWidth: true,
              ),
              Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(l10n.loginCreateAccountPrompt),
                    SizedBox(width: 6.w),
                    ActionTextButtonWidget(
                      onPressed: () => context.go('/create-account'),
                      text: l10n.loginCreateAccountCta,
                      fullWidth: false,
                    ),
                  ],
                ),
              ),
              Spacer(),
              Center(
                child: ActionTextButtonWidget(
                  onPressed: _openPrivacyPolicy,
                  text: l10n.privacyPolicy,
                  fullWidth: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPinPage extends ConsumerStatefulWidget {
  const LoginPinPage({super.key, required this.args});

  final LoginPinArgs args;

  @override
  ConsumerState<LoginPinPage> createState() => _LoginPinPageState();
}

class _LoginPinPageState extends ConsumerState<LoginPinPage> {
  String _current = '';
  bool _submitting = false;
  String? _errorMessage;
  late String _phone;

  @override
  void initState() {
    super.initState();
    _phone = widget.args.phone.trim().replaceAll(' ', '');
  }

  void _handleKey(String value) async {
    if (_submitting) return;

    if (_errorMessage != null) {
      setState(() => _errorMessage = null);
    }

    if (value == 'back') {
      if (_current.isNotEmpty) {
        setState(() => _current = _current.substring(0, _current.length - 1));
      }
      return;
    }

    if (_current.length >= 4) return;
    setState(() => _current += value);
    if (_current.length == 4) {
      await _submitPin();
    }
  }

  Future<void> _submitPin() async {
    setState(() => _submitting = true);
    final l10n = AppLocalizations.of(context)!;
    try {
      if (_phone.isEmpty) {
        setState(() {
          _errorMessage = l10n.loginPhoneRequired;
          _current = '';
          _submitting = false;
        });
        return;
      }
      await ref.read(authProvider.notifier).login(_phone, _current);
      if (!mounted) return;
      final authState = ref.read(authProvider);
      final target = authState.hasPendingJoin
          ? '/wait-approval'
          : ((widget.args.redirect?.isNotEmpty ?? false)
              ? widget.args.redirect!
              : '/home');
      context.go(target);
    } on DioException catch (e) {
      final serverError = _extractServerError(e);
      if (!mounted) return;
      String message;
      if (e.response?.statusCode == 401) {
        message = l10n.loginPinInvalid;
      } else if (e.response?.statusCode == 404) {
        message = l10n.loginUserNotFound;
      } else if (e.type == DioExceptionType.connectionError ||
          e.type == DioExceptionType.connectionTimeout) {
        message = l10n.networkError;
      } else {
        message = l10n.loginPinInvalid;
      }
      setState(() {
        _errorMessage = serverError ?? message;
        _current = '';
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = l10n.loginPinInvalid;
        _current = '';
      });
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PinScaffold(
      title: l10n.loginPinTitle,
      subtitle: l10n.loginPinSubtitle,
      pin: _current,
      onKey: _handleKey,
      showProgress: _submitting,
      errorMessage: _errorMessage,
    );
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
}
