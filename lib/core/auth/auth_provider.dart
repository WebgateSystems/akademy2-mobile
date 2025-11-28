import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/storage/secure_storage.dart';
import '../network/dio_provider.dart';

class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final bool isUnlocked;
  final String? userId;

  const AuthState({
    required this.isAuthenticated,
    this.isLoading = false,
    this.isUnlocked = false,
    this.userId,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    bool? isUnlocked,
    String? userId,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      userId: userId ?? this.userId,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SecureStorage _storage = SecureStorage();
  final Ref ref;
  Completer<bool>? _refreshCompleter;

  AuthNotifier(this.ref)
      : super(const AuthState(isAuthenticated: false, isLoading: true));

  Future<void> load() async {
    state = state.copyWith(isLoading: true);
    final token = await _storage.read('accessToken');
    state = AuthState(
      isAuthenticated: token != null,
      isLoading: false,
      isUnlocked: false,
      userId: token != null ? 'me' : null,
    );
  }

  Future<void> login(String phone, String pin) async {
    state = state.copyWith(isLoading: true);
    try {
      final dio = ref.read(dioProvider);
      final resp = await dio.post(
        'v1/auth/login',
        data: {
          'user': {
            'phone': phone,
            'pin': pin,
          },
        },
      );

      if (resp.statusCode == 200 && resp.data != null) {
        final accessToken = resp.data['accessToken'] as String?;
        final refreshToken = resp.data['refreshToken'] as String?;
        if (accessToken != null) {
          await _storage.write('accessToken', accessToken);
          if (refreshToken != null) {
            await _storage.write('refreshToken', refreshToken);
          }
          await _storage.write('userPin', pin);
          await _storage.write('phone', phone);
          state = AuthState(
            isAuthenticated: true,
            isUnlocked: true,
            userId: phone,
            isLoading: false,
          );
          return;
        }
      }
    } catch (e) {
      rethrow;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> setTokens(String accessToken,
      {String? refreshToken, String? userId}) async {
    await _storage.write('accessToken', accessToken);
    if (refreshToken != null) {
      await _storage.write('refreshToken', refreshToken);
    }
    state = AuthState(
      isAuthenticated: true,
      isUnlocked: true,
      isLoading: false,
      userId: userId ?? 'me',
    );
  }

  void markAuthenticated({String? userId}) {
    state = AuthState(
      isAuthenticated: true,
      isUnlocked: true,
      isLoading: false,
      userId: userId,
    );
  }

  void markUnlocked() {
    if (state.isAuthenticated) {
      state = state.copyWith(isUnlocked: true, isLoading: false);
    }
  }

  void requireUnlock() {
    if (state.isAuthenticated && state.isUnlocked) {
      state = state.copyWith(isUnlocked: false);
    }
  }

  Future<void> logout() async {
    await _storage.delete('accessToken');
    await _storage.delete('refreshToken');
    state = const AuthState(
      isAuthenticated: false,
      isLoading: false,
      isUnlocked: false,
    );
  }

  /// Refreshes access token using refresh token.
  /// Ensures only one refresh runs concurrently; other callers await the same future.
  Future<bool> refreshAccessToken() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }
    _refreshCompleter = Completer<bool>();

    try {
      final refreshToken = await _storage.read('refreshToken');
      if (refreshToken == null) {
        await logout();
        _refreshCompleter!.complete(false);
        return false;
      }

      final dio = ref.read(dioProvider);
      final resp = await dio.post(
        'v1/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
      if (resp.statusCode == 200 && resp.data != null) {
        final newAccess = resp.data['accessToken'] as String?;
        final newRefresh = resp.data['refreshToken'] as String?;
        if (newAccess != null) {
          await _storage.write('accessToken', newAccess);
          if (newRefresh != null) {
            await _storage.write('refreshToken', newRefresh);
          }
          state = state.copyWith(isAuthenticated: true, isLoading: false);
          _refreshCompleter!.complete(true);
          return true;
        }
      }

      await logout();
      _refreshCompleter!.complete(false);
      return false;
    } catch (e) {
      // On error, consider refresh failed
      await logout();
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  Future<String?> getAccessToken() async {
    return await _storage.read('accessToken');
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
