import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/service/party_service.dart';

class PartyManagementPage extends StatelessWidget {
  PartyManagementPage({super.key, required this.sessionId});

  final String sessionId;
  final _partyService = get<PartyService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Manage Party'),
      child: AsyncBuilder<PartyState>(
        stream: _partyService.stateStream(sessionId),
        builder: (context, state) {
          final message = state.isArchived
              ? 'This Party is archived and read-only.'
              : 'Party management options will appear here.';
          return Center(child: Text(message, textAlign: TextAlign.center));
        },
      ),
    );
  }
}
