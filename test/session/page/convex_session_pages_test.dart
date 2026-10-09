import 'dart:async';

import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/session/page/add_friends_to_session_page.dart';
import 'package:remembeer/session/page/create_session_page.dart';
import 'package:remembeer/session/page/edit_session_page.dart';
import 'package:remembeer/session/page/manage_admins_page.dart';
import 'package:remembeer/session/page/session_management_page.dart';
import 'package:toastification/toastification.dart';

void main() {
  Future<void> mount(WidgetTester tester, _Client client, Widget page) async {
    tester.view.physicalSize = const Size(1000, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(client.dispose);
    addTearDown(toastification.dismissAll);
    await tester.pumpWidget(
      ConvexProvider(
        client: client,
        child: ToastificationWrapper(child: MaterialApp(home: page)),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets(
    'session invitations accept and decline with generated mutations',
    (tester) async {
      final client = _Client();
      await mount(tester, client, const SessionManagementPage());
      expect(find.text('Evening'), findsNWidgets(2));
      await tester.tap(find.text('Accept'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'sessionMember:accept');
      expect(client.last.args, <String, dynamic>{'sessionId': 'session'});
      await tester.tap(find.text('Decline'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'sessionMember:decline');
      client.responses['sessionMember:listInvitations'] = <Object?>[];
      client.emit('sessionMember:listInvitations');
      await tester.pumpAndSettle();
      expect(find.text('Accept'), findsNothing);
    },
  );
  testWidgets('creation submits to Convex and shows server errors', (
    tester,
  ) async {
    final client = _Client()..failMutation = true;
    await mount(tester, client, const CreateSessionPage());
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Session Name'),
      'New session',
    );
    await tester.tap(find.widgetWithText(FilledButton, 'Create Session'));
    await tester.pumpAndSettle();
    expect(client.last.name, 'session:create');
    expect(client.last.args['name'], 'New session');
    expect(client.last.args['startedAt'], isA<double>());
    expect(find.textContaining('Server rejected request'), findsWidgets);
  });
  testWidgets(
    'editing, reopening, promotion and delete use session mutations',
    (tester) async {
      final client = _Client()..failMutation = true;
      await mount(tester, client, const EditSessionPage(sessionId: 'session'));
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Session Name'),
        'Renamed session',
      );
      await tester.tap(find.widgetWithText(FilledButton, 'Save Changes'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'session:update');
      expect(client.last.args['name'], 'Renamed session');
      expect(client.last.args.containsKey('endedAt'), isFalse);
      await tester.tap(find.text('Turn into Party'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Turn into Party'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'session:promoteToParty');
      await tester.tap(find.text('Delete session'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'session:softDelete');
      client.responses['session:get'] = {
        ..._session,
        'kind': 'party',
        'endedAt': 2000,
      };
      client.emit('session:get');
      await tester.pumpAndSettle();
      expect(find.text('Turn into Party'), findsNothing);
      await tester.tap(find.text('Reopen session'));
      await tester.pumpAndSettle();
      expect(client.last.args['endedAt'], isNull);
      expect(client.last.args.containsKey('endedAt'), isTrue);
    },
  );
  testWidgets(
    'member lookup invites Convex users and moderation confirms removal',
    (tester) async {
      final client = _Client();
      await mount(
        tester,
        client,
        const AddFriendsToSessionPage(sessionId: 'session'),
      );
      await tester.enterText(find.byType(TextField), 'Someone');
      await tester.tap(find.text('Find users'));
      await tester.pumpAndSettle();
      expect(client.requests.last.name, 'sessionMember:findInvitee');
      expect(client.requests.last.args, <String, dynamic>{
        'sessionId': 'session',
        'username': 'Someone',
      });
      await tester.tap(find.text('Invite'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'sessionMember:invite');
      expect(client.last.args, <String, dynamic>{
        'sessionId': 'session',
        'userId': 'invitee',
      });
      await tester.tap(find.byType(PopupMenuButton<String>).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remove'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Remove'));
      await tester.pumpAndSettle();
      expect(client.last.name, 'sessionMember:remove');
      await tester.pump(const Duration(seconds: 5));
    },
  );
  testWidgets('owner assigns admin roles and ordinary members cannot edit', (
    tester,
  ) async {
    final client = _Client();
    await mount(tester, client, const ManageAdminsPage(sessionId: 'session'));
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(client.last.name, 'sessionMember:setRole');
    expect(client.last.args['role'], {'kind': 'admin'});
    client.responses['user:current'] = {..._user, '_id': 'member'};
    await tester.pumpWidget(
      ConvexProvider(
        client: client,
        child: const MaterialApp(home: EditSessionPage(sessionId: 'session')),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Only session admins can edit this session.'),
      findsOneWidget,
    );
    expect(find.text('Save Changes'), findsNothing);
  });
}

const _session = <String, dynamic>{
  '_id': 'session',
  '_creationTime': 1,
  'ownerId': 'owner',
  'name': 'Evening',
  'description': 'Description',
  'kind': 'session',
  'startedAt': 1000,
  'endedAt': null,
  'updatedAt': 1,
  'deletedAt': null,
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
Map<String, dynamic> _member(String id, String role) => {
  '_id': 'membership-$id',
  '_creationTime': 1,
  'sessionId': 'session',
  'userId': id,
  'sessionMemberStatus': {'kind': 'joined'},
  'sessionMemberRole': {'kind': role},
  'username': id,
  'sessionEndedAt': null,
  'sessionDeletedAt': null,
  'updatedAt': 1,
};

class _Client implements ConvexRuntimeClient {
  final responses = <String, dynamic>{
    'session:get': _session,
    'session:listCurrent': [_session],
    'user:current': _user,
    'sessionMember:listForSession': [
      _member('owner', 'admin'),
      _member('member', 'member'),
    ],
    'sessionMember:findInvitee': [
      {'_id': 'invitee', 'username': 'Someone'},
    ],
    'sessionMember:listInvitations': [
      {
        'member': {
          ..._member('owner', 'member')..remove('username'),
          'sessionMemberStatus': {'kind': 'invited'},
        },
        'session': _session,
      },
    ],
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
    return name == 'session:create' ? 'created-session' : null;
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
