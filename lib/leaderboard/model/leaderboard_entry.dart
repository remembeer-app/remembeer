import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/user/model/user_model.dart';

part 'leaderboard_entry.freezed.dart';

// TODO(ohtenkay): This class could be typedef probably
@freezed
abstract class LeaderboardEntry with _$LeaderboardEntry {
  const factory LeaderboardEntry({
    required UserModel user,
    required double beersConsumed,
    required double alcoholConsumedMl,
    required int rankByBeers,
    required int rankByAlcohol,
  }) = _LeaderboardEntry;
}
