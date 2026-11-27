// Ares desktop integration for the primary macOS window
// (docs/desktop-os-native.md):
//
//   com.hermesagent.ares/shell   setTray, showWindow, quit; onTrayAction
//   com.hermesagent.ares/hotkey  register, unregister; onHotKey
//   com.hermesagent.ares/power   isSupported, setAwake; onPowerEvent
//   com.hermesagent.ares/capture status, requestPermission, openSettings,
//                                capture
//
// Only the primary process creates this. Pop-out, companion and quick-entry
// children are separate processes started with a marker argument and never
// own a menu-bar item.

import Carbon.HIToolbox
import Cocoa
import FlutterMacOS
import IOKit.pwr_mgt
import ScreenCaptureKit

/// True when this process is a child window (pop-out chat, companion or
/// quick entry), started by the primary with a marker argument.
enum AresProcessRole {
  static let childMarkers: Set<String> = [
    "--ares-workspace-chat-v1",
    "--ares-pet-companion-v1",
    "--ares-quick-entry-v1",
  ]

  static var isChild: Bool {
    !childMarkers.isDisjoint(with: CommandLine.arguments.dropFirst())
  }
}

final class AresDesktopOS: NSObject {
  private let shellChannel: FlutterMethodChannel
  private let hotkeyChannel: FlutterMethodChannel
  private weak var window: NSWindow?

  private var hotKeyRef: EventHotKeyRef?
  private var hotKeyHandler: EventHandlerRef?

  private let powerChannel: FlutterMethodChannel
  private let captureChannel: FlutterMethodChannel
  private var capturing = false
  private var powerObservers: [(NotificationCenter, NSObjectProtocol)] = []
  private var awakeOwners = Set<String>()
  private var awakeAssertion: IOPMAssertionID?

  private var statusItem: NSStatusItem?
  private var trayItemIds: [String] = []

  /// Closing the main window hides it while the menu-bar item is shown.
  private(set) var closeToTray = false

  init(messenger: FlutterBinaryMessenger, window: NSWindow?) {
    shellChannel = FlutterMethodChannel(
      name: "com.hermesagent.ares/shell",
      binaryMessenger: messenger
    )
    hotkeyChannel = FlutterMethodChannel(
      name: "com.hermesagent.ares/hotkey",
      binaryMessenger: messenger
    )
    powerChannel = FlutterMethodChannel(
      name: "com.hermesagent.ares/power",
      binaryMessenger: messenger
    )
    captureChannel = FlutterMethodChannel(
      name: "com.hermesagent.ares/capture",
      binaryMessenger: messenger
    )
    self.window = window
    super.init()
    // A hidden window must be shown again, not recreated.
    window?.isReleasedWhenClosed = false
    shellChannel.setMethodCallHandler { [weak self] call, result in
      self?.handleShell(call, result: result)
    }
    hotkeyChannel.setMethodCallHandler { [weak self] call, result in
      self?.handleHotkey(call, result: result)
    }
    powerChannel.setMethodCallHandler { [weak self] call, result in
      self?.handlePower(call, result: result)
    }
    captureChannel.setMethodCallHandler { [weak self] call, result in
      self?.handleCapture(call, result: result)
    }
    observePower()
  }

  func shutdown() {
    // Exit releases the hotkey even if Dart never got to unregister it.
    unregisterHotKey()
    if let handler = hotKeyHandler {
      RemoveEventHandler(handler)
      hotKeyHandler = nil
    }
    removeStatusItem()
    for (center, token) in powerObservers {
      center.removeObserver(token)
    }
    powerObservers = []
    awakeOwners.removeAll()
    updateAwakeAssertion()
    shellChannel.setMethodCallHandler(nil)
    hotkeyChannel.setMethodCallHandler(nil)
    powerChannel.setMethodCallHandler(nil)
    captureChannel.setMethodCallHandler(nil)
  }

  // MARK: - Screen capture (frontmost window of another app)

  private static let askedKey = "ares.capture.permissionRequested"

  private func captureStatus() -> [String: Any] {
    let supported: Bool
    if #available(macOS 14.0, *) { supported = true } else { supported = false }
    let permission: String
    if CGPreflightScreenCaptureAccess() {
      permission = "granted"
    } else if UserDefaults.standard.bool(forKey: Self.askedKey) {
      permission = "denied"
    } else {
      permission = "prompt"
    }
    return ["supported": supported, "permission": permission]
  }

  private func handleCapture(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "status":
      result(captureStatus())
    case "requestPermission":
      // Shows the system prompt once; later the user grants it in Settings.
      UserDefaults.standard.set(true, forKey: Self.askedKey)
      _ = CGRequestScreenCaptureAccess()
      result(captureStatus())
    case "openSettings":
      let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture")
      result(url.map { NSWorkspace.shared.open($0) } ?? false)
    case "capture":
      guard let args = call.arguments as? [String: Any],
            let directory = args["directory"] as? String, !directory.isEmpty
      else {
        result(FlutterError(code: "bad-args", message: "capture expects {directory}", details: nil))
        return
      }
      guard #available(macOS 14.0, *) else {
        result(FlutterError(code: "unsupported", message: "Needs macOS 14", details: nil))
        return
      }
      guard CGPreflightScreenCaptureAccess() else {
        result(FlutterError(code: "permission-denied", message: nil, details: nil))
        return
      }
      guard !capturing else {
        result(FlutterError(code: "failed", message: "busy", details: nil))
        return
      }
      capturing = true
      Task { @MainActor [weak self] in
        defer { self?.capturing = false }
        do {
          let image = try await AresWindowCapture.frontmostImage()
          let path = try AresWindowCapture.writePNG(image, directory: directory)
          result(path)
        } catch {
          result(FlutterError(code: "failed", message: nil, details: nil))
        }
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - Power: sleep/wake, lock/unlock, keep-awake

  private func observePower() {
    let workspace = NSWorkspace.shared.notificationCenter
    let distributed = DistributedNotificationCenter.default()
    let events: [(NotificationCenter, Notification.Name, String)] = [
      (workspace, NSWorkspace.willSleepNotification, "suspend"),
      (workspace, NSWorkspace.didWakeNotification, "resume"),
      // Fast user switching away is a lock for this session.
      (workspace, NSWorkspace.sessionDidResignActiveNotification, "lock"),
      (workspace, NSWorkspace.sessionDidBecomeActiveNotification, "unlock"),
      (distributed, Notification.Name("com.apple.screenIsLocked"), "lock"),
      (distributed, Notification.Name("com.apple.screenIsUnlocked"), "unlock"),
    ]
    for (center, name, event) in events {
      let token = center.addObserver(forName: name, object: nil, queue: .main) { [weak self] _ in
        self?.powerChannel.invokeMethod("onPowerEvent", arguments: event)
      }
      powerObservers.append((center, token))
    }
  }

  private func handlePower(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isSupported":
      result(true)
    case "setAwake":
      guard let args = call.arguments as? [String: Any],
            let owner = args["owner"] as? String, (1...128).contains(owner.count)
      else {
        result(FlutterError(code: "bad-args", message: "setAwake expects {owner, enabled}", details: nil))
        return
      }
      if args["enabled"] as? Bool == true {
        if awakeOwners.count < 32 { awakeOwners.insert(owner) }
      } else {
        awakeOwners.remove(owner)
      }
      updateAwakeAssertion()
      result(nil)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// Prevents idle system sleep (not display sleep) while any owner asks.
  private func updateAwakeAssertion() {
    if awakeOwners.isEmpty {
      if let id = awakeAssertion {
        IOPMAssertionRelease(id)
        awakeAssertion = nil
      }
      return
    }
    guard awakeAssertion == nil else { return }
    var id = IOPMAssertionID(0)
    let status = IOPMAssertionCreateWithName(
      kIOPMAssertionTypePreventUserIdleSystemSleep as CFString,
      IOPMAssertionLevel(kIOPMAssertionLevelOn),
      "Ares is working on a reply" as CFString,
      &id
    )
    if status == kIOReturnSuccess { awakeAssertion = id }
  }

  // MARK: - Global hotkey (Carbon; needs no Accessibility permission)

  private func handleHotkey(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isSupported":
      // Carbon hot keys work in every macOS session.
      result(true)
    case "unregister":
      unregisterHotKey()
      result(nil)
    case "register":
      guard let args = call.arguments as? [String: Any] else {
        result(FlutterError(code: "bad-args", message: "register expects a map", details: nil))
        return
      }
      result(registerHotKey(args))
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func registerHotKey(_ args: [String: Any]) -> String {
    let command = args["meta"] as? Bool == true
    let control = args["ctrl"] as? Bool == true
    let option = args["alt"] as? Bool == true
    let shift = args["shift"] as? Bool == true
    guard command || control || option,
          let key = args["key"] as? String,
          let code = AresHotkeyKeys.keyCode(for: key)
    else { return "invalid" }
    unregisterHotKey()
    guard installHotKeyHandler() else { return "unsupported" }
    var modifiers: UInt32 = 0
    if command { modifiers |= UInt32(cmdKey) }
    if control { modifiers |= UInt32(controlKey) }
    if option { modifiers |= UInt32(optionKey) }
    if shift { modifiers |= UInt32(shiftKey) }
    let id = EventHotKeyID(signature: OSType(0x4152_4553), id: 1)  // 'ARES'
    var ref: EventHotKeyRef?
    let status = RegisterEventHotKey(
      UInt32(code), modifiers, id, GetApplicationEventTarget(), 0, &ref)
    if status == noErr, let ref = ref {
      hotKeyRef = ref
      return "registered"
    }
    return status == OSStatus(eventHotKeyExistsErr) ? "conflict" : "unsupported"
  }

  private func unregisterHotKey() {
    if let ref = hotKeyRef {
      UnregisterEventHotKey(ref)
      hotKeyRef = nil
    }
  }

  private func installHotKeyHandler() -> Bool {
    if hotKeyHandler != nil { return true }
    var spec = EventTypeSpec(
      eventClass: OSType(kEventClassKeyboard),
      eventKind: UInt32(kEventHotKeyPressed)
    )
    let status = InstallEventHandler(
      GetApplicationEventTarget(),
      { _, _, userData -> OSStatus in
        guard let userData = userData else { return noErr }
        let owner = Unmanaged<AresDesktopOS>.fromOpaque(userData).takeUnretainedValue()
        DispatchQueue.main.async { owner.hotKeyPressed() }
        return noErr
      },
      1,
      &spec,
      Unmanaged.passUnretained(self).toOpaque(),
      &hotKeyHandler
    )
    return status == noErr
  }

  private func hotKeyPressed() {
    guard hotKeyRef != nil else { return }
    hotkeyChannel.invokeMethod("onHotKey", arguments: nil)
  }

  // MARK: - Shell

  private func handleShell(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "showWindow":
      showMainWindow()
      result(nil)
    case "quit":
      closeToTray = false
      removeStatusItem()
      // Reply first; terminate on the next turn of the run loop.
      result(nil)
      DispatchQueue.main.async { NSApp.terminate(nil) }
    case "isTraySupported":
      result(true)
    case "setTray":
      guard let args = call.arguments as? [String: Any] else {
        result(FlutterError(code: "bad-args", message: "setTray expects a map", details: nil))
        return
      }
      result(applyTray(args))
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  func showMainWindow() {
    NSApp.activate(ignoringOtherApps: true)
    guard let window = window else { return }
    if window.isMiniaturized { window.deminiaturize(nil) }
    window.makeKeyAndOrderFront(nil)
  }

  private func applyTray(_ args: [String: Any]) -> Bool {
    guard args["enabled"] as? Bool == true else {
      closeToTray = false
      removeStatusItem()
      return false
    }
    let item = statusItem ?? NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    statusItem = item
    if let button = item.button {
      let image = NSImage(systemSymbolName: "bubble.left.and.bubble.right", accessibilityDescription: "Ares")
      image?.isTemplate = true
      button.image = image
      button.toolTip = AresDesktopText.clean(args["tooltip"] as? String ?? "Ares", limit: 127)
    }
    let menu = NSMenu()
    menu.autoenablesItems = false
    trayItemIds = []
    for entry in (args["items"] as? [Any] ?? []).prefix(16) {
      guard let map = entry as? [String: Any],
            let id = map["id"] as? String, AresDesktopText.isItemId(id)
      else { continue }
      let label = AresDesktopText.clean(map["label"] as? String ?? "", limit: 64)
      guard !label.isEmpty else { continue }
      if map["separatorBefore"] as? Bool == true, !trayItemIds.isEmpty {
        menu.addItem(.separator())
      }
      let menuItem = NSMenuItem(title: label, action: #selector(trayItemChosen(_:)), keyEquivalent: "")
      menuItem.target = self
      menuItem.tag = trayItemIds.count
      menuItem.state = map["checked"] as? Bool == true ? .on : .off
      menu.addItem(menuItem)
      trayItemIds.append(id)
    }
    item.menu = menu
    closeToTray = args["closeToTray"] as? Bool == true
    return true
  }

  private func removeStatusItem() {
    if let item = statusItem {
      NSStatusBar.system.removeStatusItem(item)
    }
    statusItem = nil
    trayItemIds = []
  }

  @objc private func trayItemChosen(_ sender: NSMenuItem) {
    guard trayItemIds.indices.contains(sender.tag) else { return }
    shellChannel.invokeMethod("onTrayAction", arguments: trayItemIds[sender.tag])
  }
}

/// Captures the frontmost window that does not belong to Ares (any Ares
/// process: main, pop-out, companion, quick entry), or the main display
/// without Ares' windows when there is none.
@available(macOS 14.0, *)
enum AresWindowCapture {
  enum Failure: Error { case noContent, encode }

  @MainActor
  static func frontmostImage() async throws -> CGImage {
    let content = try await SCShareableContent.excludingDesktopWindows(
      true, onScreenWindowsOnly: true)
    let ownBundle = Bundle.main.bundleIdentifier
    func isAres(_ pid: pid_t) -> Bool {
      pid == getpid() ||
        (ownBundle != nil &&
          NSRunningApplication(processIdentifier: pid)?.bundleIdentifier == ownBundle)
    }
    // CGWindowList is front-to-back; ScreenCaptureKit's list is unordered.
    let ordered = (CGWindowListCopyWindowInfo(
      [.optionOnScreenOnly, .excludeDesktopElements], kCGNullWindowID)
      as? [[String: Any]]) ?? []
    for entry in ordered {
      guard (entry[kCGWindowLayer as String] as? Int) == 0,
            let pid = entry[kCGWindowOwnerPID as String] as? pid_t, !isAres(pid),
            let number = entry[kCGWindowNumber as String] as? UInt32,
            let window = content.windows.first(where: { $0.windowID == number }),
            window.frame.width >= 40, window.frame.height >= 40
      else { continue }
      let filter = SCContentFilter(desktopIndependentWindow: window)
      return try await capture(filter, size: window.frame.size)
    }
    guard let display = content.displays.first(where: {
      $0.displayID == CGMainDisplayID()
    }) ?? content.displays.first else { throw Failure.noContent }
    let ares = content.applications.filter { isAres($0.processID) }
    let filter = SCContentFilter(
      display: display, excludingApplications: ares, exceptingWindows: [])
    return try await capture(filter, size: display.frame.size)
  }

  @MainActor
  private static func capture(_ filter: SCContentFilter, size: CGSize) async throws -> CGImage {
    let config = SCStreamConfiguration()
    let scale = CGFloat(filter.pointPixelScale)
    config.width = max(1, Int(size.width * scale))
    config.height = max(1, Int(size.height * scale))
    config.showsCursor = false
    return try await SCScreenshotManager.captureImage(
      contentFilter: filter, configuration: config)
  }

  static func writePNG(_ image: CGImage, directory: String) throws -> String {
    let rep = NSBitmapImageRep(cgImage: image)
    guard let data = rep.representation(using: .png, properties: [:]) else {
      throw Failure.encode
    }
    let name = "screenshot-\(Int(Date().timeIntervalSince1970 * 1000)).png"
    let url = URL(fileURLWithPath: directory, isDirectory: true).appendingPathComponent(name)
    try data.write(to: url, options: .withoutOverwriting)
    return url.path
  }
}

/// shortcuts_store key names to Carbon virtual key codes.
enum AresHotkeyKeys {
  static func keyCode(for name: String) -> Int? {
    if name.count == 4, name.hasPrefix("key"), let letter = name.last,
       let code = letters[letter] {
      return code
    }
    if name.count == 6, name.hasPrefix("digit"), let digit = name.last,
       let code = digits[digit] {
      return code
    }
    return named[name]
  }

  private static let letters: [Character: Int] = [
    "A": kVK_ANSI_A, "B": kVK_ANSI_B, "C": kVK_ANSI_C, "D": kVK_ANSI_D,
    "E": kVK_ANSI_E, "F": kVK_ANSI_F, "G": kVK_ANSI_G, "H": kVK_ANSI_H,
    "I": kVK_ANSI_I, "J": kVK_ANSI_J, "K": kVK_ANSI_K, "L": kVK_ANSI_L,
    "M": kVK_ANSI_M, "N": kVK_ANSI_N, "O": kVK_ANSI_O, "P": kVK_ANSI_P,
    "Q": kVK_ANSI_Q, "R": kVK_ANSI_R, "S": kVK_ANSI_S, "T": kVK_ANSI_T,
    "U": kVK_ANSI_U, "V": kVK_ANSI_V, "W": kVK_ANSI_W, "X": kVK_ANSI_X,
    "Y": kVK_ANSI_Y, "Z": kVK_ANSI_Z,
  ]

  private static let digits: [Character: Int] = [
    "0": kVK_ANSI_0, "1": kVK_ANSI_1, "2": kVK_ANSI_2, "3": kVK_ANSI_3,
    "4": kVK_ANSI_4, "5": kVK_ANSI_5, "6": kVK_ANSI_6, "7": kVK_ANSI_7,
    "8": kVK_ANSI_8, "9": kVK_ANSI_9,
  ]

  private static let named: [String: Int] = [
    "space": kVK_Space, "enter": kVK_Return, "escape": kVK_Escape,
    "tab": kVK_Tab, "comma": kVK_ANSI_Comma, "period": kVK_ANSI_Period,
    "slash": kVK_ANSI_Slash, "semicolon": kVK_ANSI_Semicolon,
    "quoteSingle": kVK_ANSI_Quote, "backslash": kVK_ANSI_Backslash,
    "minus": kVK_ANSI_Minus, "equal": kVK_ANSI_Equal,
    "bracketLeft": kVK_ANSI_LeftBracket, "bracketRight": kVK_ANSI_RightBracket,
    "backquote": kVK_ANSI_Grave, "arrowLeft": kVK_LeftArrow,
    "arrowRight": kVK_RightArrow, "arrowUp": kVK_UpArrow,
    "arrowDown": kVK_DownArrow, "home": kVK_Home, "end": kVK_End,
    "pageUp": kVK_PageUp, "pageDown": kVK_PageDown,
    "delete": kVK_ForwardDelete,
  ]
}

/// Label rules shared with the Windows and Linux runners.
enum AresDesktopText {
  static func isItemId(_ id: String) -> Bool {
    guard (1...32).contains(id.count) else { return false }
    return id.unicodeScalars.allSatisfy { ("a"..."z").contains($0) || $0 == "-" }
  }

  /// Drops control characters and bounds the length.
  static func clean(_ text: String, limit: Int) -> String {
    let scalars = text.unicodeScalars.filter { scalar in
      !(scalar.value < 0x20 || (0x7F..<0xA0).contains(scalar.value))
    }
    return String(String.UnicodeScalarView(scalars).prefix(limit))
  }
}
