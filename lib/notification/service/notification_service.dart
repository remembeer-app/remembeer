import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/notification/model/notification_type.dart';
import 'package:remembeer/routes.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class NotificationService {
  final _firebaseFunctions = FirebaseFunctions.instanceFor(
    region: 'europe-west4',
  );

  final _firebaseMessaging = FirebaseMessaging.instance;

  Stream<String> get onTokenRefresh => _firebaseMessaging.onTokenRefresh;

  Future<void> initialize() async {
    await _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen(_handleForegroundNotification);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }
  }

  void _handleNotificationTap(RemoteMessage message) {
    final type = NotificationType.fromString(message.data['type'] as String?);

    switch (type) {
      case NotificationType.friendRequestReceived:
        // TODO(ohtenkay): this does not allow the user to navigate back properly,
        // but first we will habe to do deep linking properly
        router.go(const FriendRequestsRoute().location);
      case NotificationType.friendRequestAccepted:
        final fromUserId = message.data['fromUserId'] as String;
        router.go(UserProfileRoute(userId: fromUserId).location);
      case NotificationType.addedToSession:
        router.go(const DrinkRoute().location);
      case null:
        debugPrint('Unknown notification type: ${message.data['type']}');
    }
  }

  void _handleForegroundNotification(RemoteMessage message) {
    final type = NotificationType.fromString(message.data['type'] as String?);

    switch (type) {
      case NotificationType.friendRequestReceived:
        showNotification('You have a new friend request!');
      case NotificationType.friendRequestAccepted:
        showNotification('Your friend request was accepted!');
      case NotificationType.addedToSession:
        showNotification('You were added to a session!');
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
