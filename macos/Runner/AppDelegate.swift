import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
  private var aresChannels: AresAppleChannels?
  private var desktopOS: AresDesktopOS?
  // hermes:// links: created up front because a cold-start link can arrive
  // before applicationDidFinishLaunching.
  private let deepLinks = AresDeepLinkInbox()

  override func applicationDidFinishLaunching(_ notification: Notification) {
    registerAresChannels()
    super.applicationDidFinishLaunching(notification)
  }

  private func registerAresChannels() {
    if let controller = mainFlutterWindow?.contentViewController as? FlutterViewController {
      attachChannels(controller)
      return
    }
    DispatchQueue.main.async { [weak self] in
      guard let self = self,
            self.aresChannels == nil,
            let controller = self.mainFlutterWindow?.contentViewController as? FlutterViewController
      else { return }
      self.attachChannels(controller)
    }
  }

  private func attachChannels(_ controller: FlutterViewController) {
    aresChannels = AresAppleChannels(messenger: controller.engine.binaryMessenger)
    // Tray, hotkey, power, capture and deep links belong to the primary
    // window only.
    if !AresProcessRole.isChild {
      desktopOS = AresDesktopOS(
        messenger: controller.engine.binaryMessenger,
        window: mainFlutterWindow
      )
      deepLinks.attach(messenger: controller.engine.binaryMessenger)
    }
  }

  // hermes:// links (Info.plist CFBundleURLTypes), cold and warm.
  override func application(_ application: NSApplication, open urls: [URL]) {
    super.application(application, open: urls)
    // Links belong to the primary window; a child window process ignores them.
    guard !AresProcessRole.isChild else { return }
    var received = false
    for url in urls where deepLinks.receive(url) {
      received = true
    }
    if received { desktopOS?.showMainWindow() }
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    // With the menu-bar item on and "keep running" chosen, closing the
    // window hides Ares; the menu-bar item or the Dock brings it back.
    return !(desktopOS?.closeToTray ?? false)
  }

  override func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
    if !flag { desktopOS?.showMainWindow() }
    return true
  }

  override func applicationWillTerminate(_ notification: Notification) {
    deepLinks.detach()
    desktopOS?.shutdown()
    desktopOS = nil
    super.applicationWillTerminate(notification)
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
