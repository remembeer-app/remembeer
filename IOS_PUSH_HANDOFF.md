# Handoff: iOS push notifications debugging (2026-09-15)

Paste this into a fresh Claude Code session started in the repo on the Mac.

## Goal
Make FCM push notifications work on iOS (simulator first, M1 Mac, macOS 26, iOS 17-class simulator),
then ship an internal TestFlight build.

## Done so far
- Apple Developer Program joined. APNs auth key (.p8) created and uploaded to Firebase Cloud Messaging for the iOS app.
- Bundle ID `com.remembeer.app` everywhere (Xcode, `.env` FIREBASE_IOS_BUNDLE_ID, Firebase iOS app).
- Commit 4a730ee "feat: enable iOS notifications" (branch `ios-notifications`): `Runner.entitlements` with
  `aps-environment=development`, `CODE_SIGN_ENTITLEMENTS` + `DEVELOPMENT_TEAM=5RZ4BFK86Z` in all 3 configs,
  `UIBackgroundModes: remote-notification` in Info.plist. Reviewed: looks correct.
- Simulator notifications permission is allowed. Firebase APNs support in simulator is possible on this hardware.

## Symptom
After Google login in the simulator, `user_settings/{uid}.notificationToken` is never written, even after waiting minutes.
Console shows exactly one relevant line and nothing after it:
`Unhandled Exception: [firebase_messaging/apns-token-not-set] APNS token has not been received on the device yet`
thrown from `UserSettingsService._syncToken` (lib/user_settings/service/user_settings_service.dart:114), which calls
`FirebaseMessaging.getToken()` inside the `authStateChanges` listener.

## What is established (from firebase_messaging 16.4.1 source)
- On iOS `getToken()` throws if no APNs token yet; that first throw is expected and non-fatal.
- Once Apple delivers the APNs token, FIRMessaging fetches the FCM token and emits `onTokenRefresh`; the app's second
  listener (`user_settings_service.dart:38`) writes it if the user is authenticated. Since nothing ever arrives, the APNs
  token itself is never delivered (or registration fails silently; the plugin only NSLogs `didFailToRegister...`).
- The plugin calls `registerForRemoteNotifications` at plugin registration and swizzles the app delegate; no
  `FirebaseAppDelegateProxyEnabled` override in Info.plist (good).

## Next diagnostics (run on the Mac, in the repo)
1. Verify the entitlement is in the debug simulator build:
   `codesign -d --entitlements - build/ios/Debug-iphonesimulator/Runner.app`
   (earlier attempt used the wrong path `build/ios/iphonesimulator/` and printed nothing).
   If `aps-environment` is missing -> the entitlements are not applied to the Debug simulator build; fix that.
2. Read Apple's push daemon log for the app while it runs:
   `xcrun simctl spawn booted log show --last 15m --predicate 'process == "Runner" OR process == "apsd"' --style compact | grep -iE 'aps-environment|entitlement|push|remote notif|token|register'`
3. If registration is fine, add a temporary debugPrint of `FirebaseMessaging.instance.getAPNSToken()` and of
   `onTokenRefresh` events in `NotificationService.initialize()` to see whether Firebase gets the APNs token.
4. Regardless of root cause, harden `_syncToken`: catch `FirebaseException` code `apns-token-not-set` (or await
   `getAPNSToken()` with a short retry on iOS) so login no longer throws; rely on `onTokenRefresh` for the write.
   Write a failing test first (test/ has the existing patterns).

## Rules for the session
- Never `git commit` unless Matej explicitly asks; stage specific files with `git add`, never new .md files.
- One concern per commit. Do not re-apply `apple-ios-setup.patch` (set aside).
- APPLE_REVIEW_AUDIT.md: drinking-reward badges are the top Beta App Review risk; Sign in with Apple still pending.
