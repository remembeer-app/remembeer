import 'dart:async';

import 'package:dartvex/dartvex.dart';
import 'package:dartvex_auth_better/dartvex_auth_better.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:remembeer/convex_api/api.dart';
import 'package:remembeer/user/constants.dart';

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

  var _isVerified = false;
  var _hasPasswordProvider = true;
  Future<void>? _googleInitialization;

  bool get isVerified => _isVerified;
  bool get hasPasswordProvider => _hasPasswordProvider;

  BetterAuthSession get _session {
    final state = _client.currentAuthState;
    if (state is! AuthAuthenticated<BetterAuthSession>) {
      throw const BetterAuthException('Please sign in again.');
    }
    return state.userInfo;
  }

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
    final timeZone = await _initialTimeZone();
    await _authProvider.signUp(
      name: name,
      email: email,
      password: password,
      onIdToken: (_) {},
    );
    await _completeAuthentication(_client.login, timeZone: timeZone);
  }

  Future<void> signOut() => _client.logout();

  Future<bool> signInWithGoogle() async {
    final account = await _googleAccount();
    if (account == null) return false;
    final idToken = account.authentication.idToken;
    if (idToken == null) {
      throw const BetterAuthException('Google did not return an ID token.');
    }
    final session = await _authProvider.client.signInSocial(
      provider: 'google',
      idToken: idToken,
    );
    _authProvider.setSession(session);
    await _completeAuthentication(
      _client.loginFromCache,
      timeZone: await _initialTimeZone(),
    );
    return true;
  }

  Future<GoogleSignInAccount?> _googleAccount({
    bool reauthenticate = false,
  }) async {
    _googleInitialization ??= GoogleSignIn.instance.initialize(
      serverClientId: dotenv.get('GOOGLE_AUTH_SERVER_CLIENT_ID'),
    );
    await _googleInitialization;
    try {
      if (reauthenticate) await GoogleSignIn.instance.signOut();
      return await GoogleSignIn.instance.authenticate();
    } on GoogleSignInException catch (error) {
      if (error.code == GoogleSignInExceptionCode.canceled) return null;
      rethrow;
    }
  }

  Future<void> refreshAccountStatus() async {
    final status = await _authProvider.client.getAccountStatus(
      sessionToken: _session.sessionToken,
    );
    _isVerified = status.emailVerified;
    _hasPasswordProvider = status.hasPassword;
    notifyListeners();
  }

  Future<bool> deleteAccount({String? password}) async {
    if (!hasPasswordProvider) {
      final previousUserId = _session.userId;
      final account = await _googleAccount(reauthenticate: true);
      if (account == null) return false;
      if (account.email.toLowerCase() != _session.email.toLowerCase()) {
        throw const BetterAuthException(
          'Choose the Google account you are signed in with.',
        );
      }
      final idToken = account.authentication.idToken;
      if (idToken == null) {
        throw const BetterAuthException('Google did not return an ID token.');
      }
      final session = await _authProvider.client.signInSocial(
        provider: 'google',
        idToken: idToken,
      );
      if (session.userId != previousUserId) {
        await _authProvider.client.signOut(sessionToken: session.sessionToken);
        throw const BetterAuthException(
          'Choose the Google account you are signed in with.',
        );
      }
      _authProvider.setSession(session);
      await _client.loginFromCache();
    }
    await _api.user.deleteCurrent(
      password: password == null
          ? const Optional.absent()
          : Optional.of(password),
    );
    try {
      await signOut();
    } on Exception catch (error) {
      // Dartvex clears local authentication even if remote sign-out fails.
      // The account has already been deleted, so report deletion as successful.
      debugPrint('Sign-out after account deletion failed: $error');
    }
    return true;
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final state = _client.currentAuthState;
    if (state is! AuthAuthenticated<BetterAuthSession>) {
      throw const BetterAuthException(
        'Please sign in to change your password.',
      );
    }
    await _authProvider.client.changePassword(
      sessionToken: state.userInfo.sessionToken,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
    _authProvider.password = newPassword;
  }

  Future<void> _completeAuthentication(
    Future<BetterAuthSession> Function() authenticate, {
    String? timeZone,
  }) async {
    await authenticate();
    try {
      await _api.user.ensureCurrent(
        timeZone: timeZone == null
            ? const Optional.absent()
            : Optional.of(timeZone),
      );
      await refreshAccountStatus();
    } on Object {
      await _client.logout();
      rethrow;
    }
    notifyListeners();
  }

  Future<String> _initialTimeZone() async {
    try {
      return (await FlutterTimezone.getLocalTimezone()).identifier;
    } on Object catch (error) {
      debugPrint('Could not detect the account timezone: $error');
      return defaultTimeZone;
    }
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
