import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/controller/party_controller.dart';
import 'package:remembeer/party/controller/party_event_controller.dart';
import 'package:remembeer/party/controller/party_game_controller.dart';
import 'package:remembeer/party/model/party_challenge.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/model/party_tab.dart';
import 'package:remembeer/party/service/party_challenge_service.dart';
import 'package:remembeer/party/service/party_quest_service.dart';
import 'package:remembeer/party/widget/challenge_card.dart';
import 'package:remembeer/party/widget/party_class_selector.dart';
import 'package:remembeer/party/widget/party_quest_games_section.dart';
import 'package:remembeer/routes.dart';
import 'package:remembeer/user/model/user_model.dart';

typedef PartyGamesSectionBuilder =
    Widget Function(
      BuildContext context,
      PartyState state,
      List<UserModel> members,
    );

class PartyGamesTab extends StatelessWidget {
  const PartyGamesTab({
    super.key,
    required this.state,
    required this.members,
    required this.onSelectClass,
    this.challengeService,
    this.questService,
    this.socialQuestSectionBuilder,
    this.beerpongSectionBuilder,
  });

  final PartyState state;
  final List<UserModel> members;
  final Future<void> Function(DrinkCategory selectedClass) onSelectClass;
  final PartyChallengeService? challengeService;
  final PartyQuestService? questService;
  final PartyGamesSectionBuilder? socialQuestSectionBuilder;
  final PartyGamesSectionBuilder? beerpongSectionBuilder;

  @override
  Widget build(BuildContext context) {
    final settings = state.party.moduleSettings;
    final sections = <Widget>[
      ..._classSection(),
      if (settings.socialQuestsEnabled)
        socialQuestSectionBuilder?.call(context, state, members) ??
            PartyQuestGamesSection(
              state: state,
              members: members,
              service: _questService,
            ),
      if (settings.adminChallengesEnabled) _buildChallenges(context),
      if (settings.beerpongEnabled)
        beerpongSectionBuilder?.call(context, state, members) ??
            const _ModulePlaceholder(
              icon: Icons.sports_bar_outlined,
              title: 'Beerpong',
              text: 'Enrollment and tournament results will appear here.',
            ),
    ];
    final disabledCount = [
      settings.socialQuestsEnabled,
      settings.adminChallengesEnabled,
      settings.beerpongEnabled,
    ].where((enabled) => !enabled).length;

    return ListView(
      children: [
        ..._withSpacing(sections),
        if (disabledCount > 0 && state.isAdmin && state.isActive) ...[
          if (sections.isNotEmpty) const Gap(24),
          Card(
            child: ListTile(
              leading: const Icon(Icons.extension_off_outlined),
              title: Text('$disabledCount game modules disabled'),
              subtitle: const Text('Enable each module independently.'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => PartyManagementRoute(
                sessionId: state.session.id,
                tab: PartyTab.games,
              ).push<void>(context),
            ),
          ),
        ],
        if (sections.isEmpty && !(state.isAdmin && state.isActive))
          _EmptyGames(isArchived: state.isArchived),
      ],
    );
  }

  List<Widget> _classSection() {
    final selectedClass = state.currentMember?.selectedClass;
    final classMetadata = selectedClass == null
        ? null
        : partyClasses.singleWhere(
            (metadata) => metadata.category == selectedClass,
          );
    if (state.isActive &&
        state.currentMember != null &&
        selectedClass == null) {
      return [PartyClassSelector(onSubmit: onSelectClass)];
    }
    if (classMetadata == null) {
      return [];
    }
    return [
      Card(
        child: ListTile(
          leading: const Icon(Icons.shield_outlined),
          title: Text(classMetadata.title),
          subtitle: const Text(
            'Your class bonus applies to future drinks only.',
          ),
        ),
      ),
    ];
  }

  Widget _buildChallenges(BuildContext context) =>
      AsyncBuilder<List<PartyChallenge>>(
        stream: _challengeService.challengesStream(state.session.id),
        builder: (context, challenges) {
          final activeId = state.party.activeChallengeId;
          final active = challenges
              .where((challenge) => challenge.id == activeId)
              .firstOrNull;
          final recent = challenges
              .where((challenge) => challenge.id != activeId)
              .take(partyChallengeRecentResultCount)
              .toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Admin challenges',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  if (state.isAdmin && state.isActive)
                    TextButton.icon(
                      onPressed: () => PartyManagementRoute(
                        sessionId: state.session.id,
                        tab: PartyTab.games,
                      ).push<void>(context),
                      icon: const Icon(Icons.tune),
                      label: Text(active == null ? 'Create' : 'Manage'),
                    ),
                ],
              ),
              const Gap(8),
              if (active != null)
                ChallengeCard(
                  challenge: active,
                  onTap: () => _openChallenge(context, active.id),
                )
              else
                const _ModulePlaceholder(
                  icon: Icons.flag_outlined,
                  title: 'No active challenge',
                  text: 'An admin can start the next timed challenge.',
                ),
              if (recent.isNotEmpty) ...[
                const Gap(16),
                Text(
                  'Recent results',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Gap(4),
                for (final challenge in recent)
                  ChallengeCard(
                    challenge: challenge,
                    compact: true,
                    onTap: () => _openChallenge(context, challenge.id),
                  ),
              ],
            ],
          );
        },
      );

  void _openChallenge(BuildContext context, String challengeId) {
    PartyChallengeRoute(
      sessionId: state.session.id,
      challengeId: challengeId,
      tab: PartyTab.games,
    ).push<void>(context);
  }

  PartyChallengeService get _challengeService =>
      challengeService ??
      PartyChallengeService(
        partyController: get<PartyController>(),
        gameController: get<PartyGameController>(),
        eventController: get<PartyEventController>(),
      );

  PartyQuestService get _questService =>
      questService ??
      PartyQuestService(
        partyController: get<PartyController>(),
        gameController: get<PartyGameController>(),
      );
}

class _ModulePlaceholder extends StatelessWidget {
  const _ModulePlaceholder({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(text),
    ),
  );
}

class _EmptyGames extends StatelessWidget {
  const _EmptyGames({required this.isArchived});

  final bool isArchived;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 48),
    child: Column(
      children: [
        Icon(
          Icons.casino_outlined,
          size: 56,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const Gap(8),
        Text(
          isArchived ? 'No archived game results' : 'No games enabled',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ],
    ),
  );
}

List<Widget> _withSpacing(List<Widget> sections) => [
  for (var index = 0; index < sections.length; index++) ...[
    if (index > 0) const Gap(24),
    sections[index],
  ],
];
