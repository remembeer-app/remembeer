// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'party_quest_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PartyQuestTemplate {

 String get id; PartyQuestTemplateSource get source; String? get builtInKey; String get title; String get instructions; int get pointsUnits; int get durationMinutes; String get eligibilityRule; bool get enabled; int get catalogVersion; String? get createdByUserId;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get updatedAt;
/// Create a copy of PartyQuestTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartyQuestTemplateCopyWith<PartyQuestTemplate> get copyWith => _$PartyQuestTemplateCopyWithImpl<PartyQuestTemplate>(this as PartyQuestTemplate, _$identity);

  /// Serializes this PartyQuestTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PartyQuestTemplate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartyQuestTemplate&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.source, _this.source) || other.source == _this.source)&&(identical(other.builtInKey, _this.builtInKey) || other.builtInKey == _this.builtInKey)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.instructions, _this.instructions) || other.instructions == _this.instructions)&&(identical(other.pointsUnits, _this.pointsUnits) || other.pointsUnits == _this.pointsUnits)&&(identical(other.durationMinutes, _this.durationMinutes) || other.durationMinutes == _this.durationMinutes)&&(identical(other.eligibilityRule, _this.eligibilityRule) || other.eligibilityRule == _this.eligibilityRule)&&(identical(other.enabled, _this.enabled) || other.enabled == _this.enabled)&&(identical(other.catalogVersion, _this.catalogVersion) || other.catalogVersion == _this.catalogVersion)&&(identical(other.createdByUserId, _this.createdByUserId) || other.createdByUserId == _this.createdByUserId)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PartyQuestTemplate;
  return Object.hash(runtimeType,_this.id,_this.source,_this.builtInKey,_this.title,_this.instructions,_this.pointsUnits,_this.durationMinutes,_this.eligibilityRule,_this.enabled,_this.catalogVersion,_this.createdByUserId,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as PartyQuestTemplate;
  return 'PartyQuestTemplate(id: ${_this.id}, source: ${_this.source}, builtInKey: ${_this.builtInKey}, title: ${_this.title}, instructions: ${_this.instructions}, pointsUnits: ${_this.pointsUnits}, durationMinutes: ${_this.durationMinutes}, eligibilityRule: ${_this.eligibilityRule}, enabled: ${_this.enabled}, catalogVersion: ${_this.catalogVersion}, createdByUserId: ${_this.createdByUserId}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $PartyQuestTemplateCopyWith<$Res>  {
  factory $PartyQuestTemplateCopyWith(PartyQuestTemplate value, $Res Function(PartyQuestTemplate) _then) = _$PartyQuestTemplateCopyWithImpl;
@useResult
$Res call({
 String id, PartyQuestTemplateSource source, String? builtInKey, String title, String instructions, int pointsUnits, int durationMinutes, String eligibilityRule, bool enabled, int catalogVersion, String? createdByUserId,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class _$PartyQuestTemplateCopyWithImpl<$Res>
    implements $PartyQuestTemplateCopyWith<$Res> {
  _$PartyQuestTemplateCopyWithImpl(this._self, this._then);

  final PartyQuestTemplate _self;
  final $Res Function(PartyQuestTemplate) _then;

/// Create a copy of PartyQuestTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? source = null,Object? builtInKey = freezed,Object? title = null,Object? instructions = null,Object? pointsUnits = null,Object? durationMinutes = null,Object? eligibilityRule = null,Object? enabled = null,Object? catalogVersion = null,Object? createdByUserId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(PartyQuestTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as PartyQuestTemplateSource,builtInKey: freezed == builtInKey ? _self.builtInKey : builtInKey // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,pointsUnits: null == pointsUnits ? _self.pointsUnits : pointsUnits // ignore: cast_nullable_to_non_nullable
as int,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,eligibilityRule: null == eligibilityRule ? _self.eligibilityRule : eligibilityRule // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,catalogVersion: null == catalogVersion ? _self.catalogVersion : catalogVersion // ignore: cast_nullable_to_non_nullable
as int,createdByUserId: freezed == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [PartyQuestTemplate].
extension PartyQuestTemplatePatterns on PartyQuestTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartyQuestTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartyQuestTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartyQuestTemplate value)  $default,){
final _that = this;
switch (_that) {
case _PartyQuestTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartyQuestTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _PartyQuestTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  PartyQuestTemplateSource source,  String? builtInKey,  String title,  String instructions,  int pointsUnits,  int durationMinutes,  String eligibilityRule,  bool enabled,  int catalogVersion,  String? createdByUserId, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartyQuestTemplate() when $default != null:
return $default(_that.id,_that.source,_that.builtInKey,_that.title,_that.instructions,_that.pointsUnits,_that.durationMinutes,_that.eligibilityRule,_that.enabled,_that.catalogVersion,_that.createdByUserId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  PartyQuestTemplateSource source,  String? builtInKey,  String title,  String instructions,  int pointsUnits,  int durationMinutes,  String eligibilityRule,  bool enabled,  int catalogVersion,  String? createdByUserId, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _PartyQuestTemplate():
return $default(_that.id,_that.source,_that.builtInKey,_that.title,_that.instructions,_that.pointsUnits,_that.durationMinutes,_that.eligibilityRule,_that.enabled,_that.catalogVersion,_that.createdByUserId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  PartyQuestTemplateSource source,  String? builtInKey,  String title,  String instructions,  int pointsUnits,  int durationMinutes,  String eligibilityRule,  bool enabled,  int catalogVersion,  String? createdByUserId, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _PartyQuestTemplate() when $default != null:
return $default(_that.id,_that.source,_that.builtInKey,_that.title,_that.instructions,_that.pointsUnits,_that.durationMinutes,_that.eligibilityRule,_that.enabled,_that.catalogVersion,_that.createdByUserId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PartyQuestTemplate implements PartyQuestTemplate {
  const _PartyQuestTemplate({required this.id, required this.source, this.builtInKey, required this.title, required this.instructions, required this.pointsUnits, required this.durationMinutes, required this.eligibilityRule, this.enabled = true, required this.catalogVersion, this.createdByUserId, @TimestampConverter() required this.createdAt, @TimestampConverter() required this.updatedAt});
  factory _PartyQuestTemplate.fromJson(Map<String, dynamic> json) => _$PartyQuestTemplateFromJson(json);

@override final  String id;
@override final  PartyQuestTemplateSource source;
@override final  String? builtInKey;
@override final  String title;
@override final  String instructions;
@override final  int pointsUnits;
@override final  int durationMinutes;
@override final  String eligibilityRule;
@override@JsonKey() final  bool enabled;
@override final  int catalogVersion;
@override final  String? createdByUserId;
@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime updatedAt;

/// Create a copy of PartyQuestTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartyQuestTemplateCopyWith<_PartyQuestTemplate> get copyWith => __$PartyQuestTemplateCopyWithImpl<_PartyQuestTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PartyQuestTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartyQuestTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.source, source) || other.source == source)&&(identical(other.builtInKey, builtInKey) || other.builtInKey == builtInKey)&&(identical(other.title, title) || other.title == title)&&(identical(other.instructions, instructions) || other.instructions == instructions)&&(identical(other.pointsUnits, pointsUnits) || other.pointsUnits == pointsUnits)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.eligibilityRule, eligibilityRule) || other.eligibilityRule == eligibilityRule)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.catalogVersion, catalogVersion) || other.catalogVersion == catalogVersion)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,source,builtInKey,title,instructions,pointsUnits,durationMinutes,eligibilityRule,enabled,catalogVersion,createdByUserId,createdAt,updatedAt);
}

@override
String toString() {
    return 'PartyQuestTemplate(id: $id, source: $source, builtInKey: $builtInKey, title: $title, instructions: $instructions, pointsUnits: $pointsUnits, durationMinutes: $durationMinutes, eligibilityRule: $eligibilityRule, enabled: $enabled, catalogVersion: $catalogVersion, createdByUserId: $createdByUserId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PartyQuestTemplateCopyWith<$Res> implements $PartyQuestTemplateCopyWith<$Res> {
  factory _$PartyQuestTemplateCopyWith(_PartyQuestTemplate value, $Res Function(_PartyQuestTemplate) _then) = __$PartyQuestTemplateCopyWithImpl;
@override @useResult
$Res call({
 String id, PartyQuestTemplateSource source, String? builtInKey, String title, String instructions, int pointsUnits, int durationMinutes, String eligibilityRule, bool enabled, int catalogVersion, String? createdByUserId,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt
});




}
/// @nodoc
class __$PartyQuestTemplateCopyWithImpl<$Res>
    implements _$PartyQuestTemplateCopyWith<$Res> {
  __$PartyQuestTemplateCopyWithImpl(this._self, this._then);

  final _PartyQuestTemplate _self;
  final $Res Function(_PartyQuestTemplate) _then;

/// Create a copy of PartyQuestTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? source = null,Object? builtInKey = freezed,Object? title = null,Object? instructions = null,Object? pointsUnits = null,Object? durationMinutes = null,Object? eligibilityRule = null,Object? enabled = null,Object? catalogVersion = null,Object? createdByUserId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_PartyQuestTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as PartyQuestTemplateSource,builtInKey: freezed == builtInKey ? _self.builtInKey : builtInKey // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,instructions: null == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String,pointsUnits: null == pointsUnits ? _self.pointsUnits : pointsUnits // ignore: cast_nullable_to_non_nullable
as int,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,eligibilityRule: null == eligibilityRule ? _self.eligibilityRule : eligibilityRule // ignore: cast_nullable_to_non_nullable
as String,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,catalogVersion: null == catalogVersion ? _self.catalogVersion : catalogVersion // ignore: cast_nullable_to_non_nullable
as int,createdByUserId: freezed == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
