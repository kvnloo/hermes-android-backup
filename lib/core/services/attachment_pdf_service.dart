import 'dart:typed_data';

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/services.dart' show MethodChannel;
import 'package:pdfx/pdfx.dart';

import 'remote_files_client.dart' show maxAttachmentDownloadBytes;

/// A native renderer handle, not a filesystem path. Android owns its cache
/// file and descriptor, and serialises open/render/close off the UI thread.
///
/// Windows has no native channel: there the document is rendered in-process
/// by pdfx (PDFium), inside the same bounds.
class AttachmentPdfDocument {
  AttachmentPdfDocument._(this.id, this.pageCount, [this._windows]);

  static const channel = MethodChannel(
    'com.hermesagent.hermes_android/attachment_pdf',
  );
  static const maxPageDimension = 2048;
  static const maxPagePixels = 4 * 1024 * 1024;
  static const maxPages = 1000;
  final String id;
  final int pageCount;

  /// The pdfx document on Windows; null where the native channel renders.
  final PdfDocument? _windows;
  var _closed = false;

  static Future<AttachmentPdfDocument> open(Uint8List bytes) async {
    if (bytes.isEmpty || bytes.length > maxAttachmentDownloadBytes) {
      throw const FormatException('PDF exceeds preview bounds');
    }
    if (defaultTargetPlatform == TargetPlatform.windows) {
      return _openWindows(bytes);
    }
    final result = await channel.invokeMapMethod<String, dynamic>('open', {
      'bytes': bytes,
    });
    final id = result?['id'];
    final pages = result?['pageCount'];
    if (id is! String ||
        id.isEmpty ||
        pages is! int ||
        pages < 1 ||
        pages > maxPages) {
      if (id is String && id.isNotEmpty) {
        await channel.invokeMethod<void>('close', {'id': id});
      }
      throw const FormatException('Invalid PDF preview handle');
    }
    return AttachmentPdfDocument._(id, pages);
  }

  Future<Uint8List> render(int page) async {
    if (_closed || page < 0 || page >= pageCount) {
      throw StateError('PDF preview is closed or page is out of range');
    }
    final windows = _windows;
    if (windows != null) return _renderWindows(windows, page);
    final result = await channel.invokeMapMethod<String, dynamic>('render', {
      'id': id,
      'page': page,
      'maxWidth': 1536,
      'maxHeight': maxPageDimension,
    });
    if (_closed) throw StateError('PDF preview closed during render');
    final bytes = result?['bytes'];
    final width = result?['width'];
    final height = result?['height'];
    if (bytes is! Uint8List ||
        bytes.isEmpty ||
        bytes.length > 16 * 1024 * 1024 ||
        width is! int ||
        height is! int ||
        width < 1 ||
        height < 1 ||
        width > maxPageDimension ||
        height > maxPageDimension ||
        width * height > maxPagePixels) {
      throw const FormatException('Invalid rendered PDF page');
    }
    return bytes;
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    final windows = _windows;
    if (windows != null) {
      await windows.close();
      return;
    }
    await channel.invokeMethod<void>('close', {'id': id});
  }

  static Future<AttachmentPdfDocument> _openWindows(Uint8List bytes) async {
    final PdfDocument document;
    try {
      document = await PdfDocument.openData(bytes);
    } catch (_) {
      throw const FormatException('Invalid PDF preview handle');
    }
    final pages = document.pagesCount;
    if (pages < 1 || pages > maxPages) {
      await document.close();
      throw const FormatException('Invalid PDF preview handle');
    }
    return AttachmentPdfDocument._('windows', pages, document);
  }

  Future<Uint8List> _renderWindows(PdfDocument document, int page) async {
    // pdfx numbers pages from 1.
    final source = await document.getPage(page + 1);
    try {
      if (_closed) throw StateError('PDF preview closed during render');
      if (!(source.width > 0) || !(source.height > 0)) {
        throw const FormatException('Invalid rendered PDF page');
      }
      // Fit inside 1536x2048, the box the native renderers are asked for.
      final widthScale = 1536 / source.width;
      final heightScale = maxPageDimension / source.height;
      final scale = widthScale < heightScale ? widthScale : heightScale;
      final targetWidth = (source.width * scale).floor().clamp(1, 1536);
      final targetHeight = (source.height * scale).floor().clamp(
        1,
        maxPageDimension,
      );
      // No background is passed: pdfx's Windows renderer fills the page white
      // and encodes without an alpha channel, so the page is opaque white
      // paper, as the native Android and Apple renderers produce.
      final image = await source.render(
        width: targetWidth.toDouble(),
        height: targetHeight.toDouble(),
        format: PdfPageImageFormat.png,
      );
      if (_closed) throw StateError('PDF preview closed during render');
      final bytes = image?.bytes;
      final width = image?.width;
      final height = image?.height;
      if (bytes == null ||
          bytes.isEmpty ||
          bytes.length > 16 * 1024 * 1024 ||
          width == null ||
          height == null ||
          width < 1 ||
          height < 1 ||
          width > maxPageDimension ||
          height > maxPageDimension ||
          width * height > maxPagePixels) {
        throw const FormatException('Invalid rendered PDF page');
      }
      return bytes;
    } finally {
      // The page handle is already gone when the document was closed
      // mid-render; that must not replace the error being reported.
      try {
        await source.close();
      } catch (_) {}
    }
  }
}
