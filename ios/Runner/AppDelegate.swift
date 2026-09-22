import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private static let appIconChannel = "app_icon"
  private static let appIconSetMethod = "setIcon"
  /// The phase whose icon set is the primary `AppIcon`; the others are the
  /// `AppIcon-bumblebeer_<phase>` alternate icons declared in the Xcode
  /// build setting `ASSETCATALOG_COMPILER_ALTERNATE_APPICON_NAMES`.
  private static let primaryAppIconPhase = "a"

  /// Icon phase requested by Flutter while the app was not active yet.
  private var pendingAppIconPhase: String?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    UNUserNotificationCenter.current().delegate = self

    // setAlternateIconName only works while the app is active, so retry any
    // pending change when the app comes to the foreground.
    NotificationCenter.default.addObserver(
      forName: UIApplication.didBecomeActiveNotification,
      object: nil,
      queue: .main
    ) { [weak self] _ in
      self?.applyPendingAppIcon()
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    let channel = FlutterMethodChannel(
      name: AppDelegate.appIconChannel,
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == AppDelegate.appIconSetMethod else {
        result(FlutterMethodNotImplemented)
        return
      }
      guard let arguments = call.arguments as? [String: Any],
            let phase = arguments["phase"] as? String
      else {
        result(FlutterError(code: "invalid_phase", message: "Missing app icon phase", details: nil))
        return
      }
      self?.pendingAppIconPhase = phase
      self?.applyPendingAppIcon()
      result(nil)
    }
  }

  private func applyPendingAppIcon() {
    let application = UIApplication.shared
    guard let phase = pendingAppIconPhase, application.applicationState == .active else {
      return
    }
    pendingAppIconPhase = nil

    guard application.supportsAlternateIcons else {
      return
    }

    let iconName: String? =
      phase == AppDelegate.primaryAppIconPhase ? nil : "AppIcon-bumblebeer_\(phase)"
    guard application.alternateIconName != iconName else {
      return
    }

    application.setAlternateIconName(iconName) { error in
      if let error = error {
        NSLog("Failed to change the app icon: \(error.localizedDescription)")
      }
    }
  }
}
