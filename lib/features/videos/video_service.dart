import 'package:dio/dio.dart';

import '../../core/auth/join_repository.dart';
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
    final resp = await _dio.get('v1/student/videos', queryParameters: {
      'page': page,
      'per_page': perPage,
      if (subjectId != null && subjectId.isNotEmpty) 'subject_id': subjectId,
      if (query != null && query.isNotEmpty) 'q': query,
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
      'v1/student/videos',
      data: formData,
    );
  }

  Future<void> deleteVideo(String id) async {
    await _dio.delete('v1/student/videos/$id');
  }

  /// Toggle like on video (POST)
  Future<void> toggleLike(String id) async {
    await _dio.post('v1/student/videos/$id/like');
  }

  /// Get available subjects for filtering
  Future<List<VideoSubjectFilter>> fetchSubjects() async {
    final resp = await _dio.get('v1/student/videos/subjects');
    final response =
        SubjectsResponse.fromJson(resp.data as Map<String, dynamic>);
    return response.data;
  }

  /// Get single video details by ID
  Future<VideoDetail> fetchVideoById(String id) async {
    final resp = await _dio.get('v1/student/videos/$id');
    final response =
        VideoDetailResponse.fromJson(resp.data as Map<String, dynamic>);
    return response.data;
  }

  /// Update own pending video (title and description only)
  Future<void> updateVideo({
    required String id,
    required String title,
    String? description,
  }) async {
    await _dio.patch(
      'v1/student/videos/$id',
      data: {
        'video': {
          'title': title,
          if (description != null) 'description': description,
        },
      },
    );
  }
}
