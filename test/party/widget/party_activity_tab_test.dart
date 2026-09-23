import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/drink/model/drink_category.dart';
import 'package:remembeer/drink/model/drink_snapshot.dart';
import 'package:remembeer/drink_log/model/drink_log.dart';
import 'package:remembeer/party/model/party_event.dart';
import 'package:remembeer/party/model/party_event_page.dart';
import 'package:remembeer/party/service/party_activity_service.dart';
import 'package:remembeer/party/widget/party_activity_tab.dart';
import 'package:remembeer/user/model/user_model.dart';

void main() {
  testWidgets('refreshes when the session drink logs change', (tester) async {
    var fetches = 0;
    final drinkLogs = ValueNotifier<List<DrinkLog>>([_drinkLog('first')]);
    addTearDown(drinkLogs.dispose);
    final service = PartyActivityService(
      sessionId: 'party-1',
      fetchPage:
          ({
            required sessionId,
            required kinds,
            required participantIds,
            startAfter,
          }) async {
            fetches += 1;
            return const PartyEventPage(events: [], hasMore: false);
          },
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ValueListenableBuilder(
            valueListenable: drinkLogs,
            builder: (context, value, child) => PartyActivityTab(
              sessionId: 'party-1',
              members: const [_user],
              drinkLogs: value,
              currentUserId: 'user-1',
              isPartyActive: true,
              service: service,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(fetches, 1);

    drinkLogs.value = [_drinkLog('first'), _drinkLog('second')];
    await tester.pumpAndSettle();

    expect(fetches, 2);
  });

  testWidgets(
    'only current own drink revision edits and refreshes on success',
    (tester) async {
      var fetches = 0;
      final events = [
        _event('current', sourceId: 'current', revision: 2),
        _event('historic', sourceId: 'current', revision: 1),
        _event('other', sourceId: 'other', revision: 1, recipientId: 'other'),
        _event('deleted', sourceId: 'deleted', revision: 1),
        _event('reversed', sourceId: 'reversed', revision: 1),
        _event(
          'reversal',
          sourceId: 'reversed',
          revision: 1,
          kind: PartyEventKind.reversal,
          reversesEventId: 'reversed',
        ),
      ];
      final service = PartyActivityService(
        sessionId: 'party-1',
        fetchPage:
            ({
              required sessionId,
              required kinds,
              required participantIds,
              startAfter,
            }) async {
              fetches += 1;
              return PartyEventPage(events: events, hasMore: false);
            },
      );

      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => Scaffold(
              body: PartyActivityTab(
                sessionId: 'party-1',
                members: const [_user, _otherUser],
                drinkLogs: [
                  _drinkLog('current', revision: 2),
                  _drinkLog('other', ownerId: 'other'),
                  _drinkLog('reversed'),
                ],
                currentUserId: 'user-1',
                isPartyActive: true,
                service: service,
              ),
            ),
          ),
          GoRoute(
            path: '/drink-logs/sessions/:sessionId/drink-logs/:drinkLogId/edit',
            builder: (context, state) => Scaffold(
              body: FilledButton(
                onPressed: () => context.pop(true),
                child: Text(
                  'Save ${state.pathParameters['sessionId']}/'
                  '${state.pathParameters['drinkLogId']}',
                ),
              ),
            ),
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      expect(find.text('Edit'), findsOneWidget);
      await tester.tap(find.text('Edit'));
      await tester.pumpAndSettle();
      expect(find.text('Save party-1/current'), findsOneWidget);

      await tester.tap(find.text('Save party-1/current'));
      await tester.pumpAndSettle();

      expect(fetches, 2);
    },
  );

  testWidgets('archived Party activity does not expose drink editing', (
    tester,
  ) async {
    final service = PartyActivityService(
      sessionId: 'party-1',
      fetchPage:
          ({
            required sessionId,
            required kinds,
            required participantIds,
            startAfter,
          }) async => PartyEventPage(
            events: [_event('current', sourceId: 'current', revision: 2)],
            hasMore: false,
          ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: PartyActivityTab(
            sessionId: 'party-1',
            members: const [_user],
            drinkLogs: [_drinkLog('current', revision: 2)],
            currentUserId: 'user-1',
            isPartyActive: false,
            service: service,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Edit'), findsNothing);
  });
}

PartyEvent _event(
  String id, {
  required String sourceId,
  required int revision,
  String recipientId = 'user-1',
  PartyEventKind kind = PartyEventKind.drinkLog,
  String? reversesEventId,
}) => PartyEvent(
  id: id,
  kind: kind,
  recipientUserId: recipientId,
  participantIds: [recipientId],
  pointsUnits: kind == PartyEventKind.reversal ? -1000 : 1000,
  sourceCollection: PartyEventSourceCollection.drinkLogs,
  sourceId: sourceId,
  reversesEventId: reversesEventId,
  occurredAt: DateTime.utc(2026, 9, 2, 18, 30),
  createdAt: DateTime.utc(2026, 9, 2, 18, 30),
  payload: {'drinkName': 'Beer', 'revision': revision},
);

DrinkLog _drinkLog(String id, {int revision = 1, String ownerId = 'user-1'}) =>
    DrinkLog(
      id: id,
      consumedByUserId: ownerId,
      consumedAt: DateTime.utc(2026, 9, 2, 18, 30),
      drink: const DrinkSnapshot(
        name: 'Beer',
        category: DrinkCategory.beer,
        alcoholPercentage: 5,
      ),
      volumeInMilliliters: 500,
      partyRevision: revision,
    );

const _user = UserModel(
  id: 'user-1',
  email: 'user@example.com',
  username: 'User',
  searchableUsername: 'user',
);

const _otherUser = UserModel(
  id: 'other',
  email: 'other@example.com',
  username: 'Other',
  searchableUsername: 'other',
);
