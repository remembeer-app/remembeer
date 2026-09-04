import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/firebase_options.dart';
import 'package:remembeer/notification/model/notification_type.dart';
import 'package:remembeer/notification/model/party_notification_payload.dart';
import 'package:remembeer/routes.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await dotenv.load();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

class NotificationService {
  NotificationService({
    FirebaseAuth? firebaseAuth,
    void Function(String location)? navigate,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _navigate = navigate ?? router.go,
       _partyRouter = PartyNotificationRouter(navigate ?? router.go);

  final _firebaseFunctions = FirebaseFunctions.instanceFor(
    region: 'europe-west4',
  );
  final _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAuth _firebaseAuth;
  final void Function(String location) _navigate;
  final PartyNotificationRouter _partyRouter;

  Stream<String> get onTokenRefresh => _firebaseMessaging.onTokenRefresh;

  Future<void> initialize() async {
    await _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen(_handleForegroundNotification);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      unawaited(_handleNotificationTap(message));
    });

    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      unawaited(_handleInitialNotification(initialMessage));
    }
  }

  Future<void> _handleInitialNotification(RemoteMessage message) async {
    if (_firebaseAuth.currentUser == null) {
      await _firebaseAuth.authStateChanges().firstWhere((user) => user != null);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_handleNotificationTap(message));
    });
  }

  Future<void> _handleNotificationTap(RemoteMessage message) async {
    if (handlePartyNotificationData(
      message.data,
      messageId: message.messageId,
    )) {
      return;
    }
    final rawType = message.data['type'];
    final type = NotificationType.fromString(
      rawType is String ? rawType : null,
    );

    switch (type) {
      case NotificationType.friendRequestReceived:
        // TODO(ohtenkay): this does not allow the user to navigate back properly,
        // but first we will have to do deep linking properly
        _navigate(const FriendRequestsRoute().location);
      case NotificationType.friendRequestAccepted:
        final fromUserId = message.data['fromUserId'];
        if (fromUserId is String && fromUserId.isNotEmpty) {
          _navigate(UserProfileRoute(userId: fromUserId).location);
        }
      case NotificationType.addedToSession:
        _navigate(const DrinkRoute().location);
      case NotificationType.partyActivated:
      case NotificationType.partyQuestStarted:
      case NotificationType.partyQuestCompleted:
      case NotificationType.partyChallengeStarted:
      case NotificationType.partyChallengeWinner:
      case NotificationType.partyBeerpongEnrollment:
      case NotificationType.partyBeerpongMatchReady:
      case NotificationType.partyBeerpongMatchResult:
      case NotificationType.partyBeerpongCompleted:
      case NotificationType.partyArchived:
        debugPrint('Malformed Party notification: ${message.data}');
      case null:
        debugPrint('Unknown notification type: ${message.data['type']}');
    }
  }

  bool handlePartyNotificationData(
    Map<String, dynamic> data, {
    String? messageId,
  }) => _partyRouter.handle(data, messageId: messageId);

  void _handleForegroundNotification(RemoteMessage message) {
    final rawType = message.data['type'];
    final type = NotificationType.fromString(
      rawType is String ? rawType : null,
    );

    switch (type) {
      case NotificationType.friendRequestReceived:
        showNotification('You have a new friend request!');
      case NotificationType.friendRequestAccepted:
        showNotification('Your friend request was accepted!');
      case NotificationType.addedToSession:
        showNotification('You were added to a session!');
      case NotificationType.partyActivated:
      case NotificationType.partyQuestStarted:
      case NotificationType.partyQuestCompleted:
      case NotificationType.partyChallengeStarted:
      case NotificationType.partyChallengeWinner:
      case NotificationType.partyBeerpongEnrollment:
      case NotificationType.partyBeerpongMatchReady:
      case NotificationType.partyBeerpongMatchResult:
      case NotificationType.partyBeerpongCompleted:
      case NotificationType.partyArchived:
        showNotification(
          message.notification?.body ?? 'There is new Party activity.',
        );
      case null:
        debugPrint('Unknown notification type: ${message.data['type']}');
    }
  }

  Future<String?> getToken() async {
    return _firebaseMessaging.getToken();
  }

  Future<void> notifyFriendRequestAccepted(
    String toUserId,
    String fromUserId,
    String fromUsername,
  ) async {
    await _firebaseFunctions
        .httpsCallable('notify_friend_request_acceptance')
        .call<void>({
          'toUserId': toUserId,
          'fromUserId': fromUserId,
          'fromUsername': fromUsername,
        });
  }

  Future<void> notifyAddedToSession(
    String toUserId,
    String fromUserName,
    String sessionName,
  ) async {
    await _firebaseFunctions
        .httpsCallable('notify_added_to_session')
        .call<void>({
          'toUserId': toUserId,
          'fromUserName': fromUserName,
          'sessionName': sessionName,
        });
  }
}
