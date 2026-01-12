// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drink_type.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DrinkType {

 String get id; String get userId;@TimestampConverterOptimistic() DateTime get createdAt;@TimestampConverterOptimistic() DateTime get updatedAt;@TimestampConverter() DateTime? get deletedAt; String get name; DrinkCategory get category; double get alcoholPercentage;
/// Create a copy of DrinkType
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrinkTypeCopyWith<DrinkType> get copyWith => _$DrinkTypeCopyWithImpl<DrinkType>(this as DrinkType, _$identity);

  /// Serializes this DrinkType to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrinkType&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.alcoholPercentage, alcoholPercentage) || other.alcoholPercentage == alcoholPercentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,createdAt,updatedAt,deletedAt,name,category,alcoholPercentage);

@override
String toString() {
  return 'DrinkType(id: $id, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, name: $name, category: $category, alcoholPercentage: $alcoholPercentage)';
}


}

/// @nodoc
abstract mixin class $DrinkTypeCopyWith<$Res>  {
  factory $DrinkTypeCopyWith(DrinkType value, $Res Function(DrinkType) _then) = _$DrinkTypeCopyWithImpl;
@useResult
$Res call({
 String id, String userId,@TimestampConverterOptimistic() DateTime createdAt,@TimestampConverterOptimistic() DateTime updatedAt,@TimestampConverter() DateTime? deletedAt, String name, DrinkCategory category, double alcoholPercentage
});




}
/// @nodoc
class _$DrinkTypeCopyWithImpl<$Res>
    implements $DrinkTypeCopyWith<$Res> {
  _$DrinkTypeCopyWithImpl(this._self, this._then);

  final DrinkType _self;
  final $Res Function(DrinkType) _then;

/// Create a copy of DrinkType
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? name = null,Object? category = null,Object? alcoholPercentage = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DrinkCategory,alcoholPercentage: null == alcoholPercentage ? _self.alcoholPercentage : alcoholPercentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DrinkType].
extension DrinkTypePatterns on DrinkType {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrinkType value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrinkType() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrinkType value)  $default,){
final _that = this;
switch (_that) {
case _DrinkType():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrinkType value)?  $default,){
final _that = this;
switch (_that) {
case _DrinkType() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId, @TimestampConverterOptimistic()  DateTime createdAt, @TimestampConverterOptimistic()  DateTime updatedAt, @TimestampConverter()  DateTime? deletedAt,  String name,  DrinkCategory category,  double alcoholPercentage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DrinkType() when $default != null:
return $default(_that.id,_that.userId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.name,_that.category,_that.alcoholPercentage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId, @TimestampConverterOptimistic()  DateTime createdAt, @TimestampConverterOptimistic()  DateTime updatedAt, @TimestampConverter()  DateTime? deletedAt,  String name,  DrinkCategory category,  double alcoholPercentage)  $default,) {final _that = this;
switch (_that) {
case _DrinkType():
return $default(_that.id,_that.userId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.name,_that.category,_that.alcoholPercentage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId, @TimestampConverterOptimistic()  DateTime createdAt, @TimestampConverterOptimistic()  DateTime updatedAt, @TimestampConverter()  DateTime? deletedAt,  String name,  DrinkCategory category,  double alcoholPercentage)?  $default,) {final _that = this;
switch (_that) {
case _DrinkType() when $default != null:
return $default(_that.id,_that.userId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.name,_that.category,_that.alcoholPercentage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DrinkType implements DrinkType {
  const _DrinkType({required this.id, required this.userId, @TimestampConverterOptimistic() required this.createdAt, @TimestampConverterOptimistic() required this.updatedAt, @TimestampConverter() this.deletedAt, required this.name, required this.category, required this.alcoholPercentage});
  factory _DrinkType.fromJson(Map<String, dynamic> json) => _$DrinkTypeFromJson(json);

@override final  String id;
@override final  String userId;
@override@TimestampConverterOptimistic() final  DateTime createdAt;
@override@TimestampConverterOptimistic() final  DateTime updatedAt;
@override@TimestampConverter() final  DateTime? deletedAt;
@override final  String name;
@override final  DrinkCategory category;
@override final  double alcoholPercentage;

/// Create a copy of DrinkType
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrinkTypeCopyWith<_DrinkType> get copyWith => __$DrinkTypeCopyWithImpl<_DrinkType>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DrinkTypeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrinkType&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.alcoholPercentage, alcoholPercentage) || other.alcoholPercentage == alcoholPercentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,createdAt,updatedAt,deletedAt,name,category,alcoholPercentage);

@override
String toString() {
  return 'DrinkType(id: $id, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, name: $name, category: $category, alcoholPercentage: $alcoholPercentage)';
}


}

/// @nodoc
abstract mixin class _$DrinkTypeCopyWith<$Res> implements $DrinkTypeCopyWith<$Res> {
  factory _$DrinkTypeCopyWith(_DrinkType value, $Res Function(_DrinkType) _then) = __$DrinkTypeCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId,@TimestampConverterOptimistic() DateTime createdAt,@TimestampConverterOptimistic() DateTime updatedAt,@TimestampConverter() DateTime? deletedAt, String name, DrinkCategory category, double alcoholPercentage
});




}
/// @nodoc
class __$DrinkTypeCopyWithImpl<$Res>
    implements _$DrinkTypeCopyWith<$Res> {
  __$DrinkTypeCopyWithImpl(this._self, this._then);

  final _DrinkType _self;
  final $Res Function(_DrinkType) _then;

/// Create a copy of DrinkType
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? name = null,Object? category = null,Object? alcoholPercentage = null,}) {
  return _then(_DrinkType(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DrinkCategory,alcoholPercentage: null == alcoholPercentage ? _self.alcoholPercentage : alcoholPercentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
