import 'dart:typed_data';

import 'package:image/image.dart' as image_lib;

/// pasteboard 0.6.2's Windows `image` method converts CF_DIB (including
/// Windows-synthesized bitmap formats) to a BMP FILE, not PNG. Convert only
/// that native transport here; picked/dropped BMPs remain outside the draft
/// service's supported-image policy. PNG/JPEG/WebP still pass to that service
/// unchanged for its normal signature validation and metadata sanitization.
Uint8List normalizeWindowsClipboardImage(Uint8List bytes) {
  if (bytes.length < 2 || bytes[0] != 0x42 || bytes[1] != 0x4d) {
    return bytes;
  }

  // Admit exactly the uncompressed 24/32-bit BITMAPINFOHEADER transport the
  // plugin emits. Check all extents BEFORE the existing decoder allocates.
  // Raw CF_DIB/CF_DIBV5 buffers lack a file header and are not BMP files.
  const budget = 64 * 1024 * 1024;
  Never invalid() => throw const FormatException('Invalid clipboard bitmap');
  if (bytes.length < 54 || bytes.length > budget) invalid();
  final data = ByteData.sublistView(bytes);
  int u32(int offset) => data.getUint32(offset, Endian.little);
  int i32(int offset) => data.getInt32(offset, Endian.little);
  final width = i32(18);
  final height = i32(22).abs();
  final depth = data.getUint16(28, Endian.little);
  final offset = u32(10);
  if (u32(14) != 40 ||
      data.getUint16(26, Endian.little) != 1 ||
      (depth != 24 && depth != 32) ||
      u32(30) != 0 ||
      u32(46) != 0 ||
      width <= 0 ||
      height <= 0 ||
      width > budget ~/ 4 ||
      height > budget ~/ (width * 4) ||
      offset != 54) {
    invalid();
  }
  final stride = ((width * depth + 31) ~/ 32) * 4;
  final size = stride * height;
  if (size > budget ||
      offset + size != bytes.length ||
      u32(2) != bytes.length ||
      (u32(34) != 0 && u32(34) != size)) {
    invalid();
  }
  final decoded = image_lib.decodeBmp(bytes);
  if (decoded == null) invalid();
  // BI_RGB's fourth byte is reserved, not alpha. image's BMP decoder ignores
  // it for this header, so ordinary GDI screenshots do not become transparent.
  final png = image_lib.encodePng(decoded);
  if (png.length > budget) invalid();
  return png;
}
