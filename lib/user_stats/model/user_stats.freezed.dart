// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserStats {

 double get totalBeersConsumed; double get totalAlcoholConsumed; double get beersConsumedLast30Days; double get alcoholConsumedLast30Days; int get streakDays; bool get isStreakActive;
/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserStatsCopyWith<UserStats> get copyWith => _$UserStatsCopyWithImpl<UserStats>(this as UserStats, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserStats&&(identical(other.totalBeersConsumed, totalBeersConsumed) || other.totalBeersConsumed == totalBeersConsumed)&&(identical(other.totalAlcoholConsumed, totalAlcoholConsumed) || other.totalAlcoholConsumed == totalAlcoholConsumed)&&(identical(other.beersConsumedLast30Days, beersConsumedLast30Days) || other.beersConsumedLast30Days == beersConsumedLast30Days)&&(identical(other.alcoholConsumedLast30Days, alcoholConsumedLast30Days) || other.alcoholConsumedLast30Days == alcoholConsumedLast30Days)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.isStreakActive, isStreakActive) || other.isStreakActive == isStreakActive));
}


@override
int get hashCode => Object.hash(runtimeType,totalBeersConsumed,totalAlcoholConsumed,beersConsumedLast30Days,alcoholConsumedLast30Days,streakDays,isStreakActive);

@override
String toString() {
  return 'UserStats(totalBeersConsumed: $totalBeersConsumed, totalAlcoholConsumed: $totalAlcoholConsumed, beersConsumedLast30Days: $beersConsumedLast30Days, alcoholConsumedLast30Days: $alcoholConsumedLast30Days, streakDays: $streakDays, isStreakActive: $isStreakActive)';
}


}

/// @nodoc
abstract mixin class $UserStatsCopyWith<$Res>  {
  factory $UserStatsCopyWith(UserStats value, $Res Function(UserStats) _then) = _$UserStatsCopyWithImpl;
@useResult
$Res call({
 double totalBeersConsumed, double totalAlcoholConsumed, double beersConsumedLast30Days, double alcoholConsumedLast30Days, int streakDays, bool isStreakActive
});




}
/// @nodoc
class _$UserStatsCopyWithImpl<$Res>
    implements $UserStatsCopyWith<$Res> {
  _$UserStatsCopyWithImpl(this._self, this._then);

  final UserStats _self;
  final $Res Function(UserStats) _then;

/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalBeersConsumed = null,Object? totalAlcoholConsumed = null,Object? beersConsumedLast30Days = null,Object? alcoholConsumedLast30Days = null,Object? streakDays = null,Object? isStreakActive = null,}) {
  return _then(_self.copyWith(
totalBeersConsumed: null == totalBeersConsumed ? _self.totalBeersConsumed : totalBeersConsumed // ignore: cast_nullable_to_non_nullable
as double,totalAlcoholConsumed: null == totalAlcoholConsumed ? _self.totalAlcoholConsumed : totalAlcoholConsumed // ignore: cast_nullable_to_non_nullable
as double,beersConsumedLast30Days: null == beersConsumedLast30Days ? _self.beersConsumedLast30Days : beersConsumedLast30Days // ignore: cast_nullable_to_non_nullable
as double,alcoholConsumedLast30Days: null == alcoholConsumedLast30Days ? _self.alcoholConsumedLast30Days : alcoholConsumedLast30Days // ignore: cast_nullable_to_non_nullable
as double,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,isStreakActive: null == isStreakActive ? _self.isStreakActive : isStreakActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UserStats].
extension UserStatsPatterns on UserStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserStats value)  $default,){
final _that = this;
switch (_that) {
case _UserStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserStats value)?  $default,){
final _that = this;
switch (_that) {
case _UserStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double totalBeersConsumed,  double totalAlcoholConsumed,  double beersConsumedLast30Days,  double alcoholConsumedLast30Days,  int streakDays,  bool isStreakActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserStats() when $default != null:
return $default(_that.totalBeersConsumed,_that.totalAlcoholConsumed,_that.beersConsumedLast30Days,_that.alcoholConsumedLast30Days,_that.streakDays,_that.isStreakActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double totalBeersConsumed,  double totalAlcoholConsumed,  double beersConsumedLast30Days,  double alcoholConsumedLast30Days,  int streakDays,  bool isStreakActive)  $default,) {final _that = this;
switch (_that) {
case _UserStats():
return $default(_that.totalBeersConsumed,_that.totalAlcoholConsumed,_that.beersConsumedLast30Days,_that.alcoholConsumedLast30Days,_that.streakDays,_that.isStreakActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double totalBeersConsumed,  double totalAlcoholConsumed,  double beersConsumedLast30Days,  double alcoholConsumedLast30Days,  int streakDays,  bool isStreakActive)?  $default,) {final _that = this;
switch (_that) {
case _UserStats() when $default != null:
return $default(_that.totalBeersConsumed,_that.totalAlcoholConsumed,_that.beersConsumedLast30Days,_that.alcoholConsumedLast30Days,_that.streakDays,_that.isStreakActive);case _:
  return null;

}
}

}

/// @nodoc


class _UserStats implements UserStats {
  const _UserStats({required this.totalBeersConsumed, required this.totalAlcoholConsumed, required this.beersConsumedLast30Days, required this.alcoholConsumedLast30Days, required this.streakDays, required this.isStreakActive});
  

@override final  double totalBeersConsumed;
@override final  double totalAlcoholConsumed;
@override final  double beersConsumedLast30Days;
@override final  double alcoholConsumedLast30Days;
@override final  int streakDays;
@override final  bool isStreakActive;

/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserStatsCopyWith<_UserStats> get copyWith => __$UserStatsCopyWithImpl<_UserStats>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserStats&&(identical(other.totalBeersConsumed, totalBeersConsumed) || other.totalBeersConsumed == totalBeersConsumed)&&(identical(other.totalAlcoholConsumed, totalAlcoholConsumed) || other.totalAlcoholConsumed == totalAlcoholConsumed)&&(identical(other.beersConsumedLast30Days, beersConsumedLast30Days) || other.beersConsumedLast30Days == beersConsumedLast30Days)&&(identical(other.alcoholConsumedLast30Days, alcoholConsumedLast30Days) || other.alcoholConsumedLast30Days == alcoholConsumedLast30Days)&&(identical(other.streakDays, streakDays) || other.streakDays == streakDays)&&(identical(other.isStreakActive, isStreakActive) || other.isStreakActive == isStreakActive));
}


@override
int get hashCode => Object.hash(runtimeType,totalBeersConsumed,totalAlcoholConsumed,beersConsumedLast30Days,alcoholConsumedLast30Days,streakDays,isStreakActive);

@override
String toString() {
  return 'UserStats(totalBeersConsumed: $totalBeersConsumed, totalAlcoholConsumed: $totalAlcoholConsumed, beersConsumedLast30Days: $beersConsumedLast30Days, alcoholConsumedLast30Days: $alcoholConsumedLast30Days, streakDays: $streakDays, isStreakActive: $isStreakActive)';
}


}

/// @nodoc
abstract mixin class _$UserStatsCopyWith<$Res> implements $UserStatsCopyWith<$Res> {
  factory _$UserStatsCopyWith(_UserStats value, $Res Function(_UserStats) _then) = __$UserStatsCopyWithImpl;
@override @useResult
$Res call({
 double totalBeersConsumed, double totalAlcoholConsumed, double beersConsumedLast30Days, double alcoholConsumedLast30Days, int streakDays, bool isStreakActive
});




}
/// @nodoc
class __$UserStatsCopyWithImpl<$Res>
    implements _$UserStatsCopyWith<$Res> {
  __$UserStatsCopyWithImpl(this._self, this._then);

  final _UserStats _self;
  final $Res Function(_UserStats) _then;

/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalBeersConsumed = null,Object? totalAlcoholConsumed = null,Object? beersConsumedLast30Days = null,Object? alcoholConsumedLast30Days = null,Object? streakDays = null,Object? isStreakActive = null,}) {
  return _then(_UserStats(
totalBeersConsumed: null == totalBeersConsumed ? _self.totalBeersConsumed : totalBeersConsumed // ignore: cast_nullable_to_non_nullable
as double,totalAlcoholConsumed: null == totalAlcoholConsumed ? _self.totalAlcoholConsumed : totalAlcoholConsumed // ignore: cast_nullable_to_non_nullable
as double,beersConsumedLast30Days: null == beersConsumedLast30Days ? _self.beersConsumedLast30Days : beersConsumedLast30Days // ignore: cast_nullable_to_non_nullable
as double,alcoholConsumedLast30Days: null == alcoholConsumedLast30Days ? _self.alcoholConsumedLast30Days : alcoholConsumedLast30Days // ignore: cast_nullable_to_non_nullable
as double,streakDays: null == streakDays ? _self.streakDays : streakDays // ignore: cast_nullable_to_non_nullable
as int,isStreakActive: null == isStreakActive ? _self.isStreakActive : isStreakActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
