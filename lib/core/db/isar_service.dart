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
        name: 'academy_v3',
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
    final subject =
        _isar.subjectEntitys.where().idEqualTo(subjectId).build().findFirst();
    if (subject != null) {
      subject.moduleIds = moduleIds;
      await _isar.writeAsync((isar) {
        isar.subjectEntitys.put(subject);
      });
    }
  }

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
    final module =
        _isar.moduleEntitys.where().idEqualTo(moduleId).build().findFirst();
    if (module != null) {
      module.contentIds = contentIds;
      await _isar.writeAsync((isar) {
        isar.moduleEntitys.put(module);
      });
    }
  }

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

  Future<void> saveContents(List<ContentEntity> contents) async {
    await _ensureInit();
    await _isar.writeAsync((isar) {
      for (final content in contents) {
        content.isarId = isar.contentEntitys.autoIncrement();
        isar.contentEntitys.put(content);
      }
    });
  }

  Future<void> saveContent(ContentEntity content) async {
    await _ensureInit();
    final existing =
        _isar.contentEntitys.where().idEqualTo(content.id).build().findFirst();
    await _isar.writeAsync((isar) {
      if (existing != null) {
        content.isarId = existing.isarId;
      } else {
        content.isarId = isar.contentEntitys.autoIncrement();
      }
      isar.contentEntitys.put(content);
    });
  }

  Future<void> updateContentDownload(
    String contentId, {
    bool? downloaded,
    String? downloadPath,
  }) async {
    await _ensureInit();
    final existing =
        _isar.contentEntitys.where().idEqualTo(contentId).build().findFirst();
    if (existing == null) return;
    if (downloaded != null) {
      existing.downloaded = downloaded;
    }
    if (downloadPath != null) {
      existing.downloadPath = downloadPath;
    }
    await _isar.writeAsync((isar) {
      isar.contentEntitys.put(existing);
    });
  }

  Future<void> updateQuizBestScore(String contentId, int score) async {
    await _ensureInit();
    final existing =
        _isar.contentEntitys.where().idEqualTo(contentId).build().findFirst();
    if (existing == null) return;
    if (score <= existing.bestScore) return;
    existing.bestScore = score;
    await _isar.writeAsync((isar) {
      isar.contentEntitys.put(existing);
    });
  }

  Future<int> getBestQuizScoreForSubject(String subjectId) async {
    await _ensureInit();
    final modules = _isar.moduleEntitys
        .where()
        .subjectIdEqualTo(subjectId)
        .build()
        .findAll();
    if (modules.isEmpty) return 0;
    var best = 0;
    for (final module in modules) {
      final contents = _isar.contentEntitys
          .where()
          .moduleIdEqualTo(module.id)
          .build()
          .findAll();
      for (final c in contents) {
        if (c.type == 'quiz' && c.bestScore > best) {
          best = c.bestScore;
        }
      }
    }
    return best;
  }

  Future<void> updateQuizBestScoreByModuleId(String moduleId, int score) async {
    await _ensureInit();
    final contents = _isar.contentEntitys
        .where()
        .moduleIdEqualTo(moduleId)
        .build()
        .findAll();

    for (final content in contents) {
      if (content.type == 'quiz') {
        if (score > content.bestScore) {
          content.bestScore = score;
          await _isar.writeAsync((isar) {
            isar.contentEntitys.put(content);
          });
        }
        break;
      }
    }
  }

  Future<void> clearAll() async {
    await _ensureInit();
    await _isar.writeAsync((isar) {
      isar.clear();
    });
  }

  Future<void> close() async {
    if (_initialized) {
      _isar.close();
    }
  }
}
