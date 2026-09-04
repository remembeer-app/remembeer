import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/loading_form.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/model/beerpong_match.dart';
import 'package:remembeer/party/model/beerpong_team.dart';
import 'package:remembeer/party/model/beerpong_tournament.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/model/party_tab.dart';
import 'package:remembeer/party/service/beerpong_service.dart';
import 'package:remembeer/routes.dart';

class BeerpongManagementSection extends StatelessWidget {
  const BeerpongManagementSection({
    super.key,
    required this.state,
    required this.service,
    required this.partyMembersStream,
  });

  final PartyState state;
  final BeerpongService service;
  final Stream<List<PartyMember>> partyMembersStream;

  @override
  Widget build(BuildContext context) => AsyncBuilder<List<BeerpongTournament>>(
    stream: service.tournamentsStream(state.session.id),
    builder: (context, tournaments) => AsyncBuilder<List<PartyMember>>(
      stream: partyMembersStream,
      builder: (context, members) {
        final tournament = tournaments
            .where((item) => item.id == state.party.activeTournamentId)
            .firstOrNull;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Beerpong tournament',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Gap(4),
            const Text(
              'Open enrollment, draw balanced teams, and manage results.',
            ),
            const Gap(8),
            if (tournament == null)
              _TournamentCreationForm(
                onCreate:
                    ({
                      required teamCount,
                      required thirdPlaceEnabled,
                      required firstPlacePoints,
                      required secondPlacePoints,
                      required thirdPlacePoints,
                    }) => service.createTournament(
                      sessionId: state.session.id,
                      teamCount: teamCount,
                      thirdPlaceEnabled: thirdPlaceEnabled,
                      firstPlacePoints: firstPlacePoints,
                      secondPlacePoints: secondPlacePoints,
                      thirdPlacePoints: thirdPlacePoints,
                    ),
              )
            else
              AsyncBuilder<BeerpongDetailState>(
                stream: service.detailStateStream(
                  state.session.id,
                  tournament.id,
                ),
                builder: (context, detail) => _CurrentTournamentPanel(
                  state: state,
                  tournament: detail.tournament ?? tournament,
                  teams: detail.teams,
                  matches: detail.matches,
                  optedInCount: members
                      .where((member) => member.beerpongOptIn)
                      .length,
                  service: service,
                ),
              ),
          ],
        );
      },
    ),
  );
}

class _TournamentCreationForm extends StatefulWidget {
  const _TournamentCreationForm({required this.onCreate});

  final Future<void> Function({
    required int teamCount,
    required bool thirdPlaceEnabled,
    required int firstPlacePoints,
    required int secondPlacePoints,
    required int thirdPlacePoints,
  })
  onCreate;

  @override
  State<_TournamentCreationForm> createState() =>
      _TournamentCreationFormState();
}

class _TournamentCreationFormState extends State<_TournamentCreationForm> {
  var _teamCount = 2;
  var _thirdPlaceEnabled = true;
  final _firstController = TextEditingController(
    text: '$defaultBeerpongFirstPlacePoints',
  );
  final _secondController = TextEditingController(
    text: '$defaultBeerpongSecondPlacePoints',
  );
  final _thirdController = TextEditingController(
    text: '$defaultBeerpongThirdPlacePoints',
  );

  @override
  void dispose() {
    _firstController.dispose();
    _secondController.dispose();
    _thirdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: LoadingForm(
        builder: (form) => Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Open enrollment',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Gap(12),
            DropdownButtonFormField<int>(
              initialValue: _teamCount,
              decoration: const InputDecoration(
                labelText: 'Team count',
                border: OutlineInputBorder(),
              ),
              items: [
                for (
                  var count = minBeerpongTeamCount;
                  count <= maxBeerpongTeamCount;
                  count++
                )
                  DropdownMenuItem(value: count, child: Text('$count teams')),
              ],
              onChanged: form.isLoading
                  ? null
                  : (value) => setState(() => _teamCount = value ?? 2),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Third-place match'),
              value: _thirdPlaceEnabled,
              onChanged: form.isLoading
                  ? null
                  : (value) => setState(() => _thirdPlaceEnabled = value),
            ),
            const Gap(4),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: form.buildTextField(
                    controller: _firstController,
                    label: '1st points',
                    keyboardType: TextInputType.number,
                    validator: _pointsValidator,
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: form.buildTextField(
                    controller: _secondController,
                    label: '2nd points',
                    keyboardType: TextInputType.number,
                    validator: _pointsValidator,
                  ),
                ),
                const Gap(8),
                Expanded(
                  child: form.buildTextField(
                    controller: _thirdController,
                    label: '3rd points',
                    keyboardType: TextInputType.number,
                    isLastField: true,
                    validator: _pointsValidator,
                  ),
                ),
              ],
            ),
            form.buildErrorMessage(),
            const Gap(12),
            form.buildSubmitButton(
              text: 'Open enrollment',
              onSubmit: () async {
                final first = int.parse(_firstController.text);
                final second = int.parse(_secondController.text);
                final third = int.parse(_thirdController.text);
                if (!(first >= second && second >= third)) {
                  throw Exception(
                    'Placement points cannot increase for lower places.',
                  );
                }
                await widget.onCreate(
                  teamCount: _teamCount,
                  thirdPlaceEnabled: _thirdPlaceEnabled,
                  firstPlacePoints: first,
                  secondPlacePoints: second,
                  thirdPlacePoints: third,
                );
                showSuccessNotification('Beerpong enrollment opened.');
              },
            ),
          ],
        ),
      ),
    ),
  );
}

class _CurrentTournamentPanel extends StatefulWidget {
  const _CurrentTournamentPanel({
    required this.state,
    required this.tournament,
    required this.teams,
    required this.matches,
    required this.optedInCount,
    required this.service,
  });

  final PartyState state;
  final BeerpongTournament tournament;
  final List<BeerpongTeam> teams;
  final List<BeerpongMatch> matches;
  final int optedInCount;
  final BeerpongService service;

  @override
  State<_CurrentTournamentPanel> createState() =>
      _CurrentTournamentPanelState();
}

class _CurrentTournamentPanelState extends State<_CurrentTournamentPanel> {
  String? _pendingAction;

  @override
  Widget build(BuildContext context) {
    final tournament = widget.tournament;
    final hasResult = widget.matches.any(
      (match) => match.status == BeerpongMatchStatus.completed,
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.how_to_reg_outlined),
              title: Text(_statusTitle(tournament.status)),
              subtitle: Text(
                '${widget.optedInCount} opted in · ${tournament.teamCount} teams · '
                '${tournament.thirdPlaceEnabled ? 'third place on' : 'third place off'}',
              ),
            ),
            Text(
              'Points: ${formatPartyScore(tournament.firstPlacePointsUnits)} / '
              '${formatPartyScore(tournament.secondPlacePointsUnits)} / '
              '${formatPartyScore(tournament.thirdPlacePointsUnits)}',
            ),
            const Gap(12),
            if (tournament.status == BeerpongTournamentStatus.enrollment)
              FilledButton.icon(
                onPressed:
                    _pendingAction == null &&
                        widget.optedInCount >= tournament.teamCount
                    ? () => _confirmDraw(context)
                    : null,
                icon: const Icon(Icons.shuffle),
                label: Text(
                  widget.optedInCount < tournament.teamCount
                      ? 'Need ${tournament.teamCount} enrolled players'
                      : 'Draw teams',
                ),
              ),
            if (tournament.status == BeerpongTournamentStatus.active &&
                !hasResult)
              OutlinedButton.icon(
                onPressed: _pendingAction == null
                    ? () => _confirmRedraw(context)
                    : null,
                icon: const Icon(Icons.replay),
                label: const Text('Reopen and redraw'),
              ),
            if (widget.teams.isNotEmpty) ...[
              const Gap(16),
              Text('Teams', style: Theme.of(context).textTheme.titleMedium),
              const Gap(8),
              for (final team in widget.teams)
                _TeamRenameTile(
                  key: ValueKey('${team.id}:${team.name}'),
                  team: team,
                  enabled:
                      tournament.status == BeerpongTournamentStatus.active &&
                      !hasResult &&
                      _pendingAction == null,
                  onRename: (name) => _runAction(
                    'rename:${team.id}',
                    () => widget.service.renameTeam(
                      sessionId: widget.state.session.id,
                      tournamentId: tournament.id,
                      expectedRevision: tournament.revision,
                      teamId: team.id,
                      name: name,
                    ),
                    'Team renamed.',
                  ),
                ),
            ],
            const Gap(12),
            OutlinedButton.icon(
              onPressed: () => PartyTournamentRoute(
                sessionId: widget.state.session.id,
                tournamentId: tournament.id,
                tab: PartyTab.games,
              ).push<void>(context),
              icon: const Icon(Icons.account_tree_outlined),
              label: const Text('Manage bracket and results'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDraw(BuildContext context) {
    showConfirmationDialog(
      context: context,
      title: 'Draw teams?',
      text: 'Enrollment will lock and the tournament bracket will go live.',
      submitButtonText: 'Draw teams',
      onPressed: () => _runAction(
        'draw',
        () => widget.service.drawTournament(
          sessionId: widget.state.session.id,
          tournament: widget.tournament,
        ),
        'Teams drawn.',
      ),
    );
  }

  void _confirmRedraw(BuildContext context) {
    showConfirmationDialog(
      context: context,
      title: 'Reopen enrollment?',
      text:
          'Current teams and matches will be removed and must be drawn again.',
      submitButtonText: 'Reopen enrollment',
      isDestructive: true,
      onPressed: () => _runAction(
        'redraw',
        () => widget.service.redrawTournament(
          sessionId: widget.state.session.id,
          tournament: widget.tournament,
        ),
        'Enrollment reopened.',
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

class _TeamRenameTile extends StatefulWidget {
  const _TeamRenameTile({
    super.key,
    required this.team,
    required this.enabled,
    required this.onRename,
  });

  final BeerpongTeam team;
  final bool enabled;
  final Future<void> Function(String name) onRename;

  @override
  State<_TeamRenameTile> createState() => _TeamRenameTileState();
}

class _TeamRenameTileState extends State<_TeamRenameTile> {
  late final _controller = TextEditingController(text: widget.team.name);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            enabled: widget.enabled,
            maxLength: maxBeerpongTeamNameLength,
            decoration: InputDecoration(
              labelText: 'Team ${widget.team.seed}',
              border: const OutlineInputBorder(),
              counterText: '',
            ),
          ),
        ),
        const Gap(8),
        IconButton.filledTonal(
          tooltip: 'Save team name',
          onPressed: !widget.enabled
              ? null
              : () {
                  final name = _controller.text.trim();
                  if (name.isNotEmpty && name != widget.team.name) {
                    widget.onRename(name);
                  }
                },
          icon: const Icon(Icons.save_outlined),
        ),
      ],
    ),
  );
}

String? _pointsValidator(String? value) {
  final parsed = int.tryParse(value ?? '');
  if (parsed == null ||
      parsed < minBeerpongPlacementPoints ||
      parsed > maxBeerpongPlacementPoints) {
    return '$minBeerpongPlacementPoints-$maxBeerpongPlacementPoints';
  }
  return null;
}

String _statusTitle(BeerpongTournamentStatus status) => switch (status) {
  BeerpongTournamentStatus.enrollment => 'Enrollment open',
  BeerpongTournamentStatus.active => 'Tournament active',
  BeerpongTournamentStatus.completed => 'Tournament completed',
  BeerpongTournamentStatus.cancelled => 'Tournament cancelled',
};
