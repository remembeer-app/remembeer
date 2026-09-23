import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/party/model/party_tab.dart';
import 'package:remembeer/routes.dart';

void main() {
  test('Party route defaults to activity and restores another tab', () {
    expect(PartyTab.values, [
      PartyTab.ranking,
      PartyTab.activity,
      PartyTab.games,
    ]);
    expect(
      const PartyRoute(sessionId: 'session-1').location,
      '/drink-logs/parties/session-1',
    );
    expect(
      const PartyRoute(sessionId: 'session-1', tab: PartyTab.ranking).location,
      '/drink-logs/parties/session-1?tab=ranking',
    );
  });

  test('Party route remains nested in the DrinkLog branch', () {
    final shell = $navbarShellRouteData as StatefulShellRoute;
    final drinkLogRoute = shell.branches[2].routes.single as GoRoute;
    final partyRoute = drinkLogRoute.routes.whereType<GoRoute>().singleWhere(
      (route) => route.path == 'parties/:sessionId',
    );

    expect(drinkLogRoute.path, '/drink-logs');
    expect(partyRoute.path, 'parties/:sessionId');
  });

  test('nested Party routes preserve the selected tab', () {
    expect(
      const PartyManagementRoute(
        sessionId: 'session-1',
        tab: PartyTab.games,
      ).location,
      '/drink-logs/parties/session-1/manage?tab=games',
    );
    expect(
      const PartyQuestManagementRoute(
        sessionId: 'session-1',
        tab: PartyTab.games,
      ).location,
      '/drink-logs/parties/session-1/manage/quests?tab=games',
    );
    expect(
      const PartyQuestRoute(
        sessionId: 'session-1',
        questId: 'quest-1',
        tab: PartyTab.games,
      ).location,
      '/drink-logs/parties/session-1/quests/quest-1?tab=games',
    );
    expect(
      const PartyChallengeRoute(
        sessionId: 'session-1',
        challengeId: 'challenge-1',
        tab: PartyTab.ranking,
      ).location,
      '/drink-logs/parties/session-1/challenges/challenge-1?tab=ranking',
    );
    expect(
      const PartyTournamentRoute(
        sessionId: 'session-1',
        tournamentId: 'tournament-1',
        tab: PartyTab.games,
      ).location,
      '/drink-logs/parties/session-1/tournaments/tournament-1?tab=games',
    );
  });
}
