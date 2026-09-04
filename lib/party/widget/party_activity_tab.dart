import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/party/controller/party_event_controller.dart';
import 'package:remembeer/party/service/party_activity_service.dart';
import 'package:remembeer/party/widget/party_activity_filters.dart';
import 'package:remembeer/party/widget/party_event_card.dart';
import 'package:remembeer/user/model/user_model.dart';

class PartyActivityTab extends StatefulWidget {
  const PartyActivityTab({
    super.key,
    required this.sessionId,
    required this.members,
    this.service,
  });

  final String sessionId;
  final List<UserModel> members;
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
        return PartyEventCard(group: groups[index], membersById: membersById);
      },
    );
  }
}
