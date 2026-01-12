// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'leaderboard_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LeaderboardEntry {

 UserModel get user; double get beersConsumed; double get alcoholConsumedMl; int get rankByBeers; int get rankByAlcohol;
/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LeaderboardEntryCopyWith<LeaderboardEntry> get copyWith => _$LeaderboardEntryCopyWithImpl<LeaderboardEntry>(this as LeaderboardEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LeaderboardEntry&&(identical(other.user, user) || other.user == user)&&(identical(other.beersConsumed, beersConsumed) || other.beersConsumed == beersConsumed)&&(identical(other.alcoholConsumedMl, alcoholConsumedMl) || other.alcoholConsumedMl == alcoholConsumedMl)&&(identical(other.rankByBeers, rankByBeers) || other.rankByBeers == rankByBeers)&&(identical(other.rankByAlcohol, rankByAlcohol) || other.rankByAlcohol == rankByAlcohol));
}


@override
int get hashCode => Object.hash(runtimeType,user,beersConsumed,alcoholConsumedMl,rankByBeers,rankByAlcohol);

@override
String toString() {
  return 'LeaderboardEntry(user: $user, beersConsumed: $beersConsumed, alcoholConsumedMl: $alcoholConsumedMl, rankByBeers: $rankByBeers, rankByAlcohol: $rankByAlcohol)';
}


}

/// @nodoc
abstract mixin class $LeaderboardEntryCopyWith<$Res>  {
  factory $LeaderboardEntryCopyWith(LeaderboardEntry value, $Res Function(LeaderboardEntry) _then) = _$LeaderboardEntryCopyWithImpl;
@useResult
$Res call({
 UserModel user, double beersConsumed, double alcoholConsumedMl, int rankByBeers, int rankByAlcohol
});


$UserModelCopyWith<$Res> get user;

}
/// @nodoc
class _$LeaderboardEntryCopyWithImpl<$Res>
    implements $LeaderboardEntryCopyWith<$Res> {
  _$LeaderboardEntryCopyWithImpl(this._self, this._then);

  final LeaderboardEntry _self;
  final $Res Function(LeaderboardEntry) _then;

/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? user = null,Object? beersConsumed = null,Object? alcoholConsumedMl = null,Object? rankByBeers = null,Object? rankByAlcohol = null,}) {
  return _then(_self.copyWith(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel,beersConsumed: null == beersConsumed ? _self.beersConsumed : beersConsumed // ignore: cast_nullable_to_non_nullable
as double,alcoholConsumedMl: null == alcoholConsumedMl ? _self.alcoholConsumedMl : alcoholConsumedMl // ignore: cast_nullable_to_non_nullable
as double,rankByBeers: null == rankByBeers ? _self.rankByBeers : rankByBeers // ignore: cast_nullable_to_non_nullable
as int,rankByAlcohol: null == rankByAlcohol ? _self.rankByAlcohol : rankByAlcohol // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get user {
  
  return $UserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}


/// Adds pattern-matching-related methods to [LeaderboardEntry].
extension LeaderboardEntryPatterns on LeaderboardEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LeaderboardEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LeaderboardEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LeaderboardEntry value)  $default,){
final _that = this;
switch (_that) {
case _LeaderboardEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LeaderboardEntry value)?  $default,){
final _that = this;
switch (_that) {
case _LeaderboardEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( UserModel user,  double beersConsumed,  double alcoholConsumedMl,  int rankByBeers,  int rankByAlcohol)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LeaderboardEntry() when $default != null:
return $default(_that.user,_that.beersConsumed,_that.alcoholConsumedMl,_that.rankByBeers,_that.rankByAlcohol);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( UserModel user,  double beersConsumed,  double alcoholConsumedMl,  int rankByBeers,  int rankByAlcohol)  $default,) {final _that = this;
switch (_that) {
case _LeaderboardEntry():
return $default(_that.user,_that.beersConsumed,_that.alcoholConsumedMl,_that.rankByBeers,_that.rankByAlcohol);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( UserModel user,  double beersConsumed,  double alcoholConsumedMl,  int rankByBeers,  int rankByAlcohol)?  $default,) {final _that = this;
switch (_that) {
case _LeaderboardEntry() when $default != null:
return $default(_that.user,_that.beersConsumed,_that.alcoholConsumedMl,_that.rankByBeers,_that.rankByAlcohol);case _:
  return null;

}
}

}

/// @nodoc


class _LeaderboardEntry implements LeaderboardEntry {
  const _LeaderboardEntry({required this.user, required this.beersConsumed, required this.alcoholConsumedMl, required this.rankByBeers, required this.rankByAlcohol});
  

@override final  UserModel user;
@override final  double beersConsumed;
@override final  double alcoholConsumedMl;
@override final  int rankByBeers;
@override final  int rankByAlcohol;

/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LeaderboardEntryCopyWith<_LeaderboardEntry> get copyWith => __$LeaderboardEntryCopyWithImpl<_LeaderboardEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LeaderboardEntry&&(identical(other.user, user) || other.user == user)&&(identical(other.beersConsumed, beersConsumed) || other.beersConsumed == beersConsumed)&&(identical(other.alcoholConsumedMl, alcoholConsumedMl) || other.alcoholConsumedMl == alcoholConsumedMl)&&(identical(other.rankByBeers, rankByBeers) || other.rankByBeers == rankByBeers)&&(identical(other.rankByAlcohol, rankByAlcohol) || other.rankByAlcohol == rankByAlcohol));
}


@override
int get hashCode => Object.hash(runtimeType,user,beersConsumed,alcoholConsumedMl,rankByBeers,rankByAlcohol);

@override
String toString() {
  return 'LeaderboardEntry(user: $user, beersConsumed: $beersConsumed, alcoholConsumedMl: $alcoholConsumedMl, rankByBeers: $rankByBeers, rankByAlcohol: $rankByAlcohol)';
}


}

/// @nodoc
abstract mixin class _$LeaderboardEntryCopyWith<$Res> implements $LeaderboardEntryCopyWith<$Res> {
  factory _$LeaderboardEntryCopyWith(_LeaderboardEntry value, $Res Function(_LeaderboardEntry) _then) = __$LeaderboardEntryCopyWithImpl;
@override @useResult
$Res call({
 UserModel user, double beersConsumed, double alcoholConsumedMl, int rankByBeers, int rankByAlcohol
});


@override $UserModelCopyWith<$Res> get user;

}
/// @nodoc
class __$LeaderboardEntryCopyWithImpl<$Res>
    implements _$LeaderboardEntryCopyWith<$Res> {
  __$LeaderboardEntryCopyWithImpl(this._self, this._then);

  final _LeaderboardEntry _self;
  final $Res Function(_LeaderboardEntry) _then;

/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? user = null,Object? beersConsumed = null,Object? alcoholConsumedMl = null,Object? rankByBeers = null,Object? rankByAlcohol = null,}) {
  return _then(_LeaderboardEntry(
user: null == user ? _self.user : user // ignore: cast_nullable_to_non_nullable
as UserModel,beersConsumed: null == beersConsumed ? _self.beersConsumed : beersConsumed // ignore: cast_nullable_to_non_nullable
as double,alcoholConsumedMl: null == alcoholConsumedMl ? _self.alcoholConsumedMl : alcoholConsumedMl // ignore: cast_nullable_to_non_nullable
as double,rankByBeers: null == rankByBeers ? _self.rankByBeers : rankByBeers // ignore: cast_nullable_to_non_nullable
as int,rankByAlcohol: null == rankByAlcohol ? _self.rankByAlcohol : rankByAlcohol // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of LeaderboardEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UserModelCopyWith<$Res> get user {
  
  return $UserModelCopyWith<$Res>(_self.user, (value) {
    return _then(_self.copyWith(user: value));
  });
}
}

// dart format on
