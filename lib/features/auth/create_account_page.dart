import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/checkbox_widget.dart';
import 'package:academy_2_app/app/view/edit_text_widget.dart';
import 'package:academy_2_app/app/view/toolbar_widget.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'auth_flow_models.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
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
    _phoneCtrl.addListener(_validatePhone);
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

  void _validatePhone() {
    final phone = _phoneCtrl.text.trim();
    final regex = RegExp(r'^\+?[0-9\s-]{7,}$');
    setState(() {
      _phoneError = phone.isEmpty || regex.hasMatch(phone)
          ? null
          : 'Invalid phone number.';
    });
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 18, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _dob = picked;
        _dobCtrl.text =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      });
    }
  }

  Future<void> _submit() async {
    if (!_isFormValid) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    final args = VerifyPhoneArgs(
      phone: _phoneCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
    );
    context.go('/verify-phone', extra: args);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 44.h),
            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: ToolbarWidget(
                title: loc?.createAnAccount ?? 'Create an Account',
              ),
            ),
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
            ),
            SizedBox(height: 20.h),
            CheckboxWidget(
              text: loc?.iAgreeToReceive ?? '',
              value: _agree,
              onChanged: (v) => setState(() => _agree = v ?? false),
            ),
            SizedBox(height: 20.h),
            ActionButtonWidget(
              onPressed: _isFormValid && !_loading ? _submit : null,
              text: loc?.createAccountButton ?? 'Create account',
              loading: _loading,
            ),
          ],
        ),
      ),
    );
  }
}
