// Regression test for issue #354: ng_* keys in app_de.arb were copied from
// the Spanish catalog and showed Spanish strings in the NextGen German UI.
//
// Asserts the exact German copy for every affected key so the catalog cannot
// silently revert to the Spanish values.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hermes_android/core/l10n/l10n.dart';

import 'support/l10n_test_utils.dart';

Future<AppLocalizations> _de() => loadTestL10n(const Locale('de'));

void main() {
  group('German (de) NextGen l10n regression', () {
    const keysWithPlaceholders = 34;

    test('replaces the Spanish copy with the suggested German copy',
        () async {
      final l10n = await _de();

      expect(l10n.ng_no_chats_yet, 'Noch keine Chats.');
      expect(l10n.ng_nothing_is_running, 'Es läuft gerade nichts.');
      expect(l10n.ng_nothing_is_waiting_on_you, 'Nichts wartet auf dich.');
      expect(l10n.ng_settings, 'Einstellungen');
      expect(l10n.ng_all, 'Alle');
      expect(l10n.ng_needs_you(3), 'Braucht dich · 3');
      expect(l10n.ng_needs_you_2, 'Braucht dich');
      expect(l10n.ng_classic_connection('10.0.0.1:8642'),
          '10.0.0.1:8642 · klassische Verbindung');
      expect(l10n.ng_classic_connection_2, 'Klassische Verbindung');
      expect(l10n.ng_signed_in, 'Angemeldet');
      expect(l10n.ng_in_the_browser, 'Im Browser');
      expect(l10n.ng_in_the_browser_as('Sam'), 'Im Browser als Sam');
      expect(l10n.ng_not_required, 'Nicht erforderlich');
      expect(l10n.ng_test_connection, 'Verbindung testen');
      expect(l10n.ng_sign_in_again_2, 'Erneut anmelden');
      expect(l10n.ng_sign_out, 'Abmelden');
      expect(l10n.ng_in_use, 'In Verwendung');
      expect(l10n.ng_theme, 'Design');
      expect(l10n.ng_system, 'System');
      expect(l10n.ng_light, 'Hell');
      expect(l10n.ng_dark, 'Dunkel');
      expect(l10n.ng_accent, 'Akzent');
      expect(l10n.ng_pure_black, 'Reines Schwarz');
      expect(l10n.ng_dark_theme_uses_true_black_oled,
          'Das dunkle Design nutzt reines Schwarz (OLED)');
      expect(l10n.ng_glow, 'Leuchten');
      expect(l10n.ng_soft_accent_light_behind_each_screen,
          'Sanftes Akzentlicht hinter jedem Bildschirm');
      expect(l10n.ng_the_new_interface_turn_off_to,
          'Die neue Oberfläche. Zum Zurückwechseln zur klassischen ausschalten; deine Gateways und Chats werden geteilt.');
      expect(l10n.ng_more_settings, 'Weitere Einstellungen');
      expect(l10n.ng_voice_notifications_language_backups_and_the,
          'Stimme, Benachrichtigungen, Sprache, Backups und die Gateway-Konfiguration');
      expect(l10n.ng_licences, 'Lizenzen');
      expect(l10n.ng_sign_out_of('Home Assistant'),
          'Von Home Assistant abmelden?');
      expect(l10n.ng_this_gateway_and_its_saved_sign,
          'Dieses Gateway und die gespeicherte Anmeldung werden in beiden Oberflächen von diesem Telefon entfernt. Deine Chats bleiben auf dem Gateway.');
      expect(l10n.ng_password_or_browser, 'Passwort oder Browser');
      expect(l10n.ng_unsupported, 'Nicht unterstützt');

      expect(keysWithPlaceholders, 34);
    });
  });
}
