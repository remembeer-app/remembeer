import 'package:flutter/material.dart';
import 'package:remembeer/session/model/session.dart';

class DrinkLogGroupSection extends StatelessWidget {
  const DrinkLogGroupSection({
    super.key,
    required this.isSharedSession,
    required this.sessions,
    this.minHeight,
  });

  final bool isSharedSession;
  final List<Session> sessions;
  final double? minHeight;

  @override
  Widget build(BuildContext context) =>
      const Center(child: Text('Session drinks are awaiting migration.'));
}
