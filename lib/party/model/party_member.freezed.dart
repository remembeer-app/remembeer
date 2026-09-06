// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'party_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PartyMember {

 String get id; String get userId; DrinkCategory? get selectedClass; int get classVersion;@TimestampConverter() DateTime? get classChangedAt; bool get beerpongOptIn; int get scoreUnits; int get drinkCount; bool get isActive;@TimestampConverter() DateTime get joinedAt;@TimestampConverterOptimistic() DateTime get updatedAt;
/// Create a copy of PartyMember
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartyMemberCopyWith<PartyMember> get copyWith => _$PartyMemberCopyWithImpl<PartyMember>(this as PartyMember, _$identity);

  /// Serializes this PartyMember to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PartyMember;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartyMember&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.selectedClass, _this.selectedClass) || other.selectedClass == _this.selectedClass)&&(identical(other.classVersion, _this.classVersion) || other.classVersion == _this.classVersion)&&(identical(other.classChangedAt, _this.classChangedAt) || other.classChangedAt == _this.classChangedAt)&&(identical(other.beerpongOptIn, _this.beerpongOptIn) || other.beerpongOptIn == _this.beerpongOptIn)&&(identical(other.scoreUnits, _this.scoreUnits) || other.scoreUnits == _this.scoreUnits)&&(identical(other.drinkCount, _this.drinkCount) || other.drinkCount == _this.drinkCount)&&(identical(other.isActive, _this.isActive) || other.isActive == _this.isActive)&&(identical(other.joinedAt, _this.joinedAt) || other.joinedAt == _this.joinedAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PartyMember;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.selectedClass,_this.classVersion,_this.classChangedAt,_this.beerpongOptIn,_this.scoreUnits,_this.drinkCount,_this.isActive,_this.joinedAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as PartyMember;
  return 'PartyMember(id: ${_this.id}, userId: ${_this.userId}, selectedClass: ${_this.selectedClass}, classVersion: ${_this.classVersion}, classChangedAt: ${_this.classChangedAt}, beerpongOptIn: ${_this.beerpongOptIn}, scoreUnits: ${_this.scoreUnits}, drinkCount: ${_this.drinkCount}, isActive: ${_this.isActive}, joinedAt: ${_this.joinedAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $PartyMemberCopyWith<$Res>  {
  factory $PartyMemberCopyWith(PartyMember value, $Res Function(PartyMember) _then) = _$PartyMemberCopyWithImpl;
@useResult
$Res call({
 String id, String userId, DrinkCategory? selectedClass, int classVersion,@TimestampConverter() DateTime? classChangedAt, bool beerpongOptIn, int scoreUnits, int drinkCount, bool isActive,@TimestampConverter() DateTime joinedAt,@TimestampConverterOptimistic() DateTime updatedAt
});




}
/// @nodoc
class _$PartyMemberCopyWithImpl<$Res>
    implements $PartyMemberCopyWith<$Res> {
  _$PartyMemberCopyWithImpl(this._self, this._then);

  final PartyMember _self;
  final $Res Function(PartyMember) _then;

/// Create a copy of PartyMember
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? selectedClass = freezed,Object? classVersion = null,Object? classChangedAt = freezed,Object? beerpongOptIn = null,Object? scoreUnits = null,Object? drinkCount = null,Object? isActive = null,Object? joinedAt = null,Object? updatedAt = null,}) {
  return _then(PartyMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,selectedClass: freezed == selectedClass ? _self.selectedClass : selectedClass // ignore: cast_nullable_to_non_nullable
as DrinkCategory?,classVersion: null == classVersion ? _self.classVersion : classVersion // ignore: cast_nullable_to_non_nullable
as int,classChangedAt: freezed == classChangedAt ? _self.classChangedAt : classChangedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,beerpongOptIn: null == beerpongOptIn ? _self.beerpongOptIn : beerpongOptIn // ignore: cast_nullable_to_non_nullable
as bool,scoreUnits: null == scoreUnits ? _self.scoreUnits : scoreUnits // ignore: cast_nullable_to_non_nullable
as int,drinkCount: null == drinkCount ? _self.drinkCount : drinkCount // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PartyMember].
extension PartyMemberPatterns on PartyMember {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartyMember value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartyMember() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartyMember value)  $default,){
final _that = this;
switch (_that) {
case _PartyMember():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartyMember value)?  $default,){
final _that = this;
switch (_that) {
case _PartyMember() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  DrinkCategory? selectedClass,  int classVersion, @TimestampConverter()  DateTime? classChangedAt,  bool beerpongOptIn,  int scoreUnits,  int drinkCount,  bool isActive, @TimestampConverter()  DateTime joinedAt, @TimestampConverterOptimistic()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartyMember() when $default != null:
return $default(_that.id,_that.userId,_that.selectedClass,_that.classVersion,_that.classChangedAt,_that.beerpongOptIn,_that.scoreUnits,_that.drinkCount,_that.isActive,_that.joinedAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  DrinkCategory? selectedClass,  int classVersion, @TimestampConverter()  DateTime? classChangedAt,  bool beerpongOptIn,  int scoreUnits,  int drinkCount,  bool isActive, @TimestampConverter()  DateTime joinedAt, @TimestampConverterOptimistic()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PartyMember():
return $default(_that.id,_that.userId,_that.selectedClass,_that.classVersion,_that.classChangedAt,_that.beerpongOptIn,_that.scoreUnits,_that.drinkCount,_that.isActive,_that.joinedAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  DrinkCategory? selectedClass,  int classVersion, @TimestampConverter()  DateTime? classChangedAt,  bool beerpongOptIn,  int scoreUnits,  int drinkCount,  bool isActive, @TimestampConverter()  DateTime joinedAt, @TimestampConverterOptimistic()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PartyMember() when $default != null:
return $default(_that.id,_that.userId,_that.selectedClass,_that.classVersion,_that.classChangedAt,_that.beerpongOptIn,_that.scoreUnits,_that.drinkCount,_that.isActive,_that.joinedAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PartyMember implements PartyMember {
  const _PartyMember({required this.id, required this.userId, this.selectedClass, this.classVersion = 0, @TimestampConverter() this.classChangedAt, this.beerpongOptIn = false, this.scoreUnits = 0, this.drinkCount = 0, this.isActive = true, @TimestampConverter() required this.joinedAt, @TimestampConverterOptimistic() required this.updatedAt});
  factory _PartyMember.fromJson(Map<String, dynamic> json) => _$PartyMemberFromJson(json);

@override final  String id;
@override final  String userId;
@override final  DrinkCategory? selectedClass;
@override@JsonKey() final  int classVersion;
@override@TimestampConverter() final  DateTime? classChangedAt;
@override@JsonKey() final  bool beerpongOptIn;
@override@JsonKey() final  int scoreUnits;
@override@JsonKey() final  int drinkCount;
@override@JsonKey() final  bool isActive;
@override@TimestampConverter() final  DateTime joinedAt;
@override@TimestampConverterOptimistic() final  DateTime updatedAt;

/// Create a copy of PartyMember
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartyMemberCopyWith<_PartyMember> get copyWith => __$PartyMemberCopyWithImpl<_PartyMember>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PartyMemberToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartyMember&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.selectedClass, selectedClass) || other.selectedClass == selectedClass)&&(identical(other.classVersion, classVersion) || other.classVersion == classVersion)&&(identical(other.classChangedAt, classChangedAt) || other.classChangedAt == classChangedAt)&&(identical(other.beerpongOptIn, beerpongOptIn) || other.beerpongOptIn == beerpongOptIn)&&(identical(other.scoreUnits, scoreUnits) || other.scoreUnits == scoreUnits)&&(identical(other.drinkCount, drinkCount) || other.drinkCount == drinkCount)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,selectedClass,classVersion,classChangedAt,beerpongOptIn,scoreUnits,drinkCount,isActive,joinedAt,updatedAt);
}

@override
String toString() {
    return 'PartyMember(id: $id, userId: $userId, selectedClass: $selectedClass, classVersion: $classVersion, classChangedAt: $classChangedAt, beerpongOptIn: $beerpongOptIn, scoreUnits: $scoreUnits, drinkCount: $drinkCount, isActive: $isActive, joinedAt: $joinedAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PartyMemberCopyWith<$Res> implements $PartyMemberCopyWith<$Res> {
  factory _$PartyMemberCopyWith(_PartyMember value, $Res Function(_PartyMember) _then) = __$PartyMemberCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, DrinkCategory? selectedClass, int classVersion,@TimestampConverter() DateTime? classChangedAt, bool beerpongOptIn, int scoreUnits, int drinkCount, bool isActive,@TimestampConverter() DateTime joinedAt,@TimestampConverterOptimistic() DateTime updatedAt
});




}
/// @nodoc
class __$PartyMemberCopyWithImpl<$Res>
    implements _$PartyMemberCopyWith<$Res> {
  __$PartyMemberCopyWithImpl(this._self, this._then);

  final _PartyMember _self;
  final $Res Function(_PartyMember) _then;

/// Create a copy of PartyMember
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? selectedClass = freezed,Object? classVersion = null,Object? classChangedAt = freezed,Object? beerpongOptIn = null,Object? scoreUnits = null,Object? drinkCount = null,Object? isActive = null,Object? joinedAt = null,Object? updatedAt = null,}) {
  return _then(_PartyMember(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,selectedClass: freezed == selectedClass ? _self.selectedClass : selectedClass // ignore: cast_nullable_to_non_nullable
as DrinkCategory?,classVersion: null == classVersion ? _self.classVersion : classVersion // ignore: cast_nullable_to_non_nullable
as int,classChangedAt: freezed == classChangedAt ? _self.classChangedAt : classChangedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,beerpongOptIn: null == beerpongOptIn ? _self.beerpongOptIn : beerpongOptIn // ignore: cast_nullable_to_non_nullable
as bool,scoreUnits: null == scoreUnits ? _self.scoreUnits : scoreUnits // ignore: cast_nullable_to_non_nullable
as int,drinkCount: null == drinkCount ? _self.drinkCount : drinkCount // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
