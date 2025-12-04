import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
import 'package:academy_2_app/app/view/edit_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_provider.dart';
import '../../core/network/dio_provider.dart';

/// Тимчасовий технічний екран для логіну по email/password, щоб отримати токен.
class TechLoginPage extends ConsumerStatefulWidget {
  const TechLoginPage({super.key});

  @override
  ConsumerState<TechLoginPage> createState() => _TechLoginPageState();
}

class _TechLoginPageState extends ConsumerState<TechLoginPage> {
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtl.dispose();
    _passCtl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailCtl.text.trim();
    final pass = _passCtl.text.trim();
    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email і пароль обов’язкові')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      final dio = ref.read(dioProvider);
      final resp = await dio.post(
        'v1/session',
        data: {
          'user': {'email': email, 'password': pass}
        },
      );
      final access = resp.data['access_token'] as String?;
      final data = resp.data['data'] as Map<String, dynamic>?;
      final attrs = data?['attributes'] as Map<String, dynamic>?;
      final userId = attrs?['id'] as String? ?? data?['id'] as String? ?? email;
      if (access != null) {
        final notifier = ref.read(authProvider.notifier);
        await notifier.setTokens(access, userId: userId, refreshToken: null);
        await notifier.saveUserProfile(
          attrs,
          email: attrs?['email'] as String? ?? email,
          phone: attrs?['phone'] as String?,
        );
        if (mounted) context.go('/home');
        return;
      }
      throw Exception('access_token missing');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BasePageWithToolbar(
        showBackButton: false,
        stickChildrenToBottom: true,
        title: 'Tech Login',
        children: [
          SizedBox(height: 16.h),
          EditTextWidget(
            controller: _emailCtl,
            label: 'Email',
          ),
          SizedBox(height: 16.h),
          EditTextWidget(
            controller: _passCtl,
            label: 'Password',
            obscureText: true,
          ),
          SizedBox(height: 16.h),
          ActionButtonWidget(
            onPressed: _login,
            text: 'Log in',
            loading: _loading,
          ),
        ],
      ),
    );
  }
}
