import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/entities/content_entity.dart';
import '../db/entities/module_entity.dart';
import '../db/entities/subject_entity.dart';
import '../db/isar_service.dart';
import '../network/dio_provider.dart';

/// Manages metadata synchronization between API and local Isar database
class SyncManager {
  final Ref ref;

  SyncManager(this.ref);

  /// Sync metadata (subjects/modules/contents) from API to local database
  Future<void> bootstrap() async {
    try {
      debugPrint('SyncManager: Starting bootstrap sync...');

      final isarService = IsarService();
      final dio = ref.read(dioProvider);

      // Fetch subjects from API (intercepted by MockApiInterceptor)
      final subjectsResp = await dio.get('/v1/subjects');
      final subjectsData =
          (subjectsResp.data['subjects'] as List?)?.cast<Map<String, dynamic>>() ??
          [];
      final subjects =
          subjectsData.map((json) => SubjectEntity.fromJson(json)).toList();

      debugPrint('SyncManager: Fetched ${subjects.length} subjects');

      // Save subjects to Isar
      await isarService.saveSubjects(subjects);

      // Fetch and save modules for each subject
      for (final subject in subjects) {
        final modulesResp = await dio.get(
          '/v1/modules',
          queryParameters: {'subjectId': subject.id},
        );
        final modulesData =
            (modulesResp.data['modules'] as List?)?.cast<Map<String, dynamic>>() ??
            [];
        final modules =
            modulesData.map((json) => ModuleEntity.fromJson(json)).toList();

        debugPrint(
          'SyncManager: Fetched ${modules.length} modules for ${subject.title}',
        );
        await isarService.saveModules(modules);
        await isarService.updateSubjectModules(
          subject.id,
          modules.map((m) => m.id).toList(),
        );

        // Fetch and save contents for each module
        for (final module in modules) {
          final contentsResp = await dio.get(
            '/v1/contents',
            queryParameters: {'moduleId': module.id},
          );
          final contentsData =
              (contentsResp.data['contents'] as List?)?.cast<Map<String, dynamic>>() ??
              [];
          final contents = contentsData
              .map((json) => ContentEntity.fromJson(json))
              .toList();

          debugPrint(
            'SyncManager: Fetched ${contents.length} contents for ${module.title}',
          );
          await isarService.saveContents(contents);
          await isarService.updateModuleContents(
            module.id,
            contents.map((c) => c.id).toList(),
          );
        }
      }

      debugPrint('SyncManager: Bootstrap sync completed successfully');
    } catch (e, st) {
      debugPrint('SyncManager: Bootstrap sync failed: $e\n$st');
      // For M1, we'll continue with mock data if sync fails
    }
  }

  /// Incremental sync (only fetch updates since last sync)
  Future<void> sync() async {
    // TODO: implement incremental sync in M2/M3
  }

  /// Clear and re-download all data
  Future<void> reset() async {
    final isarService = IsarService();
    await isarService.clearAll();
    await bootstrap();
  }
}

final syncManagerProvider = Provider((ref) => SyncManager(ref));
