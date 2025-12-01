import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/action_textbutton_widget.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

import '../../core/storage/secure_storage.dart';

class EnableBiometricPage extends ConsumerStatefulWidget {
  const EnableBiometricPage({super.key});

  @override
  ConsumerState<EnableBiometricPage> createState() =>
      _EnableBiometricPageState();
}

class _EnableBiometricPageState extends ConsumerState<EnableBiometricPage> {
  final _auth = LocalAuthentication();
  bool _fingerprint = false;
  bool _face = false;
  bool _saving = false;

  void _toggleFingerprint() => setState(() => _fingerprint = !_fingerprint);
  void _toggleFace() => setState(() => _face = !_face);

  Future<void> _enableWithAuth() async {
    final l10n = AppLocalizations.of(context)!;
    if (_saving) return;
    if (!_fingerprint && !_face) {
      _showMessage(l10n.enableBiometricSelectOption);
      return;
    }
    setState(() => _saving = true);
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;
      if (!supported || !canCheck) {
        _showMessage(l10n.enableBiometricNotAvailable);
        if (mounted) setState(() => _saving = false);
        return;
      }
      final didAuthenticate = await _auth.authenticate(
        localizedReason: l10n.enableBiometricTitle,
      );
      if (!didAuthenticate) {
        if (mounted) setState(() => _saving = false);
        return;
      }
      await _saveAndClose(enable: true);
    } catch (e) {
      _showMessage(l10n.enableBiometricFailed('$e'));
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _skipBiometric(AppLocalizations l10n) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      // Явно вимикаємо обидва прапори, щоб не зберігати сміття.
      _fingerprint = false;
      _face = false;
      await _saveAndClose(enable: false);
    } catch (e) {
      _showMessage(l10n.enableBiometricFailed('$e'));
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _saveAndClose({required bool enable}) async {
    final storage = SecureStorage();
    await storage.write('biometricEnabled', enable.toString());
    await storage.write('biometricFingerprint', _fingerprint.toString());
    await storage.write('biometricFace', _face.toString());
    if (!mounted) return;
    context.go('/join-group');
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: BasePageWithToolbar(
        title: l10n.enableBiometricTitle,
        subtitle: l10n.enableBiometricSubtitle,
        showBackButton: true,
        stickChildrenToBottom: true,
        children: [
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20.w,
            children: [
              CustomImageChip(
                selected: _fingerprint,
                onTap: _toggleFingerprint,
                assetPath: 'assets/images/ic_fingerprint_id.png',
                size: 64.h,
              ),
              CustomImageChip(
                selected: _face,
                onTap: _toggleFace,
                assetPath: 'assets/images/ic_face_id.png',
                size: 64.h,
              ),
            ],
          ),
          SizedBox(height: 64.h),
          Column(
            children: [
              ActionButtonWidget(
                text: l10n.enableBiometricEnable,
                onPressed: _enableWithAuth,
                loading: _saving,
              ),
              SizedBox(height: 12.h),
              ActionTextButtonWidget(
                onPressed: _saving ? null : () => _skipBiometric(l10n),
                text: l10n.enableBiometricNotNow,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomImageChip extends StatelessWidget {
  final bool selected;
  final VoidCallback onTap;
  final String assetPath;
  final double size;

  const CustomImageChip({
    super.key,
    required this.selected,
    required this.onTap,
    required this.assetPath,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor =
        selected ? AppColors.surfacePrimary(context) : Colors.transparent;

    final borderColor =
        selected ? AppColors.borderFocused(context) : Colors.transparent;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.w),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              assetPath,
              width: size,
              height: size,
            ),
          ],
        ),
      ),
    );
  }
}
