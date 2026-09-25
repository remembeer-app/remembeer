import Flutter
import UIKit
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate, FlutterSceneLifeCycleDelegate {
  private static let appIconChannel = "app_icon"
  private static let appIconSetMethod = "setIcon"
  /// The phase whose icon set is the primary `AppIcon`; the others are the
  /// `AppIcon-bumblebeer_<phase>` alternate icons declared in the Xcode
  /// build setting `ASSETCATALOG_COMPILER_ALTERNATE_APPICON_NAMES`.
  private static let primaryAppIconPhase = "a"

  /// Same channel and method as `MainActivity` on Android; handled in `main.dart`.
  private static let quickAddChannelName = "quick_add_action"
  private static let quickAddMethod = "quickAddPressed"
  /// URL opened by the Quick Add home screen widget (see `QuickAddWidget.swift`).
  private static let quickAddURLScheme = "remembeer"
  private static let quickAddURLHost = "quick-add"
  private static let quickAddPluginKey = "QuickAddWidget"

  /// Icon phase requested by Flutter while the app was not active yet.
  private var pendingAppIconPhase: String?

  private var quickAddChannel: FlutterMethodChannel?
  /// Set once Flutter has drawn its first frame, which means `main.dart` has
  /// installed the method call handler. Messages sent earlier would be dropped.
  private var isFlutterReady = false
  /// A widget tap that arrived before Flutter was ready to handle it.
  private var hasPendingQuickAdd = false

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

    let messenger = engineBridge.applicationRegistrar.messenger()

    let channel = FlutterMethodChannel(name: AppDelegate.appIconChannel, binaryMessenger: messenger)
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

    quickAddChannel = FlutterMethodChannel(
      name: AppDelegate.quickAddChannelName,
      binaryMessenger: messenger
    )
    // The widget URL is delivered through the scene delegate, which Flutter
    // forwards to scene life cycle delegates registered by plugins; register the
    // app delegate itself the way a plugin would.
    engineBridge.pluginRegistry
      .registrar(forPlugin: AppDelegate.quickAddPluginKey)?
      .addSceneDelegate(self)
  }

  // MARK: - FlutterSceneLifeCycleDelegate

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions?
  ) -> Bool {
    observeFlutterReadiness(in: scene)
    // Cold start from the widget: the URL is part of the connection options.
    return handleQuickAddURLs(connectionOptions?.urlContexts ?? [])
  }

  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) -> Bool {
    // Warm start from the widget: the app was already running.
    return handleQuickAddURLs(URLContexts)
  }

  // MARK: - Quick Add widget

  private func handleQuickAddURLs(_ urlContexts: Set<UIOpenURLContext>) -> Bool {
    let isQuickAdd = urlContexts.contains { context in
      let url = context.url
      return url.scheme == AppDelegate.quickAddURLScheme && url.host == AppDelegate.quickAddURLHost
    }
    guard isQuickAdd else {
      return false
    }
    hasPendingQuickAdd = true
    flushPendingQuickAdd()
    return true
  }

  private func flushPendingQuickAdd() {
    guard hasPendingQuickAdd, isFlutterReady, let channel = quickAddChannel else {
      return
    }
    hasPendingQuickAdd = false
    channel.invokeMethod(AppDelegate.quickAddMethod, arguments: nil)
  }

  /// Marks Flutter as ready once the storyboard's `FlutterViewController` has
  /// rendered its first frame, then delivers any tap that was waiting for it.
  private func observeFlutterReadiness(in scene: UIScene) {
    guard !isFlutterReady else {
      return
    }
    let flutterViewController = (scene as? UIWindowScene)?.windows
      .compactMap { $0.rootViewController as? FlutterViewController }
      .first
    guard let flutterViewController = flutterViewController else {
      NSLog("Quick Add: no FlutterViewController found in the connected scene")
      return
    }
    if flutterViewController.isDisplayingFlutterUI {
      isFlutterReady = true
      flushPendingQuickAdd()
      return
    }
    flutterViewController.setFlutterViewDidRenderCallback { [weak self] in
      self?.isFlutterReady = true
      self?.flushPendingQuickAdd()
    }
  }

  // MARK: - App icon

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
