// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_request_create.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FriendRequestCreate {

 String get toUserId;
/// Create a copy of FriendRequestCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FriendRequestCreateCopyWith<FriendRequestCreate> get copyWith => _$FriendRequestCreateCopyWithImpl<FriendRequestCreate>(this as FriendRequestCreate, _$identity);

  /// Serializes this FriendRequestCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FriendRequestCreate&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,toUserId);

@override
String toString() {
  return 'FriendRequestCreate(toUserId: $toUserId)';
}


}

/// @nodoc
abstract mixin class $FriendRequestCreateCopyWith<$Res>  {
  factory $FriendRequestCreateCopyWith(FriendRequestCreate value, $Res Function(FriendRequestCreate) _then) = _$FriendRequestCreateCopyWithImpl;
@useResult
$Res call({
 String toUserId
});




}
/// @nodoc
class _$FriendRequestCreateCopyWithImpl<$Res>
    implements $FriendRequestCreateCopyWith<$Res> {
  _$FriendRequestCreateCopyWithImpl(this._self, this._then);

  final FriendRequestCreate _self;
  final $Res Function(FriendRequestCreate) _then;

/// Create a copy of FriendRequestCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? toUserId = null,}) {
  return _then(_self.copyWith(
toUserId: null == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FriendRequestCreate].
extension FriendRequestCreatePatterns on FriendRequestCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FriendRequestCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FriendRequestCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FriendRequestCreate value)  $default,){
final _that = this;
switch (_that) {
case _FriendRequestCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FriendRequestCreate value)?  $default,){
final _that = this;
switch (_that) {
case _FriendRequestCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String toUserId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FriendRequestCreate() when $default != null:
return $default(_that.toUserId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String toUserId)  $default,) {final _that = this;
switch (_that) {
case _FriendRequestCreate():
return $default(_that.toUserId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String toUserId)?  $default,) {final _that = this;
switch (_that) {
case _FriendRequestCreate() when $default != null:
return $default(_that.toUserId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FriendRequestCreate implements FriendRequestCreate {
  const _FriendRequestCreate({required this.toUserId});
  factory _FriendRequestCreate.fromJson(Map<String, dynamic> json) => _$FriendRequestCreateFromJson(json);

@override final  String toUserId;

/// Create a copy of FriendRequestCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FriendRequestCreateCopyWith<_FriendRequestCreate> get copyWith => __$FriendRequestCreateCopyWithImpl<_FriendRequestCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FriendRequestCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FriendRequestCreate&&(identical(other.toUserId, toUserId) || other.toUserId == toUserId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,toUserId);

@override
String toString() {
  return 'FriendRequestCreate(toUserId: $toUserId)';
}


}

/// @nodoc
abstract mixin class _$FriendRequestCreateCopyWith<$Res> implements $FriendRequestCreateCopyWith<$Res> {
  factory _$FriendRequestCreateCopyWith(_FriendRequestCreate value, $Res Function(_FriendRequestCreate) _then) = __$FriendRequestCreateCopyWithImpl;
@override @useResult
$Res call({
 String toUserId
});




}
/// @nodoc
class __$FriendRequestCreateCopyWithImpl<$Res>
    implements _$FriendRequestCreateCopyWith<$Res> {
  __$FriendRequestCreateCopyWithImpl(this._self, this._then);

  final _FriendRequestCreate _self;
  final $Res Function(_FriendRequestCreate) _then;

/// Create a copy of FriendRequestCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? toUserId = null,}) {
  return _then(_FriendRequestCreate(
toUserId: null == toUserId ? _self.toUserId : toUserId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
