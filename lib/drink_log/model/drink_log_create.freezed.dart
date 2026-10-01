// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drink_log_create.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DrinkLogCreate {

 DateTime get consumedAt; DrinkSnapshot get drink; int get volumeInMilliliters;@GeoPointConverter() GeoPoint? get location;
/// Create a copy of DrinkLogCreate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrinkLogCreateCopyWith<DrinkLogCreate> get copyWith => _$DrinkLogCreateCopyWithImpl<DrinkLogCreate>(this as DrinkLogCreate, _$identity);

  /// Serializes this DrinkLogCreate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DrinkLogCreate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrinkLogCreate&&(identical(other.consumedAt, _this.consumedAt) || other.consumedAt == _this.consumedAt)&&(identical(other.drink, _this.drink) || other.drink == _this.drink)&&(identical(other.volumeInMilliliters, _this.volumeInMilliliters) || other.volumeInMilliliters == _this.volumeInMilliliters)&&(identical(other.location, _this.location) || other.location == _this.location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DrinkLogCreate;
  return Object.hash(runtimeType,_this.consumedAt,_this.drink,_this.volumeInMilliliters,_this.location);
}

@override
String toString() {
  final _this = this as DrinkLogCreate;
  return 'DrinkLogCreate(consumedAt: ${_this.consumedAt}, drink: ${_this.drink}, volumeInMilliliters: ${_this.volumeInMilliliters}, location: ${_this.location})';
}


}

/// @nodoc
abstract mixin class $DrinkLogCreateCopyWith<$Res>  {
  factory $DrinkLogCreateCopyWith(DrinkLogCreate value, $Res Function(DrinkLogCreate) _then) = _$DrinkLogCreateCopyWithImpl;
@useResult
$Res call({
 DateTime consumedAt, DrinkSnapshot drink, int volumeInMilliliters,@GeoPointConverter() GeoPoint? location
});


$DrinkSnapshotCopyWith<$Res> get drink;

}
/// @nodoc
class _$DrinkLogCreateCopyWithImpl<$Res>
    implements $DrinkLogCreateCopyWith<$Res> {
  _$DrinkLogCreateCopyWithImpl(this._self, this._then);

  final DrinkLogCreate _self;
  final $Res Function(DrinkLogCreate) _then;

/// Create a copy of DrinkLogCreate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? consumedAt = null,Object? drink = null,Object? volumeInMilliliters = null,Object? location = freezed,}) {
  return _then(DrinkLogCreate(
consumedAt: null == consumedAt ? _self.consumedAt : consumedAt // ignore: cast_nullable_to_non_nullable
as DateTime,drink: null == drink ? _self.drink : drink // ignore: cast_nullable_to_non_nullable
as DrinkSnapshot,volumeInMilliliters: null == volumeInMilliliters ? _self.volumeInMilliliters : volumeInMilliliters // ignore: cast_nullable_to_non_nullable
as int,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint?,
  ));
}
/// Create a copy of DrinkLogCreate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrinkSnapshotCopyWith<$Res> get drink {
  
  return $DrinkSnapshotCopyWith<$Res>(_self.drink, (value) {
    return _then(_self.copyWith(drink: value));
  });
}
}


/// Adds pattern-matching-related methods to [DrinkLogCreate].
extension DrinkLogCreatePatterns on DrinkLogCreate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrinkLogCreate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrinkLogCreate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrinkLogCreate value)  $default,){
final _that = this;
switch (_that) {
case _DrinkLogCreate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrinkLogCreate value)?  $default,){
final _that = this;
switch (_that) {
case _DrinkLogCreate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime consumedAt,  DrinkSnapshot drink,  int volumeInMilliliters, @GeoPointConverter()  GeoPoint? location)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrinkLogCreate() when $default != null:
return $default(_that.consumedAt,_that.drink,_that.volumeInMilliliters,_that.location);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime consumedAt,  DrinkSnapshot drink,  int volumeInMilliliters, @GeoPointConverter()  GeoPoint? location)  $default,) {final _that = this;
switch (_that) {
case _DrinkLogCreate():
return $default(_that.consumedAt,_that.drink,_that.volumeInMilliliters,_that.location);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime consumedAt,  DrinkSnapshot drink,  int volumeInMilliliters, @GeoPointConverter()  GeoPoint? location)?  $default,) {final _that = this;
switch (_that) {
case _DrinkLogCreate() when $default != null:
return $default(_that.consumedAt,_that.drink,_that.volumeInMilliliters,_that.location);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DrinkLogCreate implements DrinkLogCreate {
  const _DrinkLogCreate({required this.consumedAt, required this.drink, required this.volumeInMilliliters, @GeoPointConverter() this.location});
  factory _DrinkLogCreate.fromJson(Map<String, dynamic> json) => _$DrinkLogCreateFromJson(json);

@override final  DateTime consumedAt;
@override final  DrinkSnapshot drink;
@override final  int volumeInMilliliters;
@override@GeoPointConverter() final  GeoPoint? location;

/// Create a copy of DrinkLogCreate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrinkLogCreateCopyWith<_DrinkLogCreate> get copyWith => __$DrinkLogCreateCopyWithImpl<_DrinkLogCreate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DrinkLogCreateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrinkLogCreate&&(identical(other.consumedAt, consumedAt) || other.consumedAt == consumedAt)&&(identical(other.drink, drink) || other.drink == drink)&&(identical(other.volumeInMilliliters, volumeInMilliliters) || other.volumeInMilliliters == volumeInMilliliters)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,consumedAt,drink,volumeInMilliliters,location);
}

@override
String toString() {
    return 'DrinkLogCreate(consumedAt: $consumedAt, drink: $drink, volumeInMilliliters: $volumeInMilliliters, location: $location)';
}


}

/// @nodoc
abstract mixin class _$DrinkLogCreateCopyWith<$Res> implements $DrinkLogCreateCopyWith<$Res> {
  factory _$DrinkLogCreateCopyWith(_DrinkLogCreate value, $Res Function(_DrinkLogCreate) _then) = __$DrinkLogCreateCopyWithImpl;
@override @useResult
$Res call({
 DateTime consumedAt, DrinkSnapshot drink, int volumeInMilliliters,@GeoPointConverter() GeoPoint? location
});


@override $DrinkSnapshotCopyWith<$Res> get drink;

}
/// @nodoc
class __$DrinkLogCreateCopyWithImpl<$Res>
    implements _$DrinkLogCreateCopyWith<$Res> {
  __$DrinkLogCreateCopyWithImpl(this._self, this._then);

  final _DrinkLogCreate _self;
  final $Res Function(_DrinkLogCreate) _then;

/// Create a copy of DrinkLogCreate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? consumedAt = null,Object? drink = null,Object? volumeInMilliliters = null,Object? location = freezed,}) {
  return _then(_DrinkLogCreate(
consumedAt: null == consumedAt ? _self.consumedAt : consumedAt // ignore: cast_nullable_to_non_nullable
as DateTime,drink: null == drink ? _self.drink : drink // ignore: cast_nullable_to_non_nullable
as DrinkSnapshot,volumeInMilliliters: null == volumeInMilliliters ? _self.volumeInMilliliters : volumeInMilliliters // ignore: cast_nullable_to_non_nullable
as int,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint?,
  ));
}

/// Create a copy of DrinkLogCreate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrinkSnapshotCopyWith<$Res> get drink {
  
  return $DrinkSnapshotCopyWith<$Res>(_self.drink, (value) {
    return _then(_self.copyWith(drink: value));
  });
}
}

// dart format on
