// Stand-ins for the generated plugin registrant and the shared Apple layer
// (apple/AresApple.swift), so macos_typecheck.sh checks only the runner.

import Foundation
import FlutterMacOS

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {}

final class AresAppleChannels {
  init(messenger: FlutterBinaryMessenger) {}
}

final class AresDeepLinkInbox {
  @discardableResult func receive(_ url: URL) -> Bool { false }
  func attach(messenger: FlutterBinaryMessenger) {}
  func detach() {}
}
