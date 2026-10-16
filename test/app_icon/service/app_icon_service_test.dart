import 'dart:async';

import 'package:dartvex/dartvex.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/app_icon/service/app_icon_service.dart';
import 'package:remembeer/auth/service/convex_auth_service.dart';
import 'package:remembeer/convex_api/api.dart';

void main() {
  testWidgets(
    'live consumption, rollover, resume and sign-out update the icon',
    (tester) async {
      final auth = _Auth();
      final caller = _Caller();
      final phases = <String>[];
      const channel = MethodChannel('app_icon');
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(channel, (
        call,
      ) async {
        phases.add(
          (call.arguments as Map<Object?, Object?>)['phase']! as String,
        );
        return null;
      });
      final service = AppIconService(authService: auth, api: ConvexApi(caller));
      addTearDown(() {
        service.dispose();
        auth.dispose();
        tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          channel,
          null,
        );
      });
      addTearDown(caller.dispose);
      service
        ..initialize()
        ..initialize();
      await tester.pump();
      expect(phases, ['a']);
      expect(caller.requests, isEmpty);

      auth.signInLocally();
      await tester.pump();
      expect(caller.requests, hasLength(1));
      caller.emit(50, after: const Duration(seconds: 2));
      await tester.pump();
      expect(phases, ['a', 'c']);
      caller.emit(51, after: const Duration(seconds: 2));
      await tester.pump();
      expect(phases, ['a', 'c']);
      await tester.pump(const Duration(seconds: 2));
      expect(caller.requests, hasLength(2));
      expect(
        caller.requests.last['refreshAt']! as double,
        greaterThan(caller.requests.first['refreshAt']! as double),
      );
      caller.emit(0);
      await tester.pump();
      expect(phases.last, 'a');

      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
      tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
      await tester.pump();
      expect(caller.requests, hasLength(3));
      caller.emit(500);
      await tester.pump();
      expect(phases.last, 'h');
      caller.events.add(const QueryError('Temporarily offline'));
      await tester.pump();
      expect(phases.last, 'h');
      auth.signOutLocally();
      await tester.pump();
      expect(phases.last, 'a');
      expect(caller.cancellations, 3);
      caller.emit(100);
      await tester.pump();
      expect(phases.last, 'a');
      service.dispose();
      auth.signInLocally();
      await tester.pump(const Duration(days: 1));
      expect(caller.requests, hasLength(3));
    },
  );
}

class _Auth extends ChangeNotifier implements ConvexAuthService {
  @override
  var isAuthenticated = false;

  void signInLocally() {
    isAuthenticated = true;
    notifyListeners();
  }

  void signOutLocally() {
    isAuthenticated = false;
    notifyListeners();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Caller implements ConvexFunctionCaller {
  final events = StreamController<QueryResult>.broadcast();
  final requests = <Map<String, dynamic>>[];
  var cancellations = 0;

  void emit(double alcoholMl, {Duration after = const Duration(hours: 1)}) {
    events.add(
      QuerySuccess({
        'alcoholConsumedMl': alcoholMl,
        'nextRefreshAt': DateTime.now().add(after).millisecondsSinceEpoch,
      }),
    );
  }

  @override
  ConvexSubscription subscribe(
    String name, [
    Map<String, dynamic> args = const {},
  ]) {
    expectSync(name, 'user:currentDayConsumption');
    requests.add(args);
    return ConvexSubscription(
      stream: events.stream,
      onCancel: () async => cancellations++,
    );
  }

  Future<void> dispose() => events.close();

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
