import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_provider.dart';
import 'api.dart';
import 'dio_client.dart';

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
    if (status == 401 && (req.extra['retry'] != true)) {
      final notifier = ref.read(authProvider.notifier);
      final refreshed = await notifier.refreshAccessToken();
      if (refreshed) {
        final newToken = await notifier.getAccessToken();
        if (newToken != null) {
          final clone = req
            ..headers['Authorization'] = 'Bearer $newToken'
            ..extra = {...req.extra, 'retry': true}
            ..baseUrl =
                req.baseUrl.isEmpty ? Api.normalizedBaseUrl : req.baseUrl;
          try {
            final response = await DioClient().dio.fetch(clone);
            return handler.resolve(response);
          } catch (e) {
          }
        }
      }
    }
    handler.next(err);
  }
}
