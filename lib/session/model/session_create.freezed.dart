// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_create.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionCreate {

 String get name; DateTime get startedAt; DateTime? get endedAt; Set<String> get memberIds;
/// Create a copy of SessionCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionCreateCopyWith<SessionCreate> get copyWith => _$SessionCreateCopyWithImpl<SessionCreate>(this as SessionCreate, _$identity);

  /// Serializes this SessionCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionCreate&&(identical(other.name, name) || other.name == name)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&const DeepCollectionEquality().equals(other.memberIds, memberIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,startedAt,endedAt,const DeepCollectionEquality().hash(memberIds));

@override
String toString() {
  return 'SessionCreate(name: $name, startedAt: $startedAt, endedAt: $endedAt, memberIds: $memberIds)';
}


}

/// @nodoc
abstract mixin class $SessionCreateCopyWith<$Res>  {
  factory $SessionCreateCopyWith(SessionCreate value, $Res Function(SessionCreate) _then) = _$SessionCreateCopyWithImpl;
@useResult
$Res call({
 String name, DateTime startedAt, DateTime? endedAt, Set<String> memberIds
});




}
/// @nodoc
class _$SessionCreateCopyWithImpl<$Res>
    implements $SessionCreateCopyWith<$Res> {
  _$SessionCreateCopyWithImpl(this._self, this._then);

  final SessionCreate _self;
  final $Res Function(SessionCreate) _then;

/// Create a copy of SessionCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? startedAt = null,Object? endedAt = freezed,Object? memberIds = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,memberIds: null == memberIds ? _self.memberIds : memberIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionCreate].
extension SessionCreatePatterns on SessionCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionCreate value)  $default,){
final _that = this;
switch (_that) {
case _SessionCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionCreate value)?  $default,){
final _that = this;
switch (_that) {
case _SessionCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  DateTime startedAt,  DateTime? endedAt,  Set<String> memberIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionCreate() when $default != null:
return $default(_that.name,_that.startedAt,_that.endedAt,_that.memberIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  DateTime startedAt,  DateTime? endedAt,  Set<String> memberIds)  $default,) {final _that = this;
switch (_that) {
case _SessionCreate():
return $default(_that.name,_that.startedAt,_that.endedAt,_that.memberIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  DateTime startedAt,  DateTime? endedAt,  Set<String> memberIds)?  $default,) {final _that = this;
switch (_that) {
case _SessionCreate() when $default != null:
return $default(_that.name,_that.startedAt,_that.endedAt,_that.memberIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionCreate implements SessionCreate {
  const _SessionCreate({required this.name, required this.startedAt, this.endedAt, required final  Set<String> memberIds}): _memberIds = memberIds;
  factory _SessionCreate.fromJson(Map<String, dynamic> json) => _$SessionCreateFromJson(json);

@override final  String name;
@override final  DateTime startedAt;
@override final  DateTime? endedAt;
 final  Set<String> _memberIds;
@override Set<String> get memberIds {
  if (_memberIds is EqualUnmodifiableSetView) return _memberIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_memberIds);
}


/// Create a copy of SessionCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionCreateCopyWith<_SessionCreate> get copyWith => __$SessionCreateCopyWithImpl<_SessionCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionCreate&&(identical(other.name, name) || other.name == name)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&const DeepCollectionEquality().equals(other._memberIds, _memberIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,startedAt,endedAt,const DeepCollectionEquality().hash(_memberIds));

@override
String toString() {
  return 'SessionCreate(name: $name, startedAt: $startedAt, endedAt: $endedAt, memberIds: $memberIds)';
}


}

/// @nodoc
abstract mixin class _$SessionCreateCopyWith<$Res> implements $SessionCreateCopyWith<$Res> {
  factory _$SessionCreateCopyWith(_SessionCreate value, $Res Function(_SessionCreate) _then) = __$SessionCreateCopyWithImpl;
@override @useResult
$Res call({
 String name, DateTime startedAt, DateTime? endedAt, Set<String> memberIds
});




}
/// @nodoc
class __$SessionCreateCopyWithImpl<$Res>
    implements _$SessionCreateCopyWith<$Res> {
  __$SessionCreateCopyWithImpl(this._self, this._then);

  final _SessionCreate _self;
  final $Res Function(_SessionCreate) _then;

/// Create a copy of SessionCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? startedAt = null,Object? endedAt = freezed,Object? memberIds = null,}) {
  return _then(_SessionCreate(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,memberIds: null == memberIds ? _self._memberIds : memberIds // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
