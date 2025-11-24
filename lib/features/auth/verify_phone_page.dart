import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'auth_flow_models.dart';

class VerifyPhonePage extends StatefulWidget {
  const VerifyPhonePage({super.key, required this.args});

  final VerifyPhoneArgs args;

  @override
  State<VerifyPhonePage> createState() => _VerifyPhonePageState();
}

class _VerifyPhonePageState extends State<VerifyPhonePage> {
  final _controllers = List.generate(4, (_) => TextEditingController());
  final _focusNodes = List.generate(4, (_) => FocusNode());
  bool _invalid = false;
  bool _loading = false;
  int _resendSeconds = 59;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _resendSeconds = 59;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds == 0) {
        timer.cancel();
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  String get _code => _controllers.map((c) => c.text).join();

  Future<void> _verify() async {
    if (_code.length != 4 || !_code.contains(RegExp(r'^\d{4}$'))) {
      setState(() => _invalid = true);
      return;
    }
    setState(() {
      _invalid = false;
      _loading = true;
    });
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    context.go('/verify-email', extra: widget.args.email);
  }

  void _resend() {
    for (final c in _controllers) {
      c.clear();
    }
    _startTimer();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Code resent')),
    );
  }

  void _onDigitChanged(int index, String value) {
    if (value.length > 1) {
      _controllers[index].text = value.substring(0, 1);
      _controllers[index].selection = const TextSelection.collapsed(offset: 1);
    }
    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final phone = widget.args.phone;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Verify your phone number',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'We sent a 4-digit code on your phone\n$phone.',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_controllers.length, (index) {
                return SizedBox(
                  width: 64,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    onChanged: (v) => _onDigitChanged(index, v),
                    decoration: const InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 12),
            if (_invalid)
              const Text(
                'Invalid verification code. Resend a new one?',
                style: TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton(
                  onPressed: _resendSeconds == 0 ? _resend : null,
                  child: Text(
                    _resendSeconds == 0
                        ? 'Resend'
                        : 'Resend (in 0:${_resendSeconds.toString().padLeft(2, '0')})',
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: _code.length == 4 && !_loading ? _verify : null,
                  child: _loading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Verify'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
