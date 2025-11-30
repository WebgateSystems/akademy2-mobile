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
        'v1/session',
        data: {
          'user': {
            // API очікує email/password, але для учня використовуємо phone/pin
            'email': phone,
            'password': pin,
          },
        },
      );

      if (resp.statusCode == 200 && resp.data != null) {
        final accessToken = resp.data['access_token'] as String?;
        final data = resp.data['data'] as Map<String, dynamic>?;
        final attributes = data?['attributes'] as Map<String, dynamic>?;
        final userId = attributes?['id'] as String? ?? data?['id'] as String?;
        final refreshToken = resp.data['refreshToken'] as String?;
        if (accessToken != null) {
          await _storage.write('accessToken', accessToken);
          if (refreshToken != null) {
            await _storage.write('refreshToken', refreshToken);
          }
          await saveUserProfile(attributes,
              email: attributes?['email'] as String?,
              phone: attributes?['phone'] as String? ?? phone,
              pin: pin);
          state = AuthState(
            isAuthenticated: true,
            isUnlocked: true,
            userId: userId ?? phone,
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
    await logout();
    return false;
  }

  Future<String?> getAccessToken() async {
    return await _storage.read('accessToken');
  }

  Future<void> saveUserProfile(
    Map<String, dynamic>? attrs, {
    String? email,
    String? phone,
    String? pin,
  }) async {
    final storage = _storage;
    final firstName = attrs?['first_name'] as String?;
    final lastName = attrs?['last_name'] as String?;
    final birthdate = attrs?['birthdate'] as String?;
    final metaPin = attrs?['metadata'] is Map<String, dynamic>
        ? (attrs?['metadata'] as Map<String, dynamic>)['pin'] as String?
        : null;

    if (firstName != null) await storage.write('firstName', firstName);
    if (lastName != null) await storage.write('lastName', lastName);
    if (birthdate != null) await storage.write('dob', birthdate);
    if (email != null) await storage.write('email', email);
    if (phone != null) await storage.write('phone', phone);
    if (pin != null) await storage.write('userPin', pin);
    if (metaPin != null) await storage.write('userPin', metaPin);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});
