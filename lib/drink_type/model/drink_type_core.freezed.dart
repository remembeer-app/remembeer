// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drink_type_core.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DrinkTypeCore {

 String get name; DrinkCategory get category; double get alcoholPercentage;
/// Create a copy of DrinkTypeCore
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrinkTypeCoreCopyWith<DrinkTypeCore> get copyWith => _$DrinkTypeCoreCopyWithImpl<DrinkTypeCore>(this as DrinkTypeCore, _$identity);

  /// Serializes this DrinkTypeCore to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrinkTypeCore&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.alcoholPercentage, alcoholPercentage) || other.alcoholPercentage == alcoholPercentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,category,alcoholPercentage);

@override
String toString() {
  return 'DrinkTypeCore(name: $name, category: $category, alcoholPercentage: $alcoholPercentage)';
}


}

/// @nodoc
abstract mixin class $DrinkTypeCoreCopyWith<$Res>  {
  factory $DrinkTypeCoreCopyWith(DrinkTypeCore value, $Res Function(DrinkTypeCore) _then) = _$DrinkTypeCoreCopyWithImpl;
@useResult
$Res call({
 String name, DrinkCategory category, double alcoholPercentage
});




}
/// @nodoc
class _$DrinkTypeCoreCopyWithImpl<$Res>
    implements $DrinkTypeCoreCopyWith<$Res> {
  _$DrinkTypeCoreCopyWithImpl(this._self, this._then);

  final DrinkTypeCore _self;
  final $Res Function(DrinkTypeCore) _then;

/// Create a copy of DrinkTypeCore
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? category = null,Object? alcoholPercentage = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DrinkCategory,alcoholPercentage: null == alcoholPercentage ? _self.alcoholPercentage : alcoholPercentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DrinkTypeCore].
extension DrinkTypeCorePatterns on DrinkTypeCore {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrinkTypeCore value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrinkTypeCore() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrinkTypeCore value)  $default,){
final _that = this;
switch (_that) {
case _DrinkTypeCore():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrinkTypeCore value)?  $default,){
final _that = this;
switch (_that) {
case _DrinkTypeCore() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  DrinkCategory category,  double alcoholPercentage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrinkTypeCore() when $default != null:
return $default(_that.name,_that.category,_that.alcoholPercentage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  DrinkCategory category,  double alcoholPercentage)  $default,) {final _that = this;
switch (_that) {
case _DrinkTypeCore():
return $default(_that.name,_that.category,_that.alcoholPercentage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  DrinkCategory category,  double alcoholPercentage)?  $default,) {final _that = this;
switch (_that) {
case _DrinkTypeCore() when $default != null:
return $default(_that.name,_that.category,_that.alcoholPercentage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DrinkTypeCore implements DrinkTypeCore {
  const _DrinkTypeCore({required this.name, required this.category, required this.alcoholPercentage});
  factory _DrinkTypeCore.fromJson(Map<String, dynamic> json) => _$DrinkTypeCoreFromJson(json);

@override final  String name;
@override final  DrinkCategory category;
@override final  double alcoholPercentage;

/// Create a copy of DrinkTypeCore
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrinkTypeCoreCopyWith<_DrinkTypeCore> get copyWith => __$DrinkTypeCoreCopyWithImpl<_DrinkTypeCore>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DrinkTypeCoreToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrinkTypeCore&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.alcoholPercentage, alcoholPercentage) || other.alcoholPercentage == alcoholPercentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,category,alcoholPercentage);

@override
String toString() {
  return 'DrinkTypeCore(name: $name, category: $category, alcoholPercentage: $alcoholPercentage)';
}


}

/// @nodoc
abstract mixin class _$DrinkTypeCoreCopyWith<$Res> implements $DrinkTypeCoreCopyWith<$Res> {
  factory _$DrinkTypeCoreCopyWith(_DrinkTypeCore value, $Res Function(_DrinkTypeCore) _then) = __$DrinkTypeCoreCopyWithImpl;
@override @useResult
$Res call({
 String name, DrinkCategory category, double alcoholPercentage
});




}
/// @nodoc
class __$DrinkTypeCoreCopyWithImpl<$Res>
    implements _$DrinkTypeCoreCopyWith<$Res> {
  __$DrinkTypeCoreCopyWithImpl(this._self, this._then);

  final _DrinkTypeCore _self;
  final $Res Function(_DrinkTypeCore) _then;

/// Create a copy of DrinkTypeCore
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? category = null,Object? alcoholPercentage = null,}) {
  return _then(_DrinkTypeCore(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DrinkCategory,alcoholPercentage: null == alcoholPercentage ? _self.alcoholPercentage : alcoholPercentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
