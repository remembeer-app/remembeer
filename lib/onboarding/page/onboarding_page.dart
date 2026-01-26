import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:remembeer/auth/page/login_page.dart';
import 'package:remembeer/auth/service/auth_service.dart';
import 'package:remembeer/authenticated_context.dart';
import 'package:remembeer/ioc/ioc_container.dart';

// TODO(ohtenkay): add onboarding steps with screenshots
class OnboardingPage extends StatelessWidget {
  OnboardingPage({super.key});

  final _authService = get<AuthService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: StreamBuilder<User?>(
        stream: _authService.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData) {
            return const AuthenticatedContext();
          }

          return const LoginPage();
        },
      ),
    );
  }
}
