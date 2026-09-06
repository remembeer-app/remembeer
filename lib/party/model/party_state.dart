import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:remembeer/party/model/party.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/session/model/session.dart';

enum PartyAccess { nonMember, member, admin }

enum PartyLifecycle { active, archived }

@immutable
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartyState &&
          runtimeType == other.runtimeType &&
          session == other.session &&
          party == other.party &&
          currentMember == other.currentMember &&
          access == other.access &&
          lifecycle == other.lifecycle;

  @override
  int get hashCode =>
      session.hashCode ^
      party.hashCode ^
      currentMember.hashCode ^
      access.hashCode ^
      lifecycle.hashCode;
}
