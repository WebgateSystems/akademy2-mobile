class SchoolVideo {
  SchoolVideo({
    required this.id,
    required this.title,
    required this.description,
    required this.subjectId,
    required this.status,
    required this.url,
  });

  final String id;
  final String title;
  final String description;
  final String subjectId;
  final String status; // pending, approved
  final String url;

  factory SchoolVideo.fromJson(Map<String, dynamic> json) {
    return SchoolVideo(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      subjectId: json['subjectId'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      url: json['url'] as String? ?? '',
    );
  }
}
