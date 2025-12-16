import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/router.dart';
import '../auth/auth_provider.dart';

class AuthInterceptor extends Interceptor {
  final Ref ref;

  AuthInterceptor(this.ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final notifier = ref.read(authProvider.notifier);
      final accessToken = await notifier.getAccessToken();
      debugPrint(
          'AuthInterceptor: Token exists=${accessToken != null}, length=${accessToken?.length ?? 0}');
      if (accessToken != null) {
        options.headers['Authorization'] = 'Bearer $accessToken';
        debugPrint(
            'AuthInterceptor: Added Bearer token to request ${options.uri}');
      } else {
        debugPrint('AuthInterceptor: No token for request ${options.uri}');
      }
    } catch (e) {
      debugPrint('AuthInterceptor: Error getting token: $e');
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final req = err.requestOptions;
    final status = err.response?.statusCode;
    if (status == 401) {
      try {
        await ref.read(authProvider.notifier).logout();
        final router = ref.read(routerProvider);
        router.go('/login');
      } catch (_) {}
      return handler.next(err);
    }
    handler.next(err);
  }
}
