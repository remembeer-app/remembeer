// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'drink_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DrinkSnapshot {

 String get name; DrinkCategory get category; double get alcoholPercentage;
/// Create a copy of DrinkSnapshot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DrinkSnapshotCopyWith<DrinkSnapshot> get copyWith => _$DrinkSnapshotCopyWithImpl<DrinkSnapshot>(this as DrinkSnapshot, _$identity);

  /// Serializes this DrinkSnapshot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DrinkSnapshot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DrinkSnapshot&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.alcoholPercentage, _this.alcoholPercentage) || other.alcoholPercentage == _this.alcoholPercentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DrinkSnapshot;
  return Object.hash(runtimeType,_this.name,_this.category,_this.alcoholPercentage);
}

@override
String toString() {
  final _this = this as DrinkSnapshot;
  return 'DrinkSnapshot(name: ${_this.name}, category: ${_this.category}, alcoholPercentage: ${_this.alcoholPercentage})';
}


}

/// @nodoc
abstract mixin class $DrinkSnapshotCopyWith<$Res>  {
  factory $DrinkSnapshotCopyWith(DrinkSnapshot value, $Res Function(DrinkSnapshot) _then) = _$DrinkSnapshotCopyWithImpl;
@useResult
$Res call({
 String name, DrinkCategory category, double alcoholPercentage
});




}
/// @nodoc
class _$DrinkSnapshotCopyWithImpl<$Res>
    implements $DrinkSnapshotCopyWith<$Res> {
  _$DrinkSnapshotCopyWithImpl(this._self, this._then);

  final DrinkSnapshot _self;
  final $Res Function(DrinkSnapshot) _then;

/// Create a copy of DrinkSnapshot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? category = null,Object? alcoholPercentage = null,}) {
  return _then(DrinkSnapshot(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DrinkCategory,alcoholPercentage: null == alcoholPercentage ? _self.alcoholPercentage : alcoholPercentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DrinkSnapshot].
extension DrinkSnapshotPatterns on DrinkSnapshot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DrinkSnapshot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DrinkSnapshot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DrinkSnapshot value)  $default,){
final _that = this;
switch (_that) {
case _DrinkSnapshot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DrinkSnapshot value)?  $default,){
final _that = this;
switch (_that) {
case _DrinkSnapshot() when $default != null:
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
case _DrinkSnapshot() when $default != null:
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
case _DrinkSnapshot():
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
case _DrinkSnapshot() when $default != null:
return $default(_that.name,_that.category,_that.alcoholPercentage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DrinkSnapshot implements DrinkSnapshot {
  const _DrinkSnapshot({required this.name, required this.category, required this.alcoholPercentage});
  factory _DrinkSnapshot.fromJson(Map<String, dynamic> json) => _$DrinkSnapshotFromJson(json);

@override final  String name;
@override final  DrinkCategory category;
@override final  double alcoholPercentage;

/// Create a copy of DrinkSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DrinkSnapshotCopyWith<_DrinkSnapshot> get copyWith => __$DrinkSnapshotCopyWithImpl<_DrinkSnapshot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DrinkSnapshotToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DrinkSnapshot&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.alcoholPercentage, alcoholPercentage) || other.alcoholPercentage == alcoholPercentage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,category,alcoholPercentage);
}

@override
String toString() {
    return 'DrinkSnapshot(name: $name, category: $category, alcoholPercentage: $alcoholPercentage)';
}


}

/// @nodoc
abstract mixin class _$DrinkSnapshotCopyWith<$Res> implements $DrinkSnapshotCopyWith<$Res> {
  factory _$DrinkSnapshotCopyWith(_DrinkSnapshot value, $Res Function(_DrinkSnapshot) _then) = __$DrinkSnapshotCopyWithImpl;
@override @useResult
$Res call({
 String name, DrinkCategory category, double alcoholPercentage
});




}
/// @nodoc
class __$DrinkSnapshotCopyWithImpl<$Res>
    implements _$DrinkSnapshotCopyWith<$Res> {
  __$DrinkSnapshotCopyWithImpl(this._self, this._then);

  final _DrinkSnapshot _self;
  final $Res Function(_DrinkSnapshot) _then;

/// Create a copy of DrinkSnapshot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? category = null,Object? alcoholPercentage = null,}) {
  return _then(_DrinkSnapshot(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as DrinkCategory,alcoholPercentage: null == alcoholPercentage ? _self.alcoholPercentage : alcoholPercentage // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
