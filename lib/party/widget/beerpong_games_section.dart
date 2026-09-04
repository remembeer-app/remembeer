import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/party/model/beerpong_tournament.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/model/party_tab.dart';
import 'package:remembeer/party/service/beerpong_service.dart';
import 'package:remembeer/routes.dart';
import 'package:remembeer/user/model/user_model.dart';

class BeerpongGamesSection extends StatefulWidget {
  const BeerpongGamesSection({
    super.key,
    required this.state,
    required this.members,
    required this.partyMembersStream,
    required this.service,
  });

  final PartyState state;
  final List<UserModel> members;
  final Stream<List<PartyMember>> partyMembersStream;
  final BeerpongService service;

  @override
  State<BeerpongGamesSection> createState() => _BeerpongGamesSectionState();
}

class _BeerpongGamesSectionState extends State<BeerpongGamesSection> {
  var _isUpdating = false;

  @override
  Widget build(BuildContext context) => AsyncBuilder<List<BeerpongTournament>>(
    stream: widget.service.tournamentsStream(widget.state.session.id),
    builder: (context, tournaments) => AsyncBuilder<List<PartyMember>>(
      stream: widget.partyMembersStream,
      builder: (context, partyMembers) {
        final activeId = widget.state.party.activeTournamentId;
        final tournament = tournaments
            .where((item) => item.id == activeId)
            .firstOrNull;
        final visible =
            tournament ??
            (widget.state.isArchived ? tournaments.firstOrNull : null);
        return _buildContent(context, visible, partyMembers);
      },
    ),
  );

  Widget _buildContent(
    BuildContext context,
    BeerpongTournament? tournament,
    List<PartyMember> partyMembers,
  ) {
    final optedIn = partyMembers.where((member) => member.beerpongOptIn).length;
    final currentMember = widget.state.currentMember;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Beerpong',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            if (tournament != null)
              TextButton.icon(
                onPressed: () => PartyTournamentRoute(
                  sessionId: widget.state.session.id,
                  tournamentId: tournament.id,
                  tab: PartyTab.games,
                ).push<void>(context),
                icon: const Icon(Icons.account_tree_outlined),
                label: const Text('Open bracket'),
              ),
          ],
        ),
        const Gap(8),
        if (tournament == null)
          Card(
            child: ListTile(
              leading: const Icon(Icons.sports_bar_outlined),
              title: Text(
                widget.state.isArchived
                    ? 'No archived tournament'
                    : 'No tournament yet',
              ),
              subtitle: Text(
                widget.state.isArchived
                    ? 'No beerpong tournament ran during this Party.'
                    : 'An admin can open enrollment from Party management.',
              ),
            ),
          )
        else if (tournament.status == BeerpongTournamentStatus.enrollment)
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.how_to_reg_outlined),
                  title: const Text('Enrollment open'),
                  subtitle: Text(
                    '$optedIn opted in · ${tournament.teamCount} teams planned',
                  ),
                ),
                if (widget.state.isActive && currentMember != null)
                  SwitchListTile(
                    secondary: const Icon(Icons.sports_bar),
                    title: const Text('Play in this tournament'),
                    subtitle: Text(
                      currentMember.beerpongOptIn
                          ? 'You are enrolled'
                          : 'You are not enrolled',
                    ),
                    value: currentMember.beerpongOptIn,
                    onChanged: _isUpdating
                        ? null
                        : (value) => _setOptIn(tournament, value),
                  ),
              ],
            ),
          )
        else
          Card(
            child: ListTile(
              leading: Icon(
                tournament.status == BeerpongTournamentStatus.completed
                    ? Icons.emoji_events
                    : widget.state.isArchived
                    ? Icons.archive_outlined
                    : Icons.account_tree_outlined,
              ),
              title: Text(
                tournament.status == BeerpongTournamentStatus.completed
                    ? 'Tournament completed'
                    : widget.state.isArchived
                    ? 'Archived tournament'
                    : 'Tournament in progress',
              ),
              subtitle: Text(
                '${tournament.participantIds.length} players · '
                '${tournament.teamCount} teams',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => PartyTournamentRoute(
                sessionId: widget.state.session.id,
                tournamentId: tournament.id,
                tab: PartyTab.games,
              ).push<void>(context),
            ),
          ),
      ],
    );
  }

  Future<void> _setOptIn(BeerpongTournament tournament, bool optedIn) async {
    setState(() => _isUpdating = true);
    try {
      await widget.service.setOptIn(
        sessionId: widget.state.session.id,
        tournamentId: tournament.id,
        expectedRevision: tournament.revision,
        optedIn: optedIn,
      );
      showSuccessNotification(optedIn ? 'You are enrolled.' : 'Opt-out saved.');
    } on Exception catch (error) {
      showErrorNotification(error.toString());
    } finally {
      if (mounted) setState(() => _isUpdating = false);
    }
  }
}
