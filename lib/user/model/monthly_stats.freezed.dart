// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MonthlyStats {

 int get year; int get month; double get beersConsumed; double get alcoholConsumedMl; Map<int, DailyStats> get dailyStats;
/// Create a copy of MonthlyStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlyStatsCopyWith<MonthlyStats> get copyWith => _$MonthlyStatsCopyWithImpl<MonthlyStats>(this as MonthlyStats, _$identity);

  /// Serializes this MonthlyStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlyStats&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.beersConsumed, beersConsumed) || other.beersConsumed == beersConsumed)&&(identical(other.alcoholConsumedMl, alcoholConsumedMl) || other.alcoholConsumedMl == alcoholConsumedMl)&&const DeepCollectionEquality().equals(other.dailyStats, dailyStats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,beersConsumed,alcoholConsumedMl,const DeepCollectionEquality().hash(dailyStats));

@override
String toString() {
  return 'MonthlyStats(year: $year, month: $month, beersConsumed: $beersConsumed, alcoholConsumedMl: $alcoholConsumedMl, dailyStats: $dailyStats)';
}


}

/// @nodoc
abstract mixin class $MonthlyStatsCopyWith<$Res>  {
  factory $MonthlyStatsCopyWith(MonthlyStats value, $Res Function(MonthlyStats) _then) = _$MonthlyStatsCopyWithImpl;
@useResult
$Res call({
 int year, int month, double beersConsumed, double alcoholConsumedMl, Map<int, DailyStats> dailyStats
});




}
/// @nodoc
class _$MonthlyStatsCopyWithImpl<$Res>
    implements $MonthlyStatsCopyWith<$Res> {
  _$MonthlyStatsCopyWithImpl(this._self, this._then);

  final MonthlyStats _self;
  final $Res Function(MonthlyStats) _then;

/// Create a copy of MonthlyStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? year = null,Object? month = null,Object? beersConsumed = null,Object? alcoholConsumedMl = null,Object? dailyStats = null,}) {
  return _then(_self.copyWith(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,beersConsumed: null == beersConsumed ? _self.beersConsumed : beersConsumed // ignore: cast_nullable_to_non_nullable
as double,alcoholConsumedMl: null == alcoholConsumedMl ? _self.alcoholConsumedMl : alcoholConsumedMl // ignore: cast_nullable_to_non_nullable
as double,dailyStats: null == dailyStats ? _self.dailyStats : dailyStats // ignore: cast_nullable_to_non_nullable
as Map<int, DailyStats>,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlyStats].
extension MonthlyStatsPatterns on MonthlyStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlyStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlyStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlyStats value)  $default,){
final _that = this;
switch (_that) {
case _MonthlyStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlyStats value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlyStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int year,  int month,  double beersConsumed,  double alcoholConsumedMl,  Map<int, DailyStats> dailyStats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlyStats() when $default != null:
return $default(_that.year,_that.month,_that.beersConsumed,_that.alcoholConsumedMl,_that.dailyStats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int year,  int month,  double beersConsumed,  double alcoholConsumedMl,  Map<int, DailyStats> dailyStats)  $default,) {final _that = this;
switch (_that) {
case _MonthlyStats():
return $default(_that.year,_that.month,_that.beersConsumed,_that.alcoholConsumedMl,_that.dailyStats);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int year,  int month,  double beersConsumed,  double alcoholConsumedMl,  Map<int, DailyStats> dailyStats)?  $default,) {final _that = this;
switch (_that) {
case _MonthlyStats() when $default != null:
return $default(_that.year,_that.month,_that.beersConsumed,_that.alcoholConsumedMl,_that.dailyStats);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MonthlyStats extends MonthlyStats {
  const _MonthlyStats({required this.year, required this.month, required this.beersConsumed, required this.alcoholConsumedMl, final  Map<int, DailyStats> dailyStats = const {}}): _dailyStats = dailyStats,super._();
  factory _MonthlyStats.fromJson(Map<String, dynamic> json) => _$MonthlyStatsFromJson(json);

@override final  int year;
@override final  int month;
@override final  double beersConsumed;
@override final  double alcoholConsumedMl;
 final  Map<int, DailyStats> _dailyStats;
@override@JsonKey() Map<int, DailyStats> get dailyStats {
  if (_dailyStats is EqualUnmodifiableMapView) return _dailyStats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_dailyStats);
}


/// Create a copy of MonthlyStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlyStatsCopyWith<_MonthlyStats> get copyWith => __$MonthlyStatsCopyWithImpl<_MonthlyStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MonthlyStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlyStats&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.beersConsumed, beersConsumed) || other.beersConsumed == beersConsumed)&&(identical(other.alcoholConsumedMl, alcoholConsumedMl) || other.alcoholConsumedMl == alcoholConsumedMl)&&const DeepCollectionEquality().equals(other._dailyStats, _dailyStats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,year,month,beersConsumed,alcoholConsumedMl,const DeepCollectionEquality().hash(_dailyStats));

@override
String toString() {
  return 'MonthlyStats(year: $year, month: $month, beersConsumed: $beersConsumed, alcoholConsumedMl: $alcoholConsumedMl, dailyStats: $dailyStats)';
}


}

/// @nodoc
abstract mixin class _$MonthlyStatsCopyWith<$Res> implements $MonthlyStatsCopyWith<$Res> {
  factory _$MonthlyStatsCopyWith(_MonthlyStats value, $Res Function(_MonthlyStats) _then) = __$MonthlyStatsCopyWithImpl;
@override @useResult
$Res call({
 int year, int month, double beersConsumed, double alcoholConsumedMl, Map<int, DailyStats> dailyStats
});




}
/// @nodoc
class __$MonthlyStatsCopyWithImpl<$Res>
    implements _$MonthlyStatsCopyWith<$Res> {
  __$MonthlyStatsCopyWithImpl(this._self, this._then);

  final _MonthlyStats _self;
  final $Res Function(_MonthlyStats) _then;

/// Create a copy of MonthlyStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? year = null,Object? month = null,Object? beersConsumed = null,Object? alcoholConsumedMl = null,Object? dailyStats = null,}) {
  return _then(_MonthlyStats(
year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,beersConsumed: null == beersConsumed ? _self.beersConsumed : beersConsumed // ignore: cast_nullable_to_non_nullable
as double,alcoholConsumedMl: null == alcoholConsumedMl ? _self.alcoholConsumedMl : alcoholConsumedMl // ignore: cast_nullable_to_non_nullable
as double,dailyStats: null == dailyStats ? _self._dailyStats : dailyStats // ignore: cast_nullable_to_non_nullable
as Map<int, DailyStats>,
  ));
}


}

// dart format on
