import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/action_textbutton_widget.dart';
import 'package:academy_2_app/app/view/circular_progress_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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

class _UnlockPageState extends ConsumerState<UnlockPage>
    with WidgetsBindingObserver {
  final _localAuth = LocalAuthentication();
  String _current = '';
  String? _storedPin;
  String? _phone;
  bool _mismatch = false;
  bool _submitting = false;
  bool _biometricEnabled = false;
  bool _biometricAttempted = false;
  bool _biometricInProgress = false;
  bool _appWasPaused = false;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadPreferences();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    try {
      final storage = SecureStorage();
      final storedPin = (await storage.read('userPin'))?.trim();
      final phone = await storage.read('phone');
      final biometricFlag = (await storage.read('biometricEnabled')) == 'true';

      if (!mounted) return;
      setState(() {
        _storedPin = storedPin;
        _phone = phone;
        _biometricEnabled = biometricFlag;
        _ready = true;
      });

      if ((storedPin == null || storedPin.isEmpty) && mounted) {
        ref.read(authProvider.notifier).markUnlocked();
        final target =
            (widget.redirect?.isNotEmpty ?? false) ? widget.redirect! : '/home';
        context.go(target);
        return;
      }
      _scheduleBiometricAttempt();
    } catch (_) {
      if (mounted) {
        setState(() => _ready = true);
      }
    }
  }

  void _scheduleBiometricAttempt() {
    if (!_biometricEnabled || _biometricAttempted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_biometricEnabled || _biometricAttempted) return;
      _tryBiometric();
    });
  }

  Future<void> _tryBiometric({bool fromButton = false}) async {
    if ((!fromButton && _biometricAttempted) || !_biometricEnabled) return;
    _biometricAttempted = true;
    if (mounted) {
      setState(() => _biometricInProgress = true);
    }
    try {
      final supported = await _localAuth.isDeviceSupported();
      final canCheck = await _localAuth.canCheckBiometrics;
      if (!supported || !canCheck) return;
      final success = await _localAuth.authenticate(
        localizedReason: 'Unlock with biometrics',
      );
      if (success && mounted) {
        await _finishUnlock();
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() => _biometricInProgress = false);
      }
    }
  }

  void _handleBiometricTap() async {
    if (_submitting || !_ready) return;
    if (!_biometricEnabled) {
      if (!mounted) return;
      context.go('/enable-biometric', extra: _redirectTarget());
      return;
    }
    await _tryBiometric(fromButton: true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _appWasPaused = true;
      return;
    }
    if (state == AppLifecycleState.resumed &&
        _appWasPaused &&
        _biometricEnabled &&
        mounted &&
        !_submitting) {
      _appWasPaused = false;
      _biometricAttempted = false;
      _scheduleBiometricAttempt();
    }
  }

  String _redirectTarget() {
    final targetRaw =
        (widget.redirect?.isNotEmpty ?? false) ? widget.redirect! : '/home';
    return targetRaw == '/unlock' || targetRaw.isEmpty ? '/home' : targetRaw;
  }

  void _handleKey(String value) async {
    if (_submitting || !_ready) return;
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
      if (_current.trim() == _storedPin!.trim()) {
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
    context.go(_redirectTarget());
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
    final maxBiometricLabelWidth = MediaQuery.of(context).size.width - 80.w;
    if (!_ready) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        PinScaffold(
          title: l10n.unlockPinTitle,
          subtitle: l10n.unlockPinSubtitle(phoneLabel),
          pin: _current,
          onKey: _handleKey,
          mismatch: _mismatch,
          showProgress: _submitting,
          showBackButton: false,
          showBiometricKey: true,
          onBiometricTap: _handleBiometricTap,
          footer: Column(
            children: [
              ActionTextButtonWidget(
                onPressed: _submitting ? null : _logout,
                text: l10n.useAnotherAccount,
              ),
            ],
          ),
        ),
        if (_biometricInProgress)
          Positioned.fill(
            child: AbsorbPointer(
              absorbing: true,
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressWidget(),
                      SizedBox(height: 12.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(maxWidth: maxBiometricLabelWidth),
                          child: Text(
                            l10n.unlockBiometricWaiting,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.b2(context).copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
