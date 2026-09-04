// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'party_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PartyEvent {

 String get id; PartyEventKind get kind; String get recipientUserId; List<String> get participantIds; int get pointsUnits; PartyEventSourceCollection get sourceCollection; String get sourceId; String? get reversesEventId; String? get actorUserId;@TimestampConverter() DateTime get occurredAt;@TimestampConverterOptimistic() DateTime get createdAt; Map<String, Object?> get payload;
/// Create a copy of PartyEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartyEventCopyWith<PartyEvent> get copyWith => _$PartyEventCopyWithImpl<PartyEvent>(this as PartyEvent, _$identity);

  /// Serializes this PartyEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PartyEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartyEvent&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.kind, _this.kind) || other.kind == _this.kind)&&(identical(other.recipientUserId, _this.recipientUserId) || other.recipientUserId == _this.recipientUserId)&&const DeepCollectionEquality().equals(other.participantIds, _this.participantIds)&&(identical(other.pointsUnits, _this.pointsUnits) || other.pointsUnits == _this.pointsUnits)&&(identical(other.sourceCollection, _this.sourceCollection) || other.sourceCollection == _this.sourceCollection)&&(identical(other.sourceId, _this.sourceId) || other.sourceId == _this.sourceId)&&(identical(other.reversesEventId, _this.reversesEventId) || other.reversesEventId == _this.reversesEventId)&&(identical(other.actorUserId, _this.actorUserId) || other.actorUserId == _this.actorUserId)&&(identical(other.occurredAt, _this.occurredAt) || other.occurredAt == _this.occurredAt)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&const DeepCollectionEquality().equals(other.payload, _this.payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PartyEvent;
  return Object.hash(runtimeType,_this.id,_this.kind,_this.recipientUserId,const DeepCollectionEquality().hash(_this.participantIds),_this.pointsUnits,_this.sourceCollection,_this.sourceId,_this.reversesEventId,_this.actorUserId,_this.occurredAt,_this.createdAt,const DeepCollectionEquality().hash(_this.payload));
}

@override
String toString() {
  final _this = this as PartyEvent;
  return 'PartyEvent(id: ${_this.id}, kind: ${_this.kind}, recipientUserId: ${_this.recipientUserId}, participantIds: ${_this.participantIds}, pointsUnits: ${_this.pointsUnits}, sourceCollection: ${_this.sourceCollection}, sourceId: ${_this.sourceId}, reversesEventId: ${_this.reversesEventId}, actorUserId: ${_this.actorUserId}, occurredAt: ${_this.occurredAt}, createdAt: ${_this.createdAt}, payload: ${_this.payload})';
}


}

/// @nodoc
abstract mixin class $PartyEventCopyWith<$Res>  {
  factory $PartyEventCopyWith(PartyEvent value, $Res Function(PartyEvent) _then) = _$PartyEventCopyWithImpl;
@useResult
$Res call({
 String id, PartyEventKind kind, String recipientUserId, List<String> participantIds, int pointsUnits, PartyEventSourceCollection sourceCollection, String sourceId, String? reversesEventId, String? actorUserId,@TimestampConverter() DateTime occurredAt,@TimestampConverterOptimistic() DateTime createdAt, Map<String, Object?> payload
});




}
/// @nodoc
class _$PartyEventCopyWithImpl<$Res>
    implements $PartyEventCopyWith<$Res> {
  _$PartyEventCopyWithImpl(this._self, this._then);

  final PartyEvent _self;
  final $Res Function(PartyEvent) _then;

/// Create a copy of PartyEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? recipientUserId = null,Object? participantIds = null,Object? pointsUnits = null,Object? sourceCollection = null,Object? sourceId = null,Object? reversesEventId = freezed,Object? actorUserId = freezed,Object? occurredAt = null,Object? createdAt = null,Object? payload = null,}) {
  return _then(PartyEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PartyEventKind,recipientUserId: null == recipientUserId ? _self.recipientUserId : recipientUserId // ignore: cast_nullable_to_non_nullable
as String,participantIds: null == participantIds ? _self.participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as List<String>,pointsUnits: null == pointsUnits ? _self.pointsUnits : pointsUnits // ignore: cast_nullable_to_non_nullable
as int,sourceCollection: null == sourceCollection ? _self.sourceCollection : sourceCollection // ignore: cast_nullable_to_non_nullable
as PartyEventSourceCollection,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,reversesEventId: freezed == reversesEventId ? _self.reversesEventId : reversesEventId // ignore: cast_nullable_to_non_nullable
as String?,actorUserId: freezed == actorUserId ? _self.actorUserId : actorUserId // ignore: cast_nullable_to_non_nullable
as String?,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}

}


/// Adds pattern-matching-related methods to [PartyEvent].
extension PartyEventPatterns on PartyEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartyEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartyEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartyEvent value)  $default,){
final _that = this;
switch (_that) {
case _PartyEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartyEvent value)?  $default,){
final _that = this;
switch (_that) {
case _PartyEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  PartyEventKind kind,  String recipientUserId,  List<String> participantIds,  int pointsUnits,  PartyEventSourceCollection sourceCollection,  String sourceId,  String? reversesEventId,  String? actorUserId, @TimestampConverter()  DateTime occurredAt, @TimestampConverterOptimistic()  DateTime createdAt,  Map<String, Object?> payload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartyEvent() when $default != null:
return $default(_that.id,_that.kind,_that.recipientUserId,_that.participantIds,_that.pointsUnits,_that.sourceCollection,_that.sourceId,_that.reversesEventId,_that.actorUserId,_that.occurredAt,_that.createdAt,_that.payload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  PartyEventKind kind,  String recipientUserId,  List<String> participantIds,  int pointsUnits,  PartyEventSourceCollection sourceCollection,  String sourceId,  String? reversesEventId,  String? actorUserId, @TimestampConverter()  DateTime occurredAt, @TimestampConverterOptimistic()  DateTime createdAt,  Map<String, Object?> payload)  $default,) {final _that = this;
switch (_that) {
case _PartyEvent():
return $default(_that.id,_that.kind,_that.recipientUserId,_that.participantIds,_that.pointsUnits,_that.sourceCollection,_that.sourceId,_that.reversesEventId,_that.actorUserId,_that.occurredAt,_that.createdAt,_that.payload);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  PartyEventKind kind,  String recipientUserId,  List<String> participantIds,  int pointsUnits,  PartyEventSourceCollection sourceCollection,  String sourceId,  String? reversesEventId,  String? actorUserId, @TimestampConverter()  DateTime occurredAt, @TimestampConverterOptimistic()  DateTime createdAt,  Map<String, Object?> payload)?  $default,) {final _that = this;
switch (_that) {
case _PartyEvent() when $default != null:
return $default(_that.id,_that.kind,_that.recipientUserId,_that.participantIds,_that.pointsUnits,_that.sourceCollection,_that.sourceId,_that.reversesEventId,_that.actorUserId,_that.occurredAt,_that.createdAt,_that.payload);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PartyEvent implements PartyEvent {
  const _PartyEvent({required this.id, required this.kind, required this.recipientUserId, required  List<String> participantIds, required this.pointsUnits, required this.sourceCollection, required this.sourceId, this.reversesEventId, this.actorUserId, @TimestampConverter() required this.occurredAt, @TimestampConverterOptimistic() required this.createdAt,  Map<String, Object?> payload = const <String, Object?>{}}): _participantIds = participantIds,_payload = payload;
  factory _PartyEvent.fromJson(Map<String, dynamic> json) => _$PartyEventFromJson(json);

@override final  String id;
@override final  PartyEventKind kind;
@override final  String recipientUserId;
 final  List<String> _participantIds;
@override List<String> get participantIds {
  if (_participantIds is EqualUnmodifiableListView) return _participantIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participantIds);
}

@override final  int pointsUnits;
@override final  PartyEventSourceCollection sourceCollection;
@override final  String sourceId;
@override final  String? reversesEventId;
@override final  String? actorUserId;
@override@TimestampConverter() final  DateTime occurredAt;
@override@TimestampConverterOptimistic() final  DateTime createdAt;
 final  Map<String, Object?> _payload;
@override@JsonKey() Map<String, Object?> get payload {
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_payload);
}


/// Create a copy of PartyEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartyEventCopyWith<_PartyEvent> get copyWith => __$PartyEventCopyWithImpl<_PartyEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PartyEventToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartyEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.recipientUserId, recipientUserId) || other.recipientUserId == recipientUserId)&&const DeepCollectionEquality().equals(other.participantIds, _participantIds)&&(identical(other.pointsUnits, pointsUnits) || other.pointsUnits == pointsUnits)&&(identical(other.sourceCollection, sourceCollection) || other.sourceCollection == sourceCollection)&&(identical(other.sourceId, sourceId) || other.sourceId == sourceId)&&(identical(other.reversesEventId, reversesEventId) || other.reversesEventId == reversesEventId)&&(identical(other.actorUserId, actorUserId) || other.actorUserId == actorUserId)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.payload, _payload));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,kind,recipientUserId,const DeepCollectionEquality().hash(_participantIds),pointsUnits,sourceCollection,sourceId,reversesEventId,actorUserId,occurredAt,createdAt,const DeepCollectionEquality().hash(_payload));
}

@override
String toString() {
    return 'PartyEvent(id: $id, kind: $kind, recipientUserId: $recipientUserId, participantIds: $participantIds, pointsUnits: $pointsUnits, sourceCollection: $sourceCollection, sourceId: $sourceId, reversesEventId: $reversesEventId, actorUserId: $actorUserId, occurredAt: $occurredAt, createdAt: $createdAt, payload: $payload)';
}


}

/// @nodoc
abstract mixin class _$PartyEventCopyWith<$Res> implements $PartyEventCopyWith<$Res> {
  factory _$PartyEventCopyWith(_PartyEvent value, $Res Function(_PartyEvent) _then) = __$PartyEventCopyWithImpl;
@override @useResult
$Res call({
 String id, PartyEventKind kind, String recipientUserId, List<String> participantIds, int pointsUnits, PartyEventSourceCollection sourceCollection, String sourceId, String? reversesEventId, String? actorUserId,@TimestampConverter() DateTime occurredAt,@TimestampConverterOptimistic() DateTime createdAt, Map<String, Object?> payload
});




}
/// @nodoc
class __$PartyEventCopyWithImpl<$Res>
    implements _$PartyEventCopyWith<$Res> {
  __$PartyEventCopyWithImpl(this._self, this._then);

  final _PartyEvent _self;
  final $Res Function(_PartyEvent) _then;

/// Create a copy of PartyEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? recipientUserId = null,Object? participantIds = null,Object? pointsUnits = null,Object? sourceCollection = null,Object? sourceId = null,Object? reversesEventId = freezed,Object? actorUserId = freezed,Object? occurredAt = null,Object? createdAt = null,Object? payload = null,}) {
  return _then(_PartyEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PartyEventKind,recipientUserId: null == recipientUserId ? _self.recipientUserId : recipientUserId // ignore: cast_nullable_to_non_nullable
as String,participantIds: null == participantIds ? _self._participantIds : participantIds // ignore: cast_nullable_to_non_nullable
as List<String>,pointsUnits: null == pointsUnits ? _self.pointsUnits : pointsUnits // ignore: cast_nullable_to_non_nullable
as int,sourceCollection: null == sourceCollection ? _self.sourceCollection : sourceCollection // ignore: cast_nullable_to_non_nullable
as PartyEventSourceCollection,sourceId: null == sourceId ? _self.sourceId : sourceId // ignore: cast_nullable_to_non_nullable
as String,reversesEventId: freezed == reversesEventId ? _self.reversesEventId : reversesEventId // ignore: cast_nullable_to_non_nullable
as String?,actorUserId: freezed == actorUserId ? _self.actorUserId : actorUserId // ignore: cast_nullable_to_non_nullable
as String?,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,payload: null == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, Object?>,
  ));
}


}

// dart format on
