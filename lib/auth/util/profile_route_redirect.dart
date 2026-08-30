String? profileRouteRedirect({
  required bool isAuthenticated,
  required bool? isProfileComplete,
  required String matchedLocation,
  required String loginLocation,
  required String registerLocation,
  required String completionLocation,
  required String appLocation,
}) {
  final isOnLogin = matchedLocation == loginLocation;
  final isOnRegister = matchedLocation == registerLocation;
  final isOnCompletion = matchedLocation == completionLocation;

  if (!isAuthenticated) {
    return isOnLogin || isOnRegister ? null : loginLocation;
  }

  // Registration provisions the Firestore profile after Firebase Auth emits.
  if (isOnRegister || isProfileComplete == null && isOnLogin) {
    return null;
  }

  if (isProfileComplete != true) {
    return isOnCompletion ? null : completionLocation;
  }

  return isOnLogin || isOnCompletion ? appLocation : null;
}
