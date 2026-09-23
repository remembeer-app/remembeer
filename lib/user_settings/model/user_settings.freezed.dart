// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserSettings {

 String get id; DrinkSnapshot get defaultDrink; int get defaultDrinkSize; DrinkLogListSortOrder get drinkLogListSortOrder; String? get notificationToken;
/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSettingsCopyWith<UserSettings> get copyWith => _$UserSettingsCopyWithImpl<UserSettings>(this as UserSettings, _$identity);

  /// Serializes this UserSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as UserSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSettings&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.defaultDrink, _this.defaultDrink) || other.defaultDrink == _this.defaultDrink)&&(identical(other.defaultDrinkSize, _this.defaultDrinkSize) || other.defaultDrinkSize == _this.defaultDrinkSize)&&(identical(other.drinkLogListSortOrder, _this.drinkLogListSortOrder) || other.drinkLogListSortOrder == _this.drinkLogListSortOrder)&&(identical(other.notificationToken, _this.notificationToken) || other.notificationToken == _this.notificationToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as UserSettings;
  return Object.hash(runtimeType,_this.id,_this.defaultDrink,_this.defaultDrinkSize,_this.drinkLogListSortOrder,_this.notificationToken);
}

@override
String toString() {
  final _this = this as UserSettings;
  return 'UserSettings(id: ${_this.id}, defaultDrink: ${_this.defaultDrink}, defaultDrinkSize: ${_this.defaultDrinkSize}, drinkLogListSortOrder: ${_this.drinkLogListSortOrder}, notificationToken: ${_this.notificationToken})';
}


}

/// @nodoc
abstract mixin class $UserSettingsCopyWith<$Res>  {
  factory $UserSettingsCopyWith(UserSettings value, $Res Function(UserSettings) _then) = _$UserSettingsCopyWithImpl;
@useResult
$Res call({
 String id, DrinkSnapshot defaultDrink, int defaultDrinkSize, DrinkLogListSortOrder drinkLogListSortOrder, String? notificationToken
});


$DrinkSnapshotCopyWith<$Res> get defaultDrink;

}
/// @nodoc
class _$UserSettingsCopyWithImpl<$Res>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._self, this._then);

  final UserSettings _self;
  final $Res Function(UserSettings) _then;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? defaultDrink = null,Object? defaultDrinkSize = null,Object? drinkLogListSortOrder = null,Object? notificationToken = freezed,}) {
  return _then(UserSettings(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,defaultDrink: null == defaultDrink ? _self.defaultDrink : defaultDrink // ignore: cast_nullable_to_non_nullable
as DrinkSnapshot,defaultDrinkSize: null == defaultDrinkSize ? _self.defaultDrinkSize : defaultDrinkSize // ignore: cast_nullable_to_non_nullable
as int,drinkLogListSortOrder: null == drinkLogListSortOrder ? _self.drinkLogListSortOrder : drinkLogListSortOrder // ignore: cast_nullable_to_non_nullable
as DrinkLogListSortOrder,notificationToken: freezed == notificationToken ? _self.notificationToken : notificationToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrinkSnapshotCopyWith<$Res> get defaultDrink {
  
  return $DrinkSnapshotCopyWith<$Res>(_self.defaultDrink, (value) {
    return _then(_self.copyWith(defaultDrink: value));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DrinkSnapshot defaultDrink,  int defaultDrinkSize,  DrinkLogListSortOrder drinkLogListSortOrder,  String? notificationToken)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
return $default(_that.id,_that.defaultDrink,_that.defaultDrinkSize,_that.drinkLogListSortOrder,_that.notificationToken);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DrinkSnapshot defaultDrink,  int defaultDrinkSize,  DrinkLogListSortOrder drinkLogListSortOrder,  String? notificationToken)  $default,) {final _that = this;
switch (_that) {
case _UserSettings():
return $default(_that.id,_that.defaultDrink,_that.defaultDrinkSize,_that.drinkLogListSortOrder,_that.notificationToken);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DrinkSnapshot defaultDrink,  int defaultDrinkSize,  DrinkLogListSortOrder drinkLogListSortOrder,  String? notificationToken)?  $default,) {final _that = this;
switch (_that) {
case _UserSettings() when $default != null:
return $default(_that.id,_that.defaultDrink,_that.defaultDrinkSize,_that.drinkLogListSortOrder,_that.notificationToken);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserSettings implements UserSettings {
  const _UserSettings({required this.id, required this.defaultDrink, required this.defaultDrinkSize, this.drinkLogListSortOrder = DrinkLogListSortOrder.descending, this.notificationToken});
  factory _UserSettings.fromJson(Map<String, dynamic> json) => _$UserSettingsFromJson(json);

@override final  String id;
@override final  DrinkSnapshot defaultDrink;
@override final  int defaultDrinkSize;
@override@JsonKey() final  DrinkLogListSortOrder drinkLogListSortOrder;
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
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSettings&&(identical(other.id, id) || other.id == id)&&(identical(other.defaultDrink, defaultDrink) || other.defaultDrink == defaultDrink)&&(identical(other.defaultDrinkSize, defaultDrinkSize) || other.defaultDrinkSize == defaultDrinkSize)&&(identical(other.drinkLogListSortOrder, drinkLogListSortOrder) || other.drinkLogListSortOrder == drinkLogListSortOrder)&&(identical(other.notificationToken, notificationToken) || other.notificationToken == notificationToken));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,defaultDrink,defaultDrinkSize,drinkLogListSortOrder,notificationToken);
}

@override
String toString() {
    return 'UserSettings(id: $id, defaultDrink: $defaultDrink, defaultDrinkSize: $defaultDrinkSize, drinkLogListSortOrder: $drinkLogListSortOrder, notificationToken: $notificationToken)';
}


}

/// @nodoc
abstract mixin class _$UserSettingsCopyWith<$Res> implements $UserSettingsCopyWith<$Res> {
  factory _$UserSettingsCopyWith(_UserSettings value, $Res Function(_UserSettings) _then) = __$UserSettingsCopyWithImpl;
@override @useResult
$Res call({
 String id, DrinkSnapshot defaultDrink, int defaultDrinkSize, DrinkLogListSortOrder drinkLogListSortOrder, String? notificationToken
});


@override $DrinkSnapshotCopyWith<$Res> get defaultDrink;

}
/// @nodoc
class __$UserSettingsCopyWithImpl<$Res>
    implements _$UserSettingsCopyWith<$Res> {
  __$UserSettingsCopyWithImpl(this._self, this._then);

  final _UserSettings _self;
  final $Res Function(_UserSettings) _then;

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? defaultDrink = null,Object? defaultDrinkSize = null,Object? drinkLogListSortOrder = null,Object? notificationToken = freezed,}) {
  return _then(_UserSettings(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,defaultDrink: null == defaultDrink ? _self.defaultDrink : defaultDrink // ignore: cast_nullable_to_non_nullable
as DrinkSnapshot,defaultDrinkSize: null == defaultDrinkSize ? _self.defaultDrinkSize : defaultDrinkSize // ignore: cast_nullable_to_non_nullable
as int,drinkLogListSortOrder: null == drinkLogListSortOrder ? _self.drinkLogListSortOrder : drinkLogListSortOrder // ignore: cast_nullable_to_non_nullable
as DrinkLogListSortOrder,notificationToken: freezed == notificationToken ? _self.notificationToken : notificationToken // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of UserSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DrinkSnapshotCopyWith<$Res> get defaultDrink {
  
  return $DrinkSnapshotCopyWith<$Res>(_self.defaultDrink, (value) {
    return _then(_self.copyWith(defaultDrink: value));
  });
}
}

// dart format on
