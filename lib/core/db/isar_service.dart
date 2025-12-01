import 'package:flutter/foundation.dart';
import 'package:isar_plus/isar_plus.dart';
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
      _isar = await Isar.openAsync(
        schemas: [
          SubjectEntitySchema,
          ModuleEntitySchema,
          ContentEntitySchema,
        ],
        directory: dir.path,
        // Bump name to force a fresh schema when fields change (no migrations in isar_plus)
        name: 'academy_v2',
      );
      _initialized = true;
      debugPrint('IsarService initialized at: ${dir.path}');
    } catch (e, st) {
      debugPrint('Error initializing IsarService: $e\n$st');
      rethrow;
    }
  }

  Future<void> _ensureInit() async {
    if (!_initialized) {
      await init();
    }
  }

  /// Get all subjects from Isar
  Future<List<SubjectEntity>> getSubjects() async {
    await _ensureInit();
    final subjects =
        _isar.subjectEntitys.where().sortByOrderIndex().build().findAll();
    debugPrint(
        'IsarService: getSubjects() returned ${subjects.length} subjects');
    return subjects;
  }

  Future<SubjectEntity?> getSubject(String id) async {
    await _ensureInit();
    return _isar.subjectEntitys.where().idEqualTo(id).build().findFirst();
  }

  /// Save subjects to Isar
  Future<void> saveSubjects(List<SubjectEntity> subjects) async {
    await _ensureInit();
    debugPrint('IsarService: Saving ${subjects.length} subjects...');
    await _isar.writeAsync((isar) {
      for (final subject in subjects) {
        subject.isarId = isar.subjectEntitys.autoIncrement();
        isar.subjectEntitys.put(subject);
      }
    });
    final saved = _isar.subjectEntitys.where().build().count();
    debugPrint('IsarService: After save, total subjects in DB: $saved');
  }

  Future<void> updateSubjectModules(
    String subjectId,
    List<String> moduleIds,
  ) async {
    await _ensureInit();
    // Read outside transaction
    final subject =
        _isar.subjectEntitys.where().idEqualTo(subjectId).build().findFirst();
    if (subject != null) {
      subject.moduleIds = moduleIds;
      // Write inside transaction
      await _isar.writeAsync((isar) {
        isar.subjectEntitys.put(subject);
      });
    }
  }

  /// Get modules for a subject
  Future<List<ModuleEntity>> getModulesBySubjectId(String subjectId) async {
    await _ensureInit();
    final modules = _isar.moduleEntitys
        .where()
        .subjectIdEqualTo(subjectId)
        .sortByOrder()
        .build()
        .findAll();
    debugPrint(
        'IsarService: modules for subject=$subjectId => ${modules.length}');
    return modules;
  }

  Future<ModuleEntity?> getModuleById(String moduleId) async {
    await _ensureInit();
    return _isar.moduleEntitys.where().idEqualTo(moduleId).build().findFirst();
  }

  /// Save modules to Isar
  Future<void> saveModules(List<ModuleEntity> modules) async {
    await _ensureInit();
    await _isar.writeAsync((isar) {
      for (final module in modules) {
        module.isarId = isar.moduleEntitys.autoIncrement();
        isar.moduleEntitys.put(module);
      }
    });
  }

  Future<void> updateModuleContents(
    String moduleId,
    List<String> contentIds,
  ) async {
    await _ensureInit();
    // Read outside transaction
    final module =
        _isar.moduleEntitys.where().idEqualTo(moduleId).build().findFirst();
    if (module != null) {
      module.contentIds = contentIds;
      // Write inside transaction
      await _isar.writeAsync((isar) {
        isar.moduleEntitys.put(module);
      });
    }
  }

  /// Get contents for a module
  Future<List<ContentEntity>> getContentsByModuleId(String moduleId) async {
    await _ensureInit();
    final contents = _isar.contentEntitys
        .where()
        .moduleIdEqualTo(moduleId)
        .sortByOrder()
        .build()
        .findAll();
    debugPrint(
        'IsarService: contents for module=$moduleId => ${contents.length}');
    if (contents.isNotEmpty) {
      final sample = contents.first;
      debugPrint(
          'IsarService: sample content id=${sample.id} type=${sample.type} youtube=${sample.youtubeUrl} poster=${sample.posterUrl} file=${sample.fileUrl}');
    }
    return contents;
  }

  Future<int> countSubjects() async {
    await _ensureInit();
    return _isar.subjectEntitys.where().build().count();
  }

  Future<int> countModules() async {
    await _ensureInit();
    return _isar.moduleEntitys.where().build().count();
  }

  Future<int> countContents() async {
    await _ensureInit();
    return _isar.contentEntitys.where().build().count();
  }

  Future<ContentEntity?> getContentById(String contentId) async {
    await _ensureInit();
    return _isar.contentEntitys
        .where()
        .idEqualTo(contentId)
        .build()
        .findFirst();
  }

  /// Save contents to Isar
  Future<void> saveContents(List<ContentEntity> contents) async {
    await _ensureInit();
    await _isar.writeAsync((isar) {
      for (final content in contents) {
        content.isarId = isar.contentEntitys.autoIncrement();
        isar.contentEntitys.put(content);
      }
    });
  }

  /// Clear all data
  Future<void> clearAll() async {
    await _ensureInit();
    await _isar.writeAsync((isar) {
      isar.clear();
    });
  }

  /// Close database
  Future<void> close() async {
    if (_initialized) {
      _isar.close();
    }
  }
}
