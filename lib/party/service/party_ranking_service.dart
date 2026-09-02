import 'package:flutter/foundation.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/user/model/user_model.dart';

@immutable
class PartyStanding {
  const PartyStanding({
    required this.rank,
    required this.member,
    required this.username,
    required this.isCurrentUser,
    this.user,
  });

  final int rank;
  final PartyMember member;
  final UserModel? user;
  final String username;
  final bool isCurrentUser;
}

class PartyRankingService {
  const PartyRankingService();

  List<PartyStanding> rank({
    required List<PartyMember> members,
    required List<UserModel> users,
    required String currentUserId,
  }) {
    final usersById = {for (final user in users) user.id: user};
    final sorted = [...members]
      ..sort((a, b) {
        final scoreComparison = b.scoreUnits.compareTo(a.scoreUnits);
        if (scoreComparison != 0) {
          return scoreComparison;
        }
        final aName = usersById[a.userId]?.username ?? a.userId;
        final bName = usersById[b.userId]?.username ?? b.userId;
        final nameComparison = aName.toLowerCase().compareTo(
          bName.toLowerCase(),
        );
        if (nameComparison != 0) {
          return nameComparison;
        }
        final exactNameComparison = aName.compareTo(bName);
        return exactNameComparison != 0
            ? exactNameComparison
            : a.userId.compareTo(b.userId);
      });

    final standings = <PartyStanding>[];
    for (var index = 0; index < sorted.length; index++) {
      final member = sorted[index];
      final sharesRank =
          index > 0 && sorted[index - 1].scoreUnits == member.scoreUnits;
      standings.add(
        PartyStanding(
          rank: sharesRank ? standings.last.rank : index + 1,
          member: member,
          user: usersById[member.userId],
          username: usersById[member.userId]?.username ?? 'Former member',
          isCurrentUser: member.userId == currentUserId,
        ),
      );
    }
    return List.unmodifiable(standings);
  }
}
