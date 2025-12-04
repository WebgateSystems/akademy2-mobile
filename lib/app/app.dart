import 'dart:io';

import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/theme/theme.dart';
import '../core/auth/auth_provider.dart';
import '../core/settings/settings_provider.dart';
import 'router.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});

  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> with WidgetsBindingObserver {
  bool _wasBackgrounded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = ref.read(authProvider);
      if (auth.isAuthenticated && !auth.isUnlocked) {
        final router = ref.read(routerProvider);
        router.go(
          Uri(path: '/unlock', queryParameters: {'redirect': '/home'}).toString(),
        );
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.hidden) {
      _wasBackgrounded = true;
    }

    if (state == AppLifecycleState.resumed) {
      final auth = ref.read(authProvider);
      final shouldUnlock = auth.isAuthenticated &&
          (_wasBackgrounded || !auth.isUnlocked);
      if (shouldUnlock) {
        ref.read(authProvider.notifier).requireUnlock();
        final router = ref.read(routerProvider);
        var redirectTo = '/home';
        try {
          final current = router.routerDelegate.currentConfiguration.fullPath;
          redirectTo = current == '/unlock' || current.isEmpty ? '/home' : current;
        } catch (_) {
          redirectTo = router.routeInformationProvider.value.uri.toString();
        }
        router.go(Uri(path: '/unlock', queryParameters: {
          'redirect': redirectTo,
        }).toString());
      }
      _wasBackgrounded = false;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(routerProvider);
    final settings = ref.watch(settingsProvider);
    return ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: false,
        builder: (context, child) {
          return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: !Platform.isAndroid,
            removeLeft: true,
            removeRight: true,
            child: MediaQuery.withNoTextScaling(
              child: MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Academy 2.0',
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: settings.themeMode,
                locale: settings.locale,
                routerConfig: router,
                onGenerateTitle: (context) =>
                    AppLocalizations.of(context)?.appTitle ?? 'Academy 2.0',
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: AppLocalizations.supportedLocales,
              ),
            ),
          );
        });
  }
}
