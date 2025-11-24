import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/join_repository.dart';
import 'auth_interceptor.dart';
import 'dio_client.dart';
import 'mock_api_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final client = DioClient().dio;
  final hasAuth = client.interceptors.any((i) => i is AuthInterceptor);
  final hasMock = client.interceptors.any((i) => i is MockApiInterceptor);

  // Add MockApiInterceptor first (should run before auth)
  if (!hasMock) {
    client.interceptors.add(MockApiInterceptor());
  }

  // Add AuthInterceptor
  if (!hasAuth) {
    client.interceptors.add(AuthInterceptor(ref));
  }

  DioProviderSingleton.dio = client;
  return client;
});
