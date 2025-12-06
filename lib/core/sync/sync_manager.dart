import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_provider.dart';
import '../db/entities/content_entity.dart';
import '../db/entities/module_entity.dart';
import '../db/entities/subject_entity.dart';
import '../db/isar_service.dart';
import '../network/api.dart';
import '../network/dio_provider.dart';

/// Manages metadata synchronization between API and local Isar database
class SyncManager {
  final Ref ref;

  SyncManager(this.ref);

  /// Sync metadata (subjects/modules/contents) from API to local database
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

      // Check if token exists
      final authNotifier = ref.read(authProvider.notifier);
      final token = await authNotifier.getAccessToken();
      debugPrint(
          'SyncManager: Token exists=${token != null}, length=${token?.length ?? 0}');

      if (token == null) {
        debugPrint('SyncManager: Skip bootstrap, no access token');
        return;
      }

      final isarService = IsarService();
      final dio = ref.read(dioProvider);

      final resp = await dio.get('v1/subjects/with_contents');
      final list =
          (resp.data['data'] as List?)?.cast<Map<String, dynamic>>() ?? [];
      final parsed = _parseSubjectsWithContents(list);

      debugPrint(
          'SyncManager: Parsed subjects=${parsed.subjects.length}, modules=${parsed.modules.length}, contents=${parsed.contents.length}');

      // Per-subject/module debug
      for (final module in parsed.modules) {
        final moduleContentCount =
            parsed.contents.where((c) => c.moduleId == module.id).length;
        debugPrint(
            'SyncManager: Module id=${module.id} subjectId=${module.subjectId} contentCount=$moduleContentCount singleFlow=${module.singleFlow}');
      }

      // Clear existing data before saving new data
      await isarService.clearAll();
      debugPrint('SyncManager: Cleared all existing data');

      await isarService.saveSubjects(parsed.subjects);
      await isarService.saveModules(parsed.modules);
      await isarService.saveContents(parsed.contents);

      for (final subject in parsed.subjects) {
        await isarService.updateSubjectModules(
          subject.id,
          parsed.modules
              .where((m) => m.subjectId == subject.id)
              .map((m) => m.id)
              .toList(),
        );
      }
      for (final module in parsed.modules) {
        await isarService.updateModuleContents(
          module.id,
          parsed.contents
              .where((c) => c.moduleId == module.id)
              .map((c) => c.id)
              .toList(),
        );
      }

      // Verify persisted counts
      final subjectsCountPersisted = await isarService.countSubjects();
      final modulesCountPersisted = await isarService.countModules();
      final contentsCountPersisted = await isarService.countContents();
      debugPrint(
          'SyncManager: Persisted subjects=$subjectsCountPersisted modules=$modulesCountPersisted contents=$contentsCountPersisted');

      // Sample first 3 contents (ordered by module grouping) to verify fields (in-memory)
      if (parsed.contents.isNotEmpty) {
        for (final c in parsed.contents.take(3)) {
          debugPrint(
              'SyncManager: SampleContent id=${c.id} moduleId=${c.moduleId} type=${c.type} order=${c.order} title="${c.title}" youtube=${c.youtubeUrl} file=${c.fileUrl} poster=${c.posterUrl}');
        }
      }

      // Sample read-back from DB to ensure fields persisted
      if (parsed.contents.isNotEmpty) {
        for (final c in parsed.contents.take(3)) {
          final stored = await isarService.getContentById(c.id);
          debugPrint(
              'SyncManager: StoredContent id=${c.id} youtube=${stored?.youtubeUrl} file=${stored?.fileUrl} poster=${stored?.posterUrl}');
        }
      }

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

class _ParsedData {
  _ParsedData({
    required this.subjects,
    required this.modules,
    required this.contents,
  });

  final List<SubjectEntity> subjects;
  final List<ModuleEntity> modules;
  final List<ContentEntity> contents;
}

_ParsedData _parseSubjectsWithContents(List<Map<String, dynamic>> data) {
  final subjects = <SubjectEntity>[];
  final modules = <ModuleEntity>[];
  final contents = <ContentEntity>[];

  for (final item in data) {
    final attr = item['attributes'] as Map<String, dynamic>? ?? {};
    final subjectId = attr['id'] as String? ?? item['id'] as String? ?? '';
    final unit = attr['unit'] as Map<String, dynamic>?;
    final learningModule = unit?['learning_module'] as Map<String, dynamic>?;
    final learningModuleId =
        learningModule?['id'] as String? ?? '${subjectId}_module';

    final subject = SubjectEntity()
      ..id = subjectId
      ..type = item['type'] as String?
      ..title = attr['title'] as String? ?? ''
      ..slug = attr['slug'] as String? ?? ''
      ..orderIndex = attr['order_index'] as int? ?? 0
      ..iconUrl = attr['icon_url'] as String?
      ..colorLight = attr['color_light'] as String?
      ..colorDark = attr['color_dark'] as String?
      ..unitId = unit?['id'] as String?
      ..unitTitle = unit?['title'] as String?
      ..unitOrderIndex = unit?['order_index'] as int? ?? 0
      ..learningModuleId = learningModuleId
      ..learningModuleTitle = learningModule?['title'] as String? ?? ''
      ..learningModuleOrderIndex = learningModule?['order_index'] as int? ?? 0
      ..learningModulePublished = learningModule?['published'] as bool? ?? false
      ..learningModuleSingleFlow =
          learningModule?['single_flow'] as bool? ?? false
      ..moduleCount = learningModule == null ? 0 : 1
      ..updatedAt = _parseDate(attr['updated_at']) ??
          _parseDate(attr['updatedAt']) ??
          DateTime.now()
      ..moduleIds = learningModule == null ? [] : [learningModuleId];
    subjects.add(subject);

    if (learningModule != null) {
      final module = ModuleEntity()
        ..id = learningModuleId
        ..subjectId = subjectId
        ..title = learningModule['title'] as String? ?? ''
        ..description = ''
        ..order = learningModule['order_index'] as int? ?? 0
        ..singleFlow = learningModule['single_flow'] as bool? ?? false
        ..published = learningModule['published'] as bool? ?? false
        ..updatedAt = DateTime.now()
        ..contentIds = [];
      modules.add(module);

      final contentList =
          (learningModule['contents'] as List?)?.cast<Map<String, dynamic>>() ??
              [];
      for (final c in contentList) {
        final fileUrl = _resolveUrl(c['file_url'] as String?);
        final posterUrl = _resolveUrl(c['poster_url'] as String?);
        final subtitlesUrl = _resolveUrl(c['subtitles_url'] as String?);
        final content = ContentEntity()
          ..id = c['id'] as String? ?? ''
          ..moduleId = module.id
          ..type = (c['content_type'] as String? ?? '').toLowerCase()
          ..title = c['title'] as String? ?? ''
          ..description = ''
          ..durationSec = c['duration_sec'] as int? ?? 0
          ..order = c['order_index'] as int? ?? 0
          ..youtubeUrl = c['youtube_url'] as String?
          ..fileUrl = fileUrl
          ..fileHash = c['file_hash'] as String?
          ..fileFormat = c['file_format'] as String?
          ..posterUrl = posterUrl
          ..subtitlesUrl = subtitlesUrl
          ..payloadJson = _encodePayload(c['payload'])
          ..learningModuleId = learningModuleId
          ..learningModuleTitle = learningModule['title'] as String?
          ..bestScore = 0
          ..updatedAt = DateTime.now()
          ..downloaded = false
          ..downloadPath = '';
        contents.add(content);
        module.contentIds.add(content.id);
      }
    }
  }

  return _ParsedData(subjects: subjects, modules: modules, contents: contents);
}

DateTime? _parseDate(dynamic value) {
  if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }
  return null;
}

String? _resolveUrl(String? path) {
  if (path == null || path.isEmpty) return null;
  if (path.startsWith('http')) return path;
  final base = Api.baseUploadUrl.endsWith('/')
      ? Api.baseUploadUrl.substring(0, Api.baseUploadUrl.length - 1)
      : Api.baseUploadUrl;
  return path.startsWith('/') ? '$base$path' : '$base/$path';
}

String? _encodePayload(dynamic payload) {
  if (payload == null) return null;
  try {
    return jsonEncode(payload);
  } catch (_) {
    return null;
  }
}
