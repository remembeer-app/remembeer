import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/model/party_tab.dart';
import 'package:remembeer/party/service/party_service.dart';
import 'package:remembeer/party/widget/party_activity_tab.dart';
import 'package:remembeer/party/widget/party_games_tab.dart';
import 'package:remembeer/party/widget/party_live_banner.dart';
import 'package:remembeer/party/widget/party_ranking_tab.dart';
import 'package:remembeer/routes.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/user/model/user_model.dart';

class PartyPage extends StatefulWidget {
  const PartyPage({
    super.key,
    required this.sessionId,
    this.tab = PartyTab.activity,
  });

  final String sessionId;
  final PartyTab tab;

  @override
  State<PartyPage> createState() => _PartyPageState();
}

class _PartyPageState extends State<PartyPage>
    with SingleTickerProviderStateMixin {
  final _drinkService = get<DrinkService>();
  final _partyService = get<PartyService>();
  final _sessionService = get<SessionService>();
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: PartyTab.values.length,
      initialIndex: widget.tab.index,
      vsync: this,
    )..addListener(_onTabChanged);
  }

  @override
  void didUpdateWidget(covariant PartyPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tab != PartyTab.values[_tabController.index]) {
      _tabController.index = widget.tab.index;
    }
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging || !mounted) {
      return;
    }
    final tab = PartyTab.values[_tabController.index];
    if (tab != widget.tab) {
      PartyRoute(sessionId: widget.sessionId, tab: tab).replace(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AsyncBuilder<PartyState>(
      stream: _partyService.stateStream(widget.sessionId),
      builder: (context, state) {
        if (!state.session.isParty) {
          return const PageTemplate(
            title: Text('Party'),
            child: Center(child: Text('This session is not a party.')),
          );
        }

        return AsyncBuilder<List<UserModel>>(
          stream: _sessionService.sessionMembersStream(state.session.id),
          builder: (context, members) => _buildPage(context, state, members),
        );
      },
    );
  }

  Widget _buildPage(
    BuildContext context,
    PartyState state,
    List<UserModel> members,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final session = state.session;
    final currentUser = members
        .where((member) => member.id == _partyService.currentUserId)
        .firstOrNull;
    final accent = currentUser?.accentColor;
    final headerBackgroundColor =
        accent?.softColor ?? colorScheme.errorContainer;
    final headerForegroundColor =
        accent?.textColor ?? colorScheme.onErrorContainer;

    return PageTemplate(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.celebration, color: accent?.color),
          const Gap(8),
          Flexible(child: Text(session.name, overflow: TextOverflow.ellipsis)),
        ],
      ),
      actions: state.isAdmin && state.isActive
          ? [
              IconButton(
                tooltip: 'Manage Party',
                onPressed: () => PartyManagementRoute(
                  sessionId: session.id,
                  tab: PartyTab.values[_tabController.index],
                ).push<void>(context),
                icon: const Icon(Icons.settings),
              ),
            ]
          : null,
      appBarBackgroundColor: headerBackgroundColor,
      appBarForegroundColor: headerForegroundColor,
      padding: EdgeInsets.zero,
      floatingActionButton: state.isActive && session.hasFreeSpace
          ? GestureDetector(
              onLongPress: () =>
                  _drinkService.addDefaultDrink(targetSessionId: session.id),
              child: FloatingActionButton(
                heroTag: 'party_add_drink_fab',
                onPressed: () => AddDrinkRoute(
                  targetSessionId: session.id,
                ).push<void>(context),
                child: const Icon(Icons.add),
              ),
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PartyLiveBanner(
            state: state,
            backgroundColor: headerBackgroundColor,
            foregroundColor: headerForegroundColor,
            accentColor: accent?.color,
          ),
          Material(
            color: headerBackgroundColor,
            child: TabBar(
              controller: _tabController,
              indicatorColor: accent?.color ?? headerForegroundColor,
              labelColor: headerForegroundColor,
              unselectedLabelColor: headerForegroundColor.withValues(
                alpha: 0.7,
              ),
              tabs: const [
                Tab(icon: Icon(Icons.emoji_events), text: 'Ranking'),
                Tab(icon: Icon(Icons.bolt), text: 'Activity'),
                Tab(icon: Icon(Icons.casino), text: 'Games'),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TabBarView(
                controller: _tabController,
                children: [
                  PartyRankingTab(
                    sessionId: session.id,
                    members: members,
                    currentUserId: _partyService.currentUserId,
                    partyService: _partyService,
                  ),
                  PartyActivityTab(
                    sessionId: session.id,
                    members: members,
                    drinks: session.drinks,
                    currentUserId: _partyService.currentUserId,
                    isPartyActive: state.isActive,
                  ),
                  PartyGamesTab(
                    state: state,
                    members: members,
                    onSelectClass: (selectedClass) =>
                        _partyService.selectClass(session.id, selectedClass),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
