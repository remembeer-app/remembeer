import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/converter/timestamp_converter.dart';
import 'package:remembeer/common/model/document.dart';

part 'party_event.freezed.dart';
part 'party_event.g.dart';

enum PartyEventKind {
  drink,
  socialQuest,
  adminChallenge,
  beerpongPlacement,
  reversal,
}

enum PartyEventSourceCollection { drinks, quests, challenges, tournaments }

@freezed
abstract class PartyEvent with _$PartyEvent implements Document {
  const factory PartyEvent({
    required String id,
    required PartyEventKind kind,
    required String recipientUserId,
    required List<String> participantIds,
    required int pointsUnits,
    required PartyEventSourceCollection sourceCollection,
    required String sourceId,
    String? reversesEventId,
    String? actorUserId,
    @TimestampConverter() required DateTime occurredAt,
    @TimestampConverterOptimistic() required DateTime createdAt,
    @Default(<String, Object?>{}) Map<String, Object?> payload,
  }) = _PartyEvent;

  factory PartyEvent.fromJson(Map<String, dynamic> json) =>
      _$PartyEventFromJson(json);
}
