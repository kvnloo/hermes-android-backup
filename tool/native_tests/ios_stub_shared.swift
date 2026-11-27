// Stand-in for apple/AresApple.swift's channel owner (not under test here).
import Foundation
import Flutter

final class AresAppleChannels {
  init(messenger: FlutterBinaryMessenger) {}
}

final class AresDeepLinkInbox {
  @discardableResult func receive(_ url: URL) -> Bool { false }
  func attach(messenger: FlutterBinaryMessenger) {}
  func detach() {}
}
