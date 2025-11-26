import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/action_textbutton_widget.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
import 'package:academy_2_app/app/view/edit_text_widget.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  bool _dirty = false;
  Map<String, String> _initial = {};

  @override
  void initState() {
    super.initState();
    for (final ctrl in [
      _firstNameCtrl,
      _lastNameCtrl,
      _dobCtrl,
      _emailCtrl,
      _phoneCtrl,
      _pinCtrl,
    ]) {
      ctrl.addListener(_updateDirty);
    }
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
    _initial = {
      'firstName': _firstNameCtrl.text,
      'lastName': _lastNameCtrl.text,
      'dob': _dobCtrl.text,
      'email': _emailCtrl.text,
      'phone': _phoneCtrl.text,
      'pin': _pinCtrl.text,
      'theme': _theme,
      'language': _language,
    };
    if (mounted) {
      setState(() {
        _dirty = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    final l10n = AppLocalizations.of(context)!;
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
            .showSnackBar(SnackBar(content: Text(l10n.profileSaveSuccess)));
        _initial = {
          'firstName': _firstNameCtrl.text.trim(),
          'lastName': _lastNameCtrl.text.trim(),
          'dob': _dobCtrl.text.trim(),
          'email': _emailCtrl.text.trim(),
          'phone': _phoneCtrl.text.trim(),
          'pin': _pinCtrl.text.trim(),
          'theme': _theme,
          'language': _language,
        };
        _dirty = false;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileSaveFailed('$e'))),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    final l10n = AppLocalizations.of(context)!;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.profileLogoutTitle),
        content: Text(l10n.profileLogoutMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.profileLogoutCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.profileLogoutConfirm),
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
    final l10n = AppLocalizations.of(context)!;
    setState(() => _deleting = true);
    final dio = ref.read(dioProvider);
    try {
      await dio.delete('/v1/account/delete');
      await ref.read(authProvider.notifier).logout();
      if (mounted) context.go('/join-group');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileDeleteFailed('$e'))),
        );
      }
    } finally {
      if (mounted) setState(() => _deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: BasePageWithToolbar(
          title: l10n.profileTitle,
          showBackButton: false,
          children: [
            EditTextWidget(
              label: l10n.profileFirstName,
              readOnly: true,
              controller: _firstNameCtrl,
            ),
            SizedBox(height: 8.h),
            EditTextWidget(
              label: l10n.profileLastName,
              readOnly: true,
              controller: _lastNameCtrl,
            ),
            SizedBox(height: 8.h),
            EditTextWidget(
              label: l10n.profileDob,
              readOnly: true,
              controller: _dobCtrl,
            ),
            SizedBox(height: 8.h),
            EditTextWidget(
              label: l10n.profileEmail,
              readOnly: false,
              keyboard: TextInputType.emailAddress,
              controller: _emailCtrl,
              infoText:
                  _emailCtrl.text.isEmpty ? l10n.unverifiedEmailAddress : null,
            ),
            SizedBox(height: 8.h),
            EditTextWidget(
              label: l10n.profilePhone,
              readOnly: false,
              keyboard: TextInputType.phone,
              controller: _phoneCtrl,
              infoText:
                  _phoneCtrl.text.isEmpty ? l10n.unverifiedPhoneNubmer : null,
            ),
            SizedBox(height: 8.h),
            EditTextWidget(
              label: l10n.profilePin,
              readOnly: false,
              keyboard: TextInputType.number,
              controller: _pinCtrl,
              obscureText: true,
              maxLength: 4,
            ),
            SizedBox(height: 8.h),
            _dropdown<String>(
              label: l10n.profileTheme,
              value: _theme,
              items: [
                DropdownMenuItem(
                  value: 'light',
                  child: Text(l10n.profileThemeLight),
                ),
                DropdownMenuItem(
                  value: 'dark',
                  child: Text(l10n.profileThemeDark),
                ),
              ],
              onChanged: (v) {
                setState(() => _theme = v ?? 'light');
                _updateDirty();
              },
            ),
            SizedBox(height: 8.h),
            _dropdown<String>(
              label: l10n.profileLanguage,
              value: _language,
              items: [
                DropdownMenuItem(value: 'en', child: Text(l10n.profileLangEn)),
                DropdownMenuItem(value: 'uk', child: Text(l10n.profileLangUk)),
                DropdownMenuItem(value: 'pl', child: Text(l10n.profileLangPl)),
              ],
              onChanged: (v) {
                setState(() => _language = v ?? 'en');
                _updateDirty();
              },
            ),
            SizedBox(height: 20.h),
            if (_dirty)
              ActionButtonWidget(
                onPressed: _loading ? null : _saveProfile,
                loading: _loading,
                text: l10n.profileSaveButton,
              ),
            if (_dirty) SizedBox(height: 8.h),
            Row(
              children: [
                Flexible(
                  flex: 1,
                  child: ActionTextButtonWidget(
                    onPressed: _deleting ? null : _deleteAccount,
                    color: AppColors.contentError(context),
                    loading: _deleting,
                    text: l10n.profileDeleteButton,
                  ),
                ),
                SizedBox(width: 8.h),
                Flexible(
                  flex: 1,
                  child: ActionTextButtonWidget(
                    onPressed: _deleting ? null : _logout,
                    text: l10n.profileLogoutButton,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    String? hint,
    String? errorText,
    bool enabled = true,
    EdgeInsetsGeometry? contentPadding,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.b2(context).copyWith(
              color: theme.textTheme.bodyMedium?.color,
            ),
          ),
          SizedBox(height: 4.h),
          DropdownButtonFormField<T>(
            value: value,
            items: items,
            onChanged: enabled ? onChanged : null,
            isExpanded: true,
            style: AppTextStyles.b2(context),
            icon: Image.asset(
              'assets/images/ic_chevron_down.png',
              color: AppColors.contentPlaceholder(context),
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.surfacePrimary(context),
              hintText: hint,
              hintStyle: AppTextStyles.b2(context).copyWith(
                color: AppColors.contentPlaceholder(context),
              ),
              errorText: errorText,
              errorStyle: AppTextStyles.b3(context).copyWith(
                color: AppColors.contentError(context),
              ),
              contentPadding: contentPadding,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide: BorderSide(
                  color: AppColors.borderPrimary(context),
                  width: 1.w,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide: BorderSide(
                  color: AppColors.borderFocused(context),
                  width: 1.w,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide: BorderSide(
                  color: AppColors.borderError(context),
                  width: 1.w,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.r),
                borderSide: BorderSide(
                  color: AppColors.borderError(context),
                  width: 1.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _updateDirty() {
    final current = {
      'firstName': _firstNameCtrl.text,
      'lastName': _lastNameCtrl.text,
      'dob': _dobCtrl.text,
      'email': _emailCtrl.text,
      'phone': _phoneCtrl.text,
      'pin': _pinCtrl.text,
      'theme': _theme,
      'language': _language,
    };
    final dirtyNow =
        current.entries.any((e) => e.value != (_initial[e.key] ?? ''));
    if (dirtyNow != _dirty && mounted) {
      setState(() => _dirty = dirtyNow);
    }
  }
}
