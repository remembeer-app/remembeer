import 'package:remembeer/party/model/party.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/session/model/session.dart';

enum PartyAccess { nonMember, member, admin }

enum PartyLifecycle { active, archived }

class PartyState {
  const PartyState({
    required this.session,
    required this.party,
    required this.access,
    required this.lifecycle,
    this.currentMember,
  });

  final Session session;
  final Party party;
  final PartyMember? currentMember;
  final PartyAccess access;
  final PartyLifecycle lifecycle;

  bool get isMember => access != PartyAccess.nonMember;
  bool get isAdmin => access == PartyAccess.admin;
  bool get isActive => lifecycle == PartyLifecycle.active;
  bool get isArchived => lifecycle == PartyLifecycle.archived;
}
