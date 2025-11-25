import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/storage/secure_storage.dart';
import 'auth_flow_models.dart';

class CreatePinPage extends StatefulWidget {
  const CreatePinPage({super.key});

  @override
  State<CreatePinPage> createState() => _CreatePinPageState();
}

class _CreatePinPageState extends State<CreatePinPage> {
  String _current = '';

  void _handleKey(String value) {
    if (value == 'back') {
      if (_current.isNotEmpty) {
        setState(() => _current = _current.substring(0, _current.length - 1));
      }
      return;
    }

    if (_current.length >= 4) return;
    setState(() => _current += value);
    if (_current.length == 4) {
      context.go('/confirm-pin', extra: ConfirmPinArgs(pin: _current));
    }
  }

  @override
  Widget build(BuildContext context) {
    return PinScaffold(
      title: 'Come up with a 4-digit code',
      subtitle:
          'This code will be needed to log in to the Academy 2.0 application.',
      pin: _current,
      onKey: _handleKey,
    );
  }
}

class ConfirmPinPage extends StatefulWidget {
  const ConfirmPinPage({super.key, required this.args});

  final ConfirmPinArgs args;

  @override
  State<ConfirmPinPage> createState() => _ConfirmPinPageState();
}

class _ConfirmPinPageState extends State<ConfirmPinPage> {
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
      await SecureStorage().write('userPin', _current);
      if (!mounted) return;
      context.go('/join-group');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PinScaffold(
      title: 'Repeat a 4-digit code',
      subtitle:
          _mismatch ? 'Pins do not match. Try again.' : 'Confirm your code.',
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
  });

  final String title;
  final String subtitle;
  final String pin;
  final bool mismatch;
  final bool showProgress;
  final void Function(String value) onKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BasePageWithToolbar(
        title: title,
        subtitle: subtitle,
        showBackButton: true,
        children: [
          SizedBox(height: 56.h),
          DotsWidget(pin: pin),
          if (mismatch) SizedBox(height: 16.h),
          if (mismatch)
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pins do not match',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.b2(context).copyWith(
                    color: AppColors.contentError(context),
                  ),
                ),
              ],
            ),
          SizedBox(height: 101.h),
          if (showProgress) const CircularProgressIndicator(),
          if (!showProgress)
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _PinKeypad(onKey: onKey),
              ],
            ),
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
              ? RoundButton(
                  size: 72.r,
                  onTap: () => onKey('back'),
                  backgroundColor: Colors.transparent,
                  splashColor: AppColors.green40,
                  child: Image.asset(
                    'assets/images/ic_back_button.png',
                    width: 34.w,
                    height: 24.h,
                  ),
                )
              : RoundButton(
                  size: 72.r,
                  onTap: () => onKey(key),
                  backgroundColor: AppColors.blue10,
                  splashColor: AppColors.green40,
                  child: Text(
                    key,
                    style: AppTextStyles.h1(context),
                  ),
                );
        },
      ),
    );
  }
}

class RoundButton extends StatelessWidget {
  final double size;
  final VoidCallback onTap;
  final Widget child;
  final Color backgroundColor;
  final Color splashColor;
  final Color? borderColor;
  final double borderWidth;

  const RoundButton({
    super.key,
    required this.onTap,
    required this.child,
    this.size = 72, // діаметр кнопки
    this.backgroundColor = Colors.white,
    this.splashColor = Colors.black26, // колір кліку
    this.borderColor,
    this.borderWidth = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Material(
        color: backgroundColor,
        shape: CircleBorder(
          side: borderWidth > 0
              ? BorderSide(
                  color: borderColor ?? Colors.black, width: borderWidth)
              : BorderSide.none,
        ),
        child: InkWell(
          customBorder: const CircleBorder(),
          splashColor: splashColor,
          onTap: onTap,
          child: Center(child: child),
        ),
      ),
    );
  }
}
