import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {
  override func awakeFromNib() {
    let arguments = Array(CommandLine.arguments.dropFirst())
    let flutterViewController: FlutterViewController
    var minimumSize = NSSize(width: 480, height: 420)
    if !AresProcessRole.childMarkers.isDisjoint(with: arguments) {
      let project = FlutterDartProject()
      project.dartEntrypointArguments = arguments
      flutterViewController = FlutterViewController(project: project)
      let companion = arguments.contains("--ares-pet-companion-v1")
      let quickEntry = arguments.contains("--ares-quick-entry-v1")
      self.title = quickEntry ? "Ares — Quick entry" : companion ? "Ares — Companion" : "Ares — Chat"
      self.isRestorable = false
      if companion {
        self.level = .floating
        self.setContentSize(NSSize(width: 360, height: 520))
      }
      if quickEntry {
        // A small always-on-top panel over the current Space, also over
        // full-screen apps, a fifth of the way down the active screen.
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        minimumSize = NSSize(width: 420, height: 180)
        let size = NSSize(width: 640, height: 220)
        self.setContentSize(size)
        if let screen = NSScreen.main {
          let area = screen.visibleFrame
          let frame = self.frameRect(forContentRect: NSRect(origin: .zero, size: size))
          self.setFrameOrigin(NSPoint(
            x: area.midX - frame.width / 2,
            y: area.maxY - area.height / 5 - frame.height
          ))
        }
      }
    } else {
      flutterViewController = FlutterViewController()
    }
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)
    self.contentMinSize = minimumSize

    RegisterGeneratedPlugins(registry: flutterViewController)

    super.awakeFromNib()
    if arguments.contains("--ares-quick-entry-v1") {
      NSApp.activate(ignoringOtherApps: true)
      self.makeKeyAndOrderFront(nil)
    }
  }
}
