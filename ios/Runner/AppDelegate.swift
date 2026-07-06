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
    ScreenSecurityManager.shared.enable()
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
    channel.setMethodCallHandler { call, result in
      if call.method == "enable" {
        ScreenSecurityManager.shared.enable()
        result(nil)
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
  private var isEnabled = false

  private init() {}

  func enable() {
    guard !isEnabled else { return }
    isEnabled = true

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
      selector: #selector(updatePrivacyOverlay),
      name: UIApplication.didBecomeActiveNotification,
      object: nil
    )

    secureWindowContent()
    updatePrivacyOverlay()
  }

  private func secureWindowContent() {
    guard secureTextField == nil, let window = activeWindow else { return }

    let textField = UITextField(frame: .zero)
    textField.isSecureTextEntry = true
    textField.isUserInteractionEnabled = false
    textField.backgroundColor = .clear
    textField.translatesAutoresizingMaskIntoConstraints = false

    window.addSubview(textField)
    NSLayoutConstraint.activate([
      textField.centerXAnchor.constraint(equalTo: window.centerXAnchor),
      textField.centerYAnchor.constraint(equalTo: window.centerYAnchor),
      textField.widthAnchor.constraint(equalToConstant: 1),
      textField.heightAnchor.constraint(equalToConstant: 1),
    ])

    secureTextField = textField
  }

  @objc private func showPrivacyOverlay() {
    setPrivacyOverlayVisible(true)
  }

  @objc private func updatePrivacyOverlay() {
    setPrivacyOverlayVisible(UIScreen.main.isCaptured)
  }

  private func setPrivacyOverlayVisible(_ visible: Bool) {
    guard let window = activeWindow else { return }

    if visible {
      if privacyView == nil {
        let view = UIView(frame: window.bounds)
        view.backgroundColor = UIColor.black
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        privacyView = view
      }

      if privacyView?.superview == nil, let privacyView = privacyView {
        window.addSubview(privacyView)
      }
    } else {
      privacyView?.removeFromSuperview()
    }
  }

  private var activeWindow: UIWindow? {
    UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .first { $0.isKeyWindow }
  }
}
