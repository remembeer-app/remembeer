import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:remembeer/app.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/drink_log/service/drink_log_service.dart';
import 'package:remembeer/firebase_options.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/notification/service/notification_service.dart';

const _quickAddChannel = MethodChannel('quick_add_action');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env.client');

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  IoCContainer.initialize();

  await get<NotificationService>().initialize();

  // For the Android and iOS home screen widgets.
  _quickAddChannel.setMethodCallHandler((call) async {
    if (call.method == 'quickAddPressed') {
      try {
        await get<DrinkLogService>().addDefaultDrinkLog();
      } on Object catch (error) {
        showNotification(error.toString());
      }
    }
  });

  runApp(const App());
}
