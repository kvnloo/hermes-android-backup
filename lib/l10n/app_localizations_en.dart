// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get attachment_audio_failed =>
      'This audio could not be played. Its format or codec may not be supported, or the preview size limit was exceeded. Retry, or save or share the original file.';

  @override
  String get attachment_audio_seek => 'Audio position';

  @override
  String get workspace_workers => 'Live workers';

  @override
  String get workers_unattached =>
      'Counts only. To steer a worker, choose Live workers in its attached parent chat.';

  @override
  String get slash_local_arguments =>
      'This shortcut does not accept arguments here. Use the app controls; your draft was kept.';

  @override
  String get fallback_title => 'Fallback models';

  @override
  String get fallback_notice =>
      'Tried in order when the main model is unavailable. Changes apply to this profile only; save the complete list explicitly.';

  @override
  String get fallback_unavailable =>
      'Fallback settings are unavailable or invalid. Check the connection, selected profile and host version, then retry.';

  @override
  String get fallback_discovery_unavailable =>
      'Provider discovery is unavailable. Existing entries are preserved; retry to choose providers and models.';

  @override
  String get fallback_empty => 'No entries in this fallback list.';

  @override
  String get fallback_incomplete =>
      'Choose a provider and model for every entry, or remove incomplete entries before saving.';

  @override
  String get fallback_add => 'Add fallback';

  @override
  String get fallback_save => 'Save fallback list';

  @override
  String get fallback_save_failed =>
      'Could not verify the saved fallback list. Your draft is preserved. Retry saving or refresh to reload the host settings.';

  @override
  String get fallback_saved => 'Fallback list saved and verified.';

  @override
  String get fallback_legacy_title => 'Legacy fallbacks (read-only)';

  @override
  String get fallback_legacy_notice =>
      'The host also uses fallback_model after this list, skipping duplicate routes. These legacy entries are preserved, even when the list above is empty. Edit them on the host.';

  @override
  String fallback_priority(String position) {
    return 'Priority $position';
  }

  @override
  String get fallback_move_up => 'Move up';

  @override
  String get fallback_move_down => 'Move down';

  @override
  String get fallback_routing_read_only =>
      'Routing details or an unlisted provider are preserved. Edit this provider/model on the host; you can still reorder or remove the entry.';

  @override
  String get cron_model_default => 'Follow default';

  @override
  String get cron_model_notice =>
      'Applies only to this cron job. Without a pin, Hermes uses the cron default, then the main model. Manage custom models on the host.';

  @override
  String get model_management_unavailable =>
      'Model settings could not be loaded or saved. Refresh and try again.';

  @override
  String get model_management_subtitle =>
      'Main, fallback and auxiliary models for this profile';

  @override
  String get usage => 'Usage';

  @override
  String get nous_portal => 'Nous Portal';

  @override
  String get portal_menu_subtitle => 'Gateway status and recorded usage';

  @override
  String get portal_read_only =>
      'Read-only gateway data. Manage Nous authentication on the Hermes host. Subscription balances and credits are not provided by these endpoints.';

  @override
  String get portal_status => 'Gateway Portal status';

  @override
  String get portal_free_tier => 'Free-tier access (not a signed-in account)';

  @override
  String get portal_signed_in => 'Signed in';

  @override
  String get portal_signed_out => 'Not signed in';

  @override
  String get portal_account_tier => 'Account tier';

  @override
  String get portal_recorded_usage => 'Recorded usage';

  @override
  String get portal_all_providers =>
      'All providers in the selected gateway profile. Recorded zero cost does not mean a model is free.';

  @override
  String portal_period(String days) {
    return 'Last $days days';
  }

  @override
  String get portal_sessions => 'Sessions';

  @override
  String get portal_input => 'Input tokens';

  @override
  String get portal_output => 'Output tokens';

  @override
  String get portal_estimated => 'Estimated recorded cost';

  @override
  String get portal_actual => 'Actual recorded cost';

  @override
  String get portal_recorded_models => 'Recorded models';

  @override
  String get portal_no_models => 'No recorded models.';

  @override
  String get portal_unavailable =>
      'Unavailable. Check the connection, selected profile and gateway version, then retry.';

  @override
  String get paste_attachment_failed_text_kept =>
      'Could not attach the paste. The text was kept in the message.';

  @override
  String get background_task_report => 'Background task';

  @override
  String get background_process_report => 'Background process';

  @override
  String get background_report_issues =>
      'Issues reported — expand for details.';

  @override
  String get background_report_expand => 'Expand report';

  @override
  String get background_report_collapse => 'Collapse report';

  @override
  String get ng_brand_open_chat => 'Open a chat';

  @override
  String get ng_brand_recent => 'Recent';

  @override
  String get ng_brand_sidebar_hint => 'or pick a chat from the sidebar';

  @override
  String get copy_session_id => 'Copy session ID';

  @override
  String get copy_session_id_failed => 'Could not copy the session ID.';

  @override
  String get setup_interface_title => 'Choose your interface';

  @override
  String get setup_interface_classic => 'Classic';

  @override
  String get setup_interface_nextgen => 'NextGen';

  @override
  String get setup_interface_classic_description =>
      'The original Ares workspace, with full connection controls and every Classic setting.';

  @override
  String get setup_interface_nextgen_description =>
      'A newer look with one dashboard sign-in, live plans, subagents and notifications.';

  @override
  String get setup_interface_switch_later =>
      'You can switch at any time in Settings.';

  @override
  String get ng_confirm_model_switch => 'Switch model?';

  @override
  String get ng_switch => 'Switch';

  @override
  String get ng_model_confirmation_required =>
      'This model needs confirmation before it can be selected.';

  @override
  String ng_model_switches_next_turn(String model) {
    return 'Switches to $model at the next turn.';
  }

  @override
  String get ng_model_switch_not_connected =>
      'The chat is not ready for a model switch. Reopen it and try again.';

  @override
  String ng_gateway_kept_default_model(String model) {
    return 'The gateway kept $model for this chat. Pick the model again before sending.';
  }

  @override
  String get hands_free_title => 'Hands-free';

  @override
  String get hands_free_start => 'Start hands-free';

  @override
  String get hands_free_stop => 'Stop hands-free';

  @override
  String get hands_free_preparing => 'Preparing voice — wait for ready';

  @override
  String get hands_free_listening => 'Say Hey Hermes';

  @override
  String get hands_free_recording => 'Ready — speak now';

  @override
  String get hands_free_waiting => 'Waiting for Hermes';

  @override
  String get hands_free_speaking => 'Speaking — microphone off';

  @override
  String hands_free_followup(int seconds) {
    return 'Listen up to $seconds seconds';
  }

  @override
  String get hands_free_error => 'Hands-free stopped';

  @override
  String get hands_free_setup => 'Hands-free setup';

  @override
  String hands_free_preview(String transcript) {
    return 'Voice preview: $transcript';
  }

  @override
  String get hands_free_short_disclosure =>
      'Only while this chat is open in the foreground. Wake is offline; speech may use networks. Uses battery.';

  @override
  String get hands_free_error_action =>
      'Check microphone permission, speech service, reply voice and connection, then press Stop and Start to retry. Nothing is resent.';

  @override
  String get hands_free_disclosure =>
      'Wake detection runs offline on the CPU. Android speech recognition, the selected reply voice and gateway may use networks. Listening uses battery and false activations are possible. Stops when this chat is covered, closed or no longer foreground; reopening never restarts it. Manual dictation stays an editable draft.';

  @override
  String get hands_free_ready_cue =>
      'Say “Hey Hermes”, wait for “Ready — speak now”, then speak. No same-breath capture or pre-roll. If permission setup leaves the app, press Start again after granting it.';

  @override
  String get hands_free_settings_title => 'Hands-free voice';

  @override
  String get hands_free_settings_subtitle =>
      'Show the “Hey Hermes” start control in chats. Turning it off stops any running hands-free session.';

  @override
  String get hands_free_timing_limit =>
      'The follow-up window is a maximum, not a minimum. Android may stop earlier. Silence returns to local wake listening without repeated recognition restarts.';

  @override
  String get hands_free_followup_off =>
      'Follow-up off — say Hey Hermes for each prompt';

  @override
  String get hands_free_start_blocked =>
      'Start requires an empty draft, no attachments, an idle connected chat and spoken replies enabled. Finish any manual voice action first.';

  @override
  String get hands_free_setup_complete =>
      'Microphone setup finished. Press Start again.';

  @override
  String message_time_recorded(String time) {
    return 'Recorded by server: $time (local time)';
  }

  @override
  String message_time_sent(String time) {
    return 'Send observed on this device: $time (local time)';
  }

  @override
  String message_time_received(String time) {
    return 'First received on this device: $time (local time)';
  }

  @override
  String get stop_and_send => 'Stop and send';

  @override
  String get message_queued_for_running_turn =>
      'Message queued for the current run.';

  @override
  String get running_message_not_accepted =>
      'Hermes could not accept this message. Your draft was kept; stop the response or wait, then send again.';

  @override
  String get running_message_delivery_unknown =>
      'Message delivery could not be confirmed. Your draft was kept. Check the chat before retrying.';

  @override
  String get attachment_tap_to_preview => 'Tap to preview';

  @override
  String get attachment_save => 'Save';

  @override
  String get attachment_share => 'Share';

  @override
  String get attachment_saved => 'File saved';

  @override
  String get attachment_save_cancelled => 'Save cancelled';

  @override
  String get attachment_save_failed =>
      'Could not save this file. Please try again.';

  @override
  String get attachment_share_failed =>
      'Could not share this file. Please try again.';

  @override
  String get attachment_download_failed =>
      'Could not load this file. Check the connection and try again.';

  @override
  String get attachment_no_inline_preview =>
      'No inline preview is available for this file type. Save or share the original file to open it in another app.';

  @override
  String get attachment_image_failed =>
      'This image could not be decoded. You can still save or share the original file.';

  @override
  String get attachment_text_truncated =>
      'Preview shortened. Save or share the file to read all of it.';

  @override
  String get attachment_text_unavailable =>
      'This file could not be displayed as text. Save or share the original file.';

  @override
  String get attachment_pdf_failed =>
      'This PDF could not be previewed. Save or share the original file.';

  @override
  String get attachment_pdf_unavailable =>
      'PDF previews are available on Android. You can still save or share this file.';

  @override
  String attachment_pdf_page(int page, int total) {
    return 'Page $page of $total';
  }

  @override
  String get attachment_previous_page => 'Previous page';

  @override
  String get attachment_next_page => 'Next page';

  @override
  String get attachment_loading => 'Loading preview…';

  @override
  String get attachment_document_text_notice =>
      'Text preview. Layout, images and formatting may differ from the original.';

  @override
  String get attachment_document_failed =>
      'This document could not be previewed. Save or share the original file.';

  @override
  String get attachment_document_empty =>
      'No readable text was found in this document.';

  @override
  String get attachment_video_failed =>
      'This video could not be played. Its format or codec may not be supported. Save or share the original file.';

  @override
  String get attachment_video_play => 'Play';

  @override
  String get attachment_video_pause => 'Pause';

  @override
  String get attachment_video_mute => 'Mute';

  @override
  String get attachment_video_unmute => 'Unmute';

  @override
  String get attachment_video_seek => 'Video position';

  @override
  String get attachment_close => 'Close preview';

  @override
  String get attachment_retry => 'Retry';

  @override
  String get saved_history_heading => 'Saved history';

  @override
  String get received_output_heading =>
      'Received output — match to saved history unconfirmed';

  @override
  String get received_output_details => 'About received output';

  @override
  String get received_output_explanation =>
      'This may also appear in saved history. The app cannot confirm a match.';

  @override
  String get local_prompt_context => 'Local prompt context';

  @override
  String get received_output_badge => 'Received · match unconfirmed';

  @override
  String get received_output_lifetime =>
      'Received output is kept temporarily in this app session and may be shortened or removed as limits are reached. It may not be available after the app or connection is closed.';

  @override
  String get theme_palette => 'Colour theme';

  @override
  String get theme_palette_gold => 'Gold';

  @override
  String get theme_palette_purple => 'Purple';

  @override
  String get theme_palette_orange => 'Orange';

  @override
  String get theme_palette_green => 'Green';

  @override
  String get theme_palette_blue => 'Blue';

  @override
  String get theme_palette_red => 'Red';

  @override
  String get theme_palette_teal => 'Teal';

  @override
  String get theme_palette_pink => 'Pink';

  @override
  String get theme_palette_indigo => 'Indigo';

  @override
  String get theme_palette_cyan => 'Cyan';

  @override
  String get assets_recent_subtitle =>
      'Find files shared by Hermes in saved chats';

  @override
  String get assets_scope_notice =>
      'Generated files explicitly shared by Hermes in saved replies. This is a partial view of chat history, not a complete file or attachment catalogue. Referenced files may no longer exist.';

  @override
  String get assets_download_limit =>
      'Files are loaded only when tapped. Previews and downloads are limited to 25 MiB each; use the dashboard for larger files.';

  @override
  String get assets_search_hint => 'Search found files or source chats';

  @override
  String get assets_all => 'All';

  @override
  String get assets_images => 'Images';

  @override
  String get assets_audio => 'Audio';

  @override
  String get assets_video => 'Video';

  @override
  String get assets_documents => 'Documents and other files';

  @override
  String get assets_empty => 'No assets found in scanned messages';

  @override
  String get assets_empty_detail =>
      'Scan more chats or older messages to look further back. Ordinary attachments and unlinked files are not indexed here.';

  @override
  String get assets_no_matches => 'No matching assets';

  @override
  String get assets_load_more_chats => 'Scan more chats';

  @override
  String get assets_load_older_messages => 'Scan older messages';

  @override
  String get assets_load_failed =>
      'Some history could not be read. Results are incomplete. Check the dashboard connection and retry.';

  @override
  String get assets_retry_failed => 'Retry failed history reads';

  @override
  String get assets_partial =>
      'The server reported incomplete history. Refresh after checking the dashboard.';

  @override
  String assets_scan_summary(int files, int chats) {
    return '$files file references found across $chats scanned chats';
  }

  @override
  String assets_open_chat(String title) {
    return 'Open chat: $title';
  }

  @override
  String get assets_file_too_large =>
      'This file exceeds the download limit. Open the dashboard to download it.';

  @override
  String get a_one_off_question_archives_itself_after_72_hours_anything =>
      'A one-off question. Archives itself after 72 hours; anything worth keeping is still remembered.';

  @override
  String get archive_chat => 'Archive chat';

  @override
  String get unarchive_chat => 'Unarchive chat';

  @override
  String get chat_archived => 'Chat archived';

  @override
  String get chat_unarchived => 'Chat unarchived';

  @override
  String could_not_update_chat_archive(Object error) {
    return 'Could not update chat archive: $error';
  }

  @override
  String get quick_chat_description => 'A one-off question.';

  @override
  String get ai_full_text => 'AI + full-text';

  @override
  String get ai_search_model => 'AI search model';

  @override
  String ai_searched_for(Object aiRewrittenQuery) {
    return 'AI searched for: $aiRewrittenQuery';
  }

  @override
  String get ai_assisted_filing => 'AI-assisted filing';

  @override
  String get api_key => 'API Key';

  @override
  String get api_server_key_from_hermes_env =>
      'API_SERVER_KEY from ~/.hermes/.env';

  @override
  String get active => 'Active';

  @override
  String get activity => 'Activity';

  @override
  String get activity_reads_the_durable_turn_journal_to_know_what_hermes =>
      'Activity reads the durable turn journal to know what Hermes is doing. Check that the gateway is reachable, then try again.';

  @override
  String get add => 'Add';

  @override
  String get add_connection => 'Add Connection';

  @override
  String get add_cron_job => 'Add Cron Job';

  @override
  String get add_gateway_connection => 'Add Gateway Connection';

  @override
  String get add_and_update_connections_from_the_backup_keep_the_rest =>
      'Add and update connections from the backup, keep the rest.';

  @override
  String get add_attachment => 'Add attachment';

  @override
  String get add_new_cron_job => 'Add new cron job';

  @override
  String get add_to_chat => 'Add to chat';

  @override
  String get all_chats => 'All chats';

  @override
  String get all_stored_message_content => 'All stored message content';

  @override
  String get allow_for_this_session => 'Allow for this session';

  @override
  String get allow_matching_commands_until_this_hermes_session_ends =>
      'Allow matching commands until this Hermes session ends.';

  @override
  String get allow_folder_until_sandbox_off =>
      'Allow this folder until the sandbox is switched off.';

  @override
  String get allow_once => 'Allow once';

  @override
  String get allow_website_until_sandbox_off =>
      'Allow this website until the sandbox is switched off.';

  @override
  String get always_allow => 'Always allow';

  @override
  String get apply_to_this_chat => 'Apply to this chat';

  @override
  String get approval_needed => 'Approval needed';

  @override
  String get approval_needed_description =>
      'A command is waiting for your approval or denial.';

  @override
  String get approve => 'Approve';

  @override
  String get archive => 'Archive';

  @override
  String get archive_project => 'Archive project';

  @override
  String archive_2(Object projectName) {
    return 'Archive $projectName?';
  }

  @override
  String archive_3(Object name) {
    return 'Archive $name?';
  }

  @override
  String get archived => 'Archived';

  @override
  String get archived_conversations_appear_here =>
      'Only archived conversations appear here. Older chats remain in All chats.';

  @override
  String get archived_quick_chats => 'Archived quick chats';

  @override
  String get artifacts_attachments_and_generated_media =>
      'Artifacts, attachments, and generated media';

  @override
  String get ask_ai_to_find_a_conversation => 'Ask AI to find a conversation';

  @override
  String get assets => 'Assets';

  @override
  String get assets_need_a_server_authoritative_assets_index_in_the_hermes =>
      'Assets need a server-authoritative Assets index in the Hermes Gateway before they can be shown per project.';

  @override
  String get assets_unavailable => 'Assets unavailable';

  @override
  String get attach_image_or_file => 'Attach image or file';

  @override
  String get attachment_drafts => 'Attachment drafts';

  @override
  String get recover_text_draft => 'Recover a text draft';

  @override
  String get undo_draft_recovery => 'Undo';

  @override
  String get draft_session_exists =>
      'This chat still exists. Open it to continue your draft.';

  @override
  String get draft_recovery_unavailable =>
      'Could not verify this draft. Nothing was changed.';

  @override
  String attachment_of(Object index, Object total) {
    return 'Attachment $index of $total';
  }

  @override
  String get auto_device_default => 'Auto (device default)';

  @override
  String get agent => 'Agent';

  @override
  String get autonomous_agents => 'Autonomous agents';

  @override
  String get background_recovery_unavailable_legacy_transport =>
      'Background recovery unavailable — legacy transport';

  @override
  String get background_task_completed => 'Background task complete';

  @override
  String get background_task_completed_description =>
      'A background terminal command finished.';

  @override
  String get backup_restore => 'Backup & restore';

  @override
  String backup_exported(Object destination) {
    return 'Backup exported — $destination';
  }

  @override
  String get base_url => 'Base URL';

  @override
  String get binary_preview_is_unavailable_download_the_file_to_open_it =>
      'Binary preview is unavailable. Download the file to open it.';

  @override
  String get branch => 'Branch';

  @override
  String get branch_chat => 'Branch chat';

  @override
  String get branch_created_in_hermes_history =>
      'Branch created in Hermes history.';

  @override
  String get browse_and_manage_your_hermes_agent_sessions_from_your_phone =>
      'Browse and manage your Hermes Agent sessions from your phone. Connects to a Hermes dashboard running on your local network.';

  @override
  String get browse_server_files => 'Browse server files';

  @override
  String get browse_the_miniserver_folders_behind_your_projects =>
      'Browse the miniserver folders behind your projects';

  @override
  String get cancel => 'Cancel';

  @override
  String get cancel_voice_input => 'Cancel voice input';

  @override
  String cannot_reach(Object host, Object port) {
    return 'Cannot reach $host:$port.';
  }

  @override
  String cannot_reach_check_the_host_and_port(Object host, Object port) {
    return 'Cannot reach $host:$port. Check the host and port.';
  }

  @override
  String get change_ai_search_model => 'Change AI search model';

  @override
  String changes_the_default_for_use_the_selector_in_a_chat(Object label) {
    return 'Changes the default for $label. Use the selector in a chat to override only that conversation.';
  }

  @override
  String get chat_actions => 'Chat actions';

  @override
  String get chats => 'Chats';

  @override
  String get chats_from_this_gateway_are_not_grouped_yet_grouping_stays =>
      'Chats from this gateway are not grouped yet. Grouping stays on this phone until the gateway can host projects.';

  @override
  String get chats_in_this_project_will_show_their_state_and_last =>
      'Chats in this project will show their state and last activity here.';

  @override
  String get chats_that_are_not_assigned_to_a_project =>
      'Chats that are not assigned to a Project';

  @override
  String get chats_you_start_in_this_project_will_appear_here_on =>
      'Chats you start in this project will appear here, on every device signed in to this Hermes.';

  @override
  String get check_that_the_gateway_is_running_and_reachable_then_try =>
      'Check that the gateway is running and reachable, then try again.';

  @override
  String get check_the_dashboard_connection_and_try_again =>
      'Check the Dashboard connection and try again.';

  @override
  String get check_the_connection_and_try_again =>
      'Check the connection and try again.';

  @override
  String get choose_a_small_model_to_rewrite_queries =>
      'Choose a small model to rewrite queries';

  @override
  String get choose_an_ai_search_model_before_using_ai_search =>
      'Choose an AI search model before using AI search.';

  @override
  String get choose_an_active_project_next => 'Choose an active Project next';

  @override
  String get choose_chat_model => 'Choose chat model';

  @override
  String get choose_files => 'Choose files';

  @override
  String get choose_image => 'Choose image';

  @override
  String get choose_images => 'Choose images';

  @override
  String get choose_its_destination_space => 'Choose its destination space';

  @override
  String get clear_search => 'Clear search';

  @override
  String get close => 'Close';

  @override
  String get code_copied => 'Code copied';

  @override
  String get code_format => 'Code';

  @override
  String get coming_next => 'Coming next';

  @override
  String get command => 'Command';

  @override
  String get command_palette => 'Command palette';

  @override
  String get command_palette_hint => 'Type a command';

  @override
  String get command_palette_no_results => 'No commands found';

  @override
  String get command_palette_new_chat => 'New chat';

  @override
  String get command_palette_search_chats => 'Search chats';

  @override
  String get command_palette_toggle_theme => 'Toggle theme';

  @override
  String get command_palette_copy_last_code => 'Copy last code block';

  @override
  String get command_line_chats => 'Command-line chats';

  @override
  String get compatibility_mode => 'Compatibility mode';

  @override
  String get configure_a_valid_desktop_gateway_url_before_attaching_files =>
      'Configure a valid Desktop Gateway URL before attaching files.';

  @override
  String get confirm_always_allow => 'Confirm always allow';

  @override
  String get confirm_passphrase => 'Confirm passphrase';

  @override
  String connecting_to(Object baseUrl) {
    return 'Connecting to $baseUrl...';
  }

  @override
  String get connection_issue => 'Connection issue';

  @override
  String
  get connection_switched_the_running_reply_continues_on_the_server_and =>
      'Connection switched — the running reply continues on the server and will reattach automatically.';

  @override
  String get connection_appearance_and_device_preferences =>
      'Connection, appearance, and device preferences';

  @override
  String context_tokens(Object effectiveContextLength) {
    return 'Context: $effectiveContextLength tokens';
  }

  @override
  String get continue_label => 'Continue';

  @override
  String get continue_working => 'Continue working';

  @override
  String get conversations_in_this_project => 'Conversations in this project';

  @override
  String get copy_code => 'Copy code';

  @override
  String get copy_message => 'Copy message';

  @override
  String could_not_branch_chat(Object error) {
    return 'Could not branch chat: $error';
  }

  @override
  String could_not_delete_session(Object error) {
    return 'Could not delete session: $error';
  }

  @override
  String could_not_deny_the_command(Object error) {
    return 'Could not deny the command: $error';
  }

  @override
  String could_not_load_ai_search_models(Object error) {
    return 'Could not load AI search models: $error';
  }

  @override
  String get could_not_load_conversations => 'Could not load conversations';

  @override
  String get could_not_load_files => 'Could not load files';

  @override
  String could_not_load_models_for_this_profile(Object error) {
    return 'Could not load models for this profile: $error';
  }

  @override
  String could_not_load_more_chats(Object error) {
    return 'Could not load more chats: $error';
  }

  @override
  String get could_not_open_link => 'Could not open this link.';

  @override
  String get could_not_open_the_hermes_dashboard =>
      'Could not open the Hermes dashboard.';

  @override
  String get could_not_open_this_project => 'Could not open this project';

  @override
  String get could_not_preview_file => 'Could not preview file';

  @override
  String get could_not_reach_hermes => 'Could not reach Hermes';

  @override
  String could_not_reach_authenticate_the_dashboard_at_check_the_port(
    Object dashboardPort,
    Object host,
  ) {
    return 'Could not reach/authenticate the dashboard at $host:$dashboardPort. Check the port and credentials.';
  }

  @override
  String get could_not_read_activity => 'Could not read activity';

  @override
  String could_not_rename_chat(Object error) {
    return 'Could not rename chat: $error';
  }

  @override
  String could_not_send_the_approval(Object error) {
    return 'Could not send the approval: $error';
  }

  @override
  String get could_not_skip_the_hermes_question =>
      'Could not skip the Hermes question.';

  @override
  String could_not_the_project(Object action, Object error) {
    return 'Could not $action the project: $error';
  }

  @override
  String get couldn_t_delete_project => 'Couldn’t delete project';

  @override
  String couldn_t_load_runs(Object error) {
    return 'Couldn’t load runs: $error';
  }

  @override
  String get couldn_t_move_conversation => 'Couldn’t move conversation';

  @override
  String couldn_t_move_to(Object label, Object reason) {
    return 'Couldn’t move to $label: $reason';
  }

  @override
  String get couldn_t_prepare_the_shared_files =>
      'Couldn’t prepare the shared files.';

  @override
  String get couldn_t_promote_conversation => 'Couldn’t promote conversation';

  @override
  String couldn_t_project(Object action) {
    return 'Couldn’t $action project';
  }

  @override
  String get create => 'Create';

  @override
  String get create_a_project => 'Create a project';

  @override
  String get create_a_project_first_then_chats_can_live_inside_it =>
      'Create a project first, then chats can live inside it.';

  @override
  String get create_a_space_to_separate_related_conversations =>
      'Create a space to separate related conversations.';

  @override
  String get create_branch => 'Create branch';

  @override
  String get credit_notifications => 'Credit notifications';

  @override
  String get credit_notifications_description =>
      'Credit usage was stopped or restored.';

  @override
  String get cron => 'Cron';

  @override
  String get crons => 'Crons';

  @override
  String get cron_conversations_empty =>
      'Conversations from scheduled jobs appear here, including older runs.';

  @override
  String get search_cron_conversations => 'Search cron conversations';

  @override
  String get cron_jobs => 'Cron Jobs';

  @override
  String cron_schedule_timezone(Object zone) {
    return 'Schedule timezone: $zone';
  }

  @override
  String get crons_upcoming => 'Upcoming';

  @override
  String get crons_history => 'History';

  @override
  String cron_time_with_zone(Object time, Object zone) {
    return '$time ($zone)';
  }

  @override
  String cron_time_zone_unknown(Object time) {
    return '$time (timezone unknown)';
  }

  @override
  String get cron_no_next_run => 'No next run scheduled';

  @override
  String get cron_status_scheduled => 'Scheduled';

  @override
  String get cron_status_paused => 'Paused';

  @override
  String cron_delivers_to(Object target) {
    return 'Delivers to $target';
  }

  @override
  String get cron_upcoming_empty_title => 'No scheduled jobs';

  @override
  String get cron_upcoming_empty_message =>
      'Nothing is scheduled to run. Create a job in Cron Jobs, or ask the agent to schedule one.';

  @override
  String get cron_upcoming_unavailable => 'Scheduled jobs unavailable';

  @override
  String get cron_upcoming_needs_dashboard =>
      'Scheduled jobs need a Dashboard connection. This address does not expose the cron schedule. Check the Dashboard address and host support.';

  @override
  String get cron_upcoming_needs_dashboard_auth =>
      'Scheduled jobs need Dashboard authentication. Add this connection’s dashboard username and password, or enable proxied mode.';

  @override
  String get cron_upcoming_dashboard_unreachable =>
      'The Dashboard could not be reached. Check the host, dashboard port and network, then retry.';

  @override
  String get cron_upcoming_load_failed =>
      'The scheduled jobs could not be read. Check the Dashboard connection, then retry.';

  @override
  String get cron_upcoming_refresh_failed =>
      'Could not refresh the schedule. Showing the last successful read.';

  @override
  String get cron_job_added => 'Cron job added';

  @override
  String get cron_job_updated => 'Cron job updated';

  @override
  String get cron_run => 'Cron run';

  @override
  String get cross_device_ordering_and_reversible_bulk_organization =>
      'Cross-device ordering and reversible bulk organization';

  @override
  String get current_profile_default => 'Current profile default';

  @override
  String get custom_proxy_and_dashboard_details =>
      'Custom proxy and dashboard details';

  @override
  String get dark => 'Dark';

  @override
  String get dashboard_proxy_settings => 'Dashboard / Proxy Settings';

  @override
  String get dashboard_password_optional => 'Dashboard Password (optional)';

  @override
  String get dashboard_port => 'Dashboard Port';

  @override
  String get dashboard_username_optional => 'Dashboard Username (optional)';

  @override
  String get dashboard_behind_proxy => 'Dashboard behind proxy';

  @override
  String get dashboard_path_prefix => 'Dashboard path prefix';

  @override
  String delegated_task(Object goal) {
    return 'Delegated task: $goal';
  }

  @override
  String get delete => 'Delete';

  @override
  String delete_2(Object name) {
    return 'Delete \"$name\"?';
  }

  @override
  String delete_from_the_remote_hermes_history_this_cannot_be_undone(
    Object title,
  ) {
    return 'Delete \"$title\" from the remote Hermes history? This cannot be undone.';
  }

  @override
  String get delete_cron_job => 'Delete Cron Job';

  @override
  String get delete_connections_that_are_not_in_the_backup =>
      'Delete connections that are not in the backup.';

  @override
  String delete_failed(Object error) {
    return 'Delete failed: $error';
  }

  @override
  String get delete_project => 'Delete project';

  @override
  String get delete_session => 'Delete session?';

  @override
  String delete_3(Object projectName) {
    return 'Delete $projectName?';
  }

  @override
  String deleted(Object name) {
    return 'Deleted \"$name\"';
  }

  @override
  String get delivery_is_uncertain_recovering_without_resending =>
      'Delivery is uncertain; recovering without resending…';

  @override
  String get desktop_gateway_url_optional => 'Desktop Gateway URL (optional)';

  @override
  String get desktop_gateway_is_not_configured_for_this_connection =>
      'Desktop Gateway is not configured for this connection.';

  @override
  String get desktop_app => 'Desktop app';

  @override
  String get developer_tool_calls => 'Developer tool calls';

  @override
  String get discord_chats => 'Discord chats';

  @override
  String get dismiss => 'Dismiss';

  @override
  String get do_not_run_this_command => 'Do not run this command.';

  @override
  String get documents_archives_audio_video_or_data =>
      'Documents, archives, audio, video, or data';

  @override
  String get download => 'Download';

  @override
  String download_failed(Object error) {
    return 'Download failed: $error';
  }

  @override
  String get durable_facts_hermes_keeps_about_you =>
      'Durable facts Hermes keeps about you';

  @override
  String get durable_work_inside_one_of_your_projects_shared_with_desktop =>
      'Durable work inside one of your projects, shared with Desktop.';

  @override
  String get edit => 'Edit';

  @override
  String get edit_connection => 'Edit Connection';

  @override
  String get edit_cron_job => 'Edit Cron Job';

  @override
  String get edit_gateway_connection => 'Edit Gateway Connection';

  @override
  String get edit_and_resend => 'Edit and resend';

  @override
  String get enable_notifications => 'Enable notifications';

  @override
  String get enable_notifications_description =>
      'Turning this off disables every notification below.';

  @override
  String get enables_file_attachments_through_the_desktop_remote_gateway =>
      'Enables file attachments through the Desktop remote gateway.';

  @override
  String get enter_a_name => 'Enter a name';

  @override
  String get enter_a_passphrase => 'Enter a passphrase.';

  @override
  String get enter_the_passphrase_for_this_backup =>
      'Enter the passphrase for this backup.';

  @override
  String get every_conversation_is_already_assigned_to_a_project =>
      'Every conversation is already assigned to a Project.';

  @override
  String get everything_not_yet_native_in_the_authenticated_web_dashboard =>
      'Everything not yet native, in the authenticated web dashboard';

  @override
  String get explain_the_attached_content_clearly =>
      'Explain the attached content clearly.';

  @override
  String explain_this_content_clearly(Object text) {
    return 'Explain this content clearly:\n\n$text';
  }

  @override
  String
  get explicit_choices_adjust_android_accessibility_text_size_system_leaves_it =>
      'Explicit choices adjust Android accessibility text size; System leaves it unchanged.';

  @override
  String get export_label => 'Export';

  @override
  String get export_share => 'Export / share';

  @override
  String get external_api_clients => 'External API clients';

  @override
  String get extra_high => 'Extra High';

  @override
  String get extract_tasks => 'Extract tasks';

  @override
  String
  get extract_the_decisions_deadlines_owners_and_actionable_action_items_from =>
      'Extract the decisions, deadlines, owners, and actionable action items from the attached content.';

  @override
  String
  extract_the_decisions_deadlines_owners_and_actionable_action_items_from_2(
    Object text,
  ) {
    return 'Extract the decisions, deadlines, owners, and actionable action items from this content:\n\n$text';
  }

  @override
  String failed_to_add_job(Object error) {
    return 'Failed to add job: $error';
  }

  @override
  String get failed_to_load_cron_jobs => 'Failed to load cron jobs';

  @override
  String get failed_to_load_memory => 'Failed to load memory';

  @override
  String get failed_to_load_messages => 'Failed to load messages';

  @override
  String get failed_to_load_settings => 'Failed to load settings';

  @override
  String get failed_to_load_skills => 'Failed to load skills';

  @override
  String failed_to_update_job(Object error) {
    return 'Failed to update job: $error';
  }

  @override
  String failed(Object error) {
    return 'Failed: $error';
  }

  @override
  String get file_attached_document_catalog_registration_is_pending =>
      'File attached; document catalog registration is pending.';

  @override
  String get file_reference_added_to_chat => 'File reference added to chat';

  @override
  String get files => 'Files';

  @override
  String get fill_from_document => 'Fill from document';

  @override
  String get folder_is_empty => 'Folder is empty';

  @override
  String get folders => 'Folders';

  @override
  String get full_text => 'Full-text';

  @override
  String get gateway_api_access => 'Gateway API access';

  @override
  String get gateway_connected_but_the_dashboard_could_not_be_reached_or =>
      'Gateway connected, but the dashboard could not be reached or authenticated. Check the dashboard details, or clear them to skip.';

  @override
  String get gateway_path_prefix => 'Gateway path prefix';

  @override
  String get go_to_end => 'Go to end';

  @override
  String get hermes_agent => 'Ares - formerly Hermes Android';

  @override
  String get hermes_agent_for_android => 'Ares - formerly Hermes Android';

  @override
  String get hermes_could_not_accept_the_answer_please_try_again =>
      'Hermes could not accept the answer. Please try again.';

  @override
  String get hermes_could_not_load_your_saved_connections =>
      'Hermes could not load your saved connections';

  @override
  String get hermes_did_not_accept_the_response_please_try_again =>
      'Hermes did not accept the response. Please try again.';

  @override
  String get hermes_is_responding => 'Hermes is responding…';

  @override
  String get hermes_is_waiting_for_input => 'Hermes is waiting for input…';

  @override
  String get hermes_keeps_android_accessibility_text_scaling_active =>
      'Ares keeps Android accessibility text scaling active.';

  @override
  String get hermes_needs_your_input => 'Hermes needs your input';

  @override
  String get hermes_profile_optional => 'Hermes profile (optional)';

  @override
  String get hermes_profile_must_be_a_plain_profile_name_such_as =>
      'Hermes profile must be a plain profile name such as \"sol\", not a path.';

  @override
  String get hermes_reasoning_details => 'Hermes reasoning details';

  @override
  String hermes_recovery_is_unavailable(Object error) {
    return 'Hermes recovery is unavailable: $error';
  }

  @override
  String get hermes_stopped_recovery_safely_no_prompt_was_resent =>
      'Hermes stopped recovery safely. No prompt was resent.';

  @override
  String get hide_passphrase => 'Hide passphrase';

  @override
  String get home_needs_your_recent_chats_to_know_what_deserves_your =>
      'Home needs your recent chats to know what deserves your attention. Check that the gateway is reachable, then try again.';

  @override
  String get host => 'Host';

  @override
  String get image_selection_was_interrupted_try_again =>
      'Image selection was interrupted. Try again.';

  @override
  String get import_label => 'Import';

  @override
  String get inbox => 'Inbox';

  @override
  String get inbox_is_clear => 'Inbox is clear';

  @override
  String get input_needed => 'Input needed';

  @override
  String get input_needed_description =>
      'Hermes asked a question or needs a password or secret.';

  @override
  String get insert_a_remote_file_reference =>
      'Insert a remote @file reference';

  @override
  String get invalid_port_number => 'Invalid port number.';

  @override
  String get job_paused => 'Job paused';

  @override
  String get job_resumed => 'Job resumed';

  @override
  String get job_triggered => 'Job triggered';

  @override
  String get label => 'Label';

  @override
  String last_activity(Object day, Object month, Object year) {
    return 'Last activity $day/$month/$year';
  }

  @override
  String last(Object lastRun) {
    return 'Last: $lastRun';
  }

  @override
  String get leave_blank_for_default_8642_443_with_https =>
      'Leave blank for default (8642; 443 with https)';

  @override
  String get leave_blank_for_default_9119 => 'Leave blank for default (9119)';

  @override
  String get light => 'Light';

  @override
  String listening(Object elapsed) {
    return 'Listening • $elapsed';
  }

  @override
  String listening_elapsed(Object elapsed) {
    return 'Listening, elapsed $elapsed';
  }

  @override
  String get load_more => 'Load more…';

  @override
  String get loading => 'Loading';

  @override
  String get location => 'Location';

  @override
  String get make_sure_the_gateway_api_server_is_running_hermes_gateway =>
      'Make sure the Gateway API Server is running\n(hermes gateway status)';

  @override
  String matches(Object assigned, Object name) {
    return 'Matches $name · $assigned';
  }

  @override
  String get memory => 'Memory';

  @override
  String get memory_about_you => 'About you';

  @override
  String get memory_agent_notes => 'Agent notes';

  @override
  String get memory_builtin_scope =>
      'Saved facts from this profile’s USER.md and MEMORY.md. External memory providers (including MemPalace) are not shown here.';

  @override
  String get memory_read_only =>
      'Read-only. Ask Hermes in chat to correct or forget a fact.';

  @override
  String get memory_unavailable =>
      'This gateway or profile cannot provide saved memory facts. Check the selected profile and update Hermes if needed.';

  @override
  String get memory_load_error =>
      'Check your dashboard connection and authentication, then try again.';

  @override
  String get memory_read_full_fact => 'Read full fact';

  @override
  String get memory_full_fact_requires_update =>
      'Full facts require a newer Hermes gateway. Update Hermes and refresh.';

  @override
  String get memory_fact_detail_error =>
      'The full fact could not be loaded. It may have changed; refresh the list and try again.';

  @override
  String get memory_entries_are_cross_session_facts_the_agent_remembers_they =>
      'Saved facts will appear here after Hermes remembers them.';

  @override
  String get merge => 'Merge';

  @override
  String get message => 'Message';

  @override
  String get message_hermes => 'Message Hermes…';

  @override
  String get message_actions => 'Message actions';

  @override
  String get message_copied => 'Message copied';

  @override
  String get migrating => 'Migrating…';

  @override
  String get migration_complete => 'Migration complete';

  @override
  String get migration_failed_local_spaces_were_kept_unchanged =>
      'Migration failed. Local Spaces were kept unchanged.';

  @override
  String get migration_incomplete => 'Migration incomplete';

  @override
  String get migration_preview => 'Migration preview';

  @override
  String get model => 'Model';

  @override
  String get model_and_thinking_for_this_chat =>
      'Model and thinking for this chat';

  @override
  String model_was_not_changed(Object error) {
    return 'Model was not changed: $error';
  }

  @override
  String get move_attachment_next => 'Move attachment next';

  @override
  String get move_attachment_previous => 'Move attachment previous';

  @override
  String get move_chat => 'Move chat';

  @override
  String get move_conversation => 'Move conversation';

  @override
  String get move_to_project => 'Move to project';

  @override
  String get move_to_space => 'Move to space';

  @override
  String get moved_to_a_project => 'Moved to a Project';

  @override
  String moved_to(Object label) {
    return 'Moved to $label';
  }

  @override
  String get name => 'Name';

  @override
  String get name_prompt_and_schedule_are_required =>
      'Name, prompt, and schedule are required';

  @override
  String get nav_activity => 'Activity';

  @override
  String get nav_projects => 'Projects';

  @override
  String get needs_a_correction_aware_filing_contract_in_the_hermes_gateway =>
      'Needs a correction-aware filing contract in the Hermes Gateway.';

  @override
  String get needs_a_reachable_hermes_dashboard_check_the_host_port_and =>
      'Needs a reachable Hermes dashboard. Check the host, port, and credentials of this connection.';

  @override
  String get needs_a_server_authoritative_assets_index_in_the_hermes_gateway =>
      'Needs a server-authoritative Assets index in the Hermes Gateway.';

  @override
  String get needs_durable_pin_ordering_batch_mutation_and_undo_contracts_in =>
      'Needs durable pin ordering, batch mutation, and undo contracts in the Hermes Gateway.';

  @override
  String get needs_you => 'Needs you';

  @override
  String get new_label => 'New';

  @override
  String get new_chat => 'New Chat';

  @override
  String get new_chat_2 => 'New chat';

  @override
  String new_chat_3(Object projectName) {
    return 'New chat · $projectName';
  }

  @override
  String get new_project => 'New project';

  @override
  String get new_space => 'New space';

  @override
  String next(Object nextRun) {
    return 'Next: $nextRun';
  }

  @override
  String get nginx_injects_auth_app_sends_clean_requests =>
      'Nginx injects auth — app sends clean requests';

  @override
  String get no_tts_voices_found_ninstall_google_text_to_speech_and =>
      'No TTS voices found.\nInstall Google Text-to-Speech and download voice data.';

  @override
  String get no_active_projects_on_this_gateway =>
      'No active Projects on this Gateway';

  @override
  String get no_activity_yet => 'No activity yet';

  @override
  String get no_chat_is_blocked_running_or_waiting_to_be_resumed =>
      'No chat is blocked, running, or waiting to be resumed. Start a new one whenever you are ready.';

  @override
  String no_chats_in_this_project_match(Object searchQuery) {
    return 'No chats in this project match “$searchQuery”.';
  }

  @override
  String get no_chats_in_this_space_yet_tap_to_start_one =>
      'No chats in this space yet. Tap + to start one.';

  @override
  String get no_chats_yet => 'No chats yet';

  @override
  String get no_connections => 'No connections';

  @override
  String get no_conversation_matches_this_view =>
      'No conversation matches this view.';

  @override
  String get no_cron_jobs => 'No cron jobs';

  @override
  String get no_folders_yet => 'No folders yet';

  @override
  String get no_local_spaces_were_found_for_this_connection_so_projects =>
      'No local spaces were found for this connection, so Projects are already the only organization in use here.';

  @override
  String get no_matches => 'No matches';

  @override
  String get no_memory_entries => 'No memory entries';

  @override
  String get no_message_content_matches => 'No message-content matches';

  @override
  String get no_new_messages => 'No new messages';

  @override
  String get no_projects_yet => 'No projects yet';

  @override
  String get no_runs_yet => 'No runs yet.';

  @override
  String no_server_project_matches_this_name(Object assigned) {
    return 'No server project matches this name · $assigned';
  }

  @override
  String get no_sessions_yet => 'No sessions yet';

  @override
  String get no_skills_found => 'No skills found';

  @override
  String get no_spaces_on_this_device => 'No spaces on this device';

  @override
  String get no_text_shared => 'No text shared';

  @override
  String get no_turn_is_blocked_in_flight_or_recently_finished_work =>
      'No turn is blocked, in flight, or recently finished. Work you start will show up here.';

  @override
  String get no_turn_needs_your_input_or_has_failed =>
      'No turn needs your input or has failed.';

  @override
  String get no_unassigned_chats => 'No unassigned chats.';

  @override
  String get nothing_changed_in_the_last_seven_days =>
      'Nothing changed in the last seven days.';

  @override
  String get nothing_has_moved_yet_this_is_only_what_a_migration =>
      'Nothing has moved yet — this is only what a migration would do.';

  @override
  String get nothing_here => 'Nothing here';

  @override
  String get nothing_is_running => 'Nothing is running';

  @override
  String get nothing_needs_you => 'Nothing needs you';

  @override
  String get nothing_to_migrate => 'Nothing to migrate';

  @override
  String get notifications => 'Notifications';

  @override
  String get windows_notifications_blocked =>
      'Notifications are unavailable. Use the installed Ares app and check Settings → System → Notifications in Windows.';

  @override
  String get windows_notification_diagnostics =>
      'What Ares submitted to Windows';

  @override
  String get chat_activity_share => 'Share chat activity';

  @override
  String get chat_activity_share_hint =>
      'Tell a compatible connected gateway when you are using this chat, so its phone notification plugin can avoid duplicate alerts. No keys or message text are sent.';

  @override
  String get completion_sound => 'Completion sound';

  @override
  String get completion_sound_system => 'System default';

  @override
  String get completion_sound_mail => 'Mail';

  @override
  String get completion_sound_reminder => 'Reminder';

  @override
  String get completion_sound_silent => 'Silent';

  @override
  String get completion_sound_scope =>
      'Plays for finished replies, the test notification and inside the app. Approvals and other alerts keep their usual sound.';

  @override
  String get completion_sound_scope_android =>
      'Plays for finished replies, the test notification and inside the app. Approvals, other alerts, background notifications from the server and Android Auto messages keep their usual sound.';

  @override
  String get notification_open_action => 'Open';

  @override
  String get app_sounds_mute => 'Mute app sounds';

  @override
  String get app_sounds_mute_hint =>
      'Stops the completion sound Ares plays while it is open. Notifications keep their own sound.';

  @override
  String get notifications_permission_denied =>
      'Notifications are blocked at the OS level. Enable them for this app in Android settings.';

  @override
  String get off_no_thinking => 'Off (no thinking)';

  @override
  String get offline_showing_the_last_known_activity =>
      'Offline — showing the last known activity.';

  @override
  String get offline_showing_the_last_known_chats =>
      'Offline — showing the last known chats';

  @override
  String get offline_showing_the_last_known_projects =>
      'Offline — showing the last known projects.';

  @override
  String get on_this_device => 'On this device';

  @override
  String get on_device => 'On-device';

  @override
  String get open_inbox => 'Open inbox';

  @override
  String open_inbox_2(Object count) {
    return 'Open inbox ($count)';
  }

  @override
  String get open_the_hermes_dashboard => 'Open the Hermes dashboard';

  @override
  String get optional_for_the_memory_cron_skills_settings_tabs_leave_blank =>
      'Optional. For the Memory/Cron/Skills/Settings tabs. Leave blank to use the default dashboard port (9119) with no login.';

  @override
  String get organization => 'Organization';

  @override
  String get other_answer => 'Other answer';

  @override
  String get overview => 'Overview';

  @override
  String get passphrase => 'Passphrase';

  @override
  String get password_optional => 'Password (optional)';

  @override
  String get phone_or_tablet => 'Phone or tablet';

  @override
  String get pin_batch_and_undo => 'Pin, batch and undo';

  @override
  String get plugin_notifications => 'Plugin notifications';

  @override
  String get plugin_notifications_description =>
      'The gateway sent a notice while the app was in the background.';

  @override
  String get port => 'Port';

  @override
  String get preparing_attachments => 'Preparing attachments…';

  @override
  String get preview_truncated => 'Preview truncated';

  @override
  String get preview_unavailable => 'Preview unavailable';

  @override
  String get profile => 'Profile';

  @override
  String get profile_default_model => 'Profile default model';

  @override
  String profile_default_set_to_chats_with_their_own_model_keep(
    Object selectedModel,
  ) {
    return 'Profile default set to $selectedModel. Chats with their own model keep that override.';
  }

  @override
  String
  get profile_this_connection_chats_as_when_the_dashboard_serves_several =>
      'Profile this connection chats as when the dashboard serves several profiles. Leave blank for an isolated per-profile dashboard.';

  @override
  String get project => 'Project';

  @override
  String get project_actions => 'Project actions';

  @override
  String get project_chat => 'Project chat';

  @override
  String get project_chats_unavailable => 'Project chats unavailable';

  @override
  String get projects => 'Projects';

  @override
  String get projects_group_related_chats_files_and_activity_and_stay_in =>
      'Projects group related chats, files, and activity, and stay in sync with Hermes on your computer.';

  @override
  String
  get projects_need_a_desktop_gateway_connection_add_the_desktop_gateway =>
      'Projects need a Desktop Gateway connection. Add the Desktop Gateway URL to this connection to organize chats across your devices.';

  @override
  String get projects_unavailable => 'Projects unavailable';

  @override
  String get projects_activity_new_navigation =>
      'Projects, Activity — new navigation';

  @override
  String get promote_to_project => 'Promote to project';

  @override
  String get prompt => 'Prompt';

  @override
  String get protect_this_backup => 'Protect this backup';

  @override
  String get provider => 'Provider';

  @override
  String get proxy_injects_auth_app_sends_clean_requests =>
      'Proxy injects auth; app sends clean requests';

  @override
  String get quick_chat => 'Quick chat';

  @override
  String get quick_chats_appear_here_after_their_retention_period =>
      'Quick chats appear here after their retention period.';

  @override
  String get read_aloud => 'Read aloud';

  @override
  String get read_aloud_is_unavailable_on_this_device =>
      'Read aloud is unavailable on this device';

  @override
  String get reading_response_aloud => 'Reading response aloud';

  @override
  String get ready_to_upload => 'Ready to upload';

  @override
  String get reasoning => 'Reasoning';

  @override
  String get recently_completed => 'Recently completed';

  @override
  String get recently_active => 'Recently active';

  @override
  String get recovering_hermes => 'Recovering Hermes…';

  @override
  String get refresh => 'Refresh';

  @override
  String get regenerate_response => 'Regenerate response';

  @override
  String get remove_attachment => 'Remove attachment';

  @override
  String get rename => 'Rename';

  @override
  String get rename_chat => 'Rename chat';

  @override
  String get rename_project => 'Rename project';

  @override
  String get rename_space => 'Rename space';

  @override
  String rename_2(Object projectName) {
    return 'Rename $projectName';
  }

  @override
  String rename_3(Object name) {
    return 'Rename $name';
  }

  @override
  String get replace => 'Replace';

  @override
  String get repositories => 'Repositories';

  @override
  String
  get research_the_attached_content_verify_the_important_claims_and_cite =>
      'Research the attached content, verify the important claims, and cite sources.';

  @override
  String research_this_content_verify_the_important_claims_and_cite_sources(
    Object text,
  ) {
    return 'Research this content, verify the important claims, and cite sources:\n\n$text';
  }

  @override
  String reset_failed_the_secure_storage_may_need_reinstall(Object retryError) {
    return 'Reset failed: $retryError. The secure storage may need reinstall.';
  }

  @override
  String get reset_saved_connections => 'Reset saved connections';

  @override
  String get responding => 'Responding…';

  @override
  String response_closed_locally_gateway_stop_failed(Object error) {
    return 'Response closed locally; gateway stop failed: $error';
  }

  @override
  String get response_closed_locally_no_active_gateway_turn_was_found =>
      'Response closed locally; no active gateway turn was found.';

  @override
  String get response_complete => 'Response complete';

  @override
  String get response_complete_description =>
      'A turn completed while the app was in the background.';

  @override
  String get response_ready => 'Response ready';

  @override
  String get response_stopped => 'Response stopped.';

  @override
  String get restore => 'Restore';

  @override
  String get restore_configuration => 'Restore configuration';

  @override
  String get restore_project => 'Restore project';

  @override
  String get retry => 'Retry';

  @override
  String retry_failed_for_the_draft_and_prompt_were_kept(Object name) {
    return 'Retry failed for $name. The draft and prompt were kept.';
  }

  @override
  String get retry_upload => 'Retry upload';

  @override
  String retrying(Object name) {
    return 'Retrying $name…';
  }

  @override
  String get review_local_spaces => 'Review local spaces';

  @override
  String get review_or_promote_quick_chats_past_their_retention_period =>
      'Review or promote quick chats past their retention period';

  @override
  String get review_the_attached_content => 'Review the attached content.';

  @override
  String get run_only_this_command => 'Run only this command.';

  @override
  String get running_now => 'Running now';

  @override
  String get save => 'Save';

  @override
  String get save_changes => 'Save Changes';

  @override
  String get save_a_permanent_rule_in_the_hermes_configuration =>
      'Save a permanent rule in the Hermes configuration.';

  @override
  String get save_the_durable_facts_from_the_attached_content_to_memory =>
      'Save the durable facts from the attached content to memory, then confirm what was retained.';

  @override
  String save_the_durable_facts_from_this_content_to_memory_then(Object text) {
    return 'Save the durable facts from this content to memory, then confirm what was retained:\n\n$text';
  }

  @override
  String get save_your_connections_and_settings_to_an_encrypted_file_then =>
      'Save your connections and settings to an encrypted file, then restore them after reinstalling or on another device.';

  @override
  String save_2(Object filename) {
    return 'Save $filename';
  }

  @override
  String get schedule => 'Schedule';

  @override
  String get scheduled_jobs_and_their_last_runs =>
      'Scheduled jobs and their last runs';

  @override
  String get scheduled_tasks => 'Scheduled tasks';

  @override
  String get script_only_no_agent => 'Script only (no agent)';

  @override
  String get scroll_horizontally => 'Scroll horizontally';

  @override
  String get search_all_chats => 'Search all chats';

  @override
  String get search_all_message_content => 'Search all message content';

  @override
  String get search_chats => 'Search chats';

  @override
  String get search_conversations => 'Search conversations';

  @override
  String get search_loaded_chats => 'Search loaded chats';

  @override
  String get search_mode => 'Search mode';

  @override
  String get select_one_option_or_enter_another_answer =>
      'Select one option, or enter another answer.';

  @override
  String get select_one_or_more_options_then_continue =>
      'Select one or more options, then continue.';

  @override
  String get select_text => 'Select text';

  @override
  String get send => 'Send';

  @override
  String send_failed(Object error) {
    return 'Send failed: $error';
  }

  @override
  String send_failed_api_only_permission_denied(Object error) {
    return 'Send failed: $error. The server refused this write for the API key principal. If this chat is owned by the Dashboard, adding the Dashboard username and password for this connection may let it send; the server may also be refusing deliberately.';
  }

  @override
  String get send_message => 'Send message';

  @override
  String get send_test_notification => 'Send test notification';

  @override
  String get session_sources => 'Session Sources';

  @override
  String get session_deleted_from_remote_hermes =>
      'Session deleted from remote Hermes.';

  @override
  String session_search_failed(Object error) {
    return 'Session search failed: $error';
  }

  @override
  String get set_profile_default => 'Set profile default';

  @override
  String get settings => 'Settings';

  @override
  String get share_to_hermes => 'Share to Hermes';

  @override
  String get show_passphrase => 'Show passphrase';

  @override
  String get show_tool_calls_thinking_and_message_metadata =>
      'Show tools, reasoning, tasks and message details in collapsed sections. Off shows only the conversation.';

  @override
  String get signal_messages => 'Signal messages';

  @override
  String get skills => 'Skills';

  @override
  String skills_2(Object count) {
    return 'Skills ($count)';
  }

  @override
  String get skills_and_tools => 'Skills and tools';

  @override
  String get skip => 'Skip';

  @override
  String get slack_chats => 'Slack chats';

  @override
  String source(Object source) {
    return 'Source: $source';
  }

  @override
  String get space_actions => 'Space actions';

  @override
  String get spaces => 'Spaces';

  @override
  String get speak_to_hermes => 'Speak to Hermes';

  @override
  String get speech_recognition_is_unavailable =>
      'Speech recognition is unavailable';

  @override
  String get spoken_replies => 'Spoken replies';

  @override
  String get spoken_replies_off => 'Spoken replies off';

  @override
  String get spoken_replies_on => 'Spoken replies on';

  @override
  String get stalled_no_update_from_hermes => 'Stalled — no update from Hermes';

  @override
  String get start_something_new => 'Start something new';

  @override
  String get start_voice_input => 'Start voice input';

  @override
  String get starting_hermes => 'Starting Hermes…';

  @override
  String get media_card_download => 'Download file';

  @override
  String get media_card_tap_to_download => 'Tap to download';

  @override
  String get still_loading_your_projects => 'Still loading your projects.';

  @override
  String get stop => 'Stop';

  @override
  String get stop_response => 'Stop response';

  @override
  String get stop_voice_input => 'Stop voice input';

  @override
  String get submitted_waiting_for_hermes => 'Submitted, waiting for Hermes';

  @override
  String get suggest_projects_and_learn_from_your_corrections =>
      'Suggest Projects and learn from your corrections';

  @override
  String get summarize_the_attached_content =>
      'Summarize the attached content.';

  @override
  String summarize_this_content(Object text) {
    return 'Summarize this content:\n\n$text';
  }

  @override
  String get switch_profile => 'Switch profile';

  @override
  String get system => 'System';

  @override
  String get take_photo => 'Take photo';

  @override
  String get tap_to_add_a_remote_hermes_gateway_api_server_port =>
      'Tap + to add a remote Hermes Gateway\n(API Server, port 8642)';

  @override
  String get tap_the_button_to_start_a_new_chat =>
      'Tap the + button to start a new chat';

  @override
  String get telegram_messages => 'Telegram messages';

  @override
  String get terminal_sessions => 'Terminal sessions';

  @override
  String get test_notification_body =>
      'If you can see this, native notifications are working.';

  @override
  String get test_notification_sent => 'Test notification sent.';

  @override
  String get test_notification_title => 'Hermes notification test';

  @override
  String get test_notification_unsupported =>
      'Could not send the notification — check that the OS allows notifications.';

  @override
  String get text_size => 'Text size';

  @override
  String get text_size_preview => 'Text size preview';

  @override
  String text_size_2(Object label) {
    return 'Text size: $label';
  }

  @override
  String get the_api_key_could_not_be_stored_securely =>
      'The API key could not be stored securely.';

  @override
  String get the_project_will_move_to_archived_its_chats_and_files =>
      'The Project will move to Archived. Its chats and files stay intact, and you can restore it at any time.';

  @override
  String get the_project_will_move_to_archived_its_chats_and_files_2 =>
      'The Project will move to Archived. Its chats and files stay intact, and you can restore it later.';

  @override
  String get the_active_profile_did_not_return_any_selectable_models =>
      'The active profile did not return any selectable models.';

  @override
  String get the_backup_could_not_be_exported =>
      'The backup could not be exported.';

  @override
  String get the_backup_could_not_be_restored =>
      'The backup could not be restored.';

  @override
  String get the_connection_could_not_be_deleted_safely =>
      'The connection could not be deleted safely.';

  @override
  String get the_connection_could_not_be_stored_securely =>
      'The connection could not be stored securely.';

  @override
  String get the_dashboard_credentials_could_not_be_stored_securely =>
      'The dashboard credentials could not be stored securely.';

  @override
  String get the_detached_reply_failed => 'The detached reply failed.';

  @override
  String the_detached_reply_failed_2(Object error) {
    return 'The detached reply failed: $error';
  }

  @override
  String get the_file_contains_your_api_keys_and_dashboard_password_so =>
      'The file contains your API keys and dashboard password, so it is encrypted. Without this passphrase the backup cannot be restored.';

  @override
  String get the_last_turn_failed => 'The last turn failed';

  @override
  String the_local_connection_store_looks_damaged_you_can_reset_the(
    Object errorType,
  ) {
    return 'The local connection store looks damaged ($errorType). You can reset the saved connections and start fresh. Chats on your gateway are not affected.';
  }

  @override
  String get the_model_only_rewrites_your_question_into_a_short_full =>
      'The model only rewrites your question into a short full-text query. Hermes uses the provider credentials already configured on the host.';

  @override
  String get the_server_has_not_reported_folders_for_this_project_yet =>
      'The server has not reported folders for this project yet. Global Files stays available from More.';

  @override
  String get the_turn_failed => 'The turn failed';

  @override
  String get the_two_passphrases_do_not_match =>
      'The two passphrases do not match.';

  @override
  String get the_value_is_sent_directly_to_the_active_hermes_gateway =>
      'The value is sent directly to the active Hermes gateway and is not saved by this Android app.';

  @override
  String get there_are_no_visible_files_in_this_server_folder =>
      'There are no visible files in this server folder.';

  @override
  String get thinking_effort => 'Thinking effort';

  @override
  String get this_hermes_gateway_does_not_support_opening_a_project_yet =>
      'This Hermes gateway does not support opening a project yet. Update Hermes on the server to browse a project from your phone.';

  @override
  String get this_hermes_gateway_is_older_than_server_side_projects_so =>
      'This Hermes gateway is older than server-side projects, so chats stay grouped on this device only. Update Hermes to share the same projects across your devices.';

  @override
  String get this_project_has_no_folder_to_open_the_chat_in =>
      'This Project needs a folder before you can start a chat in it. Add a folder and try again.';

  @override
  String get this_chat_has_no_messages_available_in_the_desktop_session =>
      'This chat has no messages available in the Desktop session yet.';

  @override
  String get this_creates_a_permanent_rule_in_hermes_review_the_full =>
      'This creates a permanent rule in Hermes. Review the full command before confirming.';

  @override
  String get this_gateway_does_not_host_projects_yet_update_the_gateway =>
      'This gateway does not host projects yet. Update the gateway to organize chats across your devices.';

  @override
  String get this_permanently_deletes_the_project_chats_will_not_be_deleted =>
      'This permanently deletes the Project. Chats will not be deleted; they’ll return to Unassigned.';

  @override
  String get this_server_doesn_t_offer_background_recovery_chats_run_live =>
      'This server doesn\'t offer background recovery — chats run live';

  @override
  String get this_week => 'This week';

  @override
  String get titles_previews_and_models => 'Titles, previews, and models';

  @override
  String get tool_activity => 'Tool activity';

  @override
  String get trigger_now => 'Trigger now';

  @override
  String get received_outcome_unknown => 'Turn ended — outcome unconfirmed';

  @override
  String get turn_completed => 'Turn completed';

  @override
  String get turn_failed => 'Turn failed';

  @override
  String get turn_failed_description =>
      'A background turn ended with an error.';

  @override
  String get turn_recovery_failed => 'Turn recovery failed';

  @override
  String get unable_to_prepare_this_file_try_another_one =>
      'Unable to prepare this file. Try another one.';

  @override
  String get unable_to_prepare_this_image_try_another_one =>
      'Unable to prepare this image. Try another one.';

  @override
  String unable_to_prepare(Object name) {
    return 'Unable to prepare $name.';
  }

  @override
  String get unable_to_read_the_selected_image_the_selection_was_kept =>
      'Unable to read the selected image. The selection was kept.';

  @override
  String get unassigned => 'Unassigned';

  @override
  String get unassigned_chats => 'Unassigned chats';

  @override
  String get untitled_chat => 'Untitled chat';

  @override
  String get untitled_session => 'Untitled session';

  @override
  String get update_api_key => 'Update API Key';

  @override
  String get upload_failed => 'Upload failed';

  @override
  String get upload_failed_tap_retry => 'Upload failed • tap retry';

  @override
  String uploading(Object index, Object name, Object total) {
    return 'Uploading $index/$total: $name';
  }

  @override
  String get use_as_is => 'Use as is';

  @override
  String get use_at_least_8_characters => 'Use at least 8 characters.';

  @override
  String get use_for_cron_jobs_backed_by_scripts =>
      'Use for cron jobs backed by scripts.';

  @override
  String get use_on_device => 'Use on-device';

  @override
  String get use_the_attached_content_to_identify_and_fill_the_relevant =>
      'Use the attached content to identify and fill the relevant document or form fields. Ask before submitting anything.';

  @override
  String use_this_content_to_identify_and_fill_the_relevant_document(
    Object text,
  ) {
    return 'Use this content to identify and fill the relevant document or form fields. Ask before submitting anything:\n\n$text';
  }

  @override
  String get used_for_hosted_path_prefixes_and_for_the_settings_memory =>
      'Used for hosted path prefixes and for the Settings, Memory, Skills and Cron tabs. Leave username/password blank for an open dashboard, or enable proxied mode when your reverse proxy injects dashboard auth.';

  @override
  String get username_optional => 'Username (optional)';

  @override
  String using(Object displayName) {
    return 'Using $displayName…';
  }

  @override
  String get verbose_mode => 'Verbose Mode';

  @override
  String get message_metadata => 'Message details';

  @override
  String get voice => 'Voice';

  @override
  String voice_setup_failed(Object error) {
    return 'Voice setup failed: $error';
  }

  @override
  String get waiting_for_your_input => 'Waiting for your input';

  @override
  String get what_hermes_knows_how_to_do => 'What Hermes knows how to do';

  @override
  String get what_should_the_agent_do => 'What should the agent do?';

  @override
  String get whatsapp_messages => 'WhatsApp messages';

  @override
  String get which_project => 'Which project?';

  @override
  String get workspace => 'Workspace';

  @override
  String get wrap_lines => 'Wrap lines';

  @override
  String you_can_attach_up_to_items(Object maxRemoteAttachmentDrafts) {
    return 'You can attach up to $maxRemoteAttachmentDrafts items.';
  }

  @override
  String get your_answer => 'Your answer';

  @override
  String get e_g_dashboard => 'e.g. /dashboard';

  @override
  String get e_g_dashboard_proxy_path_before_api =>
      'e.g. /dashboard (proxy path before /api/)';

  @override
  String get e_g_profile_peter => 'e.g. /profile/peter';

  @override
  String get e_g_sol => 'e.g. sol';

  @override
  String get e_g_0_9_or_every_2h => 'e.g., 0 9 * * * or every 2h';

  @override
  String get e_g_daily_backup => 'e.g., Daily backup';

  @override
  String downloaded(Object filename) {
    return '$filename downloaded';
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
      '192.168.1.50, 100.x.y.z, or hermes-machine.tailnet.ts.net';

  @override
  String get example_profile_prefix_hint_full =>
      'e.g. /profile/peter (proxy path before /api/ and /v1/)';

  @override
  String and_more(Object count) {
    return 'and $count more';
  }

  @override
  String chats_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chats',
      one: '$count chat',
    );
    return '$_temp0';
  }

  @override
  String on_this_device_only(Object chats) {
    return '$chats · on this device only';
  }

  @override
  String spaces_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count spaces',
      one: '$count space',
    );
    return '$_temp0';
  }

  @override
  String get no_new_projects_needed => 'no new projects needed';

  @override
  String projects_to_create(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count projects to create',
      one: '$count project to create',
    );
    return '$_temp0';
  }

  @override
  String chats_migrated_projects_created(
    Object createdProjects,
    Object linkedSessions,
  ) {
    return '$linkedSessions chats migrated · $createdProjects projects created';
  }

  @override
  String chats_stayed_in_local_spaces(Object unlinkedSessions) {
    return '$unlinkedSessions chats stayed in local Spaces and can be retried safely.';
  }

  @override
  String model_recommended(Object provider) {
    return '$provider • Recommended: small and inexpensive';
  }

  @override
  String session_meta(Object count, Object model, Object time) {
    return '$count msgs • $model • $time';
  }

  @override
  String model_scope_label(Object model, Object scope) {
    return '$model • $scope';
  }

  @override
  String get this_chat => 'this chat';

  @override
  String get profile_default => 'profile default';

  @override
  String minutes_ago(Object count) {
    return '${count}m ago';
  }

  @override
  String hours_ago(Object count) {
    return '${count}h ago';
  }

  @override
  String days_ago(Object count) {
    return '${count}d ago';
  }

  @override
  String get now_label => 'now';

  @override
  String get latest_label => 'Latest';

  @override
  String new_count_indicator(Object count) {
    return '$count new';
  }

  @override
  String new_messages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count new messages',
      one: '$count new message',
    );
    return '$_temp0';
  }

  @override
  String activity_failed_summary(Object failures, Object total) {
    return '$failures failed • $total total';
  }

  @override
  String activity_completed_summary(Object count) {
    return '$count completed';
  }

  @override
  String tool_start_observed(Object time) {
    return 'Start observed $time (local)';
  }

  @override
  String tool_last_observed(Object time) {
    return 'Last observed $time (local)';
  }

  @override
  String tool_result_recorded(Object time) {
    return 'Result recorded $time (local)';
  }

  @override
  String get tool_time_unavailable => 'Time unavailable';

  @override
  String get hermes_is_using_a_tool => 'Hermes is using a tool';

  @override
  String hermes_is_using_tools(Object count) {
    return 'Hermes is using $count tools';
  }

  @override
  String delegated_tasks_completed(Object count) {
    return '$count delegated task(s) completed';
  }

  @override
  String delegated_tasks_active(Object count) {
    return '$count delegated task(s) active';
  }

  @override
  String branch_main(Object label) {
    return '$label · main';
  }

  @override
  String get you_heading => '## You';

  @override
  String get hermes_heading => '## Hermes';

  @override
  String get action_label => 'Action';

  @override
  String get destination_label => 'Destination';

  @override
  String get markdown_source => 'Source';

  @override
  String get preview_label => 'Preview';

  @override
  String get share_action_summarize => 'Summarize';

  @override
  String get share_action_explain => 'Explain';

  @override
  String get share_action_research => 'Research';

  @override
  String get share_action_remember => 'Remember';

  @override
  String get text_size_small => 'Small';

  @override
  String get text_size_default => 'Default';

  @override
  String get text_size_large => 'Large';

  @override
  String get text_size_extra_large => 'Extra large';

  @override
  String get text_size_use_system_description =>
      'Use Android accessibility text size exactly.';

  @override
  String text_size_percent_description(Object percent) {
    return '$percent% of the Android text size.';
  }

  @override
  String text_size_label_description(Object description, Object label) {
    return '$label — $description';
  }

  @override
  String files_skipped(Object count) {
    return '$count file(s) skipped: limit, size, unreadable, or sensitive filename.';
  }

  @override
  String model_scope_applied(Object effort, Object model) {
    return '$model • $effort now apply only to this chat.';
  }

  @override
  String get reasoning_minimal => 'Minimal';

  @override
  String get reasoning_low => 'Low';

  @override
  String get reasoning_medium => 'Medium';

  @override
  String get reasoning_high => 'High';

  @override
  String get reasoning_max => 'Max';

  @override
  String get reasoning_ultra => 'Ultra';

  @override
  String get status_running => 'Running';

  @override
  String get status_failed => 'Failed';

  @override
  String get status_done => 'Done';

  @override
  String get status_idle => 'Idle';

  @override
  String get upload_status_uploading => 'Uploading';

  @override
  String get upload_status_uploaded => 'Uploaded';

  @override
  String attachment_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count attachments',
      one: '$count attachment',
    );
    return '$_temp0';
  }

  @override
  String get action_create => 'create';

  @override
  String get action_rename => 'rename';

  @override
  String get action_archive => 'archive';

  @override
  String get action_restore => 'restore';

  @override
  String get action_delete => 'delete';

  @override
  String get migrate => 'Migrate';

  @override
  String assigned_chats(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count assigned chats',
      one: '$count assigned chat',
    );
    return '$_temp0';
  }

  @override
  String get date_today => 'Today';

  @override
  String get date_yesterday => 'Yesterday';

  @override
  String get date_earlier => 'Earlier';

  @override
  String get nav_home => 'Home';

  @override
  String get nav_more => 'More';

  @override
  String get status_completed => 'Completed';

  @override
  String get filter_all => 'All';

  @override
  String get filter_recent => 'Recent';

  @override
  String connection_address_key(Object address, Object status) {
    return '$address  •  Key: $status';
  }

  @override
  String model_via_provider(Object model, Object provider) {
    return '$model  \nvia `$provider`';
  }

  @override
  String get deny => 'Deny';

  @override
  String get connect => 'Connect';

  @override
  String get appearance => 'Appearance';

  @override
  String get connection_section => 'Connection';

  @override
  String get about => 'About';

  @override
  String version_label(Object version) {
    return 'Version $version';
  }

  @override
  String get matched => 'Matched';

  @override
  String get search => 'Search';

  @override
  String get on => 'On';

  @override
  String get off => 'Off';

  @override
  String get reasoning_off => 'Off';

  @override
  String get hermes_response_ready => 'Hermes response ready';

  @override
  String get admin_password_needed => 'Administrator password needed';

  @override
  String get hermes_needs_a_sudo_password_for_the_pending_terminal_command =>
      'Hermes needs a sudo password for the pending terminal command.';

  @override
  String get sudo_password => 'Sudo password';

  @override
  String get secret_needed => 'Secret needed';

  @override
  String get hermes_needs_a_secret_for_the_pending_skill =>
      'Hermes needs a secret for the pending skill.';

  @override
  String get secret_value => 'Secret value';

  @override
  String get attached_file => 'Attached file';

  @override
  String get pin_chat => 'Pin chat';

  @override
  String get unpin_chat => 'Unpin chat';

  @override
  String get pinned_chats => 'Pinned';

  @override
  String could_not_update_chat_pin(Object error) {
    return 'Could not update chat pin: $error';
  }

  @override
  String get could_not_save_chat_spaces =>
      'Could not save chat spaces on this device';

  @override
  String get chat_density => 'Chat density';

  @override
  String chat_density_2(Object label) {
    return 'Chat density: $label';
  }

  @override
  String get chat_density_comfortable => 'Comfortable';

  @override
  String get chat_density_compact => 'Compact';

  @override
  String get chat_density_comfortable_description =>
      'Roomier bubbles with a sender label above each message.';

  @override
  String get chat_density_compact_description =>
      'Tighter, unlabelled bubbles so more messages fit on screen.';

  @override
  String chat_density_label_description(Object description, Object label) {
    return '$label — $description';
  }

  @override
  String
  get compact_removes_the_you_and_hermes_labels_and_trims_bubble_padding_spacing_and_side_margins =>
      'Compact removes the You and Hermes labels and trims bubble padding, spacing, and side margins.';

  @override
  String get client_certificate_mtls => 'Client certificate (mTLS)';

  @override
  String get client_certificate_mtls_description =>
      'Present a certificate when an HTTPS proxy requires mutual TLS.';

  @override
  String get client_certificate_https_only =>
      'Client certificates are only used for HTTPS connections.';

  @override
  String get choose_certificate => 'Choose certificate';

  @override
  String get certificate_password => 'Certificate password';

  @override
  String get this_certificate_is_password_protected =>
      'This certificate is password-protected. It opens as you type.';

  @override
  String get enter_the_certificate_password_to_finish_loading_it =>
      'Enter the certificate password to finish loading the certificate you chose.';

  @override
  String get client_certificate_required =>
      'Load a client certificate or turn off the client certificate option.';

  @override
  String client_certificate_loaded(String label) {
    return 'Loaded: $label';
  }

  @override
  String get remove_certificate => 'Remove certificate';

  @override
  String get certificate_import_failed =>
      'That certificate could not be loaded.';

  @override
  String get background_work => 'Background work';

  @override
  String get keep_chats_active_in_background =>
      'Keep chats active in the background';

  @override
  String get background_work_description =>
      'Keep user-started chats connected while this app is in the background. Idle connections may disconnect. Uses more battery and network data. Turning this off does not stop work on the server.';

  @override
  String get background_work_limits =>
      'Android may still suspend connections during Doze or end the app process. Notifications after process death require the separate push setup. Force stop is not supported.';

  @override
  String get background_work_disclosure =>
      'A required service notification stays visible while background protection is active, even when optional chat notifications are off.';

  @override
  String get battery_optimisation_settings => 'Battery optimisation settings';

  @override
  String get battery_optimisation_description =>
      'Open Android settings to review battery restrictions. No exemption is requested automatically, and changing settings does not guarantee delivery.';

  @override
  String get battery_settings_unavailable =>
      'Battery settings could not be opened on this device.';

  @override
  String get background_work_save_failed =>
      'Could not save the background work setting.';

  @override
  String get ongoing_chat_channel_name => 'Active chats';

  @override
  String get ongoing_chat_channel_description =>
      'Quiet status updates for unresolved user-started chats';

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
  String get activity_status_unconfirmed => 'Status unconfirmed';

  @override
  String get activity_recently_updated => 'Recently updated';

  @override
  String get activity_reconnecting => 'Reconnecting — checking the turn status';

  @override
  String get activity_outcome_unknown =>
      'The turn’s outcome could not be confirmed. Open the chat to check.';

  @override
  String get activity_chat_updated_detail =>
      'Chat activity recorded by the gateway; live turn status is unavailable.';

  @override
  String get activity_updated => 'Updated';

  @override
  String get activity_empty_title => 'No recent activity';

  @override
  String get activity_empty_detail =>
      'Turns started in this app and gateway chats updated in the last 7 days appear here.';

  @override
  String get activity_read_error =>
      'Activity could not read its turn records or gateway chats. Check the connection and try again.';

  @override
  String get activity_chat_unavailable =>
      'This chat is no longer available, or the gateway could not be reached.';

  @override
  String get activity_partial_title => 'Activity partially loaded';

  @override
  String get activity_partial_detail =>
      'Showing a limited window of gateway activity. More chats may exist; pull to refresh.';

  @override
  String get provider_usage => 'Recorded usage';

  @override
  String get provider_usage_notice =>
      'Hermes usage for the last 30 days, not account credits or model pricing. Configure provider credentials on the Hermes server; this app does not store provider API keys.';

  @override
  String get provider_usage_failed => 'Could not load recorded usage.';

  @override
  String get provider_usage_empty => 'No recorded usage for this provider.';

  @override
  String provider_usage_counts(String sessions, String input, String output) {
    return '$sessions sessions · Input: $input · Output: $output';
  }

  @override
  String provider_usage_costs(String estimated, String actual) {
    return 'Estimated: $estimated · Reported: $actual';
  }

  @override
  String get provider_quota_codex => 'OpenAI Codex subscription';

  @override
  String get provider_quota_claude => 'Claude subscription';

  @override
  String get provider_quota_openai_api => 'OpenAI API recorded usage';

  @override
  String get provider_quota_notice =>
      'Provider-reported subscription windows, separate from Hermes recorded usage and API billing. Accounts are shown separately; model limits do not mean the whole account is exhausted.';

  @override
  String get provider_quota_windows_notice =>
      'Codex and Claude subscriptions use five-hour session and weekly limits. Only provider-reported windows are shown; missing limits and reset times remain unavailable. Weekly limits may apply to the account or specific models.';

  @override
  String get provider_quota_five_hour_session => '5-hour session';

  @override
  String get provider_quota_unavailable =>
      'Subscription allowance unavailable.';

  @override
  String get provider_quota_failed =>
      'Could not refresh subscription allowance. Any retained values are from the previous read.';

  @override
  String get provider_quota_account => 'Account';

  @override
  String get provider_quota_unknown => 'unknown';

  @override
  String provider_quota_state(String state) {
    return 'Account state: $state';
  }

  @override
  String provider_quota_scope(String scope) {
    return 'Scope: $scope';
  }

  @override
  String provider_quota_percent(String used, String remaining) {
    return '$used% used · $remaining% remaining';
  }

  @override
  String provider_quota_reset(String reset) {
    return 'Resets: $reset';
  }

  @override
  String get provider_quota_reset_unknown => 'Reset time unavailable.';

  @override
  String get auxiliary_models => 'Auxiliary models';

  @override
  String get auxiliary_notice =>
      'Choose models for individual tasks. Custom endpoints must be managed on the server. Auto follows the task’s inheritance rules.';

  @override
  String get auxiliary_inherit => 'Auto (inherit)';

  @override
  String get auxiliary_unavailable => 'Auxiliary settings are unavailable.';

  @override
  String get provider_oauth_title => 'Provider sign-in';

  @override
  String get provider_oauth_more_subtitle =>
      'Manage provider login on your Hermes host';

  @override
  String get provider_oauth_settings_subtitle =>
      'Sign in on your Hermes host; provider tokens stay off this device';

  @override
  String get provider_oauth_intro =>
      'Sign in with your provider in an external browser. Tokens are stored only on your Hermes host, not this device. Signing in does not select a chat model in this app.';

  @override
  String get provider_oauth_defaults_notice =>
      'Some host flows, including Nous free-tier account replacement, may update host defaults. Review your host settings after signing in.';

  @override
  String get provider_oauth_transport_init_failed =>
      'The selected secure dashboard transport could not be initialized. Check its TLS identity and connection settings.';

  @override
  String get provider_oauth_https_required =>
      'Provider sign-in requires an HTTPS Hermes dashboard connection.';

  @override
  String get provider_oauth_auth_required =>
      'Configure dashboard password authentication or a trusted proxy before signing in.';

  @override
  String get provider_oauth_catalog_failed =>
      'Provider sign-in is unavailable on this host. Check dashboard authentication and update the host if it does not support provider OAuth.';

  @override
  String get provider_oauth_expired => 'Sign-in expired. Start again.';

  @override
  String get provider_oauth_start_failed =>
      'Could not start secure provider sign-in. Please try again.';

  @override
  String get provider_oauth_denied => 'Sign-in was denied. Start again.';

  @override
  String get provider_oauth_cancelled => 'Sign-in cancelled.';

  @override
  String get provider_oauth_host_failed =>
      'The host could not complete sign-in. Start again.';

  @override
  String get provider_oauth_poll_failed =>
      'Could not check sign-in status. Start again.';

  @override
  String provider_oauth_cancellation_unconfirmed(String message) {
    return '$message Cancellation could not be confirmed; the host session may continue until it expires.';
  }

  @override
  String get provider_oauth_browser_failed =>
      'Could not open the external browser. Try again or cancel sign-in.';

  @override
  String get provider_oauth_retry => 'Retry';

  @override
  String provider_oauth_complete(String provider) {
    return 'Complete sign-in for $provider';
  }

  @override
  String get provider_oauth_code_instruction =>
      'Enter this temporary code on the provider page:';

  @override
  String get provider_oauth_waiting =>
      'Waiting for approval. This session expires automatically.';

  @override
  String get provider_oauth_open_browser => 'Open provider in browser';

  @override
  String get provider_oauth_cancel => 'Cancel sign-in';

  @override
  String get provider_oauth_signed_out => 'Not signed in on host';

  @override
  String get provider_oauth_sign_in_again => 'Sign in again';

  @override
  String get provider_oauth_sign_in => 'Sign in';

  @override
  String get provider_oauth_cli_required =>
      'Sign in using the provider CLI on your Hermes host. This host does not offer an in-app login for this provider.';

  @override
  String get provider_oauth_checking_account =>
      'Approval received. Checking host account…';

  @override
  String get provider_oauth_verification_unavailable =>
      'Approval received; account verification unavailable. Open Usage to refresh account usage.';

  @override
  String provider_oauth_verified_account(String email) {
    return 'Signed in on the Hermes host as $email. Open Usage to refresh account usage.';
  }

  @override
  String get provider_oauth_credentials_unverified =>
      'Host reports credentials available; account identity unverified.';

  @override
  String get provider_oauth_account_status_unknown =>
      'Host account status unavailable.';

  @override
  String get app_language => 'App language';

  @override
  String get app_language_system => 'Same as phone';

  @override
  String get auto_archives_after_72_hours => 'Auto-archives after 72 hours';

  @override
  String get automation => 'Automation';

  @override
  String get voice_recording_start => 'Record voice message';

  @override
  String get voice_recording_pause => 'Pause recording';

  @override
  String get voice_recording_preview => 'Play recording';

  @override
  String get voice_recording_resume => 'Continue recording';

  @override
  String get voice_recording_send => 'Send voice message';

  @override
  String get voice_recording_discard => 'Discard recording';

  @override
  String get voice_recording_processing => 'Preparing voice message…';

  @override
  String voice_recording_elapsed(String time) {
    return 'Recording $time';
  }

  @override
  String voice_recording_draft(String time) {
    return 'Voice message $time';
  }

  @override
  String get voice_recording_permission =>
      'Allow microphone access to record a voice message.';

  @override
  String get voice_recording_limit =>
      'This recording has reached the ten-minute limit.';

  @override
  String get voice_recording_empty => 'No audio was recorded. Try again.';

  @override
  String get voice_recording_failed =>
      'Could not process the recording. Any saved fragments have been kept.';

  @override
  String get voice_recording_unconfirmed =>
      'Delivery was not confirmed. Your recording is saved. Check the chat before trying again.';

  @override
  String get voice_recording_submit_failed =>
      'Could not send the voice message. Your recording is saved. Check the connection, Dashboard access and server transcription settings.';

  @override
  String get voice_recording_pause_playback => 'Pause playback';

  @override
  String get projects_root_title => 'Projects folder on the server';

  @override
  String get projects_root_more_subtitle =>
      'Where new server-side Project folders are created';

  @override
  String get projects_root_description =>
      'Projects you create on this phone get their folder here. Point it at the folder Hermes itself uses so the phone and the server share the same Projects.';

  @override
  String get projects_root_label => 'Projects root path';

  @override
  String projects_root_default_hint(String path) {
    return 'Server default: $path';
  }

  @override
  String get projects_root_locked_title => 'Set by the server';

  @override
  String get projects_root_locked_explanation =>
      'This server restricts file access to a single root, so the Projects folder cannot be changed from the app.';

  @override
  String get projects_root_saved => 'Projects folder saved.';

  @override
  String get projects_root_reset => 'Use the server default';

  @override
  String get projects_root_invalid_empty => 'Enter a folder path.';

  @override
  String get projects_root_invalid_absolute =>
      'Enter an absolute path that starts with a slash.';

  @override
  String get projects_root_invalid_segments =>
      'Remove dot segments and control characters from the path.';

  @override
  String get projects_root_unsupported =>
      'Not supported on this connection. A Desktop Gateway connection with Dashboard access is needed to read or change the server\'s Projects folder.';

  @override
  String get projects_root_unavailable =>
      'Could not read the server\'s Projects folder. Check the Dashboard connection, then retry.';

  @override
  String get adopt_folder_action => 'Add an existing folder';

  @override
  String adopt_folder_description(String root) {
    return 'Folders under $root that are not registered as a Project yet.';
  }

  @override
  String adopt_folder_registered(String name) {
    return 'Already a Project: $name';
  }

  @override
  String get adopt_folder_none =>
      'Every folder under this path is already a Project.';

  @override
  String get adopt_folder_unsupported =>
      'This connection cannot list server folders. Enter the absolute path of an existing folder instead.';

  @override
  String adopt_folder_failed(String error) {
    return 'Could not list server folders: $error';
  }

  @override
  String get adopt_folder_manual_label => 'Existing folder path';

  @override
  String get adopt_folder_name_label => 'Project name';

  @override
  String get adopt_folder_add => 'Add as Project';

  @override
  String adopt_folder_added(String name, String path) {
    return '$name now uses $path';
  }

  @override
  String adopt_folder_error(String error) {
    return 'Could not add the folder: $error';
  }

  @override
  String adopt_folder_folderless(String name) {
    return '$name was created, but the folder was not attached. Attach it from Hermes on the server.';
  }

  @override
  String get slash_commands => 'Slash commands';

  @override
  String get slash_commands_loading => 'Loading commands…';

  @override
  String get slash_commands_empty => 'No matching commands';

  @override
  String slash_command_info_alias(String alias, String command) {
    return '$alias is an alias of $command';
  }

  @override
  String get slash_command_info_no_description => 'No description available.';

  @override
  String get slash_command_info_arguments_options =>
      'Takes one option from a fixed list.';

  @override
  String get slash_command_info_arguments_text =>
      'Takes text after the command.';

  @override
  String get slash_command_info_arguments_mixed =>
      'Takes an option or text after the command.';

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
      'This command is not available on this server.';

  @override
  String get slash_sessions_inline =>
      'Open the session list to choose a chat. Your draft was kept.';

  @override
  String get composer_snippets => 'Prompt snippets';

  @override
  String get composer_snippets_description =>
      'Pick a starter prompt to drop into the composer.';

  @override
  String get composer_snippet_review => 'Code review';

  @override
  String get composer_snippet_review_body =>
      'Audit the current change for regressions, dropped edge cases and missing tests.';

  @override
  String get composer_snippet_review_text =>
      'Please review this for bugs, regressions and missing tests.';

  @override
  String get composer_snippet_plan => 'Implementation plan';

  @override
  String get composer_snippet_plan_body =>
      'Outline an approach before touching code so the diff stays focused.';

  @override
  String get composer_snippet_plan_text =>
      'Please make a concise implementation plan before changing code.';

  @override
  String get composer_snippet_explain => 'Explain this';

  @override
  String get composer_snippet_explain_body =>
      'Walk through how the selected code works and point to the key files.';

  @override
  String get composer_snippet_explain_text =>
      'Please explain how this works and point me to the key files.';

  @override
  String get composer_status => 'Status';

  @override
  String get composer_status_context => 'Context';

  @override
  String get composer_status_cache => 'Cache hit';

  @override
  String get composer_status_throughput => 'Output tokens/sec';

  @override
  String get composer_status_running => 'Running';

  @override
  String get composer_status_session => 'Session';

  @override
  String get composer_status_not_reported => 'Not reported';

  @override
  String get composer_status_empty => 'No context breakdown was reported.';

  @override
  String get composer_status_loading => 'Loading context breakdown';

  @override
  String get composer_status_reset => 'Reset status bar';

  @override
  String get composer_resume_title => 'Resume a chat';

  @override
  String get composer_resume_search => 'Search titles and ids';

  @override
  String get composer_resume_empty => 'No chats match.';

  @override
  String get composer_resume_unavailable =>
      'This pane has no chat list to search.';

  @override
  String get composer_failure_retry => 'Retry';

  @override
  String composer_failure_retry_at(String time) {
    return 'Retry at $time';
  }

  @override
  String get composer_failure_compress => 'Compress';

  @override
  String get composer_failure_switch_model => 'Switch model';

  @override
  String composer_failure_switch_to(String model) {
    return 'Switch to $model';
  }

  @override
  String get composer_failure_new_chat => 'New chat';

  @override
  String get composer_failure_edit => 'Edit message';

  @override
  String get composer_failure_details => 'Details';

  @override
  String get composer_failure_hide_details => 'Hide details';

  @override
  String get composer_failure_copy => 'Copy diagnostics';

  @override
  String get composer_failure_account =>
      'The other fix is on the gateway account. This chat cannot do it.';

  @override
  String get composer_failure_account_only =>
      'This has to be fixed on the gateway account. This chat cannot do it.';

  @override
  String get composer_failure_confirm_compress =>
      'Compress this chat? The gateway will shorten the transcript.';

  @override
  String composer_failure_confirm_model(String model) {
    return 'Switch this chat to $model?';
  }

  @override
  String get composer_drop_attach => 'Drop to attach';

  @override
  String get composer_drop_folder_unsupported =>
      'Folders can\'t be attached. Drop the files instead.';

  @override
  String get composer_drop_reference => 'Drop to reference';

  @override
  String get composer_reference_copy => 'Copy reference';

  @override
  String get composer_reference_remove => 'Remove reference';

  @override
  String get composer_btw_usage =>
      'Usage: /btw <question> — answered from a snapshot of this conversation without interrupting it.';

  @override
  String get composer_background_usage =>
      'Usage: /background <prompt> — the task runs separately and the result comes back here.';

  @override
  String get composer_handoff_usage =>
      'Usage: /handoff <platform> — transfer this chat to that messaging platform.';

  @override
  String get composer_command_needs_session =>
      'This command needs an open chat.';

  @override
  String get composer_retry_not_found =>
      'This turn is not in the saved history, so Retry cannot replace it. Nothing was sent again. Edit the message and send it for another try.';

  @override
  String get composer_retry_unavailable =>
      'Retry cannot replace a turn on this connection, so nothing was sent again. Edit the message and send it for another try.';

  @override
  String get composer_failure_switch_no_retry =>
      'Switching changes the model only: this connection can\'t run the failed turn again. Send it again after switching.';

  @override
  String get composer_command_needs_gateway_session =>
      'This chat has no gateway session yet. Send a message first, then run the command again.';

  @override
  String get composer_side_question =>
      'btw — answering from a conversation snapshot';

  @override
  String composer_side_question_id(String id) {
    return 'btw $id — answering from a conversation snapshot';
  }

  @override
  String get composer_background_started =>
      'Background task started. You can keep chatting. The result will appear here.';

  @override
  String composer_background_started_id(String id) {
    return 'Background task $id started. You can keep chatting. The result will appear here.';
  }

  @override
  String composer_handoff_requested(String platform) {
    return 'Handoff to $platform requested.';
  }

  @override
  String composer_handoff_done(String platform) {
    return 'Handed this chat to $platform.';
  }

  @override
  String get composer_handoff_failed => 'Handoff failed.';

  @override
  String get composer_handoff_timeout =>
      'Handoff did not finish. It may still be running on the gateway.';

  @override
  String get composer_compress_done => 'Compressed this chat.';

  @override
  String get composer_file_missing => 'That file is not on this device.';

  @override
  String get composer_attach_busy =>
      'Attachments can be added when this reply finishes.';

  @override
  String get nextgen_toggle => 'NextGen interface';

  @override
  String get nextgen_toggle_subtitle =>
      'A new design with one sign-in, live chats and network discovery. Your gateways and chats are shared with this interface.';

  @override
  String get nextgen_single_login => 'Sign in with one login';

  @override
  String get nextgen_single_login_subtitle =>
      'Add a gateway with just its dashboard address and one sign-in.';

  @override
  String get ng_allow_this_command => 'Allow this command?';

  @override
  String ng_hermes_wants_to_run_this_with(Object tool) {
    return 'Hermes wants to run this with $tool.';
  }

  @override
  String get ng_hermes_wants_to_run_this => 'Hermes wants to run this.';

  @override
  String get ng_hermes_has_a_question => 'Hermes has a question';

  @override
  String get ng_hermes_has_questions => 'Hermes has questions';

  @override
  String get ng_password_for_sudo => 'Password for sudo';

  @override
  String get ng_hermes_needs_your_sudo_password_to =>
      'Hermes needs your sudo password to run this command.';

  @override
  String get ng_a_secret_value => 'A secret value';

  @override
  String ng_value_for(Object variable) {
    return 'Value for $variable';
  }

  @override
  String get ng_your_password_manager => 'your password manager';

  @override
  String ng_unlock(Object name) {
    return 'Unlock $name';
  }

  @override
  String ng_hermes_needs_unlocked_to_sign_in(Object name) {
    return 'Hermes needs $name unlocked to sign in for you.';
  }

  @override
  String get ng_sign_in_code => 'Sign-in code';

  @override
  String get ng_enter_the_sign_in_code => 'Enter the sign-in code.';

  @override
  String ng_enter_the_sign_in_code_for(Object site) {
    return 'Enter the sign-in code for $site.';
  }

  @override
  String get ng_save_a_login => 'Save a login?';

  @override
  String ng_save_your_login(Object site) {
    return 'Save your $site login?';
  }

  @override
  String ng_couldn_t_load_this_chat(Object error) {
    return 'Couldn\'t load this chat: $error';
  }

  @override
  String ng_live_updates_are_unavailable(Object error) {
    return 'Live updates are unavailable: $error';
  }

  @override
  String ng_preparing(Object name) {
    return 'preparing $name…';
  }

  @override
  String get ng_the_turn_failed => 'The turn failed.';

  @override
  String get ng_turn_changed =>
      'that turn already ended or a newer one started';

  @override
  String get ng_steer_rejected => 'the running turn didn\'t accept it';

  @override
  String get ng_turn_not_known_yet =>
      'the running turn isn\'t known yet; try again in a moment';

  @override
  String ng_couldn_t_stop(Object error) {
    return 'Couldn\'t stop: $error';
  }

  @override
  String get ng_server_access => 'Server access';

  @override
  String get ng_sign_in => 'Sign-in';

  @override
  String get ng_live_connection => 'Live connection';

  @override
  String get ng_check_that_tailscale_is_on_on =>
      'Check that Tailscale is on, on this phone and on the server.';

  @override
  String get ng_check_the_address_and_that_the =>
      'Check the address and that the proxy forwards to the dashboard.';

  @override
  String get ng_use_the_same_network_as_the =>
      'Use the same network as the server, and start the dashboard with --host 0.0.0.0 so other devices can reach it.';

  @override
  String get ng_check_the_address_vpn_or_tailscale =>
      'Check the address, VPN or Tailscale connection.';

  @override
  String get ng_not_checked_yet => 'Not checked yet.';

  @override
  String get ng_checking => 'Checking…';

  @override
  String ng_hermes_answers_at(Object version, Object address) {
    return 'Hermes $version answers at $address.';
  }

  @override
  String get ng_something_answered_but_not_a_hermes =>
      'Something answered, but not a Hermes dashboard.';

  @override
  String ng_something_answered_http_but_not_a(Object status) {
    return 'Something answered (HTTP $status), but not a Hermes dashboard.';
  }

  @override
  String get ng_use_the_dashboard_s_address_and =>
      'Use the dashboard\'s address and port (9119 by default), not the API server\'s.';

  @override
  String get ng_cloudflare_access_turned_the_service_token =>
      'Cloudflare Access turned the service token down.';

  @override
  String get ng_cloudflare_access_is_in_front_of =>
      'Cloudflare Access is in front of this address.';

  @override
  String get ng_check_the_service_token_and_its =>
      'Check the service token and its Service Auth policy.';

  @override
  String get ng_add_a_cloudflare_access_service_token =>
      'Add a Cloudflare Access service token for this address.';

  @override
  String get ng_the_server_asks_for_a_client =>
      'The server asks for a client certificate.';

  @override
  String get ng_pick_the_client_certificate_for_this =>
      'Pick the client certificate for this gateway, then test again.';

  @override
  String get ng_needs_server_access_first => 'Needs server access first.';

  @override
  String get ng_needs_a_sign_in_first => 'Needs a sign-in first.';

  @override
  String ng_signed_in_as(Object name) {
    return 'Signed in as $name.';
  }

  @override
  String get ng_this_dashboard_doesn_t_need_a =>
      'This dashboard doesn\'t need a sign-in.';

  @override
  String get ng_the_saved_sign_in_has_expired =>
      'The saved sign-in has expired.';

  @override
  String get ng_sign_in_again => 'Sign in again.';

  @override
  String get ng_too_many_sign_in_attempts => 'Too many sign-in attempts.';

  @override
  String get ng_wait_a_minute_then_check_again =>
      'Wait a minute, then check again.';

  @override
  String ng_the_gateway_answered(Object message) {
    return 'The gateway answered: $message.';
  }

  @override
  String get ng_sign_in_again_or_update_hermes =>
      'Sign in again, or update Hermes.';

  @override
  String ng_couldn_t_check_the_sign_in(Object error) {
    return 'Couldn\'t check the sign-in: $error';
  }

  @override
  String ng_the_gateway_wouldn_t_issue_a(Object message) {
    return 'The gateway wouldn\'t issue a chat ticket ($message).';
  }

  @override
  String get ng_the_chat_connection_opened_and_the =>
      'The chat connection opened and the gateway said it\'s ready.';

  @override
  String get ng_the_gateway_never_said_it_was =>
      'The gateway never said it was ready.';

  @override
  String get ng_check_that_the_agent_is_running =>
      'Check that the agent is running on the server.';

  @override
  String get ng_the_gateway_refused_the_chat_connection =>
      'The gateway refused the chat connection (HTTP 403).';

  @override
  String get ng_this_dashboard_has_no_chat_endpoint =>
      'This dashboard has no chat endpoint (/api/ws).';

  @override
  String ng_the_chat_connection_failed(Object detail) {
    return 'The chat connection failed: $detail';
  }

  @override
  String get ng_use_the_exact_address_the_dashboard =>
      'Use the exact address the dashboard is configured for.';

  @override
  String get ng_update_hermes => 'Update Hermes.';

  @override
  String get ng_make_sure_the_proxy_allows_websocket =>
      'Make sure the proxy allows WebSocket upgrades on /api/ws.';

  @override
  String get ng_offline => 'Offline';

  @override
  String get ng_connecting => 'Connecting…';

  @override
  String get ng_connected => 'Connected';

  @override
  String get ng_reconnecting => 'Reconnecting…';

  @override
  String get ng_signed_out => 'Signed out';

  @override
  String get ng_connection_failed => 'Connection failed';

  @override
  String get ng_rate_limited_by_gateway => 'Rate limited by gateway';

  @override
  String ng_couldn_t_open_the_chat_connection(Object message) {
    return 'Couldn\'t open the chat connection: $message';
  }

  @override
  String get ng_the_gateway_returned_no_websocket_ticket =>
      'The gateway returned no WebSocket ticket.';

  @override
  String get ng_connection_lost => 'Connection lost';

  @override
  String get ng_this_dashboard_has_no_chat_endpoint_2 =>
      'This dashboard has no chat endpoint (/api/ws). Update Hermes.';

  @override
  String get ng_the_gateway_refused_the_chat_connection_2 =>
      'The gateway refused the chat connection. Check that the address matches the dashboard\'s configured host and that embedded chat is enabled.';

  @override
  String ng_the_gateway_refused(Object method) {
    return 'The gateway refused $method.';
  }

  @override
  String ng_couldn_t_read_your_saved_gateways(Object error) {
    return 'Couldn\'t read your saved gateways: $error';
  }

  @override
  String get ng_applies_to_new_chats => 'Applies to new chats';

  @override
  String ng_couldn_t_change(Object label, Object error) {
    return 'Couldn\'t change $label: $error';
  }

  @override
  String get ng_capabilities => 'Capabilities';

  @override
  String get ng_skills => 'Skills';

  @override
  String get ng_toolsets => 'Toolsets';

  @override
  String get ng_search => 'Search';

  @override
  String get ng_couldn_t_load => 'Couldn\'t load';

  @override
  String get ng_try_again => 'Try again';

  @override
  String get ng_no_skills => 'No skills';

  @override
  String get ng_no_toolsets => 'No toolsets';

  @override
  String get ng_no_mcp_servers => 'No MCP servers';

  @override
  String get ng_that_file_is_too_large_to =>
      'That file is too large to be a certificate.';

  @override
  String ng_the_certificate_couldn_t_be_imported(Object error) {
    return 'The certificate couldn\'t be imported: $error';
  }

  @override
  String get ng_now_pick_its_private_key => 'Now pick its private key.';

  @override
  String get ng_now_pick_its_certificate => 'Now pick its certificate.';

  @override
  String get ng_that_file_isn_t_a_certificate =>
      'That file isn\'t a certificate or a private key.';

  @override
  String get ng_if_a_proxy_in_front_of =>
      'If a proxy in front of this address asks for a client certificate, pick it here so the test, the sign-in and the chat all present it.';

  @override
  String get ng_client_certificates_are_only_used_with =>
      'Client certificates are only used with https:// addresses.';

  @override
  String get ng_remove => 'Remove';

  @override
  String get ng_certificate_password => 'Certificate password';

  @override
  String get ng_importing => 'Importing…';

  @override
  String get ng_pick_certificate => 'Pick certificate';

  @override
  String get ng_pick_a_different_certificate => 'Pick a different certificate';

  @override
  String get ng_accepts_p12_pfx_or_pem_certificate =>
      'Accepts .p12/.pfx, or PEM certificate and key files. The key stays in this app\'s private storage.';

  @override
  String get ng_photos => 'Photos';

  @override
  String get ng_camera => 'Camera';

  @override
  String get ng_files => 'Files';

  @override
  String ng_you_can_attach_up_to_files(Object count) {
    return 'You can attach up to $count files.';
  }

  @override
  String ng_couldn_t_read(Object name) {
    return 'Couldn\'t read $name.';
  }

  @override
  String ng_couldn_t_prepare_that_file(Object error) {
    return 'Couldn\'t prepare that file: $error';
  }

  @override
  String get ng_hermes_is_still_working => 'Hermes is still working';

  @override
  String get ng_steer => 'Steer';

  @override
  String get ng_adds_this_to_the_running_turn =>
      'Adds this to the running turn at its next step';

  @override
  String get ng_queue => 'Queue';

  @override
  String get ng_sends_it_when_the_turn_finishes =>
      'Sends it when the turn finishes';

  @override
  String get ng_stop_and_send => 'Stop and send';

  @override
  String get ng_stops_the_turn_then_sends_this =>
      'Stops the turn, then sends this';

  @override
  String ng_dictation_stopped(Object message) {
    return 'Dictation stopped: $message';
  }

  @override
  String get ng_speech_recognition_isn_t_available =>
      'Speech recognition isn\'t available.';

  @override
  String get ng_working => 'Working';

  @override
  String get ng_ready => 'Ready';

  @override
  String get ng_chats => 'Chats';

  @override
  String get ng_new_chat => 'New chat';

  @override
  String get ng_usage => 'Usage';

  @override
  String get ng_rename_chat => 'Rename chat';

  @override
  String ng_couldn_t_rename(Object error) {
    return 'Couldn\'t rename: $error';
  }

  @override
  String get ng_this_chat => 'This chat';

  @override
  String get ng_input_tokens => 'Input tokens';

  @override
  String get ng_output_tokens => 'Output tokens';

  @override
  String get ng_reasoning_tokens => 'Reasoning tokens';

  @override
  String get ng_cache_reads => 'Cache reads';

  @override
  String get ng_api_calls => 'API calls';

  @override
  String get ng_cost => 'Cost';

  @override
  String get ng_context => 'Context';

  @override
  String get ng_your_sign_in_expired => 'Your sign-in expired.';

  @override
  String get ng_sign_in_2 => 'Sign in';

  @override
  String get ng_retry => 'Retry';

  @override
  String get ng_project_home => 'Home';

  @override
  String get ng_choose_project => 'Choose a project';

  @override
  String ng_project_cwd_fallback(String path) {
    return 'The project folder wasn\'t available, so this chat runs in $path.';
  }

  @override
  String get ng_project_create_uncertain =>
      'The gateway may have created this chat, but did not confirm it. Check Chats before starting another; this request will not be retried automatically.';

  @override
  String get ng_what_should_we_work_on => 'What should we work on?';

  @override
  String get ng_ask_hermes_anything_it_can_run =>
      'Ask Hermes anything. It can run tools, browse and work in your files on the server.';

  @override
  String ng_working_2(Object frame) {
    return 'Working · $frame';
  }

  @override
  String get ng_default_model => 'Default model';

  @override
  String get ng_listening => 'Listening…';

  @override
  String get ng_steer_or_queue_a_message => 'Steer or queue a message';

  @override
  String get ng_message_hermes => 'Message Hermes';

  @override
  String get ng_attach => 'Attach';

  @override
  String get ng_stop_dictation => 'Stop dictation';

  @override
  String get ng_dictate => 'Dictate';

  @override
  String get ng_stop => 'Stop';

  @override
  String get ng_send => 'Send';

  @override
  String ng_slash_command_alias(String alias, String command) {
    return '$alias is an alias of $command';
  }

  @override
  String get ng_slash_command_no_description => 'No description available.';

  @override
  String get ng_slash_command_arguments_options =>
      'Takes one option from a fixed list.';

  @override
  String get ng_slash_command_arguments_text => 'Takes text after the command.';

  @override
  String get ng_slash_command_arguments_mixed =>
      'Takes an option or text after the command.';

  @override
  String get ng_slash_command_sent_as_message =>
      'NextGen sends this to Hermes as a normal message; the command itself doesn\'t run.';

  @override
  String get ng_slash_command_output => 'Command output';

  @override
  String get ng_slash_command_running => 'Running command…';

  @override
  String get ng_slash_command_done => 'Done.';

  @override
  String ng_slash_command_failed(Object error) {
    return 'Couldn\'t run the command: $error';
  }

  @override
  String get ng_slash_command_refused => 'Hermes can\'t run this command here.';

  @override
  String get ng_slash_command_delivery_unknown =>
      'The command was sent but no reply came back. It may still be running on the gateway, so it wasn\'t sent again and your draft was kept.';

  @override
  String get ng_slash_command_nothing_running => 'Nothing is running.';

  @override
  String get ng_steered => 'Steered';

  @override
  String get ng_copied => 'Copied';

  @override
  String ng_not_sent(Object reason) {
    return 'Not sent: $reason';
  }

  @override
  String get ng_thinking => 'Thinking…';

  @override
  String get ng_thought => 'Thought';

  @override
  String ng_used(Object name) {
    return 'Used $name';
  }

  @override
  String ng_used_tools(Object count) {
    return 'Used $count tools';
  }

  @override
  String get ng_copy => 'Copy';

  @override
  String get ng_read_aloud => 'Read aloud';

  @override
  String get ng_the_gateway_connection_dropped_try_again =>
      'The gateway connection dropped. Try again.';

  @override
  String get ng_allow_once => 'Allow once';

  @override
  String get ng_allow_until_sandbox_off => 'Until the sandbox is switched off';

  @override
  String get ng_folder_access => 'Folder access';

  @override
  String get ng_folder_access_unspecified =>
      'The gateway did not say whether this is read-only or read-write.';

  @override
  String get ng_folder_read_only => 'Read-only';

  @override
  String get ng_folder_read_write => 'Read and write';

  @override
  String get ng_website_access => 'Website access';

  @override
  String get ng_allow_for_this_chat => 'Allow for this chat';

  @override
  String get ng_always_allow => 'Always allow';

  @override
  String get ng_deny => 'Deny';

  @override
  String get ng_your_answer => 'Your answer';

  @override
  String get ng_or_type_an_answer => 'Or type an answer';

  @override
  String get ng_skip => 'Skip';

  @override
  String get ng_answer => 'Answer';

  @override
  String get ng_cancel => 'Cancel';

  @override
  String get ng_username_or_email => 'Username or email';

  @override
  String get ng_password => 'Password';

  @override
  String get ng_not_now => 'Not now';

  @override
  String get ng_save => 'Save';

  @override
  String get ng_enter_both_the_client_id_and =>
      'Enter both the Client ID and the Client Secret, or neither.';

  @override
  String get ng_enter_your_username_and_password =>
      'Enter your username and password.';

  @override
  String ng_couldn_t_save_the_sign_in(Object error) {
    return 'Couldn\'t save the sign-in: $error';
  }

  @override
  String get ng_wrong_username_or_password => 'Wrong username or password.';

  @override
  String get ng_too_many_attempts_wait_a_moment =>
      'Too many attempts. Wait a moment and try again.';

  @override
  String get ng_welcome_to_hermes => 'Welcome to Ares';

  @override
  String get ng_add_a_gateway => 'Add a gateway';

  @override
  String get ng_connect_to_your_hermes_agent_dashboard =>
      'Connect to your Hermes Agent dashboard. One address and one sign-in reach your chats, tools and settings. Nothing is sent until you sign in.';

  @override
  String get ng_connect_to_another_hermes_agent_dashboard =>
      'Connect to another Hermes Agent dashboard. You stay signed in to the ones you saved.';

  @override
  String get ng_dashboard_address => 'Dashboard address';

  @override
  String get ng_testing => 'Testing…';

  @override
  String get ng_test => 'Test';

  @override
  String get ng_where_your_hermes_dashboard_runs_lan =>
      'Where your hermes dashboard runs: LAN, Tailscale or HTTPS.';

  @override
  String get ng_find_on_my_network => 'Find on my network';

  @override
  String get ng_which_address_do_i_use => 'Which address do I use?';

  @override
  String get ng_behind_cloudflare_access => 'Behind Cloudflare Access?';

  @override
  String get ng_need_a_client_certificate => 'Need a client certificate?';

  @override
  String get ng_this_address_isn_t_private_and =>
      'This address isn\'t private and doesn\'t use https://, so your password and chats would cross the internet unencrypted. Use https://, Tailscale or your own network instead.';

  @override
  String get ng_continue_to_sign_in => 'Continue to sign in';

  @override
  String get ng_use_the_classic_interface_instead =>
      'Use the classic interface instead';

  @override
  String get ng_if_cloudflare_access_protects_this_address =>
      'If Cloudflare Access protects this address, create a service token in Cloudflare Zero Trust (Access, Service credentials) and add a Service Auth policy for it to the Access application.';

  @override
  String get ng_a_service_token_is_saved_for =>
      'A service token is saved for this address';

  @override
  String get ng_forget => 'Forget';

  @override
  String get ng_client_id => 'Client ID';

  @override
  String get ng_client_secret => 'Client Secret';

  @override
  String get ng_stored_encrypted_on_this_phone_and =>
      'Stored encrypted on this phone, and sent only to this address.';

  @override
  String get ng_hermes_is_reachable => 'Hermes is reachable';

  @override
  String ng_hermes_is_reachable_2(Object version) {
    return 'Hermes $version is reachable';
  }

  @override
  String get ng_sign_in_is_tested_next_then =>
      'Sign-in is tested next, then the chat';

  @override
  String get ng_agent_gateway => 'Agent gateway';

  @override
  String get ng_running => 'Running';

  @override
  String get ng_stopped => 'Stopped';

  @override
  String get ng_username_password => 'Username & password';

  @override
  String get ng_browser => 'Browser';

  @override
  String get ng_in_the_browser_sso => 'In the browser (SSO)';

  @override
  String get ng_profiles => 'Profiles';

  @override
  String get ng_this_dashboard_offers_neither_a_username =>
      'This dashboard offers neither a username/password provider nor browser sign-in. Update Hermes, or configure the username/password provider on the server.';

  @override
  String get ng_the_auth_gate_is_off_on =>
      'The auth gate is off on this dashboard. Anyone who can reach it can use your agent.';

  @override
  String get ng_couldn_t_reach_the_dashboard => 'Couldn\'t reach the dashboard';

  @override
  String ng_check_the_address_and_port_9119(Object reason) {
    return '$reason\n\nCheck the address and port (9119 by default). If the dashboard isn\'t running yet, run this on the server:\nhermes dashboard --host 0.0.0.0';
  }

  @override
  String get ng_that_isn_t_a_hermes_dashboard =>
      'That isn\'t a Hermes dashboard';

  @override
  String get ng_something_answered_but_not_a_hermes_2 =>
      'Something answered, but not a Hermes dashboard. Use the dashboard\'s address, not the API server\'s (port 8642).';

  @override
  String ng_something_answered_http_but_not_a_2(Object status) {
    return 'Something answered (HTTP $status), but not a Hermes dashboard. Use the dashboard\'s address, not the API server\'s (port 8642).';
  }

  @override
  String get ng_cloudflare_access_stopped_the_request =>
      'Cloudflare Access stopped the request';

  @override
  String ng_cloudflare_access_turned_down_the_service(Object status) {
    return 'Cloudflare Access turned down the service token (HTTP $status). Check the Client ID and Secret, and the Service Auth policy.';
  }

  @override
  String get ng_add_a_cloudflare_access_service_token_2 =>
      'Add a Cloudflare Access service token below, then test again.';

  @override
  String get ng_a_client_certificate_is_needed =>
      'A client certificate is needed';

  @override
  String get ng_this_server_asks_for_a_client =>
      'This server asks for a client certificate before it talks. Pick the one it gave you below, then test again.';

  @override
  String get ng_this_dashboard_doesn_t_ask_for =>
      'This dashboard doesn\'t ask for a sign-in.';

  @override
  String ng_use_the_dashboard_username_and_password(Object address) {
    return 'Use the dashboard username and password configured on $address, or sign in in your browser.';
  }

  @override
  String ng_use_the_dashboard_username_and_password_2(Object address) {
    return 'Use the dashboard username and password configured on $address.';
  }

  @override
  String ng_sign_in_to_in_your_browser(Object address) {
    return 'Sign in to $address in your browser, with the account its dashboard uses.';
  }

  @override
  String ng_gateway(Object address) {
    return 'Gateway $address';
  }

  @override
  String get ng_profile => 'Profile';

  @override
  String get ng_server_default => 'Server default';

  @override
  String get ng_continue => 'Continue';

  @override
  String get ng_username => 'Username';

  @override
  String get ng_signing_in => 'Signing in…';

  @override
  String get ng_waiting_for_the_browser => 'Waiting for the browser…';

  @override
  String get ng_sign_in_with_browser => 'Sign in with browser';

  @override
  String get ng_finish_signing_in_on_the_page =>
      'Finish signing in on the page that opened. Hermes comes back by itself when you\'re done.';

  @override
  String get ng_use_a_different_gateway => 'Use a different gateway';

  @override
  String get ng_same_wi_fi_or_local_network => 'Same Wi-Fi or local network';

  @override
  String get ng_use_the_server_s_local_address =>
      'Use the server\'s local address and port, like 192.168.1.20:9119. Start the dashboard with --host 0.0.0.0 so other devices can reach it.';

  @override
  String get ng_tailscale => 'Tailscale';

  @override
  String get ng_turn_on_tailscale_on_this_phone =>
      'Turn on Tailscale on this phone and use the server\'s Tailscale address, like 100.64.0.1:9119 or its .ts.net name. Works away from home too.';

  @override
  String get ng_use_your_https_address_when_the =>
      'Use your https:// address when the dashboard sits behind a proxy with a certificate. The proxy must also pass WebSocket upgrades on /api/ws.';

  @override
  String get ng_start_the_dashboard_on_the_server =>
      'Start the dashboard on the server:';

  @override
  String get ng_enter_a_port_from_1_to => 'Enter a port from 1 to 65535.';

  @override
  String get ng_looks_for_hermes_dashboards_on_port =>
      'Looks for Hermes dashboards on port 9119 on this Wi-Fi network, and checks the computers you have already saved.';

  @override
  String ng_looks_for_hermes_dashboards_on_ports(Object port) {
    return 'Looks for Hermes dashboards on ports 9119 and $port on this Wi-Fi network, and checks the computers you have already saved.';
  }

  @override
  String get ng_other_port_optional => 'Other port (optional)';

  @override
  String get ng_no_dashboards_answered_start_one_with =>
      'No dashboards answered. Start one with hermes dashboard --host 0.0.0.0, or type its address.';

  @override
  String get ng_using_tailscale_or_a_vpn_those =>
      'Using Tailscale or a VPN? Those networks cannot be searched. Type the computer\'s 100.x address or its .ts.net name instead.';

  @override
  String get ng_search_again => 'Search again';

  @override
  String get ng_insights => 'Insights';

  @override
  String get ng_couldn_t_load_insights => 'Couldn\'t load insights';

  @override
  String get ng_sessions => 'Sessions';

  @override
  String get ng_tokens => 'Tokens';

  @override
  String get ng_est_cost => 'Est. cost';

  @override
  String get ng_daily_tokens => 'Daily tokens';

  @override
  String get ng_models => 'Models';

  @override
  String get ng_tools => 'Tools';

  @override
  String get ng_hermes_is_waiting_for_you => 'Hermes is waiting for you.';

  @override
  String get ng_hermes_replied => 'Hermes replied';

  @override
  String get ng_the_turn_finished => 'The turn finished.';

  @override
  String get ng_off => 'Off';

  @override
  String get ng_minimal => 'Minimal';

  @override
  String get ng_low => 'Low';

  @override
  String get ng_medium => 'Medium';

  @override
  String get ng_high => 'High';

  @override
  String get ng_extra_high => 'Extra high';

  @override
  String get ng_max => 'Max';

  @override
  String get ng_ultra => 'Ultra';

  @override
  String get ng_default => 'Default';

  @override
  String ng_couldn_t_switch_model(Object error) {
    return 'Couldn\'t switch model: $error';
  }

  @override
  String get ng_model => 'Model';

  @override
  String get ng_thinking_2 => 'Thinking';

  @override
  String get ng_search_models => 'Search models';

  @override
  String get ng_no_models_match => 'No models match these filters.';

  @override
  String get privacy_policy => 'Privacy policy';

  @override
  String get report_ai_output => 'Report AI output';

  @override
  String ng_couldn_t_load_models(Object error) {
    return 'Couldn\'t load models: $error';
  }

  @override
  String get ng_no_providers_are_set_up_on =>
      'No providers are set up on this gateway yet.';

  @override
  String get ng_starred => 'Starred';

  @override
  String get ng_recent => 'Recent';

  @override
  String get ng_more => 'More';

  @override
  String get ng_archived_chats => 'Archived chats';

  @override
  String get ng_projects => 'Projects';

  @override
  String get ng_chats_grouped_by_project_and_workspace =>
      'Chats grouped by project and workspace';

  @override
  String get ng_agent => 'Agent';

  @override
  String get ng_memory => 'Memory';

  @override
  String get ng_what_hermes_remembers_about_you =>
      'What Hermes remembers about you';

  @override
  String get ng_skills_library => 'Skills library';

  @override
  String get ng_browse_and_read_installed_skills =>
      'Browse and read installed skills';

  @override
  String get ng_cron_editor => 'Cron editor';

  @override
  String get ng_edit_schedules_prompts_and_delivery =>
      'Edit schedules, prompts and delivery';

  @override
  String get ng_config_file => 'Config file';

  @override
  String get ng_edit_config_yaml_on_the_gateway =>
      'Edit config.yaml on the gateway';

  @override
  String get ng_models_and_providers => 'Models and providers';

  @override
  String get ng_model_management => 'Model management';

  @override
  String get ng_default_fallback_and_auxiliary_models =>
      'Default, fallback and auxiliary models';

  @override
  String get ng_provider_sign_in => 'Provider sign-in';

  @override
  String get ng_connect_provider_accounts_with_oauth =>
      'Connect provider accounts with OAuth';

  @override
  String get ng_nous_portal => 'Nous Portal';

  @override
  String get ng_subscription_credits_and_usage =>
      'Subscription, credits and usage';

  @override
  String get ng_interface => 'Interface';

  @override
  String get ng_switch_to_the_classic_interface =>
      'Switch to the classic interface';

  @override
  String get ng_turns_nextgen_off_you_can_turn =>
      'Turns NextGen off. You can turn it back on in Settings.';

  @override
  String get ng_restored => 'Restored';

  @override
  String get ng_archived => 'Archived';

  @override
  String get ng_couldn_t_load_archived_chats => 'Couldn\'t load archived chats';

  @override
  String get ng_nothing_archived => 'Nothing archived';

  @override
  String get ng_restore => 'Restore';

  @override
  String get ng_saved_new_chats_use_it => 'Saved. New chats use it.';

  @override
  String ng_couldn_t_save(Object error) {
    return 'Couldn\'t save: $error';
  }

  @override
  String get ng_saving => 'Saving…';

  @override
  String ng_today(Object time) {
    return 'Today $time';
  }

  @override
  String get ng_mon => 'Mon';

  @override
  String get ng_tue => 'Tue';

  @override
  String get ng_wed => 'Wed';

  @override
  String get ng_thu => 'Thu';

  @override
  String get ng_fri => 'Fri';

  @override
  String get ng_sat => 'Sat';

  @override
  String get ng_sun => 'Sun';

  @override
  String get ng_scheduled => 'Scheduled';

  @override
  String get ng_new_job => 'New job';

  @override
  String get ng_couldn_t_load_scheduled_jobs => 'Couldn\'t load scheduled jobs';

  @override
  String get ng_nothing_scheduled => 'Nothing scheduled';

  @override
  String get ng_ask_hermes_to_do_something_on =>
      'Ask Hermes to do something on a schedule, or add a job here.';

  @override
  String get ng_active => 'Active';

  @override
  String get ng_paused => 'Paused';

  @override
  String ng_next(Object when) {
    return 'Next $when';
  }

  @override
  String ng_last(Object when) {
    return 'Last $when';
  }

  @override
  String ng_last_2(Object when, Object result) {
    return 'Last $when · $result';
  }

  @override
  String ng_job(Object id) {
    return 'Job $id';
  }

  @override
  String get ng_delete => 'Delete';

  @override
  String get ng_delete_this_job => 'Delete this job?';

  @override
  String get ng_it_stops_running_past_runs_stay =>
      'It stops running. Past runs stay in your chats.';

  @override
  String ng_next_run(Object when) {
    return 'Next run $when';
  }

  @override
  String ng_delivers_to(Object target) {
    return 'Delivers to $target';
  }

  @override
  String get ng_run_now => 'Run now';

  @override
  String get ng_started => 'Started';

  @override
  String get ng_pause => 'Pause';

  @override
  String get ng_resume => 'Resume';

  @override
  String get ng_resumed => 'Resumed';

  @override
  String get ng_prompt => 'Prompt';

  @override
  String get ng_runs => 'Runs';

  @override
  String get ng_no_runs_yet => 'No runs yet.';

  @override
  String get ng_enter_a_schedule_and_a_prompt =>
      'Enter a schedule and a prompt.';

  @override
  String get ng_name_optional => 'Name (optional)';

  @override
  String get ng_schedule => 'Schedule';

  @override
  String get ng_every_1h_0_9_or_30m => 'every 1h, 0 9 * * *, or 30m';

  @override
  String get ng_create => 'Create';

  @override
  String get ng_unpin => 'Unpin';

  @override
  String get ng_pin => 'Pin';

  @override
  String get ng_rename => 'Rename';

  @override
  String get ng_archive => 'Archive';

  @override
  String get ng_delete_this_chat => 'Delete this chat?';

  @override
  String get ng_it_is_removed_from_the_gateway =>
      'It is removed from the gateway for every device.';

  @override
  String get ng_search_chats => 'Search chats';

  @override
  String get ng_pinned => 'Pinned';

  @override
  String get ng_no_chats_match => 'No chats match.';

  @override
  String get ng_no_chats_yet => 'No chats yet.';

  @override
  String get ng_nothing_is_running => 'Nothing is running.';

  @override
  String get ng_nothing_is_waiting_on_you => 'Nothing is waiting on you.';

  @override
  String get ng_settings => 'Settings';

  @override
  String get ng_all => 'All';

  @override
  String ng_needs_you(Object count) {
    return 'Needs you · $count';
  }

  @override
  String get ng_needs_you_2 => 'Needs you';

  @override
  String get ng_gateways => 'Gateways';

  @override
  String ng_classic_connection(Object address) {
    return '$address · classic connection';
  }

  @override
  String get ng_gateway_2 => 'Gateway';

  @override
  String get ng_signed_in => 'Signed in';

  @override
  String get ng_classic_connection_2 => 'Classic connection';

  @override
  String get ng_in_the_browser => 'In the browser';

  @override
  String ng_in_the_browser_as(Object name) {
    return 'In the browser as $name';
  }

  @override
  String get ng_not_required => 'Not required';

  @override
  String get ng_test_connection => 'Test connection';

  @override
  String get ng_sign_in_again_2 => 'Sign in again';

  @override
  String get ng_sign_out => 'Sign out';

  @override
  String get ng_saved_gateways => 'Saved gateways';

  @override
  String get ng_in_use => 'In use';

  @override
  String get ng_appearance => 'Appearance';

  @override
  String get ng_theme => 'Theme';

  @override
  String get ng_system => 'System';

  @override
  String get ng_light => 'Light';

  @override
  String get ng_dark => 'Dark';

  @override
  String get ng_accent => 'Accent';

  @override
  String get ng_pure_black => 'Pure black';

  @override
  String get ng_dark_theme_uses_true_black_oled =>
      'Dark theme uses true black (OLED)';

  @override
  String get ng_glow => 'Glow';

  @override
  String get ng_soft_accent_light_behind_each_screen =>
      'Soft accent light behind each screen';

  @override
  String get ng_the_new_interface_turn_off_to =>
      'The new interface. Turn off to go back to the classic one; your gateways and chats are shared.';

  @override
  String get ng_more_settings => 'More settings';

  @override
  String get ng_voice_notifications_language_backups_and_the =>
      'Voice, notifications, language, backups and the gateway\'s config';

  @override
  String get ng_licences => 'Licences';

  @override
  String ng_sign_out_of(Object name) {
    return 'Sign out of $name?';
  }

  @override
  String get ng_this_gateway_and_its_saved_sign =>
      'This gateway and its saved sign-in are removed from this phone, in both interfaces. Your chats stay on the gateway.';

  @override
  String get ng_password_or_browser => 'Password or browser';

  @override
  String get ng_unsupported => 'Unsupported';

  @override
  String get ng_background_task_finished => 'Background task finished';

  @override
  String get ng_background_process_finished => 'Background process finished';

  @override
  String get ng_system_message => 'System message';

  @override
  String get ng_summary => 'Summary';

  @override
  String get classic_interface_only => 'Classic interface only';

  @override
  String get classic_only_settings_hint =>
      'Sections marked Classic interface only change the classic look and chat, not NextGen. NextGen has its own appearance options in its Settings.';

  @override
  String get attachment_preview_too_large =>
      'Too large to preview here. Save or Share downloads it to your phone (up to 1 GB).';

  @override
  String get attachment_over_phone_limit =>
      'This file is over 1 GB and exceeds the download limit. Open the dashboard to download it.';

  @override
  String attachment_downloading_percent(int percent) {
    return 'Downloading… $percent%';
  }

  @override
  String attachment_downloading_mb(int megabytes) {
    return 'Downloading… $megabytes MB';
  }

  @override
  String ng_attachment_too_large_for_gateway(String name) {
    return '$name is larger than 12 MB, the most this gateway takes. Update Hermes to send files up to 100 MB.';
  }

  @override
  String ng_couldn_t_upload(String name) {
    return 'Couldn\'t upload $name.';
  }

  @override
  String ng_uploading_percent(int percent) {
    return 'Uploading… $percent%';
  }

  @override
  String get ng_show_tasks => 'Show tasks';

  @override
  String get ng_hide_tasks => 'Hide tasks';

  @override
  String get ng_goal => 'Goal';

  @override
  String get ng_loop => 'Loop';

  @override
  String get ng_heartbeat => 'Heartbeat';

  @override
  String get ng_goal_working => 'Working';

  @override
  String get ng_goal_waiting => 'Waiting';

  @override
  String get ng_goal_blocked => 'Blocked';

  @override
  String get ng_goal_done => 'Done';

  @override
  String ng_goal_turns_of(int used, int max) {
    return '$used of $max turns';
  }

  @override
  String ng_goal_turn(int used) {
    return 'turn $used';
  }

  @override
  String get ng_loop_held => 'Held for goal';

  @override
  String get ng_loop_finished => 'Finished';

  @override
  String get ng_loop_running => 'Running';

  @override
  String ng_loop_runs_of(int fired, int times) {
    return '$fired of $times runs';
  }

  @override
  String ng_loop_runs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count runs',
      one: '1 run',
    );
    return '$_temp0';
  }

  @override
  String ng_loop_next(String time) {
    return 'next $time';
  }

  @override
  String get ng_loop_due_now => 'due now';

  @override
  String ng_every_seconds(int seconds) {
    return 'every $seconds s';
  }

  @override
  String ng_every_minutes(int minutes) {
    return 'every $minutes min';
  }

  @override
  String ng_every_hours(int hours) {
    return 'every $hours h';
  }

  @override
  String ng_every_hours_minutes(int hours, int minutes) {
    return 'every $hours h $minutes min';
  }

  @override
  String ng_heartbeat_fired(int count) {
    return '$count fired';
  }

  @override
  String ng_heartbeat_last_fired(String time) {
    return 'Last fired at $time';
  }

  @override
  String ng_wait_until(String time) {
    return 'Waiting until $time';
  }

  @override
  String get ng_wait_resume => 'Waiting to resume';

  @override
  String get ng_wait_other_chat => 'Waiting on another chat';

  @override
  String ng_wait_process(String pid) {
    return 'Waiting on process $pid';
  }

  @override
  String get ng_control_open => 'Open goal and automation';

  @override
  String get ng_control_title => 'Goal and automation';

  @override
  String get ng_control_subtitle =>
      'What this chat is working toward, and what runs on its own.';

  @override
  String get ng_contract_outcome => 'Outcome';

  @override
  String get ng_contract_verification => 'Verification';

  @override
  String get ng_contract_constraints => 'Constraints';

  @override
  String get ng_contract_boundaries => 'Boundaries';

  @override
  String get ng_contract_stop_when => 'Stop when';

  @override
  String get ng_subgoals => 'Sub-goals';

  @override
  String get ng_subgoal_add_placeholder => 'Add a sub-goal';

  @override
  String get ng_add => 'Add';

  @override
  String get ng_subgoal_remove => 'Remove sub-goal';

  @override
  String get ng_goal_checks => 'Checks';

  @override
  String get ng_gate_not_run => 'Not run yet';

  @override
  String ng_gate_attempts(int attempts, int tries) {
    return '$attempts of $tries attempts';
  }

  @override
  String ng_gate_exit(int code) {
    return 'exit $code';
  }

  @override
  String get ng_resume_now => 'Resume now';

  @override
  String get ng_goal_clear => 'Clear goal';

  @override
  String get ng_goal_clear_title => 'Clear this goal?';

  @override
  String get ng_goal_clear_message =>
      'The agent stops working toward it. Its sub-goals and checks go with it.';

  @override
  String get ng_subgoal_remove_title => 'Remove this sub-goal?';

  @override
  String ng_subgoal_remove_message(String text) {
    return '\"$text\" will no longer be part of the goal.';
  }

  @override
  String get ng_subgoals_clear_title => 'Clear all sub-goals?';

  @override
  String get ng_subgoals_clear_message =>
      'The goal keeps its title but loses all of its sub-goals.';

  @override
  String get ng_clear_all => 'Clear all';

  @override
  String get ng_clear => 'Clear';

  @override
  String get ng_dismiss => 'Dismiss';

  @override
  String get ng_loop_stop_title => 'Stop this loop?';

  @override
  String get ng_heartbeat_clear_title => 'Clear this heartbeat?';

  @override
  String get ng_wont_fire_again => 'It won\'t fire again.';

  @override
  String get ng_loop_self_paced => 'Self-paced';

  @override
  String ng_loop_until(String condition) {
    return 'Until: $condition';
  }

  @override
  String get ng_loop_waits_for_goal => 'Waits while the goal is working.';

  @override
  String get ng_loop_awaiting_reply => 'Waiting for the agent\'s reply.';

  @override
  String ng_loop_stopped_reason(String reason) {
    return 'Stopped: $reason';
  }

  @override
  String get ng_hide_subagents => 'Hide subagents';

  @override
  String get ng_show_subagents => 'Show subagents';

  @override
  String get ng_subagent => 'Subagent';

  @override
  String get ng_subagent_queued => 'Queued';

  @override
  String get ng_subagent_starting => 'Starting…';

  @override
  String get ng_subagent_running => 'Running';

  @override
  String get ng_subagent_done => 'Done';

  @override
  String get ng_subagent_failed => 'Failed';

  @override
  String get ng_subagent_stopped => 'Stopped';

  @override
  String get ng_subagent_stop => 'Stop subagent';

  @override
  String ng_subagent_tools(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tools',
      one: '1 tool',
    );
    return '$_temp0';
  }

  @override
  String get ng_mark_as_read => 'Mark as read';

  @override
  String get ng_mark_as_unread => 'Mark as unread';

  @override
  String ng_chats_unread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chats, $count unread',
      one: 'Chats, 1 unread',
    );
    return '$_temp0';
  }

  @override
  String get ng_unread_finished => 'Finished, unread reply';

  @override
  String get ng_unread_updates => 'Running, unread updates';

  @override
  String get ng_notifications => 'Notifications';

  @override
  String get ng_notifications_hint =>
      'Replies and requests while Ares is in the background';

  @override
  String get ng_notify_replies => 'Replies';

  @override
  String get ng_notify_replies_hint =>
      'When a turn finishes or fails in the open chat';

  @override
  String get ng_notify_requests => 'Approvals and questions';

  @override
  String get ng_notify_requests_hint =>
      'A heads-up when the agent waits on you, with Allow once and Deny';

  @override
  String get ng_keep_running => 'Stay connected while a reply runs';

  @override
  String get ng_keep_running_hint =>
      'Keeps the connection open in the background until the reply finishes, with a quiet notification';

  @override
  String get ng_battery_settings => 'Battery optimisation';

  @override
  String get ng_battery_settings_hint =>
      'Let Ares run in the background so notifications arrive on time';

  @override
  String get ng_send_test_notification => 'Send a test notification';

  @override
  String get ng_test_notification_title => 'Ares notifications work';

  @override
  String get ng_test_notification_body =>
      'Replies and requests will show up like this.';

  @override
  String get ng_test_notification_sent => 'Test notification sent';

  @override
  String get ng_notifications_blocked =>
      'Notifications are blocked. Allow them in Android settings.';

  @override
  String get ng_notifications_off_hint =>
      'Notifications are off, so nothing is posted while Ares is in the background.';

  @override
  String get ng_insights_building =>
      'Building the report. A long period can take up to a minute the first time.';

  @override
  String get ng_insights_timed_out =>
      'The gateway took too long to build this report. Try again, or pick a shorter period.';

  @override
  String get ng_dock_goal_active => 'Goal active';

  @override
  String get ng_dock_goal_paused => 'Goal paused';

  @override
  String get ng_dock_goal_waiting => 'Goal waiting';

  @override
  String get ng_dock_goal_blocked => 'Goal blocked';

  @override
  String get ng_dock_goal_done => 'Goal done';

  @override
  String ng_dock_turn_of(int used, int max) {
    return 'Turn $used/$max';
  }

  @override
  String ng_dock_turn(int used) {
    return 'Turn $used';
  }

  @override
  String ng_dock_subagents(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Subagents',
      one: '1 Subagent',
    );
    return '$_temp0';
  }

  @override
  String ng_dock_subagents_done(int count) {
    return '$count done';
  }

  @override
  String ng_dock_tasks(int done, int total) {
    return 'Tasks $done/$total';
  }

  @override
  String ng_dock_previous_tasks(int done, int total) {
    return 'Previous tasks $done/$total';
  }

  @override
  String get ng_dock_manage => 'Manage';

  @override
  String get ng_recent_notifications => 'Recent notifications';

  @override
  String get ng_recent_notifications_hint =>
      'What Ares tried to post and whether Android showed it';

  @override
  String get ng_recent_notifications_empty =>
      'Nothing yet. Attempts appear here once a reply, question or failure would notify you.';

  @override
  String get ng_notify_permission_granted => 'Permission granted';

  @override
  String get ng_notify_permission_denied => 'Permission denied';

  @override
  String get ng_notify_master_on => 'Notifications on';

  @override
  String get ng_notify_master_off => 'Notifications off';

  @override
  String get ng_models_default => 'Default model';

  @override
  String get ng_models_change => 'Change';

  @override
  String get ng_models_custom_endpoint =>
      'Runs on a custom endpoint. Change it on the gateway.';

  @override
  String get ng_models_context_window => 'Context window';

  @override
  String ng_models_token_count(String count) {
    return '$count tokens';
  }

  @override
  String ng_models_context_override(String count) {
    return 'Set on the gateway. Auto-detected: $count tokens.';
  }

  @override
  String get ng_models_max_output => 'Max output';

  @override
  String get ng_models_input_price => 'Input price';

  @override
  String get ng_models_output_price => 'Output price';

  @override
  String get ng_models_cache_price => 'Cached input price';

  @override
  String ng_models_per_million(String price) {
    return '$price per 1M tokens';
  }

  @override
  String ng_models_price_pair(String input, String output) {
    return '$input in · $output out per 1M tokens';
  }

  @override
  String get ng_models_free => 'Free';

  @override
  String get ng_models_vision => 'Vision';

  @override
  String get ng_models_reasoning => 'Reasoning';

  @override
  String get ng_models_fast => 'Fast mode';

  @override
  String get ng_models_in_use => 'In use';

  @override
  String ng_models_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count models',
      one: '$count model',
    );
    return '$_temp0';
  }

  @override
  String get ng_models_rate_limited => 'Rate-limited';

  @override
  String get ng_models_plan_locked => 'Not on your plan';

  @override
  String get ng_models_unsaved => 'Unsaved changes';

  @override
  String get ng_models_discard => 'Discard';

  @override
  String get ng_models_aux_hint =>
      'Helper tasks use the default model unless you give them their own.';

  @override
  String get ng_models_uses_default => 'Uses the default model';

  @override
  String get ng_models_thinking_level => 'Thinking level';

  @override
  String get ng_models_providers => 'Providers';

  @override
  String get ng_models_saved => 'Saved';

  @override
  String get ng_aux_vision => 'Vision';

  @override
  String get ng_aux_vision_hint => 'Reads images and screenshots';

  @override
  String get ng_aux_compression => 'Compression';

  @override
  String get ng_aux_compression_hint =>
      'Shortens a long chat so it fits the context window';

  @override
  String get ng_aux_approval => 'Approval';

  @override
  String get ng_aux_approval_hint =>
      'Decides whether a command is safe to run without asking';

  @override
  String get ng_aux_mcp => 'MCP';

  @override
  String get ng_aux_mcp_hint => 'Chooses which MCP tools to use';

  @override
  String get ng_aux_title_generation => 'Chat titles';

  @override
  String get ng_aux_title_generation_hint => 'Names new chats';

  @override
  String get ng_aux_review => 'Review';

  @override
  String get ng_aux_review_hint => 'Reviews work when you run /review';

  @override
  String get ng_aux_voice_chat => 'Voice chat';

  @override
  String get ng_aux_voice_chat_hint => 'Replies in voice mode';

  @override
  String get ng_aux_triage_specifier => 'Triage';

  @override
  String get ng_aux_triage_specifier_hint =>
      'Expands a one-line Kanban card into a spec';

  @override
  String get ng_aux_kanban_decomposer => 'Kanban breakdown';

  @override
  String get ng_aux_kanban_decomposer_hint =>
      'Splits a Kanban card into smaller tasks';

  @override
  String get ng_aux_profile_describer => 'Profile descriptions';

  @override
  String get ng_aux_profile_describer_hint =>
      'Writes each profile\'s short description';

  @override
  String get ng_aux_curator => 'Curator';

  @override
  String get ng_aux_curator_hint => 'Reviews how skills are used';

  @override
  String get appearance_save_failed => 'Could not save this change.';

  @override
  String get appearance_keep_which_theme => 'Keep which theme?';

  @override
  String get appearance_tour_back => 'Back';

  @override
  String get appearance_tour_finish => 'Finish';

  @override
  String get appearance_tour_next => 'Next';

  @override
  String get appearance_tour_close => 'Close tour';

  @override
  String get appearance_dismiss_tip => 'Dismiss tip';

  @override
  String get appearance_search_settings => 'Search settings';

  @override
  String get appearance_search_show => 'Show';

  @override
  String get appearance_no_matching_setting => 'No matching setting.';

  @override
  String get appearance_replay_tour => 'Replay tour';

  @override
  String get appearance_show_tips_again => 'Show tips again';

  @override
  String get appearance_window_translucency_unavailable =>
      'Window translucency is not available on this host. Linux cannot provide it, and the Apple and Windows runners paint an opaque Flutter view.';

  @override
  String get appearance_imported_themes => 'Imported themes';

  @override
  String get appearance_import_theme_file => 'Import theme file';

  @override
  String get appearance_remove_theme => 'Remove theme';

  @override
  String get appearance_chat_font => 'Chat font';

  @override
  String get appearance_terminal_font => 'Terminal font';

  @override
  String get appearance_font_platform => 'Platform';

  @override
  String get appearance_automatic => 'Automatic';

  @override
  String get appearance_force_left_to_right => 'Force left to right';

  @override
  String get appearance_force_right_to_left => 'Force right to left';

  @override
  String get appearance_user_bubble_opacity => 'User bubble opacity';

  @override
  String get appearance_inline_embeds => 'Inline embeds';

  @override
  String get appearance_inline_embeds_hint =>
      'Rich previews load from third-party sites (YouTube, X, …). Ask shows a placeholder until you allow each one; Always loads them automatically; Off keeps plain links.';

  @override
  String get appearance_embeds_ask => 'Ask';

  @override
  String get appearance_embeds_always => 'Always';

  @override
  String get appearance_embeds_off => 'Off';

  @override
  String appearance_embeds_reset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Reset $count allowed services',
      one: 'Reset 1 allowed service',
    );
    return '$_temp0';
  }

  @override
  String get appearance_embed_load => 'Load';

  @override
  String appearance_embed_always_allow(String service) {
    return 'Always allow $service';
  }

  @override
  String get appearance_embed_loading => 'Loading preview…';

  @override
  String appearance_embed_image_failed(String host) {
    return 'Couldn\'t load the image from $host. Tap to open it.';
  }

  @override
  String get appearance_embed_preview_unavailable => 'Preview unavailable';

  @override
  String get appearance_emoji_reactions => 'Emoji reactions';

  @override
  String get appearance_celebration_hearts => 'Celebration hearts';

  @override
  String get appearance_celebration_hearts_hint =>
      'A heart plays when a reply arrives while you were away.';

  @override
  String get appearance_pop_out_companion => 'Pop out companion';

  @override
  String get appearance_mosskip => 'Mosskip';

  @override
  String get appearance_emberbun => 'Emberbun';

  @override
  String get appearance_tideling => 'Tideling';

  @override
  String get appearance_my_hatchling => 'My hatchling';

  @override
  String get appearance_at_rest => 'At rest';

  @override
  String get appearance_working => 'Working';

  @override
  String get appearance_thinking => 'Thinking';

  @override
  String get appearance_waiting_for_you => 'Waiting for you';

  @override
  String get appearance_reply_ready => 'Reply ready';

  @override
  String get appearance_turn_failed => 'Turn failed';

  @override
  String get appearance_small => 'Small';

  @override
  String get appearance_medium => 'Medium';

  @override
  String get appearance_large => 'Large';

  @override
  String get appearance_hello => 'Hello!';

  @override
  String get appearance_unread_reply => 'Unread reply';

  @override
  String get appearance_compose => 'Compose';

  @override
  String get appearance_say_hello => 'Say hello';

  @override
  String get appearance_pet_image_failed =>
      'Could not open that image. Choose a smaller PNG or JPEG.';

  @override
  String get appearance_pet_companion => 'Pet companion';

  @override
  String get appearance_pet_companion_hint =>
      'Show a companion while you chat.';

  @override
  String get appearance_adopt_a_companion => 'Adopt a companion';

  @override
  String get appearance_roam_when_idle => 'Roam when idle';

  @override
  String get appearance_pet_size => 'Pet size';

  @override
  String get appearance_hatch_from_a_local_picture =>
      'Hatch from a local picture';

  @override
  String get appearance_pet_image_limits =>
      'Choose a PNG or JPEG (up to 4 MiB, 4096 px per side and 8 MP). Preview it first. Hatching saves one 24 × 24 pixel portrait and replaces your previous hatchling.';

  @override
  String get appearance_choose_picture => 'Choose picture';

  @override
  String get appearance_hatchling_preview => 'Hatchling preview';

  @override
  String get appearance_hatch_and_adopt => 'Hatch and adopt';

  @override
  String get appearance_discard_draft => 'Discard draft';

  @override
  String get appearance_forget_saved_hatchling => 'Forget saved hatchling';

  @override
  String get appearance_radio => 'Radio';

  @override
  String appearance_radio_hint(String stations) {
    return 'Streams come straight from $stations and start only when you press Play. Station search stays on this device.';
  }

  @override
  String get appearance_radio_save_failed =>
      'Radio settings could not be saved.';

  @override
  String get appearance_choose_a_station => 'Choose a station';

  @override
  String get appearance_pause_radio => 'Pause radio';

  @override
  String get appearance_play_radio => 'Play radio';

  @override
  String get appearance_next_station => 'Next station';

  @override
  String get appearance_radio_trace_semantics =>
      'Stream activity. Audio levels are unavailable, so this line stays flat.';

  @override
  String get appearance_radio_is_off => 'Radio is off';

  @override
  String get appearance_paused => 'Paused';

  @override
  String get appearance_connecting => 'Connecting…';

  @override
  String get appearance_live => 'Live';

  @override
  String get appearance_stream_unavailable => 'Stream unavailable';

  @override
  String appearance_now_playing(String credit) {
    return 'Now playing: $credit';
  }

  @override
  String get appearance_audio_only_waveform_unavailable =>
      'Audio only · waveform unavailable';

  @override
  String get appearance_volume => 'Volume';

  @override
  String get appearance_search_presets => 'Search presets';

  @override
  String get appearance_no_stations_found => 'No stations found';

  @override
  String appearance_unpin_station(String station) {
    return 'Unpin station: $station';
  }

  @override
  String appearance_pin_station(String station) {
    return 'Pin station: $station';
  }

  @override
  String get appearance_radio_picker_metadata_notice =>
      'While this picker is open, playing stations may share track details directly from the broadcaster.';

  @override
  String get appearance_message_from_your_companion =>
      'Message from your companion';

  @override
  String get appearance_send_to_the_open_chat => 'Send to the open chat';

  @override
  String get appearance_tour_theme_body =>
      'Import a VS Code colour theme from a file on this device, then choose which variant to keep.';

  @override
  String get appearance_tour_fonts_title => 'Reading fonts';

  @override
  String get appearance_tour_fonts_body =>
      'Chat prose and terminal code use separate faces shipped with Ares.';

  @override
  String get appearance_tour_direction_title => 'Transcript direction';

  @override
  String get appearance_tour_direction_body =>
      'Leave this on automatic, or force the transcript left to right or right to left.';

  @override
  String get appearance_tour_pet_title => 'Companion';

  @override
  String get appearance_tour_pet_body =>
      'The companion is off until you adopt one. Pop-out adds a small composer.';

  @override
  String get appearance_tour_radio_body =>
      'Radio stays off until you enable it. Play is what opens a stream.';

  @override
  String get appearance_tip_theme =>
      'Imported themes replace the built-in palette until you clear the selection. Only the colours are kept.';

  @override
  String get appearance_tip_pet =>
      'The companion stores one small portrait on this device. It does not upload the picture you hatch from.';

  @override
  String get appearance_theme_import_failed =>
      'Could not import that theme. Choose a VS Code colour theme saved as a .vsix, .json or .jsonc file.';

  @override
  String get render_widget_file_truncated =>
      'Only the start of this file was read, so the widget may be incomplete.';

  @override
  String get setup_beat_title => 'Setup';

  @override
  String setup_beat_use_name(String name) {
    return 'Use $name';
  }

  @override
  String get setup_beat_name_hint => 'What should Hermes call you?';

  @override
  String get setup_beat_on_computer =>
      'This step is done in Hermes on the computer it runs on. Continue keeps what is set up there.';

  @override
  String get setup_beat_not_waiting =>
      'This setup card is no longer waiting for an answer.';

  @override
  String get catalog_kind_plugin => 'Plugin';

  @override
  String get catalog_kind_skill => 'Skill';

  @override
  String get catalog_tier_official => 'Official';

  @override
  String get catalog_tier_verified => 'Verified';

  @override
  String get catalog_tier_community => 'Community';

  @override
  String get catalog_install => 'Install';

  @override
  String get catalog_waiting => 'Waiting for your choice';

  @override
  String get catalog_installed => 'Installed';

  @override
  String get catalog_installed_off => 'Installed, not turned on';

  @override
  String get catalog_skipped => 'Skipped';

  @override
  String get catalog_not_installed => 'Not installed';

  @override
  String catalog_target_profile(String profile) {
    return 'Installs into the $profile profile';
  }

  @override
  String catalog_source(String repo, String sha) {
    return '$repo at $sha';
  }

  @override
  String catalog_scan(String status, String summary) {
    return 'Security scan: $status. $summary';
  }

  @override
  String catalog_requires_hermes(String range) {
    return 'Needs Hermes $range';
  }

  @override
  String catalog_skill_ready(String name) {
    return 'Skill $name is ready to use';
  }

  @override
  String catalog_missing_env(String names) {
    return 'Still needs: $names';
  }

  @override
  String catalog_server_error(String name, String error) {
    return '$name did not connect: $error';
  }

  @override
  String get catalog_send_failed => 'Your choice was not sent. Try again.';

  @override
  String get attachment_video_speed => 'Playback speed';

  @override
  String get catalog_installing => 'Installing…';

  @override
  String get catalog_phase_downloading => 'Downloading…';

  @override
  String get catalog_phase_python_packages => 'Installing Python packages…';

  @override
  String get catalog_phase_loading_tools => 'Loading its tools…';

  @override
  String get setup_beat_send_failed => 'Your answer was not sent. Try again.';

  @override
  String catalog_tool_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tools',
      one: '1 tool',
    );
    return '$_temp0';
  }

  @override
  String get render_svg_not_drawn => 'This SVG was not drawn.';

  @override
  String get render_notes_directive => 'Notes directive';

  @override
  String get render_maths_source => 'Maths source';

  @override
  String get render_inline_maths_source => 'Inline maths source';

  @override
  String get render_sequence_outline => 'Sequence outline';

  @override
  String get render_diagram_outline => 'Diagram outline';

  @override
  String render_revision_of(int index, int count) {
    return 'Revision $index of $count';
  }

  @override
  String get render_previous_revision => 'Previous revision';

  @override
  String get render_next_revision => 'Next revision';

  @override
  String get render_show_rendered => 'Rendered';

  @override
  String get render_show_source => 'Source';

  @override
  String render_copied_file(String name) {
    return 'Copied $name';
  }

  @override
  String render_copy_file(String name) {
    return 'Copy $name';
  }

  @override
  String get render_artifact_too_long =>
      'This artefact is too long to show as a page here.';

  @override
  String get render_active_content_removed =>
      'Scripts, frames and external addresses were removed.';

  @override
  String render_widget_file(String file) {
    return 'Widget $file';
  }

  @override
  String get render_widget_runs_as_text =>
      'Runs as text in this chat. Scripts and external frames are removed.';

  @override
  String get render_load_widget => 'Load widget';

  @override
  String get render_not_html_widget => 'This file is not an HTML widget.';

  @override
  String get render_widget_sent => 'Sent to this chat';

  @override
  String get render_widget_not_sent => 'Not sent to this chat';

  @override
  String get render_widget_throttled => 'Wait a moment before sending again';

  @override
  String get render_widget_too_long => 'This request is too long to send';

  @override
  String get render_widget_no_gesture => 'Tap a control in the widget to send';

  @override
  String get render_widget_invalid => 'This request could not be sent';

  @override
  String get render_inspected_image => 'Inspected image';

  @override
  String get render_contributions => 'Contributions';

  @override
  String get render_contributions_intro =>
      'Only contributions compiled into Ares can add to a reply. Chat text cannot register one, and a grant applies to this connection only.';

  @override
  String render_grant_plugin(String name) {
    return 'Grant $name';
  }

  @override
  String render_revoke_plugin(String name) {
    return 'Revoke $name';
  }

  @override
  String render_plugin_slots(String directive) {
    return 'reply cards for ::$directive';
  }

  @override
  String get render_plugin_notes => 'Notes';

  @override
  String get catalog_scan_passed => 'passed';

  @override
  String get catalog_scan_warnings => 'found warnings';

  @override
  String get catalog_scan_failed => 'failed';

  @override
  String get deployment_token_label => 'Deployment token (optional)';

  @override
  String get deployment_token_helper =>
      'For Hermes Dashboard session tokens sent as X-Hermes-Session-Token. Not stored in plaintext preferences.';

  @override
  String get deployment_token_hint => 'Dashboard session token';

  @override
  String get custom_headers_label => 'Custom headers (optional)';

  @override
  String get custom_headers_helper =>
      'One per line, e.g. X-Custom: value. Forbidden headers are rejected.';

  @override
  String get custom_headers_hint => 'e.g. X-Custom-Header: value';

  @override
  String get desktop_tray_open => 'Open Ares';

  @override
  String get desktop_tray_new_chat => 'New chat';

  @override
  String get desktop_tray_quick_entry => 'Quick entry…';

  @override
  String get desktop_tray_pause_notifications => 'Pause notifications';

  @override
  String get desktop_tray_quit => 'Quit Ares';

  @override
  String get desktop_integration_title => 'Desktop integration';

  @override
  String get desktop_tray_setting => 'Show Ares in the tray or menu bar';

  @override
  String get desktop_tray_setting_help =>
      'Open Ares, start a chat, open quick entry, pause notifications or quit from the icon.';

  @override
  String get desktop_close_to_tray_setting =>
      'Keep running in the tray when the window closes';

  @override
  String get desktop_tray_unsupported =>
      'This desktop has no system tray Ares can use.';

  @override
  String get quick_entry_title => 'Quick entry';

  @override
  String get quick_entry_hint => 'Type a prompt for Ares…';

  @override
  String get quick_entry_submit => 'Put in composer';

  @override
  String get quick_entry_never_sends =>
      'Enter puts the text in the chat\'s composer. Nothing is sent until you press Send.';

  @override
  String get quick_entry_unavailable =>
      'Quick entry couldn\'t open. Try again.';

  @override
  String get desktop_hotkey_setting => 'Quick entry shortcut';

  @override
  String desktop_hotkey_help(String shortcut) {
    return 'Press $shortcut anywhere to open quick entry.';
  }

  @override
  String desktop_hotkey_conflict(String shortcut) {
    return 'Another app already uses $shortcut. Choose a different shortcut.';
  }

  @override
  String get desktop_hotkey_unsupported =>
      'This desktop does not let apps register a global shortcut (for example on Wayland).';

  @override
  String get desktop_hotkey_no_modifier => 'Include Cmd, Ctrl or Alt.';

  @override
  String get desktop_hotkey_super_key =>
      'The Windows or Super key is reserved for the system.';

  @override
  String get desktop_hotkey_reserved =>
      'The system already uses this shortcut.';

  @override
  String desktop_hotkey_in_app(String action) {
    return 'Ares already uses this shortcut for $action.';
  }

  @override
  String get desktop_hotkey_change => 'Change';

  @override
  String get desktop_hotkey_reset => 'Use default';

  @override
  String get capture_screen_action => 'Capture screen';

  @override
  String get capture_screen_help =>
      'Adds a screenshot to the message as a draft. Nothing is sent until you press Send.';

  @override
  String get capture_screen_unavailable =>
      'Screen capture isn\'t available on this desktop.';

  @override
  String get capture_screen_failed =>
      'Couldn\'t capture the screen. Try again.';

  @override
  String get capture_permission_title => 'Allow screen recording';

  @override
  String get capture_permission_body =>
      'To capture a window, Ares needs the Screen Recording permission. Turn on Ares in System Settings > Privacy & Security > Screen Recording, then try again.';

  @override
  String get capture_open_settings => 'Open System Settings';

  @override
  String get keep_awake_title => 'Keep computer awake';

  @override
  String get keep_awake_title_mobile => 'Keep screen on';

  @override
  String get keep_awake_mode_off => 'Off';

  @override
  String get keep_awake_mode_while_working => 'While working';

  @override
  String get keep_awake_mode_always => 'Always';

  @override
  String get keep_awake_off_help => 'Never block system sleep (default).';

  @override
  String get keep_awake_while_working_help =>
      'Prevent idle sleep only while an agent turn is running.';

  @override
  String get keep_awake_always_help =>
      'Prevent idle sleep while Ares is open on this device.';

  @override
  String get keep_awake_off_help_mobile =>
      'Let the screen turn off as usual (default).';

  @override
  String get keep_awake_while_working_help_mobile =>
      'Keep the screen on while an agent turn is running and Ares is open.';

  @override
  String get keep_awake_always_help_mobile =>
      'Keep the screen on while Ares is open.';

  @override
  String get ng_token_gateway_has_no_sign_in =>
      'This gateway has no sign-in, so it can\'t check a deployment token. Turn on dashboard authentication on the host (or update Hermes), then try again.';

  @override
  String get palette_open => 'App command palette';

  @override
  String get palette_no_matches => 'No matching actions';

  @override
  String get palette_filter_hint => 'Type to filter actions…';

  @override
  String get palette_keys_move => '↑↓ to move';

  @override
  String get palette_keys_run => 'Enter to run';

  @override
  String get palette_keys_close => 'Esc to close';

  @override
  String get palette_search_sessions => 'Search sessions';

  @override
  String get palette_scheduled_crons => 'Scheduled / Crons';

  @override
  String get palette_capabilities_skills => 'Capabilities & skills';

  @override
  String get palette_insights_usage => 'Insights & usage';

  @override
  String get palette_more_projects => 'More & projects';

  @override
  String get deeplink_chat_not_found =>
      'Chat not found in the list. It may not have loaded yet.';

  @override
  String get keyboard_shortcuts_title => 'Keyboard shortcuts';

  @override
  String get shortcuts_reset_all => 'Reset all';

  @override
  String get shortcuts_reset_to_default => 'Reset to default';

  @override
  String get shortcut_action_command_palette => 'Command palette';

  @override
  String get shortcut_action_new_chat => 'New chat';

  @override
  String get shortcut_action_search => 'Search';

  @override
  String get shortcut_action_settings => 'Settings';

  @override
  String shortcut_action_go_to_tab(int number) {
    return 'Go to tab $number';
  }

  @override
  String shortcuts_conflict(String first, String second, String chord) {
    return 'Conflict: \"$first\" and \"$second\" both use $chord. The custom shortcut keeps its default until you change one of them.';
  }

  @override
  String shortcuts_editor_title(String action) {
    return 'Shortcut: $action';
  }

  @override
  String get shortcuts_editor_help =>
      'Press a key combination, or choose modifiers and a key below:';

  @override
  String get shortcuts_editor_needs_modifier =>
      'Select at least Cmd/Meta, Ctrl or Alt so typing in the composer is unaffected.';

  @override
  String shortcuts_text_editing_warning(String chord) {
    return '$chord is a text editing shortcut (copy, paste, cut, undo, redo or select all). Binding it here takes it away from text fields.';
  }

  @override
  String shortcuts_text_editing_in_use(String action, String chord) {
    return '\"$action\" uses $chord, a text editing shortcut. Text fields lose it while it is bound here.';
  }

  @override
  String custom_headers_problem_format(int line) {
    return 'Line $line: expected \"Name: Value\"';
  }

  @override
  String custom_headers_problem_missing_name(int line) {
    return 'Line $line: missing header name';
  }

  @override
  String custom_headers_problem_invalid_name(int line, String name) {
    return 'Line $line: invalid header name \"$name\"';
  }

  @override
  String custom_headers_problem_reserved(int line, String name) {
    return 'Line $line: \"$name\" is reserved and cannot be passed through';
  }

  @override
  String custom_headers_problem_empty_value(int line) {
    return 'Line $line: empty header value';
  }

  @override
  String get ng_enter_a_deployment_token => 'Enter a deployment session token.';

  @override
  String get ng_custom_headers => 'Custom headers';

  @override
  String get ng_custom_headers_help =>
      'Extra HTTP headers for this gateway (Name: Value, one per line), sent on its REST and WebSocket calls. They are kept in the secure credential store. Authentication and hop-by-hop headers are rejected.';

  @override
  String get ng_use_a_deployment_token => 'Use a deployment session token';

  @override
  String get ng_sign_in_with_deployment_token =>
      'Sign in with deployment token';

  @override
  String get ng_signed_in_with_deployment_token =>
      'Signed in with the deployment token.';

  @override
  String get auto_speak_replies_title => 'Auto-read replies aloud';

  @override
  String get auto_speak_replies_subtitle =>
      'Reads each new reply aloud when a turn completes. Off by default; the per-chat spoken-replies toggle still applies.';

  @override
  String get ng_auto_read_replies_title => 'Auto-read replies';

  @override
  String get ng_auto_read_replies_subtitle =>
      'Reads each new reply aloud when a turn completes. Off by default.';

  @override
  String get barge_in_title => 'Barge in';

  @override
  String get barge_in_subtitle =>
      'Speak over a reply to cut it short. The microphone stays on while replies are read aloud.';

  @override
  String get barge_in_mic_live => 'Microphone on: speak to cut the reply short';

  @override
  String get ng_barge_in_title => 'Barge in';

  @override
  String get ng_barge_in_subtitle =>
      'Speak over a reply to cut it short. The microphone stays on while replies are read aloud.';

  @override
  String get ng_barge_in_mic_live =>
      'Microphone on: speak to cut the reply short';

  @override
  String get wake_word_title => 'Wake word';

  @override
  String get wake_word_subtitle =>
      'Hands-free wake detection on the gateway. Off by default; streams microphone audio only when client capture is active.';

  @override
  String wake_word_listening(String phrase) {
    return 'Listening for wake word \"$phrase\"';
  }

  @override
  String wake_word_paused(String phrase) {
    return 'Wake word \"$phrase\" — paused';
  }

  @override
  String wake_word_off(String phrase) {
    return 'Wake word \"$phrase\" — off';
  }

  @override
  String get wake_word_arming => 'Arming wake word…';

  @override
  String get wake_word_stop => 'Stop wake word';

  @override
  String get wake_word_rearm => 'Re-arm';

  @override
  String get wake_word_capture_mode => 'Capture mode';

  @override
  String get wake_word_capture_auto => 'Automatic';

  @override
  String get wake_word_capture_client => 'This device\'s microphone';

  @override
  String get wake_word_capture_local => 'Gateway host microphone';

  @override
  String get wake_word_capture_unavailable =>
      'This gateway doesn\'t let apps change the capture mode. Set wake_word.capture in the Hermes config on the gateway host.';

  @override
  String get wake_word_input_device => 'Input microphone';

  @override
  String get wake_word_default_device => 'System default';

  @override
  String get ng_wake_word_title => 'Wake word';

  @override
  String get ng_wake_word_subtitle =>
      'Hands-free wake detection on the gateway. Off by default.';

  @override
  String get voice_engine_title => 'Voice conversation engine';

  @override
  String get voice_engine_subtitle =>
      'Choose how hands-free voice conversations run on this gateway profile.';

  @override
  String get voice_engine_chained =>
      'Chained (speech-to-text → Hermes → speech)';

  @override
  String get voice_engine_chained_short => 'Chained';

  @override
  String get voice_engine_live => 'GPT-Live (real-time voice)';

  @override
  String get voice_engine_live_short => 'GPT-Live';

  @override
  String get voice_engine_live_needs_key =>
      'Configure an OpenAI API key on the gateway host to enable GPT-Live.';

  @override
  String voice_engine_fallback_chained(String reason) {
    return 'GPT-Live unavailable ($reason) — using Chained voice.';
  }

  @override
  String get voice_live_start => 'Start voice conversation';

  @override
  String get voice_live_stop => 'End voice conversation';

  @override
  String get voice_live_mute => 'Mute microphone';

  @override
  String get voice_live_unmute => 'Unmute microphone';

  @override
  String get voice_live_interrupt => 'Interrupt or respond now';

  @override
  String get voice_live_listening => 'Listening';

  @override
  String get voice_live_speaking => 'Speaking';

  @override
  String get voice_live_thinking => 'Thinking';

  @override
  String get voice_live_muted => 'Muted';

  @override
  String get voice_live_ended_connection_lost =>
      'The live voice session lost its connection.';

  @override
  String get voice_live_ended_closed =>
      'The live voice session was closed by the service.';

  @override
  String wake_word_other_profile(String profile) {
    return 'That wake word belongs to profile \"$profile\". Open a connection to that profile to answer it.';
  }

  @override
  String get wake_word_reason_disabled => 'Off — tap to enable';

  @override
  String get wake_word_reason_surface =>
      'Scoped to another surface (config wake_word.surface)';

  @override
  String get wake_word_reason_owned =>
      'Another surface owns the wake-word listener';

  @override
  String wake_word_reason_owned_by(String surface) {
    return 'Another surface ($surface) owns the wake-word listener';
  }

  @override
  String get wake_word_reason_unavailable =>
      'Wake word unavailable on this gateway';

  @override
  String get wake_word_reason_permission_denied =>
      'Microphone permission denied';

  @override
  String get wake_word_reason_permission_required =>
      'Microphone permission required — tap to enable';

  @override
  String get voice_live_not_enabled =>
      'GPT-Live is not enabled for this profile.';

  @override
  String get voice_live_not_available => 'GPT-Live is not available';

  @override
  String voice_live_start_failed(String error) {
    return 'GPT-Live could not start: $error';
  }

  @override
  String voice_direct_stt_timeout(String seconds, String provider) {
    return 'Transcription timed out after ${seconds}s ($provider did not answer)';
  }

  @override
  String voice_direct_stt_error(String provider, String status) {
    return '$provider STT error (HTTP $status)';
  }

  @override
  String voice_direct_tts_failed(String provider) {
    return '$provider TTS request failed';
  }

  @override
  String voice_direct_tts_error(String provider, String status) {
    return '$provider TTS error (HTTP $status)';
  }

  @override
  String ng_wake_status_listening(String phrase) {
    return 'Listening (\"$phrase\")';
  }

  @override
  String ng_wake_status_off(String phrase) {
    return 'Off (\"$phrase\")';
  }

  @override
  String ng_wire_setting_unavailable(Object setting) {
    return 'Changing $setting is not available on the shared gateway yet';
  }

  @override
  String ng_wire_method_unavailable(Object method) {
    return '$method is not available on the shared gateway yet';
  }

  @override
  String ng_wire_session_options_unsupported(Object options) {
    return 'Canonical gateway does not support explicit session options: $options';
  }

  @override
  String get ng_wire_prompt_stale =>
      'Prompt is stale or unavailable; reconnect before responding';

  @override
  String get ng_wire_revision_unavailable =>
      'Session revision unavailable; reopen the session before editing metadata';

  @override
  String get ng_wire_generation_unavailable =>
      'Session execution identity unavailable; reconnect before this command';

  @override
  String get ng_wire_message_not_saved =>
      'This message is not saved yet; wait for it to settle, then branch from it again';

  @override
  String get ng_wire_not_available => 'Not available on the shared gateway yet';

  @override
  String get edit_turn_title => 'Edit this prompt?';

  @override
  String get edit_turn_body =>
      'The prompt will be re-run from here. Later turns are archived.';

  @override
  String get edit_turn_send => 'Send';

  @override
  String get restore_turn_title => 'Restore to this checkpoint?';

  @override
  String get restore_turn_body =>
      'Everything after this prompt is removed from the conversation, and the prompt runs again from here.';

  @override
  String get restore_turn_confirm => 'Restore & rerun';

  @override
  String get edit_turn_later_turns_body =>
      'This will archive later turns from the conversation. Continue?';

  @override
  String get session_history => 'Session history';

  @override
  String get import_claude_or_codex => 'Import Claude or Codex';

  @override
  String get ng_session_history => 'Session history';

  @override
  String get ng_import_claude_or_codex => 'Import Claude or Codex';

  @override
  String get ng_edit_and_resend => 'Edit and resend';

  @override
  String get ng_restore_turn_confirm => 'Restore & rerun';

  @override
  String get rewind_target_unsaved =>
      'This message is not saved yet. Wait for it to settle, then edit it again.';

  @override
  String get rewind_turn_busy =>
      'The current reply has not stopped yet, so nothing was sent. Try again in a moment.';

  @override
  String get rewind_session_changed =>
      'This chat changed since it was opened here, so nothing was removed or sent. Reopen it, then try again.';

  @override
  String get history_lineage => 'Related chats';

  @override
  String get history_lineage_none =>
      'This chat has no forks or sibling branches.';

  @override
  String get history_lineage_unavailable =>
      'Related chats could not be read from this gateway.';

  @override
  String get history_lineage_parent => 'Parent';

  @override
  String get history_lineage_sibling => 'Sibling';

  @override
  String get history_lineage_fork => 'Fork';

  @override
  String get history_messages => 'Messages';

  @override
  String get history_messages_hint =>
      'Select a saved message to branch or rewind there.';

  @override
  String get history_messages_none => 'No saved messages yet.';

  @override
  String get history_messages_unavailable =>
      'The saved messages could not be read. Open this chat, then refresh.';

  @override
  String get history_role_user => 'You';

  @override
  String get history_role_assistant => 'Hermes';

  @override
  String get history_branch_here => 'Branch from here';

  @override
  String get history_rewind_here => 'Rewind to here';

  @override
  String get history_branch_title => 'Branch from this message';

  @override
  String get history_branch_body =>
      'This creates a new chat containing history through the selected message. The current chat stays as it is.';

  @override
  String get history_rewind_title => 'Rewind to this message';

  @override
  String get history_rewind_body =>
      'Messages from the selected one onward are removed from this chat. Files on the computer are not changed. Restoring those is a separate checkpoint action.';

  @override
  String history_branched(String id) {
    return 'Branched as $id';
  }

  @override
  String get history_open_chat => 'Open chat';

  @override
  String get history_mutate_unsupported =>
      'Branch and rewind need Hermes 0.23 or newer on this gateway.';

  @override
  String get history_checkpoints => 'Checkpoints';

  @override
  String get history_checkpoints_none =>
      'This session has no filesystem checkpoints.';

  @override
  String get history_checkpoints_unavailable =>
      'Checkpoints are not available on this gateway.';

  @override
  String get history_diff_none => 'No differences.';

  @override
  String get history_diff_loading => 'Loading the changes…';

  @override
  String get history_diff_failed =>
      'The changes could not be loaded, so this checkpoint cannot be restored yet.';

  @override
  String get history_restore_checkpoint => 'Restore checkpoint';

  @override
  String get history_restore_title => 'Restore this checkpoint';

  @override
  String get history_restore_body =>
      'The files the agent changed since this checkpoint go back to how they were then. Changes you made yourself are kept. Later chat messages can be removed as well. The conversation is not branched.';

  @override
  String get history_restore_body_all =>
      'Every file in the session folder goes back to this checkpoint, including changes you made yourself. Later chat messages can be removed as well. The conversation is not branched.';

  @override
  String get history_restore_own_edits => 'Also revert my own edits';

  @override
  String get history_restored => 'Checkpoint restored.';

  @override
  String history_restored_removed(int count) {
    return 'Checkpoint restored. $count chat messages were removed.';
  }

  @override
  String get history_export => 'Export';

  @override
  String get history_export_redact => 'Redact tokens';

  @override
  String get history_export_action => 'Export transcript';

  @override
  String get history_export_saved => 'Transcript saved.';

  @override
  String get history_export_unsupported =>
      'Export needs Hermes 0.23 or newer on this gateway.';

  @override
  String get history_import_unsupported =>
      'Claude and Codex import is not supported by this gateway.';

  @override
  String history_import_destination(String profile) {
    return 'Destination profile: $profile.';
  }

  @override
  String history_import_reading(String host, String profile, int count) {
    return 'Reading from $host · Destination profile: $profile. $count logs could not be read.';
  }

  @override
  String get history_import_all => 'All';

  @override
  String history_import_scan_failed(String reason) {
    return 'Could not scan host sessions: $reason';
  }

  @override
  String get history_import_none =>
      'No Claude Code or Codex sessions found on this host.';

  @override
  String get history_import_no_match => 'No matching host sessions.';

  @override
  String history_import_preview_failed(String reason) {
    return 'Could not preview session: $reason';
  }

  @override
  String get history_import_open => 'Open imported session';

  @override
  String get history_import_action => 'Import selected session';

  @override
  String get history_import_title => 'Import this session';

  @override
  String history_import_body(String profile) {
    return 'Copy this Claude or Codex session into profile \"$profile\" on this gateway.';
  }

  @override
  String history_import_body_existing(String profile) {
    return 'This session was already imported into \"$profile\". Continue with the existing copy.';
  }

  @override
  String history_imported(String id) {
    return 'Imported as $id';
  }

  @override
  String history_imported_already(String id) {
    return 'Already imported as $id';
  }

  @override
  String history_import_directory(String path) {
    return 'Directory: $path';
  }

  @override
  String history_import_preview_partial(int shown, int total) {
    return 'Preview shows $shown of $total.';
  }

  @override
  String history_failed(String reason) {
    return 'Could not finish: $reason';
  }

  @override
  String get history_error_unavailable =>
      'The gateway could not do this right now. Try again.';

  @override
  String get history_error_unsupported => 'This gateway does not support this.';

  @override
  String get history_error_denied => 'This gateway refused the request.';

  @override
  String get history_error_changed =>
      'This chat changed while this page was open. Refresh, then try again.';

  @override
  String get history_error_unbound =>
      'This chat is not open on the gateway. Open it, then try again.';

  @override
  String get history_error_invalid =>
      'The gateway sent an answer this app could not read.';

  @override
  String ng_dock_kanban(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kanban cards',
      one: '1 Kanban card',
    );
    return '$_temp0';
  }

  @override
  String ng_dock_kanban_done(int count) {
    return '$count done';
  }

  @override
  String get ng_show_kanban => 'Show Kanban cards';

  @override
  String get ng_hide_kanban => 'Hide Kanban cards';

  @override
  String get ng_kanban_status_triage => 'Triage';

  @override
  String get ng_kanban_status_todo => 'To do';

  @override
  String get ng_kanban_status_scheduled => 'Scheduled';

  @override
  String get ng_kanban_status_ready => 'Ready';

  @override
  String get ng_kanban_status_running => 'Running';

  @override
  String get ng_kanban_status_blocked => 'Blocked';

  @override
  String get ng_kanban_status_review => 'In review';

  @override
  String get ng_kanban_status_done => 'Done';

  @override
  String get ng_kanban_status_archived => 'Archived';

  @override
  String ng_kanban_open_card(String title) {
    return 'Open $title in Kanban';
  }

  @override
  String ng_kanban_show_all(int count) {
    return 'Show all $count';
  }

  @override
  String ng_kanban_this_chat(int count) {
    return 'This chat ($count)';
  }

  @override
  String get ng_kanban_close => 'Close Kanban';

  @override
  String get ng_kanban_block_no_dashboard =>
      'This connection has no dashboard access, so card status is not live and the board cannot open.';

  @override
  String get ng_kanban_block_unsupported =>
      'Kanban is not turned on for this gateway. Enable its kanban plugin to see live status and open the board.';

  @override
  String get ng_kanban_block_denied =>
      'Sign in to the dashboard to see live card status and open the board.';

  @override
  String get ng_kanban_block_insecure =>
      'Kanban needs HTTPS or a local connection, so card status is not live and the board cannot open.';

  @override
  String get ng_kanban_block_unreachable =>
      'Could not reach Kanban on this gateway. Card status may be out of date.';

  @override
  String get ng_kanban_block_stale =>
      'The connection changed. Reopen this chat to see live card status.';

  @override
  String get ng_bots_tab_roster => 'Roster';

  @override
  String get ng_bots_tab_rooms => 'Rooms';

  @override
  String get ng_bots_tab_screen => 'Screen';

  @override
  String get ng_bots_tab_routines => 'Routines';

  @override
  String ng_bots_rooms_load_failed(String error) {
    return 'Could not load rooms: $error';
  }

  @override
  String ng_bots_routines_load_failed(String error) {
    return 'Could not load routines: $error';
  }

  @override
  String ng_bots_desktop_failed(String error) {
    return 'Bot Desktop: $error';
  }

  @override
  String get ng_bots_install_not_started =>
      'The gateway did not start the install.';

  @override
  String ng_bots_install_failed_error(String error) {
    return 'Install failed: $error';
  }

  @override
  String get ng_bots_install_cancelled => 'The install was cancelled.';

  @override
  String get ng_bots_install_no_sudo =>
      'sudo is not available on the gateway host. Run the command above there, then refresh.';

  @override
  String ng_bots_install_exit_code(String code) {
    return 'The install failed (exit code $code).';
  }

  @override
  String ng_bots_install_done(String bot) {
    return 'Bot Desktop installed for $bot';
  }

  @override
  String get ng_bots_start_failed => 'Start failed';

  @override
  String ng_bots_stop_title(String bot) {
    return 'Stop Bot Desktop for $bot?';
  }

  @override
  String get ng_bots_stop_human_held =>
      'Someone is controlling this screen. Stopping it ends their session and closes everything open on it.';

  @override
  String get ng_bots_stop_body =>
      'Everything open on the bot’s screen is closed.';

  @override
  String get ng_bots_stop_refused => 'Stop refused';

  @override
  String get ng_bots_take_over_reason => 'Take over from Ares';

  @override
  String ng_bots_take_over_failed(String error) {
    return 'Take over failed: $error';
  }

  @override
  String ng_bots_force_hand_back_title(String bot) {
    return 'Give $bot’s screen back to the bot?';
  }

  @override
  String get ng_bots_force_hand_back_body =>
      'A person is holding this screen. If they are still using it, they lose control.';

  @override
  String get ng_bots_hand_back => 'Hand back';

  @override
  String get ng_bots_hand_back_failed => 'Hand back failed';

  @override
  String get ng_bots_adopt_title => 'Adopt the new sandbox image?';

  @override
  String ng_bots_adopt_body(String bot, String current, String target) {
    return '$bot moves from $current to $target. Its container is recreated on the next terminal call; anything kept only in the current container is lost.';
  }

  @override
  String get ng_bots_adopt_image => 'Adopt image';

  @override
  String get ng_bots_image_switch_failed => 'Image switch failed';

  @override
  String get ng_bots_keep_refused => 'Keep refused';

  @override
  String ng_bots_chat_open_failed(String error) {
    return 'Could not open Bot Chat: $error';
  }

  @override
  String ng_bots_title(String connection) {
    return 'Bots · $connection';
  }

  @override
  String get ng_bots_protocol_tooltip =>
      'Gateway injects the teammate-messaging protocol itself — no extra SOUL.md protocol is sent.';

  @override
  String ng_bots_unavailable(String reason) {
    return 'Bots unavailable ($reason)';
  }

  @override
  String get ng_bots_account_changed =>
      'The account changed. Reconnect or refresh.';

  @override
  String get ng_bots_try_refresh =>
      'Try refreshing. If it persists, the gateway may not support bots.';

  @override
  String get ng_bots_search => 'Search bots';

  @override
  String get ng_bots_none_found => 'No bots found.';

  @override
  String get ng_bots_no_model => 'no model';

  @override
  String ng_bots_skill_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count skills',
      one: '1 skill',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_bot_chat => 'Bot Chat';

  @override
  String ng_bots_install_id(String id, String protocol) {
    return 'Gateway reports install id $id · bot_mode_protocol: $protocol';
  }

  @override
  String get ng_bots_protocol_note =>
      'The gateway injects the teammate-messaging protocol when bot_mode_protocol is set. Handle: default→hermes, otherwise the profile name.';

  @override
  String get ng_bots_no_rooms => 'No rooms yet. Create one from your roster.';

  @override
  String ng_bots_member_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_room_disbanded => 'disbanded';

  @override
  String get ng_bots_room_adopted => 'adopted';

  @override
  String get ng_bots_rooms_gateway => 'Gateway rooms';

  @override
  String get ng_bots_rooms_desktop => 'Desktop-driven rooms';

  @override
  String ng_bots_rooms_gateway_body(String methods) {
    return 'Rooms are owned by the gateway. Methods: $methods.';
  }

  @override
  String get ng_bots_rooms_no_seat =>
      'Rooms may not be seated by this gateway (persistent process required).';

  @override
  String get ng_bots_rooms_fallback =>
      'Classic fallback: the Desktop drives the group rounds (not newly created here).';

  @override
  String get ng_bots_create_room => 'Create room';

  @override
  String get ng_bots_refresh_rooms => 'Refresh rooms';

  @override
  String get ng_bots_room_created => 'Room created';

  @override
  String ng_bots_room_refused(String reason) {
    return 'Room creation refused ($reason)';
  }

  @override
  String ng_bots_room_failed(String error) {
    return 'Room creation failed: $error';
  }

  @override
  String get ng_bots_bot => 'Bot';

  @override
  String get ng_bots_screen_unavailable => 'Screen status unavailable';

  @override
  String get ng_bots_screen_unavailable_body =>
      'Start the bot’s screen to watch its thumbnail, or take over to use it yourself.';

  @override
  String get ng_bots_take_over_note =>
      'Take over opens the live screen and gives you control of it. Control goes back to the bot when you close the live screen, leave this page or put the app in the background.';

  @override
  String get ng_bots_not_installed => 'Not installed';

  @override
  String get ng_bots_unsupported_host => 'Unsupported host';

  @override
  String ng_bots_pid(String pid) {
    return 'pid $pid';
  }

  @override
  String ng_bots_missing(String items) {
    return 'missing: $items';
  }

  @override
  String ng_bots_blocked(String reason) {
    return 'blocked: $reason';
  }

  @override
  String get ng_bots_no_switch => 'No sandbox image switch is pending.';

  @override
  String ng_bots_switch_image(String current, String target) {
    return 'switch image: $current → $target';
  }

  @override
  String get ng_bots_bot_in_control => 'the bot is in control';

  @override
  String get ng_bots_person_in_control => 'a person is in control';

  @override
  String get ng_bots_installing =>
      'Installing Bot Desktop on the gateway host…';

  @override
  String get ng_bots_install_unfinished => 'The install did not finish';

  @override
  String get ng_bots_install => 'Install';

  @override
  String get ng_bots_start => 'Start';

  @override
  String get ng_bots_take_over => 'Take over';

  @override
  String get ng_bots_keep_image => 'Keep current image';

  @override
  String ng_bots_missing_pieces(String items) {
    return 'The gateway reported missing pieces: $items';
  }

  @override
  String get ng_bots_install_missing => 'Install missing pieces';

  @override
  String get ng_bots_thumbnail_unavailable => 'Thumbnail unavailable';

  @override
  String get ng_bots_thumbnail_title => 'Screen thumbnail (live)';

  @override
  String get ng_bots_thumbnail_suppressed =>
      'Thumbnail suppressed while the screen is human-held.';

  @override
  String get ng_bots_thumbnail_pending => 'Thumbnail not available yet.';

  @override
  String ng_bots_routines_of(String bot) {
    return '$bot · routines';
  }

  @override
  String get ng_bots_add_routine => 'Add routine';

  @override
  String get ng_bots_no_routines => 'No routines for this bot.';

  @override
  String get ng_bots_routines_note =>
      'Routines are [bot:<name>]-tagged jobs owned by the bot’s profile store. Legacy delegated routines are force-paused on load.';

  @override
  String ng_bots_routine_last(String status) {
    return 'last: $status';
  }

  @override
  String ng_bots_routine_next(String time) {
    return 'next: $time';
  }

  @override
  String ng_bots_routine_error(String error) {
    return 'error: $error';
  }

  @override
  String ng_bots_remove_routine_title(String routine) {
    return 'Remove routine $routine?';
  }

  @override
  String ng_bots_remove_routine_body(String bot) {
    return 'The routine is deleted from $bot’s schedule. This cannot be undone.';
  }

  @override
  String ng_bots_routine_action_failed(String action, String error) {
    return '$action failed: $error';
  }

  @override
  String get ng_bots_not_connected => 'Not connected.';

  @override
  String ng_bots_add_failed(String error) {
    return 'Add failed: $error';
  }

  @override
  String get ng_bots_routine_added => 'Routine added';

  @override
  String get ng_bots_routine_enabled => 'enabled';

  @override
  String get ng_bots_routine_paused => 'paused';

  @override
  String ng_bots_path(String path) {
    return 'Path: $path';
  }

  @override
  String get ng_bots_chat_present => 'Bot Chat present';

  @override
  String get ng_bots_chat_missing => 'Bot Chat missing';

  @override
  String ng_bots_last_session(String preview) {
    return 'Last session: $preview';
  }

  @override
  String get ng_bots_open_chat => 'Open Bot Chat';

  @override
  String get ng_bots_desktop => 'Bot Desktop';

  @override
  String get ng_bots_room_name => 'Room name';

  @override
  String get ng_bots_select_member => 'Select at least one member.';

  @override
  String get ng_bots_sudo_title => 'Administrator password';

  @override
  String ng_bots_sudo_body(String bot) {
    return 'Installing Bot Desktop for $bot needs sudo on the gateway host. The password is sent only to that gateway, for this install, and is not saved.';
  }

  @override
  String get ng_bots_sudo_password => 'sudo password';

  @override
  String get ng_bots_new_routine => 'New routine';

  @override
  String get ng_bots_routine_title => 'Title';

  @override
  String get ng_bots_routine_instruction => 'Instruction';

  @override
  String get ng_bots_cron => 'Cron expression';

  @override
  String get ng_bots_interval => 'Interval';

  @override
  String get ng_bots_cron_help => '0 9 * * * runs every day at 09:00';

  @override
  String get ng_bots_every => 'Every';

  @override
  String get ng_bots_unit_minutes => 'minutes';

  @override
  String get ng_bots_unit_hours => 'hours';

  @override
  String get ng_bots_unit_days => 'days';

  @override
  String get ng_bots_stop_after => 'Stop after (runs)';

  @override
  String get ng_bots_stop_after_help => 'Leave blank to keep running';

  @override
  String get ng_bots_send_results => 'Send results to';

  @override
  String get ng_bots_run_history => 'Run history only';

  @override
  String get ng_bots_continuity => 'Continue from the previous run';

  @override
  String get ng_bots_account_changed_refresh =>
      'Account changed. Refresh before continuing.';

  @override
  String ng_bots_room_load_failed(String error) {
    return 'Could not load room: $error';
  }

  @override
  String ng_bots_send_failed(String error) {
    return 'Send failed: $error';
  }

  @override
  String ng_bots_stop_failed(String error) {
    return 'Stop failed: $error';
  }

  @override
  String get ng_bots_stop_room => 'Stop room';

  @override
  String get ng_bots_send_message => 'Send a message';

  @override
  String get ng_bots_room_hint =>
      'Message the room (mention members with @handle)';

  @override
  String get ng_bots_history => 'History';

  @override
  String ng_bots_revision(String revision) {
    return 'revision $revision';
  }

  @override
  String ng_bots_last_error(String error) {
    return 'last error: $error';
  }

  @override
  String get ng_bots_members => 'Members';

  @override
  String get ng_bots_room_context => 'Room context';

  @override
  String ng_bots_purpose(String purpose) {
    return 'Purpose: $purpose';
  }

  @override
  String ng_bots_notes(String notes) {
    return 'Notes: $notes';
  }

  @override
  String ng_bots_routing(String routing) {
    return 'Routing: $routing';
  }

  @override
  String ng_bots_lead(String member) {
    return 'lead $member';
  }

  @override
  String get ng_bots_viewer_you_control =>
      'You control this screen. The bot waits until you hand it back.';

  @override
  String get ng_bots_viewer_handed_back => 'Control is back with the bot.';

  @override
  String get ng_bots_viewer_background =>
      'Control went back to the bot because the app left the foreground.';

  @override
  String get ng_bots_viewer_taken =>
      'Someone else took control of this screen.';

  @override
  String get ng_bots_viewer_lost =>
      'The live view was lost, so control went back to the bot.';

  @override
  String ng_bots_viewer_title(String bot) {
    return 'Bot Desktop · $bot';
  }

  @override
  String get ng_bots_viewer_type_hint => 'Type on the bot’s screen';

  @override
  String get ng_bots_viewer_type => 'Type it';

  @override
  String get ng_bots_viewer_enter => 'Enter';

  @override
  String get ng_bots_viewer_backspace => 'Backspace';

  @override
  String get ng_more_kanban => 'Kanban';

  @override
  String get ng_more_kanban_subtitle =>
      'Boards, task dependencies, worker assignment and logs';

  @override
  String get ng_more_bots => 'Bots';

  @override
  String get ng_more_bots_subtitle => 'Roster, rooms, routines and Bot Desktop';

  @override
  String get ng_slash_kanban => 'Open the Kanban board';

  @override
  String get ng_slash_bots => 'Open your bots';

  @override
  String ng_board_card_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cards',
      one: '1 card',
    );
    return '$_temp0';
  }

  @override
  String ng_board_event_toast(String task, String event) {
    return 'Kanban $task: $event';
  }

  @override
  String get ng_board_task => 'task';

  @override
  String ng_board_refused_http(String status) {
    return 'Action refused (HTTP $status).';
  }

  @override
  String get ng_board_err_unsupported =>
      'Kanban plugin is not enabled on this gateway.';

  @override
  String get ng_board_err_denied =>
      'Sign-in or permission required on this gateway.';

  @override
  String get ng_board_err_stale =>
      'Gateway owner changed. Refresh before continuing.';

  @override
  String get ng_board_err_insecure =>
      'HTTPS (or loopback) is required for Kanban workspace operations.';

  @override
  String get ng_board_err_unreachable =>
      'Could not reach the Kanban service on this gateway.';

  @override
  String get ng_board_err_failed => 'Operation failed. Refresh and try again.';

  @override
  String ng_board_block_title(String task) {
    return 'Block $task';
  }

  @override
  String get ng_board_block_reason => 'Blocker reason';

  @override
  String get ng_board_block_hint => 'What is blocking this card?';

  @override
  String ng_board_review_title(String task) {
    return 'Request review for $task';
  }

  @override
  String get ng_board_review_summary => 'Review summary';

  @override
  String get ng_board_review_hint => 'What was implemented and verified?';

  @override
  String ng_board_move_title(String cards, String column) {
    return 'Move $cards to $column?';
  }

  @override
  String ng_board_move_body(String board) {
    return 'Every selected card on $board changes column. A card that is running stops running.';
  }

  @override
  String get ng_board_move => 'Move';

  @override
  String ng_board_moved(String column) {
    return 'Moved cards to $column';
  }

  @override
  String ng_board_unassign_title(String cards) {
    return 'Unassign $cards?';
  }

  @override
  String ng_board_assign_title(String cards, String profile) {
    return 'Assign $cards to @$profile?';
  }

  @override
  String get ng_board_assign_body =>
      'Cards that are running are reclaimed first: their workers are stopped.';

  @override
  String get ng_board_unassign => 'Unassign';

  @override
  String get ng_board_assign => 'Assign';

  @override
  String get ng_board_unassigned_done => 'Unassigned selected cards';

  @override
  String ng_board_assigned_done(String profile) {
    return 'Assigned @$profile';
  }

  @override
  String ng_board_archive_title(String cards) {
    return 'Archive $cards?';
  }

  @override
  String ng_board_archive_body(String board) {
    return 'Archived cards leave $board. Turn on Archived to see them again.';
  }

  @override
  String get ng_board_archived_done => 'Archived selected cards';

  @override
  String ng_board_delete_title(String cards) {
    return 'Delete $cards?';
  }

  @override
  String ng_board_delete_body(String board) {
    return 'This permanently deletes the selected cards from $board.';
  }

  @override
  String ng_board_deleted(String cards) {
    return 'Deleted $cards.';
  }

  @override
  String ng_board_partial_failure(String failed, String total, String reason) {
    return '$failed of $total failed: $reason';
  }

  @override
  String get ng_board_refused => 'refused';

  @override
  String ng_board_dispatched(
    String spawned,
    String promoted,
    String reclaimed,
  ) {
    return 'Dispatched: $spawned spawned, $promoted promoted, $reclaimed reclaimed.';
  }

  @override
  String ng_board_board_archived(String board) {
    return 'Archived board $board';
  }

  @override
  String ng_board_board_archived_to(String path) {
    return 'Archived to $path';
  }

  @override
  String ng_board_exported(String board, String archive) {
    return 'Exported $board to $archive';
  }

  @override
  String ng_board_imported(String board, String warnings) {
    return 'Imported board $board$warnings';
  }

  @override
  String ng_board_created(String task) {
    return 'Created $task';
  }

  @override
  String get ng_board_orchestration_saved => 'Saved Kanban orchestration';

  @override
  String get ng_board_auto_describe_unavailable => 'Auto-describe unavailable';

  @override
  String ng_board_description_updated(String profile) {
    return 'Updated @$profile description';
  }

  @override
  String ng_board_title(String board) {
    return 'Kanban · $board';
  }

  @override
  String ng_board_active(String count) {
    return '$count active';
  }

  @override
  String get ng_board_dispatch => 'Dispatch ready tasks now';

  @override
  String get ng_board_orchestration => 'Orchestration & workers';

  @override
  String get ng_board_new_task => 'New task';

  @override
  String get ng_board_enable_plugin =>
      'Enable the bundled \"kanban\" plugin in Capabilities → Plugins on this gateway to activate its board router.';

  @override
  String get ng_board_filter => 'Filter tasks…';

  @override
  String get ng_board_all_assignees => 'All assignees';

  @override
  String get ng_board_unassigned => 'Unassigned';

  @override
  String get ng_board_running_by_profile => 'Running by profile';

  @override
  String get ng_board_select => 'Select';

  @override
  String ng_board_selected_chip(String count) {
    return 'Selected ($count)';
  }

  @override
  String get ng_board_locked_column => 'Managed column — drag drop disabled';

  @override
  String ng_board_add_to(String column) {
    return 'Add to $column';
  }

  @override
  String ng_board_collapse(String column) {
    return 'Collapse $column';
  }

  @override
  String ng_board_column_empty(String column) {
    return 'No $column tasks';
  }

  @override
  String get ng_board_drop_here => 'Drop or + task';

  @override
  String get ng_board_card_actions => 'Card actions';

  @override
  String get ng_board_open_details => 'Open details';

  @override
  String get ng_board_select_card => 'Select card';

  @override
  String ng_board_move_to(String column) {
    return 'Move to $column';
  }

  @override
  String get ng_board_parked => 'Parked';

  @override
  String ng_board_blocked_by(String count) {
    return 'Blocked by $count';
  }

  @override
  String get ng_board_goal_loop => 'Goal loop';

  @override
  String ng_board_selected(String count) {
    return '$count selected';
  }

  @override
  String get ng_board_move_menu => 'Move…';

  @override
  String get ng_board_assign_menu => 'Assign…';

  @override
  String get ng_board_new_board_title => 'New Kanban board';

  @override
  String get ng_board_slug => 'Slug (lowercase, e.g. release-v5)';

  @override
  String get ng_board_display_name => 'Display name';

  @override
  String get ng_board_linked_project => 'Linked project (optional)';

  @override
  String get ng_board_none => 'None';

  @override
  String get ng_board_default_workdir => 'Default workdir on host (optional)';

  @override
  String get ng_board_import_title => 'Import board archive';

  @override
  String get ng_board_import_path => 'Host .tar.gz archive path';

  @override
  String get ng_board_import => 'Import';

  @override
  String ng_board_edit_board(String board) {
    return 'Edit $board';
  }

  @override
  String get ng_board_name => 'Name';

  @override
  String get ng_board_description => 'Description';

  @override
  String get ng_board_workdir_clear => 'Default workdir (blank clears)';

  @override
  String get ng_board_boards => 'Kanban boards';

  @override
  String get ng_board_new_board => 'New board';

  @override
  String get ng_board_search_boards => 'Search boards…';

  @override
  String get ng_board_unpin => 'Unpin tab';

  @override
  String get ng_board_pin => 'Pin tab';

  @override
  String ng_board_archive_board_title(String board) {
    return 'Archive board $board?';
  }

  @override
  String ng_board_archive_board_body(String cards) {
    return 'The board and its $cards leave the board list. The gateway keeps an archive on its host.';
  }

  @override
  String get ng_board_edit_metadata => 'Edit metadata';

  @override
  String get ng_board_export => 'Export .tar.gz on host';

  @override
  String get ng_board_move_pin_left => 'Move pinned tab left';

  @override
  String get ng_board_archive_board => 'Archive board';

  @override
  String get ng_board_new_task_title => 'New Kanban task';

  @override
  String get ng_board_title_required => 'Title *';

  @override
  String get ng_board_spec => 'Spec & acceptance criteria';

  @override
  String get ng_board_estimate => 'Estimate';

  @override
  String ng_board_estimate_draft(String complexity, String tokens) {
    return 'Complexity $complexity (~$tokens tok — token estimate only, not a dollar-cost claim)';
  }

  @override
  String get ng_board_estimate_unavailable => 'Estimate unavailable';

  @override
  String get ng_board_initial_column => 'Initial column';

  @override
  String get ng_board_worker_assignee => 'Worker assignee';

  @override
  String get ng_board_parked_unassigned => 'Parked (unassigned)';

  @override
  String get ng_board_priority => 'Priority';

  @override
  String get ng_board_workspace => 'Workspace';

  @override
  String get ng_board_scratch => 'Scratch';

  @override
  String get ng_board_worktree => 'Git worktree';

  @override
  String get ng_board_shared_dir => 'Shared dir';

  @override
  String get ng_board_workspace_path => 'Host workspace path';

  @override
  String get ng_board_parent => 'Parent dependency (optional)';

  @override
  String get ng_board_skills => 'Pinned skills (comma-separated, optional)';

  @override
  String get ng_board_provider_override => 'Provider override';

  @override
  String get ng_board_model_override => 'Model override';

  @override
  String get ng_board_reasoning => 'Reasoning effort';

  @override
  String get ng_board_profile_default => 'Profile default';

  @override
  String get ng_board_xhigh => 'X-High';

  @override
  String get ng_board_goal_mode => 'Goal loop mode';

  @override
  String get ng_board_goal_turns => 'Goal max turns (blank = default)';

  @override
  String get ng_board_create_task => 'Create task';

  @override
  String get ng_board_orchestration_title => 'Orchestration & worker profiles';

  @override
  String ng_board_orchestrator(String profile) {
    return 'Orchestrator profile (resolved: $profile)';
  }

  @override
  String get ng_board_inherit_default => 'Inherit active default';

  @override
  String ng_board_default_assignee(String profile) {
    return 'Default assignee (resolved: $profile)';
  }

  @override
  String get ng_board_auto_decompose => 'Auto-decompose triage cards';

  @override
  String get ng_board_auto_decompose_help =>
      'Uses the configured kanban_decomposer model on triage tasks';

  @override
  String get ng_board_save_orchestration => 'Save orchestration';

  @override
  String get ng_board_worker_descriptions =>
      'Worker specialization descriptions';

  @override
  String ng_board_worker_label(String profile, String model, String skills) {
    return '@$profile ($model · $skills)';
  }

  @override
  String get ng_board_default_model => 'default model';

  @override
  String get ng_board_save_description => 'Save description';

  @override
  String get ng_board_auto_describe => 'Auto-describe from skills & persona';

  @override
  String get ng_board_manual_block => 'Manual operator block';

  @override
  String get ng_board_requested_review => 'Requested review';

  @override
  String ng_board_requeue_title(String task) {
    return 'Requeue $task?';
  }

  @override
  String get ng_board_requeue_body =>
      'A worker running this card is stopped and the card goes back to the queue.';

  @override
  String get ng_board_requeue => 'Requeue';

  @override
  String ng_board_reassign_title(String task, String profile) {
    return 'Reassign $task to @$profile?';
  }

  @override
  String get ng_board_reassign_body =>
      'This card is running: its worker is stopped first.';

  @override
  String get ng_board_reassign => 'Reassign';

  @override
  String ng_board_saved_task(String task) {
    return 'Saved task $task';
  }

  @override
  String get ng_board_commented_requeued => 'Posted comment and requeued task';

  @override
  String get ng_board_commented => 'Posted comment';

  @override
  String ng_board_requeued(String task) {
    return 'Requeued $task';
  }

  @override
  String get ng_board_decompose_failed => 'Decompose failed.';

  @override
  String ng_board_decompose_failed_reason(String reason) {
    return 'Decompose failed: $reason';
  }

  @override
  String ng_board_decomposed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Decomposed into $count child tasks',
      one: 'Decomposed into 1 child task',
    );
    return '$_temp0';
  }

  @override
  String get ng_board_no_children => 'No child tasks were created.';

  @override
  String ng_board_no_children_reason(String reason) {
    return 'No child tasks were created: $reason';
  }

  @override
  String ng_board_uploaded(String file) {
    return 'Uploaded $file';
  }

  @override
  String ng_board_linked_parent(String task) {
    return 'Linked parent $task';
  }

  @override
  String ng_board_unlinked_parent(String task) {
    return 'Removed parent link $task';
  }

  @override
  String get ng_board_task_load_failed => 'Unable to load task';

  @override
  String get ng_board_refresh_task => 'Refresh task';

  @override
  String get ng_board_tab_overview => 'Overview';

  @override
  String get ng_board_tab_comments => 'Comments & Links';

  @override
  String get ng_board_tab_runs => 'Runs & Log';

  @override
  String get ng_board_tab_events => 'Events';

  @override
  String get ng_board_decompose => 'Decompose';

  @override
  String get ng_board_attach => 'Attach file';

  @override
  String ng_board_estimate_task(
    String complexity,
    String tokens,
    String rationale,
  ) {
    return 'Estimate: $complexity · ~$tokens tokens ($rationale) — not a dollar-cost claim.';
  }

  @override
  String get ng_board_no_rationale => 'no rationale';

  @override
  String get ng_board_status => 'Status';

  @override
  String get ng_board_assignee => 'Assignee';

  @override
  String get ng_board_title_label => 'Title';

  @override
  String get ng_board_body => 'Body / specification';

  @override
  String get ng_board_save_changes => 'Save changes';

  @override
  String get ng_board_clear_model => 'Clear model override';

  @override
  String ng_board_blocked_reason(String reason) {
    return 'Blocked reason: $reason';
  }

  @override
  String ng_board_result(String result) {
    return 'Result: $result';
  }

  @override
  String ng_board_parents(String count) {
    return 'Blocked by (parents · $count)';
  }

  @override
  String get ng_board_add_parent => '+ Add parent';

  @override
  String ng_board_children(String count) {
    return 'Blocks (children · $count)';
  }

  @override
  String ng_board_attachments(String count) {
    return 'Attachments ($count)';
  }

  @override
  String get ng_board_worker => 'worker';

  @override
  String ng_board_comments(String count) {
    return 'Comments ($count)';
  }

  @override
  String get ng_board_comment_hint => 'Add comment / worker guidance';

  @override
  String get ng_board_post_comment => 'Post comment';

  @override
  String get ng_board_comment_requeue => 'Comment & requeue';

  @override
  String ng_board_runs(String count) {
    return 'Runs ($count)';
  }

  @override
  String get ng_board_no_runs => 'No worker runs recorded yet.';

  @override
  String ng_board_run_error(String error) {
    return 'Error: $error';
  }

  @override
  String ng_board_log_tail_truncated(String bytes) {
    return 'Worker log tail ($bytes B, truncated)';
  }

  @override
  String ng_board_log_tail(String bytes) {
    return 'Worker log tail ($bytes B)';
  }

  @override
  String get ng_board_refresh_log => 'Refresh log';

  @override
  String get ng_board_no_log => 'No worker log output.';

  @override
  String get ng_board_no_events => 'No events recorded.';

  @override
  String get ng_bots_room_unknown => 'unknown';

  @override
  String get ng_bots_room_blocked => 'blocked';

  @override
  String get ng_bots_room_working => 'working';

  @override
  String get ng_bots_room_running => 'running';

  @override
  String get ng_bots_room_idle => 'idle';

  @override
  String ng_board_run_title(String id, String profile, String outcome) {
    return 'Run #$id · @$profile · $outcome';
  }

  @override
  String get ng_bots_new_bot => 'New bot';

  @override
  String get ng_bots_new_bot_hint =>
      'A named teammate with its own memory, skills, and chat. It can message your other agents.';

  @override
  String get ng_bots_field_name => 'Name';

  @override
  String get ng_bots_field_title => 'Title';

  @override
  String get ng_bots_field_description => 'Description';

  @override
  String get ng_bots_description_hint => 'What should this bot help with?';

  @override
  String get ng_bots_name_invalid =>
      'Use lowercase letters, numbers, hyphens or underscores, starting with a letter or number (64 characters at most).';

  @override
  String ng_bots_name_taken(String name) {
    return 'An agent named “$name” already exists.';
  }

  @override
  String ng_bots_profile_id(String id) {
    return 'Profile id: $id';
  }

  @override
  String get ng_bots_advanced => 'Advanced — model, skills, toolsets, SOUL.md';

  @override
  String get ng_bots_clone_from => 'Clone from profile';

  @override
  String get ng_bots_clone_main => 'Main profile (default)';

  @override
  String get ng_bots_fresh_profile => 'Fresh profile (bundled skills)';

  @override
  String get ng_bots_create_empty => 'Create empty (skip bundled skills)';

  @override
  String get ng_bots_share_keys =>
      'Share keys & accounts with the main profile';

  @override
  String get ng_bots_provider => 'Provider';

  @override
  String get ng_bots_model => 'Model';

  @override
  String get ng_bots_model_pair => 'Enter both a provider and a model.';

  @override
  String get ng_bots_soul =>
      'SOUL.md (optional — replaces the generated persona)';

  @override
  String get ng_bots_soul_edit => 'SOUL.md';

  @override
  String get ng_bots_creating => 'Creating…';

  @override
  String get ng_bots_create_bot => 'Create bot';

  @override
  String ng_bots_created(String name) {
    return 'Bot “$name” created';
  }

  @override
  String get ng_bots_look_failed =>
      'Its look was not saved on the gateway; set it in Edit profile.';

  @override
  String ng_bots_request_failed(String reason) {
    return 'The gateway did not take it ($reason).';
  }

  @override
  String get ng_bots_avatar_shape => 'Shape';

  @override
  String ng_bots_avatar_shape_n(int n) {
    return 'Shape $n';
  }

  @override
  String get ng_bots_avatar_colour => 'Colour';

  @override
  String ng_bots_avatar_colour_n(int n) {
    return 'Colour $n';
  }

  @override
  String get ng_bots_avatar_match_name => 'Match the name';

  @override
  String get ng_bots_avatar_upload => 'Choose an image…';

  @override
  String get ng_bots_avatar_remove => 'Remove image — use shape';

  @override
  String get ng_bots_avatar_too_large => 'Image too large (max 15 MB).';

  @override
  String get ng_bots_avatar_unreadable => 'That image could not be read.';

  @override
  String get ng_bots_edit_profile => 'Edit profile';

  @override
  String ng_bots_edit_description(String name, String profile) {
    return 'Appearance and role for $name ($profile).';
  }

  @override
  String ng_bots_advanced_failed(String reason) {
    return 'Could not load the profile settings ($reason).';
  }

  @override
  String get ng_bots_skills => 'Skills';

  @override
  String get ng_bots_toolsets => 'Toolsets';

  @override
  String get ng_bots_toolsets_hint =>
      'Leaving all (or none) checked keeps the default toolset behaviour.';

  @override
  String get ng_bots_mcp_servers => 'MCP servers';

  @override
  String get ng_bots_saving => 'Saving…';

  @override
  String get ng_bots_confirm_changes_title => 'Save these changes?';

  @override
  String get ng_bots_change_remove_image => 'Remove the bot’s picture';

  @override
  String get ng_bots_change_soul => 'Replace its SOUL.md';

  @override
  String ng_bots_change_turn_off(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Turn off $count skills, toolsets or MCP servers',
      one: 'Turn off 1 skill, toolset or MCP server',
    );
    return '$_temp0';
  }

  @override
  String ng_bots_updated(String name) {
    return '$name updated';
  }

  @override
  String ng_bots_sections_failed(String sections) {
    return 'Some sections failed: $sections';
  }

  @override
  String get ng_bots_model_confirm_title => 'Switch the model?';

  @override
  String get ng_bots_model_confirm_ok => 'Switch';

  @override
  String get ng_bots_model_not_switched => 'The model was not switched.';

  @override
  String get ng_bots_section_new => 'New section';

  @override
  String get ng_bots_section_new_ellipsis => 'New section…';

  @override
  String get ng_bots_section_name => 'Section name';

  @override
  String get ng_bots_section_name_hint => 'e.g. Clients';

  @override
  String get ng_bots_section_create => 'Create';

  @override
  String get ng_bots_section_rename => 'Rename section';

  @override
  String get ng_bots_section_delete => 'Delete section';

  @override
  String get ng_bots_section_move_up => 'Move up';

  @override
  String get ng_bots_section_move_down => 'Move down';

  @override
  String get ng_bots_section_unassigned => 'Unassigned';

  @override
  String ng_bots_section_options(String name) {
    return '$name section options';
  }

  @override
  String get ng_bots_section_empty =>
      'No bots here yet. Use Move to section on a bot.';

  @override
  String get ng_bots_section_move_to => 'Move to section';

  @override
  String get ng_bots_section_remove => 'Remove from section';

  @override
  String ng_bots_section_deleted(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Deleted “$name” — $count bots moved to Unassigned',
      one: 'Deleted “$name” — 1 bot moved to Unassigned',
      zero: 'Deleted “$name”',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_undo => 'Undo';

  @override
  String ng_bots_section_move_failed(String reason) {
    return 'Could not move the bot ($reason).';
  }

  @override
  String ng_bots_bot_actions(String name) {
    return '$name actions';
  }

  @override
  String ng_bots_section_toggle(String name) {
    return 'Show or hide $name';
  }

  @override
  String
  get release_core_transcript_reader_this_passage_is_no_longer_in_the_loaded =>
      'This passage is no longer in the loaded window.';

  @override
  String get release_core_transcript_reader_loaded_prompts => 'Loaded prompts';

  @override
  String get release_core_transcript_reader_jump_to_latest => 'Jump to latest';

  @override
  String get release_core_transcript_reader_no_prompts_loaded =>
      'No prompts loaded';

  @override
  String get release_core_transcript_reader_find_in_loaded_messages =>
      'Find in loaded messages';

  @override
  String get release_core_transcript_reader_previous_match => 'Previous match';

  @override
  String get release_core_transcript_reader_next_match => 'Next match';

  @override
  String get release_core_transcript_reader_prompt_timeline =>
      'Prompt timeline';

  @override
  String get release_core_transcript_reader_close_find => 'Close find';

  @override
  String get release_core_session_organisation_organise_chats =>
      'Organise chats';

  @override
  String get release_core_session_organisation_show_model_and_usage =>
      'Show model and usage';

  @override
  String
  get release_core_session_files_view_connection_changed_reopen_files_on_the_new_connection =>
      'Connection changed. Reopen files on the new connection.';

  @override
  String
  get release_core_session_files_view_the_connection_or_session_changed_reopen_this_pane =>
      'The connection or session changed. Reopen this pane.';

  @override
  String
  get release_core_session_files_view_no_verified_host_working_directory_for_this_session =>
      'No verified host working directory for this session.';

  @override
  String
  get release_core_session_files_view_the_gateway_denied_this_operation =>
      'The gateway denied this operation.';

  @override
  String
  get release_core_session_files_view_this_gateway_does_not_support_this_operation =>
      'This gateway does not support this operation.';

  @override
  String
  get release_core_session_files_view_the_file_owner_or_working_directory_changed_reload =>
      'The file, owner or working directory changed. Reload and review.';

  @override
  String
  get release_core_session_files_view_the_gateway_returned_an_unsafe_path_or_invalid =>
      'The gateway returned an unsafe path or invalid file response.';

  @override
  String
  get release_core_session_files_view_workspace_access_requires_a_secure_gateway_connection =>
      'Workspace access requires a secure gateway connection.';

  @override
  String
  get release_core_session_files_view_gateway_unavailable_refresh_to_check_the_current_state =>
      'Gateway unavailable. Refresh to check the current state.';

  @override
  String
  get release_core_session_files_view_gateway_operation_could_not_be_confirmed =>
      'Gateway operation could not be confirmed.';

  @override
  String get release_core_session_files_view_git_status_unavailable =>
      'Git status unavailable.';

  @override
  String
  get release_core_session_files_view_change_this_chat_s_working_directory =>
      'Change this chat’s working directory?';

  @override
  String get release_core_session_files_view_absolute_gateway_directory =>
      'Absolute gateway directory';

  @override
  String get release_core_session_files_view_change_directory =>
      'Change directory';

  @override
  String get release_core_session_files_view_replace_gateway_file =>
      'Replace gateway file?';

  @override
  String
  release_core_session_files_view_only_if_the_file_still_matches_the_version(
    String path,
  ) {
    return '$path\n\nOnly if the file still matches the version you reviewed. A compatible host retains the displaced file for recovery.';
  }

  @override
  String get release_core_session_files_view_save_changes => 'Save changes';

  @override
  String
  get release_core_session_files_view_saved_and_verified_on_the_gateway =>
      'Saved and verified on the gateway.';

  @override
  String
  get release_core_session_files_view_guarded_saving_is_unavailable_on_this_gateway_your =>
      'Guarded saving is unavailable on this gateway. Your draft is still here.';

  @override
  String
  release_core_session_files_view_save_was_not_confirmed_your_draft_is_still(
    String reason,
  ) {
    return '$reason Save was not confirmed. Your draft is still here.';
  }

  @override
  String get release_core_session_files_view_review_current_gateway_version =>
      'Review current gateway version';

  @override
  String get release_core_session_files_view_discard_draft_and_reload =>
      'Discard draft and reload';

  @override
  String get release_core_session_files_view_keep_draft_against_this_version =>
      'Keep draft against this version';

  @override
  String get release_core_session_files_view_discard_unsaved_edits =>
      'Discard unsaved edits?';

  @override
  String get release_core_session_files_view_keep_editing => 'Keep editing';

  @override
  String get release_core_session_files_view_discard_edits => 'Discard edits';

  @override
  String get release_core_session_files_view_remote_working_directory =>
      'Remote working directory';

  @override
  String get release_core_session_files_view_change_working_directory =>
      'Change working directory';

  @override
  String get release_core_session_files_view_show_ignored_files =>
      'Show ignored files';

  @override
  String
  get release_core_session_files_view_gateway_does_not_report_ignored_status =>
      'Gateway does not report ignored status.';

  @override
  String get release_core_session_files_view_no_visible_entries =>
      'No visible entries';

  @override
  String get release_core_session_files_view_changed => 'Changed';

  @override
  String get release_core_session_files_view_ignored => 'Ignored';

  @override
  String release_core_session_files_view_actions_for(String name) {
    return 'Actions for $name';
  }

  @override
  String get release_core_session_files_view_copy_relative_path =>
      'Copy relative path';

  @override
  String get release_core_session_files_view_copy_gateway_path =>
      'Copy gateway path';

  @override
  String get release_core_session_files_view_attach_folder_reference =>
      'Attach folder reference';

  @override
  String get release_core_session_files_view_attach_file_reference =>
      'Attach file reference';

  @override
  String
  get release_core_session_files_view_preview_truncated_editing_disabled =>
      'Preview truncated — editing disabled.';

  @override
  String get release_core_session_files_view_select_lines => 'Select lines';

  @override
  String get release_core_session_files_view_review_gateway_version =>
      'Review gateway version';

  @override
  String get release_core_session_files_view_attach_selected_lines =>
      'Attach selected lines';

  @override
  String get release_core_session_files_view_binary_file_no_text_preview =>
      'Binary file — no text preview.';

  @override
  String get release_core_session_files_view_file_source => 'File source';

  @override
  String get release_core_session_files_view_close_session_files =>
      'Close session files';

  @override
  String get release_core_session_files_view_back_to_tree => 'Back to tree';

  @override
  String get release_core_session_files_view_session_files => 'Session files';

  @override
  String get release_core_session_files_view_git_review => 'Git review';

  @override
  String get release_core_session_files_view_refresh_tree => 'Refresh tree';

  @override
  String
  get release_core_gateway_queue_screen_this_connection_changed_reopen_its_chat =>
      'This connection changed. Reopen its chat.';

  @override
  String
  get release_core_gateway_queue_screen_disconnected_reconnect_the_chat_then_refresh =>
      'Disconnected. Reconnect the chat, then refresh.';

  @override
  String release_core_gateway_queue_screen_gateway_queue_unavailable(
    String reason,
  ) {
    return 'Gateway queue unavailable: $reason.';
  }

  @override
  String release_core_gateway_queue_screen_not_confirmed_nothing_was_resent(
    String reason,
  ) {
    return 'Not confirmed ($reason). Nothing was resent.';
  }

  @override
  String get release_core_gateway_queue_screen_gateway_confirmed_admission =>
      'Gateway confirmed admission.';

  @override
  String
  get release_core_gateway_queue_screen_edited_entry_admitted_at_the_end_of_the =>
      'Edited entry admitted at the end of the queue.';

  @override
  String get release_core_gateway_queue_screen_discard_unknown_outcome =>
      'Discard unknown outcome?';

  @override
  String get release_core_gateway_queue_screen_remove_this_entry =>
      'Remove this entry?';

  @override
  String
  get release_core_gateway_queue_screen_the_lost_turn_will_not_be_retried_waiting =>
      'The lost turn will not be retried. Waiting turns may now run.';

  @override
  String
  get release_core_gateway_queue_screen_if_the_gateway_has_just_started_this_entry =>
      'If the gateway has just started this entry, removing it can stop that turn.';

  @override
  String get release_core_gateway_queue_screen_keep => 'Keep';

  @override
  String get release_core_gateway_queue_screen_discard_and_resume =>
      'Discard and resume';

  @override
  String get release_core_gateway_queue_screen_remove_entry => 'Remove entry';

  @override
  String
  get release_core_gateway_queue_screen_lost_admission_resolved_it_was_not_resent =>
      'Lost admission resolved; it was not resent.';

  @override
  String get release_core_gateway_queue_screen_gateway_acknowledged_removal =>
      'Gateway acknowledged removal.';

  @override
  String get release_core_gateway_queue_screen_gateway_queue => 'Gateway queue';

  @override
  String get release_core_gateway_queue_screen_refresh_queue => 'Refresh queue';

  @override
  String get release_core_gateway_queue_screen_queue_paused_unknown_outcome =>
      'Queue paused: unknown outcome';

  @override
  String
  get release_core_gateway_queue_screen_review_the_lost_admission_before_resuming_nothing_is =>
      'Review the lost admission before resuming. Nothing is sent again.';

  @override
  String get release_core_gateway_queue_screen_no_pending_admissions =>
      'No pending admissions';

  @override
  String get release_core_gateway_queue_screen_discard => 'Discard…';

  @override
  String
  get release_core_gateway_queue_screen_gateway_acknowledged_the_steering_request =>
      'Gateway acknowledged the steering request.';

  @override
  String get release_core_gateway_queue_screen_steer_running_turn =>
      'Steer running turn';

  @override
  String get release_core_gateway_queue_screen_remove => 'Remove…';

  @override
  String get release_core_gateway_queue_screen_next_prompt => 'Next prompt';

  @override
  String get release_core_gateway_queue_screen_edit_queued_prompt =>
      'Edit queued prompt';

  @override
  String get release_core_gateway_queue_screen_submit_to_gateway_queue =>
      'Submit to gateway queue';

  @override
  String get release_core_gateway_queue_screen_save_at_queue_end =>
      'Save at queue end';

  @override
  String get release_core_gateway_queue_screen_cancel_edit => 'Cancel edit';

  @override
  String get release_core_git_review_pane_the_git_operation_did_not_complete =>
      'The Git operation did not complete.';

  @override
  String get release_core_git_review_pane_close_git_review =>
      'Close Git review';

  @override
  String get release_core_git_review_pane_pin_lane => 'Pin lane';

  @override
  String get release_core_git_review_pane_refresh_git_review =>
      'Refresh Git review';

  @override
  String get release_core_git_review_pane_uncommitted => 'Uncommitted';

  @override
  String get release_core_git_review_pane_last_turn => 'Last turn';

  @override
  String
  get release_core_git_review_pane_branch_and_last_turn_views_are_read_only =>
      'Branch and last-turn views are read-only.';

  @override
  String get release_core_git_review_pane_mark_head_as_the_turn_baseline =>
      'Mark HEAD as the turn baseline';

  @override
  String get release_core_git_review_pane_stage_all => 'Stage all';

  @override
  String get release_core_git_review_pane_discard_every_uncommitted_change =>
      'Discard every uncommitted change?';

  @override
  String
  get release_core_git_review_pane_tracked_files_return_to_head_and_untracked_files =>
      'Tracked files return to HEAD and untracked files in this session directory are removed.';

  @override
  String get release_core_git_review_pane_discard => 'Discard';

  @override
  String get release_core_git_review_pane_discard_all => 'Discard all';

  @override
  String get release_core_git_review_pane_unstage => 'Unstage';

  @override
  String get release_core_git_review_pane_stage => 'Stage';

  @override
  String get release_core_git_review_pane_discard_file => 'Discard file';

  @override
  String release_core_git_review_pane_discard_2(String path) {
    return 'Discard $path?';
  }

  @override
  String
  get release_core_git_review_pane_this_restores_the_committed_copy_or_removes_the =>
      'This restores the committed copy or removes the untracked file.';

  @override
  String get release_core_git_review_pane_commit_message => 'Commit message';

  @override
  String get release_core_git_review_pane_nothing_in_the_diff_to_summarise =>
      'Nothing in the diff to summarise.';

  @override
  String get release_core_git_review_pane_generate_message =>
      'Generate message';

  @override
  String get release_core_git_review_pane_commit => 'Commit';

  @override
  String get release_core_git_review_pane_commit_and_push => 'Commit and push';

  @override
  String get release_core_git_review_pane_push => 'Push';

  @override
  String get release_core_git_review_pane_create_pull_request =>
      'Create pull request';

  @override
  String get release_core_git_review_pane_pull_request_ready =>
      'Pull request ready';

  @override
  String get release_core_git_review_pane_ask_hermes_to_ship =>
      'Ask Hermes to ship';

  @override
  String get release_core_git_review_pane_gh_is_authenticated_on_this_gateway =>
      'gh is authenticated on this gateway.';

  @override
  String
  get release_core_git_review_pane_install_the_github_cli_gh_and_sign_in =>
      'Install the GitHub CLI (gh) and sign in to open PRs';

  @override
  String get release_core_git_review_pane_worktrees => 'Worktrees';

  @override
  String get release_core_git_review_pane_main => 'Main';

  @override
  String release_core_git_review_pane_follow(String branch) {
    return 'Follow $branch?';
  }

  @override
  String
  get release_core_git_review_pane_the_session_working_directory_becomes_this_worktree_unless =>
      'The session working directory becomes this worktree unless the lane is pinned.';

  @override
  String get release_core_git_review_pane_follow_2 => 'Follow';

  @override
  String release_core_git_review_pane_remove(String branch) {
    return 'Remove $branch?';
  }

  @override
  String get release_core_git_review_pane_the_worktree_directory_is_removed =>
      'The worktree directory is removed.';

  @override
  String get release_core_git_review_pane_remove_2 => 'Remove';

  @override
  String get release_core_git_review_pane_new_worktree_name =>
      'New worktree name';

  @override
  String get release_core_git_review_pane_new_branch => 'New branch';

  @override
  String get release_core_git_review_pane_base_branch => 'Base branch';

  @override
  String get release_core_git_review_pane_create_worktree => 'Create worktree';

  @override
  String get release_core_git_review_pane_existing_branch => 'Existing branch';

  @override
  String get release_core_git_review_pane_convert_branch_to_worktree =>
      'Convert branch to worktree';

  @override
  String get release_core_git_review_pane_switch_branch => 'Switch branch';

  @override
  String
  get release_core_git_review_pane_this_gateway_does_not_support_that_git_operation =>
      'This gateway does not support that Git operation.';

  @override
  String
  get release_core_git_review_pane_git_needs_the_session_directory_on_the_local =>
      'Git needs the session directory on the local terminal backend.';

  @override
  String
  get release_core_git_review_pane_the_gateway_refused_the_git_operation =>
      'The gateway refused the Git operation.';

  @override
  String
  get release_core_git_review_pane_the_session_changed_refresh_and_try_again =>
      'The session changed. Refresh and try again.';

  @override
  String
  get release_core_git_review_pane_this_review_is_no_longer_the_selected_session =>
      'This review is no longer the selected session.';

  @override
  String
  get release_core_git_review_pane_the_gateway_returned_an_unexpected_git_result =>
      'The gateway returned an unexpected Git result.';

  @override
  String
  get release_core_git_review_pane_git_review_requires_the_gateway_transport =>
      'Git review requires the gateway transport.';

  @override
  String get release_core_client_held_queue_bar_resume => 'Resume';

  @override
  String get release_core_client_held_queue_bar_send_queued_prompt =>
      'Send queued prompt';

  @override
  String get release_core_client_held_queue_bar_edit_unsent_prompt =>
      'Edit unsent prompt';

  @override
  String get release_core_client_held_queue_bar_remove_unsent_prompt =>
      'Remove unsent prompt';

  @override
  String get release_core_workspace_discovery_view_repository_discovery =>
      'Repository discovery';

  @override
  String get release_core_workspace_discovery_view_refresh_results =>
      'Refresh results';

  @override
  String release_core_workspace_discovery_view_hide(String path) {
    return 'Hide $path';
  }

  @override
  String
  get release_core_workspace_discovery_view_invalid_path_or_discovery_data_use_absolute_server =>
      'Invalid path or discovery data. Use absolute server paths without . or .. components.';

  @override
  String
  get release_core_workspace_discovery_view_this_gateway_does_not_support_repository_discovery =>
      'This gateway does not support repository discovery.';

  @override
  String
  get release_core_workspace_discovery_view_the_gateway_denied_access_to_repository_discovery =>
      'The gateway denied access to repository discovery.';

  @override
  String
  get release_core_workspace_discovery_view_the_connection_changed_reopen_discovery_on_the_current =>
      'The connection changed. Reopen discovery on the current gateway.';

  @override
  String
  get release_core_workspace_discovery_view_the_displayed_settings_have_changed_refresh_before_trying =>
      'The displayed settings have changed. Refresh before trying again.';

  @override
  String
  get release_core_workspace_discovery_view_could_not_load_or_verify_discovery_settings_refresh =>
      'Could not load or verify discovery settings. Refresh to try again.';

  @override
  String release_core_workspace_discovery_view_repositories_shown_of(
    int visible,
    int total,
  ) {
    return 'Repositories shown: $visible of $total';
  }

  @override
  String
  get release_core_workspace_discovery_view_the_gateway_returned_no_repositories =>
      'The gateway returned no repositories.';

  @override
  String
  get release_core_workspace_discovery_view_no_repositories_match_your_device_filters =>
      'No repositories match your device filters.';

  @override
  String get release_core_workspace_discovery_view_gateway_scan_policy =>
      'Gateway scan policy';

  @override
  String
  get release_core_workspace_discovery_view_this_gateway_did_not_report_a_scan_policy =>
      'This gateway did not report a scan policy.';

  @override
  String
  get release_core_workspace_discovery_view_to_scan_folders_configure_repository_scanning_in_the =>
      'To scan folders, configure repository scanning in the gateway profile’s Desktop settings.';

  @override
  String
  get release_core_workspace_discovery_view_results_can_include_cached_repositories_and_repositories_with =>
      'Results can include cached repositories and repositories with sessions. A scan does not guarantee that every folder was reached.';

  @override
  String get release_core_workspace_discovery_view_scan_gateway_roots =>
      'Scan gateway roots';

  @override
  String
  get release_core_workspace_discovery_view_filter_results_on_this_device =>
      'Filter results on this device';

  @override
  String
  get release_core_workspace_discovery_view_only_this_discovery_list_changes_not_the_gateway =>
      'Only this discovery list changes, not the gateway scan.';

  @override
  String get release_core_workspace_discovery_view_include_subtrees_empty_all =>
      'Include subtrees (empty = all)';

  @override
  String get release_core_workspace_discovery_view_exclude_subtrees =>
      'Exclude subtrees';

  @override
  String get release_core_workspace_discovery_view_apply_filters =>
      'Apply filters';

  @override
  String release_core_workspace_discovery_view_hidden_repositories(int count) {
    return 'Hidden repositories ($count)';
  }

  @override
  String get release_core_workspace_discovery_view_undo_hide => 'Undo hide';

  @override
  String
  get release_core_workspace_discovery_view_one_absolute_server_path_per_line =>
      'One absolute server path per line';

  @override
  String get release_core_project_settings_view_project_settings =>
      'Project settings';

  @override
  String
  get release_core_project_settings_view_the_gateway_did_not_confirm_the_selected_project =>
      'The gateway did not confirm the selected project or change. Review the settings before trying again.';

  @override
  String
  get release_core_project_settings_view_could_not_verify_these_settings_use_one_absolute =>
      'Could not verify these settings. Use one absolute server folder path per line, without . or .. components.';

  @override
  String get release_core_project_settings_view_set_active => 'Set active';

  @override
  String get release_core_project_settings_view_icon => 'Icon';

  @override
  String get release_core_project_settings_view_folder => 'Folder';

  @override
  String get release_core_project_settings_view_repository => 'Repository';

  @override
  String get release_core_project_settings_view_rocket => 'Rocket';

  @override
  String get release_core_project_settings_view_star => 'Star';

  @override
  String get release_core_project_settings_view_book => 'Book';

  @override
  String get release_core_project_settings_view_terminal => 'Terminal';

  @override
  String get release_core_project_settings_view_colour => 'Colour';

  @override
  String get release_core_project_settings_view_primary_folder =>
      'Primary folder';

  @override
  String get release_core_project_settings_view_server_folder_paths =>
      'Server folder paths';

  @override
  String
  get release_core_project_settings_view_one_absolute_path_per_line_existing_folders_are =>
      'One absolute path per line. Existing folders are kept.';

  @override
  String get release_core_project_settings_view_add_folders => 'Add folders';

  @override
  String release_core_project_settings_view_choose(String label) {
    return 'Choose $label';
  }

  @override
  String
  get release_core_prepared_image_recovery_wait_for_an_empty_draft_before_restoring =>
      'Wait for an empty draft before restoring.';

  @override
  String
  get release_core_prepared_image_recovery_no_unacknowledged_image_drafts_in_this_chat =>
      'No unacknowledged image drafts in this chat.';

  @override
  String get release_core_prepared_image_recovery_unacknowledged_image_drafts =>
      'Unacknowledged image drafts';

  @override
  String
  get release_core_prepared_image_recovery_the_gateway_may_already_have_received_these_restore =>
      'The gateway may already have received these. Restore to review; nothing is sent.';

  @override
  String get release_core_prepared_image_recovery_image_draft => 'Image draft';

  @override
  String get release_core_prepared_image_recovery_discard_local_copy =>
      'Discard local copy';

  @override
  String
  get release_core_prepared_image_recovery_discard_this_local_image_draft =>
      'Discard this local image draft?';

  @override
  String
  get release_core_prepared_image_recovery_image_draft_recovery_is_unavailable =>
      'Image draft recovery is unavailable.';

  @override
  String get release_core_prepared_image_recovery_recover_image_draft =>
      'Recover image draft…';

  @override
  String get release_core_session_search_mode_menu_could_not_save_search_mode =>
      'Could not save search mode.';

  @override
  String get release_core_projects_pane_discover_repositories =>
      'Discover repositories';

  @override
  String
  get release_core_projects_pane_project_created_but_the_gateway_did_not_confirm =>
      'Project created, but the gateway did not confirm its idea.';

  @override
  String get release_core_projects_pane_project_idea_optional =>
      'Project idea (optional)';

  @override
  String
  get release_core_projects_pane_saved_in_the_project_description_not_a_file =>
      'Saved in the project description, not a file.';

  @override
  String get release_core_project_detail_screen_new_chat_in_this_lane =>
      'New chat in this lane';

  @override
  String get release_core_project_detail_screen_review_git => 'Review Git';

  @override
  String get release_core_more_pane_gateway_fleet => 'Gateway fleet';

  @override
  String
  get release_core_more_pane_connected_sessions_hermes_cloud_and_desktop_webapp =>
      'Connected sessions, Hermes Cloud and Desktop Webapp';

  @override
  String get release_core_more_pane_use_dashboard_sign_in_for_a_named_profile =>
      'Use dashboard sign-in for a named profile. This legacy API cannot confirm which profile owns chat history.';

  @override
  String get release_core_more_pane_capabilities => 'Capabilities';

  @override
  String
  get release_core_more_pane_install_and_govern_skills_plugins_connectors_and_tool =>
      'Install and govern skills, plugins, connectors and tool backends';

  @override
  String get release_core_more_pane_browser_vault => 'Browser vault';

  @override
  String
  get release_core_more_pane_site_logins_addresses_cards_and_credential_sources =>
      'Site logins, addresses, cards and credential sources';

  @override
  String get release_core_more_pane_agent_policy => 'Agent policy';

  @override
  String
  get release_core_more_pane_approvals_checkpoints_browser_access_and_shared_metrics =>
      'Approvals, checkpoints, browser access and shared metrics';

  @override
  String get release_core_more_pane_remote_logs_health_maintenance_and_update =>
      'Remote logs, health, maintenance and update';

  @override
  String get release_core_more_pane_schedules => 'Schedules';

  @override
  String get release_core_more_pane_all_profiles_blueprints_catch_up_and_stop =>
      'All profiles, blueprints, catch-up and stop';

  @override
  String get release_core_more_pane_memory_graph => 'Memory graph';

  @override
  String get release_core_more_pane_timeline_edits_and_memory_providers =>
      'Timeline, edits and memory providers';

  @override
  String get release_core_more_pane_providers_and_routes =>
      'Providers and routes';

  @override
  String get release_core_more_pane_keys_endpoints_delegation_and_mixtures =>
      'Keys, endpoints, delegation and mixtures';

  @override
  String get release_core_more_pane_credits_and_plans => 'Credits and plans';

  @override
  String
  get release_core_more_pane_consented_nous_billing_when_the_account_allows_it =>
      'Consented Nous billing when the account allows it';

  @override
  String
  get release_core_fleet_screen_this_gateway_does_not_offer_this_service =>
      'This gateway does not offer this service.';

  @override
  String
  get release_core_fleet_screen_sign_in_or_permission_required_on_this_gateway =>
      'Sign-in or permission required on this gateway.';

  @override
  String get release_core_fleet_screen_a_secure_gateway_address_is_required =>
      'A secure gateway address is required.';

  @override
  String
  get release_core_fleet_screen_the_owner_changed_refresh_before_continuing =>
      'The owner changed. Refresh before continuing.';

  @override
  String
  get release_core_fleet_screen_could_not_verify_the_operation_check_the_gateway =>
      'Could not verify the operation. Check the gateway and refresh.';

  @override
  String get release_core_fleet_screen_verified_ssh => 'Verified SSH';

  @override
  String
  get release_core_fleet_screen_confirm_a_host_key_inspect_a_remote_service =>
      'Confirm a host key, inspect a remote service or open its shell';

  @override
  String get release_core_fleet_screen_cloud_and_desktop_webapp =>
      'Cloud and Desktop Webapp';

  @override
  String get release_core_fleet_screen_register_an_existing_gateway_or_webapp =>
      'Register an existing gateway or Webapp';

  @override
  String
  get release_core_fleet_screen_sign_in_to_its_address_nothing_is_hosted =>
      'Sign in to its address. Nothing is hosted on this device.';

  @override
  String get release_core_fleet_screen_fleet_updates => 'Fleet updates';

  @override
  String get release_core_fleet_screen_refresh_roster => 'Refresh roster';

  @override
  String release_core_fleet_screen_disconnect(String gateway) {
    return 'Disconnect $gateway';
  }

  @override
  String get release_core_fleet_screen_open_this_gateway_on_launch =>
      'Open this gateway on launch';

  @override
  String
  get release_core_fleet_screen_primary_for_ares_does_not_change_the_last =>
      'Primary for Ares; does not change the last-used gateway.';

  @override
  String get release_core_fleet_screen_reconnect_in_fleet_on_launch =>
      'Reconnect in fleet on launch';

  @override
  String get release_core_fleet_screen_no_sessions_for_this_profile =>
      'No sessions for this profile.';

  @override
  String get release_core_fleet_screen_more_sessions => 'More sessions';

  @override
  String get release_core_fleet_screen_this_gateway_was_disconnected =>
      'This gateway was disconnected.';

  @override
  String
  get release_core_fleet_screen_some_conversation_data_could_not_be_loaded =>
      'Some conversation data could not be loaded.';

  @override
  String get release_core_fleet_screen_message_this_session =>
      'Message this session';

  @override
  String get release_core_fleet_screen_send_to_this_session =>
      'Send to this session';

  @override
  String get release_core_fleet_updates_screen_update_these_remote_gateways =>
      'Update these remote gateways?';

  @override
  String
  release_core_fleet_updates_screen_this_can_restart_the_backend_and_interrupt_other(
    String gateways,
  ) {
    return 'This can restart the backend and interrupt other users. It will not update Ares.\n\n$gateways';
  }

  @override
  String get release_core_fleet_updates_screen_update_listed_gateways =>
      'Update listed gateways';

  @override
  String
  get release_core_fleet_updates_screen_checks_connected_gateways_cloud_is_platform_managed_entries =>
      'Checks connected gateways. Cloud is platform-managed; entries without enrollment provenance are excluded.';

  @override
  String get release_core_fleet_updates_screen_check_connected_gateways =>
      'Check connected gateways';

  @override
  String get release_core_fleet_updates_screen_read_update_receipt =>
      'Read update receipt';

  @override
  String get release_core_fleet_updates_screen_review_eligible_updates =>
      'Review eligible updates';

  @override
  String
  get release_core_fleet_webapp_screen_account_changed_reopen_this_page =>
      'Account changed. Reopen this page.';

  @override
  String
  get release_core_fleet_webapp_screen_set_the_webapp_s_primary_gateway =>
      'Set the Webapp’s primary gateway?';

  @override
  String
  release_core_fleet_webapp_screen_this_changes_the_shared_registry_not_the_last(
    String webapp,
    String gateway,
    String id,
  ) {
    return '$webapp → $gateway ($id)\nThis changes the shared registry, not the last-used gateway.';
  }

  @override
  String get release_core_fleet_webapp_screen_set_primary => 'Set primary';

  @override
  String get release_core_fleet_webapp_screen_serving_profile =>
      'Serving profile';

  @override
  String get release_core_fleet_webapp_screen_hermes_cloud => 'Hermes Cloud';

  @override
  String get release_core_fleet_webapp_screen_discover_signed_in_agents =>
      'Discover signed-in agents';

  @override
  String release_core_fleet_webapp_screen_organisation(String organisation) {
    return 'Organisation: $organisation';
  }

  @override
  String get release_core_fleet_webapp_screen_no_agents_available =>
      'No agents available.';

  @override
  String get release_core_fleet_webapp_screen_existing_desktop_webapp =>
      'Existing Desktop Webapp';

  @override
  String
  get release_core_fleet_webapp_screen_check_gateway_and_web_access_status =>
      'Check gateway and Web Access status';

  @override
  String
  get release_core_fleet_webapp_screen_these_settings_belong_to_the_machine_serving_this =>
      'These settings belong to the machine serving this Webapp. Publishing and restarts are not remote actions.';

  @override
  String get release_core_fleet_webapp_screen_read_webapp_gateway_registry =>
      'Read Webapp gateway registry';

  @override
  String get release_core_fleet_webapp_screen_last_used => 'Last used';

  @override
  String get release_core_fleet_webapp_screen_primary => 'Primary';

  @override
  String release_core_fleet_webapp_screen_set_primary_2(String gateway) {
    return 'Set primary: $gateway';
  }

  @override
  String get release_core_fleet_webapp_screen_read_shared_display_preferences =>
      'Read shared display preferences';

  @override
  String
  get release_core_fleet_webapp_screen_chat_text_direction_on_this_webapp_and_desktop =>
      'Chat text direction on this Webapp and Desktop';

  @override
  String release_core_schedule_desk_screen_created_on(
    String job,
    String profile,
  ) {
    return 'Created $job on $profile.';
  }

  @override
  String
  get release_core_schedule_desk_screen_the_list_covers_every_profile_on_this_gateway =>
      'The list covers every profile on this gateway. Stop, pause, catch-up, delivery and blueprints are sent to the job\'s owning profile.';

  @override
  String get release_core_schedule_desk_screen_a_run_is_in_progress =>
      'A run is in progress';

  @override
  String get release_core_schedule_desk_screen_no_current_run =>
      'No current run';

  @override
  String release_core_schedule_desk_screen_stop_requested_for(String job) {
    return 'Stop requested for $job.';
  }

  @override
  String release_core_schedule_desk_screen_no_run_was_in_flight_for(
    String job,
  ) {
    return 'No run was in flight for $job.';
  }

  @override
  String get release_core_schedule_desk_screen_stop_current_run =>
      'Stop current run';

  @override
  String get release_core_schedule_desk_screen_pause_future_runs =>
      'Pause future runs';

  @override
  String get release_core_schedule_desk_screen_resume_future_runs =>
      'Resume future runs';

  @override
  String get release_core_schedule_desk_screen_catch_up_default =>
      'Catch-up default';

  @override
  String get release_core_schedule_desk_screen_run_one_missed =>
      'Run one missed';

  @override
  String get release_core_schedule_desk_screen_skip_missed => 'Skip missed';

  @override
  String get release_core_schedule_desk_screen_blueprint_recipes =>
      'Blueprint recipes';

  @override
  String get release_core_schedule_desk_screen_profile_for_the_new_job =>
      'Profile for the new job';

  @override
  String release_core_schedule_desk_screen_create(String blueprint) {
    return 'Create $blueprint';
  }

  @override
  String get release_core_schedule_desk_screen_loading_delivery_targets =>
      'Loading delivery targets';

  @override
  String release_core_schedule_desk_screen_no_home_channel(String target) {
    return '$target (no home channel)';
  }

  @override
  String release_core_memory_graph_screen_edit(String label) {
    return 'Edit $label';
  }

  @override
  String get release_core_memory_graph_screen_content => 'Content';

  @override
  String get release_core_memory_graph_screen_archive_skill => 'Archive skill';

  @override
  String get release_core_memory_graph_screen_delete_memory => 'Delete memory';

  @override
  String release_core_memory_graph_screen_archive_on_it_can_be_restored_on_the(
    String label,
    String profile,
  ) {
    return 'Archive $label on $profile? It can be restored on the host with the Curator.';
  }

  @override
  String release_core_memory_graph_screen_delete_from_this_removes_that_memory(
    String label,
    String profile,
  ) {
    return 'Delete $label from $profile? This removes that memory.';
  }

  @override
  String get release_core_memory_graph_screen_filter => 'Filter';

  @override
  String get release_core_memory_graph_screen_timeline => 'Timeline';

  @override
  String get release_core_memory_graph_screen_play_timeline => 'Play timeline';

  @override
  String get release_core_memory_graph_screen_layout_code => 'Layout code';

  @override
  String get release_core_memory_graph_screen_external_memory_providers =>
      'External memory providers';

  @override
  String
  get release_core_memory_graph_screen_a_value_is_stored_leave_blank_to_keep =>
      'A value is stored. Leave blank to keep it.';

  @override
  String get release_core_memory_graph_screen_save_provider => 'Save provider';

  @override
  String release_core_workspace_profiles_screen_applies_to(String profile) {
    return 'Applies to: $profile';
  }

  @override
  String get release_core_workspace_profiles_screen_choose_another_profile =>
      'Choose another profile';

  @override
  String
  get release_core_workspace_profiles_screen_could_not_verify_the_selected_profile_on_this =>
      'Could not verify the selected profile on this gateway.';

  @override
  String get release_core_workspace_profiles_screen_create_profile =>
      'Create profile';

  @override
  String get release_core_workspace_profiles_screen_new_profile_id =>
      'New profile ID';

  @override
  String get release_core_assets_screen_links => 'Links';

  @override
  String get release_core_workspace_picker_no_matching_items =>
      'No matching items.';

  @override
  String get release_core_workspace_picker_save_layout => 'Save layout';

  @override
  String get release_core_workspace_picker_layout_name => 'Layout name';

  @override
  String
  get release_core_workspace_popout_this_chat_already_has_a_pop_out_window =>
      'This chat already has a pop-out window.';

  @override
  String
  get release_core_workspace_popout_could_not_open_this_saved_chat_check_the =>
      'Could not open this saved chat. Check the connection and try again.';

  @override
  String
  get release_core_popout_bootstrap_use_the_main_window_to_change_your_connection =>
      'Use the main window to change your connection.';

  @override
  String get release_core_guarded_save_refused =>
      'This file can\'t be saved by the gateway';

  @override
  String get release_core_guarded_save_unavailable =>
      'Guarded saving isn\'t available on this gateway';

  @override
  String release_core_git_files_changed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count files changed this turn',
      one: '1 file changed this turn',
    );
    return '$_temp0';
  }

  @override
  String release_core_git_entries_omitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count Git entries were left out because they were not safe to show.',
      one: '1 Git entry was left out because it was not safe to show.',
    );
    return '$_temp0';
  }

  @override
  String get release_core_git_staged => 'Staged';

  @override
  String get release_core_session_sort_recent => 'Recent activity';

  @override
  String get release_core_session_sort_created => 'Newest created';

  @override
  String get release_core_session_sort_status => 'Running first';

  @override
  String get release_core_session_sort_tokens => 'Most tokens';

  @override
  String get release_core_session_sort_cost => 'Highest cost';

  @override
  String get release_core_session_group_standard => 'Default grouping';

  @override
  String get release_core_session_group_status => 'Group by status';

  @override
  String get release_core_session_group_project => 'Group by project';

  @override
  String release_core_session_tokens(int count) {
    return '$count tokens';
  }

  @override
  String release_core_search_gateway_mode(String mode) {
    return '$mode (gateway)';
  }

  @override
  String release_core_search_mode_tooltip(String label, String mode) {
    return '$label: $mode';
  }

  @override
  String get release_core_image_recovery_new_turn =>
      'Sending creates a new turn';

  @override
  String release_core_image_recovery_metadata(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count images · $date',
      one: '1 image · $date',
    );
    return '$_temp0';
  }

  @override
  String release_core_discovery_scanning(String state) {
    return 'Scanning: $state';
  }

  @override
  String get release_core_discovery_enabled => 'enabled';

  @override
  String get release_core_discovery_disabled => 'disabled';

  @override
  String get release_core_discovery_none => 'none';

  @override
  String release_core_discovery_roots(String paths) {
    return 'Scan roots: $paths';
  }

  @override
  String release_core_discovery_excluded(String paths) {
    return 'Excluded subtrees: $paths';
  }

  @override
  String release_core_discovery_repository_sessions(String path, int count) {
    return '$path\nSessions: $count';
  }

  @override
  String get release_core_projects_local_only =>
      'This Hermes gateway is older than server-side projects, so chats stay grouped on this device only. Update Hermes to share the same projects across your devices.';

  @override
  String get release_core_fleet_no_address => 'No gateway address yet';

  @override
  String release_core_fleet_diagnostics(String version, String access) {
    return 'Gateway $version · $access';
  }

  @override
  String get release_core_schedule_builtin => 'built-in';

  @override
  String get release_core_memory_gateway_profile => 'gateway';

  @override
  String release_core_memory_profile_summary(String profile, String gateway) {
    return 'Profile $profile on $gateway. The share code stores zoom, time and filters only.';
  }

  @override
  String release_core_memory_layers_summary(
    int memoryBytes,
    int userBytes,
    String provider,
  ) {
    return 'Built-in memory $memoryBytes bytes, user $userBytes bytes. Active provider $provider.';
  }

  @override
  String get release_core_memory_kind_all => 'All';

  @override
  String get release_core_memory_kind_skill => 'Skills';

  @override
  String get release_core_memory_kind_memory => 'Memory';

  @override
  String get release_core_workspace_failure_stale => 'connection changed';

  @override
  String get release_core_workspace_failure_unbound =>
      'no verified working directory';

  @override
  String get release_core_workspace_failure_denied => 'permission denied';

  @override
  String get release_core_workspace_failure_ineligible =>
      'operation not allowed for this file';

  @override
  String get release_core_workspace_failure_unsupported =>
      'not supported by this gateway';

  @override
  String get release_core_workspace_failure_mismatch => 'remote state changed';

  @override
  String get release_core_workspace_failure_invalid =>
      'invalid gateway response';

  @override
  String get release_core_workspace_failure_insecure =>
      'secure connection required';

  @override
  String get release_core_workspace_failure_unavailable =>
      'gateway unavailable';

  @override
  String get release_core_queue_state_queued => 'Queued';

  @override
  String get release_core_queue_state_started => 'Started';

  @override
  String get release_core_queue_state_unknown => 'Unknown outcome';

  @override
  String get release_core_unknown_state => 'Unknown';

  @override
  String get release_core_fleet_state_idle => 'Offline';

  @override
  String get release_core_fleet_state_connected => 'Connected';

  @override
  String get release_core_fleet_state_reconnecting => 'Reconnecting…';

  @override
  String get release_core_fleet_state_sessionExpired => 'Signed out';

  @override
  String get release_core_fleet_state_failed => 'Connection failed';

  @override
  String release_core_workspace_operation_failed(String reason) {
    return 'Gateway operation could not be confirmed: $reason.';
  }

  @override
  String get release_core_workspace_invalid_data =>
      'The data or input could not be verified. Review it and try again.';

  @override
  String
  get release_core_parallel_workspace_layout_changed_in_this_window_but_could_not =>
      'Layout changed in this window but could not be saved.';

  @override
  String get release_core_parallel_workspace_first_pane => 'First pane';

  @override
  String get release_core_parallel_workspace_second_pane => 'Second pane';

  @override
  String get release_core_parallel_workspace_unavailable_page =>
      'Unavailable page';

  @override
  String release_core_parallel_workspace_close_a_tab_first_maximum(
    String maximum,
  ) {
    return 'Close a tab first (maximum $maximum).';
  }

  @override
  String get release_core_parallel_workspace_dock_beside_current_pane =>
      'Dock beside current pane';

  @override
  String get release_core_parallel_workspace_add_chat => 'Add chat';

  @override
  String
  get release_core_parallel_workspace_action_failed_check_the_connection_and_try_again =>
      'Action failed. Check the connection and try again.';

  @override
  String
  get release_core_parallel_workspace_close_a_tab_before_reopening_another =>
      'Close a tab before reopening another.';

  @override
  String release_core_parallel_workspace_replace_layout(String name) {
    return 'Replace layout “$name”?';
  }

  @override
  String
  get release_core_parallel_workspace_layout_limit_reached_replace_an_existing_layout =>
      'Layout limit reached. Replace an existing layout.';

  @override
  String get release_core_parallel_workspace_restore_layout => 'Restore layout';

  @override
  String get release_core_parallel_workspace_workspace_options =>
      'Workspace options';

  @override
  String get release_core_parallel_workspace_dock_another_pane =>
      'Dock another pane';

  @override
  String get release_core_parallel_workspace_swap_panes => 'Swap panes';

  @override
  String get release_core_parallel_workspace_undock_second_pane =>
      'Undock second pane';

  @override
  String get release_core_parallel_workspace_arrange_side_by_side =>
      'Arrange side by side';

  @override
  String get release_core_parallel_workspace_arrange_top_to_bottom =>
      'Arrange top to bottom';

  @override
  String release_core_parallel_workspace_change_split_size(String percent) {
    return 'Change split size ($percent%)';
  }

  @override
  String get release_core_parallel_workspace_focus_pane_full_screen =>
      'Focus pane full screen';

  @override
  String get release_core_parallel_workspace_open_chat_in_new_window =>
      'Open chat in new window';

  @override
  String get release_core_parallel_workspace_hide_pane_keep_running =>
      'Hide pane (keep running)';

  @override
  String get release_core_parallel_workspace_previous_tab => 'Previous tab';

  @override
  String get release_core_parallel_workspace_next_tab => 'Next tab';

  @override
  String get release_core_parallel_workspace_move_tab_left => 'Move tab left';

  @override
  String get release_core_parallel_workspace_move_tab_right => 'Move tab right';

  @override
  String get release_core_parallel_workspace_reload_current_tab =>
      'Reload current tab';

  @override
  String get release_core_parallel_workspace_close_tab => 'Close tab';

  @override
  String get release_core_parallel_workspace_close_other_tabs =>
      'Close other tabs';

  @override
  String get release_core_parallel_workspace_close_tabs_to_the_right =>
      'Close tabs to the right';

  @override
  String get release_core_parallel_workspace_close_all_tabs => 'Close all tabs';

  @override
  String get release_core_parallel_workspace_reopen_closed_tab =>
      'Reopen closed tab';

  @override
  String get release_core_parallel_workspace_save_named_layout =>
      'Save named layout';

  @override
  String get release_core_parallel_workspace_restore_named_layout =>
      'Restore named layout';

  @override
  String get release_core_parallel_workspace_refresh_chat_list =>
      'Refresh chat list';

  @override
  String get release_core_parallel_workspace_workspace_tools =>
      'Workspace tools';

  @override
  String get release_core_parallel_workspace_choose_a_chat_for_this_pane =>
      'Choose a chat for this pane';

  @override
  String release_core_parallel_workspace_choose_chat_for(String pane) {
    return 'Choose chat for $pane';
  }

  @override
  String get release_core_parallel_workspace_add_a_chat_to_start_a_workspace =>
      'Add a chat to start a workspace.';

  @override
  String get release_core_parallel_workspace_select_a_tab_to_show_its_pane =>
      'Select a tab to show its pane.';

  @override
  String get release_core_parallel_workspace_parallel_workspace =>
      'Parallel workspace';

  @override
  String get release_core_parallel_workspace_show_workspace => 'Show workspace';

  @override
  String get release_core_parallel_workspace_could_not_load_chats_retry =>
      'Could not load chats. Retry';

  @override
  String release_core_parallel_workspace_close(String pane) {
    return 'Close $pane';
  }

  @override
  String release_core_parallel_workspace_switch_pane(String pane) {
    return 'Switch pane: $pane';
  }

  @override
  String get release_core_workspace_registry_session_id_copied =>
      'Session ID copied.';

  @override
  String get release_core_workspace_registry_chat_details => 'Chat details';

  @override
  String get release_core_workspace_registry_server_default => 'Server default';

  @override
  String get release_core_workspace_registry_session_id => 'Session ID';

  @override
  String get release_core_workspace_registry_title => 'Title';

  @override
  String get release_core_workspace_label_terminals => 'Terminals';

  @override
  String get release_core_workspace_label_copy_id => 'Copy session ID';

  @override
  String get release_core_workspace_label_contributions => 'Contributions';

  @override
  String get release_core_workspace_owner_inactive =>
      'This workspace owner is no longer active.';

  @override
  String get release_core_workspace_select_chat => 'Select a chat first.';

  @override
  String get release_core_workspace_chat_unavailable =>
      'This chat is not available for this connection.';

  @override
  String get release_core_workspace_page_unavailable =>
      'This page is not available for this connection.';

  @override
  String release_core_client_queue_count(int count) {
    return '$count queued';
  }

  @override
  String release_core_client_queue_paused_count(int count) {
    return '$count queued — paused';
  }

  @override
  String release_core_git_diff_truncated(String diff) {
    return '$diff\n… truncated';
  }

  @override
  String get release_core_search_no_models =>
      'Hermes returned no configured selectable models.';

  @override
  String get release_core_chat_archive_unavailable =>
      'Chat archive action is unavailable.';

  @override
  String get release_core_chat_pin_unconfirmed =>
      'Pin state was not confirmed.';

  @override
  String get release_core_chat_archive_unconfirmed =>
      'Archive state was not confirmed.';

  @override
  String get release_core_chat_archive_history_unavailable =>
      'Archived history unavailable';

  @override
  String get release_core_quick_chat_history_unavailable =>
      'Quick Chat history unavailable';

  @override
  String get release_core_chat_project_ownership_unavailable =>
      'Project ownership unavailable';

  @override
  String get release_core_chat_unknown_project => 'Unknown project';

  @override
  String get release_core_chat_local_search_fallback =>
      'Message search unavailable. Showing local matches.';

  @override
  String release_core_fleet_update_eligible(String version) {
    return 'Eligible · $version';
  }

  @override
  String get release_core_fleet_update_state_1 => 'Skipped: same installation';

  @override
  String get release_core_fleet_update_state_2 => 'Not checked';

  @override
  String get release_core_fleet_update_state_3 => 'Skipped: Cloud-managed';

  @override
  String get release_core_fleet_update_state_4 =>
      'Skipped: not enrolled as a direct gateway';

  @override
  String get release_core_fleet_update_state_5 =>
      'Skipped: disconnected or busy';

  @override
  String get release_core_fleet_update_state_6 => 'No applicable update';

  @override
  String get release_core_fleet_update_state_7 =>
      'Could not verify eligibility';

  @override
  String get release_core_fleet_update_state_8 =>
      'Skipped: stale, busy or already requested';

  @override
  String get release_core_fleet_update_state_9 => 'Requesting';

  @override
  String get release_core_fleet_update_state_10 =>
      'Accepted; receipt unavailable';

  @override
  String get release_core_fleet_update_state_11 => 'Accepted; awaiting receipt';

  @override
  String get release_core_fleet_update_state_12 =>
      'Skipped: a chat on this installation is running';

  @override
  String get release_core_fleet_update_state_13 =>
      'Not confirmed; do not resend automatically';

  @override
  String get release_core_fleet_update_state_14 => 'Reconnect to check receipt';

  @override
  String get release_core_fleet_update_state_15 => 'Receipt unavailable';

  @override
  String get release_core_fleet_update_state_16 => 'Awaiting matching receipt';

  @override
  String get release_core_fleet_update_state_17 =>
      'Updated; follow-up required';

  @override
  String get release_core_fleet_update_state_19 => 'Partially updated';

  @override
  String get release_core_fleet_update_state_20 => 'Update failed';

  @override
  String get release_core_fleet_update_state_21 => 'Not confirmed';

  @override
  String get release_core_cloud_status_ready => 'Ready';

  @override
  String get release_core_cloud_status_online => 'Online';

  @override
  String get release_core_cloud_status_stopped => 'Stopped';

  @override
  String get release_core_cloud_status_error => 'Error';

  @override
  String get ng_release_more_contributions_subtitle =>
      'Reviewed reply cards for this connection';

  @override
  String get ng_release_more_gateway_fleet => 'Gateway fleet';

  @override
  String get ng_release_more_memory_graph => 'Memory graph';

  @override
  String get ng_release_more_memory_graph_subtitle =>
      'Timeline, edits and memory providers';

  @override
  String get ng_release_more_capabilities_subtitle =>
      'Install and govern skills, plugins, connectors and tool backends';

  @override
  String get ng_release_more_browser_vault => 'Browser vault';

  @override
  String get ng_release_more_browser_vault_subtitle =>
      'Site logins, addresses, cards and credential sources';

  @override
  String get ng_release_more_agent_policy => 'Agent policy';

  @override
  String get ng_release_more_agent_policy_subtitle =>
      'Approvals, checkpoints, browser access and shared metrics';

  @override
  String get ng_release_more_schedules => 'Schedules';

  @override
  String get ng_release_more_schedules_subtitle =>
      'All profiles, blueprints, catch-up and stop';

  @override
  String get ng_release_more_host_subtitle =>
      'Remote logs, health, maintenance and update';

  @override
  String get ng_release_more_providers_routes => 'Providers and routes';

  @override
  String get ng_release_more_providers_routes_subtitle =>
      'Keys, endpoints, delegation and mixtures';

  @override
  String get ng_release_more_credits_plans => 'Credits and plans';

  @override
  String get ng_release_more_credits_plans_subtitle =>
      'Consented Nous billing when the account allows it';

  @override
  String get ng_release_sign_in_or => 'or';

  @override
  String ng_release_deployment_sign_in_hint(String message) {
    return '$message You can still sign in with a deployment session token on the next step.';
  }

  @override
  String get ng_release_message_search_unavailable =>
      'Message search unavailable. Showing local matches.';

  @override
  String ng_release_insights_days(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '$days day',
    );
    return '$_temp0';
  }

  @override
  String get ng_release_signed_in_you => 'you';

  @override
  String get release_chat_unsent_prompt_gone =>
      'That unsent prompt is no longer in the queue.';

  @override
  String ng_release_attachment_not_attached(String name) {
    return 'The gateway did not attach $name.';
  }

  @override
  String get ng_release_gateway_not_connected =>
      'Not connected to the gateway yet.';

  @override
  String get ng_release_gateway_unreachable => 'Couldn\'t reach the gateway.';

  @override
  String get ng_release_projects_scope_changed =>
      'Projects scope is no longer selected';

  @override
  String get ng_release_missing_providers => 'Missing providers';

  @override
  String get ng_release_missing_tasks => 'Missing tasks';

  @override
  String ng_release_age_minutes(int count) {
    return '${count}m';
  }

  @override
  String ng_release_age_hours(int count) {
    return '${count}h';
  }

  @override
  String ng_release_age_days(int count) {
    return '${count}d';
  }

  @override
  String ng_release_age_weeks(int count) {
    return '${count}w';
  }

  @override
  String ng_release_age_years(int count) {
    return '${count}y';
  }

  @override
  String ng_release_compact_billions(String count) {
    return '${count}B';
  }

  @override
  String ng_release_compact_millions(String count) {
    return '${count}M';
  }

  @override
  String ng_release_compact_thousands(String count) {
    return '${count}k';
  }

  @override
  String ng_release_token_thousands(String count) {
    return '${count}K';
  }

  @override
  String ng_release_elapsed_minutes_seconds(int minutes, int seconds) {
    return '${minutes}m ${seconds}s';
  }

  @override
  String ng_release_elapsed_seconds(int seconds) {
    return '${seconds}s';
  }

  @override
  String get ng_release_notification_foreground => 'Ares was on screen';

  @override
  String get ng_release_notification_stopped => 'the turn was stopped';

  @override
  String get ng_release_more_parallel_workspace => 'Parallel workspace';

  @override
  String get ng_release_more_parallel_workspace_subtitle =>
      'Open multiple chats in tabs or side by side.';

  @override
  String get release_chat_unknown_model => 'unknown';

  @override
  String release_chat_profile_default(String model) {
    return 'Profile default: $model';
  }

  @override
  String release_chat_profile_default_provider(String model, String provider) {
    return 'Profile default: $model • $provider';
  }

  @override
  String get release_chat_choose_provider =>
      'This model is available from multiple providers. Choose a provider to continue.';

  @override
  String get release_chat_slash_needs_gateway =>
      'Slash commands need the Desktop gateway';

  @override
  String get release_chat_recovering_without_resending =>
      'Recovering without resending';

  @override
  String get release_chat_live_request_unreachable =>
      'Sorry, I could not reach Hermes for that request.';

  @override
  String release_chat_live_working(String tool) {
    return 'Hermes is working: $tool. Not done yet.';
  }

  @override
  String get release_chat_live_finished_without_spoken_result =>
      'Hermes finished that request without a spoken result.';

  @override
  String get release_chat_reply_language_unavailable =>
      'Selected reply language is unavailable';

  @override
  String get release_chat_reply_voice_unavailable =>
      'Selected reply voice is unavailable';

  @override
  String get release_chat_reply_voice_configuration_unavailable =>
      'Reply voice configuration is unavailable';

  @override
  String get release_chat_notification_review_action =>
      'Open the chat to review the requested action.';

  @override
  String get release_chat_notification_respond => 'Open the chat to respond.';

  @override
  String get release_chat_start_new_main_window =>
      'Start a new chat in the main window.';

  @override
  String get release_chat_no_desktop_gateway => 'No Desktop gateway';

  @override
  String get release_chat_attachment_preparation_cancelled =>
      'Attachment preparation was cancelled.';

  @override
  String get release_chat_approval_authority_revoked =>
      'Approval authority was revoked.';

  @override
  String get release_chat_gateway_session_disconnected =>
      'The Desktop gateway session is no longer connected';

  @override
  String get release_chat_stop_requested =>
      'Stop requested. Waiting for Hermes to finish.';

  @override
  String release_chat_stop_request_failed(String error) {
    return 'Could not request stop: $error';
  }

  @override
  String get release_chat_queued_prompt_not_sent =>
      'The queued prompt was not sent.';

  @override
  String get release_chat_running_turn_unreachable =>
      'The running turn could not be reached. Reconnecting without resending.';

  @override
  String get release_chat_wait_for_composer =>
      'Wait for the composer to become available.';

  @override
  String get release_chat_find_in_transcript => 'Find in transcript';

  @override
  String get release_chat_open_browser_preview => 'Open browser preview';

  @override
  String get release_chat_more_tools => 'More chat tools';

  @override
  String get release_chat_queue_until_finished =>
      'Queue until this turn finishes';

  @override
  String get release_chat_format_bold => 'Bold';

  @override
  String get release_chat_format_italic => 'Italic';

  @override
  String get ng_release_chat_gateway_queue_requirements =>
      'The gateway queue needs an attached chat and a text-only prompt.';

  @override
  String get ng_release_chat_start_new_main_screen =>
      'Start a new chat from the main chat screen.';

  @override
  String get ng_release_chat_image => 'image';

  @override
  String ng_release_chat_tool_seconds(String seconds) {
    return '${seconds}s';
  }

  @override
  String get release_preview_chat_changed =>
      'Chat changed. Reconnect the preview to continue.';

  @override
  String get release_preview_authenticating_chat => 'Authenticating chat…';

  @override
  String release_preview_unavailable_reason(String reason) {
    return 'Preview unavailable: $reason';
  }

  @override
  String get release_preview_operation_failed => 'Preview operation failed.';

  @override
  String get release_preview_added_to_draft => 'Added to draft. Nothing sent.';

  @override
  String get release_preview_open_site_title => 'Open this site?';

  @override
  String release_preview_open_site_body(String origin) {
    return '$origin\n\nReader mode loads only this document. It does not share cookies, sign-in details or the page with Hermes.';
  }

  @override
  String get release_preview_open_site => 'Open site';

  @override
  String get release_preview_discard_pins_title => 'Discard unstaged pins?';

  @override
  String get release_preview_keep_pins => 'Keep pins';

  @override
  String get release_preview_share_page_title =>
      'Share this page with this chat?';

  @override
  String release_preview_share_page_body(String origin) {
    return 'Hermes can read the displayed text and element list from $origin, and scroll this pane. Navigation ends sharing. Forms and credentials are not shared.';
  }

  @override
  String get release_preview_share_page => 'Share page';

  @override
  String release_preview_comment_number(int number) {
    return 'Comment #$number';
  }

  @override
  String get release_preview_note => 'Note';

  @override
  String get release_preview_keep_pin => 'Keep pin';

  @override
  String get release_preview_title => 'Browser preview';

  @override
  String get release_preview_hide => 'Hide preview';

  @override
  String get release_preview_close_and_forget => 'Close and forget page';

  @override
  String get release_preview_site_address => 'Site address';

  @override
  String get release_preview_go_to_address => 'Go to address';

  @override
  String get release_preview_forward => 'Forward';

  @override
  String get release_preview_reload => 'Reload';

  @override
  String get release_preview_share_with_hermes => 'Share page with Hermes';

  @override
  String get release_preview_stop_sharing => 'Stop sharing page';

  @override
  String get release_preview_annotate => 'Annotate element or region';

  @override
  String get release_preview_reader_console => 'Reader console';

  @override
  String get release_preview_reconnect => 'Reconnect preview';

  @override
  String get release_preview_reader_mode_help =>
      'Reader mode: HTML and text. No scripts, embedded resources or signed-in browser profile.';

  @override
  String release_preview_sharing_origin(String origin) {
    return 'Sharing reader with this chat: $origin';
  }

  @override
  String get release_preview_annotation_help =>
      'Tap an element or drag a region to comment.';

  @override
  String get release_preview_reader_requests =>
      'Reader requests (JavaScript is off)';

  @override
  String release_preview_selected_requests(int count) {
    return '$count selected · JavaScript is off';
  }

  @override
  String get release_preview_copy_all => 'Copy all';

  @override
  String get release_preview_copy_selected => 'Copy selected';

  @override
  String get release_preview_add_log_to_draft => 'Add log to draft';

  @override
  String release_preview_requests_draft(String log) {
    return 'Reader requests:\n$log';
  }

  @override
  String release_preview_add_pins_to_draft(int count) {
    return 'Add $count to draft';
  }

  @override
  String release_preview_request_loaded(String origin, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reader elements',
      one: '$count reader element',
    );
    return 'HTTP 200 · $origin · $_temp0';
  }

  @override
  String release_preview_annotation_intro(String origin) {
    return 'Review these comments on the preview of $origin. The attached crops are numbered in the same order.';
  }

  @override
  String get release_preview_reader_region => 'reader region';

  @override
  String get release_preview_capture_failed =>
      'Could not capture these pixels.';

  @override
  String get release_preview_address_not_approved =>
      'This address is outside the approved preview origin.';

  @override
  String get release_preview_page_limit => 'Page exceeds the reader limit.';

  @override
  String get release_preview_page_unreadable => 'The page could not be read.';

  @override
  String get release_preview_page_complex =>
      'This page is too complex for reader mode.';

  @override
  String release_preview_http_failed(int statusCode) {
    return 'HTTP $statusCode. No redirect or sign-in was followed.';
  }

  @override
  String get release_preview_unsupported_type =>
      'Only HTML and plain text can open in reader mode.';

  @override
  String get release_preview_load_insecure =>
      'The site could not be loaded securely.';

  @override
  String get release_preview_crop_limit => 'Preview crop exceeds its limit.';

  @override
  String get release_preview_image_unreadable =>
      'The selected image is empty or unreadable.';

  @override
  String get release_preview_image_budget =>
      'The selected image exceeds the 64 MiB draft budget.';

  @override
  String get release_preview_image_format =>
      'Unsupported image format. Choose a JPEG, PNG, or WebP image.';

  @override
  String get release_preview_image_decode =>
      'The selected JPEG, PNG, or WebP image could not be decoded safely.';

  @override
  String get release_preview_image_sanitize =>
      'Unable to sanitize this image. Choose a valid JPEG, PNG, or WebP image.';

  @override
  String get release_preview_draft_budget =>
      'Attachments are limited to 64 MiB total per draft.';

  @override
  String get release_preview_generic_file_limit =>
      'Generic files are limited to 16 MiB each.';

  @override
  String get release_preview_image_not_sanitized =>
      'Remote images must be sanitized before upload.';

  @override
  String get release_preview_stage_failed =>
      'Could not add preview evidence to the draft. Try again.';

  @override
  String get release_misc_find_hermes_on_lan => 'Find Hermes on LAN';

  @override
  String release_misc_discovery_failed(String error) {
    return 'Discovery failed: $error';
  }

  @override
  String get release_misc_no_lan_servers =>
      'No Hermes servers found on the local network.';

  @override
  String release_misc_api_key_rejected(String endpoint, int statusCode) {
    return 'API key was rejected by $endpoint (HTTP $statusCode).';
  }

  @override
  String get release_misc_api_key_required =>
      'Server requires an API key. Enter your API_SERVER_KEY.';

  @override
  String release_misc_gateway_not_found(String endpoint) {
    return 'Gateway endpoint $endpoint returned HTTP 404. Check the Gateway path prefix and reverse-proxy routes.';
  }

  @override
  String release_misc_gateway_http_error(String endpoint, int statusCode) {
    return 'Gateway endpoint $endpoint returned HTTP $statusCode.';
  }

  @override
  String release_misc_gateway_unreachable(String endpoint) {
    return 'Cannot reach Gateway endpoint $endpoint.';
  }

  @override
  String get release_core_schedule_invalid_delivery_target =>
      'Invalid delivery target';

  @override
  String get release_core_file_save_direct_only =>
      'Only a file directly in the working directory can be saved.';

  @override
  String get release_core_file_save_hidden =>
      'Hidden files can\'t be saved by the gateway.';

  @override
  String get rel_admin_choose_provider => 'Choose a provider and a model.';

  @override
  String get rel_admin_known_effort => 'Choose a known effort level.';

  @override
  String get rel_admin_endpoint_name_required =>
      'Enter a name for this endpoint.';

  @override
  String get rel_admin_endpoint_model_required =>
      'Enter the model this endpoint serves.';

  @override
  String get rel_admin_known_api_mode => 'Choose Auto or a known API mode.';

  @override
  String get rel_admin_endpoint_id_invalid =>
      'This endpoint identifier is not usable.';

  @override
  String get rel_admin_endpoint_https =>
      'Use HTTPS for a remote endpoint, or HTTP on localhost.';

  @override
  String get rel_admin_key_invalid => 'That API key cannot be saved.';

  @override
  String get rel_admin_response_shape =>
      'The gateway response did not match the expected shape.';

  @override
  String get rel_admin_limits_required =>
      'Enter iteration, concurrency and timeout limits before saving.';

  @override
  String get rel_admin_route_required =>
      'Each route needs a name and a model before it can be saved.';

  @override
  String get rel_admin_route_unique => 'Route names must be unique.';

  @override
  String get rel_admin_route_default_invalid =>
      'The default route has to be one of the saved routes.';

  @override
  String get rel_admin_policy_required =>
      'Choose a loud or silent degraded-reference policy.';

  @override
  String get rel_admin_mixture_missing =>
      'The gateway did not return an active mixture.';

  @override
  String get rel_admin_mixture_slots_required =>
      'Name a provider and model for the aggregator and every reference.';

  @override
  String get rel_admin_chat_id_required =>
      'Enter the chat id this change applies to.';

  @override
  String rel_admin_http_error(String status) {
    return 'The gateway returned HTTP $status.';
  }

  @override
  String get rel_admin_response_unreadable =>
      'The gateway response could not be read.';

  @override
  String get rel_admin_connect_before_change =>
      'Connect the live gateway session before changing billing or a chat.';

  @override
  String get rel_admin_operation_unavailable =>
      'This gateway does not provide that operation.';

  @override
  String get rel_admin_key_required => 'Enter the key to save.';

  @override
  String get rel_admin_key_save_failed => 'The gateway did not save that key.';

  @override
  String get rel_admin_key_clear_required => 'Choose a provider key to clear.';

  @override
  String get rel_admin_key_clear_failed =>
      'The gateway did not clear that key.';

  @override
  String get rel_admin_endpoint_save_failed =>
      'The gateway did not save that endpoint.';

  @override
  String get rel_admin_endpoint_activate_failed =>
      'The gateway did not activate that endpoint.';

  @override
  String get rel_admin_accounts_secure_required =>
      'Provider accounts need an authenticated HTTPS gateway, or localhost.';

  @override
  String get rel_admin_accounts_read_failed =>
      'Provider accounts could not be read.';

  @override
  String get rel_admin_account_disconnect_failed =>
      'The gateway did not disconnect that account.';

  @override
  String get rel_admin_account_not_disconnectable =>
      'That provider account cannot be disconnected.';

  @override
  String get rel_admin_backend_required =>
      'Choose one of the available delegation backends.';

  @override
  String get rel_admin_backend_save_failed =>
      'The gateway did not select that backend.';

  @override
  String get rel_admin_routes_save_failed =>
      'The gateway did not save those routes.';

  @override
  String get rel_admin_profile_route_required =>
      'Each profile route needs a profile name.';

  @override
  String get rel_admin_profile_route_unique => 'Profile routes must be unique.';

  @override
  String get rel_admin_profile_route_default_invalid =>
      'The default profile route has to be one of the allowed profiles.';

  @override
  String get rel_admin_profile_routes_save_failed =>
      'The gateway did not save those profile routes.';

  @override
  String get rel_admin_limits_save_failed =>
      'The gateway did not save those limits.';

  @override
  String get rel_admin_mixture_save_failed =>
      'The gateway did not save that mixture.';

  @override
  String get rel_admin_credit_amount_required =>
      'Choose one of the offered credit amounts.';

  @override
  String get rel_admin_charge_check_failed =>
      'That charge could not be checked.';

  @override
  String get rel_admin_reload_amounts_missing =>
      'Auto-reload amounts were not provided, so they were not changed.';

  @override
  String get rel_admin_plan_required => 'Choose a plan first.';

  @override
  String get rel_admin_plan_scheduled_only =>
      'Only a scheduled plan change can be confirmed from here.';

  @override
  String get rel_admin_billing_refused =>
      'The gateway refused this billing request.';

  @override
  String get rel_admin_request_refused => 'The gateway refused this request.';

  @override
  String get rel_admin_endpoint_answered => 'The endpoint answered.';

  @override
  String get rel_admin_endpoint_no_answer => 'The endpoint did not answer.';

  @override
  String get rel_admin_charge_unknown =>
      'Charge outcome unknown. It may still settle. Check the portal before retrying.';

  @override
  String get rel_admin_connect_before_billing =>
      'Connect the live gateway session before reading billing. Nothing is charged from this page.';

  @override
  String get rel_admin_preset_required => 'Save a preset before applying it.';

  @override
  String get rel_admin_cancel => 'Cancel';

  @override
  String get rel_admin_refresh => 'Refresh';

  @override
  String get rel_admin_credits_and_plans => 'Credits and plans';

  @override
  String get rel_admin_saved => 'Saved';

  @override
  String get rel_admin_name => 'Name';

  @override
  String get rel_admin_base_url => 'Base URL';

  @override
  String get rel_admin_model => 'Model';

  @override
  String get rel_admin_signed_in => 'Signed in';

  @override
  String get rel_admin_not_signed_in => 'Not signed in';

  @override
  String get rel_admin_provider => 'Provider';

  @override
  String get rel_admin_apply_to_this_chat => 'Apply to this chat';

  @override
  String get rel_admin_auto => 'Auto';

  @override
  String get rel_admin_chat_completions => 'Chat Completions';

  @override
  String get rel_admin_codex_responses => 'Codex Responses';

  @override
  String get rel_admin_anthropic_messages => 'Anthropic Messages';

  @override
  String get rel_admin_could_not_complete_that_request =>
      'Could not complete that request.';

  @override
  String get rel_admin_confirm => 'Confirm';

  @override
  String get rel_admin_providers_and_billing => 'Providers and billing';

  @override
  String get rel_admin_api_keys => 'API keys';

  @override
  String get rel_admin_custom_endpoints => 'Custom endpoints';

  @override
  String get rel_admin_provider_accounts => 'Provider accounts';

  @override
  String get rel_admin_effort_and_speed_presets => 'Effort and speed presets';

  @override
  String get rel_admin_delegation => 'Delegation';

  @override
  String get rel_admin_mixture_of_agents => 'Mixture of agents';

  @override
  String get rel_admin_no_provider_keys_were_reported_for_this_profile =>
      'No provider keys were reported for this profile.';

  @override
  String get rel_admin_not_saved => 'Not saved';

  @override
  String get rel_admin_new_key_value => 'New key value';

  @override
  String get rel_admin_provider_key_saved => 'Provider key saved.';

  @override
  String get rel_admin_save_key => 'Save key';

  @override
  String get rel_admin_clear_provider_key => 'Clear provider key';

  @override
  String get rel_admin_provider_key_cleared => 'Provider key cleared.';

  @override
  String get rel_admin_clear_key => 'Clear key';

  @override
  String get rel_admin_new_endpoint => 'New endpoint';

  @override
  String get rel_admin_api_key => 'API key';

  @override
  String get rel_admin_leave_blank_to_keep_a_key_this_endpoint_already_has =>
      'Leave blank to keep a key this endpoint already has.';

  @override
  String get rel_admin_reachable => 'Reachable';

  @override
  String get rel_admin_unreachable => 'Unreachable';

  @override
  String get rel_admin_test_endpoint => 'Test endpoint';

  @override
  String get rel_admin_endpoint_saved => 'Endpoint saved.';

  @override
  String get rel_admin_save_endpoint => 'Save endpoint';

  @override
  String get rel_admin_use_this_endpoint => 'Use this endpoint';

  @override
  String
  get rel_admin_make_this_named_endpoint_the_current_model_for_this_profile =>
      'Make this named endpoint the current model for this profile?';

  @override
  String get rel_admin_endpoint_is_now_current => 'Endpoint is now current.';

  @override
  String get rel_admin_use_endpoint => 'Use endpoint';

  @override
  String get rel_admin_delete_endpoint => 'Delete endpoint';

  @override
  String get rel_admin_delete_this_named_endpoint_from_the_profile =>
      'Delete this named endpoint from the profile?';

  @override
  String get rel_admin_endpoint_deleted => 'Endpoint deleted.';

  @override
  String get rel_admin_signing_in_stays_on_the_provider_sign_in_screen =>
      'Signing in stays on the provider sign-in screen. Disconnect only runs when this gateway says the account can be removed.';

  @override
  String get rel_admin_disconnect_this_provider_account_on_the_gateway =>
      'Disconnect this provider account on the gateway?';

  @override
  String get rel_admin_provider_account_disconnected =>
      'Provider account disconnected.';

  @override
  String get rel_admin_disconnect => 'Disconnect';

  @override
  String get rel_admin_not_disconnectable => 'Not disconnectable';

  @override
  String get rel_admin_fast => 'Fast';

  @override
  String get rel_admin_preset_saved_for_this_model =>
      'Preset saved for this model.';

  @override
  String get rel_admin_save_preset => 'Save preset';

  @override
  String get rel_admin_chat_id => 'Chat id';

  @override
  String get rel_admin_apply_preset => 'Apply preset';

  @override
  String get rel_admin_set_this_chat_s_effort_and_speed_from_the_saved_preset =>
      'Set this chat\'s effort and speed from the saved preset?';

  @override
  String get rel_admin_preset_applied_to_this_chat =>
      'Preset applied to this chat.';

  @override
  String get rel_admin_this_route_sends_the_picked_effort_unchanged =>
      'This route sends the picked effort unchanged.';

  @override
  String get rel_admin_show_route_clamp => 'Show route clamp';

  @override
  String get rel_admin_delegation_backend => 'Delegation backend';

  @override
  String get rel_admin_delegation_backend_saved => 'Delegation backend saved.';

  @override
  String get rel_admin_save_backend => 'Save backend';

  @override
  String get rel_admin_max_iterations => 'Max iterations';

  @override
  String get rel_admin_max_concurrent_children => 'Max concurrent children';

  @override
  String get rel_admin_child_timeout_seconds => 'Child timeout seconds';

  @override
  String get rel_admin_delegation_effort_leave_unchanged =>
      'Delegation effort, leave unchanged';

  @override
  String get rel_admin_delegation_limits_saved => 'Delegation limits saved.';

  @override
  String get rel_admin_save_limits => 'Save limits';

  @override
  String get rel_admin_remove_route => 'Remove route';

  @override
  String get rel_admin_route_name => 'Route name';

  @override
  String get rel_admin_route_provider => 'Route provider';

  @override
  String get rel_admin_route_model => 'Route model';

  @override
  String get rel_admin_route_effort_unchanged => 'Route effort unchanged';

  @override
  String get rel_admin_add_route => 'Add route';

  @override
  String get rel_admin_default_route => 'Default route';

  @override
  String get rel_admin_delegation_routes_saved => 'Delegation routes saved.';

  @override
  String get rel_admin_save_routes => 'Save routes';

  @override
  String get rel_admin_profile_routes_saved => 'Profile routes saved.';

  @override
  String get rel_admin_save_profile_routes => 'Save profile routes';

  @override
  String get rel_admin_no_mixture_is_loaded => 'No mixture is loaded.';

  @override
  String get rel_admin_mixture_enabled => 'Mixture enabled';

  @override
  String get rel_admin_loud_degraded_references => 'Loud degraded references';

  @override
  String get rel_admin_silent_degraded_references =>
      'Silent degraded references';

  @override
  String get rel_admin_aggregator => 'Aggregator';

  @override
  String get rel_admin_aggregator_provider => 'Aggregator provider';

  @override
  String get rel_admin_aggregator_model => 'Aggregator model';

  @override
  String get rel_admin_reference_provider => 'Reference provider';

  @override
  String get rel_admin_reference_model => 'Reference model';

  @override
  String get rel_admin_add_reference_model => 'Add reference model';

  @override
  String get rel_admin_mixture_saved => 'Mixture saved.';

  @override
  String get rel_admin_save_mixture => 'Save mixture';

  @override
  String get rel_admin_credit_purchase_submitted =>
      'Credit purchase submitted.';

  @override
  String get rel_admin_credit_purchase_settled => 'Credit purchase settled.';

  @override
  String get rel_admin_credit_and_plan_changes_wait_for_confirmation_a_plan =>
      'Credit and plan changes wait for confirmation. A plan that would charge immediately is shown and not confirmed here.';

  @override
  String get rel_admin_buy_credits => 'Buy credits';

  @override
  String get rel_admin_retry_same_charge => 'Retry same charge';

  @override
  String get rel_admin_retry_the_same_credit_charge_this_does_not_start =>
      'Retry the same credit charge. This does not start a second purchase.';

  @override
  String get rel_admin_credit_purchases_are_not_available_for_this_account =>
      'Credit purchases are not available for this account.';

  @override
  String get rel_admin_auto_reload => 'Auto-reload';

  @override
  String get rel_admin_read_only_until_this_account_can_charge =>
      'Read-only until this account can charge.';

  @override
  String get rel_admin_auto_reload_updated => 'Auto-reload updated.';

  @override
  String get rel_admin_keep_going_on_credits => 'Keep going on credits';

  @override
  String get rel_admin_continue_on_credits_when_the_plan_window_is_used_up =>
      'Continue on credits when the plan window is used up?';

  @override
  String
  get rel_admin_stop_continuing_on_credits_when_the_plan_window_is_used_up =>
      'Stop continuing on credits when the plan window is used up?';

  @override
  String get rel_admin_credit_continuation_updated =>
      'Credit continuation updated.';

  @override
  String get rel_admin_this_plan_change_is_not_confirmed_from_ares =>
      'This plan change is not confirmed from Ares.';

  @override
  String get rel_admin_this_change_is_scheduled_confirm_to_apply_it =>
      'This change is scheduled. Confirm to apply it.';

  @override
  String get rel_admin_preview_plan => 'Preview plan';

  @override
  String get rel_admin_schedule_plan_change => 'Schedule plan change';

  @override
  String get rel_admin_plan_change_scheduled => 'Plan change scheduled.';

  @override
  String get rel_admin_confirm_scheduled_plan_change =>
      'Confirm scheduled plan change';

  @override
  String rel_admin_remove_key_confirm(String key) {
    return 'Remove the saved $key value from this profile?';
  }

  @override
  String rel_admin_current_endpoint(String name) {
    return '$name · current';
  }

  @override
  String rel_admin_endpoint_result(
    String status,
    String transport,
    String count,
    String message,
  ) {
    return '$status · $transport · $count models. $message';
  }

  @override
  String rel_admin_disconnect_account(String name) {
    return 'Disconnect $name';
  }

  @override
  String rel_admin_delegation_blocked(String reason) {
    return 'Delegation is blocked: $reason';
  }

  @override
  String rel_admin_backend_unavailable(String name) {
    return '$name · unavailable';
  }

  @override
  String rel_admin_reference_number(String number) {
    return 'Reference $number';
  }

  @override
  String rel_admin_reload_enable_confirm(String amount, String threshold) {
    return 'Turn on auto-reload and charge $amount when the balance falls below $threshold?';
  }

  @override
  String rel_admin_reload_disable_confirm(String amount, String threshold) {
    return 'Turn off auto-reload? It currently charges $amount when the balance falls below $threshold.';
  }

  @override
  String get rel_admin_this_plan => 'this plan';

  @override
  String rel_admin_plan_confirm(String name) {
    return 'Schedule $name. It is scheduled for the end of the current period. No charge is made now.';
  }

  @override
  String rel_admin_plan_confirm_price(String name, String price) {
    return 'Schedule $name at $price. It is scheduled for the end of the current period. No charge is made now.';
  }

  @override
  String rel_admin_plan_confirm_when(String name, String when) {
    return 'Schedule $name. It takes effect $when. No charge is made now.';
  }

  @override
  String rel_admin_plan_confirm_price_when(
    String name,
    String price,
    String when,
  ) {
    return 'Schedule $name at $price. It takes effect $when. No charge is made now.';
  }

  @override
  String rel_admin_balance(String amount) {
    return 'Balance $amount';
  }

  @override
  String rel_admin_buy_confirm(String amount) {
    return 'Charge \$$amount to the payment method on this Nous account. This spends real money.';
  }

  @override
  String rel_admin_reload_portal(String url) {
    return 'Change auto-reload on the portal: $url';
  }

  @override
  String rel_admin_team_portal(String url) {
    return 'Team subscriptions are changed on the portal: $url';
  }

  @override
  String get rel_admin_effort_none => 'none';

  @override
  String get rel_admin_effort_minimal => 'minimal';

  @override
  String get rel_admin_effort_low => 'low';

  @override
  String get rel_admin_effort_medium => 'medium';

  @override
  String get rel_admin_effort_high => 'high';

  @override
  String get rel_admin_effort_xhigh => 'xhigh';

  @override
  String get rel_admin_effort_max => 'max';

  @override
  String get rel_admin_effort_ultra => 'ultra';

  @override
  String get rel_admin_auto_lower => 'auto';

  @override
  String get rel_admin_create => 'Create';

  @override
  String get rel_admin_prompt => 'Prompt';

  @override
  String get rel_admin_new_profile_id => 'New profile ID';

  @override
  String get rel_admin_this_operation_is_unavailable_on_this_gateway =>
      'This operation is unavailable on this gateway.';

  @override
  String get rel_admin_access_denied_by_the_gateway =>
      'Access denied by the gateway.';

  @override
  String get rel_admin_connection_changed_reopen_profiles =>
      'Connection changed. Reopen Profiles.';

  @override
  String
  get rel_admin_invalid_input_or_gateway_response_check_the_target_before =>
      'Invalid input or gateway response. Check the target before retrying.';

  @override
  String get rel_admin_could_not_verify_the_result_refresh_the_target_before =>
      'Could not verify the result. Refresh the target before trying again.';

  @override
  String get rel_admin_edit_soul_md => 'Edit SOUL.md';

  @override
  String get rel_admin_persona => 'Persona';

  @override
  String get rel_admin_persona_saved => 'Persona saved.';

  @override
  String get rel_admin_not_set => 'not set';

  @override
  String get rel_admin_enabled => 'Enabled';

  @override
  String get rel_admin_keys_to_remove_comma_separated =>
      'Keys to remove (comma-separated)';

  @override
  String get rel_admin_saved_and_applied_by_the_gateway =>
      'Saved and applied by the gateway.';

  @override
  String get rel_admin_saved_a_gateway_restart_may_be_required =>
      'Saved. A gateway restart may be required.';

  @override
  String get rel_admin_create_signed_route => 'Create signed route';

  @override
  String get rel_admin_route_id => 'Route ID';

  @override
  String get rel_admin_signature => 'Signature';

  @override
  String get rel_admin_events_comma_separated => 'Events (comma-separated)';

  @override
  String get rel_admin_delivery_target => 'Delivery target';

  @override
  String get rel_admin_skills_comma_separated => 'Skills (comma-separated)';

  @override
  String get rel_admin_delivery_mode => 'Delivery mode';

  @override
  String get rel_admin_delivery_chat_id_optional =>
      'Delivery chat ID (optional)';

  @override
  String get rel_admin_hide_signing_secret => 'Hide signing secret';

  @override
  String get rel_admin_reveal_signing_secret => 'Reveal signing secret';

  @override
  String get rel_admin_edit_persona => 'Edit persona';

  @override
  String get rel_admin_portable_profile_bundle => 'Portable profile bundle';

  @override
  String get rel_admin_clone_profile => 'Clone profile';

  @override
  String get rel_admin_rename_display_label => 'Rename display label';

  @override
  String get rel_admin_rename_profile => 'Rename profile';

  @override
  String get rel_admin_new_name => 'New name';

  @override
  String get rel_admin_rename_verified => 'Rename verified.';

  @override
  String get rel_admin_delete_profile => 'Delete profile';

  @override
  String get rel_admin_profile_id_to_delete => 'Profile ID to delete';

  @override
  String get rel_admin_profile_deleted => 'Profile deleted.';

  @override
  String
  get rel_admin_profile_deleted_server_identity_cleanup_is_still_pending =>
      'Profile deleted. Server identity cleanup is still pending.';

  @override
  String get rel_admin_export_profile_archive => 'Export profile archive';

  @override
  String get rel_admin_import_profile_archive => 'Import profile archive';

  @override
  String get rel_admin_import_a_trusted_profile => 'Import a trusted profile';

  @override
  String get rel_admin_absolute_archive_path_on_gateway =>
      'Absolute archive path on gateway';

  @override
  String get rel_admin_messaging_channels => 'Messaging channels';

  @override
  String get rel_admin_dm_pairing_requests => 'DM pairing requests';

  @override
  String get rel_admin_no_pending_or_approved_users =>
      'No pending or approved users.';

  @override
  String get rel_admin_legacy_pairing_no_verifiable_request_id_ask_the_user =>
      'Legacy pairing: no verifiable request ID. Ask the user to pair again.';

  @override
  String get rel_admin_pairing_change_verified => 'Pairing change verified.';

  @override
  String get rel_admin_create_telegram_bot_by_qr => 'Create Telegram bot by QR';

  @override
  String get rel_admin_create_telegram_bot => 'Create Telegram bot';

  @override
  String get rel_admin_bot_name => 'Bot name';

  @override
  String get rel_admin_telegram_bot_creation_qr_code =>
      'Telegram bot creation QR code';

  @override
  String get rel_admin_check_telegram_pairing => 'Check Telegram pairing';

  @override
  String get rel_admin_waiting_for_telegram => 'Waiting for Telegram.';

  @override
  String get rel_admin_apply_telegram_bot => 'Apply Telegram bot';

  @override
  String get rel_admin_allowed_numeric_user_ids => 'Allowed numeric user IDs';

  @override
  String get rel_admin_saved_restart_still_required =>
      'Saved. Restart still required.';

  @override
  String get rel_admin_saved_gateway_restart_requested =>
      'Saved; gateway restart requested.';

  @override
  String get rel_admin_cancel_telegram_setup => 'Cancel Telegram setup';

  @override
  String get rel_admin_inbound_webhooks => 'Inbound webhooks';

  @override
  String get rel_admin_enable_webhook_service => 'Enable webhook service';

  @override
  String get rel_admin_enable_webhooks => 'Enable webhooks';

  @override
  String get rel_admin_enabled_restart_still_required =>
      'Enabled. Restart still required.';

  @override
  String get rel_admin_enabled_restart_requested =>
      'Enabled; restart requested.';

  @override
  String get rel_admin_route_change_verified => 'Route change verified.';

  @override
  String get rel_admin_delete_route => 'Delete route';

  @override
  String get rel_admin_disable_route => 'Disable route';

  @override
  String get rel_admin_enable_route => 'Enable route';

  @override
  String get rel_admin_back_up_entire_agent_home => 'Back up entire agent home';

  @override
  String get rel_admin_transfer_to_a_cloud_agent => 'Transfer to a Cloud agent';

  @override
  String get rel_admin_check_backup_progress => 'Check backup progress';

  @override
  String get rel_admin_save_backup_to_this_device =>
      'Save backup to this device';

  @override
  String get rel_admin_save_sensitive_full_home_archive =>
      'Save sensitive full-home archive';

  @override
  String get rel_admin_save_cancelled => 'Save cancelled.';

  @override
  String get rel_admin_backup_saved => 'Backup saved.';

  @override
  String get rel_admin_up_to_32_mib_larger_archives_remain_on_the_gateway =>
      'Up to 32 MiB. Larger archives remain on the gateway.';

  @override
  String rel_admin_persona_scope(String scope) {
    return 'Save the persona for $scope.';
  }

  @override
  String rel_admin_configure_channel(String name) {
    return 'Configure $name';
  }

  @override
  String rel_admin_channel_warning(String scope) {
    return 'Applies to $scope. Blank keeps an existing value. To remove a value, list its key below.';
  }

  @override
  String rel_admin_hook_warning(String scope) {
    return 'Applies to $scope. Use a unique name. The gateway creates a signing secret. If another operator creates the name simultaneously the host may replace that route.';
  }

  @override
  String rel_admin_hook_created(String url) {
    return 'Created $url. Store the signing secret before leaving.';
  }

  @override
  String rel_admin_clone_warning(String scope) {
    return 'Copy settings, skills, persona and potentially provider credentials from $scope. Messaging tokens are not requested.';
  }

  @override
  String rel_admin_cloned(String source, String destination) {
    return 'Cloned $source to $destination.';
  }

  @override
  String rel_admin_rename_target(String name) {
    return 'Rename $name';
  }

  @override
  String rel_admin_rename_label_warning(String scope) {
    return 'Change the presentation label for $scope. Its ID stays default.';
  }

  @override
  String rel_admin_rename_warning(String scope) {
    return 'Rename $scope on the server. A running gateway may stop.';
  }

  @override
  String rel_admin_delete_target(String name) {
    return 'Delete $name';
  }

  @override
  String rel_admin_delete_profile_warning(String scope) {
    return 'Permanently delete $scope, including sessions and credentials. Type the exact profile ID.';
  }

  @override
  String rel_admin_export_target(String name) {
    return 'Export $name';
  }

  @override
  String rel_admin_export_warning(String scope) {
    return 'Create a .tar.gz on $scope. Known credential stores are excluded, but private data can remain. Review before sharing.';
  }

  @override
  String rel_admin_archive_on(String gateway, String path) {
    return 'Archive on $gateway: $path';
  }

  @override
  String rel_admin_import_warning(String gateway) {
    return 'Use a reviewed .tar.gz already on $gateway. It can contain plugins, scripts and schedules. A new profile ID is required.';
  }

  @override
  String rel_admin_imported(String name) {
    return 'Imported $name.';
  }

  @override
  String rel_admin_approve_user(String user) {
    return 'Approve $user';
  }

  @override
  String rel_admin_revoke_user(String user) {
    return 'Revoke $user';
  }

  @override
  String rel_admin_allow_pair(String platform, String scope) {
    return '$platform on $scope: allow this user’s messaging access.';
  }

  @override
  String rel_admin_remove_pair(String platform, String scope) {
    return '$platform on $scope: remove this user’s messaging access.';
  }

  @override
  String rel_admin_telegram_start(String scope) {
    return 'Start a Telegram pairing on $scope using the gateway’s setup service.';
  }

  @override
  String rel_admin_expires(String time) {
    return 'Expires: $time';
  }

  @override
  String rel_admin_telegram_apply(String bot, String scope) {
    return 'Enable @$bot on $scope and attempt a gateway restart. Only the listed users may message it.';
  }

  @override
  String rel_admin_hooks_enable(String scope) {
    return 'Enable inbound webhooks on $scope and attempt a gateway restart.';
  }

  @override
  String rel_admin_disable_target(String name) {
    return 'Disable $name';
  }

  @override
  String rel_admin_enable_target(String name) {
    return 'Enable $name';
  }

  @override
  String rel_admin_hook_change(String name, String scope) {
    return 'Change exactly $name on $scope.';
  }

  @override
  String rel_admin_backup_warning(String gateway) {
    return 'This is not an Ares settings backup. Save all profiles, sessions and credentials on $gateway. The archive is sensitive.';
  }

  @override
  String rel_admin_backup_started(String gateway) {
    return 'Backup started on $gateway.';
  }

  @override
  String rel_admin_backup_verified(String gateway, String path) {
    return 'Backup verified on $gateway: $path';
  }

  @override
  String rel_admin_backup_running(String gateway) {
    return 'Backup still running on $gateway.';
  }

  @override
  String get rel_admin_choice_yes => 'yes';

  @override
  String get rel_admin_choice_no => 'no';

  @override
  String get rel_admin_choice_generic => 'generic';

  @override
  String get rel_admin_choice_log => 'log';

  @override
  String get rel_admin_choice_email => 'email';

  @override
  String get rel_admin_choice_github_comment => 'github_comment';

  @override
  String get rel_admin_choice_agent => 'Agent processes event';

  @override
  String get rel_admin_choice_direct => 'Direct delivery';

  @override
  String get rel_admin_configured => 'configured';

  @override
  String get rel_admin_state_pending_restart => 'pending_restart';

  @override
  String get rel_admin_state_unknown => 'unknown';

  @override
  String get rel_admin_state_connected => 'connected';

  @override
  String get rel_admin_state_disconnected => 'disconnected';

  @override
  String get rel_admin_state_disabled => 'disabled';

  @override
  String get rel_admin_state_enabled => 'enabled';

  @override
  String get rel_admin_state_running => 'running';

  @override
  String get rel_admin_state_stopped => 'stopped';

  @override
  String get rel_admin_state_error => 'error';

  @override
  String get rel_admin_state_not_configured => 'not_configured';

  @override
  String get rel_admin_state_startup_failed => 'startup_failed';

  @override
  String get rel_admin_state_gateway_stopped => 'gateway_stopped';

  @override
  String get rel_admin_state_connecting => 'connecting';

  @override
  String get rel_admin_state_retrying => 'retrying';

  @override
  String get rel_admin_state_fatal => 'fatal';

  @override
  String get rel_admin_unsupported_or_oversized_profile_archive =>
      'Unsupported or oversized profile archive.';

  @override
  String get rel_admin_current_layout => 'Current layout';

  @override
  String get rel_admin_one_pane => 'One pane';

  @override
  String get rel_admin_stacked => 'Stacked';

  @override
  String get rel_admin_side_by_side => 'Side by side';

  @override
  String get rel_admin_no_supported_appearance_in_this_profile =>
      'No supported appearance in this profile.';

  @override
  String get rel_admin_review_appearance_saved_with_this_profile =>
      'Review appearance saved with this profile';

  @override
  String get rel_admin_applies_only_to_this_named_profile_on_this_device =>
      'Applies only to this named profile on this device. An imported arrangement starts with empty panes; choose its chats yourself.';

  @override
  String get rel_admin_apply_to_this_profile_on_this_device =>
      'Apply to this profile on this device';

  @override
  String get rel_admin_export_prepares_a_tar_gz_on_the_gateway_review =>
      'Export prepares a .tar.gz on the gateway. Review its portable files before saving a copy here. Import opens a local archive for review; opening alone uploads nothing.';

  @override
  String get rel_admin_prepare_profile_export => 'Prepare profile export';

  @override
  String get rel_admin_open_tar_gz_from_this_device =>
      'Open .tar.gz from this device';

  @override
  String get rel_admin_only_selected_text_files_travel_review_for_secrets_and =>
      'Only selected text files travel. Review for secrets and private information. Config, skills and schedules can change what the new profile does.';

  @override
  String get rel_admin_include_this_reviewed_file =>
      'Include this reviewed file';

  @override
  String get rel_admin_apply_appearance_to_the_new_profile_on_this_device =>
      'Apply appearance to the new profile on this device';

  @override
  String
  get rel_admin_imports_colours_and_pane_sizes_never_chats_tools_or_session_ids =>
      'Imports colours and pane sizes, never chats, tools or session IDs.';

  @override
  String
  get rel_admin_the_gateway_retains_a_private_staged_copy_import_creates =>
      'The gateway retains a private staged copy. Import creates a new profile; it will not replace an existing one.';

  @override
  String get rel_admin_appearance_not_applied_the_gateway_did_not_confirm_the =>
      ' Appearance not applied: the gateway did not confirm the reviewed overlay.';

  @override
  String get rel_admin_appearance_applied_on_this_device =>
      ' Appearance applied on this device.';

  @override
  String get rel_admin_appearance_was_not_saved_on_this_device =>
      ' Appearance was not saved on this device.';

  @override
  String get rel_admin_save_reviewed_profile_bundle =>
      'Save reviewed profile bundle';

  @override
  String get rel_admin_profile_bundle_saved => 'Profile bundle saved.';

  @override
  String get rel_admin_import_selected_files => 'Import selected files';

  @override
  String get rel_admin_save_selected_files_to_device =>
      'Save selected files to device';

  @override
  String rel_admin_layout_first_pane(String layout, String percent) {
    return '$layout · $percent% first pane';
  }

  @override
  String rel_admin_appearance_summary(String skin, String mode, String layout) {
    return 'Skin: $skin · Mode: $mode · $layout';
  }

  @override
  String rel_admin_appearance_applied(String gateway, String profile) {
    return 'Appearance applied to $gateway / $profile.';
  }

  @override
  String rel_admin_bundle_summary(
    String profile,
    String count,
    String omitted,
  ) {
    return 'Bundle: $profile · $count reviewable files · $omitted omitted';
  }

  @override
  String rel_admin_imported_on(String name, String gateway) {
    return 'Imported $name on $gateway.';
  }

  @override
  String get rel_admin_unchanged => 'unchanged';

  @override
  String get rel_admin_mode_system => 'system';

  @override
  String get rel_admin_mode_light => 'light';

  @override
  String get rel_admin_mode_dark => 'dark';

  @override
  String get rel_admin_skin_classic => 'classic';

  @override
  String get rel_admin_skin_midnight => 'midnight';

  @override
  String get rel_admin_skin_ember => 'ember';

  @override
  String get rel_admin_skin_mono => 'mono';

  @override
  String get rel_admin_skin_cyberpunk => 'cyberpunk';

  @override
  String get rel_admin_skin_slate => 'slate';

  @override
  String get rel_admin_no_available_cloud_agents_in_this_account =>
      'No available Cloud agents in this account.';

  @override
  String get rel_admin_the_previous_undo_receipt_could_not_be_verified_no =>
      'The previous undo receipt could not be verified. No change was made.';

  @override
  String get rel_admin_transfer_to_cloud => 'Transfer to Cloud';

  @override
  String
  get rel_admin_connection_changed_leave_this_page_a_restore_already_submitted =>
      'Connection changed. Leave this page. A restore already submitted may continue.';

  @override
  String get rel_admin_find_my_cloud_agents => 'Find my Cloud agents';

  @override
  String
  get rel_admin_undo_replaces_the_destination_with_its_pre_transfer_backup =>
      'Undo replaces the destination with its pre-transfer backup.';

  @override
  String get rel_admin_replace_this_cloud_agent_with_the_entire_source_home =>
      'Replace this Cloud agent with the entire source home, including credentials, conversations and files. The source is not deleted. Incoming messaging bots are switched off.';

  @override
  String get rel_admin_type_destination_agent_id => 'Type destination agent ID';

  @override
  String
  get rel_admin_could_not_retain_the_local_undo_receipt_keep_this_page_open =>
      'Could not retain the local undo receipt. Keep this page open.';

  @override
  String get rel_admin_undo_transfer => 'Undo transfer';

  @override
  String get rel_admin_replace_cloud_agent => 'Replace Cloud agent';

  @override
  String
  get rel_admin_local_undo_receipt_forgotten_no_remote_backup_was_removed =>
      'Local undo receipt forgotten. No remote backup was removed.';

  @override
  String get rel_admin_forget_local_undo_receipt_only =>
      'Forget local undo receipt only';

  @override
  String get rel_admin_stop_before_restore => 'Stop before restore';

  @override
  String get rel_admin_do_not_close_this_page_restore_runs_on_the =>
      'Do not close this page. Restore runs on the destination and cannot be cancelled.';

  @override
  String get rel_admin_files_restored_destination_gateway_needs_attention =>
      'Files restored; destination gateway needs attention.';

  @override
  String rel_admin_transfer_sign_in(String origin) {
    return 'Sign in to exactly one saved Ares connection for $origin, then return here.';
  }

  @override
  String rel_admin_transfer_source(String gateway, String profile) {
    return 'Source: $gateway / $profile';
  }

  @override
  String rel_admin_transfer_destination(String name, String origin) {
    return 'Destination: $name · $origin / default';
  }

  @override
  String rel_admin_agent_id(String id) {
    return 'Agent ID: $id';
  }

  @override
  String rel_admin_transfer_status(String phase) {
    return 'Status: $phase';
  }

  @override
  String rel_admin_copied_percent(String percent) {
    return 'Copied $percent%';
  }

  @override
  String rel_admin_undo_point(String path) {
    return 'Undo point on destination: $path';
  }

  @override
  String rel_admin_messaging_disabled(String channels) {
    return 'Messaging disabled: $channels';
  }

  @override
  String get rel_admin_phase_prepared => 'prepared';

  @override
  String get rel_admin_phase_backup => 'backup';

  @override
  String get rel_admin_phase_upload => 'upload';

  @override
  String get rel_admin_phase_restore => 'restore';

  @override
  String get rel_admin_phase_finished => 'finished';

  @override
  String get rel_admin_phase_failed => 'failed';

  @override
  String get rel_admin_phase_undo => 'undo';

  @override
  String get rel_admin_phase_undone => 'undone';

  @override
  String rel_ops_cap_install_blocked(String verdict, String detail) {
    return 'Install blocked ($verdict): $detail';
  }

  @override
  String rel_ops_cap_scan_confirm(String verdict, String requested) {
    return 'Scan verdict: $verdict. Confirm $requested before installing.';
  }

  @override
  String rel_ops_cap_install_unconfirmed(String requested) {
    return 'The gateway has not confirmed that $requested is installed.';
  }

  @override
  String rel_ops_cap_edit_skill(String name) {
    return 'Edit $name';
  }

  @override
  String rel_ops_cap_archive_skill(String name) {
    return 'Archive $name?';
  }

  @override
  String rel_ops_cap_archive_explanation(String command) {
    return 'The skill is archived and can be restored with $command.';
  }

  @override
  String rel_ops_cap_install_anyway(String name) {
    return 'Install $name anyway';
  }

  @override
  String rel_ops_cap_install_despite_scan(String name) {
    return 'Install $name despite the scan?';
  }

  @override
  String rel_ops_cap_scan_warning(String name) {
    return 'The security scan blocked $name. This confirmation applies only to $name.';
  }

  @override
  String rel_ops_cap_accept_scan_warning(String name) {
    return 'Accepting capabilities does not override the scan of $name.';
  }

  @override
  String rel_ops_cap_review_scan(String name) {
    return 'Review scan for $name';
  }

  @override
  String rel_ops_cap_desktop_grants(String description) {
    return '$description\nFolder and preview-script grants stay in the Desktop app on that computer. Removing the plugin here does not revoke those local grants.';
  }

  @override
  String rel_ops_cap_remove_plugin(String name) {
    return 'Remove $name?';
  }

  @override
  String rel_ops_cap_probe_result(String name, String tools) {
    return 'Probe $name: $tools';
  }

  @override
  String rel_ops_cap_save_tool_grants_for(String connector) {
    return 'Save tool grants for $connector';
  }

  @override
  String rel_ops_cap_backends_for(String name) {
    return 'Backends for $name';
  }

  @override
  String rel_ops_cap_use_backend_confirmation(String name) {
    return 'Use $name?';
  }

  @override
  String rel_ops_cap_unlock_source(String name) {
    return 'Unlock $name';
  }

  @override
  String get rel_ops_cap_capabilities => 'Capabilities';

  @override
  String get rel_ops_cap_plugins => 'Plugins';

  @override
  String get rel_ops_cap_connectors => 'Connectors';

  @override
  String get rel_ops_cap_backends => 'Backends';

  @override
  String get rel_ops_cap_save_skill => 'Save skill';

  @override
  String get rel_ops_cap_archive => 'Archive';

  @override
  String get rel_ops_cap_hub_identifier => 'Hub identifier';

  @override
  String get rel_ops_cap_install => 'Install';

  @override
  String get rel_ops_cap_update_all => 'Update all';

  @override
  String get rel_ops_cap_unlock => 'Unlock';

  @override
  String get rel_ops_cap_lock => 'Lock';

  @override
  String get rel_ops_cap_this_update_adds_capabilities_nothing_changed_yet =>
      'This update adds capabilities. Nothing changed yet.';

  @override
  String get rel_ops_cap_the_scan_blocked_this_plugin =>
      'The scan blocked this plugin.';

  @override
  String get rel_ops_cap_the_plugin_was_not_changed =>
      'The plugin was not changed.';

  @override
  String get rel_ops_cap_repository => 'Repository';

  @override
  String get rel_ops_cap_install_plugin => 'Install plugin';

  @override
  String get rel_ops_cap_update_plugins => 'Update plugins';

  @override
  String get rel_ops_cap_accept_capabilities => 'Accept capabilities';

  @override
  String get rel_ops_cap_update => 'Update';

  @override
  String get rel_ops_cap_remove_desktop_half => 'Remove desktop half';

  @override
  String get rel_ops_cap_server_name => 'Server name';

  @override
  String get rel_ops_cap_command => 'Command';

  @override
  String get rel_ops_cap_http_url => 'HTTP URL';

  @override
  String get rel_ops_cap_add_server => 'Add server';

  @override
  String get rel_ops_cap_probe => 'Probe';

  @override
  String get rel_ops_cap_probe_failed => 'Probe failed.';

  @override
  String get rel_ops_cap_logs => 'Logs';

  @override
  String get rel_ops_cap_mcp_log => 'MCP log';

  @override
  String get rel_ops_cap_connector => 'Connector';

  @override
  String get rel_ops_cap_account_alias => 'Account alias';

  @override
  String get rel_ops_cap_link_account => 'Link account';

  @override
  String get rel_ops_cap_remove_account => 'Remove account';

  @override
  String get rel_ops_cap_tool_connector => 'Tool connector';

  @override
  String get rel_ops_cap_load_tools => 'Load tools';

  @override
  String get rel_ops_cap_save_tool_grants => 'Save tool grants';

  @override
  String
  get rel_ops_cap_this_policy_has_no_member_revision_so_tool_grants_stay_unchanged =>
      'This policy has no member revision, so tool grants stay unchanged.';

  @override
  String get rel_ops_cap_active => 'Active';

  @override
  String get rel_ops_cap_use => 'Use';

  @override
  String get rel_ops_cap_run_setup => 'Run setup';

  @override
  String get rel_ops_cap_terminal_backends => 'Terminal backends';

  @override
  String get rel_ops_cap_this_changes_the_terminal_backend_for_this_profile =>
      'This changes the terminal backend for this profile.';

  @override
  String get rel_ops_cap_use_backend => 'Use backend';

  @override
  String get rel_ops_cap_select => 'Select';

  @override
  String get rel_ops_cap_browser_vault => 'Browser vault';

  @override
  String
  get rel_ops_cap_saved_site_logins_addresses_and_cards_passwords_stay_in_the_secure_fields_and_are_not_listed_here =>
      'Saved site logins, addresses and cards. Passwords stay in the secure fields and are not listed here.';

  @override
  String get rel_ops_cap_remove_saved_item => 'Remove saved item';

  @override
  String get rel_ops_cap_delete_this_item => 'Delete this item?';

  @override
  String get rel_ops_cap_unlocked => 'Unlocked';

  @override
  String get rel_ops_cap_locked => 'Locked';

  @override
  String get rel_ops_cap_not_detected => 'Not detected';

  @override
  String get rel_ops_cap_master_password => 'Master password';

  @override
  String get rel_ops_cap_login => 'Login';

  @override
  String get rel_ops_cap_address => 'Address';

  @override
  String get rel_ops_cap_card => 'Card';

  @override
  String get rel_ops_cap_label => 'Label';

  @override
  String get rel_ops_cap_site_origin => 'Site origin';

  @override
  String get rel_ops_cap_identifier => 'Identifier';

  @override
  String get rel_ops_cap_password => 'Password';

  @override
  String get rel_ops_cap_authenticator_key => 'Authenticator key';

  @override
  String get rel_ops_cap_street => 'Street';

  @override
  String get rel_ops_cap_city => 'City';

  @override
  String get rel_ops_cap_postal_code => 'Postal code';

  @override
  String get rel_ops_cap_country => 'Country';

  @override
  String get rel_ops_cap_name_on_card => 'Name on card';

  @override
  String get rel_ops_cap_card_number => 'Card number';

  @override
  String get rel_ops_cap_expiry_month => 'Expiry month';

  @override
  String get rel_ops_cap_expiry_year => 'Expiry year';

  @override
  String get rel_ops_cap_security_code => 'Security code';

  @override
  String get rel_ops_cap_this_gateway_has_no_shared_metrics_consent_method =>
      'This gateway has no shared-metrics consent method.';

  @override
  String get rel_ops_cap_agent_policy => 'Agent policy';

  @override
  String get rel_ops_cap_loading_policy => 'Loading policy';

  @override
  String get rel_ops_cap_approval_timeout => 'Approval timeout';

  @override
  String get rel_ops_cap_confirm_mcp_reloads => 'Confirm MCP reloads';

  @override
  String get rel_ops_cap_command_allowlist => 'Command allowlist';

  @override
  String get rel_ops_cap_file_checkpoints => 'File checkpoints';

  @override
  String get rel_ops_cap_checkpoint_limit => 'Checkpoint limit';

  @override
  String get rel_ops_cap_browser_private_urls => 'Browser private URLs';

  @override
  String get rel_ops_cap_use_my_real_browser_profile =>
      'Use my real browser profile';

  @override
  String get rel_ops_cap_save_policy => 'Save policy';

  @override
  String get rel_ops_cap_shared_metrics_for_this_profile =>
      'Shared metrics for this profile';

  @override
  String get rel_ops_cap_send_shared_metrics => 'Send shared metrics';

  @override
  String get rel_ops_cap_error_enter_a_label => 'Enter a label.';

  @override
  String get rel_ops_cap_error_enter_a_valid_url_like_https_example_com =>
      'Enter a valid URL like https://example.com.';

  @override
  String get rel_ops_cap_error_enter_the_identifier_and_password =>
      'Enter the identifier and password.';

  @override
  String
  get rel_ops_cap_error_enter_the_card_name_number_expiry_and_security_code =>
      'Enter the card name, number, expiry and security code.';

  @override
  String get rel_ops_cap_error_enter_the_street_city_postal_code_and_country =>
      'Enter the street, city, postal code and country.';

  @override
  String
  get rel_ops_cap_error_the_gateway_returned_a_response_that_could_not_be_read =>
      'The gateway returned a response that could not be read.';

  @override
  String rel_ops_cap_error_the_gateway_refused_the_request_status(
    int statusCode,
  ) {
    return 'The gateway refused the request ($statusCode).';
  }

  @override
  String
  rel_ops_cap_error_this_connection_has_no_gateway_socket_so_method_is_unavailable(
    String method,
  ) {
    return 'This connection has no gateway socket, so $method is unavailable.';
  }

  @override
  String get rel_ops_cap_error_choose_a_skill => 'Choose a skill.';

  @override
  String get rel_ops_cap_error_the_skill_text_was_not_returned =>
      'The skill text was not returned.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_saved =>
      'The skill was not saved.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_archived =>
      'The skill was not archived.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_installed =>
      'The skill was not installed.';

  @override
  String get rel_ops_cap_error_skill_updates_did_not_start =>
      'Skill updates did not start.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_removed =>
      'The skill was not removed.';

  @override
  String get rel_ops_cap_error_enter_a_skill_or_plugin_identifier =>
      'Enter a skill or plugin identifier.';

  @override
  String get rel_ops_cap_error_choose_a_plugin => 'Choose a plugin.';

  @override
  String get rel_ops_cap_error_the_plugin_was_not_removed =>
      'The plugin was not removed.';

  @override
  String get rel_ops_cap_error_the_desktop_half_was_not_removed =>
      'The desktop half was not removed.';

  @override
  String
  get rel_ops_cap_error_this_gateway_did_not_give_the_plugin_a_stable_key =>
      'This gateway did not give the plugin a stable key.';

  @override
  String get rel_ops_cap_error_the_plugin_was_not_changed =>
      'The plugin was not changed.';

  @override
  String get rel_ops_cap_error_choose_a_server => 'Choose a server.';

  @override
  String get rel_ops_cap_error_name_the_server => 'Name the server.';

  @override
  String get rel_ops_cap_error_give_the_server_a_command_or_an_http_s_url =>
      'Give the server a command or an http(s) URL.';

  @override
  String get rel_ops_cap_error_choose_a_toolset => 'Choose a toolset.';

  @override
  String get rel_ops_cap_error_tool_backend_status_was_not_returned =>
      'Tool backend status was not returned.';

  @override
  String get rel_ops_cap_error_choose_a_provider => 'Choose a provider.';

  @override
  String get rel_ops_cap_error_this_provider_has_no_setup_action =>
      'This provider has no setup action.';

  @override
  String get rel_ops_cap_error_setup_did_not_start => 'Setup did not start.';

  @override
  String get rel_ops_cap_error_choose_a_terminal_backend =>
      'Choose a terminal backend.';

  @override
  String get rel_ops_cap_error_name_the_connector => 'Name the connector.';

  @override
  String get rel_ops_cap_error_choose_an_account => 'Choose an account.';

  @override
  String
  get rel_ops_cap_error_reload_the_connector_policy_before_changing_tool_grants =>
      'Reload the connector policy before changing tool grants.';

  @override
  String get rel_ops_cap_error_choose_an_item => 'Choose an item.';

  @override
  String get rel_ops_cap_error_choose_a_source => 'Choose a source.';

  @override
  String get rel_ops_cap_error_enter_the_master_password =>
      'Enter the master password.';

  @override
  String get rel_ops_cap_error_gateway_config_was_not_returned =>
      'Gateway config was not returned.';

  @override
  String get rel_ops_cap_error_choose_a_known_approval_mode =>
      'Choose a known approval mode.';

  @override
  String get rel_ops_cap_error_use_a_positive_limit => 'Use a positive limit.';

  @override
  String get rel_ops_cap_error_the_policy_was_not_saved =>
      'The policy was not saved.';

  @override
  String get rel_ops_cap_value_manual => 'manual';

  @override
  String get rel_ops_cap_value_smart => 'smart';

  @override
  String get rel_ops_cap_value_off => 'off';

  @override
  String get rel_ops_cap_value_safe => 'safe';

  @override
  String get rel_ops_cap_value_caution => 'caution';

  @override
  String get rel_ops_cap_value_dangerous => 'dangerous';

  @override
  String get rel_ops_cap_value_blocked => 'blocked';

  @override
  String get rel_ops_cap_value_clean => 'clean';

  @override
  String get rel_ops_cap_value_ready => 'ready';

  @override
  String get rel_ops_cap_value_available => 'available';

  @override
  String get rel_ops_cap_value_unavailable => 'unavailable';

  @override
  String get rel_ops_cap_value_enabled => 'enabled';

  @override
  String get rel_ops_cap_value_disabled => 'disabled';

  @override
  String get rel_ops_cap_value_active => 'active';

  @override
  String get rel_ops_cap_value_inactive => 'inactive';

  @override
  String get rel_ops_cap_value_installed => 'installed';

  @override
  String get rel_ops_cap_value_missing => 'missing';

  @override
  String get rel_ops_cap_value_configured => 'configured';

  @override
  String get rel_ops_cap_value_not_configured => 'not_configured';

  @override
  String get rel_ops_cap_value_error => 'error';

  @override
  String get rel_ops_cap_value_unknown => 'unknown';

  @override
  String get rel_ops_cap_value_login => 'login';

  @override
  String get rel_ops_cap_value_address => 'address';

  @override
  String get rel_ops_cap_value_payment => 'payment';

  @override
  String get rel_ops_term_connecting => 'Connecting…';

  @override
  String get rel_ops_term_unbound =>
      'No matching live session or host working directory. Open the owning chat first.';

  @override
  String get rel_ops_term_unsupported =>
      'This gateway does not offer this terminal capability. No local shell was started.';

  @override
  String get rel_ops_term_local_pty_unavailable =>
      'The packaged local PTY is unavailable on this device.';

  @override
  String get rel_ops_term_operation_failed =>
      'Could not open or control the terminal. Check the host, credentials and fingerprint. No fallback shell was started.';

  @override
  String get rel_ops_term_input_refused =>
      'Input refused. Reopen the originating chat.';

  @override
  String get rel_ops_term_cancel => 'Cancel';

  @override
  String get rel_ops_term_confirm => 'Confirm';

  @override
  String get rel_ops_term_open_device_title => 'Open a shell on this device?';

  @override
  String get rel_ops_term_ssh_shell => 'SSH shell';

  @override
  String get rel_ops_term_local_shell => 'Local shell';

  @override
  String get rel_ops_term_connection_lost => 'Connection lost';

  @override
  String get rel_ops_term_shell_ended => 'Shell ended';

  @override
  String get rel_ops_term_no_owner =>
      'This chat has no authenticated gateway terminal owner. A URL or Cloud login alone does not grant a shell.';

  @override
  String get rel_ops_term_open_gateway_title => 'Open a gateway shell?';

  @override
  String get rel_ops_term_shell_expired => 'Shell ended or expired';

  @override
  String get rel_ops_term_disconnected => 'Disconnected';

  @override
  String get rel_ops_term_gateway_shell => 'Gateway shell';

  @override
  String get rel_ops_term_close_body =>
      'End this shell. To keep it running, hide the pane instead.';

  @override
  String get rel_ops_term_closing => 'Closing…';

  @override
  String get rel_ops_term_close_unconfirmed => 'Close not confirmed';

  @override
  String get rel_ops_term_processes_require_chat =>
      'Agent processes require the authenticated owning chat.';

  @override
  String get rel_ops_term_watching_processes =>
      'Watching this chat’s agent processes. Closing a mirror never stops its process.';

  @override
  String get rel_ops_term_paste_limit => 'Paste is limited to 16 KiB.';

  @override
  String get rel_ops_term_paste => 'Paste';

  @override
  String get rel_ops_term_select_first => 'Select terminal output first.';

  @override
  String get rel_ops_term_open_chat_to_insert =>
      'Open the originating chat before inserting output.';

  @override
  String get rel_ops_term_added_to_draft =>
      'Added to the originating chat draft. Nothing was sent.';

  @override
  String get rel_ops_term_close => 'Close';

  @override
  String get rel_ops_term_add_selection => 'Add selection to chat draft';

  @override
  String get rel_ops_term_new_terminal => 'New terminal';

  @override
  String get rel_ops_term_gateway_terminal => 'Gateway host terminal';

  @override
  String get rel_ops_term_verified_ssh_terminal => 'Verified SSH terminal';

  @override
  String get rel_ops_term_device_local_shell => 'This device (local shell)';

  @override
  String get rel_ops_term_local_unavailable_mobile =>
      'Local shell unavailable on mobile';

  @override
  String get rel_ops_term_watch_processes => 'Watch agent processes';

  @override
  String get rel_ops_term_select_output => 'Select or copy output';

  @override
  String get rel_ops_term_add_selected_output =>
      'Add selected output to chat draft';

  @override
  String get rel_ops_term_review_paste => 'Review clipboard paste';

  @override
  String get rel_ops_term_reconnect => 'Reconnect same shell';

  @override
  String get rel_ops_term_close_mirror => 'Close mirror';

  @override
  String get rel_ops_term_close_shell => 'Close shell';

  @override
  String get rel_ops_term_empty =>
      'Choose + to open a terminal. No shell starts automatically.';

  @override
  String get rel_ops_term_reason_stale => 'stale';

  @override
  String get rel_ops_term_reason_mismatch => 'mismatch';

  @override
  String get rel_ops_term_reason_unbound => 'unbound';

  @override
  String get rel_ops_term_reason_unsupported => 'unsupported';

  @override
  String get rel_ops_term_reason_denied => 'denied';

  @override
  String get rel_ops_term_reason_ineligible => 'ineligible';

  @override
  String get rel_ops_term_reason_unavailable => 'unavailable';

  @override
  String get rel_ops_term_reason_invalid => 'invalid';

  @override
  String get rel_ops_term_reason_insecure => 'insecure';

  @override
  String rel_ops_term_refused(String reason) {
    return 'Gateway refused this terminal operation ($reason).';
  }

  @override
  String rel_ops_term_open_device_body(String connection) {
    return 'This is the Ares device, not $connection. The shell uses your app permissions and starts in app storage.';
  }

  @override
  String rel_ops_term_open_gateway_body(String host) {
    return 'Start a shell on $host in the verified chat working directory. This is not a device shell.';
  }

  @override
  String rel_ops_term_close_tab_title(String label) {
    return 'Close $label?';
  }

  @override
  String rel_ops_term_read_only_status(String status) {
    return 'Read-only · $status';
  }

  @override
  String rel_ops_term_paste_title(String label) {
    return 'Paste into $label?';
  }

  @override
  String rel_ops_term_output_title(String label) {
    return 'Output · $label';
  }

  @override
  String rel_ops_term_mirror_status(String label) {
    return 'Read-only process mirror · $label';
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
    return 'This device · $number';
  }

  @override
  String rel_ops_term_gateway_tab(String host, int number) {
    return 'Gateway $host · $number';
  }

  @override
  String get rel_ops_term_earlier_output_trimmed => '[Earlier output trimmed]';

  @override
  String get rel_ops_term_ssh_dialog_title => 'Open a verified SSH terminal';

  @override
  String get rel_ops_term_ssh_dialog_body =>
      'Use a fingerprint obtained independently from the host administrator. This opens a new remote login, not the gateway or a local shell.';

  @override
  String get rel_ops_term_ssh_host => 'SSH host';

  @override
  String get rel_ops_term_ssh_port => 'Port';

  @override
  String get rel_ops_term_ssh_user => 'User';

  @override
  String get rel_ops_term_ssh_fingerprint => 'Host key fingerprint (SHA256:…)';

  @override
  String get rel_ops_term_ssh_password => 'SSH password (not saved)';

  @override
  String get rel_ops_term_connect => 'Connect';

  @override
  String get rel_ops_ssh_invalid_destination =>
      'Invalid SSH host, port or user.';

  @override
  String get rel_ops_ssh_public_key_required =>
      'An OpenSSH Ed25519 public host key is required.';

  @override
  String get rel_ops_ssh_invalid_public_key => 'Invalid Ed25519 host key.';

  @override
  String get rel_ops_ssh_invalid_saved_key => 'Invalid saved host key.';

  @override
  String get rel_ops_ssh_enrollment_unverified =>
      'Could not verify host-key enrollment.';

  @override
  String get rel_ops_ssh_different_key_pinned =>
      'A different key is already pinned. Verify the change separately.';

  @override
  String get rel_ops_ssh_open_ssh_unavailable =>
      'System OpenSSH is unavailable.';

  @override
  String get rel_ops_ssh_confirm_host_key =>
      'Confirm the host key before connecting.';

  @override
  String get rel_ops_ssh_absolute_identity_required =>
      'Select an absolute identity file.';

  @override
  String get rel_ops_ssh_invalid_remote_port => 'Invalid remote port.';

  @override
  String get rel_ops_ssh_preview_too_large =>
      'Preview exceeds the 64 KiB limit.';

  @override
  String get rel_ops_ssh_connection_refused =>
      'SSH connection refused. Check the enrolled host key, identity and service.';

  @override
  String get rel_ops_ssh_http_not_ok =>
      'The remote service did not return HTTP 200.';

  @override
  String get rel_ops_ssh_encoded_response =>
      'Encoded responses are not supported by this preview.';

  @override
  String get rel_ops_ssh_preview_type_unsupported =>
      'Only text and HTML source can be previewed.';

  @override
  String get rel_ops_ssh_health_unconfirmed =>
      'The service did not confirm gateway health.';

  @override
  String get rel_ops_ssh_enroll_host_key_first =>
      'Enroll the host’s public key first.';

  @override
  String get rel_ops_ssh_cancel => 'Cancel';

  @override
  String get rel_ops_ssh_confirm => 'Confirm';

  @override
  String get rel_ops_ssh_pin_title => 'Pin this SSH host key?';

  @override
  String rel_ops_ssh_pin_detail(String destination, String fingerprint) {
    return '$destination\n$fingerprint\nCompare this fingerprint with the host administrator over an independent channel. No connection will be made.';
  }

  @override
  String get rel_ops_ssh_host_key_pinned => 'Host key pinned.';

  @override
  String get rel_ops_ssh_shell_detail => 'Open an interactive login shell.';

  @override
  String rel_ops_ssh_read_detail(String path, int port) {
    return 'Read $path on remote 127.0.0.1:$port through an SSH channel.';
  }

  @override
  String rel_ops_ssh_connect_title(String destination) {
    return 'Connect to $destination?';
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
  String get rel_ops_ssh_agent_auth => 'Authenticate with your SSH agent.';

  @override
  String get rel_ops_ssh_identity_auth => 'Use the selected identity file.';

  @override
  String rel_ops_ssh_gateway_responding(int port) {
    return 'Gateway is responding on remote loopback port $port.';
  }

  @override
  String get rel_ops_ssh_session_closed => 'SSH session closed.';

  @override
  String get rel_ops_ssh_session_unclean =>
      'SSH session ended without a clean exit.';

  @override
  String get rel_ops_ssh_operation_failed =>
      'SSH operation failed. Check the destination and identity.';

  @override
  String get rel_ops_ssh_title => 'Verified SSH';

  @override
  String get rel_ops_ssh_unsupported =>
      'This device has no supported system OpenSSH transport. The pinned gateway relay automatically accepts new keys and cannot be used for verified enrollment.';

  @override
  String get rel_ops_ssh_host => 'SSH host';

  @override
  String get rel_ops_ssh_port => 'SSH port';

  @override
  String get rel_ops_ssh_user => 'SSH user';

  @override
  String get rel_ops_ssh_identity =>
      'Identity file (optional; otherwise use SSH agent)';

  @override
  String get rel_ops_ssh_public_key =>
      'Public host key from administrator (ssh-ed25519)';

  @override
  String get rel_ops_ssh_review_key => 'Review host key';

  @override
  String get rel_ops_ssh_remote_port => 'Remote loopback service port';

  @override
  String get rel_ops_ssh_check_gateway => 'Check gateway over SSH';

  @override
  String get rel_ops_ssh_preview_source => 'Preview source over SSH';

  @override
  String get rel_ops_ssh_open_shell => 'Open SSH shell';

  @override
  String get rel_ops_ssh_shell_line => 'Line to remote shell';

  @override
  String get rel_ops_ssh_disconnect => 'Disconnect shell';

  @override
  String get rel_ops_host_cancel => 'Cancel';

  @override
  String get rel_ops_host_confirm => 'Confirm';

  @override
  String get rel_ops_host_title => 'Host';

  @override
  String get rel_ops_host_refresh => 'Refresh';

  @override
  String get rel_ops_host_update => 'Update remote Hermes';

  @override
  String rel_ops_host_update_confirmation(String profile) {
    return 'This starts an in-place update on the gateway host for $profile. It does not update Ares on this device. Success is the matching update receipt, not the host staying reachable.';
  }

  @override
  String get rel_ops_host_update_awaiting =>
      'Awaiting matching receipt. Update is still running.';

  @override
  String get rel_ops_host_receipt_success => 'Update receipt succeeded.';

  @override
  String get rel_ops_host_receipt_partial =>
      'Update committed, with follow-up steps still owed.';

  @override
  String get rel_ops_host_receipt_failed => 'Update receipt failed.';

  @override
  String get rel_ops_host_receipt_refused => 'Update receipt refused.';

  @override
  String get rel_ops_host_update_running => 'Update is still running.';

  @override
  String get rel_ops_host_update_unknown =>
      'Update outcome is unknown. A live gateway is not a successful update.';

  @override
  String get rel_ops_host_default_profile => 'the gateway default';

  @override
  String get rel_ops_host_restart => 'Restart remote gateway';

  @override
  String rel_ops_host_restart_shared_confirmation(String profiles) {
    return 'This restarts the gateway shared by $profiles. Live turns on this gateway are interrupted. Reconnect afterwards. Reachability is not proof the restart finished.';
  }

  @override
  String rel_ops_host_restart_confirmation(String profile) {
    return 'This restarts the remote gateway for $profile. Live turns on this gateway are interrupted. Reconnect afterwards.';
  }

  @override
  String get rel_ops_host_restart_running =>
      'Restart command is still running.';

  @override
  String get rel_ops_host_restart_finished =>
      'Restart command finished. Reconnect to the host yourself.';

  @override
  String get rel_ops_host_restart_failed => 'Restart command failed.';

  @override
  String rel_ops_host_maintenance_running(String name) {
    return '$name is still running';
  }

  @override
  String rel_ops_host_maintenance_finished(String name) {
    return '$name finished';
  }

  @override
  String rel_ops_host_maintenance_failed(String name) {
    return '$name failed';
  }

  @override
  String get rel_ops_host_curator_paused_result => 'Curator paused.';

  @override
  String get rel_ops_host_curator_resumed_result => 'Curator resumed.';

  @override
  String get rel_ops_host_reset => 'Reset remote memory files';

  @override
  String rel_ops_host_reset_confirmation(String targetName, String profile) {
    return 'Delete the $targetName memory file on $profile? This cannot be undone from Ares.';
  }

  @override
  String rel_ops_host_reset_result(String targetName, int count) {
    return 'Reset $targetName. Removed $count remote file(s).';
  }

  @override
  String get rel_ops_host_share_not_redacted =>
      'The host did not confirm the bundle was redacted. No link is shown.';

  @override
  String rel_ops_host_scope(String connection, String profile) {
    return 'These controls operate the remote gateway $connection for $profile, not this device and not the Ares client update.';
  }

  @override
  String rel_ops_host_health_running(String version, int count) {
    return 'Gateway process running $version · $count sessions';
  }

  @override
  String rel_ops_host_health_stopped(String version, int count) {
    return 'Gateway process stopped $version · $count sessions';
  }

  @override
  String rel_ops_host_heartbeat_stale(num seconds) {
    return 'Host heartbeat is stale (${seconds}s).';
  }

  @override
  String get rel_ops_host_doctor => 'Run Doctor';

  @override
  String get rel_ops_host_security_audit => 'Security audit';

  @override
  String get rel_ops_host_check_receipt => 'Check update receipt';

  @override
  String get rel_ops_host_logs => 'Remote host logs';

  @override
  String get rel_ops_host_search_logs => 'Search host logs';

  @override
  String get rel_ops_host_driver => 'Remote host driver';

  @override
  String get rel_ops_host_driver_scope =>
      'Computer Use readiness is the gateway machine\'s driver and OS permissions, not this device.';

  @override
  String rel_ops_host_computer_status(
    String platform,
    String installed,
    String ready,
  ) {
    return '$platform · installed $installed · ready $ready';
  }

  @override
  String get rel_ops_host_null => 'null';

  @override
  String get rel_ops_host_true => 'true';

  @override
  String get rel_ops_host_false => 'false';

  @override
  String get rel_ops_host_curator => 'Curator';

  @override
  String get rel_ops_host_curator_paused => 'Curator paused';

  @override
  String get rel_ops_host_curator_running => 'Curator running';

  @override
  String get rel_ops_host_no_run => 'No completed run';

  @override
  String get rel_ops_host_run_curator => 'Run Curator now';

  @override
  String get rel_ops_host_reset_memory => 'Reset memory file';

  @override
  String get rel_ops_host_reset_user => 'Reset user file';

  @override
  String get rel_ops_host_reset_both => 'Reset both files';

  @override
  String get rel_ops_host_share_consent =>
      'I agree to upload a redacted diagnostic bundle from the remote host';

  @override
  String get rel_ops_host_share => 'Share redacted diagnostics';

  @override
  String get rel_ops_host_update_unknown_installation =>
      'This installation is unknown, so the update was not sent';

  @override
  String get rel_ops_host_update_busy_installation =>
      'A chat on this installation is running';

  @override
  String get rel_ops_host_update_refused => 'Remote update refused';

  @override
  String get rel_ops_host_error_stale => 'Remote workspace: stale';

  @override
  String get rel_ops_host_error_mismatch => 'Remote workspace: mismatch';

  @override
  String get rel_ops_host_error_unbound => 'Remote workspace: unbound';

  @override
  String get rel_ops_host_error_unsupported => 'Remote workspace: unsupported';

  @override
  String get rel_ops_host_error_denied => 'Remote workspace: denied';

  @override
  String get rel_ops_host_error_ineligible => 'Remote workspace: ineligible';

  @override
  String get rel_ops_host_error_unavailable => 'Remote workspace: unavailable';

  @override
  String get rel_ops_host_error_invalid => 'Remote workspace: invalid';

  @override
  String get rel_ops_host_error_insecure => 'Remote workspace: insecure';

  @override
  String get rel_ops_host_error_request => 'Could not complete that request.';

  @override
  String get rel_svc_push_api_select_sessions =>
      'Select 1–128 durable session IDs, each 1–200 ASCII characters using only letters, digits, _ . : @ or -. Remove blank IDs and whitespace.';

  @override
  String get rel_svc_push_api_unavailable =>
      'Mobile push is unavailable on this server.';

  @override
  String get rel_svc_push_api_invalid_vapid =>
      'Invalid server VAPID public key.';

  @override
  String get rel_svc_push_api_update_plugin =>
      'This server needs an updated mobile-push plugin for automatic subscriptions.';

  @override
  String get rel_svc_push_status_android_only => 'Android only';

  @override
  String get rel_svc_push_native_prefs_sync_failed =>
      'Native notification preferences could not be synchronized.';

  @override
  String get rel_svc_push_choose_android_connection =>
      'Choose a saved connection on Android first.';

  @override
  String get rel_svc_push_status_checking_authorization =>
      'Checking server authorization';

  @override
  String get rel_svc_push_revoke_persist_failed =>
      'Could not persist revocation. Retry disabling before leaving the app.';

  @override
  String get rel_svc_push_status_off_api_ready => 'Off; server API ready';

  @override
  String get rel_svc_push_status_off_revoke_pending =>
      'Off; server revocation pending';

  @override
  String get rel_svc_push_status_off_connection_changed =>
      'Off; saved connection changed';

  @override
  String get rel_svc_push_status_pending_endpoint =>
      'Pending distributor endpoint';

  @override
  String get rel_svc_push_status_registering => 'Registering';

  @override
  String get rel_svc_push_status_pending_challenge =>
      'Pending encrypted challenge (waiting for silent server verification push)';

  @override
  String get rel_svc_push_allow_android_notifications_retry =>
      'Allow Android notifications in system settings, then retry.';

  @override
  String get rel_svc_push_plugin_invalid =>
      'The server mobile-push plugin is unavailable, outdated, or returned an invalid subscription response. Ask the operator to update it, then retry.';

  @override
  String get rel_svc_push_transport_unavailable =>
      'No push transport is available. Built-in delivery needs working Google Play Services; alternatively install a UnifiedPush distributor and retry.';

  @override
  String get rel_svc_push_transport_choice =>
      'Several UnifiedPush distributors are available. Choose one in Advanced transport, then retry.';

  @override
  String get rel_svc_push_transport_missing =>
      'The selected UnifiedPush distributor is unavailable. Restore it or choose another in Advanced transport.';

  @override
  String get rel_svc_push_companion_unavailable =>
      'The server mobile-push companion is unavailable. It may be missing or disabled, or this connection may point to the wrong dashboard. Install or enable the companion on the server, check the dashboard connection, then refresh. See Server setup guide above.';

  @override
  String get rel_svc_push_server_denied =>
      'Server denied mobile push. Ask the operator to authorize this principal and these sessions.';

  @override
  String get rel_svc_push_not_ready =>
      'Mobile push is not ready. Check server plugin authorization, distributor and network, then retry.';

  @override
  String get rel_svc_push_availability_read_failed =>
      'Unable to read Android push availability. Retry below.';

  @override
  String get rel_svc_push_setup_failed =>
      'Push setup failed. Check Android permission, server authorization and transport, then retry.';

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
    return 'Status: Bound to $bound (not active for $connection; handshake: $status)';
  }

  @override
  String get rel_svc_push_another_saved_connection =>
      'another saved connection';

  @override
  String get rel_svc_push_background_notifications =>
      'Background notifications';

  @override
  String rel_svc_push_bound_subtitle(String bound, String connection) {
    return 'Bound to $bound — revoke that binding below before enabling for $connection';
  }

  @override
  String rel_svc_push_private_activity(String connection) {
    return 'Private server activity for $connection';
  }

  @override
  String rel_svc_push_bound_warning_named(String bound) {
    return 'Bound to another saved connection ($bound). Disable and revoke that binding before enabling for this connection.';
  }

  @override
  String get rel_svc_push_bound_warning =>
      'Bound to another saved connection. Disable and revoke that binding before enabling for this connection.';

  @override
  String get rel_svc_push_local_notifications_muted =>
      'Local notifications are turned off above. Background notification consent is unchanged, but ordinary background activity hints are muted until \"Enable notifications\" is turned on.';

  @override
  String rel_svc_push_legacy_subscription(int count) {
    return 'Legacy subscription: $count selected session(s) only. It will not expand automatically. Turn off, then on to opt in to server-authorized sessions.';
  }

  @override
  String get rel_svc_push_authorized_binding =>
      'Bound only to this saved connection and profile. Session access follows current server authorization.';

  @override
  String get rel_svc_push_revocation_pending =>
      'Server revocation pending. Local delivery is off; retry while the original saved login is available.';

  @override
  String get rel_svc_push_refresh_retry => 'Refresh / retry';

  @override
  String rel_svc_push_disable_named(String bound) {
    return 'Disable and revoke $bound';
  }

  @override
  String get rel_svc_push_other_connection => 'other connection';

  @override
  String get rel_svc_push_disable => 'Disable and revoke';

  @override
  String get rel_svc_push_refresh_explanation =>
      'Refresh / retry rechecks availability after server setup; it cannot install the companion. Enabling notifications remains a separate choice.';

  @override
  String get rel_svc_push_companion_required =>
      'Background notifications require a separately installed and enabled server-side mobile-push companion. Android cannot install it. Updating the APK alone does not set up the server.';

  @override
  String get rel_svc_push_server_setup_guide => 'Server setup guide';

  @override
  String get rel_svc_push_enable_disclosure =>
      'Enable to request Android notification permission and share this installation’s endpoint and encryption keys with this server. Encrypted activity hints contain no chat content. Only sessions authorized by your server login are included.';

  @override
  String get rel_svc_push_transport_disclosure =>
      'Built-in delivery uses Google’s push transport and needs Google Play Services, but includes no Firebase SDK. An optional UnifiedPush distributor can be used instead. Delivery is best-effort; reopen Hermes to reconcile.';

  @override
  String get rel_svc_push_advanced_transport => 'Advanced transport';

  @override
  String get rel_svc_push_automatic_explanation =>
      'Automatic preserves an existing distributor choice, otherwise uses built-in Google delivery when available. Disable before changing transport.';

  @override
  String get rel_svc_push_transport_label => 'Push transport';

  @override
  String get rel_svc_push_automatic_recommended => 'Automatic (recommended)';

  @override
  String get rel_svc_push_selected_unavailable =>
      'Selected distributor (unavailable)';

  @override
  String get rel_svc_push_no_transport_detected =>
      'No available transport detected. Built-in delivery needs Google Play Services; without it, install and configure a UnifiedPush distributor, then refresh.';

  @override
  String get rel_svc_push_channel_turns_name => 'Ares Turns';

  @override
  String get rel_svc_push_channel_turns_description =>
      'Notifications for completed background turns';

  @override
  String get rel_svc_push_channel_attention_name => 'Ares Attention';

  @override
  String get rel_svc_push_channel_attention_description =>
      'Approvals and input requests that need you';

  @override
  String get rel_svc_push_channel_background_name => 'Ares Background';

  @override
  String get rel_svc_push_channel_background_description =>
      'Background task completions';

  @override
  String get rel_svc_push_channel_notices_name => 'Ares Notices';

  @override
  String get rel_svc_push_channel_notices_description =>
      'Credit and plugin notices';

  @override
  String get rel_svc_push_diag_not_initialised => 'not initialised';

  @override
  String get rel_svc_push_diag_replies_off => 'replies are off';

  @override
  String get rel_svc_push_diag_conversation => 'conversation';

  @override
  String get rel_svc_push_diag_conversation_permission_denied =>
      'conversation; permission denied';

  @override
  String rel_svc_push_diag_conversation_error(String error) {
    return 'conversation: $error';
  }

  @override
  String get rel_svc_push_diag_failures_off => 'failures are off';

  @override
  String rel_svc_push_diag_kind_off(String kind) {
    return '$kind is off';
  }

  @override
  String get rel_svc_push_diag_windows_setting_unknown =>
      'Windows did not report its notification setting';

  @override
  String get rel_svc_backup_not_hermes_configuration_backup =>
      'This file is not a Hermes configuration backup.';

  @override
  String get rel_svc_backup_newer_version_cannot_import =>
      'This backup was made by a newer version of the app and cannot be imported.';

  @override
  String get rel_svc_backup_missing_client_certificate =>
      'This backup claims a client certificate for a connection but does not contain it, so a complete restore is not possible.';

  @override
  String get rel_svc_backup_damaged_unreadable =>
      'This backup file is damaged and could not be read.';

  @override
  String get rel_svc_backup_unsupported_preference_type =>
      'A saved preference has an unsupported type and cannot be exported.';

  @override
  String get rel_svc_backup_choose_passphrase_api_keys =>
      'Choose a passphrase — the backup contains your API keys.';

  @override
  String get rel_svc_backup_could_not_protect_safely =>
      'The backup could not be protected safely.';

  @override
  String get rel_svc_backup_unsupported_encryption =>
      'This backup uses an unsupported encryption scheme.';

  @override
  String get rel_svc_backup_wrong_passphrase_or_altered =>
      'Wrong passphrase, or this backup file has been altered.';

  @override
  String get rel_svc_backup_share_subject => 'Hermes configuration backup';

  @override
  String get rel_svc_backup_selected_file_unreadable =>
      'That file could not be read.';

  @override
  String rel_svc_backup_connections_added(int count) {
    return '$count added';
  }

  @override
  String rel_svc_backup_connections_updated(int count) {
    return '$count updated';
  }

  @override
  String rel_svc_backup_connections_removed(int count) {
    return '$count removed';
  }

  @override
  String get rel_svc_backup_no_connection_changes => 'No connection changes';

  @override
  String rel_svc_backup_connections_summary(String changes) {
    return 'Connections: $changes';
  }

  @override
  String rel_svc_backup_restore_summary(String connections, int count) {
    return '$connections · $count settings restored';
  }

  @override
  String rel_svc_backup_certificate_not_included(String label, String error) {
    return 'The client certificate for \"$label\" could not be included in this backup: $error';
  }

  @override
  String get rel_svc_backup_certificate_password_needed =>
      'This certificate needs its password. Enter it below and it will open automatically.';

  @override
  String get rel_svc_backup_certificate_password_or_corrupt =>
      'The certificate password is incorrect, or the file is corrupted.';

  @override
  String get rel_svc_backup_certificate_password_incorrect =>
      'The certificate password is incorrect.';

  @override
  String get rel_svc_backup_certificate_unsupported_encryption =>
      'This certificate uses an encryption method the app cannot read.';

  @override
  String get rel_svc_backup_certificate_unreadable_pkcs12 =>
      'The selected file is not a readable PKCS#12 (.p12/.pfx) certificate.';

  @override
  String get rel_svc_backup_certificate_unreadable =>
      'The selected certificate could not be read.';

  @override
  String get rel_svc_backup_not_certificate_file =>
      'That file is not a certificate: pick a .p12/.pfx container or PEM certificate and key files.';

  @override
  String get rel_svc_backup_not_pem_certificate =>
      'The selected certificate is not a PEM certificate.';

  @override
  String get rel_svc_backup_not_pem_private_key =>
      'The selected private key is not a PEM private key.';

  @override
  String get rel_svc_backup_certificate_pair_unloadable =>
      'The selected certificate and private key could not be loaded.';

  @override
  String get rel_svc_backup_saved_certificate_files_unreadable =>
      'The saved client certificate files could not be read.';

  @override
  String get rel_svc_backup_client_certificate_storage_failed =>
      'The client certificate could not be stored securely on this device.';

  @override
  String get rel_svc_backup_certificate_storage_failed =>
      'The certificate could not be stored securely on this device.';

  @override
  String get rel_svc_backup_client_certificate_label => 'Client certificate';

  @override
  String rel_svc_backup_search_dashboard_unreachable(String error) {
    return 'Could not reach the dashboard: $error';
  }

  @override
  String get rel_svc_backup_search_credentials_rejected =>
      'The dashboard rejected the saved credentials. Check the dashboard username and password for this connection.';

  @override
  String get rel_svc_backup_search_not_supported =>
      'This dashboard does not expose session search. Update Hermes on the host, or switch back to on-device search.';

  @override
  String rel_svc_backup_search_redirected(int statusCode) {
    return 'The dashboard redirected session search (HTTP $statusCode). Ares does not follow redirects with saved credentials; check the connection address.';
  }

  @override
  String rel_svc_backup_search_http_failed(int statusCode) {
    return 'Session search failed with HTTP $statusCode.';
  }

  @override
  String get rel_svc_backup_search_malformed_response =>
      'The dashboard returned a malformed search response.';

  @override
  String get rel_svc_backup_search_unexpected_response =>
      'The dashboard returned an unexpected search response.';

  @override
  String get rel_svc_backup_search_too_many_results =>
      'The dashboard returned more search results than requested.';

  @override
  String get rel_svc_backup_message_search_unexpected_response =>
      'Unexpected message search response.';

  @override
  String get rel_svc_backup_message_search_unexpected_result =>
      'Unexpected message search result.';

  @override
  String get rel_svc_backup_ai_search_api_key_rejected =>
      'The Hermes API rejected the saved API key.';

  @override
  String rel_svc_backup_ai_search_http_failed(int statusCode) {
    return 'AI query rewrite failed with HTTP $statusCode.';
  }

  @override
  String get rel_svc_backup_ai_search_no_usable_query =>
      'The selected model returned no usable search query.';

  @override
  String get rel_svc_backup_ai_search_malformed_response =>
      'Hermes returned a malformed AI rewrite response.';

  @override
  String get rel_svc_backup_space_name_already_exists =>
      'A space with this name already exists';

  @override
  String get rel_svc_backup_space_name_length_invalid =>
      'Space name must be 1–80 characters';

  @override
  String get ng_rel_svc_backup_gateway_address_required =>
      'Enter the address of your Hermes dashboard.';

  @override
  String ng_rel_svc_backup_gateway_address_scheme(String scheme) {
    return 'The address must start with http:// or https:// (got $scheme).';
  }

  @override
  String get ng_rel_svc_backup_gateway_address_invalid =>
      'That address is not valid.';

  @override
  String get ng_rel_svc_backup_gateway_address_no_host =>
      'The address has no host name.';

  @override
  String get ng_rel_svc_backup_sign_in_main_window =>
      'Sign in in the main window.';

  @override
  String get rel_svc_backup_sign_in_renewal_failed =>
      'The gateway couldn\'t renew the sign-in right now.';

  @override
  String get rel_svc_backup_sign_in_provider_unreachable =>
      'The gateway couldn\'t renew the sign-in: its sign-in provider is unreachable.';

  @override
  String get rel_svc_backup_sign_in_renewal_timed_out =>
      'Timed out renewing the sign-in.';

  @override
  String get rel_svc_backup_sign_in_no_tokens =>
      'The gateway returned no sign-in tokens.';

  @override
  String get ng_rel_svc_backup_probe_timed_out =>
      'Timed out. Check the address, VPN or Tailscale connection.';

  @override
  String ng_rel_svc_backup_probe_tls_failed(String error) {
    return 'TLS handshake failed: $error';
  }

  @override
  String ng_rel_svc_backup_gateway_answered_http(int statusCode) {
    return 'The gateway answered HTTP $statusCode.';
  }

  @override
  String get ng_rel_svc_backup_gateway_answer_timed_out =>
      'The gateway took too long to answer.';

  @override
  String ng_rel_svc_backup_browser_callback_not_ready(String error) {
    return 'Couldn\'t get ready for the browser to come back: $error';
  }

  @override
  String get ng_rel_svc_backup_browser_signed_in_body =>
      'You can go back to Hermes now.';

  @override
  String get ng_rel_svc_backup_browser_waiting_title => 'Waiting for sign-in';

  @override
  String get ng_rel_svc_backup_browser_not_current =>
      'This page is not part of the current sign-in.';

  @override
  String get ng_rel_svc_backup_browser_open_failed =>
      'Couldn\'t open the browser to sign in.';

  @override
  String get ng_rel_svc_backup_browser_sign_in_timed_out =>
      'The sign-in took too long. Try again.';

  @override
  String ng_rel_svc_backup_gateway_refused_sign_in(int statusCode) {
    return 'The gateway refused the sign-in (HTTP $statusCode).';
  }

  @override
  String get rel_svc_misc_alert_caution => 'Caution';

  @override
  String get rel_svc_misc_alert_important => 'Important';

  @override
  String get rel_svc_misc_alert_tip => 'Tip';

  @override
  String get rel_svc_misc_alert_warning => 'Warning';

  @override
  String get rel_svc_misc_allow_folder_session =>
      'Allow this folder until the session ends.';

  @override
  String get rel_svc_misc_allow_website_session =>
      'Allow this website until the session ends.';

  @override
  String rel_svc_misc_approval_needed_title(String title) {
    return 'Approval needed — $title';
  }

  @override
  String get rel_svc_misc_attach_file_reference => 'Attach a file reference';

  @override
  String get rel_svc_misc_attach_folder_reference =>
      'Attach a folder reference';

  @override
  String get rel_svc_misc_attach_git_context => 'Attach git context';

  @override
  String get rel_svc_misc_attach_image_reference => 'Attach an image reference';

  @override
  String get rel_svc_misc_attach_staged_diff => 'Attach the staged diff';

  @override
  String get rel_svc_misc_attach_tool_reference => 'Attach a tool reference';

  @override
  String get rel_svc_misc_attach_unstaged_diff => 'Attach the unstaged diff';

  @override
  String get rel_svc_misc_attach_url_reference => 'Attach a URL reference';

  @override
  String get rel_svc_misc_background_task_completed =>
      'Background task completed';

  @override
  String rel_svc_misc_background_task_named_completed(String taskId) {
    return 'Background task $taskId completed';
  }

  @override
  String get rel_svc_misc_chat => 'Chat';

  @override
  String get rel_svc_misc_compacting_context =>
      'Compacting conversation context…';

  @override
  String rel_svc_misc_completed_in(String duration) {
    return 'Completed in $duration';
  }

  @override
  String get rel_svc_misc_context_compacted => 'Conversation context compacted';

  @override
  String get rel_svc_misc_cron_readback_mismatch =>
      'Cron model read-back did not match';

  @override
  String get rel_svc_misc_cron_update_rejected => 'Cron update rejected';

  @override
  String get rel_svc_misc_deny_folder_grant => 'Do not grant this folder.';

  @override
  String get rel_svc_misc_deny_website_grant => 'Do not grant this website.';

  @override
  String rel_svc_misc_failed_after(String duration) {
    return 'Failed after $duration';
  }

  @override
  String get rel_svc_misc_gateway_folder_unnamed =>
      'The gateway did not name a folder.';

  @override
  String get rel_svc_misc_gateway_idle_unconfirmed =>
      'The gateway is idle. The previous turn’s outcome could not be confirmed.';

  @override
  String get rel_svc_misc_gateway_turn_failed => 'Gateway turn failed';

  @override
  String rel_svc_misc_gateway_turn_status(String status) {
    return 'Gateway turn $status';
  }

  @override
  String get rel_svc_misc_gateway_website_unnamed =>
      'The gateway did not name a website.';

  @override
  String get rel_svc_misc_hermes_review => 'Hermes review';

  @override
  String get rel_svc_misc_hermes_turn_failed => 'Hermes turn failed';

  @override
  String get rel_svc_misc_image_recovery_companion_gap =>
      'Image and text recovery is not available on companion recovery. An unacknowledged image send cannot be restored on this connection, and nothing is sent again automatically.';

  @override
  String get rel_svc_misc_image_recovery_rest_gap =>
      'Image and text recovery is not available on Classic REST/SSE. An unacknowledged image send cannot be restored on this connection, and nothing is sent again automatically.';

  @override
  String rel_svc_misc_input_needed_title(String title) {
    return 'Input needed — $title';
  }

  @override
  String get rel_svc_misc_parallel_workspace_connection_changed =>
      'The connection changed. Reopen it to use the workspace.';

  @override
  String get rel_svc_misc_preparing => 'Preparing';

  @override
  String get rel_svc_misc_save_folder_grant =>
      'Save this folder grant for later requests.';

  @override
  String get rel_svc_misc_save_website_grant =>
      'Save this website grant for later requests.';

  @override
  String get rel_svc_misc_stored_identity_turn_conflict =>
      'This chat was opened through its stored identity while another turn was admitted. The unsent prompt was not sent; retry explicitly after that turn finishes.';

  @override
  String get rel_svc_misc_untitled => 'Untitled';

  @override
  String get rel_svc_misc_wake_capture_silent =>
      'Client wake capture hears only silence — check OS microphone access and re-toggle wake word.';

  @override
  String get rel_svc_misc_wake_capture_stalled =>
      'Client wake capture stalled: no microphone audio callbacks arrived.';

  @override
  String rel_svc_misc_wake_feed_refused(int count, String detail) {
    return 'Wake-word feed refused $count consecutive frames$detail — re-toggle wake word to re-arm.';
  }

  @override
  String rel_svc_misc_wake_microphone_failed(String error) {
    return 'Client wake microphone stream failed: $error';
  }

  @override
  String get rel_svc_misc_wake_track_ended =>
      'Microphone track ended during wake-word capture — re-toggle wake word to re-arm.';

  @override
  String get rel_svc_misc_website => 'Website';

  @override
  String get rel_svc_lan_timeout => 'LAN discovery timed out';

  @override
  String get rel_svc_notification_permission_denied => 'permission denied';

  @override
  String get rel_svc_notifications_off => 'notifications are off';

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
  String get fleet_managed_ssh_title => 'Gateway-managed SSH';

  @override
  String get fleet_managed_ssh_intro =>
      'Manage SSH hosts already saved on this gateway, from any device. Hermes must already be installed on the remote host. This starts or attaches an owned remote service, not an Ares chat connection. Managed updates and recovery are available only in native Desktop.';

  @override
  String get fleet_managed_ssh_read => 'Read saved SSH hosts';

  @override
  String get fleet_managed_ssh_trust =>
      'On this first connection, the gateway will trust and remember this host’s SSH key. A later key change will be flagged and blocked. The gateway does not report the key fingerprint, so Ares cannot display or store it. Only continue if you trust this first connection.';

  @override
  String get fleet_managed_ssh_changed =>
      'This host’s SSH key changed. Connection blocked. Someone with access to the gateway host must independently verify the new key fingerprint and remove the old trusted key there. Retry only after that verification and repair. Ares does not replace the trusted key.';

  @override
  String get fleet_managed_ssh_disconnect_warning =>
      'Disconnect the SSH tunnel and stop the remote service owned by this gateway? This can interrupt other clients using that service.';

  @override
  String get fleet_managed_ssh_verify => 'Verify the key yourself instead';

  @override
  String fleet_managed_ssh_pending(int seconds) {
    return 'Waiting for the gateway: $seconds s. Leaving this page does not cancel bootstrap. If the request fails, check status before retrying.';
  }

  @override
  String fleet_managed_ssh_status(
    String host,
    int localPort,
    int remotePort,
    String version,
    String reused,
  ) {
    return 'Host: $host\nGateway loopback port: $localPort\nRemote loopback port: $remotePort\nHermes: $version\nReused: $reused';
  }

  @override
  String get fleet_managed_ssh_disconnect => 'Disconnect';

  @override
  String get ng_slash_suggestions_loading => 'Loading commands…';

  @override
  String get ng_slash_suggestions_empty => 'No matching commands';

  @override
  String get ng_slash_suggestions_label => 'Command suggestions';

  @override
  String get ng_slash_suggestions_skill => 'Skill';

  @override
  String get settings_classic_title => 'Classic Settings';

  @override
  String get settings_nextgen_title => 'NextGen Settings';

  @override
  String get settings_category_general => 'General & language';

  @override
  String get settings_category_chat => 'Chat & sessions';

  @override
  String get settings_category_device => 'Device & shortcuts';

  @override
  String get settings_category_connections => 'Connections & models';

  @override
  String get settings_category_security => 'Privacy & backup';

  @override
  String get settings_category_about => 'About & help';

  @override
  String get settings_reopen_chat =>
      'Restore last chat when returning to a gateway';

  @override
  String get settings_reopen_chat_hint =>
      'Cold starts open the welcome screen. Links and notifications open the requested chat.';

  @override
  String get settings_danger => 'Danger zone';
}
