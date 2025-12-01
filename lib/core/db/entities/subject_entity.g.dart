// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_entity.dart';

// **************************************************************************
// _IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, invalid_use_of_protected_member, lines_longer_than_80_chars, constant_identifier_names, avoid_js_rounded_ints, no_leading_underscores_for_local_identifiers, require_trailing_commas, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_in_if_null_operators, library_private_types_in_public_api, prefer_const_constructors
// ignore_for_file: type=lint

extension GetSubjectEntityCollection on Isar {
  IsarCollection<int, SubjectEntity> get subjectEntitys => this.collection();
}

final SubjectEntitySchema = IsarGeneratedSchema(
  schema: IsarSchema(
    name: 'SubjectEntity',
    idName: 'isarId',
    embedded: false,
    properties: [
      IsarPropertySchema(
        name: 'id',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'type',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'title',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'slug',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'orderIndex',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'iconUrl',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'colorLight',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'colorDark',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'createdAt',
        type: IsarType.dateTime,
      ),
      IsarPropertySchema(
        name: 'unitId',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'unitTitle',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'unitOrderIndex',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'learningModuleId',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'learningModuleTitle',
        type: IsarType.string,
      ),
      IsarPropertySchema(
        name: 'learningModuleOrderIndex',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'learningModulePublished',
        type: IsarType.bool,
      ),
      IsarPropertySchema(
        name: 'learningModuleSingleFlow',
        type: IsarType.bool,
      ),
      IsarPropertySchema(
        name: 'moduleCount',
        type: IsarType.long,
      ),
      IsarPropertySchema(
        name: 'updatedAt',
        type: IsarType.dateTime,
      ),
      IsarPropertySchema(
        name: 'moduleIds',
        type: IsarType.stringList,
      ),
    ],
    indexes: [
      IsarIndexSchema(
        name: 'id',
        properties: [
          "id",
        ],
        unique: true,
        hash: false,
      ),
      IsarIndexSchema(
        name: 'title',
        properties: [
          "title",
        ],
        unique: false,
        hash: false,
      ),
      IsarIndexSchema(
        name: 'slug',
        properties: [
          "slug",
        ],
        unique: false,
        hash: false,
      ),
      IsarIndexSchema(
        name: 'orderIndex',
        properties: [
          "orderIndex",
        ],
        unique: false,
        hash: false,
      ),
      IsarIndexSchema(
        name: 'updatedAt',
        properties: [
          "updatedAt",
        ],
        unique: false,
        hash: false,
      ),
    ],
  ),
  converter: IsarObjectConverter<int, SubjectEntity>(
    serialize: serializeSubjectEntity,
    deserialize: deserializeSubjectEntity,
    deserializeProperty: deserializeSubjectEntityProp,
  ),
  getEmbeddedSchemas: () => [],
);

@isarProtected
int serializeSubjectEntity(IsarWriter writer, SubjectEntity object) {
  IsarCore.writeString(writer, 1, object.id);
  {
    final value = object.type;
    if (value == null) {
      IsarCore.writeNull(writer, 2);
    } else {
      IsarCore.writeString(writer, 2, value);
    }
  }
  IsarCore.writeString(writer, 3, object.title);
  IsarCore.writeString(writer, 4, object.slug);
  IsarCore.writeLong(writer, 5, object.orderIndex);
  {
    final value = object.iconUrl;
    if (value == null) {
      IsarCore.writeNull(writer, 6);
    } else {
      IsarCore.writeString(writer, 6, value);
    }
  }
  {
    final value = object.colorLight;
    if (value == null) {
      IsarCore.writeNull(writer, 7);
    } else {
      IsarCore.writeString(writer, 7, value);
    }
  }
  {
    final value = object.colorDark;
    if (value == null) {
      IsarCore.writeNull(writer, 8);
    } else {
      IsarCore.writeString(writer, 8, value);
    }
  }
  IsarCore.writeLong(writer, 9,
      object.createdAt?.toUtc().microsecondsSinceEpoch ?? -9223372036854775808);
  {
    final value = object.unitId;
    if (value == null) {
      IsarCore.writeNull(writer, 10);
    } else {
      IsarCore.writeString(writer, 10, value);
    }
  }
  {
    final value = object.unitTitle;
    if (value == null) {
      IsarCore.writeNull(writer, 11);
    } else {
      IsarCore.writeString(writer, 11, value);
    }
  }
  IsarCore.writeLong(writer, 12, object.unitOrderIndex);
  {
    final value = object.learningModuleId;
    if (value == null) {
      IsarCore.writeNull(writer, 13);
    } else {
      IsarCore.writeString(writer, 13, value);
    }
  }
  {
    final value = object.learningModuleTitle;
    if (value == null) {
      IsarCore.writeNull(writer, 14);
    } else {
      IsarCore.writeString(writer, 14, value);
    }
  }
  IsarCore.writeLong(writer, 15, object.learningModuleOrderIndex);
  IsarCore.writeBool(writer, 16, value: object.learningModulePublished);
  IsarCore.writeBool(writer, 17, value: object.learningModuleSingleFlow);
  IsarCore.writeLong(writer, 18, object.moduleCount);
  IsarCore.writeLong(
      writer, 19, object.updatedAt.toUtc().microsecondsSinceEpoch);
  {
    final list = object.moduleIds;
    final listWriter = IsarCore.beginList(writer, 20, list.length);
    for (var i = 0; i < list.length; i++) {
      IsarCore.writeString(listWriter, i, list[i]);
    }
    IsarCore.endList(writer, listWriter);
  }
  return object.isarId;
}

@isarProtected
SubjectEntity deserializeSubjectEntity(IsarReader reader) {
  final object = SubjectEntity();
  object.isarId = IsarCore.readId(reader);
  object.id = IsarCore.readString(reader, 1) ?? '';
  object.type = IsarCore.readString(reader, 2);
  object.title = IsarCore.readString(reader, 3) ?? '';
  object.slug = IsarCore.readString(reader, 4) ?? '';
  object.orderIndex = IsarCore.readLong(reader, 5);
  object.iconUrl = IsarCore.readString(reader, 6);
  object.colorLight = IsarCore.readString(reader, 7);
  object.colorDark = IsarCore.readString(reader, 8);
  {
    final value = IsarCore.readLong(reader, 9);
    if (value == -9223372036854775808) {
      object.createdAt = null;
    } else {
      object.createdAt =
          DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true).toLocal();
    }
  }
  object.unitId = IsarCore.readString(reader, 10);
  object.unitTitle = IsarCore.readString(reader, 11);
  object.unitOrderIndex = IsarCore.readLong(reader, 12);
  object.learningModuleId = IsarCore.readString(reader, 13);
  object.learningModuleTitle = IsarCore.readString(reader, 14);
  object.learningModuleOrderIndex = IsarCore.readLong(reader, 15);
  object.learningModulePublished = IsarCore.readBool(reader, 16);
  object.learningModuleSingleFlow = IsarCore.readBool(reader, 17);
  object.moduleCount = IsarCore.readLong(reader, 18);
  {
    final value = IsarCore.readLong(reader, 19);
    if (value == -9223372036854775808) {
      object.updatedAt =
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
    } else {
      object.updatedAt =
          DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true).toLocal();
    }
  }
  {
    final length = IsarCore.readList(reader, 20, IsarCore.readerPtrPtr);
    {
      final reader = IsarCore.readerPtr;
      if (reader.isNull) {
        object.moduleIds = const <String>[];
      } else {
        final list = List<String>.filled(length, '', growable: true);
        for (var i = 0; i < length; i++) {
          list[i] = IsarCore.readString(reader, i) ?? '';
        }
        IsarCore.freeReader(reader);
        object.moduleIds = list;
      }
    }
  }
  return object;
}

@isarProtected
dynamic deserializeSubjectEntityProp(IsarReader reader, int property) {
  switch (property) {
    case 0:
      return IsarCore.readId(reader);
    case 1:
      return IsarCore.readString(reader, 1) ?? '';
    case 2:
      return IsarCore.readString(reader, 2);
    case 3:
      return IsarCore.readString(reader, 3) ?? '';
    case 4:
      return IsarCore.readString(reader, 4) ?? '';
    case 5:
      return IsarCore.readLong(reader, 5);
    case 6:
      return IsarCore.readString(reader, 6);
    case 7:
      return IsarCore.readString(reader, 7);
    case 8:
      return IsarCore.readString(reader, 8);
    case 9:
      {
        final value = IsarCore.readLong(reader, 9);
        if (value == -9223372036854775808) {
          return null;
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true)
              .toLocal();
        }
      }
    case 10:
      return IsarCore.readString(reader, 10);
    case 11:
      return IsarCore.readString(reader, 11);
    case 12:
      return IsarCore.readLong(reader, 12);
    case 13:
      return IsarCore.readString(reader, 13);
    case 14:
      return IsarCore.readString(reader, 14);
    case 15:
      return IsarCore.readLong(reader, 15);
    case 16:
      return IsarCore.readBool(reader, 16);
    case 17:
      return IsarCore.readBool(reader, 17);
    case 18:
      return IsarCore.readLong(reader, 18);
    case 19:
      {
        final value = IsarCore.readLong(reader, 19);
        if (value == -9223372036854775808) {
          return DateTime.fromMillisecondsSinceEpoch(0, isUtc: true).toLocal();
        } else {
          return DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true)
              .toLocal();
        }
      }
    case 20:
      {
        final length = IsarCore.readList(reader, 20, IsarCore.readerPtrPtr);
        {
          final reader = IsarCore.readerPtr;
          if (reader.isNull) {
            return const <String>[];
          } else {
            final list = List<String>.filled(length, '', growable: true);
            for (var i = 0; i < length; i++) {
              list[i] = IsarCore.readString(reader, i) ?? '';
            }
            IsarCore.freeReader(reader);
            return list;
          }
        }
      }
    default:
      throw ArgumentError('Unknown property: $property');
  }
}

sealed class _SubjectEntityUpdate {
  bool call({
    required int isarId,
    String? id,
    String? type,
    String? title,
    String? slug,
    int? orderIndex,
    String? iconUrl,
    String? colorLight,
    String? colorDark,
    DateTime? createdAt,
    String? unitId,
    String? unitTitle,
    int? unitOrderIndex,
    String? learningModuleId,
    String? learningModuleTitle,
    int? learningModuleOrderIndex,
    bool? learningModulePublished,
    bool? learningModuleSingleFlow,
    int? moduleCount,
    DateTime? updatedAt,
  });
}

class _SubjectEntityUpdateImpl implements _SubjectEntityUpdate {
  const _SubjectEntityUpdateImpl(this.collection);

  final IsarCollection<int, SubjectEntity> collection;

  @override
  bool call({
    required int isarId,
    Object? id = ignore,
    Object? type = ignore,
    Object? title = ignore,
    Object? slug = ignore,
    Object? orderIndex = ignore,
    Object? iconUrl = ignore,
    Object? colorLight = ignore,
    Object? colorDark = ignore,
    Object? createdAt = ignore,
    Object? unitId = ignore,
    Object? unitTitle = ignore,
    Object? unitOrderIndex = ignore,
    Object? learningModuleId = ignore,
    Object? learningModuleTitle = ignore,
    Object? learningModuleOrderIndex = ignore,
    Object? learningModulePublished = ignore,
    Object? learningModuleSingleFlow = ignore,
    Object? moduleCount = ignore,
    Object? updatedAt = ignore,
  }) {
    return collection.updateProperties([
          isarId
        ], {
          if (id != ignore) 1: id as String?,
          if (type != ignore) 2: type as String?,
          if (title != ignore) 3: title as String?,
          if (slug != ignore) 4: slug as String?,
          if (orderIndex != ignore) 5: orderIndex as int?,
          if (iconUrl != ignore) 6: iconUrl as String?,
          if (colorLight != ignore) 7: colorLight as String?,
          if (colorDark != ignore) 8: colorDark as String?,
          if (createdAt != ignore) 9: createdAt as DateTime?,
          if (unitId != ignore) 10: unitId as String?,
          if (unitTitle != ignore) 11: unitTitle as String?,
          if (unitOrderIndex != ignore) 12: unitOrderIndex as int?,
          if (learningModuleId != ignore) 13: learningModuleId as String?,
          if (learningModuleTitle != ignore) 14: learningModuleTitle as String?,
          if (learningModuleOrderIndex != ignore)
            15: learningModuleOrderIndex as int?,
          if (learningModulePublished != ignore)
            16: learningModulePublished as bool?,
          if (learningModuleSingleFlow != ignore)
            17: learningModuleSingleFlow as bool?,
          if (moduleCount != ignore) 18: moduleCount as int?,
          if (updatedAt != ignore) 19: updatedAt as DateTime?,
        }) >
        0;
  }
}

sealed class _SubjectEntityUpdateAll {
  int call({
    required List<int> isarId,
    String? id,
    String? type,
    String? title,
    String? slug,
    int? orderIndex,
    String? iconUrl,
    String? colorLight,
    String? colorDark,
    DateTime? createdAt,
    String? unitId,
    String? unitTitle,
    int? unitOrderIndex,
    String? learningModuleId,
    String? learningModuleTitle,
    int? learningModuleOrderIndex,
    bool? learningModulePublished,
    bool? learningModuleSingleFlow,
    int? moduleCount,
    DateTime? updatedAt,
  });
}

class _SubjectEntityUpdateAllImpl implements _SubjectEntityUpdateAll {
  const _SubjectEntityUpdateAllImpl(this.collection);

  final IsarCollection<int, SubjectEntity> collection;

  @override
  int call({
    required List<int> isarId,
    Object? id = ignore,
    Object? type = ignore,
    Object? title = ignore,
    Object? slug = ignore,
    Object? orderIndex = ignore,
    Object? iconUrl = ignore,
    Object? colorLight = ignore,
    Object? colorDark = ignore,
    Object? createdAt = ignore,
    Object? unitId = ignore,
    Object? unitTitle = ignore,
    Object? unitOrderIndex = ignore,
    Object? learningModuleId = ignore,
    Object? learningModuleTitle = ignore,
    Object? learningModuleOrderIndex = ignore,
    Object? learningModulePublished = ignore,
    Object? learningModuleSingleFlow = ignore,
    Object? moduleCount = ignore,
    Object? updatedAt = ignore,
  }) {
    return collection.updateProperties(isarId, {
      if (id != ignore) 1: id as String?,
      if (type != ignore) 2: type as String?,
      if (title != ignore) 3: title as String?,
      if (slug != ignore) 4: slug as String?,
      if (orderIndex != ignore) 5: orderIndex as int?,
      if (iconUrl != ignore) 6: iconUrl as String?,
      if (colorLight != ignore) 7: colorLight as String?,
      if (colorDark != ignore) 8: colorDark as String?,
      if (createdAt != ignore) 9: createdAt as DateTime?,
      if (unitId != ignore) 10: unitId as String?,
      if (unitTitle != ignore) 11: unitTitle as String?,
      if (unitOrderIndex != ignore) 12: unitOrderIndex as int?,
      if (learningModuleId != ignore) 13: learningModuleId as String?,
      if (learningModuleTitle != ignore) 14: learningModuleTitle as String?,
      if (learningModuleOrderIndex != ignore)
        15: learningModuleOrderIndex as int?,
      if (learningModulePublished != ignore)
        16: learningModulePublished as bool?,
      if (learningModuleSingleFlow != ignore)
        17: learningModuleSingleFlow as bool?,
      if (moduleCount != ignore) 18: moduleCount as int?,
      if (updatedAt != ignore) 19: updatedAt as DateTime?,
    });
  }
}

extension SubjectEntityUpdate on IsarCollection<int, SubjectEntity> {
  _SubjectEntityUpdate get update => _SubjectEntityUpdateImpl(this);

  _SubjectEntityUpdateAll get updateAll => _SubjectEntityUpdateAllImpl(this);
}

sealed class _SubjectEntityQueryUpdate {
  int call({
    String? id,
    String? type,
    String? title,
    String? slug,
    int? orderIndex,
    String? iconUrl,
    String? colorLight,
    String? colorDark,
    DateTime? createdAt,
    String? unitId,
    String? unitTitle,
    int? unitOrderIndex,
    String? learningModuleId,
    String? learningModuleTitle,
    int? learningModuleOrderIndex,
    bool? learningModulePublished,
    bool? learningModuleSingleFlow,
    int? moduleCount,
    DateTime? updatedAt,
  });
}

class _SubjectEntityQueryUpdateImpl implements _SubjectEntityQueryUpdate {
  const _SubjectEntityQueryUpdateImpl(this.query, {this.limit});

  final IsarQuery<SubjectEntity> query;
  final int? limit;

  @override
  int call({
    Object? id = ignore,
    Object? type = ignore,
    Object? title = ignore,
    Object? slug = ignore,
    Object? orderIndex = ignore,
    Object? iconUrl = ignore,
    Object? colorLight = ignore,
    Object? colorDark = ignore,
    Object? createdAt = ignore,
    Object? unitId = ignore,
    Object? unitTitle = ignore,
    Object? unitOrderIndex = ignore,
    Object? learningModuleId = ignore,
    Object? learningModuleTitle = ignore,
    Object? learningModuleOrderIndex = ignore,
    Object? learningModulePublished = ignore,
    Object? learningModuleSingleFlow = ignore,
    Object? moduleCount = ignore,
    Object? updatedAt = ignore,
  }) {
    return query.updateProperties(limit: limit, {
      if (id != ignore) 1: id as String?,
      if (type != ignore) 2: type as String?,
      if (title != ignore) 3: title as String?,
      if (slug != ignore) 4: slug as String?,
      if (orderIndex != ignore) 5: orderIndex as int?,
      if (iconUrl != ignore) 6: iconUrl as String?,
      if (colorLight != ignore) 7: colorLight as String?,
      if (colorDark != ignore) 8: colorDark as String?,
      if (createdAt != ignore) 9: createdAt as DateTime?,
      if (unitId != ignore) 10: unitId as String?,
      if (unitTitle != ignore) 11: unitTitle as String?,
      if (unitOrderIndex != ignore) 12: unitOrderIndex as int?,
      if (learningModuleId != ignore) 13: learningModuleId as String?,
      if (learningModuleTitle != ignore) 14: learningModuleTitle as String?,
      if (learningModuleOrderIndex != ignore)
        15: learningModuleOrderIndex as int?,
      if (learningModulePublished != ignore)
        16: learningModulePublished as bool?,
      if (learningModuleSingleFlow != ignore)
        17: learningModuleSingleFlow as bool?,
      if (moduleCount != ignore) 18: moduleCount as int?,
      if (updatedAt != ignore) 19: updatedAt as DateTime?,
    });
  }
}

extension SubjectEntityQueryUpdate on IsarQuery<SubjectEntity> {
  _SubjectEntityQueryUpdate get updateFirst =>
      _SubjectEntityQueryUpdateImpl(this, limit: 1);

  _SubjectEntityQueryUpdate get updateAll =>
      _SubjectEntityQueryUpdateImpl(this);
}

class _SubjectEntityQueryBuilderUpdateImpl
    implements _SubjectEntityQueryUpdate {
  const _SubjectEntityQueryBuilderUpdateImpl(this.query, {this.limit});

  final QueryBuilder<SubjectEntity, SubjectEntity, QOperations> query;
  final int? limit;

  @override
  int call({
    Object? id = ignore,
    Object? type = ignore,
    Object? title = ignore,
    Object? slug = ignore,
    Object? orderIndex = ignore,
    Object? iconUrl = ignore,
    Object? colorLight = ignore,
    Object? colorDark = ignore,
    Object? createdAt = ignore,
    Object? unitId = ignore,
    Object? unitTitle = ignore,
    Object? unitOrderIndex = ignore,
    Object? learningModuleId = ignore,
    Object? learningModuleTitle = ignore,
    Object? learningModuleOrderIndex = ignore,
    Object? learningModulePublished = ignore,
    Object? learningModuleSingleFlow = ignore,
    Object? moduleCount = ignore,
    Object? updatedAt = ignore,
  }) {
    final q = query.build();
    try {
      return q.updateProperties(limit: limit, {
        if (id != ignore) 1: id as String?,
        if (type != ignore) 2: type as String?,
        if (title != ignore) 3: title as String?,
        if (slug != ignore) 4: slug as String?,
        if (orderIndex != ignore) 5: orderIndex as int?,
        if (iconUrl != ignore) 6: iconUrl as String?,
        if (colorLight != ignore) 7: colorLight as String?,
        if (colorDark != ignore) 8: colorDark as String?,
        if (createdAt != ignore) 9: createdAt as DateTime?,
        if (unitId != ignore) 10: unitId as String?,
        if (unitTitle != ignore) 11: unitTitle as String?,
        if (unitOrderIndex != ignore) 12: unitOrderIndex as int?,
        if (learningModuleId != ignore) 13: learningModuleId as String?,
        if (learningModuleTitle != ignore) 14: learningModuleTitle as String?,
        if (learningModuleOrderIndex != ignore)
          15: learningModuleOrderIndex as int?,
        if (learningModulePublished != ignore)
          16: learningModulePublished as bool?,
        if (learningModuleSingleFlow != ignore)
          17: learningModuleSingleFlow as bool?,
        if (moduleCount != ignore) 18: moduleCount as int?,
        if (updatedAt != ignore) 19: updatedAt as DateTime?,
      });
    } finally {
      q.close();
    }
  }
}

extension SubjectEntityQueryBuilderUpdate
    on QueryBuilder<SubjectEntity, SubjectEntity, QOperations> {
  _SubjectEntityQueryUpdate get updateFirst =>
      _SubjectEntityQueryBuilderUpdateImpl(this, limit: 1);

  _SubjectEntityQueryUpdate get updateAll =>
      _SubjectEntityQueryBuilderUpdateImpl(this);
}

extension SubjectEntityQueryFilter
    on QueryBuilder<SubjectEntity, SubjectEntity, QFilterCondition> {
  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      isarIdEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      isarIdGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      isarIdGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      isarIdLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      isarIdLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 0,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      isarIdBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 0,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      idGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      idGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> idLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      idLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 1,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 1,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 1,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 1,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 2));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      typeIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 2));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> typeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      typeGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      typeGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      typeLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      typeLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> typeBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 2,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 2,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 2,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 2,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 2,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      titleGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      titleLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      titleLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      titleBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 3,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 3,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 3,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 3,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 3,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> slugEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      slugGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      slugGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      slugLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      slugLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> slugBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 4,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      slugStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      slugEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      slugContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 4,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> slugMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 4,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      slugIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 4,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      slugIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 4,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      orderIndexEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      orderIndexGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      orderIndexGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      orderIndexLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      orderIndexLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 5,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      orderIndexBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 5,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 6));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 6));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 6,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 6,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 6,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 6,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 6,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 7));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 7,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 7,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 7,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 7,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 7,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 8));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 8,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 8,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 8,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 8,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 8,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 9));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      createdAtEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 9,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 9,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      createdAtGreaterThanOrEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 9,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      createdAtLessThan(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 9,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      createdAtLessThanOrEqualTo(
    DateTime? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 9,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      createdAtBetween(
    DateTime? lower,
    DateTime? upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 9,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 10));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 10));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 10,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 10,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 10,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 10,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 10,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 11));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 11,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 11,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 11,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 11,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 11,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitOrderIndexEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 12,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitOrderIndexGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 12,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitOrderIndexGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 12,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitOrderIndexLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 12,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitOrderIndexLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 12,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitOrderIndexBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 12,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 13));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 13));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 13,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 13,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 13,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 13,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 13,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const IsNullCondition(property: 14));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleIsNotNull() {
    return QueryBuilder.apply(not(), (query) {
      return query.addFilterCondition(const IsNullCondition(property: 14));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleGreaterThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleGreaterThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleLessThan(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleLessThanOrEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleBetween(
    String? lower,
    String? upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 14,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 14,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 14,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 14,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 14,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleOrderIndexEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 15,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleOrderIndexGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 15,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleOrderIndexGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 15,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleOrderIndexLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 15,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleOrderIndexLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 15,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleOrderIndexBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 15,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModulePublishedEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 16,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleSingleFlowEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 17,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleCountEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 18,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleCountGreaterThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 18,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleCountGreaterThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 18,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleCountLessThan(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 18,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleCountLessThanOrEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 18,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleCountBetween(
    int lower,
    int upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 18,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      updatedAtEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 19,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 19,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      updatedAtGreaterThanOrEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 19,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 19,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      updatedAtLessThanOrEqualTo(
    DateTime value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 19,
          value: value,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 19,
          lower: lower,
          upper: upper,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EqualCondition(
          property: 20,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsElementGreaterThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterCondition(
          property: 20,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsElementGreaterThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        GreaterOrEqualCondition(
          property: 20,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsElementLessThan(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessCondition(
          property: 20,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsElementLessThanOrEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        LessOrEqualCondition(
          property: 20,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsElementBetween(
    String lower,
    String upper, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        BetweenCondition(
          property: 20,
          lower: lower,
          upper: upper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        StartsWithCondition(
          property: 20,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        EndsWithCondition(
          property: 20,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        ContainsCondition(
          property: 20,
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        MatchesCondition(
          property: 20,
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const EqualCondition(
          property: 20,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterCondition(
          property: 20,
          value: '',
        ),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsIsEmpty() {
    return not().moduleIdsIsNotEmpty();
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const GreaterOrEqualCondition(property: 20, value: null),
      );
    });
  }
}

extension SubjectEntityQueryObject
    on QueryBuilder<SubjectEntity, SubjectEntity, QFilterCondition> {}

extension SubjectEntityQuerySortBy
    on QueryBuilder<SubjectEntity, SubjectEntity, QSortBy> {
  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        1,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        2,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByTypeDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        2,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        3,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByTitleDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        3,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortBySlug(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        4,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortBySlugDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        4,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByIconUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        6,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByIconUrlDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        6,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByColorLight(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        7,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByColorLightDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        7,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByColorDark(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        8,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByColorDarkDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        8,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByUnitId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        10,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByUnitIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        10,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByUnitTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        11,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByUnitTitleDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        11,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByUnitOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByUnitOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByLearningModuleId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        13,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByLearningModuleIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        13,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByLearningModuleTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        14,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByLearningModuleTitleDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(
        14,
        sort: Sort.desc,
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByLearningModuleOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByLearningModuleOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, sort: Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByLearningModulePublished() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByLearningModulePublishedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, sort: Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByLearningModuleSingleFlow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByLearningModuleSingleFlowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17, sort: Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByModuleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByModuleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18, sort: Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19, sort: Sort.desc);
    });
  }
}

extension SubjectEntityQuerySortThenBy
    on QueryBuilder<SubjectEntity, SubjectEntity, QSortThenBy> {
  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(0, sort: Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(1, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByTypeDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(2, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByTitleDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(3, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenBySlug(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenBySlugDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(4, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(5, sort: Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByIconUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByIconUrlDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(6, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByColorLight(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByColorLightDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(7, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByColorDark(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByColorDarkDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(8, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(9, sort: Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByUnitId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByUnitIdDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(10, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByUnitTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByUnitTitleDesc(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(11, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByUnitOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByUnitOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(12, sort: Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByLearningModuleId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByLearningModuleIdDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(13, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByLearningModuleTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByLearningModuleTitleDesc({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(14, sort: Sort.desc, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByLearningModuleOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByLearningModuleOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(15, sort: Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByLearningModulePublished() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByLearningModulePublishedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(16, sort: Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByLearningModuleSingleFlow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByLearningModuleSingleFlowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(17, sort: Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByModuleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByModuleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(18, sort: Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(19, sort: Sort.desc);
    });
  }
}

extension SubjectEntityQueryWhereDistinct
    on QueryBuilder<SubjectEntity, SubjectEntity, QDistinct> {
  QueryBuilder<SubjectEntity, SubjectEntity, QAfterDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(1, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(2, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(3, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterDistinct> distinctBySlug(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(4, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterDistinct>
      distinctByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(5);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterDistinct> distinctByIconUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(6, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterDistinct>
      distinctByColorLight({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(7, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterDistinct>
      distinctByColorDark({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(8, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(9);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterDistinct> distinctByUnitId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(10, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterDistinct>
      distinctByUnitTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(11, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterDistinct>
      distinctByUnitOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(12);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterDistinct>
      distinctByLearningModuleId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(13, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterDistinct>
      distinctByLearningModuleTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(14, caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterDistinct>
      distinctByLearningModuleOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(15);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterDistinct>
      distinctByLearningModulePublished() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(16);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterDistinct>
      distinctByLearningModuleSingleFlow() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(17);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterDistinct>
      distinctByModuleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(18);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(19);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterDistinct>
      distinctByModuleIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(20);
    });
  }
}

extension SubjectEntityQueryProperty1
    on QueryBuilder<SubjectEntity, SubjectEntity, QProperty> {
  QueryBuilder<SubjectEntity, int, QAfterProperty> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<SubjectEntity, String, QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<SubjectEntity, String?, QAfterProperty> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<SubjectEntity, String, QAfterProperty> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<SubjectEntity, String, QAfterProperty> slugProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<SubjectEntity, int, QAfterProperty> orderIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<SubjectEntity, String?, QAfterProperty> iconUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<SubjectEntity, String?, QAfterProperty> colorLightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<SubjectEntity, String?, QAfterProperty> colorDarkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<SubjectEntity, DateTime?, QAfterProperty> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<SubjectEntity, String?, QAfterProperty> unitIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<SubjectEntity, String?, QAfterProperty> unitTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<SubjectEntity, int, QAfterProperty> unitOrderIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<SubjectEntity, String?, QAfterProperty>
      learningModuleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<SubjectEntity, String?, QAfterProperty>
      learningModuleTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<SubjectEntity, int, QAfterProperty>
      learningModuleOrderIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<SubjectEntity, bool, QAfterProperty>
      learningModulePublishedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<SubjectEntity, bool, QAfterProperty>
      learningModuleSingleFlowProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<SubjectEntity, int, QAfterProperty> moduleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<SubjectEntity, DateTime, QAfterProperty> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<SubjectEntity, List<String>, QAfterProperty>
      moduleIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }
}

extension SubjectEntityQueryProperty2<R>
    on QueryBuilder<SubjectEntity, R, QAfterProperty> {
  QueryBuilder<SubjectEntity, (R, int), QAfterProperty> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<SubjectEntity, (R, String), QAfterProperty> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<SubjectEntity, (R, String?), QAfterProperty> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<SubjectEntity, (R, String), QAfterProperty> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<SubjectEntity, (R, String), QAfterProperty> slugProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<SubjectEntity, (R, int), QAfterProperty> orderIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<SubjectEntity, (R, String?), QAfterProperty> iconUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<SubjectEntity, (R, String?), QAfterProperty>
      colorLightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<SubjectEntity, (R, String?), QAfterProperty>
      colorDarkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<SubjectEntity, (R, DateTime?), QAfterProperty>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<SubjectEntity, (R, String?), QAfterProperty> unitIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<SubjectEntity, (R, String?), QAfterProperty>
      unitTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<SubjectEntity, (R, int), QAfterProperty>
      unitOrderIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<SubjectEntity, (R, String?), QAfterProperty>
      learningModuleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<SubjectEntity, (R, String?), QAfterProperty>
      learningModuleTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<SubjectEntity, (R, int), QAfterProperty>
      learningModuleOrderIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<SubjectEntity, (R, bool), QAfterProperty>
      learningModulePublishedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<SubjectEntity, (R, bool), QAfterProperty>
      learningModuleSingleFlowProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<SubjectEntity, (R, int), QAfterProperty> moduleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<SubjectEntity, (R, DateTime), QAfterProperty>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<SubjectEntity, (R, List<String>), QAfterProperty>
      moduleIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }
}

extension SubjectEntityQueryProperty3<R1, R2>
    on QueryBuilder<SubjectEntity, (R1, R2), QAfterProperty> {
  QueryBuilder<SubjectEntity, (R1, R2, int), QOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(0);
    });
  }

  QueryBuilder<SubjectEntity, (R1, R2, String), QOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(1);
    });
  }

  QueryBuilder<SubjectEntity, (R1, R2, String?), QOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(2);
    });
  }

  QueryBuilder<SubjectEntity, (R1, R2, String), QOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(3);
    });
  }

  QueryBuilder<SubjectEntity, (R1, R2, String), QOperations> slugProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(4);
    });
  }

  QueryBuilder<SubjectEntity, (R1, R2, int), QOperations> orderIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(5);
    });
  }

  QueryBuilder<SubjectEntity, (R1, R2, String?), QOperations>
      iconUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(6);
    });
  }

  QueryBuilder<SubjectEntity, (R1, R2, String?), QOperations>
      colorLightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(7);
    });
  }

  QueryBuilder<SubjectEntity, (R1, R2, String?), QOperations>
      colorDarkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(8);
    });
  }

  QueryBuilder<SubjectEntity, (R1, R2, DateTime?), QOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(9);
    });
  }

  QueryBuilder<SubjectEntity, (R1, R2, String?), QOperations> unitIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(10);
    });
  }

  QueryBuilder<SubjectEntity, (R1, R2, String?), QOperations>
      unitTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(11);
    });
  }

  QueryBuilder<SubjectEntity, (R1, R2, int), QOperations>
      unitOrderIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(12);
    });
  }

  QueryBuilder<SubjectEntity, (R1, R2, String?), QOperations>
      learningModuleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(13);
    });
  }

  QueryBuilder<SubjectEntity, (R1, R2, String?), QOperations>
      learningModuleTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(14);
    });
  }

  QueryBuilder<SubjectEntity, (R1, R2, int), QOperations>
      learningModuleOrderIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(15);
    });
  }

  QueryBuilder<SubjectEntity, (R1, R2, bool), QOperations>
      learningModulePublishedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(16);
    });
  }

  QueryBuilder<SubjectEntity, (R1, R2, bool), QOperations>
      learningModuleSingleFlowProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(17);
    });
  }

  QueryBuilder<SubjectEntity, (R1, R2, int), QOperations>
      moduleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(18);
    });
  }

  QueryBuilder<SubjectEntity, (R1, R2, DateTime), QOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(19);
    });
  }

  QueryBuilder<SubjectEntity, (R1, R2, List<String>), QOperations>
      moduleIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addProperty(20);
    });
  }
}
