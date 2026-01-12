// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unlocked_badge.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnlockedBadge {

 String get badgeId; DateTime get unlockedAt; bool get isShown;
/// Create a copy of UnlockedBadge
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnlockedBadgeCopyWith<UnlockedBadge> get copyWith => _$UnlockedBadgeCopyWithImpl<UnlockedBadge>(this as UnlockedBadge, _$identity);

  /// Serializes this UnlockedBadge to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnlockedBadge&&(identical(other.badgeId, badgeId) || other.badgeId == badgeId)&&(identical(other.unlockedAt, unlockedAt) || other.unlockedAt == unlockedAt)&&(identical(other.isShown, isShown) || other.isShown == isShown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,badgeId,unlockedAt,isShown);

@override
String toString() {
  return 'UnlockedBadge(badgeId: $badgeId, unlockedAt: $unlockedAt, isShown: $isShown)';
}


}

/// @nodoc
abstract mixin class $UnlockedBadgeCopyWith<$Res>  {
  factory $UnlockedBadgeCopyWith(UnlockedBadge value, $Res Function(UnlockedBadge) _then) = _$UnlockedBadgeCopyWithImpl;
@useResult
$Res call({
 String badgeId, DateTime unlockedAt, bool isShown
});




}
/// @nodoc
class _$UnlockedBadgeCopyWithImpl<$Res>
    implements $UnlockedBadgeCopyWith<$Res> {
  _$UnlockedBadgeCopyWithImpl(this._self, this._then);

  final UnlockedBadge _self;
  final $Res Function(UnlockedBadge) _then;

/// Create a copy of UnlockedBadge
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? badgeId = null,Object? unlockedAt = null,Object? isShown = null,}) {
  return _then(_self.copyWith(
badgeId: null == badgeId ? _self.badgeId : badgeId // ignore: cast_nullable_to_non_nullable
as String,unlockedAt: null == unlockedAt ? _self.unlockedAt : unlockedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isShown: null == isShown ? _self.isShown : isShown // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UnlockedBadge].
extension UnlockedBadgePatterns on UnlockedBadge {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UnlockedBadge value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UnlockedBadge() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UnlockedBadge value)  $default,){
final _that = this;
switch (_that) {
case _UnlockedBadge():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UnlockedBadge value)?  $default,){
final _that = this;
switch (_that) {
case _UnlockedBadge() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String badgeId,  DateTime unlockedAt,  bool isShown)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UnlockedBadge() when $default != null:
return $default(_that.badgeId,_that.unlockedAt,_that.isShown);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String badgeId,  DateTime unlockedAt,  bool isShown)  $default,) {final _that = this;
switch (_that) {
case _UnlockedBadge():
return $default(_that.badgeId,_that.unlockedAt,_that.isShown);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String badgeId,  DateTime unlockedAt,  bool isShown)?  $default,) {final _that = this;
switch (_that) {
case _UnlockedBadge() when $default != null:
return $default(_that.badgeId,_that.unlockedAt,_that.isShown);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UnlockedBadge implements UnlockedBadge {
  const _UnlockedBadge({required this.badgeId, required this.unlockedAt, required this.isShown});
  factory _UnlockedBadge.fromJson(Map<String, dynamic> json) => _$UnlockedBadgeFromJson(json);

@override final  String badgeId;
@override final  DateTime unlockedAt;
@override final  bool isShown;

/// Create a copy of UnlockedBadge
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UnlockedBadgeCopyWith<_UnlockedBadge> get copyWith => __$UnlockedBadgeCopyWithImpl<_UnlockedBadge>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UnlockedBadgeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UnlockedBadge&&(identical(other.badgeId, badgeId) || other.badgeId == badgeId)&&(identical(other.unlockedAt, unlockedAt) || other.unlockedAt == unlockedAt)&&(identical(other.isShown, isShown) || other.isShown == isShown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,badgeId,unlockedAt,isShown);

@override
String toString() {
  return 'UnlockedBadge(badgeId: $badgeId, unlockedAt: $unlockedAt, isShown: $isShown)';
}


}

/// @nodoc
abstract mixin class _$UnlockedBadgeCopyWith<$Res> implements $UnlockedBadgeCopyWith<$Res> {
  factory _$UnlockedBadgeCopyWith(_UnlockedBadge value, $Res Function(_UnlockedBadge) _then) = __$UnlockedBadgeCopyWithImpl;
@override @useResult
$Res call({
 String badgeId, DateTime unlockedAt, bool isShown
});




}
/// @nodoc
class __$UnlockedBadgeCopyWithImpl<$Res>
    implements _$UnlockedBadgeCopyWith<$Res> {
  __$UnlockedBadgeCopyWithImpl(this._self, this._then);

  final _UnlockedBadge _self;
  final $Res Function(_UnlockedBadge) _then;

/// Create a copy of UnlockedBadge
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? badgeId = null,Object? unlockedAt = null,Object? isShown = null,}) {
  return _then(_UnlockedBadge(
badgeId: null == badgeId ? _self.badgeId : badgeId // ignore: cast_nullable_to_non_nullable
as String,unlockedAt: null == unlockedAt ? _self.unlockedAt : unlockedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isShown: null == isShown ? _self.isShown : isShown // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
