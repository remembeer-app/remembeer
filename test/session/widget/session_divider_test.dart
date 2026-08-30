import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/session/model/session.dart';
import 'package:remembeer/session/service/session_service.dart';
import 'package:remembeer/session/widget/session_divider.dart';
import 'package:remembeer/user/model/user_model.dart';
import 'package:remembeer/user/service/user_service.dart';

void main() {
  testWidgets('session drawers expand independently', (tester) async {
    get
      ..registerSingleton<SessionService>(_FakeSessionService(isOwner: true))
      ..registerSingleton<UserService>(_FakeUserService());
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
    await tester.pump();

    expect(find.text('First description'), findsNothing);
    expect(find.text('Second description'), findsNothing);
    expect(find.textContaining('still going'), findsNWidgets(2));

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
    get
      ..registerSingleton<SessionService>(_FakeSessionService(isOwner: false))
      ..registerSingleton<UserService>(_FakeUserService());
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

  testWidgets('multi-day session shows only its start date', (tester) async {
    get
      ..registerSingleton<SessionService>(_FakeSessionService(isOwner: true))
      ..registerSingleton<UserService>(_FakeUserService());
    addTearDown(get.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SessionDivider(
            session: _session(
              id: 'multi-day',
              name: 'Multi-day session',
              description: '',
              memberIds: const {'owner'},
              endedAt: DateTime(2026, 8, 23, 8),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('22. Aug'), findsOneWidget);
    expect(find.textContaining('18:30'), findsNothing);
  });
}

Session _session({
  required String id,
  required String name,
  required String description,
  required Set<String> memberIds,
  DateTime? endedAt,
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
    endedAt: endedAt,
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

class _FakeUserService implements UserService {
  @override
  Stream<UserModel> get currentUserStream => Stream.value(
    const UserModel(
      id: 'owner',
      email: 'owner@example.com',
      username: 'Owner',
      searchableUsername: 'owner',
    ),
  );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
