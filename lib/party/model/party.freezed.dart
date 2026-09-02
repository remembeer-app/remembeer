// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'party.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PartyModuleSettings {

 bool get socialQuestsEnabled; bool get adminChallengesEnabled; bool get beerpongEnabled;
/// Create a copy of PartyModuleSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartyModuleSettingsCopyWith<PartyModuleSettings> get copyWith => _$PartyModuleSettingsCopyWithImpl<PartyModuleSettings>(this as PartyModuleSettings, _$identity);

  /// Serializes this PartyModuleSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PartyModuleSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartyModuleSettings&&(identical(other.socialQuestsEnabled, _this.socialQuestsEnabled) || other.socialQuestsEnabled == _this.socialQuestsEnabled)&&(identical(other.adminChallengesEnabled, _this.adminChallengesEnabled) || other.adminChallengesEnabled == _this.adminChallengesEnabled)&&(identical(other.beerpongEnabled, _this.beerpongEnabled) || other.beerpongEnabled == _this.beerpongEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PartyModuleSettings;
  return Object.hash(runtimeType,_this.socialQuestsEnabled,_this.adminChallengesEnabled,_this.beerpongEnabled);
}

@override
String toString() {
  final _this = this as PartyModuleSettings;
  return 'PartyModuleSettings(socialQuestsEnabled: ${_this.socialQuestsEnabled}, adminChallengesEnabled: ${_this.adminChallengesEnabled}, beerpongEnabled: ${_this.beerpongEnabled})';
}


}

/// @nodoc
abstract mixin class $PartyModuleSettingsCopyWith<$Res>  {
  factory $PartyModuleSettingsCopyWith(PartyModuleSettings value, $Res Function(PartyModuleSettings) _then) = _$PartyModuleSettingsCopyWithImpl;
@useResult
$Res call({
 bool socialQuestsEnabled, bool adminChallengesEnabled, bool beerpongEnabled
});




}
/// @nodoc
class _$PartyModuleSettingsCopyWithImpl<$Res>
    implements $PartyModuleSettingsCopyWith<$Res> {
  _$PartyModuleSettingsCopyWithImpl(this._self, this._then);

  final PartyModuleSettings _self;
  final $Res Function(PartyModuleSettings) _then;

/// Create a copy of PartyModuleSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? socialQuestsEnabled = null,Object? adminChallengesEnabled = null,Object? beerpongEnabled = null,}) {
  return _then(PartyModuleSettings(
socialQuestsEnabled: null == socialQuestsEnabled ? _self.socialQuestsEnabled : socialQuestsEnabled // ignore: cast_nullable_to_non_nullable
as bool,adminChallengesEnabled: null == adminChallengesEnabled ? _self.adminChallengesEnabled : adminChallengesEnabled // ignore: cast_nullable_to_non_nullable
as bool,beerpongEnabled: null == beerpongEnabled ? _self.beerpongEnabled : beerpongEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [PartyModuleSettings].
extension PartyModuleSettingsPatterns on PartyModuleSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartyModuleSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartyModuleSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartyModuleSettings value)  $default,){
final _that = this;
switch (_that) {
case _PartyModuleSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartyModuleSettings value)?  $default,){
final _that = this;
switch (_that) {
case _PartyModuleSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool socialQuestsEnabled,  bool adminChallengesEnabled,  bool beerpongEnabled)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartyModuleSettings() when $default != null:
return $default(_that.socialQuestsEnabled,_that.adminChallengesEnabled,_that.beerpongEnabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool socialQuestsEnabled,  bool adminChallengesEnabled,  bool beerpongEnabled)  $default,) {final _that = this;
switch (_that) {
case _PartyModuleSettings():
return $default(_that.socialQuestsEnabled,_that.adminChallengesEnabled,_that.beerpongEnabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool socialQuestsEnabled,  bool adminChallengesEnabled,  bool beerpongEnabled)?  $default,) {final _that = this;
switch (_that) {
case _PartyModuleSettings() when $default != null:
return $default(_that.socialQuestsEnabled,_that.adminChallengesEnabled,_that.beerpongEnabled);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PartyModuleSettings implements PartyModuleSettings {
  const _PartyModuleSettings({this.socialQuestsEnabled = false, this.adminChallengesEnabled = false, this.beerpongEnabled = false});
  factory _PartyModuleSettings.fromJson(Map<String, dynamic> json) => _$PartyModuleSettingsFromJson(json);

@override@JsonKey() final  bool socialQuestsEnabled;
@override@JsonKey() final  bool adminChallengesEnabled;
@override@JsonKey() final  bool beerpongEnabled;

/// Create a copy of PartyModuleSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartyModuleSettingsCopyWith<_PartyModuleSettings> get copyWith => __$PartyModuleSettingsCopyWithImpl<_PartyModuleSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PartyModuleSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartyModuleSettings&&(identical(other.socialQuestsEnabled, socialQuestsEnabled) || other.socialQuestsEnabled == socialQuestsEnabled)&&(identical(other.adminChallengesEnabled, adminChallengesEnabled) || other.adminChallengesEnabled == adminChallengesEnabled)&&(identical(other.beerpongEnabled, beerpongEnabled) || other.beerpongEnabled == beerpongEnabled));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,socialQuestsEnabled,adminChallengesEnabled,beerpongEnabled);
}

@override
String toString() {
    return 'PartyModuleSettings(socialQuestsEnabled: $socialQuestsEnabled, adminChallengesEnabled: $adminChallengesEnabled, beerpongEnabled: $beerpongEnabled)';
}


}

/// @nodoc
abstract mixin class _$PartyModuleSettingsCopyWith<$Res> implements $PartyModuleSettingsCopyWith<$Res> {
  factory _$PartyModuleSettingsCopyWith(_PartyModuleSettings value, $Res Function(_PartyModuleSettings) _then) = __$PartyModuleSettingsCopyWithImpl;
@override @useResult
$Res call({
 bool socialQuestsEnabled, bool adminChallengesEnabled, bool beerpongEnabled
});




}
/// @nodoc
class __$PartyModuleSettingsCopyWithImpl<$Res>
    implements _$PartyModuleSettingsCopyWith<$Res> {
  __$PartyModuleSettingsCopyWithImpl(this._self, this._then);

  final _PartyModuleSettings _self;
  final $Res Function(_PartyModuleSettings) _then;

/// Create a copy of PartyModuleSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? socialQuestsEnabled = null,Object? adminChallengesEnabled = null,Object? beerpongEnabled = null,}) {
  return _then(_PartyModuleSettings(
socialQuestsEnabled: null == socialQuestsEnabled ? _self.socialQuestsEnabled : socialQuestsEnabled // ignore: cast_nullable_to_non_nullable
as bool,adminChallengesEnabled: null == adminChallengesEnabled ? _self.adminChallengesEnabled : adminChallengesEnabled // ignore: cast_nullable_to_non_nullable
as bool,beerpongEnabled: null == beerpongEnabled ? _self.beerpongEnabled : beerpongEnabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$PartyQuestSchedule {

 int get minIntervalMinutes; int get maxIntervalMinutes; int get defaultDurationMinutes;@TimestampConverter() DateTime? get nextQuestAt;
/// Create a copy of PartyQuestSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartyQuestScheduleCopyWith<PartyQuestSchedule> get copyWith => _$PartyQuestScheduleCopyWithImpl<PartyQuestSchedule>(this as PartyQuestSchedule, _$identity);

  /// Serializes this PartyQuestSchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PartyQuestSchedule;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PartyQuestSchedule&&(identical(other.minIntervalMinutes, _this.minIntervalMinutes) || other.minIntervalMinutes == _this.minIntervalMinutes)&&(identical(other.maxIntervalMinutes, _this.maxIntervalMinutes) || other.maxIntervalMinutes == _this.maxIntervalMinutes)&&(identical(other.defaultDurationMinutes, _this.defaultDurationMinutes) || other.defaultDurationMinutes == _this.defaultDurationMinutes)&&(identical(other.nextQuestAt, _this.nextQuestAt) || other.nextQuestAt == _this.nextQuestAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PartyQuestSchedule;
  return Object.hash(runtimeType,_this.minIntervalMinutes,_this.maxIntervalMinutes,_this.defaultDurationMinutes,_this.nextQuestAt);
}

@override
String toString() {
  final _this = this as PartyQuestSchedule;
  return 'PartyQuestSchedule(minIntervalMinutes: ${_this.minIntervalMinutes}, maxIntervalMinutes: ${_this.maxIntervalMinutes}, defaultDurationMinutes: ${_this.defaultDurationMinutes}, nextQuestAt: ${_this.nextQuestAt})';
}


}

/// @nodoc
abstract mixin class $PartyQuestScheduleCopyWith<$Res>  {
  factory $PartyQuestScheduleCopyWith(PartyQuestSchedule value, $Res Function(PartyQuestSchedule) _then) = _$PartyQuestScheduleCopyWithImpl;
@useResult
$Res call({
 int minIntervalMinutes, int maxIntervalMinutes, int defaultDurationMinutes,@TimestampConverter() DateTime? nextQuestAt
});




}
/// @nodoc
class _$PartyQuestScheduleCopyWithImpl<$Res>
    implements $PartyQuestScheduleCopyWith<$Res> {
  _$PartyQuestScheduleCopyWithImpl(this._self, this._then);

  final PartyQuestSchedule _self;
  final $Res Function(PartyQuestSchedule) _then;

/// Create a copy of PartyQuestSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? minIntervalMinutes = null,Object? maxIntervalMinutes = null,Object? defaultDurationMinutes = null,Object? nextQuestAt = freezed,}) {
  return _then(PartyQuestSchedule(
minIntervalMinutes: null == minIntervalMinutes ? _self.minIntervalMinutes : minIntervalMinutes // ignore: cast_nullable_to_non_nullable
as int,maxIntervalMinutes: null == maxIntervalMinutes ? _self.maxIntervalMinutes : maxIntervalMinutes // ignore: cast_nullable_to_non_nullable
as int,defaultDurationMinutes: null == defaultDurationMinutes ? _self.defaultDurationMinutes : defaultDurationMinutes // ignore: cast_nullable_to_non_nullable
as int,nextQuestAt: freezed == nextQuestAt ? _self.nextQuestAt : nextQuestAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PartyQuestSchedule].
extension PartyQuestSchedulePatterns on PartyQuestSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PartyQuestSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PartyQuestSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PartyQuestSchedule value)  $default,){
final _that = this;
switch (_that) {
case _PartyQuestSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PartyQuestSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _PartyQuestSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int minIntervalMinutes,  int maxIntervalMinutes,  int defaultDurationMinutes, @TimestampConverter()  DateTime? nextQuestAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PartyQuestSchedule() when $default != null:
return $default(_that.minIntervalMinutes,_that.maxIntervalMinutes,_that.defaultDurationMinutes,_that.nextQuestAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int minIntervalMinutes,  int maxIntervalMinutes,  int defaultDurationMinutes, @TimestampConverter()  DateTime? nextQuestAt)  $default,) {final _that = this;
switch (_that) {
case _PartyQuestSchedule():
return $default(_that.minIntervalMinutes,_that.maxIntervalMinutes,_that.defaultDurationMinutes,_that.nextQuestAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int minIntervalMinutes,  int maxIntervalMinutes,  int defaultDurationMinutes, @TimestampConverter()  DateTime? nextQuestAt)?  $default,) {final _that = this;
switch (_that) {
case _PartyQuestSchedule() when $default != null:
return $default(_that.minIntervalMinutes,_that.maxIntervalMinutes,_that.defaultDurationMinutes,_that.nextQuestAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PartyQuestSchedule implements PartyQuestSchedule {
  const _PartyQuestSchedule({this.minIntervalMinutes = defaultPartyQuestMinIntervalMinutes, this.maxIntervalMinutes = defaultPartyQuestMaxIntervalMinutes, this.defaultDurationMinutes = defaultPartyQuestDurationMinutes, @TimestampConverter() this.nextQuestAt});
  factory _PartyQuestSchedule.fromJson(Map<String, dynamic> json) => _$PartyQuestScheduleFromJson(json);

@override@JsonKey() final  int minIntervalMinutes;
@override@JsonKey() final  int maxIntervalMinutes;
@override@JsonKey() final  int defaultDurationMinutes;
@override@TimestampConverter() final  DateTime? nextQuestAt;

/// Create a copy of PartyQuestSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartyQuestScheduleCopyWith<_PartyQuestSchedule> get copyWith => __$PartyQuestScheduleCopyWithImpl<_PartyQuestSchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PartyQuestScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PartyQuestSchedule&&(identical(other.minIntervalMinutes, minIntervalMinutes) || other.minIntervalMinutes == minIntervalMinutes)&&(identical(other.maxIntervalMinutes, maxIntervalMinutes) || other.maxIntervalMinutes == maxIntervalMinutes)&&(identical(other.defaultDurationMinutes, defaultDurationMinutes) || other.defaultDurationMinutes == defaultDurationMinutes)&&(identical(other.nextQuestAt, nextQuestAt) || other.nextQuestAt == nextQuestAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,minIntervalMinutes,maxIntervalMinutes,defaultDurationMinutes,nextQuestAt);
}

@override
String toString() {
    return 'PartyQuestSchedule(minIntervalMinutes: $minIntervalMinutes, maxIntervalMinutes: $maxIntervalMinutes, defaultDurationMinutes: $defaultDurationMinutes, nextQuestAt: $nextQuestAt)';
}


}

/// @nodoc
abstract mixin class _$PartyQuestScheduleCopyWith<$Res> implements $PartyQuestScheduleCopyWith<$Res> {
  factory _$PartyQuestScheduleCopyWith(_PartyQuestSchedule value, $Res Function(_PartyQuestSchedule) _then) = __$PartyQuestScheduleCopyWithImpl;
@override @useResult
$Res call({
 int minIntervalMinutes, int maxIntervalMinutes, int defaultDurationMinutes,@TimestampConverter() DateTime? nextQuestAt
});




}
/// @nodoc
class __$PartyQuestScheduleCopyWithImpl<$Res>
    implements _$PartyQuestScheduleCopyWith<$Res> {
  __$PartyQuestScheduleCopyWithImpl(this._self, this._then);

  final _PartyQuestSchedule _self;
  final $Res Function(_PartyQuestSchedule) _then;

/// Create a copy of PartyQuestSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? minIntervalMinutes = null,Object? maxIntervalMinutes = null,Object? defaultDurationMinutes = null,Object? nextQuestAt = freezed,}) {
  return _then(_PartyQuestSchedule(
minIntervalMinutes: null == minIntervalMinutes ? _self.minIntervalMinutes : minIntervalMinutes // ignore: cast_nullable_to_non_nullable
as int,maxIntervalMinutes: null == maxIntervalMinutes ? _self.maxIntervalMinutes : maxIntervalMinutes // ignore: cast_nullable_to_non_nullable
as int,defaultDurationMinutes: null == defaultDurationMinutes ? _self.defaultDurationMinutes : defaultDurationMinutes // ignore: cast_nullable_to_non_nullable
as int,nextQuestAt: freezed == nextQuestAt ? _self.nextQuestAt : nextQuestAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$Party {

 String get id; String get sessionId; PartyStatus get status;@TimestampConverter() DateTime get activatedAt; String get activatedByUserId;@TimestampConverter() DateTime? get archivedAt; PartyModuleSettings get moduleSettings; PartyQuestSchedule get questSchedule; String? get activeQuestId; String? get activeChallengeId; String? get activeTournamentId; int get schemaVersion;@TimestampConverter() DateTime get createdAt;@TimestampConverter() DateTime get updatedAt;
/// Create a copy of Party
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PartyCopyWith<Party> get copyWith => _$PartyCopyWithImpl<Party>(this as Party, _$identity);

  /// Serializes this Party to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Party;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Party&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.sessionId, _this.sessionId) || other.sessionId == _this.sessionId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.activatedAt, _this.activatedAt) || other.activatedAt == _this.activatedAt)&&(identical(other.activatedByUserId, _this.activatedByUserId) || other.activatedByUserId == _this.activatedByUserId)&&(identical(other.archivedAt, _this.archivedAt) || other.archivedAt == _this.archivedAt)&&(identical(other.moduleSettings, _this.moduleSettings) || other.moduleSettings == _this.moduleSettings)&&(identical(other.questSchedule, _this.questSchedule) || other.questSchedule == _this.questSchedule)&&(identical(other.activeQuestId, _this.activeQuestId) || other.activeQuestId == _this.activeQuestId)&&(identical(other.activeChallengeId, _this.activeChallengeId) || other.activeChallengeId == _this.activeChallengeId)&&(identical(other.activeTournamentId, _this.activeTournamentId) || other.activeTournamentId == _this.activeTournamentId)&&(identical(other.schemaVersion, _this.schemaVersion) || other.schemaVersion == _this.schemaVersion)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Party;
  return Object.hash(runtimeType,_this.id,_this.sessionId,_this.status,_this.activatedAt,_this.activatedByUserId,_this.archivedAt,_this.moduleSettings,_this.questSchedule,_this.activeQuestId,_this.activeChallengeId,_this.activeTournamentId,_this.schemaVersion,_this.createdAt,_this.updatedAt);
}

@override
String toString() {
  final _this = this as Party;
  return 'Party(id: ${_this.id}, sessionId: ${_this.sessionId}, status: ${_this.status}, activatedAt: ${_this.activatedAt}, activatedByUserId: ${_this.activatedByUserId}, archivedAt: ${_this.archivedAt}, moduleSettings: ${_this.moduleSettings}, questSchedule: ${_this.questSchedule}, activeQuestId: ${_this.activeQuestId}, activeChallengeId: ${_this.activeChallengeId}, activeTournamentId: ${_this.activeTournamentId}, schemaVersion: ${_this.schemaVersion}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt})';
}


}

/// @nodoc
abstract mixin class $PartyCopyWith<$Res>  {
  factory $PartyCopyWith(Party value, $Res Function(Party) _then) = _$PartyCopyWithImpl;
@useResult
$Res call({
 String id, String sessionId, PartyStatus status,@TimestampConverter() DateTime activatedAt, String activatedByUserId,@TimestampConverter() DateTime? archivedAt, PartyModuleSettings moduleSettings, PartyQuestSchedule questSchedule, String? activeQuestId, String? activeChallengeId, String? activeTournamentId, int schemaVersion,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt
});


$PartyModuleSettingsCopyWith<$Res> get moduleSettings;$PartyQuestScheduleCopyWith<$Res> get questSchedule;

}
/// @nodoc
class _$PartyCopyWithImpl<$Res>
    implements $PartyCopyWith<$Res> {
  _$PartyCopyWithImpl(this._self, this._then);

  final Party _self;
  final $Res Function(Party) _then;

/// Create a copy of Party
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? status = null,Object? activatedAt = null,Object? activatedByUserId = null,Object? archivedAt = freezed,Object? moduleSettings = null,Object? questSchedule = null,Object? activeQuestId = freezed,Object? activeChallengeId = freezed,Object? activeTournamentId = freezed,Object? schemaVersion = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(Party(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PartyStatus,activatedAt: null == activatedAt ? _self.activatedAt : activatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,activatedByUserId: null == activatedByUserId ? _self.activatedByUserId : activatedByUserId // ignore: cast_nullable_to_non_nullable
as String,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,moduleSettings: null == moduleSettings ? _self.moduleSettings : moduleSettings // ignore: cast_nullable_to_non_nullable
as PartyModuleSettings,questSchedule: null == questSchedule ? _self.questSchedule : questSchedule // ignore: cast_nullable_to_non_nullable
as PartyQuestSchedule,activeQuestId: freezed == activeQuestId ? _self.activeQuestId : activeQuestId // ignore: cast_nullable_to_non_nullable
as String?,activeChallengeId: freezed == activeChallengeId ? _self.activeChallengeId : activeChallengeId // ignore: cast_nullable_to_non_nullable
as String?,activeTournamentId: freezed == activeTournamentId ? _self.activeTournamentId : activeTournamentId // ignore: cast_nullable_to_non_nullable
as String?,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of Party
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartyModuleSettingsCopyWith<$Res> get moduleSettings {
  
  return $PartyModuleSettingsCopyWith<$Res>(_self.moduleSettings, (value) {
    return _then(_self.copyWith(moduleSettings: value));
  });
}/// Create a copy of Party
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartyQuestScheduleCopyWith<$Res> get questSchedule {
  
  return $PartyQuestScheduleCopyWith<$Res>(_self.questSchedule, (value) {
    return _then(_self.copyWith(questSchedule: value));
  });
}
}


/// Adds pattern-matching-related methods to [Party].
extension PartyPatterns on Party {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Party value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Party() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Party value)  $default,){
final _that = this;
switch (_that) {
case _Party():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Party value)?  $default,){
final _that = this;
switch (_that) {
case _Party() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sessionId,  PartyStatus status, @TimestampConverter()  DateTime activatedAt,  String activatedByUserId, @TimestampConverter()  DateTime? archivedAt,  PartyModuleSettings moduleSettings,  PartyQuestSchedule questSchedule,  String? activeQuestId,  String? activeChallengeId,  String? activeTournamentId,  int schemaVersion, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Party() when $default != null:
return $default(_that.id,_that.sessionId,_that.status,_that.activatedAt,_that.activatedByUserId,_that.archivedAt,_that.moduleSettings,_that.questSchedule,_that.activeQuestId,_that.activeChallengeId,_that.activeTournamentId,_that.schemaVersion,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sessionId,  PartyStatus status, @TimestampConverter()  DateTime activatedAt,  String activatedByUserId, @TimestampConverter()  DateTime? archivedAt,  PartyModuleSettings moduleSettings,  PartyQuestSchedule questSchedule,  String? activeQuestId,  String? activeChallengeId,  String? activeTournamentId,  int schemaVersion, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Party():
return $default(_that.id,_that.sessionId,_that.status,_that.activatedAt,_that.activatedByUserId,_that.archivedAt,_that.moduleSettings,_that.questSchedule,_that.activeQuestId,_that.activeChallengeId,_that.activeTournamentId,_that.schemaVersion,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sessionId,  PartyStatus status, @TimestampConverter()  DateTime activatedAt,  String activatedByUserId, @TimestampConverter()  DateTime? archivedAt,  PartyModuleSettings moduleSettings,  PartyQuestSchedule questSchedule,  String? activeQuestId,  String? activeChallengeId,  String? activeTournamentId,  int schemaVersion, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Party() when $default != null:
return $default(_that.id,_that.sessionId,_that.status,_that.activatedAt,_that.activatedByUserId,_that.archivedAt,_that.moduleSettings,_that.questSchedule,_that.activeQuestId,_that.activeChallengeId,_that.activeTournamentId,_that.schemaVersion,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Party implements Party {
  const _Party({required this.id, required this.sessionId, required this.status, @TimestampConverter() required this.activatedAt, required this.activatedByUserId, @TimestampConverter() this.archivedAt, this.moduleSettings = const PartyModuleSettings(), this.questSchedule = const PartyQuestSchedule(), this.activeQuestId, this.activeChallengeId, this.activeTournamentId, this.schemaVersion = partySchemaVersion, @TimestampConverter() required this.createdAt, @TimestampConverter() required this.updatedAt});
  factory _Party.fromJson(Map<String, dynamic> json) => _$PartyFromJson(json);

@override final  String id;
@override final  String sessionId;
@override final  PartyStatus status;
@override@TimestampConverter() final  DateTime activatedAt;
@override final  String activatedByUserId;
@override@TimestampConverter() final  DateTime? archivedAt;
@override@JsonKey() final  PartyModuleSettings moduleSettings;
@override@JsonKey() final  PartyQuestSchedule questSchedule;
@override final  String? activeQuestId;
@override final  String? activeChallengeId;
@override final  String? activeTournamentId;
@override@JsonKey() final  int schemaVersion;
@override@TimestampConverter() final  DateTime createdAt;
@override@TimestampConverter() final  DateTime updatedAt;

/// Create a copy of Party
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PartyCopyWith<_Party> get copyWith => __$PartyCopyWithImpl<_Party>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PartyToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Party&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.status, status) || other.status == status)&&(identical(other.activatedAt, activatedAt) || other.activatedAt == activatedAt)&&(identical(other.activatedByUserId, activatedByUserId) || other.activatedByUserId == activatedByUserId)&&(identical(other.archivedAt, archivedAt) || other.archivedAt == archivedAt)&&(identical(other.moduleSettings, moduleSettings) || other.moduleSettings == moduleSettings)&&(identical(other.questSchedule, questSchedule) || other.questSchedule == questSchedule)&&(identical(other.activeQuestId, activeQuestId) || other.activeQuestId == activeQuestId)&&(identical(other.activeChallengeId, activeChallengeId) || other.activeChallengeId == activeChallengeId)&&(identical(other.activeTournamentId, activeTournamentId) || other.activeTournamentId == activeTournamentId)&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,sessionId,status,activatedAt,activatedByUserId,archivedAt,moduleSettings,questSchedule,activeQuestId,activeChallengeId,activeTournamentId,schemaVersion,createdAt,updatedAt);
}

@override
String toString() {
    return 'Party(id: $id, sessionId: $sessionId, status: $status, activatedAt: $activatedAt, activatedByUserId: $activatedByUserId, archivedAt: $archivedAt, moduleSettings: $moduleSettings, questSchedule: $questSchedule, activeQuestId: $activeQuestId, activeChallengeId: $activeChallengeId, activeTournamentId: $activeTournamentId, schemaVersion: $schemaVersion, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$PartyCopyWith<$Res> implements $PartyCopyWith<$Res> {
  factory _$PartyCopyWith(_Party value, $Res Function(_Party) _then) = __$PartyCopyWithImpl;
@override @useResult
$Res call({
 String id, String sessionId, PartyStatus status,@TimestampConverter() DateTime activatedAt, String activatedByUserId,@TimestampConverter() DateTime? archivedAt, PartyModuleSettings moduleSettings, PartyQuestSchedule questSchedule, String? activeQuestId, String? activeChallengeId, String? activeTournamentId, int schemaVersion,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt
});


@override $PartyModuleSettingsCopyWith<$Res> get moduleSettings;@override $PartyQuestScheduleCopyWith<$Res> get questSchedule;

}
/// @nodoc
class __$PartyCopyWithImpl<$Res>
    implements _$PartyCopyWith<$Res> {
  __$PartyCopyWithImpl(this._self, this._then);

  final _Party _self;
  final $Res Function(_Party) _then;

/// Create a copy of Party
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? status = null,Object? activatedAt = null,Object? activatedByUserId = null,Object? archivedAt = freezed,Object? moduleSettings = null,Object? questSchedule = null,Object? activeQuestId = freezed,Object? activeChallengeId = freezed,Object? activeTournamentId = freezed,Object? schemaVersion = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Party(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PartyStatus,activatedAt: null == activatedAt ? _self.activatedAt : activatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,activatedByUserId: null == activatedByUserId ? _self.activatedByUserId : activatedByUserId // ignore: cast_nullable_to_non_nullable
as String,archivedAt: freezed == archivedAt ? _self.archivedAt : archivedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,moduleSettings: null == moduleSettings ? _self.moduleSettings : moduleSettings // ignore: cast_nullable_to_non_nullable
as PartyModuleSettings,questSchedule: null == questSchedule ? _self.questSchedule : questSchedule // ignore: cast_nullable_to_non_nullable
as PartyQuestSchedule,activeQuestId: freezed == activeQuestId ? _self.activeQuestId : activeQuestId // ignore: cast_nullable_to_non_nullable
as String?,activeChallengeId: freezed == activeChallengeId ? _self.activeChallengeId : activeChallengeId // ignore: cast_nullable_to_non_nullable
as String?,activeTournamentId: freezed == activeTournamentId ? _self.activeTournamentId : activeTournamentId // ignore: cast_nullable_to_non_nullable
as String?,schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of Party
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartyModuleSettingsCopyWith<$Res> get moduleSettings {
  
  return $PartyModuleSettingsCopyWith<$Res>(_self.moduleSettings, (value) {
    return _then(_self.copyWith(moduleSettings: value));
  });
}/// Create a copy of Party
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PartyQuestScheduleCopyWith<$Res> get questSchedule {
  
  return $PartyQuestScheduleCopyWith<$Res>(_self.questSchedule, (value) {
    return _then(_self.copyWith(questSchedule: value));
  });
}
}

// dart format on
