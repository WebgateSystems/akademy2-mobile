import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/entities/content_entity.dart';
import '../db/entities/module_entity.dart';
import '../db/entities/subject_entity.dart';
import '../db/isar_service.dart';
import '../network/api.dart';
import '../network/api_endpoints.dart';
import '../network/dio_provider.dart';

class StudentAccessRequiredException implements Exception {
  final String message;

  const StudentAccessRequiredException(
      [this.message = 'Student access required']);

  @override
  String toString() => message;
}

class DashboardSubject {
  final String id;
  final String title;
  final String slug;
  final String? iconUrl;
  final String? colorLight;
  final String? colorDark;
  final int totalModules;
  final int completedModules;
  final int completionRate;
  final int averageScore;

  const DashboardSubject({
    required this.id,
    required this.title,
    required this.slug,
    this.iconUrl,
    this.colorLight,
    this.colorDark,
    required this.totalModules,
    required this.completedModules,
    required this.completionRate,
    required this.averageScore,
  });

  factory DashboardSubject.fromJson(Map<String, dynamic> json) {
    return DashboardSubject(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      iconUrl: _resolveUrl(json['icon_url'] as String?),
      colorLight: json['color_light'] as String?,
      colorDark: json['color_dark'] as String?,
      totalModules: json['total_modules'] as int? ?? 0,
      completedModules: json['completed_modules'] as int? ?? 0,
      completionRate: json['completion_rate'] as int? ?? 0,
      averageScore: json['average_score'] as int? ?? 0,
    );
  }
}

class SubjectModule {
  final String id;
  final String title;
  final int orderIndex;
  final int contentsCount;
  final bool completed;
  final int? score;

  const SubjectModule({
    required this.id,
    required this.title,
    required this.orderIndex,
    required this.contentsCount,
    required this.completed,
    this.score,
  });

  factory SubjectModule.fromJson(Map<String, dynamic> json) {
    return SubjectModule(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      orderIndex: json['order_index'] as int? ?? 0,
      contentsCount: json['contents_count'] as int? ?? 0,
      completed: json['completed'] as bool? ?? false,
      score: json['score'] as int?,
    );
  }
}

class SubjectUnit {
  final String id;
  final String title;
  final int orderIndex;
  final List<SubjectModule> modules;

  const SubjectUnit({
    required this.id,
    required this.title,
    required this.orderIndex,
    required this.modules,
  });

  factory SubjectUnit.fromJson(Map<String, dynamic> json) {
    return SubjectUnit(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      orderIndex: json['order_index'] as int? ?? 0,
      modules: (json['modules'] as List?)
              ?.map((e) => SubjectModule.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class SubjectDetailData {
  final String id;
  final String title;
  final String slug;
  final String? iconUrl;
  final String? colorLight;
  final String? colorDark;
  final List<SubjectUnit> units;
  final int totalModules;
  final int completedModules;
  final int averageScore;

  const SubjectDetailData({
    required this.id,
    required this.title,
    required this.slug,
    this.iconUrl,
    this.colorLight,
    this.colorDark,
    required this.units,
    required this.totalModules,
    required this.completedModules,
    required this.averageScore,
  });

  List<SubjectModule> get allModules =>
      units.expand((unit) => unit.modules).toList();

  factory SubjectDetailData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final subject = data['subject'] as Map<String, dynamic>? ?? {};
    final progress = data['progress'] as Map<String, dynamic>? ?? {};

    return SubjectDetailData(
      id: subject['id'] as String? ?? '',
      title: subject['title'] as String? ?? '',
      slug: subject['slug'] as String? ?? '',
      iconUrl: _resolveUrl(subject['icon_url'] as String?),
      colorLight: subject['color_light'] as String?,
      colorDark: subject['color_dark'] as String?,
      units: (data['units'] as List?)
              ?.map((e) => SubjectUnit.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalModules: progress['total_modules'] as int? ?? 0,
      completedModules: progress['completed_modules'] as int? ?? 0,
      averageScore: progress['average_score'] as int? ?? 0,
    );
  }
}

class ModuleContent {
  final String id;
  final String title;
  final String contentType;
  final int orderIndex;
  final String? fileUrl;
  final String? posterUrl;
  final String? subtitlesUrl;
  final String? youtubeUrl;
  final int? durationSec;
  final Map<String, dynamic>? payload;

  const ModuleContent({
    required this.id,
    required this.title,
    required this.contentType,
    required this.orderIndex,
    this.fileUrl,
    this.posterUrl,
    this.subtitlesUrl,
    this.youtubeUrl,
    this.durationSec,
    this.payload,
  });

  String? get payloadJson {
    if (payload == null) return null;
    try {
      return jsonEncode(payload);
    } catch (_) {
      return null;
    }
  }

  factory ModuleContent.fromJson(Map<String, dynamic> json) {
    return ModuleContent(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      contentType: (json['content_type'] as String? ?? '').toLowerCase(),
      orderIndex: json['order_index'] as int? ?? 0,
      fileUrl: _resolveUrl(json['file_url'] as String?),
      posterUrl: _resolveUrl(json['poster_url'] as String?),
      subtitlesUrl: _resolveUrl(json['subtitles_url'] as String?),
      youtubeUrl: json['youtube_url'] as String?,
      durationSec: json['duration_sec'] as int?,
      payload: json['payload'] as Map<String, dynamic>?,
    );
  }

  ContentEntity toContentEntity(String moduleId) {
    return ContentEntity()
      ..id = id
      ..moduleId = moduleId
      ..type = contentType
      ..title = title
      ..description = null
      ..durationSec = durationSec ?? 0
      ..order = orderIndex
      ..youtubeUrl = youtubeUrl
      ..fileUrl = fileUrl
      ..fileHash = null
      ..fileFormat = null
      ..posterUrl = posterUrl
      ..subtitlesUrl = subtitlesUrl
      ..payloadJson = payloadJson
      ..learningModuleId = moduleId
      ..learningModuleTitle = null
      ..updatedAt = DateTime.now()
      ..downloaded = false
      ..downloadPath = '';
  }
}

class ModuleDetailData {
  final String id;
  final String title;
  final String unitId;
  final String unitTitle;
  final bool singleFlow;
  final List<ModuleContent> contents;
  final Map<String, dynamic>? previousResult;

  const ModuleDetailData({
    required this.id,
    required this.title,
    required this.unitId,
    required this.unitTitle,
    required this.singleFlow,
    required this.contents,
    this.previousResult,
  });

  factory ModuleDetailData.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;
    final module = data['module'] as Map<String, dynamic>? ?? {};

    return ModuleDetailData(
      id: module['id'] as String? ?? '',
      title: module['title'] as String? ?? '',
      unitId: module['unit_id'] as String? ?? '',
      unitTitle: module['unit_title'] as String? ?? '',
      singleFlow: module['single_flow'] as bool? ?? false,
      contents: (data['contents'] as List?)
              ?.map((e) => ModuleContent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      previousResult: data['previous_result'] as Map<String, dynamic>?,
    );
  }
}

class StudentApiService {
  final Dio _dio;
  final IsarService _isar = IsarService();

  StudentApiService(this._dio);

  Future<List<DashboardSubject>> fetchDashboardSubjects() async {
    try {
      final response = await _dio.get(ApiEndpoints.studentDashboard);
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      final subjects = (data['subjects'] as List?)
              ?.map((e) => DashboardSubject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
      debugPrint('StudentApiService: Fetched ${subjects.length} subjects');
      await _cacheDashboardSubjects(subjects);
      return subjects;
    } on DioException catch (e) {
      debugPrint(
          'StudentApiService: fetchDashboardSubjects error - ${e.message}');
      if (_isStudentAccessRequired(e)) {
        throw const StudentAccessRequiredException();
      }
      final cached = await _loadDashboardSubjectsFromCache();
      if (cached.isNotEmpty) {
        debugPrint(
            'StudentApiService: Using ${cached.length} cached dashboard subjects');
        return cached;
      }
      rethrow;
    }
  }

  Future<DashboardStatus> fetchDashboardStatus() async {
    final response = await _dio.get(ApiEndpoints.studentDashboard);
    final data = response.data['data'] as Map<String, dynamic>? ?? {};
    final schoolRaw = data['school'];
    final classesRaw = data['classes'];
    final hasSchoolToken = _extractSchoolToken(schoolRaw) != null;
    final hasClasses =
        classesRaw is List && classesRaw.isNotEmpty;
    return DashboardStatus(
      hasSchoolToken: hasSchoolToken,
      hasClasses: hasClasses,
    );
  }

  bool _isStudentAccessRequired(DioException e) {
    if (e.response?.statusCode != 403) return false;
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final errorMessage = data['error'];
      if (errorMessage is String &&
          errorMessage.toLowerCase().contains('student access required')) {
        return true;
      }
    }
    final message = e.message?.toLowerCase() ?? '';
    return message.contains('student access required');
  }

  Future<SubjectDetailData> fetchSubjectDetail(String subjectId) async {
    try {
      final response = await _dio.get(ApiEndpoints.studentSubject(subjectId));
      final result =
          SubjectDetailData.fromJson(response.data as Map<String, dynamic>);
      debugPrint(
          'StudentApiService: Fetched subject ${result.title} with ${result.units.length} units');
      await _cacheSubjectDetail(result);
      return result;
    } on DioException catch (e) {
      debugPrint('StudentApiService: fetchSubjectDetail error - ${e.message}');
      if (_isStudentAccessRequired(e)) {
        throw const StudentAccessRequiredException();
      }
      final cached = await _loadSubjectDetailFromCache(subjectId);
      if (cached != null) {
        debugPrint(
            'StudentApiService: Using cached subject detail for $subjectId');
        return cached;
      }
      rethrow;
    }
  }

  Future<ModuleDetailData> fetchModuleDetail(String moduleId) async {
    try {
      final response =
          await _dio.get(ApiEndpoints.studentLearningModule(moduleId));
      final result =
          ModuleDetailData.fromJson(response.data as Map<String, dynamic>);
      debugPrint(
          'StudentApiService: Fetched module ${result.title} with ${result.contents.length} contents');
      await _cacheModuleDetail(result);
      return result;
    } on DioException catch (e) {
      debugPrint('StudentApiService: fetchModuleDetail error - ${e.message}');
      if (_isStudentAccessRequired(e)) {
        throw const StudentAccessRequiredException();
      }
      final cached = await _loadModuleDetailFromCache(moduleId);
      if (cached != null) {
        debugPrint(
            'StudentApiService: Using cached module detail for $moduleId');
        return cached;
      }
      rethrow;
    }
  }

  Future<void> _cacheDashboardSubjects(
    List<DashboardSubject> subjects,
  ) async {
    if (subjects.isEmpty) return;
    final now = DateTime.now();
    final entities = <SubjectEntity>[];
    for (var i = 0; i < subjects.length; i++) {
      final subject = subjects[i];
      entities.add(
        SubjectEntity()
          ..id = subject.id
          ..title = subject.title
          ..slug = subject.slug
          ..orderIndex = i
          ..iconUrl = subject.iconUrl
          ..colorLight = subject.colorLight
          ..colorDark = subject.colorDark
          ..moduleCount = subject.totalModules
          ..updatedAt = now,
      );
    }
    await _isar.saveSubjects(entities);
  }

  Future<List<DashboardSubject>> _loadDashboardSubjectsFromCache() async {
    try {
      final cached = await _isar.getSubjects();
      if (cached.isEmpty) return [];
      final subjects = <DashboardSubject>[];
      for (final subject in cached) {
        final bestScore = await _isar.getBestQuizScoreForSubject(subject.id);
        subjects.add(
          DashboardSubject(
            id: subject.id,
            title: subject.title,
            slug: subject.slug,
            iconUrl: subject.iconUrl,
            colorLight: subject.colorLight,
            colorDark: subject.colorDark,
            totalModules: subject.moduleCount,
            completedModules: 0,
            completionRate: 0,
            averageScore: bestScore,
          ),
        );
      }
      return subjects;
    } catch (_) {
      return [];
    }
  }

  Future<void> _cacheSubjectDetail(SubjectDetailData detail) async {
    final now = DateTime.now();
    final modules = detail.allModules;
    final firstUnit = detail.units.isNotEmpty ? detail.units.first : null;

    final subjectEntity = SubjectEntity()
      ..id = detail.id
      ..title = detail.title
      ..slug = detail.slug
      ..orderIndex = firstUnit?.orderIndex ?? 0
      ..iconUrl = detail.iconUrl
      ..colorLight = detail.colorLight
      ..colorDark = detail.colorDark
      ..moduleCount = detail.totalModules
      ..unitId = firstUnit?.id
      ..unitTitle = firstUnit?.title
      ..unitOrderIndex = firstUnit?.orderIndex ?? 0
      ..updatedAt = now
      ..moduleIds = modules.map((m) => m.id).toList();

    await _isar.saveSubjects([subjectEntity]);

    if (modules.isEmpty) return;

    final moduleEntities = modules
        .map(
          (module) => ModuleEntity()
            ..id = module.id
            ..subjectId = detail.id
            ..title = module.title
            ..order = module.orderIndex
            ..singleFlow = false
            ..published = true
            ..updatedAt = now
            ..contentIds = [],
        )
        .toList();

    await _isar.saveModules(moduleEntities);
    await _isar.updateSubjectModules(
      detail.id,
      moduleEntities.map((m) => m.id).toList(),
    );
  }

  Future<SubjectDetailData?> _loadSubjectDetailFromCache(
    String subjectId,
  ) async {
    final subject = await _isar.getSubject(subjectId);
    if (subject == null) return null;

    final modules = await _isar.getModulesBySubjectId(subjectId);
    if (modules.isEmpty) return null;

    final moduleDtos = modules
        .map(
          (module) => SubjectModule(
            id: module.id,
            title: module.title,
            orderIndex: module.order,
            contentsCount: module.contentIds.length,
            completed: false,
            score: null,
          ),
        )
        .toList()
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    final bestScore = await _isar.getBestQuizScoreForSubject(subjectId);

    final unit = SubjectUnit(
      id: subject.unitId ?? subject.id,
      title: subject.unitTitle ?? subject.title,
      orderIndex: subject.unitOrderIndex,
      modules: moduleDtos,
    );

    return SubjectDetailData(
      id: subject.id,
      title: subject.title,
      slug: subject.slug,
      iconUrl: subject.iconUrl,
      colorLight: subject.colorLight,
      colorDark: subject.colorDark,
      units: [unit],
      totalModules: subject.moduleCount,
      completedModules: 0,
      averageScore: bestScore,
    );
  }

  Future<void> _cacheModuleDetail(ModuleDetailData moduleDetail) async {
    final now = DateTime.now();
    final moduleId = moduleDetail.id;
    final existing = await _isar.getModuleById(moduleId);

    final module = ModuleEntity()
      ..id = moduleId
      ..subjectId = existing?.subjectId ?? moduleDetail.unitId
      ..title = moduleDetail.title
      ..description = moduleDetail.unitTitle
      ..order = existing?.order ?? 0
      ..singleFlow = moduleDetail.singleFlow
      ..published = true
      ..updatedAt = now
      ..contentIds = moduleDetail.contents.map((c) => c.id).toList();

    await _isar.saveModules([module]);

    for (final content in moduleDetail.contents) {
      var entity = await _isar.getContentById(content.id);
      final downloaded = entity?.downloaded ?? false;
      final downloadPath = entity?.downloadPath ?? '';

      if (entity == null) {
        entity = content.toContentEntity(moduleId);
      } else {
        entity
          ..moduleId = moduleId
          ..type = content.contentType
          ..title = content.title
          ..order = content.orderIndex
          ..youtubeUrl = content.youtubeUrl
          ..fileUrl = content.fileUrl
          ..posterUrl = content.posterUrl
          ..subtitlesUrl = content.subtitlesUrl
          ..payloadJson = content.payloadJson
          ..durationSec = content.durationSec ?? 0
          ..updatedAt = now;
        if (downloaded) {
          entity
            ..downloaded = true
            ..downloadPath = downloadPath;
        }
      }

      await _isar.saveContent(entity);
    }
  }

  Future<ModuleDetailData?> _loadModuleDetailFromCache(
    String moduleId,
  ) async {
    final module = await _isar.getModuleById(moduleId);
    if (module == null) return null;

    final contents = await _isar.getContentsByModuleId(moduleId);
    if (contents.isEmpty) return null;

    final moduleContents = contents
        .map(
          (content) => _moduleContentFromEntity(content),
        )
        .toList()
      ..sort((a, b) => a.orderIndex.compareTo(b.orderIndex));

    return ModuleDetailData(
      id: module.id,
      title: module.title,
      unitId: module.subjectId,
      unitTitle: module.description ?? '',
      singleFlow: module.singleFlow,
      contents: moduleContents,
      previousResult: null,
    );
  }

  ModuleContent _moduleContentFromEntity(ContentEntity entity) {
    return ModuleContent(
      id: entity.id,
      title: entity.title,
      contentType: entity.type,
      orderIndex: entity.order,
      fileUrl: entity.fileUrl,
      posterUrl: entity.posterUrl,
      subtitlesUrl: entity.subtitlesUrl,
      youtubeUrl: entity.youtubeUrl,
      durationSec: entity.durationSec,
      payload:
          entity.payloadJson != null ? jsonDecode(entity.payloadJson!) : null,
    );
  }
}

final studentApiServiceProvider = Provider<StudentApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return StudentApiService(dio);
});

final dashboardSubjectsProvider =
    FutureProvider<List<DashboardSubject>>((ref) async {
  final service = ref.watch(studentApiServiceProvider);
  return service.fetchDashboardSubjects();
});

final subjectDetailProvider =
    FutureProvider.family<SubjectDetailData, String>((ref, subjectId) async {
  final service = ref.watch(studentApiServiceProvider);
  return service.fetchSubjectDetail(subjectId);
});

final moduleDetailProvider =
    FutureProvider.family<ModuleDetailData, String>((ref, moduleId) async {
  final service = ref.watch(studentApiServiceProvider);
  return service.fetchModuleDetail(moduleId);
});

String? _resolveUrl(String? path) {
  if (path == null || path.isEmpty) return null;
  if (path.startsWith('http')) return path;
  final base = Api.baseUploadUrl.endsWith('/')
      ? Api.baseUploadUrl.substring(0, Api.baseUploadUrl.length - 1)
      : Api.baseUploadUrl;
  return path.startsWith('/') ? '$base$path' : '$base/$path';
}

String? _extractSchoolToken(dynamic school) {
  if (school is String && school.isNotEmpty) return school;
  if (school is Map<String, dynamic>) {
    return (school['token'] as String?) ??
        (school['school_token'] as String?) ??
        (school['id'] as String?);
  }
  return null;
}

class DashboardStatus {
  final bool hasSchoolToken;
  final bool hasClasses;

  const DashboardStatus({
    required this.hasSchoolToken,
    required this.hasClasses,
  });
}
