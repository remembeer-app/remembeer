import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/drink/model/drink.dart';
import 'package:remembeer/drink_type/model/drink_category.dart';
import 'package:remembeer/drink_type/model/drink_type_core.dart';
import 'package:remembeer/party/model/party_event.dart';
import 'package:remembeer/party/model/party_event_page.dart';
import 'package:remembeer/party/service/party_activity_service.dart';
import 'package:remembeer/party/widget/party_activity_tab.dart';
import 'package:remembeer/user/model/user_model.dart';

void main() {
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
                drinks: [
                  _drink('current', revision: 2),
                  _drink('other', ownerId: 'other'),
                  _drink('reversed'),
                ],
                currentUserId: 'user-1',
                isPartyActive: true,
                service: service,
              ),
            ),
          ),
          GoRoute(
            path: '/drink/sessions/:sessionId/drinks/:drinkId/edit',
            builder: (context, state) => Scaffold(
              body: FilledButton(
                onPressed: () => context.pop(true),
                child: Text(
                  'Save ${state.pathParameters['sessionId']}/'
                  '${state.pathParameters['drinkId']}',
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
            drinks: [_drink('current', revision: 2)],
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
  PartyEventKind kind = PartyEventKind.drink,
  String? reversesEventId,
}) => PartyEvent(
  id: id,
  kind: kind,
  recipientUserId: recipientId,
  participantIds: [recipientId],
  pointsUnits: kind == PartyEventKind.reversal ? -1000 : 1000,
  sourceCollection: PartyEventSourceCollection.drinks,
  sourceId: sourceId,
  reversesEventId: reversesEventId,
  occurredAt: DateTime.utc(2026, 9, 2, 18, 30),
  createdAt: DateTime.utc(2026, 9, 2, 18, 30),
  payload: {'drinkName': 'Beer', 'revision': revision},
);

Drink _drink(String id, {int revision = 1, String ownerId = 'user-1'}) => Drink(
  id: id,
  consumedByUserId: ownerId,
  consumedAt: DateTime.utc(2026, 9, 2, 18, 30),
  drinkType: const DrinkTypeCore(
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
