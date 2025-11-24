import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'entities/content_entity.dart';
import 'entities/module_entity.dart';
import 'entities/subject_entity.dart';

class IsarService {
  static final IsarService _instance = IsarService._internal();
  bool _initialized = false;
  late Isar _isar;

  IsarService._internal();

  factory IsarService() {
    return _instance;
  }

  /// Initialize Isar database using isar_plus and generated schemas
  Future<void> init() async {
    if (_initialized) return;

    try {
      final dir = await getApplicationDocumentsDirectory();
      _isar = await Isar.open(
        [
          SubjectEntitySchema,
          ModuleEntitySchema,
          ContentEntitySchema,
        ],
        directory: dir.path,
        name: 'academy',
      );
      _initialized = true;
      debugPrint('IsarService initialized at: ${dir.path}');
    } catch (e, st) {
      debugPrint('Error initializing IsarService: $e\n$st');
      rethrow;
    }
  }

  /// Get all subjects from Isar
  Future<List<SubjectEntity>> getSubjects() async {
    return _isar.subjectEntitys.where().sortByOrder().findAll();
  }

  Future<SubjectEntity?> getSubject(String id) async {
    return _isar.subjectEntitys.filter().idEqualTo(id).findFirst();
  }

  /// Save subjects to Isar
  Future<void> saveSubjects(List<SubjectEntity> subjects) async {
    await _isar.writeTxn(() async {
      await _isar.subjectEntitys.putAll(subjects);
    });
  }

  Future<void> updateSubjectModules(
    String subjectId,
    List<String> moduleIds,
  ) async {
    await _isar.writeTxn(() async {
      final subject =
          await _isar.subjectEntitys.filter().idEqualTo(subjectId).findFirst();
      if (subject != null) {
        subject.moduleIds = moduleIds;
        await _isar.subjectEntitys.put(subject);
      }
    });
  }

  /// Get modules for a subject
  Future<List<ModuleEntity>> getModulesBySubjectId(String subjectId) async {
    return _isar.moduleEntitys
        .filter()
        .subjectIdEqualTo(subjectId)
        .sortByOrder()
        .findAll();
  }

  Future<ModuleEntity?> getModuleById(String moduleId) async {
    return _isar.moduleEntitys.filter().idEqualTo(moduleId).findFirst();
  }

  /// Save modules to Isar
  Future<void> saveModules(List<ModuleEntity> modules) async {
    await _isar.writeTxn(() async {
      await _isar.moduleEntitys.putAll(modules);
    });
  }

  Future<void> updateModuleContents(
    String moduleId,
    List<String> contentIds,
  ) async {
    await _isar.writeTxn(() async {
      final module =
          await _isar.moduleEntitys.filter().idEqualTo(moduleId).findFirst();
      if (module != null) {
        module.contentIds = contentIds;
        await _isar.moduleEntitys.put(module);
      }
    });
  }

  /// Get contents for a module
  Future<List<ContentEntity>> getContentsByModuleId(String moduleId) async {
    return _isar.contentEntitys
        .filter()
        .moduleIdEqualTo(moduleId)
        .sortByOrder()
        .findAll();
  }

  Future<ContentEntity?> getContentById(String contentId) async {
    return _isar.contentEntitys.filter().idEqualTo(contentId).findFirst();
  }

  /// Save contents to Isar
  Future<void> saveContents(List<ContentEntity> contents) async {
    await _isar.writeTxn(() async {
      await _isar.contentEntitys.putAll(contents);
    });
  }

  /// Clear all data
  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.clear();
    });
  }

  /// Close database
  Future<void> close() async {
    if (_initialized) {
      await _isar.close();
    }
  }
}
