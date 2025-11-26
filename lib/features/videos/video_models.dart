class SchoolVideo {
  SchoolVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.subjectId,
    required this.status,
    required this.url,
    required this.likes,
    required this.thumbnailUrl,
    required this.liked,
  });

  final String id;
  final String title;
  final String description;
  final String subjectId;
  final String status; // pending, approved
  final String url;
  final int? likes;
  final String thumbnailUrl;
  final bool liked;

  factory SchoolVideo.fromJson(Map<String, dynamic> json) {
    return SchoolVideo(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      subjectId: json['subjectId'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      url: json['url'] as String? ?? '',
      likes: _asInt(json['likes']),
      thumbnailUrl: json['thumbnailUrl'] as String? ?? '',
      liked: json['liked'] as bool? ?? false,
    );
  }

  static int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }
}
