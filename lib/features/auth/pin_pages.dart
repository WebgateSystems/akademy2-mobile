import 'dart:async';

import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
import 'package:academy_2_app/app/view/circular_progress_widget.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_provider.dart';
import '../../core/network/dio_provider.dart';
import '../../core/storage/secure_storage.dart';
import 'auth_flow_models.dart';

class CreatePinPage extends ConsumerStatefulWidget {
  const CreatePinPage({super.key, required this.flowId});

  final String flowId;

  @override
  ConsumerState<CreatePinPage> createState() => _CreatePinPageState();
}

class _CreatePinPageState extends ConsumerState<CreatePinPage> {
  String _current = '';
  bool _saving = false;

  void _handleKey(String value) async {
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
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final dio = ref.read(dioProvider);
      await dio.post(
        'v1/register/set_pin',
        data: {
          'flow_id': widget.flowId,
          'pin': _current,
        },
      );
      if (!mounted) return;
      context.push(
        '/confirm-pin',
        extra: ConfirmPinArgs(pin: _current, flowId: widget.flowId),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _current = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to set PIN')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PinScaffold(
      title: l10n.pinCreateTitle,
      subtitle: l10n.pinCreateSubtitle,
      pin: _current,
      onKey: _handleKey,
      showProgress: _saving,
    );
  }
}

class ConfirmPinPage extends ConsumerStatefulWidget {
  const ConfirmPinPage({super.key, required this.args});

  final ConfirmPinArgs args;

  @override
  ConsumerState<ConfirmPinPage> createState() => _ConfirmPinPageState();
}

class _ConfirmPinPageState extends ConsumerState<ConfirmPinPage> {
  String _current = '';
  bool _mismatch = false;
  bool _saving = false;

  void _handleKey(String value) async {
    if (value == 'back') {
      if (_current.isNotEmpty) {
        setState(() => _current = _current.substring(0, _current.length - 1));
      }
      return;
    }

    if (_current.length >= 4) return;
    setState(() => _current += value);
    if (_current.length == 4) {
      if (_current != widget.args.pin) {
        setState(() {
          _mismatch = true;
          _current = '';
        });
        return;
      }
      setState(() {
        _mismatch = false;
        _saving = true;
      });
      await _confirmPin();
    }
  }

  Future<void> _confirmPin() async {
    try {
      final dio = ref.read(dioProvider);
      final resp = await dio.post(
        'v1/register/confirm_pin',
        data: {
          'flow_id': widget.args.flowId,
          'pin': _current,
        },
      );

      final accessToken = resp.data['access_token'] as String?;
      final data = resp.data['data'] as Map<String, dynamic>?;
      final attributes = data?['attributes'] as Map<String, dynamic>?;
      final userId =
          attributes?['id'] as String? ?? data?['id'] as String? ?? 'me';

      if (accessToken != null) {
        await SecureStorage().write('userPin', _current);
        await ref
            .read(authProvider.notifier)
            .setTokens(accessToken, userId: userId);
        if (!mounted) return;
        context.go('/join-group');
        return;
      }
      throw Exception('No access token');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to confirm PIN: $e')),
      );
      setState(() {
        _current = '';
      });
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return PinScaffold(
      title: l10n.pinConfirmTitle,
      subtitle:
          _mismatch ? l10n.pinConfirmMismatchSubtitle : l10n.pinConfirmSubtitle,
      pin: _current,
      onKey: _handleKey,
      mismatch: _mismatch,
      showProgress: _saving,
    );
  }
}

class PinScaffold extends StatelessWidget {
  const PinScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.pin,
    required this.onKey,
    this.mismatch = false,
    this.showProgress = false,
    this.showBackButton = true,
    this.footer,
    this.errorMessage,
  });

  final String title;
  final String subtitle;
  final String pin;
  final bool mismatch;
  final bool showProgress;
  final void Function(String value) onKey;
  final bool showBackButton;
  final Widget? footer;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasError =
        mismatch || (errorMessage != null && errorMessage!.isNotEmpty);
    return Scaffold(
      body: BasePageWithToolbar(
        title: title,
        subtitle: subtitle,
        showBackButton: showBackButton,
        children: [
          SizedBox(height: 56.h),
          DotsWidget(pin: pin),
          if (hasError) SizedBox(height: 16.h),
          if (hasError)
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    errorMessage ?? l10n.pinMismatchInline,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.b2(context).copyWith(
                      color: AppColors.contentError(context),
                    ),
                  ),
                ),
              ],
            ),
          SizedBox(height: 101.h),
          if (showProgress) Center(child: const CircularProgressWidget()),
          if (!showProgress)
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _PinKeypad(onKey: onKey),
              ],
            ),
          if (footer != null) SizedBox(height: 24.h),
          if (footer != null) footer!,
        ],
      ),
    );
  }
}

class DotsWidget extends StatelessWidget {
  const DotsWidget({
    super.key,
    required this.pin,
  });

  final String pin;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        final filled = index < pin.length;
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10.w),
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? AppColors.blue30 : Colors.transparent,
            border: Border.all(color: AppColors.blue30, width: 2.w),
          ),
        );
      }),
    );
  }
}

class _PinKeypad extends StatelessWidget {
  const _PinKeypad({required this.onKey});

  final void Function(String value) onKey;

  @override
  Widget build(BuildContext context) {
    final keys = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '',
      '0',
      'back',
    ];
    return SizedBox(
      width: 280.w,
      height: 384.h,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: keys.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (context, index) {
          final key = keys[index];
          if (key.isEmpty) {
            return const SizedBox.shrink();
          }
          return key == 'back'
              ? RoundButton.image(
                  size: 72.r,
                  onTap: () => onKey('back'),
                  backgroundColor: Colors.transparent,
                  splashColor: AppColors.surfaceAccent(context),
                  assetImage: Theme.of(context).brightness == Brightness.dark
                      ? 'assets/images/ic_back_button_dark.png'
                      : 'assets/images/ic_back_button.png',
                  pressedImageOpacity: 0.5,
                )
              : RoundButton.text(
                  size: 72.r,
                  onTap: () => onKey(key),
                  backgroundColor: AppColors.surfaceActive(context),
                  splashColor: AppColors.surfaceAccent(context),
                  textColor: AppColors.contentPrimary(context),
                  pressedTextColor: AppColors.background(context),
                  text: key,
                );
        },
      ),
    );
  }
}

class RoundButton extends StatefulWidget {
  final double size;
  final VoidCallback onTap;

  // Випадок 1: текст
  final String? text;
  final Color textColor;
  final Color pressedTextColor;

  // Випадок 2: картинка
  final String? assetImage;
  final double pressedImageOpacity;

  final Color backgroundColor;
  final Color splashColor;
  final Color? borderColor;
  final double borderWidth;

  const RoundButton._internal({
    super.key,
    required this.onTap,
    required this.size,
    required this.backgroundColor,
    required this.splashColor,
    required this.borderColor,
    required this.borderWidth,
    this.text,
    this.textColor = Colors.black,
    this.pressedTextColor = Colors.red,
    this.assetImage,
    this.pressedImageOpacity = 0.6,
  }) : assert(
          (text != null && assetImage == null) ||
              (text == null && assetImage != null),
          'Або text, або assetImage, але не обидва одночасно',
        );

  /// Конструктор для текстової кнопки
  factory RoundButton.text({
    Key? key,
    required VoidCallback onTap,
    required String text,
    double size = 72,
    Color? textColor,
    Color? pressedTextColor,
    Color backgroundColor = Colors.white,
    Color splashColor = Colors.black26,
    Color? borderColor,
    double borderWidth = 0,
  }) {
    return RoundButton._internal(
      key: key,
      onTap: onTap,
      size: size,
      backgroundColor: backgroundColor,
      splashColor: splashColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      text: text,
      textColor: textColor ?? Colors.black,
      pressedTextColor: pressedTextColor ?? Colors.white,
    );
  }

  /// Конструктор для кнопки з картинкою
  factory RoundButton.image({
    Key? key,
    required VoidCallback onTap,
    required String assetImage,
    double size = 72,
    double pressedImageOpacity = 0.6,
    Color backgroundColor = Colors.white,
    Color splashColor = Colors.black26,
    Color? borderColor,
    double borderWidth = 0,
  }) {
    return RoundButton._internal(
      key: key,
      onTap: onTap,
      size: size,
      backgroundColor: backgroundColor,
      splashColor: splashColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      assetImage: assetImage,
      pressedImageOpacity: pressedImageOpacity,
    );
  }

  @override
  State<RoundButton> createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  bool _pressed = false;
  Timer? _pressResetTimer;

  @override
  void dispose() {
    _pressResetTimer?.cancel();
    super.dispose();
  }

  void _setPressed(bool value) {
    if (value) {
      _pressResetTimer?.cancel();
      _pressResetTimer = null;
      if (!_pressed) {
        setState(() => _pressed = true);
      }
      return;
    }

    _pressResetTimer?.cancel();
    _pressResetTimer = Timer(const Duration(milliseconds: 120), () {
      if (!mounted) return;
      setState(() => _pressed = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Material(
        color: widget.backgroundColor,
        shape: CircleBorder(
          side: widget.borderWidth > 0
              ? BorderSide(
                  color: widget.borderColor ?? Colors.black,
                  width: widget.borderWidth,
                )
              : BorderSide.none,
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          splashColor: widget.splashColor,
          onTap: widget.onTap,
          onHighlightChanged: _setPressed,
          child: Center(
            child: _buildChild(),
          ),
        ),
      ),
    );
  }

  Widget _buildChild() {
    if (widget.text != null) {
      // Випадок з текстом: змінюємо колір
      return AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 120),
        style: AppTextStyles.h1(context).copyWith(
          color: _pressed ? widget.pressedTextColor : widget.textColor,
        ),
        child: Text(widget.text!),
      );
    } else if (widget.assetImage != null) {
      // Випадок з картинкою: змінюємо прозорість
      return AnimatedOpacity(
        duration: const Duration(milliseconds: 120),
        opacity: _pressed ? widget.pressedImageOpacity : 1.0,
        child: Image.asset(widget.assetImage!, width: 34.w, height: 24.h),
      );
    }

    return const SizedBox.shrink();
  }
}
