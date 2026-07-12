import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/widget/async_builder.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/session/widget/user_list_tile.dart';
import 'package:remembeer/user/model/user_model.dart';

class ManageAdminsPage extends StatelessWidget {
  final Session session;

  ManageAdminsPage({super.key, required this.session});

  final _sessionService = get<SessionService>();

  @override
  Widget build(BuildContext context) {
    return PageTemplate(
      title: const Text('Manage Admins'),
      child: AsyncBuilder<Session>(
        stream: _sessionService.sessionStream(session.id),
        builder: (context, session) {
          return AsyncBuilder<List<UserModel>>(
            stream: _sessionService.sessionMembersStream(session.id),
            builder: (context, members) {
              final manageableMembers = members
                  .where((member) => member.id != session.userId)
                  .toList();

              if (manageableMembers.isEmpty) {
                return _buildEmptyState(context);
              }

              return ListView(
                children: [
                  _buildSelectAllTile(context, session, manageableMembers),
                  for (final member in manageableMembers)
                    _buildMemberTile(context, session, member),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.admin_panel_settings_outlined,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            const Gap(16),
            Text(
              'No members to manage yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const Gap(8),
            Text(
              'Invite people to the session to grant them admin rights',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withValues(
                  alpha: 0.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectAllTile(
    BuildContext context,
    Session session,
    List<UserModel> members,
  ) {
    final everyoneIsAdmin = members.every(
      (member) => session.isAdmin(member.id),
    );

    return CheckboxListTile(
      value: everyoneIsAdmin,
      controlAffinity: ListTileControlAffinity.trailing,
      title: Text(everyoneIsAdmin ? 'Unselect all' : 'Select all'),
      onChanged: (_) => everyoneIsAdmin
          ? _sessionService.clearAdmins(session)
          : _sessionService.makeAllMembersAdmins(session),
    );
  }

  Widget _buildMemberTile(
    BuildContext context,
    Session session,
    UserModel member,
  ) {
    return UserListTile(
      user: member,
      trailing: Switch(
        value: session.isAdmin(member.id),
        onChanged: (value) => value
            ? _sessionService.addAdminToSession(
                session: session,
                userId: member.id,
              )
            : _sessionService.removeAdminFromSession(
                session: session,
                userId: member.id,
              ),
      ),
    );
  }
}
