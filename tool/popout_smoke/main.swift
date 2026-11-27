import Cocoa
import FlutterMacOS
// The fixture uses the production NSWindow/current-engine setup with only
// synthetic Dart platform backends. No installed Ares bundle or keychain.
func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {}
let app = NSApplication.shared
_ = app.setActivationPolicy(.regular)
let window = MainFlutterWindow(contentRect:NSRect(x:100,y:100,width:680,height:520),styleMask:[.titled,.closable,.resizable],backing:.buffered,defer:false)
window.title = "Fixture owner"
window.awakeFromNib()
window.makeKeyAndOrderFront(nil)
app.run()
