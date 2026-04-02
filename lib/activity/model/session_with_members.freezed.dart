// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_with_members.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionWithMembers {

 Session get session; Map<String, UserModel> get members;
/// Create a copy of SessionWithMembers
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionWithMembersCopyWith<SessionWithMembers> get copyWith => _$SessionWithMembersCopyWithImpl<SessionWithMembers>(this as SessionWithMembers, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionWithMembers&&(identical(other.session, session) || other.session == session)&&const DeepCollectionEquality().equals(other.members, members));
}


@override
int get hashCode => Object.hash(runtimeType,session,const DeepCollectionEquality().hash(members));

@override
String toString() {
  return 'SessionWithMembers(session: $session, members: $members)';
}


}

/// @nodoc
abstract mixin class $SessionWithMembersCopyWith<$Res>  {
  factory $SessionWithMembersCopyWith(SessionWithMembers value, $Res Function(SessionWithMembers) _then) = _$SessionWithMembersCopyWithImpl;
@useResult
$Res call({
 Session session, Map<String, UserModel> members
});


$SessionCopyWith<$Res> get session;

}
/// @nodoc
class _$SessionWithMembersCopyWithImpl<$Res>
    implements $SessionWithMembersCopyWith<$Res> {
  _$SessionWithMembersCopyWithImpl(this._self, this._then);

  final SessionWithMembers _self;
  final $Res Function(SessionWithMembers) _then;

/// Create a copy of SessionWithMembers
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? session = null,Object? members = null,}) {
  return _then(_self.copyWith(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as Session,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as Map<String, UserModel>,
  ));
}
/// Create a copy of SessionWithMembers
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionCopyWith<$Res> get session {
  
  return $SessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}


/// Adds pattern-matching-related methods to [SessionWithMembers].
extension SessionWithMembersPatterns on SessionWithMembers {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionWithMembers value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionWithMembers() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionWithMembers value)  $default,){
final _that = this;
switch (_that) {
case _SessionWithMembers():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionWithMembers value)?  $default,){
final _that = this;
switch (_that) {
case _SessionWithMembers() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Session session,  Map<String, UserModel> members)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionWithMembers() when $default != null:
return $default(_that.session,_that.members);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Session session,  Map<String, UserModel> members)  $default,) {final _that = this;
switch (_that) {
case _SessionWithMembers():
return $default(_that.session,_that.members);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Session session,  Map<String, UserModel> members)?  $default,) {final _that = this;
switch (_that) {
case _SessionWithMembers() when $default != null:
return $default(_that.session,_that.members);case _:
  return null;

}
}

}

/// @nodoc


class _SessionWithMembers extends SessionWithMembers {
  const _SessionWithMembers({required this.session, required final  Map<String, UserModel> members}): _members = members,super._();
  

@override final  Session session;
 final  Map<String, UserModel> _members;
@override Map<String, UserModel> get members {
  if (_members is EqualUnmodifiableMapView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_members);
}


/// Create a copy of SessionWithMembers
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionWithMembersCopyWith<_SessionWithMembers> get copyWith => __$SessionWithMembersCopyWithImpl<_SessionWithMembers>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionWithMembers&&(identical(other.session, session) || other.session == session)&&const DeepCollectionEquality().equals(other._members, _members));
}


@override
int get hashCode => Object.hash(runtimeType,session,const DeepCollectionEquality().hash(_members));

@override
String toString() {
  return 'SessionWithMembers(session: $session, members: $members)';
}


}

/// @nodoc
abstract mixin class _$SessionWithMembersCopyWith<$Res> implements $SessionWithMembersCopyWith<$Res> {
  factory _$SessionWithMembersCopyWith(_SessionWithMembers value, $Res Function(_SessionWithMembers) _then) = __$SessionWithMembersCopyWithImpl;
@override @useResult
$Res call({
 Session session, Map<String, UserModel> members
});


@override $SessionCopyWith<$Res> get session;

}
/// @nodoc
class __$SessionWithMembersCopyWithImpl<$Res>
    implements _$SessionWithMembersCopyWith<$Res> {
  __$SessionWithMembersCopyWithImpl(this._self, this._then);

  final _SessionWithMembers _self;
  final $Res Function(_SessionWithMembers) _then;

/// Create a copy of SessionWithMembers
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? session = null,Object? members = null,}) {
  return _then(_SessionWithMembers(
session: null == session ? _self.session : session // ignore: cast_nullable_to_non_nullable
as Session,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as Map<String, UserModel>,
  ));
}

/// Create a copy of SessionWithMembers
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionCopyWith<$Res> get session {
  
  return $SessionCopyWith<$Res>(_self.session, (value) {
    return _then(_self.copyWith(session: value));
  });
}
}

// dart format on
