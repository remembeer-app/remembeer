import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/session/widget/session_divider.dart';

void main() {
  testWidgets('session drawers expand independently', (tester) async {
    get.registerSingleton<SessionService>(_FakeSessionService(isOwner: true));
    addTearDown(get.reset);

    final firstSession = _session(
      id: 'first',
      name: 'First session',
      description: 'First description',
      memberIds: const {'owner', 'friend'},
    );
    final secondSession = _session(
      id: 'second',
      name: 'Second session',
      description: 'Second description',
      memberIds: const {'owner'},
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView(
            children: [
              SessionDivider(session: firstSession),
              SessionDivider(session: secondSession),
            ],
          ),
        ),
      ),
    );

    expect(find.text('First description'), findsNothing);
    expect(find.text('Second description'), findsNothing);
    expect(find.text('18:30 - ongoing'), findsNWidgets(2));

    await tester.tap(find.text('First session'));
    await tester.pumpAndSettle();

    expect(find.text('First description'), findsOneWidget);
    expect(find.text('2 members'), findsOneWidget);
    expect(find.text('Second description'), findsNothing);
    expect(find.text('Add friends'), findsOneWidget);
    expect(find.text('Edit session'), findsOneWidget);

    await tester.tap(find.text('Second session'));
    await tester.pumpAndSettle();

    expect(find.text('First description'), findsOneWidget);
    expect(find.text('Second description'), findsOneWidget);

    await tester.tap(find.text('First session'));
    await tester.pumpAndSettle();

    expect(find.text('First description'), findsNothing);
    expect(find.text('Second description'), findsOneWidget);
  });

  testWidgets('edit action is hidden from non-owners', (tester) async {
    get.registerSingleton<SessionService>(_FakeSessionService(isOwner: false));
    addTearDown(get.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SessionDivider(
            session: _session(
              id: 'guest',
              name: "Someone else's session",
              description: '',
              memberIds: const {'owner', 'guest'},
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text("Someone else's session"));
    await tester.pumpAndSettle();

    expect(find.text('Add friends'), findsOneWidget);
    expect(find.text('Edit session'), findsNothing);
  });
}

Session _session({
  required String id,
  required String name,
  required String description,
  required Set<String> memberIds,
}) {
  final startedAt = DateTime(2026, 8, 22, 18, 30);

  return Session(
    id: id,
    userId: 'owner',
    createdAt: startedAt,
    updatedAt: startedAt,
    memberIds: memberIds,
    adminIds: const {'owner'},
    bannedMemberIds: const {},
    name: name,
    startedAt: startedAt,
    isSoloSession: false,
    description: description,
  );
}

class _FakeSessionService implements SessionService {
  final bool isOwner;

  _FakeSessionService({required this.isOwner});

  @override
  bool isSessionOwner(Session session) => isOwner;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
