import 'package:isar/isar.dart';

part 'module_entity.g.dart';

@collection
class ModuleEntity {
  ModuleEntity();

  Id isarId = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String id;

  @Index()
  late String subjectId;

  @Index(caseSensitive: false)
  late String title;

  String? description;

  @Index()
  late int order;

  late bool singleFlow;
  bool published = false;

  @Index()
  late DateTime updatedAt;

  List<String> contentIds = [];

  factory ModuleEntity.fromJson(Map<String, dynamic> json) {
    return ModuleEntity()
      ..id = json['id'] as String? ?? ''
      ..subjectId = json['subjectId'] as String? ?? ''
      ..title = json['title'] as String? ?? ''
      ..description = json['description'] as String?
      ..order = json['order'] as int? ?? 0
      ..singleFlow = json['singleFlow'] as bool? ?? false
      ..published = json['published'] as bool? ?? false
      ..updatedAt = json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now()
      ..contentIds = (json['contentIds'] as List?)?.cast<String>() ?? [];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subjectId': subjectId,
        'title': title,
        'description': description,
        'order': order,
        'singleFlow': singleFlow,
        'published': published,
        'updatedAt': updatedAt.toIso8601String(),
        'contentIds': contentIds,
      };
}
