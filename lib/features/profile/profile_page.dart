import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_provider.dart';
import '../../core/network/dio_provider.dart';
import '../../core/storage/secure_storage.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _pinCtrl = TextEditingController();

  String _theme = 'light';
  String _language = 'en';
  bool _loading = false;
  bool _deleting = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _dobCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _pinCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final storage = SecureStorage();
    _firstNameCtrl.text = await storage.read('firstName') ?? '';
    _lastNameCtrl.text = await storage.read('lastName') ?? '';
    _dobCtrl.text = await storage.read('dob') ?? '';
    _emailCtrl.text = await storage.read('email') ?? '';
    _phoneCtrl.text = await storage.read('phone') ?? '';
    _pinCtrl.text = await storage.read('userPin') ?? '';
    _theme = await storage.read('theme') ?? 'light';
    _language = await storage.read('language') ?? 'en';
    if (mounted) setState(() {});
  }

  Future<void> _pickDob() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      _dobCtrl.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      setState(() {});
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _loading = true);
    final dio = ref.read(dioProvider);
    try {
      await dio.post('/v1/account/update', data: {
        'firstName': _firstNameCtrl.text.trim(),
        'lastName': _lastNameCtrl.text.trim(),
        'dob': _dobCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'pin': _pinCtrl.text.trim(),
        'theme': _theme,
        'language': _language,
      });
      final storage = SecureStorage();
      await storage.write('firstName', _firstNameCtrl.text.trim());
      await storage.write('lastName', _lastNameCtrl.text.trim());
      await storage.write('dob', _dobCtrl.text.trim());
      await storage.write('email', _emailCtrl.text.trim());
      await storage.write('phone', _phoneCtrl.text.trim());
      await storage.write('userPin', _pinCtrl.text.trim());
      await storage.write('theme', _theme);
      await storage.write('language', _language);
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Profile saved')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Do you want to logout from your account?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await ref.read(authProvider.notifier).logout();
    if (mounted) {
      context.go('/join-group');
    }
  }

  Future<void> _deleteAccount() async {
    setState(() => _deleting = true);
    final dio = ref.read(dioProvider);
    try {
      await dio.delete('/v1/account/delete');
      await ref.read(authProvider.notifier).logout();
      if (mounted) context.go('/join-group');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _field('First name', _firstNameCtrl),
            _field('Last name', _lastNameCtrl),
            GestureDetector(
              onTap: _pickDob,
              child: AbsorbPointer(
                child: _field(
                  'Date of birth',
                  _dobCtrl,
                  suffix: const Icon(Icons.calendar_today, size: 18),
                ),
              ),
            ),
            _field('Email', _emailCtrl, keyboard: TextInputType.emailAddress),
            _field('Phone', _phoneCtrl, keyboard: TextInputType.phone),
            _field('PIN code', _pinCtrl, obscure: true, maxLength: 4),
            const SizedBox(height: 12),
            _dropdown<String>(
              label: 'Theme',
              value: _theme,
              items: const [
                DropdownMenuItem(value: 'light', child: Text('Light')),
                DropdownMenuItem(value: 'dark', child: Text('Dark')),
              ],
              onChanged: (v) => setState(() => _theme = v ?? 'light'),
            ),
            const SizedBox(height: 12),
            _dropdown<String>(
              label: 'Language',
              value: _language,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'uk', child: Text('Ukrainian')),
                DropdownMenuItem(value: 'pl', child: Text('Polish')),
              ],
              onChanged: (v) => setState(() => _language = v ?? 'en'),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _saveProfile,
                child: _loading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save changes'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _deleting ? null : _logout,
                child: const Text('Logout'),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: _deleting ? null : _deleteAccount,
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: _deleting
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Delete account'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    TextInputType keyboard = TextInputType.text,
    bool obscure = false,
    int? maxLength,
    Widget? suffix,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboard,
        obscureText: obscure,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: suffix,
        ),
      ),
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
