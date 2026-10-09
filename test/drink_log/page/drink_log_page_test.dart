import 'dart:async';
import 'package:dartvex/dartvex.dart';
import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/drinkLog.dart' as logs;
import 'package:remembeer/drink_log/page/add_drink_log_page.dart';
import 'package:remembeer/drink_log/page/drink_log_page.dart';
import 'package:remembeer/drink_log/page/update_drink_log_page.dart';
import 'package:remembeer/drink_log/service/drink_log_service.dart';
import 'package:remembeer/drink_log/widget/drink_log_group_section.dart';
import 'package:remembeer/drink_log/widget/midnight_divider.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/location/service/location_service.dart';
import 'package:toastification/toastification.dart';

void main() {
  testWidgets(
    'selected day is local and Today refreshes on tab entry and resume',
    (tester) async {
      final client = _Runtime()..emptyLogs = true;
      final api = _Mutations();
      final active = ValueNotifier(true);
      get
        ..registerSingleton(ConvexApi(api))
        ..registerSingleton<DrinkLogService>(_Logs());
      addTearDown(get.reset);
      await tester.pumpWidget(
        ConvexProvider(
          client: client,
          child: MaterialApp(
            home: ValueListenableBuilder<bool>(
              valueListenable: active,
              builder: (context, enabled, child) =>
                  TickerMode(enabled: enabled, child: child!),
              child: const DrinkLogPage(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(client.requests.length, 1);
      expect(client.requests.last.args.containsKey('date'), isFalse);
      expect(client.requests.last.args['at'], isA<double>());
      await tester.tap(find.byIcon(Icons.chevron_left));
      await tester.pumpAndSettle();
      expect(client.requests.last.args['date'], '2025-12-31');
      expect(find.text('Return to today'), findsOneWidget);
      expect(client.requests.length, 2);

      active.value = false;
      await tester.pump();
      client.today = '2026-01-02';
      active.value = true;
      await tester.pumpAndSettle();
      expect(client.requests.length, 3);
      expect(client.requests.last.args['date'], '2025-12-31');
      await tester.tap(find.text('Return to today'));
      await tester.pumpAndSettle();
      expect(client.requests.last.args.containsKey('date'), isFalse);
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Return to today'), findsNothing);

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      client.today = '2026-01-03';
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pumpAndSettle();
      expect(client.requests.length, 5);
      expect(client.requests.last.args.containsKey('date'), isFalse);
      expect(find.text('Today'), findsOneWidget);
      await tester.pump(const Duration(days: 1));
      expect(client.requests.length, 5);
      await tester.pumpWidget(const SizedBox.shrink());
      active.dispose();
      await client.events.close();
    },
  );

  testWidgets('daily list, add, edit and delete use the generated Convex API', (
    tester,
  ) async {
    final mutations = _Mutations();
    final client = _Runtime()
      ..mutations = mutations
      ..sessionId = 'unavailable-session'
      ..availableSessions = [
        {
          '_id': 'session',
          '_creationTime': 1,
          'ownerId': 'user',
          'kind': 'session',
          'name': 'Evening session',
          'description': '',
          'startedAt': 1,
          'endedAt': null,
          'updatedAt': 1,
          'deletedAt': null,
        },
      ];
    final quickAdds = _Logs();
    get
      ..registerSingleton<DrinkLogService>(quickAdds)
      ..registerSingleton(ConvexApi(mutations))
      ..registerSingleton(LocationService());
    addTearDown(get.reset);
    final router = GoRouter(
      initialLocation: '/drink-logs',
      routes: [
        GoRoute(
          path: '/drink-logs',
          builder: (context, state) => const DrinkLogPage(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) => const AddDrinkLogPage(),
            ),
            GoRoute(
              path: ':drinkLogId/edit',
              builder: (context, state) => UpdateDrinkLogPage(
                log: state.extra as logs.ListForDayResultLogsItem?,
              ),
            ),
          ],
        ),
      ],
    );
    await tester.pumpWidget(
      ConvexProvider(
        client: client,
        child: ToastificationWrapper(
          child: MaterialApp.router(routerConfig: router),
        ),
      ),
    );
    await tester.pump();
    expect(client.requests.single.name, 'drinkLog:listForDay');
    expect(client.requests.single.args.containsKey('date'), isFalse);
    expect(client.requests.single.args['at'], isA<double>());
    client.emit();
    await tester.pumpAndSettle();
    expect(find.text('Recorded beer'), findsOneWidget);
    expect(find.text('Unavailable drink'), findsOneWidget);
    client
      ..name = 'Edited beer'
      ..emit();
    await tester.pumpAndSettle();
    expect(find.text('Edited beer'), findsOneWidget);

    await tester.longPress(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    expect(quickAdds.count, 1);
    expect(find.text('Drinks'), findsOneWidget);
    expect(find.byType(AddDrinkLogPage), findsNothing);

    await tester.tap(find.text('Edited beer'));
    await tester.pumpAndSettle();
    expect(find.text('Catalogue beer'), findsOneWidget);
    expect(find.text('Previous session (unavailable)'), findsOneWidget);
    await tester.tap(find.widgetWithText(TextFormField, 'Volume (ml)'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Volume (ml)'),
      '330',
    );
    await tester.pumpAndSettle();
    while (find.byTooltip('Next field').evaluate().isNotEmpty) {
      await tester.tap(find.byTooltip('Next field'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.byTooltip('Submit'));
    await tester.pumpAndSettle();
    expect(mutations.name, 'drinkLog:update');
    expect(mutations.args['id'], 'log');
    expect(mutations.args['drinkId'], 'drink');
    expect(mutations.args['volumeMl'], 330);
    expect(mutations.args['location'], isNull);
    expect(mutations.args.containsKey('sessionId'), isFalse);
    expect(find.text('Drinks'), findsOneWidget);
    await tester.tap(find.byTooltip('Delete drink').first);
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
    await tester.pumpAndSettle();
    expect(mutations.name, 'drinkLog:softDelete');
    expect(mutations.args, {'id': 'log'});
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextFormField, 'Volume (ml)'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Volume (ml)'),
      '250',
    );
    await tester.tap(find.byType(DropdownButtonFormField<SessionId>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Evening session').last);
    await tester.pumpAndSettle();
    await tester.pumpAndSettle();
    while (find.byTooltip('Next field').evaluate().isNotEmpty) {
      await tester.tap(find.byTooltip('Next field'));
      await tester.pumpAndSettle();
    }
    await tester.tap(find.byTooltip('Submit'));
    await tester.pumpAndSettle();
    expect(mutations.name, 'drinkLog:create');
    expect(mutations.args['drinkId'], 'drink');
    expect(mutations.args['volumeMl'], 250);
    expect(mutations.args['sessionId'], 'session');
    expect(mutations.args['location'], isNull);
    expect(mutations.args['consumedAt'], isA<double>());
    expect(find.text('Drinks'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    router.dispose();
    await client.events.close();
  });

  testWidgets('drag drinks into empty sessions and back out across midnight', (
    tester,
  ) async {
    final mutations = _Mutations();
    final client = _Runtime()
      ..crossesMidnight = true
      ..sessions = [
        {
          '_id': 'session',
          'kind': 'session',
          'name': 'Evening session',
          'description': '',
          'startedAtLocal': '2026-01-01T20:00:00',
          'endedAtLocal': null,
        },
      ];
    get
      ..registerSingleton(ConvexApi(mutations))
      ..registerSingleton<DrinkLogService>(_Logs());
    addTearDown(get.reset);
    await tester.pumpWidget(
      ConvexProvider(
        client: client,
        child: const MaterialApp(home: DrinkLogPage()),
      ),
    );
    await tester.pump();
    client.emit();
    await tester.pumpAndSettle();
    expect(find.byType(MidnightDivider), findsOneWidget);
    final section = tester.widget<DrinkLogGroupSection>(
      find.byType(DrinkLogGroupSection).first,
    );
    final material = tester.widget<Material>(
      find
          .descendant(
            of: find.byType(DrinkLogGroupSection).first,
            matching: find.byType(Material),
          )
          .first,
    );
    expect(section.logs, isEmpty);
    expect(
      (material.shape! as RoundedRectangleBorder).side,
      isNot(BorderSide.none),
    );

    Future<void> moveTo(Finder target) async {
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Recorded beer')),
      );
      await tester.pump(const Duration(milliseconds: 600));
      await gesture.moveTo(tester.getCenter(target));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();
    }

    await moveTo(find.text('Evening session'));
    expect(mutations.name, 'drinkLog:update');
    expect(mutations.args, {'id': 'log', 'sessionId': 'session'});
    client
      ..sessionId = 'session'
      ..emit();
    await tester.pumpAndSettle();
    expect(find.byType(MidnightDivider), findsNothing);
    mutations.name = null;
    await moveTo(find.text('Evening session'));
    expect(mutations.name, isNull);
    await moveTo(find.text('Other drinks'));
    expect(mutations.args, {'id': 'log', 'sessionId': null});
    client
      ..sessionId = null
      ..emit();
    await tester.pumpAndSettle();
    expect(find.byType(MidnightDivider), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await client.events.close();
  });

  testWidgets(
    'sessions group my drinks, retain empty groups and react to access changes',
    (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final client = _Runtime()
        ..sessionId = 'session'
        ..sessions = [
          {
            '_id': 'session',
            'kind': 'session',
            'name': 'Evening session',
            'description': 'Session description',
            'startedAtLocal': '2026-01-01T06:00:00',
            'endedAtLocal': null,
          },
          {
            '_id': 'party',
            'kind': 'party',
            'name': 'Empty party',
            'description': '',
            'startedAtLocal': '2026-01-01T20:00:00',
            'endedAtLocal': '2026-01-02T02:00:00',
          },
        ];
      get
        ..registerSingleton(ConvexApi(_Mutations()))
        ..registerSingleton<DrinkLogService>(_Logs());
      addTearDown(get.reset);
      await tester.pumpWidget(
        ConvexProvider(
          client: client,
          child: const MaterialApp(home: DrinkLogPage()),
        ),
      );
      await tester.pump();
      client.emit();
      await tester.pumpAndSettle();
      expect(find.text('Evening session'), findsOneWidget);
      expect(find.text('Party · Empty party'), findsOneWidget);
      expect(find.text('1 drink this day'), findsOneWidget);
      expect(find.text('0 drinks this day'), findsOneWidget);
      expect(find.text('Recorded beer'), findsOneWidget);
      expect(find.text('Unavailable drink'), findsOneWidget);
      final sections = tester
          .widgetList<DrinkLogGroupSection>(find.byType(DrinkLogGroupSection))
          .toList();
      expect(sections.map((section) => section.logs.length), [1, 0, 1]);
      expect(sections.last.session, isNull);
      expect(sections.last.logs.single.sessionId?.value, 'inaccessible');
      await tester.tap(find.text('Evening session'));
      await tester.pumpAndSettle();
      expect(find.text('Session description'), findsOneWidget);
      expect(find.text('Started Jan 1, 2026 06:00'), findsOneWidget);
      expect(find.text('Still going'), findsOneWidget);
      await tester.tap(find.text('Party · Empty party'));
      await tester.pumpAndSettle();
      expect(find.text('Ended Jan 2, 2026 02:00'), findsOneWidget);

      client.sessions = [client.sessions.last];
      client.emit();
      await tester.pumpAndSettle();
      expect(find.text('Evening session'), findsNothing);
      expect(find.text('Recorded beer'), findsOneWidget);
      expect(find.text('Unavailable drink'), findsOneWidget);
      final other = tester
          .widgetList<DrinkLogGroupSection>(find.byType(DrinkLogGroupSection))
          .last;
      expect(other.logs.map((log) => log.id.value), ['log', 'missing']);

      client
        ..emptyLogs = true
        ..emit();
      await tester.pumpAndSettle();
      expect(find.text('Party · Empty party'), findsOneWidget);
      expect(find.text('No drinks recorded for this day.'), findsOneWidget);
      expect(find.text('Other drinks'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await client.events.close();
    },
  );
}

Map<String, dynamic> _drink(String name) => {
  '_id': 'drink',
  '_creationTime': 1,
  'ownerId': null,
  'name': name,
  'drinkCategory': {'kind': 'beer'},
  'alcoholPercentage': 5,
  'updatedAt': 1,
  'deletedAt': null,
};

class _Runtime implements ConvexRuntimeClient {
  var emptyLogs = false;
  var crossesMidnight = false;
  _Mutations? mutations;
  List<Map<String, dynamic>> sessions = [];
  List<Map<String, dynamic>> availableSessions = [];
  String? sessionId;
  var today = '2026-01-01';

  String get date {
    final selected =
        requests
                .lastWhere((request) => request.name == 'drinkLog:listForDay')
                .args['date']
            as String?;
    return selected == null || selected.compareTo(today) > 0 ? today : selected;
  }

  @override
  ConvexConnectionState get currentConnectionState =>
      ConvexConnectionState.connected;
  final events = StreamController<ConvexRuntimeQueryEvent>.broadcast();
  final requests = <({String name, Map<String, dynamic> args})>[];
  var name = 'Recorded beer';

  void emit() => events.add(
    ConvexRuntimeQuerySuccess({
      'today': today,
      'date': date,
      'sessions': sessions,
      'logs': [
        if (!emptyLogs)
          for (final missing in [false, true])
            {
              '_id': missing ? 'missing' : 'log',
              '_creationTime': 1,
              'userId': 'user',
              'sessionId': missing ? 'inaccessible' : sessionId,
              'drinkId': missing ? 'missing-drink' : 'drink',
              'consumedAt': DateTime.utc(2026, 1, 1, 5).millisecondsSinceEpoch,
              'consumedAtLocal': crossesMidnight
                  ? missing
                        ? '2026-01-01T23:00:00'
                        : '2026-01-02T02:00:00'
                  : '2026-01-01T06:00:00',
              'volumeMl': 500,
              'location': null,
              'updatedAt': 1,
              'deletedAt': null,
              'drink': missing ? null : _drink(name),
            },
      ],
    }),
  );

  @override
  ConvexRuntimeSubscription subscribe(
    String name, [
    Map<String, dynamic> args = const {},
  ]) {
    requests.add((name: name, args: args));
    if (name == 'drinkLog:listForDay') {
      if (emptyLogs) {
        return _Subscription(
          Stream.value(
            ConvexRuntimeQuerySuccess({
              'today': today,
              'date': date,
              'sessions': sessions,
              'logs': <Object?>[],
            }),
          ),
        );
      }
      return _Subscription(events.stream);
    }
    if (name == 'user:current') {
      return _Subscription(
        Stream.value(
          const ConvexRuntimeQuerySuccess({
            '_id': 'user',
            '_creationTime': 1,
            'authUserId': 'auth',
            'username': 'User',
            'normalizedUsername': 'user',
            'accentColor': 'amber',
            'avatarUrl': null,
            'defaultDrink': 'drink',
            'timeZone': 'Europe/Prague',
            'endOfDayBoundary': 360,
            'drinkLogSortOrder': 'desc',
          }),
        ),
      );
    }
    if (name == 'session:listCurrent') {
      return _Subscription(
        Stream.value(ConvexRuntimeQuerySuccess(availableSessions)),
      );
    }
    if (name == 'drink:listAvailable') {
      return _Subscription(
        Stream.value(ConvexRuntimeQuerySuccess([_drink('Catalogue beer')])),
      );
    }
    throw StateError('Unexpected query: $name');
  }

  @override
  Future<dynamic> mutate(
    String name, [
    Map<String, dynamic> args = const {},
    OptimisticUpdate? optimisticUpdate,
  ]) async => mutations!.mutate(name, args);

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Subscription implements ConvexRuntimeSubscription {
  _Subscription(this.stream);

  @override
  final Stream<ConvexRuntimeQueryEvent> stream;

  @override
  void cancel() {}
}

class _Logs implements DrinkLogService {
  var count = 0;

  @override
  Future<void> addDefaultDrinkLog() async => count++;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Mutations implements ConvexFunctionCaller {
  String? name;
  Map<String, dynamic> args = {};

  @override
  Future<dynamic> mutate(
    String name, [
    Map<String, dynamic> args = const {},
  ]) async {
    this.name = name;
    this.args = args;
    return name == 'drinkLog:create' ? 'created-log' : null;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
