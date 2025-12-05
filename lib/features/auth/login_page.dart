import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/action_textbutton_widget.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
import 'package:academy_2_app/app/view/edit_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

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

  void _onPhoneChanged() {
    final raw = _phoneCtl.text;
    final formatted = _formatPlPhone(raw);

    if (formatted != raw) {
      final newValue = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
      _phoneCtl.value = newValue;
    }

    setState(() {
      _phoneError = (_phoneCtl.text.trim().isEmpty ||
              _isValidPlPhone(_phoneCtl.text.trim()))
          ? null
          : AppLocalizations.of(context)!.loginPhoneInvalid;
    });
  }

  String _formatPlPhone(String input) {
    var digits = input.replaceAll(RegExp(r'\D'), '');

    if (digits.startsWith('48')) {
      digits = digits.substring(2);
    }

    if (digits.isEmpty) {
      return '';
    }

    if (digits.length > 9) {
      digits = digits.substring(0, 9);
    }

    final buffer = StringBuffer('+48 ');

    for (var i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      if (i == 2 || i == 5) {
        buffer.write(' ');
      }
    }

    return buffer.toString();
  }

  bool _isValidPlPhone(String text) {
    final regex = RegExp(r'^\+48 [0-9]{3} [0-9]{3} [0-9]{3}$');
    return regex.hasMatch(text);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      body: BasePageWithToolbar(
        stickChildrenToBottom: true,
        showBackButton: false,
        title: l10n.loginTitle,
        children: [
          SizedBox(height: 16.h),
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
          Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                  padding: EdgeInsetsGeometry.only(left: 20.w),
                  child: Text(l10n.loginCreateAccountPrompt)),
              Flexible(
                child: ActionTextButtonWidget(
                  onPressed: () => context.go('/create-account'),
                  text: l10n.loginCreateAccountCta,
                ),
              ),
            ],
          ),
          // const SizedBox(height: 12),
          // ActionOutlinedButtonWidget(
          //   onPressed: () => context.go('/tech-login'),
          //   text: 'Tech login (email/password)',
          // ),
        ],
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

  void _handleKey(String value) async {
    if (_submitting) return;
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
      final phone = widget.args.phone.trim().replaceAll(" ", "");
      if (phone.isEmpty) {
        throw Exception('Missing phone number');
      }
      await ref.read(authProvider.notifier).login(phone, _current);
      if (!mounted) return;
      final target = (widget.args.redirect?.isNotEmpty ?? false)
          ? widget.args.redirect!
          : '/home';
      context.go(target);
    } catch (e) {
      if (!mounted) return;
      setState(() => _current = '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.loginFailed('$e'))),
      );
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
    );
  }
}
