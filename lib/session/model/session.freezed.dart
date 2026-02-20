// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Session {

 String get id; String get userId;@TimestampConverterOptimistic() DateTime get createdAt;@TimestampConverterOptimistic() DateTime get updatedAt;@TimestampConverter() DateTime? get deletedAt; Set<String> get memberIds; Set<String> get bannedMemberIds; String get name; DateTime get startedAt; DateTime? get endedAt; List<Drink> get drinks; bool get isSoloSession;
/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionCopyWith<Session> get copyWith => _$SessionCopyWithImpl<Session>(this as Session, _$identity);

  /// Serializes this Session to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Session&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&const DeepCollectionEquality().equals(other.memberIds, memberIds)&&const DeepCollectionEquality().equals(other.bannedMemberIds, bannedMemberIds)&&(identical(other.name, name) || other.name == name)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&const DeepCollectionEquality().equals(other.drinks, drinks)&&(identical(other.isSoloSession, isSoloSession) || other.isSoloSession == isSoloSession));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,createdAt,updatedAt,deletedAt,const DeepCollectionEquality().hash(memberIds),const DeepCollectionEquality().hash(bannedMemberIds),name,startedAt,endedAt,const DeepCollectionEquality().hash(drinks),isSoloSession);

@override
String toString() {
  return 'Session(id: $id, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, memberIds: $memberIds, bannedMemberIds: $bannedMemberIds, name: $name, startedAt: $startedAt, endedAt: $endedAt, drinks: $drinks, isSoloSession: $isSoloSession)';
}


}

/// @nodoc
abstract mixin class $SessionCopyWith<$Res>  {
  factory $SessionCopyWith(Session value, $Res Function(Session) _then) = _$SessionCopyWithImpl;
@useResult
$Res call({
 String id, String userId,@TimestampConverterOptimistic() DateTime createdAt,@TimestampConverterOptimistic() DateTime updatedAt,@TimestampConverter() DateTime? deletedAt, Set<String> memberIds, Set<String> bannedMemberIds, String name, DateTime startedAt, DateTime? endedAt, List<Drink> drinks, bool isSoloSession
});




}
/// @nodoc
class _$SessionCopyWithImpl<$Res>
    implements $SessionCopyWith<$Res> {
  _$SessionCopyWithImpl(this._self, this._then);

  final Session _self;
  final $Res Function(Session) _then;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? memberIds = null,Object? bannedMemberIds = null,Object? name = null,Object? startedAt = null,Object? endedAt = freezed,Object? drinks = null,Object? isSoloSession = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,memberIds: null == memberIds ? _self.memberIds : memberIds // ignore: cast_nullable_to_non_nullable
as Set<String>,bannedMemberIds: null == bannedMemberIds ? _self.bannedMemberIds : bannedMemberIds // ignore: cast_nullable_to_non_nullable
as Set<String>,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,drinks: null == drinks ? _self.drinks : drinks // ignore: cast_nullable_to_non_nullable
as List<Drink>,isSoloSession: null == isSoloSession ? _self.isSoloSession : isSoloSession // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Session].
extension SessionPatterns on Session {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Session value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Session() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Session value)  $default,){
final _that = this;
switch (_that) {
case _Session():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Session value)?  $default,){
final _that = this;
switch (_that) {
case _Session() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId, @TimestampConverterOptimistic()  DateTime createdAt, @TimestampConverterOptimistic()  DateTime updatedAt, @TimestampConverter()  DateTime? deletedAt,  Set<String> memberIds,  Set<String> bannedMemberIds,  String name,  DateTime startedAt,  DateTime? endedAt,  List<Drink> drinks,  bool isSoloSession)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that.id,_that.userId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.memberIds,_that.bannedMemberIds,_that.name,_that.startedAt,_that.endedAt,_that.drinks,_that.isSoloSession);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId, @TimestampConverterOptimistic()  DateTime createdAt, @TimestampConverterOptimistic()  DateTime updatedAt, @TimestampConverter()  DateTime? deletedAt,  Set<String> memberIds,  Set<String> bannedMemberIds,  String name,  DateTime startedAt,  DateTime? endedAt,  List<Drink> drinks,  bool isSoloSession)  $default,) {final _that = this;
switch (_that) {
case _Session():
return $default(_that.id,_that.userId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.memberIds,_that.bannedMemberIds,_that.name,_that.startedAt,_that.endedAt,_that.drinks,_that.isSoloSession);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId, @TimestampConverterOptimistic()  DateTime createdAt, @TimestampConverterOptimistic()  DateTime updatedAt, @TimestampConverter()  DateTime? deletedAt,  Set<String> memberIds,  Set<String> bannedMemberIds,  String name,  DateTime startedAt,  DateTime? endedAt,  List<Drink> drinks,  bool isSoloSession)?  $default,) {final _that = this;
switch (_that) {
case _Session() when $default != null:
return $default(_that.id,_that.userId,_that.createdAt,_that.updatedAt,_that.deletedAt,_that.memberIds,_that.bannedMemberIds,_that.name,_that.startedAt,_that.endedAt,_that.drinks,_that.isSoloSession);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Session extends Session {
  const _Session({required this.id, required this.userId, @TimestampConverterOptimistic() required this.createdAt, @TimestampConverterOptimistic() required this.updatedAt, @TimestampConverter() this.deletedAt, required final  Set<String> memberIds, required final  Set<String> bannedMemberIds, required this.name, required this.startedAt, this.endedAt, final  List<Drink> drinks = const [], this.isSoloSession = true}): _memberIds = memberIds,_bannedMemberIds = bannedMemberIds,_drinks = drinks,super._();
  factory _Session.fromJson(Map<String, dynamic> json) => _$SessionFromJson(json);

@override final  String id;
@override final  String userId;
@override@TimestampConverterOptimistic() final  DateTime createdAt;
@override@TimestampConverterOptimistic() final  DateTime updatedAt;
@override@TimestampConverter() final  DateTime? deletedAt;
 final  Set<String> _memberIds;
@override Set<String> get memberIds {
  if (_memberIds is EqualUnmodifiableSetView) return _memberIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_memberIds);
}

 final  Set<String> _bannedMemberIds;
@override Set<String> get bannedMemberIds {
  if (_bannedMemberIds is EqualUnmodifiableSetView) return _bannedMemberIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_bannedMemberIds);
}

@override final  String name;
@override final  DateTime startedAt;
@override final  DateTime? endedAt;
 final  List<Drink> _drinks;
@override@JsonKey() List<Drink> get drinks {
  if (_drinks is EqualUnmodifiableListView) return _drinks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_drinks);
}

@override@JsonKey() final  bool isSoloSession;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionCopyWith<_Session> get copyWith => __$SessionCopyWithImpl<_Session>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Session&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.deletedAt, deletedAt) || other.deletedAt == deletedAt)&&const DeepCollectionEquality().equals(other._memberIds, _memberIds)&&const DeepCollectionEquality().equals(other._bannedMemberIds, _bannedMemberIds)&&(identical(other.name, name) || other.name == name)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&const DeepCollectionEquality().equals(other._drinks, _drinks)&&(identical(other.isSoloSession, isSoloSession) || other.isSoloSession == isSoloSession));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,createdAt,updatedAt,deletedAt,const DeepCollectionEquality().hash(_memberIds),const DeepCollectionEquality().hash(_bannedMemberIds),name,startedAt,endedAt,const DeepCollectionEquality().hash(_drinks),isSoloSession);

@override
String toString() {
  return 'Session(id: $id, userId: $userId, createdAt: $createdAt, updatedAt: $updatedAt, deletedAt: $deletedAt, memberIds: $memberIds, bannedMemberIds: $bannedMemberIds, name: $name, startedAt: $startedAt, endedAt: $endedAt, drinks: $drinks, isSoloSession: $isSoloSession)';
}


}

/// @nodoc
abstract mixin class _$SessionCopyWith<$Res> implements $SessionCopyWith<$Res> {
  factory _$SessionCopyWith(_Session value, $Res Function(_Session) _then) = __$SessionCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId,@TimestampConverterOptimistic() DateTime createdAt,@TimestampConverterOptimistic() DateTime updatedAt,@TimestampConverter() DateTime? deletedAt, Set<String> memberIds, Set<String> bannedMemberIds, String name, DateTime startedAt, DateTime? endedAt, List<Drink> drinks, bool isSoloSession
});




}
/// @nodoc
class __$SessionCopyWithImpl<$Res>
    implements _$SessionCopyWith<$Res> {
  __$SessionCopyWithImpl(this._self, this._then);

  final _Session _self;
  final $Res Function(_Session) _then;

/// Create a copy of Session
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? createdAt = null,Object? updatedAt = null,Object? deletedAt = freezed,Object? memberIds = null,Object? bannedMemberIds = null,Object? name = null,Object? startedAt = null,Object? endedAt = freezed,Object? drinks = null,Object? isSoloSession = null,}) {
  return _then(_Session(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,deletedAt: freezed == deletedAt ? _self.deletedAt : deletedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,memberIds: null == memberIds ? _self._memberIds : memberIds // ignore: cast_nullable_to_non_nullable
as Set<String>,bannedMemberIds: null == bannedMemberIds ? _self._bannedMemberIds : bannedMemberIds // ignore: cast_nullable_to_non_nullable
as Set<String>,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,drinks: null == drinks ? _self._drinks : drinks // ignore: cast_nullable_to_non_nullable
as List<Drink>,isSoloSession: null == isSoloSession ? _self.isSoloSession : isSoloSession // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
