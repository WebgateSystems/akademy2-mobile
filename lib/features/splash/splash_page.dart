import 'dart:async';

import 'package:academy_2_app/app/theme/tokens.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.blue05,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Spacer(),
                    GestureDetector(
                      onTap: _onLogoTap,
                      child: Image.asset(
                        'assets/images/logo_full.png',
                        width: 265.w,
                        height: 120.w,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: _onLogoTap,
                      child: Image.asset(
                        'assets/images/min_logo.png',
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          GestureDetector(
                            onTap: _onLogoTap,
                            child: Image.asset(
                              'assets/images/logo_enchanced.png',
                              width: 90.w,
                              height: 90.w,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: _onLogoTap,
                            child: Image.asset(
                              'assets/images/logo4.png',
                              width: 110.w,
                              height: 110.w,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: _onLogoTap,
                            child: Image.asset(
                              'assets/images/logo8.png',
                              width: 90.w,
                              height: 90.w,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.h, bottom: 10.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          GestureDetector(
                            onTap: _onLogoTap,
                            child: Image.asset(
                              'assets/images/ws_logo.png',
                              width: 118.w,
                              height: 22.w,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: _onLogoTap,
                            child: Image.asset(
                              'assets/images/logo6.png',
                              width: 90.w,
                              height: 90.w,
                            ),
                          ),
                          Spacer(),
                          GestureDetector(
                            onTap: _onLogoTap,
                            child: Image.asset(
                              'assets/images/securhub.png',
                              width: 118.w,
                              height: 72.w,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
