import 'dart:io';

import 'package:academy_2_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../app/theme/theme.dart';
import '../core/settings/settings_provider.dart';
import 'router.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
