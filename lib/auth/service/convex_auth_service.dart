import 'dart:async';

import 'package:dartvex/dartvex.dart';
import 'package:dartvex_auth_better/dartvex_auth_better.dart';
import 'package:flutter/foundation.dart';
import 'package:remembeer/convex_api/api.dart';

class ConvexAuthService extends ChangeNotifier {
  final ConvexBetterAuthProvider _authProvider;
  final ConvexClientWithAuth<BetterAuthSession> _client;
  final ConvexApi _api;
  late final StreamSubscription<AuthState<BetterAuthSession>>
  _authStateSubscription;

  ConvexAuthService({
    required ConvexBetterAuthProvider authProvider,
    required ConvexClientWithAuth<BetterAuthSession> client,
    required ConvexApi api,
  }) : _authProvider = authProvider,
       _client = client,
       _api = api {
    _authStateSubscription = _client.authState.listen(_handleAuthState);
  }

  bool get isAuthenticated =>
      _client.currentAuthState is AuthAuthenticated<BetterAuthSession>;

  Future<void> signIn({required String email, required String password}) async {
    _authProvider
      ..email = email
      ..password = password;

    await _completeAuthentication(_client.login);
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await _authProvider.signUp(
      name: name,
      email: email,
      password: password,
      onIdToken: (_) {},
    );
    await _completeAuthentication(_client.login);
  }

  Future<void> signOut() => _client.logout();

  Future<void> _completeAuthentication(
    Future<BetterAuthSession> Function() authenticate,
  ) async {
    await authenticate();
    try {
      await _api.user.ensureCurrent();
    } on Object {
      await _client.logout();
      rethrow;
    }
    notifyListeners();
  }

  void _handleAuthState(AuthState<BetterAuthSession> state) {
    if (state is! AuthAuthenticated<BetterAuthSession>) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    unawaited(_authStateSubscription.cancel());
    super.dispose();
  }
}
