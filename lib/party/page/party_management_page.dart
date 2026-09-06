import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/page/party_profile_page.dart';
import 'package:remembeer/party/service/party_service.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/user/model/user_model.dart';

class PartyManagementPage extends StatelessWidget {
  PartyManagementPage({super.key, required this.sessionId});

  final String sessionId;
  final _partyService = get<PartyService>();
  final _sessionService = get<SessionService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Manage Party'),
      child: AsyncBuilder<PartyState>(
        stream: _partyService.stateStream(sessionId),
        builder: (context, state) {
          if (state.isArchived) {
            return const Center(
              child: Text('This Party is archived and read-only.'),
            );
          }
          if (!state.isAdmin) {
            return const Center(
              child: Text('Only Party admins can manage member classes.'),
            );
          }
          return AsyncBuilder<List<PartyMember>>(
            stream: _partyService.membersStream(sessionId),
            builder: (context, partyMembers) => AsyncBuilder<List<UserModel>>(
              stream: _sessionService.sessionMembersStream(sessionId),
              builder: (context, users) =>
                  _buildMembers(context, state, partyMembers, users),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMembers(
    BuildContext context,
    PartyState state,
    List<PartyMember> partyMembers,
    List<UserModel> users,
  ) {
    final activeMembers = partyMembers
        .where(
          (member) =>
              member.isActive &&
              state.session.memberIds.contains(member.userId),
        )
        .toList();

    return ListView(
      children: [
        Text('Member classes', style: Theme.of(context).textTheme.titleLarge),
        const Gap(4),
        Text(
          'Class changes affect future drinks only.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const Gap(12),
        for (final member in activeMembers)
          if (users.where((user) => user.id == member.userId).firstOrNull
              case final user?)
            Card(
              child: ListTile(
                leading: const Icon(Icons.shield_outlined),
                title: Text(user.username),
                subtitle: Text(
                  member.selectedClass?.displayName ?? 'No class selected',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.of(context).push<void>(
                  MaterialPageRoute(
                    builder: (_) =>
                        PartyProfilePage(sessionId: sessionId, user: user),
                  ),
                ),
              ),
            ),
      ],
    );
  }
}
