import 'package:dartvex_flutter/dartvex_flutter.dart';
import 'package:flutter/material.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/routes.dart';
import 'package:toastification/toastification.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ConvexProvider(
      client: get<ConvexClientRuntime>(),
      child: ToastificationWrapper(
        child: MaterialApp.router(
          title: 'Remembeer',
          routerConfig: router,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFD4A017),
            ),
          ),
        ),
      ),
    );
  }
}
