import 'dart:async';

import 'package:dartvex/dartvex.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/auth/service/convex_auth_service.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/date/service/date_service.dart';
import 'package:remembeer/date/type/date_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test(
    'calendar selection follows server Today and resets after authentication changes',
    () async {
      final caller = _DayCaller();
      final auth = _Auth();
      final service = DateService(api: ConvexApi(caller), authService: auth);
      final states = <DateState>[];
      final listener = service.selectedDateStateStream.listen(states.add);
      await Future<void>.delayed(Duration.zero);
      caller.emit('2026-01-02');
      await Future<void>.delayed(Duration.zero);
      expect(states.last.selectedDate, DateTime.utc(2026, 1, 2));
      service.previousDay();
      await Future<void>.delayed(Duration.zero);
      expect(states.last.selectedDate, DateTime.utc(2026));
      service.nextDay();
      await Future<void>.delayed(Duration.zero);
      service.setDate(DateTime(2026, 1, 3));
      await Future<void>.delayed(Duration.zero);
      expect(states.last.selectedDate, DateTime.utc(2026, 1, 2));
      caller.emit('2026-01-03');
      await Future<void>.delayed(Duration.zero);
      expect(states.last.selectedDate, DateTime.utc(2026, 1, 3));
      service.previousDay();
      await Future<void>.delayed(Duration.zero);
      auth.notifyListeners();
      await Future<void>.delayed(Duration.zero);
      expect(caller.subscriptions, 2);
      caller.emit('2026-01-04');
      await Future<void>.delayed(Duration.zero);
      expect(states.last.selectedDate, DateTime.utc(2026, 1, 4));
      await listener.cancel();
      service.dispose();
      auth.dispose();
      await Future<void>.delayed(Duration.zero);
    },
  );
}

class _DayCaller implements ConvexFunctionCaller {
  late StreamController<QueryResult> _events;
  var subscriptions = 0;

  void emit(String today) => _events.add(
    QuerySuccess({
      'today': today,
      'nextBoundary': DateTime.now()
          .add(const Duration(hours: 1))
          .millisecondsSinceEpoch,
    }),
  );

  @override
  ConvexSubscription subscribe(
    String name, [
    Map<String, dynamic> args = const {},
  ]) {
    if (name != 'drinkLog:dayContext') {
      throw StateError('Unexpected subscription: $name');
    }
    subscriptions++;
    _events = StreamController<QueryResult>();
    final events = _events;
    return ConvexSubscription(stream: events.stream, onCancel: events.close);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Auth extends ChangeNotifier implements ConvexAuthService {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
