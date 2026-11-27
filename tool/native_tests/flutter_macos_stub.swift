// Declarations-only stand-in for the FlutterMacOS framework, used by
// macos_typecheck.sh to type-check the runner sources without an engine.
// Signatures follow the FlutterMacOS headers the runner uses.

import Cocoa

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

open class FlutterEngine: NSObject {
  public var binaryMessenger: FlutterBinaryMessenger { fatalError() }
}

open class FlutterDartProject: NSObject {
  public override init() {}
  public var dartEntrypointArguments: [String]?
}

public protocol FlutterPluginRegistry: AnyObject {}

open class FlutterViewController: NSViewController, FlutterPluginRegistry {
  public init(project: FlutterDartProject?) { super.init(nibName: nil, bundle: nil) }
  public convenience init() { self.init(project: nil) }
  public required init?(coder: NSCoder) { fatalError() }
  public var engine: FlutterEngine { fatalError() }
}

open class FlutterAppDelegate: NSObject, NSApplicationDelegate {
  @IBOutlet open var mainFlutterWindow: NSWindow?
  open func applicationDidFinishLaunching(_ notification: Notification) {}
  open func applicationWillTerminate(_ notification: Notification) {}
  open func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool { false }
  open func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool { true }
  open func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool { false }
  open func application(_ application: NSApplication, open urls: [URL]) {}
}
