import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/service/party_service.dart';
import 'package:remembeer/party/widget/party_class_selector.dart';
import 'package:remembeer/user/model/user_model.dart';

class PartyProfilePage extends StatelessWidget {
  PartyProfilePage({super.key, required this.sessionId, required this.user});

  final String sessionId;
  final UserModel user;
  final _partyService = get<PartyService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: Text(user.username),
      child: AsyncBuilder<PartyState>(
        stream: _partyService.stateStream(sessionId),
        builder: (context, state) => AsyncBuilder<List<PartyMember>>(
          stream: _partyService.membersStream(sessionId),
          builder: (context, members) => _buildContent(
            context,
            state,
            members.where((member) => member.userId == user.id).firstOrNull,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    PartyState state,
    PartyMember? member,
  ) {
    if (member == null) {
      return const Center(child: Text('Party member data is unavailable.'));
    }
    if (state.isArchived || !member.isActive) {
      return const Center(
        child: Text(
          'Class controls are unavailable for archived or inactive members.',
          textAlign: TextAlign.center,
        ),
      );
    }
    if (!state.isAdmin) {
      return const Center(child: Text('Only Party admins can change classes.'));
    }

    return ListView(
      children: [
        const Card(
          child: ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Changes affect future drinks only'),
            subtitle: Text(
              'Existing drink awards keep the class and bonus they received when recorded.',
            ),
          ),
        ),
        const Gap(16),
        PartyClassSelector(
          selectedClass: member.selectedClass,
          submitLabel: member.selectedClass == null
              ? 'Set member class'
              : 'Change member class',
          onSubmit: (selectedClass) async {
            await _partyService.setMemberClass(
              sessionId,
              member.userId,
              selectedClass,
            );
            showSuccessNotification('Party class updated!');
          },
        ),
      ],
    );
  }
}
