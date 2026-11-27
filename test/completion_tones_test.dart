import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/completion_tones.dart';

import '../tool/generate_completion_sounds.dart' show bundledCompletionSounds;

/// Samples of a 16-bit mono PCM WAV written by [completionToneWav].
Int16List _samples(Uint8List wav) {
  final data = ByteData.sublistView(wav);
  expect(String.fromCharCodes(wav.sublist(0, 4)), 'RIFF');
  expect(data.getUint32(4, Endian.little), wav.length - 8);
  expect(String.fromCharCodes(wav.sublist(8, 16)), 'WAVEfmt ');
  expect(data.getUint16(20, Endian.little), 1, reason: 'PCM');
  expect(data.getUint16(22, Endian.little), 1, reason: 'mono');
  expect(data.getUint32(24, Endian.little), completionToneSampleRate);
  expect(data.getUint16(34, Endian.little), 16);
  expect(String.fromCharCodes(wav.sublist(36, 40)), 'data');
  final bytes = data.getUint32(40, Endian.little);
  expect(bytes, wav.length - 44, reason: 'no metadata chunks');
  return Int16List.fromList([
    for (var i = 0; i < bytes ~/ 2; i++)
      data.getInt16(44 + i * 2, Endian.little),
  ]);
}

void main() {
  test('the bundled WAVs are reproduced byte for byte by the generator', () {
    expect(bundledCompletionSounds, hasLength(6));
    for (final MapEntry(key: path, value: tone)
        in bundledCompletionSounds.entries) {
      expect(
        File(path).readAsBytesSync(),
        completionToneWav(tone),
        reason: '$path: run dart run tool/generate_completion_sounds.dart',
      );
    }
  });

  test('every tone starts and ends silent, fades out and stays below full '
      'scale', () {
    for (final tone in CompletionTone.values) {
      final wav = completionToneWav(tone);
      expect(completionToneWav(tone), wav, reason: 'deterministic');
      final samples = _samples(wav);
      final seconds = samples.length / completionToneSampleRate;
      expect(seconds, inInclusiveRange(0.25, 0.5), reason: tone.name);
      expect(samples.first, 0, reason: '${tone.name} starts at zero');
      expect(samples.last, 0, reason: '${tone.name} ends at zero');
      int peak(int from, int to) => samples
          .sublist(from, to)
          .fold(0, (m, s) => s.abs() > m ? s.abs() : m);
      final all = peak(0, samples.length);
      expect(all, greaterThan(8000), reason: '${tone.name} is audible');
      expect(all, lessThan(16384), reason: '${tone.name} has headroom');
      // The last 25 ms fade to nothing: no click when playback stops.
      final ms = completionToneSampleRate ~/ 1000;
      final n = samples.length;
      expect(peak(n - 2 * ms, n), lessThan(all ~/ 20), reason: tone.name);
      expect(
        peak(n - 10 * ms, n - 5 * ms),
        lessThanOrEqualTo(peak(n - 25 * ms, n - 20 * ms)),
        reason: '${tone.name} fades out',
      );
    }
  });
}
