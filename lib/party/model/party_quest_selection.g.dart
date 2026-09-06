// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party_quest_selection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PartyQuestSelection _$PartyQuestSelectionFromJson(Map<String, dynamic> json) =>
    _PartyQuestSelection(
      id: json['id'] as String,
      selectorUserId: json['selectorUserId'] as String,
      selectedUserId: json['selectedUserId'] as String,
      selectedAt: const TimestampConverter().fromJson(
        json['selectedAt'] as Timestamp,
      ),
    );

Map<String, dynamic> _$PartyQuestSelectionToJson(
  _PartyQuestSelection instance,
) => <String, dynamic>{
  'id': instance.id,
  'selectorUserId': instance.selectorUserId,
  'selectedUserId': instance.selectedUserId,
  'selectedAt': const TimestampConverter().toJson(instance.selectedAt),
};
