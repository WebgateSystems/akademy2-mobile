import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/join_repository.dart';
import 'auth_interceptor.dart';
import 'dio_client.dart';

final dioProvider = Provider<Dio>((ref) {
  final client = DioClient().dio;
  final hasAuth = client.interceptors.any((i) => i is AuthInterceptor);

  if (!hasAuth) {
    client.interceptors.add(AuthInterceptor(ref));
  }

  DioProviderSingleton.dio = client;
  return client;
});
