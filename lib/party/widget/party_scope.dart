import 'package:flutter/material.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/sessionMember.dart';
import 'package:remembeer/convex_api/widgets/session.dart';
import 'package:remembeer/convex_api/widgets/sessionMember.dart';
import 'package:remembeer/convex_api/widgets/user.dart';

/// Supplies the current party and access information from Convex subscriptions.
class PartyScope extends StatelessWidget {
  const PartyScope({super.key, required this.sessionId, required this.builder});

  final String sessionId;
  final Widget Function(
    BuildContext,
    Party,
    UserId,
    List<ListForSessionResultItem>,
    bool,
  )
  builder;

  @override
  Widget build(BuildContext context) => SessionGetTypeQuery(
    id: SessionId(sessionId),
    builder: (context, session) {
      if (session is! Party) {
        return const Center(child: Text('This session is not a party.'));
      }
      return UserCurrentQuery(
        builder: (context, user) => SessionMemberListForSessionQuery(
          sessionId: session.id,
          builder: (context, members) => builder(
            context,
            session,
            user.id,
            members,
            session.ownerId == user.id ||
                members.any(
                  (entry) =>
                      entry.member.userId == user.id &&
                      entry.member.sessionMemberStatus.isJoined &&
                      entry.member.sessionMemberRole.isAdmin,
                ),
          ),
        ),
      );
    },
  );
}
