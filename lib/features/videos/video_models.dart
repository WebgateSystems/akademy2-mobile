class VideoAuthor {
  VideoAuthor({
    required this.id,
    required this.name,
    required this.isMe,
  });

  final String id;
  final String name;
  final bool isMe;

  factory VideoAuthor.fromJson(Map<String, dynamic> json) {
    return VideoAuthor(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      isMe: json['is_me'] as bool? ?? false,
    );
  }
}

/// Model for single video details from GET /v1/student/videos/{id}
class VideoDetail {
  VideoDetail({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.author,
  });

  final String id;
  final String title;
  final String description;
  final String status;
  final VideoAuthor? author;

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';

  factory VideoDetail.fromJson(Map<String, dynamic> json) {
    return VideoDetail(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      status: json['status'] as String? ?? 'approved',
      author: json['author'] != null
          ? VideoAuthor.fromJson(json['author'] as Map<String, dynamic>)
          : null,
    );
  }
}

/// Response wrapper for single video details
class VideoDetailResponse {
  VideoDetailResponse({
    required this.success,
    required this.data,
  });

  final bool success;
  final VideoDetail data;

  factory VideoDetailResponse.fromJson(Map<String, dynamic> json) {
    return VideoDetailResponse(
      success: json['success'] as bool? ?? false,
      data: VideoDetail.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class VideoSubject {
  VideoSubject({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;

  factory VideoSubject.fromJson(Map<String, dynamic> json) {
    return VideoSubject(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
    );
  }
}

class VideoSchool {
  VideoSchool({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  factory VideoSchool.fromJson(Map<String, dynamic> json) {
    return VideoSchool(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }
}

class SchoolVideo {
  SchoolVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.fileUrl,
    required this.thumbnailUrl,
    required this.youtubeUrl,
    required this.durationSec,
    required this.likesCount,
    required this.likedByMe,
    required this.author,
    required this.subject,
    required this.school,
    required this.createdAt,
    required this.canDelete,
  });

  final String id;
  final String title;
  final String description;
  final String fileUrl;
  final String thumbnailUrl;
  final String youtubeUrl;
  final int durationSec;
  final int likesCount;
  final bool likedByMe;
  final VideoAuthor? author;
  final VideoSubject? subject;
  final VideoSchool? school;
  final DateTime? createdAt;
  final bool canDelete;

  // Compatibility getters
  String get subjectId => subject?.id ?? '';
  String get url => fileUrl.isNotEmpty ? fileUrl : youtubeUrl;
  int? get likes => likesCount;
  bool get liked => likedByMe;

  factory SchoolVideo.fromJson(Map<String, dynamic> json) {
    return SchoolVideo(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      fileUrl: json['file_url'] as String? ?? '',
      thumbnailUrl: json['thumbnail_url'] as String? ?? '',
      youtubeUrl: json['youtube_url'] as String? ?? '',
      durationSec: _asInt(json['duration_sec']),
      likesCount: _asInt(json['likes_count']),
      likedByMe: json['liked_by_me'] as bool? ?? false,
      author: json['author'] != null
          ? VideoAuthor.fromJson(json['author'] as Map<String, dynamic>)
          : null,
      subject: json['subject'] != null
          ? VideoSubject.fromJson(json['subject'] as Map<String, dynamic>)
          : null,
      school: json['school'] != null
          ? VideoSchool.fromJson(json['school'] as Map<String, dynamic>)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      canDelete: json['can_delete'] as bool? ?? false,
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}

class VideosMeta {
  VideosMeta({
    required this.page,
    required this.perPage,
    required this.total,
    required this.totalPages,
  });

  final int page;
  final int perPage;
  final int total;
  final int totalPages;

  bool get hasMore => page < totalPages;

  factory VideosMeta.fromJson(Map<String, dynamic> json) {
    return VideosMeta(
      page: json['page'] as int? ?? 0,
      perPage: json['per_page'] as int? ?? 20,
      total: json['total'] as int? ?? 0,
      totalPages: json['total_pages'] as int? ?? 0,
    );
  }
}

class VideosResponse {
  VideosResponse({
    required this.success,
    required this.data,
    required this.meta,
  });

  final bool success;
  final List<SchoolVideo> data;
  final VideosMeta meta;

  factory VideosResponse.fromJson(Map<String, dynamic> json) {
    return VideosResponse(
      success: json['success'] as bool? ?? false,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => SchoolVideo.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: VideosMeta.fromJson(json['meta'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class VideoSubjectFilter {
  VideoSubjectFilter({
    required this.id,
    required this.title,
    required this.slug,
  });

  final String id;
  final String title;
  final String slug;

  factory VideoSubjectFilter.fromJson(Map<String, dynamic> json) {
    return VideoSubjectFilter(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
    );
  }
}

class SubjectsResponse {
  SubjectsResponse({
    required this.success,
    required this.data,
  });

  final bool success;
  final List<VideoSubjectFilter> data;

  factory SubjectsResponse.fromJson(Map<String, dynamic> json) {
    return SubjectsResponse(
      success: json['success'] as bool? ?? false,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => VideoSubjectFilter.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
