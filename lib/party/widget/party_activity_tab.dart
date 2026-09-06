import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/party/controller/party_event_controller.dart';
import 'package:remembeer/party/model/party_event.dart';
import 'package:remembeer/party/service/party_activity_service.dart';
import 'package:remembeer/party/widget/party_activity_filters.dart';
import 'package:remembeer/party/widget/party_event_card.dart';
import 'package:remembeer/routes.dart';
import 'package:remembeer/user/model/user_model.dart';

class PartyActivityTab extends StatefulWidget {
  const PartyActivityTab({
    super.key,
    required this.sessionId,
    required this.members,
    required this.drinks,
    required this.currentUserId,
    required this.isPartyActive,
    this.service,
  });

  final String sessionId;
  final List<UserModel> members;
  final List<Drink> drinks;
  final String currentUserId;
  final bool isPartyActive;
  final PartyActivityService? service;

  @override
  State<PartyActivityTab> createState() => _PartyActivityTabState();
}

class _PartyActivityTabState extends State<PartyActivityTab> {
  late final PartyActivityService _service =
      widget.service ??
      PartyActivityService(
        sessionId: widget.sessionId,
        eventController: get<PartyEventController>(),
      );
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _service
      ..addListener(_onServiceChanged)
      ..loadInitial();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _service.removeListener(_onServiceChanged);
    if (widget.service == null) {
      _service.dispose();
    }
    super.dispose();
  }

  void _onServiceChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 240) {
      _service.loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = _service.state;
    final groups = groupPartyEvents(state.events);
    final membersById = {
      for (final member in widget.members) member.id: member,
    };

    return Column(
      children: [
        PartyActivityFiltersButton(
          filters: state.filters,
          members: widget.members,
          onChanged: _service.setFilters,
        ),
        const Gap(12),
        Expanded(
          child: RefreshIndicator(
            onRefresh: _service.loadInitial,
            child: _buildFeed(context, state, groups, membersById),
          ),
        ),
      ],
    );
  }

  Widget _buildFeed(
    BuildContext context,
    PartyActivityState state,
    List<PartyEventGroup> groups,
    Map<String, UserModel> membersById,
  ) {
    if (state.events.isEmpty && state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.events.isEmpty) {
      return ListView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 64),
            child: Column(
              children: [
                const Icon(Icons.bolt, size: 56),
                const Gap(12),
                Text(
                  state.filters.isEmpty
                      ? 'No Party activity yet'
                      : 'No activity matches these filters',
                ),
                if (state.error != null) ...[
                  const Gap(8),
                  Text('Could not load activity: ${state.error}'),
                ],
              ],
            ),
          ),
        ],
      );
    }

    return ListView.separated(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: groups.length + (state.isLoading || state.hasMore ? 1 : 0),
      separatorBuilder: (context, index) => const Gap(8),
      itemBuilder: (context, index) {
        if (index == groups.length) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: state.isLoading
                  ? const CircularProgressIndicator()
                  : OutlinedButton(
                      onPressed: _service.loadMore,
                      child: const Text('Load more activity'),
                    ),
            ),
          );
        }
        final group = groups[index];
        final editableDrink = _editableDrink(group);
        return PartyEventCard(
          group: group,
          membersById: membersById,
          onEdit: editableDrink == null
              ? null
              : () => _editDrink(context, editableDrink.id),
        );
      },
    );
  }

  Drink? _editableDrink(PartyEventGroup group) {
    final event = group.events.first;
    if (!widget.isPartyActive ||
        group.isReversed ||
        event.kind != PartyEventKind.drink ||
        event.sourceCollection != PartyEventSourceCollection.drinks ||
        event.recipientUserId != widget.currentUserId) {
      return null;
    }
    final revision = event.payload['revision'];
    if (revision is! int) {
      return null;
    }
    for (final drink in widget.drinks) {
      if (drink.id == event.sourceId &&
          drink.consumedByUserId == widget.currentUserId &&
          drink.partyRevision == revision) {
        return drink;
      }
    }
    return null;
  }

  Future<void> _editDrink(BuildContext context, String drinkId) async {
    final updated = await UpdateDrinkRoute(
      sessionId: widget.sessionId,
      drinkId: drinkId,
    ).push<bool>(context);
    if (updated ?? false) {
      await _service.loadInitial();
    }
  }
}
