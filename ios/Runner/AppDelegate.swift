import UIKit
import Flutter
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
    private let screenSecurityChannel = "elhanbly/screen_security"
    weak var screen: UIView? = nil
    var overlayController = UIViewController()
    private var secureTextField: UITextField?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
            GeneratedPluginRegistrant.register(with: registry)
        }

        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        } else {
            let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }

        GeneratedPluginRegistrant.register(with: self)
        registerScreenSecurityChannel()

        NotificationCenter.default.addObserver(self, selector: #selector(screenRecordingStatusChanged), name: UIScreen.capturedDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(screenshotHasTaken), name: UIApplication.userDidTakeScreenshotNotification, object: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.makeSecure()
            if self?.checkIsScreenRecording() == true {
                self?.displayOverlayControllerWith(message: "Screen recording is not allowed while using the app. Kindly turn off the screen recording to continue using the app.")
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
        registerScreenSecurityChannel()
    }

    private func registerScreenSecurityChannel() {
        guard let controller = resolveFlutterViewController() else { return }

        let channel = FlutterMethodChannel(
            name: screenSecurityChannel,
            binaryMessenger: controller.binaryMessenger
        )

        channel.setMethodCallHandler { [weak self] call, result in
            switch call.method {
            case "enable":
                self?.makeSecure()
                result(nil)
            case "disable":
                result(nil)
            case "isScreenRecording":
                result(self?.checkIsScreenRecording() ?? false)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }

    private func resolveWindow() -> UIWindow? {
        if let appWindow = self.window { return appWindow }
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        return scenes.flatMap({ $0.windows }).first(where: { $0.isKeyWindow }) ?? scenes.flatMap({ $0.windows }).first
    }

    private func resolveFlutterViewController() -> FlutterViewController? {
        if let controller = self.window?.rootViewController as? FlutterViewController {
            return controller
        }
        let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
        for scene in scenes {
            for win in scene.windows {
                if let flutterVC = win.rootViewController as? FlutterViewController {
                    return flutterVC
                }
            }
        }
        return nil
    }

    func makeSecure() {
        guard secureTextField == nil else { return }
        guard let window = resolveWindow(),
              let controller = resolveFlutterViewController(),
              let controllerView = controller.view else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.makeSecure()
            }
            return
        }

        let field = UITextField()
        field.isSecureTextEntry = true
        field.isUserInteractionEnabled = false
        field.backgroundColor = .clear
        field.translatesAutoresizingMaskIntoConstraints = false
        field.tag = 888999

        // Add to window as sibling to avoid circular layer graph
        window.addSubview(field)
        window.sendSubviewToBack(field)

        NSLayoutConstraint.activate([
            field.topAnchor.constraint(equalTo: window.topAnchor),
            field.bottomAnchor.constraint(equalTo: window.bottomAnchor),
            field.leadingAnchor.constraint(equalTo: window.leadingAnchor),
            field.trailingAnchor.constraint(equalTo: window.trailingAnchor)
        ])

        window.layoutIfNeeded()

        let secureLayer = field.subviews.first?.layer ?? field.layer.sublayers?.first
        if let secureLayer = secureLayer {
            secureLayer.addSublayer(controllerView.layer)
        } else {
            field.layer.addSublayer(controllerView.layer)
        }

        self.secureTextField = field
    }

    private func checkIsScreenRecording() -> Bool {
        if let window = resolveWindow(), let scene = window.windowScene {
            return scene.screen.isCaptured
        }
        return UIScreen.main.isCaptured
    }

    override func applicationWillResignActive(_ application: UIApplication) {
        self.blurScreen()
    }

    override func applicationDidBecomeActive(_ application: UIApplication) {
        self.removeBlurScreen()
        self.makeSecure()
        if self.checkIsScreenRecording() {
            self.displayOverlayControllerWith(message: "Screen recording is not allowed while using the app. Kindly turn off the screen recording to continue using the app.")
        } else {
            self.overlayController.dismiss(animated: false, completion: nil)
        }
    }

    @objc func screenRecordingStatusChanged() {
        if checkIsScreenRecording() {
            self.displayOverlayControllerWith(message: "Screen recording is not allowed while using the app. Kindly turn off the screen recording to continue using the app.")
        } else {
            self.overlayController.dismiss(animated: false, completion: nil)
        }
    }

    @objc func screenshotHasTaken() {
    }

    fileprivate func displayOverlayControllerWith(message: String) {
        guard let rootWindow = resolveWindow() else { return }

        self.overlayController.view.backgroundColor = .white
        self.overlayController.modalPresentationStyle = .fullScreen
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height - (rootWindow.safeAreaInsets.top + rootWindow.safeAreaInsets.bottom)
        let frameOfLabel = CGRect(x: 20, y: screenHeight/2 - 100, width: screenWidth - 40, height: 200)

        if let labelMessage = self.overlayController.view.viewWithTag(1010) as? UILabel {
            labelMessage.text = message
        } else {
            let labelMessage = UILabel(frame: frameOfLabel)
            labelMessage.tag = 1010
            labelMessage.numberOfLines = 0
            labelMessage.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            labelMessage.text = message
            labelMessage.textColor = .black
            labelMessage.textAlignment = .center
            self.overlayController.view.addSubview(labelMessage)
        }

        if self.overlayController.presentingViewController == nil {
            rootWindow.rootViewController?.present(self.overlayController, animated: false, completion: nil)
        }
    }

    func blurScreen(style: UIBlurEffect.Style = UIBlurEffect.Style.regular) {
        guard let targetWindow = resolveWindow() else { return }
        if screen != nil { return }

        let snap = UIScreen.main.snapshotView(afterScreenUpdates: false)
        let blurEffect = UIBlurEffect(style: style)
        let blurBackground = UIVisualEffectView(effect: blurEffect)
        snap.addSubview(blurBackground)
        blurBackground.frame = snap.frame
        targetWindow.addSubview(snap)
        targetWindow.bringSubviewToFront(snap)
        self.screen = snap
    }

    func removeBlurScreen() {
        screen?.removeFromSuperview()
        screen = nil
    }
}
