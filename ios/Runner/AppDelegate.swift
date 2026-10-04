import UIKit
import Flutter
import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
    weak var screen : UIView? = nil
    var overlayController = UIViewController()

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

        DispatchQueue.main.async { [weak self] in
            self?.window?.makeSecure()
        }

        NotificationCenter.default.addObserver(self, selector: #selector(screenRecordingStatusChanged), name: UIScreen.capturedDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(screenshotHasTaken), name: UIApplication.userDidTakeScreenshotNotification, object: nil)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            if UIScreen.main.isCaptured {
                self?.displayOverlayControllerWith(message: "Screen recording is not allowed while using the app. Kindly turn off the screen recording to continue using the app.")
            }
        }
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func applicationWillResignActive(
        _ application: UIApplication
    ) {
        self.blurScreen()
    }

    override func applicationDidBecomeActive(
        _ application: UIApplication
    ) {
        self.removeBlurScreen()
    }

    @objc func screenRecordingStatusChanged() {
        if UIScreen.main.isCaptured {
            self.displayOverlayControllerWith(message: "Screen recording is not allowed while using the app. Kindly turn off the screen recording to continue using the app.")
        } else {
            self.overlayController.dismiss(animated: false, completion: nil)
        }
    }

    @objc func screenshotHasTaken() {
    }

    fileprivate func displayOverlayControllerWith(message : String) {
        guard let rootWindow = self.window ?? UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first else {
            return
        }

        self.overlayController.view.backgroundColor = .white
        self.overlayController.modalPresentationStyle = .fullScreen
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height - (rootWindow.safeAreaInsets.top + rootWindow.safeAreaInsets.bottom)
        let frameOfLabel = CGRect.init(x: 20, y: screenHeight/2 - 100, width: screenWidth - 40, height: 200)

        if let labelMessage = self.overlayController.view.viewWithTag(1010) as? UILabel {
            labelMessage.text = message
        } else {
            let labelMessage = UILabel.init(frame: frameOfLabel)
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
        guard let targetWindow = self.window ?? UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) ?? UIApplication.shared.windows.first else {
            return
        }

        if screen != nil { return }

        let snap = UIScreen.main.snapshotView(afterScreenUpdates: false)
        let blurEffect = UIBlurEffect(style: style)
        let blurBackground = UIVisualEffectView(effect: blurEffect)
        snap.addSubview(blurBackground)
        blurBackground.frame = snap.frame
        targetWindow.addSubview(snap)
        self.screen = snap
    }

    func removeBlurScreen() {
        screen?.removeFromSuperview()
        screen = nil
    }
}

extension UIWindow {
    func makeSecure() {
        if self.viewWithTag(999888) != nil { return }
        let field = UITextField()
        field.tag = 999888
        field.isSecureTextEntry = true
        field.isUserInteractionEnabled = false
        self.addSubview(field)
        field.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.layer.superlayer?.addSublayer(field.layer)
        field.layer.sublayers?.last?.addSublayer(self.layer)
    }
}
