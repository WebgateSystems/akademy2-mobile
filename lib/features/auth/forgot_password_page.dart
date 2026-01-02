import 'package:academy_2_app/app/view/action_button_widget.dart';
import 'package:academy_2_app/app/view/action_textbutton_widget.dart';
import 'package:academy_2_app/app/view/base_page_with_toolbar.dart';
import 'package:academy_2_app/app/view/edit_text_widget.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../core/network/api_endpoints.dart';
import '../../core/network/dio_provider.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailCtl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtl.dispose();
    super.dispose();
  }

  Future<void> _sendForgotPasswordRequest() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailCtl.text.trim();
    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.emailRequired)),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      final dio = ref.read(dioProvider);
      final resp = await dio.post(
        ApiEndpoints.forgotPassword,
        data: {
          'user[email]': email,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );
      final code = resp.statusCode;
      final message = _extractMessage(resp.data);
      if (code == 200) {
        if (mounted) {
          if (message != null && message.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
          context.go('/login');
        }
        return;
      }
      throw Exception(message ?? 'Request failed with status code $code');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Forgot password request failed: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _extractMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final msg = data['message'];
      if (msg is String && msg.isNotEmpty) return msg;
    } else if (data is String && data.isNotEmpty) {
      return data;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: BasePageWithToolbar(
        showBackButton: false,
        stickChildrenToBottom: true,
        title: l10n.forgotPasswordTitle,
        subtitle: l10n.forgotPasswordSubtitle,
        children: [
          SizedBox(height: 16.h),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: EditTextWidget(
                controller: _emailCtl,
                label: l10n.forgotPasswordEmailField,
                hint: l10n.emailHintField,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          ActionButtonWidget(
            onPressed: _sendForgotPasswordRequest,
            text: l10n.forgotPasswordSendButton,
            loading: _loading,
          ),
          SizedBox(height: 6.h),
          ActionTextButtonWidget(
            onPressed: () => context.go('/login'),
            text: l10n.forgotPasswordBackToLogin,
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}
