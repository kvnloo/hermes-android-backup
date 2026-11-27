import 'dart:typed_data';

/// Ares's own completion tones, synthesised in code. No recorded or
/// third-party audio is involved.
///
/// [mail] and [reminder] are also bundled as `ares_mail.wav` and
/// `ares_reminder.wav` for notification sounds (Android `res/raw`, the iOS
/// and macOS app bundles); `tool/generate_completion_sounds.dart` writes those
/// files from [completionToneWav], and a test checks they match byte for byte.
/// [chime] is the in-app cue for the "System default" choice: an app cannot
/// play the platform's notification sound itself.
enum CompletionTone { chime, mail, reminder }

/// Sample rate of every tone: mono, 16-bit PCM.
const completionToneSampleRate = 22050;

/// One enveloped note: [frequency] Hz from [start] for [length] seconds.
class _Note {
  const _Note(this.frequency, this.start, this.length, {this.gain = 1});
  final double frequency;
  final double start;
  final double length;
  final double gain;
}

const _tones = <CompletionTone, List<_Note>>{
  // A single soft bell (C6).
  CompletionTone.chime: [_Note(1046.5, 0, 0.30)],
  // A rising two-note "ding-dong" (A5, E6).
  CompletionTone.mail: [_Note(880, 0, 0.16), _Note(1318.5, 0.12, 0.22)],
  // Three quick rising notes (G5, B5, D6).
  CompletionTone.reminder: [
    _Note(784, 0, 0.14),
    _Note(987.77, 0.11, 0.14),
    _Note(1174.66, 0.22, 0.2, gain: 0.9),
  ],
};

/// Attack before full level, avoiding a click at each note start.
const _attack = 0.006;

/// Linear fade to silence over the last stretch of the tone, so playback
/// never stops on a non-zero sample.
const _fadeOut = 0.025;

/// Peak level, well below full scale.
const _peak = 0.42;

/// The tone as a complete WAV file (RIFF, PCM, no metadata chunks).
///
/// Deterministic on every platform: only IEEE-754 addition, subtraction,
/// multiplication, division and rounding are used (the sine below is a
/// polynomial, not the platform's math library), so the same bytes come out
/// everywhere.
Uint8List completionToneWav(CompletionTone tone) {
  final notes = _tones[tone]!;
  var seconds = 0.0;
  for (final note in notes) {
    final end = note.start + note.length;
    if (end > seconds) seconds = end;
  }
  final count = (seconds * completionToneSampleRate).round();
  final samples = Int16List(count);
  for (var n = 0; n < count; n++) {
    final t = n / completionToneSampleRate;
    var value = 0.0;
    for (final note in notes) {
      final local = t - note.start;
      if (local < 0 || local >= note.length) continue;
      final attack = local < _attack ? local / _attack : 1.0;
      // Quadratic decay to zero at the end of the note.
      final remaining = 1 - local / note.length;
      final level = attack * remaining * remaining * note.gain;
      final phase = 2 * _pi * note.frequency * local;
      // The fundamental with a quiet octave for a bell-like colour.
      value += level * (_sin(phase) + 0.18 * _sin(2 * phase));
    }
    final tail = seconds - t;
    if (tail < _fadeOut) value *= tail / _fadeOut;
    final scaled = (value * _peak * 32767).round();
    samples[n] = scaled.clamp(-32768, 32767);
  }
  if (count > 0) samples[0] = 0;
  return _wav(samples);
}

const _pi = 3.141592653589793;

/// sin(x) from a range reduction to [-pi/2, pi/2] and a Taylor polynomial,
/// accurate to about 1e-9 there: far below one 16-bit step.
double _sin(double x) {
  const twoPi = 2 * _pi;
  var r = x - twoPi * (x / twoPi).roundToDouble();
  if (r > _pi / 2) r = _pi - r;
  if (r < -_pi / 2) r = -_pi - r;
  final r2 = r * r;
  // Horner form of r - r^3/3! + r^5/5! - ... - r^15/15!.
  var sum = -1 / 1307674368000;
  sum = sum * r2 + 1 / 6227020800;
  sum = sum * r2 - 1 / 39916800;
  sum = sum * r2 + 1 / 362880;
  sum = sum * r2 - 1 / 5040;
  sum = sum * r2 + 1 / 120;
  sum = sum * r2 - 1 / 6;
  sum = sum * r2 + 1;
  return sum * r;
}

Uint8List _wav(Int16List samples) {
  const channels = 1;
  const bits = 16;
  const blockAlign = channels * bits ~/ 8;
  final dataBytes = samples.length * blockAlign;
  final out = ByteData(44 + dataBytes);
  void ascii(int offset, String text) {
    for (var i = 0; i < text.length; i++) {
      out.setUint8(offset + i, text.codeUnitAt(i));
    }
  }

  ascii(0, 'RIFF');
  out.setUint32(4, 36 + dataBytes, Endian.little);
  ascii(8, 'WAVE');
  ascii(12, 'fmt ');
  out.setUint32(16, 16, Endian.little);
  out.setUint16(20, 1, Endian.little); // PCM
  out.setUint16(22, channels, Endian.little);
  out.setUint32(24, completionToneSampleRate, Endian.little);
  out.setUint32(28, completionToneSampleRate * blockAlign, Endian.little);
  out.setUint16(32, blockAlign, Endian.little);
  out.setUint16(34, bits, Endian.little);
  ascii(36, 'data');
  out.setUint32(40, dataBytes, Endian.little);
  for (var i = 0; i < samples.length; i++) {
    out.setInt16(44 + i * 2, samples[i], Endian.little);
  }
  return out.buffer.asUint8List();
}
