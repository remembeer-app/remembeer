// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drink_type_create.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DrinkTypeCreate {

 String get name; DrinkCategory get category; double get alcoholPercentage;
/// Create a copy of DrinkTypeCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrinkTypeCreateCopyWith<DrinkTypeCreate> get copyWith => _$DrinkTypeCreateCopyWithImpl<DrinkTypeCreate>(this as DrinkTypeCreate, _$identity);

  /// Serializes this DrinkTypeCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrinkTypeCreate&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.alcoholPercentage, alcoholPercentage) || other.alcoholPercentage == alcoholPercentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,category,alcoholPercentage);

@override
String toString() {
  return 'DrinkTypeCreate(name: $name, category: $category, alcoholPercentage: $alcoholPercentage)';
}


}

/// @nodoc
abstract mixin class $DrinkTypeCreateCopyWith<$Res>  {
  factory $DrinkTypeCreateCopyWith(DrinkTypeCreate value, $Res Function(DrinkTypeCreate) _then) = _$DrinkTypeCreateCopyWithImpl;
@useResult
$Res call({
 String name, DrinkCategory category, double alcoholPercentage
});




}
/// @nodoc
class _$DrinkTypeCreateCopyWithImpl<$Res>
    implements $DrinkTypeCreateCopyWith<$Res> {
  _$DrinkTypeCreateCopyWithImpl(this._self, this._then);

  final DrinkTypeCreate _self;
  final $Res Function(DrinkTypeCreate) _then;

/// Create a copy of DrinkTypeCreate
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


/// Adds pattern-matching-related methods to [DrinkTypeCreate].
extension DrinkTypeCreatePatterns on DrinkTypeCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrinkTypeCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrinkTypeCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrinkTypeCreate value)  $default,){
final _that = this;
switch (_that) {
case _DrinkTypeCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrinkTypeCreate value)?  $default,){
final _that = this;
switch (_that) {
case _DrinkTypeCreate() when $default != null:
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
case _DrinkTypeCreate() when $default != null:
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
case _DrinkTypeCreate():
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
case _DrinkTypeCreate() when $default != null:
return $default(_that.name,_that.category,_that.alcoholPercentage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DrinkTypeCreate implements DrinkTypeCreate {
  const _DrinkTypeCreate({required this.name, required this.category, required this.alcoholPercentage});
  factory _DrinkTypeCreate.fromJson(Map<String, dynamic> json) => _$DrinkTypeCreateFromJson(json);

@override final  String name;
@override final  DrinkCategory category;
@override final  double alcoholPercentage;

/// Create a copy of DrinkTypeCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrinkTypeCreateCopyWith<_DrinkTypeCreate> get copyWith => __$DrinkTypeCreateCopyWithImpl<_DrinkTypeCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DrinkTypeCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrinkTypeCreate&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.alcoholPercentage, alcoholPercentage) || other.alcoholPercentage == alcoholPercentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,category,alcoholPercentage);

@override
String toString() {
  return 'DrinkTypeCreate(name: $name, category: $category, alcoholPercentage: $alcoholPercentage)';
}


}

/// @nodoc
abstract mixin class _$DrinkTypeCreateCopyWith<$Res> implements $DrinkTypeCreateCopyWith<$Res> {
  factory _$DrinkTypeCreateCopyWith(_DrinkTypeCreate value, $Res Function(_DrinkTypeCreate) _then) = __$DrinkTypeCreateCopyWithImpl;
@override @useResult
$Res call({
 String name, DrinkCategory category, double alcoholPercentage
});




}
/// @nodoc
class __$DrinkTypeCreateCopyWithImpl<$Res>
    implements _$DrinkTypeCreateCopyWith<$Res> {
  __$DrinkTypeCreateCopyWithImpl(this._self, this._then);

  final _DrinkTypeCreate _self;
  final $Res Function(_DrinkTypeCreate) _then;

/// Create a copy of DrinkTypeCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? category = null,Object? alcoholPercentage = null,}) {
  return _then(_DrinkTypeCreate(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DrinkCategory,alcoholPercentage: null == alcoholPercentage ? _self.alcoholPercentage : alcoholPercentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
