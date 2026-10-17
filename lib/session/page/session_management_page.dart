import 'package:flutter/material.dart';
import 'package:remembeer/common/widget/error_message_box.dart';
import 'package:remembeer/common/widget/page_template.dart';
import 'package:remembeer/convex_api/widgets/session.dart';
import 'package:remembeer/convex_api/widgets/sessionMember.dart';
import 'package:remembeer/routes.dart';
import 'package:remembeer/session/widget/section_header.dart';

class SessionManagementPage extends StatelessWidget {
  const SessionManagementPage({super.key});

  @override
  Widget build(BuildContext context) => PageTemplate(
    title: const Text('Sessions'),
    actions: [
      IconButton(
        tooltip: 'Create session',
        icon: const Icon(Icons.add),
        onPressed: () => const CreateSessionRoute().push<void>(context),
      ),
    ],
    child: SessionMemberListInvitationsQuery(
      builder: (context, invitations) => SessionListCurrentQuery(
        builder: (context, sessions) => ListView(
          children: [
            if (invitations.isNotEmpty)
              const SectionHeader(title: 'Invitations'),
            for (final invitation in invitations)
              SessionMemberAcceptMutation(
                builder: (context, accept, acceptState) =>
                    SessionMemberDeclineMutation(
                      builder: (context, decline, declineState) => Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(invitation.session.name),
                              trailing: Wrap(
                                children: [
                                  TextButton(
                                    onPressed:
                                        acceptState.isLoading ||
                                            declineState.isLoading
                                        ? null
                                        : () => accept.run(
                                            sessionId: invitation.session.id,
                                          ),
                                    child: const Text('Accept'),
                                  ),
                                  TextButton(
                                    onPressed:
                                        acceptState.isLoading ||
                                            declineState.isLoading
                                        ? null
                                        : () => decline.run(
                                            sessionId: invitation.session.id,
                                          ),
                                    child: const Text('Decline'),
                                  ),
                                ],
                              ),
                            ),
                            if (acceptState.error ?? declineState.error
                                case final error?)
                              ErrorMessageBox(message: error.toString()),
                          ],
                        ),
                      ),
                    ),
              ),
            const SectionHeader(title: 'Your sessions'),
            if (sessions.isEmpty)
              const ListTile(
                title: Text(
                  'No sessions yet. Create one or accept an invitation.',
                ),
              ),
            for (final session in sessions)
              Card(
                child: ListTile(
                  leading: Icon(
                    session.isParty ? Icons.celebration : Icons.table_bar,
                  ),
                  title: Text(session.name),
                  subtitle: Text(session.endedAt == null ? 'Ongoing' : 'Ended'),
                  onTap: () => ActivitySessionRoute(
                    sessionId: session.id.value,
                  ).push<void>(context),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
