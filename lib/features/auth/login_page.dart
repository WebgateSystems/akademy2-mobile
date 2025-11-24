import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../l10n/app_localizations.dart';
import '../../core/auth/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, this.redirect});

  final String? redirect;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();

  @override
  void dispose() {
    _emailCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  void _login() async {
    try {
      FocusScope.of(context).unfocus();
      final email =
          _emailCtl.text.isEmpty ? 'test@example.com' : _emailCtl.text.trim();
      final password = _passCtl.text.isEmpty ? 'pass' : _passCtl.text.trim();

      await ref.read(authProvider.notifier).login(email, password);

      if (mounted) {
        final target =
            (widget.redirect?.isNotEmpty ?? false) ? widget.redirect! : '/home';
        context.go(target);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authState = ref.watch(authProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.loginTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailCtl,
              decoration: InputDecoration(labelText: l10n.emailField),
              enabled: !isLoading,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passCtl,
              decoration: InputDecoration(labelText: l10n.passwordField),
              obscureText: true,
              enabled: !isLoading,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text(l10n.loginTitle),
                  ),
            const SizedBox(height: 12),
            const Text('Try test@example.com / pass'),
          ],
        ),
      ),
    );
  }
}
