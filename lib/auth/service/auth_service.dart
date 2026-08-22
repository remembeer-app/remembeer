import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:remembeer/common/util/invariant.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;
  final _authStateSubject = BehaviorSubject<User?>();

  AuthService({required FirebaseAuth firebaseAuth})
    : _firebaseAuth = firebaseAuth {
    _authStateSubject.add(_firebaseAuth.currentUser);
    _firebaseAuth.authStateChanges().listen(_authStateSubject.add);
  }

  late final Stream<User?> authStateChanges = _authStateSubject.stream;

  User? get currentUser =>
      _authStateSubject.valueOrNull ?? _firebaseAuth.currentUser;

  /// Returns the currently authenticated `User`.
  ///
  /// Intended to be used only in an authenticated context.
  /// The authenticated-user invariant fails if no user is signed in.
  User get authenticatedUser {
    final user = currentUser;
    invariant(user != null, 'User is not authenticated.');
    return user!;
  }

  bool get isAuthenticated => currentUser != null;

  bool get isVerified => authenticatedUser.emailVerified;

  bool get hasPasswordProvider => authenticatedUser.providerData.any(
    (info) => info.providerId == 'password',
  );

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> sendEmailVerification() async {
    final user = authenticatedUser;
    if (!user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> resetPassword({required String email}) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = authenticatedUser;
    final email = user.email;
    invariant(email != null, 'User does not have an email.');

    final credential = EmailAuthProvider.credential(
      email: email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  Future<({UserCredential credential, bool isNewUser})?>
  signInWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn.instance.authenticate();

      final credential = GoogleAuthProvider.credential(
        idToken: googleUser.authentication.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );

      final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

      return (credential: userCredential, isNewUser: isNewUser);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        return null;
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _firebaseAuth.signOut();
  }
}
