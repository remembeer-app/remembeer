import 'package:flutter/material.dart';

class PartyGamesTab extends StatelessWidget {
  const PartyGamesTab({super.key, required this.isReadOnly});

  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.casino, size: 56, color: colorScheme.onSurfaceVariant),
          const Text('Party games'),
          Text(
            isReadOnly
                ? 'This Party is archived. Game results remain available.'
                : 'Quests, challenges, and tournaments will appear here.',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
