import 'package:go_router/go_router.dart';
import 'package:remembeer/onboarding/page/onboarding_page.dart';

final router = GoRouter(
  routes: [GoRoute(path: '/', builder: (context, state) => OnboardingPage())],
);
