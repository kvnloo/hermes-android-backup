// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get attachment_audio_failed =>
      'Dieses Audio konnte nicht abgespielt werden. Format oder Codec werden möglicherweise nicht unterstützt oder die Vorschau ist zu groß. Erneut versuchen oder die Originaldatei speichern oder teilen.';

  @override
  String get attachment_audio_seek => 'Audioposition';

  @override
  String get workspace_workers => 'Aktive Unteragenten';

  @override
  String get workers_unattached =>
      'Nur Anzahl. Wähle zum Steuern im verbundenen übergeordneten Chat „Aktive Unteragenten“.';

  @override
  String get slash_local_arguments =>
      'Diese Verknüpfung unterstützt hier keine Argumente. Verwende die App-Steuerelemente; dein Entwurf wurde beibehalten.';

  @override
  String get fallback_title => 'Ausweichmodelle';

  @override
  String get fallback_notice =>
      'Werden der Reihe nach versucht, wenn das Hauptmodell nicht verfügbar ist. Änderungen gelten nur für dieses Profil; speichere die vollständige Liste ausdrücklich.';

  @override
  String get fallback_unavailable =>
      'Die Ausweichkonfiguration ist nicht verfügbar oder ungültig. Prüfe Verbindung, ausgewähltes Profil und Host-Version und versuche es erneut.';

  @override
  String get fallback_discovery_unavailable =>
      'Anbieter können nicht geladen werden. Vorhandene Einträge bleiben erhalten; versuche es erneut, um Anbieter und Modelle auszuwählen.';

  @override
  String get fallback_empty => 'Keine Einträge in dieser Ausweichliste.';

  @override
  String get fallback_incomplete =>
      'Wähle für jeden Eintrag Anbieter und Modell oder entferne unvollständige Einträge vor dem Speichern.';

  @override
  String get fallback_add => 'Ausweichmodell hinzufügen';

  @override
  String get fallback_save => 'Ausweichliste speichern';

  @override
  String get fallback_save_failed =>
      'Die gespeicherte Ausweichliste konnte nicht bestätigt werden. Dein Entwurf bleibt erhalten. Speichere erneut oder lade die Host-Einstellungen neu.';

  @override
  String get fallback_saved => 'Ausweichliste gespeichert und bestätigt.';

  @override
  String get fallback_legacy_title => 'Alte Ausweichmodelle (schreibgeschützt)';

  @override
  String get fallback_legacy_notice =>
      'Der Host verwendet nach dieser Liste auch fallback_model und überspringt doppelte Routen. Diese alten Einträge bleiben auch bei leerer obiger Liste erhalten. Bearbeite sie auf dem Host.';

  @override
  String fallback_priority(String position) {
    return 'Priorität $position';
  }

  @override
  String get fallback_move_up => 'Nach oben';

  @override
  String get fallback_move_down => 'Nach unten';

  @override
  String get fallback_routing_read_only =>
      'Routingdetails oder ein nicht aufgeführter Anbieter bleiben erhalten. Bearbeite Anbieter/Modell auf dem Host; Umordnen oder Entfernen ist hier weiterhin möglich.';

  @override
  String get cron_model_default => 'Standard folgen';

  @override
  String get cron_model_notice =>
      'Gilt nur für diesen Cronjob. Ohne Fixierung nutzt Hermes den Cron-Standard, dann das Hauptmodell. Eigene Modelle auf dem Host verwalten.';

  @override
  String get model_management_unavailable =>
      'Modelleinstellungen konnten nicht geladen oder gespeichert werden. Aktualisieren Sie und versuchen Sie es erneut.';

  @override
  String get model_management_subtitle =>
      'Haupt-, Ausweich- und Hilfsmodelle für dieses Profil';

  @override
  String get usage => 'Nutzung';

  @override
  String get nous_portal => 'Nous Portal';

  @override
  String get portal_menu_subtitle => 'Gateway-Status und erfasste Nutzung';

  @override
  String get portal_read_only =>
      'Schreibgeschützte Gateway-Daten. Verwalte die Nous-Anmeldung auf dem Hermes-Host. Diese Endpunkte liefern weder Abonnementguthaben noch Credits.';

  @override
  String get portal_status => 'Portal-Status des Gateways';

  @override
  String get portal_free_tier => 'Kostenloser Zugang (kein angemeldetes Konto)';

  @override
  String get portal_signed_in => 'Angemeldet';

  @override
  String get portal_signed_out => 'Nicht angemeldet';

  @override
  String get portal_account_tier => 'Kontostufe';

  @override
  String get portal_recorded_usage => 'Erfasste Nutzung';

  @override
  String get portal_all_providers =>
      'Alle Anbieter im ausgewählten Gateway-Profil. Erfasste Kosten von null bedeuten nicht, dass ein Modell kostenlos ist.';

  @override
  String portal_period(String days) {
    return 'Letzte $days Tage';
  }

  @override
  String get portal_sessions => 'Sitzungen';

  @override
  String get portal_input => 'Eingabe-Token';

  @override
  String get portal_output => 'Ausgabe-Token';

  @override
  String get portal_estimated => 'Geschätzte erfasste Kosten';

  @override
  String get portal_actual => 'Tatsächlich erfasste Kosten';

  @override
  String get portal_recorded_models => 'Erfasste Modelle';

  @override
  String get portal_no_models => 'Keine erfassten Modelle.';

  @override
  String get portal_unavailable =>
      'Nicht verfügbar. Prüfe Verbindung, ausgewähltes Profil und Gateway-Version und versuche es erneut.';

  @override
  String get paste_attachment_failed_text_kept =>
      'Der eingefügte Text konnte nicht angehängt werden. Er bleibt in der Nachricht erhalten.';

  @override
  String get background_task_report => 'Hintergrundaufgabe';

  @override
  String get background_process_report => 'Hintergrundprozess';

  @override
  String get background_report_issues =>
      'Probleme gemeldet — für Details aufklappen.';

  @override
  String get background_report_expand => 'Bericht aufklappen';

  @override
  String get background_report_collapse => 'Bericht zuklappen';

  @override
  String get ng_brand_open_chat => 'Chat öffnen';

  @override
  String get ng_brand_recent => 'Zuletzt';

  @override
  String get ng_brand_sidebar_hint =>
      'oder einen Chat aus der Seitenleiste wählen';

  @override
  String get copy_session_id => 'Sitzungs-ID kopieren';

  @override
  String get copy_session_id_failed =>
      'Die Sitzungs-ID konnte nicht kopiert werden.';

  @override
  String get setup_interface_title => 'Oberfläche wählen';

  @override
  String get setup_interface_classic => 'Classic';

  @override
  String get setup_interface_nextgen => 'NextGen';

  @override
  String get setup_interface_classic_description =>
      'Der ursprüngliche Ares-Arbeitsbereich mit allen Verbindungsoptionen und Classic-Einstellungen.';

  @override
  String get setup_interface_nextgen_description =>
      'Ein neues Design mit einer Dashboard-Anmeldung, Live-Plänen, Subagenten und Benachrichtigungen.';

  @override
  String get setup_interface_switch_later =>
      'Du kannst jederzeit in den Einstellungen wechseln.';

  @override
  String get ng_confirm_model_switch => 'Modell wechseln?';

  @override
  String get ng_switch => 'Wechseln';

  @override
  String get ng_model_confirmation_required =>
      'Dieses Modell muss vor der Auswahl bestätigt werden.';

  @override
  String ng_model_switches_next_turn(String model) {
    return 'Wechselt im nächsten Durchgang zu $model.';
  }

  @override
  String get ng_model_switch_not_connected =>
      'Der Chat ist noch nicht für einen Modellwechsel bereit. Öffne ihn erneut und versuche es noch einmal.';

  @override
  String ng_gateway_kept_default_model(String model) {
    return 'Das Gateway hat $model für diesen Chat beibehalten. Wähle das Modell vor dem Senden erneut.';
  }

  @override
  String get hands_free_title => 'Freisprechen';

  @override
  String get hands_free_start => 'Freisprechen starten';

  @override
  String get hands_free_stop => 'Freisprechen stoppen';

  @override
  String get hands_free_preparing => 'Sprachfunktion wird vorbereitet';

  @override
  String get hands_free_listening => 'Sage Hey Hermes';

  @override
  String get hands_free_recording => 'Bereit — jetzt sprechen';

  @override
  String get hands_free_waiting => 'Warten auf Hermes';

  @override
  String get hands_free_speaking => 'Wiedergabe — Mikrofon aus';

  @override
  String hands_free_followup(int seconds) {
    return 'Bis zu $seconds Sekunden zuhören';
  }

  @override
  String get hands_free_error => 'Freisprechen gestoppt';

  @override
  String get hands_free_setup => 'Freisprechen einrichten';

  @override
  String hands_free_preview(String transcript) {
    return 'Sprachvorschau: $transcript';
  }

  @override
  String get hands_free_short_disclosure =>
      'Nur solange dieser Chat im Vordergrund geöffnet ist. Aktivierung offline; Sprache ggf. online. Verbraucht Akku.';

  @override
  String get hands_free_error_action =>
      'Mikrofonberechtigung, Sprachdienst, Stimme und Verbindung prüfen. Dann Stoppen und Starten wählen. Nichts wird erneut gesendet.';

  @override
  String get hands_free_disclosure =>
      'Die Aktivierung läuft offline auf der CPU. Android-Spracherkennung, Antwortstimme und Gateway können Netzwerke nutzen. Zuhören verbraucht Akku; Fehlaktivierungen sind möglich. Bei verdecktem, geschlossenem oder nicht mehr sichtbarem Chat wird gestoppt. Kein automatischer Neustart. Manuelles Diktieren bleibt ein bearbeitbarer Entwurf.';

  @override
  String get hands_free_ready_cue =>
      '„Hey Hermes“ sagen, auf „Bereit“ warten, dann sprechen. Keine Erfassung im selben Atemzug oder Audiopuffer. Nach einem Berechtigungsdialog gegebenenfalls erneut Starten wählen.';

  @override
  String get hands_free_settings_title => 'Freisprechen-Sprachsteuerung';

  @override
  String get hands_free_settings_subtitle =>
      'Zeigt die Startschaltfläche „Hey Hermes“ in Chats. Ausschalten beendet eine laufende Freisprechen-Sitzung.';

  @override
  String get hands_free_timing_limit =>
      'Das Folgefenster ist eine Höchstdauer, keine Mindestdauer. Android kann früher stoppen. Bei Stille zurück zur lokalen Aktivierung, ohne wiederholte Spracherkennungsstarts.';

  @override
  String get hands_free_followup_off =>
      'Folgefenster aus — für jede Eingabe Hey Hermes sagen';

  @override
  String get hands_free_start_blocked =>
      'Leerer Entwurf, keine Anhänge, inaktiver verbundener Chat und Sprachantworten erforderlich. Manuelle Sprachaktionen zuerst beenden.';

  @override
  String get hands_free_setup_complete =>
      'Mikrofoneinrichtung beendet. Erneut Starten wählen.';

  @override
  String message_time_recorded(String time) {
    return 'Vom Server aufgezeichnet: $time (Ortszeit)';
  }

  @override
  String message_time_sent(String time) {
    return 'Senden auf diesem Gerät erfasst: $time (Ortszeit)';
  }

  @override
  String message_time_received(String time) {
    return 'Auf diesem Gerät erstmals empfangen: $time (Ortszeit)';
  }

  @override
  String get stop_and_send => 'Stoppen und senden';

  @override
  String get message_queued_for_running_turn =>
      'Nachricht für den aktuellen Lauf eingereiht.';

  @override
  String get running_message_not_accepted =>
      'Hermes konnte diese Nachricht nicht annehmen. Dein Entwurf bleibt erhalten. Stoppe die Antwort oder warte und sende dann erneut.';

  @override
  String get running_message_delivery_unknown =>
      'Die Zustellung konnte nicht bestätigt werden. Dein Entwurf bleibt erhalten. Prüfe den Chat, bevor du es erneut versuchst.';

  @override
  String get attachment_tap_to_preview => 'Zum Anzeigen tippen';

  @override
  String get attachment_save => 'Speichern';

  @override
  String get attachment_share => 'Teilen';

  @override
  String get attachment_saved => 'Datei gespeichert';

  @override
  String get attachment_save_cancelled => 'Speichern abgebrochen';

  @override
  String get attachment_save_failed =>
      'Diese Datei konnte nicht gespeichert werden. Bitte erneut versuchen.';

  @override
  String get attachment_share_failed =>
      'Diese Datei konnte nicht geteilt werden. Bitte erneut versuchen.';

  @override
  String get attachment_download_failed =>
      'Diese Datei konnte nicht geladen werden. Verbindung prüfen und erneut versuchen.';

  @override
  String get attachment_no_inline_preview =>
      'Für diesen Dateityp ist keine Vorschau verfügbar. Die Originaldatei speichern oder teilen, um sie in einer anderen App zu öffnen.';

  @override
  String get attachment_image_failed =>
      'Dieses Bild konnte nicht dekodiert werden. Die Originaldatei kann weiterhin gespeichert oder geteilt werden.';

  @override
  String get attachment_text_truncated =>
      'Vorschau gekürzt. Die Datei speichern oder teilen, um sie vollständig zu lesen.';

  @override
  String get attachment_text_unavailable =>
      'Diese Datei konnte nicht als Text angezeigt werden. Die Originaldatei speichern oder teilen.';

  @override
  String get attachment_pdf_failed =>
      'Für diese PDF-Datei konnte keine Vorschau erstellt werden. Die Originaldatei speichern oder teilen.';

  @override
  String get attachment_pdf_unavailable =>
      'PDF-Vorschauen sind unter Android verfügbar. Diese Datei kann weiterhin gespeichert oder geteilt werden.';

  @override
  String attachment_pdf_page(int page, int total) {
    return 'Seite $page von $total';
  }

  @override
  String get attachment_previous_page => 'Vorherige Seite';

  @override
  String get attachment_next_page => 'Nächste Seite';

  @override
  String get attachment_loading => 'Vorschau wird geladen…';

  @override
  String get attachment_document_text_notice =>
      'Textvorschau. Layout, Bilder und Formatierung können vom Original abweichen.';

  @override
  String get attachment_document_failed =>
      'Für dieses Dokument konnte keine Vorschau erstellt werden. Die Originaldatei speichern oder teilen.';

  @override
  String get attachment_document_empty =>
      'In diesem Dokument wurde kein lesbarer Text gefunden.';

  @override
  String get attachment_video_failed =>
      'Dieses Video konnte nicht abgespielt werden. Das Format oder der Codec wird möglicherweise nicht unterstützt. Die Originaldatei speichern oder teilen.';

  @override
  String get attachment_video_play => 'Abspielen';

  @override
  String get attachment_video_pause => 'Pause';

  @override
  String get attachment_video_mute => 'Stummschalten';

  @override
  String get attachment_video_unmute => 'Ton einschalten';

  @override
  String get attachment_video_seek => 'Videoposition';

  @override
  String get attachment_close => 'Vorschau schließen';

  @override
  String get attachment_retry => 'Erneut versuchen';

  @override
  String get saved_history_heading => 'Gespeicherter Verlauf';

  @override
  String get received_output_heading =>
      'Empfangene Ausgabe — Übereinstimmung mit gespeichertem Verlauf unbestätigt';

  @override
  String get received_output_details => 'Über die empfangene Ausgabe';

  @override
  String get received_output_explanation =>
      'Dies kann auch im gespeicherten Verlauf erscheinen. Die App kann keine Übereinstimmung bestätigen.';

  @override
  String get local_prompt_context => 'Lokaler Prompt-Kontext';

  @override
  String get received_output_badge => 'Empfangen · Übereinstimmung unbestätigt';

  @override
  String get received_output_lifetime =>
      'Empfangene Ausgaben werden in dieser App-Sitzung vorübergehend aufbewahrt und bei Erreichen der Grenzen möglicherweise gekürzt oder entfernt. Nach dem Schließen der App oder Verbindung sind sie eventuell nicht mehr verfügbar.';

  @override
  String get theme_palette => 'Farbthema';

  @override
  String get theme_palette_gold => 'Gold';

  @override
  String get theme_palette_purple => 'Violett';

  @override
  String get theme_palette_orange => 'Orange';

  @override
  String get theme_palette_green => 'Grün';

  @override
  String get theme_palette_blue => 'Blau';

  @override
  String get theme_palette_red => 'Rot';

  @override
  String get theme_palette_teal => 'Petrol';

  @override
  String get theme_palette_pink => 'Rosa';

  @override
  String get theme_palette_indigo => 'Indigo';

  @override
  String get theme_palette_cyan => 'Cyan';

  @override
  String get assets_recent_subtitle =>
      'Finde Dateien, die Hermes in gespeicherten Chats geteilt hat';

  @override
  String get assets_scope_notice =>
      'Generierte Dateien, die Hermes in gespeicherten Antworten ausdrücklich geteilt hat. Dies ist nur ein Ausschnitt des Chatverlaufs, kein vollständiger Datei- oder Anhangskatalog. Die referenzierten Dateien sind möglicherweise nicht mehr vorhanden.';

  @override
  String get assets_download_limit =>
      'Dateien werden erst beim Antippen geladen. Vorschauen und Downloads sind auf jeweils 25 MiB pro Datei begrenzt; nutze für größere Dateien das Dashboard.';

  @override
  String get assets_search_hint =>
      'Gefundene Dateien oder zugehörige Chats durchsuchen';

  @override
  String get assets_all => 'Alle';

  @override
  String get assets_images => 'Bilder';

  @override
  String get assets_audio => 'Audio';

  @override
  String get assets_video => 'Video';

  @override
  String get assets_documents => 'Dokumente und andere Dateien';

  @override
  String get assets_empty =>
      'Keine Assets in den durchsuchten Nachrichten gefunden';

  @override
  String get assets_empty_detail =>
      'Durchsuche weitere Chats oder ältere Nachrichten, um weiter zurückzublicken. Normale Anhänge und nicht verlinkte Dateien werden hier nicht indexiert.';

  @override
  String get assets_no_matches => 'Keine passenden Assets';

  @override
  String get assets_load_more_chats => 'Weitere Chats durchsuchen';

  @override
  String get assets_load_older_messages => 'Ältere Nachrichten durchsuchen';

  @override
  String get assets_load_failed =>
      'Ein Teil des Verlaufs konnte nicht gelesen werden. Die Ergebnisse sind unvollständig. Prüfe die Dashboard-Verbindung und versuche es erneut.';

  @override
  String get assets_retry_failed =>
      'Fehlgeschlagene Verlaufsabfragen wiederholen';

  @override
  String get assets_partial =>
      'Der Server hat einen unvollständigen Verlauf gemeldet. Prüfe das Dashboard und aktualisiere anschließend.';

  @override
  String assets_scan_summary(int files, int chats) {
    return 'Gefundene Dateiverweise: $files · Durchsuchte Chats: $chats';
  }

  @override
  String assets_open_chat(String title) {
    return 'Chat öffnen: $title';
  }

  @override
  String get assets_file_too_large =>
      'Diese Datei überschreitet das Downloadlimit. Öffne das Dashboard, um sie herunterzuladen.';

  @override
  String get a_one_off_question_archives_itself_after_72_hours_anything =>
      'Eine einmalige Frage. Wird nach 72 Stunden automatisch archiviert; alles, was es wert ist, bleibt im Gedächtnis.';

  @override
  String get archive_chat => 'Chat archivieren';

  @override
  String get unarchive_chat => 'Chat aus Archiv holen';

  @override
  String get chat_archived => 'Chat archiviert';

  @override
  String get chat_unarchived => 'Chat aus Archiv geholt';

  @override
  String could_not_update_chat_archive(Object error) {
    return 'Archivstatus des Chats konnte nicht geändert werden: $error';
  }

  @override
  String get quick_chat_description => 'Eine einmalige Frage.';

  @override
  String get ai_full_text => 'KI + Volltext';

  @override
  String get ai_search_model => 'KI-Suchmodell';

  @override
  String ai_searched_for(Object aiRewrittenQuery) {
    return 'KI hat gesucht: $aiRewrittenQuery';
  }

  @override
  String get ai_assisted_filing => 'KI-gestützte Ablage';

  @override
  String get api_key => 'API-Schlüssel';

  @override
  String get api_server_key_from_hermes_env =>
      'API_SERVER_KEY aus ~/.hermes/.env';

  @override
  String get active => 'Aktiv';

  @override
  String get activity => 'Aktivität';

  @override
  String get activity_reads_the_durable_turn_journal_to_know_what_hermes =>
      'Die Aktivität liest das dauerhafte Turn-Journal, um zu wissen, was Hermes gerade tut. Prüfe, ob das Gateway erreichbar ist, und versuche es dann erneut.';

  @override
  String get add => 'Hinzufügen';

  @override
  String get add_connection => 'Verbindung hinzufügen';

  @override
  String get add_cron_job => 'Cron-Job hinzufügen';

  @override
  String get add_gateway_connection => 'Gateway-Verbindung hinzufügen';

  @override
  String get add_and_update_connections_from_the_backup_keep_the_rest =>
      'Verbindungen aus dem Backup hinzufügen und aktualisieren, den Rest beibehalten.';

  @override
  String get add_attachment => 'Anhang hinzufügen';

  @override
  String get add_new_cron_job => 'Neuen Cron-Job hinzufügen';

  @override
  String get add_to_chat => 'Zum Chat hinzufügen';

  @override
  String get all_chats => 'Alle Chats';

  @override
  String get all_stored_message_content =>
      'Gesamter gespeicherter Nachrichteninhalt';

  @override
  String get allow_for_this_session => 'Für diese Sitzung erlauben';

  @override
  String get allow_matching_commands_until_this_hermes_session_ends =>
      'Passende Befehle bis zum Ende dieser Hermes-Sitzung erlauben.';

  @override
  String get allow_folder_until_sandbox_off =>
      'Diesen Ordner erlauben, bis die Sandbox ausgeschaltet wird.';

  @override
  String get allow_once => 'Einmal erlauben';

  @override
  String get allow_website_until_sandbox_off =>
      'Diese Website erlauben, bis die Sandbox ausgeschaltet wird.';

  @override
  String get always_allow => 'Immer erlauben';

  @override
  String get apply_to_this_chat => 'Auf diesen Chat anwenden';

  @override
  String get approval_needed => 'Genehmigung erforderlich';

  @override
  String get approval_needed_description =>
      'Ein Befehl wartet auf deine Zustimmung oder Ablehnung.';

  @override
  String get approve => 'Genehmigen';

  @override
  String get archive => 'Archivieren';

  @override
  String get archive_project => 'Projekt archivieren';

  @override
  String archive_2(Object projectName) {
    return '$projectName archivieren?';
  }

  @override
  String archive_3(Object name) {
    return '$name archivieren?';
  }

  @override
  String get archived => 'Archiviert';

  @override
  String get archived_conversations_appear_here =>
      'Hier erscheinen nur archivierte Unterhaltungen. Ältere Chats bleiben unter „Alle Chats“.';

  @override
  String get archived_quick_chats => 'Archivierte Schnellchats';

  @override
  String get artifacts_attachments_and_generated_media =>
      'Artefakte, Anhänge und generierte Medien';

  @override
  String get ask_ai_to_find_a_conversation =>
      'KI bitten, eine Unterhaltung zu finden';

  @override
  String get assets => 'Assets';

  @override
  String get assets_need_a_server_authoritative_assets_index_in_the_hermes =>
      'Assets benötigen einen serverautoritativen Index im Hermes-Gateway, bevor sie pro Projekt angezeigt werden können.';

  @override
  String get assets_unavailable => 'Assets nicht verfügbar';

  @override
  String get attach_image_or_file => 'Bild oder Datei anhängen';

  @override
  String get attachment_drafts => 'Anhangsentwürfe';

  @override
  String get recover_text_draft => 'Textentwurf wiederherstellen';

  @override
  String get undo_draft_recovery => 'Rückgängig';

  @override
  String get draft_session_exists =>
      'Dieser Chat existiert noch. Öffne ihn, um den Entwurf fortzusetzen.';

  @override
  String get draft_recovery_unavailable =>
      'Der Entwurf konnte nicht überprüft werden. Es wurde nichts geändert.';

  @override
  String attachment_of(Object index, Object total) {
    return 'Anhang $index von $total';
  }

  @override
  String get auto_device_default => 'Automatisch (Gerätestandard)';

  @override
  String get agent => 'Agent';

  @override
  String get autonomous_agents => 'Autonome Agenten';

  @override
  String get background_recovery_unavailable_legacy_transport =>
      'Hintergrund-Wiederherstellung nicht verfügbar — Legacy-Transport';

  @override
  String get background_task_completed => 'Hintergrundaufgabe abgeschlossen';

  @override
  String get background_task_completed_description =>
      'Ein Terminal-Befehl im Hintergrund ist abgeschlossen.';

  @override
  String get backup_restore => 'Backup und Wiederherstellung';

  @override
  String backup_exported(Object destination) {
    return 'Backup exportiert — $destination';
  }

  @override
  String get base_url => 'Basis-URL';

  @override
  String get binary_preview_is_unavailable_download_the_file_to_open_it =>
      'Binärvorschau ist nicht verfügbar. Lade die Datei herunter, um sie zu öffnen.';

  @override
  String get branch => 'Branch';

  @override
  String get branch_chat => 'Chat verzweigen';

  @override
  String get branch_created_in_hermes_history =>
      'Branch im Hermes-Verlauf erstellt.';

  @override
  String get browse_and_manage_your_hermes_agent_sessions_from_your_phone =>
      'Durchsuche und verwalte deine Hermes-Agent-Sitzungen vom Telefon aus. Verbindet sich mit einem Hermes-Dashboard in deinem lokalen Netzwerk.';

  @override
  String get browse_server_files => 'Serverdateien durchsuchen';

  @override
  String get browse_the_miniserver_folders_behind_your_projects =>
      'Durchsuche die miniserver-Ordner hinter deinen Projekten';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get cancel_voice_input => 'Spracheingabe abbrechen';

  @override
  String cannot_reach(Object host, Object port) {
    return '$host:$port ist nicht erreichbar.';
  }

  @override
  String cannot_reach_check_the_host_and_port(Object host, Object port) {
    return '$host:$port ist nicht erreichbar. Prüfe Host und Port.';
  }

  @override
  String get change_ai_search_model => 'KI-Suchmodell ändern';

  @override
  String changes_the_default_for_use_the_selector_in_a_chat(Object label) {
    return 'Ändert den Standard für $label. Nutze die Auswahl in einem Chat, um nur diese Unterhaltung zu überschreiben.';
  }

  @override
  String get chat_actions => 'Chat-Aktionen';

  @override
  String get chats => 'Chats';

  @override
  String get chats_from_this_gateway_are_not_grouped_yet_grouping_stays =>
      'Chats von diesem Gateway werden noch nicht gruppiert. Die Gruppierung bleibt auf diesem Telefon, bis das Gateway Projekte hosten kann.';

  @override
  String get chats_in_this_project_will_show_their_state_and_last =>
      'Chats in diesem Projekt zeigen hier ihren Status und ihre letzte Aktivität.';

  @override
  String get chats_that_are_not_assigned_to_a_project =>
      'Chats, die keinem Projekt zugewiesen sind';

  @override
  String get chats_you_start_in_this_project_will_appear_here_on =>
      'Chats, die du in diesem Projekt startest, erscheinen hier — auf jedem Gerät, das bei diesem Hermes angemeldet ist.';

  @override
  String get check_that_the_gateway_is_running_and_reachable_then_try =>
      'Prüfe, ob das Gateway läuft und erreichbar ist, und versuche es dann erneut.';

  @override
  String get check_the_dashboard_connection_and_try_again =>
      'Prüfe die Dashboard-Verbindung und versuche es erneut.';

  @override
  String get check_the_connection_and_try_again =>
      'Prüfe die Verbindung und versuche es erneut.';

  @override
  String get choose_a_small_model_to_rewrite_queries =>
      'Wähle ein kleines Modell zum Umschreiben von Anfragen';

  @override
  String get choose_an_ai_search_model_before_using_ai_search =>
      'Wähle ein KI-Suchmodell, bevor du die KI-Suche verwendest.';

  @override
  String get choose_an_active_project_next =>
      'Wähle als Nächstes ein aktives Projekt';

  @override
  String get choose_chat_model => 'Chat-Modell wählen';

  @override
  String get choose_files => 'Dateien wählen';

  @override
  String get choose_image => 'Bild wählen';

  @override
  String get choose_images => 'Bilder wählen';

  @override
  String get choose_its_destination_space => 'Wähle den Zielbereich';

  @override
  String get clear_search => 'Suche löschen';

  @override
  String get close => 'Schließen';

  @override
  String get code_copied => 'Code kopiert';

  @override
  String get code_format => 'Code';

  @override
  String get coming_next => 'Demnächst';

  @override
  String get command => 'Befehl';

  @override
  String get command_palette => 'Befehlspalette';

  @override
  String get command_palette_hint => 'Befehl eingeben';

  @override
  String get command_palette_no_results => 'Keine Befehle gefunden';

  @override
  String get command_palette_new_chat => 'Neuer Chat';

  @override
  String get command_palette_search_chats => 'Chats durchsuchen';

  @override
  String get command_palette_toggle_theme => 'Design wechseln';

  @override
  String get command_palette_copy_last_code => 'Letzten Codeblock kopieren';

  @override
  String get command_line_chats => 'Kommandozeilen-Chats';

  @override
  String get compatibility_mode => 'Kompatibilitätsmodus';

  @override
  String get configure_a_valid_desktop_gateway_url_before_attaching_files =>
      'Konfiguriere eine gültige Desktop-Gateway-URL, bevor du Dateien anhängst.';

  @override
  String get confirm_always_allow => '„Immer erlauben“ bestätigen';

  @override
  String get confirm_passphrase => 'Passphrase bestätigen';

  @override
  String connecting_to(Object baseUrl) {
    return 'Verbindung zu $baseUrl wird hergestellt...';
  }

  @override
  String get connection_issue => 'Verbindungsproblem';

  @override
  String
  get connection_switched_the_running_reply_continues_on_the_server_and =>
      'Verbindung gewechselt — die laufende Antwort wird auf dem Server fortgesetzt und automatisch wieder angehängt.';

  @override
  String get connection_appearance_and_device_preferences =>
      'Verbindung, Darstellung und Geräteeinstellungen';

  @override
  String context_tokens(Object effectiveContextLength) {
    return 'Kontext: $effectiveContextLength Token';
  }

  @override
  String get continue_label => 'Weiter';

  @override
  String get continue_working => 'Weiterarbeiten';

  @override
  String get conversations_in_this_project =>
      'Unterhaltungen in diesem Projekt';

  @override
  String get copy_code => 'Code kopieren';

  @override
  String get copy_message => 'Nachricht kopieren';

  @override
  String could_not_branch_chat(Object error) {
    return 'Chat konnte nicht verzweigt werden: $error';
  }

  @override
  String could_not_delete_session(Object error) {
    return 'Sitzung konnte nicht gelöscht werden: $error';
  }

  @override
  String could_not_deny_the_command(Object error) {
    return 'Befehl konnte nicht abgelehnt werden: $error';
  }

  @override
  String could_not_load_ai_search_models(Object error) {
    return 'KI-Suchmodelle konnten nicht geladen werden: $error';
  }

  @override
  String get could_not_load_conversations =>
      'Unterhaltungen konnten nicht geladen werden';

  @override
  String get could_not_load_files => 'Dateien konnten nicht geladen werden';

  @override
  String could_not_load_models_for_this_profile(Object error) {
    return 'Modelle für dieses Profil konnten nicht geladen werden: $error';
  }

  @override
  String could_not_load_more_chats(Object error) {
    return 'Weitere Chats konnten nicht geladen werden: $error';
  }

  @override
  String get could_not_open_link => 'Dieser Link konnte nicht geöffnet werden.';

  @override
  String get could_not_open_the_hermes_dashboard =>
      'Das Hermes-Dashboard konnte nicht geöffnet werden.';

  @override
  String get could_not_open_this_project =>
      'Dieses Projekt konnte nicht geöffnet werden';

  @override
  String get could_not_preview_file =>
      'Datei konnte nicht in der Vorschau angezeigt werden';

  @override
  String get could_not_reach_hermes => 'Hermes ist nicht erreichbar';

  @override
  String could_not_reach_authenticate_the_dashboard_at_check_the_port(
    Object dashboardPort,
    Object host,
  ) {
    return 'Dashboard unter $host:$dashboardPort nicht erreichbar oder nicht authentifiziert. Prüfe Port und Zugangsdaten.';
  }

  @override
  String get could_not_read_activity => 'Aktivität konnte nicht gelesen werden';

  @override
  String could_not_rename_chat(Object error) {
    return 'Chat konnte nicht umbenannt werden: $error';
  }

  @override
  String could_not_send_the_approval(Object error) {
    return 'Genehmigung konnte nicht gesendet werden: $error';
  }

  @override
  String get could_not_skip_the_hermes_question =>
      'Die Frage von Hermes konnte nicht übersprungen werden.';

  @override
  String could_not_the_project(Object action, Object error) {
    return 'Projekt konnte nicht $action werden: $error';
  }

  @override
  String get couldn_t_delete_project => 'Projekt konnte nicht gelöscht werden';

  @override
  String couldn_t_load_runs(Object error) {
    return 'Ausführungen konnten nicht geladen werden: $error';
  }

  @override
  String get couldn_t_move_conversation =>
      'Unterhaltung konnte nicht verschoben werden';

  @override
  String couldn_t_move_to(Object label, Object reason) {
    return 'Verschieben nach $label fehlgeschlagen: $reason';
  }

  @override
  String get couldn_t_prepare_the_shared_files =>
      'Die geteilten Dateien konnten nicht vorbereitet werden.';

  @override
  String get couldn_t_promote_conversation =>
      'Unterhaltung konnte nicht hochgestuft werden';

  @override
  String couldn_t_project(Object action) {
    return 'Projekt konnte nicht $action werden';
  }

  @override
  String get create => 'Erstellen';

  @override
  String get create_a_project => 'Projekt erstellen';

  @override
  String get create_a_project_first_then_chats_can_live_inside_it =>
      'Erstelle zuerst ein Projekt; darin können dann Chats leben.';

  @override
  String get create_a_space_to_separate_related_conversations =>
      'Erstelle einen Bereich, um zusammengehörige Unterhaltungen zu trennen.';

  @override
  String get create_branch => 'Branch erstellen';

  @override
  String get credit_notifications => 'Guthaben-Benachrichtigungen';

  @override
  String get credit_notifications_description =>
      'Die Guthabennutzung wurde gestoppt oder wiederhergestellt.';

  @override
  String get cron => 'Cron';

  @override
  String get crons => 'Cronjobs';

  @override
  String get cron_conversations_empty =>
      'Hier erscheinen Unterhaltungen aus geplanten Aufgaben, auch aus älteren Ausführungen.';

  @override
  String get search_cron_conversations => 'Cron-Unterhaltungen durchsuchen';

  @override
  String get cron_jobs => 'Cron-Jobs';

  @override
  String cron_schedule_timezone(Object zone) {
    return 'Zeitzone des Zeitplans: $zone';
  }

  @override
  String get crons_upcoming => 'Anstehend';

  @override
  String get crons_history => 'Verlauf';

  @override
  String cron_time_with_zone(Object time, Object zone) {
    return '$time ($zone)';
  }

  @override
  String cron_time_zone_unknown(Object time) {
    return '$time (Zeitzone unbekannt)';
  }

  @override
  String get cron_no_next_run => 'Kein nächster Lauf geplant';

  @override
  String get cron_status_scheduled => 'Geplant';

  @override
  String get cron_status_paused => 'Pausiert';

  @override
  String cron_delivers_to(Object target) {
    return 'Zustellung an $target';
  }

  @override
  String get cron_upcoming_empty_title => 'Keine geplanten Aufgaben';

  @override
  String get cron_upcoming_empty_message =>
      'Es ist nichts zur Ausführung geplant. Lege unter Cron-Jobs eine Aufgabe an oder bitte den Agenten, eine zu planen.';

  @override
  String get cron_upcoming_unavailable => 'Geplante Aufgaben nicht verfügbar';

  @override
  String get cron_upcoming_needs_dashboard =>
      'Geplante Aufgaben benötigen eine Dashboard-Verbindung. Diese Adresse stellt den Cron-Zeitplan nicht bereit. Prüfe die Dashboard-Adresse und die Unterstützung auf dem Host.';

  @override
  String get cron_upcoming_needs_dashboard_auth =>
      'Geplante Aufgaben benötigen eine Dashboard-Anmeldung. Ergänze Benutzernamen und Passwort des Dashboards für diese Verbindung oder aktiviere den Proxy-Modus.';

  @override
  String get cron_upcoming_dashboard_unreachable =>
      'Das Dashboard war nicht erreichbar. Prüfe Host, Dashboard-Port und Netzwerk und versuche es erneut.';

  @override
  String get cron_upcoming_load_failed =>
      'Die geplanten Aufgaben konnten nicht gelesen werden. Prüfe die Dashboard-Verbindung und versuche es erneut.';

  @override
  String get cron_upcoming_refresh_failed =>
      'Der Zeitplan konnte nicht aktualisiert werden. Angezeigt wird der letzte erfolgreiche Abruf.';

  @override
  String get cron_job_added => 'Cron-Job hinzugefügt';

  @override
  String get cron_job_updated => 'Cron-Job aktualisiert';

  @override
  String get cron_run => 'Cron-Ausführung';

  @override
  String get cross_device_ordering_and_reversible_bulk_organization =>
      'Geräteübergreifende Reihenfolge und umkehrbare Massenorganisation';

  @override
  String get current_profile_default => 'Aktueller Profilstandard';

  @override
  String get custom_proxy_and_dashboard_details =>
      'Benutzerdefinierte Proxy- und Dashboard-Details';

  @override
  String get dark => 'Dunkel';

  @override
  String get dashboard_proxy_settings => 'Dashboard- / Proxy-Einstellungen';

  @override
  String get dashboard_password_optional => 'Dashboard-Passwort (optional)';

  @override
  String get dashboard_port => 'Dashboard-Port';

  @override
  String get dashboard_username_optional => 'Dashboard-Benutzername (optional)';

  @override
  String get dashboard_behind_proxy => 'Dashboard hinter Proxy';

  @override
  String get dashboard_path_prefix => 'Dashboard-Pfadpräfix';

  @override
  String delegated_task(Object goal) {
    return 'Delegierte Aufgabe: $goal';
  }

  @override
  String get delete => 'Löschen';

  @override
  String delete_2(Object name) {
    return '„$name“ löschen?';
  }

  @override
  String delete_from_the_remote_hermes_history_this_cannot_be_undone(
    Object title,
  ) {
    return '„$title“ aus dem entfernten Hermes-Verlauf löschen? Dies kann nicht rückgängig gemacht werden.';
  }

  @override
  String get delete_cron_job => 'Cron-Job löschen';

  @override
  String get delete_connections_that_are_not_in_the_backup =>
      'Verbindungen löschen, die nicht im Backup enthalten sind.';

  @override
  String delete_failed(Object error) {
    return 'Löschen fehlgeschlagen: $error';
  }

  @override
  String get delete_project => 'Projekt löschen';

  @override
  String get delete_session => 'Sitzung löschen?';

  @override
  String delete_3(Object projectName) {
    return '$projectName löschen?';
  }

  @override
  String deleted(Object name) {
    return '„$name“ gelöscht';
  }

  @override
  String get delivery_is_uncertain_recovering_without_resending =>
      'Die Zustellung ist ungewiss; Wiederherstellung ohne erneutes Senden…';

  @override
  String get desktop_gateway_url_optional => 'Desktop-Gateway-URL (optional)';

  @override
  String get desktop_gateway_is_not_configured_for_this_connection =>
      'Desktop Gateway ist für diese Verbindung nicht konfiguriert.';

  @override
  String get desktop_app => 'Desktop-App';

  @override
  String get developer_tool_calls => 'Entwickler-Tool-Aufrufe';

  @override
  String get discord_chats => 'Discord-Chats';

  @override
  String get dismiss => 'Ausblenden';

  @override
  String get do_not_run_this_command => 'Diesen Befehl nicht ausführen.';

  @override
  String get documents_archives_audio_video_or_data =>
      'Dokumente, Archive, Audio, Video oder Daten';

  @override
  String get download => 'Herunterladen';

  @override
  String download_failed(Object error) {
    return 'Download fehlgeschlagen: $error';
  }

  @override
  String get durable_facts_hermes_keeps_about_you =>
      'Dauerhafte Fakten, die Hermes über dich speichert';

  @override
  String get durable_work_inside_one_of_your_projects_shared_with_desktop =>
      'Dauerhafte Arbeit in einem deiner Projekte, geteilt mit Desktop.';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get edit_connection => 'Verbindung bearbeiten';

  @override
  String get edit_cron_job => 'Cron-Job bearbeiten';

  @override
  String get edit_gateway_connection => 'Gateway-Verbindung bearbeiten';

  @override
  String get edit_and_resend => 'Bearbeiten und erneut senden';

  @override
  String get enable_notifications => 'Benachrichtigungen aktivieren';

  @override
  String get enable_notifications_description =>
      'Wenn du dies ausschaltest, werden alle Benachrichtigungen unten deaktiviert.';

  @override
  String get enables_file_attachments_through_the_desktop_remote_gateway =>
      'Aktiviert Dateianhänge über das Desktop-Remote-Gateway.';

  @override
  String get enter_a_name => 'Namen eingeben';

  @override
  String get enter_a_passphrase => 'Gib eine Passphrase ein.';

  @override
  String get enter_the_passphrase_for_this_backup =>
      'Gib die Passphrase für dieses Backup ein.';

  @override
  String get every_conversation_is_already_assigned_to_a_project =>
      'Jede Unterhaltung ist bereits einem Projekt zugewiesen.';

  @override
  String get everything_not_yet_native_in_the_authenticated_web_dashboard =>
      'Alles, was noch nicht nativ ist, im authentifizierten Web-Dashboard';

  @override
  String get explain_the_attached_content_clearly =>
      'Erkläre den angehängten Inhalt verständlich.';

  @override
  String explain_this_content_clearly(Object text) {
    return 'Erkläre diesen Inhalt verständlich:\n\n$text';
  }

  @override
  String
  get explicit_choices_adjust_android_accessibility_text_size_system_leaves_it =>
      'Explizite Auswahl passt die Android-Schriftgröße für Barrierefreiheit an; „System“ lässt sie unverändert.';

  @override
  String get export_label => 'Exportieren';

  @override
  String get export_share => 'Exportieren / teilen';

  @override
  String get external_api_clients => 'Externe API-Clients';

  @override
  String get extra_high => 'Sehr hoch';

  @override
  String get extract_tasks => 'Aufgaben extrahieren';

  @override
  String
  get extract_the_decisions_deadlines_owners_and_actionable_action_items_from =>
      'Extrahiere aus dem angehängten Inhalt Entscheidungen, Fristen, Verantwortliche und umsetzbare Aufgaben.';

  @override
  String
  extract_the_decisions_deadlines_owners_and_actionable_action_items_from_2(
    Object text,
  ) {
    return 'Extrahiere aus diesem Inhalt Entscheidungen, Fristen, Verantwortliche und umsetzbare Aufgaben:\n\n$text';
  }

  @override
  String failed_to_add_job(Object error) {
    return 'Job konnte nicht hinzugefügt werden: $error';
  }

  @override
  String get failed_to_load_cron_jobs =>
      'Cron-Jobs konnten nicht geladen werden';

  @override
  String get failed_to_load_memory => 'Gedächtnis konnte nicht geladen werden';

  @override
  String get failed_to_load_messages =>
      'Nachrichten konnten nicht geladen werden';

  @override
  String get failed_to_load_settings =>
      'Einstellungen konnten nicht geladen werden';

  @override
  String get failed_to_load_skills =>
      'Fähigkeiten konnten nicht geladen werden';

  @override
  String failed_to_update_job(Object error) {
    return 'Job konnte nicht aktualisiert werden: $error';
  }

  @override
  String failed(Object error) {
    return 'Fehlgeschlagen: $error';
  }

  @override
  String get file_attached_document_catalog_registration_is_pending =>
      'Datei angehängt; die Registrierung im Dokumentkatalog steht noch aus.';

  @override
  String get file_reference_added_to_chat =>
      'Dateireferenz zum Chat hinzugefügt';

  @override
  String get files => 'Dateien';

  @override
  String get fill_from_document => 'Aus Dokument befüllen';

  @override
  String get folder_is_empty => 'Ordner ist leer';

  @override
  String get folders => 'Ordner';

  @override
  String get full_text => 'Volltext';

  @override
  String get gateway_api_access => 'Gateway-API-Zugriff';

  @override
  String get gateway_connected_but_the_dashboard_could_not_be_reached_or =>
      'Gateway verbunden, aber das Dashboard war nicht erreichbar oder nicht authentifiziert. Prüfe die Dashboard-Details oder lösche sie, um zu überspringen.';

  @override
  String get gateway_path_prefix => 'Gateway-Pfadpräfix';

  @override
  String get go_to_end => 'Zum Ende';

  @override
  String get hermes_agent => 'Ares - formerly Hermes Android';

  @override
  String get hermes_agent_for_android => 'Ares - formerly Hermes Android';

  @override
  String get hermes_could_not_accept_the_answer_please_try_again =>
      'Hermes konnte die Antwort nicht annehmen. Bitte versuche es erneut.';

  @override
  String get hermes_could_not_load_your_saved_connections =>
      'Hermes konnte deine gespeicherten Verbindungen nicht laden';

  @override
  String get hermes_did_not_accept_the_response_please_try_again =>
      'Hermes hat die Antwort nicht angenommen. Bitte versuche es erneut.';

  @override
  String get hermes_is_responding => 'Hermes antwortet…';

  @override
  String get hermes_is_waiting_for_input => 'Hermes wartet auf deine Eingabe…';

  @override
  String get hermes_keeps_android_accessibility_text_scaling_active =>
      'Ares lässt die Android-Textskalierung für Barrierefreiheit aktiv.';

  @override
  String get hermes_needs_your_input => 'Hermes braucht deine Eingabe';

  @override
  String get hermes_profile_optional => 'Hermes-Profil (optional)';

  @override
  String get hermes_profile_must_be_a_plain_profile_name_such_as =>
      'Das Hermes-Profil muss ein einfacher Profilname wie „sol“ sein, kein Pfad.';

  @override
  String get hermes_reasoning_details => 'Hermes-Reasoning-Details';

  @override
  String hermes_recovery_is_unavailable(Object error) {
    return 'Hermes-Wiederherstellung ist nicht verfügbar: $error';
  }

  @override
  String get hermes_stopped_recovery_safely_no_prompt_was_resent =>
      'Hermes hat die Wiederherstellung sicher gestoppt. Es wurde kein Prompt erneut gesendet.';

  @override
  String get hide_passphrase => 'Passphrase verbergen';

  @override
  String get home_needs_your_recent_chats_to_know_what_deserves_your =>
      'Start braucht deine letzten Chats, um zu wissen, was deine Aufmerksamkeit verdient. Prüfe, ob das Gateway erreichbar ist, und versuche es dann erneut.';

  @override
  String get host => 'Host';

  @override
  String get image_selection_was_interrupted_try_again =>
      'Bildauswahl wurde unterbrochen. Versuche es erneut.';

  @override
  String get import_label => 'Importieren';

  @override
  String get inbox => 'Posteingang';

  @override
  String get inbox_is_clear => 'Posteingang ist leer';

  @override
  String get input_needed => 'Eingabe erforderlich';

  @override
  String get input_needed_description =>
      'Hermes hat eine Frage gestellt oder braucht ein Passwort oder Geheimnis.';

  @override
  String get insert_a_remote_file_reference =>
      'Entfernte @file-Referenz einfügen';

  @override
  String get invalid_port_number => 'Ungültige Portnummer.';

  @override
  String get job_paused => 'Job pausiert';

  @override
  String get job_resumed => 'Job fortgesetzt';

  @override
  String get job_triggered => 'Job ausgelöst';

  @override
  String get label => 'Bezeichnung';

  @override
  String last_activity(Object day, Object month, Object year) {
    return 'Letzte Aktivität $day.$month.$year';
  }

  @override
  String last(Object lastRun) {
    return 'Zuletzt: $lastRun';
  }

  @override
  String get leave_blank_for_default_8642_443_with_https =>
      'Leer lassen für Standard (8642; 443 bei https)';

  @override
  String get leave_blank_for_default_9119 => 'Leer lassen für Standard (9119)';

  @override
  String get light => 'Hell';

  @override
  String listening(Object elapsed) {
    return 'Höre zu • $elapsed';
  }

  @override
  String listening_elapsed(Object elapsed) {
    return 'Höre zu, verstrichen: $elapsed';
  }

  @override
  String get load_more => 'Mehr laden…';

  @override
  String get loading => 'Wird geladen';

  @override
  String get location => 'Standort';

  @override
  String get make_sure_the_gateway_api_server_is_running_hermes_gateway =>
      'Stelle sicher, dass der Gateway-API-Server läuft\n(hermes gateway status)';

  @override
  String matches(Object assigned, Object name) {
    return 'Passt zu $name · $assigned';
  }

  @override
  String get memory => 'Gedächtnis';

  @override
  String get memory_about_you => 'Über dich';

  @override
  String get memory_agent_notes => 'Agent-Notizen';

  @override
  String get memory_builtin_scope =>
      'Gespeicherte Fakten aus USER.md und MEMORY.md dieses Profils. Externe Speicheranbieter (einschließlich MemPalace) werden hier nicht angezeigt.';

  @override
  String get memory_read_only =>
      'Nur Lesen. Bitte Hermes im Chat, einen Fakt zu korrigieren oder zu vergessen.';

  @override
  String get memory_unavailable =>
      'Dieses Gateway oder Profil kann keine gespeicherten Fakten liefern. Prüfe das gewählte Profil und aktualisiere Hermes bei Bedarf.';

  @override
  String get memory_load_error =>
      'Prüfe die Dashboard-Verbindung und Anmeldung und versuche es erneut.';

  @override
  String get memory_read_full_fact => 'Vollständigen Fakt lesen';

  @override
  String get memory_full_fact_requires_update =>
      'Vollständige Fakten erfordern ein neueres Hermes-Gateway. Aktualisiere Hermes und lade die Liste neu.';

  @override
  String get memory_fact_detail_error =>
      'Der vollständige Fakt konnte nicht geladen werden. Er wurde möglicherweise geändert. Aktualisiere die Liste und versuche es erneut.';

  @override
  String get memory_entries_are_cross_session_facts_the_agent_remembers_they =>
      'Gespeicherte Fakten erscheinen hier, sobald Hermes sie sich merkt.';

  @override
  String get merge => 'Zusammenführen';

  @override
  String get message => 'Nachricht';

  @override
  String get message_hermes => 'Nachricht an Hermes…';

  @override
  String get message_actions => 'Nachrichtenaktionen';

  @override
  String get message_copied => 'Nachricht kopiert';

  @override
  String get migrating => 'Migration läuft…';

  @override
  String get migration_complete => 'Migration abgeschlossen';

  @override
  String get migration_failed_local_spaces_were_kept_unchanged =>
      'Migration fehlgeschlagen. Lokale Bereiche wurden unverändert beibehalten.';

  @override
  String get migration_incomplete => 'Migration unvollständig';

  @override
  String get migration_preview => 'Migrationsvorschau';

  @override
  String get model => 'Modell';

  @override
  String get model_and_thinking_for_this_chat =>
      'Modell und Reasoning für diesen Chat';

  @override
  String model_was_not_changed(Object error) {
    return 'Modell wurde nicht geändert: $error';
  }

  @override
  String get move_attachment_next => 'Anhang nach hinten verschieben';

  @override
  String get move_attachment_previous => 'Anhang nach vorne verschieben';

  @override
  String get move_chat => 'Chat verschieben';

  @override
  String get move_conversation => 'Unterhaltung verschieben';

  @override
  String get move_to_project => 'In Projekt verschieben';

  @override
  String get move_to_space => 'In Bereich verschieben';

  @override
  String get moved_to_a_project => 'In ein Projekt verschoben';

  @override
  String moved_to(Object label) {
    return 'Nach $label verschoben';
  }

  @override
  String get name => 'Name';

  @override
  String get name_prompt_and_schedule_are_required =>
      'Name, Prompt und Zeitplan sind erforderlich';

  @override
  String get nav_activity => 'Aktivität';

  @override
  String get nav_projects => 'Projekte';

  @override
  String get needs_a_correction_aware_filing_contract_in_the_hermes_gateway =>
      'Erfordert einen korrekturfähigen Ablagevertrag im Hermes-Gateway.';

  @override
  String get needs_a_reachable_hermes_dashboard_check_the_host_port_and =>
      'Erfordert ein erreichbares Hermes-Dashboard. Prüfe Host, Port und Zugangsdaten dieser Verbindung.';

  @override
  String get needs_a_server_authoritative_assets_index_in_the_hermes_gateway =>
      'Erfordert einen serverautoritativen Assets-Index im Hermes-Gateway.';

  @override
  String get needs_durable_pin_ordering_batch_mutation_and_undo_contracts_in =>
      'Erfordert dauerhafte Pin-Reihenfolge-, Batch-Mutations- und Undo-Verträge im Hermes-Gateway.';

  @override
  String get needs_you => 'Du wirst gebraucht';

  @override
  String get new_label => 'Neu';

  @override
  String get new_chat => 'Neuer Chat';

  @override
  String get new_chat_2 => 'Neuer Chat';

  @override
  String new_chat_3(Object projectName) {
    return 'Neuer Chat · $projectName';
  }

  @override
  String get new_project => 'Neues Projekt';

  @override
  String get new_space => 'Neuer Bereich';

  @override
  String next(Object nextRun) {
    return 'Nächste: $nextRun';
  }

  @override
  String get nginx_injects_auth_app_sends_clean_requests =>
      'Nginx injiziert die Authentifizierung — die App sendet saubere Anfragen';

  @override
  String get no_tts_voices_found_ninstall_google_text_to_speech_and =>
      'Keine TTS-Stimmen gefunden.\nInstalliere Google Text-to-Speech und lade die Sprachdaten herunter.';

  @override
  String get no_active_projects_on_this_gateway =>
      'Keine aktiven Projekte auf diesem Gateway';

  @override
  String get no_activity_yet => 'Noch keine Aktivität';

  @override
  String get no_chat_is_blocked_running_or_waiting_to_be_resumed =>
      'Kein Chat ist blockiert, läuft oder wartet auf Fortsetzung. Starte jederzeit einen neuen.';

  @override
  String no_chats_in_this_project_match(Object searchQuery) {
    return 'Keine Chats in diesem Projekt passen zu „$searchQuery“.';
  }

  @override
  String get no_chats_in_this_space_yet_tap_to_start_one =>
      'Noch keine Chats in diesem Bereich. Tippe auf +, um einen zu starten.';

  @override
  String get no_chats_yet => 'Noch keine Chats';

  @override
  String get no_connections => 'Keine Verbindungen';

  @override
  String get no_conversation_matches_this_view =>
      'Keine Unterhaltung passt zu dieser Ansicht.';

  @override
  String get no_cron_jobs => 'Keine Cron-Jobs';

  @override
  String get no_folders_yet => 'Noch keine Ordner';

  @override
  String get no_local_spaces_were_found_for_this_connection_so_projects =>
      'Für diese Verbindung wurden keine lokalen Bereiche gefunden; Projekte sind hier also bereits die einzige verwendete Organisation.';

  @override
  String get no_matches => 'Keine Treffer';

  @override
  String get no_memory_entries => 'Keine Gedächtniseinträge';

  @override
  String get no_message_content_matches => 'Keine Treffer im Nachrichteninhalt';

  @override
  String get no_new_messages => 'Keine neuen Nachrichten';

  @override
  String get no_projects_yet => 'Noch keine Projekte';

  @override
  String get no_runs_yet => 'Noch keine Ausführungen.';

  @override
  String no_server_project_matches_this_name(Object assigned) {
    return 'Kein Serverprojekt passt zu diesem Namen · $assigned';
  }

  @override
  String get no_sessions_yet => 'Noch keine Sitzungen';

  @override
  String get no_skills_found => 'Keine Fähigkeiten gefunden';

  @override
  String get no_spaces_on_this_device => 'Keine Bereiche auf diesem Gerät';

  @override
  String get no_text_shared => 'Kein Text geteilt';

  @override
  String get no_turn_is_blocked_in_flight_or_recently_finished_work =>
      'Kein Turn ist blockiert, läuft oder wurde kürzlich abgeschlossen. Gestartete Arbeit erscheint hier.';

  @override
  String get no_turn_needs_your_input_or_has_failed =>
      'Kein Turn braucht deine Eingabe oder ist fehlgeschlagen.';

  @override
  String get no_unassigned_chats => 'Keine nicht zugewiesenen Chats.';

  @override
  String get nothing_changed_in_the_last_seven_days =>
      'In den letzten sieben Tagen hat sich nichts geändert.';

  @override
  String get nothing_has_moved_yet_this_is_only_what_a_migration =>
      'Es wurde noch nichts verschoben — dies ist nur, was eine Migration tun würde.';

  @override
  String get nothing_here => 'Hier ist nichts';

  @override
  String get nothing_is_running => 'Nichts läuft';

  @override
  String get nothing_needs_you => 'Nichts braucht dich';

  @override
  String get nothing_to_migrate => 'Nichts zu migrieren';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get windows_notifications_blocked =>
      'Benachrichtigungen sind nicht verfügbar. Verwende die installierte Ares-App und prüfe in Windows Einstellungen → System → Benachrichtigungen.';

  @override
  String get windows_notification_diagnostics =>
      'Was Ares an Windows übermittelt hat';

  @override
  String get chat_activity_share => 'Chat-Aktivität teilen';

  @override
  String get chat_activity_share_hint =>
      'Teile einem kompatiblen verbundenen Gateway mit, wann du diesen Chat nutzt, damit sein Telefon-Benachrichtigungsplugin doppelte Hinweise vermeiden kann. Es werden keine Schlüssel oder Nachrichtentexte gesendet.';

  @override
  String get completion_sound => 'Abschlusston';

  @override
  String get completion_sound_system => 'Systemstandard';

  @override
  String get completion_sound_mail => 'Mail';

  @override
  String get completion_sound_reminder => 'Erinnerung';

  @override
  String get completion_sound_silent => 'Lautlos';

  @override
  String get completion_sound_scope =>
      'Wird bei fertigen Antworten, der Testbenachrichtigung und in der App abgespielt. Genehmigungen und andere Hinweise behalten ihren üblichen Ton.';

  @override
  String get completion_sound_scope_android =>
      'Wird bei fertigen Antworten, der Testbenachrichtigung und in der App abgespielt. Genehmigungen, andere Hinweise, Hintergrundbenachrichtigungen vom Server und Android Auto-Nachrichten behalten ihren üblichen Ton.';

  @override
  String get notification_open_action => 'Öffnen';

  @override
  String get app_sounds_mute => 'App-Töne stummschalten';

  @override
  String get app_sounds_mute_hint =>
      'Schaltet den Abschlusston aus, den Ares bei geöffneter App abspielt. Benachrichtigungen behalten ihren eigenen Ton.';

  @override
  String get notifications_permission_denied =>
      'Benachrichtigungen sind auf Systemebene blockiert. Aktiviere sie für diese App in den Android-Einstellungen.';

  @override
  String get off_no_thinking => 'Aus (kein Reasoning)';

  @override
  String get offline_showing_the_last_known_activity =>
      'Offline — zeige die letzte bekannte Aktivität.';

  @override
  String get offline_showing_the_last_known_chats =>
      'Offline — zeige die letzten bekannten Chats';

  @override
  String get offline_showing_the_last_known_projects =>
      'Offline — zeige die letzten bekannten Projekte.';

  @override
  String get on_this_device => 'Auf diesem Gerät';

  @override
  String get on_device => 'Auf dem Gerät';

  @override
  String get open_inbox => 'Posteingang öffnen';

  @override
  String open_inbox_2(Object count) {
    return 'Posteingang öffnen ($count)';
  }

  @override
  String get open_the_hermes_dashboard => 'Hermes-Dashboard öffnen';

  @override
  String get optional_for_the_memory_cron_skills_settings_tabs_leave_blank =>
      'Optional. Für die Tabs Gedächtnis/Cron/Fähigkeiten/Einstellungen. Leer lassen, um den Standard-Dashboard-Port (9119) ohne Anmeldung zu verwenden.';

  @override
  String get organization => 'Organisation';

  @override
  String get other_answer => 'Andere Antwort';

  @override
  String get overview => 'Übersicht';

  @override
  String get passphrase => 'Passphrase';

  @override
  String get password_optional => 'Passwort (optional)';

  @override
  String get phone_or_tablet => 'Telefon oder Tablet';

  @override
  String get pin_batch_and_undo =>
      'Anpinnen, Stapelverarbeitung und Rückgängig';

  @override
  String get plugin_notifications => 'Plugin-Benachrichtigungen';

  @override
  String get plugin_notifications_description =>
      'Das Gateway hat eine Mitteilung gesendet, während die App im Hintergrund war.';

  @override
  String get port => 'Port';

  @override
  String get preparing_attachments => 'Anhänge werden vorbereitet…';

  @override
  String get preview_truncated => 'Vorschau gekürzt';

  @override
  String get preview_unavailable => 'Vorschau nicht verfügbar';

  @override
  String get profile => 'Profil';

  @override
  String get profile_default_model => 'Standardmodell des Profils';

  @override
  String profile_default_set_to_chats_with_their_own_model_keep(
    Object selectedModel,
  ) {
    return 'Profilstandard auf $selectedModel gesetzt. Chats mit eigenem Modell behalten diese Überschreibung.';
  }

  @override
  String
  get profile_this_connection_chats_as_when_the_dashboard_serves_several =>
      'Profil, mit dem diese Verbindung chattet, wenn das Dashboard mehrere Profile bedient. Leer lassen für ein isoliertes Dashboard pro Profil.';

  @override
  String get project => 'Projekt';

  @override
  String get project_actions => 'Projektaktionen';

  @override
  String get project_chat => 'Projekt-Chat';

  @override
  String get project_chats_unavailable => 'Projekt-Chats nicht verfügbar';

  @override
  String get projects => 'Projekte';

  @override
  String get projects_group_related_chats_files_and_activity_and_stay_in =>
      'Projekte gruppieren zugehörige Chats, Dateien und Aktivitäten und bleiben mit Hermes auf deinem Computer synchron.';

  @override
  String
  get projects_need_a_desktop_gateway_connection_add_the_desktop_gateway =>
      'Projekte benötigen eine Desktop-Gateway-Verbindung. Füge die Desktop-Gateway-URL zu dieser Verbindung hinzu, um Chats geräteübergreifend zu organisieren.';

  @override
  String get projects_unavailable => 'Projekte nicht verfügbar';

  @override
  String get projects_activity_new_navigation =>
      'Projekte, Aktivität — neue Navigation';

  @override
  String get promote_to_project => 'Zu Projekt hochstufen';

  @override
  String get prompt => 'Prompt';

  @override
  String get protect_this_backup => 'Dieses Backup schützen';

  @override
  String get provider => 'Anbieter';

  @override
  String get proxy_injects_auth_app_sends_clean_requests =>
      'Proxy injiziert die Authentifizierung; die App sendet saubere Anfragen';

  @override
  String get quick_chat => 'Schnellchat';

  @override
  String get quick_chats_appear_here_after_their_retention_period =>
      'Schnellchats erscheinen hier nach ihrer Aufbewahrungsfrist.';

  @override
  String get read_aloud => 'Vorlesen';

  @override
  String get read_aloud_is_unavailable_on_this_device =>
      'Vorlesen ist auf diesem Gerät nicht verfügbar';

  @override
  String get reading_response_aloud => 'Antwort wird vorgelesen';

  @override
  String get ready_to_upload => 'Bereit zum Hochladen';

  @override
  String get reasoning => 'Reasoning';

  @override
  String get recently_completed => 'Kürzlich abgeschlossen';

  @override
  String get recently_active => 'Kürzlich aktiv';

  @override
  String get recovering_hermes => 'Hermes wird wiederhergestellt…';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get regenerate_response => 'Antwort neu generieren';

  @override
  String get remove_attachment => 'Anhang entfernen';

  @override
  String get rename => 'Umbenennen';

  @override
  String get rename_chat => 'Chat umbenennen';

  @override
  String get rename_project => 'Projekt umbenennen';

  @override
  String get rename_space => 'Bereich umbenennen';

  @override
  String rename_2(Object projectName) {
    return '$projectName umbenennen';
  }

  @override
  String rename_3(Object name) {
    return '$name umbenennen';
  }

  @override
  String get replace => 'Ersetzen';

  @override
  String get repositories => 'Repositories';

  @override
  String
  get research_the_attached_content_verify_the_important_claims_and_cite =>
      'Recherchiere den angehängten Inhalt, überprüfe die wichtigen Aussagen und gib Quellen an.';

  @override
  String research_this_content_verify_the_important_claims_and_cite_sources(
    Object text,
  ) {
    return 'Recherchiere diesen Inhalt, überprüfe die wichtigen Aussagen und gib Quellen an:\n\n$text';
  }

  @override
  String reset_failed_the_secure_storage_may_need_reinstall(Object retryError) {
    return 'Zurücksetzen fehlgeschlagen: $retryError. Der sichere Speicher muss möglicherweise neu installiert werden.';
  }

  @override
  String get reset_saved_connections =>
      'Gespeicherte Verbindungen zurücksetzen';

  @override
  String get responding => 'Antwortet…';

  @override
  String response_closed_locally_gateway_stop_failed(Object error) {
    return 'Antwort lokal geschlossen; Gateway-Stopp fehlgeschlagen: $error';
  }

  @override
  String get response_closed_locally_no_active_gateway_turn_was_found =>
      'Antwort lokal geschlossen; kein aktiver Gateway-Turn gefunden.';

  @override
  String get response_complete => 'Antwort abgeschlossen';

  @override
  String get response_complete_description =>
      'Ein Durchlauf wurde abgeschlossen, während die App im Hintergrund war.';

  @override
  String get response_ready => 'Antwort bereit';

  @override
  String get response_stopped => 'Antwort gestoppt.';

  @override
  String get restore => 'Wiederherstellen';

  @override
  String get restore_configuration => 'Konfiguration wiederherstellen';

  @override
  String get restore_project => 'Projekt wiederherstellen';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String retry_failed_for_the_draft_and_prompt_were_kept(Object name) {
    return 'Erneuter Versuch für $name fehlgeschlagen. Entwurf und Prompt wurden beibehalten.';
  }

  @override
  String get retry_upload => 'Upload erneut versuchen';

  @override
  String retrying(Object name) {
    return '$name wird erneut versucht…';
  }

  @override
  String get review_local_spaces => 'Lokale Bereiche überprüfen';

  @override
  String get review_or_promote_quick_chats_past_their_retention_period =>
      'Schnellchats nach ihrer Aufbewahrungsfrist überprüfen oder hochstufen';

  @override
  String get review_the_attached_content => 'Überprüfe den angehängten Inhalt.';

  @override
  String get run_only_this_command => 'Führe nur diesen Befehl aus.';

  @override
  String get running_now => 'Läuft gerade';

  @override
  String get save => 'Speichern';

  @override
  String get save_changes => 'Änderungen speichern';

  @override
  String get save_a_permanent_rule_in_the_hermes_configuration =>
      'Speichere eine dauerhafte Regel in der Hermes-Konfiguration.';

  @override
  String get save_the_durable_facts_from_the_attached_content_to_memory =>
      'Speichere die dauerhaften Fakten aus dem angehängten Inhalt im Gedächtnis und bestätige, was behalten wurde.';

  @override
  String save_the_durable_facts_from_this_content_to_memory_then(Object text) {
    return 'Speichere die dauerhaften Fakten aus diesem Inhalt im Gedächtnis und bestätige, was behalten wurde:\n\n$text';
  }

  @override
  String get save_your_connections_and_settings_to_an_encrypted_file_then =>
      'Speichere deine Verbindungen und Einstellungen in einer verschlüsselten Datei und stelle sie nach einer Neuinstallation oder auf einem anderen Gerät wieder her.';

  @override
  String save_2(Object filename) {
    return '$filename speichern';
  }

  @override
  String get schedule => 'Zeitplan';

  @override
  String get scheduled_jobs_and_their_last_runs =>
      'Geplante Jobs und ihre letzten Ausführungen';

  @override
  String get scheduled_tasks => 'Geplante Aufgaben';

  @override
  String get script_only_no_agent => 'Nur Skript (kein Agent)';

  @override
  String get scroll_horizontally => 'Horizontal scrollen';

  @override
  String get search_all_chats => 'Alle Chats durchsuchen';

  @override
  String get search_all_message_content =>
      'Gesamten Nachrichteninhalt durchsuchen';

  @override
  String get search_chats => 'Chats durchsuchen';

  @override
  String get search_conversations => 'Unterhaltungen durchsuchen';

  @override
  String get search_loaded_chats => 'Geladene Chats durchsuchen';

  @override
  String get search_mode => 'Suchmodus';

  @override
  String get select_one_option_or_enter_another_answer =>
      'Wähle eine Option oder gib eine andere Antwort ein.';

  @override
  String get select_one_or_more_options_then_continue =>
      'Wähle eine oder mehrere Optionen und fahre dann fort.';

  @override
  String get select_text => 'Text auswählen';

  @override
  String get send => 'Senden';

  @override
  String send_failed(Object error) {
    return 'Senden fehlgeschlagen: $error';
  }

  @override
  String send_failed_api_only_permission_denied(Object error) {
    return 'Senden fehlgeschlagen: $error. Der Server hat diesen Schreibvorgang für den API-Schlüssel-Principal abgelehnt. Wenn dieser Chat zum Dashboard gehört, kann das Hinterlegen von Dashboard-Benutzername und -Passwort für diese Verbindung das Senden ermöglichen; der Server kann es aber auch absichtlich verweigern.';
  }

  @override
  String get send_message => 'Nachricht senden';

  @override
  String get send_test_notification => 'Testbenachrichtigung senden';

  @override
  String get session_sources => 'Sitzungsquellen';

  @override
  String get session_deleted_from_remote_hermes =>
      'Sitzung aus dem entfernten Hermes gelöscht.';

  @override
  String session_search_failed(Object error) {
    return 'Sitzungssuche fehlgeschlagen: $error';
  }

  @override
  String get set_profile_default => 'Als Profilstandard festlegen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get share_to_hermes => 'An Hermes teilen';

  @override
  String get show_passphrase => 'Passphrase anzeigen';

  @override
  String get show_tool_calls_thinking_and_message_metadata =>
      'Tool-Aufrufe, Reasoning und Nachrichten-Metadaten anzeigen';

  @override
  String get signal_messages => 'Signal-Nachrichten';

  @override
  String get skills => 'Fähigkeiten';

  @override
  String skills_2(Object count) {
    return 'Fähigkeiten ($count)';
  }

  @override
  String get skills_and_tools => 'Fähigkeiten und Tools';

  @override
  String get skip => 'Überspringen';

  @override
  String get slack_chats => 'Slack-Chats';

  @override
  String source(Object source) {
    return 'Quelle: $source';
  }

  @override
  String get space_actions => 'Bereichsaktionen';

  @override
  String get spaces => 'Bereiche';

  @override
  String get speak_to_hermes => 'Sprich mit Hermes';

  @override
  String get speech_recognition_is_unavailable =>
      'Spracherkennung ist nicht verfügbar';

  @override
  String get spoken_replies => 'Gesprochene Antworten';

  @override
  String get spoken_replies_off => 'Gesprochene Antworten aus';

  @override
  String get spoken_replies_on => 'Gesprochene Antworten an';

  @override
  String get stalled_no_update_from_hermes =>
      'Ins Stocken geraten — kein Update von Hermes';

  @override
  String get start_something_new => 'Etwas Neues starten';

  @override
  String get start_voice_input => 'Spracheingabe starten';

  @override
  String get starting_hermes => 'Hermes wird gestartet…';

  @override
  String get media_card_download => 'Datei herunterladen';

  @override
  String get media_card_tap_to_download => 'Zum Herunterladen tippen';

  @override
  String get still_loading_your_projects =>
      'Deine Projekte werden noch geladen.';

  @override
  String get stop => 'Stoppen';

  @override
  String get stop_response => 'Antwort stoppen';

  @override
  String get stop_voice_input => 'Spracheingabe stoppen';

  @override
  String get submitted_waiting_for_hermes => 'Gesendet, warte auf Hermes';

  @override
  String get suggest_projects_and_learn_from_your_corrections =>
      'Projekte vorschlagen und aus deinen Korrekturen lernen';

  @override
  String get summarize_the_attached_content =>
      'Fasse den angehängten Inhalt zusammen.';

  @override
  String summarize_this_content(Object text) {
    return 'Fasse diesen Inhalt zusammen:\n\n$text';
  }

  @override
  String get switch_profile => 'Profil wechseln';

  @override
  String get system => 'System';

  @override
  String get take_photo => 'Foto aufnehmen';

  @override
  String get tap_to_add_a_remote_hermes_gateway_api_server_port =>
      'Tippe auf +, um ein entferntes Hermes-Gateway hinzuzufügen\n(API-Server, Port 8642)';

  @override
  String get tap_the_button_to_start_a_new_chat =>
      'Tippe auf die +-Schaltfläche, um einen neuen Chat zu starten';

  @override
  String get telegram_messages => 'Telegram-Nachrichten';

  @override
  String get terminal_sessions => 'Terminal-Sitzungen';

  @override
  String get test_notification_body =>
      'Wenn du das siehst, funktionieren die Benachrichtigungen.';

  @override
  String get test_notification_sent => 'Testbenachrichtigung gesendet.';

  @override
  String get test_notification_title => 'Hermes-Benachrichtigungstest';

  @override
  String get test_notification_unsupported =>
      'Benachrichtigung konnte nicht gesendet werden — prüfe, ob das System Benachrichtigungen erlaubt.';

  @override
  String get text_size => 'Textgröße';

  @override
  String get text_size_preview => 'Textgrößen-Vorschau';

  @override
  String text_size_2(Object label) {
    return 'Textgröße: $label';
  }

  @override
  String get the_api_key_could_not_be_stored_securely =>
      'Der API-Schlüssel konnte nicht sicher gespeichert werden.';

  @override
  String get the_project_will_move_to_archived_its_chats_and_files =>
      'Das Projekt wird nach „Archiviert“ verschoben. Seine Chats und Dateien bleiben intakt, und du kannst es jederzeit wiederherstellen.';

  @override
  String get the_project_will_move_to_archived_its_chats_and_files_2 =>
      'Das Projekt wird nach „Archiviert“ verschoben. Seine Chats und Dateien bleiben intakt, und du kannst es später wiederherstellen.';

  @override
  String get the_active_profile_did_not_return_any_selectable_models =>
      'Das aktive Profil hat keine auswählbaren Modelle zurückgegeben.';

  @override
  String get the_backup_could_not_be_exported =>
      'Das Backup konnte nicht exportiert werden.';

  @override
  String get the_backup_could_not_be_restored =>
      'Das Backup konnte nicht wiederhergestellt werden.';

  @override
  String get the_connection_could_not_be_deleted_safely =>
      'Die Verbindung konnte nicht sicher gelöscht werden.';

  @override
  String get the_connection_could_not_be_stored_securely =>
      'Die Verbindung konnte nicht sicher gespeichert werden.';

  @override
  String get the_dashboard_credentials_could_not_be_stored_securely =>
      'Die Dashboard-Zugangsdaten konnten nicht sicher gespeichert werden.';

  @override
  String get the_detached_reply_failed =>
      'Die abgekoppelte Antwort ist fehlgeschlagen.';

  @override
  String the_detached_reply_failed_2(Object error) {
    return 'Die abgekoppelte Antwort ist fehlgeschlagen: $error';
  }

  @override
  String get the_file_contains_your_api_keys_and_dashboard_password_so =>
      'Die Datei enthält deine API-Schlüssel und das Dashboard-Passwort und ist daher verschlüsselt. Ohne diese Passphrase kann das Backup nicht wiederhergestellt werden.';

  @override
  String get the_last_turn_failed => 'Der letzte Turn ist fehlgeschlagen';

  @override
  String the_local_connection_store_looks_damaged_you_can_reset_the(
    Object errorType,
  ) {
    return 'Der lokale Verbindungsspeicher scheint beschädigt zu sein ($errorType). Du kannst die gespeicherten Verbindungen zurücksetzen und neu beginnen. Chats auf deinem Gateway sind nicht betroffen.';
  }

  @override
  String get the_model_only_rewrites_your_question_into_a_short_full =>
      'Das Modell schreibt deine Frage nur in eine kurze Volltextanfrage um. Hermes verwendet die bereits auf dem Host konfigurierten Anbieter-Zugangsdaten.';

  @override
  String get the_server_has_not_reported_folders_for_this_project_yet =>
      'Der Server hat für dieses Projekt noch keine Ordner gemeldet. Globale Dateien bleibt über Mehr verfügbar.';

  @override
  String get the_turn_failed => 'Der Turn ist fehlgeschlagen';

  @override
  String get the_two_passphrases_do_not_match =>
      'Die beiden Passphrasen stimmen nicht überein.';

  @override
  String get the_value_is_sent_directly_to_the_active_hermes_gateway =>
      'Der Wert wird direkt an das aktive Hermes-Gateway gesendet und nicht von dieser Android-App gespeichert.';

  @override
  String get there_are_no_visible_files_in_this_server_folder =>
      'In diesem Serverordner sind keine sichtbaren Dateien.';

  @override
  String get thinking_effort => 'Denkaufwand';

  @override
  String get this_hermes_gateway_does_not_support_opening_a_project_yet =>
      'Dieses Hermes-Gateway unterstützt das Öffnen eines Projekts noch nicht. Aktualisiere Hermes auf dem Server, um ein Projekt vom Telefon aus zu durchsuchen.';

  @override
  String get this_hermes_gateway_is_older_than_server_side_projects_so =>
      'Dieses Hermes-Gateway ist älter als serverseitige Projekte, daher bleiben Chats nur auf diesem Gerät gruppiert. Aktualisiere Hermes, um dieselben Projekte geräteübergreifend zu teilen.';

  @override
  String get this_project_has_no_folder_to_open_the_chat_in =>
      'Dieses Projekt benötigt einen Ordner, bevor du darin einen Chat starten kannst. Füge einen Ordner hinzu und versuche es erneut.';

  @override
  String get this_chat_has_no_messages_available_in_the_desktop_session =>
      'Dieser Chat hat noch keine Nachrichten in der Desktop-Sitzung.';

  @override
  String get this_creates_a_permanent_rule_in_hermes_review_the_full =>
      'Dies erstellt eine dauerhafte Regel in Hermes. Überprüfe den vollständigen Befehl, bevor du bestätigst.';

  @override
  String get this_gateway_does_not_host_projects_yet_update_the_gateway =>
      'Dieses Gateway hostet noch keine Projekte. Aktualisiere das Gateway, um Chats geräteübergreifend zu organisieren.';

  @override
  String get this_permanently_deletes_the_project_chats_will_not_be_deleted =>
      'Dies löscht das Projekt dauerhaft. Chats werden nicht gelöscht; sie kehren zu „Nicht zugewiesen“ zurück.';

  @override
  String get this_server_doesn_t_offer_background_recovery_chats_run_live =>
      'Dieser Server bietet keine Hintergrund-Wiederherstellung — Chats laufen live';

  @override
  String get this_week => 'Diese Woche';

  @override
  String get titles_previews_and_models => 'Titel, Vorschauen und Modelle';

  @override
  String get tool_activity => 'Tool-Aktivität';

  @override
  String get trigger_now => 'Jetzt auslösen';

  @override
  String get received_outcome_unknown => 'Turn beendet — Ergebnis unbestätigt';

  @override
  String get turn_completed => 'Turn abgeschlossen';

  @override
  String get turn_failed => 'Durchlauf fehlgeschlagen';

  @override
  String get turn_failed_description =>
      'Ein Durchlauf im Hintergrund endete mit einem Fehler.';

  @override
  String get turn_recovery_failed => 'Turn-Wiederherstellung fehlgeschlagen';

  @override
  String get unable_to_prepare_this_file_try_another_one =>
      'Diese Datei konnte nicht vorbereitet werden. Versuche es mit einer anderen.';

  @override
  String get unable_to_prepare_this_image_try_another_one =>
      'Dieses Bild konnte nicht vorbereitet werden. Versuche es mit einem anderen.';

  @override
  String unable_to_prepare(Object name) {
    return '$name konnte nicht vorbereitet werden.';
  }

  @override
  String get unable_to_read_the_selected_image_the_selection_was_kept =>
      'Das ausgewählte Bild konnte nicht gelesen werden. Die Auswahl wurde beibehalten.';

  @override
  String get unassigned => 'Nicht zugewiesen';

  @override
  String get unassigned_chats => 'Nicht zugewiesene Chats';

  @override
  String get untitled_chat => 'Unbenannter Chat';

  @override
  String get untitled_session => 'Unbenannte Sitzung';

  @override
  String get update_api_key => 'API-Schlüssel aktualisieren';

  @override
  String get upload_failed => 'Upload fehlgeschlagen';

  @override
  String get upload_failed_tap_retry =>
      'Upload fehlgeschlagen • zum Wiederholen tippen';

  @override
  String uploading(Object index, Object name, Object total) {
    return 'Lade $index/$total hoch: $name';
  }

  @override
  String get use_as_is => 'So verwenden';

  @override
  String get use_at_least_8_characters => 'Verwende mindestens 8 Zeichen.';

  @override
  String get use_for_cron_jobs_backed_by_scripts =>
      'Für skriptbasierte Cron-Jobs verwenden.';

  @override
  String get use_on_device => 'Auf dem Gerät verwenden';

  @override
  String get use_the_attached_content_to_identify_and_fill_the_relevant =>
      'Verwende den angehängten Inhalt, um die relevanten Dokument- oder Formularfelder zu identifizieren und auszufüllen. Frage nach, bevor du etwas absendest.';

  @override
  String use_this_content_to_identify_and_fill_the_relevant_document(
    Object text,
  ) {
    return 'Verwende diesen Inhalt, um die relevanten Dokument- oder Formularfelder zu identifizieren und auszufüllen. Frage nach, bevor du etwas absendest:\n\n$text';
  }

  @override
  String get used_for_hosted_path_prefixes_and_for_the_settings_memory =>
      'Wird für gehostete Pfadpräfixe und für die Tabs Einstellungen, Gedächtnis, Fähigkeiten und Cron verwendet. Lass Benutzername/Passwort leer für ein offenes Dashboard, oder aktiviere den Proxy-Modus, wenn dein Reverse-Proxy die Dashboard-Authentifizierung injiziert.';

  @override
  String get username_optional => 'Benutzername (optional)';

  @override
  String using(Object displayName) {
    return '$displayName wird verwendet…';
  }

  @override
  String get verbose_mode => 'Ausführlicher Modus';

  @override
  String get message_metadata => 'Nachrichtendetails';

  @override
  String get voice => 'Sprache';

  @override
  String voice_setup_failed(Object error) {
    return 'Spracheinrichtung fehlgeschlagen: $error';
  }

  @override
  String get waiting_for_your_input => 'Warte auf deine Eingabe';

  @override
  String get what_hermes_knows_how_to_do => 'Was Hermes kann';

  @override
  String get what_should_the_agent_do => 'Was soll der Agent tun?';

  @override
  String get whatsapp_messages => 'WhatsApp-Nachrichten';

  @override
  String get which_project => 'Welches Projekt?';

  @override
  String get workspace => 'Arbeitsbereich';

  @override
  String get wrap_lines => 'Zeilen umbrechen';

  @override
  String you_can_attach_up_to_items(Object maxRemoteAttachmentDrafts) {
    return 'Du kannst bis zu $maxRemoteAttachmentDrafts Elemente anhängen.';
  }

  @override
  String get your_answer => 'Deine Antwort';

  @override
  String get e_g_dashboard => 'z. B. /dashboard';

  @override
  String get e_g_dashboard_proxy_path_before_api =>
      'z. B. /dashboard (Proxy-Pfad vor /api/)';

  @override
  String get e_g_profile_peter => 'z. B. /profile/peter';

  @override
  String get e_g_sol => 'z. B. sol';

  @override
  String get e_g_0_9_or_every_2h => 'z. B. 0 9 * * * oder every 2h';

  @override
  String get e_g_daily_backup => 'z. B. Tägliches Backup';

  @override
  String downloaded(Object filename) {
    return '$filename heruntergeladen';
  }

  @override
  String activity_name_status(Object displayName, Object statusLabel) {
    return '$displayName: $statusLabel';
  }

  @override
  String connection_status_label(Object connectionLabel, Object label) {
    return '$connectionLabel $label';
  }

  @override
  String get example_host_hint =>
      '192.168.1.50, 100.x.y.z oder hermes-machine.tailnet.ts.net';

  @override
  String get example_profile_prefix_hint_full =>
      'z. B. /profile/peter (Proxy-Pfad vor /api/ und /v1/)';

  @override
  String and_more(Object count) {
    return 'und $count weitere';
  }

  @override
  String chats_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Chats',
      one: '$count Chat',
    );
    return '$_temp0';
  }

  @override
  String on_this_device_only(Object chats) {
    return '$chats · nur auf diesem Gerät';
  }

  @override
  String spaces_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bereiche',
      one: '$count Bereich',
    );
    return '$_temp0';
  }

  @override
  String get no_new_projects_needed => 'keine neuen Projekte nötig';

  @override
  String projects_to_create(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zu erstellende Projekte',
      one: '$count zu erstellendes Projekt',
    );
    return '$_temp0';
  }

  @override
  String chats_migrated_projects_created(
    Object createdProjects,
    Object linkedSessions,
  ) {
    return '$linkedSessions Chats migriert · $createdProjects Projekte erstellt';
  }

  @override
  String chats_stayed_in_local_spaces(Object unlinkedSessions) {
    return '$unlinkedSessions Chats sind in lokalen Bereichen geblieben und können sicher erneut versucht werden.';
  }

  @override
  String model_recommended(Object provider) {
    return '$provider • Empfohlen: klein und günstig';
  }

  @override
  String session_meta(Object count, Object model, Object time) {
    return '$count Nachr. • $model • $time';
  }

  @override
  String model_scope_label(Object model, Object scope) {
    return '$model • $scope';
  }

  @override
  String get this_chat => 'dieser Chat';

  @override
  String get profile_default => 'Profilstandard';

  @override
  String minutes_ago(Object count) {
    return 'vor $count Min.';
  }

  @override
  String hours_ago(Object count) {
    return 'vor $count Std.';
  }

  @override
  String days_ago(Object count) {
    return 'vor $count T.';
  }

  @override
  String get now_label => 'jetzt';

  @override
  String get latest_label => 'Neueste';

  @override
  String new_count_indicator(Object count) {
    return '$count neu';
  }

  @override
  String new_messages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count neue Nachrichten',
      one: '$count neue Nachricht',
    );
    return '$_temp0';
  }

  @override
  String activity_failed_summary(Object failures, Object total) {
    return '$failures fehlgeschlagen • $total gesamt';
  }

  @override
  String activity_completed_summary(Object count) {
    return '$count abgeschlossen';
  }

  @override
  String tool_start_observed(Object time) {
    return 'Start beobachtet um $time (Ortszeit)';
  }

  @override
  String tool_last_observed(Object time) {
    return 'Zuletzt beobachtet um $time (Ortszeit)';
  }

  @override
  String tool_result_recorded(Object time) {
    return 'Ergebnis erfasst um $time (Ortszeit)';
  }

  @override
  String get tool_time_unavailable => 'Uhrzeit nicht verfügbar';

  @override
  String get hermes_is_using_a_tool => 'Hermes verwendet ein Tool';

  @override
  String hermes_is_using_tools(Object count) {
    return 'Hermes verwendet $count Tools';
  }

  @override
  String delegated_tasks_completed(Object count) {
    return '$count delegierte Aufgabe(n) abgeschlossen';
  }

  @override
  String delegated_tasks_active(Object count) {
    return '$count delegierte Aufgabe(n) aktiv';
  }

  @override
  String branch_main(Object label) {
    return '$label · main';
  }

  @override
  String get you_heading => '## Du';

  @override
  String get hermes_heading => '## Hermes';

  @override
  String get action_label => 'Aktion';

  @override
  String get destination_label => 'Ziel';

  @override
  String get markdown_source => 'Quelltext';

  @override
  String get preview_label => 'Vorschau';

  @override
  String get share_action_summarize => 'Zusammenfassen';

  @override
  String get share_action_explain => 'Erklären';

  @override
  String get share_action_research => 'Recherchieren';

  @override
  String get share_action_remember => 'Merken';

  @override
  String get text_size_small => 'Klein';

  @override
  String get text_size_default => 'Standard';

  @override
  String get text_size_large => 'Groß';

  @override
  String get text_size_extra_large => 'Sehr groß';

  @override
  String get text_size_use_system_description =>
      'Genau die Android-Schriftgröße für Barrierefreiheit verwenden.';

  @override
  String text_size_percent_description(Object percent) {
    return '$percent % der Android-Textgröße.';
  }

  @override
  String text_size_label_description(Object description, Object label) {
    return '$label — $description';
  }

  @override
  String files_skipped(Object count) {
    return '$count Datei(en) übersprungen: Limit, Größe, nicht lesbar oder sensibler Dateiname.';
  }

  @override
  String model_scope_applied(Object effort, Object model) {
    return '$model • $effort gelten jetzt nur für diesen Chat.';
  }

  @override
  String get reasoning_minimal => 'Minimal';

  @override
  String get reasoning_low => 'Niedrig';

  @override
  String get reasoning_medium => 'Mittel';

  @override
  String get reasoning_high => 'Hoch';

  @override
  String get reasoning_max => 'Maximal';

  @override
  String get reasoning_ultra => 'Ultra';

  @override
  String get status_running => 'Läuft';

  @override
  String get status_failed => 'Fehlgeschlagen';

  @override
  String get status_done => 'Fertig';

  @override
  String get status_idle => 'Inaktiv';

  @override
  String get upload_status_uploading => 'Wird hochgeladen';

  @override
  String get upload_status_uploaded => 'Hochgeladen';

  @override
  String attachment_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Anhänge',
      one: '$count Anhang',
    );
    return '$_temp0';
  }

  @override
  String get action_create => 'erstellt';

  @override
  String get action_rename => 'umbenannt';

  @override
  String get action_archive => 'archiviert';

  @override
  String get action_restore => 'wiederhergestellt';

  @override
  String get action_delete => 'gelöscht';

  @override
  String get migrate => 'Migrieren';

  @override
  String assigned_chats(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count zugewiesene Chats',
      one: '$count zugewiesener Chat',
    );
    return '$_temp0';
  }

  @override
  String get date_today => 'Heute';

  @override
  String get date_yesterday => 'Gestern';

  @override
  String get date_earlier => 'Früher';

  @override
  String get nav_home => 'Start';

  @override
  String get nav_more => 'Mehr';

  @override
  String get status_completed => 'Abgeschlossen';

  @override
  String get filter_all => 'Alle';

  @override
  String get filter_recent => 'Kürzlich';

  @override
  String connection_address_key(Object address, Object status) {
    return '$address  •  Schlüssel: $status';
  }

  @override
  String model_via_provider(Object model, Object provider) {
    return '$model  \nvia `$provider`';
  }

  @override
  String get deny => 'Ablehnen';

  @override
  String get connect => 'Verbinden';

  @override
  String get appearance => 'Darstellung';

  @override
  String get connection_section => 'Verbindung';

  @override
  String get about => 'Über';

  @override
  String version_label(Object version) {
    return 'Version $version';
  }

  @override
  String get matched => 'Passt';

  @override
  String get search => 'Suchen';

  @override
  String get on => 'An';

  @override
  String get off => 'Aus';

  @override
  String get reasoning_off => 'Aus';

  @override
  String get hermes_response_ready => 'Hermes-Antwort bereit';

  @override
  String get admin_password_needed => 'Administratorpasswort erforderlich';

  @override
  String get hermes_needs_a_sudo_password_for_the_pending_terminal_command =>
      'Hermes benötigt ein sudo-Passwort für den ausstehenden Terminal-Befehl.';

  @override
  String get sudo_password => 'sudo-Passwort';

  @override
  String get secret_needed => 'Secret erforderlich';

  @override
  String get hermes_needs_a_secret_for_the_pending_skill =>
      'Hermes benötigt ein Secret für die ausstehende Fähigkeit.';

  @override
  String get secret_value => 'Secret-Wert';

  @override
  String get attached_file => 'Angehängte Datei';

  @override
  String get pin_chat => 'Chat anheften';

  @override
  String get unpin_chat => 'Chat lösen';

  @override
  String get pinned_chats => 'Angeheftet';

  @override
  String could_not_update_chat_pin(Object error) {
    return 'Anheften des Chats konnte nicht geändert werden: $error';
  }

  @override
  String get could_not_save_chat_spaces =>
      'Chat-Bereiche konnten auf diesem Gerät nicht gespeichert werden';

  @override
  String get chat_density => 'Chat-Dichte';

  @override
  String chat_density_2(Object label) {
    return 'Chat-Dichte: $label';
  }

  @override
  String get chat_density_comfortable => 'Komfortabel';

  @override
  String get chat_density_compact => 'Kompakt';

  @override
  String get chat_density_comfortable_description =>
      'Geräumigere Blasen mit Absenderbeschriftung über jeder Nachricht.';

  @override
  String get chat_density_compact_description =>
      'Engere Blasen ohne Beschriftung, damit mehr Nachrichten auf den Bildschirm passen.';

  @override
  String chat_density_label_description(Object description, Object label) {
    return '$label — $description';
  }

  @override
  String
  get compact_removes_the_you_and_hermes_labels_and_trims_bubble_padding_spacing_and_side_margins =>
      'Kompakt entfernt die Beschriftungen „You“ und „Hermes“ und verringert Blasenabstand, Abstände und Seitenränder.';

  @override
  String get client_certificate_mtls => 'Clientzertifikat (mTLS)';

  @override
  String get client_certificate_mtls_description =>
      'Ein Zertifikat vorlegen, wenn ein HTTPS-Proxy gegenseitiges TLS erfordert.';

  @override
  String get client_certificate_https_only =>
      'Clientzertifikate werden nur für HTTPS-Verbindungen verwendet.';

  @override
  String get choose_certificate => 'Zertifikat auswählen';

  @override
  String get certificate_password => 'Zertifikatspasswort';

  @override
  String get this_certificate_is_password_protected =>
      'Dieses Zertifikat ist passwortgeschützt. Es wird während der Eingabe geöffnet.';

  @override
  String get enter_the_certificate_password_to_finish_loading_it =>
      'Gib das Zertifikatspasswort ein, um das ausgewählte Zertifikat vollständig zu laden.';

  @override
  String get client_certificate_required =>
      'Lade ein Clientzertifikat oder deaktiviere die Clientzertifikat-Option.';

  @override
  String client_certificate_loaded(String label) {
    return 'Geladen: $label';
  }

  @override
  String get remove_certificate => 'Zertifikat entfernen';

  @override
  String get certificate_import_failed =>
      'Dieses Zertifikat konnte nicht geladen werden.';

  @override
  String get background_work => 'Hintergrundaktivität';

  @override
  String get keep_chats_active_in_background =>
      'Chats im Hintergrund aktiv halten';

  @override
  String get background_work_description =>
      'Vom Nutzer gestartete Chats bleiben verbunden, während diese App im Hintergrund ist. Inaktive Verbindungen dürfen getrennt werden. Benötigt mehr Akku und Daten. Das Ausschalten stoppt keine Arbeit auf dem Server.';

  @override
  String get background_work_limits =>
      'Android kann Verbindungen im Doze-Modus dennoch unterbrechen oder den App-Prozess beenden. Benachrichtigungen nach dem Prozessende erfordern die separate Push-Einrichtung. „Beenden erzwingen“ wird nicht unterstützt.';

  @override
  String get background_work_disclosure =>
      'Bei aktivem Hintergrundschutz bleibt eine erforderliche Dienstbenachrichtigung sichtbar, auch wenn optionale Chat-Benachrichtigungen ausgeschaltet sind.';

  @override
  String get battery_optimisation_settings =>
      'Einstellungen zur Akkuoptimierung';

  @override
  String get battery_optimisation_description =>
      'Android-Einstellungen öffnen, um Akkubeschränkungen zu prüfen. Es wird keine Ausnahme automatisch beantragt; Änderungen garantieren keine Zustellung.';

  @override
  String get battery_settings_unavailable =>
      'Die Akkueinstellungen konnten auf diesem Gerät nicht geöffnet werden.';

  @override
  String get background_work_save_failed =>
      'Die Einstellung zur Hintergrundaktivität konnte nicht gespeichert werden.';

  @override
  String get ongoing_chat_channel_name => 'Aktive Chats';

  @override
  String get ongoing_chat_channel_description =>
      'Stille Statusmeldungen für noch offene, vom Nutzer gestartete Chats';

  @override
  String get task_timeline => 'Task timeline';

  @override
  String get task_refresh_history => 'Refresh task history';

  @override
  String get task_live_preview => 'Live preview from parent events';

  @override
  String get task_preview_explanation =>
      'Latest exposed preview only; not a recorded transcript row.';

  @override
  String get task_preview => 'Preview';

  @override
  String get task_recorded_history => 'Recorded task history';

  @override
  String get task_loading_history => 'Loading task history…';

  @override
  String get task_empty_history =>
      'No recorded messages yet. The task may not have flushed its history; this does not mean it produced no work.';

  @override
  String get task_load_older => 'Load older';

  @override
  String get task_default_goal => 'Delegated task';

  @override
  String task_status(Object status) {
    return 'Status: $status';
  }

  @override
  String task_identity(Object id) {
    return 'Task: $id';
  }

  @override
  String task_stored_session(Object id) {
    return 'Stored session: $id';
  }

  @override
  String task_delegation(Object id) {
    return 'Delegation: $id';
  }

  @override
  String get task_read_only_notice =>
      'Read-only · recorded history may appear after the task flushes. Refresh to check again.';

  @override
  String task_row_label(Object id, Object role) {
    return '$role · row $id';
  }

  @override
  String get task_role_assistant => 'Assistant';

  @override
  String get task_role_user => 'User';

  @override
  String get task_role_tool => 'Tool';

  @override
  String task_tool_call(Object name) {
    return 'Tool call · $name';
  }

  @override
  String task_tool_result(Object name) {
    return 'Tool result · $name';
  }

  @override
  String task_call_details(Object arguments, Object id) {
    return 'Call ID: $id\nArguments\n$arguments';
  }

  @override
  String task_result_details(Object id, Object result) {
    return 'Call ID: $id\nResult\n$result';
  }

  @override
  String get task_not_supplied => 'Not supplied';

  @override
  String get task_missing_arguments => 'Arguments not retained by the server.';

  @override
  String get task_image_placeholder => '[image]';

  @override
  String get task_invalid_reference =>
      'Task transcript unavailable: invalid stored session reference.';

  @override
  String get task_auth_required =>
      'Task transcript unavailable: configure Dashboard authentication for this gateway. The API-server key cannot read task reasoning.';

  @override
  String get task_auth_rejected =>
      'Task transcript unavailable: Dashboard authentication was rejected. Check this gateway’s Dashboard settings.';

  @override
  String get task_incompatible_history =>
      'Task transcript unavailable: this Dashboard does not provide compatible bounded raw history for the selected profile.';

  @override
  String get task_identity_unproven =>
      'Task transcript unavailable: the Dashboard could not prove the exact stored session or its compression lineage. No transcript from another session is shown.';

  @override
  String get task_partial_compression =>
      'Partial history: this task continued after compression, but this gateway has not exposed a verifiable newer reference. The final reply may be missing. Automatic refresh is paused; use Refresh to retry.';

  @override
  String get task_partial_ancestors =>
      'Partial history: this gateway omits compression ancestors for this task. Earlier task segments may be missing. Known rows are retained; use Refresh to retry.';

  @override
  String get task_missing_reference =>
      'Task transcript unavailable: this server did not retain its session reference.';

  @override
  String get task_missing_row_identity =>
      'Task transcript unavailable: this server did not supply durable message row identities.';

  @override
  String get task_history_not_ready =>
      'Task history is not available yet (HTTP 404). The task may not have flushed, or this Dashboard may not support task history. Retry to check again.';

  @override
  String get task_refresh_failed =>
      'Could not refresh task history. Check the connection and retry.';

  @override
  String get task_status_interrupted => 'Interrupted';

  @override
  String get task_status_cancelled => 'Cancelled';

  @override
  String get task_status_requested => 'Requested';

  @override
  String get task_status_thinking => 'Thinking';

  @override
  String get task_status_tool => 'Using a tool';

  @override
  String get task_status_pending => 'Pending';

  @override
  String get task_status_dispatched => 'Dispatched';

  @override
  String task_status_unknown(Object status) {
    return 'Unknown status: $status';
  }

  @override
  String task_tasks_finished(Object count) {
    return '$count delegated task(s) finished';
  }

  @override
  String get activity_status_unconfirmed => 'Status unbestätigt';

  @override
  String get activity_recently_updated => 'Kürzlich aktualisiert';

  @override
  String get activity_reconnecting =>
      'Verbindung wird wiederhergestellt — Turn-Status wird geprüft';

  @override
  String get activity_outcome_unknown =>
      'Das Ergebnis des Turns konnte nicht bestätigt werden. Öffne den Chat, um es zu prüfen.';

  @override
  String get activity_chat_updated_detail =>
      'Das Gateway hat Chat-Aktivität aufgezeichnet; der aktuelle Turn-Status ist nicht verfügbar.';

  @override
  String get activity_updated => 'Aktualisiert';

  @override
  String get activity_empty_title => 'Keine aktuellen Aktivitäten';

  @override
  String get activity_empty_detail =>
      'Hier erscheinen in dieser App gestartete Turns und Gateway-Chats, die in den letzten 7 Tagen aktualisiert wurden.';

  @override
  String get activity_read_error =>
      'Die Aktivitätsansicht konnte ihre Turn-Aufzeichnungen oder Gateway-Chats nicht lesen. Prüfe die Verbindung und versuche es erneut.';

  @override
  String get activity_chat_unavailable =>
      'Dieser Chat ist nicht mehr verfügbar oder das Gateway konnte nicht erreicht werden.';

  @override
  String get activity_partial_title => 'Aktivität teilweise geladen';

  @override
  String get activity_partial_detail =>
      'Es wird ein begrenzter Ausschnitt der Gateway-Aktivität angezeigt. Möglicherweise gibt es weitere Chats. Zum Aktualisieren nach unten ziehen.';

  @override
  String get provider_usage => 'Erfasste Nutzung';

  @override
  String get provider_usage_notice =>
      'Hermes-Nutzung der letzten 30 Tage, kein Kontoguthaben oder Modellpreis. Zugangsdaten werden auf dem Hermes-Server eingerichtet; diese App speichert keine Anbieter-API-Schlüssel.';

  @override
  String get provider_usage_failed =>
      'Die erfasste Nutzung konnte nicht geladen werden.';

  @override
  String get provider_usage_empty =>
      'Keine erfasste Nutzung für diesen Anbieter.';

  @override
  String provider_usage_counts(String sessions, String input, String output) {
    return '$sessions Sitzungen · Eingabe: $input · Ausgabe: $output';
  }

  @override
  String provider_usage_costs(String estimated, String actual) {
    return 'Geschätzt: $estimated · Gemeldet: $actual';
  }

  @override
  String get provider_quota_codex => 'OpenAI-Codex-Abonnement';

  @override
  String get provider_quota_claude => 'Claude-Abonnement';

  @override
  String get provider_quota_openai_api => 'Erfasste OpenAI-API-Nutzung';

  @override
  String get provider_quota_notice =>
      'Vom Anbieter gemeldete Nutzungszeiträume des Abonnements, getrennt von der in Hermes erfassten Nutzung und der API-Abrechnung. Konten werden einzeln angezeigt; Modelllimits bedeuten nicht, dass das gesamte Kontingent des Kontos aufgebraucht ist.';

  @override
  String get provider_quota_windows_notice =>
      'Für Codex- und Claude-Abonnements gelten Limits pro Fünf-Stunden-Sitzung und pro Woche. Es werden nur vom Anbieter gemeldete Zeiträume angezeigt; fehlende Limits und Rücksetzzeiten bleiben nicht verfügbar. Wochenlimits können für das Konto oder bestimmte Modelle gelten.';

  @override
  String get provider_quota_five_hour_session => '5-Stunden-Sitzung';

  @override
  String get provider_quota_unavailable =>
      'Abonnementkontingent nicht verfügbar.';

  @override
  String get provider_quota_failed =>
      'Das Abonnementkontingent konnte nicht aktualisiert werden. Beibehaltene Werte stammen aus der vorherigen Abfrage.';

  @override
  String get provider_quota_account => 'Konto';

  @override
  String get provider_quota_unknown => 'unbekannt';

  @override
  String provider_quota_state(String state) {
    return 'Kontostatus: $state';
  }

  @override
  String provider_quota_scope(String scope) {
    return 'Geltungsbereich: $scope';
  }

  @override
  String provider_quota_percent(String used, String remaining) {
    return '$used% verbraucht · $remaining% verbleibend';
  }

  @override
  String provider_quota_reset(String reset) {
    return 'Zurücksetzung: $reset';
  }

  @override
  String get provider_quota_reset_unknown => 'Rücksetzzeit nicht verfügbar.';

  @override
  String get auxiliary_models => 'Hilfsmodelle';

  @override
  String get auxiliary_notice =>
      'Modelle für einzelne Aufgaben auswählen. Benutzerdefinierte Endpunkte müssen auf dem Server verwaltet werden. Auto folgt den Vererbungsregeln der Aufgabe.';

  @override
  String get auxiliary_inherit => 'Auto (vererben)';

  @override
  String get auxiliary_unavailable =>
      'Hilfsmodelleinstellungen sind nicht verfügbar.';

  @override
  String get provider_oauth_title => 'Anbieter-Anmeldung';

  @override
  String get provider_oauth_more_subtitle =>
      'Anbieter-Anmeldung auf deinem Hermes-Host verwalten';

  @override
  String get provider_oauth_settings_subtitle =>
      'Auf deinem Hermes-Host anmelden; Anbieter-Tokens bleiben von diesem Gerät fern';

  @override
  String get provider_oauth_intro =>
      'Melde dich bei deinem Anbieter in einem externen Browser an. Tokens werden nur auf deinem Hermes-Host gespeichert, nicht auf diesem Gerät. Die Anmeldung wählt kein Chat-Modell in dieser App aus.';

  @override
  String get provider_oauth_defaults_notice =>
      'Einige Host-Abläufe, darunter der Austausch eines kostenlosen Nous-Kontos, können Host-Standardwerte ändern. Prüfe nach der Anmeldung deine Host-Einstellungen.';

  @override
  String get provider_oauth_transport_init_failed =>
      'Die ausgewählte sichere Dashboard-Verbindung konnte nicht initialisiert werden. Prüfe ihre TLS-Identität und Verbindungseinstellungen.';

  @override
  String get provider_oauth_https_required =>
      'Die Anbieter-Anmeldung erfordert eine HTTPS-Verbindung zum Hermes-Dashboard.';

  @override
  String get provider_oauth_auth_required =>
      'Richte vor der Anmeldung die Dashboard-Passwortauthentifizierung oder einen vertrauenswürdigen Proxy ein.';

  @override
  String get provider_oauth_catalog_failed =>
      'Die Anbieter-Anmeldung ist auf diesem Host nicht verfügbar. Prüfe die Dashboard-Authentifizierung und aktualisiere den Host, falls er Anbieter-OAuth nicht unterstützt.';

  @override
  String get provider_oauth_expired =>
      'Die Anmeldung ist abgelaufen. Starte erneut.';

  @override
  String get provider_oauth_start_failed =>
      'Die sichere Anbieter-Anmeldung konnte nicht gestartet werden. Versuche es erneut.';

  @override
  String get provider_oauth_denied =>
      'Die Anmeldung wurde abgelehnt. Starte erneut.';

  @override
  String get provider_oauth_cancelled => 'Anmeldung abgebrochen.';

  @override
  String get provider_oauth_host_failed =>
      'Der Host konnte die Anmeldung nicht abschließen. Starte erneut.';

  @override
  String get provider_oauth_poll_failed =>
      'Der Anmeldestatus konnte nicht geprüft werden. Starte erneut.';

  @override
  String provider_oauth_cancellation_unconfirmed(String message) {
    return '$message Der Abbruch konnte nicht bestätigt werden; die Host-Sitzung kann bis zu ihrem Ablauf weiterlaufen.';
  }

  @override
  String get provider_oauth_browser_failed =>
      'Der externe Browser konnte nicht geöffnet werden. Versuche es erneut oder brich die Anmeldung ab.';

  @override
  String get provider_oauth_retry => 'Erneut versuchen';

  @override
  String provider_oauth_complete(String provider) {
    return 'Anmeldung für $provider abschließen';
  }

  @override
  String get provider_oauth_code_instruction =>
      'Gib diesen temporären Code auf der Anbieterseite ein:';

  @override
  String get provider_oauth_waiting =>
      'Warten auf Genehmigung. Diese Sitzung läuft automatisch ab.';

  @override
  String get provider_oauth_open_browser => 'Anbieter im Browser öffnen';

  @override
  String get provider_oauth_cancel => 'Anmeldung abbrechen';

  @override
  String get provider_oauth_signed_out => 'Nicht auf dem Host angemeldet';

  @override
  String get provider_oauth_sign_in_again => 'Erneut anmelden';

  @override
  String get provider_oauth_sign_in => 'Anmelden';

  @override
  String get provider_oauth_cli_required =>
      'Melde dich mit der Anbieter-CLI auf deinem Hermes-Host an. Dieser Host bietet für diesen Anbieter keine Anmeldung in der App.';

  @override
  String get provider_oauth_checking_account =>
      'Genehmigung erhalten. Host-Konto wird geprüft…';

  @override
  String get provider_oauth_verification_unavailable =>
      'Genehmigung erhalten; Kontoverifizierung nicht verfügbar. Öffne Nutzung, um die Kontonutzung zu aktualisieren.';

  @override
  String provider_oauth_verified_account(String email) {
    return 'Auf dem Hermes-Host als $email angemeldet. Öffne Nutzung, um die Kontonutzung zu aktualisieren.';
  }

  @override
  String get provider_oauth_credentials_unverified =>
      'Der Host meldet verfügbare Zugangsdaten; die Kontoidentität ist nicht verifiziert.';

  @override
  String get provider_oauth_account_status_unknown =>
      'Host-Kontostatus nicht verfügbar.';

  @override
  String get app_language => 'App-Sprache';

  @override
  String get app_language_system => 'Wie auf dem Telefon';

  @override
  String get auto_archives_after_72_hours =>
      'Wird nach 72 Stunden automatisch archiviert';

  @override
  String get automation => 'Automatisierung';

  @override
  String get voice_recording_start => 'Sprachnachricht aufnehmen';

  @override
  String get voice_recording_pause => 'Aufnahme pausieren';

  @override
  String get voice_recording_preview => 'Aufnahme abspielen';

  @override
  String get voice_recording_resume => 'Aufnahme fortsetzen';

  @override
  String get voice_recording_send => 'Sprachnachricht senden';

  @override
  String get voice_recording_discard => 'Aufnahme verwerfen';

  @override
  String get voice_recording_processing => 'Sprachnachricht wird vorbereitet…';

  @override
  String voice_recording_elapsed(String time) {
    return 'Aufnahme $time';
  }

  @override
  String voice_recording_draft(String time) {
    return 'Sprachnachricht $time';
  }

  @override
  String get voice_recording_permission =>
      'Erlaube den Mikrofonzugriff, um eine Sprachnachricht aufzunehmen.';

  @override
  String get voice_recording_limit =>
      'Diese Aufnahme hat die Grenze von zehn Minuten erreicht.';

  @override
  String get voice_recording_empty =>
      'Es wurde kein Audio aufgenommen. Versuche es erneut.';

  @override
  String get voice_recording_failed =>
      'Die Aufnahme konnte nicht verarbeitet werden. Gespeicherte Teile wurden aufbewahrt.';

  @override
  String get voice_recording_unconfirmed =>
      'Die Zustellung wurde nicht bestätigt. Deine Aufnahme ist gespeichert. Prüfe den Chat, bevor du es erneut versuchst.';

  @override
  String get voice_recording_submit_failed =>
      'Die Sprachnachricht konnte nicht gesendet werden. Deine Aufnahme ist gespeichert. Prüfe die Verbindung, den Dashboard-Zugriff und die Transkriptionseinstellungen des Servers.';

  @override
  String get voice_recording_pause_playback => 'Wiedergabe pausieren';

  @override
  String get projects_root_title => 'Projektordner auf dem Server';

  @override
  String get projects_root_more_subtitle =>
      'Wo neue Projektordner auf dem Server angelegt werden';

  @override
  String get projects_root_description =>
      'Projekte, die du auf diesem Telefon erstellst, erhalten hier ihren Ordner. Zeige auf den Ordner, den Hermes selbst nutzt, damit Telefon und Server dieselben Projekte sehen.';

  @override
  String get projects_root_label => 'Pfad des Projektverzeichnisses';

  @override
  String projects_root_default_hint(String path) {
    return 'Serverstandard: $path';
  }

  @override
  String get projects_root_locked_title => 'Vom Server festgelegt';

  @override
  String get projects_root_locked_explanation =>
      'Dieser Server beschränkt den Dateizugriff auf ein einziges Wurzelverzeichnis, daher kann der Projektordner nicht in der App geändert werden.';

  @override
  String get projects_root_saved => 'Projektordner gespeichert.';

  @override
  String get projects_root_reset => 'Serverstandard verwenden';

  @override
  String get projects_root_invalid_empty => 'Gib einen Ordnerpfad ein.';

  @override
  String get projects_root_invalid_absolute =>
      'Gib einen absoluten Pfad ein, der mit einem Schrägstrich beginnt.';

  @override
  String get projects_root_invalid_segments =>
      'Entferne Punktsegmente und Steuerzeichen aus dem Pfad.';

  @override
  String get projects_root_unsupported =>
      'Für diese Verbindung nicht unterstützt. Zum Lesen oder Ändern des Projektordners auf dem Server ist eine Desktop-Gateway-Verbindung mit Dashboard-Zugriff erforderlich.';

  @override
  String get projects_root_unavailable =>
      'Der Projektordner des Servers konnte nicht gelesen werden. Prüfe die Dashboard-Verbindung und versuche es erneut.';

  @override
  String get adopt_folder_action => 'Vorhandenen Ordner hinzufügen';

  @override
  String adopt_folder_description(String root) {
    return 'Ordner unter $root, die noch nicht als Projekt registriert sind.';
  }

  @override
  String adopt_folder_registered(String name) {
    return 'Bereits ein Projekt: $name';
  }

  @override
  String get adopt_folder_none =>
      'Jeder Ordner unter diesem Pfad ist bereits ein Projekt.';

  @override
  String get adopt_folder_unsupported =>
      'Diese Verbindung kann keine Serverordner auflisten. Gib stattdessen den absoluten Pfad eines vorhandenen Ordners ein.';

  @override
  String adopt_folder_failed(String error) {
    return 'Serverordner konnten nicht aufgelistet werden: $error';
  }

  @override
  String get adopt_folder_manual_label => 'Pfad eines vorhandenen Ordners';

  @override
  String get adopt_folder_name_label => 'Projektname';

  @override
  String get adopt_folder_add => 'Als Projekt hinzufügen';

  @override
  String adopt_folder_added(String name, String path) {
    return '$name verwendet jetzt $path';
  }

  @override
  String adopt_folder_error(String error) {
    return 'Der Ordner konnte nicht hinzugefügt werden: $error';
  }

  @override
  String adopt_folder_folderless(String name) {
    return '$name wurde erstellt, aber der Ordner wurde nicht verknüpft. Verknüpfe ihn in Hermes auf dem Server.';
  }

  @override
  String get slash_commands => 'Slash commands';

  @override
  String get slash_commands_loading => 'Loading commands…';

  @override
  String get slash_commands_empty => 'No matching commands';

  @override
  String slash_command_info_alias(String alias, String command) {
    return '$alias ist ein Alias für $command';
  }

  @override
  String get slash_command_info_no_description =>
      'Keine Beschreibung verfügbar.';

  @override
  String get slash_command_info_arguments_options =>
      'Erwartet eine Option aus einer festen Auswahl.';

  @override
  String get slash_command_info_arguments_text =>
      'Erwartet Text nach dem Befehl.';

  @override
  String get slash_command_info_arguments_mixed =>
      'Erwartet eine Option oder Text nach dem Befehl.';

  @override
  String get slash_command_output => 'Command output';

  @override
  String get slash_command_no_output => 'The command completed with no output.';

  @override
  String get slash_command_delivery_unknown =>
      'The command was sent but its reply never arrived. It may still be running on the gateway, so your draft was kept. Check the gateway before retrying.';

  @override
  String get slash_command_failed => 'The command could not be run.';

  @override
  String get slash_command_unsupported =>
      'Dieser Befehl ist auf diesem Server nicht verfügbar.';

  @override
  String get slash_sessions_inline =>
      'Öffne die Sitzungsliste, um einen Chat auszuwählen. Dein Entwurf wurde beibehalten.';

  @override
  String get composer_snippets => 'Prompt-Vorlagen';

  @override
  String get composer_snippets_description =>
      'Wähle einen Einstiegsprompt für das Eingabefeld.';

  @override
  String get composer_snippet_review => 'Code-Review';

  @override
  String get composer_snippet_review_body =>
      'Prüfe die aktuelle Änderung auf Regressionen, übersehene Sonderfälle und fehlende Tests.';

  @override
  String get composer_snippet_review_text =>
      'Bitte prüfe dies auf Fehler, Regressionen und fehlende Tests.';

  @override
  String get composer_snippet_plan => 'Implementierungsplan';

  @override
  String get composer_snippet_plan_body =>
      'Skizziere vor Codeänderungen einen Ansatz, damit der Diff fokussiert bleibt.';

  @override
  String get composer_snippet_plan_text =>
      'Bitte erstelle einen knappen Implementierungsplan, bevor du Code änderst.';

  @override
  String get composer_snippet_explain => 'Dies erklären';

  @override
  String get composer_snippet_explain_body =>
      'Erkläre, wie der ausgewählte Code funktioniert, und zeige die wichtigsten Dateien.';

  @override
  String get composer_snippet_explain_text =>
      'Bitte erkläre, wie dies funktioniert, und zeige mir die wichtigsten Dateien.';

  @override
  String get composer_status => 'Status';

  @override
  String get composer_status_context => 'Kontext';

  @override
  String get composer_status_cache => 'Cache-Treffer';

  @override
  String get composer_status_throughput => 'Ausgabetoken/Sek.';

  @override
  String get composer_status_running => 'Läuft';

  @override
  String get composer_status_session => 'Sitzung';

  @override
  String get composer_status_not_reported => 'Nicht gemeldet';

  @override
  String get composer_status_empty =>
      'Es wurde keine Kontextaufschlüsselung gemeldet.';

  @override
  String get composer_status_loading => 'Kontextaufschlüsselung wird geladen';

  @override
  String get composer_status_reset => 'Statusleiste zurücksetzen';

  @override
  String get composer_resume_title => 'Chat fortsetzen';

  @override
  String get composer_resume_search => 'Titel und IDs durchsuchen';

  @override
  String get composer_resume_empty => 'Keine passenden Chats gefunden.';

  @override
  String get composer_resume_unavailable =>
      'Dieser Bereich hat keine Chatliste zum Durchsuchen.';

  @override
  String get composer_failure_retry => 'Erneut versuchen';

  @override
  String composer_failure_retry_at(String time) {
    return 'Erneut versuchen um $time';
  }

  @override
  String get composer_failure_compress => 'Komprimieren';

  @override
  String get composer_failure_switch_model => 'Modell wechseln';

  @override
  String composer_failure_switch_to(String model) {
    return 'Zu $model wechseln';
  }

  @override
  String get composer_failure_new_chat => 'Neuer Chat';

  @override
  String get composer_failure_edit => 'Nachricht bearbeiten';

  @override
  String get composer_failure_details => 'Details';

  @override
  String get composer_failure_hide_details => 'Details ausblenden';

  @override
  String get composer_failure_copy => 'Diagnosedaten kopieren';

  @override
  String get composer_failure_account =>
      'Die andere Lösung erfordert eine Änderung am Gateway-Konto. Das geht nicht in diesem Chat.';

  @override
  String get composer_failure_account_only =>
      'Dies muss am Gateway-Konto behoben werden. Das geht nicht in diesem Chat.';

  @override
  String get composer_failure_confirm_compress =>
      'Diesen Chat komprimieren? Das Gateway wird das Transkript kürzen.';

  @override
  String composer_failure_confirm_model(String model) {
    return 'Diesen Chat auf $model umstellen?';
  }

  @override
  String get composer_drop_attach => 'Zum Anhängen ablegen';

  @override
  String get composer_drop_folder_unsupported =>
      'Ordner können nicht angehängt werden. Lege stattdessen die Dateien ab.';

  @override
  String get composer_drop_reference => 'Zum Referenzieren ablegen';

  @override
  String get composer_reference_copy => 'Referenz kopieren';

  @override
  String get composer_reference_remove => 'Referenz entfernen';

  @override
  String get composer_btw_usage =>
      'Verwendung: /btw <question> — wird aus einer Momentaufnahme dieser Unterhaltung beantwortet, ohne sie zu unterbrechen.';

  @override
  String get composer_background_usage =>
      'Verwendung: /background <prompt> — die Aufgabe läuft separat und das Ergebnis erscheint hier.';

  @override
  String get composer_handoff_usage =>
      'Verwendung: /handoff <platform> — diesen Chat an die angegebene Nachrichtenplattform übergeben.';

  @override
  String get composer_command_needs_session =>
      'Dieser Befehl benötigt einen geöffneten Chat.';

  @override
  String get composer_retry_not_found =>
      'Dieser Durchlauf ist nicht im gespeicherten Verlauf, daher kann „Erneut versuchen“ ihn nicht ersetzen. Es wurde nichts erneut gesendet. Bearbeite die Nachricht und sende sie für einen weiteren Versuch.';

  @override
  String get composer_retry_unavailable =>
      '„Erneut versuchen“ kann bei dieser Verbindung keinen Durchlauf ersetzen, daher wurde nichts erneut gesendet. Bearbeite die Nachricht und sende sie für einen weiteren Versuch.';

  @override
  String get composer_failure_switch_no_retry =>
      'Der Wechsel ändert nur das Modell: Diese Verbindung kann den fehlgeschlagenen Durchgang nicht erneut ausführen. Sende ihn nach dem Wechsel noch einmal.';

  @override
  String get composer_command_needs_gateway_session =>
      'Dieser Chat hat noch keine Gateway-Sitzung. Sende zuerst eine Nachricht und führe den Befehl dann erneut aus.';

  @override
  String get composer_side_question =>
      'btw — Antwort aus einer Momentaufnahme der Unterhaltung';

  @override
  String composer_side_question_id(String id) {
    return 'btw $id — Antwort aus einer Momentaufnahme der Unterhaltung';
  }

  @override
  String get composer_background_started =>
      'Hintergrundaufgabe gestartet. Du kannst weiterchatten. Das Ergebnis erscheint hier.';

  @override
  String composer_background_started_id(String id) {
    return 'Hintergrundaufgabe $id gestartet. Du kannst weiterchatten. Das Ergebnis erscheint hier.';
  }

  @override
  String composer_handoff_requested(String platform) {
    return 'Übergabe an $platform angefordert.';
  }

  @override
  String composer_handoff_done(String platform) {
    return 'Diesen Chat an $platform übergeben.';
  }

  @override
  String get composer_handoff_failed => 'Übergabe fehlgeschlagen.';

  @override
  String get composer_handoff_timeout =>
      'Die Übergabe wurde nicht abgeschlossen. Sie läuft möglicherweise noch auf dem Gateway.';

  @override
  String get composer_compress_done => 'Diesen Chat komprimiert.';

  @override
  String get composer_file_missing => 'Diese Datei ist nicht auf diesem Gerät.';

  @override
  String get composer_attach_busy =>
      'Anhänge können hinzugefügt werden, sobald diese Antwort fertig ist.';

  @override
  String get nextgen_toggle => 'NextGen-Oberfläche';

  @override
  String get nextgen_toggle_subtitle =>
      'Ein neues Design mit einer Anmeldung, Live-Chats und Netzwerksuche. Gateways und Chats werden mit dieser Oberfläche geteilt.';

  @override
  String get nextgen_single_login => 'Mit einer Anmeldung verbinden';

  @override
  String get nextgen_single_login_subtitle =>
      'Füge ein Gateway nur mit seiner Dashboard-Adresse und einer Anmeldung hinzu.';

  @override
  String get ng_allow_this_command => 'Diesen Befehl erlauben?';

  @override
  String ng_hermes_wants_to_run_this_with(Object tool) {
    return 'Hermes möchte das mit $tool ausführen.';
  }

  @override
  String get ng_hermes_wants_to_run_this => 'Hermes möchte das ausführen.';

  @override
  String get ng_hermes_has_a_question => 'Hermes hat eine Frage';

  @override
  String get ng_hermes_has_questions => 'Hermes hat Fragen';

  @override
  String get ng_password_for_sudo => 'Passwort für sudo';

  @override
  String get ng_hermes_needs_your_sudo_password_to =>
      'Hermes braucht dein sudo-Passwort, um diesen Befehl auszuführen.';

  @override
  String get ng_a_secret_value => 'Ein geheimer Wert';

  @override
  String ng_value_for(Object variable) {
    return 'Wert für $variable';
  }

  @override
  String get ng_your_password_manager => 'deinen Passwortmanager';

  @override
  String ng_unlock(Object name) {
    return '$name entsperren';
  }

  @override
  String ng_hermes_needs_unlocked_to_sign_in(Object name) {
    return 'Hermes muss $name entsperren, um dich anzumelden.';
  }

  @override
  String get ng_sign_in_code => 'Anmeldecode';

  @override
  String get ng_enter_the_sign_in_code => 'Gib den Anmeldecode ein.';

  @override
  String ng_enter_the_sign_in_code_for(Object site) {
    return 'Gib den Anmeldecode für $site ein.';
  }

  @override
  String get ng_save_a_login => 'Anmeldedaten speichern?';

  @override
  String ng_save_your_login(Object site) {
    return 'Deine Anmeldedaten für $site speichern?';
  }

  @override
  String ng_couldn_t_load_this_chat(Object error) {
    return 'Chat konnte nicht geladen werden: $error';
  }

  @override
  String ng_live_updates_are_unavailable(Object error) {
    return 'Live-Aktualisierungen sind nicht verfügbar: $error';
  }

  @override
  String ng_preparing(Object name) {
    return '$name wird vorbereitet…';
  }

  @override
  String get ng_the_turn_failed => 'Der Durchlauf ist fehlgeschlagen.';

  @override
  String get ng_turn_changed =>
      'dieser Durchlauf ist bereits beendet oder ein neuerer hat begonnen';

  @override
  String get ng_steer_rejected =>
      'der laufende Durchlauf hat es nicht angenommen';

  @override
  String get ng_turn_not_known_yet =>
      'der laufende Durchlauf ist noch nicht bekannt; versuche es gleich noch einmal';

  @override
  String ng_couldn_t_stop(Object error) {
    return 'Konnte nicht gestoppt werden: $error';
  }

  @override
  String get ng_server_access => 'Serverzugriff';

  @override
  String get ng_sign_in => 'Anmeldung';

  @override
  String get ng_live_connection => 'Live-Verbindung';

  @override
  String get ng_check_that_tailscale_is_on_on =>
      'Prüfe, ob Tailscale auf diesem Smartphone und auf dem Server aktiviert ist.';

  @override
  String get ng_check_the_address_and_that_the =>
      'Prüfe die Adresse und ob der Proxy Anfragen an das Dashboard weiterleitet.';

  @override
  String get ng_use_the_same_network_as_the =>
      'Nutze dasselbe Netzwerk wie der Server und starte das Dashboard mit --host 0.0.0.0, damit andere Geräte darauf zugreifen können.';

  @override
  String get ng_check_the_address_vpn_or_tailscale =>
      'Prüfe die Adresse sowie deine VPN- oder Tailscale-Verbindung.';

  @override
  String get ng_not_checked_yet => 'Noch nicht geprüft.';

  @override
  String get ng_checking => 'Wird geprüft…';

  @override
  String ng_hermes_answers_at(Object version, Object address) {
    return 'Hermes $version ist unter $address erreichbar.';
  }

  @override
  String get ng_something_answered_but_not_a_hermes =>
      'Etwas hat geantwortet, aber es ist kein Hermes-Dashboard.';

  @override
  String ng_something_answered_http_but_not_a(Object status) {
    return 'Etwas hat geantwortet (HTTP $status), aber es ist kein Hermes-Dashboard.';
  }

  @override
  String get ng_use_the_dashboard_s_address_and =>
      'Verwende Adresse und Port des Dashboards (standardmäßig 9119), nicht die des API-Servers.';

  @override
  String get ng_cloudflare_access_turned_the_service_token =>
      'Cloudflare Access hat das Service-Token abgelehnt.';

  @override
  String get ng_cloudflare_access_is_in_front_of =>
      'Cloudflare Access ist dieser Adresse vorgeschaltet.';

  @override
  String get ng_check_the_service_token_and_its =>
      'Prüfe das Service-Token und seine Service-Auth-Richtlinie.';

  @override
  String get ng_add_a_cloudflare_access_service_token =>
      'Füge für diese Adresse ein Cloudflare Access Service-Token hinzu.';

  @override
  String get ng_the_server_asks_for_a_client =>
      'Der Server verlangt ein Client-Zertifikat.';

  @override
  String get ng_pick_the_client_certificate_for_this =>
      'Wähle das Client-Zertifikat für dieses Gateway aus und teste es erneut.';

  @override
  String get ng_needs_server_access_first =>
      'Zuerst ist Serverzugriff erforderlich.';

  @override
  String get ng_needs_a_sign_in_first => 'Zuerst musst du dich anmelden.';

  @override
  String ng_signed_in_as(Object name) {
    return 'Angemeldet als $name.';
  }

  @override
  String get ng_this_dashboard_doesn_t_need_a =>
      'Für dieses Dashboard ist keine Anmeldung erforderlich.';

  @override
  String get ng_the_saved_sign_in_has_expired =>
      'Die gespeicherte Anmeldung ist abgelaufen.';

  @override
  String get ng_sign_in_again => 'Melde dich erneut an.';

  @override
  String get ng_too_many_sign_in_attempts => 'Zu viele Anmeldeversuche.';

  @override
  String get ng_wait_a_minute_then_check_again =>
      'Warte eine Minute und prüfe es dann erneut.';

  @override
  String ng_the_gateway_answered(Object message) {
    return 'Das Gateway hat geantwortet: $message.';
  }

  @override
  String get ng_sign_in_again_or_update_hermes =>
      'Melde dich erneut an oder aktualisiere Hermes.';

  @override
  String ng_couldn_t_check_the_sign_in(Object error) {
    return 'Anmeldung konnte nicht geprüft werden: $error';
  }

  @override
  String ng_the_gateway_wouldn_t_issue_a(Object message) {
    return 'Das Gateway hat kein Chat-Ticket ausgestellt ($message).';
  }

  @override
  String get ng_the_chat_connection_opened_and_the =>
      'Die Chat-Verbindung wurde geöffnet und das Gateway ist bereit.';

  @override
  String get ng_the_gateway_never_said_it_was =>
      'Das Gateway hat nie bestätigt, dass es bereit ist.';

  @override
  String get ng_check_that_the_agent_is_running =>
      'Prüfe, ob der Agent auf dem Server läuft.';

  @override
  String get ng_the_gateway_refused_the_chat_connection =>
      'Das Gateway hat die Chat-Verbindung abgelehnt (HTTP 403).';

  @override
  String get ng_this_dashboard_has_no_chat_endpoint =>
      'Dieses Dashboard hat keinen Chat-Endpunkt (/api/ws).';

  @override
  String ng_the_chat_connection_failed(Object detail) {
    return 'Die Chat-Verbindung ist fehlgeschlagen: $detail';
  }

  @override
  String get ng_use_the_exact_address_the_dashboard =>
      'Verwende genau die Adresse, für die das Dashboard konfiguriert ist.';

  @override
  String get ng_update_hermes => 'Aktualisiere Hermes.';

  @override
  String get ng_make_sure_the_proxy_allows_websocket =>
      'Stelle sicher, dass der Proxy WebSocket-Upgrades auf /api/ws zulässt.';

  @override
  String get ng_offline => 'Offline';

  @override
  String get ng_connecting => 'Verbindung wird hergestellt…';

  @override
  String get ng_connected => 'Verbunden';

  @override
  String get ng_reconnecting => 'Verbindung wird wiederhergestellt…';

  @override
  String get ng_signed_out => 'Abgemeldet';

  @override
  String get ng_connection_failed => 'Verbindung fehlgeschlagen';

  @override
  String get ng_rate_limited_by_gateway => 'Vom Gateway gedrosselt';

  @override
  String ng_couldn_t_open_the_chat_connection(Object message) {
    return 'Chatverbindung konnte nicht geöffnet werden: $message';
  }

  @override
  String get ng_the_gateway_returned_no_websocket_ticket =>
      'Das Gateway hat kein WebSocket-Ticket zurückgegeben.';

  @override
  String get ng_connection_lost => 'Verbindung unterbrochen';

  @override
  String get ng_this_dashboard_has_no_chat_endpoint_2 =>
      'Dieses Dashboard hat keinen Chat-Endpunkt (/api/ws). Aktualisiere Hermes.';

  @override
  String get ng_the_gateway_refused_the_chat_connection_2 =>
      'Das Gateway hat die Chatverbindung abgelehnt. Prüfe, ob die Adresse mit dem für das Dashboard konfigurierten Host übereinstimmt und ob der eingebettete Chat aktiviert ist.';

  @override
  String ng_the_gateway_refused(Object method) {
    return 'Das Gateway hat $method abgelehnt.';
  }

  @override
  String ng_couldn_t_read_your_saved_gateways(Object error) {
    return 'Deine gespeicherten Gateways konnten nicht gelesen werden: $error';
  }

  @override
  String get ng_applies_to_new_chats => 'Gilt für neue Chats';

  @override
  String ng_couldn_t_change(Object label, Object error) {
    return '$label konnte nicht geändert werden: $error';
  }

  @override
  String get ng_capabilities => 'Funktionen';

  @override
  String get ng_skills => 'Skills';

  @override
  String get ng_toolsets => 'Werkzeugsammlungen';

  @override
  String get ng_search => 'Suchen';

  @override
  String get ng_couldn_t_load => 'Konnte nicht geladen werden';

  @override
  String get ng_try_again => 'Erneut versuchen';

  @override
  String get ng_no_skills => 'Keine Skills';

  @override
  String get ng_no_toolsets => 'Keine Werkzeugsammlungen';

  @override
  String get ng_no_mcp_servers => 'Keine MCP-Server';

  @override
  String get ng_that_file_is_too_large_to =>
      'Diese Datei ist zu groß, um ein Zertifikat zu sein.';

  @override
  String ng_the_certificate_couldn_t_be_imported(Object error) {
    return 'Das Zertifikat konnte nicht importiert werden: $error';
  }

  @override
  String get ng_now_pick_its_private_key =>
      'Wähle jetzt den zugehörigen privaten Schlüssel aus.';

  @override
  String get ng_now_pick_its_certificate =>
      'Wähle jetzt das zugehörige Zertifikat aus.';

  @override
  String get ng_that_file_isn_t_a_certificate =>
      'Diese Datei ist weder ein Zertifikat noch ein privater Schlüssel.';

  @override
  String get ng_if_a_proxy_in_front_of =>
      'Wenn ein Proxy vor dieser Adresse ein Client-Zertifikat verlangt, wähle es hier aus. Dann wird es beim Test, bei der Anmeldung und im Chat mitgesendet.';

  @override
  String get ng_client_certificates_are_only_used_with =>
      'Client-Zertifikate werden nur bei https://-Adressen verwendet.';

  @override
  String get ng_remove => 'Entfernen';

  @override
  String get ng_certificate_password => 'Zertifikatspasswort';

  @override
  String get ng_importing => 'Wird importiert…';

  @override
  String get ng_pick_certificate => 'Zertifikat auswählen';

  @override
  String get ng_pick_a_different_certificate => 'Anderes Zertifikat auswählen';

  @override
  String get ng_accepts_p12_pfx_or_pem_certificate =>
      'Unterstützt .p12/.pfx oder PEM-Zertifikat- und Schlüsseldateien. Der Schlüssel bleibt im privaten Speicher dieser App.';

  @override
  String get ng_photos => 'Fotos';

  @override
  String get ng_camera => 'Kamera';

  @override
  String get ng_files => 'Dateien';

  @override
  String ng_you_can_attach_up_to_files(Object count) {
    return 'Du kannst bis zu $count Dateien anhängen.';
  }

  @override
  String ng_couldn_t_read(Object name) {
    return '$name konnte nicht gelesen werden.';
  }

  @override
  String ng_couldn_t_prepare_that_file(Object error) {
    return 'Diese Datei konnte nicht vorbereitet werden: $error';
  }

  @override
  String get ng_hermes_is_still_working => 'Hermes arbeitet noch';

  @override
  String get ng_steer => 'Steuern';

  @override
  String get ng_adds_this_to_the_running_turn =>
      'Wird beim nächsten Schritt zum laufenden Durchlauf hinzugefügt';

  @override
  String get ng_queue => 'Warteschlange';

  @override
  String get ng_sends_it_when_the_turn_finishes =>
      'Wird gesendet, wenn der Durchlauf abgeschlossen ist';

  @override
  String get ng_stop_and_send => 'Stoppen und senden';

  @override
  String get ng_stops_the_turn_then_sends_this =>
      'Stoppt den Durchlauf und sendet diese Nachricht anschließend';

  @override
  String ng_dictation_stopped(Object message) {
    return 'Diktat beendet: $message';
  }

  @override
  String get ng_speech_recognition_isn_t_available =>
      'Spracherkennung ist nicht verfügbar.';

  @override
  String get ng_working => 'In Arbeit';

  @override
  String get ng_ready => 'Bereit';

  @override
  String get ng_chats => 'Chats';

  @override
  String get ng_new_chat => 'Neuer Chat';

  @override
  String get ng_usage => 'Nutzung';

  @override
  String get ng_rename_chat => 'Chat umbenennen';

  @override
  String ng_couldn_t_rename(Object error) {
    return 'Umbenennen fehlgeschlagen: $error';
  }

  @override
  String get ng_this_chat => 'Dieser Chat';

  @override
  String get ng_input_tokens => 'Input-Tokens';

  @override
  String get ng_output_tokens => 'Output-Tokens';

  @override
  String get ng_reasoning_tokens => 'Reasoning-Tokens';

  @override
  String get ng_cache_reads => 'Cache-Lesezugriffe';

  @override
  String get ng_api_calls => 'API-Aufrufe';

  @override
  String get ng_cost => 'Kosten';

  @override
  String get ng_context => 'Kontext';

  @override
  String get ng_your_sign_in_expired => 'Deine Anmeldung ist abgelaufen.';

  @override
  String get ng_sign_in_2 => 'Anmelden';

  @override
  String get ng_retry => 'Erneut versuchen';

  @override
  String get ng_project_home => 'Home';

  @override
  String get ng_choose_project => 'Projekt auswählen';

  @override
  String ng_project_cwd_fallback(String path) {
    return 'Der Projektordner war nicht verfügbar. Dieser Chat läuft daher in $path.';
  }

  @override
  String get ng_project_create_uncertain =>
      'Das Gateway hat diesen Chat möglicherweise erstellt, aber nicht bestätigt. Prüfe die Chats, bevor du einen weiteren startest. Diese Anfrage wird nicht automatisch wiederholt.';

  @override
  String get ng_what_should_we_work_on => 'Woran sollen wir arbeiten?';

  @override
  String get ng_ask_hermes_anything_it_can_run =>
      'Frag Hermes alles. Es kann Tools ausführen, im Web suchen und mit deinen Dateien auf dem Server arbeiten.';

  @override
  String ng_working_2(Object frame) {
    return 'Wird bearbeitet · $frame';
  }

  @override
  String get ng_default_model => 'Standardmodell';

  @override
  String get ng_listening => 'Höre zu…';

  @override
  String get ng_steer_or_queue_a_message =>
      'Nachricht anpassen oder in die Warteschlange stellen';

  @override
  String get ng_message_hermes => 'Nachricht an Hermes';

  @override
  String get ng_attach => 'Anhängen';

  @override
  String get ng_stop_dictation => 'Diktat beenden';

  @override
  String get ng_dictate => 'Diktieren';

  @override
  String get ng_stop => 'Stopp';

  @override
  String get ng_send => 'Senden';

  @override
  String ng_slash_command_alias(String alias, String command) {
    return '$alias ist ein Alias für $command';
  }

  @override
  String get ng_slash_command_no_description => 'Keine Beschreibung verfügbar.';

  @override
  String get ng_slash_command_arguments_options =>
      'Erwartet eine Option aus einer festen Auswahl.';

  @override
  String get ng_slash_command_arguments_text =>
      'Erwartet Text nach dem Befehl.';

  @override
  String get ng_slash_command_arguments_mixed =>
      'Erwartet eine Option oder Text nach dem Befehl.';

  @override
  String get ng_slash_command_sent_as_message =>
      'NextGen sendet dies als normale Nachricht an Hermes; der Befehl selbst wird nicht ausgeführt.';

  @override
  String get ng_slash_command_output => 'Befehlsausgabe';

  @override
  String get ng_slash_command_running => 'Befehl wird ausgeführt…';

  @override
  String get ng_slash_command_done => 'Fertig.';

  @override
  String ng_slash_command_failed(Object error) {
    return 'Befehl konnte nicht ausgeführt werden: $error';
  }

  @override
  String get ng_slash_command_refused =>
      'Hermes kann diesen Befehl hier nicht ausführen.';

  @override
  String get ng_slash_command_delivery_unknown =>
      'Der Befehl wurde gesendet, aber es kam keine Antwort. Er läuft möglicherweise noch auf dem Gateway, daher wurde er nicht erneut gesendet und dein Entwurf wurde behalten.';

  @override
  String get ng_slash_command_nothing_running => 'Es läuft gerade nichts.';

  @override
  String get ng_steered => 'Angepasst';

  @override
  String get ng_copied => 'Kopiert';

  @override
  String ng_not_sent(Object reason) {
    return 'Nicht gesendet: $reason';
  }

  @override
  String get ng_thinking => 'Denkt nach…';

  @override
  String get ng_thought => 'Gedanke';

  @override
  String ng_used(Object name) {
    return '$name verwendet';
  }

  @override
  String ng_used_tools(Object count) {
    return '$count Tools verwendet';
  }

  @override
  String get ng_copy => 'Kopieren';

  @override
  String get ng_read_aloud => 'Vorlesen';

  @override
  String get ng_the_gateway_connection_dropped_try_again =>
      'Die Verbindung zum Gateway wurde unterbrochen. Versuch es erneut.';

  @override
  String get ng_allow_once => 'Einmal erlauben';

  @override
  String get ng_allow_until_sandbox_off => 'Bis die Sandbox ausgeschaltet wird';

  @override
  String get ng_folder_access => 'Ordnerzugriff';

  @override
  String get ng_folder_access_unspecified =>
      'Das Gateway hat nicht angegeben, ob der Zugriff schreibgeschützt ist oder Lesen und Schreiben erlaubt.';

  @override
  String get ng_folder_read_only => 'Schreibgeschützt';

  @override
  String get ng_folder_read_write => 'Lesen und Schreiben';

  @override
  String get ng_website_access => 'Websitezugriff';

  @override
  String get ng_allow_for_this_chat => 'Für diesen Chat erlauben';

  @override
  String get ng_always_allow => 'Immer erlauben';

  @override
  String get ng_deny => 'Ablehnen';

  @override
  String get ng_your_answer => 'Deine Antwort';

  @override
  String get ng_or_type_an_answer => 'Oder gib eine Antwort ein';

  @override
  String get ng_skip => 'Überspringen';

  @override
  String get ng_answer => 'Antworten';

  @override
  String get ng_cancel => 'Abbrechen';

  @override
  String get ng_username_or_email => 'Benutzername oder E-Mail-Adresse';

  @override
  String get ng_password => 'Passwort';

  @override
  String get ng_not_now => 'Nicht jetzt';

  @override
  String get ng_save => 'Speichern';

  @override
  String get ng_enter_both_the_client_id_and =>
      'Gib entweder sowohl die Client-ID als auch das Client Secret ein oder lass beide leer.';

  @override
  String get ng_enter_your_username_and_password =>
      'Gib deinen Benutzernamen und dein Passwort ein.';

  @override
  String ng_couldn_t_save_the_sign_in(Object error) {
    return 'Anmeldedaten konnten nicht gespeichert werden: $error';
  }

  @override
  String get ng_wrong_username_or_password =>
      'Benutzername oder Passwort ist falsch.';

  @override
  String get ng_too_many_attempts_wait_a_moment =>
      'Zu viele Versuche. Warte kurz und versuch es erneut.';

  @override
  String get ng_welcome_to_hermes => 'Willkommen bei Ares';

  @override
  String get ng_add_a_gateway => 'Gateway hinzufügen';

  @override
  String get ng_connect_to_your_hermes_agent_dashboard =>
      'Verbinde dich mit deinem Hermes Agent-Dashboard. Eine Adresse und eine Anmeldung reichen für deine Chats, Tools und Einstellungen. Es wird nichts gesendet, bis du dich anmeldest.';

  @override
  String get ng_connect_to_another_hermes_agent_dashboard =>
      'Verbinde dich mit einem weiteren Hermes Agent-Dashboard. Bei den gespeicherten Dashboards bleibst du angemeldet.';

  @override
  String get ng_dashboard_address => 'Dashboard-Adresse';

  @override
  String get ng_testing => 'Wird getestet…';

  @override
  String get ng_test => 'Testen';

  @override
  String get ng_where_your_hermes_dashboard_runs_lan =>
      'Die Adresse deines Hermes-Dashboards: LAN, Tailscale oder HTTPS.';

  @override
  String get ng_find_on_my_network => 'In meinem Netzwerk suchen';

  @override
  String get ng_which_address_do_i_use => 'Welche Adresse soll ich verwenden?';

  @override
  String get ng_behind_cloudflare_access => 'Hinter Cloudflare Access?';

  @override
  String get ng_need_a_client_certificate =>
      'Brauchst du ein Client-Zertifikat?';

  @override
  String get ng_this_address_isn_t_private_and =>
      'Diese Adresse ist nicht privat und verwendet kein https://. Dein Passwort und deine Chats würden daher unverschlüsselt über das Internet übertragen. Verwende stattdessen https://, Tailscale oder dein eigenes Netzwerk.';

  @override
  String get ng_continue_to_sign_in => 'Weiter zur Anmeldung';

  @override
  String get ng_use_the_classic_interface_instead =>
      'Stattdessen die klassische Oberfläche verwenden';

  @override
  String get ng_if_cloudflare_access_protects_this_address =>
      'Wenn Cloudflare Access diese Adresse schützt, erstelle in Cloudflare Zero Trust (Access, Service credentials) ein Service Token und füge dafür eine Service Auth-Richtlinie zur Access-Anwendung hinzu.';

  @override
  String get ng_a_service_token_is_saved_for =>
      'Für diese Adresse ist ein Service Token gespeichert';

  @override
  String get ng_forget => 'Entfernen';

  @override
  String get ng_client_id => 'Client-ID';

  @override
  String get ng_client_secret => 'Client Secret';

  @override
  String get ng_stored_encrypted_on_this_phone_and =>
      'Wird verschlüsselt auf diesem Smartphone gespeichert und nur an diese Adresse gesendet.';

  @override
  String get ng_hermes_is_reachable => 'Hermes ist erreichbar';

  @override
  String ng_hermes_is_reachable_2(Object version) {
    return 'Hermes $version ist erreichbar';
  }

  @override
  String get ng_sign_in_is_tested_next_then =>
      'Als Nächstes wird die Anmeldung getestet, dann der Chat';

  @override
  String get ng_agent_gateway => 'Agent-Gateway';

  @override
  String get ng_running => 'Läuft';

  @override
  String get ng_stopped => 'Gestoppt';

  @override
  String get ng_username_password => 'Benutzername und Passwort';

  @override
  String get ng_browser => 'Browser';

  @override
  String get ng_in_the_browser_sso => 'Im Browser (SSO)';

  @override
  String get ng_profiles => 'Profile';

  @override
  String get ng_this_dashboard_offers_neither_a_username =>
      'Dieses Dashboard bietet weder eine Anmeldung mit Benutzername und Passwort noch eine Browser-Anmeldung. Aktualisiere Hermes oder richte die Anmeldung mit Benutzername und Passwort auf dem Server ein.';

  @override
  String get ng_the_auth_gate_is_off_on =>
      'Die Anmeldesperre ist auf diesem Dashboard deaktiviert. Jeder, der darauf zugreifen kann, kann deinen Agenten verwenden.';

  @override
  String get ng_couldn_t_reach_the_dashboard => 'Dashboard nicht erreichbar';

  @override
  String ng_check_the_address_and_port_9119(Object reason) {
    return '$reason\n\nÜberprüfe die Adresse und den Port (standardmäßig 9119). Falls das Dashboard noch nicht läuft, führe diesen Befehl auf dem Server aus:\nhermes dashboard --host 0.0.0.0';
  }

  @override
  String get ng_that_isn_t_a_hermes_dashboard =>
      'Das ist kein Hermes-Dashboard';

  @override
  String get ng_something_answered_but_not_a_hermes_2 =>
      'Es hat sich etwas gemeldet, aber es ist kein Hermes-Dashboard. Verwende die Adresse des Dashboards, nicht die des API-Servers (Port 8642).';

  @override
  String ng_something_answered_http_but_not_a_2(Object status) {
    return 'Es hat sich etwas gemeldet (HTTP $status), aber es ist kein Hermes-Dashboard. Verwende die Adresse des Dashboards, nicht die des API-Servers (Port 8642).';
  }

  @override
  String get ng_cloudflare_access_stopped_the_request =>
      'Cloudflare Access hat die Anfrage blockiert';

  @override
  String ng_cloudflare_access_turned_down_the_service(Object status) {
    return 'Cloudflare Access hat das Service-Token abgelehnt (HTTP $status). Überprüfe Client-ID und Secret sowie die Service-Auth-Richtlinie.';
  }

  @override
  String get ng_add_a_cloudflare_access_service_token_2 =>
      'Füge unten ein Cloudflare-Access-Service-Token hinzu und teste es erneut.';

  @override
  String get ng_a_client_certificate_is_needed =>
      'Ein Clientzertifikat ist erforderlich';

  @override
  String get ng_this_server_asks_for_a_client =>
      'Dieser Server verlangt ein Clientzertifikat, bevor er kommuniziert. Wähle unten das bereitgestellte Zertifikat aus und teste es erneut.';

  @override
  String get ng_this_dashboard_doesn_t_ask_for =>
      'Dieses Dashboard verlangt keine Anmeldung.';

  @override
  String ng_use_the_dashboard_username_and_password(Object address) {
    return 'Verwende den auf $address eingerichteten Dashboard-Benutzernamen und das Passwort oder melde dich in deinem Browser an.';
  }

  @override
  String ng_use_the_dashboard_username_and_password_2(Object address) {
    return 'Verwende den auf $address eingerichteten Dashboard-Benutzernamen und das Passwort.';
  }

  @override
  String ng_sign_in_to_in_your_browser(Object address) {
    return 'Melde dich in deinem Browser unter $address mit dem Konto an, das für das Dashboard verwendet wird.';
  }

  @override
  String ng_gateway(Object address) {
    return 'Gateway $address';
  }

  @override
  String get ng_profile => 'Profil';

  @override
  String get ng_server_default => 'Serverstandard';

  @override
  String get ng_continue => 'Weiter';

  @override
  String get ng_username => 'Benutzername';

  @override
  String get ng_signing_in => 'Anmeldung läuft…';

  @override
  String get ng_waiting_for_the_browser => 'Warte auf den Browser…';

  @override
  String get ng_sign_in_with_browser => 'Mit dem Browser anmelden';

  @override
  String get ng_finish_signing_in_on_the_page =>
      'Schließe die Anmeldung auf der geöffneten Seite ab. Hermes kehrt automatisch zurück, sobald du fertig bist.';

  @override
  String get ng_use_a_different_gateway => 'Anderes Gateway verwenden';

  @override
  String get ng_same_wi_fi_or_local_network =>
      'Gleiches WLAN oder lokales Netzwerk';

  @override
  String get ng_use_the_server_s_local_address =>
      'Verwende die lokale Adresse und den Port des Servers, zum Beispiel 192.168.1.20:9119. Starte das Dashboard mit --host 0.0.0.0, damit andere Geräte darauf zugreifen können.';

  @override
  String get ng_tailscale => 'Tailscale';

  @override
  String get ng_turn_on_tailscale_on_this_phone =>
      'Aktiviere Tailscale auf diesem Smartphone und verwende die Tailscale-Adresse des Servers, zum Beispiel 100.64.0.1:9119 oder seinen .ts.net-Namen. Funktioniert auch unterwegs.';

  @override
  String get ng_use_your_https_address_when_the =>
      'Verwende deine https://-Adresse, wenn das Dashboard hinter einem Proxy mit Zertifikat liegt. Der Proxy muss außerdem WebSocket-Upgrades auf /api/ws weiterleiten.';

  @override
  String get ng_start_the_dashboard_on_the_server =>
      'Starte das Dashboard auf dem Server:';

  @override
  String get ng_enter_a_port_from_1_to =>
      'Gib einen Port zwischen 1 und 65535 ein.';

  @override
  String get ng_looks_for_hermes_dashboards_on_port =>
      'Sucht in diesem WLAN nach Hermes-Dashboards auf Port 9119 und prüft Computer, die du bereits gespeichert hast.';

  @override
  String ng_looks_for_hermes_dashboards_on_ports(Object port) {
    return 'Sucht in diesem WLAN nach Hermes-Dashboards auf den Ports 9119 und $port und prüft Computer, die du bereits gespeichert hast.';
  }

  @override
  String get ng_other_port_optional => 'Weiterer Port (optional)';

  @override
  String get ng_no_dashboards_answered_start_one_with =>
      'Keine Dashboards gefunden. Starte eines mit hermes dashboard --host 0.0.0.0 oder gib seine Adresse ein.';

  @override
  String get ng_using_tailscale_or_a_vpn_those =>
      'Verwendest du Tailscale oder ein VPN? Diese Netzwerke können nicht durchsucht werden. Gib stattdessen die 100.x-Adresse des Computers oder seinen .ts.net-Namen ein.';

  @override
  String get ng_search_again => 'Erneut suchen';

  @override
  String get ng_insights => 'Einblicke';

  @override
  String get ng_couldn_t_load_insights =>
      'Einblicke konnten nicht geladen werden';

  @override
  String get ng_sessions => 'Sitzungen';

  @override
  String get ng_tokens => 'Tokens';

  @override
  String get ng_est_cost => 'Geschätzte Kosten';

  @override
  String get ng_daily_tokens => 'Tokens pro Tag';

  @override
  String get ng_models => 'Modelle';

  @override
  String get ng_tools => 'Tools';

  @override
  String get ng_hermes_is_waiting_for_you => 'Hermes wartet auf dich.';

  @override
  String get ng_hermes_replied => 'Hermes hat geantwortet';

  @override
  String get ng_the_turn_finished => 'Der Durchlauf ist abgeschlossen.';

  @override
  String get ng_off => 'Aus';

  @override
  String get ng_minimal => 'Minimal';

  @override
  String get ng_low => 'Niedrig';

  @override
  String get ng_medium => 'Mittel';

  @override
  String get ng_high => 'Hoch';

  @override
  String get ng_extra_high => 'Sehr hoch';

  @override
  String get ng_max => 'Maximal';

  @override
  String get ng_ultra => 'Ultra';

  @override
  String get ng_default => 'Standard';

  @override
  String ng_couldn_t_switch_model(Object error) {
    return 'Modell konnte nicht gewechselt werden: $error';
  }

  @override
  String get ng_model => 'Modell';

  @override
  String get ng_thinking_2 => 'Denken';

  @override
  String get ng_search_models => 'Modelle suchen';

  @override
  String get ng_no_models_match => 'Keine Modelle entsprechen diesen Filtern.';

  @override
  String get privacy_policy => 'Datenschutzerklärung';

  @override
  String get report_ai_output => 'KI-Ausgabe melden';

  @override
  String ng_couldn_t_load_models(Object error) {
    return 'Modelle konnten nicht geladen werden: $error';
  }

  @override
  String get ng_no_providers_are_set_up_on =>
      'Für dieses Gateway sind noch keine Anbieter eingerichtet.';

  @override
  String get ng_starred => 'Markiert';

  @override
  String get ng_recent => 'Zuletzt verwendet';

  @override
  String get ng_more => 'Mehr';

  @override
  String get ng_archived_chats => 'Archivierte Chats';

  @override
  String get ng_projects => 'Projekte';

  @override
  String get ng_chats_grouped_by_project_and_workspace =>
      'Chats nach Projekt und Arbeitsbereich gruppiert';

  @override
  String get ng_agent => 'Agent';

  @override
  String get ng_memory => 'Erinnerungen';

  @override
  String get ng_what_hermes_remembers_about_you => 'Was Hermes über dich weiß';

  @override
  String get ng_skills_library => 'Skill-Bibliothek';

  @override
  String get ng_browse_and_read_installed_skills =>
      'Installierte Skills durchsuchen und lesen';

  @override
  String get ng_cron_editor => 'Cron-Editor';

  @override
  String get ng_edit_schedules_prompts_and_delivery =>
      'Zeitpläne, Prompts und Zustellung bearbeiten';

  @override
  String get ng_config_file => 'Konfigurationsdatei';

  @override
  String get ng_edit_config_yaml_on_the_gateway =>
      'config.yaml auf dem Gateway bearbeiten';

  @override
  String get ng_models_and_providers => 'Modelle und Anbieter';

  @override
  String get ng_model_management => 'Modellverwaltung';

  @override
  String get ng_default_fallback_and_auxiliary_models =>
      'Standard-, Fallback- und Zusatzmodelle';

  @override
  String get ng_provider_sign_in => 'Bei Anbietern anmelden';

  @override
  String get ng_connect_provider_accounts_with_oauth =>
      'Anbieterkonten mit OAuth verbinden';

  @override
  String get ng_nous_portal => 'Nous Portal';

  @override
  String get ng_subscription_credits_and_usage => 'Abo, Guthaben und Nutzung';

  @override
  String get ng_interface => 'Oberfläche';

  @override
  String get ng_switch_to_the_classic_interface =>
      'Zur klassischen Oberfläche wechseln';

  @override
  String get ng_turns_nextgen_off_you_can_turn =>
      'Deaktiviert NextGen. Du kannst es in den Einstellungen wieder aktivieren.';

  @override
  String get ng_restored => 'Wiederhergestellt';

  @override
  String get ng_archived => 'Archiviert';

  @override
  String get ng_couldn_t_load_archived_chats =>
      'Archivierte Chats konnten nicht geladen werden';

  @override
  String get ng_nothing_archived => 'Keine archivierten Chats';

  @override
  String get ng_restore => 'Wiederherstellen';

  @override
  String get ng_saved_new_chats_use_it =>
      'Gespeichert. Für neue Chats wird diese Einstellung verwendet.';

  @override
  String ng_couldn_t_save(Object error) {
    return 'Speichern fehlgeschlagen: $error';
  }

  @override
  String get ng_saving => 'Wird gespeichert…';

  @override
  String ng_today(Object time) {
    return 'Heute $time';
  }

  @override
  String get ng_mon => 'Mo';

  @override
  String get ng_tue => 'Di';

  @override
  String get ng_wed => 'Mi';

  @override
  String get ng_thu => 'Do';

  @override
  String get ng_fri => 'Fr';

  @override
  String get ng_sat => 'Sa';

  @override
  String get ng_sun => 'So';

  @override
  String get ng_scheduled => 'Geplant';

  @override
  String get ng_new_job => 'Neuer Auftrag';

  @override
  String get ng_couldn_t_load_scheduled_jobs =>
      'Geplante Aufträge konnten nicht geladen werden';

  @override
  String get ng_nothing_scheduled => 'Nichts geplant';

  @override
  String get ng_ask_hermes_to_do_something_on =>
      'Bitte Hermes, etwas regelmäßig zu erledigen, oder füge hier einen Auftrag hinzu.';

  @override
  String get ng_active => 'Aktiv';

  @override
  String get ng_paused => 'Pausiert';

  @override
  String ng_next(Object when) {
    return 'Als Nächstes: $when';
  }

  @override
  String ng_last(Object when) {
    return 'Zuletzt: $when';
  }

  @override
  String ng_last_2(Object when, Object result) {
    return 'Zuletzt: $when · $result';
  }

  @override
  String ng_job(Object id) {
    return 'Auftrag $id';
  }

  @override
  String get ng_delete => 'Löschen';

  @override
  String get ng_delete_this_job => 'Diesen Auftrag löschen?';

  @override
  String get ng_it_stops_running_past_runs_stay =>
      'Der Auftrag wird nicht mehr ausgeführt. Frühere Ausführungen bleiben in deinen Chats.';

  @override
  String ng_next_run(Object when) {
    return 'Nächste Ausführung $when';
  }

  @override
  String ng_delivers_to(Object target) {
    return 'Wird an $target gesendet';
  }

  @override
  String get ng_run_now => 'Jetzt ausführen';

  @override
  String get ng_started => 'Gestartet';

  @override
  String get ng_pause => 'Pausieren';

  @override
  String get ng_resume => 'Fortsetzen';

  @override
  String get ng_resumed => 'Fortgesetzt';

  @override
  String get ng_prompt => 'Prompt';

  @override
  String get ng_runs => 'Ausführungen';

  @override
  String get ng_no_runs_yet => 'Noch keine Ausführungen.';

  @override
  String get ng_enter_a_schedule_and_a_prompt =>
      'Gib einen Zeitplan und einen Prompt ein.';

  @override
  String get ng_name_optional => 'Name (optional)';

  @override
  String get ng_schedule => 'Zeitplan';

  @override
  String get ng_every_1h_0_9_or_30m => 'every 1h, 0 9 * * *, or 30m';

  @override
  String get ng_create => 'Erstellen';

  @override
  String get ng_unpin => 'Loslösen';

  @override
  String get ng_pin => 'Anheften';

  @override
  String get ng_rename => 'Umbenennen';

  @override
  String get ng_archive => 'Archivieren';

  @override
  String get ng_delete_this_chat => 'Diesen Chat löschen?';

  @override
  String get ng_it_is_removed_from_the_gateway =>
      'Der Chat wird auf allen Geräten aus dem Gateway entfernt.';

  @override
  String get ng_search_chats => 'Chats durchsuchen';

  @override
  String get ng_pinned => 'Angeheftet';

  @override
  String get ng_no_chats_match => 'Keine passenden Chats gefunden.';

  @override
  String get ng_no_chats_yet => 'Noch keine Chats.';

  @override
  String get ng_nothing_is_running => 'Es läuft gerade nichts.';

  @override
  String get ng_nothing_is_waiting_on_you => 'Nichts wartet auf dich.';

  @override
  String get ng_settings => 'Einstellungen';

  @override
  String get ng_all => 'Alle';

  @override
  String ng_needs_you(Object count) {
    return 'Braucht dich · $count';
  }

  @override
  String get ng_needs_you_2 => 'Braucht dich';

  @override
  String get ng_gateways => 'Gateways';

  @override
  String ng_classic_connection(Object address) {
    return '$address · klassische Verbindung';
  }

  @override
  String get ng_gateway_2 => 'Gateway';

  @override
  String get ng_signed_in => 'Angemeldet';

  @override
  String get ng_classic_connection_2 => 'Klassische Verbindung';

  @override
  String get ng_in_the_browser => 'Im Browser';

  @override
  String ng_in_the_browser_as(Object name) {
    return 'Im Browser als $name';
  }

  @override
  String get ng_not_required => 'Nicht erforderlich';

  @override
  String get ng_test_connection => 'Verbindung testen';

  @override
  String get ng_sign_in_again_2 => 'Erneut anmelden';

  @override
  String get ng_sign_out => 'Abmelden';

  @override
  String get ng_saved_gateways => 'Gateways guardados';

  @override
  String get ng_in_use => 'In Verwendung';

  @override
  String get ng_appearance => 'Aspecto';

  @override
  String get ng_theme => 'Design';

  @override
  String get ng_system => 'System';

  @override
  String get ng_light => 'Hell';

  @override
  String get ng_dark => 'Dunkel';

  @override
  String get ng_accent => 'Akzent';

  @override
  String get ng_pure_black => 'Reines Schwarz';

  @override
  String get ng_dark_theme_uses_true_black_oled =>
      'Das dunkle Design nutzt reines Schwarz (OLED)';

  @override
  String get ng_glow => 'Leuchten';

  @override
  String get ng_soft_accent_light_behind_each_screen =>
      'Sanftes Akzentlicht hinter jedem Bildschirm';

  @override
  String get ng_the_new_interface_turn_off_to =>
      'Die neue Oberfläche. Zum Zurückwechseln zur klassischen ausschalten; deine Gateways und Chats werden geteilt.';

  @override
  String get ng_more_settings => 'Weitere Einstellungen';

  @override
  String get ng_voice_notifications_language_backups_and_the =>
      'Stimme, Benachrichtigungen, Sprache, Backups und die Gateway-Konfiguration';

  @override
  String get ng_licences => 'Lizenzen';

  @override
  String ng_sign_out_of(Object name) {
    return 'Von $name abmelden?';
  }

  @override
  String get ng_this_gateway_and_its_saved_sign =>
      'Dieses Gateway und die gespeicherte Anmeldung werden in beiden Oberflächen von diesem Telefon entfernt. Deine Chats bleiben auf dem Gateway.';

  @override
  String get ng_password_or_browser => 'Passwort oder Browser';

  @override
  String get ng_unsupported => 'Nicht unterstützt';

  @override
  String get ng_background_task_finished => 'Hintergrundaufgabe abgeschlossen';

  @override
  String get ng_background_process_finished =>
      'Hintergrundprozess abgeschlossen';

  @override
  String get ng_system_message => 'Systemmeldung';

  @override
  String get ng_summary => 'Zusammenfassung';

  @override
  String get classic_interface_only => 'Nur klassische Oberfläche';

  @override
  String get classic_only_settings_hint =>
      'Abschnitte mit der Kennzeichnung „Nur klassische Oberfläche“ ändern das klassische Erscheinungsbild und den Chat, nicht NextGen. NextGen bietet eigene Darstellungsoptionen in den Einstellungen.';

  @override
  String get attachment_preview_too_large =>
      'Für die Vorschau zu groß. Über „Speichern“ oder „Teilen“ wird die Datei auf dein Smartphone heruntergeladen (bis zu 1 GB).';

  @override
  String get attachment_over_phone_limit =>
      'Diese Datei ist größer als 1 GB und überschreitet das Downloadlimit. Öffne das Dashboard, um sie herunterzuladen.';

  @override
  String attachment_downloading_percent(int percent) {
    return 'Wird heruntergeladen… $percent%';
  }

  @override
  String attachment_downloading_mb(int megabytes) {
    return 'Wird heruntergeladen… $megabytes MB';
  }

  @override
  String ng_attachment_too_large_for_gateway(String name) {
    return '$name ist größer als 12 MB, die maximale Dateigröße für dieses Gateway. Aktualisiere Hermes, um Dateien mit bis zu 100 MB zu senden.';
  }

  @override
  String ng_couldn_t_upload(String name) {
    return '$name konnte nicht hochgeladen werden.';
  }

  @override
  String ng_uploading_percent(int percent) {
    return 'Wird hochgeladen… $percent%';
  }

  @override
  String get ng_show_tasks => 'Aufgaben anzeigen';

  @override
  String get ng_hide_tasks => 'Aufgaben ausblenden';

  @override
  String get ng_goal => 'Ziel';

  @override
  String get ng_loop => 'Schleife';

  @override
  String get ng_heartbeat => 'Takt';

  @override
  String get ng_goal_working => 'In Bearbeitung';

  @override
  String get ng_goal_waiting => 'Wartend';

  @override
  String get ng_goal_blocked => 'Blockiert';

  @override
  String get ng_goal_done => 'Erledigt';

  @override
  String ng_goal_turns_of(int used, int max) {
    return '$used von $max Durchläufen';
  }

  @override
  String ng_goal_turn(int used) {
    return 'Durchlauf $used';
  }

  @override
  String get ng_loop_held => 'Wegen des Ziels angehalten';

  @override
  String get ng_loop_finished => 'Abgeschlossen';

  @override
  String get ng_loop_running => 'Läuft';

  @override
  String ng_loop_runs_of(int fired, int times) {
    return '$fired von $times Ausführungen';
  }

  @override
  String ng_loop_runs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Ausführungen',
      one: '1 Ausführung',
    );
    return '$_temp0';
  }

  @override
  String ng_loop_next(String time) {
    return 'nächste $time';
  }

  @override
  String get ng_loop_due_now => 'jetzt fällig';

  @override
  String ng_every_seconds(int seconds) {
    return 'alle $seconds s';
  }

  @override
  String ng_every_minutes(int minutes) {
    return 'alle $minutes Min.';
  }

  @override
  String ng_every_hours(int hours) {
    return 'alle $hours Std.';
  }

  @override
  String ng_every_hours_minutes(int hours, int minutes) {
    return 'alle $hours Std. und $minutes Min.';
  }

  @override
  String ng_heartbeat_fired(int count) {
    return '$count Mal ausgelöst';
  }

  @override
  String ng_heartbeat_last_fired(String time) {
    return 'Zuletzt ausgelöst um $time';
  }

  @override
  String ng_wait_until(String time) {
    return 'Warten bis $time';
  }

  @override
  String get ng_wait_resume => 'Warten auf Fortsetzung';

  @override
  String get ng_wait_other_chat => 'Warten auf einen anderen Chat';

  @override
  String ng_wait_process(String pid) {
    return 'Warten auf Prozess $pid';
  }

  @override
  String get ng_control_open => 'Ziel und Automatisierung öffnen';

  @override
  String get ng_control_title => 'Ziel und Automatisierung';

  @override
  String get ng_control_subtitle =>
      'Worauf dieser Chat hinarbeitet und was automatisch ausgeführt wird.';

  @override
  String get ng_contract_outcome => 'Ergebnis';

  @override
  String get ng_contract_verification => 'Überprüfung';

  @override
  String get ng_contract_constraints => 'Einschränkungen';

  @override
  String get ng_contract_boundaries => 'Grenzen';

  @override
  String get ng_contract_stop_when => 'Beenden, wenn';

  @override
  String get ng_subgoals => 'Teilziele';

  @override
  String get ng_subgoal_add_placeholder => 'Teilziel hinzufügen';

  @override
  String get ng_add => 'Hinzufügen';

  @override
  String get ng_subgoal_remove => 'Teilziel entfernen';

  @override
  String get ng_goal_checks => 'Prüfungen';

  @override
  String get ng_gate_not_run => 'Noch nicht ausgeführt';

  @override
  String ng_gate_attempts(int attempts, int tries) {
    return '$attempts von $tries Versuchen';
  }

  @override
  String ng_gate_exit(int code) {
    return 'Exit-Code $code';
  }

  @override
  String get ng_resume_now => 'Jetzt fortsetzen';

  @override
  String get ng_goal_clear => 'Ziel löschen';

  @override
  String get ng_goal_clear_title => 'Dieses Ziel löschen?';

  @override
  String get ng_goal_clear_message =>
      'Der Agent arbeitet nicht mehr daran. Die Teilziele und Prüfungen werden ebenfalls gelöscht.';

  @override
  String get ng_subgoal_remove_title => 'Dieses Teilziel entfernen?';

  @override
  String ng_subgoal_remove_message(String text) {
    return '„$text“ gehört dann nicht mehr zum Ziel.';
  }

  @override
  String get ng_subgoals_clear_title => 'Alle Teilziele löschen?';

  @override
  String get ng_subgoals_clear_message =>
      'Der Titel des Ziels bleibt erhalten, aber alle Teilziele werden gelöscht.';

  @override
  String get ng_clear_all => 'Alle löschen';

  @override
  String get ng_clear => 'Löschen';

  @override
  String get ng_dismiss => 'Schließen';

  @override
  String get ng_loop_stop_title => 'Diese Schleife stoppen?';

  @override
  String get ng_heartbeat_clear_title => 'Diesen Takt löschen?';

  @override
  String get ng_wont_fire_again => 'Er wird nicht erneut ausgelöst.';

  @override
  String get ng_loop_self_paced => 'Selbstgesteuert';

  @override
  String ng_loop_until(String condition) {
    return 'Bis: $condition';
  }

  @override
  String get ng_loop_waits_for_goal =>
      'Wartet, solange das Ziel bearbeitet wird.';

  @override
  String get ng_loop_awaiting_reply => 'Wartet auf die Antwort des Agents.';

  @override
  String ng_loop_stopped_reason(String reason) {
    return 'Gestoppt: $reason';
  }

  @override
  String get ng_hide_subagents => 'Subagenten ausblenden';

  @override
  String get ng_show_subagents => 'Subagenten anzeigen';

  @override
  String get ng_subagent => 'Subagent';

  @override
  String get ng_subagent_queued => 'In der Warteschlange';

  @override
  String get ng_subagent_starting => 'Wird gestartet…';

  @override
  String get ng_subagent_running => 'Läuft';

  @override
  String get ng_subagent_done => 'Abgeschlossen';

  @override
  String get ng_subagent_failed => 'Fehlgeschlagen';

  @override
  String get ng_subagent_stopped => 'Angehalten';

  @override
  String get ng_subagent_stop => 'Subagent anhalten';

  @override
  String ng_subagent_tools(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tools',
      one: '1 Tool',
    );
    return '$_temp0';
  }

  @override
  String get ng_mark_as_read => 'Als gelesen markieren';

  @override
  String get ng_mark_as_unread => 'Als ungelesen markieren';

  @override
  String ng_chats_unread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chats, $count ungelesen',
      one: 'Chats, 1 ungelesen',
    );
    return '$_temp0';
  }

  @override
  String get ng_unread_finished => 'Fertig, ungelesene Antwort';

  @override
  String get ng_unread_updates => 'Läuft, ungelesene Updates';

  @override
  String get ng_notifications => 'Benachrichtigungen';

  @override
  String get ng_notifications_hint =>
      'Antworten und Anfragen, während Ares im Hintergrund läuft';

  @override
  String get ng_notify_replies => 'Antworten';

  @override
  String get ng_notify_replies_hint =>
      'Wenn eine Antwort im geöffneten Chat abgeschlossen ist oder fehlschlägt';

  @override
  String get ng_notify_requests => 'Freigaben und Fragen';

  @override
  String get ng_notify_requests_hint =>
      'Ein Hinweis, wenn der Agent auf dich wartet – mit „Einmal erlauben“ und „Ablehnen“';

  @override
  String get ng_keep_running => 'Während einer Antwort verbunden bleiben';

  @override
  String get ng_keep_running_hint =>
      'Hält die Verbindung im Hintergrund offen, bis die Antwort fertig ist, und zeigt eine unaufdringliche Benachrichtigung';

  @override
  String get ng_battery_settings => 'Akkuoptimierung';

  @override
  String get ng_battery_settings_hint =>
      'Ares im Hintergrund laufen lassen, damit Benachrichtigungen pünktlich ankommen';

  @override
  String get ng_send_test_notification => 'Testbenachrichtigung senden';

  @override
  String get ng_test_notification_title =>
      'Ares-Benachrichtigungen funktionieren';

  @override
  String get ng_test_notification_body =>
      'Antworten und Anfragen werden so angezeigt.';

  @override
  String get ng_test_notification_sent => 'Testbenachrichtigung gesendet';

  @override
  String get ng_notifications_blocked =>
      'Benachrichtigungen sind blockiert. Erlaube sie in den Android-Einstellungen.';

  @override
  String get ng_notifications_off_hint =>
      'Benachrichtigungen sind deaktiviert. Daher werden keine angezeigt, während Ares im Hintergrund läuft.';

  @override
  String get ng_insights_building =>
      'Der Bericht wird erstellt. Bei einem längeren Zeitraum kann es beim ersten Mal bis zu einer Minute dauern.';

  @override
  String get ng_insights_timed_out =>
      'Das Gateway hat zu lange gebraucht, um diesen Bericht zu erstellen. Versuche es erneut oder wähle einen kürzeren Zeitraum.';

  @override
  String get ng_dock_goal_active => 'Ziel aktiv';

  @override
  String get ng_dock_goal_paused => 'Ziel pausiert';

  @override
  String get ng_dock_goal_waiting => 'Ziel wartet';

  @override
  String get ng_dock_goal_blocked => 'Ziel blockiert';

  @override
  String get ng_dock_goal_done => 'Ziel abgeschlossen';

  @override
  String ng_dock_turn_of(int used, int max) {
    return 'Durchlauf $used/$max';
  }

  @override
  String ng_dock_turn(int used) {
    return 'Durchlauf $used';
  }

  @override
  String ng_dock_subagents(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Unteragenten',
      one: '1 Unteragent',
    );
    return '$_temp0';
  }

  @override
  String ng_dock_subagents_done(int count) {
    return '$count erledigt';
  }

  @override
  String ng_dock_tasks(int done, int total) {
    return 'Aufgaben $done/$total';
  }

  @override
  String ng_dock_previous_tasks(int done, int total) {
    return 'Vorherige Aufgaben $done/$total';
  }

  @override
  String get ng_dock_manage => 'Verwalten';

  @override
  String get ng_recent_notifications => 'Letzte Benachrichtigungen';

  @override
  String get ng_recent_notifications_hint =>
      'Was Ares zu posten versucht hat und ob Android es angezeigt hat';

  @override
  String get ng_recent_notifications_empty =>
      'Noch nichts. Versuche werden hier angezeigt, sobald eine Antwort, Frage oder ein Fehler dich benachrichtigen würde.';

  @override
  String get ng_notify_permission_granted => 'Berechtigung erteilt';

  @override
  String get ng_notify_permission_denied => 'Berechtigung verweigert';

  @override
  String get ng_notify_master_on => 'Benachrichtigungen aktiviert';

  @override
  String get ng_notify_master_off => 'Benachrichtigungen deaktiviert';

  @override
  String get ng_models_default => 'Standardmodell';

  @override
  String get ng_models_change => 'Ändern';

  @override
  String get ng_models_custom_endpoint =>
      'Läuft über einen benutzerdefinierten Endpunkt. Ändere ihn auf dem Gateway.';

  @override
  String get ng_models_context_window => 'Kontextfenster';

  @override
  String ng_models_token_count(String count) {
    return '$count Token';
  }

  @override
  String ng_models_context_override(String count) {
    return 'Auf dem Gateway festgelegt. Automatisch erkannt: $count Token.';
  }

  @override
  String get ng_models_max_output => 'Max. Ausgabe';

  @override
  String get ng_models_input_price => 'Eingabepreis';

  @override
  String get ng_models_output_price => 'Ausgabepreis';

  @override
  String get ng_models_cache_price => 'Preis für zwischengespeicherte Eingabe';

  @override
  String ng_models_per_million(String price) {
    return '$price pro 1 Mio. Token';
  }

  @override
  String ng_models_price_pair(String input, String output) {
    return '$input Eingabe · $output Ausgabe pro 1 Mio. Token';
  }

  @override
  String get ng_models_free => 'Kostenlos';

  @override
  String get ng_models_vision => 'Bildanalyse';

  @override
  String get ng_models_reasoning => 'Denken';

  @override
  String get ng_models_fast => 'Schnellmodus';

  @override
  String get ng_models_in_use => 'In Verwendung';

  @override
  String ng_models_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Modelle',
      one: '$count Modell',
    );
    return '$_temp0';
  }

  @override
  String get ng_models_rate_limited => 'Limit erreicht';

  @override
  String get ng_models_plan_locked => 'Nicht in deinem Tarif';

  @override
  String get ng_models_unsaved => 'Nicht gespeicherte Änderungen';

  @override
  String get ng_models_discard => 'Verwerfen';

  @override
  String get ng_models_aux_hint =>
      'Hilfsaufgaben nutzen das Standardmodell, solange du ihnen kein eigenes zuweist.';

  @override
  String get ng_models_uses_default => 'Nutzt das Standardmodell';

  @override
  String get ng_models_thinking_level => 'Denkstufe';

  @override
  String get ng_models_providers => 'Anbieter';

  @override
  String get ng_models_saved => 'Gespeichert';

  @override
  String get ng_aux_vision => 'Bildanalyse';

  @override
  String get ng_aux_vision_hint => 'Liest Bilder und Screenshots';

  @override
  String get ng_aux_compression => 'Komprimierung';

  @override
  String get ng_aux_compression_hint =>
      'Kürzt lange Chats, damit sie ins Kontextfenster passen';

  @override
  String get ng_aux_approval => 'Freigabe';

  @override
  String get ng_aux_approval_hint =>
      'Entscheidet, ob ein Befehl ohne Nachfrage sicher ausgeführt werden kann';

  @override
  String get ng_aux_mcp => 'MCP';

  @override
  String get ng_aux_mcp_hint => 'Wählt aus, welche MCP-Tools verwendet werden';

  @override
  String get ng_aux_title_generation => 'Chat-Titel';

  @override
  String get ng_aux_title_generation_hint => 'Benennt neue Chats';

  @override
  String get ng_aux_review => 'Überprüfung';

  @override
  String get ng_aux_review_hint =>
      'Prüft die Arbeit, wenn du /review ausführst';

  @override
  String get ng_aux_voice_chat => 'Sprachchat';

  @override
  String get ng_aux_voice_chat_hint => 'Antwortet im Sprachmodus';

  @override
  String get ng_aux_triage_specifier => 'Triage';

  @override
  String get ng_aux_triage_specifier_hint =>
      'Macht aus einer einzeiligen Kanban-Karte eine Spezifikation';

  @override
  String get ng_aux_kanban_decomposer => 'Kanban-Zerlegung';

  @override
  String get ng_aux_kanban_decomposer_hint =>
      'Teilt eine Kanban-Karte in kleinere Aufgaben auf';

  @override
  String get ng_aux_profile_describer => 'Profilbeschreibungen';

  @override
  String get ng_aux_profile_describer_hint =>
      'Schreibt die Kurzbeschreibung jedes Profils';

  @override
  String get ng_aux_curator => 'Kurator';

  @override
  String get ng_aux_curator_hint => 'Prüft, wie Skills genutzt werden';

  @override
  String get appearance_save_failed =>
      'Diese Änderung konnte nicht gespeichert werden.';

  @override
  String get appearance_keep_which_theme => 'Welches Design behalten?';

  @override
  String get appearance_tour_back => 'Zurück';

  @override
  String get appearance_tour_finish => 'Fertigstellen';

  @override
  String get appearance_tour_next => 'Weiter';

  @override
  String get appearance_tour_close => 'Tour schließen';

  @override
  String get appearance_dismiss_tip => 'Tipp ausblenden';

  @override
  String get appearance_search_settings => 'Einstellungen durchsuchen';

  @override
  String get appearance_search_show => 'Anzeigen';

  @override
  String get appearance_no_matching_setting => 'Keine passende Einstellung.';

  @override
  String get appearance_replay_tour => 'Tour wiederholen';

  @override
  String get appearance_show_tips_again => 'Tipps erneut anzeigen';

  @override
  String get appearance_window_translucency_unavailable =>
      'Fenstertransparenz ist auf diesem Host nicht verfügbar. Linux kann sie nicht bereitstellen, und die Apple- und Windows-Runner zeichnen eine undurchsichtige Flutter-Ansicht.';

  @override
  String get appearance_imported_themes => 'Importierte Designs';

  @override
  String get appearance_import_theme_file => 'Design-Datei importieren';

  @override
  String get appearance_remove_theme => 'Design entfernen';

  @override
  String get appearance_chat_font => 'Chat-Schriftart';

  @override
  String get appearance_terminal_font => 'Terminal-Schriftart';

  @override
  String get appearance_font_platform => 'Plattform';

  @override
  String get appearance_automatic => 'Automatisch';

  @override
  String get appearance_force_left_to_right => 'Links nach rechts erzwingen';

  @override
  String get appearance_force_right_to_left => 'Rechts nach links erzwingen';

  @override
  String get appearance_user_bubble_opacity =>
      'Deckkraft der Nutzer-Sprechblasen';

  @override
  String get appearance_inline_embeds => 'Eingebettete Inhalte';

  @override
  String get appearance_inline_embeds_hint =>
      'Umfangreiche Vorschauen werden von Websites Dritter geladen (YouTube, X, …). „Fragen“ zeigt einen Platzhalter, bis du jede einzeln erlaubst; „Immer“ lädt sie automatisch; „Aus“ behält einfache Links.';

  @override
  String get appearance_embeds_ask => 'Fragen';

  @override
  String get appearance_embeds_always => 'Immer';

  @override
  String get appearance_embeds_off => 'Aus';

  @override
  String appearance_embeds_reset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count erlaubte Dienste zurücksetzen',
      one: '1 erlaubten Dienst zurücksetzen',
    );
    return '$_temp0';
  }

  @override
  String get appearance_embed_load => 'Laden';

  @override
  String appearance_embed_always_allow(String service) {
    return '$service immer erlauben';
  }

  @override
  String get appearance_embed_loading => 'Vorschau wird geladen…';

  @override
  String appearance_embed_image_failed(String host) {
    return 'Das Bild von $host konnte nicht geladen werden. Tippe, um es zu öffnen.';
  }

  @override
  String get appearance_embed_preview_unavailable => 'Vorschau nicht verfügbar';

  @override
  String get appearance_emoji_reactions => 'Emoji-Reaktionen';

  @override
  String get appearance_celebration_hearts => 'Freudenherzen';

  @override
  String get appearance_celebration_hearts_hint =>
      'Ein Herz wird animiert, wenn während deiner Abwesenheit eine Antwort eingetroffen ist.';

  @override
  String get appearance_pop_out_companion =>
      'Begleiter in eigenem Fenster öffnen';

  @override
  String get appearance_mosskip => 'Mosskip';

  @override
  String get appearance_emberbun => 'Emberbun';

  @override
  String get appearance_tideling => 'Tideling';

  @override
  String get appearance_my_hatchling => 'Mein Schlüpfling';

  @override
  String get appearance_at_rest => 'Ruht';

  @override
  String get appearance_working => 'In Arbeit';

  @override
  String get appearance_thinking => 'Denkt nach';

  @override
  String get appearance_waiting_for_you => 'Wartet auf dich';

  @override
  String get appearance_reply_ready => 'Antwort bereit';

  @override
  String get appearance_turn_failed => 'Durchlauf fehlgeschlagen';

  @override
  String get appearance_small => 'Klein';

  @override
  String get appearance_medium => 'Mittel';

  @override
  String get appearance_large => 'Groß';

  @override
  String get appearance_hello => 'Hallo!';

  @override
  String get appearance_unread_reply => 'Ungelesene Antwort';

  @override
  String get appearance_compose => 'Verfassen';

  @override
  String get appearance_say_hello => 'Hallo sagen';

  @override
  String get appearance_pet_image_failed =>
      'Dieses Bild konnte nicht geöffnet werden. Wähle eine kleinere PNG- oder JPEG-Datei.';

  @override
  String get appearance_pet_companion => 'Tierischer Begleiter';

  @override
  String get appearance_pet_companion_hint =>
      'Beim Chatten einen Begleiter anzeigen.';

  @override
  String get appearance_adopt_a_companion => 'Begleiter adoptieren';

  @override
  String get appearance_roam_when_idle => 'Im Leerlauf umherstreifen';

  @override
  String get appearance_pet_size => 'Größe des Begleiters';

  @override
  String get appearance_hatch_from_a_local_picture =>
      'Aus einem lokalen Bild schlüpfen lassen';

  @override
  String get appearance_pet_image_limits =>
      'Wähle ein PNG oder JPEG (bis zu 4 MiB, 4096 px pro Seite und 8 MP). Sieh dir zuerst die Vorschau an. Beim Schlüpfen wird ein 24 × 24 Pixel großes Porträt gespeichert und dein bisheriger Schlüpfling ersetzt.';

  @override
  String get appearance_choose_picture => 'Bild auswählen';

  @override
  String get appearance_hatchling_preview => 'Schlüpfling-Vorschau';

  @override
  String get appearance_hatch_and_adopt => 'Schlüpfen lassen und adoptieren';

  @override
  String get appearance_discard_draft => 'Entwurf verwerfen';

  @override
  String get appearance_forget_saved_hatchling =>
      'Gespeicherten Schlüpfling vergessen';

  @override
  String get appearance_radio => 'Radio';

  @override
  String appearance_radio_hint(String stations) {
    return 'Streams kommen direkt von $stations und starten erst, wenn du auf Wiedergabe drückst. Die Sendersuche bleibt auf diesem Gerät.';
  }

  @override
  String get appearance_radio_save_failed =>
      'Die Radioeinstellungen konnten nicht gespeichert werden.';

  @override
  String get appearance_choose_a_station => 'Sender auswählen';

  @override
  String get appearance_pause_radio => 'Radio pausieren';

  @override
  String get appearance_play_radio => 'Radio abspielen';

  @override
  String get appearance_next_station => 'Nächster Sender';

  @override
  String get appearance_radio_trace_semantics =>
      'Stream-Aktivität. Audiopegel sind nicht verfügbar, daher bleibt diese Linie flach.';

  @override
  String get appearance_radio_is_off => 'Radio ist ausgeschaltet';

  @override
  String get appearance_paused => 'Pausiert';

  @override
  String get appearance_connecting => 'Verbindung wird hergestellt…';

  @override
  String get appearance_live => 'Live';

  @override
  String get appearance_stream_unavailable => 'Stream nicht verfügbar';

  @override
  String appearance_now_playing(String credit) {
    return 'Läuft gerade: $credit';
  }

  @override
  String get appearance_audio_only_waveform_unavailable =>
      'Nur Audio · Wellenform nicht verfügbar';

  @override
  String get appearance_volume => 'Lautstärke';

  @override
  String get appearance_search_presets => 'Voreinstellungen durchsuchen';

  @override
  String get appearance_no_stations_found => 'Keine Sender gefunden';

  @override
  String appearance_unpin_station(String station) {
    return 'Sender lösen: $station';
  }

  @override
  String appearance_pin_station(String station) {
    return 'Sender anheften: $station';
  }

  @override
  String get appearance_radio_picker_metadata_notice =>
      'Solange diese Auswahl geöffnet ist, können laufende Sender Titeldetails direkt vom Rundfunkanbieter übermitteln.';

  @override
  String get appearance_message_from_your_companion =>
      'Nachricht von deinem Begleiter';

  @override
  String get appearance_send_to_the_open_chat =>
      'An den geöffneten Chat senden';

  @override
  String get appearance_tour_theme_body =>
      'Importiere ein VS Code-Farbthema aus einer Datei auf diesem Gerät und wähle dann die Variante, die du behalten möchtest.';

  @override
  String get appearance_tour_fonts_title => 'Leseschriftarten';

  @override
  String get appearance_tour_fonts_body =>
      'Chat-Text und Terminal-Code verwenden unterschiedliche, mit Ares gelieferte Schriftarten.';

  @override
  String get appearance_tour_direction_title => 'Transkriptrichtung';

  @override
  String get appearance_tour_direction_body =>
      'Lass dies auf automatisch oder erzwinge die Transkriptrichtung von links nach rechts oder von rechts nach links.';

  @override
  String get appearance_tour_pet_title => 'Begleiter';

  @override
  String get appearance_tour_pet_body =>
      'Der Begleiter bleibt aus, bis du einen adoptierst. Im eigenen Fenster kommt ein kleines Eingabefeld hinzu.';

  @override
  String get appearance_tour_radio_body =>
      'Das Radio bleibt aus, bis du es aktivierst. Erst Wiedergabe öffnet einen Stream.';

  @override
  String get appearance_tip_theme =>
      'Importierte Designs ersetzen die integrierte Farbpalette, bis du die Auswahl aufhebst. Nur die Farben werden übernommen.';

  @override
  String get appearance_tip_pet =>
      'Der Begleiter speichert ein kleines Porträt auf diesem Gerät. Das Bild, aus dem du ihn schlüpfen lässt, wird nicht hochgeladen.';

  @override
  String get appearance_theme_import_failed =>
      'Dieses Design konnte nicht importiert werden. Wähle ein VS Code-Farbthema, das als .vsix-, .json- oder .jsonc-Datei gespeichert ist.';

  @override
  String get render_widget_file_truncated =>
      'Nur der Anfang dieser Datei wurde gelesen, daher ist das Widget möglicherweise unvollständig.';

  @override
  String get setup_beat_title => 'Einrichtung';

  @override
  String setup_beat_use_name(String name) {
    return '$name verwenden';
  }

  @override
  String get setup_beat_name_hint => 'Wie soll Hermes dich nennen?';

  @override
  String get setup_beat_on_computer =>
      'Dieser Schritt erfolgt in Hermes auf dem Computer, auf dem es läuft. „Weiter“ behält, was dort eingerichtet ist.';

  @override
  String get setup_beat_not_waiting =>
      'Diese Einrichtungskarte wartet nicht mehr auf eine Antwort.';

  @override
  String get catalog_kind_plugin => 'Plugin';

  @override
  String get catalog_kind_skill => 'Skill';

  @override
  String get catalog_tier_official => 'Offiziell';

  @override
  String get catalog_tier_verified => 'Geprüft';

  @override
  String get catalog_tier_community => 'Community';

  @override
  String get catalog_install => 'Installieren';

  @override
  String get catalog_waiting => 'Wartet auf deine Wahl';

  @override
  String get catalog_installed => 'Installiert';

  @override
  String get catalog_installed_off => 'Installiert, nicht aktiviert';

  @override
  String get catalog_skipped => 'Übersprungen';

  @override
  String get catalog_not_installed => 'Nicht installiert';

  @override
  String catalog_target_profile(String profile) {
    return 'Wird im Profil $profile installiert';
  }

  @override
  String catalog_source(String repo, String sha) {
    return '$repo bei $sha';
  }

  @override
  String catalog_scan(String status, String summary) {
    return 'Sicherheitsprüfung: $status. $summary';
  }

  @override
  String catalog_requires_hermes(String range) {
    return 'Benötigt Hermes $range';
  }

  @override
  String catalog_skill_ready(String name) {
    return 'Skill $name ist einsatzbereit';
  }

  @override
  String catalog_missing_env(String names) {
    return 'Benötigt noch: $names';
  }

  @override
  String catalog_server_error(String name, String error) {
    return '$name hat sich nicht verbunden: $error';
  }

  @override
  String get catalog_send_failed =>
      'Deine Wahl wurde nicht gesendet. Versuche es erneut.';

  @override
  String get attachment_video_speed => 'Wiedergabegeschwindigkeit';

  @override
  String get catalog_installing => 'Wird installiert…';

  @override
  String get catalog_phase_downloading => 'Wird heruntergeladen…';

  @override
  String get catalog_phase_python_packages =>
      'Python-Pakete werden installiert…';

  @override
  String get catalog_phase_loading_tools => 'Werkzeuge werden geladen…';

  @override
  String get setup_beat_send_failed =>
      'Deine Antwort wurde nicht gesendet. Versuche es erneut.';

  @override
  String catalog_tool_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Tools',
      one: '1 Tool',
    );
    return '$_temp0';
  }

  @override
  String get render_svg_not_drawn => 'Dieses SVG wurde nicht gezeichnet.';

  @override
  String get render_notes_directive => 'Notiz-Direktive';

  @override
  String get render_maths_source => 'Formelquelle';

  @override
  String get render_inline_maths_source => 'Inline-Formelquelle';

  @override
  String get render_sequence_outline => 'Ablaufübersicht';

  @override
  String get render_diagram_outline => 'Diagrammübersicht';

  @override
  String render_revision_of(int index, int count) {
    return 'Revision $index von $count';
  }

  @override
  String get render_previous_revision => 'Vorherige Revision';

  @override
  String get render_next_revision => 'Nächste Revision';

  @override
  String get render_show_rendered => 'Dargestellt';

  @override
  String get render_show_source => 'Quelltext';

  @override
  String render_copied_file(String name) {
    return '$name kopiert';
  }

  @override
  String render_copy_file(String name) {
    return '$name kopieren';
  }

  @override
  String get render_artifact_too_long =>
      'Dieses Artefakt ist zu lang, um es hier als Seite anzuzeigen.';

  @override
  String get render_active_content_removed =>
      'Skripte, Frames und externe Adressen wurden entfernt.';

  @override
  String render_widget_file(String file) {
    return 'Widget-Datei $file';
  }

  @override
  String get render_widget_runs_as_text =>
      'Läuft als Text in diesem Chat. Skripte und externe Frames werden entfernt.';

  @override
  String get render_load_widget => 'Widget laden';

  @override
  String get render_not_html_widget => 'Diese Datei ist kein HTML-Widget.';

  @override
  String get render_widget_sent => 'An diesen Chat gesendet';

  @override
  String get render_widget_not_sent => 'Nicht an diesen Chat gesendet';

  @override
  String get render_widget_throttled => 'Warte kurz, bevor du erneut sendest';

  @override
  String get render_widget_too_long => 'Diese Anfrage ist zu lang zum Senden';

  @override
  String get render_widget_no_gesture =>
      'Tippe zum Senden auf ein Steuerelement im Widget';

  @override
  String get render_widget_invalid =>
      'Diese Anfrage konnte nicht gesendet werden';

  @override
  String get render_inspected_image => 'Untersuchtes Bild';

  @override
  String get render_contributions => 'Beiträge';

  @override
  String get render_contributions_intro =>
      'Nur in Ares eingebaute Beiträge können eine Antwort ergänzen. Chattext kann keinen registrieren, und eine Freigabe gilt nur für diese Verbindung.';

  @override
  String render_grant_plugin(String name) {
    return '$name erlauben';
  }

  @override
  String render_revoke_plugin(String name) {
    return '$name entziehen';
  }

  @override
  String render_plugin_slots(String directive) {
    return 'Antwortkarten für ::$directive';
  }

  @override
  String get render_plugin_notes => 'Notizen';

  @override
  String get catalog_scan_passed => 'bestanden';

  @override
  String get catalog_scan_warnings => 'Warnungen gefunden';

  @override
  String get catalog_scan_failed => 'fehlgeschlagen';

  @override
  String get deployment_token_label => 'Bereitstellungstoken (optional)';

  @override
  String get deployment_token_helper =>
      'Für Hermes-Dashboard-Sitzungstokens, gesendet als X-Hermes-Session-Token. Nicht im Klartext in den Einstellungen gespeichert.';

  @override
  String get deployment_token_hint => 'Dashboard-Sitzungstoken';

  @override
  String get custom_headers_label => 'Eigene Header (optional)';

  @override
  String get custom_headers_helper =>
      'Einer pro Zeile, z. B. X-Custom: Wert. Verbotene Header werden abgelehnt.';

  @override
  String get custom_headers_hint => 'z. B. X-Custom-Header: Wert';

  @override
  String get desktop_tray_open => 'Ares öffnen';

  @override
  String get desktop_tray_new_chat => 'Neuer Chat';

  @override
  String get desktop_tray_quick_entry => 'Schnelleingabe…';

  @override
  String get desktop_tray_pause_notifications => 'Benachrichtigungen pausieren';

  @override
  String get desktop_tray_quit => 'Ares beenden';

  @override
  String get desktop_integration_title => 'Desktop-Integration';

  @override
  String get desktop_tray_setting =>
      'Ares im Infobereich oder in der Menüleiste anzeigen';

  @override
  String get desktop_tray_setting_help =>
      'Über das Symbol Ares öffnen, einen Chat starten, die Schnelleingabe öffnen, Benachrichtigungen pausieren oder beenden.';

  @override
  String get desktop_close_to_tray_setting =>
      'Beim Schließen des Fensters im Infobereich weiterlaufen';

  @override
  String get desktop_tray_unsupported =>
      'Diese Arbeitsumgebung hat keinen Infobereich, den Ares nutzen kann.';

  @override
  String get quick_entry_title => 'Schnelleingabe';

  @override
  String get quick_entry_hint => 'Prompt für Ares eingeben…';

  @override
  String get quick_entry_submit => 'In Eingabefeld übernehmen';

  @override
  String get quick_entry_never_sends =>
      'Mit Enter landet der Text im Eingabefeld des Chats. Gesendet wird erst, wenn du auf Senden drückst.';

  @override
  String get quick_entry_unavailable =>
      'Die Schnelleingabe konnte nicht geöffnet werden. Versuche es erneut.';

  @override
  String get desktop_hotkey_setting => 'Tastenkürzel für Schnelleingabe';

  @override
  String desktop_hotkey_help(String shortcut) {
    return 'Drücke überall $shortcut, um die Schnelleingabe zu öffnen.';
  }

  @override
  String desktop_hotkey_conflict(String shortcut) {
    return 'Eine andere App verwendet bereits $shortcut. Wähle ein anderes Tastenkürzel.';
  }

  @override
  String get desktop_hotkey_unsupported =>
      'Diese Arbeitsumgebung erlaubt Apps keine globalen Tastenkürzel (zum Beispiel unter Wayland).';

  @override
  String get desktop_hotkey_no_modifier => 'Füge Cmd, Strg oder Alt hinzu.';

  @override
  String get desktop_hotkey_super_key =>
      'Die Windows- bzw. Super-Taste ist dem System vorbehalten.';

  @override
  String get desktop_hotkey_reserved =>
      'Das System verwendet dieses Tastenkürzel bereits.';

  @override
  String desktop_hotkey_in_app(String action) {
    return 'Ares verwendet dieses Tastenkürzel bereits für $action.';
  }

  @override
  String get desktop_hotkey_change => 'Ändern';

  @override
  String get desktop_hotkey_reset => 'Standard verwenden';

  @override
  String get capture_screen_action => 'Bildschirm aufnehmen';

  @override
  String get capture_screen_help =>
      'Fügt der Nachricht einen Screenshot als Entwurf hinzu. Gesendet wird erst, wenn du auf Senden drückst.';

  @override
  String get capture_screen_unavailable =>
      'Bildschirmaufnahmen sind in dieser Arbeitsumgebung nicht verfügbar.';

  @override
  String get capture_screen_failed =>
      'Der Bildschirm konnte nicht aufgenommen werden. Versuche es erneut.';

  @override
  String get capture_permission_title => 'Bildschirmaufnahme erlauben';

  @override
  String get capture_permission_body =>
      'Um ein Fenster aufzunehmen, braucht Ares die Berechtigung „Bildschirmaufnahme“. Aktiviere Ares unter Systemeinstellungen > Datenschutz & Sicherheit > Bildschirmaufnahme und versuche es dann erneut.';

  @override
  String get capture_open_settings => 'Systemeinstellungen öffnen';

  @override
  String get keep_awake_title => 'Computer wach halten';

  @override
  String get keep_awake_title_mobile => 'Bildschirm eingeschaltet lassen';

  @override
  String get keep_awake_mode_off => 'Aus';

  @override
  String get keep_awake_mode_while_working => 'Während der Arbeit';

  @override
  String get keep_awake_mode_always => 'Immer';

  @override
  String get keep_awake_off_help => 'Ruhezustand nie verhindern (Standard).';

  @override
  String get keep_awake_while_working_help =>
      'Leerlauf-Ruhezustand nur verhindern, während ein Agent-Durchlauf läuft.';

  @override
  String get keep_awake_always_help =>
      'Leerlauf-Ruhezustand verhindern, solange Ares auf diesem Gerät geöffnet ist.';

  @override
  String get keep_awake_off_help_mobile =>
      'Bildschirm wie gewohnt ausschalten lassen (Standard).';

  @override
  String get keep_awake_while_working_help_mobile =>
      'Bildschirm eingeschaltet lassen, während ein Agent-Durchlauf läuft und Ares geöffnet ist.';

  @override
  String get keep_awake_always_help_mobile =>
      'Bildschirm eingeschaltet lassen, solange Ares geöffnet ist.';

  @override
  String get ng_token_gateway_has_no_sign_in =>
      'Dieses Gateway hat keine Anmeldung und kann daher kein Bereitstellungstoken prüfen. Aktiviere die Dashboard-Authentifizierung auf dem Host (oder aktualisiere Hermes) und versuche es erneut.';

  @override
  String get palette_open => 'App-Befehlspalette';

  @override
  String get palette_no_matches => 'Keine passenden Aktionen';

  @override
  String get palette_filter_hint => 'Tippen, um Aktionen zu filtern…';

  @override
  String get palette_keys_move => '↑↓ zum Bewegen';

  @override
  String get palette_keys_run => 'Eingabe zum Ausführen';

  @override
  String get palette_keys_close => 'Esc zum Schließen';

  @override
  String get palette_search_sessions => 'Sitzungen durchsuchen';

  @override
  String get palette_scheduled_crons => 'Geplant / Crons';

  @override
  String get palette_capabilities_skills => 'Fähigkeiten & Skills';

  @override
  String get palette_insights_usage => 'Einblicke & Nutzung';

  @override
  String get palette_more_projects => 'Mehr & Projekte';

  @override
  String get deeplink_chat_not_found =>
      'Chat nicht in der Liste gefunden. Möglicherweise ist er noch nicht geladen.';

  @override
  String get keyboard_shortcuts_title => 'Tastenkürzel';

  @override
  String get shortcuts_reset_all => 'Alle zurücksetzen';

  @override
  String get shortcuts_reset_to_default => 'Auf Standard zurücksetzen';

  @override
  String get shortcut_action_command_palette => 'Befehlspalette';

  @override
  String get shortcut_action_new_chat => 'Neuer Chat';

  @override
  String get shortcut_action_search => 'Suchen';

  @override
  String get shortcut_action_settings => 'Einstellungen';

  @override
  String shortcut_action_go_to_tab(int number) {
    return 'Zu Tab $number';
  }

  @override
  String shortcuts_conflict(String first, String second, String chord) {
    return 'Konflikt: „$first“ und „$second“ verwenden beide $chord. Das eigene Tastenkürzel behält seinen Standard, bis du eines davon änderst.';
  }

  @override
  String shortcuts_editor_title(String action) {
    return 'Tastenkürzel: $action';
  }

  @override
  String get shortcuts_editor_help =>
      'Drücke eine Tastenkombination oder wähle unten Modifikatoren und eine Taste:';

  @override
  String get shortcuts_editor_needs_modifier =>
      'Wähle mindestens Cmd/Meta, Ctrl oder Alt, damit das Tippen im Eingabefeld nicht betroffen ist.';

  @override
  String shortcuts_text_editing_warning(String chord) {
    return '$chord ist ein Textbearbeitungskürzel (Kopieren, Einfügen, Ausschneiden, Rückgängig, Wiederholen oder Alles auswählen). Wenn du es hier belegst, fehlt es in Textfeldern.';
  }

  @override
  String shortcuts_text_editing_in_use(String action, String chord) {
    return '„$action“ verwendet $chord, ein Textbearbeitungskürzel. Textfelder verlieren es, solange es hier belegt ist.';
  }

  @override
  String custom_headers_problem_format(int line) {
    return 'Zeile $line: „Name: Wert“ erwartet';
  }

  @override
  String custom_headers_problem_missing_name(int line) {
    return 'Zeile $line: Header-Name fehlt';
  }

  @override
  String custom_headers_problem_invalid_name(int line, String name) {
    return 'Zeile $line: ungültiger Header-Name „$name“';
  }

  @override
  String custom_headers_problem_reserved(int line, String name) {
    return 'Zeile $line: „$name“ ist reserviert und kann nicht weitergegeben werden';
  }

  @override
  String custom_headers_problem_empty_value(int line) {
    return 'Zeile $line: leerer Header-Wert';
  }

  @override
  String get ng_enter_a_deployment_token =>
      'Gib ein Bereitstellungs-Sitzungstoken ein.';

  @override
  String get ng_custom_headers => 'Eigene Header';

  @override
  String get ng_custom_headers_help =>
      'Zusätzliche HTTP-Header für dieses Gateway (Name: Wert, einer pro Zeile), gesendet bei seinen REST- und WebSocket-Aufrufen. Sie liegen im sicheren Anmeldedatenspeicher. Authentifizierungs- und Hop-by-Hop-Header werden abgelehnt.';

  @override
  String get ng_use_a_deployment_token =>
      'Bereitstellungs-Sitzungstoken verwenden';

  @override
  String get ng_sign_in_with_deployment_token =>
      'Mit Bereitstellungstoken anmelden';

  @override
  String get ng_signed_in_with_deployment_token =>
      'Mit dem Bereitstellungstoken angemeldet.';

  @override
  String get auto_speak_replies_title => 'Antworten automatisch vorlesen';

  @override
  String get auto_speak_replies_subtitle =>
      'Liest jede neue Antwort nach Abschluss eines Turns hörbar vor. Aus standardmäßig; der in-Chat Schalter „Spoken replies“ gilt weiterhin.';

  @override
  String get ng_auto_read_replies_title => 'Antworten automatisch vorlesen';

  @override
  String get ng_auto_read_replies_subtitle =>
      'Liest jede neue Antwort nach Abschluss eines Turns hörbar vor. Aus standardmäßig.';

  @override
  String get barge_in_title => 'Hereinbrechen';

  @override
  String get barge_in_subtitle =>
      'Sprechen Sie während einer Antwort, um das Vorlesen abzubrechen. Das Mikrofon bleibt eingeschaltet, solange Antworten vorgelesen werden.';

  @override
  String get barge_in_mic_live =>
      'Mikrofon an: Sprechen Sie, um die Antwort abzubrechen';

  @override
  String get ng_barge_in_title => 'Hereinbrechen';

  @override
  String get ng_barge_in_subtitle =>
      'Sprechen Sie während einer Antwort, um das Vorlesen abzubrechen. Das Mikrofon bleibt eingeschaltet, solange Antworten vorgelesen werden.';

  @override
  String get ng_barge_in_mic_live =>
      'Mikrofon an: Sprechen Sie, um die Antwort abzubrechen';

  @override
  String get wake_word_title => 'Aktivierungswort';

  @override
  String get wake_word_subtitle =>
      'Freihändige Aktivierungswort-Erkennung über das Gateway. Standardmäßig aus; überträgt Mikrofon-Audio nur bei aktiver Geräteaufnahme.';

  @override
  String wake_word_listening(String phrase) {
    return 'Hört auf Aktivierungswort „$phrase“';
  }

  @override
  String wake_word_paused(String phrase) {
    return 'Aktivierungswort „$phrase“ — pausiert';
  }

  @override
  String wake_word_off(String phrase) {
    return 'Aktivierungswort „$phrase“ — aus';
  }

  @override
  String get wake_word_arming => 'Aktivierungswort wird vorbereitet…';

  @override
  String get wake_word_stop => 'Aktivierungswort stoppen';

  @override
  String get wake_word_rearm => 'Neu aktivieren';

  @override
  String get wake_word_capture_mode => 'Aufnahmemodus';

  @override
  String get wake_word_capture_auto => 'Automatisch';

  @override
  String get wake_word_capture_client => 'Mikrofon dieses Geräts';

  @override
  String get wake_word_capture_local => 'Mikrofon des Gateway-Hosts';

  @override
  String get wake_word_capture_unavailable =>
      'Dieses Gateway lässt Apps den Aufnahmemodus nicht ändern. Lege wake_word.capture in der Hermes-Konfiguration auf dem Gateway-Host fest.';

  @override
  String get wake_word_input_device => 'Eingabemikrofon';

  @override
  String get wake_word_default_device => 'Systemstandard';

  @override
  String get ng_wake_word_title => 'Aktivierungswort';

  @override
  String get ng_wake_word_subtitle =>
      'Freihändige Aktivierungswort-Erkennung über das Gateway. Standardmäßig aus.';

  @override
  String get voice_engine_title => 'Sprachgesprächs-Engine';

  @override
  String get voice_engine_subtitle =>
      'Wählen Sie, wie freihändige Sprachgespräche auf diesem Gateway-Profil laufen.';

  @override
  String get voice_engine_chained =>
      'Verkettet (Sprache zu Text → Hermes → Sprache)';

  @override
  String get voice_engine_chained_short => 'Verkettet';

  @override
  String get voice_engine_live => 'GPT-Live (Echtzeit-Sprache)';

  @override
  String get voice_engine_live_short => 'GPT-Live';

  @override
  String get voice_engine_live_needs_key =>
      'Hinterlegen Sie auf dem Gateway-Host einen OpenAI-API-Schlüssel, um GPT-Live zu aktivieren.';

  @override
  String voice_engine_fallback_chained(String reason) {
    return 'GPT-Live nicht verfügbar ($reason) — verkettete Sprache wird verwendet.';
  }

  @override
  String get voice_live_start => 'Sprachgespräch starten';

  @override
  String get voice_live_stop => 'Sprachgespräch beenden';

  @override
  String get voice_live_mute => 'Mikrofon stummschalten';

  @override
  String get voice_live_unmute => 'Mikrofon einschalten';

  @override
  String get voice_live_interrupt => 'Unterbrechen oder jetzt antworten';

  @override
  String get voice_live_listening => 'Hört zu';

  @override
  String get voice_live_speaking => 'Spricht';

  @override
  String get voice_live_thinking => 'Denkt nach';

  @override
  String get voice_live_muted => 'Stumm';

  @override
  String get voice_live_ended_connection_lost =>
      'Die Live-Sprachsitzung hat die Verbindung verloren.';

  @override
  String get voice_live_ended_closed =>
      'Die Live-Sprachsitzung wurde vom Dienst beendet.';

  @override
  String wake_word_other_profile(String profile) {
    return 'Dieses Aktivierungswort gehört zum Profil „$profile“. Öffne eine Verbindung zu diesem Profil, um darauf zu antworten.';
  }

  @override
  String get wake_word_reason_disabled => 'Aus — zum Aktivieren tippen';

  @override
  String get wake_word_reason_surface =>
      'Auf eine andere Oberfläche beschränkt (Konfiguration wake_word.surface)';

  @override
  String get wake_word_reason_owned =>
      'Eine andere Oberfläche belegt die Aktivierungswort-Erkennung';

  @override
  String wake_word_reason_owned_by(String surface) {
    return 'Eine andere Oberfläche ($surface) belegt die Aktivierungswort-Erkennung';
  }

  @override
  String get wake_word_reason_unavailable =>
      'Aktivierungswort auf diesem Gateway nicht verfügbar';

  @override
  String get wake_word_reason_permission_denied =>
      'Mikrofonberechtigung verweigert';

  @override
  String get wake_word_reason_permission_required =>
      'Mikrofonberechtigung erforderlich — zum Aktivieren tippen';

  @override
  String get voice_live_not_enabled =>
      'GPT-Live ist für dieses Profil nicht aktiviert.';

  @override
  String get voice_live_not_available => 'GPT-Live ist nicht verfügbar';

  @override
  String voice_live_start_failed(String error) {
    return 'GPT-Live konnte nicht starten: $error';
  }

  @override
  String voice_direct_stt_timeout(String seconds, String provider) {
    return 'Zeitüberschreitung bei der Transkription nach $seconds s ($provider hat nicht geantwortet)';
  }

  @override
  String voice_direct_stt_error(String provider, String status) {
    return 'STT-Fehler von $provider (HTTP $status)';
  }

  @override
  String voice_direct_tts_failed(String provider) {
    return 'TTS-Anfrage an $provider fehlgeschlagen';
  }

  @override
  String voice_direct_tts_error(String provider, String status) {
    return 'TTS-Fehler von $provider (HTTP $status)';
  }

  @override
  String ng_wake_status_listening(String phrase) {
    return 'Hört zu („$phrase“)';
  }

  @override
  String ng_wake_status_off(String phrase) {
    return 'Aus („$phrase“)';
  }

  @override
  String ng_wire_setting_unavailable(Object setting) {
    return '$setting lässt sich über das gemeinsame Gateway noch nicht ändern';
  }

  @override
  String ng_wire_method_unavailable(Object method) {
    return '$method ist über das gemeinsame Gateway noch nicht verfügbar';
  }

  @override
  String ng_wire_session_options_unsupported(Object options) {
    return 'Das kanonische Gateway unterstützt diese ausdrücklichen Sitzungsoptionen nicht: $options';
  }

  @override
  String get ng_wire_prompt_stale =>
      'Die Abfrage ist veraltet oder nicht verfügbar; verbinde dich neu, bevor du antwortest';

  @override
  String get ng_wire_revision_unavailable =>
      'Die Sitzungsrevision ist nicht verfügbar; öffne die Sitzung erneut, bevor du Metadaten bearbeitest';

  @override
  String get ng_wire_generation_unavailable =>
      'Die Ausführungskennung der Sitzung ist nicht verfügbar; verbinde dich vor diesem Befehl neu';

  @override
  String get ng_wire_message_not_saved =>
      'Diese Nachricht ist noch nicht gespeichert; warte, bis sie abgeschlossen ist, und verzweige dann erneut von ihr';

  @override
  String get ng_wire_not_available =>
      'Über das gemeinsame Gateway noch nicht verfügbar';

  @override
  String get edit_turn_title => 'Diese Eingabe bearbeiten?';

  @override
  String get edit_turn_body =>
      'Die Eingabe wird ab hier erneut ausgeführt. Spätere Runden werden archiviert.';

  @override
  String get edit_turn_send => 'Senden';

  @override
  String get restore_turn_title => 'Auf diesen Sicherungspunkt zurücksetzen?';

  @override
  String get restore_turn_body =>
      'Alles nach dieser Eingabe wird aus dem Gespräch entfernt und die Eingabe ab hier erneut ausgeführt.';

  @override
  String get restore_turn_confirm => 'Zurücksetzen & neu starten';

  @override
  String get edit_turn_later_turns_body =>
      'Dadurch werden spätere Runden aus dem Gespräch archiviert. Fortfahren?';

  @override
  String get session_history => 'Sitzungsverlauf';

  @override
  String get import_claude_or_codex => 'Claude oder Codex importieren';

  @override
  String get ng_session_history => 'Sitzungsverlauf';

  @override
  String get ng_import_claude_or_codex => 'Claude oder Codex importieren';

  @override
  String get ng_edit_and_resend => 'Bearbeiten und erneut senden';

  @override
  String get ng_restore_turn_confirm => 'Zurücksetzen & neu starten';

  @override
  String get rewind_target_unsaved =>
      'Diese Nachricht ist noch nicht gespeichert. Warte, bis sie abgeschlossen ist, und bearbeite sie dann erneut.';

  @override
  String get rewind_turn_busy =>
      'Die aktuelle Antwort wurde noch nicht gestoppt, daher wurde nichts gesendet. Versuche es gleich noch einmal.';

  @override
  String get rewind_session_changed =>
      'Dieser Chat hat sich geändert, seit er hier geöffnet wurde, daher wurde nichts entfernt oder gesendet. Öffne ihn erneut und versuche es noch einmal.';

  @override
  String get history_lineage => 'Verwandte Chats';

  @override
  String get history_lineage_none =>
      'Dieser Chat hat keine Abzweigungen oder Geschwisterzweige.';

  @override
  String get history_lineage_unavailable =>
      'Verwandte Chats konnten von diesem Gateway nicht gelesen werden.';

  @override
  String get history_lineage_parent => 'Ursprung';

  @override
  String get history_lineage_sibling => 'Geschwister';

  @override
  String get history_lineage_fork => 'Abzweigung';

  @override
  String get history_messages => 'Nachrichten';

  @override
  String get history_messages_hint =>
      'Wähle eine gespeicherte Nachricht, um dort abzuzweigen oder zurückzuspulen.';

  @override
  String get history_messages_none => 'Noch keine gespeicherten Nachrichten.';

  @override
  String get history_messages_unavailable =>
      'Die gespeicherten Nachrichten konnten nicht gelesen werden. Öffne diesen Chat und aktualisiere dann.';

  @override
  String get history_role_user => 'Du';

  @override
  String get history_role_assistant => 'Hermes';

  @override
  String get history_branch_here => 'Hier abzweigen';

  @override
  String get history_rewind_here => 'Bis hierher zurückspulen';

  @override
  String get history_branch_title => 'Von dieser Nachricht abzweigen';

  @override
  String get history_branch_body =>
      'Dadurch entsteht ein neuer Chat mit dem Verlauf bis zur ausgewählten Nachricht. Der aktuelle Chat bleibt unverändert.';

  @override
  String get history_rewind_title => 'Bis zu dieser Nachricht zurückspulen';

  @override
  String get history_rewind_body =>
      'Nachrichten ab der ausgewählten werden aus diesem Chat entfernt. Dateien auf dem Computer bleiben unverändert. Sie werden separat über einen Sicherungspunkt wiederhergestellt.';

  @override
  String history_branched(String id) {
    return 'Abgezweigt als $id';
  }

  @override
  String get history_open_chat => 'Chat öffnen';

  @override
  String get history_mutate_unsupported =>
      'Abzweigen und Zurückspulen erfordern Hermes 0.23 oder neuer auf diesem Gateway.';

  @override
  String get history_checkpoints => 'Sicherungspunkte';

  @override
  String get history_checkpoints_none =>
      'Diese Sitzung hat keine Dateisystem-Sicherungspunkte.';

  @override
  String get history_checkpoints_unavailable =>
      'Sicherungspunkte sind auf diesem Gateway nicht verfügbar.';

  @override
  String get history_diff_none => 'Keine Unterschiede.';

  @override
  String get history_diff_loading => 'Änderungen werden geladen…';

  @override
  String get history_diff_failed =>
      'Die Änderungen konnten nicht geladen werden, daher kann dieser Sicherungspunkt noch nicht wiederhergestellt werden.';

  @override
  String get history_restore_checkpoint => 'Sicherungspunkt wiederherstellen';

  @override
  String get history_restore_title => 'Diesen Sicherungspunkt wiederherstellen';

  @override
  String get history_restore_body =>
      'Die Dateien, die der Agent seit diesem Sicherungspunkt geändert hat, werden auf den damaligen Stand zurückgesetzt. Deine eigenen Änderungen bleiben erhalten. Spätere Chat-Nachrichten können ebenfalls entfernt werden. Die Unterhaltung wird nicht abgezweigt.';

  @override
  String get history_restore_body_all =>
      'Jede Datei im Sitzungsordner wird auf diesen Sicherungspunkt zurückgesetzt, auch deine eigenen Änderungen. Spätere Chat-Nachrichten können ebenfalls entfernt werden. Die Unterhaltung wird nicht abgezweigt.';

  @override
  String get history_restore_own_edits =>
      'Auch meine eigenen Änderungen zurücksetzen';

  @override
  String get history_restored => 'Sicherungspunkt wiederhergestellt.';

  @override
  String history_restored_removed(int count) {
    return 'Sicherungspunkt wiederhergestellt. $count Chat-Nachrichten wurden entfernt.';
  }

  @override
  String get history_export => 'Exportieren';

  @override
  String get history_export_redact => 'Tokens schwärzen';

  @override
  String get history_export_action => 'Transkript exportieren';

  @override
  String get history_export_saved => 'Transkript gespeichert.';

  @override
  String get history_export_unsupported =>
      'Der Export erfordert Hermes 0.23 oder neuer auf diesem Gateway.';

  @override
  String get history_import_unsupported =>
      'Der Import aus Claude und Codex wird von diesem Gateway nicht unterstützt.';

  @override
  String history_import_destination(String profile) {
    return 'Zielprofil: $profile.';
  }

  @override
  String history_import_reading(String host, String profile, int count) {
    return 'Gelesen von $host · Zielprofil: $profile. $count Protokolle konnten nicht gelesen werden.';
  }

  @override
  String get history_import_all => 'Alle';

  @override
  String history_import_scan_failed(String reason) {
    return 'Host-Sitzungen konnten nicht durchsucht werden: $reason';
  }

  @override
  String get history_import_none =>
      'Auf diesem Host wurden keine Claude-Code- oder Codex-Sitzungen gefunden.';

  @override
  String get history_import_no_match => 'Keine passenden Host-Sitzungen.';

  @override
  String history_import_preview_failed(String reason) {
    return 'Sitzungsvorschau nicht möglich: $reason';
  }

  @override
  String get history_import_open => 'Importierte Sitzung öffnen';

  @override
  String get history_import_action => 'Ausgewählte Sitzung importieren';

  @override
  String get history_import_title => 'Diese Sitzung importieren';

  @override
  String history_import_body(String profile) {
    return 'Diese Claude- oder Codex-Sitzung in das Profil „$profile“ auf diesem Gateway kopieren.';
  }

  @override
  String history_import_body_existing(String profile) {
    return 'Diese Sitzung wurde bereits in „$profile“ importiert. Mit der vorhandenen Kopie fortfahren.';
  }

  @override
  String history_imported(String id) {
    return 'Importiert als $id';
  }

  @override
  String history_imported_already(String id) {
    return 'Bereits importiert als $id';
  }

  @override
  String history_import_directory(String path) {
    return 'Verzeichnis: $path';
  }

  @override
  String history_import_preview_partial(int shown, int total) {
    return 'Die Vorschau zeigt $shown von $total.';
  }

  @override
  String history_failed(String reason) {
    return 'Nicht abgeschlossen: $reason';
  }

  @override
  String get history_error_unavailable =>
      'Das Gateway konnte das gerade nicht ausführen. Versuche es erneut.';

  @override
  String get history_error_unsupported =>
      'Dieses Gateway unterstützt das nicht.';

  @override
  String get history_error_denied =>
      'Dieses Gateway hat die Anfrage abgelehnt.';

  @override
  String get history_error_changed =>
      'Dieser Chat hat sich geändert, während diese Seite geöffnet war. Aktualisiere und versuche es erneut.';

  @override
  String get history_error_unbound =>
      'Dieser Chat ist auf dem Gateway nicht geöffnet. Öffne ihn und versuche es erneut.';

  @override
  String get history_error_invalid =>
      'Das Gateway hat eine Antwort gesendet, die diese App nicht lesen konnte.';

  @override
  String ng_dock_kanban(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kanban-Karten',
      one: '1 Kanban-Karte',
    );
    return '$_temp0';
  }

  @override
  String ng_dock_kanban_done(int count) {
    return '$count erledigt';
  }

  @override
  String get ng_show_kanban => 'Kanban-Karten anzeigen';

  @override
  String get ng_hide_kanban => 'Kanban-Karten ausblenden';

  @override
  String get ng_kanban_status_triage => 'Sichtung';

  @override
  String get ng_kanban_status_todo => 'Zu erledigen';

  @override
  String get ng_kanban_status_scheduled => 'Geplant';

  @override
  String get ng_kanban_status_ready => 'Bereit';

  @override
  String get ng_kanban_status_running => 'Läuft';

  @override
  String get ng_kanban_status_blocked => 'Blockiert';

  @override
  String get ng_kanban_status_review => 'In Prüfung';

  @override
  String get ng_kanban_status_done => 'Erledigt';

  @override
  String get ng_kanban_status_archived => 'Archiviert';

  @override
  String ng_kanban_open_card(String title) {
    return '$title in Kanban öffnen';
  }

  @override
  String ng_kanban_show_all(int count) {
    return 'Alle $count anzeigen';
  }

  @override
  String ng_kanban_this_chat(int count) {
    return 'Dieser Chat ($count)';
  }

  @override
  String get ng_kanban_close => 'Kanban schließen';

  @override
  String get ng_kanban_block_no_dashboard =>
      'Diese Verbindung hat keinen Dashboard-Zugriff. Der Kartenstatus ist daher nicht live, und das Board lässt sich nicht öffnen.';

  @override
  String get ng_kanban_block_unsupported =>
      'Kanban ist für dieses Gateway nicht aktiviert. Aktiviere das Kanban-Plugin, um den Live-Status zu sehen und das Board zu öffnen.';

  @override
  String get ng_kanban_block_denied =>
      'Melde dich beim Dashboard an, um den Live-Status der Karten zu sehen und das Board zu öffnen.';

  @override
  String get ng_kanban_block_insecure =>
      'Kanban benötigt HTTPS oder eine lokale Verbindung. Der Kartenstatus ist daher nicht live, und das Board lässt sich nicht öffnen.';

  @override
  String get ng_kanban_block_unreachable =>
      'Kanban ist auf diesem Gateway nicht erreichbar. Der Kartenstatus ist möglicherweise veraltet.';

  @override
  String get ng_kanban_block_stale =>
      'Die Verbindung hat sich geändert. Öffne diesen Chat erneut, um den Live-Status der Karten zu sehen.';

  @override
  String get ng_bots_tab_roster => 'Team';

  @override
  String get ng_bots_tab_rooms => 'Räume';

  @override
  String get ng_bots_tab_screen => 'Bildschirm';

  @override
  String get ng_bots_tab_routines => 'Routinen';

  @override
  String ng_bots_rooms_load_failed(String error) {
    return 'Räume konnten nicht geladen werden: $error';
  }

  @override
  String ng_bots_routines_load_failed(String error) {
    return 'Routinen konnten nicht geladen werden: $error';
  }

  @override
  String ng_bots_desktop_failed(String error) {
    return 'Bot Desktop: $error';
  }

  @override
  String get ng_bots_install_not_started =>
      'Das Gateway hat die Installation nicht gestartet.';

  @override
  String ng_bots_install_failed_error(String error) {
    return 'Installation fehlgeschlagen: $error';
  }

  @override
  String get ng_bots_install_cancelled => 'Die Installation wurde abgebrochen.';

  @override
  String get ng_bots_install_no_sudo =>
      'sudo ist auf dem Gateway-Host nicht verfügbar. Führe den obigen Befehl dort aus und aktualisiere dann.';

  @override
  String ng_bots_install_exit_code(String code) {
    return 'Die Installation ist fehlgeschlagen (Exit-Code $code).';
  }

  @override
  String ng_bots_install_done(String bot) {
    return 'Bot Desktop für $bot installiert';
  }

  @override
  String get ng_bots_start_failed => 'Start fehlgeschlagen';

  @override
  String ng_bots_stop_title(String bot) {
    return 'Bot Desktop für $bot stoppen?';
  }

  @override
  String get ng_bots_stop_human_held =>
      'Jemand steuert gerade diesen Bildschirm. Durch das Stoppen endet die Sitzung dieser Person und alles, was darauf geöffnet ist, wird geschlossen.';

  @override
  String get ng_bots_stop_body =>
      'Alles, was auf dem Bildschirm des Bots geöffnet ist, wird geschlossen.';

  @override
  String get ng_bots_stop_refused => 'Stoppen abgelehnt';

  @override
  String get ng_bots_take_over_reason => 'Übernahme aus Ares';

  @override
  String ng_bots_take_over_failed(String error) {
    return 'Übernahme fehlgeschlagen: $error';
  }

  @override
  String ng_bots_force_hand_back_title(String bot) {
    return 'Bildschirm von $bot an den Bot zurückgeben?';
  }

  @override
  String get ng_bots_force_hand_back_body =>
      'Eine Person steuert diesen Bildschirm. Falls sie ihn noch nutzt, verliert sie die Kontrolle.';

  @override
  String get ng_bots_hand_back => 'Zurückgeben';

  @override
  String get ng_bots_hand_back_failed => 'Zurückgeben fehlgeschlagen';

  @override
  String get ng_bots_adopt_title => 'Neues Sandbox-Image übernehmen?';

  @override
  String ng_bots_adopt_body(String bot, String current, String target) {
    return '$bot wechselt von $current zu $target. Der Container wird beim nächsten Terminal-Aufruf neu erstellt; alles, was nur im aktuellen Container liegt, geht verloren.';
  }

  @override
  String get ng_bots_adopt_image => 'Image übernehmen';

  @override
  String get ng_bots_image_switch_failed => 'Image-Wechsel fehlgeschlagen';

  @override
  String get ng_bots_keep_refused => 'Beibehalten abgelehnt';

  @override
  String ng_bots_chat_open_failed(String error) {
    return 'Bot Chat konnte nicht geöffnet werden: $error';
  }

  @override
  String ng_bots_title(String connection) {
    return 'Bots · $connection';
  }

  @override
  String get ng_bots_protocol_tooltip =>
      'Das Gateway fügt das Protokoll für Teamnachrichten selbst ein — es wird kein zusätzliches SOUL.md-Protokoll gesendet.';

  @override
  String ng_bots_unavailable(String reason) {
    return 'Bots nicht verfügbar ($reason)';
  }

  @override
  String get ng_bots_account_changed =>
      'Das Konto hat sich geändert. Verbinde dich neu oder aktualisiere.';

  @override
  String get ng_bots_try_refresh =>
      'Versuche zu aktualisieren. Falls das Problem bleibt, unterstützt das Gateway eventuell keine Bots.';

  @override
  String get ng_bots_search => 'Bots durchsuchen';

  @override
  String get ng_bots_none_found => 'Keine Bots gefunden.';

  @override
  String get ng_bots_no_model => 'kein Modell';

  @override
  String ng_bots_skill_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Skills',
      one: '1 Skill',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_bot_chat => 'Bot Chat';

  @override
  String ng_bots_install_id(String id, String protocol) {
    return 'Gateway meldet Installations-ID $id · bot_mode_protocol: $protocol';
  }

  @override
  String get ng_bots_protocol_note =>
      'Das Gateway fügt das Protokoll für Teamnachrichten ein, wenn bot_mode_protocol gesetzt ist. Handle: default→hermes, sonst der Profilname.';

  @override
  String get ng_bots_no_rooms =>
      'Noch keine Räume. Erstelle einen aus deinem Team.';

  @override
  String ng_bots_member_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Mitglieder',
      one: '1 Mitglied',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_room_disbanded => 'aufgelöst';

  @override
  String get ng_bots_room_adopted => 'übernommen';

  @override
  String get ng_bots_rooms_gateway => 'Gateway-Räume';

  @override
  String get ng_bots_rooms_desktop => 'Desktop-gesteuerte Räume';

  @override
  String ng_bots_rooms_gateway_body(String methods) {
    return 'Räume gehören dem Gateway. Methoden: $methods.';
  }

  @override
  String get ng_bots_rooms_no_seat =>
      'Dieses Gateway kann Räume eventuell nicht bereitstellen (dauerhafter Prozess erforderlich).';

  @override
  String get ng_bots_rooms_fallback =>
      'Klassischer Fallback: Der Desktop steuert die Gruppenrunden (hier nicht neu erstellt).';

  @override
  String get ng_bots_create_room => 'Raum erstellen';

  @override
  String get ng_bots_refresh_rooms => 'Räume aktualisieren';

  @override
  String get ng_bots_room_created => 'Raum erstellt';

  @override
  String ng_bots_room_refused(String reason) {
    return 'Raumerstellung abgelehnt ($reason)';
  }

  @override
  String ng_bots_room_failed(String error) {
    return 'Raumerstellung fehlgeschlagen: $error';
  }

  @override
  String get ng_bots_bot => 'Bot';

  @override
  String get ng_bots_screen_unavailable => 'Bildschirmstatus nicht verfügbar';

  @override
  String get ng_bots_screen_unavailable_body =>
      'Starte den Bildschirm des Bots, um sein Vorschaubild zu sehen, oder übernimm ihn, um ihn selbst zu nutzen.';

  @override
  String get ng_bots_take_over_note =>
      '„Übernehmen“ öffnet den Live-Bildschirm und gibt dir die Kontrolle darüber. Die Kontrolle geht an den Bot zurück, wenn du den Live-Bildschirm schließt, diese Seite verlässt oder die App in den Hintergrund schickst.';

  @override
  String get ng_bots_not_installed => 'Nicht installiert';

  @override
  String get ng_bots_unsupported_host => 'Nicht unterstützter Host';

  @override
  String ng_bots_pid(String pid) {
    return 'pid $pid';
  }

  @override
  String ng_bots_missing(String items) {
    return 'fehlt: $items';
  }

  @override
  String ng_bots_blocked(String reason) {
    return 'blockiert: $reason';
  }

  @override
  String get ng_bots_no_switch => 'Kein Sandbox-Image-Wechsel ausstehend.';

  @override
  String ng_bots_switch_image(String current, String target) {
    return 'Image-Wechsel: $current → $target';
  }

  @override
  String get ng_bots_bot_in_control => 'der Bot hat die Kontrolle';

  @override
  String get ng_bots_person_in_control => 'eine Person hat die Kontrolle';

  @override
  String get ng_bots_installing =>
      'Bot Desktop wird auf dem Gateway-Host installiert…';

  @override
  String get ng_bots_install_unfinished =>
      'Die Installation wurde nicht abgeschlossen';

  @override
  String get ng_bots_install => 'Installieren';

  @override
  String get ng_bots_start => 'Starten';

  @override
  String get ng_bots_take_over => 'Übernehmen';

  @override
  String get ng_bots_keep_image => 'Aktuelles Image behalten';

  @override
  String ng_bots_missing_pieces(String items) {
    return 'Das Gateway meldet fehlende Komponenten: $items';
  }

  @override
  String get ng_bots_install_missing => 'Fehlende Komponenten installieren';

  @override
  String get ng_bots_thumbnail_unavailable => 'Vorschaubild nicht verfügbar';

  @override
  String get ng_bots_thumbnail_title => 'Bildschirmvorschau (live)';

  @override
  String get ng_bots_thumbnail_suppressed =>
      'Vorschaubild ausgeblendet, solange eine Person den Bildschirm steuert.';

  @override
  String get ng_bots_thumbnail_pending => 'Vorschaubild noch nicht verfügbar.';

  @override
  String ng_bots_routines_of(String bot) {
    return '$bot · Routinen';
  }

  @override
  String get ng_bots_add_routine => 'Routine hinzufügen';

  @override
  String get ng_bots_no_routines => 'Keine Routinen für diesen Bot.';

  @override
  String get ng_bots_routines_note =>
      'Routinen sind mit [bot:<name>] markierte Jobs im Profilspeicher des Bots. Ältere delegierte Routinen werden beim Laden zwangsweise pausiert.';

  @override
  String ng_bots_routine_last(String status) {
    return 'zuletzt: $status';
  }

  @override
  String ng_bots_routine_next(String time) {
    return 'nächste: $time';
  }

  @override
  String ng_bots_routine_error(String error) {
    return 'Fehler: $error';
  }

  @override
  String ng_bots_remove_routine_title(String routine) {
    return 'Routine $routine entfernen?';
  }

  @override
  String ng_bots_remove_routine_body(String bot) {
    return 'Die Routine wird aus dem Zeitplan von $bot gelöscht. Das kann nicht rückgängig gemacht werden.';
  }

  @override
  String ng_bots_routine_action_failed(String action, String error) {
    return '$action fehlgeschlagen: $error';
  }

  @override
  String get ng_bots_not_connected => 'Nicht verbunden.';

  @override
  String ng_bots_add_failed(String error) {
    return 'Hinzufügen fehlgeschlagen: $error';
  }

  @override
  String get ng_bots_routine_added => 'Routine hinzugefügt';

  @override
  String get ng_bots_routine_enabled => 'aktiviert';

  @override
  String get ng_bots_routine_paused => 'pausiert';

  @override
  String ng_bots_path(String path) {
    return 'Pfad: $path';
  }

  @override
  String get ng_bots_chat_present => 'Bot Chat vorhanden';

  @override
  String get ng_bots_chat_missing => 'Bot Chat fehlt';

  @override
  String ng_bots_last_session(String preview) {
    return 'Letzte Sitzung: $preview';
  }

  @override
  String get ng_bots_open_chat => 'Bot Chat öffnen';

  @override
  String get ng_bots_desktop => 'Bot Desktop';

  @override
  String get ng_bots_room_name => 'Raumname';

  @override
  String get ng_bots_select_member => 'Wähle mindestens ein Mitglied aus.';

  @override
  String get ng_bots_sudo_title => 'Administratorpasswort';

  @override
  String ng_bots_sudo_body(String bot) {
    return 'Die Installation von Bot Desktop für $bot erfordert sudo auf dem Gateway-Host. Das Passwort wird nur für diese Installation an dieses Gateway gesendet und nicht gespeichert.';
  }

  @override
  String get ng_bots_sudo_password => 'sudo-Passwort';

  @override
  String get ng_bots_new_routine => 'Neue Routine';

  @override
  String get ng_bots_routine_title => 'Titel';

  @override
  String get ng_bots_routine_instruction => 'Anweisung';

  @override
  String get ng_bots_cron => 'Cron-Ausdruck';

  @override
  String get ng_bots_interval => 'Intervall';

  @override
  String get ng_bots_cron_help => '0 9 * * * läuft täglich um 09:00';

  @override
  String get ng_bots_every => 'Alle';

  @override
  String get ng_bots_unit_minutes => 'Minuten';

  @override
  String get ng_bots_unit_hours => 'Stunden';

  @override
  String get ng_bots_unit_days => 'Tage';

  @override
  String get ng_bots_stop_after => 'Stoppen nach (Läufen)';

  @override
  String get ng_bots_stop_after_help =>
      'Leer lassen für unbegrenzte Ausführung';

  @override
  String get ng_bots_send_results => 'Ergebnisse senden an';

  @override
  String get ng_bots_run_history => 'Nur Ausführungsverlauf';

  @override
  String get ng_bots_continuity => 'An den vorherigen Lauf anknüpfen';

  @override
  String get ng_bots_account_changed_refresh =>
      'Konto geändert. Aktualisiere, bevor du fortfährst.';

  @override
  String ng_bots_room_load_failed(String error) {
    return 'Raum konnte nicht geladen werden: $error';
  }

  @override
  String ng_bots_send_failed(String error) {
    return 'Senden fehlgeschlagen: $error';
  }

  @override
  String ng_bots_stop_failed(String error) {
    return 'Stoppen fehlgeschlagen: $error';
  }

  @override
  String get ng_bots_stop_room => 'Raum stoppen';

  @override
  String get ng_bots_send_message => 'Nachricht senden';

  @override
  String get ng_bots_room_hint =>
      'Nachricht an den Raum (Mitglieder mit @handle erwähnen)';

  @override
  String get ng_bots_history => 'Verlauf';

  @override
  String ng_bots_revision(String revision) {
    return 'Revision $revision';
  }

  @override
  String ng_bots_last_error(String error) {
    return 'letzter Fehler: $error';
  }

  @override
  String get ng_bots_members => 'Mitglieder';

  @override
  String get ng_bots_room_context => 'Raumkontext';

  @override
  String ng_bots_purpose(String purpose) {
    return 'Zweck: $purpose';
  }

  @override
  String ng_bots_notes(String notes) {
    return 'Notizen: $notes';
  }

  @override
  String ng_bots_routing(String routing) {
    return 'Routing: $routing';
  }

  @override
  String ng_bots_lead(String member) {
    return 'Leitung $member';
  }

  @override
  String get ng_bots_viewer_you_control =>
      'Du steuerst diesen Bildschirm. Der Bot wartet, bis du ihn zurückgibst.';

  @override
  String get ng_bots_viewer_handed_back =>
      'Die Kontrolle liegt wieder beim Bot.';

  @override
  String get ng_bots_viewer_background =>
      'Die Kontrolle ging an den Bot zurück, weil die App nicht mehr im Vordergrund ist.';

  @override
  String get ng_bots_viewer_taken =>
      'Jemand anderes hat die Kontrolle über diesen Bildschirm übernommen.';

  @override
  String get ng_bots_viewer_lost =>
      'Die Live-Ansicht wurde unterbrochen, daher ging die Kontrolle an den Bot zurück.';

  @override
  String ng_bots_viewer_title(String bot) {
    return 'Bot Desktop · $bot';
  }

  @override
  String get ng_bots_viewer_type_hint => 'Auf dem Bildschirm des Bots tippen';

  @override
  String get ng_bots_viewer_type => 'Eintippen';

  @override
  String get ng_bots_viewer_enter => 'Eingabe';

  @override
  String get ng_bots_viewer_backspace => 'Rücktaste';

  @override
  String get ng_more_kanban => 'Kanban';

  @override
  String get ng_more_kanban_subtitle =>
      'Boards, Aufgabenabhängigkeiten, Worker-Zuweisung und Logs';

  @override
  String get ng_more_bots => 'Bots';

  @override
  String get ng_more_bots_subtitle => 'Team, Räume, Routinen und Bot Desktop';

  @override
  String get ng_slash_kanban => 'Kanban-Board öffnen';

  @override
  String get ng_slash_bots => 'Deine Bots öffnen';

  @override
  String ng_board_card_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Karten',
      one: '1 Karte',
    );
    return '$_temp0';
  }

  @override
  String ng_board_event_toast(String task, String event) {
    return 'Kanban $task: $event';
  }

  @override
  String get ng_board_task => 'Aufgabe';

  @override
  String ng_board_refused_http(String status) {
    return 'Aktion abgelehnt (HTTP $status).';
  }

  @override
  String get ng_board_err_unsupported =>
      'Das Kanban-Plugin ist auf diesem Gateway nicht aktiviert.';

  @override
  String get ng_board_err_denied =>
      'Anmeldung oder Berechtigung auf diesem Gateway erforderlich.';

  @override
  String get ng_board_err_stale =>
      'Der Gateway-Besitzer hat sich geändert. Aktualisiere, bevor du fortfährst.';

  @override
  String get ng_board_err_insecure =>
      'Für Kanban-Workspace-Vorgänge ist HTTPS (oder Loopback) erforderlich.';

  @override
  String get ng_board_err_unreachable =>
      'Der Kanban-Dienst auf diesem Gateway ist nicht erreichbar.';

  @override
  String get ng_board_err_failed =>
      'Vorgang fehlgeschlagen. Aktualisiere und versuche es erneut.';

  @override
  String ng_board_block_title(String task) {
    return '$task blockieren';
  }

  @override
  String get ng_board_block_reason => 'Grund der Blockierung';

  @override
  String get ng_board_block_hint => 'Was blockiert diese Karte?';

  @override
  String ng_board_review_title(String task) {
    return 'Review für $task anfordern';
  }

  @override
  String get ng_board_review_summary => 'Review-Zusammenfassung';

  @override
  String get ng_board_review_hint => 'Was wurde umgesetzt und überprüft?';

  @override
  String ng_board_move_title(String cards, String column) {
    return '$cards nach $column verschieben?';
  }

  @override
  String ng_board_move_body(String board) {
    return 'Jede ausgewählte Karte auf $board wechselt die Spalte. Laufende Karten werden gestoppt.';
  }

  @override
  String get ng_board_move => 'Verschieben';

  @override
  String ng_board_moved(String column) {
    return 'Karten nach $column verschoben';
  }

  @override
  String ng_board_unassign_title(String cards) {
    return 'Zuweisung von $cards aufheben?';
  }

  @override
  String ng_board_assign_title(String cards, String profile) {
    return '$cards @$profile zuweisen?';
  }

  @override
  String get ng_board_assign_body =>
      'Laufende Karten werden zuerst zurückgeholt: Ihre Worker werden gestoppt.';

  @override
  String get ng_board_unassign => 'Zuweisung aufheben';

  @override
  String get ng_board_assign => 'Zuweisen';

  @override
  String get ng_board_unassigned_done =>
      'Zuweisung der ausgewählten Karten aufgehoben';

  @override
  String ng_board_assigned_done(String profile) {
    return '@$profile zugewiesen';
  }

  @override
  String ng_board_archive_title(String cards) {
    return '$cards archivieren?';
  }

  @override
  String ng_board_archive_body(String board) {
    return 'Archivierte Karten verschwinden von $board. Aktiviere „Archiviert“, um sie wieder zu sehen.';
  }

  @override
  String get ng_board_archived_done => 'Ausgewählte Karten archiviert';

  @override
  String ng_board_delete_title(String cards) {
    return '$cards löschen?';
  }

  @override
  String ng_board_delete_body(String board) {
    return 'Dadurch werden die ausgewählten Karten dauerhaft von $board gelöscht.';
  }

  @override
  String ng_board_deleted(String cards) {
    return '$cards gelöscht.';
  }

  @override
  String ng_board_partial_failure(String failed, String total, String reason) {
    return '$failed von $total fehlgeschlagen: $reason';
  }

  @override
  String get ng_board_refused => 'abgelehnt';

  @override
  String ng_board_dispatched(
    String spawned,
    String promoted,
    String reclaimed,
  ) {
    return 'Verteilt: $spawned gestartet, $promoted hochgestuft, $reclaimed zurückgeholt.';
  }

  @override
  String ng_board_board_archived(String board) {
    return 'Board $board archiviert';
  }

  @override
  String ng_board_board_archived_to(String path) {
    return 'Archiviert unter $path';
  }

  @override
  String ng_board_exported(String board, String archive) {
    return '$board nach $archive exportiert';
  }

  @override
  String ng_board_imported(String board, String warnings) {
    return 'Board $board importiert$warnings';
  }

  @override
  String ng_board_created(String task) {
    return '$task erstellt';
  }

  @override
  String get ng_board_orchestration_saved =>
      'Kanban-Orchestrierung gespeichert';

  @override
  String get ng_board_auto_describe_unavailable =>
      'Automatische Beschreibung nicht verfügbar';

  @override
  String ng_board_description_updated(String profile) {
    return 'Beschreibung von @$profile aktualisiert';
  }

  @override
  String ng_board_title(String board) {
    return 'Kanban · $board';
  }

  @override
  String ng_board_active(String count) {
    return '$count aktiv';
  }

  @override
  String get ng_board_dispatch => 'Bereite Aufgaben jetzt verteilen';

  @override
  String get ng_board_orchestration => 'Orchestrierung & Worker';

  @override
  String get ng_board_new_task => 'Neue Aufgabe';

  @override
  String get ng_board_enable_plugin =>
      'Aktiviere auf diesem Gateway unter Funktionen → Plugins das mitgelieferte Plugin „kanban“, um seinen Board-Router zu aktivieren.';

  @override
  String get ng_board_filter => 'Aufgaben filtern…';

  @override
  String get ng_board_all_assignees => 'Alle Bearbeiter';

  @override
  String get ng_board_unassigned => 'Nicht zugewiesen';

  @override
  String get ng_board_running_by_profile => 'Laufend nach Profil';

  @override
  String get ng_board_select => 'Auswählen';

  @override
  String ng_board_selected_chip(String count) {
    return 'Ausgewählt ($count)';
  }

  @override
  String get ng_board_locked_column =>
      'Verwaltete Spalte — Drag & Drop deaktiviert';

  @override
  String ng_board_add_to(String column) {
    return 'Zu $column hinzufügen';
  }

  @override
  String ng_board_collapse(String column) {
    return '$column einklappen';
  }

  @override
  String ng_board_column_empty(String column) {
    return 'Keine Aufgaben in $column';
  }

  @override
  String get ng_board_drop_here => 'Ablegen oder + Aufgabe';

  @override
  String get ng_board_card_actions => 'Kartenaktionen';

  @override
  String get ng_board_open_details => 'Details öffnen';

  @override
  String get ng_board_select_card => 'Karte auswählen';

  @override
  String ng_board_move_to(String column) {
    return 'Nach $column verschieben';
  }

  @override
  String get ng_board_parked => 'Geparkt';

  @override
  String ng_board_blocked_by(String count) {
    return 'Blockiert durch $count';
  }

  @override
  String get ng_board_goal_loop => 'Zielschleife';

  @override
  String ng_board_selected(String count) {
    return '$count ausgewählt';
  }

  @override
  String get ng_board_move_menu => 'Verschieben…';

  @override
  String get ng_board_assign_menu => 'Zuweisen…';

  @override
  String get ng_board_new_board_title => 'Neues Kanban-Board';

  @override
  String get ng_board_slug => 'Slug (Kleinbuchstaben, z. B. release-v5)';

  @override
  String get ng_board_display_name => 'Anzeigename';

  @override
  String get ng_board_linked_project => 'Verknüpftes Projekt (optional)';

  @override
  String get ng_board_none => 'Keins';

  @override
  String get ng_board_default_workdir =>
      'Standard-Arbeitsverzeichnis auf dem Host (optional)';

  @override
  String get ng_board_import_title => 'Board-Archiv importieren';

  @override
  String get ng_board_import_path => 'Pfad zum .tar.gz-Archiv auf dem Host';

  @override
  String get ng_board_import => 'Importieren';

  @override
  String ng_board_edit_board(String board) {
    return '$board bearbeiten';
  }

  @override
  String get ng_board_name => 'Name';

  @override
  String get ng_board_description => 'Beschreibung';

  @override
  String get ng_board_workdir_clear =>
      'Standard-Arbeitsverzeichnis (leer = entfernen)';

  @override
  String get ng_board_boards => 'Kanban-Boards';

  @override
  String get ng_board_new_board => 'Neues Board';

  @override
  String get ng_board_search_boards => 'Boards durchsuchen…';

  @override
  String get ng_board_unpin => 'Tab lösen';

  @override
  String get ng_board_pin => 'Tab anheften';

  @override
  String ng_board_archive_board_title(String board) {
    return 'Board $board archivieren?';
  }

  @override
  String ng_board_archive_board_body(String cards) {
    return 'Das Board und seine $cards verschwinden aus der Board-Liste. Das Gateway behält ein Archiv auf seinem Host.';
  }

  @override
  String get ng_board_edit_metadata => 'Metadaten bearbeiten';

  @override
  String get ng_board_export => 'Als .tar.gz auf dem Host exportieren';

  @override
  String get ng_board_move_pin_left =>
      'Angehefteten Tab nach links verschieben';

  @override
  String get ng_board_archive_board => 'Board archivieren';

  @override
  String get ng_board_new_task_title => 'Neue Kanban-Aufgabe';

  @override
  String get ng_board_title_required => 'Titel *';

  @override
  String get ng_board_spec => 'Spezifikation & Akzeptanzkriterien';

  @override
  String get ng_board_estimate => 'Schätzung';

  @override
  String ng_board_estimate_draft(String complexity, String tokens) {
    return 'Komplexität $complexity (~$tokens tok — nur Token-Schätzung, keine Kostenangabe in Dollar)';
  }

  @override
  String get ng_board_estimate_unavailable => 'Schätzung nicht verfügbar';

  @override
  String get ng_board_initial_column => 'Anfangsspalte';

  @override
  String get ng_board_worker_assignee => 'Zuständiger Worker';

  @override
  String get ng_board_parked_unassigned => 'Geparkt (nicht zugewiesen)';

  @override
  String get ng_board_priority => 'Priorität';

  @override
  String get ng_board_workspace => 'Arbeitsbereich';

  @override
  String get ng_board_scratch => 'Temporär';

  @override
  String get ng_board_worktree => 'Git-Worktree';

  @override
  String get ng_board_shared_dir => 'Gemeinsames Verzeichnis';

  @override
  String get ng_board_workspace_path => 'Arbeitsbereichspfad auf dem Host';

  @override
  String get ng_board_parent => 'Übergeordnete Abhängigkeit (optional)';

  @override
  String get ng_board_skills => 'Angeheftete Skills (kommagetrennt, optional)';

  @override
  String get ng_board_provider_override => 'Anbieter überschreiben';

  @override
  String get ng_board_model_override => 'Modell überschreiben';

  @override
  String get ng_board_reasoning => 'Denkaufwand';

  @override
  String get ng_board_profile_default => 'Profilstandard';

  @override
  String get ng_board_xhigh => 'Sehr hoch';

  @override
  String get ng_board_goal_mode => 'Zielschleifen-Modus';

  @override
  String get ng_board_goal_turns => 'Max. Runden für Ziel (leer = Standard)';

  @override
  String get ng_board_create_task => 'Aufgabe erstellen';

  @override
  String get ng_board_orchestration_title => 'Orchestrierung & Worker-Profile';

  @override
  String ng_board_orchestrator(String profile) {
    return 'Orchestrator-Profil (aufgelöst: $profile)';
  }

  @override
  String get ng_board_inherit_default => 'Aktiven Standard übernehmen';

  @override
  String ng_board_default_assignee(String profile) {
    return 'Standard-Bearbeiter (aufgelöst: $profile)';
  }

  @override
  String get ng_board_auto_decompose => 'Triage-Karten automatisch zerlegen';

  @override
  String get ng_board_auto_decompose_help =>
      'Verwendet das konfigurierte kanban_decomposer-Modell für Triage-Aufgaben';

  @override
  String get ng_board_save_orchestration => 'Orchestrierung speichern';

  @override
  String get ng_board_worker_descriptions =>
      'Beschreibungen der Worker-Spezialisierung';

  @override
  String ng_board_worker_label(String profile, String model, String skills) {
    return '@$profile ($model · $skills)';
  }

  @override
  String get ng_board_default_model => 'Standardmodell';

  @override
  String get ng_board_save_description => 'Beschreibung speichern';

  @override
  String get ng_board_auto_describe =>
      'Automatisch aus Skills & Persona beschreiben';

  @override
  String get ng_board_manual_block => 'Manuelle Blockierung durch Operator';

  @override
  String get ng_board_requested_review => 'Review angefordert';

  @override
  String ng_board_requeue_title(String task) {
    return '$task erneut einreihen?';
  }

  @override
  String get ng_board_requeue_body =>
      'Ein Worker, der diese Karte ausführt, wird gestoppt, und die Karte kommt zurück in die Warteschlange.';

  @override
  String get ng_board_requeue => 'Erneut einreihen';

  @override
  String ng_board_reassign_title(String task, String profile) {
    return '$task @$profile neu zuweisen?';
  }

  @override
  String get ng_board_reassign_body =>
      'Diese Karte läuft: Ihr Worker wird zuerst gestoppt.';

  @override
  String get ng_board_reassign => 'Neu zuweisen';

  @override
  String ng_board_saved_task(String task) {
    return 'Aufgabe $task gespeichert';
  }

  @override
  String get ng_board_commented_requeued =>
      'Kommentar gepostet und Aufgabe erneut eingereiht';

  @override
  String get ng_board_commented => 'Kommentar gepostet';

  @override
  String ng_board_requeued(String task) {
    return '$task erneut eingereiht';
  }

  @override
  String get ng_board_decompose_failed => 'Zerlegen fehlgeschlagen.';

  @override
  String ng_board_decompose_failed_reason(String reason) {
    return 'Zerlegen fehlgeschlagen: $reason';
  }

  @override
  String ng_board_decomposed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'In $count Unteraufgaben zerlegt',
      one: 'In 1 Unteraufgabe zerlegt',
    );
    return '$_temp0';
  }

  @override
  String get ng_board_no_children => 'Es wurden keine Unteraufgaben erstellt.';

  @override
  String ng_board_no_children_reason(String reason) {
    return 'Es wurden keine Unteraufgaben erstellt: $reason';
  }

  @override
  String ng_board_uploaded(String file) {
    return '$file hochgeladen';
  }

  @override
  String ng_board_linked_parent(String task) {
    return 'Übergeordnete Aufgabe $task verknüpft';
  }

  @override
  String ng_board_unlinked_parent(String task) {
    return 'Verknüpfung zur übergeordneten Aufgabe $task entfernt';
  }

  @override
  String get ng_board_task_load_failed => 'Aufgabe konnte nicht geladen werden';

  @override
  String get ng_board_refresh_task => 'Aufgabe aktualisieren';

  @override
  String get ng_board_tab_overview => 'Übersicht';

  @override
  String get ng_board_tab_comments => 'Kommentare & Links';

  @override
  String get ng_board_tab_runs => 'Läufe & Log';

  @override
  String get ng_board_tab_events => 'Ereignisse';

  @override
  String get ng_board_decompose => 'Zerlegen';

  @override
  String get ng_board_attach => 'Datei anhängen';

  @override
  String ng_board_estimate_task(
    String complexity,
    String tokens,
    String rationale,
  ) {
    return 'Schätzung: $complexity · ~$tokens Token ($rationale) — keine Kostenangabe in Dollar.';
  }

  @override
  String get ng_board_no_rationale => 'keine Begründung';

  @override
  String get ng_board_status => 'Status';

  @override
  String get ng_board_assignee => 'Bearbeiter';

  @override
  String get ng_board_title_label => 'Titel';

  @override
  String get ng_board_body => 'Inhalt / Spezifikation';

  @override
  String get ng_board_save_changes => 'Änderungen speichern';

  @override
  String get ng_board_clear_model => 'Modellüberschreibung entfernen';

  @override
  String ng_board_blocked_reason(String reason) {
    return 'Blockierungsgrund: $reason';
  }

  @override
  String ng_board_result(String result) {
    return 'Ergebnis: $result';
  }

  @override
  String ng_board_parents(String count) {
    return 'Blockiert durch (übergeordnet · $count)';
  }

  @override
  String get ng_board_add_parent => '+ Übergeordnete hinzufügen';

  @override
  String ng_board_children(String count) {
    return 'Blockiert (untergeordnet · $count)';
  }

  @override
  String ng_board_attachments(String count) {
    return 'Anhänge ($count)';
  }

  @override
  String get ng_board_worker => 'Worker';

  @override
  String ng_board_comments(String count) {
    return 'Kommentare ($count)';
  }

  @override
  String get ng_board_comment_hint =>
      'Kommentar / Hinweise für den Worker hinzufügen';

  @override
  String get ng_board_post_comment => 'Kommentar posten';

  @override
  String get ng_board_comment_requeue => 'Kommentieren & erneut einreihen';

  @override
  String ng_board_runs(String count) {
    return 'Läufe ($count)';
  }

  @override
  String get ng_board_no_runs => 'Noch keine Worker-Läufe erfasst.';

  @override
  String ng_board_run_error(String error) {
    return 'Fehler: $error';
  }

  @override
  String ng_board_log_tail_truncated(String bytes) {
    return 'Ende des Worker-Logs ($bytes B, gekürzt)';
  }

  @override
  String ng_board_log_tail(String bytes) {
    return 'Ende des Worker-Logs ($bytes B)';
  }

  @override
  String get ng_board_refresh_log => 'Log aktualisieren';

  @override
  String get ng_board_no_log => 'Keine Worker-Log-Ausgabe.';

  @override
  String get ng_board_no_events => 'Keine Ereignisse erfasst.';

  @override
  String get ng_bots_room_unknown => 'unbekannt';

  @override
  String get ng_bots_room_blocked => 'blockiert';

  @override
  String get ng_bots_room_working => 'arbeitet';

  @override
  String get ng_bots_room_running => 'läuft';

  @override
  String get ng_bots_room_idle => 'inaktiv';

  @override
  String ng_board_run_title(String id, String profile, String outcome) {
    return 'Lauf #$id · @$profile · $outcome';
  }

  @override
  String get ng_bots_new_bot => 'Neuer Bot';

  @override
  String get ng_bots_new_bot_hint =>
      'Ein benannter Teamkollege mit eigenem Gedächtnis, eigenen Skills und eigenem Chat. Er kann deinen anderen Agenten schreiben.';

  @override
  String get ng_bots_field_name => 'Name';

  @override
  String get ng_bots_field_title => 'Titel';

  @override
  String get ng_bots_field_description => 'Beschreibung';

  @override
  String get ng_bots_description_hint => 'Wobei soll dieser Bot helfen?';

  @override
  String get ng_bots_name_invalid =>
      'Kleinbuchstaben, Ziffern, Bindestriche oder Unterstriche verwenden; mit Buchstabe oder Ziffer beginnen (höchstens 64 Zeichen).';

  @override
  String ng_bots_name_taken(String name) {
    return 'Ein Agent namens „$name“ existiert bereits.';
  }

  @override
  String ng_bots_profile_id(String id) {
    return 'Profil-ID: $id';
  }

  @override
  String get ng_bots_advanced =>
      'Erweitert — Modell, Skills, Toolsets, SOUL.md';

  @override
  String get ng_bots_clone_from => 'Von Profil klonen';

  @override
  String get ng_bots_clone_main => 'Hauptprofil (default)';

  @override
  String get ng_bots_fresh_profile => 'Neues Profil (mitgelieferte Skills)';

  @override
  String get ng_bots_create_empty =>
      'Leer anlegen (mitgelieferte Skills überspringen)';

  @override
  String get ng_bots_share_keys =>
      'Schlüssel und Konten mit dem Hauptprofil teilen';

  @override
  String get ng_bots_provider => 'Anbieter';

  @override
  String get ng_bots_model => 'Modell';

  @override
  String get ng_bots_model_pair => 'Anbieter und Modell angeben.';

  @override
  String get ng_bots_soul =>
      'SOUL.md (optional — ersetzt die erzeugte Persona)';

  @override
  String get ng_bots_soul_edit => 'SOUL.md';

  @override
  String get ng_bots_creating => 'Wird erstellt…';

  @override
  String get ng_bots_create_bot => 'Bot erstellen';

  @override
  String ng_bots_created(String name) {
    return 'Bot „$name“ erstellt';
  }

  @override
  String get ng_bots_look_failed =>
      'Das Aussehen wurde nicht auf dem Gateway gespeichert; lege es unter „Profil bearbeiten“ fest.';

  @override
  String ng_bots_request_failed(String reason) {
    return 'Das Gateway hat es nicht angenommen ($reason).';
  }

  @override
  String get ng_bots_avatar_shape => 'Form';

  @override
  String ng_bots_avatar_shape_n(int n) {
    return 'Form $n';
  }

  @override
  String get ng_bots_avatar_colour => 'Farbe';

  @override
  String ng_bots_avatar_colour_n(int n) {
    return 'Farbe $n';
  }

  @override
  String get ng_bots_avatar_match_name => 'Passend zum Namen';

  @override
  String get ng_bots_avatar_upload => 'Bild auswählen…';

  @override
  String get ng_bots_avatar_remove => 'Bild entfernen — Form verwenden';

  @override
  String get ng_bots_avatar_too_large => 'Bild zu groß (max. 15 MB).';

  @override
  String get ng_bots_avatar_unreadable =>
      'Das Bild konnte nicht gelesen werden.';

  @override
  String get ng_bots_edit_profile => 'Profil bearbeiten';

  @override
  String ng_bots_edit_description(String name, String profile) {
    return 'Aussehen und Rolle von $name ($profile).';
  }

  @override
  String ng_bots_advanced_failed(String reason) {
    return 'Die Profileinstellungen konnten nicht geladen werden ($reason).';
  }

  @override
  String get ng_bots_skills => 'Skills';

  @override
  String get ng_bots_toolsets => 'Toolsets';

  @override
  String get ng_bots_toolsets_hint =>
      'Alle (oder keine) angehakt lassen behält das Standardverhalten der Toolsets bei.';

  @override
  String get ng_bots_mcp_servers => 'MCP-Server';

  @override
  String get ng_bots_saving => 'Wird gespeichert…';

  @override
  String get ng_bots_confirm_changes_title => 'Diese Änderungen speichern?';

  @override
  String get ng_bots_change_remove_image => 'Das Bild des Bots entfernen';

  @override
  String get ng_bots_change_soul => 'Seine SOUL.md ersetzen';

  @override
  String ng_bots_change_turn_off(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Skills, Toolsets oder MCP-Server ausschalten',
      one: '1 Skill, Toolset oder MCP-Server ausschalten',
    );
    return '$_temp0';
  }

  @override
  String ng_bots_updated(String name) {
    return '$name aktualisiert';
  }

  @override
  String ng_bots_sections_failed(String sections) {
    return 'Einige Bereiche sind fehlgeschlagen: $sections';
  }

  @override
  String get ng_bots_model_confirm_title => 'Modell wechseln?';

  @override
  String get ng_bots_model_confirm_ok => 'Wechseln';

  @override
  String get ng_bots_model_not_switched => 'Das Modell wurde nicht gewechselt.';

  @override
  String get ng_bots_section_new => 'Neuer Bereich';

  @override
  String get ng_bots_section_new_ellipsis => 'Neuer Bereich…';

  @override
  String get ng_bots_section_name => 'Name des Bereichs';

  @override
  String get ng_bots_section_name_hint => 'z. B. Kunden';

  @override
  String get ng_bots_section_create => 'Erstellen';

  @override
  String get ng_bots_section_rename => 'Bereich umbenennen';

  @override
  String get ng_bots_section_delete => 'Bereich löschen';

  @override
  String get ng_bots_section_move_up => 'Nach oben';

  @override
  String get ng_bots_section_move_down => 'Nach unten';

  @override
  String get ng_bots_section_unassigned => 'Nicht zugeordnet';

  @override
  String ng_bots_section_options(String name) {
    return 'Optionen für Bereich $name';
  }

  @override
  String get ng_bots_section_empty =>
      'Noch keine Bots hier. Bei einem Bot „In Bereich verschieben“ wählen.';

  @override
  String get ng_bots_section_move_to => 'In Bereich verschieben';

  @override
  String get ng_bots_section_remove => 'Aus Bereich entfernen';

  @override
  String ng_bots_section_deleted(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '„$name“ gelöscht — $count Bots nach „Nicht zugeordnet“ verschoben',
      one: '„$name“ gelöscht — 1 Bot nach „Nicht zugeordnet“ verschoben',
      zero: '„$name“ gelöscht',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_undo => 'Rückgängig';

  @override
  String ng_bots_section_move_failed(String reason) {
    return 'Der Bot konnte nicht verschoben werden ($reason).';
  }

  @override
  String ng_bots_bot_actions(String name) {
    return 'Aktionen für $name';
  }

  @override
  String ng_bots_section_toggle(String name) {
    return '$name ein- oder ausblenden';
  }

  @override
  String
  get release_core_transcript_reader_this_passage_is_no_longer_in_the_loaded =>
      'Diese Passage ist nicht mehr im geladenen Ausschnitt enthalten.';

  @override
  String get release_core_transcript_reader_loaded_prompts =>
      'Geladene Prompts';

  @override
  String get release_core_transcript_reader_jump_to_latest =>
      'Zum neuesten Eintrag springen';

  @override
  String get release_core_transcript_reader_no_prompts_loaded =>
      'Keine Prompts geladen';

  @override
  String get release_core_transcript_reader_find_in_loaded_messages =>
      'In geladenen Nachrichten suchen';

  @override
  String get release_core_transcript_reader_previous_match =>
      'Vorheriger Treffer';

  @override
  String get release_core_transcript_reader_next_match => 'Nächster Treffer';

  @override
  String get release_core_transcript_reader_prompt_timeline =>
      'Prompt-Zeitleiste';

  @override
  String get release_core_transcript_reader_close_find => 'Suche schließen';

  @override
  String get release_core_session_organisation_organise_chats =>
      'Chats organisieren';

  @override
  String get release_core_session_organisation_show_model_and_usage =>
      'Modell und Nutzung anzeigen';

  @override
  String
  get release_core_session_files_view_connection_changed_reopen_files_on_the_new_connection =>
      'Verbindung geändert. Öffne die Dateien über die neue Verbindung erneut.';

  @override
  String
  get release_core_session_files_view_the_connection_or_session_changed_reopen_this_pane =>
      'Die Verbindung oder Sitzung hat sich geändert. Öffne diesen Bereich erneut.';

  @override
  String
  get release_core_session_files_view_no_verified_host_working_directory_for_this_session =>
      'Kein verifiziertes Arbeitsverzeichnis auf dem Host für diese Sitzung.';

  @override
  String
  get release_core_session_files_view_the_gateway_denied_this_operation =>
      'Das Gateway hat diesen Vorgang abgelehnt.';

  @override
  String
  get release_core_session_files_view_this_gateway_does_not_support_this_operation =>
      'Dieses Gateway unterstützt diesen Vorgang nicht.';

  @override
  String
  get release_core_session_files_view_the_file_owner_or_working_directory_changed_reload =>
      'Die Datei, der Eigentümer oder das Arbeitsverzeichnis hat sich geändert. Lade neu und überprüfe die Angaben.';

  @override
  String
  get release_core_session_files_view_the_gateway_returned_an_unsafe_path_or_invalid =>
      'Das Gateway hat einen unsicheren Pfad oder eine ungültige Dateiantwort zurückgegeben.';

  @override
  String
  get release_core_session_files_view_workspace_access_requires_a_secure_gateway_connection =>
      'Der Zugriff auf den Arbeitsbereich erfordert eine sichere Gateway-Verbindung.';

  @override
  String
  get release_core_session_files_view_gateway_unavailable_refresh_to_check_the_current_state =>
      'Gateway nicht verfügbar. Aktualisiere, um den aktuellen Status zu prüfen.';

  @override
  String
  get release_core_session_files_view_gateway_operation_could_not_be_confirmed =>
      'Der Gateway-Vorgang konnte nicht bestätigt werden.';

  @override
  String get release_core_session_files_view_git_status_unavailable =>
      'Git-Status nicht verfügbar.';

  @override
  String
  get release_core_session_files_view_change_this_chat_s_working_directory =>
      'Arbeitsverzeichnis dieses Chats ändern?';

  @override
  String get release_core_session_files_view_absolute_gateway_directory =>
      'Absolutes Verzeichnis auf dem Gateway';

  @override
  String get release_core_session_files_view_change_directory =>
      'Verzeichnis ändern';

  @override
  String get release_core_session_files_view_replace_gateway_file =>
      'Datei auf dem Gateway ersetzen?';

  @override
  String
  release_core_session_files_view_only_if_the_file_still_matches_the_version(
    String path,
  ) {
    return '$path\n\nNur wenn die Datei noch der von dir überprüften Version entspricht. Ein kompatibler Host bewahrt die ersetzte Datei zur Wiederherstellung auf.';
  }

  @override
  String get release_core_session_files_view_save_changes =>
      'Änderungen speichern';

  @override
  String
  get release_core_session_files_view_saved_and_verified_on_the_gateway =>
      'Auf dem Gateway gespeichert und verifiziert.';

  @override
  String
  get release_core_session_files_view_guarded_saving_is_unavailable_on_this_gateway_your =>
      'Geschütztes Speichern ist auf diesem Gateway nicht verfügbar. Dein Entwurf ist weiterhin vorhanden.';

  @override
  String
  release_core_session_files_view_save_was_not_confirmed_your_draft_is_still(
    String reason,
  ) {
    return '$reason Das Speichern wurde nicht bestätigt. Dein Entwurf ist weiterhin vorhanden.';
  }

  @override
  String get release_core_session_files_view_review_current_gateway_version =>
      'Aktuelle Version auf dem Gateway prüfen';

  @override
  String get release_core_session_files_view_discard_draft_and_reload =>
      'Entwurf verwerfen und neu laden';

  @override
  String get release_core_session_files_view_keep_draft_against_this_version =>
      'Entwurf auf Basis dieser Version beibehalten';

  @override
  String get release_core_session_files_view_discard_unsaved_edits =>
      'Ungespeicherte Änderungen verwerfen?';

  @override
  String get release_core_session_files_view_keep_editing =>
      'Weiter bearbeiten';

  @override
  String get release_core_session_files_view_discard_edits =>
      'Änderungen verwerfen';

  @override
  String get release_core_session_files_view_remote_working_directory =>
      'Entferntes Arbeitsverzeichnis';

  @override
  String get release_core_session_files_view_change_working_directory =>
      'Arbeitsverzeichnis ändern';

  @override
  String get release_core_session_files_view_show_ignored_files =>
      'Ignorierte Dateien anzeigen';

  @override
  String
  get release_core_session_files_view_gateway_does_not_report_ignored_status =>
      'Das Gateway meldet nicht, welche Dateien ignoriert werden.';

  @override
  String get release_core_session_files_view_no_visible_entries =>
      'Keine sichtbaren Einträge';

  @override
  String get release_core_session_files_view_changed => 'Geändert';

  @override
  String get release_core_session_files_view_ignored => 'Ignoriert';

  @override
  String release_core_session_files_view_actions_for(String name) {
    return 'Aktionen für $name';
  }

  @override
  String get release_core_session_files_view_copy_relative_path =>
      'Relativen Pfad kopieren';

  @override
  String get release_core_session_files_view_copy_gateway_path =>
      'Gateway-Pfad kopieren';

  @override
  String get release_core_session_files_view_attach_folder_reference =>
      'Ordnerreferenz anhängen';

  @override
  String get release_core_session_files_view_attach_file_reference =>
      'Dateireferenz anhängen';

  @override
  String
  get release_core_session_files_view_preview_truncated_editing_disabled =>
      'Vorschau gekürzt — Bearbeitung deaktiviert.';

  @override
  String get release_core_session_files_view_select_lines => 'Zeilen auswählen';

  @override
  String get release_core_session_files_view_review_gateway_version =>
      'Version auf dem Gateway prüfen';

  @override
  String get release_core_session_files_view_attach_selected_lines =>
      'Ausgewählte Zeilen anhängen';

  @override
  String get release_core_session_files_view_binary_file_no_text_preview =>
      'Binärdatei — keine Textvorschau.';

  @override
  String get release_core_session_files_view_file_source => 'Dateiquelle';

  @override
  String get release_core_session_files_view_close_session_files =>
      'Sitzungsdateien schließen';

  @override
  String get release_core_session_files_view_back_to_tree =>
      'Zurück zur Baumansicht';

  @override
  String get release_core_session_files_view_session_files => 'Sitzungsdateien';

  @override
  String get release_core_session_files_view_git_review => 'Git-Überprüfung';

  @override
  String get release_core_session_files_view_refresh_tree =>
      'Baumansicht aktualisieren';

  @override
  String
  get release_core_gateway_queue_screen_this_connection_changed_reopen_its_chat =>
      'Diese Verbindung hat sich geändert. Öffne den zugehörigen Chat erneut.';

  @override
  String
  get release_core_gateway_queue_screen_disconnected_reconnect_the_chat_then_refresh =>
      'Verbindung getrennt. Verbinde den Chat erneut und aktualisiere dann.';

  @override
  String release_core_gateway_queue_screen_gateway_queue_unavailable(
    String reason,
  ) {
    return 'Gateway-Warteschlange nicht verfügbar: $reason.';
  }

  @override
  String release_core_gateway_queue_screen_not_confirmed_nothing_was_resent(
    String reason,
  ) {
    return 'Nicht bestätigt ($reason). Es wurde nichts erneut gesendet.';
  }

  @override
  String get release_core_gateway_queue_screen_gateway_confirmed_admission =>
      'Das Gateway hat die Aufnahme bestätigt.';

  @override
  String
  get release_core_gateway_queue_screen_edited_entry_admitted_at_the_end_of_the =>
      'Bearbeiteter Eintrag am Ende der Warteschlange aufgenommen.';

  @override
  String get release_core_gateway_queue_screen_discard_unknown_outcome =>
      'Eintrag mit unbekanntem Ergebnis verwerfen?';

  @override
  String get release_core_gateway_queue_screen_remove_this_entry =>
      'Diesen Eintrag entfernen?';

  @override
  String
  get release_core_gateway_queue_screen_the_lost_turn_will_not_be_retried_waiting =>
      'Der verlorene Turn wird nicht erneut versucht. Wartende Turns können jetzt ausgeführt werden.';

  @override
  String
  get release_core_gateway_queue_screen_if_the_gateway_has_just_started_this_entry =>
      'Wenn das Gateway diesen Eintrag gerade gestartet hat, kann das Entfernen den zugehörigen Turn stoppen.';

  @override
  String get release_core_gateway_queue_screen_keep => 'Beibehalten';

  @override
  String get release_core_gateway_queue_screen_discard_and_resume =>
      'Verwerfen und fortsetzen';

  @override
  String get release_core_gateway_queue_screen_remove_entry =>
      'Eintrag entfernen';

  @override
  String
  get release_core_gateway_queue_screen_lost_admission_resolved_it_was_not_resent =>
      'Ungeklärte Aufnahme aufgelöst; es wurde nichts erneut gesendet.';

  @override
  String get release_core_gateway_queue_screen_gateway_acknowledged_removal =>
      'Das Gateway hat das Entfernen bestätigt.';

  @override
  String get release_core_gateway_queue_screen_gateway_queue =>
      'Gateway-Warteschlange';

  @override
  String get release_core_gateway_queue_screen_refresh_queue =>
      'Warteschlange aktualisieren';

  @override
  String get release_core_gateway_queue_screen_queue_paused_unknown_outcome =>
      'Warteschlange pausiert: Ergebnis unbekannt';

  @override
  String
  get release_core_gateway_queue_screen_review_the_lost_admission_before_resuming_nothing_is =>
      'Prüfe die ungeklärte Aufnahme vor dem Fortsetzen. Es wird nichts erneut gesendet.';

  @override
  String get release_core_gateway_queue_screen_no_pending_admissions =>
      'Keine ausstehenden Aufnahmen';

  @override
  String get release_core_gateway_queue_screen_discard => 'Verwerfen…';

  @override
  String
  get release_core_gateway_queue_screen_gateway_acknowledged_the_steering_request =>
      'Das Gateway hat die Steuerungsanfrage bestätigt.';

  @override
  String get release_core_gateway_queue_screen_steer_running_turn =>
      'Laufenden Turn steuern';

  @override
  String get release_core_gateway_queue_screen_remove => 'Entfernen…';

  @override
  String get release_core_gateway_queue_screen_next_prompt => 'Nächster Prompt';

  @override
  String get release_core_gateway_queue_screen_edit_queued_prompt =>
      'Prompt in der Warteschlange bearbeiten';

  @override
  String get release_core_gateway_queue_screen_submit_to_gateway_queue =>
      'An die Gateway-Warteschlange senden';

  @override
  String get release_core_gateway_queue_screen_save_at_queue_end =>
      'Am Ende der Warteschlange speichern';

  @override
  String get release_core_gateway_queue_screen_cancel_edit =>
      'Bearbeitung abbrechen';

  @override
  String get release_core_git_review_pane_the_git_operation_did_not_complete =>
      'Der Git-Vorgang wurde nicht abgeschlossen.';

  @override
  String get release_core_git_review_pane_close_git_review =>
      'Git-Überprüfung schließen';

  @override
  String get release_core_git_review_pane_pin_lane => 'Spur anheften';

  @override
  String get release_core_git_review_pane_refresh_git_review =>
      'Git-Überprüfung aktualisieren';

  @override
  String get release_core_git_review_pane_uncommitted => 'Nicht committet';

  @override
  String get release_core_git_review_pane_last_turn => 'Letzter Turn';

  @override
  String
  get release_core_git_review_pane_branch_and_last_turn_views_are_read_only =>
      'Branch- und Letzter-Turn-Ansichten sind schreibgeschützt.';

  @override
  String get release_core_git_review_pane_mark_head_as_the_turn_baseline =>
      'HEAD als Ausgangspunkt des Turns markieren';

  @override
  String get release_core_git_review_pane_stage_all =>
      'Alles zum Commit vormerken';

  @override
  String get release_core_git_review_pane_discard_every_uncommitted_change =>
      'Alle nicht committeten Änderungen verwerfen?';

  @override
  String
  get release_core_git_review_pane_tracked_files_return_to_head_and_untracked_files =>
      'Verfolgte Dateien werden auf HEAD zurückgesetzt und nicht verfolgte Dateien in diesem Sitzungsverzeichnis entfernt.';

  @override
  String get release_core_git_review_pane_discard => 'Verwerfen';

  @override
  String get release_core_git_review_pane_discard_all => 'Alles verwerfen';

  @override
  String get release_core_git_review_pane_unstage =>
      'Aus der Commit-Vormerkung entfernen';

  @override
  String get release_core_git_review_pane_stage => 'Zum Commit vormerken';

  @override
  String get release_core_git_review_pane_discard_file =>
      'Dateiänderungen verwerfen';

  @override
  String release_core_git_review_pane_discard_2(String path) {
    return 'Änderungen an $path verwerfen?';
  }

  @override
  String
  get release_core_git_review_pane_this_restores_the_committed_copy_or_removes_the =>
      'Dadurch wird die committete Kopie wiederhergestellt oder die nicht verfolgte Datei entfernt.';

  @override
  String get release_core_git_review_pane_commit_message => 'Commit-Nachricht';

  @override
  String get release_core_git_review_pane_nothing_in_the_diff_to_summarise =>
      'Keine Änderungen im Diff zum Zusammenfassen.';

  @override
  String get release_core_git_review_pane_generate_message =>
      'Nachricht generieren';

  @override
  String get release_core_git_review_pane_commit => 'Committen';

  @override
  String get release_core_git_review_pane_commit_and_push =>
      'Committen und pushen';

  @override
  String get release_core_git_review_pane_push => 'Pushen';

  @override
  String get release_core_git_review_pane_create_pull_request =>
      'Pull Request erstellen';

  @override
  String get release_core_git_review_pane_pull_request_ready =>
      'Pull Request bereit';

  @override
  String get release_core_git_review_pane_ask_hermes_to_ship =>
      'Hermes um Veröffentlichung bitten';

  @override
  String get release_core_git_review_pane_gh_is_authenticated_on_this_gateway =>
      'gh ist auf diesem Gateway authentifiziert.';

  @override
  String
  get release_core_git_review_pane_install_the_github_cli_gh_and_sign_in =>
      'Installiere die GitHub CLI (gh) und melde dich an, um PRs zu öffnen';

  @override
  String get release_core_git_review_pane_worktrees => 'Worktrees';

  @override
  String get release_core_git_review_pane_main => 'Haupt-Worktree';

  @override
  String release_core_git_review_pane_follow(String branch) {
    return '$branch folgen?';
  }

  @override
  String
  get release_core_git_review_pane_the_session_working_directory_becomes_this_worktree_unless =>
      'Dieser Worktree wird zum Arbeitsverzeichnis der Sitzung, sofern die Spur nicht angeheftet ist.';

  @override
  String get release_core_git_review_pane_follow_2 => 'Folgen';

  @override
  String release_core_git_review_pane_remove(String branch) {
    return '$branch entfernen?';
  }

  @override
  String get release_core_git_review_pane_the_worktree_directory_is_removed =>
      'Das Worktree-Verzeichnis wird entfernt.';

  @override
  String get release_core_git_review_pane_remove_2 => 'Entfernen';

  @override
  String get release_core_git_review_pane_new_worktree_name =>
      'Name des neuen Worktrees';

  @override
  String get release_core_git_review_pane_new_branch => 'Neuer Branch';

  @override
  String get release_core_git_review_pane_base_branch => 'Basis-Branch';

  @override
  String get release_core_git_review_pane_create_worktree =>
      'Worktree erstellen';

  @override
  String get release_core_git_review_pane_existing_branch =>
      'Vorhandener Branch';

  @override
  String get release_core_git_review_pane_convert_branch_to_worktree =>
      'Branch in Worktree umwandeln';

  @override
  String get release_core_git_review_pane_switch_branch => 'Branch wechseln';

  @override
  String
  get release_core_git_review_pane_this_gateway_does_not_support_that_git_operation =>
      'Dieses Gateway unterstützt diesen Git-Vorgang nicht.';

  @override
  String
  get release_core_git_review_pane_git_needs_the_session_directory_on_the_local =>
      'Git benötigt das Sitzungsverzeichnis im lokalen Terminal-Backend.';

  @override
  String
  get release_core_git_review_pane_the_gateway_refused_the_git_operation =>
      'Das Gateway hat den Git-Vorgang abgelehnt.';

  @override
  String
  get release_core_git_review_pane_the_session_changed_refresh_and_try_again =>
      'Die Sitzung hat sich geändert. Aktualisiere und versuche es erneut.';

  @override
  String
  get release_core_git_review_pane_this_review_is_no_longer_the_selected_session =>
      'Diese Überprüfung gehört nicht mehr zur ausgewählten Sitzung.';

  @override
  String
  get release_core_git_review_pane_the_gateway_returned_an_unexpected_git_result =>
      'Das Gateway hat ein unerwartetes Git-Ergebnis zurückgegeben.';

  @override
  String
  get release_core_git_review_pane_git_review_requires_the_gateway_transport =>
      'Die Git-Überprüfung erfordert die Gateway-Verbindung.';

  @override
  String get release_core_client_held_queue_bar_resume => 'Fortsetzen';

  @override
  String get release_core_client_held_queue_bar_send_queued_prompt =>
      'Prompt aus der Warteschlange senden';

  @override
  String get release_core_client_held_queue_bar_edit_unsent_prompt =>
      'Ungesendeten Prompt bearbeiten';

  @override
  String get release_core_client_held_queue_bar_remove_unsent_prompt =>
      'Ungesendeten Prompt entfernen';

  @override
  String get release_core_workspace_discovery_view_repository_discovery =>
      'Repository-Suche';

  @override
  String get release_core_workspace_discovery_view_refresh_results =>
      'Ergebnisse aktualisieren';

  @override
  String release_core_workspace_discovery_view_hide(String path) {
    return '$path ausblenden';
  }

  @override
  String
  get release_core_workspace_discovery_view_invalid_path_or_discovery_data_use_absolute_server =>
      'Ungültiger Pfad oder ungültige Suchdaten. Verwende absolute Serverpfade ohne . oder .. als Pfadbestandteile.';

  @override
  String
  get release_core_workspace_discovery_view_this_gateway_does_not_support_repository_discovery =>
      'Dieses Gateway unterstützt die Repository-Suche nicht.';

  @override
  String
  get release_core_workspace_discovery_view_the_gateway_denied_access_to_repository_discovery =>
      'Das Gateway hat den Zugriff auf die Repository-Suche verweigert.';

  @override
  String
  get release_core_workspace_discovery_view_the_connection_changed_reopen_discovery_on_the_current =>
      'Die Verbindung hat sich geändert. Öffne die Suche auf dem aktuellen Gateway erneut.';

  @override
  String
  get release_core_workspace_discovery_view_the_displayed_settings_have_changed_refresh_before_trying =>
      'Die angezeigten Einstellungen haben sich geändert. Aktualisiere vor einem erneuten Versuch.';

  @override
  String
  get release_core_workspace_discovery_view_could_not_load_or_verify_discovery_settings_refresh =>
      'Die Sucheinstellungen konnten nicht geladen oder verifiziert werden. Aktualisiere, um es erneut zu versuchen.';

  @override
  String release_core_workspace_discovery_view_repositories_shown_of(
    int visible,
    int total,
  ) {
    return 'Angezeigte Repositories: $visible von $total';
  }

  @override
  String
  get release_core_workspace_discovery_view_the_gateway_returned_no_repositories =>
      'Das Gateway hat keine Repositories zurückgegeben.';

  @override
  String
  get release_core_workspace_discovery_view_no_repositories_match_your_device_filters =>
      'Keine Repositories entsprechen deinen Gerätefiltern.';

  @override
  String get release_core_workspace_discovery_view_gateway_scan_policy =>
      'Scan-Richtlinie des Gateways';

  @override
  String
  get release_core_workspace_discovery_view_this_gateway_did_not_report_a_scan_policy =>
      'Dieses Gateway hat keine Scan-Richtlinie gemeldet.';

  @override
  String
  get release_core_workspace_discovery_view_to_scan_folders_configure_repository_scanning_in_the =>
      'Um Ordner zu durchsuchen, konfiguriere die Repository-Suche in den Desktop-Einstellungen des Gateway-Profils.';

  @override
  String
  get release_core_workspace_discovery_view_results_can_include_cached_repositories_and_repositories_with =>
      'Ergebnisse können zwischengespeicherte Repositories und Repositories mit Sitzungen enthalten. Ein Scan garantiert nicht, dass jeder Ordner erreicht wurde.';

  @override
  String get release_core_workspace_discovery_view_scan_gateway_roots =>
      'Stammverzeichnisse des Gateways durchsuchen';

  @override
  String
  get release_core_workspace_discovery_view_filter_results_on_this_device =>
      'Ergebnisse auf diesem Gerät filtern';

  @override
  String
  get release_core_workspace_discovery_view_only_this_discovery_list_changes_not_the_gateway =>
      'Nur diese Ergebnisliste ändert sich, nicht der Gateway-Scan.';

  @override
  String get release_core_workspace_discovery_view_include_subtrees_empty_all =>
      'Unterverzeichnisbäume einschließen (leer = alle)';

  @override
  String get release_core_workspace_discovery_view_exclude_subtrees =>
      'Unterverzeichnisbäume ausschließen';

  @override
  String get release_core_workspace_discovery_view_apply_filters =>
      'Filter anwenden';

  @override
  String release_core_workspace_discovery_view_hidden_repositories(int count) {
    return 'Ausgeblendete Repositories ($count)';
  }

  @override
  String get release_core_workspace_discovery_view_undo_hide =>
      'Ausblenden rückgängig machen';

  @override
  String
  get release_core_workspace_discovery_view_one_absolute_server_path_per_line =>
      'Ein absoluter Serverpfad pro Zeile';

  @override
  String get release_core_project_settings_view_project_settings =>
      'Projekteinstellungen';

  @override
  String
  get release_core_project_settings_view_the_gateway_did_not_confirm_the_selected_project =>
      'Das Gateway hat das ausgewählte Projekt oder die Änderung nicht bestätigt. Prüfe die Einstellungen vor einem erneuten Versuch.';

  @override
  String
  get release_core_project_settings_view_could_not_verify_these_settings_use_one_absolute =>
      'Diese Einstellungen konnten nicht verifiziert werden. Verwende einen absoluten Serverordnerpfad pro Zeile, ohne . oder .. als Pfadbestandteile.';

  @override
  String get release_core_project_settings_view_set_active => 'Aktiv setzen';

  @override
  String get release_core_project_settings_view_icon => 'Symbol';

  @override
  String get release_core_project_settings_view_folder => 'Ordner';

  @override
  String get release_core_project_settings_view_repository => 'Repository';

  @override
  String get release_core_project_settings_view_rocket => 'Rakete';

  @override
  String get release_core_project_settings_view_star => 'Stern';

  @override
  String get release_core_project_settings_view_book => 'Buch';

  @override
  String get release_core_project_settings_view_terminal => 'Terminal';

  @override
  String get release_core_project_settings_view_colour => 'Farbe';

  @override
  String get release_core_project_settings_view_primary_folder => 'Hauptordner';

  @override
  String get release_core_project_settings_view_server_folder_paths =>
      'Serverordnerpfade';

  @override
  String
  get release_core_project_settings_view_one_absolute_path_per_line_existing_folders_are =>
      'Ein absoluter Pfad pro Zeile. Vorhandene Ordner bleiben erhalten.';

  @override
  String get release_core_project_settings_view_add_folders =>
      'Ordner hinzufügen';

  @override
  String release_core_project_settings_view_choose(String label) {
    return '$label auswählen';
  }

  @override
  String
  get release_core_prepared_image_recovery_wait_for_an_empty_draft_before_restoring =>
      'Warte mit der Wiederherstellung, bis der Entwurf leer ist.';

  @override
  String
  get release_core_prepared_image_recovery_no_unacknowledged_image_drafts_in_this_chat =>
      'Keine unbestätigten Bildentwürfe in diesem Chat.';

  @override
  String get release_core_prepared_image_recovery_unacknowledged_image_drafts =>
      'Unbestätigte Bildentwürfe';

  @override
  String
  get release_core_prepared_image_recovery_the_gateway_may_already_have_received_these_restore =>
      'Das Gateway hat diese möglicherweise bereits empfangen. Stelle sie zur Überprüfung wieder her; es wird nichts gesendet.';

  @override
  String get release_core_prepared_image_recovery_image_draft => 'Bildentwurf';

  @override
  String get release_core_prepared_image_recovery_discard_local_copy =>
      'Lokale Kopie verwerfen';

  @override
  String
  get release_core_prepared_image_recovery_discard_this_local_image_draft =>
      'Diesen lokalen Bildentwurf verwerfen?';

  @override
  String
  get release_core_prepared_image_recovery_image_draft_recovery_is_unavailable =>
      'Die Wiederherstellung von Bildentwürfen ist nicht verfügbar.';

  @override
  String get release_core_prepared_image_recovery_recover_image_draft =>
      'Bildentwurf wiederherstellen…';

  @override
  String get release_core_session_search_mode_menu_could_not_save_search_mode =>
      'Suchmodus konnte nicht gespeichert werden.';

  @override
  String get release_core_projects_pane_discover_repositories =>
      'Repositories suchen';

  @override
  String
  get release_core_projects_pane_project_created_but_the_gateway_did_not_confirm =>
      'Projekt erstellt, aber das Gateway hat die Projektidee nicht bestätigt.';

  @override
  String get release_core_projects_pane_project_idea_optional =>
      'Projektidee (optional)';

  @override
  String
  get release_core_projects_pane_saved_in_the_project_description_not_a_file =>
      'Wird in der Projektbeschreibung gespeichert, nicht in einer Datei.';

  @override
  String get release_core_project_detail_screen_new_chat_in_this_lane =>
      'Neuer Chat in dieser Spur';

  @override
  String get release_core_project_detail_screen_review_git => 'Git überprüfen';

  @override
  String get release_core_more_pane_gateway_fleet => 'Gateway-Flotte';

  @override
  String
  get release_core_more_pane_connected_sessions_hermes_cloud_and_desktop_webapp =>
      'Verbundene Sitzungen, Hermes Cloud und Desktop-Webapp';

  @override
  String get release_core_more_pane_use_dashboard_sign_in_for_a_named_profile =>
      'Verwende für ein benanntes Profil die Dashboard-Anmeldung. Diese ältere API kann nicht bestätigen, welchem Profil der Chatverlauf gehört.';

  @override
  String get release_core_more_pane_capabilities => 'Funktionen';

  @override
  String
  get release_core_more_pane_install_and_govern_skills_plugins_connectors_and_tool =>
      'Fähigkeiten, Plugins, Konnektoren und Tool-Backends installieren und verwalten';

  @override
  String get release_core_more_pane_browser_vault => 'Browser-Tresor';

  @override
  String
  get release_core_more_pane_site_logins_addresses_cards_and_credential_sources =>
      'Website-Anmeldungen, Adressen, Karten und Zugangsdatenquellen';

  @override
  String get release_core_more_pane_agent_policy => 'Agentenrichtlinie';

  @override
  String
  get release_core_more_pane_approvals_checkpoints_browser_access_and_shared_metrics =>
      'Genehmigungen, Prüfpunkte, Browserzugriff und gemeinsame Metriken';

  @override
  String get release_core_more_pane_remote_logs_health_maintenance_and_update =>
      'Remote-Protokolle, Systemzustand, Wartung und Updates';

  @override
  String get release_core_more_pane_schedules => 'Zeitpläne';

  @override
  String get release_core_more_pane_all_profiles_blueprints_catch_up_and_stop =>
      'Alle Profile, Vorlagen, Nachholen und Stoppen';

  @override
  String get release_core_more_pane_memory_graph => 'Gedächtnisgraph';

  @override
  String get release_core_more_pane_timeline_edits_and_memory_providers =>
      'Zeitleiste, Bearbeitungen und Gedächtnisanbieter';

  @override
  String get release_core_more_pane_providers_and_routes =>
      'Anbieter und Routen';

  @override
  String get release_core_more_pane_keys_endpoints_delegation_and_mixtures =>
      'Schlüssel, Endpunkte, Delegation und Mischungen';

  @override
  String get release_core_more_pane_credits_and_plans => 'Guthaben und Tarife';

  @override
  String
  get release_core_more_pane_consented_nous_billing_when_the_account_allows_it =>
      'Nous-Abrechnung mit Einwilligung, sofern das Konto es erlaubt';

  @override
  String
  get release_core_fleet_screen_this_gateway_does_not_offer_this_service =>
      'Dieses Gateway bietet diesen Dienst nicht an.';

  @override
  String
  get release_core_fleet_screen_sign_in_or_permission_required_on_this_gateway =>
      'Für dieses Gateway ist eine Anmeldung oder Berechtigung erforderlich.';

  @override
  String get release_core_fleet_screen_a_secure_gateway_address_is_required =>
      'Eine sichere Gateway-Adresse ist erforderlich.';

  @override
  String
  get release_core_fleet_screen_the_owner_changed_refresh_before_continuing =>
      'Der Eigentümer hat sich geändert. Aktualisiere, bevor du fortfährst.';

  @override
  String
  get release_core_fleet_screen_could_not_verify_the_operation_check_the_gateway =>
      'Der Vorgang konnte nicht verifiziert werden. Prüfe das Gateway und aktualisiere.';

  @override
  String get release_core_fleet_screen_verified_ssh => 'Verifiziertes SSH';

  @override
  String
  get release_core_fleet_screen_confirm_a_host_key_inspect_a_remote_service =>
      'Hostschlüssel bestätigen, einen entfernten Dienst prüfen oder dessen Shell öffnen';

  @override
  String get release_core_fleet_screen_cloud_and_desktop_webapp =>
      'Cloud und Desktop-Webapp';

  @override
  String get release_core_fleet_screen_register_an_existing_gateway_or_webapp =>
      'Vorhandenes Gateway oder vorhandene Webapp registrieren';

  @override
  String
  get release_core_fleet_screen_sign_in_to_its_address_nothing_is_hosted =>
      'Melde dich unter der zugehörigen Adresse an. Auf diesem Gerät wird nichts gehostet.';

  @override
  String get release_core_fleet_screen_fleet_updates => 'Flotten-Updates';

  @override
  String get release_core_fleet_screen_refresh_roster =>
      'Übersicht aktualisieren';

  @override
  String release_core_fleet_screen_disconnect(String gateway) {
    return 'Verbindung zu $gateway trennen';
  }

  @override
  String get release_core_fleet_screen_open_this_gateway_on_launch =>
      'Dieses Gateway beim Start öffnen';

  @override
  String
  get release_core_fleet_screen_primary_for_ares_does_not_change_the_last =>
      'Primär für Ares; ändert nicht das zuletzt verwendete Gateway.';

  @override
  String get release_core_fleet_screen_reconnect_in_fleet_on_launch =>
      'Beim Start in der Flotte erneut verbinden';

  @override
  String get release_core_fleet_screen_no_sessions_for_this_profile =>
      'Keine Sitzungen für dieses Profil.';

  @override
  String get release_core_fleet_screen_more_sessions => 'Weitere Sitzungen';

  @override
  String get release_core_fleet_screen_this_gateway_was_disconnected =>
      'Die Verbindung zu diesem Gateway wurde getrennt.';

  @override
  String
  get release_core_fleet_screen_some_conversation_data_could_not_be_loaded =>
      'Einige Unterhaltungsdaten konnten nicht geladen werden.';

  @override
  String get release_core_fleet_screen_message_this_session =>
      'Nachricht an diese Sitzung';

  @override
  String get release_core_fleet_screen_send_to_this_session =>
      'An diese Sitzung senden';

  @override
  String get release_core_fleet_updates_screen_update_these_remote_gateways =>
      'Diese entfernten Gateways aktualisieren?';

  @override
  String
  release_core_fleet_updates_screen_this_can_restart_the_backend_and_interrupt_other(
    String gateways,
  ) {
    return 'Dies kann das Backend neu starten und andere Nutzer unterbrechen. Ares wird dabei nicht aktualisiert.\n\n$gateways';
  }

  @override
  String get release_core_fleet_updates_screen_update_listed_gateways =>
      'Aufgelistete Gateways aktualisieren';

  @override
  String
  get release_core_fleet_updates_screen_checks_connected_gateways_cloud_is_platform_managed_entries =>
      'Prüft verbundene Gateways. Die Cloud wird von der Plattform verwaltet; Einträge ohne Registrierungsnachweis sind ausgeschlossen.';

  @override
  String get release_core_fleet_updates_screen_check_connected_gateways =>
      'Verbundene Gateways prüfen';

  @override
  String get release_core_fleet_updates_screen_read_update_receipt =>
      'Update-Bestätigung lesen';

  @override
  String get release_core_fleet_updates_screen_review_eligible_updates =>
      'Verfügbare zulässige Updates prüfen';

  @override
  String
  get release_core_fleet_webapp_screen_account_changed_reopen_this_page =>
      'Konto geändert. Öffne diese Seite erneut.';

  @override
  String
  get release_core_fleet_webapp_screen_set_the_webapp_s_primary_gateway =>
      'Primäres Gateway der Webapp festlegen?';

  @override
  String
  release_core_fleet_webapp_screen_this_changes_the_shared_registry_not_the_last(
    String webapp,
    String gateway,
    String id,
  ) {
    return '$webapp → $gateway ($id)\nDies ändert die gemeinsame Registrierung, nicht das zuletzt verwendete Gateway.';
  }

  @override
  String get release_core_fleet_webapp_screen_set_primary =>
      'Als primär festlegen';

  @override
  String get release_core_fleet_webapp_screen_serving_profile =>
      'Bereitstellendes Profil';

  @override
  String get release_core_fleet_webapp_screen_hermes_cloud => 'Hermes Cloud';

  @override
  String get release_core_fleet_webapp_screen_discover_signed_in_agents =>
      'Angemeldete Agenten suchen';

  @override
  String release_core_fleet_webapp_screen_organisation(String organisation) {
    return 'Organisation: $organisation';
  }

  @override
  String get release_core_fleet_webapp_screen_no_agents_available =>
      'Keine Agenten verfügbar.';

  @override
  String get release_core_fleet_webapp_screen_existing_desktop_webapp =>
      'Vorhandene Desktop-Webapp';

  @override
  String
  get release_core_fleet_webapp_screen_check_gateway_and_web_access_status =>
      'Gateway- und Webzugriffsstatus prüfen';

  @override
  String
  get release_core_fleet_webapp_screen_these_settings_belong_to_the_machine_serving_this =>
      'Diese Einstellungen gehören zu dem Rechner, der diese Webapp bereitstellt. Veröffentlichung und Neustarts sind keine Remote-Aktionen.';

  @override
  String get release_core_fleet_webapp_screen_read_webapp_gateway_registry =>
      'Gateway-Registrierung der Webapp lesen';

  @override
  String get release_core_fleet_webapp_screen_last_used => 'Zuletzt verwendet';

  @override
  String get release_core_fleet_webapp_screen_primary => 'Primär';

  @override
  String release_core_fleet_webapp_screen_set_primary_2(String gateway) {
    return 'Als primär festlegen: $gateway';
  }

  @override
  String get release_core_fleet_webapp_screen_read_shared_display_preferences =>
      'Gemeinsame Anzeigeeinstellungen lesen';

  @override
  String
  get release_core_fleet_webapp_screen_chat_text_direction_on_this_webapp_and_desktop =>
      'Textrichtung im Chat in dieser Webapp und auf Desktop';

  @override
  String release_core_schedule_desk_screen_created_on(
    String job,
    String profile,
  ) {
    return '$job auf $profile erstellt.';
  }

  @override
  String
  get release_core_schedule_desk_screen_the_list_covers_every_profile_on_this_gateway =>
      'Die Liste umfasst alle Profile auf diesem Gateway. Stoppen, Pausieren, Nachholen, Zustellung und Vorlagen werden an das Profil gesendet, dem der Auftrag gehört.';

  @override
  String get release_core_schedule_desk_screen_a_run_is_in_progress =>
      'Ein Lauf ist aktiv';

  @override
  String get release_core_schedule_desk_screen_no_current_run =>
      'Kein aktiver Lauf';

  @override
  String release_core_schedule_desk_screen_stop_requested_for(String job) {
    return 'Stopp für $job angefordert.';
  }

  @override
  String release_core_schedule_desk_screen_no_run_was_in_flight_for(
    String job,
  ) {
    return 'Für $job war kein Lauf aktiv.';
  }

  @override
  String get release_core_schedule_desk_screen_stop_current_run =>
      'Aktuellen Lauf stoppen';

  @override
  String get release_core_schedule_desk_screen_pause_future_runs =>
      'Künftige Läufe pausieren';

  @override
  String get release_core_schedule_desk_screen_resume_future_runs =>
      'Künftige Läufe fortsetzen';

  @override
  String get release_core_schedule_desk_screen_catch_up_default =>
      'Standard für das Nachholen';

  @override
  String get release_core_schedule_desk_screen_run_one_missed =>
      'Einen verpassten Lauf nachholen';

  @override
  String get release_core_schedule_desk_screen_skip_missed =>
      'Verpasste Läufe überspringen';

  @override
  String get release_core_schedule_desk_screen_blueprint_recipes =>
      'Vorlagenrezepte';

  @override
  String get release_core_schedule_desk_screen_profile_for_the_new_job =>
      'Profil für den neuen Auftrag';

  @override
  String release_core_schedule_desk_screen_create(String blueprint) {
    return '$blueprint erstellen';
  }

  @override
  String get release_core_schedule_desk_screen_loading_delivery_targets =>
      'Zustellziele werden geladen';

  @override
  String release_core_schedule_desk_screen_no_home_channel(String target) {
    return '$target (kein Heimatkanal)';
  }

  @override
  String release_core_memory_graph_screen_edit(String label) {
    return '$label bearbeiten';
  }

  @override
  String get release_core_memory_graph_screen_content => 'Inhalt';

  @override
  String get release_core_memory_graph_screen_archive_skill =>
      'Fähigkeit archivieren';

  @override
  String get release_core_memory_graph_screen_delete_memory =>
      'Gedächtniseintrag löschen';

  @override
  String release_core_memory_graph_screen_archive_on_it_can_be_restored_on_the(
    String label,
    String profile,
  ) {
    return '$label auf $profile archivieren? Der Eintrag kann auf dem Host mit dem Curator wiederhergestellt werden.';
  }

  @override
  String release_core_memory_graph_screen_delete_from_this_removes_that_memory(
    String label,
    String profile,
  ) {
    return '$label aus $profile löschen? Dadurch wird dieser Gedächtniseintrag entfernt.';
  }

  @override
  String get release_core_memory_graph_screen_filter => 'Filter';

  @override
  String get release_core_memory_graph_screen_timeline => 'Zeitleiste';

  @override
  String get release_core_memory_graph_screen_play_timeline =>
      'Zeitleiste abspielen';

  @override
  String get release_core_memory_graph_screen_layout_code => 'Layout-Code';

  @override
  String get release_core_memory_graph_screen_external_memory_providers =>
      'Externe Gedächtnisanbieter';

  @override
  String
  get release_core_memory_graph_screen_a_value_is_stored_leave_blank_to_keep =>
      'Ein Wert ist gespeichert. Lass das Feld leer, um ihn beizubehalten.';

  @override
  String get release_core_memory_graph_screen_save_provider =>
      'Anbieter speichern';

  @override
  String release_core_workspace_profiles_screen_applies_to(String profile) {
    return 'Gilt für: $profile';
  }

  @override
  String get release_core_workspace_profiles_screen_choose_another_profile =>
      'Anderes Profil wählen';

  @override
  String
  get release_core_workspace_profiles_screen_could_not_verify_the_selected_profile_on_this =>
      'Das ausgewählte Profil auf diesem Gateway konnte nicht verifiziert werden.';

  @override
  String get release_core_workspace_profiles_screen_create_profile =>
      'Profil erstellen';

  @override
  String get release_core_workspace_profiles_screen_new_profile_id =>
      'Neue Profil-ID';

  @override
  String get release_core_assets_screen_links => 'Links';

  @override
  String get release_core_workspace_picker_no_matching_items =>
      'Keine passenden Einträge.';

  @override
  String get release_core_workspace_picker_save_layout => 'Layout speichern';

  @override
  String get release_core_workspace_picker_layout_name => 'Layoutname';

  @override
  String
  get release_core_workspace_popout_this_chat_already_has_a_pop_out_window =>
      'Dieser Chat hat bereits ein separates Fenster.';

  @override
  String
  get release_core_workspace_popout_could_not_open_this_saved_chat_check_the =>
      'Dieser gespeicherte Chat konnte nicht geöffnet werden. Prüfe die Verbindung und versuche es erneut.';

  @override
  String
  get release_core_popout_bootstrap_use_the_main_window_to_change_your_connection =>
      'Verwende das Hauptfenster, um deine Verbindung zu ändern.';

  @override
  String get release_core_guarded_save_refused =>
      'Diese Datei kann vom Gateway nicht gespeichert werden';

  @override
  String get release_core_guarded_save_unavailable =>
      'Geschütztes Speichern ist auf diesem Gateway nicht verfügbar';

  @override
  String release_core_git_files_changed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Dateien in diesem Turn geändert',
      one: '1 Datei in diesem Turn geändert',
    );
    return '$_temp0';
  }

  @override
  String release_core_git_entries_omitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Git-Einträge wurden ausgelassen, weil ihre Anzeige nicht sicher war.',
      one:
          '1 Git-Eintrag wurde ausgelassen, weil seine Anzeige nicht sicher war.',
    );
    return '$_temp0';
  }

  @override
  String get release_core_git_staged => 'Zum Commit vorgemerkt';

  @override
  String get release_core_session_sort_recent => 'Letzte Aktivität';

  @override
  String get release_core_session_sort_created => 'Zuletzt erstellt';

  @override
  String get release_core_session_sort_status => 'Laufende zuerst';

  @override
  String get release_core_session_sort_tokens => 'Meiste Tokens';

  @override
  String get release_core_session_sort_cost => 'Höchste Kosten';

  @override
  String get release_core_session_group_standard => 'Standardgruppierung';

  @override
  String get release_core_session_group_status => 'Nach Status gruppieren';

  @override
  String get release_core_session_group_project => 'Nach Projekt gruppieren';

  @override
  String release_core_session_tokens(int count) {
    return '$count Tokens';
  }

  @override
  String release_core_search_gateway_mode(String mode) {
    return '$mode (Gateway)';
  }

  @override
  String release_core_search_mode_tooltip(String label, String mode) {
    return '$label: $mode';
  }

  @override
  String get release_core_image_recovery_new_turn =>
      'Senden startet einen neuen Turn';

  @override
  String release_core_image_recovery_metadata(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Bilder · $date',
      one: '1 Bild · $date',
    );
    return '$_temp0';
  }

  @override
  String release_core_discovery_scanning(String state) {
    return 'Scan: $state';
  }

  @override
  String get release_core_discovery_enabled => 'aktiviert';

  @override
  String get release_core_discovery_disabled => 'deaktiviert';

  @override
  String get release_core_discovery_none => 'keine';

  @override
  String release_core_discovery_roots(String paths) {
    return 'Scan-Stammverzeichnisse: $paths';
  }

  @override
  String release_core_discovery_excluded(String paths) {
    return 'Ausgeschlossene Unterverzeichnisbäume: $paths';
  }

  @override
  String release_core_discovery_repository_sessions(String path, int count) {
    return '$path\nSitzungen: $count';
  }

  @override
  String get release_core_projects_local_only =>
      'Dieses Hermes-Gateway ist älter als serverseitige Projekte, daher bleiben Chats nur auf diesem Gerät gruppiert. Aktualisiere Hermes, um dieselben Projekte geräteübergreifend zu teilen.';

  @override
  String get release_core_fleet_no_address => 'Noch keine Gateway-Adresse';

  @override
  String release_core_fleet_diagnostics(String version, String access) {
    return 'Gateway $version · $access';
  }

  @override
  String get release_core_schedule_builtin => 'integriert';

  @override
  String get release_core_memory_gateway_profile => 'Gateway';

  @override
  String release_core_memory_profile_summary(String profile, String gateway) {
    return 'Profil $profile auf $gateway. Der Freigabecode speichert nur Zoom, Zeit und Filter.';
  }

  @override
  String release_core_memory_layers_summary(
    int memoryBytes,
    int userBytes,
    String provider,
  ) {
    return 'Integriertes Gedächtnis: $memoryBytes Bytes, Benutzer: $userBytes Bytes. Aktiver Anbieter: $provider.';
  }

  @override
  String get release_core_memory_kind_all => 'Alle';

  @override
  String get release_core_memory_kind_skill => 'Fähigkeiten';

  @override
  String get release_core_memory_kind_memory => 'Gedächtnis';

  @override
  String get release_core_workspace_failure_stale => 'Verbindung geändert';

  @override
  String get release_core_workspace_failure_unbound =>
      'kein verifiziertes Arbeitsverzeichnis';

  @override
  String get release_core_workspace_failure_denied => 'Berechtigung verweigert';

  @override
  String get release_core_workspace_failure_ineligible =>
      'Vorgang für diese Datei nicht erlaubt';

  @override
  String get release_core_workspace_failure_unsupported =>
      'von diesem Gateway nicht unterstützt';

  @override
  String get release_core_workspace_failure_mismatch =>
      'entfernter Zustand geändert';

  @override
  String get release_core_workspace_failure_invalid =>
      'ungültige Gateway-Antwort';

  @override
  String get release_core_workspace_failure_insecure =>
      'sichere Verbindung erforderlich';

  @override
  String get release_core_workspace_failure_unavailable =>
      'Gateway nicht verfügbar';

  @override
  String get release_core_queue_state_queued => 'In Warteschlange';

  @override
  String get release_core_queue_state_started => 'Gestartet';

  @override
  String get release_core_queue_state_unknown => 'Ergebnis unbekannt';

  @override
  String get release_core_unknown_state => 'Unbekannt';

  @override
  String get release_core_fleet_state_idle => 'Offline';

  @override
  String get release_core_fleet_state_connected => 'Verbunden';

  @override
  String get release_core_fleet_state_reconnecting =>
      'Verbindung wird wiederhergestellt…';

  @override
  String get release_core_fleet_state_sessionExpired => 'Abgemeldet';

  @override
  String get release_core_fleet_state_failed => 'Verbindung fehlgeschlagen';

  @override
  String release_core_workspace_operation_failed(String reason) {
    return 'Der Gateway-Vorgang konnte nicht bestätigt werden: $reason.';
  }

  @override
  String get release_core_workspace_invalid_data =>
      'Die Daten oder die Eingabe konnten nicht verifiziert werden. Prüfe sie und versuche es erneut.';

  @override
  String
  get release_core_parallel_workspace_layout_changed_in_this_window_but_could_not =>
      'Das Layout wurde in diesem Fenster geändert, konnte aber nicht gespeichert werden.';

  @override
  String get release_core_parallel_workspace_first_pane => 'Erster Bereich';

  @override
  String get release_core_parallel_workspace_second_pane => 'Zweiter Bereich';

  @override
  String get release_core_parallel_workspace_unavailable_page =>
      'Seite nicht verfügbar';

  @override
  String release_core_parallel_workspace_close_a_tab_first_maximum(
    String maximum,
  ) {
    return 'Schließe zuerst einen Tab (maximal $maximum).';
  }

  @override
  String get release_core_parallel_workspace_dock_beside_current_pane =>
      'Neben aktuellem Bereich andocken';

  @override
  String get release_core_parallel_workspace_add_chat => 'Chat hinzufügen';

  @override
  String
  get release_core_parallel_workspace_action_failed_check_the_connection_and_try_again =>
      'Aktion fehlgeschlagen. Prüfe die Verbindung und versuche es erneut.';

  @override
  String
  get release_core_parallel_workspace_close_a_tab_before_reopening_another =>
      'Schließe einen Tab, bevor du einen weiteren erneut öffnest.';

  @override
  String release_core_parallel_workspace_replace_layout(String name) {
    return 'Layout „$name“ ersetzen?';
  }

  @override
  String
  get release_core_parallel_workspace_layout_limit_reached_replace_an_existing_layout =>
      'Layoutlimit erreicht. Ersetze ein vorhandenes Layout.';

  @override
  String get release_core_parallel_workspace_restore_layout =>
      'Layout wiederherstellen';

  @override
  String get release_core_parallel_workspace_workspace_options =>
      'Arbeitsbereichsoptionen';

  @override
  String get release_core_parallel_workspace_dock_another_pane =>
      'Weiteren Bereich andocken';

  @override
  String get release_core_parallel_workspace_swap_panes => 'Bereiche tauschen';

  @override
  String get release_core_parallel_workspace_undock_second_pane =>
      'Zweiten Bereich abdocken';

  @override
  String get release_core_parallel_workspace_arrange_side_by_side =>
      'Nebeneinander anordnen';

  @override
  String get release_core_parallel_workspace_arrange_top_to_bottom =>
      'Untereinander anordnen';

  @override
  String release_core_parallel_workspace_change_split_size(String percent) {
    return 'Aufteilungsgröße ändern ($percent%)';
  }

  @override
  String get release_core_parallel_workspace_focus_pane_full_screen =>
      'Bereich im Vollbild fokussieren';

  @override
  String get release_core_parallel_workspace_open_chat_in_new_window =>
      'Chat in neuem Fenster öffnen';

  @override
  String get release_core_parallel_workspace_hide_pane_keep_running =>
      'Bereich ausblenden (weiterlaufen lassen)';

  @override
  String get release_core_parallel_workspace_previous_tab => 'Vorheriger Tab';

  @override
  String get release_core_parallel_workspace_next_tab => 'Nächster Tab';

  @override
  String get release_core_parallel_workspace_move_tab_left =>
      'Tab nach links verschieben';

  @override
  String get release_core_parallel_workspace_move_tab_right =>
      'Tab nach rechts verschieben';

  @override
  String get release_core_parallel_workspace_reload_current_tab =>
      'Aktuellen Tab neu laden';

  @override
  String get release_core_parallel_workspace_close_tab => 'Tab schließen';

  @override
  String get release_core_parallel_workspace_close_other_tabs =>
      'Andere Tabs schließen';

  @override
  String get release_core_parallel_workspace_close_tabs_to_the_right =>
      'Tabs rechts schließen';

  @override
  String get release_core_parallel_workspace_close_all_tabs =>
      'Alle Tabs schließen';

  @override
  String get release_core_parallel_workspace_reopen_closed_tab =>
      'Geschlossenen Tab erneut öffnen';

  @override
  String get release_core_parallel_workspace_save_named_layout =>
      'Benanntes Layout speichern';

  @override
  String get release_core_parallel_workspace_restore_named_layout =>
      'Benanntes Layout wiederherstellen';

  @override
  String get release_core_parallel_workspace_refresh_chat_list =>
      'Chatliste aktualisieren';

  @override
  String get release_core_parallel_workspace_workspace_tools =>
      'Arbeitsbereichs-Tools';

  @override
  String get release_core_parallel_workspace_choose_a_chat_for_this_pane =>
      'Chat für diesen Bereich wählen';

  @override
  String release_core_parallel_workspace_choose_chat_for(String pane) {
    return 'Chat für $pane wählen';
  }

  @override
  String get release_core_parallel_workspace_add_a_chat_to_start_a_workspace =>
      'Füge einen Chat hinzu, um einen Arbeitsbereich zu starten.';

  @override
  String get release_core_parallel_workspace_select_a_tab_to_show_its_pane =>
      'Wähle einen Tab aus, um seinen Bereich anzuzeigen.';

  @override
  String get release_core_parallel_workspace_parallel_workspace =>
      'Paralleler Arbeitsbereich';

  @override
  String get release_core_parallel_workspace_show_workspace =>
      'Arbeitsbereich anzeigen';

  @override
  String get release_core_parallel_workspace_could_not_load_chats_retry =>
      'Chats konnten nicht geladen werden. Erneut versuchen';

  @override
  String release_core_parallel_workspace_close(String pane) {
    return '$pane schließen';
  }

  @override
  String release_core_parallel_workspace_switch_pane(String pane) {
    return 'Bereich wechseln: $pane';
  }

  @override
  String get release_core_workspace_registry_session_id_copied =>
      'Sitzungs-ID kopiert.';

  @override
  String get release_core_workspace_registry_chat_details => 'Chatdetails';

  @override
  String get release_core_workspace_registry_server_default => 'Serverstandard';

  @override
  String get release_core_workspace_registry_session_id => 'Sitzungs-ID';

  @override
  String get release_core_workspace_registry_title => 'Titel';

  @override
  String get release_core_workspace_label_terminals => 'Terminals';

  @override
  String get release_core_workspace_label_copy_id => 'Sitzungs-ID kopieren';

  @override
  String get release_core_workspace_label_contributions => 'Beiträge';

  @override
  String get release_core_workspace_owner_inactive =>
      'Der Eigentümer dieses Arbeitsbereichs ist nicht mehr aktiv.';

  @override
  String get release_core_workspace_select_chat =>
      'Wähle zuerst einen Chat aus.';

  @override
  String get release_core_workspace_chat_unavailable =>
      'Dieser Chat ist für diese Verbindung nicht verfügbar.';

  @override
  String get release_core_workspace_page_unavailable =>
      'Diese Seite ist für diese Verbindung nicht verfügbar.';

  @override
  String release_core_client_queue_count(int count) {
    return '$count in Warteschlange';
  }

  @override
  String release_core_client_queue_paused_count(int count) {
    return '$count in Warteschlange — pausiert';
  }

  @override
  String release_core_git_diff_truncated(String diff) {
    return '$diff\n… gekürzt';
  }

  @override
  String get release_core_search_no_models =>
      'Hermes hat keine konfigurierten auswählbaren Modelle zurückgegeben.';

  @override
  String get release_core_chat_archive_unavailable =>
      'Die Chat-Archivierung ist nicht verfügbar.';

  @override
  String get release_core_chat_pin_unconfirmed =>
      'Der Anheftungsstatus wurde nicht bestätigt.';

  @override
  String get release_core_chat_archive_unconfirmed =>
      'Der Archivstatus wurde nicht bestätigt.';

  @override
  String get release_core_chat_archive_history_unavailable =>
      'Archivierter Verlauf nicht verfügbar';

  @override
  String get release_core_quick_chat_history_unavailable =>
      'Schnellchat-Verlauf nicht verfügbar';

  @override
  String get release_core_chat_project_ownership_unavailable =>
      'Projektzugehörigkeit nicht verfügbar';

  @override
  String get release_core_chat_unknown_project => 'Unbekanntes Projekt';

  @override
  String get release_core_chat_local_search_fallback =>
      'Nachrichtensuche nicht verfügbar. Lokale Treffer werden angezeigt.';

  @override
  String release_core_fleet_update_eligible(String version) {
    return 'Für Update geeignet · $version';
  }

  @override
  String get release_core_fleet_update_state_1 =>
      'Übersprungen: dieselbe Installation';

  @override
  String get release_core_fleet_update_state_2 => 'Nicht geprüft';

  @override
  String get release_core_fleet_update_state_3 =>
      'Übersprungen: Cloud-verwaltet';

  @override
  String get release_core_fleet_update_state_4 =>
      'Übersprungen: nicht als direktes Gateway registriert';

  @override
  String get release_core_fleet_update_state_5 =>
      'Übersprungen: getrennt oder beschäftigt';

  @override
  String get release_core_fleet_update_state_6 => 'Kein passendes Update';

  @override
  String get release_core_fleet_update_state_7 =>
      'Update-Berechtigung konnte nicht verifiziert werden';

  @override
  String get release_core_fleet_update_state_8 =>
      'Übersprungen: veraltet, beschäftigt oder bereits angefordert';

  @override
  String get release_core_fleet_update_state_9 => 'Wird angefordert';

  @override
  String get release_core_fleet_update_state_10 =>
      'Angenommen; Bestätigung nicht verfügbar';

  @override
  String get release_core_fleet_update_state_11 =>
      'Angenommen; Bestätigung ausstehend';

  @override
  String get release_core_fleet_update_state_12 =>
      'Übersprungen: auf dieser Installation läuft ein Chat';

  @override
  String get release_core_fleet_update_state_13 =>
      'Nicht bestätigt; nicht automatisch erneut senden';

  @override
  String get release_core_fleet_update_state_14 =>
      'Erneut verbinden, um die Bestätigung zu prüfen';

  @override
  String get release_core_fleet_update_state_15 =>
      'Bestätigung nicht verfügbar';

  @override
  String get release_core_fleet_update_state_16 =>
      'Passende Bestätigung ausstehend';

  @override
  String get release_core_fleet_update_state_17 =>
      'Aktualisiert; Nacharbeiten erforderlich';

  @override
  String get release_core_fleet_update_state_19 => 'Teilweise aktualisiert';

  @override
  String get release_core_fleet_update_state_20 => 'Update fehlgeschlagen';

  @override
  String get release_core_fleet_update_state_21 => 'Nicht bestätigt';

  @override
  String get release_core_cloud_status_ready => 'Bereit';

  @override
  String get release_core_cloud_status_online => 'Online';

  @override
  String get release_core_cloud_status_stopped => 'Gestoppt';

  @override
  String get release_core_cloud_status_error => 'Fehler';

  @override
  String get ng_release_more_contributions_subtitle =>
      'Geprüfte Antwortkarten für diese Verbindung';

  @override
  String get ng_release_more_gateway_fleet => 'Gateway-Flotte';

  @override
  String get ng_release_more_memory_graph => 'Gedächtnisgraph';

  @override
  String get ng_release_more_memory_graph_subtitle =>
      'Zeitleiste, Bearbeitungen und Gedächtnisanbieter';

  @override
  String get ng_release_more_capabilities_subtitle =>
      'Fähigkeiten, Plugins, Konnektoren und Tool-Backends installieren und verwalten';

  @override
  String get ng_release_more_browser_vault => 'Browser-Tresor';

  @override
  String get ng_release_more_browser_vault_subtitle =>
      'Website-Anmeldungen, Adressen, Karten und Zugangsdatenquellen';

  @override
  String get ng_release_more_agent_policy => 'Agentenrichtlinie';

  @override
  String get ng_release_more_agent_policy_subtitle =>
      'Genehmigungen, Prüfpunkte, Browserzugriff und gemeinsame Metriken';

  @override
  String get ng_release_more_schedules => 'Zeitpläne';

  @override
  String get ng_release_more_schedules_subtitle =>
      'Alle Profile, Vorlagen, Nachholen und Stoppen';

  @override
  String get ng_release_more_host_subtitle =>
      'Remote-Protokolle, Systemzustand, Wartung und Updates';

  @override
  String get ng_release_more_providers_routes => 'Anbieter und Routen';

  @override
  String get ng_release_more_providers_routes_subtitle =>
      'Schlüssel, Endpunkte, Delegation und Mischungen';

  @override
  String get ng_release_more_credits_plans => 'Guthaben und Tarife';

  @override
  String get ng_release_more_credits_plans_subtitle =>
      'Nous-Abrechnung mit Einwilligung, sofern das Konto es erlaubt';

  @override
  String get ng_release_sign_in_or => 'oder';

  @override
  String ng_release_deployment_sign_in_hint(String message) {
    return '$message Du kannst dich im nächsten Schritt weiterhin mit einem Sitzungstoken der Bereitstellung anmelden.';
  }

  @override
  String get ng_release_message_search_unavailable =>
      'Nachrichtensuche nicht verfügbar. Lokale Treffer werden angezeigt.';

  @override
  String ng_release_insights_days(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage',
      one: '$days Tag',
    );
    return '$_temp0';
  }

  @override
  String get ng_release_signed_in_you => 'du';

  @override
  String get release_chat_unsent_prompt_gone =>
      'Dieser ungesendete Prompt ist nicht mehr in der Warteschlange.';

  @override
  String ng_release_attachment_not_attached(String name) {
    return 'Das Gateway hat $name nicht angehängt.';
  }

  @override
  String get ng_release_gateway_not_connected =>
      'Noch nicht mit dem Gateway verbunden.';

  @override
  String get ng_release_gateway_unreachable =>
      'Das Gateway konnte nicht erreicht werden.';

  @override
  String get ng_release_projects_scope_changed =>
      'Der Projektbereich ist nicht mehr ausgewählt';

  @override
  String get ng_release_missing_providers => 'Anbieter fehlen';

  @override
  String get ng_release_missing_tasks => 'Aufgaben fehlen';

  @override
  String ng_release_age_minutes(int count) {
    return '$count Min.';
  }

  @override
  String ng_release_age_hours(int count) {
    return '$count Std.';
  }

  @override
  String ng_release_age_days(int count) {
    return '$count T.';
  }

  @override
  String ng_release_age_weeks(int count) {
    return '$count Wo.';
  }

  @override
  String ng_release_age_years(int count) {
    return '$count J.';
  }

  @override
  String ng_release_compact_billions(String count) {
    return '$count Mrd.';
  }

  @override
  String ng_release_compact_millions(String count) {
    return '$count Mio.';
  }

  @override
  String ng_release_compact_thousands(String count) {
    return '$count Tsd.';
  }

  @override
  String ng_release_token_thousands(String count) {
    return '$count Tsd.';
  }

  @override
  String ng_release_elapsed_minutes_seconds(int minutes, int seconds) {
    return '$minutes Min. $seconds Sek.';
  }

  @override
  String ng_release_elapsed_seconds(int seconds) {
    return '$seconds Sek.';
  }

  @override
  String get ng_release_notification_foreground =>
      'Ares war auf dem Bildschirm';

  @override
  String get ng_release_notification_stopped => 'der Turn wurde gestoppt';

  @override
  String get ng_release_more_parallel_workspace => 'Paralleler Arbeitsbereich';

  @override
  String get ng_release_more_parallel_workspace_subtitle =>
      'Mehrere Chats in Tabs oder nebeneinander öffnen.';

  @override
  String get release_chat_unknown_model => 'unbekannt';

  @override
  String release_chat_profile_default(String model) {
    return 'Profilstandard: $model';
  }

  @override
  String release_chat_profile_default_provider(String model, String provider) {
    return 'Profilstandard: $model • $provider';
  }

  @override
  String get release_chat_choose_provider =>
      'Dieses Modell ist bei mehreren Anbietern verfügbar. Wähle einen Anbieter aus, um fortzufahren.';

  @override
  String get release_chat_slash_needs_gateway =>
      'Slash-Befehle benötigen das Desktop-Gateway';

  @override
  String get release_chat_recovering_without_resending =>
      'Wiederherstellung ohne erneutes Senden';

  @override
  String get release_chat_live_request_unreachable =>
      'Entschuldigung, ich konnte Hermes für diese Anfrage nicht erreichen.';

  @override
  String release_chat_live_working(String tool) {
    return 'Hermes arbeitet: $tool. Noch nicht fertig.';
  }

  @override
  String get release_chat_live_finished_without_spoken_result =>
      'Hermes hat diese Anfrage ohne gesprochenes Ergebnis abgeschlossen.';

  @override
  String get release_chat_reply_language_unavailable =>
      'Die ausgewählte Antwortsprache ist nicht verfügbar';

  @override
  String get release_chat_reply_voice_unavailable =>
      'Die ausgewählte Antwortstimme ist nicht verfügbar';

  @override
  String get release_chat_reply_voice_configuration_unavailable =>
      'Die Konfiguration der Antwortstimme ist nicht verfügbar';

  @override
  String get release_chat_notification_review_action =>
      'Öffne den Chat, um die angeforderte Aktion zu prüfen.';

  @override
  String get release_chat_notification_respond =>
      'Öffne den Chat, um zu antworten.';

  @override
  String get release_chat_start_new_main_window =>
      'Starte einen neuen Chat im Hauptfenster.';

  @override
  String get release_chat_no_desktop_gateway => 'Kein Desktop-Gateway';

  @override
  String get release_chat_attachment_preparation_cancelled =>
      'Die Vorbereitung des Anhangs wurde abgebrochen.';

  @override
  String get release_chat_approval_authority_revoked =>
      'Die Genehmigungsbefugnis wurde widerrufen.';

  @override
  String get release_chat_gateway_session_disconnected =>
      'Die Desktop-Gateway-Sitzung ist nicht mehr verbunden';

  @override
  String get release_chat_stop_requested =>
      'Stopp angefordert. Warte auf den Abschluss durch Hermes.';

  @override
  String release_chat_stop_request_failed(String error) {
    return 'Stopp konnte nicht angefordert werden: $error';
  }

  @override
  String get release_chat_queued_prompt_not_sent =>
      'Der Prompt aus der Warteschlange wurde nicht gesendet.';

  @override
  String get release_chat_running_turn_unreachable =>
      'Der laufende Turn konnte nicht erreicht werden. Die Verbindung wird ohne erneutes Senden wiederhergestellt.';

  @override
  String get release_chat_wait_for_composer =>
      'Warte, bis das Eingabefeld verfügbar ist.';

  @override
  String get release_chat_find_in_transcript => 'Im Transkript suchen';

  @override
  String get release_chat_open_browser_preview => 'Browservorschau öffnen';

  @override
  String get release_chat_more_tools => 'Weitere Chat-Tools';

  @override
  String get release_chat_queue_until_finished =>
      'Bis zum Ende dieses Turns in die Warteschlange stellen';

  @override
  String get release_chat_format_bold => 'Fett';

  @override
  String get release_chat_format_italic => 'Kursiv';

  @override
  String get ng_release_chat_gateway_queue_requirements =>
      'Die Gateway-Warteschlange erfordert einen angehängten Chat und einen reinen Text-Prompt.';

  @override
  String get ng_release_chat_start_new_main_screen =>
      'Starte einen neuen Chat über den Haupt-Chatbildschirm.';

  @override
  String get ng_release_chat_image => 'Bild';

  @override
  String ng_release_chat_tool_seconds(String seconds) {
    return '$seconds Sek.';
  }

  @override
  String get release_preview_chat_changed =>
      'Chat geändert. Verbinde die Vorschau erneut, um fortzufahren.';

  @override
  String get release_preview_authenticating_chat =>
      'Chat wird authentifiziert…';

  @override
  String release_preview_unavailable_reason(String reason) {
    return 'Vorschau nicht verfügbar: $reason';
  }

  @override
  String get release_preview_operation_failed =>
      'Vorschauvorgang fehlgeschlagen.';

  @override
  String get release_preview_added_to_draft =>
      'Zum Entwurf hinzugefügt. Nichts gesendet.';

  @override
  String get release_preview_open_site_title => 'Diese Website öffnen?';

  @override
  String release_preview_open_site_body(String origin) {
    return '$origin\n\nDer Lesemodus lädt nur dieses Dokument. Cookies, Anmeldedaten oder die Seite werden nicht mit Hermes geteilt.';
  }

  @override
  String get release_preview_open_site => 'Website öffnen';

  @override
  String get release_preview_discard_pins_title =>
      'Noch nicht zum Entwurf hinzugefügte Markierungen verwerfen?';

  @override
  String get release_preview_keep_pins => 'Markierungen beibehalten';

  @override
  String get release_preview_share_page_title =>
      'Diese Seite mit diesem Chat teilen?';

  @override
  String release_preview_share_page_body(String origin) {
    return 'Hermes kann den angezeigten Text und die Elementliste von $origin lesen und in diesem Bereich scrollen. Eine Navigation beendet die Freigabe. Formulare und Zugangsdaten werden nicht geteilt.';
  }

  @override
  String get release_preview_share_page => 'Seite teilen';

  @override
  String release_preview_comment_number(int number) {
    return 'Kommentar #$number';
  }

  @override
  String get release_preview_note => 'Notiz';

  @override
  String get release_preview_keep_pin => 'Markierung beibehalten';

  @override
  String get release_preview_title => 'Browservorschau';

  @override
  String get release_preview_hide => 'Vorschau ausblenden';

  @override
  String get release_preview_close_and_forget =>
      'Schließen und Seite vergessen';

  @override
  String get release_preview_site_address => 'Website-Adresse';

  @override
  String get release_preview_go_to_address => 'Adresse aufrufen';

  @override
  String get release_preview_forward => 'Vorwärts';

  @override
  String get release_preview_reload => 'Neu laden';

  @override
  String get release_preview_share_with_hermes => 'Seite mit Hermes teilen';

  @override
  String get release_preview_stop_sharing => 'Seitenfreigabe beenden';

  @override
  String get release_preview_annotate => 'Element oder Bereich kommentieren';

  @override
  String get release_preview_reader_console => 'Lesekonsole';

  @override
  String get release_preview_reconnect => 'Vorschau erneut verbinden';

  @override
  String get release_preview_reader_mode_help =>
      'Lesemodus: HTML und Text. Keine Skripte, keine eingebetteten Ressourcen und kein angemeldetes Browserprofil.';

  @override
  String release_preview_sharing_origin(String origin) {
    return 'Leseansicht mit diesem Chat geteilt: $origin';
  }

  @override
  String get release_preview_annotation_help =>
      'Tippe auf ein Element oder ziehe einen Bereich auf, um einen Kommentar hinzuzufügen.';

  @override
  String get release_preview_reader_requests =>
      'Leseanfragen (JavaScript ist deaktiviert)';

  @override
  String release_preview_selected_requests(int count) {
    return '$count ausgewählt · JavaScript ist deaktiviert';
  }

  @override
  String get release_preview_copy_all => 'Alles kopieren';

  @override
  String get release_preview_copy_selected => 'Ausgewählte kopieren';

  @override
  String get release_preview_add_log_to_draft =>
      'Protokoll zum Entwurf hinzufügen';

  @override
  String release_preview_requests_draft(String log) {
    return 'Leseanfragen:\n$log';
  }

  @override
  String release_preview_add_pins_to_draft(int count) {
    return '$count zum Entwurf hinzufügen';
  }

  @override
  String release_preview_request_loaded(String origin, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Leseelemente',
      one: '$count Leseelement',
    );
    return 'HTTP 200 · $origin · $_temp0';
  }

  @override
  String release_preview_annotation_intro(String origin) {
    return 'Prüfe diese Kommentare zur Vorschau von $origin. Die angehängten Ausschnitte sind in derselben Reihenfolge nummeriert.';
  }

  @override
  String get release_preview_reader_region => 'Lesebereich';

  @override
  String get release_preview_capture_failed =>
      'Diese Pixel konnten nicht erfasst werden.';

  @override
  String get release_preview_address_not_approved =>
      'Diese Adresse liegt außerhalb des genehmigten Vorschau-Ursprungs.';

  @override
  String get release_preview_page_limit =>
      'Die Seite überschreitet das Limit des Lesemodus.';

  @override
  String get release_preview_page_unreadable =>
      'Die Seite konnte nicht gelesen werden.';

  @override
  String get release_preview_page_complex =>
      'Diese Seite ist für den Lesemodus zu komplex.';

  @override
  String release_preview_http_failed(int statusCode) {
    return 'HTTP $statusCode. Es wurde keiner Weiterleitung gefolgt und keine Anmeldung durchgeführt.';
  }

  @override
  String get release_preview_unsupported_type =>
      'Im Lesemodus können nur HTML und einfacher Text geöffnet werden.';

  @override
  String get release_preview_load_insecure =>
      'Die Website konnte nicht sicher geladen werden.';

  @override
  String get release_preview_crop_limit =>
      'Der Vorschauausschnitt überschreitet sein Limit.';

  @override
  String get release_preview_image_unreadable =>
      'Das ausgewählte Bild ist leer oder nicht lesbar.';

  @override
  String get release_preview_image_budget =>
      'Das ausgewählte Bild überschreitet das Entwurfslimit von 64 MiB.';

  @override
  String get release_preview_image_format =>
      'Nicht unterstütztes Bildformat. Wähle ein JPEG-, PNG- oder WebP-Bild.';

  @override
  String get release_preview_image_decode =>
      'Das ausgewählte JPEG-, PNG- oder WebP-Bild konnte nicht sicher decodiert werden.';

  @override
  String get release_preview_image_sanitize =>
      'Dieses Bild konnte nicht bereinigt werden. Wähle ein gültiges JPEG-, PNG- oder WebP-Bild.';

  @override
  String get release_preview_draft_budget =>
      'Anhänge sind auf insgesamt 64 MiB pro Entwurf begrenzt.';

  @override
  String get release_preview_generic_file_limit =>
      'Sonstige Dateien sind auf jeweils 16 MiB begrenzt.';

  @override
  String get release_preview_image_not_sanitized =>
      'Entfernte Bilder müssen vor dem Hochladen bereinigt werden.';

  @override
  String get release_preview_stage_failed =>
      'Vorschau-Belege konnten nicht zum Entwurf hinzugefügt werden. Versuche es erneut.';

  @override
  String get release_misc_find_hermes_on_lan => 'Hermes im LAN suchen';

  @override
  String release_misc_discovery_failed(String error) {
    return 'Suche fehlgeschlagen: $error';
  }

  @override
  String get release_misc_no_lan_servers =>
      'Keine Hermes-Server im lokalen Netzwerk gefunden.';

  @override
  String release_misc_api_key_rejected(String endpoint, int statusCode) {
    return 'Der API-Schlüssel wurde von $endpoint abgelehnt (HTTP $statusCode).';
  }

  @override
  String get release_misc_api_key_required =>
      'Der Server erfordert einen API-Schlüssel. Gib deinen API_SERVER_KEY ein.';

  @override
  String release_misc_gateway_not_found(String endpoint) {
    return 'Gateway-Endpunkt $endpoint hat HTTP 404 zurückgegeben. Prüfe das Gateway-Pfadpräfix und die Reverse-Proxy-Routen.';
  }

  @override
  String release_misc_gateway_http_error(String endpoint, int statusCode) {
    return 'Gateway-Endpunkt $endpoint hat HTTP $statusCode zurückgegeben.';
  }

  @override
  String release_misc_gateway_unreachable(String endpoint) {
    return 'Gateway-Endpunkt $endpoint nicht erreichbar.';
  }

  @override
  String get release_core_schedule_invalid_delivery_target =>
      'Ungültiges Zustellziel';

  @override
  String get release_core_file_save_direct_only =>
      'Nur eine Datei direkt im Arbeitsverzeichnis kann gespeichert werden.';

  @override
  String get release_core_file_save_hidden =>
      'Versteckte Dateien können vom Gateway nicht gespeichert werden.';

  @override
  String get rel_admin_choose_provider =>
      'Wähle einen Anbieter und ein Modell.';

  @override
  String get rel_admin_known_effort => 'Wähle eine bekannte Aufwandsstufe.';

  @override
  String get rel_admin_endpoint_name_required =>
      'Gib einen Namen für diesen Endpunkt ein.';

  @override
  String get rel_admin_endpoint_model_required =>
      'Gib das Modell ein, das dieser Endpunkt bereitstellt.';

  @override
  String get rel_admin_known_api_mode =>
      'Wähle Automatisch oder einen bekannten API-Modus.';

  @override
  String get rel_admin_endpoint_id_invalid =>
      'Diese Endpunktkennung ist nicht verwendbar.';

  @override
  String get rel_admin_endpoint_https =>
      'Verwende HTTPS für einen entfernten Endpunkt oder HTTP auf localhost.';

  @override
  String get rel_admin_key_invalid =>
      'Dieser API-Schlüssel kann nicht gespeichert werden.';

  @override
  String get rel_admin_response_shape =>
      'Die Gateway-Antwort hatte nicht die erwartete Struktur.';

  @override
  String get rel_admin_limits_required =>
      'Gib vor dem Speichern Grenzen für Iterationen, Parallelität und Zeitlimit ein.';

  @override
  String get rel_admin_route_required =>
      'Jede Route benötigt vor dem Speichern einen Namen und ein Modell.';

  @override
  String get rel_admin_route_unique => 'Routennamen müssen eindeutig sein.';

  @override
  String get rel_admin_route_default_invalid =>
      'Die Standardroute muss eine der gespeicherten Routen sein.';

  @override
  String get rel_admin_policy_required =>
      'Wähle eine laute oder stille Richtlinie für beeinträchtigte Referenzen.';

  @override
  String get rel_admin_mixture_missing =>
      'Das Gateway hat keine aktive Mischung zurückgegeben.';

  @override
  String get rel_admin_mixture_slots_required =>
      'Gib für den Aggregator und jede Referenz einen Anbieter und ein Modell an.';

  @override
  String get rel_admin_chat_id_required =>
      'Gib die Chat-ID ein, für die diese Änderung gilt.';

  @override
  String rel_admin_http_error(String status) {
    return 'Das Gateway hat HTTP $status zurückgegeben.';
  }

  @override
  String get rel_admin_response_unreadable =>
      'Die Gateway-Antwort konnte nicht gelesen werden.';

  @override
  String get rel_admin_connect_before_change =>
      'Verbinde die Live-Gateway-Sitzung, bevor du Abrechnung oder Chat änderst.';

  @override
  String get rel_admin_operation_unavailable =>
      'Dieses Gateway bietet diesen Vorgang nicht an.';

  @override
  String get rel_admin_key_required => 'Gib den zu speichernden Schlüssel ein.';

  @override
  String get rel_admin_key_save_failed =>
      'Das Gateway hat diesen Schlüssel nicht gespeichert.';

  @override
  String get rel_admin_key_clear_required =>
      'Wähle einen Anbieterschlüssel zum Löschen.';

  @override
  String get rel_admin_key_clear_failed =>
      'Das Gateway hat diesen Schlüssel nicht gelöscht.';

  @override
  String get rel_admin_endpoint_save_failed =>
      'Das Gateway hat diesen Endpunkt nicht gespeichert.';

  @override
  String get rel_admin_endpoint_activate_failed =>
      'Das Gateway hat diesen Endpunkt nicht aktiviert.';

  @override
  String get rel_admin_accounts_secure_required =>
      'Anbieterkonten benötigen ein authentifiziertes HTTPS-Gateway oder localhost.';

  @override
  String get rel_admin_accounts_read_failed =>
      'Anbieterkonten konnten nicht gelesen werden.';

  @override
  String get rel_admin_account_disconnect_failed =>
      'Das Gateway hat dieses Konto nicht getrennt.';

  @override
  String get rel_admin_account_not_disconnectable =>
      'Dieses Anbieterkonto kann nicht getrennt werden.';

  @override
  String get rel_admin_backend_required =>
      'Wähle eines der verfügbaren Delegations-Backends.';

  @override
  String get rel_admin_backend_save_failed =>
      'Das Gateway hat dieses Backend nicht ausgewählt.';

  @override
  String get rel_admin_routes_save_failed =>
      'Das Gateway hat diese Routen nicht gespeichert.';

  @override
  String get rel_admin_profile_route_required =>
      'Jede Profilroute benötigt einen Profilnamen.';

  @override
  String get rel_admin_profile_route_unique =>
      'Profilrouten müssen eindeutig sein.';

  @override
  String get rel_admin_profile_route_default_invalid =>
      'Die Standard-Profilroute muss eines der erlaubten Profile sein.';

  @override
  String get rel_admin_profile_routes_save_failed =>
      'Das Gateway hat diese Profilrouten nicht gespeichert.';

  @override
  String get rel_admin_limits_save_failed =>
      'Das Gateway hat diese Grenzen nicht gespeichert.';

  @override
  String get rel_admin_mixture_save_failed =>
      'Das Gateway hat diese Mischung nicht gespeichert.';

  @override
  String get rel_admin_credit_amount_required =>
      'Wähle einen der angebotenen Guthabenbeträge.';

  @override
  String get rel_admin_charge_check_failed =>
      'Diese Abbuchung konnte nicht geprüft werden.';

  @override
  String get rel_admin_reload_amounts_missing =>
      'Es wurden keine Beträge für die automatische Aufladung angegeben, daher wurden sie nicht geändert.';

  @override
  String get rel_admin_plan_required => 'Wähle zuerst einen Tarif.';

  @override
  String get rel_admin_plan_scheduled_only =>
      'Hier kann nur ein geplanter Tarifwechsel bestätigt werden.';

  @override
  String get rel_admin_billing_refused =>
      'Das Gateway hat diese Abrechnungsanfrage abgelehnt.';

  @override
  String get rel_admin_request_refused =>
      'Das Gateway hat diese Anfrage abgelehnt.';

  @override
  String get rel_admin_endpoint_answered => 'Der Endpunkt hat geantwortet.';

  @override
  String get rel_admin_endpoint_no_answer =>
      'Der Endpunkt hat nicht geantwortet.';

  @override
  String get rel_admin_charge_unknown =>
      'Ausgang der Abbuchung unbekannt. Sie kann noch abgeschlossen werden. Prüfe vor einem erneuten Versuch das Portal.';

  @override
  String get rel_admin_connect_before_billing =>
      'Verbinde die Live-Gateway-Sitzung, bevor du die Abrechnung liest. Auf dieser Seite wird nichts berechnet.';

  @override
  String get rel_admin_preset_required =>
      'Speichere eine Voreinstellung, bevor du sie anwendest.';

  @override
  String get rel_admin_cancel => 'Abbrechen';

  @override
  String get rel_admin_refresh => 'Aktualisieren';

  @override
  String get rel_admin_credits_and_plans => 'Guthaben und Tarife';

  @override
  String get rel_admin_saved => 'Gespeichert';

  @override
  String get rel_admin_name => 'Name';

  @override
  String get rel_admin_base_url => 'Basis-URL';

  @override
  String get rel_admin_model => 'Modell';

  @override
  String get rel_admin_signed_in => 'Angemeldet';

  @override
  String get rel_admin_not_signed_in => 'Nicht angemeldet';

  @override
  String get rel_admin_provider => 'Anbieter';

  @override
  String get rel_admin_apply_to_this_chat => 'Auf diesen Chat anwenden';

  @override
  String get rel_admin_auto => 'Automatisch';

  @override
  String get rel_admin_chat_completions => 'Chat-Vervollständigungen';

  @override
  String get rel_admin_codex_responses => 'Codex-Antworten';

  @override
  String get rel_admin_anthropic_messages => 'Anthropic-Nachrichten';

  @override
  String get rel_admin_could_not_complete_that_request =>
      'Diese Anfrage konnte nicht abgeschlossen werden.';

  @override
  String get rel_admin_confirm => 'Bestätigen';

  @override
  String get rel_admin_providers_and_billing => 'Anbieter und Abrechnung';

  @override
  String get rel_admin_api_keys => 'API-Schlüssel';

  @override
  String get rel_admin_custom_endpoints => 'Benutzerdefinierte Endpunkte';

  @override
  String get rel_admin_provider_accounts => 'Anbieterkonten';

  @override
  String get rel_admin_effort_and_speed_presets =>
      'Voreinstellungen für Aufwand und Geschwindigkeit';

  @override
  String get rel_admin_delegation => 'Delegation';

  @override
  String get rel_admin_mixture_of_agents => 'Agentenmischung';

  @override
  String get rel_admin_no_provider_keys_were_reported_for_this_profile =>
      'Für dieses Profil wurden keine Anbieterschlüssel gemeldet.';

  @override
  String get rel_admin_not_saved => 'Nicht gespeichert';

  @override
  String get rel_admin_new_key_value => 'Neuer Schlüsselwert';

  @override
  String get rel_admin_provider_key_saved => 'Anbieterschlüssel gespeichert.';

  @override
  String get rel_admin_save_key => 'Schlüssel speichern';

  @override
  String get rel_admin_clear_provider_key => 'Anbieterschlüssel löschen';

  @override
  String get rel_admin_provider_key_cleared => 'Anbieterschlüssel gelöscht.';

  @override
  String get rel_admin_clear_key => 'Schlüssel löschen';

  @override
  String get rel_admin_new_endpoint => 'Neuer Endpunkt';

  @override
  String get rel_admin_api_key => 'API-Schlüssel';

  @override
  String get rel_admin_leave_blank_to_keep_a_key_this_endpoint_already_has =>
      'Leer lassen, um einen vorhandenen Schlüssel dieses Endpunkts zu behalten.';

  @override
  String get rel_admin_reachable => 'Erreichbar';

  @override
  String get rel_admin_unreachable => 'Nicht erreichbar';

  @override
  String get rel_admin_test_endpoint => 'Endpunkt testen';

  @override
  String get rel_admin_endpoint_saved => 'Endpunkt gespeichert.';

  @override
  String get rel_admin_save_endpoint => 'Endpunkt speichern';

  @override
  String get rel_admin_use_this_endpoint => 'Diesen Endpunkt verwenden';

  @override
  String
  get rel_admin_make_this_named_endpoint_the_current_model_for_this_profile =>
      'Diesen benannten Endpunkt zum aktuellen Modell für dieses Profil machen?';

  @override
  String get rel_admin_endpoint_is_now_current => 'Endpunkt ist jetzt aktuell.';

  @override
  String get rel_admin_use_endpoint => 'Endpunkt verwenden';

  @override
  String get rel_admin_delete_endpoint => 'Endpunkt löschen';

  @override
  String get rel_admin_delete_this_named_endpoint_from_the_profile =>
      'Diesen benannten Endpunkt aus dem Profil löschen?';

  @override
  String get rel_admin_endpoint_deleted => 'Endpunkt gelöscht.';

  @override
  String get rel_admin_signing_in_stays_on_the_provider_sign_in_screen =>
      'Die Anmeldung bleibt auf dem Anmeldebildschirm des Anbieters. Die Trennung erfolgt nur, wenn dieses Gateway das Entfernen des Kontos erlaubt.';

  @override
  String get rel_admin_disconnect_this_provider_account_on_the_gateway =>
      'Dieses Anbieterkonto am Gateway trennen?';

  @override
  String get rel_admin_provider_account_disconnected =>
      'Anbieterkonto getrennt.';

  @override
  String get rel_admin_disconnect => 'Trennen';

  @override
  String get rel_admin_not_disconnectable => 'Nicht trennbar';

  @override
  String get rel_admin_fast => 'Schnell';

  @override
  String get rel_admin_preset_saved_for_this_model =>
      'Voreinstellung für dieses Modell gespeichert.';

  @override
  String get rel_admin_save_preset => 'Voreinstellung speichern';

  @override
  String get rel_admin_chat_id => 'Chat-ID';

  @override
  String get rel_admin_apply_preset => 'Voreinstellung anwenden';

  @override
  String get rel_admin_set_this_chat_s_effort_and_speed_from_the_saved_preset =>
      'Aufwand und Geschwindigkeit dieses Chats aus der gespeicherten Voreinstellung übernehmen?';

  @override
  String get rel_admin_preset_applied_to_this_chat =>
      'Voreinstellung auf diesen Chat angewendet.';

  @override
  String get rel_admin_this_route_sends_the_picked_effort_unchanged =>
      'Diese Route sendet den gewählten Aufwand unverändert.';

  @override
  String get rel_admin_show_route_clamp => 'Routenbegrenzung anzeigen';

  @override
  String get rel_admin_delegation_backend => 'Delegations-Backend';

  @override
  String get rel_admin_delegation_backend_saved =>
      'Delegations-Backend gespeichert.';

  @override
  String get rel_admin_save_backend => 'Backend speichern';

  @override
  String get rel_admin_max_iterations => 'Maximale Iterationen';

  @override
  String get rel_admin_max_concurrent_children =>
      'Maximale parallele Unteragenten';

  @override
  String get rel_admin_child_timeout_seconds =>
      'Zeitlimit für Unteragenten in Sekunden';

  @override
  String get rel_admin_delegation_effort_leave_unchanged =>
      'Delegationsaufwand, unverändert lassen';

  @override
  String get rel_admin_delegation_limits_saved =>
      'Delegationsgrenzen gespeichert.';

  @override
  String get rel_admin_save_limits => 'Grenzen speichern';

  @override
  String get rel_admin_remove_route => 'Route entfernen';

  @override
  String get rel_admin_route_name => 'Routenname';

  @override
  String get rel_admin_route_provider => 'Routenanbieter';

  @override
  String get rel_admin_route_model => 'Routenmodell';

  @override
  String get rel_admin_route_effort_unchanged => 'Routenaufwand unverändert';

  @override
  String get rel_admin_add_route => 'Route hinzufügen';

  @override
  String get rel_admin_default_route => 'Standardroute';

  @override
  String get rel_admin_delegation_routes_saved =>
      'Delegationsrouten gespeichert.';

  @override
  String get rel_admin_save_routes => 'Routen speichern';

  @override
  String get rel_admin_profile_routes_saved => 'Profilrouten gespeichert.';

  @override
  String get rel_admin_save_profile_routes => 'Profilrouten speichern';

  @override
  String get rel_admin_no_mixture_is_loaded => 'Keine Mischung geladen.';

  @override
  String get rel_admin_mixture_enabled => 'Mischung aktiviert';

  @override
  String get rel_admin_loud_degraded_references =>
      'Laute beeinträchtigte Referenzen';

  @override
  String get rel_admin_silent_degraded_references =>
      'Stille beeinträchtigte Referenzen';

  @override
  String get rel_admin_aggregator => 'Aggregator';

  @override
  String get rel_admin_aggregator_provider => 'Aggregator-Anbieter';

  @override
  String get rel_admin_aggregator_model => 'Aggregator-Modell';

  @override
  String get rel_admin_reference_provider => 'Referenzanbieter';

  @override
  String get rel_admin_reference_model => 'Referenzmodell';

  @override
  String get rel_admin_add_reference_model => 'Referenzmodell hinzufügen';

  @override
  String get rel_admin_mixture_saved => 'Mischung gespeichert.';

  @override
  String get rel_admin_save_mixture => 'Mischung speichern';

  @override
  String get rel_admin_credit_purchase_submitted => 'Guthabenkauf übermittelt.';

  @override
  String get rel_admin_credit_purchase_settled => 'Guthabenkauf abgeschlossen.';

  @override
  String get rel_admin_credit_and_plan_changes_wait_for_confirmation_a_plan =>
      'Guthaben- und Tarifänderungen warten auf Bestätigung. Ein Tarif mit sofortiger Abbuchung wird hier angezeigt, aber nicht bestätigt.';

  @override
  String get rel_admin_buy_credits => 'Guthaben kaufen';

  @override
  String get rel_admin_retry_same_charge =>
      'Dieselbe Abbuchung erneut versuchen';

  @override
  String get rel_admin_retry_the_same_credit_charge_this_does_not_start =>
      'Dieselbe Guthabenabbuchung erneut versuchen. Dadurch wird kein zweiter Kauf gestartet.';

  @override
  String get rel_admin_credit_purchases_are_not_available_for_this_account =>
      'Guthabenkäufe sind für dieses Konto nicht verfügbar.';

  @override
  String get rel_admin_auto_reload => 'Automatische Aufladung';

  @override
  String get rel_admin_read_only_until_this_account_can_charge =>
      'Schreibgeschützt, bis dieses Konto Abbuchungen erlaubt.';

  @override
  String get rel_admin_auto_reload_updated =>
      'Automatische Aufladung aktualisiert.';

  @override
  String get rel_admin_keep_going_on_credits => 'Mit Guthaben fortfahren';

  @override
  String get rel_admin_continue_on_credits_when_the_plan_window_is_used_up =>
      'Mit Guthaben fortfahren, wenn das Tarifkontingent aufgebraucht ist?';

  @override
  String
  get rel_admin_stop_continuing_on_credits_when_the_plan_window_is_used_up =>
      'Das Fortfahren mit Guthaben beenden, wenn das Tarifkontingent aufgebraucht ist?';

  @override
  String get rel_admin_credit_continuation_updated =>
      'Fortfahren mit Guthaben aktualisiert.';

  @override
  String get rel_admin_this_plan_change_is_not_confirmed_from_ares =>
      'Dieser Tarifwechsel wird nicht über Ares bestätigt.';

  @override
  String get rel_admin_this_change_is_scheduled_confirm_to_apply_it =>
      'Diese Änderung ist geplant. Bestätige sie, um sie anzuwenden.';

  @override
  String get rel_admin_preview_plan => 'Tarifvorschau';

  @override
  String get rel_admin_schedule_plan_change => 'Tarifwechsel planen';

  @override
  String get rel_admin_plan_change_scheduled => 'Tarifwechsel geplant.';

  @override
  String get rel_admin_confirm_scheduled_plan_change =>
      'Geplanten Tarifwechsel bestätigen';

  @override
  String rel_admin_remove_key_confirm(String key) {
    return 'Den gespeicherten Wert $key aus diesem Profil entfernen?';
  }

  @override
  String rel_admin_current_endpoint(String name) {
    return '$name · aktuell';
  }

  @override
  String rel_admin_endpoint_result(
    String status,
    String transport,
    String count,
    String message,
  ) {
    return '$status · $transport · $count Modelle. $message';
  }

  @override
  String rel_admin_disconnect_account(String name) {
    return '$name trennen';
  }

  @override
  String rel_admin_delegation_blocked(String reason) {
    return 'Delegation ist blockiert: $reason';
  }

  @override
  String rel_admin_backend_unavailable(String name) {
    return '$name · nicht verfügbar';
  }

  @override
  String rel_admin_reference_number(String number) {
    return 'Referenz $number';
  }

  @override
  String rel_admin_reload_enable_confirm(String amount, String threshold) {
    return 'Automatische Aufladung aktivieren und $amount abbuchen, wenn das Guthaben unter $threshold fällt?';
  }

  @override
  String rel_admin_reload_disable_confirm(String amount, String threshold) {
    return 'Automatische Aufladung deaktivieren? Derzeit werden $amount abgebucht, wenn das Guthaben unter $threshold fällt.';
  }

  @override
  String get rel_admin_this_plan => 'diesen Tarif';

  @override
  String rel_admin_plan_confirm(String name) {
    return '$name planen. Der Wechsel ist für das Ende des aktuellen Zeitraums vorgesehen. Jetzt wird nichts abgebucht.';
  }

  @override
  String rel_admin_plan_confirm_price(String name, String price) {
    return '$name für $price planen. Der Wechsel ist für das Ende des aktuellen Zeitraums vorgesehen. Jetzt wird nichts abgebucht.';
  }

  @override
  String rel_admin_plan_confirm_when(String name, String when) {
    return '$name planen. Der Wechsel tritt $when in Kraft. Jetzt wird nichts abgebucht.';
  }

  @override
  String rel_admin_plan_confirm_price_when(
    String name,
    String price,
    String when,
  ) {
    return '$name für $price planen. Der Wechsel tritt $when in Kraft. Jetzt wird nichts abgebucht.';
  }

  @override
  String rel_admin_balance(String amount) {
    return 'Guthaben $amount';
  }

  @override
  String rel_admin_buy_confirm(String amount) {
    return '\$$amount über die Zahlungsmethode dieses Nous-Kontos abbuchen. Dabei wird echtes Geld ausgegeben.';
  }

  @override
  String rel_admin_reload_portal(String url) {
    return 'Automatische Aufladung im Portal ändern: $url';
  }

  @override
  String rel_admin_team_portal(String url) {
    return 'Team-Abonnements werden im Portal geändert: $url';
  }

  @override
  String get rel_admin_effort_none => 'keiner';

  @override
  String get rel_admin_effort_minimal => 'minimal';

  @override
  String get rel_admin_effort_low => 'niedrig';

  @override
  String get rel_admin_effort_medium => 'mittel';

  @override
  String get rel_admin_effort_high => 'hoch';

  @override
  String get rel_admin_effort_xhigh => 'sehr hoch';

  @override
  String get rel_admin_effort_max => 'maximal';

  @override
  String get rel_admin_effort_ultra => 'ultrahoch';

  @override
  String get rel_admin_auto_lower => 'Automatisch';

  @override
  String get rel_admin_create => 'Erstellen';

  @override
  String get rel_admin_prompt => 'Prompt';

  @override
  String get rel_admin_new_profile_id => 'Neue Profil-ID';

  @override
  String get rel_admin_this_operation_is_unavailable_on_this_gateway =>
      'Dieser Vorgang ist auf diesem Gateway nicht verfügbar.';

  @override
  String get rel_admin_access_denied_by_the_gateway =>
      'Zugriff vom Gateway verweigert.';

  @override
  String get rel_admin_connection_changed_reopen_profiles =>
      'Verbindung geändert. Öffne Profile erneut.';

  @override
  String
  get rel_admin_invalid_input_or_gateway_response_check_the_target_before =>
      'Ungültige Eingabe oder Gateway-Antwort. Prüfe das Ziel vor einem erneuten Versuch.';

  @override
  String get rel_admin_could_not_verify_the_result_refresh_the_target_before =>
      'Das Ergebnis konnte nicht überprüft werden. Aktualisiere das Ziel vor einem erneuten Versuch.';

  @override
  String get rel_admin_edit_soul_md => 'SOUL.md bearbeiten';

  @override
  String get rel_admin_persona => 'Persona';

  @override
  String get rel_admin_persona_saved => 'Persona gespeichert.';

  @override
  String get rel_admin_not_set => 'nicht gesetzt';

  @override
  String get rel_admin_enabled => 'Aktiviert';

  @override
  String get rel_admin_keys_to_remove_comma_separated =>
      'Zu entfernende Schlüssel (kommagetrennt)';

  @override
  String get rel_admin_saved_and_applied_by_the_gateway =>
      'Vom Gateway gespeichert und angewendet.';

  @override
  String get rel_admin_saved_a_gateway_restart_may_be_required =>
      'Gespeichert. Ein Gateway-Neustart kann erforderlich sein.';

  @override
  String get rel_admin_create_signed_route => 'Signierte Route erstellen';

  @override
  String get rel_admin_route_id => 'Routen-ID';

  @override
  String get rel_admin_signature => 'Signatur';

  @override
  String get rel_admin_events_comma_separated => 'Ereignisse (kommagetrennt)';

  @override
  String get rel_admin_delivery_target => 'Zustellziel';

  @override
  String get rel_admin_skills_comma_separated => 'Skills (kommagetrennt)';

  @override
  String get rel_admin_delivery_mode => 'Zustellmodus';

  @override
  String get rel_admin_delivery_chat_id_optional =>
      'Zustell-Chat-ID (optional)';

  @override
  String get rel_admin_hide_signing_secret => 'Signiergeheimnis ausblenden';

  @override
  String get rel_admin_reveal_signing_secret => 'Signiergeheimnis anzeigen';

  @override
  String get rel_admin_edit_persona => 'Persona bearbeiten';

  @override
  String get rel_admin_portable_profile_bundle => 'Portables Profilpaket';

  @override
  String get rel_admin_clone_profile => 'Profil klonen';

  @override
  String get rel_admin_rename_display_label => 'Anzeigenamen umbenennen';

  @override
  String get rel_admin_rename_profile => 'Profil umbenennen';

  @override
  String get rel_admin_new_name => 'Neuer Name';

  @override
  String get rel_admin_rename_verified => 'Umbenennung bestätigt.';

  @override
  String get rel_admin_delete_profile => 'Profil löschen';

  @override
  String get rel_admin_profile_id_to_delete => 'Zu löschende Profil-ID';

  @override
  String get rel_admin_profile_deleted => 'Profil gelöscht.';

  @override
  String
  get rel_admin_profile_deleted_server_identity_cleanup_is_still_pending =>
      'Profil gelöscht. Die Bereinigung der Serveridentität steht noch aus.';

  @override
  String get rel_admin_export_profile_archive => 'Profilarchiv exportieren';

  @override
  String get rel_admin_import_profile_archive => 'Profilarchiv importieren';

  @override
  String get rel_admin_import_a_trusted_profile =>
      'Vertrauenswürdiges Profil importieren';

  @override
  String get rel_admin_absolute_archive_path_on_gateway =>
      'Absoluter Archivpfad auf dem Gateway';

  @override
  String get rel_admin_messaging_channels => 'Nachrichtenkanäle';

  @override
  String get rel_admin_dm_pairing_requests => 'DM-Kopplungsanfragen';

  @override
  String get rel_admin_no_pending_or_approved_users =>
      'Keine ausstehenden oder genehmigten Nutzer.';

  @override
  String get rel_admin_legacy_pairing_no_verifiable_request_id_ask_the_user =>
      'Alte Kopplung: keine überprüfbare Anfrage-ID. Bitte den Nutzer, sich erneut zu koppeln.';

  @override
  String get rel_admin_pairing_change_verified =>
      'Kopplungsänderung bestätigt.';

  @override
  String get rel_admin_create_telegram_bot_by_qr =>
      'Telegram-Bot per QR erstellen';

  @override
  String get rel_admin_create_telegram_bot => 'Telegram-Bot erstellen';

  @override
  String get rel_admin_bot_name => 'Bot-Name';

  @override
  String get rel_admin_telegram_bot_creation_qr_code =>
      'QR-Code zum Erstellen eines Telegram-Bots';

  @override
  String get rel_admin_check_telegram_pairing => 'Telegram-Kopplung prüfen';

  @override
  String get rel_admin_waiting_for_telegram => 'Warte auf Telegram.';

  @override
  String get rel_admin_apply_telegram_bot => 'Telegram-Bot anwenden';

  @override
  String get rel_admin_allowed_numeric_user_ids =>
      'Erlaubte numerische Nutzer-IDs';

  @override
  String get rel_admin_saved_restart_still_required =>
      'Gespeichert. Neustart weiterhin erforderlich.';

  @override
  String get rel_admin_saved_gateway_restart_requested =>
      'Gespeichert; Gateway-Neustart angefordert.';

  @override
  String get rel_admin_cancel_telegram_setup =>
      'Telegram-Einrichtung abbrechen';

  @override
  String get rel_admin_inbound_webhooks => 'Eingehende Webhooks';

  @override
  String get rel_admin_enable_webhook_service => 'Webhook-Dienst aktivieren';

  @override
  String get rel_admin_enable_webhooks => 'Webhooks aktivieren';

  @override
  String get rel_admin_enabled_restart_still_required =>
      'Aktiviert. Neustart weiterhin erforderlich.';

  @override
  String get rel_admin_enabled_restart_requested =>
      'Aktiviert; Neustart angefordert.';

  @override
  String get rel_admin_route_change_verified => 'Routenänderung bestätigt.';

  @override
  String get rel_admin_delete_route => 'Route löschen';

  @override
  String get rel_admin_disable_route => 'Route deaktivieren';

  @override
  String get rel_admin_enable_route => 'Route aktivieren';

  @override
  String get rel_admin_back_up_entire_agent_home =>
      'Gesamtes Agenten-Home sichern';

  @override
  String get rel_admin_transfer_to_a_cloud_agent =>
      'Zu einem Cloud-Agenten übertragen';

  @override
  String get rel_admin_check_backup_progress => 'Sicherungsfortschritt prüfen';

  @override
  String get rel_admin_save_backup_to_this_device =>
      'Sicherung auf diesem Gerät speichern';

  @override
  String get rel_admin_save_sensitive_full_home_archive =>
      'Vertrauliches vollständiges Home-Archiv speichern';

  @override
  String get rel_admin_save_cancelled => 'Speichern abgebrochen.';

  @override
  String get rel_admin_backup_saved => 'Sicherung gespeichert.';

  @override
  String get rel_admin_up_to_32_mib_larger_archives_remain_on_the_gateway =>
      'Bis zu 32 MiB. Größere Archive bleiben auf dem Gateway.';

  @override
  String rel_admin_persona_scope(String scope) {
    return 'Persona für $scope speichern.';
  }

  @override
  String rel_admin_configure_channel(String name) {
    return '$name konfigurieren';
  }

  @override
  String rel_admin_channel_warning(String scope) {
    return 'Gilt für $scope. Leer behält einen vorhandenen Wert. Zum Entfernen eines Werts seinen Schlüssel unten angeben.';
  }

  @override
  String rel_admin_hook_warning(String scope) {
    return 'Gilt für $scope. Verwende einen eindeutigen Namen. Das Gateway erstellt ein Signiergeheimnis. Wenn ein anderer Betreiber den Namen gleichzeitig erstellt, kann der Host diese Route ersetzen.';
  }

  @override
  String rel_admin_hook_created(String url) {
    return '$url erstellt. Speichere das Signiergeheimnis vor dem Verlassen.';
  }

  @override
  String rel_admin_clone_warning(String scope) {
    return 'Einstellungen, Skills, Persona und möglicherweise Anbieter-Zugangsdaten von $scope kopieren. Nachrichten-Tokens werden nicht angefordert.';
  }

  @override
  String rel_admin_cloned(String source, String destination) {
    return '$source nach $destination geklont.';
  }

  @override
  String rel_admin_rename_target(String name) {
    return '$name umbenennen';
  }

  @override
  String rel_admin_rename_label_warning(String scope) {
    return 'Anzeigenamen für $scope ändern. Die ID bleibt default.';
  }

  @override
  String rel_admin_rename_warning(String scope) {
    return '$scope auf dem Server umbenennen. Ein laufendes Gateway kann stoppen.';
  }

  @override
  String rel_admin_delete_target(String name) {
    return '$name löschen';
  }

  @override
  String rel_admin_delete_profile_warning(String scope) {
    return '$scope einschließlich Sitzungen und Zugangsdaten dauerhaft löschen. Gib die genaue Profil-ID ein.';
  }

  @override
  String rel_admin_export_target(String name) {
    return '$name exportieren';
  }

  @override
  String rel_admin_export_warning(String scope) {
    return 'Eine .tar.gz-Datei auf $scope erstellen. Bekannte Zugangsdaten-Speicher werden ausgeschlossen, private Daten können aber verbleiben. Vor dem Teilen prüfen.';
  }

  @override
  String rel_admin_archive_on(String gateway, String path) {
    return 'Archiv auf $gateway: $path';
  }

  @override
  String rel_admin_import_warning(String gateway) {
    return 'Eine geprüfte .tar.gz-Datei verwenden, die bereits auf $gateway liegt. Sie kann Plugins, Skripte und Zeitpläne enthalten. Eine neue Profil-ID ist erforderlich.';
  }

  @override
  String rel_admin_imported(String name) {
    return '$name importiert.';
  }

  @override
  String rel_admin_approve_user(String user) {
    return '$user genehmigen';
  }

  @override
  String rel_admin_revoke_user(String user) {
    return '$user widerrufen';
  }

  @override
  String rel_admin_allow_pair(String platform, String scope) {
    return '$platform auf $scope: Nachrichtenzugriff dieses Nutzers erlauben.';
  }

  @override
  String rel_admin_remove_pair(String platform, String scope) {
    return '$platform auf $scope: Nachrichtenzugriff dieses Nutzers entfernen.';
  }

  @override
  String rel_admin_telegram_start(String scope) {
    return 'Telegram-Kopplung auf $scope über den Einrichtungsdienst des Gateways starten.';
  }

  @override
  String rel_admin_expires(String time) {
    return 'Läuft ab: $time';
  }

  @override
  String rel_admin_telegram_apply(String bot, String scope) {
    return '@$bot auf $scope aktivieren und einen Gateway-Neustart versuchen. Nur die aufgeführten Nutzer dürfen ihm Nachrichten senden.';
  }

  @override
  String rel_admin_hooks_enable(String scope) {
    return 'Eingehende Webhooks auf $scope aktivieren und einen Gateway-Neustart versuchen.';
  }

  @override
  String rel_admin_disable_target(String name) {
    return '$name deaktivieren';
  }

  @override
  String rel_admin_enable_target(String name) {
    return '$name aktivieren';
  }

  @override
  String rel_admin_hook_change(String name, String scope) {
    return 'Genau $name auf $scope ändern.';
  }

  @override
  String rel_admin_backup_warning(String gateway) {
    return 'Dies ist keine Ares-Einstellungssicherung. Alle Profile, Sitzungen und Zugangsdaten auf $gateway speichern. Das Archiv ist vertraulich.';
  }

  @override
  String rel_admin_backup_started(String gateway) {
    return 'Sicherung auf $gateway gestartet.';
  }

  @override
  String rel_admin_backup_verified(String gateway, String path) {
    return 'Sicherung auf $gateway überprüft: $path';
  }

  @override
  String rel_admin_backup_running(String gateway) {
    return 'Sicherung auf $gateway läuft noch.';
  }

  @override
  String get rel_admin_choice_yes => 'ja';

  @override
  String get rel_admin_choice_no => 'nein';

  @override
  String get rel_admin_choice_generic => 'allgemein';

  @override
  String get rel_admin_choice_log => 'Protokoll';

  @override
  String get rel_admin_choice_email => 'E-Mail';

  @override
  String get rel_admin_choice_github_comment => 'GitHub-Kommentar';

  @override
  String get rel_admin_choice_agent => 'Agent verarbeitet Ereignis';

  @override
  String get rel_admin_choice_direct => 'Direkte Zustellung';

  @override
  String get rel_admin_configured => 'konfiguriert';

  @override
  String get rel_admin_state_pending_restart => 'Neustart ausstehend';

  @override
  String get rel_admin_state_unknown => 'unbekannt';

  @override
  String get rel_admin_state_connected => 'verbunden';

  @override
  String get rel_admin_state_disconnected => 'getrennt';

  @override
  String get rel_admin_state_disabled => 'deaktiviert';

  @override
  String get rel_admin_state_enabled => 'aktiviert';

  @override
  String get rel_admin_state_running => 'läuft';

  @override
  String get rel_admin_state_stopped => 'gestoppt';

  @override
  String get rel_admin_state_error => 'Fehler';

  @override
  String get rel_admin_state_not_configured => 'nicht konfiguriert';

  @override
  String get rel_admin_state_startup_failed => 'Start fehlgeschlagen';

  @override
  String get rel_admin_state_gateway_stopped => 'Gateway gestoppt';

  @override
  String get rel_admin_state_connecting => 'Verbindung wird hergestellt';

  @override
  String get rel_admin_state_retrying => 'erneuter Versuch';

  @override
  String get rel_admin_state_fatal => 'schwerwiegender Fehler';

  @override
  String get rel_admin_unsupported_or_oversized_profile_archive =>
      'Nicht unterstütztes oder zu großes Profilarchiv.';

  @override
  String get rel_admin_current_layout => 'Aktuelles Layout';

  @override
  String get rel_admin_one_pane => 'Ein Bereich';

  @override
  String get rel_admin_stacked => 'Gestapelt';

  @override
  String get rel_admin_side_by_side => 'Nebeneinander';

  @override
  String get rel_admin_no_supported_appearance_in_this_profile =>
      'Kein unterstütztes Erscheinungsbild in diesem Profil.';

  @override
  String get rel_admin_review_appearance_saved_with_this_profile =>
      'Mit diesem Profil gespeichertes Erscheinungsbild prüfen';

  @override
  String get rel_admin_applies_only_to_this_named_profile_on_this_device =>
      'Gilt nur für dieses benannte Profil auf diesem Gerät. Eine importierte Anordnung beginnt mit leeren Bereichen; wähle ihre Chats selbst.';

  @override
  String get rel_admin_apply_to_this_profile_on_this_device =>
      'Auf dieses Profil auf diesem Gerät anwenden';

  @override
  String get rel_admin_export_prepares_a_tar_gz_on_the_gateway_review =>
      'Der Export bereitet eine .tar.gz-Datei auf dem Gateway vor. Prüfe ihre portablen Dateien, bevor du hier eine Kopie speicherst. Der Import öffnet ein lokales Archiv zur Prüfung; das Öffnen allein lädt nichts hoch.';

  @override
  String get rel_admin_prepare_profile_export => 'Profilexport vorbereiten';

  @override
  String get rel_admin_open_tar_gz_from_this_device =>
      '.tar.gz von diesem Gerät öffnen';

  @override
  String get rel_admin_only_selected_text_files_travel_review_for_secrets_and =>
      'Nur ausgewählte Textdateien werden übertragen. Prüfe sie auf Geheimnisse und private Informationen. Konfiguration, Skills und Zeitpläne können das Verhalten des neuen Profils ändern.';

  @override
  String get rel_admin_include_this_reviewed_file =>
      'Diese geprüfte Datei einschließen';

  @override
  String get rel_admin_apply_appearance_to_the_new_profile_on_this_device =>
      'Erscheinungsbild auf das neue Profil auf diesem Gerät anwenden';

  @override
  String
  get rel_admin_imports_colours_and_pane_sizes_never_chats_tools_or_session_ids =>
      'Importiert Farben und Bereichsgrößen, niemals Chats, Werkzeuge oder Sitzungs-IDs.';

  @override
  String
  get rel_admin_the_gateway_retains_a_private_staged_copy_import_creates =>
      'Das Gateway behält eine private zwischengespeicherte Kopie. Der Import erstellt ein neues Profil; ein vorhandenes wird nicht ersetzt.';

  @override
  String get rel_admin_appearance_not_applied_the_gateway_did_not_confirm_the =>
      ' Erscheinungsbild nicht angewendet: Das Gateway hat die geprüfte Überlagerung nicht bestätigt.';

  @override
  String get rel_admin_appearance_applied_on_this_device =>
      ' Erscheinungsbild auf diesem Gerät angewendet.';

  @override
  String get rel_admin_appearance_was_not_saved_on_this_device =>
      ' Erscheinungsbild wurde auf diesem Gerät nicht gespeichert.';

  @override
  String get rel_admin_save_reviewed_profile_bundle =>
      'Geprüftes Profilpaket speichern';

  @override
  String get rel_admin_profile_bundle_saved => 'Profilpaket gespeichert.';

  @override
  String get rel_admin_import_selected_files =>
      'Ausgewählte Dateien importieren';

  @override
  String get rel_admin_save_selected_files_to_device =>
      'Ausgewählte Dateien auf Gerät speichern';

  @override
  String rel_admin_layout_first_pane(String layout, String percent) {
    return '$layout · $percent% erster Bereich';
  }

  @override
  String rel_admin_appearance_summary(String skin, String mode, String layout) {
    return 'Design: $skin · Modus: $mode · $layout';
  }

  @override
  String rel_admin_appearance_applied(String gateway, String profile) {
    return 'Erscheinungsbild auf $gateway / $profile angewendet.';
  }

  @override
  String rel_admin_bundle_summary(
    String profile,
    String count,
    String omitted,
  ) {
    return 'Paket: $profile · $count prüfbare Dateien · $omitted ausgelassen';
  }

  @override
  String rel_admin_imported_on(String name, String gateway) {
    return '$name auf $gateway importiert.';
  }

  @override
  String get rel_admin_unchanged => 'unverändert';

  @override
  String get rel_admin_mode_system => 'System';

  @override
  String get rel_admin_mode_light => 'hell';

  @override
  String get rel_admin_mode_dark => 'dunkel';

  @override
  String get rel_admin_skin_classic => 'klassisch';

  @override
  String get rel_admin_skin_midnight => 'Mitternacht';

  @override
  String get rel_admin_skin_ember => 'Glut';

  @override
  String get rel_admin_skin_mono => 'monochrom';

  @override
  String get rel_admin_skin_cyberpunk => 'Cyberpunk';

  @override
  String get rel_admin_skin_slate => 'Schiefer';

  @override
  String get rel_admin_no_available_cloud_agents_in_this_account =>
      'Keine verfügbaren Cloud-Agenten in diesem Konto.';

  @override
  String get rel_admin_the_previous_undo_receipt_could_not_be_verified_no =>
      'Der vorherige Rückgängig-Beleg konnte nicht überprüft werden. Es wurde nichts geändert.';

  @override
  String get rel_admin_transfer_to_cloud => 'Zu Cloud übertragen';

  @override
  String
  get rel_admin_connection_changed_leave_this_page_a_restore_already_submitted =>
      'Verbindung geändert. Verlasse diese Seite. Eine bereits übermittelte Wiederherstellung kann weiterlaufen.';

  @override
  String get rel_admin_find_my_cloud_agents => 'Meine Cloud-Agenten finden';

  @override
  String
  get rel_admin_undo_replaces_the_destination_with_its_pre_transfer_backup =>
      'Rückgängig ersetzt das Ziel durch seine Sicherung vor der Übertragung.';

  @override
  String get rel_admin_replace_this_cloud_agent_with_the_entire_source_home =>
      'Ersetze diesen Cloud-Agenten durch das gesamte Quell-Home, einschließlich Zugangsdaten, Unterhaltungen und Dateien. Die Quelle wird nicht gelöscht. Eingehende Nachrichten-Bots werden ausgeschaltet.';

  @override
  String get rel_admin_type_destination_agent_id => 'Ziel-Agenten-ID eingeben';

  @override
  String
  get rel_admin_could_not_retain_the_local_undo_receipt_keep_this_page_open =>
      'Der lokale Rückgängig-Beleg konnte nicht gespeichert werden. Lass diese Seite geöffnet.';

  @override
  String get rel_admin_undo_transfer => 'Übertragung rückgängig machen';

  @override
  String get rel_admin_replace_cloud_agent => 'Cloud-Agenten ersetzen';

  @override
  String
  get rel_admin_local_undo_receipt_forgotten_no_remote_backup_was_removed =>
      'Lokaler Rückgängig-Beleg vergessen. Keine entfernte Sicherung wurde gelöscht.';

  @override
  String get rel_admin_forget_local_undo_receipt_only =>
      'Nur lokalen Rückgängig-Beleg vergessen';

  @override
  String get rel_admin_stop_before_restore => 'Vor Wiederherstellung stoppen';

  @override
  String get rel_admin_do_not_close_this_page_restore_runs_on_the =>
      'Schließe diese Seite nicht. Die Wiederherstellung läuft auf dem Ziel und kann nicht abgebrochen werden.';

  @override
  String get rel_admin_files_restored_destination_gateway_needs_attention =>
      'Dateien wiederhergestellt; das Ziel-Gateway benötigt Aufmerksamkeit.';

  @override
  String rel_admin_transfer_sign_in(String origin) {
    return 'Melde dich bei genau einer gespeicherten Ares-Verbindung für $origin an und kehre dann hierher zurück.';
  }

  @override
  String rel_admin_transfer_source(String gateway, String profile) {
    return 'Quelle: $gateway / $profile';
  }

  @override
  String rel_admin_transfer_destination(String name, String origin) {
    return 'Ziel: $name · $origin / default';
  }

  @override
  String rel_admin_agent_id(String id) {
    return 'Agenten-ID: $id';
  }

  @override
  String rel_admin_transfer_status(String phase) {
    return 'Status: $phase';
  }

  @override
  String rel_admin_copied_percent(String percent) {
    return '$percent% kopiert';
  }

  @override
  String rel_admin_undo_point(String path) {
    return 'Rückgängig-Punkt auf dem Ziel: $path';
  }

  @override
  String rel_admin_messaging_disabled(String channels) {
    return 'Nachrichten deaktiviert: $channels';
  }

  @override
  String get rel_admin_phase_prepared => 'vorbereitet';

  @override
  String get rel_admin_phase_backup => 'Sicherung';

  @override
  String get rel_admin_phase_upload => 'Upload';

  @override
  String get rel_admin_phase_restore => 'Wiederherstellung';

  @override
  String get rel_admin_phase_finished => 'abgeschlossen';

  @override
  String get rel_admin_phase_failed => 'fehlgeschlagen';

  @override
  String get rel_admin_phase_undo => 'Rückgängig';

  @override
  String get rel_admin_phase_undone => 'rückgängig gemacht';

  @override
  String rel_ops_cap_install_blocked(String verdict, String detail) {
    return 'Installation blockiert ($verdict): $detail';
  }

  @override
  String rel_ops_cap_scan_confirm(String verdict, String requested) {
    return 'Prüfergebnis: $verdict. Bestätige $requested vor der Installation.';
  }

  @override
  String rel_ops_cap_install_unconfirmed(String requested) {
    return 'Das Gateway hat nicht bestätigt, dass $requested installiert ist.';
  }

  @override
  String rel_ops_cap_edit_skill(String name) {
    return '$name bearbeiten';
  }

  @override
  String rel_ops_cap_archive_skill(String name) {
    return '$name archivieren?';
  }

  @override
  String rel_ops_cap_archive_explanation(String command) {
    return 'Der Skill wird archiviert und kann mit $command wiederhergestellt werden.';
  }

  @override
  String rel_ops_cap_install_anyway(String name) {
    return '$name trotzdem installieren';
  }

  @override
  String rel_ops_cap_install_despite_scan(String name) {
    return '$name trotz Prüfergebnis installieren?';
  }

  @override
  String rel_ops_cap_scan_warning(String name) {
    return 'Die Sicherheitsprüfung hat $name blockiert. Diese Bestätigung gilt nur für $name.';
  }

  @override
  String rel_ops_cap_accept_scan_warning(String name) {
    return 'Das Akzeptieren von Funktionen setzt die Prüfung von $name nicht außer Kraft.';
  }

  @override
  String rel_ops_cap_review_scan(String name) {
    return 'Prüfergebnis für $name ansehen';
  }

  @override
  String rel_ops_cap_desktop_grants(String description) {
    return '$description\nBerechtigungen für Ordner und Vorschauskripte bleiben in der Desktop-App auf diesem Computer. Das Entfernen des Plugins hier widerruft diese lokalen Berechtigungen nicht.';
  }

  @override
  String rel_ops_cap_remove_plugin(String name) {
    return '$name entfernen?';
  }

  @override
  String rel_ops_cap_probe_result(String name, String tools) {
    return 'Verbindungstest für $name: $tools';
  }

  @override
  String rel_ops_cap_save_tool_grants_for(String connector) {
    return 'Tool-Berechtigungen für $connector speichern';
  }

  @override
  String rel_ops_cap_backends_for(String name) {
    return 'Backends für $name';
  }

  @override
  String rel_ops_cap_use_backend_confirmation(String name) {
    return '$name verwenden?';
  }

  @override
  String rel_ops_cap_unlock_source(String name) {
    return '$name entsperren';
  }

  @override
  String get rel_ops_cap_capabilities => 'Funktionen';

  @override
  String get rel_ops_cap_plugins => 'Plugins';

  @override
  String get rel_ops_cap_connectors => 'Konnektoren';

  @override
  String get rel_ops_cap_backends => 'Backends';

  @override
  String get rel_ops_cap_save_skill => 'Skill speichern';

  @override
  String get rel_ops_cap_archive => 'Archivieren';

  @override
  String get rel_ops_cap_hub_identifier => 'Hub-Kennung';

  @override
  String get rel_ops_cap_install => 'Installieren';

  @override
  String get rel_ops_cap_update_all => 'Alle aktualisieren';

  @override
  String get rel_ops_cap_unlock => 'Entsperren';

  @override
  String get rel_ops_cap_lock => 'Sperren';

  @override
  String get rel_ops_cap_this_update_adds_capabilities_nothing_changed_yet =>
      'Dieses Update fügt Funktionen hinzu. Bisher wurde nichts geändert.';

  @override
  String get rel_ops_cap_the_scan_blocked_this_plugin =>
      'Die Prüfung hat dieses Plugin blockiert.';

  @override
  String get rel_ops_cap_the_plugin_was_not_changed =>
      'Das Plugin wurde nicht geändert.';

  @override
  String get rel_ops_cap_repository => 'Repository';

  @override
  String get rel_ops_cap_install_plugin => 'Plugin installieren';

  @override
  String get rel_ops_cap_update_plugins => 'Plugins aktualisieren';

  @override
  String get rel_ops_cap_accept_capabilities => 'Funktionen akzeptieren';

  @override
  String get rel_ops_cap_update => 'Aktualisieren';

  @override
  String get rel_ops_cap_remove_desktop_half => 'Desktop-Komponente entfernen';

  @override
  String get rel_ops_cap_server_name => 'Servername';

  @override
  String get rel_ops_cap_command => 'Befehl';

  @override
  String get rel_ops_cap_http_url => 'HTTP-URL';

  @override
  String get rel_ops_cap_add_server => 'Server hinzufügen';

  @override
  String get rel_ops_cap_probe => 'Verbindung testen';

  @override
  String get rel_ops_cap_probe_failed => 'Verbindungstest fehlgeschlagen.';

  @override
  String get rel_ops_cap_logs => 'Protokolle';

  @override
  String get rel_ops_cap_mcp_log => 'MCP-Protokoll';

  @override
  String get rel_ops_cap_connector => 'Konnektor';

  @override
  String get rel_ops_cap_account_alias => 'Kontoalias';

  @override
  String get rel_ops_cap_link_account => 'Konto verknüpfen';

  @override
  String get rel_ops_cap_remove_account => 'Konto entfernen';

  @override
  String get rel_ops_cap_tool_connector => 'Tool-Konnektor';

  @override
  String get rel_ops_cap_load_tools => 'Tools laden';

  @override
  String get rel_ops_cap_save_tool_grants => 'Tool-Berechtigungen speichern';

  @override
  String
  get rel_ops_cap_this_policy_has_no_member_revision_so_tool_grants_stay_unchanged =>
      'Diese Richtlinie hat keine Mitgliedsrevision. Die Tool-Berechtigungen bleiben daher unverändert.';

  @override
  String get rel_ops_cap_active => 'Aktiv';

  @override
  String get rel_ops_cap_use => 'Verwenden';

  @override
  String get rel_ops_cap_run_setup => 'Einrichtung starten';

  @override
  String get rel_ops_cap_terminal_backends => 'Terminal-Backends';

  @override
  String get rel_ops_cap_this_changes_the_terminal_backend_for_this_profile =>
      'Dies ändert das Terminal-Backend für dieses Profil.';

  @override
  String get rel_ops_cap_use_backend => 'Backend verwenden';

  @override
  String get rel_ops_cap_select => 'Auswählen';

  @override
  String get rel_ops_cap_browser_vault => 'Browser-Tresor';

  @override
  String
  get rel_ops_cap_saved_site_logins_addresses_and_cards_passwords_stay_in_the_secure_fields_and_are_not_listed_here =>
      'Gespeicherte Website-Anmeldungen, Adressen und Karten. Passwörter bleiben in den geschützten Feldern und werden hier nicht aufgeführt.';

  @override
  String get rel_ops_cap_remove_saved_item => 'Gespeicherten Eintrag entfernen';

  @override
  String get rel_ops_cap_delete_this_item => 'Diesen Eintrag löschen?';

  @override
  String get rel_ops_cap_unlocked => 'Entsperrt';

  @override
  String get rel_ops_cap_locked => 'Gesperrt';

  @override
  String get rel_ops_cap_not_detected => 'Nicht erkannt';

  @override
  String get rel_ops_cap_master_password => 'Master-Passwort';

  @override
  String get rel_ops_cap_login => 'Anmeldedaten';

  @override
  String get rel_ops_cap_address => 'Adresse';

  @override
  String get rel_ops_cap_card => 'Karte';

  @override
  String get rel_ops_cap_label => 'Bezeichnung';

  @override
  String get rel_ops_cap_site_origin => 'Website-Ursprung';

  @override
  String get rel_ops_cap_identifier => 'Kennung';

  @override
  String get rel_ops_cap_password => 'Passwort';

  @override
  String get rel_ops_cap_authenticator_key => 'Authentifizierungsschlüssel';

  @override
  String get rel_ops_cap_street => 'Straße';

  @override
  String get rel_ops_cap_city => 'Stadt';

  @override
  String get rel_ops_cap_postal_code => 'Postleitzahl';

  @override
  String get rel_ops_cap_country => 'Land';

  @override
  String get rel_ops_cap_name_on_card => 'Name auf der Karte';

  @override
  String get rel_ops_cap_card_number => 'Kartennummer';

  @override
  String get rel_ops_cap_expiry_month => 'Ablaufmonat';

  @override
  String get rel_ops_cap_expiry_year => 'Ablaufjahr';

  @override
  String get rel_ops_cap_security_code => 'Sicherheitscode';

  @override
  String get rel_ops_cap_this_gateway_has_no_shared_metrics_consent_method =>
      'Dieses Gateway bietet keine Methode zur Einwilligung in geteilte Metriken.';

  @override
  String get rel_ops_cap_agent_policy => 'Agentenrichtlinie';

  @override
  String get rel_ops_cap_loading_policy => 'Richtlinie wird geladen';

  @override
  String get rel_ops_cap_approval_timeout => 'Zeitlimit für Genehmigungen';

  @override
  String get rel_ops_cap_confirm_mcp_reloads => 'MCP-Neuladen bestätigen';

  @override
  String get rel_ops_cap_command_allowlist => 'Zulässige Befehle';

  @override
  String get rel_ops_cap_file_checkpoints => 'Datei-Checkpoints';

  @override
  String get rel_ops_cap_checkpoint_limit => 'Checkpoint-Limit';

  @override
  String get rel_ops_cap_browser_private_urls => 'Private URLs im Browser';

  @override
  String get rel_ops_cap_use_my_real_browser_profile =>
      'Mein echtes Browserprofil verwenden';

  @override
  String get rel_ops_cap_save_policy => 'Richtlinie speichern';

  @override
  String get rel_ops_cap_shared_metrics_for_this_profile =>
      'Geteilte Metriken für dieses Profil';

  @override
  String get rel_ops_cap_send_shared_metrics => 'Geteilte Metriken senden';

  @override
  String get rel_ops_cap_error_enter_a_label => 'Gib eine Bezeichnung ein.';

  @override
  String get rel_ops_cap_error_enter_a_valid_url_like_https_example_com =>
      'Gib eine gültige URL wie https://example.com ein.';

  @override
  String get rel_ops_cap_error_enter_the_identifier_and_password =>
      'Gib die Kennung und das Passwort ein.';

  @override
  String
  get rel_ops_cap_error_enter_the_card_name_number_expiry_and_security_code =>
      'Gib den Kartennamen, die Nummer, das Ablaufdatum und den Sicherheitscode ein.';

  @override
  String get rel_ops_cap_error_enter_the_street_city_postal_code_and_country =>
      'Gib Straße, Stadt, Postleitzahl und Land ein.';

  @override
  String
  get rel_ops_cap_error_the_gateway_returned_a_response_that_could_not_be_read =>
      'Das Gateway hat eine unlesbare Antwort zurückgegeben.';

  @override
  String rel_ops_cap_error_the_gateway_refused_the_request_status(
    int statusCode,
  ) {
    return 'Das Gateway hat die Anfrage abgelehnt ($statusCode).';
  }

  @override
  String
  rel_ops_cap_error_this_connection_has_no_gateway_socket_so_method_is_unavailable(
    String method,
  ) {
    return 'Diese Verbindung hat keinen Gateway-Socket. Daher ist $method nicht verfügbar.';
  }

  @override
  String get rel_ops_cap_error_choose_a_skill => 'Wähle einen Skill aus.';

  @override
  String get rel_ops_cap_error_the_skill_text_was_not_returned =>
      'Der Skill-Text wurde nicht zurückgegeben.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_saved =>
      'Der Skill wurde nicht gespeichert.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_archived =>
      'Der Skill wurde nicht archiviert.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_installed =>
      'Der Skill wurde nicht installiert.';

  @override
  String get rel_ops_cap_error_skill_updates_did_not_start =>
      'Die Skill-Updates wurden nicht gestartet.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_removed =>
      'Der Skill wurde nicht entfernt.';

  @override
  String get rel_ops_cap_error_enter_a_skill_or_plugin_identifier =>
      'Gib eine Skill- oder Plugin-Kennung ein.';

  @override
  String get rel_ops_cap_error_choose_a_plugin => 'Wähle ein Plugin aus.';

  @override
  String get rel_ops_cap_error_the_plugin_was_not_removed =>
      'Das Plugin wurde nicht entfernt.';

  @override
  String get rel_ops_cap_error_the_desktop_half_was_not_removed =>
      'Die Desktop-Komponente wurde nicht entfernt.';

  @override
  String
  get rel_ops_cap_error_this_gateway_did_not_give_the_plugin_a_stable_key =>
      'Dieses Gateway hat dem Plugin keinen stabilen Schlüssel zugewiesen.';

  @override
  String get rel_ops_cap_error_the_plugin_was_not_changed =>
      'Das Plugin wurde nicht geändert.';

  @override
  String get rel_ops_cap_error_choose_a_server => 'Wähle einen Server aus.';

  @override
  String get rel_ops_cap_error_name_the_server => 'Gib dem Server einen Namen.';

  @override
  String get rel_ops_cap_error_give_the_server_a_command_or_an_http_s_url =>
      'Gib für den Server einen Befehl oder eine http(s)-URL an.';

  @override
  String get rel_ops_cap_error_choose_a_toolset =>
      'Wähle eine Tool-Gruppe aus.';

  @override
  String get rel_ops_cap_error_tool_backend_status_was_not_returned =>
      'Der Status des Tool-Backends wurde nicht zurückgegeben.';

  @override
  String get rel_ops_cap_error_choose_a_provider => 'Wähle einen Anbieter aus.';

  @override
  String get rel_ops_cap_error_this_provider_has_no_setup_action =>
      'Für diesen Anbieter gibt es keine Einrichtungsaktion.';

  @override
  String get rel_ops_cap_error_setup_did_not_start =>
      'Die Einrichtung wurde nicht gestartet.';

  @override
  String get rel_ops_cap_error_choose_a_terminal_backend =>
      'Wähle ein Terminal-Backend aus.';

  @override
  String get rel_ops_cap_error_name_the_connector =>
      'Gib dem Konnektor einen Namen.';

  @override
  String get rel_ops_cap_error_choose_an_account => 'Wähle ein Konto aus.';

  @override
  String
  get rel_ops_cap_error_reload_the_connector_policy_before_changing_tool_grants =>
      'Lade die Konnektorrichtlinie neu, bevor du Tool-Berechtigungen änderst.';

  @override
  String get rel_ops_cap_error_choose_an_item => 'Wähle einen Eintrag aus.';

  @override
  String get rel_ops_cap_error_choose_a_source => 'Wähle eine Quelle aus.';

  @override
  String get rel_ops_cap_error_enter_the_master_password =>
      'Gib das Master-Passwort ein.';

  @override
  String get rel_ops_cap_error_gateway_config_was_not_returned =>
      'Die Gateway-Konfiguration wurde nicht zurückgegeben.';

  @override
  String get rel_ops_cap_error_choose_a_known_approval_mode =>
      'Wähle einen bekannten Genehmigungsmodus aus.';

  @override
  String get rel_ops_cap_error_use_a_positive_limit =>
      'Verwende ein positives Limit.';

  @override
  String get rel_ops_cap_error_the_policy_was_not_saved =>
      'Die Richtlinie wurde nicht gespeichert.';

  @override
  String get rel_ops_cap_value_manual => 'manuell';

  @override
  String get rel_ops_cap_value_smart => 'intelligent';

  @override
  String get rel_ops_cap_value_off => 'aus';

  @override
  String get rel_ops_cap_value_safe => 'sicher';

  @override
  String get rel_ops_cap_value_caution => 'Vorsicht';

  @override
  String get rel_ops_cap_value_dangerous => 'gefährlich';

  @override
  String get rel_ops_cap_value_blocked => 'blockiert';

  @override
  String get rel_ops_cap_value_clean => 'unbedenklich';

  @override
  String get rel_ops_cap_value_ready => 'bereit';

  @override
  String get rel_ops_cap_value_available => 'verfügbar';

  @override
  String get rel_ops_cap_value_unavailable => 'nicht verfügbar';

  @override
  String get rel_ops_cap_value_enabled => 'aktiviert';

  @override
  String get rel_ops_cap_value_disabled => 'deaktiviert';

  @override
  String get rel_ops_cap_value_active => 'aktiv';

  @override
  String get rel_ops_cap_value_inactive => 'inaktiv';

  @override
  String get rel_ops_cap_value_installed => 'installiert';

  @override
  String get rel_ops_cap_value_missing => 'fehlt';

  @override
  String get rel_ops_cap_value_configured => 'konfiguriert';

  @override
  String get rel_ops_cap_value_not_configured => 'nicht konfiguriert';

  @override
  String get rel_ops_cap_value_error => 'Fehler';

  @override
  String get rel_ops_cap_value_unknown => 'unbekannt';

  @override
  String get rel_ops_cap_value_login => 'Anmeldedaten';

  @override
  String get rel_ops_cap_value_address => 'Adresse';

  @override
  String get rel_ops_cap_value_payment => 'Zahlung';

  @override
  String get rel_ops_term_connecting => 'Verbindung wird hergestellt…';

  @override
  String get rel_ops_term_unbound =>
      'Keine passende aktive Sitzung oder kein passendes Arbeitsverzeichnis auf dem Host. Öffne zuerst den zugehörigen Chat.';

  @override
  String get rel_ops_term_unsupported =>
      'Dieses Gateway bietet diese Terminalfunktion nicht an. Es wurde keine lokale Shell gestartet.';

  @override
  String get rel_ops_term_local_pty_unavailable =>
      'Die mitgelieferte lokale PTY ist auf diesem Gerät nicht verfügbar.';

  @override
  String get rel_ops_term_operation_failed =>
      'Das Terminal konnte nicht geöffnet oder gesteuert werden. Prüfe Host, Zugangsdaten und Fingerabdruck. Es wurde keine Ersatz-Shell gestartet.';

  @override
  String get rel_ops_term_input_refused =>
      'Eingabe abgelehnt. Öffne den ursprünglichen Chat erneut.';

  @override
  String get rel_ops_term_cancel => 'Abbrechen';

  @override
  String get rel_ops_term_confirm => 'Bestätigen';

  @override
  String get rel_ops_term_open_device_title =>
      'Eine Shell auf diesem Gerät öffnen?';

  @override
  String get rel_ops_term_ssh_shell => 'SSH-Shell';

  @override
  String get rel_ops_term_local_shell => 'Lokale Shell';

  @override
  String get rel_ops_term_connection_lost => 'Verbindung verloren';

  @override
  String get rel_ops_term_shell_ended => 'Shell beendet';

  @override
  String get rel_ops_term_no_owner =>
      'Dieser Chat hat keinen authentifizierten Verantwortlichen für das Gateway-Terminal. Eine URL oder eine Cloud-Anmeldung allein gewährt keinen Shell-Zugriff.';

  @override
  String get rel_ops_term_open_gateway_title => 'Eine Gateway-Shell öffnen?';

  @override
  String get rel_ops_term_shell_expired => 'Shell beendet oder abgelaufen';

  @override
  String get rel_ops_term_disconnected => 'Getrennt';

  @override
  String get rel_ops_term_gateway_shell => 'Gateway-Shell';

  @override
  String get rel_ops_term_close_body =>
      'Diese Shell beenden. Blende stattdessen den Bereich aus, um sie weiterlaufen zu lassen.';

  @override
  String get rel_ops_term_closing => 'Wird geschlossen…';

  @override
  String get rel_ops_term_close_unconfirmed => 'Schließen nicht bestätigt';

  @override
  String get rel_ops_term_processes_require_chat =>
      'Agentenprozesse erfordern den authentifizierten zugehörigen Chat.';

  @override
  String get rel_ops_term_watching_processes =>
      'Die Agentenprozesse dieses Chats werden beobachtet. Das Schließen einer Spiegelansicht stoppt niemals den zugehörigen Prozess.';

  @override
  String get rel_ops_term_paste_limit => 'Einfügen ist auf 16 KiB begrenzt.';

  @override
  String get rel_ops_term_paste => 'Einfügen';

  @override
  String get rel_ops_term_select_first =>
      'Wähle zuerst die Terminalausgabe aus.';

  @override
  String get rel_ops_term_open_chat_to_insert =>
      'Öffne den ursprünglichen Chat, bevor du die Ausgabe einfügst.';

  @override
  String get rel_ops_term_added_to_draft =>
      'Zum Entwurf des ursprünglichen Chats hinzugefügt. Es wurde nichts gesendet.';

  @override
  String get rel_ops_term_close => 'Schließen';

  @override
  String get rel_ops_term_add_selection => 'Auswahl zum Chatentwurf hinzufügen';

  @override
  String get rel_ops_term_new_terminal => 'Neues Terminal';

  @override
  String get rel_ops_term_gateway_terminal => 'Terminal des Gateway-Hosts';

  @override
  String get rel_ops_term_verified_ssh_terminal => 'Verifiziertes SSH-Terminal';

  @override
  String get rel_ops_term_device_local_shell => 'Dieses Gerät (lokale Shell)';

  @override
  String get rel_ops_term_local_unavailable_mobile =>
      'Lokale Shell auf Mobilgeräten nicht verfügbar';

  @override
  String get rel_ops_term_watch_processes => 'Agentenprozesse beobachten';

  @override
  String get rel_ops_term_select_output => 'Ausgabe auswählen oder kopieren';

  @override
  String get rel_ops_term_add_selected_output =>
      'Ausgewählte Ausgabe zum Chatentwurf hinzufügen';

  @override
  String get rel_ops_term_review_paste =>
      'Einfügen aus der Zwischenablage prüfen';

  @override
  String get rel_ops_term_reconnect => 'Mit derselben Shell erneut verbinden';

  @override
  String get rel_ops_term_close_mirror => 'Spiegelansicht schließen';

  @override
  String get rel_ops_term_close_shell => 'Shell schließen';

  @override
  String get rel_ops_term_empty =>
      'Wähle +, um ein Terminal zu öffnen. Es wird keine Shell automatisch gestartet.';

  @override
  String get rel_ops_term_reason_stale => 'veraltet';

  @override
  String get rel_ops_term_reason_mismatch => 'keine Übereinstimmung';

  @override
  String get rel_ops_term_reason_unbound => 'nicht zugeordnet';

  @override
  String get rel_ops_term_reason_unsupported => 'nicht unterstützt';

  @override
  String get rel_ops_term_reason_denied => 'abgelehnt';

  @override
  String get rel_ops_term_reason_ineligible => 'nicht berechtigt';

  @override
  String get rel_ops_term_reason_unavailable => 'nicht verfügbar';

  @override
  String get rel_ops_term_reason_invalid => 'ungültig';

  @override
  String get rel_ops_term_reason_insecure => 'unsicher';

  @override
  String rel_ops_term_refused(String reason) {
    return 'Das Gateway hat diesen Terminalvorgang abgelehnt ($reason).';
  }

  @override
  String rel_ops_term_open_device_body(String connection) {
    return 'Dies ist das Ares-Gerät, nicht $connection. Die Shell nutzt die Berechtigungen deiner App und startet im App-Speicher.';
  }

  @override
  String rel_ops_term_open_gateway_body(String host) {
    return 'Starte eine Shell auf $host im verifizierten Arbeitsverzeichnis des Chats. Dies ist keine Geräte-Shell.';
  }

  @override
  String rel_ops_term_close_tab_title(String label) {
    return '$label schließen?';
  }

  @override
  String rel_ops_term_read_only_status(String status) {
    return 'Schreibgeschützt · $status';
  }

  @override
  String rel_ops_term_paste_title(String label) {
    return 'In $label einfügen?';
  }

  @override
  String rel_ops_term_output_title(String label) {
    return 'Ausgabe · $label';
  }

  @override
  String rel_ops_term_mirror_status(String label) {
    return 'Schreibgeschützte Prozess-Spiegelansicht · $label';
  }

  @override
  String rel_ops_term_status_label(String status, String label) {
    return '$status · $label';
  }

  @override
  String rel_ops_term_ssh_tab(String user, String host, int port, int number) {
    return 'SSH $user@$host:$port · $number';
  }

  @override
  String rel_ops_term_device_tab(int number) {
    return 'Dieses Gerät · $number';
  }

  @override
  String rel_ops_term_gateway_tab(String host, int number) {
    return 'Gateway $host · $number';
  }

  @override
  String get rel_ops_term_earlier_output_trimmed => '[Frühere Ausgabe gekürzt]';

  @override
  String get rel_ops_term_ssh_dialog_title =>
      'Ein verifiziertes SSH-Terminal öffnen';

  @override
  String get rel_ops_term_ssh_dialog_body =>
      'Verwende einen Fingerabdruck, den du über einen unabhängigen Kanal vom Host-Administrator erhalten hast. Dies öffnet eine neue Remote-Anmeldung, nicht das Gateway oder eine lokale Shell.';

  @override
  String get rel_ops_term_ssh_host => 'SSH-Host';

  @override
  String get rel_ops_term_ssh_port => 'Port';

  @override
  String get rel_ops_term_ssh_user => 'Benutzer';

  @override
  String get rel_ops_term_ssh_fingerprint =>
      'Fingerabdruck des Hostschlüssels (SHA256:…)';

  @override
  String get rel_ops_term_ssh_password =>
      'SSH-Passwort (wird nicht gespeichert)';

  @override
  String get rel_ops_term_connect => 'Verbinden';

  @override
  String get rel_ops_ssh_invalid_destination =>
      'Ungültiger SSH-Host, Port oder Benutzer.';

  @override
  String get rel_ops_ssh_public_key_required =>
      'Ein öffentlicher Hostschlüssel im Format OpenSSH Ed25519 ist erforderlich.';

  @override
  String get rel_ops_ssh_invalid_public_key =>
      'Ungültiger Ed25519-Hostschlüssel.';

  @override
  String get rel_ops_ssh_invalid_saved_key =>
      'Ungültiger gespeicherter Hostschlüssel.';

  @override
  String get rel_ops_ssh_enrollment_unverified =>
      'Die Registrierung des Hostschlüssels konnte nicht verifiziert werden.';

  @override
  String get rel_ops_ssh_different_key_pinned =>
      'Ein anderer Schlüssel ist bereits fest hinterlegt. Verifiziere die Änderung separat.';

  @override
  String get rel_ops_ssh_open_ssh_unavailable =>
      'OpenSSH ist auf dem System nicht verfügbar.';

  @override
  String get rel_ops_ssh_confirm_host_key =>
      'Bestätige den Hostschlüssel vor dem Verbindungsaufbau.';

  @override
  String get rel_ops_ssh_absolute_identity_required =>
      'Wähle eine Identitätsdatei mit absolutem Pfad.';

  @override
  String get rel_ops_ssh_invalid_remote_port => 'Ungültiger entfernter Port.';

  @override
  String get rel_ops_ssh_preview_too_large =>
      'Die Vorschau überschreitet das Limit von 64 KiB.';

  @override
  String get rel_ops_ssh_connection_refused =>
      'SSH-Verbindung abgelehnt. Prüfe den registrierten Hostschlüssel, die Identität und den Dienst.';

  @override
  String get rel_ops_ssh_http_not_ok =>
      'Der entfernte Dienst hat nicht HTTP 200 zurückgegeben.';

  @override
  String get rel_ops_ssh_encoded_response =>
      'Kodierte Antworten werden von dieser Vorschau nicht unterstützt.';

  @override
  String get rel_ops_ssh_preview_type_unsupported =>
      'Nur Text und HTML-Quelltext können in der Vorschau angezeigt werden.';

  @override
  String get rel_ops_ssh_health_unconfirmed =>
      'Der Dienst hat den fehlerfreien Zustand des Gateways nicht bestätigt.';

  @override
  String get rel_ops_ssh_enroll_host_key_first =>
      'Registriere zuerst den öffentlichen Schlüssel des Hosts.';

  @override
  String get rel_ops_ssh_cancel => 'Abbrechen';

  @override
  String get rel_ops_ssh_confirm => 'Bestätigen';

  @override
  String get rel_ops_ssh_pin_title =>
      'Diesen SSH-Hostschlüssel fest hinterlegen?';

  @override
  String rel_ops_ssh_pin_detail(String destination, String fingerprint) {
    return '$destination\n$fingerprint\nVergleiche diesen Fingerabdruck über einen unabhängigen Kanal mit dem Hostadministrator. Es wird keine Verbindung hergestellt.';
  }

  @override
  String get rel_ops_ssh_host_key_pinned => 'Hostschlüssel fest hinterlegt.';

  @override
  String get rel_ops_ssh_shell_detail => 'Eine interaktive Login-Shell öffnen.';

  @override
  String rel_ops_ssh_read_detail(String path, int port) {
    return '$path auf dem entfernten 127.0.0.1:$port über einen SSH-Kanal lesen.';
  }

  @override
  String rel_ops_ssh_connect_title(String destination) {
    return 'Mit $destination verbinden?';
  }

  @override
  String rel_ops_ssh_connect_detail(
    String detail,
    String fingerprint,
    String authentication,
  ) {
    return '$detail\n$fingerprint\n$authentication';
  }

  @override
  String get rel_ops_ssh_agent_auth =>
      'Authentifiziere dich mit deinem SSH-Agenten.';

  @override
  String get rel_ops_ssh_identity_auth =>
      'Die ausgewählte Identitätsdatei verwenden.';

  @override
  String rel_ops_ssh_gateway_responding(int port) {
    return 'Das Gateway antwortet am entfernten Loopback-Port $port.';
  }

  @override
  String get rel_ops_ssh_session_closed => 'SSH-Sitzung geschlossen.';

  @override
  String get rel_ops_ssh_session_unclean =>
      'Die SSH-Sitzung wurde nicht ordnungsgemäß beendet.';

  @override
  String get rel_ops_ssh_operation_failed =>
      'SSH-Vorgang fehlgeschlagen. Prüfe das Ziel und die Identität.';

  @override
  String get rel_ops_ssh_title => 'Verifiziertes SSH';

  @override
  String get rel_ops_ssh_unsupported =>
      'Dieses Gerät verfügt über keinen unterstützten OpenSSH-Transport des Systems. Das fest hinterlegte Gateway-Relay akzeptiert neue Schlüssel automatisch und kann nicht für eine verifizierte Registrierung verwendet werden.';

  @override
  String get rel_ops_ssh_host => 'SSH-Host';

  @override
  String get rel_ops_ssh_port => 'SSH-Port';

  @override
  String get rel_ops_ssh_user => 'SSH-Benutzer';

  @override
  String get rel_ops_ssh_identity =>
      'Identitätsdatei (optional; andernfalls SSH-Agent verwenden)';

  @override
  String get rel_ops_ssh_public_key =>
      'Öffentlicher Hostschlüssel vom Administrator (ssh-ed25519)';

  @override
  String get rel_ops_ssh_review_key => 'Hostschlüssel prüfen';

  @override
  String get rel_ops_ssh_remote_port => 'Entfernter Loopback-Dienstport';

  @override
  String get rel_ops_ssh_check_gateway => 'Gateway über SSH prüfen';

  @override
  String get rel_ops_ssh_preview_source =>
      'Quelltext über SSH in der Vorschau anzeigen';

  @override
  String get rel_ops_ssh_open_shell => 'SSH-Shell öffnen';

  @override
  String get rel_ops_ssh_shell_line => 'Zeile an die entfernte Shell';

  @override
  String get rel_ops_ssh_disconnect => 'Shell-Verbindung trennen';

  @override
  String get rel_ops_host_cancel => 'Abbrechen';

  @override
  String get rel_ops_host_confirm => 'Bestätigen';

  @override
  String get rel_ops_host_title => 'Host';

  @override
  String get rel_ops_host_refresh => 'Aktualisieren';

  @override
  String get rel_ops_host_update => 'Hermes auf dem Remote-Host aktualisieren';

  @override
  String rel_ops_host_update_confirmation(String profile) {
    return 'Dies startet für $profile ein Update der bestehenden Installation auf dem Gateway-Host. Ares auf diesem Gerät wird dadurch nicht aktualisiert. Erfolg wird durch die passende Update-Bestätigung belegt, nicht dadurch, dass der Host erreichbar bleibt.';
  }

  @override
  String get rel_ops_host_update_awaiting =>
      'Warte auf passende Bestätigung. Das Update läuft noch.';

  @override
  String get rel_ops_host_receipt_success =>
      'Die Update-Bestätigung meldet Erfolg.';

  @override
  String get rel_ops_host_receipt_partial =>
      'Update übernommen; weitere Schritte stehen noch aus.';

  @override
  String get rel_ops_host_receipt_failed =>
      'Die Update-Bestätigung meldet einen Fehler.';

  @override
  String get rel_ops_host_receipt_refused =>
      'Die Update-Bestätigung meldet eine Ablehnung.';

  @override
  String get rel_ops_host_update_running => 'Das Update läuft noch.';

  @override
  String get rel_ops_host_update_unknown =>
      'Das Ergebnis des Updates ist unbekannt. Ein laufendes Gateway bedeutet kein erfolgreiches Update.';

  @override
  String get rel_ops_host_default_profile => 'das Standardprofil des Gateways';

  @override
  String get rel_ops_host_restart => 'Remote-Gateway neu starten';

  @override
  String rel_ops_host_restart_shared_confirmation(String profiles) {
    return 'Dies startet das von $profiles gemeinsam genutzte Gateway neu. Laufende Turns auf diesem Gateway werden unterbrochen. Verbinde dich danach erneut. Erreichbarkeit ist kein Nachweis für einen abgeschlossenen Neustart.';
  }

  @override
  String rel_ops_host_restart_confirmation(String profile) {
    return 'Dies startet das Remote-Gateway für $profile neu. Laufende Turns auf diesem Gateway werden unterbrochen. Verbinde dich danach erneut.';
  }

  @override
  String get rel_ops_host_restart_running => 'Der Neustartbefehl läuft noch.';

  @override
  String get rel_ops_host_restart_finished =>
      'Neustartbefehl abgeschlossen. Verbinde dich selbst erneut mit dem Host.';

  @override
  String get rel_ops_host_restart_failed => 'Neustartbefehl fehlgeschlagen.';

  @override
  String rel_ops_host_maintenance_running(String name) {
    return '$name läuft noch';
  }

  @override
  String rel_ops_host_maintenance_finished(String name) {
    return '$name abgeschlossen';
  }

  @override
  String rel_ops_host_maintenance_failed(String name) {
    return '$name fehlgeschlagen';
  }

  @override
  String get rel_ops_host_curator_paused_result => 'Kurator pausiert.';

  @override
  String get rel_ops_host_curator_resumed_result => 'Kurator fortgesetzt.';

  @override
  String get rel_ops_host_reset => 'Remote-Gedächtnisdateien zurücksetzen';

  @override
  String rel_ops_host_reset_confirmation(String targetName, String profile) {
    return 'Die Gedächtnisdatei $targetName für $profile löschen? Dies lässt sich in Ares nicht rückgängig machen.';
  }

  @override
  String rel_ops_host_reset_result(String targetName, int count) {
    return '$targetName zurückgesetzt. $count Datei(en) auf dem Remote-Host entfernt.';
  }

  @override
  String get rel_ops_host_share_not_redacted =>
      'Der Host hat die Schwärzung vertraulicher Daten im Paket nicht bestätigt. Es wird kein Link angezeigt.';

  @override
  String rel_ops_host_scope(String connection, String profile) {
    return 'Diese Steuerelemente bedienen das Remote-Gateway $connection für $profile, nicht dieses Gerät und nicht das Ares-Client-Update.';
  }

  @override
  String rel_ops_host_health_running(String version, int count) {
    return 'Gateway-Prozess läuft $version · $count Sitzungen';
  }

  @override
  String rel_ops_host_health_stopped(String version, int count) {
    return 'Gateway-Prozess gestoppt $version · $count Sitzungen';
  }

  @override
  String rel_ops_host_heartbeat_stale(num seconds) {
    return 'Das Lebenszeichen des Hosts ist veraltet ($seconds s).';
  }

  @override
  String get rel_ops_host_doctor => 'Doctor ausführen';

  @override
  String get rel_ops_host_security_audit => 'Sicherheitsaudit';

  @override
  String get rel_ops_host_check_receipt => 'Update-Bestätigung prüfen';

  @override
  String get rel_ops_host_logs => 'Remote-Host-Protokolle';

  @override
  String get rel_ops_host_search_logs => 'Host-Protokolle durchsuchen';

  @override
  String get rel_ops_host_driver => 'Remote-Host-Treiber';

  @override
  String get rel_ops_host_driver_scope =>
      'Die Einsatzbereitschaft der Computersteuerung bezieht sich auf Treiber und Betriebssystemberechtigungen des Gateway-Rechners, nicht auf dieses Gerät.';

  @override
  String rel_ops_host_computer_status(
    String platform,
    String installed,
    String ready,
  ) {
    return '$platform · installiert $installed · bereit $ready';
  }

  @override
  String get rel_ops_host_null => 'nicht verfügbar';

  @override
  String get rel_ops_host_true => 'ja';

  @override
  String get rel_ops_host_false => 'nein';

  @override
  String get rel_ops_host_curator => 'Kurator';

  @override
  String get rel_ops_host_curator_paused => 'Kurator pausiert';

  @override
  String get rel_ops_host_curator_running => 'Kurator läuft';

  @override
  String get rel_ops_host_no_run => 'Kein abgeschlossener Durchlauf';

  @override
  String get rel_ops_host_run_curator => 'Kurator jetzt ausführen';

  @override
  String get rel_ops_host_reset_memory => 'Gedächtnisdatei zurücksetzen';

  @override
  String get rel_ops_host_reset_user => 'Benutzerdatei zurücksetzen';

  @override
  String get rel_ops_host_reset_both => 'Beide Dateien zurücksetzen';

  @override
  String get rel_ops_host_share_consent =>
      'Ich stimme zu, ein Diagnosepaket mit geschwärzten vertraulichen Daten vom Remote-Host hochzuladen';

  @override
  String get rel_ops_host_share =>
      'Diagnosedaten mit geschwärzten vertraulichen Daten teilen';

  @override
  String get rel_ops_host_update_unknown_installation =>
      'Diese Installation ist unbekannt, daher wurde das Update nicht gesendet';

  @override
  String get rel_ops_host_update_busy_installation =>
      'Auf dieser Installation läuft ein Chat';

  @override
  String get rel_ops_host_update_refused => 'Remote-Update abgelehnt';

  @override
  String get rel_ops_host_error_stale => 'Remote-Arbeitsbereich: veraltet';

  @override
  String get rel_ops_host_error_mismatch =>
      'Remote-Arbeitsbereich: stimmt nicht überein';

  @override
  String get rel_ops_host_error_unbound =>
      'Remote-Arbeitsbereich: nicht gebunden';

  @override
  String get rel_ops_host_error_unsupported =>
      'Remote-Arbeitsbereich: nicht unterstützt';

  @override
  String get rel_ops_host_error_denied =>
      'Remote-Arbeitsbereich: Zugriff verweigert';

  @override
  String get rel_ops_host_error_ineligible =>
      'Remote-Arbeitsbereich: nicht berechtigt';

  @override
  String get rel_ops_host_error_unavailable =>
      'Remote-Arbeitsbereich: nicht verfügbar';

  @override
  String get rel_ops_host_error_invalid => 'Remote-Arbeitsbereich: ungültig';

  @override
  String get rel_ops_host_error_insecure => 'Remote-Arbeitsbereich: unsicher';

  @override
  String get rel_ops_host_error_request =>
      'Die Anfrage konnte nicht abgeschlossen werden.';

  @override
  String get rel_svc_push_api_select_sessions =>
      'Wähle 1–128 dauerhafte Sitzungs-IDs mit jeweils 1–200 ASCII-Zeichen aus. Zulässig sind nur Buchstaben, Ziffern, _ . : @ und -. Entferne leere IDs und Leerzeichen.';

  @override
  String get rel_svc_push_api_unavailable =>
      'Mobile Push ist auf diesem Server nicht verfügbar.';

  @override
  String get rel_svc_push_api_invalid_vapid =>
      'Ungültiger öffentlicher VAPID-Schlüssel des Servers.';

  @override
  String get rel_svc_push_api_update_plugin =>
      'Dieser Server benötigt für automatische Abonnements ein aktualisiertes mobile-push-Plugin.';

  @override
  String get rel_svc_push_status_android_only => 'Nur Android';

  @override
  String get rel_svc_push_native_prefs_sync_failed =>
      'Die nativen Benachrichtigungseinstellungen konnten nicht synchronisiert werden.';

  @override
  String get rel_svc_push_choose_android_connection =>
      'Wähle zuerst eine gespeicherte Verbindung auf Android aus.';

  @override
  String get rel_svc_push_status_checking_authorization =>
      'Serverautorisierung wird geprüft';

  @override
  String get rel_svc_push_revoke_persist_failed =>
      'Der Widerruf konnte nicht gespeichert werden. Versuche vor dem Verlassen der App erneut, die Funktion zu deaktivieren.';

  @override
  String get rel_svc_push_status_off_api_ready => 'Aus; Server-API bereit';

  @override
  String get rel_svc_push_status_off_revoke_pending =>
      'Aus; Serverwiderruf ausstehend';

  @override
  String get rel_svc_push_status_off_connection_changed =>
      'Aus; gespeicherte Verbindung geändert';

  @override
  String get rel_svc_push_status_pending_endpoint =>
      'Verteiler-Endpunkt ausstehend';

  @override
  String get rel_svc_push_status_registering => 'Wird registriert';

  @override
  String get rel_svc_push_status_pending_challenge =>
      'Verschlüsselte Challenge ausstehend (Warten auf stille Server-Verifizierungsnachricht)';

  @override
  String get rel_svc_push_allow_android_notifications_retry =>
      'Erlaube Android-Benachrichtigungen in den Systemeinstellungen und versuche es erneut.';

  @override
  String get rel_svc_push_plugin_invalid =>
      'Das mobile-push-Plugin des Servers ist nicht verfügbar, veraltet oder hat eine ungültige Abonnementantwort geliefert. Bitte den Betreiber um ein Update und versuche es erneut.';

  @override
  String get rel_svc_push_transport_unavailable =>
      'Kein Push-Transport ist verfügbar. Die integrierte Zustellung benötigt funktionierende Google Play-Dienste; installiere alternativ einen UnifiedPush-Verteiler und versuche es erneut.';

  @override
  String get rel_svc_push_transport_choice =>
      'Mehrere UnifiedPush-Verteiler sind verfügbar. Wähle unter „Erweiterter Transport“ einen aus und versuche es erneut.';

  @override
  String get rel_svc_push_transport_missing =>
      'Der ausgewählte UnifiedPush-Verteiler ist nicht verfügbar. Stelle ihn wieder her oder wähle unter „Erweiterter Transport“ einen anderen aus.';

  @override
  String get rel_svc_push_companion_unavailable =>
      'Der mobile-push-Begleitdienst des Servers ist nicht verfügbar. Er fehlt möglicherweise, ist deaktiviert oder diese Verbindung verweist auf das falsche Dashboard. Installiere oder aktiviere ihn auf dem Server, prüfe die Dashboard-Verbindung und aktualisiere. Siehe die Anleitung zur Servereinrichtung oben.';

  @override
  String get rel_svc_push_server_denied =>
      'Der Server hat Mobile Push abgelehnt. Bitte den Betreiber, diesen Principal und diese Sitzungen zu autorisieren.';

  @override
  String get rel_svc_push_not_ready =>
      'Mobile Push ist nicht bereit. Prüfe Plugin-Autorisierung, Verteiler und Netzwerk und versuche es erneut.';

  @override
  String get rel_svc_push_availability_read_failed =>
      'Die Verfügbarkeit von Android Push konnte nicht gelesen werden. Versuche es unten erneut.';

  @override
  String get rel_svc_push_setup_failed =>
      'Die Push-Einrichtung ist fehlgeschlagen. Prüfe Android-Berechtigung, Serverautorisierung und Transport und versuche es erneut.';

  @override
  String rel_svc_push_status(String status) {
    return 'Status: $status';
  }

  @override
  String rel_svc_push_status_bound(
    String bound,
    String connection,
    String status,
  ) {
    return 'Status: An $bound gebunden (nicht aktiv für $connection; Handshake: $status)';
  }

  @override
  String get rel_svc_push_another_saved_connection =>
      'eine andere gespeicherte Verbindung';

  @override
  String get rel_svc_push_background_notifications =>
      'Hintergrundbenachrichtigungen';

  @override
  String rel_svc_push_bound_subtitle(String bound, String connection) {
    return 'An $bound gebunden — widerrufe diese Bindung unten, bevor du sie für $connection aktivierst';
  }

  @override
  String rel_svc_push_private_activity(String connection) {
    return 'Private Serveraktivität für $connection';
  }

  @override
  String rel_svc_push_bound_warning_named(String bound) {
    return 'An eine andere gespeicherte Verbindung ($bound) gebunden. Deaktiviere und widerrufe diese Bindung, bevor du sie für diese Verbindung aktivierst.';
  }

  @override
  String get rel_svc_push_bound_warning =>
      'An eine andere gespeicherte Verbindung gebunden. Deaktiviere und widerrufe diese Bindung, bevor du sie für diese Verbindung aktivierst.';

  @override
  String get rel_svc_push_local_notifications_muted =>
      'Lokale Benachrichtigungen sind oben ausgeschaltet. Die Zustimmung zu Hintergrundbenachrichtigungen bleibt bestehen, gewöhnliche Aktivitätshinweise bleiben jedoch stumm, bis „Benachrichtigungen aktivieren“ eingeschaltet wird.';

  @override
  String rel_svc_push_legacy_subscription(int count) {
    return 'Altes Abonnement: nur $count ausgewählte Sitzung(en). Es wird nicht automatisch erweitert. Aus- und wieder einschalten, um serverautorisierten Sitzungen zuzustimmen.';
  }

  @override
  String get rel_svc_push_authorized_binding =>
      'Nur an diese gespeicherte Verbindung und dieses Profil gebunden. Der Sitzungszugriff folgt der aktuellen Serverautorisierung.';

  @override
  String get rel_svc_push_revocation_pending =>
      'Serverwiderruf ausstehend. Lokale Zustellung ist aus; versuche es erneut, solange die ursprünglich gespeicherte Anmeldung verfügbar ist.';

  @override
  String get rel_svc_push_refresh_retry => 'Aktualisieren / erneut versuchen';

  @override
  String rel_svc_push_disable_named(String bound) {
    return '$bound deaktivieren und widerrufen';
  }

  @override
  String get rel_svc_push_other_connection => 'andere Verbindung';

  @override
  String get rel_svc_push_disable => 'Deaktivieren und widerrufen';

  @override
  String get rel_svc_push_refresh_explanation =>
      'Aktualisieren / erneut versuchen prüft die Verfügbarkeit nach der Servereinrichtung; der Begleitdienst kann damit nicht installiert werden. Benachrichtigungen zu aktivieren bleibt eine separate Entscheidung.';

  @override
  String get rel_svc_push_companion_required =>
      'Hintergrundbenachrichtigungen benötigen einen separat installierten und aktivierten serverseitigen mobile-push-Begleitdienst. Android kann ihn nicht installieren. Ein APK-Update allein richtet den Server nicht ein.';

  @override
  String get rel_svc_push_server_setup_guide =>
      'Anleitung zur Servereinrichtung';

  @override
  String get rel_svc_push_enable_disclosure =>
      'Aktivieren, um die Android-Benachrichtigungsberechtigung anzufordern und Endpunkt sowie Verschlüsselungsschlüssel dieser Installation mit diesem Server zu teilen. Verschlüsselte Aktivitätshinweise enthalten keine Chatinhalte. Nur durch deine Serveranmeldung autorisierte Sitzungen werden einbezogen.';

  @override
  String get rel_svc_push_transport_disclosure =>
      'Die integrierte Zustellung nutzt Googles Push-Transport und benötigt Google Play-Dienste, enthält aber kein Firebase SDK. Alternativ kann ein UnifiedPush-Verteiler verwendet werden. Die Zustellung erfolgt nach bestem Bemühen; öffne Hermes erneut zum Abgleich.';

  @override
  String get rel_svc_push_advanced_transport => 'Erweiterter Transport';

  @override
  String get rel_svc_push_automatic_explanation =>
      'Automatisch behält eine vorhandene Verteilerwahl bei, sonst wird die integrierte Google-Zustellung verwendet, wenn verfügbar. Vor dem Transportwechsel deaktivieren.';

  @override
  String get rel_svc_push_transport_label => 'Push-Transport';

  @override
  String get rel_svc_push_automatic_recommended => 'Automatisch (empfohlen)';

  @override
  String get rel_svc_push_selected_unavailable =>
      'Ausgewählter Verteiler (nicht verfügbar)';

  @override
  String get rel_svc_push_no_transport_detected =>
      'Kein verfügbarer Transport erkannt. Die integrierte Zustellung benötigt Google Play-Dienste; installiere und konfiguriere andernfalls einen UnifiedPush-Verteiler und aktualisiere.';

  @override
  String get rel_svc_push_channel_turns_name => 'Ares-Turns';

  @override
  String get rel_svc_push_channel_turns_description =>
      'Benachrichtigungen für abgeschlossene Hintergrund-Turns';

  @override
  String get rel_svc_push_channel_attention_name => 'Ares Aufmerksamkeit';

  @override
  String get rel_svc_push_channel_attention_description =>
      'Genehmigungen und Eingabeanfragen, die dich benötigen';

  @override
  String get rel_svc_push_channel_background_name => 'Ares Hintergrund';

  @override
  String get rel_svc_push_channel_background_description =>
      'Abschlüsse von Hintergrundaufgaben';

  @override
  String get rel_svc_push_channel_notices_name => 'Ares-Hinweise';

  @override
  String get rel_svc_push_channel_notices_description =>
      'Guthaben- und Plugin-Hinweise';

  @override
  String get rel_svc_push_diag_not_initialised => 'nicht initialisiert';

  @override
  String get rel_svc_push_diag_replies_off =>
      'Antwortbenachrichtigungen sind aus';

  @override
  String get rel_svc_push_diag_conversation => 'Unterhaltung';

  @override
  String get rel_svc_push_diag_conversation_permission_denied =>
      'Unterhaltung; Berechtigung verweigert';

  @override
  String rel_svc_push_diag_conversation_error(String error) {
    return 'Unterhaltung: $error';
  }

  @override
  String get rel_svc_push_diag_failures_off =>
      'Fehlerbenachrichtigungen sind aus';

  @override
  String rel_svc_push_diag_kind_off(String kind) {
    return '$kind ist aus';
  }

  @override
  String get rel_svc_push_diag_windows_setting_unknown =>
      'Windows hat seine Benachrichtigungseinstellung nicht gemeldet';

  @override
  String get rel_svc_backup_not_hermes_configuration_backup =>
      'Diese Datei ist keine Hermes-Konfigurationssicherung.';

  @override
  String get rel_svc_backup_newer_version_cannot_import =>
      'Diese Sicherung wurde mit einer neueren App-Version erstellt und kann nicht importiert werden.';

  @override
  String get rel_svc_backup_missing_client_certificate =>
      'Diese Sicherung gibt ein Clientzertifikat für eine Verbindung an, enthält es aber nicht. Eine vollständige Wiederherstellung ist daher nicht möglich.';

  @override
  String get rel_svc_backup_damaged_unreadable =>
      'Diese Sicherungsdatei ist beschädigt und konnte nicht gelesen werden.';

  @override
  String get rel_svc_backup_unsupported_preference_type =>
      'Eine gespeicherte Einstellung hat einen nicht unterstützten Typ und kann nicht exportiert werden.';

  @override
  String get rel_svc_backup_choose_passphrase_api_keys =>
      'Wähle eine Passphrase – die Sicherung enthält deine API-Schlüssel.';

  @override
  String get rel_svc_backup_could_not_protect_safely =>
      'Die Sicherung konnte nicht sicher geschützt werden.';

  @override
  String get rel_svc_backup_unsupported_encryption =>
      'Diese Sicherung verwendet ein nicht unterstütztes Verschlüsselungsverfahren.';

  @override
  String get rel_svc_backup_wrong_passphrase_or_altered =>
      'Falsche Passphrase oder diese Sicherungsdatei wurde verändert.';

  @override
  String get rel_svc_backup_share_subject => 'Hermes-Konfigurationssicherung';

  @override
  String get rel_svc_backup_selected_file_unreadable =>
      'Diese Datei konnte nicht gelesen werden.';

  @override
  String rel_svc_backup_connections_added(int count) {
    return '$count hinzugefügt';
  }

  @override
  String rel_svc_backup_connections_updated(int count) {
    return '$count aktualisiert';
  }

  @override
  String rel_svc_backup_connections_removed(int count) {
    return '$count entfernt';
  }

  @override
  String get rel_svc_backup_no_connection_changes =>
      'Keine Verbindungsänderungen';

  @override
  String rel_svc_backup_connections_summary(String changes) {
    return 'Verbindungen: $changes';
  }

  @override
  String rel_svc_backup_restore_summary(String connections, int count) {
    return '$connections · $count Einstellungen wiederhergestellt';
  }

  @override
  String rel_svc_backup_certificate_not_included(String label, String error) {
    return 'Das Clientzertifikat für „$label“ konnte nicht in diese Sicherung aufgenommen werden: $error';
  }

  @override
  String get rel_svc_backup_certificate_password_needed =>
      'Dieses Zertifikat benötigt sein Passwort. Gib es unten ein; dann wird es automatisch geöffnet.';

  @override
  String get rel_svc_backup_certificate_password_or_corrupt =>
      'Das Zertifikatpasswort ist falsch oder die Datei ist beschädigt.';

  @override
  String get rel_svc_backup_certificate_password_incorrect =>
      'Das Zertifikatpasswort ist falsch.';

  @override
  String get rel_svc_backup_certificate_unsupported_encryption =>
      'Dieses Zertifikat verwendet eine Verschlüsselungsmethode, die die App nicht lesen kann.';

  @override
  String get rel_svc_backup_certificate_unreadable_pkcs12 =>
      'Die ausgewählte Datei ist kein lesbares PKCS#12-Zertifikat (.p12/.pfx).';

  @override
  String get rel_svc_backup_certificate_unreadable =>
      'Das ausgewählte Zertifikat konnte nicht gelesen werden.';

  @override
  String get rel_svc_backup_not_certificate_file =>
      'Diese Datei ist kein Zertifikat: Wähle einen .p12/.pfx-Container oder PEM-Zertifikat- und Schlüsseldateien.';

  @override
  String get rel_svc_backup_not_pem_certificate =>
      'Das ausgewählte Zertifikat ist kein PEM-Zertifikat.';

  @override
  String get rel_svc_backup_not_pem_private_key =>
      'Der ausgewählte private Schlüssel ist kein privater PEM-Schlüssel.';

  @override
  String get rel_svc_backup_certificate_pair_unloadable =>
      'Das ausgewählte Zertifikat und der private Schlüssel konnten nicht geladen werden.';

  @override
  String get rel_svc_backup_saved_certificate_files_unreadable =>
      'Die gespeicherten Clientzertifikatdateien konnten nicht gelesen werden.';

  @override
  String get rel_svc_backup_client_certificate_storage_failed =>
      'Das Clientzertifikat konnte auf diesem Gerät nicht sicher gespeichert werden.';

  @override
  String get rel_svc_backup_certificate_storage_failed =>
      'Das Zertifikat konnte auf diesem Gerät nicht sicher gespeichert werden.';

  @override
  String get rel_svc_backup_client_certificate_label => 'Clientzertifikat';

  @override
  String rel_svc_backup_search_dashboard_unreachable(String error) {
    return 'Das Dashboard war nicht erreichbar: $error';
  }

  @override
  String get rel_svc_backup_search_credentials_rejected =>
      'Das Dashboard hat die gespeicherten Anmeldedaten abgelehnt. Prüfe Dashboard-Benutzername und -Passwort für diese Verbindung.';

  @override
  String get rel_svc_backup_search_not_supported =>
      'Dieses Dashboard bietet keine Sitzungssuche. Aktualisiere Hermes auf dem Host oder wechsle zurück zur Suche auf dem Gerät.';

  @override
  String rel_svc_backup_search_redirected(int statusCode) {
    return 'Das Dashboard hat die Sitzungssuche umgeleitet (HTTP $statusCode). Ares folgt mit gespeicherten Anmeldedaten keinen Weiterleitungen; prüfe die Verbindungsadresse.';
  }

  @override
  String rel_svc_backup_search_http_failed(int statusCode) {
    return 'Die Sitzungssuche ist mit HTTP $statusCode fehlgeschlagen.';
  }

  @override
  String get rel_svc_backup_search_malformed_response =>
      'Das Dashboard hat eine fehlerhafte Suchantwort zurückgegeben.';

  @override
  String get rel_svc_backup_search_unexpected_response =>
      'Das Dashboard hat eine unerwartete Suchantwort zurückgegeben.';

  @override
  String get rel_svc_backup_search_too_many_results =>
      'Das Dashboard hat mehr Suchergebnisse als angefordert zurückgegeben.';

  @override
  String get rel_svc_backup_message_search_unexpected_response =>
      'Unerwartete Antwort der Nachrichtensuche.';

  @override
  String get rel_svc_backup_message_search_unexpected_result =>
      'Unerwartetes Ergebnis der Nachrichtensuche.';

  @override
  String get rel_svc_backup_ai_search_api_key_rejected =>
      'Die Hermes-API hat den gespeicherten API-Schlüssel abgelehnt.';

  @override
  String rel_svc_backup_ai_search_http_failed(int statusCode) {
    return 'Die KI-Abfrageumschreibung ist mit HTTP $statusCode fehlgeschlagen.';
  }

  @override
  String get rel_svc_backup_ai_search_no_usable_query =>
      'Das ausgewählte Modell hat keine brauchbare Suchanfrage zurückgegeben.';

  @override
  String get rel_svc_backup_ai_search_malformed_response =>
      'Hermes hat eine fehlerhafte KI-Umschreibungsantwort zurückgegeben.';

  @override
  String get rel_svc_backup_space_name_already_exists =>
      'Ein Bereich mit diesem Namen ist bereits vorhanden';

  @override
  String get rel_svc_backup_space_name_length_invalid =>
      'Der Bereichsname muss 1–80 Zeichen lang sein';

  @override
  String get ng_rel_svc_backup_gateway_address_required =>
      'Gib die Adresse deines Hermes-Dashboards ein.';

  @override
  String ng_rel_svc_backup_gateway_address_scheme(String scheme) {
    return 'Die Adresse muss mit http:// oder https:// beginnen (erhalten: $scheme).';
  }

  @override
  String get ng_rel_svc_backup_gateway_address_invalid =>
      'Diese Adresse ist ungültig.';

  @override
  String get ng_rel_svc_backup_gateway_address_no_host =>
      'Die Adresse enthält keinen Hostnamen.';

  @override
  String get ng_rel_svc_backup_sign_in_main_window =>
      'Melde dich im Hauptfenster an.';

  @override
  String get rel_svc_backup_sign_in_renewal_failed =>
      'Das Gateway konnte die Anmeldung gerade nicht erneuern.';

  @override
  String get rel_svc_backup_sign_in_provider_unreachable =>
      'Das Gateway konnte die Anmeldung nicht erneuern: Der Anmeldeanbieter ist nicht erreichbar.';

  @override
  String get rel_svc_backup_sign_in_renewal_timed_out =>
      'Zeitüberschreitung beim Erneuern der Anmeldung.';

  @override
  String get rel_svc_backup_sign_in_no_tokens =>
      'Das Gateway hat keine Anmeldetoken zurückgegeben.';

  @override
  String get ng_rel_svc_backup_probe_timed_out =>
      'Zeitüberschreitung. Prüfe die Adresse sowie die VPN- oder Tailscale-Verbindung.';

  @override
  String ng_rel_svc_backup_probe_tls_failed(String error) {
    return 'TLS-Handshake fehlgeschlagen: $error';
  }

  @override
  String ng_rel_svc_backup_gateway_answered_http(int statusCode) {
    return 'Das Gateway antwortete mit HTTP $statusCode.';
  }

  @override
  String get ng_rel_svc_backup_gateway_answer_timed_out =>
      'Das Gateway hat zu lange für die Antwort gebraucht.';

  @override
  String ng_rel_svc_backup_browser_callback_not_ready(String error) {
    return 'Die Rückkehr des Browsers konnte nicht vorbereitet werden: $error';
  }

  @override
  String get ng_rel_svc_backup_browser_signed_in_body =>
      'Du kannst jetzt zu Hermes zurückkehren.';

  @override
  String get ng_rel_svc_backup_browser_waiting_title => 'Warten auf Anmeldung';

  @override
  String get ng_rel_svc_backup_browser_not_current =>
      'Diese Seite gehört nicht zur aktuellen Anmeldung.';

  @override
  String get ng_rel_svc_backup_browser_open_failed =>
      'Der Browser konnte für die Anmeldung nicht geöffnet werden.';

  @override
  String get ng_rel_svc_backup_browser_sign_in_timed_out =>
      'Die Anmeldung hat zu lange gedauert. Versuche es erneut.';

  @override
  String ng_rel_svc_backup_gateway_refused_sign_in(int statusCode) {
    return 'Das Gateway hat die Anmeldung abgelehnt (HTTP $statusCode).';
  }

  @override
  String get rel_svc_misc_alert_caution => 'Vorsicht';

  @override
  String get rel_svc_misc_alert_important => 'Wichtig';

  @override
  String get rel_svc_misc_alert_tip => 'Tipp';

  @override
  String get rel_svc_misc_alert_warning => 'Warnung';

  @override
  String get rel_svc_misc_allow_folder_session =>
      'Diesen Ordner bis zum Ende der Sitzung zulassen.';

  @override
  String get rel_svc_misc_allow_website_session =>
      'Diese Website bis zum Ende der Sitzung zulassen.';

  @override
  String rel_svc_misc_approval_needed_title(String title) {
    return 'Genehmigung erforderlich — $title';
  }

  @override
  String get rel_svc_misc_attach_file_reference => 'Dateiverweis anhängen';

  @override
  String get rel_svc_misc_attach_folder_reference => 'Ordnerverweis anhängen';

  @override
  String get rel_svc_misc_attach_git_context => 'Git-Kontext anhängen';

  @override
  String get rel_svc_misc_attach_image_reference => 'Bildverweis anhängen';

  @override
  String get rel_svc_misc_attach_staged_diff =>
      'Bereitgestellten Diff anhängen';

  @override
  String get rel_svc_misc_attach_tool_reference => 'Werkzeugverweis anhängen';

  @override
  String get rel_svc_misc_attach_unstaged_diff =>
      'Nicht bereitgestellten Diff anhängen';

  @override
  String get rel_svc_misc_attach_url_reference => 'URL-Verweis anhängen';

  @override
  String get rel_svc_misc_background_task_completed =>
      'Hintergrundaufgabe abgeschlossen';

  @override
  String rel_svc_misc_background_task_named_completed(String taskId) {
    return 'Hintergrundaufgabe $taskId abgeschlossen';
  }

  @override
  String get rel_svc_misc_chat => 'Chat';

  @override
  String get rel_svc_misc_compacting_context =>
      'Konversationskontext wird komprimiert…';

  @override
  String rel_svc_misc_completed_in(String duration) {
    return 'In $duration abgeschlossen';
  }

  @override
  String get rel_svc_misc_context_compacted =>
      'Konversationskontext komprimiert';

  @override
  String get rel_svc_misc_cron_readback_mismatch =>
      'Das zurückgelesene Cron-Modell stimmte nicht überein';

  @override
  String get rel_svc_misc_cron_update_rejected =>
      'Cron-Aktualisierung abgelehnt';

  @override
  String get rel_svc_misc_deny_folder_grant => 'Diesen Ordner nicht freigeben.';

  @override
  String get rel_svc_misc_deny_website_grant =>
      'Diese Website nicht freigeben.';

  @override
  String rel_svc_misc_failed_after(String duration) {
    return 'Nach $duration fehlgeschlagen';
  }

  @override
  String get rel_svc_misc_gateway_folder_unnamed =>
      'Das Gateway hat keinen Ordner angegeben.';

  @override
  String get rel_svc_misc_gateway_idle_unconfirmed =>
      'Das Gateway ist inaktiv. Das Ergebnis des vorherigen Durchlaufs konnte nicht bestätigt werden.';

  @override
  String get rel_svc_misc_gateway_turn_failed =>
      'Gateway-Durchlauf fehlgeschlagen';

  @override
  String rel_svc_misc_gateway_turn_status(String status) {
    return 'Gateway-Durchlauf: $status';
  }

  @override
  String get rel_svc_misc_gateway_website_unnamed =>
      'Das Gateway hat keine Website angegeben.';

  @override
  String get rel_svc_misc_hermes_review => 'Hermes-Überprüfung';

  @override
  String get rel_svc_misc_hermes_turn_failed =>
      'Hermes-Durchlauf fehlgeschlagen';

  @override
  String get rel_svc_misc_image_recovery_companion_gap =>
      'Die Wiederherstellung von Bildern und Text ist bei der begleitenden Wiederherstellung nicht verfügbar. Ein unbestätigter Bildversand kann über diese Verbindung nicht wiederhergestellt werden, und es wird nichts automatisch erneut gesendet.';

  @override
  String get rel_svc_misc_image_recovery_rest_gap =>
      'Die Wiederherstellung von Bildern und Text ist bei Classic REST/SSE nicht verfügbar. Ein unbestätigter Bildversand kann über diese Verbindung nicht wiederhergestellt werden, und es wird nichts automatisch erneut gesendet.';

  @override
  String rel_svc_misc_input_needed_title(String title) {
    return 'Eingabe erforderlich — $title';
  }

  @override
  String get rel_svc_misc_parallel_workspace_connection_changed =>
      'Die Verbindung hat sich geändert. Öffne sie erneut, um den Arbeitsbereich zu verwenden.';

  @override
  String get rel_svc_misc_preparing => 'Wird vorbereitet';

  @override
  String get rel_svc_misc_save_folder_grant =>
      'Diese Ordnerfreigabe für spätere Anfragen speichern.';

  @override
  String get rel_svc_misc_save_website_grant =>
      'Diese Website-Freigabe für spätere Anfragen speichern.';

  @override
  String get rel_svc_misc_stored_identity_turn_conflict =>
      'Dieser Chat wurde über seine gespeicherte Identität geöffnet, während ein anderer Durchlauf zugelassen war. Die noch nicht gesendete Eingabe wurde nicht gesendet; versuche es nach Abschluss dieses Durchlaufs ausdrücklich erneut.';

  @override
  String get rel_svc_misc_untitled => 'Ohne Titel';

  @override
  String get rel_svc_misc_wake_capture_silent =>
      'Die clientseitige Wake-Aufnahme hört nur Stille — prüfe den Mikrofonzugriff des Betriebssystems und schalte das Aktivierungswort erneut ein.';

  @override
  String get rel_svc_misc_wake_capture_stalled =>
      'Die clientseitige Wake-Aufnahme ist ins Stocken geraten: Es kamen keine Mikrofon-Audio-Callbacks an.';

  @override
  String rel_svc_misc_wake_feed_refused(int count, String detail) {
    return 'Der Aktivierungswort-Feed hat $count aufeinanderfolgende Frames abgelehnt$detail — schalte das Aktivierungswort erneut ein, um es wieder zu aktivieren.';
  }

  @override
  String rel_svc_misc_wake_microphone_failed(String error) {
    return 'Clientseitiger Wake-Mikrofonstream fehlgeschlagen: $error';
  }

  @override
  String get rel_svc_misc_wake_track_ended =>
      'Die Mikrofonspur endete während der Aktivierungswort-Aufnahme — schalte das Aktivierungswort erneut ein, um es wieder zu aktivieren.';

  @override
  String get rel_svc_misc_website => 'Website';

  @override
  String get rel_svc_lan_timeout => 'Zeitüberschreitung bei der LAN-Suche';

  @override
  String get rel_svc_notification_permission_denied =>
      'Berechtigung verweigert';

  @override
  String get rel_svc_notifications_off =>
      'Benachrichtigungen sind ausgeschaltet';

  @override
  String rel_chat_preview_pin_label(int number, String note) {
    return '#$number $note';
  }

  @override
  String rel_chat_preview_pin_number(int number) {
    return '#$number';
  }

  @override
  String ng_rel_chat_wake_status_notice(String status, String notice) {
    return '$status — $notice';
  }

  @override
  String ng_rel_chat_cost_amount(String amount) {
    return '\$$amount';
  }

  @override
  String ng_rel_chat_context_ratio(String used, String maximum) {
    return '$used / $maximum';
  }

  @override
  String ng_rel_chat_connection_reason(String status, String reason) {
    return '$status $reason';
  }

  @override
  String ng_rel_chat_notice_time(String message, String time) {
    return '$message · $time';
  }

  @override
  String ng_rel_chat_attachment_progress(String name, String progress) {
    return '$name · $progress';
  }

  @override
  String ng_rel_chat_tool_detail(String name, String detail) {
    return '$name · $detail';
  }

  @override
  String get fleet_managed_ssh_title => 'Vom Gateway verwaltetes SSH';

  @override
  String get fleet_managed_ssh_intro =>
      'Verwalte SSH-Hosts, die bereits auf diesem Gateway gespeichert sind, von jedem Gerät aus. Hermes muss bereits auf dem Remote-Host installiert sein. Dabei wird ein eigener Remote-Dienst gestartet oder eine Verbindung zu ihm hergestellt, keine Ares-Chatverbindung. Verwaltete Updates und Wiederherstellung sind nur in der nativen Desktop-App verfügbar.';

  @override
  String get fleet_managed_ssh_read => 'Gespeicherte SSH-Hosts lesen';

  @override
  String get fleet_managed_ssh_trust =>
      'Bei dieser ersten Verbindung vertraut das Gateway dem SSH-Schlüssel dieses Hosts und speichert ihn. Eine spätere Schlüsseländerung wird erkannt und blockiert. Das Gateway meldet den Schlüsselfingerabdruck nicht, daher kann Ares ihn weder anzeigen noch speichern. Fahre nur fort, wenn du dieser ersten Verbindung vertraust.';

  @override
  String get fleet_managed_ssh_changed =>
      'Der SSH-Schlüssel dieses Hosts hat sich geändert. Verbindung blockiert. Jemand mit Zugriff auf den Gateway-Host muss den neuen Schlüsselfingerabdruck unabhängig überprüfen und dort den alten vertrauenswürdigen Schlüssel entfernen. Versuche es erst nach dieser Überprüfung und Reparatur erneut. Ares ersetzt den vertrauenswürdigen Schlüssel nicht.';

  @override
  String get fleet_managed_ssh_disconnect_warning =>
      'SSH-Tunnel trennen und den Remote-Dienst stoppen, der diesem Gateway gehört? Dadurch können andere Clients unterbrochen werden, die diesen Dienst verwenden.';

  @override
  String get fleet_managed_ssh_verify =>
      'Den Schlüssel stattdessen selbst überprüfen';

  @override
  String fleet_managed_ssh_pending(int seconds) {
    return 'Warten auf das Gateway: $seconds s. Das Verlassen dieser Seite bricht die Einrichtung nicht ab. Falls die Anfrage fehlschlägt, prüfe vor einem erneuten Versuch den Status.';
  }

  @override
  String fleet_managed_ssh_status(
    String host,
    int localPort,
    int remotePort,
    String version,
    String reused,
  ) {
    return 'Host: $host\nLokaler Loopback-Port: $localPort\nRemote-Loopback-Port: $remotePort\nHermes: $version\nWiederverwendet: $reused';
  }

  @override
  String get fleet_managed_ssh_disconnect => 'Trennen';

  @override
  String get ng_slash_suggestions_loading => 'Befehle werden geladen…';

  @override
  String get ng_slash_suggestions_empty => 'Keine passenden Befehle';

  @override
  String get ng_slash_suggestions_label => 'Befehlsvorschläge';

  @override
  String get ng_slash_suggestions_skill => 'Skill';

  @override
  String get settings_classic_title => 'Classic-Einstellungen';

  @override
  String get settings_nextgen_title => 'NextGen-Einstellungen';

  @override
  String get settings_category_general => 'Allgemein & Sprache';

  @override
  String get settings_category_chat => 'Chat & Sitzungen';

  @override
  String get settings_category_device => 'Gerät & Tastenkürzel';

  @override
  String get settings_category_connections => 'Verbindungen & Modelle';

  @override
  String get settings_category_security => 'Datenschutz & Sicherung';

  @override
  String get settings_category_about => 'Info & Hilfe';

  @override
  String get settings_reopen_chat =>
      'Letzten Chat bei Rückkehr zu einem Gateway wiederherstellen';

  @override
  String get settings_reopen_chat_hint =>
      'Beim Kaltstart erscheint die Begrüßungsseite. Links und Benachrichtigungen öffnen den angeforderten Chat.';

  @override
  String get settings_danger => 'Gefahrenbereich';
}
