import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/party/widget/party_activity.dart';

class PartyEventsPage extends StatelessWidget {
  const PartyEventsPage({super.key, required this.sessionId});
  final String sessionId;
  @override
  Widget build(BuildContext context) => PageTemplate(
    title: const Text('Party activity'),
    child: PartyActivity(sessionId: sessionId),
  );
}
