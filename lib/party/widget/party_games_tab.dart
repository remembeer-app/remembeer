import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/drink_icon.dart';
import 'package:remembeer/drink/model/drink_category.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/model/party.dart';
import 'package:remembeer/party/model/party_challenge.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/model/party_tab.dart';
import 'package:remembeer/party/service/beerpong_service.dart';
import 'package:remembeer/party/service/party_challenge_service.dart';
import 'package:remembeer/party/service/party_quest_service.dart';
import 'package:remembeer/party/widget/beerpong_games_section.dart';
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

class PartyGamesTab extends StatefulWidget {
  const PartyGamesTab({
    super.key,
    required this.state,
    required this.members,
    required this.onSelectClass,
    this.challengeService,
    this.questService,
    this.beerpongService,
    this.socialQuestSectionBuilder,
    this.beerpongSectionBuilder,
  });

  final PartyState state;
  final List<UserModel> members;
  final Future<void> Function(DrinkCategory selectedClass) onSelectClass;
  final PartyChallengeService? challengeService;
  final PartyQuestService? questService;
  final BeerpongService? beerpongService;
  final PartyGamesSectionBuilder? socialQuestSectionBuilder;
  final PartyGamesSectionBuilder? beerpongSectionBuilder;

  @override
  State<PartyGamesTab> createState() => _PartyGamesTabState();
}

class _PartyGamesTabState extends State<PartyGamesTab> {
  final _scrollController = ScrollController();
  final _classSectionKey = GlobalKey();

  PartyState get state => widget.state;
  List<UserModel> get members => widget.members;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = state.party.moduleSettings;
    if (settings.adminChallengesEnabled) {
      return AsyncBuilder<List<PartyChallenge>>(
        stream: _challengeService.challengesStream(state.session.id),
        builder: (context, challenges) =>
            _buildContent(context, settings, challenges),
      );
    }
    return _buildContent(context, settings, const []);
  }

  Widget _buildContent(
    BuildContext context,
    PartyModuleSettings settings,
    List<PartyChallenge> challenges,
  ) {
    final needsClassSelection =
        state.isActive &&
        state.currentMember != null &&
        state.currentMember?.selectedClass == null;
    final sections = <Widget>[
      if (needsClassSelection)
        _ClassSelectionNotice(onChooseClass: _scrollToClassSection),
      if (settings.socialQuestsEnabled)
        widget.socialQuestSectionBuilder?.call(context, state, members) ??
            PartyQuestGamesSection(
              state: state,
              members: members,
              service: _questService,
            ),
      if (settings.adminChallengesEnabled)
        _buildActiveChallenge(context, challenges),
      if (settings.beerpongEnabled)
        widget.beerpongSectionBuilder?.call(context, state, members) ??
            BeerpongGamesSection(
              state: state,
              members: members,
              partyMembersStream: _beerpongService.partyMembersStream(
                state.session.id,
              ),
              service: _beerpongService,
            ),
      ..._classSection(needsClassSelection: needsClassSelection),
    ];
    final activeId = state.party.activeChallengeId;
    final recentChallenges = challenges
        .where((challenge) => challenge.id != activeId)
        .take(partyChallengeRecentResultCount)
        .toList();
    final disabledCount = [
      settings.socialQuestsEnabled,
      settings.adminChallengesEnabled,
      settings.beerpongEnabled,
    ].where((enabled) => !enabled).length;

    return ListView(
      controller: _scrollController,
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
        if (recentChallenges.isNotEmpty) ...[
          if (sections.isNotEmpty ||
              (disabledCount > 0 && state.isAdmin && state.isActive))
            const Gap(24),
          _buildRecentChallengeResults(context, recentChallenges),
        ],
        if (sections.isEmpty &&
            recentChallenges.isEmpty &&
            !(state.isAdmin && state.isActive))
          _EmptyGames(isArchived: state.isArchived),
      ],
    );
  }

  List<Widget> _classSection({required bool needsClassSelection}) {
    if (needsClassSelection) {
      return [
        KeyedSubtree(
          key: _classSectionKey,
          child: PartyClassSelector(onSubmit: widget.onSelectClass),
        ),
      ];
    }
    final selectedClass = state.currentMember?.selectedClass;
    if (selectedClass == null) {
      return [];
    }
    final classMetadata = partyClasses.singleWhere(
      (metadata) => metadata.category == selectedClass,
    );
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Your class', style: Theme.of(context).textTheme.titleLarge),
          const Gap(8),
          Card(
            child: ListTile(
              leading: DrinkIcon(category: selectedClass, size: 32),
              title: Text(classMetadata.title),
              subtitle: const Text(
                'Your class bonus applies to future drinks only.',
              ),
            ),
          ),
        ],
      ),
    ];
  }

  Future<void> _scrollToClassSection() async {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (_classSectionKey.currentContext == null) {
      // The selector sits at the end of the lazily built list, so scroll
      // there first to make sure it is laid out before aligning to it.
      await _scrollController.animateTo(
        position.maxScrollExtent,
        duration: partyGamesScrollDuration,
        curve: Curves.easeInOut,
      );
    }
    final classContext = _classSectionKey.currentContext;
    if (classContext == null || !classContext.mounted) return;
    await Scrollable.ensureVisible(
      classContext,
      duration: partyGamesScrollDuration,
      curve: Curves.easeInOut,
    );
  }

  Widget _buildActiveChallenge(
    BuildContext context,
    List<PartyChallenge> challenges,
  ) {
    final activeId = state.party.activeChallengeId;
    final active = challenges
        .where((challenge) => challenge.id == activeId)
        .firstOrNull;
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
      ],
    );
  }

  Widget _buildRecentChallengeResults(
    BuildContext context,
    List<PartyChallenge> challenges,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text('Recent results', style: Theme.of(context).textTheme.titleMedium),
      const Gap(4),
      for (final challenge in challenges)
        ChallengeCard(
          challenge: challenge,
          compact: true,
          onTap: () => _openChallenge(context, challenge.id),
        ),
    ],
  );

  void _openChallenge(BuildContext context, String challengeId) {
    PartyChallengeRoute(
      sessionId: state.session.id,
      challengeId: challengeId,
      tab: PartyTab.games,
    ).push<void>(context);
  }

  PartyChallengeService get _challengeService =>
      widget.challengeService ?? get<PartyChallengeService>();

  PartyQuestService get _questService =>
      widget.questService ?? get<PartyQuestService>();

  BeerpongService get _beerpongService =>
      widget.beerpongService ?? get<BeerpongService>();
}

class _ClassSelectionNotice extends StatelessWidget {
  const _ClassSelectionNotice({required this.onChooseClass});

  final VoidCallback onChooseClass;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.shield_outlined,
                  color: colorScheme.onTertiaryContainer,
                ),
                const Gap(12),
                Expanded(
                  child: Text(
                    'No Party class selected',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: colorScheme.onTertiaryContainer,
                    ),
                  ),
                ),
              ],
            ),
            const Gap(8),
            Text(
              'Pick a class to earn a 10% Party point bonus on matching drinks. '
              'Drinks logged without a class get no bonus.',
              style: TextStyle(color: colorScheme.onTertiaryContainer),
            ),
            const Gap(4),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onChooseClass,
                style: TextButton.styleFrom(
                  foregroundColor: colorScheme.onTertiaryContainer,
                ),
                icon: const Icon(Icons.arrow_downward),
                label: const Text('Pick your class'),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
