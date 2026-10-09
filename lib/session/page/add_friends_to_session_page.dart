import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/widgets/session.dart';
import 'package:remembeer/convex_api/widgets/sessionMember.dart';
import 'package:remembeer/convex_api/widgets/user.dart';
import 'package:remembeer/session/extension/session_member_status_extension.dart';
import 'package:remembeer/session/widget/section_header.dart';
import 'package:remembeer/user/constants.dart';

class AddFriendsToSessionPage extends StatefulWidget {
  const AddFriendsToSessionPage({super.key, required this.sessionId});
  final String sessionId;

  @override
  State<AddFriendsToSessionPage> createState() =>
      _AddFriendsToSessionPageState();
}

class _AddFriendsToSessionPageState extends State<AddFriendsToSessionPage> {
  final _usernameController = TextEditingController();
  String? _username;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _findUser() {
    final username = _usernameController.text.trim();
    if (username.length >= minUsernameLength &&
        username.length <= maxUsernameLength) {
      setState(() => _username = username);
    }
  }

  @override
  Widget build(BuildContext context) => PageTemplate(
    title: const Text('Session Members'),
    child: SessionGetTypeQuery(
      id: SessionId(widget.sessionId),
      builder: (context, session) => UserCurrentQuery(
        builder: (context, user) => SessionMemberListForSessionQuery(
          sessionId: session.id,
          builder: (context, members) {
            final isOwner = user.id == session.ownerId;
            final isAdmin =
                isOwner ||
                members.any(
                  (member) =>
                      member.userId == user.id &&
                      member.sessionMemberStatus.isJoined &&
                      member.sessionMemberRole.isAdmin,
                );
            return SessionMemberInviteMutation(
              builder: (context, invite, inviteState) => SessionMemberRemoveMutation(
                builder: (context, remove, removeState) => SessionMemberBanMutation(
                  builder: (context, ban, banState) => SessionMemberUnbanMutation(
                    builder: (context, unban, unbanState) {
                      final busy =
                          inviteState.isLoading ||
                          removeState.isLoading ||
                          banState.isLoading ||
                          unbanState.isLoading;
                      return ListView(
                        children: [
                          if (inviteState.error ??
                                  removeState.error ??
                                  banState.error ??
                                  unbanState.error
                              case final error?)
                            ErrorMessageBox(message: error.toString()),
                          if (isAdmin) ...[
                            const Text(
                              'Invite someone by their full username.',
                            ),
                            const Gap(12),
                            TextField(
                              controller: _usernameController,
                              onSubmitted: (_) => _findUser(),
                              maxLength: maxUsernameLength,
                              decoration: const InputDecoration(
                                labelText: 'Username',
                                helperText:
                                    'At least $minUsernameLength characters',
                              ),
                            ),
                            FilledButton(
                              onPressed: busy ? null : _findUser,
                              child: const Text('Find users'),
                            ),
                            if (_username case final username?)
                              SessionMemberFindInviteeQuery(
                                sessionId: session.id,
                                username: username,
                                builder: (context, users) => Column(
                                  children: [
                                    if (users.isEmpty)
                                      const ListTile(
                                        title: Text('No matching users.'),
                                      ),
                                    for (final invitee in users)
                                      ListTile(
                                        title: Text(invitee.username),
                                        trailing: TextButton(
                                          onPressed:
                                              busy ||
                                                  invitee.id ==
                                                      session.ownerId ||
                                                  members.any(
                                                    (m) =>
                                                        m.userId ==
                                                            invitee.id &&
                                                        (m
                                                                .sessionMemberStatus
                                                                .isJoined ||
                                                            m
                                                                .sessionMemberStatus
                                                                .isInvited ||
                                                            m
                                                                .sessionMemberStatus
                                                                .isBanned),
                                                  )
                                              ? null
                                              : () => invite.run(
                                                  sessionId: session.id,
                                                  userId: invitee.id,
                                                  onSuccess: (_) =>
                                                      showSuccessNotification(
                                                        'Invitation sent.',
                                                      ),
                                                ),
                                          child: const Text('Invite'),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                          ],
                          const SectionHeader(title: 'Members'),
                          for (final member in members)
                            ListTile(
                              title: Text(member.username),
                              subtitle: Text(
                                '${member.sessionMemberStatus.label}${member.sessionMemberRole.isAdmin ? ' · Admin' : ''}${member.userId == session.ownerId ? ' · Owner' : ''}',
                              ),
                              trailing:
                                  !isAdmin ||
                                      member.userId == session.ownerId ||
                                      (!isOwner &&
                                          member.sessionMemberRole.isAdmin)
                                  ? null
                                  : PopupMenuButton<String>(
                                      enabled: !busy,
                                      itemBuilder: (context) => [
                                        if (member.sessionMemberStatus.isLeft ||
                                            member
                                                .sessionMemberStatus
                                                .isDeclined)
                                          const PopupMenuItem(
                                            value: 'invite',
                                            child: Text('Invite again'),
                                          ),
                                        if (member
                                                .sessionMemberStatus
                                                .isJoined ||
                                            member
                                                .sessionMemberStatus
                                                .isInvited)
                                          const PopupMenuItem(
                                            value: 'remove',
                                            child: Text('Remove'),
                                          ),
                                        if (member.sessionMemberStatus.isBanned)
                                          const PopupMenuItem(
                                            value: 'unban',
                                            child: Text('Unban'),
                                          )
                                        else
                                          const PopupMenuItem(
                                            value: 'ban',
                                            child: Text('Ban'),
                                          ),
                                      ],
                                      onSelected: (action) {
                                        if (action == 'invite') {
                                          invite.run(
                                            sessionId: session.id,
                                            userId: member.userId,
                                          );
                                          return;
                                        }
                                        if (action == 'unban') {
                                          unban.run(
                                            sessionId: session.id,
                                            userId: member.userId,
                                          );
                                          return;
                                        }
                                        showConfirmationDialog(
                                          context: context,
                                          title: action == 'ban'
                                              ? 'Ban member'
                                              : 'Remove member',
                                          text:
                                              '${action == 'ban' ? 'Ban' : 'Remove'} ${member.username} from this session?',
                                          submitButtonText: action == 'ban'
                                              ? 'Ban'
                                              : 'Remove',
                                          isDestructive: true,
                                          onPressed: () async {
                                            if (action == 'ban') {
                                              ban.run(
                                                sessionId: session.id,
                                                userId: member.userId,
                                              );
                                            } else {
                                              remove.run(
                                                sessionId: session.id,
                                                userId: member.userId,
                                              );
                                            }
                                          },
                                        );
                                      },
                                    ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
