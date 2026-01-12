// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserSettings {

 String get id; DrinkType get defaultDrinkType; int get defaultDrinkSize; DrinkListSortOrder get drinkListSortOrder; String? get notificationToken;
/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<UserSettings> get copyWith => _$UserSettingsCopyWithImpl<UserSettings>(this as UserSettings, _$identity);

  /// Serializes this UserSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSettings&&(identical(other.id, id) || other.id == id)&&(identical(other.defaultDrinkType, defaultDrinkType) || other.defaultDrinkType == defaultDrinkType)&&(identical(other.defaultDrinkSize, defaultDrinkSize) || other.defaultDrinkSize == defaultDrinkSize)&&(identical(other.drinkListSortOrder, drinkListSortOrder) || other.drinkListSortOrder == drinkListSortOrder)&&(identical(other.notificationToken, notificationToken) || other.notificationToken == notificationToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,defaultDrinkType,defaultDrinkSize,drinkListSortOrder,notificationToken);

@override
String toString() {
  return 'UserSettings(id: $id, defaultDrinkType: $defaultDrinkType, defaultDrinkSize: $defaultDrinkSize, drinkListSortOrder: $drinkListSortOrder, notificationToken: $notificationToken)';
}


}

/// @nodoc
abstract mixin class $UserSettingsCopyWith<$Res>  {
  factory $UserSettingsCopyWith(UserSettings value, $Res Function(UserSettings) _then) = _$UserSettingsCopyWithImpl;
@useResult
$Res call({
 String id, DrinkType defaultDrinkType, int defaultDrinkSize, DrinkListSortOrder drinkListSortOrder, String? notificationToken
});


$DrinkTypeCopyWith<$Res> get defaultDrinkType;

}
/// @nodoc
class _$UserSettingsCopyWithImpl<$Res>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._self, this._then);

  final UserSettings _self;
  final $Res Function(UserSettings) _then;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? defaultDrinkType = null,Object? defaultDrinkSize = null,Object? drinkListSortOrder = null,Object? notificationToken = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,defaultDrinkType: null == defaultDrinkType ? _self.defaultDrinkType : defaultDrinkType // ignore: cast_nullable_to_non_nullable
as DrinkType,defaultDrinkSize: null == defaultDrinkSize ? _self.defaultDrinkSize : defaultDrinkSize // ignore: cast_nullable_to_non_nullable
as int,drinkListSortOrder: null == drinkListSortOrder ? _self.drinkListSortOrder : drinkListSortOrder // ignore: cast_nullable_to_non_nullable
as DrinkListSortOrder,notificationToken: freezed == notificationToken ? _self.notificationToken : notificationToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrinkTypeCopyWith<$Res> get defaultDrinkType {
  
  return $DrinkTypeCopyWith<$Res>(_self.defaultDrinkType, (value) {
    return _then(_self.copyWith(defaultDrinkType: value));
  });
}
}


/// Adds pattern-matching-related methods to [UserSettings].
extension UserSettingsPatterns on UserSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserSettings value)  $default,){
final _that = this;
switch (_that) {
case _UserSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserSettings value)?  $default,){
final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DrinkType defaultDrinkType,  int defaultDrinkSize,  DrinkListSortOrder drinkListSortOrder,  String? notificationToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
return $default(_that.id,_that.defaultDrinkType,_that.defaultDrinkSize,_that.drinkListSortOrder,_that.notificationToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DrinkType defaultDrinkType,  int defaultDrinkSize,  DrinkListSortOrder drinkListSortOrder,  String? notificationToken)  $default,) {final _that = this;
switch (_that) {
case _UserSettings():
return $default(_that.id,_that.defaultDrinkType,_that.defaultDrinkSize,_that.drinkListSortOrder,_that.notificationToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DrinkType defaultDrinkType,  int defaultDrinkSize,  DrinkListSortOrder drinkListSortOrder,  String? notificationToken)?  $default,) {final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
return $default(_that.id,_that.defaultDrinkType,_that.defaultDrinkSize,_that.drinkListSortOrder,_that.notificationToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserSettings implements UserSettings {
  const _UserSettings({required this.id, required this.defaultDrinkType, required this.defaultDrinkSize, this.drinkListSortOrder = DrinkListSortOrder.descending, this.notificationToken});
  factory _UserSettings.fromJson(Map<String, dynamic> json) => _$UserSettingsFromJson(json);

@override final  String id;
@override final  DrinkType defaultDrinkType;
@override final  int defaultDrinkSize;
@override@JsonKey() final  DrinkListSortOrder drinkListSortOrder;
@override final  String? notificationToken;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserSettingsCopyWith<_UserSettings> get copyWith => __$UserSettingsCopyWithImpl<_UserSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSettings&&(identical(other.id, id) || other.id == id)&&(identical(other.defaultDrinkType, defaultDrinkType) || other.defaultDrinkType == defaultDrinkType)&&(identical(other.defaultDrinkSize, defaultDrinkSize) || other.defaultDrinkSize == defaultDrinkSize)&&(identical(other.drinkListSortOrder, drinkListSortOrder) || other.drinkListSortOrder == drinkListSortOrder)&&(identical(other.notificationToken, notificationToken) || other.notificationToken == notificationToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,defaultDrinkType,defaultDrinkSize,drinkListSortOrder,notificationToken);

@override
String toString() {
  return 'UserSettings(id: $id, defaultDrinkType: $defaultDrinkType, defaultDrinkSize: $defaultDrinkSize, drinkListSortOrder: $drinkListSortOrder, notificationToken: $notificationToken)';
}


}

/// @nodoc
abstract mixin class _$UserSettingsCopyWith<$Res> implements $UserSettingsCopyWith<$Res> {
  factory _$UserSettingsCopyWith(_UserSettings value, $Res Function(_UserSettings) _then) = __$UserSettingsCopyWithImpl;
@override @useResult
$Res call({
 String id, DrinkType defaultDrinkType, int defaultDrinkSize, DrinkListSortOrder drinkListSortOrder, String? notificationToken
});


@override $DrinkTypeCopyWith<$Res> get defaultDrinkType;

}
/// @nodoc
class __$UserSettingsCopyWithImpl<$Res>
    implements _$UserSettingsCopyWith<$Res> {
  __$UserSettingsCopyWithImpl(this._self, this._then);

  final _UserSettings _self;
  final $Res Function(_UserSettings) _then;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? defaultDrinkType = null,Object? defaultDrinkSize = null,Object? drinkListSortOrder = null,Object? notificationToken = freezed,}) {
  return _then(_UserSettings(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,defaultDrinkType: null == defaultDrinkType ? _self.defaultDrinkType : defaultDrinkType // ignore: cast_nullable_to_non_nullable
as DrinkType,defaultDrinkSize: null == defaultDrinkSize ? _self.defaultDrinkSize : defaultDrinkSize // ignore: cast_nullable_to_non_nullable
as int,drinkListSortOrder: null == drinkListSortOrder ? _self.drinkListSortOrder : drinkListSortOrder // ignore: cast_nullable_to_non_nullable
as DrinkListSortOrder,notificationToken: freezed == notificationToken ? _self.notificationToken : notificationToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrinkTypeCopyWith<$Res> get defaultDrinkType {
  
  return $DrinkTypeCopyWith<$Res>(_self.defaultDrinkType, (value) {
    return _then(_self.copyWith(defaultDrinkType: value));
  });
}
}

// dart format on
