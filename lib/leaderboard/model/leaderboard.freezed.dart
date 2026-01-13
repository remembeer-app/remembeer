// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leaderboard.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Leaderboard {

 String get id; String get userId;@TimestampConverterOptimistic() DateTime get createdAt;@TimestampConverterOptimistic() DateTime get updatedAt;@TimestampConverter() DateTime? get deletedAt; Set<String> get memberIds; Set<String> get bannedMemberIds; String get name; String get iconName; String get inviteCode;
/// Create a copy of Leaderboard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaderboardCopyWith<Leaderboard> get copyWith => _$LeaderboardCopyWithImpl<Leaderboard>(this as Leaderboard, _$identity);

  /// Serializes this Leaderboard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Leaderboard&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&const DeepCollectionEquality().equals(other.memberIds, memberIds)&&const DeepCollectionEquality().equals(other.bannedMemberIds, bannedMemberIds)&&(identical(other.name, name) || other.name == name)&&(identical(other.iconName, iconName) || other.iconName == iconName)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,createdAt,updatedAt,deletedAt,const DeepCollectionEquality().hash(memberIds),const DeepCollectionEquality().hash(bannedMemberIds),name,iconName,inviteCode);

@override
String toString() {
  return 'Leaderboard(id: $id, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, memberIds: $memberIds, bannedMemberIds: $bannedMemberIds, name: $name, iconName: $iconName, inviteCode: $inviteCode)';
}


}

/// @nodoc
abstract mixin class $LeaderboardCopyWith<$Res>  {
  factory $LeaderboardCopyWith(Leaderboard value, $Res Function(Leaderboard) _then) = _$LeaderboardCopyWithImpl;
@useResult
$Res call({
 String id, String userId,@TimestampConverterOptimistic() DateTime createdAt,@TimestampConverterOptimistic() DateTime updatedAt,@TimestampConverter() DateTime? deletedAt, Set<String> memberIds, Set<String> bannedMemberIds, String name, String iconName, String inviteCode
});




}
/// @nodoc
class _$LeaderboardCopyWithImpl<$Res>
    implements $LeaderboardCopyWith<$Res> {
  _$LeaderboardCopyWithImpl(this._self, this._then);

  final Leaderboard _self;
  final $Res Function(Leaderboard) _then;

/// Create a copy of Leaderboard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? memberIds = null,Object? bannedMemberIds = null,Object? name = null,Object? iconName = null,Object? inviteCode = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,memberIds: null == memberIds ? _self.memberIds : memberIds // ignore: cast_nullable_to_non_nullable
as Set<String>,bannedMemberIds: null == bannedMemberIds ? _self.bannedMemberIds : bannedMemberIds // ignore: cast_nullable_to_non_nullable
as Set<String>,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconName: null == iconName ? _self.iconName : iconName // ignore: cast_nullable_to_non_nullable
as String,inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Leaderboard].
extension LeaderboardPatterns on Leaderboard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Leaderboard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Leaderboard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Leaderboard value)  $default,){
final _that = this;
switch (_that) {
case _Leaderboard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Leaderboard value)?  $default,){
final _that = this;
switch (_that) {
case _Leaderboard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId, @TimestampConverterOptimistic()  DateTime createdAt, @TimestampConverterOptimistic()  DateTime updatedAt, @TimestampConverter()  DateTime? deletedAt,  Set<String> memberIds,  Set<String> bannedMemberIds,  String name,  String iconName,  String inviteCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Leaderboard() when $default != null:
return $default(_that.id,_that.userId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.memberIds,_that.bannedMemberIds,_that.name,_that.iconName,_that.inviteCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId, @TimestampConverterOptimistic()  DateTime createdAt, @TimestampConverterOptimistic()  DateTime updatedAt, @TimestampConverter()  DateTime? deletedAt,  Set<String> memberIds,  Set<String> bannedMemberIds,  String name,  String iconName,  String inviteCode)  $default,) {final _that = this;
switch (_that) {
case _Leaderboard():
return $default(_that.id,_that.userId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.memberIds,_that.bannedMemberIds,_that.name,_that.iconName,_that.inviteCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId, @TimestampConverterOptimistic()  DateTime createdAt, @TimestampConverterOptimistic()  DateTime updatedAt, @TimestampConverter()  DateTime? deletedAt,  Set<String> memberIds,  Set<String> bannedMemberIds,  String name,  String iconName,  String inviteCode)?  $default,) {final _that = this;
switch (_that) {
case _Leaderboard() when $default != null:
return $default(_that.id,_that.userId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.memberIds,_that.bannedMemberIds,_that.name,_that.iconName,_that.inviteCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Leaderboard implements Leaderboard {
  const _Leaderboard({required this.id, required this.userId, @TimestampConverterOptimistic() required this.createdAt, @TimestampConverterOptimistic() required this.updatedAt, @TimestampConverter() this.deletedAt, required final  Set<String> memberIds, required final  Set<String> bannedMemberIds, required this.name, required this.iconName, required this.inviteCode}): _memberIds = memberIds,_bannedMemberIds = bannedMemberIds;
  factory _Leaderboard.fromJson(Map<String, dynamic> json) => _$LeaderboardFromJson(json);

@override final  String id;
@override final  String userId;
@override@TimestampConverterOptimistic() final  DateTime createdAt;
@override@TimestampConverterOptimistic() final  DateTime updatedAt;
@override@TimestampConverter() final  DateTime? deletedAt;
 final  Set<String> _memberIds;
@override Set<String> get memberIds {
  if (_memberIds is EqualUnmodifiableSetView) return _memberIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_memberIds);
}

 final  Set<String> _bannedMemberIds;
@override Set<String> get bannedMemberIds {
  if (_bannedMemberIds is EqualUnmodifiableSetView) return _bannedMemberIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_bannedMemberIds);
}

@override final  String name;
@override final  String iconName;
@override final  String inviteCode;

/// Create a copy of Leaderboard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaderboardCopyWith<_Leaderboard> get copyWith => __$LeaderboardCopyWithImpl<_Leaderboard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaderboardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Leaderboard&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&const DeepCollectionEquality().equals(other._memberIds, _memberIds)&&const DeepCollectionEquality().equals(other._bannedMemberIds, _bannedMemberIds)&&(identical(other.name, name) || other.name == name)&&(identical(other.iconName, iconName) || other.iconName == iconName)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,createdAt,updatedAt,deletedAt,const DeepCollectionEquality().hash(_memberIds),const DeepCollectionEquality().hash(_bannedMemberIds),name,iconName,inviteCode);

@override
String toString() {
  return 'Leaderboard(id: $id, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, memberIds: $memberIds, bannedMemberIds: $bannedMemberIds, name: $name, iconName: $iconName, inviteCode: $inviteCode)';
}


}

/// @nodoc
abstract mixin class _$LeaderboardCopyWith<$Res> implements $LeaderboardCopyWith<$Res> {
  factory _$LeaderboardCopyWith(_Leaderboard value, $Res Function(_Leaderboard) _then) = __$LeaderboardCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId,@TimestampConverterOptimistic() DateTime createdAt,@TimestampConverterOptimistic() DateTime updatedAt,@TimestampConverter() DateTime? deletedAt, Set<String> memberIds, Set<String> bannedMemberIds, String name, String iconName, String inviteCode
});




}
/// @nodoc
class __$LeaderboardCopyWithImpl<$Res>
    implements _$LeaderboardCopyWith<$Res> {
  __$LeaderboardCopyWithImpl(this._self, this._then);

  final _Leaderboard _self;
  final $Res Function(_Leaderboard) _then;

/// Create a copy of Leaderboard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? memberIds = null,Object? bannedMemberIds = null,Object? name = null,Object? iconName = null,Object? inviteCode = null,}) {
  return _then(_Leaderboard(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,memberIds: null == memberIds ? _self._memberIds : memberIds // ignore: cast_nullable_to_non_nullable
as Set<String>,bannedMemberIds: null == bannedMemberIds ? _self._bannedMemberIds : bannedMemberIds // ignore: cast_nullable_to_non_nullable
as Set<String>,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconName: null == iconName ? _self.iconName : iconName // ignore: cast_nullable_to_non_nullable
as String,inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
