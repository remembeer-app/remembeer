import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/common/model/document.dart';

part 'beerpong_match.freezed.dart';
part 'beerpong_match.g.dart';

enum BeerpongMatchKind { main, thirdPlace }

enum BeerpongMatchStatus { pending, ready, completed, bye }

enum BeerpongMatchSlot { a, b }

@freezed
abstract class BeerpongMatch with _$BeerpongMatch implements Document {
  const factory BeerpongMatch({
    required String id,
    required int round,
    required int position,
    required BeerpongMatchKind kind,
    String? teamAId,
    String? teamBId,
    String? winnerTeamId,
    String? loserTeamId,
    required BeerpongMatchStatus status,
    String? nextMatchId,
    BeerpongMatchSlot? nextSlot,
  }) = _BeerpongMatch;

  factory BeerpongMatch.fromJson(Map<String, dynamic> json) =>
      _$BeerpongMatchFromJson(json);
}
