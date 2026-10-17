import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/widgets/beerpongTournament.dart';
import 'package:remembeer/convex_api/widgets/partyChallenge.dart';
import 'package:remembeer/convex_api/widgets/partyQuest.dart';
import 'package:remembeer/convex_api/widgets/sessionMember.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/widget/party_class_selector.dart';
import 'package:remembeer/routes.dart';

class PartyGames extends StatelessWidget {
  const PartyGames({
    super.key,
    required this.party,
    required this.userId,
    required this.member,
  });
  final Party party;
  final UserId userId;
  final PartyMember? member;

  @override
  Widget build(BuildContext context) => ListView(
    children: [
      if (party.endedAt == null)
        FilledButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add drink'),
          onPressed: () => AddDrinkLogRoute(
            targetSessionId: party.id.value,
          ).push<void>(context),
        ),
      if (party.endedAt == null &&
          member != null &&
          member!.selectedClass == null)
        SessionMemberSetClassMutation(
          builder: (context, setClass, state) => Column(
            children: [
              PartyClassSelector(
                selectedClass: member!.selectedClass,
                onSubmit: (category) => setClass(
                  sessionId: party.id,
                  userId: userId,
                  selectedClass: category,
                ),
              ),
              if (state.error case final error?)
                ErrorMessageBox(message: error.toString()),
            ],
          ),
        ),
      const Gap(16),
      if (party.modules.beerpongEnabled && member != null)
        SessionMemberSetBeerpongOptInMutation(
          builder: (context, optIn, state) => Column(
            children: [
              SwitchListTile(
                title: const Text('Join beerpong draws'),
                value: member!.beerpongOptIn,
                onChanged: party.endedAt != null || state.isLoading
                    ? null
                    : (value) => optIn.run(sessionId: party.id, optedIn: value),
              ),
              if (state.error case final error?)
                ErrorMessageBox(message: error.toString()),
            ],
          ),
        ),
      Text('Social quests', style: Theme.of(context).textTheme.titleLarge),
      if (!party.modules.socialQuestsEnabled && party.endedAt == null)
        const Text('Social quests are disabled.'),
      PartyQuestListForSessionQuery(
        sessionId: party.id,
        builder: (context, quests) => Column(
          children: [
            if (quests.isEmpty) const ListTile(title: Text('No quests yet.')),
            for (final quest in quests)
              Card(
                child: ListTile(
                  title: Text(quest.title),
                  subtitle: Text(
                    '${quest.status.value} · Ends ${partyTime(quest.endsAt)}',
                  ),
                  trailing: Text(formatPartyScore(quest.pointsUnits.toInt())),
                  onTap: () => PartyQuestRoute(
                    sessionId: party.id.value,
                    questId: quest.id.value,
                  ).push<void>(context),
                ),
              ),
          ],
        ),
      ),
      const Gap(16),
      Text('Challenges', style: Theme.of(context).textTheme.titleLarge),
      PartyChallengeListForSessionQuery(
        sessionId: party.id,
        builder: (context, challenges) => Column(
          children: [
            if (challenges.isEmpty)
              const ListTile(title: Text('No challenges yet.')),
            for (final challenge in challenges)
              Card(
                child: ListTile(
                  title: Text(challenge.title),
                  subtitle: Text(
                    '${challenge.status.value} · ${challenge.winners.length} winners',
                  ),
                  trailing: Text(
                    formatPartyScore(challenge.pointsUnits.toInt()),
                  ),
                  onTap: () => PartyChallengeRoute(
                    sessionId: party.id.value,
                    challengeId: challenge.id.value,
                  ).push<void>(context),
                ),
              ),
          ],
        ),
      ),
      const Gap(16),
      Text('Beerpong', style: Theme.of(context).textTheme.titleLarge),
      BeerpongTournamentListForSessionQuery(
        sessionId: party.id,
        builder: (context, tournaments) => Column(
          children: [
            if (tournaments.isEmpty)
              const ListTile(title: Text('No tournaments yet.')),
            for (final tournament in tournaments)
              Card(
                child: ListTile(
                  title: Text(tournament.name),
                  subtitle: Text(
                    '${tournament.status.value} · ${tournament.teamCount.toInt()} teams',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => PartyTournamentRoute(
                    sessionId: party.id.value,
                    tournamentId: tournament.id.value,
                  ).push<void>(context),
                ),
              ),
          ],
        ),
      ),
    ],
  );
}

String partyTime(double timestamp) => DateFormat.yMMMd().add_Hm().format(
  DateTime.fromMillisecondsSinceEpoch(timestamp.toInt()),
);
