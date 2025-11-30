import 'package:academy_2_app/app/view/action_textbutton_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';

import '../../core/auth/auth_provider.dart';
import '../../core/storage/secure_storage.dart';
import '../../l10n/app_localizations.dart';
import 'pin_pages.dart';

class UnlockPage extends ConsumerStatefulWidget {
  const UnlockPage({super.key, this.redirect});

  final String? redirect;

  @override
  ConsumerState<UnlockPage> createState() => _UnlockPageState();
}

class _UnlockPageState extends ConsumerState<UnlockPage> {
  final _localAuth = LocalAuthentication();
  String _current = '';
  String? _storedPin;
  String? _phone;
  bool _mismatch = false;
  bool _submitting = false;
  bool _biometricEnabled = false;
  bool _biometricAttempted = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final storage = SecureStorage();
    final storedPin = await storage.read('userPin');
    final phone = await storage.read('phone');
    final biometricFlag = (await storage.read('biometricEnabled')) == 'true';

    if (!mounted) return;
    setState(() {
      _storedPin = storedPin;
      _phone = phone;
      _biometricEnabled = biometricFlag;
    });

    if ((storedPin == null || storedPin.isEmpty) && mounted) {
      ref.read(authProvider.notifier).markUnlocked();
      final target =
          (widget.redirect?.isNotEmpty ?? false) ? widget.redirect! : '/home';
      context.go(target);
      return;
    }

    if (biometricFlag) {
      await _tryBiometric();
    }
  }

  Future<void> _tryBiometric() async {
    if (_biometricAttempted || !_biometricEnabled) return;
    _biometricAttempted = true;
    try {
      final supported = await _localAuth.isDeviceSupported();
      final canCheck = await _localAuth.canCheckBiometrics;
      if (!supported || !canCheck) return;
      final success = await _localAuth.authenticate(
        localizedReason: 'Unlock with biometrics',
        options: const AuthenticationOptions(biometricOnly: true),
      );
      if (success && mounted) {
        await _finishUnlock();
      }
    } catch (_) {
      // ignore biometric errors; user can fallback to PIN
    }
  }

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
    if (_storedPin == null || _storedPin!.isEmpty) {
      if (mounted) context.go('/login');
      return;
    }

    setState(() {
      _submitting = true;
      _mismatch = false;
    });
    try {
      if (_current == _storedPin) {
        await _finishUnlock();
        return;
      }
      if (mounted) {
        setState(() {
          _mismatch = true;
          _current = '';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _submitting = false);
      }
    }
  }

  Future<void> _finishUnlock() async {
    ref.read(authProvider.notifier).markUnlocked();
    if (!mounted) return;
    final target =
        (widget.redirect?.isNotEmpty ?? false) ? widget.redirect! : '/home';
    context.go(target);
  }

  Future<void> _logout() async {
    await ref.read(authProvider.notifier).logout();
    if (!mounted) return;
    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final phoneLabel = _phone ?? '';
    return PinScaffold(
      title: l10n.unlockPinTitle,
      subtitle: l10n.unlockPinSubtitle(phoneLabel),
      pin: _current,
      onKey: _handleKey,
      mismatch: _mismatch,
      showProgress: _submitting,
      showBackButton: false,
      footer: Column(
        children: [
          ActionTextButtonWidget(
            onPressed: _submitting ? null : _logout,
            text: l10n.useAnotherAccount,
          ),
        ],
      ),
    );
  }
}
