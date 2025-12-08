import 'package:isar_plus/isar_plus.dart';

part 'subject_entity.g.dart';

@Collection()
class SubjectEntity {
  SubjectEntity();

  @Id()
  var isarId = 0;

  @Index(unique: true)
  late String id;

  String? type;

  @Index()
  late String title;

  @Index()
  String slug = '';

  @Index()
  late int orderIndex;

  String? iconUrl;
  String? colorLight;
  String? colorDark;
  DateTime? createdAt;

  String? unitId;
  String? unitTitle;
  int unitOrderIndex = 0;
  String? learningModuleId;
  String? learningModuleTitle;
  int learningModuleOrderIndex = 0;
  bool learningModulePublished = false;
  bool learningModuleSingleFlow = false;

  late int moduleCount;

  @Index()
  late DateTime updatedAt;

  List<String> moduleIds = [];

  factory SubjectEntity.fromJson(Map<String, dynamic> json) {
    final attrs = json['attributes'] as Map<String, dynamic>? ?? json;
    final unit = attrs['unit'] as Map<String, dynamic>?;
    final learningModule = unit?['learning_module'] as Map<String, dynamic>?;
    return SubjectEntity()
      ..id = attrs['id'] as String? ?? json['id'] as String? ?? ''
      ..type = json['type'] as String?
      ..title = attrs['title'] as String? ?? ''
      ..slug = attrs['slug'] as String? ?? ''
      ..orderIndex = attrs['order_index'] as int? ?? 0
      ..iconUrl = attrs['icon_url'] as String?
      ..colorLight = attrs['color_light'] as String?
      ..colorDark = attrs['color_dark'] as String?
      ..createdAt = _parseDate(attrs['created_at'])
      ..unitId = unit?['id'] as String?
      ..unitTitle = unit?['title'] as String?
      ..unitOrderIndex = unit?['order_index'] as int? ?? 0
      ..learningModuleId = learningModule?['id'] as String?
      ..learningModuleTitle = learningModule?['title'] as String?
      ..learningModuleOrderIndex = learningModule?['order_index'] as int? ?? 0
      ..learningModulePublished = learningModule?['published'] as bool? ?? false
      ..learningModuleSingleFlow =
          learningModule?['single_flow'] as bool? ?? false
      ..moduleCount = attrs['moduleCount'] as int? ?? 0
      ..updatedAt = attrs['updatedAt'] != null
          ? DateTime.parse(attrs['updatedAt'] as String)
          : DateTime.now()
      ..moduleIds = (attrs['moduleIds'] as List?)?.cast<String>() ?? [];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'slug': slug,
        'order_index': orderIndex,
        'icon_url': iconUrl,
        'color_light': colorLight,
        'color_dark': colorDark,
        'created_at': createdAt?.toIso8601String(),
        'unit_id': unitId,
        'unit_title': unitTitle,
        'unit_order_index': unitOrderIndex,
        'learning_module_id': learningModuleId,
        'learning_module_title': learningModuleTitle,
        'learning_module_order_index': learningModuleOrderIndex,
        'learning_module_published': learningModulePublished,
        'learning_module_single_flow': learningModuleSingleFlow,
        'moduleCount': moduleCount,
        'updatedAt': updatedAt.toIso8601String(),
        'moduleIds': moduleIds,
      };
}

DateTime? _parseDate(dynamic value) {
  if (value is String) {
    try {
      return DateTime.parse(value);
    } catch (_) {
      return null;
    }
  }
  return null;
}
