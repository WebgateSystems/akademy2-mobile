import '../../core/auth/join_repository.dart';
import 'package:dio/dio.dart';

import 'video_models.dart';

class VideoService {
  VideoService({Dio? dio}) : _dio = dio ?? DioProviderSingleton.dio;
  final Dio _dio;

  Future<List<SchoolVideo>> fetchVideos({String? subjectId, String? query}) async {
    final resp = await _dio.get('/v1/videos', queryParameters: {
      if (subjectId != null && subjectId.isNotEmpty) 'subjectId': subjectId,
      if (query != null && query.isNotEmpty) 'q': query,
    });
    final list = (resp.data['videos'] as List<dynamic>? ?? [])
        .map((e) => SchoolVideo.fromJson(e as Map<String, dynamic>))
        .toList();
    return list;
  }

  Future<SchoolVideo> addVideo({
    required String title,
    required String description,
    required String subjectId,
    required String filePath,
  }) async {
    final resp = await _dio.post(
      '/v1/videos',
      data: {
        'title': title,
        'description': description,
        'subjectId': subjectId,
        'filePath': filePath,
      },
    );
    return SchoolVideo.fromJson(resp.data['video'] as Map<String, dynamic>);
  }

  Future<void> deleteVideo(String id) async {
    await _dio.delete('/v1/videos/$id');
  }
}
