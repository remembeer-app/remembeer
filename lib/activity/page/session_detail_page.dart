import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:remembeer/common/action/confirmation_dialog.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/widgets/session.dart';
import 'package:remembeer/convex_api/widgets/sessionMember.dart';
import 'package:remembeer/convex_api/widgets/user.dart';
import 'package:remembeer/routes.dart';

class SessionDetailPage extends StatelessWidget {
  const SessionDetailPage({super.key, required this.sessionId});
  final String sessionId;

  @override
  Widget build(BuildContext context) => PageTemplate(
    title: const Text('Session'),
    child: SessionGetTypeQuery(
      id: SessionId(sessionId),
      builder: (context, session) => UserCurrentQuery(
        builder: (context, user) => SessionMemberListForSessionQuery(
          sessionId: session.id,
          builder: (context, members) {
            final owner = user.id == session.ownerId;
            final admin =
                owner ||
                members.any(
                  (member) =>
                      member.userId == user.id &&
                      member.sessionMemberStatus.isJoined &&
                      member.sessionMemberRole.isAdmin,
                );
            return SessionMemberLeaveMutation(
              builder: (context, leave, snapshot) => ListView(
                children: [
                  Text(
                    session.isParty ? 'Party · ${session.name}' : session.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  if (session.description.isNotEmpty) ...[
                    const Gap(12),
                    Text(session.description),
                  ],
                  const Gap(12),
                  Text('Started ${_time(session.startedAt)}'),
                  Text(
                    session.endedAt == null
                        ? 'Still going'
                        : 'Ended ${_time(session.endedAt!)}',
                  ),
                  const Gap(16),
                  FilledButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add drink'),
                    onPressed: () => AddDrinkLogRoute(
                      targetSessionId: sessionId,
                    ).push<void>(context),
                  ),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.group),
                    label: const Text('Members'),
                    onPressed: () => AddSessionFriendsRoute(
                      sessionId: sessionId,
                    ).push<void>(context),
                  ),
                  if (admin)
                    OutlinedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit session'),
                      onPressed: () => EditSessionRoute(
                        sessionId: sessionId,
                      ).push<void>(context),
                    ),
                  if (!owner)
                    OutlinedButton.icon(
                      icon: const Icon(Icons.logout),
                      label: const Text('Leave session'),
                      onPressed: snapshot.isLoading
                          ? null
                          : () => showConfirmationDialog(
                              context: context,
                              title: 'Leave session',
                              text:
                                  'Leave this session? Your recorded drinks will be kept.',
                              submitButtonText: 'Leave',
                              isDestructive: true,
                              onPressed: () async {
                                leave.run(
                                  sessionId: session.id,
                                  onSuccess: (_) {
                                    if (context.mounted) {
                                      const SessionManagementRoute().go(
                                        context,
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                    ),
                  if (snapshot.error case final error?)
                    ErrorMessageBox(message: error.toString()),
                ],
              ),
            );
          },
        ),
      ),
    ),
  );

  String _time(double at) => DateFormat.yMMMd().add_Hm().format(
    DateTime.fromMillisecondsSinceEpoch(at.toInt()),
  );
}
