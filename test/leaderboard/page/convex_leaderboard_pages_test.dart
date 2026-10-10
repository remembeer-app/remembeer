import 'dart:async';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/leaderboard/page/create_leaderboard_page.dart';
import 'package:remembeer/leaderboard/page/join_leaderboard_page.dart';
import 'package:remembeer/leaderboard/page/leaderboard_detail_page.dart';
import 'package:remembeer/leaderboard/page/leaderboards_page.dart';
import 'package:remembeer/leaderboard/page/manage_leaderboard_page.dart';
import 'package:remembeer/leaderboard/page/update_leaderboard_name_page.dart';
import 'package:remembeer/leaderboard/service/month_service.dart';
import 'package:toastification/toastification.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late MonthService months;
  late _Client client;

  setUp(() {
    months = MonthService();
    client = _Client();
    get.registerSingleton(months);
  });
  tearDown(() async {
    await get.reset();
    await client.dispose();
  });

  Future<void> mount(WidgetTester tester, Widget page) async {
    tester.view.physicalSize = const Size(1000, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(toastification.dismissAll);
    await tester.pumpWidget(
      ConvexProvider(
        client: client,
        child: ToastificationWrapper(child: MaterialApp(home: page)),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> finish(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
    months.dispose();
    expect(client.activeSubscriptions, 0);
  }

  testWidgets(
    'list uses generated queries, live counts and current-user ranks',
    (tester) async {
      await mount(tester, const LeaderboardsPage());
      expect(find.text('Our board'), findsOneWidget);
      expect(find.text('2 members'), findsOneWidget);
      expect(find.text('#1'), findsOneWidget);
      expect(find.text('#2'), findsOneWidget);
      client.responses['leaderboard:listCurrent'] = [
        {'leaderboard': _board, 'memberCount': 3},
      ];
      client.emit('leaderboard:listCurrent');
      await tester.pumpAndSettle();
      expect(find.text('3 members'), findsOneWidget);
      await finish(tester);
    },
  );

  testWidgets(
    'create and rename submit generated mutations and display errors',
    (tester) async {
      client.failMutation = true;
      await mount(tester, const CreateLeaderboardPage());
      await tester.enterText(find.byType(TextFormField), 'New board');
      await tester.tap(find.widgetWithText(FilledButton, 'Create Leaderboard'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'leaderboard:create');
      expect(client.last.args, {'name': 'New board', 'iconName': 'trophy'});
      expect(find.textContaining('Server rejected request'), findsOneWidget);
      await mount(
        tester,
        const UpdateLeaderboardNamePage(leaderboardId: 'board'),
      );
      await tester.enterText(find.byType(TextFormField), 'Renamed');
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'leaderboard:update');
      expect(client.last.args, {'id': 'board', 'name': 'Renamed'});
      expect(find.textContaining('Server rejected request'), findsOneWidget);
      await finish(tester);
    },
  );

  testWidgets(
    'invite preview, full/banned joins and query errors use generated widgets',
    (tester) async {
      client.joinResult = 'full';
      await mount(tester, const JoinLeaderboardPage());
      Future<void> search() async {
        await tester.enterText(find.byType(TextFormField), 'ABCDEFGH');
        await tester.tap(find.text('Find Leaderboard'));
        await tester.pumpAndSettle();
      }

      await search();
      expect(client.requests.last.name, 'leaderboard:findByInviteCode');
      expect(client.requests.last.args, {'inviteCode': 'ABCDEFGH'});
      expect(find.text('2 members'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Join Leaderboard'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'leaderboard:join');
      expect(client.last.args, {'id': 'board'});
      expect(find.text('Leaderboard is full.'), findsOneWidget);
      client.joinResult = 'banned';
      await search();
      await tester.tap(find.widgetWithText(FilledButton, 'Join Leaderboard'));
      await tester.pumpAndSettle();
      expect(
        find.text('You are banned from this leaderboard.'),
        findsOneWidget,
      );
      client.queryErrors.add('leaderboard:findByInviteCode');
      await search();
      expect(find.textContaining('Query rejected'), findsOneWidget);
      client.queryErrors.clear();
      client.responses['leaderboard:findByInviteCode'] = null;
      await search();
      expect(find.text('No leaderboard found with this code.'), findsOneWidget);
      client.responses['leaderboard:findByInviteCode'] = {
        'id': 'board',
        'name': 'Our board',
        'iconName': 'trophy',
        'memberCount': 2,
      };
      client.failMutation = true;
      await search();
      await tester.tap(find.widgetWithText(FilledButton, 'Join Leaderboard'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Server rejected request'), findsOneWidget);
      client.failMutation = false;
      await search();
      expect(
        find.widgetWithText(FilledButton, 'Join Leaderboard'),
        findsOneWidget,
      );
      await finish(tester);
    },
  );

  testWidgets(
    'owner management uses generated remove/ban/unban/delete/icon mutations',
    (tester) async {
      client.failMutation = true;
      await mount(tester, const ManageLeaderboardPage(leaderboardId: 'board'));
      expect(find.text('Members (2)'), findsOneWidget);
      expect(find.text('Banned (1)'), findsOneWidget);
      expect(find.text('Member'), findsOneWidget);
      Future<void> confirm(String button) async {
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(FilledButton, button));
        await tester.pumpAndSettle();
      }

      await tester.tap(find.byIcon(Icons.person_remove));
      await confirm('Remove');
      expect(client.last.name, 'leaderboard:remove');
      expect(client.last.args, {'id': 'board', 'userId': 'member'});
      expect(find.textContaining('Server rejected request'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.block));
      await confirm('Ban');
      expect(client.last.name, 'leaderboard:ban');
      expect(client.last.args, {'id': 'board', 'userId': 'member'});
      await tester.tap(find.byTooltip('Unban'));
      await confirm('Unban');
      expect(client.last.name, 'leaderboard:unban');
      expect(client.last.args, {'id': 'board', 'userId': 'banned'});
      await tester.tap(find.text('Delete Leaderboard'));
      await confirm('Delete');
      expect(client.last.name, 'leaderboard:softDelete');
      expect(client.last.args, {'id': 'board'});
      await tester.tap(find.byIcon(Icons.emoji_events));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.star));
      await tester.tap(find.widgetWithText(FilledButton, 'Save'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'leaderboard:update');
      expect(client.last.args, {'id': 'board', 'iconName': 'star'});
      expect(find.textContaining('Server rejected request'), findsWidgets);
      await finish(tester);
    },
  );

  testWidgets(
    'standings sorting and month navigation keep generated query arguments',
    (tester) async {
      await mount(tester, const LeaderboardDetailPage(leaderboardId: 'board'));
      expect(find.text('January 2026'), findsOneWidget);
      expect(find.text('3.0 beers'), findsOneWidget);
      final next = tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.chevron_right),
      );
      expect(next.onPressed, isNull);
      await tester.tap(find.text('Alcohol'));
      await tester.pumpAndSettle();
      expect(find.text('75.0 ml'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();
      expect(
        client.requests
            .lastWhere((request) => request.name == 'leaderboard:standings')
            .args['month'],
        '2025-12',
      );
      expect(find.text('December 2025'), findsOneWidget);
      client
        ..currentMonth = '2026-02'
        ..emit('leaderboard:standings');
      await tester.pumpAndSettle();
      expect(find.text('December 2025'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();
      expect(find.text('January 2026'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.chevron_right));
      await tester.pumpAndSettle();
      expect(find.text('February 2026'), findsOneWidget);
      expect(
        client.requests
            .lastWhere((request) => request.name == 'leaderboard:standings')
            .args
            .containsKey('month'),
        isFalse,
      );
      await finish(tester);
    },
  );

  testWidgets(
    'rollover and resume refresh generated queries without advancing historical selection',
    (tester) async {
      await mount(tester, const LeaderboardDetailPage(leaderboardId: 'board'));
      final firstRefresh = client.requests
          .lastWhere((request) => request.name == 'leaderboard:standings')
          .args['refreshAt'];
      client.currentMonth = '2026-02';
      months.updateReportingMonth(
        '2026-01',
        DateTime.now().millisecondsSinceEpoch,
      );
      await tester.pumpAndSettle();
      expect(find.text('February 2026'), findsOneWidget);
      expect(
        client.requests
            .lastWhere((request) => request.name == 'leaderboard:standings')
            .args['refreshAt'],
        isNot(firstRefresh),
      );
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();
      final beforeResume = client.requests
          .lastWhere((request) => request.name == 'leaderboard:standings')
          .args['refreshAt'];
      client.currentMonth = '2026-03';
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(find.text('January 2026'), findsOneWidget);
      expect(
        client.requests
            .lastWhere((request) => request.name == 'leaderboard:standings')
            .args['refreshAt'],
        isNot(beforeResume),
      );
      await finish(tester);
    },
  );

  testWidgets(
    'leave/delete navigate after success even when the detail query loses access',
    (tester) async {
      Future<void> mountRouted(Widget page) async {
        final router = GoRouter(
          initialLocation: '/leaderboards/board',
          routes: [
            GoRoute(
              path: '/leaderboards',
              builder: (_, _) =>
                  const Scaffold(body: Text('Back to leaderboards')),
            ),
            GoRoute(path: '/leaderboards/board', builder: (_, _) => page),
          ],
        );
        addTearDown(router.dispose);
        await tester.pumpWidget(
          ConvexProvider(
            client: client,
            child: MaterialApp.router(routerConfig: router),
          ),
        );
        await tester.pumpAndSettle();
      }

      client.currentUserId = 'member';
      await mountRouted(const LeaderboardDetailPage(leaderboardId: 'board'));
      await tester.tap(find.byIcon(Icons.logout));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Leave'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'leaderboard:leave');
      expect(find.text('Back to leaderboards'), findsOneWidget);
      client
        ..currentUserId = 'owner'
        ..queryErrors.clear();
      await tester.pumpWidget(const SizedBox.shrink());
      await mountRouted(const ManageLeaderboardPage(leaderboardId: 'board'));
      await tester.tap(find.text('Delete Leaderboard'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'leaderboard:softDelete');
      expect(find.text('Back to leaderboards'), findsOneWidget);
      await finish(tester);
    },
  );
}

const _board = <String, dynamic>{
  '_id': 'board',
  '_creationTime': 1,
  'ownerId': 'owner',
  'name': 'Our board',
  'iconName': 'trophy',
  'inviteCode': 'ABCDEFGH',
  'timeZone': 'Europe/Prague',
  'endOfDayBoundary': 360,
  'updatedAt': 1,
  'deletedAt': null,
};
Map<String, dynamic> _profile(String id, String name) => {
  '_id': id,
  'username': name,
  'avatarUrl': null,
  'accentColor': 'amber',
};

class _Client implements ConvexRuntimeClient {
  final responses = <String, dynamic>{
    'leaderboard:listCurrent': [
      {'leaderboard': _board, 'memberCount': 2},
    ],
    'leaderboard:get': {
      'leaderboard': _board,
      'members': [_profile('owner', 'Owner'), _profile('member', 'Member')],
      'bannedMembers': [_profile('banned', 'Banned')],
    },
    'leaderboard:findByInviteCode': {
      'id': 'board',
      'name': 'Our board',
      'iconName': 'trophy',
      'memberCount': 2,
    },
  };
  final requests = <({String name, Map<String, dynamic> args})>[];
  final queryErrors = <String>{};
  final _events = <String, StreamController<void>>{};
  var currentUserId = 'owner';
  var currentMonth = '2026-01';
  var joinResult = 'success';
  var failMutation = false;
  var activeSubscriptions = 0;
  var last = (name: '', args: <String, dynamic>{});

  Object? _response(String name, Map<String, dynamic> args) => switch (name) {
    'leaderboard:standings' => {
      'currentMonth': currentMonth,
      'month': args['month'] ?? currentMonth,
      'nextMonthAt': DateTime.now()
          .add(const Duration(days: 30))
          .millisecondsSinceEpoch,
      'entries': [
        {
          'user': _profile(currentUserId, 'Owner'),
          'beersConsumed': 3,
          'alcoholConsumedMl': 75,
          'rankByBeers': 1,
          'rankByAlcohol': 2,
        },
      ],
    },
    'user:current' => {
      ..._profile(currentUserId, 'Owner'),
      '_creationTime': 1,
      'authUserId': 'auth',
      'normalizedUsername': 'owner',
      'defaultDrink': null,
      'endOfDayBoundary': 0,
      'timeZone': 'Asia/Tokyo',
      'drinkLogSortOrder': 'desc',
    },
    _ => responses[name],
  };
  ConvexRuntimeQueryEvent _event(String name, Map<String, dynamic> args) =>
      queryErrors.contains(name)
      ? const ConvexRuntimeQueryError('Query rejected')
      : ConvexRuntimeQuerySuccess(_response(name, args));
  void emit(String name) => _events[name]?.add(null);

  @override
  ConvexConnectionState get currentConnectionState =>
      ConvexConnectionState.connected;
  @override
  ConvexRuntimeSubscription subscribe(
    String name, [
    Map<String, dynamic> args = const {},
  ]) {
    requests.add((name: name, args: args));
    activeSubscriptions++;
    // Controllers are closed by dispose.
    // ignore: close_sinks
    final events = _events.putIfAbsent(name, StreamController<void>.broadcast);
    return _Subscription(
      Stream.multi((controller) {
        controller.add(_event(name, args));
        final listener = events.stream.listen(
          (_) => controller.add(_event(name, args)),
        );
        controller.onCancel = listener.cancel;
      }),
      () => activeSubscriptions--,
    );
  }

  @override
  Future<dynamic> mutate(
    String name, [
    Map<String, dynamic> args = const {},
    OptimisticUpdate? optimisticUpdate,
  ]) async {
    last = (name: name, args: args);
    if (failMutation) throw Exception('Server rejected request');
    if (name == 'leaderboard:leave' || name == 'leaderboard:softDelete') {
      queryErrors.add('leaderboard:get');
      emit('leaderboard:get');
    }
    return switch (name) {
      'leaderboard:create' => 'created',
      'leaderboard:join' => joinResult,
      _ => null,
    };
  }

  @override
  Future<void> dispose() async {
    for (final events in _events.values) {
      await events.close();
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Subscription implements ConvexRuntimeSubscription {
  _Subscription(this.stream, this._onCancel);
  @override
  final Stream<ConvexRuntimeQueryEvent> stream;
  final void Function() _onCancel;
  var _cancelled = false;
  @override
  void cancel() {
    if (!_cancelled) {
      _cancelled = true;
      _onCancel();
    }
  }
}
