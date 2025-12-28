import 'dart:async';

import 'package:academy_2_app/app/theme/tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/auth/auth_provider.dart';
import '../../core/constants/urls.dart';
import '../shared/parental_gate_dialog.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
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
    final auth = ref.read(authProvider);
    if (auth.isAuthenticated) {
      if (!auth.isUnlocked) {
        context.go('/unlock');
        return;
      }
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  Future<void> _onLogoTap() async {
    _timer?.cancel();

    final approved = await ParentalGateDialog.show(context);
    if (!mounted || !approved) {
      if (!_navigated) {
        _timer = Timer(const Duration(seconds: 2), _goNext);
      }
      return;
    }

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
    bool isTablet = MediaQuery.sizeOf(context).width > 800;

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
                        width: 265.r,
                        height: 120.r,
                      ),
                    ),
                    Spacer(),
                    isTablet ? _getLogosForTablet() : _getLogosForPhone(),
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
                        width: 20.r,
                        height: 20.r),
                    onPressed: _goNext,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _logoImage(String asset,
      {double? width, double? height, BoxFit fit = BoxFit.contain}) {
    return Image.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => SizedBox(
        width: width ?? height ?? 80.r,
        height: height ?? 40.r,
      ),
    );
  }

  Column _getLogosForPhone() {
    return Column(
      children: [
        GestureDetector(
          onTap: _onLogoTap,
          child: _logoImage(
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
                child: _logoImage(
                  'assets/images/logo_enchanced.png',
                  width: 90.r,
                  height: 90.r,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: _onLogoTap,
                child: _logoImage(
                  'assets/images/logo4.png',
                  width: 110.r,
                  height: 110.r,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: _onLogoTap,
                child: _logoImage(
                  'assets/images/logo8.png',
                  width: 90.r,
                  height: 90.r,
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
                child: _logoImage(
                  'assets/images/ws_logo.png',
                  width: 118.r,
                  height: 22.r,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: _onLogoTap,
                child: _logoImage(
                  'assets/images/logo6.png',
                  width: 90.r,
                  height: 90.r,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: _onLogoTap,
                child: _logoImage(
                  'assets/images/securhub.png',
                  width: 118.r,
                  height: 72.r,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getLogosForTablet() {
    Widget logo(String asset, {double? width, double? height}) {
      return GestureDetector(
        onTap: _onLogoTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          child: _logoImage(asset, width: width, height: height),
        ),
      );
    }

    return SizedBox(
      width: double.infinity,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            logo('assets/images/min_logo.png', height: 90.r),
            SizedBox(width: 12.w),
            logo('assets/images/logo_enchanced.png', width: 90.r, height: 90.r),
            SizedBox(width: 12.w),
            logo('assets/images/logo4.png', width: 110.r, height: 110.r),
            SizedBox(width: 12.w),
            logo('assets/images/logo8.png', width: 90.r, height: 90.r),
            SizedBox(width: 12.w),
            logo('assets/images/ws_logo.png', width: 118.r, height: 22.r),
            SizedBox(width: 12.w),
            logo('assets/images/logo6.png', width: 90.r, height: 90.r),
            SizedBox(width: 12.w),
            logo('assets/images/securhub.png', width: 118.r, height: 72.r),
          ],
        ),
      ),
    );
  }
}
