// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyStats {

 int get day; double get beersConsumed; double get alcoholConsumedMl; double get beersAfter6pm;
/// Create a copy of DailyStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyStatsCopyWith<DailyStats> get copyWith => _$DailyStatsCopyWithImpl<DailyStats>(this as DailyStats, _$identity);

  /// Serializes this DailyStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyStats&&(identical(other.day, day) || other.day == day)&&(identical(other.beersConsumed, beersConsumed) || other.beersConsumed == beersConsumed)&&(identical(other.alcoholConsumedMl, alcoholConsumedMl) || other.alcoholConsumedMl == alcoholConsumedMl)&&(identical(other.beersAfter6pm, beersAfter6pm) || other.beersAfter6pm == beersAfter6pm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,beersConsumed,alcoholConsumedMl,beersAfter6pm);

@override
String toString() {
  return 'DailyStats(day: $day, beersConsumed: $beersConsumed, alcoholConsumedMl: $alcoholConsumedMl, beersAfter6pm: $beersAfter6pm)';
}


}

/// @nodoc
abstract mixin class $DailyStatsCopyWith<$Res>  {
  factory $DailyStatsCopyWith(DailyStats value, $Res Function(DailyStats) _then) = _$DailyStatsCopyWithImpl;
@useResult
$Res call({
 int day, double beersConsumed, double alcoholConsumedMl, double beersAfter6pm
});




}
/// @nodoc
class _$DailyStatsCopyWithImpl<$Res>
    implements $DailyStatsCopyWith<$Res> {
  _$DailyStatsCopyWithImpl(this._self, this._then);

  final DailyStats _self;
  final $Res Function(DailyStats) _then;

/// Create a copy of DailyStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? day = null,Object? beersConsumed = null,Object? alcoholConsumedMl = null,Object? beersAfter6pm = null,}) {
  return _then(_self.copyWith(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,beersConsumed: null == beersConsumed ? _self.beersConsumed : beersConsumed // ignore: cast_nullable_to_non_nullable
as double,alcoholConsumedMl: null == alcoholConsumedMl ? _self.alcoholConsumedMl : alcoholConsumedMl // ignore: cast_nullable_to_non_nullable
as double,beersAfter6pm: null == beersAfter6pm ? _self.beersAfter6pm : beersAfter6pm // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyStats].
extension DailyStatsPatterns on DailyStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyStats value)  $default,){
final _that = this;
switch (_that) {
case _DailyStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyStats value)?  $default,){
final _that = this;
switch (_that) {
case _DailyStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int day,  double beersConsumed,  double alcoholConsumedMl,  double beersAfter6pm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyStats() when $default != null:
return $default(_that.day,_that.beersConsumed,_that.alcoholConsumedMl,_that.beersAfter6pm);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int day,  double beersConsumed,  double alcoholConsumedMl,  double beersAfter6pm)  $default,) {final _that = this;
switch (_that) {
case _DailyStats():
return $default(_that.day,_that.beersConsumed,_that.alcoholConsumedMl,_that.beersAfter6pm);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int day,  double beersConsumed,  double alcoholConsumedMl,  double beersAfter6pm)?  $default,) {final _that = this;
switch (_that) {
case _DailyStats() when $default != null:
return $default(_that.day,_that.beersConsumed,_that.alcoholConsumedMl,_that.beersAfter6pm);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyStats extends DailyStats {
  const _DailyStats({required this.day, this.beersConsumed = 0, this.alcoholConsumedMl = 0, this.beersAfter6pm = 0}): super._();
  factory _DailyStats.fromJson(Map<String, dynamic> json) => _$DailyStatsFromJson(json);

@override final  int day;
@override@JsonKey() final  double beersConsumed;
@override@JsonKey() final  double alcoholConsumedMl;
@override@JsonKey() final  double beersAfter6pm;

/// Create a copy of DailyStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyStatsCopyWith<_DailyStats> get copyWith => __$DailyStatsCopyWithImpl<_DailyStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyStats&&(identical(other.day, day) || other.day == day)&&(identical(other.beersConsumed, beersConsumed) || other.beersConsumed == beersConsumed)&&(identical(other.alcoholConsumedMl, alcoholConsumedMl) || other.alcoholConsumedMl == alcoholConsumedMl)&&(identical(other.beersAfter6pm, beersAfter6pm) || other.beersAfter6pm == beersAfter6pm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,day,beersConsumed,alcoholConsumedMl,beersAfter6pm);

@override
String toString() {
  return 'DailyStats(day: $day, beersConsumed: $beersConsumed, alcoholConsumedMl: $alcoholConsumedMl, beersAfter6pm: $beersAfter6pm)';
}


}

/// @nodoc
abstract mixin class _$DailyStatsCopyWith<$Res> implements $DailyStatsCopyWith<$Res> {
  factory _$DailyStatsCopyWith(_DailyStats value, $Res Function(_DailyStats) _then) = __$DailyStatsCopyWithImpl;
@override @useResult
$Res call({
 int day, double beersConsumed, double alcoholConsumedMl, double beersAfter6pm
});




}
/// @nodoc
class __$DailyStatsCopyWithImpl<$Res>
    implements _$DailyStatsCopyWith<$Res> {
  __$DailyStatsCopyWithImpl(this._self, this._then);

  final _DailyStats _self;
  final $Res Function(_DailyStats) _then;

/// Create a copy of DailyStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? day = null,Object? beersConsumed = null,Object? alcoholConsumedMl = null,Object? beersAfter6pm = null,}) {
  return _then(_DailyStats(
day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,beersConsumed: null == beersConsumed ? _self.beersConsumed : beersConsumed // ignore: cast_nullable_to_non_nullable
as double,alcoholConsumedMl: null == alcoholConsumedMl ? _self.alcoholConsumedMl : alcoholConsumedMl // ignore: cast_nullable_to_non_nullable
as double,beersAfter6pm: null == beersAfter6pm ? _self.beersAfter6pm : beersAfter6pm // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
