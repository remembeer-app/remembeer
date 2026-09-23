// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drink_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DrinkLog {

 String get id; String get consumedByUserId;@LocalDateTimeConverter() DateTime get consumedAt; DrinkSnapshot get drink;@JsonKey(name: 'drinkId', includeIfNull: false) String? get catalogDrinkId; int get volumeInMilliliters;@GeoPointConverter() GeoPoint? get location;@JsonKey(includeToJson: false) int get partyRevision;
/// Create a copy of DrinkLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrinkLogCopyWith<DrinkLog> get copyWith => _$DrinkLogCopyWithImpl<DrinkLog>(this as DrinkLog, _$identity);

  /// Serializes this DrinkLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DrinkLog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrinkLog&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.consumedByUserId, _this.consumedByUserId) || other.consumedByUserId == _this.consumedByUserId)&&(identical(other.consumedAt, _this.consumedAt) || other.consumedAt == _this.consumedAt)&&(identical(other.drink, _this.drink) || other.drink == _this.drink)&&(identical(other.catalogDrinkId, _this.catalogDrinkId) || other.catalogDrinkId == _this.catalogDrinkId)&&(identical(other.volumeInMilliliters, _this.volumeInMilliliters) || other.volumeInMilliliters == _this.volumeInMilliliters)&&(identical(other.location, _this.location) || other.location == _this.location)&&(identical(other.partyRevision, _this.partyRevision) || other.partyRevision == _this.partyRevision));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DrinkLog;
  return Object.hash(runtimeType,_this.id,_this.consumedByUserId,_this.consumedAt,_this.drink,_this.catalogDrinkId,_this.volumeInMilliliters,_this.location,_this.partyRevision);
}

@override
String toString() {
  final _this = this as DrinkLog;
  return 'DrinkLog(id: ${_this.id}, consumedByUserId: ${_this.consumedByUserId}, consumedAt: ${_this.consumedAt}, drink: ${_this.drink}, catalogDrinkId: ${_this.catalogDrinkId}, volumeInMilliliters: ${_this.volumeInMilliliters}, location: ${_this.location}, partyRevision: ${_this.partyRevision})';
}


}

/// @nodoc
abstract mixin class $DrinkLogCopyWith<$Res>  {
  factory $DrinkLogCopyWith(DrinkLog value, $Res Function(DrinkLog) _then) = _$DrinkLogCopyWithImpl;
@useResult
$Res call({
 String id, String consumedByUserId,@LocalDateTimeConverter() DateTime consumedAt, DrinkSnapshot drink,@JsonKey(name: 'drinkId', includeIfNull: false) String? catalogDrinkId, int volumeInMilliliters,@GeoPointConverter() GeoPoint? location,@JsonKey(includeToJson: false) int partyRevision
});


$DrinkSnapshotCopyWith<$Res> get drink;

}
/// @nodoc
class _$DrinkLogCopyWithImpl<$Res>
    implements $DrinkLogCopyWith<$Res> {
  _$DrinkLogCopyWithImpl(this._self, this._then);

  final DrinkLog _self;
  final $Res Function(DrinkLog) _then;

/// Create a copy of DrinkLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? consumedByUserId = null,Object? consumedAt = null,Object? drink = null,Object? catalogDrinkId = freezed,Object? volumeInMilliliters = null,Object? location = freezed,Object? partyRevision = null,}) {
  return _then(DrinkLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,consumedByUserId: null == consumedByUserId ? _self.consumedByUserId : consumedByUserId // ignore: cast_nullable_to_non_nullable
as String,consumedAt: null == consumedAt ? _self.consumedAt : consumedAt // ignore: cast_nullable_to_non_nullable
as DateTime,drink: null == drink ? _self.drink : drink // ignore: cast_nullable_to_non_nullable
as DrinkSnapshot,catalogDrinkId: freezed == catalogDrinkId ? _self.catalogDrinkId : catalogDrinkId // ignore: cast_nullable_to_non_nullable
as String?,volumeInMilliliters: null == volumeInMilliliters ? _self.volumeInMilliliters : volumeInMilliliters // ignore: cast_nullable_to_non_nullable
as int,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint?,partyRevision: null == partyRevision ? _self.partyRevision : partyRevision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of DrinkLog
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrinkSnapshotCopyWith<$Res> get drink {
  
  return $DrinkSnapshotCopyWith<$Res>(_self.drink, (value) {
    return _then(_self.copyWith(drink: value));
  });
}
}


/// Adds pattern-matching-related methods to [DrinkLog].
extension DrinkLogPatterns on DrinkLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrinkLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrinkLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrinkLog value)  $default,){
final _that = this;
switch (_that) {
case _DrinkLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrinkLog value)?  $default,){
final _that = this;
switch (_that) {
case _DrinkLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String consumedByUserId, @LocalDateTimeConverter()  DateTime consumedAt,  DrinkSnapshot drink, @JsonKey(name: 'drinkId', includeIfNull: false)  String? catalogDrinkId,  int volumeInMilliliters, @GeoPointConverter()  GeoPoint? location, @JsonKey(includeToJson: false)  int partyRevision)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrinkLog() when $default != null:
return $default(_that.id,_that.consumedByUserId,_that.consumedAt,_that.drink,_that.catalogDrinkId,_that.volumeInMilliliters,_that.location,_that.partyRevision);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String consumedByUserId, @LocalDateTimeConverter()  DateTime consumedAt,  DrinkSnapshot drink, @JsonKey(name: 'drinkId', includeIfNull: false)  String? catalogDrinkId,  int volumeInMilliliters, @GeoPointConverter()  GeoPoint? location, @JsonKey(includeToJson: false)  int partyRevision)  $default,) {final _that = this;
switch (_that) {
case _DrinkLog():
return $default(_that.id,_that.consumedByUserId,_that.consumedAt,_that.drink,_that.catalogDrinkId,_that.volumeInMilliliters,_that.location,_that.partyRevision);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String consumedByUserId, @LocalDateTimeConverter()  DateTime consumedAt,  DrinkSnapshot drink, @JsonKey(name: 'drinkId', includeIfNull: false)  String? catalogDrinkId,  int volumeInMilliliters, @GeoPointConverter()  GeoPoint? location, @JsonKey(includeToJson: false)  int partyRevision)?  $default,) {final _that = this;
switch (_that) {
case _DrinkLog() when $default != null:
return $default(_that.id,_that.consumedByUserId,_that.consumedAt,_that.drink,_that.catalogDrinkId,_that.volumeInMilliliters,_that.location,_that.partyRevision);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DrinkLog extends DrinkLog {
  const _DrinkLog({required this.id, required this.consumedByUserId, @LocalDateTimeConverter() required this.consumedAt, required this.drink, @JsonKey(name: 'drinkId', includeIfNull: false) this.catalogDrinkId, required this.volumeInMilliliters, @GeoPointConverter() this.location, @JsonKey(includeToJson: false) this.partyRevision = 1}): super._();
  factory _DrinkLog.fromJson(Map<String, dynamic> json) => _$DrinkLogFromJson(json);

@override final  String id;
@override final  String consumedByUserId;
@override@LocalDateTimeConverter() final  DateTime consumedAt;
@override final  DrinkSnapshot drink;
@override@JsonKey(name: 'drinkId', includeIfNull: false) final  String? catalogDrinkId;
@override final  int volumeInMilliliters;
@override@GeoPointConverter() final  GeoPoint? location;
@override@JsonKey(includeToJson: false) final  int partyRevision;

/// Create a copy of DrinkLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrinkLogCopyWith<_DrinkLog> get copyWith => __$DrinkLogCopyWithImpl<_DrinkLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DrinkLogToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrinkLog&&(identical(other.id, id) || other.id == id)&&(identical(other.consumedByUserId, consumedByUserId) || other.consumedByUserId == consumedByUserId)&&(identical(other.consumedAt, consumedAt) || other.consumedAt == consumedAt)&&(identical(other.drink, drink) || other.drink == drink)&&(identical(other.catalogDrinkId, catalogDrinkId) || other.catalogDrinkId == catalogDrinkId)&&(identical(other.volumeInMilliliters, volumeInMilliliters) || other.volumeInMilliliters == volumeInMilliliters)&&(identical(other.location, location) || other.location == location)&&(identical(other.partyRevision, partyRevision) || other.partyRevision == partyRevision));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,consumedByUserId,consumedAt,drink,catalogDrinkId,volumeInMilliliters,location,partyRevision);
}

@override
String toString() {
    return 'DrinkLog(id: $id, consumedByUserId: $consumedByUserId, consumedAt: $consumedAt, drink: $drink, catalogDrinkId: $catalogDrinkId, volumeInMilliliters: $volumeInMilliliters, location: $location, partyRevision: $partyRevision)';
}


}

/// @nodoc
abstract mixin class _$DrinkLogCopyWith<$Res> implements $DrinkLogCopyWith<$Res> {
  factory _$DrinkLogCopyWith(_DrinkLog value, $Res Function(_DrinkLog) _then) = __$DrinkLogCopyWithImpl;
@override @useResult
$Res call({
 String id, String consumedByUserId,@LocalDateTimeConverter() DateTime consumedAt, DrinkSnapshot drink,@JsonKey(name: 'drinkId', includeIfNull: false) String? catalogDrinkId, int volumeInMilliliters,@GeoPointConverter() GeoPoint? location,@JsonKey(includeToJson: false) int partyRevision
});


@override $DrinkSnapshotCopyWith<$Res> get drink;

}
/// @nodoc
class __$DrinkLogCopyWithImpl<$Res>
    implements _$DrinkLogCopyWith<$Res> {
  __$DrinkLogCopyWithImpl(this._self, this._then);

  final _DrinkLog _self;
  final $Res Function(_DrinkLog) _then;

/// Create a copy of DrinkLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? consumedByUserId = null,Object? consumedAt = null,Object? drink = null,Object? catalogDrinkId = freezed,Object? volumeInMilliliters = null,Object? location = freezed,Object? partyRevision = null,}) {
  return _then(_DrinkLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,consumedByUserId: null == consumedByUserId ? _self.consumedByUserId : consumedByUserId // ignore: cast_nullable_to_non_nullable
as String,consumedAt: null == consumedAt ? _self.consumedAt : consumedAt // ignore: cast_nullable_to_non_nullable
as DateTime,drink: null == drink ? _self.drink : drink // ignore: cast_nullable_to_non_nullable
as DrinkSnapshot,catalogDrinkId: freezed == catalogDrinkId ? _self.catalogDrinkId : catalogDrinkId // ignore: cast_nullable_to_non_nullable
as String?,volumeInMilliliters: null == volumeInMilliliters ? _self.volumeInMilliliters : volumeInMilliliters // ignore: cast_nullable_to_non_nullable
as int,location: freezed == location ? _self.location : location // ignore: cast_nullable_to_non_nullable
as GeoPoint?,partyRevision: null == partyRevision ? _self.partyRevision : partyRevision // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of DrinkLog
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
