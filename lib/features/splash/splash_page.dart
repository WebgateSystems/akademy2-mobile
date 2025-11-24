import 'dart:async';

import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/urls.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;
  bool _logoTapped = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), _goNext);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _goNext() {
    if (_navigated) return;
    _navigated = true;
    if (!mounted) return;
    context.go('/create-account');
  }

  Future<void> _onLogoTap() async {
    _timer?.cancel();
    setState(() {
      _logoTapped = true;
    });

    final uri = Uri.parse(AppLinks.landing);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open link')),
        );
      }
    }
  }

  Future<void> _onMinLogoTap() async {
    _timer?.cancel();
    setState(() {
      _logoTapped = true;
    });

    final uri = Uri.parse(AppLinks.minLanding);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open link')),
        );
      }
    }
  }

  Future<void> _onWSLogoTap() async {
    _timer?.cancel();
    setState(() {
      _logoTapped = true;
    });

    final uri = Uri.parse(AppLinks.wsLanding);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open link')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 140.h),
                  child: GestureDetector(
                    onTap: _onLogoTap,
                    child: Image.asset(
                      'assets/images/logo.png',
                      width: 147.w,
                      height: 147.w,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  AppLocalizations.of(context)?.appTitle ?? 'Academy 2.0',
                  style: AppTextStyles.H1.copyWith(
                    color: theme.textTheme.bodyMedium?.color,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 161.h),
                  child: GestureDetector(
                    onTap: _onMinLogoTap,
                    child: Image.asset(
                      'assets/images/min_logo.png',
                      width: 287.w,
                      height: 100.w,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 23.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: _onWSLogoTap,
                        child: Image.asset(
                          'assets/images/ws_logo.png',
                          width: 40.w,
                          height: 38.w,
                        ),
                      ),
                      SizedBox(
                        width: 200.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (_logoTapped)
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(top: 48.h, right: 16.w),
                  child: IconButton(
                    icon: Image.asset('assets/images/ic_close.png',
                        color: theme.textTheme.bodyMedium?.color,
                        width: 20.w,
                        height: 20.w),
                    onPressed: _goNext,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
