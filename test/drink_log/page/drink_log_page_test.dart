import 'dart:async';
import 'package:dartvex/dartvex.dart';
import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/convex_api/modules/drinkLog.dart' as logs;
import 'package:remembeer/date/service/date_service.dart';
import 'package:remembeer/date/type/date_state.dart';
import 'package:remembeer/drink_log/page/add_drink_log_page.dart';
import 'package:remembeer/drink_log/page/drink_log_page.dart';
import 'package:remembeer/drink_log/page/update_drink_log_page.dart';
import 'package:remembeer/drink_log/service/drink_log_service.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/location/service/location_service.dart';
import 'package:toastification/toastification.dart';

void main() {
  testWidgets('daily list, add, edit and delete use the generated Convex API', (
    tester,
  ) async {
    final client = _Runtime();
    final mutations = _Mutations();
    get
      ..registerSingleton<DateService>(_Dates())
      ..registerSingleton<DrinkLogService>(_Logs())
      ..registerSingleton(ConvexApi(mutations))
      ..registerSingleton(LocationService());
    addTearDown(get.reset);
    final router = GoRouter(
      initialLocation: '/drink-logs',
      routes: [
        GoRoute(
          path: '/drink-logs',
          builder: (context, state) => DrinkLogPage(),
          routes: [
            GoRoute(
              path: 'new',
              builder: (context, state) => AddDrinkLogPage(),
            ),
            GoRoute(
              path: ':drinkLogId/edit',
              builder: (context, state) => UpdateDrinkLogPage(
                log: state.extra as logs.ListForDayResultItem?,
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
    expect(client.requests.single.args, {'date': '2026-01-01'});
    client.emit();
    await tester.pumpAndSettle();
    expect(find.text('Recorded beer'), findsOneWidget);
    expect(find.text('Unavailable drink'), findsOneWidget);
    client
      ..name = 'Edited beer'
      ..emit();
    await tester.pumpAndSettle();
    expect(find.text('Edited beer'), findsOneWidget);

    await tester.tap(find.text('Edited beer'));
    await tester.pumpAndSettle();
    expect(find.text('Catalogue beer'), findsOneWidget);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Volume (ml)'),
      '330',
    );
    await tester.tap(find.text('Submit'));
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
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Volume (ml)'),
      '250',
    );
    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();
    expect(mutations.name, 'drinkLog:create');
    expect(mutations.args['drinkId'], 'drink');
    expect(mutations.args['volumeMl'], 250);
    expect(mutations.args['sessionId'], isNull);
    expect(mutations.args['location'], isNull);
    expect(mutations.args['consumedAt'], isA<double>());
    expect(find.text('Drinks'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    router.dispose();
    await client.events.close();
  });
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
  final events = StreamController<ConvexRuntimeQueryEvent>.broadcast();
  final requests = <({String name, Map<String, dynamic> args})>[];
  var name = 'Recorded beer';

  void emit() => events.add(
    ConvexRuntimeQuerySuccess([
      for (final missing in [false, true])
        {
          '_id': missing ? 'missing' : 'log',
          '_creationTime': 1,
          'userId': 'user',
          'sessionId': null,
          'drinkId': missing ? 'missing-drink' : 'drink',
          'consumedAt': DateTime.utc(2026, 1, 1, 5).millisecondsSinceEpoch,
          'consumedAtLocal': '2026-01-01T06:00:00',
          'volumeMl': 500,
          'location': null,
          'updatedAt': 1,
          'deletedAt': null,
          'drink': missing ? null : _drink(name),
        },
    ]),
  );

  @override
  ConvexRuntimeSubscription subscribe(
    String name, [
    Map<String, dynamic> args = const {},
  ]) {
    requests.add((name: name, args: args));
    if (name == 'drinkLog:listForDay') {
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
    if (name == 'drink:listAvailable') {
      return _Subscription(
        Stream.value(ConvexRuntimeQuerySuccess([_drink('Catalogue beer')])),
      );
    }
    throw StateError('Unexpected query: $name');
  }

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

class _Dates implements DateService {
  @override
  Stream<DateState> get selectedDateStateStream => Stream.value((
    selectedDate: DateTime.utc(2026),
    effectiveToday: DateTime.utc(2026),
  ));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Logs implements DrinkLogService {
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
