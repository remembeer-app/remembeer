// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'beerpong_match.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BeerpongMatch {

 String get id; int get round; int get position; BeerpongMatchKind get kind; String? get teamAId; String? get teamBId; String? get winnerTeamId; String? get loserTeamId; BeerpongMatchStatus get status; String? get nextMatchId; BeerpongMatchSlot? get nextSlot;
/// Create a copy of BeerpongMatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BeerpongMatchCopyWith<BeerpongMatch> get copyWith => _$BeerpongMatchCopyWithImpl<BeerpongMatch>(this as BeerpongMatch, _$identity);

  /// Serializes this BeerpongMatch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as BeerpongMatch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BeerpongMatch&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.round, _this.round) || other.round == _this.round)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.teamAId, _this.teamAId) || other.teamAId == _this.teamAId)&&(identical(other.teamBId, _this.teamBId) || other.teamBId == _this.teamBId)&&(identical(other.winnerTeamId, _this.winnerTeamId) || other.winnerTeamId == _this.winnerTeamId)&&(identical(other.loserTeamId, _this.loserTeamId) || other.loserTeamId == _this.loserTeamId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.nextMatchId, _this.nextMatchId) || other.nextMatchId == _this.nextMatchId)&&(identical(other.nextSlot, _this.nextSlot) || other.nextSlot == _this.nextSlot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as BeerpongMatch;
  return Object.hash(runtimeType,_this.id,_this.round,_this.position,_this.kind,_this.teamAId,_this.teamBId,_this.winnerTeamId,_this.loserTeamId,_this.status,_this.nextMatchId,_this.nextSlot);
}

@override
String toString() {
  final _this = this as BeerpongMatch;
  return 'BeerpongMatch(id: ${_this.id}, round: ${_this.round}, position: ${_this.position}, kind: ${_this.kind}, teamAId: ${_this.teamAId}, teamBId: ${_this.teamBId}, winnerTeamId: ${_this.winnerTeamId}, loserTeamId: ${_this.loserTeamId}, status: ${_this.status}, nextMatchId: ${_this.nextMatchId}, nextSlot: ${_this.nextSlot})';
}


}

/// @nodoc
abstract mixin class $BeerpongMatchCopyWith<$Res>  {
  factory $BeerpongMatchCopyWith(BeerpongMatch value, $Res Function(BeerpongMatch) _then) = _$BeerpongMatchCopyWithImpl;
@useResult
$Res call({
 String id, int round, int position, BeerpongMatchKind kind, String? teamAId, String? teamBId, String? winnerTeamId, String? loserTeamId, BeerpongMatchStatus status, String? nextMatchId, BeerpongMatchSlot? nextSlot
});




}
/// @nodoc
class _$BeerpongMatchCopyWithImpl<$Res>
    implements $BeerpongMatchCopyWith<$Res> {
  _$BeerpongMatchCopyWithImpl(this._self, this._then);

  final BeerpongMatch _self;
  final $Res Function(BeerpongMatch) _then;

/// Create a copy of BeerpongMatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? round = null,Object? position = null,Object? kind = null,Object? teamAId = freezed,Object? teamBId = freezed,Object? winnerTeamId = freezed,Object? loserTeamId = freezed,Object? status = null,Object? nextMatchId = freezed,Object? nextSlot = freezed,}) {
  return _then(BeerpongMatch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,round: null == round ? _self.round : round // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as BeerpongMatchKind,teamAId: freezed == teamAId ? _self.teamAId : teamAId // ignore: cast_nullable_to_non_nullable
as String?,teamBId: freezed == teamBId ? _self.teamBId : teamBId // ignore: cast_nullable_to_non_nullable
as String?,winnerTeamId: freezed == winnerTeamId ? _self.winnerTeamId : winnerTeamId // ignore: cast_nullable_to_non_nullable
as String?,loserTeamId: freezed == loserTeamId ? _self.loserTeamId : loserTeamId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BeerpongMatchStatus,nextMatchId: freezed == nextMatchId ? _self.nextMatchId : nextMatchId // ignore: cast_nullable_to_non_nullable
as String?,nextSlot: freezed == nextSlot ? _self.nextSlot : nextSlot // ignore: cast_nullable_to_non_nullable
as BeerpongMatchSlot?,
  ));
}

}


/// Adds pattern-matching-related methods to [BeerpongMatch].
extension BeerpongMatchPatterns on BeerpongMatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BeerpongMatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BeerpongMatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BeerpongMatch value)  $default,){
final _that = this;
switch (_that) {
case _BeerpongMatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BeerpongMatch value)?  $default,){
final _that = this;
switch (_that) {
case _BeerpongMatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int round,  int position,  BeerpongMatchKind kind,  String? teamAId,  String? teamBId,  String? winnerTeamId,  String? loserTeamId,  BeerpongMatchStatus status,  String? nextMatchId,  BeerpongMatchSlot? nextSlot)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BeerpongMatch() when $default != null:
return $default(_that.id,_that.round,_that.position,_that.kind,_that.teamAId,_that.teamBId,_that.winnerTeamId,_that.loserTeamId,_that.status,_that.nextMatchId,_that.nextSlot);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int round,  int position,  BeerpongMatchKind kind,  String? teamAId,  String? teamBId,  String? winnerTeamId,  String? loserTeamId,  BeerpongMatchStatus status,  String? nextMatchId,  BeerpongMatchSlot? nextSlot)  $default,) {final _that = this;
switch (_that) {
case _BeerpongMatch():
return $default(_that.id,_that.round,_that.position,_that.kind,_that.teamAId,_that.teamBId,_that.winnerTeamId,_that.loserTeamId,_that.status,_that.nextMatchId,_that.nextSlot);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int round,  int position,  BeerpongMatchKind kind,  String? teamAId,  String? teamBId,  String? winnerTeamId,  String? loserTeamId,  BeerpongMatchStatus status,  String? nextMatchId,  BeerpongMatchSlot? nextSlot)?  $default,) {final _that = this;
switch (_that) {
case _BeerpongMatch() when $default != null:
return $default(_that.id,_that.round,_that.position,_that.kind,_that.teamAId,_that.teamBId,_that.winnerTeamId,_that.loserTeamId,_that.status,_that.nextMatchId,_that.nextSlot);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BeerpongMatch implements BeerpongMatch {
  const _BeerpongMatch({required this.id, required this.round, required this.position, required this.kind, this.teamAId, this.teamBId, this.winnerTeamId, this.loserTeamId, required this.status, this.nextMatchId, this.nextSlot});
  factory _BeerpongMatch.fromJson(Map<String, dynamic> json) => _$BeerpongMatchFromJson(json);

@override final  String id;
@override final  int round;
@override final  int position;
@override final  BeerpongMatchKind kind;
@override final  String? teamAId;
@override final  String? teamBId;
@override final  String? winnerTeamId;
@override final  String? loserTeamId;
@override final  BeerpongMatchStatus status;
@override final  String? nextMatchId;
@override final  BeerpongMatchSlot? nextSlot;

/// Create a copy of BeerpongMatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BeerpongMatchCopyWith<_BeerpongMatch> get copyWith => __$BeerpongMatchCopyWithImpl<_BeerpongMatch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BeerpongMatchToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BeerpongMatch&&(identical(other.id, id) || other.id == id)&&(identical(other.round, round) || other.round == round)&&(identical(other.position, position) || other.position == position)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.teamAId, teamAId) || other.teamAId == teamAId)&&(identical(other.teamBId, teamBId) || other.teamBId == teamBId)&&(identical(other.winnerTeamId, winnerTeamId) || other.winnerTeamId == winnerTeamId)&&(identical(other.loserTeamId, loserTeamId) || other.loserTeamId == loserTeamId)&&(identical(other.status, status) || other.status == status)&&(identical(other.nextMatchId, nextMatchId) || other.nextMatchId == nextMatchId)&&(identical(other.nextSlot, nextSlot) || other.nextSlot == nextSlot));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,round,position,kind,teamAId,teamBId,winnerTeamId,loserTeamId,status,nextMatchId,nextSlot);
}

@override
String toString() {
    return 'BeerpongMatch(id: $id, round: $round, position: $position, kind: $kind, teamAId: $teamAId, teamBId: $teamBId, winnerTeamId: $winnerTeamId, loserTeamId: $loserTeamId, status: $status, nextMatchId: $nextMatchId, nextSlot: $nextSlot)';
}


}

/// @nodoc
abstract mixin class _$BeerpongMatchCopyWith<$Res> implements $BeerpongMatchCopyWith<$Res> {
  factory _$BeerpongMatchCopyWith(_BeerpongMatch value, $Res Function(_BeerpongMatch) _then) = __$BeerpongMatchCopyWithImpl;
@override @useResult
$Res call({
 String id, int round, int position, BeerpongMatchKind kind, String? teamAId, String? teamBId, String? winnerTeamId, String? loserTeamId, BeerpongMatchStatus status, String? nextMatchId, BeerpongMatchSlot? nextSlot
});




}
/// @nodoc
class __$BeerpongMatchCopyWithImpl<$Res>
    implements _$BeerpongMatchCopyWith<$Res> {
  __$BeerpongMatchCopyWithImpl(this._self, this._then);

  final _BeerpongMatch _self;
  final $Res Function(_BeerpongMatch) _then;

/// Create a copy of BeerpongMatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? round = null,Object? position = null,Object? kind = null,Object? teamAId = freezed,Object? teamBId = freezed,Object? winnerTeamId = freezed,Object? loserTeamId = freezed,Object? status = null,Object? nextMatchId = freezed,Object? nextSlot = freezed,}) {
  return _then(_BeerpongMatch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,round: null == round ? _self.round : round // ignore: cast_nullable_to_non_nullable
as int,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as BeerpongMatchKind,teamAId: freezed == teamAId ? _self.teamAId : teamAId // ignore: cast_nullable_to_non_nullable
as String?,teamBId: freezed == teamBId ? _self.teamBId : teamBId // ignore: cast_nullable_to_non_nullable
as String?,winnerTeamId: freezed == winnerTeamId ? _self.winnerTeamId : winnerTeamId // ignore: cast_nullable_to_non_nullable
as String?,loserTeamId: freezed == loserTeamId ? _self.loserTeamId : loserTeamId // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BeerpongMatchStatus,nextMatchId: freezed == nextMatchId ? _self.nextMatchId : nextMatchId // ignore: cast_nullable_to_non_nullable
as String?,nextSlot: freezed == nextSlot ? _self.nextSlot : nextSlot // ignore: cast_nullable_to_non_nullable
as BeerpongMatchSlot?,
  ));
}


}

// dart format on
