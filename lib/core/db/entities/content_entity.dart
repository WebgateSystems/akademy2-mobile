import 'package:isar_plus/isar_plus.dart';

part 'content_entity.g.dart';

@Collection()
class ContentEntity {
  ContentEntity();

  @Id()
  var isarId = 0;

  @Index(unique: true)
  late String id;

  @Index()
  late String moduleId;

  late String type; // video, infographic, quiz, pdf

  @Index()
  late String title;

  String? description;
  late int durationSec;
  late int order;

  @Index()
  late DateTime updatedAt;

  bool downloaded = false;
  String downloadPath = '';

  factory ContentEntity.fromJson(Map<String, dynamic> json) {
    return ContentEntity()
      ..id = json['id'] as String? ?? ''
      ..moduleId = json['moduleId'] as String? ?? ''
      ..type = json['type'] as String? ?? 'video'
      ..title = json['title'] as String? ?? ''
      ..description = json['description'] as String?
      ..durationSec = json['durationSec'] as int? ?? 0
      ..order = json['order'] as int? ?? 0
      ..updatedAt = json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now()
      ..downloaded = json['downloaded'] as bool? ?? false
      ..downloadPath = json['downloadPath'] as String? ?? '';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'moduleId': moduleId,
        'type': type,
        'title': title,
        'description': description,
        'durationSec': durationSec,
        'order': order,
        'updatedAt': updatedAt.toIso8601String(),
        'downloaded': downloaded,
        'downloadPath': downloadPath,
      };
}
