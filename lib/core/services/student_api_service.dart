import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../db/entities/content_entity.dart';
import '../network/api.dart';
import '../network/dio_provider.dart';


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

  StudentApiService(this._dio);

  Future<List<DashboardSubject>> fetchDashboardSubjects() async {
    try {
      final response = await _dio.get('v1/student/dashboard');
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      final subjects = (data['subjects'] as List?)
              ?.map((e) => DashboardSubject.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [];
      debugPrint('StudentApiService: Fetched ${subjects.length} subjects');
      return subjects;
    } on DioException catch (e) {
      debugPrint(
          'StudentApiService: fetchDashboardSubjects error - ${e.message}');
      rethrow;
    }
  }

  Future<SubjectDetailData> fetchSubjectDetail(String subjectId) async {
    try {
      final response = await _dio.get('v1/student/subjects/$subjectId');
      final result =
          SubjectDetailData.fromJson(response.data as Map<String, dynamic>);
      debugPrint(
          'StudentApiService: Fetched subject ${result.title} with ${result.units.length} units');
      return result;
    } on DioException catch (e) {
      debugPrint('StudentApiService: fetchSubjectDetail error - ${e.message}');
      rethrow;
    }
  }

  Future<ModuleDetailData> fetchModuleDetail(String moduleId) async {
    try {
      final response = await _dio.get('v1/student/learning_modules/$moduleId');
      final result =
          ModuleDetailData.fromJson(response.data as Map<String, dynamic>);
      debugPrint(
          'StudentApiService: Fetched module ${result.title} with ${result.contents.length} contents');
      return result;
    } on DioException catch (e) {
      debugPrint('StudentApiService: fetchModuleDetail error - ${e.message}');
      rethrow;
    }
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
