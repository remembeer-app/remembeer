// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drink_create.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DrinkCreate {

 DateTime get consumedAt; DrinkType get drinkType; int get volumeInMilliliters;@GeoPointConverter() GeoPoint? get location;
/// Create a copy of DrinkCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrinkCreateCopyWith<DrinkCreate> get copyWith => _$DrinkCreateCopyWithImpl<DrinkCreate>(this as DrinkCreate, _$identity);

  /// Serializes this DrinkCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrinkCreate&&(identical(other.consumedAt, consumedAt) || other.consumedAt == consumedAt)&&(identical(other.drinkType, drinkType) || other.drinkType == drinkType)&&(identical(other.volumeInMilliliters, volumeInMilliliters) || other.volumeInMilliliters == volumeInMilliliters)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,consumedAt,drinkType,volumeInMilliliters,location);

@override
String toString() {
  return 'DrinkCreate(consumedAt: $consumedAt, drinkType: $drinkType, volumeInMilliliters: $volumeInMilliliters, location: $location)';
}


}

/// @nodoc
abstract mixin class $DrinkCreateCopyWith<$Res>  {
  factory $DrinkCreateCopyWith(DrinkCreate value, $Res Function(DrinkCreate) _then) = _$DrinkCreateCopyWithImpl;
@useResult
$Res call({
 DateTime consumedAt, DrinkType drinkType, int volumeInMilliliters,@GeoPointConverter() GeoPoint? location
});


$DrinkTypeCopyWith<$Res> get drinkType;

}
/// @nodoc
class _$DrinkCreateCopyWithImpl<$Res>
    implements $DrinkCreateCopyWith<$Res> {
  _$DrinkCreateCopyWithImpl(this._self, this._then);

  final DrinkCreate _self;
  final $Res Function(DrinkCreate) _then;

/// Create a copy of DrinkCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? consumedAt = null,Object? drinkType = null,Object? volumeInMilliliters = null,Object? location = freezed,}) {
  return _then(_self.copyWith(
consumedAt: null == consumedAt ? _self.consumedAt : consumedAt // ignore: cast_nullable_to_non_nullable
as DateTime,drinkType: null == drinkType ? _self.drinkType : drinkType // ignore: cast_nullable_to_non_nullable
as DrinkType,volumeInMilliliters: null == volumeInMilliliters ? _self.volumeInMilliliters : volumeInMilliliters // ignore: cast_nullable_to_non_nullable
as int,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint?,
  ));
}
/// Create a copy of DrinkCreate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrinkTypeCopyWith<$Res> get drinkType {
  
  return $DrinkTypeCopyWith<$Res>(_self.drinkType, (value) {
    return _then(_self.copyWith(drinkType: value));
  });
}
}


/// Adds pattern-matching-related methods to [DrinkCreate].
extension DrinkCreatePatterns on DrinkCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrinkCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrinkCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrinkCreate value)  $default,){
final _that = this;
switch (_that) {
case _DrinkCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrinkCreate value)?  $default,){
final _that = this;
switch (_that) {
case _DrinkCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime consumedAt,  DrinkType drinkType,  int volumeInMilliliters, @GeoPointConverter()  GeoPoint? location)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrinkCreate() when $default != null:
return $default(_that.consumedAt,_that.drinkType,_that.volumeInMilliliters,_that.location);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime consumedAt,  DrinkType drinkType,  int volumeInMilliliters, @GeoPointConverter()  GeoPoint? location)  $default,) {final _that = this;
switch (_that) {
case _DrinkCreate():
return $default(_that.consumedAt,_that.drinkType,_that.volumeInMilliliters,_that.location);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime consumedAt,  DrinkType drinkType,  int volumeInMilliliters, @GeoPointConverter()  GeoPoint? location)?  $default,) {final _that = this;
switch (_that) {
case _DrinkCreate() when $default != null:
return $default(_that.consumedAt,_that.drinkType,_that.volumeInMilliliters,_that.location);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DrinkCreate implements DrinkCreate {
  const _DrinkCreate({required this.consumedAt, required this.drinkType, required this.volumeInMilliliters, @GeoPointConverter() this.location});
  factory _DrinkCreate.fromJson(Map<String, dynamic> json) => _$DrinkCreateFromJson(json);

@override final  DateTime consumedAt;
@override final  DrinkType drinkType;
@override final  int volumeInMilliliters;
@override@GeoPointConverter() final  GeoPoint? location;

/// Create a copy of DrinkCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrinkCreateCopyWith<_DrinkCreate> get copyWith => __$DrinkCreateCopyWithImpl<_DrinkCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DrinkCreateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrinkCreate&&(identical(other.consumedAt, consumedAt) || other.consumedAt == consumedAt)&&(identical(other.drinkType, drinkType) || other.drinkType == drinkType)&&(identical(other.volumeInMilliliters, volumeInMilliliters) || other.volumeInMilliliters == volumeInMilliliters)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,consumedAt,drinkType,volumeInMilliliters,location);

@override
String toString() {
  return 'DrinkCreate(consumedAt: $consumedAt, drinkType: $drinkType, volumeInMilliliters: $volumeInMilliliters, location: $location)';
}


}

/// @nodoc
abstract mixin class _$DrinkCreateCopyWith<$Res> implements $DrinkCreateCopyWith<$Res> {
  factory _$DrinkCreateCopyWith(_DrinkCreate value, $Res Function(_DrinkCreate) _then) = __$DrinkCreateCopyWithImpl;
@override @useResult
$Res call({
 DateTime consumedAt, DrinkType drinkType, int volumeInMilliliters,@GeoPointConverter() GeoPoint? location
});


@override $DrinkTypeCopyWith<$Res> get drinkType;

}
/// @nodoc
class __$DrinkCreateCopyWithImpl<$Res>
    implements _$DrinkCreateCopyWith<$Res> {
  __$DrinkCreateCopyWithImpl(this._self, this._then);

  final _DrinkCreate _self;
  final $Res Function(_DrinkCreate) _then;

/// Create a copy of DrinkCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? consumedAt = null,Object? drinkType = null,Object? volumeInMilliliters = null,Object? location = freezed,}) {
  return _then(_DrinkCreate(
consumedAt: null == consumedAt ? _self.consumedAt : consumedAt // ignore: cast_nullable_to_non_nullable
as DateTime,drinkType: null == drinkType ? _self.drinkType : drinkType // ignore: cast_nullable_to_non_nullable
as DrinkType,volumeInMilliliters: null == volumeInMilliliters ? _self.volumeInMilliliters : volumeInMilliliters // ignore: cast_nullable_to_non_nullable
as int,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint?,
  ));
}

/// Create a copy of DrinkCreate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrinkTypeCopyWith<$Res> get drinkType {
  
  return $DrinkTypeCopyWith<$Res>(_self.drinkType, (value) {
    return _then(_self.copyWith(drinkType: value));
  });
}
}

// dart format on
