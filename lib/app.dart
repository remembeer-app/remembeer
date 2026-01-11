import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:remembeer/auth/page/login_page.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/ioc/ioc_container.dart';
import 'package:remembeer/page_switcher.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  App({super.key});

  final _authService = get<AuthService>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remembeer',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFD4A017)),
      ),
      home: _buildAuthGate(),
    );
  }

  StreamBuilder<User?> _buildAuthGate() {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const PageSwitcher();
        }

        return const LoginPage();
      },
    );
  }
}
