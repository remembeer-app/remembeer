import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/party/model/party_tab.dart';
import 'package:remembeer/party/widget/party_activity.dart';
import 'package:remembeer/party/widget/party_games.dart';
import 'package:remembeer/party/widget/party_scope.dart';
import 'package:remembeer/party/widget/party_standings.dart';
import 'package:remembeer/routes.dart';

class PartyPage extends StatelessWidget {
  const PartyPage({
    super.key,
    required this.sessionId,
    this.tab = PartyTab.activity,
  });
  final String sessionId;
  final PartyTab tab;

  @override
  Widget build(BuildContext context) => PartyScope(
    sessionId: sessionId,
    builder: (context, party, userId, members, isAdmin) => DefaultTabController(
      initialIndex: tab.index,
      length: PartyTab.values.length,
      child: PageTemplate(
        title: Text(party.name),
        actions: [
          if (isAdmin && party.endedAt == null)
            IconButton(
              tooltip: 'Manage party',
              icon: const Icon(Icons.settings),
              onPressed: () => PartyManagementRoute(
                sessionId: sessionId,
                tab: tab,
              ).push<void>(context),
            ),
        ],
        child: Column(
          children: [
            if (party.endedAt != null)
              const ListTile(
                leading: Icon(Icons.archive_outlined),
                title: Text('Archived party'),
                subtitle: Text('Gameplay is read-only.'),
              ),
            const TabBar(
              tabs: [
                Tab(text: 'Ranking'),
                Tab(text: 'Activity'),
                Tab(text: 'Games'),
              ],
            ),
            const Gap(12),
            Expanded(
              child: TabBarView(
                children: [
                  PartyStandings(sessionId: sessionId),
                  PartyActivity(sessionId: sessionId),
                  PartyGames(
                    party: party,
                    userId: userId,
                    member: members
                        .map((entry) => entry.member)
                        .whereType<PartyMember>()
                        .where((member) => member.userId == userId)
                        .firstOrNull,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
