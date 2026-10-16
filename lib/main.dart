import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:remembeer/app.dart';
import 'package:remembeer/app_icon/service/app_icon_service.dart';
import 'package:remembeer/common/action/notifications.dart';
import 'package:remembeer/drink_log/service/drink_log_service.dart';
import 'package:remembeer/ioc/ioc_container.dart';

const _quickAddChannel = MethodChannel('quick_add_action');

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env.client');

  IoCContainer.initialize();
  get<AppIconService>().initialize();

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
