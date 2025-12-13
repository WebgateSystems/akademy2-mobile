import 'dart:async';

import 'package:dio/dio.dart';

import '../network/api_endpoints.dart';
import '../storage/secure_storage.dart';

class JoinRepository {
  JoinRepository({Dio? dio}) : _dio = dio ?? DioProviderSingleton.dio;

  final Dio _dio;

  Future<String> joinWithCode(String code) async {
    final payload = _extractJoinCode(code);
    final resp = await _dio.post(
      ApiEndpoints.studentEnrollmentsJoin,
      data: {'token': payload},
    );
    final data = resp.data as Map<String, dynamic>;
    final id = data['requestId'] as String? ?? data['enrollment_id'] as String?;
    if (id == null || id.isEmpty) {
      throw Exception('Invalid response');
    }
    return id;
  }

  Future<JoinStatus> checkStatus(String requestId) async {
    final resp =
        await _dio.get(ApiEndpoints.studentEnrollmentStatus(requestId));
    final data = resp.data as Map<String, dynamic>;
    final status = data['status'] as String? ?? 'pending';
    final token =
        data['accessToken'] as String? ?? data['access_token'] as String?;
    final refresh =
        data['refreshToken'] as String? ?? data['refresh_token'] as String?;
    final schoolId =
        data['schoolId'] as String? ?? data['school_id'] as String?;
    return JoinStatus(
      status: status,
      accessToken: token,
      refreshToken: refresh,
      schoolId: schoolId,
    );
  }

  Future<void> clearPending() async {
    final storage = SecureStorage();
    await storage.delete('pendingJoinId');
    await storage.delete('pendingJoinCode');
  }

  String _extractJoinCode(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw Exception('Empty join code');
    }

    final uri = Uri.tryParse(trimmed);

    if (uri != null && uri.host.isNotEmpty) {
      if (uri.pathSegments.isNotEmpty) {
        return uri.pathSegments.last;
      }
    }

    return trimmed;
  }
}

class JoinStatus {
  const JoinStatus({
    required this.status,
    this.accessToken,
    this.refreshToken,
    this.schoolId,
  });
  final String status;
  final String? accessToken;
  final String? refreshToken;
  final String? schoolId;
}

class DioProviderSingleton {
  static late Dio dio;
}
