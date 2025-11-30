// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_entity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSubjectEntityCollection on Isar {
  IsarCollection<SubjectEntity> get subjectEntitys => this.collection();
}

const SubjectEntitySchema = CollectionSchema(
  name: r'SubjectEntity',
  id: 7370011932666232649,
  properties: {
    r'colorDark': PropertySchema(
      id: 0,
      name: r'colorDark',
      type: IsarType.string,
    ),
    r'colorLight': PropertySchema(
      id: 1,
      name: r'colorLight',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'iconUrl': PropertySchema(
      id: 3,
      name: r'iconUrl',
      type: IsarType.string,
    ),
    r'id': PropertySchema(
      id: 4,
      name: r'id',
      type: IsarType.string,
    ),
    r'learningModuleId': PropertySchema(
      id: 5,
      name: r'learningModuleId',
      type: IsarType.string,
    ),
    r'learningModuleOrderIndex': PropertySchema(
      id: 6,
      name: r'learningModuleOrderIndex',
      type: IsarType.long,
    ),
    r'learningModulePublished': PropertySchema(
      id: 7,
      name: r'learningModulePublished',
      type: IsarType.bool,
    ),
    r'learningModuleSingleFlow': PropertySchema(
      id: 8,
      name: r'learningModuleSingleFlow',
      type: IsarType.bool,
    ),
    r'learningModuleTitle': PropertySchema(
      id: 9,
      name: r'learningModuleTitle',
      type: IsarType.string,
    ),
    r'moduleCount': PropertySchema(
      id: 10,
      name: r'moduleCount',
      type: IsarType.long,
    ),
    r'moduleIds': PropertySchema(
      id: 11,
      name: r'moduleIds',
      type: IsarType.stringList,
    ),
    r'orderIndex': PropertySchema(
      id: 12,
      name: r'orderIndex',
      type: IsarType.long,
    ),
    r'slug': PropertySchema(
      id: 13,
      name: r'slug',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 14,
      name: r'title',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 15,
      name: r'type',
      type: IsarType.string,
    ),
    r'unitId': PropertySchema(
      id: 16,
      name: r'unitId',
      type: IsarType.string,
    ),
    r'unitOrderIndex': PropertySchema(
      id: 17,
      name: r'unitOrderIndex',
      type: IsarType.long,
    ),
    r'unitTitle': PropertySchema(
      id: 18,
      name: r'unitTitle',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 19,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _subjectEntityEstimateSize,
  serialize: _subjectEntitySerialize,
  deserialize: _subjectEntityDeserialize,
  deserializeProp: _subjectEntityDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'title': IndexSchema(
      id: -7636685945352118059,
      name: r'title',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'title',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'slug': IndexSchema(
      id: 6169444064746062836,
      name: r'slug',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'slug',
          type: IndexType.hash,
          caseSensitive: false,
        )
      ],
    ),
    r'orderIndex': IndexSchema(
      id: -6149432298716175352,
      name: r'orderIndex',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'orderIndex',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'updatedAt': IndexSchema(
      id: -6238191080293565125,
      name: r'updatedAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'updatedAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _subjectEntityGetId,
  getLinks: _subjectEntityGetLinks,
  attach: _subjectEntityAttach,
  version: '3.1.0+1',
);

int _subjectEntityEstimateSize(
  SubjectEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.colorDark;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.colorLight;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.iconUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.id.length * 3;
  {
    final value = object.learningModuleId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.learningModuleTitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.moduleIds.length * 3;
  {
    for (var i = 0; i < object.moduleIds.length; i++) {
      final value = object.moduleIds[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.slug.length * 3;
  bytesCount += 3 + object.title.length * 3;
  {
    final value = object.type;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.unitId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.unitTitle;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _subjectEntitySerialize(
  SubjectEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.colorDark);
  writer.writeString(offsets[1], object.colorLight);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeString(offsets[3], object.iconUrl);
  writer.writeString(offsets[4], object.id);
  writer.writeString(offsets[5], object.learningModuleId);
  writer.writeLong(offsets[6], object.learningModuleOrderIndex);
  writer.writeBool(offsets[7], object.learningModulePublished);
  writer.writeBool(offsets[8], object.learningModuleSingleFlow);
  writer.writeString(offsets[9], object.learningModuleTitle);
  writer.writeLong(offsets[10], object.moduleCount);
  writer.writeStringList(offsets[11], object.moduleIds);
  writer.writeLong(offsets[12], object.orderIndex);
  writer.writeString(offsets[13], object.slug);
  writer.writeString(offsets[14], object.title);
  writer.writeString(offsets[15], object.type);
  writer.writeString(offsets[16], object.unitId);
  writer.writeLong(offsets[17], object.unitOrderIndex);
  writer.writeString(offsets[18], object.unitTitle);
  writer.writeDateTime(offsets[19], object.updatedAt);
}

SubjectEntity _subjectEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SubjectEntity();
  object.colorDark = reader.readStringOrNull(offsets[0]);
  object.colorLight = reader.readStringOrNull(offsets[1]);
  object.createdAt = reader.readDateTimeOrNull(offsets[2]);
  object.iconUrl = reader.readStringOrNull(offsets[3]);
  object.id = reader.readString(offsets[4]);
  object.isarId = id;
  object.learningModuleId = reader.readStringOrNull(offsets[5]);
  object.learningModuleOrderIndex = reader.readLong(offsets[6]);
  object.learningModulePublished = reader.readBool(offsets[7]);
  object.learningModuleSingleFlow = reader.readBool(offsets[8]);
  object.learningModuleTitle = reader.readStringOrNull(offsets[9]);
  object.moduleCount = reader.readLong(offsets[10]);
  object.moduleIds = reader.readStringList(offsets[11]) ?? [];
  object.orderIndex = reader.readLong(offsets[12]);
  object.slug = reader.readString(offsets[13]);
  object.title = reader.readString(offsets[14]);
  object.type = reader.readStringOrNull(offsets[15]);
  object.unitId = reader.readStringOrNull(offsets[16]);
  object.unitOrderIndex = reader.readLong(offsets[17]);
  object.unitTitle = reader.readStringOrNull(offsets[18]);
  object.updatedAt = reader.readDateTime(offsets[19]);
  return object;
}

P _subjectEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readStringOrNull(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readStringList(offset) ?? []) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readString(offset)) as P;
    case 14:
      return (reader.readString(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readStringOrNull(offset)) as P;
    case 17:
      return (reader.readLong(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _subjectEntityGetId(SubjectEntity object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _subjectEntityGetLinks(SubjectEntity object) {
  return [];
}

void _subjectEntityAttach(
    IsarCollection<dynamic> col, Id id, SubjectEntity object) {
  object.isarId = id;
}

extension SubjectEntityByIndex on IsarCollection<SubjectEntity> {
  Future<SubjectEntity?> getById(String id) {
    return getByIndex(r'id', [id]);
  }

  SubjectEntity? getByIdSync(String id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<SubjectEntity?>> getAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<SubjectEntity?> getAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(SubjectEntity object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(SubjectEntity object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<SubjectEntity> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<SubjectEntity> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension SubjectEntityQueryWhereSort
    on QueryBuilder<SubjectEntity, SubjectEntity, QWhere> {
  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhere> anyOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'orderIndex'),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhere> anyUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'updatedAt'),
      );
    });
  }
}

extension SubjectEntityQueryWhere
    on QueryBuilder<SubjectEntity, SubjectEntity, QWhereClause> {
  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhereClause> idEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhereClause> idNotEqualTo(
      String id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhereClause> titleEqualTo(
      String title) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'title',
        value: [title],
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhereClause> titleNotEqualTo(
      String title) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [],
              upper: [title],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [title],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [title],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [],
              upper: [title],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhereClause> slugEqualTo(
      String slug) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'slug',
        value: [slug],
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhereClause> slugNotEqualTo(
      String slug) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [],
              upper: [slug],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [slug],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [slug],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'slug',
              lower: [],
              upper: [slug],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhereClause>
      orderIndexEqualTo(int orderIndex) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'orderIndex',
        value: [orderIndex],
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhereClause>
      orderIndexNotEqualTo(int orderIndex) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderIndex',
              lower: [],
              upper: [orderIndex],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderIndex',
              lower: [orderIndex],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderIndex',
              lower: [orderIndex],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderIndex',
              lower: [],
              upper: [orderIndex],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhereClause>
      orderIndexGreaterThan(
    int orderIndex, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'orderIndex',
        lower: [orderIndex],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhereClause>
      orderIndexLessThan(
    int orderIndex, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'orderIndex',
        lower: [],
        upper: [orderIndex],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhereClause>
      orderIndexBetween(
    int lowerOrderIndex,
    int upperOrderIndex, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'orderIndex',
        lower: [lowerOrderIndex],
        includeLower: includeLower,
        upper: [upperOrderIndex],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhereClause>
      updatedAtEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'updatedAt',
        value: [updatedAt],
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhereClause>
      updatedAtNotEqualTo(DateTime updatedAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [updatedAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'updatedAt',
              lower: [],
              upper: [updatedAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhereClause>
      updatedAtGreaterThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [updatedAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhereClause>
      updatedAtLessThan(
    DateTime updatedAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [],
        upper: [updatedAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterWhereClause>
      updatedAtBetween(
    DateTime lowerUpdatedAt,
    DateTime upperUpdatedAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'updatedAt',
        lower: [lowerUpdatedAt],
        includeLower: includeLower,
        upper: [upperUpdatedAt],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SubjectEntityQueryFilter
    on QueryBuilder<SubjectEntity, SubjectEntity, QFilterCondition> {
  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'colorDark',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'colorDark',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorDark',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'colorDark',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'colorDark',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'colorDark',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'colorDark',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'colorDark',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'colorDark',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'colorDark',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorDark',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorDarkIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'colorDark',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'colorLight',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'colorLight',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorLight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'colorLight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'colorLight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'colorLight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'colorLight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'colorLight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'colorLight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'colorLight',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorLight',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      colorLightIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'colorLight',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      createdAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      createdAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'iconUrl',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'iconUrl',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'iconUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'iconUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'iconUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'iconUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'iconUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'iconUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'iconUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'iconUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      iconUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'iconUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> idEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      idGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> idLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> idBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'learningModuleId',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'learningModuleId',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'learningModuleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'learningModuleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'learningModuleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'learningModuleId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'learningModuleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'learningModuleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'learningModuleId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'learningModuleId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'learningModuleId',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'learningModuleId',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleOrderIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'learningModuleOrderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleOrderIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'learningModuleOrderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleOrderIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'learningModuleOrderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleOrderIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'learningModuleOrderIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModulePublishedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'learningModulePublished',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleSingleFlowEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'learningModuleSingleFlow',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'learningModuleTitle',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'learningModuleTitle',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'learningModuleTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'learningModuleTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'learningModuleTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'learningModuleTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'learningModuleTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'learningModuleTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'learningModuleTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'learningModuleTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'learningModuleTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      learningModuleTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'learningModuleTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moduleCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moduleCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moduleCount',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moduleCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moduleIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'moduleIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'moduleIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'moduleIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'moduleIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'moduleIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'moduleIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'moduleIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'moduleIds',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'moduleIds',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'moduleIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'moduleIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'moduleIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'moduleIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'moduleIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      moduleIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'moduleIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      orderIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      orderIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      orderIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      orderIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> slugEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      slugGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      slugLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> slugBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slug',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      slugStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      slugEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      slugContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'slug',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> slugMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'slug',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      slugIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slug',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      slugIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'slug',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> typeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      typeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      typeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> typeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'unitId',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'unitId',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unitId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'unitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'unitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'unitId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'unitId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unitId',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'unitId',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitOrderIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unitOrderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitOrderIndexGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unitOrderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitOrderIndexLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unitOrderIndex',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitOrderIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unitOrderIndex',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'unitTitle',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'unitTitle',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unitTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unitTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unitTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unitTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'unitTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'unitTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'unitTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'unitTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unitTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      unitTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'unitTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      updatedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      updatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      updatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterFilterCondition>
      updatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension SubjectEntityQueryObject
    on QueryBuilder<SubjectEntity, SubjectEntity, QFilterCondition> {}

extension SubjectEntityQueryLinks
    on QueryBuilder<SubjectEntity, SubjectEntity, QFilterCondition> {}

extension SubjectEntityQuerySortBy
    on QueryBuilder<SubjectEntity, SubjectEntity, QSortBy> {
  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByColorDark() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorDark', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByColorDarkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorDark', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByColorLight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorLight', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByColorLightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorLight', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByIconUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconUrl', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByIconUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconUrl', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByLearningModuleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningModuleId', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByLearningModuleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningModuleId', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByLearningModuleOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningModuleOrderIndex', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByLearningModuleOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningModuleOrderIndex', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByLearningModulePublished() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningModulePublished', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByLearningModulePublishedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningModulePublished', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByLearningModuleSingleFlow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningModuleSingleFlow', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByLearningModuleSingleFlowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningModuleSingleFlow', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByLearningModuleTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningModuleTitle', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByLearningModuleTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningModuleTitle', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByModuleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moduleCount', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByModuleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moduleCount', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortBySlug() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortBySlugDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByUnitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitId', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByUnitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitId', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByUnitOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitOrderIndex', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByUnitOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitOrderIndex', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByUnitTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitTitle', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByUnitTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitTitle', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SubjectEntityQuerySortThenBy
    on QueryBuilder<SubjectEntity, SubjectEntity, QSortThenBy> {
  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByColorDark() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorDark', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByColorDarkDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorDark', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByColorLight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorLight', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByColorLightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'colorLight', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByIconUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconUrl', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByIconUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'iconUrl', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByLearningModuleId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningModuleId', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByLearningModuleIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningModuleId', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByLearningModuleOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningModuleOrderIndex', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByLearningModuleOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningModuleOrderIndex', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByLearningModulePublished() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningModulePublished', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByLearningModulePublishedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningModulePublished', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByLearningModuleSingleFlow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningModuleSingleFlow', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByLearningModuleSingleFlowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningModuleSingleFlow', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByLearningModuleTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningModuleTitle', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByLearningModuleTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'learningModuleTitle', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByModuleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moduleCount', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByModuleCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'moduleCount', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderIndex', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenBySlug() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenBySlugDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slug', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByUnitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitId', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByUnitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitId', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByUnitOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitOrderIndex', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByUnitOrderIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitOrderIndex', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByUnitTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitTitle', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByUnitTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unitTitle', Sort.desc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy> thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension SubjectEntityQueryWhereDistinct
    on QueryBuilder<SubjectEntity, SubjectEntity, QDistinct> {
  QueryBuilder<SubjectEntity, SubjectEntity, QDistinct> distinctByColorDark(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorDark', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QDistinct> distinctByColorLight(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'colorLight', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QDistinct> distinctByIconUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'iconUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QDistinct>
      distinctByLearningModuleId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'learningModuleId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QDistinct>
      distinctByLearningModuleOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'learningModuleOrderIndex');
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QDistinct>
      distinctByLearningModulePublished() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'learningModulePublished');
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QDistinct>
      distinctByLearningModuleSingleFlow() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'learningModuleSingleFlow');
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QDistinct>
      distinctByLearningModuleTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'learningModuleTitle',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QDistinct>
      distinctByModuleCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moduleCount');
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QDistinct> distinctByModuleIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'moduleIds');
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QDistinct> distinctByOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderIndex');
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QDistinct> distinctBySlug(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slug', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QDistinct> distinctByType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QDistinct> distinctByUnitId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unitId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QDistinct>
      distinctByUnitOrderIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unitOrderIndex');
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QDistinct> distinctByUnitTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unitTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SubjectEntity, SubjectEntity, QDistinct> distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension SubjectEntityQueryProperty
    on QueryBuilder<SubjectEntity, SubjectEntity, QQueryProperty> {
  QueryBuilder<SubjectEntity, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<SubjectEntity, String?, QQueryOperations> colorDarkProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorDark');
    });
  }

  QueryBuilder<SubjectEntity, String?, QQueryOperations> colorLightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'colorLight');
    });
  }

  QueryBuilder<SubjectEntity, DateTime?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<SubjectEntity, String?, QQueryOperations> iconUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'iconUrl');
    });
  }

  QueryBuilder<SubjectEntity, String, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SubjectEntity, String?, QQueryOperations>
      learningModuleIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'learningModuleId');
    });
  }

  QueryBuilder<SubjectEntity, int, QQueryOperations>
      learningModuleOrderIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'learningModuleOrderIndex');
    });
  }

  QueryBuilder<SubjectEntity, bool, QQueryOperations>
      learningModulePublishedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'learningModulePublished');
    });
  }

  QueryBuilder<SubjectEntity, bool, QQueryOperations>
      learningModuleSingleFlowProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'learningModuleSingleFlow');
    });
  }

  QueryBuilder<SubjectEntity, String?, QQueryOperations>
      learningModuleTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'learningModuleTitle');
    });
  }

  QueryBuilder<SubjectEntity, int, QQueryOperations> moduleCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moduleCount');
    });
  }

  QueryBuilder<SubjectEntity, List<String>, QQueryOperations>
      moduleIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'moduleIds');
    });
  }

  QueryBuilder<SubjectEntity, int, QQueryOperations> orderIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderIndex');
    });
  }

  QueryBuilder<SubjectEntity, String, QQueryOperations> slugProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slug');
    });
  }

  QueryBuilder<SubjectEntity, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<SubjectEntity, String?, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<SubjectEntity, String?, QQueryOperations> unitIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unitId');
    });
  }

  QueryBuilder<SubjectEntity, int, QQueryOperations> unitOrderIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unitOrderIndex');
    });
  }

  QueryBuilder<SubjectEntity, String?, QQueryOperations> unitTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unitTitle');
    });
  }

  QueryBuilder<SubjectEntity, DateTime, QQueryOperations> updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}
