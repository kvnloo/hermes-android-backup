// Declarations-only stand-in for the iOS Flutter framework, used by
// ios_typecheck.sh to type-check ios/Runner/SceneDelegate.swift without an
// engine. Signatures follow the Flutter iOS headers the runner uses.

import UIKit

public typealias FlutterResult = (Any?) -> Void
public typealias FlutterMethodCallHandler = (FlutterMethodCall, @escaping FlutterResult) -> Void

public let FlutterMethodNotImplemented: NSObject = NSObject()

@objc public protocol FlutterBinaryMessenger: NSObjectProtocol {}

open class FlutterMethodCall: NSObject {
  public let method: String
  public let arguments: Any?
  public init(methodName: String, arguments: Any?) {
    self.method = methodName
    self.arguments = arguments
  }
}

open class FlutterError: NSObject {
  public init(code: String, message: String?, details: Any?) {}
}

open class FlutterMethodChannel: NSObject {
  public init(name: String, binaryMessenger messenger: FlutterBinaryMessenger) {}
  open func setMethodCallHandler(_ handler: FlutterMethodCallHandler?) {}
  open func invokeMethod(_ method: String, arguments: Any?) {}
}

open class FlutterViewController: UIViewController {
  public var binaryMessenger: FlutterBinaryMessenger { fatalError() }
}

open class FlutterSceneDelegate: UIResponder, UIWindowSceneDelegate {
  open var window: UIWindow?
  open func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {}
  open func sceneDidBecomeActive(_ scene: UIScene) {}
  open func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {}
  open func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {}
}
