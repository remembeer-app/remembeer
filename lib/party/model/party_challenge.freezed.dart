// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'party_challenge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PartyChallenge {

 String get id; String get title; String get instructions; int get pointsUnits;@TimestampConverter() DateTime get startsAt;@TimestampConverter() DateTime get endsAt; PartyChallengeStatus get status; List<String> get winnerIds; String get createdByUserId;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get updatedAt;
/// Create a copy of PartyChallenge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartyChallengeCopyWith<PartyChallenge> get copyWith => _$PartyChallengeCopyWithImpl<PartyChallenge>(this as PartyChallenge, _$identity);

  /// Serializes this PartyChallenge to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PartyChallenge;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartyChallenge&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.instructions, _this.instructions) || other.instructions == _this.instructions)&&(identical(other.pointsUnits, _this.pointsUnits) || other.pointsUnits == _this.pointsUnits)&&(identical(other.startsAt, _this.startsAt) || other.startsAt == _this.startsAt)&&(identical(other.endsAt, _this.endsAt) || other.endsAt == _this.endsAt)&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.winnerIds, _this.winnerIds)&&(identical(other.createdByUserId, _this.createdByUserId) || other.createdByUserId == _this.createdByUserId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PartyChallenge;
  return Object.hash(runtimeType,_this.id,_this.title,_this.instructions,_this.pointsUnits,_this.startsAt,_this.endsAt,_this.status,const DeepCollectionEquality().hash(_this.winnerIds),_this.createdByUserId,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as PartyChallenge;
  return 'PartyChallenge(id: ${_this.id}, title: ${_this.title}, instructions: ${_this.instructions}, pointsUnits: ${_this.pointsUnits}, startsAt: ${_this.startsAt}, endsAt: ${_this.endsAt}, status: ${_this.status}, winnerIds: ${_this.winnerIds}, createdByUserId: ${_this.createdByUserId}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $PartyChallengeCopyWith<$Res>  {
  factory $PartyChallengeCopyWith(PartyChallenge value, $Res Function(PartyChallenge) _then) = _$PartyChallengeCopyWithImpl;
@useResult
$Res call({
 String id, String title, String instructions, int pointsUnits,@TimestampConverter() DateTime startsAt,@TimestampConverter() DateTime endsAt, PartyChallengeStatus status, List<String> winnerIds, String createdByUserId,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class _$PartyChallengeCopyWithImpl<$Res>
    implements $PartyChallengeCopyWith<$Res> {
  _$PartyChallengeCopyWithImpl(this._self, this._then);

  final PartyChallenge _self;
  final $Res Function(PartyChallenge) _then;

/// Create a copy of PartyChallenge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? instructions = null,Object? pointsUnits = null,Object? startsAt = null,Object? endsAt = null,Object? status = null,Object? winnerIds = null,Object? createdByUserId = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(PartyChallenge(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,pointsUnits: null == pointsUnits ? _self.pointsUnits : pointsUnits // ignore: cast_nullable_to_non_nullable
as int,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PartyChallengeStatus,winnerIds: null == winnerIds ? _self.winnerIds : winnerIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PartyChallenge].
extension PartyChallengePatterns on PartyChallenge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartyChallenge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartyChallenge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartyChallenge value)  $default,){
final _that = this;
switch (_that) {
case _PartyChallenge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartyChallenge value)?  $default,){
final _that = this;
switch (_that) {
case _PartyChallenge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String instructions,  int pointsUnits, @TimestampConverter()  DateTime startsAt, @TimestampConverter()  DateTime endsAt,  PartyChallengeStatus status,  List<String> winnerIds,  String createdByUserId, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartyChallenge() when $default != null:
return $default(_that.id,_that.title,_that.instructions,_that.pointsUnits,_that.startsAt,_that.endsAt,_that.status,_that.winnerIds,_that.createdByUserId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String instructions,  int pointsUnits, @TimestampConverter()  DateTime startsAt, @TimestampConverter()  DateTime endsAt,  PartyChallengeStatus status,  List<String> winnerIds,  String createdByUserId, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PartyChallenge():
return $default(_that.id,_that.title,_that.instructions,_that.pointsUnits,_that.startsAt,_that.endsAt,_that.status,_that.winnerIds,_that.createdByUserId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String instructions,  int pointsUnits, @TimestampConverter()  DateTime startsAt, @TimestampConverter()  DateTime endsAt,  PartyChallengeStatus status,  List<String> winnerIds,  String createdByUserId, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PartyChallenge() when $default != null:
return $default(_that.id,_that.title,_that.instructions,_that.pointsUnits,_that.startsAt,_that.endsAt,_that.status,_that.winnerIds,_that.createdByUserId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PartyChallenge implements PartyChallenge {
  const _PartyChallenge({required this.id, required this.title, required this.instructions, required this.pointsUnits, @TimestampConverter() required this.startsAt, @TimestampConverter() required this.endsAt, required this.status,  List<String> winnerIds = const <String>[], required this.createdByUserId, @TimestampConverter() required this.createdAt, @TimestampConverter() required this.updatedAt}): _winnerIds = winnerIds;
  factory _PartyChallenge.fromJson(Map<String, dynamic> json) => _$PartyChallengeFromJson(json);

@override final  String id;
@override final  String title;
@override final  String instructions;
@override final  int pointsUnits;
@override@TimestampConverter() final  DateTime startsAt;
@override@TimestampConverter() final  DateTime endsAt;
@override final  PartyChallengeStatus status;
 final  List<String> _winnerIds;
@override@JsonKey() List<String> get winnerIds {
  if (_winnerIds is EqualUnmodifiableListView) return _winnerIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_winnerIds);
}

@override final  String createdByUserId;
@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime updatedAt;

/// Create a copy of PartyChallenge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartyChallengeCopyWith<_PartyChallenge> get copyWith => __$PartyChallengeCopyWithImpl<_PartyChallenge>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PartyChallengeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartyChallenge&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.pointsUnits, pointsUnits) || other.pointsUnits == pointsUnits)&&(identical(other.startsAt, startsAt) || other.startsAt == startsAt)&&(identical(other.endsAt, endsAt) || other.endsAt == endsAt)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.winnerIds, _winnerIds)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,title,instructions,pointsUnits,startsAt,endsAt,status,const DeepCollectionEquality().hash(_winnerIds),createdByUserId,createdAt,updatedAt);
}

@override
String toString() {
    return 'PartyChallenge(id: $id, title: $title, instructions: $instructions, pointsUnits: $pointsUnits, startsAt: $startsAt, endsAt: $endsAt, status: $status, winnerIds: $winnerIds, createdByUserId: $createdByUserId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PartyChallengeCopyWith<$Res> implements $PartyChallengeCopyWith<$Res> {
  factory _$PartyChallengeCopyWith(_PartyChallenge value, $Res Function(_PartyChallenge) _then) = __$PartyChallengeCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String instructions, int pointsUnits,@TimestampConverter() DateTime startsAt,@TimestampConverter() DateTime endsAt, PartyChallengeStatus status, List<String> winnerIds, String createdByUserId,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class __$PartyChallengeCopyWithImpl<$Res>
    implements _$PartyChallengeCopyWith<$Res> {
  __$PartyChallengeCopyWithImpl(this._self, this._then);

  final _PartyChallenge _self;
  final $Res Function(_PartyChallenge) _then;

/// Create a copy of PartyChallenge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? instructions = null,Object? pointsUnits = null,Object? startsAt = null,Object? endsAt = null,Object? status = null,Object? winnerIds = null,Object? createdByUserId = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_PartyChallenge(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,pointsUnits: null == pointsUnits ? _self.pointsUnits : pointsUnits // ignore: cast_nullable_to_non_nullable
as int,startsAt: null == startsAt ? _self.startsAt : startsAt // ignore: cast_nullable_to_non_nullable
as DateTime,endsAt: null == endsAt ? _self.endsAt : endsAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PartyChallengeStatus,winnerIds: null == winnerIds ? _self._winnerIds : winnerIds // ignore: cast_nullable_to_non_nullable
as List<String>,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
