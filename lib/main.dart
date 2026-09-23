import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:remembeer/app.dart';
import 'package:remembeer/app_icon/service/app_icon_service.dart';
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
  get<AppIconService>().initialize();

  // For the Android home screen widget.
  _quickAddChannel.setMethodCallHandler((call) async {
    if (call.method == 'quickAddPressed') {
      await get<DrinkLogService>().addDefaultDrinkLog();
    }
  });

  runApp(const App());
}
