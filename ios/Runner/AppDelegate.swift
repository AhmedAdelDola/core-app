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
    channel.setMethodCallHandler { [weak self] call, result in
      if call.method == "enable" {
        ScreenSecurityManager.shared.enable(window: self?.window, channel: channel)
        result(nil)
      } else if call.method == "disable" {
        ScreenSecurityManager.shared.disable()
        result(nil)
      } else if call.method == "isScreenRecording" {
        result(ScreenSecurityManager.shared.isRecordingActive)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }
  }
}

final class ScreenSecurityManager {
  static let shared = ScreenSecurityManager()

  private var privacyView: UIView?
  private var secureTextField: UITextField?
  private var isObserverRegistered = false
  private var isEnabled = false
  private weak var targetWindow: UIWindow?
  private var channel: FlutterMethodChannel?

  var isRecordingActive: Bool {
    return isScreenRecording
  }

  private init() {}

  func enable(window: UIWindow? = nil, channel: FlutterMethodChannel? = nil) {
    if let channel = channel {
      self.channel = channel
    }
    isEnabled = true
    if let window = window {
      self.targetWindow = window
    }

    registerObservers()
    secureContent()
    updatePrivacyOverlay()
  }

  func disable() {
    isEnabled = false
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.privacyView?.removeFromSuperview()
      self.privacyView = nil

      if let textField = self.secureTextField {
        textField.isSecureTextEntry = false
        if let window = self.resolveWindow(),
           let controllerView = window.rootViewController?.view {
          window.layer.addSublayer(controllerView.layer)
        }
        textField.removeFromSuperview()
        self.secureTextField = nil
      }
    }
  }

  private func registerObservers() {
    guard !isObserverRegistered else { return }
    isObserverRegistered = true

    NotificationCenter.default.addObserver(
      self,
      selector: #selector(updatePrivacyOverlay),
      name: UIScreen.capturedDidChangeNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(showPrivacyOverlay),
      name: UIApplication.willResignActiveNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(didBecomeActive),
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
    let sceneWindow = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }
    if let sceneWindow = sceneWindow {
      self.targetWindow = sceneWindow
      return sceneWindow
    }
    return nil
  }

  private func secureContent() {
    guard isEnabled else { return }
    DispatchQueue.main.async { [weak self] in
      guard let self = self, self.isEnabled else { return }
      guard self.secureTextField == nil else { return }
      guard let window = self.resolveWindow() else {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
          self?.secureContent()
        }
        return
      }

      let textField = UITextField(frame: .zero)
      textField.isSecureTextEntry = true
      textField.isUserInteractionEnabled = false
      textField.backgroundColor = .clear
      textField.translatesAutoresizingMaskIntoConstraints = false

      if let controllerView = window.rootViewController?.view,
         let superlayer = controllerView.layer.superlayer {
        controllerView.addSubview(textField)
        NSLayoutConstraint.activate([
          textField.centerXAnchor.constraint(equalTo: controllerView.centerXAnchor),
          textField.centerYAnchor.constraint(equalTo: controllerView.centerYAnchor),
          textField.widthAnchor.constraint(equalToConstant: 1),
          textField.heightAnchor.constraint(equalToConstant: 1),
        ])

        superlayer.addSublayer(textField.layer)
        if let secureLayer = textField.layer.sublayers?.first ?? textField.layer.sublayers?.last {
          secureLayer.addSublayer(controllerView.layer)
        }
      } else if let superlayer = window.layer.superlayer {
        window.addSubview(textField)
        NSLayoutConstraint.activate([
          textField.centerXAnchor.constraint(equalTo: window.centerXAnchor),
          textField.centerYAnchor.constraint(equalTo: window.centerYAnchor),
          textField.widthAnchor.constraint(equalToConstant: 1),
          textField.heightAnchor.constraint(equalToConstant: 1),
        ])

        superlayer.addSublayer(textField.layer)
        if let secureLayer = textField.layer.sublayers?.first ?? textField.layer.sublayers?.last {
          secureLayer.addSublayer(window.layer)
        }
      } else {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
          self?.secureContent()
        }
        return
      }

      self.secureTextField = textField
    }
  }

  @objc private func showPrivacyOverlay() {
    guard isEnabled else { return }
    setPrivacyOverlayVisible(true)
  }

  @objc private func didBecomeActive() {
    if isEnabled {
      secureContent()
      updatePrivacyOverlay()
    }
  }

  @objc private func updatePrivacyOverlay() {
    let recording = isScreenRecording
    setPrivacyOverlayVisible(isEnabled && recording)
    DispatchQueue.main.async { [weak self] in
      self?.channel?.invokeMethod("onScreenRecordingChanged", arguments: recording)
    }
  }

  private var isScreenRecording: Bool {
    return UIScreen.main.isCaptured
  }

  private func setPrivacyOverlayVisible(_ visible: Bool) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      guard let window = self.resolveWindow() else { return }

      if visible && self.isEnabled {
        if self.privacyView == nil {
          let overlay = UIView(frame: window.bounds)
          overlay.backgroundColor = .black
          overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]

          let label = UILabel()
          label.text = "عفواً، لا يمكن تصوير أو تسجيل الشاشة"
          label.textColor = .white
          label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
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

          self.privacyView = overlay
        }

        if let overlay = self.privacyView {
          overlay.frame = window.bounds
          if overlay.superview == nil {
            window.addSubview(overlay)
          }
          window.bringSubviewToFront(overlay)
        }
      } else {
        if !self.isScreenRecording && UIApplication.shared.applicationState == .active {
          self.privacyView?.removeFromSuperview()
        }
      }
    }
  }
}
