import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
import 'package:academy_2_app/app/view/checkbox_widget.dart';
import 'package:academy_2_app/app/view/edit_text_widget.dart';
import 'package:academy_2_app/core/network/api_endpoints.dart';
import 'package:academy_2_app/core/network/dio_provider.dart';
import 'package:academy_2_app/core/utils/phone_formatter.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'auth_flow_models.dart';

class CreateAccountPage extends ConsumerStatefulWidget {
  const CreateAccountPage({super.key});

  @override
  ConsumerState<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends ConsumerState<CreateAccountPage> {
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  DateTime? _dob;
  bool _agree = false;
  bool _loading = false;
  String? _emailError;
  String? _phoneError;

  @override
  void initState() {
    super.initState();
    _emailCtrl.addListener(_validateEmail);
    _phoneCtrl.addListener(_onPhoneChanged);
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _dobCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _firstNameCtrl.text.trim().isNotEmpty &&
        _lastNameCtrl.text.trim().isNotEmpty &&
        _dob != null &&
        _emailError == null &&
        _phoneError == null &&
        _emailCtrl.text.trim().isNotEmpty &&
        _phoneCtrl.text.trim().isNotEmpty &&
        _agree;
  }

  void _validateEmail() {
    final email = _emailCtrl.text.trim();
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    setState(() {
      _emailError = email.isEmpty || regex.hasMatch(email)
          ? null
          : 'Invalid email format.';
    });
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final initial = _dob ?? DateTime(now.year - 18, now.month, now.day);
    final minDate = DateTime(1900);
    final maxDate = now;
    var tempDate = initial;

    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      useSafeArea: true,
      builder: (ctx) {
        final l10n = AppLocalizations.of(ctx)!;
        return SafeArea(
          child: SizedBox(
            height: 448.h,
            child: Column(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
                  child: Text(
                    l10n.addBirthdate,
                    style: AppTextStyles.h1(context),
                  ),
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: initial,
                    minimumDate: minDate,
                    maximumDate: maxDate,
                    onDateTimeChanged: (date) => tempDate = date,
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.w),
                  child: ActionButtonWidget(
                    onPressed: () => Navigator.of(ctx).pop(tempDate),
                    text: l10n.addButton,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dob = picked;
        _dobCtrl.text = '${picked.day.toString().padLeft(2, '0')}.'
            '${picked.month.toString().padLeft(2, '0')}.'
            '${picked.year.toString()}';
      });
    }
  }

  String _prevPhone = '';

  void _onPhoneChanged() {
    final raw = _phoneCtrl.text;
    final formatted = PlPhoneFormatter.format(raw, previousValue: _prevPhone);
    _prevPhone = formatted;

    if (formatted != raw) {
      final newValue = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
      _phoneCtrl.value = newValue;
    }

    setState(() {
      _phoneError = (_phoneCtrl.text.trim().isEmpty ||
              PlPhoneFormatter.isValid(_phoneCtrl.text.trim()))
          ? null
          : 'Invalid phone number.';
    });
  }

  Future<void> _submit() async {
    if (!_isFormValid) return;
    setState(() => _loading = true);
    try {
      final dio = ref.read(dioProvider);

      final flowResp = await dio.get(ApiEndpoints.registerFlow);
      final flowId = (flowResp.data['data']?['id'] as String?) ?? '';
      if (flowId.isEmpty) {
        throw Exception('Flow id missing');
      }

      await dio.post(
        ApiEndpoints.registerProfile,
        data: {
          'flow_id': flowId,
          'profile': {
            'first_name': _firstNameCtrl.text.trim(),
            'last_name': _lastNameCtrl.text.trim(),
            'email': _emailCtrl.text.trim(),
            'birthdate': _dobCtrl.text.trim(),
            'phone': _phoneCtrl.text.trim().replaceAll(' ', ''),
          },
        },
      );

      if (!mounted) return;
      final args = VerifyPhoneArgs(
        phone: _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim(),
        flowId: flowId,
      );
      context.push('/verify-phone', extra: args);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      body: BasePageWithToolbar(
        showBackButton: false,
        stickChildrenToBottom: true,
        title: loc?.createAnAccount ?? 'Create an Account',
        children: [
          SizedBox(height: 20.h),
          EditTextWidget(
              label: loc?.firstNameField ?? 'First name',
              hint: loc?.firstNameField ?? 'First name',
              controller: _firstNameCtrl),
          SizedBox(height: 12.h),
          EditTextWidget(
              label: loc?.lastNameField ?? 'Last name',
              hint: loc?.lastNameField ?? 'Last name',
              controller: _lastNameCtrl),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: _pickDob,
            child: AbsorbPointer(
              child: EditTextWidget(
                label: loc?.dateOfBirthField ?? 'Date of birth',
                hint: loc?.dateOfBirthHintField ?? 'Date of birth',
                controller: _dobCtrl,
                readOnly: true,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          EditTextWidget(
              label: loc?.emailField ?? 'Email',
              hint: loc?.emailHintField ?? 'Email',
              controller: _emailCtrl,
              errorText: _emailError),
          SizedBox(height: 12.h),
          EditTextWidget(
            label: loc?.phoneField ?? 'Phone',
            hint: loc?.phoneHintField ?? 'Phone',
            controller: _phoneCtrl,
            keyboard: TextInputType.phone,
            errorText: _phoneError,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => FocusScope.of(context).unfocus(),
          ),
          SizedBox(height: 20.h),
          CheckboxWidget(
            text: loc?.iAgreeToReceive ?? '',
            value: _agree,
            onChanged: (v) => setState(() => _agree = v ?? false),
          ),
          Spacer(),
          ActionButtonWidget(
            onPressed: _isFormValid && !_loading ? _submit : null,
            text: loc?.createAccountButton ?? 'Create account',
            loading: _loading,
          ),
        ],
      ),
    );
  }
}
