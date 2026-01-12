// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'badge_definition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BadgeDefinition {

 String get id; String get name; String get description; String get iconPath; BadgeCategory get category; int? get goal;
/// Create a copy of BadgeDefinition
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BadgeDefinitionCopyWith<BadgeDefinition> get copyWith => _$BadgeDefinitionCopyWithImpl<BadgeDefinition>(this as BadgeDefinition, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BadgeDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconPath, iconPath) || other.iconPath == iconPath)&&(identical(other.category, category) || other.category == category)&&(identical(other.goal, goal) || other.goal == goal));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,iconPath,category,goal);

@override
String toString() {
  return 'BadgeDefinition(id: $id, name: $name, description: $description, iconPath: $iconPath, category: $category, goal: $goal)';
}


}

/// @nodoc
abstract mixin class $BadgeDefinitionCopyWith<$Res>  {
  factory $BadgeDefinitionCopyWith(BadgeDefinition value, $Res Function(BadgeDefinition) _then) = _$BadgeDefinitionCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, String iconPath, BadgeCategory category, int? goal
});




}
/// @nodoc
class _$BadgeDefinitionCopyWithImpl<$Res>
    implements $BadgeDefinitionCopyWith<$Res> {
  _$BadgeDefinitionCopyWithImpl(this._self, this._then);

  final BadgeDefinition _self;
  final $Res Function(BadgeDefinition) _then;

/// Create a copy of BadgeDefinition
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? iconPath = null,Object? category = null,Object? goal = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,iconPath: null == iconPath ? _self.iconPath : iconPath // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as BadgeCategory,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [BadgeDefinition].
extension BadgeDefinitionPatterns on BadgeDefinition {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BadgeDefinition value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BadgeDefinition() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BadgeDefinition value)  $default,){
final _that = this;
switch (_that) {
case _BadgeDefinition():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BadgeDefinition value)?  $default,){
final _that = this;
switch (_that) {
case _BadgeDefinition() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String iconPath,  BadgeCategory category,  int? goal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BadgeDefinition() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.iconPath,_that.category,_that.goal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String iconPath,  BadgeCategory category,  int? goal)  $default,) {final _that = this;
switch (_that) {
case _BadgeDefinition():
return $default(_that.id,_that.name,_that.description,_that.iconPath,_that.category,_that.goal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  String iconPath,  BadgeCategory category,  int? goal)?  $default,) {final _that = this;
switch (_that) {
case _BadgeDefinition() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.iconPath,_that.category,_that.goal);case _:
  return null;

}
}

}

/// @nodoc


class _BadgeDefinition implements BadgeDefinition {
  const _BadgeDefinition({required this.id, required this.name, required this.description, required this.iconPath, required this.category, this.goal});
  

@override final  String id;
@override final  String name;
@override final  String description;
@override final  String iconPath;
@override final  BadgeCategory category;
@override final  int? goal;

/// Create a copy of BadgeDefinition
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BadgeDefinitionCopyWith<_BadgeDefinition> get copyWith => __$BadgeDefinitionCopyWithImpl<_BadgeDefinition>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BadgeDefinition&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconPath, iconPath) || other.iconPath == iconPath)&&(identical(other.category, category) || other.category == category)&&(identical(other.goal, goal) || other.goal == goal));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,iconPath,category,goal);

@override
String toString() {
  return 'BadgeDefinition(id: $id, name: $name, description: $description, iconPath: $iconPath, category: $category, goal: $goal)';
}


}

/// @nodoc
abstract mixin class _$BadgeDefinitionCopyWith<$Res> implements $BadgeDefinitionCopyWith<$Res> {
  factory _$BadgeDefinitionCopyWith(_BadgeDefinition value, $Res Function(_BadgeDefinition) _then) = __$BadgeDefinitionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, String iconPath, BadgeCategory category, int? goal
});




}
/// @nodoc
class __$BadgeDefinitionCopyWithImpl<$Res>
    implements _$BadgeDefinitionCopyWith<$Res> {
  __$BadgeDefinitionCopyWithImpl(this._self, this._then);

  final _BadgeDefinition _self;
  final $Res Function(_BadgeDefinition) _then;

/// Create a copy of BadgeDefinition
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? iconPath = null,Object? category = null,Object? goal = freezed,}) {
  return _then(_BadgeDefinition(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,iconPath: null == iconPath ? _self.iconPath : iconPath // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as BadgeCategory,goal: freezed == goal ? _self.goal : goal // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
