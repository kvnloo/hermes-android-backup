// New Bot profile ids as Desktop's slugifyProfileName (labels.ts at
// hermes-agent b7ee21c14e): NFC, then each letter or digit folded through
// NFKD with its marks dropped when that leaves ASCII, else a `u<hex>` token
// (review of deb6f558, PROBE B-N1). The expected ids are Desktop's own,
// produced by running its function under Node v22.22.2 (Unicode
// 17.0, ICU 78.2):
// evidence/dock-f11-fixes-t_41aee7f4/desktop_slug_extended.js.
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/services/remote_workspace.dart'
    show botProfileIdPattern, botProfileIdentity, botProfileSlug;

/// Name -> Desktop's profile id. The first ten are the review's
/// (slug_desktop.txt).
const _desktop = {
  'Research Buddy': 'research-buddy',
  'R\u{e9}sum\u{e9}  Bot!': 'resume-bot',
  '\u{5c0f}\u{52a9}\u{624b}': 'u5c0f-u52a9-u624b',
  'Sm\u{f8}rrebr\u{f8}d': 'sm-uf8-rrebr-uf8-d',
  '\u{218}tefan Bot': 'stefan-bot',
  'Nguy\u{1ec5}n Helper': 'nguyen-helper',
  '\u{ff22}\u{ff4f}\u{ff54}\u{ff12}': 'bot2',
  'Re\u{301}sume\u{301}': 'resume',
  '\u{1c4}emal': 'dzemal',
  '\u{110}or\u{111}e': 'u110-or-u111-e',
  '\u{fb01}le \u{fb02}ow': 'file-flow',
  '\u{216b} Legion': 'xii-legion',
  'H\u{2082}O x\u{b2}': 'h2o-x2',
  '\u{2460}\u{2461}\u{2462}': '123',
  '\u{bd} Bot': 'ubd--bot',
  'Kelvin \u{212a}': 'kelvin-k',
  '\u{c5}\u{212b}': 'aa',
  '\u{1d401}\u{1d428}\u{1d425}\u{1d41d} \u{1d509}\u{1d52f}\u{1d51e}\u{1d528}':
      'bold-frak',
  'o\u{338}\u{301}': 'o',
  'e\u{323}\u{301}x': 'e-x',
  'A\u{30a}\u{301}': 'a',
  '\u{f8}\u{301}': 'u1ff',
  '\u{130}stanbul \u{131}': 'istanbul--u131',
  'Stra\u{df}e': 'stra-udf-e',
  '\u{c6}r\u{f8} \u{c6}sir': 'uc6-r-uf8---uc6-sir',
  '\u{395}\u{3bb}\u{3bb}\u{3b7}\u{3bd}\u{3b9}\u{3ba}\u{3ac}':
      'u395-u3bb-u3bb-u3b7-u3bd-u3b9-u3ba-u3ac',
  '\u{41f}\u{440}\u{438}\u{432}\u{435}\u{442} \u{411}\u{43e}\u{442}':
      'u41f-u440-u438-u432-u435-u442---u411-u43e-u442',
  '\u{d55c}\u{ae00} \u{bd07}': 'ud55c-uae00---ubd07',
  '\u{645}\u{631}\u{62d}\u{628}\u{627} \u{663}':
      'u645-u631-u62d-u628-u627---u663',
  '\u{ff8a}\u{ff9d}\u{ff76}\u{ff78} \u{ff76}\u{ff85}':
      'uff8a-uff9d-uff76-uff78---uff76-uff85',
  'Bot \u{1f916} Two': 'bot-two',
  '___bot___': '___bot___',
  '--a--b--': 'a-b',
  '  spaced   out  ': 'spaced-out',
  'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa':
      'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
  'word word word word word word word word word word word word word word word word word word word word ':
      'word-word-word-word-word-word-word-word-word-word-word-word-word',
  '\u{5c0f}\u{5c0f}\u{5c0f}\u{5c0f}\u{5c0f}\u{5c0f}\u{5c0f}\u{5c0f}\u{5c0f}\u{5c0f}\u{5c0f}\u{5c0f}':
      'u5c0f-u5c0f-u5c0f-u5c0f-u5c0f-u5c0f-u5c0f-u5c0f-u5c0f-u5c0f',
  'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx \u{5c0f}\u{52a9}':
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx--u5c0f',
  'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-y':
      'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
  '': '',
  '!!!': '',
};

void main() {
  test('B-N1: the review\'s ten names give Desktop\'s profile ids', () {
    final differ = <String>[];
    for (final MapEntry(:key, :value) in _desktop.entries.take(10)) {
      final ares = botProfileSlug(key);
      if (ares != value) differ.add('"$key": desktop=$value ares=$ares');
    }
    expect(differ, isEmpty, reason: differ.join('\n'));
  });

  test('compatibility forms, composition, other scripts and the 64-character '
      'cut give Desktop\'s profile ids', () {
    final differ = <String>[];
    for (final MapEntry(:key, :value) in _desktop.entries.skip(10)) {
      final ares = botProfileSlug(key);
      if (ares != value) differ.add('"$key": desktop=$value ares=$ares');
    }
    expect(differ, isEmpty, reason: differ.join('\n'));
  });

  test('every non-empty id fits the profile id grammar', () {
    for (final id in _desktop.values.where((id) => id.isNotEmpty)) {
      expect(id.length, lessThanOrEqualTo(64), reason: id);
      if (RegExp('^[a-z0-9]').hasMatch(id)) {
        expect(botProfileIdPattern.hasMatch(id), isTrue, reason: id);
      }
    }
  });

  test('botProfileIdentity trims the name and keeps a non-ASCII one as the '
      'title', () {
    expect(botProfileIdentity('  Nguy\u{1ec5}n Helper ', ''), (
      slug: 'nguyen-helper',
      title: 'Nguy\u{1ec5}n Helper',
    ));
    expect(botProfileIdentity('Research Buddy', ''), (
      slug: 'research-buddy',
      title: '',
    ));
    expect(botProfileIdentity('\u{ff22}ot', 'Mine'), (
      slug: 'bot',
      title: 'Mine',
    ));
  });
}
