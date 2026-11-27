// Ares native Apple layer (iOS + macOS).
//
// Implements the cross-platform MethodChannels the Dart app speaks on Android:
//   com.hermesagent.hermes_android/attachment_pdf    open / render / close
//   com.hermesagent.hermes_android/attachment_save   saveFile (cached file export)
//   com.hermesagent.hermes_android/voice_draft       duration / join (AAC M4A)
//
// Channel callbacks run on utility queues and reply on the main thread.

import Foundation
import AVFoundation
import PDFKit

#if os(iOS)
import UIKit
import Flutter
#elseif os(macOS)
import Cocoa
import FlutterMacOS
#endif

// MARK: - Bounds & Helpers

private enum AresPdfBounds {
  static let maxBytes = 25 * 1024 * 1024
  static let maxDimension = 2048
  static let maxPixels = 4 * 1024 * 1024
  static let maxPages = 1000
  static let maxDocuments = 3

  static func dimensions(
    width: Int,
    height: Int,
    maxWidth: Int,
    maxHeight: Int
  ) throws -> (Int, Int) {
    guard (1...100_000).contains(width), (1...100_000).contains(height) else {
      throw NSError(domain: "AresPdf", code: 1)
    }
    guard (1...maxDimension).contains(maxWidth), (1...maxDimension).contains(maxHeight) else {
      throw NSError(domain: "AresPdf", code: 2)
    }
    let scale = min(Double(maxWidth) / Double(width), Double(maxHeight) / Double(height))
    let targetW = min(max(Int((Double(width) * scale).rounded(.down)), 1), maxWidth)
    let targetH = min(max(Int((Double(height) * scale).rounded(.down)), 1), maxHeight)
    guard Int64(targetW) * Int64(targetH) <= Int64(maxPixels) else {
      throw NSError(domain: "AresPdf", code: 3)
    }
    return (targetW, targetH)
  }
}

private final class AresPdfStore {
  private var documents: [String: PDFDocument] = [:]

  func open(bytes: Data) throws -> [String: Any] {
    guard (5...AresPdfBounds.maxBytes).contains(bytes.count) else {
      throw NSError(domain: "AresPdf", code: 10)
    }
    let header = [UInt8](bytes.prefix(5))
    guard header == Array("%PDF-".utf8) else {
      throw NSError(domain: "AresPdf", code: 11)
    }
    guard documents.count < AresPdfBounds.maxDocuments else {
      throw NSError(domain: "AresPdf", code: 12)
    }
    guard let doc = PDFDocument(data: bytes), !doc.isLocked else {
      throw NSError(domain: "AresPdf", code: 13)
    }
    let count = doc.pageCount
    guard (1...AresPdfBounds.maxPages).contains(count) else {
      throw NSError(domain: "AresPdf", code: 14)
    }
    let id = UUID().uuidString
    documents[id] = doc
    return ["id": id, "pageCount": count]
  }

  func render(id: String, pageIndex: Int, maxWidth: Int, maxHeight: Int) throws -> [String: Any] {
    guard let doc = documents[id],
          pageIndex >= 0,
          pageIndex < doc.pageCount,
          let page = doc.page(at: pageIndex)
    else {
      throw NSError(domain: "AresPdf", code: 20)
    }
    let bounds = page.bounds(for: .mediaBox)
    let rotation = ((page.rotation % 360) + 360) % 360
    let pageW = (rotation == 90 || rotation == 270) ? Int(bounds.height.rounded()) : Int(bounds.width.rounded())
    let pageH = (rotation == 90 || rotation == 270) ? Int(bounds.width.rounded()) : Int(bounds.height.rounded())
    let (width, height) = try AresPdfBounds.dimensions(
      width: max(pageW, 1),
      height: max(pageH, 1),
      maxWidth: maxWidth,
      maxHeight: maxHeight
    )

    guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB),
          let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: width * 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
          )
    else {
      throw NSError(domain: "AresPdf", code: 21)
    }

    context.setFillColor(CGColor(red: 1, green: 1, blue: 1, alpha: 1))
    context.fill(CGRect(x: 0, y: 0, width: width, height: height))
    context.saveGState()
    let scaleX = CGFloat(width) / max(bounds.width, 1)
    let scaleY = CGFloat(height) / max(bounds.height, 1)
    let scale = min(scaleX, scaleY)
    context.scaleBy(x: scale, y: scale)
    page.draw(with: .mediaBox, to: context)
    context.restoreGState()

    guard let cgImage = context.makeImage() else {
      throw NSError(domain: "AresPdf", code: 22)
    }

    let pngData: Data?
    #if os(iOS)
    pngData = UIImage(cgImage: cgImage).pngData()
    #elseif os(macOS)
    let rep = NSBitmapImageRep(cgImage: cgImage)
    pngData = rep.representation(using: .png, properties: [:])
    #endif

    guard let data = pngData, !data.isEmpty, data.count <= 16 * 1024 * 1024 else {
      throw NSError(domain: "AresPdf", code: 23)
    }

    return [
      "bytes": FlutterStandardTypedData(bytes: data),
      "width": width,
      "height": height,
    ]
  }

  func close(id: String) {
    documents.removeValue(forKey: id)
  }
}

// MARK: - Voice Draft Media

private enum AresVoiceDraftMedia {
  static let maxBytes: Int64 = 6 * 1024 * 1024
  static let maxDurationMs: Int = 600_000

  private static func voiceDraftsRoot() throws -> URL {
    let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
    guard let support = urls.first else {
      throw NSError(domain: "AresVoice", code: 1)
    }
    return support.appendingPathComponent("voice_drafts", isDirectory: true).standardizedFileURL
  }

  static func ownedFile(_ rawPath: String, existing: Bool = true) throws -> URL {
    let url = URL(fileURLWithPath: rawPath).standardizedFileURL
    let root = try voiceDraftsRoot().resolvingSymlinksInPath()
    let parent = url.deletingLastPathComponent().resolvingSymlinksInPath()
    guard parent.path == root.path, url.pathExtension.lowercased() == "m4a" else {
      throw NSError(domain: "AresVoice", code: 2)
    }
    if existing {
      var isDir: ObjCBool = false
      guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir), !isDir.boolValue else {
        throw NSError(domain: "AresVoice", code: 3)
      }
      let attrs = try FileManager.default.attributesOfItem(atPath: url.path)
      let size = (attrs[.size] as? NSNumber)?.int64Value ?? 0
      guard size >= 1 && size <= maxBytes else {
        throw NSError(domain: "AresVoice", code: 4)
      }
    }
    return url
  }

  static func durationMs(of url: URL) -> Int {
    let asset = AVURLAsset(url: url)
    let seconds = CMTimeGetSeconds(asset.duration)
    guard seconds.isFinite && seconds >= 0 else { return 0 }
    return Int((seconds * 1000.0).rounded())
  }

  static func join(files: [URL], output: URL) throws {
    let totalDuration = files.reduce(0) { $0 + durationMs(of: $1) }
    guard totalDuration <= maxDurationMs else {
      throw NSError(domain: "AresVoice", code: 10)
    }
    let composition = AVMutableComposition()
    guard let track = composition.addMutableTrack(
      withMediaType: .audio,
      preferredTrackID: kCMPersistentTrackID_Invalid
    ) else {
      throw NSError(domain: "AresVoice", code: 11)
    }

    var cursor = CMTime.zero
    for file in files {
      let asset = AVURLAsset(url: file)
      guard let sourceTrack = asset.tracks(withMediaType: .audio).first else {
        throw NSError(domain: "AresVoice", code: 12)
      }
      let range = CMTimeRange(start: .zero, duration: asset.duration)
      try track.insertTimeRange(range, of: sourceTrack, at: cursor)
      cursor = CMTimeAdd(cursor, asset.duration)
    }

    guard let session = AVAssetExportSession(
      asset: composition,
      presetName: AVAssetExportPresetAppleM4A
    ) else {
      throw NSError(domain: "AresVoice", code: 13)
    }
    session.outputURL = output
    session.outputFileType = .m4a

    let sema = DispatchSemaphore(value: 0)
    session.exportAsynchronously {
      sema.signal()
    }
    sema.wait()

    if session.status != .completed {
      try? FileManager.default.removeItem(at: output)
      throw session.error ?? NSError(domain: "AresVoice", code: 14)
    }
    let attrs = try FileManager.default.attributesOfItem(atPath: output.path)
    let size = (attrs[.size] as? NSNumber)?.int64Value ?? 0
    guard size >= 1 && size <= maxBytes else {
      try? FileManager.default.removeItem(at: output)
      throw NSError(domain: "AresVoice", code: 15)
    }
  }
}

// MARK: - Attachment File Saver

private final class AresAttachmentSaver: NSObject {
  private var busy = false

  private static func isCachedFile(_ url: URL) -> Bool {
    var isDir: ObjCBool = false
    guard FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir), !isDir.boolValue else {
      return false
    }
    let resolved = url.resolvingSymlinksInPath().path
    var roots: [String] = [URL(fileURLWithPath: NSTemporaryDirectory()).resolvingSymlinksInPath().path]
    if let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
      roots.append(caches.resolvingSymlinksInPath().path)
    }
    return roots.contains { root in
      resolved.hasPrefix(root.hasSuffix("/") ? root : root + "/")
    }
  }

  #if os(macOS)
  func saveFile(path: String, filename: String, result: @escaping FlutterResult) {
    guard !busy else {
      result(FlutterError(code: "busy", message: "Another save is in progress", details: nil))
      return
    }
    let source = URL(fileURLWithPath: path)
    guard Self.isCachedFile(source) else {
      result(FlutterError(code: "invalid_source", message: "Only downloaded cache files can be saved", details: nil))
      return
    }
    busy = true
    let panel = NSSavePanel()
    panel.nameFieldStringValue = filename.isEmpty ? "attachment" : filename
    panel.canCreateDirectories = true
    let response = panel.runModal()
    guard response == .OK, let dest = panel.url else {
      busy = false
      result(nil)
      return
    }
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
      do {
        if FileManager.default.fileExists(atPath: dest.path) {
          try FileManager.default.removeItem(at: dest)
        }
        try FileManager.default.copyItem(at: source, to: dest)
        DispatchQueue.main.async {
          self?.busy = false
          result(dest.path)
        }
      } catch {
        DispatchQueue.main.async {
          self?.busy = false
          result(FlutterError(code: "write_failed", message: error.localizedDescription, details: nil))
        }
      }
    }
  }
  #elseif os(iOS)
  private var pendingResult: FlutterResult?

  func saveFile(path: String, filename: String, result: @escaping FlutterResult) {
    guard !busy else {
      result(FlutterError(code: "busy", message: "Another save is in progress", details: nil))
      return
    }
    let source = URL(fileURLWithPath: path)
    guard Self.isCachedFile(source) else {
      result(FlutterError(code: "invalid_source", message: "Only downloaded cache files can be saved", details: nil))
      return
    }
    guard let presenter = Self.topViewController() else {
      result(FlutterError(code: "unavailable", message: "No view controller available", details: nil))
      return
    }
    busy = true
    pendingResult = result
    let picker = UIDocumentPickerViewController(forExporting: [source], asCopy: true)
    picker.delegate = self
    presenter.present(picker, animated: true)
  }

  private static func topViewController() -> UIViewController? {
    let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
    let window = scenes.flatMap { $0.windows }.first { $0.isKeyWindow } ?? scenes.flatMap { $0.windows }.first
    var top = window?.rootViewController
    while let presented = top?.presentedViewController {
      top = presented
    }
    return top
  }
  #endif
}

#if os(iOS)
extension AresAttachmentSaver: UIDocumentPickerDelegate {
  func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
    let callback = pendingResult
    pendingResult = nil
    busy = false
    callback?(urls.first?.path)
  }

  func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
    let callback = pendingResult
    pendingResult = nil
    busy = false
    callback?(nil)
  }
}
#endif

// MARK: - Channel Registration

final class AresAppleChannels {
  private let pdfChannel: FlutterMethodChannel
  private let voiceDraftChannel: FlutterMethodChannel
  private let attachmentSaveChannel: FlutterMethodChannel
  private let pdfQueue = DispatchQueue(label: "com.hermesagent.hermes_android.pdf", qos: .userInitiated)
  private let voiceQueue = DispatchQueue(label: "com.hermesagent.hermes_android.voice_draft", qos: .userInitiated)
  private let pdfStore = AresPdfStore()
  private let saver = AresAttachmentSaver()

  init(messenger: FlutterBinaryMessenger) {
    pdfChannel = FlutterMethodChannel(
      name: "com.hermesagent.hermes_android/attachment_pdf",
      binaryMessenger: messenger
    )
    voiceDraftChannel = FlutterMethodChannel(
      name: "com.hermesagent.hermes_android/voice_draft",
      binaryMessenger: messenger
    )
    attachmentSaveChannel = FlutterMethodChannel(
      name: "com.hermesagent.hermes_android/attachment_save",
      binaryMessenger: messenger
    )

    pdfChannel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { return }
      guard ["open", "render", "close"].contains(call.method) else {
        result(FlutterMethodNotImplemented)
        return
      }
      let args = call.arguments as? [String: Any]
      self.pdfQueue.async {
        do {
          let value: Any?
          switch call.method {
          case "open":
            guard let typed = args?["bytes"] as? FlutterStandardTypedData else {
              throw NSError(domain: "AresPdf", code: 30)
            }
            value = try self.pdfStore.open(bytes: typed.data)
          case "render":
            guard let id = args?["id"] as? String,
                  let page = args?["page"] as? Int,
                  let maxWidth = args?["maxWidth"] as? Int,
                  let maxHeight = args?["maxHeight"] as? Int
            else {
              throw NSError(domain: "AresPdf", code: 31)
            }
            value = try self.pdfStore.render(
              id: id,
              pageIndex: page,
              maxWidth: maxWidth,
              maxHeight: maxHeight
            )
          case "close":
            if let id = args?["id"] as? String {
              self.pdfStore.close(id: id)
            }
            value = nil
          default:
            value = nil
          }
          DispatchQueue.main.async { result(value) }
        } catch {
          DispatchQueue.main.async {
            result(FlutterError(code: "pdf_preview", message: "Could not preview this PDF", details: nil))
          }
        }
      }
    }

    voiceDraftChannel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { return }
      let args = call.arguments as? [String: Any]
      self.voiceQueue.async {
        do {
          let value: Any
          switch call.method {
          case "duration":
            let raw = (args?["path"] as? String) ?? ""
            let file = try AresVoiceDraftMedia.ownedFile(raw)
            value = AresVoiceDraftMedia.durationMs(of: file)
          case "join":
            guard let paths = args?["paths"] as? [String], paths.count == 2 else {
              throw NSError(domain: "AresVoice", code: 20)
            }
            let files = try paths.map { try AresVoiceDraftMedia.ownedFile($0) }
            let outRaw = (args?["output"] as? String) ?? ""
            let output = try AresVoiceDraftMedia.ownedFile(outRaw, existing: false)
            guard !files.contains(output), !FileManager.default.fileExists(atPath: output.path) else {
              throw NSError(domain: "AresVoice", code: 21)
            }
            try AresVoiceDraftMedia.join(files: files, output: output)
            value = true
          default:
            DispatchQueue.main.async { result(FlutterMethodNotImplemented) }
            return
          }
          DispatchQueue.main.async { result(value) }
        } catch {
          DispatchQueue.main.async {
            result(
              FlutterError(
                code: "voice_draft",
                message: "Could not process voice recording; fragments retained.",
                details: nil
              )
            )
          }
        }
      }
    }

    attachmentSaveChannel.setMethodCallHandler { [weak self] call, result in
      guard let self = self else { return }
      guard call.method == "saveFile" else {
        result(FlutterMethodNotImplemented)
        return
      }
      let args = call.arguments as? [String: Any]
      let path = (args?["path"] as? String) ?? ""
      let filename = (args?["filename"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "attachment"
      self.saver.saveFile(path: path, filename: filename.isEmpty ? "attachment" : filename, result: result)
    }
  }
}

// MARK: - hermes:// deep links

/// Primary-window inbox for `hermes://` links on `com.hermesagent.ares/deeplink`
/// (iOS SceneDelegate, macOS AppDelegate). The runner never interprets a link:
/// it only bounds it and hands the whole string to Dart's validated router
/// (`lib/core/services/hermes_deeplink.dart`), which can navigate and prefill
/// but never sends, approves or installs anything. A link that arrives before
/// Dart asks for the initial one waits (the latest wins).
final class AresDeepLinkInbox {
  static let maxBytes = 16 * 1024

  private var channel: FlutterMethodChannel?
  private var pending: String?
  private var dartReady = false

  /// Accepts a link from the OS, cold or warm. Returns whether it was one.
  @discardableResult
  func receive(_ url: URL) -> Bool {
    guard url.scheme?.lowercased() == "hermes" else { return false }
    let link = url.absoluteString
    guard link.utf8.count <= AresDeepLinkInbox.maxBytes,
          !link.unicodeScalars.contains(where: { $0.value < 0x20 || $0.value == 0x7f })
    else { return false }
    if let channel = channel, dartReady {
      channel.invokeMethod("onDeepLink", arguments: link)
    } else {
      pending = link
    }
    return true
  }

  func attach(messenger: FlutterBinaryMessenger) {
    guard channel == nil else { return }
    let channel = FlutterMethodChannel(
      name: "com.hermesagent.ares/deeplink",
      binaryMessenger: messenger
    )
    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "getInitialLink" else {
        result(FlutterMethodNotImplemented)
        return
      }
      // Dart listens from here on: later links go straight to it.
      self?.dartReady = true
      let link = self?.pending
      self?.pending = nil
      result(link)
    }
    self.channel = channel
  }

  func detach() {
    channel?.setMethodCallHandler(nil)
    channel = nil
    dartReady = false
  }
}
