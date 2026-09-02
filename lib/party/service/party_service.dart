import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/party/controller/party_controller.dart';
import 'package:remembeer/party/model/party.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/session/controller/session_controller.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:rxdart/rxdart.dart';

class PartyService {
  PartyService({
    required this.authService,
    required this.sessionController,
    required this.partyController,
  });

  final AuthService authService;
  final SessionController sessionController;
  final PartyController partyController;

  String get currentUserId => authService.authenticatedUser.uid;

  Stream<Session> sessionStream(String sessionId) =>
      sessionController.streamById(sessionId);

  Stream<Party> partyStream(String sessionId) =>
      partyController.partyStream(sessionId);

  Stream<List<PartyMember>> membersStream(String sessionId) =>
      partyController.membersStream(sessionId);

  Stream<PartyMember?> currentMemberStream(String sessionId) =>
      partyController.memberStream(sessionId, currentUserId);

  Future<void> activateParty(String sessionId) async {
    await partyController.activateParty(
      sessionId: sessionId,
      commandId: partyController.generateCommandId(),
    );
  }

  Future<void> selectClass(
    String sessionId,
    DrinkCategory selectedClass,
  ) async {
    await partyController.selectPartyClass(
      sessionId: sessionId,
      commandId: partyController.generateCommandId(),
      selectedClass: selectedClass,
    );
  }

  Future<void> setMemberClass(
    String sessionId,
    String memberId,
    DrinkCategory selectedClass,
  ) async {
    await partyController.setPartyMemberClass(
      sessionId: sessionId,
      commandId: partyController.generateCommandId(),
      memberId: memberId,
      selectedClass: selectedClass,
    );
  }

  Stream<PartyState> stateStream(String sessionId) =>
      Rx.combineLatest2(
        sessionStream(sessionId),
        partyStream(sessionId),
        (session, party) => (session: session, party: party),
      ).switchMap((data) {
        final session = data.session;
        final party = data.party;
        final userId = currentUserId;
        final isMember = session.memberIds.contains(userId);
        final memberStream = isMember
            ? partyController.memberStream(sessionId, userId)
            : Stream<PartyMember?>.value(null);

        return memberStream.map((member) {
          final access = !isMember
              ? PartyAccess.nonMember
              : session.userId == userId || session.adminIds.contains(userId)
              ? PartyAccess.admin
              : PartyAccess.member;
          final lifecycle =
              party.status == PartyStatus.archived || session.endedAt != null
              ? PartyLifecycle.archived
              : PartyLifecycle.active;
          return PartyState(
            session: session,
            party: party,
            currentMember: member,
            access: access,
            lifecycle: lifecycle,
          );
        });
      }).distinct();
}
