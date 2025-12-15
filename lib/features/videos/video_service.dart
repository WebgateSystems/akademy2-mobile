import 'package:dio/dio.dart';

import '../../core/auth/join_repository.dart';
import '../../core/network/api_endpoints.dart';
import 'video_models.dart';

class VideoService {
  VideoService({Dio? dio}) : _dio = dio ?? DioProviderSingleton.dio;
  final Dio _dio;

  Future<VideosResponse> fetchVideos({
    int page = 1,
    int perPage = 20,
    String? subjectId,
    String? query,
  }) async {
    final trimmedQuery = query?.trim();
    final resp = await _dio.get(ApiEndpoints.studentVideos, queryParameters: {
      'page': page,
      'per_page': perPage,
      if (subjectId != null && subjectId.isNotEmpty) 'subject_id': subjectId,
      if (trimmedQuery != null && trimmedQuery.isNotEmpty) 'q': trimmedQuery,
    });
    return VideosResponse.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<VideosResponse> fetchMyVideos({
    int page = 1,
    int perPage = 20,
    String? subjectId,
    String? query,
  }) async {
    final trimmedQuery = query?.trim();
    final resp = await _dio.get(ApiEndpoints.studentVideosMy, queryParameters: {
      'page': page,
      'per_page': perPage,
      if (subjectId != null && subjectId.isNotEmpty) 'subject_id': subjectId,
      if (trimmedQuery != null && trimmedQuery.isNotEmpty) 'q': trimmedQuery,
    });
    return VideosResponse.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<void> addVideo({
    required String title,
    required String subjectId,
    required String filePath,
    String? description,
  }) async {
    final formData = FormData.fromMap({
      'video[title]': title,
      'video[subject_id]': subjectId,
      if (description != null && description.isNotEmpty)
        'video[description]': description,
      'video[file]': await MultipartFile.fromFile(
        filePath,
        filename: filePath.split('/').last,
      ),
    });

    await _dio.post(
      ApiEndpoints.studentVideos,
      data: formData,
    );
  }

  Future<void> deleteVideo(String id) async {
    await _dio.delete(ApiEndpoints.studentVideo(id));
  }

  Future<void> toggleLike(String id) async {
    await _dio.post(ApiEndpoints.studentVideoLike(id));
  }

  Future<List<VideoSubjectFilter>> fetchSubjects() async {
    final resp = await _dio.get(ApiEndpoints.studentVideoSubjects);
    final response =
        SubjectsResponse.fromJson(resp.data as Map<String, dynamic>);
    return response.data;
  }

  Future<VideoDetail> fetchVideoById(String id) async {
    final resp = await _dio.get(ApiEndpoints.studentVideo(id));
    final response =
        VideoDetailResponse.fromJson(resp.data as Map<String, dynamic>);
    return response.data;
  }

  Future<void> updateVideo({
    required String id,
    required String title,
    String? description,
  }) async {
    await _dio.patch(
      ApiEndpoints.studentVideo(id),
      data: {
        'video': {
          'title': title,
          if (description != null) 'description': description,
        },
      },
    );
  }
}
