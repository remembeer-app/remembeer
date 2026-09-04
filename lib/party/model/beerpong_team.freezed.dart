// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'beerpong_team.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BeerpongTeam {

 String get id; String get name; List<String> get memberIds; int get seed; int? get placement;
/// Create a copy of BeerpongTeam
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BeerpongTeamCopyWith<BeerpongTeam> get copyWith => _$BeerpongTeamCopyWithImpl<BeerpongTeam>(this as BeerpongTeam, _$identity);

  /// Serializes this BeerpongTeam to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BeerpongTeam;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BeerpongTeam&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.memberIds, _this.memberIds)&&(identical(other.seed, _this.seed) || other.seed == _this.seed)&&(identical(other.placement, _this.placement) || other.placement == _this.placement));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BeerpongTeam;
  return Object.hash(runtimeType,_this.id,_this.name,const DeepCollectionEquality().hash(_this.memberIds),_this.seed,_this.placement);
}

@override
String toString() {
  final _this = this as BeerpongTeam;
  return 'BeerpongTeam(id: ${_this.id}, name: ${_this.name}, memberIds: ${_this.memberIds}, seed: ${_this.seed}, placement: ${_this.placement})';
}


}

/// @nodoc
abstract mixin class $BeerpongTeamCopyWith<$Res>  {
  factory $BeerpongTeamCopyWith(BeerpongTeam value, $Res Function(BeerpongTeam) _then) = _$BeerpongTeamCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<String> memberIds, int seed, int? placement
});




}
/// @nodoc
class _$BeerpongTeamCopyWithImpl<$Res>
    implements $BeerpongTeamCopyWith<$Res> {
  _$BeerpongTeamCopyWithImpl(this._self, this._then);

  final BeerpongTeam _self;
  final $Res Function(BeerpongTeam) _then;

/// Create a copy of BeerpongTeam
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? memberIds = null,Object? seed = null,Object? placement = freezed,}) {
  return _then(BeerpongTeam(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,memberIds: null == memberIds ? _self.memberIds : memberIds // ignore: cast_nullable_to_non_nullable
as List<String>,seed: null == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int,placement: freezed == placement ? _self.placement : placement // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [BeerpongTeam].
extension BeerpongTeamPatterns on BeerpongTeam {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BeerpongTeam value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BeerpongTeam() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BeerpongTeam value)  $default,){
final _that = this;
switch (_that) {
case _BeerpongTeam():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BeerpongTeam value)?  $default,){
final _that = this;
switch (_that) {
case _BeerpongTeam() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<String> memberIds,  int seed,  int? placement)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BeerpongTeam() when $default != null:
return $default(_that.id,_that.name,_that.memberIds,_that.seed,_that.placement);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<String> memberIds,  int seed,  int? placement)  $default,) {final _that = this;
switch (_that) {
case _BeerpongTeam():
return $default(_that.id,_that.name,_that.memberIds,_that.seed,_that.placement);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<String> memberIds,  int seed,  int? placement)?  $default,) {final _that = this;
switch (_that) {
case _BeerpongTeam() when $default != null:
return $default(_that.id,_that.name,_that.memberIds,_that.seed,_that.placement);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BeerpongTeam implements BeerpongTeam {
  const _BeerpongTeam({required this.id, required this.name,  List<String> memberIds = const <String>[], required this.seed, this.placement}): _memberIds = memberIds;
  factory _BeerpongTeam.fromJson(Map<String, dynamic> json) => _$BeerpongTeamFromJson(json);

@override final  String id;
@override final  String name;
 final  List<String> _memberIds;
@override@JsonKey() List<String> get memberIds {
  if (_memberIds is EqualUnmodifiableListView) return _memberIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memberIds);
}

@override final  int seed;
@override final  int? placement;

/// Create a copy of BeerpongTeam
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BeerpongTeamCopyWith<_BeerpongTeam> get copyWith => __$BeerpongTeamCopyWithImpl<_BeerpongTeam>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BeerpongTeamToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BeerpongTeam&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.memberIds, _memberIds)&&(identical(other.seed, seed) || other.seed == seed)&&(identical(other.placement, placement) || other.placement == placement));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_memberIds),seed,placement);
}

@override
String toString() {
    return 'BeerpongTeam(id: $id, name: $name, memberIds: $memberIds, seed: $seed, placement: $placement)';
}


}

/// @nodoc
abstract mixin class _$BeerpongTeamCopyWith<$Res> implements $BeerpongTeamCopyWith<$Res> {
  factory _$BeerpongTeamCopyWith(_BeerpongTeam value, $Res Function(_BeerpongTeam) _then) = __$BeerpongTeamCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<String> memberIds, int seed, int? placement
});




}
/// @nodoc
class __$BeerpongTeamCopyWithImpl<$Res>
    implements _$BeerpongTeamCopyWith<$Res> {
  __$BeerpongTeamCopyWithImpl(this._self, this._then);

  final _BeerpongTeam _self;
  final $Res Function(_BeerpongTeam) _then;

/// Create a copy of BeerpongTeam
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? memberIds = null,Object? seed = null,Object? placement = freezed,}) {
  return _then(_BeerpongTeam(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,memberIds: null == memberIds ? _self._memberIds : memberIds // ignore: cast_nullable_to_non_nullable
as List<String>,seed: null == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int,placement: freezed == placement ? _self.placement : placement // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
