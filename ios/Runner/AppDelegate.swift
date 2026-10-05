import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let screenSecurityChannel = "elhanbly/screen_security"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    registerScreenSecurityChannel()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    registerScreenSecurityChannel()
  }

  private func registerScreenSecurityChannel() {
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
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}

final class ScreenSecurityManager {
  static let shared = ScreenSecurityManager()

  private var privacyOverlay: UIView?
  private var secureTextField: UITextField?
  private var isObserverRegistered = false
  private var isEnabled = false
  private weak var targetWindow: UIWindow?
  private var channel: FlutterMethodChannel?

  // لتخزين الـ Constraints الأصلية لإعادتها عند إيقاف الحماية
  private var originalFlutterConstraints: [NSLayoutConstraint] = []

  var isRecordingActive: Bool {
    return checkIsScreenRecording()
  }

  private init() {}

  func setup(channel: FlutterMethodChannel?, window: UIWindow?) {
    self.channel = channel
    if let window = window {
      self.targetWindow = window
    }
    registerObservers()
  }

  func enable(window: UIWindow? = nil, channel: FlutterMethodChannel? = nil) {
    if let channel = channel {
      self.channel = channel
    }
    if let window = window {
      self.targetWindow = window
    }
    isEnabled = true
    registerObservers()
    applySecureContent()
    updateScreenCaptureStatus()
  }

  func disable() {
    isEnabled = false
    removeSecureContent()
    removePrivacyOverlay()
  }

  private func registerObservers() {
    guard !isObserverRegistered else { return }
    isObserverRegistered = true

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(screenCaptureChanged),
      name: UIScreen.capturedDidChangeNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(userDidTakeScreenshot),
      name: UIApplication.userDidTakeScreenshotNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(applicationWillResignActive),
      name: UIApplication.willResignActiveNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(applicationDidBecomeActive),
      name: UIApplication.didBecomeActiveNotification,
      object: nil
    )
  }

  private func resolveWindow() -> UIWindow? {
    if let target = targetWindow {
      return target
    }
    if let appDelegateWindow = (UIApplication.shared.delegate as? AppDelegate)?.window, appDelegateWindow != nil {
      self.targetWindow = appDelegateWindow
      return appDelegateWindow
    }
    let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
    if let sceneWindow = scenes.flatMap({ $0.windows }).first(where: { $0.isKeyWindow }) ?? scenes.flatMap({ $0.windows }).first {
      self.targetWindow = sceneWindow
      return sceneWindow
    }
    return nil
  }

  private func applySecureContent() {
    guard isEnabled else { return }
    DispatchQueue.main.async { [weak self] in
      guard let self = self, self.isEnabled else { return }
      guard self.secureTextField == nil else { return }
      guard let window = self.resolveWindow(),
            let controller = window.rootViewController,
            let controllerView = controller.view else {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
          self?.applySecureContent()
        }
        return
      }

      // --- الجزء الأول: إنشاء حقل النص المؤمن وتجهيزه ---
      let field = UITextField()
      field.isSecureTextEntry = true
      field.isUserInteractionEnabled = false
      field.backgroundColor = .clear
      field.translatesAutoresizingMaskIntoConstraints = false
      field.tag = 888999

      window.addSubview(field)
      window.sendSubviewToBack(field)

      // جعل الـ UITextField يملأ الشاشة بالكامل خلف الواجهة
      NSLayoutConstraint.activate([
        field.topAnchor.constraint(equalTo: window.topAnchor),
        field.bottomAnchor.constraint(equalTo: window.bottomAnchor),
        field.leadingAnchor.constraint(equalTo: window.leadingAnchor),
        field.trailingAnchor.constraint(equalTo: window.trailingAnchor)
      ])
      window.layoutIfNeeded()

      // --- الجزء الثاني: البحث عن الـ Secure Canvas Layer ---
      var secureCanvasView: UIView? = nil
      for subview in field.subviews {
        let className = String(describing: type(of: subview))
        if className.contains("CanvasView") || className.contains("TextLayoutCanvas") {
          secureCanvasView = subview
          break
        }
      }

      let targetLayer = secureCanvasView?.layer ?? field.layer.sublayers?.first ?? field.subviews.first?.layer

      // --- الجزء الثالث: نقل واجهة Flutter وتصحيح الأبعاد ---
      if let secureLayer = targetLayer {
        self.secureTextField = field

        // 1. نقل الـ Layer (وهذا ما يسبب مشكلة الأبعاد)
        secureLayer.addSublayer(controllerView.layer)

        // 2. إصلاح مشكلة الأبعاد عبر إجبار الـ View على ملء الـ Secure Canvas
        // يجب التأكد من تفعيل translatesAutoresizingMaskIntoConstraints
        controllerView.translatesAutoresizingMaskIntoConstraints = false
        
        // إزالة أي Constraints سابقة قد تسبب تعارضاً
        controllerView.removeConstraints(controllerView.constraints)

        // إضافة Constraints جديدة لربط واجهة Flutter بأبعاد الـ window
        NSLayoutConstraint.activate([
          controllerView.topAnchor.constraint(equalTo: window.topAnchor),
          controllerView.bottomAnchor.constraint(equalTo: window.bottomAnchor),
          controllerView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
          controllerView.trailingAnchor.constraint(equalTo: window.trailingAnchor)
        ])
        
        // إجبار النظام على إعادة حساب الأبعاد فوراً
        window.layoutIfNeeded()
        controllerView.setNeedsLayout()
        controllerView.layoutIfNeeded()

      } else {
        // إعادة المحاولة في حال لم تكن الطبقة جاهزة
        field.removeFromSuperview()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) { [weak self] in
          self?.applySecureContent()
        }
      }
    }
  }

  private func removeSecureContent() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      if let field = self.secureTextField {
        field.isSecureTextEntry = false
        if let window = self.resolveWindow(),
           let controller = window.rootViewController,
           let controllerView = controller.view {
          
          // إعادة الـ Layer لمكانه الأصلي في الـ window
          window.layer.addSublayer(controllerView.layer)
          
          // إعادة ضبط الـ Constraints الأصلية للـ View
          controllerView.translatesAutoresizingMaskIntoConstraints = true
          controllerView.frame = window.bounds
          controllerView.setNeedsLayout()
          controllerView.layoutIfNeeded()
        }
        field.removeFromSuperview()
        self.secureTextField = nil
      }
    }
  }

  @objc private func screenCaptureChanged() {
    updateScreenCaptureStatus()
  }

  @objc private func userDidTakeScreenshot() {
    DispatchQueue.main.async { [weak self] in
      self?.channel?.invokeMethod("onScreenshotTaken", arguments: nil)
    }
  }

  @objc private func applicationWillResignActive() {
    guard isEnabled else { return }
    showPrivacyOverlay()
  }

  @objc private func applicationDidBecomeActive() {
    if isEnabled {
      applySecureContent()
      updateScreenCaptureStatus()
    }
  }

  private func updateScreenCaptureStatus() {
    let recording = checkIsScreenRecording()
    if recording && isEnabled {
      showPrivacyOverlay()
    } else if !recording && UIApplication.shared.applicationState == .active {
      removePrivacyOverlay()
    }
    DispatchQueue.main.async { [weak self] in
      self?.channel?.invokeMethod("onScreenRecordingChanged", arguments: recording)
    }
  }

  private func checkIsScreenRecording() -> Bool {
    if let window = resolveWindow(), let scene = window.windowScene {
      return scene.screen.isCaptured
    }
    return UIScreen.main.isCaptured
  }

  private func showPrivacyOverlay() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      guard let window = self.resolveWindow() else { return }

      if self.privacyOverlay == nil {
        let overlay = UIView(frame: window.bounds)
        overlay.backgroundColor = .black
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.tag = 777666

        let label = UILabel()
        label.text = "عفواً، لا يمكن تصوير أو تسجيل الشاشة"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        overlay.addSubview(label)

        NSLayoutConstraint.activate([
          label.centerXAnchor.constraint(equalTo: overlay.centerXAnchor),
          label.centerYAnchor.constraint(equalTo: overlay.centerYAnchor),
          label.leadingAnchor.constraint(greaterThanOrEqualTo: overlay.leadingAnchor, constant: 24),
          label.trailingAnchor.constraint(lessThanOrEqualTo: overlay.trailingAnchor, constant: -24)
        ])

        self.privacyOverlay = overlay
      }

      if let overlay = self.privacyOverlay {
        overlay.frame = window.bounds
        if overlay.superview == nil {
          window.addSubview(overlay)
        }
        window.bringSubviewToFront(overlay)
      }
    }
  }

  private func removePrivacyOverlay() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      if !self.checkIsScreenRecording() && UIApplication.shared.applicationState == .active {
        self.privacyOverlay?.removeFromSuperview()
        self.privacyOverlay = nil
      }
    }
  }
}