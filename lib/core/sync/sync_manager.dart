import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_provider.dart';
import '../db/isar_service.dart';
import '../services/quiz_sync_service.dart';

class SyncManager {
  final Ref ref;

  SyncManager(this.ref);

  Future<void> bootstrap() async {
    try {
      debugPrint('SyncManager: Starting bootstrap sync...');

      final auth = ref.read(authProvider);
      debugPrint(
          'SyncManager: Auth state - isAuthenticated=${auth.isAuthenticated}, isLoading=${auth.isLoading}');

      if (!auth.isAuthenticated) {
        debugPrint('SyncManager: Skip bootstrap, user not authenticated');
        return;
      }

      final authNotifier = ref.read(authProvider.notifier);
      final token = await authNotifier.getAccessToken();
      debugPrint(
          'SyncManager: Token exists=${token != null}, length=${token?.length ?? 0}');

      if (token == null) {
        debugPrint('SyncManager: Skip bootstrap, no access token');
        return;
      }

      final isarService = IsarService();

      await _syncQuizResults(isarService);

      debugPrint('SyncManager: Bootstrap sync completed successfully');
    } on DioException catch (e, st) {
      debugPrint('SyncManager: DioException during bootstrap:');
      debugPrint('  Type: ${e.type}');
      debugPrint('  Message: ${e.message}');
      debugPrint('  Response status: ${e.response?.statusCode}');
      debugPrint('  Response data: ${e.response?.data}');
      debugPrint('  Request URL: ${e.requestOptions.uri}');
      debugPrint('  Stack trace: $st');
    } catch (e, st) {
      debugPrint('SyncManager: Bootstrap sync failed: $e\n$st');
    }
  }

  Future<void> sync() async {
  }

  Future<void> reset() async {
    final isarService = IsarService();
    await isarService.clearAll();
    await bootstrap();
  }

  Future<void> _syncQuizResults(IsarService isarService) async {
    try {
      debugPrint('SyncManager: Syncing quiz results from server...');
      final results = await QuizSyncService.instance.fetchQuizResults();

      if (results.isEmpty) {
        debugPrint('SyncManager: No quiz results to sync');
        return;
      }

      for (final result in results) {
        await isarService.updateQuizBestScoreByModuleId(
          result.learningModuleId,
          result.score,
        );
        debugPrint(
            'SyncManager: Synced quiz result moduleId=${result.learningModuleId} score=${result.score}');
      }

      debugPrint(
          'SyncManager: Quiz results sync completed, count=${results.length}');
    } catch (e) {
      debugPrint('SyncManager: Failed to sync quiz results: $e');
    }
  }
}

final syncManagerProvider = Provider((ref) => SyncManager(ref));
