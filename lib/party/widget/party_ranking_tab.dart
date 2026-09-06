import 'package:flutter/material.dart';
import 'package:remembeer/party/widget/party_ranking.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/user/model/user_model.dart';

class PartyRankingTab extends StatelessWidget {
  const PartyRankingTab({
    super.key,
    required this.session,
    required this.members,
  });

  final Session session;
  final List<UserModel> members;

  @override
  Widget build(BuildContext context) {
    return PartyRanking(session: session, members: members);
  }
}
