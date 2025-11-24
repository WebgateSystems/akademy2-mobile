import 'dart:async';

import 'package:dio/dio.dart';

import '../storage/secure_storage.dart';

class JoinRepository {
  JoinRepository({Dio? dio}) : _dio = dio ?? DioProviderSingleton.dio;

  final Dio _dio;

  Future<String> joinWithCode(String code) async {
    final resp = await _dio.post('/v1/classes/join', data: {'code': code});
    final data = resp.data as Map<String, dynamic>;
    final id = data['requestId'] as String?;
    if (id == null) throw Exception('Invalid response');
    return id;
  }

  Future<JoinStatus> checkStatus(String requestId) async {
    final resp = await _dio.get('/v1/classes/join/$requestId/status');
    final data = resp.data as Map<String, dynamic>;
    final status = data['status'] as String? ?? 'pending';
    final token = data['accessToken'] as String?;
    final refresh = data['refreshToken'] as String?;
    return JoinStatus(status: status, accessToken: token, refreshToken: refresh);
  }

  Future<void> clearPending() async {
    final storage = SecureStorage();
    await storage.delete('pendingJoinId');
    await storage.delete('pendingJoinCode');
  }
}

class JoinStatus {
  const JoinStatus({required this.status, this.accessToken, this.refreshToken});
  final String status;
  final String? accessToken;
  final String? refreshToken;
}

/// Singleton holder for Dio with interceptors already attached via Riverpod provider.
class DioProviderSingleton {
  static late Dio dio;
}
