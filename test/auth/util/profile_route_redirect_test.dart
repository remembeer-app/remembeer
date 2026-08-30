import 'package:flutter_test/flutter_test.dart';
import 'package:remembeer/auth/util/profile_route_redirect.dart';

void main() {
  const login = '/login';
  const register = '/register';
  const completion = '/complete-profile';
  const app = '/drink';

  String? redirect({
    required bool authenticated,
    required bool? complete,
    required String location,
  }) {
    return profileRouteRedirect(
      isAuthenticated: authenticated,
      isProfileComplete: complete,
      matchedLocation: location,
      loginLocation: login,
      registerLocation: register,
      completionLocation: completion,
      appLocation: app,
    );
  }

  test('unauthenticated users can only access authentication routes', () {
    expect(
      redirect(authenticated: false, complete: null, location: app),
      login,
    );
    expect(
      redirect(authenticated: false, complete: null, location: login),
      isNull,
    );
    expect(
      redirect(authenticated: false, complete: null, location: register),
      isNull,
    );
  });

  test('incomplete users are confined to profile completion', () {
    expect(
      redirect(authenticated: true, complete: false, location: app),
      completion,
    );
    expect(
      redirect(authenticated: true, complete: false, location: completion),
      isNull,
    );
  });

  test('complete users leave auth and completion routes for the app', () {
    expect(redirect(authenticated: true, complete: true, location: login), app);
    expect(
      redirect(authenticated: true, complete: true, location: completion),
      app,
    );
    expect(
      redirect(authenticated: true, complete: true, location: '/settings'),
      isNull,
    );
  });

  test('new account provisioning does not create redirect loops', () {
    expect(
      redirect(authenticated: true, complete: null, location: register),
      isNull,
    );
    expect(
      redirect(authenticated: true, complete: null, location: login),
      isNull,
    );
    expect(
      redirect(authenticated: true, complete: null, location: app),
      completion,
    );
  });
}
