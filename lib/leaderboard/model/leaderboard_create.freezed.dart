// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leaderboard_create.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LeaderboardCreate {

 String get name; String get iconName; Set<String> get memberIds; Set<String> get bannedMemberIds; String get inviteCode;
/// Create a copy of LeaderboardCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaderboardCreateCopyWith<LeaderboardCreate> get copyWith => _$LeaderboardCreateCopyWithImpl<LeaderboardCreate>(this as LeaderboardCreate, _$identity);

  /// Serializes this LeaderboardCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaderboardCreate&&(identical(other.name, name) || other.name == name)&&(identical(other.iconName, iconName) || other.iconName == iconName)&&const DeepCollectionEquality().equals(other.memberIds, memberIds)&&const DeepCollectionEquality().equals(other.bannedMemberIds, bannedMemberIds)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,iconName,const DeepCollectionEquality().hash(memberIds),const DeepCollectionEquality().hash(bannedMemberIds),inviteCode);

@override
String toString() {
  return 'LeaderboardCreate(name: $name, iconName: $iconName, memberIds: $memberIds, bannedMemberIds: $bannedMemberIds, inviteCode: $inviteCode)';
}


}

/// @nodoc
abstract mixin class $LeaderboardCreateCopyWith<$Res>  {
  factory $LeaderboardCreateCopyWith(LeaderboardCreate value, $Res Function(LeaderboardCreate) _then) = _$LeaderboardCreateCopyWithImpl;
@useResult
$Res call({
 String name, String iconName, Set<String> memberIds, Set<String> bannedMemberIds, String inviteCode
});




}
/// @nodoc
class _$LeaderboardCreateCopyWithImpl<$Res>
    implements $LeaderboardCreateCopyWith<$Res> {
  _$LeaderboardCreateCopyWithImpl(this._self, this._then);

  final LeaderboardCreate _self;
  final $Res Function(LeaderboardCreate) _then;

/// Create a copy of LeaderboardCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? iconName = null,Object? memberIds = null,Object? bannedMemberIds = null,Object? inviteCode = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconName: null == iconName ? _self.iconName : iconName // ignore: cast_nullable_to_non_nullable
as String,memberIds: null == memberIds ? _self.memberIds : memberIds // ignore: cast_nullable_to_non_nullable
as Set<String>,bannedMemberIds: null == bannedMemberIds ? _self.bannedMemberIds : bannedMemberIds // ignore: cast_nullable_to_non_nullable
as Set<String>,inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LeaderboardCreate].
extension LeaderboardCreatePatterns on LeaderboardCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaderboardCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaderboardCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaderboardCreate value)  $default,){
final _that = this;
switch (_that) {
case _LeaderboardCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaderboardCreate value)?  $default,){
final _that = this;
switch (_that) {
case _LeaderboardCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String iconName,  Set<String> memberIds,  Set<String> bannedMemberIds,  String inviteCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaderboardCreate() when $default != null:
return $default(_that.name,_that.iconName,_that.memberIds,_that.bannedMemberIds,_that.inviteCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String iconName,  Set<String> memberIds,  Set<String> bannedMemberIds,  String inviteCode)  $default,) {final _that = this;
switch (_that) {
case _LeaderboardCreate():
return $default(_that.name,_that.iconName,_that.memberIds,_that.bannedMemberIds,_that.inviteCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String iconName,  Set<String> memberIds,  Set<String> bannedMemberIds,  String inviteCode)?  $default,) {final _that = this;
switch (_that) {
case _LeaderboardCreate() when $default != null:
return $default(_that.name,_that.iconName,_that.memberIds,_that.bannedMemberIds,_that.inviteCode);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LeaderboardCreate implements LeaderboardCreate {
  const _LeaderboardCreate({required this.name, required this.iconName, required final  Set<String> memberIds, final  Set<String> bannedMemberIds = const {}, required this.inviteCode}): _memberIds = memberIds,_bannedMemberIds = bannedMemberIds;
  factory _LeaderboardCreate.fromJson(Map<String, dynamic> json) => _$LeaderboardCreateFromJson(json);

@override final  String name;
@override final  String iconName;
 final  Set<String> _memberIds;
@override Set<String> get memberIds {
  if (_memberIds is EqualUnmodifiableSetView) return _memberIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_memberIds);
}

 final  Set<String> _bannedMemberIds;
@override@JsonKey() Set<String> get bannedMemberIds {
  if (_bannedMemberIds is EqualUnmodifiableSetView) return _bannedMemberIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_bannedMemberIds);
}

@override final  String inviteCode;

/// Create a copy of LeaderboardCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaderboardCreateCopyWith<_LeaderboardCreate> get copyWith => __$LeaderboardCreateCopyWithImpl<_LeaderboardCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LeaderboardCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaderboardCreate&&(identical(other.name, name) || other.name == name)&&(identical(other.iconName, iconName) || other.iconName == iconName)&&const DeepCollectionEquality().equals(other._memberIds, _memberIds)&&const DeepCollectionEquality().equals(other._bannedMemberIds, _bannedMemberIds)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,iconName,const DeepCollectionEquality().hash(_memberIds),const DeepCollectionEquality().hash(_bannedMemberIds),inviteCode);

@override
String toString() {
  return 'LeaderboardCreate(name: $name, iconName: $iconName, memberIds: $memberIds, bannedMemberIds: $bannedMemberIds, inviteCode: $inviteCode)';
}


}

/// @nodoc
abstract mixin class _$LeaderboardCreateCopyWith<$Res> implements $LeaderboardCreateCopyWith<$Res> {
  factory _$LeaderboardCreateCopyWith(_LeaderboardCreate value, $Res Function(_LeaderboardCreate) _then) = __$LeaderboardCreateCopyWithImpl;
@override @useResult
$Res call({
 String name, String iconName, Set<String> memberIds, Set<String> bannedMemberIds, String inviteCode
});




}
/// @nodoc
class __$LeaderboardCreateCopyWithImpl<$Res>
    implements _$LeaderboardCreateCopyWith<$Res> {
  __$LeaderboardCreateCopyWithImpl(this._self, this._then);

  final _LeaderboardCreate _self;
  final $Res Function(_LeaderboardCreate) _then;

/// Create a copy of LeaderboardCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? iconName = null,Object? memberIds = null,Object? bannedMemberIds = null,Object? inviteCode = null,}) {
  return _then(_LeaderboardCreate(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,iconName: null == iconName ? _self.iconName : iconName // ignore: cast_nullable_to_non_nullable
as String,memberIds: null == memberIds ? _self._memberIds : memberIds // ignore: cast_nullable_to_non_nullable
as Set<String>,bannedMemberIds: null == bannedMemberIds ? _self._bannedMemberIds : bannedMemberIds // ignore: cast_nullable_to_non_nullable
as Set<String>,inviteCode: null == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
