import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ru'),
    Locale('uk'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @attachment_audio_failed.
  ///
  /// In en, this message translates to:
  /// **'This audio could not be played. Its format or codec may not be supported, or the preview size limit was exceeded. Retry, or save or share the original file.'**
  String get attachment_audio_failed;

  /// No description provided for @attachment_audio_seek.
  ///
  /// In en, this message translates to:
  /// **'Audio position'**
  String get attachment_audio_seek;

  /// No description provided for @workspace_workers.
  ///
  /// In en, this message translates to:
  /// **'Live workers'**
  String get workspace_workers;

  /// No description provided for @workers_unattached.
  ///
  /// In en, this message translates to:
  /// **'Counts only. To steer a worker, choose Live workers in its attached parent chat.'**
  String get workers_unattached;

  /// No description provided for @slash_local_arguments.
  ///
  /// In en, this message translates to:
  /// **'This shortcut does not accept arguments here. Use the app controls; your draft was kept.'**
  String get slash_local_arguments;

  /// No description provided for @fallback_title.
  ///
  /// In en, this message translates to:
  /// **'Fallback models'**
  String get fallback_title;

  /// No description provided for @fallback_notice.
  ///
  /// In en, this message translates to:
  /// **'Tried in order when the main model is unavailable. Changes apply to this profile only; save the complete list explicitly.'**
  String get fallback_notice;

  /// No description provided for @fallback_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Fallback settings are unavailable or invalid. Check the connection, selected profile and host version, then retry.'**
  String get fallback_unavailable;

  /// No description provided for @fallback_discovery_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Provider discovery is unavailable. Existing entries are preserved; retry to choose providers and models.'**
  String get fallback_discovery_unavailable;

  /// No description provided for @fallback_empty.
  ///
  /// In en, this message translates to:
  /// **'No entries in this fallback list.'**
  String get fallback_empty;

  /// No description provided for @fallback_incomplete.
  ///
  /// In en, this message translates to:
  /// **'Choose a provider and model for every entry, or remove incomplete entries before saving.'**
  String get fallback_incomplete;

  /// No description provided for @fallback_add.
  ///
  /// In en, this message translates to:
  /// **'Add fallback'**
  String get fallback_add;

  /// No description provided for @fallback_save.
  ///
  /// In en, this message translates to:
  /// **'Save fallback list'**
  String get fallback_save;

  /// No description provided for @fallback_save_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not verify the saved fallback list. Your draft is preserved. Retry saving or refresh to reload the host settings.'**
  String get fallback_save_failed;

  /// No description provided for @fallback_saved.
  ///
  /// In en, this message translates to:
  /// **'Fallback list saved and verified.'**
  String get fallback_saved;

  /// No description provided for @fallback_legacy_title.
  ///
  /// In en, this message translates to:
  /// **'Legacy fallbacks (read-only)'**
  String get fallback_legacy_title;

  /// No description provided for @fallback_legacy_notice.
  ///
  /// In en, this message translates to:
  /// **'The host also uses fallback_model after this list, skipping duplicate routes. These legacy entries are preserved, even when the list above is empty. Edit them on the host.'**
  String get fallback_legacy_notice;

  /// No description provided for @fallback_priority.
  ///
  /// In en, this message translates to:
  /// **'Priority {position}'**
  String fallback_priority(String position);

  /// No description provided for @fallback_move_up.
  ///
  /// In en, this message translates to:
  /// **'Move up'**
  String get fallback_move_up;

  /// No description provided for @fallback_move_down.
  ///
  /// In en, this message translates to:
  /// **'Move down'**
  String get fallback_move_down;

  /// No description provided for @fallback_routing_read_only.
  ///
  /// In en, this message translates to:
  /// **'Routing details or an unlisted provider are preserved. Edit this provider/model on the host; you can still reorder or remove the entry.'**
  String get fallback_routing_read_only;

  /// No description provided for @cron_model_default.
  ///
  /// In en, this message translates to:
  /// **'Follow default'**
  String get cron_model_default;

  /// No description provided for @cron_model_notice.
  ///
  /// In en, this message translates to:
  /// **'Applies only to this cron job. Without a pin, Hermes uses the cron default, then the main model. Manage custom models on the host.'**
  String get cron_model_notice;

  /// No description provided for @model_management_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Model settings could not be loaded or saved. Refresh and try again.'**
  String get model_management_unavailable;

  /// No description provided for @model_management_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Main, fallback and auxiliary models for this profile'**
  String get model_management_subtitle;

  /// No description provided for @usage.
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get usage;

  /// No description provided for @nous_portal.
  ///
  /// In en, this message translates to:
  /// **'Nous Portal'**
  String get nous_portal;

  /// No description provided for @portal_menu_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Gateway status and recorded usage'**
  String get portal_menu_subtitle;

  /// No description provided for @portal_read_only.
  ///
  /// In en, this message translates to:
  /// **'Read-only gateway data. Manage Nous authentication on the Hermes host. Subscription balances and credits are not provided by these endpoints.'**
  String get portal_read_only;

  /// No description provided for @portal_status.
  ///
  /// In en, this message translates to:
  /// **'Gateway Portal status'**
  String get portal_status;

  /// No description provided for @portal_free_tier.
  ///
  /// In en, this message translates to:
  /// **'Free-tier access (not a signed-in account)'**
  String get portal_free_tier;

  /// No description provided for @portal_signed_in.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get portal_signed_in;

  /// No description provided for @portal_signed_out.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get portal_signed_out;

  /// No description provided for @portal_account_tier.
  ///
  /// In en, this message translates to:
  /// **'Account tier'**
  String get portal_account_tier;

  /// No description provided for @portal_recorded_usage.
  ///
  /// In en, this message translates to:
  /// **'Recorded usage'**
  String get portal_recorded_usage;

  /// No description provided for @portal_all_providers.
  ///
  /// In en, this message translates to:
  /// **'All providers in the selected gateway profile. Recorded zero cost does not mean a model is free.'**
  String get portal_all_providers;

  /// No description provided for @portal_period.
  ///
  /// In en, this message translates to:
  /// **'Last {days} days'**
  String portal_period(String days);

  /// No description provided for @portal_sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get portal_sessions;

  /// No description provided for @portal_input.
  ///
  /// In en, this message translates to:
  /// **'Input tokens'**
  String get portal_input;

  /// No description provided for @portal_output.
  ///
  /// In en, this message translates to:
  /// **'Output tokens'**
  String get portal_output;

  /// No description provided for @portal_estimated.
  ///
  /// In en, this message translates to:
  /// **'Estimated recorded cost'**
  String get portal_estimated;

  /// No description provided for @portal_actual.
  ///
  /// In en, this message translates to:
  /// **'Actual recorded cost'**
  String get portal_actual;

  /// No description provided for @portal_recorded_models.
  ///
  /// In en, this message translates to:
  /// **'Recorded models'**
  String get portal_recorded_models;

  /// No description provided for @portal_no_models.
  ///
  /// In en, this message translates to:
  /// **'No recorded models.'**
  String get portal_no_models;

  /// No description provided for @portal_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable. Check the connection, selected profile and gateway version, then retry.'**
  String get portal_unavailable;

  /// No description provided for @paste_attachment_failed_text_kept.
  ///
  /// In en, this message translates to:
  /// **'Could not attach the paste. The text was kept in the message.'**
  String get paste_attachment_failed_text_kept;

  /// No description provided for @background_task_report.
  ///
  /// In en, this message translates to:
  /// **'Background task'**
  String get background_task_report;

  /// No description provided for @background_process_report.
  ///
  /// In en, this message translates to:
  /// **'Background process'**
  String get background_process_report;

  /// No description provided for @background_report_issues.
  ///
  /// In en, this message translates to:
  /// **'Issues reported — expand for details.'**
  String get background_report_issues;

  /// No description provided for @background_report_expand.
  ///
  /// In en, this message translates to:
  /// **'Expand report'**
  String get background_report_expand;

  /// No description provided for @background_report_collapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse report'**
  String get background_report_collapse;

  /// No description provided for @ng_brand_open_chat.
  ///
  /// In en, this message translates to:
  /// **'Open a chat'**
  String get ng_brand_open_chat;

  /// No description provided for @ng_brand_recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get ng_brand_recent;

  /// No description provided for @ng_brand_sidebar_hint.
  ///
  /// In en, this message translates to:
  /// **'or pick a chat from the sidebar'**
  String get ng_brand_sidebar_hint;

  /// No description provided for @copy_session_id.
  ///
  /// In en, this message translates to:
  /// **'Copy session ID'**
  String get copy_session_id;

  /// No description provided for @copy_session_id_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not copy the session ID.'**
  String get copy_session_id_failed;

  /// No description provided for @setup_interface_title.
  ///
  /// In en, this message translates to:
  /// **'Choose your interface'**
  String get setup_interface_title;

  /// No description provided for @setup_interface_classic.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get setup_interface_classic;

  /// No description provided for @setup_interface_nextgen.
  ///
  /// In en, this message translates to:
  /// **'NextGen'**
  String get setup_interface_nextgen;

  /// No description provided for @setup_interface_classic_description.
  ///
  /// In en, this message translates to:
  /// **'The original Ares workspace, with full connection controls and every Classic setting.'**
  String get setup_interface_classic_description;

  /// No description provided for @setup_interface_nextgen_description.
  ///
  /// In en, this message translates to:
  /// **'A newer look with one dashboard sign-in, live plans, subagents and notifications.'**
  String get setup_interface_nextgen_description;

  /// No description provided for @setup_interface_switch_later.
  ///
  /// In en, this message translates to:
  /// **'You can switch at any time in Settings.'**
  String get setup_interface_switch_later;

  /// No description provided for @ng_confirm_model_switch.
  ///
  /// In en, this message translates to:
  /// **'Switch model?'**
  String get ng_confirm_model_switch;

  /// No description provided for @ng_switch.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get ng_switch;

  /// No description provided for @ng_model_confirmation_required.
  ///
  /// In en, this message translates to:
  /// **'This model needs confirmation before it can be selected.'**
  String get ng_model_confirmation_required;

  /// No description provided for @ng_model_switches_next_turn.
  ///
  /// In en, this message translates to:
  /// **'Switches to {model} at the next turn.'**
  String ng_model_switches_next_turn(String model);

  /// No description provided for @ng_model_switch_not_connected.
  ///
  /// In en, this message translates to:
  /// **'The chat is not ready for a model switch. Reopen it and try again.'**
  String get ng_model_switch_not_connected;

  /// No description provided for @ng_gateway_kept_default_model.
  ///
  /// In en, this message translates to:
  /// **'The gateway kept {model} for this chat. Pick the model again before sending.'**
  String ng_gateway_kept_default_model(String model);

  /// No description provided for @hands_free_title.
  ///
  /// In en, this message translates to:
  /// **'Hands-free'**
  String get hands_free_title;

  /// No description provided for @hands_free_start.
  ///
  /// In en, this message translates to:
  /// **'Start hands-free'**
  String get hands_free_start;

  /// No description provided for @hands_free_stop.
  ///
  /// In en, this message translates to:
  /// **'Stop hands-free'**
  String get hands_free_stop;

  /// No description provided for @hands_free_preparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing voice — wait for ready'**
  String get hands_free_preparing;

  /// No description provided for @hands_free_listening.
  ///
  /// In en, this message translates to:
  /// **'Say Hey Hermes'**
  String get hands_free_listening;

  /// No description provided for @hands_free_recording.
  ///
  /// In en, this message translates to:
  /// **'Ready — speak now'**
  String get hands_free_recording;

  /// No description provided for @hands_free_waiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Hermes'**
  String get hands_free_waiting;

  /// No description provided for @hands_free_speaking.
  ///
  /// In en, this message translates to:
  /// **'Speaking — microphone off'**
  String get hands_free_speaking;

  /// No description provided for @hands_free_followup.
  ///
  /// In en, this message translates to:
  /// **'Listen up to {seconds} seconds'**
  String hands_free_followup(int seconds);

  /// No description provided for @hands_free_error.
  ///
  /// In en, this message translates to:
  /// **'Hands-free stopped'**
  String get hands_free_error;

  /// No description provided for @hands_free_setup.
  ///
  /// In en, this message translates to:
  /// **'Hands-free setup'**
  String get hands_free_setup;

  /// No description provided for @hands_free_preview.
  ///
  /// In en, this message translates to:
  /// **'Voice preview: {transcript}'**
  String hands_free_preview(String transcript);

  /// No description provided for @hands_free_short_disclosure.
  ///
  /// In en, this message translates to:
  /// **'Only while this chat is open in the foreground. Wake is offline; speech may use networks. Uses battery.'**
  String get hands_free_short_disclosure;

  /// No description provided for @hands_free_error_action.
  ///
  /// In en, this message translates to:
  /// **'Check microphone permission, speech service, reply voice and connection, then press Stop and Start to retry. Nothing is resent.'**
  String get hands_free_error_action;

  /// No description provided for @hands_free_disclosure.
  ///
  /// In en, this message translates to:
  /// **'Wake detection runs offline on the CPU. Android speech recognition, the selected reply voice and gateway may use networks. Listening uses battery and false activations are possible. Stops when this chat is covered, closed or no longer foreground; reopening never restarts it. Manual dictation stays an editable draft.'**
  String get hands_free_disclosure;

  /// No description provided for @hands_free_ready_cue.
  ///
  /// In en, this message translates to:
  /// **'Say “Hey Hermes”, wait for “Ready — speak now”, then speak. No same-breath capture or pre-roll. If permission setup leaves the app, press Start again after granting it.'**
  String get hands_free_ready_cue;

  /// No description provided for @hands_free_settings_title.
  ///
  /// In en, this message translates to:
  /// **'Hands-free voice'**
  String get hands_free_settings_title;

  /// No description provided for @hands_free_settings_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Show the “Hey Hermes” start control in chats. Turning it off stops any running hands-free session.'**
  String get hands_free_settings_subtitle;

  /// No description provided for @hands_free_timing_limit.
  ///
  /// In en, this message translates to:
  /// **'The follow-up window is a maximum, not a minimum. Android may stop earlier. Silence returns to local wake listening without repeated recognition restarts.'**
  String get hands_free_timing_limit;

  /// No description provided for @hands_free_followup_off.
  ///
  /// In en, this message translates to:
  /// **'Follow-up off — say Hey Hermes for each prompt'**
  String get hands_free_followup_off;

  /// No description provided for @hands_free_start_blocked.
  ///
  /// In en, this message translates to:
  /// **'Start requires an empty draft, no attachments, an idle connected chat and spoken replies enabled. Finish any manual voice action first.'**
  String get hands_free_start_blocked;

  /// No description provided for @hands_free_setup_complete.
  ///
  /// In en, this message translates to:
  /// **'Microphone setup finished. Press Start again.'**
  String get hands_free_setup_complete;

  /// No description provided for @message_time_recorded.
  ///
  /// In en, this message translates to:
  /// **'Recorded by server: {time} (local time)'**
  String message_time_recorded(String time);

  /// No description provided for @message_time_sent.
  ///
  /// In en, this message translates to:
  /// **'Send observed on this device: {time} (local time)'**
  String message_time_sent(String time);

  /// No description provided for @message_time_received.
  ///
  /// In en, this message translates to:
  /// **'First received on this device: {time} (local time)'**
  String message_time_received(String time);

  /// No description provided for @stop_and_send.
  ///
  /// In en, this message translates to:
  /// **'Stop and send'**
  String get stop_and_send;

  /// No description provided for @message_queued_for_running_turn.
  ///
  /// In en, this message translates to:
  /// **'Message queued for the current run.'**
  String get message_queued_for_running_turn;

  /// No description provided for @running_message_not_accepted.
  ///
  /// In en, this message translates to:
  /// **'Hermes could not accept this message. Your draft was kept; stop the response or wait, then send again.'**
  String get running_message_not_accepted;

  /// No description provided for @running_message_delivery_unknown.
  ///
  /// In en, this message translates to:
  /// **'Message delivery could not be confirmed. Your draft was kept. Check the chat before retrying.'**
  String get running_message_delivery_unknown;

  /// No description provided for @attachment_tap_to_preview.
  ///
  /// In en, this message translates to:
  /// **'Tap to preview'**
  String get attachment_tap_to_preview;

  /// No description provided for @attachment_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get attachment_save;

  /// No description provided for @attachment_share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get attachment_share;

  /// No description provided for @attachment_saved.
  ///
  /// In en, this message translates to:
  /// **'File saved'**
  String get attachment_saved;

  /// No description provided for @attachment_save_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Save cancelled'**
  String get attachment_save_cancelled;

  /// No description provided for @attachment_save_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not save this file. Please try again.'**
  String get attachment_save_failed;

  /// No description provided for @attachment_share_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not share this file. Please try again.'**
  String get attachment_share_failed;

  /// No description provided for @attachment_download_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not load this file. Check the connection and try again.'**
  String get attachment_download_failed;

  /// No description provided for @attachment_no_inline_preview.
  ///
  /// In en, this message translates to:
  /// **'No inline preview is available for this file type. Save or share the original file to open it in another app.'**
  String get attachment_no_inline_preview;

  /// No description provided for @attachment_image_failed.
  ///
  /// In en, this message translates to:
  /// **'This image could not be decoded. You can still save or share the original file.'**
  String get attachment_image_failed;

  /// No description provided for @attachment_text_truncated.
  ///
  /// In en, this message translates to:
  /// **'Preview shortened. Save or share the file to read all of it.'**
  String get attachment_text_truncated;

  /// No description provided for @attachment_text_unavailable.
  ///
  /// In en, this message translates to:
  /// **'This file could not be displayed as text. Save or share the original file.'**
  String get attachment_text_unavailable;

  /// No description provided for @attachment_pdf_failed.
  ///
  /// In en, this message translates to:
  /// **'This PDF could not be previewed. Save or share the original file.'**
  String get attachment_pdf_failed;

  /// No description provided for @attachment_pdf_unavailable.
  ///
  /// In en, this message translates to:
  /// **'PDF previews are available on Android. You can still save or share this file.'**
  String get attachment_pdf_unavailable;

  /// No description provided for @attachment_pdf_page.
  ///
  /// In en, this message translates to:
  /// **'Page {page} of {total}'**
  String attachment_pdf_page(int page, int total);

  /// No description provided for @attachment_previous_page.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get attachment_previous_page;

  /// No description provided for @attachment_next_page.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get attachment_next_page;

  /// No description provided for @attachment_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading preview…'**
  String get attachment_loading;

  /// No description provided for @attachment_document_text_notice.
  ///
  /// In en, this message translates to:
  /// **'Text preview. Layout, images and formatting may differ from the original.'**
  String get attachment_document_text_notice;

  /// No description provided for @attachment_document_failed.
  ///
  /// In en, this message translates to:
  /// **'This document could not be previewed. Save or share the original file.'**
  String get attachment_document_failed;

  /// No description provided for @attachment_document_empty.
  ///
  /// In en, this message translates to:
  /// **'No readable text was found in this document.'**
  String get attachment_document_empty;

  /// No description provided for @attachment_video_failed.
  ///
  /// In en, this message translates to:
  /// **'This video could not be played. Its format or codec may not be supported. Save or share the original file.'**
  String get attachment_video_failed;

  /// No description provided for @attachment_video_play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get attachment_video_play;

  /// No description provided for @attachment_video_pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get attachment_video_pause;

  /// No description provided for @attachment_video_mute.
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get attachment_video_mute;

  /// No description provided for @attachment_video_unmute.
  ///
  /// In en, this message translates to:
  /// **'Unmute'**
  String get attachment_video_unmute;

  /// No description provided for @attachment_video_seek.
  ///
  /// In en, this message translates to:
  /// **'Video position'**
  String get attachment_video_seek;

  /// No description provided for @attachment_close.
  ///
  /// In en, this message translates to:
  /// **'Close preview'**
  String get attachment_close;

  /// No description provided for @attachment_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get attachment_retry;

  /// No description provided for @saved_history_heading.
  ///
  /// In en, this message translates to:
  /// **'Saved history'**
  String get saved_history_heading;

  /// No description provided for @received_output_heading.
  ///
  /// In en, this message translates to:
  /// **'Received output — match to saved history unconfirmed'**
  String get received_output_heading;

  /// No description provided for @received_output_details.
  ///
  /// In en, this message translates to:
  /// **'About received output'**
  String get received_output_details;

  /// No description provided for @received_output_explanation.
  ///
  /// In en, this message translates to:
  /// **'This may also appear in saved history. The app cannot confirm a match.'**
  String get received_output_explanation;

  /// No description provided for @local_prompt_context.
  ///
  /// In en, this message translates to:
  /// **'Local prompt context'**
  String get local_prompt_context;

  /// No description provided for @received_output_badge.
  ///
  /// In en, this message translates to:
  /// **'Received · match unconfirmed'**
  String get received_output_badge;

  /// No description provided for @received_output_lifetime.
  ///
  /// In en, this message translates to:
  /// **'Received output is kept temporarily in this app session and may be shortened or removed as limits are reached. It may not be available after the app or connection is closed.'**
  String get received_output_lifetime;

  /// No description provided for @theme_palette.
  ///
  /// In en, this message translates to:
  /// **'Colour theme'**
  String get theme_palette;

  /// No description provided for @theme_palette_gold.
  ///
  /// In en, this message translates to:
  /// **'Gold'**
  String get theme_palette_gold;

  /// No description provided for @theme_palette_purple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get theme_palette_purple;

  /// No description provided for @theme_palette_orange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get theme_palette_orange;

  /// No description provided for @theme_palette_green.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get theme_palette_green;

  /// No description provided for @theme_palette_blue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get theme_palette_blue;

  /// No description provided for @theme_palette_red.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get theme_palette_red;

  /// No description provided for @theme_palette_teal.
  ///
  /// In en, this message translates to:
  /// **'Teal'**
  String get theme_palette_teal;

  /// No description provided for @theme_palette_pink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get theme_palette_pink;

  /// No description provided for @theme_palette_indigo.
  ///
  /// In en, this message translates to:
  /// **'Indigo'**
  String get theme_palette_indigo;

  /// No description provided for @theme_palette_cyan.
  ///
  /// In en, this message translates to:
  /// **'Cyan'**
  String get theme_palette_cyan;

  /// No description provided for @assets_recent_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Find files shared by Hermes in saved chats'**
  String get assets_recent_subtitle;

  /// No description provided for @assets_scope_notice.
  ///
  /// In en, this message translates to:
  /// **'Generated files explicitly shared by Hermes in saved replies. This is a partial view of chat history, not a complete file or attachment catalogue. Referenced files may no longer exist.'**
  String get assets_scope_notice;

  /// No description provided for @assets_download_limit.
  ///
  /// In en, this message translates to:
  /// **'Files are loaded only when tapped. Previews and downloads are limited to 25 MiB each; use the dashboard for larger files.'**
  String get assets_download_limit;

  /// No description provided for @assets_search_hint.
  ///
  /// In en, this message translates to:
  /// **'Search found files or source chats'**
  String get assets_search_hint;

  /// No description provided for @assets_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get assets_all;

  /// No description provided for @assets_images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get assets_images;

  /// No description provided for @assets_audio.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get assets_audio;

  /// No description provided for @assets_video.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get assets_video;

  /// No description provided for @assets_documents.
  ///
  /// In en, this message translates to:
  /// **'Documents and other files'**
  String get assets_documents;

  /// No description provided for @assets_empty.
  ///
  /// In en, this message translates to:
  /// **'No assets found in scanned messages'**
  String get assets_empty;

  /// No description provided for @assets_empty_detail.
  ///
  /// In en, this message translates to:
  /// **'Scan more chats or older messages to look further back. Ordinary attachments and unlinked files are not indexed here.'**
  String get assets_empty_detail;

  /// No description provided for @assets_no_matches.
  ///
  /// In en, this message translates to:
  /// **'No matching assets'**
  String get assets_no_matches;

  /// No description provided for @assets_load_more_chats.
  ///
  /// In en, this message translates to:
  /// **'Scan more chats'**
  String get assets_load_more_chats;

  /// No description provided for @assets_load_older_messages.
  ///
  /// In en, this message translates to:
  /// **'Scan older messages'**
  String get assets_load_older_messages;

  /// No description provided for @assets_load_failed.
  ///
  /// In en, this message translates to:
  /// **'Some history could not be read. Results are incomplete. Check the dashboard connection and retry.'**
  String get assets_load_failed;

  /// No description provided for @assets_retry_failed.
  ///
  /// In en, this message translates to:
  /// **'Retry failed history reads'**
  String get assets_retry_failed;

  /// No description provided for @assets_partial.
  ///
  /// In en, this message translates to:
  /// **'The server reported incomplete history. Refresh after checking the dashboard.'**
  String get assets_partial;

  /// No description provided for @assets_scan_summary.
  ///
  /// In en, this message translates to:
  /// **'{files} file references found across {chats} scanned chats'**
  String assets_scan_summary(int files, int chats);

  /// No description provided for @assets_open_chat.
  ///
  /// In en, this message translates to:
  /// **'Open chat: {title}'**
  String assets_open_chat(String title);

  /// No description provided for @assets_file_too_large.
  ///
  /// In en, this message translates to:
  /// **'This file exceeds the download limit. Open the dashboard to download it.'**
  String get assets_file_too_large;

  /// No description provided for @a_one_off_question_archives_itself_after_72_hours_anything.
  ///
  /// In en, this message translates to:
  /// **'A one-off question. Archives itself after 72 hours; anything worth keeping is still remembered.'**
  String get a_one_off_question_archives_itself_after_72_hours_anything;

  /// No description provided for @archive_chat.
  ///
  /// In en, this message translates to:
  /// **'Archive chat'**
  String get archive_chat;

  /// No description provided for @unarchive_chat.
  ///
  /// In en, this message translates to:
  /// **'Unarchive chat'**
  String get unarchive_chat;

  /// No description provided for @chat_archived.
  ///
  /// In en, this message translates to:
  /// **'Chat archived'**
  String get chat_archived;

  /// No description provided for @chat_unarchived.
  ///
  /// In en, this message translates to:
  /// **'Chat unarchived'**
  String get chat_unarchived;

  /// No description provided for @could_not_update_chat_archive.
  ///
  /// In en, this message translates to:
  /// **'Could not update chat archive: {error}'**
  String could_not_update_chat_archive(Object error);

  /// No description provided for @quick_chat_description.
  ///
  /// In en, this message translates to:
  /// **'A one-off question.'**
  String get quick_chat_description;

  /// No description provided for @ai_full_text.
  ///
  /// In en, this message translates to:
  /// **'AI + full-text'**
  String get ai_full_text;

  /// No description provided for @ai_search_model.
  ///
  /// In en, this message translates to:
  /// **'AI search model'**
  String get ai_search_model;

  /// No description provided for @ai_searched_for.
  ///
  /// In en, this message translates to:
  /// **'AI searched for: {aiRewrittenQuery}'**
  String ai_searched_for(Object aiRewrittenQuery);

  /// No description provided for @ai_assisted_filing.
  ///
  /// In en, this message translates to:
  /// **'AI-assisted filing'**
  String get ai_assisted_filing;

  /// No description provided for @api_key.
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get api_key;

  /// No description provided for @api_server_key_from_hermes_env.
  ///
  /// In en, this message translates to:
  /// **'API_SERVER_KEY from ~/.hermes/.env'**
  String get api_server_key_from_hermes_env;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get activity;

  /// No description provided for @activity_reads_the_durable_turn_journal_to_know_what_hermes.
  ///
  /// In en, this message translates to:
  /// **'Activity reads the durable turn journal to know what Hermes is doing. Check that the gateway is reachable, then try again.'**
  String get activity_reads_the_durable_turn_journal_to_know_what_hermes;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @add_connection.
  ///
  /// In en, this message translates to:
  /// **'Add Connection'**
  String get add_connection;

  /// No description provided for @add_cron_job.
  ///
  /// In en, this message translates to:
  /// **'Add Cron Job'**
  String get add_cron_job;

  /// No description provided for @add_gateway_connection.
  ///
  /// In en, this message translates to:
  /// **'Add Gateway Connection'**
  String get add_gateway_connection;

  /// No description provided for @add_and_update_connections_from_the_backup_keep_the_rest.
  ///
  /// In en, this message translates to:
  /// **'Add and update connections from the backup, keep the rest.'**
  String get add_and_update_connections_from_the_backup_keep_the_rest;

  /// No description provided for @add_attachment.
  ///
  /// In en, this message translates to:
  /// **'Add attachment'**
  String get add_attachment;

  /// No description provided for @add_new_cron_job.
  ///
  /// In en, this message translates to:
  /// **'Add new cron job'**
  String get add_new_cron_job;

  /// No description provided for @add_to_chat.
  ///
  /// In en, this message translates to:
  /// **'Add to chat'**
  String get add_to_chat;

  /// No description provided for @all_chats.
  ///
  /// In en, this message translates to:
  /// **'All chats'**
  String get all_chats;

  /// No description provided for @all_stored_message_content.
  ///
  /// In en, this message translates to:
  /// **'All stored message content'**
  String get all_stored_message_content;

  /// No description provided for @allow_for_this_session.
  ///
  /// In en, this message translates to:
  /// **'Allow for this session'**
  String get allow_for_this_session;

  /// No description provided for @allow_matching_commands_until_this_hermes_session_ends.
  ///
  /// In en, this message translates to:
  /// **'Allow matching commands until this Hermes session ends.'**
  String get allow_matching_commands_until_this_hermes_session_ends;

  /// No description provided for @allow_folder_until_sandbox_off.
  ///
  /// In en, this message translates to:
  /// **'Allow this folder until the sandbox is switched off.'**
  String get allow_folder_until_sandbox_off;

  /// No description provided for @allow_once.
  ///
  /// In en, this message translates to:
  /// **'Allow once'**
  String get allow_once;

  /// No description provided for @allow_website_until_sandbox_off.
  ///
  /// In en, this message translates to:
  /// **'Allow this website until the sandbox is switched off.'**
  String get allow_website_until_sandbox_off;

  /// No description provided for @always_allow.
  ///
  /// In en, this message translates to:
  /// **'Always allow'**
  String get always_allow;

  /// No description provided for @apply_to_this_chat.
  ///
  /// In en, this message translates to:
  /// **'Apply to this chat'**
  String get apply_to_this_chat;

  /// No description provided for @approval_needed.
  ///
  /// In en, this message translates to:
  /// **'Approval needed'**
  String get approval_needed;

  /// No description provided for @approval_needed_description.
  ///
  /// In en, this message translates to:
  /// **'A command is waiting for your approval or denial.'**
  String get approval_needed_description;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @archive_project.
  ///
  /// In en, this message translates to:
  /// **'Archive project'**
  String get archive_project;

  /// No description provided for @archive_2.
  ///
  /// In en, this message translates to:
  /// **'Archive {projectName}?'**
  String archive_2(Object projectName);

  /// No description provided for @archive_3.
  ///
  /// In en, this message translates to:
  /// **'Archive {name}?'**
  String archive_3(Object name);

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @archived_conversations_appear_here.
  ///
  /// In en, this message translates to:
  /// **'Only archived conversations appear here. Older chats remain in All chats.'**
  String get archived_conversations_appear_here;

  /// No description provided for @archived_quick_chats.
  ///
  /// In en, this message translates to:
  /// **'Archived quick chats'**
  String get archived_quick_chats;

  /// No description provided for @artifacts_attachments_and_generated_media.
  ///
  /// In en, this message translates to:
  /// **'Artifacts, attachments, and generated media'**
  String get artifacts_attachments_and_generated_media;

  /// No description provided for @ask_ai_to_find_a_conversation.
  ///
  /// In en, this message translates to:
  /// **'Ask AI to find a conversation'**
  String get ask_ai_to_find_a_conversation;

  /// No description provided for @assets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get assets;

  /// No description provided for @assets_need_a_server_authoritative_assets_index_in_the_hermes.
  ///
  /// In en, this message translates to:
  /// **'Assets need a server-authoritative Assets index in the Hermes Gateway before they can be shown per project.'**
  String get assets_need_a_server_authoritative_assets_index_in_the_hermes;

  /// No description provided for @assets_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Assets unavailable'**
  String get assets_unavailable;

  /// No description provided for @attach_image_or_file.
  ///
  /// In en, this message translates to:
  /// **'Attach image or file'**
  String get attach_image_or_file;

  /// No description provided for @attachment_drafts.
  ///
  /// In en, this message translates to:
  /// **'Attachment drafts'**
  String get attachment_drafts;

  /// No description provided for @recover_text_draft.
  ///
  /// In en, this message translates to:
  /// **'Recover a text draft'**
  String get recover_text_draft;

  /// No description provided for @undo_draft_recovery.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo_draft_recovery;

  /// No description provided for @draft_session_exists.
  ///
  /// In en, this message translates to:
  /// **'This chat still exists. Open it to continue your draft.'**
  String get draft_session_exists;

  /// No description provided for @draft_recovery_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not verify this draft. Nothing was changed.'**
  String get draft_recovery_unavailable;

  /// No description provided for @attachment_of.
  ///
  /// In en, this message translates to:
  /// **'Attachment {index} of {total}'**
  String attachment_of(Object index, Object total);

  /// No description provided for @auto_device_default.
  ///
  /// In en, this message translates to:
  /// **'Auto (device default)'**
  String get auto_device_default;

  /// More menu section containing Cron, Skills and Memory.
  ///
  /// In en, this message translates to:
  /// **'Agent'**
  String get agent;

  /// No description provided for @autonomous_agents.
  ///
  /// In en, this message translates to:
  /// **'Autonomous agents'**
  String get autonomous_agents;

  /// No description provided for @background_recovery_unavailable_legacy_transport.
  ///
  /// In en, this message translates to:
  /// **'Background recovery unavailable — legacy transport'**
  String get background_recovery_unavailable_legacy_transport;

  /// No description provided for @background_task_completed.
  ///
  /// In en, this message translates to:
  /// **'Background task complete'**
  String get background_task_completed;

  /// No description provided for @background_task_completed_description.
  ///
  /// In en, this message translates to:
  /// **'A background terminal command finished.'**
  String get background_task_completed_description;

  /// No description provided for @backup_restore.
  ///
  /// In en, this message translates to:
  /// **'Backup & restore'**
  String get backup_restore;

  /// No description provided for @backup_exported.
  ///
  /// In en, this message translates to:
  /// **'Backup exported — {destination}'**
  String backup_exported(Object destination);

  /// No description provided for @base_url.
  ///
  /// In en, this message translates to:
  /// **'Base URL'**
  String get base_url;

  /// No description provided for @binary_preview_is_unavailable_download_the_file_to_open_it.
  ///
  /// In en, this message translates to:
  /// **'Binary preview is unavailable. Download the file to open it.'**
  String get binary_preview_is_unavailable_download_the_file_to_open_it;

  /// No description provided for @branch.
  ///
  /// In en, this message translates to:
  /// **'Branch'**
  String get branch;

  /// No description provided for @branch_chat.
  ///
  /// In en, this message translates to:
  /// **'Branch chat'**
  String get branch_chat;

  /// No description provided for @branch_created_in_hermes_history.
  ///
  /// In en, this message translates to:
  /// **'Branch created in Hermes history.'**
  String get branch_created_in_hermes_history;

  /// No description provided for @browse_and_manage_your_hermes_agent_sessions_from_your_phone.
  ///
  /// In en, this message translates to:
  /// **'Browse and manage your Hermes Agent sessions from your phone. Connects to a Hermes dashboard running on your local network.'**
  String get browse_and_manage_your_hermes_agent_sessions_from_your_phone;

  /// No description provided for @browse_server_files.
  ///
  /// In en, this message translates to:
  /// **'Browse server files'**
  String get browse_server_files;

  /// No description provided for @browse_the_miniserver_folders_behind_your_projects.
  ///
  /// In en, this message translates to:
  /// **'Browse the miniserver folders behind your projects'**
  String get browse_the_miniserver_folders_behind_your_projects;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @cancel_voice_input.
  ///
  /// In en, this message translates to:
  /// **'Cancel voice input'**
  String get cancel_voice_input;

  /// No description provided for @cannot_reach.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach {host}:{port}.'**
  String cannot_reach(Object host, Object port);

  /// No description provided for @cannot_reach_check_the_host_and_port.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach {host}:{port}. Check the host and port.'**
  String cannot_reach_check_the_host_and_port(Object host, Object port);

  /// No description provided for @change_ai_search_model.
  ///
  /// In en, this message translates to:
  /// **'Change AI search model'**
  String get change_ai_search_model;

  /// No description provided for @changes_the_default_for_use_the_selector_in_a_chat.
  ///
  /// In en, this message translates to:
  /// **'Changes the default for {label}. Use the selector in a chat to override only that conversation.'**
  String changes_the_default_for_use_the_selector_in_a_chat(Object label);

  /// No description provided for @chat_actions.
  ///
  /// In en, this message translates to:
  /// **'Chat actions'**
  String get chat_actions;

  /// No description provided for @chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get chats;

  /// No description provided for @chats_from_this_gateway_are_not_grouped_yet_grouping_stays.
  ///
  /// In en, this message translates to:
  /// **'Chats from this gateway are not grouped yet. Grouping stays on this phone until the gateway can host projects.'**
  String get chats_from_this_gateway_are_not_grouped_yet_grouping_stays;

  /// No description provided for @chats_in_this_project_will_show_their_state_and_last.
  ///
  /// In en, this message translates to:
  /// **'Chats in this project will show their state and last activity here.'**
  String get chats_in_this_project_will_show_their_state_and_last;

  /// No description provided for @chats_that_are_not_assigned_to_a_project.
  ///
  /// In en, this message translates to:
  /// **'Chats that are not assigned to a Project'**
  String get chats_that_are_not_assigned_to_a_project;

  /// No description provided for @chats_you_start_in_this_project_will_appear_here_on.
  ///
  /// In en, this message translates to:
  /// **'Chats you start in this project will appear here, on every device signed in to this Hermes.'**
  String get chats_you_start_in_this_project_will_appear_here_on;

  /// No description provided for @check_that_the_gateway_is_running_and_reachable_then_try.
  ///
  /// In en, this message translates to:
  /// **'Check that the gateway is running and reachable, then try again.'**
  String get check_that_the_gateway_is_running_and_reachable_then_try;

  /// No description provided for @check_the_dashboard_connection_and_try_again.
  ///
  /// In en, this message translates to:
  /// **'Check the Dashboard connection and try again.'**
  String get check_the_dashboard_connection_and_try_again;

  /// No description provided for @check_the_connection_and_try_again.
  ///
  /// In en, this message translates to:
  /// **'Check the connection and try again.'**
  String get check_the_connection_and_try_again;

  /// No description provided for @choose_a_small_model_to_rewrite_queries.
  ///
  /// In en, this message translates to:
  /// **'Choose a small model to rewrite queries'**
  String get choose_a_small_model_to_rewrite_queries;

  /// No description provided for @choose_an_ai_search_model_before_using_ai_search.
  ///
  /// In en, this message translates to:
  /// **'Choose an AI search model before using AI search.'**
  String get choose_an_ai_search_model_before_using_ai_search;

  /// No description provided for @choose_an_active_project_next.
  ///
  /// In en, this message translates to:
  /// **'Choose an active Project next'**
  String get choose_an_active_project_next;

  /// No description provided for @choose_chat_model.
  ///
  /// In en, this message translates to:
  /// **'Choose chat model'**
  String get choose_chat_model;

  /// No description provided for @choose_files.
  ///
  /// In en, this message translates to:
  /// **'Choose files'**
  String get choose_files;

  /// No description provided for @choose_image.
  ///
  /// In en, this message translates to:
  /// **'Choose image'**
  String get choose_image;

  /// No description provided for @choose_images.
  ///
  /// In en, this message translates to:
  /// **'Choose images'**
  String get choose_images;

  /// No description provided for @choose_its_destination_space.
  ///
  /// In en, this message translates to:
  /// **'Choose its destination space'**
  String get choose_its_destination_space;

  /// No description provided for @clear_search.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clear_search;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @code_copied.
  ///
  /// In en, this message translates to:
  /// **'Code copied'**
  String get code_copied;

  /// No description provided for @code_format.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code_format;

  /// No description provided for @coming_next.
  ///
  /// In en, this message translates to:
  /// **'Coming next'**
  String get coming_next;

  /// No description provided for @command.
  ///
  /// In en, this message translates to:
  /// **'Command'**
  String get command;

  /// No description provided for @command_palette.
  ///
  /// In en, this message translates to:
  /// **'Command palette'**
  String get command_palette;

  /// No description provided for @command_palette_hint.
  ///
  /// In en, this message translates to:
  /// **'Type a command'**
  String get command_palette_hint;

  /// No description provided for @command_palette_no_results.
  ///
  /// In en, this message translates to:
  /// **'No commands found'**
  String get command_palette_no_results;

  /// No description provided for @command_palette_new_chat.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get command_palette_new_chat;

  /// No description provided for @command_palette_search_chats.
  ///
  /// In en, this message translates to:
  /// **'Search chats'**
  String get command_palette_search_chats;

  /// No description provided for @command_palette_toggle_theme.
  ///
  /// In en, this message translates to:
  /// **'Toggle theme'**
  String get command_palette_toggle_theme;

  /// No description provided for @command_palette_copy_last_code.
  ///
  /// In en, this message translates to:
  /// **'Copy last code block'**
  String get command_palette_copy_last_code;

  /// No description provided for @command_line_chats.
  ///
  /// In en, this message translates to:
  /// **'Command-line chats'**
  String get command_line_chats;

  /// No description provided for @compatibility_mode.
  ///
  /// In en, this message translates to:
  /// **'Compatibility mode'**
  String get compatibility_mode;

  /// No description provided for @configure_a_valid_desktop_gateway_url_before_attaching_files.
  ///
  /// In en, this message translates to:
  /// **'Configure a valid Desktop Gateway URL before attaching files.'**
  String get configure_a_valid_desktop_gateway_url_before_attaching_files;

  /// No description provided for @confirm_always_allow.
  ///
  /// In en, this message translates to:
  /// **'Confirm always allow'**
  String get confirm_always_allow;

  /// No description provided for @confirm_passphrase.
  ///
  /// In en, this message translates to:
  /// **'Confirm passphrase'**
  String get confirm_passphrase;

  /// No description provided for @connecting_to.
  ///
  /// In en, this message translates to:
  /// **'Connecting to {baseUrl}...'**
  String connecting_to(Object baseUrl);

  /// No description provided for @connection_issue.
  ///
  /// In en, this message translates to:
  /// **'Connection issue'**
  String get connection_issue;

  /// No description provided for @connection_switched_the_running_reply_continues_on_the_server_and.
  ///
  /// In en, this message translates to:
  /// **'Connection switched — the running reply continues on the server and will reattach automatically.'**
  String get connection_switched_the_running_reply_continues_on_the_server_and;

  /// No description provided for @connection_appearance_and_device_preferences.
  ///
  /// In en, this message translates to:
  /// **'Connection, appearance, and device preferences'**
  String get connection_appearance_and_device_preferences;

  /// No description provided for @context_tokens.
  ///
  /// In en, this message translates to:
  /// **'Context: {effectiveContextLength} tokens'**
  String context_tokens(Object effectiveContextLength);

  /// No description provided for @continue_label.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_label;

  /// No description provided for @continue_working.
  ///
  /// In en, this message translates to:
  /// **'Continue working'**
  String get continue_working;

  /// No description provided for @conversations_in_this_project.
  ///
  /// In en, this message translates to:
  /// **'Conversations in this project'**
  String get conversations_in_this_project;

  /// No description provided for @copy_code.
  ///
  /// In en, this message translates to:
  /// **'Copy code'**
  String get copy_code;

  /// No description provided for @copy_message.
  ///
  /// In en, this message translates to:
  /// **'Copy message'**
  String get copy_message;

  /// No description provided for @could_not_branch_chat.
  ///
  /// In en, this message translates to:
  /// **'Could not branch chat: {error}'**
  String could_not_branch_chat(Object error);

  /// No description provided for @could_not_delete_session.
  ///
  /// In en, this message translates to:
  /// **'Could not delete session: {error}'**
  String could_not_delete_session(Object error);

  /// No description provided for @could_not_deny_the_command.
  ///
  /// In en, this message translates to:
  /// **'Could not deny the command: {error}'**
  String could_not_deny_the_command(Object error);

  /// No description provided for @could_not_load_ai_search_models.
  ///
  /// In en, this message translates to:
  /// **'Could not load AI search models: {error}'**
  String could_not_load_ai_search_models(Object error);

  /// No description provided for @could_not_load_conversations.
  ///
  /// In en, this message translates to:
  /// **'Could not load conversations'**
  String get could_not_load_conversations;

  /// No description provided for @could_not_load_files.
  ///
  /// In en, this message translates to:
  /// **'Could not load files'**
  String get could_not_load_files;

  /// No description provided for @could_not_load_models_for_this_profile.
  ///
  /// In en, this message translates to:
  /// **'Could not load models for this profile: {error}'**
  String could_not_load_models_for_this_profile(Object error);

  /// No description provided for @could_not_load_more_chats.
  ///
  /// In en, this message translates to:
  /// **'Could not load more chats: {error}'**
  String could_not_load_more_chats(Object error);

  /// No description provided for @could_not_open_link.
  ///
  /// In en, this message translates to:
  /// **'Could not open this link.'**
  String get could_not_open_link;

  /// No description provided for @could_not_open_the_hermes_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Could not open the Hermes dashboard.'**
  String get could_not_open_the_hermes_dashboard;

  /// No description provided for @could_not_open_this_project.
  ///
  /// In en, this message translates to:
  /// **'Could not open this project'**
  String get could_not_open_this_project;

  /// No description provided for @could_not_preview_file.
  ///
  /// In en, this message translates to:
  /// **'Could not preview file'**
  String get could_not_preview_file;

  /// No description provided for @could_not_reach_hermes.
  ///
  /// In en, this message translates to:
  /// **'Could not reach Hermes'**
  String get could_not_reach_hermes;

  /// No description provided for @could_not_reach_authenticate_the_dashboard_at_check_the_port.
  ///
  /// In en, this message translates to:
  /// **'Could not reach/authenticate the dashboard at {host}:{dashboardPort}. Check the port and credentials.'**
  String could_not_reach_authenticate_the_dashboard_at_check_the_port(
    Object dashboardPort,
    Object host,
  );

  /// No description provided for @could_not_read_activity.
  ///
  /// In en, this message translates to:
  /// **'Could not read activity'**
  String get could_not_read_activity;

  /// No description provided for @could_not_rename_chat.
  ///
  /// In en, this message translates to:
  /// **'Could not rename chat: {error}'**
  String could_not_rename_chat(Object error);

  /// No description provided for @could_not_send_the_approval.
  ///
  /// In en, this message translates to:
  /// **'Could not send the approval: {error}'**
  String could_not_send_the_approval(Object error);

  /// No description provided for @could_not_skip_the_hermes_question.
  ///
  /// In en, this message translates to:
  /// **'Could not skip the Hermes question.'**
  String get could_not_skip_the_hermes_question;

  /// No description provided for @could_not_the_project.
  ///
  /// In en, this message translates to:
  /// **'Could not {action} the project: {error}'**
  String could_not_the_project(Object action, Object error);

  /// No description provided for @couldn_t_delete_project.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t delete project'**
  String get couldn_t_delete_project;

  /// No description provided for @couldn_t_load_runs.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t load runs: {error}'**
  String couldn_t_load_runs(Object error);

  /// No description provided for @couldn_t_move_conversation.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t move conversation'**
  String get couldn_t_move_conversation;

  /// No description provided for @couldn_t_move_to.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t move to {label}: {reason}'**
  String couldn_t_move_to(Object label, Object reason);

  /// No description provided for @couldn_t_prepare_the_shared_files.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t prepare the shared files.'**
  String get couldn_t_prepare_the_shared_files;

  /// No description provided for @couldn_t_promote_conversation.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t promote conversation'**
  String get couldn_t_promote_conversation;

  /// No description provided for @couldn_t_project.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t {action} project'**
  String couldn_t_project(Object action);

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @create_a_project.
  ///
  /// In en, this message translates to:
  /// **'Create a project'**
  String get create_a_project;

  /// No description provided for @create_a_project_first_then_chats_can_live_inside_it.
  ///
  /// In en, this message translates to:
  /// **'Create a project first, then chats can live inside it.'**
  String get create_a_project_first_then_chats_can_live_inside_it;

  /// No description provided for @create_a_space_to_separate_related_conversations.
  ///
  /// In en, this message translates to:
  /// **'Create a space to separate related conversations.'**
  String get create_a_space_to_separate_related_conversations;

  /// No description provided for @create_branch.
  ///
  /// In en, this message translates to:
  /// **'Create branch'**
  String get create_branch;

  /// No description provided for @credit_notifications.
  ///
  /// In en, this message translates to:
  /// **'Credit notifications'**
  String get credit_notifications;

  /// No description provided for @credit_notifications_description.
  ///
  /// In en, this message translates to:
  /// **'Credit usage was stopped or restored.'**
  String get credit_notifications_description;

  /// No description provided for @cron.
  ///
  /// In en, this message translates to:
  /// **'Cron'**
  String get cron;

  /// No description provided for @crons.
  ///
  /// In en, this message translates to:
  /// **'Crons'**
  String get crons;

  /// No description provided for @cron_conversations_empty.
  ///
  /// In en, this message translates to:
  /// **'Conversations from scheduled jobs appear here, including older runs.'**
  String get cron_conversations_empty;

  /// No description provided for @search_cron_conversations.
  ///
  /// In en, this message translates to:
  /// **'Search cron conversations'**
  String get search_cron_conversations;

  /// No description provided for @cron_jobs.
  ///
  /// In en, this message translates to:
  /// **'Cron Jobs'**
  String get cron_jobs;

  /// No description provided for @cron_schedule_timezone.
  ///
  /// In en, this message translates to:
  /// **'Schedule timezone: {zone}'**
  String cron_schedule_timezone(Object zone);

  /// No description provided for @crons_upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get crons_upcoming;

  /// No description provided for @crons_history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get crons_history;

  /// No description provided for @cron_time_with_zone.
  ///
  /// In en, this message translates to:
  /// **'{time} ({zone})'**
  String cron_time_with_zone(Object time, Object zone);

  /// No description provided for @cron_time_zone_unknown.
  ///
  /// In en, this message translates to:
  /// **'{time} (timezone unknown)'**
  String cron_time_zone_unknown(Object time);

  /// No description provided for @cron_no_next_run.
  ///
  /// In en, this message translates to:
  /// **'No next run scheduled'**
  String get cron_no_next_run;

  /// No description provided for @cron_status_scheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get cron_status_scheduled;

  /// No description provided for @cron_status_paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get cron_status_paused;

  /// No description provided for @cron_delivers_to.
  ///
  /// In en, this message translates to:
  /// **'Delivers to {target}'**
  String cron_delivers_to(Object target);

  /// No description provided for @cron_upcoming_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No scheduled jobs'**
  String get cron_upcoming_empty_title;

  /// No description provided for @cron_upcoming_empty_message.
  ///
  /// In en, this message translates to:
  /// **'Nothing is scheduled to run. Create a job in Cron Jobs, or ask the agent to schedule one.'**
  String get cron_upcoming_empty_message;

  /// No description provided for @cron_upcoming_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Scheduled jobs unavailable'**
  String get cron_upcoming_unavailable;

  /// No description provided for @cron_upcoming_needs_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Scheduled jobs need a Dashboard connection. This address does not expose the cron schedule. Check the Dashboard address and host support.'**
  String get cron_upcoming_needs_dashboard;

  /// No description provided for @cron_upcoming_needs_dashboard_auth.
  ///
  /// In en, this message translates to:
  /// **'Scheduled jobs need Dashboard authentication. Add this connection’s dashboard username and password, or enable proxied mode.'**
  String get cron_upcoming_needs_dashboard_auth;

  /// No description provided for @cron_upcoming_dashboard_unreachable.
  ///
  /// In en, this message translates to:
  /// **'The Dashboard could not be reached. Check the host, dashboard port and network, then retry.'**
  String get cron_upcoming_dashboard_unreachable;

  /// No description provided for @cron_upcoming_load_failed.
  ///
  /// In en, this message translates to:
  /// **'The scheduled jobs could not be read. Check the Dashboard connection, then retry.'**
  String get cron_upcoming_load_failed;

  /// No description provided for @cron_upcoming_refresh_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh the schedule. Showing the last successful read.'**
  String get cron_upcoming_refresh_failed;

  /// No description provided for @cron_job_added.
  ///
  /// In en, this message translates to:
  /// **'Cron job added'**
  String get cron_job_added;

  /// No description provided for @cron_job_updated.
  ///
  /// In en, this message translates to:
  /// **'Cron job updated'**
  String get cron_job_updated;

  /// No description provided for @cron_run.
  ///
  /// In en, this message translates to:
  /// **'Cron run'**
  String get cron_run;

  /// No description provided for @cross_device_ordering_and_reversible_bulk_organization.
  ///
  /// In en, this message translates to:
  /// **'Cross-device ordering and reversible bulk organization'**
  String get cross_device_ordering_and_reversible_bulk_organization;

  /// No description provided for @current_profile_default.
  ///
  /// In en, this message translates to:
  /// **'Current profile default'**
  String get current_profile_default;

  /// No description provided for @custom_proxy_and_dashboard_details.
  ///
  /// In en, this message translates to:
  /// **'Custom proxy and dashboard details'**
  String get custom_proxy_and_dashboard_details;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @dashboard_proxy_settings.
  ///
  /// In en, this message translates to:
  /// **'Dashboard / Proxy Settings'**
  String get dashboard_proxy_settings;

  /// No description provided for @dashboard_password_optional.
  ///
  /// In en, this message translates to:
  /// **'Dashboard Password (optional)'**
  String get dashboard_password_optional;

  /// No description provided for @dashboard_port.
  ///
  /// In en, this message translates to:
  /// **'Dashboard Port'**
  String get dashboard_port;

  /// No description provided for @dashboard_username_optional.
  ///
  /// In en, this message translates to:
  /// **'Dashboard Username (optional)'**
  String get dashboard_username_optional;

  /// No description provided for @dashboard_behind_proxy.
  ///
  /// In en, this message translates to:
  /// **'Dashboard behind proxy'**
  String get dashboard_behind_proxy;

  /// No description provided for @dashboard_path_prefix.
  ///
  /// In en, this message translates to:
  /// **'Dashboard path prefix'**
  String get dashboard_path_prefix;

  /// No description provided for @delegated_task.
  ///
  /// In en, this message translates to:
  /// **'Delegated task: {goal}'**
  String delegated_task(Object goal);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @delete_2.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\"?'**
  String delete_2(Object name);

  /// No description provided for @delete_from_the_remote_hermes_history_this_cannot_be_undone.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{title}\" from the remote Hermes history? This cannot be undone.'**
  String delete_from_the_remote_hermes_history_this_cannot_be_undone(
    Object title,
  );

  /// No description provided for @delete_cron_job.
  ///
  /// In en, this message translates to:
  /// **'Delete Cron Job'**
  String get delete_cron_job;

  /// No description provided for @delete_connections_that_are_not_in_the_backup.
  ///
  /// In en, this message translates to:
  /// **'Delete connections that are not in the backup.'**
  String get delete_connections_that_are_not_in_the_backup;

  /// No description provided for @delete_failed.
  ///
  /// In en, this message translates to:
  /// **'Delete failed: {error}'**
  String delete_failed(Object error);

  /// No description provided for @delete_project.
  ///
  /// In en, this message translates to:
  /// **'Delete project'**
  String get delete_project;

  /// No description provided for @delete_session.
  ///
  /// In en, this message translates to:
  /// **'Delete session?'**
  String get delete_session;

  /// No description provided for @delete_3.
  ///
  /// In en, this message translates to:
  /// **'Delete {projectName}?'**
  String delete_3(Object projectName);

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted \"{name}\"'**
  String deleted(Object name);

  /// No description provided for @delivery_is_uncertain_recovering_without_resending.
  ///
  /// In en, this message translates to:
  /// **'Delivery is uncertain; recovering without resending…'**
  String get delivery_is_uncertain_recovering_without_resending;

  /// No description provided for @desktop_gateway_url_optional.
  ///
  /// In en, this message translates to:
  /// **'Desktop Gateway URL (optional)'**
  String get desktop_gateway_url_optional;

  /// No description provided for @desktop_gateway_is_not_configured_for_this_connection.
  ///
  /// In en, this message translates to:
  /// **'Desktop Gateway is not configured for this connection.'**
  String get desktop_gateway_is_not_configured_for_this_connection;

  /// No description provided for @desktop_app.
  ///
  /// In en, this message translates to:
  /// **'Desktop app'**
  String get desktop_app;

  /// No description provided for @developer_tool_calls.
  ///
  /// In en, this message translates to:
  /// **'Developer tool calls'**
  String get developer_tool_calls;

  /// No description provided for @discord_chats.
  ///
  /// In en, this message translates to:
  /// **'Discord chats'**
  String get discord_chats;

  /// No description provided for @dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get dismiss;

  /// No description provided for @do_not_run_this_command.
  ///
  /// In en, this message translates to:
  /// **'Do not run this command.'**
  String get do_not_run_this_command;

  /// No description provided for @documents_archives_audio_video_or_data.
  ///
  /// In en, this message translates to:
  /// **'Documents, archives, audio, video, or data'**
  String get documents_archives_audio_video_or_data;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @download_failed.
  ///
  /// In en, this message translates to:
  /// **'Download failed: {error}'**
  String download_failed(Object error);

  /// No description provided for @durable_facts_hermes_keeps_about_you.
  ///
  /// In en, this message translates to:
  /// **'Durable facts Hermes keeps about you'**
  String get durable_facts_hermes_keeps_about_you;

  /// No description provided for @durable_work_inside_one_of_your_projects_shared_with_desktop.
  ///
  /// In en, this message translates to:
  /// **'Durable work inside one of your projects, shared with Desktop.'**
  String get durable_work_inside_one_of_your_projects_shared_with_desktop;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @edit_connection.
  ///
  /// In en, this message translates to:
  /// **'Edit Connection'**
  String get edit_connection;

  /// No description provided for @edit_cron_job.
  ///
  /// In en, this message translates to:
  /// **'Edit Cron Job'**
  String get edit_cron_job;

  /// No description provided for @edit_gateway_connection.
  ///
  /// In en, this message translates to:
  /// **'Edit Gateway Connection'**
  String get edit_gateway_connection;

  /// No description provided for @edit_and_resend.
  ///
  /// In en, this message translates to:
  /// **'Edit and resend'**
  String get edit_and_resend;

  /// No description provided for @enable_notifications.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications'**
  String get enable_notifications;

  /// No description provided for @enable_notifications_description.
  ///
  /// In en, this message translates to:
  /// **'Turning this off disables every notification below.'**
  String get enable_notifications_description;

  /// No description provided for @enables_file_attachments_through_the_desktop_remote_gateway.
  ///
  /// In en, this message translates to:
  /// **'Enables file attachments through the Desktop remote gateway.'**
  String get enables_file_attachments_through_the_desktop_remote_gateway;

  /// No description provided for @enter_a_name.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get enter_a_name;

  /// No description provided for @enter_a_passphrase.
  ///
  /// In en, this message translates to:
  /// **'Enter a passphrase.'**
  String get enter_a_passphrase;

  /// No description provided for @enter_the_passphrase_for_this_backup.
  ///
  /// In en, this message translates to:
  /// **'Enter the passphrase for this backup.'**
  String get enter_the_passphrase_for_this_backup;

  /// No description provided for @every_conversation_is_already_assigned_to_a_project.
  ///
  /// In en, this message translates to:
  /// **'Every conversation is already assigned to a Project.'**
  String get every_conversation_is_already_assigned_to_a_project;

  /// No description provided for @everything_not_yet_native_in_the_authenticated_web_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Everything not yet native, in the authenticated web dashboard'**
  String get everything_not_yet_native_in_the_authenticated_web_dashboard;

  /// No description provided for @explain_the_attached_content_clearly.
  ///
  /// In en, this message translates to:
  /// **'Explain the attached content clearly.'**
  String get explain_the_attached_content_clearly;

  /// No description provided for @explain_this_content_clearly.
  ///
  /// In en, this message translates to:
  /// **'Explain this content clearly:\n\n{text}'**
  String explain_this_content_clearly(Object text);

  /// No description provided for @explicit_choices_adjust_android_accessibility_text_size_system_leaves_it.
  ///
  /// In en, this message translates to:
  /// **'Explicit choices adjust Android accessibility text size; System leaves it unchanged.'**
  String
  get explicit_choices_adjust_android_accessibility_text_size_system_leaves_it;

  /// No description provided for @export_label.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export_label;

  /// No description provided for @export_share.
  ///
  /// In en, this message translates to:
  /// **'Export / share'**
  String get export_share;

  /// No description provided for @external_api_clients.
  ///
  /// In en, this message translates to:
  /// **'External API clients'**
  String get external_api_clients;

  /// No description provided for @extra_high.
  ///
  /// In en, this message translates to:
  /// **'Extra High'**
  String get extra_high;

  /// No description provided for @extract_tasks.
  ///
  /// In en, this message translates to:
  /// **'Extract tasks'**
  String get extract_tasks;

  /// No description provided for @extract_the_decisions_deadlines_owners_and_actionable_action_items_from.
  ///
  /// In en, this message translates to:
  /// **'Extract the decisions, deadlines, owners, and actionable action items from the attached content.'**
  String
  get extract_the_decisions_deadlines_owners_and_actionable_action_items_from;

  /// No description provided for @extract_the_decisions_deadlines_owners_and_actionable_action_items_from_2.
  ///
  /// In en, this message translates to:
  /// **'Extract the decisions, deadlines, owners, and actionable action items from this content:\n\n{text}'**
  String
  extract_the_decisions_deadlines_owners_and_actionable_action_items_from_2(
    Object text,
  );

  /// No description provided for @failed_to_add_job.
  ///
  /// In en, this message translates to:
  /// **'Failed to add job: {error}'**
  String failed_to_add_job(Object error);

  /// No description provided for @failed_to_load_cron_jobs.
  ///
  /// In en, this message translates to:
  /// **'Failed to load cron jobs'**
  String get failed_to_load_cron_jobs;

  /// No description provided for @failed_to_load_memory.
  ///
  /// In en, this message translates to:
  /// **'Failed to load memory'**
  String get failed_to_load_memory;

  /// No description provided for @failed_to_load_messages.
  ///
  /// In en, this message translates to:
  /// **'Failed to load messages'**
  String get failed_to_load_messages;

  /// No description provided for @failed_to_load_settings.
  ///
  /// In en, this message translates to:
  /// **'Failed to load settings'**
  String get failed_to_load_settings;

  /// No description provided for @failed_to_load_skills.
  ///
  /// In en, this message translates to:
  /// **'Failed to load skills'**
  String get failed_to_load_skills;

  /// No description provided for @failed_to_update_job.
  ///
  /// In en, this message translates to:
  /// **'Failed to update job: {error}'**
  String failed_to_update_job(Object error);

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed: {error}'**
  String failed(Object error);

  /// No description provided for @file_attached_document_catalog_registration_is_pending.
  ///
  /// In en, this message translates to:
  /// **'File attached; document catalog registration is pending.'**
  String get file_attached_document_catalog_registration_is_pending;

  /// No description provided for @file_reference_added_to_chat.
  ///
  /// In en, this message translates to:
  /// **'File reference added to chat'**
  String get file_reference_added_to_chat;

  /// No description provided for @files.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get files;

  /// No description provided for @fill_from_document.
  ///
  /// In en, this message translates to:
  /// **'Fill from document'**
  String get fill_from_document;

  /// No description provided for @folder_is_empty.
  ///
  /// In en, this message translates to:
  /// **'Folder is empty'**
  String get folder_is_empty;

  /// No description provided for @folders.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get folders;

  /// No description provided for @full_text.
  ///
  /// In en, this message translates to:
  /// **'Full-text'**
  String get full_text;

  /// No description provided for @gateway_api_access.
  ///
  /// In en, this message translates to:
  /// **'Gateway API access'**
  String get gateway_api_access;

  /// No description provided for @gateway_connected_but_the_dashboard_could_not_be_reached_or.
  ///
  /// In en, this message translates to:
  /// **'Gateway connected, but the dashboard could not be reached or authenticated. Check the dashboard details, or clear them to skip.'**
  String get gateway_connected_but_the_dashboard_could_not_be_reached_or;

  /// No description provided for @gateway_path_prefix.
  ///
  /// In en, this message translates to:
  /// **'Gateway path prefix'**
  String get gateway_path_prefix;

  /// No description provided for @go_to_end.
  ///
  /// In en, this message translates to:
  /// **'Go to end'**
  String get go_to_end;

  /// No description provided for @hermes_agent.
  ///
  /// In en, this message translates to:
  /// **'Ares - formerly Hermes Android'**
  String get hermes_agent;

  /// No description provided for @hermes_agent_for_android.
  ///
  /// In en, this message translates to:
  /// **'Ares - formerly Hermes Android'**
  String get hermes_agent_for_android;

  /// No description provided for @hermes_could_not_accept_the_answer_please_try_again.
  ///
  /// In en, this message translates to:
  /// **'Hermes could not accept the answer. Please try again.'**
  String get hermes_could_not_accept_the_answer_please_try_again;

  /// No description provided for @hermes_could_not_load_your_saved_connections.
  ///
  /// In en, this message translates to:
  /// **'Hermes could not load your saved connections'**
  String get hermes_could_not_load_your_saved_connections;

  /// No description provided for @hermes_did_not_accept_the_response_please_try_again.
  ///
  /// In en, this message translates to:
  /// **'Hermes did not accept the response. Please try again.'**
  String get hermes_did_not_accept_the_response_please_try_again;

  /// No description provided for @hermes_is_responding.
  ///
  /// In en, this message translates to:
  /// **'Hermes is responding…'**
  String get hermes_is_responding;

  /// No description provided for @hermes_is_waiting_for_input.
  ///
  /// In en, this message translates to:
  /// **'Hermes is waiting for input…'**
  String get hermes_is_waiting_for_input;

  /// No description provided for @hermes_keeps_android_accessibility_text_scaling_active.
  ///
  /// In en, this message translates to:
  /// **'Ares keeps Android accessibility text scaling active.'**
  String get hermes_keeps_android_accessibility_text_scaling_active;

  /// No description provided for @hermes_needs_your_input.
  ///
  /// In en, this message translates to:
  /// **'Hermes needs your input'**
  String get hermes_needs_your_input;

  /// No description provided for @hermes_profile_optional.
  ///
  /// In en, this message translates to:
  /// **'Hermes profile (optional)'**
  String get hermes_profile_optional;

  /// No description provided for @hermes_profile_must_be_a_plain_profile_name_such_as.
  ///
  /// In en, this message translates to:
  /// **'Hermes profile must be a plain profile name such as \"sol\", not a path.'**
  String get hermes_profile_must_be_a_plain_profile_name_such_as;

  /// No description provided for @hermes_reasoning_details.
  ///
  /// In en, this message translates to:
  /// **'Hermes reasoning details'**
  String get hermes_reasoning_details;

  /// No description provided for @hermes_recovery_is_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Hermes recovery is unavailable: {error}'**
  String hermes_recovery_is_unavailable(Object error);

  /// No description provided for @hermes_stopped_recovery_safely_no_prompt_was_resent.
  ///
  /// In en, this message translates to:
  /// **'Hermes stopped recovery safely. No prompt was resent.'**
  String get hermes_stopped_recovery_safely_no_prompt_was_resent;

  /// No description provided for @hide_passphrase.
  ///
  /// In en, this message translates to:
  /// **'Hide passphrase'**
  String get hide_passphrase;

  /// No description provided for @home_needs_your_recent_chats_to_know_what_deserves_your.
  ///
  /// In en, this message translates to:
  /// **'Home needs your recent chats to know what deserves your attention. Check that the gateway is reachable, then try again.'**
  String get home_needs_your_recent_chats_to_know_what_deserves_your;

  /// No description provided for @host.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get host;

  /// No description provided for @image_selection_was_interrupted_try_again.
  ///
  /// In en, this message translates to:
  /// **'Image selection was interrupted. Try again.'**
  String get image_selection_was_interrupted_try_again;

  /// No description provided for @import_label.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get import_label;

  /// No description provided for @inbox.
  ///
  /// In en, this message translates to:
  /// **'Inbox'**
  String get inbox;

  /// No description provided for @inbox_is_clear.
  ///
  /// In en, this message translates to:
  /// **'Inbox is clear'**
  String get inbox_is_clear;

  /// No description provided for @input_needed.
  ///
  /// In en, this message translates to:
  /// **'Input needed'**
  String get input_needed;

  /// No description provided for @input_needed_description.
  ///
  /// In en, this message translates to:
  /// **'Hermes asked a question or needs a password or secret.'**
  String get input_needed_description;

  /// No description provided for @insert_a_remote_file_reference.
  ///
  /// In en, this message translates to:
  /// **'Insert a remote @file reference'**
  String get insert_a_remote_file_reference;

  /// No description provided for @invalid_port_number.
  ///
  /// In en, this message translates to:
  /// **'Invalid port number.'**
  String get invalid_port_number;

  /// No description provided for @job_paused.
  ///
  /// In en, this message translates to:
  /// **'Job paused'**
  String get job_paused;

  /// No description provided for @job_resumed.
  ///
  /// In en, this message translates to:
  /// **'Job resumed'**
  String get job_resumed;

  /// No description provided for @job_triggered.
  ///
  /// In en, this message translates to:
  /// **'Job triggered'**
  String get job_triggered;

  /// No description provided for @label.
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get label;

  /// No description provided for @last_activity.
  ///
  /// In en, this message translates to:
  /// **'Last activity {day}/{month}/{year}'**
  String last_activity(Object day, Object month, Object year);

  /// No description provided for @last.
  ///
  /// In en, this message translates to:
  /// **'Last: {lastRun}'**
  String last(Object lastRun);

  /// No description provided for @leave_blank_for_default_8642_443_with_https.
  ///
  /// In en, this message translates to:
  /// **'Leave blank for default (8642; 443 with https)'**
  String get leave_blank_for_default_8642_443_with_https;

  /// No description provided for @leave_blank_for_default_9119.
  ///
  /// In en, this message translates to:
  /// **'Leave blank for default (9119)'**
  String get leave_blank_for_default_9119;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening • {elapsed}'**
  String listening(Object elapsed);

  /// No description provided for @listening_elapsed.
  ///
  /// In en, this message translates to:
  /// **'Listening, elapsed {elapsed}'**
  String listening_elapsed(Object elapsed);

  /// No description provided for @load_more.
  ///
  /// In en, this message translates to:
  /// **'Load more…'**
  String get load_more;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @make_sure_the_gateway_api_server_is_running_hermes_gateway.
  ///
  /// In en, this message translates to:
  /// **'Make sure the Gateway API Server is running\n(hermes gateway status)'**
  String get make_sure_the_gateway_api_server_is_running_hermes_gateway;

  /// No description provided for @matches.
  ///
  /// In en, this message translates to:
  /// **'Matches {name} · {assigned}'**
  String matches(Object assigned, Object name);

  /// No description provided for @memory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get memory;

  /// No description provided for @memory_about_you.
  ///
  /// In en, this message translates to:
  /// **'About you'**
  String get memory_about_you;

  /// No description provided for @memory_agent_notes.
  ///
  /// In en, this message translates to:
  /// **'Agent notes'**
  String get memory_agent_notes;

  /// No description provided for @memory_builtin_scope.
  ///
  /// In en, this message translates to:
  /// **'Saved facts from this profile’s USER.md and MEMORY.md. External memory providers (including MemPalace) are not shown here.'**
  String get memory_builtin_scope;

  /// No description provided for @memory_read_only.
  ///
  /// In en, this message translates to:
  /// **'Read-only. Ask Hermes in chat to correct or forget a fact.'**
  String get memory_read_only;

  /// No description provided for @memory_unavailable.
  ///
  /// In en, this message translates to:
  /// **'This gateway or profile cannot provide saved memory facts. Check the selected profile and update Hermes if needed.'**
  String get memory_unavailable;

  /// No description provided for @memory_load_error.
  ///
  /// In en, this message translates to:
  /// **'Check your dashboard connection and authentication, then try again.'**
  String get memory_load_error;

  /// No description provided for @memory_read_full_fact.
  ///
  /// In en, this message translates to:
  /// **'Read full fact'**
  String get memory_read_full_fact;

  /// No description provided for @memory_full_fact_requires_update.
  ///
  /// In en, this message translates to:
  /// **'Full facts require a newer Hermes gateway. Update Hermes and refresh.'**
  String get memory_full_fact_requires_update;

  /// No description provided for @memory_fact_detail_error.
  ///
  /// In en, this message translates to:
  /// **'The full fact could not be loaded. It may have changed; refresh the list and try again.'**
  String get memory_fact_detail_error;

  /// No description provided for @memory_entries_are_cross_session_facts_the_agent_remembers_they.
  ///
  /// In en, this message translates to:
  /// **'Saved facts will appear here after Hermes remembers them.'**
  String get memory_entries_are_cross_session_facts_the_agent_remembers_they;

  /// No description provided for @merge.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get merge;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @message_hermes.
  ///
  /// In en, this message translates to:
  /// **'Message Hermes…'**
  String get message_hermes;

  /// No description provided for @message_actions.
  ///
  /// In en, this message translates to:
  /// **'Message actions'**
  String get message_actions;

  /// No description provided for @message_copied.
  ///
  /// In en, this message translates to:
  /// **'Message copied'**
  String get message_copied;

  /// No description provided for @migrating.
  ///
  /// In en, this message translates to:
  /// **'Migrating…'**
  String get migrating;

  /// No description provided for @migration_complete.
  ///
  /// In en, this message translates to:
  /// **'Migration complete'**
  String get migration_complete;

  /// No description provided for @migration_failed_local_spaces_were_kept_unchanged.
  ///
  /// In en, this message translates to:
  /// **'Migration failed. Local Spaces were kept unchanged.'**
  String get migration_failed_local_spaces_were_kept_unchanged;

  /// No description provided for @migration_incomplete.
  ///
  /// In en, this message translates to:
  /// **'Migration incomplete'**
  String get migration_incomplete;

  /// No description provided for @migration_preview.
  ///
  /// In en, this message translates to:
  /// **'Migration preview'**
  String get migration_preview;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @model_and_thinking_for_this_chat.
  ///
  /// In en, this message translates to:
  /// **'Model and thinking for this chat'**
  String get model_and_thinking_for_this_chat;

  /// No description provided for @model_was_not_changed.
  ///
  /// In en, this message translates to:
  /// **'Model was not changed: {error}'**
  String model_was_not_changed(Object error);

  /// No description provided for @move_attachment_next.
  ///
  /// In en, this message translates to:
  /// **'Move attachment next'**
  String get move_attachment_next;

  /// No description provided for @move_attachment_previous.
  ///
  /// In en, this message translates to:
  /// **'Move attachment previous'**
  String get move_attachment_previous;

  /// No description provided for @move_chat.
  ///
  /// In en, this message translates to:
  /// **'Move chat'**
  String get move_chat;

  /// No description provided for @move_conversation.
  ///
  /// In en, this message translates to:
  /// **'Move conversation'**
  String get move_conversation;

  /// No description provided for @move_to_project.
  ///
  /// In en, this message translates to:
  /// **'Move to project'**
  String get move_to_project;

  /// No description provided for @move_to_space.
  ///
  /// In en, this message translates to:
  /// **'Move to space'**
  String get move_to_space;

  /// No description provided for @moved_to_a_project.
  ///
  /// In en, this message translates to:
  /// **'Moved to a Project'**
  String get moved_to_a_project;

  /// No description provided for @moved_to.
  ///
  /// In en, this message translates to:
  /// **'Moved to {label}'**
  String moved_to(Object label);

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @name_prompt_and_schedule_are_required.
  ///
  /// In en, this message translates to:
  /// **'Name, prompt, and schedule are required'**
  String get name_prompt_and_schedule_are_required;

  /// No description provided for @nav_activity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get nav_activity;

  /// No description provided for @nav_projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get nav_projects;

  /// No description provided for @needs_a_correction_aware_filing_contract_in_the_hermes_gateway.
  ///
  /// In en, this message translates to:
  /// **'Needs a correction-aware filing contract in the Hermes Gateway.'**
  String get needs_a_correction_aware_filing_contract_in_the_hermes_gateway;

  /// No description provided for @needs_a_reachable_hermes_dashboard_check_the_host_port_and.
  ///
  /// In en, this message translates to:
  /// **'Needs a reachable Hermes dashboard. Check the host, port, and credentials of this connection.'**
  String get needs_a_reachable_hermes_dashboard_check_the_host_port_and;

  /// No description provided for @needs_a_server_authoritative_assets_index_in_the_hermes_gateway.
  ///
  /// In en, this message translates to:
  /// **'Needs a server-authoritative Assets index in the Hermes Gateway.'**
  String get needs_a_server_authoritative_assets_index_in_the_hermes_gateway;

  /// No description provided for @needs_durable_pin_ordering_batch_mutation_and_undo_contracts_in.
  ///
  /// In en, this message translates to:
  /// **'Needs durable pin ordering, batch mutation, and undo contracts in the Hermes Gateway.'**
  String get needs_durable_pin_ordering_batch_mutation_and_undo_contracts_in;

  /// No description provided for @needs_you.
  ///
  /// In en, this message translates to:
  /// **'Needs you'**
  String get needs_you;

  /// No description provided for @new_label.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get new_label;

  /// No description provided for @new_chat.
  ///
  /// In en, this message translates to:
  /// **'New Chat'**
  String get new_chat;

  /// No description provided for @new_chat_2.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get new_chat_2;

  /// No description provided for @new_chat_3.
  ///
  /// In en, this message translates to:
  /// **'New chat · {projectName}'**
  String new_chat_3(Object projectName);

  /// No description provided for @new_project.
  ///
  /// In en, this message translates to:
  /// **'New project'**
  String get new_project;

  /// No description provided for @new_space.
  ///
  /// In en, this message translates to:
  /// **'New space'**
  String get new_space;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next: {nextRun}'**
  String next(Object nextRun);

  /// No description provided for @nginx_injects_auth_app_sends_clean_requests.
  ///
  /// In en, this message translates to:
  /// **'Nginx injects auth — app sends clean requests'**
  String get nginx_injects_auth_app_sends_clean_requests;

  /// No description provided for @no_tts_voices_found_ninstall_google_text_to_speech_and.
  ///
  /// In en, this message translates to:
  /// **'No TTS voices found.\nInstall Google Text-to-Speech and download voice data.'**
  String get no_tts_voices_found_ninstall_google_text_to_speech_and;

  /// No description provided for @no_active_projects_on_this_gateway.
  ///
  /// In en, this message translates to:
  /// **'No active Projects on this Gateway'**
  String get no_active_projects_on_this_gateway;

  /// No description provided for @no_activity_yet.
  ///
  /// In en, this message translates to:
  /// **'No activity yet'**
  String get no_activity_yet;

  /// No description provided for @no_chat_is_blocked_running_or_waiting_to_be_resumed.
  ///
  /// In en, this message translates to:
  /// **'No chat is blocked, running, or waiting to be resumed. Start a new one whenever you are ready.'**
  String get no_chat_is_blocked_running_or_waiting_to_be_resumed;

  /// No description provided for @no_chats_in_this_project_match.
  ///
  /// In en, this message translates to:
  /// **'No chats in this project match “{searchQuery}”.'**
  String no_chats_in_this_project_match(Object searchQuery);

  /// No description provided for @no_chats_in_this_space_yet_tap_to_start_one.
  ///
  /// In en, this message translates to:
  /// **'No chats in this space yet. Tap + to start one.'**
  String get no_chats_in_this_space_yet_tap_to_start_one;

  /// No description provided for @no_chats_yet.
  ///
  /// In en, this message translates to:
  /// **'No chats yet'**
  String get no_chats_yet;

  /// No description provided for @no_connections.
  ///
  /// In en, this message translates to:
  /// **'No connections'**
  String get no_connections;

  /// No description provided for @no_conversation_matches_this_view.
  ///
  /// In en, this message translates to:
  /// **'No conversation matches this view.'**
  String get no_conversation_matches_this_view;

  /// No description provided for @no_cron_jobs.
  ///
  /// In en, this message translates to:
  /// **'No cron jobs'**
  String get no_cron_jobs;

  /// No description provided for @no_folders_yet.
  ///
  /// In en, this message translates to:
  /// **'No folders yet'**
  String get no_folders_yet;

  /// No description provided for @no_local_spaces_were_found_for_this_connection_so_projects.
  ///
  /// In en, this message translates to:
  /// **'No local spaces were found for this connection, so Projects are already the only organization in use here.'**
  String get no_local_spaces_were_found_for_this_connection_so_projects;

  /// No description provided for @no_matches.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get no_matches;

  /// No description provided for @no_memory_entries.
  ///
  /// In en, this message translates to:
  /// **'No memory entries'**
  String get no_memory_entries;

  /// No description provided for @no_message_content_matches.
  ///
  /// In en, this message translates to:
  /// **'No message-content matches'**
  String get no_message_content_matches;

  /// No description provided for @no_new_messages.
  ///
  /// In en, this message translates to:
  /// **'No new messages'**
  String get no_new_messages;

  /// No description provided for @no_projects_yet.
  ///
  /// In en, this message translates to:
  /// **'No projects yet'**
  String get no_projects_yet;

  /// No description provided for @no_runs_yet.
  ///
  /// In en, this message translates to:
  /// **'No runs yet.'**
  String get no_runs_yet;

  /// No description provided for @no_server_project_matches_this_name.
  ///
  /// In en, this message translates to:
  /// **'No server project matches this name · {assigned}'**
  String no_server_project_matches_this_name(Object assigned);

  /// No description provided for @no_sessions_yet.
  ///
  /// In en, this message translates to:
  /// **'No sessions yet'**
  String get no_sessions_yet;

  /// No description provided for @no_skills_found.
  ///
  /// In en, this message translates to:
  /// **'No skills found'**
  String get no_skills_found;

  /// No description provided for @no_spaces_on_this_device.
  ///
  /// In en, this message translates to:
  /// **'No spaces on this device'**
  String get no_spaces_on_this_device;

  /// No description provided for @no_text_shared.
  ///
  /// In en, this message translates to:
  /// **'No text shared'**
  String get no_text_shared;

  /// No description provided for @no_turn_is_blocked_in_flight_or_recently_finished_work.
  ///
  /// In en, this message translates to:
  /// **'No turn is blocked, in flight, or recently finished. Work you start will show up here.'**
  String get no_turn_is_blocked_in_flight_or_recently_finished_work;

  /// No description provided for @no_turn_needs_your_input_or_has_failed.
  ///
  /// In en, this message translates to:
  /// **'No turn needs your input or has failed.'**
  String get no_turn_needs_your_input_or_has_failed;

  /// No description provided for @no_unassigned_chats.
  ///
  /// In en, this message translates to:
  /// **'No unassigned chats.'**
  String get no_unassigned_chats;

  /// No description provided for @nothing_changed_in_the_last_seven_days.
  ///
  /// In en, this message translates to:
  /// **'Nothing changed in the last seven days.'**
  String get nothing_changed_in_the_last_seven_days;

  /// No description provided for @nothing_has_moved_yet_this_is_only_what_a_migration.
  ///
  /// In en, this message translates to:
  /// **'Nothing has moved yet — this is only what a migration would do.'**
  String get nothing_has_moved_yet_this_is_only_what_a_migration;

  /// No description provided for @nothing_here.
  ///
  /// In en, this message translates to:
  /// **'Nothing here'**
  String get nothing_here;

  /// No description provided for @nothing_is_running.
  ///
  /// In en, this message translates to:
  /// **'Nothing is running'**
  String get nothing_is_running;

  /// No description provided for @nothing_needs_you.
  ///
  /// In en, this message translates to:
  /// **'Nothing needs you'**
  String get nothing_needs_you;

  /// No description provided for @nothing_to_migrate.
  ///
  /// In en, this message translates to:
  /// **'Nothing to migrate'**
  String get nothing_to_migrate;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @windows_notifications_blocked.
  ///
  /// In en, this message translates to:
  /// **'Notifications are unavailable. Use the installed Ares app and check Settings → System → Notifications in Windows.'**
  String get windows_notifications_blocked;

  /// No description provided for @windows_notification_diagnostics.
  ///
  /// In en, this message translates to:
  /// **'What Ares submitted to Windows'**
  String get windows_notification_diagnostics;

  /// No description provided for @chat_activity_share.
  ///
  /// In en, this message translates to:
  /// **'Share chat activity'**
  String get chat_activity_share;

  /// No description provided for @chat_activity_share_hint.
  ///
  /// In en, this message translates to:
  /// **'Tell a compatible connected gateway when you are using this chat, so its phone notification plugin can avoid duplicate alerts. No keys or message text are sent.'**
  String get chat_activity_share_hint;

  /// No description provided for @completion_sound.
  ///
  /// In en, this message translates to:
  /// **'Completion sound'**
  String get completion_sound;

  /// No description provided for @completion_sound_system.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get completion_sound_system;

  /// No description provided for @completion_sound_mail.
  ///
  /// In en, this message translates to:
  /// **'Mail'**
  String get completion_sound_mail;

  /// No description provided for @completion_sound_reminder.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get completion_sound_reminder;

  /// No description provided for @completion_sound_silent.
  ///
  /// In en, this message translates to:
  /// **'Silent'**
  String get completion_sound_silent;

  /// No description provided for @completion_sound_scope.
  ///
  /// In en, this message translates to:
  /// **'Plays for finished replies, the test notification and inside the app. Approvals and other alerts keep their usual sound.'**
  String get completion_sound_scope;

  /// No description provided for @completion_sound_scope_android.
  ///
  /// In en, this message translates to:
  /// **'Plays for finished replies, the test notification and inside the app. Approvals, other alerts, background notifications from the server and Android Auto messages keep their usual sound.'**
  String get completion_sound_scope_android;

  /// No description provided for @notification_open_action.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get notification_open_action;

  /// No description provided for @app_sounds_mute.
  ///
  /// In en, this message translates to:
  /// **'Mute app sounds'**
  String get app_sounds_mute;

  /// No description provided for @app_sounds_mute_hint.
  ///
  /// In en, this message translates to:
  /// **'Stops the completion sound Ares plays while it is open. Notifications keep their own sound.'**
  String get app_sounds_mute_hint;

  /// No description provided for @notifications_permission_denied.
  ///
  /// In en, this message translates to:
  /// **'Notifications are blocked at the OS level. Enable them for this app in Android settings.'**
  String get notifications_permission_denied;

  /// No description provided for @off_no_thinking.
  ///
  /// In en, this message translates to:
  /// **'Off (no thinking)'**
  String get off_no_thinking;

  /// No description provided for @offline_showing_the_last_known_activity.
  ///
  /// In en, this message translates to:
  /// **'Offline — showing the last known activity.'**
  String get offline_showing_the_last_known_activity;

  /// No description provided for @offline_showing_the_last_known_chats.
  ///
  /// In en, this message translates to:
  /// **'Offline — showing the last known chats'**
  String get offline_showing_the_last_known_chats;

  /// No description provided for @offline_showing_the_last_known_projects.
  ///
  /// In en, this message translates to:
  /// **'Offline — showing the last known projects.'**
  String get offline_showing_the_last_known_projects;

  /// No description provided for @on_this_device.
  ///
  /// In en, this message translates to:
  /// **'On this device'**
  String get on_this_device;

  /// No description provided for @on_device.
  ///
  /// In en, this message translates to:
  /// **'On-device'**
  String get on_device;

  /// No description provided for @open_inbox.
  ///
  /// In en, this message translates to:
  /// **'Open inbox'**
  String get open_inbox;

  /// No description provided for @open_inbox_2.
  ///
  /// In en, this message translates to:
  /// **'Open inbox ({count})'**
  String open_inbox_2(Object count);

  /// No description provided for @open_the_hermes_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Open the Hermes dashboard'**
  String get open_the_hermes_dashboard;

  /// No description provided for @optional_for_the_memory_cron_skills_settings_tabs_leave_blank.
  ///
  /// In en, this message translates to:
  /// **'Optional. For the Memory/Cron/Skills/Settings tabs. Leave blank to use the default dashboard port (9119) with no login.'**
  String get optional_for_the_memory_cron_skills_settings_tabs_leave_blank;

  /// No description provided for @organization.
  ///
  /// In en, this message translates to:
  /// **'Organization'**
  String get organization;

  /// No description provided for @other_answer.
  ///
  /// In en, this message translates to:
  /// **'Other answer'**
  String get other_answer;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @passphrase.
  ///
  /// In en, this message translates to:
  /// **'Passphrase'**
  String get passphrase;

  /// No description provided for @password_optional.
  ///
  /// In en, this message translates to:
  /// **'Password (optional)'**
  String get password_optional;

  /// No description provided for @phone_or_tablet.
  ///
  /// In en, this message translates to:
  /// **'Phone or tablet'**
  String get phone_or_tablet;

  /// No description provided for @pin_batch_and_undo.
  ///
  /// In en, this message translates to:
  /// **'Pin, batch and undo'**
  String get pin_batch_and_undo;

  /// No description provided for @plugin_notifications.
  ///
  /// In en, this message translates to:
  /// **'Plugin notifications'**
  String get plugin_notifications;

  /// No description provided for @plugin_notifications_description.
  ///
  /// In en, this message translates to:
  /// **'The gateway sent a notice while the app was in the background.'**
  String get plugin_notifications_description;

  /// No description provided for @port.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get port;

  /// No description provided for @preparing_attachments.
  ///
  /// In en, this message translates to:
  /// **'Preparing attachments…'**
  String get preparing_attachments;

  /// No description provided for @preview_truncated.
  ///
  /// In en, this message translates to:
  /// **'Preview truncated'**
  String get preview_truncated;

  /// No description provided for @preview_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Preview unavailable'**
  String get preview_unavailable;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @profile_default_model.
  ///
  /// In en, this message translates to:
  /// **'Profile default model'**
  String get profile_default_model;

  /// No description provided for @profile_default_set_to_chats_with_their_own_model_keep.
  ///
  /// In en, this message translates to:
  /// **'Profile default set to {selectedModel}. Chats with their own model keep that override.'**
  String profile_default_set_to_chats_with_their_own_model_keep(
    Object selectedModel,
  );

  /// No description provided for @profile_this_connection_chats_as_when_the_dashboard_serves_several.
  ///
  /// In en, this message translates to:
  /// **'Profile this connection chats as when the dashboard serves several profiles. Leave blank for an isolated per-profile dashboard.'**
  String get profile_this_connection_chats_as_when_the_dashboard_serves_several;

  /// No description provided for @project.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get project;

  /// No description provided for @project_actions.
  ///
  /// In en, this message translates to:
  /// **'Project actions'**
  String get project_actions;

  /// No description provided for @project_chat.
  ///
  /// In en, this message translates to:
  /// **'Project chat'**
  String get project_chat;

  /// No description provided for @project_chats_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Project chats unavailable'**
  String get project_chats_unavailable;

  /// No description provided for @projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projects;

  /// No description provided for @projects_group_related_chats_files_and_activity_and_stay_in.
  ///
  /// In en, this message translates to:
  /// **'Projects group related chats, files, and activity, and stay in sync with Hermes on your computer.'**
  String get projects_group_related_chats_files_and_activity_and_stay_in;

  /// No description provided for @projects_need_a_desktop_gateway_connection_add_the_desktop_gateway.
  ///
  /// In en, this message translates to:
  /// **'Projects need a Desktop Gateway connection. Add the Desktop Gateway URL to this connection to organize chats across your devices.'**
  String get projects_need_a_desktop_gateway_connection_add_the_desktop_gateway;

  /// No description provided for @projects_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Projects unavailable'**
  String get projects_unavailable;

  /// No description provided for @projects_activity_new_navigation.
  ///
  /// In en, this message translates to:
  /// **'Projects, Activity — new navigation'**
  String get projects_activity_new_navigation;

  /// No description provided for @promote_to_project.
  ///
  /// In en, this message translates to:
  /// **'Promote to project'**
  String get promote_to_project;

  /// No description provided for @prompt.
  ///
  /// In en, this message translates to:
  /// **'Prompt'**
  String get prompt;

  /// No description provided for @protect_this_backup.
  ///
  /// In en, this message translates to:
  /// **'Protect this backup'**
  String get protect_this_backup;

  /// No description provided for @provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get provider;

  /// No description provided for @proxy_injects_auth_app_sends_clean_requests.
  ///
  /// In en, this message translates to:
  /// **'Proxy injects auth; app sends clean requests'**
  String get proxy_injects_auth_app_sends_clean_requests;

  /// No description provided for @quick_chat.
  ///
  /// In en, this message translates to:
  /// **'Quick chat'**
  String get quick_chat;

  /// No description provided for @quick_chats_appear_here_after_their_retention_period.
  ///
  /// In en, this message translates to:
  /// **'Quick chats appear here after their retention period.'**
  String get quick_chats_appear_here_after_their_retention_period;

  /// No description provided for @read_aloud.
  ///
  /// In en, this message translates to:
  /// **'Read aloud'**
  String get read_aloud;

  /// No description provided for @read_aloud_is_unavailable_on_this_device.
  ///
  /// In en, this message translates to:
  /// **'Read aloud is unavailable on this device'**
  String get read_aloud_is_unavailable_on_this_device;

  /// No description provided for @reading_response_aloud.
  ///
  /// In en, this message translates to:
  /// **'Reading response aloud'**
  String get reading_response_aloud;

  /// No description provided for @ready_to_upload.
  ///
  /// In en, this message translates to:
  /// **'Ready to upload'**
  String get ready_to_upload;

  /// No description provided for @reasoning.
  ///
  /// In en, this message translates to:
  /// **'Reasoning'**
  String get reasoning;

  /// No description provided for @recently_completed.
  ///
  /// In en, this message translates to:
  /// **'Recently completed'**
  String get recently_completed;

  /// No description provided for @recently_active.
  ///
  /// In en, this message translates to:
  /// **'Recently active'**
  String get recently_active;

  /// No description provided for @recovering_hermes.
  ///
  /// In en, this message translates to:
  /// **'Recovering Hermes…'**
  String get recovering_hermes;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @regenerate_response.
  ///
  /// In en, this message translates to:
  /// **'Regenerate response'**
  String get regenerate_response;

  /// No description provided for @remove_attachment.
  ///
  /// In en, this message translates to:
  /// **'Remove attachment'**
  String get remove_attachment;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @rename_chat.
  ///
  /// In en, this message translates to:
  /// **'Rename chat'**
  String get rename_chat;

  /// No description provided for @rename_project.
  ///
  /// In en, this message translates to:
  /// **'Rename project'**
  String get rename_project;

  /// No description provided for @rename_space.
  ///
  /// In en, this message translates to:
  /// **'Rename space'**
  String get rename_space;

  /// No description provided for @rename_2.
  ///
  /// In en, this message translates to:
  /// **'Rename {projectName}'**
  String rename_2(Object projectName);

  /// No description provided for @rename_3.
  ///
  /// In en, this message translates to:
  /// **'Rename {name}'**
  String rename_3(Object name);

  /// No description provided for @replace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replace;

  /// No description provided for @repositories.
  ///
  /// In en, this message translates to:
  /// **'Repositories'**
  String get repositories;

  /// No description provided for @research_the_attached_content_verify_the_important_claims_and_cite.
  ///
  /// In en, this message translates to:
  /// **'Research the attached content, verify the important claims, and cite sources.'**
  String get research_the_attached_content_verify_the_important_claims_and_cite;

  /// No description provided for @research_this_content_verify_the_important_claims_and_cite_sources.
  ///
  /// In en, this message translates to:
  /// **'Research this content, verify the important claims, and cite sources:\n\n{text}'**
  String research_this_content_verify_the_important_claims_and_cite_sources(
    Object text,
  );

  /// No description provided for @reset_failed_the_secure_storage_may_need_reinstall.
  ///
  /// In en, this message translates to:
  /// **'Reset failed: {retryError}. The secure storage may need reinstall.'**
  String reset_failed_the_secure_storage_may_need_reinstall(Object retryError);

  /// No description provided for @reset_saved_connections.
  ///
  /// In en, this message translates to:
  /// **'Reset saved connections'**
  String get reset_saved_connections;

  /// No description provided for @responding.
  ///
  /// In en, this message translates to:
  /// **'Responding…'**
  String get responding;

  /// No description provided for @response_closed_locally_gateway_stop_failed.
  ///
  /// In en, this message translates to:
  /// **'Response closed locally; gateway stop failed: {error}'**
  String response_closed_locally_gateway_stop_failed(Object error);

  /// No description provided for @response_closed_locally_no_active_gateway_turn_was_found.
  ///
  /// In en, this message translates to:
  /// **'Response closed locally; no active gateway turn was found.'**
  String get response_closed_locally_no_active_gateway_turn_was_found;

  /// No description provided for @response_complete.
  ///
  /// In en, this message translates to:
  /// **'Response complete'**
  String get response_complete;

  /// No description provided for @response_complete_description.
  ///
  /// In en, this message translates to:
  /// **'A turn completed while the app was in the background.'**
  String get response_complete_description;

  /// No description provided for @response_ready.
  ///
  /// In en, this message translates to:
  /// **'Response ready'**
  String get response_ready;

  /// No description provided for @response_stopped.
  ///
  /// In en, this message translates to:
  /// **'Response stopped.'**
  String get response_stopped;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @restore_configuration.
  ///
  /// In en, this message translates to:
  /// **'Restore configuration'**
  String get restore_configuration;

  /// No description provided for @restore_project.
  ///
  /// In en, this message translates to:
  /// **'Restore project'**
  String get restore_project;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @retry_failed_for_the_draft_and_prompt_were_kept.
  ///
  /// In en, this message translates to:
  /// **'Retry failed for {name}. The draft and prompt were kept.'**
  String retry_failed_for_the_draft_and_prompt_were_kept(Object name);

  /// No description provided for @retry_upload.
  ///
  /// In en, this message translates to:
  /// **'Retry upload'**
  String get retry_upload;

  /// No description provided for @retrying.
  ///
  /// In en, this message translates to:
  /// **'Retrying {name}…'**
  String retrying(Object name);

  /// No description provided for @review_local_spaces.
  ///
  /// In en, this message translates to:
  /// **'Review local spaces'**
  String get review_local_spaces;

  /// No description provided for @review_or_promote_quick_chats_past_their_retention_period.
  ///
  /// In en, this message translates to:
  /// **'Review or promote quick chats past their retention period'**
  String get review_or_promote_quick_chats_past_their_retention_period;

  /// No description provided for @review_the_attached_content.
  ///
  /// In en, this message translates to:
  /// **'Review the attached content.'**
  String get review_the_attached_content;

  /// No description provided for @run_only_this_command.
  ///
  /// In en, this message translates to:
  /// **'Run only this command.'**
  String get run_only_this_command;

  /// No description provided for @running_now.
  ///
  /// In en, this message translates to:
  /// **'Running now'**
  String get running_now;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get save_changes;

  /// No description provided for @save_a_permanent_rule_in_the_hermes_configuration.
  ///
  /// In en, this message translates to:
  /// **'Save a permanent rule in the Hermes configuration.'**
  String get save_a_permanent_rule_in_the_hermes_configuration;

  /// No description provided for @save_the_durable_facts_from_the_attached_content_to_memory.
  ///
  /// In en, this message translates to:
  /// **'Save the durable facts from the attached content to memory, then confirm what was retained.'**
  String get save_the_durable_facts_from_the_attached_content_to_memory;

  /// No description provided for @save_the_durable_facts_from_this_content_to_memory_then.
  ///
  /// In en, this message translates to:
  /// **'Save the durable facts from this content to memory, then confirm what was retained:\n\n{text}'**
  String save_the_durable_facts_from_this_content_to_memory_then(Object text);

  /// No description provided for @save_your_connections_and_settings_to_an_encrypted_file_then.
  ///
  /// In en, this message translates to:
  /// **'Save your connections and settings to an encrypted file, then restore them after reinstalling or on another device.'**
  String get save_your_connections_and_settings_to_an_encrypted_file_then;

  /// No description provided for @save_2.
  ///
  /// In en, this message translates to:
  /// **'Save {filename}'**
  String save_2(Object filename);

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @scheduled_jobs_and_their_last_runs.
  ///
  /// In en, this message translates to:
  /// **'Scheduled jobs and their last runs'**
  String get scheduled_jobs_and_their_last_runs;

  /// No description provided for @scheduled_tasks.
  ///
  /// In en, this message translates to:
  /// **'Scheduled tasks'**
  String get scheduled_tasks;

  /// No description provided for @script_only_no_agent.
  ///
  /// In en, this message translates to:
  /// **'Script only (no agent)'**
  String get script_only_no_agent;

  /// No description provided for @scroll_horizontally.
  ///
  /// In en, this message translates to:
  /// **'Scroll horizontally'**
  String get scroll_horizontally;

  /// No description provided for @search_all_chats.
  ///
  /// In en, this message translates to:
  /// **'Search all chats'**
  String get search_all_chats;

  /// No description provided for @search_all_message_content.
  ///
  /// In en, this message translates to:
  /// **'Search all message content'**
  String get search_all_message_content;

  /// No description provided for @search_chats.
  ///
  /// In en, this message translates to:
  /// **'Search chats'**
  String get search_chats;

  /// No description provided for @search_conversations.
  ///
  /// In en, this message translates to:
  /// **'Search conversations'**
  String get search_conversations;

  /// No description provided for @search_loaded_chats.
  ///
  /// In en, this message translates to:
  /// **'Search loaded chats'**
  String get search_loaded_chats;

  /// No description provided for @search_mode.
  ///
  /// In en, this message translates to:
  /// **'Search mode'**
  String get search_mode;

  /// No description provided for @select_one_option_or_enter_another_answer.
  ///
  /// In en, this message translates to:
  /// **'Select one option, or enter another answer.'**
  String get select_one_option_or_enter_another_answer;

  /// No description provided for @select_one_or_more_options_then_continue.
  ///
  /// In en, this message translates to:
  /// **'Select one or more options, then continue.'**
  String get select_one_or_more_options_then_continue;

  /// No description provided for @select_text.
  ///
  /// In en, this message translates to:
  /// **'Select text'**
  String get select_text;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @send_failed.
  ///
  /// In en, this message translates to:
  /// **'Send failed: {error}'**
  String send_failed(Object error);

  /// No description provided for @send_failed_api_only_permission_denied.
  ///
  /// In en, this message translates to:
  /// **'Send failed: {error}. The server refused this write for the API key principal. If this chat is owned by the Dashboard, adding the Dashboard username and password for this connection may let it send; the server may also be refusing deliberately.'**
  String send_failed_api_only_permission_denied(Object error);

  /// No description provided for @send_message.
  ///
  /// In en, this message translates to:
  /// **'Send message'**
  String get send_message;

  /// No description provided for @send_test_notification.
  ///
  /// In en, this message translates to:
  /// **'Send test notification'**
  String get send_test_notification;

  /// No description provided for @session_sources.
  ///
  /// In en, this message translates to:
  /// **'Session Sources'**
  String get session_sources;

  /// No description provided for @session_deleted_from_remote_hermes.
  ///
  /// In en, this message translates to:
  /// **'Session deleted from remote Hermes.'**
  String get session_deleted_from_remote_hermes;

  /// No description provided for @session_search_failed.
  ///
  /// In en, this message translates to:
  /// **'Session search failed: {error}'**
  String session_search_failed(Object error);

  /// No description provided for @set_profile_default.
  ///
  /// In en, this message translates to:
  /// **'Set profile default'**
  String get set_profile_default;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @share_to_hermes.
  ///
  /// In en, this message translates to:
  /// **'Share to Hermes'**
  String get share_to_hermes;

  /// No description provided for @show_passphrase.
  ///
  /// In en, this message translates to:
  /// **'Show passphrase'**
  String get show_passphrase;

  /// No description provided for @show_tool_calls_thinking_and_message_metadata.
  ///
  /// In en, this message translates to:
  /// **'Show tools, reasoning, tasks and message details in collapsed sections. Off shows only the conversation.'**
  String get show_tool_calls_thinking_and_message_metadata;

  /// No description provided for @signal_messages.
  ///
  /// In en, this message translates to:
  /// **'Signal messages'**
  String get signal_messages;

  /// No description provided for @skills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skills;

  /// No description provided for @skills_2.
  ///
  /// In en, this message translates to:
  /// **'Skills ({count})'**
  String skills_2(Object count);

  /// No description provided for @skills_and_tools.
  ///
  /// In en, this message translates to:
  /// **'Skills and tools'**
  String get skills_and_tools;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @slack_chats.
  ///
  /// In en, this message translates to:
  /// **'Slack chats'**
  String get slack_chats;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source: {source}'**
  String source(Object source);

  /// No description provided for @space_actions.
  ///
  /// In en, this message translates to:
  /// **'Space actions'**
  String get space_actions;

  /// No description provided for @spaces.
  ///
  /// In en, this message translates to:
  /// **'Spaces'**
  String get spaces;

  /// No description provided for @speak_to_hermes.
  ///
  /// In en, this message translates to:
  /// **'Speak to Hermes'**
  String get speak_to_hermes;

  /// No description provided for @speech_recognition_is_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition is unavailable'**
  String get speech_recognition_is_unavailable;

  /// No description provided for @spoken_replies.
  ///
  /// In en, this message translates to:
  /// **'Spoken replies'**
  String get spoken_replies;

  /// No description provided for @spoken_replies_off.
  ///
  /// In en, this message translates to:
  /// **'Spoken replies off'**
  String get spoken_replies_off;

  /// No description provided for @spoken_replies_on.
  ///
  /// In en, this message translates to:
  /// **'Spoken replies on'**
  String get spoken_replies_on;

  /// No description provided for @stalled_no_update_from_hermes.
  ///
  /// In en, this message translates to:
  /// **'Stalled — no update from Hermes'**
  String get stalled_no_update_from_hermes;

  /// No description provided for @start_something_new.
  ///
  /// In en, this message translates to:
  /// **'Start something new'**
  String get start_something_new;

  /// No description provided for @start_voice_input.
  ///
  /// In en, this message translates to:
  /// **'Start voice input'**
  String get start_voice_input;

  /// No description provided for @starting_hermes.
  ///
  /// In en, this message translates to:
  /// **'Starting Hermes…'**
  String get starting_hermes;

  /// No description provided for @media_card_download.
  ///
  /// In en, this message translates to:
  /// **'Download file'**
  String get media_card_download;

  /// No description provided for @media_card_tap_to_download.
  ///
  /// In en, this message translates to:
  /// **'Tap to download'**
  String get media_card_tap_to_download;

  /// No description provided for @still_loading_your_projects.
  ///
  /// In en, this message translates to:
  /// **'Still loading your projects.'**
  String get still_loading_your_projects;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @stop_response.
  ///
  /// In en, this message translates to:
  /// **'Stop response'**
  String get stop_response;

  /// No description provided for @stop_voice_input.
  ///
  /// In en, this message translates to:
  /// **'Stop voice input'**
  String get stop_voice_input;

  /// No description provided for @submitted_waiting_for_hermes.
  ///
  /// In en, this message translates to:
  /// **'Submitted, waiting for Hermes'**
  String get submitted_waiting_for_hermes;

  /// No description provided for @suggest_projects_and_learn_from_your_corrections.
  ///
  /// In en, this message translates to:
  /// **'Suggest Projects and learn from your corrections'**
  String get suggest_projects_and_learn_from_your_corrections;

  /// No description provided for @summarize_the_attached_content.
  ///
  /// In en, this message translates to:
  /// **'Summarize the attached content.'**
  String get summarize_the_attached_content;

  /// No description provided for @summarize_this_content.
  ///
  /// In en, this message translates to:
  /// **'Summarize this content:\n\n{text}'**
  String summarize_this_content(Object text);

  /// No description provided for @switch_profile.
  ///
  /// In en, this message translates to:
  /// **'Switch profile'**
  String get switch_profile;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @take_photo.
  ///
  /// In en, this message translates to:
  /// **'Take photo'**
  String get take_photo;

  /// No description provided for @tap_to_add_a_remote_hermes_gateway_api_server_port.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add a remote Hermes Gateway\n(API Server, port 8642)'**
  String get tap_to_add_a_remote_hermes_gateway_api_server_port;

  /// No description provided for @tap_the_button_to_start_a_new_chat.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button to start a new chat'**
  String get tap_the_button_to_start_a_new_chat;

  /// No description provided for @telegram_messages.
  ///
  /// In en, this message translates to:
  /// **'Telegram messages'**
  String get telegram_messages;

  /// No description provided for @terminal_sessions.
  ///
  /// In en, this message translates to:
  /// **'Terminal sessions'**
  String get terminal_sessions;

  /// No description provided for @test_notification_body.
  ///
  /// In en, this message translates to:
  /// **'If you can see this, native notifications are working.'**
  String get test_notification_body;

  /// No description provided for @test_notification_sent.
  ///
  /// In en, this message translates to:
  /// **'Test notification sent.'**
  String get test_notification_sent;

  /// No description provided for @test_notification_title.
  ///
  /// In en, this message translates to:
  /// **'Hermes notification test'**
  String get test_notification_title;

  /// No description provided for @test_notification_unsupported.
  ///
  /// In en, this message translates to:
  /// **'Could not send the notification — check that the OS allows notifications.'**
  String get test_notification_unsupported;

  /// No description provided for @text_size.
  ///
  /// In en, this message translates to:
  /// **'Text size'**
  String get text_size;

  /// No description provided for @text_size_preview.
  ///
  /// In en, this message translates to:
  /// **'Text size preview'**
  String get text_size_preview;

  /// No description provided for @text_size_2.
  ///
  /// In en, this message translates to:
  /// **'Text size: {label}'**
  String text_size_2(Object label);

  /// No description provided for @the_api_key_could_not_be_stored_securely.
  ///
  /// In en, this message translates to:
  /// **'The API key could not be stored securely.'**
  String get the_api_key_could_not_be_stored_securely;

  /// No description provided for @the_project_will_move_to_archived_its_chats_and_files.
  ///
  /// In en, this message translates to:
  /// **'The Project will move to Archived. Its chats and files stay intact, and you can restore it at any time.'**
  String get the_project_will_move_to_archived_its_chats_and_files;

  /// No description provided for @the_project_will_move_to_archived_its_chats_and_files_2.
  ///
  /// In en, this message translates to:
  /// **'The Project will move to Archived. Its chats and files stay intact, and you can restore it later.'**
  String get the_project_will_move_to_archived_its_chats_and_files_2;

  /// No description provided for @the_active_profile_did_not_return_any_selectable_models.
  ///
  /// In en, this message translates to:
  /// **'The active profile did not return any selectable models.'**
  String get the_active_profile_did_not_return_any_selectable_models;

  /// No description provided for @the_backup_could_not_be_exported.
  ///
  /// In en, this message translates to:
  /// **'The backup could not be exported.'**
  String get the_backup_could_not_be_exported;

  /// No description provided for @the_backup_could_not_be_restored.
  ///
  /// In en, this message translates to:
  /// **'The backup could not be restored.'**
  String get the_backup_could_not_be_restored;

  /// No description provided for @the_connection_could_not_be_deleted_safely.
  ///
  /// In en, this message translates to:
  /// **'The connection could not be deleted safely.'**
  String get the_connection_could_not_be_deleted_safely;

  /// No description provided for @the_connection_could_not_be_stored_securely.
  ///
  /// In en, this message translates to:
  /// **'The connection could not be stored securely.'**
  String get the_connection_could_not_be_stored_securely;

  /// No description provided for @the_dashboard_credentials_could_not_be_stored_securely.
  ///
  /// In en, this message translates to:
  /// **'The dashboard credentials could not be stored securely.'**
  String get the_dashboard_credentials_could_not_be_stored_securely;

  /// No description provided for @the_detached_reply_failed.
  ///
  /// In en, this message translates to:
  /// **'The detached reply failed.'**
  String get the_detached_reply_failed;

  /// No description provided for @the_detached_reply_failed_2.
  ///
  /// In en, this message translates to:
  /// **'The detached reply failed: {error}'**
  String the_detached_reply_failed_2(Object error);

  /// No description provided for @the_file_contains_your_api_keys_and_dashboard_password_so.
  ///
  /// In en, this message translates to:
  /// **'The file contains your API keys and dashboard password, so it is encrypted. Without this passphrase the backup cannot be restored.'**
  String get the_file_contains_your_api_keys_and_dashboard_password_so;

  /// No description provided for @the_last_turn_failed.
  ///
  /// In en, this message translates to:
  /// **'The last turn failed'**
  String get the_last_turn_failed;

  /// No description provided for @the_local_connection_store_looks_damaged_you_can_reset_the.
  ///
  /// In en, this message translates to:
  /// **'The local connection store looks damaged ({errorType}). You can reset the saved connections and start fresh. Chats on your gateway are not affected.'**
  String the_local_connection_store_looks_damaged_you_can_reset_the(
    Object errorType,
  );

  /// No description provided for @the_model_only_rewrites_your_question_into_a_short_full.
  ///
  /// In en, this message translates to:
  /// **'The model only rewrites your question into a short full-text query. Hermes uses the provider credentials already configured on the host.'**
  String get the_model_only_rewrites_your_question_into_a_short_full;

  /// No description provided for @the_server_has_not_reported_folders_for_this_project_yet.
  ///
  /// In en, this message translates to:
  /// **'The server has not reported folders for this project yet. Global Files stays available from More.'**
  String get the_server_has_not_reported_folders_for_this_project_yet;

  /// No description provided for @the_turn_failed.
  ///
  /// In en, this message translates to:
  /// **'The turn failed'**
  String get the_turn_failed;

  /// No description provided for @the_two_passphrases_do_not_match.
  ///
  /// In en, this message translates to:
  /// **'The two passphrases do not match.'**
  String get the_two_passphrases_do_not_match;

  /// No description provided for @the_value_is_sent_directly_to_the_active_hermes_gateway.
  ///
  /// In en, this message translates to:
  /// **'The value is sent directly to the active Hermes gateway and is not saved by this Android app.'**
  String get the_value_is_sent_directly_to_the_active_hermes_gateway;

  /// No description provided for @there_are_no_visible_files_in_this_server_folder.
  ///
  /// In en, this message translates to:
  /// **'There are no visible files in this server folder.'**
  String get there_are_no_visible_files_in_this_server_folder;

  /// No description provided for @thinking_effort.
  ///
  /// In en, this message translates to:
  /// **'Thinking effort'**
  String get thinking_effort;

  /// No description provided for @this_hermes_gateway_does_not_support_opening_a_project_yet.
  ///
  /// In en, this message translates to:
  /// **'This Hermes gateway does not support opening a project yet. Update Hermes on the server to browse a project from your phone.'**
  String get this_hermes_gateway_does_not_support_opening_a_project_yet;

  /// No description provided for @this_hermes_gateway_is_older_than_server_side_projects_so.
  ///
  /// In en, this message translates to:
  /// **'This Hermes gateway is older than server-side projects, so chats stay grouped on this device only. Update Hermes to share the same projects across your devices.'**
  String get this_hermes_gateway_is_older_than_server_side_projects_so;

  /// No description provided for @this_project_has_no_folder_to_open_the_chat_in.
  ///
  /// In en, this message translates to:
  /// **'This Project needs a folder before you can start a chat in it. Add a folder and try again.'**
  String get this_project_has_no_folder_to_open_the_chat_in;

  /// No description provided for @this_chat_has_no_messages_available_in_the_desktop_session.
  ///
  /// In en, this message translates to:
  /// **'This chat has no messages available in the Desktop session yet.'**
  String get this_chat_has_no_messages_available_in_the_desktop_session;

  /// No description provided for @this_creates_a_permanent_rule_in_hermes_review_the_full.
  ///
  /// In en, this message translates to:
  /// **'This creates a permanent rule in Hermes. Review the full command before confirming.'**
  String get this_creates_a_permanent_rule_in_hermes_review_the_full;

  /// No description provided for @this_gateway_does_not_host_projects_yet_update_the_gateway.
  ///
  /// In en, this message translates to:
  /// **'This gateway does not host projects yet. Update the gateway to organize chats across your devices.'**
  String get this_gateway_does_not_host_projects_yet_update_the_gateway;

  /// No description provided for @this_permanently_deletes_the_project_chats_will_not_be_deleted.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes the Project. Chats will not be deleted; they’ll return to Unassigned.'**
  String get this_permanently_deletes_the_project_chats_will_not_be_deleted;

  /// No description provided for @this_server_doesn_t_offer_background_recovery_chats_run_live.
  ///
  /// In en, this message translates to:
  /// **'This server doesn\'t offer background recovery — chats run live'**
  String get this_server_doesn_t_offer_background_recovery_chats_run_live;

  /// No description provided for @this_week.
  ///
  /// In en, this message translates to:
  /// **'This week'**
  String get this_week;

  /// No description provided for @titles_previews_and_models.
  ///
  /// In en, this message translates to:
  /// **'Titles, previews, and models'**
  String get titles_previews_and_models;

  /// No description provided for @tool_activity.
  ///
  /// In en, this message translates to:
  /// **'Tool activity'**
  String get tool_activity;

  /// No description provided for @trigger_now.
  ///
  /// In en, this message translates to:
  /// **'Trigger now'**
  String get trigger_now;

  /// No description provided for @received_outcome_unknown.
  ///
  /// In en, this message translates to:
  /// **'Turn ended — outcome unconfirmed'**
  String get received_outcome_unknown;

  /// No description provided for @turn_completed.
  ///
  /// In en, this message translates to:
  /// **'Turn completed'**
  String get turn_completed;

  /// No description provided for @turn_failed.
  ///
  /// In en, this message translates to:
  /// **'Turn failed'**
  String get turn_failed;

  /// No description provided for @turn_failed_description.
  ///
  /// In en, this message translates to:
  /// **'A background turn ended with an error.'**
  String get turn_failed_description;

  /// No description provided for @turn_recovery_failed.
  ///
  /// In en, this message translates to:
  /// **'Turn recovery failed'**
  String get turn_recovery_failed;

  /// No description provided for @unable_to_prepare_this_file_try_another_one.
  ///
  /// In en, this message translates to:
  /// **'Unable to prepare this file. Try another one.'**
  String get unable_to_prepare_this_file_try_another_one;

  /// No description provided for @unable_to_prepare_this_image_try_another_one.
  ///
  /// In en, this message translates to:
  /// **'Unable to prepare this image. Try another one.'**
  String get unable_to_prepare_this_image_try_another_one;

  /// No description provided for @unable_to_prepare.
  ///
  /// In en, this message translates to:
  /// **'Unable to prepare {name}.'**
  String unable_to_prepare(Object name);

  /// No description provided for @unable_to_read_the_selected_image_the_selection_was_kept.
  ///
  /// In en, this message translates to:
  /// **'Unable to read the selected image. The selection was kept.'**
  String get unable_to_read_the_selected_image_the_selection_was_kept;

  /// No description provided for @unassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get unassigned;

  /// No description provided for @unassigned_chats.
  ///
  /// In en, this message translates to:
  /// **'Unassigned chats'**
  String get unassigned_chats;

  /// No description provided for @untitled_chat.
  ///
  /// In en, this message translates to:
  /// **'Untitled chat'**
  String get untitled_chat;

  /// No description provided for @untitled_session.
  ///
  /// In en, this message translates to:
  /// **'Untitled session'**
  String get untitled_session;

  /// No description provided for @update_api_key.
  ///
  /// In en, this message translates to:
  /// **'Update API Key'**
  String get update_api_key;

  /// No description provided for @upload_failed.
  ///
  /// In en, this message translates to:
  /// **'Upload failed'**
  String get upload_failed;

  /// No description provided for @upload_failed_tap_retry.
  ///
  /// In en, this message translates to:
  /// **'Upload failed • tap retry'**
  String get upload_failed_tap_retry;

  /// No description provided for @uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading {index}/{total}: {name}'**
  String uploading(Object index, Object name, Object total);

  /// No description provided for @use_as_is.
  ///
  /// In en, this message translates to:
  /// **'Use as is'**
  String get use_as_is;

  /// No description provided for @use_at_least_8_characters.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters.'**
  String get use_at_least_8_characters;

  /// No description provided for @use_for_cron_jobs_backed_by_scripts.
  ///
  /// In en, this message translates to:
  /// **'Use for cron jobs backed by scripts.'**
  String get use_for_cron_jobs_backed_by_scripts;

  /// No description provided for @use_on_device.
  ///
  /// In en, this message translates to:
  /// **'Use on-device'**
  String get use_on_device;

  /// No description provided for @use_the_attached_content_to_identify_and_fill_the_relevant.
  ///
  /// In en, this message translates to:
  /// **'Use the attached content to identify and fill the relevant document or form fields. Ask before submitting anything.'**
  String get use_the_attached_content_to_identify_and_fill_the_relevant;

  /// No description provided for @use_this_content_to_identify_and_fill_the_relevant_document.
  ///
  /// In en, this message translates to:
  /// **'Use this content to identify and fill the relevant document or form fields. Ask before submitting anything:\n\n{text}'**
  String use_this_content_to_identify_and_fill_the_relevant_document(
    Object text,
  );

  /// No description provided for @used_for_hosted_path_prefixes_and_for_the_settings_memory.
  ///
  /// In en, this message translates to:
  /// **'Used for hosted path prefixes and for the Settings, Memory, Skills and Cron tabs. Leave username/password blank for an open dashboard, or enable proxied mode when your reverse proxy injects dashboard auth.'**
  String get used_for_hosted_path_prefixes_and_for_the_settings_memory;

  /// No description provided for @username_optional.
  ///
  /// In en, this message translates to:
  /// **'Username (optional)'**
  String get username_optional;

  /// No description provided for @using.
  ///
  /// In en, this message translates to:
  /// **'Using {displayName}…'**
  String using(Object displayName);

  /// No description provided for @verbose_mode.
  ///
  /// In en, this message translates to:
  /// **'Verbose Mode'**
  String get verbose_mode;

  /// No description provided for @message_metadata.
  ///
  /// In en, this message translates to:
  /// **'Message details'**
  String get message_metadata;

  /// No description provided for @voice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voice;

  /// No description provided for @voice_setup_failed.
  ///
  /// In en, this message translates to:
  /// **'Voice setup failed: {error}'**
  String voice_setup_failed(Object error);

  /// No description provided for @waiting_for_your_input.
  ///
  /// In en, this message translates to:
  /// **'Waiting for your input'**
  String get waiting_for_your_input;

  /// No description provided for @what_hermes_knows_how_to_do.
  ///
  /// In en, this message translates to:
  /// **'What Hermes knows how to do'**
  String get what_hermes_knows_how_to_do;

  /// No description provided for @what_should_the_agent_do.
  ///
  /// In en, this message translates to:
  /// **'What should the agent do?'**
  String get what_should_the_agent_do;

  /// No description provided for @whatsapp_messages.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp messages'**
  String get whatsapp_messages;

  /// No description provided for @which_project.
  ///
  /// In en, this message translates to:
  /// **'Which project?'**
  String get which_project;

  /// No description provided for @workspace.
  ///
  /// In en, this message translates to:
  /// **'Workspace'**
  String get workspace;

  /// No description provided for @wrap_lines.
  ///
  /// In en, this message translates to:
  /// **'Wrap lines'**
  String get wrap_lines;

  /// No description provided for @you_can_attach_up_to_items.
  ///
  /// In en, this message translates to:
  /// **'You can attach up to {maxRemoteAttachmentDrafts} items.'**
  String you_can_attach_up_to_items(Object maxRemoteAttachmentDrafts);

  /// No description provided for @your_answer.
  ///
  /// In en, this message translates to:
  /// **'Your answer'**
  String get your_answer;

  /// No description provided for @e_g_dashboard.
  ///
  /// In en, this message translates to:
  /// **'e.g. /dashboard'**
  String get e_g_dashboard;

  /// No description provided for @e_g_dashboard_proxy_path_before_api.
  ///
  /// In en, this message translates to:
  /// **'e.g. /dashboard (proxy path before /api/)'**
  String get e_g_dashboard_proxy_path_before_api;

  /// No description provided for @e_g_profile_peter.
  ///
  /// In en, this message translates to:
  /// **'e.g. /profile/peter'**
  String get e_g_profile_peter;

  /// No description provided for @e_g_sol.
  ///
  /// In en, this message translates to:
  /// **'e.g. sol'**
  String get e_g_sol;

  /// No description provided for @e_g_0_9_or_every_2h.
  ///
  /// In en, this message translates to:
  /// **'e.g., 0 9 * * * or every 2h'**
  String get e_g_0_9_or_every_2h;

  /// No description provided for @e_g_daily_backup.
  ///
  /// In en, this message translates to:
  /// **'e.g., Daily backup'**
  String get e_g_daily_backup;

  /// No description provided for @downloaded.
  ///
  /// In en, this message translates to:
  /// **'{filename} downloaded'**
  String downloaded(Object filename);

  /// No description provided for @activity_name_status.
  ///
  /// In en, this message translates to:
  /// **'{displayName}: {statusLabel}'**
  String activity_name_status(Object displayName, Object statusLabel);

  /// No description provided for @connection_status_label.
  ///
  /// In en, this message translates to:
  /// **'{connectionLabel} {label}'**
  String connection_status_label(Object connectionLabel, Object label);

  /// No description provided for @example_host_hint.
  ///
  /// In en, this message translates to:
  /// **'192.168.1.50, 100.x.y.z, or hermes-machine.tailnet.ts.net'**
  String get example_host_hint;

  /// No description provided for @example_profile_prefix_hint_full.
  ///
  /// In en, this message translates to:
  /// **'e.g. /profile/peter (proxy path before /api/ and /v1/)'**
  String get example_profile_prefix_hint_full;

  /// No description provided for @and_more.
  ///
  /// In en, this message translates to:
  /// **'and {count} more'**
  String and_more(Object count);

  /// No description provided for @chats_count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} chat} other{{count} chats}}'**
  String chats_count(num count);

  /// No description provided for @on_this_device_only.
  ///
  /// In en, this message translates to:
  /// **'{chats} · on this device only'**
  String on_this_device_only(Object chats);

  /// No description provided for @spaces_count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} space} other{{count} spaces}}'**
  String spaces_count(num count);

  /// No description provided for @no_new_projects_needed.
  ///
  /// In en, this message translates to:
  /// **'no new projects needed'**
  String get no_new_projects_needed;

  /// No description provided for @projects_to_create.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} project to create} other{{count} projects to create}}'**
  String projects_to_create(num count);

  /// No description provided for @chats_migrated_projects_created.
  ///
  /// In en, this message translates to:
  /// **'{linkedSessions} chats migrated · {createdProjects} projects created'**
  String chats_migrated_projects_created(
    Object createdProjects,
    Object linkedSessions,
  );

  /// No description provided for @chats_stayed_in_local_spaces.
  ///
  /// In en, this message translates to:
  /// **'{unlinkedSessions} chats stayed in local Spaces and can be retried safely.'**
  String chats_stayed_in_local_spaces(Object unlinkedSessions);

  /// No description provided for @model_recommended.
  ///
  /// In en, this message translates to:
  /// **'{provider} • Recommended: small and inexpensive'**
  String model_recommended(Object provider);

  /// No description provided for @session_meta.
  ///
  /// In en, this message translates to:
  /// **'{count} msgs • {model} • {time}'**
  String session_meta(Object count, Object model, Object time);

  /// No description provided for @model_scope_label.
  ///
  /// In en, this message translates to:
  /// **'{model} • {scope}'**
  String model_scope_label(Object model, Object scope);

  /// No description provided for @this_chat.
  ///
  /// In en, this message translates to:
  /// **'this chat'**
  String get this_chat;

  /// No description provided for @profile_default.
  ///
  /// In en, this message translates to:
  /// **'profile default'**
  String get profile_default;

  /// No description provided for @minutes_ago.
  ///
  /// In en, this message translates to:
  /// **'{count}m ago'**
  String minutes_ago(Object count);

  /// No description provided for @hours_ago.
  ///
  /// In en, this message translates to:
  /// **'{count}h ago'**
  String hours_ago(Object count);

  /// No description provided for @days_ago.
  ///
  /// In en, this message translates to:
  /// **'{count}d ago'**
  String days_ago(Object count);

  /// No description provided for @now_label.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get now_label;

  /// No description provided for @latest_label.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latest_label;

  /// No description provided for @new_count_indicator.
  ///
  /// In en, this message translates to:
  /// **'{count} new'**
  String new_count_indicator(Object count);

  /// No description provided for @new_messages.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} new message} other{{count} new messages}}'**
  String new_messages(num count);

  /// No description provided for @activity_failed_summary.
  ///
  /// In en, this message translates to:
  /// **'{failures} failed • {total} total'**
  String activity_failed_summary(Object failures, Object total);

  /// No description provided for @activity_completed_summary.
  ///
  /// In en, this message translates to:
  /// **'{count} completed'**
  String activity_completed_summary(Object count);

  /// No description provided for @tool_start_observed.
  ///
  /// In en, this message translates to:
  /// **'Start observed {time} (local)'**
  String tool_start_observed(Object time);

  /// No description provided for @tool_last_observed.
  ///
  /// In en, this message translates to:
  /// **'Last observed {time} (local)'**
  String tool_last_observed(Object time);

  /// No description provided for @tool_result_recorded.
  ///
  /// In en, this message translates to:
  /// **'Result recorded {time} (local)'**
  String tool_result_recorded(Object time);

  /// No description provided for @tool_time_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Time unavailable'**
  String get tool_time_unavailable;

  /// No description provided for @hermes_is_using_a_tool.
  ///
  /// In en, this message translates to:
  /// **'Hermes is using a tool'**
  String get hermes_is_using_a_tool;

  /// No description provided for @hermes_is_using_tools.
  ///
  /// In en, this message translates to:
  /// **'Hermes is using {count} tools'**
  String hermes_is_using_tools(Object count);

  /// No description provided for @delegated_tasks_completed.
  ///
  /// In en, this message translates to:
  /// **'{count} delegated task(s) completed'**
  String delegated_tasks_completed(Object count);

  /// No description provided for @delegated_tasks_active.
  ///
  /// In en, this message translates to:
  /// **'{count} delegated task(s) active'**
  String delegated_tasks_active(Object count);

  /// No description provided for @branch_main.
  ///
  /// In en, this message translates to:
  /// **'{label} · main'**
  String branch_main(Object label);

  /// No description provided for @you_heading.
  ///
  /// In en, this message translates to:
  /// **'## You'**
  String get you_heading;

  /// No description provided for @hermes_heading.
  ///
  /// In en, this message translates to:
  /// **'## Hermes'**
  String get hermes_heading;

  /// No description provided for @action_label.
  ///
  /// In en, this message translates to:
  /// **'Action'**
  String get action_label;

  /// No description provided for @destination_label.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get destination_label;

  /// No description provided for @markdown_source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get markdown_source;

  /// No description provided for @preview_label.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview_label;

  /// No description provided for @share_action_summarize.
  ///
  /// In en, this message translates to:
  /// **'Summarize'**
  String get share_action_summarize;

  /// No description provided for @share_action_explain.
  ///
  /// In en, this message translates to:
  /// **'Explain'**
  String get share_action_explain;

  /// No description provided for @share_action_research.
  ///
  /// In en, this message translates to:
  /// **'Research'**
  String get share_action_research;

  /// No description provided for @share_action_remember.
  ///
  /// In en, this message translates to:
  /// **'Remember'**
  String get share_action_remember;

  /// No description provided for @text_size_small.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get text_size_small;

  /// No description provided for @text_size_default.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get text_size_default;

  /// No description provided for @text_size_large.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get text_size_large;

  /// No description provided for @text_size_extra_large.
  ///
  /// In en, this message translates to:
  /// **'Extra large'**
  String get text_size_extra_large;

  /// No description provided for @text_size_use_system_description.
  ///
  /// In en, this message translates to:
  /// **'Use Android accessibility text size exactly.'**
  String get text_size_use_system_description;

  /// No description provided for @text_size_percent_description.
  ///
  /// In en, this message translates to:
  /// **'{percent}% of the Android text size.'**
  String text_size_percent_description(Object percent);

  /// No description provided for @text_size_label_description.
  ///
  /// In en, this message translates to:
  /// **'{label} — {description}'**
  String text_size_label_description(Object description, Object label);

  /// No description provided for @files_skipped.
  ///
  /// In en, this message translates to:
  /// **'{count} file(s) skipped: limit, size, unreadable, or sensitive filename.'**
  String files_skipped(Object count);

  /// No description provided for @model_scope_applied.
  ///
  /// In en, this message translates to:
  /// **'{model} • {effort} now apply only to this chat.'**
  String model_scope_applied(Object effort, Object model);

  /// No description provided for @reasoning_minimal.
  ///
  /// In en, this message translates to:
  /// **'Minimal'**
  String get reasoning_minimal;

  /// No description provided for @reasoning_low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get reasoning_low;

  /// No description provided for @reasoning_medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get reasoning_medium;

  /// No description provided for @reasoning_high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get reasoning_high;

  /// No description provided for @reasoning_max.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get reasoning_max;

  /// No description provided for @reasoning_ultra.
  ///
  /// In en, this message translates to:
  /// **'Ultra'**
  String get reasoning_ultra;

  /// No description provided for @status_running.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get status_running;

  /// No description provided for @status_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get status_failed;

  /// No description provided for @status_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get status_done;

  /// No description provided for @status_idle.
  ///
  /// In en, this message translates to:
  /// **'Idle'**
  String get status_idle;

  /// No description provided for @upload_status_uploading.
  ///
  /// In en, this message translates to:
  /// **'Uploading'**
  String get upload_status_uploading;

  /// No description provided for @upload_status_uploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded'**
  String get upload_status_uploaded;

  /// No description provided for @attachment_count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} attachment} other{{count} attachments}}'**
  String attachment_count(num count);

  /// No description provided for @action_create.
  ///
  /// In en, this message translates to:
  /// **'create'**
  String get action_create;

  /// No description provided for @action_rename.
  ///
  /// In en, this message translates to:
  /// **'rename'**
  String get action_rename;

  /// No description provided for @action_archive.
  ///
  /// In en, this message translates to:
  /// **'archive'**
  String get action_archive;

  /// No description provided for @action_restore.
  ///
  /// In en, this message translates to:
  /// **'restore'**
  String get action_restore;

  /// No description provided for @action_delete.
  ///
  /// In en, this message translates to:
  /// **'delete'**
  String get action_delete;

  /// No description provided for @migrate.
  ///
  /// In en, this message translates to:
  /// **'Migrate'**
  String get migrate;

  /// No description provided for @assigned_chats.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} assigned chat} other{{count} assigned chats}}'**
  String assigned_chats(num count);

  /// No description provided for @date_today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get date_today;

  /// No description provided for @date_yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get date_yesterday;

  /// No description provided for @date_earlier.
  ///
  /// In en, this message translates to:
  /// **'Earlier'**
  String get date_earlier;

  /// No description provided for @nav_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get nav_home;

  /// No description provided for @nav_more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get nav_more;

  /// No description provided for @status_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get status_completed;

  /// No description provided for @filter_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filter_all;

  /// No description provided for @filter_recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get filter_recent;

  /// No description provided for @connection_address_key.
  ///
  /// In en, this message translates to:
  /// **'{address}  •  Key: {status}'**
  String connection_address_key(Object address, Object status);

  /// No description provided for @model_via_provider.
  ///
  /// In en, this message translates to:
  /// **'{model}  \nvia `{provider}`'**
  String model_via_provider(Object model, Object provider);

  /// No description provided for @deny.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get deny;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @connection_section.
  ///
  /// In en, this message translates to:
  /// **'Connection'**
  String get connection_section;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @version_label.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String version_label(Object version);

  /// No description provided for @matched.
  ///
  /// In en, this message translates to:
  /// **'Matched'**
  String get matched;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @on.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get on;

  /// No description provided for @off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get off;

  /// No description provided for @reasoning_off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get reasoning_off;

  /// No description provided for @hermes_response_ready.
  ///
  /// In en, this message translates to:
  /// **'Hermes response ready'**
  String get hermes_response_ready;

  /// No description provided for @admin_password_needed.
  ///
  /// In en, this message translates to:
  /// **'Administrator password needed'**
  String get admin_password_needed;

  /// No description provided for @hermes_needs_a_sudo_password_for_the_pending_terminal_command.
  ///
  /// In en, this message translates to:
  /// **'Hermes needs a sudo password for the pending terminal command.'**
  String get hermes_needs_a_sudo_password_for_the_pending_terminal_command;

  /// No description provided for @sudo_password.
  ///
  /// In en, this message translates to:
  /// **'Sudo password'**
  String get sudo_password;

  /// No description provided for @secret_needed.
  ///
  /// In en, this message translates to:
  /// **'Secret needed'**
  String get secret_needed;

  /// No description provided for @hermes_needs_a_secret_for_the_pending_skill.
  ///
  /// In en, this message translates to:
  /// **'Hermes needs a secret for the pending skill.'**
  String get hermes_needs_a_secret_for_the_pending_skill;

  /// No description provided for @secret_value.
  ///
  /// In en, this message translates to:
  /// **'Secret value'**
  String get secret_value;

  /// No description provided for @attached_file.
  ///
  /// In en, this message translates to:
  /// **'Attached file'**
  String get attached_file;

  /// No description provided for @pin_chat.
  ///
  /// In en, this message translates to:
  /// **'Pin chat'**
  String get pin_chat;

  /// No description provided for @unpin_chat.
  ///
  /// In en, this message translates to:
  /// **'Unpin chat'**
  String get unpin_chat;

  /// No description provided for @pinned_chats.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get pinned_chats;

  /// No description provided for @could_not_update_chat_pin.
  ///
  /// In en, this message translates to:
  /// **'Could not update chat pin: {error}'**
  String could_not_update_chat_pin(Object error);

  /// No description provided for @could_not_save_chat_spaces.
  ///
  /// In en, this message translates to:
  /// **'Could not save chat spaces on this device'**
  String get could_not_save_chat_spaces;

  /// No description provided for @chat_density.
  ///
  /// In en, this message translates to:
  /// **'Chat density'**
  String get chat_density;

  /// No description provided for @chat_density_2.
  ///
  /// In en, this message translates to:
  /// **'Chat density: {label}'**
  String chat_density_2(Object label);

  /// No description provided for @chat_density_comfortable.
  ///
  /// In en, this message translates to:
  /// **'Comfortable'**
  String get chat_density_comfortable;

  /// No description provided for @chat_density_compact.
  ///
  /// In en, this message translates to:
  /// **'Compact'**
  String get chat_density_compact;

  /// No description provided for @chat_density_comfortable_description.
  ///
  /// In en, this message translates to:
  /// **'Roomier bubbles with a sender label above each message.'**
  String get chat_density_comfortable_description;

  /// No description provided for @chat_density_compact_description.
  ///
  /// In en, this message translates to:
  /// **'Tighter, unlabelled bubbles so more messages fit on screen.'**
  String get chat_density_compact_description;

  /// No description provided for @chat_density_label_description.
  ///
  /// In en, this message translates to:
  /// **'{label} — {description}'**
  String chat_density_label_description(Object description, Object label);

  /// No description provided for @compact_removes_the_you_and_hermes_labels_and_trims_bubble_padding_spacing_and_side_margins.
  ///
  /// In en, this message translates to:
  /// **'Compact removes the You and Hermes labels and trims bubble padding, spacing, and side margins.'**
  String
  get compact_removes_the_you_and_hermes_labels_and_trims_bubble_padding_spacing_and_side_margins;

  /// No description provided for @client_certificate_mtls.
  ///
  /// In en, this message translates to:
  /// **'Client certificate (mTLS)'**
  String get client_certificate_mtls;

  /// No description provided for @client_certificate_mtls_description.
  ///
  /// In en, this message translates to:
  /// **'Present a certificate when an HTTPS proxy requires mutual TLS.'**
  String get client_certificate_mtls_description;

  /// No description provided for @client_certificate_https_only.
  ///
  /// In en, this message translates to:
  /// **'Client certificates are only used for HTTPS connections.'**
  String get client_certificate_https_only;

  /// No description provided for @choose_certificate.
  ///
  /// In en, this message translates to:
  /// **'Choose certificate'**
  String get choose_certificate;

  /// No description provided for @certificate_password.
  ///
  /// In en, this message translates to:
  /// **'Certificate password'**
  String get certificate_password;

  /// No description provided for @this_certificate_is_password_protected.
  ///
  /// In en, this message translates to:
  /// **'This certificate is password-protected. It opens as you type.'**
  String get this_certificate_is_password_protected;

  /// No description provided for @enter_the_certificate_password_to_finish_loading_it.
  ///
  /// In en, this message translates to:
  /// **'Enter the certificate password to finish loading the certificate you chose.'**
  String get enter_the_certificate_password_to_finish_loading_it;

  /// No description provided for @client_certificate_required.
  ///
  /// In en, this message translates to:
  /// **'Load a client certificate or turn off the client certificate option.'**
  String get client_certificate_required;

  /// No description provided for @client_certificate_loaded.
  ///
  /// In en, this message translates to:
  /// **'Loaded: {label}'**
  String client_certificate_loaded(String label);

  /// No description provided for @remove_certificate.
  ///
  /// In en, this message translates to:
  /// **'Remove certificate'**
  String get remove_certificate;

  /// No description provided for @certificate_import_failed.
  ///
  /// In en, this message translates to:
  /// **'That certificate could not be loaded.'**
  String get certificate_import_failed;

  /// No description provided for @background_work.
  ///
  /// In en, this message translates to:
  /// **'Background work'**
  String get background_work;

  /// No description provided for @keep_chats_active_in_background.
  ///
  /// In en, this message translates to:
  /// **'Keep chats active in the background'**
  String get keep_chats_active_in_background;

  /// No description provided for @background_work_description.
  ///
  /// In en, this message translates to:
  /// **'Keep user-started chats connected while this app is in the background. Idle connections may disconnect. Uses more battery and network data. Turning this off does not stop work on the server.'**
  String get background_work_description;

  /// No description provided for @background_work_limits.
  ///
  /// In en, this message translates to:
  /// **'Android may still suspend connections during Doze or end the app process. Notifications after process death require the separate push setup. Force stop is not supported.'**
  String get background_work_limits;

  /// No description provided for @background_work_disclosure.
  ///
  /// In en, this message translates to:
  /// **'A required service notification stays visible while background protection is active, even when optional chat notifications are off.'**
  String get background_work_disclosure;

  /// No description provided for @battery_optimisation_settings.
  ///
  /// In en, this message translates to:
  /// **'Battery optimisation settings'**
  String get battery_optimisation_settings;

  /// No description provided for @battery_optimisation_description.
  ///
  /// In en, this message translates to:
  /// **'Open Android settings to review battery restrictions. No exemption is requested automatically, and changing settings does not guarantee delivery.'**
  String get battery_optimisation_description;

  /// No description provided for @battery_settings_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Battery settings could not be opened on this device.'**
  String get battery_settings_unavailable;

  /// No description provided for @background_work_save_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not save the background work setting.'**
  String get background_work_save_failed;

  /// No description provided for @ongoing_chat_channel_name.
  ///
  /// In en, this message translates to:
  /// **'Active chats'**
  String get ongoing_chat_channel_name;

  /// No description provided for @ongoing_chat_channel_description.
  ///
  /// In en, this message translates to:
  /// **'Quiet status updates for unresolved user-started chats'**
  String get ongoing_chat_channel_description;

  /// No description provided for @task_timeline.
  ///
  /// In en, this message translates to:
  /// **'Task timeline'**
  String get task_timeline;

  /// No description provided for @task_refresh_history.
  ///
  /// In en, this message translates to:
  /// **'Refresh task history'**
  String get task_refresh_history;

  /// No description provided for @task_live_preview.
  ///
  /// In en, this message translates to:
  /// **'Live preview from parent events'**
  String get task_live_preview;

  /// No description provided for @task_preview_explanation.
  ///
  /// In en, this message translates to:
  /// **'Latest exposed preview only; not a recorded transcript row.'**
  String get task_preview_explanation;

  /// No description provided for @task_preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get task_preview;

  /// No description provided for @task_recorded_history.
  ///
  /// In en, this message translates to:
  /// **'Recorded task history'**
  String get task_recorded_history;

  /// No description provided for @task_loading_history.
  ///
  /// In en, this message translates to:
  /// **'Loading task history…'**
  String get task_loading_history;

  /// No description provided for @task_empty_history.
  ///
  /// In en, this message translates to:
  /// **'No recorded messages yet. The task may not have flushed its history; this does not mean it produced no work.'**
  String get task_empty_history;

  /// No description provided for @task_load_older.
  ///
  /// In en, this message translates to:
  /// **'Load older'**
  String get task_load_older;

  /// No description provided for @task_default_goal.
  ///
  /// In en, this message translates to:
  /// **'Delegated task'**
  String get task_default_goal;

  /// No description provided for @task_status.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String task_status(Object status);

  /// No description provided for @task_identity.
  ///
  /// In en, this message translates to:
  /// **'Task: {id}'**
  String task_identity(Object id);

  /// No description provided for @task_stored_session.
  ///
  /// In en, this message translates to:
  /// **'Stored session: {id}'**
  String task_stored_session(Object id);

  /// No description provided for @task_delegation.
  ///
  /// In en, this message translates to:
  /// **'Delegation: {id}'**
  String task_delegation(Object id);

  /// No description provided for @task_read_only_notice.
  ///
  /// In en, this message translates to:
  /// **'Read-only · recorded history may appear after the task flushes. Refresh to check again.'**
  String get task_read_only_notice;

  /// No description provided for @task_row_label.
  ///
  /// In en, this message translates to:
  /// **'{role} · row {id}'**
  String task_row_label(Object id, Object role);

  /// No description provided for @task_role_assistant.
  ///
  /// In en, this message translates to:
  /// **'Assistant'**
  String get task_role_assistant;

  /// No description provided for @task_role_user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get task_role_user;

  /// No description provided for @task_role_tool.
  ///
  /// In en, this message translates to:
  /// **'Tool'**
  String get task_role_tool;

  /// No description provided for @task_tool_call.
  ///
  /// In en, this message translates to:
  /// **'Tool call · {name}'**
  String task_tool_call(Object name);

  /// No description provided for @task_tool_result.
  ///
  /// In en, this message translates to:
  /// **'Tool result · {name}'**
  String task_tool_result(Object name);

  /// No description provided for @task_call_details.
  ///
  /// In en, this message translates to:
  /// **'Call ID: {id}\nArguments\n{arguments}'**
  String task_call_details(Object arguments, Object id);

  /// No description provided for @task_result_details.
  ///
  /// In en, this message translates to:
  /// **'Call ID: {id}\nResult\n{result}'**
  String task_result_details(Object id, Object result);

  /// No description provided for @task_not_supplied.
  ///
  /// In en, this message translates to:
  /// **'Not supplied'**
  String get task_not_supplied;

  /// No description provided for @task_missing_arguments.
  ///
  /// In en, this message translates to:
  /// **'Arguments not retained by the server.'**
  String get task_missing_arguments;

  /// No description provided for @task_image_placeholder.
  ///
  /// In en, this message translates to:
  /// **'[image]'**
  String get task_image_placeholder;

  /// No description provided for @task_invalid_reference.
  ///
  /// In en, this message translates to:
  /// **'Task transcript unavailable: invalid stored session reference.'**
  String get task_invalid_reference;

  /// No description provided for @task_auth_required.
  ///
  /// In en, this message translates to:
  /// **'Task transcript unavailable: configure Dashboard authentication for this gateway. The API-server key cannot read task reasoning.'**
  String get task_auth_required;

  /// No description provided for @task_auth_rejected.
  ///
  /// In en, this message translates to:
  /// **'Task transcript unavailable: Dashboard authentication was rejected. Check this gateway’s Dashboard settings.'**
  String get task_auth_rejected;

  /// No description provided for @task_incompatible_history.
  ///
  /// In en, this message translates to:
  /// **'Task transcript unavailable: this Dashboard does not provide compatible bounded raw history for the selected profile.'**
  String get task_incompatible_history;

  /// No description provided for @task_identity_unproven.
  ///
  /// In en, this message translates to:
  /// **'Task transcript unavailable: the Dashboard could not prove the exact stored session or its compression lineage. No transcript from another session is shown.'**
  String get task_identity_unproven;

  /// No description provided for @task_partial_compression.
  ///
  /// In en, this message translates to:
  /// **'Partial history: this task continued after compression, but this gateway has not exposed a verifiable newer reference. The final reply may be missing. Automatic refresh is paused; use Refresh to retry.'**
  String get task_partial_compression;

  /// No description provided for @task_partial_ancestors.
  ///
  /// In en, this message translates to:
  /// **'Partial history: this gateway omits compression ancestors for this task. Earlier task segments may be missing. Known rows are retained; use Refresh to retry.'**
  String get task_partial_ancestors;

  /// No description provided for @task_missing_reference.
  ///
  /// In en, this message translates to:
  /// **'Task transcript unavailable: this server did not retain its session reference.'**
  String get task_missing_reference;

  /// No description provided for @task_missing_row_identity.
  ///
  /// In en, this message translates to:
  /// **'Task transcript unavailable: this server did not supply durable message row identities.'**
  String get task_missing_row_identity;

  /// No description provided for @task_history_not_ready.
  ///
  /// In en, this message translates to:
  /// **'Task history is not available yet (HTTP 404). The task may not have flushed, or this Dashboard may not support task history. Retry to check again.'**
  String get task_history_not_ready;

  /// No description provided for @task_refresh_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh task history. Check the connection and retry.'**
  String get task_refresh_failed;

  /// No description provided for @task_status_interrupted.
  ///
  /// In en, this message translates to:
  /// **'Interrupted'**
  String get task_status_interrupted;

  /// No description provided for @task_status_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get task_status_cancelled;

  /// No description provided for @task_status_requested.
  ///
  /// In en, this message translates to:
  /// **'Requested'**
  String get task_status_requested;

  /// No description provided for @task_status_thinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking'**
  String get task_status_thinking;

  /// No description provided for @task_status_tool.
  ///
  /// In en, this message translates to:
  /// **'Using a tool'**
  String get task_status_tool;

  /// No description provided for @task_status_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get task_status_pending;

  /// No description provided for @task_status_dispatched.
  ///
  /// In en, this message translates to:
  /// **'Dispatched'**
  String get task_status_dispatched;

  /// No description provided for @task_status_unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown status: {status}'**
  String task_status_unknown(Object status);

  /// No description provided for @task_tasks_finished.
  ///
  /// In en, this message translates to:
  /// **'{count} delegated task(s) finished'**
  String task_tasks_finished(Object count);

  /// No description provided for @activity_status_unconfirmed.
  ///
  /// In en, this message translates to:
  /// **'Status unconfirmed'**
  String get activity_status_unconfirmed;

  /// No description provided for @activity_recently_updated.
  ///
  /// In en, this message translates to:
  /// **'Recently updated'**
  String get activity_recently_updated;

  /// No description provided for @activity_reconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting — checking the turn status'**
  String get activity_reconnecting;

  /// No description provided for @activity_outcome_unknown.
  ///
  /// In en, this message translates to:
  /// **'The turn’s outcome could not be confirmed. Open the chat to check.'**
  String get activity_outcome_unknown;

  /// No description provided for @activity_chat_updated_detail.
  ///
  /// In en, this message translates to:
  /// **'Chat activity recorded by the gateway; live turn status is unavailable.'**
  String get activity_chat_updated_detail;

  /// No description provided for @activity_updated.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get activity_updated;

  /// No description provided for @activity_empty_title.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get activity_empty_title;

  /// No description provided for @activity_empty_detail.
  ///
  /// In en, this message translates to:
  /// **'Turns started in this app and gateway chats updated in the last 7 days appear here.'**
  String get activity_empty_detail;

  /// No description provided for @activity_read_error.
  ///
  /// In en, this message translates to:
  /// **'Activity could not read its turn records or gateway chats. Check the connection and try again.'**
  String get activity_read_error;

  /// No description provided for @activity_chat_unavailable.
  ///
  /// In en, this message translates to:
  /// **'This chat is no longer available, or the gateway could not be reached.'**
  String get activity_chat_unavailable;

  /// No description provided for @activity_partial_title.
  ///
  /// In en, this message translates to:
  /// **'Activity partially loaded'**
  String get activity_partial_title;

  /// No description provided for @activity_partial_detail.
  ///
  /// In en, this message translates to:
  /// **'Showing a limited window of gateway activity. More chats may exist; pull to refresh.'**
  String get activity_partial_detail;

  /// No description provided for @provider_usage.
  ///
  /// In en, this message translates to:
  /// **'Recorded usage'**
  String get provider_usage;

  /// No description provided for @provider_usage_notice.
  ///
  /// In en, this message translates to:
  /// **'Hermes usage for the last 30 days, not account credits or model pricing. Configure provider credentials on the Hermes server; this app does not store provider API keys.'**
  String get provider_usage_notice;

  /// No description provided for @provider_usage_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not load recorded usage.'**
  String get provider_usage_failed;

  /// No description provided for @provider_usage_empty.
  ///
  /// In en, this message translates to:
  /// **'No recorded usage for this provider.'**
  String get provider_usage_empty;

  /// No description provided for @provider_usage_counts.
  ///
  /// In en, this message translates to:
  /// **'{sessions} sessions · Input: {input} · Output: {output}'**
  String provider_usage_counts(String sessions, String input, String output);

  /// No description provided for @provider_usage_costs.
  ///
  /// In en, this message translates to:
  /// **'Estimated: {estimated} · Reported: {actual}'**
  String provider_usage_costs(String estimated, String actual);

  /// No description provided for @provider_quota_codex.
  ///
  /// In en, this message translates to:
  /// **'OpenAI Codex subscription'**
  String get provider_quota_codex;

  /// No description provided for @provider_quota_claude.
  ///
  /// In en, this message translates to:
  /// **'Claude subscription'**
  String get provider_quota_claude;

  /// No description provided for @provider_quota_openai_api.
  ///
  /// In en, this message translates to:
  /// **'OpenAI API recorded usage'**
  String get provider_quota_openai_api;

  /// No description provided for @provider_quota_notice.
  ///
  /// In en, this message translates to:
  /// **'Provider-reported subscription windows, separate from Hermes recorded usage and API billing. Accounts are shown separately; model limits do not mean the whole account is exhausted.'**
  String get provider_quota_notice;

  /// No description provided for @provider_quota_windows_notice.
  ///
  /// In en, this message translates to:
  /// **'Codex and Claude subscriptions use five-hour session and weekly limits. Only provider-reported windows are shown; missing limits and reset times remain unavailable. Weekly limits may apply to the account or specific models.'**
  String get provider_quota_windows_notice;

  /// No description provided for @provider_quota_five_hour_session.
  ///
  /// In en, this message translates to:
  /// **'5-hour session'**
  String get provider_quota_five_hour_session;

  /// No description provided for @provider_quota_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Subscription allowance unavailable.'**
  String get provider_quota_unavailable;

  /// No description provided for @provider_quota_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not refresh subscription allowance. Any retained values are from the previous read.'**
  String get provider_quota_failed;

  /// No description provided for @provider_quota_account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get provider_quota_account;

  /// No description provided for @provider_quota_unknown.
  ///
  /// In en, this message translates to:
  /// **'unknown'**
  String get provider_quota_unknown;

  /// No description provided for @provider_quota_state.
  ///
  /// In en, this message translates to:
  /// **'Account state: {state}'**
  String provider_quota_state(String state);

  /// No description provided for @provider_quota_scope.
  ///
  /// In en, this message translates to:
  /// **'Scope: {scope}'**
  String provider_quota_scope(String scope);

  /// No description provided for @provider_quota_percent.
  ///
  /// In en, this message translates to:
  /// **'{used}% used · {remaining}% remaining'**
  String provider_quota_percent(String used, String remaining);

  /// No description provided for @provider_quota_reset.
  ///
  /// In en, this message translates to:
  /// **'Resets: {reset}'**
  String provider_quota_reset(String reset);

  /// No description provided for @provider_quota_reset_unknown.
  ///
  /// In en, this message translates to:
  /// **'Reset time unavailable.'**
  String get provider_quota_reset_unknown;

  /// No description provided for @auxiliary_models.
  ///
  /// In en, this message translates to:
  /// **'Auxiliary models'**
  String get auxiliary_models;

  /// No description provided for @auxiliary_notice.
  ///
  /// In en, this message translates to:
  /// **'Choose models for individual tasks. Custom endpoints must be managed on the server. Auto follows the task’s inheritance rules.'**
  String get auxiliary_notice;

  /// No description provided for @auxiliary_inherit.
  ///
  /// In en, this message translates to:
  /// **'Auto (inherit)'**
  String get auxiliary_inherit;

  /// No description provided for @auxiliary_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Auxiliary settings are unavailable.'**
  String get auxiliary_unavailable;

  /// No description provided for @provider_oauth_title.
  ///
  /// In en, this message translates to:
  /// **'Provider sign-in'**
  String get provider_oauth_title;

  /// No description provided for @provider_oauth_more_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage provider login on your Hermes host'**
  String get provider_oauth_more_subtitle;

  /// No description provided for @provider_oauth_settings_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in on your Hermes host; provider tokens stay off this device'**
  String get provider_oauth_settings_subtitle;

  /// No description provided for @provider_oauth_intro.
  ///
  /// In en, this message translates to:
  /// **'Sign in with your provider in an external browser. Tokens are stored only on your Hermes host, not this device. Signing in does not select a chat model in this app.'**
  String get provider_oauth_intro;

  /// No description provided for @provider_oauth_defaults_notice.
  ///
  /// In en, this message translates to:
  /// **'Some host flows, including Nous free-tier account replacement, may update host defaults. Review your host settings after signing in.'**
  String get provider_oauth_defaults_notice;

  /// No description provided for @provider_oauth_transport_init_failed.
  ///
  /// In en, this message translates to:
  /// **'The selected secure dashboard transport could not be initialized. Check its TLS identity and connection settings.'**
  String get provider_oauth_transport_init_failed;

  /// No description provided for @provider_oauth_https_required.
  ///
  /// In en, this message translates to:
  /// **'Provider sign-in requires an HTTPS Hermes dashboard connection.'**
  String get provider_oauth_https_required;

  /// No description provided for @provider_oauth_auth_required.
  ///
  /// In en, this message translates to:
  /// **'Configure dashboard password authentication or a trusted proxy before signing in.'**
  String get provider_oauth_auth_required;

  /// No description provided for @provider_oauth_catalog_failed.
  ///
  /// In en, this message translates to:
  /// **'Provider sign-in is unavailable on this host. Check dashboard authentication and update the host if it does not support provider OAuth.'**
  String get provider_oauth_catalog_failed;

  /// No description provided for @provider_oauth_expired.
  ///
  /// In en, this message translates to:
  /// **'Sign-in expired. Start again.'**
  String get provider_oauth_expired;

  /// No description provided for @provider_oauth_start_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not start secure provider sign-in. Please try again.'**
  String get provider_oauth_start_failed;

  /// No description provided for @provider_oauth_denied.
  ///
  /// In en, this message translates to:
  /// **'Sign-in was denied. Start again.'**
  String get provider_oauth_denied;

  /// No description provided for @provider_oauth_cancelled.
  ///
  /// In en, this message translates to:
  /// **'Sign-in cancelled.'**
  String get provider_oauth_cancelled;

  /// No description provided for @provider_oauth_host_failed.
  ///
  /// In en, this message translates to:
  /// **'The host could not complete sign-in. Start again.'**
  String get provider_oauth_host_failed;

  /// No description provided for @provider_oauth_poll_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not check sign-in status. Start again.'**
  String get provider_oauth_poll_failed;

  /// No description provided for @provider_oauth_cancellation_unconfirmed.
  ///
  /// In en, this message translates to:
  /// **'{message} Cancellation could not be confirmed; the host session may continue until it expires.'**
  String provider_oauth_cancellation_unconfirmed(String message);

  /// No description provided for @provider_oauth_browser_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not open the external browser. Try again or cancel sign-in.'**
  String get provider_oauth_browser_failed;

  /// No description provided for @provider_oauth_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get provider_oauth_retry;

  /// No description provided for @provider_oauth_complete.
  ///
  /// In en, this message translates to:
  /// **'Complete sign-in for {provider}'**
  String provider_oauth_complete(String provider);

  /// No description provided for @provider_oauth_code_instruction.
  ///
  /// In en, this message translates to:
  /// **'Enter this temporary code on the provider page:'**
  String get provider_oauth_code_instruction;

  /// No description provided for @provider_oauth_waiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for approval. This session expires automatically.'**
  String get provider_oauth_waiting;

  /// No description provided for @provider_oauth_open_browser.
  ///
  /// In en, this message translates to:
  /// **'Open provider in browser'**
  String get provider_oauth_open_browser;

  /// No description provided for @provider_oauth_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel sign-in'**
  String get provider_oauth_cancel;

  /// No description provided for @provider_oauth_signed_out.
  ///
  /// In en, this message translates to:
  /// **'Not signed in on host'**
  String get provider_oauth_signed_out;

  /// No description provided for @provider_oauth_sign_in_again.
  ///
  /// In en, this message translates to:
  /// **'Sign in again'**
  String get provider_oauth_sign_in_again;

  /// No description provided for @provider_oauth_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get provider_oauth_sign_in;

  /// No description provided for @provider_oauth_cli_required.
  ///
  /// In en, this message translates to:
  /// **'Sign in using the provider CLI on your Hermes host. This host does not offer an in-app login for this provider.'**
  String get provider_oauth_cli_required;

  /// No description provided for @provider_oauth_checking_account.
  ///
  /// In en, this message translates to:
  /// **'Approval received. Checking host account…'**
  String get provider_oauth_checking_account;

  /// No description provided for @provider_oauth_verification_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Approval received; account verification unavailable. Open Usage to refresh account usage.'**
  String get provider_oauth_verification_unavailable;

  /// No description provided for @provider_oauth_verified_account.
  ///
  /// In en, this message translates to:
  /// **'Signed in on the Hermes host as {email}. Open Usage to refresh account usage.'**
  String provider_oauth_verified_account(String email);

  /// No description provided for @provider_oauth_credentials_unverified.
  ///
  /// In en, this message translates to:
  /// **'Host reports credentials available; account identity unverified.'**
  String get provider_oauth_credentials_unverified;

  /// No description provided for @provider_oauth_account_status_unknown.
  ///
  /// In en, this message translates to:
  /// **'Host account status unavailable.'**
  String get provider_oauth_account_status_unknown;

  /// No description provided for @app_language.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get app_language;

  /// No description provided for @app_language_system.
  ///
  /// In en, this message translates to:
  /// **'Same as phone'**
  String get app_language_system;

  /// No description provided for @auto_archives_after_72_hours.
  ///
  /// In en, this message translates to:
  /// **'Auto-archives after 72 hours'**
  String get auto_archives_after_72_hours;

  /// No description provided for @automation.
  ///
  /// In en, this message translates to:
  /// **'Automation'**
  String get automation;

  /// No description provided for @voice_recording_start.
  ///
  /// In en, this message translates to:
  /// **'Record voice message'**
  String get voice_recording_start;

  /// No description provided for @voice_recording_pause.
  ///
  /// In en, this message translates to:
  /// **'Pause recording'**
  String get voice_recording_pause;

  /// No description provided for @voice_recording_preview.
  ///
  /// In en, this message translates to:
  /// **'Play recording'**
  String get voice_recording_preview;

  /// No description provided for @voice_recording_resume.
  ///
  /// In en, this message translates to:
  /// **'Continue recording'**
  String get voice_recording_resume;

  /// No description provided for @voice_recording_send.
  ///
  /// In en, this message translates to:
  /// **'Send voice message'**
  String get voice_recording_send;

  /// No description provided for @voice_recording_discard.
  ///
  /// In en, this message translates to:
  /// **'Discard recording'**
  String get voice_recording_discard;

  /// No description provided for @voice_recording_processing.
  ///
  /// In en, this message translates to:
  /// **'Preparing voice message…'**
  String get voice_recording_processing;

  /// No description provided for @voice_recording_elapsed.
  ///
  /// In en, this message translates to:
  /// **'Recording {time}'**
  String voice_recording_elapsed(String time);

  /// No description provided for @voice_recording_draft.
  ///
  /// In en, this message translates to:
  /// **'Voice message {time}'**
  String voice_recording_draft(String time);

  /// No description provided for @voice_recording_permission.
  ///
  /// In en, this message translates to:
  /// **'Allow microphone access to record a voice message.'**
  String get voice_recording_permission;

  /// No description provided for @voice_recording_limit.
  ///
  /// In en, this message translates to:
  /// **'This recording has reached the ten-minute limit.'**
  String get voice_recording_limit;

  /// No description provided for @voice_recording_empty.
  ///
  /// In en, this message translates to:
  /// **'No audio was recorded. Try again.'**
  String get voice_recording_empty;

  /// No description provided for @voice_recording_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not process the recording. Any saved fragments have been kept.'**
  String get voice_recording_failed;

  /// No description provided for @voice_recording_unconfirmed.
  ///
  /// In en, this message translates to:
  /// **'Delivery was not confirmed. Your recording is saved. Check the chat before trying again.'**
  String get voice_recording_unconfirmed;

  /// No description provided for @voice_recording_submit_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not send the voice message. Your recording is saved. Check the connection, Dashboard access and server transcription settings.'**
  String get voice_recording_submit_failed;

  /// No description provided for @voice_recording_pause_playback.
  ///
  /// In en, this message translates to:
  /// **'Pause playback'**
  String get voice_recording_pause_playback;

  /// No description provided for @projects_root_title.
  ///
  /// In en, this message translates to:
  /// **'Projects folder on the server'**
  String get projects_root_title;

  /// No description provided for @projects_root_more_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Where new server-side Project folders are created'**
  String get projects_root_more_subtitle;

  /// No description provided for @projects_root_description.
  ///
  /// In en, this message translates to:
  /// **'Projects you create on this phone get their folder here. Point it at the folder Hermes itself uses so the phone and the server share the same Projects.'**
  String get projects_root_description;

  /// No description provided for @projects_root_label.
  ///
  /// In en, this message translates to:
  /// **'Projects root path'**
  String get projects_root_label;

  /// No description provided for @projects_root_default_hint.
  ///
  /// In en, this message translates to:
  /// **'Server default: {path}'**
  String projects_root_default_hint(String path);

  /// No description provided for @projects_root_locked_title.
  ///
  /// In en, this message translates to:
  /// **'Set by the server'**
  String get projects_root_locked_title;

  /// No description provided for @projects_root_locked_explanation.
  ///
  /// In en, this message translates to:
  /// **'This server restricts file access to a single root, so the Projects folder cannot be changed from the app.'**
  String get projects_root_locked_explanation;

  /// No description provided for @projects_root_saved.
  ///
  /// In en, this message translates to:
  /// **'Projects folder saved.'**
  String get projects_root_saved;

  /// No description provided for @projects_root_reset.
  ///
  /// In en, this message translates to:
  /// **'Use the server default'**
  String get projects_root_reset;

  /// No description provided for @projects_root_invalid_empty.
  ///
  /// In en, this message translates to:
  /// **'Enter a folder path.'**
  String get projects_root_invalid_empty;

  /// No description provided for @projects_root_invalid_absolute.
  ///
  /// In en, this message translates to:
  /// **'Enter an absolute path that starts with a slash.'**
  String get projects_root_invalid_absolute;

  /// No description provided for @projects_root_invalid_segments.
  ///
  /// In en, this message translates to:
  /// **'Remove dot segments and control characters from the path.'**
  String get projects_root_invalid_segments;

  /// No description provided for @projects_root_unsupported.
  ///
  /// In en, this message translates to:
  /// **'Not supported on this connection. A Desktop Gateway connection with Dashboard access is needed to read or change the server\'s Projects folder.'**
  String get projects_root_unsupported;

  /// No description provided for @projects_root_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Could not read the server\'s Projects folder. Check the Dashboard connection, then retry.'**
  String get projects_root_unavailable;

  /// No description provided for @adopt_folder_action.
  ///
  /// In en, this message translates to:
  /// **'Add an existing folder'**
  String get adopt_folder_action;

  /// No description provided for @adopt_folder_description.
  ///
  /// In en, this message translates to:
  /// **'Folders under {root} that are not registered as a Project yet.'**
  String adopt_folder_description(String root);

  /// No description provided for @adopt_folder_registered.
  ///
  /// In en, this message translates to:
  /// **'Already a Project: {name}'**
  String adopt_folder_registered(String name);

  /// No description provided for @adopt_folder_none.
  ///
  /// In en, this message translates to:
  /// **'Every folder under this path is already a Project.'**
  String get adopt_folder_none;

  /// No description provided for @adopt_folder_unsupported.
  ///
  /// In en, this message translates to:
  /// **'This connection cannot list server folders. Enter the absolute path of an existing folder instead.'**
  String get adopt_folder_unsupported;

  /// No description provided for @adopt_folder_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not list server folders: {error}'**
  String adopt_folder_failed(String error);

  /// No description provided for @adopt_folder_manual_label.
  ///
  /// In en, this message translates to:
  /// **'Existing folder path'**
  String get adopt_folder_manual_label;

  /// No description provided for @adopt_folder_name_label.
  ///
  /// In en, this message translates to:
  /// **'Project name'**
  String get adopt_folder_name_label;

  /// No description provided for @adopt_folder_add.
  ///
  /// In en, this message translates to:
  /// **'Add as Project'**
  String get adopt_folder_add;

  /// No description provided for @adopt_folder_added.
  ///
  /// In en, this message translates to:
  /// **'{name} now uses {path}'**
  String adopt_folder_added(String name, String path);

  /// No description provided for @adopt_folder_error.
  ///
  /// In en, this message translates to:
  /// **'Could not add the folder: {error}'**
  String adopt_folder_error(String error);

  /// No description provided for @adopt_folder_folderless.
  ///
  /// In en, this message translates to:
  /// **'{name} was created, but the folder was not attached. Attach it from Hermes on the server.'**
  String adopt_folder_folderless(String name);

  /// No description provided for @slash_commands.
  ///
  /// In en, this message translates to:
  /// **'Slash commands'**
  String get slash_commands;

  /// No description provided for @slash_commands_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading commands…'**
  String get slash_commands_loading;

  /// No description provided for @slash_commands_empty.
  ///
  /// In en, this message translates to:
  /// **'No matching commands'**
  String get slash_commands_empty;

  /// No description provided for @slash_command_info_alias.
  ///
  /// In en, this message translates to:
  /// **'{alias} is an alias of {command}'**
  String slash_command_info_alias(String alias, String command);

  /// No description provided for @slash_command_info_no_description.
  ///
  /// In en, this message translates to:
  /// **'No description available.'**
  String get slash_command_info_no_description;

  /// No description provided for @slash_command_info_arguments_options.
  ///
  /// In en, this message translates to:
  /// **'Takes one option from a fixed list.'**
  String get slash_command_info_arguments_options;

  /// No description provided for @slash_command_info_arguments_text.
  ///
  /// In en, this message translates to:
  /// **'Takes text after the command.'**
  String get slash_command_info_arguments_text;

  /// No description provided for @slash_command_info_arguments_mixed.
  ///
  /// In en, this message translates to:
  /// **'Takes an option or text after the command.'**
  String get slash_command_info_arguments_mixed;

  /// No description provided for @slash_command_output.
  ///
  /// In en, this message translates to:
  /// **'Command output'**
  String get slash_command_output;

  /// No description provided for @slash_command_no_output.
  ///
  /// In en, this message translates to:
  /// **'The command completed with no output.'**
  String get slash_command_no_output;

  /// No description provided for @slash_command_delivery_unknown.
  ///
  /// In en, this message translates to:
  /// **'The command was sent but its reply never arrived. It may still be running on the gateway, so your draft was kept. Check the gateway before retrying.'**
  String get slash_command_delivery_unknown;

  /// No description provided for @slash_command_failed.
  ///
  /// In en, this message translates to:
  /// **'The command could not be run.'**
  String get slash_command_failed;

  /// No description provided for @slash_command_unsupported.
  ///
  /// In en, this message translates to:
  /// **'This command is not available on this server.'**
  String get slash_command_unsupported;

  /// No description provided for @slash_sessions_inline.
  ///
  /// In en, this message translates to:
  /// **'Open the session list to choose a chat. Your draft was kept.'**
  String get slash_sessions_inline;

  /// No description provided for @composer_snippets.
  ///
  /// In en, this message translates to:
  /// **'Prompt snippets'**
  String get composer_snippets;

  /// No description provided for @composer_snippets_description.
  ///
  /// In en, this message translates to:
  /// **'Pick a starter prompt to drop into the composer.'**
  String get composer_snippets_description;

  /// No description provided for @composer_snippet_review.
  ///
  /// In en, this message translates to:
  /// **'Code review'**
  String get composer_snippet_review;

  /// No description provided for @composer_snippet_review_body.
  ///
  /// In en, this message translates to:
  /// **'Audit the current change for regressions, dropped edge cases and missing tests.'**
  String get composer_snippet_review_body;

  /// No description provided for @composer_snippet_review_text.
  ///
  /// In en, this message translates to:
  /// **'Please review this for bugs, regressions and missing tests.'**
  String get composer_snippet_review_text;

  /// No description provided for @composer_snippet_plan.
  ///
  /// In en, this message translates to:
  /// **'Implementation plan'**
  String get composer_snippet_plan;

  /// No description provided for @composer_snippet_plan_body.
  ///
  /// In en, this message translates to:
  /// **'Outline an approach before touching code so the diff stays focused.'**
  String get composer_snippet_plan_body;

  /// No description provided for @composer_snippet_plan_text.
  ///
  /// In en, this message translates to:
  /// **'Please make a concise implementation plan before changing code.'**
  String get composer_snippet_plan_text;

  /// No description provided for @composer_snippet_explain.
  ///
  /// In en, this message translates to:
  /// **'Explain this'**
  String get composer_snippet_explain;

  /// No description provided for @composer_snippet_explain_body.
  ///
  /// In en, this message translates to:
  /// **'Walk through how the selected code works and point to the key files.'**
  String get composer_snippet_explain_body;

  /// No description provided for @composer_snippet_explain_text.
  ///
  /// In en, this message translates to:
  /// **'Please explain how this works and point me to the key files.'**
  String get composer_snippet_explain_text;

  /// No description provided for @composer_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get composer_status;

  /// No description provided for @composer_status_context.
  ///
  /// In en, this message translates to:
  /// **'Context'**
  String get composer_status_context;

  /// No description provided for @composer_status_cache.
  ///
  /// In en, this message translates to:
  /// **'Cache hit'**
  String get composer_status_cache;

  /// No description provided for @composer_status_throughput.
  ///
  /// In en, this message translates to:
  /// **'Output tokens/sec'**
  String get composer_status_throughput;

  /// No description provided for @composer_status_running.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get composer_status_running;

  /// No description provided for @composer_status_session.
  ///
  /// In en, this message translates to:
  /// **'Session'**
  String get composer_status_session;

  /// No description provided for @composer_status_not_reported.
  ///
  /// In en, this message translates to:
  /// **'Not reported'**
  String get composer_status_not_reported;

  /// No description provided for @composer_status_empty.
  ///
  /// In en, this message translates to:
  /// **'No context breakdown was reported.'**
  String get composer_status_empty;

  /// No description provided for @composer_status_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading context breakdown'**
  String get composer_status_loading;

  /// No description provided for @composer_status_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset status bar'**
  String get composer_status_reset;

  /// No description provided for @composer_resume_title.
  ///
  /// In en, this message translates to:
  /// **'Resume a chat'**
  String get composer_resume_title;

  /// No description provided for @composer_resume_search.
  ///
  /// In en, this message translates to:
  /// **'Search titles and ids'**
  String get composer_resume_search;

  /// No description provided for @composer_resume_empty.
  ///
  /// In en, this message translates to:
  /// **'No chats match.'**
  String get composer_resume_empty;

  /// No description provided for @composer_resume_unavailable.
  ///
  /// In en, this message translates to:
  /// **'This pane has no chat list to search.'**
  String get composer_resume_unavailable;

  /// No description provided for @composer_failure_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get composer_failure_retry;

  /// No description provided for @composer_failure_retry_at.
  ///
  /// In en, this message translates to:
  /// **'Retry at {time}'**
  String composer_failure_retry_at(String time);

  /// No description provided for @composer_failure_compress.
  ///
  /// In en, this message translates to:
  /// **'Compress'**
  String get composer_failure_compress;

  /// No description provided for @composer_failure_switch_model.
  ///
  /// In en, this message translates to:
  /// **'Switch model'**
  String get composer_failure_switch_model;

  /// No description provided for @composer_failure_switch_to.
  ///
  /// In en, this message translates to:
  /// **'Switch to {model}'**
  String composer_failure_switch_to(String model);

  /// No description provided for @composer_failure_new_chat.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get composer_failure_new_chat;

  /// No description provided for @composer_failure_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit message'**
  String get composer_failure_edit;

  /// No description provided for @composer_failure_details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get composer_failure_details;

  /// No description provided for @composer_failure_hide_details.
  ///
  /// In en, this message translates to:
  /// **'Hide details'**
  String get composer_failure_hide_details;

  /// No description provided for @composer_failure_copy.
  ///
  /// In en, this message translates to:
  /// **'Copy diagnostics'**
  String get composer_failure_copy;

  /// No description provided for @composer_failure_account.
  ///
  /// In en, this message translates to:
  /// **'The other fix is on the gateway account. This chat cannot do it.'**
  String get composer_failure_account;

  /// No description provided for @composer_failure_account_only.
  ///
  /// In en, this message translates to:
  /// **'This has to be fixed on the gateway account. This chat cannot do it.'**
  String get composer_failure_account_only;

  /// No description provided for @composer_failure_confirm_compress.
  ///
  /// In en, this message translates to:
  /// **'Compress this chat? The gateway will shorten the transcript.'**
  String get composer_failure_confirm_compress;

  /// No description provided for @composer_failure_confirm_model.
  ///
  /// In en, this message translates to:
  /// **'Switch this chat to {model}?'**
  String composer_failure_confirm_model(String model);

  /// No description provided for @composer_drop_attach.
  ///
  /// In en, this message translates to:
  /// **'Drop to attach'**
  String get composer_drop_attach;

  /// No description provided for @composer_drop_folder_unsupported.
  ///
  /// In en, this message translates to:
  /// **'Folders can\'t be attached. Drop the files instead.'**
  String get composer_drop_folder_unsupported;

  /// No description provided for @composer_drop_reference.
  ///
  /// In en, this message translates to:
  /// **'Drop to reference'**
  String get composer_drop_reference;

  /// No description provided for @composer_reference_copy.
  ///
  /// In en, this message translates to:
  /// **'Copy reference'**
  String get composer_reference_copy;

  /// No description provided for @composer_reference_remove.
  ///
  /// In en, this message translates to:
  /// **'Remove reference'**
  String get composer_reference_remove;

  /// No description provided for @composer_btw_usage.
  ///
  /// In en, this message translates to:
  /// **'Usage: /btw <question> — answered from a snapshot of this conversation without interrupting it.'**
  String get composer_btw_usage;

  /// No description provided for @composer_background_usage.
  ///
  /// In en, this message translates to:
  /// **'Usage: /background <prompt> — the task runs separately and the result comes back here.'**
  String get composer_background_usage;

  /// No description provided for @composer_handoff_usage.
  ///
  /// In en, this message translates to:
  /// **'Usage: /handoff <platform> — transfer this chat to that messaging platform.'**
  String get composer_handoff_usage;

  /// No description provided for @composer_command_needs_session.
  ///
  /// In en, this message translates to:
  /// **'This command needs an open chat.'**
  String get composer_command_needs_session;

  /// No description provided for @composer_retry_not_found.
  ///
  /// In en, this message translates to:
  /// **'This turn is not in the saved history, so Retry cannot replace it. Nothing was sent again. Edit the message and send it for another try.'**
  String get composer_retry_not_found;

  /// No description provided for @composer_retry_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Retry cannot replace a turn on this connection, so nothing was sent again. Edit the message and send it for another try.'**
  String get composer_retry_unavailable;

  /// Failure card note under 'Switch to <model>' on a connection that cannot re-run a failed turn (REST).
  ///
  /// In en, this message translates to:
  /// **'Switching changes the model only: this connection can\'t run the failed turn again. Send it again after switching.'**
  String get composer_failure_switch_no_retry;

  /// No description provided for @composer_command_needs_gateway_session.
  ///
  /// In en, this message translates to:
  /// **'This chat has no gateway session yet. Send a message first, then run the command again.'**
  String get composer_command_needs_gateway_session;

  /// No description provided for @composer_side_question.
  ///
  /// In en, this message translates to:
  /// **'btw — answering from a conversation snapshot'**
  String get composer_side_question;

  /// No description provided for @composer_side_question_id.
  ///
  /// In en, this message translates to:
  /// **'btw {id} — answering from a conversation snapshot'**
  String composer_side_question_id(String id);

  /// No description provided for @composer_background_started.
  ///
  /// In en, this message translates to:
  /// **'Background task started. You can keep chatting. The result will appear here.'**
  String get composer_background_started;

  /// No description provided for @composer_background_started_id.
  ///
  /// In en, this message translates to:
  /// **'Background task {id} started. You can keep chatting. The result will appear here.'**
  String composer_background_started_id(String id);

  /// No description provided for @composer_handoff_requested.
  ///
  /// In en, this message translates to:
  /// **'Handoff to {platform} requested.'**
  String composer_handoff_requested(String platform);

  /// No description provided for @composer_handoff_done.
  ///
  /// In en, this message translates to:
  /// **'Handed this chat to {platform}.'**
  String composer_handoff_done(String platform);

  /// No description provided for @composer_handoff_failed.
  ///
  /// In en, this message translates to:
  /// **'Handoff failed.'**
  String get composer_handoff_failed;

  /// No description provided for @composer_handoff_timeout.
  ///
  /// In en, this message translates to:
  /// **'Handoff did not finish. It may still be running on the gateway.'**
  String get composer_handoff_timeout;

  /// No description provided for @composer_compress_done.
  ///
  /// In en, this message translates to:
  /// **'Compressed this chat.'**
  String get composer_compress_done;

  /// No description provided for @composer_file_missing.
  ///
  /// In en, this message translates to:
  /// **'That file is not on this device.'**
  String get composer_file_missing;

  /// No description provided for @composer_attach_busy.
  ///
  /// In en, this message translates to:
  /// **'Attachments can be added when this reply finishes.'**
  String get composer_attach_busy;

  /// No description provided for @nextgen_toggle.
  ///
  /// In en, this message translates to:
  /// **'NextGen interface'**
  String get nextgen_toggle;

  /// No description provided for @nextgen_toggle_subtitle.
  ///
  /// In en, this message translates to:
  /// **'A new design with one sign-in, live chats and network discovery. Your gateways and chats are shared with this interface.'**
  String get nextgen_toggle_subtitle;

  /// No description provided for @nextgen_single_login.
  ///
  /// In en, this message translates to:
  /// **'Sign in with one login'**
  String get nextgen_single_login;

  /// No description provided for @nextgen_single_login_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a gateway with just its dashboard address and one sign-in.'**
  String get nextgen_single_login_subtitle;

  /// No description provided for @ng_allow_this_command.
  ///
  /// In en, this message translates to:
  /// **'Allow this command?'**
  String get ng_allow_this_command;

  /// No description provided for @ng_hermes_wants_to_run_this_with.
  ///
  /// In en, this message translates to:
  /// **'Hermes wants to run this with {tool}.'**
  String ng_hermes_wants_to_run_this_with(Object tool);

  /// No description provided for @ng_hermes_wants_to_run_this.
  ///
  /// In en, this message translates to:
  /// **'Hermes wants to run this.'**
  String get ng_hermes_wants_to_run_this;

  /// No description provided for @ng_hermes_has_a_question.
  ///
  /// In en, this message translates to:
  /// **'Hermes has a question'**
  String get ng_hermes_has_a_question;

  /// No description provided for @ng_hermes_has_questions.
  ///
  /// In en, this message translates to:
  /// **'Hermes has questions'**
  String get ng_hermes_has_questions;

  /// No description provided for @ng_password_for_sudo.
  ///
  /// In en, this message translates to:
  /// **'Password for sudo'**
  String get ng_password_for_sudo;

  /// No description provided for @ng_hermes_needs_your_sudo_password_to.
  ///
  /// In en, this message translates to:
  /// **'Hermes needs your sudo password to run this command.'**
  String get ng_hermes_needs_your_sudo_password_to;

  /// No description provided for @ng_a_secret_value.
  ///
  /// In en, this message translates to:
  /// **'A secret value'**
  String get ng_a_secret_value;

  /// No description provided for @ng_value_for.
  ///
  /// In en, this message translates to:
  /// **'Value for {variable}'**
  String ng_value_for(Object variable);

  /// No description provided for @ng_your_password_manager.
  ///
  /// In en, this message translates to:
  /// **'your password manager'**
  String get ng_your_password_manager;

  /// No description provided for @ng_unlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock {name}'**
  String ng_unlock(Object name);

  /// No description provided for @ng_hermes_needs_unlocked_to_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Hermes needs {name} unlocked to sign in for you.'**
  String ng_hermes_needs_unlocked_to_sign_in(Object name);

  /// No description provided for @ng_sign_in_code.
  ///
  /// In en, this message translates to:
  /// **'Sign-in code'**
  String get ng_sign_in_code;

  /// No description provided for @ng_enter_the_sign_in_code.
  ///
  /// In en, this message translates to:
  /// **'Enter the sign-in code.'**
  String get ng_enter_the_sign_in_code;

  /// No description provided for @ng_enter_the_sign_in_code_for.
  ///
  /// In en, this message translates to:
  /// **'Enter the sign-in code for {site}.'**
  String ng_enter_the_sign_in_code_for(Object site);

  /// No description provided for @ng_save_a_login.
  ///
  /// In en, this message translates to:
  /// **'Save a login?'**
  String get ng_save_a_login;

  /// No description provided for @ng_save_your_login.
  ///
  /// In en, this message translates to:
  /// **'Save your {site} login?'**
  String ng_save_your_login(Object site);

  /// No description provided for @ng_couldn_t_load_this_chat.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load this chat: {error}'**
  String ng_couldn_t_load_this_chat(Object error);

  /// No description provided for @ng_live_updates_are_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Live updates are unavailable: {error}'**
  String ng_live_updates_are_unavailable(Object error);

  /// No description provided for @ng_preparing.
  ///
  /// In en, this message translates to:
  /// **'preparing {name}…'**
  String ng_preparing(Object name);

  /// No description provided for @ng_the_turn_failed.
  ///
  /// In en, this message translates to:
  /// **'The turn failed.'**
  String get ng_the_turn_failed;

  /// Why Stop or Steer did nothing: the turn the user saw is no longer the running one.
  ///
  /// In en, this message translates to:
  /// **'that turn already ended or a newer one started'**
  String get ng_turn_changed;

  /// Why a Steer was not delivered: the running turn refused it.
  ///
  /// In en, this message translates to:
  /// **'the running turn didn\'t accept it'**
  String get ng_steer_rejected;

  /// Why Stop or Steer was not sent: the app has not learned the running turn yet.
  ///
  /// In en, this message translates to:
  /// **'the running turn isn\'t known yet; try again in a moment'**
  String get ng_turn_not_known_yet;

  /// No description provided for @ng_couldn_t_stop.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t stop: {error}'**
  String ng_couldn_t_stop(Object error);

  /// No description provided for @ng_server_access.
  ///
  /// In en, this message translates to:
  /// **'Server access'**
  String get ng_server_access;

  /// No description provided for @ng_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign-in'**
  String get ng_sign_in;

  /// No description provided for @ng_live_connection.
  ///
  /// In en, this message translates to:
  /// **'Live connection'**
  String get ng_live_connection;

  /// No description provided for @ng_check_that_tailscale_is_on_on.
  ///
  /// In en, this message translates to:
  /// **'Check that Tailscale is on, on this phone and on the server.'**
  String get ng_check_that_tailscale_is_on_on;

  /// No description provided for @ng_check_the_address_and_that_the.
  ///
  /// In en, this message translates to:
  /// **'Check the address and that the proxy forwards to the dashboard.'**
  String get ng_check_the_address_and_that_the;

  /// No description provided for @ng_use_the_same_network_as_the.
  ///
  /// In en, this message translates to:
  /// **'Use the same network as the server, and start the dashboard with --host 0.0.0.0 so other devices can reach it.'**
  String get ng_use_the_same_network_as_the;

  /// No description provided for @ng_check_the_address_vpn_or_tailscale.
  ///
  /// In en, this message translates to:
  /// **'Check the address, VPN or Tailscale connection.'**
  String get ng_check_the_address_vpn_or_tailscale;

  /// No description provided for @ng_not_checked_yet.
  ///
  /// In en, this message translates to:
  /// **'Not checked yet.'**
  String get ng_not_checked_yet;

  /// No description provided for @ng_checking.
  ///
  /// In en, this message translates to:
  /// **'Checking…'**
  String get ng_checking;

  /// No description provided for @ng_hermes_answers_at.
  ///
  /// In en, this message translates to:
  /// **'Hermes {version} answers at {address}.'**
  String ng_hermes_answers_at(Object version, Object address);

  /// No description provided for @ng_something_answered_but_not_a_hermes.
  ///
  /// In en, this message translates to:
  /// **'Something answered, but not a Hermes dashboard.'**
  String get ng_something_answered_but_not_a_hermes;

  /// No description provided for @ng_something_answered_http_but_not_a.
  ///
  /// In en, this message translates to:
  /// **'Something answered (HTTP {status}), but not a Hermes dashboard.'**
  String ng_something_answered_http_but_not_a(Object status);

  /// No description provided for @ng_use_the_dashboard_s_address_and.
  ///
  /// In en, this message translates to:
  /// **'Use the dashboard\'s address and port (9119 by default), not the API server\'s.'**
  String get ng_use_the_dashboard_s_address_and;

  /// No description provided for @ng_cloudflare_access_turned_the_service_token.
  ///
  /// In en, this message translates to:
  /// **'Cloudflare Access turned the service token down.'**
  String get ng_cloudflare_access_turned_the_service_token;

  /// No description provided for @ng_cloudflare_access_is_in_front_of.
  ///
  /// In en, this message translates to:
  /// **'Cloudflare Access is in front of this address.'**
  String get ng_cloudflare_access_is_in_front_of;

  /// No description provided for @ng_check_the_service_token_and_its.
  ///
  /// In en, this message translates to:
  /// **'Check the service token and its Service Auth policy.'**
  String get ng_check_the_service_token_and_its;

  /// No description provided for @ng_add_a_cloudflare_access_service_token.
  ///
  /// In en, this message translates to:
  /// **'Add a Cloudflare Access service token for this address.'**
  String get ng_add_a_cloudflare_access_service_token;

  /// No description provided for @ng_the_server_asks_for_a_client.
  ///
  /// In en, this message translates to:
  /// **'The server asks for a client certificate.'**
  String get ng_the_server_asks_for_a_client;

  /// No description provided for @ng_pick_the_client_certificate_for_this.
  ///
  /// In en, this message translates to:
  /// **'Pick the client certificate for this gateway, then test again.'**
  String get ng_pick_the_client_certificate_for_this;

  /// No description provided for @ng_needs_server_access_first.
  ///
  /// In en, this message translates to:
  /// **'Needs server access first.'**
  String get ng_needs_server_access_first;

  /// No description provided for @ng_needs_a_sign_in_first.
  ///
  /// In en, this message translates to:
  /// **'Needs a sign-in first.'**
  String get ng_needs_a_sign_in_first;

  /// No description provided for @ng_signed_in_as.
  ///
  /// In en, this message translates to:
  /// **'Signed in as {name}.'**
  String ng_signed_in_as(Object name);

  /// No description provided for @ng_this_dashboard_doesn_t_need_a.
  ///
  /// In en, this message translates to:
  /// **'This dashboard doesn\'t need a sign-in.'**
  String get ng_this_dashboard_doesn_t_need_a;

  /// No description provided for @ng_the_saved_sign_in_has_expired.
  ///
  /// In en, this message translates to:
  /// **'The saved sign-in has expired.'**
  String get ng_the_saved_sign_in_has_expired;

  /// No description provided for @ng_sign_in_again.
  ///
  /// In en, this message translates to:
  /// **'Sign in again.'**
  String get ng_sign_in_again;

  /// No description provided for @ng_too_many_sign_in_attempts.
  ///
  /// In en, this message translates to:
  /// **'Too many sign-in attempts.'**
  String get ng_too_many_sign_in_attempts;

  /// No description provided for @ng_wait_a_minute_then_check_again.
  ///
  /// In en, this message translates to:
  /// **'Wait a minute, then check again.'**
  String get ng_wait_a_minute_then_check_again;

  /// No description provided for @ng_the_gateway_answered.
  ///
  /// In en, this message translates to:
  /// **'The gateway answered: {message}.'**
  String ng_the_gateway_answered(Object message);

  /// No description provided for @ng_sign_in_again_or_update_hermes.
  ///
  /// In en, this message translates to:
  /// **'Sign in again, or update Hermes.'**
  String get ng_sign_in_again_or_update_hermes;

  /// No description provided for @ng_couldn_t_check_the_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t check the sign-in: {error}'**
  String ng_couldn_t_check_the_sign_in(Object error);

  /// No description provided for @ng_the_gateway_wouldn_t_issue_a.
  ///
  /// In en, this message translates to:
  /// **'The gateway wouldn\'t issue a chat ticket ({message}).'**
  String ng_the_gateway_wouldn_t_issue_a(Object message);

  /// No description provided for @ng_the_chat_connection_opened_and_the.
  ///
  /// In en, this message translates to:
  /// **'The chat connection opened and the gateway said it\'s ready.'**
  String get ng_the_chat_connection_opened_and_the;

  /// No description provided for @ng_the_gateway_never_said_it_was.
  ///
  /// In en, this message translates to:
  /// **'The gateway never said it was ready.'**
  String get ng_the_gateway_never_said_it_was;

  /// No description provided for @ng_check_that_the_agent_is_running.
  ///
  /// In en, this message translates to:
  /// **'Check that the agent is running on the server.'**
  String get ng_check_that_the_agent_is_running;

  /// No description provided for @ng_the_gateway_refused_the_chat_connection.
  ///
  /// In en, this message translates to:
  /// **'The gateway refused the chat connection (HTTP 403).'**
  String get ng_the_gateway_refused_the_chat_connection;

  /// No description provided for @ng_this_dashboard_has_no_chat_endpoint.
  ///
  /// In en, this message translates to:
  /// **'This dashboard has no chat endpoint (/api/ws).'**
  String get ng_this_dashboard_has_no_chat_endpoint;

  /// No description provided for @ng_the_chat_connection_failed.
  ///
  /// In en, this message translates to:
  /// **'The chat connection failed: {detail}'**
  String ng_the_chat_connection_failed(Object detail);

  /// No description provided for @ng_use_the_exact_address_the_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Use the exact address the dashboard is configured for.'**
  String get ng_use_the_exact_address_the_dashboard;

  /// No description provided for @ng_update_hermes.
  ///
  /// In en, this message translates to:
  /// **'Update Hermes.'**
  String get ng_update_hermes;

  /// No description provided for @ng_make_sure_the_proxy_allows_websocket.
  ///
  /// In en, this message translates to:
  /// **'Make sure the proxy allows WebSocket upgrades on /api/ws.'**
  String get ng_make_sure_the_proxy_allows_websocket;

  /// No description provided for @ng_offline.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get ng_offline;

  /// No description provided for @ng_connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get ng_connecting;

  /// No description provided for @ng_connected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get ng_connected;

  /// No description provided for @ng_reconnecting.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting…'**
  String get ng_reconnecting;

  /// No description provided for @ng_signed_out.
  ///
  /// In en, this message translates to:
  /// **'Signed out'**
  String get ng_signed_out;

  /// No description provided for @ng_connection_failed.
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get ng_connection_failed;

  /// No description provided for @ng_rate_limited_by_gateway.
  ///
  /// In en, this message translates to:
  /// **'Rate limited by gateway'**
  String get ng_rate_limited_by_gateway;

  /// No description provided for @ng_couldn_t_open_the_chat_connection.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the chat connection: {message}'**
  String ng_couldn_t_open_the_chat_connection(Object message);

  /// No description provided for @ng_the_gateway_returned_no_websocket_ticket.
  ///
  /// In en, this message translates to:
  /// **'The gateway returned no WebSocket ticket.'**
  String get ng_the_gateway_returned_no_websocket_ticket;

  /// No description provided for @ng_connection_lost.
  ///
  /// In en, this message translates to:
  /// **'Connection lost'**
  String get ng_connection_lost;

  /// No description provided for @ng_this_dashboard_has_no_chat_endpoint_2.
  ///
  /// In en, this message translates to:
  /// **'This dashboard has no chat endpoint (/api/ws). Update Hermes.'**
  String get ng_this_dashboard_has_no_chat_endpoint_2;

  /// No description provided for @ng_the_gateway_refused_the_chat_connection_2.
  ///
  /// In en, this message translates to:
  /// **'The gateway refused the chat connection. Check that the address matches the dashboard\'s configured host and that embedded chat is enabled.'**
  String get ng_the_gateway_refused_the_chat_connection_2;

  /// No description provided for @ng_the_gateway_refused.
  ///
  /// In en, this message translates to:
  /// **'The gateway refused {method}.'**
  String ng_the_gateway_refused(Object method);

  /// No description provided for @ng_couldn_t_read_your_saved_gateways.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read your saved gateways: {error}'**
  String ng_couldn_t_read_your_saved_gateways(Object error);

  /// No description provided for @ng_applies_to_new_chats.
  ///
  /// In en, this message translates to:
  /// **'Applies to new chats'**
  String get ng_applies_to_new_chats;

  /// No description provided for @ng_couldn_t_change.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t change {label}: {error}'**
  String ng_couldn_t_change(Object label, Object error);

  /// No description provided for @ng_capabilities.
  ///
  /// In en, this message translates to:
  /// **'Capabilities'**
  String get ng_capabilities;

  /// No description provided for @ng_skills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get ng_skills;

  /// No description provided for @ng_toolsets.
  ///
  /// In en, this message translates to:
  /// **'Toolsets'**
  String get ng_toolsets;

  /// No description provided for @ng_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get ng_search;

  /// No description provided for @ng_couldn_t_load.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load'**
  String get ng_couldn_t_load;

  /// No description provided for @ng_try_again.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get ng_try_again;

  /// No description provided for @ng_no_skills.
  ///
  /// In en, this message translates to:
  /// **'No skills'**
  String get ng_no_skills;

  /// No description provided for @ng_no_toolsets.
  ///
  /// In en, this message translates to:
  /// **'No toolsets'**
  String get ng_no_toolsets;

  /// No description provided for @ng_no_mcp_servers.
  ///
  /// In en, this message translates to:
  /// **'No MCP servers'**
  String get ng_no_mcp_servers;

  /// No description provided for @ng_that_file_is_too_large_to.
  ///
  /// In en, this message translates to:
  /// **'That file is too large to be a certificate.'**
  String get ng_that_file_is_too_large_to;

  /// No description provided for @ng_the_certificate_couldn_t_be_imported.
  ///
  /// In en, this message translates to:
  /// **'The certificate couldn\'t be imported: {error}'**
  String ng_the_certificate_couldn_t_be_imported(Object error);

  /// No description provided for @ng_now_pick_its_private_key.
  ///
  /// In en, this message translates to:
  /// **'Now pick its private key.'**
  String get ng_now_pick_its_private_key;

  /// No description provided for @ng_now_pick_its_certificate.
  ///
  /// In en, this message translates to:
  /// **'Now pick its certificate.'**
  String get ng_now_pick_its_certificate;

  /// No description provided for @ng_that_file_isn_t_a_certificate.
  ///
  /// In en, this message translates to:
  /// **'That file isn\'t a certificate or a private key.'**
  String get ng_that_file_isn_t_a_certificate;

  /// No description provided for @ng_if_a_proxy_in_front_of.
  ///
  /// In en, this message translates to:
  /// **'If a proxy in front of this address asks for a client certificate, pick it here so the test, the sign-in and the chat all present it.'**
  String get ng_if_a_proxy_in_front_of;

  /// No description provided for @ng_client_certificates_are_only_used_with.
  ///
  /// In en, this message translates to:
  /// **'Client certificates are only used with https:// addresses.'**
  String get ng_client_certificates_are_only_used_with;

  /// No description provided for @ng_remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get ng_remove;

  /// No description provided for @ng_certificate_password.
  ///
  /// In en, this message translates to:
  /// **'Certificate password'**
  String get ng_certificate_password;

  /// No description provided for @ng_importing.
  ///
  /// In en, this message translates to:
  /// **'Importing…'**
  String get ng_importing;

  /// No description provided for @ng_pick_certificate.
  ///
  /// In en, this message translates to:
  /// **'Pick certificate'**
  String get ng_pick_certificate;

  /// No description provided for @ng_pick_a_different_certificate.
  ///
  /// In en, this message translates to:
  /// **'Pick a different certificate'**
  String get ng_pick_a_different_certificate;

  /// No description provided for @ng_accepts_p12_pfx_or_pem_certificate.
  ///
  /// In en, this message translates to:
  /// **'Accepts .p12/.pfx, or PEM certificate and key files. The key stays in this app\'s private storage.'**
  String get ng_accepts_p12_pfx_or_pem_certificate;

  /// No description provided for @ng_photos.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get ng_photos;

  /// No description provided for @ng_camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get ng_camera;

  /// No description provided for @ng_files.
  ///
  /// In en, this message translates to:
  /// **'Files'**
  String get ng_files;

  /// No description provided for @ng_you_can_attach_up_to_files.
  ///
  /// In en, this message translates to:
  /// **'You can attach up to {count} files.'**
  String ng_you_can_attach_up_to_files(Object count);

  /// No description provided for @ng_couldn_t_read.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t read {name}.'**
  String ng_couldn_t_read(Object name);

  /// No description provided for @ng_couldn_t_prepare_that_file.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t prepare that file: {error}'**
  String ng_couldn_t_prepare_that_file(Object error);

  /// No description provided for @ng_hermes_is_still_working.
  ///
  /// In en, this message translates to:
  /// **'Hermes is still working'**
  String get ng_hermes_is_still_working;

  /// No description provided for @ng_steer.
  ///
  /// In en, this message translates to:
  /// **'Steer'**
  String get ng_steer;

  /// No description provided for @ng_adds_this_to_the_running_turn.
  ///
  /// In en, this message translates to:
  /// **'Adds this to the running turn at its next step'**
  String get ng_adds_this_to_the_running_turn;

  /// No description provided for @ng_queue.
  ///
  /// In en, this message translates to:
  /// **'Queue'**
  String get ng_queue;

  /// No description provided for @ng_sends_it_when_the_turn_finishes.
  ///
  /// In en, this message translates to:
  /// **'Sends it when the turn finishes'**
  String get ng_sends_it_when_the_turn_finishes;

  /// No description provided for @ng_stop_and_send.
  ///
  /// In en, this message translates to:
  /// **'Stop and send'**
  String get ng_stop_and_send;

  /// No description provided for @ng_stops_the_turn_then_sends_this.
  ///
  /// In en, this message translates to:
  /// **'Stops the turn, then sends this'**
  String get ng_stops_the_turn_then_sends_this;

  /// No description provided for @ng_dictation_stopped.
  ///
  /// In en, this message translates to:
  /// **'Dictation stopped: {message}'**
  String ng_dictation_stopped(Object message);

  /// No description provided for @ng_speech_recognition_isn_t_available.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition isn\'t available.'**
  String get ng_speech_recognition_isn_t_available;

  /// No description provided for @ng_working.
  ///
  /// In en, this message translates to:
  /// **'Working'**
  String get ng_working;

  /// No description provided for @ng_ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ng_ready;

  /// No description provided for @ng_chats.
  ///
  /// In en, this message translates to:
  /// **'Chats'**
  String get ng_chats;

  /// No description provided for @ng_new_chat.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get ng_new_chat;

  /// No description provided for @ng_usage.
  ///
  /// In en, this message translates to:
  /// **'Usage'**
  String get ng_usage;

  /// No description provided for @ng_rename_chat.
  ///
  /// In en, this message translates to:
  /// **'Rename chat'**
  String get ng_rename_chat;

  /// No description provided for @ng_couldn_t_rename.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t rename: {error}'**
  String ng_couldn_t_rename(Object error);

  /// No description provided for @ng_this_chat.
  ///
  /// In en, this message translates to:
  /// **'This chat'**
  String get ng_this_chat;

  /// No description provided for @ng_input_tokens.
  ///
  /// In en, this message translates to:
  /// **'Input tokens'**
  String get ng_input_tokens;

  /// No description provided for @ng_output_tokens.
  ///
  /// In en, this message translates to:
  /// **'Output tokens'**
  String get ng_output_tokens;

  /// No description provided for @ng_reasoning_tokens.
  ///
  /// In en, this message translates to:
  /// **'Reasoning tokens'**
  String get ng_reasoning_tokens;

  /// No description provided for @ng_cache_reads.
  ///
  /// In en, this message translates to:
  /// **'Cache reads'**
  String get ng_cache_reads;

  /// No description provided for @ng_api_calls.
  ///
  /// In en, this message translates to:
  /// **'API calls'**
  String get ng_api_calls;

  /// No description provided for @ng_cost.
  ///
  /// In en, this message translates to:
  /// **'Cost'**
  String get ng_cost;

  /// No description provided for @ng_context.
  ///
  /// In en, this message translates to:
  /// **'Context'**
  String get ng_context;

  /// No description provided for @ng_your_sign_in_expired.
  ///
  /// In en, this message translates to:
  /// **'Your sign-in expired.'**
  String get ng_your_sign_in_expired;

  /// No description provided for @ng_sign_in_2.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get ng_sign_in_2;

  /// No description provided for @ng_retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get ng_retry;

  /// No description provided for @ng_project_home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get ng_project_home;

  /// No description provided for @ng_choose_project.
  ///
  /// In en, this message translates to:
  /// **'Choose a project'**
  String get ng_choose_project;

  /// No description provided for @ng_project_cwd_fallback.
  ///
  /// In en, this message translates to:
  /// **'The project folder wasn\'t available, so this chat runs in {path}.'**
  String ng_project_cwd_fallback(String path);

  /// No description provided for @ng_project_create_uncertain.
  ///
  /// In en, this message translates to:
  /// **'The gateway may have created this chat, but did not confirm it. Check Chats before starting another; this request will not be retried automatically.'**
  String get ng_project_create_uncertain;

  /// No description provided for @ng_what_should_we_work_on.
  ///
  /// In en, this message translates to:
  /// **'What should we work on?'**
  String get ng_what_should_we_work_on;

  /// No description provided for @ng_ask_hermes_anything_it_can_run.
  ///
  /// In en, this message translates to:
  /// **'Ask Hermes anything. It can run tools, browse and work in your files on the server.'**
  String get ng_ask_hermes_anything_it_can_run;

  /// No description provided for @ng_working_2.
  ///
  /// In en, this message translates to:
  /// **'Working · {frame}'**
  String ng_working_2(Object frame);

  /// No description provided for @ng_default_model.
  ///
  /// In en, this message translates to:
  /// **'Default model'**
  String get ng_default_model;

  /// No description provided for @ng_listening.
  ///
  /// In en, this message translates to:
  /// **'Listening…'**
  String get ng_listening;

  /// No description provided for @ng_steer_or_queue_a_message.
  ///
  /// In en, this message translates to:
  /// **'Steer or queue a message'**
  String get ng_steer_or_queue_a_message;

  /// No description provided for @ng_message_hermes.
  ///
  /// In en, this message translates to:
  /// **'Message Hermes'**
  String get ng_message_hermes;

  /// No description provided for @ng_attach.
  ///
  /// In en, this message translates to:
  /// **'Attach'**
  String get ng_attach;

  /// No description provided for @ng_stop_dictation.
  ///
  /// In en, this message translates to:
  /// **'Stop dictation'**
  String get ng_stop_dictation;

  /// No description provided for @ng_dictate.
  ///
  /// In en, this message translates to:
  /// **'Dictate'**
  String get ng_dictate;

  /// No description provided for @ng_stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get ng_stop;

  /// No description provided for @ng_send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get ng_send;

  /// No description provided for @ng_slash_command_alias.
  ///
  /// In en, this message translates to:
  /// **'{alias} is an alias of {command}'**
  String ng_slash_command_alias(String alias, String command);

  /// No description provided for @ng_slash_command_no_description.
  ///
  /// In en, this message translates to:
  /// **'No description available.'**
  String get ng_slash_command_no_description;

  /// No description provided for @ng_slash_command_arguments_options.
  ///
  /// In en, this message translates to:
  /// **'Takes one option from a fixed list.'**
  String get ng_slash_command_arguments_options;

  /// No description provided for @ng_slash_command_arguments_text.
  ///
  /// In en, this message translates to:
  /// **'Takes text after the command.'**
  String get ng_slash_command_arguments_text;

  /// No description provided for @ng_slash_command_arguments_mixed.
  ///
  /// In en, this message translates to:
  /// **'Takes an option or text after the command.'**
  String get ng_slash_command_arguments_mixed;

  /// No description provided for @ng_slash_command_sent_as_message.
  ///
  /// In en, this message translates to:
  /// **'NextGen sends this to Hermes as a normal message; the command itself doesn\'t run.'**
  String get ng_slash_command_sent_as_message;

  /// No description provided for @ng_slash_command_output.
  ///
  /// In en, this message translates to:
  /// **'Command output'**
  String get ng_slash_command_output;

  /// No description provided for @ng_slash_command_running.
  ///
  /// In en, this message translates to:
  /// **'Running command…'**
  String get ng_slash_command_running;

  /// No description provided for @ng_slash_command_done.
  ///
  /// In en, this message translates to:
  /// **'Done.'**
  String get ng_slash_command_done;

  /// No description provided for @ng_slash_command_failed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t run the command: {error}'**
  String ng_slash_command_failed(Object error);

  /// No description provided for @ng_slash_command_refused.
  ///
  /// In en, this message translates to:
  /// **'Hermes can\'t run this command here.'**
  String get ng_slash_command_refused;

  /// No description provided for @ng_slash_command_delivery_unknown.
  ///
  /// In en, this message translates to:
  /// **'The command was sent but no reply came back. It may still be running on the gateway, so it wasn\'t sent again and your draft was kept.'**
  String get ng_slash_command_delivery_unknown;

  /// No description provided for @ng_slash_command_nothing_running.
  ///
  /// In en, this message translates to:
  /// **'Nothing is running.'**
  String get ng_slash_command_nothing_running;

  /// No description provided for @ng_steered.
  ///
  /// In en, this message translates to:
  /// **'Steered'**
  String get ng_steered;

  /// No description provided for @ng_copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get ng_copied;

  /// No description provided for @ng_not_sent.
  ///
  /// In en, this message translates to:
  /// **'Not sent: {reason}'**
  String ng_not_sent(Object reason);

  /// No description provided for @ng_thinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking…'**
  String get ng_thinking;

  /// No description provided for @ng_thought.
  ///
  /// In en, this message translates to:
  /// **'Thought'**
  String get ng_thought;

  /// No description provided for @ng_used.
  ///
  /// In en, this message translates to:
  /// **'Used {name}'**
  String ng_used(Object name);

  /// No description provided for @ng_used_tools.
  ///
  /// In en, this message translates to:
  /// **'Used {count} tools'**
  String ng_used_tools(Object count);

  /// No description provided for @ng_copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get ng_copy;

  /// No description provided for @ng_read_aloud.
  ///
  /// In en, this message translates to:
  /// **'Read aloud'**
  String get ng_read_aloud;

  /// No description provided for @ng_the_gateway_connection_dropped_try_again.
  ///
  /// In en, this message translates to:
  /// **'The gateway connection dropped. Try again.'**
  String get ng_the_gateway_connection_dropped_try_again;

  /// No description provided for @ng_allow_once.
  ///
  /// In en, this message translates to:
  /// **'Allow once'**
  String get ng_allow_once;

  /// No description provided for @ng_allow_until_sandbox_off.
  ///
  /// In en, this message translates to:
  /// **'Until the sandbox is switched off'**
  String get ng_allow_until_sandbox_off;

  /// No description provided for @ng_folder_access.
  ///
  /// In en, this message translates to:
  /// **'Folder access'**
  String get ng_folder_access;

  /// No description provided for @ng_folder_access_unspecified.
  ///
  /// In en, this message translates to:
  /// **'The gateway did not say whether this is read-only or read-write.'**
  String get ng_folder_access_unspecified;

  /// No description provided for @ng_folder_read_only.
  ///
  /// In en, this message translates to:
  /// **'Read-only'**
  String get ng_folder_read_only;

  /// No description provided for @ng_folder_read_write.
  ///
  /// In en, this message translates to:
  /// **'Read and write'**
  String get ng_folder_read_write;

  /// No description provided for @ng_website_access.
  ///
  /// In en, this message translates to:
  /// **'Website access'**
  String get ng_website_access;

  /// No description provided for @ng_allow_for_this_chat.
  ///
  /// In en, this message translates to:
  /// **'Allow for this chat'**
  String get ng_allow_for_this_chat;

  /// No description provided for @ng_always_allow.
  ///
  /// In en, this message translates to:
  /// **'Always allow'**
  String get ng_always_allow;

  /// No description provided for @ng_deny.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get ng_deny;

  /// No description provided for @ng_your_answer.
  ///
  /// In en, this message translates to:
  /// **'Your answer'**
  String get ng_your_answer;

  /// No description provided for @ng_or_type_an_answer.
  ///
  /// In en, this message translates to:
  /// **'Or type an answer'**
  String get ng_or_type_an_answer;

  /// No description provided for @ng_skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get ng_skip;

  /// No description provided for @ng_answer.
  ///
  /// In en, this message translates to:
  /// **'Answer'**
  String get ng_answer;

  /// No description provided for @ng_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get ng_cancel;

  /// No description provided for @ng_username_or_email.
  ///
  /// In en, this message translates to:
  /// **'Username or email'**
  String get ng_username_or_email;

  /// No description provided for @ng_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get ng_password;

  /// No description provided for @ng_not_now.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get ng_not_now;

  /// No description provided for @ng_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get ng_save;

  /// No description provided for @ng_enter_both_the_client_id_and.
  ///
  /// In en, this message translates to:
  /// **'Enter both the Client ID and the Client Secret, or neither.'**
  String get ng_enter_both_the_client_id_and;

  /// No description provided for @ng_enter_your_username_and_password.
  ///
  /// In en, this message translates to:
  /// **'Enter your username and password.'**
  String get ng_enter_your_username_and_password;

  /// No description provided for @ng_couldn_t_save_the_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save the sign-in: {error}'**
  String ng_couldn_t_save_the_sign_in(Object error);

  /// No description provided for @ng_wrong_username_or_password.
  ///
  /// In en, this message translates to:
  /// **'Wrong username or password.'**
  String get ng_wrong_username_or_password;

  /// No description provided for @ng_too_many_attempts_wait_a_moment.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Wait a moment and try again.'**
  String get ng_too_many_attempts_wait_a_moment;

  /// No description provided for @ng_welcome_to_hermes.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Ares'**
  String get ng_welcome_to_hermes;

  /// No description provided for @ng_add_a_gateway.
  ///
  /// In en, this message translates to:
  /// **'Add a gateway'**
  String get ng_add_a_gateway;

  /// No description provided for @ng_connect_to_your_hermes_agent_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Connect to your Hermes Agent dashboard. One address and one sign-in reach your chats, tools and settings. Nothing is sent until you sign in.'**
  String get ng_connect_to_your_hermes_agent_dashboard;

  /// No description provided for @ng_connect_to_another_hermes_agent_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Connect to another Hermes Agent dashboard. You stay signed in to the ones you saved.'**
  String get ng_connect_to_another_hermes_agent_dashboard;

  /// No description provided for @ng_dashboard_address.
  ///
  /// In en, this message translates to:
  /// **'Dashboard address'**
  String get ng_dashboard_address;

  /// No description provided for @ng_testing.
  ///
  /// In en, this message translates to:
  /// **'Testing…'**
  String get ng_testing;

  /// No description provided for @ng_test.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get ng_test;

  /// No description provided for @ng_where_your_hermes_dashboard_runs_lan.
  ///
  /// In en, this message translates to:
  /// **'Where your hermes dashboard runs: LAN, Tailscale or HTTPS.'**
  String get ng_where_your_hermes_dashboard_runs_lan;

  /// No description provided for @ng_find_on_my_network.
  ///
  /// In en, this message translates to:
  /// **'Find on my network'**
  String get ng_find_on_my_network;

  /// No description provided for @ng_which_address_do_i_use.
  ///
  /// In en, this message translates to:
  /// **'Which address do I use?'**
  String get ng_which_address_do_i_use;

  /// No description provided for @ng_behind_cloudflare_access.
  ///
  /// In en, this message translates to:
  /// **'Behind Cloudflare Access?'**
  String get ng_behind_cloudflare_access;

  /// No description provided for @ng_need_a_client_certificate.
  ///
  /// In en, this message translates to:
  /// **'Need a client certificate?'**
  String get ng_need_a_client_certificate;

  /// No description provided for @ng_this_address_isn_t_private_and.
  ///
  /// In en, this message translates to:
  /// **'This address isn\'t private and doesn\'t use https://, so your password and chats would cross the internet unencrypted. Use https://, Tailscale or your own network instead.'**
  String get ng_this_address_isn_t_private_and;

  /// No description provided for @ng_continue_to_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Continue to sign in'**
  String get ng_continue_to_sign_in;

  /// No description provided for @ng_use_the_classic_interface_instead.
  ///
  /// In en, this message translates to:
  /// **'Use the classic interface instead'**
  String get ng_use_the_classic_interface_instead;

  /// No description provided for @ng_if_cloudflare_access_protects_this_address.
  ///
  /// In en, this message translates to:
  /// **'If Cloudflare Access protects this address, create a service token in Cloudflare Zero Trust (Access, Service credentials) and add a Service Auth policy for it to the Access application.'**
  String get ng_if_cloudflare_access_protects_this_address;

  /// No description provided for @ng_a_service_token_is_saved_for.
  ///
  /// In en, this message translates to:
  /// **'A service token is saved for this address'**
  String get ng_a_service_token_is_saved_for;

  /// No description provided for @ng_forget.
  ///
  /// In en, this message translates to:
  /// **'Forget'**
  String get ng_forget;

  /// No description provided for @ng_client_id.
  ///
  /// In en, this message translates to:
  /// **'Client ID'**
  String get ng_client_id;

  /// No description provided for @ng_client_secret.
  ///
  /// In en, this message translates to:
  /// **'Client Secret'**
  String get ng_client_secret;

  /// No description provided for @ng_stored_encrypted_on_this_phone_and.
  ///
  /// In en, this message translates to:
  /// **'Stored encrypted on this phone, and sent only to this address.'**
  String get ng_stored_encrypted_on_this_phone_and;

  /// No description provided for @ng_hermes_is_reachable.
  ///
  /// In en, this message translates to:
  /// **'Hermes is reachable'**
  String get ng_hermes_is_reachable;

  /// No description provided for @ng_hermes_is_reachable_2.
  ///
  /// In en, this message translates to:
  /// **'Hermes {version} is reachable'**
  String ng_hermes_is_reachable_2(Object version);

  /// No description provided for @ng_sign_in_is_tested_next_then.
  ///
  /// In en, this message translates to:
  /// **'Sign-in is tested next, then the chat'**
  String get ng_sign_in_is_tested_next_then;

  /// No description provided for @ng_agent_gateway.
  ///
  /// In en, this message translates to:
  /// **'Agent gateway'**
  String get ng_agent_gateway;

  /// No description provided for @ng_running.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get ng_running;

  /// No description provided for @ng_stopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get ng_stopped;

  /// No description provided for @ng_username_password.
  ///
  /// In en, this message translates to:
  /// **'Username & password'**
  String get ng_username_password;

  /// No description provided for @ng_browser.
  ///
  /// In en, this message translates to:
  /// **'Browser'**
  String get ng_browser;

  /// No description provided for @ng_in_the_browser_sso.
  ///
  /// In en, this message translates to:
  /// **'In the browser (SSO)'**
  String get ng_in_the_browser_sso;

  /// No description provided for @ng_profiles.
  ///
  /// In en, this message translates to:
  /// **'Profiles'**
  String get ng_profiles;

  /// No description provided for @ng_this_dashboard_offers_neither_a_username.
  ///
  /// In en, this message translates to:
  /// **'This dashboard offers neither a username/password provider nor browser sign-in. Update Hermes, or configure the username/password provider on the server.'**
  String get ng_this_dashboard_offers_neither_a_username;

  /// No description provided for @ng_the_auth_gate_is_off_on.
  ///
  /// In en, this message translates to:
  /// **'The auth gate is off on this dashboard. Anyone who can reach it can use your agent.'**
  String get ng_the_auth_gate_is_off_on;

  /// No description provided for @ng_couldn_t_reach_the_dashboard.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the dashboard'**
  String get ng_couldn_t_reach_the_dashboard;

  /// No description provided for @ng_check_the_address_and_port_9119.
  ///
  /// In en, this message translates to:
  /// **'{reason}\n\nCheck the address and port (9119 by default). If the dashboard isn\'t running yet, run this on the server:\nhermes dashboard --host 0.0.0.0'**
  String ng_check_the_address_and_port_9119(Object reason);

  /// No description provided for @ng_that_isn_t_a_hermes_dashboard.
  ///
  /// In en, this message translates to:
  /// **'That isn\'t a Hermes dashboard'**
  String get ng_that_isn_t_a_hermes_dashboard;

  /// No description provided for @ng_something_answered_but_not_a_hermes_2.
  ///
  /// In en, this message translates to:
  /// **'Something answered, but not a Hermes dashboard. Use the dashboard\'s address, not the API server\'s (port 8642).'**
  String get ng_something_answered_but_not_a_hermes_2;

  /// No description provided for @ng_something_answered_http_but_not_a_2.
  ///
  /// In en, this message translates to:
  /// **'Something answered (HTTP {status}), but not a Hermes dashboard. Use the dashboard\'s address, not the API server\'s (port 8642).'**
  String ng_something_answered_http_but_not_a_2(Object status);

  /// No description provided for @ng_cloudflare_access_stopped_the_request.
  ///
  /// In en, this message translates to:
  /// **'Cloudflare Access stopped the request'**
  String get ng_cloudflare_access_stopped_the_request;

  /// No description provided for @ng_cloudflare_access_turned_down_the_service.
  ///
  /// In en, this message translates to:
  /// **'Cloudflare Access turned down the service token (HTTP {status}). Check the Client ID and Secret, and the Service Auth policy.'**
  String ng_cloudflare_access_turned_down_the_service(Object status);

  /// No description provided for @ng_add_a_cloudflare_access_service_token_2.
  ///
  /// In en, this message translates to:
  /// **'Add a Cloudflare Access service token below, then test again.'**
  String get ng_add_a_cloudflare_access_service_token_2;

  /// No description provided for @ng_a_client_certificate_is_needed.
  ///
  /// In en, this message translates to:
  /// **'A client certificate is needed'**
  String get ng_a_client_certificate_is_needed;

  /// No description provided for @ng_this_server_asks_for_a_client.
  ///
  /// In en, this message translates to:
  /// **'This server asks for a client certificate before it talks. Pick the one it gave you below, then test again.'**
  String get ng_this_server_asks_for_a_client;

  /// No description provided for @ng_this_dashboard_doesn_t_ask_for.
  ///
  /// In en, this message translates to:
  /// **'This dashboard doesn\'t ask for a sign-in.'**
  String get ng_this_dashboard_doesn_t_ask_for;

  /// No description provided for @ng_use_the_dashboard_username_and_password.
  ///
  /// In en, this message translates to:
  /// **'Use the dashboard username and password configured on {address}, or sign in in your browser.'**
  String ng_use_the_dashboard_username_and_password(Object address);

  /// No description provided for @ng_use_the_dashboard_username_and_password_2.
  ///
  /// In en, this message translates to:
  /// **'Use the dashboard username and password configured on {address}.'**
  String ng_use_the_dashboard_username_and_password_2(Object address);

  /// No description provided for @ng_sign_in_to_in_your_browser.
  ///
  /// In en, this message translates to:
  /// **'Sign in to {address} in your browser, with the account its dashboard uses.'**
  String ng_sign_in_to_in_your_browser(Object address);

  /// No description provided for @ng_gateway.
  ///
  /// In en, this message translates to:
  /// **'Gateway {address}'**
  String ng_gateway(Object address);

  /// No description provided for @ng_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get ng_profile;

  /// No description provided for @ng_server_default.
  ///
  /// In en, this message translates to:
  /// **'Server default'**
  String get ng_server_default;

  /// No description provided for @ng_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get ng_continue;

  /// No description provided for @ng_username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get ng_username;

  /// No description provided for @ng_signing_in.
  ///
  /// In en, this message translates to:
  /// **'Signing in…'**
  String get ng_signing_in;

  /// No description provided for @ng_waiting_for_the_browser.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the browser…'**
  String get ng_waiting_for_the_browser;

  /// No description provided for @ng_sign_in_with_browser.
  ///
  /// In en, this message translates to:
  /// **'Sign in with browser'**
  String get ng_sign_in_with_browser;

  /// No description provided for @ng_finish_signing_in_on_the_page.
  ///
  /// In en, this message translates to:
  /// **'Finish signing in on the page that opened. Hermes comes back by itself when you\'re done.'**
  String get ng_finish_signing_in_on_the_page;

  /// No description provided for @ng_use_a_different_gateway.
  ///
  /// In en, this message translates to:
  /// **'Use a different gateway'**
  String get ng_use_a_different_gateway;

  /// No description provided for @ng_same_wi_fi_or_local_network.
  ///
  /// In en, this message translates to:
  /// **'Same Wi-Fi or local network'**
  String get ng_same_wi_fi_or_local_network;

  /// No description provided for @ng_use_the_server_s_local_address.
  ///
  /// In en, this message translates to:
  /// **'Use the server\'s local address and port, like 192.168.1.20:9119. Start the dashboard with --host 0.0.0.0 so other devices can reach it.'**
  String get ng_use_the_server_s_local_address;

  /// No description provided for @ng_tailscale.
  ///
  /// In en, this message translates to:
  /// **'Tailscale'**
  String get ng_tailscale;

  /// No description provided for @ng_turn_on_tailscale_on_this_phone.
  ///
  /// In en, this message translates to:
  /// **'Turn on Tailscale on this phone and use the server\'s Tailscale address, like 100.64.0.1:9119 or its .ts.net name. Works away from home too.'**
  String get ng_turn_on_tailscale_on_this_phone;

  /// No description provided for @ng_use_your_https_address_when_the.
  ///
  /// In en, this message translates to:
  /// **'Use your https:// address when the dashboard sits behind a proxy with a certificate. The proxy must also pass WebSocket upgrades on /api/ws.'**
  String get ng_use_your_https_address_when_the;

  /// No description provided for @ng_start_the_dashboard_on_the_server.
  ///
  /// In en, this message translates to:
  /// **'Start the dashboard on the server:'**
  String get ng_start_the_dashboard_on_the_server;

  /// No description provided for @ng_enter_a_port_from_1_to.
  ///
  /// In en, this message translates to:
  /// **'Enter a port from 1 to 65535.'**
  String get ng_enter_a_port_from_1_to;

  /// No description provided for @ng_looks_for_hermes_dashboards_on_port.
  ///
  /// In en, this message translates to:
  /// **'Looks for Hermes dashboards on port 9119 on this Wi-Fi network, and checks the computers you have already saved.'**
  String get ng_looks_for_hermes_dashboards_on_port;

  /// No description provided for @ng_looks_for_hermes_dashboards_on_ports.
  ///
  /// In en, this message translates to:
  /// **'Looks for Hermes dashboards on ports 9119 and {port} on this Wi-Fi network, and checks the computers you have already saved.'**
  String ng_looks_for_hermes_dashboards_on_ports(Object port);

  /// No description provided for @ng_other_port_optional.
  ///
  /// In en, this message translates to:
  /// **'Other port (optional)'**
  String get ng_other_port_optional;

  /// No description provided for @ng_no_dashboards_answered_start_one_with.
  ///
  /// In en, this message translates to:
  /// **'No dashboards answered. Start one with hermes dashboard --host 0.0.0.0, or type its address.'**
  String get ng_no_dashboards_answered_start_one_with;

  /// No description provided for @ng_using_tailscale_or_a_vpn_those.
  ///
  /// In en, this message translates to:
  /// **'Using Tailscale or a VPN? Those networks cannot be searched. Type the computer\'s 100.x address or its .ts.net name instead.'**
  String get ng_using_tailscale_or_a_vpn_those;

  /// No description provided for @ng_search_again.
  ///
  /// In en, this message translates to:
  /// **'Search again'**
  String get ng_search_again;

  /// No description provided for @ng_insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get ng_insights;

  /// No description provided for @ng_couldn_t_load_insights.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load insights'**
  String get ng_couldn_t_load_insights;

  /// No description provided for @ng_sessions.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get ng_sessions;

  /// No description provided for @ng_tokens.
  ///
  /// In en, this message translates to:
  /// **'Tokens'**
  String get ng_tokens;

  /// No description provided for @ng_est_cost.
  ///
  /// In en, this message translates to:
  /// **'Est. cost'**
  String get ng_est_cost;

  /// No description provided for @ng_daily_tokens.
  ///
  /// In en, this message translates to:
  /// **'Daily tokens'**
  String get ng_daily_tokens;

  /// No description provided for @ng_models.
  ///
  /// In en, this message translates to:
  /// **'Models'**
  String get ng_models;

  /// No description provided for @ng_tools.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get ng_tools;

  /// No description provided for @ng_hermes_is_waiting_for_you.
  ///
  /// In en, this message translates to:
  /// **'Hermes is waiting for you.'**
  String get ng_hermes_is_waiting_for_you;

  /// No description provided for @ng_hermes_replied.
  ///
  /// In en, this message translates to:
  /// **'Hermes replied'**
  String get ng_hermes_replied;

  /// No description provided for @ng_the_turn_finished.
  ///
  /// In en, this message translates to:
  /// **'The turn finished.'**
  String get ng_the_turn_finished;

  /// No description provided for @ng_off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get ng_off;

  /// No description provided for @ng_minimal.
  ///
  /// In en, this message translates to:
  /// **'Minimal'**
  String get ng_minimal;

  /// No description provided for @ng_low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get ng_low;

  /// No description provided for @ng_medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get ng_medium;

  /// No description provided for @ng_high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get ng_high;

  /// No description provided for @ng_extra_high.
  ///
  /// In en, this message translates to:
  /// **'Extra high'**
  String get ng_extra_high;

  /// No description provided for @ng_max.
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get ng_max;

  /// No description provided for @ng_ultra.
  ///
  /// In en, this message translates to:
  /// **'Ultra'**
  String get ng_ultra;

  /// No description provided for @ng_default.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get ng_default;

  /// No description provided for @ng_couldn_t_switch_model.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t switch model: {error}'**
  String ng_couldn_t_switch_model(Object error);

  /// No description provided for @ng_model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get ng_model;

  /// No description provided for @ng_thinking_2.
  ///
  /// In en, this message translates to:
  /// **'Thinking'**
  String get ng_thinking_2;

  /// No description provided for @ng_search_models.
  ///
  /// In en, this message translates to:
  /// **'Search models'**
  String get ng_search_models;

  /// No description provided for @ng_no_models_match.
  ///
  /// In en, this message translates to:
  /// **'No models match these filters.'**
  String get ng_no_models_match;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get privacy_policy;

  /// No description provided for @report_ai_output.
  ///
  /// In en, this message translates to:
  /// **'Report AI output'**
  String get report_ai_output;

  /// No description provided for @ng_couldn_t_load_models.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load models: {error}'**
  String ng_couldn_t_load_models(Object error);

  /// No description provided for @ng_no_providers_are_set_up_on.
  ///
  /// In en, this message translates to:
  /// **'No providers are set up on this gateway yet.'**
  String get ng_no_providers_are_set_up_on;

  /// No description provided for @ng_starred.
  ///
  /// In en, this message translates to:
  /// **'Starred'**
  String get ng_starred;

  /// No description provided for @ng_recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get ng_recent;

  /// No description provided for @ng_more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get ng_more;

  /// No description provided for @ng_archived_chats.
  ///
  /// In en, this message translates to:
  /// **'Archived chats'**
  String get ng_archived_chats;

  /// No description provided for @ng_projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get ng_projects;

  /// No description provided for @ng_chats_grouped_by_project_and_workspace.
  ///
  /// In en, this message translates to:
  /// **'Chats grouped by project and workspace'**
  String get ng_chats_grouped_by_project_and_workspace;

  /// No description provided for @ng_agent.
  ///
  /// In en, this message translates to:
  /// **'Agent'**
  String get ng_agent;

  /// No description provided for @ng_memory.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get ng_memory;

  /// No description provided for @ng_what_hermes_remembers_about_you.
  ///
  /// In en, this message translates to:
  /// **'What Hermes remembers about you'**
  String get ng_what_hermes_remembers_about_you;

  /// No description provided for @ng_skills_library.
  ///
  /// In en, this message translates to:
  /// **'Skills library'**
  String get ng_skills_library;

  /// No description provided for @ng_browse_and_read_installed_skills.
  ///
  /// In en, this message translates to:
  /// **'Browse and read installed skills'**
  String get ng_browse_and_read_installed_skills;

  /// No description provided for @ng_cron_editor.
  ///
  /// In en, this message translates to:
  /// **'Cron editor'**
  String get ng_cron_editor;

  /// No description provided for @ng_edit_schedules_prompts_and_delivery.
  ///
  /// In en, this message translates to:
  /// **'Edit schedules, prompts and delivery'**
  String get ng_edit_schedules_prompts_and_delivery;

  /// No description provided for @ng_config_file.
  ///
  /// In en, this message translates to:
  /// **'Config file'**
  String get ng_config_file;

  /// No description provided for @ng_edit_config_yaml_on_the_gateway.
  ///
  /// In en, this message translates to:
  /// **'Edit config.yaml on the gateway'**
  String get ng_edit_config_yaml_on_the_gateway;

  /// No description provided for @ng_models_and_providers.
  ///
  /// In en, this message translates to:
  /// **'Models and providers'**
  String get ng_models_and_providers;

  /// No description provided for @ng_model_management.
  ///
  /// In en, this message translates to:
  /// **'Model management'**
  String get ng_model_management;

  /// No description provided for @ng_default_fallback_and_auxiliary_models.
  ///
  /// In en, this message translates to:
  /// **'Default, fallback and auxiliary models'**
  String get ng_default_fallback_and_auxiliary_models;

  /// No description provided for @ng_provider_sign_in.
  ///
  /// In en, this message translates to:
  /// **'Provider sign-in'**
  String get ng_provider_sign_in;

  /// No description provided for @ng_connect_provider_accounts_with_oauth.
  ///
  /// In en, this message translates to:
  /// **'Connect provider accounts with OAuth'**
  String get ng_connect_provider_accounts_with_oauth;

  /// No description provided for @ng_nous_portal.
  ///
  /// In en, this message translates to:
  /// **'Nous Portal'**
  String get ng_nous_portal;

  /// No description provided for @ng_subscription_credits_and_usage.
  ///
  /// In en, this message translates to:
  /// **'Subscription, credits and usage'**
  String get ng_subscription_credits_and_usage;

  /// No description provided for @ng_interface.
  ///
  /// In en, this message translates to:
  /// **'Interface'**
  String get ng_interface;

  /// No description provided for @ng_switch_to_the_classic_interface.
  ///
  /// In en, this message translates to:
  /// **'Switch to the classic interface'**
  String get ng_switch_to_the_classic_interface;

  /// No description provided for @ng_turns_nextgen_off_you_can_turn.
  ///
  /// In en, this message translates to:
  /// **'Turns NextGen off. You can turn it back on in Settings.'**
  String get ng_turns_nextgen_off_you_can_turn;

  /// No description provided for @ng_restored.
  ///
  /// In en, this message translates to:
  /// **'Restored'**
  String get ng_restored;

  /// No description provided for @ng_archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get ng_archived;

  /// No description provided for @ng_couldn_t_load_archived_chats.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load archived chats'**
  String get ng_couldn_t_load_archived_chats;

  /// No description provided for @ng_nothing_archived.
  ///
  /// In en, this message translates to:
  /// **'Nothing archived'**
  String get ng_nothing_archived;

  /// No description provided for @ng_restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get ng_restore;

  /// No description provided for @ng_saved_new_chats_use_it.
  ///
  /// In en, this message translates to:
  /// **'Saved. New chats use it.'**
  String get ng_saved_new_chats_use_it;

  /// No description provided for @ng_couldn_t_save.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save: {error}'**
  String ng_couldn_t_save(Object error);

  /// No description provided for @ng_saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get ng_saving;

  /// No description provided for @ng_today.
  ///
  /// In en, this message translates to:
  /// **'Today {time}'**
  String ng_today(Object time);

  /// No description provided for @ng_mon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get ng_mon;

  /// No description provided for @ng_tue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get ng_tue;

  /// No description provided for @ng_wed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get ng_wed;

  /// No description provided for @ng_thu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get ng_thu;

  /// No description provided for @ng_fri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get ng_fri;

  /// No description provided for @ng_sat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get ng_sat;

  /// No description provided for @ng_sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get ng_sun;

  /// No description provided for @ng_scheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get ng_scheduled;

  /// No description provided for @ng_new_job.
  ///
  /// In en, this message translates to:
  /// **'New job'**
  String get ng_new_job;

  /// No description provided for @ng_couldn_t_load_scheduled_jobs.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load scheduled jobs'**
  String get ng_couldn_t_load_scheduled_jobs;

  /// No description provided for @ng_nothing_scheduled.
  ///
  /// In en, this message translates to:
  /// **'Nothing scheduled'**
  String get ng_nothing_scheduled;

  /// No description provided for @ng_ask_hermes_to_do_something_on.
  ///
  /// In en, this message translates to:
  /// **'Ask Hermes to do something on a schedule, or add a job here.'**
  String get ng_ask_hermes_to_do_something_on;

  /// No description provided for @ng_active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get ng_active;

  /// No description provided for @ng_paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get ng_paused;

  /// No description provided for @ng_next.
  ///
  /// In en, this message translates to:
  /// **'Next {when}'**
  String ng_next(Object when);

  /// No description provided for @ng_last.
  ///
  /// In en, this message translates to:
  /// **'Last {when}'**
  String ng_last(Object when);

  /// No description provided for @ng_last_2.
  ///
  /// In en, this message translates to:
  /// **'Last {when} · {result}'**
  String ng_last_2(Object when, Object result);

  /// No description provided for @ng_job.
  ///
  /// In en, this message translates to:
  /// **'Job {id}'**
  String ng_job(Object id);

  /// No description provided for @ng_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get ng_delete;

  /// No description provided for @ng_delete_this_job.
  ///
  /// In en, this message translates to:
  /// **'Delete this job?'**
  String get ng_delete_this_job;

  /// No description provided for @ng_it_stops_running_past_runs_stay.
  ///
  /// In en, this message translates to:
  /// **'It stops running. Past runs stay in your chats.'**
  String get ng_it_stops_running_past_runs_stay;

  /// No description provided for @ng_next_run.
  ///
  /// In en, this message translates to:
  /// **'Next run {when}'**
  String ng_next_run(Object when);

  /// No description provided for @ng_delivers_to.
  ///
  /// In en, this message translates to:
  /// **'Delivers to {target}'**
  String ng_delivers_to(Object target);

  /// No description provided for @ng_run_now.
  ///
  /// In en, this message translates to:
  /// **'Run now'**
  String get ng_run_now;

  /// No description provided for @ng_started.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get ng_started;

  /// No description provided for @ng_pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get ng_pause;

  /// No description provided for @ng_resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get ng_resume;

  /// No description provided for @ng_resumed.
  ///
  /// In en, this message translates to:
  /// **'Resumed'**
  String get ng_resumed;

  /// No description provided for @ng_prompt.
  ///
  /// In en, this message translates to:
  /// **'Prompt'**
  String get ng_prompt;

  /// No description provided for @ng_runs.
  ///
  /// In en, this message translates to:
  /// **'Runs'**
  String get ng_runs;

  /// No description provided for @ng_no_runs_yet.
  ///
  /// In en, this message translates to:
  /// **'No runs yet.'**
  String get ng_no_runs_yet;

  /// No description provided for @ng_enter_a_schedule_and_a_prompt.
  ///
  /// In en, this message translates to:
  /// **'Enter a schedule and a prompt.'**
  String get ng_enter_a_schedule_and_a_prompt;

  /// No description provided for @ng_name_optional.
  ///
  /// In en, this message translates to:
  /// **'Name (optional)'**
  String get ng_name_optional;

  /// No description provided for @ng_schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get ng_schedule;

  /// No description provided for @ng_every_1h_0_9_or_30m.
  ///
  /// In en, this message translates to:
  /// **'every 1h, 0 9 * * *, or 30m'**
  String get ng_every_1h_0_9_or_30m;

  /// No description provided for @ng_create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get ng_create;

  /// No description provided for @ng_unpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin'**
  String get ng_unpin;

  /// No description provided for @ng_pin.
  ///
  /// In en, this message translates to:
  /// **'Pin'**
  String get ng_pin;

  /// No description provided for @ng_rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get ng_rename;

  /// No description provided for @ng_archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get ng_archive;

  /// No description provided for @ng_delete_this_chat.
  ///
  /// In en, this message translates to:
  /// **'Delete this chat?'**
  String get ng_delete_this_chat;

  /// No description provided for @ng_it_is_removed_from_the_gateway.
  ///
  /// In en, this message translates to:
  /// **'It is removed from the gateway for every device.'**
  String get ng_it_is_removed_from_the_gateway;

  /// No description provided for @ng_search_chats.
  ///
  /// In en, this message translates to:
  /// **'Search chats'**
  String get ng_search_chats;

  /// No description provided for @ng_pinned.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get ng_pinned;

  /// No description provided for @ng_no_chats_match.
  ///
  /// In en, this message translates to:
  /// **'No chats match.'**
  String get ng_no_chats_match;

  /// No description provided for @ng_no_chats_yet.
  ///
  /// In en, this message translates to:
  /// **'No chats yet.'**
  String get ng_no_chats_yet;

  /// No description provided for @ng_nothing_is_running.
  ///
  /// In en, this message translates to:
  /// **'Nothing is running.'**
  String get ng_nothing_is_running;

  /// No description provided for @ng_nothing_is_waiting_on_you.
  ///
  /// In en, this message translates to:
  /// **'Nothing is waiting on you.'**
  String get ng_nothing_is_waiting_on_you;

  /// No description provided for @ng_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get ng_settings;

  /// No description provided for @ng_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get ng_all;

  /// No description provided for @ng_needs_you.
  ///
  /// In en, this message translates to:
  /// **'Needs you · {count}'**
  String ng_needs_you(Object count);

  /// No description provided for @ng_needs_you_2.
  ///
  /// In en, this message translates to:
  /// **'Needs you'**
  String get ng_needs_you_2;

  /// No description provided for @ng_gateways.
  ///
  /// In en, this message translates to:
  /// **'Gateways'**
  String get ng_gateways;

  /// No description provided for @ng_classic_connection.
  ///
  /// In en, this message translates to:
  /// **'{address} · classic connection'**
  String ng_classic_connection(Object address);

  /// No description provided for @ng_gateway_2.
  ///
  /// In en, this message translates to:
  /// **'Gateway'**
  String get ng_gateway_2;

  /// No description provided for @ng_signed_in.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get ng_signed_in;

  /// No description provided for @ng_classic_connection_2.
  ///
  /// In en, this message translates to:
  /// **'Classic connection'**
  String get ng_classic_connection_2;

  /// No description provided for @ng_in_the_browser.
  ///
  /// In en, this message translates to:
  /// **'In the browser'**
  String get ng_in_the_browser;

  /// No description provided for @ng_in_the_browser_as.
  ///
  /// In en, this message translates to:
  /// **'In the browser as {name}'**
  String ng_in_the_browser_as(Object name);

  /// No description provided for @ng_not_required.
  ///
  /// In en, this message translates to:
  /// **'Not required'**
  String get ng_not_required;

  /// No description provided for @ng_test_connection.
  ///
  /// In en, this message translates to:
  /// **'Test connection'**
  String get ng_test_connection;

  /// No description provided for @ng_sign_in_again_2.
  ///
  /// In en, this message translates to:
  /// **'Sign in again'**
  String get ng_sign_in_again_2;

  /// No description provided for @ng_sign_out.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get ng_sign_out;

  /// No description provided for @ng_saved_gateways.
  ///
  /// In en, this message translates to:
  /// **'Saved gateways'**
  String get ng_saved_gateways;

  /// No description provided for @ng_in_use.
  ///
  /// In en, this message translates to:
  /// **'In use'**
  String get ng_in_use;

  /// No description provided for @ng_appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get ng_appearance;

  /// No description provided for @ng_theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get ng_theme;

  /// No description provided for @ng_system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get ng_system;

  /// No description provided for @ng_light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get ng_light;

  /// No description provided for @ng_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get ng_dark;

  /// No description provided for @ng_accent.
  ///
  /// In en, this message translates to:
  /// **'Accent'**
  String get ng_accent;

  /// No description provided for @ng_pure_black.
  ///
  /// In en, this message translates to:
  /// **'Pure black'**
  String get ng_pure_black;

  /// No description provided for @ng_dark_theme_uses_true_black_oled.
  ///
  /// In en, this message translates to:
  /// **'Dark theme uses true black (OLED)'**
  String get ng_dark_theme_uses_true_black_oled;

  /// No description provided for @ng_glow.
  ///
  /// In en, this message translates to:
  /// **'Glow'**
  String get ng_glow;

  /// No description provided for @ng_soft_accent_light_behind_each_screen.
  ///
  /// In en, this message translates to:
  /// **'Soft accent light behind each screen'**
  String get ng_soft_accent_light_behind_each_screen;

  /// No description provided for @ng_the_new_interface_turn_off_to.
  ///
  /// In en, this message translates to:
  /// **'The new interface. Turn off to go back to the classic one; your gateways and chats are shared.'**
  String get ng_the_new_interface_turn_off_to;

  /// No description provided for @ng_more_settings.
  ///
  /// In en, this message translates to:
  /// **'More settings'**
  String get ng_more_settings;

  /// No description provided for @ng_voice_notifications_language_backups_and_the.
  ///
  /// In en, this message translates to:
  /// **'Voice, notifications, language, backups and the gateway\'s config'**
  String get ng_voice_notifications_language_backups_and_the;

  /// No description provided for @ng_licences.
  ///
  /// In en, this message translates to:
  /// **'Licences'**
  String get ng_licences;

  /// No description provided for @ng_sign_out_of.
  ///
  /// In en, this message translates to:
  /// **'Sign out of {name}?'**
  String ng_sign_out_of(Object name);

  /// No description provided for @ng_this_gateway_and_its_saved_sign.
  ///
  /// In en, this message translates to:
  /// **'This gateway and its saved sign-in are removed from this phone, in both interfaces. Your chats stay on the gateway.'**
  String get ng_this_gateway_and_its_saved_sign;

  /// No description provided for @ng_password_or_browser.
  ///
  /// In en, this message translates to:
  /// **'Password or browser'**
  String get ng_password_or_browser;

  /// No description provided for @ng_unsupported.
  ///
  /// In en, this message translates to:
  /// **'Unsupported'**
  String get ng_unsupported;

  /// No description provided for @ng_background_task_finished.
  ///
  /// In en, this message translates to:
  /// **'Background task finished'**
  String get ng_background_task_finished;

  /// No description provided for @ng_background_process_finished.
  ///
  /// In en, this message translates to:
  /// **'Background process finished'**
  String get ng_background_process_finished;

  /// No description provided for @ng_system_message.
  ///
  /// In en, this message translates to:
  /// **'System message'**
  String get ng_system_message;

  /// No description provided for @ng_summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get ng_summary;

  /// No description provided for @classic_interface_only.
  ///
  /// In en, this message translates to:
  /// **'Classic interface only'**
  String get classic_interface_only;

  /// No description provided for @classic_only_settings_hint.
  ///
  /// In en, this message translates to:
  /// **'Sections marked Classic interface only change the classic look and chat, not NextGen. NextGen has its own appearance options in its Settings.'**
  String get classic_only_settings_hint;

  /// No description provided for @attachment_preview_too_large.
  ///
  /// In en, this message translates to:
  /// **'Too large to preview here. Save or Share downloads it to your phone (up to 1 GB).'**
  String get attachment_preview_too_large;

  /// No description provided for @attachment_over_phone_limit.
  ///
  /// In en, this message translates to:
  /// **'This file is over 1 GB and exceeds the download limit. Open the dashboard to download it.'**
  String get attachment_over_phone_limit;

  /// No description provided for @attachment_downloading_percent.
  ///
  /// In en, this message translates to:
  /// **'Downloading… {percent}%'**
  String attachment_downloading_percent(int percent);

  /// No description provided for @attachment_downloading_mb.
  ///
  /// In en, this message translates to:
  /// **'Downloading… {megabytes} MB'**
  String attachment_downloading_mb(int megabytes);

  /// No description provided for @ng_attachment_too_large_for_gateway.
  ///
  /// In en, this message translates to:
  /// **'{name} is larger than 12 MB, the most this gateway takes. Update Hermes to send files up to 100 MB.'**
  String ng_attachment_too_large_for_gateway(String name);

  /// No description provided for @ng_couldn_t_upload.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t upload {name}.'**
  String ng_couldn_t_upload(String name);

  /// No description provided for @ng_uploading_percent.
  ///
  /// In en, this message translates to:
  /// **'Uploading… {percent}%'**
  String ng_uploading_percent(int percent);

  /// No description provided for @ng_show_tasks.
  ///
  /// In en, this message translates to:
  /// **'Show tasks'**
  String get ng_show_tasks;

  /// No description provided for @ng_hide_tasks.
  ///
  /// In en, this message translates to:
  /// **'Hide tasks'**
  String get ng_hide_tasks;

  /// No description provided for @ng_goal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get ng_goal;

  /// No description provided for @ng_loop.
  ///
  /// In en, this message translates to:
  /// **'Loop'**
  String get ng_loop;

  /// No description provided for @ng_heartbeat.
  ///
  /// In en, this message translates to:
  /// **'Heartbeat'**
  String get ng_heartbeat;

  /// No description provided for @ng_goal_working.
  ///
  /// In en, this message translates to:
  /// **'Working'**
  String get ng_goal_working;

  /// No description provided for @ng_goal_waiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get ng_goal_waiting;

  /// No description provided for @ng_goal_blocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get ng_goal_blocked;

  /// No description provided for @ng_goal_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get ng_goal_done;

  /// No description provided for @ng_goal_turns_of.
  ///
  /// In en, this message translates to:
  /// **'{used} of {max} turns'**
  String ng_goal_turns_of(int used, int max);

  /// No description provided for @ng_goal_turn.
  ///
  /// In en, this message translates to:
  /// **'turn {used}'**
  String ng_goal_turn(int used);

  /// No description provided for @ng_loop_held.
  ///
  /// In en, this message translates to:
  /// **'Held for goal'**
  String get ng_loop_held;

  /// No description provided for @ng_loop_finished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get ng_loop_finished;

  /// No description provided for @ng_loop_running.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get ng_loop_running;

  /// No description provided for @ng_loop_runs_of.
  ///
  /// In en, this message translates to:
  /// **'{fired} of {times} runs'**
  String ng_loop_runs_of(int fired, int times);

  /// No description provided for @ng_loop_runs.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 run} other{{count} runs}}'**
  String ng_loop_runs(int count);

  /// No description provided for @ng_loop_next.
  ///
  /// In en, this message translates to:
  /// **'next {time}'**
  String ng_loop_next(String time);

  /// No description provided for @ng_loop_due_now.
  ///
  /// In en, this message translates to:
  /// **'due now'**
  String get ng_loop_due_now;

  /// No description provided for @ng_every_seconds.
  ///
  /// In en, this message translates to:
  /// **'every {seconds} s'**
  String ng_every_seconds(int seconds);

  /// No description provided for @ng_every_minutes.
  ///
  /// In en, this message translates to:
  /// **'every {minutes} min'**
  String ng_every_minutes(int minutes);

  /// No description provided for @ng_every_hours.
  ///
  /// In en, this message translates to:
  /// **'every {hours} h'**
  String ng_every_hours(int hours);

  /// No description provided for @ng_every_hours_minutes.
  ///
  /// In en, this message translates to:
  /// **'every {hours} h {minutes} min'**
  String ng_every_hours_minutes(int hours, int minutes);

  /// No description provided for @ng_heartbeat_fired.
  ///
  /// In en, this message translates to:
  /// **'{count} fired'**
  String ng_heartbeat_fired(int count);

  /// No description provided for @ng_heartbeat_last_fired.
  ///
  /// In en, this message translates to:
  /// **'Last fired at {time}'**
  String ng_heartbeat_last_fired(String time);

  /// No description provided for @ng_wait_until.
  ///
  /// In en, this message translates to:
  /// **'Waiting until {time}'**
  String ng_wait_until(String time);

  /// No description provided for @ng_wait_resume.
  ///
  /// In en, this message translates to:
  /// **'Waiting to resume'**
  String get ng_wait_resume;

  /// No description provided for @ng_wait_other_chat.
  ///
  /// In en, this message translates to:
  /// **'Waiting on another chat'**
  String get ng_wait_other_chat;

  /// No description provided for @ng_wait_process.
  ///
  /// In en, this message translates to:
  /// **'Waiting on process {pid}'**
  String ng_wait_process(String pid);

  /// No description provided for @ng_control_open.
  ///
  /// In en, this message translates to:
  /// **'Open goal and automation'**
  String get ng_control_open;

  /// No description provided for @ng_control_title.
  ///
  /// In en, this message translates to:
  /// **'Goal and automation'**
  String get ng_control_title;

  /// No description provided for @ng_control_subtitle.
  ///
  /// In en, this message translates to:
  /// **'What this chat is working toward, and what runs on its own.'**
  String get ng_control_subtitle;

  /// No description provided for @ng_contract_outcome.
  ///
  /// In en, this message translates to:
  /// **'Outcome'**
  String get ng_contract_outcome;

  /// No description provided for @ng_contract_verification.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get ng_contract_verification;

  /// No description provided for @ng_contract_constraints.
  ///
  /// In en, this message translates to:
  /// **'Constraints'**
  String get ng_contract_constraints;

  /// No description provided for @ng_contract_boundaries.
  ///
  /// In en, this message translates to:
  /// **'Boundaries'**
  String get ng_contract_boundaries;

  /// No description provided for @ng_contract_stop_when.
  ///
  /// In en, this message translates to:
  /// **'Stop when'**
  String get ng_contract_stop_when;

  /// No description provided for @ng_subgoals.
  ///
  /// In en, this message translates to:
  /// **'Sub-goals'**
  String get ng_subgoals;

  /// No description provided for @ng_subgoal_add_placeholder.
  ///
  /// In en, this message translates to:
  /// **'Add a sub-goal'**
  String get ng_subgoal_add_placeholder;

  /// No description provided for @ng_add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get ng_add;

  /// No description provided for @ng_subgoal_remove.
  ///
  /// In en, this message translates to:
  /// **'Remove sub-goal'**
  String get ng_subgoal_remove;

  /// No description provided for @ng_goal_checks.
  ///
  /// In en, this message translates to:
  /// **'Checks'**
  String get ng_goal_checks;

  /// No description provided for @ng_gate_not_run.
  ///
  /// In en, this message translates to:
  /// **'Not run yet'**
  String get ng_gate_not_run;

  /// No description provided for @ng_gate_attempts.
  ///
  /// In en, this message translates to:
  /// **'{attempts} of {tries} attempts'**
  String ng_gate_attempts(int attempts, int tries);

  /// No description provided for @ng_gate_exit.
  ///
  /// In en, this message translates to:
  /// **'exit {code}'**
  String ng_gate_exit(int code);

  /// No description provided for @ng_resume_now.
  ///
  /// In en, this message translates to:
  /// **'Resume now'**
  String get ng_resume_now;

  /// No description provided for @ng_goal_clear.
  ///
  /// In en, this message translates to:
  /// **'Clear goal'**
  String get ng_goal_clear;

  /// No description provided for @ng_goal_clear_title.
  ///
  /// In en, this message translates to:
  /// **'Clear this goal?'**
  String get ng_goal_clear_title;

  /// No description provided for @ng_goal_clear_message.
  ///
  /// In en, this message translates to:
  /// **'The agent stops working toward it. Its sub-goals and checks go with it.'**
  String get ng_goal_clear_message;

  /// No description provided for @ng_subgoal_remove_title.
  ///
  /// In en, this message translates to:
  /// **'Remove this sub-goal?'**
  String get ng_subgoal_remove_title;

  /// No description provided for @ng_subgoal_remove_message.
  ///
  /// In en, this message translates to:
  /// **'\"{text}\" will no longer be part of the goal.'**
  String ng_subgoal_remove_message(String text);

  /// No description provided for @ng_subgoals_clear_title.
  ///
  /// In en, this message translates to:
  /// **'Clear all sub-goals?'**
  String get ng_subgoals_clear_title;

  /// No description provided for @ng_subgoals_clear_message.
  ///
  /// In en, this message translates to:
  /// **'The goal keeps its title but loses all of its sub-goals.'**
  String get ng_subgoals_clear_message;

  /// No description provided for @ng_clear_all.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get ng_clear_all;

  /// No description provided for @ng_clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get ng_clear;

  /// No description provided for @ng_dismiss.
  ///
  /// In en, this message translates to:
  /// **'Dismiss'**
  String get ng_dismiss;

  /// No description provided for @ng_loop_stop_title.
  ///
  /// In en, this message translates to:
  /// **'Stop this loop?'**
  String get ng_loop_stop_title;

  /// No description provided for @ng_heartbeat_clear_title.
  ///
  /// In en, this message translates to:
  /// **'Clear this heartbeat?'**
  String get ng_heartbeat_clear_title;

  /// No description provided for @ng_wont_fire_again.
  ///
  /// In en, this message translates to:
  /// **'It won\'t fire again.'**
  String get ng_wont_fire_again;

  /// No description provided for @ng_loop_self_paced.
  ///
  /// In en, this message translates to:
  /// **'Self-paced'**
  String get ng_loop_self_paced;

  /// No description provided for @ng_loop_until.
  ///
  /// In en, this message translates to:
  /// **'Until: {condition}'**
  String ng_loop_until(String condition);

  /// No description provided for @ng_loop_waits_for_goal.
  ///
  /// In en, this message translates to:
  /// **'Waits while the goal is working.'**
  String get ng_loop_waits_for_goal;

  /// No description provided for @ng_loop_awaiting_reply.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the agent\'s reply.'**
  String get ng_loop_awaiting_reply;

  /// No description provided for @ng_loop_stopped_reason.
  ///
  /// In en, this message translates to:
  /// **'Stopped: {reason}'**
  String ng_loop_stopped_reason(String reason);

  /// No description provided for @ng_hide_subagents.
  ///
  /// In en, this message translates to:
  /// **'Hide subagents'**
  String get ng_hide_subagents;

  /// No description provided for @ng_show_subagents.
  ///
  /// In en, this message translates to:
  /// **'Show subagents'**
  String get ng_show_subagents;

  /// No description provided for @ng_subagent.
  ///
  /// In en, this message translates to:
  /// **'Subagent'**
  String get ng_subagent;

  /// No description provided for @ng_subagent_queued.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get ng_subagent_queued;

  /// No description provided for @ng_subagent_starting.
  ///
  /// In en, this message translates to:
  /// **'Starting…'**
  String get ng_subagent_starting;

  /// No description provided for @ng_subagent_running.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get ng_subagent_running;

  /// No description provided for @ng_subagent_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get ng_subagent_done;

  /// No description provided for @ng_subagent_failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get ng_subagent_failed;

  /// No description provided for @ng_subagent_stopped.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get ng_subagent_stopped;

  /// No description provided for @ng_subagent_stop.
  ///
  /// In en, this message translates to:
  /// **'Stop subagent'**
  String get ng_subagent_stop;

  /// No description provided for @ng_subagent_tools.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 tool} other{{count} tools}}'**
  String ng_subagent_tools(int count);

  /// No description provided for @ng_mark_as_read.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get ng_mark_as_read;

  /// No description provided for @ng_mark_as_unread.
  ///
  /// In en, this message translates to:
  /// **'Mark as unread'**
  String get ng_mark_as_unread;

  /// No description provided for @ng_chats_unread.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Chats, 1 unread} other{Chats, {count} unread}}'**
  String ng_chats_unread(int count);

  /// No description provided for @ng_unread_finished.
  ///
  /// In en, this message translates to:
  /// **'Finished, unread reply'**
  String get ng_unread_finished;

  /// No description provided for @ng_unread_updates.
  ///
  /// In en, this message translates to:
  /// **'Running, unread updates'**
  String get ng_unread_updates;

  /// No description provided for @ng_notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get ng_notifications;

  /// No description provided for @ng_notifications_hint.
  ///
  /// In en, this message translates to:
  /// **'Replies and requests while Ares is in the background'**
  String get ng_notifications_hint;

  /// No description provided for @ng_notify_replies.
  ///
  /// In en, this message translates to:
  /// **'Replies'**
  String get ng_notify_replies;

  /// No description provided for @ng_notify_replies_hint.
  ///
  /// In en, this message translates to:
  /// **'When a turn finishes or fails in the open chat'**
  String get ng_notify_replies_hint;

  /// No description provided for @ng_notify_requests.
  ///
  /// In en, this message translates to:
  /// **'Approvals and questions'**
  String get ng_notify_requests;

  /// No description provided for @ng_notify_requests_hint.
  ///
  /// In en, this message translates to:
  /// **'A heads-up when the agent waits on you, with Allow once and Deny'**
  String get ng_notify_requests_hint;

  /// No description provided for @ng_keep_running.
  ///
  /// In en, this message translates to:
  /// **'Stay connected while a reply runs'**
  String get ng_keep_running;

  /// No description provided for @ng_keep_running_hint.
  ///
  /// In en, this message translates to:
  /// **'Keeps the connection open in the background until the reply finishes, with a quiet notification'**
  String get ng_keep_running_hint;

  /// No description provided for @ng_battery_settings.
  ///
  /// In en, this message translates to:
  /// **'Battery optimisation'**
  String get ng_battery_settings;

  /// No description provided for @ng_battery_settings_hint.
  ///
  /// In en, this message translates to:
  /// **'Let Ares run in the background so notifications arrive on time'**
  String get ng_battery_settings_hint;

  /// No description provided for @ng_send_test_notification.
  ///
  /// In en, this message translates to:
  /// **'Send a test notification'**
  String get ng_send_test_notification;

  /// No description provided for @ng_test_notification_title.
  ///
  /// In en, this message translates to:
  /// **'Ares notifications work'**
  String get ng_test_notification_title;

  /// No description provided for @ng_test_notification_body.
  ///
  /// In en, this message translates to:
  /// **'Replies and requests will show up like this.'**
  String get ng_test_notification_body;

  /// No description provided for @ng_test_notification_sent.
  ///
  /// In en, this message translates to:
  /// **'Test notification sent'**
  String get ng_test_notification_sent;

  /// No description provided for @ng_notifications_blocked.
  ///
  /// In en, this message translates to:
  /// **'Notifications are blocked. Allow them in Android settings.'**
  String get ng_notifications_blocked;

  /// No description provided for @ng_notifications_off_hint.
  ///
  /// In en, this message translates to:
  /// **'Notifications are off, so nothing is posted while Ares is in the background.'**
  String get ng_notifications_off_hint;

  /// No description provided for @ng_insights_building.
  ///
  /// In en, this message translates to:
  /// **'Building the report. A long period can take up to a minute the first time.'**
  String get ng_insights_building;

  /// No description provided for @ng_insights_timed_out.
  ///
  /// In en, this message translates to:
  /// **'The gateway took too long to build this report. Try again, or pick a shorter period.'**
  String get ng_insights_timed_out;

  /// No description provided for @ng_dock_goal_active.
  ///
  /// In en, this message translates to:
  /// **'Goal active'**
  String get ng_dock_goal_active;

  /// No description provided for @ng_dock_goal_paused.
  ///
  /// In en, this message translates to:
  /// **'Goal paused'**
  String get ng_dock_goal_paused;

  /// No description provided for @ng_dock_goal_waiting.
  ///
  /// In en, this message translates to:
  /// **'Goal waiting'**
  String get ng_dock_goal_waiting;

  /// No description provided for @ng_dock_goal_blocked.
  ///
  /// In en, this message translates to:
  /// **'Goal blocked'**
  String get ng_dock_goal_blocked;

  /// No description provided for @ng_dock_goal_done.
  ///
  /// In en, this message translates to:
  /// **'Goal done'**
  String get ng_dock_goal_done;

  /// No description provided for @ng_dock_turn_of.
  ///
  /// In en, this message translates to:
  /// **'Turn {used}/{max}'**
  String ng_dock_turn_of(int used, int max);

  /// No description provided for @ng_dock_turn.
  ///
  /// In en, this message translates to:
  /// **'Turn {used}'**
  String ng_dock_turn(int used);

  /// No description provided for @ng_dock_subagents.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Subagent} other{{count} Subagents}}'**
  String ng_dock_subagents(int count);

  /// No description provided for @ng_dock_subagents_done.
  ///
  /// In en, this message translates to:
  /// **'{count} done'**
  String ng_dock_subagents_done(int count);

  /// No description provided for @ng_dock_tasks.
  ///
  /// In en, this message translates to:
  /// **'Tasks {done}/{total}'**
  String ng_dock_tasks(int done, int total);

  /// No description provided for @ng_dock_previous_tasks.
  ///
  /// In en, this message translates to:
  /// **'Previous tasks {done}/{total}'**
  String ng_dock_previous_tasks(int done, int total);

  /// No description provided for @ng_dock_manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get ng_dock_manage;

  /// No description provided for @ng_recent_notifications.
  ///
  /// In en, this message translates to:
  /// **'Recent notifications'**
  String get ng_recent_notifications;

  /// No description provided for @ng_recent_notifications_hint.
  ///
  /// In en, this message translates to:
  /// **'What Ares tried to post and whether Android showed it'**
  String get ng_recent_notifications_hint;

  /// No description provided for @ng_recent_notifications_empty.
  ///
  /// In en, this message translates to:
  /// **'Nothing yet. Attempts appear here once a reply, question or failure would notify you.'**
  String get ng_recent_notifications_empty;

  /// No description provided for @ng_notify_permission_granted.
  ///
  /// In en, this message translates to:
  /// **'Permission granted'**
  String get ng_notify_permission_granted;

  /// No description provided for @ng_notify_permission_denied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get ng_notify_permission_denied;

  /// No description provided for @ng_notify_master_on.
  ///
  /// In en, this message translates to:
  /// **'Notifications on'**
  String get ng_notify_master_on;

  /// No description provided for @ng_notify_master_off.
  ///
  /// In en, this message translates to:
  /// **'Notifications off'**
  String get ng_notify_master_off;

  /// No description provided for @ng_models_default.
  ///
  /// In en, this message translates to:
  /// **'Default model'**
  String get ng_models_default;

  /// No description provided for @ng_models_change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get ng_models_change;

  /// No description provided for @ng_models_custom_endpoint.
  ///
  /// In en, this message translates to:
  /// **'Runs on a custom endpoint. Change it on the gateway.'**
  String get ng_models_custom_endpoint;

  /// No description provided for @ng_models_context_window.
  ///
  /// In en, this message translates to:
  /// **'Context window'**
  String get ng_models_context_window;

  /// No description provided for @ng_models_token_count.
  ///
  /// In en, this message translates to:
  /// **'{count} tokens'**
  String ng_models_token_count(String count);

  /// No description provided for @ng_models_context_override.
  ///
  /// In en, this message translates to:
  /// **'Set on the gateway. Auto-detected: {count} tokens.'**
  String ng_models_context_override(String count);

  /// No description provided for @ng_models_max_output.
  ///
  /// In en, this message translates to:
  /// **'Max output'**
  String get ng_models_max_output;

  /// No description provided for @ng_models_input_price.
  ///
  /// In en, this message translates to:
  /// **'Input price'**
  String get ng_models_input_price;

  /// No description provided for @ng_models_output_price.
  ///
  /// In en, this message translates to:
  /// **'Output price'**
  String get ng_models_output_price;

  /// No description provided for @ng_models_cache_price.
  ///
  /// In en, this message translates to:
  /// **'Cached input price'**
  String get ng_models_cache_price;

  /// No description provided for @ng_models_per_million.
  ///
  /// In en, this message translates to:
  /// **'{price} per 1M tokens'**
  String ng_models_per_million(String price);

  /// No description provided for @ng_models_price_pair.
  ///
  /// In en, this message translates to:
  /// **'{input} in · {output} out per 1M tokens'**
  String ng_models_price_pair(String input, String output);

  /// No description provided for @ng_models_free.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get ng_models_free;

  /// No description provided for @ng_models_vision.
  ///
  /// In en, this message translates to:
  /// **'Vision'**
  String get ng_models_vision;

  /// No description provided for @ng_models_reasoning.
  ///
  /// In en, this message translates to:
  /// **'Reasoning'**
  String get ng_models_reasoning;

  /// No description provided for @ng_models_fast.
  ///
  /// In en, this message translates to:
  /// **'Fast mode'**
  String get ng_models_fast;

  /// No description provided for @ng_models_in_use.
  ///
  /// In en, this message translates to:
  /// **'In use'**
  String get ng_models_in_use;

  /// No description provided for @ng_models_count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} model} other{{count} models}}'**
  String ng_models_count(int count);

  /// No description provided for @ng_models_rate_limited.
  ///
  /// In en, this message translates to:
  /// **'Rate-limited'**
  String get ng_models_rate_limited;

  /// No description provided for @ng_models_plan_locked.
  ///
  /// In en, this message translates to:
  /// **'Not on your plan'**
  String get ng_models_plan_locked;

  /// No description provided for @ng_models_unsaved.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get ng_models_unsaved;

  /// No description provided for @ng_models_discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get ng_models_discard;

  /// No description provided for @ng_models_aux_hint.
  ///
  /// In en, this message translates to:
  /// **'Helper tasks use the default model unless you give them their own.'**
  String get ng_models_aux_hint;

  /// No description provided for @ng_models_uses_default.
  ///
  /// In en, this message translates to:
  /// **'Uses the default model'**
  String get ng_models_uses_default;

  /// No description provided for @ng_models_thinking_level.
  ///
  /// In en, this message translates to:
  /// **'Thinking level'**
  String get ng_models_thinking_level;

  /// No description provided for @ng_models_providers.
  ///
  /// In en, this message translates to:
  /// **'Providers'**
  String get ng_models_providers;

  /// No description provided for @ng_models_saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get ng_models_saved;

  /// No description provided for @ng_aux_vision.
  ///
  /// In en, this message translates to:
  /// **'Vision'**
  String get ng_aux_vision;

  /// No description provided for @ng_aux_vision_hint.
  ///
  /// In en, this message translates to:
  /// **'Reads images and screenshots'**
  String get ng_aux_vision_hint;

  /// No description provided for @ng_aux_compression.
  ///
  /// In en, this message translates to:
  /// **'Compression'**
  String get ng_aux_compression;

  /// No description provided for @ng_aux_compression_hint.
  ///
  /// In en, this message translates to:
  /// **'Shortens a long chat so it fits the context window'**
  String get ng_aux_compression_hint;

  /// No description provided for @ng_aux_approval.
  ///
  /// In en, this message translates to:
  /// **'Approval'**
  String get ng_aux_approval;

  /// No description provided for @ng_aux_approval_hint.
  ///
  /// In en, this message translates to:
  /// **'Decides whether a command is safe to run without asking'**
  String get ng_aux_approval_hint;

  /// No description provided for @ng_aux_mcp.
  ///
  /// In en, this message translates to:
  /// **'MCP'**
  String get ng_aux_mcp;

  /// No description provided for @ng_aux_mcp_hint.
  ///
  /// In en, this message translates to:
  /// **'Chooses which MCP tools to use'**
  String get ng_aux_mcp_hint;

  /// No description provided for @ng_aux_title_generation.
  ///
  /// In en, this message translates to:
  /// **'Chat titles'**
  String get ng_aux_title_generation;

  /// No description provided for @ng_aux_title_generation_hint.
  ///
  /// In en, this message translates to:
  /// **'Names new chats'**
  String get ng_aux_title_generation_hint;

  /// No description provided for @ng_aux_review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get ng_aux_review;

  /// No description provided for @ng_aux_review_hint.
  ///
  /// In en, this message translates to:
  /// **'Reviews work when you run /review'**
  String get ng_aux_review_hint;

  /// No description provided for @ng_aux_voice_chat.
  ///
  /// In en, this message translates to:
  /// **'Voice chat'**
  String get ng_aux_voice_chat;

  /// No description provided for @ng_aux_voice_chat_hint.
  ///
  /// In en, this message translates to:
  /// **'Replies in voice mode'**
  String get ng_aux_voice_chat_hint;

  /// No description provided for @ng_aux_triage_specifier.
  ///
  /// In en, this message translates to:
  /// **'Triage'**
  String get ng_aux_triage_specifier;

  /// No description provided for @ng_aux_triage_specifier_hint.
  ///
  /// In en, this message translates to:
  /// **'Expands a one-line Kanban card into a spec'**
  String get ng_aux_triage_specifier_hint;

  /// No description provided for @ng_aux_kanban_decomposer.
  ///
  /// In en, this message translates to:
  /// **'Kanban breakdown'**
  String get ng_aux_kanban_decomposer;

  /// No description provided for @ng_aux_kanban_decomposer_hint.
  ///
  /// In en, this message translates to:
  /// **'Splits a Kanban card into smaller tasks'**
  String get ng_aux_kanban_decomposer_hint;

  /// No description provided for @ng_aux_profile_describer.
  ///
  /// In en, this message translates to:
  /// **'Profile descriptions'**
  String get ng_aux_profile_describer;

  /// No description provided for @ng_aux_profile_describer_hint.
  ///
  /// In en, this message translates to:
  /// **'Writes each profile\'s short description'**
  String get ng_aux_profile_describer_hint;

  /// No description provided for @ng_aux_curator.
  ///
  /// In en, this message translates to:
  /// **'Curator'**
  String get ng_aux_curator;

  /// No description provided for @ng_aux_curator_hint.
  ///
  /// In en, this message translates to:
  /// **'Reviews how skills are used'**
  String get ng_aux_curator_hint;

  /// No description provided for @appearance_save_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not save this change.'**
  String get appearance_save_failed;

  /// No description provided for @appearance_keep_which_theme.
  ///
  /// In en, this message translates to:
  /// **'Keep which theme?'**
  String get appearance_keep_which_theme;

  /// No description provided for @appearance_tour_back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get appearance_tour_back;

  /// No description provided for @appearance_tour_finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get appearance_tour_finish;

  /// No description provided for @appearance_tour_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get appearance_tour_next;

  /// No description provided for @appearance_tour_close.
  ///
  /// In en, this message translates to:
  /// **'Close tour'**
  String get appearance_tour_close;

  /// No description provided for @appearance_dismiss_tip.
  ///
  /// In en, this message translates to:
  /// **'Dismiss tip'**
  String get appearance_dismiss_tip;

  /// No description provided for @appearance_search_settings.
  ///
  /// In en, this message translates to:
  /// **'Search settings'**
  String get appearance_search_settings;

  /// No description provided for @appearance_search_show.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get appearance_search_show;

  /// No description provided for @appearance_no_matching_setting.
  ///
  /// In en, this message translates to:
  /// **'No matching setting.'**
  String get appearance_no_matching_setting;

  /// No description provided for @appearance_replay_tour.
  ///
  /// In en, this message translates to:
  /// **'Replay tour'**
  String get appearance_replay_tour;

  /// No description provided for @appearance_show_tips_again.
  ///
  /// In en, this message translates to:
  /// **'Show tips again'**
  String get appearance_show_tips_again;

  /// No description provided for @appearance_window_translucency_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Window translucency is not available on this host. Linux cannot provide it, and the Apple and Windows runners paint an opaque Flutter view.'**
  String get appearance_window_translucency_unavailable;

  /// No description provided for @appearance_imported_themes.
  ///
  /// In en, this message translates to:
  /// **'Imported themes'**
  String get appearance_imported_themes;

  /// No description provided for @appearance_import_theme_file.
  ///
  /// In en, this message translates to:
  /// **'Import theme file'**
  String get appearance_import_theme_file;

  /// No description provided for @appearance_remove_theme.
  ///
  /// In en, this message translates to:
  /// **'Remove theme'**
  String get appearance_remove_theme;

  /// No description provided for @appearance_chat_font.
  ///
  /// In en, this message translates to:
  /// **'Chat font'**
  String get appearance_chat_font;

  /// No description provided for @appearance_terminal_font.
  ///
  /// In en, this message translates to:
  /// **'Terminal font'**
  String get appearance_terminal_font;

  /// No description provided for @appearance_font_platform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get appearance_font_platform;

  /// No description provided for @appearance_automatic.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get appearance_automatic;

  /// No description provided for @appearance_force_left_to_right.
  ///
  /// In en, this message translates to:
  /// **'Force left to right'**
  String get appearance_force_left_to_right;

  /// No description provided for @appearance_force_right_to_left.
  ///
  /// In en, this message translates to:
  /// **'Force right to left'**
  String get appearance_force_right_to_left;

  /// No description provided for @appearance_user_bubble_opacity.
  ///
  /// In en, this message translates to:
  /// **'User bubble opacity'**
  String get appearance_user_bubble_opacity;

  /// No description provided for @appearance_inline_embeds.
  ///
  /// In en, this message translates to:
  /// **'Inline embeds'**
  String get appearance_inline_embeds;

  /// No description provided for @appearance_inline_embeds_hint.
  ///
  /// In en, this message translates to:
  /// **'Rich previews load from third-party sites (YouTube, X, …). Ask shows a placeholder until you allow each one; Always loads them automatically; Off keeps plain links.'**
  String get appearance_inline_embeds_hint;

  /// No description provided for @appearance_embeds_ask.
  ///
  /// In en, this message translates to:
  /// **'Ask'**
  String get appearance_embeds_ask;

  /// No description provided for @appearance_embeds_always.
  ///
  /// In en, this message translates to:
  /// **'Always'**
  String get appearance_embeds_always;

  /// No description provided for @appearance_embeds_off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get appearance_embeds_off;

  /// No description provided for @appearance_embeds_reset.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Reset 1 allowed service} other{Reset {count} allowed services}}'**
  String appearance_embeds_reset(int count);

  /// No description provided for @appearance_embed_load.
  ///
  /// In en, this message translates to:
  /// **'Load'**
  String get appearance_embed_load;

  /// No description provided for @appearance_embed_always_allow.
  ///
  /// In en, this message translates to:
  /// **'Always allow {service}'**
  String appearance_embed_always_allow(String service);

  /// No description provided for @appearance_embed_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading preview…'**
  String get appearance_embed_loading;

  /// No description provided for @appearance_embed_image_failed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load the image from {host}. Tap to open it.'**
  String appearance_embed_image_failed(String host);

  /// No description provided for @appearance_embed_preview_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Preview unavailable'**
  String get appearance_embed_preview_unavailable;

  /// No description provided for @appearance_emoji_reactions.
  ///
  /// In en, this message translates to:
  /// **'Emoji reactions'**
  String get appearance_emoji_reactions;

  /// No description provided for @appearance_celebration_hearts.
  ///
  /// In en, this message translates to:
  /// **'Celebration hearts'**
  String get appearance_celebration_hearts;

  /// No description provided for @appearance_celebration_hearts_hint.
  ///
  /// In en, this message translates to:
  /// **'A heart plays when a reply arrives while you were away.'**
  String get appearance_celebration_hearts_hint;

  /// No description provided for @appearance_pop_out_companion.
  ///
  /// In en, this message translates to:
  /// **'Pop out companion'**
  String get appearance_pop_out_companion;

  /// No description provided for @appearance_mosskip.
  ///
  /// In en, this message translates to:
  /// **'Mosskip'**
  String get appearance_mosskip;

  /// No description provided for @appearance_emberbun.
  ///
  /// In en, this message translates to:
  /// **'Emberbun'**
  String get appearance_emberbun;

  /// No description provided for @appearance_tideling.
  ///
  /// In en, this message translates to:
  /// **'Tideling'**
  String get appearance_tideling;

  /// No description provided for @appearance_my_hatchling.
  ///
  /// In en, this message translates to:
  /// **'My hatchling'**
  String get appearance_my_hatchling;

  /// No description provided for @appearance_at_rest.
  ///
  /// In en, this message translates to:
  /// **'At rest'**
  String get appearance_at_rest;

  /// No description provided for @appearance_working.
  ///
  /// In en, this message translates to:
  /// **'Working'**
  String get appearance_working;

  /// No description provided for @appearance_thinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking'**
  String get appearance_thinking;

  /// No description provided for @appearance_waiting_for_you.
  ///
  /// In en, this message translates to:
  /// **'Waiting for you'**
  String get appearance_waiting_for_you;

  /// No description provided for @appearance_reply_ready.
  ///
  /// In en, this message translates to:
  /// **'Reply ready'**
  String get appearance_reply_ready;

  /// No description provided for @appearance_turn_failed.
  ///
  /// In en, this message translates to:
  /// **'Turn failed'**
  String get appearance_turn_failed;

  /// No description provided for @appearance_small.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get appearance_small;

  /// No description provided for @appearance_medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get appearance_medium;

  /// No description provided for @appearance_large.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get appearance_large;

  /// No description provided for @appearance_hello.
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get appearance_hello;

  /// No description provided for @appearance_unread_reply.
  ///
  /// In en, this message translates to:
  /// **'Unread reply'**
  String get appearance_unread_reply;

  /// No description provided for @appearance_compose.
  ///
  /// In en, this message translates to:
  /// **'Compose'**
  String get appearance_compose;

  /// No description provided for @appearance_say_hello.
  ///
  /// In en, this message translates to:
  /// **'Say hello'**
  String get appearance_say_hello;

  /// No description provided for @appearance_pet_image_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not open that image. Choose a smaller PNG or JPEG.'**
  String get appearance_pet_image_failed;

  /// No description provided for @appearance_pet_companion.
  ///
  /// In en, this message translates to:
  /// **'Pet companion'**
  String get appearance_pet_companion;

  /// No description provided for @appearance_pet_companion_hint.
  ///
  /// In en, this message translates to:
  /// **'Show a companion while you chat.'**
  String get appearance_pet_companion_hint;

  /// No description provided for @appearance_adopt_a_companion.
  ///
  /// In en, this message translates to:
  /// **'Adopt a companion'**
  String get appearance_adopt_a_companion;

  /// No description provided for @appearance_roam_when_idle.
  ///
  /// In en, this message translates to:
  /// **'Roam when idle'**
  String get appearance_roam_when_idle;

  /// No description provided for @appearance_pet_size.
  ///
  /// In en, this message translates to:
  /// **'Pet size'**
  String get appearance_pet_size;

  /// No description provided for @appearance_hatch_from_a_local_picture.
  ///
  /// In en, this message translates to:
  /// **'Hatch from a local picture'**
  String get appearance_hatch_from_a_local_picture;

  /// No description provided for @appearance_pet_image_limits.
  ///
  /// In en, this message translates to:
  /// **'Choose a PNG or JPEG (up to 4 MiB, 4096 px per side and 8 MP). Preview it first. Hatching saves one 24 × 24 pixel portrait and replaces your previous hatchling.'**
  String get appearance_pet_image_limits;

  /// No description provided for @appearance_choose_picture.
  ///
  /// In en, this message translates to:
  /// **'Choose picture'**
  String get appearance_choose_picture;

  /// No description provided for @appearance_hatchling_preview.
  ///
  /// In en, this message translates to:
  /// **'Hatchling preview'**
  String get appearance_hatchling_preview;

  /// No description provided for @appearance_hatch_and_adopt.
  ///
  /// In en, this message translates to:
  /// **'Hatch and adopt'**
  String get appearance_hatch_and_adopt;

  /// No description provided for @appearance_discard_draft.
  ///
  /// In en, this message translates to:
  /// **'Discard draft'**
  String get appearance_discard_draft;

  /// No description provided for @appearance_forget_saved_hatchling.
  ///
  /// In en, this message translates to:
  /// **'Forget saved hatchling'**
  String get appearance_forget_saved_hatchling;

  /// No description provided for @appearance_radio.
  ///
  /// In en, this message translates to:
  /// **'Radio'**
  String get appearance_radio;

  /// No description provided for @appearance_radio_hint.
  ///
  /// In en, this message translates to:
  /// **'Streams come straight from {stations} and start only when you press Play. Station search stays on this device.'**
  String appearance_radio_hint(String stations);

  /// No description provided for @appearance_radio_save_failed.
  ///
  /// In en, this message translates to:
  /// **'Radio settings could not be saved.'**
  String get appearance_radio_save_failed;

  /// No description provided for @appearance_choose_a_station.
  ///
  /// In en, this message translates to:
  /// **'Choose a station'**
  String get appearance_choose_a_station;

  /// No description provided for @appearance_pause_radio.
  ///
  /// In en, this message translates to:
  /// **'Pause radio'**
  String get appearance_pause_radio;

  /// No description provided for @appearance_play_radio.
  ///
  /// In en, this message translates to:
  /// **'Play radio'**
  String get appearance_play_radio;

  /// No description provided for @appearance_next_station.
  ///
  /// In en, this message translates to:
  /// **'Next station'**
  String get appearance_next_station;

  /// No description provided for @appearance_radio_trace_semantics.
  ///
  /// In en, this message translates to:
  /// **'Stream activity. Audio levels are unavailable, so this line stays flat.'**
  String get appearance_radio_trace_semantics;

  /// No description provided for @appearance_radio_is_off.
  ///
  /// In en, this message translates to:
  /// **'Radio is off'**
  String get appearance_radio_is_off;

  /// No description provided for @appearance_paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get appearance_paused;

  /// No description provided for @appearance_connecting.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get appearance_connecting;

  /// No description provided for @appearance_live.
  ///
  /// In en, this message translates to:
  /// **'Live'**
  String get appearance_live;

  /// No description provided for @appearance_stream_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Stream unavailable'**
  String get appearance_stream_unavailable;

  /// No description provided for @appearance_now_playing.
  ///
  /// In en, this message translates to:
  /// **'Now playing: {credit}'**
  String appearance_now_playing(String credit);

  /// No description provided for @appearance_audio_only_waveform_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Audio only · waveform unavailable'**
  String get appearance_audio_only_waveform_unavailable;

  /// No description provided for @appearance_volume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get appearance_volume;

  /// No description provided for @appearance_search_presets.
  ///
  /// In en, this message translates to:
  /// **'Search presets'**
  String get appearance_search_presets;

  /// No description provided for @appearance_no_stations_found.
  ///
  /// In en, this message translates to:
  /// **'No stations found'**
  String get appearance_no_stations_found;

  /// No description provided for @appearance_unpin_station.
  ///
  /// In en, this message translates to:
  /// **'Unpin station: {station}'**
  String appearance_unpin_station(String station);

  /// No description provided for @appearance_pin_station.
  ///
  /// In en, this message translates to:
  /// **'Pin station: {station}'**
  String appearance_pin_station(String station);

  /// No description provided for @appearance_radio_picker_metadata_notice.
  ///
  /// In en, this message translates to:
  /// **'While this picker is open, playing stations may share track details directly from the broadcaster.'**
  String get appearance_radio_picker_metadata_notice;

  /// No description provided for @appearance_message_from_your_companion.
  ///
  /// In en, this message translates to:
  /// **'Message from your companion'**
  String get appearance_message_from_your_companion;

  /// No description provided for @appearance_send_to_the_open_chat.
  ///
  /// In en, this message translates to:
  /// **'Send to the open chat'**
  String get appearance_send_to_the_open_chat;

  /// No description provided for @appearance_tour_theme_body.
  ///
  /// In en, this message translates to:
  /// **'Import a VS Code colour theme from a file on this device, then choose which variant to keep.'**
  String get appearance_tour_theme_body;

  /// No description provided for @appearance_tour_fonts_title.
  ///
  /// In en, this message translates to:
  /// **'Reading fonts'**
  String get appearance_tour_fonts_title;

  /// No description provided for @appearance_tour_fonts_body.
  ///
  /// In en, this message translates to:
  /// **'Chat prose and terminal code use separate faces shipped with Ares.'**
  String get appearance_tour_fonts_body;

  /// No description provided for @appearance_tour_direction_title.
  ///
  /// In en, this message translates to:
  /// **'Transcript direction'**
  String get appearance_tour_direction_title;

  /// No description provided for @appearance_tour_direction_body.
  ///
  /// In en, this message translates to:
  /// **'Leave this on automatic, or force the transcript left to right or right to left.'**
  String get appearance_tour_direction_body;

  /// No description provided for @appearance_tour_pet_title.
  ///
  /// In en, this message translates to:
  /// **'Companion'**
  String get appearance_tour_pet_title;

  /// No description provided for @appearance_tour_pet_body.
  ///
  /// In en, this message translates to:
  /// **'The companion is off until you adopt one. Pop-out adds a small composer.'**
  String get appearance_tour_pet_body;

  /// No description provided for @appearance_tour_radio_body.
  ///
  /// In en, this message translates to:
  /// **'Radio stays off until you enable it. Play is what opens a stream.'**
  String get appearance_tour_radio_body;

  /// No description provided for @appearance_tip_theme.
  ///
  /// In en, this message translates to:
  /// **'Imported themes replace the built-in palette until you clear the selection. Only the colours are kept.'**
  String get appearance_tip_theme;

  /// No description provided for @appearance_tip_pet.
  ///
  /// In en, this message translates to:
  /// **'The companion stores one small portrait on this device. It does not upload the picture you hatch from.'**
  String get appearance_tip_pet;

  /// No description provided for @appearance_theme_import_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not import that theme. Choose a VS Code colour theme saved as a .vsix, .json or .jsonc file.'**
  String get appearance_theme_import_failed;

  /// No description provided for @render_widget_file_truncated.
  ///
  /// In en, this message translates to:
  /// **'Only the start of this file was read, so the widget may be incomplete.'**
  String get render_widget_file_truncated;

  /// No description provided for @setup_beat_title.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get setup_beat_title;

  /// No description provided for @setup_beat_use_name.
  ///
  /// In en, this message translates to:
  /// **'Use {name}'**
  String setup_beat_use_name(String name);

  /// No description provided for @setup_beat_name_hint.
  ///
  /// In en, this message translates to:
  /// **'What should Hermes call you?'**
  String get setup_beat_name_hint;

  /// No description provided for @setup_beat_on_computer.
  ///
  /// In en, this message translates to:
  /// **'This step is done in Hermes on the computer it runs on. Continue keeps what is set up there.'**
  String get setup_beat_on_computer;

  /// No description provided for @setup_beat_not_waiting.
  ///
  /// In en, this message translates to:
  /// **'This setup card is no longer waiting for an answer.'**
  String get setup_beat_not_waiting;

  /// No description provided for @catalog_kind_plugin.
  ///
  /// In en, this message translates to:
  /// **'Plugin'**
  String get catalog_kind_plugin;

  /// No description provided for @catalog_kind_skill.
  ///
  /// In en, this message translates to:
  /// **'Skill'**
  String get catalog_kind_skill;

  /// No description provided for @catalog_tier_official.
  ///
  /// In en, this message translates to:
  /// **'Official'**
  String get catalog_tier_official;

  /// No description provided for @catalog_tier_verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get catalog_tier_verified;

  /// No description provided for @catalog_tier_community.
  ///
  /// In en, this message translates to:
  /// **'Community'**
  String get catalog_tier_community;

  /// No description provided for @catalog_install.
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get catalog_install;

  /// No description provided for @catalog_waiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for your choice'**
  String get catalog_waiting;

  /// No description provided for @catalog_installed.
  ///
  /// In en, this message translates to:
  /// **'Installed'**
  String get catalog_installed;

  /// No description provided for @catalog_installed_off.
  ///
  /// In en, this message translates to:
  /// **'Installed, not turned on'**
  String get catalog_installed_off;

  /// No description provided for @catalog_skipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get catalog_skipped;

  /// No description provided for @catalog_not_installed.
  ///
  /// In en, this message translates to:
  /// **'Not installed'**
  String get catalog_not_installed;

  /// No description provided for @catalog_target_profile.
  ///
  /// In en, this message translates to:
  /// **'Installs into the {profile} profile'**
  String catalog_target_profile(String profile);

  /// No description provided for @catalog_source.
  ///
  /// In en, this message translates to:
  /// **'{repo} at {sha}'**
  String catalog_source(String repo, String sha);

  /// No description provided for @catalog_scan.
  ///
  /// In en, this message translates to:
  /// **'Security scan: {status}. {summary}'**
  String catalog_scan(String status, String summary);

  /// No description provided for @catalog_requires_hermes.
  ///
  /// In en, this message translates to:
  /// **'Needs Hermes {range}'**
  String catalog_requires_hermes(String range);

  /// No description provided for @catalog_skill_ready.
  ///
  /// In en, this message translates to:
  /// **'Skill {name} is ready to use'**
  String catalog_skill_ready(String name);

  /// No description provided for @catalog_missing_env.
  ///
  /// In en, this message translates to:
  /// **'Still needs: {names}'**
  String catalog_missing_env(String names);

  /// No description provided for @catalog_server_error.
  ///
  /// In en, this message translates to:
  /// **'{name} did not connect: {error}'**
  String catalog_server_error(String name, String error);

  /// No description provided for @catalog_send_failed.
  ///
  /// In en, this message translates to:
  /// **'Your choice was not sent. Try again.'**
  String get catalog_send_failed;

  /// No description provided for @attachment_video_speed.
  ///
  /// In en, this message translates to:
  /// **'Playback speed'**
  String get attachment_video_speed;

  /// No description provided for @catalog_installing.
  ///
  /// In en, this message translates to:
  /// **'Installing…'**
  String get catalog_installing;

  /// No description provided for @catalog_phase_downloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading…'**
  String get catalog_phase_downloading;

  /// No description provided for @catalog_phase_python_packages.
  ///
  /// In en, this message translates to:
  /// **'Installing Python packages…'**
  String get catalog_phase_python_packages;

  /// No description provided for @catalog_phase_loading_tools.
  ///
  /// In en, this message translates to:
  /// **'Loading its tools…'**
  String get catalog_phase_loading_tools;

  /// No description provided for @setup_beat_send_failed.
  ///
  /// In en, this message translates to:
  /// **'Your answer was not sent. Try again.'**
  String get setup_beat_send_failed;

  /// No description provided for @catalog_tool_count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 tool} other{{count} tools}}'**
  String catalog_tool_count(int count);

  /// No description provided for @render_svg_not_drawn.
  ///
  /// In en, this message translates to:
  /// **'This SVG was not drawn.'**
  String get render_svg_not_drawn;

  /// No description provided for @render_notes_directive.
  ///
  /// In en, this message translates to:
  /// **'Notes directive'**
  String get render_notes_directive;

  /// No description provided for @render_maths_source.
  ///
  /// In en, this message translates to:
  /// **'Maths source'**
  String get render_maths_source;

  /// No description provided for @render_inline_maths_source.
  ///
  /// In en, this message translates to:
  /// **'Inline maths source'**
  String get render_inline_maths_source;

  /// No description provided for @render_sequence_outline.
  ///
  /// In en, this message translates to:
  /// **'Sequence outline'**
  String get render_sequence_outline;

  /// No description provided for @render_diagram_outline.
  ///
  /// In en, this message translates to:
  /// **'Diagram outline'**
  String get render_diagram_outline;

  /// No description provided for @render_revision_of.
  ///
  /// In en, this message translates to:
  /// **'Revision {index} of {count}'**
  String render_revision_of(int index, int count);

  /// No description provided for @render_previous_revision.
  ///
  /// In en, this message translates to:
  /// **'Previous revision'**
  String get render_previous_revision;

  /// No description provided for @render_next_revision.
  ///
  /// In en, this message translates to:
  /// **'Next revision'**
  String get render_next_revision;

  /// No description provided for @render_show_rendered.
  ///
  /// In en, this message translates to:
  /// **'Rendered'**
  String get render_show_rendered;

  /// No description provided for @render_show_source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get render_show_source;

  /// No description provided for @render_copied_file.
  ///
  /// In en, this message translates to:
  /// **'Copied {name}'**
  String render_copied_file(String name);

  /// No description provided for @render_copy_file.
  ///
  /// In en, this message translates to:
  /// **'Copy {name}'**
  String render_copy_file(String name);

  /// No description provided for @render_artifact_too_long.
  ///
  /// In en, this message translates to:
  /// **'This artefact is too long to show as a page here.'**
  String get render_artifact_too_long;

  /// No description provided for @render_active_content_removed.
  ///
  /// In en, this message translates to:
  /// **'Scripts, frames and external addresses were removed.'**
  String get render_active_content_removed;

  /// No description provided for @render_widget_file.
  ///
  /// In en, this message translates to:
  /// **'Widget {file}'**
  String render_widget_file(String file);

  /// No description provided for @render_widget_runs_as_text.
  ///
  /// In en, this message translates to:
  /// **'Runs as text in this chat. Scripts and external frames are removed.'**
  String get render_widget_runs_as_text;

  /// No description provided for @render_load_widget.
  ///
  /// In en, this message translates to:
  /// **'Load widget'**
  String get render_load_widget;

  /// No description provided for @render_not_html_widget.
  ///
  /// In en, this message translates to:
  /// **'This file is not an HTML widget.'**
  String get render_not_html_widget;

  /// No description provided for @render_widget_sent.
  ///
  /// In en, this message translates to:
  /// **'Sent to this chat'**
  String get render_widget_sent;

  /// No description provided for @render_widget_not_sent.
  ///
  /// In en, this message translates to:
  /// **'Not sent to this chat'**
  String get render_widget_not_sent;

  /// No description provided for @render_widget_throttled.
  ///
  /// In en, this message translates to:
  /// **'Wait a moment before sending again'**
  String get render_widget_throttled;

  /// No description provided for @render_widget_too_long.
  ///
  /// In en, this message translates to:
  /// **'This request is too long to send'**
  String get render_widget_too_long;

  /// No description provided for @render_widget_no_gesture.
  ///
  /// In en, this message translates to:
  /// **'Tap a control in the widget to send'**
  String get render_widget_no_gesture;

  /// No description provided for @render_widget_invalid.
  ///
  /// In en, this message translates to:
  /// **'This request could not be sent'**
  String get render_widget_invalid;

  /// No description provided for @render_inspected_image.
  ///
  /// In en, this message translates to:
  /// **'Inspected image'**
  String get render_inspected_image;

  /// No description provided for @render_contributions.
  ///
  /// In en, this message translates to:
  /// **'Contributions'**
  String get render_contributions;

  /// No description provided for @render_contributions_intro.
  ///
  /// In en, this message translates to:
  /// **'Only contributions compiled into Ares can add to a reply. Chat text cannot register one, and a grant applies to this connection only.'**
  String get render_contributions_intro;

  /// No description provided for @render_grant_plugin.
  ///
  /// In en, this message translates to:
  /// **'Grant {name}'**
  String render_grant_plugin(String name);

  /// No description provided for @render_revoke_plugin.
  ///
  /// In en, this message translates to:
  /// **'Revoke {name}'**
  String render_revoke_plugin(String name);

  /// No description provided for @render_plugin_slots.
  ///
  /// In en, this message translates to:
  /// **'reply cards for ::{directive}'**
  String render_plugin_slots(String directive);

  /// No description provided for @render_plugin_notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get render_plugin_notes;

  /// No description provided for @catalog_scan_passed.
  ///
  /// In en, this message translates to:
  /// **'passed'**
  String get catalog_scan_passed;

  /// No description provided for @catalog_scan_warnings.
  ///
  /// In en, this message translates to:
  /// **'found warnings'**
  String get catalog_scan_warnings;

  /// No description provided for @catalog_scan_failed.
  ///
  /// In en, this message translates to:
  /// **'failed'**
  String get catalog_scan_failed;

  /// No description provided for @deployment_token_label.
  ///
  /// In en, this message translates to:
  /// **'Deployment token (optional)'**
  String get deployment_token_label;

  /// No description provided for @deployment_token_helper.
  ///
  /// In en, this message translates to:
  /// **'For Hermes Dashboard session tokens sent as X-Hermes-Session-Token. Not stored in plaintext preferences.'**
  String get deployment_token_helper;

  /// No description provided for @deployment_token_hint.
  ///
  /// In en, this message translates to:
  /// **'Dashboard session token'**
  String get deployment_token_hint;

  /// No description provided for @custom_headers_label.
  ///
  /// In en, this message translates to:
  /// **'Custom headers (optional)'**
  String get custom_headers_label;

  /// No description provided for @custom_headers_helper.
  ///
  /// In en, this message translates to:
  /// **'One per line, e.g. X-Custom: value. Forbidden headers are rejected.'**
  String get custom_headers_helper;

  /// No description provided for @custom_headers_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. X-Custom-Header: value'**
  String get custom_headers_hint;

  /// No description provided for @desktop_tray_open.
  ///
  /// In en, this message translates to:
  /// **'Open Ares'**
  String get desktop_tray_open;

  /// No description provided for @desktop_tray_new_chat.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get desktop_tray_new_chat;

  /// No description provided for @desktop_tray_quick_entry.
  ///
  /// In en, this message translates to:
  /// **'Quick entry…'**
  String get desktop_tray_quick_entry;

  /// No description provided for @desktop_tray_pause_notifications.
  ///
  /// In en, this message translates to:
  /// **'Pause notifications'**
  String get desktop_tray_pause_notifications;

  /// No description provided for @desktop_tray_quit.
  ///
  /// In en, this message translates to:
  /// **'Quit Ares'**
  String get desktop_tray_quit;

  /// No description provided for @desktop_integration_title.
  ///
  /// In en, this message translates to:
  /// **'Desktop integration'**
  String get desktop_integration_title;

  /// No description provided for @desktop_tray_setting.
  ///
  /// In en, this message translates to:
  /// **'Show Ares in the tray or menu bar'**
  String get desktop_tray_setting;

  /// No description provided for @desktop_tray_setting_help.
  ///
  /// In en, this message translates to:
  /// **'Open Ares, start a chat, open quick entry, pause notifications or quit from the icon.'**
  String get desktop_tray_setting_help;

  /// No description provided for @desktop_close_to_tray_setting.
  ///
  /// In en, this message translates to:
  /// **'Keep running in the tray when the window closes'**
  String get desktop_close_to_tray_setting;

  /// No description provided for @desktop_tray_unsupported.
  ///
  /// In en, this message translates to:
  /// **'This desktop has no system tray Ares can use.'**
  String get desktop_tray_unsupported;

  /// No description provided for @quick_entry_title.
  ///
  /// In en, this message translates to:
  /// **'Quick entry'**
  String get quick_entry_title;

  /// No description provided for @quick_entry_hint.
  ///
  /// In en, this message translates to:
  /// **'Type a prompt for Ares…'**
  String get quick_entry_hint;

  /// No description provided for @quick_entry_submit.
  ///
  /// In en, this message translates to:
  /// **'Put in composer'**
  String get quick_entry_submit;

  /// No description provided for @quick_entry_never_sends.
  ///
  /// In en, this message translates to:
  /// **'Enter puts the text in the chat\'s composer. Nothing is sent until you press Send.'**
  String get quick_entry_never_sends;

  /// No description provided for @quick_entry_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Quick entry couldn\'t open. Try again.'**
  String get quick_entry_unavailable;

  /// No description provided for @desktop_hotkey_setting.
  ///
  /// In en, this message translates to:
  /// **'Quick entry shortcut'**
  String get desktop_hotkey_setting;

  /// No description provided for @desktop_hotkey_help.
  ///
  /// In en, this message translates to:
  /// **'Press {shortcut} anywhere to open quick entry.'**
  String desktop_hotkey_help(String shortcut);

  /// No description provided for @desktop_hotkey_conflict.
  ///
  /// In en, this message translates to:
  /// **'Another app already uses {shortcut}. Choose a different shortcut.'**
  String desktop_hotkey_conflict(String shortcut);

  /// No description provided for @desktop_hotkey_unsupported.
  ///
  /// In en, this message translates to:
  /// **'This desktop does not let apps register a global shortcut (for example on Wayland).'**
  String get desktop_hotkey_unsupported;

  /// No description provided for @desktop_hotkey_no_modifier.
  ///
  /// In en, this message translates to:
  /// **'Include Cmd, Ctrl or Alt.'**
  String get desktop_hotkey_no_modifier;

  /// No description provided for @desktop_hotkey_super_key.
  ///
  /// In en, this message translates to:
  /// **'The Windows or Super key is reserved for the system.'**
  String get desktop_hotkey_super_key;

  /// No description provided for @desktop_hotkey_reserved.
  ///
  /// In en, this message translates to:
  /// **'The system already uses this shortcut.'**
  String get desktop_hotkey_reserved;

  /// No description provided for @desktop_hotkey_in_app.
  ///
  /// In en, this message translates to:
  /// **'Ares already uses this shortcut for {action}.'**
  String desktop_hotkey_in_app(String action);

  /// No description provided for @desktop_hotkey_change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get desktop_hotkey_change;

  /// No description provided for @desktop_hotkey_reset.
  ///
  /// In en, this message translates to:
  /// **'Use default'**
  String get desktop_hotkey_reset;

  /// No description provided for @capture_screen_action.
  ///
  /// In en, this message translates to:
  /// **'Capture screen'**
  String get capture_screen_action;

  /// No description provided for @capture_screen_help.
  ///
  /// In en, this message translates to:
  /// **'Adds a screenshot to the message as a draft. Nothing is sent until you press Send.'**
  String get capture_screen_help;

  /// No description provided for @capture_screen_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Screen capture isn\'t available on this desktop.'**
  String get capture_screen_unavailable;

  /// No description provided for @capture_screen_failed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t capture the screen. Try again.'**
  String get capture_screen_failed;

  /// No description provided for @capture_permission_title.
  ///
  /// In en, this message translates to:
  /// **'Allow screen recording'**
  String get capture_permission_title;

  /// No description provided for @capture_permission_body.
  ///
  /// In en, this message translates to:
  /// **'To capture a window, Ares needs the Screen Recording permission. Turn on Ares in System Settings > Privacy & Security > Screen Recording, then try again.'**
  String get capture_permission_body;

  /// No description provided for @capture_open_settings.
  ///
  /// In en, this message translates to:
  /// **'Open System Settings'**
  String get capture_open_settings;

  /// No description provided for @keep_awake_title.
  ///
  /// In en, this message translates to:
  /// **'Keep computer awake'**
  String get keep_awake_title;

  /// No description provided for @keep_awake_title_mobile.
  ///
  /// In en, this message translates to:
  /// **'Keep screen on'**
  String get keep_awake_title_mobile;

  /// No description provided for @keep_awake_mode_off.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get keep_awake_mode_off;

  /// No description provided for @keep_awake_mode_while_working.
  ///
  /// In en, this message translates to:
  /// **'While working'**
  String get keep_awake_mode_while_working;

  /// No description provided for @keep_awake_mode_always.
  ///
  /// In en, this message translates to:
  /// **'Always'**
  String get keep_awake_mode_always;

  /// No description provided for @keep_awake_off_help.
  ///
  /// In en, this message translates to:
  /// **'Never block system sleep (default).'**
  String get keep_awake_off_help;

  /// No description provided for @keep_awake_while_working_help.
  ///
  /// In en, this message translates to:
  /// **'Prevent idle sleep only while an agent turn is running.'**
  String get keep_awake_while_working_help;

  /// No description provided for @keep_awake_always_help.
  ///
  /// In en, this message translates to:
  /// **'Prevent idle sleep while Ares is open on this device.'**
  String get keep_awake_always_help;

  /// No description provided for @keep_awake_off_help_mobile.
  ///
  /// In en, this message translates to:
  /// **'Let the screen turn off as usual (default).'**
  String get keep_awake_off_help_mobile;

  /// No description provided for @keep_awake_while_working_help_mobile.
  ///
  /// In en, this message translates to:
  /// **'Keep the screen on while an agent turn is running and Ares is open.'**
  String get keep_awake_while_working_help_mobile;

  /// No description provided for @keep_awake_always_help_mobile.
  ///
  /// In en, this message translates to:
  /// **'Keep the screen on while Ares is open.'**
  String get keep_awake_always_help_mobile;

  /// No description provided for @ng_token_gateway_has_no_sign_in.
  ///
  /// In en, this message translates to:
  /// **'This gateway has no sign-in, so it can\'t check a deployment token. Turn on dashboard authentication on the host (or update Hermes), then try again.'**
  String get ng_token_gateway_has_no_sign_in;

  /// No description provided for @palette_open.
  ///
  /// In en, this message translates to:
  /// **'App command palette'**
  String get palette_open;

  /// No description provided for @palette_no_matches.
  ///
  /// In en, this message translates to:
  /// **'No matching actions'**
  String get palette_no_matches;

  /// No description provided for @palette_filter_hint.
  ///
  /// In en, this message translates to:
  /// **'Type to filter actions…'**
  String get palette_filter_hint;

  /// No description provided for @palette_keys_move.
  ///
  /// In en, this message translates to:
  /// **'↑↓ to move'**
  String get palette_keys_move;

  /// No description provided for @palette_keys_run.
  ///
  /// In en, this message translates to:
  /// **'Enter to run'**
  String get palette_keys_run;

  /// No description provided for @palette_keys_close.
  ///
  /// In en, this message translates to:
  /// **'Esc to close'**
  String get palette_keys_close;

  /// No description provided for @palette_search_sessions.
  ///
  /// In en, this message translates to:
  /// **'Search sessions'**
  String get palette_search_sessions;

  /// No description provided for @palette_scheduled_crons.
  ///
  /// In en, this message translates to:
  /// **'Scheduled / Crons'**
  String get palette_scheduled_crons;

  /// No description provided for @palette_capabilities_skills.
  ///
  /// In en, this message translates to:
  /// **'Capabilities & skills'**
  String get palette_capabilities_skills;

  /// No description provided for @palette_insights_usage.
  ///
  /// In en, this message translates to:
  /// **'Insights & usage'**
  String get palette_insights_usage;

  /// No description provided for @palette_more_projects.
  ///
  /// In en, this message translates to:
  /// **'More & projects'**
  String get palette_more_projects;

  /// No description provided for @deeplink_chat_not_found.
  ///
  /// In en, this message translates to:
  /// **'Chat not found in the list. It may not have loaded yet.'**
  String get deeplink_chat_not_found;

  /// No description provided for @keyboard_shortcuts_title.
  ///
  /// In en, this message translates to:
  /// **'Keyboard shortcuts'**
  String get keyboard_shortcuts_title;

  /// No description provided for @shortcuts_reset_all.
  ///
  /// In en, this message translates to:
  /// **'Reset all'**
  String get shortcuts_reset_all;

  /// No description provided for @shortcuts_reset_to_default.
  ///
  /// In en, this message translates to:
  /// **'Reset to default'**
  String get shortcuts_reset_to_default;

  /// No description provided for @shortcut_action_command_palette.
  ///
  /// In en, this message translates to:
  /// **'Command palette'**
  String get shortcut_action_command_palette;

  /// No description provided for @shortcut_action_new_chat.
  ///
  /// In en, this message translates to:
  /// **'New chat'**
  String get shortcut_action_new_chat;

  /// No description provided for @shortcut_action_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get shortcut_action_search;

  /// No description provided for @shortcut_action_settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get shortcut_action_settings;

  /// No description provided for @shortcut_action_go_to_tab.
  ///
  /// In en, this message translates to:
  /// **'Go to tab {number}'**
  String shortcut_action_go_to_tab(int number);

  /// No description provided for @shortcuts_conflict.
  ///
  /// In en, this message translates to:
  /// **'Conflict: \"{first}\" and \"{second}\" both use {chord}. The custom shortcut keeps its default until you change one of them.'**
  String shortcuts_conflict(String first, String second, String chord);

  /// No description provided for @shortcuts_editor_title.
  ///
  /// In en, this message translates to:
  /// **'Shortcut: {action}'**
  String shortcuts_editor_title(String action);

  /// No description provided for @shortcuts_editor_help.
  ///
  /// In en, this message translates to:
  /// **'Press a key combination, or choose modifiers and a key below:'**
  String get shortcuts_editor_help;

  /// No description provided for @shortcuts_editor_needs_modifier.
  ///
  /// In en, this message translates to:
  /// **'Select at least Cmd/Meta, Ctrl or Alt so typing in the composer is unaffected.'**
  String get shortcuts_editor_needs_modifier;

  /// No description provided for @shortcuts_text_editing_warning.
  ///
  /// In en, this message translates to:
  /// **'{chord} is a text editing shortcut (copy, paste, cut, undo, redo or select all). Binding it here takes it away from text fields.'**
  String shortcuts_text_editing_warning(String chord);

  /// No description provided for @shortcuts_text_editing_in_use.
  ///
  /// In en, this message translates to:
  /// **'\"{action}\" uses {chord}, a text editing shortcut. Text fields lose it while it is bound here.'**
  String shortcuts_text_editing_in_use(String action, String chord);

  /// No description provided for @custom_headers_problem_format.
  ///
  /// In en, this message translates to:
  /// **'Line {line}: expected \"Name: Value\"'**
  String custom_headers_problem_format(int line);

  /// No description provided for @custom_headers_problem_missing_name.
  ///
  /// In en, this message translates to:
  /// **'Line {line}: missing header name'**
  String custom_headers_problem_missing_name(int line);

  /// No description provided for @custom_headers_problem_invalid_name.
  ///
  /// In en, this message translates to:
  /// **'Line {line}: invalid header name \"{name}\"'**
  String custom_headers_problem_invalid_name(int line, String name);

  /// No description provided for @custom_headers_problem_reserved.
  ///
  /// In en, this message translates to:
  /// **'Line {line}: \"{name}\" is reserved and cannot be passed through'**
  String custom_headers_problem_reserved(int line, String name);

  /// No description provided for @custom_headers_problem_empty_value.
  ///
  /// In en, this message translates to:
  /// **'Line {line}: empty header value'**
  String custom_headers_problem_empty_value(int line);

  /// No description provided for @ng_enter_a_deployment_token.
  ///
  /// In en, this message translates to:
  /// **'Enter a deployment session token.'**
  String get ng_enter_a_deployment_token;

  /// No description provided for @ng_custom_headers.
  ///
  /// In en, this message translates to:
  /// **'Custom headers'**
  String get ng_custom_headers;

  /// No description provided for @ng_custom_headers_help.
  ///
  /// In en, this message translates to:
  /// **'Extra HTTP headers for this gateway (Name: Value, one per line), sent on its REST and WebSocket calls. They are kept in the secure credential store. Authentication and hop-by-hop headers are rejected.'**
  String get ng_custom_headers_help;

  /// No description provided for @ng_use_a_deployment_token.
  ///
  /// In en, this message translates to:
  /// **'Use a deployment session token'**
  String get ng_use_a_deployment_token;

  /// No description provided for @ng_sign_in_with_deployment_token.
  ///
  /// In en, this message translates to:
  /// **'Sign in with deployment token'**
  String get ng_sign_in_with_deployment_token;

  /// No description provided for @ng_signed_in_with_deployment_token.
  ///
  /// In en, this message translates to:
  /// **'Signed in with the deployment token.'**
  String get ng_signed_in_with_deployment_token;

  /// No description provided for @auto_speak_replies_title.
  ///
  /// In en, this message translates to:
  /// **'Auto-read replies aloud'**
  String get auto_speak_replies_title;

  /// No description provided for @auto_speak_replies_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Reads each new reply aloud when a turn completes. Off by default; the per-chat spoken-replies toggle still applies.'**
  String get auto_speak_replies_subtitle;

  /// No description provided for @ng_auto_read_replies_title.
  ///
  /// In en, this message translates to:
  /// **'Auto-read replies'**
  String get ng_auto_read_replies_title;

  /// No description provided for @ng_auto_read_replies_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Reads each new reply aloud when a turn completes. Off by default.'**
  String get ng_auto_read_replies_subtitle;

  /// No description provided for @barge_in_title.
  ///
  /// In en, this message translates to:
  /// **'Barge in'**
  String get barge_in_title;

  /// No description provided for @barge_in_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Speak over a reply to cut it short. The microphone stays on while replies are read aloud.'**
  String get barge_in_subtitle;

  /// No description provided for @barge_in_mic_live.
  ///
  /// In en, this message translates to:
  /// **'Microphone on: speak to cut the reply short'**
  String get barge_in_mic_live;

  /// No description provided for @ng_barge_in_title.
  ///
  /// In en, this message translates to:
  /// **'Barge in'**
  String get ng_barge_in_title;

  /// No description provided for @ng_barge_in_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Speak over a reply to cut it short. The microphone stays on while replies are read aloud.'**
  String get ng_barge_in_subtitle;

  /// No description provided for @ng_barge_in_mic_live.
  ///
  /// In en, this message translates to:
  /// **'Microphone on: speak to cut the reply short'**
  String get ng_barge_in_mic_live;

  /// No description provided for @wake_word_title.
  ///
  /// In en, this message translates to:
  /// **'Wake word'**
  String get wake_word_title;

  /// No description provided for @wake_word_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Hands-free wake detection on the gateway. Off by default; streams microphone audio only when client capture is active.'**
  String get wake_word_subtitle;

  /// No description provided for @wake_word_listening.
  ///
  /// In en, this message translates to:
  /// **'Listening for wake word \"{phrase}\"'**
  String wake_word_listening(String phrase);

  /// No description provided for @wake_word_paused.
  ///
  /// In en, this message translates to:
  /// **'Wake word \"{phrase}\" — paused'**
  String wake_word_paused(String phrase);

  /// No description provided for @wake_word_off.
  ///
  /// In en, this message translates to:
  /// **'Wake word \"{phrase}\" — off'**
  String wake_word_off(String phrase);

  /// No description provided for @wake_word_arming.
  ///
  /// In en, this message translates to:
  /// **'Arming wake word…'**
  String get wake_word_arming;

  /// No description provided for @wake_word_stop.
  ///
  /// In en, this message translates to:
  /// **'Stop wake word'**
  String get wake_word_stop;

  /// No description provided for @wake_word_rearm.
  ///
  /// In en, this message translates to:
  /// **'Re-arm'**
  String get wake_word_rearm;

  /// No description provided for @wake_word_capture_mode.
  ///
  /// In en, this message translates to:
  /// **'Capture mode'**
  String get wake_word_capture_mode;

  /// No description provided for @wake_word_capture_auto.
  ///
  /// In en, this message translates to:
  /// **'Automatic'**
  String get wake_word_capture_auto;

  /// No description provided for @wake_word_capture_client.
  ///
  /// In en, this message translates to:
  /// **'This device\'s microphone'**
  String get wake_word_capture_client;

  /// No description provided for @wake_word_capture_local.
  ///
  /// In en, this message translates to:
  /// **'Gateway host microphone'**
  String get wake_word_capture_local;

  /// No description provided for @wake_word_capture_unavailable.
  ///
  /// In en, this message translates to:
  /// **'This gateway doesn\'t let apps change the capture mode. Set wake_word.capture in the Hermes config on the gateway host.'**
  String get wake_word_capture_unavailable;

  /// No description provided for @wake_word_input_device.
  ///
  /// In en, this message translates to:
  /// **'Input microphone'**
  String get wake_word_input_device;

  /// No description provided for @wake_word_default_device.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get wake_word_default_device;

  /// No description provided for @ng_wake_word_title.
  ///
  /// In en, this message translates to:
  /// **'Wake word'**
  String get ng_wake_word_title;

  /// No description provided for @ng_wake_word_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Hands-free wake detection on the gateway. Off by default.'**
  String get ng_wake_word_subtitle;

  /// No description provided for @voice_engine_title.
  ///
  /// In en, this message translates to:
  /// **'Voice conversation engine'**
  String get voice_engine_title;

  /// No description provided for @voice_engine_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how hands-free voice conversations run on this gateway profile.'**
  String get voice_engine_subtitle;

  /// No description provided for @voice_engine_chained.
  ///
  /// In en, this message translates to:
  /// **'Chained (speech-to-text → Hermes → speech)'**
  String get voice_engine_chained;

  /// No description provided for @voice_engine_chained_short.
  ///
  /// In en, this message translates to:
  /// **'Chained'**
  String get voice_engine_chained_short;

  /// No description provided for @voice_engine_live.
  ///
  /// In en, this message translates to:
  /// **'GPT-Live (real-time voice)'**
  String get voice_engine_live;

  /// No description provided for @voice_engine_live_short.
  ///
  /// In en, this message translates to:
  /// **'GPT-Live'**
  String get voice_engine_live_short;

  /// No description provided for @voice_engine_live_needs_key.
  ///
  /// In en, this message translates to:
  /// **'Configure an OpenAI API key on the gateway host to enable GPT-Live.'**
  String get voice_engine_live_needs_key;

  /// No description provided for @voice_engine_fallback_chained.
  ///
  /// In en, this message translates to:
  /// **'GPT-Live unavailable ({reason}) — using Chained voice.'**
  String voice_engine_fallback_chained(String reason);

  /// No description provided for @voice_live_start.
  ///
  /// In en, this message translates to:
  /// **'Start voice conversation'**
  String get voice_live_start;

  /// No description provided for @voice_live_stop.
  ///
  /// In en, this message translates to:
  /// **'End voice conversation'**
  String get voice_live_stop;

  /// No description provided for @voice_live_mute.
  ///
  /// In en, this message translates to:
  /// **'Mute microphone'**
  String get voice_live_mute;

  /// No description provided for @voice_live_unmute.
  ///
  /// In en, this message translates to:
  /// **'Unmute microphone'**
  String get voice_live_unmute;

  /// No description provided for @voice_live_interrupt.
  ///
  /// In en, this message translates to:
  /// **'Interrupt or respond now'**
  String get voice_live_interrupt;

  /// No description provided for @voice_live_listening.
  ///
  /// In en, this message translates to:
  /// **'Listening'**
  String get voice_live_listening;

  /// No description provided for @voice_live_speaking.
  ///
  /// In en, this message translates to:
  /// **'Speaking'**
  String get voice_live_speaking;

  /// No description provided for @voice_live_thinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking'**
  String get voice_live_thinking;

  /// No description provided for @voice_live_muted.
  ///
  /// In en, this message translates to:
  /// **'Muted'**
  String get voice_live_muted;

  /// No description provided for @voice_live_ended_connection_lost.
  ///
  /// In en, this message translates to:
  /// **'The live voice session lost its connection.'**
  String get voice_live_ended_connection_lost;

  /// No description provided for @voice_live_ended_closed.
  ///
  /// In en, this message translates to:
  /// **'The live voice session was closed by the service.'**
  String get voice_live_ended_closed;

  /// No description provided for @wake_word_other_profile.
  ///
  /// In en, this message translates to:
  /// **'That wake word belongs to profile \"{profile}\". Open a connection to that profile to answer it.'**
  String wake_word_other_profile(String profile);

  /// No description provided for @wake_word_reason_disabled.
  ///
  /// In en, this message translates to:
  /// **'Off — tap to enable'**
  String get wake_word_reason_disabled;

  /// No description provided for @wake_word_reason_surface.
  ///
  /// In en, this message translates to:
  /// **'Scoped to another surface (config wake_word.surface)'**
  String get wake_word_reason_surface;

  /// No description provided for @wake_word_reason_owned.
  ///
  /// In en, this message translates to:
  /// **'Another surface owns the wake-word listener'**
  String get wake_word_reason_owned;

  /// No description provided for @wake_word_reason_owned_by.
  ///
  /// In en, this message translates to:
  /// **'Another surface ({surface}) owns the wake-word listener'**
  String wake_word_reason_owned_by(String surface);

  /// No description provided for @wake_word_reason_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Wake word unavailable on this gateway'**
  String get wake_word_reason_unavailable;

  /// No description provided for @wake_word_reason_permission_denied.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission denied'**
  String get wake_word_reason_permission_denied;

  /// No description provided for @wake_word_reason_permission_required.
  ///
  /// In en, this message translates to:
  /// **'Microphone permission required — tap to enable'**
  String get wake_word_reason_permission_required;

  /// No description provided for @voice_live_not_enabled.
  ///
  /// In en, this message translates to:
  /// **'GPT-Live is not enabled for this profile.'**
  String get voice_live_not_enabled;

  /// No description provided for @voice_live_not_available.
  ///
  /// In en, this message translates to:
  /// **'GPT-Live is not available'**
  String get voice_live_not_available;

  /// No description provided for @voice_live_start_failed.
  ///
  /// In en, this message translates to:
  /// **'GPT-Live could not start: {error}'**
  String voice_live_start_failed(String error);

  /// No description provided for @voice_direct_stt_timeout.
  ///
  /// In en, this message translates to:
  /// **'Transcription timed out after {seconds}s ({provider} did not answer)'**
  String voice_direct_stt_timeout(String seconds, String provider);

  /// No description provided for @voice_direct_stt_error.
  ///
  /// In en, this message translates to:
  /// **'{provider} STT error (HTTP {status})'**
  String voice_direct_stt_error(String provider, String status);

  /// No description provided for @voice_direct_tts_failed.
  ///
  /// In en, this message translates to:
  /// **'{provider} TTS request failed'**
  String voice_direct_tts_failed(String provider);

  /// No description provided for @voice_direct_tts_error.
  ///
  /// In en, this message translates to:
  /// **'{provider} TTS error (HTTP {status})'**
  String voice_direct_tts_error(String provider, String status);

  /// No description provided for @ng_wake_status_listening.
  ///
  /// In en, this message translates to:
  /// **'Listening (\"{phrase}\")'**
  String ng_wake_status_listening(String phrase);

  /// No description provided for @ng_wake_status_off.
  ///
  /// In en, this message translates to:
  /// **'Off (\"{phrase}\")'**
  String ng_wake_status_off(String phrase);

  /// A setting change was not sent: a Hermes 0.23+ shared gateway has no form for that config key (or that scope). {setting} is the key, with its scope in brackets when one was asked for.
  ///
  /// In en, this message translates to:
  /// **'Changing {setting} is not available on the shared gateway yet'**
  String ng_wire_setting_unavailable(Object setting);

  /// A request was not sent: a Hermes 0.23+ shared gateway does not serve that method. {method} is the wire method name.
  ///
  /// In en, this message translates to:
  /// **'{method} is not available on the shared gateway yet'**
  String ng_wire_method_unavailable(Object method);

  /// A new chat was not created: the shared gateway has no field for these options. {options} is a comma-separated list of option names.
  ///
  /// In en, this message translates to:
  /// **'Canonical gateway does not support explicit session options: {options}'**
  String ng_wire_session_options_unsupported(Object options);

  /// An approval or question could not be answered: it is no longer the one the gateway waits on.
  ///
  /// In en, this message translates to:
  /// **'Prompt is stale or unavailable; reconnect before responding'**
  String get ng_wire_prompt_stale;

  /// A rename, archive or similar edit was not sent: the app has not learned the chat revision the gateway requires.
  ///
  /// In en, this message translates to:
  /// **'Session revision unavailable; reopen the session before editing metadata'**
  String get ng_wire_revision_unavailable;

  /// A command was not sent: the app has not learned which turn of the chat is current.
  ///
  /// In en, this message translates to:
  /// **'Session execution identity unavailable; reconnect before this command'**
  String get ng_wire_generation_unavailable;

  /// A branch from a message was not sent: the message has no saved id yet.
  ///
  /// In en, this message translates to:
  /// **'This message is not saved yet; wait for it to settle, then branch from it again'**
  String get ng_wire_message_not_saved;

  /// Tooltip or note on a control that is disabled because the connected Hermes 0.23+ shared gateway does not offer it.
  ///
  /// In en, this message translates to:
  /// **'Not available on the shared gateway yet'**
  String get ng_wire_not_available;

  /// No description provided for @edit_turn_title.
  ///
  /// In en, this message translates to:
  /// **'Edit this prompt?'**
  String get edit_turn_title;

  /// No description provided for @edit_turn_body.
  ///
  /// In en, this message translates to:
  /// **'The prompt will be re-run from here. Later turns are archived.'**
  String get edit_turn_body;

  /// No description provided for @edit_turn_send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get edit_turn_send;

  /// No description provided for @restore_turn_title.
  ///
  /// In en, this message translates to:
  /// **'Restore to this checkpoint?'**
  String get restore_turn_title;

  /// No description provided for @restore_turn_body.
  ///
  /// In en, this message translates to:
  /// **'Everything after this prompt is removed from the conversation, and the prompt runs again from here.'**
  String get restore_turn_body;

  /// No description provided for @restore_turn_confirm.
  ///
  /// In en, this message translates to:
  /// **'Restore & rerun'**
  String get restore_turn_confirm;

  /// No description provided for @edit_turn_later_turns_body.
  ///
  /// In en, this message translates to:
  /// **'This will archive later turns from the conversation. Continue?'**
  String get edit_turn_later_turns_body;

  /// No description provided for @session_history.
  ///
  /// In en, this message translates to:
  /// **'Session history'**
  String get session_history;

  /// No description provided for @import_claude_or_codex.
  ///
  /// In en, this message translates to:
  /// **'Import Claude or Codex'**
  String get import_claude_or_codex;

  /// No description provided for @ng_session_history.
  ///
  /// In en, this message translates to:
  /// **'Session history'**
  String get ng_session_history;

  /// No description provided for @ng_import_claude_or_codex.
  ///
  /// In en, this message translates to:
  /// **'Import Claude or Codex'**
  String get ng_import_claude_or_codex;

  /// No description provided for @ng_edit_and_resend.
  ///
  /// In en, this message translates to:
  /// **'Edit and resend'**
  String get ng_edit_and_resend;

  /// No description provided for @ng_restore_turn_confirm.
  ///
  /// In en, this message translates to:
  /// **'Restore & rerun'**
  String get ng_restore_turn_confirm;

  /// No description provided for @rewind_target_unsaved.
  ///
  /// In en, this message translates to:
  /// **'This message is not saved yet. Wait for it to settle, then edit it again.'**
  String get rewind_target_unsaved;

  /// No description provided for @rewind_turn_busy.
  ///
  /// In en, this message translates to:
  /// **'The current reply has not stopped yet, so nothing was sent. Try again in a moment.'**
  String get rewind_turn_busy;

  /// No description provided for @rewind_session_changed.
  ///
  /// In en, this message translates to:
  /// **'This chat changed since it was opened here, so nothing was removed or sent. Reopen it, then try again.'**
  String get rewind_session_changed;

  /// No description provided for @history_lineage.
  ///
  /// In en, this message translates to:
  /// **'Related chats'**
  String get history_lineage;

  /// No description provided for @history_lineage_none.
  ///
  /// In en, this message translates to:
  /// **'This chat has no forks or sibling branches.'**
  String get history_lineage_none;

  /// No description provided for @history_lineage_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Related chats could not be read from this gateway.'**
  String get history_lineage_unavailable;

  /// No description provided for @history_lineage_parent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get history_lineage_parent;

  /// No description provided for @history_lineage_sibling.
  ///
  /// In en, this message translates to:
  /// **'Sibling'**
  String get history_lineage_sibling;

  /// No description provided for @history_lineage_fork.
  ///
  /// In en, this message translates to:
  /// **'Fork'**
  String get history_lineage_fork;

  /// No description provided for @history_messages.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get history_messages;

  /// No description provided for @history_messages_hint.
  ///
  /// In en, this message translates to:
  /// **'Select a saved message to branch or rewind there.'**
  String get history_messages_hint;

  /// No description provided for @history_messages_none.
  ///
  /// In en, this message translates to:
  /// **'No saved messages yet.'**
  String get history_messages_none;

  /// No description provided for @history_messages_unavailable.
  ///
  /// In en, this message translates to:
  /// **'The saved messages could not be read. Open this chat, then refresh.'**
  String get history_messages_unavailable;

  /// No description provided for @history_role_user.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get history_role_user;

  /// No description provided for @history_role_assistant.
  ///
  /// In en, this message translates to:
  /// **'Hermes'**
  String get history_role_assistant;

  /// No description provided for @history_branch_here.
  ///
  /// In en, this message translates to:
  /// **'Branch from here'**
  String get history_branch_here;

  /// No description provided for @history_rewind_here.
  ///
  /// In en, this message translates to:
  /// **'Rewind to here'**
  String get history_rewind_here;

  /// No description provided for @history_branch_title.
  ///
  /// In en, this message translates to:
  /// **'Branch from this message'**
  String get history_branch_title;

  /// No description provided for @history_branch_body.
  ///
  /// In en, this message translates to:
  /// **'This creates a new chat containing history through the selected message. The current chat stays as it is.'**
  String get history_branch_body;

  /// No description provided for @history_rewind_title.
  ///
  /// In en, this message translates to:
  /// **'Rewind to this message'**
  String get history_rewind_title;

  /// No description provided for @history_rewind_body.
  ///
  /// In en, this message translates to:
  /// **'Messages from the selected one onward are removed from this chat. Files on the computer are not changed. Restoring those is a separate checkpoint action.'**
  String get history_rewind_body;

  /// No description provided for @history_branched.
  ///
  /// In en, this message translates to:
  /// **'Branched as {id}'**
  String history_branched(String id);

  /// No description provided for @history_open_chat.
  ///
  /// In en, this message translates to:
  /// **'Open chat'**
  String get history_open_chat;

  /// No description provided for @history_mutate_unsupported.
  ///
  /// In en, this message translates to:
  /// **'Branch and rewind need Hermes 0.23 or newer on this gateway.'**
  String get history_mutate_unsupported;

  /// No description provided for @history_checkpoints.
  ///
  /// In en, this message translates to:
  /// **'Checkpoints'**
  String get history_checkpoints;

  /// No description provided for @history_checkpoints_none.
  ///
  /// In en, this message translates to:
  /// **'This session has no filesystem checkpoints.'**
  String get history_checkpoints_none;

  /// No description provided for @history_checkpoints_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Checkpoints are not available on this gateway.'**
  String get history_checkpoints_unavailable;

  /// No description provided for @history_diff_none.
  ///
  /// In en, this message translates to:
  /// **'No differences.'**
  String get history_diff_none;

  /// No description provided for @history_diff_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading the changes…'**
  String get history_diff_loading;

  /// No description provided for @history_diff_failed.
  ///
  /// In en, this message translates to:
  /// **'The changes could not be loaded, so this checkpoint cannot be restored yet.'**
  String get history_diff_failed;

  /// No description provided for @history_restore_checkpoint.
  ///
  /// In en, this message translates to:
  /// **'Restore checkpoint'**
  String get history_restore_checkpoint;

  /// No description provided for @history_restore_title.
  ///
  /// In en, this message translates to:
  /// **'Restore this checkpoint'**
  String get history_restore_title;

  /// No description provided for @history_restore_body.
  ///
  /// In en, this message translates to:
  /// **'The files the agent changed since this checkpoint go back to how they were then. Changes you made yourself are kept. Later chat messages can be removed as well. The conversation is not branched.'**
  String get history_restore_body;

  /// No description provided for @history_restore_body_all.
  ///
  /// In en, this message translates to:
  /// **'Every file in the session folder goes back to this checkpoint, including changes you made yourself. Later chat messages can be removed as well. The conversation is not branched.'**
  String get history_restore_body_all;

  /// No description provided for @history_restore_own_edits.
  ///
  /// In en, this message translates to:
  /// **'Also revert my own edits'**
  String get history_restore_own_edits;

  /// No description provided for @history_restored.
  ///
  /// In en, this message translates to:
  /// **'Checkpoint restored.'**
  String get history_restored;

  /// No description provided for @history_restored_removed.
  ///
  /// In en, this message translates to:
  /// **'Checkpoint restored. {count} chat messages were removed.'**
  String history_restored_removed(int count);

  /// No description provided for @history_export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get history_export;

  /// No description provided for @history_export_redact.
  ///
  /// In en, this message translates to:
  /// **'Redact tokens'**
  String get history_export_redact;

  /// No description provided for @history_export_action.
  ///
  /// In en, this message translates to:
  /// **'Export transcript'**
  String get history_export_action;

  /// No description provided for @history_export_saved.
  ///
  /// In en, this message translates to:
  /// **'Transcript saved.'**
  String get history_export_saved;

  /// No description provided for @history_export_unsupported.
  ///
  /// In en, this message translates to:
  /// **'Export needs Hermes 0.23 or newer on this gateway.'**
  String get history_export_unsupported;

  /// No description provided for @history_import_unsupported.
  ///
  /// In en, this message translates to:
  /// **'Claude and Codex import is not supported by this gateway.'**
  String get history_import_unsupported;

  /// No description provided for @history_import_destination.
  ///
  /// In en, this message translates to:
  /// **'Destination profile: {profile}.'**
  String history_import_destination(String profile);

  /// No description provided for @history_import_reading.
  ///
  /// In en, this message translates to:
  /// **'Reading from {host} · Destination profile: {profile}. {count} logs could not be read.'**
  String history_import_reading(String host, String profile, int count);

  /// No description provided for @history_import_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get history_import_all;

  /// No description provided for @history_import_scan_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not scan host sessions: {reason}'**
  String history_import_scan_failed(String reason);

  /// No description provided for @history_import_none.
  ///
  /// In en, this message translates to:
  /// **'No Claude Code or Codex sessions found on this host.'**
  String get history_import_none;

  /// No description provided for @history_import_no_match.
  ///
  /// In en, this message translates to:
  /// **'No matching host sessions.'**
  String get history_import_no_match;

  /// No description provided for @history_import_preview_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not preview session: {reason}'**
  String history_import_preview_failed(String reason);

  /// No description provided for @history_import_open.
  ///
  /// In en, this message translates to:
  /// **'Open imported session'**
  String get history_import_open;

  /// No description provided for @history_import_action.
  ///
  /// In en, this message translates to:
  /// **'Import selected session'**
  String get history_import_action;

  /// No description provided for @history_import_title.
  ///
  /// In en, this message translates to:
  /// **'Import this session'**
  String get history_import_title;

  /// No description provided for @history_import_body.
  ///
  /// In en, this message translates to:
  /// **'Copy this Claude or Codex session into profile \"{profile}\" on this gateway.'**
  String history_import_body(String profile);

  /// No description provided for @history_import_body_existing.
  ///
  /// In en, this message translates to:
  /// **'This session was already imported into \"{profile}\". Continue with the existing copy.'**
  String history_import_body_existing(String profile);

  /// No description provided for @history_imported.
  ///
  /// In en, this message translates to:
  /// **'Imported as {id}'**
  String history_imported(String id);

  /// No description provided for @history_imported_already.
  ///
  /// In en, this message translates to:
  /// **'Already imported as {id}'**
  String history_imported_already(String id);

  /// No description provided for @history_import_directory.
  ///
  /// In en, this message translates to:
  /// **'Directory: {path}'**
  String history_import_directory(String path);

  /// No description provided for @history_import_preview_partial.
  ///
  /// In en, this message translates to:
  /// **'Preview shows {shown} of {total}.'**
  String history_import_preview_partial(int shown, int total);

  /// No description provided for @history_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not finish: {reason}'**
  String history_failed(String reason);

  /// No description provided for @history_error_unavailable.
  ///
  /// In en, this message translates to:
  /// **'The gateway could not do this right now. Try again.'**
  String get history_error_unavailable;

  /// No description provided for @history_error_unsupported.
  ///
  /// In en, this message translates to:
  /// **'This gateway does not support this.'**
  String get history_error_unsupported;

  /// No description provided for @history_error_denied.
  ///
  /// In en, this message translates to:
  /// **'This gateway refused the request.'**
  String get history_error_denied;

  /// No description provided for @history_error_changed.
  ///
  /// In en, this message translates to:
  /// **'This chat changed while this page was open. Refresh, then try again.'**
  String get history_error_changed;

  /// No description provided for @history_error_unbound.
  ///
  /// In en, this message translates to:
  /// **'This chat is not open on the gateway. Open it, then try again.'**
  String get history_error_unbound;

  /// No description provided for @history_error_invalid.
  ///
  /// In en, this message translates to:
  /// **'The gateway sent an answer this app could not read.'**
  String get history_error_invalid;

  /// No description provided for @ng_dock_kanban.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Kanban card} other{{count} Kanban cards}}'**
  String ng_dock_kanban(int count);

  /// No description provided for @ng_dock_kanban_done.
  ///
  /// In en, this message translates to:
  /// **'{count} done'**
  String ng_dock_kanban_done(int count);

  /// No description provided for @ng_show_kanban.
  ///
  /// In en, this message translates to:
  /// **'Show Kanban cards'**
  String get ng_show_kanban;

  /// No description provided for @ng_hide_kanban.
  ///
  /// In en, this message translates to:
  /// **'Hide Kanban cards'**
  String get ng_hide_kanban;

  /// No description provided for @ng_kanban_status_triage.
  ///
  /// In en, this message translates to:
  /// **'Triage'**
  String get ng_kanban_status_triage;

  /// No description provided for @ng_kanban_status_todo.
  ///
  /// In en, this message translates to:
  /// **'To do'**
  String get ng_kanban_status_todo;

  /// No description provided for @ng_kanban_status_scheduled.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get ng_kanban_status_scheduled;

  /// No description provided for @ng_kanban_status_ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ng_kanban_status_ready;

  /// No description provided for @ng_kanban_status_running.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get ng_kanban_status_running;

  /// No description provided for @ng_kanban_status_blocked.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get ng_kanban_status_blocked;

  /// No description provided for @ng_kanban_status_review.
  ///
  /// In en, this message translates to:
  /// **'In review'**
  String get ng_kanban_status_review;

  /// No description provided for @ng_kanban_status_done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get ng_kanban_status_done;

  /// No description provided for @ng_kanban_status_archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get ng_kanban_status_archived;

  /// No description provided for @ng_kanban_open_card.
  ///
  /// In en, this message translates to:
  /// **'Open {title} in Kanban'**
  String ng_kanban_open_card(String title);

  /// No description provided for @ng_kanban_show_all.
  ///
  /// In en, this message translates to:
  /// **'Show all {count}'**
  String ng_kanban_show_all(int count);

  /// No description provided for @ng_kanban_this_chat.
  ///
  /// In en, this message translates to:
  /// **'This chat ({count})'**
  String ng_kanban_this_chat(int count);

  /// No description provided for @ng_kanban_close.
  ///
  /// In en, this message translates to:
  /// **'Close Kanban'**
  String get ng_kanban_close;

  /// No description provided for @ng_kanban_block_no_dashboard.
  ///
  /// In en, this message translates to:
  /// **'This connection has no dashboard access, so card status is not live and the board cannot open.'**
  String get ng_kanban_block_no_dashboard;

  /// No description provided for @ng_kanban_block_unsupported.
  ///
  /// In en, this message translates to:
  /// **'Kanban is not turned on for this gateway. Enable its kanban plugin to see live status and open the board.'**
  String get ng_kanban_block_unsupported;

  /// No description provided for @ng_kanban_block_denied.
  ///
  /// In en, this message translates to:
  /// **'Sign in to the dashboard to see live card status and open the board.'**
  String get ng_kanban_block_denied;

  /// No description provided for @ng_kanban_block_insecure.
  ///
  /// In en, this message translates to:
  /// **'Kanban needs HTTPS or a local connection, so card status is not live and the board cannot open.'**
  String get ng_kanban_block_insecure;

  /// No description provided for @ng_kanban_block_unreachable.
  ///
  /// In en, this message translates to:
  /// **'Could not reach Kanban on this gateway. Card status may be out of date.'**
  String get ng_kanban_block_unreachable;

  /// No description provided for @ng_kanban_block_stale.
  ///
  /// In en, this message translates to:
  /// **'The connection changed. Reopen this chat to see live card status.'**
  String get ng_kanban_block_stale;

  /// No description provided for @ng_bots_tab_roster.
  ///
  /// In en, this message translates to:
  /// **'Roster'**
  String get ng_bots_tab_roster;

  /// No description provided for @ng_bots_tab_rooms.
  ///
  /// In en, this message translates to:
  /// **'Rooms'**
  String get ng_bots_tab_rooms;

  /// No description provided for @ng_bots_tab_screen.
  ///
  /// In en, this message translates to:
  /// **'Screen'**
  String get ng_bots_tab_screen;

  /// No description provided for @ng_bots_tab_routines.
  ///
  /// In en, this message translates to:
  /// **'Routines'**
  String get ng_bots_tab_routines;

  /// No description provided for @ng_bots_rooms_load_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not load rooms: {error}'**
  String ng_bots_rooms_load_failed(String error);

  /// No description provided for @ng_bots_routines_load_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not load routines: {error}'**
  String ng_bots_routines_load_failed(String error);

  /// No description provided for @ng_bots_desktop_failed.
  ///
  /// In en, this message translates to:
  /// **'Bot Desktop: {error}'**
  String ng_bots_desktop_failed(String error);

  /// No description provided for @ng_bots_install_not_started.
  ///
  /// In en, this message translates to:
  /// **'The gateway did not start the install.'**
  String get ng_bots_install_not_started;

  /// No description provided for @ng_bots_install_failed_error.
  ///
  /// In en, this message translates to:
  /// **'Install failed: {error}'**
  String ng_bots_install_failed_error(String error);

  /// No description provided for @ng_bots_install_cancelled.
  ///
  /// In en, this message translates to:
  /// **'The install was cancelled.'**
  String get ng_bots_install_cancelled;

  /// No description provided for @ng_bots_install_no_sudo.
  ///
  /// In en, this message translates to:
  /// **'sudo is not available on the gateway host. Run the command above there, then refresh.'**
  String get ng_bots_install_no_sudo;

  /// No description provided for @ng_bots_install_exit_code.
  ///
  /// In en, this message translates to:
  /// **'The install failed (exit code {code}).'**
  String ng_bots_install_exit_code(String code);

  /// No description provided for @ng_bots_install_done.
  ///
  /// In en, this message translates to:
  /// **'Bot Desktop installed for {bot}'**
  String ng_bots_install_done(String bot);

  /// No description provided for @ng_bots_start_failed.
  ///
  /// In en, this message translates to:
  /// **'Start failed'**
  String get ng_bots_start_failed;

  /// No description provided for @ng_bots_stop_title.
  ///
  /// In en, this message translates to:
  /// **'Stop Bot Desktop for {bot}?'**
  String ng_bots_stop_title(String bot);

  /// No description provided for @ng_bots_stop_human_held.
  ///
  /// In en, this message translates to:
  /// **'Someone is controlling this screen. Stopping it ends their session and closes everything open on it.'**
  String get ng_bots_stop_human_held;

  /// No description provided for @ng_bots_stop_body.
  ///
  /// In en, this message translates to:
  /// **'Everything open on the bot’s screen is closed.'**
  String get ng_bots_stop_body;

  /// No description provided for @ng_bots_stop_refused.
  ///
  /// In en, this message translates to:
  /// **'Stop refused'**
  String get ng_bots_stop_refused;

  /// No description provided for @ng_bots_take_over_reason.
  ///
  /// In en, this message translates to:
  /// **'Take over from Ares'**
  String get ng_bots_take_over_reason;

  /// No description provided for @ng_bots_take_over_failed.
  ///
  /// In en, this message translates to:
  /// **'Take over failed: {error}'**
  String ng_bots_take_over_failed(String error);

  /// No description provided for @ng_bots_force_hand_back_title.
  ///
  /// In en, this message translates to:
  /// **'Give {bot}’s screen back to the bot?'**
  String ng_bots_force_hand_back_title(String bot);

  /// No description provided for @ng_bots_force_hand_back_body.
  ///
  /// In en, this message translates to:
  /// **'A person is holding this screen. If they are still using it, they lose control.'**
  String get ng_bots_force_hand_back_body;

  /// No description provided for @ng_bots_hand_back.
  ///
  /// In en, this message translates to:
  /// **'Hand back'**
  String get ng_bots_hand_back;

  /// No description provided for @ng_bots_hand_back_failed.
  ///
  /// In en, this message translates to:
  /// **'Hand back failed'**
  String get ng_bots_hand_back_failed;

  /// No description provided for @ng_bots_adopt_title.
  ///
  /// In en, this message translates to:
  /// **'Adopt the new sandbox image?'**
  String get ng_bots_adopt_title;

  /// No description provided for @ng_bots_adopt_body.
  ///
  /// In en, this message translates to:
  /// **'{bot} moves from {current} to {target}. Its container is recreated on the next terminal call; anything kept only in the current container is lost.'**
  String ng_bots_adopt_body(String bot, String current, String target);

  /// No description provided for @ng_bots_adopt_image.
  ///
  /// In en, this message translates to:
  /// **'Adopt image'**
  String get ng_bots_adopt_image;

  /// No description provided for @ng_bots_image_switch_failed.
  ///
  /// In en, this message translates to:
  /// **'Image switch failed'**
  String get ng_bots_image_switch_failed;

  /// No description provided for @ng_bots_keep_refused.
  ///
  /// In en, this message translates to:
  /// **'Keep refused'**
  String get ng_bots_keep_refused;

  /// No description provided for @ng_bots_chat_open_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not open Bot Chat: {error}'**
  String ng_bots_chat_open_failed(String error);

  /// No description provided for @ng_bots_title.
  ///
  /// In en, this message translates to:
  /// **'Bots · {connection}'**
  String ng_bots_title(String connection);

  /// No description provided for @ng_bots_protocol_tooltip.
  ///
  /// In en, this message translates to:
  /// **'Gateway injects the teammate-messaging protocol itself — no extra SOUL.md protocol is sent.'**
  String get ng_bots_protocol_tooltip;

  /// No description provided for @ng_bots_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Bots unavailable ({reason})'**
  String ng_bots_unavailable(String reason);

  /// No description provided for @ng_bots_account_changed.
  ///
  /// In en, this message translates to:
  /// **'The account changed. Reconnect or refresh.'**
  String get ng_bots_account_changed;

  /// No description provided for @ng_bots_try_refresh.
  ///
  /// In en, this message translates to:
  /// **'Try refreshing. If it persists, the gateway may not support bots.'**
  String get ng_bots_try_refresh;

  /// No description provided for @ng_bots_search.
  ///
  /// In en, this message translates to:
  /// **'Search bots'**
  String get ng_bots_search;

  /// No description provided for @ng_bots_none_found.
  ///
  /// In en, this message translates to:
  /// **'No bots found.'**
  String get ng_bots_none_found;

  /// No description provided for @ng_bots_no_model.
  ///
  /// In en, this message translates to:
  /// **'no model'**
  String get ng_bots_no_model;

  /// No description provided for @ng_bots_skill_count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 skill} other{{count} skills}}'**
  String ng_bots_skill_count(int count);

  /// No description provided for @ng_bots_bot_chat.
  ///
  /// In en, this message translates to:
  /// **'Bot Chat'**
  String get ng_bots_bot_chat;

  /// No description provided for @ng_bots_install_id.
  ///
  /// In en, this message translates to:
  /// **'Gateway reports install id {id} · bot_mode_protocol: {protocol}'**
  String ng_bots_install_id(String id, String protocol);

  /// No description provided for @ng_bots_protocol_note.
  ///
  /// In en, this message translates to:
  /// **'The gateway injects the teammate-messaging protocol when bot_mode_protocol is set. Handle: default→hermes, otherwise the profile name.'**
  String get ng_bots_protocol_note;

  /// No description provided for @ng_bots_no_rooms.
  ///
  /// In en, this message translates to:
  /// **'No rooms yet. Create one from your roster.'**
  String get ng_bots_no_rooms;

  /// No description provided for @ng_bots_member_count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 member} other{{count} members}}'**
  String ng_bots_member_count(int count);

  /// No description provided for @ng_bots_room_disbanded.
  ///
  /// In en, this message translates to:
  /// **'disbanded'**
  String get ng_bots_room_disbanded;

  /// No description provided for @ng_bots_room_adopted.
  ///
  /// In en, this message translates to:
  /// **'adopted'**
  String get ng_bots_room_adopted;

  /// No description provided for @ng_bots_rooms_gateway.
  ///
  /// In en, this message translates to:
  /// **'Gateway rooms'**
  String get ng_bots_rooms_gateway;

  /// No description provided for @ng_bots_rooms_desktop.
  ///
  /// In en, this message translates to:
  /// **'Desktop-driven rooms'**
  String get ng_bots_rooms_desktop;

  /// No description provided for @ng_bots_rooms_gateway_body.
  ///
  /// In en, this message translates to:
  /// **'Rooms are owned by the gateway. Methods: {methods}.'**
  String ng_bots_rooms_gateway_body(String methods);

  /// No description provided for @ng_bots_rooms_no_seat.
  ///
  /// In en, this message translates to:
  /// **'Rooms may not be seated by this gateway (persistent process required).'**
  String get ng_bots_rooms_no_seat;

  /// No description provided for @ng_bots_rooms_fallback.
  ///
  /// In en, this message translates to:
  /// **'Classic fallback: the Desktop drives the group rounds (not newly created here).'**
  String get ng_bots_rooms_fallback;

  /// No description provided for @ng_bots_create_room.
  ///
  /// In en, this message translates to:
  /// **'Create room'**
  String get ng_bots_create_room;

  /// No description provided for @ng_bots_refresh_rooms.
  ///
  /// In en, this message translates to:
  /// **'Refresh rooms'**
  String get ng_bots_refresh_rooms;

  /// No description provided for @ng_bots_room_created.
  ///
  /// In en, this message translates to:
  /// **'Room created'**
  String get ng_bots_room_created;

  /// No description provided for @ng_bots_room_refused.
  ///
  /// In en, this message translates to:
  /// **'Room creation refused ({reason})'**
  String ng_bots_room_refused(String reason);

  /// No description provided for @ng_bots_room_failed.
  ///
  /// In en, this message translates to:
  /// **'Room creation failed: {error}'**
  String ng_bots_room_failed(String error);

  /// No description provided for @ng_bots_bot.
  ///
  /// In en, this message translates to:
  /// **'Bot'**
  String get ng_bots_bot;

  /// No description provided for @ng_bots_screen_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Screen status unavailable'**
  String get ng_bots_screen_unavailable;

  /// No description provided for @ng_bots_screen_unavailable_body.
  ///
  /// In en, this message translates to:
  /// **'Start the bot’s screen to watch its thumbnail, or take over to use it yourself.'**
  String get ng_bots_screen_unavailable_body;

  /// No description provided for @ng_bots_take_over_note.
  ///
  /// In en, this message translates to:
  /// **'Take over opens the live screen and gives you control of it. Control goes back to the bot when you close the live screen, leave this page or put the app in the background.'**
  String get ng_bots_take_over_note;

  /// No description provided for @ng_bots_not_installed.
  ///
  /// In en, this message translates to:
  /// **'Not installed'**
  String get ng_bots_not_installed;

  /// No description provided for @ng_bots_unsupported_host.
  ///
  /// In en, this message translates to:
  /// **'Unsupported host'**
  String get ng_bots_unsupported_host;

  /// No description provided for @ng_bots_pid.
  ///
  /// In en, this message translates to:
  /// **'pid {pid}'**
  String ng_bots_pid(String pid);

  /// No description provided for @ng_bots_missing.
  ///
  /// In en, this message translates to:
  /// **'missing: {items}'**
  String ng_bots_missing(String items);

  /// No description provided for @ng_bots_blocked.
  ///
  /// In en, this message translates to:
  /// **'blocked: {reason}'**
  String ng_bots_blocked(String reason);

  /// No description provided for @ng_bots_no_switch.
  ///
  /// In en, this message translates to:
  /// **'No sandbox image switch is pending.'**
  String get ng_bots_no_switch;

  /// No description provided for @ng_bots_switch_image.
  ///
  /// In en, this message translates to:
  /// **'switch image: {current} → {target}'**
  String ng_bots_switch_image(String current, String target);

  /// No description provided for @ng_bots_bot_in_control.
  ///
  /// In en, this message translates to:
  /// **'the bot is in control'**
  String get ng_bots_bot_in_control;

  /// No description provided for @ng_bots_person_in_control.
  ///
  /// In en, this message translates to:
  /// **'a person is in control'**
  String get ng_bots_person_in_control;

  /// No description provided for @ng_bots_installing.
  ///
  /// In en, this message translates to:
  /// **'Installing Bot Desktop on the gateway host…'**
  String get ng_bots_installing;

  /// No description provided for @ng_bots_install_unfinished.
  ///
  /// In en, this message translates to:
  /// **'The install did not finish'**
  String get ng_bots_install_unfinished;

  /// No description provided for @ng_bots_install.
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get ng_bots_install;

  /// No description provided for @ng_bots_start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get ng_bots_start;

  /// No description provided for @ng_bots_take_over.
  ///
  /// In en, this message translates to:
  /// **'Take over'**
  String get ng_bots_take_over;

  /// No description provided for @ng_bots_keep_image.
  ///
  /// In en, this message translates to:
  /// **'Keep current image'**
  String get ng_bots_keep_image;

  /// No description provided for @ng_bots_missing_pieces.
  ///
  /// In en, this message translates to:
  /// **'The gateway reported missing pieces: {items}'**
  String ng_bots_missing_pieces(String items);

  /// No description provided for @ng_bots_install_missing.
  ///
  /// In en, this message translates to:
  /// **'Install missing pieces'**
  String get ng_bots_install_missing;

  /// No description provided for @ng_bots_thumbnail_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Thumbnail unavailable'**
  String get ng_bots_thumbnail_unavailable;

  /// No description provided for @ng_bots_thumbnail_title.
  ///
  /// In en, this message translates to:
  /// **'Screen thumbnail (live)'**
  String get ng_bots_thumbnail_title;

  /// No description provided for @ng_bots_thumbnail_suppressed.
  ///
  /// In en, this message translates to:
  /// **'Thumbnail suppressed while the screen is human-held.'**
  String get ng_bots_thumbnail_suppressed;

  /// No description provided for @ng_bots_thumbnail_pending.
  ///
  /// In en, this message translates to:
  /// **'Thumbnail not available yet.'**
  String get ng_bots_thumbnail_pending;

  /// No description provided for @ng_bots_routines_of.
  ///
  /// In en, this message translates to:
  /// **'{bot} · routines'**
  String ng_bots_routines_of(String bot);

  /// No description provided for @ng_bots_add_routine.
  ///
  /// In en, this message translates to:
  /// **'Add routine'**
  String get ng_bots_add_routine;

  /// No description provided for @ng_bots_no_routines.
  ///
  /// In en, this message translates to:
  /// **'No routines for this bot.'**
  String get ng_bots_no_routines;

  /// No description provided for @ng_bots_routines_note.
  ///
  /// In en, this message translates to:
  /// **'Routines are [bot:<name>]-tagged jobs owned by the bot’s profile store. Legacy delegated routines are force-paused on load.'**
  String get ng_bots_routines_note;

  /// No description provided for @ng_bots_routine_last.
  ///
  /// In en, this message translates to:
  /// **'last: {status}'**
  String ng_bots_routine_last(String status);

  /// No description provided for @ng_bots_routine_next.
  ///
  /// In en, this message translates to:
  /// **'next: {time}'**
  String ng_bots_routine_next(String time);

  /// No description provided for @ng_bots_routine_error.
  ///
  /// In en, this message translates to:
  /// **'error: {error}'**
  String ng_bots_routine_error(String error);

  /// No description provided for @ng_bots_remove_routine_title.
  ///
  /// In en, this message translates to:
  /// **'Remove routine {routine}?'**
  String ng_bots_remove_routine_title(String routine);

  /// No description provided for @ng_bots_remove_routine_body.
  ///
  /// In en, this message translates to:
  /// **'The routine is deleted from {bot}’s schedule. This cannot be undone.'**
  String ng_bots_remove_routine_body(String bot);

  /// No description provided for @ng_bots_routine_action_failed.
  ///
  /// In en, this message translates to:
  /// **'{action} failed: {error}'**
  String ng_bots_routine_action_failed(String action, String error);

  /// No description provided for @ng_bots_not_connected.
  ///
  /// In en, this message translates to:
  /// **'Not connected.'**
  String get ng_bots_not_connected;

  /// No description provided for @ng_bots_add_failed.
  ///
  /// In en, this message translates to:
  /// **'Add failed: {error}'**
  String ng_bots_add_failed(String error);

  /// No description provided for @ng_bots_routine_added.
  ///
  /// In en, this message translates to:
  /// **'Routine added'**
  String get ng_bots_routine_added;

  /// No description provided for @ng_bots_routine_enabled.
  ///
  /// In en, this message translates to:
  /// **'enabled'**
  String get ng_bots_routine_enabled;

  /// No description provided for @ng_bots_routine_paused.
  ///
  /// In en, this message translates to:
  /// **'paused'**
  String get ng_bots_routine_paused;

  /// No description provided for @ng_bots_path.
  ///
  /// In en, this message translates to:
  /// **'Path: {path}'**
  String ng_bots_path(String path);

  /// No description provided for @ng_bots_chat_present.
  ///
  /// In en, this message translates to:
  /// **'Bot Chat present'**
  String get ng_bots_chat_present;

  /// No description provided for @ng_bots_chat_missing.
  ///
  /// In en, this message translates to:
  /// **'Bot Chat missing'**
  String get ng_bots_chat_missing;

  /// No description provided for @ng_bots_last_session.
  ///
  /// In en, this message translates to:
  /// **'Last session: {preview}'**
  String ng_bots_last_session(String preview);

  /// No description provided for @ng_bots_open_chat.
  ///
  /// In en, this message translates to:
  /// **'Open Bot Chat'**
  String get ng_bots_open_chat;

  /// No description provided for @ng_bots_desktop.
  ///
  /// In en, this message translates to:
  /// **'Bot Desktop'**
  String get ng_bots_desktop;

  /// No description provided for @ng_bots_room_name.
  ///
  /// In en, this message translates to:
  /// **'Room name'**
  String get ng_bots_room_name;

  /// No description provided for @ng_bots_select_member.
  ///
  /// In en, this message translates to:
  /// **'Select at least one member.'**
  String get ng_bots_select_member;

  /// No description provided for @ng_bots_sudo_title.
  ///
  /// In en, this message translates to:
  /// **'Administrator password'**
  String get ng_bots_sudo_title;

  /// No description provided for @ng_bots_sudo_body.
  ///
  /// In en, this message translates to:
  /// **'Installing Bot Desktop for {bot} needs sudo on the gateway host. The password is sent only to that gateway, for this install, and is not saved.'**
  String ng_bots_sudo_body(String bot);

  /// No description provided for @ng_bots_sudo_password.
  ///
  /// In en, this message translates to:
  /// **'sudo password'**
  String get ng_bots_sudo_password;

  /// No description provided for @ng_bots_new_routine.
  ///
  /// In en, this message translates to:
  /// **'New routine'**
  String get ng_bots_new_routine;

  /// No description provided for @ng_bots_routine_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get ng_bots_routine_title;

  /// No description provided for @ng_bots_routine_instruction.
  ///
  /// In en, this message translates to:
  /// **'Instruction'**
  String get ng_bots_routine_instruction;

  /// No description provided for @ng_bots_cron.
  ///
  /// In en, this message translates to:
  /// **'Cron expression'**
  String get ng_bots_cron;

  /// No description provided for @ng_bots_interval.
  ///
  /// In en, this message translates to:
  /// **'Interval'**
  String get ng_bots_interval;

  /// No description provided for @ng_bots_cron_help.
  ///
  /// In en, this message translates to:
  /// **'0 9 * * * runs every day at 09:00'**
  String get ng_bots_cron_help;

  /// No description provided for @ng_bots_every.
  ///
  /// In en, this message translates to:
  /// **'Every'**
  String get ng_bots_every;

  /// No description provided for @ng_bots_unit_minutes.
  ///
  /// In en, this message translates to:
  /// **'minutes'**
  String get ng_bots_unit_minutes;

  /// No description provided for @ng_bots_unit_hours.
  ///
  /// In en, this message translates to:
  /// **'hours'**
  String get ng_bots_unit_hours;

  /// No description provided for @ng_bots_unit_days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get ng_bots_unit_days;

  /// No description provided for @ng_bots_stop_after.
  ///
  /// In en, this message translates to:
  /// **'Stop after (runs)'**
  String get ng_bots_stop_after;

  /// No description provided for @ng_bots_stop_after_help.
  ///
  /// In en, this message translates to:
  /// **'Leave blank to keep running'**
  String get ng_bots_stop_after_help;

  /// No description provided for @ng_bots_send_results.
  ///
  /// In en, this message translates to:
  /// **'Send results to'**
  String get ng_bots_send_results;

  /// No description provided for @ng_bots_run_history.
  ///
  /// In en, this message translates to:
  /// **'Run history only'**
  String get ng_bots_run_history;

  /// No description provided for @ng_bots_continuity.
  ///
  /// In en, this message translates to:
  /// **'Continue from the previous run'**
  String get ng_bots_continuity;

  /// No description provided for @ng_bots_account_changed_refresh.
  ///
  /// In en, this message translates to:
  /// **'Account changed. Refresh before continuing.'**
  String get ng_bots_account_changed_refresh;

  /// No description provided for @ng_bots_room_load_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not load room: {error}'**
  String ng_bots_room_load_failed(String error);

  /// No description provided for @ng_bots_send_failed.
  ///
  /// In en, this message translates to:
  /// **'Send failed: {error}'**
  String ng_bots_send_failed(String error);

  /// No description provided for @ng_bots_stop_failed.
  ///
  /// In en, this message translates to:
  /// **'Stop failed: {error}'**
  String ng_bots_stop_failed(String error);

  /// No description provided for @ng_bots_stop_room.
  ///
  /// In en, this message translates to:
  /// **'Stop room'**
  String get ng_bots_stop_room;

  /// No description provided for @ng_bots_send_message.
  ///
  /// In en, this message translates to:
  /// **'Send a message'**
  String get ng_bots_send_message;

  /// No description provided for @ng_bots_room_hint.
  ///
  /// In en, this message translates to:
  /// **'Message the room (mention members with @handle)'**
  String get ng_bots_room_hint;

  /// No description provided for @ng_bots_history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get ng_bots_history;

  /// No description provided for @ng_bots_revision.
  ///
  /// In en, this message translates to:
  /// **'revision {revision}'**
  String ng_bots_revision(String revision);

  /// No description provided for @ng_bots_last_error.
  ///
  /// In en, this message translates to:
  /// **'last error: {error}'**
  String ng_bots_last_error(String error);

  /// No description provided for @ng_bots_members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get ng_bots_members;

  /// No description provided for @ng_bots_room_context.
  ///
  /// In en, this message translates to:
  /// **'Room context'**
  String get ng_bots_room_context;

  /// No description provided for @ng_bots_purpose.
  ///
  /// In en, this message translates to:
  /// **'Purpose: {purpose}'**
  String ng_bots_purpose(String purpose);

  /// No description provided for @ng_bots_notes.
  ///
  /// In en, this message translates to:
  /// **'Notes: {notes}'**
  String ng_bots_notes(String notes);

  /// No description provided for @ng_bots_routing.
  ///
  /// In en, this message translates to:
  /// **'Routing: {routing}'**
  String ng_bots_routing(String routing);

  /// No description provided for @ng_bots_lead.
  ///
  /// In en, this message translates to:
  /// **'lead {member}'**
  String ng_bots_lead(String member);

  /// No description provided for @ng_bots_viewer_you_control.
  ///
  /// In en, this message translates to:
  /// **'You control this screen. The bot waits until you hand it back.'**
  String get ng_bots_viewer_you_control;

  /// No description provided for @ng_bots_viewer_handed_back.
  ///
  /// In en, this message translates to:
  /// **'Control is back with the bot.'**
  String get ng_bots_viewer_handed_back;

  /// No description provided for @ng_bots_viewer_background.
  ///
  /// In en, this message translates to:
  /// **'Control went back to the bot because the app left the foreground.'**
  String get ng_bots_viewer_background;

  /// No description provided for @ng_bots_viewer_taken.
  ///
  /// In en, this message translates to:
  /// **'Someone else took control of this screen.'**
  String get ng_bots_viewer_taken;

  /// No description provided for @ng_bots_viewer_lost.
  ///
  /// In en, this message translates to:
  /// **'The live view was lost, so control went back to the bot.'**
  String get ng_bots_viewer_lost;

  /// No description provided for @ng_bots_viewer_title.
  ///
  /// In en, this message translates to:
  /// **'Bot Desktop · {bot}'**
  String ng_bots_viewer_title(String bot);

  /// No description provided for @ng_bots_viewer_type_hint.
  ///
  /// In en, this message translates to:
  /// **'Type on the bot’s screen'**
  String get ng_bots_viewer_type_hint;

  /// No description provided for @ng_bots_viewer_type.
  ///
  /// In en, this message translates to:
  /// **'Type it'**
  String get ng_bots_viewer_type;

  /// No description provided for @ng_bots_viewer_enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get ng_bots_viewer_enter;

  /// No description provided for @ng_bots_viewer_backspace.
  ///
  /// In en, this message translates to:
  /// **'Backspace'**
  String get ng_bots_viewer_backspace;

  /// No description provided for @ng_more_kanban.
  ///
  /// In en, this message translates to:
  /// **'Kanban'**
  String get ng_more_kanban;

  /// No description provided for @ng_more_kanban_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Boards, task dependencies, worker assignment and logs'**
  String get ng_more_kanban_subtitle;

  /// No description provided for @ng_more_bots.
  ///
  /// In en, this message translates to:
  /// **'Bots'**
  String get ng_more_bots;

  /// No description provided for @ng_more_bots_subtitle.
  ///
  /// In en, this message translates to:
  /// **'Roster, rooms, routines and Bot Desktop'**
  String get ng_more_bots_subtitle;

  /// No description provided for @ng_slash_kanban.
  ///
  /// In en, this message translates to:
  /// **'Open the Kanban board'**
  String get ng_slash_kanban;

  /// No description provided for @ng_slash_bots.
  ///
  /// In en, this message translates to:
  /// **'Open your bots'**
  String get ng_slash_bots;

  /// No description provided for @ng_board_card_count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 card} other{{count} cards}}'**
  String ng_board_card_count(int count);

  /// No description provided for @ng_board_event_toast.
  ///
  /// In en, this message translates to:
  /// **'Kanban {task}: {event}'**
  String ng_board_event_toast(String task, String event);

  /// No description provided for @ng_board_task.
  ///
  /// In en, this message translates to:
  /// **'task'**
  String get ng_board_task;

  /// No description provided for @ng_board_refused_http.
  ///
  /// In en, this message translates to:
  /// **'Action refused (HTTP {status}).'**
  String ng_board_refused_http(String status);

  /// No description provided for @ng_board_err_unsupported.
  ///
  /// In en, this message translates to:
  /// **'Kanban plugin is not enabled on this gateway.'**
  String get ng_board_err_unsupported;

  /// No description provided for @ng_board_err_denied.
  ///
  /// In en, this message translates to:
  /// **'Sign-in or permission required on this gateway.'**
  String get ng_board_err_denied;

  /// No description provided for @ng_board_err_stale.
  ///
  /// In en, this message translates to:
  /// **'Gateway owner changed. Refresh before continuing.'**
  String get ng_board_err_stale;

  /// No description provided for @ng_board_err_insecure.
  ///
  /// In en, this message translates to:
  /// **'HTTPS (or loopback) is required for Kanban workspace operations.'**
  String get ng_board_err_insecure;

  /// No description provided for @ng_board_err_unreachable.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the Kanban service on this gateway.'**
  String get ng_board_err_unreachable;

  /// No description provided for @ng_board_err_failed.
  ///
  /// In en, this message translates to:
  /// **'Operation failed. Refresh and try again.'**
  String get ng_board_err_failed;

  /// No description provided for @ng_board_block_title.
  ///
  /// In en, this message translates to:
  /// **'Block {task}'**
  String ng_board_block_title(String task);

  /// No description provided for @ng_board_block_reason.
  ///
  /// In en, this message translates to:
  /// **'Blocker reason'**
  String get ng_board_block_reason;

  /// No description provided for @ng_board_block_hint.
  ///
  /// In en, this message translates to:
  /// **'What is blocking this card?'**
  String get ng_board_block_hint;

  /// No description provided for @ng_board_review_title.
  ///
  /// In en, this message translates to:
  /// **'Request review for {task}'**
  String ng_board_review_title(String task);

  /// No description provided for @ng_board_review_summary.
  ///
  /// In en, this message translates to:
  /// **'Review summary'**
  String get ng_board_review_summary;

  /// No description provided for @ng_board_review_hint.
  ///
  /// In en, this message translates to:
  /// **'What was implemented and verified?'**
  String get ng_board_review_hint;

  /// No description provided for @ng_board_move_title.
  ///
  /// In en, this message translates to:
  /// **'Move {cards} to {column}?'**
  String ng_board_move_title(String cards, String column);

  /// No description provided for @ng_board_move_body.
  ///
  /// In en, this message translates to:
  /// **'Every selected card on {board} changes column. A card that is running stops running.'**
  String ng_board_move_body(String board);

  /// No description provided for @ng_board_move.
  ///
  /// In en, this message translates to:
  /// **'Move'**
  String get ng_board_move;

  /// No description provided for @ng_board_moved.
  ///
  /// In en, this message translates to:
  /// **'Moved cards to {column}'**
  String ng_board_moved(String column);

  /// No description provided for @ng_board_unassign_title.
  ///
  /// In en, this message translates to:
  /// **'Unassign {cards}?'**
  String ng_board_unassign_title(String cards);

  /// No description provided for @ng_board_assign_title.
  ///
  /// In en, this message translates to:
  /// **'Assign {cards} to @{profile}?'**
  String ng_board_assign_title(String cards, String profile);

  /// No description provided for @ng_board_assign_body.
  ///
  /// In en, this message translates to:
  /// **'Cards that are running are reclaimed first: their workers are stopped.'**
  String get ng_board_assign_body;

  /// No description provided for @ng_board_unassign.
  ///
  /// In en, this message translates to:
  /// **'Unassign'**
  String get ng_board_unassign;

  /// No description provided for @ng_board_assign.
  ///
  /// In en, this message translates to:
  /// **'Assign'**
  String get ng_board_assign;

  /// No description provided for @ng_board_unassigned_done.
  ///
  /// In en, this message translates to:
  /// **'Unassigned selected cards'**
  String get ng_board_unassigned_done;

  /// No description provided for @ng_board_assigned_done.
  ///
  /// In en, this message translates to:
  /// **'Assigned @{profile}'**
  String ng_board_assigned_done(String profile);

  /// No description provided for @ng_board_archive_title.
  ///
  /// In en, this message translates to:
  /// **'Archive {cards}?'**
  String ng_board_archive_title(String cards);

  /// No description provided for @ng_board_archive_body.
  ///
  /// In en, this message translates to:
  /// **'Archived cards leave {board}. Turn on Archived to see them again.'**
  String ng_board_archive_body(String board);

  /// No description provided for @ng_board_archived_done.
  ///
  /// In en, this message translates to:
  /// **'Archived selected cards'**
  String get ng_board_archived_done;

  /// No description provided for @ng_board_delete_title.
  ///
  /// In en, this message translates to:
  /// **'Delete {cards}?'**
  String ng_board_delete_title(String cards);

  /// No description provided for @ng_board_delete_body.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes the selected cards from {board}.'**
  String ng_board_delete_body(String board);

  /// No description provided for @ng_board_deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted {cards}.'**
  String ng_board_deleted(String cards);

  /// No description provided for @ng_board_partial_failure.
  ///
  /// In en, this message translates to:
  /// **'{failed} of {total} failed: {reason}'**
  String ng_board_partial_failure(String failed, String total, String reason);

  /// No description provided for @ng_board_refused.
  ///
  /// In en, this message translates to:
  /// **'refused'**
  String get ng_board_refused;

  /// No description provided for @ng_board_dispatched.
  ///
  /// In en, this message translates to:
  /// **'Dispatched: {spawned} spawned, {promoted} promoted, {reclaimed} reclaimed.'**
  String ng_board_dispatched(String spawned, String promoted, String reclaimed);

  /// No description provided for @ng_board_board_archived.
  ///
  /// In en, this message translates to:
  /// **'Archived board {board}'**
  String ng_board_board_archived(String board);

  /// No description provided for @ng_board_board_archived_to.
  ///
  /// In en, this message translates to:
  /// **'Archived to {path}'**
  String ng_board_board_archived_to(String path);

  /// No description provided for @ng_board_exported.
  ///
  /// In en, this message translates to:
  /// **'Exported {board} to {archive}'**
  String ng_board_exported(String board, String archive);

  /// No description provided for @ng_board_imported.
  ///
  /// In en, this message translates to:
  /// **'Imported board {board}{warnings}'**
  String ng_board_imported(String board, String warnings);

  /// No description provided for @ng_board_created.
  ///
  /// In en, this message translates to:
  /// **'Created {task}'**
  String ng_board_created(String task);

  /// No description provided for @ng_board_orchestration_saved.
  ///
  /// In en, this message translates to:
  /// **'Saved Kanban orchestration'**
  String get ng_board_orchestration_saved;

  /// No description provided for @ng_board_auto_describe_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Auto-describe unavailable'**
  String get ng_board_auto_describe_unavailable;

  /// No description provided for @ng_board_description_updated.
  ///
  /// In en, this message translates to:
  /// **'Updated @{profile} description'**
  String ng_board_description_updated(String profile);

  /// No description provided for @ng_board_title.
  ///
  /// In en, this message translates to:
  /// **'Kanban · {board}'**
  String ng_board_title(String board);

  /// No description provided for @ng_board_active.
  ///
  /// In en, this message translates to:
  /// **'{count} active'**
  String ng_board_active(String count);

  /// No description provided for @ng_board_dispatch.
  ///
  /// In en, this message translates to:
  /// **'Dispatch ready tasks now'**
  String get ng_board_dispatch;

  /// No description provided for @ng_board_orchestration.
  ///
  /// In en, this message translates to:
  /// **'Orchestration & workers'**
  String get ng_board_orchestration;

  /// No description provided for @ng_board_new_task.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get ng_board_new_task;

  /// No description provided for @ng_board_enable_plugin.
  ///
  /// In en, this message translates to:
  /// **'Enable the bundled \"kanban\" plugin in Capabilities → Plugins on this gateway to activate its board router.'**
  String get ng_board_enable_plugin;

  /// No description provided for @ng_board_filter.
  ///
  /// In en, this message translates to:
  /// **'Filter tasks…'**
  String get ng_board_filter;

  /// No description provided for @ng_board_all_assignees.
  ///
  /// In en, this message translates to:
  /// **'All assignees'**
  String get ng_board_all_assignees;

  /// No description provided for @ng_board_unassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get ng_board_unassigned;

  /// No description provided for @ng_board_running_by_profile.
  ///
  /// In en, this message translates to:
  /// **'Running by profile'**
  String get ng_board_running_by_profile;

  /// No description provided for @ng_board_select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get ng_board_select;

  /// No description provided for @ng_board_selected_chip.
  ///
  /// In en, this message translates to:
  /// **'Selected ({count})'**
  String ng_board_selected_chip(String count);

  /// No description provided for @ng_board_locked_column.
  ///
  /// In en, this message translates to:
  /// **'Managed column — drag drop disabled'**
  String get ng_board_locked_column;

  /// No description provided for @ng_board_add_to.
  ///
  /// In en, this message translates to:
  /// **'Add to {column}'**
  String ng_board_add_to(String column);

  /// No description provided for @ng_board_collapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse {column}'**
  String ng_board_collapse(String column);

  /// No description provided for @ng_board_column_empty.
  ///
  /// In en, this message translates to:
  /// **'No {column} tasks'**
  String ng_board_column_empty(String column);

  /// No description provided for @ng_board_drop_here.
  ///
  /// In en, this message translates to:
  /// **'Drop or + task'**
  String get ng_board_drop_here;

  /// No description provided for @ng_board_card_actions.
  ///
  /// In en, this message translates to:
  /// **'Card actions'**
  String get ng_board_card_actions;

  /// No description provided for @ng_board_open_details.
  ///
  /// In en, this message translates to:
  /// **'Open details'**
  String get ng_board_open_details;

  /// No description provided for @ng_board_select_card.
  ///
  /// In en, this message translates to:
  /// **'Select card'**
  String get ng_board_select_card;

  /// No description provided for @ng_board_move_to.
  ///
  /// In en, this message translates to:
  /// **'Move to {column}'**
  String ng_board_move_to(String column);

  /// No description provided for @ng_board_parked.
  ///
  /// In en, this message translates to:
  /// **'Parked'**
  String get ng_board_parked;

  /// No description provided for @ng_board_blocked_by.
  ///
  /// In en, this message translates to:
  /// **'Blocked by {count}'**
  String ng_board_blocked_by(String count);

  /// No description provided for @ng_board_goal_loop.
  ///
  /// In en, this message translates to:
  /// **'Goal loop'**
  String get ng_board_goal_loop;

  /// No description provided for @ng_board_selected.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String ng_board_selected(String count);

  /// No description provided for @ng_board_move_menu.
  ///
  /// In en, this message translates to:
  /// **'Move…'**
  String get ng_board_move_menu;

  /// No description provided for @ng_board_assign_menu.
  ///
  /// In en, this message translates to:
  /// **'Assign…'**
  String get ng_board_assign_menu;

  /// No description provided for @ng_board_new_board_title.
  ///
  /// In en, this message translates to:
  /// **'New Kanban board'**
  String get ng_board_new_board_title;

  /// No description provided for @ng_board_slug.
  ///
  /// In en, this message translates to:
  /// **'Slug (lowercase, e.g. release-v5)'**
  String get ng_board_slug;

  /// No description provided for @ng_board_display_name.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get ng_board_display_name;

  /// No description provided for @ng_board_linked_project.
  ///
  /// In en, this message translates to:
  /// **'Linked project (optional)'**
  String get ng_board_linked_project;

  /// No description provided for @ng_board_none.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get ng_board_none;

  /// No description provided for @ng_board_default_workdir.
  ///
  /// In en, this message translates to:
  /// **'Default workdir on host (optional)'**
  String get ng_board_default_workdir;

  /// No description provided for @ng_board_import_title.
  ///
  /// In en, this message translates to:
  /// **'Import board archive'**
  String get ng_board_import_title;

  /// No description provided for @ng_board_import_path.
  ///
  /// In en, this message translates to:
  /// **'Host .tar.gz archive path'**
  String get ng_board_import_path;

  /// No description provided for @ng_board_import.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get ng_board_import;

  /// No description provided for @ng_board_edit_board.
  ///
  /// In en, this message translates to:
  /// **'Edit {board}'**
  String ng_board_edit_board(String board);

  /// No description provided for @ng_board_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get ng_board_name;

  /// No description provided for @ng_board_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get ng_board_description;

  /// No description provided for @ng_board_workdir_clear.
  ///
  /// In en, this message translates to:
  /// **'Default workdir (blank clears)'**
  String get ng_board_workdir_clear;

  /// No description provided for @ng_board_boards.
  ///
  /// In en, this message translates to:
  /// **'Kanban boards'**
  String get ng_board_boards;

  /// No description provided for @ng_board_new_board.
  ///
  /// In en, this message translates to:
  /// **'New board'**
  String get ng_board_new_board;

  /// No description provided for @ng_board_search_boards.
  ///
  /// In en, this message translates to:
  /// **'Search boards…'**
  String get ng_board_search_boards;

  /// No description provided for @ng_board_unpin.
  ///
  /// In en, this message translates to:
  /// **'Unpin tab'**
  String get ng_board_unpin;

  /// No description provided for @ng_board_pin.
  ///
  /// In en, this message translates to:
  /// **'Pin tab'**
  String get ng_board_pin;

  /// No description provided for @ng_board_archive_board_title.
  ///
  /// In en, this message translates to:
  /// **'Archive board {board}?'**
  String ng_board_archive_board_title(String board);

  /// No description provided for @ng_board_archive_board_body.
  ///
  /// In en, this message translates to:
  /// **'The board and its {cards} leave the board list. The gateway keeps an archive on its host.'**
  String ng_board_archive_board_body(String cards);

  /// No description provided for @ng_board_edit_metadata.
  ///
  /// In en, this message translates to:
  /// **'Edit metadata'**
  String get ng_board_edit_metadata;

  /// No description provided for @ng_board_export.
  ///
  /// In en, this message translates to:
  /// **'Export .tar.gz on host'**
  String get ng_board_export;

  /// No description provided for @ng_board_move_pin_left.
  ///
  /// In en, this message translates to:
  /// **'Move pinned tab left'**
  String get ng_board_move_pin_left;

  /// No description provided for @ng_board_archive_board.
  ///
  /// In en, this message translates to:
  /// **'Archive board'**
  String get ng_board_archive_board;

  /// No description provided for @ng_board_new_task_title.
  ///
  /// In en, this message translates to:
  /// **'New Kanban task'**
  String get ng_board_new_task_title;

  /// No description provided for @ng_board_title_required.
  ///
  /// In en, this message translates to:
  /// **'Title *'**
  String get ng_board_title_required;

  /// No description provided for @ng_board_spec.
  ///
  /// In en, this message translates to:
  /// **'Spec & acceptance criteria'**
  String get ng_board_spec;

  /// No description provided for @ng_board_estimate.
  ///
  /// In en, this message translates to:
  /// **'Estimate'**
  String get ng_board_estimate;

  /// No description provided for @ng_board_estimate_draft.
  ///
  /// In en, this message translates to:
  /// **'Complexity {complexity} (~{tokens} tok — token estimate only, not a dollar-cost claim)'**
  String ng_board_estimate_draft(String complexity, String tokens);

  /// No description provided for @ng_board_estimate_unavailable.
  ///
  /// In en, this message translates to:
  /// **'Estimate unavailable'**
  String get ng_board_estimate_unavailable;

  /// No description provided for @ng_board_initial_column.
  ///
  /// In en, this message translates to:
  /// **'Initial column'**
  String get ng_board_initial_column;

  /// No description provided for @ng_board_worker_assignee.
  ///
  /// In en, this message translates to:
  /// **'Worker assignee'**
  String get ng_board_worker_assignee;

  /// No description provided for @ng_board_parked_unassigned.
  ///
  /// In en, this message translates to:
  /// **'Parked (unassigned)'**
  String get ng_board_parked_unassigned;

  /// No description provided for @ng_board_priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get ng_board_priority;

  /// No description provided for @ng_board_workspace.
  ///
  /// In en, this message translates to:
  /// **'Workspace'**
  String get ng_board_workspace;

  /// No description provided for @ng_board_scratch.
  ///
  /// In en, this message translates to:
  /// **'Scratch'**
  String get ng_board_scratch;

  /// No description provided for @ng_board_worktree.
  ///
  /// In en, this message translates to:
  /// **'Git worktree'**
  String get ng_board_worktree;

  /// No description provided for @ng_board_shared_dir.
  ///
  /// In en, this message translates to:
  /// **'Shared dir'**
  String get ng_board_shared_dir;

  /// No description provided for @ng_board_workspace_path.
  ///
  /// In en, this message translates to:
  /// **'Host workspace path'**
  String get ng_board_workspace_path;

  /// No description provided for @ng_board_parent.
  ///
  /// In en, this message translates to:
  /// **'Parent dependency (optional)'**
  String get ng_board_parent;

  /// No description provided for @ng_board_skills.
  ///
  /// In en, this message translates to:
  /// **'Pinned skills (comma-separated, optional)'**
  String get ng_board_skills;

  /// No description provided for @ng_board_provider_override.
  ///
  /// In en, this message translates to:
  /// **'Provider override'**
  String get ng_board_provider_override;

  /// No description provided for @ng_board_model_override.
  ///
  /// In en, this message translates to:
  /// **'Model override'**
  String get ng_board_model_override;

  /// No description provided for @ng_board_reasoning.
  ///
  /// In en, this message translates to:
  /// **'Reasoning effort'**
  String get ng_board_reasoning;

  /// No description provided for @ng_board_profile_default.
  ///
  /// In en, this message translates to:
  /// **'Profile default'**
  String get ng_board_profile_default;

  /// No description provided for @ng_board_xhigh.
  ///
  /// In en, this message translates to:
  /// **'X-High'**
  String get ng_board_xhigh;

  /// No description provided for @ng_board_goal_mode.
  ///
  /// In en, this message translates to:
  /// **'Goal loop mode'**
  String get ng_board_goal_mode;

  /// No description provided for @ng_board_goal_turns.
  ///
  /// In en, this message translates to:
  /// **'Goal max turns (blank = default)'**
  String get ng_board_goal_turns;

  /// No description provided for @ng_board_create_task.
  ///
  /// In en, this message translates to:
  /// **'Create task'**
  String get ng_board_create_task;

  /// No description provided for @ng_board_orchestration_title.
  ///
  /// In en, this message translates to:
  /// **'Orchestration & worker profiles'**
  String get ng_board_orchestration_title;

  /// No description provided for @ng_board_orchestrator.
  ///
  /// In en, this message translates to:
  /// **'Orchestrator profile (resolved: {profile})'**
  String ng_board_orchestrator(String profile);

  /// No description provided for @ng_board_inherit_default.
  ///
  /// In en, this message translates to:
  /// **'Inherit active default'**
  String get ng_board_inherit_default;

  /// No description provided for @ng_board_default_assignee.
  ///
  /// In en, this message translates to:
  /// **'Default assignee (resolved: {profile})'**
  String ng_board_default_assignee(String profile);

  /// No description provided for @ng_board_auto_decompose.
  ///
  /// In en, this message translates to:
  /// **'Auto-decompose triage cards'**
  String get ng_board_auto_decompose;

  /// No description provided for @ng_board_auto_decompose_help.
  ///
  /// In en, this message translates to:
  /// **'Uses the configured kanban_decomposer model on triage tasks'**
  String get ng_board_auto_decompose_help;

  /// No description provided for @ng_board_save_orchestration.
  ///
  /// In en, this message translates to:
  /// **'Save orchestration'**
  String get ng_board_save_orchestration;

  /// No description provided for @ng_board_worker_descriptions.
  ///
  /// In en, this message translates to:
  /// **'Worker specialization descriptions'**
  String get ng_board_worker_descriptions;

  /// No description provided for @ng_board_worker_label.
  ///
  /// In en, this message translates to:
  /// **'@{profile} ({model} · {skills})'**
  String ng_board_worker_label(String profile, String model, String skills);

  /// No description provided for @ng_board_default_model.
  ///
  /// In en, this message translates to:
  /// **'default model'**
  String get ng_board_default_model;

  /// No description provided for @ng_board_save_description.
  ///
  /// In en, this message translates to:
  /// **'Save description'**
  String get ng_board_save_description;

  /// No description provided for @ng_board_auto_describe.
  ///
  /// In en, this message translates to:
  /// **'Auto-describe from skills & persona'**
  String get ng_board_auto_describe;

  /// No description provided for @ng_board_manual_block.
  ///
  /// In en, this message translates to:
  /// **'Manual operator block'**
  String get ng_board_manual_block;

  /// No description provided for @ng_board_requested_review.
  ///
  /// In en, this message translates to:
  /// **'Requested review'**
  String get ng_board_requested_review;

  /// No description provided for @ng_board_requeue_title.
  ///
  /// In en, this message translates to:
  /// **'Requeue {task}?'**
  String ng_board_requeue_title(String task);

  /// No description provided for @ng_board_requeue_body.
  ///
  /// In en, this message translates to:
  /// **'A worker running this card is stopped and the card goes back to the queue.'**
  String get ng_board_requeue_body;

  /// No description provided for @ng_board_requeue.
  ///
  /// In en, this message translates to:
  /// **'Requeue'**
  String get ng_board_requeue;

  /// No description provided for @ng_board_reassign_title.
  ///
  /// In en, this message translates to:
  /// **'Reassign {task} to @{profile}?'**
  String ng_board_reassign_title(String task, String profile);

  /// No description provided for @ng_board_reassign_body.
  ///
  /// In en, this message translates to:
  /// **'This card is running: its worker is stopped first.'**
  String get ng_board_reassign_body;

  /// No description provided for @ng_board_reassign.
  ///
  /// In en, this message translates to:
  /// **'Reassign'**
  String get ng_board_reassign;

  /// No description provided for @ng_board_saved_task.
  ///
  /// In en, this message translates to:
  /// **'Saved task {task}'**
  String ng_board_saved_task(String task);

  /// No description provided for @ng_board_commented_requeued.
  ///
  /// In en, this message translates to:
  /// **'Posted comment and requeued task'**
  String get ng_board_commented_requeued;

  /// No description provided for @ng_board_commented.
  ///
  /// In en, this message translates to:
  /// **'Posted comment'**
  String get ng_board_commented;

  /// No description provided for @ng_board_requeued.
  ///
  /// In en, this message translates to:
  /// **'Requeued {task}'**
  String ng_board_requeued(String task);

  /// No description provided for @ng_board_decompose_failed.
  ///
  /// In en, this message translates to:
  /// **'Decompose failed.'**
  String get ng_board_decompose_failed;

  /// No description provided for @ng_board_decompose_failed_reason.
  ///
  /// In en, this message translates to:
  /// **'Decompose failed: {reason}'**
  String ng_board_decompose_failed_reason(String reason);

  /// No description provided for @ng_board_decomposed.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Decomposed into 1 child task} other{Decomposed into {count} child tasks}}'**
  String ng_board_decomposed(int count);

  /// No description provided for @ng_board_no_children.
  ///
  /// In en, this message translates to:
  /// **'No child tasks were created.'**
  String get ng_board_no_children;

  /// No description provided for @ng_board_no_children_reason.
  ///
  /// In en, this message translates to:
  /// **'No child tasks were created: {reason}'**
  String ng_board_no_children_reason(String reason);

  /// No description provided for @ng_board_uploaded.
  ///
  /// In en, this message translates to:
  /// **'Uploaded {file}'**
  String ng_board_uploaded(String file);

  /// No description provided for @ng_board_linked_parent.
  ///
  /// In en, this message translates to:
  /// **'Linked parent {task}'**
  String ng_board_linked_parent(String task);

  /// No description provided for @ng_board_unlinked_parent.
  ///
  /// In en, this message translates to:
  /// **'Removed parent link {task}'**
  String ng_board_unlinked_parent(String task);

  /// No description provided for @ng_board_task_load_failed.
  ///
  /// In en, this message translates to:
  /// **'Unable to load task'**
  String get ng_board_task_load_failed;

  /// No description provided for @ng_board_refresh_task.
  ///
  /// In en, this message translates to:
  /// **'Refresh task'**
  String get ng_board_refresh_task;

  /// No description provided for @ng_board_tab_overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get ng_board_tab_overview;

  /// No description provided for @ng_board_tab_comments.
  ///
  /// In en, this message translates to:
  /// **'Comments & Links'**
  String get ng_board_tab_comments;

  /// No description provided for @ng_board_tab_runs.
  ///
  /// In en, this message translates to:
  /// **'Runs & Log'**
  String get ng_board_tab_runs;

  /// No description provided for @ng_board_tab_events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get ng_board_tab_events;

  /// No description provided for @ng_board_decompose.
  ///
  /// In en, this message translates to:
  /// **'Decompose'**
  String get ng_board_decompose;

  /// No description provided for @ng_board_attach.
  ///
  /// In en, this message translates to:
  /// **'Attach file'**
  String get ng_board_attach;

  /// No description provided for @ng_board_estimate_task.
  ///
  /// In en, this message translates to:
  /// **'Estimate: {complexity} · ~{tokens} tokens ({rationale}) — not a dollar-cost claim.'**
  String ng_board_estimate_task(
    String complexity,
    String tokens,
    String rationale,
  );

  /// No description provided for @ng_board_no_rationale.
  ///
  /// In en, this message translates to:
  /// **'no rationale'**
  String get ng_board_no_rationale;

  /// No description provided for @ng_board_status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get ng_board_status;

  /// No description provided for @ng_board_assignee.
  ///
  /// In en, this message translates to:
  /// **'Assignee'**
  String get ng_board_assignee;

  /// No description provided for @ng_board_title_label.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get ng_board_title_label;

  /// No description provided for @ng_board_body.
  ///
  /// In en, this message translates to:
  /// **'Body / specification'**
  String get ng_board_body;

  /// No description provided for @ng_board_save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get ng_board_save_changes;

  /// No description provided for @ng_board_clear_model.
  ///
  /// In en, this message translates to:
  /// **'Clear model override'**
  String get ng_board_clear_model;

  /// No description provided for @ng_board_blocked_reason.
  ///
  /// In en, this message translates to:
  /// **'Blocked reason: {reason}'**
  String ng_board_blocked_reason(String reason);

  /// No description provided for @ng_board_result.
  ///
  /// In en, this message translates to:
  /// **'Result: {result}'**
  String ng_board_result(String result);

  /// No description provided for @ng_board_parents.
  ///
  /// In en, this message translates to:
  /// **'Blocked by (parents · {count})'**
  String ng_board_parents(String count);

  /// No description provided for @ng_board_add_parent.
  ///
  /// In en, this message translates to:
  /// **'+ Add parent'**
  String get ng_board_add_parent;

  /// No description provided for @ng_board_children.
  ///
  /// In en, this message translates to:
  /// **'Blocks (children · {count})'**
  String ng_board_children(String count);

  /// No description provided for @ng_board_attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments ({count})'**
  String ng_board_attachments(String count);

  /// No description provided for @ng_board_worker.
  ///
  /// In en, this message translates to:
  /// **'worker'**
  String get ng_board_worker;

  /// No description provided for @ng_board_comments.
  ///
  /// In en, this message translates to:
  /// **'Comments ({count})'**
  String ng_board_comments(String count);

  /// No description provided for @ng_board_comment_hint.
  ///
  /// In en, this message translates to:
  /// **'Add comment / worker guidance'**
  String get ng_board_comment_hint;

  /// No description provided for @ng_board_post_comment.
  ///
  /// In en, this message translates to:
  /// **'Post comment'**
  String get ng_board_post_comment;

  /// No description provided for @ng_board_comment_requeue.
  ///
  /// In en, this message translates to:
  /// **'Comment & requeue'**
  String get ng_board_comment_requeue;

  /// No description provided for @ng_board_runs.
  ///
  /// In en, this message translates to:
  /// **'Runs ({count})'**
  String ng_board_runs(String count);

  /// No description provided for @ng_board_no_runs.
  ///
  /// In en, this message translates to:
  /// **'No worker runs recorded yet.'**
  String get ng_board_no_runs;

  /// No description provided for @ng_board_run_error.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String ng_board_run_error(String error);

  /// No description provided for @ng_board_log_tail_truncated.
  ///
  /// In en, this message translates to:
  /// **'Worker log tail ({bytes} B, truncated)'**
  String ng_board_log_tail_truncated(String bytes);

  /// No description provided for @ng_board_log_tail.
  ///
  /// In en, this message translates to:
  /// **'Worker log tail ({bytes} B)'**
  String ng_board_log_tail(String bytes);

  /// No description provided for @ng_board_refresh_log.
  ///
  /// In en, this message translates to:
  /// **'Refresh log'**
  String get ng_board_refresh_log;

  /// No description provided for @ng_board_no_log.
  ///
  /// In en, this message translates to:
  /// **'No worker log output.'**
  String get ng_board_no_log;

  /// No description provided for @ng_board_no_events.
  ///
  /// In en, this message translates to:
  /// **'No events recorded.'**
  String get ng_board_no_events;

  /// No description provided for @ng_bots_room_unknown.
  ///
  /// In en, this message translates to:
  /// **'unknown'**
  String get ng_bots_room_unknown;

  /// No description provided for @ng_bots_room_blocked.
  ///
  /// In en, this message translates to:
  /// **'blocked'**
  String get ng_bots_room_blocked;

  /// No description provided for @ng_bots_room_working.
  ///
  /// In en, this message translates to:
  /// **'working'**
  String get ng_bots_room_working;

  /// No description provided for @ng_bots_room_running.
  ///
  /// In en, this message translates to:
  /// **'running'**
  String get ng_bots_room_running;

  /// No description provided for @ng_bots_room_idle.
  ///
  /// In en, this message translates to:
  /// **'idle'**
  String get ng_bots_room_idle;

  /// No description provided for @ng_board_run_title.
  ///
  /// In en, this message translates to:
  /// **'Run #{id} · @{profile} · {outcome}'**
  String ng_board_run_title(String id, String profile, String outcome);

  /// No description provided for @ng_bots_new_bot.
  ///
  /// In en, this message translates to:
  /// **'New bot'**
  String get ng_bots_new_bot;

  /// No description provided for @ng_bots_new_bot_hint.
  ///
  /// In en, this message translates to:
  /// **'A named teammate with its own memory, skills, and chat. It can message your other agents.'**
  String get ng_bots_new_bot_hint;

  /// No description provided for @ng_bots_field_name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get ng_bots_field_name;

  /// No description provided for @ng_bots_field_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get ng_bots_field_title;

  /// No description provided for @ng_bots_field_description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get ng_bots_field_description;

  /// No description provided for @ng_bots_description_hint.
  ///
  /// In en, this message translates to:
  /// **'What should this bot help with?'**
  String get ng_bots_description_hint;

  /// No description provided for @ng_bots_name_invalid.
  ///
  /// In en, this message translates to:
  /// **'Use lowercase letters, numbers, hyphens or underscores, starting with a letter or number (64 characters at most).'**
  String get ng_bots_name_invalid;

  /// No description provided for @ng_bots_name_taken.
  ///
  /// In en, this message translates to:
  /// **'An agent named “{name}” already exists.'**
  String ng_bots_name_taken(String name);

  /// No description provided for @ng_bots_profile_id.
  ///
  /// In en, this message translates to:
  /// **'Profile id: {id}'**
  String ng_bots_profile_id(String id);

  /// No description provided for @ng_bots_advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced — model, skills, toolsets, SOUL.md'**
  String get ng_bots_advanced;

  /// No description provided for @ng_bots_clone_from.
  ///
  /// In en, this message translates to:
  /// **'Clone from profile'**
  String get ng_bots_clone_from;

  /// No description provided for @ng_bots_clone_main.
  ///
  /// In en, this message translates to:
  /// **'Main profile (default)'**
  String get ng_bots_clone_main;

  /// No description provided for @ng_bots_fresh_profile.
  ///
  /// In en, this message translates to:
  /// **'Fresh profile (bundled skills)'**
  String get ng_bots_fresh_profile;

  /// No description provided for @ng_bots_create_empty.
  ///
  /// In en, this message translates to:
  /// **'Create empty (skip bundled skills)'**
  String get ng_bots_create_empty;

  /// No description provided for @ng_bots_share_keys.
  ///
  /// In en, this message translates to:
  /// **'Share keys & accounts with the main profile'**
  String get ng_bots_share_keys;

  /// No description provided for @ng_bots_provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get ng_bots_provider;

  /// No description provided for @ng_bots_model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get ng_bots_model;

  /// No description provided for @ng_bots_model_pair.
  ///
  /// In en, this message translates to:
  /// **'Enter both a provider and a model.'**
  String get ng_bots_model_pair;

  /// No description provided for @ng_bots_soul.
  ///
  /// In en, this message translates to:
  /// **'SOUL.md (optional — replaces the generated persona)'**
  String get ng_bots_soul;

  /// No description provided for @ng_bots_soul_edit.
  ///
  /// In en, this message translates to:
  /// **'SOUL.md'**
  String get ng_bots_soul_edit;

  /// No description provided for @ng_bots_creating.
  ///
  /// In en, this message translates to:
  /// **'Creating…'**
  String get ng_bots_creating;

  /// No description provided for @ng_bots_create_bot.
  ///
  /// In en, this message translates to:
  /// **'Create bot'**
  String get ng_bots_create_bot;

  /// No description provided for @ng_bots_created.
  ///
  /// In en, this message translates to:
  /// **'Bot “{name}” created'**
  String ng_bots_created(String name);

  /// No description provided for @ng_bots_look_failed.
  ///
  /// In en, this message translates to:
  /// **'Its look was not saved on the gateway; set it in Edit profile.'**
  String get ng_bots_look_failed;

  /// No description provided for @ng_bots_request_failed.
  ///
  /// In en, this message translates to:
  /// **'The gateway did not take it ({reason}).'**
  String ng_bots_request_failed(String reason);

  /// No description provided for @ng_bots_avatar_shape.
  ///
  /// In en, this message translates to:
  /// **'Shape'**
  String get ng_bots_avatar_shape;

  /// No description provided for @ng_bots_avatar_shape_n.
  ///
  /// In en, this message translates to:
  /// **'Shape {n}'**
  String ng_bots_avatar_shape_n(int n);

  /// No description provided for @ng_bots_avatar_colour.
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get ng_bots_avatar_colour;

  /// No description provided for @ng_bots_avatar_colour_n.
  ///
  /// In en, this message translates to:
  /// **'Colour {n}'**
  String ng_bots_avatar_colour_n(int n);

  /// No description provided for @ng_bots_avatar_match_name.
  ///
  /// In en, this message translates to:
  /// **'Match the name'**
  String get ng_bots_avatar_match_name;

  /// No description provided for @ng_bots_avatar_upload.
  ///
  /// In en, this message translates to:
  /// **'Choose an image…'**
  String get ng_bots_avatar_upload;

  /// No description provided for @ng_bots_avatar_remove.
  ///
  /// In en, this message translates to:
  /// **'Remove image — use shape'**
  String get ng_bots_avatar_remove;

  /// No description provided for @ng_bots_avatar_too_large.
  ///
  /// In en, this message translates to:
  /// **'Image too large (max 15 MB).'**
  String get ng_bots_avatar_too_large;

  /// No description provided for @ng_bots_avatar_unreadable.
  ///
  /// In en, this message translates to:
  /// **'That image could not be read.'**
  String get ng_bots_avatar_unreadable;

  /// No description provided for @ng_bots_edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get ng_bots_edit_profile;

  /// No description provided for @ng_bots_edit_description.
  ///
  /// In en, this message translates to:
  /// **'Appearance and role for {name} ({profile}).'**
  String ng_bots_edit_description(String name, String profile);

  /// No description provided for @ng_bots_advanced_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not load the profile settings ({reason}).'**
  String ng_bots_advanced_failed(String reason);

  /// No description provided for @ng_bots_skills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get ng_bots_skills;

  /// No description provided for @ng_bots_toolsets.
  ///
  /// In en, this message translates to:
  /// **'Toolsets'**
  String get ng_bots_toolsets;

  /// No description provided for @ng_bots_toolsets_hint.
  ///
  /// In en, this message translates to:
  /// **'Leaving all (or none) checked keeps the default toolset behaviour.'**
  String get ng_bots_toolsets_hint;

  /// No description provided for @ng_bots_mcp_servers.
  ///
  /// In en, this message translates to:
  /// **'MCP servers'**
  String get ng_bots_mcp_servers;

  /// No description provided for @ng_bots_saving.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get ng_bots_saving;

  /// No description provided for @ng_bots_confirm_changes_title.
  ///
  /// In en, this message translates to:
  /// **'Save these changes?'**
  String get ng_bots_confirm_changes_title;

  /// No description provided for @ng_bots_change_remove_image.
  ///
  /// In en, this message translates to:
  /// **'Remove the bot’s picture'**
  String get ng_bots_change_remove_image;

  /// No description provided for @ng_bots_change_soul.
  ///
  /// In en, this message translates to:
  /// **'Replace its SOUL.md'**
  String get ng_bots_change_soul;

  /// No description provided for @ng_bots_change_turn_off.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Turn off 1 skill, toolset or MCP server} other{Turn off {count} skills, toolsets or MCP servers}}'**
  String ng_bots_change_turn_off(int count);

  /// No description provided for @ng_bots_updated.
  ///
  /// In en, this message translates to:
  /// **'{name} updated'**
  String ng_bots_updated(String name);

  /// No description provided for @ng_bots_sections_failed.
  ///
  /// In en, this message translates to:
  /// **'Some sections failed: {sections}'**
  String ng_bots_sections_failed(String sections);

  /// No description provided for @ng_bots_model_confirm_title.
  ///
  /// In en, this message translates to:
  /// **'Switch the model?'**
  String get ng_bots_model_confirm_title;

  /// No description provided for @ng_bots_model_confirm_ok.
  ///
  /// In en, this message translates to:
  /// **'Switch'**
  String get ng_bots_model_confirm_ok;

  /// No description provided for @ng_bots_model_not_switched.
  ///
  /// In en, this message translates to:
  /// **'The model was not switched.'**
  String get ng_bots_model_not_switched;

  /// No description provided for @ng_bots_section_new.
  ///
  /// In en, this message translates to:
  /// **'New section'**
  String get ng_bots_section_new;

  /// No description provided for @ng_bots_section_new_ellipsis.
  ///
  /// In en, this message translates to:
  /// **'New section…'**
  String get ng_bots_section_new_ellipsis;

  /// No description provided for @ng_bots_section_name.
  ///
  /// In en, this message translates to:
  /// **'Section name'**
  String get ng_bots_section_name;

  /// No description provided for @ng_bots_section_name_hint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Clients'**
  String get ng_bots_section_name_hint;

  /// No description provided for @ng_bots_section_create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get ng_bots_section_create;

  /// No description provided for @ng_bots_section_rename.
  ///
  /// In en, this message translates to:
  /// **'Rename section'**
  String get ng_bots_section_rename;

  /// No description provided for @ng_bots_section_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete section'**
  String get ng_bots_section_delete;

  /// No description provided for @ng_bots_section_move_up.
  ///
  /// In en, this message translates to:
  /// **'Move up'**
  String get ng_bots_section_move_up;

  /// No description provided for @ng_bots_section_move_down.
  ///
  /// In en, this message translates to:
  /// **'Move down'**
  String get ng_bots_section_move_down;

  /// No description provided for @ng_bots_section_unassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get ng_bots_section_unassigned;

  /// No description provided for @ng_bots_section_options.
  ///
  /// In en, this message translates to:
  /// **'{name} section options'**
  String ng_bots_section_options(String name);

  /// No description provided for @ng_bots_section_empty.
  ///
  /// In en, this message translates to:
  /// **'No bots here yet. Use Move to section on a bot.'**
  String get ng_bots_section_empty;

  /// No description provided for @ng_bots_section_move_to.
  ///
  /// In en, this message translates to:
  /// **'Move to section'**
  String get ng_bots_section_move_to;

  /// No description provided for @ng_bots_section_remove.
  ///
  /// In en, this message translates to:
  /// **'Remove from section'**
  String get ng_bots_section_remove;

  /// No description provided for @ng_bots_section_deleted.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Deleted “{name}”} =1{Deleted “{name}” — 1 bot moved to Unassigned} other{Deleted “{name}” — {count} bots moved to Unassigned}}'**
  String ng_bots_section_deleted(String name, int count);

  /// No description provided for @ng_bots_undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get ng_bots_undo;

  /// No description provided for @ng_bots_section_move_failed.
  ///
  /// In en, this message translates to:
  /// **'Could not move the bot ({reason}).'**
  String ng_bots_section_move_failed(String reason);

  /// No description provided for @ng_bots_bot_actions.
  ///
  /// In en, this message translates to:
  /// **'{name} actions'**
  String ng_bots_bot_actions(String name);

  /// No description provided for @ng_bots_section_toggle.
  ///
  /// In en, this message translates to:
  /// **'Show or hide {name}'**
  String ng_bots_section_toggle(String name);

  /// Shared transcript reader user interface: This passage is no longer in the loaded window.
  ///
  /// In en, this message translates to:
  /// **'This passage is no longer in the loaded window.'**
  String
  get release_core_transcript_reader_this_passage_is_no_longer_in_the_loaded;

  /// Shared transcript reader user interface: Loaded prompts
  ///
  /// In en, this message translates to:
  /// **'Loaded prompts'**
  String get release_core_transcript_reader_loaded_prompts;

  /// Shared transcript reader user interface: Jump to latest
  ///
  /// In en, this message translates to:
  /// **'Jump to latest'**
  String get release_core_transcript_reader_jump_to_latest;

  /// Shared transcript reader user interface: No prompts loaded
  ///
  /// In en, this message translates to:
  /// **'No prompts loaded'**
  String get release_core_transcript_reader_no_prompts_loaded;

  /// Shared transcript reader user interface: Find in loaded messages
  ///
  /// In en, this message translates to:
  /// **'Find in loaded messages'**
  String get release_core_transcript_reader_find_in_loaded_messages;

  /// Shared transcript reader user interface: Previous match
  ///
  /// In en, this message translates to:
  /// **'Previous match'**
  String get release_core_transcript_reader_previous_match;

  /// Shared transcript reader user interface: Next match
  ///
  /// In en, this message translates to:
  /// **'Next match'**
  String get release_core_transcript_reader_next_match;

  /// Shared transcript reader user interface: Prompt timeline
  ///
  /// In en, this message translates to:
  /// **'Prompt timeline'**
  String get release_core_transcript_reader_prompt_timeline;

  /// Shared transcript reader user interface: Close find
  ///
  /// In en, this message translates to:
  /// **'Close find'**
  String get release_core_transcript_reader_close_find;

  /// Shared session organisation user interface: Organise chats
  ///
  /// In en, this message translates to:
  /// **'Organise chats'**
  String get release_core_session_organisation_organise_chats;

  /// Shared session organisation user interface: Show model and usage
  ///
  /// In en, this message translates to:
  /// **'Show model and usage'**
  String get release_core_session_organisation_show_model_and_usage;

  /// Shared session files view user interface: Connection changed. Reopen files on the new connection.
  ///
  /// In en, this message translates to:
  /// **'Connection changed. Reopen files on the new connection.'**
  String
  get release_core_session_files_view_connection_changed_reopen_files_on_the_new_connection;

  /// Shared session files view user interface: The connection or session changed. Reopen this pane.
  ///
  /// In en, this message translates to:
  /// **'The connection or session changed. Reopen this pane.'**
  String
  get release_core_session_files_view_the_connection_or_session_changed_reopen_this_pane;

  /// Shared session files view user interface: No verified host working directory for this session.
  ///
  /// In en, this message translates to:
  /// **'No verified host working directory for this session.'**
  String
  get release_core_session_files_view_no_verified_host_working_directory_for_this_session;

  /// Shared session files view user interface: The gateway denied this operation.
  ///
  /// In en, this message translates to:
  /// **'The gateway denied this operation.'**
  String get release_core_session_files_view_the_gateway_denied_this_operation;

  /// Shared session files view user interface: This gateway does not support this operation.
  ///
  /// In en, this message translates to:
  /// **'This gateway does not support this operation.'**
  String
  get release_core_session_files_view_this_gateway_does_not_support_this_operation;

  /// Shared session files view user interface: The file, owner or working directory changed. Reload and review.
  ///
  /// In en, this message translates to:
  /// **'The file, owner or working directory changed. Reload and review.'**
  String
  get release_core_session_files_view_the_file_owner_or_working_directory_changed_reload;

  /// Shared session files view user interface: The gateway returned an unsafe path or invalid file response.
  ///
  /// In en, this message translates to:
  /// **'The gateway returned an unsafe path or invalid file response.'**
  String
  get release_core_session_files_view_the_gateway_returned_an_unsafe_path_or_invalid;

  /// Shared session files view user interface: Workspace access requires a secure gateway connection.
  ///
  /// In en, this message translates to:
  /// **'Workspace access requires a secure gateway connection.'**
  String
  get release_core_session_files_view_workspace_access_requires_a_secure_gateway_connection;

  /// Shared session files view user interface: Gateway unavailable. Refresh to check the current state.
  ///
  /// In en, this message translates to:
  /// **'Gateway unavailable. Refresh to check the current state.'**
  String
  get release_core_session_files_view_gateway_unavailable_refresh_to_check_the_current_state;

  /// Shared session files view user interface: Gateway operation could not be confirmed.
  ///
  /// In en, this message translates to:
  /// **'Gateway operation could not be confirmed.'**
  String
  get release_core_session_files_view_gateway_operation_could_not_be_confirmed;

  /// Shared session files view user interface: Git status unavailable.
  ///
  /// In en, this message translates to:
  /// **'Git status unavailable.'**
  String get release_core_session_files_view_git_status_unavailable;

  /// Shared session files view user interface: Change this chat’s working directory?
  ///
  /// In en, this message translates to:
  /// **'Change this chat’s working directory?'**
  String
  get release_core_session_files_view_change_this_chat_s_working_directory;

  /// Shared session files view user interface: Absolute gateway directory
  ///
  /// In en, this message translates to:
  /// **'Absolute gateway directory'**
  String get release_core_session_files_view_absolute_gateway_directory;

  /// Shared session files view user interface: Change directory
  ///
  /// In en, this message translates to:
  /// **'Change directory'**
  String get release_core_session_files_view_change_directory;

  /// Shared session files view user interface: Replace gateway file?
  ///
  /// In en, this message translates to:
  /// **'Replace gateway file?'**
  String get release_core_session_files_view_replace_gateway_file;

  /// Shared session files view user interface: {value1}
  ///
  /// Only if the file still matches the version you reviewed. A compatible host retains the displaced file for recovery.
  ///
  /// In en, this message translates to:
  /// **'{path}\n\nOnly if the file still matches the version you reviewed. A compatible host retains the displaced file for recovery.'**
  String
  release_core_session_files_view_only_if_the_file_still_matches_the_version(
    String path,
  );

  /// Shared session files view user interface: Save changes
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get release_core_session_files_view_save_changes;

  /// Shared session files view user interface: Saved and verified on the gateway.
  ///
  /// In en, this message translates to:
  /// **'Saved and verified on the gateway.'**
  String get release_core_session_files_view_saved_and_verified_on_the_gateway;

  /// Shared session files view user interface: Guarded saving is unavailable on this gateway. Your draft is still here.
  ///
  /// In en, this message translates to:
  /// **'Guarded saving is unavailable on this gateway. Your draft is still here.'**
  String
  get release_core_session_files_view_guarded_saving_is_unavailable_on_this_gateway_your;

  /// Shared session files view user interface: {value1} Save was not confirmed. Your draft is still here.
  ///
  /// In en, this message translates to:
  /// **'{reason} Save was not confirmed. Your draft is still here.'**
  String
  release_core_session_files_view_save_was_not_confirmed_your_draft_is_still(
    String reason,
  );

  /// Shared session files view user interface: Review current gateway version
  ///
  /// In en, this message translates to:
  /// **'Review current gateway version'**
  String get release_core_session_files_view_review_current_gateway_version;

  /// Shared session files view user interface: Discard draft and reload
  ///
  /// In en, this message translates to:
  /// **'Discard draft and reload'**
  String get release_core_session_files_view_discard_draft_and_reload;

  /// Shared session files view user interface: Keep draft against this version
  ///
  /// In en, this message translates to:
  /// **'Keep draft against this version'**
  String get release_core_session_files_view_keep_draft_against_this_version;

  /// Shared session files view user interface: Discard unsaved edits?
  ///
  /// In en, this message translates to:
  /// **'Discard unsaved edits?'**
  String get release_core_session_files_view_discard_unsaved_edits;

  /// Shared session files view user interface: Keep editing
  ///
  /// In en, this message translates to:
  /// **'Keep editing'**
  String get release_core_session_files_view_keep_editing;

  /// Shared session files view user interface: Discard edits
  ///
  /// In en, this message translates to:
  /// **'Discard edits'**
  String get release_core_session_files_view_discard_edits;

  /// Shared session files view user interface: Remote working directory
  ///
  /// In en, this message translates to:
  /// **'Remote working directory'**
  String get release_core_session_files_view_remote_working_directory;

  /// Shared session files view user interface: Change working directory
  ///
  /// In en, this message translates to:
  /// **'Change working directory'**
  String get release_core_session_files_view_change_working_directory;

  /// Shared session files view user interface: Show ignored files
  ///
  /// In en, this message translates to:
  /// **'Show ignored files'**
  String get release_core_session_files_view_show_ignored_files;

  /// Shared session files view user interface: Gateway does not report ignored status.
  ///
  /// In en, this message translates to:
  /// **'Gateway does not report ignored status.'**
  String
  get release_core_session_files_view_gateway_does_not_report_ignored_status;

  /// Shared session files view user interface: No visible entries
  ///
  /// In en, this message translates to:
  /// **'No visible entries'**
  String get release_core_session_files_view_no_visible_entries;

  /// Shared session files view user interface: Changed
  ///
  /// In en, this message translates to:
  /// **'Changed'**
  String get release_core_session_files_view_changed;

  /// Shared session files view user interface: Ignored
  ///
  /// In en, this message translates to:
  /// **'Ignored'**
  String get release_core_session_files_view_ignored;

  /// Shared session files view user interface: Actions for {value1}
  ///
  /// In en, this message translates to:
  /// **'Actions for {name}'**
  String release_core_session_files_view_actions_for(String name);

  /// Shared session files view user interface: Copy relative path
  ///
  /// In en, this message translates to:
  /// **'Copy relative path'**
  String get release_core_session_files_view_copy_relative_path;

  /// Shared session files view user interface: Copy gateway path
  ///
  /// In en, this message translates to:
  /// **'Copy gateway path'**
  String get release_core_session_files_view_copy_gateway_path;

  /// Shared session files view user interface: Attach folder reference
  ///
  /// In en, this message translates to:
  /// **'Attach folder reference'**
  String get release_core_session_files_view_attach_folder_reference;

  /// Shared session files view user interface: Attach file reference
  ///
  /// In en, this message translates to:
  /// **'Attach file reference'**
  String get release_core_session_files_view_attach_file_reference;

  /// Shared session files view user interface: Preview truncated — editing disabled.
  ///
  /// In en, this message translates to:
  /// **'Preview truncated — editing disabled.'**
  String get release_core_session_files_view_preview_truncated_editing_disabled;

  /// Shared session files view user interface: Select lines
  ///
  /// In en, this message translates to:
  /// **'Select lines'**
  String get release_core_session_files_view_select_lines;

  /// Shared session files view user interface: Review gateway version
  ///
  /// In en, this message translates to:
  /// **'Review gateway version'**
  String get release_core_session_files_view_review_gateway_version;

  /// Shared session files view user interface: Attach selected lines
  ///
  /// In en, this message translates to:
  /// **'Attach selected lines'**
  String get release_core_session_files_view_attach_selected_lines;

  /// Shared session files view user interface: Binary file — no text preview.
  ///
  /// In en, this message translates to:
  /// **'Binary file — no text preview.'**
  String get release_core_session_files_view_binary_file_no_text_preview;

  /// Shared session files view user interface: File source
  ///
  /// In en, this message translates to:
  /// **'File source'**
  String get release_core_session_files_view_file_source;

  /// Shared session files view user interface: Close session files
  ///
  /// In en, this message translates to:
  /// **'Close session files'**
  String get release_core_session_files_view_close_session_files;

  /// Shared session files view user interface: Back to tree
  ///
  /// In en, this message translates to:
  /// **'Back to tree'**
  String get release_core_session_files_view_back_to_tree;

  /// Shared session files view user interface: Session files
  ///
  /// In en, this message translates to:
  /// **'Session files'**
  String get release_core_session_files_view_session_files;

  /// Shared session files view user interface: Git review
  ///
  /// In en, this message translates to:
  /// **'Git review'**
  String get release_core_session_files_view_git_review;

  /// Shared session files view user interface: Refresh tree
  ///
  /// In en, this message translates to:
  /// **'Refresh tree'**
  String get release_core_session_files_view_refresh_tree;

  /// Shared gateway queue screen user interface: This connection changed. Reopen its chat.
  ///
  /// In en, this message translates to:
  /// **'This connection changed. Reopen its chat.'**
  String
  get release_core_gateway_queue_screen_this_connection_changed_reopen_its_chat;

  /// Shared gateway queue screen user interface: Disconnected. Reconnect the chat, then refresh.
  ///
  /// In en, this message translates to:
  /// **'Disconnected. Reconnect the chat, then refresh.'**
  String
  get release_core_gateway_queue_screen_disconnected_reconnect_the_chat_then_refresh;

  /// Shared gateway queue screen user interface: Gateway queue unavailable: {value1}.
  ///
  /// In en, this message translates to:
  /// **'Gateway queue unavailable: {reason}.'**
  String release_core_gateway_queue_screen_gateway_queue_unavailable(
    String reason,
  );

  /// Shared gateway queue screen user interface: Not confirmed ({value1}). Nothing was resent.
  ///
  /// In en, this message translates to:
  /// **'Not confirmed ({reason}). Nothing was resent.'**
  String release_core_gateway_queue_screen_not_confirmed_nothing_was_resent(
    String reason,
  );

  /// Shared gateway queue screen user interface: Gateway confirmed admission.
  ///
  /// In en, this message translates to:
  /// **'Gateway confirmed admission.'**
  String get release_core_gateway_queue_screen_gateway_confirmed_admission;

  /// Shared gateway queue screen user interface: Edited entry admitted at the end of the queue.
  ///
  /// In en, this message translates to:
  /// **'Edited entry admitted at the end of the queue.'**
  String
  get release_core_gateway_queue_screen_edited_entry_admitted_at_the_end_of_the;

  /// Shared gateway queue screen user interface: Discard unknown outcome?
  ///
  /// In en, this message translates to:
  /// **'Discard unknown outcome?'**
  String get release_core_gateway_queue_screen_discard_unknown_outcome;

  /// Shared gateway queue screen user interface: Remove this entry?
  ///
  /// In en, this message translates to:
  /// **'Remove this entry?'**
  String get release_core_gateway_queue_screen_remove_this_entry;

  /// Shared gateway queue screen user interface: The lost turn will not be retried. Waiting turns may now run.
  ///
  /// In en, this message translates to:
  /// **'The lost turn will not be retried. Waiting turns may now run.'**
  String
  get release_core_gateway_queue_screen_the_lost_turn_will_not_be_retried_waiting;

  /// Shared gateway queue screen user interface: If the gateway has just started this entry, removing it can stop that turn.
  ///
  /// In en, this message translates to:
  /// **'If the gateway has just started this entry, removing it can stop that turn.'**
  String
  get release_core_gateway_queue_screen_if_the_gateway_has_just_started_this_entry;

  /// Shared gateway queue screen user interface: Keep
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get release_core_gateway_queue_screen_keep;

  /// Shared gateway queue screen user interface: Discard and resume
  ///
  /// In en, this message translates to:
  /// **'Discard and resume'**
  String get release_core_gateway_queue_screen_discard_and_resume;

  /// Shared gateway queue screen user interface: Remove entry
  ///
  /// In en, this message translates to:
  /// **'Remove entry'**
  String get release_core_gateway_queue_screen_remove_entry;

  /// Shared gateway queue screen user interface: Lost admission resolved; it was not resent.
  ///
  /// In en, this message translates to:
  /// **'Lost admission resolved; it was not resent.'**
  String
  get release_core_gateway_queue_screen_lost_admission_resolved_it_was_not_resent;

  /// Shared gateway queue screen user interface: Gateway acknowledged removal.
  ///
  /// In en, this message translates to:
  /// **'Gateway acknowledged removal.'**
  String get release_core_gateway_queue_screen_gateway_acknowledged_removal;

  /// Shared gateway queue screen user interface: Gateway queue
  ///
  /// In en, this message translates to:
  /// **'Gateway queue'**
  String get release_core_gateway_queue_screen_gateway_queue;

  /// Shared gateway queue screen user interface: Refresh queue
  ///
  /// In en, this message translates to:
  /// **'Refresh queue'**
  String get release_core_gateway_queue_screen_refresh_queue;

  /// Shared gateway queue screen user interface: Queue paused: unknown outcome
  ///
  /// In en, this message translates to:
  /// **'Queue paused: unknown outcome'**
  String get release_core_gateway_queue_screen_queue_paused_unknown_outcome;

  /// Shared gateway queue screen user interface: Review the lost admission before resuming. Nothing is sent again.
  ///
  /// In en, this message translates to:
  /// **'Review the lost admission before resuming. Nothing is sent again.'**
  String
  get release_core_gateway_queue_screen_review_the_lost_admission_before_resuming_nothing_is;

  /// Shared gateway queue screen user interface: No pending admissions
  ///
  /// In en, this message translates to:
  /// **'No pending admissions'**
  String get release_core_gateway_queue_screen_no_pending_admissions;

  /// Shared gateway queue screen user interface: Discard…
  ///
  /// In en, this message translates to:
  /// **'Discard…'**
  String get release_core_gateway_queue_screen_discard;

  /// Shared gateway queue screen user interface: Gateway acknowledged the steering request.
  ///
  /// In en, this message translates to:
  /// **'Gateway acknowledged the steering request.'**
  String
  get release_core_gateway_queue_screen_gateway_acknowledged_the_steering_request;

  /// Shared gateway queue screen user interface: Steer running turn
  ///
  /// In en, this message translates to:
  /// **'Steer running turn'**
  String get release_core_gateway_queue_screen_steer_running_turn;

  /// Shared gateway queue screen user interface: Remove…
  ///
  /// In en, this message translates to:
  /// **'Remove…'**
  String get release_core_gateway_queue_screen_remove;

  /// Shared gateway queue screen user interface: Next prompt
  ///
  /// In en, this message translates to:
  /// **'Next prompt'**
  String get release_core_gateway_queue_screen_next_prompt;

  /// Shared gateway queue screen user interface: Edit queued prompt
  ///
  /// In en, this message translates to:
  /// **'Edit queued prompt'**
  String get release_core_gateway_queue_screen_edit_queued_prompt;

  /// Shared gateway queue screen user interface: Submit to gateway queue
  ///
  /// In en, this message translates to:
  /// **'Submit to gateway queue'**
  String get release_core_gateway_queue_screen_submit_to_gateway_queue;

  /// Shared gateway queue screen user interface: Save at queue end
  ///
  /// In en, this message translates to:
  /// **'Save at queue end'**
  String get release_core_gateway_queue_screen_save_at_queue_end;

  /// Shared gateway queue screen user interface: Cancel edit
  ///
  /// In en, this message translates to:
  /// **'Cancel edit'**
  String get release_core_gateway_queue_screen_cancel_edit;

  /// Shared git review pane user interface: The Git operation did not complete.
  ///
  /// In en, this message translates to:
  /// **'The Git operation did not complete.'**
  String get release_core_git_review_pane_the_git_operation_did_not_complete;

  /// Shared git review pane user interface: Close Git review
  ///
  /// In en, this message translates to:
  /// **'Close Git review'**
  String get release_core_git_review_pane_close_git_review;

  /// Shared git review pane user interface: Pin lane
  ///
  /// In en, this message translates to:
  /// **'Pin lane'**
  String get release_core_git_review_pane_pin_lane;

  /// Shared git review pane user interface: Refresh Git review
  ///
  /// In en, this message translates to:
  /// **'Refresh Git review'**
  String get release_core_git_review_pane_refresh_git_review;

  /// Shared git review pane user interface: Uncommitted
  ///
  /// In en, this message translates to:
  /// **'Uncommitted'**
  String get release_core_git_review_pane_uncommitted;

  /// Shared git review pane user interface: Last turn
  ///
  /// In en, this message translates to:
  /// **'Last turn'**
  String get release_core_git_review_pane_last_turn;

  /// Shared git review pane user interface: Branch and last-turn views are read-only.
  ///
  /// In en, this message translates to:
  /// **'Branch and last-turn views are read-only.'**
  String
  get release_core_git_review_pane_branch_and_last_turn_views_are_read_only;

  /// Shared git review pane user interface: Mark HEAD as the turn baseline
  ///
  /// In en, this message translates to:
  /// **'Mark HEAD as the turn baseline'**
  String get release_core_git_review_pane_mark_head_as_the_turn_baseline;

  /// Shared git review pane user interface: Stage all
  ///
  /// In en, this message translates to:
  /// **'Stage all'**
  String get release_core_git_review_pane_stage_all;

  /// Shared git review pane user interface: Discard every uncommitted change?
  ///
  /// In en, this message translates to:
  /// **'Discard every uncommitted change?'**
  String get release_core_git_review_pane_discard_every_uncommitted_change;

  /// Shared git review pane user interface: Tracked files return to HEAD and untracked files in this session directory are removed.
  ///
  /// In en, this message translates to:
  /// **'Tracked files return to HEAD and untracked files in this session directory are removed.'**
  String
  get release_core_git_review_pane_tracked_files_return_to_head_and_untracked_files;

  /// Shared git review pane user interface: Discard
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get release_core_git_review_pane_discard;

  /// Shared git review pane user interface: Discard all
  ///
  /// In en, this message translates to:
  /// **'Discard all'**
  String get release_core_git_review_pane_discard_all;

  /// Shared git review pane user interface: Unstage
  ///
  /// In en, this message translates to:
  /// **'Unstage'**
  String get release_core_git_review_pane_unstage;

  /// Shared git review pane user interface: Stage
  ///
  /// In en, this message translates to:
  /// **'Stage'**
  String get release_core_git_review_pane_stage;

  /// Shared git review pane user interface: Discard file
  ///
  /// In en, this message translates to:
  /// **'Discard file'**
  String get release_core_git_review_pane_discard_file;

  /// Shared git review pane user interface: Discard {value1}?
  ///
  /// In en, this message translates to:
  /// **'Discard {path}?'**
  String release_core_git_review_pane_discard_2(String path);

  /// Shared git review pane user interface: This restores the committed copy or removes the untracked file.
  ///
  /// In en, this message translates to:
  /// **'This restores the committed copy or removes the untracked file.'**
  String
  get release_core_git_review_pane_this_restores_the_committed_copy_or_removes_the;

  /// Shared git review pane user interface: Commit message
  ///
  /// In en, this message translates to:
  /// **'Commit message'**
  String get release_core_git_review_pane_commit_message;

  /// Shared git review pane user interface: Nothing in the diff to summarise.
  ///
  /// In en, this message translates to:
  /// **'Nothing in the diff to summarise.'**
  String get release_core_git_review_pane_nothing_in_the_diff_to_summarise;

  /// Shared git review pane user interface: Generate message
  ///
  /// In en, this message translates to:
  /// **'Generate message'**
  String get release_core_git_review_pane_generate_message;

  /// Shared git review pane user interface: Commit
  ///
  /// In en, this message translates to:
  /// **'Commit'**
  String get release_core_git_review_pane_commit;

  /// Shared git review pane user interface: Commit and push
  ///
  /// In en, this message translates to:
  /// **'Commit and push'**
  String get release_core_git_review_pane_commit_and_push;

  /// Shared git review pane user interface: Push
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get release_core_git_review_pane_push;

  /// Shared git review pane user interface: Create pull request
  ///
  /// In en, this message translates to:
  /// **'Create pull request'**
  String get release_core_git_review_pane_create_pull_request;

  /// Shared git review pane user interface: Pull request ready
  ///
  /// In en, this message translates to:
  /// **'Pull request ready'**
  String get release_core_git_review_pane_pull_request_ready;

  /// Shared git review pane user interface: Ask Hermes to ship
  ///
  /// In en, this message translates to:
  /// **'Ask Hermes to ship'**
  String get release_core_git_review_pane_ask_hermes_to_ship;

  /// Shared git review pane user interface: gh is authenticated on this gateway.
  ///
  /// In en, this message translates to:
  /// **'gh is authenticated on this gateway.'**
  String get release_core_git_review_pane_gh_is_authenticated_on_this_gateway;

  /// Shared git review pane user interface: Install the GitHub CLI (gh) and sign in to open PRs
  ///
  /// In en, this message translates to:
  /// **'Install the GitHub CLI (gh) and sign in to open PRs'**
  String get release_core_git_review_pane_install_the_github_cli_gh_and_sign_in;

  /// Shared git review pane user interface: Worktrees
  ///
  /// In en, this message translates to:
  /// **'Worktrees'**
  String get release_core_git_review_pane_worktrees;

  /// Shared git review pane user interface: Main
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get release_core_git_review_pane_main;

  /// Shared git review pane user interface: Follow {value1}?
  ///
  /// In en, this message translates to:
  /// **'Follow {branch}?'**
  String release_core_git_review_pane_follow(String branch);

  /// Shared git review pane user interface: The session working directory becomes this worktree unless the lane is pinned.
  ///
  /// In en, this message translates to:
  /// **'The session working directory becomes this worktree unless the lane is pinned.'**
  String
  get release_core_git_review_pane_the_session_working_directory_becomes_this_worktree_unless;

  /// Shared git review pane user interface: Follow
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get release_core_git_review_pane_follow_2;

  /// Shared git review pane user interface: Remove {value1}?
  ///
  /// In en, this message translates to:
  /// **'Remove {branch}?'**
  String release_core_git_review_pane_remove(String branch);

  /// Shared git review pane user interface: The worktree directory is removed.
  ///
  /// In en, this message translates to:
  /// **'The worktree directory is removed.'**
  String get release_core_git_review_pane_the_worktree_directory_is_removed;

  /// Shared git review pane user interface: Remove
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get release_core_git_review_pane_remove_2;

  /// Shared git review pane user interface: New worktree name
  ///
  /// In en, this message translates to:
  /// **'New worktree name'**
  String get release_core_git_review_pane_new_worktree_name;

  /// Shared git review pane user interface: New branch
  ///
  /// In en, this message translates to:
  /// **'New branch'**
  String get release_core_git_review_pane_new_branch;

  /// Shared git review pane user interface: Base branch
  ///
  /// In en, this message translates to:
  /// **'Base branch'**
  String get release_core_git_review_pane_base_branch;

  /// Shared git review pane user interface: Create worktree
  ///
  /// In en, this message translates to:
  /// **'Create worktree'**
  String get release_core_git_review_pane_create_worktree;

  /// Shared git review pane user interface: Existing branch
  ///
  /// In en, this message translates to:
  /// **'Existing branch'**
  String get release_core_git_review_pane_existing_branch;

  /// Shared git review pane user interface: Convert branch to worktree
  ///
  /// In en, this message translates to:
  /// **'Convert branch to worktree'**
  String get release_core_git_review_pane_convert_branch_to_worktree;

  /// Shared git review pane user interface: Switch branch
  ///
  /// In en, this message translates to:
  /// **'Switch branch'**
  String get release_core_git_review_pane_switch_branch;

  /// Shared git review pane user interface: This gateway does not support that Git operation.
  ///
  /// In en, this message translates to:
  /// **'This gateway does not support that Git operation.'**
  String
  get release_core_git_review_pane_this_gateway_does_not_support_that_git_operation;

  /// Shared git review pane user interface: Git needs the session directory on the local terminal backend.
  ///
  /// In en, this message translates to:
  /// **'Git needs the session directory on the local terminal backend.'**
  String
  get release_core_git_review_pane_git_needs_the_session_directory_on_the_local;

  /// Shared git review pane user interface: The gateway refused the Git operation.
  ///
  /// In en, this message translates to:
  /// **'The gateway refused the Git operation.'**
  String get release_core_git_review_pane_the_gateway_refused_the_git_operation;

  /// Shared git review pane user interface: The session changed. Refresh and try again.
  ///
  /// In en, this message translates to:
  /// **'The session changed. Refresh and try again.'**
  String
  get release_core_git_review_pane_the_session_changed_refresh_and_try_again;

  /// Shared git review pane user interface: This review is no longer the selected session.
  ///
  /// In en, this message translates to:
  /// **'This review is no longer the selected session.'**
  String
  get release_core_git_review_pane_this_review_is_no_longer_the_selected_session;

  /// Shared git review pane user interface: The gateway returned an unexpected Git result.
  ///
  /// In en, this message translates to:
  /// **'The gateway returned an unexpected Git result.'**
  String
  get release_core_git_review_pane_the_gateway_returned_an_unexpected_git_result;

  /// Shared git review pane user interface: Git review requires the gateway transport.
  ///
  /// In en, this message translates to:
  /// **'Git review requires the gateway transport.'**
  String
  get release_core_git_review_pane_git_review_requires_the_gateway_transport;

  /// Shared client held queue bar user interface: Resume
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get release_core_client_held_queue_bar_resume;

  /// Shared client held queue bar user interface: Send queued prompt
  ///
  /// In en, this message translates to:
  /// **'Send queued prompt'**
  String get release_core_client_held_queue_bar_send_queued_prompt;

  /// Shared client held queue bar user interface: Edit unsent prompt
  ///
  /// In en, this message translates to:
  /// **'Edit unsent prompt'**
  String get release_core_client_held_queue_bar_edit_unsent_prompt;

  /// Shared client held queue bar user interface: Remove unsent prompt
  ///
  /// In en, this message translates to:
  /// **'Remove unsent prompt'**
  String get release_core_client_held_queue_bar_remove_unsent_prompt;

  /// Shared workspace discovery view user interface: Repository discovery
  ///
  /// In en, this message translates to:
  /// **'Repository discovery'**
  String get release_core_workspace_discovery_view_repository_discovery;

  /// Shared workspace discovery view user interface: Refresh results
  ///
  /// In en, this message translates to:
  /// **'Refresh results'**
  String get release_core_workspace_discovery_view_refresh_results;

  /// Shared workspace discovery view user interface: Hide {value1}
  ///
  /// In en, this message translates to:
  /// **'Hide {path}'**
  String release_core_workspace_discovery_view_hide(String path);

  /// Shared workspace discovery view user interface: Invalid path or discovery data. Use absolute server paths without . or .. components.
  ///
  /// In en, this message translates to:
  /// **'Invalid path or discovery data. Use absolute server paths without . or .. components.'**
  String
  get release_core_workspace_discovery_view_invalid_path_or_discovery_data_use_absolute_server;

  /// Shared workspace discovery view user interface: This gateway does not support repository discovery.
  ///
  /// In en, this message translates to:
  /// **'This gateway does not support repository discovery.'**
  String
  get release_core_workspace_discovery_view_this_gateway_does_not_support_repository_discovery;

  /// Shared workspace discovery view user interface: The gateway denied access to repository discovery.
  ///
  /// In en, this message translates to:
  /// **'The gateway denied access to repository discovery.'**
  String
  get release_core_workspace_discovery_view_the_gateway_denied_access_to_repository_discovery;

  /// Shared workspace discovery view user interface: The connection changed. Reopen discovery on the current gateway.
  ///
  /// In en, this message translates to:
  /// **'The connection changed. Reopen discovery on the current gateway.'**
  String
  get release_core_workspace_discovery_view_the_connection_changed_reopen_discovery_on_the_current;

  /// Shared workspace discovery view user interface: The displayed settings have changed. Refresh before trying again.
  ///
  /// In en, this message translates to:
  /// **'The displayed settings have changed. Refresh before trying again.'**
  String
  get release_core_workspace_discovery_view_the_displayed_settings_have_changed_refresh_before_trying;

  /// Shared workspace discovery view user interface: Could not load or verify discovery settings. Refresh to try again.
  ///
  /// In en, this message translates to:
  /// **'Could not load or verify discovery settings. Refresh to try again.'**
  String
  get release_core_workspace_discovery_view_could_not_load_or_verify_discovery_settings_refresh;

  /// Shared workspace discovery view user interface: Repositories shown: {count1} of {count2}
  ///
  /// In en, this message translates to:
  /// **'Repositories shown: {visible} of {total}'**
  String release_core_workspace_discovery_view_repositories_shown_of(
    int visible,
    int total,
  );

  /// Shared workspace discovery view user interface: The gateway returned no repositories.
  ///
  /// In en, this message translates to:
  /// **'The gateway returned no repositories.'**
  String
  get release_core_workspace_discovery_view_the_gateway_returned_no_repositories;

  /// Shared workspace discovery view user interface: No repositories match your device filters.
  ///
  /// In en, this message translates to:
  /// **'No repositories match your device filters.'**
  String
  get release_core_workspace_discovery_view_no_repositories_match_your_device_filters;

  /// Shared workspace discovery view user interface: Gateway scan policy
  ///
  /// In en, this message translates to:
  /// **'Gateway scan policy'**
  String get release_core_workspace_discovery_view_gateway_scan_policy;

  /// Shared workspace discovery view user interface: This gateway did not report a scan policy.
  ///
  /// In en, this message translates to:
  /// **'This gateway did not report a scan policy.'**
  String
  get release_core_workspace_discovery_view_this_gateway_did_not_report_a_scan_policy;

  /// Shared workspace discovery view user interface: To scan folders, configure repository scanning in the gateway profile’s Desktop settings.
  ///
  /// In en, this message translates to:
  /// **'To scan folders, configure repository scanning in the gateway profile’s Desktop settings.'**
  String
  get release_core_workspace_discovery_view_to_scan_folders_configure_repository_scanning_in_the;

  /// Shared workspace discovery view user interface: Results can include cached repositories and repositories with sessions. A scan does not guarantee that every folder was reached.
  ///
  /// In en, this message translates to:
  /// **'Results can include cached repositories and repositories with sessions. A scan does not guarantee that every folder was reached.'**
  String
  get release_core_workspace_discovery_view_results_can_include_cached_repositories_and_repositories_with;

  /// Shared workspace discovery view user interface: Scan gateway roots
  ///
  /// In en, this message translates to:
  /// **'Scan gateway roots'**
  String get release_core_workspace_discovery_view_scan_gateway_roots;

  /// Shared workspace discovery view user interface: Filter results on this device
  ///
  /// In en, this message translates to:
  /// **'Filter results on this device'**
  String
  get release_core_workspace_discovery_view_filter_results_on_this_device;

  /// Shared workspace discovery view user interface: Only this discovery list changes, not the gateway scan.
  ///
  /// In en, this message translates to:
  /// **'Only this discovery list changes, not the gateway scan.'**
  String
  get release_core_workspace_discovery_view_only_this_discovery_list_changes_not_the_gateway;

  /// Shared workspace discovery view user interface: Include subtrees (empty = all)
  ///
  /// In en, this message translates to:
  /// **'Include subtrees (empty = all)'**
  String get release_core_workspace_discovery_view_include_subtrees_empty_all;

  /// Shared workspace discovery view user interface: Exclude subtrees
  ///
  /// In en, this message translates to:
  /// **'Exclude subtrees'**
  String get release_core_workspace_discovery_view_exclude_subtrees;

  /// Shared workspace discovery view user interface: Apply filters
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get release_core_workspace_discovery_view_apply_filters;

  /// Shared workspace discovery view user interface: Hidden repositories ({count1})
  ///
  /// In en, this message translates to:
  /// **'Hidden repositories ({count})'**
  String release_core_workspace_discovery_view_hidden_repositories(int count);

  /// Shared workspace discovery view user interface: Undo hide
  ///
  /// In en, this message translates to:
  /// **'Undo hide'**
  String get release_core_workspace_discovery_view_undo_hide;

  /// Shared workspace discovery view user interface: One absolute server path per line
  ///
  /// In en, this message translates to:
  /// **'One absolute server path per line'**
  String
  get release_core_workspace_discovery_view_one_absolute_server_path_per_line;

  /// Shared project settings view user interface: Project settings
  ///
  /// In en, this message translates to:
  /// **'Project settings'**
  String get release_core_project_settings_view_project_settings;

  /// Shared project settings view user interface: The gateway did not confirm the selected project or change. Review the settings before trying again.
  ///
  /// In en, this message translates to:
  /// **'The gateway did not confirm the selected project or change. Review the settings before trying again.'**
  String
  get release_core_project_settings_view_the_gateway_did_not_confirm_the_selected_project;

  /// Shared project settings view user interface: Could not verify these settings. Use one absolute server folder path per line, without . or .. components.
  ///
  /// In en, this message translates to:
  /// **'Could not verify these settings. Use one absolute server folder path per line, without . or .. components.'**
  String
  get release_core_project_settings_view_could_not_verify_these_settings_use_one_absolute;

  /// Shared project settings view user interface: Set active
  ///
  /// In en, this message translates to:
  /// **'Set active'**
  String get release_core_project_settings_view_set_active;

  /// Shared project settings view user interface: Icon
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get release_core_project_settings_view_icon;

  /// Shared project settings view user interface: Folder
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get release_core_project_settings_view_folder;

  /// Shared project settings view user interface: Repository
  ///
  /// In en, this message translates to:
  /// **'Repository'**
  String get release_core_project_settings_view_repository;

  /// Shared project settings view user interface: Rocket
  ///
  /// In en, this message translates to:
  /// **'Rocket'**
  String get release_core_project_settings_view_rocket;

  /// Shared project settings view user interface: Star
  ///
  /// In en, this message translates to:
  /// **'Star'**
  String get release_core_project_settings_view_star;

  /// Shared project settings view user interface: Book
  ///
  /// In en, this message translates to:
  /// **'Book'**
  String get release_core_project_settings_view_book;

  /// Shared project settings view user interface: Terminal
  ///
  /// In en, this message translates to:
  /// **'Terminal'**
  String get release_core_project_settings_view_terminal;

  /// Shared project settings view user interface: Colour
  ///
  /// In en, this message translates to:
  /// **'Colour'**
  String get release_core_project_settings_view_colour;

  /// Shared project settings view user interface: Primary folder
  ///
  /// In en, this message translates to:
  /// **'Primary folder'**
  String get release_core_project_settings_view_primary_folder;

  /// Shared project settings view user interface: Server folder paths
  ///
  /// In en, this message translates to:
  /// **'Server folder paths'**
  String get release_core_project_settings_view_server_folder_paths;

  /// Shared project settings view user interface: One absolute path per line. Existing folders are kept.
  ///
  /// In en, this message translates to:
  /// **'One absolute path per line. Existing folders are kept.'**
  String
  get release_core_project_settings_view_one_absolute_path_per_line_existing_folders_are;

  /// Shared project settings view user interface: Add folders
  ///
  /// In en, this message translates to:
  /// **'Add folders'**
  String get release_core_project_settings_view_add_folders;

  /// Shared project settings view user interface: Choose {value1}
  ///
  /// In en, this message translates to:
  /// **'Choose {label}'**
  String release_core_project_settings_view_choose(String label);

  /// Shared prepared image recovery user interface: Wait for an empty draft before restoring.
  ///
  /// In en, this message translates to:
  /// **'Wait for an empty draft before restoring.'**
  String
  get release_core_prepared_image_recovery_wait_for_an_empty_draft_before_restoring;

  /// Shared prepared image recovery user interface: No unacknowledged image drafts in this chat.
  ///
  /// In en, this message translates to:
  /// **'No unacknowledged image drafts in this chat.'**
  String
  get release_core_prepared_image_recovery_no_unacknowledged_image_drafts_in_this_chat;

  /// Shared prepared image recovery user interface: Unacknowledged image drafts
  ///
  /// In en, this message translates to:
  /// **'Unacknowledged image drafts'**
  String get release_core_prepared_image_recovery_unacknowledged_image_drafts;

  /// Shared prepared image recovery user interface: The gateway may already have received these. Restore to review; nothing is sent.
  ///
  /// In en, this message translates to:
  /// **'The gateway may already have received these. Restore to review; nothing is sent.'**
  String
  get release_core_prepared_image_recovery_the_gateway_may_already_have_received_these_restore;

  /// Shared prepared image recovery user interface: Image draft
  ///
  /// In en, this message translates to:
  /// **'Image draft'**
  String get release_core_prepared_image_recovery_image_draft;

  /// Shared prepared image recovery user interface: Discard local copy
  ///
  /// In en, this message translates to:
  /// **'Discard local copy'**
  String get release_core_prepared_image_recovery_discard_local_copy;

  /// Shared prepared image recovery user interface: Discard this local image draft?
  ///
  /// In en, this message translates to:
  /// **'Discard this local image draft?'**
  String
  get release_core_prepared_image_recovery_discard_this_local_image_draft;

  /// Shared prepared image recovery user interface: Image draft recovery is unavailable.
  ///
  /// In en, this message translates to:
  /// **'Image draft recovery is unavailable.'**
  String
  get release_core_prepared_image_recovery_image_draft_recovery_is_unavailable;

  /// Shared prepared image recovery user interface: Recover image draft…
  ///
  /// In en, this message translates to:
  /// **'Recover image draft…'**
  String get release_core_prepared_image_recovery_recover_image_draft;

  /// Shared session search mode menu user interface: Could not save search mode.
  ///
  /// In en, this message translates to:
  /// **'Could not save search mode.'**
  String get release_core_session_search_mode_menu_could_not_save_search_mode;

  /// Shared projects pane user interface: Discover repositories
  ///
  /// In en, this message translates to:
  /// **'Discover repositories'**
  String get release_core_projects_pane_discover_repositories;

  /// Shared projects pane user interface: Project created, but the gateway did not confirm its idea.
  ///
  /// In en, this message translates to:
  /// **'Project created, but the gateway did not confirm its idea.'**
  String
  get release_core_projects_pane_project_created_but_the_gateway_did_not_confirm;

  /// Shared projects pane user interface: Project idea (optional)
  ///
  /// In en, this message translates to:
  /// **'Project idea (optional)'**
  String get release_core_projects_pane_project_idea_optional;

  /// Shared projects pane user interface: Saved in the project description, not a file.
  ///
  /// In en, this message translates to:
  /// **'Saved in the project description, not a file.'**
  String
  get release_core_projects_pane_saved_in_the_project_description_not_a_file;

  /// Shared project detail screen user interface: New chat in this lane
  ///
  /// In en, this message translates to:
  /// **'New chat in this lane'**
  String get release_core_project_detail_screen_new_chat_in_this_lane;

  /// Shared project detail screen user interface: Review Git
  ///
  /// In en, this message translates to:
  /// **'Review Git'**
  String get release_core_project_detail_screen_review_git;

  /// Shared more pane user interface: Gateway fleet
  ///
  /// In en, this message translates to:
  /// **'Gateway fleet'**
  String get release_core_more_pane_gateway_fleet;

  /// Shared more pane user interface: Connected sessions, Hermes Cloud and Desktop Webapp
  ///
  /// In en, this message translates to:
  /// **'Connected sessions, Hermes Cloud and Desktop Webapp'**
  String
  get release_core_more_pane_connected_sessions_hermes_cloud_and_desktop_webapp;

  /// Shared more pane user interface: Use dashboard sign-in for a named profile. This legacy API cannot confirm which profile owns chat history.
  ///
  /// In en, this message translates to:
  /// **'Use dashboard sign-in for a named profile. This legacy API cannot confirm which profile owns chat history.'**
  String get release_core_more_pane_use_dashboard_sign_in_for_a_named_profile;

  /// Shared more pane user interface: Capabilities
  ///
  /// In en, this message translates to:
  /// **'Capabilities'**
  String get release_core_more_pane_capabilities;

  /// Shared more pane user interface: Install and govern skills, plugins, connectors and tool backends
  ///
  /// In en, this message translates to:
  /// **'Install and govern skills, plugins, connectors and tool backends'**
  String
  get release_core_more_pane_install_and_govern_skills_plugins_connectors_and_tool;

  /// Shared more pane user interface: Browser vault
  ///
  /// In en, this message translates to:
  /// **'Browser vault'**
  String get release_core_more_pane_browser_vault;

  /// Shared more pane user interface: Site logins, addresses, cards and credential sources
  ///
  /// In en, this message translates to:
  /// **'Site logins, addresses, cards and credential sources'**
  String
  get release_core_more_pane_site_logins_addresses_cards_and_credential_sources;

  /// Shared more pane user interface: Agent policy
  ///
  /// In en, this message translates to:
  /// **'Agent policy'**
  String get release_core_more_pane_agent_policy;

  /// Shared more pane user interface: Approvals, checkpoints, browser access and shared metrics
  ///
  /// In en, this message translates to:
  /// **'Approvals, checkpoints, browser access and shared metrics'**
  String
  get release_core_more_pane_approvals_checkpoints_browser_access_and_shared_metrics;

  /// Shared more pane user interface: Remote logs, health, maintenance and update
  ///
  /// In en, this message translates to:
  /// **'Remote logs, health, maintenance and update'**
  String get release_core_more_pane_remote_logs_health_maintenance_and_update;

  /// Shared more pane user interface: Schedules
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get release_core_more_pane_schedules;

  /// Shared more pane user interface: All profiles, blueprints, catch-up and stop
  ///
  /// In en, this message translates to:
  /// **'All profiles, blueprints, catch-up and stop'**
  String get release_core_more_pane_all_profiles_blueprints_catch_up_and_stop;

  /// Shared more pane user interface: Memory graph
  ///
  /// In en, this message translates to:
  /// **'Memory graph'**
  String get release_core_more_pane_memory_graph;

  /// Shared more pane user interface: Timeline, edits and memory providers
  ///
  /// In en, this message translates to:
  /// **'Timeline, edits and memory providers'**
  String get release_core_more_pane_timeline_edits_and_memory_providers;

  /// Shared more pane user interface: Providers and routes
  ///
  /// In en, this message translates to:
  /// **'Providers and routes'**
  String get release_core_more_pane_providers_and_routes;

  /// Shared more pane user interface: Keys, endpoints, delegation and mixtures
  ///
  /// In en, this message translates to:
  /// **'Keys, endpoints, delegation and mixtures'**
  String get release_core_more_pane_keys_endpoints_delegation_and_mixtures;

  /// Shared more pane user interface: Credits and plans
  ///
  /// In en, this message translates to:
  /// **'Credits and plans'**
  String get release_core_more_pane_credits_and_plans;

  /// Shared more pane user interface: Consented Nous billing when the account allows it
  ///
  /// In en, this message translates to:
  /// **'Consented Nous billing when the account allows it'**
  String
  get release_core_more_pane_consented_nous_billing_when_the_account_allows_it;

  /// Shared fleet screen user interface: This gateway does not offer this service.
  ///
  /// In en, this message translates to:
  /// **'This gateway does not offer this service.'**
  String get release_core_fleet_screen_this_gateway_does_not_offer_this_service;

  /// Shared fleet screen user interface: Sign-in or permission required on this gateway.
  ///
  /// In en, this message translates to:
  /// **'Sign-in or permission required on this gateway.'**
  String
  get release_core_fleet_screen_sign_in_or_permission_required_on_this_gateway;

  /// Shared fleet screen user interface: A secure gateway address is required.
  ///
  /// In en, this message translates to:
  /// **'A secure gateway address is required.'**
  String get release_core_fleet_screen_a_secure_gateway_address_is_required;

  /// Shared fleet screen user interface: The owner changed. Refresh before continuing.
  ///
  /// In en, this message translates to:
  /// **'The owner changed. Refresh before continuing.'**
  String
  get release_core_fleet_screen_the_owner_changed_refresh_before_continuing;

  /// Shared fleet screen user interface: Could not verify the operation. Check the gateway and refresh.
  ///
  /// In en, this message translates to:
  /// **'Could not verify the operation. Check the gateway and refresh.'**
  String
  get release_core_fleet_screen_could_not_verify_the_operation_check_the_gateway;

  /// Shared fleet screen user interface: Verified SSH
  ///
  /// In en, this message translates to:
  /// **'Verified SSH'**
  String get release_core_fleet_screen_verified_ssh;

  /// Shared fleet screen user interface: Confirm a host key, inspect a remote service or open its shell
  ///
  /// In en, this message translates to:
  /// **'Confirm a host key, inspect a remote service or open its shell'**
  String
  get release_core_fleet_screen_confirm_a_host_key_inspect_a_remote_service;

  /// Shared fleet screen user interface: Cloud and Desktop Webapp
  ///
  /// In en, this message translates to:
  /// **'Cloud and Desktop Webapp'**
  String get release_core_fleet_screen_cloud_and_desktop_webapp;

  /// Shared fleet screen user interface: Register an existing gateway or Webapp
  ///
  /// In en, this message translates to:
  /// **'Register an existing gateway or Webapp'**
  String get release_core_fleet_screen_register_an_existing_gateway_or_webapp;

  /// Shared fleet screen user interface: Sign in to its address. Nothing is hosted on this device.
  ///
  /// In en, this message translates to:
  /// **'Sign in to its address. Nothing is hosted on this device.'**
  String get release_core_fleet_screen_sign_in_to_its_address_nothing_is_hosted;

  /// Shared fleet screen user interface: Fleet updates
  ///
  /// In en, this message translates to:
  /// **'Fleet updates'**
  String get release_core_fleet_screen_fleet_updates;

  /// Shared fleet screen user interface: Refresh roster
  ///
  /// In en, this message translates to:
  /// **'Refresh roster'**
  String get release_core_fleet_screen_refresh_roster;

  /// Shared fleet screen user interface: Disconnect {value1}
  ///
  /// In en, this message translates to:
  /// **'Disconnect {gateway}'**
  String release_core_fleet_screen_disconnect(String gateway);

  /// Shared fleet screen user interface: Open this gateway on launch
  ///
  /// In en, this message translates to:
  /// **'Open this gateway on launch'**
  String get release_core_fleet_screen_open_this_gateway_on_launch;

  /// Shared fleet screen user interface: Primary for Ares; does not change the last-used gateway.
  ///
  /// In en, this message translates to:
  /// **'Primary for Ares; does not change the last-used gateway.'**
  String
  get release_core_fleet_screen_primary_for_ares_does_not_change_the_last;

  /// Shared fleet screen user interface: Reconnect in fleet on launch
  ///
  /// In en, this message translates to:
  /// **'Reconnect in fleet on launch'**
  String get release_core_fleet_screen_reconnect_in_fleet_on_launch;

  /// Shared fleet screen user interface: No sessions for this profile.
  ///
  /// In en, this message translates to:
  /// **'No sessions for this profile.'**
  String get release_core_fleet_screen_no_sessions_for_this_profile;

  /// Shared fleet screen user interface: More sessions
  ///
  /// In en, this message translates to:
  /// **'More sessions'**
  String get release_core_fleet_screen_more_sessions;

  /// Shared fleet screen user interface: This gateway was disconnected.
  ///
  /// In en, this message translates to:
  /// **'This gateway was disconnected.'**
  String get release_core_fleet_screen_this_gateway_was_disconnected;

  /// Shared fleet screen user interface: Some conversation data could not be loaded.
  ///
  /// In en, this message translates to:
  /// **'Some conversation data could not be loaded.'**
  String
  get release_core_fleet_screen_some_conversation_data_could_not_be_loaded;

  /// Shared fleet screen user interface: Message this session
  ///
  /// In en, this message translates to:
  /// **'Message this session'**
  String get release_core_fleet_screen_message_this_session;

  /// Shared fleet screen user interface: Send to this session
  ///
  /// In en, this message translates to:
  /// **'Send to this session'**
  String get release_core_fleet_screen_send_to_this_session;

  /// Shared fleet updates screen user interface: Update these remote gateways?
  ///
  /// In en, this message translates to:
  /// **'Update these remote gateways?'**
  String get release_core_fleet_updates_screen_update_these_remote_gateways;

  /// Shared fleet updates screen user interface: This can restart the backend and interrupt other users. It will not update Ares.
  ///
  /// {value1}
  ///
  /// In en, this message translates to:
  /// **'This can restart the backend and interrupt other users. It will not update Ares.\n\n{gateways}'**
  String
  release_core_fleet_updates_screen_this_can_restart_the_backend_and_interrupt_other(
    String gateways,
  );

  /// Shared fleet updates screen user interface: Update listed gateways
  ///
  /// In en, this message translates to:
  /// **'Update listed gateways'**
  String get release_core_fleet_updates_screen_update_listed_gateways;

  /// Shared fleet updates screen user interface: Checks connected gateways. Cloud is platform-managed; entries without enrollment provenance are excluded.
  ///
  /// In en, this message translates to:
  /// **'Checks connected gateways. Cloud is platform-managed; entries without enrollment provenance are excluded.'**
  String
  get release_core_fleet_updates_screen_checks_connected_gateways_cloud_is_platform_managed_entries;

  /// Shared fleet updates screen user interface: Check connected gateways
  ///
  /// In en, this message translates to:
  /// **'Check connected gateways'**
  String get release_core_fleet_updates_screen_check_connected_gateways;

  /// Shared fleet updates screen user interface: Read update receipt
  ///
  /// In en, this message translates to:
  /// **'Read update receipt'**
  String get release_core_fleet_updates_screen_read_update_receipt;

  /// Shared fleet updates screen user interface: Review eligible updates
  ///
  /// In en, this message translates to:
  /// **'Review eligible updates'**
  String get release_core_fleet_updates_screen_review_eligible_updates;

  /// Shared fleet webapp screen user interface: Account changed. Reopen this page.
  ///
  /// In en, this message translates to:
  /// **'Account changed. Reopen this page.'**
  String get release_core_fleet_webapp_screen_account_changed_reopen_this_page;

  /// Shared fleet webapp screen user interface: Set the Webapp’s primary gateway?
  ///
  /// In en, this message translates to:
  /// **'Set the Webapp’s primary gateway?'**
  String get release_core_fleet_webapp_screen_set_the_webapp_s_primary_gateway;

  /// Shared fleet webapp screen user interface: {value1} → {value2} ({value3})
  /// This changes the shared registry, not the last-used gateway.
  ///
  /// In en, this message translates to:
  /// **'{webapp} → {gateway} ({id})\nThis changes the shared registry, not the last-used gateway.'**
  String
  release_core_fleet_webapp_screen_this_changes_the_shared_registry_not_the_last(
    String webapp,
    String gateway,
    String id,
  );

  /// Shared fleet webapp screen user interface: Set primary
  ///
  /// In en, this message translates to:
  /// **'Set primary'**
  String get release_core_fleet_webapp_screen_set_primary;

  /// Shared fleet webapp screen user interface: Serving profile
  ///
  /// In en, this message translates to:
  /// **'Serving profile'**
  String get release_core_fleet_webapp_screen_serving_profile;

  /// Shared fleet webapp screen user interface: Hermes Cloud
  ///
  /// In en, this message translates to:
  /// **'Hermes Cloud'**
  String get release_core_fleet_webapp_screen_hermes_cloud;

  /// Shared fleet webapp screen user interface: Discover signed-in agents
  ///
  /// In en, this message translates to:
  /// **'Discover signed-in agents'**
  String get release_core_fleet_webapp_screen_discover_signed_in_agents;

  /// Shared fleet webapp screen user interface: Organisation: {value1}
  ///
  /// In en, this message translates to:
  /// **'Organisation: {organisation}'**
  String release_core_fleet_webapp_screen_organisation(String organisation);

  /// Shared fleet webapp screen user interface: No agents available.
  ///
  /// In en, this message translates to:
  /// **'No agents available.'**
  String get release_core_fleet_webapp_screen_no_agents_available;

  /// Shared fleet webapp screen user interface: Existing Desktop Webapp
  ///
  /// In en, this message translates to:
  /// **'Existing Desktop Webapp'**
  String get release_core_fleet_webapp_screen_existing_desktop_webapp;

  /// Shared fleet webapp screen user interface: Check gateway and Web Access status
  ///
  /// In en, this message translates to:
  /// **'Check gateway and Web Access status'**
  String
  get release_core_fleet_webapp_screen_check_gateway_and_web_access_status;

  /// Shared fleet webapp screen user interface: These settings belong to the machine serving this Webapp. Publishing and restarts are not remote actions.
  ///
  /// In en, this message translates to:
  /// **'These settings belong to the machine serving this Webapp. Publishing and restarts are not remote actions.'**
  String
  get release_core_fleet_webapp_screen_these_settings_belong_to_the_machine_serving_this;

  /// Shared fleet webapp screen user interface: Read Webapp gateway registry
  ///
  /// In en, this message translates to:
  /// **'Read Webapp gateway registry'**
  String get release_core_fleet_webapp_screen_read_webapp_gateway_registry;

  /// Shared fleet webapp screen user interface: Last used
  ///
  /// In en, this message translates to:
  /// **'Last used'**
  String get release_core_fleet_webapp_screen_last_used;

  /// Shared fleet webapp screen user interface: Primary
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get release_core_fleet_webapp_screen_primary;

  /// Shared fleet webapp screen user interface: Set primary: {value1}
  ///
  /// In en, this message translates to:
  /// **'Set primary: {gateway}'**
  String release_core_fleet_webapp_screen_set_primary_2(String gateway);

  /// Shared fleet webapp screen user interface: Read shared display preferences
  ///
  /// In en, this message translates to:
  /// **'Read shared display preferences'**
  String get release_core_fleet_webapp_screen_read_shared_display_preferences;

  /// Shared fleet webapp screen user interface: Chat text direction on this Webapp and Desktop
  ///
  /// In en, this message translates to:
  /// **'Chat text direction on this Webapp and Desktop'**
  String
  get release_core_fleet_webapp_screen_chat_text_direction_on_this_webapp_and_desktop;

  /// Shared schedule desk screen user interface: Created {value1} on {value2}.
  ///
  /// In en, this message translates to:
  /// **'Created {job} on {profile}.'**
  String release_core_schedule_desk_screen_created_on(
    String job,
    String profile,
  );

  /// Shared schedule desk screen user interface: The list covers every profile on this gateway. Stop, pause, catch-up, delivery and blueprints are sent to the job's owning profile.
  ///
  /// In en, this message translates to:
  /// **'The list covers every profile on this gateway. Stop, pause, catch-up, delivery and blueprints are sent to the job\'s owning profile.'**
  String
  get release_core_schedule_desk_screen_the_list_covers_every_profile_on_this_gateway;

  /// Shared schedule desk screen user interface: A run is in progress
  ///
  /// In en, this message translates to:
  /// **'A run is in progress'**
  String get release_core_schedule_desk_screen_a_run_is_in_progress;

  /// Shared schedule desk screen user interface: No current run
  ///
  /// In en, this message translates to:
  /// **'No current run'**
  String get release_core_schedule_desk_screen_no_current_run;

  /// Shared schedule desk screen user interface: Stop requested for {value1}.
  ///
  /// In en, this message translates to:
  /// **'Stop requested for {job}.'**
  String release_core_schedule_desk_screen_stop_requested_for(String job);

  /// Shared schedule desk screen user interface: No run was in flight for {value1}.
  ///
  /// In en, this message translates to:
  /// **'No run was in flight for {job}.'**
  String release_core_schedule_desk_screen_no_run_was_in_flight_for(String job);

  /// Shared schedule desk screen user interface: Stop current run
  ///
  /// In en, this message translates to:
  /// **'Stop current run'**
  String get release_core_schedule_desk_screen_stop_current_run;

  /// Shared schedule desk screen user interface: Pause future runs
  ///
  /// In en, this message translates to:
  /// **'Pause future runs'**
  String get release_core_schedule_desk_screen_pause_future_runs;

  /// Shared schedule desk screen user interface: Resume future runs
  ///
  /// In en, this message translates to:
  /// **'Resume future runs'**
  String get release_core_schedule_desk_screen_resume_future_runs;

  /// Shared schedule desk screen user interface: Catch-up default
  ///
  /// In en, this message translates to:
  /// **'Catch-up default'**
  String get release_core_schedule_desk_screen_catch_up_default;

  /// Shared schedule desk screen user interface: Run one missed
  ///
  /// In en, this message translates to:
  /// **'Run one missed'**
  String get release_core_schedule_desk_screen_run_one_missed;

  /// Shared schedule desk screen user interface: Skip missed
  ///
  /// In en, this message translates to:
  /// **'Skip missed'**
  String get release_core_schedule_desk_screen_skip_missed;

  /// Shared schedule desk screen user interface: Blueprint recipes
  ///
  /// In en, this message translates to:
  /// **'Blueprint recipes'**
  String get release_core_schedule_desk_screen_blueprint_recipes;

  /// Shared schedule desk screen user interface: Profile for the new job
  ///
  /// In en, this message translates to:
  /// **'Profile for the new job'**
  String get release_core_schedule_desk_screen_profile_for_the_new_job;

  /// Shared schedule desk screen user interface: Create {value1}
  ///
  /// In en, this message translates to:
  /// **'Create {blueprint}'**
  String release_core_schedule_desk_screen_create(String blueprint);

  /// Shared schedule desk screen user interface: Loading delivery targets
  ///
  /// In en, this message translates to:
  /// **'Loading delivery targets'**
  String get release_core_schedule_desk_screen_loading_delivery_targets;

  /// Shared schedule desk screen user interface: {value1} (no home channel)
  ///
  /// In en, this message translates to:
  /// **'{target} (no home channel)'**
  String release_core_schedule_desk_screen_no_home_channel(String target);

  /// Shared memory graph screen user interface: Edit {value1}
  ///
  /// In en, this message translates to:
  /// **'Edit {label}'**
  String release_core_memory_graph_screen_edit(String label);

  /// Shared memory graph screen user interface: Content
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get release_core_memory_graph_screen_content;

  /// Shared memory graph screen user interface: Archive skill
  ///
  /// In en, this message translates to:
  /// **'Archive skill'**
  String get release_core_memory_graph_screen_archive_skill;

  /// Shared memory graph screen user interface: Delete memory
  ///
  /// In en, this message translates to:
  /// **'Delete memory'**
  String get release_core_memory_graph_screen_delete_memory;

  /// Shared memory graph screen user interface: Archive {value1} on {value2}? It can be restored on the host with the Curator.
  ///
  /// In en, this message translates to:
  /// **'Archive {label} on {profile}? It can be restored on the host with the Curator.'**
  String release_core_memory_graph_screen_archive_on_it_can_be_restored_on_the(
    String label,
    String profile,
  );

  /// Shared memory graph screen user interface: Delete {value1} from {value2}? This removes that memory.
  ///
  /// In en, this message translates to:
  /// **'Delete {label} from {profile}? This removes that memory.'**
  String release_core_memory_graph_screen_delete_from_this_removes_that_memory(
    String label,
    String profile,
  );

  /// Shared memory graph screen user interface: Filter
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get release_core_memory_graph_screen_filter;

  /// Shared memory graph screen user interface: Timeline
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get release_core_memory_graph_screen_timeline;

  /// Shared memory graph screen user interface: Play timeline
  ///
  /// In en, this message translates to:
  /// **'Play timeline'**
  String get release_core_memory_graph_screen_play_timeline;

  /// Shared memory graph screen user interface: Layout code
  ///
  /// In en, this message translates to:
  /// **'Layout code'**
  String get release_core_memory_graph_screen_layout_code;

  /// Shared memory graph screen user interface: External memory providers
  ///
  /// In en, this message translates to:
  /// **'External memory providers'**
  String get release_core_memory_graph_screen_external_memory_providers;

  /// Shared memory graph screen user interface: A value is stored. Leave blank to keep it.
  ///
  /// In en, this message translates to:
  /// **'A value is stored. Leave blank to keep it.'**
  String
  get release_core_memory_graph_screen_a_value_is_stored_leave_blank_to_keep;

  /// Shared memory graph screen user interface: Save provider
  ///
  /// In en, this message translates to:
  /// **'Save provider'**
  String get release_core_memory_graph_screen_save_provider;

  /// Shared workspace profiles screen user interface: Applies to: {value1}
  ///
  /// In en, this message translates to:
  /// **'Applies to: {profile}'**
  String release_core_workspace_profiles_screen_applies_to(String profile);

  /// Shared workspace profiles screen user interface: Choose another profile
  ///
  /// In en, this message translates to:
  /// **'Choose another profile'**
  String get release_core_workspace_profiles_screen_choose_another_profile;

  /// Shared workspace profiles screen user interface: Could not verify the selected profile on this gateway.
  ///
  /// In en, this message translates to:
  /// **'Could not verify the selected profile on this gateway.'**
  String
  get release_core_workspace_profiles_screen_could_not_verify_the_selected_profile_on_this;

  /// Shared workspace profiles screen user interface: Create profile
  ///
  /// In en, this message translates to:
  /// **'Create profile'**
  String get release_core_workspace_profiles_screen_create_profile;

  /// Shared workspace profiles screen user interface: New profile ID
  ///
  /// In en, this message translates to:
  /// **'New profile ID'**
  String get release_core_workspace_profiles_screen_new_profile_id;

  /// Shared assets screen user interface: Links
  ///
  /// In en, this message translates to:
  /// **'Links'**
  String get release_core_assets_screen_links;

  /// Shared workspace picker user interface: No matching items.
  ///
  /// In en, this message translates to:
  /// **'No matching items.'**
  String get release_core_workspace_picker_no_matching_items;

  /// Shared workspace picker user interface: Save layout
  ///
  /// In en, this message translates to:
  /// **'Save layout'**
  String get release_core_workspace_picker_save_layout;

  /// Shared workspace picker user interface: Layout name
  ///
  /// In en, this message translates to:
  /// **'Layout name'**
  String get release_core_workspace_picker_layout_name;

  /// Shared workspace popout user interface: This chat already has a pop-out window.
  ///
  /// In en, this message translates to:
  /// **'This chat already has a pop-out window.'**
  String
  get release_core_workspace_popout_this_chat_already_has_a_pop_out_window;

  /// Shared workspace popout user interface: Could not open this saved chat. Check the connection and try again.
  ///
  /// In en, this message translates to:
  /// **'Could not open this saved chat. Check the connection and try again.'**
  String
  get release_core_workspace_popout_could_not_open_this_saved_chat_check_the;

  /// Shared popout bootstrap user interface: Use the main window to change your connection.
  ///
  /// In en, this message translates to:
  /// **'Use the main window to change your connection.'**
  String
  get release_core_popout_bootstrap_use_the_main_window_to_change_your_connection;

  /// Guarded file-save refusal; retain the draft.
  ///
  /// In en, this message translates to:
  /// **'This file can\'t be saved by the gateway'**
  String get release_core_guarded_save_refused;

  /// Host does not support safe guarded file writes.
  ///
  /// In en, this message translates to:
  /// **'Guarded saving isn\'t available on this gateway'**
  String get release_core_guarded_save_unavailable;

  /// Number of files changed in the current turn.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 file changed this turn} other{{count} files changed this turn}}'**
  String release_core_git_files_changed(int count);

  /// Number of unsafe Git entries withheld from display.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Git entry was left out because it was not safe to show.} other{{count} Git entries were left out because they were not safe to show.}}'**
  String release_core_git_entries_omitted(int count);

  /// Git file state for an entry in the index.
  ///
  /// In en, this message translates to:
  /// **'Staged'**
  String get release_core_git_staged;

  /// Chat list sort order.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get release_core_session_sort_recent;

  /// Chat list sort order.
  ///
  /// In en, this message translates to:
  /// **'Newest created'**
  String get release_core_session_sort_created;

  /// Chat list sort order.
  ///
  /// In en, this message translates to:
  /// **'Running first'**
  String get release_core_session_sort_status;

  /// Chat list sort order.
  ///
  /// In en, this message translates to:
  /// **'Most tokens'**
  String get release_core_session_sort_tokens;

  /// Chat list sort order.
  ///
  /// In en, this message translates to:
  /// **'Highest cost'**
  String get release_core_session_sort_cost;

  /// Chat list grouping mode.
  ///
  /// In en, this message translates to:
  /// **'Default grouping'**
  String get release_core_session_group_standard;

  /// Chat list grouping mode.
  ///
  /// In en, this message translates to:
  /// **'Group by status'**
  String get release_core_session_group_status;

  /// Chat list grouping mode.
  ///
  /// In en, this message translates to:
  /// **'Group by project'**
  String get release_core_session_group_project;

  /// Token count in the optional model and usage summary.
  ///
  /// In en, this message translates to:
  /// **'{count} tokens'**
  String release_core_session_tokens(int count);

  /// Search mode served by the gateway.
  ///
  /// In en, this message translates to:
  /// **'{mode} (gateway)'**
  String release_core_search_gateway_mode(String mode);

  /// Search mode menu tooltip.
  ///
  /// In en, this message translates to:
  /// **'{label}: {mode}'**
  String release_core_search_mode_tooltip(String label, String mode);

  /// Warning that a recovered image copy starts a new turn.
  ///
  /// In en, this message translates to:
  /// **'Sending creates a new turn'**
  String get release_core_image_recovery_new_turn;

  /// Recovered image draft image count and creation date.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 image · {date}} other{{count} images · {date}}}'**
  String release_core_image_recovery_metadata(int count, String date);

  /// Gateway repository scanning policy state.
  ///
  /// In en, this message translates to:
  /// **'Scanning: {state}'**
  String release_core_discovery_scanning(String state);

  /// State of the gateway repository scanning policy.
  ///
  /// In en, this message translates to:
  /// **'enabled'**
  String get release_core_discovery_enabled;

  /// State of the gateway repository scanning policy.
  ///
  /// In en, this message translates to:
  /// **'disabled'**
  String get release_core_discovery_disabled;

  /// No paths are configured in the gateway repository scan policy.
  ///
  /// In en, this message translates to:
  /// **'none'**
  String get release_core_discovery_none;

  /// Newline-separated server paths scanned for repositories.
  ///
  /// In en, this message translates to:
  /// **'Scan roots: {paths}'**
  String release_core_discovery_roots(String paths);

  /// Newline-separated server subtrees omitted from scans.
  ///
  /// In en, this message translates to:
  /// **'Excluded subtrees: {paths}'**
  String release_core_discovery_excluded(String paths);

  /// Repository root and number of its sessions.
  ///
  /// In en, this message translates to:
  /// **'{path}\nSessions: {count}'**
  String release_core_discovery_repository_sessions(String path, int count);

  /// Projects compatibility notice for a host without server-side projects.
  ///
  /// In en, this message translates to:
  /// **'This Hermes gateway is older than server-side projects, so chats stay grouped on this device only. Update Hermes to share the same projects across your devices.'**
  String get release_core_projects_local_only;

  /// A discovered Cloud agent does not have an address yet.
  ///
  /// In en, this message translates to:
  /// **'No gateway address yet'**
  String get release_core_fleet_no_address;

  /// Gateway version and web-access diagnostic state.
  ///
  /// In en, this message translates to:
  /// **'Gateway {version} · {access}'**
  String release_core_fleet_diagnostics(String version, String access);

  /// Origin of a built-in schedule blueprint.
  ///
  /// In en, this message translates to:
  /// **'built-in'**
  String get release_core_schedule_builtin;

  /// Gateway default profile used in the memory graph header.
  ///
  /// In en, this message translates to:
  /// **'gateway'**
  String get release_core_memory_gateway_profile;

  /// Bound memory graph owner and explanation of non-sensitive layout sharing.
  ///
  /// In en, this message translates to:
  /// **'Profile {profile} on {gateway}. The share code stores zoom, time and filters only.'**
  String release_core_memory_profile_summary(String profile, String gateway);

  /// Memory layer storage sizes and selected provider.
  ///
  /// In en, this message translates to:
  /// **'Built-in memory {memoryBytes} bytes, user {userBytes} bytes. Active provider {provider}.'**
  String release_core_memory_layers_summary(
    int memoryBytes,
    int userBytes,
    String provider,
  );

  /// Memory graph node kind filter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get release_core_memory_kind_all;

  /// Memory graph node kind filter.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get release_core_memory_kind_skill;

  /// Memory graph node kind filter.
  ///
  /// In en, this message translates to:
  /// **'Memory'**
  String get release_core_memory_kind_memory;

  /// Reason why a gateway workspace or queue operation could not be confirmed.
  ///
  /// In en, this message translates to:
  /// **'connection changed'**
  String get release_core_workspace_failure_stale;

  /// Reason why a gateway workspace or queue operation could not be confirmed.
  ///
  /// In en, this message translates to:
  /// **'no verified working directory'**
  String get release_core_workspace_failure_unbound;

  /// Reason why a gateway workspace or queue operation could not be confirmed.
  ///
  /// In en, this message translates to:
  /// **'permission denied'**
  String get release_core_workspace_failure_denied;

  /// Reason why a gateway workspace or queue operation could not be confirmed.
  ///
  /// In en, this message translates to:
  /// **'operation not allowed for this file'**
  String get release_core_workspace_failure_ineligible;

  /// Reason why a gateway workspace or queue operation could not be confirmed.
  ///
  /// In en, this message translates to:
  /// **'not supported by this gateway'**
  String get release_core_workspace_failure_unsupported;

  /// Reason why a gateway workspace or queue operation could not be confirmed.
  ///
  /// In en, this message translates to:
  /// **'remote state changed'**
  String get release_core_workspace_failure_mismatch;

  /// Reason why a gateway workspace or queue operation could not be confirmed.
  ///
  /// In en, this message translates to:
  /// **'invalid gateway response'**
  String get release_core_workspace_failure_invalid;

  /// Reason why a gateway workspace or queue operation could not be confirmed.
  ///
  /// In en, this message translates to:
  /// **'secure connection required'**
  String get release_core_workspace_failure_insecure;

  /// Reason why a gateway workspace or queue operation could not be confirmed.
  ///
  /// In en, this message translates to:
  /// **'gateway unavailable'**
  String get release_core_workspace_failure_unavailable;

  /// State of a prompt admitted to the server-owned gateway queue.
  ///
  /// In en, this message translates to:
  /// **'Queued'**
  String get release_core_queue_state_queued;

  /// State of a prompt admitted to the server-owned gateway queue.
  ///
  /// In en, this message translates to:
  /// **'Started'**
  String get release_core_queue_state_started;

  /// State of a prompt admitted to the server-owned gateway queue.
  ///
  /// In en, this message translates to:
  /// **'Unknown outcome'**
  String get release_core_queue_state_unknown;

  /// Fallback for a gateway state not understood by this client.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get release_core_unknown_state;

  /// Connection phase shown in the gateway fleet roster.
  ///
  /// In en, this message translates to:
  /// **'Offline'**
  String get release_core_fleet_state_idle;

  /// Connection phase shown in the gateway fleet roster.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get release_core_fleet_state_connected;

  /// Connection phase shown in the gateway fleet roster.
  ///
  /// In en, this message translates to:
  /// **'Reconnecting…'**
  String get release_core_fleet_state_reconnecting;

  /// Connection phase shown in the gateway fleet roster.
  ///
  /// In en, this message translates to:
  /// **'Signed out'**
  String get release_core_fleet_state_sessionExpired;

  /// Connection phase shown in the gateway fleet roster.
  ///
  /// In en, this message translates to:
  /// **'Connection failed'**
  String get release_core_fleet_state_failed;

  /// Workspace operation failed without a confirmed remote result.
  ///
  /// In en, this message translates to:
  /// **'Gateway operation could not be confirmed: {reason}.'**
  String release_core_workspace_operation_failed(String reason);

  /// Safe localized replacement for a parser or validation exception.
  ///
  /// In en, this message translates to:
  /// **'The data or input could not be verified. Review it and try again.'**
  String get release_core_workspace_invalid_data;

  /// Shared parallel workspace user interface: Layout changed in this window but could not be saved.
  ///
  /// In en, this message translates to:
  /// **'Layout changed in this window but could not be saved.'**
  String
  get release_core_parallel_workspace_layout_changed_in_this_window_but_could_not;

  /// Shared parallel workspace user interface: First pane
  ///
  /// In en, this message translates to:
  /// **'First pane'**
  String get release_core_parallel_workspace_first_pane;

  /// Shared parallel workspace user interface: Second pane
  ///
  /// In en, this message translates to:
  /// **'Second pane'**
  String get release_core_parallel_workspace_second_pane;

  /// Shared parallel workspace user interface: Unavailable page
  ///
  /// In en, this message translates to:
  /// **'Unavailable page'**
  String get release_core_parallel_workspace_unavailable_page;

  /// Shared parallel workspace user interface: Close a tab first (maximum {value1}).
  ///
  /// In en, this message translates to:
  /// **'Close a tab first (maximum {maximum}).'**
  String release_core_parallel_workspace_close_a_tab_first_maximum(
    String maximum,
  );

  /// Shared parallel workspace user interface: Dock beside current pane
  ///
  /// In en, this message translates to:
  /// **'Dock beside current pane'**
  String get release_core_parallel_workspace_dock_beside_current_pane;

  /// Shared parallel workspace user interface: Add chat
  ///
  /// In en, this message translates to:
  /// **'Add chat'**
  String get release_core_parallel_workspace_add_chat;

  /// Shared parallel workspace user interface: Action failed. Check the connection and try again.
  ///
  /// In en, this message translates to:
  /// **'Action failed. Check the connection and try again.'**
  String
  get release_core_parallel_workspace_action_failed_check_the_connection_and_try_again;

  /// Shared parallel workspace user interface: Close a tab before reopening another.
  ///
  /// In en, this message translates to:
  /// **'Close a tab before reopening another.'**
  String
  get release_core_parallel_workspace_close_a_tab_before_reopening_another;

  /// Shared parallel workspace user interface: Replace layout “{value1}”?
  ///
  /// In en, this message translates to:
  /// **'Replace layout “{name}”?'**
  String release_core_parallel_workspace_replace_layout(String name);

  /// Shared parallel workspace user interface: Layout limit reached. Replace an existing layout.
  ///
  /// In en, this message translates to:
  /// **'Layout limit reached. Replace an existing layout.'**
  String
  get release_core_parallel_workspace_layout_limit_reached_replace_an_existing_layout;

  /// Shared parallel workspace user interface: Restore layout
  ///
  /// In en, this message translates to:
  /// **'Restore layout'**
  String get release_core_parallel_workspace_restore_layout;

  /// Shared parallel workspace user interface: Workspace options
  ///
  /// In en, this message translates to:
  /// **'Workspace options'**
  String get release_core_parallel_workspace_workspace_options;

  /// Shared parallel workspace user interface: Dock another pane
  ///
  /// In en, this message translates to:
  /// **'Dock another pane'**
  String get release_core_parallel_workspace_dock_another_pane;

  /// Shared parallel workspace user interface: Swap panes
  ///
  /// In en, this message translates to:
  /// **'Swap panes'**
  String get release_core_parallel_workspace_swap_panes;

  /// Shared parallel workspace user interface: Undock second pane
  ///
  /// In en, this message translates to:
  /// **'Undock second pane'**
  String get release_core_parallel_workspace_undock_second_pane;

  /// Shared parallel workspace user interface: Arrange side by side
  ///
  /// In en, this message translates to:
  /// **'Arrange side by side'**
  String get release_core_parallel_workspace_arrange_side_by_side;

  /// Shared parallel workspace user interface: Arrange top to bottom
  ///
  /// In en, this message translates to:
  /// **'Arrange top to bottom'**
  String get release_core_parallel_workspace_arrange_top_to_bottom;

  /// Shared parallel workspace user interface: Change split size ({value1}%)
  ///
  /// In en, this message translates to:
  /// **'Change split size ({percent}%)'**
  String release_core_parallel_workspace_change_split_size(String percent);

  /// Shared parallel workspace user interface: Focus pane full screen
  ///
  /// In en, this message translates to:
  /// **'Focus pane full screen'**
  String get release_core_parallel_workspace_focus_pane_full_screen;

  /// Shared parallel workspace user interface: Open chat in new window
  ///
  /// In en, this message translates to:
  /// **'Open chat in new window'**
  String get release_core_parallel_workspace_open_chat_in_new_window;

  /// Shared parallel workspace user interface: Hide pane (keep running)
  ///
  /// In en, this message translates to:
  /// **'Hide pane (keep running)'**
  String get release_core_parallel_workspace_hide_pane_keep_running;

  /// Shared parallel workspace user interface: Previous tab
  ///
  /// In en, this message translates to:
  /// **'Previous tab'**
  String get release_core_parallel_workspace_previous_tab;

  /// Shared parallel workspace user interface: Next tab
  ///
  /// In en, this message translates to:
  /// **'Next tab'**
  String get release_core_parallel_workspace_next_tab;

  /// Shared parallel workspace user interface: Move tab left
  ///
  /// In en, this message translates to:
  /// **'Move tab left'**
  String get release_core_parallel_workspace_move_tab_left;

  /// Shared parallel workspace user interface: Move tab right
  ///
  /// In en, this message translates to:
  /// **'Move tab right'**
  String get release_core_parallel_workspace_move_tab_right;

  /// Shared parallel workspace user interface: Reload current tab
  ///
  /// In en, this message translates to:
  /// **'Reload current tab'**
  String get release_core_parallel_workspace_reload_current_tab;

  /// Shared parallel workspace user interface: Close tab
  ///
  /// In en, this message translates to:
  /// **'Close tab'**
  String get release_core_parallel_workspace_close_tab;

  /// Shared parallel workspace user interface: Close other tabs
  ///
  /// In en, this message translates to:
  /// **'Close other tabs'**
  String get release_core_parallel_workspace_close_other_tabs;

  /// Shared parallel workspace user interface: Close tabs to the right
  ///
  /// In en, this message translates to:
  /// **'Close tabs to the right'**
  String get release_core_parallel_workspace_close_tabs_to_the_right;

  /// Shared parallel workspace user interface: Close all tabs
  ///
  /// In en, this message translates to:
  /// **'Close all tabs'**
  String get release_core_parallel_workspace_close_all_tabs;

  /// Shared parallel workspace user interface: Reopen closed tab
  ///
  /// In en, this message translates to:
  /// **'Reopen closed tab'**
  String get release_core_parallel_workspace_reopen_closed_tab;

  /// Shared parallel workspace user interface: Save named layout
  ///
  /// In en, this message translates to:
  /// **'Save named layout'**
  String get release_core_parallel_workspace_save_named_layout;

  /// Shared parallel workspace user interface: Restore named layout
  ///
  /// In en, this message translates to:
  /// **'Restore named layout'**
  String get release_core_parallel_workspace_restore_named_layout;

  /// Shared parallel workspace user interface: Refresh chat list
  ///
  /// In en, this message translates to:
  /// **'Refresh chat list'**
  String get release_core_parallel_workspace_refresh_chat_list;

  /// Shared parallel workspace user interface: Workspace tools
  ///
  /// In en, this message translates to:
  /// **'Workspace tools'**
  String get release_core_parallel_workspace_workspace_tools;

  /// Shared parallel workspace user interface: Choose a chat for this pane
  ///
  /// In en, this message translates to:
  /// **'Choose a chat for this pane'**
  String get release_core_parallel_workspace_choose_a_chat_for_this_pane;

  /// Shared parallel workspace user interface: Choose chat for {value1}
  ///
  /// In en, this message translates to:
  /// **'Choose chat for {pane}'**
  String release_core_parallel_workspace_choose_chat_for(String pane);

  /// Shared parallel workspace user interface: Add a chat to start a workspace.
  ///
  /// In en, this message translates to:
  /// **'Add a chat to start a workspace.'**
  String get release_core_parallel_workspace_add_a_chat_to_start_a_workspace;

  /// Shared parallel workspace user interface: Select a tab to show its pane.
  ///
  /// In en, this message translates to:
  /// **'Select a tab to show its pane.'**
  String get release_core_parallel_workspace_select_a_tab_to_show_its_pane;

  /// Shared parallel workspace user interface: Parallel workspace
  ///
  /// In en, this message translates to:
  /// **'Parallel workspace'**
  String get release_core_parallel_workspace_parallel_workspace;

  /// Shared parallel workspace user interface: Show workspace
  ///
  /// In en, this message translates to:
  /// **'Show workspace'**
  String get release_core_parallel_workspace_show_workspace;

  /// Shared parallel workspace user interface: Could not load chats. Retry
  ///
  /// In en, this message translates to:
  /// **'Could not load chats. Retry'**
  String get release_core_parallel_workspace_could_not_load_chats_retry;

  /// Shared parallel workspace user interface: Close {value1}
  ///
  /// In en, this message translates to:
  /// **'Close {pane}'**
  String release_core_parallel_workspace_close(String pane);

  /// Shared parallel workspace user interface: Switch pane: {value1}
  ///
  /// In en, this message translates to:
  /// **'Switch pane: {pane}'**
  String release_core_parallel_workspace_switch_pane(String pane);

  /// Shared workspace registry user interface: Session ID copied.
  ///
  /// In en, this message translates to:
  /// **'Session ID copied.'**
  String get release_core_workspace_registry_session_id_copied;

  /// Shared workspace registry user interface: Chat details
  ///
  /// In en, this message translates to:
  /// **'Chat details'**
  String get release_core_workspace_registry_chat_details;

  /// Shared workspace registry user interface: Server default
  ///
  /// In en, this message translates to:
  /// **'Server default'**
  String get release_core_workspace_registry_server_default;

  /// Shared workspace registry user interface: Session ID
  ///
  /// In en, this message translates to:
  /// **'Session ID'**
  String get release_core_workspace_registry_session_id;

  /// Shared workspace registry user interface: Title
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get release_core_workspace_registry_title;

  /// Built-in parallel workspace page or action name.
  ///
  /// In en, this message translates to:
  /// **'Terminals'**
  String get release_core_workspace_label_terminals;

  /// Built-in parallel workspace page or action name.
  ///
  /// In en, this message translates to:
  /// **'Copy session ID'**
  String get release_core_workspace_label_copy_id;

  /// Built-in parallel workspace page or action name.
  ///
  /// In en, this message translates to:
  /// **'Contributions'**
  String get release_core_workspace_label_contributions;

  /// Reason workspace actions are disabled after the owner changes.
  ///
  /// In en, this message translates to:
  /// **'This workspace owner is no longer active.'**
  String get release_core_workspace_owner_inactive;

  /// Reason a workspace contribution requiring a session is disabled.
  ///
  /// In en, this message translates to:
  /// **'Select a chat first.'**
  String get release_core_workspace_select_chat;

  /// Unavailable chat pane in a retained workspace.
  ///
  /// In en, this message translates to:
  /// **'This chat is not available for this connection.'**
  String get release_core_workspace_chat_unavailable;

  /// Unavailable contribution page in a retained workspace.
  ///
  /// In en, this message translates to:
  /// **'This page is not available for this connection.'**
  String get release_core_workspace_page_unavailable;

  /// Number of unsent prompts held on the client.
  ///
  /// In en, this message translates to:
  /// **'{count} queued'**
  String release_core_client_queue_count(int count);

  /// Number of unsent client-held prompts while local draining is parked.
  ///
  /// In en, this message translates to:
  /// **'{count} queued — paused'**
  String release_core_client_queue_paused_count(int count);

  /// A long Git diff preview has been shortened on this device.
  ///
  /// In en, this message translates to:
  /// **'{diff}\n… truncated'**
  String release_core_git_diff_truncated(String diff);

  /// Search model picker cannot open because the host returned no selectable models.
  ///
  /// In en, this message translates to:
  /// **'Hermes returned no configured selectable models.'**
  String get release_core_search_no_models;

  /// A chat archive mutation cannot start for this row or owner.
  ///
  /// In en, this message translates to:
  /// **'Chat archive action is unavailable.'**
  String get release_core_chat_archive_unavailable;

  /// A server chat pin update did not match the requested state.
  ///
  /// In en, this message translates to:
  /// **'Pin state was not confirmed.'**
  String get release_core_chat_pin_unconfirmed;

  /// A server chat archive update did not match the requested state.
  ///
  /// In en, this message translates to:
  /// **'Archive state was not confirmed.'**
  String get release_core_chat_archive_unconfirmed;

  /// Archived conversation data has not been verified.
  ///
  /// In en, this message translates to:
  /// **'Archived history unavailable'**
  String get release_core_chat_archive_history_unavailable;

  /// Quick Chat history has not been verified.
  ///
  /// In en, this message translates to:
  /// **'Quick Chat history unavailable'**
  String get release_core_quick_chat_history_unavailable;

  /// Project ownership cannot be verified for the conversation browser.
  ///
  /// In en, this message translates to:
  /// **'Project ownership unavailable'**
  String get release_core_chat_project_ownership_unavailable;

  /// Conversation group whose server project ownership is not known.
  ///
  /// In en, this message translates to:
  /// **'Unknown project'**
  String get release_core_chat_unknown_project;

  /// Search failed; local matches remain visible.
  ///
  /// In en, this message translates to:
  /// **'Message search unavailable. Showing local matches.'**
  String get release_core_chat_local_search_fallback;

  /// An eligible remote gateway update and its version.
  ///
  /// In en, this message translates to:
  /// **'Eligible · {version}'**
  String release_core_fleet_update_eligible(String version);

  /// Remote gateway fleet update state or receipt outcome; do not imply an unverified update succeeded.
  ///
  /// In en, this message translates to:
  /// **'Skipped: same installation'**
  String get release_core_fleet_update_state_1;

  /// Remote gateway fleet update state or receipt outcome; do not imply an unverified update succeeded.
  ///
  /// In en, this message translates to:
  /// **'Not checked'**
  String get release_core_fleet_update_state_2;

  /// Remote gateway fleet update state or receipt outcome; do not imply an unverified update succeeded.
  ///
  /// In en, this message translates to:
  /// **'Skipped: Cloud-managed'**
  String get release_core_fleet_update_state_3;

  /// Remote gateway fleet update state or receipt outcome; do not imply an unverified update succeeded.
  ///
  /// In en, this message translates to:
  /// **'Skipped: not enrolled as a direct gateway'**
  String get release_core_fleet_update_state_4;

  /// Remote gateway fleet update state or receipt outcome; do not imply an unverified update succeeded.
  ///
  /// In en, this message translates to:
  /// **'Skipped: disconnected or busy'**
  String get release_core_fleet_update_state_5;

  /// Remote gateway fleet update state or receipt outcome; do not imply an unverified update succeeded.
  ///
  /// In en, this message translates to:
  /// **'No applicable update'**
  String get release_core_fleet_update_state_6;

  /// Remote gateway fleet update state or receipt outcome; do not imply an unverified update succeeded.
  ///
  /// In en, this message translates to:
  /// **'Could not verify eligibility'**
  String get release_core_fleet_update_state_7;

  /// Remote gateway fleet update state or receipt outcome; do not imply an unverified update succeeded.
  ///
  /// In en, this message translates to:
  /// **'Skipped: stale, busy or already requested'**
  String get release_core_fleet_update_state_8;

  /// Remote gateway fleet update state or receipt outcome; do not imply an unverified update succeeded.
  ///
  /// In en, this message translates to:
  /// **'Requesting'**
  String get release_core_fleet_update_state_9;

  /// Remote gateway fleet update state or receipt outcome; do not imply an unverified update succeeded.
  ///
  /// In en, this message translates to:
  /// **'Accepted; receipt unavailable'**
  String get release_core_fleet_update_state_10;

  /// Remote gateway fleet update state or receipt outcome; do not imply an unverified update succeeded.
  ///
  /// In en, this message translates to:
  /// **'Accepted; awaiting receipt'**
  String get release_core_fleet_update_state_11;

  /// Remote gateway fleet update state or receipt outcome; do not imply an unverified update succeeded.
  ///
  /// In en, this message translates to:
  /// **'Skipped: a chat on this installation is running'**
  String get release_core_fleet_update_state_12;

  /// Remote gateway fleet update state or receipt outcome; do not imply an unverified update succeeded.
  ///
  /// In en, this message translates to:
  /// **'Not confirmed; do not resend automatically'**
  String get release_core_fleet_update_state_13;

  /// Remote gateway fleet update state or receipt outcome; do not imply an unverified update succeeded.
  ///
  /// In en, this message translates to:
  /// **'Reconnect to check receipt'**
  String get release_core_fleet_update_state_14;

  /// Remote gateway fleet update state or receipt outcome; do not imply an unverified update succeeded.
  ///
  /// In en, this message translates to:
  /// **'Receipt unavailable'**
  String get release_core_fleet_update_state_15;

  /// Remote gateway fleet update state or receipt outcome; do not imply an unverified update succeeded.
  ///
  /// In en, this message translates to:
  /// **'Awaiting matching receipt'**
  String get release_core_fleet_update_state_16;

  /// Remote gateway fleet update state or receipt outcome; do not imply an unverified update succeeded.
  ///
  /// In en, this message translates to:
  /// **'Updated; follow-up required'**
  String get release_core_fleet_update_state_17;

  /// Remote gateway fleet update state or receipt outcome; do not imply an unverified update succeeded.
  ///
  /// In en, this message translates to:
  /// **'Partially updated'**
  String get release_core_fleet_update_state_19;

  /// Remote gateway fleet update state or receipt outcome; do not imply an unverified update succeeded.
  ///
  /// In en, this message translates to:
  /// **'Update failed'**
  String get release_core_fleet_update_state_20;

  /// Remote gateway fleet update state or receipt outcome; do not imply an unverified update succeeded.
  ///
  /// In en, this message translates to:
  /// **'Not confirmed'**
  String get release_core_fleet_update_state_21;

  /// Known server-reported Cloud agent status in the gateway fleet list.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get release_core_cloud_status_ready;

  /// Known server-reported Cloud agent status in the gateway fleet list.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get release_core_cloud_status_online;

  /// Known server-reported Cloud agent status in the gateway fleet list.
  ///
  /// In en, this message translates to:
  /// **'Stopped'**
  String get release_core_cloud_status_stopped;

  /// Known server-reported Cloud agent status in the gateway fleet list.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get release_core_cloud_status_error;

  /// NextGen More menu subtitle for reviewed reply-card contributions.
  ///
  /// In en, this message translates to:
  /// **'Reviewed reply cards for this connection'**
  String get ng_release_more_contributions_subtitle;

  /// NextGen More menu entry for the fleet of gateways.
  ///
  /// In en, this message translates to:
  /// **'Gateway fleet'**
  String get ng_release_more_gateway_fleet;

  /// NextGen More menu entry for the memory graph.
  ///
  /// In en, this message translates to:
  /// **'Memory graph'**
  String get ng_release_more_memory_graph;

  /// NextGen More menu subtitle for memory history and providers.
  ///
  /// In en, this message translates to:
  /// **'Timeline, edits and memory providers'**
  String get ng_release_more_memory_graph_subtitle;

  /// NextGen More menu subtitle for capability administration.
  ///
  /// In en, this message translates to:
  /// **'Install and govern skills, plugins, connectors and tool backends'**
  String get ng_release_more_capabilities_subtitle;

  /// NextGen More menu entry for browser credentials and saved details.
  ///
  /// In en, this message translates to:
  /// **'Browser vault'**
  String get ng_release_more_browser_vault;

  /// NextGen More menu subtitle for browser vault administration.
  ///
  /// In en, this message translates to:
  /// **'Site logins, addresses, cards and credential sources'**
  String get ng_release_more_browser_vault_subtitle;

  /// NextGen More menu entry for agent policy administration.
  ///
  /// In en, this message translates to:
  /// **'Agent policy'**
  String get ng_release_more_agent_policy;

  /// NextGen More menu subtitle for agent policies. Navigation copy only; does not grant consent.
  ///
  /// In en, this message translates to:
  /// **'Approvals, checkpoints, browser access and shared metrics'**
  String get ng_release_more_agent_policy_subtitle;

  /// NextGen More menu entry for the cross-profile schedule desk.
  ///
  /// In en, this message translates to:
  /// **'Schedules'**
  String get ng_release_more_schedules;

  /// NextGen More menu subtitle describing schedule management.
  ///
  /// In en, this message translates to:
  /// **'All profiles, blueprints, catch-up and stop'**
  String get ng_release_more_schedules_subtitle;

  /// NextGen More menu subtitle for host operations.
  ///
  /// In en, this message translates to:
  /// **'Remote logs, health, maintenance and update'**
  String get ng_release_more_host_subtitle;

  /// NextGen More menu entry for model providers and routing.
  ///
  /// In en, this message translates to:
  /// **'Providers and routes'**
  String get ng_release_more_providers_routes;

  /// NextGen More menu subtitle for provider configuration.
  ///
  /// In en, this message translates to:
  /// **'Keys, endpoints, delegation and mixtures'**
  String get ng_release_more_providers_routes_subtitle;

  /// NextGen More menu entry for billing and plans.
  ///
  /// In en, this message translates to:
  /// **'Credits and plans'**
  String get ng_release_more_credits_plans;

  /// NextGen More menu billing subtitle. Describes existing account-gated, consented billing; does not authorize it.
  ///
  /// In en, this message translates to:
  /// **'Consented Nous billing when the account allows it'**
  String get ng_release_more_credits_plans_subtitle;

  /// Separator between password and browser sign-in options in NextGen.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get ng_release_sign_in_or;

  /// NextGen unsupported-provider notice with an already-localized explanation as its verbatim prefix.
  ///
  /// In en, this message translates to:
  /// **'{message} You can still sign in with a deployment session token on the next step.'**
  String ng_release_deployment_sign_in_hint(String message);

  /// NextGen sidebar fallback when remote message search fails; locally cached matches remain visible.
  ///
  /// In en, this message translates to:
  /// **'Message search unavailable. Showing local matches.'**
  String get ng_release_message_search_unavailable;

  /// NextGen Insights reporting-period selector. Currently offers 7, 30 and 90 days.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, one{{days} day} other{{days} days}}'**
  String ng_release_insights_days(int days);

  /// Fallback person name in NextGen’s “Signed in as {name}.” connection check when the response has no user object.
  ///
  /// In en, this message translates to:
  /// **'you'**
  String get ng_release_signed_in_you;

  /// NextGen error when a queued, unsent prompt was removed before its edit could be saved.
  ///
  /// In en, this message translates to:
  /// **'That unsent prompt is no longer in the queue.'**
  String get release_chat_unsent_prompt_gone;

  /// NextGen attachment error when the gateway does not confirm attaching the selected file.
  ///
  /// In en, this message translates to:
  /// **'The gateway did not attach {name}.'**
  String ng_release_attachment_not_attached(String name);

  /// NextGen error when an action needs a live gateway connection.
  ///
  /// In en, this message translates to:
  /// **'Not connected to the gateway yet.'**
  String get ng_release_gateway_not_connected;

  /// NextGen timeout fallback when no more specific gateway connection reason is available.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the gateway.'**
  String get ng_release_gateway_unreachable;

  /// NextGen project-operation error when the selected connection or profile changed.
  ///
  /// In en, this message translates to:
  /// **'Projects scope is no longer selected'**
  String get ng_release_projects_scope_changed;

  /// NextGen model catalogue error when the gateway omits its provider list.
  ///
  /// In en, this message translates to:
  /// **'Missing providers'**
  String get ng_release_missing_providers;

  /// NextGen auxiliary-model catalogue error when the gateway omits its helper-task list.
  ///
  /// In en, this message translates to:
  /// **'Missing tasks'**
  String get ng_release_missing_tasks;

  /// Compact NextGen sidebar chat age in minutes. Keep it short; no “ago” suffix.
  ///
  /// In en, this message translates to:
  /// **'{count}m'**
  String ng_release_age_minutes(int count);

  /// Compact NextGen sidebar chat age in hours. Keep it short; no “ago” suffix.
  ///
  /// In en, this message translates to:
  /// **'{count}h'**
  String ng_release_age_hours(int count);

  /// Compact NextGen sidebar chat age in days. Keep it short; no “ago” suffix.
  ///
  /// In en, this message translates to:
  /// **'{count}d'**
  String ng_release_age_days(int count);

  /// Compact NextGen sidebar chat age in whole weeks. Keep it short; no “ago” suffix.
  ///
  /// In en, this message translates to:
  /// **'{count}w'**
  String ng_release_age_weeks(int count);

  /// Compact NextGen sidebar chat age in whole years. Keep it short; no “ago” suffix.
  ///
  /// In en, this message translates to:
  /// **'{count}y'**
  String ng_release_age_years(int count);

  /// Compact NextGen number in billions. The count is already scaled and formatted; translate the magnitude suffix.
  ///
  /// In en, this message translates to:
  /// **'{count}B'**
  String ng_release_compact_billions(String count);

  /// Compact NextGen number in millions. The count is already scaled and formatted; translate the magnitude suffix.
  ///
  /// In en, this message translates to:
  /// **'{count}M'**
  String ng_release_compact_millions(String count);

  /// Compact NextGen number in thousands. The count is already scaled and formatted; translate the magnitude suffix.
  ///
  /// In en, this message translates to:
  /// **'{count}k'**
  String ng_release_compact_thousands(String count);

  /// Compact NextGen model context/output size in thousands of tokens. Count is already scaled; preserve the uppercase K in English.
  ///
  /// In en, this message translates to:
  /// **'{count}K'**
  String ng_release_token_thousands(String count);

  /// Compact elapsed time for a NextGen subagent, with whole minutes and remaining seconds.
  ///
  /// In en, this message translates to:
  /// **'{minutes}m {seconds}s'**
  String ng_release_elapsed_minutes_seconds(int minutes, int seconds);

  /// Compact elapsed time for a NextGen subagent that has run for less than one minute.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String ng_release_elapsed_seconds(int seconds);

  /// NextGen recent-notification diagnostic explaining why a foreground reply did not notify.
  ///
  /// In en, this message translates to:
  /// **'Ares was on screen'**
  String get ng_release_notification_foreground;

  /// NextGen recent-notification diagnostic explaining why an interrupted turn did not notify.
  ///
  /// In en, this message translates to:
  /// **'the turn was stopped'**
  String get ng_release_notification_stopped;

  /// NextGen More menu entry for opening several chats in one workspace.
  ///
  /// In en, this message translates to:
  /// **'Parallel workspace'**
  String get ng_release_more_parallel_workspace;

  /// NextGen More menu subtitle for the parallel chat workspace.
  ///
  /// In en, this message translates to:
  /// **'Open multiple chats in tabs or side by side.'**
  String get ng_release_more_parallel_workspace_subtitle;

  /// Fallback model name in the chat model picker's profile-default summary.
  ///
  /// In en, this message translates to:
  /// **'unknown'**
  String get release_chat_unknown_model;

  /// Chat model picker summary when the profile does not report a provider.
  ///
  /// In en, this message translates to:
  /// **'Profile default: {model}'**
  String release_chat_profile_default(String model);

  /// Chat model picker summary showing the profile's default model and provider.
  ///
  /// In en, this message translates to:
  /// **'Profile default: {model} • {provider}'**
  String release_chat_profile_default_provider(String model, String provider);

  /// Chat model picker notice requiring an explicit provider for an ambiguous model.
  ///
  /// In en, this message translates to:
  /// **'This model is available from multiple providers. Choose a provider to continue.'**
  String get release_chat_choose_provider;

  /// Classic chat slash-command catalogue error when there is no Desktop gateway.
  ///
  /// In en, this message translates to:
  /// **'Slash commands need the Desktop gateway'**
  String get release_chat_slash_needs_gateway;

  /// Classic chat activity status during reconciliation; the prompt is not sent again.
  ///
  /// In en, this message translates to:
  /// **'Recovering without resending'**
  String get release_chat_recovering_without_resending;

  /// Spoken live-voice failure notice in both chat layouts when the delegated request cannot reach Hermes.
  ///
  /// In en, this message translates to:
  /// **'Sorry, I could not reach Hermes for that request.'**
  String get release_chat_live_request_unreachable;

  /// Live-voice progress announcement in both chat layouts. The tool is a server-supplied tool name or status.
  ///
  /// In en, this message translates to:
  /// **'Hermes is working: {tool}. Not done yet.'**
  String release_chat_live_working(String tool);

  /// Live-voice announcement in both chat layouts when the completed request has no spoken reply.
  ///
  /// In en, this message translates to:
  /// **'Hermes finished that request without a spoken result.'**
  String get release_chat_live_finished_without_spoken_result;

  /// Classic chat voice-setup error detail when the selected reply language cannot be configured.
  ///
  /// In en, this message translates to:
  /// **'Selected reply language is unavailable'**
  String get release_chat_reply_language_unavailable;

  /// Classic chat voice-setup error detail when the selected reply voice cannot be configured.
  ///
  /// In en, this message translates to:
  /// **'Selected reply voice is unavailable'**
  String get release_chat_reply_voice_unavailable;

  /// Classic chat voice-setup error detail when rate, volume or pitch configuration fails.
  ///
  /// In en, this message translates to:
  /// **'Reply voice configuration is unavailable'**
  String get release_chat_reply_voice_configuration_unavailable;

  /// Privacy-preserving native approval notification body; action details remain inside the authenticated chat.
  ///
  /// In en, this message translates to:
  /// **'Open the chat to review the requested action.'**
  String get release_chat_notification_review_action;

  /// Privacy-preserving native question or secret-input notification body; prompt content remains inside the chat.
  ///
  /// In en, this message translates to:
  /// **'Open the chat to respond.'**
  String get release_chat_notification_respond;

  /// Classic single-session window notice when a new-chat slash command needs the main window.
  ///
  /// In en, this message translates to:
  /// **'Start a new chat in the main window.'**
  String get release_chat_start_new_main_window;

  /// Classic composer RPC error detail when no Desktop gateway is available.
  ///
  /// In en, this message translates to:
  /// **'No Desktop gateway'**
  String get release_chat_no_desktop_gateway;

  /// Classic chat upload error when the attachment's owning response generation has been cancelled.
  ///
  /// In en, this message translates to:
  /// **'Attachment preparation was cancelled.'**
  String get release_chat_attachment_preparation_cancelled;

  /// Classic approval refusal detail when the original approval authority is no longer current.
  ///
  /// In en, this message translates to:
  /// **'Approval authority was revoked.'**
  String get release_chat_approval_authority_revoked;

  /// Classic approval, question, sudo or secret response error when its Desktop gateway session has disconnected.
  ///
  /// In en, this message translates to:
  /// **'The Desktop gateway session is no longer connected'**
  String get release_chat_gateway_session_disconnected;

  /// Classic chat notice after requesting interruption without yet observing terminal settlement.
  ///
  /// In en, this message translates to:
  /// **'Stop requested. Waiting for Hermes to finish.'**
  String get release_chat_stop_requested;

  /// Classic chat interruption failure notice, preserving the reported error detail.
  ///
  /// In en, this message translates to:
  /// **'Could not request stop: {error}'**
  String release_chat_stop_request_failed(String error);

  /// Classic chat refusal detail inside the existing send-failed notice for a client-held prompt.
  ///
  /// In en, this message translates to:
  /// **'The queued prompt was not sent.'**
  String get release_chat_queued_prompt_not_sent;

  /// Classic chat stop notice when the running turn is unreachable; reconnection does not resend the prompt.
  ///
  /// In en, this message translates to:
  /// **'The running turn could not be reached. Reconnecting without resending.'**
  String get release_chat_running_turn_unreachable;

  /// Browser-preview attachment refusal in both chat layouts while the composer is busy.
  ///
  /// In en, this message translates to:
  /// **'Wait for the composer to become available.'**
  String get release_chat_wait_for_composer;

  /// Toolbar tooltip in both chat layouts opening search in the currently loaded transcript.
  ///
  /// In en, this message translates to:
  /// **'Find in transcript'**
  String get release_chat_find_in_transcript;

  /// Toolbar tooltip and compact chat-tools menu entry opening the browser preview in both chat layouts.
  ///
  /// In en, this message translates to:
  /// **'Open browser preview'**
  String get release_chat_open_browser_preview;

  /// Compact toolbar overflow-menu tooltip in both chat layouts.
  ///
  /// In en, this message translates to:
  /// **'More chat tools'**
  String get release_chat_more_tools;

  /// Classic composer tooltip for holding a prompt locally until the running turn finishes.
  ///
  /// In en, this message translates to:
  /// **'Queue until this turn finishes'**
  String get release_chat_queue_until_finished;

  /// Classic composer formatting-button tooltip and accessibility label for bold Markdown.
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get release_chat_format_bold;

  /// Classic composer formatting-button tooltip and accessibility label for italic Markdown.
  ///
  /// In en, this message translates to:
  /// **'Italic'**
  String get release_chat_format_italic;

  /// NextGen refusal when the gateway queue lacks an attached stored chat or the draft has attachments.
  ///
  /// In en, this message translates to:
  /// **'The gateway queue needs an attached chat and a text-only prompt.'**
  String get ng_release_chat_gateway_queue_requirements;

  /// NextGen new-chat command notice in a pane with no new-chat callback.
  ///
  /// In en, this message translates to:
  /// **'Start a new chat from the main chat screen.'**
  String get ng_release_chat_start_new_main_screen;

  /// NextGen fallback item name inside the could-not-prepare-that-file message after a captured image cannot be staged.
  ///
  /// In en, this message translates to:
  /// **'image'**
  String get ng_release_chat_image;

  /// NextGen tool elapsed duration, with seconds already formatted to one decimal place.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String ng_release_chat_tool_seconds(String seconds);

  /// Preview notice after its owning chat changes.
  ///
  /// In en, this message translates to:
  /// **'Chat changed. Reconnect the preview to continue.'**
  String get release_preview_chat_changed;

  /// Preview progress while verifying the owning chat.
  ///
  /// In en, this message translates to:
  /// **'Authenticating chat…'**
  String get release_preview_authenticating_chat;

  /// Preview refusal with an already localized workspace failure reason.
  ///
  /// In en, this message translates to:
  /// **'Preview unavailable: {reason}'**
  String release_preview_unavailable_reason(String reason);

  /// Safe fallback for an unexpected preview operation failure.
  ///
  /// In en, this message translates to:
  /// **'Preview operation failed.'**
  String get release_preview_operation_failed;

  /// Preview evidence was staged in the composer, not submitted.
  ///
  /// In en, this message translates to:
  /// **'Added to draft. Nothing sent.'**
  String get release_preview_added_to_draft;

  /// Confirmation before loading a new preview origin.
  ///
  /// In en, this message translates to:
  /// **'Open this site?'**
  String get release_preview_open_site_title;

  /// Preview origin approval explanation. The origin is a URL origin, not translated.
  ///
  /// In en, this message translates to:
  /// **'{origin}\n\nReader mode loads only this document. It does not share cookies, sign-in details or the page with Hermes.'**
  String release_preview_open_site_body(String origin);

  /// Confirm loading the approved preview origin.
  ///
  /// In en, this message translates to:
  /// **'Open site'**
  String get release_preview_open_site;

  /// Confirmation before navigation drops annotation pins not yet staged.
  ///
  /// In en, this message translates to:
  /// **'Discard unstaged pins?'**
  String get release_preview_discard_pins_title;

  /// Cancel navigation and retain the preview annotation pins.
  ///
  /// In en, this message translates to:
  /// **'Keep pins'**
  String get release_preview_keep_pins;

  /// Consent title before enabling reader access for the owning chat.
  ///
  /// In en, this message translates to:
  /// **'Share this page with this chat?'**
  String get release_preview_share_page_title;

  /// Exact reader-sharing scope disclosure. Keep navigation revocation and form/credential exclusions explicit.
  ///
  /// In en, this message translates to:
  /// **'Hermes can read the displayed text and element list from {origin}, and scroll this pane. Navigation ends sharing. Forms and credentials are not shared.'**
  String release_preview_share_page_body(String origin);

  /// Confirm reader sharing with the current chat.
  ///
  /// In en, this message translates to:
  /// **'Share page'**
  String get release_preview_share_page;

  /// Title of the annotation comment dialog, with the pin number.
  ///
  /// In en, this message translates to:
  /// **'Comment #{number}'**
  String release_preview_comment_number(int number);

  /// Label of the preview annotation comment text field.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get release_preview_note;

  /// Save the current preview annotation pin locally.
  ///
  /// In en, this message translates to:
  /// **'Keep pin'**
  String get release_preview_keep_pin;

  /// Title of the isolated browser reader pane.
  ///
  /// In en, this message translates to:
  /// **'Browser preview'**
  String get release_preview_title;

  /// Tooltip: hide the preview without forgetting its document.
  ///
  /// In en, this message translates to:
  /// **'Hide preview'**
  String get release_preview_hide;

  /// Tooltip: close the preview and forget its document.
  ///
  /// In en, this message translates to:
  /// **'Close and forget page'**
  String get release_preview_close_and_forget;

  /// Label of the preview URL field.
  ///
  /// In en, this message translates to:
  /// **'Site address'**
  String get release_preview_site_address;

  /// Tooltip: navigate the preview to the entered URL.
  ///
  /// In en, this message translates to:
  /// **'Go to address'**
  String get release_preview_go_to_address;

  /// Tooltip: advance through preview navigation history.
  ///
  /// In en, this message translates to:
  /// **'Forward'**
  String get release_preview_forward;

  /// Tooltip: reload the current preview document.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get release_preview_reload;

  /// Tooltip: request consent to share the preview reader with Hermes.
  ///
  /// In en, this message translates to:
  /// **'Share page with Hermes'**
  String get release_preview_share_with_hermes;

  /// Tooltip: revoke the current reader-sharing grant.
  ///
  /// In en, this message translates to:
  /// **'Stop sharing page'**
  String get release_preview_stop_sharing;

  /// Tooltip: toggle preview annotation mode.
  ///
  /// In en, this message translates to:
  /// **'Annotate element or region'**
  String get release_preview_annotate;

  /// Tooltip: toggle the credential-free reader request log.
  ///
  /// In en, this message translates to:
  /// **'Reader console'**
  String get release_preview_reader_console;

  /// Action to rebind a preview to its current chat.
  ///
  /// In en, this message translates to:
  /// **'Reconnect preview'**
  String get release_preview_reconnect;

  /// Preview empty-state description of its reader-only limitations.
  ///
  /// In en, this message translates to:
  /// **'Reader mode: HTML and text. No scripts, embedded resources or signed-in browser profile.'**
  String get release_preview_reader_mode_help;

  /// Persistent notice while this preview reader is shared with the owning chat.
  ///
  /// In en, this message translates to:
  /// **'Sharing reader with this chat: {origin}'**
  String release_preview_sharing_origin(String origin);

  /// Instruction shown in preview annotation mode.
  ///
  /// In en, this message translates to:
  /// **'Tap an element or drag a region to comment.'**
  String get release_preview_annotation_help;

  /// Reader console heading when no log rows are selected.
  ///
  /// In en, this message translates to:
  /// **'Reader requests (JavaScript is off)'**
  String get release_preview_reader_requests;

  /// Reader console heading with the selected log-row count.
  ///
  /// In en, this message translates to:
  /// **'{count} selected · JavaScript is off'**
  String release_preview_selected_requests(int count);

  /// Copy every retained reader request log row.
  ///
  /// In en, this message translates to:
  /// **'Copy all'**
  String get release_preview_copy_all;

  /// Copy only the selected reader request log rows.
  ///
  /// In en, this message translates to:
  /// **'Copy selected'**
  String get release_preview_copy_selected;

  /// Stage the reader request log in the composer without sending.
  ///
  /// In en, this message translates to:
  /// **'Add log to draft'**
  String get release_preview_add_log_to_draft;

  /// Heading and request log staged visibly in the composer. Preserve log line breaks.
  ///
  /// In en, this message translates to:
  /// **'Reader requests:\n{log}'**
  String release_preview_requests_draft(String log);

  /// Stage the current preview annotation pins in the composer without sending.
  ///
  /// In en, this message translates to:
  /// **'Add {count} to draft'**
  String release_preview_add_pins_to_draft(int count);

  /// A successful reader fetch log row; retain HTTP 200 and the untranslated URL origin.
  ///
  /// In en, this message translates to:
  /// **'HTTP 200 · {origin} · {count, plural, one{{count} reader element} other{{count} reader elements}}'**
  String release_preview_request_loaded(String origin, int count);

  /// Introduction to annotation evidence staged visibly in the composer, followed by technical coordinates and user notes.
  ///
  /// In en, this message translates to:
  /// **'Review these comments on the preview of {origin}. The attached crops are numbered in the same order.'**
  String release_preview_annotation_intro(String origin);

  /// Label for a user-drawn reader region in staged annotation evidence.
  ///
  /// In en, this message translates to:
  /// **'reader region'**
  String get release_preview_reader_region;

  /// Preview failure when an annotation crop cannot be captured.
  ///
  /// In en, this message translates to:
  /// **'Could not capture these pixels.'**
  String get release_preview_capture_failed;

  /// Preview address-policy refusal. Do not imply that navigation was approved.
  ///
  /// In en, this message translates to:
  /// **'This address is outside the approved preview origin.'**
  String get release_preview_address_not_approved;

  /// Preview page exceeds the reader byte or source length budget.
  ///
  /// In en, this message translates to:
  /// **'Page exceeds the reader limit.'**
  String get release_preview_page_limit;

  /// Preview HTML parse failed or the worker returned invalid data.
  ///
  /// In en, this message translates to:
  /// **'The page could not be read.'**
  String get release_preview_page_unreadable;

  /// Preview background parsing exceeded its time budget.
  ///
  /// In en, this message translates to:
  /// **'This page is too complex for reader mode.'**
  String get release_preview_page_complex;

  /// Reader HTTP failure with the response status. Retain the no-redirect and no-sign-in guarantees.
  ///
  /// In en, this message translates to:
  /// **'HTTP {statusCode}. No redirect or sign-in was followed.'**
  String release_preview_http_failed(int statusCode);

  /// Preview MIME type is not supported.
  ///
  /// In en, this message translates to:
  /// **'Only HTML and plain text can open in reader mode.'**
  String get release_preview_unsupported_type;

  /// Credential-free preview fetch failed.
  ///
  /// In en, this message translates to:
  /// **'The site could not be loaded securely.'**
  String get release_preview_load_insecure;

  /// Attachment preparation rejected the preview crop byte budget.
  ///
  /// In en, this message translates to:
  /// **'Preview crop exceeds its limit.'**
  String get release_preview_crop_limit;

  /// Preview crop preparation found an empty or unreadable image.
  ///
  /// In en, this message translates to:
  /// **'The selected image is empty or unreadable.'**
  String get release_preview_image_unreadable;

  /// Preview crop preparation rejected the per-image draft byte budget.
  ///
  /// In en, this message translates to:
  /// **'The selected image exceeds the 64 MiB draft budget.'**
  String get release_preview_image_budget;

  /// Preview crop preparation rejected an unsupported image format.
  ///
  /// In en, this message translates to:
  /// **'Unsupported image format. Choose a JPEG, PNG, or WebP image.'**
  String get release_preview_image_format;

  /// Preview crop preparation could not safely decode the image.
  ///
  /// In en, this message translates to:
  /// **'The selected JPEG, PNG, or WebP image could not be decoded safely.'**
  String get release_preview_image_decode;

  /// Preview crop preparation could not scrub image metadata safely.
  ///
  /// In en, this message translates to:
  /// **'Unable to sanitize this image. Choose a valid JPEG, PNG, or WebP image.'**
  String get release_preview_image_sanitize;

  /// Preview evidence would exceed the total attachment byte budget.
  ///
  /// In en, this message translates to:
  /// **'Attachments are limited to 64 MiB total per draft.'**
  String get release_preview_draft_budget;

  /// An existing generic attachment exceeds the limit checked while staging preview evidence.
  ///
  /// In en, this message translates to:
  /// **'Generic files are limited to 16 MiB each.'**
  String get release_preview_generic_file_limit;

  /// An existing image fails the safety check while staging preview evidence.
  ///
  /// In en, this message translates to:
  /// **'Remote images must be sanitized before upload.'**
  String get release_preview_image_not_sanitized;

  /// Safe localized fallback for an unknown attachment preparation failure; never show raw service diagnostics.
  ///
  /// In en, this message translates to:
  /// **'Could not add preview evidence to the draft. Try again.'**
  String get release_preview_stage_failed;

  /// Button and sheet title for finding Hermes servers on the local area network. Hermes is a product name; LAN means local area network.
  ///
  /// In en, this message translates to:
  /// **'Find Hermes on LAN'**
  String get release_misc_find_hermes_on_lan;

  /// Failure notice when local-network server discovery fails. The diagnostic error text is shown verbatim after a translated label.
  ///
  /// In en, this message translates to:
  /// **'Discovery failed: {error}'**
  String release_misc_discovery_failed(String error);

  /// Empty result message after the local-network Hermes server scan completes.
  ///
  /// In en, this message translates to:
  /// **'No Hermes servers found on the local network.'**
  String get release_misc_no_lan_servers;

  /// Connection health-check failure after the server rejects a supplied API key.
  ///
  /// In en, this message translates to:
  /// **'API key was rejected by {endpoint} (HTTP {statusCode}).'**
  String release_misc_api_key_rejected(String endpoint, int statusCode);

  /// Connection health-check failure when the server requires an API key and none was supplied. Keep the configuration identifier API_SERVER_KEY unchanged.
  ///
  /// In en, this message translates to:
  /// **'Server requires an API key. Enter your API_SERVER_KEY.'**
  String get release_misc_api_key_required;

  /// Connection health-check failure for a missing gateway endpoint, including configuration checks rather than assuming the service identity.
  ///
  /// In en, this message translates to:
  /// **'Gateway endpoint {endpoint} returned HTTP 404. Check the Gateway path prefix and reverse-proxy routes.'**
  String release_misc_gateway_not_found(String endpoint);

  /// Connection health-check failure for an HTTP status other than an authentication refusal or a missing endpoint.
  ///
  /// In en, this message translates to:
  /// **'Gateway endpoint {endpoint} returned HTTP {statusCode}.'**
  String release_misc_gateway_http_error(String endpoint, int statusCode);

  /// Connection health-check network failure without an HTTP response.
  ///
  /// In en, this message translates to:
  /// **'Cannot reach Gateway endpoint {endpoint}.'**
  String release_misc_gateway_unreachable(String endpoint);

  /// Shared validation refusal; preserve the specific delivery target or file-saving reason.
  ///
  /// In en, this message translates to:
  /// **'Invalid delivery target'**
  String get release_core_schedule_invalid_delivery_target;

  /// Shared validation refusal; preserve the specific delivery target or file-saving reason.
  ///
  /// In en, this message translates to:
  /// **'Only a file directly in the working directory can be saved.'**
  String get release_core_file_save_direct_only;

  /// Shared validation refusal; preserve the specific delivery target or file-saving reason.
  ///
  /// In en, this message translates to:
  /// **'Hidden files can\'t be saved by the gateway.'**
  String get release_core_file_save_hidden;

  /// Release administration: Choose a provider and a model.
  ///
  /// In en, this message translates to:
  /// **'Choose a provider and a model.'**
  String get rel_admin_choose_provider;

  /// Release administration: Choose a known effort level.
  ///
  /// In en, this message translates to:
  /// **'Choose a known effort level.'**
  String get rel_admin_known_effort;

  /// Release administration: Enter a name for this endpoint.
  ///
  /// In en, this message translates to:
  /// **'Enter a name for this endpoint.'**
  String get rel_admin_endpoint_name_required;

  /// Release administration: Enter the model this endpoint serves.
  ///
  /// In en, this message translates to:
  /// **'Enter the model this endpoint serves.'**
  String get rel_admin_endpoint_model_required;

  /// Release administration: Choose Auto or a known API mode.
  ///
  /// In en, this message translates to:
  /// **'Choose Auto or a known API mode.'**
  String get rel_admin_known_api_mode;

  /// Release administration: This endpoint identifier is not usable.
  ///
  /// In en, this message translates to:
  /// **'This endpoint identifier is not usable.'**
  String get rel_admin_endpoint_id_invalid;

  /// Release administration: Use HTTPS for a remote endpoint, or HTTP on localhost.
  ///
  /// In en, this message translates to:
  /// **'Use HTTPS for a remote endpoint, or HTTP on localhost.'**
  String get rel_admin_endpoint_https;

  /// Release administration: That API key cannot be saved.
  ///
  /// In en, this message translates to:
  /// **'That API key cannot be saved.'**
  String get rel_admin_key_invalid;

  /// Release administration: The gateway response did not match the expected shape.
  ///
  /// In en, this message translates to:
  /// **'The gateway response did not match the expected shape.'**
  String get rel_admin_response_shape;

  /// Release administration: Enter iteration, concurrency and timeout limits before saving.
  ///
  /// In en, this message translates to:
  /// **'Enter iteration, concurrency and timeout limits before saving.'**
  String get rel_admin_limits_required;

  /// Release administration: Each route needs a name and a model before it can be saved.
  ///
  /// In en, this message translates to:
  /// **'Each route needs a name and a model before it can be saved.'**
  String get rel_admin_route_required;

  /// Release administration: Route names must be unique.
  ///
  /// In en, this message translates to:
  /// **'Route names must be unique.'**
  String get rel_admin_route_unique;

  /// Release administration: The default route has to be one of the saved routes.
  ///
  /// In en, this message translates to:
  /// **'The default route has to be one of the saved routes.'**
  String get rel_admin_route_default_invalid;

  /// Release administration: Choose a loud or silent degraded-reference policy.
  ///
  /// In en, this message translates to:
  /// **'Choose a loud or silent degraded-reference policy.'**
  String get rel_admin_policy_required;

  /// Release administration: The gateway did not return an active mixture.
  ///
  /// In en, this message translates to:
  /// **'The gateway did not return an active mixture.'**
  String get rel_admin_mixture_missing;

  /// Release administration: Name a provider and model for the aggregator and every reference.
  ///
  /// In en, this message translates to:
  /// **'Name a provider and model for the aggregator and every reference.'**
  String get rel_admin_mixture_slots_required;

  /// Release administration: Enter the chat id this change applies to.
  ///
  /// In en, this message translates to:
  /// **'Enter the chat id this change applies to.'**
  String get rel_admin_chat_id_required;

  /// Release administration: The gateway returned HTTP {status}.
  ///
  /// In en, this message translates to:
  /// **'The gateway returned HTTP {status}.'**
  String rel_admin_http_error(String status);

  /// Release administration: The gateway response could not be read.
  ///
  /// In en, this message translates to:
  /// **'The gateway response could not be read.'**
  String get rel_admin_response_unreadable;

  /// Release administration: Connect the live gateway session before changing billing or a chat.
  ///
  /// In en, this message translates to:
  /// **'Connect the live gateway session before changing billing or a chat.'**
  String get rel_admin_connect_before_change;

  /// Release administration: This gateway does not provide that operation.
  ///
  /// In en, this message translates to:
  /// **'This gateway does not provide that operation.'**
  String get rel_admin_operation_unavailable;

  /// Release administration: Enter the key to save.
  ///
  /// In en, this message translates to:
  /// **'Enter the key to save.'**
  String get rel_admin_key_required;

  /// Release administration: The gateway did not save that key.
  ///
  /// In en, this message translates to:
  /// **'The gateway did not save that key.'**
  String get rel_admin_key_save_failed;

  /// Release administration: Choose a provider key to clear.
  ///
  /// In en, this message translates to:
  /// **'Choose a provider key to clear.'**
  String get rel_admin_key_clear_required;

  /// Release administration: The gateway did not clear that key.
  ///
  /// In en, this message translates to:
  /// **'The gateway did not clear that key.'**
  String get rel_admin_key_clear_failed;

  /// Release administration: The gateway did not save that endpoint.
  ///
  /// In en, this message translates to:
  /// **'The gateway did not save that endpoint.'**
  String get rel_admin_endpoint_save_failed;

  /// Release administration: The gateway did not activate that endpoint.
  ///
  /// In en, this message translates to:
  /// **'The gateway did not activate that endpoint.'**
  String get rel_admin_endpoint_activate_failed;

  /// Release administration: Provider accounts need an authenticated HTTPS gateway, or localhost.
  ///
  /// In en, this message translates to:
  /// **'Provider accounts need an authenticated HTTPS gateway, or localhost.'**
  String get rel_admin_accounts_secure_required;

  /// Release administration: Provider accounts could not be read.
  ///
  /// In en, this message translates to:
  /// **'Provider accounts could not be read.'**
  String get rel_admin_accounts_read_failed;

  /// Release administration: The gateway did not disconnect that account.
  ///
  /// In en, this message translates to:
  /// **'The gateway did not disconnect that account.'**
  String get rel_admin_account_disconnect_failed;

  /// Release administration: That provider account cannot be disconnected.
  ///
  /// In en, this message translates to:
  /// **'That provider account cannot be disconnected.'**
  String get rel_admin_account_not_disconnectable;

  /// Release administration: Choose one of the available delegation backends.
  ///
  /// In en, this message translates to:
  /// **'Choose one of the available delegation backends.'**
  String get rel_admin_backend_required;

  /// Release administration: The gateway did not select that backend.
  ///
  /// In en, this message translates to:
  /// **'The gateway did not select that backend.'**
  String get rel_admin_backend_save_failed;

  /// Release administration: The gateway did not save those routes.
  ///
  /// In en, this message translates to:
  /// **'The gateway did not save those routes.'**
  String get rel_admin_routes_save_failed;

  /// Release administration: Each profile route needs a profile name.
  ///
  /// In en, this message translates to:
  /// **'Each profile route needs a profile name.'**
  String get rel_admin_profile_route_required;

  /// Release administration: Profile routes must be unique.
  ///
  /// In en, this message translates to:
  /// **'Profile routes must be unique.'**
  String get rel_admin_profile_route_unique;

  /// Release administration: The default profile route has to be one of the allowed profiles.
  ///
  /// In en, this message translates to:
  /// **'The default profile route has to be one of the allowed profiles.'**
  String get rel_admin_profile_route_default_invalid;

  /// Release administration: The gateway did not save those profile routes.
  ///
  /// In en, this message translates to:
  /// **'The gateway did not save those profile routes.'**
  String get rel_admin_profile_routes_save_failed;

  /// Release administration: The gateway did not save those limits.
  ///
  /// In en, this message translates to:
  /// **'The gateway did not save those limits.'**
  String get rel_admin_limits_save_failed;

  /// Release administration: The gateway did not save that mixture.
  ///
  /// In en, this message translates to:
  /// **'The gateway did not save that mixture.'**
  String get rel_admin_mixture_save_failed;

  /// Release administration: Choose one of the offered credit amounts.
  ///
  /// In en, this message translates to:
  /// **'Choose one of the offered credit amounts.'**
  String get rel_admin_credit_amount_required;

  /// Release administration: That charge could not be checked.
  ///
  /// In en, this message translates to:
  /// **'That charge could not be checked.'**
  String get rel_admin_charge_check_failed;

  /// Release administration: Auto-reload amounts were not provided, so they were not changed.
  ///
  /// In en, this message translates to:
  /// **'Auto-reload amounts were not provided, so they were not changed.'**
  String get rel_admin_reload_amounts_missing;

  /// Release administration: Choose a plan first.
  ///
  /// In en, this message translates to:
  /// **'Choose a plan first.'**
  String get rel_admin_plan_required;

  /// Release administration: Only a scheduled plan change can be confirmed from here.
  ///
  /// In en, this message translates to:
  /// **'Only a scheduled plan change can be confirmed from here.'**
  String get rel_admin_plan_scheduled_only;

  /// Release administration: The gateway refused this billing request.
  ///
  /// In en, this message translates to:
  /// **'The gateway refused this billing request.'**
  String get rel_admin_billing_refused;

  /// Release administration: The gateway refused this request.
  ///
  /// In en, this message translates to:
  /// **'The gateway refused this request.'**
  String get rel_admin_request_refused;

  /// Release administration: The endpoint answered.
  ///
  /// In en, this message translates to:
  /// **'The endpoint answered.'**
  String get rel_admin_endpoint_answered;

  /// Release administration: The endpoint did not answer.
  ///
  /// In en, this message translates to:
  /// **'The endpoint did not answer.'**
  String get rel_admin_endpoint_no_answer;

  /// Release administration: Charge outcome unknown. It may still settle. Check the portal before retrying.
  ///
  /// In en, this message translates to:
  /// **'Charge outcome unknown. It may still settle. Check the portal before retrying.'**
  String get rel_admin_charge_unknown;

  /// Release administration: Connect the live gateway session before reading billing. Nothing is charged from this page.
  ///
  /// In en, this message translates to:
  /// **'Connect the live gateway session before reading billing. Nothing is charged from this page.'**
  String get rel_admin_connect_before_billing;

  /// Release administration: Save a preset before applying it.
  ///
  /// In en, this message translates to:
  /// **'Save a preset before applying it.'**
  String get rel_admin_preset_required;

  /// Release administration: Cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get rel_admin_cancel;

  /// Release administration: Refresh
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get rel_admin_refresh;

  /// Release administration: Credits and plans
  ///
  /// In en, this message translates to:
  /// **'Credits and plans'**
  String get rel_admin_credits_and_plans;

  /// Release administration: Saved
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get rel_admin_saved;

  /// Release administration: Name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get rel_admin_name;

  /// Release administration: Base URL
  ///
  /// In en, this message translates to:
  /// **'Base URL'**
  String get rel_admin_base_url;

  /// Release administration: Model
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get rel_admin_model;

  /// Release administration: Signed in
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get rel_admin_signed_in;

  /// Release administration: Not signed in
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get rel_admin_not_signed_in;

  /// Release administration: Provider
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get rel_admin_provider;

  /// Release administration: Apply to this chat
  ///
  /// In en, this message translates to:
  /// **'Apply to this chat'**
  String get rel_admin_apply_to_this_chat;

  /// Release administration: Auto
  ///
  /// In en, this message translates to:
  /// **'Auto'**
  String get rel_admin_auto;

  /// Release administration: Chat Completions
  ///
  /// In en, this message translates to:
  /// **'Chat Completions'**
  String get rel_admin_chat_completions;

  /// Release administration: Codex Responses
  ///
  /// In en, this message translates to:
  /// **'Codex Responses'**
  String get rel_admin_codex_responses;

  /// Release administration: Anthropic Messages
  ///
  /// In en, this message translates to:
  /// **'Anthropic Messages'**
  String get rel_admin_anthropic_messages;

  /// Release administration: Could not complete that request.
  ///
  /// In en, this message translates to:
  /// **'Could not complete that request.'**
  String get rel_admin_could_not_complete_that_request;

  /// Release administration: Confirm
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get rel_admin_confirm;

  /// Release administration: Providers and billing
  ///
  /// In en, this message translates to:
  /// **'Providers and billing'**
  String get rel_admin_providers_and_billing;

  /// Release administration: API keys
  ///
  /// In en, this message translates to:
  /// **'API keys'**
  String get rel_admin_api_keys;

  /// Release administration: Custom endpoints
  ///
  /// In en, this message translates to:
  /// **'Custom endpoints'**
  String get rel_admin_custom_endpoints;

  /// Release administration: Provider accounts
  ///
  /// In en, this message translates to:
  /// **'Provider accounts'**
  String get rel_admin_provider_accounts;

  /// Release administration: Effort and speed presets
  ///
  /// In en, this message translates to:
  /// **'Effort and speed presets'**
  String get rel_admin_effort_and_speed_presets;

  /// Release administration: Delegation
  ///
  /// In en, this message translates to:
  /// **'Delegation'**
  String get rel_admin_delegation;

  /// Release administration: Mixture of agents
  ///
  /// In en, this message translates to:
  /// **'Mixture of agents'**
  String get rel_admin_mixture_of_agents;

  /// Release administration: No provider keys were reported for this profile.
  ///
  /// In en, this message translates to:
  /// **'No provider keys were reported for this profile.'**
  String get rel_admin_no_provider_keys_were_reported_for_this_profile;

  /// Release administration: Not saved
  ///
  /// In en, this message translates to:
  /// **'Not saved'**
  String get rel_admin_not_saved;

  /// Release administration: New key value
  ///
  /// In en, this message translates to:
  /// **'New key value'**
  String get rel_admin_new_key_value;

  /// Release administration: Provider key saved.
  ///
  /// In en, this message translates to:
  /// **'Provider key saved.'**
  String get rel_admin_provider_key_saved;

  /// Release administration: Save key
  ///
  /// In en, this message translates to:
  /// **'Save key'**
  String get rel_admin_save_key;

  /// Release administration: Clear provider key
  ///
  /// In en, this message translates to:
  /// **'Clear provider key'**
  String get rel_admin_clear_provider_key;

  /// Release administration: Provider key cleared.
  ///
  /// In en, this message translates to:
  /// **'Provider key cleared.'**
  String get rel_admin_provider_key_cleared;

  /// Release administration: Clear key
  ///
  /// In en, this message translates to:
  /// **'Clear key'**
  String get rel_admin_clear_key;

  /// Release administration: New endpoint
  ///
  /// In en, this message translates to:
  /// **'New endpoint'**
  String get rel_admin_new_endpoint;

  /// Release administration: API key
  ///
  /// In en, this message translates to:
  /// **'API key'**
  String get rel_admin_api_key;

  /// Release administration: Leave blank to keep a key this endpoint already has.
  ///
  /// In en, this message translates to:
  /// **'Leave blank to keep a key this endpoint already has.'**
  String get rel_admin_leave_blank_to_keep_a_key_this_endpoint_already_has;

  /// Release administration: Reachable
  ///
  /// In en, this message translates to:
  /// **'Reachable'**
  String get rel_admin_reachable;

  /// Release administration: Unreachable
  ///
  /// In en, this message translates to:
  /// **'Unreachable'**
  String get rel_admin_unreachable;

  /// Release administration: Test endpoint
  ///
  /// In en, this message translates to:
  /// **'Test endpoint'**
  String get rel_admin_test_endpoint;

  /// Release administration: Endpoint saved.
  ///
  /// In en, this message translates to:
  /// **'Endpoint saved.'**
  String get rel_admin_endpoint_saved;

  /// Release administration: Save endpoint
  ///
  /// In en, this message translates to:
  /// **'Save endpoint'**
  String get rel_admin_save_endpoint;

  /// Release administration: Use this endpoint
  ///
  /// In en, this message translates to:
  /// **'Use this endpoint'**
  String get rel_admin_use_this_endpoint;

  /// Release administration: Make this named endpoint the current model for this profile?
  ///
  /// In en, this message translates to:
  /// **'Make this named endpoint the current model for this profile?'**
  String
  get rel_admin_make_this_named_endpoint_the_current_model_for_this_profile;

  /// Release administration: Endpoint is now current.
  ///
  /// In en, this message translates to:
  /// **'Endpoint is now current.'**
  String get rel_admin_endpoint_is_now_current;

  /// Release administration: Use endpoint
  ///
  /// In en, this message translates to:
  /// **'Use endpoint'**
  String get rel_admin_use_endpoint;

  /// Release administration: Delete endpoint
  ///
  /// In en, this message translates to:
  /// **'Delete endpoint'**
  String get rel_admin_delete_endpoint;

  /// Release administration: Delete this named endpoint from the profile?
  ///
  /// In en, this message translates to:
  /// **'Delete this named endpoint from the profile?'**
  String get rel_admin_delete_this_named_endpoint_from_the_profile;

  /// Release administration: Endpoint deleted.
  ///
  /// In en, this message translates to:
  /// **'Endpoint deleted.'**
  String get rel_admin_endpoint_deleted;

  /// Release administration: Signing in stays on the provider sign-in screen. Disconnect only runs when this gateway says the account can be removed.
  ///
  /// In en, this message translates to:
  /// **'Signing in stays on the provider sign-in screen. Disconnect only runs when this gateway says the account can be removed.'**
  String get rel_admin_signing_in_stays_on_the_provider_sign_in_screen;

  /// Release administration: Disconnect this provider account on the gateway?
  ///
  /// In en, this message translates to:
  /// **'Disconnect this provider account on the gateway?'**
  String get rel_admin_disconnect_this_provider_account_on_the_gateway;

  /// Release administration: Provider account disconnected.
  ///
  /// In en, this message translates to:
  /// **'Provider account disconnected.'**
  String get rel_admin_provider_account_disconnected;

  /// Release administration: Disconnect
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get rel_admin_disconnect;

  /// Release administration: Not disconnectable
  ///
  /// In en, this message translates to:
  /// **'Not disconnectable'**
  String get rel_admin_not_disconnectable;

  /// Release administration: Fast
  ///
  /// In en, this message translates to:
  /// **'Fast'**
  String get rel_admin_fast;

  /// Release administration: Preset saved for this model.
  ///
  /// In en, this message translates to:
  /// **'Preset saved for this model.'**
  String get rel_admin_preset_saved_for_this_model;

  /// Release administration: Save preset
  ///
  /// In en, this message translates to:
  /// **'Save preset'**
  String get rel_admin_save_preset;

  /// Release administration: Chat id
  ///
  /// In en, this message translates to:
  /// **'Chat id'**
  String get rel_admin_chat_id;

  /// Release administration: Apply preset
  ///
  /// In en, this message translates to:
  /// **'Apply preset'**
  String get rel_admin_apply_preset;

  /// Release administration: Set this chat's effort and speed from the saved preset?
  ///
  /// In en, this message translates to:
  /// **'Set this chat\'s effort and speed from the saved preset?'**
  String get rel_admin_set_this_chat_s_effort_and_speed_from_the_saved_preset;

  /// Release administration: Preset applied to this chat.
  ///
  /// In en, this message translates to:
  /// **'Preset applied to this chat.'**
  String get rel_admin_preset_applied_to_this_chat;

  /// Release administration: This route sends the picked effort unchanged.
  ///
  /// In en, this message translates to:
  /// **'This route sends the picked effort unchanged.'**
  String get rel_admin_this_route_sends_the_picked_effort_unchanged;

  /// Release administration: Show route clamp
  ///
  /// In en, this message translates to:
  /// **'Show route clamp'**
  String get rel_admin_show_route_clamp;

  /// Release administration: Delegation backend
  ///
  /// In en, this message translates to:
  /// **'Delegation backend'**
  String get rel_admin_delegation_backend;

  /// Release administration: Delegation backend saved.
  ///
  /// In en, this message translates to:
  /// **'Delegation backend saved.'**
  String get rel_admin_delegation_backend_saved;

  /// Release administration: Save backend
  ///
  /// In en, this message translates to:
  /// **'Save backend'**
  String get rel_admin_save_backend;

  /// Release administration: Max iterations
  ///
  /// In en, this message translates to:
  /// **'Max iterations'**
  String get rel_admin_max_iterations;

  /// Release administration: Max concurrent children
  ///
  /// In en, this message translates to:
  /// **'Max concurrent children'**
  String get rel_admin_max_concurrent_children;

  /// Release administration: Child timeout seconds
  ///
  /// In en, this message translates to:
  /// **'Child timeout seconds'**
  String get rel_admin_child_timeout_seconds;

  /// Release administration: Delegation effort, leave unchanged
  ///
  /// In en, this message translates to:
  /// **'Delegation effort, leave unchanged'**
  String get rel_admin_delegation_effort_leave_unchanged;

  /// Release administration: Delegation limits saved.
  ///
  /// In en, this message translates to:
  /// **'Delegation limits saved.'**
  String get rel_admin_delegation_limits_saved;

  /// Release administration: Save limits
  ///
  /// In en, this message translates to:
  /// **'Save limits'**
  String get rel_admin_save_limits;

  /// Release administration: Remove route
  ///
  /// In en, this message translates to:
  /// **'Remove route'**
  String get rel_admin_remove_route;

  /// Release administration: Route name
  ///
  /// In en, this message translates to:
  /// **'Route name'**
  String get rel_admin_route_name;

  /// Release administration: Route provider
  ///
  /// In en, this message translates to:
  /// **'Route provider'**
  String get rel_admin_route_provider;

  /// Release administration: Route model
  ///
  /// In en, this message translates to:
  /// **'Route model'**
  String get rel_admin_route_model;

  /// Release administration: Route effort unchanged
  ///
  /// In en, this message translates to:
  /// **'Route effort unchanged'**
  String get rel_admin_route_effort_unchanged;

  /// Release administration: Add route
  ///
  /// In en, this message translates to:
  /// **'Add route'**
  String get rel_admin_add_route;

  /// Release administration: Default route
  ///
  /// In en, this message translates to:
  /// **'Default route'**
  String get rel_admin_default_route;

  /// Release administration: Delegation routes saved.
  ///
  /// In en, this message translates to:
  /// **'Delegation routes saved.'**
  String get rel_admin_delegation_routes_saved;

  /// Release administration: Save routes
  ///
  /// In en, this message translates to:
  /// **'Save routes'**
  String get rel_admin_save_routes;

  /// Release administration: Profile routes saved.
  ///
  /// In en, this message translates to:
  /// **'Profile routes saved.'**
  String get rel_admin_profile_routes_saved;

  /// Release administration: Save profile routes
  ///
  /// In en, this message translates to:
  /// **'Save profile routes'**
  String get rel_admin_save_profile_routes;

  /// Release administration: No mixture is loaded.
  ///
  /// In en, this message translates to:
  /// **'No mixture is loaded.'**
  String get rel_admin_no_mixture_is_loaded;

  /// Release administration: Mixture enabled
  ///
  /// In en, this message translates to:
  /// **'Mixture enabled'**
  String get rel_admin_mixture_enabled;

  /// Release administration: Loud degraded references
  ///
  /// In en, this message translates to:
  /// **'Loud degraded references'**
  String get rel_admin_loud_degraded_references;

  /// Release administration: Silent degraded references
  ///
  /// In en, this message translates to:
  /// **'Silent degraded references'**
  String get rel_admin_silent_degraded_references;

  /// Release administration: Aggregator
  ///
  /// In en, this message translates to:
  /// **'Aggregator'**
  String get rel_admin_aggregator;

  /// Release administration: Aggregator provider
  ///
  /// In en, this message translates to:
  /// **'Aggregator provider'**
  String get rel_admin_aggregator_provider;

  /// Release administration: Aggregator model
  ///
  /// In en, this message translates to:
  /// **'Aggregator model'**
  String get rel_admin_aggregator_model;

  /// Release administration: Reference provider
  ///
  /// In en, this message translates to:
  /// **'Reference provider'**
  String get rel_admin_reference_provider;

  /// Release administration: Reference model
  ///
  /// In en, this message translates to:
  /// **'Reference model'**
  String get rel_admin_reference_model;

  /// Release administration: Add reference model
  ///
  /// In en, this message translates to:
  /// **'Add reference model'**
  String get rel_admin_add_reference_model;

  /// Release administration: Mixture saved.
  ///
  /// In en, this message translates to:
  /// **'Mixture saved.'**
  String get rel_admin_mixture_saved;

  /// Release administration: Save mixture
  ///
  /// In en, this message translates to:
  /// **'Save mixture'**
  String get rel_admin_save_mixture;

  /// Release administration: Credit purchase submitted.
  ///
  /// In en, this message translates to:
  /// **'Credit purchase submitted.'**
  String get rel_admin_credit_purchase_submitted;

  /// Release administration: Credit purchase settled.
  ///
  /// In en, this message translates to:
  /// **'Credit purchase settled.'**
  String get rel_admin_credit_purchase_settled;

  /// Release administration: Credit and plan changes wait for confirmation. A plan that would charge immediately is shown and not confirmed here.
  ///
  /// In en, this message translates to:
  /// **'Credit and plan changes wait for confirmation. A plan that would charge immediately is shown and not confirmed here.'**
  String get rel_admin_credit_and_plan_changes_wait_for_confirmation_a_plan;

  /// Release administration: Buy credits
  ///
  /// In en, this message translates to:
  /// **'Buy credits'**
  String get rel_admin_buy_credits;

  /// Release administration: Retry same charge
  ///
  /// In en, this message translates to:
  /// **'Retry same charge'**
  String get rel_admin_retry_same_charge;

  /// Release administration: Retry the same credit charge. This does not start a second purchase.
  ///
  /// In en, this message translates to:
  /// **'Retry the same credit charge. This does not start a second purchase.'**
  String get rel_admin_retry_the_same_credit_charge_this_does_not_start;

  /// Release administration: Credit purchases are not available for this account.
  ///
  /// In en, this message translates to:
  /// **'Credit purchases are not available for this account.'**
  String get rel_admin_credit_purchases_are_not_available_for_this_account;

  /// Release administration: Auto-reload
  ///
  /// In en, this message translates to:
  /// **'Auto-reload'**
  String get rel_admin_auto_reload;

  /// Release administration: Read-only until this account can charge.
  ///
  /// In en, this message translates to:
  /// **'Read-only until this account can charge.'**
  String get rel_admin_read_only_until_this_account_can_charge;

  /// Release administration: Auto-reload updated.
  ///
  /// In en, this message translates to:
  /// **'Auto-reload updated.'**
  String get rel_admin_auto_reload_updated;

  /// Release administration: Keep going on credits
  ///
  /// In en, this message translates to:
  /// **'Keep going on credits'**
  String get rel_admin_keep_going_on_credits;

  /// Release administration: Continue on credits when the plan window is used up?
  ///
  /// In en, this message translates to:
  /// **'Continue on credits when the plan window is used up?'**
  String get rel_admin_continue_on_credits_when_the_plan_window_is_used_up;

  /// Release administration: Stop continuing on credits when the plan window is used up?
  ///
  /// In en, this message translates to:
  /// **'Stop continuing on credits when the plan window is used up?'**
  String
  get rel_admin_stop_continuing_on_credits_when_the_plan_window_is_used_up;

  /// Release administration: Credit continuation updated.
  ///
  /// In en, this message translates to:
  /// **'Credit continuation updated.'**
  String get rel_admin_credit_continuation_updated;

  /// Release administration: This plan change is not confirmed from Ares.
  ///
  /// In en, this message translates to:
  /// **'This plan change is not confirmed from Ares.'**
  String get rel_admin_this_plan_change_is_not_confirmed_from_ares;

  /// Release administration: This change is scheduled. Confirm to apply it.
  ///
  /// In en, this message translates to:
  /// **'This change is scheduled. Confirm to apply it.'**
  String get rel_admin_this_change_is_scheduled_confirm_to_apply_it;

  /// Release administration: Preview plan
  ///
  /// In en, this message translates to:
  /// **'Preview plan'**
  String get rel_admin_preview_plan;

  /// Release administration: Schedule plan change
  ///
  /// In en, this message translates to:
  /// **'Schedule plan change'**
  String get rel_admin_schedule_plan_change;

  /// Release administration: Plan change scheduled.
  ///
  /// In en, this message translates to:
  /// **'Plan change scheduled.'**
  String get rel_admin_plan_change_scheduled;

  /// Release administration: Confirm scheduled plan change
  ///
  /// In en, this message translates to:
  /// **'Confirm scheduled plan change'**
  String get rel_admin_confirm_scheduled_plan_change;

  /// Release administration: Remove the saved {key} value from this profile?
  ///
  /// In en, this message translates to:
  /// **'Remove the saved {key} value from this profile?'**
  String rel_admin_remove_key_confirm(String key);

  /// Release administration: {name} · current
  ///
  /// In en, this message translates to:
  /// **'{name} · current'**
  String rel_admin_current_endpoint(String name);

  /// Release administration: {status} · {transport} · {count} models. {message}
  ///
  /// In en, this message translates to:
  /// **'{status} · {transport} · {count} models. {message}'**
  String rel_admin_endpoint_result(
    String status,
    String transport,
    String count,
    String message,
  );

  /// Release administration: Disconnect {name}
  ///
  /// In en, this message translates to:
  /// **'Disconnect {name}'**
  String rel_admin_disconnect_account(String name);

  /// Release administration: Delegation is blocked: {reason}
  ///
  /// In en, this message translates to:
  /// **'Delegation is blocked: {reason}'**
  String rel_admin_delegation_blocked(String reason);

  /// Release administration: {name} · unavailable
  ///
  /// In en, this message translates to:
  /// **'{name} · unavailable'**
  String rel_admin_backend_unavailable(String name);

  /// Release administration: Reference {number}
  ///
  /// In en, this message translates to:
  /// **'Reference {number}'**
  String rel_admin_reference_number(String number);

  /// Release administration: Turn on auto-reload and charge {amount} when the balance falls below {threshold}?
  ///
  /// In en, this message translates to:
  /// **'Turn on auto-reload and charge {amount} when the balance falls below {threshold}?'**
  String rel_admin_reload_enable_confirm(String amount, String threshold);

  /// Release administration: Turn off auto-reload? It currently charges {amount} when the balance falls below {threshold}.
  ///
  /// In en, this message translates to:
  /// **'Turn off auto-reload? It currently charges {amount} when the balance falls below {threshold}.'**
  String rel_admin_reload_disable_confirm(String amount, String threshold);

  /// Release administration: this plan
  ///
  /// In en, this message translates to:
  /// **'this plan'**
  String get rel_admin_this_plan;

  /// Release administration: Schedule {name}. It is scheduled for the end of the current period. No charge is made now.
  ///
  /// In en, this message translates to:
  /// **'Schedule {name}. It is scheduled for the end of the current period. No charge is made now.'**
  String rel_admin_plan_confirm(String name);

  /// Release administration: Schedule {name} at {price}. It is scheduled for the end of the current period. No charge is made now.
  ///
  /// In en, this message translates to:
  /// **'Schedule {name} at {price}. It is scheduled for the end of the current period. No charge is made now.'**
  String rel_admin_plan_confirm_price(String name, String price);

  /// Release administration: Schedule {name}. It takes effect {when}. No charge is made now.
  ///
  /// In en, this message translates to:
  /// **'Schedule {name}. It takes effect {when}. No charge is made now.'**
  String rel_admin_plan_confirm_when(String name, String when);

  /// Release administration: Schedule {name} at {price}. It takes effect {when}. No charge is made now.
  ///
  /// In en, this message translates to:
  /// **'Schedule {name} at {price}. It takes effect {when}. No charge is made now.'**
  String rel_admin_plan_confirm_price_when(
    String name,
    String price,
    String when,
  );

  /// Release administration: Balance {amount}
  ///
  /// In en, this message translates to:
  /// **'Balance {amount}'**
  String rel_admin_balance(String amount);

  /// Release administration: Charge ${amount} to the payment method on this Nous account. This spends real money.
  ///
  /// In en, this message translates to:
  /// **'Charge \${amount} to the payment method on this Nous account. This spends real money.'**
  String rel_admin_buy_confirm(String amount);

  /// Release administration: Change auto-reload on the portal: {url}
  ///
  /// In en, this message translates to:
  /// **'Change auto-reload on the portal: {url}'**
  String rel_admin_reload_portal(String url);

  /// Release administration: Team subscriptions are changed on the portal: {url}
  ///
  /// In en, this message translates to:
  /// **'Team subscriptions are changed on the portal: {url}'**
  String rel_admin_team_portal(String url);

  /// Release administration: none
  ///
  /// In en, this message translates to:
  /// **'none'**
  String get rel_admin_effort_none;

  /// Release administration: minimal
  ///
  /// In en, this message translates to:
  /// **'minimal'**
  String get rel_admin_effort_minimal;

  /// Release administration: low
  ///
  /// In en, this message translates to:
  /// **'low'**
  String get rel_admin_effort_low;

  /// Release administration: medium
  ///
  /// In en, this message translates to:
  /// **'medium'**
  String get rel_admin_effort_medium;

  /// Release administration: high
  ///
  /// In en, this message translates to:
  /// **'high'**
  String get rel_admin_effort_high;

  /// Release administration: xhigh
  ///
  /// In en, this message translates to:
  /// **'xhigh'**
  String get rel_admin_effort_xhigh;

  /// Release administration: max
  ///
  /// In en, this message translates to:
  /// **'max'**
  String get rel_admin_effort_max;

  /// Release administration: ultra
  ///
  /// In en, this message translates to:
  /// **'ultra'**
  String get rel_admin_effort_ultra;

  /// Release administration: auto
  ///
  /// In en, this message translates to:
  /// **'auto'**
  String get rel_admin_auto_lower;

  /// Release administration: Create
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get rel_admin_create;

  /// Release administration: Prompt
  ///
  /// In en, this message translates to:
  /// **'Prompt'**
  String get rel_admin_prompt;

  /// Release administration: New profile ID
  ///
  /// In en, this message translates to:
  /// **'New profile ID'**
  String get rel_admin_new_profile_id;

  /// Release administration: This operation is unavailable on this gateway.
  ///
  /// In en, this message translates to:
  /// **'This operation is unavailable on this gateway.'**
  String get rel_admin_this_operation_is_unavailable_on_this_gateway;

  /// Release administration: Access denied by the gateway.
  ///
  /// In en, this message translates to:
  /// **'Access denied by the gateway.'**
  String get rel_admin_access_denied_by_the_gateway;

  /// Release administration: Connection changed. Reopen Profiles.
  ///
  /// In en, this message translates to:
  /// **'Connection changed. Reopen Profiles.'**
  String get rel_admin_connection_changed_reopen_profiles;

  /// Release administration: Invalid input or gateway response. Check the target before retrying.
  ///
  /// In en, this message translates to:
  /// **'Invalid input or gateway response. Check the target before retrying.'**
  String
  get rel_admin_invalid_input_or_gateway_response_check_the_target_before;

  /// Release administration: Could not verify the result. Refresh the target before trying again.
  ///
  /// In en, this message translates to:
  /// **'Could not verify the result. Refresh the target before trying again.'**
  String get rel_admin_could_not_verify_the_result_refresh_the_target_before;

  /// Release administration: Edit SOUL.md
  ///
  /// In en, this message translates to:
  /// **'Edit SOUL.md'**
  String get rel_admin_edit_soul_md;

  /// Release administration: Persona
  ///
  /// In en, this message translates to:
  /// **'Persona'**
  String get rel_admin_persona;

  /// Release administration: Persona saved.
  ///
  /// In en, this message translates to:
  /// **'Persona saved.'**
  String get rel_admin_persona_saved;

  /// Release administration: not set
  ///
  /// In en, this message translates to:
  /// **'not set'**
  String get rel_admin_not_set;

  /// Release administration: Enabled
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get rel_admin_enabled;

  /// Release administration: Keys to remove (comma-separated)
  ///
  /// In en, this message translates to:
  /// **'Keys to remove (comma-separated)'**
  String get rel_admin_keys_to_remove_comma_separated;

  /// Release administration: Saved and applied by the gateway.
  ///
  /// In en, this message translates to:
  /// **'Saved and applied by the gateway.'**
  String get rel_admin_saved_and_applied_by_the_gateway;

  /// Release administration: Saved. A gateway restart may be required.
  ///
  /// In en, this message translates to:
  /// **'Saved. A gateway restart may be required.'**
  String get rel_admin_saved_a_gateway_restart_may_be_required;

  /// Release administration: Create signed route
  ///
  /// In en, this message translates to:
  /// **'Create signed route'**
  String get rel_admin_create_signed_route;

  /// Release administration: Route ID
  ///
  /// In en, this message translates to:
  /// **'Route ID'**
  String get rel_admin_route_id;

  /// Release administration: Signature
  ///
  /// In en, this message translates to:
  /// **'Signature'**
  String get rel_admin_signature;

  /// Release administration: Events (comma-separated)
  ///
  /// In en, this message translates to:
  /// **'Events (comma-separated)'**
  String get rel_admin_events_comma_separated;

  /// Release administration: Delivery target
  ///
  /// In en, this message translates to:
  /// **'Delivery target'**
  String get rel_admin_delivery_target;

  /// Release administration: Skills (comma-separated)
  ///
  /// In en, this message translates to:
  /// **'Skills (comma-separated)'**
  String get rel_admin_skills_comma_separated;

  /// Release administration: Delivery mode
  ///
  /// In en, this message translates to:
  /// **'Delivery mode'**
  String get rel_admin_delivery_mode;

  /// Release administration: Delivery chat ID (optional)
  ///
  /// In en, this message translates to:
  /// **'Delivery chat ID (optional)'**
  String get rel_admin_delivery_chat_id_optional;

  /// Release administration: Hide signing secret
  ///
  /// In en, this message translates to:
  /// **'Hide signing secret'**
  String get rel_admin_hide_signing_secret;

  /// Release administration: Reveal signing secret
  ///
  /// In en, this message translates to:
  /// **'Reveal signing secret'**
  String get rel_admin_reveal_signing_secret;

  /// Release administration: Edit persona
  ///
  /// In en, this message translates to:
  /// **'Edit persona'**
  String get rel_admin_edit_persona;

  /// Release administration: Portable profile bundle
  ///
  /// In en, this message translates to:
  /// **'Portable profile bundle'**
  String get rel_admin_portable_profile_bundle;

  /// Release administration: Clone profile
  ///
  /// In en, this message translates to:
  /// **'Clone profile'**
  String get rel_admin_clone_profile;

  /// Release administration: Rename display label
  ///
  /// In en, this message translates to:
  /// **'Rename display label'**
  String get rel_admin_rename_display_label;

  /// Release administration: Rename profile
  ///
  /// In en, this message translates to:
  /// **'Rename profile'**
  String get rel_admin_rename_profile;

  /// Release administration: New name
  ///
  /// In en, this message translates to:
  /// **'New name'**
  String get rel_admin_new_name;

  /// Release administration: Rename verified.
  ///
  /// In en, this message translates to:
  /// **'Rename verified.'**
  String get rel_admin_rename_verified;

  /// Release administration: Delete profile
  ///
  /// In en, this message translates to:
  /// **'Delete profile'**
  String get rel_admin_delete_profile;

  /// Release administration: Profile ID to delete
  ///
  /// In en, this message translates to:
  /// **'Profile ID to delete'**
  String get rel_admin_profile_id_to_delete;

  /// Release administration: Profile deleted.
  ///
  /// In en, this message translates to:
  /// **'Profile deleted.'**
  String get rel_admin_profile_deleted;

  /// Release administration: Profile deleted. Server identity cleanup is still pending.
  ///
  /// In en, this message translates to:
  /// **'Profile deleted. Server identity cleanup is still pending.'**
  String get rel_admin_profile_deleted_server_identity_cleanup_is_still_pending;

  /// Release administration: Export profile archive
  ///
  /// In en, this message translates to:
  /// **'Export profile archive'**
  String get rel_admin_export_profile_archive;

  /// Release administration: Import profile archive
  ///
  /// In en, this message translates to:
  /// **'Import profile archive'**
  String get rel_admin_import_profile_archive;

  /// Release administration: Import a trusted profile
  ///
  /// In en, this message translates to:
  /// **'Import a trusted profile'**
  String get rel_admin_import_a_trusted_profile;

  /// Release administration: Absolute archive path on gateway
  ///
  /// In en, this message translates to:
  /// **'Absolute archive path on gateway'**
  String get rel_admin_absolute_archive_path_on_gateway;

  /// Release administration: Messaging channels
  ///
  /// In en, this message translates to:
  /// **'Messaging channels'**
  String get rel_admin_messaging_channels;

  /// Release administration: DM pairing requests
  ///
  /// In en, this message translates to:
  /// **'DM pairing requests'**
  String get rel_admin_dm_pairing_requests;

  /// Release administration: No pending or approved users.
  ///
  /// In en, this message translates to:
  /// **'No pending or approved users.'**
  String get rel_admin_no_pending_or_approved_users;

  /// Release administration: Legacy pairing: no verifiable request ID. Ask the user to pair again.
  ///
  /// In en, this message translates to:
  /// **'Legacy pairing: no verifiable request ID. Ask the user to pair again.'**
  String get rel_admin_legacy_pairing_no_verifiable_request_id_ask_the_user;

  /// Release administration: Pairing change verified.
  ///
  /// In en, this message translates to:
  /// **'Pairing change verified.'**
  String get rel_admin_pairing_change_verified;

  /// Release administration: Create Telegram bot by QR
  ///
  /// In en, this message translates to:
  /// **'Create Telegram bot by QR'**
  String get rel_admin_create_telegram_bot_by_qr;

  /// Release administration: Create Telegram bot
  ///
  /// In en, this message translates to:
  /// **'Create Telegram bot'**
  String get rel_admin_create_telegram_bot;

  /// Release administration: Bot name
  ///
  /// In en, this message translates to:
  /// **'Bot name'**
  String get rel_admin_bot_name;

  /// Release administration: Telegram bot creation QR code
  ///
  /// In en, this message translates to:
  /// **'Telegram bot creation QR code'**
  String get rel_admin_telegram_bot_creation_qr_code;

  /// Release administration: Check Telegram pairing
  ///
  /// In en, this message translates to:
  /// **'Check Telegram pairing'**
  String get rel_admin_check_telegram_pairing;

  /// Release administration: Waiting for Telegram.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Telegram.'**
  String get rel_admin_waiting_for_telegram;

  /// Release administration: Apply Telegram bot
  ///
  /// In en, this message translates to:
  /// **'Apply Telegram bot'**
  String get rel_admin_apply_telegram_bot;

  /// Release administration: Allowed numeric user IDs
  ///
  /// In en, this message translates to:
  /// **'Allowed numeric user IDs'**
  String get rel_admin_allowed_numeric_user_ids;

  /// Release administration: Saved. Restart still required.
  ///
  /// In en, this message translates to:
  /// **'Saved. Restart still required.'**
  String get rel_admin_saved_restart_still_required;

  /// Release administration: Saved; gateway restart requested.
  ///
  /// In en, this message translates to:
  /// **'Saved; gateway restart requested.'**
  String get rel_admin_saved_gateway_restart_requested;

  /// Release administration: Cancel Telegram setup
  ///
  /// In en, this message translates to:
  /// **'Cancel Telegram setup'**
  String get rel_admin_cancel_telegram_setup;

  /// Release administration: Inbound webhooks
  ///
  /// In en, this message translates to:
  /// **'Inbound webhooks'**
  String get rel_admin_inbound_webhooks;

  /// Release administration: Enable webhook service
  ///
  /// In en, this message translates to:
  /// **'Enable webhook service'**
  String get rel_admin_enable_webhook_service;

  /// Release administration: Enable webhooks
  ///
  /// In en, this message translates to:
  /// **'Enable webhooks'**
  String get rel_admin_enable_webhooks;

  /// Release administration: Enabled. Restart still required.
  ///
  /// In en, this message translates to:
  /// **'Enabled. Restart still required.'**
  String get rel_admin_enabled_restart_still_required;

  /// Release administration: Enabled; restart requested.
  ///
  /// In en, this message translates to:
  /// **'Enabled; restart requested.'**
  String get rel_admin_enabled_restart_requested;

  /// Release administration: Route change verified.
  ///
  /// In en, this message translates to:
  /// **'Route change verified.'**
  String get rel_admin_route_change_verified;

  /// Release administration: Delete route
  ///
  /// In en, this message translates to:
  /// **'Delete route'**
  String get rel_admin_delete_route;

  /// Release administration: Disable route
  ///
  /// In en, this message translates to:
  /// **'Disable route'**
  String get rel_admin_disable_route;

  /// Release administration: Enable route
  ///
  /// In en, this message translates to:
  /// **'Enable route'**
  String get rel_admin_enable_route;

  /// Release administration: Back up entire agent home
  ///
  /// In en, this message translates to:
  /// **'Back up entire agent home'**
  String get rel_admin_back_up_entire_agent_home;

  /// Release administration: Transfer to a Cloud agent
  ///
  /// In en, this message translates to:
  /// **'Transfer to a Cloud agent'**
  String get rel_admin_transfer_to_a_cloud_agent;

  /// Release administration: Check backup progress
  ///
  /// In en, this message translates to:
  /// **'Check backup progress'**
  String get rel_admin_check_backup_progress;

  /// Release administration: Save backup to this device
  ///
  /// In en, this message translates to:
  /// **'Save backup to this device'**
  String get rel_admin_save_backup_to_this_device;

  /// Release administration: Save sensitive full-home archive
  ///
  /// In en, this message translates to:
  /// **'Save sensitive full-home archive'**
  String get rel_admin_save_sensitive_full_home_archive;

  /// Release administration: Save cancelled.
  ///
  /// In en, this message translates to:
  /// **'Save cancelled.'**
  String get rel_admin_save_cancelled;

  /// Release administration: Backup saved.
  ///
  /// In en, this message translates to:
  /// **'Backup saved.'**
  String get rel_admin_backup_saved;

  /// Release administration: Up to 32 MiB. Larger archives remain on the gateway.
  ///
  /// In en, this message translates to:
  /// **'Up to 32 MiB. Larger archives remain on the gateway.'**
  String get rel_admin_up_to_32_mib_larger_archives_remain_on_the_gateway;

  /// Release administration: Save the persona for {scope}.
  ///
  /// In en, this message translates to:
  /// **'Save the persona for {scope}.'**
  String rel_admin_persona_scope(String scope);

  /// Release administration: Configure {name}
  ///
  /// In en, this message translates to:
  /// **'Configure {name}'**
  String rel_admin_configure_channel(String name);

  /// Release administration: Applies to {scope}. Blank keeps an existing value. To remove a value, list its key below.
  ///
  /// In en, this message translates to:
  /// **'Applies to {scope}. Blank keeps an existing value. To remove a value, list its key below.'**
  String rel_admin_channel_warning(String scope);

  /// Release administration: Applies to {scope}. Use a unique name. The gateway creates a signing secret. If another operator creates the name simultaneously the host may replace that route.
  ///
  /// In en, this message translates to:
  /// **'Applies to {scope}. Use a unique name. The gateway creates a signing secret. If another operator creates the name simultaneously the host may replace that route.'**
  String rel_admin_hook_warning(String scope);

  /// Release administration: Created {url}. Store the signing secret before leaving.
  ///
  /// In en, this message translates to:
  /// **'Created {url}. Store the signing secret before leaving.'**
  String rel_admin_hook_created(String url);

  /// Release administration: Copy settings, skills, persona and potentially provider credentials from {scope}. Messaging tokens are not requested.
  ///
  /// In en, this message translates to:
  /// **'Copy settings, skills, persona and potentially provider credentials from {scope}. Messaging tokens are not requested.'**
  String rel_admin_clone_warning(String scope);

  /// Release administration: Cloned {source} to {destination}.
  ///
  /// In en, this message translates to:
  /// **'Cloned {source} to {destination}.'**
  String rel_admin_cloned(String source, String destination);

  /// Release administration: Rename {name}
  ///
  /// In en, this message translates to:
  /// **'Rename {name}'**
  String rel_admin_rename_target(String name);

  /// Release administration: Change the presentation label for {scope}. Its ID stays default.
  ///
  /// In en, this message translates to:
  /// **'Change the presentation label for {scope}. Its ID stays default.'**
  String rel_admin_rename_label_warning(String scope);

  /// Release administration: Rename {scope} on the server. A running gateway may stop.
  ///
  /// In en, this message translates to:
  /// **'Rename {scope} on the server. A running gateway may stop.'**
  String rel_admin_rename_warning(String scope);

  /// Release administration: Delete {name}
  ///
  /// In en, this message translates to:
  /// **'Delete {name}'**
  String rel_admin_delete_target(String name);

  /// Release administration: Permanently delete {scope}, including sessions and credentials. Type the exact profile ID.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete {scope}, including sessions and credentials. Type the exact profile ID.'**
  String rel_admin_delete_profile_warning(String scope);

  /// Release administration: Export {name}
  ///
  /// In en, this message translates to:
  /// **'Export {name}'**
  String rel_admin_export_target(String name);

  /// Release administration: Create a .tar.gz on {scope}. Known credential stores are excluded, but private data can remain. Review before sharing.
  ///
  /// In en, this message translates to:
  /// **'Create a .tar.gz on {scope}. Known credential stores are excluded, but private data can remain. Review before sharing.'**
  String rel_admin_export_warning(String scope);

  /// Release administration: Archive on {gateway}: {path}
  ///
  /// In en, this message translates to:
  /// **'Archive on {gateway}: {path}'**
  String rel_admin_archive_on(String gateway, String path);

  /// Release administration: Use a reviewed .tar.gz already on {gateway}. It can contain plugins, scripts and schedules. A new profile ID is required.
  ///
  /// In en, this message translates to:
  /// **'Use a reviewed .tar.gz already on {gateway}. It can contain plugins, scripts and schedules. A new profile ID is required.'**
  String rel_admin_import_warning(String gateway);

  /// Release administration: Imported {name}.
  ///
  /// In en, this message translates to:
  /// **'Imported {name}.'**
  String rel_admin_imported(String name);

  /// Release administration: Approve {user}
  ///
  /// In en, this message translates to:
  /// **'Approve {user}'**
  String rel_admin_approve_user(String user);

  /// Release administration: Revoke {user}
  ///
  /// In en, this message translates to:
  /// **'Revoke {user}'**
  String rel_admin_revoke_user(String user);

  /// Release administration: {platform} on {scope}: allow this user’s messaging access.
  ///
  /// In en, this message translates to:
  /// **'{platform} on {scope}: allow this user’s messaging access.'**
  String rel_admin_allow_pair(String platform, String scope);

  /// Release administration: {platform} on {scope}: remove this user’s messaging access.
  ///
  /// In en, this message translates to:
  /// **'{platform} on {scope}: remove this user’s messaging access.'**
  String rel_admin_remove_pair(String platform, String scope);

  /// Release administration: Start a Telegram pairing on {scope} using the gateway’s setup service.
  ///
  /// In en, this message translates to:
  /// **'Start a Telegram pairing on {scope} using the gateway’s setup service.'**
  String rel_admin_telegram_start(String scope);

  /// Release administration: Expires: {time}
  ///
  /// In en, this message translates to:
  /// **'Expires: {time}'**
  String rel_admin_expires(String time);

  /// Release administration: Enable @{bot} on {scope} and attempt a gateway restart. Only the listed users may message it.
  ///
  /// In en, this message translates to:
  /// **'Enable @{bot} on {scope} and attempt a gateway restart. Only the listed users may message it.'**
  String rel_admin_telegram_apply(String bot, String scope);

  /// Release administration: Enable inbound webhooks on {scope} and attempt a gateway restart.
  ///
  /// In en, this message translates to:
  /// **'Enable inbound webhooks on {scope} and attempt a gateway restart.'**
  String rel_admin_hooks_enable(String scope);

  /// Release administration: Disable {name}
  ///
  /// In en, this message translates to:
  /// **'Disable {name}'**
  String rel_admin_disable_target(String name);

  /// Release administration: Enable {name}
  ///
  /// In en, this message translates to:
  /// **'Enable {name}'**
  String rel_admin_enable_target(String name);

  /// Release administration: Change exactly {name} on {scope}.
  ///
  /// In en, this message translates to:
  /// **'Change exactly {name} on {scope}.'**
  String rel_admin_hook_change(String name, String scope);

  /// Release administration: This is not an Ares settings backup. Save all profiles, sessions and credentials on {gateway}. The archive is sensitive.
  ///
  /// In en, this message translates to:
  /// **'This is not an Ares settings backup. Save all profiles, sessions and credentials on {gateway}. The archive is sensitive.'**
  String rel_admin_backup_warning(String gateway);

  /// Release administration: Backup started on {gateway}.
  ///
  /// In en, this message translates to:
  /// **'Backup started on {gateway}.'**
  String rel_admin_backup_started(String gateway);

  /// Release administration: Backup verified on {gateway}: {path}
  ///
  /// In en, this message translates to:
  /// **'Backup verified on {gateway}: {path}'**
  String rel_admin_backup_verified(String gateway, String path);

  /// Release administration: Backup still running on {gateway}.
  ///
  /// In en, this message translates to:
  /// **'Backup still running on {gateway}.'**
  String rel_admin_backup_running(String gateway);

  /// Release administration: yes
  ///
  /// In en, this message translates to:
  /// **'yes'**
  String get rel_admin_choice_yes;

  /// Release administration: no
  ///
  /// In en, this message translates to:
  /// **'no'**
  String get rel_admin_choice_no;

  /// Release administration: generic
  ///
  /// In en, this message translates to:
  /// **'generic'**
  String get rel_admin_choice_generic;

  /// Release administration: log
  ///
  /// In en, this message translates to:
  /// **'log'**
  String get rel_admin_choice_log;

  /// Release administration: email
  ///
  /// In en, this message translates to:
  /// **'email'**
  String get rel_admin_choice_email;

  /// Release administration: github_comment
  ///
  /// In en, this message translates to:
  /// **'github_comment'**
  String get rel_admin_choice_github_comment;

  /// Release administration: Agent processes event
  ///
  /// In en, this message translates to:
  /// **'Agent processes event'**
  String get rel_admin_choice_agent;

  /// Release administration: Direct delivery
  ///
  /// In en, this message translates to:
  /// **'Direct delivery'**
  String get rel_admin_choice_direct;

  /// Release administration: configured
  ///
  /// In en, this message translates to:
  /// **'configured'**
  String get rel_admin_configured;

  /// Release administration: pending_restart
  ///
  /// In en, this message translates to:
  /// **'pending_restart'**
  String get rel_admin_state_pending_restart;

  /// Release administration: unknown
  ///
  /// In en, this message translates to:
  /// **'unknown'**
  String get rel_admin_state_unknown;

  /// Release administration: connected
  ///
  /// In en, this message translates to:
  /// **'connected'**
  String get rel_admin_state_connected;

  /// Release administration: disconnected
  ///
  /// In en, this message translates to:
  /// **'disconnected'**
  String get rel_admin_state_disconnected;

  /// Release administration: disabled
  ///
  /// In en, this message translates to:
  /// **'disabled'**
  String get rel_admin_state_disabled;

  /// Release administration: enabled
  ///
  /// In en, this message translates to:
  /// **'enabled'**
  String get rel_admin_state_enabled;

  /// Release administration: running
  ///
  /// In en, this message translates to:
  /// **'running'**
  String get rel_admin_state_running;

  /// Release administration: stopped
  ///
  /// In en, this message translates to:
  /// **'stopped'**
  String get rel_admin_state_stopped;

  /// Release administration: error
  ///
  /// In en, this message translates to:
  /// **'error'**
  String get rel_admin_state_error;

  /// Release administration: not_configured
  ///
  /// In en, this message translates to:
  /// **'not_configured'**
  String get rel_admin_state_not_configured;

  /// Release administration: startup_failed
  ///
  /// In en, this message translates to:
  /// **'startup_failed'**
  String get rel_admin_state_startup_failed;

  /// Release administration: gateway_stopped
  ///
  /// In en, this message translates to:
  /// **'gateway_stopped'**
  String get rel_admin_state_gateway_stopped;

  /// Release administration: connecting
  ///
  /// In en, this message translates to:
  /// **'connecting'**
  String get rel_admin_state_connecting;

  /// Release administration: retrying
  ///
  /// In en, this message translates to:
  /// **'retrying'**
  String get rel_admin_state_retrying;

  /// Release administration: fatal
  ///
  /// In en, this message translates to:
  /// **'fatal'**
  String get rel_admin_state_fatal;

  /// Release administration: Unsupported or oversized profile archive.
  ///
  /// In en, this message translates to:
  /// **'Unsupported or oversized profile archive.'**
  String get rel_admin_unsupported_or_oversized_profile_archive;

  /// Release administration: Current layout
  ///
  /// In en, this message translates to:
  /// **'Current layout'**
  String get rel_admin_current_layout;

  /// Release administration: One pane
  ///
  /// In en, this message translates to:
  /// **'One pane'**
  String get rel_admin_one_pane;

  /// Release administration: Stacked
  ///
  /// In en, this message translates to:
  /// **'Stacked'**
  String get rel_admin_stacked;

  /// Release administration: Side by side
  ///
  /// In en, this message translates to:
  /// **'Side by side'**
  String get rel_admin_side_by_side;

  /// Release administration: No supported appearance in this profile.
  ///
  /// In en, this message translates to:
  /// **'No supported appearance in this profile.'**
  String get rel_admin_no_supported_appearance_in_this_profile;

  /// Release administration: Review appearance saved with this profile
  ///
  /// In en, this message translates to:
  /// **'Review appearance saved with this profile'**
  String get rel_admin_review_appearance_saved_with_this_profile;

  /// Release administration: Applies only to this named profile on this device. An imported arrangement starts with empty panes; choose its chats yourself.
  ///
  /// In en, this message translates to:
  /// **'Applies only to this named profile on this device. An imported arrangement starts with empty panes; choose its chats yourself.'**
  String get rel_admin_applies_only_to_this_named_profile_on_this_device;

  /// Release administration: Apply to this profile on this device
  ///
  /// In en, this message translates to:
  /// **'Apply to this profile on this device'**
  String get rel_admin_apply_to_this_profile_on_this_device;

  /// Release administration: Export prepares a .tar.gz on the gateway. Review its portable files before saving a copy here. Import opens a local archive for review; opening alone uploads nothing.
  ///
  /// In en, this message translates to:
  /// **'Export prepares a .tar.gz on the gateway. Review its portable files before saving a copy here. Import opens a local archive for review; opening alone uploads nothing.'**
  String get rel_admin_export_prepares_a_tar_gz_on_the_gateway_review;

  /// Release administration: Prepare profile export
  ///
  /// In en, this message translates to:
  /// **'Prepare profile export'**
  String get rel_admin_prepare_profile_export;

  /// Release administration: Open .tar.gz from this device
  ///
  /// In en, this message translates to:
  /// **'Open .tar.gz from this device'**
  String get rel_admin_open_tar_gz_from_this_device;

  /// Release administration: Only selected text files travel. Review for secrets and private information. Config, skills and schedules can change what the new profile does.
  ///
  /// In en, this message translates to:
  /// **'Only selected text files travel. Review for secrets and private information. Config, skills and schedules can change what the new profile does.'**
  String get rel_admin_only_selected_text_files_travel_review_for_secrets_and;

  /// Release administration: Include this reviewed file
  ///
  /// In en, this message translates to:
  /// **'Include this reviewed file'**
  String get rel_admin_include_this_reviewed_file;

  /// Release administration: Apply appearance to the new profile on this device
  ///
  /// In en, this message translates to:
  /// **'Apply appearance to the new profile on this device'**
  String get rel_admin_apply_appearance_to_the_new_profile_on_this_device;

  /// Release administration: Imports colours and pane sizes, never chats, tools or session IDs.
  ///
  /// In en, this message translates to:
  /// **'Imports colours and pane sizes, never chats, tools or session IDs.'**
  String
  get rel_admin_imports_colours_and_pane_sizes_never_chats_tools_or_session_ids;

  /// Release administration: The gateway retains a private staged copy. Import creates a new profile; it will not replace an existing one.
  ///
  /// In en, this message translates to:
  /// **'The gateway retains a private staged copy. Import creates a new profile; it will not replace an existing one.'**
  String get rel_admin_the_gateway_retains_a_private_staged_copy_import_creates;

  /// Release administration:  Appearance not applied: the gateway did not confirm the reviewed overlay.
  ///
  /// In en, this message translates to:
  /// **' Appearance not applied: the gateway did not confirm the reviewed overlay.'**
  String get rel_admin_appearance_not_applied_the_gateway_did_not_confirm_the;

  /// Release administration:  Appearance applied on this device.
  ///
  /// In en, this message translates to:
  /// **' Appearance applied on this device.'**
  String get rel_admin_appearance_applied_on_this_device;

  /// Release administration:  Appearance was not saved on this device.
  ///
  /// In en, this message translates to:
  /// **' Appearance was not saved on this device.'**
  String get rel_admin_appearance_was_not_saved_on_this_device;

  /// Release administration: Save reviewed profile bundle
  ///
  /// In en, this message translates to:
  /// **'Save reviewed profile bundle'**
  String get rel_admin_save_reviewed_profile_bundle;

  /// Release administration: Profile bundle saved.
  ///
  /// In en, this message translates to:
  /// **'Profile bundle saved.'**
  String get rel_admin_profile_bundle_saved;

  /// Release administration: Import selected files
  ///
  /// In en, this message translates to:
  /// **'Import selected files'**
  String get rel_admin_import_selected_files;

  /// Release administration: Save selected files to device
  ///
  /// In en, this message translates to:
  /// **'Save selected files to device'**
  String get rel_admin_save_selected_files_to_device;

  /// Release administration: {layout} · {percent}% first pane
  ///
  /// In en, this message translates to:
  /// **'{layout} · {percent}% first pane'**
  String rel_admin_layout_first_pane(String layout, String percent);

  /// Release administration: Skin: {skin} · Mode: {mode} · {layout}
  ///
  /// In en, this message translates to:
  /// **'Skin: {skin} · Mode: {mode} · {layout}'**
  String rel_admin_appearance_summary(String skin, String mode, String layout);

  /// Release administration: Appearance applied to {gateway} / {profile}.
  ///
  /// In en, this message translates to:
  /// **'Appearance applied to {gateway} / {profile}.'**
  String rel_admin_appearance_applied(String gateway, String profile);

  /// Release administration: Bundle: {profile} · {count} reviewable files · {omitted} omitted
  ///
  /// In en, this message translates to:
  /// **'Bundle: {profile} · {count} reviewable files · {omitted} omitted'**
  String rel_admin_bundle_summary(String profile, String count, String omitted);

  /// Release administration: Imported {name} on {gateway}.
  ///
  /// In en, this message translates to:
  /// **'Imported {name} on {gateway}.'**
  String rel_admin_imported_on(String name, String gateway);

  /// Release administration: unchanged
  ///
  /// In en, this message translates to:
  /// **'unchanged'**
  String get rel_admin_unchanged;

  /// Release administration: system
  ///
  /// In en, this message translates to:
  /// **'system'**
  String get rel_admin_mode_system;

  /// Release administration: light
  ///
  /// In en, this message translates to:
  /// **'light'**
  String get rel_admin_mode_light;

  /// Release administration: dark
  ///
  /// In en, this message translates to:
  /// **'dark'**
  String get rel_admin_mode_dark;

  /// Release administration: classic
  ///
  /// In en, this message translates to:
  /// **'classic'**
  String get rel_admin_skin_classic;

  /// Release administration: midnight
  ///
  /// In en, this message translates to:
  /// **'midnight'**
  String get rel_admin_skin_midnight;

  /// Release administration: ember
  ///
  /// In en, this message translates to:
  /// **'ember'**
  String get rel_admin_skin_ember;

  /// Release administration: mono
  ///
  /// In en, this message translates to:
  /// **'mono'**
  String get rel_admin_skin_mono;

  /// Release administration: cyberpunk
  ///
  /// In en, this message translates to:
  /// **'cyberpunk'**
  String get rel_admin_skin_cyberpunk;

  /// Release administration: slate
  ///
  /// In en, this message translates to:
  /// **'slate'**
  String get rel_admin_skin_slate;

  /// Release administration: No available Cloud agents in this account.
  ///
  /// In en, this message translates to:
  /// **'No available Cloud agents in this account.'**
  String get rel_admin_no_available_cloud_agents_in_this_account;

  /// Release administration: The previous undo receipt could not be verified. No change was made.
  ///
  /// In en, this message translates to:
  /// **'The previous undo receipt could not be verified. No change was made.'**
  String get rel_admin_the_previous_undo_receipt_could_not_be_verified_no;

  /// Release administration: Transfer to Cloud
  ///
  /// In en, this message translates to:
  /// **'Transfer to Cloud'**
  String get rel_admin_transfer_to_cloud;

  /// Release administration: Connection changed. Leave this page. A restore already submitted may continue.
  ///
  /// In en, this message translates to:
  /// **'Connection changed. Leave this page. A restore already submitted may continue.'**
  String
  get rel_admin_connection_changed_leave_this_page_a_restore_already_submitted;

  /// Release administration: Find my Cloud agents
  ///
  /// In en, this message translates to:
  /// **'Find my Cloud agents'**
  String get rel_admin_find_my_cloud_agents;

  /// Release administration: Undo replaces the destination with its pre-transfer backup.
  ///
  /// In en, this message translates to:
  /// **'Undo replaces the destination with its pre-transfer backup.'**
  String
  get rel_admin_undo_replaces_the_destination_with_its_pre_transfer_backup;

  /// Release administration: Replace this Cloud agent with the entire source home, including credentials, conversations and files. The source is not deleted. Incoming messaging bots are switched off.
  ///
  /// In en, this message translates to:
  /// **'Replace this Cloud agent with the entire source home, including credentials, conversations and files. The source is not deleted. Incoming messaging bots are switched off.'**
  String get rel_admin_replace_this_cloud_agent_with_the_entire_source_home;

  /// Release administration: Type destination agent ID
  ///
  /// In en, this message translates to:
  /// **'Type destination agent ID'**
  String get rel_admin_type_destination_agent_id;

  /// Release administration: Could not retain the local undo receipt. Keep this page open.
  ///
  /// In en, this message translates to:
  /// **'Could not retain the local undo receipt. Keep this page open.'**
  String
  get rel_admin_could_not_retain_the_local_undo_receipt_keep_this_page_open;

  /// Release administration: Undo transfer
  ///
  /// In en, this message translates to:
  /// **'Undo transfer'**
  String get rel_admin_undo_transfer;

  /// Release administration: Replace Cloud agent
  ///
  /// In en, this message translates to:
  /// **'Replace Cloud agent'**
  String get rel_admin_replace_cloud_agent;

  /// Release administration: Local undo receipt forgotten. No remote backup was removed.
  ///
  /// In en, this message translates to:
  /// **'Local undo receipt forgotten. No remote backup was removed.'**
  String
  get rel_admin_local_undo_receipt_forgotten_no_remote_backup_was_removed;

  /// Release administration: Forget local undo receipt only
  ///
  /// In en, this message translates to:
  /// **'Forget local undo receipt only'**
  String get rel_admin_forget_local_undo_receipt_only;

  /// Release administration: Stop before restore
  ///
  /// In en, this message translates to:
  /// **'Stop before restore'**
  String get rel_admin_stop_before_restore;

  /// Release administration: Do not close this page. Restore runs on the destination and cannot be cancelled.
  ///
  /// In en, this message translates to:
  /// **'Do not close this page. Restore runs on the destination and cannot be cancelled.'**
  String get rel_admin_do_not_close_this_page_restore_runs_on_the;

  /// Release administration: Files restored; destination gateway needs attention.
  ///
  /// In en, this message translates to:
  /// **'Files restored; destination gateway needs attention.'**
  String get rel_admin_files_restored_destination_gateway_needs_attention;

  /// Release administration: Sign in to exactly one saved Ares connection for {origin}, then return here.
  ///
  /// In en, this message translates to:
  /// **'Sign in to exactly one saved Ares connection for {origin}, then return here.'**
  String rel_admin_transfer_sign_in(String origin);

  /// Release administration: Source: {gateway} / {profile}
  ///
  /// In en, this message translates to:
  /// **'Source: {gateway} / {profile}'**
  String rel_admin_transfer_source(String gateway, String profile);

  /// Release administration: Destination: {name} · {origin} / default
  ///
  /// In en, this message translates to:
  /// **'Destination: {name} · {origin} / default'**
  String rel_admin_transfer_destination(String name, String origin);

  /// Release administration: Agent ID: {id}
  ///
  /// In en, this message translates to:
  /// **'Agent ID: {id}'**
  String rel_admin_agent_id(String id);

  /// Release administration: Status: {phase}
  ///
  /// In en, this message translates to:
  /// **'Status: {phase}'**
  String rel_admin_transfer_status(String phase);

  /// Release administration: Copied {percent}%
  ///
  /// In en, this message translates to:
  /// **'Copied {percent}%'**
  String rel_admin_copied_percent(String percent);

  /// Release administration: Undo point on destination: {path}
  ///
  /// In en, this message translates to:
  /// **'Undo point on destination: {path}'**
  String rel_admin_undo_point(String path);

  /// Release administration: Messaging disabled: {channels}
  ///
  /// In en, this message translates to:
  /// **'Messaging disabled: {channels}'**
  String rel_admin_messaging_disabled(String channels);

  /// Release administration: prepared
  ///
  /// In en, this message translates to:
  /// **'prepared'**
  String get rel_admin_phase_prepared;

  /// Release administration: backup
  ///
  /// In en, this message translates to:
  /// **'backup'**
  String get rel_admin_phase_backup;

  /// Release administration: upload
  ///
  /// In en, this message translates to:
  /// **'upload'**
  String get rel_admin_phase_upload;

  /// Release administration: restore
  ///
  /// In en, this message translates to:
  /// **'restore'**
  String get rel_admin_phase_restore;

  /// Release administration: finished
  ///
  /// In en, this message translates to:
  /// **'finished'**
  String get rel_admin_phase_finished;

  /// Release administration: failed
  ///
  /// In en, this message translates to:
  /// **'failed'**
  String get rel_admin_phase_failed;

  /// Release administration: undo
  ///
  /// In en, this message translates to:
  /// **'undo'**
  String get rel_admin_phase_undo;

  /// Release administration: undone
  ///
  /// In en, this message translates to:
  /// **'undone'**
  String get rel_admin_phase_undone;

  /// Capability administration: Install blocked ({verdict}): {detail}
  ///
  /// In en, this message translates to:
  /// **'Install blocked ({verdict}): {detail}'**
  String rel_ops_cap_install_blocked(String verdict, String detail);

  /// Capability administration: Scan verdict: {verdict}. Confirm {requested} before installing.
  ///
  /// In en, this message translates to:
  /// **'Scan verdict: {verdict}. Confirm {requested} before installing.'**
  String rel_ops_cap_scan_confirm(String verdict, String requested);

  /// Capability administration: The gateway has not confirmed that {requested} is installed.
  ///
  /// In en, this message translates to:
  /// **'The gateway has not confirmed that {requested} is installed.'**
  String rel_ops_cap_install_unconfirmed(String requested);

  /// Capability administration: Edit {name}
  ///
  /// In en, this message translates to:
  /// **'Edit {name}'**
  String rel_ops_cap_edit_skill(String name);

  /// Capability administration: Archive {name}?
  ///
  /// In en, this message translates to:
  /// **'Archive {name}?'**
  String rel_ops_cap_archive_skill(String name);

  /// Archive confirmation. The command placeholder is the literal CLI command hermes curator restore; do not translate or alter the command.
  ///
  /// In en, this message translates to:
  /// **'The skill is archived and can be restored with {command}.'**
  String rel_ops_cap_archive_explanation(String command);

  /// Capability administration: Install {name} anyway
  ///
  /// In en, this message translates to:
  /// **'Install {name} anyway'**
  String rel_ops_cap_install_anyway(String name);

  /// Capability administration: Install {name} despite the scan?
  ///
  /// In en, this message translates to:
  /// **'Install {name} despite the scan?'**
  String rel_ops_cap_install_despite_scan(String name);

  /// Capability administration: The security scan blocked {name}. This confirmation applies only to {name}.
  ///
  /// In en, this message translates to:
  /// **'The security scan blocked {name}. This confirmation applies only to {name}.'**
  String rel_ops_cap_scan_warning(String name);

  /// Capability administration: Accepting capabilities does not override the scan of {name}.
  ///
  /// In en, this message translates to:
  /// **'Accepting capabilities does not override the scan of {name}.'**
  String rel_ops_cap_accept_scan_warning(String name);

  /// Capability administration: Review scan for {name}
  ///
  /// In en, this message translates to:
  /// **'Review scan for {name}'**
  String rel_ops_cap_review_scan(String name);

  /// Plugin description followed by a warning about local Desktop app grants. Desktop is the app name; preserve it.
  ///
  /// In en, this message translates to:
  /// **'{description}\nFolder and preview-script grants stay in the Desktop app on that computer. Removing the plugin here does not revoke those local grants.'**
  String rel_ops_cap_desktop_grants(String description);

  /// Capability administration: Remove {name}?
  ///
  /// In en, this message translates to:
  /// **'Remove {name}?'**
  String rel_ops_cap_remove_plugin(String name);

  /// Capability administration: Probe {name}: {tools}
  ///
  /// In en, this message translates to:
  /// **'Probe {name}: {tools}'**
  String rel_ops_cap_probe_result(String name, String tools);

  /// Capability administration: Save tool grants for {connector}
  ///
  /// In en, this message translates to:
  /// **'Save tool grants for {connector}'**
  String rel_ops_cap_save_tool_grants_for(String connector);

  /// Capability administration: Backends for {name}
  ///
  /// In en, this message translates to:
  /// **'Backends for {name}'**
  String rel_ops_cap_backends_for(String name);

  /// Capability administration: Use {name}?
  ///
  /// In en, this message translates to:
  /// **'Use {name}?'**
  String rel_ops_cap_use_backend_confirmation(String name);

  /// Capability administration: Unlock {name}
  ///
  /// In en, this message translates to:
  /// **'Unlock {name}'**
  String rel_ops_cap_unlock_source(String name);

  /// Capability administration: Capabilities
  ///
  /// In en, this message translates to:
  /// **'Capabilities'**
  String get rel_ops_cap_capabilities;

  /// Capability administration: Plugins
  ///
  /// In en, this message translates to:
  /// **'Plugins'**
  String get rel_ops_cap_plugins;

  /// Capability administration: Connectors
  ///
  /// In en, this message translates to:
  /// **'Connectors'**
  String get rel_ops_cap_connectors;

  /// Capability administration: Backends
  ///
  /// In en, this message translates to:
  /// **'Backends'**
  String get rel_ops_cap_backends;

  /// Capability administration: Save skill
  ///
  /// In en, this message translates to:
  /// **'Save skill'**
  String get rel_ops_cap_save_skill;

  /// Capability administration: Archive
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get rel_ops_cap_archive;

  /// Capability administration: Hub identifier
  ///
  /// In en, this message translates to:
  /// **'Hub identifier'**
  String get rel_ops_cap_hub_identifier;

  /// Capability administration: Install
  ///
  /// In en, this message translates to:
  /// **'Install'**
  String get rel_ops_cap_install;

  /// Capability administration: Update all
  ///
  /// In en, this message translates to:
  /// **'Update all'**
  String get rel_ops_cap_update_all;

  /// Capability administration: Unlock
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get rel_ops_cap_unlock;

  /// Capability administration: Lock
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get rel_ops_cap_lock;

  /// Capability administration: This update adds capabilities. Nothing changed yet.
  ///
  /// In en, this message translates to:
  /// **'This update adds capabilities. Nothing changed yet.'**
  String get rel_ops_cap_this_update_adds_capabilities_nothing_changed_yet;

  /// Capability administration: The scan blocked this plugin.
  ///
  /// In en, this message translates to:
  /// **'The scan blocked this plugin.'**
  String get rel_ops_cap_the_scan_blocked_this_plugin;

  /// Capability administration: The plugin was not changed.
  ///
  /// In en, this message translates to:
  /// **'The plugin was not changed.'**
  String get rel_ops_cap_the_plugin_was_not_changed;

  /// Capability administration: Repository
  ///
  /// In en, this message translates to:
  /// **'Repository'**
  String get rel_ops_cap_repository;

  /// Capability administration: Install plugin
  ///
  /// In en, this message translates to:
  /// **'Install plugin'**
  String get rel_ops_cap_install_plugin;

  /// Capability administration: Update plugins
  ///
  /// In en, this message translates to:
  /// **'Update plugins'**
  String get rel_ops_cap_update_plugins;

  /// Capability administration: Accept capabilities
  ///
  /// In en, this message translates to:
  /// **'Accept capabilities'**
  String get rel_ops_cap_accept_capabilities;

  /// Capability administration: Update
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get rel_ops_cap_update;

  /// Capability administration: Remove desktop half
  ///
  /// In en, this message translates to:
  /// **'Remove desktop half'**
  String get rel_ops_cap_remove_desktop_half;

  /// Capability administration: Server name
  ///
  /// In en, this message translates to:
  /// **'Server name'**
  String get rel_ops_cap_server_name;

  /// Capability administration: Command
  ///
  /// In en, this message translates to:
  /// **'Command'**
  String get rel_ops_cap_command;

  /// Capability administration: HTTP URL
  ///
  /// In en, this message translates to:
  /// **'HTTP URL'**
  String get rel_ops_cap_http_url;

  /// Capability administration: Add server
  ///
  /// In en, this message translates to:
  /// **'Add server'**
  String get rel_ops_cap_add_server;

  /// Capability administration: Probe
  ///
  /// In en, this message translates to:
  /// **'Probe'**
  String get rel_ops_cap_probe;

  /// Capability administration: Probe failed.
  ///
  /// In en, this message translates to:
  /// **'Probe failed.'**
  String get rel_ops_cap_probe_failed;

  /// Capability administration: Logs
  ///
  /// In en, this message translates to:
  /// **'Logs'**
  String get rel_ops_cap_logs;

  /// Capability administration: MCP log
  ///
  /// In en, this message translates to:
  /// **'MCP log'**
  String get rel_ops_cap_mcp_log;

  /// Capability administration: Connector
  ///
  /// In en, this message translates to:
  /// **'Connector'**
  String get rel_ops_cap_connector;

  /// Capability administration: Account alias
  ///
  /// In en, this message translates to:
  /// **'Account alias'**
  String get rel_ops_cap_account_alias;

  /// Capability administration: Link account
  ///
  /// In en, this message translates to:
  /// **'Link account'**
  String get rel_ops_cap_link_account;

  /// Capability administration: Remove account
  ///
  /// In en, this message translates to:
  /// **'Remove account'**
  String get rel_ops_cap_remove_account;

  /// Capability administration: Tool connector
  ///
  /// In en, this message translates to:
  /// **'Tool connector'**
  String get rel_ops_cap_tool_connector;

  /// Capability administration: Load tools
  ///
  /// In en, this message translates to:
  /// **'Load tools'**
  String get rel_ops_cap_load_tools;

  /// Capability administration: Save tool grants
  ///
  /// In en, this message translates to:
  /// **'Save tool grants'**
  String get rel_ops_cap_save_tool_grants;

  /// Capability administration: This policy has no member revision, so tool grants stay unchanged.
  ///
  /// In en, this message translates to:
  /// **'This policy has no member revision, so tool grants stay unchanged.'**
  String
  get rel_ops_cap_this_policy_has_no_member_revision_so_tool_grants_stay_unchanged;

  /// Capability administration: Active
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get rel_ops_cap_active;

  /// Capability administration: Use
  ///
  /// In en, this message translates to:
  /// **'Use'**
  String get rel_ops_cap_use;

  /// Capability administration: Run setup
  ///
  /// In en, this message translates to:
  /// **'Run setup'**
  String get rel_ops_cap_run_setup;

  /// Capability administration: Terminal backends
  ///
  /// In en, this message translates to:
  /// **'Terminal backends'**
  String get rel_ops_cap_terminal_backends;

  /// Capability administration: This changes the terminal backend for this profile.
  ///
  /// In en, this message translates to:
  /// **'This changes the terminal backend for this profile.'**
  String get rel_ops_cap_this_changes_the_terminal_backend_for_this_profile;

  /// Capability administration: Use backend
  ///
  /// In en, this message translates to:
  /// **'Use backend'**
  String get rel_ops_cap_use_backend;

  /// Capability administration: Select
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get rel_ops_cap_select;

  /// Capability administration: Browser vault
  ///
  /// In en, this message translates to:
  /// **'Browser vault'**
  String get rel_ops_cap_browser_vault;

  /// Capability administration: Saved site logins, addresses and cards. Passwords stay in the secure fields and are not listed here.
  ///
  /// In en, this message translates to:
  /// **'Saved site logins, addresses and cards. Passwords stay in the secure fields and are not listed here.'**
  String
  get rel_ops_cap_saved_site_logins_addresses_and_cards_passwords_stay_in_the_secure_fields_and_are_not_listed_here;

  /// Capability administration: Remove saved item
  ///
  /// In en, this message translates to:
  /// **'Remove saved item'**
  String get rel_ops_cap_remove_saved_item;

  /// Capability administration: Delete this item?
  ///
  /// In en, this message translates to:
  /// **'Delete this item?'**
  String get rel_ops_cap_delete_this_item;

  /// Capability administration: Unlocked
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get rel_ops_cap_unlocked;

  /// Capability administration: Locked
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get rel_ops_cap_locked;

  /// Capability administration: Not detected
  ///
  /// In en, this message translates to:
  /// **'Not detected'**
  String get rel_ops_cap_not_detected;

  /// Capability administration: Master password
  ///
  /// In en, this message translates to:
  /// **'Master password'**
  String get rel_ops_cap_master_password;

  /// Capability administration: Login
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get rel_ops_cap_login;

  /// Capability administration: Address
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get rel_ops_cap_address;

  /// Capability administration: Card
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get rel_ops_cap_card;

  /// Capability administration: Label
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get rel_ops_cap_label;

  /// Capability administration: Site origin
  ///
  /// In en, this message translates to:
  /// **'Site origin'**
  String get rel_ops_cap_site_origin;

  /// Capability administration: Identifier
  ///
  /// In en, this message translates to:
  /// **'Identifier'**
  String get rel_ops_cap_identifier;

  /// Capability administration: Password
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get rel_ops_cap_password;

  /// Capability administration: Authenticator key
  ///
  /// In en, this message translates to:
  /// **'Authenticator key'**
  String get rel_ops_cap_authenticator_key;

  /// Capability administration: Street
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get rel_ops_cap_street;

  /// Capability administration: City
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get rel_ops_cap_city;

  /// Capability administration: Postal code
  ///
  /// In en, this message translates to:
  /// **'Postal code'**
  String get rel_ops_cap_postal_code;

  /// Capability administration: Country
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get rel_ops_cap_country;

  /// Capability administration: Name on card
  ///
  /// In en, this message translates to:
  /// **'Name on card'**
  String get rel_ops_cap_name_on_card;

  /// Capability administration: Card number
  ///
  /// In en, this message translates to:
  /// **'Card number'**
  String get rel_ops_cap_card_number;

  /// Capability administration: Expiry month
  ///
  /// In en, this message translates to:
  /// **'Expiry month'**
  String get rel_ops_cap_expiry_month;

  /// Capability administration: Expiry year
  ///
  /// In en, this message translates to:
  /// **'Expiry year'**
  String get rel_ops_cap_expiry_year;

  /// Capability administration: Security code
  ///
  /// In en, this message translates to:
  /// **'Security code'**
  String get rel_ops_cap_security_code;

  /// Capability administration: This gateway has no shared-metrics consent method.
  ///
  /// In en, this message translates to:
  /// **'This gateway has no shared-metrics consent method.'**
  String get rel_ops_cap_this_gateway_has_no_shared_metrics_consent_method;

  /// Capability administration: Agent policy
  ///
  /// In en, this message translates to:
  /// **'Agent policy'**
  String get rel_ops_cap_agent_policy;

  /// Capability administration: Loading policy
  ///
  /// In en, this message translates to:
  /// **'Loading policy'**
  String get rel_ops_cap_loading_policy;

  /// Capability administration: Approval timeout
  ///
  /// In en, this message translates to:
  /// **'Approval timeout'**
  String get rel_ops_cap_approval_timeout;

  /// Capability administration: Confirm MCP reloads
  ///
  /// In en, this message translates to:
  /// **'Confirm MCP reloads'**
  String get rel_ops_cap_confirm_mcp_reloads;

  /// Capability administration: Command allowlist
  ///
  /// In en, this message translates to:
  /// **'Command allowlist'**
  String get rel_ops_cap_command_allowlist;

  /// Capability administration: File checkpoints
  ///
  /// In en, this message translates to:
  /// **'File checkpoints'**
  String get rel_ops_cap_file_checkpoints;

  /// Capability administration: Checkpoint limit
  ///
  /// In en, this message translates to:
  /// **'Checkpoint limit'**
  String get rel_ops_cap_checkpoint_limit;

  /// Capability administration: Browser private URLs
  ///
  /// In en, this message translates to:
  /// **'Browser private URLs'**
  String get rel_ops_cap_browser_private_urls;

  /// Capability administration: Use my real browser profile
  ///
  /// In en, this message translates to:
  /// **'Use my real browser profile'**
  String get rel_ops_cap_use_my_real_browser_profile;

  /// Capability administration: Save policy
  ///
  /// In en, this message translates to:
  /// **'Save policy'**
  String get rel_ops_cap_save_policy;

  /// Capability administration: Shared metrics for this profile
  ///
  /// In en, this message translates to:
  /// **'Shared metrics for this profile'**
  String get rel_ops_cap_shared_metrics_for_this_profile;

  /// Capability administration: Send shared metrics
  ///
  /// In en, this message translates to:
  /// **'Send shared metrics'**
  String get rel_ops_cap_send_shared_metrics;

  /// Capability administration: Enter a label.
  ///
  /// In en, this message translates to:
  /// **'Enter a label.'**
  String get rel_ops_cap_error_enter_a_label;

  /// Capability administration: Enter a valid URL like https://example.com.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid URL like https://example.com.'**
  String get rel_ops_cap_error_enter_a_valid_url_like_https_example_com;

  /// Capability administration: Enter the identifier and password.
  ///
  /// In en, this message translates to:
  /// **'Enter the identifier and password.'**
  String get rel_ops_cap_error_enter_the_identifier_and_password;

  /// Capability administration: Enter the card name, number, expiry and security code.
  ///
  /// In en, this message translates to:
  /// **'Enter the card name, number, expiry and security code.'**
  String
  get rel_ops_cap_error_enter_the_card_name_number_expiry_and_security_code;

  /// Capability administration: Enter the street, city, postal code and country.
  ///
  /// In en, this message translates to:
  /// **'Enter the street, city, postal code and country.'**
  String get rel_ops_cap_error_enter_the_street_city_postal_code_and_country;

  /// Capability administration: The gateway returned a response that could not be read.
  ///
  /// In en, this message translates to:
  /// **'The gateway returned a response that could not be read.'**
  String
  get rel_ops_cap_error_the_gateway_returned_a_response_that_could_not_be_read;

  /// Capability administration: The gateway refused the request ({statusCode}).
  ///
  /// In en, this message translates to:
  /// **'The gateway refused the request ({statusCode}).'**
  String rel_ops_cap_error_the_gateway_refused_the_request_status(
    int statusCode,
  );

  /// Missing gateway socket error. The method placeholder is a JSON-RPC wire method; do not translate it.
  ///
  /// In en, this message translates to:
  /// **'This connection has no gateway socket, so {method} is unavailable.'**
  String
  rel_ops_cap_error_this_connection_has_no_gateway_socket_so_method_is_unavailable(
    String method,
  );

  /// Capability administration: Choose a skill.
  ///
  /// In en, this message translates to:
  /// **'Choose a skill.'**
  String get rel_ops_cap_error_choose_a_skill;

  /// Capability administration: The skill text was not returned.
  ///
  /// In en, this message translates to:
  /// **'The skill text was not returned.'**
  String get rel_ops_cap_error_the_skill_text_was_not_returned;

  /// Capability administration: The skill was not saved.
  ///
  /// In en, this message translates to:
  /// **'The skill was not saved.'**
  String get rel_ops_cap_error_the_skill_was_not_saved;

  /// Capability administration: The skill was not archived.
  ///
  /// In en, this message translates to:
  /// **'The skill was not archived.'**
  String get rel_ops_cap_error_the_skill_was_not_archived;

  /// Capability administration: The skill was not installed.
  ///
  /// In en, this message translates to:
  /// **'The skill was not installed.'**
  String get rel_ops_cap_error_the_skill_was_not_installed;

  /// Capability administration: Skill updates did not start.
  ///
  /// In en, this message translates to:
  /// **'Skill updates did not start.'**
  String get rel_ops_cap_error_skill_updates_did_not_start;

  /// Capability administration: The skill was not removed.
  ///
  /// In en, this message translates to:
  /// **'The skill was not removed.'**
  String get rel_ops_cap_error_the_skill_was_not_removed;

  /// Capability administration: Enter a skill or plugin identifier.
  ///
  /// In en, this message translates to:
  /// **'Enter a skill or plugin identifier.'**
  String get rel_ops_cap_error_enter_a_skill_or_plugin_identifier;

  /// Capability administration: Choose a plugin.
  ///
  /// In en, this message translates to:
  /// **'Choose a plugin.'**
  String get rel_ops_cap_error_choose_a_plugin;

  /// Capability administration: The plugin was not removed.
  ///
  /// In en, this message translates to:
  /// **'The plugin was not removed.'**
  String get rel_ops_cap_error_the_plugin_was_not_removed;

  /// Capability administration: The desktop half was not removed.
  ///
  /// In en, this message translates to:
  /// **'The desktop half was not removed.'**
  String get rel_ops_cap_error_the_desktop_half_was_not_removed;

  /// Capability administration: This gateway did not give the plugin a stable key.
  ///
  /// In en, this message translates to:
  /// **'This gateway did not give the plugin a stable key.'**
  String
  get rel_ops_cap_error_this_gateway_did_not_give_the_plugin_a_stable_key;

  /// Capability administration: The plugin was not changed.
  ///
  /// In en, this message translates to:
  /// **'The plugin was not changed.'**
  String get rel_ops_cap_error_the_plugin_was_not_changed;

  /// Capability administration: Choose a server.
  ///
  /// In en, this message translates to:
  /// **'Choose a server.'**
  String get rel_ops_cap_error_choose_a_server;

  /// Capability administration: Name the server.
  ///
  /// In en, this message translates to:
  /// **'Name the server.'**
  String get rel_ops_cap_error_name_the_server;

  /// Capability administration: Give the server a command or an http(s) URL.
  ///
  /// In en, this message translates to:
  /// **'Give the server a command or an http(s) URL.'**
  String get rel_ops_cap_error_give_the_server_a_command_or_an_http_s_url;

  /// Capability administration: Choose a toolset.
  ///
  /// In en, this message translates to:
  /// **'Choose a toolset.'**
  String get rel_ops_cap_error_choose_a_toolset;

  /// Capability administration: Tool backend status was not returned.
  ///
  /// In en, this message translates to:
  /// **'Tool backend status was not returned.'**
  String get rel_ops_cap_error_tool_backend_status_was_not_returned;

  /// Capability administration: Choose a provider.
  ///
  /// In en, this message translates to:
  /// **'Choose a provider.'**
  String get rel_ops_cap_error_choose_a_provider;

  /// Capability administration: This provider has no setup action.
  ///
  /// In en, this message translates to:
  /// **'This provider has no setup action.'**
  String get rel_ops_cap_error_this_provider_has_no_setup_action;

  /// Capability administration: Setup did not start.
  ///
  /// In en, this message translates to:
  /// **'Setup did not start.'**
  String get rel_ops_cap_error_setup_did_not_start;

  /// Capability administration: Choose a terminal backend.
  ///
  /// In en, this message translates to:
  /// **'Choose a terminal backend.'**
  String get rel_ops_cap_error_choose_a_terminal_backend;

  /// Capability administration: Name the connector.
  ///
  /// In en, this message translates to:
  /// **'Name the connector.'**
  String get rel_ops_cap_error_name_the_connector;

  /// Capability administration: Choose an account.
  ///
  /// In en, this message translates to:
  /// **'Choose an account.'**
  String get rel_ops_cap_error_choose_an_account;

  /// Capability administration: Reload the connector policy before changing tool grants.
  ///
  /// In en, this message translates to:
  /// **'Reload the connector policy before changing tool grants.'**
  String
  get rel_ops_cap_error_reload_the_connector_policy_before_changing_tool_grants;

  /// Capability administration: Choose an item.
  ///
  /// In en, this message translates to:
  /// **'Choose an item.'**
  String get rel_ops_cap_error_choose_an_item;

  /// Capability administration: Choose a source.
  ///
  /// In en, this message translates to:
  /// **'Choose a source.'**
  String get rel_ops_cap_error_choose_a_source;

  /// Capability administration: Enter the master password.
  ///
  /// In en, this message translates to:
  /// **'Enter the master password.'**
  String get rel_ops_cap_error_enter_the_master_password;

  /// Capability administration: Gateway config was not returned.
  ///
  /// In en, this message translates to:
  /// **'Gateway config was not returned.'**
  String get rel_ops_cap_error_gateway_config_was_not_returned;

  /// Capability administration: Choose a known approval mode.
  ///
  /// In en, this message translates to:
  /// **'Choose a known approval mode.'**
  String get rel_ops_cap_error_choose_a_known_approval_mode;

  /// Capability administration: Use a positive limit.
  ///
  /// In en, this message translates to:
  /// **'Use a positive limit.'**
  String get rel_ops_cap_error_use_a_positive_limit;

  /// Capability administration: The policy was not saved.
  ///
  /// In en, this message translates to:
  /// **'The policy was not saved.'**
  String get rel_ops_cap_error_the_policy_was_not_saved;

  /// Capability _capabilityValue display label for wire value manual. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'manual'**
  String get rel_ops_cap_value_manual;

  /// Capability _capabilityValue display label for wire value smart. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'smart'**
  String get rel_ops_cap_value_smart;

  /// Capability _capabilityValue display label for wire value off. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'off'**
  String get rel_ops_cap_value_off;

  /// Capability _capabilityValue display label for wire value safe. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'safe'**
  String get rel_ops_cap_value_safe;

  /// Capability _capabilityValue display label for wire value caution. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'caution'**
  String get rel_ops_cap_value_caution;

  /// Capability _capabilityValue display label for wire value dangerous. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'dangerous'**
  String get rel_ops_cap_value_dangerous;

  /// Capability _capabilityValue display label for wire value blocked. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'blocked'**
  String get rel_ops_cap_value_blocked;

  /// Capability _capabilityValue display label for wire value clean. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'clean'**
  String get rel_ops_cap_value_clean;

  /// Capability _capabilityValue display label for wire value ready. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'ready'**
  String get rel_ops_cap_value_ready;

  /// Capability _capabilityValue display label for wire value available. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'available'**
  String get rel_ops_cap_value_available;

  /// Capability _capabilityValue display label for wire value unavailable. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'unavailable'**
  String get rel_ops_cap_value_unavailable;

  /// Capability _capabilityValue display label for wire value enabled. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'enabled'**
  String get rel_ops_cap_value_enabled;

  /// Capability _capabilityValue display label for wire value disabled. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'disabled'**
  String get rel_ops_cap_value_disabled;

  /// Capability _capabilityValue display label for wire value active. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'active'**
  String get rel_ops_cap_value_active;

  /// Capability _capabilityValue display label for wire value inactive. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'inactive'**
  String get rel_ops_cap_value_inactive;

  /// Capability _capabilityValue display label for wire value installed. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'installed'**
  String get rel_ops_cap_value_installed;

  /// Capability _capabilityValue display label for wire value missing. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'missing'**
  String get rel_ops_cap_value_missing;

  /// Capability _capabilityValue display label for wire value configured. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'configured'**
  String get rel_ops_cap_value_configured;

  /// Capability _capabilityValue display label for wire value not_configured. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'not_configured'**
  String get rel_ops_cap_value_not_configured;

  /// Capability _capabilityValue display label for wire value error. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'error'**
  String get rel_ops_cap_value_error;

  /// Capability _capabilityValue display label for wire value unknown. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'unknown'**
  String get rel_ops_cap_value_unknown;

  /// Capability _capabilityValue display label for wire value login. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'login'**
  String get rel_ops_cap_value_login;

  /// Capability _capabilityValue display label for wire value address. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'address'**
  String get rel_ops_cap_value_address;

  /// Capability _capabilityValue display label for wire value payment. Keep wire identifiers unchanged; localise only this display label.
  ///
  /// In en, this message translates to:
  /// **'payment'**
  String get rel_ops_cap_value_payment;

  /// Terminal connection status.
  ///
  /// In en, this message translates to:
  /// **'Connecting…'**
  String get rel_ops_term_connecting;

  /// Terminal page: unbound.
  ///
  /// In en, this message translates to:
  /// **'No matching live session or host working directory. Open the owning chat first.'**
  String get rel_ops_term_unbound;

  /// Terminal page: unsupported.
  ///
  /// In en, this message translates to:
  /// **'This gateway does not offer this terminal capability. No local shell was started.'**
  String get rel_ops_term_unsupported;

  /// Terminal page: local pty unavailable.
  ///
  /// In en, this message translates to:
  /// **'The packaged local PTY is unavailable on this device.'**
  String get rel_ops_term_local_pty_unavailable;

  /// Terminal page: operation failed.
  ///
  /// In en, this message translates to:
  /// **'Could not open or control the terminal. Check the host, credentials and fingerprint. No fallback shell was started.'**
  String get rel_ops_term_operation_failed;

  /// Terminal page: input refused.
  ///
  /// In en, this message translates to:
  /// **'Input refused. Reopen the originating chat.'**
  String get rel_ops_term_input_refused;

  /// Terminal page: cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get rel_ops_term_cancel;

  /// Terminal page: confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get rel_ops_term_confirm;

  /// Terminal page: open device title.
  ///
  /// In en, this message translates to:
  /// **'Open a shell on this device?'**
  String get rel_ops_term_open_device_title;

  /// Terminal page: ssh shell.
  ///
  /// In en, this message translates to:
  /// **'SSH shell'**
  String get rel_ops_term_ssh_shell;

  /// Terminal page: local shell.
  ///
  /// In en, this message translates to:
  /// **'Local shell'**
  String get rel_ops_term_local_shell;

  /// Terminal page: connection lost.
  ///
  /// In en, this message translates to:
  /// **'Connection lost'**
  String get rel_ops_term_connection_lost;

  /// Terminal page: shell ended.
  ///
  /// In en, this message translates to:
  /// **'Shell ended'**
  String get rel_ops_term_shell_ended;

  /// Terminal page: no owner.
  ///
  /// In en, this message translates to:
  /// **'This chat has no authenticated gateway terminal owner. A URL or Cloud login alone does not grant a shell.'**
  String get rel_ops_term_no_owner;

  /// Terminal page: open gateway title.
  ///
  /// In en, this message translates to:
  /// **'Open a gateway shell?'**
  String get rel_ops_term_open_gateway_title;

  /// Terminal page: shell expired.
  ///
  /// In en, this message translates to:
  /// **'Shell ended or expired'**
  String get rel_ops_term_shell_expired;

  /// Terminal page: disconnected.
  ///
  /// In en, this message translates to:
  /// **'Disconnected'**
  String get rel_ops_term_disconnected;

  /// Terminal page: gateway shell.
  ///
  /// In en, this message translates to:
  /// **'Gateway shell'**
  String get rel_ops_term_gateway_shell;

  /// Terminal page: close body.
  ///
  /// In en, this message translates to:
  /// **'End this shell. To keep it running, hide the pane instead.'**
  String get rel_ops_term_close_body;

  /// Terminal page: closing.
  ///
  /// In en, this message translates to:
  /// **'Closing…'**
  String get rel_ops_term_closing;

  /// Terminal page: close unconfirmed.
  ///
  /// In en, this message translates to:
  /// **'Close not confirmed'**
  String get rel_ops_term_close_unconfirmed;

  /// Terminal page: processes require chat.
  ///
  /// In en, this message translates to:
  /// **'Agent processes require the authenticated owning chat.'**
  String get rel_ops_term_processes_require_chat;

  /// Terminal page: watching processes.
  ///
  /// In en, this message translates to:
  /// **'Watching this chat’s agent processes. Closing a mirror never stops its process.'**
  String get rel_ops_term_watching_processes;

  /// Terminal page: paste limit.
  ///
  /// In en, this message translates to:
  /// **'Paste is limited to 16 KiB.'**
  String get rel_ops_term_paste_limit;

  /// Terminal page: paste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get rel_ops_term_paste;

  /// Terminal page: select first.
  ///
  /// In en, this message translates to:
  /// **'Select terminal output first.'**
  String get rel_ops_term_select_first;

  /// Terminal page: open chat to insert.
  ///
  /// In en, this message translates to:
  /// **'Open the originating chat before inserting output.'**
  String get rel_ops_term_open_chat_to_insert;

  /// Terminal page: added to draft.
  ///
  /// In en, this message translates to:
  /// **'Added to the originating chat draft. Nothing was sent.'**
  String get rel_ops_term_added_to_draft;

  /// Terminal page: close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get rel_ops_term_close;

  /// Terminal page: add selection.
  ///
  /// In en, this message translates to:
  /// **'Add selection to chat draft'**
  String get rel_ops_term_add_selection;

  /// Terminal page: new terminal.
  ///
  /// In en, this message translates to:
  /// **'New terminal'**
  String get rel_ops_term_new_terminal;

  /// Terminal page: gateway terminal.
  ///
  /// In en, this message translates to:
  /// **'Gateway host terminal'**
  String get rel_ops_term_gateway_terminal;

  /// Terminal page: verified ssh terminal.
  ///
  /// In en, this message translates to:
  /// **'Verified SSH terminal'**
  String get rel_ops_term_verified_ssh_terminal;

  /// Terminal page: device local shell.
  ///
  /// In en, this message translates to:
  /// **'This device (local shell)'**
  String get rel_ops_term_device_local_shell;

  /// Terminal page: local unavailable mobile.
  ///
  /// In en, this message translates to:
  /// **'Local shell unavailable on mobile'**
  String get rel_ops_term_local_unavailable_mobile;

  /// Terminal page: watch processes.
  ///
  /// In en, this message translates to:
  /// **'Watch agent processes'**
  String get rel_ops_term_watch_processes;

  /// Terminal page: select output.
  ///
  /// In en, this message translates to:
  /// **'Select or copy output'**
  String get rel_ops_term_select_output;

  /// Terminal page: add selected output.
  ///
  /// In en, this message translates to:
  /// **'Add selected output to chat draft'**
  String get rel_ops_term_add_selected_output;

  /// Terminal page: review paste.
  ///
  /// In en, this message translates to:
  /// **'Review clipboard paste'**
  String get rel_ops_term_review_paste;

  /// Terminal page: reconnect.
  ///
  /// In en, this message translates to:
  /// **'Reconnect same shell'**
  String get rel_ops_term_reconnect;

  /// Terminal page: close mirror.
  ///
  /// In en, this message translates to:
  /// **'Close mirror'**
  String get rel_ops_term_close_mirror;

  /// Terminal page: close shell.
  ///
  /// In en, this message translates to:
  /// **'Close shell'**
  String get rel_ops_term_close_shell;

  /// Terminal page: empty.
  ///
  /// In en, this message translates to:
  /// **'Choose + to open a terminal. No shell starts automatically.'**
  String get rel_ops_term_empty;

  /// Terminal failure reason; English preserves the existing enum-name wording.
  ///
  /// In en, this message translates to:
  /// **'stale'**
  String get rel_ops_term_reason_stale;

  /// Terminal failure reason; English preserves the existing enum-name wording.
  ///
  /// In en, this message translates to:
  /// **'mismatch'**
  String get rel_ops_term_reason_mismatch;

  /// Terminal failure reason; English preserves the existing enum-name wording.
  ///
  /// In en, this message translates to:
  /// **'unbound'**
  String get rel_ops_term_reason_unbound;

  /// Terminal failure reason; English preserves the existing enum-name wording.
  ///
  /// In en, this message translates to:
  /// **'unsupported'**
  String get rel_ops_term_reason_unsupported;

  /// Terminal failure reason; English preserves the existing enum-name wording.
  ///
  /// In en, this message translates to:
  /// **'denied'**
  String get rel_ops_term_reason_denied;

  /// Terminal failure reason; English preserves the existing enum-name wording.
  ///
  /// In en, this message translates to:
  /// **'ineligible'**
  String get rel_ops_term_reason_ineligible;

  /// Terminal failure reason; English preserves the existing enum-name wording.
  ///
  /// In en, this message translates to:
  /// **'unavailable'**
  String get rel_ops_term_reason_unavailable;

  /// Terminal failure reason; English preserves the existing enum-name wording.
  ///
  /// In en, this message translates to:
  /// **'invalid'**
  String get rel_ops_term_reason_invalid;

  /// Terminal failure reason; English preserves the existing enum-name wording.
  ///
  /// In en, this message translates to:
  /// **'insecure'**
  String get rel_ops_term_reason_insecure;

  /// Terminal page: refused. Preserve server/user placeholder values.
  ///
  /// In en, this message translates to:
  /// **'Gateway refused this terminal operation ({reason}).'**
  String rel_ops_term_refused(String reason);

  /// Terminal page: open device body. Preserve server/user placeholder values.
  ///
  /// In en, this message translates to:
  /// **'This is the Ares device, not {connection}. The shell uses your app permissions and starts in app storage.'**
  String rel_ops_term_open_device_body(String connection);

  /// Terminal page: open gateway body. Preserve server/user placeholder values.
  ///
  /// In en, this message translates to:
  /// **'Start a shell on {host} in the verified chat working directory. This is not a device shell.'**
  String rel_ops_term_open_gateway_body(String host);

  /// Terminal page: close tab title. Preserve server/user placeholder values.
  ///
  /// In en, this message translates to:
  /// **'Close {label}?'**
  String rel_ops_term_close_tab_title(String label);

  /// Terminal page: read only status. Preserve server/user placeholder values.
  ///
  /// In en, this message translates to:
  /// **'Read-only · {status}'**
  String rel_ops_term_read_only_status(String status);

  /// Terminal page: paste title. Preserve server/user placeholder values.
  ///
  /// In en, this message translates to:
  /// **'Paste into {label}?'**
  String rel_ops_term_paste_title(String label);

  /// Terminal page: output title. Preserve server/user placeholder values.
  ///
  /// In en, this message translates to:
  /// **'Output · {label}'**
  String rel_ops_term_output_title(String label);

  /// Terminal page: mirror status. Preserve server/user placeholder values.
  ///
  /// In en, this message translates to:
  /// **'Read-only process mirror · {label}'**
  String rel_ops_term_mirror_status(String label);

  /// Terminal page: status label. Preserve server/user placeholder values.
  ///
  /// In en, this message translates to:
  /// **'{status} · {label}'**
  String rel_ops_term_status_label(String status, String label);

  /// SSH tab label. Preserve SSH and the login address.
  ///
  /// In en, this message translates to:
  /// **'SSH {user}@{host}:{port} · {number}'**
  String rel_ops_term_ssh_tab(String user, String host, int port, int number);

  /// Local device shell tab label.
  ///
  /// In en, this message translates to:
  /// **'This device · {number}'**
  String rel_ops_term_device_tab(int number);

  /// Gateway shell tab label; host is unchanged.
  ///
  /// In en, this message translates to:
  /// **'Gateway {host} · {number}'**
  String rel_ops_term_gateway_tab(String host, int number);

  /// App-authored terminal replay notice, not shell output.
  ///
  /// In en, this message translates to:
  /// **'[Earlier output trimmed]'**
  String get rel_ops_term_earlier_output_trimmed;

  /// SSH terminal dialog: ssh dialog title. Keep SSH/SHA256 protocol notation unchanged.
  ///
  /// In en, this message translates to:
  /// **'Open a verified SSH terminal'**
  String get rel_ops_term_ssh_dialog_title;

  /// SSH terminal dialog: ssh dialog body. Keep SSH/SHA256 protocol notation unchanged.
  ///
  /// In en, this message translates to:
  /// **'Use a fingerprint obtained independently from the host administrator. This opens a new remote login, not the gateway or a local shell.'**
  String get rel_ops_term_ssh_dialog_body;

  /// SSH terminal dialog: ssh host. Keep SSH/SHA256 protocol notation unchanged.
  ///
  /// In en, this message translates to:
  /// **'SSH host'**
  String get rel_ops_term_ssh_host;

  /// SSH terminal dialog: ssh port. Keep SSH/SHA256 protocol notation unchanged.
  ///
  /// In en, this message translates to:
  /// **'Port'**
  String get rel_ops_term_ssh_port;

  /// SSH terminal dialog: ssh user. Keep SSH/SHA256 protocol notation unchanged.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get rel_ops_term_ssh_user;

  /// SSH terminal dialog: ssh fingerprint. Keep SSH/SHA256 protocol notation unchanged.
  ///
  /// In en, this message translates to:
  /// **'Host key fingerprint (SHA256:…)'**
  String get rel_ops_term_ssh_fingerprint;

  /// SSH terminal dialog: ssh password. Keep SSH/SHA256 protocol notation unchanged.
  ///
  /// In en, this message translates to:
  /// **'SSH password (not saved)'**
  String get rel_ops_term_ssh_password;

  /// SSH terminal dialog: connect. Keep SSH/SHA256 protocol notation unchanged.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get rel_ops_term_connect;

  /// Verified SSH destination validation refusal.
  ///
  /// In en, this message translates to:
  /// **'Invalid SSH host, port or user.'**
  String get rel_ops_ssh_invalid_destination;

  /// Verified SSH key format refusal. Preserve OpenSSH and Ed25519.
  ///
  /// In en, this message translates to:
  /// **'An OpenSSH Ed25519 public host key is required.'**
  String get rel_ops_ssh_public_key_required;

  /// Verified SSH key binary validation refusal.
  ///
  /// In en, this message translates to:
  /// **'Invalid Ed25519 host key.'**
  String get rel_ops_ssh_invalid_public_key;

  /// Saved SSH pin failed validation.
  ///
  /// In en, this message translates to:
  /// **'Invalid saved host key.'**
  String get rel_ops_ssh_invalid_saved_key;

  /// Host key enrollment could not be read back.
  ///
  /// In en, this message translates to:
  /// **'Could not verify host-key enrollment.'**
  String get rel_ops_ssh_enrollment_unverified;

  /// SSH pin replacement refusal. Preserve separate verification requirement.
  ///
  /// In en, this message translates to:
  /// **'A different key is already pinned. Verify the change separately.'**
  String get rel_ops_ssh_different_key_pinned;

  /// System OpenSSH transport unavailable refusal.
  ///
  /// In en, this message translates to:
  /// **'System OpenSSH is unavailable.'**
  String get rel_ops_ssh_open_ssh_unavailable;

  /// Connection refused before explicit host key enrollment.
  ///
  /// In en, this message translates to:
  /// **'Confirm the host key before connecting.'**
  String get rel_ops_ssh_confirm_host_key;

  /// Unsafe or relative SSH identity path refusal.
  ///
  /// In en, this message translates to:
  /// **'Select an absolute identity file.'**
  String get rel_ops_ssh_absolute_identity_required;

  /// Remote loopback port validation refusal.
  ///
  /// In en, this message translates to:
  /// **'Invalid remote port.'**
  String get rel_ops_ssh_invalid_remote_port;

  /// SSH preview response size refusal. Preserve 64 KiB limit.
  ///
  /// In en, this message translates to:
  /// **'Preview exceeds the 64 KiB limit.'**
  String get rel_ops_ssh_preview_too_large;

  /// SSH subprocess nonzero exit refusal.
  ///
  /// In en, this message translates to:
  /// **'SSH connection refused. Check the enrolled host key, identity and service.'**
  String get rel_ops_ssh_connection_refused;

  /// Remote HTTP status or header validation refusal. Preserve HTTP 200.
  ///
  /// In en, this message translates to:
  /// **'The remote service did not return HTTP 200.'**
  String get rel_ops_ssh_http_not_ok;

  /// Encoded remote HTTP response refusal.
  ///
  /// In en, this message translates to:
  /// **'Encoded responses are not supported by this preview.'**
  String get rel_ops_ssh_encoded_response;

  /// Unsupported remote preview content type refusal.
  ///
  /// In en, this message translates to:
  /// **'Only text and HTML source can be previewed.'**
  String get rel_ops_ssh_preview_type_unsupported;

  /// Remote health response did not affirm ok.
  ///
  /// In en, this message translates to:
  /// **'The service did not confirm gateway health.'**
  String get rel_ops_ssh_health_unconfirmed;

  /// SSH screen notice for an unenrolled destination.
  ///
  /// In en, this message translates to:
  /// **'Enroll the host’s public key first.'**
  String get rel_ops_ssh_enroll_host_key_first;

  /// Cancel an SSH enrollment or connection confirmation.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get rel_ops_ssh_cancel;

  /// Confirm an SSH enrollment or connection.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get rel_ops_ssh_confirm;

  /// Explicit SSH host key enrollment confirmation title.
  ///
  /// In en, this message translates to:
  /// **'Pin this SSH host key?'**
  String get rel_ops_ssh_pin_title;

  /// Host key enrollment consent. Preserve independent-channel verification and no-connection assurance. Values are verbatim SSH identifiers.
  ///
  /// In en, this message translates to:
  /// **'{destination}\n{fingerprint}\nCompare this fingerprint with the host administrator over an independent channel. No connection will be made.'**
  String rel_ops_ssh_pin_detail(String destination, String fingerprint);

  /// Successful host key enrollment notice.
  ///
  /// In en, this message translates to:
  /// **'Host key pinned.'**
  String get rel_ops_ssh_host_key_pinned;

  /// SSH remote shell connection consent detail.
  ///
  /// In en, this message translates to:
  /// **'Open an interactive login shell.'**
  String get rel_ops_ssh_shell_detail;

  /// Remote loopback HTTP read consent. Preserve literal loopback address; path is / or /api/health and must remain unchanged.
  ///
  /// In en, this message translates to:
  /// **'Read {path} on remote 127.0.0.1:{port} through an SSH channel.'**
  String rel_ops_ssh_read_detail(String path, int port);

  /// SSH connection confirmation title; destination is verbatim user@host:port.
  ///
  /// In en, this message translates to:
  /// **'Connect to {destination}?'**
  String rel_ops_ssh_connect_title(String destination);

  /// SSH connection confirmation layout combining localized operation and authentication consent with a verbatim fingerprint.
  ///
  /// In en, this message translates to:
  /// **'{detail}\n{fingerprint}\n{authentication}'**
  String rel_ops_ssh_connect_detail(
    String detail,
    String fingerprint,
    String authentication,
  );

  /// SSH agent authentication consent detail.
  ///
  /// In en, this message translates to:
  /// **'Authenticate with your SSH agent.'**
  String get rel_ops_ssh_agent_auth;

  /// Selected SSH identity file authentication consent detail.
  ///
  /// In en, this message translates to:
  /// **'Use the selected identity file.'**
  String get rel_ops_ssh_identity_auth;

  /// Successful SSH remote gateway health check result.
  ///
  /// In en, this message translates to:
  /// **'Gateway is responding on remote loopback port {port}.'**
  String rel_ops_ssh_gateway_responding(int port);

  /// Remote SSH shell exited cleanly.
  ///
  /// In en, this message translates to:
  /// **'SSH session closed.'**
  String get rel_ops_ssh_session_closed;

  /// Remote SSH shell exited with nonzero status.
  ///
  /// In en, this message translates to:
  /// **'SSH session ended without a clean exit.'**
  String get rel_ops_ssh_session_unclean;

  /// Safe SSH operation failure notice replacing untrusted system errors.
  ///
  /// In en, this message translates to:
  /// **'SSH operation failed. Check the destination and identity.'**
  String get rel_ops_ssh_operation_failed;

  /// Verified SSH screen title.
  ///
  /// In en, this message translates to:
  /// **'Verified SSH'**
  String get rel_ops_ssh_title;

  /// Security explanation on unsupported devices. Preserve the relay enrollment restriction.
  ///
  /// In en, this message translates to:
  /// **'This device has no supported system OpenSSH transport. The pinned gateway relay automatically accepts new keys and cannot be used for verified enrollment.'**
  String get rel_ops_ssh_unsupported;

  /// SSH hostname input label.
  ///
  /// In en, this message translates to:
  /// **'SSH host'**
  String get rel_ops_ssh_host;

  /// SSH transport port input label.
  ///
  /// In en, this message translates to:
  /// **'SSH port'**
  String get rel_ops_ssh_port;

  /// SSH username input label.
  ///
  /// In en, this message translates to:
  /// **'SSH user'**
  String get rel_ops_ssh_user;

  /// SSH identity path input label and agent fallback explanation.
  ///
  /// In en, this message translates to:
  /// **'Identity file (optional; otherwise use SSH agent)'**
  String get rel_ops_ssh_identity;

  /// Public host key input label. Preserve ssh-ed25519 algorithm token.
  ///
  /// In en, this message translates to:
  /// **'Public host key from administrator (ssh-ed25519)'**
  String get rel_ops_ssh_public_key;

  /// Open SSH host key enrollment review.
  ///
  /// In en, this message translates to:
  /// **'Review host key'**
  String get rel_ops_ssh_review_key;

  /// Remote HTTP service loopback port input label.
  ///
  /// In en, this message translates to:
  /// **'Remote loopback service port'**
  String get rel_ops_ssh_remote_port;

  /// Check remote gateway health through SSH.
  ///
  /// In en, this message translates to:
  /// **'Check gateway over SSH'**
  String get rel_ops_ssh_check_gateway;

  /// Read remote text or HTML source through SSH.
  ///
  /// In en, this message translates to:
  /// **'Preview source over SSH'**
  String get rel_ops_ssh_preview_source;

  /// Explicitly open a remote SSH login shell.
  ///
  /// In en, this message translates to:
  /// **'Open SSH shell'**
  String get rel_ops_ssh_open_shell;

  /// Input label for a line sent to the active remote shell.
  ///
  /// In en, this message translates to:
  /// **'Line to remote shell'**
  String get rel_ops_ssh_shell_line;

  /// Terminate the active SSH shell subprocess.
  ///
  /// In en, this message translates to:
  /// **'Disconnect shell'**
  String get rel_ops_ssh_disconnect;

  /// Cancel a remote host operation confirmation.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get rel_ops_host_cancel;

  /// Confirm a remote host operation.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get rel_ops_host_confirm;

  /// Remote host operations screen title.
  ///
  /// In en, this message translates to:
  /// **'Host'**
  String get rel_ops_host_title;

  /// Refresh remote host status and logs.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get rel_ops_host_refresh;

  /// Start an update on the remote gateway host, not the Ares client.
  ///
  /// In en, this message translates to:
  /// **'Update remote Hermes'**
  String get rel_ops_host_update;

  /// Remote Hermes update confirmation. Preserve the profile identifier verbatim.
  ///
  /// In en, this message translates to:
  /// **'This starts an in-place update on the gateway host for {profile}. It does not update Ares on this device. Success is the matching update receipt, not the host staying reachable.'**
  String rel_ops_host_update_confirmation(String profile);

  /// Update is running but no matching receipt has arrived.
  ///
  /// In en, this message translates to:
  /// **'Awaiting matching receipt. Update is still running.'**
  String get rel_ops_host_update_awaiting;

  /// Matching remote update receipt reports success.
  ///
  /// In en, this message translates to:
  /// **'Update receipt succeeded.'**
  String get rel_ops_host_receipt_success;

  /// Remote update committed but still requires follow-up work.
  ///
  /// In en, this message translates to:
  /// **'Update committed, with follow-up steps still owed.'**
  String get rel_ops_host_receipt_partial;

  /// Matching remote update receipt reports failure.
  ///
  /// In en, this message translates to:
  /// **'Update receipt failed.'**
  String get rel_ops_host_receipt_failed;

  /// Matching remote update receipt reports refusal.
  ///
  /// In en, this message translates to:
  /// **'Update receipt refused.'**
  String get rel_ops_host_receipt_refused;

  /// Remote update remains in progress.
  ///
  /// In en, this message translates to:
  /// **'Update is still running.'**
  String get rel_ops_host_update_running;

  /// No matching receipt verifies the remote update outcome.
  ///
  /// In en, this message translates to:
  /// **'Update outcome is unknown. A live gateway is not a successful update.'**
  String get rel_ops_host_update_unknown;

  /// Display name for an unspecified gateway profile, not a wire identifier.
  ///
  /// In en, this message translates to:
  /// **'the gateway default'**
  String get rel_ops_host_default_profile;

  /// Restart the gateway on the remote host.
  ///
  /// In en, this message translates to:
  /// **'Restart remote gateway'**
  String get rel_ops_host_restart;

  /// Warn that restarting a shared gateway interrupts all listed profiles. Keep profile identifiers unchanged.
  ///
  /// In en, this message translates to:
  /// **'This restarts the gateway shared by {profiles}. Live turns on this gateway are interrupted. Reconnect afterwards. Reachability is not proof the restart finished.'**
  String rel_ops_host_restart_shared_confirmation(String profiles);

  /// Remote gateway restart confirmation.
  ///
  /// In en, this message translates to:
  /// **'This restarts the remote gateway for {profile}. Live turns on this gateway are interrupted. Reconnect afterwards.'**
  String rel_ops_host_restart_confirmation(String profile);

  /// Remote restart command is still running.
  ///
  /// In en, this message translates to:
  /// **'Restart command is still running.'**
  String get rel_ops_host_restart_running;

  /// Remote restart command exited successfully; reconnection remains manual.
  ///
  /// In en, this message translates to:
  /// **'Restart command finished. Reconnect to the host yourself.'**
  String get rel_ops_host_restart_finished;

  /// Remote restart command exited unsuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Restart command failed.'**
  String get rel_ops_host_restart_failed;

  /// Remote maintenance command status. The name is a command identifier such as doctor, security-audit or curator-run; do not translate it.
  ///
  /// In en, this message translates to:
  /// **'{name} is still running'**
  String rel_ops_host_maintenance_running(String name);

  /// Remote maintenance command succeeded. Keep the command identifier unchanged.
  ///
  /// In en, this message translates to:
  /// **'{name} finished'**
  String rel_ops_host_maintenance_finished(String name);

  /// Remote maintenance command failed. Keep the command identifier unchanged.
  ///
  /// In en, this message translates to:
  /// **'{name} failed'**
  String rel_ops_host_maintenance_failed(String name);

  /// Confirmation that the remote Curator was paused.
  ///
  /// In en, this message translates to:
  /// **'Curator paused.'**
  String get rel_ops_host_curator_paused_result;

  /// Confirmation that the remote Curator was resumed.
  ///
  /// In en, this message translates to:
  /// **'Curator resumed.'**
  String get rel_ops_host_curator_resumed_result;

  /// Remote memory file reset section and confirmation title.
  ///
  /// In en, this message translates to:
  /// **'Reset remote memory files'**
  String get rel_ops_host_reset;

  /// Destructive remote memory reset warning. Preserve the target token (memory, user or all) and profile identifier.
  ///
  /// In en, this message translates to:
  /// **'Delete the {targetName} memory file on {profile}? This cannot be undone from Ares.'**
  String rel_ops_host_reset_confirmation(String targetName, String profile);

  /// Remote memory reset result. Preserve the target token unchanged.
  ///
  /// In en, this message translates to:
  /// **'Reset {targetName}. Removed {count} remote file(s).'**
  String rel_ops_host_reset_result(String targetName, int count);

  /// Diagnostic sharing is blocked without server confirmation of redaction.
  ///
  /// In en, this message translates to:
  /// **'The host did not confirm the bundle was redacted. No link is shown.'**
  String get rel_ops_host_share_not_redacted;

  /// Explain that controls target the named remote connection and profile, never this device. Preserve the connection label and profile identifier.
  ///
  /// In en, this message translates to:
  /// **'These controls operate the remote gateway {connection} for {profile}, not this device and not the Ares client update.'**
  String rel_ops_host_scope(String connection, String profile);

  /// Remote gateway health with running process, server version and active session count.
  ///
  /// In en, this message translates to:
  /// **'Gateway process running {version} · {count} sessions'**
  String rel_ops_host_health_running(String version, int count);

  /// Remote gateway health with stopped process, server version and active session count.
  ///
  /// In en, this message translates to:
  /// **'Gateway process stopped {version} · {count} sessions'**
  String rel_ops_host_health_stopped(String version, int count);

  /// Remote host heartbeat age in seconds; the gateway may return fractional seconds.
  ///
  /// In en, this message translates to:
  /// **'Host heartbeat is stale ({seconds}s).'**
  String rel_ops_host_heartbeat_stale(num seconds);

  /// Run remote host diagnostics using the Doctor command.
  ///
  /// In en, this message translates to:
  /// **'Run Doctor'**
  String get rel_ops_host_doctor;

  /// Run the remote host security audit.
  ///
  /// In en, this message translates to:
  /// **'Security audit'**
  String get rel_ops_host_security_audit;

  /// Read the receipt for the already-started remote update, without starting another.
  ///
  /// In en, this message translates to:
  /// **'Check update receipt'**
  String get rel_ops_host_check_receipt;

  /// Remote gateway logs section heading.
  ///
  /// In en, this message translates to:
  /// **'Remote host logs'**
  String get rel_ops_host_logs;

  /// Search field label for remote host logs.
  ///
  /// In en, this message translates to:
  /// **'Search host logs'**
  String get rel_ops_host_search_logs;

  /// Remote Computer Use driver section heading.
  ///
  /// In en, this message translates to:
  /// **'Remote host driver'**
  String get rel_ops_host_driver;

  /// Clarify that driver readiness and OS permissions refer only to the remote gateway machine.
  ///
  /// In en, this message translates to:
  /// **'Computer Use readiness is the gateway machine\'s driver and OS permissions, not this device.'**
  String get rel_ops_host_driver_scope;

  /// Computer Use driver status. Platform is a server identifier; installed and ready are localized boolean display values.
  ///
  /// In en, this message translates to:
  /// **'{platform} · installed {installed} · ready {ready}'**
  String rel_ops_host_computer_status(
    String platform,
    String installed,
    String ready,
  );

  /// Human-readable unavailable readiness value from a nullable remote driver status; never sent over the wire.
  ///
  /// In en, this message translates to:
  /// **'null'**
  String get rel_ops_host_null;

  /// Human-readable affirmative boolean in remote driver status; never sent over the wire.
  ///
  /// In en, this message translates to:
  /// **'true'**
  String get rel_ops_host_true;

  /// Human-readable negative boolean in remote driver status; never sent over the wire.
  ///
  /// In en, this message translates to:
  /// **'false'**
  String get rel_ops_host_false;

  /// Remote Curator section heading.
  ///
  /// In en, this message translates to:
  /// **'Curator'**
  String get rel_ops_host_curator;

  /// Remote Curator paused status label.
  ///
  /// In en, this message translates to:
  /// **'Curator paused'**
  String get rel_ops_host_curator_paused;

  /// Remote Curator running status label.
  ///
  /// In en, this message translates to:
  /// **'Curator running'**
  String get rel_ops_host_curator_running;

  /// No completed remote Curator run timestamp is available.
  ///
  /// In en, this message translates to:
  /// **'No completed run'**
  String get rel_ops_host_no_run;

  /// Start a remote Curator maintenance run immediately.
  ///
  /// In en, this message translates to:
  /// **'Run Curator now'**
  String get rel_ops_host_run_curator;

  /// Delete the remote memory file after confirmation.
  ///
  /// In en, this message translates to:
  /// **'Reset memory file'**
  String get rel_ops_host_reset_memory;

  /// Delete the remote user memory file after confirmation.
  ///
  /// In en, this message translates to:
  /// **'Reset user file'**
  String get rel_ops_host_reset_user;

  /// Delete both remote memory files after confirmation.
  ///
  /// In en, this message translates to:
  /// **'Reset both files'**
  String get rel_ops_host_reset_both;

  /// Explicit consent to upload a redacted remote host diagnostic bundle; do not weaken the consent or remote-host scope.
  ///
  /// In en, this message translates to:
  /// **'I agree to upload a redacted diagnostic bundle from the remote host'**
  String get rel_ops_host_share_consent;

  /// Upload redacted remote diagnostic bundle after explicit consent.
  ///
  /// In en, this message translates to:
  /// **'Share redacted diagnostics'**
  String get rel_ops_host_share;

  /// Local admission refusal when the gateway installation cannot be identified.
  ///
  /// In en, this message translates to:
  /// **'This installation is unknown, so the update was not sent'**
  String get rel_ops_host_update_unknown_installation;

  /// Local admission refusal when an active chat or agent blocks the remote update.
  ///
  /// In en, this message translates to:
  /// **'A chat on this installation is running'**
  String get rel_ops_host_update_busy_installation;

  /// Local fallback when the server refuses an update without a message.
  ///
  /// In en, this message translates to:
  /// **'Remote update refused'**
  String get rel_ops_host_update_refused;

  /// Workspace failure: the remote owner or connection is no longer current.
  ///
  /// In en, this message translates to:
  /// **'Remote workspace: stale'**
  String get rel_ops_host_error_stale;

  /// Workspace failure: remote owner or action result does not match the requested target.
  ///
  /// In en, this message translates to:
  /// **'Remote workspace: mismatch'**
  String get rel_ops_host_error_mismatch;

  /// Workspace failure: no authenticated remote target has been bound.
  ///
  /// In en, this message translates to:
  /// **'Remote workspace: unbound'**
  String get rel_ops_host_error_unbound;

  /// Workspace failure: the gateway does not support this operation.
  ///
  /// In en, this message translates to:
  /// **'Remote workspace: unsupported'**
  String get rel_ops_host_error_unsupported;

  /// Workspace failure: the remote host operation was denied.
  ///
  /// In en, this message translates to:
  /// **'Remote workspace: denied'**
  String get rel_ops_host_error_denied;

  /// Workspace failure: the remote target is not eligible for this operation.
  ///
  /// In en, this message translates to:
  /// **'Remote workspace: ineligible'**
  String get rel_ops_host_error_ineligible;

  /// Workspace failure: the remote host operation is unavailable.
  ///
  /// In en, this message translates to:
  /// **'Remote workspace: unavailable'**
  String get rel_ops_host_error_unavailable;

  /// Workspace failure: the request or gateway response was invalid.
  ///
  /// In en, this message translates to:
  /// **'Remote workspace: invalid'**
  String get rel_ops_host_error_invalid;

  /// Workspace failure: the remote connection does not meet security requirements.
  ///
  /// In en, this message translates to:
  /// **'Remote workspace: insecure'**
  String get rel_ops_host_error_insecure;

  /// Safe host-operation failure fallback when no structured reason is available. Do not expose client-authored service exception prose.
  ///
  /// In en, this message translates to:
  /// **'Could not complete that request.'**
  String get rel_ops_host_error_request;

  /// Validation shown when a legacy mobile-push session allowlist is invalid.
  ///
  /// In en, this message translates to:
  /// **'Select 1–128 durable session IDs, each 1–200 ASCII characters using only letters, digits, _ . : @ or -. Remove blank IDs and whitespace.'**
  String get rel_svc_push_api_select_sessions;

  /// Mobile-push capability validation failure.
  ///
  /// In en, this message translates to:
  /// **'Mobile push is unavailable on this server.'**
  String get rel_svc_push_api_unavailable;

  /// Mobile-push server key validation failure.
  ///
  /// In en, this message translates to:
  /// **'Invalid server VAPID public key.'**
  String get rel_svc_push_api_invalid_vapid;

  /// Server plugin is too old for authorized automatic subscriptions.
  ///
  /// In en, this message translates to:
  /// **'This server needs an updated mobile-push plugin for automatic subscriptions.'**
  String get rel_svc_push_api_update_plugin;

  /// Mobile-push service status on unsupported platforms.
  ///
  /// In en, this message translates to:
  /// **'Android only'**
  String get rel_svc_push_status_android_only;

  /// Safe mobile-push error when native preference synchronization fails.
  ///
  /// In en, this message translates to:
  /// **'Native notification preferences could not be synchronized.'**
  String get rel_svc_push_native_prefs_sync_failed;

  /// Mobile-push enable error when no eligible saved Android connection exists.
  ///
  /// In en, this message translates to:
  /// **'Choose a saved connection on Android first.'**
  String get rel_svc_push_choose_android_connection;

  /// Mobile-push handshake status.
  ///
  /// In en, this message translates to:
  /// **'Checking server authorization'**
  String get rel_svc_push_status_checking_authorization;

  /// Error after local mobile-push revocation could not be saved.
  ///
  /// In en, this message translates to:
  /// **'Could not persist revocation. Retry disabling before leaving the app.'**
  String get rel_svc_push_revoke_persist_failed;

  /// Mobile-push availability status while consent is off.
  ///
  /// In en, this message translates to:
  /// **'Off; server API ready'**
  String get rel_svc_push_status_off_api_ready;

  /// Mobile-push status while a server-side revoke must still be retried.
  ///
  /// In en, this message translates to:
  /// **'Off; server revocation pending'**
  String get rel_svc_push_status_off_revoke_pending;

  /// Mobile-push status after its bound saved login changed.
  ///
  /// In en, this message translates to:
  /// **'Off; saved connection changed'**
  String get rel_svc_push_status_off_connection_changed;

  /// Mobile-push registration status while waiting for the distributor endpoint.
  ///
  /// In en, this message translates to:
  /// **'Pending distributor endpoint'**
  String get rel_svc_push_status_pending_endpoint;

  /// Mobile-push registration status.
  ///
  /// In en, this message translates to:
  /// **'Registering'**
  String get rel_svc_push_status_registering;

  /// Mobile-push handshake status while waiting for a silent encrypted verification push.
  ///
  /// In en, this message translates to:
  /// **'Pending encrypted challenge (waiting for silent server verification push)'**
  String get rel_svc_push_status_pending_challenge;

  /// Safe mobile-push error after notification permission was denied.
  ///
  /// In en, this message translates to:
  /// **'Allow Android notifications in system settings, then retry.'**
  String get rel_svc_push_allow_android_notifications_retry;

  /// Safe mobile-push error for invalid server capability or subscription responses.
  ///
  /// In en, this message translates to:
  /// **'The server mobile-push plugin is unavailable, outdated, or returned an invalid subscription response. Ask the operator to update it, then retry.'**
  String get rel_svc_push_plugin_invalid;

  /// Safe mobile-push error when Android has no usable transport.
  ///
  /// In en, this message translates to:
  /// **'No push transport is available. Built-in delivery needs working Google Play Services; alternatively install a UnifiedPush distributor and retry.'**
  String get rel_svc_push_transport_unavailable;

  /// Safe mobile-push error when Android needs an explicit distributor choice.
  ///
  /// In en, this message translates to:
  /// **'Several UnifiedPush distributors are available. Choose one in Advanced transport, then retry.'**
  String get rel_svc_push_transport_choice;

  /// Safe mobile-push error when the selected distributor disappeared.
  ///
  /// In en, this message translates to:
  /// **'The selected UnifiedPush distributor is unavailable. Restore it or choose another in Advanced transport.'**
  String get rel_svc_push_transport_missing;

  /// Safe 404 error with operator remediation for the server companion.
  ///
  /// In en, this message translates to:
  /// **'The server mobile-push companion is unavailable. It may be missing or disabled, or this connection may point to the wrong dashboard. Install or enable the companion on the server, check the dashboard connection, then refresh. See Server setup guide above.'**
  String get rel_svc_push_companion_unavailable;

  /// Safe authorization failure for mobile push.
  ///
  /// In en, this message translates to:
  /// **'Server denied mobile push. Ask the operator to authorize this principal and these sessions.'**
  String get rel_svc_push_server_denied;

  /// Generic safe mobile-push setup failure.
  ///
  /// In en, this message translates to:
  /// **'Mobile push is not ready. Check server plugin authorization, distributor and network, then retry.'**
  String get rel_svc_push_not_ready;

  /// Settings error while loading Android push transports.
  ///
  /// In en, this message translates to:
  /// **'Unable to read Android push availability. Retry below.'**
  String get rel_svc_push_availability_read_failed;

  /// Fallback error for the mobile-push settings action.
  ///
  /// In en, this message translates to:
  /// **'Push setup failed. Check Android permission, server authorization and transport, then retry.'**
  String get rel_svc_push_setup_failed;

  /// Mobile-push settings status line.
  ///
  /// In en, this message translates to:
  /// **'Status: {status}'**
  String rel_svc_push_status(String status);

  /// Mobile-push status when another saved connection owns the binding.
  ///
  /// In en, this message translates to:
  /// **'Status: Bound to {bound} (not active for {connection}; handshake: {status})'**
  String rel_svc_push_status_bound(
    String bound,
    String connection,
    String status,
  );

  /// Fallback label for a different saved connection.
  ///
  /// In en, this message translates to:
  /// **'another saved connection'**
  String get rel_svc_push_another_saved_connection;

  /// Title of the explicit mobile-push consent switch.
  ///
  /// In en, this message translates to:
  /// **'Background notifications'**
  String get rel_svc_push_background_notifications;

  /// Mobile-push switch subtitle when another connection owns consent.
  ///
  /// In en, this message translates to:
  /// **'Bound to {bound} — revoke that binding below before enabling for {connection}'**
  String rel_svc_push_bound_subtitle(String bound, String connection);

  /// Mobile-push switch subtitle for the current connection.
  ///
  /// In en, this message translates to:
  /// **'Private server activity for {connection}'**
  String rel_svc_push_private_activity(String connection);

  /// Named warning when mobile push is bound elsewhere.
  ///
  /// In en, this message translates to:
  /// **'Bound to another saved connection ({bound}). Disable and revoke that binding before enabling for this connection.'**
  String rel_svc_push_bound_warning_named(String bound);

  /// Warning when mobile push is bound to an unnamed saved connection.
  ///
  /// In en, this message translates to:
  /// **'Bound to another saved connection. Disable and revoke that binding before enabling for this connection.'**
  String get rel_svc_push_bound_warning;

  /// Explains that the master local toggle mutes delivery without revoking push consent.
  ///
  /// In en, this message translates to:
  /// **'Local notifications are turned off above. Background notification consent is unchanged, but ordinary background activity hints are muted until \"Enable notifications\" is turned on.'**
  String get rel_svc_push_local_notifications_muted;

  /// Warning for a legacy explicit mobile-push session allowlist.
  ///
  /// In en, this message translates to:
  /// **'Legacy subscription: {count} selected session(s) only. It will not expand automatically. Turn off, then on to opt in to server-authorized sessions.'**
  String rel_svc_push_legacy_subscription(int count);

  /// Scope disclosure for automatic mobile-push subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Bound only to this saved connection and profile. Session access follows current server authorization.'**
  String get rel_svc_push_authorized_binding;

  /// Warning for a durable pending server revoke.
  ///
  /// In en, this message translates to:
  /// **'Server revocation pending. Local delivery is off; retry while the original saved login is available.'**
  String get rel_svc_push_revocation_pending;

  /// Button to recheck mobile-push setup.
  ///
  /// In en, this message translates to:
  /// **'Refresh / retry'**
  String get rel_svc_push_refresh_retry;

  /// Button revoking mobile push from a named other connection.
  ///
  /// In en, this message translates to:
  /// **'Disable and revoke {bound}'**
  String rel_svc_push_disable_named(String bound);

  /// Fallback short label for another connection.
  ///
  /// In en, this message translates to:
  /// **'other connection'**
  String get rel_svc_push_other_connection;

  /// Button revoking mobile-push consent.
  ///
  /// In en, this message translates to:
  /// **'Disable and revoke'**
  String get rel_svc_push_disable;

  /// Clarifies what refresh does and that notification consent stays separate.
  ///
  /// In en, this message translates to:
  /// **'Refresh / retry rechecks availability after server setup; it cannot install the companion. Enabling notifications remains a separate choice.'**
  String get rel_svc_push_refresh_explanation;

  /// Server-side installation requirement disclosure.
  ///
  /// In en, this message translates to:
  /// **'Background notifications require a separately installed and enabled server-side mobile-push companion. Android cannot install it. Updating the APK alone does not set up the server.'**
  String get rel_svc_push_companion_required;

  /// Link to mobile-push server installation documentation.
  ///
  /// In en, this message translates to:
  /// **'Server setup guide'**
  String get rel_svc_push_server_setup_guide;

  /// Consent disclosure shown before enabling mobile push.
  ///
  /// In en, this message translates to:
  /// **'Enable to request Android notification permission and share this installation’s endpoint and encryption keys with this server. Encrypted activity hints contain no chat content. Only sessions authorized by your server login are included.'**
  String get rel_svc_push_enable_disclosure;

  /// Mobile-push transport and delivery disclosure.
  ///
  /// In en, this message translates to:
  /// **'Built-in delivery uses Google’s push transport and needs Google Play Services, but includes no Firebase SDK. An optional UnifiedPush distributor can be used instead. Delivery is best-effort; reopen Hermes to reconcile.'**
  String get rel_svc_push_transport_disclosure;

  /// Expandable mobile-push transport settings title.
  ///
  /// In en, this message translates to:
  /// **'Advanced transport'**
  String get rel_svc_push_advanced_transport;

  /// Explanation of automatic transport selection.
  ///
  /// In en, this message translates to:
  /// **'Automatic preserves an existing distributor choice, otherwise uses built-in Google delivery when available. Disable before changing transport.'**
  String get rel_svc_push_automatic_explanation;

  /// Mobile-push transport dropdown label.
  ///
  /// In en, this message translates to:
  /// **'Push transport'**
  String get rel_svc_push_transport_label;

  /// Recommended automatic mobile-push transport option.
  ///
  /// In en, this message translates to:
  /// **'Automatic (recommended)'**
  String get rel_svc_push_automatic_recommended;

  /// Disabled dropdown option for a missing selected distributor.
  ///
  /// In en, this message translates to:
  /// **'Selected distributor (unavailable)'**
  String get rel_svc_push_selected_unavailable;

  /// Empty mobile-push transport list guidance.
  ///
  /// In en, this message translates to:
  /// **'No available transport detected. Built-in delivery needs Google Play Services; without it, install and configure a UnifiedPush distributor, then refresh.'**
  String get rel_svc_push_no_transport_detected;

  /// OS notification channel name for completed turns.
  ///
  /// In en, this message translates to:
  /// **'Ares Turns'**
  String get rel_svc_push_channel_turns_name;

  /// OS notification channel description for completed turns.
  ///
  /// In en, this message translates to:
  /// **'Notifications for completed background turns'**
  String get rel_svc_push_channel_turns_description;

  /// OS notification channel name for requests needing attention.
  ///
  /// In en, this message translates to:
  /// **'Ares Attention'**
  String get rel_svc_push_channel_attention_name;

  /// OS notification channel description for attention requests.
  ///
  /// In en, this message translates to:
  /// **'Approvals and input requests that need you'**
  String get rel_svc_push_channel_attention_description;

  /// OS notification channel name for background work.
  ///
  /// In en, this message translates to:
  /// **'Ares Background'**
  String get rel_svc_push_channel_background_name;

  /// OS notification channel description for background work.
  ///
  /// In en, this message translates to:
  /// **'Background task completions'**
  String get rel_svc_push_channel_background_description;

  /// OS notification channel name for credit and plugin notices.
  ///
  /// In en, this message translates to:
  /// **'Ares Notices'**
  String get rel_svc_push_channel_notices_name;

  /// OS notification channel description for credit and plugin notices.
  ///
  /// In en, this message translates to:
  /// **'Credit and plugin notices'**
  String get rel_svc_push_channel_notices_description;

  /// Recent-notification diagnostic detail when the notification sink did not initialize.
  ///
  /// In en, this message translates to:
  /// **'not initialised'**
  String get rel_svc_push_diag_not_initialised;

  /// Recent-notification skip reason when reply notifications are disabled.
  ///
  /// In en, this message translates to:
  /// **'replies are off'**
  String get rel_svc_push_diag_replies_off;

  /// Recent-notification diagnostic indicating an Android conversation post.
  ///
  /// In en, this message translates to:
  /// **'conversation'**
  String get rel_svc_push_diag_conversation;

  /// Recent-notification diagnostic for a conversation posted without confirmed permission.
  ///
  /// In en, this message translates to:
  /// **'conversation; permission denied'**
  String get rel_svc_push_diag_conversation_permission_denied;

  /// Recent-notification conversation failure prefix; error is kept raw.
  ///
  /// In en, this message translates to:
  /// **'conversation: {error}'**
  String rel_svc_push_diag_conversation_error(String error);

  /// Recent-notification skip reason when failure notifications are disabled.
  ///
  /// In en, this message translates to:
  /// **'failures are off'**
  String get rel_svc_push_diag_failures_off;

  /// Recent-notification skip reason; kind is a literal notification enum id.
  ///
  /// In en, this message translates to:
  /// **'{kind} is off'**
  String rel_svc_push_diag_kind_off(String kind);

  /// Recent-notification diagnostic when Windows accepts a toast but its setting is unreadable.
  ///
  /// In en, this message translates to:
  /// **'Windows did not report its notification setting'**
  String get rel_svc_push_diag_windows_setting_unknown;

  /// Backup validation failure for a file with the wrong format.
  ///
  /// In en, this message translates to:
  /// **'This file is not a Hermes configuration backup.'**
  String get rel_svc_backup_not_hermes_configuration_backup;

  /// Backup version is newer than this app supports.
  ///
  /// In en, this message translates to:
  /// **'This backup was made by a newer version of the app and cannot be imported.'**
  String get rel_svc_backup_newer_version_cannot_import;

  /// Backup metadata references a missing client certificate.
  ///
  /// In en, this message translates to:
  /// **'This backup claims a client certificate for a connection but does not contain it, so a complete restore is not possible.'**
  String get rel_svc_backup_missing_client_certificate;

  /// Generic safe error for malformed backup content.
  ///
  /// In en, this message translates to:
  /// **'This backup file is damaged and could not be read.'**
  String get rel_svc_backup_damaged_unreadable;

  /// Export failed because a stored setting has an unsupported value type.
  ///
  /// In en, this message translates to:
  /// **'A saved preference has an unsupported type and cannot be exported.'**
  String get rel_svc_backup_unsupported_preference_type;

  /// Backup export requires encryption because API keys are included.
  ///
  /// In en, this message translates to:
  /// **'Choose a passphrase — the backup contains your API keys.'**
  String get rel_svc_backup_choose_passphrase_api_keys;

  /// Backup encryption failed safely.
  ///
  /// In en, this message translates to:
  /// **'The backup could not be protected safely.'**
  String get rel_svc_backup_could_not_protect_safely;

  /// Backup declares an encryption format this app cannot use.
  ///
  /// In en, this message translates to:
  /// **'This backup uses an unsupported encryption scheme.'**
  String get rel_svc_backup_unsupported_encryption;

  /// Authenticated decryption failed without distinguishing password from tampering.
  ///
  /// In en, this message translates to:
  /// **'Wrong passphrase, or this backup file has been altered.'**
  String get rel_svc_backup_wrong_passphrase_or_altered;

  /// Operating-system share sheet subject for an exported backup.
  ///
  /// In en, this message translates to:
  /// **'Hermes configuration backup'**
  String get rel_svc_backup_share_subject;

  /// Selected backup file could not be read.
  ///
  /// In en, this message translates to:
  /// **'That file could not be read.'**
  String get rel_svc_backup_selected_file_unreadable;

  /// Count fragment in a restored-connections summary.
  ///
  /// In en, this message translates to:
  /// **'{count} added'**
  String rel_svc_backup_connections_added(int count);

  /// Count fragment in a restored-connections summary.
  ///
  /// In en, this message translates to:
  /// **'{count} updated'**
  String rel_svc_backup_connections_updated(int count);

  /// Count fragment in a restored-connections summary.
  ///
  /// In en, this message translates to:
  /// **'{count} removed'**
  String rel_svc_backup_connections_removed(int count);

  /// Restore summary when no saved connections changed.
  ///
  /// In en, this message translates to:
  /// **'No connection changes'**
  String get rel_svc_backup_no_connection_changes;

  /// Restore summary prefix followed by localized change fragments.
  ///
  /// In en, this message translates to:
  /// **'Connections: {changes}'**
  String rel_svc_backup_connections_summary(String changes);

  /// Final configuration restore result summary.
  ///
  /// In en, this message translates to:
  /// **'{connections} · {count} settings restored'**
  String rel_svc_backup_restore_summary(String connections, int count);

  /// Backup export could not include one connection's client certificate; label is user data and error is already localized.
  ///
  /// In en, this message translates to:
  /// **'The client certificate for \"{label}\" could not be included in this backup: {error}'**
  String rel_svc_backup_certificate_not_included(String label, String error);

  /// Certificate import requires its password.
  ///
  /// In en, this message translates to:
  /// **'This certificate needs its password. Enter it below and it will open automatically.'**
  String get rel_svc_backup_certificate_password_needed;

  /// Certificate authentication failed without distinguishing wrong password from corruption.
  ///
  /// In en, this message translates to:
  /// **'The certificate password is incorrect, or the file is corrupted.'**
  String get rel_svc_backup_certificate_password_or_corrupt;

  /// Certificate password is wrong.
  ///
  /// In en, this message translates to:
  /// **'The certificate password is incorrect.'**
  String get rel_svc_backup_certificate_password_incorrect;

  /// Certificate uses unsupported encryption.
  ///
  /// In en, this message translates to:
  /// **'This certificate uses an encryption method the app cannot read.'**
  String get rel_svc_backup_certificate_unsupported_encryption;

  /// Selected file is not a readable PKCS#12 certificate container.
  ///
  /// In en, this message translates to:
  /// **'The selected file is not a readable PKCS#12 (.p12/.pfx) certificate.'**
  String get rel_svc_backup_certificate_unreadable_pkcs12;

  /// Selected certificate could not be parsed.
  ///
  /// In en, this message translates to:
  /// **'The selected certificate could not be read.'**
  String get rel_svc_backup_certificate_unreadable;

  /// Picked file contains no supported certificate or private key.
  ///
  /// In en, this message translates to:
  /// **'That file is not a certificate: pick a .p12/.pfx container or PEM certificate and key files.'**
  String get rel_svc_backup_not_certificate_file;

  /// Selected certificate half is not PEM.
  ///
  /// In en, this message translates to:
  /// **'The selected certificate is not a PEM certificate.'**
  String get rel_svc_backup_not_pem_certificate;

  /// Selected private-key half is not PEM.
  ///
  /// In en, this message translates to:
  /// **'The selected private key is not a PEM private key.'**
  String get rel_svc_backup_not_pem_private_key;

  /// PEM certificate and private key could not be loaded together.
  ///
  /// In en, this message translates to:
  /// **'The selected certificate and private key could not be loaded.'**
  String get rel_svc_backup_certificate_pair_unloadable;

  /// Stored client certificate files are missing or unreadable during backup.
  ///
  /// In en, this message translates to:
  /// **'The saved client certificate files could not be read.'**
  String get rel_svc_backup_saved_certificate_files_unreadable;

  /// Committing a client certificate to private device storage failed.
  ///
  /// In en, this message translates to:
  /// **'The client certificate could not be stored securely on this device.'**
  String get rel_svc_backup_client_certificate_storage_failed;

  /// Writing certificate files to private device storage failed.
  ///
  /// In en, this message translates to:
  /// **'The certificate could not be stored securely on this device.'**
  String get rel_svc_backup_certificate_storage_failed;

  /// Fallback display label when a client certificate has no filename or common name.
  ///
  /// In en, this message translates to:
  /// **'Client certificate'**
  String get rel_svc_backup_client_certificate_label;

  /// Session search transport failed; error is raw platform detail.
  ///
  /// In en, this message translates to:
  /// **'Could not reach the dashboard: {error}'**
  String rel_svc_backup_search_dashboard_unreachable(String error);

  /// Session search received an authentication rejection.
  ///
  /// In en, this message translates to:
  /// **'The dashboard rejected the saved credentials. Check the dashboard username and password for this connection.'**
  String get rel_svc_backup_search_credentials_rejected;

  /// Dashboard does not support remote session search.
  ///
  /// In en, this message translates to:
  /// **'This dashboard does not expose session search. Update Hermes on the host, or switch back to on-device search.'**
  String get rel_svc_backup_search_not_supported;

  /// Session search refused an HTTP redirect to protect saved credentials.
  ///
  /// In en, this message translates to:
  /// **'The dashboard redirected session search (HTTP {statusCode}). Ares does not follow redirects with saved credentials; check the connection address.'**
  String rel_svc_backup_search_redirected(int statusCode);

  /// Session search failed with a non-success HTTP status.
  ///
  /// In en, this message translates to:
  /// **'Session search failed with HTTP {statusCode}.'**
  String rel_svc_backup_search_http_failed(int statusCode);

  /// Dashboard search response was not valid JSON.
  ///
  /// In en, this message translates to:
  /// **'The dashboard returned a malformed search response.'**
  String get rel_svc_backup_search_malformed_response;

  /// Dashboard search response had the wrong top-level shape.
  ///
  /// In en, this message translates to:
  /// **'The dashboard returned an unexpected search response.'**
  String get rel_svc_backup_search_unexpected_response;

  /// Dashboard exceeded the requested search-result limit.
  ///
  /// In en, this message translates to:
  /// **'The dashboard returned more search results than requested.'**
  String get rel_svc_backup_search_too_many_results;

  /// Message-search response failed semantic validation.
  ///
  /// In en, this message translates to:
  /// **'Unexpected message search response.'**
  String get rel_svc_backup_message_search_unexpected_response;

  /// One message-search result failed semantic validation.
  ///
  /// In en, this message translates to:
  /// **'Unexpected message search result.'**
  String get rel_svc_backup_message_search_unexpected_result;

  /// AI search rewrite authentication failed.
  ///
  /// In en, this message translates to:
  /// **'The Hermes API rejected the saved API key.'**
  String get rel_svc_backup_ai_search_api_key_rejected;

  /// AI query rewrite failed with a non-success HTTP status.
  ///
  /// In en, this message translates to:
  /// **'AI query rewrite failed with HTTP {statusCode}.'**
  String rel_svc_backup_ai_search_http_failed(int statusCode);

  /// AI model produced no usable rewritten query.
  ///
  /// In en, this message translates to:
  /// **'The selected model returned no usable search query.'**
  String get rel_svc_backup_ai_search_no_usable_query;

  /// Hermes returned invalid AI rewrite JSON.
  ///
  /// In en, this message translates to:
  /// **'Hermes returned a malformed AI rewrite response.'**
  String get rel_svc_backup_ai_search_malformed_response;

  /// Space create or rename validation failure.
  ///
  /// In en, this message translates to:
  /// **'A space with this name already exists'**
  String get rel_svc_backup_space_name_already_exists;

  /// Space name validation range and single-line requirement.
  ///
  /// In en, this message translates to:
  /// **'Space name must be 1–80 characters'**
  String get rel_svc_backup_space_name_length_invalid;

  /// NextGen gateway address validation.
  ///
  /// In en, this message translates to:
  /// **'Enter the address of your Hermes dashboard.'**
  String get ng_rel_svc_backup_gateway_address_required;

  /// NextGen gateway address has an unsupported scheme.
  ///
  /// In en, this message translates to:
  /// **'The address must start with http:// or https:// (got {scheme}).'**
  String ng_rel_svc_backup_gateway_address_scheme(String scheme);

  /// NextGen gateway address parse failure.
  ///
  /// In en, this message translates to:
  /// **'That address is not valid.'**
  String get ng_rel_svc_backup_gateway_address_invalid;

  /// NextGen gateway address has no hostname.
  ///
  /// In en, this message translates to:
  /// **'The address has no host name.'**
  String get ng_rel_svc_backup_gateway_address_no_host;

  /// NextGen read-only secondary window cannot alter sign-in.
  ///
  /// In en, this message translates to:
  /// **'Sign in in the main window.'**
  String get ng_rel_svc_backup_sign_in_main_window;

  /// Recent sign-in renewal failed and is temporarily throttled.
  ///
  /// In en, this message translates to:
  /// **'The gateway couldn\'t renew the sign-in right now.'**
  String get rel_svc_backup_sign_in_renewal_failed;

  /// Sign-in renewal provider is unavailable.
  ///
  /// In en, this message translates to:
  /// **'The gateway couldn\'t renew the sign-in: its sign-in provider is unreachable.'**
  String get rel_svc_backup_sign_in_provider_unreachable;

  /// Sign-in renewal request timed out.
  ///
  /// In en, this message translates to:
  /// **'Timed out renewing the sign-in.'**
  String get rel_svc_backup_sign_in_renewal_timed_out;

  /// Gateway sign-in or renewal returned no tokens.
  ///
  /// In en, this message translates to:
  /// **'The gateway returned no sign-in tokens.'**
  String get rel_svc_backup_sign_in_no_tokens;

  /// NextGen gateway probe timed out.
  ///
  /// In en, this message translates to:
  /// **'Timed out. Check the address, VPN or Tailscale connection.'**
  String get ng_rel_svc_backup_probe_timed_out;

  /// NextGen gateway probe TLS failure; error is raw platform detail.
  ///
  /// In en, this message translates to:
  /// **'TLS handshake failed: {error}'**
  String ng_rel_svc_backup_probe_tls_failed(String error);

  /// NextGen sign-in received an unexpected HTTP status.
  ///
  /// In en, this message translates to:
  /// **'The gateway answered HTTP {statusCode}.'**
  String ng_rel_svc_backup_gateway_answered_http(int statusCode);

  /// NextGen sign-in gateway request timed out.
  ///
  /// In en, this message translates to:
  /// **'The gateway took too long to answer.'**
  String get ng_rel_svc_backup_gateway_answer_timed_out;

  /// NextGen could not open the local browser callback listener; error is raw detail.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get ready for the browser to come back: {error}'**
  String ng_rel_svc_backup_browser_callback_not_ready(String error);

  /// NextGen browser callback success page body.
  ///
  /// In en, this message translates to:
  /// **'You can go back to Hermes now.'**
  String get ng_rel_svc_backup_browser_signed_in_body;

  /// NextGen browser callback mismatch page title.
  ///
  /// In en, this message translates to:
  /// **'Waiting for sign-in'**
  String get ng_rel_svc_backup_browser_waiting_title;

  /// NextGen browser callback state did not match the current sign-in.
  ///
  /// In en, this message translates to:
  /// **'This page is not part of the current sign-in.'**
  String get ng_rel_svc_backup_browser_not_current;

  /// NextGen failed to launch the external browser for sign-in.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the browser to sign in.'**
  String get ng_rel_svc_backup_browser_open_failed;

  /// NextGen browser sign-in timed out.
  ///
  /// In en, this message translates to:
  /// **'The sign-in took too long. Try again.'**
  String get ng_rel_svc_backup_browser_sign_in_timed_out;

  /// NextGen gateway rejected browser token redemption.
  ///
  /// In en, this message translates to:
  /// **'The gateway refused the sign-in (HTTP {statusCode}).'**
  String ng_rel_svc_backup_gateway_refused_sign_in(int statusCode);

  /// Label for a Markdown caution alert banner.
  ///
  /// In en, this message translates to:
  /// **'Caution'**
  String get rel_svc_misc_alert_caution;

  /// Label for a Markdown important alert banner.
  ///
  /// In en, this message translates to:
  /// **'Important'**
  String get rel_svc_misc_alert_important;

  /// Label for a Markdown tip alert banner.
  ///
  /// In en, this message translates to:
  /// **'Tip'**
  String get rel_svc_misc_alert_tip;

  /// Label for a Markdown warning alert banner.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get rel_svc_misc_alert_warning;

  /// Approval scope explanation for a session-long folder grant.
  ///
  /// In en, this message translates to:
  /// **'Allow this folder until the session ends.'**
  String get rel_svc_misc_allow_folder_session;

  /// Approval scope explanation for a session-long website grant.
  ///
  /// In en, this message translates to:
  /// **'Allow this website until the session ends.'**
  String get rel_svc_misc_allow_website_session;

  /// Native notification title for an approval request. Title is the user or server supplied chat title.
  ///
  /// In en, this message translates to:
  /// **'Approval needed — {title}'**
  String rel_svc_misc_approval_needed_title(String title);

  /// Description of the @file composer reference starter.
  ///
  /// In en, this message translates to:
  /// **'Attach a file reference'**
  String get rel_svc_misc_attach_file_reference;

  /// Description of the @folder composer reference starter.
  ///
  /// In en, this message translates to:
  /// **'Attach a folder reference'**
  String get rel_svc_misc_attach_folder_reference;

  /// Description of the @git composer reference starter.
  ///
  /// In en, this message translates to:
  /// **'Attach git context'**
  String get rel_svc_misc_attach_git_context;

  /// Description of the @image composer reference starter.
  ///
  /// In en, this message translates to:
  /// **'Attach an image reference'**
  String get rel_svc_misc_attach_image_reference;

  /// Description of the @staged composer reference starter.
  ///
  /// In en, this message translates to:
  /// **'Attach the staged diff'**
  String get rel_svc_misc_attach_staged_diff;

  /// Description of the @tool composer reference starter.
  ///
  /// In en, this message translates to:
  /// **'Attach a tool reference'**
  String get rel_svc_misc_attach_tool_reference;

  /// Description of the @diff composer reference starter.
  ///
  /// In en, this message translates to:
  /// **'Attach the unstaged diff'**
  String get rel_svc_misc_attach_unstaged_diff;

  /// Description of the @url composer reference starter.
  ///
  /// In en, this message translates to:
  /// **'Attach a URL reference'**
  String get rel_svc_misc_attach_url_reference;

  /// Title of a completed background-task notice when the gateway supplies no task ID.
  ///
  /// In en, this message translates to:
  /// **'Background task completed'**
  String get rel_svc_misc_background_task_completed;

  /// Title of a completed background-task notice. TaskId is an opaque server task identifier.
  ///
  /// In en, this message translates to:
  /// **'Background task {taskId} completed'**
  String rel_svc_misc_background_task_named_completed(String taskId);

  /// Fallback chat title used while restoring a stored gateway turn.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get rel_svc_misc_chat;

  /// Live turn status while conversation context is being compacted.
  ///
  /// In en, this message translates to:
  /// **'Compacting conversation context…'**
  String get rel_svc_misc_compacting_context;

  /// Tool activity status with a preformatted elapsed duration such as 420 ms or 1.2 s.
  ///
  /// In en, this message translates to:
  /// **'Completed in {duration}'**
  String rel_svc_misc_completed_in(String duration);

  /// Live turn status after conversation context compaction completes.
  ///
  /// In en, this message translates to:
  /// **'Conversation context compacted'**
  String get rel_svc_misc_context_compacted;

  /// Cron update failure when the job read back from the gateway does not match the submitted model and fields.
  ///
  /// In en, this message translates to:
  /// **'Cron model read-back did not match'**
  String get rel_svc_misc_cron_readback_mismatch;

  /// Cron update failure when the gateway explicitly rejects the update.
  ///
  /// In en, this message translates to:
  /// **'Cron update rejected'**
  String get rel_svc_misc_cron_update_rejected;

  /// Approval scope explanation for denying folder access.
  ///
  /// In en, this message translates to:
  /// **'Do not grant this folder.'**
  String get rel_svc_misc_deny_folder_grant;

  /// Approval scope explanation for denying website access.
  ///
  /// In en, this message translates to:
  /// **'Do not grant this website.'**
  String get rel_svc_misc_deny_website_grant;

  /// Tool activity failure status with a preformatted elapsed duration such as 420 ms or 1.2 s.
  ///
  /// In en, this message translates to:
  /// **'Failed after {duration}'**
  String rel_svc_misc_failed_after(String duration);

  /// Folder approval fallback when the gateway omits the folder path.
  ///
  /// In en, this message translates to:
  /// **'The gateway did not name a folder.'**
  String get rel_svc_misc_gateway_folder_unnamed;

  /// Turn status after recovery finds an idle gateway but cannot prove the previous turn outcome.
  ///
  /// In en, this message translates to:
  /// **'The gateway is idle. The previous turn’s outcome could not be confirmed.'**
  String get rel_svc_misc_gateway_idle_unconfirmed;

  /// Fallback failure text when a gateway turn fails without a server-authored error.
  ///
  /// In en, this message translates to:
  /// **'Gateway turn failed'**
  String get rel_svc_misc_gateway_turn_failed;

  /// Fallback failure text that retains an unknown raw gateway turn status.
  ///
  /// In en, this message translates to:
  /// **'Gateway turn {status}'**
  String rel_svc_misc_gateway_turn_status(String status);

  /// Website approval fallback when the gateway omits the host.
  ///
  /// In en, this message translates to:
  /// **'The gateway did not name a website.'**
  String get rel_svc_misc_gateway_website_unnamed;

  /// Title of a gateway review-summary notice. Hermes is the product name.
  ///
  /// In en, this message translates to:
  /// **'Hermes review'**
  String get rel_svc_misc_hermes_review;

  /// Native notification title for a failed Hermes turn.
  ///
  /// In en, this message translates to:
  /// **'Hermes turn failed'**
  String get rel_svc_misc_hermes_turn_failed;

  /// Composer notice explaining the image recovery limitation on the companion recovery transport.
  ///
  /// In en, this message translates to:
  /// **'Image and text recovery is not available on companion recovery. An unacknowledged image send cannot be restored on this connection, and nothing is sent again automatically.'**
  String get rel_svc_misc_image_recovery_companion_gap;

  /// Composer notice explaining the image recovery limitation on Classic REST/SSE.
  ///
  /// In en, this message translates to:
  /// **'Image and text recovery is not available on Classic REST/SSE. An unacknowledged image send cannot be restored on this connection, and nothing is sent again automatically.'**
  String get rel_svc_misc_image_recovery_rest_gap;

  /// Native notification title for an input request. Title is the user or server supplied chat title.
  ///
  /// In en, this message translates to:
  /// **'Input needed — {title}'**
  String rel_svc_misc_input_needed_title(String title);

  /// Snack bar shown when an old parallel-workspace entry loses connection ownership.
  ///
  /// In en, this message translates to:
  /// **'The connection changed. Reopen it to use the workspace.'**
  String get rel_svc_misc_parallel_workspace_connection_changed;

  /// Tool activity status while a tool is preparing output.
  ///
  /// In en, this message translates to:
  /// **'Preparing'**
  String get rel_svc_misc_preparing;

  /// Approval scope explanation for permanently saving a folder grant.
  ///
  /// In en, this message translates to:
  /// **'Save this folder grant for later requests.'**
  String get rel_svc_misc_save_folder_grant;

  /// Approval scope explanation for permanently saving a website grant.
  ///
  /// In en, this message translates to:
  /// **'Save this website grant for later requests.'**
  String get rel_svc_misc_save_website_grant;

  /// Chat failure explaining that an unsent prompt was rejected after stored-session identity reconciliation found another admitted turn.
  ///
  /// In en, this message translates to:
  /// **'This chat was opened through its stored identity while another turn was admitted. The unsent prompt was not sent; retry explicitly after that turn finishes.'**
  String get rel_svc_misc_stored_identity_turn_conflict;

  /// Fallback title for a cron job with no name or ID.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get rel_svc_misc_untitled;

  /// Wake-word notice when client microphone capture contains only silence.
  ///
  /// In en, this message translates to:
  /// **'Client wake capture hears only silence — check OS microphone access and re-toggle wake word.'**
  String get rel_svc_misc_wake_capture_silent;

  /// Wake-word notice when client microphone capture stops delivering audio callbacks.
  ///
  /// In en, this message translates to:
  /// **'Client wake capture stalled: no microphone audio callbacks arrived.'**
  String get rel_svc_misc_wake_capture_stalled;

  /// Wake-word notice after consecutive audio frames are refused. Detail is either empty or a raw server reason in parentheses.
  ///
  /// In en, this message translates to:
  /// **'Wake-word feed refused {count} consecutive frames{detail} — re-toggle wake word to re-arm.'**
  String rel_svc_misc_wake_feed_refused(int count, String detail);

  /// Wake-word notice when the client microphone stream fails. Error is a raw local platform error.
  ///
  /// In en, this message translates to:
  /// **'Client wake microphone stream failed: {error}'**
  String rel_svc_misc_wake_microphone_failed(String error);

  /// Wake-word notice when the microphone track ends unexpectedly during capture.
  ///
  /// In en, this message translates to:
  /// **'Microphone track ended during wake-word capture — re-toggle wake word to re-arm.'**
  String get rel_svc_misc_wake_track_ended;

  /// Field heading for the host requested by a website-access approval.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get rel_svc_misc_website;

  /// Explanation when discovery on the local network reaches its time limit; displayed inside the discovery failure wrapper.
  ///
  /// In en, this message translates to:
  /// **'LAN discovery timed out'**
  String get rel_svc_lan_timeout;

  /// Lowercase reason in recent notification diagnostics when OS permission is denied.
  ///
  /// In en, this message translates to:
  /// **'permission denied'**
  String get rel_svc_notification_permission_denied;

  /// Lowercase recent-notification diagnostic explaining that notifications are disabled.
  ///
  /// In en, this message translates to:
  /// **'notifications are off'**
  String get rel_svc_notifications_off;

  /// Preview annotation chip: pin number followed by the user's note. Preserve the note verbatim.
  ///
  /// In en, this message translates to:
  /// **'#{number} {note}'**
  String rel_chat_preview_pin_label(int number, String note);

  /// Number badge over a pinned preview region; corresponds to the numbered annotation chip and crop.
  ///
  /// In en, this message translates to:
  /// **'#{number}'**
  String rel_chat_preview_pin_number(int number);

  /// NextGen chat toast combining the already localised wake-word status with an additional gateway notice. Preserve the supplied text verbatim.
  ///
  /// In en, this message translates to:
  /// **'{status} — {notice}'**
  String ng_rel_chat_wake_status_notice(String status, String notice);

  /// NextGen chat usage sheet cost value. Amount is preformatted to four decimal places; the dollar sign is the existing currency convention, not a request for currency conversion.
  ///
  /// In en, this message translates to:
  /// **'\${amount}'**
  String ng_rel_chat_cost_amount(String amount);

  /// NextGen chat usage sheet context usage ratio. Used and maximum are preformatted compact token counts.
  ///
  /// In en, this message translates to:
  /// **'{used} / {maximum}'**
  String ng_rel_chat_context_ratio(String used, String maximum);

  /// NextGen chat connection banner combining an already localised connection status with its supplied reason. Preserve both supplied messages.
  ///
  /// In en, this message translates to:
  /// **'{status} {reason}'**
  String ng_rel_chat_connection_reason(String status, String reason);

  /// NextGen transcript notice followed by its preformatted timestamp. Message is incoming notice text and must remain verbatim.
  ///
  /// In en, this message translates to:
  /// **'{message} · {time}'**
  String ng_rel_chat_notice_time(String message, String time);

  /// NextGen user-message attachment pill combining the original filename with an already localised upload-progress label.
  ///
  /// In en, this message translates to:
  /// **'{name} · {progress}'**
  String ng_rel_chat_attachment_progress(String name, String progress);

  /// NextGen assistant tool disclosure label while a tool is running and has a non-null detail. Tool name is a protocol identifier; preserve it and the supplied detail verbatim.
  ///
  /// In en, this message translates to:
  /// **'{name} · {detail}'**
  String ng_rel_chat_tool_detail(String name, String detail);

  /// No description provided for @fleet_managed_ssh_title.
  ///
  /// In en, this message translates to:
  /// **'Gateway-managed SSH'**
  String get fleet_managed_ssh_title;

  /// No description provided for @fleet_managed_ssh_intro.
  ///
  /// In en, this message translates to:
  /// **'Manage SSH hosts already saved on this gateway, from any device. Hermes must already be installed on the remote host. This starts or attaches an owned remote service, not an Ares chat connection. Managed updates and recovery are available only in native Desktop.'**
  String get fleet_managed_ssh_intro;

  /// No description provided for @fleet_managed_ssh_read.
  ///
  /// In en, this message translates to:
  /// **'Read saved SSH hosts'**
  String get fleet_managed_ssh_read;

  /// No description provided for @fleet_managed_ssh_trust.
  ///
  /// In en, this message translates to:
  /// **'On this first connection, the gateway will trust and remember this host’s SSH key. A later key change will be flagged and blocked. The gateway does not report the key fingerprint, so Ares cannot display or store it. Only continue if you trust this first connection.'**
  String get fleet_managed_ssh_trust;

  /// No description provided for @fleet_managed_ssh_changed.
  ///
  /// In en, this message translates to:
  /// **'This host’s SSH key changed. Connection blocked. Someone with access to the gateway host must independently verify the new key fingerprint and remove the old trusted key there. Retry only after that verification and repair. Ares does not replace the trusted key.'**
  String get fleet_managed_ssh_changed;

  /// No description provided for @fleet_managed_ssh_disconnect_warning.
  ///
  /// In en, this message translates to:
  /// **'Disconnect the SSH tunnel and stop the remote service owned by this gateway? This can interrupt other clients using that service.'**
  String get fleet_managed_ssh_disconnect_warning;

  /// No description provided for @fleet_managed_ssh_verify.
  ///
  /// In en, this message translates to:
  /// **'Verify the key yourself instead'**
  String get fleet_managed_ssh_verify;

  /// No description provided for @fleet_managed_ssh_pending.
  ///
  /// In en, this message translates to:
  /// **'Waiting for the gateway: {seconds} s. Leaving this page does not cancel bootstrap. If the request fails, check status before retrying.'**
  String fleet_managed_ssh_pending(int seconds);

  /// No description provided for @fleet_managed_ssh_status.
  ///
  /// In en, this message translates to:
  /// **'Host: {host}\nGateway loopback port: {localPort}\nRemote loopback port: {remotePort}\nHermes: {version}\nReused: {reused}'**
  String fleet_managed_ssh_status(
    String host,
    int localPort,
    int remotePort,
    String version,
    String reused,
  );

  /// No description provided for @fleet_managed_ssh_disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get fleet_managed_ssh_disconnect;

  /// No description provided for @ng_slash_suggestions_loading.
  ///
  /// In en, this message translates to:
  /// **'Loading commands…'**
  String get ng_slash_suggestions_loading;

  /// No description provided for @ng_slash_suggestions_empty.
  ///
  /// In en, this message translates to:
  /// **'No matching commands'**
  String get ng_slash_suggestions_empty;

  /// No description provided for @ng_slash_suggestions_label.
  ///
  /// In en, this message translates to:
  /// **'Command suggestions'**
  String get ng_slash_suggestions_label;

  /// No description provided for @ng_slash_suggestions_skill.
  ///
  /// In en, this message translates to:
  /// **'Skill'**
  String get ng_slash_suggestions_skill;

  /// No description provided for @settings_classic_title.
  ///
  /// In en, this message translates to:
  /// **'Classic Settings'**
  String get settings_classic_title;

  /// No description provided for @settings_nextgen_title.
  ///
  /// In en, this message translates to:
  /// **'NextGen Settings'**
  String get settings_nextgen_title;

  /// No description provided for @settings_category_general.
  ///
  /// In en, this message translates to:
  /// **'General & language'**
  String get settings_category_general;

  /// No description provided for @settings_category_chat.
  ///
  /// In en, this message translates to:
  /// **'Chat & sessions'**
  String get settings_category_chat;

  /// No description provided for @settings_category_device.
  ///
  /// In en, this message translates to:
  /// **'Device & shortcuts'**
  String get settings_category_device;

  /// No description provided for @settings_category_connections.
  ///
  /// In en, this message translates to:
  /// **'Connections & models'**
  String get settings_category_connections;

  /// No description provided for @settings_category_security.
  ///
  /// In en, this message translates to:
  /// **'Privacy & backup'**
  String get settings_category_security;

  /// No description provided for @settings_category_about.
  ///
  /// In en, this message translates to:
  /// **'About & help'**
  String get settings_category_about;

  /// No description provided for @settings_reopen_chat.
  ///
  /// In en, this message translates to:
  /// **'Restore last chat when returning to a gateway'**
  String get settings_reopen_chat;

  /// No description provided for @settings_reopen_chat_hint.
  ///
  /// In en, this message translates to:
  /// **'Cold starts open the welcome screen. Links and notifications open the requested chat.'**
  String get settings_reopen_chat_hint;

  /// No description provided for @settings_danger.
  ///
  /// In en, this message translates to:
  /// **'Danger zone'**
  String get settings_danger;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'ja',
    'ko',
    'pt',
    'ru',
    'uk',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'uk':
      return AppLocalizationsUk();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
