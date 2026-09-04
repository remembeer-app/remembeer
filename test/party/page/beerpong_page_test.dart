import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/party/model/beerpong_match.dart';
import 'package:remembeer/party/model/beerpong_team.dart';
import 'package:remembeer/party/model/beerpong_tournament.dart';
import 'package:remembeer/party/model/party.dart';
import 'package:remembeer/party/model/party_member.dart';
import 'package:remembeer/party/model/party_state.dart';
import 'package:remembeer/party/page/beerpong_page.dart';
import 'package:remembeer/party/service/beerpong_service.dart';
import 'package:remembeer/party/service/party_service.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:toastification/toastification.dart';

void main() {
  testWidgets('admin confirms a ready match result', (tester) async {
    final beerpongService = _FakeBeerpongService(_detail());
    await tester.pumpWidget(_page(_state(), beerpongService));
    await _settleStreams(tester);

    await tester.tap(find.text('Team One').last);
    await tester.pumpAndSettle();
    expect(find.text('Record Team One as winner?'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Record winner'));
    await tester.pumpAndSettle();
    expect(beerpongService.recordedWinnerId, 'team-1');
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
  });

  testWidgets('completed tournament is read-only', (tester) async {
    final tournament = _tournament(status: BeerpongTournamentStatus.completed);
    final detail = _detail(
      tournament: tournament,
      matches: const [
        BeerpongMatch(
          id: 'final',
          round: 1,
          position: 1,
          kind: BeerpongMatchKind.main,
          teamAId: 'team-1',
          teamBId: 'team-2',
          winnerTeamId: 'team-1',
          loserTeamId: 'team-2',
          status: BeerpongMatchStatus.completed,
        ),
      ],
    );
    await tester.pumpWidget(_page(_state(), _FakeBeerpongService(detail)));
    await _settleStreams(tester);

    expect(find.text('Finalized'), findsOneWidget);
    expect(find.text('Correct to this team'), findsNothing);
    expect(find.text('Finalize tournament and award points'), findsNothing);
  });

  testWidgets('archived tournament hides every mutation', (tester) async {
    await tester.pumpWidget(
      _page(_state(isArchived: true), _FakeBeerpongService(_detail())),
    );
    await _settleStreams(tester);

    expect(find.text('Archived'), findsOneWidget);
    expect(find.text('Correct to this team'), findsNothing);
    expect(find.text('Finalize tournament and award points'), findsNothing);
  });
}

Future<void> _settleStreams(WidgetTester tester) async {
  await tester.pump();
  await tester.pump();
  await tester.pump();
}

Widget _page(PartyState state, _FakeBeerpongService beerpongService) =>
    ToastificationWrapper(
      child: MaterialApp(
        home: BeerpongPage(
          sessionId: 'session-1',
          tournamentId: 'tournament-1',
          partyService: _FakePartyService(state),
          sessionService: _FakeSessionService(),
          beerpongService: beerpongService,
        ),
      ),
    );

PartyState _state({bool isArchived = false}) {
  final now = DateTime.utc(2026);
  final session = Session(
    id: 'session-1',
    userId: 'user-1',
    createdAt: now,
    updatedAt: now,
    memberIds: const {'user-1', 'user-2'},
    adminIds: const {},
    bannedMemberIds: const {},
    name: 'Party',
    startedAt: now,
    endedAt: isArchived ? now.add(const Duration(hours: 1)) : null,
    isSoloSession: false,
    isParty: true,
  );
  return PartyState(
    session: session,
    party: Party(
      id: session.id,
      sessionId: session.id,
      status: isArchived ? PartyStatus.archived : PartyStatus.active,
      activatedAt: now,
      activatedByUserId: 'user-1',
      activeTournamentId: 'tournament-1',
      createdAt: now,
      updatedAt: now,
    ),
    access: PartyAccess.admin,
    lifecycle: isArchived ? PartyLifecycle.archived : PartyLifecycle.active,
    currentMember: PartyMember(
      id: 'user-1',
      userId: 'user-1',
      joinedAt: now,
      updatedAt: now,
    ),
  );
}

BeerpongDetailState _detail({
  BeerpongTournament? tournament,
  List<BeerpongMatch>? matches,
}) => BeerpongDetailState(
  tournament: tournament ?? _tournament(),
  teams: _teams,
  matches:
      matches ??
      const [
        BeerpongMatch(
          id: 'final',
          round: 1,
          position: 1,
          kind: BeerpongMatchKind.main,
          teamAId: 'team-1',
          teamBId: 'team-2',
          status: BeerpongMatchStatus.ready,
        ),
      ],
);

BeerpongTournament _tournament({
  BeerpongTournamentStatus status = BeerpongTournamentStatus.active,
}) => BeerpongTournament(
  id: 'tournament-1',
  status: status,
  participantIds: const ['user-1', 'user-2'],
  teamCount: 2,
  firstPlacePointsUnits: 100000,
  secondPlacePointsUnits: 50000,
  thirdPlacePointsUnits: 25000,
  revision: 3,
  randomSeedHash: 'hash',
  createdByUserId: 'user-1',
  createdAt: DateTime.utc(2026),
);

const _teams = [
  BeerpongTeam(id: 'team-1', name: 'Team One', memberIds: ['user-1'], seed: 1),
  BeerpongTeam(id: 'team-2', name: 'Team Two', memberIds: ['user-2'], seed: 2),
];

const _users = [
  UserModel(
    id: 'user-1',
    email: 'one@example.com',
    username: 'Player One',
    searchableUsername: 'player one',
  ),
  UserModel(
    id: 'user-2',
    email: 'two@example.com',
    username: 'Player Two',
    searchableUsername: 'player two',
  ),
];

class _FakePartyService implements PartyService {
  _FakePartyService(this.state);

  final PartyState state;

  @override
  Stream<PartyState> stateStream(String sessionId) => Stream.value(state);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeSessionService implements SessionService {
  @override
  Stream<List<UserModel>> sessionMembersStream(String sessionId) =>
      Stream.value(_users);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeBeerpongService implements BeerpongService {
  _FakeBeerpongService(this.detail);

  final BeerpongDetailState detail;
  String? recordedWinnerId;

  @override
  Stream<BeerpongDetailState> detailStateStream(
    String sessionId,
    String tournamentId,
  ) => Stream.value(detail);

  @override
  Future<void> recordResult({
    required String sessionId,
    required String tournamentId,
    required int expectedRevision,
    required String matchId,
    required String winnerTeamId,
  }) async {
    recordedWinnerId = winnerTeamId;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
