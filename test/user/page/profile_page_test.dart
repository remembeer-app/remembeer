import 'dart:async';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:remembeer/friend_request/page/friend_requests_page.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/user/page/friends_list_page.dart';
import 'package:remembeer/user/page/profile_page.dart';
import 'package:remembeer/user/page/search_user_page.dart';
import 'package:remembeer/user/service/user_stats_service.dart';
import 'package:remembeer/user/widget/social_section.dart';

void main() {
  setUp(() => get.registerSingleton(UserStatsService()));
  tearDown(get.reset);
  Future<void> mount(WidgetTester tester, _Client client, Widget page) async {
    tester.view.physicalSize = const Size(1000, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(client.dispose);
    await tester.pumpWidget(
      ConvexProvider(
        client: client,
        child: MaterialApp(home: page),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('own profile uses Convex identity and live friend counts', (
    tester,
  ) async {
    final client = _Client();
    await mount(tester, client, const ProfilePage());
    expect(find.text('Owner'), findsOneWidget);
    expect(
      tester.widget<SocialSection>(find.byType(SocialSection)).user.friends,
      {'friend'},
    );
    expect(find.text('Day Streak'), findsOneWidget);
    expect(find.text('Badges'), findsOneWidget);
    expect(find.text('Consumption Stats'), findsOneWidget);
    expect(find.text('Last 30 Days'), findsOneWidget);
    expect(find.text('Total Lifetime'), findsOneWidget);
    expect(find.text('No badges yet'), findsOneWidget);
    expect(find.byIcon(Icons.edit), findsOneWidget);
    expect(find.text('View 1 friend request(s)'), findsOneWidget);
    expect(
      client.requests.any((request) => request.name == 'user:get'),
      isFalse,
    );
    client.responses['friendship:listCurrent'] = <Object?>[];
    client.emit('friendship:listCurrent');
    await tester.pumpAndSettle();
    expect(
      tester.widget<SocialSection>(find.byType(SocialSection)).user.friends,
      isEmpty,
    );
    client.responses['badge:listCurrent'] = [
      {
        '_id': 'badge',
        '_creationTime': 1,
        'userId': 'owner',
        'badgeKey': 'centurion',
        'unlockedAt': 1,
        'isShown': true,
      },
    ];
    client.emit('badge:listCurrent');
    await tester.pumpAndSettle();
    expect(find.text('Centurion'), findsOneWidget);
  });

  testWidgets('profile actions send, cancel and accept using Convex IDs', (
    tester,
  ) async {
    final client = _Client();
    await mount(tester, client, const ProfilePage(userId: 'friend'));
    expect(find.text('Friend'), findsOneWidget);
    for (final (status, label, mutation) in [
      ('notFriends', 'Add as friend', 'friendship:sendRequest'),
      ('requestSent', 'Revoke sent request', 'friendship:cancel'),
      ('requestReceived', 'Accept request', 'friendship:accept'),
    ]) {
      client.responses['friendship:getStatus'] = status;
      client.emit('friendship:getStatus');
      await tester.pumpAndSettle();
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();
      expect(client.last.name, mutation);
      expect(client.last.args, <String, dynamic>{'userId': 'friend'});
    }
  });

  testWidgets('unfriend requires confirmation and server errors stay visible', (
    tester,
  ) async {
    final client = _Client()
      ..failMutation = true
      ..responses['friendship:getStatus'] = 'friends';
    await mount(tester, client, const ProfilePage(userId: 'friend'));
    await tester.tap(find.text('Remove friend'));
    await tester.pumpAndSettle();
    expect(client.last.name, isEmpty);
    await tester.tap(find.widgetWithText(FilledButton, 'Remove'));
    await tester.pumpAndSettle();
    expect(client.last.name, 'friendship:remove');
    expect(client.last.args, <String, dynamic>{'userId': 'friend'});
    expect(find.textContaining('Server rejected request'), findsWidgets);
    expect(find.text('Remove friend'), findsOneWidget);
  });

  testWidgets(
    'original request icons accept and deny incoming requests and update live',
    (tester) async {
      final client = _Client();
      await mount(tester, client, const FriendRequestsPage());
      expect(find.text('Friend'), findsOneWidget);
      expect(find.text('Other'), findsNothing);
      expect(find.byTooltip('Accept'), findsOneWidget);
      expect(find.byTooltip('Deny'), findsOneWidget);
      await tester.tap(find.byTooltip('Accept'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'friendship:accept');
      expect(client.last.args, <String, dynamic>{'userId': 'friend'});
      await tester.tap(find.byTooltip('Deny'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'friendship:accept');
      await tester.tap(find.widgetWithText(FilledButton, 'Deny'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'friendship:decline');
      expect(client.last.args, <String, dynamic>{'userId': 'friend'});
      client.responses['friendship:listRequests'] = <Object?>[];
      client.emit('friendship:listRequests');
      await tester.pumpAndSettle();
      expect(find.text('You have no pending friend requests.'), findsOneWidget);
    },
  );

  testWidgets('request errors do not hide pending actions', (tester) async {
    final client = _Client()..failMutation = true;
    await mount(tester, client, const FriendRequestsPage());
    await tester.tap(find.byTooltip('Accept'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Server rejected request'), findsWidgets);
    expect(find.text('Friend'), findsOneWidget);
    expect(find.text('Other'), findsNothing);
    expect(find.byTooltip('Accept'), findsOneWidget);
  });

  testWidgets(
    'friends list retains the original empty state and updates live',
    (tester) async {
      final client = _Client();
      await mount(tester, client, const FriendsListPage(userId: 'owner'));
      expect(find.text('Friend'), findsOneWidget);
      client.responses['friendship:listCurrent'] = <Object?>[];
      client.emit('friendship:listCurrent');
      await tester.pumpAndSettle();
      expect(find.text('This user has no friends yet.'), findsOneWidget);
      await tester.pumpWidget(
        ConvexProvider(
          client: client,
          child: const MaterialApp(home: FriendsListPage(userId: 'friend')),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('This user has no friends yet.'), findsOneWidget);
    },
  );

  testWidgets(
    'original debounced search opens a Convex profile without a submit button',
    (tester) async {
      final client = _Client();
      addTearDown(client.dispose);
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const SearchUserPage(),
          ),
          GoRoute(
            path: '/user/:userId',
            builder: (context, state) =>
                ProfilePage(userId: state.pathParameters['userId']),
          ),
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
      await tester.enterText(find.byType(TextField), 'ab');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(find.text('No users found.'), findsOneWidget);
      expect(find.text('Search by username or email'), findsOneWidget);
      expect(find.text('Find users'), findsNothing);
      expect(
        client.requests.where((request) => request.name == 'user:search'),
        isEmpty,
      );
      await tester.enterText(find.byType(TextField), '  Friend  ');
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pumpAndSettle();
      expect(client.requests.last.name, 'user:search');
      expect(client.requests.last.args, <String, dynamic>{
        'username': 'Friend',
      });
      await tester.tap(find.text('Friend'));
      await tester.pumpAndSettle();
      expect(
        client.requests
            .where((request) => request.name == 'user:get')
            .last
            .args,
        <String, dynamic>{'userId': 'friend'},
      );
      expect(find.text('Add as friend'), findsOneWidget);
    },
  );

  testWidgets('mutation buttons disable while a request is in flight', (
    tester,
  ) async {
    final client = _Client()..pendingMutation = Completer<Object?>();
    await mount(tester, client, const ProfilePage(userId: 'friend'));
    await tester.tap(find.text('Add as friend'));
    await tester.pump();
    expect(
      tester
          .widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Add as friend'),
          )
          .onPressed,
      isNull,
    );
    client.pendingMutation!.complete();
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<ElevatedButton>(
            find.widgetWithText(ElevatedButton, 'Add as friend'),
          )
          .onPressed,
      isNotNull,
    );
  });
}

const _user = <String, dynamic>{
  '_id': 'owner',
  '_creationTime': 1,
  'authUserId': 'auth-owner',
  'username': 'Owner',
  'normalizedUsername': 'owner',
  'accentColor': 'amber',
  'avatarUrl': null,
  'defaultDrink': null,
  'endOfDayBoundary': 360,
  'timeZone': 'Europe/Prague',
  'drinkLogSortOrder': 'desc',
};
const _friend = <String, dynamic>{
  '_id': 'friend',
  'username': 'Friend',
  'accentColor': 'amber',
  'avatarUrl': null,
};
Map<String, dynamic> _request(String id, String otherId, String senderId) => {
  'friendship': {
    '_id': id,
    '_creationTime': 1,
    'userAId': otherId,
    'userBId': 'owner',
    'requestedById': senderId,
    'status': 'pending',
    'updatedAt': 1,
  },
  'user': {
    ..._friend,
    '_id': otherId,
    'username': otherId == 'friend' ? 'Friend' : 'Other',
  },
};

class _Client implements ConvexRuntimeClient {
  final responses = <String, dynamic>{
    'user:current': _user,
    'badge:listCurrent': <Object?>[],
    'user:get': _friend,
    'user:search': [_friend],
    'friendship:getStatus': 'notFriends',
    'friendship:listCurrent': [_friend],
    'friendship:listRequests': [
      _request('incoming', 'friend', 'friend'),
      _request('outgoing', 'other', 'owner'),
    ],
  };
  final requests = <({String name, Map<String, dynamic> args})>[];
  final _events = <String, StreamController<ConvexRuntimeQueryEvent>>{};
  var failMutation = false;
  Completer<Object?>? pendingMutation;
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
    return pendingMutation?.future;
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
