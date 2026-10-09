import 'package:dartvex/dartvex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/drink_log/service/drink_log_service.dart';
import 'package:remembeer/location/service/location_service.dart';
import 'package:toastification/toastification.dart';

void main() {
  testWidgets(
    'quick add uses catalogue category volume and handles missing defaults',
    (tester) async {
      await tester.pumpWidget(
        const ToastificationWrapper(child: MaterialApp(home: Scaffold())),
      );
      addTearDown(toastification.dismissAll);
      final caller = _Caller();
      final service = DrinkLogService(
        api: ConvexApi(caller),
        locationService: _NoLocation(),
      );
      for (final entry in {'beer': 500, 'spirit': 40, 'wine': 200}.entries) {
        caller.category = entry.key;
        await service.addDefaultDrinkLog();
        expect(caller.mutations.last.name, 'drinkLog:create');
        expect(caller.mutations.last.args['volumeMl'], entry.value);
        expect(caller.mutations.last.args['drinkId'], 'drink');
        expect(caller.mutations.last.args['sessionId'], isNull);
        expect(caller.mutations.last.args['location'], isNull);
      }
      caller.defaultDrink = null;
      final count = caller.mutations.length;
      await expectLater(service.addDefaultDrinkLog(), throwsStateError);
      expect(caller.mutations, hasLength(count));
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
    },
  );
}

class _Caller implements ConvexFunctionCaller {
  var category = 'beer';
  String? defaultDrink = 'drink';
  final mutations = <({String name, Map<String, dynamic> args})>[];

  @override
  Future<dynamic> query(
    String name, [
    Map<String, dynamic> args = const {},
  ]) async {
    if (name == 'user:current') {
      return {
        '_id': 'user',
        '_creationTime': 1,
        'authUserId': 'auth',
        'username': 'User',
        'normalizedUsername': 'user',
        'accentColor': 'amber',
        'avatarUrl': null,
        'defaultDrink': defaultDrink,
        'timeZone': 'Europe/Prague',
        'endOfDayBoundary': 360,
        'drinkLogSortOrder': 'desc',
      };
    }
    if (name == 'drink:listAvailable') {
      return [
        {
          '_id': 'drink',
          '_creationTime': 1,
          'ownerId': null,
          'name': 'Default',
          'drinkCategory': {'kind': category},
          'alcoholPercentage': 5,
          'updatedAt': 1,
          'deletedAt': null,
        },
      ];
    }
    throw StateError('Unexpected query: $name');
  }

  @override
  Future<dynamic> mutate(
    String name, [
    Map<String, dynamic> args = const {},
  ]) async {
    mutations.add((name: name, args: args));
    return name == 'drinkLog:create' ? 'log' : null;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _NoLocation implements LocationService {
  @override
  Future<Position?> getLastPositionIfAllowed() async => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
