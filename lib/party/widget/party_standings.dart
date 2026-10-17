import 'package:flutter/material.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/widgets/party.dart';
import 'package:remembeer/party/constants.dart';

class PartyStandings extends StatelessWidget {
  const PartyStandings({super.key, required this.sessionId});
  final String sessionId;

  @override
  Widget build(BuildContext context) => PartyStandingsQuery(
    sessionId: SessionId(sessionId),
    builder: (context, result) => result.entries.isEmpty
        ? const Center(child: Text('No party members yet.'))
        : ListView(
            children: [
              for (final entry in result.entries)
                Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${entry.rank.toInt()}')),
                    title: Text(entry.user?.username ?? 'Unavailable user'),
                    subtitle: Text(
                      '${entry.drinkCount.toInt()} drinks · ${entry.completedQuestCount.toInt()} quests · ${entry.wonChallengeCount.toInt()} challenges',
                    ),
                    trailing: Text(formatPartyScore(entry.scoreUnits.toInt())),
                  ),
                ),
            ],
          ),
  );
}
