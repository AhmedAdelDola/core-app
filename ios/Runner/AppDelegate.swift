import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let screenSecurityChannel = "core_app/screen_security"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    registerScreenSecurityChannels()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    registerScreenSecurityChannels()
  }

  private func registerScreenSecurityChannels() {
    guard let controller = window?.rootViewController as? FlutterViewController else {
      return
    }

    let channel = FlutterMethodChannel(
      name: screenSecurityChannel,
      binaryMessenger: controller.binaryMessenger
    )

    ScreenSecurityManager.shared.setup(channel: channel, window: window)

    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "enable":
        ScreenSecurityManager.shared.enable()
        result(nil)
      case "disable":
        ScreenSecurityManager.shared.disable()
        result(nil)
      case "isScreenRecording":
        result(ScreenSecurityManager.shared.isRecordingActive)
      case "getSecurityState":
        result(ScreenSecurityManager.shared.getSecurityState())
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}

// MARK: - Security Privacy Overlay View
final class SecurityPrivacyOverlay: UIView {
  private let iconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    imageView.tintColor = .white
    if #available(iOS 13.0, *) {
      let config = UIImage.SymbolConfiguration(pointSize: 48, weight: .semibold)
      imageView.image = UIImage(systemName: "lock.shield.fill", withConfiguration: config)
    }
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "عفواً، لا يمكن تصوير أو تسجيل الشاشة"
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()

  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "حماية المحتوى التعليمي والبيانات نشطة"
    label.textColor = UIColor.white.withAlphaComponent(0.75)
    label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()

  private let containerStack: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.alignment = .center
    stack.spacing = 14
    return stack
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupView()
  }

  private func setupView() {
    backgroundColor = .black
    isOpaque = true
    isUserInteractionEnabled = true
    autoresizingMask = [.flexibleWidth, .flexibleHeight]
    tag = 777666

    containerStack.addArrangedSubview(iconImageView)
    containerStack.addArrangedSubview(titleLabel)
    containerStack.addArrangedSubview(subtitleLabel)
    addSubview(containerStack)

    NSLayoutConstraint.activate([
      containerStack.centerXAnchor.constraint(equalTo: centerXAnchor),
      containerStack.centerYAnchor.constraint(equalTo: centerYAnchor),
      containerStack.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 28),
      containerStack.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -28)
    ])
  }
}

// MARK: - Screen Security Manager
final class ScreenSecurityManager {
  static let shared = ScreenSecurityManager()

  private var privacyOverlay: SecurityPrivacyOverlay?
  private var isObserverRegistered = false
  private var isEnabled = false
  private weak var targetWindow: UIWindow?
  private weak var activeWindowScene: UIWindowScene?
  private var channel: FlutterMethodChannel?

  var isRecordingActive: Bool {
    return checkIsScreenCapturedOrMirrored()
  }

  private init() {}

  func setup(channel: FlutterMethodChannel?, window: UIWindow?) {
    self.channel = channel
    if let window = window {
      self.targetWindow = window
    }
    registerObservers()
  }

  func updateScene(_ scene: UIWindowScene, window: UIWindow?) {
    self.activeWindowScene = scene
    if let window = window {
      self.targetWindow = window
    }
  }

  func enable(window: UIWindow? = nil) {
    if let window = window {
      self.targetWindow = window
    }
    isEnabled = true
    registerObservers()
    evaluateSecurityStateAndOverlay()
  }

  func disable() {
    isEnabled = false
    removePrivacyOverlay()
  }

  func getSecurityState() -> [String: Any] {
    let isCaptured = checkIsScreenCaptured()
    let isMirrored = checkIsScreenMirrored()
    let isExternal = checkHasExternalDisplay()
    return [
      "isRecording": isCaptured,
      "isMirroring": isMirrored,
      "isExternalDisplay": isExternal,
      "isProtected": isEnabled
    ]
  }

  // MARK: - Observers Registration
  private func registerObservers() {
    guard !isObserverRegistered else { return }
    isObserverRegistered = true

    // Screen Recording / Capture changes
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(screenCaptureChanged),
      name: UIScreen.capturedDidChangeNotification,
      object: nil
    )

    // Screenshot taken
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(userDidTakeScreenshot),
      name: UIApplication.userDidTakeScreenshotNotification,
      object: nil
    )

    // External display / Mirroring connect/disconnect
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(screenConnectionChanged),
      name: UIScreen.didConnectNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(screenConnectionChanged),
      name: UIScreen.didDisconnectNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(screenConnectionChanged),
      name: UIScreen.modeDidChangeNotification,
      object: nil
    )
  }

  // MARK: - Scene Lifecycle Handlers
  func sceneDidBecomeActive(_ scene: UIScene) {
    if let windowScene = scene as? UIWindowScene {
      self.activeWindowScene = windowScene
      if let sceneWindow = windowScene.windows.first(where: { $0.isKeyWindow }) ?? windowScene.windows.first {
        self.targetWindow = sceneWindow
      }
    }
    evaluateSecurityStateAndOverlay()
  }

  func sceneWillResignActive(_ scene: UIScene) {
    if let windowScene = scene as? UIWindowScene {
      self.activeWindowScene = windowScene
      if let sceneWindow = windowScene.windows.first(where: { $0.isKeyWindow }) ?? windowScene.windows.first {
        self.targetWindow = sceneWindow
      }
    }
    if isEnabled {
      showPrivacyOverlayImmediately()
    }
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    if isEnabled {
      showPrivacyOverlayImmediately()
    }
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    // Keep overlay active until sceneDidBecomeActive verifies safety
  }

  // MARK: - Window Resolution
  private func resolveWindow() -> UIWindow? {
    if let target = targetWindow, target.windowScene != nil {
      return target
    }
    if let scene = activeWindowScene {
      if let keyWin = scene.windows.first(where: { $0.isKeyWindow }) {
        self.targetWindow = keyWin
        return keyWin
      }
      if let firstWin = scene.windows.first {
        self.targetWindow = firstWin
        return firstWin
      }
    }
    let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
    for scene in scenes {
      if let keyWin = scene.windows.first(where: { $0.isKeyWindow }) {
        self.activeWindowScene = scene
        self.targetWindow = keyWin
        return keyWin
      }
    }
    if let fallback = scenes.flatMap({ $0.windows }).first {
      self.targetWindow = fallback
      return fallback
    }
    return targetWindow
  }

  // MARK: - Security Evaluation
  @objc private func screenCaptureChanged() {
    evaluateSecurityStateAndOverlay()
  }

  @objc private func screenConnectionChanged() {
    evaluateSecurityStateAndOverlay()
  }

  @objc private func userDidTakeScreenshot() {
    DispatchQueue.main.async { [weak self] in
      self?.channel?.invokeMethod("onScreenshotTaken", arguments: nil)
    }
  }

  func evaluateSecurityStateAndOverlay() {
    let capturedOrMirrored = checkIsScreenCapturedOrMirrored()
    let isAppActive = UIApplication.shared.applicationState == .active

    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }

      if capturedOrMirrored && self.isEnabled {
        self.showPrivacyOverlayImmediately()
      } else if !capturedOrMirrored && isAppActive {
        self.removePrivacyOverlay()
      }

      let state = self.getSecurityState()
      self.channel?.invokeMethod("onScreenRecordingChanged", arguments: capturedOrMirrored)
      self.channel?.invokeMethod("onSecurityStateChanged", arguments: state)
    }
  }

  private func checkIsScreenCaptured() -> Bool {
    if let scene = activeWindowScene {
      return scene.screen.isCaptured
    }
    if let window = resolveWindow(), let scene = window.windowScene {
      return scene.screen.isCaptured
    }
    return UIScreen.screens.contains(where: { $0.isCaptured })
  }

  private func checkIsScreenMirrored() -> Bool {
    return UIScreen.screens.contains(where: { $0.mirrored != nil })
  }

  private func checkHasExternalDisplay() -> Bool {
    return UIScreen.screens.count > 1
  }

  private func checkIsScreenCapturedOrMirrored() -> Bool {
    return checkIsScreenCaptured() || checkIsScreenMirrored() || checkHasExternalDisplay()
  }

  // MARK: - Privacy Overlay Display
  func showPrivacyOverlayImmediately() {
    guard let window = resolveWindow() else { return }

    if privacyOverlay == nil {
      let overlay = SecurityPrivacyOverlay(frame: window.bounds)
      self.privacyOverlay = overlay
    }

    if let overlay = privacyOverlay {
      overlay.frame = window.bounds
      if overlay.superview == nil {
        window.addSubview(overlay)
      }
      window.bringSubviewToFront(overlay)
      overlay.setNeedsLayout()
      overlay.layoutIfNeeded()
    }
  }

  func removePrivacyOverlay() {
    guard !checkIsScreenCapturedOrMirrored() else { return }
    privacyOverlay?.removeFromSuperview()
    privacyOverlay = nil
  }
}