import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  final _messageStreamController = BehaviorSubject<RemoteMessage>();
  Stream<RemoteMessage> get messageStream => _messageStreamController.stream;
  Future<void> initialize() async {
    await _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((message) {
      _messageStreamController.sink.add(message);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<String?> getToken() async {
    return _firebaseMessaging.getToken();
  }

  Stream<String> get onTokenRefresh => _firebaseMessaging.onTokenRefresh;

  void dispose() {
    _messageStreamController.close();
  }
}
