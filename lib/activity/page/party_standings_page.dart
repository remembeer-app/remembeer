import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/party/widget/party_standings.dart';

class PartyStandingsPage extends StatelessWidget {
  const PartyStandingsPage({super.key, required this.sessionId});
  final String sessionId;
  @override
  Widget build(BuildContext context) => PageTemplate(
    title: const Text('Party standings'),
    child: PartyStandings(sessionId: sessionId),
  );
}
