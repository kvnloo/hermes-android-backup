// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get attachment_audio_failed =>
      'この音声を再生できませんでした。形式やコーデックが非対応か、プレビューのサイズ制限を超えています。再試行するか、元のファイルを保存または共有してください。';

  @override
  String get attachment_audio_seek => '音声の再生位置';

  @override
  String get workspace_workers => '実行中のサブエージェント';

  @override
  String get workers_unattached =>
      '件数のみ表示しています。指示を送るには、接続中の親チャットで「実行中のサブエージェント」を選んでください。';

  @override
  String get slash_local_arguments =>
      'ここではこのショートカットに引数を指定できません。アプリの操作画面を使用してください。下書きは保持されています。';

  @override
  String get fallback_title => 'フォールバックモデル';

  @override
  String get fallback_notice =>
      'メインモデルが利用できない場合に順番に試行します。変更はこのプロファイルのみに適用されます。リスト全体を明示的に保存してください。';

  @override
  String get fallback_unavailable =>
      'フォールバック設定を利用できないか、設定が無効です。接続、選択したプロファイル、ホストのバージョンを確認して再試行してください。';

  @override
  String get fallback_discovery_unavailable =>
      'プロバイダー一覧を取得できません。既存の項目は保持されます。再試行するとプロバイダーとモデルを選択できます。';

  @override
  String get fallback_empty => 'このフォールバックリストに項目はありません。';

  @override
  String get fallback_incomplete =>
      '保存前にすべての項目でプロバイダーとモデルを選択するか、未入力の項目を削除してください。';

  @override
  String get fallback_add => 'フォールバックを追加';

  @override
  String get fallback_save => 'フォールバックリストを保存';

  @override
  String get fallback_save_failed =>
      '保存したリストを確認できませんでした。下書きは保持されています。もう一度保存するか、更新してホストの設定を読み込んでください。';

  @override
  String get fallback_saved => 'フォールバックリストを保存し、確認しました。';

  @override
  String get fallback_legacy_title => '従来のフォールバック（読み取り専用）';

  @override
  String get fallback_legacy_notice =>
      'ホストはこのリストの後に fallback_model も使用し、重複する経路はスキップします。上のリストが空でも従来の項目は保持されます。編集はホストで行ってください。';

  @override
  String fallback_priority(String position) {
    return '優先順位 $position';
  }

  @override
  String get fallback_move_up => '上へ移動';

  @override
  String get fallback_move_down => '下へ移動';

  @override
  String get fallback_routing_read_only =>
      '経路設定または一覧にないプロバイダーは保持されます。このプロバイダー／モデルはホストで編集してください。ここでは並べ替えと削除ができます。';

  @override
  String get cron_model_default => 'デフォルトに従う';

  @override
  String get cron_model_notice =>
      'このcronジョブにのみ適用されます。固定しない場合、Hermesはcronのデフォルト、次にメインモデルを使用します。カスタムモデルはホストで管理してください。';

  @override
  String get model_management_unavailable =>
      'モデル設定を読み込みまたは保存できませんでした。更新して再試行してください。';

  @override
  String get model_management_subtitle => 'このプロファイルのメイン・フォールバック・補助モデル';

  @override
  String get usage => '使用状況';

  @override
  String get nous_portal => 'Nous Portal';

  @override
  String get portal_menu_subtitle => 'ゲートウェイの状態と記録された使用量';

  @override
  String get portal_read_only =>
      'ゲートウェイの読み取り専用データです。Nous の認証は Hermes ホストで管理してください。これらのエンドポイントはサブスクリプション残高やクレジットを提供しません。';

  @override
  String get portal_status => 'ゲートウェイの Portal 状態';

  @override
  String get portal_free_tier => '無料枠でのアクセス（アカウント未ログイン）';

  @override
  String get portal_signed_in => 'ログイン済み';

  @override
  String get portal_signed_out => '未ログイン';

  @override
  String get portal_account_tier => 'アカウントのティア';

  @override
  String get portal_recorded_usage => '記録された使用量';

  @override
  String get portal_all_providers =>
      '選択したゲートウェイプロファイルのすべてのプロバイダー。記録された費用がゼロでも、モデルが無料とは限りません。';

  @override
  String portal_period(String days) {
    return '過去 $days 日間';
  }

  @override
  String get portal_sessions => 'セッション';

  @override
  String get portal_input => '入力トークン';

  @override
  String get portal_output => '出力トークン';

  @override
  String get portal_estimated => '記録された推定費用';

  @override
  String get portal_actual => '記録された実際の費用';

  @override
  String get portal_recorded_models => '記録されたモデル';

  @override
  String get portal_no_models => '記録されたモデルはありません。';

  @override
  String get portal_unavailable =>
      '利用できません。接続、選択したプロファイル、ゲートウェイのバージョンを確認して再試行してください。';

  @override
  String get paste_attachment_failed_text_kept =>
      '貼り付けたテキストを添付できませんでした。テキストはメッセージに残っています。';

  @override
  String get background_task_report => 'バックグラウンドタスク';

  @override
  String get background_process_report => 'バックグラウンドプロセス';

  @override
  String get background_report_issues => '問題が報告されています。展開して詳細を確認してください。';

  @override
  String get background_report_expand => 'レポートを展開';

  @override
  String get background_report_collapse => 'レポートを折りたたむ';

  @override
  String get ng_brand_open_chat => 'チャットを開く';

  @override
  String get ng_brand_recent => '最近のチャット';

  @override
  String get ng_brand_sidebar_hint => 'またはサイドバーからチャットを選択';

  @override
  String get copy_session_id => 'セッション ID をコピー';

  @override
  String get copy_session_id_failed => 'セッション ID をコピーできませんでした。';

  @override
  String get setup_interface_title => 'インターフェースを選択';

  @override
  String get setup_interface_classic => 'Classic';

  @override
  String get setup_interface_nextgen => 'NextGen';

  @override
  String get setup_interface_classic_description =>
      'すべての接続設定と Classic の設定を備えた、従来の Ares ワークスペース。';

  @override
  String get setup_interface_nextgen_description =>
      '1 回のダッシュボードログイン、ライブプラン、サブエージェント、通知を備えた新しいインターフェース。';

  @override
  String get setup_interface_switch_later => '設定でいつでも切り替えられます。';

  @override
  String get ng_confirm_model_switch => 'モデルを切り替えますか？';

  @override
  String get ng_switch => '切り替える';

  @override
  String get ng_model_confirmation_required => 'このモデルを選択するには確認が必要です。';

  @override
  String ng_model_switches_next_turn(String model) {
    return '次のターンで $model に切り替わります。';
  }

  @override
  String get ng_model_switch_not_connected =>
      'チャットでモデルを切り替える準備ができていません。開き直して再試行してください。';

  @override
  String ng_gateway_kept_default_model(String model) {
    return 'ゲートウェイはこのチャットで $model を維持しました。送信前にモデルを再度選択してください。';
  }

  @override
  String get hands_free_title => 'ハンズフリー';

  @override
  String get hands_free_start => 'ハンズフリー開始';

  @override
  String get hands_free_stop => 'ハンズフリー停止';

  @override
  String get hands_free_preparing => '音声を準備中 — お待ちください';

  @override
  String get hands_free_listening => 'Hey Hermes と言ってください';

  @override
  String get hands_free_recording => '準備完了 — 話してください';

  @override
  String get hands_free_waiting => 'Hermes の応答待ち';

  @override
  String get hands_free_speaking => '読み上げ中 — マイクはオフ';

  @override
  String hands_free_followup(int seconds) {
    return '最大 $seconds 秒間聞き取る';
  }

  @override
  String get hands_free_error => 'ハンズフリー停止中';

  @override
  String get hands_free_setup => 'ハンズフリー設定';

  @override
  String hands_free_preview(String transcript) {
    return '音声プレビュー: $transcript';
  }

  @override
  String get hands_free_short_disclosure =>
      'このチャットが前面で開いている間のみ。起動検出はオフライン、音声は通信を使う場合があります。電池を消費します。';

  @override
  String get hands_free_error_action =>
      'マイク権限、音声サービス、読み上げ音声、接続を確認して停止後に再開してください。自動再送はしません。';

  @override
  String get hands_free_disclosure =>
      '起動検出は CPU でオフライン動作します。Android の音声認識、選択した音声、ゲートウェイは通信を使う場合があります。電池を消費し、誤起動もあります。チャットが隠れる、閉じる、前面を離れると停止し、自動再開しません。手動入力の音声は編集可能な下書きのままです。';

  @override
  String get hands_free_ready_cue =>
      '「Hey Hermes」と言い、準備完了を待ってから話してください。一息での入力や先行録音はありません。権限設定でアプリを離れた場合、許可後に再度開始してください。';

  @override
  String get hands_free_settings_title => 'ハンズフリー音声';

  @override
  String get hands_free_settings_subtitle =>
      'チャットに「Hey Hermes」の開始ボタンを表示します。オフにすると、実行中のハンズフリーセッションが停止します。';

  @override
  String get hands_free_timing_limit =>
      '継続入力の時間は最大値であり、最小値ではありません。Android が早く終了する場合があります。無音時は認識を繰り返さず、ローカル起動待ちに戻ります。';

  @override
  String get hands_free_followup_off => '継続入力オフ — 毎回 Hey Hermes と言ってください';

  @override
  String get hands_free_start_blocked =>
      '空の下書き、添付なし、処理中でない接続済みチャット、読み上げ有効が必要です。手動音声操作を先に終えてください。';

  @override
  String get hands_free_setup_complete => 'マイク設定が完了しました。再度開始してください。';

  @override
  String message_time_recorded(String time) {
    return 'サーバーでの記録時刻：$time（ローカル時刻）';
  }

  @override
  String message_time_sent(String time) {
    return 'この端末で送信を確認：$time（ローカル時刻）';
  }

  @override
  String message_time_received(String time) {
    return 'この端末での初回受信時刻：$time（ローカル時刻）';
  }

  @override
  String get stop_and_send => '停止して送信';

  @override
  String get message_queued_for_running_turn => '現在の実行にメッセージを追加しました。';

  @override
  String get running_message_not_accepted =>
      'Hermes はこのメッセージを受け付けられませんでした。下書きは保持されています。応答を停止するか、完了を待ってから再送信してください。';

  @override
  String get running_message_delivery_unknown =>
      'メッセージの配信を確認できませんでした。下書きは保持されています。再試行する前にチャットを確認してください。';

  @override
  String get attachment_tap_to_preview => 'タップしてプレビュー';

  @override
  String get attachment_save => '保存';

  @override
  String get attachment_share => '共有';

  @override
  String get attachment_saved => 'ファイルを保存しました';

  @override
  String get attachment_save_cancelled => '保存をキャンセルしました';

  @override
  String get attachment_save_failed => 'このファイルを保存できませんでした。もう一度お試しください。';

  @override
  String get attachment_share_failed => 'このファイルを共有できませんでした。もう一度お試しください。';

  @override
  String get attachment_download_failed =>
      'このファイルを読み込めませんでした。接続を確認して、もう一度お試しください。';

  @override
  String get attachment_no_inline_preview =>
      'この種類のファイルはプレビューできません。元のファイルを保存または共有して、別のアプリで開いてください。';

  @override
  String get attachment_image_failed => 'この画像をデコードできませんでした。元のファイルは保存または共有できます。';

  @override
  String get attachment_text_truncated =>
      'プレビューを短縮しました。全文を読むにはファイルを保存または共有してください。';

  @override
  String get attachment_text_unavailable =>
      'このファイルをテキストとして表示できませんでした。元のファイルを保存または共有してください。';

  @override
  String get attachment_pdf_failed =>
      'このPDFをプレビューできませんでした。元のファイルを保存または共有してください。';

  @override
  String get attachment_pdf_unavailable =>
      'PDFのプレビューはAndroidで利用できます。このファイルは保存または共有できます。';

  @override
  String attachment_pdf_page(int page, int total) {
    return '$totalページ中$pageページ';
  }

  @override
  String get attachment_previous_page => '前のページ';

  @override
  String get attachment_next_page => '次のページ';

  @override
  String get attachment_loading => 'プレビューを読み込み中…';

  @override
  String get attachment_document_text_notice =>
      'テキストのプレビューです。レイアウト、画像、書式は元のファイルと異なる場合があります。';

  @override
  String get attachment_document_failed =>
      'この文書をプレビューできませんでした。元のファイルを保存または共有してください。';

  @override
  String get attachment_document_empty => 'この文書に読み取り可能なテキストが見つかりませんでした。';

  @override
  String get attachment_video_failed =>
      'この動画を再生できませんでした。形式またはコーデックがサポートされていない可能性があります。元のファイルを保存または共有してください。';

  @override
  String get attachment_video_play => '再生';

  @override
  String get attachment_video_pause => '一時停止';

  @override
  String get attachment_video_mute => 'ミュート';

  @override
  String get attachment_video_unmute => 'ミュート解除';

  @override
  String get attachment_video_seek => '動画の再生位置';

  @override
  String get attachment_close => 'プレビューを閉じる';

  @override
  String get attachment_retry => '再試行';

  @override
  String get saved_history_heading => '保存済みの履歴';

  @override
  String get received_output_heading => '受信した出力 — 保存済みの履歴との一致は未確認';

  @override
  String get received_output_details => '受信した出力について';

  @override
  String get received_output_explanation =>
      '保存済みの履歴にも含まれている可能性があります。アプリでは一致を確認できません。';

  @override
  String get local_prompt_context => 'ローカルのプロンプトコンテキスト';

  @override
  String get received_output_badge => '受信済み · 一致未確認';

  @override
  String get received_output_lifetime =>
      '受信した出力は、このアプリセッション中に一時的に保持され、上限に達すると短縮または削除される場合があります。アプリや接続を閉じると利用できなくなる場合があります。';

  @override
  String get theme_palette => 'カラーテーマ';

  @override
  String get theme_palette_gold => '金色';

  @override
  String get theme_palette_purple => '紫';

  @override
  String get theme_palette_orange => 'オレンジ';

  @override
  String get theme_palette_green => '緑';

  @override
  String get theme_palette_blue => '青';

  @override
  String get theme_palette_red => '赤';

  @override
  String get theme_palette_teal => '青緑';

  @override
  String get theme_palette_pink => 'ピンク';

  @override
  String get theme_palette_indigo => '藍色';

  @override
  String get theme_palette_cyan => 'シアン';

  @override
  String get assets_recent_subtitle => '保存済みのチャットで Hermes が共有したファイルを探す';

  @override
  String get assets_scope_notice =>
      '保存済みの返信で Hermes が明示的に共有した生成ファイルを表示します。チャット履歴の一部のみを対象としており、すべてのファイルや添付ファイルを網羅するものではありません。参照先のファイルはすでに存在しない場合があります。';

  @override
  String get assets_download_limit =>
      'ファイルはタップしたときにのみ読み込まれます。プレビューとダウンロードの上限は、それぞれ 1 ファイルあたり 25 MiB です。これより大きなファイルはダッシュボードをご利用ください。';

  @override
  String get assets_search_hint => '見つかったファイルや共有元のチャットを検索';

  @override
  String get assets_all => 'すべて';

  @override
  String get assets_images => '画像';

  @override
  String get assets_audio => '音声';

  @override
  String get assets_video => '動画';

  @override
  String get assets_documents => 'ドキュメントとその他のファイル';

  @override
  String get assets_empty => '調べたメッセージにアセットは見つかりませんでした';

  @override
  String get assets_empty_detail =>
      'さらにチャットや古いメッセージを調べると、より前の履歴を確認できます。通常の添付ファイルやリンクのないファイルは、ここではインデックス化されません。';

  @override
  String get assets_no_matches => '一致するアセットはありません';

  @override
  String get assets_load_more_chats => 'さらにチャットを調べる';

  @override
  String get assets_load_older_messages => '古いメッセージを調べる';

  @override
  String get assets_load_failed =>
      '履歴の一部を読み込めませんでした。結果は不完全です。ダッシュボード接続を確認して、もう一度お試しください。';

  @override
  String get assets_retry_failed => '読み込めなかった履歴を再読み込み';

  @override
  String get assets_partial =>
      'サーバーから履歴が不完全であると報告されました。ダッシュボードを確認してから更新してください。';

  @override
  String assets_scan_summary(int files, int chats) {
    return '調べたチャット $chats 件からファイル参照 $files 件を検出';
  }

  @override
  String assets_open_chat(String title) {
    return 'チャットを開く: $title';
  }

  @override
  String get assets_file_too_large =>
      'このファイルはダウンロードの上限を超えています。ダッシュボードを開いてダウンロードしてください。';

  @override
  String get a_one_off_question_archives_itself_after_72_hours_anything =>
      '単発の質問用。72時間後に自動アーカイブされますが、残す価値のある内容は記憶されます。';

  @override
  String get archive_chat => 'チャットをアーカイブ';

  @override
  String get unarchive_chat => 'チャットのアーカイブを解除';

  @override
  String get chat_archived => 'チャットをアーカイブしました';

  @override
  String get chat_unarchived => 'チャットのアーカイブを解除しました';

  @override
  String could_not_update_chat_archive(Object error) {
    return 'チャットのアーカイブ状態を更新できませんでした: $error';
  }

  @override
  String get quick_chat_description => '単発の質問用。';

  @override
  String get ai_full_text => 'AI + 全文';

  @override
  String get ai_search_model => 'AI検索モデル';

  @override
  String ai_searched_for(Object aiRewrittenQuery) {
    return 'AI検索: $aiRewrittenQuery';
  }

  @override
  String get ai_assisted_filing => 'AIによる仕分け';

  @override
  String get api_key => 'APIキー';

  @override
  String get api_server_key_from_hermes_env =>
      '~/.hermes/.env の API_SERVER_KEY';

  @override
  String get active => 'アクティブ';

  @override
  String get activity => 'アクティビティ';

  @override
  String get activity_reads_the_durable_turn_journal_to_know_what_hermes =>
      'アクティビティは永続的なターンジャーナルを読み取り、Hermesの動作を把握します。ゲートウェイに到達できることを確認して、もう一度お試しください。';

  @override
  String get add => '追加';

  @override
  String get add_connection => '接続を追加';

  @override
  String get add_cron_job => 'Cronジョブを追加';

  @override
  String get add_gateway_connection => 'ゲートウェイ接続を追加';

  @override
  String get add_and_update_connections_from_the_backup_keep_the_rest =>
      'バックアップの接続を追加・更新し、それ以外はそのままにします。';

  @override
  String get add_attachment => '添付を追加';

  @override
  String get add_new_cron_job => '新しいCronジョブを追加';

  @override
  String get add_to_chat => 'チャットに追加';

  @override
  String get all_chats => 'すべてのチャット';

  @override
  String get all_stored_message_content => '保存されている全メッセージ内容';

  @override
  String get allow_for_this_session => 'このセッション中は許可';

  @override
  String get allow_matching_commands_until_this_hermes_session_ends =>
      'このHermesセッションが終了するまで、一致するコマンドを許可します。';

  @override
  String get allow_folder_until_sandbox_off => 'サンドボックスがオフになるまで、このフォルダーを許可します。';

  @override
  String get allow_once => '1回だけ許可';

  @override
  String get allow_website_until_sandbox_off =>
      'サンドボックスがオフになるまで、このウェブサイトを許可します。';

  @override
  String get always_allow => '常に許可';

  @override
  String get apply_to_this_chat => 'このチャットに適用';

  @override
  String get approval_needed => '承認が必要';

  @override
  String get approval_needed_description => 'コマンドが承認または拒否を待っています。';

  @override
  String get approve => '承認';

  @override
  String get archive => 'アーカイブ';

  @override
  String get archive_project => 'プロジェクトをアーカイブ';

  @override
  String archive_2(Object projectName) {
    return '$projectNameをアーカイブしますか？';
  }

  @override
  String archive_3(Object name) {
    return '$nameをアーカイブしますか？';
  }

  @override
  String get archived => 'アーカイブ済み';

  @override
  String get archived_conversations_appear_here =>
      'アーカイブした会話のみがここに表示されます。古いチャットは「すべてのチャット」に残ります。';

  @override
  String get archived_quick_chats => 'アーカイブ済みクイックチャット';

  @override
  String get artifacts_attachments_and_generated_media => '成果物、添付ファイル、生成メディア';

  @override
  String get ask_ai_to_find_a_conversation => 'AIに会話を探させる';

  @override
  String get assets => 'アセット';

  @override
  String get assets_need_a_server_authoritative_assets_index_in_the_hermes =>
      'プロジェクトごとに表示するには、Hermesゲートウェイにサーバー権威のアセットインデックスが必要です。';

  @override
  String get assets_unavailable => 'アセットを利用できません';

  @override
  String get attach_image_or_file => '画像またはファイルを添付';

  @override
  String get attachment_drafts => '添付ドラフト';

  @override
  String get recover_text_draft => 'テキストの下書きを復元';

  @override
  String get undo_draft_recovery => '元に戻す';

  @override
  String get draft_session_exists => 'このチャットはまだ存在します。開いて下書きの編集を続けてください。';

  @override
  String get draft_recovery_unavailable => '下書きを確認できませんでした。変更はありません。';

  @override
  String attachment_of(Object index, Object total) {
    return '添付 $index/$total';
  }

  @override
  String get auto_device_default => '自動（端末のデフォルト）';

  @override
  String get agent => 'エージェント';

  @override
  String get autonomous_agents => '自律エージェント';

  @override
  String get background_recovery_unavailable_legacy_transport =>
      'バックグラウンド復旧は利用不可 — レガシー通信方式';

  @override
  String get background_task_completed => 'バックグラウンドタスク完了';

  @override
  String get background_task_completed_description =>
      'バックグラウンドのターミナルコマンドが完了しました。';

  @override
  String get backup_restore => 'バックアップと復元';

  @override
  String backup_exported(Object destination) {
    return 'バックアップを書き出しました — $destination';
  }

  @override
  String get base_url => 'ベースURL';

  @override
  String get binary_preview_is_unavailable_download_the_file_to_open_it =>
      'バイナリのプレビューはできません。ファイルをダウンロードして開いてください。';

  @override
  String get branch => 'ブランチ';

  @override
  String get branch_chat => 'チャットを分岐';

  @override
  String get branch_created_in_hermes_history => 'Hermes履歴にブランチを作成しました。';

  @override
  String get browse_and_manage_your_hermes_agent_sessions_from_your_phone =>
      'スマホからHermes Agentのセッションを閲覧・管理できます。ローカルネットワーク上のHermesダッシュボードに接続します。';

  @override
  String get browse_server_files => 'サーバーファイルを閲覧';

  @override
  String get browse_the_miniserver_folders_behind_your_projects =>
      'プロジェクトの背後にあるminiserverフォルダを閲覧';

  @override
  String get cancel => 'キャンセル';

  @override
  String get cancel_voice_input => '音声入力をキャンセル';

  @override
  String cannot_reach(Object host, Object port) {
    return '$host:$port に接続できません。';
  }

  @override
  String cannot_reach_check_the_host_and_port(Object host, Object port) {
    return '$host:$port に接続できません。ホストとポートを確認してください。';
  }

  @override
  String get change_ai_search_model => 'AI検索モデルを変更';

  @override
  String changes_the_default_for_use_the_selector_in_a_chat(Object label) {
    return '$labelのデフォルトを変更します。チャット内のセレクターで、その会話だけ上書きできます。';
  }

  @override
  String get chat_actions => 'チャット操作';

  @override
  String get chats => 'チャット';

  @override
  String get chats_from_this_gateway_are_not_grouped_yet_grouping_stays =>
      'このゲートウェイのチャットはまだグループ化されていません。ゲートウェイがプロジェクトをホストできるようになるまで、グループ化はこの端末内のみです。';

  @override
  String get chats_in_this_project_will_show_their_state_and_last =>
      'このプロジェクトで開始したチャットは、ここに状態と最近のアクティビティを表示します。';

  @override
  String get chats_that_are_not_assigned_to_a_project =>
      'プロジェクトに割り当てられていないチャット';

  @override
  String get chats_you_start_in_this_project_will_appear_here_on =>
      'このプロジェクトで開始したチャットは、このHermesにサインインしているすべての端末でここに表示されます。';

  @override
  String get check_that_the_gateway_is_running_and_reachable_then_try =>
      'ゲートウェイが起動していて到達可能か確認して、もう一度お試しください。';

  @override
  String get check_the_dashboard_connection_and_try_again =>
      'ダッシュボード接続を確認して、もう一度お試しください。';

  @override
  String get check_the_connection_and_try_again => '接続を確認して、もう一度お試しください。';

  @override
  String get choose_a_small_model_to_rewrite_queries => 'クエリを書き換える小型モデルを選択';

  @override
  String get choose_an_ai_search_model_before_using_ai_search =>
      'AI検索を使う前に、AI検索モデルを選択してください。';

  @override
  String get choose_an_active_project_next => '次にアクティブなプロジェクトを選択';

  @override
  String get choose_chat_model => 'チャットモデルを選択';

  @override
  String get choose_files => 'ファイルを選択';

  @override
  String get choose_image => '画像を選択';

  @override
  String get choose_images => '画像を選択';

  @override
  String get choose_its_destination_space => '移動先スペースを選択';

  @override
  String get clear_search => '検索をクリア';

  @override
  String get close => '閉じる';

  @override
  String get code_copied => 'コードをコピーしました';

  @override
  String get code_format => 'コード';

  @override
  String get coming_next => '近日対応';

  @override
  String get command => 'コマンド';

  @override
  String get command_palette => 'コマンドパレット';

  @override
  String get command_palette_hint => 'コマンドを入力';

  @override
  String get command_palette_no_results => 'コマンドが見つかりません';

  @override
  String get command_palette_new_chat => '新しいチャット';

  @override
  String get command_palette_search_chats => 'チャットを検索';

  @override
  String get command_palette_toggle_theme => 'テーマを切り替え';

  @override
  String get command_palette_copy_last_code => '最後のコードブロックをコピー';

  @override
  String get command_line_chats => 'コマンドラインのチャット';

  @override
  String get compatibility_mode => '互換モード';

  @override
  String get configure_a_valid_desktop_gateway_url_before_attaching_files =>
      'ファイルを添付する前に、有効なDesktop Gateway URLを設定してください。';

  @override
  String get confirm_always_allow => '常に許可を確認';

  @override
  String get confirm_passphrase => 'パスフレーズを確認';

  @override
  String connecting_to(Object baseUrl) {
    return '$baseUrl に接続中…';
  }

  @override
  String get connection_issue => '接続の問題';

  @override
  String
  get connection_switched_the_running_reply_continues_on_the_server_and =>
      '接続を切り替えました — 実行中の応答はサーバー側で継続し、自動的に再アタッチされます。';

  @override
  String get connection_appearance_and_device_preferences => '接続・外観・端末の設定';

  @override
  String context_tokens(Object effectiveContextLength) {
    return 'コンテキスト: $effectiveContextLength トークン';
  }

  @override
  String get continue_label => '続行';

  @override
  String get continue_working => '作業を続ける';

  @override
  String get conversations_in_this_project => 'このプロジェクトの会話';

  @override
  String get copy_code => 'コードをコピー';

  @override
  String get copy_message => 'メッセージをコピー';

  @override
  String could_not_branch_chat(Object error) {
    return 'チャットを分岐できませんでした: $error';
  }

  @override
  String could_not_delete_session(Object error) {
    return 'セッションを削除できませんでした: $error';
  }

  @override
  String could_not_deny_the_command(Object error) {
    return 'コマンドを拒否できませんでした: $error';
  }

  @override
  String could_not_load_ai_search_models(Object error) {
    return 'AI検索モデルを読み込めませんでした: $error';
  }

  @override
  String get could_not_load_conversations => '会話を読み込めませんでした';

  @override
  String get could_not_load_files => 'ファイルを読み込めませんでした';

  @override
  String could_not_load_models_for_this_profile(Object error) {
    return 'このプロファイルのモデルを読み込めませんでした: $error';
  }

  @override
  String could_not_load_more_chats(Object error) {
    return 'これ以上チャットを読み込めませんでした: $error';
  }

  @override
  String get could_not_open_link => 'このリンクを開けませんでした。';

  @override
  String get could_not_open_the_hermes_dashboard => 'Hermesダッシュボードを開けませんでした。';

  @override
  String get could_not_open_this_project => 'このプロジェクトを開けませんでした';

  @override
  String get could_not_preview_file => 'ファイルをプレビューできませんでした';

  @override
  String get could_not_reach_hermes => 'Hermesに接続できませんでした';

  @override
  String could_not_reach_authenticate_the_dashboard_at_check_the_port(
    Object dashboardPort,
    Object host,
  ) {
    return '$host:$dashboardPort のダッシュボードに到達できないか、認証に失敗しました。ポートと認証情報を確認してください。';
  }

  @override
  String get could_not_read_activity => 'アクティビティを読み込めませんでした';

  @override
  String could_not_rename_chat(Object error) {
    return 'チャット名を変更できませんでした: $error';
  }

  @override
  String could_not_send_the_approval(Object error) {
    return '承認を送信できませんでした: $error';
  }

  @override
  String get could_not_skip_the_hermes_question => 'Hermesの質問をスキップできませんでした。';

  @override
  String could_not_the_project(Object action, Object error) {
    return 'プロジェクトの$actionに失敗しました: $error';
  }

  @override
  String get couldn_t_delete_project => 'プロジェクトを削除できませんでした';

  @override
  String couldn_t_load_runs(Object error) {
    return '実行履歴を読み込めませんでした: $error';
  }

  @override
  String get couldn_t_move_conversation => '会話を移動できませんでした';

  @override
  String couldn_t_move_to(Object label, Object reason) {
    return '$labelに移動できませんでした: $reason';
  }

  @override
  String get couldn_t_prepare_the_shared_files => '共有ファイルを準備できませんでした。';

  @override
  String get couldn_t_promote_conversation => '会話を昇格できませんでした';

  @override
  String couldn_t_project(Object action) {
    return 'プロジェクトの$actionに失敗しました';
  }

  @override
  String get create => '作成';

  @override
  String get create_a_project => 'プロジェクトを作成';

  @override
  String get create_a_project_first_then_chats_can_live_inside_it =>
      'まずプロジェクトを作成すると、その中にチャットを置けます。';

  @override
  String get create_a_space_to_separate_related_conversations =>
      '関連する会話を分けるスペースを作成します。';

  @override
  String get create_branch => 'ブランチを作成';

  @override
  String get credit_notifications => 'クレジット通知';

  @override
  String get credit_notifications_description => 'クレジットの利用が停止または復旧しました。';

  @override
  String get cron => 'Cron';

  @override
  String get crons => 'Cronジョブ';

  @override
  String get cron_conversations_empty => '予定されたジョブの会話が、過去の実行分も含めてここに表示されます。';

  @override
  String get search_cron_conversations => 'Cronの会話を検索';

  @override
  String get cron_jobs => 'Cronジョブ';

  @override
  String cron_schedule_timezone(Object zone) {
    return 'スケジュールのタイムゾーン：$zone';
  }

  @override
  String get crons_upcoming => '今後の予定';

  @override
  String get crons_history => '履歴';

  @override
  String cron_time_with_zone(Object time, Object zone) {
    return '$time（$zone）';
  }

  @override
  String cron_time_zone_unknown(Object time) {
    return '$time（タイムゾーン不明）';
  }

  @override
  String get cron_no_next_run => '次回の実行予定はありません';

  @override
  String get cron_status_scheduled => '予定済み';

  @override
  String get cron_status_paused => '一時停止中';

  @override
  String cron_delivers_to(Object target) {
    return '$target に配信';
  }

  @override
  String get cron_upcoming_empty_title => '予定されたジョブはありません';

  @override
  String get cron_upcoming_empty_message =>
      '実行予定のジョブはありません。Cronジョブで作成するか、エージェントに予定を依頼してください。';

  @override
  String get cron_upcoming_unavailable => '予定されたジョブを表示できません';

  @override
  String get cron_upcoming_needs_dashboard =>
      '予定されたジョブにはダッシュボード接続が必要です。このアドレスではCronのスケジュールを取得できません。ダッシュボードのアドレスとホストの対応状況を確認してください。';

  @override
  String get cron_upcoming_needs_dashboard_auth =>
      '予定されたジョブにはダッシュボード認証が必要です。この接続にダッシュボードのユーザー名とパスワードを設定するか、プロキシモードを有効にしてください。';

  @override
  String get cron_upcoming_dashboard_unreachable =>
      'ダッシュボードに接続できませんでした。ホスト、ダッシュボードのポート、ネットワークを確認して、もう一度お試しください。';

  @override
  String get cron_upcoming_load_failed =>
      '予定されたジョブを読み込めませんでした。ダッシュボード接続を確認して、もう一度お試しください。';

  @override
  String get cron_upcoming_refresh_failed =>
      'スケジュールを更新できませんでした。最後に成功した取得結果を表示しています。';

  @override
  String get cron_job_added => 'Cronジョブを追加しました';

  @override
  String get cron_job_updated => 'Cronジョブを更新しました';

  @override
  String get cron_run => 'Cron実行';

  @override
  String get cross_device_ordering_and_reversible_bulk_organization =>
      '端末間の並び順と、取り消し可能な一括整理';

  @override
  String get current_profile_default => '現在のプロファイルのデフォルト';

  @override
  String get custom_proxy_and_dashboard_details => 'カスタムプロキシとダッシュボードの詳細';

  @override
  String get dark => 'ダーク';

  @override
  String get dashboard_proxy_settings => 'ダッシュボード / プロキシ設定';

  @override
  String get dashboard_password_optional => 'ダッシュボードのパスワード（任意）';

  @override
  String get dashboard_port => 'ダッシュボードのポート';

  @override
  String get dashboard_username_optional => 'ダッシュボードのユーザー名（任意）';

  @override
  String get dashboard_behind_proxy => 'ダッシュボードがプロキシの背後にある';

  @override
  String get dashboard_path_prefix => 'ダッシュボードのパスプレフィックス';

  @override
  String delegated_task(Object goal) {
    return '委任されたタスク: $goal';
  }

  @override
  String get delete => '削除';

  @override
  String delete_2(Object name) {
    return '「$name」を削除しますか？';
  }

  @override
  String delete_from_the_remote_hermes_history_this_cannot_be_undone(
    Object title,
  ) {
    return '「$title」をリモートのHermes履歴から削除しますか？この操作は取り消せません。';
  }

  @override
  String get delete_cron_job => 'Cronジョブを削除';

  @override
  String get delete_connections_that_are_not_in_the_backup =>
      'バックアップにない接続を削除します。';

  @override
  String delete_failed(Object error) {
    return '削除に失敗しました: $error';
  }

  @override
  String get delete_project => 'プロジェクトを削除';

  @override
  String get delete_session => 'セッションを削除しますか？';

  @override
  String delete_3(Object projectName) {
    return '$projectNameを削除しますか？';
  }

  @override
  String deleted(Object name) {
    return '「$name」を削除しました';
  }

  @override
  String get delivery_is_uncertain_recovering_without_resending =>
      '配信状況が不明です。再送せずに復旧しています…';

  @override
  String get desktop_gateway_url_optional => 'Desktop Gateway URL（任意）';

  @override
  String get desktop_gateway_is_not_configured_for_this_connection =>
      'この接続にはDesktop Gatewayが設定されていません。';

  @override
  String get desktop_app => 'デスクトップアプリ';

  @override
  String get developer_tool_calls => '開発ツールの呼び出し';

  @override
  String get discord_chats => 'Discordのチャット';

  @override
  String get dismiss => '閉じる';

  @override
  String get do_not_run_this_command => 'このコマンドを実行しない。';

  @override
  String get documents_archives_audio_video_or_data =>
      'ドキュメント、アーカイブ、音声、動画、データなど';

  @override
  String get download => 'ダウンロード';

  @override
  String download_failed(Object error) {
    return 'ダウンロードに失敗しました: $error';
  }

  @override
  String get durable_facts_hermes_keeps_about_you => 'Hermesが記憶している永続的な情報';

  @override
  String get durable_work_inside_one_of_your_projects_shared_with_desktop =>
      'プロジェクト内の永続的な作業。Desktopと共有されます。';

  @override
  String get edit => '編集';

  @override
  String get edit_connection => '接続を編集';

  @override
  String get edit_cron_job => 'Cronジョブを編集';

  @override
  String get edit_gateway_connection => 'ゲートウェイ接続を編集';

  @override
  String get edit_and_resend => '編集して再送信';

  @override
  String get enable_notifications => '通知を有効にする';

  @override
  String get enable_notifications_description => 'オフで以下の通知をすべて無効にします。';

  @override
  String get enables_file_attachments_through_the_desktop_remote_gateway =>
      'Desktopリモートゲートウェイ経由のファイル添付を有効にします。';

  @override
  String get enter_a_name => '名前を入力';

  @override
  String get enter_a_passphrase => 'パスフレーズを入力してください。';

  @override
  String get enter_the_passphrase_for_this_backup =>
      'このバックアップのパスフレーズを入力してください。';

  @override
  String get every_conversation_is_already_assigned_to_a_project =>
      'すべての会話はすでにプロジェクトに割り当てられています。';

  @override
  String get everything_not_yet_native_in_the_authenticated_web_dashboard =>
      'まだネイティブ対応していないすべての機能（認証済みWebダッシュボード）';

  @override
  String get explain_the_attached_content_clearly => '添付コンテンツをわかりやすく説明して。';

  @override
  String explain_this_content_clearly(Object text) {
    return 'この内容をわかりやすく説明して:\n\n$text';
  }

  @override
  String
  get explicit_choices_adjust_android_accessibility_text_size_system_leaves_it =>
      '明示的に選ぶとAndroidのアクセシビリティ文字サイズを調整します。「システム」は変更しません。';

  @override
  String get export_label => 'エクスポート';

  @override
  String get export_share => 'エクスポート / 共有';

  @override
  String get external_api_clients => '外部APIクライアント';

  @override
  String get extra_high => '最高';

  @override
  String get extract_tasks => 'タスクを抽出';

  @override
  String
  get extract_the_decisions_deadlines_owners_and_actionable_action_items_from =>
      '添付コンテンツから、決定事項・締め切り・担当者・実行可能なアクション項目を抽出して。';

  @override
  String
  extract_the_decisions_deadlines_owners_and_actionable_action_items_from_2(
    Object text,
  ) {
    return 'この内容から、決定事項・締め切り・担当者・実行可能なアクション項目を抽出して:\n\n$text';
  }

  @override
  String failed_to_add_job(Object error) {
    return 'ジョブの追加に失敗しました: $error';
  }

  @override
  String get failed_to_load_cron_jobs => 'Cronジョブを読み込めませんでした';

  @override
  String get failed_to_load_memory => 'メモリを読み込めませんでした';

  @override
  String get failed_to_load_messages => 'メッセージを読み込めませんでした';

  @override
  String get failed_to_load_settings => '設定を読み込めませんでした';

  @override
  String get failed_to_load_skills => 'スキルを読み込めませんでした';

  @override
  String failed_to_update_job(Object error) {
    return 'ジョブの更新に失敗しました: $error';
  }

  @override
  String failed(Object error) {
    return '失敗: $error';
  }

  @override
  String get file_attached_document_catalog_registration_is_pending =>
      'ファイルを添付しました。ドキュメントカタログへの登録は保留中です。';

  @override
  String get file_reference_added_to_chat => 'ファイル参照をチャットに追加しました';

  @override
  String get files => 'ファイル';

  @override
  String get fill_from_document => '書類から記入';

  @override
  String get folder_is_empty => 'フォルダは空です';

  @override
  String get folders => 'フォルダ';

  @override
  String get full_text => '全文';

  @override
  String get gateway_api_access => 'ゲートウェイAPIアクセス';

  @override
  String get gateway_connected_but_the_dashboard_could_not_be_reached_or =>
      'ゲートウェイには接続しましたが、ダッシュボードに到達できないか認証に失敗しました。ダッシュボードの設定を確認するか、空にしてスキップしてください。';

  @override
  String get gateway_path_prefix => 'ゲートウェイのパスプレフィックス';

  @override
  String get go_to_end => '末尾へ';

  @override
  String get hermes_agent => 'Ares - formerly Hermes Android';

  @override
  String get hermes_agent_for_android => 'Ares - formerly Hermes Android';

  @override
  String get hermes_could_not_accept_the_answer_please_try_again =>
      'Hermesが回答を受け付けられませんでした。もう一度お試しください。';

  @override
  String get hermes_could_not_load_your_saved_connections =>
      '保存された接続を読み込めませんでした';

  @override
  String get hermes_did_not_accept_the_response_please_try_again =>
      'Hermesが応答を受け付けませんでした。もう一度お試しください。';

  @override
  String get hermes_is_responding => 'Hermesが応答中…';

  @override
  String get hermes_is_waiting_for_input => 'Hermesが入力を待っています…';

  @override
  String get hermes_keeps_android_accessibility_text_scaling_active =>
      'AresはAndroidのアクセシビリティ文字拡大を有効に保ちます。';

  @override
  String get hermes_needs_your_input => 'Hermesが入力を求めています';

  @override
  String get hermes_profile_optional => 'Hermesプロファイル（任意）';

  @override
  String get hermes_profile_must_be_a_plain_profile_name_such_as =>
      'Hermesプロファイルは「sol」のような単純な名前で入力してください。パスは使えません。';

  @override
  String get hermes_reasoning_details => 'Hermesの推論の詳細';

  @override
  String hermes_recovery_is_unavailable(Object error) {
    return 'Hermesの復旧は利用できません: $error';
  }

  @override
  String get hermes_stopped_recovery_safely_no_prompt_was_resent =>
      'Hermesはプロンプトを再送せず、安全に復旧を停止しました。';

  @override
  String get hide_passphrase => 'パスフレーズを隠す';

  @override
  String get home_needs_your_recent_chats_to_know_what_deserves_your =>
      'ホームで最近のチャットを表示するには接続が必要です。ゲートウェイに到達できるか確認して、もう一度お試しください。';

  @override
  String get host => 'ホスト';

  @override
  String get image_selection_was_interrupted_try_again =>
      '画像の選択が中断されました。もう一度お試しください。';

  @override
  String get import_label => 'インポート';

  @override
  String get inbox => '受信トレイ';

  @override
  String get inbox_is_clear => '受信トレイは空です';

  @override
  String get input_needed => '入力が必要';

  @override
  String get input_needed_description => 'Hermes が質問したか、パスワードやシークレットを必要としています。';

  @override
  String get insert_a_remote_file_reference => 'リモートの@file参照を挿入';

  @override
  String get invalid_port_number => 'ポート番号が無効です。';

  @override
  String get job_paused => 'ジョブを一時停止しました';

  @override
  String get job_resumed => 'ジョブを再開しました';

  @override
  String get job_triggered => 'ジョブを実行しました';

  @override
  String get label => 'ラベル';

  @override
  String last_activity(Object day, Object month, Object year) {
    return '最終アクティビティ $year/$month/$day';
  }

  @override
  String last(Object lastRun) {
    return '前回: $lastRun';
  }

  @override
  String get leave_blank_for_default_8642_443_with_https =>
      '空欄でデフォルト（8642、https時は443）';

  @override
  String get leave_blank_for_default_9119 => '空欄でデフォルト（9119）';

  @override
  String get light => 'ライト';

  @override
  String listening(Object elapsed) {
    return '聞き取り中 • $elapsed';
  }

  @override
  String listening_elapsed(Object elapsed) {
    return '聞き取り中、経過 $elapsed';
  }

  @override
  String get load_more => 'もっと読み込む…';

  @override
  String get loading => '読み込み中';

  @override
  String get location => '場所';

  @override
  String get make_sure_the_gateway_api_server_is_running_hermes_gateway =>
      'ゲートウェイAPIサーバーが起動していることを確認してください\n（hermes gateway status）';

  @override
  String matches(Object assigned, Object name) {
    return '$name に一致 · $assigned';
  }

  @override
  String get memory => 'メモリ';

  @override
  String get memory_about_you => 'あなたについて';

  @override
  String get memory_agent_notes => 'エージェントのメモ';

  @override
  String get memory_builtin_scope =>
      'このプロファイルの USER.md と MEMORY.md に保存された情報です。MemPalace などの外部メモリはここには表示されません。';

  @override
  String get memory_read_only => '読み取り専用です。修正や削除はチャットで Hermes に依頼してください。';

  @override
  String get memory_unavailable =>
      'このゲートウェイまたはプロファイルから保存情報を取得できません。プロファイルを確認し、必要に応じて Hermes を更新してください。';

  @override
  String get memory_load_error => 'ダッシュボードの接続と認証を確認して、もう一度お試しください。';

  @override
  String get memory_read_full_fact => '情報の全文を読む';

  @override
  String get memory_full_fact_requires_update =>
      '全文の表示には新しい Hermes ゲートウェイが必要です。Hermes を更新し、一覧を再読み込みしてください。';

  @override
  String get memory_fact_detail_error =>
      '全文を読み込めませんでした。情報が変更された可能性があります。一覧を更新して、もう一度お試しください。';

  @override
  String get memory_entries_are_cross_session_facts_the_agent_remembers_they =>
      'Hermes が記憶した情報がここに表示されます。';

  @override
  String get merge => 'マージ';

  @override
  String get message => 'メッセージ';

  @override
  String get message_hermes => 'Hermesにメッセージ…';

  @override
  String get message_actions => 'メッセージ操作';

  @override
  String get message_copied => 'メッセージをコピーしました';

  @override
  String get migrating => '移行中…';

  @override
  String get migration_complete => '移行完了';

  @override
  String get migration_failed_local_spaces_were_kept_unchanged =>
      '移行に失敗しました。ローカルスペースは変更されていません。';

  @override
  String get migration_incomplete => '移行未完了';

  @override
  String get migration_preview => '移行プレビュー';

  @override
  String get model => 'モデル';

  @override
  String get model_and_thinking_for_this_chat => 'このチャットのモデルと思考';

  @override
  String model_was_not_changed(Object error) {
    return 'モデルは変更されませんでした: $error';
  }

  @override
  String get move_attachment_next => '添付を次へ移動';

  @override
  String get move_attachment_previous => '添付を前へ移動';

  @override
  String get move_chat => 'チャットを移動';

  @override
  String get move_conversation => '会話を移動';

  @override
  String get move_to_project => 'プロジェクトへ移動';

  @override
  String get move_to_space => 'スペースへ移動';

  @override
  String get moved_to_a_project => 'プロジェクトに移動しました';

  @override
  String moved_to(Object label) {
    return '$labelに移動しました';
  }

  @override
  String get name => '名前';

  @override
  String get name_prompt_and_schedule_are_required => '名前・プロンプト・スケジュールは必須です';

  @override
  String get nav_activity => '活動';

  @override
  String get nav_projects => '案件';

  @override
  String get needs_a_correction_aware_filing_contract_in_the_hermes_gateway =>
      'Hermesゲートウェイに訂正対応の仕分けコントラクトが必要です。';

  @override
  String get needs_a_reachable_hermes_dashboard_check_the_host_port_and =>
      '到達可能なHermesダッシュボードが必要です。この接続のホスト・ポート・認証情報を確認してください。';

  @override
  String get needs_a_server_authoritative_assets_index_in_the_hermes_gateway =>
      'Hermesゲートウェイにサーバー権威のアセットインデックスが必要です。';

  @override
  String get needs_durable_pin_ordering_batch_mutation_and_undo_contracts_in =>
      'Hermesゲートウェイに永続的なピン順序・バッチ変更・取り消しのコントラクトが必要です。';

  @override
  String get needs_you => '対応が必要';

  @override
  String get new_label => '新規';

  @override
  String get new_chat => '新しいチャット';

  @override
  String get new_chat_2 => '新しいチャット';

  @override
  String new_chat_3(Object projectName) {
    return '新しいチャット · $projectName';
  }

  @override
  String get new_project => '新しいプロジェクト';

  @override
  String get new_space => '新しいスペース';

  @override
  String next(Object nextRun) {
    return '次回: $nextRun';
  }

  @override
  String get nginx_injects_auth_app_sends_clean_requests =>
      'Nginxが認証を付与 — アプリは素のリクエストを送信';

  @override
  String get no_tts_voices_found_ninstall_google_text_to_speech_and =>
      'TTS音声が見つかりません。\nGoogle Text-to-Speechをインストールして音声データをダウンロードしてください。';

  @override
  String get no_active_projects_on_this_gateway =>
      'このゲートウェイにアクティブなプロジェクトはありません';

  @override
  String get no_activity_yet => 'まだアクティビティはありません';

  @override
  String get no_chat_is_blocked_running_or_waiting_to_be_resumed =>
      '対応が必要なチャットも、実行中・再開待ちのチャットもありません。準備ができたら新しいチャットを始めましょう。';

  @override
  String no_chats_in_this_project_match(Object searchQuery) {
    return 'このプロジェクトに「$searchQuery」に一致するチャットはありません。';
  }

  @override
  String get no_chats_in_this_space_yet_tap_to_start_one =>
      'このスペースにはまだチャットがありません。+ をタップして開始してください。';

  @override
  String get no_chats_yet => 'まだチャットはありません';

  @override
  String get no_connections => '接続がありません';

  @override
  String get no_conversation_matches_this_view => 'このビューに一致する会話はありません。';

  @override
  String get no_cron_jobs => 'Cronジョブはありません';

  @override
  String get no_folders_yet => 'まだフォルダはありません';

  @override
  String get no_local_spaces_were_found_for_this_connection_so_projects =>
      'この接続にローカルスペースは見つかりませんでした。プロジェクトがすでに唯一の整理手段として使われています。';

  @override
  String get no_matches => '一致なし';

  @override
  String get no_memory_entries => 'メモリエントリはありません';

  @override
  String get no_message_content_matches => 'メッセージ内容に一致はありません';

  @override
  String get no_new_messages => '新しいメッセージはありません';

  @override
  String get no_projects_yet => 'まだプロジェクトはありません';

  @override
  String get no_runs_yet => 'まだ実行履歴はありません。';

  @override
  String no_server_project_matches_this_name(Object assigned) {
    return 'この名前に一致するサーバープロジェクトはありません · $assigned';
  }

  @override
  String get no_sessions_yet => 'まだセッションはありません';

  @override
  String get no_skills_found => 'スキルが見つかりません';

  @override
  String get no_spaces_on_this_device => 'この端末にスペースはありません';

  @override
  String get no_text_shared => '共有されたテキストはありません';

  @override
  String get no_turn_is_blocked_in_flight_or_recently_finished_work =>
      '保留中・実行中・最近完了したターンはありません。開始した作業はここに表示されます。';

  @override
  String get no_turn_needs_your_input_or_has_failed =>
      '入力が必要なターンや失敗したターンはありません。';

  @override
  String get no_unassigned_chats => '未割り当てのチャットはありません。';

  @override
  String get nothing_changed_in_the_last_seven_days => '過去7日間に変更はありません。';

  @override
  String get nothing_has_moved_yet_this_is_only_what_a_migration =>
      'まだ何も移動していません — これは移行のプレビューです。';

  @override
  String get nothing_here => 'ここには何もありません';

  @override
  String get nothing_is_running => '実行中のものはありません';

  @override
  String get nothing_needs_you => '対応が必要なものはありません';

  @override
  String get nothing_to_migrate => '移行するものはありません';

  @override
  String get notifications => '通知';

  @override
  String get windows_notifications_blocked =>
      '通知を利用できません。インストール済みのAresアプリを使用し、Windowsの設定 → システム → 通知を確認してください。';

  @override
  String get windows_notification_diagnostics => 'AresがWindowsに送信した内容';

  @override
  String get chat_activity_share => 'チャットの利用状況を共有';

  @override
  String get chat_activity_share_hint =>
      'このチャットの利用中であることを、対応する接続済みのゲートウェイに伝え、電話通知プラグインによる重複通知を防ぎます。キーやメッセージ本文は送信されません。';

  @override
  String get completion_sound => '完了音';

  @override
  String get completion_sound_system => 'システムのデフォルト';

  @override
  String get completion_sound_mail => 'メール';

  @override
  String get completion_sound_reminder => 'リマインダー';

  @override
  String get completion_sound_silent => '無音';

  @override
  String get completion_sound_scope =>
      '応答の完了時、テスト通知、アプリ内で再生します。承認やその他の通知には通常の音を使用します。';

  @override
  String get completion_sound_scope_android =>
      '応答の完了時、テスト通知、アプリ内で再生します。承認、その他の通知、サーバーからのバックグラウンド通知、Android Autoのメッセージには通常の音を使用します。';

  @override
  String get notification_open_action => '開く';

  @override
  String get app_sounds_mute => 'アプリの音をミュート';

  @override
  String get app_sounds_mute_hint => 'Aresを開いている間に鳴る完了音を止めます。通知にはそれぞれの音を使用します。';

  @override
  String get notifications_permission_denied =>
      '通知がOS側で許可されていません。Androidの設定からこのアプリの通知を有効にしてください。';

  @override
  String get off_no_thinking => 'オフ（思考なし）';

  @override
  String get offline_showing_the_last_known_activity =>
      'オフライン — 最後に確認できたアクティビティを表示中。';

  @override
  String get offline_showing_the_last_known_chats => 'オフライン — 最後に確認できたチャットを表示中';

  @override
  String get offline_showing_the_last_known_projects =>
      'オフライン — 最後に確認できたプロジェクトを表示中。';

  @override
  String get on_this_device => 'この端末内';

  @override
  String get on_device => '端末内';

  @override
  String get open_inbox => '受信トレイを開く';

  @override
  String open_inbox_2(Object count) {
    return '受信トレイを開く（$count）';
  }

  @override
  String get open_the_hermes_dashboard => 'Hermesダッシュボードを開く';

  @override
  String get optional_for_the_memory_cron_skills_settings_tabs_leave_blank =>
      '任意。メモリ/Cron/スキル/設定タブで使用します。空欄のままにすると、デフォルトのダッシュボードポート（9119）をログインなしで使用します。';

  @override
  String get organization => '整理';

  @override
  String get other_answer => 'その他の回答';

  @override
  String get overview => '概要';

  @override
  String get passphrase => 'パスフレーズ';

  @override
  String get password_optional => 'パスワード（任意）';

  @override
  String get phone_or_tablet => 'スマホまたはタブレット';

  @override
  String get pin_batch_and_undo => 'ピン留め・一括操作・取り消し';

  @override
  String get plugin_notifications => 'プラグイン通知';

  @override
  String get plugin_notifications_description =>
      'アプリがバックグラウンドの間に、ゲートウェイから通知が届きました。';

  @override
  String get port => 'ポート';

  @override
  String get preparing_attachments => '添付を準備中…';

  @override
  String get preview_truncated => 'プレビューは省略表示';

  @override
  String get preview_unavailable => 'プレビュー不可';

  @override
  String get profile => 'プロファイル';

  @override
  String get profile_default_model => 'プロファイルのデフォルトモデル';

  @override
  String profile_default_set_to_chats_with_their_own_model_keep(
    Object selectedModel,
  ) {
    return 'プロファイルのデフォルトを$selectedModelに設定しました。独自のモデルを使うチャットはそのまま維持されます。';
  }

  @override
  String
  get profile_this_connection_chats_as_when_the_dashboard_serves_several =>
      'ダッシュボードが複数のプロファイルを提供する場合に、この接続がどのプロファイルとしてチャットするか。空欄にするとプロファイルごとに分離されたダッシュボードになります。';

  @override
  String get project => 'プロジェクト';

  @override
  String get project_actions => 'プロジェクト操作';

  @override
  String get project_chat => 'プロジェクトチャット';

  @override
  String get project_chats_unavailable => 'プロジェクトのチャットを利用できません';

  @override
  String get projects => 'プロジェクト';

  @override
  String get projects_group_related_chats_files_and_activity_and_stay_in =>
      'プロジェクトは関連するチャット・ファイル・アクティビティをまとめ、お使いのPC上のHermesと同期します。';

  @override
  String
  get projects_need_a_desktop_gateway_connection_add_the_desktop_gateway =>
      'プロジェクトにはDesktop Gateway接続が必要です。この接続にDesktop Gateway URLを追加すると、端末間でチャットを整理できます。';

  @override
  String get projects_unavailable => 'プロジェクトを利用できません';

  @override
  String get projects_activity_new_navigation => 'プロジェクト、アクティビティ — 新しいナビゲーション';

  @override
  String get promote_to_project => 'プロジェクトに昇格';

  @override
  String get prompt => 'プロンプト';

  @override
  String get protect_this_backup => 'このバックアップを保護';

  @override
  String get provider => 'プロバイダー';

  @override
  String get proxy_injects_auth_app_sends_clean_requests =>
      'プロキシが認証を付与; アプリは素のリクエストを送信';

  @override
  String get quick_chat => 'クイックチャット';

  @override
  String get quick_chats_appear_here_after_their_retention_period =>
      'クイックチャットは保持期間を過ぎるとここに表示されます。';

  @override
  String get read_aloud => '読み上げ';

  @override
  String get read_aloud_is_unavailable_on_this_device => 'この端末では読み上げを利用できません';

  @override
  String get reading_response_aloud => '応答を読み上げ中';

  @override
  String get ready_to_upload => 'アップロード準備完了';

  @override
  String get reasoning => '推論';

  @override
  String get recently_completed => '最近完了';

  @override
  String get recently_active => '最近アクティブ';

  @override
  String get recovering_hermes => 'Hermesを復旧中…';

  @override
  String get refresh => '更新';

  @override
  String get regenerate_response => '応答を再生成';

  @override
  String get remove_attachment => '添付を削除';

  @override
  String get rename => '名前を変更';

  @override
  String get rename_chat => 'チャット名を変更';

  @override
  String get rename_project => 'プロジェクト名を変更';

  @override
  String get rename_space => 'スペース名を変更';

  @override
  String rename_2(Object projectName) {
    return '$projectNameの名前を変更';
  }

  @override
  String rename_3(Object name) {
    return '$nameの名前を変更';
  }

  @override
  String get replace => '置き換え';

  @override
  String get repositories => 'リポジトリ';

  @override
  String
  get research_the_attached_content_verify_the_important_claims_and_cite =>
      '添付コンテンツを調査し、重要な主張を検証して、出典を引用して。';

  @override
  String research_this_content_verify_the_important_claims_and_cite_sources(
    Object text,
  ) {
    return 'この内容を調査し、重要な主張を検証して、出典を引用して:\n\n$text';
  }

  @override
  String reset_failed_the_secure_storage_may_need_reinstall(Object retryError) {
    return 'リセットに失敗しました: $retryError。セキュアストレージの再インストールが必要かもしれません。';
  }

  @override
  String get reset_saved_connections => '保存された接続をリセット';

  @override
  String get responding => '応答中…';

  @override
  String response_closed_locally_gateway_stop_failed(Object error) {
    return '応答はローカルで終了しましたが、ゲートウェイの停止に失敗しました: $error';
  }

  @override
  String get response_closed_locally_no_active_gateway_turn_was_found =>
      '応答はローカルで終了しました。アクティブなゲートウェイターンは見つかりませんでした。';

  @override
  String get response_complete => '応答完了';

  @override
  String get response_complete_description => 'バックグラウンド中にターンが完了しました。';

  @override
  String get response_ready => '応答が完了';

  @override
  String get response_stopped => '応答を停止しました。';

  @override
  String get restore => '復元';

  @override
  String get restore_configuration => '設定を復元';

  @override
  String get restore_project => 'プロジェクトを復元';

  @override
  String get retry => '再試行';

  @override
  String retry_failed_for_the_draft_and_prompt_were_kept(Object name) {
    return '$nameの再試行に失敗しました。ドラフトとプロンプトは保持されています。';
  }

  @override
  String get retry_upload => 'アップロードを再試行';

  @override
  String retrying(Object name) {
    return '$nameを再試行中…';
  }

  @override
  String get review_local_spaces => 'ローカルスペースを確認';

  @override
  String get review_or_promote_quick_chats_past_their_retention_period =>
      '保持期間を過ぎたクイックチャットを確認または昇格';

  @override
  String get review_the_attached_content => '添付コンテンツを確認して。';

  @override
  String get run_only_this_command => 'このコマンドだけを実行します。';

  @override
  String get running_now => '実行中';

  @override
  String get save => '保存';

  @override
  String get save_changes => '変更を保存';

  @override
  String get save_a_permanent_rule_in_the_hermes_configuration =>
      'Hermes設定に永続的なルールを保存します。';

  @override
  String get save_the_durable_facts_from_the_attached_content_to_memory =>
      '添付コンテンツの永続的な事実をメモリに保存し、保存された内容を確認して。';

  @override
  String save_the_durable_facts_from_this_content_to_memory_then(Object text) {
    return 'この内容の永続的な事実をメモリに保存し、保存された内容を確認して:\n\n$text';
  }

  @override
  String get save_your_connections_and_settings_to_an_encrypted_file_then =>
      '接続と設定を暗号化ファイルに保存し、再インストール後や別の端末で復元できます。';

  @override
  String save_2(Object filename) {
    return '$filenameを保存';
  }

  @override
  String get schedule => 'スケジュール';

  @override
  String get scheduled_jobs_and_their_last_runs => 'スケジュールされたジョブと前回の実行';

  @override
  String get scheduled_tasks => 'スケジュールされたタスク';

  @override
  String get script_only_no_agent => 'スクリプトのみ（エージェントなし）';

  @override
  String get scroll_horizontally => '横にスクロール';

  @override
  String get search_all_chats => 'すべてのチャットを検索';

  @override
  String get search_all_message_content => '全メッセージ内容を検索';

  @override
  String get search_chats => 'チャットを検索';

  @override
  String get search_conversations => '会話を検索';

  @override
  String get search_loaded_chats => '読み込み済みチャットを検索';

  @override
  String get search_mode => '検索モード';

  @override
  String get select_one_option_or_enter_another_answer =>
      '1つ選択するか、別の回答を入力してください。';

  @override
  String get select_one_or_more_options_then_continue => '1つ以上選択して続行してください。';

  @override
  String get select_text => 'テキストを選択';

  @override
  String get send => '送信';

  @override
  String send_failed(Object error) {
    return '送信に失敗しました: $error';
  }

  @override
  String send_failed_api_only_permission_denied(Object error) {
    return '送信に失敗しました: $error。サーバーは API キーのプリンシパルによるこの書き込みを拒否しました。このチャットが Dashboard の所有である場合、この接続に Dashboard のユーザー名とパスワードを設定すると送信できることがあります。サーバーが意図的に拒否している可能性もあります。';
  }

  @override
  String get send_message => 'メッセージを送信';

  @override
  String get send_test_notification => 'テスト通知を送信';

  @override
  String get session_sources => 'セッションのソース';

  @override
  String get session_deleted_from_remote_hermes => 'リモートのHermesからセッションを削除しました。';

  @override
  String session_search_failed(Object error) {
    return 'セッション検索に失敗しました: $error';
  }

  @override
  String get set_profile_default => 'プロファイルのデフォルトに設定';

  @override
  String get settings => '設定';

  @override
  String get share_to_hermes => 'Hermesに共有';

  @override
  String get show_passphrase => 'パスフレーズを表示';

  @override
  String get show_tool_calls_thinking_and_message_metadata =>
      'ツール呼び出し・思考・メッセージのメタデータを表示';

  @override
  String get signal_messages => 'Signalのメッセージ';

  @override
  String get skills => 'スキル';

  @override
  String skills_2(Object count) {
    return 'スキル（$count）';
  }

  @override
  String get skills_and_tools => 'スキルとツール';

  @override
  String get skip => 'スキップ';

  @override
  String get slack_chats => 'Slackのチャット';

  @override
  String source(Object source) {
    return 'ソース: $source';
  }

  @override
  String get space_actions => 'スペース操作';

  @override
  String get spaces => 'スペース';

  @override
  String get speak_to_hermes => 'Hermesに話しかける';

  @override
  String get speech_recognition_is_unavailable => '音声認識を利用できません';

  @override
  String get spoken_replies => '読み上げ応答';

  @override
  String get spoken_replies_off => '読み上げオフ';

  @override
  String get spoken_replies_on => '読み上げオン';

  @override
  String get stalled_no_update_from_hermes => '停滞 — Hermesからの更新がありません';

  @override
  String get start_something_new => '新しく始める';

  @override
  String get start_voice_input => '音声入力を開始';

  @override
  String get starting_hermes => 'Hermesを起動中…';

  @override
  String get media_card_download => 'ファイルをダウンロード';

  @override
  String get media_card_tap_to_download => 'タップしてダウンロード';

  @override
  String get still_loading_your_projects => 'プロジェクトを読み込み中です。';

  @override
  String get stop => '停止';

  @override
  String get stop_response => '応答を停止';

  @override
  String get stop_voice_input => '音声入力を停止';

  @override
  String get submitted_waiting_for_hermes => '送信済み、Hermesの応答待ち';

  @override
  String get suggest_projects_and_learn_from_your_corrections =>
      'プロジェクトを提案し、あなたの修正から学習します';

  @override
  String get summarize_the_attached_content => '添付コンテンツを要約して。';

  @override
  String summarize_this_content(Object text) {
    return 'この内容を要約して:\n\n$text';
  }

  @override
  String get switch_profile => 'プロファイルを切り替え';

  @override
  String get system => 'システム';

  @override
  String get take_photo => '写真を撮る';

  @override
  String get tap_to_add_a_remote_hermes_gateway_api_server_port =>
      '+ をタップしてリモートHermesゲートウェイを追加\n（APIサーバー、ポート8642）';

  @override
  String get tap_the_button_to_start_a_new_chat => '+ ボタンをタップして新しいチャットを開始';

  @override
  String get telegram_messages => 'Telegramのメッセージ';

  @override
  String get terminal_sessions => 'ターミナルセッション';

  @override
  String get test_notification_body => 'この通知が見えていれば、通知機能は正常に動作しています。';

  @override
  String get test_notification_sent => 'テスト通知を送信しました。';

  @override
  String get test_notification_title => 'Hermes 通知テスト';

  @override
  String get test_notification_unsupported =>
      '通知を送信できませんでした。OS側で通知が許可されているか確認してください。';

  @override
  String get text_size => '文字サイズ';

  @override
  String get text_size_preview => '文字サイズのプレビュー';

  @override
  String text_size_2(Object label) {
    return '文字サイズ: $label';
  }

  @override
  String get the_api_key_could_not_be_stored_securely => 'APIキーを安全に保存できませんでした。';

  @override
  String get the_project_will_move_to_archived_its_chats_and_files =>
      'プロジェクトはアーカイブ済みに移動します。チャットとファイルはそのまま残り、いつでも復元できます。';

  @override
  String get the_project_will_move_to_archived_its_chats_and_files_2 =>
      'プロジェクトはアーカイブ済みに移動します。チャットとファイルはそのまま残り、後で復元できます。';

  @override
  String get the_active_profile_did_not_return_any_selectable_models =>
      'アクティブなプロファイルに選択可能なモデルがありません。';

  @override
  String get the_backup_could_not_be_exported => 'バックアップを書き出せませんでした。';

  @override
  String get the_backup_could_not_be_restored => 'バックアップを復元できませんでした。';

  @override
  String get the_connection_could_not_be_deleted_safely => '接続を安全に削除できませんでした。';

  @override
  String get the_connection_could_not_be_stored_securely => '接続を安全に保存できませんでした。';

  @override
  String get the_dashboard_credentials_could_not_be_stored_securely =>
      'ダッシュボードの認証情報を安全に保存できませんでした。';

  @override
  String get the_detached_reply_failed => '切り離された応答が失敗しました。';

  @override
  String the_detached_reply_failed_2(Object error) {
    return '切り離された応答が失敗しました: $error';
  }

  @override
  String get the_file_contains_your_api_keys_and_dashboard_password_so =>
      'このファイルにはAPIキーとダッシュボードのパスワードが含まれるため、暗号化されます。このパスフレーズがないとバックアップを復元できません。';

  @override
  String get the_last_turn_failed => '最後のターンが失敗しました';

  @override
  String the_local_connection_store_looks_damaged_you_can_reset_the(
    Object errorType,
  ) {
    return 'ローカルの接続ストアが破損しているようです（$errorType）。保存された接続をリセットして最初からやり直せます。ゲートウェイ上のチャットは影響を受けません。';
  }

  @override
  String get the_model_only_rewrites_your_question_into_a_short_full =>
      'モデルは質問を短い全文検索クエリに書き換えるだけです。Hermesはホスト側に設定済みのプロバイダー認証情報を使用します。';

  @override
  String get the_server_has_not_reported_folders_for_this_project_yet =>
      'サーバーはまだこのプロジェクトのフォルダを報告していません。グローバルなファイルは「その他」から引き続き利用できます。';

  @override
  String get the_turn_failed => 'ターンが失敗しました';

  @override
  String get the_two_passphrases_do_not_match => '2つのパスフレーズが一致しません。';

  @override
  String get the_value_is_sent_directly_to_the_active_hermes_gateway =>
      '入力した値はアクティブなHermesゲートウェイに直接送信され、このAndroidアプリには保存されません。';

  @override
  String get there_are_no_visible_files_in_this_server_folder =>
      'このサーバーフォルダに見えるファイルはありません。';

  @override
  String get thinking_effort => '思考の強度';

  @override
  String get this_hermes_gateway_does_not_support_opening_a_project_yet =>
      'このHermesゲートウェイはまだプロジェクトを開く機能に対応していません。サーバー上のHermesを更新すると、スマホからプロジェクトを閲覧できます。';

  @override
  String get this_hermes_gateway_is_older_than_server_side_projects_so =>
      'このHermesゲートウェイはサーバーサイドプロジェクトより古いため、チャットのグループ化はこの端末内のみになります。端末間で同じプロジェクトを共有するにはHermesを更新してください。';

  @override
  String get this_project_has_no_folder_to_open_the_chat_in =>
      'このプロジェクトでチャットを開始するにはフォルダが必要です。フォルダを追加してから再試行してください。';

  @override
  String get this_chat_has_no_messages_available_in_the_desktop_session =>
      'このチャットには、まだDesktopセッションで利用できるメッセージがありません。';

  @override
  String get this_creates_a_permanent_rule_in_hermes_review_the_full =>
      'Hermesに永続的なルールを作成します。確認する前にコマンド全体を確認してください。';

  @override
  String get this_gateway_does_not_host_projects_yet_update_the_gateway =>
      'このゲートウェイはまだプロジェクトをホストしていません。端末間でチャットを整理するにはゲートウェイを更新してください。';

  @override
  String get this_permanently_deletes_the_project_chats_will_not_be_deleted =>
      'プロジェクトを完全に削除します。チャットは削除されず、未割り当てに戻ります。';

  @override
  String get this_server_doesn_t_offer_background_recovery_chats_run_live =>
      'このサーバーはバックグラウンド復旧に対応していません — チャットはライブで実行されます';

  @override
  String get this_week => '今週';

  @override
  String get titles_previews_and_models => 'タイトル・プレビュー・モデル';

  @override
  String get tool_activity => 'ツールのアクティビティ';

  @override
  String get trigger_now => '今すぐ実行';

  @override
  String get received_outcome_unknown => 'ターン終了 — 結果未確認';

  @override
  String get turn_completed => 'ターン完了';

  @override
  String get turn_failed => 'ターン失敗';

  @override
  String get turn_failed_description => 'バックグラウンドのターンがエラーで終了しました。';

  @override
  String get turn_recovery_failed => 'ターンの復旧に失敗しました';

  @override
  String get unable_to_prepare_this_file_try_another_one =>
      'このファイルを準備できませんでした。別のファイルをお試しください。';

  @override
  String get unable_to_prepare_this_image_try_another_one =>
      'この画像を準備できませんでした。別の画像をお試しください。';

  @override
  String unable_to_prepare(Object name) {
    return '$nameを準備できませんでした。';
  }

  @override
  String get unable_to_read_the_selected_image_the_selection_was_kept =>
      '選択した画像を読み込めませんでした。選択内容は保持されています。';

  @override
  String get unassigned => '未割り当て';

  @override
  String get unassigned_chats => '未割り当てのチャット';

  @override
  String get untitled_chat => '無題のチャット';

  @override
  String get untitled_session => '無題のセッション';

  @override
  String get update_api_key => 'APIキーを更新';

  @override
  String get upload_failed => 'アップロード失敗';

  @override
  String get upload_failed_tap_retry => 'アップロード失敗 • タップで再試行';

  @override
  String uploading(Object index, Object name, Object total) {
    return 'アップロード中 $index/$total: $name';
  }

  @override
  String get use_as_is => 'そのまま使用';

  @override
  String get use_at_least_8_characters => '8文字以上で入力してください。';

  @override
  String get use_for_cron_jobs_backed_by_scripts => 'スクリプトで実行するCronジョブ向けです。';

  @override
  String get use_on_device => '端末内で使用';

  @override
  String get use_the_attached_content_to_identify_and_fill_the_relevant =>
      '添付コンテンツを使って、関連する書類やフォームの項目を特定して記入して。送信する前には必ず確認して。';

  @override
  String use_this_content_to_identify_and_fill_the_relevant_document(
    Object text,
  ) {
    return 'この内容を使って、関連する書類やフォームの項目を特定して記入して。送信する前には必ず確認して:\n\n$text';
  }

  @override
  String get used_for_hosted_path_prefixes_and_for_the_settings_memory =>
      'Settings・Memory・Skills・Cronタブや、ホスト型のパスプレフィックスで使用します。ユーザー名/パスワードが空欄の場合はオープンなダッシュボードとして扱われ、リバースプロキシがダッシュボード認証を付与する場合はプロキシモードを有効にしてください。';

  @override
  String get username_optional => 'ユーザー名（任意）';

  @override
  String using(Object displayName) {
    return '$displayNameを使用中…';
  }

  @override
  String get verbose_mode => '詳細モード';

  @override
  String get message_metadata => 'メッセージの詳細';

  @override
  String get voice => '音声';

  @override
  String voice_setup_failed(Object error) {
    return '音声のセットアップに失敗しました: $error';
  }

  @override
  String get waiting_for_your_input => '入力待ち';

  @override
  String get what_hermes_knows_how_to_do => 'Hermesにできること';

  @override
  String get what_should_the_agent_do => 'エージェントに何をさせますか？';

  @override
  String get whatsapp_messages => 'WhatsAppのメッセージ';

  @override
  String get which_project => 'どのプロジェクト？';

  @override
  String get workspace => 'ワークスペース';

  @override
  String get wrap_lines => '折り返し';

  @override
  String you_can_attach_up_to_items(Object maxRemoteAttachmentDrafts) {
    return '最大$maxRemoteAttachmentDrafts個まで添付できます。';
  }

  @override
  String get your_answer => '回答';

  @override
  String get e_g_dashboard => '例: /dashboard';

  @override
  String get e_g_dashboard_proxy_path_before_api =>
      '例: /dashboard（/api/ より前のプロキシパス）';

  @override
  String get e_g_profile_peter => '例: /profile/peter';

  @override
  String get e_g_sol => '例: sol';

  @override
  String get e_g_0_9_or_every_2h => '例: 0 9 * * * または every 2h';

  @override
  String get e_g_daily_backup => '例: 毎日のバックアップ';

  @override
  String downloaded(Object filename) {
    return '$filenameをダウンロードしました';
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
      '192.168.1.50、100.x.y.z、または hermes-machine.tailnet.ts.net';

  @override
  String get example_profile_prefix_hint_full =>
      '例: /profile/peter（/api/ と /v1/ より前のプロキシパス）';

  @override
  String and_more(Object count) {
    return 'ほか$count件';
  }

  @override
  String chats_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'チャット$count件',
    );
    return '$_temp0';
  }

  @override
  String on_this_device_only(Object chats) {
    return '$chats · この端末のみ';
  }

  @override
  String spaces_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'スペース$count件',
    );
    return '$_temp0';
  }

  @override
  String get no_new_projects_needed => '新しいプロジェクトは不要';

  @override
  String projects_to_create(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'プロジェクトを$count件作成',
    );
    return '$_temp0';
  }

  @override
  String chats_migrated_projects_created(
    Object createdProjects,
    Object linkedSessions,
  ) {
    return '$linkedSessions件のチャットを移行 · $createdProjects件のプロジェクトを作成';
  }

  @override
  String chats_stayed_in_local_spaces(Object unlinkedSessions) {
    return '$unlinkedSessions件のチャットはローカルスペースに残ります。安全に再試行できます。';
  }

  @override
  String model_recommended(Object provider) {
    return '$provider • 推奨: 小型で低コスト';
  }

  @override
  String session_meta(Object count, Object model, Object time) {
    return '$count件のメッセージ • $model • $time';
  }

  @override
  String model_scope_label(Object model, Object scope) {
    return '$model • $scope';
  }

  @override
  String get this_chat => 'このチャット';

  @override
  String get profile_default => 'プロファイルのデフォルト';

  @override
  String minutes_ago(Object count) {
    return '$count分前';
  }

  @override
  String hours_ago(Object count) {
    return '$count時間前';
  }

  @override
  String days_ago(Object count) {
    return '$count日前';
  }

  @override
  String get now_label => 'たった今';

  @override
  String get latest_label => '最新';

  @override
  String new_count_indicator(Object count) {
    return '新着$count件';
  }

  @override
  String new_messages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '新着メッセージ$count件',
    );
    return '$_temp0';
  }

  @override
  String activity_failed_summary(Object failures, Object total) {
    return '$failures件失敗 • 全$total件';
  }

  @override
  String activity_completed_summary(Object count) {
    return '$count件完了';
  }

  @override
  String tool_start_observed(Object time) {
    return '開始を観測 $time（現地時刻）';
  }

  @override
  String tool_last_observed(Object time) {
    return '最終観測 $time（現地時刻）';
  }

  @override
  String tool_result_recorded(Object time) {
    return '結果を記録 $time（現地時刻）';
  }

  @override
  String get tool_time_unavailable => '時刻は不明';

  @override
  String get hermes_is_using_a_tool => 'Hermesがツールを使用中';

  @override
  String hermes_is_using_tools(Object count) {
    return 'Hermesが$count個のツールを使用中';
  }

  @override
  String delegated_tasks_completed(Object count) {
    return '委任タスク$count件が完了';
  }

  @override
  String delegated_tasks_active(Object count) {
    return '委任タスク$count件が実行中';
  }

  @override
  String branch_main(Object label) {
    return '$label · main';
  }

  @override
  String get you_heading => '## あなた';

  @override
  String get hermes_heading => '## Hermes';

  @override
  String get action_label => 'アクション';

  @override
  String get destination_label => '移動先';

  @override
  String get markdown_source => 'ソース';

  @override
  String get preview_label => 'プレビュー';

  @override
  String get share_action_summarize => '要約';

  @override
  String get share_action_explain => '説明';

  @override
  String get share_action_research => '調査';

  @override
  String get share_action_remember => '記憶';

  @override
  String get text_size_small => '小';

  @override
  String get text_size_default => '標準';

  @override
  String get text_size_large => '大';

  @override
  String get text_size_extra_large => '特大';

  @override
  String get text_size_use_system_description =>
      'Androidのアクセシビリティ文字サイズをそのまま使用します。';

  @override
  String text_size_percent_description(Object percent) {
    return 'Androidの文字サイズの$percent%';
  }

  @override
  String text_size_label_description(Object description, Object label) {
    return '$label — $description';
  }

  @override
  String files_skipped(Object count) {
    return '$count件のファイルをスキップしました: 上限・サイズ・読み取り不可・機密ファイル名';
  }

  @override
  String model_scope_applied(Object effort, Object model) {
    return '$model • $effort はこのチャットのみに適用されます。';
  }

  @override
  String get reasoning_minimal => '最小';

  @override
  String get reasoning_low => '低';

  @override
  String get reasoning_medium => '中';

  @override
  String get reasoning_high => '高';

  @override
  String get reasoning_max => '最大';

  @override
  String get reasoning_ultra => 'ウルトラ';

  @override
  String get status_running => '実行中';

  @override
  String get status_failed => '失敗';

  @override
  String get status_done => '完了';

  @override
  String get status_idle => '待機中';

  @override
  String get upload_status_uploading => 'アップロード中';

  @override
  String get upload_status_uploaded => 'アップロード済み';

  @override
  String attachment_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '添付$count件',
    );
    return '$_temp0';
  }

  @override
  String get action_create => '作成';

  @override
  String get action_rename => '名前の変更';

  @override
  String get action_archive => 'アーカイブ';

  @override
  String get action_restore => '復元';

  @override
  String get action_delete => '削除';

  @override
  String get migrate => '移行';

  @override
  String assigned_chats(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '割り当て済みチャット$count件',
    );
    return '$_temp0';
  }

  @override
  String get date_today => '今日';

  @override
  String get date_yesterday => '昨日';

  @override
  String get date_earlier => 'それ以前';

  @override
  String get nav_home => 'ホーム';

  @override
  String get nav_more => 'その他';

  @override
  String get status_completed => '完了';

  @override
  String get filter_all => 'すべて';

  @override
  String get filter_recent => '最近';

  @override
  String connection_address_key(Object address, Object status) {
    return '$address  •  キー: $status';
  }

  @override
  String model_via_provider(Object model, Object provider) {
    return '$model  \n`$provider` 経由';
  }

  @override
  String get deny => '拒否';

  @override
  String get connect => '接続';

  @override
  String get appearance => '外観';

  @override
  String get connection_section => '接続';

  @override
  String get about => 'このアプリ';

  @override
  String version_label(Object version) {
    return 'バージョン $version';
  }

  @override
  String get matched => '一致';

  @override
  String get search => '検索';

  @override
  String get on => 'オン';

  @override
  String get off => 'オフ';

  @override
  String get reasoning_off => 'オフ';

  @override
  String get hermes_response_ready => 'Hermesの応答';

  @override
  String get admin_password_needed => '管理者パスワードが必要です';

  @override
  String get hermes_needs_a_sudo_password_for_the_pending_terminal_command =>
      '保留中のターミナルコマンドの実行にsudoパスワードが必要です。';

  @override
  String get sudo_password => 'sudoパスワード';

  @override
  String get secret_needed => 'シークレットが必要です';

  @override
  String get hermes_needs_a_secret_for_the_pending_skill =>
      '保留中のスキルの実行にシークレットが必要です。';

  @override
  String get secret_value => 'シークレットの値';

  @override
  String get attached_file => '添付ファイル';

  @override
  String get pin_chat => 'チャットをピン留め';

  @override
  String get unpin_chat => 'ピン留めを解除';

  @override
  String get pinned_chats => 'ピン留め';

  @override
  String could_not_update_chat_pin(Object error) {
    return 'チャットのピン留めを更新できませんでした: $error';
  }

  @override
  String get could_not_save_chat_spaces => 'この端末でチャットスペースを保存できませんでした';

  @override
  String get chat_density => 'チャットの密度';

  @override
  String chat_density_2(Object label) {
    return 'チャットの密度: $label';
  }

  @override
  String get chat_density_comfortable => 'ゆったり';

  @override
  String get chat_density_compact => 'コンパクト';

  @override
  String get chat_density_comfortable_description =>
      '各メッセージの上に送信者ラベルが付いた、ゆったりとした吹き出し。';

  @override
  String get chat_density_compact_description =>
      'ラベルなしの詰まった吹き出しで、より多くのメッセージを表示します。';

  @override
  String chat_density_label_description(Object description, Object label) {
    return '$label — $description';
  }

  @override
  String
  get compact_removes_the_you_and_hermes_labels_and_trims_bubble_padding_spacing_and_side_margins =>
      'コンパクトでは「You」「Hermes」のラベルを外し、吹き出しの余白・間隔・左右のマージンを詰めます。';

  @override
  String get client_certificate_mtls => 'クライアント証明書（mTLS）';

  @override
  String get client_certificate_mtls_description =>
      'HTTPSプロキシが相互TLSを要求する場合に証明書を提示します。';

  @override
  String get client_certificate_https_only => 'クライアント証明書はHTTPS接続でのみ使用します。';

  @override
  String get choose_certificate => '証明書を選択';

  @override
  String get certificate_password => '証明書のパスワード';

  @override
  String get this_certificate_is_password_protected =>
      'この証明書はパスワードで保護されています。入力すると開きます。';

  @override
  String get enter_the_certificate_password_to_finish_loading_it =>
      '選択した証明書の読み込みを完了するには、証明書のパスワードを入力してください。';

  @override
  String get client_certificate_required =>
      'クライアント証明書を読み込むか、クライアント証明書のオプションをオフにしてください。';

  @override
  String client_certificate_loaded(String label) {
    return '読み込み済み：$label';
  }

  @override
  String get remove_certificate => '証明書を削除';

  @override
  String get certificate_import_failed => 'その証明書を読み込めませんでした。';

  @override
  String get background_work => 'バックグラウンド動作';

  @override
  String get keep_chats_active_in_background => 'バックグラウンドでもチャットを接続';

  @override
  String get background_work_description =>
      'ユーザーが開始したチャットの接続を、アプリがバックグラウンドにある間も維持します。待機中の接続は切断される場合があります。バッテリーと通信量を多く使います。オフにしてもサーバー上の処理は停止しません。';

  @override
  String get background_work_limits =>
      'Android は Doze 中に接続を休止したり、アプリのプロセスを終了したりする場合があります。プロセス終了後の通知には、別途プッシュ設定が必要です。強制停止には対応していません。';

  @override
  String get background_work_disclosure =>
      'バックグラウンド保護が有効な間は、任意のチャット通知がオフでも、必須のサービス通知が表示されます。';

  @override
  String get battery_optimisation_settings => 'バッテリー最適化の設定';

  @override
  String get battery_optimisation_description =>
      'Android の設定を開き、バッテリー制限を確認します。最適化の除外を自動では要求しません。設定を変更しても通知の到達は保証されません。';

  @override
  String get battery_settings_unavailable => 'この端末ではバッテリー設定を開けませんでした。';

  @override
  String get background_work_save_failed => 'バックグラウンド動作の設定を保存できませんでした。';

  @override
  String get ongoing_chat_channel_name => '進行中のチャット';

  @override
  String get ongoing_chat_channel_description => 'ユーザーが開始した未完了のチャットの静かな状態通知';

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
  String get activity_status_unconfirmed => '状態未確認';

  @override
  String get activity_recently_updated => '最近更新';

  @override
  String get activity_reconnecting => '再接続中 — ターンの状態を確認しています';

  @override
  String get activity_outcome_unknown => 'ターンの結果を確認できませんでした。チャットを開いて確認してください。';

  @override
  String get activity_chat_updated_detail =>
      'ゲートウェイが記録したチャットのアクティビティです。ターンの現在の状態は確認できません。';

  @override
  String get activity_updated => '更新済み';

  @override
  String get activity_empty_title => '最近のアクティビティはありません';

  @override
  String get activity_empty_detail =>
      'このアプリで開始したターンと、過去7日間に更新されたゲートウェイのチャットがここに表示されます。';

  @override
  String get activity_read_error =>
      'アクティビティでターンの記録またはゲートウェイのチャットを読み取れませんでした。接続を確認して、もう一度お試しください。';

  @override
  String get activity_chat_unavailable =>
      'このチャットは利用できなくなったか、ゲートウェイに接続できませんでした。';

  @override
  String get activity_partial_title => 'アクティビティは一部のみ読み込まれています';

  @override
  String get activity_partial_detail =>
      'ゲートウェイのアクティビティを限られた範囲で表示しています。他にもチャットがある可能性があります。下に引いて更新してください。';

  @override
  String get provider_usage => '記録された使用量';

  @override
  String get provider_usage_notice =>
      '過去30日間のHermes使用量です。残高やモデル料金ではありません。認証情報はHermesサーバーで設定してください。このアプリはプロバイダーのAPIキーを保存しません。';

  @override
  String get provider_usage_failed => '使用量を読み込めませんでした。';

  @override
  String get provider_usage_empty => 'このプロバイダーの使用記録はありません。';

  @override
  String provider_usage_counts(String sessions, String input, String output) {
    return '$sessions セッション · 入力: $input · 出力: $output';
  }

  @override
  String provider_usage_costs(String estimated, String actual) {
    return '推定: $estimated · 報告: $actual';
  }

  @override
  String get provider_quota_codex => 'OpenAI Codex サブスクリプション';

  @override
  String get provider_quota_claude => 'Claude サブスクリプション';

  @override
  String get provider_quota_openai_api => 'OpenAI API の記録済み使用量';

  @override
  String get provider_quota_notice =>
      'プロバイダーが報告したサブスクリプションの利用枠です。Hermes が記録した使用量や API の請求とは別です。アカウントごとに表示されます。モデルの上限に達しても、アカウント全体の利用枠を使い切ったことにはなりません。';

  @override
  String get provider_quota_windows_notice =>
      'Codex と Claude のサブスクリプションには、5時間のセッション単位と週単位の上限があります。プロバイダーが報告した利用枠のみを表示し、報告されていない上限やリセット時刻は表示できません。週単位の上限は、アカウント全体または特定のモデルに適用される場合があります。';

  @override
  String get provider_quota_five_hour_session => '5時間のセッション';

  @override
  String get provider_quota_unavailable => 'サブスクリプションの利用枠を取得できません。';

  @override
  String get provider_quota_failed =>
      'サブスクリプションの利用枠を更新できませんでした。保持されている値は前回の取得時のものです。';

  @override
  String get provider_quota_account => 'アカウント';

  @override
  String get provider_quota_unknown => '不明';

  @override
  String provider_quota_state(String state) {
    return 'アカウントの状態: $state';
  }

  @override
  String provider_quota_scope(String scope) {
    return '適用範囲: $scope';
  }

  @override
  String provider_quota_percent(String used, String remaining) {
    return '$used% 使用済み · 残り $remaining%';
  }

  @override
  String provider_quota_reset(String reset) {
    return 'リセット: $reset';
  }

  @override
  String get provider_quota_reset_unknown => 'リセット時刻を取得できません。';

  @override
  String get auxiliary_models => '補助モデル';

  @override
  String get auxiliary_notice =>
      'タスクごとのモデルを選択します。カスタムエンドポイントはサーバーで管理してください。自動はタスクの継承ルールに従います。';

  @override
  String get auxiliary_inherit => '自動（継承）';

  @override
  String get auxiliary_unavailable => '補助設定を利用できません。';

  @override
  String get provider_oauth_title => 'プロバイダーへのログイン';

  @override
  String get provider_oauth_more_subtitle => 'Hermesホストでプロバイダーへのログインを管理';

  @override
  String get provider_oauth_settings_subtitle =>
      'Hermesホストにログインします。プロバイダーのトークンはこの端末に保存されません';

  @override
  String get provider_oauth_intro =>
      '外部ブラウザーでプロバイダーにログインします。トークンはHermesホストにのみ保存され、この端末には保存されません。ログインしても、このアプリのチャットモデルは選択されません。';

  @override
  String get provider_oauth_defaults_notice =>
      'Nousの無料アカウントの置き換えなど、一部のホスト側の処理でホストの既定値が変更される場合があります。ログイン後にホストの設定を確認してください。';

  @override
  String get provider_oauth_transport_init_failed =>
      '選択した安全なダッシュボード接続を初期化できませんでした。TLS IDと接続設定を確認してください。';

  @override
  String get provider_oauth_https_required =>
      'プロバイダーへのログインには、HermesダッシュボードへのHTTPS接続が必要です。';

  @override
  String get provider_oauth_auth_required =>
      'ログインする前に、ダッシュボードのパスワード認証または信頼できるプロキシを設定してください。';

  @override
  String get provider_oauth_catalog_failed =>
      'このホストではプロバイダーへのログインを利用できません。ダッシュボードの認証を確認し、プロバイダーOAuthに対応していない場合はホストを更新してください。';

  @override
  String get provider_oauth_expired => 'ログインの有効期限が切れました。やり直してください。';

  @override
  String get provider_oauth_start_failed =>
      '安全なプロバイダーログインを開始できませんでした。もう一度お試しください。';

  @override
  String get provider_oauth_denied => 'ログインが拒否されました。やり直してください。';

  @override
  String get provider_oauth_cancelled => 'ログインをキャンセルしました。';

  @override
  String get provider_oauth_host_failed => 'ホストがログインを完了できませんでした。やり直してください。';

  @override
  String get provider_oauth_poll_failed => 'ログイン状態を確認できませんでした。やり直してください。';

  @override
  String provider_oauth_cancellation_unconfirmed(String message) {
    return '$message キャンセルを確認できませんでした。ホストのセッションは有効期限まで継続する可能性があります。';
  }

  @override
  String get provider_oauth_browser_failed =>
      '外部ブラウザーを開けませんでした。再試行するか、ログインをキャンセルしてください。';

  @override
  String get provider_oauth_retry => '再試行';

  @override
  String provider_oauth_complete(String provider) {
    return '$providerへのログインを完了';
  }

  @override
  String get provider_oauth_code_instruction => 'プロバイダーのページに次の一時コードを入力してください：';

  @override
  String get provider_oauth_waiting => '承認を待っています。このセッションは自動的に期限切れになります。';

  @override
  String get provider_oauth_open_browser => 'ブラウザーでプロバイダーを開く';

  @override
  String get provider_oauth_cancel => 'ログインをキャンセル';

  @override
  String get provider_oauth_signed_out => 'ホストに未ログイン';

  @override
  String get provider_oauth_sign_in_again => '再ログイン';

  @override
  String get provider_oauth_sign_in => 'ログイン';

  @override
  String get provider_oauth_cli_required =>
      'Hermesホスト上でプロバイダーのCLIを使ってログインしてください。このホストでは、このプロバイダーのアプリ内ログインを利用できません。';

  @override
  String get provider_oauth_checking_account => '承認を受信しました。ホストのアカウントを確認中…';

  @override
  String get provider_oauth_verification_unavailable =>
      '承認を受信しましたが、アカウントを検証できません。「使用状況」を開いてアカウントの使用状況を更新してください。';

  @override
  String provider_oauth_verified_account(String email) {
    return 'Hermesホストに $email としてサインインしました。「使用状況」を開いてアカウントの使用状況を更新してください。';
  }

  @override
  String get provider_oauth_credentials_unverified =>
      'ホストは認証情報が利用可能と報告していますが、アカウントの本人確認は完了していません。';

  @override
  String get provider_oauth_account_status_unknown => 'ホストのアカウント状態を取得できません。';

  @override
  String get app_language => 'アプリの言語';

  @override
  String get app_language_system => '端末と同じ';

  @override
  String get auto_archives_after_72_hours => '72時間後に自動でアーカイブ';

  @override
  String get automation => '自動化';

  @override
  String get voice_recording_start => '音声メッセージを録音';

  @override
  String get voice_recording_pause => '録音を一時停止';

  @override
  String get voice_recording_preview => '録音を再生';

  @override
  String get voice_recording_resume => '録音を続ける';

  @override
  String get voice_recording_send => '音声メッセージを送信';

  @override
  String get voice_recording_discard => '録音を破棄';

  @override
  String get voice_recording_processing => '音声メッセージを準備中…';

  @override
  String voice_recording_elapsed(String time) {
    return '録音中 $time';
  }

  @override
  String voice_recording_draft(String time) {
    return '音声メッセージ $time';
  }

  @override
  String get voice_recording_permission => '音声メッセージを録音するには、マイクへのアクセスを許可してください。';

  @override
  String get voice_recording_limit => '録音が上限の10分に達しました。';

  @override
  String get voice_recording_empty => '音声が録音されませんでした。もう一度お試しください。';

  @override
  String get voice_recording_failed => '録音を処理できませんでした。保存済みの録音部分は保持されています。';

  @override
  String get voice_recording_unconfirmed =>
      '配信を確認できませんでした。録音は保存されています。再試行する前にチャットを確認してください。';

  @override
  String get voice_recording_submit_failed =>
      '音声メッセージを送信できませんでした。録音は保存されています。接続、ダッシュボードへのアクセス、サーバーの文字起こし設定を確認してください。';

  @override
  String get voice_recording_pause_playback => '再生を一時停止';

  @override
  String get projects_root_title => 'サーバー上のプロジェクトフォルダー';

  @override
  String get projects_root_more_subtitle => 'サーバー上で新しいプロジェクトフォルダーを作る場所';

  @override
  String get projects_root_description =>
      'この端末で作成したプロジェクトのフォルダーはここに作られます。Hermes 自身が使うフォルダーを指定すると、端末とサーバーが同じプロジェクトを共有します。';

  @override
  String get projects_root_label => 'プロジェクトのルートパス';

  @override
  String projects_root_default_hint(String path) {
    return 'サーバーの既定値: $path';
  }

  @override
  String get projects_root_locked_title => 'サーバーで設定済み';

  @override
  String get projects_root_locked_explanation =>
      'このサーバーはファイルアクセスを単一のルートに制限しているため、プロジェクトフォルダーをアプリから変更できません。';

  @override
  String get projects_root_saved => 'プロジェクトフォルダーを保存しました。';

  @override
  String get projects_root_reset => 'サーバーの既定値を使う';

  @override
  String get projects_root_invalid_empty => 'フォルダーのパスを入力してください。';

  @override
  String get projects_root_invalid_absolute => 'スラッシュで始まる絶対パスを入力してください。';

  @override
  String get projects_root_invalid_segments => 'パスからドットのセグメントと制御文字を削除してください。';

  @override
  String get projects_root_unsupported =>
      'この接続では利用できません。サーバーのプロジェクトフォルダーを読み取ったり変更するには、ダッシュボードにアクセスできる Desktop Gateway 接続が必要です。';

  @override
  String get projects_root_unavailable =>
      'サーバーのプロジェクトフォルダーを読み取れませんでした。ダッシュボードの接続を確認して再試行してください。';

  @override
  String get adopt_folder_action => '既存のフォルダーを追加';

  @override
  String adopt_folder_description(String root) {
    return '$root 配下にあり、まだプロジェクトとして登録されていないフォルダーです。';
  }

  @override
  String adopt_folder_registered(String name) {
    return 'すでにプロジェクトです: $name';
  }

  @override
  String get adopt_folder_none => 'このパス配下のフォルダーはすべてプロジェクトになっています。';

  @override
  String get adopt_folder_unsupported =>
      'この接続ではサーバーのフォルダーを一覧できません。既存フォルダーの絶対パスを入力してください。';

  @override
  String adopt_folder_failed(String error) {
    return 'サーバーのフォルダーを一覧できませんでした: $error';
  }

  @override
  String get adopt_folder_manual_label => '既存フォルダーのパス';

  @override
  String get adopt_folder_name_label => 'プロジェクト名';

  @override
  String get adopt_folder_add => 'プロジェクトとして追加';

  @override
  String adopt_folder_added(String name, String path) {
    return '$name は $path を使うようになりました';
  }

  @override
  String adopt_folder_error(String error) {
    return 'フォルダーを追加できませんでした: $error';
  }

  @override
  String adopt_folder_folderless(String name) {
    return '$name は作成されましたが、フォルダーが関連付けられませんでした。サーバーの Hermes から関連付けてください。';
  }

  @override
  String get slash_commands => 'Slash commands';

  @override
  String get slash_commands_loading => 'Loading commands…';

  @override
  String get slash_commands_empty => 'No matching commands';

  @override
  String slash_command_info_alias(String alias, String command) {
    return '$alias は $command の別名です';
  }

  @override
  String get slash_command_info_no_description => '説明はありません。';

  @override
  String get slash_command_info_arguments_options => '決められた選択肢から1つを指定します。';

  @override
  String get slash_command_info_arguments_text => 'コマンドの後にテキストを指定します。';

  @override
  String get slash_command_info_arguments_mixed => 'コマンドの後に選択肢またはテキストを指定します。';

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
  String get slash_command_unsupported => 'このコマンドはこのサーバーでは利用できません。';

  @override
  String get slash_sessions_inline => 'セッションリストを開いてチャットを選択してください。下書きは保持されています。';

  @override
  String get composer_snippets => 'プロンプト定型文';

  @override
  String get composer_snippets_description => '入力欄に挿入する開始用のプロンプトを選んでください。';

  @override
  String get composer_snippet_review => 'コードレビュー';

  @override
  String get composer_snippet_review_body =>
      '今回の変更にリグレッション、見落とした境界ケース、不足しているテストがないか確認します。';

  @override
  String get composer_snippet_review_text =>
      'バグ、リグレッション、不足しているテストがないかレビューしてください。';

  @override
  String get composer_snippet_plan => '実装計画';

  @override
  String get composer_snippet_plan_body => '変更範囲を絞るため、コードに手を加える前に方針をまとめます。';

  @override
  String get composer_snippet_plan_text => 'コードを変更する前に、簡潔な実装計画を作成してください。';

  @override
  String get composer_snippet_explain => 'これを説明';

  @override
  String get composer_snippet_explain_body => '選択したコードの仕組みを順に説明し、主要なファイルを示します。';

  @override
  String get composer_snippet_explain_text => 'この仕組みを説明し、主要なファイルを教えてください。';

  @override
  String get composer_status => 'ステータス';

  @override
  String get composer_status_context => 'コンテキスト';

  @override
  String get composer_status_cache => 'キャッシュヒット';

  @override
  String get composer_status_throughput => '出力トークン/秒';

  @override
  String get composer_status_running => '実行中';

  @override
  String get composer_status_session => 'セッション';

  @override
  String get composer_status_not_reported => '報告なし';

  @override
  String get composer_status_empty => 'コンテキストの内訳は報告されていません。';

  @override
  String get composer_status_loading => 'コンテキストの内訳を読み込み中';

  @override
  String get composer_status_reset => 'ステータスバーをリセット';

  @override
  String get composer_resume_title => 'チャットを再開';

  @override
  String get composer_resume_search => 'タイトルとIDを検索';

  @override
  String get composer_resume_empty => '一致するチャットはありません。';

  @override
  String get composer_resume_unavailable => 'このペインには検索できるチャット一覧がありません。';

  @override
  String get composer_failure_retry => '再試行';

  @override
  String composer_failure_retry_at(String time) {
    return '$timeに再試行';
  }

  @override
  String get composer_failure_compress => '圧縮';

  @override
  String get composer_failure_switch_model => 'モデルを切り替え';

  @override
  String composer_failure_switch_to(String model) {
    return '$modelに切り替え';
  }

  @override
  String get composer_failure_new_chat => '新しいチャット';

  @override
  String get composer_failure_edit => 'メッセージを編集';

  @override
  String get composer_failure_details => '詳細';

  @override
  String get composer_failure_hide_details => '詳細を非表示';

  @override
  String get composer_failure_copy => '診断情報をコピー';

  @override
  String get composer_failure_account =>
      'もう一つの解決策は、ゲートウェイのアカウント側での対応です。このチャットでは対応できません。';

  @override
  String get composer_failure_account_only =>
      'ゲートウェイのアカウント側で修正する必要があります。このチャットでは対応できません。';

  @override
  String get composer_failure_confirm_compress =>
      'このチャットを圧縮しますか？ゲートウェイが会話記録を短縮します。';

  @override
  String composer_failure_confirm_model(String model) {
    return 'このチャットを$modelに切り替えますか？';
  }

  @override
  String get composer_drop_attach => 'ドロップして添付';

  @override
  String get composer_drop_folder_unsupported =>
      'フォルダーは添付できません。代わりにファイルをドロップしてください。';

  @override
  String get composer_drop_reference => 'ドロップして参照を追加';

  @override
  String get composer_reference_copy => '参照をコピー';

  @override
  String get composer_reference_remove => '参照を削除';

  @override
  String get composer_btw_usage =>
      '使い方：/btw <question> — 会話を中断せず、この会話のスナップショットに基づいて回答します。';

  @override
  String get composer_background_usage =>
      '使い方：/background <prompt> — タスクを別途実行し、結果をここに返します。';

  @override
  String get composer_handoff_usage =>
      '使い方：/handoff <platform> — このチャットを指定のメッセージングプラットフォームに引き継ぎます。';

  @override
  String get composer_command_needs_session => 'このコマンドには開いているチャットが必要です。';

  @override
  String get composer_retry_not_found =>
      'このターンは保存済みの履歴にないため、再試行で置き換えることができません。再送信は行っていません。もう一度試すには、メッセージを編集して送信してください。';

  @override
  String get composer_retry_unavailable =>
      'この接続では再試行でターンを置き換えられないため、再送信は行っていません。もう一度試すには、メッセージを編集して送信してください。';

  @override
  String get composer_failure_switch_no_retry =>
      '切り替えで変わるのはモデルだけです。この接続では失敗したターンを再実行できません。切り替えた後にもう一度送信してください。';

  @override
  String get composer_command_needs_gateway_session =>
      'このチャットにはまだゲートウェイのセッションがありません。まずメッセージを送信してから、もう一度コマンドを実行してください。';

  @override
  String get composer_side_question => 'btw — 会話のスナップショットから回答中';

  @override
  String composer_side_question_id(String id) {
    return 'btw $id — 会話のスナップショットから回答中';
  }

  @override
  String get composer_background_started =>
      'バックグラウンドタスクを開始しました。チャットは続けられます。結果はここに表示されます。';

  @override
  String composer_background_started_id(String id) {
    return 'バックグラウンドタスク$idを開始しました。チャットは続けられます。結果はここに表示されます。';
  }

  @override
  String composer_handoff_requested(String platform) {
    return '$platformへの引き継ぎを要求しました。';
  }

  @override
  String composer_handoff_done(String platform) {
    return 'このチャットを$platformに引き継ぎました。';
  }

  @override
  String get composer_handoff_failed => '引き継ぎに失敗しました。';

  @override
  String get composer_handoff_timeout =>
      '引き継ぎが完了しませんでした。ゲートウェイでまだ実行中の可能性があります。';

  @override
  String get composer_compress_done => 'このチャットを圧縮しました。';

  @override
  String get composer_file_missing => 'そのファイルはこの端末にありません。';

  @override
  String get composer_attach_busy => 'この応答が完了すると添付ファイルを追加できます。';

  @override
  String get nextgen_toggle => 'NextGen インターフェース';

  @override
  String get nextgen_toggle_subtitle =>
      '1回のサインイン、ライブチャット、ネットワーク検出を備えた新しいデザイン。ゲートウェイとチャットはこのインターフェースと共有されます。';

  @override
  String get nextgen_single_login => '1つのログインでサインイン';

  @override
  String get nextgen_single_login_subtitle =>
      'ダッシュボードのアドレスと1回のサインインだけでゲートウェイを追加します。';

  @override
  String get ng_allow_this_command => 'このコマンドを許可しますか？';

  @override
  String ng_hermes_wants_to_run_this_with(Object tool) {
    return 'Hermes が $tool を使ってこれを実行しようとしています。';
  }

  @override
  String get ng_hermes_wants_to_run_this => 'Hermes がこれを実行しようとしています。';

  @override
  String get ng_hermes_has_a_question => 'Hermes からの質問';

  @override
  String get ng_hermes_has_questions => 'Hermes からの質問';

  @override
  String get ng_password_for_sudo => 'sudo のパスワード';

  @override
  String get ng_hermes_needs_your_sudo_password_to =>
      'このコマンドを実行するには、Hermes に sudo のパスワードが必要です。';

  @override
  String get ng_a_secret_value => 'シークレット値';

  @override
  String ng_value_for(Object variable) {
    return '$variable の値';
  }

  @override
  String get ng_your_password_manager => 'お使いのパスワードマネージャー';

  @override
  String ng_unlock(Object name) {
    return '$name のロックを解除';
  }

  @override
  String ng_hermes_needs_unlocked_to_sign_in(Object name) {
    return 'Hermes が代理でサインインするには、$name のロックを解除する必要があります。';
  }

  @override
  String get ng_sign_in_code => 'サインインコード';

  @override
  String get ng_enter_the_sign_in_code => 'サインインコードを入力してください。';

  @override
  String ng_enter_the_sign_in_code_for(Object site) {
    return '$site のサインインコードを入力してください。';
  }

  @override
  String get ng_save_a_login => 'ログイン情報を保存しますか？';

  @override
  String ng_save_your_login(Object site) {
    return '$site のログイン情報を保存しますか？';
  }

  @override
  String ng_couldn_t_load_this_chat(Object error) {
    return 'このチャットを読み込めませんでした: $error';
  }

  @override
  String ng_live_updates_are_unavailable(Object error) {
    return 'リアルタイム更新を利用できません: $error';
  }

  @override
  String ng_preparing(Object name) {
    return '$name を準備中…';
  }

  @override
  String get ng_the_turn_failed => '応答の生成に失敗しました。';

  @override
  String get ng_turn_changed => 'その応答はすでに終了したか、新しい応答が始まりました';

  @override
  String get ng_steer_rejected => '実行中の応答が受け付けませんでした';

  @override
  String get ng_turn_not_known_yet => '実行中の応答をまだ確認できません。少し待ってからもう一度お試しください';

  @override
  String ng_couldn_t_stop(Object error) {
    return '停止できませんでした: $error';
  }

  @override
  String get ng_server_access => 'サーバー接続';

  @override
  String get ng_sign_in => 'サインイン';

  @override
  String get ng_live_connection => 'ライブ接続';

  @override
  String get ng_check_that_tailscale_is_on_on =>
      'このスマートフォンとサーバーの両方で Tailscale がオンになっているか確認してください。';

  @override
  String get ng_check_the_address_and_that_the =>
      'アドレスと、プロキシがダッシュボードに転送していることを確認してください。';

  @override
  String get ng_use_the_same_network_as_the =>
      'サーバーと同じネットワークに接続し、他のデバイスからアクセスできるように --host 0.0.0.0 を指定してダッシュボードを起動してください。';

  @override
  String get ng_check_the_address_vpn_or_tailscale =>
      'アドレス、VPN、または Tailscale の接続を確認してください。';

  @override
  String get ng_not_checked_yet => '未確認です。';

  @override
  String get ng_checking => '確認中…';

  @override
  String ng_hermes_answers_at(Object version, Object address) {
    return 'Hermes $version に接続できます: $address';
  }

  @override
  String get ng_something_answered_but_not_a_hermes =>
      '応答はありましたが、Hermes ダッシュボードではありません。';

  @override
  String ng_something_answered_http_but_not_a(Object status) {
    return '応答はありましたが（HTTP $status）、Hermes ダッシュボードではありません。';
  }

  @override
  String get ng_use_the_dashboard_s_address_and =>
      'API サーバーではなく、ダッシュボードのアドレスとポート（既定は 9119）を使用してください。';

  @override
  String get ng_cloudflare_access_turned_the_service_token =>
      'Cloudflare Access にサービス トークンを拒否されました。';

  @override
  String get ng_cloudflare_access_is_in_front_of =>
      'このアドレスの前段に Cloudflare Access があります。';

  @override
  String get ng_check_the_service_token_and_its =>
      'サービス トークンと Service Auth ポリシーを確認してください。';

  @override
  String get ng_add_a_cloudflare_access_service_token =>
      'このアドレス用の Cloudflare Access サービス トークンを追加してください。';

  @override
  String get ng_the_server_asks_for_a_client => 'サーバーからクライアント証明書を求められています。';

  @override
  String get ng_pick_the_client_certificate_for_this =>
      'このゲートウェイ用のクライアント証明書を選択して、もう一度テストしてください。';

  @override
  String get ng_needs_server_access_first => '先にサーバーへの接続が必要です。';

  @override
  String get ng_needs_a_sign_in_first => '先にサインインが必要です。';

  @override
  String ng_signed_in_as(Object name) {
    return '$name としてサインイン中です。';
  }

  @override
  String get ng_this_dashboard_doesn_t_need_a => 'このダッシュボードではサインインは不要です。';

  @override
  String get ng_the_saved_sign_in_has_expired => '保存されたサインインの有効期限が切れています。';

  @override
  String get ng_sign_in_again => 'もう一度サインインしてください。';

  @override
  String get ng_too_many_sign_in_attempts => 'サインインの試行回数が多すぎます。';

  @override
  String get ng_wait_a_minute_then_check_again => '1 分ほど待ってから、もう一度確認してください。';

  @override
  String ng_the_gateway_answered(Object message) {
    return 'ゲートウェイからの応答: $message';
  }

  @override
  String get ng_sign_in_again_or_update_hermes =>
      'もう一度サインインするか、Hermes を更新してください。';

  @override
  String ng_couldn_t_check_the_sign_in(Object error) {
    return 'サインインを確認できませんでした: $error';
  }

  @override
  String ng_the_gateway_wouldn_t_issue_a(Object message) {
    return 'ゲートウェイがチャットチケットを発行しませんでした（$message）。';
  }

  @override
  String get ng_the_chat_connection_opened_and_the =>
      'チャット接続が確立され、ゲートウェイから準備完了の応答がありました。';

  @override
  String get ng_the_gateway_never_said_it_was => 'ゲートウェイから準備完了の応答がありませんでした。';

  @override
  String get ng_check_that_the_agent_is_running => 'サーバーでエージェントが実行中か確認してください。';

  @override
  String get ng_the_gateway_refused_the_chat_connection =>
      'ゲートウェイにチャット接続を拒否されました（HTTP 403）。';

  @override
  String get ng_this_dashboard_has_no_chat_endpoint =>
      'このダッシュボードにはチャットエンドポイント（/api/ws）がありません。';

  @override
  String ng_the_chat_connection_failed(Object detail) {
    return 'チャット接続に失敗しました: $detail';
  }

  @override
  String get ng_use_the_exact_address_the_dashboard =>
      'ダッシュボードに設定されているアドレスを正確に入力してください。';

  @override
  String get ng_update_hermes => 'Hermes を更新してください。';

  @override
  String get ng_make_sure_the_proxy_allows_websocket =>
      'プロキシで /api/ws の WebSocket アップグレードが許可されていることを確認してください。';

  @override
  String get ng_offline => 'オフライン';

  @override
  String get ng_connecting => '接続中…';

  @override
  String get ng_connected => '接続済み';

  @override
  String get ng_reconnecting => '再接続中…';

  @override
  String get ng_signed_out => 'サインアウトしました';

  @override
  String get ng_connection_failed => '接続に失敗しました';

  @override
  String get ng_rate_limited_by_gateway => 'ゲートウェイによるレート制限中';

  @override
  String ng_couldn_t_open_the_chat_connection(Object message) {
    return 'チャットに接続できませんでした: $message';
  }

  @override
  String get ng_the_gateway_returned_no_websocket_ticket =>
      'ゲートウェイからWebSocketチケットが返されませんでした。';

  @override
  String get ng_connection_lost => '接続が切断されました';

  @override
  String get ng_this_dashboard_has_no_chat_endpoint_2 =>
      'このダッシュボードにはチャットエンドポイント（/api/ws）がありません。Hermesを更新してください。';

  @override
  String get ng_the_gateway_refused_the_chat_connection_2 =>
      'ゲートウェイがチャット接続を拒否しました。アドレスがダッシュボードに設定されたホストと一致していること、埋め込みチャットが有効になっていることを確認してください。';

  @override
  String ng_the_gateway_refused(Object method) {
    return 'ゲートウェイが$methodを拒否しました。';
  }

  @override
  String ng_couldn_t_read_your_saved_gateways(Object error) {
    return '保存済みのゲートウェイを読み込めませんでした: $error';
  }

  @override
  String get ng_applies_to_new_chats => '新しいチャットに適用';

  @override
  String ng_couldn_t_change(Object label, Object error) {
    return '$labelを変更できませんでした: $error';
  }

  @override
  String get ng_capabilities => '機能';

  @override
  String get ng_skills => 'スキル';

  @override
  String get ng_toolsets => 'ツールセット';

  @override
  String get ng_search => '検索';

  @override
  String get ng_couldn_t_load => '読み込めませんでした';

  @override
  String get ng_try_again => '再試行';

  @override
  String get ng_no_skills => 'スキルはありません';

  @override
  String get ng_no_toolsets => 'ツールセットはありません';

  @override
  String get ng_no_mcp_servers => 'MCPサーバーはありません';

  @override
  String get ng_that_file_is_too_large_to => '証明書として扱うにはファイルが大きすぎます。';

  @override
  String ng_the_certificate_couldn_t_be_imported(Object error) {
    return '証明書をインポートできませんでした: $error';
  }

  @override
  String get ng_now_pick_its_private_key => '次に秘密鍵を選択してください。';

  @override
  String get ng_now_pick_its_certificate => '次に証明書を選択してください。';

  @override
  String get ng_that_file_isn_t_a_certificate => 'このファイルは証明書でも秘密鍵でもありません。';

  @override
  String get ng_if_a_proxy_in_front_of =>
      'このアドレスの前段にあるプロキシがクライアント証明書を要求する場合は、ここで選択してください。接続テスト、サインイン、チャットで証明書が提示されます。';

  @override
  String get ng_client_certificates_are_only_used_with =>
      'クライアント証明書はhttps://アドレスでのみ使用できます。';

  @override
  String get ng_remove => '削除';

  @override
  String get ng_certificate_password => '証明書のパスワード';

  @override
  String get ng_importing => 'インポート中…';

  @override
  String get ng_pick_certificate => '証明書を選択';

  @override
  String get ng_pick_a_different_certificate => '別の証明書を選択';

  @override
  String get ng_accepts_p12_pfx_or_pem_certificate =>
      '.p12/.pfx、またはPEM形式の証明書と鍵に対応しています。鍵はこのアプリのプライベートストレージに保存されます。';

  @override
  String get ng_photos => '写真';

  @override
  String get ng_camera => 'カメラ';

  @override
  String get ng_files => 'ファイル';

  @override
  String ng_you_can_attach_up_to_files(Object count) {
    return '添付できるファイルは最大$count件です。';
  }

  @override
  String ng_couldn_t_read(Object name) {
    return '$nameを読み込めませんでした。';
  }

  @override
  String ng_couldn_t_prepare_that_file(Object error) {
    return 'ファイルを準備できませんでした: $error';
  }

  @override
  String get ng_hermes_is_still_working => 'Hermesはまだ処理中です';

  @override
  String get ng_steer => '途中で指示';

  @override
  String get ng_adds_this_to_the_running_turn => '実行中のターンの次のステップに追加します';

  @override
  String get ng_queue => 'キューに追加';

  @override
  String get ng_sends_it_when_the_turn_finishes => 'ターンの終了後に送信します';

  @override
  String get ng_stop_and_send => '停止して送信';

  @override
  String get ng_stops_the_turn_then_sends_this => 'ターンを停止してから送信します';

  @override
  String ng_dictation_stopped(Object message) {
    return '音声入力を停止しました: $message';
  }

  @override
  String get ng_speech_recognition_isn_t_available => '音声認識を利用できません。';

  @override
  String get ng_working => '処理中';

  @override
  String get ng_ready => '準備完了';

  @override
  String get ng_chats => 'チャット';

  @override
  String get ng_new_chat => '新しいチャット';

  @override
  String get ng_usage => '使用状況';

  @override
  String get ng_rename_chat => 'チャット名を変更';

  @override
  String ng_couldn_t_rename(Object error) {
    return '名前を変更できませんでした: $error';
  }

  @override
  String get ng_this_chat => 'このチャット';

  @override
  String get ng_input_tokens => '入力トークン';

  @override
  String get ng_output_tokens => '出力トークン';

  @override
  String get ng_reasoning_tokens => '推論トークン';

  @override
  String get ng_cache_reads => 'キャッシュ読み取り';

  @override
  String get ng_api_calls => 'API呼び出し';

  @override
  String get ng_cost => 'コスト';

  @override
  String get ng_context => 'コンテキスト';

  @override
  String get ng_your_sign_in_expired => 'サインインの有効期限が切れました。';

  @override
  String get ng_sign_in_2 => 'サインイン';

  @override
  String get ng_retry => '再試行';

  @override
  String get ng_project_home => 'ホーム';

  @override
  String get ng_choose_project => 'プロジェクトを選択';

  @override
  String ng_project_cwd_fallback(String path) {
    return 'プロジェクトフォルダーを利用できなかったため、このチャットは $path で実行されます。';
  }

  @override
  String get ng_project_create_uncertain =>
      'ゲートウェイがチャットを作成した可能性がありますが、確認できませんでした。別のチャットを開始する前にチャット一覧を確認してください。このリクエストは自動的に再試行されません。';

  @override
  String get ng_what_should_we_work_on => '何に取り組みますか？';

  @override
  String get ng_ask_hermes_anything_it_can_run =>
      'Hermesに何でも聞いてください。ツールの実行やウェブの閲覧、サーバー上のファイル操作ができます。';

  @override
  String ng_working_2(Object frame) {
    return '作業中 · $frame';
  }

  @override
  String get ng_default_model => '既定のモデル';

  @override
  String get ng_listening => '聞き取り中…';

  @override
  String get ng_steer_or_queue_a_message => 'メッセージを割り込ませるか、順番待ちに追加';

  @override
  String get ng_message_hermes => 'Hermesにメッセージ';

  @override
  String get ng_attach => '添付';

  @override
  String get ng_stop_dictation => '音声入力を停止';

  @override
  String get ng_dictate => '音声入力';

  @override
  String get ng_stop => '停止';

  @override
  String get ng_send => '送信';

  @override
  String ng_slash_command_alias(String alias, String command) {
    return '$alias は $command の別名です';
  }

  @override
  String get ng_slash_command_no_description => '説明はありません。';

  @override
  String get ng_slash_command_arguments_options => '決められた選択肢から1つを指定します。';

  @override
  String get ng_slash_command_arguments_text => 'コマンドの後にテキストを指定します。';

  @override
  String get ng_slash_command_arguments_mixed => 'コマンドの後に選択肢またはテキストを指定します。';

  @override
  String get ng_slash_command_sent_as_message =>
      'NextGen ではこれは通常のメッセージとして Hermes に送信され、コマンド自体は実行されません。';

  @override
  String get ng_slash_command_output => 'コマンドの出力';

  @override
  String get ng_slash_command_running => 'コマンドを実行中…';

  @override
  String get ng_slash_command_done => '完了しました。';

  @override
  String ng_slash_command_failed(Object error) {
    return 'コマンドを実行できませんでした: $error';
  }

  @override
  String get ng_slash_command_refused => 'Hermes はここでこのコマンドを実行できません。';

  @override
  String get ng_slash_command_delivery_unknown =>
      'コマンドは送信されましたが、応答がありませんでした。ゲートウェイでまだ実行中の可能性があるため、再送信せず下書きを残しました。';

  @override
  String get ng_slash_command_nothing_running => '実行中のものはありません。';

  @override
  String get ng_steered => '指示を反映しました';

  @override
  String get ng_copied => 'コピーしました';

  @override
  String ng_not_sent(Object reason) {
    return '送信できませんでした: $reason';
  }

  @override
  String get ng_thinking => '考え中…';

  @override
  String get ng_thought => '思考';

  @override
  String ng_used(Object name) {
    return '$nameを使用';
  }

  @override
  String ng_used_tools(Object count) {
    return '$count個のツールを使用';
  }

  @override
  String get ng_copy => 'コピー';

  @override
  String get ng_read_aloud => '読み上げ';

  @override
  String get ng_the_gateway_connection_dropped_try_again =>
      'ゲートウェイとの接続が切れました。もう一度お試しください。';

  @override
  String get ng_allow_once => '今回のみ許可';

  @override
  String get ng_allow_until_sandbox_off => 'サンドボックスがオフになるまで';

  @override
  String get ng_folder_access => 'フォルダーへのアクセス';

  @override
  String get ng_folder_access_unspecified => '読み取り専用か読み書き可能かがゲートウェイから示されていません。';

  @override
  String get ng_folder_read_only => '読み取り専用';

  @override
  String get ng_folder_read_write => '読み書き';

  @override
  String get ng_website_access => 'ウェブサイトへのアクセス';

  @override
  String get ng_allow_for_this_chat => 'このチャットで許可';

  @override
  String get ng_always_allow => '常に許可';

  @override
  String get ng_deny => '拒否';

  @override
  String get ng_your_answer => 'あなたの回答';

  @override
  String get ng_or_type_an_answer => 'または回答を入力';

  @override
  String get ng_skip => 'スキップ';

  @override
  String get ng_answer => '回答';

  @override
  String get ng_cancel => 'キャンセル';

  @override
  String get ng_username_or_email => 'ユーザー名またはメールアドレス';

  @override
  String get ng_password => 'パスワード';

  @override
  String get ng_not_now => '今はしない';

  @override
  String get ng_save => '保存';

  @override
  String get ng_enter_both_the_client_id_and =>
      'クライアントIDとクライアントシークレットの両方を入力するか、どちらも入力しないでください。';

  @override
  String get ng_enter_your_username_and_password => 'ユーザー名とパスワードを入力してください。';

  @override
  String ng_couldn_t_save_the_sign_in(Object error) {
    return 'サインインを保存できませんでした: $error';
  }

  @override
  String get ng_wrong_username_or_password => 'ユーザー名またはパスワードが正しくありません。';

  @override
  String get ng_too_many_attempts_wait_a_moment =>
      '試行回数が多すぎます。少し待ってからもう一度お試しください。';

  @override
  String get ng_welcome_to_hermes => 'Aresへようこそ';

  @override
  String get ng_add_a_gateway => 'ゲートウェイを追加';

  @override
  String get ng_connect_to_your_hermes_agent_dashboard =>
      'Hermes Agentダッシュボードに接続します。1つのアドレスとサインインで、チャット、ツール、設定にアクセスできます。サインインするまで何も送信されません。';

  @override
  String get ng_connect_to_another_hermes_agent_dashboard =>
      '別のHermes Agentダッシュボードに接続します。保存済みのダッシュボードにはサインインしたまま利用できます。';

  @override
  String get ng_dashboard_address => 'ダッシュボードのアドレス';

  @override
  String get ng_testing => 'テスト中…';

  @override
  String get ng_test => 'テスト';

  @override
  String get ng_where_your_hermes_dashboard_runs_lan =>
      'Hermesダッシュボードの接続先: LAN、Tailscale、またはHTTPS。';

  @override
  String get ng_find_on_my_network => 'ネットワーク上で検索';

  @override
  String get ng_which_address_do_i_use => 'どのアドレスを使えばよいですか？';

  @override
  String get ng_behind_cloudflare_access => 'Cloudflare Accessの背後にありますか？';

  @override
  String get ng_need_a_client_certificate => 'クライアント証明書が必要ですか？';

  @override
  String get ng_this_address_isn_t_private_and =>
      'このアドレスはプライベートではなく、https://も使用していません。パスワードやチャットが暗号化されずにインターネット経由で送信されます。https://、Tailscale、またはご自身のネットワークを使用してください。';

  @override
  String get ng_continue_to_sign_in => 'サインインに進む';

  @override
  String get ng_use_the_classic_interface_instead => '代わりに従来のインターフェースを使う';

  @override
  String get ng_if_cloudflare_access_protects_this_address =>
      'このアドレスがCloudflare Accessで保護されている場合は、Cloudflare Zero Trust（Access、Service credentials）でサービストークンを作成し、AccessアプリケーションにService Authポリシーを追加してください。';

  @override
  String get ng_a_service_token_is_saved_for => 'このアドレスのサービストークンは保存済みです';

  @override
  String get ng_forget => '削除';

  @override
  String get ng_client_id => 'クライアントID';

  @override
  String get ng_client_secret => 'クライアントシークレット';

  @override
  String get ng_stored_encrypted_on_this_phone_and =>
      'このスマートフォンに暗号化して保存され、このアドレスにのみ送信されます。';

  @override
  String get ng_hermes_is_reachable => 'Hermesに接続できます';

  @override
  String ng_hermes_is_reachable_2(Object version) {
    return 'Hermes $versionに接続できます';
  }

  @override
  String get ng_sign_in_is_tested_next_then => '次にサインインをテストし、その後チャットをテストします';

  @override
  String get ng_agent_gateway => 'エージェントゲートウェイ';

  @override
  String get ng_running => '実行中';

  @override
  String get ng_stopped => '停止中';

  @override
  String get ng_username_password => 'ユーザー名とパスワード';

  @override
  String get ng_browser => 'ブラウザー';

  @override
  String get ng_in_the_browser_sso => 'ブラウザーでサインイン（SSO）';

  @override
  String get ng_profiles => 'プロフィール';

  @override
  String get ng_this_dashboard_offers_neither_a_username =>
      'このダッシュボードでは、ユーザー名とパスワードによるサインインも、ブラウザーでのサインインも利用できません。Hermesを更新するか、サーバーでユーザー名とパスワードによる認証を設定してください。';

  @override
  String get ng_the_auth_gate_is_off_on =>
      'このダッシュボードでは認証が無効です。アクセスできる人は誰でもエージェントを利用できます。';

  @override
  String get ng_couldn_t_reach_the_dashboard => 'ダッシュボードに接続できませんでした';

  @override
  String ng_check_the_address_and_port_9119(Object reason) {
    return '$reason\n\nアドレスとポート（デフォルトは9119）を確認してください。ダッシュボードがまだ起動していない場合は、サーバーで次を実行してください:\nhermes dashboard --host 0.0.0.0';
  }

  @override
  String get ng_that_isn_t_a_hermes_dashboard => 'これはHermesのダッシュボードではありません';

  @override
  String get ng_something_answered_but_not_a_hermes_2 =>
      '応答はありましたが、Hermesのダッシュボードではありません。APIサーバー（ポート8642）ではなく、ダッシュボードのアドレスを使用してください。';

  @override
  String ng_something_answered_http_but_not_a_2(Object status) {
    return '応答はありました（HTTP $status）が、Hermesのダッシュボードではありません。APIサーバー（ポート8642）ではなく、ダッシュボードのアドレスを使用してください。';
  }

  @override
  String get ng_cloudflare_access_stopped_the_request =>
      'Cloudflare Accessがリクエストをブロックしました';

  @override
  String ng_cloudflare_access_turned_down_the_service(Object status) {
    return 'Cloudflare Accessがサービス認証トークンを拒否しました（HTTP $status）。クライアントIDとシークレット、Service Authポリシーを確認してください。';
  }

  @override
  String get ng_add_a_cloudflare_access_service_token_2 =>
      '以下にCloudflare Accessのサービス認証トークンを追加して、もう一度テストしてください。';

  @override
  String get ng_a_client_certificate_is_needed => 'クライアント証明書が必要です';

  @override
  String get ng_this_server_asks_for_a_client =>
      'このサーバーは接続前にクライアント証明書を求めています。下から発行された証明書を選び、もう一度テストしてください。';

  @override
  String get ng_this_dashboard_doesn_t_ask_for => 'このダッシュボードではサインインは不要です。';

  @override
  String ng_use_the_dashboard_username_and_password(Object address) {
    return '$addressで設定されているダッシュボードのユーザー名とパスワードを使うか、ブラウザーでサインインしてください。';
  }

  @override
  String ng_use_the_dashboard_username_and_password_2(Object address) {
    return '$addressで設定されているダッシュボードのユーザー名とパスワードを使ってください。';
  }

  @override
  String ng_sign_in_to_in_your_browser(Object address) {
    return 'ブラウザーで$addressにアクセスし、ダッシュボードで使うアカウントでサインインしてください。';
  }

  @override
  String ng_gateway(Object address) {
    return 'ゲートウェイ $address';
  }

  @override
  String get ng_profile => 'プロフィール';

  @override
  String get ng_server_default => 'サーバーのデフォルト';

  @override
  String get ng_continue => '続行';

  @override
  String get ng_username => 'ユーザー名';

  @override
  String get ng_signing_in => 'サインイン中…';

  @override
  String get ng_waiting_for_the_browser => 'ブラウザーを待っています…';

  @override
  String get ng_sign_in_with_browser => 'ブラウザーでサインイン';

  @override
  String get ng_finish_signing_in_on_the_page =>
      '開いたページでサインインを完了してください。完了するとHermesに自動で戻ります。';

  @override
  String get ng_use_a_different_gateway => '別のゲートウェイを使う';

  @override
  String get ng_same_wi_fi_or_local_network => '同じWi-Fiまたはローカルネットワーク';

  @override
  String get ng_use_the_server_s_local_address =>
      'サーバーのローカルアドレスとポートを使ってください（例: 192.168.1.20:9119）。ほかのデバイスから接続できるよう、--host 0.0.0.0 を指定してダッシュボードを起動してください。';

  @override
  String get ng_tailscale => 'Tailscale';

  @override
  String get ng_turn_on_tailscale_on_this_phone =>
      'このスマートフォンでTailscaleを有効にし、サーバーのTailscaleアドレス（例: 100.64.0.1:9119または.ts.net名）を使ってください。外出先からも接続できます。';

  @override
  String get ng_use_your_https_address_when_the =>
      '証明書付きのプロキシ経由でダッシュボードに接続する場合は、https://から始まるアドレスを使ってください。プロキシでは/api/wsへのWebSocketアップグレードも許可する必要があります。';

  @override
  String get ng_start_the_dashboard_on_the_server => 'サーバーでダッシュボードを起動:';

  @override
  String get ng_enter_a_port_from_1_to => '1〜65535のポート番号を入力してください。';

  @override
  String get ng_looks_for_hermes_dashboards_on_port =>
      'このWi-Fiネットワーク上でポート9119のHermesダッシュボードを探し、保存済みのコンピューターも確認します。';

  @override
  String ng_looks_for_hermes_dashboards_on_ports(Object port) {
    return 'このWi-Fiネットワーク上でポート9119と$portのHermesダッシュボードを探し、保存済みのコンピューターも確認します。';
  }

  @override
  String get ng_other_port_optional => '別のポート（任意）';

  @override
  String get ng_no_dashboards_answered_start_one_with =>
      'ダッシュボードから応答がありませんでした。hermes dashboard --host 0.0.0.0 で起動するか、アドレスを入力してください。';

  @override
  String get ng_using_tailscale_or_a_vpn_those =>
      'TailscaleまたはVPNを使用していますか？これらのネットワークは検索できません。コンピューターの100.xアドレスまたは.ts.net名を入力してください。';

  @override
  String get ng_search_again => 'もう一度検索';

  @override
  String get ng_insights => 'インサイト';

  @override
  String get ng_couldn_t_load_insights => 'インサイトを読み込めませんでした';

  @override
  String get ng_sessions => 'セッション';

  @override
  String get ng_tokens => 'トークン';

  @override
  String get ng_est_cost => '推定コスト';

  @override
  String get ng_daily_tokens => '1日のトークン数';

  @override
  String get ng_models => 'モデル';

  @override
  String get ng_tools => 'ツール';

  @override
  String get ng_hermes_is_waiting_for_you => 'Hermesが待っています。';

  @override
  String get ng_hermes_replied => 'Hermesから返信がありました';

  @override
  String get ng_the_turn_finished => '応答が完了しました。';

  @override
  String get ng_off => 'オフ';

  @override
  String get ng_minimal => '最小';

  @override
  String get ng_low => '低';

  @override
  String get ng_medium => '中';

  @override
  String get ng_high => '高';

  @override
  String get ng_extra_high => '非常に高い';

  @override
  String get ng_max => '最大';

  @override
  String get ng_ultra => 'ウルトラ';

  @override
  String get ng_default => 'デフォルト';

  @override
  String ng_couldn_t_switch_model(Object error) {
    return 'モデルを切り替えられませんでした: $error';
  }

  @override
  String get ng_model => 'モデル';

  @override
  String get ng_thinking_2 => '思考';

  @override
  String get ng_search_models => 'モデルを検索';

  @override
  String get ng_no_models_match => 'これらのフィルターに一致するモデルはありません。';

  @override
  String get privacy_policy => 'プライバシーポリシー';

  @override
  String get report_ai_output => 'AIの回答を報告';

  @override
  String ng_couldn_t_load_models(Object error) {
    return 'モデルを読み込めませんでした: $error';
  }

  @override
  String get ng_no_providers_are_set_up_on => 'このゲートウェイには、まだプロバイダーが設定されていません。';

  @override
  String get ng_starred => 'スター付き';

  @override
  String get ng_recent => '最近';

  @override
  String get ng_more => 'もっと見る';

  @override
  String get ng_archived_chats => 'アーカイブ済みのチャット';

  @override
  String get ng_projects => 'プロジェクト';

  @override
  String get ng_chats_grouped_by_project_and_workspace =>
      'プロジェクトとワークスペース別のチャット';

  @override
  String get ng_agent => 'エージェント';

  @override
  String get ng_memory => 'メモリ';

  @override
  String get ng_what_hermes_remembers_about_you => 'Hermesがあなたについて記憶していること';

  @override
  String get ng_skills_library => 'スキルライブラリ';

  @override
  String get ng_browse_and_read_installed_skills => 'インストール済みのスキルを閲覧・確認';

  @override
  String get ng_cron_editor => 'cronエディター';

  @override
  String get ng_edit_schedules_prompts_and_delivery => 'スケジュール、プロンプト、配信先を編集';

  @override
  String get ng_config_file => '設定ファイル';

  @override
  String get ng_edit_config_yaml_on_the_gateway => 'ゲートウェイ上のconfig.yamlを編集';

  @override
  String get ng_models_and_providers => 'モデルとプロバイダー';

  @override
  String get ng_model_management => 'モデル管理';

  @override
  String get ng_default_fallback_and_auxiliary_models => 'デフォルト、フォールバック、補助モデル';

  @override
  String get ng_provider_sign_in => 'プロバイダーにサインイン';

  @override
  String get ng_connect_provider_accounts_with_oauth => 'OAuthでプロバイダーアカウントを接続';

  @override
  String get ng_nous_portal => 'Nous Portal';

  @override
  String get ng_subscription_credits_and_usage => 'サブスクリプション、クレジット、利用状況';

  @override
  String get ng_interface => 'インターフェース';

  @override
  String get ng_switch_to_the_classic_interface => 'クラシックなインターフェースに切り替え';

  @override
  String get ng_turns_nextgen_off_you_can_turn =>
      'NextGenをオフにします。設定から再びオンにできます。';

  @override
  String get ng_restored => '復元しました';

  @override
  String get ng_archived => 'アーカイブしました';

  @override
  String get ng_couldn_t_load_archived_chats => 'アーカイブ済みのチャットを読み込めませんでした';

  @override
  String get ng_nothing_archived => 'アーカイブはありません';

  @override
  String get ng_restore => '復元';

  @override
  String get ng_saved_new_chats_use_it => '保存しました。新しいチャットに適用されます。';

  @override
  String ng_couldn_t_save(Object error) {
    return '保存できませんでした: $error';
  }

  @override
  String get ng_saving => '保存中…';

  @override
  String ng_today(Object time) {
    return '今日 $time';
  }

  @override
  String get ng_mon => '月';

  @override
  String get ng_tue => '火';

  @override
  String get ng_wed => '水';

  @override
  String get ng_thu => '木';

  @override
  String get ng_fri => '金';

  @override
  String get ng_sat => '土';

  @override
  String get ng_sun => '日';

  @override
  String get ng_scheduled => 'スケジュール済み';

  @override
  String get ng_new_job => '新しいジョブ';

  @override
  String get ng_couldn_t_load_scheduled_jobs => 'スケジュール済みのジョブを読み込めませんでした';

  @override
  String get ng_nothing_scheduled => 'スケジュールはありません';

  @override
  String get ng_ask_hermes_to_do_something_on =>
      'Hermesに定期的なタスクを頼むか、ここでジョブを追加できます。';

  @override
  String get ng_active => '有効';

  @override
  String get ng_paused => '一時停止中';

  @override
  String ng_next(Object when) {
    return '次回 $when';
  }

  @override
  String ng_last(Object when) {
    return '前回 $when';
  }

  @override
  String ng_last_2(Object when, Object result) {
    return '前回 $when · $result';
  }

  @override
  String ng_job(Object id) {
    return 'ジョブ $id';
  }

  @override
  String get ng_delete => '削除';

  @override
  String get ng_delete_this_job => 'このジョブを削除しますか？';

  @override
  String get ng_it_stops_running_past_runs_stay =>
      'ジョブは停止します。過去の実行履歴はチャットに残ります。';

  @override
  String ng_next_run(Object when) {
    return '次回の実行 $when';
  }

  @override
  String ng_delivers_to(Object target) {
    return '配信先: $target';
  }

  @override
  String get ng_run_now => '今すぐ実行';

  @override
  String get ng_started => '開始しました';

  @override
  String get ng_pause => '一時停止';

  @override
  String get ng_resume => '再開';

  @override
  String get ng_resumed => '再開しました';

  @override
  String get ng_prompt => 'プロンプト';

  @override
  String get ng_runs => '実行履歴';

  @override
  String get ng_no_runs_yet => 'まだ実行履歴はありません。';

  @override
  String get ng_enter_a_schedule_and_a_prompt => 'スケジュールとプロンプトを入力してください。';

  @override
  String get ng_name_optional => '名前（任意）';

  @override
  String get ng_schedule => 'スケジュール';

  @override
  String get ng_every_1h_0_9_or_30m => 'every 1h, 0 9 * * *, or 30m';

  @override
  String get ng_create => '作成';

  @override
  String get ng_unpin => 'ピン留めを解除';

  @override
  String get ng_pin => 'ピン留め';

  @override
  String get ng_rename => '名前を変更';

  @override
  String get ng_archive => 'アーカイブ';

  @override
  String get ng_delete_this_chat => 'このチャットを削除しますか？';

  @override
  String get ng_it_is_removed_from_the_gateway => 'すべてのデバイスでゲートウェイから削除されます。';

  @override
  String get ng_search_chats => 'チャットを検索';

  @override
  String get ng_pinned => 'ピン留め済み';

  @override
  String get ng_no_chats_match => '一致するチャットはありません。';

  @override
  String get ng_no_chats_yet => 'チャットはまだありません。';

  @override
  String get ng_nothing_is_running => '実行中のものはありません。';

  @override
  String get ng_nothing_is_waiting_on_you => '対応が必要なものはありません。';

  @override
  String get ng_settings => '設定';

  @override
  String get ng_all => 'すべて';

  @override
  String ng_needs_you(Object count) {
    return '対応が必要 · $count';
  }

  @override
  String get ng_needs_you_2 => '対応が必要';

  @override
  String get ng_gateways => 'ゲートウェイ';

  @override
  String ng_classic_connection(Object address) {
    return '$address · クラシック接続';
  }

  @override
  String get ng_gateway_2 => 'ゲートウェイ';

  @override
  String get ng_signed_in => 'サインイン済み';

  @override
  String get ng_classic_connection_2 => 'クラシック接続';

  @override
  String get ng_in_the_browser => 'ブラウザー内';

  @override
  String ng_in_the_browser_as(Object name) {
    return 'ブラウザー内（$nameとして）';
  }

  @override
  String get ng_not_required => '不要';

  @override
  String get ng_test_connection => '接続をテスト';

  @override
  String get ng_sign_in_again_2 => '再度サインイン';

  @override
  String get ng_sign_out => 'サインアウト';

  @override
  String get ng_saved_gateways => '保存済みのゲートウェイ';

  @override
  String get ng_in_use => '使用中';

  @override
  String get ng_appearance => '外観';

  @override
  String get ng_theme => 'テーマ';

  @override
  String get ng_system => 'システム';

  @override
  String get ng_light => 'ライト';

  @override
  String get ng_dark => 'ダーク';

  @override
  String get ng_accent => 'アクセント';

  @override
  String get ng_pure_black => 'ピュアブラック';

  @override
  String get ng_dark_theme_uses_true_black_oled => 'ダークテーマでは真の黒（OLED）を使用します';

  @override
  String get ng_glow => 'グロー';

  @override
  String get ng_soft_accent_light_behind_each_screen =>
      '各画面の背後にアクセントカラーの柔らかな光を表示します';

  @override
  String get ng_the_new_interface_turn_off_to =>
      '新しいインターフェースです。オフにするとクラシック版に戻ります。ゲートウェイとチャットは両方で共有されます。';

  @override
  String get ng_more_settings => 'その他の設定';

  @override
  String get ng_voice_notifications_language_backups_and_the =>
      '音声、通知、言語、バックアップ、ゲートウェイの設定';

  @override
  String get ng_licences => 'ライセンス';

  @override
  String ng_sign_out_of(Object name) {
    return '$nameからサインアウトしますか？';
  }

  @override
  String get ng_this_gateway_and_its_saved_sign =>
      'このゲートウェイと保存済みのサインイン情報は、両方のインターフェースでこのスマートフォンから削除されます。チャットはゲートウェイに残ります。';

  @override
  String get ng_password_or_browser => 'パスワードまたはブラウザー';

  @override
  String get ng_unsupported => '未対応';

  @override
  String get ng_background_task_finished => 'バックグラウンドタスク完了';

  @override
  String get ng_background_process_finished => 'バックグラウンドプロセス完了';

  @override
  String get ng_system_message => 'システムメッセージ';

  @override
  String get ng_summary => '要約';

  @override
  String get classic_interface_only => 'クラシック インターフェースのみ';

  @override
  String get classic_only_settings_hint =>
      '「クラシック インターフェースのみ」と表示されたセクションの設定は、クラシック版の外観とチャットにのみ適用され、NextGen には適用されません。NextGen には、設定内に独自の外観オプションがあります。';

  @override
  String get attachment_preview_too_large =>
      'ここではプレビューできるサイズを超えています。保存または共有すると、スマートフォンにダウンロードされます（最大1 GB）。';

  @override
  String get attachment_over_phone_limit =>
      'このファイルは1 GBを超えているため、ダウンロードできません。ダッシュボードからダウンロードしてください。';

  @override
  String attachment_downloading_percent(int percent) {
    return 'ダウンロード中… $percent%';
  }

  @override
  String attachment_downloading_mb(int megabytes) {
    return 'ダウンロード中… $megabytes MB';
  }

  @override
  String ng_attachment_too_large_for_gateway(String name) {
    return '$name は12 MBを超えているため、このゲートウェイでは送信できません。Hermesを更新すると、最大100 MBのファイルを送信できます。';
  }

  @override
  String ng_couldn_t_upload(String name) {
    return '$name をアップロードできませんでした。';
  }

  @override
  String ng_uploading_percent(int percent) {
    return 'アップロード中… $percent%';
  }

  @override
  String get ng_show_tasks => 'タスクを表示';

  @override
  String get ng_hide_tasks => 'タスクを非表示';

  @override
  String get ng_goal => '目標';

  @override
  String get ng_loop => 'ループ';

  @override
  String get ng_heartbeat => 'ハートビート';

  @override
  String get ng_goal_working => '進行中';

  @override
  String get ng_goal_waiting => '待機中';

  @override
  String get ng_goal_blocked => 'ブロック中';

  @override
  String get ng_goal_done => '完了';

  @override
  String ng_goal_turns_of(int used, int max) {
    return '$used/$maxターン';
  }

  @override
  String ng_goal_turn(int used) {
    return 'ターン$used';
  }

  @override
  String get ng_loop_held => '目標のため保留中';

  @override
  String get ng_loop_finished => '終了';

  @override
  String get ng_loop_running => '実行中';

  @override
  String ng_loop_runs_of(int fired, int times) {
    return '$fired/$times回実行';
  }

  @override
  String ng_loop_runs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count回の実行',
    );
    return '$_temp0';
  }

  @override
  String ng_loop_next(String time) {
    return '次回 $time';
  }

  @override
  String get ng_loop_due_now => '今すぐ実行';

  @override
  String ng_every_seconds(int seconds) {
    return '$seconds秒ごと';
  }

  @override
  String ng_every_minutes(int minutes) {
    return '$minutes分ごと';
  }

  @override
  String ng_every_hours(int hours) {
    return '$hours時間ごと';
  }

  @override
  String ng_every_hours_minutes(int hours, int minutes) {
    return '$hours時間$minutes分ごと';
  }

  @override
  String ng_heartbeat_fired(int count) {
    return '$count回実行';
  }

  @override
  String ng_heartbeat_last_fired(String time) {
    return '最終実行：$time';
  }

  @override
  String ng_wait_until(String time) {
    return '$timeまで待機中';
  }

  @override
  String get ng_wait_resume => '再開待ち';

  @override
  String get ng_wait_other_chat => '別のチャットの処理待ち';

  @override
  String ng_wait_process(String pid) {
    return 'プロセス $pid の処理待ち';
  }

  @override
  String get ng_control_open => '目標と自動化を開く';

  @override
  String get ng_control_title => '目標と自動化';

  @override
  String get ng_control_subtitle => 'このチャットの目標と、自動で実行される処理。';

  @override
  String get ng_contract_outcome => '成果';

  @override
  String get ng_contract_verification => '検証方法';

  @override
  String get ng_contract_constraints => '制約';

  @override
  String get ng_contract_boundaries => '境界';

  @override
  String get ng_contract_stop_when => '停止条件';

  @override
  String get ng_subgoals => 'サブ目標';

  @override
  String get ng_subgoal_add_placeholder => 'サブ目標を追加';

  @override
  String get ng_add => '追加';

  @override
  String get ng_subgoal_remove => 'サブ目標を削除';

  @override
  String get ng_goal_checks => 'チェック項目';

  @override
  String get ng_gate_not_run => '未実行';

  @override
  String ng_gate_attempts(int attempts, int tries) {
    return '$attempts/$tries回試行';
  }

  @override
  String ng_gate_exit(int code) {
    return '終了コード $code';
  }

  @override
  String get ng_resume_now => '今すぐ再開';

  @override
  String get ng_goal_clear => '目標をクリア';

  @override
  String get ng_goal_clear_title => 'この目標をクリアしますか？';

  @override
  String get ng_goal_clear_message =>
      'エージェントはこの目標に向けた作業を停止します。サブ目標とチェック項目も削除されます。';

  @override
  String get ng_subgoal_remove_title => 'このサブ目標を削除しますか？';

  @override
  String ng_subgoal_remove_message(String text) {
    return '「$text」は目標に含まれなくなります。';
  }

  @override
  String get ng_subgoals_clear_title => 'すべてのサブ目標をクリアしますか？';

  @override
  String get ng_subgoals_clear_message => '目標のタイトルは残りますが、サブ目標はすべて削除されます。';

  @override
  String get ng_clear_all => 'すべてクリア';

  @override
  String get ng_clear => 'クリア';

  @override
  String get ng_dismiss => '閉じる';

  @override
  String get ng_loop_stop_title => 'このループを停止しますか？';

  @override
  String get ng_heartbeat_clear_title => 'このハートビートをクリアしますか？';

  @override
  String get ng_wont_fire_again => '今後は実行されません。';

  @override
  String get ng_loop_self_paced => '自動ペース';

  @override
  String ng_loop_until(String condition) {
    return '終了条件：$condition';
  }

  @override
  String get ng_loop_waits_for_goal => '目標の作業中は待機します。';

  @override
  String get ng_loop_awaiting_reply => 'エージェントの返信待ちです。';

  @override
  String ng_loop_stopped_reason(String reason) {
    return '停止理由：$reason';
  }

  @override
  String get ng_hide_subagents => 'サブエージェントを隠す';

  @override
  String get ng_show_subagents => 'サブエージェントを表示';

  @override
  String get ng_subagent => 'サブエージェント';

  @override
  String get ng_subagent_queued => '待機中';

  @override
  String get ng_subagent_starting => '開始中…';

  @override
  String get ng_subagent_running => '実行中';

  @override
  String get ng_subagent_done => '完了';

  @override
  String get ng_subagent_failed => '失敗';

  @override
  String get ng_subagent_stopped => '停止';

  @override
  String get ng_subagent_stop => 'サブエージェントを停止';

  @override
  String ng_subagent_tools(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個のツール',
    );
    return '$_temp0';
  }

  @override
  String get ng_mark_as_read => '既読にする';

  @override
  String get ng_mark_as_unread => '未読にする';

  @override
  String ng_chats_unread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '未読のチャット: $count件',
    );
    return '$_temp0';
  }

  @override
  String get ng_unread_finished => '完了、未読の返信あり';

  @override
  String get ng_unread_updates => '実行中、未読の更新あり';

  @override
  String get ng_notifications => '通知';

  @override
  String get ng_notifications_hint => 'Aresがバックグラウンドにある間の返信とリクエスト';

  @override
  String get ng_notify_replies => '返信';

  @override
  String get ng_notify_replies_hint => '開いているチャットで応答が完了または失敗したとき';

  @override
  String get ng_notify_requests => '承認と質問';

  @override
  String get ng_notify_requests_hint =>
      'エージェントがあなたの対応を待っているときに通知します。「今回のみ許可」と「拒否」を選べます';

  @override
  String get ng_keep_running => '返信の生成中も接続を維持';

  @override
  String get ng_keep_running_hint => '返信が完了するまでバックグラウンドで接続を維持し、目立たない通知を表示します';

  @override
  String get ng_battery_settings => 'バッテリー最適化';

  @override
  String get ng_battery_settings_hint => '通知が遅れず届くよう、Aresのバックグラウンド実行を許可します';

  @override
  String get ng_send_test_notification => 'テスト通知を送信';

  @override
  String get ng_test_notification_title => 'Aresの通知は正常に動作しています';

  @override
  String get ng_test_notification_body => '返信やリクエストはこのように表示されます。';

  @override
  String get ng_test_notification_sent => 'テスト通知を送信しました';

  @override
  String get ng_notifications_blocked =>
      '通知がブロックされています。Androidの設定で通知を許可してください。';

  @override
  String get ng_notifications_off_hint =>
      '通知がオフのため、Aresがバックグラウンドにある間は通知が表示されません。';

  @override
  String get ng_insights_building =>
      'レポートを作成しています。期間が長い場合、初回は最大1分ほどかかることがあります。';

  @override
  String get ng_insights_timed_out =>
      'レポートの作成に時間がかかりすぎています。もう一度お試しいただくか、期間を短くしてください。';

  @override
  String get ng_dock_goal_active => '目標（実行中）';

  @override
  String get ng_dock_goal_paused => '目標（一時停止）';

  @override
  String get ng_dock_goal_waiting => '目標（待機中）';

  @override
  String get ng_dock_goal_blocked => '目標（ブロック中）';

  @override
  String get ng_dock_goal_done => '目標（完了）';

  @override
  String ng_dock_turn_of(int used, int max) {
    return 'ターン $used/$max';
  }

  @override
  String ng_dock_turn(int used) {
    return 'ターン $used';
  }

  @override
  String ng_dock_subagents(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件のサブエージェント',
      one: '$count件のサブエージェント',
    );
    return '$_temp0';
  }

  @override
  String ng_dock_subagents_done(int count) {
    return '$count件完了';
  }

  @override
  String ng_dock_tasks(int done, int total) {
    return 'タスク $done/$total';
  }

  @override
  String ng_dock_previous_tasks(int done, int total) {
    return '前回のタスク $done/$total';
  }

  @override
  String get ng_dock_manage => '管理';

  @override
  String get ng_recent_notifications => '最近の通知';

  @override
  String get ng_recent_notifications_hint =>
      'Aresが投稿しようとした内容と、Androidに表示されたかどうか';

  @override
  String get ng_recent_notifications_empty =>
      'まだありません。返信、質問、または失敗によって通知が発生する場合、その試行がここに表示されます。';

  @override
  String get ng_notify_permission_granted => '通知の許可が付与されました';

  @override
  String get ng_notify_permission_denied => '通知が拒否されました';

  @override
  String get ng_notify_master_on => '通知オン';

  @override
  String get ng_notify_master_off => '通知オフ';

  @override
  String get ng_models_default => 'デフォルトモデル';

  @override
  String get ng_models_change => '変更';

  @override
  String get ng_models_custom_endpoint =>
      'カスタムエンドポイントを使用しています。ゲートウェイ側で変更してください。';

  @override
  String get ng_models_context_window => 'コンテキストウィンドウ';

  @override
  String ng_models_token_count(String count) {
    return '$count トークン';
  }

  @override
  String ng_models_context_override(String count) {
    return 'ゲートウェイで設定されています。自動検出: $count トークン。';
  }

  @override
  String get ng_models_max_output => '最大出力';

  @override
  String get ng_models_input_price => '入力料金';

  @override
  String get ng_models_output_price => '出力料金';

  @override
  String get ng_models_cache_price => 'キャッシュ済み入力の料金';

  @override
  String ng_models_per_million(String price) {
    return '100万トークンあたり $price';
  }

  @override
  String ng_models_price_pair(String input, String output) {
    return '100万トークンあたり 入力 $input · 出力 $output';
  }

  @override
  String get ng_models_free => '無料';

  @override
  String get ng_models_vision => '画像認識';

  @override
  String get ng_models_reasoning => '推論';

  @override
  String get ng_models_fast => '高速モード';

  @override
  String get ng_models_in_use => '使用中';

  @override
  String ng_models_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個のモデル',
    );
    return '$_temp0';
  }

  @override
  String get ng_models_rate_limited => 'レート制限中';

  @override
  String get ng_models_plan_locked => '現在のプランでは利用不可';

  @override
  String get ng_models_unsaved => '未保存の変更';

  @override
  String get ng_models_discard => '破棄';

  @override
  String get ng_models_aux_hint => '補助タスクは、個別にモデルを指定しない限りデフォルトモデルを使用します。';

  @override
  String get ng_models_uses_default => 'デフォルトモデルを使用';

  @override
  String get ng_models_thinking_level => '思考レベル';

  @override
  String get ng_models_providers => 'プロバイダー';

  @override
  String get ng_models_saved => '保存しました';

  @override
  String get ng_aux_vision => 'ビジョン';

  @override
  String get ng_aux_vision_hint => '画像やスクリーンショットを読み取ります';

  @override
  String get ng_aux_compression => '圧縮';

  @override
  String get ng_aux_compression_hint => '長いチャットをコンテキストウィンドウに収まるよう要約します';

  @override
  String get ng_aux_approval => '承認';

  @override
  String get ng_aux_approval_hint => 'コマンドを確認なしで安全に実行できるか判断します';

  @override
  String get ng_aux_mcp => 'MCP';

  @override
  String get ng_aux_mcp_hint => '使用する MCP ツールを選びます';

  @override
  String get ng_aux_title_generation => 'チャットタイトル';

  @override
  String get ng_aux_title_generation_hint => '新しいチャットに名前を付けます';

  @override
  String get ng_aux_review => 'レビュー';

  @override
  String get ng_aux_review_hint => '/review の実行時に作業内容を確認します';

  @override
  String get ng_aux_voice_chat => '音声チャット';

  @override
  String get ng_aux_voice_chat_hint => '音声モードで応答します';

  @override
  String get ng_aux_triage_specifier => 'トリアージ';

  @override
  String get ng_aux_triage_specifier_hint => '1行のカンバンカードを仕様に展開します';

  @override
  String get ng_aux_kanban_decomposer => 'カンバン分解';

  @override
  String get ng_aux_kanban_decomposer_hint => 'カンバンカードを小さなタスクに分割します';

  @override
  String get ng_aux_profile_describer => 'プロファイルの説明';

  @override
  String get ng_aux_profile_describer_hint => '各プロファイルの短い説明を作成します';

  @override
  String get ng_aux_curator => 'キュレーター';

  @override
  String get ng_aux_curator_hint => 'スキルの使われ方を確認します';

  @override
  String get appearance_save_failed => 'この変更を保存できませんでした。';

  @override
  String get appearance_keep_which_theme => 'どちらのテーマを残しますか？';

  @override
  String get appearance_tour_back => '戻る';

  @override
  String get appearance_tour_finish => '完了';

  @override
  String get appearance_tour_next => '次へ';

  @override
  String get appearance_tour_close => 'ツアーを閉じる';

  @override
  String get appearance_dismiss_tip => 'ヒントを閉じる';

  @override
  String get appearance_search_settings => '設定を検索';

  @override
  String get appearance_search_show => '表示';

  @override
  String get appearance_no_matching_setting => '一致する設定はありません。';

  @override
  String get appearance_replay_tour => 'ツアーをもう一度見る';

  @override
  String get appearance_show_tips_again => 'ヒントを再表示';

  @override
  String get appearance_window_translucency_unavailable =>
      'このホストではウィンドウの半透明表示を利用できません。Linuxは対応しておらず、AppleとWindowsのランナーは不透明なFlutterビューを描画します。';

  @override
  String get appearance_imported_themes => 'インポート済みのテーマ';

  @override
  String get appearance_import_theme_file => 'テーマファイルをインポート';

  @override
  String get appearance_remove_theme => 'テーマを削除';

  @override
  String get appearance_chat_font => 'チャットのフォント';

  @override
  String get appearance_terminal_font => 'ターミナルのフォント';

  @override
  String get appearance_font_platform => 'プラットフォーム';

  @override
  String get appearance_automatic => '自動';

  @override
  String get appearance_force_left_to_right => '左から右に固定';

  @override
  String get appearance_force_right_to_left => '右から左に固定';

  @override
  String get appearance_user_bubble_opacity => 'ユーザーの吹き出しの不透明度';

  @override
  String get appearance_inline_embeds => 'インライン埋め込み';

  @override
  String get appearance_inline_embeds_hint =>
      'リッチプレビューは外部サイト（YouTube、X など）から読み込まれます。「確認」はそれぞれ許可するまでプレースホルダーを表示し、「常に」は自動で読み込み、「オフ」は通常のリンクのままにします。';

  @override
  String get appearance_embeds_ask => '確認';

  @override
  String get appearance_embeds_always => '常に';

  @override
  String get appearance_embeds_off => 'オフ';

  @override
  String appearance_embeds_reset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '許可済みのサービス $count 件をリセット',
      one: '許可済みのサービス 1 件をリセット',
    );
    return '$_temp0';
  }

  @override
  String get appearance_embed_load => '読み込む';

  @override
  String appearance_embed_always_allow(String service) {
    return '$service を常に許可';
  }

  @override
  String get appearance_embed_loading => 'プレビューを読み込み中…';

  @override
  String appearance_embed_image_failed(String host) {
    return '$host から画像を読み込めませんでした。タップして開きます。';
  }

  @override
  String get appearance_embed_preview_unavailable => 'プレビューを表示できません';

  @override
  String get appearance_emoji_reactions => '絵文字リアクション';

  @override
  String get appearance_celebration_hearts => 'お祝いのハート';

  @override
  String get appearance_celebration_hearts_hint =>
      '離席中に応答が届くと、ハートのアニメーションを表示します。';

  @override
  String get appearance_pop_out_companion => 'コンパニオンを別ウィンドウに表示';

  @override
  String get appearance_mosskip => 'Mosskip';

  @override
  String get appearance_emberbun => 'Emberbun';

  @override
  String get appearance_tideling => 'Tideling';

  @override
  String get appearance_my_hatchling => '私のひな';

  @override
  String get appearance_at_rest => '休憩中';

  @override
  String get appearance_working => '作業中';

  @override
  String get appearance_thinking => '考え中';

  @override
  String get appearance_waiting_for_you => 'あなたを待っています';

  @override
  String get appearance_reply_ready => '応答の準備完了';

  @override
  String get appearance_turn_failed => 'ターンに失敗';

  @override
  String get appearance_small => '小';

  @override
  String get appearance_medium => '中';

  @override
  String get appearance_large => '大';

  @override
  String get appearance_hello => 'こんにちは！';

  @override
  String get appearance_unread_reply => '未読の応答';

  @override
  String get appearance_compose => '作成';

  @override
  String get appearance_say_hello => '挨拶する';

  @override
  String get appearance_pet_image_failed =>
      'その画像を開けませんでした。より小さいPNGまたはJPEGを選んでください。';

  @override
  String get appearance_pet_companion => 'ペットのコンパニオン';

  @override
  String get appearance_pet_companion_hint => 'チャット中にコンパニオンを表示します。';

  @override
  String get appearance_adopt_a_companion => 'コンパニオンを迎える';

  @override
  String get appearance_roam_when_idle => '待機中に歩き回る';

  @override
  String get appearance_pet_size => 'ペットのサイズ';

  @override
  String get appearance_hatch_from_a_local_picture => '端末内の画像から孵化させる';

  @override
  String get appearance_pet_image_limits =>
      'PNGまたはJPEG（最大4 MiB、各辺4096 px、8 MP）を選び、まずプレビューしてください。孵化させると24 × 24ピクセルの画像を1枚保存し、前のひなを置き換えます。';

  @override
  String get appearance_choose_picture => '画像を選択';

  @override
  String get appearance_hatchling_preview => 'ひなのプレビュー';

  @override
  String get appearance_hatch_and_adopt => '孵化させて迎える';

  @override
  String get appearance_discard_draft => '下書きを破棄';

  @override
  String get appearance_forget_saved_hatchling => '保存済みのひなを削除';

  @override
  String get appearance_radio => 'ラジオ';

  @override
  String appearance_radio_hint(String stations) {
    return 'ストリームは$stationsから直接配信され、再生を押したときにのみ開始します。放送局の検索はこの端末内で行います。';
  }

  @override
  String get appearance_radio_save_failed => 'ラジオの設定を保存できませんでした。';

  @override
  String get appearance_choose_a_station => '放送局を選択';

  @override
  String get appearance_pause_radio => 'ラジオを一時停止';

  @override
  String get appearance_play_radio => 'ラジオを再生';

  @override
  String get appearance_next_station => '次の放送局';

  @override
  String get appearance_radio_trace_semantics =>
      'ストリームの動作状況。音量レベルを取得できないため、この線は平らなままです。';

  @override
  String get appearance_radio_is_off => 'ラジオはオフです';

  @override
  String get appearance_paused => '一時停止中';

  @override
  String get appearance_connecting => '接続中…';

  @override
  String get appearance_live => 'ライブ';

  @override
  String get appearance_stream_unavailable => 'ストリームを利用できません';

  @override
  String appearance_now_playing(String credit) {
    return '再生中：$credit';
  }

  @override
  String get appearance_audio_only_waveform_unavailable => '音声のみ · 波形は利用できません';

  @override
  String get appearance_volume => '音量';

  @override
  String get appearance_search_presets => 'プリセットを検索';

  @override
  String get appearance_no_stations_found => '放送局が見つかりません';

  @override
  String appearance_unpin_station(String station) {
    return '放送局の固定を解除：$station';
  }

  @override
  String appearance_pin_station(String station) {
    return '放送局を固定：$station';
  }

  @override
  String get appearance_radio_picker_metadata_notice =>
      'この選択画面を開いている間、再生中の放送局から曲の情報が直接提供される場合があります。';

  @override
  String get appearance_message_from_your_companion => 'コンパニオンからのメッセージ';

  @override
  String get appearance_send_to_the_open_chat => '開いているチャットに送信';

  @override
  String get appearance_tour_theme_body =>
      'この端末のファイルからVS Codeのカラーテーマをインポートし、残すバリエーションを選びます。';

  @override
  String get appearance_tour_fonts_title => '表示フォント';

  @override
  String get appearance_tour_fonts_body =>
      'チャットの文章とターミナルのコードには、Aresに同梱された別々の書体を使用します。';

  @override
  String get appearance_tour_direction_title => '会話記録の表示方向';

  @override
  String get appearance_tour_direction_body =>
      '自動のままにするか、会話記録を左から右または右から左に固定します。';

  @override
  String get appearance_tour_pet_title => 'コンパニオン';

  @override
  String get appearance_tour_pet_body =>
      'コンパニオンは迎えるまでオフのままです。別ウィンドウ表示には小さな入力欄が付きます。';

  @override
  String get appearance_tour_radio_body =>
      'ラジオは有効にするまでオフのままです。再生を押すとストリームを開きます。';

  @override
  String get appearance_tip_theme =>
      '選択を解除するまで、インポートしたテーマが組み込みのパレットに代わって使用されます。保持されるのは色のみです。';

  @override
  String get appearance_tip_pet =>
      'コンパニオンは小さな画像を1枚この端末に保存します。孵化に使用した画像はアップロードしません。';

  @override
  String get appearance_theme_import_failed =>
      'そのテーマをインポートできませんでした。.vsix、.json、.jsonc形式で保存されたVS Codeのカラーテーマを選んでください。';

  @override
  String get render_widget_file_truncated =>
      'このファイルは先頭部分しか読み込まれていないため、ウィジェットが不完全な可能性があります。';

  @override
  String get setup_beat_title => 'セットアップ';

  @override
  String setup_beat_use_name(String name) {
    return '$name を使う';
  }

  @override
  String get setup_beat_name_hint => 'Hermes はあなたを何と呼べばよいですか？';

  @override
  String get setup_beat_on_computer =>
      'この手順は Hermes が動作しているコンピューターで行います。「続ける」を選ぶと、そこでの設定がそのまま使われます。';

  @override
  String get setup_beat_not_waiting => 'このセットアップカードはもう回答を待っていません。';

  @override
  String get catalog_kind_plugin => 'プラグイン';

  @override
  String get catalog_kind_skill => 'スキル';

  @override
  String get catalog_tier_official => '公式';

  @override
  String get catalog_tier_verified => '検証済み';

  @override
  String get catalog_tier_community => 'コミュニティ';

  @override
  String get catalog_install => 'インストール';

  @override
  String get catalog_waiting => '選択を待っています';

  @override
  String get catalog_installed => 'インストール済み';

  @override
  String get catalog_installed_off => 'インストール済み（未有効化）';

  @override
  String get catalog_skipped => 'スキップしました';

  @override
  String get catalog_not_installed => 'インストールされていません';

  @override
  String catalog_target_profile(String profile) {
    return '$profile プロファイルにインストールされます';
  }

  @override
  String catalog_source(String repo, String sha) {
    return '$repo（$sha）';
  }

  @override
  String catalog_scan(String status, String summary) {
    return 'セキュリティスキャン: $status。$summary';
  }

  @override
  String catalog_requires_hermes(String range) {
    return 'Hermes $range が必要です';
  }

  @override
  String catalog_skill_ready(String name) {
    return 'スキル $name を使用できます';
  }

  @override
  String catalog_missing_env(String names) {
    return 'まだ必要: $names';
  }

  @override
  String catalog_server_error(String name, String error) {
    return '$name に接続できませんでした: $error';
  }

  @override
  String get catalog_send_failed => '選択を送信できませんでした。もう一度お試しください。';

  @override
  String get attachment_video_speed => '再生速度';

  @override
  String get catalog_installing => 'インストール中…';

  @override
  String get catalog_phase_downloading => 'ダウンロード中…';

  @override
  String get catalog_phase_python_packages => 'Python パッケージをインストール中…';

  @override
  String get catalog_phase_loading_tools => 'ツールを読み込み中…';

  @override
  String get setup_beat_send_failed => '回答を送信できませんでした。もう一度お試しください。';

  @override
  String catalog_tool_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個のツール',
    );
    return '$_temp0';
  }

  @override
  String get render_svg_not_drawn => 'この SVG は描画されませんでした。';

  @override
  String get render_notes_directive => 'メモ ディレクティブ';

  @override
  String get render_maths_source => '数式のソース';

  @override
  String get render_inline_maths_source => 'インライン数式のソース';

  @override
  String get render_sequence_outline => 'シーケンスの概要';

  @override
  String get render_diagram_outline => '図の概要';

  @override
  String render_revision_of(int index, int count) {
    return 'リビジョン $index/$count';
  }

  @override
  String get render_previous_revision => '前のリビジョン';

  @override
  String get render_next_revision => '次のリビジョン';

  @override
  String get render_show_rendered => '表示';

  @override
  String get render_show_source => 'ソース';

  @override
  String render_copied_file(String name) {
    return '$name をコピーしました';
  }

  @override
  String render_copy_file(String name) {
    return '$name をコピー';
  }

  @override
  String get render_artifact_too_long => 'この成果物は長すぎるため、ここではページとして表示できません。';

  @override
  String get render_active_content_removed => 'スクリプト、フレーム、外部アドレスは削除されました。';

  @override
  String render_widget_file(String file) {
    return 'ウィジェット $file';
  }

  @override
  String get render_widget_runs_as_text =>
      'このチャットではテキストとして動作します。スクリプトと外部フレームは削除されます。';

  @override
  String get render_load_widget => 'ウィジェットを読み込む';

  @override
  String get render_not_html_widget => 'このファイルは HTML ウィジェットではありません。';

  @override
  String get render_widget_sent => 'このチャットに送信しました';

  @override
  String get render_widget_not_sent => 'このチャットに送信されませんでした';

  @override
  String get render_widget_throttled => '少し待ってからもう一度送信してください';

  @override
  String get render_widget_too_long => 'このリクエストは長すぎるため送信できません';

  @override
  String get render_widget_no_gesture => '送信するにはウィジェット内のコントロールをタップしてください';

  @override
  String get render_widget_invalid => 'このリクエストを送信できませんでした';

  @override
  String get render_inspected_image => '確認した画像';

  @override
  String get render_contributions => 'コントリビューション';

  @override
  String get render_contributions_intro =>
      '返信に追加できるのは Ares に組み込まれたコントリビューションだけです。チャットのテキストからは登録できず、許可はこの接続にのみ適用されます。';

  @override
  String render_grant_plugin(String name) {
    return '$name を許可';
  }

  @override
  String render_revoke_plugin(String name) {
    return '$name の許可を取り消す';
  }

  @override
  String render_plugin_slots(String directive) {
    return '::$directive の返信カード';
  }

  @override
  String get render_plugin_notes => 'メモ';

  @override
  String get catalog_scan_passed => '合格';

  @override
  String get catalog_scan_warnings => '警告あり';

  @override
  String get catalog_scan_failed => '不合格';

  @override
  String get deployment_token_label => 'デプロイメントトークン(任意)';

  @override
  String get deployment_token_helper =>
      'X-Hermes-Session-Token として送信される Hermes Dashboard のセッショントークン用です。平文の設定には保存されません。';

  @override
  String get deployment_token_hint => 'ダッシュボードのセッショントークン';

  @override
  String get custom_headers_label => 'カスタムヘッダー(任意)';

  @override
  String get custom_headers_helper =>
      '1 行に 1 つ。例: X-Custom: 値。禁止されたヘッダーは拒否されます。';

  @override
  String get custom_headers_hint => '例: X-Custom-Header: 値';

  @override
  String get desktop_tray_open => 'Ares を開く';

  @override
  String get desktop_tray_new_chat => '新しいチャット';

  @override
  String get desktop_tray_quick_entry => 'クイック入力…';

  @override
  String get desktop_tray_pause_notifications => '通知を一時停止';

  @override
  String get desktop_tray_quit => 'Ares を終了';

  @override
  String get desktop_integration_title => 'デスクトップ統合';

  @override
  String get desktop_tray_setting => 'システムトレイまたはメニューバーに Ares を表示';

  @override
  String get desktop_tray_setting_help =>
      'アイコンから Ares を開く、チャットを開始する、クイック入力を開く、通知を一時停止する、終了することができます。';

  @override
  String get desktop_close_to_tray_setting => 'ウィンドウを閉じてもトレイで実行を続ける';

  @override
  String get desktop_tray_unsupported => 'このデスクトップには Ares が使えるシステムトレイがありません。';

  @override
  String get quick_entry_title => 'クイック入力';

  @override
  String get quick_entry_hint => 'Ares へのプロンプトを入力…';

  @override
  String get quick_entry_submit => '入力欄に入れる';

  @override
  String get quick_entry_never_sends =>
      'Enter でテキストがチャットの入力欄に入ります。送信を押すまで何も送信されません。';

  @override
  String get quick_entry_unavailable => 'クイック入力を開けませんでした。もう一度お試しください。';

  @override
  String get desktop_hotkey_setting => 'クイック入力のショートカット';

  @override
  String desktop_hotkey_help(String shortcut) {
    return 'どこからでも $shortcut を押すとクイック入力が開きます。';
  }

  @override
  String desktop_hotkey_conflict(String shortcut) {
    return '$shortcut は別のアプリが使用しています。別のショートカットを選んでください。';
  }

  @override
  String get desktop_hotkey_unsupported =>
      'このデスクトップではアプリがグローバルショートカットを登録できません（Wayland など）。';

  @override
  String get desktop_hotkey_no_modifier => 'Cmd、Ctrl、Alt のいずれかを含めてください。';

  @override
  String get desktop_hotkey_super_key =>
      'Windows キーまたは Super キーはシステム用に予約されています。';

  @override
  String get desktop_hotkey_reserved => 'このショートカットはシステムが使用しています。';

  @override
  String desktop_hotkey_in_app(String action) {
    return 'このショートカットは Ares の $action で使用されています。';
  }

  @override
  String get desktop_hotkey_change => '変更';

  @override
  String get desktop_hotkey_reset => '既定値を使用';

  @override
  String get capture_screen_action => '画面をキャプチャ';

  @override
  String get capture_screen_help =>
      'スクリーンショットを下書きとしてメッセージに追加します。送信を押すまで何も送信されません。';

  @override
  String get capture_screen_unavailable => 'このデスクトップでは画面キャプチャを利用できません。';

  @override
  String get capture_screen_failed => '画面をキャプチャできませんでした。もう一度お試しください。';

  @override
  String get capture_permission_title => '画面収録を許可';

  @override
  String get capture_permission_body =>
      'ウィンドウをキャプチャするには、Ares に画面収録の許可が必要です。システム設定 > プライバシーとセキュリティ > 画面収録 で Ares をオンにしてから、もう一度お試しください。';

  @override
  String get capture_open_settings => 'システム設定を開く';

  @override
  String get keep_awake_title => 'コンピュータをスリープさせない';

  @override
  String get keep_awake_title_mobile => '画面をオンのままにする';

  @override
  String get keep_awake_mode_off => 'オフ';

  @override
  String get keep_awake_mode_while_working => '作業中';

  @override
  String get keep_awake_mode_always => '常に';

  @override
  String get keep_awake_off_help => 'システムのスリープを妨げません(デフォルト)。';

  @override
  String get keep_awake_while_working_help =>
      'エージェントのターンが実行中のときだけアイドルスリープを防ぎます。';

  @override
  String get keep_awake_always_help => 'このデバイスで Ares が開いている間はアイドルスリープを防ぎます。';

  @override
  String get keep_awake_off_help_mobile => '画面は通常どおりオフになります(デフォルト)。';

  @override
  String get keep_awake_while_working_help_mobile =>
      'エージェントのターンが実行中で Ares が開いている間、画面をオンのままにします。';

  @override
  String get keep_awake_always_help_mobile => 'Ares が開いている間、画面をオンのままにします。';

  @override
  String get ng_token_gateway_has_no_sign_in =>
      'このゲートウェイにはサインインがないため、デプロイメントトークンを確認できません。ホストでダッシュボード認証を有効にするか Hermes を更新してから、もう一度お試しください。';

  @override
  String get palette_open => 'アプリのコマンドパレット';

  @override
  String get palette_no_matches => '一致するアクションはありません';

  @override
  String get palette_filter_hint => '入力してアクションを絞り込み…';

  @override
  String get palette_keys_move => '↑↓ で移動';

  @override
  String get palette_keys_run => 'Enter で実行';

  @override
  String get palette_keys_close => 'Esc で閉じる';

  @override
  String get palette_search_sessions => 'セッションを検索';

  @override
  String get palette_scheduled_crons => 'スケジュール / Cron';

  @override
  String get palette_capabilities_skills => '機能とスキル';

  @override
  String get palette_insights_usage => 'インサイトと使用量';

  @override
  String get palette_more_projects => 'その他とプロジェクト';

  @override
  String get deeplink_chat_not_found => 'チャットが一覧に見つかりません。まだ読み込まれていない可能性があります。';

  @override
  String get keyboard_shortcuts_title => 'キーボードショートカット';

  @override
  String get shortcuts_reset_all => 'すべてリセット';

  @override
  String get shortcuts_reset_to_default => 'デフォルトに戻す';

  @override
  String get shortcut_action_command_palette => 'コマンドパレット';

  @override
  String get shortcut_action_new_chat => '新しいチャット';

  @override
  String get shortcut_action_search => '検索';

  @override
  String get shortcut_action_settings => '設定';

  @override
  String shortcut_action_go_to_tab(int number) {
    return 'タブ $number へ移動';
  }

  @override
  String shortcuts_conflict(String first, String second, String chord) {
    return '競合:「$first」と「$second」が両方とも $chord を使っています。どちらかを変更するまで、カスタムのショートカットはデフォルトのままです。';
  }

  @override
  String shortcuts_editor_title(String action) {
    return 'ショートカット: $action';
  }

  @override
  String get shortcuts_editor_help => 'キーの組み合わせを押すか、下で修飾キーとキーを選んでください:';

  @override
  String get shortcuts_editor_needs_modifier =>
      '入力欄での入力に影響しないよう、Cmd/Meta、Ctrl、Alt のいずれかを選んでください。';

  @override
  String shortcuts_text_editing_warning(String chord) {
    return '$chord はテキスト編集のショートカットです(コピー、貼り付け、切り取り、取り消し、やり直し、すべて選択)。ここに割り当てると、テキスト欄では使えなくなります。';
  }

  @override
  String shortcuts_text_editing_in_use(String action, String chord) {
    return '「$action」はテキスト編集のショートカット $chord を使っています。ここに割り当てている間、テキスト欄では使えません。';
  }

  @override
  String custom_headers_problem_format(int line) {
    return '$line 行目:「名前: 値」の形式が必要です';
  }

  @override
  String custom_headers_problem_missing_name(int line) {
    return '$line 行目: ヘッダー名がありません';
  }

  @override
  String custom_headers_problem_invalid_name(int line, String name) {
    return '$line 行目: ヘッダー名「$name」は無効です';
  }

  @override
  String custom_headers_problem_reserved(int line, String name) {
    return '$line 行目:「$name」は予約済みのため送信できません';
  }

  @override
  String custom_headers_problem_empty_value(int line) {
    return '$line 行目: ヘッダーの値が空です';
  }

  @override
  String get ng_enter_a_deployment_token => 'デプロイメントのセッショントークンを入力してください。';

  @override
  String get ng_custom_headers => 'カスタムヘッダー';

  @override
  String get ng_custom_headers_help =>
      'このゲートウェイ用の追加 HTTP ヘッダー(名前: 値、1 行に 1 つ)。REST と WebSocket の呼び出しで送信され、安全な資格情報ストアに保存されます。認証ヘッダーとホップバイホップヘッダーは拒否されます。';

  @override
  String get ng_use_a_deployment_token => 'デプロイメントのセッショントークンを使う';

  @override
  String get ng_sign_in_with_deployment_token => 'デプロイメントトークンでサインイン';

  @override
  String get ng_signed_in_with_deployment_token => 'デプロイメントトークンでサインインしています。';

  @override
  String get auto_speak_replies_title => '返信を自動読み上げ';

  @override
  String get auto_speak_replies_subtitle =>
      'ターン完了時に各返信を読み上げます。デフォルトではオフ。チャット内の読み上げトグルは引き続き有効です。';

  @override
  String get ng_auto_read_replies_title => '返信を自動読み上げ';

  @override
  String get ng_auto_read_replies_subtitle => 'ターン完了時に各返信を読み上げます。デフォルトではオフ。';

  @override
  String get barge_in_title => '割り込み';

  @override
  String get barge_in_subtitle => '読み上げ中に話すと途中で止められます。返信の読み上げ中はマイクがオンのままになります。';

  @override
  String get barge_in_mic_live => 'マイクオン：話すと返信の読み上げを止めます';

  @override
  String get ng_barge_in_title => '割り込み';

  @override
  String get ng_barge_in_subtitle =>
      '読み上げ中に話すと途中で止められます。返信の読み上げ中はマイクがオンのままになります。';

  @override
  String get ng_barge_in_mic_live => 'マイクオン：話すと返信の読み上げを止めます';

  @override
  String get wake_word_title => 'ウェイクワード';

  @override
  String get wake_word_subtitle =>
      'ゲートウェイでのハンズフリー起動語検出。既定ではオフ。クライアント収音が有効なときのみマイク音声を送信します。';

  @override
  String wake_word_listening(String phrase) {
    return 'ウェイクワード「$phrase」を待機中';
  }

  @override
  String wake_word_paused(String phrase) {
    return 'ウェイクワード「$phrase」— 一時停止中';
  }

  @override
  String wake_word_off(String phrase) {
    return 'ウェイクワード「$phrase」— オフ';
  }

  @override
  String get wake_word_arming => 'ウェイクワードを準備中…';

  @override
  String get wake_word_stop => 'ウェイクワードを停止';

  @override
  String get wake_word_rearm => '再待機';

  @override
  String get wake_word_capture_mode => '収音モード';

  @override
  String get wake_word_capture_auto => '自動';

  @override
  String get wake_word_capture_client => 'このデバイスのマイク';

  @override
  String get wake_word_capture_local => 'ゲートウェイホストのマイク';

  @override
  String get wake_word_capture_unavailable =>
      'このゲートウェイでは、アプリから収音モードを変更できません。ゲートウェイホストの Hermes 設定で wake_word.capture を設定してください。';

  @override
  String get wake_word_input_device => '入力マイク';

  @override
  String get wake_word_default_device => 'システム既定';

  @override
  String get ng_wake_word_title => 'ウェイクワード';

  @override
  String get ng_wake_word_subtitle => 'ゲートウェイでのハンズフリー起動語検出。既定ではオフ。';

  @override
  String get voice_engine_title => '音声会話エンジン';

  @override
  String get voice_engine_subtitle => 'このゲートウェイプロファイルでハンズフリー音声会話をどう動かすかを選びます。';

  @override
  String get voice_engine_chained => '連結（音声→テキスト → Hermes → 音声）';

  @override
  String get voice_engine_chained_short => '連結';

  @override
  String get voice_engine_live => 'GPT-Live（リアルタイム音声）';

  @override
  String get voice_engine_live_short => 'GPT-Live';

  @override
  String get voice_engine_live_needs_key =>
      'GPT-Live を有効にするには、ゲートウェイホストに OpenAI API キーを設定してください。';

  @override
  String voice_engine_fallback_chained(String reason) {
    return 'GPT-Live を利用できません（$reason）— 連結音声を使用します。';
  }

  @override
  String get voice_live_start => '音声会話を開始';

  @override
  String get voice_live_stop => '音声会話を終了';

  @override
  String get voice_live_mute => 'マイクをミュート';

  @override
  String get voice_live_unmute => 'マイクのミュートを解除';

  @override
  String get voice_live_interrupt => '割り込む／今すぐ応答';

  @override
  String get voice_live_listening => '聞き取り中';

  @override
  String get voice_live_speaking => '話しています';

  @override
  String get voice_live_thinking => '考え中';

  @override
  String get voice_live_muted => 'ミュート中';

  @override
  String get voice_live_ended_connection_lost => 'ライブ音声セッションの接続が切れました。';

  @override
  String get voice_live_ended_closed => 'ライブ音声セッションはサービスによって終了されました。';

  @override
  String wake_word_other_profile(String profile) {
    return 'このウェイクワードはプロファイル「$profile」のものです。応答するには、そのプロファイルへの接続を開いてください。';
  }

  @override
  String get wake_word_reason_disabled => 'オフ — タップして有効化';

  @override
  String get wake_word_reason_surface =>
      '別のサーフェスに限定されています（設定 wake_word.surface）';

  @override
  String get wake_word_reason_owned => '別のサーフェスがウェイクワードの待機を担当しています';

  @override
  String wake_word_reason_owned_by(String surface) {
    return '別のサーフェス（$surface）がウェイクワードの待機を担当しています';
  }

  @override
  String get wake_word_reason_unavailable => 'このゲートウェイではウェイクワードを利用できません';

  @override
  String get wake_word_reason_permission_denied => 'マイクの権限が拒否されました';

  @override
  String get wake_word_reason_permission_required => 'マイクの権限が必要です — タップして有効化';

  @override
  String get voice_live_not_enabled => 'このプロファイルでは GPT-Live が有効になっていません。';

  @override
  String get voice_live_not_available => 'GPT-Live を利用できません';

  @override
  String voice_live_start_failed(String error) {
    return 'GPT-Live を開始できませんでした: $error';
  }

  @override
  String voice_direct_stt_timeout(String seconds, String provider) {
    return '$seconds 秒で文字起こしがタイムアウトしました（$provider から応答がありません）';
  }

  @override
  String voice_direct_stt_error(String provider, String status) {
    return '$provider の STT エラー（HTTP $status）';
  }

  @override
  String voice_direct_tts_failed(String provider) {
    return '$provider への TTS リクエストに失敗しました';
  }

  @override
  String voice_direct_tts_error(String provider, String status) {
    return '$provider の TTS エラー（HTTP $status）';
  }

  @override
  String ng_wake_status_listening(String phrase) {
    return '待機中（「$phrase」）';
  }

  @override
  String ng_wake_status_off(String phrase) {
    return 'オフ（「$phrase」）';
  }

  @override
  String ng_wire_setting_unavailable(Object setting) {
    return '$setting の変更は、共有ゲートウェイではまだ利用できません';
  }

  @override
  String ng_wire_method_unavailable(Object method) {
    return '$method は、共有ゲートウェイではまだ利用できません';
  }

  @override
  String ng_wire_session_options_unsupported(Object options) {
    return '正規ゲートウェイは、明示的に指定された次のセッションオプションに対応していません: $options';
  }

  @override
  String get ng_wire_prompt_stale => 'この確認は古いか、利用できません。再接続してから回答してください';

  @override
  String get ng_wire_revision_unavailable =>
      'セッションのリビジョンを取得できません。セッションを開き直してからメタデータを編集してください';

  @override
  String get ng_wire_generation_unavailable =>
      'セッションの実行 ID を取得できません。再接続してからこのコマンドを実行してください';

  @override
  String get ng_wire_message_not_saved =>
      'このメッセージはまだ保存されていません。確定するまで待ってから、もう一度ここから分岐してください';

  @override
  String get ng_wire_not_available => '共有ゲートウェイではまだ利用できません';

  @override
  String get edit_turn_title => 'このプロンプトを編集しますか？';

  @override
  String get edit_turn_body => 'ここからプロンプトを再実行します。以降のターンはアーカイブされます。';

  @override
  String get edit_turn_send => '送信';

  @override
  String get restore_turn_title => 'このチェックポイントに復元しますか？';

  @override
  String get restore_turn_body => 'このプロンプト以降の内容を会話から削除し、ここから再度実行します。';

  @override
  String get restore_turn_confirm => '復元して再実行';

  @override
  String get edit_turn_later_turns_body => '以降のターンは会話からアーカイブされます。続行しますか？';

  @override
  String get session_history => 'セッション履歴';

  @override
  String get import_claude_or_codex => 'Claude または Codex をインポート';

  @override
  String get ng_session_history => 'セッション履歴';

  @override
  String get ng_import_claude_or_codex => 'Claude または Codex をインポート';

  @override
  String get ng_edit_and_resend => '編集して再送信';

  @override
  String get ng_restore_turn_confirm => '復元して再実行';

  @override
  String get rewind_target_unsaved =>
      'このメッセージはまだ保存されていません。完了するまで待ってから、もう一度編集してください。';

  @override
  String get rewind_turn_busy =>
      '現在の返信がまだ停止していないため、何も送信されませんでした。少し待ってからもう一度お試しください。';

  @override
  String get rewind_session_changed =>
      'このチャットはここで開いてから変更されたため、何も削除・送信されませんでした。開き直してからもう一度お試しください。';

  @override
  String get history_lineage => '関連チャット';

  @override
  String get history_lineage_none => 'このチャットには分岐や兄弟ブランチがありません。';

  @override
  String get history_lineage_unavailable => 'このゲートウェイから関連チャットを読み込めませんでした。';

  @override
  String get history_lineage_parent => '親';

  @override
  String get history_lineage_sibling => '兄弟';

  @override
  String get history_lineage_fork => '分岐';

  @override
  String get history_messages => 'メッセージ';

  @override
  String get history_messages_hint => '保存済みメッセージを選ぶと、そこから分岐または巻き戻しできます。';

  @override
  String get history_messages_none => '保存済みメッセージはまだありません。';

  @override
  String get history_messages_unavailable =>
      '保存済みメッセージを読み込めませんでした。このチャットを開いてから更新してください。';

  @override
  String get history_role_user => 'あなた';

  @override
  String get history_role_assistant => 'Hermes';

  @override
  String get history_branch_here => 'ここから分岐';

  @override
  String get history_rewind_here => 'ここまで巻き戻す';

  @override
  String get history_branch_title => 'このメッセージから分岐';

  @override
  String get history_branch_body =>
      '選択したメッセージまでの履歴を含む新しいチャットを作成します。現在のチャットはそのままです。';

  @override
  String get history_rewind_title => 'このメッセージまで巻き戻す';

  @override
  String get history_rewind_body =>
      '選択したメッセージ以降がこのチャットから削除されます。コンピューター上のファイルは変更されません。ファイルの復元はチェックポイントで別に行います。';

  @override
  String history_branched(String id) {
    return '$id として分岐しました';
  }

  @override
  String get history_open_chat => 'チャットを開く';

  @override
  String get history_mutate_unsupported =>
      '分岐と巻き戻しには、このゲートウェイに Hermes 0.23 以降が必要です。';

  @override
  String get history_checkpoints => 'チェックポイント';

  @override
  String get history_checkpoints_none => 'このセッションにはファイルのチェックポイントがありません。';

  @override
  String get history_checkpoints_unavailable => 'このゲートウェイではチェックポイントを利用できません。';

  @override
  String get history_diff_none => '差分はありません。';

  @override
  String get history_diff_loading => '変更を読み込み中…';

  @override
  String get history_diff_failed => '変更を読み込めなかったため、このチェックポイントはまだ復元できません。';

  @override
  String get history_restore_checkpoint => 'チェックポイントを復元';

  @override
  String get history_restore_title => 'このチェックポイントを復元';

  @override
  String get history_restore_body =>
      'このチェックポイント以降にエージェントが変更したファイルが当時の状態に戻ります。あなた自身の変更は残ります。以降のチャットメッセージも削除されることがあります。会話は分岐されません。';

  @override
  String get history_restore_body_all =>
      'セッションフォルダー内のすべてのファイルが、あなた自身の変更も含めてこのチェックポイントに戻ります。以降のチャットメッセージも削除されることがあります。会話は分岐されません。';

  @override
  String get history_restore_own_edits => '自分の編集も元に戻す';

  @override
  String get history_restored => 'チェックポイントを復元しました。';

  @override
  String history_restored_removed(int count) {
    return 'チェックポイントを復元しました。チャットメッセージ $count 件を削除しました。';
  }

  @override
  String get history_export => 'エクスポート';

  @override
  String get history_export_redact => 'トークンを伏せる';

  @override
  String get history_export_action => 'トランスクリプトをエクスポート';

  @override
  String get history_export_saved => 'トランスクリプトを保存しました。';

  @override
  String get history_export_unsupported =>
      'エクスポートには、このゲートウェイに Hermes 0.23 以降が必要です。';

  @override
  String get history_import_unsupported =>
      'このゲートウェイは Claude と Codex のインポートに対応していません。';

  @override
  String history_import_destination(String profile) {
    return 'インポート先プロファイル: $profile。';
  }

  @override
  String history_import_reading(String host, String profile, int count) {
    return '$host から読み込み中 · インポート先プロファイル: $profile。読み込めなかったログ: $count 件。';
  }

  @override
  String get history_import_all => 'すべて';

  @override
  String history_import_scan_failed(String reason) {
    return 'ホストのセッションを検索できませんでした: $reason';
  }

  @override
  String get history_import_none =>
      'このホストに Claude Code や Codex のセッションは見つかりませんでした。';

  @override
  String get history_import_no_match => '一致するホストセッションはありません。';

  @override
  String history_import_preview_failed(String reason) {
    return 'セッションをプレビューできませんでした: $reason';
  }

  @override
  String get history_import_open => 'インポート済みセッションを開く';

  @override
  String get history_import_action => '選択したセッションをインポート';

  @override
  String get history_import_title => 'このセッションをインポート';

  @override
  String history_import_body(String profile) {
    return 'この Claude または Codex のセッションを、このゲートウェイのプロファイル「$profile」にコピーします。';
  }

  @override
  String history_import_body_existing(String profile) {
    return 'このセッションは既に「$profile」にインポートされています。既存のコピーで続行します。';
  }

  @override
  String history_imported(String id) {
    return '$id としてインポートしました';
  }

  @override
  String history_imported_already(String id) {
    return '$id として既にインポート済み';
  }

  @override
  String history_import_directory(String path) {
    return 'ディレクトリ: $path';
  }

  @override
  String history_import_preview_partial(int shown, int total) {
    return 'プレビューは $total 件中 $shown 件を表示しています。';
  }

  @override
  String history_failed(String reason) {
    return '完了できませんでした: $reason';
  }

  @override
  String get history_error_unavailable =>
      'ゲートウェイは今この操作を実行できませんでした。もう一度お試しください。';

  @override
  String get history_error_unsupported => 'このゲートウェイはこの操作に対応していません。';

  @override
  String get history_error_denied => 'このゲートウェイはリクエストを拒否しました。';

  @override
  String get history_error_changed =>
      'このページを開いている間にチャットが変更されました。更新してからもう一度お試しください。';

  @override
  String get history_error_unbound =>
      'このチャットはゲートウェイで開かれていません。開いてからもう一度お試しください。';

  @override
  String get history_error_invalid => 'ゲートウェイからの応答をこのアプリで読み取れませんでした。';

  @override
  String ng_dock_kanban(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件のカンバンカード',
      one: '$count件のカンバンカード',
    );
    return '$_temp0';
  }

  @override
  String ng_dock_kanban_done(int count) {
    return '$count件完了';
  }

  @override
  String get ng_show_kanban => 'カンバンカードを表示';

  @override
  String get ng_hide_kanban => 'カンバンカードを非表示';

  @override
  String get ng_kanban_status_triage => 'トリアージ';

  @override
  String get ng_kanban_status_todo => '未着手';

  @override
  String get ng_kanban_status_scheduled => '予定済み';

  @override
  String get ng_kanban_status_ready => '準備完了';

  @override
  String get ng_kanban_status_running => '実行中';

  @override
  String get ng_kanban_status_blocked => 'ブロック中';

  @override
  String get ng_kanban_status_review => 'レビュー中';

  @override
  String get ng_kanban_status_done => '完了';

  @override
  String get ng_kanban_status_archived => 'アーカイブ済み';

  @override
  String ng_kanban_open_card(String title) {
    return '$titleをカンバンで開く';
  }

  @override
  String ng_kanban_show_all(int count) {
    return '$count件すべて表示';
  }

  @override
  String ng_kanban_this_chat(int count) {
    return 'このチャット（$count）';
  }

  @override
  String get ng_kanban_close => 'カンバンを閉じる';

  @override
  String get ng_kanban_block_no_dashboard =>
      'この接続にはダッシュボードへのアクセスがないため、カードの状態はリアルタイムではなく、ボードも開けません。';

  @override
  String get ng_kanban_block_unsupported =>
      'このゲートウェイではカンバンが有効になっていません。カンバンプラグインを有効にすると、リアルタイムの状態を確認してボードを開けます。';

  @override
  String get ng_kanban_block_denied =>
      'カードのリアルタイムの状態を確認してボードを開くには、ダッシュボードにサインインしてください。';

  @override
  String get ng_kanban_block_insecure =>
      'カンバンにはHTTPSまたはローカル接続が必要なため、カードの状態はリアルタイムではなく、ボードも開けません。';

  @override
  String get ng_kanban_block_unreachable =>
      'このゲートウェイのカンバンに接続できませんでした。カードの状態が古い可能性があります。';

  @override
  String get ng_kanban_block_stale =>
      '接続が変更されました。カードのリアルタイムの状態を確認するには、このチャットを開き直してください。';

  @override
  String get ng_bots_tab_roster => 'ボット一覧';

  @override
  String get ng_bots_tab_rooms => 'ルーム';

  @override
  String get ng_bots_tab_screen => '画面';

  @override
  String get ng_bots_tab_routines => 'ルーティン';

  @override
  String ng_bots_rooms_load_failed(String error) {
    return 'ルームを読み込めませんでした: $error';
  }

  @override
  String ng_bots_routines_load_failed(String error) {
    return 'ルーティンを読み込めませんでした: $error';
  }

  @override
  String ng_bots_desktop_failed(String error) {
    return 'Bot Desktop: $error';
  }

  @override
  String get ng_bots_install_not_started => 'ゲートウェイがインストールを開始しませんでした。';

  @override
  String ng_bots_install_failed_error(String error) {
    return 'インストールに失敗しました: $error';
  }

  @override
  String get ng_bots_install_cancelled => 'インストールはキャンセルされました。';

  @override
  String get ng_bots_install_no_sudo =>
      'ゲートウェイホストで sudo を使用できません。上記のコマンドをそのホストで実行してから、更新してください。';

  @override
  String ng_bots_install_exit_code(String code) {
    return 'インストールに失敗しました（終了コード $code）。';
  }

  @override
  String ng_bots_install_done(String bot) {
    return '$bot に Bot Desktop をインストールしました';
  }

  @override
  String get ng_bots_start_failed => '起動に失敗しました';

  @override
  String ng_bots_stop_title(String bot) {
    return '$bot の Bot Desktop を停止しますか？';
  }

  @override
  String get ng_bots_stop_human_held =>
      '誰かがこの画面を操作しています。停止するとその人のセッションが終了し、画面上で開いているものはすべて閉じられます。';

  @override
  String get ng_bots_stop_body => 'ボットの画面で開いているものはすべて閉じられます。';

  @override
  String get ng_bots_stop_refused => '停止が拒否されました';

  @override
  String get ng_bots_take_over_reason => 'Ares から操作を引き継ぎ';

  @override
  String ng_bots_take_over_failed(String error) {
    return '操作の引き継ぎに失敗しました: $error';
  }

  @override
  String ng_bots_force_hand_back_title(String bot) {
    return '$bot の画面をボットに戻しますか？';
  }

  @override
  String get ng_bots_force_hand_back_body =>
      'この画面は人が操作中です。まだ使用中の場合、その人は操作できなくなります。';

  @override
  String get ng_bots_hand_back => '操作を返す';

  @override
  String get ng_bots_hand_back_failed => '操作を返せませんでした';

  @override
  String get ng_bots_adopt_title => '新しいサンドボックスイメージを採用しますか？';

  @override
  String ng_bots_adopt_body(String bot, String current, String target) {
    return '$bot は $current から $target に移行します。コンテナは次回のターミナル呼び出し時に再作成され、現在のコンテナにのみ保存されているものは失われます。';
  }

  @override
  String get ng_bots_adopt_image => 'イメージを採用';

  @override
  String get ng_bots_image_switch_failed => 'イメージの切り替えに失敗しました';

  @override
  String get ng_bots_keep_refused => '維持が拒否されました';

  @override
  String ng_bots_chat_open_failed(String error) {
    return 'Bot Chat を開けませんでした: $error';
  }

  @override
  String ng_bots_title(String connection) {
    return 'ボット · $connection';
  }

  @override
  String get ng_bots_protocol_tooltip =>
      'ゲートウェイがチームメイト間メッセージングのプロトコルを自ら挿入します — 追加の SOUL.md プロトコルは送信されません。';

  @override
  String ng_bots_unavailable(String reason) {
    return 'ボットを利用できません（$reason）';
  }

  @override
  String get ng_bots_account_changed => 'アカウントが変更されました。再接続するか、更新してください。';

  @override
  String get ng_bots_try_refresh =>
      '更新してみてください。問題が続く場合、ゲートウェイがボットに対応していない可能性があります。';

  @override
  String get ng_bots_search => 'ボットを検索';

  @override
  String get ng_bots_none_found => 'ボットが見つかりません。';

  @override
  String get ng_bots_no_model => 'モデルなし';

  @override
  String ng_bots_skill_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個のスキル',
      one: '$count 個のスキル',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_bot_chat => 'Bot Chat';

  @override
  String ng_bots_install_id(String id, String protocol) {
    return 'ゲートウェイが報告したインストール ID: $id · bot_mode_protocol: $protocol';
  }

  @override
  String get ng_bots_protocol_note =>
      'bot_mode_protocol が設定されている場合、ゲートウェイがチームメイト間メッセージングのプロトコルを挿入します。ハンドル: default→hermes、それ以外はプロファイル名です。';

  @override
  String get ng_bots_no_rooms => 'ルームはまだありません。ボット一覧から作成してください。';

  @override
  String ng_bots_member_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'メンバー $count 人',
      one: 'メンバー $count 人',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_room_disbanded => '解散済み';

  @override
  String get ng_bots_room_adopted => '採用済み';

  @override
  String get ng_bots_rooms_gateway => 'ゲートウェイのルーム';

  @override
  String get ng_bots_rooms_desktop => 'デスクトップ主導のルーム';

  @override
  String ng_bots_rooms_gateway_body(String methods) {
    return 'ルームはゲートウェイが所有しています。メソッド: $methods。';
  }

  @override
  String get ng_bots_rooms_no_seat =>
      'このゲートウェイではルームをホストできない場合があります（常駐プロセスが必要です）。';

  @override
  String get ng_bots_rooms_fallback =>
      '従来のフォールバック: デスクトップがグループのラウンドを進行します（ここでは新規作成されません）。';

  @override
  String get ng_bots_create_room => 'ルームを作成';

  @override
  String get ng_bots_refresh_rooms => 'ルームを更新';

  @override
  String get ng_bots_room_created => 'ルームを作成しました';

  @override
  String ng_bots_room_refused(String reason) {
    return 'ルームの作成が拒否されました（$reason）';
  }

  @override
  String ng_bots_room_failed(String error) {
    return 'ルームの作成に失敗しました: $error';
  }

  @override
  String get ng_bots_bot => 'ボット';

  @override
  String get ng_bots_screen_unavailable => '画面のステータスを取得できません';

  @override
  String get ng_bots_screen_unavailable_body =>
      'ボットの画面を起動するとサムネイルを確認できます。自分で使用するには操作を引き継いでください。';

  @override
  String get ng_bots_take_over_note =>
      '「操作を引き継ぐ」を使うと、ライブ画面が開き、その操作権があなたに移ります。ライブ画面を閉じる、このページを離れる、またはアプリをバックグラウンドにすると、操作はボットに戻ります。';

  @override
  String get ng_bots_not_installed => '未インストール';

  @override
  String get ng_bots_unsupported_host => '非対応のホスト';

  @override
  String ng_bots_pid(String pid) {
    return 'pid $pid';
  }

  @override
  String ng_bots_missing(String items) {
    return '不足: $items';
  }

  @override
  String ng_bots_blocked(String reason) {
    return 'ブロック中: $reason';
  }

  @override
  String get ng_bots_no_switch => '保留中のサンドボックスイメージの切り替えはありません。';

  @override
  String ng_bots_switch_image(String current, String target) {
    return 'イメージの切り替え: $current → $target';
  }

  @override
  String get ng_bots_bot_in_control => 'ボットが操作中';

  @override
  String get ng_bots_person_in_control => '人が操作中';

  @override
  String get ng_bots_installing => 'ゲートウェイホストに Bot Desktop をインストールしています…';

  @override
  String get ng_bots_install_unfinished => 'インストールが完了しませんでした';

  @override
  String get ng_bots_install => 'インストール';

  @override
  String get ng_bots_start => '起動';

  @override
  String get ng_bots_take_over => '操作を引き継ぐ';

  @override
  String get ng_bots_keep_image => '現在のイメージを維持';

  @override
  String ng_bots_missing_pieces(String items) {
    return 'ゲートウェイから不足しているコンポーネントが報告されました: $items';
  }

  @override
  String get ng_bots_install_missing => '不足しているコンポーネントをインストール';

  @override
  String get ng_bots_thumbnail_unavailable => 'サムネイルを利用できません';

  @override
  String get ng_bots_thumbnail_title => '画面のサムネイル（ライブ）';

  @override
  String get ng_bots_thumbnail_suppressed => '人が画面を操作している間、サムネイルは表示されません。';

  @override
  String get ng_bots_thumbnail_pending => 'サムネイルはまだ利用できません。';

  @override
  String ng_bots_routines_of(String bot) {
    return '$bot · ルーティン';
  }

  @override
  String get ng_bots_add_routine => 'ルーティンを追加';

  @override
  String get ng_bots_no_routines => 'このボットにはルーティンがありません。';

  @override
  String get ng_bots_routines_note =>
      'ルーティンは、ボットのプロファイルストアが所有する [bot:<name>] タグ付きのジョブです。従来の委任ルーティンは読み込み時に強制的に一時停止されます。';

  @override
  String ng_bots_routine_last(String status) {
    return '前回: $status';
  }

  @override
  String ng_bots_routine_next(String time) {
    return '次回: $time';
  }

  @override
  String ng_bots_routine_error(String error) {
    return 'エラー: $error';
  }

  @override
  String ng_bots_remove_routine_title(String routine) {
    return 'ルーティン「$routine」を削除しますか？';
  }

  @override
  String ng_bots_remove_routine_body(String bot) {
    return 'このルーティンは $bot のスケジュールから削除されます。この操作は元に戻せません。';
  }

  @override
  String ng_bots_routine_action_failed(String action, String error) {
    return '$actionに失敗しました: $error';
  }

  @override
  String get ng_bots_not_connected => '接続されていません。';

  @override
  String ng_bots_add_failed(String error) {
    return '追加に失敗しました: $error';
  }

  @override
  String get ng_bots_routine_added => 'ルーティンを追加しました';

  @override
  String get ng_bots_routine_enabled => '有効';

  @override
  String get ng_bots_routine_paused => '一時停止中';

  @override
  String ng_bots_path(String path) {
    return 'パス: $path';
  }

  @override
  String get ng_bots_chat_present => 'Bot Chat あり';

  @override
  String get ng_bots_chat_missing => 'Bot Chat なし';

  @override
  String ng_bots_last_session(String preview) {
    return '前回のセッション: $preview';
  }

  @override
  String get ng_bots_open_chat => 'Bot Chat を開く';

  @override
  String get ng_bots_desktop => 'Bot Desktop';

  @override
  String get ng_bots_room_name => 'ルーム名';

  @override
  String get ng_bots_select_member => 'メンバーを 1 人以上選択してください。';

  @override
  String get ng_bots_sudo_title => '管理者パスワード';

  @override
  String ng_bots_sudo_body(String bot) {
    return '$bot に Bot Desktop をインストールするには、ゲートウェイホストで sudo が必要です。パスワードはこのインストールのためにそのゲートウェイにのみ送信され、保存されません。';
  }

  @override
  String get ng_bots_sudo_password => 'sudo パスワード';

  @override
  String get ng_bots_new_routine => '新しいルーティン';

  @override
  String get ng_bots_routine_title => 'タイトル';

  @override
  String get ng_bots_routine_instruction => '指示';

  @override
  String get ng_bots_cron => 'cron 式';

  @override
  String get ng_bots_interval => '間隔';

  @override
  String get ng_bots_cron_help => '0 9 * * * は毎日 09:00 に実行されます';

  @override
  String get ng_bots_every => '実行間隔';

  @override
  String get ng_bots_unit_minutes => '分';

  @override
  String get ng_bots_unit_hours => '時間';

  @override
  String get ng_bots_unit_days => '日';

  @override
  String get ng_bots_stop_after => '停止までの実行回数';

  @override
  String get ng_bots_stop_after_help => '空欄のままにすると実行を続けます';

  @override
  String get ng_bots_send_results => '結果の送信先';

  @override
  String get ng_bots_run_history => '実行履歴のみ';

  @override
  String get ng_bots_continuity => '前回の実行から続行';

  @override
  String get ng_bots_account_changed_refresh => 'アカウントが変更されました。続行する前に更新してください。';

  @override
  String ng_bots_room_load_failed(String error) {
    return 'ルームを読み込めませんでした: $error';
  }

  @override
  String ng_bots_send_failed(String error) {
    return '送信に失敗しました: $error';
  }

  @override
  String ng_bots_stop_failed(String error) {
    return '停止に失敗しました: $error';
  }

  @override
  String get ng_bots_stop_room => 'ルームを停止';

  @override
  String get ng_bots_send_message => 'メッセージを送信';

  @override
  String get ng_bots_room_hint => 'ルームにメッセージを送信（@handle でメンバーをメンション）';

  @override
  String get ng_bots_history => '履歴';

  @override
  String ng_bots_revision(String revision) {
    return 'リビジョン $revision';
  }

  @override
  String ng_bots_last_error(String error) {
    return '最後のエラー: $error';
  }

  @override
  String get ng_bots_members => 'メンバー';

  @override
  String get ng_bots_room_context => 'ルームのコンテキスト';

  @override
  String ng_bots_purpose(String purpose) {
    return '目的: $purpose';
  }

  @override
  String ng_bots_notes(String notes) {
    return 'メモ: $notes';
  }

  @override
  String ng_bots_routing(String routing) {
    return 'ルーティング: $routing';
  }

  @override
  String ng_bots_lead(String member) {
    return 'リーダー $member';
  }

  @override
  String get ng_bots_viewer_you_control => 'この画面はあなたが操作しています。操作を返すまでボットは待機します。';

  @override
  String get ng_bots_viewer_handed_back => '操作はボットに戻りました。';

  @override
  String get ng_bots_viewer_background => 'アプリがフォアグラウンドから離れたため、操作はボットに戻りました。';

  @override
  String get ng_bots_viewer_taken => '別のユーザーがこの画面の操作を引き継ぎました。';

  @override
  String get ng_bots_viewer_lost => 'ライブ表示が切断されたため、操作はボットに戻りました。';

  @override
  String ng_bots_viewer_title(String bot) {
    return 'Bot Desktop · $bot';
  }

  @override
  String get ng_bots_viewer_type_hint => 'ボットの画面に入力';

  @override
  String get ng_bots_viewer_type => '入力';

  @override
  String get ng_bots_viewer_enter => 'Enter';

  @override
  String get ng_bots_viewer_backspace => 'Backspace';

  @override
  String get ng_more_kanban => 'カンバン';

  @override
  String get ng_more_kanban_subtitle => 'ボード、タスクの依存関係、ワーカーの割り当て、ログ';

  @override
  String get ng_more_bots => 'ボット';

  @override
  String get ng_more_bots_subtitle => 'ボット一覧、ルーム、ルーティン、Bot Desktop';

  @override
  String get ng_slash_kanban => 'カンバンボードを開く';

  @override
  String get ng_slash_bots => 'ボットを開く';

  @override
  String ng_board_card_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 枚のカード',
      one: '$count 枚のカード',
    );
    return '$_temp0';
  }

  @override
  String ng_board_event_toast(String task, String event) {
    return 'カンバン $task: $event';
  }

  @override
  String get ng_board_task => 'タスク';

  @override
  String ng_board_refused_http(String status) {
    return '操作が拒否されました（HTTP $status）。';
  }

  @override
  String get ng_board_err_unsupported => 'このゲートウェイではカンバンプラグインが有効になっていません。';

  @override
  String get ng_board_err_denied => 'このゲートウェイではサインインまたは権限が必要です。';

  @override
  String get ng_board_err_stale => 'ゲートウェイの所有者が変更されました。続行する前に更新してください。';

  @override
  String get ng_board_err_insecure => 'カンバンのワークスペース操作には HTTPS（またはループバック）が必要です。';

  @override
  String get ng_board_err_unreachable => 'このゲートウェイのカンバンサービスに接続できませんでした。';

  @override
  String get ng_board_err_failed => '操作に失敗しました。更新してもう一度お試しください。';

  @override
  String ng_board_block_title(String task) {
    return '$task をブロック';
  }

  @override
  String get ng_board_block_reason => 'ブロックの理由';

  @override
  String get ng_board_block_hint => 'このカードをブロックしているものは何ですか？';

  @override
  String ng_board_review_title(String task) {
    return '$task のレビューを依頼';
  }

  @override
  String get ng_board_review_summary => 'レビューの概要';

  @override
  String get ng_board_review_hint => '何を実装し、検証しましたか？';

  @override
  String ng_board_move_title(String cards, String column) {
    return '$cards を $column に移動しますか？';
  }

  @override
  String ng_board_move_body(String board) {
    return '$board で選択されたすべてのカードの列が変更されます。実行中のカードは実行が停止されます。';
  }

  @override
  String get ng_board_move => '移動';

  @override
  String ng_board_moved(String column) {
    return 'カードを $column に移動しました';
  }

  @override
  String ng_board_unassign_title(String cards) {
    return '$cards の割り当てを解除しますか？';
  }

  @override
  String ng_board_assign_title(String cards, String profile) {
    return '$cards を @$profile に割り当てますか？';
  }

  @override
  String get ng_board_assign_body => '実行中のカードは先に回収され、そのワーカーは停止されます。';

  @override
  String get ng_board_unassign => '割り当て解除';

  @override
  String get ng_board_assign => '割り当て';

  @override
  String get ng_board_unassigned_done => '選択したカードの割り当てを解除しました';

  @override
  String ng_board_assigned_done(String profile) {
    return '@$profile に割り当てました';
  }

  @override
  String ng_board_archive_title(String cards) {
    return '$cards をアーカイブしますか？';
  }

  @override
  String ng_board_archive_body(String board) {
    return 'アーカイブしたカードは $board から外れます。再度表示するには「アーカイブ済み」をオンにしてください。';
  }

  @override
  String get ng_board_archived_done => '選択したカードをアーカイブしました';

  @override
  String ng_board_delete_title(String cards) {
    return '$cards を削除しますか？';
  }

  @override
  String ng_board_delete_body(String board) {
    return '選択したカードは $board から完全に削除されます。';
  }

  @override
  String ng_board_deleted(String cards) {
    return '$cards を削除しました。';
  }

  @override
  String ng_board_partial_failure(String failed, String total, String reason) {
    return '$total 件中 $failed 件が失敗しました: $reason';
  }

  @override
  String get ng_board_refused => '拒否されました';

  @override
  String ng_board_dispatched(
    String spawned,
    String promoted,
    String reclaimed,
  ) {
    return 'ディスパッチ完了: $spawned 件起動、$promoted 件昇格、$reclaimed 件回収。';
  }

  @override
  String ng_board_board_archived(String board) {
    return 'ボード $board をアーカイブしました';
  }

  @override
  String ng_board_board_archived_to(String path) {
    return '$path にアーカイブしました';
  }

  @override
  String ng_board_exported(String board, String archive) {
    return '$board を $archive にエクスポートしました';
  }

  @override
  String ng_board_imported(String board, String warnings) {
    return 'ボード $board をインポートしました$warnings';
  }

  @override
  String ng_board_created(String task) {
    return '$task を作成しました';
  }

  @override
  String get ng_board_orchestration_saved => 'カンバンのオーケストレーションを保存しました';

  @override
  String get ng_board_auto_describe_unavailable => '自動説明は利用できません';

  @override
  String ng_board_description_updated(String profile) {
    return '@$profile の説明を更新しました';
  }

  @override
  String ng_board_title(String board) {
    return 'カンバン · $board';
  }

  @override
  String ng_board_active(String count) {
    return '$count 件アクティブ';
  }

  @override
  String get ng_board_dispatch => '準備完了のタスクを今すぐディスパッチ';

  @override
  String get ng_board_orchestration => 'オーケストレーションとワーカー';

  @override
  String get ng_board_new_task => '新しいタスク';

  @override
  String get ng_board_enable_plugin =>
      'ボードルーターを有効にするには、このゲートウェイの「機能 → プラグイン」で同梱の「kanban」プラグインを有効にしてください。';

  @override
  String get ng_board_filter => 'タスクを絞り込み…';

  @override
  String get ng_board_all_assignees => 'すべての担当者';

  @override
  String get ng_board_unassigned => '未割り当て';

  @override
  String get ng_board_running_by_profile => 'プロファイル別の実行中';

  @override
  String get ng_board_select => '選択';

  @override
  String ng_board_selected_chip(String count) {
    return '選択済み（$count）';
  }

  @override
  String get ng_board_locked_column => '管理対象の列 — ドラッグ＆ドロップは無効です';

  @override
  String ng_board_add_to(String column) {
    return '$column に追加';
  }

  @override
  String ng_board_collapse(String column) {
    return '$column を折りたたむ';
  }

  @override
  String ng_board_column_empty(String column) {
    return '$column のタスクはありません';
  }

  @override
  String get ng_board_drop_here => 'ドロップまたは + タスク';

  @override
  String get ng_board_card_actions => 'カードの操作';

  @override
  String get ng_board_open_details => '詳細を開く';

  @override
  String get ng_board_select_card => 'カードを選択';

  @override
  String ng_board_move_to(String column) {
    return '$column に移動';
  }

  @override
  String get ng_board_parked => '保留中';

  @override
  String ng_board_blocked_by(String count) {
    return '$count 件にブロックされています';
  }

  @override
  String get ng_board_goal_loop => 'ゴールループ';

  @override
  String ng_board_selected(String count) {
    return '$count 件選択中';
  }

  @override
  String get ng_board_move_menu => '移動…';

  @override
  String get ng_board_assign_menu => '割り当て…';

  @override
  String get ng_board_new_board_title => '新しいカンバンボード';

  @override
  String get ng_board_slug => 'スラッグ（小文字、例: release-v5）';

  @override
  String get ng_board_display_name => '表示名';

  @override
  String get ng_board_linked_project => 'リンクされたプロジェクト（任意）';

  @override
  String get ng_board_none => 'なし';

  @override
  String get ng_board_default_workdir => 'ホスト上のデフォルト作業ディレクトリ（任意）';

  @override
  String get ng_board_import_title => 'ボードアーカイブをインポート';

  @override
  String get ng_board_import_path => 'ホスト上の .tar.gz アーカイブのパス';

  @override
  String get ng_board_import => 'インポート';

  @override
  String ng_board_edit_board(String board) {
    return '$board を編集';
  }

  @override
  String get ng_board_name => '名前';

  @override
  String get ng_board_description => '説明';

  @override
  String get ng_board_workdir_clear => 'デフォルト作業ディレクトリ（空欄でクリア）';

  @override
  String get ng_board_boards => 'カンバンボード';

  @override
  String get ng_board_new_board => '新しいボード';

  @override
  String get ng_board_search_boards => 'ボードを検索…';

  @override
  String get ng_board_unpin => 'タブの固定を解除';

  @override
  String get ng_board_pin => 'タブを固定';

  @override
  String ng_board_archive_board_title(String board) {
    return 'ボード $board をアーカイブしますか？';
  }

  @override
  String ng_board_archive_board_body(String cards) {
    return 'ボードとその $cards はボード一覧から外れます。ゲートウェイはホスト上にアーカイブを保持します。';
  }

  @override
  String get ng_board_edit_metadata => 'メタデータを編集';

  @override
  String get ng_board_export => 'ホスト上に .tar.gz をエクスポート';

  @override
  String get ng_board_move_pin_left => '固定タブを左に移動';

  @override
  String get ng_board_archive_board => 'ボードをアーカイブ';

  @override
  String get ng_board_new_task_title => '新しいカンバンタスク';

  @override
  String get ng_board_title_required => 'タイトル *';

  @override
  String get ng_board_spec => '仕様と受け入れ基準';

  @override
  String get ng_board_estimate => '見積もり';

  @override
  String ng_board_estimate_draft(String complexity, String tokens) {
    return '複雑度 $complexity（約 $tokens トークン — トークン数の見積もりのみで、金額コストを示すものではありません）';
  }

  @override
  String get ng_board_estimate_unavailable => '見積もりを利用できません';

  @override
  String get ng_board_initial_column => '初期の列';

  @override
  String get ng_board_worker_assignee => '担当ワーカー';

  @override
  String get ng_board_parked_unassigned => '保留中（未割り当て）';

  @override
  String get ng_board_priority => '優先度';

  @override
  String get ng_board_workspace => 'ワークスペース';

  @override
  String get ng_board_scratch => 'スクラッチ';

  @override
  String get ng_board_worktree => 'Git ワークツリー';

  @override
  String get ng_board_shared_dir => '共有ディレクトリ';

  @override
  String get ng_board_workspace_path => 'ホストのワークスペースパス';

  @override
  String get ng_board_parent => '親の依存関係（任意）';

  @override
  String get ng_board_skills => '固定スキル（カンマ区切り、任意）';

  @override
  String get ng_board_provider_override => 'プロバイダーの上書き';

  @override
  String get ng_board_model_override => 'モデルの上書き';

  @override
  String get ng_board_reasoning => '推論の強度';

  @override
  String get ng_board_profile_default => 'プロファイルのデフォルト';

  @override
  String get ng_board_xhigh => '超高';

  @override
  String get ng_board_goal_mode => 'ゴールループモード';

  @override
  String get ng_board_goal_turns => 'ゴールの最大ターン数（空欄 = デフォルト）';

  @override
  String get ng_board_create_task => 'タスクを作成';

  @override
  String get ng_board_orchestration_title => 'オーケストレーションとワーカープロファイル';

  @override
  String ng_board_orchestrator(String profile) {
    return 'オーケストレーターのプロファイル（解決済み: $profile）';
  }

  @override
  String get ng_board_inherit_default => 'アクティブなデフォルトを継承';

  @override
  String ng_board_default_assignee(String profile) {
    return 'デフォルトの担当者（解決済み: $profile）';
  }

  @override
  String get ng_board_auto_decompose => 'トリアージのカードを自動分解';

  @override
  String get ng_board_auto_decompose_help =>
      'トリアージのタスクに、設定済みの kanban_decomposer モデルを使用します';

  @override
  String get ng_board_save_orchestration => 'オーケストレーションを保存';

  @override
  String get ng_board_worker_descriptions => 'ワーカーの専門分野の説明';

  @override
  String ng_board_worker_label(String profile, String model, String skills) {
    return '@$profile（$model · $skills）';
  }

  @override
  String get ng_board_default_model => 'デフォルトのモデル';

  @override
  String get ng_board_save_description => '説明を保存';

  @override
  String get ng_board_auto_describe => 'スキルとペルソナから自動で説明を作成';

  @override
  String get ng_board_manual_block => 'オペレーターによる手動ブロック';

  @override
  String get ng_board_requested_review => 'レビュー依頼済み';

  @override
  String ng_board_requeue_title(String task) {
    return '$task をキューに戻しますか？';
  }

  @override
  String get ng_board_requeue_body => 'このカードを実行中のワーカーは停止され、カードはキューに戻ります。';

  @override
  String get ng_board_requeue => 'キューに戻す';

  @override
  String ng_board_reassign_title(String task, String profile) {
    return '$task を @$profile に再割り当てしますか？';
  }

  @override
  String get ng_board_reassign_body => 'このカードは実行中のため、先にそのワーカーが停止されます。';

  @override
  String get ng_board_reassign => '再割り当て';

  @override
  String ng_board_saved_task(String task) {
    return 'タスク $task を保存しました';
  }

  @override
  String get ng_board_commented_requeued => 'コメントを投稿し、タスクをキューに戻しました';

  @override
  String get ng_board_commented => 'コメントを投稿しました';

  @override
  String ng_board_requeued(String task) {
    return '$task をキューに戻しました';
  }

  @override
  String get ng_board_decompose_failed => '分解に失敗しました。';

  @override
  String ng_board_decompose_failed_reason(String reason) {
    return '分解に失敗しました: $reason';
  }

  @override
  String ng_board_decomposed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 件の子タスクに分解しました',
      one: '$count 件の子タスクに分解しました',
    );
    return '$_temp0';
  }

  @override
  String get ng_board_no_children => '子タスクは作成されませんでした。';

  @override
  String ng_board_no_children_reason(String reason) {
    return '子タスクは作成されませんでした: $reason';
  }

  @override
  String ng_board_uploaded(String file) {
    return '$file をアップロードしました';
  }

  @override
  String ng_board_linked_parent(String task) {
    return '親 $task をリンクしました';
  }

  @override
  String ng_board_unlinked_parent(String task) {
    return '親 $task とのリンクを解除しました';
  }

  @override
  String get ng_board_task_load_failed => 'タスクを読み込めません';

  @override
  String get ng_board_refresh_task => 'タスクを更新';

  @override
  String get ng_board_tab_overview => '概要';

  @override
  String get ng_board_tab_comments => 'コメントとリンク';

  @override
  String get ng_board_tab_runs => '実行とログ';

  @override
  String get ng_board_tab_events => 'イベント';

  @override
  String get ng_board_decompose => '分解';

  @override
  String get ng_board_attach => 'ファイルを添付';

  @override
  String ng_board_estimate_task(
    String complexity,
    String tokens,
    String rationale,
  ) {
    return '見積もり: $complexity · 約 $tokens トークン（$rationale）— 金額コストを示すものではありません。';
  }

  @override
  String get ng_board_no_rationale => '根拠なし';

  @override
  String get ng_board_status => 'ステータス';

  @override
  String get ng_board_assignee => '担当者';

  @override
  String get ng_board_title_label => 'タイトル';

  @override
  String get ng_board_body => '本文 / 仕様';

  @override
  String get ng_board_save_changes => '変更を保存';

  @override
  String get ng_board_clear_model => 'モデルの上書きをクリア';

  @override
  String ng_board_blocked_reason(String reason) {
    return 'ブロックの理由: $reason';
  }

  @override
  String ng_board_result(String result) {
    return '結果: $result';
  }

  @override
  String ng_board_parents(String count) {
    return 'ブロック元（親 · $count）';
  }

  @override
  String get ng_board_add_parent => '+ 親を追加';

  @override
  String ng_board_children(String count) {
    return 'ブロック先（子 · $count）';
  }

  @override
  String ng_board_attachments(String count) {
    return '添付ファイル（$count）';
  }

  @override
  String get ng_board_worker => 'ワーカー';

  @override
  String ng_board_comments(String count) {
    return 'コメント（$count）';
  }

  @override
  String get ng_board_comment_hint => 'コメント / ワーカーへの指示を追加';

  @override
  String get ng_board_post_comment => 'コメントを投稿';

  @override
  String get ng_board_comment_requeue => 'コメントしてキューに戻す';

  @override
  String ng_board_runs(String count) {
    return '実行（$count）';
  }

  @override
  String get ng_board_no_runs => 'ワーカーの実行はまだ記録されていません。';

  @override
  String ng_board_run_error(String error) {
    return 'エラー: $error';
  }

  @override
  String ng_board_log_tail_truncated(String bytes) {
    return 'ワーカーログの末尾（$bytes B、切り詰め済み）';
  }

  @override
  String ng_board_log_tail(String bytes) {
    return 'ワーカーログの末尾（$bytes B）';
  }

  @override
  String get ng_board_refresh_log => 'ログを更新';

  @override
  String get ng_board_no_log => 'ワーカーログの出力はありません。';

  @override
  String get ng_board_no_events => '記録されたイベントはありません。';

  @override
  String get ng_bots_room_unknown => '不明';

  @override
  String get ng_bots_room_blocked => 'ブロック中';

  @override
  String get ng_bots_room_working => '作業中';

  @override
  String get ng_bots_room_running => '実行中';

  @override
  String get ng_bots_room_idle => '待機中';

  @override
  String ng_board_run_title(String id, String profile, String outcome) {
    return '実行 #$id · @$profile · $outcome';
  }

  @override
  String get ng_bots_new_bot => '新しいボット';

  @override
  String get ng_bots_new_bot_hint =>
      '独自のメモリ、スキル、チャットを持つ名前付きのチームメイト。他のエージェントにメッセージを送れます。';

  @override
  String get ng_bots_field_name => '名前';

  @override
  String get ng_bots_field_title => 'タイトル';

  @override
  String get ng_bots_field_description => '説明';

  @override
  String get ng_bots_description_hint => 'このボットに何を手伝ってほしいですか？';

  @override
  String get ng_bots_name_invalid =>
      '小文字、数字、ハイフン、アンダースコアを使い、英字か数字で始めてください（最大 64 文字）。';

  @override
  String ng_bots_name_taken(String name) {
    return '「$name」という名前のエージェントはすでに存在します。';
  }

  @override
  String ng_bots_profile_id(String id) {
    return 'プロファイル ID: $id';
  }

  @override
  String get ng_bots_advanced => '詳細 — モデル、スキル、ツールセット、SOUL.md';

  @override
  String get ng_bots_clone_from => '複製元のプロファイル';

  @override
  String get ng_bots_clone_main => 'メインプロファイル（default）';

  @override
  String get ng_bots_fresh_profile => '新規プロファイル（同梱スキル）';

  @override
  String get ng_bots_create_empty => '空で作成（同梱スキルを省略）';

  @override
  String get ng_bots_share_keys => 'キーとアカウントをメインプロファイルと共有';

  @override
  String get ng_bots_provider => 'プロバイダー';

  @override
  String get ng_bots_model => 'モデル';

  @override
  String get ng_bots_model_pair => 'プロバイダーとモデルの両方を入力してください。';

  @override
  String get ng_bots_soul => 'SOUL.md（任意 — 生成されたペルソナを置き換え）';

  @override
  String get ng_bots_soul_edit => 'SOUL.md';

  @override
  String get ng_bots_creating => '作成中…';

  @override
  String get ng_bots_create_bot => 'ボットを作成';

  @override
  String ng_bots_created(String name) {
    return 'ボット「$name」を作成しました';
  }

  @override
  String get ng_bots_look_failed =>
      '見た目はゲートウェイに保存されませんでした。「プロファイルを編集」で設定してください。';

  @override
  String ng_bots_request_failed(String reason) {
    return 'ゲートウェイが受け付けませんでした（$reason）。';
  }

  @override
  String get ng_bots_avatar_shape => '形';

  @override
  String ng_bots_avatar_shape_n(int n) {
    return '形 $n';
  }

  @override
  String get ng_bots_avatar_colour => '色';

  @override
  String ng_bots_avatar_colour_n(int n) {
    return '色 $n';
  }

  @override
  String get ng_bots_avatar_match_name => '名前に合わせる';

  @override
  String get ng_bots_avatar_upload => '画像を選択…';

  @override
  String get ng_bots_avatar_remove => '画像を削除 — 形を使う';

  @override
  String get ng_bots_avatar_too_large => '画像が大きすぎます（最大 15 MB）。';

  @override
  String get ng_bots_avatar_unreadable => 'その画像を読み込めませんでした。';

  @override
  String get ng_bots_edit_profile => 'プロファイルを編集';

  @override
  String ng_bots_edit_description(String name, String profile) {
    return '$name（$profile）の外観と役割。';
  }

  @override
  String ng_bots_advanced_failed(String reason) {
    return 'プロファイル設定を読み込めませんでした（$reason）。';
  }

  @override
  String get ng_bots_skills => 'スキル';

  @override
  String get ng_bots_toolsets => 'ツールセット';

  @override
  String get ng_bots_toolsets_hint =>
      'すべて（またはなし）をチェックしたままにすると既定のツールセット動作になります。';

  @override
  String get ng_bots_mcp_servers => 'MCP サーバー';

  @override
  String get ng_bots_saving => '保存中…';

  @override
  String get ng_bots_confirm_changes_title => 'これらの変更を保存しますか？';

  @override
  String get ng_bots_change_remove_image => 'ボットの画像を削除';

  @override
  String get ng_bots_change_soul => 'SOUL.md を置き換え';

  @override
  String ng_bots_change_turn_off(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'スキル・ツールセット・MCP サーバーを $count 件オフにする',
    );
    return '$_temp0';
  }

  @override
  String ng_bots_updated(String name) {
    return '$name を更新しました';
  }

  @override
  String ng_bots_sections_failed(String sections) {
    return '一部のセクションが失敗しました: $sections';
  }

  @override
  String get ng_bots_model_confirm_title => 'モデルを切り替えますか？';

  @override
  String get ng_bots_model_confirm_ok => '切り替える';

  @override
  String get ng_bots_model_not_switched => 'モデルは切り替えられていません。';

  @override
  String get ng_bots_section_new => '新しいセクション';

  @override
  String get ng_bots_section_new_ellipsis => '新しいセクション…';

  @override
  String get ng_bots_section_name => 'セクション名';

  @override
  String get ng_bots_section_name_hint => '例: クライアント';

  @override
  String get ng_bots_section_create => '作成';

  @override
  String get ng_bots_section_rename => 'セクション名を変更';

  @override
  String get ng_bots_section_delete => 'セクションを削除';

  @override
  String get ng_bots_section_move_up => '上へ移動';

  @override
  String get ng_bots_section_move_down => '下へ移動';

  @override
  String get ng_bots_section_unassigned => '未割り当て';

  @override
  String ng_bots_section_options(String name) {
    return 'セクション「$name」のオプション';
  }

  @override
  String get ng_bots_section_empty => 'まだボットはありません。ボットの「セクションへ移動」を使ってください。';

  @override
  String get ng_bots_section_move_to => 'セクションへ移動';

  @override
  String get ng_bots_section_remove => 'セクションから外す';

  @override
  String ng_bots_section_deleted(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '「$name」を削除しました — $count 件のボットを未割り当てに移動',
      zero: '「$name」を削除しました',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_undo => '元に戻す';

  @override
  String ng_bots_section_move_failed(String reason) {
    return 'ボットを移動できませんでした（$reason）。';
  }

  @override
  String ng_bots_bot_actions(String name) {
    return '$name の操作';
  }

  @override
  String ng_bots_section_toggle(String name) {
    return '$name の表示を切り替え';
  }

  @override
  String
  get release_core_transcript_reader_this_passage_is_no_longer_in_the_loaded =>
      'この箇所は読み込み済みの範囲に含まれなくなりました。';

  @override
  String get release_core_transcript_reader_loaded_prompts => '読み込み済みのプロンプト';

  @override
  String get release_core_transcript_reader_jump_to_latest => '最新に移動';

  @override
  String get release_core_transcript_reader_no_prompts_loaded =>
      '読み込み済みのプロンプトはありません';

  @override
  String get release_core_transcript_reader_find_in_loaded_messages =>
      '読み込み済みメッセージ内を検索';

  @override
  String get release_core_transcript_reader_previous_match => '前の一致箇所';

  @override
  String get release_core_transcript_reader_next_match => '次の一致箇所';

  @override
  String get release_core_transcript_reader_prompt_timeline => 'プロンプトのタイムライン';

  @override
  String get release_core_transcript_reader_close_find => '検索を閉じる';

  @override
  String get release_core_session_organisation_organise_chats => 'チャットを整理';

  @override
  String get release_core_session_organisation_show_model_and_usage =>
      'モデルと使用量を表示';

  @override
  String
  get release_core_session_files_view_connection_changed_reopen_files_on_the_new_connection =>
      '接続が変更されました。新しい接続でファイルを開き直してください。';

  @override
  String
  get release_core_session_files_view_the_connection_or_session_changed_reopen_this_pane =>
      '接続またはセッションが変更されました。このペインを開き直してください。';

  @override
  String
  get release_core_session_files_view_no_verified_host_working_directory_for_this_session =>
      'このセッションには、確認済みのホスト作業ディレクトリがありません。';

  @override
  String
  get release_core_session_files_view_the_gateway_denied_this_operation =>
      'ゲートウェイがこの操作を拒否しました。';

  @override
  String
  get release_core_session_files_view_this_gateway_does_not_support_this_operation =>
      'このゲートウェイはこの操作に対応していません。';

  @override
  String
  get release_core_session_files_view_the_file_owner_or_working_directory_changed_reload =>
      'ファイル、所有者、または作業ディレクトリが変更されました。再読み込みして確認してください。';

  @override
  String
  get release_core_session_files_view_the_gateway_returned_an_unsafe_path_or_invalid =>
      'ゲートウェイから安全でないパス、または無効なファイル応答が返されました。';

  @override
  String
  get release_core_session_files_view_workspace_access_requires_a_secure_gateway_connection =>
      'ワークスペースへのアクセスには、安全なゲートウェイ接続が必要です。';

  @override
  String
  get release_core_session_files_view_gateway_unavailable_refresh_to_check_the_current_state =>
      'ゲートウェイを利用できません。更新して現在の状態を確認してください。';

  @override
  String
  get release_core_session_files_view_gateway_operation_could_not_be_confirmed =>
      'ゲートウェイでの操作を確認できませんでした。';

  @override
  String get release_core_session_files_view_git_status_unavailable =>
      'Gitの状態を取得できません。';

  @override
  String
  get release_core_session_files_view_change_this_chat_s_working_directory =>
      'このチャットの作業ディレクトリを変更しますか？';

  @override
  String get release_core_session_files_view_absolute_gateway_directory =>
      'ゲートウェイ上のディレクトリの絶対パス';

  @override
  String get release_core_session_files_view_change_directory => 'ディレクトリを変更';

  @override
  String get release_core_session_files_view_replace_gateway_file =>
      'ゲートウェイ上のファイルを置き換えますか？';

  @override
  String
  release_core_session_files_view_only_if_the_file_still_matches_the_version(
    String path,
  ) {
    return '$path\n\nファイルが確認時のバージョンと一致する場合にのみ置き換えます。対応するホストでは、置き換え前のファイルを復旧用に保持します。';
  }

  @override
  String get release_core_session_files_view_save_changes => '変更を保存';

  @override
  String
  get release_core_session_files_view_saved_and_verified_on_the_gateway =>
      'ゲートウェイに保存し、確認しました。';

  @override
  String
  get release_core_session_files_view_guarded_saving_is_unavailable_on_this_gateway_your =>
      'このゲートウェイでは競合を防ぐ保存を利用できません。下書きはここに残っています。';

  @override
  String
  release_core_session_files_view_save_was_not_confirmed_your_draft_is_still(
    String reason,
  ) {
    return '$reason 保存を確認できませんでした。下書きはここに残っています。';
  }

  @override
  String get release_core_session_files_view_review_current_gateway_version =>
      'ゲートウェイ上の現在のバージョンを確認';

  @override
  String get release_core_session_files_view_discard_draft_and_reload =>
      '下書きを破棄して再読み込み';

  @override
  String get release_core_session_files_view_keep_draft_against_this_version =>
      'このバージョンに対する下書きとして保持';

  @override
  String get release_core_session_files_view_discard_unsaved_edits =>
      '未保存の編集を破棄しますか？';

  @override
  String get release_core_session_files_view_keep_editing => '編集を続ける';

  @override
  String get release_core_session_files_view_discard_edits => '編集を破棄';

  @override
  String get release_core_session_files_view_remote_working_directory =>
      'リモート作業ディレクトリ';

  @override
  String get release_core_session_files_view_change_working_directory =>
      '作業ディレクトリを変更';

  @override
  String get release_core_session_files_view_show_ignored_files =>
      '無視されたファイルを表示';

  @override
  String
  get release_core_session_files_view_gateway_does_not_report_ignored_status =>
      'ゲートウェイは無視状態を報告しません。';

  @override
  String get release_core_session_files_view_no_visible_entries =>
      '表示できる項目はありません';

  @override
  String get release_core_session_files_view_changed => '変更あり';

  @override
  String get release_core_session_files_view_ignored => '無視';

  @override
  String release_core_session_files_view_actions_for(String name) {
    return '$nameの操作';
  }

  @override
  String get release_core_session_files_view_copy_relative_path => '相対パスをコピー';

  @override
  String get release_core_session_files_view_copy_gateway_path =>
      'ゲートウェイ上のパスをコピー';

  @override
  String get release_core_session_files_view_attach_folder_reference =>
      'フォルダ参照を添付';

  @override
  String get release_core_session_files_view_attach_file_reference =>
      'ファイル参照を添付';

  @override
  String
  get release_core_session_files_view_preview_truncated_editing_disabled =>
      'プレビューが省略されているため、編集できません。';

  @override
  String get release_core_session_files_view_select_lines => '行を選択';

  @override
  String get release_core_session_files_view_review_gateway_version =>
      'ゲートウェイ上のバージョンを確認';

  @override
  String get release_core_session_files_view_attach_selected_lines =>
      '選択した行を添付';

  @override
  String get release_core_session_files_view_binary_file_no_text_preview =>
      'バイナリファイルのため、テキストプレビューはありません。';

  @override
  String get release_core_session_files_view_file_source => 'ファイルのソース';

  @override
  String get release_core_session_files_view_close_session_files =>
      'セッションファイルを閉じる';

  @override
  String get release_core_session_files_view_back_to_tree => 'ツリーに戻る';

  @override
  String get release_core_session_files_view_session_files => 'セッションファイル';

  @override
  String get release_core_session_files_view_git_review => 'Gitレビュー';

  @override
  String get release_core_session_files_view_refresh_tree => 'ツリーを更新';

  @override
  String
  get release_core_gateway_queue_screen_this_connection_changed_reopen_its_chat =>
      'この接続が変更されました。チャットを開き直してください。';

  @override
  String
  get release_core_gateway_queue_screen_disconnected_reconnect_the_chat_then_refresh =>
      '切断されました。チャットに再接続してから更新してください。';

  @override
  String release_core_gateway_queue_screen_gateway_queue_unavailable(
    String reason,
  ) {
    return 'ゲートウェイのキューを利用できません: $reason。';
  }

  @override
  String release_core_gateway_queue_screen_not_confirmed_nothing_was_resent(
    String reason,
  ) {
    return '確認できませんでした（$reason）。再送信はしていません。';
  }

  @override
  String get release_core_gateway_queue_screen_gateway_confirmed_admission =>
      'ゲートウェイが受け付けを確認しました。';

  @override
  String
  get release_core_gateway_queue_screen_edited_entry_admitted_at_the_end_of_the =>
      '編集した項目がキューの末尾に受け付けられました。';

  @override
  String get release_core_gateway_queue_screen_discard_unknown_outcome =>
      '結果不明の項目を破棄しますか？';

  @override
  String get release_core_gateway_queue_screen_remove_this_entry =>
      'この項目を削除しますか？';

  @override
  String
  get release_core_gateway_queue_screen_the_lost_turn_will_not_be_retried_waiting =>
      '結果を確認できなかったターンは再試行されません。待機中のターンが実行される場合があります。';

  @override
  String
  get release_core_gateway_queue_screen_if_the_gateway_has_just_started_this_entry =>
      'ゲートウェイがこの項目の処理を開始した直後の場合、削除するとそのターンが停止することがあります。';

  @override
  String get release_core_gateway_queue_screen_keep => '保持';

  @override
  String get release_core_gateway_queue_screen_discard_and_resume => '破棄して再開';

  @override
  String get release_core_gateway_queue_screen_remove_entry => '項目を削除';

  @override
  String
  get release_core_gateway_queue_screen_lost_admission_resolved_it_was_not_resent =>
      '受け付け結果が不明だった項目を解決しました。再送信はしていません。';

  @override
  String get release_core_gateway_queue_screen_gateway_acknowledged_removal =>
      'ゲートウェイが削除を受理しました。';

  @override
  String get release_core_gateway_queue_screen_gateway_queue => 'ゲートウェイのキュー';

  @override
  String get release_core_gateway_queue_screen_refresh_queue => 'キューを更新';

  @override
  String get release_core_gateway_queue_screen_queue_paused_unknown_outcome =>
      'キューを一時停止中: 結果不明';

  @override
  String
  get release_core_gateway_queue_screen_review_the_lost_admission_before_resuming_nothing_is =>
      '再開する前に、受け付け結果が不明な項目を確認してください。再送信は行いません。';

  @override
  String get release_core_gateway_queue_screen_no_pending_admissions =>
      '受け付け待ちの項目はありません';

  @override
  String get release_core_gateway_queue_screen_discard => '破棄…';

  @override
  String
  get release_core_gateway_queue_screen_gateway_acknowledged_the_steering_request =>
      'ゲートウェイが追加指示のリクエストを受理しました。';

  @override
  String get release_core_gateway_queue_screen_steer_running_turn =>
      '実行中のターンに追加指示';

  @override
  String get release_core_gateway_queue_screen_remove => '削除…';

  @override
  String get release_core_gateway_queue_screen_next_prompt => '次のプロンプト';

  @override
  String get release_core_gateway_queue_screen_edit_queued_prompt =>
      'キュー内のプロンプトを編集';

  @override
  String get release_core_gateway_queue_screen_submit_to_gateway_queue =>
      'ゲートウェイのキューに送信';

  @override
  String get release_core_gateway_queue_screen_save_at_queue_end => 'キューの末尾に保存';

  @override
  String get release_core_gateway_queue_screen_cancel_edit => '編集をキャンセル';

  @override
  String get release_core_git_review_pane_the_git_operation_did_not_complete =>
      'Git操作が完了しませんでした。';

  @override
  String get release_core_git_review_pane_close_git_review => 'Gitレビューを閉じる';

  @override
  String get release_core_git_review_pane_pin_lane => 'レーンを固定';

  @override
  String get release_core_git_review_pane_refresh_git_review => 'Gitレビューを更新';

  @override
  String get release_core_git_review_pane_uncommitted => '未コミット';

  @override
  String get release_core_git_review_pane_last_turn => '前回のターン';

  @override
  String
  get release_core_git_review_pane_branch_and_last_turn_views_are_read_only =>
      'ブランチ表示と前回のターン表示は読み取り専用です。';

  @override
  String get release_core_git_review_pane_mark_head_as_the_turn_baseline =>
      'HEADをターンの基準点に設定';

  @override
  String get release_core_git_review_pane_stage_all => 'すべてステージ';

  @override
  String get release_core_git_review_pane_discard_every_uncommitted_change =>
      '未コミットの変更をすべて破棄しますか？';

  @override
  String
  get release_core_git_review_pane_tracked_files_return_to_head_and_untracked_files =>
      '追跡対象のファイルをHEADに戻し、このセッションのディレクトリ内にある未追跡ファイルを削除します。';

  @override
  String get release_core_git_review_pane_discard => '破棄';

  @override
  String get release_core_git_review_pane_discard_all => 'すべて破棄';

  @override
  String get release_core_git_review_pane_unstage => 'ステージを解除';

  @override
  String get release_core_git_review_pane_stage => 'ステージ';

  @override
  String get release_core_git_review_pane_discard_file => 'ファイルの変更を破棄';

  @override
  String release_core_git_review_pane_discard_2(String path) {
    return '$pathの変更を破棄しますか？';
  }

  @override
  String
  get release_core_git_review_pane_this_restores_the_committed_copy_or_removes_the =>
      'コミット済みの内容に戻すか、未追跡ファイルを削除します。';

  @override
  String get release_core_git_review_pane_commit_message => 'コミットメッセージ';

  @override
  String get release_core_git_review_pane_nothing_in_the_diff_to_summarise =>
      '要約する差分はありません。';

  @override
  String get release_core_git_review_pane_generate_message => 'メッセージを生成';

  @override
  String get release_core_git_review_pane_commit => 'コミット';

  @override
  String get release_core_git_review_pane_commit_and_push => 'コミットしてプッシュ';

  @override
  String get release_core_git_review_pane_push => 'プッシュ';

  @override
  String get release_core_git_review_pane_create_pull_request => 'プルリクエストを作成';

  @override
  String get release_core_git_review_pane_pull_request_ready => 'プルリクエストの準備完了';

  @override
  String get release_core_git_review_pane_ask_hermes_to_ship => 'Hermesに公開を依頼';

  @override
  String get release_core_git_review_pane_gh_is_authenticated_on_this_gateway =>
      'このゲートウェイではghが認証済みです。';

  @override
  String
  get release_core_git_review_pane_install_the_github_cli_gh_and_sign_in =>
      'PRを作成するには、GitHub CLI（gh）をインストールしてサインインしてください';

  @override
  String get release_core_git_review_pane_worktrees => 'ワークツリー';

  @override
  String get release_core_git_review_pane_main => 'メイン';

  @override
  String release_core_git_review_pane_follow(String branch) {
    return '$branchに追従しますか？';
  }

  @override
  String
  get release_core_git_review_pane_the_session_working_directory_becomes_this_worktree_unless =>
      'レーンが固定されていなければ、セッションの作業ディレクトリがこのワークツリーになります。';

  @override
  String get release_core_git_review_pane_follow_2 => '追従';

  @override
  String release_core_git_review_pane_remove(String branch) {
    return '$branchを削除しますか？';
  }

  @override
  String get release_core_git_review_pane_the_worktree_directory_is_removed =>
      'ワークツリーのディレクトリを削除します。';

  @override
  String get release_core_git_review_pane_remove_2 => '削除';

  @override
  String get release_core_git_review_pane_new_worktree_name => '新しいワークツリー名';

  @override
  String get release_core_git_review_pane_new_branch => '新しいブランチ';

  @override
  String get release_core_git_review_pane_base_branch => 'ベースブランチ';

  @override
  String get release_core_git_review_pane_create_worktree => 'ワークツリーを作成';

  @override
  String get release_core_git_review_pane_existing_branch => '既存のブランチ';

  @override
  String get release_core_git_review_pane_convert_branch_to_worktree =>
      'ブランチをワークツリーに変換';

  @override
  String get release_core_git_review_pane_switch_branch => 'ブランチを切り替え';

  @override
  String
  get release_core_git_review_pane_this_gateway_does_not_support_that_git_operation =>
      'このゲートウェイはそのGit操作に対応していません。';

  @override
  String
  get release_core_git_review_pane_git_needs_the_session_directory_on_the_local =>
      'Gitには、ローカルのターミナルバックエンド上にあるセッションディレクトリが必要です。';

  @override
  String
  get release_core_git_review_pane_the_gateway_refused_the_git_operation =>
      'ゲートウェイがGit操作を拒否しました。';

  @override
  String
  get release_core_git_review_pane_the_session_changed_refresh_and_try_again =>
      'セッションが変更されました。更新してもう一度お試しください。';

  @override
  String
  get release_core_git_review_pane_this_review_is_no_longer_the_selected_session =>
      'このレビューは、選択中のセッションのものではなくなりました。';

  @override
  String
  get release_core_git_review_pane_the_gateway_returned_an_unexpected_git_result =>
      'ゲートウェイから予期しないGitの結果が返されました。';

  @override
  String
  get release_core_git_review_pane_git_review_requires_the_gateway_transport =>
      'Gitレビューにはゲートウェイトランスポートが必要です。';

  @override
  String get release_core_client_held_queue_bar_resume => '再開';

  @override
  String get release_core_client_held_queue_bar_send_queued_prompt =>
      'キュー内のプロンプトを送信';

  @override
  String get release_core_client_held_queue_bar_edit_unsent_prompt =>
      '未送信のプロンプトを編集';

  @override
  String get release_core_client_held_queue_bar_remove_unsent_prompt =>
      '未送信のプロンプトを削除';

  @override
  String get release_core_workspace_discovery_view_repository_discovery =>
      'リポジトリの検出';

  @override
  String get release_core_workspace_discovery_view_refresh_results => '結果を更新';

  @override
  String release_core_workspace_discovery_view_hide(String path) {
    return '$pathを非表示';
  }

  @override
  String
  get release_core_workspace_discovery_view_invalid_path_or_discovery_data_use_absolute_server =>
      'パスまたは検出データが無効です。「.」や「..」というパス要素を含まないサーバー上の絶対パスを使用してください。';

  @override
  String
  get release_core_workspace_discovery_view_this_gateway_does_not_support_repository_discovery =>
      'このゲートウェイはリポジトリの検出に対応していません。';

  @override
  String
  get release_core_workspace_discovery_view_the_gateway_denied_access_to_repository_discovery =>
      'ゲートウェイがリポジトリ検出へのアクセスを拒否しました。';

  @override
  String
  get release_core_workspace_discovery_view_the_connection_changed_reopen_discovery_on_the_current =>
      '接続が変更されました。現在のゲートウェイで検出画面を開き直してください。';

  @override
  String
  get release_core_workspace_discovery_view_the_displayed_settings_have_changed_refresh_before_trying =>
      '表示中の設定が変更されました。再試行する前に更新してください。';

  @override
  String
  get release_core_workspace_discovery_view_could_not_load_or_verify_discovery_settings_refresh =>
      '検出設定の読み込みまたは確認ができませんでした。更新してもう一度お試しください。';

  @override
  String release_core_workspace_discovery_view_repositories_shown_of(
    int visible,
    int total,
  ) {
    return '表示中のリポジトリ: $total件中$visible件';
  }

  @override
  String
  get release_core_workspace_discovery_view_the_gateway_returned_no_repositories =>
      'ゲートウェイからリポジトリが返されませんでした。';

  @override
  String
  get release_core_workspace_discovery_view_no_repositories_match_your_device_filters =>
      'この端末のフィルターに一致するリポジトリはありません。';

  @override
  String get release_core_workspace_discovery_view_gateway_scan_policy =>
      'ゲートウェイのスキャンポリシー';

  @override
  String
  get release_core_workspace_discovery_view_this_gateway_did_not_report_a_scan_policy =>
      'このゲートウェイはスキャンポリシーを報告しませんでした。';

  @override
  String
  get release_core_workspace_discovery_view_to_scan_folders_configure_repository_scanning_in_the =>
      'フォルダをスキャンするには、ゲートウェイのプロファイルのDesktop設定でリポジトリスキャンを設定してください。';

  @override
  String
  get release_core_workspace_discovery_view_results_can_include_cached_repositories_and_repositories_with =>
      '結果には、キャッシュされたリポジトリやセッションがあるリポジトリが含まれることがあります。スキャンですべてのフォルダに到達できるとは限りません。';

  @override
  String get release_core_workspace_discovery_view_scan_gateway_roots =>
      'ゲートウェイのルートをスキャン';

  @override
  String
  get release_core_workspace_discovery_view_filter_results_on_this_device =>
      'この端末で結果を絞り込む';

  @override
  String
  get release_core_workspace_discovery_view_only_this_discovery_list_changes_not_the_gateway =>
      '変更されるのはこの検出リストのみで、ゲートウェイのスキャンには影響しません。';

  @override
  String get release_core_workspace_discovery_view_include_subtrees_empty_all =>
      '含めるサブツリー（空欄ですべて）';

  @override
  String get release_core_workspace_discovery_view_exclude_subtrees =>
      '除外するサブツリー';

  @override
  String get release_core_workspace_discovery_view_apply_filters => 'フィルターを適用';

  @override
  String release_core_workspace_discovery_view_hidden_repositories(int count) {
    return '非表示のリポジトリ（$count）';
  }

  @override
  String get release_core_workspace_discovery_view_undo_hide => '非表示を元に戻す';

  @override
  String
  get release_core_workspace_discovery_view_one_absolute_server_path_per_line =>
      'サーバー上の絶対パスを1行に1つ入力';

  @override
  String get release_core_project_settings_view_project_settings => 'プロジェクト設定';

  @override
  String
  get release_core_project_settings_view_the_gateway_did_not_confirm_the_selected_project =>
      'ゲートウェイで選択したプロジェクトまたは変更を確認できませんでした。再試行する前に設定を確認してください。';

  @override
  String
  get release_core_project_settings_view_could_not_verify_these_settings_use_one_absolute =>
      'これらの設定を確認できませんでした。「.」や「..」というパス要素を含まないサーバー上のフォルダの絶対パスを1行に1つ入力してください。';

  @override
  String get release_core_project_settings_view_set_active => 'アクティブに設定';

  @override
  String get release_core_project_settings_view_icon => 'アイコン';

  @override
  String get release_core_project_settings_view_folder => 'フォルダ';

  @override
  String get release_core_project_settings_view_repository => 'リポジトリ';

  @override
  String get release_core_project_settings_view_rocket => 'ロケット';

  @override
  String get release_core_project_settings_view_star => '星';

  @override
  String get release_core_project_settings_view_book => '本';

  @override
  String get release_core_project_settings_view_terminal => 'ターミナル';

  @override
  String get release_core_project_settings_view_colour => '色';

  @override
  String get release_core_project_settings_view_primary_folder => 'メインフォルダ';

  @override
  String get release_core_project_settings_view_server_folder_paths =>
      'サーバー上のフォルダパス';

  @override
  String
  get release_core_project_settings_view_one_absolute_path_per_line_existing_folders_are =>
      '絶対パスを1行に1つ入力してください。既存のフォルダは保持されます。';

  @override
  String get release_core_project_settings_view_add_folders => 'フォルダを追加';

  @override
  String release_core_project_settings_view_choose(String label) {
    return '$labelを選択';
  }

  @override
  String
  get release_core_prepared_image_recovery_wait_for_an_empty_draft_before_restoring =>
      '下書きが空になってから復元してください。';

  @override
  String
  get release_core_prepared_image_recovery_no_unacknowledged_image_drafts_in_this_chat =>
      'このチャットに受信未確認の画像下書きはありません。';

  @override
  String get release_core_prepared_image_recovery_unacknowledged_image_drafts =>
      '受信未確認の画像下書き';

  @override
  String
  get release_core_prepared_image_recovery_the_gateway_may_already_have_received_these_restore =>
      'ゲートウェイがすでに受信している可能性があります。復元して確認してください。送信は行いません。';

  @override
  String get release_core_prepared_image_recovery_image_draft => '画像の下書き';

  @override
  String get release_core_prepared_image_recovery_discard_local_copy =>
      'ローカルのコピーを破棄';

  @override
  String
  get release_core_prepared_image_recovery_discard_this_local_image_draft =>
      'このローカルの画像下書きを破棄しますか？';

  @override
  String
  get release_core_prepared_image_recovery_image_draft_recovery_is_unavailable =>
      '画像下書きの復元を利用できません。';

  @override
  String get release_core_prepared_image_recovery_recover_image_draft =>
      '画像の下書きを復元…';

  @override
  String get release_core_session_search_mode_menu_could_not_save_search_mode =>
      '検索モードを保存できませんでした。';

  @override
  String get release_core_projects_pane_discover_repositories => 'リポジトリを検出';

  @override
  String
  get release_core_projects_pane_project_created_but_the_gateway_did_not_confirm =>
      'プロジェクトは作成されましたが、ゲートウェイでそのアイデアを確認できませんでした。';

  @override
  String get release_core_projects_pane_project_idea_optional =>
      'プロジェクトのアイデア（任意）';

  @override
  String
  get release_core_projects_pane_saved_in_the_project_description_not_a_file =>
      'ファイルではなく、プロジェクトの説明に保存されます。';

  @override
  String get release_core_project_detail_screen_new_chat_in_this_lane =>
      'このレーンで新しいチャット';

  @override
  String get release_core_project_detail_screen_review_git => 'Gitをレビュー';

  @override
  String get release_core_more_pane_gateway_fleet => 'ゲートウェイフリート';

  @override
  String
  get release_core_more_pane_connected_sessions_hermes_cloud_and_desktop_webapp =>
      '接続中のセッション、Hermes CloudとDesktop Webアプリ';

  @override
  String get release_core_more_pane_use_dashboard_sign_in_for_a_named_profile =>
      '名前付きプロファイルにはダッシュボードのサインインを使用してください。この旧APIでは、チャット履歴を所有するプロファイルを確認できません。';

  @override
  String get release_core_more_pane_capabilities => '機能';

  @override
  String
  get release_core_more_pane_install_and_govern_skills_plugins_connectors_and_tool =>
      'スキル、プラグイン、コネクター、ツールバックエンドのインストールと管理';

  @override
  String get release_core_more_pane_browser_vault => 'ブラウザー保管庫';

  @override
  String
  get release_core_more_pane_site_logins_addresses_cards_and_credential_sources =>
      'サイトのログイン情報、住所、カード、認証情報の取得元';

  @override
  String get release_core_more_pane_agent_policy => 'エージェントのポリシー';

  @override
  String
  get release_core_more_pane_approvals_checkpoints_browser_access_and_shared_metrics =>
      '承認、チェックポイント、ブラウザーへのアクセス、共有メトリクス';

  @override
  String get release_core_more_pane_remote_logs_health_maintenance_and_update =>
      'リモートログ、稼働状況、メンテナンス、更新';

  @override
  String get release_core_more_pane_schedules => 'スケジュール';

  @override
  String get release_core_more_pane_all_profiles_blueprints_catch_up_and_stop =>
      'すべてのプロファイル、ブループリント、未実行分の実行、停止';

  @override
  String get release_core_more_pane_memory_graph => 'メモリグラフ';

  @override
  String get release_core_more_pane_timeline_edits_and_memory_providers =>
      'タイムライン、編集、メモリプロバイダー';

  @override
  String get release_core_more_pane_providers_and_routes => 'プロバイダーとルート';

  @override
  String get release_core_more_pane_keys_endpoints_delegation_and_mixtures =>
      'キー、エンドポイント、委任、モデルの組み合わせ';

  @override
  String get release_core_more_pane_credits_and_plans => 'クレジットとプラン';

  @override
  String
  get release_core_more_pane_consented_nous_billing_when_the_account_allows_it =>
      'アカウントで許可されている場合の、同意に基づくNousの課金';

  @override
  String
  get release_core_fleet_screen_this_gateway_does_not_offer_this_service =>
      'このゲートウェイはこのサービスを提供していません。';

  @override
  String
  get release_core_fleet_screen_sign_in_or_permission_required_on_this_gateway =>
      'このゲートウェイではサインインまたは権限が必要です。';

  @override
  String get release_core_fleet_screen_a_secure_gateway_address_is_required =>
      '安全なゲートウェイアドレスが必要です。';

  @override
  String
  get release_core_fleet_screen_the_owner_changed_refresh_before_continuing =>
      '所有者が変更されました。続行する前に更新してください。';

  @override
  String
  get release_core_fleet_screen_could_not_verify_the_operation_check_the_gateway =>
      '操作を確認できませんでした。ゲートウェイを確認して更新してください。';

  @override
  String get release_core_fleet_screen_verified_ssh => '検証済みSSH';

  @override
  String
  get release_core_fleet_screen_confirm_a_host_key_inspect_a_remote_service =>
      'ホストキーの確認、リモートサービスの調査、シェルの起動';

  @override
  String get release_core_fleet_screen_cloud_and_desktop_webapp =>
      'クラウドとDesktop Webアプリ';

  @override
  String get release_core_fleet_screen_register_an_existing_gateway_or_webapp =>
      '既存のゲートウェイまたはWebアプリを登録';

  @override
  String
  get release_core_fleet_screen_sign_in_to_its_address_nothing_is_hosted =>
      'そのアドレスでサインインしてください。この端末では何もホストしません。';

  @override
  String get release_core_fleet_screen_fleet_updates => 'フリートの更新';

  @override
  String get release_core_fleet_screen_refresh_roster => '登録一覧を更新';

  @override
  String release_core_fleet_screen_disconnect(String gateway) {
    return '$gatewayを切断';
  }

  @override
  String get release_core_fleet_screen_open_this_gateway_on_launch =>
      '起動時にこのゲートウェイを開く';

  @override
  String
  get release_core_fleet_screen_primary_for_ares_does_not_change_the_last =>
      'Aresのメインとして使用します。最後に使用したゲートウェイは変更しません。';

  @override
  String get release_core_fleet_screen_reconnect_in_fleet_on_launch =>
      '起動時にフリート内で再接続';

  @override
  String get release_core_fleet_screen_no_sessions_for_this_profile =>
      'このプロファイルにセッションはありません。';

  @override
  String get release_core_fleet_screen_more_sessions => 'さらにセッションを表示';

  @override
  String get release_core_fleet_screen_this_gateway_was_disconnected =>
      'このゲートウェイは切断されました。';

  @override
  String
  get release_core_fleet_screen_some_conversation_data_could_not_be_loaded =>
      '会話データの一部を読み込めませんでした。';

  @override
  String get release_core_fleet_screen_message_this_session =>
      'このセッションにメッセージを送る';

  @override
  String get release_core_fleet_screen_send_to_this_session => 'このセッションに送信';

  @override
  String get release_core_fleet_updates_screen_update_these_remote_gateways =>
      'これらのリモートゲートウェイを更新しますか？';

  @override
  String
  release_core_fleet_updates_screen_this_can_restart_the_backend_and_interrupt_other(
    String gateways,
  ) {
    return 'バックエンドが再起動し、他のユーザーの操作が中断される可能性があります。Aresは更新されません。\n\n$gateways';
  }

  @override
  String get release_core_fleet_updates_screen_update_listed_gateways =>
      '一覧のゲートウェイを更新';

  @override
  String
  get release_core_fleet_updates_screen_checks_connected_gateways_cloud_is_platform_managed_entries =>
      '接続中のゲートウェイを確認します。クラウドはプラットフォーム側で管理されます。登録元を確認できない項目は除外されます。';

  @override
  String get release_core_fleet_updates_screen_check_connected_gateways =>
      '接続中のゲートウェイを確認';

  @override
  String get release_core_fleet_updates_screen_read_update_receipt =>
      '更新の実施記録を取得';

  @override
  String get release_core_fleet_updates_screen_review_eligible_updates =>
      '対象の更新を確認';

  @override
  String
  get release_core_fleet_webapp_screen_account_changed_reopen_this_page =>
      'アカウントが変更されました。このページを開き直してください。';

  @override
  String
  get release_core_fleet_webapp_screen_set_the_webapp_s_primary_gateway =>
      'Webアプリのメインゲートウェイを設定しますか？';

  @override
  String
  release_core_fleet_webapp_screen_this_changes_the_shared_registry_not_the_last(
    String webapp,
    String gateway,
    String id,
  ) {
    return '$webapp → $gateway（$id）\n共有レジストリを変更します。最後に使用したゲートウェイは変更しません。';
  }

  @override
  String get release_core_fleet_webapp_screen_set_primary => 'メインに設定';

  @override
  String get release_core_fleet_webapp_screen_serving_profile => '提供中のプロファイル';

  @override
  String get release_core_fleet_webapp_screen_hermes_cloud => 'Hermes Cloud';

  @override
  String get release_core_fleet_webapp_screen_discover_signed_in_agents =>
      'サインイン済みのエージェントを検出';

  @override
  String release_core_fleet_webapp_screen_organisation(String organisation) {
    return '組織: $organisation';
  }

  @override
  String get release_core_fleet_webapp_screen_no_agents_available =>
      '利用可能なエージェントはありません。';

  @override
  String get release_core_fleet_webapp_screen_existing_desktop_webapp =>
      '既存のDesktop Webアプリ';

  @override
  String
  get release_core_fleet_webapp_screen_check_gateway_and_web_access_status =>
      'ゲートウェイとWebアクセスの状態を確認';

  @override
  String
  get release_core_fleet_webapp_screen_these_settings_belong_to_the_machine_serving_this =>
      'これらは、このWebアプリを提供しているマシンの設定です。公開と再起動はリモート操作ではありません。';

  @override
  String get release_core_fleet_webapp_screen_read_webapp_gateway_registry =>
      'Webアプリのゲートウェイレジストリを取得';

  @override
  String get release_core_fleet_webapp_screen_last_used => '最後に使用';

  @override
  String get release_core_fleet_webapp_screen_primary => 'メイン';

  @override
  String release_core_fleet_webapp_screen_set_primary_2(String gateway) {
    return 'メインに設定: $gateway';
  }

  @override
  String get release_core_fleet_webapp_screen_read_shared_display_preferences =>
      '共有の表示設定を取得';

  @override
  String
  get release_core_fleet_webapp_screen_chat_text_direction_on_this_webapp_and_desktop =>
      'このWebアプリとDesktopのチャットの文字方向';

  @override
  String release_core_schedule_desk_screen_created_on(
    String job,
    String profile,
  ) {
    return '$profileに$jobを作成しました。';
  }

  @override
  String
  get release_core_schedule_desk_screen_the_list_covers_every_profile_on_this_gateway =>
      '一覧には、このゲートウェイのすべてのプロファイルが含まれます。停止、一時停止、未実行分の実行、配信、ブループリントの操作は、ジョブを所有するプロファイルに送信されます。';

  @override
  String get release_core_schedule_desk_screen_a_run_is_in_progress => '実行中です';

  @override
  String get release_core_schedule_desk_screen_no_current_run => '現在の実行はありません';

  @override
  String release_core_schedule_desk_screen_stop_requested_for(String job) {
    return '$jobの停止をリクエストしました。';
  }

  @override
  String release_core_schedule_desk_screen_no_run_was_in_flight_for(
    String job,
  ) {
    return '$jobに進行中の実行はありませんでした。';
  }

  @override
  String get release_core_schedule_desk_screen_stop_current_run => '現在の実行を停止';

  @override
  String get release_core_schedule_desk_screen_pause_future_runs =>
      '今後の実行を一時停止';

  @override
  String get release_core_schedule_desk_screen_resume_future_runs => '今後の実行を再開';

  @override
  String get release_core_schedule_desk_screen_catch_up_default =>
      '未実行分の扱いのデフォルト';

  @override
  String get release_core_schedule_desk_screen_run_one_missed => '未実行分を1回実行';

  @override
  String get release_core_schedule_desk_screen_skip_missed => '未実行分をスキップ';

  @override
  String get release_core_schedule_desk_screen_blueprint_recipes =>
      'ブループリントのレシピ';

  @override
  String get release_core_schedule_desk_screen_profile_for_the_new_job =>
      '新しいジョブのプロファイル';

  @override
  String release_core_schedule_desk_screen_create(String blueprint) {
    return '$blueprintを作成';
  }

  @override
  String get release_core_schedule_desk_screen_loading_delivery_targets =>
      '配信先を読み込み中';

  @override
  String release_core_schedule_desk_screen_no_home_channel(String target) {
    return '$target（ホームチャンネルなし）';
  }

  @override
  String release_core_memory_graph_screen_edit(String label) {
    return '$labelを編集';
  }

  @override
  String get release_core_memory_graph_screen_content => '内容';

  @override
  String get release_core_memory_graph_screen_archive_skill => 'スキルをアーカイブ';

  @override
  String get release_core_memory_graph_screen_delete_memory => 'メモリを削除';

  @override
  String release_core_memory_graph_screen_archive_on_it_can_be_restored_on_the(
    String label,
    String profile,
  ) {
    return '$profileの$labelをアーカイブしますか？ホスト上のCuratorで復元できます。';
  }

  @override
  String release_core_memory_graph_screen_delete_from_this_removes_that_memory(
    String label,
    String profile,
  ) {
    return '$profileから$labelを削除しますか？そのメモリが削除されます。';
  }

  @override
  String get release_core_memory_graph_screen_filter => 'フィルター';

  @override
  String get release_core_memory_graph_screen_timeline => 'タイムライン';

  @override
  String get release_core_memory_graph_screen_play_timeline => 'タイムラインを再生';

  @override
  String get release_core_memory_graph_screen_layout_code => 'レイアウトコード';

  @override
  String get release_core_memory_graph_screen_external_memory_providers =>
      '外部メモリプロバイダー';

  @override
  String
  get release_core_memory_graph_screen_a_value_is_stored_leave_blank_to_keep =>
      '値が保存されています。保持する場合は空欄にしてください。';

  @override
  String get release_core_memory_graph_screen_save_provider => 'プロバイダーを保存';

  @override
  String release_core_workspace_profiles_screen_applies_to(String profile) {
    return '適用先: $profile';
  }

  @override
  String get release_core_workspace_profiles_screen_choose_another_profile =>
      '別のプロファイルを選択';

  @override
  String
  get release_core_workspace_profiles_screen_could_not_verify_the_selected_profile_on_this =>
      'このゲートウェイで選択したプロファイルを確認できませんでした。';

  @override
  String get release_core_workspace_profiles_screen_create_profile =>
      'プロファイルを作成';

  @override
  String get release_core_workspace_profiles_screen_new_profile_id =>
      '新しいプロファイルID';

  @override
  String get release_core_assets_screen_links => 'リンク';

  @override
  String get release_core_workspace_picker_no_matching_items => '一致する項目はありません。';

  @override
  String get release_core_workspace_picker_save_layout => 'レイアウトを保存';

  @override
  String get release_core_workspace_picker_layout_name => 'レイアウト名';

  @override
  String
  get release_core_workspace_popout_this_chat_already_has_a_pop_out_window =>
      'このチャットはすでに別ウィンドウで開かれています。';

  @override
  String
  get release_core_workspace_popout_could_not_open_this_saved_chat_check_the =>
      '保存済みのチャットを開けませんでした。接続を確認して、もう一度お試しください。';

  @override
  String
  get release_core_popout_bootstrap_use_the_main_window_to_change_your_connection =>
      '接続を変更するにはメインウィンドウを使用してください。';

  @override
  String get release_core_guarded_save_refused => 'このファイルはゲートウェイで保存できません';

  @override
  String get release_core_guarded_save_unavailable =>
      'このゲートウェイでは競合を防ぐ保存を利用できません';

  @override
  String release_core_git_files_changed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'このターンで$countファイルを変更',
      one: 'このターンで1ファイルを変更',
    );
    return '$_temp0';
  }

  @override
  String release_core_git_entries_omitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '安全に表示できないため、Gitの項目を$count件省略しました。',
      one: '安全に表示できないため、Gitの項目を1件省略しました。',
    );
    return '$_temp0';
  }

  @override
  String get release_core_git_staged => 'ステージ済み';

  @override
  String get release_core_session_sort_recent => '最近のアクティビティ';

  @override
  String get release_core_session_sort_created => '作成日時の新しい順';

  @override
  String get release_core_session_sort_status => '実行中を先頭に';

  @override
  String get release_core_session_sort_tokens => 'トークン数の多い順';

  @override
  String get release_core_session_sort_cost => 'コストの高い順';

  @override
  String get release_core_session_group_standard => 'デフォルトのグループ化';

  @override
  String get release_core_session_group_status => '状態別にグループ化';

  @override
  String get release_core_session_group_project => 'プロジェクト別にグループ化';

  @override
  String release_core_session_tokens(int count) {
    return '$countトークン';
  }

  @override
  String release_core_search_gateway_mode(String mode) {
    return '$mode（ゲートウェイ）';
  }

  @override
  String release_core_search_mode_tooltip(String label, String mode) {
    return '$label: $mode';
  }

  @override
  String get release_core_image_recovery_new_turn => '送信すると新しいターンが作成されます';

  @override
  String release_core_image_recovery_metadata(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '画像$count枚 · $date',
      one: '画像1枚 · $date',
    );
    return '$_temp0';
  }

  @override
  String release_core_discovery_scanning(String state) {
    return 'スキャン: $state';
  }

  @override
  String get release_core_discovery_enabled => '有効';

  @override
  String get release_core_discovery_disabled => '無効';

  @override
  String get release_core_discovery_none => 'なし';

  @override
  String release_core_discovery_roots(String paths) {
    return 'スキャンのルート: $paths';
  }

  @override
  String release_core_discovery_excluded(String paths) {
    return '除外するサブツリー: $paths';
  }

  @override
  String release_core_discovery_repository_sessions(String path, int count) {
    return '$path\nセッション: $count';
  }

  @override
  String get release_core_projects_local_only =>
      'このHermesゲートウェイはサーバーサイドプロジェクトより古いため、チャットのグループ化はこの端末内のみになります。端末間で同じプロジェクトを共有するにはHermesを更新してください。';

  @override
  String get release_core_fleet_no_address => 'ゲートウェイアドレスはまだありません';

  @override
  String release_core_fleet_diagnostics(String version, String access) {
    return 'ゲートウェイ $version · $access';
  }

  @override
  String get release_core_schedule_builtin => '組み込み';

  @override
  String get release_core_memory_gateway_profile => 'ゲートウェイ';

  @override
  String release_core_memory_profile_summary(String profile, String gateway) {
    return '$gateway上のプロファイル$profile。共有コードにはズーム、時刻、フィルターのみが保存されます。';
  }

  @override
  String release_core_memory_layers_summary(
    int memoryBytes,
    int userBytes,
    String provider,
  ) {
    return '組み込みメモリ$memoryBytesバイト、ユーザーメモリ$userBytesバイト。使用中のプロバイダー: $provider。';
  }

  @override
  String get release_core_memory_kind_all => 'すべて';

  @override
  String get release_core_memory_kind_skill => 'スキル';

  @override
  String get release_core_memory_kind_memory => 'メモリ';

  @override
  String get release_core_workspace_failure_stale => '接続が変更されました';

  @override
  String get release_core_workspace_failure_unbound => '確認済みの作業ディレクトリがありません';

  @override
  String get release_core_workspace_failure_denied => '権限がありません';

  @override
  String get release_core_workspace_failure_ineligible =>
      'このファイルでは許可されていない操作です';

  @override
  String get release_core_workspace_failure_unsupported => 'このゲートウェイでは対応していません';

  @override
  String get release_core_workspace_failure_mismatch => 'リモートの状態が変更されました';

  @override
  String get release_core_workspace_failure_invalid => 'ゲートウェイの応答が無効です';

  @override
  String get release_core_workspace_failure_insecure => '安全な接続が必要です';

  @override
  String get release_core_workspace_failure_unavailable => 'ゲートウェイを利用できません';

  @override
  String get release_core_queue_state_queued => 'キュー待機中';

  @override
  String get release_core_queue_state_started => '開始済み';

  @override
  String get release_core_queue_state_unknown => '結果不明';

  @override
  String get release_core_unknown_state => '不明';

  @override
  String get release_core_fleet_state_idle => 'オフライン';

  @override
  String get release_core_fleet_state_connected => '接続済み';

  @override
  String get release_core_fleet_state_reconnecting => '再接続中…';

  @override
  String get release_core_fleet_state_sessionExpired => 'サインアウト済み';

  @override
  String get release_core_fleet_state_failed => '接続に失敗しました';

  @override
  String release_core_workspace_operation_failed(String reason) {
    return 'ゲートウェイでの操作を確認できませんでした: $reason。';
  }

  @override
  String get release_core_workspace_invalid_data =>
      'データまたは入力内容を確認できませんでした。内容を確認して、もう一度お試しください。';

  @override
  String
  get release_core_parallel_workspace_layout_changed_in_this_window_but_could_not =>
      'このウィンドウのレイアウトは変更されましたが、保存できませんでした。';

  @override
  String get release_core_parallel_workspace_first_pane => '1つ目のペイン';

  @override
  String get release_core_parallel_workspace_second_pane => '2つ目のペイン';

  @override
  String get release_core_parallel_workspace_unavailable_page => '利用できないページ';

  @override
  String release_core_parallel_workspace_close_a_tab_first_maximum(
    String maximum,
  ) {
    return '先にタブを閉じてください（最大$maximum個）。';
  }

  @override
  String get release_core_parallel_workspace_dock_beside_current_pane =>
      '現在のペインの隣にドッキング';

  @override
  String get release_core_parallel_workspace_add_chat => 'チャットを追加';

  @override
  String
  get release_core_parallel_workspace_action_failed_check_the_connection_and_try_again =>
      '操作に失敗しました。接続を確認して、もう一度お試しください。';

  @override
  String
  get release_core_parallel_workspace_close_a_tab_before_reopening_another =>
      '別のタブを開き直す前に、タブを1つ閉じてください。';

  @override
  String release_core_parallel_workspace_replace_layout(String name) {
    return 'レイアウト「$name」を置き換えますか？';
  }

  @override
  String
  get release_core_parallel_workspace_layout_limit_reached_replace_an_existing_layout =>
      'レイアウト数の上限に達しました。既存のレイアウトを置き換えてください。';

  @override
  String get release_core_parallel_workspace_restore_layout => 'レイアウトを復元';

  @override
  String get release_core_parallel_workspace_workspace_options =>
      'ワークスペースのオプション';

  @override
  String get release_core_parallel_workspace_dock_another_pane => '別のペインをドッキング';

  @override
  String get release_core_parallel_workspace_swap_panes => 'ペインを入れ替え';

  @override
  String get release_core_parallel_workspace_undock_second_pane =>
      '2つ目のペインのドッキングを解除';

  @override
  String get release_core_parallel_workspace_arrange_side_by_side => '左右に並べる';

  @override
  String get release_core_parallel_workspace_arrange_top_to_bottom => '上下に並べる';

  @override
  String release_core_parallel_workspace_change_split_size(String percent) {
    return '分割サイズを変更（$percent%）';
  }

  @override
  String get release_core_parallel_workspace_focus_pane_full_screen =>
      'ペインを全画面表示';

  @override
  String get release_core_parallel_workspace_open_chat_in_new_window =>
      '新しいウィンドウでチャットを開く';

  @override
  String get release_core_parallel_workspace_hide_pane_keep_running =>
      'ペインを非表示（実行は継続）';

  @override
  String get release_core_parallel_workspace_previous_tab => '前のタブ';

  @override
  String get release_core_parallel_workspace_next_tab => '次のタブ';

  @override
  String get release_core_parallel_workspace_move_tab_left => 'タブを左に移動';

  @override
  String get release_core_parallel_workspace_move_tab_right => 'タブを右に移動';

  @override
  String get release_core_parallel_workspace_reload_current_tab =>
      '現在のタブを再読み込み';

  @override
  String get release_core_parallel_workspace_close_tab => 'タブを閉じる';

  @override
  String get release_core_parallel_workspace_close_other_tabs => '他のタブを閉じる';

  @override
  String get release_core_parallel_workspace_close_tabs_to_the_right =>
      '右側のタブを閉じる';

  @override
  String get release_core_parallel_workspace_close_all_tabs => 'すべてのタブを閉じる';

  @override
  String get release_core_parallel_workspace_reopen_closed_tab => '閉じたタブを開き直す';

  @override
  String get release_core_parallel_workspace_save_named_layout =>
      '名前を付けてレイアウトを保存';

  @override
  String get release_core_parallel_workspace_restore_named_layout =>
      '名前付きレイアウトを復元';

  @override
  String get release_core_parallel_workspace_refresh_chat_list => 'チャット一覧を更新';

  @override
  String get release_core_parallel_workspace_workspace_tools => 'ワークスペースのツール';

  @override
  String get release_core_parallel_workspace_choose_a_chat_for_this_pane =>
      'このペインのチャットを選択';

  @override
  String release_core_parallel_workspace_choose_chat_for(String pane) {
    return '$paneのチャットを選択';
  }

  @override
  String get release_core_parallel_workspace_add_a_chat_to_start_a_workspace =>
      'チャットを追加してワークスペースを開始してください。';

  @override
  String get release_core_parallel_workspace_select_a_tab_to_show_its_pane =>
      'タブを選択すると、そのペインが表示されます。';

  @override
  String get release_core_parallel_workspace_parallel_workspace => '並列ワークスペース';

  @override
  String get release_core_parallel_workspace_show_workspace => 'ワークスペースを表示';

  @override
  String get release_core_parallel_workspace_could_not_load_chats_retry =>
      'チャットを読み込めませんでした。再試行';

  @override
  String release_core_parallel_workspace_close(String pane) {
    return '$paneを閉じる';
  }

  @override
  String release_core_parallel_workspace_switch_pane(String pane) {
    return 'ペインを切り替え: $pane';
  }

  @override
  String get release_core_workspace_registry_session_id_copied =>
      'セッションIDをコピーしました。';

  @override
  String get release_core_workspace_registry_chat_details => 'チャットの詳細';

  @override
  String get release_core_workspace_registry_server_default => 'サーバーのデフォルト';

  @override
  String get release_core_workspace_registry_session_id => 'セッションID';

  @override
  String get release_core_workspace_registry_title => 'タイトル';

  @override
  String get release_core_workspace_label_terminals => 'ターミナル';

  @override
  String get release_core_workspace_label_copy_id => 'セッションIDをコピー';

  @override
  String get release_core_workspace_label_contributions => 'コントリビューション';

  @override
  String get release_core_workspace_owner_inactive =>
      'このワークスペースの所有者はアクティブではなくなりました。';

  @override
  String get release_core_workspace_select_chat => '先にチャットを選択してください。';

  @override
  String get release_core_workspace_chat_unavailable => 'この接続ではこのチャットを利用できません。';

  @override
  String get release_core_workspace_page_unavailable => 'この接続ではこのページを利用できません。';

  @override
  String release_core_client_queue_count(int count) {
    return '$count件がキュー待機中';
  }

  @override
  String release_core_client_queue_paused_count(int count) {
    return '$count件がキュー待機中 — 一時停止中';
  }

  @override
  String release_core_git_diff_truncated(String diff) {
    return '$diff\n…省略';
  }

  @override
  String get release_core_search_no_models =>
      'Hermesから設定済みの選択可能なモデルが返されませんでした。';

  @override
  String get release_core_chat_archive_unavailable => 'チャットのアーカイブ操作を利用できません。';

  @override
  String get release_core_chat_pin_unconfirmed => 'ピン留めの状態を確認できませんでした。';

  @override
  String get release_core_chat_archive_unconfirmed => 'アーカイブの状態を確認できませんでした。';

  @override
  String get release_core_chat_archive_history_unavailable =>
      'アーカイブ済みの履歴を利用できません';

  @override
  String get release_core_quick_chat_history_unavailable =>
      'クイックチャットの履歴を利用できません';

  @override
  String get release_core_chat_project_ownership_unavailable =>
      'プロジェクトの所有情報を利用できません';

  @override
  String get release_core_chat_unknown_project => '不明なプロジェクト';

  @override
  String get release_core_chat_local_search_fallback =>
      'メッセージ検索を利用できません。ローカルの一致結果を表示しています。';

  @override
  String release_core_fleet_update_eligible(String version) {
    return '更新対象 · $version';
  }

  @override
  String get release_core_fleet_update_state_1 => 'スキップ: 同一のインストール先';

  @override
  String get release_core_fleet_update_state_2 => '未確認';

  @override
  String get release_core_fleet_update_state_3 => 'スキップ: クラウド管理';

  @override
  String get release_core_fleet_update_state_4 => 'スキップ: 直接接続のゲートウェイとして未登録';

  @override
  String get release_core_fleet_update_state_5 => 'スキップ: 切断中または処理中';

  @override
  String get release_core_fleet_update_state_6 => '適用可能な更新はありません';

  @override
  String get release_core_fleet_update_state_7 => '更新対象か確認できませんでした';

  @override
  String get release_core_fleet_update_state_8 => 'スキップ: 情報が古い、処理中、またはリクエスト済み';

  @override
  String get release_core_fleet_update_state_9 => 'リクエスト中';

  @override
  String get release_core_fleet_update_state_10 => '受理済み。実施記録を取得できません';

  @override
  String get release_core_fleet_update_state_11 => '受理済み。実施記録を待機中';

  @override
  String get release_core_fleet_update_state_12 => 'スキップ: このインストール先でチャットが実行中';

  @override
  String get release_core_fleet_update_state_13 => '未確認。自動で再送信しないでください';

  @override
  String get release_core_fleet_update_state_14 => '実施記録を確認するには再接続してください';

  @override
  String get release_core_fleet_update_state_15 => '実施記録を取得できません';

  @override
  String get release_core_fleet_update_state_16 => '一致する実施記録を待機中';

  @override
  String get release_core_fleet_update_state_17 => '更新済み。追加対応が必要です';

  @override
  String get release_core_fleet_update_state_19 => '一部更新済み';

  @override
  String get release_core_fleet_update_state_20 => '更新に失敗しました';

  @override
  String get release_core_fleet_update_state_21 => '未確認';

  @override
  String get release_core_cloud_status_ready => '準備完了';

  @override
  String get release_core_cloud_status_online => 'オンライン';

  @override
  String get release_core_cloud_status_stopped => '停止済み';

  @override
  String get release_core_cloud_status_error => 'エラー';

  @override
  String get ng_release_more_contributions_subtitle => 'この接続の確認済み応答カード';

  @override
  String get ng_release_more_gateway_fleet => 'ゲートウェイフリート';

  @override
  String get ng_release_more_memory_graph => 'メモリグラフ';

  @override
  String get ng_release_more_memory_graph_subtitle => 'タイムライン、編集、メモリプロバイダー';

  @override
  String get ng_release_more_capabilities_subtitle =>
      'スキル、プラグイン、コネクター、ツールバックエンドのインストールと管理';

  @override
  String get ng_release_more_browser_vault => 'ブラウザー保管庫';

  @override
  String get ng_release_more_browser_vault_subtitle =>
      'サイトのログイン情報、住所、カード、認証情報の取得元';

  @override
  String get ng_release_more_agent_policy => 'エージェントのポリシー';

  @override
  String get ng_release_more_agent_policy_subtitle =>
      '承認、チェックポイント、ブラウザーへのアクセス、共有メトリクス';

  @override
  String get ng_release_more_schedules => 'スケジュール';

  @override
  String get ng_release_more_schedules_subtitle =>
      'すべてのプロファイル、ブループリント、未実行分の実行、停止';

  @override
  String get ng_release_more_host_subtitle => 'リモートログ、稼働状況、メンテナンス、更新';

  @override
  String get ng_release_more_providers_routes => 'プロバイダーとルート';

  @override
  String get ng_release_more_providers_routes_subtitle =>
      'キー、エンドポイント、委任、モデルの組み合わせ';

  @override
  String get ng_release_more_credits_plans => 'クレジットとプラン';

  @override
  String get ng_release_more_credits_plans_subtitle =>
      'アカウントで許可されている場合の、同意に基づくNousの課金';

  @override
  String get ng_release_sign_in_or => 'または';

  @override
  String ng_release_deployment_sign_in_hint(String message) {
    return '$message 次のステップでデプロイメントセッショントークンを使ってサインインすることもできます。';
  }

  @override
  String get ng_release_message_search_unavailable =>
      'メッセージ検索を利用できません。ローカルの一致結果を表示しています。';

  @override
  String ng_release_insights_days(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days日',
      one: '$days日',
    );
    return '$_temp0';
  }

  @override
  String get ng_release_signed_in_you => 'あなた';

  @override
  String get release_chat_unsent_prompt_gone => 'その未送信プロンプトはキューにありません。';

  @override
  String ng_release_attachment_not_attached(String name) {
    return 'ゲートウェイが$nameの添付を確認しませんでした。';
  }

  @override
  String get ng_release_gateway_not_connected => 'まだゲートウェイに接続していません。';

  @override
  String get ng_release_gateway_unreachable => 'ゲートウェイに接続できませんでした。';

  @override
  String get ng_release_projects_scope_changed => 'プロジェクトの対象範囲は選択されていません';

  @override
  String get ng_release_missing_providers => 'プロバイダーがありません';

  @override
  String get ng_release_missing_tasks => 'タスクがありません';

  @override
  String ng_release_age_minutes(int count) {
    return '$count分';
  }

  @override
  String ng_release_age_hours(int count) {
    return '$count時間';
  }

  @override
  String ng_release_age_days(int count) {
    return '$count日';
  }

  @override
  String ng_release_age_weeks(int count) {
    return '$count週';
  }

  @override
  String ng_release_age_years(int count) {
    return '$count年';
  }

  @override
  String ng_release_compact_billions(String count) {
    return '$count十億';
  }

  @override
  String ng_release_compact_millions(String count) {
    return '$count百万';
  }

  @override
  String ng_release_compact_thousands(String count) {
    return '$count千';
  }

  @override
  String ng_release_token_thousands(String count) {
    return '$count千';
  }

  @override
  String ng_release_elapsed_minutes_seconds(int minutes, int seconds) {
    return '$minutes分$seconds秒';
  }

  @override
  String ng_release_elapsed_seconds(int seconds) {
    return '$seconds秒';
  }

  @override
  String get ng_release_notification_foreground => 'Aresを画面に表示していました';

  @override
  String get ng_release_notification_stopped => 'ターンが停止されました';

  @override
  String get ng_release_more_parallel_workspace => '並列ワークスペース';

  @override
  String get ng_release_more_parallel_workspace_subtitle =>
      '複数のチャットをタブや横並びで開きます。';

  @override
  String get release_chat_unknown_model => '不明';

  @override
  String release_chat_profile_default(String model) {
    return 'プロファイルのデフォルト: $model';
  }

  @override
  String release_chat_profile_default_provider(String model, String provider) {
    return 'プロファイルのデフォルト: $model • $provider';
  }

  @override
  String get release_chat_choose_provider =>
      'このモデルは複数のプロバイダーで利用できます。続行するにはプロバイダーを選択してください。';

  @override
  String get release_chat_slash_needs_gateway =>
      'スラッシュコマンドにはDesktopゲートウェイが必要です';

  @override
  String get release_chat_recovering_without_resending => '再送信せずに復旧中';

  @override
  String get release_chat_live_request_unreachable =>
      '申し訳ありません。そのリクエストではHermesに接続できませんでした。';

  @override
  String release_chat_live_working(String tool) {
    return 'Hermesが処理中です: $tool。まだ完了していません。';
  }

  @override
  String get release_chat_live_finished_without_spoken_result =>
      'Hermesがそのリクエストを完了しましたが、音声の応答はありませんでした。';

  @override
  String get release_chat_reply_language_unavailable => '選択した応答言語を利用できません';

  @override
  String get release_chat_reply_voice_unavailable => '選択した応答の音声を利用できません';

  @override
  String get release_chat_reply_voice_configuration_unavailable =>
      '応答の音声設定を利用できません';

  @override
  String get release_chat_notification_review_action =>
      'チャットを開いて、リクエストされた操作を確認してください。';

  @override
  String get release_chat_notification_respond => 'チャットを開いて応答してください。';

  @override
  String get release_chat_start_new_main_window => 'メインウィンドウで新しいチャットを開始してください。';

  @override
  String get release_chat_no_desktop_gateway => 'Desktopゲートウェイがありません';

  @override
  String get release_chat_attachment_preparation_cancelled =>
      '添付ファイルの準備がキャンセルされました。';

  @override
  String get release_chat_approval_authority_revoked => '承認権限が取り消されました。';

  @override
  String get release_chat_gateway_session_disconnected =>
      'Desktopゲートウェイのセッションは接続されていません';

  @override
  String get release_chat_stop_requested => '停止をリクエストしました。Hermesの終了を待っています。';

  @override
  String release_chat_stop_request_failed(String error) {
    return '停止をリクエストできませんでした: $error';
  }

  @override
  String get release_chat_queued_prompt_not_sent => 'キュー内のプロンプトは送信されませんでした。';

  @override
  String get release_chat_running_turn_unreachable =>
      '実行中のターンに接続できませんでした。再送信せずに再接続しています。';

  @override
  String get release_chat_wait_for_composer => '入力欄が使用可能になるまでお待ちください。';

  @override
  String get release_chat_find_in_transcript => '会話履歴内を検索';

  @override
  String get release_chat_open_browser_preview => 'ブラウザープレビューを開く';

  @override
  String get release_chat_more_tools => 'その他のチャットツール';

  @override
  String get release_chat_queue_until_finished => 'このターンが終了するまでキューで待機';

  @override
  String get release_chat_format_bold => '太字';

  @override
  String get release_chat_format_italic => '斜体';

  @override
  String get ng_release_chat_gateway_queue_requirements =>
      'ゲートウェイのキューには、接続済みのチャットとテキストのみのプロンプトが必要です。';

  @override
  String get ng_release_chat_start_new_main_screen =>
      'メインのチャット画面から新しいチャットを開始してください。';

  @override
  String get ng_release_chat_image => '画像';

  @override
  String ng_release_chat_tool_seconds(String seconds) {
    return '$seconds秒';
  }

  @override
  String get release_preview_chat_changed =>
      'チャットが変更されました。続行するにはプレビューに再接続してください。';

  @override
  String get release_preview_authenticating_chat => 'チャットを認証中…';

  @override
  String release_preview_unavailable_reason(String reason) {
    return 'プレビューを利用できません: $reason';
  }

  @override
  String get release_preview_operation_failed => 'プレビューの操作に失敗しました。';

  @override
  String get release_preview_added_to_draft => '下書きに追加しました。送信はしていません。';

  @override
  String get release_preview_open_site_title => 'このサイトを開きますか？';

  @override
  String release_preview_open_site_body(String origin) {
    return '$origin\n\nリーダーモードでは、このドキュメントのみを読み込みます。Cookie、サインイン情報、ページをHermesと共有しません。';
  }

  @override
  String get release_preview_open_site => 'サイトを開く';

  @override
  String get release_preview_discard_pins_title => '下書きに追加していないピンを破棄しますか？';

  @override
  String get release_preview_keep_pins => 'ピンを保持';

  @override
  String get release_preview_share_page_title => 'このページをこのチャットと共有しますか？';

  @override
  String release_preview_share_page_body(String origin) {
    return 'Hermesは$originの表示中のテキストと要素一覧を読み取り、このペインをスクロールできます。別のページへの移動で共有は終了します。フォームと認証情報は共有されません。';
  }

  @override
  String get release_preview_share_page => 'ページを共有';

  @override
  String release_preview_comment_number(int number) {
    return 'コメント #$number';
  }

  @override
  String get release_preview_note => 'メモ';

  @override
  String get release_preview_keep_pin => 'ピンを保持';

  @override
  String get release_preview_title => 'ブラウザープレビュー';

  @override
  String get release_preview_hide => 'プレビューを非表示';

  @override
  String get release_preview_close_and_forget => '閉じてページを破棄';

  @override
  String get release_preview_site_address => 'サイトのアドレス';

  @override
  String get release_preview_go_to_address => 'アドレスに移動';

  @override
  String get release_preview_forward => '進む';

  @override
  String get release_preview_reload => '再読み込み';

  @override
  String get release_preview_share_with_hermes => 'ページをHermesと共有';

  @override
  String get release_preview_stop_sharing => 'ページの共有を停止';

  @override
  String get release_preview_annotate => '要素または領域に注釈を追加';

  @override
  String get release_preview_reader_console => 'リーダーコンソール';

  @override
  String get release_preview_reconnect => 'プレビューに再接続';

  @override
  String get release_preview_reader_mode_help =>
      'リーダーモード: HTMLとテキストのみ。スクリプト、埋め込みリソース、サインイン済みのブラウザープロファイルは使用しません。';

  @override
  String release_preview_sharing_origin(String origin) {
    return 'このチャットとリーダーを共有中: $origin';
  }

  @override
  String get release_preview_annotation_help =>
      '要素をタップするか領域をドラッグして、コメントを追加してください。';

  @override
  String get release_preview_reader_requests => 'リーダーのリクエスト（JavaScriptは無効）';

  @override
  String release_preview_selected_requests(int count) {
    return '$count件を選択中 · JavaScriptは無効';
  }

  @override
  String get release_preview_copy_all => 'すべてコピー';

  @override
  String get release_preview_copy_selected => '選択項目をコピー';

  @override
  String get release_preview_add_log_to_draft => 'ログを下書きに追加';

  @override
  String release_preview_requests_draft(String log) {
    return 'リーダーのリクエスト:\n$log';
  }

  @override
  String release_preview_add_pins_to_draft(int count) {
    return '$count件を下書きに追加';
  }

  @override
  String release_preview_request_loaded(String origin, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'リーダーの要素$count件',
      one: 'リーダーの要素$count件',
    );
    return 'HTTP 200 · $origin · $_temp0';
  }

  @override
  String release_preview_annotation_intro(String origin) {
    return '$originのプレビューに付けられたこれらのコメントを確認してください。添付の切り抜き画像には、同じ順序で番号が付いています。';
  }

  @override
  String get release_preview_reader_region => 'リーダーの領域';

  @override
  String get release_preview_capture_failed => 'この範囲の画像をキャプチャできませんでした。';

  @override
  String get release_preview_address_not_approved =>
      'このアドレスは、承認済みのプレビューのオリジン外です。';

  @override
  String get release_preview_page_limit => 'ページがリーダーの上限を超えています。';

  @override
  String get release_preview_page_unreadable => 'ページを読み取れませんでした。';

  @override
  String get release_preview_page_complex => 'このページは複雑すぎるため、リーダーモードで処理できません。';

  @override
  String release_preview_http_failed(int statusCode) {
    return 'HTTP $statusCode。リダイレクト先への移動やサインインは行っていません。';
  }

  @override
  String get release_preview_unsupported_type =>
      'リーダーモードで開けるのはHTMLとプレーンテキストのみです。';

  @override
  String get release_preview_load_insecure => 'サイトを安全に読み込めませんでした。';

  @override
  String get release_preview_crop_limit => 'プレビューの切り抜き画像が上限を超えています。';

  @override
  String get release_preview_image_unreadable => '選択した画像は空か、読み取れません。';

  @override
  String get release_preview_image_budget => '選択した画像は下書きの上限である64 MiBを超えています。';

  @override
  String get release_preview_image_format =>
      '対応していない画像形式です。JPEG、PNG、WebPのいずれかを選択してください。';

  @override
  String get release_preview_image_decode =>
      '選択したJPEG、PNG、WebP画像を安全にデコードできませんでした。';

  @override
  String get release_preview_image_sanitize =>
      'この画像を無害化できません。有効なJPEG、PNG、WebP画像を選択してください。';

  @override
  String get release_preview_draft_budget => '添付ファイルは下書きごとに合計64 MiBまでです。';

  @override
  String get release_preview_generic_file_limit => '一般ファイルは1つにつき16 MiBまでです。';

  @override
  String get release_preview_image_not_sanitized =>
      'リモート画像はアップロード前に無害化する必要があります。';

  @override
  String get release_preview_stage_failed =>
      'プレビューの資料を下書きに追加できませんでした。もう一度お試しください。';

  @override
  String get release_misc_find_hermes_on_lan => 'LAN上のHermesを検索';

  @override
  String release_misc_discovery_failed(String error) {
    return '検出に失敗しました: $error';
  }

  @override
  String get release_misc_no_lan_servers =>
      'ローカルネットワーク上にHermesサーバーが見つかりませんでした。';

  @override
  String release_misc_api_key_rejected(String endpoint, int statusCode) {
    return '$endpointがAPIキーを拒否しました（HTTP $statusCode）。';
  }

  @override
  String get release_misc_api_key_required =>
      'サーバーにはAPIキーが必要です。API_SERVER_KEYを入力してください。';

  @override
  String release_misc_gateway_not_found(String endpoint) {
    return 'ゲートウェイのエンドポイント$endpointからHTTP 404が返されました。ゲートウェイのパスプレフィックスとリバースプロキシのルートを確認してください。';
  }

  @override
  String release_misc_gateway_http_error(String endpoint, int statusCode) {
    return 'ゲートウェイのエンドポイント$endpointからHTTP $statusCodeが返されました。';
  }

  @override
  String release_misc_gateway_unreachable(String endpoint) {
    return 'ゲートウェイのエンドポイント$endpointに接続できません。';
  }

  @override
  String get release_core_schedule_invalid_delivery_target => '配信先が無効です';

  @override
  String get release_core_file_save_direct_only => '作業ディレクトリ直下のファイルのみ保存できます。';

  @override
  String get release_core_file_save_hidden => 'ゲートウェイでは隠しファイルを保存できません。';

  @override
  String get rel_admin_choose_provider => 'プロバイダーとモデルを選択してください。';

  @override
  String get rel_admin_known_effort => '既知の思考レベルを選択してください。';

  @override
  String get rel_admin_endpoint_name_required => 'このエンドポイントの名前を入力してください。';

  @override
  String get rel_admin_endpoint_model_required => 'このエンドポイントが提供するモデルを入力してください。';

  @override
  String get rel_admin_known_api_mode => '自動または既知のAPIモードを選択してください。';

  @override
  String get rel_admin_endpoint_id_invalid => 'このエンドポイント識別子は使用できません。';

  @override
  String get rel_admin_endpoint_https =>
      'リモートエンドポイントにはHTTPS、localhostにはHTTPを使用してください。';

  @override
  String get rel_admin_key_invalid => 'そのAPIキーは保存できません。';

  @override
  String get rel_admin_response_shape => 'ゲートウェイの応答が想定された形式と一致しませんでした。';

  @override
  String get rel_admin_limits_required =>
      '保存する前に反復回数、同時実行数、タイムアウトの上限を入力してください。';

  @override
  String get rel_admin_route_required => '保存するには各ルートに名前とモデルが必要です。';

  @override
  String get rel_admin_route_unique => 'ルート名は一意である必要があります。';

  @override
  String get rel_admin_route_default_invalid => 'デフォルトルートは保存済みのルートである必要があります。';

  @override
  String get rel_admin_policy_required =>
      '参照モデルの機能低下時のポリシーとして通知ありまたはサイレントを選択してください。';

  @override
  String get rel_admin_mixture_missing => 'ゲートウェイから有効な混合構成が返されませんでした。';

  @override
  String get rel_admin_mixture_slots_required =>
      '集約モデルとすべての参照モデルのプロバイダーとモデルを指定してください。';

  @override
  String get rel_admin_chat_id_required => 'この変更を適用するチャットIDを入力してください。';

  @override
  String rel_admin_http_error(String status) {
    return 'ゲートウェイがHTTP $statusを返しました。';
  }

  @override
  String get rel_admin_response_unreadable => 'ゲートウェイの応答を読み取れませんでした。';

  @override
  String get rel_admin_connect_before_change =>
      '請求またはチャットを変更する前に、ゲートウェイのライブセッションに接続してください。';

  @override
  String get rel_admin_operation_unavailable => 'このゲートウェイはその操作に対応していません。';

  @override
  String get rel_admin_key_required => '保存するキーを入力してください。';

  @override
  String get rel_admin_key_save_failed => 'ゲートウェイはそのキーを保存しませんでした。';

  @override
  String get rel_admin_key_clear_required => '削除するプロバイダーキーを選択してください。';

  @override
  String get rel_admin_key_clear_failed => 'ゲートウェイはそのキーを削除しませんでした。';

  @override
  String get rel_admin_endpoint_save_failed => 'ゲートウェイはそのエンドポイントを保存しませんでした。';

  @override
  String get rel_admin_endpoint_activate_failed =>
      'ゲートウェイはそのエンドポイントを有効にしませんでした。';

  @override
  String get rel_admin_accounts_secure_required =>
      'プロバイダーアカウントには認証済みのHTTPSゲートウェイまたはlocalhostが必要です。';

  @override
  String get rel_admin_accounts_read_failed => 'プロバイダーアカウントを読み取れませんでした。';

  @override
  String get rel_admin_account_disconnect_failed => 'ゲートウェイはそのアカウントを切断しませんでした。';

  @override
  String get rel_admin_account_not_disconnectable => 'そのプロバイダーアカウントは切断できません。';

  @override
  String get rel_admin_backend_required => '利用可能な委任バックエンドを選択してください。';

  @override
  String get rel_admin_backend_save_failed => 'ゲートウェイはそのバックエンドを選択しませんでした。';

  @override
  String get rel_admin_routes_save_failed => 'ゲートウェイはそれらのルートを保存しませんでした。';

  @override
  String get rel_admin_profile_route_required => '各プロファイルルートにはプロファイル名が必要です。';

  @override
  String get rel_admin_profile_route_unique => 'プロファイルルートは一意である必要があります。';

  @override
  String get rel_admin_profile_route_default_invalid =>
      'デフォルトのプロファイルルートは許可されたプロファイルのいずれかである必要があります。';

  @override
  String get rel_admin_profile_routes_save_failed =>
      'ゲートウェイはそれらのプロファイルルートを保存しませんでした。';

  @override
  String get rel_admin_limits_save_failed => 'ゲートウェイはそれらの上限を保存しませんでした。';

  @override
  String get rel_admin_mixture_save_failed => 'ゲートウェイはその混合構成を保存しませんでした。';

  @override
  String get rel_admin_credit_amount_required => '提示されたクレジット金額から選択してください。';

  @override
  String get rel_admin_charge_check_failed => 'その請求を確認できませんでした。';

  @override
  String get rel_admin_reload_amounts_missing =>
      '自動チャージ金額が指定されていないため、変更されませんでした。';

  @override
  String get rel_admin_plan_required => '先にプランを選択してください。';

  @override
  String get rel_admin_plan_scheduled_only => 'ここでは予定されたプラン変更のみ確認できます。';

  @override
  String get rel_admin_billing_refused => 'ゲートウェイがこの請求リクエストを拒否しました。';

  @override
  String get rel_admin_request_refused => 'ゲートウェイがこのリクエストを拒否しました。';

  @override
  String get rel_admin_endpoint_answered => 'エンドポイントが応答しました。';

  @override
  String get rel_admin_endpoint_no_answer => 'エンドポイントが応答しませんでした。';

  @override
  String get rel_admin_charge_unknown =>
      '請求結果が不明です。まだ決済される可能性があります。再試行する前にポータルを確認してください。';

  @override
  String get rel_admin_connect_before_billing =>
      '請求情報を確認する前に、ゲートウェイのライブセッションに接続してください。このページからは請求されません。';

  @override
  String get rel_admin_preset_required => '適用する前にプリセットを保存してください。';

  @override
  String get rel_admin_cancel => 'キャンセル';

  @override
  String get rel_admin_refresh => '更新';

  @override
  String get rel_admin_credits_and_plans => 'クレジットとプラン';

  @override
  String get rel_admin_saved => '保存しました';

  @override
  String get rel_admin_name => '名前';

  @override
  String get rel_admin_base_url => 'ベースURL';

  @override
  String get rel_admin_model => 'モデル';

  @override
  String get rel_admin_signed_in => 'サインイン済み';

  @override
  String get rel_admin_not_signed_in => '未ログイン';

  @override
  String get rel_admin_provider => 'プロバイダー';

  @override
  String get rel_admin_apply_to_this_chat => 'このチャットに適用';

  @override
  String get rel_admin_auto => '自動';

  @override
  String get rel_admin_chat_completions => 'チャット補完';

  @override
  String get rel_admin_codex_responses => 'Codexレスポンス';

  @override
  String get rel_admin_anthropic_messages => 'Anthropicメッセージ';

  @override
  String get rel_admin_could_not_complete_that_request => 'そのリクエストを完了できませんでした。';

  @override
  String get rel_admin_confirm => '確認';

  @override
  String get rel_admin_providers_and_billing => 'プロバイダーと請求';

  @override
  String get rel_admin_api_keys => 'APIキー';

  @override
  String get rel_admin_custom_endpoints => 'カスタムエンドポイント';

  @override
  String get rel_admin_provider_accounts => 'プロバイダーアカウント';

  @override
  String get rel_admin_effort_and_speed_presets => '思考レベルと速度のプリセット';

  @override
  String get rel_admin_delegation => '委任';

  @override
  String get rel_admin_mixture_of_agents => 'エージェント混合';

  @override
  String get rel_admin_no_provider_keys_were_reported_for_this_profile =>
      'このプロファイルのプロバイダーキーは報告されていません。';

  @override
  String get rel_admin_not_saved => '未保存';

  @override
  String get rel_admin_new_key_value => '新しいキーの値';

  @override
  String get rel_admin_provider_key_saved => 'プロバイダーキーを保存しました。';

  @override
  String get rel_admin_save_key => 'キーを保存';

  @override
  String get rel_admin_clear_provider_key => 'プロバイダーキーを削除';

  @override
  String get rel_admin_provider_key_cleared => 'プロバイダーキーを削除しました。';

  @override
  String get rel_admin_clear_key => 'キーを削除';

  @override
  String get rel_admin_new_endpoint => '新しいエンドポイント';

  @override
  String get rel_admin_api_key => 'APIキー';

  @override
  String get rel_admin_leave_blank_to_keep_a_key_this_endpoint_already_has =>
      'このエンドポイントの既存のキーを保持するには空欄にしてください。';

  @override
  String get rel_admin_reachable => '到達可能';

  @override
  String get rel_admin_unreachable => '到達不可';

  @override
  String get rel_admin_test_endpoint => 'エンドポイントをテスト';

  @override
  String get rel_admin_endpoint_saved => 'エンドポイントを保存しました。';

  @override
  String get rel_admin_save_endpoint => 'エンドポイントを保存';

  @override
  String get rel_admin_use_this_endpoint => 'このエンドポイントを使用';

  @override
  String
  get rel_admin_make_this_named_endpoint_the_current_model_for_this_profile =>
      'この名前付きエンドポイントをこのプロファイルの現在のモデルにしますか？';

  @override
  String get rel_admin_endpoint_is_now_current => 'このエンドポイントが現在の設定になりました。';

  @override
  String get rel_admin_use_endpoint => 'エンドポイントを使用';

  @override
  String get rel_admin_delete_endpoint => 'エンドポイントを削除';

  @override
  String get rel_admin_delete_this_named_endpoint_from_the_profile =>
      'この名前付きエンドポイントをプロファイルから削除しますか？';

  @override
  String get rel_admin_endpoint_deleted => 'エンドポイントを削除しました。';

  @override
  String get rel_admin_signing_in_stays_on_the_provider_sign_in_screen =>
      'サインインはプロバイダーのサインイン画面で行います。このゲートウェイがアカウントを削除できると示した場合のみ切断されます。';

  @override
  String get rel_admin_disconnect_this_provider_account_on_the_gateway =>
      'ゲートウェイでこのプロバイダーアカウントを切断しますか？';

  @override
  String get rel_admin_provider_account_disconnected => 'プロバイダーアカウントを切断しました。';

  @override
  String get rel_admin_disconnect => '切断';

  @override
  String get rel_admin_not_disconnectable => '切断不可';

  @override
  String get rel_admin_fast => '高速';

  @override
  String get rel_admin_preset_saved_for_this_model => 'このモデルのプリセットを保存しました。';

  @override
  String get rel_admin_save_preset => 'プリセットを保存';

  @override
  String get rel_admin_chat_id => 'チャットID';

  @override
  String get rel_admin_apply_preset => 'プリセットを適用';

  @override
  String get rel_admin_set_this_chat_s_effort_and_speed_from_the_saved_preset =>
      '保存済みプリセットからこのチャットの思考レベルと速度を設定しますか？';

  @override
  String get rel_admin_preset_applied_to_this_chat => 'このチャットにプリセットを適用しました。';

  @override
  String get rel_admin_this_route_sends_the_picked_effort_unchanged =>
      'このルートは選択された思考レベルを変更せずに送信します。';

  @override
  String get rel_admin_show_route_clamp => 'ルートの制限を表示';

  @override
  String get rel_admin_delegation_backend => '委任バックエンド';

  @override
  String get rel_admin_delegation_backend_saved => '委任バックエンドを保存しました。';

  @override
  String get rel_admin_save_backend => 'バックエンドを保存';

  @override
  String get rel_admin_max_iterations => '最大反復回数';

  @override
  String get rel_admin_max_concurrent_children => '最大同時子エージェント数';

  @override
  String get rel_admin_child_timeout_seconds => '子エージェントのタイムアウト秒数';

  @override
  String get rel_admin_delegation_effort_leave_unchanged => '委任の思考レベル、変更なし';

  @override
  String get rel_admin_delegation_limits_saved => '委任の上限を保存しました。';

  @override
  String get rel_admin_save_limits => '上限を保存';

  @override
  String get rel_admin_remove_route => 'ルートを削除';

  @override
  String get rel_admin_route_name => 'ルート名';

  @override
  String get rel_admin_route_provider => 'ルートのプロバイダー';

  @override
  String get rel_admin_route_model => 'ルートのモデル';

  @override
  String get rel_admin_route_effort_unchanged => 'ルートの思考レベル変更なし';

  @override
  String get rel_admin_add_route => 'ルートを追加';

  @override
  String get rel_admin_default_route => 'デフォルトルート';

  @override
  String get rel_admin_delegation_routes_saved => '委任ルートを保存しました。';

  @override
  String get rel_admin_save_routes => 'ルートを保存';

  @override
  String get rel_admin_profile_routes_saved => 'プロファイルルートを保存しました。';

  @override
  String get rel_admin_save_profile_routes => 'プロファイルルートを保存';

  @override
  String get rel_admin_no_mixture_is_loaded => '混合構成が読み込まれていません。';

  @override
  String get rel_admin_mixture_enabled => '混合構成を有効化';

  @override
  String get rel_admin_loud_degraded_references => '参照モデル低下時に通知';

  @override
  String get rel_admin_silent_degraded_references => '参照モデル低下時に通知しない';

  @override
  String get rel_admin_aggregator => '集約モデル';

  @override
  String get rel_admin_aggregator_provider => '集約モデルのプロバイダー';

  @override
  String get rel_admin_aggregator_model => '集約モデル';

  @override
  String get rel_admin_reference_provider => '参照モデルのプロバイダー';

  @override
  String get rel_admin_reference_model => '参照モデル';

  @override
  String get rel_admin_add_reference_model => '参照モデルを追加';

  @override
  String get rel_admin_mixture_saved => '混合構成を保存しました。';

  @override
  String get rel_admin_save_mixture => '混合構成を保存';

  @override
  String get rel_admin_credit_purchase_submitted => 'クレジット購入を送信しました。';

  @override
  String get rel_admin_credit_purchase_settled => 'クレジット購入の決済が完了しました。';

  @override
  String get rel_admin_credit_and_plan_changes_wait_for_confirmation_a_plan =>
      'クレジットとプランの変更は確認待ちになります。即時請求が発生するプランは表示されますが、ここでは確定されません。';

  @override
  String get rel_admin_buy_credits => 'クレジットを購入';

  @override
  String get rel_admin_retry_same_charge => '同じ請求を再試行';

  @override
  String get rel_admin_retry_the_same_credit_charge_this_does_not_start =>
      '同じクレジット請求を再試行します。2回目の購入は開始されません。';

  @override
  String get rel_admin_credit_purchases_are_not_available_for_this_account =>
      'このアカウントではクレジットを購入できません。';

  @override
  String get rel_admin_auto_reload => '自動チャージ';

  @override
  String get rel_admin_read_only_until_this_account_can_charge =>
      'このアカウントで請求が可能になるまでは読み取り専用です。';

  @override
  String get rel_admin_auto_reload_updated => '自動チャージを更新しました。';

  @override
  String get rel_admin_keep_going_on_credits => 'クレジットで続行';

  @override
  String get rel_admin_continue_on_credits_when_the_plan_window_is_used_up =>
      'プランの期間内の枠を使い切ったらクレジットで続行しますか？';

  @override
  String
  get rel_admin_stop_continuing_on_credits_when_the_plan_window_is_used_up =>
      'プランの期間内の枠を使い切った際にクレジットで続行するのをやめますか？';

  @override
  String get rel_admin_credit_continuation_updated => 'クレジットでの続行を更新しました。';

  @override
  String get rel_admin_this_plan_change_is_not_confirmed_from_ares =>
      'このプラン変更はAresから確定されません。';

  @override
  String get rel_admin_this_change_is_scheduled_confirm_to_apply_it =>
      'この変更は予定されています。適用するには確認してください。';

  @override
  String get rel_admin_preview_plan => 'プランをプレビュー';

  @override
  String get rel_admin_schedule_plan_change => 'プラン変更を予定';

  @override
  String get rel_admin_plan_change_scheduled => 'プラン変更を予定しました。';

  @override
  String get rel_admin_confirm_scheduled_plan_change => '予定されたプラン変更を確認';

  @override
  String rel_admin_remove_key_confirm(String key) {
    return 'このプロファイルから保存済みの$keyの値を削除しますか？';
  }

  @override
  String rel_admin_current_endpoint(String name) {
    return '$name · 現在';
  }

  @override
  String rel_admin_endpoint_result(
    String status,
    String transport,
    String count,
    String message,
  ) {
    return '$status · $transport · $countモデル。$message';
  }

  @override
  String rel_admin_disconnect_account(String name) {
    return '$nameを切断';
  }

  @override
  String rel_admin_delegation_blocked(String reason) {
    return '委任がブロックされています：$reason';
  }

  @override
  String rel_admin_backend_unavailable(String name) {
    return '$name · 利用不可';
  }

  @override
  String rel_admin_reference_number(String number) {
    return '参照 $number';
  }

  @override
  String rel_admin_reload_enable_confirm(String amount, String threshold) {
    return '自動チャージをオンにし、残高が$thresholdを下回ったときに$amountを請求しますか？';
  }

  @override
  String rel_admin_reload_disable_confirm(String amount, String threshold) {
    return '自動チャージをオフにしますか？現在は残高が$thresholdを下回ると$amountが請求されます。';
  }

  @override
  String get rel_admin_this_plan => 'このプラン';

  @override
  String rel_admin_plan_confirm(String name) {
    return '$nameを予定します。現在の期間の終了時に適用予定です。今は請求されません。';
  }

  @override
  String rel_admin_plan_confirm_price(String name, String price) {
    return '$nameを$priceで予定します。現在の期間の終了時に適用予定です。今は請求されません。';
  }

  @override
  String rel_admin_plan_confirm_when(String name, String when) {
    return '$nameを予定します。$whenに適用されます。今は請求されません。';
  }

  @override
  String rel_admin_plan_confirm_price_when(
    String name,
    String price,
    String when,
  ) {
    return '$nameを$priceで予定します。$whenに適用されます。今は請求されません。';
  }

  @override
  String rel_admin_balance(String amount) {
    return '残高 $amount';
  }

  @override
  String rel_admin_buy_confirm(String amount) {
    return 'このNousアカウントの支払い方法に\$$amountを請求します。実際のお金が使われます。';
  }

  @override
  String rel_admin_reload_portal(String url) {
    return 'ポータルで自動チャージを変更：$url';
  }

  @override
  String rel_admin_team_portal(String url) {
    return 'チームのサブスクリプションはポータルで変更します：$url';
  }

  @override
  String get rel_admin_effort_none => 'なし';

  @override
  String get rel_admin_effort_minimal => '最小';

  @override
  String get rel_admin_effort_low => '低';

  @override
  String get rel_admin_effort_medium => '中';

  @override
  String get rel_admin_effort_high => '高';

  @override
  String get rel_admin_effort_xhigh => '非常に高い';

  @override
  String get rel_admin_effort_max => '最大';

  @override
  String get rel_admin_effort_ultra => '超高';

  @override
  String get rel_admin_auto_lower => '自動';

  @override
  String get rel_admin_create => '作成';

  @override
  String get rel_admin_prompt => 'プロンプト';

  @override
  String get rel_admin_new_profile_id => '新しいプロファイルID';

  @override
  String get rel_admin_this_operation_is_unavailable_on_this_gateway =>
      'このゲートウェイではこの操作を利用できません。';

  @override
  String get rel_admin_access_denied_by_the_gateway => 'ゲートウェイによりアクセスが拒否されました。';

  @override
  String get rel_admin_connection_changed_reopen_profiles =>
      '接続が変更されました。プロファイルを開き直してください。';

  @override
  String
  get rel_admin_invalid_input_or_gateway_response_check_the_target_before =>
      '入力またはゲートウェイの応答が無効です。再試行する前に対象を確認してください。';

  @override
  String get rel_admin_could_not_verify_the_result_refresh_the_target_before =>
      '結果を確認できませんでした。再試行する前に対象を更新してください。';

  @override
  String get rel_admin_edit_soul_md => 'SOUL.mdを編集';

  @override
  String get rel_admin_persona => 'ペルソナ';

  @override
  String get rel_admin_persona_saved => 'ペルソナを保存しました。';

  @override
  String get rel_admin_not_set => '未設定';

  @override
  String get rel_admin_enabled => '有効';

  @override
  String get rel_admin_keys_to_remove_comma_separated => '削除するキー（カンマ区切り）';

  @override
  String get rel_admin_saved_and_applied_by_the_gateway => 'ゲートウェイで保存して適用しました。';

  @override
  String get rel_admin_saved_a_gateway_restart_may_be_required =>
      '保存しました。ゲートウェイの再起動が必要な場合があります。';

  @override
  String get rel_admin_create_signed_route => '署名付きルートを作成';

  @override
  String get rel_admin_route_id => 'ルートID';

  @override
  String get rel_admin_signature => '署名';

  @override
  String get rel_admin_events_comma_separated => 'イベント（カンマ区切り）';

  @override
  String get rel_admin_delivery_target => '配信先';

  @override
  String get rel_admin_skills_comma_separated => 'スキル（カンマ区切り）';

  @override
  String get rel_admin_delivery_mode => '配信モード';

  @override
  String get rel_admin_delivery_chat_id_optional => '配信先チャットID（任意）';

  @override
  String get rel_admin_hide_signing_secret => '署名シークレットを非表示';

  @override
  String get rel_admin_reveal_signing_secret => '署名シークレットを表示';

  @override
  String get rel_admin_edit_persona => 'ペルソナを編集';

  @override
  String get rel_admin_portable_profile_bundle => 'ポータブルプロファイルバンドル';

  @override
  String get rel_admin_clone_profile => 'プロファイルを複製';

  @override
  String get rel_admin_rename_display_label => '表示名を変更';

  @override
  String get rel_admin_rename_profile => 'プロファイル名を変更';

  @override
  String get rel_admin_new_name => '新しい名前';

  @override
  String get rel_admin_rename_verified => '名前の変更を確認しました。';

  @override
  String get rel_admin_delete_profile => 'プロファイルを削除';

  @override
  String get rel_admin_profile_id_to_delete => '削除するプロファイルID';

  @override
  String get rel_admin_profile_deleted => 'プロファイルを削除しました。';

  @override
  String
  get rel_admin_profile_deleted_server_identity_cleanup_is_still_pending =>
      'プロファイルを削除しました。サーバー識別情報のクリーンアップは保留中です。';

  @override
  String get rel_admin_export_profile_archive => 'プロファイルアーカイブをエクスポート';

  @override
  String get rel_admin_import_profile_archive => 'プロファイルアーカイブをインポート';

  @override
  String get rel_admin_import_a_trusted_profile => '信頼できるプロファイルをインポート';

  @override
  String get rel_admin_absolute_archive_path_on_gateway => 'ゲートウェイ上のアーカイブの絶対パス';

  @override
  String get rel_admin_messaging_channels => 'メッセージングチャンネル';

  @override
  String get rel_admin_dm_pairing_requests => 'DMペアリングリクエスト';

  @override
  String get rel_admin_no_pending_or_approved_users => '保留中または承認済みのユーザーはいません。';

  @override
  String get rel_admin_legacy_pairing_no_verifiable_request_id_ask_the_user =>
      '旧方式のペアリング：検証可能なリクエストIDがありません。ユーザーに再度ペアリングするよう依頼してください。';

  @override
  String get rel_admin_pairing_change_verified => 'ペアリングの変更を確認しました。';

  @override
  String get rel_admin_create_telegram_bot_by_qr => 'QRでTelegramボットを作成';

  @override
  String get rel_admin_create_telegram_bot => 'Telegramボットを作成';

  @override
  String get rel_admin_bot_name => 'ボット名';

  @override
  String get rel_admin_telegram_bot_creation_qr_code => 'Telegramボット作成用QRコード';

  @override
  String get rel_admin_check_telegram_pairing => 'Telegramのペアリングを確認';

  @override
  String get rel_admin_waiting_for_telegram => 'Telegramを待機中。';

  @override
  String get rel_admin_apply_telegram_bot => 'Telegramボットを適用';

  @override
  String get rel_admin_allowed_numeric_user_ids => '許可するユーザーの数値ID';

  @override
  String get rel_admin_saved_restart_still_required => '保存しました。再起動がまだ必要です。';

  @override
  String get rel_admin_saved_gateway_restart_requested =>
      '保存しました。ゲートウェイの再起動を要求しました。';

  @override
  String get rel_admin_cancel_telegram_setup => 'Telegramの設定をキャンセル';

  @override
  String get rel_admin_inbound_webhooks => '受信Webhook';

  @override
  String get rel_admin_enable_webhook_service => 'Webhookサービスを有効化';

  @override
  String get rel_admin_enable_webhooks => 'Webhookを有効化';

  @override
  String get rel_admin_enabled_restart_still_required => '有効にしました。再起動がまだ必要です。';

  @override
  String get rel_admin_enabled_restart_requested => '有効にしました。再起動を要求しました。';

  @override
  String get rel_admin_route_change_verified => 'ルートの変更を確認しました。';

  @override
  String get rel_admin_delete_route => 'ルートを削除';

  @override
  String get rel_admin_disable_route => 'ルートを無効化';

  @override
  String get rel_admin_enable_route => 'ルートを有効化';

  @override
  String get rel_admin_back_up_entire_agent_home => 'エージェントのホーム全体をバックアップ';

  @override
  String get rel_admin_transfer_to_a_cloud_agent => 'Cloudエージェントに転送';

  @override
  String get rel_admin_check_backup_progress => 'バックアップの進行状況を確認';

  @override
  String get rel_admin_save_backup_to_this_device => 'このデバイスにバックアップを保存';

  @override
  String get rel_admin_save_sensitive_full_home_archive =>
      '機密情報を含むホーム全体のアーカイブを保存';

  @override
  String get rel_admin_save_cancelled => '保存をキャンセルしました。';

  @override
  String get rel_admin_backup_saved => 'バックアップを保存しました。';

  @override
  String get rel_admin_up_to_32_mib_larger_archives_remain_on_the_gateway =>
      '最大32 MiB。これより大きいアーカイブはゲートウェイに残ります。';

  @override
  String rel_admin_persona_scope(String scope) {
    return '$scopeのペルソナを保存します。';
  }

  @override
  String rel_admin_configure_channel(String name) {
    return '$nameを設定';
  }

  @override
  String rel_admin_channel_warning(String scope) {
    return '$scopeに適用します。空欄は既存の値を保持します。値を削除するには、そのキーを下に列挙してください。';
  }

  @override
  String rel_admin_hook_warning(String scope) {
    return '$scopeに適用します。一意の名前を使用してください。ゲートウェイが署名シークレットを作成します。別の操作者が同時に同じ名前を作成した場合、ホストがそのルートを置き換える可能性があります。';
  }

  @override
  String rel_admin_hook_created(String url) {
    return '$urlを作成しました。離れる前に署名シークレットを保存してください。';
  }

  @override
  String rel_admin_clone_warning(String scope) {
    return '$scopeから設定、スキル、ペルソナ、および場合によってはプロバイダー認証情報をコピーします。メッセージングトークンは要求されません。';
  }

  @override
  String rel_admin_cloned(String source, String destination) {
    return '$sourceを$destinationに複製しました。';
  }

  @override
  String rel_admin_rename_target(String name) {
    return '$nameの名前を変更';
  }

  @override
  String rel_admin_rename_label_warning(String scope) {
    return '$scopeの表示名を変更します。IDはdefaultのままです。';
  }

  @override
  String rel_admin_rename_warning(String scope) {
    return 'サーバー上の$scopeの名前を変更します。実行中のゲートウェイが停止する可能性があります。';
  }

  @override
  String rel_admin_delete_target(String name) {
    return '$nameを削除';
  }

  @override
  String rel_admin_delete_profile_warning(String scope) {
    return 'セッションと認証情報を含む$scopeを完全に削除します。正確なプロファイルIDを入力してください。';
  }

  @override
  String rel_admin_export_target(String name) {
    return '$nameをエクスポート';
  }

  @override
  String rel_admin_export_warning(String scope) {
    return '$scopeに.tar.gzを作成します。既知の認証情報ストアは除外されますが、個人データが残る可能性があります。共有前に確認してください。';
  }

  @override
  String rel_admin_archive_on(String gateway, String path) {
    return '$gatewayのアーカイブ：$path';
  }

  @override
  String rel_admin_import_warning(String gateway) {
    return '$gatewayにある確認済みの.tar.gzを使用します。プラグイン、スクリプト、スケジュールが含まれる場合があります。新しいプロファイルIDが必要です。';
  }

  @override
  String rel_admin_imported(String name) {
    return '$nameをインポートしました。';
  }

  @override
  String rel_admin_approve_user(String user) {
    return '$userを承認';
  }

  @override
  String rel_admin_revoke_user(String user) {
    return '$userを取り消す';
  }

  @override
  String rel_admin_allow_pair(String platform, String scope) {
    return '$scopeの$platform：このユーザーのメッセージングアクセスを許可します。';
  }

  @override
  String rel_admin_remove_pair(String platform, String scope) {
    return '$scopeの$platform：このユーザーのメッセージングアクセスを削除します。';
  }

  @override
  String rel_admin_telegram_start(String scope) {
    return 'ゲートウェイのセットアップサービスを使用して$scopeでTelegramペアリングを開始します。';
  }

  @override
  String rel_admin_expires(String time) {
    return '有効期限：$time';
  }

  @override
  String rel_admin_telegram_apply(String bot, String scope) {
    return '$scopeで@$botを有効にし、ゲートウェイの再起動を試みます。リストに記載されたユーザーのみメッセージを送信できます。';
  }

  @override
  String rel_admin_hooks_enable(String scope) {
    return '$scopeで受信Webhookを有効にし、ゲートウェイの再起動を試みます。';
  }

  @override
  String rel_admin_disable_target(String name) {
    return '$nameを無効化';
  }

  @override
  String rel_admin_enable_target(String name) {
    return '$nameを有効化';
  }

  @override
  String rel_admin_hook_change(String name, String scope) {
    return '$scopeの$nameのみを変更します。';
  }

  @override
  String rel_admin_backup_warning(String gateway) {
    return 'これはAresの設定のバックアップではありません。$gateway上のすべてのプロファイル、セッション、認証情報を保存します。アーカイブには機密情報が含まれます。';
  }

  @override
  String rel_admin_backup_started(String gateway) {
    return '$gatewayでバックアップを開始しました。';
  }

  @override
  String rel_admin_backup_verified(String gateway, String path) {
    return '$gatewayでバックアップを確認しました：$path';
  }

  @override
  String rel_admin_backup_running(String gateway) {
    return '$gatewayでバックアップを実行中です。';
  }

  @override
  String get rel_admin_choice_yes => 'はい';

  @override
  String get rel_admin_choice_no => 'いいえ';

  @override
  String get rel_admin_choice_generic => '汎用';

  @override
  String get rel_admin_choice_log => 'ログ';

  @override
  String get rel_admin_choice_email => 'メール';

  @override
  String get rel_admin_choice_github_comment => 'GitHubコメント';

  @override
  String get rel_admin_choice_agent => 'エージェントがイベントを処理';

  @override
  String get rel_admin_choice_direct => '直接配信';

  @override
  String get rel_admin_configured => '設定済み';

  @override
  String get rel_admin_state_pending_restart => '再起動待ち';

  @override
  String get rel_admin_state_unknown => '不明';

  @override
  String get rel_admin_state_connected => '接続済み';

  @override
  String get rel_admin_state_disconnected => '未接続';

  @override
  String get rel_admin_state_disabled => '無効';

  @override
  String get rel_admin_state_enabled => '有効';

  @override
  String get rel_admin_state_running => '実行中';

  @override
  String get rel_admin_state_stopped => '停止';

  @override
  String get rel_admin_state_error => 'エラー';

  @override
  String get rel_admin_state_not_configured => '未設定';

  @override
  String get rel_admin_state_startup_failed => '起動失敗';

  @override
  String get rel_admin_state_gateway_stopped => 'ゲートウェイ停止';

  @override
  String get rel_admin_state_connecting => '接続中';

  @override
  String get rel_admin_state_retrying => '再試行中';

  @override
  String get rel_admin_state_fatal => '致命的エラー';

  @override
  String get rel_admin_unsupported_or_oversized_profile_archive =>
      '未対応またはサイズが大きすぎるプロファイルアーカイブです。';

  @override
  String get rel_admin_current_layout => '現在のレイアウト';

  @override
  String get rel_admin_one_pane => '1ペイン';

  @override
  String get rel_admin_stacked => '上下配置';

  @override
  String get rel_admin_side_by_side => '左右配置';

  @override
  String get rel_admin_no_supported_appearance_in_this_profile =>
      'このプロファイルに対応した外観はありません。';

  @override
  String get rel_admin_review_appearance_saved_with_this_profile =>
      'このプロファイルに保存された外観を確認';

  @override
  String get rel_admin_applies_only_to_this_named_profile_on_this_device =>
      'このデバイス上のこの名前付きプロファイルにのみ適用されます。インポートした配置は空のペインから始まります。チャットは自分で選択してください。';

  @override
  String get rel_admin_apply_to_this_profile_on_this_device =>
      'このデバイスのこのプロファイルに適用';

  @override
  String get rel_admin_export_prepares_a_tar_gz_on_the_gateway_review =>
      'エクスポートはゲートウェイ上に.tar.gzを準備します。ここにコピーを保存する前に、移行可能なファイルを確認してください。インポートは確認用にローカルアーカイブを開きます。開くだけではアップロードされません。';

  @override
  String get rel_admin_prepare_profile_export => 'プロファイルのエクスポートを準備';

  @override
  String get rel_admin_open_tar_gz_from_this_device => 'このデバイスの.tar.gzを開く';

  @override
  String get rel_admin_only_selected_text_files_travel_review_for_secrets_and =>
      '選択したテキストファイルのみ転送されます。シークレットや個人情報が含まれていないか確認してください。設定、スキル、スケジュールによって新しいプロファイルの動作が変わる可能性があります。';

  @override
  String get rel_admin_include_this_reviewed_file => '確認済みのこのファイルを含める';

  @override
  String get rel_admin_apply_appearance_to_the_new_profile_on_this_device =>
      'このデバイスの新しいプロファイルに外観を適用';

  @override
  String
  get rel_admin_imports_colours_and_pane_sizes_never_chats_tools_or_session_ids =>
      '色とペインのサイズをインポートします。チャット、ツール、セッションIDはインポートしません。';

  @override
  String
  get rel_admin_the_gateway_retains_a_private_staged_copy_import_creates =>
      'ゲートウェイは非公開のステージングコピーを保持します。インポートでは新しいプロファイルを作成し、既存のものは置き換えません。';

  @override
  String get rel_admin_appearance_not_applied_the_gateway_did_not_confirm_the =>
      ' 外観は適用されませんでした。ゲートウェイが確認済みのオーバーレイを承認しませんでした。';

  @override
  String get rel_admin_appearance_applied_on_this_device =>
      ' このデバイスに外観を適用しました。';

  @override
  String get rel_admin_appearance_was_not_saved_on_this_device =>
      ' このデバイスに外観は保存されませんでした。';

  @override
  String get rel_admin_save_reviewed_profile_bundle => '確認済みプロファイルバンドルを保存';

  @override
  String get rel_admin_profile_bundle_saved => 'プロファイルバンドルを保存しました。';

  @override
  String get rel_admin_import_selected_files => '選択したファイルをインポート';

  @override
  String get rel_admin_save_selected_files_to_device => '選択したファイルをデバイスに保存';

  @override
  String rel_admin_layout_first_pane(String layout, String percent) {
    return '$layout · 最初のペイン$percent%';
  }

  @override
  String rel_admin_appearance_summary(String skin, String mode, String layout) {
    return 'スキン：$skin · モード：$mode · $layout';
  }

  @override
  String rel_admin_appearance_applied(String gateway, String profile) {
    return '$gateway / $profileに外観を適用しました。';
  }

  @override
  String rel_admin_bundle_summary(
    String profile,
    String count,
    String omitted,
  ) {
    return 'バンドル：$profile · 確認可能なファイル$count件 · 除外$omitted件';
  }

  @override
  String rel_admin_imported_on(String name, String gateway) {
    return '$gatewayに$nameをインポートしました。';
  }

  @override
  String get rel_admin_unchanged => '変更なし';

  @override
  String get rel_admin_mode_system => 'システム';

  @override
  String get rel_admin_mode_light => 'ライト';

  @override
  String get rel_admin_mode_dark => 'ダーク';

  @override
  String get rel_admin_skin_classic => 'クラシック';

  @override
  String get rel_admin_skin_midnight => 'ミッドナイト';

  @override
  String get rel_admin_skin_ember => '残り火';

  @override
  String get rel_admin_skin_mono => 'モノクロ';

  @override
  String get rel_admin_skin_cyberpunk => 'サイバーパンク';

  @override
  String get rel_admin_skin_slate => 'スレート';

  @override
  String get rel_admin_no_available_cloud_agents_in_this_account =>
      'このアカウントに利用可能なCloudエージェントはありません。';

  @override
  String get rel_admin_the_previous_undo_receipt_could_not_be_verified_no =>
      '前回の取り消し用レシートを確認できませんでした。変更は行われていません。';

  @override
  String get rel_admin_transfer_to_cloud => 'Cloudに転送';

  @override
  String
  get rel_admin_connection_changed_leave_this_page_a_restore_already_submitted =>
      '接続が変更されました。このページを離れてください。送信済みの復元は続行される場合があります。';

  @override
  String get rel_admin_find_my_cloud_agents => '自分のCloudエージェントを検索';

  @override
  String
  get rel_admin_undo_replaces_the_destination_with_its_pre_transfer_backup =>
      '取り消すと、転送先が転送前のバックアップに置き換わります。';

  @override
  String get rel_admin_replace_this_cloud_agent_with_the_entire_source_home =>
      'このCloudエージェントを、認証情報、会話、ファイルを含む転送元のホーム全体で置き換えます。転送元は削除されません。受信メッセージングボットはオフになります。';

  @override
  String get rel_admin_type_destination_agent_id => '転送先エージェントIDを入力';

  @override
  String
  get rel_admin_could_not_retain_the_local_undo_receipt_keep_this_page_open =>
      'ローカルの取り消し用レシートを保持できませんでした。このページを開いたままにしてください。';

  @override
  String get rel_admin_undo_transfer => '転送を取り消す';

  @override
  String get rel_admin_replace_cloud_agent => 'Cloudエージェントを置き換え';

  @override
  String
  get rel_admin_local_undo_receipt_forgotten_no_remote_backup_was_removed =>
      'ローカルの取り消し用レシートを削除しました。リモートのバックアップは削除されていません。';

  @override
  String get rel_admin_forget_local_undo_receipt_only => 'ローカルの取り消し用レシートのみ削除';

  @override
  String get rel_admin_stop_before_restore => '復元前に停止';

  @override
  String get rel_admin_do_not_close_this_page_restore_runs_on_the =>
      'このページを閉じないでください。復元は転送先で実行され、キャンセルできません。';

  @override
  String get rel_admin_files_restored_destination_gateway_needs_attention =>
      'ファイルを復元しました。転送先のゲートウェイに対応が必要です。';

  @override
  String rel_admin_transfer_sign_in(String origin) {
    return '$originの保存済みAres接続のうち1つだけにサインインしてから、ここに戻ってください。';
  }

  @override
  String rel_admin_transfer_source(String gateway, String profile) {
    return '転送元：$gateway / $profile';
  }

  @override
  String rel_admin_transfer_destination(String name, String origin) {
    return '転送先：$name · $origin / default';
  }

  @override
  String rel_admin_agent_id(String id) {
    return 'エージェントID：$id';
  }

  @override
  String rel_admin_transfer_status(String phase) {
    return '状態：$phase';
  }

  @override
  String rel_admin_copied_percent(String percent) {
    return '$percent%コピー済み';
  }

  @override
  String rel_admin_undo_point(String path) {
    return '転送先の取り消しポイント：$path';
  }

  @override
  String rel_admin_messaging_disabled(String channels) {
    return 'メッセージング無効：$channels';
  }

  @override
  String get rel_admin_phase_prepared => '準備完了';

  @override
  String get rel_admin_phase_backup => 'バックアップ';

  @override
  String get rel_admin_phase_upload => 'アップロード';

  @override
  String get rel_admin_phase_restore => '復元';

  @override
  String get rel_admin_phase_finished => '完了';

  @override
  String get rel_admin_phase_failed => '失敗';

  @override
  String get rel_admin_phase_undo => '取り消し';

  @override
  String get rel_admin_phase_undone => '取り消し済み';

  @override
  String rel_ops_cap_install_blocked(String verdict, String detail) {
    return 'インストールがブロックされました（$verdict）：$detail';
  }

  @override
  String rel_ops_cap_scan_confirm(String verdict, String requested) {
    return 'スキャン結果：$verdict。インストール前に $requested を確認してください。';
  }

  @override
  String rel_ops_cap_install_unconfirmed(String requested) {
    return 'ゲートウェイは $requested のインストールをまだ確認していません。';
  }

  @override
  String rel_ops_cap_edit_skill(String name) {
    return '$name を編集';
  }

  @override
  String rel_ops_cap_archive_skill(String name) {
    return '$name をアーカイブしますか？';
  }

  @override
  String rel_ops_cap_archive_explanation(String command) {
    return 'スキルはアーカイブされ、$command で復元できます。';
  }

  @override
  String rel_ops_cap_install_anyway(String name) {
    return 'それでも $name をインストール';
  }

  @override
  String rel_ops_cap_install_despite_scan(String name) {
    return 'スキャン結果にかかわらず $name をインストールしますか？';
  }

  @override
  String rel_ops_cap_scan_warning(String name) {
    return 'セキュリティスキャンにより $name がブロックされました。この確認は $name にのみ適用されます。';
  }

  @override
  String rel_ops_cap_accept_scan_warning(String name) {
    return '機能の許可を承認しても、$name のスキャン結果は無効になりません。';
  }

  @override
  String rel_ops_cap_review_scan(String name) {
    return '$name のスキャン結果を確認';
  }

  @override
  String rel_ops_cap_desktop_grants(String description) {
    return '$description\nフォルダーとプレビュースクリプトへの許可は、そのコンピューターの Desktop アプリに保持されます。ここでプラグインを削除しても、それらのローカルの許可は取り消されません。';
  }

  @override
  String rel_ops_cap_remove_plugin(String name) {
    return '$name を削除しますか？';
  }

  @override
  String rel_ops_cap_probe_result(String name, String tools) {
    return '$name の接続テスト：$tools';
  }

  @override
  String rel_ops_cap_save_tool_grants_for(String connector) {
    return '$connector のツールの許可を保存';
  }

  @override
  String rel_ops_cap_backends_for(String name) {
    return '$name のバックエンド';
  }

  @override
  String rel_ops_cap_use_backend_confirmation(String name) {
    return '$name を使用しますか？';
  }

  @override
  String rel_ops_cap_unlock_source(String name) {
    return '$name をロック解除';
  }

  @override
  String get rel_ops_cap_capabilities => '機能';

  @override
  String get rel_ops_cap_plugins => 'プラグイン';

  @override
  String get rel_ops_cap_connectors => 'コネクター';

  @override
  String get rel_ops_cap_backends => 'バックエンド';

  @override
  String get rel_ops_cap_save_skill => 'スキルを保存';

  @override
  String get rel_ops_cap_archive => 'アーカイブ';

  @override
  String get rel_ops_cap_hub_identifier => 'Hub 識別子';

  @override
  String get rel_ops_cap_install => 'インストール';

  @override
  String get rel_ops_cap_update_all => 'すべて更新';

  @override
  String get rel_ops_cap_unlock => 'ロック解除';

  @override
  String get rel_ops_cap_lock => 'ロック';

  @override
  String get rel_ops_cap_this_update_adds_capabilities_nothing_changed_yet =>
      'この更新では機能が追加されます。まだ何も変更されていません。';

  @override
  String get rel_ops_cap_the_scan_blocked_this_plugin =>
      'スキャンによりこのプラグインがブロックされました。';

  @override
  String get rel_ops_cap_the_plugin_was_not_changed => 'プラグインは変更されませんでした。';

  @override
  String get rel_ops_cap_repository => 'リポジトリ';

  @override
  String get rel_ops_cap_install_plugin => 'プラグインをインストール';

  @override
  String get rel_ops_cap_update_plugins => 'プラグインを更新';

  @override
  String get rel_ops_cap_accept_capabilities => '機能の許可を承認';

  @override
  String get rel_ops_cap_update => '更新';

  @override
  String get rel_ops_cap_remove_desktop_half => 'デスクトップ側のコンポーネントを削除';

  @override
  String get rel_ops_cap_server_name => 'サーバー名';

  @override
  String get rel_ops_cap_command => 'コマンド';

  @override
  String get rel_ops_cap_http_url => 'HTTP URL';

  @override
  String get rel_ops_cap_add_server => 'サーバーを追加';

  @override
  String get rel_ops_cap_probe => '接続テスト';

  @override
  String get rel_ops_cap_probe_failed => '接続テストに失敗しました。';

  @override
  String get rel_ops_cap_logs => 'ログ';

  @override
  String get rel_ops_cap_mcp_log => 'MCP ログ';

  @override
  String get rel_ops_cap_connector => 'コネクター';

  @override
  String get rel_ops_cap_account_alias => 'アカウントの別名';

  @override
  String get rel_ops_cap_link_account => 'アカウントを連携';

  @override
  String get rel_ops_cap_remove_account => 'アカウントを削除';

  @override
  String get rel_ops_cap_tool_connector => 'ツールコネクター';

  @override
  String get rel_ops_cap_load_tools => 'ツールを読み込む';

  @override
  String get rel_ops_cap_save_tool_grants => 'ツールの許可を保存';

  @override
  String
  get rel_ops_cap_this_policy_has_no_member_revision_so_tool_grants_stay_unchanged =>
      'このポリシーにはメンバーリビジョンがないため、ツールの許可は変更されません。';

  @override
  String get rel_ops_cap_active => '使用中';

  @override
  String get rel_ops_cap_use => '使用';

  @override
  String get rel_ops_cap_run_setup => 'セットアップを実行';

  @override
  String get rel_ops_cap_terminal_backends => 'ターミナルバックエンド';

  @override
  String get rel_ops_cap_this_changes_the_terminal_backend_for_this_profile =>
      'このプロファイルのターミナルバックエンドが変更されます。';

  @override
  String get rel_ops_cap_use_backend => 'バックエンドを使用';

  @override
  String get rel_ops_cap_select => '選択';

  @override
  String get rel_ops_cap_browser_vault => 'ブラウザー保管庫';

  @override
  String
  get rel_ops_cap_saved_site_logins_addresses_and_cards_passwords_stay_in_the_secure_fields_and_are_not_listed_here =>
      '保存されたサイトのログイン情報、住所、カード。パスワードは安全なフィールドに保持され、ここには表示されません。';

  @override
  String get rel_ops_cap_remove_saved_item => '保存済みの項目を削除';

  @override
  String get rel_ops_cap_delete_this_item => 'この項目を削除しますか？';

  @override
  String get rel_ops_cap_unlocked => 'ロック解除済み';

  @override
  String get rel_ops_cap_locked => 'ロック中';

  @override
  String get rel_ops_cap_not_detected => '未検出';

  @override
  String get rel_ops_cap_master_password => 'マスターパスワード';

  @override
  String get rel_ops_cap_login => 'ログイン情報';

  @override
  String get rel_ops_cap_address => '住所';

  @override
  String get rel_ops_cap_card => 'カード';

  @override
  String get rel_ops_cap_label => 'ラベル';

  @override
  String get rel_ops_cap_site_origin => 'サイトのオリジン';

  @override
  String get rel_ops_cap_identifier => '識別子';

  @override
  String get rel_ops_cap_password => 'パスワード';

  @override
  String get rel_ops_cap_authenticator_key => '認証キー';

  @override
  String get rel_ops_cap_street => '町名・番地';

  @override
  String get rel_ops_cap_city => '市区町村';

  @override
  String get rel_ops_cap_postal_code => '郵便番号';

  @override
  String get rel_ops_cap_country => '国・地域';

  @override
  String get rel_ops_cap_name_on_card => 'カード名義';

  @override
  String get rel_ops_cap_card_number => 'カード番号';

  @override
  String get rel_ops_cap_expiry_month => '有効期限の月';

  @override
  String get rel_ops_cap_expiry_year => '有効期限の年';

  @override
  String get rel_ops_cap_security_code => 'セキュリティコード';

  @override
  String get rel_ops_cap_this_gateway_has_no_shared_metrics_consent_method =>
      'このゲートウェイには共有メトリクスへの同意を設定するメソッドがありません。';

  @override
  String get rel_ops_cap_agent_policy => 'エージェントポリシー';

  @override
  String get rel_ops_cap_loading_policy => 'ポリシーを読み込み中';

  @override
  String get rel_ops_cap_approval_timeout => '承認のタイムアウト';

  @override
  String get rel_ops_cap_confirm_mcp_reloads => 'MCP の再読み込みを確認';

  @override
  String get rel_ops_cap_command_allowlist => 'コマンドの許可リスト';

  @override
  String get rel_ops_cap_file_checkpoints => 'ファイルのチェックポイント';

  @override
  String get rel_ops_cap_checkpoint_limit => 'チェックポイントの上限';

  @override
  String get rel_ops_cap_browser_private_urls => 'ブラウザーのプライベート URL';

  @override
  String get rel_ops_cap_use_my_real_browser_profile => '実際のブラウザープロファイルを使用';

  @override
  String get rel_ops_cap_save_policy => 'ポリシーを保存';

  @override
  String get rel_ops_cap_shared_metrics_for_this_profile => 'このプロファイルの共有メトリクス';

  @override
  String get rel_ops_cap_send_shared_metrics => '共有メトリクスを送信';

  @override
  String get rel_ops_cap_error_enter_a_label => 'ラベルを入力してください。';

  @override
  String get rel_ops_cap_error_enter_a_valid_url_like_https_example_com =>
      'https://example.com のような有効な URL を入力してください。';

  @override
  String get rel_ops_cap_error_enter_the_identifier_and_password =>
      '識別子とパスワードを入力してください。';

  @override
  String
  get rel_ops_cap_error_enter_the_card_name_number_expiry_and_security_code =>
      'カード名義、番号、有効期限、セキュリティコードを入力してください。';

  @override
  String get rel_ops_cap_error_enter_the_street_city_postal_code_and_country =>
      '町名・番地、市区町村、郵便番号、国・地域を入力してください。';

  @override
  String
  get rel_ops_cap_error_the_gateway_returned_a_response_that_could_not_be_read =>
      'ゲートウェイから読み取れない応答が返されました。';

  @override
  String rel_ops_cap_error_the_gateway_refused_the_request_status(
    int statusCode,
  ) {
    return 'ゲートウェイがリクエストを拒否しました（$statusCode）。';
  }

  @override
  String
  rel_ops_cap_error_this_connection_has_no_gateway_socket_so_method_is_unavailable(
    String method,
  ) {
    return 'この接続にはゲートウェイソケットがないため、$method は使用できません。';
  }

  @override
  String get rel_ops_cap_error_choose_a_skill => 'スキルを選択してください。';

  @override
  String get rel_ops_cap_error_the_skill_text_was_not_returned =>
      'スキルのテキストが返されませんでした。';

  @override
  String get rel_ops_cap_error_the_skill_was_not_saved => 'スキルは保存されませんでした。';

  @override
  String get rel_ops_cap_error_the_skill_was_not_archived =>
      'スキルはアーカイブされませんでした。';

  @override
  String get rel_ops_cap_error_the_skill_was_not_installed =>
      'スキルはインストールされませんでした。';

  @override
  String get rel_ops_cap_error_skill_updates_did_not_start =>
      'スキルの更新は開始されませんでした。';

  @override
  String get rel_ops_cap_error_the_skill_was_not_removed => 'スキルは削除されませんでした。';

  @override
  String get rel_ops_cap_error_enter_a_skill_or_plugin_identifier =>
      'スキルまたはプラグインの識別子を入力してください。';

  @override
  String get rel_ops_cap_error_choose_a_plugin => 'プラグインを選択してください。';

  @override
  String get rel_ops_cap_error_the_plugin_was_not_removed =>
      'プラグインは削除されませんでした。';

  @override
  String get rel_ops_cap_error_the_desktop_half_was_not_removed =>
      'デスクトップ側のコンポーネントは削除されませんでした。';

  @override
  String
  get rel_ops_cap_error_this_gateway_did_not_give_the_plugin_a_stable_key =>
      'このゲートウェイはプラグインに安定したキーを割り当てませんでした。';

  @override
  String get rel_ops_cap_error_the_plugin_was_not_changed =>
      'プラグインは変更されませんでした。';

  @override
  String get rel_ops_cap_error_choose_a_server => 'サーバーを選択してください。';

  @override
  String get rel_ops_cap_error_name_the_server => 'サーバーに名前を付けてください。';

  @override
  String get rel_ops_cap_error_give_the_server_a_command_or_an_http_s_url =>
      'サーバーのコマンドまたは http(s) URL を指定してください。';

  @override
  String get rel_ops_cap_error_choose_a_toolset => 'ツールセットを選択してください。';

  @override
  String get rel_ops_cap_error_tool_backend_status_was_not_returned =>
      'ツールバックエンドの状態が返されませんでした。';

  @override
  String get rel_ops_cap_error_choose_a_provider => 'プロバイダーを選択してください。';

  @override
  String get rel_ops_cap_error_this_provider_has_no_setup_action =>
      'このプロバイダーにはセットアップ操作がありません。';

  @override
  String get rel_ops_cap_error_setup_did_not_start => 'セットアップは開始されませんでした。';

  @override
  String get rel_ops_cap_error_choose_a_terminal_backend =>
      'ターミナルバックエンドを選択してください。';

  @override
  String get rel_ops_cap_error_name_the_connector => 'コネクターに名前を付けてください。';

  @override
  String get rel_ops_cap_error_choose_an_account => 'アカウントを選択してください。';

  @override
  String
  get rel_ops_cap_error_reload_the_connector_policy_before_changing_tool_grants =>
      'ツールの許可を変更する前にコネクターポリシーを再読み込みしてください。';

  @override
  String get rel_ops_cap_error_choose_an_item => '項目を選択してください。';

  @override
  String get rel_ops_cap_error_choose_a_source => 'ソースを選択してください。';

  @override
  String get rel_ops_cap_error_enter_the_master_password =>
      'マスターパスワードを入力してください。';

  @override
  String get rel_ops_cap_error_gateway_config_was_not_returned =>
      'ゲートウェイの設定が返されませんでした。';

  @override
  String get rel_ops_cap_error_choose_a_known_approval_mode =>
      '既知の承認モードを選択してください。';

  @override
  String get rel_ops_cap_error_use_a_positive_limit => '上限には正の値を使用してください。';

  @override
  String get rel_ops_cap_error_the_policy_was_not_saved => 'ポリシーは保存されませんでした。';

  @override
  String get rel_ops_cap_value_manual => '手動';

  @override
  String get rel_ops_cap_value_smart => 'スマート';

  @override
  String get rel_ops_cap_value_off => 'オフ';

  @override
  String get rel_ops_cap_value_safe => '安全';

  @override
  String get rel_ops_cap_value_caution => '注意';

  @override
  String get rel_ops_cap_value_dangerous => '危険';

  @override
  String get rel_ops_cap_value_blocked => 'ブロック済み';

  @override
  String get rel_ops_cap_value_clean => '脅威なし';

  @override
  String get rel_ops_cap_value_ready => '準備完了';

  @override
  String get rel_ops_cap_value_available => '利用可能';

  @override
  String get rel_ops_cap_value_unavailable => '利用不可';

  @override
  String get rel_ops_cap_value_enabled => '有効';

  @override
  String get rel_ops_cap_value_disabled => '無効';

  @override
  String get rel_ops_cap_value_active => '使用中';

  @override
  String get rel_ops_cap_value_inactive => '未使用';

  @override
  String get rel_ops_cap_value_installed => 'インストール済み';

  @override
  String get rel_ops_cap_value_missing => '見つかりません';

  @override
  String get rel_ops_cap_value_configured => '設定済み';

  @override
  String get rel_ops_cap_value_not_configured => '未設定';

  @override
  String get rel_ops_cap_value_error => 'エラー';

  @override
  String get rel_ops_cap_value_unknown => '不明';

  @override
  String get rel_ops_cap_value_login => 'ログイン情報';

  @override
  String get rel_ops_cap_value_address => '住所';

  @override
  String get rel_ops_cap_value_payment => '支払い';

  @override
  String get rel_ops_term_connecting => '接続中…';

  @override
  String get rel_ops_term_unbound =>
      '一致する稼働中のセッションまたはホストの作業ディレクトリがありません。先に対応するチャットを開いてください。';

  @override
  String get rel_ops_term_unsupported =>
      'このゲートウェイはこのターミナル機能を提供していません。ローカルシェルは起動されていません。';

  @override
  String get rel_ops_term_local_pty_unavailable =>
      '同梱のローカルPTYはこのデバイスでは利用できません。';

  @override
  String get rel_ops_term_operation_failed =>
      'ターミナルを開くか操作することができませんでした。ホスト、認証情報、フィンガープリントを確認してください。代替シェルは起動されていません。';

  @override
  String get rel_ops_term_input_refused => '入力が拒否されました。元のチャットを開き直してください。';

  @override
  String get rel_ops_term_cancel => 'キャンセル';

  @override
  String get rel_ops_term_confirm => '確認';

  @override
  String get rel_ops_term_open_device_title => 'このデバイスでシェルを開きますか？';

  @override
  String get rel_ops_term_ssh_shell => 'SSHシェル';

  @override
  String get rel_ops_term_local_shell => 'ローカルシェル';

  @override
  String get rel_ops_term_connection_lost => '接続が失われました';

  @override
  String get rel_ops_term_shell_ended => 'シェルが終了しました';

  @override
  String get rel_ops_term_no_owner =>
      'このチャットには認証済みのゲートウェイターミナル所有者がいません。URLまたはクラウドへのログインだけではシェルへのアクセス権は付与されません。';

  @override
  String get rel_ops_term_open_gateway_title => 'ゲートウェイのシェルを開きますか？';

  @override
  String get rel_ops_term_shell_expired => 'シェルが終了したか有効期限が切れました';

  @override
  String get rel_ops_term_disconnected => '切断済み';

  @override
  String get rel_ops_term_gateway_shell => 'ゲートウェイシェル';

  @override
  String get rel_ops_term_close_body =>
      'このシェルを終了します。実行を続けるには、代わりにペインを非表示にしてください。';

  @override
  String get rel_ops_term_closing => '終了中…';

  @override
  String get rel_ops_term_close_unconfirmed => '終了を確認できませんでした';

  @override
  String get rel_ops_term_processes_require_chat =>
      'エージェントプロセスには、認証済みの対応するチャットが必要です。';

  @override
  String get rel_ops_term_watching_processes =>
      'このチャットのエージェントプロセスを監視しています。ミラー表示を閉じてもプロセスは停止しません。';

  @override
  String get rel_ops_term_paste_limit => '貼り付けは16 KiBまでです。';

  @override
  String get rel_ops_term_paste => '貼り付け';

  @override
  String get rel_ops_term_select_first => '先にターミナルの出力を選択してください。';

  @override
  String get rel_ops_term_open_chat_to_insert => '出力を挿入する前に元のチャットを開いてください。';

  @override
  String get rel_ops_term_added_to_draft => '元のチャットの下書きに追加しました。何も送信されていません。';

  @override
  String get rel_ops_term_close => '閉じる';

  @override
  String get rel_ops_term_add_selection => '選択範囲をチャットの下書きに追加';

  @override
  String get rel_ops_term_new_terminal => '新しいターミナル';

  @override
  String get rel_ops_term_gateway_terminal => 'ゲートウェイホストのターミナル';

  @override
  String get rel_ops_term_verified_ssh_terminal => '検証済みSSHターミナル';

  @override
  String get rel_ops_term_device_local_shell => 'このデバイス（ローカルシェル）';

  @override
  String get rel_ops_term_local_unavailable_mobile => 'モバイルではローカルシェルを利用できません';

  @override
  String get rel_ops_term_watch_processes => 'エージェントプロセスを監視';

  @override
  String get rel_ops_term_select_output => '出力を選択またはコピー';

  @override
  String get rel_ops_term_add_selected_output => '選択した出力をチャットの下書きに追加';

  @override
  String get rel_ops_term_review_paste => 'クリップボードからの貼り付け内容を確認';

  @override
  String get rel_ops_term_reconnect => '同じシェルに再接続';

  @override
  String get rel_ops_term_close_mirror => 'ミラー表示を閉じる';

  @override
  String get rel_ops_term_close_shell => 'シェルを閉じる';

  @override
  String get rel_ops_term_empty => '+ を選択してターミナルを開いてください。シェルが自動的に起動することはありません。';

  @override
  String get rel_ops_term_reason_stale => '古い状態';

  @override
  String get rel_ops_term_reason_mismatch => '不一致';

  @override
  String get rel_ops_term_reason_unbound => '未関連付け';

  @override
  String get rel_ops_term_reason_unsupported => '未対応';

  @override
  String get rel_ops_term_reason_denied => '拒否';

  @override
  String get rel_ops_term_reason_ineligible => '利用資格なし';

  @override
  String get rel_ops_term_reason_unavailable => '利用不可';

  @override
  String get rel_ops_term_reason_invalid => '無効';

  @override
  String get rel_ops_term_reason_insecure => '安全でない接続';

  @override
  String rel_ops_term_refused(String reason) {
    return 'ゲートウェイがこのターミナル操作を拒否しました（$reason）。';
  }

  @override
  String rel_ops_term_open_device_body(String connection) {
    return 'これはAresのデバイスであり、$connectionではありません。シェルはアプリの権限を使用し、アプリのストレージで起動します。';
  }

  @override
  String rel_ops_term_open_gateway_body(String host) {
    return '$host上の、検証済みのチャット作業ディレクトリでシェルを起動します。これはデバイスのシェルではありません。';
  }

  @override
  String rel_ops_term_close_tab_title(String label) {
    return '$labelを閉じますか？';
  }

  @override
  String rel_ops_term_read_only_status(String status) {
    return '読み取り専用 · $status';
  }

  @override
  String rel_ops_term_paste_title(String label) {
    return '$labelに貼り付けますか？';
  }

  @override
  String rel_ops_term_output_title(String label) {
    return '出力 · $label';
  }

  @override
  String rel_ops_term_mirror_status(String label) {
    return '読み取り専用のプロセスミラー · $label';
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
    return 'このデバイス · $number';
  }

  @override
  String rel_ops_term_gateway_tab(String host, int number) {
    return 'ゲートウェイ $host · $number';
  }

  @override
  String get rel_ops_term_earlier_output_trimmed => '[以前の出力は切り詰められました]';

  @override
  String get rel_ops_term_ssh_dialog_title => '検証済みSSHターミナルを開く';

  @override
  String get rel_ops_term_ssh_dialog_body =>
      'ホスト管理者から独立した経路で取得したフィンガープリントを使用してください。ゲートウェイやローカルシェルではなく、新しいリモートログインセッションを開きます。';

  @override
  String get rel_ops_term_ssh_host => 'SSHホスト';

  @override
  String get rel_ops_term_ssh_port => 'ポート';

  @override
  String get rel_ops_term_ssh_user => 'ユーザー';

  @override
  String get rel_ops_term_ssh_fingerprint => 'ホスト鍵のフィンガープリント（SHA256:…）';

  @override
  String get rel_ops_term_ssh_password => 'SSHパスワード（保存されません）';

  @override
  String get rel_ops_term_connect => '接続';

  @override
  String get rel_ops_ssh_invalid_destination => 'SSHホスト、ポート、またはユーザーが無効です。';

  @override
  String get rel_ops_ssh_public_key_required =>
      'OpenSSH Ed25519形式のホスト公開鍵が必要です。';

  @override
  String get rel_ops_ssh_invalid_public_key => 'Ed25519ホスト鍵が無効です。';

  @override
  String get rel_ops_ssh_invalid_saved_key => '保存されたホスト鍵が無効です。';

  @override
  String get rel_ops_ssh_enrollment_unverified => 'ホスト鍵の登録を検証できませんでした。';

  @override
  String get rel_ops_ssh_different_key_pinned =>
      '別の鍵がすでに固定されています。変更を別途検証してください。';

  @override
  String get rel_ops_ssh_open_ssh_unavailable => 'システムのOpenSSHを利用できません。';

  @override
  String get rel_ops_ssh_confirm_host_key => '接続する前にホスト鍵を確認してください。';

  @override
  String get rel_ops_ssh_absolute_identity_required =>
      '絶対パスで指定された認証鍵ファイルを選択してください。';

  @override
  String get rel_ops_ssh_invalid_remote_port => 'リモートポートが無効です。';

  @override
  String get rel_ops_ssh_preview_too_large => 'プレビューが64 KiBの上限を超えています。';

  @override
  String get rel_ops_ssh_connection_refused =>
      'SSH接続が拒否されました。登録済みのホスト鍵、認証情報、サービスを確認してください。';

  @override
  String get rel_ops_ssh_http_not_ok => 'リモートサービスからHTTP 200が返されませんでした。';

  @override
  String get rel_ops_ssh_encoded_response => 'このプレビューはエンコードされた応答に対応していません。';

  @override
  String get rel_ops_ssh_preview_type_unsupported =>
      'プレビューできるのはテキストとHTMLソースのみです。';

  @override
  String get rel_ops_ssh_health_unconfirmed => 'サービスからゲートウェイの正常性を確認できませんでした。';

  @override
  String get rel_ops_ssh_enroll_host_key_first => 'まずホストの公開鍵を登録してください。';

  @override
  String get rel_ops_ssh_cancel => 'キャンセル';

  @override
  String get rel_ops_ssh_confirm => '確認';

  @override
  String get rel_ops_ssh_pin_title => 'このSSHホスト鍵を固定しますか？';

  @override
  String rel_ops_ssh_pin_detail(String destination, String fingerprint) {
    return '$destination\n$fingerprint\n独立した通信経路でホスト管理者にこのフィンガープリントを照合してください。接続は行われません。';
  }

  @override
  String get rel_ops_ssh_host_key_pinned => 'ホスト鍵を固定しました。';

  @override
  String get rel_ops_ssh_shell_detail => '対話型ログインシェルを開きます。';

  @override
  String rel_ops_ssh_read_detail(String path, int port) {
    return 'SSHチャネル経由でリモートの127.0.0.1:$portにある$pathを読み取ります。';
  }

  @override
  String rel_ops_ssh_connect_title(String destination) {
    return '$destinationに接続しますか？';
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
  String get rel_ops_ssh_agent_auth => 'SSHエージェントで認証します。';

  @override
  String get rel_ops_ssh_identity_auth => '選択した認証鍵ファイルを使用します。';

  @override
  String rel_ops_ssh_gateway_responding(int port) {
    return 'ゲートウェイがリモートのループバックポート$portで応答しています。';
  }

  @override
  String get rel_ops_ssh_session_closed => 'SSHセッションを閉じました。';

  @override
  String get rel_ops_ssh_session_unclean => 'SSHセッションが正常に終了しませんでした。';

  @override
  String get rel_ops_ssh_operation_failed => 'SSH操作に失敗しました。接続先と認証情報を確認してください。';

  @override
  String get rel_ops_ssh_title => '検証済みSSH';

  @override
  String get rel_ops_ssh_unsupported =>
      'このデバイスには、対応するシステムOpenSSHトランスポートがありません。固定済みゲートウェイのリレーは新しい鍵を自動的に受け入れるため、検証付きの登録には使用できません。';

  @override
  String get rel_ops_ssh_host => 'SSHホスト';

  @override
  String get rel_ops_ssh_port => 'SSHポート';

  @override
  String get rel_ops_ssh_user => 'SSHユーザー';

  @override
  String get rel_ops_ssh_identity => '認証鍵ファイル（任意。未指定の場合はSSHエージェントを使用）';

  @override
  String get rel_ops_ssh_public_key => '管理者から提供されたホスト公開鍵（ssh-ed25519）';

  @override
  String get rel_ops_ssh_review_key => 'ホスト鍵を確認';

  @override
  String get rel_ops_ssh_remote_port => 'リモートのループバックサービスポート';

  @override
  String get rel_ops_ssh_check_gateway => 'SSH経由でゲートウェイを確認';

  @override
  String get rel_ops_ssh_preview_source => 'SSH経由でソースをプレビュー';

  @override
  String get rel_ops_ssh_open_shell => 'SSHシェルを開く';

  @override
  String get rel_ops_ssh_shell_line => 'リモートシェルに送信する行';

  @override
  String get rel_ops_ssh_disconnect => 'シェルを切断';

  @override
  String get rel_ops_host_cancel => 'キャンセル';

  @override
  String get rel_ops_host_confirm => '確認';

  @override
  String get rel_ops_host_title => 'ホスト';

  @override
  String get rel_ops_host_refresh => '更新';

  @override
  String get rel_ops_host_update => 'リモートの Hermes を更新';

  @override
  String rel_ops_host_update_confirmation(String profile) {
    return '$profile のゲートウェイホストで既存のインストールを更新します。このデバイスの Ares は更新されません。成功を示すのは対応する更新の実施記録であり、ホストに接続できる状態が続くことではありません。';
  }

  @override
  String get rel_ops_host_update_awaiting => '対応する実施記録を待っています。更新はまだ実行中です。';

  @override
  String get rel_ops_host_receipt_success => '更新の実施記録は成功を示しています。';

  @override
  String get rel_ops_host_receipt_partial => '更新は適用されましたが、追加の手順がまだ必要です。';

  @override
  String get rel_ops_host_receipt_failed => '更新の実施記録は失敗を示しています。';

  @override
  String get rel_ops_host_receipt_refused => '更新の実施記録は拒否を示しています。';

  @override
  String get rel_ops_host_update_running => '更新はまだ実行中です。';

  @override
  String get rel_ops_host_update_unknown =>
      '更新の結果は不明です。ゲートウェイが稼働していても、更新の成功を意味しません。';

  @override
  String get rel_ops_host_default_profile => 'ゲートウェイのデフォルトプロファイル';

  @override
  String get rel_ops_host_restart => 'リモートゲートウェイを再起動';

  @override
  String rel_ops_host_restart_shared_confirmation(String profiles) {
    return '$profiles が共有するゲートウェイを再起動します。このゲートウェイで実行中のターンは中断されます。その後、再接続してください。接続できることは、再起動完了の証明にはなりません。';
  }

  @override
  String rel_ops_host_restart_confirmation(String profile) {
    return '$profile のリモートゲートウェイを再起動します。このゲートウェイで実行中のターンは中断されます。その後、再接続してください。';
  }

  @override
  String get rel_ops_host_restart_running => '再起動コマンドはまだ実行中です。';

  @override
  String get rel_ops_host_restart_finished =>
      '再起動コマンドが終了しました。ホストに手動で再接続してください。';

  @override
  String get rel_ops_host_restart_failed => '再起動コマンドが失敗しました。';

  @override
  String rel_ops_host_maintenance_running(String name) {
    return '$name はまだ実行中です';
  }

  @override
  String rel_ops_host_maintenance_finished(String name) {
    return '$name が完了しました';
  }

  @override
  String rel_ops_host_maintenance_failed(String name) {
    return '$name が失敗しました';
  }

  @override
  String get rel_ops_host_curator_paused_result => 'キュレーターを一時停止しました。';

  @override
  String get rel_ops_host_curator_resumed_result => 'キュレーターを再開しました。';

  @override
  String get rel_ops_host_reset => 'リモートのメモリファイルをリセット';

  @override
  String rel_ops_host_reset_confirmation(String targetName, String profile) {
    return '$profile のメモリファイル $targetName を削除しますか？この操作は Ares からは元に戻せません。';
  }

  @override
  String rel_ops_host_reset_result(String targetName, int count) {
    return '$targetName をリセットしました。リモートファイルを $count 個削除しました。';
  }

  @override
  String get rel_ops_host_share_not_redacted =>
      'ホストが診断パッケージの機密情報のマスキングを確認していません。リンクは表示されません。';

  @override
  String rel_ops_host_scope(String connection, String profile) {
    return 'これらの操作の対象は $profile のリモートゲートウェイ $connection です。このデバイスや Ares クライアントの更新は対象ではありません。';
  }

  @override
  String rel_ops_host_health_running(String version, int count) {
    return 'ゲートウェイプロセス稼働中 $version · $count セッション';
  }

  @override
  String rel_ops_host_health_stopped(String version, int count) {
    return 'ゲートウェイプロセス停止中 $version · $count セッション';
  }

  @override
  String rel_ops_host_heartbeat_stale(num seconds) {
    return 'ホストのハートビートが古くなっています（$seconds 秒）。';
  }

  @override
  String get rel_ops_host_doctor => 'Doctor を実行';

  @override
  String get rel_ops_host_security_audit => 'セキュリティ監査';

  @override
  String get rel_ops_host_check_receipt => '更新の実施記録を確認';

  @override
  String get rel_ops_host_logs => 'リモートホストのログ';

  @override
  String get rel_ops_host_search_logs => 'ホストのログを検索';

  @override
  String get rel_ops_host_driver => 'リモートホストのドライバー';

  @override
  String get rel_ops_host_driver_scope =>
      'コンピューター操作の準備状況は、ゲートウェイマシンのドライバーと OS の権限に関するもので、このデバイスのものではありません。';

  @override
  String rel_ops_host_computer_status(
    String platform,
    String installed,
    String ready,
  ) {
    return '$platform · インストール済み $installed · 準備完了 $ready';
  }

  @override
  String get rel_ops_host_null => '利用不可';

  @override
  String get rel_ops_host_true => 'はい';

  @override
  String get rel_ops_host_false => 'いいえ';

  @override
  String get rel_ops_host_curator => 'キュレーター';

  @override
  String get rel_ops_host_curator_paused => 'キュレーターは一時停止中';

  @override
  String get rel_ops_host_curator_running => 'キュレーターは実行中';

  @override
  String get rel_ops_host_no_run => '完了した実行はありません';

  @override
  String get rel_ops_host_run_curator => 'キュレーターを今すぐ実行';

  @override
  String get rel_ops_host_reset_memory => 'メモリファイルをリセット';

  @override
  String get rel_ops_host_reset_user => 'ユーザーファイルをリセット';

  @override
  String get rel_ops_host_reset_both => '両方のファイルをリセット';

  @override
  String get rel_ops_host_share_consent =>
      'リモートホストから機密情報をマスキングした診断パッケージをアップロードすることに同意します';

  @override
  String get rel_ops_host_share => '機密情報をマスキングした診断情報を共有';

  @override
  String get rel_ops_host_update_unknown_installation =>
      'このインストールは不明なため、更新は送信されませんでした';

  @override
  String get rel_ops_host_update_busy_installation => 'このインストールでチャットが実行中です';

  @override
  String get rel_ops_host_update_refused => 'リモート更新が拒否されました';

  @override
  String get rel_ops_host_error_stale => 'リモートワークスペース：古い状態';

  @override
  String get rel_ops_host_error_mismatch => 'リモートワークスペース：不一致';

  @override
  String get rel_ops_host_error_unbound => 'リモートワークスペース：未関連付け';

  @override
  String get rel_ops_host_error_unsupported => 'リモートワークスペース：未対応';

  @override
  String get rel_ops_host_error_denied => 'リモートワークスペース：アクセス拒否';

  @override
  String get rel_ops_host_error_ineligible => 'リモートワークスペース：対象外';

  @override
  String get rel_ops_host_error_unavailable => 'リモートワークスペース：利用不可';

  @override
  String get rel_ops_host_error_invalid => 'リモートワークスペース：無効';

  @override
  String get rel_ops_host_error_insecure => 'リモートワークスペース：安全でない接続';

  @override
  String get rel_ops_host_error_request => 'リクエストを完了できませんでした。';

  @override
  String get rel_svc_push_api_select_sessions =>
      '永続セッション ID を 1～128 個選択してください。各 ID は 1～200 文字の ASCII で、英数字と _ . : @ - のみ使用できます。空の ID と空白を削除してください。';

  @override
  String get rel_svc_push_api_unavailable => 'このサーバーではモバイルプッシュを利用できません。';

  @override
  String get rel_svc_push_api_invalid_vapid => 'サーバーの VAPID 公開鍵が無効です。';

  @override
  String get rel_svc_push_api_update_plugin =>
      '自動サブスクリプションには、このサーバーの mobile-push プラグインを更新する必要があります。';

  @override
  String get rel_svc_push_status_android_only => 'Android のみ';

  @override
  String get rel_svc_push_native_prefs_sync_failed => 'ネイティブ通知の設定を同期できませんでした。';

  @override
  String get rel_svc_push_choose_android_connection =>
      'まず Android で保存済みの接続を選択してください。';

  @override
  String get rel_svc_push_status_checking_authorization => 'サーバーの承認を確認中';

  @override
  String get rel_svc_push_revoke_persist_failed =>
      '失効を保存できませんでした。アプリを終了する前に、もう一度無効化してください。';

  @override
  String get rel_svc_push_status_off_api_ready => 'オフ、サーバー API は準備完了';

  @override
  String get rel_svc_push_status_off_revoke_pending => 'オフ、サーバーでの失効待ち';

  @override
  String get rel_svc_push_status_off_connection_changed => 'オフ、保存済みの接続が変更されました';

  @override
  String get rel_svc_push_status_pending_endpoint => 'ディストリビューターのエンドポイントを待機中';

  @override
  String get rel_svc_push_status_registering => '登録中';

  @override
  String get rel_svc_push_status_pending_challenge =>
      '暗号化チャレンジ待ち（サーバー検証用のサイレントプッシュを待機中）';

  @override
  String get rel_svc_push_allow_android_notifications_retry =>
      'システム設定で Android の通知を許可してから、もう一度お試しください。';

  @override
  String get rel_svc_push_plugin_invalid =>
      'サーバーの mobile-push プラグインが利用できないか古い、または無効なサブスクリプション応答を返しました。運用者に更新を依頼してから、もう一度お試しください。';

  @override
  String get rel_svc_push_transport_unavailable =>
      '利用可能なプッシュ転送手段がありません。内蔵配信には動作する Google Play 開発者サービスが必要です。または UnifiedPush ディストリビューターをインストールして再試行してください。';

  @override
  String get rel_svc_push_transport_choice =>
      '複数の UnifiedPush ディストリビューターが利用できます。「詳細な転送」で 1 つ選択し、再試行してください。';

  @override
  String get rel_svc_push_transport_missing =>
      '選択した UnifiedPush ディストリビューターは利用できません。復元するか、「詳細な転送」で別のものを選択してください。';

  @override
  String get rel_svc_push_companion_unavailable =>
      'サーバーの mobile-push コンパニオンを利用できません。未インストール、無効、または接続先のダッシュボードが違う可能性があります。サーバーでコンパニオンをインストールまたは有効化し、ダッシュボード接続を確認して更新してください。上のサーバー設定ガイドを参照してください。';

  @override
  String get rel_svc_push_server_denied =>
      'サーバーがモバイルプッシュを拒否しました。運用者に、このプリンシパルとセッションの承認を依頼してください。';

  @override
  String get rel_svc_push_not_ready =>
      'モバイルプッシュの準備ができていません。サーバープラグインの承認、ディストリビューター、ネットワークを確認して再試行してください。';

  @override
  String get rel_svc_push_availability_read_failed =>
      'Android プッシュの利用可否を確認できません。下で再試行してください。';

  @override
  String get rel_svc_push_setup_failed =>
      'プッシュの設定に失敗しました。Android の権限、サーバーの承認、転送手段を確認して再試行してください。';

  @override
  String rel_svc_push_status(String status) {
    return 'ステータス: $status';
  }

  @override
  String rel_svc_push_status_bound(
    String bound,
    String connection,
    String status,
  ) {
    return 'ステータス: $bound にバインド済み（$connection では無効、ハンドシェイク: $status）';
  }

  @override
  String get rel_svc_push_another_saved_connection => '別の保存済み接続';

  @override
  String get rel_svc_push_background_notifications => 'バックグラウンド通知';

  @override
  String rel_svc_push_bound_subtitle(String bound, String connection) {
    return '$bound にバインド済み — $connection で有効にする前に、下でこのバインドを取り消してください';
  }

  @override
  String rel_svc_push_private_activity(String connection) {
    return '$connection のプライベートサーバーアクティビティ';
  }

  @override
  String rel_svc_push_bound_warning_named(String bound) {
    return '別の保存済み接続（$bound）にバインドされています。この接続で有効にする前に、そのバインドを無効化して取り消してください。';
  }

  @override
  String get rel_svc_push_bound_warning =>
      '別の保存済み接続にバインドされています。この接続で有効にする前に、そのバインドを無効化して取り消してください。';

  @override
  String get rel_svc_push_local_notifications_muted =>
      '上でローカル通知がオフになっています。バックグラウンド通知への同意は変わりませんが、「通知を有効にする」をオンにするまで通常のアクティビティ通知はミュートされます。';

  @override
  String rel_svc_push_legacy_subscription(int count) {
    return '従来のサブスクリプション: 選択した $count 件のセッションのみ。自動では拡張されません。オフにしてからオンにすると、サーバー承認済みセッションに同意できます。';
  }

  @override
  String get rel_svc_push_authorized_binding =>
      'この保存済み接続とプロファイルだけにバインドされます。セッションアクセスは現在のサーバー承認に従います。';

  @override
  String get rel_svc_push_revocation_pending =>
      'サーバーでの失効待ちです。ローカル配信はオフです。元の保存済みログインが利用できる間に再試行してください。';

  @override
  String get rel_svc_push_refresh_retry => '更新 / 再試行';

  @override
  String rel_svc_push_disable_named(String bound) {
    return '$bound を無効化して取り消す';
  }

  @override
  String get rel_svc_push_other_connection => '別の接続';

  @override
  String get rel_svc_push_disable => '無効化して取り消す';

  @override
  String get rel_svc_push_refresh_explanation =>
      '更新 / 再試行はサーバー設定後の利用可否を再確認しますが、コンパニオンはインストールできません。通知の有効化は引き続き別の選択です。';

  @override
  String get rel_svc_push_companion_required =>
      'バックグラウンド通知には、サーバー側の mobile-push コンパニオンを別途インストールして有効化する必要があります。Android からはインストールできません。APK の更新だけではサーバーは設定されません。';

  @override
  String get rel_svc_push_server_setup_guide => 'サーバー設定ガイド';

  @override
  String get rel_svc_push_enable_disclosure =>
      '有効にすると Android の通知権限を要求し、このインストールのエンドポイントと暗号鍵をこのサーバーと共有します。暗号化されたアクティビティ通知にチャット内容は含まれません。サーバーログインで承認されたセッションのみ対象です。';

  @override
  String get rel_svc_push_transport_disclosure =>
      '内蔵配信は Google のプッシュ転送と Google Play 開発者サービスを使用しますが、Firebase SDK は含みません。代わりに任意の UnifiedPush ディストリビューターも使用できます。配信はベストエフォートです。Hermes を開き直して同期してください。';

  @override
  String get rel_svc_push_advanced_transport => '詳細な転送';

  @override
  String get rel_svc_push_automatic_explanation =>
      '自動は既存のディストリビューター選択を維持し、それ以外では利用可能な内蔵 Google 配信を使用します。転送を変更する前に無効化してください。';

  @override
  String get rel_svc_push_transport_label => 'プッシュ転送';

  @override
  String get rel_svc_push_automatic_recommended => '自動（推奨）';

  @override
  String get rel_svc_push_selected_unavailable => '選択したディストリビューター（利用不可）';

  @override
  String get rel_svc_push_no_transport_detected =>
      '利用可能な転送手段が見つかりません。内蔵配信には Google Play 開発者サービスが必要です。ない場合は UnifiedPush ディストリビューターをインストールして設定し、更新してください。';

  @override
  String get rel_svc_push_channel_turns_name => 'Ares ターン';

  @override
  String get rel_svc_push_channel_turns_description => 'バックグラウンドで完了したターンの通知';

  @override
  String get rel_svc_push_channel_attention_name => 'Ares 要対応';

  @override
  String get rel_svc_push_channel_attention_description => '対応が必要な承認と入力リクエスト';

  @override
  String get rel_svc_push_channel_background_name => 'Ares バックグラウンド';

  @override
  String get rel_svc_push_channel_background_description => 'バックグラウンドタスクの完了';

  @override
  String get rel_svc_push_channel_notices_name => 'Ares お知らせ';

  @override
  String get rel_svc_push_channel_notices_description => 'クレジットとプラグインのお知らせ';

  @override
  String get rel_svc_push_diag_not_initialised => '初期化されていません';

  @override
  String get rel_svc_push_diag_replies_off => '返信通知はオフです';

  @override
  String get rel_svc_push_diag_conversation => '会話';

  @override
  String get rel_svc_push_diag_conversation_permission_denied =>
      '会話、権限が拒否されました';

  @override
  String rel_svc_push_diag_conversation_error(String error) {
    return '会話: $error';
  }

  @override
  String get rel_svc_push_diag_failures_off => '失敗通知はオフです';

  @override
  String rel_svc_push_diag_kind_off(String kind) {
    return '$kind はオフです';
  }

  @override
  String get rel_svc_push_diag_windows_setting_unknown =>
      'Windows から通知設定が報告されませんでした';

  @override
  String get rel_svc_backup_not_hermes_configuration_backup =>
      'このファイルは Hermes の設定バックアップではありません。';

  @override
  String get rel_svc_backup_newer_version_cannot_import =>
      'このバックアップは新しいバージョンのアプリで作成されたため、インポートできません。';

  @override
  String get rel_svc_backup_missing_client_certificate =>
      'このバックアップは接続用クライアント証明書を示していますが、その証明書が含まれていないため完全には復元できません。';

  @override
  String get rel_svc_backup_damaged_unreadable =>
      'このバックアップファイルは破損しているため読み取れませんでした。';

  @override
  String get rel_svc_backup_unsupported_preference_type =>
      '保存済み設定に未対応の型があるため、エクスポートできません。';

  @override
  String get rel_svc_backup_choose_passphrase_api_keys =>
      'パスフレーズを選択してください — バックアップには API キーが含まれています。';

  @override
  String get rel_svc_backup_could_not_protect_safely => 'バックアップを安全に保護できませんでした。';

  @override
  String get rel_svc_backup_unsupported_encryption =>
      'このバックアップは未対応の暗号化方式を使用しています。';

  @override
  String get rel_svc_backup_wrong_passphrase_or_altered =>
      'パスフレーズが間違っているか、このバックアップファイルが変更されています。';

  @override
  String get rel_svc_backup_share_subject => 'Hermes 設定バックアップ';

  @override
  String get rel_svc_backup_selected_file_unreadable => 'そのファイルを読み取れませんでした。';

  @override
  String rel_svc_backup_connections_added(int count) {
    return '$count 件追加';
  }

  @override
  String rel_svc_backup_connections_updated(int count) {
    return '$count 件更新';
  }

  @override
  String rel_svc_backup_connections_removed(int count) {
    return '$count 件削除';
  }

  @override
  String get rel_svc_backup_no_connection_changes => '接続の変更なし';

  @override
  String rel_svc_backup_connections_summary(String changes) {
    return '接続: $changes';
  }

  @override
  String rel_svc_backup_restore_summary(String connections, int count) {
    return '$connections · $count 件の設定を復元';
  }

  @override
  String rel_svc_backup_certificate_not_included(String label, String error) {
    return '「$label」のクライアント証明書をこのバックアップに含められませんでした: $error';
  }

  @override
  String get rel_svc_backup_certificate_password_needed =>
      'この証明書にはパスワードが必要です。下に入力すると自動的に開きます。';

  @override
  String get rel_svc_backup_certificate_password_or_corrupt =>
      '証明書のパスワードが間違っているか、ファイルが破損しています。';

  @override
  String get rel_svc_backup_certificate_password_incorrect =>
      '証明書のパスワードが間違っています。';

  @override
  String get rel_svc_backup_certificate_unsupported_encryption =>
      'この証明書はアプリが読み取れない暗号化方式を使用しています。';

  @override
  String get rel_svc_backup_certificate_unreadable_pkcs12 =>
      '選択したファイルは読み取り可能な PKCS#12（.p12/.pfx）証明書ではありません。';

  @override
  String get rel_svc_backup_certificate_unreadable => '選択した証明書を読み取れませんでした。';

  @override
  String get rel_svc_backup_not_certificate_file =>
      'そのファイルは証明書ではありません。.p12/.pfx コンテナ、または PEM 証明書とキーファイルを選択してください。';

  @override
  String get rel_svc_backup_not_pem_certificate => '選択した証明書は PEM 証明書ではありません。';

  @override
  String get rel_svc_backup_not_pem_private_key => '選択した秘密鍵は PEM 秘密鍵ではありません。';

  @override
  String get rel_svc_backup_certificate_pair_unloadable =>
      '選択した証明書と秘密鍵を読み込めませんでした。';

  @override
  String get rel_svc_backup_saved_certificate_files_unreadable =>
      '保存済みのクライアント証明書ファイルを読み取れませんでした。';

  @override
  String get rel_svc_backup_client_certificate_storage_failed =>
      'クライアント証明書をこのデバイスに安全に保存できませんでした。';

  @override
  String get rel_svc_backup_certificate_storage_failed =>
      '証明書をこのデバイスに安全に保存できませんでした。';

  @override
  String get rel_svc_backup_client_certificate_label => 'クライアント証明書';

  @override
  String rel_svc_backup_search_dashboard_unreachable(String error) {
    return 'ダッシュボードに接続できませんでした: $error';
  }

  @override
  String get rel_svc_backup_search_credentials_rejected =>
      'ダッシュボードが保存済みの認証情報を拒否しました。この接続のダッシュボードのユーザー名とパスワードを確認してください。';

  @override
  String get rel_svc_backup_search_not_supported =>
      'このダッシュボードはセッション検索を提供していません。ホストの Hermes を更新するか、デバイス上の検索に戻してください。';

  @override
  String rel_svc_backup_search_redirected(int statusCode) {
    return 'ダッシュボードがセッション検索をリダイレクトしました（HTTP $statusCode）。Ares は保存済み認証情報を伴うリダイレクトに従いません。接続アドレスを確認してください。';
  }

  @override
  String rel_svc_backup_search_http_failed(int statusCode) {
    return 'セッション検索が HTTP $statusCode で失敗しました。';
  }

  @override
  String get rel_svc_backup_search_malformed_response =>
      'ダッシュボードから不正な形式の検索応答が返されました。';

  @override
  String get rel_svc_backup_search_unexpected_response =>
      'ダッシュボードから予期しない検索応答が返されました。';

  @override
  String get rel_svc_backup_search_too_many_results =>
      'ダッシュボードから要求数を超える検索結果が返されました。';

  @override
  String get rel_svc_backup_message_search_unexpected_response =>
      'メッセージ検索から予期しない応答が返されました。';

  @override
  String get rel_svc_backup_message_search_unexpected_result =>
      'メッセージ検索に予期しない結果が含まれています。';

  @override
  String get rel_svc_backup_ai_search_api_key_rejected =>
      'Hermes API が保存済み API キーを拒否しました。';

  @override
  String rel_svc_backup_ai_search_http_failed(int statusCode) {
    return 'AI クエリの書き換えが HTTP $statusCode で失敗しました。';
  }

  @override
  String get rel_svc_backup_ai_search_no_usable_query =>
      '選択したモデルから使用可能な検索クエリが返されませんでした。';

  @override
  String get rel_svc_backup_ai_search_malformed_response =>
      'Hermes から不正な形式の AI 書き換え応答が返されました。';

  @override
  String get rel_svc_backup_space_name_already_exists => 'この名前のスペースはすでに存在します';

  @override
  String get rel_svc_backup_space_name_length_invalid =>
      'スペース名は 1～80 文字にしてください';

  @override
  String get ng_rel_svc_backup_gateway_address_required =>
      'Hermes ダッシュボードのアドレスを入力してください。';

  @override
  String ng_rel_svc_backup_gateway_address_scheme(String scheme) {
    return 'アドレスは http:// または https:// で始まる必要があります（入力: $scheme）。';
  }

  @override
  String get ng_rel_svc_backup_gateway_address_invalid => 'そのアドレスは無効です。';

  @override
  String get ng_rel_svc_backup_gateway_address_no_host => 'アドレスにホスト名がありません。';

  @override
  String get ng_rel_svc_backup_sign_in_main_window => 'メインウィンドウでサインインしてください。';

  @override
  String get rel_svc_backup_sign_in_renewal_failed =>
      'ゲートウェイは現在サインインを更新できませんでした。';

  @override
  String get rel_svc_backup_sign_in_provider_unreachable =>
      'ゲートウェイはサインインを更新できませんでした。サインインプロバイダーに接続できません。';

  @override
  String get rel_svc_backup_sign_in_renewal_timed_out => 'サインインの更新がタイムアウトしました。';

  @override
  String get rel_svc_backup_sign_in_no_tokens => 'ゲートウェイからサインイントークンが返されませんでした。';

  @override
  String get ng_rel_svc_backup_probe_timed_out =>
      'タイムアウトしました。アドレス、VPN、または Tailscale 接続を確認してください。';

  @override
  String ng_rel_svc_backup_probe_tls_failed(String error) {
    return 'TLS ハンドシェイクに失敗しました: $error';
  }

  @override
  String ng_rel_svc_backup_gateway_answered_http(int statusCode) {
    return 'ゲートウェイが HTTP $statusCode を返しました。';
  }

  @override
  String get ng_rel_svc_backup_gateway_answer_timed_out =>
      'ゲートウェイの応答に時間がかかりすぎました。';

  @override
  String ng_rel_svc_backup_browser_callback_not_ready(String error) {
    return 'ブラウザーから戻る準備ができませんでした: $error';
  }

  @override
  String get ng_rel_svc_backup_browser_signed_in_body => 'Hermes に戻ることができます。';

  @override
  String get ng_rel_svc_backup_browser_waiting_title => 'サインインを待機中';

  @override
  String get ng_rel_svc_backup_browser_not_current =>
      'このページは現在のサインインの一部ではありません。';

  @override
  String get ng_rel_svc_backup_browser_open_failed => 'サインイン用のブラウザーを開けませんでした。';

  @override
  String get ng_rel_svc_backup_browser_sign_in_timed_out =>
      'サインインに時間がかかりすぎました。もう一度お試しください。';

  @override
  String ng_rel_svc_backup_gateway_refused_sign_in(int statusCode) {
    return 'ゲートウェイがサインインを拒否しました（HTTP $statusCode）。';
  }

  @override
  String get rel_svc_misc_alert_caution => '注意';

  @override
  String get rel_svc_misc_alert_important => '重要';

  @override
  String get rel_svc_misc_alert_tip => 'ヒント';

  @override
  String get rel_svc_misc_alert_warning => '警告';

  @override
  String get rel_svc_misc_allow_folder_session => 'セッションが終了するまでこのフォルダーを許可します。';

  @override
  String get rel_svc_misc_allow_website_session =>
      'セッションが終了するまでこのウェブサイトを許可します。';

  @override
  String rel_svc_misc_approval_needed_title(String title) {
    return '承認が必要です — $title';
  }

  @override
  String get rel_svc_misc_attach_file_reference => 'ファイル参照を添付';

  @override
  String get rel_svc_misc_attach_folder_reference => 'フォルダー参照を添付';

  @override
  String get rel_svc_misc_attach_git_context => 'git コンテキストを添付';

  @override
  String get rel_svc_misc_attach_image_reference => '画像参照を添付';

  @override
  String get rel_svc_misc_attach_staged_diff => 'ステージ済みの差分を添付';

  @override
  String get rel_svc_misc_attach_tool_reference => 'ツール参照を添付';

  @override
  String get rel_svc_misc_attach_unstaged_diff => '未ステージの差分を添付';

  @override
  String get rel_svc_misc_attach_url_reference => 'URL 参照を添付';

  @override
  String get rel_svc_misc_background_task_completed => 'バックグラウンドタスクが完了しました';

  @override
  String rel_svc_misc_background_task_named_completed(String taskId) {
    return 'バックグラウンドタスク $taskId が完了しました';
  }

  @override
  String get rel_svc_misc_chat => 'チャット';

  @override
  String get rel_svc_misc_compacting_context => '会話コンテキストを圧縮しています…';

  @override
  String rel_svc_misc_completed_in(String duration) {
    return '$duration で完了';
  }

  @override
  String get rel_svc_misc_context_compacted => '会話コンテキストを圧縮しました';

  @override
  String get rel_svc_misc_cron_readback_mismatch => 'Cron モデルの読み戻しが一致しませんでした';

  @override
  String get rel_svc_misc_cron_update_rejected => 'Cron の更新が拒否されました';

  @override
  String get rel_svc_misc_deny_folder_grant => 'このフォルダーへのアクセスを許可しません。';

  @override
  String get rel_svc_misc_deny_website_grant => 'このウェブサイトへのアクセスを許可しません。';

  @override
  String rel_svc_misc_failed_after(String duration) {
    return '$duration 後に失敗';
  }

  @override
  String get rel_svc_misc_gateway_folder_unnamed => 'ゲートウェイがフォルダーを指定しませんでした。';

  @override
  String get rel_svc_misc_gateway_idle_unconfirmed =>
      'ゲートウェイはアイドル状態です。前のターンの結果を確認できませんでした。';

  @override
  String get rel_svc_misc_gateway_turn_failed => 'ゲートウェイのターンに失敗しました';

  @override
  String rel_svc_misc_gateway_turn_status(String status) {
    return 'ゲートウェイのターン: $status';
  }

  @override
  String get rel_svc_misc_gateway_website_unnamed => 'ゲートウェイがウェブサイトを指定しませんでした。';

  @override
  String get rel_svc_misc_hermes_review => 'Hermes レビュー';

  @override
  String get rel_svc_misc_hermes_turn_failed => 'Hermes のターンに失敗しました';

  @override
  String get rel_svc_misc_image_recovery_companion_gap =>
      'コンパニオン復旧では画像とテキストの復旧を利用できません。この接続では確認応答のない画像送信を復元できず、自動的に再送信されることもありません。';

  @override
  String get rel_svc_misc_image_recovery_rest_gap =>
      'Classic REST/SSE では画像とテキストの復旧を利用できません。この接続では確認応答のない画像送信を復元できず、自動的に再送信されることもありません。';

  @override
  String rel_svc_misc_input_needed_title(String title) {
    return '入力が必要です — $title';
  }

  @override
  String get rel_svc_misc_parallel_workspace_connection_changed =>
      '接続が変更されました。ワークスペースを使用するには開き直してください。';

  @override
  String get rel_svc_misc_preparing => '準備中';

  @override
  String get rel_svc_misc_save_folder_grant => '今後のリクエスト用にこのフォルダー権限を保存します。';

  @override
  String get rel_svc_misc_save_website_grant => '今後のリクエスト用にこのウェブサイト権限を保存します。';

  @override
  String get rel_svc_misc_stored_identity_turn_conflict =>
      '別のターンが受け付けられている間に、このチャットは保存済みの識別情報から開かれました。未送信のプロンプトは送信されていません。そのターンの終了後に明示的に再試行してください。';

  @override
  String get rel_svc_misc_untitled => '無題';

  @override
  String get rel_svc_misc_wake_capture_silent =>
      'クライアントのウェイクキャプチャで無音しか検出されません。OS のマイクアクセスを確認し、ウェイクワードを切り替えて再有効化してください。';

  @override
  String get rel_svc_misc_wake_capture_stalled =>
      'クライアントのウェイクキャプチャが停止しました。マイク音声のコールバックが届きませんでした。';

  @override
  String rel_svc_misc_wake_feed_refused(int count, String detail) {
    return 'ウェイクワードフィードが連続する $count フレームを拒否しました$detail。ウェイクワードを切り替えて再有効化してください。';
  }

  @override
  String rel_svc_misc_wake_microphone_failed(String error) {
    return 'クライアントのウェイク用マイクストリームに失敗しました: $error';
  }

  @override
  String get rel_svc_misc_wake_track_ended =>
      'ウェイクワードのキャプチャ中にマイクトラックが終了しました。ウェイクワードを切り替えて再有効化してください。';

  @override
  String get rel_svc_misc_website => 'ウェブサイト';

  @override
  String get rel_svc_lan_timeout => 'LANでの検出がタイムアウトしました';

  @override
  String get rel_svc_notification_permission_denied => '権限が拒否されました';

  @override
  String get rel_svc_notifications_off => '通知はオフです';

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
  String get fleet_managed_ssh_title => 'ゲートウェイ管理のSSH';

  @override
  String get fleet_managed_ssh_intro =>
      'このゲートウェイに保存済みのSSHホストを、どのデバイスからでも管理できます。リモートホストにはHermesがインストール済みである必要があります。この操作は、ゲートウェイが所有するリモートサービスを起動するか、そのサービスに接続するもので、Aresのチャット接続ではありません。管理された更新と復旧は、ネイティブのデスクトップアプリでのみ利用できます。';

  @override
  String get fleet_managed_ssh_read => '保存済みSSHホストを読み込む';

  @override
  String get fleet_managed_ssh_trust =>
      'この初回接続で、ゲートウェイはこのホストのSSH鍵を信頼して記憶します。その後の鍵の変更は検出され、接続がブロックされます。ゲートウェイは鍵のフィンガープリントを通知しないため、Aresでは表示も保存もできません。この初回接続を信頼できる場合のみ続行してください。';

  @override
  String get fleet_managed_ssh_changed =>
      'このホストのSSH鍵が変更されました。接続はブロックされています。ゲートウェイホストにアクセスできる人が、新しい鍵のフィンガープリントを独立した方法で確認し、そのホストで古い信頼済みの鍵を削除する必要があります。この確認と修復が完了してから再試行してください。Aresは信頼済みの鍵を置き換えません。';

  @override
  String get fleet_managed_ssh_disconnect_warning =>
      'SSHトンネルを切断し、このゲートウェイが所有するリモートサービスを停止しますか？そのサービスを利用する他のクライアントに影響する可能性があります。';

  @override
  String get fleet_managed_ssh_verify => '代わりに自分で鍵を確認する';

  @override
  String fleet_managed_ssh_pending(int seconds) {
    return 'ゲートウェイを待機中：$seconds秒。このページを離れても初期設定はキャンセルされません。リクエストが失敗した場合は、再試行する前に状態を確認してください。';
  }

  @override
  String fleet_managed_ssh_status(
    String host,
    int localPort,
    int remotePort,
    String version,
    String reused,
  ) {
    return 'ホスト：$host\nゲートウェイのループバックポート：$localPort\nリモートのループバックポート：$remotePort\nHermes：$version\n再利用：$reused';
  }

  @override
  String get fleet_managed_ssh_disconnect => '切断';

  @override
  String get ng_slash_suggestions_loading => 'コマンドを読み込み中…';

  @override
  String get ng_slash_suggestions_empty => '一致するコマンドはありません';

  @override
  String get ng_slash_suggestions_label => 'コマンドの候補';

  @override
  String get ng_slash_suggestions_skill => 'スキル';

  @override
  String get settings_classic_title => 'Classic 設定';

  @override
  String get settings_nextgen_title => 'NextGen 設定';

  @override
  String get settings_category_general => '一般と言語';

  @override
  String get settings_category_chat => 'チャットとセッション';

  @override
  String get settings_category_device => 'デバイスとショートカット';

  @override
  String get settings_category_connections => '接続とモデル';

  @override
  String get settings_category_security => 'プライバシーとバックアップ';

  @override
  String get settings_category_about => 'アプリ情報とヘルプ';

  @override
  String get settings_reopen_chat => 'ゲートウェイに戻るときに最後のチャットを復元';

  @override
  String get settings_reopen_chat_hint =>
      '新規起動時はようこそ画面が開きます。リンクや通知からは指定されたチャットが開きます。';

  @override
  String get settings_danger => '重要な操作';
}
