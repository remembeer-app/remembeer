// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PartyMember _$PartyMemberFromJson(Map<String, dynamic> json) => _PartyMember(
  id: json['id'] as String,
  userId: json['userId'] as String,
  selectedClass: $enumDecodeNullable(
    _$DrinkCategoryEnumMap,
    json['selectedClass'],
  ),
  classVersion: (json['classVersion'] as num?)?.toInt() ?? 0,
  classChangedAt: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['classChangedAt'],
    const TimestampConverter().fromJson,
  ),
  beerpongOptIn: json['beerpongOptIn'] as bool? ?? false,
  scoreUnits: (json['scoreUnits'] as num?)?.toInt() ?? 0,
  drinkCount: (json['drinkCount'] as num?)?.toInt() ?? 0,
  isActive: json['isActive'] as bool? ?? true,
  joinedAt: const TimestampConverter().fromJson(json['joinedAt'] as Timestamp),
  updatedAt: const TimestampConverterOptimistic().fromJson(
    json['updatedAt'] as Timestamp?,
  ),
);

Map<String, dynamic> _$PartyMemberToJson(
  _PartyMember instance,
) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'selectedClass': _$DrinkCategoryEnumMap[instance.selectedClass],
  'classVersion': instance.classVersion,
  'classChangedAt': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.classChangedAt,
    const TimestampConverter().toJson,
  ),
  'beerpongOptIn': instance.beerpongOptIn,
  'scoreUnits': instance.scoreUnits,
  'drinkCount': instance.drinkCount,
  'isActive': instance.isActive,
  'joinedAt': const TimestampConverter().toJson(instance.joinedAt),
  'updatedAt': const TimestampConverterOptimistic().toJson(instance.updatedAt),
};

const _$DrinkCategoryEnumMap = {
  DrinkCategory.beer: 'beer',
  DrinkCategory.cider: 'cider',
  DrinkCategory.cocktail: 'cocktail',
  DrinkCategory.spirit: 'spirit',
  DrinkCategory.wine: 'wine',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
