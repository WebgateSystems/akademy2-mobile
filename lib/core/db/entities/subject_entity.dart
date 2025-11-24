import 'package:isar/isar.dart';

part 'subject_entity.g.dart';

@collection
class SubjectEntity {
  SubjectEntity();

  Id isarId = Isar.autoIncrement;

  /// UUID from backend
  @Index(unique: true, replace: true)
  late String id;

  @Index(caseSensitive: false)
  late String title;

  String? description;

  @Index()
  late int order;

  late int moduleCount;

  @Index()
  late DateTime updatedAt;

  List<String> moduleIds = [];

  factory SubjectEntity.fromJson(Map<String, dynamic> json) {
    return SubjectEntity()
      ..id = json['id'] as String? ?? ''
      ..title = json['title'] as String? ?? ''
      ..description = json['description'] as String?
      ..order = json['order'] as int? ?? 0
      ..moduleCount = json['moduleCount'] as int? ?? 0
      ..updatedAt = json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now()
      ..moduleIds = (json['moduleIds'] as List?)?.cast<String>() ?? [];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'order': order,
        'moduleCount': moduleCount,
        'updatedAt': updatedAt.toIso8601String(),
        'moduleIds': moduleIds,
      };
}
