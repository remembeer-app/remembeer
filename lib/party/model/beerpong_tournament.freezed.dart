// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'beerpong_tournament.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BeerpongTournament {

 String get id; BeerpongTournamentStatus get status; List<String> get participantIds; int get teamCount; bool get thirdPlaceEnabled; int get firstPlacePointsUnits; int get secondPlacePointsUnits; int get thirdPlacePointsUnits; String get randomSeedHash; String? get randomSeedReveal; String get createdByUserId;@TimestampConverterOptimistic() DateTime get createdAt;@TimestampConverter() DateTime? get completedAt;
/// Create a copy of BeerpongTournament
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BeerpongTournamentCopyWith<BeerpongTournament> get copyWith => _$BeerpongTournamentCopyWithImpl<BeerpongTournament>(this as BeerpongTournament, _$identity);

  /// Serializes this BeerpongTournament to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BeerpongTournament;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BeerpongTournament&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.status, _this.status) || other.status == _this.status)&&const DeepCollectionEquality().equals(other.participantIds, _this.participantIds)&&(identical(other.teamCount, _this.teamCount) || other.teamCount == _this.teamCount)&&(identical(other.thirdPlaceEnabled, _this.thirdPlaceEnabled) || other.thirdPlaceEnabled == _this.thirdPlaceEnabled)&&(identical(other.firstPlacePointsUnits, _this.firstPlacePointsUnits) || other.firstPlacePointsUnits == _this.firstPlacePointsUnits)&&(identical(other.secondPlacePointsUnits, _this.secondPlacePointsUnits) || other.secondPlacePointsUnits == _this.secondPlacePointsUnits)&&(identical(other.thirdPlacePointsUnits, _this.thirdPlacePointsUnits) || other.thirdPlacePointsUnits == _this.thirdPlacePointsUnits)&&(identical(other.randomSeedHash, _this.randomSeedHash) || other.randomSeedHash == _this.randomSeedHash)&&(identical(other.randomSeedReveal, _this.randomSeedReveal) || other.randomSeedReveal == _this.randomSeedReveal)&&(identical(other.createdByUserId, _this.createdByUserId) || other.createdByUserId == _this.createdByUserId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.completedAt, _this.completedAt) || other.completedAt == _this.completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BeerpongTournament;
  return Object.hash(runtimeType,_this.id,_this.status,const DeepCollectionEquality().hash(_this.participantIds),_this.teamCount,_this.thirdPlaceEnabled,_this.firstPlacePointsUnits,_this.secondPlacePointsUnits,_this.thirdPlacePointsUnits,_this.randomSeedHash,_this.randomSeedReveal,_this.createdByUserId,_this.createdAt,_this.completedAt);
}

@override
String toString() {
  final _this = this as BeerpongTournament;
  return 'BeerpongTournament(id: ${_this.id}, status: ${_this.status}, participantIds: ${_this.participantIds}, teamCount: ${_this.teamCount}, thirdPlaceEnabled: ${_this.thirdPlaceEnabled}, firstPlacePointsUnits: ${_this.firstPlacePointsUnits}, secondPlacePointsUnits: ${_this.secondPlacePointsUnits}, thirdPlacePointsUnits: ${_this.thirdPlacePointsUnits}, randomSeedHash: ${_this.randomSeedHash}, randomSeedReveal: ${_this.randomSeedReveal}, createdByUserId: ${_this.createdByUserId}, createdAt: ${_this.createdAt}, completedAt: ${_this.completedAt})';
}


}

/// @nodoc
abstract mixin class $BeerpongTournamentCopyWith<$Res>  {
  factory $BeerpongTournamentCopyWith(BeerpongTournament value, $Res Function(BeerpongTournament) _then) = _$BeerpongTournamentCopyWithImpl;
@useResult
$Res call({
 String id, BeerpongTournamentStatus status, List<String> participantIds, int teamCount, bool thirdPlaceEnabled, int firstPlacePointsUnits, int secondPlacePointsUnits, int thirdPlacePointsUnits, String randomSeedHash, String? randomSeedReveal, String createdByUserId,@TimestampConverterOptimistic() DateTime createdAt,@TimestampConverter() DateTime? completedAt
});




}
/// @nodoc
class _$BeerpongTournamentCopyWithImpl<$Res>
    implements $BeerpongTournamentCopyWith<$Res> {
  _$BeerpongTournamentCopyWithImpl(this._self, this._then);

  final BeerpongTournament _self;
  final $Res Function(BeerpongTournament) _then;

/// Create a copy of BeerpongTournament
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? participantIds = null,Object? teamCount = null,Object? thirdPlaceEnabled = null,Object? firstPlacePointsUnits = null,Object? secondPlacePointsUnits = null,Object? thirdPlacePointsUnits = null,Object? randomSeedHash = null,Object? randomSeedReveal = freezed,Object? createdByUserId = null,Object? createdAt = null,Object? completedAt = freezed,}) {
  return _then(BeerpongTournament(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BeerpongTournamentStatus,participantIds: null == participantIds ? _self.participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as List<String>,teamCount: null == teamCount ? _self.teamCount : teamCount // ignore: cast_nullable_to_non_nullable
as int,thirdPlaceEnabled: null == thirdPlaceEnabled ? _self.thirdPlaceEnabled : thirdPlaceEnabled // ignore: cast_nullable_to_non_nullable
as bool,firstPlacePointsUnits: null == firstPlacePointsUnits ? _self.firstPlacePointsUnits : firstPlacePointsUnits // ignore: cast_nullable_to_non_nullable
as int,secondPlacePointsUnits: null == secondPlacePointsUnits ? _self.secondPlacePointsUnits : secondPlacePointsUnits // ignore: cast_nullable_to_non_nullable
as int,thirdPlacePointsUnits: null == thirdPlacePointsUnits ? _self.thirdPlacePointsUnits : thirdPlacePointsUnits // ignore: cast_nullable_to_non_nullable
as int,randomSeedHash: null == randomSeedHash ? _self.randomSeedHash : randomSeedHash // ignore: cast_nullable_to_non_nullable
as String,randomSeedReveal: freezed == randomSeedReveal ? _self.randomSeedReveal : randomSeedReveal // ignore: cast_nullable_to_non_nullable
as String?,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BeerpongTournament].
extension BeerpongTournamentPatterns on BeerpongTournament {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BeerpongTournament value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BeerpongTournament() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BeerpongTournament value)  $default,){
final _that = this;
switch (_that) {
case _BeerpongTournament():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BeerpongTournament value)?  $default,){
final _that = this;
switch (_that) {
case _BeerpongTournament() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  BeerpongTournamentStatus status,  List<String> participantIds,  int teamCount,  bool thirdPlaceEnabled,  int firstPlacePointsUnits,  int secondPlacePointsUnits,  int thirdPlacePointsUnits,  String randomSeedHash,  String? randomSeedReveal,  String createdByUserId, @TimestampConverterOptimistic()  DateTime createdAt, @TimestampConverter()  DateTime? completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BeerpongTournament() when $default != null:
return $default(_that.id,_that.status,_that.participantIds,_that.teamCount,_that.thirdPlaceEnabled,_that.firstPlacePointsUnits,_that.secondPlacePointsUnits,_that.thirdPlacePointsUnits,_that.randomSeedHash,_that.randomSeedReveal,_that.createdByUserId,_that.createdAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  BeerpongTournamentStatus status,  List<String> participantIds,  int teamCount,  bool thirdPlaceEnabled,  int firstPlacePointsUnits,  int secondPlacePointsUnits,  int thirdPlacePointsUnits,  String randomSeedHash,  String? randomSeedReveal,  String createdByUserId, @TimestampConverterOptimistic()  DateTime createdAt, @TimestampConverter()  DateTime? completedAt)  $default,) {final _that = this;
switch (_that) {
case _BeerpongTournament():
return $default(_that.id,_that.status,_that.participantIds,_that.teamCount,_that.thirdPlaceEnabled,_that.firstPlacePointsUnits,_that.secondPlacePointsUnits,_that.thirdPlacePointsUnits,_that.randomSeedHash,_that.randomSeedReveal,_that.createdByUserId,_that.createdAt,_that.completedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  BeerpongTournamentStatus status,  List<String> participantIds,  int teamCount,  bool thirdPlaceEnabled,  int firstPlacePointsUnits,  int secondPlacePointsUnits,  int thirdPlacePointsUnits,  String randomSeedHash,  String? randomSeedReveal,  String createdByUserId, @TimestampConverterOptimistic()  DateTime createdAt, @TimestampConverter()  DateTime? completedAt)?  $default,) {final _that = this;
switch (_that) {
case _BeerpongTournament() when $default != null:
return $default(_that.id,_that.status,_that.participantIds,_that.teamCount,_that.thirdPlaceEnabled,_that.firstPlacePointsUnits,_that.secondPlacePointsUnits,_that.thirdPlacePointsUnits,_that.randomSeedHash,_that.randomSeedReveal,_that.createdByUserId,_that.createdAt,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BeerpongTournament implements BeerpongTournament {
  const _BeerpongTournament({required this.id, required this.status,  List<String> participantIds = const <String>[], required this.teamCount, this.thirdPlaceEnabled = false, required this.firstPlacePointsUnits, required this.secondPlacePointsUnits, required this.thirdPlacePointsUnits, required this.randomSeedHash, this.randomSeedReveal, required this.createdByUserId, @TimestampConverterOptimistic() required this.createdAt, @TimestampConverter() this.completedAt}): _participantIds = participantIds;
  factory _BeerpongTournament.fromJson(Map<String, dynamic> json) => _$BeerpongTournamentFromJson(json);

@override final  String id;
@override final  BeerpongTournamentStatus status;
 final  List<String> _participantIds;
@override@JsonKey() List<String> get participantIds {
  if (_participantIds is EqualUnmodifiableListView) return _participantIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participantIds);
}

@override final  int teamCount;
@override@JsonKey() final  bool thirdPlaceEnabled;
@override final  int firstPlacePointsUnits;
@override final  int secondPlacePointsUnits;
@override final  int thirdPlacePointsUnits;
@override final  String randomSeedHash;
@override final  String? randomSeedReveal;
@override final  String createdByUserId;
@override@TimestampConverterOptimistic() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime? completedAt;

/// Create a copy of BeerpongTournament
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BeerpongTournamentCopyWith<_BeerpongTournament> get copyWith => __$BeerpongTournamentCopyWithImpl<_BeerpongTournament>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BeerpongTournamentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BeerpongTournament&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.participantIds, _participantIds)&&(identical(other.teamCount, teamCount) || other.teamCount == teamCount)&&(identical(other.thirdPlaceEnabled, thirdPlaceEnabled) || other.thirdPlaceEnabled == thirdPlaceEnabled)&&(identical(other.firstPlacePointsUnits, firstPlacePointsUnits) || other.firstPlacePointsUnits == firstPlacePointsUnits)&&(identical(other.secondPlacePointsUnits, secondPlacePointsUnits) || other.secondPlacePointsUnits == secondPlacePointsUnits)&&(identical(other.thirdPlacePointsUnits, thirdPlacePointsUnits) || other.thirdPlacePointsUnits == thirdPlacePointsUnits)&&(identical(other.randomSeedHash, randomSeedHash) || other.randomSeedHash == randomSeedHash)&&(identical(other.randomSeedReveal, randomSeedReveal) || other.randomSeedReveal == randomSeedReveal)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,status,const DeepCollectionEquality().hash(_participantIds),teamCount,thirdPlaceEnabled,firstPlacePointsUnits,secondPlacePointsUnits,thirdPlacePointsUnits,randomSeedHash,randomSeedReveal,createdByUserId,createdAt,completedAt);
}

@override
String toString() {
    return 'BeerpongTournament(id: $id, status: $status, participantIds: $participantIds, teamCount: $teamCount, thirdPlaceEnabled: $thirdPlaceEnabled, firstPlacePointsUnits: $firstPlacePointsUnits, secondPlacePointsUnits: $secondPlacePointsUnits, thirdPlacePointsUnits: $thirdPlacePointsUnits, randomSeedHash: $randomSeedHash, randomSeedReveal: $randomSeedReveal, createdByUserId: $createdByUserId, createdAt: $createdAt, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$BeerpongTournamentCopyWith<$Res> implements $BeerpongTournamentCopyWith<$Res> {
  factory _$BeerpongTournamentCopyWith(_BeerpongTournament value, $Res Function(_BeerpongTournament) _then) = __$BeerpongTournamentCopyWithImpl;
@override @useResult
$Res call({
 String id, BeerpongTournamentStatus status, List<String> participantIds, int teamCount, bool thirdPlaceEnabled, int firstPlacePointsUnits, int secondPlacePointsUnits, int thirdPlacePointsUnits, String randomSeedHash, String? randomSeedReveal, String createdByUserId,@TimestampConverterOptimistic() DateTime createdAt,@TimestampConverter() DateTime? completedAt
});




}
/// @nodoc
class __$BeerpongTournamentCopyWithImpl<$Res>
    implements _$BeerpongTournamentCopyWith<$Res> {
  __$BeerpongTournamentCopyWithImpl(this._self, this._then);

  final _BeerpongTournament _self;
  final $Res Function(_BeerpongTournament) _then;

/// Create a copy of BeerpongTournament
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? participantIds = null,Object? teamCount = null,Object? thirdPlaceEnabled = null,Object? firstPlacePointsUnits = null,Object? secondPlacePointsUnits = null,Object? thirdPlacePointsUnits = null,Object? randomSeedHash = null,Object? randomSeedReveal = freezed,Object? createdByUserId = null,Object? createdAt = null,Object? completedAt = freezed,}) {
  return _then(_BeerpongTournament(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BeerpongTournamentStatus,participantIds: null == participantIds ? _self._participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as List<String>,teamCount: null == teamCount ? _self.teamCount : teamCount // ignore: cast_nullable_to_non_nullable
as int,thirdPlaceEnabled: null == thirdPlaceEnabled ? _self.thirdPlaceEnabled : thirdPlaceEnabled // ignore: cast_nullable_to_non_nullable
as bool,firstPlacePointsUnits: null == firstPlacePointsUnits ? _self.firstPlacePointsUnits : firstPlacePointsUnits // ignore: cast_nullable_to_non_nullable
as int,secondPlacePointsUnits: null == secondPlacePointsUnits ? _self.secondPlacePointsUnits : secondPlacePointsUnits // ignore: cast_nullable_to_non_nullable
as int,thirdPlacePointsUnits: null == thirdPlacePointsUnits ? _self.thirdPlacePointsUnits : thirdPlacePointsUnits // ignore: cast_nullable_to_non_nullable
as int,randomSeedHash: null == randomSeedHash ? _self.randomSeedHash : randomSeedHash // ignore: cast_nullable_to_non_nullable
as String,randomSeedReveal: freezed == randomSeedReveal ? _self.randomSeedReveal : randomSeedReveal // ignore: cast_nullable_to_non_nullable
as String?,createdByUserId: null == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
