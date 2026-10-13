import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  override func sceneDidBecomeActive(_ scene: UIScene) {
    super.sceneDidBecomeActive(scene)
    ScreenSecurityManager.shared.enable()
    ScreenSecurityManager.shared.removePrivacyOverlayIfSafe()
  }

  override func sceneWillResignActive(_ scene: UIScene) {
    super.sceneWillResignActive(scene)
    ScreenSecurityManager.shared.showPrivacyOverlayImmediately()
  }

  override func sceneDidEnterBackground(_ scene: UIScene) {
    super.sceneDidEnterBackground(scene)
    ScreenSecurityManager.shared.showPrivacyOverlayImmediately()
  }
}
