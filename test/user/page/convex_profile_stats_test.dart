import 'dart:async';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/user/page/profile_page.dart';
import 'package:remembeer/user/widget/profile_stats.dart';

void main() {
  Future<void> mount(WidgetTester tester, _Client client, Widget child) async {
    tester.view.physicalSize = const Size(1000, 2400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(client.dispose);
    await tester.pumpWidget(
      ConvexProvider(
        client: client,
        child: MaterialApp(home: child),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (final id in [null, 'other']) {
    testWidgets('profile $id displays live query totals and streak', (
      tester,
    ) async {
      final client = _Client();
      await mount(tester, client, ProfilePage(userId: id));
      final requests = client.requests.where(
        (request) => request.name == 'user:stats',
      );
      expect(requests.length, 1);
      expect(requests.single.args['userId'], id ?? 'owner');
      expect(find.text('7'), findsOneWidget);
      expect(find.text('1.2 L'), findsOneWidget);
      expect(find.text('20'), findsOneWidget);
      client.responses['user:stats'] = {
        ..._stats,
        'totalBeersConsumed': 21,
        'streakDays': 8,
      };
      client.emit('user:stats');
      await tester.pumpAndSettle();
      expect(find.text('21'), findsOneWidget);
      expect(find.text('8'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
    });
  }

  testWidgets('boundary and app resume refresh the stats subscription', (
    tester,
  ) async {
    final client = _Client();
    client.responses['user:stats'] = {
      ..._stats,
      'nextRefreshAt': DateTime.now()
          .add(const Duration(seconds: 2))
          .millisecondsSinceEpoch,
    };
    await mount(
      tester,
      client,
      ProfileStats(
        userId: const UserId('owner'),
        builder: (context, stats) => Text('${stats.streakDays}'),
      ),
    );
    int count() =>
        client.requests.where((request) => request.name == 'user:stats').length;
    expect(count(), 1);
    client.responses['user:stats'] = _stats;
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
    expect(count(), 2);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pumpAndSettle();
    expect(count(), 3);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

final _stats = <String, dynamic>{
  'totalBeersConsumed': 20,
  'totalAlcoholConsumed': 1200,
  'beersConsumedLast30Days': 3,
  'alcoholConsumedLast30Days': 75,
  'streakDays': 7,
  'isStreakActive': true,
  'nextRefreshAt': DateTime.now()
      .add(const Duration(days: 1))
      .millisecondsSinceEpoch,
};
const _user = <String, dynamic>{
  '_id': 'owner',
  '_creationTime': 1,
  'authUserId': 'auth',
  'username': 'Owner',
  'normalizedUsername': 'owner',
  'accentColor': 'amber',
  'avatarUrl': null,
  'defaultDrink': null,
  'endOfDayBoundary': 360,
  'timeZone': 'Europe/Prague',
  'drinkLogSortOrder': 'desc',
};

class _Client implements ConvexRuntimeClient {
  final responses = <String, dynamic>{
    'user:stats': _stats,
    'user:get': {
      '_id': 'other',
      'username': 'Other',
      'accentColor': 'amber',
      'avatarUrl': null,
    },
    'user:current': _user,
    'friendship:listCurrent': <Object?>[],
    'friendship:listRequests': <Object?>[],
    'badge:listCurrent': <Object?>[],
    'friendship:getStatus': 'notFriends',
  };
  final requests = <({String name, Map<String, dynamic> args})>[];
  final _events = <String, StreamController<ConvexRuntimeQueryEvent>>{};
  var failMutation = false;
  var last = (name: '', args: <String, dynamic>{});
  void emit(String name) =>
      _events[name]?.add(ConvexRuntimeQuerySuccess(responses[name]));
  @override
  Future<void> dispose() async {
    for (final stream in _events.values) {
      await stream.close();
    }
  }

  @override
  ConvexConnectionState get currentConnectionState =>
      ConvexConnectionState.connected;
  @override
  ConvexRuntimeSubscription subscribe(
    String name, [
    Map<String, dynamic> args = const {},
  ]) {
    requests.add((name: name, args: args));
    // Controllers in this map are closed by dispose.
    // ignore: close_sinks
    final events = _events.putIfAbsent(
      name,
      StreamController<ConvexRuntimeQueryEvent>.broadcast,
    );
    return _Subscription(
      Stream.multi((controller) {
        controller.add(ConvexRuntimeQuerySuccess(responses[name]));
        final subscription = events.stream.listen(controller.add);
        controller.onCancel = subscription.cancel;
      }),
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
    return null;
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
