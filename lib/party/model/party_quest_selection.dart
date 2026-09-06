import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/converter/timestamp_converter.dart';
import 'package:remembeer/common/model/document.dart';

part 'party_quest_selection.freezed.dart';
part 'party_quest_selection.g.dart';

@freezed
abstract class PartyQuestSelection
    with _$PartyQuestSelection
    implements Document {
  const factory PartyQuestSelection({
    required String id,
    required String selectorUserId,
    required String selectedUserId,
    @TimestampConverter() required DateTime selectedAt,
  }) = _PartyQuestSelection;

  factory PartyQuestSelection.fromJson(Map<String, dynamic> json) =>
      _$PartyQuestSelectionFromJson(json);
}
