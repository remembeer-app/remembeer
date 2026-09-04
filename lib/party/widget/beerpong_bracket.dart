import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/model/beerpong_match.dart';
import 'package:remembeer/party/model/beerpong_team.dart';
import 'package:remembeer/user/model/user_model.dart';

typedef BeerpongResultCallback =
    void Function(BeerpongMatch match, String winnerTeamId);

class BeerpongBracket extends StatelessWidget {
  const BeerpongBracket({
    super.key,
    required this.teams,
    required this.matches,
    required this.members,
    required this.currentUserId,
    this.onRecordResult,
    this.onCorrectResult,
  });

  final List<BeerpongTeam> teams;
  final List<BeerpongMatch> matches;
  final List<UserModel> members;
  final String currentUserId;
  final BeerpongResultCallback? onRecordResult;
  final BeerpongResultCallback? onCorrectResult;

  @override
  Widget build(BuildContext context) {
    if (matches.isEmpty) {
      return const Card(
        child: ListTile(
          leading: Icon(Icons.account_tree_outlined),
          title: Text('Bracket not drawn'),
          subtitle: Text('Matches appear after enrollment is locked.'),
        ),
      );
    }
    final teamsById = {for (final team in teams) team.id: team};
    final membersById = {for (final member in members) member.id: member};
    final mainMatches = matches
        .where((match) => match.kind == BeerpongMatchKind.main)
        .toList();
    final finalRound = mainMatches
        .map((match) => match.round)
        .reduce((left, right) => left > right ? left : right);
    final rounds = <_BracketRound>[
      for (var round = 1; round <= finalRound; round++)
        _BracketRound(
          title: _roundTitle(round, finalRound),
          matches: mainMatches.where((match) => match.round == round).toList(),
        ),
      if (matches.any((match) => match.kind == BeerpongMatchKind.thirdPlace))
        _BracketRound(
          title: 'Third place',
          matches: matches
              .where((match) => match.kind == BeerpongMatchKind.thirdPlace)
              .toList(),
        ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = [
          for (final round in rounds)
            _RoundColumn(
              round: round,
              teamsById: teamsById,
              membersById: membersById,
              currentUserId: currentUserId,
              onRecordResult: onRecordResult,
              onCorrectResult: onCorrectResult,
            ),
        ];
        final minimumWideWidth = rounds.length * 220;
        if (constraints.maxWidth < beerpongWideBracketBreakpoint ||
            constraints.maxWidth < minimumWideWidth) {
          return Semantics(
            label: 'Tournament bracket. Swipe horizontally to view rounds.',
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (var index = 0; index < columns.length; index++) ...[
                    SizedBox(
                      width: beerpongBracketColumnWidth,
                      child: columns[index],
                    ),
                    if (index < columns.length - 1) const Gap(12),
                  ],
                ],
              ),
            ),
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < columns.length; index++) ...[
              Expanded(child: columns[index]),
              if (index < columns.length - 1) const Gap(12),
            ],
          ],
        );
      },
    );
  }
}

class _BracketRound {
  const _BracketRound({required this.title, required this.matches});

  final String title;
  final List<BeerpongMatch> matches;
}

class _RoundColumn extends StatelessWidget {
  const _RoundColumn({
    required this.round,
    required this.teamsById,
    required this.membersById,
    required this.currentUserId,
    required this.onRecordResult,
    required this.onCorrectResult,
  });

  final _BracketRound round;
  final Map<String, BeerpongTeam> teamsById;
  final Map<String, UserModel> membersById;
  final String currentUserId;
  final BeerpongResultCallback? onRecordResult;
  final BeerpongResultCallback? onCorrectResult;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        round.title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const Gap(8),
      for (var index = 0; index < round.matches.length; index++) ...[
        _MatchCard(
          match: round.matches[index],
          teamsById: teamsById,
          membersById: membersById,
          currentUserId: currentUserId,
          onRecordResult: onRecordResult,
          onCorrectResult: onCorrectResult,
        ),
        if (index < round.matches.length - 1) const Gap(12),
      ],
    ],
  );
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({
    required this.match,
    required this.teamsById,
    required this.membersById,
    required this.currentUserId,
    required this.onRecordResult,
    required this.onCorrectResult,
  });

  final BeerpongMatch match;
  final Map<String, BeerpongTeam> teamsById;
  final Map<String, UserModel> membersById;
  final String currentUserId;
  final BeerpongResultCallback? onRecordResult;
  final BeerpongResultCallback? onCorrectResult;

  @override
  Widget build(BuildContext context) {
    final teamA = teamsById[match.teamAId];
    final teamB = teamsById[match.teamBId];
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Match ${match.position}',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
                _StatusChip(status: match.status),
              ],
            ),
            const Gap(10),
            _TeamSlot(
              team: teamA,
              membersById: membersById,
              currentUserId: currentUserId,
              isWinner: teamA?.id == match.winnerTeamId,
              onSelect:
                  match.status == BeerpongMatchStatus.ready &&
                      onRecordResult != null &&
                      teamA != null
                  ? () => onRecordResult!(match, teamA.id)
                  : null,
              correction:
                  match.status == BeerpongMatchStatus.completed &&
                      onCorrectResult != null &&
                      teamA != null &&
                      teamA.id != match.winnerTeamId
                  ? () => onCorrectResult!(match, teamA.id)
                  : null,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Text('vs', textAlign: TextAlign.center),
            ),
            _TeamSlot(
              team: teamB,
              membersById: membersById,
              currentUserId: currentUserId,
              isWinner: teamB?.id == match.winnerTeamId,
              onSelect:
                  match.status == BeerpongMatchStatus.ready &&
                      onRecordResult != null &&
                      teamB != null
                  ? () => onRecordResult!(match, teamB.id)
                  : null,
              correction:
                  match.status == BeerpongMatchStatus.completed &&
                      onCorrectResult != null &&
                      teamB != null &&
                      teamB.id != match.winnerTeamId
                  ? () => onCorrectResult!(match, teamB.id)
                  : null,
            ),
            if (match.status == BeerpongMatchStatus.pending) ...[
              const Gap(8),
              const Text(
                'Waiting for previous match',
                textAlign: TextAlign.center,
              ),
            ],
            if (match.status == BeerpongMatchStatus.bye) ...[
              const Gap(8),
              const Text(
                'Bye: advances automatically',
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TeamSlot extends StatelessWidget {
  const _TeamSlot({
    required this.team,
    required this.membersById,
    required this.currentUserId,
    required this.isWinner,
    required this.onSelect,
    required this.correction,
  });

  final BeerpongTeam? team;
  final Map<String, UserModel> membersById;
  final String currentUserId;
  final bool isWinner;
  final VoidCallback? onSelect;
  final VoidCallback? correction;

  @override
  Widget build(BuildContext context) {
    final value = team;
    if (value == null) {
      return DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Padding(
          padding: EdgeInsets.all(12),
          child: Text('TBD', textAlign: TextAlign.center),
        ),
      );
    }
    final isCurrent = value.memberIds.contains(currentUserId);
    final memberNames = value.memberIds
        .map((id) => membersById[id]?.username ?? 'Unknown member')
        .join(', ');
    final colorScheme = Theme.of(context).colorScheme;
    final child = Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isCurrent) ...[
                const Icon(Icons.person, size: 18),
                const Gap(4),
              ],
              Expanded(
                child: Text(
                  value.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              if (isWinner) ...[
                const Gap(4),
                const Icon(Icons.emoji_events, size: 18),
              ],
            ],
          ),
          if (isCurrent) const Text('Your team'),
          if (isWinner) const Text('Winner'),
          Text(memberNames, maxLines: 2, overflow: TextOverflow.ellipsis),
          if (correction != null)
            TextButton(
              onPressed: correction,
              child: const Text('Correct to this team'),
            ),
        ],
      ),
    );
    return Material(
      color: isCurrent
          ? colorScheme.primaryContainer
          : isWinner
          ? colorScheme.tertiaryContainer
          : colorScheme.surfaceContainerHighest,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isCurrent ? colorScheme.primary : colorScheme.outlineVariant,
          width: isCurrent ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: onSelect == null ? child : InkWell(onTap: onSelect, child: child),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final BeerpongMatchStatus status;

  @override
  Widget build(BuildContext context) => Chip(
    visualDensity: VisualDensity.compact,
    avatar: Icon(_statusIcon(status), size: 16),
    label: Text(switch (status) {
      BeerpongMatchStatus.pending => 'Pending',
      BeerpongMatchStatus.ready => 'Ready',
      BeerpongMatchStatus.completed => 'Completed',
      BeerpongMatchStatus.bye => 'Bye',
    }),
  );
}

String _roundTitle(int round, int finalRound) {
  if (round == finalRound) return 'Final';
  if (round == finalRound - 1) return 'Semifinals';
  if (round == finalRound - 2) return 'Quarterfinals';
  return 'Round $round';
}

IconData _statusIcon(BeerpongMatchStatus status) => switch (status) {
  BeerpongMatchStatus.pending => Icons.schedule,
  BeerpongMatchStatus.ready => Icons.sports_bar,
  BeerpongMatchStatus.completed => Icons.check_circle,
  BeerpongMatchStatus.bye => Icons.fast_forward,
};
