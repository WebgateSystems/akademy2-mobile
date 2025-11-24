import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Create an Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('First name', _firstNameCtrl),
            _buildTextField('Last name', _lastNameCtrl),
            GestureDetector(
              onTap: _pickDob,
              child: AbsorbPointer(
                child: _buildTextField(
                  'Date of birth',
                  _dobCtrl,
                  suffix: const Icon(Icons.calendar_today, size: 18),
                ),
              ),
            ),
            _buildTextField('Email', _emailCtrl, errorText: _emailError),
            _buildTextField(
              'Phone',
              _phoneCtrl,
              keyboard: TextInputType.phone,
              errorText: _phoneError,
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              value: _agree,
              onChanged: (v) => setState(() => _agree = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'By providing my email I agree to receive communications from Academy 2.0 I understand I can opt out at any time.',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isFormValid && !_loading ? _submit : null,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Create account'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
    String? errorText,
    Widget? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          labelText: label,
          errorText: errorText,
          suffixIcon: suffix,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
