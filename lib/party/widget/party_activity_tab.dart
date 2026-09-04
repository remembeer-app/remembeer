import 'package:flutter/material.dart';

class PartyActivityTab extends StatelessWidget {
  const PartyActivityTab({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.bolt, size: 56, color: colorScheme.onSurfaceVariant),
          const Text('Party activity'),
          Text(
            'Drinks and game results will appear here.',
            style: TextStyle(color: colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
