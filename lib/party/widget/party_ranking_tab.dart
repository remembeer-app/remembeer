import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/party/service/party_ranking_service.dart';
import 'package:remembeer/party/service/party_service.dart';
import 'package:remembeer/party/widget/party_ranking.dart';
import 'package:remembeer/user/model/user_model.dart';

class PartyRankingTab extends StatelessWidget {
  const PartyRankingTab({
    super.key,
    required this.sessionId,
    required this.members,
    required this.currentUserId,
    required this.partyService,
    this.rankingService = const PartyRankingService(),
  });

  final String sessionId;
  final List<UserModel> members;
  final String currentUserId;
  final PartyService partyService;
  final PartyRankingService rankingService;

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<List<PartyMember>>(
      stream: partyService.membersStream(sessionId),
      builder: (context, partyMembers) => PartyRanking(
        standings: rankingService.rank(
          members: partyMembers,
          users: members,
          currentUserId: currentUserId,
        ),
      ),
    );
  }
}
