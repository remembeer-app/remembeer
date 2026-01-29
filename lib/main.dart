import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:remembeer/app.dart';
import 'package:remembeer/drink/service/drink_service.dart';
import 'package:remembeer/firebase_options.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/notification/service/notification_service.dart';
import 'package:remembeer/routes.dart';

const _quickAddChannel = MethodChannel('quick_add_action');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  await Firebase.initializeApp(
    name: 'remembeer',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await GoogleSignIn.instance.initialize(
    serverClientId: dotenv.env['GOOGLE_AUTH_SERVER_CLIENT_ID'],
  );

  IoCContainer.initialize();

  await get<NotificationService>().initialize();

  // For the Android home screen widget.
  _quickAddChannel.setMethodCallHandler((call) async {
    if (call.method == 'quickAddPressed') {
      await get<DrinkService>().addDefaultDrink();
    }
  });

  // Whenever the auth state changes, the redirect logic in the router
  // is reevaluated.
  FirebaseAuth.instance.authStateChanges().listen((user) {
    router.refresh();
  });

  runApp(const App());
}
