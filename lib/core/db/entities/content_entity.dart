import 'dart:convert';

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

  late String type;

  @Index()
  late String title;

  String? description;
  late int durationSec;
  late int order;
  String? youtubeUrl;
  String? fileUrl;
  String? fileHash;
  String? fileFormat;
  String? posterUrl;
  String? subtitlesUrl;
  String? payloadJson;
  String? learningModuleId;
  String? learningModuleTitle;
  int bestScore = 0;

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
      ..youtubeUrl = (json['youtubeUrl'] ?? json['youtube_url']) as String?
      ..fileUrl = (json['fileUrl'] ?? json['file_url']) as String?
      ..fileHash = (json['fileHash'] ?? json['file_hash']) as String?
      ..fileFormat = (json['fileFormat'] ?? json['file_format']) as String?
      ..posterUrl = (json['posterUrl'] ?? json['poster_url']) as String?
      ..subtitlesUrl =
          (json['subtitlesUrl'] ?? json['subtitles_url']) as String?
      ..payloadJson = _encodePayload(json['payload'])
      ..learningModuleId =
          (json['learningModuleId'] ?? json['learning_module_id']) as String?
      ..learningModuleTitle = (json['learningModuleTitle'] ??
          json['learning_module_title']) as String?
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
        'youtubeUrl': youtubeUrl,
        'fileUrl': fileUrl,
        'fileHash': fileHash,
        'fileFormat': fileFormat,
        'posterUrl': posterUrl,
        'subtitlesUrl': subtitlesUrl,
        'payload': payloadJson != null ? jsonDecode(payloadJson!) : null,
        'learningModuleId': learningModuleId,
        'learningModuleTitle': learningModuleTitle,
        'bestScore': bestScore,
        'updatedAt': updatedAt.toIso8601String(),
        'downloaded': downloaded,
        'downloadPath': downloadPath,
      };
}

String? _encodePayload(dynamic payload) {
  if (payload == null) return null;
  try {
    return jsonEncode(payload);
  } catch (_) {
    return null;
  }
}
