import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/party/constants.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/widget/party_class_selector.dart';

class PartyGamesTab extends StatelessWidget {
  const PartyGamesTab({
    super.key,
    required this.state,
    required this.onSelectClass,
  });

  final PartyState state;
  final Future<void> Function(DrinkCategory selectedClass) onSelectClass;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final selectedClass = state.currentMember?.selectedClass;
    final classMetadata = selectedClass == null
        ? null
        : partyClasses.singleWhere(
            (metadata) => metadata.category == selectedClass,
          );

    return ListView(
      children: [
        if (state.isActive &&
            state.currentMember != null &&
            selectedClass == null) ...[
          PartyClassSelector(onSubmit: onSelectClass),
          const Gap(32),
        ] else if (classMetadata != null) ...[
          Card(
            child: ListTile(
              leading: const Icon(Icons.shield_outlined),
              title: Text(classMetadata.title),
              subtitle: const Text(
                'Your class bonus applies to future drinks only.',
              ),
            ),
          ),
          const Gap(24),
        ],
        Icon(Icons.casino, size: 56, color: colorScheme.onSurfaceVariant),
        const Center(child: Text('Party games')),
        Text(
          state.isArchived
              ? 'This Party is archived. Game results remain available.'
              : 'Quests, challenges, and tournaments will appear here.',
          style: TextStyle(color: colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
