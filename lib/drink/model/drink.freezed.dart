// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drink.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Drink {

 String get id; String get userId;@TimestampConverterOptimistic() DateTime get createdAt;@TimestampConverterOptimistic() DateTime get updatedAt;@TimestampConverter() DateTime? get deletedAt; DateTime get consumedAt; DrinkTypeCore get drinkType; int get volumeInMilliliters;@GeoPointConverter() GeoPoint? get location;
/// Create a copy of Drink
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrinkCopyWith<Drink> get copyWith => _$DrinkCopyWithImpl<Drink>(this as Drink, _$identity);

  /// Serializes this Drink to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Drink&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.consumedAt, consumedAt) || other.consumedAt == consumedAt)&&(identical(other.drinkType, drinkType) || other.drinkType == drinkType)&&(identical(other.volumeInMilliliters, volumeInMilliliters) || other.volumeInMilliliters == volumeInMilliliters)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,createdAt,updatedAt,deletedAt,consumedAt,drinkType,volumeInMilliliters,location);

@override
String toString() {
  return 'Drink(id: $id, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, consumedAt: $consumedAt, drinkType: $drinkType, volumeInMilliliters: $volumeInMilliliters, location: $location)';
}


}

/// @nodoc
abstract mixin class $DrinkCopyWith<$Res>  {
  factory $DrinkCopyWith(Drink value, $Res Function(Drink) _then) = _$DrinkCopyWithImpl;
@useResult
$Res call({
 String id, String userId,@TimestampConverterOptimistic() DateTime createdAt,@TimestampConverterOptimistic() DateTime updatedAt,@TimestampConverter() DateTime? deletedAt, DateTime consumedAt, DrinkTypeCore drinkType, int volumeInMilliliters,@GeoPointConverter() GeoPoint? location
});


$DrinkTypeCoreCopyWith<$Res> get drinkType;

}
/// @nodoc
class _$DrinkCopyWithImpl<$Res>
    implements $DrinkCopyWith<$Res> {
  _$DrinkCopyWithImpl(this._self, this._then);

  final Drink _self;
  final $Res Function(Drink) _then;

/// Create a copy of Drink
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? consumedAt = null,Object? drinkType = null,Object? volumeInMilliliters = null,Object? location = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,consumedAt: null == consumedAt ? _self.consumedAt : consumedAt // ignore: cast_nullable_to_non_nullable
as DateTime,drinkType: null == drinkType ? _self.drinkType : drinkType // ignore: cast_nullable_to_non_nullable
as DrinkTypeCore,volumeInMilliliters: null == volumeInMilliliters ? _self.volumeInMilliliters : volumeInMilliliters // ignore: cast_nullable_to_non_nullable
as int,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint?,
  ));
}
/// Create a copy of Drink
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrinkTypeCoreCopyWith<$Res> get drinkType {
  
  return $DrinkTypeCoreCopyWith<$Res>(_self.drinkType, (value) {
    return _then(_self.copyWith(drinkType: value));
  });
}
}


/// Adds pattern-matching-related methods to [Drink].
extension DrinkPatterns on Drink {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Drink value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Drink() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Drink value)  $default,){
final _that = this;
switch (_that) {
case _Drink():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Drink value)?  $default,){
final _that = this;
switch (_that) {
case _Drink() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId, @TimestampConverterOptimistic()  DateTime createdAt, @TimestampConverterOptimistic()  DateTime updatedAt, @TimestampConverter()  DateTime? deletedAt,  DateTime consumedAt,  DrinkTypeCore drinkType,  int volumeInMilliliters, @GeoPointConverter()  GeoPoint? location)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Drink() when $default != null:
return $default(_that.id,_that.userId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.consumedAt,_that.drinkType,_that.volumeInMilliliters,_that.location);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId, @TimestampConverterOptimistic()  DateTime createdAt, @TimestampConverterOptimistic()  DateTime updatedAt, @TimestampConverter()  DateTime? deletedAt,  DateTime consumedAt,  DrinkTypeCore drinkType,  int volumeInMilliliters, @GeoPointConverter()  GeoPoint? location)  $default,) {final _that = this;
switch (_that) {
case _Drink():
return $default(_that.id,_that.userId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.consumedAt,_that.drinkType,_that.volumeInMilliliters,_that.location);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId, @TimestampConverterOptimistic()  DateTime createdAt, @TimestampConverterOptimistic()  DateTime updatedAt, @TimestampConverter()  DateTime? deletedAt,  DateTime consumedAt,  DrinkTypeCore drinkType,  int volumeInMilliliters, @GeoPointConverter()  GeoPoint? location)?  $default,) {final _that = this;
switch (_that) {
case _Drink() when $default != null:
return $default(_that.id,_that.userId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.consumedAt,_that.drinkType,_that.volumeInMilliliters,_that.location);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Drink implements Drink {
  const _Drink({required this.id, required this.userId, @TimestampConverterOptimistic() required this.createdAt, @TimestampConverterOptimistic() required this.updatedAt, @TimestampConverter() this.deletedAt, required this.consumedAt, required this.drinkType, required this.volumeInMilliliters, @GeoPointConverter() this.location});
  factory _Drink.fromJson(Map<String, dynamic> json) => _$DrinkFromJson(json);

@override final  String id;
@override final  String userId;
@override@TimestampConverterOptimistic() final  DateTime createdAt;
@override@TimestampConverterOptimistic() final  DateTime updatedAt;
@override@TimestampConverter() final  DateTime? deletedAt;
@override final  DateTime consumedAt;
@override final  DrinkTypeCore drinkType;
@override final  int volumeInMilliliters;
@override@GeoPointConverter() final  GeoPoint? location;

/// Create a copy of Drink
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrinkCopyWith<_Drink> get copyWith => __$DrinkCopyWithImpl<_Drink>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DrinkToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Drink&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.consumedAt, consumedAt) || other.consumedAt == consumedAt)&&(identical(other.drinkType, drinkType) || other.drinkType == drinkType)&&(identical(other.volumeInMilliliters, volumeInMilliliters) || other.volumeInMilliliters == volumeInMilliliters)&&(identical(other.location, location) || other.location == location));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,createdAt,updatedAt,deletedAt,consumedAt,drinkType,volumeInMilliliters,location);

@override
String toString() {
  return 'Drink(id: $id, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, consumedAt: $consumedAt, drinkType: $drinkType, volumeInMilliliters: $volumeInMilliliters, location: $location)';
}


}

/// @nodoc
abstract mixin class _$DrinkCopyWith<$Res> implements $DrinkCopyWith<$Res> {
  factory _$DrinkCopyWith(_Drink value, $Res Function(_Drink) _then) = __$DrinkCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId,@TimestampConverterOptimistic() DateTime createdAt,@TimestampConverterOptimistic() DateTime updatedAt,@TimestampConverter() DateTime? deletedAt, DateTime consumedAt, DrinkTypeCore drinkType, int volumeInMilliliters,@GeoPointConverter() GeoPoint? location
});


@override $DrinkTypeCoreCopyWith<$Res> get drinkType;

}
/// @nodoc
class __$DrinkCopyWithImpl<$Res>
    implements _$DrinkCopyWith<$Res> {
  __$DrinkCopyWithImpl(this._self, this._then);

  final _Drink _self;
  final $Res Function(_Drink) _then;

/// Create a copy of Drink
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? consumedAt = null,Object? drinkType = null,Object? volumeInMilliliters = null,Object? location = freezed,}) {
  return _then(_Drink(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,consumedAt: null == consumedAt ? _self.consumedAt : consumedAt // ignore: cast_nullable_to_non_nullable
as DateTime,drinkType: null == drinkType ? _self.drinkType : drinkType // ignore: cast_nullable_to_non_nullable
as DrinkTypeCore,volumeInMilliliters: null == volumeInMilliliters ? _self.volumeInMilliliters : volumeInMilliliters // ignore: cast_nullable_to_non_nullable
as int,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint?,
  ));
}

/// Create a copy of Drink
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrinkTypeCoreCopyWith<$Res> get drinkType {
  
  return $DrinkTypeCoreCopyWith<$Res>(_self.drinkType, (value) {
    return _then(_self.copyWith(drinkType: value));
  });
}
}

// dart format on
