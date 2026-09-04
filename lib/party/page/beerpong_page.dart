import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/party/model/beerpong_match.dart';
import 'package:remembeer/party/model/beerpong_team.dart';
import 'package:remembeer/party/model/beerpong_tournament.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/service/beerpong_service.dart';
import 'package:remembeer/party/service/party_service.dart';
import 'package:remembeer/party/widget/beerpong_bracket.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/user/model/user_model.dart';

class BeerpongPage extends StatefulWidget {
  BeerpongPage({
    super.key,
    required this.sessionId,
    required this.tournamentId,
    PartyService? partyService,
    SessionService? sessionService,
    BeerpongService? beerpongService,
  }) : partyService = partyService ?? get<PartyService>(),
       sessionService = sessionService ?? get<SessionService>(),
       beerpongService = beerpongService ?? get<BeerpongService>();

  final String sessionId;
  final String tournamentId;
  final PartyService partyService;
  final SessionService sessionService;
  final BeerpongService beerpongService;

  @override
  State<BeerpongPage> createState() => _BeerpongPageState();
}

class _BeerpongPageState extends State<BeerpongPage> {
  String? _pendingAction;

  @override
  Widget build(BuildContext context) => PageTemplate(
    title: const Text('Beerpong'),
    child: AsyncBuilder<PartyState>(
      stream: widget.partyService.stateStream(widget.sessionId),
      builder: (context, partyState) => AsyncBuilder<BeerpongDetailState>(
        stream: widget.beerpongService.detailStateStream(
          widget.sessionId,
          widget.tournamentId,
        ),
        builder: (context, detail) {
          final tournament = detail.tournament;
          if (tournament == null) {
            return const Center(child: Text('Tournament not found.'));
          }
          return AsyncBuilder<List<UserModel>>(
            stream: widget.sessionService.sessionMembersStream(
              widget.sessionId,
            ),
            builder: (context, members) =>
                _buildContent(context, partyState, detail, tournament, members),
          );
        },
      ),
    ),
  );

  Widget _buildContent(
    BuildContext context,
    PartyState partyState,
    BeerpongDetailState detail,
    BeerpongTournament tournament,
    List<UserModel> members,
  ) {
    final isReadOnly =
        partyState.isArchived ||
        tournament.status == BeerpongTournamentStatus.completed ||
        tournament.status == BeerpongTournamentStatus.cancelled;
    final canManageResults =
        partyState.isAdmin &&
        partyState.isActive &&
        _pendingAction == null &&
        tournament.status == BeerpongTournamentStatus.active;
    final currentTeam = detail.teams
        .where(
          (team) => team.memberIds.contains(partyState.currentMember?.userId),
        )
        .firstOrNull;
    return ListView(
      children: [
        _TournamentHeader(
          tournament: tournament,
          currentTeam: currentTeam,
          isArchived: partyState.isArchived,
        ),
        const Gap(20),
        if (tournament.status == BeerpongTournamentStatus.enrollment)
          const Card(
            child: ListTile(
              leading: Icon(Icons.how_to_reg_outlined),
              title: Text('Enrollment is open'),
              subtitle: Text(
                'Opt in from the Games tab. An admin will draw teams when the roster is ready.',
              ),
            ),
          )
        else ...[
          Text('Teams', style: Theme.of(context).textTheme.titleLarge),
          const Gap(8),
          _TeamsOverview(
            teams: detail.teams,
            members: members,
            currentUserId: partyState.currentMember?.userId ?? '',
          ),
          const Gap(20),
          Text('Bracket', style: Theme.of(context).textTheme.titleLarge),
          const Gap(4),
          Text(
            MediaQuery.sizeOf(context).width < 700
                ? 'Swipe horizontally to see every round.'
                : 'Every round is shown side by side.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const Gap(8),
          BeerpongBracket(
            teams: detail.teams,
            matches: detail.matches,
            members: members,
            currentUserId: partyState.currentMember?.userId ?? '',
            onRecordResult: canManageResults
                ? (match, teamId) => _confirmResult(
                    context,
                    tournament,
                    match,
                    teamId,
                    detail.teams,
                  )
                : null,
            onCorrectResult: canManageResults
                ? (match, teamId) => _confirmCorrection(
                    context,
                    tournament,
                    match,
                    teamId,
                    detail.teams,
                  )
                : null,
          ),
          if (canManageResults && _canFinalize(detail.matches)) ...[
            const Gap(20),
            FilledButton.icon(
              onPressed: _pendingAction == null
                  ? () => _confirmFinalize(context, tournament)
                  : null,
              icon: const Icon(Icons.emoji_events_outlined),
              label: const Text('Finalize tournament and award points'),
            ),
          ],
        ],
        if (isReadOnly) ...[
          const Gap(20),
          Card(
            child: ListTile(
              leading: Icon(
                partyState.isArchived
                    ? Icons.archive_outlined
                    : Icons.lock_outline,
              ),
              title: Text(
                partyState.isArchived
                    ? 'Archived Party'
                    : 'Tournament finalized',
              ),
              subtitle: const Text('Teams and results are read-only.'),
            ),
          ),
        ],
      ],
    );
  }

  void _confirmResult(
    BuildContext context,
    BeerpongTournament tournament,
    BeerpongMatch match,
    String winnerTeamId,
    List<BeerpongTeam> teams,
  ) {
    final teamName = _teamName(teams, winnerTeamId);
    showConfirmationDialog(
      context: context,
      title: 'Record $teamName as winner?',
      text: 'This result advances the bracket.',
      submitButtonText: 'Record winner',
      onPressed: () => _runAction(
        'result:${match.id}',
        () => widget.beerpongService.recordResult(
          sessionId: widget.sessionId,
          tournamentId: tournament.id,
          expectedRevision: tournament.revision,
          matchId: match.id,
          winnerTeamId: winnerTeamId,
        ),
        'Match result recorded.',
      ),
    );
  }

  void _confirmCorrection(
    BuildContext context,
    BeerpongTournament tournament,
    BeerpongMatch match,
    String winnerTeamId,
    List<BeerpongTeam> teams,
  ) {
    final teamName = _teamName(teams, winnerTeamId);
    showConfirmationDialog(
      context: context,
      title: 'Correct winner to $teamName?',
      text:
          'Dependent match results will be cleared and must be entered again.',
      submitButtonText: 'Correct result',
      isDestructive: true,
      onPressed: () => _runAction(
        'correct:${match.id}',
        () => widget.beerpongService.correctResult(
          sessionId: widget.sessionId,
          tournamentId: tournament.id,
          expectedRevision: tournament.revision,
          matchId: match.id,
          winnerTeamId: winnerTeamId,
        ),
        'Match result corrected.',
      ),
    );
  }

  void _confirmFinalize(BuildContext context, BeerpongTournament tournament) {
    showConfirmationDialog(
      context: context,
      title: 'Finalize tournament?',
      text:
          'Placements will be locked and points awarded to every team member.',
      submitButtonText: 'Finalize and award',
      onPressed: () => _runAction(
        'finalize',
        () => widget.beerpongService.finalizeTournament(
          sessionId: widget.sessionId,
          tournamentId: tournament.id,
          expectedRevision: tournament.revision,
        ),
        'Tournament finalized.',
      ),
    );
  }

  Future<void> _runAction(
    String key,
    Future<void> Function() action,
    String message,
  ) async {
    setState(() => _pendingAction = key);
    try {
      await action();
      showSuccessNotification(message);
    } on Exception catch (error) {
      showErrorNotification(error.toString());
    } finally {
      if (mounted) setState(() => _pendingAction = null);
    }
  }
}

class _TournamentHeader extends StatelessWidget {
  const _TournamentHeader({
    required this.tournament,
    required this.currentTeam,
    required this.isArchived,
  });

  final BeerpongTournament tournament;
  final BeerpongTeam? currentTeam;
  final bool isArchived;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sports_bar, size: 36),
              const Gap(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Beerpong tournament',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      isArchived
                          ? 'Archived'
                          : switch (tournament.status) {
                              BeerpongTournamentStatus.enrollment =>
                                'Enrollment open',
                              BeerpongTournamentStatus.active => 'In progress',
                              BeerpongTournamentStatus.completed => 'Finalized',
                              BeerpongTournamentStatus.cancelled => 'Cancelled',
                            },
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (currentTeam != null) ...[
            const Gap(12),
            Row(
              children: [
                const Icon(Icons.person),
                const Gap(8),
                Expanded(child: Text('Your team: ${currentTeam!.name}')),
              ],
            ),
          ],
        ],
      ),
    ),
  );
}

class _TeamsOverview extends StatelessWidget {
  const _TeamsOverview({
    required this.teams,
    required this.members,
    required this.currentUserId,
  });

  final List<BeerpongTeam> teams;
  final List<UserModel> members;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    final membersById = {for (final member in members) member.id: member};
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final team in teams)
          Chip(
            avatar: Icon(
              team.memberIds.contains(currentUserId)
                  ? Icons.person
                  : team.placement == 1
                  ? Icons.emoji_events
                  : Icons.groups_outlined,
            ),
            label: Text(
              '${team.name}${team.placement == null ? '' : ' · #${team.placement}'}\n'
              '${team.memberIds.map((id) => membersById[id]?.username ?? 'Unknown').join(', ')}',
            ),
          ),
      ],
    );
  }
}

bool _canFinalize(List<BeerpongMatch> matches) =>
    matches.isNotEmpty &&
    matches.every(
      (match) =>
          match.status == BeerpongMatchStatus.completed ||
          match.status == BeerpongMatchStatus.bye,
    );

String _teamName(List<BeerpongTeam> teams, String teamId) =>
    teams.where((team) => team.id == teamId).firstOrNull?.name ?? 'this team';
