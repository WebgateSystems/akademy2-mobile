import 'package:flutter/material.dart';
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
      subtitle: _mismatch ? 'Pins do not match. Try again.' : 'Confirm your code.',
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
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                final filled = index < pin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: filled ? Colors.black : Colors.transparent,
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                );
              }),
            ),
            if (mismatch)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  'Pins do not match',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            const Spacer(),
            if (showProgress) const CircularProgressIndicator(),
            if (!showProgress) _PinKeypad(onKey: onKey),
          ],
        ),
      ),
    );
  }
}

class _PinKeypad extends StatelessWidget {
  const _PinKeypad({required this.onKey});

  final void Function(String value) onKey;

  @override
  Widget build(BuildContext context) {
    final keys = [
      '1', '2', '3',
      '4', '5', '6',
      '7', '8', '9',
      '', '0', 'back',
    ];
    return SizedBox(
      height: 320,
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
          return ElevatedButton(
            onPressed: () => onKey(key),
            child: key == 'back'
                ? const Icon(Icons.backspace_outlined)
                : Text(
                    key,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
          );
        },
      ),
    );
  }
}
