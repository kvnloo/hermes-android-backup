import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  private var aresChannels: AresAppleChannels?
  private var keepAwake: AresKeepAwakeChannel?
  private let deepLinks = AresDeepLinkInbox()

  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)
    registerAresChannels()
    // Cold launch from a hermes:// link: Dart reads it with getInitialLink.
    for context in connectionOptions.urlContexts {
      deepLinks.receive(context.url)
    }
  }

  // Warm: a hermes:// link while the scene is connected.
  override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    super.scene(scene, openURLContexts: URLContexts)
    registerAresChannels()
    for context in URLContexts {
      deepLinks.receive(context.url)
    }
  }

  override func sceneDidBecomeActive(_ scene: UIScene) {
    super.sceneDidBecomeActive(scene)
    registerAresChannels()
  }

  private func registerAresChannels() {
    guard aresChannels == nil,
          let controller = window?.rootViewController as? FlutterViewController
    else { return }
    aresChannels = AresAppleChannels(messenger: controller.binaryMessenger)
    keepAwake = AresKeepAwakeChannel(messenger: controller.binaryMessenger)
    deepLinks.attach(messenger: controller.binaryMessenger)
  }
}

/// `com.hermesagent.ares/power` on iOS (Settings → Keep screen on): the same
/// `isSupported` / `setAwake {owner, enabled}` contract as the desktop
/// runners, implemented with `UIApplication.isIdleTimerDisabled`. iOS ignores
/// the flag in the background, and Dart also releases it when the app pauses.
final class AresKeepAwakeChannel {
  private let channel: FlutterMethodChannel
  private var owners = Set<String>()

  init(messenger: FlutterBinaryMessenger) {
    channel = FlutterMethodChannel(
      name: "com.hermesagent.ares/power",
      binaryMessenger: messenger
    )
    channel.setMethodCallHandler { [weak self] call, result in
      self?.handle(call, result: result)
    }
  }

  deinit {
    channel.setMethodCallHandler(nil)
    if !owners.isEmpty {
      DispatchQueue.main.async { UIApplication.shared.isIdleTimerDisabled = false }
    }
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isSupported":
      result(true)
    case "setAwake":
      guard let args = call.arguments as? [String: Any],
            let owner = args["owner"] as? String, (1...128).contains(owner.count),
            let enabled = args["enabled"] as? Bool
      else {
        result(FlutterError(code: "bad-args", message: "setAwake expects {owner, enabled}", details: nil))
        return
      }
      if enabled {
        if owners.count < 32 { owners.insert(owner) }
      } else {
        owners.remove(owner)
      }
      UIApplication.shared.isIdleTimerDisabled = !owners.isEmpty
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
