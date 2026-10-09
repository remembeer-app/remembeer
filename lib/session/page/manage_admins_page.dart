import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/widgets/session.dart';
import 'package:remembeer/convex_api/widgets/sessionMember.dart';
import 'package:remembeer/convex_api/widgets/user.dart';

class ManageAdminsPage extends StatelessWidget {
  const ManageAdminsPage({super.key, required this.sessionId});
  final String sessionId;

  @override
  Widget build(BuildContext context) => PageTemplate(
    title: const Text('Manage Admins'),
    child: SessionGetTypeQuery(
      id: SessionId(sessionId),
      builder: (context, session) => UserCurrentQuery(
        builder: (context, user) {
          if (session.ownerId != user.id) {
            return const Center(
              child: Text('Only the owner can manage admins.'),
            );
          }
          return SessionMemberListForSessionQuery(
            sessionId: session.id,
            builder: (context, members) => SessionMemberSetRoleMutation(
              builder: (context, setRole, snapshot) {
                final joined = members
                    .where(
                      (member) =>
                          member.userId != session.ownerId &&
                          member.sessionMemberStatus.isJoined,
                    )
                    .toList();
                return ListView(
                  children: [
                    if (snapshot.error case final error?)
                      ErrorMessageBox(message: error.toString()),
                    if (joined.isEmpty)
                      const ListTile(
                        title: Text('No joined members to manage yet.'),
                      ),
                    for (final member in joined)
                      SwitchListTile(
                        title: Text(member.username),
                        value: member.sessionMemberRole.isAdmin,
                        onChanged: snapshot.isLoading
                            ? null
                            : (value) => setRole.run(
                                sessionId: session.id,
                                userId: member.userId,
                                role: value ? const Admin() : const Member(),
                              ),
                      ),
                  ],
                );
              },
            ),
          );
        },
      ),
    ),
  );
}
