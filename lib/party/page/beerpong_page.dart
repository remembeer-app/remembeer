import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/beerpongTournament.dart';
import 'package:remembeer/convex_api/widgets/beerpongMatch.dart';
import 'package:remembeer/convex_api/widgets/beerpongTournament.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/widget/party_scope.dart';
import 'package:remembeer/party/widget/team_editor.dart';

class BeerpongPage extends StatelessWidget {
  const BeerpongPage({
    super.key,
    required this.sessionId,
    required this.tournamentId,
  });
  final String sessionId;
  final String tournamentId;

  @override
  Widget build(BuildContext context) => PageTemplate(
    title: const Text('Beerpong'),
    child: PartyScope(
      sessionId: sessionId,
      builder: (context, party, userId, members, isAdmin) => BeerpongTournamentGetTypeQuery(
        id: BeerpongTournamentId(tournamentId),
        builder: (context, detail) {
          final tournament = detail.tournament;
          if (tournament.sessionId != party.id) {
            return const Center(
              child: Text('Tournament not found in this party.'),
            );
          }
          final canManage =
              isAdmin && party.endedAt == null && party.modules.beerpongEnabled;
          final enrollment =
              tournament.status ==
              BeerpongTournamentDocumentStatus.enrollmentValue;
          final setup =
              tournament.status == BeerpongTournamentDocumentStatus.setupValue;
          final active =
              tournament.status == BeerpongTournamentDocumentStatus.activeValue;
          String teamName(BeerpongTeamId? id) =>
              detail.teams.where((team) => team.id == id).firstOrNull?.name ??
              'Pending opponent';
          return ListView(
            children: [
              Text(
                tournament.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Gap(8),
              Text(
                '${tournament.status.value} · ${tournament.teamCount.toInt()} teams',
              ),
              Text(
                'Team prizes: ${formatPartyScore(tournament.firstPlacePointsUnits.toInt())} / ${formatPartyScore(tournament.secondPlacePointsUnits.toInt())} / ${formatPartyScore(tournament.thirdPlacePointsUnits.toInt())}',
              ),
              if (enrollment) ...[
                const Gap(16),
                Text(
                  '${members.where((entry) => entry.member is PartyMember && (entry.member as PartyMember).beerpongOptIn && entry.member.sessionMemberStatus.isJoined).length} players opted in',
                ),
                const Text('Players can opt in from the party Games tab.'),
                if (canManage)
                  BeerpongTournamentDrawMutation(
                    builder: (context, draw, state) => Column(
                      children: [
                        FilledButton(
                          onPressed: state.isLoading
                              ? null
                              : () => draw.run(id: tournament.id),
                          child: const Text('Draw teams'),
                        ),
                        if (state.error case final error?)
                          ErrorMessageBox(message: error.toString()),
                      ],
                    ),
                  ),
              ],
              if (setup) ...[
                const Gap(16),
                const Text('Review the teams before starting the bracket.'),
                if (canManage)
                  BeerpongTournamentStartMutation(
                    builder: (context, start, state) => Column(
                      children: [
                        FilledButton(
                          onPressed: state.isLoading
                              ? null
                              : () => start.run(id: tournament.id),
                          child: const Text('Start tournament'),
                        ),
                        if (state.error case final error?)
                          ErrorMessageBox(message: error.toString()),
                      ],
                    ),
                  ),
              ],
              const Gap(24),
              Text('Teams', style: Theme.of(context).textTheme.titleLarge),
              for (final team in detail.teams)
                TeamEditor(
                  team: team,
                  teams: detail.teams,
                  members: members,
                  canEdit: canManage && (setup || active),
                  placement: detail.placements
                      .where((placement) => placement.teamId == team.id)
                      .firstOrNull
                      ?.placement
                      .toInt(),
                ),
              const Gap(24),
              for (final round
                  in detail.matches.map((match) => match.round).toSet().toList()
                    ..sort()) ...[
                Text(
                  'Round ${round.toInt()}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                for (final match in detail.matches.where(
                  (match) => match.round == round,
                ))
                  _MatchCard(
                    match: match,
                    teamName: teamName,
                    canEdit: canManage && active,
                  ),
                const Gap(16),
              ],
              if (canManage &&
                  active &&
                  detail.matches.isNotEmpty &&
                  detail.matches.every((match) => match.winnerTeamId != null))
                BeerpongTournamentFinalizeMutation(
                  builder: (context, finalize, state) => Column(
                    children: [
                      FilledButton(
                        onPressed: state.isLoading
                            ? null
                            : () => showConfirmationDialog(
                                context: context,
                                title: 'Finalize tournament?',
                                text:
                                    'Placements will award points and teams and results will be locked.',
                                submitButtonText: 'Finalize',
                                onPressed: () async {
                                  await finalize(id: tournament.id);
                                },
                              ),
                        child: const Text('Finalize and award points'),
                      ),
                      if (state.error case final error?)
                        ErrorMessageBox(message: error.toString()),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    ),
  );
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({
    required this.match,
    required this.teamName,
    required this.canEdit,
  });
  final GetTypeResultMatchesItem match;
  final String Function(BeerpongTeamId?) teamName;
  final bool canEdit;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            match.kind == GetTypeResultMatchesItemKind.thirdPlaceValue
                ? 'Third place'
                : 'Match ${match.position.toInt()}',
          ),
          Text('${teamName(match.teamAId)} vs ${teamName(match.teamBId)}'),
          Text(match.status.value! as String),
          if (match.winnerTeamId != null)
            Text('Winner: ${teamName(match.winnerTeamId)}'),
          if (canEdit && match.teamAId != null && match.teamBId != null)
            BeerpongMatchRecordResultMutation(
              builder: (context, record, recordState) =>
                  BeerpongMatchCorrectResultMutation(
                    builder: (context, correct, correctState) => Column(
                      children: [
                        if (recordState.error ?? correctState.error
                            case final error?)
                          ErrorMessageBox(message: error.toString()),
                        for (final id in [match.teamAId!, match.teamBId!])
                          TextButton(
                            onPressed:
                                recordState.isLoading ||
                                    correctState.isLoading ||
                                    match.winnerTeamId == id
                                ? null
                                : () {
                                    if (match.winnerTeamId == null) {
                                      record.run(
                                        id: match.id,
                                        winnerTeamId: id,
                                      );
                                    } else {
                                      showConfirmationDialog(
                                        context: context,
                                        title: 'Correct match winner?',
                                        text:
                                            'Dependent results will be cleared.',
                                        submitButtonText: 'Correct winner',
                                        isDestructive: true,
                                        onPressed: () async {
                                          await correct(
                                            id: match.id,
                                            winnerTeamId: id,
                                          );
                                        },
                                      );
                                    }
                                  },
                            child: Text(
                              '${match.winnerTeamId == null ? 'Winner' : 'Correct to'}: ${teamName(id)}',
                            ),
                          ),
                      ],
                    ),
                  ),
            ),
        ],
      ),
    ),
  );
}
