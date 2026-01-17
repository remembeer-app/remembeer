// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

 String get id; String get email; String get username; String get searchableUsername; String? get avatarUrl; Set<String> get friends; Map<String, MonthlyStats> get monthlyStats; Map<String, UnlockedBadge> get unlockedBadges;@TimeOfDayConverter() TimeOfDay get endOfDayBoundary;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.searchableUsername, searchableUsername) || other.searchableUsername == searchableUsername)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&const DeepCollectionEquality().equals(other.friends, friends)&&const DeepCollectionEquality().equals(other.monthlyStats, monthlyStats)&&const DeepCollectionEquality().equals(other.unlockedBadges, unlockedBadges)&&(identical(other.endOfDayBoundary, endOfDayBoundary) || other.endOfDayBoundary == endOfDayBoundary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,username,searchableUsername,avatarUrl,const DeepCollectionEquality().hash(friends),const DeepCollectionEquality().hash(monthlyStats),const DeepCollectionEquality().hash(unlockedBadges),endOfDayBoundary);

@override
String toString() {
  return 'UserModel(id: $id, email: $email, username: $username, searchableUsername: $searchableUsername, avatarUrl: $avatarUrl, friends: $friends, monthlyStats: $monthlyStats, unlockedBadges: $unlockedBadges, endOfDayBoundary: $endOfDayBoundary)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String id, String email, String username, String searchableUsername, String? avatarUrl, Set<String> friends, Map<String, MonthlyStats> monthlyStats, Map<String, UnlockedBadge> unlockedBadges,@TimeOfDayConverter() TimeOfDay endOfDayBoundary
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? username = null,Object? searchableUsername = null,Object? avatarUrl = freezed,Object? friends = null,Object? monthlyStats = null,Object? unlockedBadges = null,Object? endOfDayBoundary = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,searchableUsername: null == searchableUsername ? _self.searchableUsername : searchableUsername // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,friends: null == friends ? _self.friends : friends // ignore: cast_nullable_to_non_nullable
as Set<String>,monthlyStats: null == monthlyStats ? _self.monthlyStats : monthlyStats // ignore: cast_nullable_to_non_nullable
as Map<String, MonthlyStats>,unlockedBadges: null == unlockedBadges ? _self.unlockedBadges : unlockedBadges // ignore: cast_nullable_to_non_nullable
as Map<String, UnlockedBadge>,endOfDayBoundary: null == endOfDayBoundary ? _self.endOfDayBoundary : endOfDayBoundary // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}

}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String username,  String searchableUsername,  String? avatarUrl,  Set<String> friends,  Map<String, MonthlyStats> monthlyStats,  Map<String, UnlockedBadge> unlockedBadges, @TimeOfDayConverter()  TimeOfDay endOfDayBoundary)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.email,_that.username,_that.searchableUsername,_that.avatarUrl,_that.friends,_that.monthlyStats,_that.unlockedBadges,_that.endOfDayBoundary);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String username,  String searchableUsername,  String? avatarUrl,  Set<String> friends,  Map<String, MonthlyStats> monthlyStats,  Map<String, UnlockedBadge> unlockedBadges, @TimeOfDayConverter()  TimeOfDay endOfDayBoundary)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.email,_that.username,_that.searchableUsername,_that.avatarUrl,_that.friends,_that.monthlyStats,_that.unlockedBadges,_that.endOfDayBoundary);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String username,  String searchableUsername,  String? avatarUrl,  Set<String> friends,  Map<String, MonthlyStats> monthlyStats,  Map<String, UnlockedBadge> unlockedBadges, @TimeOfDayConverter()  TimeOfDay endOfDayBoundary)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.email,_that.username,_that.searchableUsername,_that.avatarUrl,_that.friends,_that.monthlyStats,_that.unlockedBadges,_that.endOfDayBoundary);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel extends UserModel {
  const _UserModel({required this.id, required this.email, required this.username, required this.searchableUsername, this.avatarUrl, final  Set<String> friends = const {}, final  Map<String, MonthlyStats> monthlyStats = const {}, final  Map<String, UnlockedBadge> unlockedBadges = const {}, @TimeOfDayConverter() this.endOfDayBoundary = defaultEndOfDayBoundary}): _friends = friends,_monthlyStats = monthlyStats,_unlockedBadges = unlockedBadges,super._();
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String id;
@override final  String email;
@override final  String username;
@override final  String searchableUsername;
@override final  String? avatarUrl;
 final  Set<String> _friends;
@override@JsonKey() Set<String> get friends {
  if (_friends is EqualUnmodifiableSetView) return _friends;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_friends);
}

 final  Map<String, MonthlyStats> _monthlyStats;
@override@JsonKey() Map<String, MonthlyStats> get monthlyStats {
  if (_monthlyStats is EqualUnmodifiableMapView) return _monthlyStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_monthlyStats);
}

 final  Map<String, UnlockedBadge> _unlockedBadges;
@override@JsonKey() Map<String, UnlockedBadge> get unlockedBadges {
  if (_unlockedBadges is EqualUnmodifiableMapView) return _unlockedBadges;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_unlockedBadges);
}

@override@JsonKey()@TimeOfDayConverter() final  TimeOfDay endOfDayBoundary;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.username, username) || other.username == username)&&(identical(other.searchableUsername, searchableUsername) || other.searchableUsername == searchableUsername)&&(identical(other.avatarUrl, avatarUrl) || other.avatarUrl == avatarUrl)&&const DeepCollectionEquality().equals(other._friends, _friends)&&const DeepCollectionEquality().equals(other._monthlyStats, _monthlyStats)&&const DeepCollectionEquality().equals(other._unlockedBadges, _unlockedBadges)&&(identical(other.endOfDayBoundary, endOfDayBoundary) || other.endOfDayBoundary == endOfDayBoundary));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,email,username,searchableUsername,avatarUrl,const DeepCollectionEquality().hash(_friends),const DeepCollectionEquality().hash(_monthlyStats),const DeepCollectionEquality().hash(_unlockedBadges),endOfDayBoundary);

@override
String toString() {
  return 'UserModel(id: $id, email: $email, username: $username, searchableUsername: $searchableUsername, avatarUrl: $avatarUrl, friends: $friends, monthlyStats: $monthlyStats, unlockedBadges: $unlockedBadges, endOfDayBoundary: $endOfDayBoundary)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String username, String searchableUsername, String? avatarUrl, Set<String> friends, Map<String, MonthlyStats> monthlyStats, Map<String, UnlockedBadge> unlockedBadges,@TimeOfDayConverter() TimeOfDay endOfDayBoundary
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? username = null,Object? searchableUsername = null,Object? avatarUrl = freezed,Object? friends = null,Object? monthlyStats = null,Object? unlockedBadges = null,Object? endOfDayBoundary = null,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,searchableUsername: null == searchableUsername ? _self.searchableUsername : searchableUsername // ignore: cast_nullable_to_non_nullable
as String,avatarUrl: freezed == avatarUrl ? _self.avatarUrl : avatarUrl // ignore: cast_nullable_to_non_nullable
as String?,friends: null == friends ? _self._friends : friends // ignore: cast_nullable_to_non_nullable
as Set<String>,monthlyStats: null == monthlyStats ? _self._monthlyStats : monthlyStats // ignore: cast_nullable_to_non_nullable
as Map<String, MonthlyStats>,unlockedBadges: null == unlockedBadges ? _self._unlockedBadges : unlockedBadges // ignore: cast_nullable_to_non_nullable
as Map<String, UnlockedBadge>,endOfDayBoundary: null == endOfDayBoundary ? _self.endOfDayBoundary : endOfDayBoundary // ignore: cast_nullable_to_non_nullable
as TimeOfDay,
  ));
}


}

// dart format on
