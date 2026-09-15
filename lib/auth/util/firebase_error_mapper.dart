String mapFirebaseAuthError(String? code) {
  return switch (code) {
    'invalid-credential' ||
    'wrong-password' ||
    'invalid-email' => 'Invalid email or password.',
    'user-not-found' => 'No account found with this email.',
    'user-disabled' => 'This account has been disabled.',
    'too-many-requests' => 'Too many attempts. Please try again later.',
    'email-already-in-use' => 'This email is already registered.',
    'weak-password' => 'Password is too weak.',
    'network-request-failed' => 'Network error. Check your connection.',
    'requires-recent-login' => 'Please confirm your identity again and retry.',
    'user-mismatch' =>
      'Please confirm with the same account you are signed in with.',
    _ => 'An error occurred. Please try again.',
  };
}
