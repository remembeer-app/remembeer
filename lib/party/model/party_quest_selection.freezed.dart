// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'party_quest_selection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PartyQuestSelection {

 String get id; String get selectorUserId; String get selectedUserId;@TimestampConverter() DateTime get selectedAt;
/// Create a copy of PartyQuestSelection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartyQuestSelectionCopyWith<PartyQuestSelection> get copyWith => _$PartyQuestSelectionCopyWithImpl<PartyQuestSelection>(this as PartyQuestSelection, _$identity);

  /// Serializes this PartyQuestSelection to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PartyQuestSelection;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartyQuestSelection&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.selectorUserId, _this.selectorUserId) || other.selectorUserId == _this.selectorUserId)&&(identical(other.selectedUserId, _this.selectedUserId) || other.selectedUserId == _this.selectedUserId)&&(identical(other.selectedAt, _this.selectedAt) || other.selectedAt == _this.selectedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PartyQuestSelection;
  return Object.hash(runtimeType,_this.id,_this.selectorUserId,_this.selectedUserId,_this.selectedAt);
}

@override
String toString() {
  final _this = this as PartyQuestSelection;
  return 'PartyQuestSelection(id: ${_this.id}, selectorUserId: ${_this.selectorUserId}, selectedUserId: ${_this.selectedUserId}, selectedAt: ${_this.selectedAt})';
}


}

/// @nodoc
abstract mixin class $PartyQuestSelectionCopyWith<$Res>  {
  factory $PartyQuestSelectionCopyWith(PartyQuestSelection value, $Res Function(PartyQuestSelection) _then) = _$PartyQuestSelectionCopyWithImpl;
@useResult
$Res call({
 String id, String selectorUserId, String selectedUserId,@TimestampConverter() DateTime selectedAt
});




}
/// @nodoc
class _$PartyQuestSelectionCopyWithImpl<$Res>
    implements $PartyQuestSelectionCopyWith<$Res> {
  _$PartyQuestSelectionCopyWithImpl(this._self, this._then);

  final PartyQuestSelection _self;
  final $Res Function(PartyQuestSelection) _then;

/// Create a copy of PartyQuestSelection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? selectorUserId = null,Object? selectedUserId = null,Object? selectedAt = null,}) {
  return _then(PartyQuestSelection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,selectorUserId: null == selectorUserId ? _self.selectorUserId : selectorUserId // ignore: cast_nullable_to_non_nullable
as String,selectedUserId: null == selectedUserId ? _self.selectedUserId : selectedUserId // ignore: cast_nullable_to_non_nullable
as String,selectedAt: null == selectedAt ? _self.selectedAt : selectedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PartyQuestSelection].
extension PartyQuestSelectionPatterns on PartyQuestSelection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartyQuestSelection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartyQuestSelection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartyQuestSelection value)  $default,){
final _that = this;
switch (_that) {
case _PartyQuestSelection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartyQuestSelection value)?  $default,){
final _that = this;
switch (_that) {
case _PartyQuestSelection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String selectorUserId,  String selectedUserId, @TimestampConverter()  DateTime selectedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartyQuestSelection() when $default != null:
return $default(_that.id,_that.selectorUserId,_that.selectedUserId,_that.selectedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String selectorUserId,  String selectedUserId, @TimestampConverter()  DateTime selectedAt)  $default,) {final _that = this;
switch (_that) {
case _PartyQuestSelection():
return $default(_that.id,_that.selectorUserId,_that.selectedUserId,_that.selectedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String selectorUserId,  String selectedUserId, @TimestampConverter()  DateTime selectedAt)?  $default,) {final _that = this;
switch (_that) {
case _PartyQuestSelection() when $default != null:
return $default(_that.id,_that.selectorUserId,_that.selectedUserId,_that.selectedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PartyQuestSelection implements PartyQuestSelection {
  const _PartyQuestSelection({required this.id, required this.selectorUserId, required this.selectedUserId, @TimestampConverter() required this.selectedAt});
  factory _PartyQuestSelection.fromJson(Map<String, dynamic> json) => _$PartyQuestSelectionFromJson(json);

@override final  String id;
@override final  String selectorUserId;
@override final  String selectedUserId;
@override@TimestampConverter() final  DateTime selectedAt;

/// Create a copy of PartyQuestSelection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartyQuestSelectionCopyWith<_PartyQuestSelection> get copyWith => __$PartyQuestSelectionCopyWithImpl<_PartyQuestSelection>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PartyQuestSelectionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartyQuestSelection&&(identical(other.id, id) || other.id == id)&&(identical(other.selectorUserId, selectorUserId) || other.selectorUserId == selectorUserId)&&(identical(other.selectedUserId, selectedUserId) || other.selectedUserId == selectedUserId)&&(identical(other.selectedAt, selectedAt) || other.selectedAt == selectedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,selectorUserId,selectedUserId,selectedAt);
}

@override
String toString() {
    return 'PartyQuestSelection(id: $id, selectorUserId: $selectorUserId, selectedUserId: $selectedUserId, selectedAt: $selectedAt)';
}


}

/// @nodoc
abstract mixin class _$PartyQuestSelectionCopyWith<$Res> implements $PartyQuestSelectionCopyWith<$Res> {
  factory _$PartyQuestSelectionCopyWith(_PartyQuestSelection value, $Res Function(_PartyQuestSelection) _then) = __$PartyQuestSelectionCopyWithImpl;
@override @useResult
$Res call({
 String id, String selectorUserId, String selectedUserId,@TimestampConverter() DateTime selectedAt
});




}
/// @nodoc
class __$PartyQuestSelectionCopyWithImpl<$Res>
    implements _$PartyQuestSelectionCopyWith<$Res> {
  __$PartyQuestSelectionCopyWithImpl(this._self, this._then);

  final _PartyQuestSelection _self;
  final $Res Function(_PartyQuestSelection) _then;

/// Create a copy of PartyQuestSelection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? selectorUserId = null,Object? selectedUserId = null,Object? selectedAt = null,}) {
  return _then(_PartyQuestSelection(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,selectorUserId: null == selectorUserId ? _self.selectorUserId : selectorUserId // ignore: cast_nullable_to_non_nullable
as String,selectedUserId: null == selectedUserId ? _self.selectedUserId : selectedUserId // ignore: cast_nullable_to_non_nullable
as String,selectedAt: null == selectedAt ? _self.selectedAt : selectedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
