import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class NotificationService {
  final _firebaseFunctions = FirebaseFunctions.instanceFor(
    region: 'europe-west4',
  );

  final _firebaseMessaging = FirebaseMessaging.instance;

  Stream<String> get onTokenRefresh => _firebaseMessaging.onTokenRefresh;

  final _messageStreamController = BehaviorSubject<RemoteMessage>();

  Stream<RemoteMessage> get messageStream => _messageStreamController.stream;

  final _notificationTapController = BehaviorSubject<RemoteMessage>();

  Stream<RemoteMessage> get notificationTapStream =>
      _notificationTapController.stream;

  Future<void> initialize() async {
    await _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((message) {
      _messageStreamController.sink.add(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _notificationTapController.sink.add(message);
    });

    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _notificationTapController.sink.add(initialMessage);
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

  void dispose() {
    _messageStreamController.close();
    _notificationTapController.close();
  }
}
