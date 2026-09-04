// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'party_quest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PartyQuest {

 String get id; String get templateId; String get titleSnapshot; String get instructionsSnapshot; int get pointsUnits;@TimestampConverter() DateTime get startsAt;@TimestampConverter() DateTime get endsAt; PartyQuestStatus get status; List<String> get eligibleMemberIds; List<String> get eligiblePairKeys; List<String> get completedPairKeys;@TimestampConverterOptimistic() DateTime get createdAt;
/// Create a copy of PartyQuest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartyQuestCopyWith<PartyQuest> get copyWith => _$PartyQuestCopyWithImpl<PartyQuest>(this as PartyQuest, _$identity);

  /// Serializes this PartyQuest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PartyQuest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartyQuest&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.templateId, _this.templateId) || other.templateId == _this.templateId)&&(identical(other.titleSnapshot, _this.titleSnapshot) || other.titleSnapshot == _this.titleSnapshot)&&(identical(other.instructionsSnapshot, _this.instructionsSnapshot) || other.instructionsSnapshot == _this.instructionsSnapshot)&&(identical(other.pointsUnits, _this.pointsUnits) || other.pointsUnits == _this.pointsUnits)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.eligibleMemberIds, _this.eligibleMemberIds)&&const DeepCollectionEquality().equals(other.eligiblePairKeys, _this.eligiblePairKeys)&&const DeepCollectionEquality().equals(other.completedPairKeys, _this.completedPairKeys)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PartyQuest;
  return Object.hash(runtimeType,_this.id,_this.templateId,_this.titleSnapshot,_this.instructionsSnapshot,_this.pointsUnits,_this.startsAt,_this.endsAt,_this.status,const DeepCollectionEquality().hash(_this.eligibleMemberIds),const DeepCollectionEquality().hash(_this.eligiblePairKeys),const DeepCollectionEquality().hash(_this.completedPairKeys),_this.createdAt);
}

@override
String toString() {
  final _this = this as PartyQuest;
  return 'PartyQuest(id: ${_this.id}, templateId: ${_this.templateId}, titleSnapshot: ${_this.titleSnapshot}, instructionsSnapshot: ${_this.instructionsSnapshot}, pointsUnits: ${_this.pointsUnits}, startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt}, status: ${_this.status}, eligibleMemberIds: ${_this.eligibleMemberIds}, eligiblePairKeys: ${_this.eligiblePairKeys}, completedPairKeys: ${_this.completedPairKeys}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $PartyQuestCopyWith<$Res>  {
  factory $PartyQuestCopyWith(PartyQuest value, $Res Function(PartyQuest) _then) = _$PartyQuestCopyWithImpl;
@useResult
$Res call({
 String id, String templateId, String titleSnapshot, String instructionsSnapshot, int pointsUnits,@TimestampConverter() DateTime startsAt,@TimestampConverter() DateTime endsAt, PartyQuestStatus status, List<String> eligibleMemberIds, List<String> eligiblePairKeys, List<String> completedPairKeys,@TimestampConverterOptimistic() DateTime createdAt
});




}
/// @nodoc
class _$PartyQuestCopyWithImpl<$Res>
    implements $PartyQuestCopyWith<$Res> {
  _$PartyQuestCopyWithImpl(this._self, this._then);

  final PartyQuest _self;
  final $Res Function(PartyQuest) _then;

/// Create a copy of PartyQuest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? templateId = null,Object? titleSnapshot = null,Object? instructionsSnapshot = null,Object? pointsUnits = null,Object? startsAt = null,Object? endsAt = null,Object? status = null,Object? eligibleMemberIds = null,Object? eligiblePairKeys = null,Object? completedPairKeys = null,Object? createdAt = null,}) {
  return _then(PartyQuest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,titleSnapshot: null == titleSnapshot ? _self.titleSnapshot : titleSnapshot // ignore: cast_nullable_to_non_nullable
as String,instructionsSnapshot: null == instructionsSnapshot ? _self.instructionsSnapshot : instructionsSnapshot // ignore: cast_nullable_to_non_nullable
as String,pointsUnits: null == pointsUnits ? _self.pointsUnits : pointsUnits // ignore: cast_nullable_to_non_nullable
as int,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PartyQuestStatus,eligibleMemberIds: null == eligibleMemberIds ? _self.eligibleMemberIds : eligibleMemberIds // ignore: cast_nullable_to_non_nullable
as List<String>,eligiblePairKeys: null == eligiblePairKeys ? _self.eligiblePairKeys : eligiblePairKeys // ignore: cast_nullable_to_non_nullable
as List<String>,completedPairKeys: null == completedPairKeys ? _self.completedPairKeys : completedPairKeys // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PartyQuest].
extension PartyQuestPatterns on PartyQuest {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartyQuest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartyQuest() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartyQuest value)  $default,){
final _that = this;
switch (_that) {
case _PartyQuest():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartyQuest value)?  $default,){
final _that = this;
switch (_that) {
case _PartyQuest() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String templateId,  String titleSnapshot,  String instructionsSnapshot,  int pointsUnits, @TimestampConverter()  DateTime startsAt, @TimestampConverter()  DateTime endsAt,  PartyQuestStatus status,  List<String> eligibleMemberIds,  List<String> eligiblePairKeys,  List<String> completedPairKeys, @TimestampConverterOptimistic()  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartyQuest() when $default != null:
return $default(_that.id,_that.templateId,_that.titleSnapshot,_that.instructionsSnapshot,_that.pointsUnits,_that.startsAt,_that.endsAt,_that.status,_that.eligibleMemberIds,_that.eligiblePairKeys,_that.completedPairKeys,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String templateId,  String titleSnapshot,  String instructionsSnapshot,  int pointsUnits, @TimestampConverter()  DateTime startsAt, @TimestampConverter()  DateTime endsAt,  PartyQuestStatus status,  List<String> eligibleMemberIds,  List<String> eligiblePairKeys,  List<String> completedPairKeys, @TimestampConverterOptimistic()  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _PartyQuest():
return $default(_that.id,_that.templateId,_that.titleSnapshot,_that.instructionsSnapshot,_that.pointsUnits,_that.startsAt,_that.endsAt,_that.status,_that.eligibleMemberIds,_that.eligiblePairKeys,_that.completedPairKeys,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String templateId,  String titleSnapshot,  String instructionsSnapshot,  int pointsUnits, @TimestampConverter()  DateTime startsAt, @TimestampConverter()  DateTime endsAt,  PartyQuestStatus status,  List<String> eligibleMemberIds,  List<String> eligiblePairKeys,  List<String> completedPairKeys, @TimestampConverterOptimistic()  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PartyQuest() when $default != null:
return $default(_that.id,_that.templateId,_that.titleSnapshot,_that.instructionsSnapshot,_that.pointsUnits,_that.startsAt,_that.endsAt,_that.status,_that.eligibleMemberIds,_that.eligiblePairKeys,_that.completedPairKeys,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PartyQuest implements PartyQuest {
  const _PartyQuest({required this.id, required this.templateId, required this.titleSnapshot, required this.instructionsSnapshot, required this.pointsUnits, @TimestampConverter() required this.startsAt, @TimestampConverter() required this.endsAt, required this.status,  List<String> eligibleMemberIds = const <String>[],  List<String> eligiblePairKeys = const <String>[],  List<String> completedPairKeys = const <String>[], @TimestampConverterOptimistic() required this.createdAt}): _eligibleMemberIds = eligibleMemberIds,_eligiblePairKeys = eligiblePairKeys,_completedPairKeys = completedPairKeys;
  factory _PartyQuest.fromJson(Map<String, dynamic> json) => _$PartyQuestFromJson(json);

@override final  String id;
@override final  String templateId;
@override final  String titleSnapshot;
@override final  String instructionsSnapshot;
@override final  int pointsUnits;
@override@TimestampConverter() final  DateTime startsAt;
@override@TimestampConverter() final  DateTime endsAt;
@override final  PartyQuestStatus status;
 final  List<String> _eligibleMemberIds;
@override@JsonKey() List<String> get eligibleMemberIds {
  if (_eligibleMemberIds is EqualUnmodifiableListView) return _eligibleMemberIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_eligibleMemberIds);
}

 final  List<String> _eligiblePairKeys;
@override@JsonKey() List<String> get eligiblePairKeys {
  if (_eligiblePairKeys is EqualUnmodifiableListView) return _eligiblePairKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_eligiblePairKeys);
}

 final  List<String> _completedPairKeys;
@override@JsonKey() List<String> get completedPairKeys {
  if (_completedPairKeys is EqualUnmodifiableListView) return _completedPairKeys;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedPairKeys);
}

@override@TimestampConverterOptimistic() final  DateTime createdAt;

/// Create a copy of PartyQuest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartyQuestCopyWith<_PartyQuest> get copyWith => __$PartyQuestCopyWithImpl<_PartyQuest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PartyQuestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartyQuest&&(identical(other.id, id) || other.id == id)&&(identical(other.templateId, templateId) || other.templateId == templateId)&&(identical(other.titleSnapshot, titleSnapshot) || other.titleSnapshot == titleSnapshot)&&(identical(other.instructionsSnapshot, instructionsSnapshot) || other.instructionsSnapshot == instructionsSnapshot)&&(identical(other.pointsUnits, pointsUnits) || other.pointsUnits == pointsUnits)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.eligibleMemberIds, _eligibleMemberIds)&&const DeepCollectionEquality().equals(other.eligiblePairKeys, _eligiblePairKeys)&&const DeepCollectionEquality().equals(other.completedPairKeys, _completedPairKeys)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,templateId,titleSnapshot,instructionsSnapshot,pointsUnits,startsAt,endsAt,status,const DeepCollectionEquality().hash(_eligibleMemberIds),const DeepCollectionEquality().hash(_eligiblePairKeys),const DeepCollectionEquality().hash(_completedPairKeys),createdAt);
}

@override
String toString() {
    return 'PartyQuest(id: $id, templateId: $templateId, titleSnapshot: $titleSnapshot, instructionsSnapshot: $instructionsSnapshot, pointsUnits: $pointsUnits, startsAt: $startsAt, endsAt: $endsAt, status: $status, eligibleMemberIds: $eligibleMemberIds, eligiblePairKeys: $eligiblePairKeys, completedPairKeys: $completedPairKeys, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PartyQuestCopyWith<$Res> implements $PartyQuestCopyWith<$Res> {
  factory _$PartyQuestCopyWith(_PartyQuest value, $Res Function(_PartyQuest) _then) = __$PartyQuestCopyWithImpl;
@override @useResult
$Res call({
 String id, String templateId, String titleSnapshot, String instructionsSnapshot, int pointsUnits,@TimestampConverter() DateTime startsAt,@TimestampConverter() DateTime endsAt, PartyQuestStatus status, List<String> eligibleMemberIds, List<String> eligiblePairKeys, List<String> completedPairKeys,@TimestampConverterOptimistic() DateTime createdAt
});




}
/// @nodoc
class __$PartyQuestCopyWithImpl<$Res>
    implements _$PartyQuestCopyWith<$Res> {
  __$PartyQuestCopyWithImpl(this._self, this._then);

  final _PartyQuest _self;
  final $Res Function(_PartyQuest) _then;

/// Create a copy of PartyQuest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? templateId = null,Object? titleSnapshot = null,Object? instructionsSnapshot = null,Object? pointsUnits = null,Object? startsAt = null,Object? endsAt = null,Object? status = null,Object? eligibleMemberIds = null,Object? eligiblePairKeys = null,Object? completedPairKeys = null,Object? createdAt = null,}) {
  return _then(_PartyQuest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,templateId: null == templateId ? _self.templateId : templateId // ignore: cast_nullable_to_non_nullable
as String,titleSnapshot: null == titleSnapshot ? _self.titleSnapshot : titleSnapshot // ignore: cast_nullable_to_non_nullable
as String,instructionsSnapshot: null == instructionsSnapshot ? _self.instructionsSnapshot : instructionsSnapshot // ignore: cast_nullable_to_non_nullable
as String,pointsUnits: null == pointsUnits ? _self.pointsUnits : pointsUnits // ignore: cast_nullable_to_non_nullable
as int,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PartyQuestStatus,eligibleMemberIds: null == eligibleMemberIds ? _self._eligibleMemberIds : eligibleMemberIds // ignore: cast_nullable_to_non_nullable
as List<String>,eligiblePairKeys: null == eligiblePairKeys ? _self._eligiblePairKeys : eligiblePairKeys // ignore: cast_nullable_to_non_nullable
as List<String>,completedPairKeys: null == completedPairKeys ? _self._completedPairKeys : completedPairKeys // ignore: cast_nullable_to_non_nullable
as List<String>,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
