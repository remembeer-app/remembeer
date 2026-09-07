import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/party/model/party_event.dart';
import 'package:remembeer/party/service/party_activity_service.dart';
import 'package:remembeer/user/model/user_model.dart';

class PartyActivityFiltersButton extends StatelessWidget {
  const PartyActivityFiltersButton({
    super.key,
    required this.filters,
    required this.members,
    required this.onChanged,
  });

  final PartyActivityFilters filters;
  final List<UserModel> members;
  final ValueChanged<PartyActivityFilters> onChanged;

  @override
  Widget build(BuildContext context) {
    final count = filters.participantIds.length + filters.kinds.length;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _showFilters(context),
            icon: const Icon(Icons.tune),
            label: Text(count == 0 ? 'Filter activity' : 'Filters ($count)'),
          ),
        ),
        if (count > 0) ...[
          const Gap(8),
          IconButton(
            tooltip: 'Clear activity filters',
            onPressed: () => onChanged(const PartyActivityFilters()),
            icon: const Icon(Icons.filter_alt_off),
          ),
        ],
      ],
    );
  }

  Future<void> _showFilters(BuildContext context) async {
    final result = await showModalBottomSheet<PartyActivityFilters>(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          _PartyActivityFiltersSheet(initialFilters: filters, members: members),
    );
    if (result != null) {
      onChanged(result);
    }
  }
}

class _PartyActivityFiltersSheet extends StatefulWidget {
  const _PartyActivityFiltersSheet({
    required this.initialFilters,
    required this.members,
  });

  final PartyActivityFilters initialFilters;
  final List<UserModel> members;

  @override
  State<_PartyActivityFiltersSheet> createState() =>
      _PartyActivityFiltersSheetState();
}

class _PartyActivityFiltersSheetState
    extends State<_PartyActivityFiltersSheet> {
  late final Set<String> _participantIds = {
    ...widget.initialFilters.participantIds,
  };
  late final Set<PartyEventKind> _kinds = {...widget.initialFilters.kinds};

  @override
  Widget build(BuildContext context) {
    final sortedMembers = [...widget.members]
      ..sort(
        (a, b) => a.username.toLowerCase().compareTo(b.username.toLowerCase()),
      );
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          24,
          20,
          24,
          20 + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Activity filters',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Gap(4),
              Text(
                'Selections are OR within each section and AND between sections.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Gap(20),
              Text('People', style: Theme.of(context).textTheme.titleMedium),
              const Gap(8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final member in sortedMembers)
                    FilterChip(
                      label: Text(member.username),
                      selected: _participantIds.contains(member.id),
                      onSelected: (selected) => setState(() {
                        selected
                            ? _participantIds.add(member.id)
                            : _participantIds.remove(member.id);
                      }),
                    ),
                ],
              ),
              const Gap(20),
              Text(
                'Event types',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const Gap(8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final kind in PartyEventKind.values)
                    FilterChip(
                      label: Text(kind.activityLabel),
                      selected: _kinds.contains(kind),
                      onSelected: (selected) => setState(() {
                        selected ? _kinds.add(kind) : _kinds.remove(kind);
                      }),
                    ),
                ],
              ),
              const Gap(24),
              FilledButton(
                onPressed: () => Navigator.pop(
                  context,
                  PartyActivityFilters(
                    participantIds: Set.unmodifiable(_participantIds),
                    kinds: Set.unmodifiable(_kinds),
                  ),
                ),
                child: const Text('Apply filters'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension PartyEventKindActivityLabel on PartyEventKind {
  String get activityLabel => switch (this) {
    PartyEventKind.drink => 'Drinks',
    PartyEventKind.socialQuest => 'Quests',
    PartyEventKind.adminChallenge => 'Challenges',
    PartyEventKind.beerpongPlacement => 'Placements',
    PartyEventKind.reversal => 'Reversals',
  };
}
