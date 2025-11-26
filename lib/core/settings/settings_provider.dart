import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../storage/secure_storage.dart';

class SettingsState {
  const SettingsState({
    required this.themeMode,
    required this.languageCode,
    this.locale,
    this.loading = false,
  });

  final ThemeMode themeMode;
  final String languageCode;
  final Locale? locale;
  final bool loading;

  SettingsState copyWith({
    ThemeMode? themeMode,
    String? languageCode,
    Locale? locale,
    bool? loading,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      locale: locale ?? this.locale,
      loading: loading ?? this.loading,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState(themeMode: ThemeMode.light, languageCode: 'en')) {
    _load();
  }

  final _storage = SecureStorage();

  Future<void> _load() async {
    state = state.copyWith(loading: true);
    final themeStr = await _storage.read('theme') ?? 'light';
    final lang = await _storage.read('language') ?? 'en';
    state = SettingsState(
      themeMode: themeStr == 'dark' ? ThemeMode.dark : ThemeMode.light,
      languageCode: lang,
      locale: Locale(lang),
      loading: false,
    );
  }

  Future<void> setTheme(String theme) async {
    final mode = theme == 'dark' ? ThemeMode.dark : ThemeMode.light;
    state = state.copyWith(themeMode: mode);
    unawaited(_storage.write('theme', theme));
  }

  Future<void> setLanguage(String code) async {
    state = state.copyWith(languageCode: code, locale: Locale(code));
    unawaited(_storage.write('language', code));
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
