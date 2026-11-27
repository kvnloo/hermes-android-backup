// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get attachment_audio_failed =>
      '이 오디오를 재생할 수 없습니다. 형식 또는 코덱이 지원되지 않거나 미리 보기 크기 제한을 초과했을 수 있습니다. 다시 시도하거나 원본 파일을 저장 또는 공유하세요.';

  @override
  String get attachment_audio_seek => '오디오 재생 위치';

  @override
  String get workspace_workers => '실행 중인 하위 에이전트';

  @override
  String get workers_unattached =>
      '개수만 표시됩니다. 지시를 보내려면 연결된 상위 채팅에서 ‘실행 중인 하위 에이전트’를 선택하세요.';

  @override
  String get slash_local_arguments =>
      '이 바로 가기는 여기서 인수를 지원하지 않습니다. 앱의 컨트롤을 사용하세요. 초안은 보관되었습니다.';

  @override
  String get fallback_title => '대체 모델';

  @override
  String get fallback_notice =>
      '기본 모델을 사용할 수 없을 때 순서대로 시도합니다. 변경은 이 프로필에만 적용됩니다. 전체 목록을 명시적으로 저장하세요.';

  @override
  String get fallback_unavailable =>
      '대체 설정을 사용할 수 없거나 올바르지 않습니다. 연결, 선택한 프로필 및 호스트 버전을 확인한 후 다시 시도하세요.';

  @override
  String get fallback_discovery_unavailable =>
      '공급자 목록을 불러올 수 없습니다. 기존 항목은 유지됩니다. 공급자와 모델을 선택하려면 다시 시도하세요.';

  @override
  String get fallback_empty => '이 대체 목록에 항목이 없습니다.';

  @override
  String get fallback_incomplete =>
      '저장하기 전에 모든 항목의 공급자와 모델을 선택하거나 미완성 항목을 삭제하세요.';

  @override
  String get fallback_add => '대체 모델 추가';

  @override
  String get fallback_save => '대체 목록 저장';

  @override
  String get fallback_save_failed =>
      '저장된 대체 목록을 확인할 수 없습니다. 초안은 유지됩니다. 다시 저장하거나 새로고침하여 호스트 설정을 불러오세요.';

  @override
  String get fallback_saved => '대체 목록을 저장하고 확인했습니다.';

  @override
  String get fallback_legacy_title => '이전 대체 설정(읽기 전용)';

  @override
  String get fallback_legacy_notice =>
      '호스트는 이 목록 다음에 fallback_model도 사용하며 중복 경로는 건너뜁니다. 위 목록이 비어 있어도 이전 항목은 유지됩니다. 호스트에서 편집하세요.';

  @override
  String fallback_priority(String position) {
    return '우선순위 $position';
  }

  @override
  String get fallback_move_up => '위로 이동';

  @override
  String get fallback_move_down => '아래로 이동';

  @override
  String get fallback_routing_read_only =>
      '라우팅 세부 정보 또는 목록에 없는 공급자가 유지됩니다. 이 공급자/모델은 호스트에서 편집하세요. 여기서는 순서 변경과 삭제가 가능합니다.';

  @override
  String get cron_model_default => '기본값 따르기';

  @override
  String get cron_model_notice =>
      '이 cron 작업에만 적용됩니다. 고정하지 않으면 Hermes는 cron 기본값을 사용한 다음 주 모델을 사용합니다. 사용자 지정 모델은 호스트에서 관리하세요.';

  @override
  String get model_management_unavailable =>
      '모델 설정을 불러오거나 저장하지 못했습니다. 새로고침한 후 다시 시도하세요.';

  @override
  String get model_management_subtitle => '이 프로필의 기본, 대체 및 보조 모델';

  @override
  String get usage => '사용량';

  @override
  String get nous_portal => 'Nous Portal';

  @override
  String get portal_menu_subtitle => '게이트웨이 상태 및 기록된 사용량';

  @override
  String get portal_read_only =>
      '게이트웨이의 읽기 전용 데이터입니다. Hermes 호스트에서 Nous 인증을 관리하세요. 이 엔드포인트는 구독 잔액이나 크레딧을 제공하지 않습니다.';

  @override
  String get portal_status => '게이트웨이 Portal 상태';

  @override
  String get portal_free_tier => '무료 등급 액세스(로그인된 계정 아님)';

  @override
  String get portal_signed_in => '로그인됨';

  @override
  String get portal_signed_out => '로그인되지 않음';

  @override
  String get portal_account_tier => '계정 등급';

  @override
  String get portal_recorded_usage => '기록된 사용량';

  @override
  String get portal_all_providers =>
      '선택한 게이트웨이 프로필의 모든 제공업체입니다. 기록된 비용이 0이어도 모델이 무료라는 뜻은 아닙니다.';

  @override
  String portal_period(String days) {
    return '최근 $days일';
  }

  @override
  String get portal_sessions => '세션';

  @override
  String get portal_input => '입력 토큰';

  @override
  String get portal_output => '출력 토큰';

  @override
  String get portal_estimated => '기록된 예상 비용';

  @override
  String get portal_actual => '기록된 실제 비용';

  @override
  String get portal_recorded_models => '기록된 모델';

  @override
  String get portal_no_models => '기록된 모델이 없습니다.';

  @override
  String get portal_unavailable =>
      '사용할 수 없습니다. 연결, 선택한 프로필 및 게이트웨이 버전을 확인한 후 다시 시도하세요.';

  @override
  String get paste_attachment_failed_text_kept =>
      '붙여넣은 텍스트를 첨부하지 못했습니다. 텍스트는 메시지에 유지됩니다.';

  @override
  String get background_task_report => '백그라운드 작업';

  @override
  String get background_process_report => '백그라운드 프로세스';

  @override
  String get background_report_issues => '문제가 보고되었습니다. 펼쳐서 자세히 확인하세요.';

  @override
  String get background_report_expand => '보고서 펼치기';

  @override
  String get background_report_collapse => '보고서 접기';

  @override
  String get ng_brand_open_chat => '채팅 열기';

  @override
  String get ng_brand_recent => '최근 채팅';

  @override
  String get ng_brand_sidebar_hint => '또는 사이드바에서 채팅을 선택하세요';

  @override
  String get copy_session_id => '세션 ID 복사';

  @override
  String get copy_session_id_failed => '세션 ID를 복사하지 못했습니다.';

  @override
  String get setup_interface_title => '인터페이스 선택';

  @override
  String get setup_interface_classic => 'Classic';

  @override
  String get setup_interface_nextgen => 'NextGen';

  @override
  String get setup_interface_classic_description =>
      '모든 연결 설정과 Classic 설정을 갖춘 기존 Ares 작업 공간입니다.';

  @override
  String get setup_interface_nextgen_description =>
      '한 번의 대시보드 로그인, 실시간 계획, 하위 에이전트, 알림을 제공하는 새로운 인터페이스입니다.';

  @override
  String get setup_interface_switch_later => '설정에서 언제든지 전환할 수 있습니다.';

  @override
  String get ng_confirm_model_switch => '모델을 전환할까요?';

  @override
  String get ng_switch => '전환';

  @override
  String get ng_model_confirmation_required => '이 모델을 선택하려면 확인이 필요합니다.';

  @override
  String ng_model_switches_next_turn(String model) {
    return '다음 턴에 $model(으)로 전환합니다.';
  }

  @override
  String get ng_model_switch_not_connected =>
      '채팅에서 모델을 전환할 준비가 되지 않았습니다. 채팅을 다시 열고 시도하세요.';

  @override
  String ng_gateway_kept_default_model(String model) {
    return '게이트웨이가 이 채팅에서 $model을(를) 유지했습니다. 보내기 전에 모델을 다시 선택하세요.';
  }

  @override
  String get hands_free_title => '핸즈프리';

  @override
  String get hands_free_start => '핸즈프리 시작';

  @override
  String get hands_free_stop => '핸즈프리 중지';

  @override
  String get hands_free_preparing => '음성 준비 중 — 기다려 주세요';

  @override
  String get hands_free_listening => 'Hey Hermes라고 말하세요';

  @override
  String get hands_free_recording => '준비 완료 — 말씀하세요';

  @override
  String get hands_free_waiting => 'Hermes 응답 대기 중';

  @override
  String get hands_free_speaking => '읽는 중 — 마이크 꺼짐';

  @override
  String hands_free_followup(int seconds) {
    return '최대 $seconds초 동안 듣기';
  }

  @override
  String get hands_free_error => '핸즈프리 중지됨';

  @override
  String get hands_free_setup => '핸즈프리 설정';

  @override
  String hands_free_preview(String transcript) {
    return '음성 미리보기: $transcript';
  }

  @override
  String get hands_free_short_disclosure =>
      '이 채팅이 전면에 열려 있을 때만 동작합니다. 호출 감지는 오프라인이며 음성은 네트워크를 사용할 수 있습니다. 배터리를 소모합니다.';

  @override
  String get hands_free_error_action =>
      '마이크 권한, 음성 서비스, 응답 음성 및 연결을 확인한 후 중지하고 다시 시작하세요. 자동 재전송하지 않습니다.';

  @override
  String get hands_free_disclosure =>
      '호출 감지는 CPU에서 오프라인으로 동작합니다. Android 음성 인식, 선택한 음성 및 게이트웨이는 네트워크를 사용할 수 있습니다. 배터리를 소모하고 오작동할 수 있습니다. 채팅이 가려지거나 닫히거나 전면을 떠나면 중지하며 자동 재개하지 않습니다. 수동 받아쓰기는 편집 가능한 초안으로 남습니다.';

  @override
  String get hands_free_ready_cue =>
      '“Hey Hermes”라고 말하고 준비 완료를 기다린 후 말씀하세요. 한 번에 이어 말하기나 사전 녹음은 지원하지 않습니다. 권한 설정으로 앱을 떠난 경우 허용 후 다시 시작하세요.';

  @override
  String get hands_free_settings_title => '핸즈프리 음성';

  @override
  String get hands_free_settings_subtitle =>
      '채팅에 \"Hey Hermes\" 시작 컨트롤을 표시합니다. 끄면 실행 중인 핸즈프리 세션이 중지됩니다.';

  @override
  String get hands_free_timing_limit =>
      '후속 입력 시간은 최댓값이며 최솟값이 아닙니다. Android가 더 일찍 중지할 수 있습니다. 무음이면 인식을 반복하지 않고 로컬 호출 대기로 돌아갑니다.';

  @override
  String get hands_free_followup_off => '후속 입력 꺼짐 — 입력할 때마다 Hey Hermes라고 말하세요';

  @override
  String get hands_free_start_blocked =>
      '빈 초안, 첨부 없음, 작업 중이 아닌 연결된 채팅 및 응답 읽기 켜짐이 필요합니다. 수동 음성 작업을 먼저 마치세요.';

  @override
  String get hands_free_setup_complete => '마이크 설정이 끝났습니다. 다시 시작하세요.';

  @override
  String message_time_recorded(String time) {
    return '서버 기록 시각: $time (현지 시각)';
  }

  @override
  String message_time_sent(String time) {
    return '이 기기에서 전송 감지: $time (현지 시각)';
  }

  @override
  String message_time_received(String time) {
    return '이 기기에서 처음 수신한 시각: $time (현지 시각)';
  }

  @override
  String get stop_and_send => '중지 후 보내기';

  @override
  String get message_queued_for_running_turn => '현재 실행에 메시지를 대기열로 추가했습니다.';

  @override
  String get running_message_not_accepted =>
      'Hermes가 이 메시지를 수락하지 못했습니다. 초안은 유지됩니다. 응답을 중지하거나 기다린 후 다시 보내세요.';

  @override
  String get running_message_delivery_unknown =>
      '메시지 전달을 확인하지 못했습니다. 초안은 유지됩니다. 다시 시도하기 전에 채팅을 확인하세요.';

  @override
  String get attachment_tap_to_preview => '탭하여 미리 보기';

  @override
  String get attachment_save => '저장';

  @override
  String get attachment_share => '공유';

  @override
  String get attachment_saved => '파일을 저장했습니다';

  @override
  String get attachment_save_cancelled => '저장을 취소했습니다';

  @override
  String get attachment_save_failed => '이 파일을 저장하지 못했습니다. 다시 시도해 주세요.';

  @override
  String get attachment_share_failed => '이 파일을 공유하지 못했습니다. 다시 시도해 주세요.';

  @override
  String get attachment_download_failed =>
      '이 파일을 불러오지 못했습니다. 연결을 확인하고 다시 시도해 주세요.';

  @override
  String get attachment_no_inline_preview =>
      '이 파일 형식은 미리 볼 수 없습니다. 원본 파일을 저장하거나 공유하여 다른 앱에서 여세요.';

  @override
  String get attachment_image_failed =>
      '이 이미지를 디코딩하지 못했습니다. 원본 파일은 저장하거나 공유할 수 있습니다.';

  @override
  String get attachment_text_truncated =>
      '미리 보기가 축약되었습니다. 전체 내용을 읽으려면 파일을 저장하거나 공유하세요.';

  @override
  String get attachment_text_unavailable =>
      '이 파일을 텍스트로 표시하지 못했습니다. 원본 파일을 저장하거나 공유하세요.';

  @override
  String get attachment_pdf_failed => '이 PDF를 미리 볼 수 없습니다. 원본 파일을 저장하거나 공유하세요.';

  @override
  String get attachment_pdf_unavailable =>
      'PDF 미리 보기는 Android에서 사용할 수 있습니다. 이 파일은 저장하거나 공유할 수 있습니다.';

  @override
  String attachment_pdf_page(int page, int total) {
    return '$total페이지 중 $page페이지';
  }

  @override
  String get attachment_previous_page => '이전 페이지';

  @override
  String get attachment_next_page => '다음 페이지';

  @override
  String get attachment_loading => '미리 보기 불러오는 중…';

  @override
  String get attachment_document_text_notice =>
      '텍스트 미리 보기입니다. 레이아웃, 이미지 및 서식이 원본과 다를 수 있습니다.';

  @override
  String get attachment_document_failed =>
      '이 문서를 미리 볼 수 없습니다. 원본 파일을 저장하거나 공유하세요.';

  @override
  String get attachment_document_empty => '이 문서에서 읽을 수 있는 텍스트를 찾지 못했습니다.';

  @override
  String get attachment_video_failed =>
      '이 동영상을 재생할 수 없습니다. 형식이나 코덱이 지원되지 않을 수 있습니다. 원본 파일을 저장하거나 공유하세요.';

  @override
  String get attachment_video_play => '재생';

  @override
  String get attachment_video_pause => '일시 정지';

  @override
  String get attachment_video_mute => '음소거';

  @override
  String get attachment_video_unmute => '음소거 해제';

  @override
  String get attachment_video_seek => '동영상 재생 위치';

  @override
  String get attachment_close => '미리 보기 닫기';

  @override
  String get attachment_retry => '다시 시도';

  @override
  String get saved_history_heading => '저장된 기록';

  @override
  String get received_output_heading => '수신한 출력 — 저장된 기록과의 일치 여부 미확인';

  @override
  String get received_output_details => '수신한 출력 정보';

  @override
  String get received_output_explanation =>
      '저장된 기록에도 포함되어 있을 수 있습니다. 앱에서는 일치 여부를 확인할 수 없습니다.';

  @override
  String get local_prompt_context => '로컬 프롬프트 컨텍스트';

  @override
  String get received_output_badge => '수신됨 · 일치 여부 미확인';

  @override
  String get received_output_lifetime =>
      '수신한 출력은 이 앱 세션 동안 임시로 보관되며, 한도에 도달하면 줄어들거나 삭제될 수 있습니다. 앱이나 연결을 종료하면 사용할 수 없을 수도 있습니다.';

  @override
  String get theme_palette => '색상 테마';

  @override
  String get theme_palette_gold => '금색';

  @override
  String get theme_palette_purple => '보라색';

  @override
  String get theme_palette_orange => '주황색';

  @override
  String get theme_palette_green => '초록색';

  @override
  String get theme_palette_blue => '파란색';

  @override
  String get theme_palette_red => '빨간색';

  @override
  String get theme_palette_teal => '청록색';

  @override
  String get theme_palette_pink => '분홍색';

  @override
  String get theme_palette_indigo => '남색';

  @override
  String get theme_palette_cyan => '시안';

  @override
  String get assets_recent_subtitle => '저장된 채팅에서 Hermes가 공유한 파일 찾기';

  @override
  String get assets_scope_notice =>
      '저장된 답변에서 Hermes가 명시적으로 공유한 생성된 파일입니다. 채팅 기록의 일부만 보여 주며, 모든 파일이나 첨부 파일을 망라한 목록은 아닙니다. 참조된 파일이 더 이상 존재하지 않을 수 있습니다.';

  @override
  String get assets_download_limit =>
      '파일은 탭할 때만 불러옵니다. 미리보기와 다운로드는 각각 파일당 25 MiB로 제한됩니다. 더 큰 파일은 대시보드를 이용하세요.';

  @override
  String get assets_search_hint => '찾은 파일이나 원본 채팅 검색';

  @override
  String get assets_all => '전체';

  @override
  String get assets_images => '이미지';

  @override
  String get assets_audio => '오디오';

  @override
  String get assets_video => '동영상';

  @override
  String get assets_documents => '문서 및 기타 파일';

  @override
  String get assets_empty => '살펴본 메시지에서 에셋을 찾지 못했습니다';

  @override
  String get assets_empty_detail =>
      '채팅을 더 살펴보거나 이전 메시지를 살펴보면 더 오래된 기록을 확인할 수 있습니다. 일반 첨부 파일과 링크가 없는 파일은 여기에 색인되지 않습니다.';

  @override
  String get assets_no_matches => '일치하는 에셋 없음';

  @override
  String get assets_load_more_chats => '채팅 더 살펴보기';

  @override
  String get assets_load_older_messages => '이전 메시지 살펴보기';

  @override
  String get assets_load_failed =>
      '일부 기록을 읽지 못했습니다. 결과가 불완전합니다. 대시보드 연결을 확인하고 다시 시도하세요.';

  @override
  String get assets_retry_failed => '읽지 못한 기록 다시 불러오기';

  @override
  String get assets_partial => '서버에서 기록이 불완전하다고 보고했습니다. 대시보드를 확인한 후 새로고침하세요.';

  @override
  String assets_scan_summary(int files, int chats) {
    return '살펴본 채팅 $chats개에서 파일 참조 $files개 발견';
  }

  @override
  String assets_open_chat(String title) {
    return '채팅 열기: $title';
  }

  @override
  String get assets_file_too_large =>
      '이 파일은 다운로드 크기 제한을 초과합니다. 대시보드를 열어 다운로드하세요.';

  @override
  String get a_one_off_question_archives_itself_after_72_hours_anything =>
      '일회성 질문입니다. 72시간 후에 자동으로 보관 처리되며, 보관할 가치가 있는 내용은 기억에 유지됩니다.';

  @override
  String get archive_chat => '채팅 보관';

  @override
  String get unarchive_chat => '채팅 보관 해제';

  @override
  String get chat_archived => '채팅이 보관되었습니다';

  @override
  String get chat_unarchived => '채팅 보관이 해제되었습니다';

  @override
  String could_not_update_chat_archive(Object error) {
    return '채팅 보관 상태를 변경할 수 없습니다: $error';
  }

  @override
  String get quick_chat_description => '일회성 질문입니다.';

  @override
  String get ai_full_text => 'AI + 전문 검색';

  @override
  String get ai_search_model => 'AI 검색 모델';

  @override
  String ai_searched_for(Object aiRewrittenQuery) {
    return 'AI 검색어: $aiRewrittenQuery';
  }

  @override
  String get ai_assisted_filing => 'AI 지원 정리';

  @override
  String get api_key => 'API 키';

  @override
  String get api_server_key_from_hermes_env => '~/.hermes/.env의 API_SERVER_KEY';

  @override
  String get active => '활성';

  @override
  String get activity => '활동';

  @override
  String get activity_reads_the_durable_turn_journal_to_know_what_hermes =>
      '활동 기능은 영구 턴 저널을 읽어 Hermes의 작업 내용을 파악합니다. 게이트웨이 연결 상태를 확인한 후 다시 시도하세요.';

  @override
  String get add => '추가';

  @override
  String get add_connection => '연결 추가';

  @override
  String get add_cron_job => 'Cron 작업 추가';

  @override
  String get add_gateway_connection => '게이트웨이 연결 추가';

  @override
  String get add_and_update_connections_from_the_backup_keep_the_rest =>
      '백업에서 연결을 추가 및 업데이트하고 나머지는 유지합니다.';

  @override
  String get add_attachment => '첨부 파일 추가';

  @override
  String get add_new_cron_job => '새 Cron 작업 추가';

  @override
  String get add_to_chat => '채팅에 추가';

  @override
  String get all_chats => '모든 채팅';

  @override
  String get all_stored_message_content => '저장된 모든 메시지 콘텐츠';

  @override
  String get allow_for_this_session => '이번 세션 동안 허용';

  @override
  String get allow_matching_commands_until_this_hermes_session_ends =>
      '이 Hermes 세션이 끝날 때까지 일치하는 명령을 허용합니다.';

  @override
  String get allow_folder_until_sandbox_off => '샌드박스가 꺼질 때까지 이 폴더를 허용합니다.';

  @override
  String get allow_once => '한 번 허용';

  @override
  String get allow_website_until_sandbox_off => '샌드박스가 꺼질 때까지 이 웹사이트를 허용합니다.';

  @override
  String get always_allow => '항상 허용';

  @override
  String get apply_to_this_chat => '이 채팅에 적용';

  @override
  String get approval_needed => '승인 필요';

  @override
  String get approval_needed_description => '명령이 승인 또는 거부를 기다리고 있습니다.';

  @override
  String get approve => '승인';

  @override
  String get archive => '보관';

  @override
  String get archive_project => '프로젝트 보관';

  @override
  String archive_2(Object projectName) {
    return '$projectName을(를) 보관하시겠습니까?';
  }

  @override
  String archive_3(Object name) {
    return '$name을(를) 보관하시겠습니까?';
  }

  @override
  String get archived => '보관됨';

  @override
  String get archived_conversations_appear_here =>
      '보관한 대화만 여기에 표시됩니다. 이전 채팅은 모든 채팅에 남아 있습니다.';

  @override
  String get archived_quick_chats => '보관된 빠른 채팅';

  @override
  String get artifacts_attachments_and_generated_media =>
      '아티팩트, 첨부 파일, 생성된 미디어';

  @override
  String get ask_ai_to_find_a_conversation => 'AI에게 대화 찾기 요청';

  @override
  String get assets => '에셋';

  @override
  String get assets_need_a_server_authoritative_assets_index_in_the_hermes =>
      '에셋을 프로젝트별로 표시하려면 Hermes 게이트웨이에 서버 권한 에셋 색인이 필요합니다.';

  @override
  String get assets_unavailable => '에셋을 사용할 수 없음';

  @override
  String get attach_image_or_file => '이미지 또는 파일 첨부';

  @override
  String get attachment_drafts => '첨부 파일 초안';

  @override
  String get recover_text_draft => '텍스트 초안 복구';

  @override
  String get undo_draft_recovery => '실행 취소';

  @override
  String get draft_session_exists => '이 채팅은 아직 존재합니다. 채팅을 열어 초안을 이어서 작성하세요.';

  @override
  String get draft_recovery_unavailable => '초안을 확인할 수 없습니다. 변경된 내용이 없습니다.';

  @override
  String attachment_of(Object index, Object total) {
    return '첨부 파일 $index/$total';
  }

  @override
  String get auto_device_default => '자동 (기기 기본값)';

  @override
  String get agent => '에이전트';

  @override
  String get autonomous_agents => '자율 에이전트';

  @override
  String get background_recovery_unavailable_legacy_transport =>
      '백그라운드 복구를 사용할 수 없음 — 레거시 전송';

  @override
  String get background_task_completed => '백그라운드 작업 완료';

  @override
  String get background_task_completed_description => '백그라운드 터미널 명령이 완료되었습니다.';

  @override
  String get backup_restore => '백업 및 복원';

  @override
  String backup_exported(Object destination) {
    return '백업 내보내기 완료 — $destination';
  }

  @override
  String get base_url => '기본 URL';

  @override
  String get binary_preview_is_unavailable_download_the_file_to_open_it =>
      '이진 미리보기를 사용할 수 없습니다. 파일을 다운로드하여 여세요.';

  @override
  String get branch => '분기';

  @override
  String get branch_chat => '채팅 분기';

  @override
  String get branch_created_in_hermes_history => 'Hermes 기록에 분기가 생성되었습니다.';

  @override
  String get browse_and_manage_your_hermes_agent_sessions_from_your_phone =>
      '휴대전화에서 Hermes Agent 세션을 탐색하고 관리하세요. 로컬 네트워크에서 실행 중인 Hermes 대시보드에 연결합니다.';

  @override
  String get browse_server_files => '서버 파일 찾아보기';

  @override
  String get browse_the_miniserver_folders_behind_your_projects =>
      '프로젝트 뒤에 있는 miniserver 폴더 찾아보기';

  @override
  String get cancel => '취소';

  @override
  String get cancel_voice_input => '음성 입력 취소';

  @override
  String cannot_reach(Object host, Object port) {
    return '$host:$port에 연결할 수 없습니다.';
  }

  @override
  String cannot_reach_check_the_host_and_port(Object host, Object port) {
    return '$host:$port에 연결할 수 없습니다. 호스트와 포트를 확인하세요.';
  }

  @override
  String get change_ai_search_model => 'AI 검색 모델 변경';

  @override
  String changes_the_default_for_use_the_selector_in_a_chat(Object label) {
    return '$label의 기본값을 변경합니다. 해당 대화에서만 재정의하려면 채팅 내 선택기를 사용하세요.';
  }

  @override
  String get chat_actions => '채팅 작업';

  @override
  String get chats => '채팅';

  @override
  String get chats_from_this_gateway_are_not_grouped_yet_grouping_stays =>
      '이 게이트웨이의 채팅은 아직 그룹화되지 않았습니다. 그룹화는 게이트웨이가 프로젝트를 호스팅할 수 있을 때까지 이 휴대전화에 유지됩니다.';

  @override
  String get chats_in_this_project_will_show_their_state_and_last =>
      '이 프로젝트의 채팅은 여기에 상태와 마지막 활동을 표시합니다.';

  @override
  String get chats_that_are_not_assigned_to_a_project => '프로젝트에 할당되지 않은 채팅';

  @override
  String get chats_you_start_in_this_project_will_appear_here_on =>
      '이 프로젝트에서 시작한 채팅은 이 Hermes에 로그인된 모든 기기에 여기에 표시됩니다.';

  @override
  String get check_that_the_gateway_is_running_and_reachable_then_try =>
      '게이트웨이가 실행 중이고 도달 가능한지 확인한 후 다시 시도하세요.';

  @override
  String get check_the_dashboard_connection_and_try_again =>
      '대시보드 연결을 확인하고 다시 시도하세요.';

  @override
  String get check_the_connection_and_try_again => '연결을 확인하고 다시 시도하세요.';

  @override
  String get choose_a_small_model_to_rewrite_queries => '쿼리를 재작성할 소형 모델을 선택하세요';

  @override
  String get choose_an_ai_search_model_before_using_ai_search =>
      'AI 검색을 사용하기 전에 AI 검색 모델을 선택하세요.';

  @override
  String get choose_an_active_project_next => '다음으로 활성 프로젝트 선택';

  @override
  String get choose_chat_model => '채팅 모델 선택';

  @override
  String get choose_files => '파일 선택';

  @override
  String get choose_image => '이미지 선택';

  @override
  String get choose_images => '이미지 선택';

  @override
  String get choose_its_destination_space => '대상 스페이스 선택';

  @override
  String get clear_search => '검색 지우기';

  @override
  String get close => '닫기';

  @override
  String get code_copied => '코드가 복사되었습니다';

  @override
  String get code_format => '코드';

  @override
  String get coming_next => '예정된 기능';

  @override
  String get command => '명령';

  @override
  String get command_palette => '명령 팔레트';

  @override
  String get command_palette_hint => '명령 입력';

  @override
  String get command_palette_no_results => '명령을 찾을 수 없습니다';

  @override
  String get command_palette_new_chat => '새 채팅';

  @override
  String get command_palette_search_chats => '채팅 검색';

  @override
  String get command_palette_toggle_theme => '테마 전환';

  @override
  String get command_palette_copy_last_code => '마지막 코드 블록 복사';

  @override
  String get command_line_chats => '명령줄 채팅';

  @override
  String get compatibility_mode => '호환성 모드';

  @override
  String get configure_a_valid_desktop_gateway_url_before_attaching_files =>
      '파일을 첨부하기 전에 올바른 Desktop Gateway URL을 설정하세요.';

  @override
  String get confirm_always_allow => '항상 허용 확인';

  @override
  String get confirm_passphrase => '패스프레이즈 확인';

  @override
  String connecting_to(Object baseUrl) {
    return '$baseUrl에 연결 중...';
  }

  @override
  String get connection_issue => '연결 문제';

  @override
  String
  get connection_switched_the_running_reply_continues_on_the_server_and =>
      '연결이 전환되었습니다. 실행 중인 응답은 서버에서 계속 진행되며 자동으로 다시 연결됩니다.';

  @override
  String get connection_appearance_and_device_preferences => '연결, 외관 및 기기 환경설정';

  @override
  String context_tokens(Object effectiveContextLength) {
    return '컨텍스트: $effectiveContextLength 토큰';
  }

  @override
  String get continue_label => '계속';

  @override
  String get continue_working => '작업 계속하기';

  @override
  String get conversations_in_this_project => '이 프로젝트의 대화';

  @override
  String get copy_code => '코드 복사';

  @override
  String get copy_message => '메시지 복사';

  @override
  String could_not_branch_chat(Object error) {
    return '채팅을 분기할 수 없습니다: $error';
  }

  @override
  String could_not_delete_session(Object error) {
    return '세션을 삭제할 수 없습니다: $error';
  }

  @override
  String could_not_deny_the_command(Object error) {
    return '명령을 거부할 수 없습니다: $error';
  }

  @override
  String could_not_load_ai_search_models(Object error) {
    return 'AI 검색 모델을 불러올 수 없습니다: $error';
  }

  @override
  String get could_not_load_conversations => '대화를 불러올 수 없습니다';

  @override
  String get could_not_load_files => '파일을 불러올 수 없습니다';

  @override
  String could_not_load_models_for_this_profile(Object error) {
    return '이 프로필의 모델을 불러올 수 없습니다: $error';
  }

  @override
  String could_not_load_more_chats(Object error) {
    return '채팅을 더 불러올 수 없습니다: $error';
  }

  @override
  String get could_not_open_link => '이 링크를 열 수 없습니다.';

  @override
  String get could_not_open_the_hermes_dashboard => 'Hermes 대시보드를 열 수 없습니다.';

  @override
  String get could_not_open_this_project => '이 프로젝트를 열 수 없습니다';

  @override
  String get could_not_preview_file => '파일을 미리 볼 수 없습니다';

  @override
  String get could_not_reach_hermes => 'Hermes에 연결할 수 없습니다';

  @override
  String could_not_reach_authenticate_the_dashboard_at_check_the_port(
    Object dashboardPort,
    Object host,
  ) {
    return '$host:$dashboardPort의 대시보드에 연결하거나 인증할 수 없습니다. 포트와 자격 증명을 확인하세요.';
  }

  @override
  String get could_not_read_activity => '활동을 읽을 수 없습니다';

  @override
  String could_not_rename_chat(Object error) {
    return '채팅 이름을 변경할 수 없습니다: $error';
  }

  @override
  String could_not_send_the_approval(Object error) {
    return '승인을 보낼 수 없습니다: $error';
  }

  @override
  String get could_not_skip_the_hermes_question => 'Hermes 질문을 건너뛸 수 없습니다.';

  @override
  String could_not_the_project(Object action, Object error) {
    return '프로젝트를 $action할 수 없습니다: $error';
  }

  @override
  String get couldn_t_delete_project => '프로젝트를 삭제할 수 없습니다';

  @override
  String couldn_t_load_runs(Object error) {
    return '실행 기록을 불러올 수 없습니다: $error';
  }

  @override
  String get couldn_t_move_conversation => '대화를 이동할 수 없습니다';

  @override
  String couldn_t_move_to(Object label, Object reason) {
    return '$label(으)로 이동할 수 없습니다: $reason';
  }

  @override
  String get couldn_t_prepare_the_shared_files => '공유 파일을 준비할 수 없습니다.';

  @override
  String get couldn_t_promote_conversation => '대화를 승격할 수 없습니다';

  @override
  String couldn_t_project(Object action) {
    return '프로젝트를 $action할 수 없습니다';
  }

  @override
  String get create => '만들기';

  @override
  String get create_a_project => '프로젝트 만들기';

  @override
  String get create_a_project_first_then_chats_can_live_inside_it =>
      '프로젝트를 먼저 만들면 그 안에 채팅을 보관할 수 있습니다.';

  @override
  String get create_a_space_to_separate_related_conversations =>
      '관련 대화를 분리할 스페이스를 만드세요.';

  @override
  String get create_branch => '분기 만들기';

  @override
  String get credit_notifications => '크레딧 알림';

  @override
  String get credit_notifications_description => '크레딧 사용이 중지되거나 복구되었습니다.';

  @override
  String get cron => 'Cron';

  @override
  String get crons => 'Cron 작업';

  @override
  String get cron_conversations_empty => '이전 실행을 포함한 예약 작업의 대화가 여기에 표시됩니다.';

  @override
  String get search_cron_conversations => 'Cron 대화 검색';

  @override
  String get cron_jobs => 'Cron 작업';

  @override
  String cron_schedule_timezone(Object zone) {
    return '일정 시간대: $zone';
  }

  @override
  String get crons_upcoming => '예정';

  @override
  String get crons_history => '기록';

  @override
  String cron_time_with_zone(Object time, Object zone) {
    return '$time($zone)';
  }

  @override
  String cron_time_zone_unknown(Object time) {
    return '$time(시간대 알 수 없음)';
  }

  @override
  String get cron_no_next_run => '예정된 다음 실행 없음';

  @override
  String get cron_status_scheduled => '예정됨';

  @override
  String get cron_status_paused => '일시중지';

  @override
  String cron_delivers_to(Object target) {
    return '$target(으)로 전달';
  }

  @override
  String get cron_upcoming_empty_title => '예정된 작업 없음';

  @override
  String get cron_upcoming_empty_message =>
      '실행 예정인 작업이 없습니다. Cron 작업에서 만들거나 에이전트에게 일정을 요청하세요.';

  @override
  String get cron_upcoming_unavailable => '예정된 작업을 사용할 수 없음';

  @override
  String get cron_upcoming_needs_dashboard =>
      '예정된 작업에는 대시보드 연결이 필요합니다. 이 주소는 Cron 일정을 제공하지 않습니다. 대시보드 주소와 호스트의 지원 여부를 확인하세요.';

  @override
  String get cron_upcoming_needs_dashboard_auth =>
      '예정된 작업에는 대심부드 인증이 필요합니다. 이 연결에 대심부드 사용자 이름과 바밀번호를 추가하거나 프록시 모드를 사용하세요.';

  @override
  String get cron_upcoming_dashboard_unreachable =>
      '대심부드에 연결할 수 없어요. 호스트, 대심부드 포트, 네트워크를 확인하고 다시 시도하세요.';

  @override
  String get cron_upcoming_load_failed =>
      '예정된 작업을 불러올 수 없습니다. 대심부드 연결을 확인하고 다시 시도하세요.';

  @override
  String get cron_upcoming_refresh_failed =>
      '일정을 새로 고칠 수 없습니다. 마지막으로 성공한 조회 결과를 표시합니다.';

  @override
  String get cron_job_added => 'Cron 작업이 추가되었습니다';

  @override
  String get cron_job_updated => 'Cron 작업이 업데이트되었습니다';

  @override
  String get cron_run => 'Cron 실행';

  @override
  String get cross_device_ordering_and_reversible_bulk_organization =>
      '기기 간 정렬 및 되돌리기 가능한 일괄 정리';

  @override
  String get current_profile_default => '현재 프로필 기본값';

  @override
  String get custom_proxy_and_dashboard_details => '사용자 정의 프록시 및 대시보드 세부 정보';

  @override
  String get dark => '다크';

  @override
  String get dashboard_proxy_settings => '대시보드 / 프록시 설정';

  @override
  String get dashboard_password_optional => '대시보드 비밀번호 (선택 사항)';

  @override
  String get dashboard_port => '대시보드 포트';

  @override
  String get dashboard_username_optional => '대시보드 사용자 이름 (선택 사항)';

  @override
  String get dashboard_behind_proxy => '프록시 뒤의 대시보드';

  @override
  String get dashboard_path_prefix => '대시보드 경로 접두사';

  @override
  String delegated_task(Object goal) {
    return '위임된 작업: $goal';
  }

  @override
  String get delete => '삭제';

  @override
  String delete_2(Object name) {
    return '\"$name\"을(를) 삭제하시겠습니까?';
  }

  @override
  String delete_from_the_remote_hermes_history_this_cannot_be_undone(
    Object title,
  ) {
    return '원격 Hermes 기록에서 \"$title\"을(를) 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.';
  }

  @override
  String get delete_cron_job => 'Cron 작업 삭제';

  @override
  String get delete_connections_that_are_not_in_the_backup =>
      '백업에 없는 연결을 삭제합니다.';

  @override
  String delete_failed(Object error) {
    return '삭제 실패: $error';
  }

  @override
  String get delete_project => '프로젝트 삭제';

  @override
  String get delete_session => '세션을 삭제하시겠습니까?';

  @override
  String delete_3(Object projectName) {
    return '$projectName을(를) 삭제하시겠습니까?';
  }

  @override
  String deleted(Object name) {
    return '\"$name\"이(가) 삭제되었습니다';
  }

  @override
  String get delivery_is_uncertain_recovering_without_resending =>
      '전송 상태가 불확실합니다. 재전송하지 않고 복구하는 중…';

  @override
  String get desktop_gateway_url_optional => 'Desktop Gateway URL (선택 사항)';

  @override
  String get desktop_gateway_is_not_configured_for_this_connection =>
      '이 연결에는 Desktop Gateway가 구성되어 있지 않습니다.';

  @override
  String get desktop_app => '데스크톱 앱';

  @override
  String get developer_tool_calls => '개발자 도구 호출';

  @override
  String get discord_chats => 'Discord 채팅';

  @override
  String get dismiss => '닫기';

  @override
  String get do_not_run_this_command => '이 명령을 실행하지 마세요.';

  @override
  String get documents_archives_audio_video_or_data =>
      '문서, 아카이브, 오디오, 비디오 또는 데이터';

  @override
  String get download => '다운로드';

  @override
  String download_failed(Object error) {
    return '다운로드 실패: $error';
  }

  @override
  String get durable_facts_hermes_keeps_about_you => 'Hermes가 기억하는 지속적인 정보';

  @override
  String get durable_work_inside_one_of_your_projects_shared_with_desktop =>
      'Desktop과 공유되는 프로젝트 내의 지속적인 작업입니다.';

  @override
  String get edit => '편집';

  @override
  String get edit_connection => '연결 편집';

  @override
  String get edit_cron_job => 'Cron 작업 편집';

  @override
  String get edit_gateway_connection => '게이트웨이 연결 편집';

  @override
  String get edit_and_resend => '편집 후 다시 보내기';

  @override
  String get enable_notifications => '알림 사용';

  @override
  String get enable_notifications_description => '끄면 아래의 모든 알림이 비활성화됩니다.';

  @override
  String get enables_file_attachments_through_the_desktop_remote_gateway =>
      'Desktop 원격 게이트웨이를 통한 파일 첨부를 활성화합니다.';

  @override
  String get enter_a_name => '이름을 입력하세요';

  @override
  String get enter_a_passphrase => '패스프레이즈를 입력하세요.';

  @override
  String get enter_the_passphrase_for_this_backup => '이 백업의 패스프레이즈를 입력하세요.';

  @override
  String get every_conversation_is_already_assigned_to_a_project =>
      '모든 대화가 이미 프로젝트에 할당되어 있습니다.';

  @override
  String get everything_not_yet_native_in_the_authenticated_web_dashboard =>
      '아직 네이티브로 구현되지 않은 모든 기능은 인증된 웹 대시보드에서 확인하세요.';

  @override
  String get explain_the_attached_content_clearly => '첨부된 내용을 명확하게 설명하세요.';

  @override
  String explain_this_content_clearly(Object text) {
    return '이 내용을 명확하게 설명하세요:\n\n$text';
  }

  @override
  String
  get explicit_choices_adjust_android_accessibility_text_size_system_leaves_it =>
      '직접 선택하여 Android 접근성 텍스트 크기를 조정하거나, 시스템 설정을 따르세요.';

  @override
  String get export_label => '내보내기';

  @override
  String get export_share => '내보내기 / 공유';

  @override
  String get external_api_clients => '외부 API 클라이언트';

  @override
  String get extra_high => '매우 높음';

  @override
  String get extract_tasks => '작업 추출';

  @override
  String
  get extract_the_decisions_deadlines_owners_and_actionable_action_items_from =>
      '첨부된 내용에서 결정 사항, 마감 기한, 담당자 및 실행 가능한 작업 항목을 추출하세요.';

  @override
  String
  extract_the_decisions_deadlines_owners_and_actionable_action_items_from_2(
    Object text,
  ) {
    return '이 내용에서 결정 사항, 마감 기한, 담당자 및 실행 가능한 작업 항목을 추출하세요:\n\n$text';
  }

  @override
  String failed_to_add_job(Object error) {
    return '작업 추가 실패: $error';
  }

  @override
  String get failed_to_load_cron_jobs => 'Cron 작업 불러오기 실패';

  @override
  String get failed_to_load_memory => '메모리 불러오기 실패';

  @override
  String get failed_to_load_messages => '메시지 불러오기 실패';

  @override
  String get failed_to_load_settings => '설정 불러오기 실패';

  @override
  String get failed_to_load_skills => '스킬 불러오기 실패';

  @override
  String failed_to_update_job(Object error) {
    return '작업 업데이트 실패: $error';
  }

  @override
  String failed(Object error) {
    return '실패: $error';
  }

  @override
  String get file_attached_document_catalog_registration_is_pending =>
      '파일이 첨부되었습니다. 문서 카탈로그 등록이 진행 중입니다.';

  @override
  String get file_reference_added_to_chat => '채팅에 파일 참조가 추가되었습니다';

  @override
  String get files => '파일';

  @override
  String get fill_from_document => '문서에서 채우기';

  @override
  String get folder_is_empty => '폴더가 비어 있습니다';

  @override
  String get folders => '폴더';

  @override
  String get full_text => '전체 텍스트';

  @override
  String get gateway_api_access => '게이트웨이 API 액세스';

  @override
  String get gateway_connected_but_the_dashboard_could_not_be_reached_or =>
      '게이트웨이에 연결되었으나 대시보드에 도달할 수 없거나 인증되지 않았습니다. 대시보드 세부 정보를 확인하거나, 건너뛰려면 지우세요.';

  @override
  String get gateway_path_prefix => '게이트웨이 경로 접두사';

  @override
  String get go_to_end => '끝으로 이동';

  @override
  String get hermes_agent => 'Ares - formerly Hermes Android';

  @override
  String get hermes_agent_for_android => 'Ares - formerly Hermes Android';

  @override
  String get hermes_could_not_accept_the_answer_please_try_again =>
      'Hermes가 답변을 수락하지 못했습니다. 다시 시도해 주세요.';

  @override
  String get hermes_could_not_load_your_saved_connections =>
      'Hermes가 저장된 연결을 불러올 수 없습니다';

  @override
  String get hermes_did_not_accept_the_response_please_try_again =>
      'Hermes가 응답을 수락하지 않았습니다. 다시 시도해 주세요.';

  @override
  String get hermes_is_responding => 'Hermes가 응답 중입니다…';

  @override
  String get hermes_is_waiting_for_input => 'Hermes가 입력을 기다리는 중입니다…';

  @override
  String get hermes_keeps_android_accessibility_text_scaling_active =>
      'Ares는 Android 접근성 텍스트 크기 조정을 활성 상태로 유지합니다.';

  @override
  String get hermes_needs_your_input => 'Hermes에 입력이 필요합니다';

  @override
  String get hermes_profile_optional => 'Hermes 프로필 (선택 사항)';

  @override
  String get hermes_profile_must_be_a_plain_profile_name_such_as =>
      'Hermes 프로필은 경로가 아닌 \"sol\"과 같은 일반적인 프로필 이름이어야 합니다.';

  @override
  String get hermes_reasoning_details => 'Hermes 추론 세부 정보';

  @override
  String hermes_recovery_is_unavailable(Object error) {
    return 'Hermes 복구를 사용할 수 없습니다: $error';
  }

  @override
  String get hermes_stopped_recovery_safely_no_prompt_was_resent =>
      'Hermes가 안전하게 복구를 중단했습니다. 프롬프트가 다시 전송되지 않았습니다.';

  @override
  String get hide_passphrase => '패스프레이즈 숨기기';

  @override
  String get home_needs_your_recent_chats_to_know_what_deserves_your =>
      '홈 화면에서 주의가 필요한 항목을 파악하려면 최근 채팅이 필요합니다. 게이트웨이에 연결할 수 있는지 확인한 후 다시 시도하세요.';

  @override
  String get host => '호스트';

  @override
  String get image_selection_was_interrupted_try_again =>
      '이미지 선택이 중단되었습니다. 다시 시도하세요.';

  @override
  String get import_label => '가져오기';

  @override
  String get inbox => '받은편지함';

  @override
  String get inbox_is_clear => '받은편지함이 비어 있습니다';

  @override
  String get input_needed => '입력 필요';

  @override
  String get input_needed_description => 'Hermes가 질문했거나 비밀번호 또는 시크릿이 필요합니다.';

  @override
  String get insert_a_remote_file_reference => '원격 @file 참조 삽입';

  @override
  String get invalid_port_number => '유효하지 않은 포트 번호입니다.';

  @override
  String get job_paused => '작업 일시 중지됨';

  @override
  String get job_resumed => '작업 재개됨';

  @override
  String get job_triggered => '작업 트리거됨';

  @override
  String get label => '라벨';

  @override
  String last_activity(Object day, Object month, Object year) {
    return '최근 활동 $year/$month/$day';
  }

  @override
  String last(Object lastRun) {
    return '마지막: $lastRun';
  }

  @override
  String get leave_blank_for_default_8642_443_with_https =>
      '기본값(8642; https 사용 시 443)을 사용하려면 비워 두세요';

  @override
  String get leave_blank_for_default_9119 => '기본값(9119)을 사용하려면 비워 두세요';

  @override
  String get light => '라이트';

  @override
  String listening(Object elapsed) {
    return '듣는 중 • $elapsed';
  }

  @override
  String listening_elapsed(Object elapsed) {
    return '듣는 중, 경과 시간 $elapsed';
  }

  @override
  String get load_more => '더 불러오기…';

  @override
  String get loading => '불러오는 중';

  @override
  String get location => '위치';

  @override
  String get make_sure_the_gateway_api_server_is_running_hermes_gateway =>
      '게이트웨이 API 서버가 실행 중인지 확인하세요\n(hermes gateway status)';

  @override
  String matches(Object assigned, Object name) {
    return '$name · $assigned 일치';
  }

  @override
  String get memory => '메모리';

  @override
  String get memory_about_you => '사용자 정보';

  @override
  String get memory_agent_notes => '에이전트 메모';

  @override
  String get memory_builtin_scope =>
      '이 프로필의 USER.md 및 MEMORY.md에 저장된 정보입니다. MemPalace를 포함한 외부 메모리 제공업체의 정보는 표시되지 않습니다.';

  @override
  String get memory_read_only =>
      '읽기 전용입니다. 채팅에서 Hermes에게 정보를 수정하거나 잊어 달라고 요청하세요.';

  @override
  String get memory_unavailable =>
      '이 게이트웨이 또는 프로필에서 저장된 정보를 가져올 수 없습니다. 선택한 프로필을 확인하고 필요한 경우 Hermes를 업데이트하세요.';

  @override
  String get memory_load_error => '대시보드 연결과 인증을 확인한 후 다시 시도하세요.';

  @override
  String get memory_read_full_fact => '전체 정보 읽기';

  @override
  String get memory_full_fact_requires_update =>
      '전체 정보를 보려면 더 최신 Hermes 게이트웨이가 필요합니다. Hermes를 업데이트하고 새로고침하세요.';

  @override
  String get memory_fact_detail_error =>
      '전체 정보를 불러올 수 없습니다. 정보가 변경되었을 수 있습니다. 목록을 새로고침하고 다시 시도하세요.';

  @override
  String get memory_entries_are_cross_session_facts_the_agent_remembers_they =>
      'Hermes가 기억한 정보가 여기에 표시됩니다.';

  @override
  String get merge => '병합';

  @override
  String get message => '메시지';

  @override
  String get message_hermes => 'Hermes에게 메시지 보내기…';

  @override
  String get message_actions => '메시지 작업';

  @override
  String get message_copied => '메시지가 복사되었습니다';

  @override
  String get migrating => '마이그레이션 중…';

  @override
  String get migration_complete => '마이그레이션 완료';

  @override
  String get migration_failed_local_spaces_were_kept_unchanged =>
      '마이그레이션에 실패했습니다. 로컬 스페이스는 변경되지 않았습니다.';

  @override
  String get migration_incomplete => '마이그레이션이 완료되지 않았습니다';

  @override
  String get migration_preview => '마이그레이션 미리보기';

  @override
  String get model => '모델';

  @override
  String get model_and_thinking_for_this_chat => '이 채팅을 위한 모델 및 추론';

  @override
  String model_was_not_changed(Object error) {
    return '모델이 변경되지 않았습니다: $error';
  }

  @override
  String get move_attachment_next => '첨부 파일을 다음으로 이동';

  @override
  String get move_attachment_previous => '첨부 파일을 이전으로 이동';

  @override
  String get move_chat => '채팅 이동';

  @override
  String get move_conversation => '대화 이동';

  @override
  String get move_to_project => '프로젝트로 이동';

  @override
  String get move_to_space => '스페이스로 이동';

  @override
  String get moved_to_a_project => '프로젝트로 이동됨';

  @override
  String moved_to(Object label) {
    return '$label(으)로 이동됨';
  }

  @override
  String get name => '이름';

  @override
  String get name_prompt_and_schedule_are_required => '이름, 프롬프트, 스케줄은 필수 항목입니다';

  @override
  String get nav_activity => '활동';

  @override
  String get nav_projects => '프로젝트';

  @override
  String get needs_a_correction_aware_filing_contract_in_the_hermes_gateway =>
      'Hermes 게이트웨이에 수정 인식 파일링 계약이 필요합니다.';

  @override
  String get needs_a_reachable_hermes_dashboard_check_the_host_port_and =>
      '연결 가능한 Hermes 대시보드가 필요합니다. 이 연결의 호스트, 포트 및 자격 증명을 확인하세요.';

  @override
  String get needs_a_server_authoritative_assets_index_in_the_hermes_gateway =>
      'Hermes 게이트웨이에 서버 권한 자산 인덱스가 필요합니다.';

  @override
  String get needs_durable_pin_ordering_batch_mutation_and_undo_contracts_in =>
      'Hermes 게이트웨이에 영구 고정 순서 지정, 일괄 변경 및 실행 취소 계약이 필요합니다.';

  @override
  String get needs_you => '확인 필요';

  @override
  String get new_label => '신규';

  @override
  String get new_chat => '새 채팅';

  @override
  String get new_chat_2 => '새 채팅';

  @override
  String new_chat_3(Object projectName) {
    return '새 채팅 · $projectName';
  }

  @override
  String get new_project => '새 프로젝트';

  @override
  String get new_space => '새 스페이스';

  @override
  String next(Object nextRun) {
    return '다음: $nextRun';
  }

  @override
  String get nginx_injects_auth_app_sends_clean_requests =>
      'Nginx가 인증을 주입합니다 — 앱은 깔끔한 요청을 보냅니다';

  @override
  String get no_tts_voices_found_ninstall_google_text_to_speech_and =>
      '사용 가능한 TTS 음성이 없습니다.\nGoogle Text-to-Speech를 설치하고 음성 데이터를 다운로드하세요.';

  @override
  String get no_active_projects_on_this_gateway => '이 게이트웨이에 활성 프로젝트가 없습니다';

  @override
  String get no_activity_yet => '아직 활동이 없습니다';

  @override
  String get no_chat_is_blocked_running_or_waiting_to_be_resumed =>
      '차단되었거나 실행 중이거나 재개 대기 중인 채팅이 없습니다. 준비되면 언제든 새 채팅을 시작하세요.';

  @override
  String no_chats_in_this_project_match(Object searchQuery) {
    return '이 프로젝트에서 “$searchQuery”와(과) 일치하는 채팅이 없습니다.';
  }

  @override
  String get no_chats_in_this_space_yet_tap_to_start_one =>
      '이 스페이스에 아직 채팅이 없습니다. +를 눌러 시작하세요.';

  @override
  String get no_chats_yet => '아직 채팅이 없습니다';

  @override
  String get no_connections => '연결 없음';

  @override
  String get no_conversation_matches_this_view => '이 보기와 일치하는 대화가 없습니다.';

  @override
  String get no_cron_jobs => 'Cron 작업 없음';

  @override
  String get no_folders_yet => '아직 폴더가 없습니다';

  @override
  String get no_local_spaces_were_found_for_this_connection_so_projects =>
      '이 연결에서 로컬 스페이스를 찾지 못했으므로 프로젝트가 이미 여기서 사용되는 유일한 정리 방식입니다.';

  @override
  String get no_matches => '일치하는 항목 없음';

  @override
  String get no_memory_entries => '메모리 항목 없음';

  @override
  String get no_message_content_matches => '메시지 내용과 일치하는 항목 없음';

  @override
  String get no_new_messages => '새 메시지 없음';

  @override
  String get no_projects_yet => '아직 프로젝트가 없습니다';

  @override
  String get no_runs_yet => '아직 실행 기록이 없습니다.';

  @override
  String no_server_project_matches_this_name(Object assigned) {
    return '이 이름과 일치하는 서버 프로젝트가 없습니다 · $assigned';
  }

  @override
  String get no_sessions_yet => '아직 세션이 없습니다';

  @override
  String get no_skills_found => '스킬을 찾을 수 없습니다';

  @override
  String get no_spaces_on_this_device => '이 기기에 스페이스가 없습니다';

  @override
  String get no_text_shared => '공유된 텍스트 없음';

  @override
  String get no_turn_is_blocked_in_flight_or_recently_finished_work =>
      '차단되었거나, 진행 중이거나, 최근에 완료된 턴이 없습니다. 작업을 시작하면 여기에 표시됩니다.';

  @override
  String get no_turn_needs_your_input_or_has_failed => '입력이 필요하거나 실패한 턴이 없습니다.';

  @override
  String get no_unassigned_chats => '할당되지 않은 채팅이 없습니다.';

  @override
  String get nothing_changed_in_the_last_seven_days => '지난 7일 동안 변경된 내용이 없습니다.';

  @override
  String get nothing_has_moved_yet_this_is_only_what_a_migration =>
      '아직 이동된 항목이 없습니다 — 마이그레이션이 수행할 작업의 미리보기입니다.';

  @override
  String get nothing_here => '항목이 없습니다';

  @override
  String get nothing_is_running => '실행 중인 작업이 없습니다';

  @override
  String get nothing_needs_you => '조치가 필요한 항목이 없습니다';

  @override
  String get nothing_to_migrate => '마이그레이션할 항목이 없습니다';

  @override
  String get notifications => '알림';

  @override
  String get windows_notifications_blocked =>
      '알림을 사용할 수 없습니다. 설치된 Ares 앱을 사용하고 Windows의 설정 → 시스템 → 알림을 확인하세요.';

  @override
  String get windows_notification_diagnostics => 'Ares가 Windows에 전달한 내용';

  @override
  String get chat_activity_share => '채팅 활동 공유';

  @override
  String get chat_activity_share_hint =>
      '이 채팅을 사용 중임을 호환되는 연결된 게이트웨이에 알려 휴대전화 알림 플러그인의 중복 알림을 방지합니다. 키나 메시지 본문은 전송되지 않습니다.';

  @override
  String get completion_sound => '완료 소리';

  @override
  String get completion_sound_system => '시스템 기본값';

  @override
  String get completion_sound_mail => '메일';

  @override
  String get completion_sound_reminder => '미리 알림';

  @override
  String get completion_sound_silent => '무음';

  @override
  String get completion_sound_scope =>
      '응답 완료, 테스트 알림 및 앱 내에서 재생됩니다. 승인 및 기타 알림은 기존 소리를 유지합니다.';

  @override
  String get completion_sound_scope_android =>
      '응답 완료, 테스트 알림 및 앱 내에서 재생됩니다. 승인, 기타 알림, 서버의 백그라운드 알림 및 Android Auto 메시지는 기존 소리를 유지합니다.';

  @override
  String get notification_open_action => '열기';

  @override
  String get app_sounds_mute => '앱 소리 음소거';

  @override
  String get app_sounds_mute_hint =>
      'Ares가 열려 있는 동안 재생하는 완료 소리를 끕니다. 알림은 각각의 소리를 유지합니다.';

  @override
  String get notifications_permission_denied =>
      'OS 수준에서 알림이 차단되어 있습니다. Android 설정에서 이 앱의 알림을 허용하세요.';

  @override
  String get off_no_thinking => '끔 (추론 없음)';

  @override
  String get offline_showing_the_last_known_activity =>
      '오프라인 — 마지막으로 확인된 활동을 표시하는 중입니다.';

  @override
  String get offline_showing_the_last_known_chats =>
      '오프라인 — 마지막으로 확인된 채팅을 표시하는 중입니다';

  @override
  String get offline_showing_the_last_known_projects =>
      '오프라인 — 마지막으로 확인된 프로젝트를 표시합니다.';

  @override
  String get on_this_device => '이 기기';

  @override
  String get on_device => '온디바이스';

  @override
  String get open_inbox => '받은편지함 열기';

  @override
  String open_inbox_2(Object count) {
    return '받은편지함 열기 ($count)';
  }

  @override
  String get open_the_hermes_dashboard => 'Hermes 대시보드 열기';

  @override
  String get optional_for_the_memory_cron_skills_settings_tabs_leave_blank =>
      '선택 사항입니다. 메모리/Cron/스킬/설정 탭에 사용됩니다. 기본 대시보드 포트(9119)를 로그인 없이 사용하려면 비워 두세요.';

  @override
  String get organization => '조직';

  @override
  String get other_answer => '다른 답변';

  @override
  String get overview => '개요';

  @override
  String get passphrase => '패스프레이즈';

  @override
  String get password_optional => '비밀번호 (선택 사항)';

  @override
  String get phone_or_tablet => '휴대전화 또는 태블릿';

  @override
  String get pin_batch_and_undo => '고정, 일괄 처리 및 실행 취소';

  @override
  String get plugin_notifications => '플러그인 알림';

  @override
  String get plugin_notifications_description =>
      '앱이 백그라운드일 때 게이트웨이가 알림을 보냈습니다.';

  @override
  String get port => '포트';

  @override
  String get preparing_attachments => '첨부 파일 준비 중…';

  @override
  String get preview_truncated => '미리보기가 잘렸습니다';

  @override
  String get preview_unavailable => '미리보기를 사용할 수 없습니다';

  @override
  String get profile => '프로필';

  @override
  String get profile_default_model => '프로필 기본 모델';

  @override
  String profile_default_set_to_chats_with_their_own_model_keep(
    Object selectedModel,
  ) {
    return '프로필 기본값이 $selectedModel(으)로 설정되었습니다. 자체 모델을 사용하는 채팅은 해당 설정을 유지합니다.';
  }

  @override
  String
  get profile_this_connection_chats_as_when_the_dashboard_serves_several =>
      '대시보드가 여러 프로필을 제공할 때 이 연결이 채팅할 프로필입니다. 프로필별로 분리된 대시보드를 사용하려면 비워 두세요.';

  @override
  String get project => '프로젝트';

  @override
  String get project_actions => '프로젝트 작업';

  @override
  String get project_chat => '프로젝트 채팅';

  @override
  String get project_chats_unavailable => '프로젝트 채팅을 사용할 수 없습니다';

  @override
  String get projects => '프로젝트';

  @override
  String get projects_group_related_chats_files_and_activity_and_stay_in =>
      '프로젝트는 관련 채팅, 파일, 활동을 그룹화하며 컴퓨터의 Hermes와 동기화 상태를 유지합니다.';

  @override
  String
  get projects_need_a_desktop_gateway_connection_add_the_desktop_gateway =>
      '프로젝트를 사용하려면 Desktop Gateway 연결이 필요합니다. 기기 간 채팅을 정리하려면 이 연결에 Desktop Gateway URL을 추가하세요.';

  @override
  String get projects_unavailable => '프로젝트를 사용할 수 없습니다';

  @override
  String get projects_activity_new_navigation => '프로젝트, 활동 — 새로운 탐색';

  @override
  String get promote_to_project => '프로젝트로 승격';

  @override
  String get prompt => '프롬프트';

  @override
  String get protect_this_backup => '이 백업 보호하기';

  @override
  String get provider => '제공자';

  @override
  String get proxy_injects_auth_app_sends_clean_requests =>
      '프록시가 인증을 주입하며, 앱은 정리된 요청을 보냅니다';

  @override
  String get quick_chat => '빠른 채팅';

  @override
  String get quick_chats_appear_here_after_their_retention_period =>
      '빠른 채팅은 보관 기간이 지나면 여기에 나타납니다.';

  @override
  String get read_aloud => '소리 내어 읽기';

  @override
  String get read_aloud_is_unavailable_on_this_device =>
      '이 기기에서는 소리 내어 읽기를 사용할 수 없습니다';

  @override
  String get reading_response_aloud => '응답을 소리 내어 읽는 중';

  @override
  String get ready_to_upload => '업로드 준비 완료';

  @override
  String get reasoning => '추론';

  @override
  String get recently_completed => '최근 완료됨';

  @override
  String get recently_active => '최근 활동';

  @override
  String get recovering_hermes => 'Hermes 복구 중…';

  @override
  String get refresh => '새로고침';

  @override
  String get regenerate_response => '응답 재생성';

  @override
  String get remove_attachment => '첨부 파일 제거';

  @override
  String get rename => '이름 바꾸기';

  @override
  String get rename_chat => '채팅 이름 바꾸기';

  @override
  String get rename_project => '프로젝트 이름 바꾸기';

  @override
  String get rename_space => '스페이스 이름 바꾸기';

  @override
  String rename_2(Object projectName) {
    return '$projectName 이름 바꾸기';
  }

  @override
  String rename_3(Object name) {
    return '$name 이름 바꾸기';
  }

  @override
  String get replace => '바꾸기';

  @override
  String get repositories => '저장소';

  @override
  String
  get research_the_attached_content_verify_the_important_claims_and_cite =>
      '첨부된 콘텐츠를 조사하고, 중요한 주장을 검증한 뒤 출처를 인용하세요.';

  @override
  String research_this_content_verify_the_important_claims_and_cite_sources(
    Object text,
  ) {
    return '이 콘텐츠를 조사하고, 중요한 주장을 검증한 뒤 출처를 인용하세요:\n\n$text';
  }

  @override
  String reset_failed_the_secure_storage_may_need_reinstall(Object retryError) {
    return '재설정 실패: $retryError. 보안 저장소를 재설치해야 할 수도 있습니다.';
  }

  @override
  String get reset_saved_connections => '저장된 연결 재설정';

  @override
  String get responding => '응답 중…';

  @override
  String response_closed_locally_gateway_stop_failed(Object error) {
    return '로컬에서 응답이 종료되었습니다. 게이트웨이 중지 실패: $error';
  }

  @override
  String get response_closed_locally_no_active_gateway_turn_was_found =>
      '로컬에서 응답이 종료되었습니다. 활성 게이트웨이 턴을 찾을 수 없습니다.';

  @override
  String get response_complete => '응답 완료';

  @override
  String get response_complete_description => '앱이 백그라운드일 때 턴이 완료되었습니다.';

  @override
  String get response_ready => '응답 준비 완료';

  @override
  String get response_stopped => '응답이 중단되었습니다.';

  @override
  String get restore => '복원';

  @override
  String get restore_configuration => '구성 복원';

  @override
  String get restore_project => '프로젝트 복원';

  @override
  String get retry => '재시도';

  @override
  String retry_failed_for_the_draft_and_prompt_were_kept(Object name) {
    return '$name 재시도에 실패했습니다. 초안과 프롬프트는 유지되었습니다.';
  }

  @override
  String get retry_upload => '업로드 재시도';

  @override
  String retrying(Object name) {
    return '$name 재시도 중…';
  }

  @override
  String get review_local_spaces => '로컬 스페이스 검토';

  @override
  String get review_or_promote_quick_chats_past_their_retention_period =>
      '보존 기간이 지난 빠른 채팅을 검토하거나 승격하세요';

  @override
  String get review_the_attached_content => '첨부된 콘텐츠를 검토하세요.';

  @override
  String get run_only_this_command => '이 명령만 실행하세요.';

  @override
  String get running_now => '실행 중';

  @override
  String get save => '저장';

  @override
  String get save_changes => '변경 사항 저장';

  @override
  String get save_a_permanent_rule_in_the_hermes_configuration =>
      'Hermes 구성에 영구 규칙을 저장하세요.';

  @override
  String get save_the_durable_facts_from_the_attached_content_to_memory =>
      '첨부된 콘텐츠에서 지속적인 사실을 메모리에 저장한 다음, 무엇이 보존되었는지 확인하세요.';

  @override
  String save_the_durable_facts_from_this_content_to_memory_then(Object text) {
    return '이 콘텐츠에서 지속적인 사실을 메모리에 저장한 다음, 무엇이 보존되었는지 확인하세요:\n\n$text';
  }

  @override
  String get save_your_connections_and_settings_to_an_encrypted_file_then =>
      '연결 및 설정을 암호화된 파일로 저장한 후, 재설치 시 또는 다른 기기에서 복원하세요.';

  @override
  String save_2(Object filename) {
    return '$filename 저장';
  }

  @override
  String get schedule => '일정';

  @override
  String get scheduled_jobs_and_their_last_runs => '예약된 작업 및 마지막 실행 기록';

  @override
  String get scheduled_tasks => '예약된 작업';

  @override
  String get script_only_no_agent => '스크립트 전용 (에이전트 없음)';

  @override
  String get scroll_horizontally => '가로로 스크롤';

  @override
  String get search_all_chats => '모든 채팅 검색';

  @override
  String get search_all_message_content => '모든 메시지 내용 검색';

  @override
  String get search_chats => '채팅 검색';

  @override
  String get search_conversations => '대화 검색';

  @override
  String get search_loaded_chats => '불러온 채팅 검색';

  @override
  String get search_mode => '검색 모드';

  @override
  String get select_one_option_or_enter_another_answer =>
      '옵션 중 하나를 선택하거나 다른 답변을 입력하세요.';

  @override
  String get select_one_or_more_options_then_continue =>
      '하나 이상의 옵션을 선택한 후 계속하세요.';

  @override
  String get select_text => '텍스트 선택';

  @override
  String get send => '보내기';

  @override
  String send_failed(Object error) {
    return '전송 실패: $error';
  }

  @override
  String send_failed_api_only_permission_denied(Object error) {
    return '전송 실패: $error. 서버가 API 키 주체의 이 쓰기를 거부했습니다. 이 채팅이 Dashboard 소유라면 이 연결에 Dashboard 사용자 이름과 비밀번호를 추가하면 전송될 수 있습니다. 서버가 의도적으로 거부하는 것일 수도 있습니다.';
  }

  @override
  String get send_message => '메시지 보내기';

  @override
  String get send_test_notification => '테스트 알림 보내기';

  @override
  String get session_sources => '세션 소스';

  @override
  String get session_deleted_from_remote_hermes => '원격 Hermes에서 세션이 삭제되었습니다.';

  @override
  String session_search_failed(Object error) {
    return '세션 검색 실패: $error';
  }

  @override
  String get set_profile_default => '프로필 기본값으로 설정';

  @override
  String get settings => '설정';

  @override
  String get share_to_hermes => 'Hermes에 공유';

  @override
  String get show_passphrase => '패스프레이즈 표시';

  @override
  String get show_tool_calls_thinking_and_message_metadata =>
      '도구 호출, 추론 및 메시지 메타데이터 표시';

  @override
  String get signal_messages => 'Signal 메시지';

  @override
  String get skills => '스킬';

  @override
  String skills_2(Object count) {
    return '스킬 ($count)';
  }

  @override
  String get skills_and_tools => '스킬 및 도구';

  @override
  String get skip => '건너뛰기';

  @override
  String get slack_chats => 'Slack 채팅';

  @override
  String source(Object source) {
    return '소스: $source';
  }

  @override
  String get space_actions => '스페이스 작업';

  @override
  String get spaces => '스페이스';

  @override
  String get speak_to_hermes => 'Hermes에게 말하기';

  @override
  String get speech_recognition_is_unavailable => '음성 인식 기능을 사용할 수 없습니다';

  @override
  String get spoken_replies => '음성 응답';

  @override
  String get spoken_replies_off => '음성 답변 끄기';

  @override
  String get spoken_replies_on => '음성 답변 켜기';

  @override
  String get stalled_no_update_from_hermes => '지연됨 — Hermes에서 업데이트가 없습니다';

  @override
  String get start_something_new => '새로운 작업 시작하기';

  @override
  String get start_voice_input => '음성 입력 시작';

  @override
  String get starting_hermes => 'Hermes 시작 중…';

  @override
  String get media_card_download => '파일 다운로드';

  @override
  String get media_card_tap_to_download => '탭하여 다운로드';

  @override
  String get still_loading_your_projects => '프로젝트를 불러오는 중입니다.';

  @override
  String get stop => '중지';

  @override
  String get stop_response => '응답 중지';

  @override
  String get stop_voice_input => '음성 입력 중지';

  @override
  String get submitted_waiting_for_hermes => '전송됨, Hermes 대기 중';

  @override
  String get suggest_projects_and_learn_from_your_corrections =>
      '프로젝트 제안 및 수정 사항 학습';

  @override
  String get summarize_the_attached_content => '첨부된 콘텐츠 요약하기';

  @override
  String summarize_this_content(Object text) {
    return '다음 콘텐츠 요약:\n\n$text';
  }

  @override
  String get switch_profile => '프로필 전환';

  @override
  String get system => '시스템';

  @override
  String get take_photo => '사진 촬영';

  @override
  String get tap_to_add_a_remote_hermes_gateway_api_server_port =>
      '+를 눌러 원격 Hermes 게이트웨이 추가\n(API 서버, 포트 8642)';

  @override
  String get tap_the_button_to_start_a_new_chat => '+ 버튼을 눌러 새 채팅 시작하기';

  @override
  String get telegram_messages => 'Telegram 메시지';

  @override
  String get terminal_sessions => '터미널 세션';

  @override
  String get test_notification_body => '이 알림이 보이면 알림 기능이 정상입니다.';

  @override
  String get test_notification_sent => '테스트 알림을 보냈습니다.';

  @override
  String get test_notification_title => 'Hermes 알림 테스트';

  @override
  String get test_notification_unsupported =>
      '알림을 보낼 수 없습니다. OS에서 알림이 허용되어 있는지 확인하세요.';

  @override
  String get text_size => '텍스트 크기';

  @override
  String get text_size_preview => '텍스트 크기 미리보기';

  @override
  String text_size_2(Object label) {
    return '텍스트 크기: $label';
  }

  @override
  String get the_api_key_could_not_be_stored_securely =>
      'API 키를 안전하게 저장할 수 없습니다.';

  @override
  String get the_project_will_move_to_archived_its_chats_and_files =>
      '프로젝트가 \'보관됨\'으로 이동합니다. 채팅과 파일은 그대로 유지되며 언제든지 복원할 수 있습니다.';

  @override
  String get the_project_will_move_to_archived_its_chats_and_files_2 =>
      '프로젝트가 \'보관됨\'으로 이동합니다. 채팅과 파일은 그대로 유지되며 나중에 복원할 수 있습니다.';

  @override
  String get the_active_profile_did_not_return_any_selectable_models =>
      '활성 프로필에서 선택 가능한 모델을 찾을 수 없습니다.';

  @override
  String get the_backup_could_not_be_exported => '백업을 내보낼 수 없습니다.';

  @override
  String get the_backup_could_not_be_restored => '백업을 복원할 수 없습니다.';

  @override
  String get the_connection_could_not_be_deleted_safely =>
      '연결을 안전하게 삭제할 수 없습니다.';

  @override
  String get the_connection_could_not_be_stored_securely =>
      '연결 정보를 안전하게 저장할 수 없습니다.';

  @override
  String get the_dashboard_credentials_could_not_be_stored_securely =>
      '대시보드 자격 증명을 안전하게 저장할 수 없습니다.';

  @override
  String get the_detached_reply_failed => '분리된 응답에 실패했습니다.';

  @override
  String the_detached_reply_failed_2(Object error) {
    return '분리된 응답에 실패했습니다: $error';
  }

  @override
  String get the_file_contains_your_api_keys_and_dashboard_password_so =>
      '이 파일에는 API 키와 대시보드 비밀번호가 포함되어 있어 암호화되어 있습니다. 이 패스프레이즈 없이는 백업을 복원할 수 없습니다.';

  @override
  String get the_last_turn_failed => '마지막 턴이 실패했습니다';

  @override
  String the_local_connection_store_looks_damaged_you_can_reset_the(
    Object errorType,
  ) {
    return '로컬 연결 저장소가 손상된 것으로 보입니다 ($errorType). 저장된 연결을 초기화하고 새로 시작할 수 있습니다. 게이트웨이의 채팅은 영향을 받지 않습니다.';
  }

  @override
  String get the_model_only_rewrites_your_question_into_a_short_full =>
      '모델이 질문을 짧은 전체 텍스트 쿼리로 다시 작성하기만 합니다. Hermes는 호스트에 이미 구성된 제공자 자격 증명을 사용합니다.';

  @override
  String get the_server_has_not_reported_folders_for_this_project_yet =>
      '서버가 아직 이 프로젝트의 폴더를 보고하지 않았습니다. \'더 보기\'에서 전체 파일을 계속 사용할 수 있습니다.';

  @override
  String get the_turn_failed => '턴이 실패했습니다';

  @override
  String get the_two_passphrases_do_not_match => '두 패스프레이즈가 일치하지 않습니다.';

  @override
  String get the_value_is_sent_directly_to_the_active_hermes_gateway =>
      '이 값은 활성 Hermes 게이트웨이로 직접 전송되며 이 Android 앱에는 저장되지 않습니다.';

  @override
  String get there_are_no_visible_files_in_this_server_folder =>
      '이 서버 폴더에 표시되는 파일이 없습니다.';

  @override
  String get thinking_effort => '추론 수준';

  @override
  String get this_hermes_gateway_does_not_support_opening_a_project_yet =>
      '이 Hermes 게이트웨이는 아직 프로젝트 열기를 지원하지 않습니다. 휴대폰에서 프로젝트를 탐색하려면 서버의 Hermes를 업데이트하세요.';

  @override
  String get this_hermes_gateway_is_older_than_server_side_projects_so =>
      '이 Hermes 게이트웨이는 서버 측 프로젝트보다 구버전이므로 채팅이 이 기기에만 그룹화됩니다. 기기 간에 동일한 프로젝트를 공유하려면 Hermes를 업데이트하세요.';

  @override
  String get this_project_has_no_folder_to_open_the_chat_in =>
      '이 프로젝트에서 채팅을 시작하려면 폴더가 필요합니다. 폴더를 추가한 후 다시 시도하세요.';

  @override
  String get this_chat_has_no_messages_available_in_the_desktop_session =>
      '이 채팅에는 아직 Desktop 세션에서 사용할 수 있는 메시지가 없습니다.';

  @override
  String get this_creates_a_permanent_rule_in_hermes_review_the_full =>
      '이 작업은 Hermes에 영구적인 규칙을 생성합니다. 확인하기 전에 전체 명령을 검토하세요.';

  @override
  String get this_gateway_does_not_host_projects_yet_update_the_gateway =>
      '이 게이트웨이는 아직 프로젝트를 호스팅하지 않습니다. 기기 간에 채팅을 정리하려면 게이트웨이를 업데이트하세요.';

  @override
  String get this_permanently_deletes_the_project_chats_will_not_be_deleted =>
      '이 프로젝트를 영구적으로 삭제합니다. 채팅은 삭제되지 않으며 미할당 상태로 돌아갑니다.';

  @override
  String get this_server_doesn_t_offer_background_recovery_chats_run_live =>
      '이 서버는 백그라운드 복구를 제공하지 않습니다 — 채팅이 실시간으로 실행됩니다';

  @override
  String get this_week => '이번 주';

  @override
  String get titles_previews_and_models => '제목, 미리보기 및 모델';

  @override
  String get tool_activity => '도구 활동';

  @override
  String get trigger_now => '지금 트리거';

  @override
  String get received_outcome_unknown => '턴 종료 — 결과 미확인';

  @override
  String get turn_completed => '턴 완료';

  @override
  String get turn_failed => '턴 실패';

  @override
  String get turn_failed_description => '백그라운드 턴이 오류로 종료되었습니다.';

  @override
  String get turn_recovery_failed => '턴 복구 실패';

  @override
  String get unable_to_prepare_this_file_try_another_one =>
      '이 파일을 준비할 수 없습니다. 다른 파일을 시도하세요.';

  @override
  String get unable_to_prepare_this_image_try_another_one =>
      '이 이미지를 준비할 수 없습니다. 다른 이미지를 시도하세요.';

  @override
  String unable_to_prepare(Object name) {
    return '$name을(를) 준비할 수 없습니다.';
  }

  @override
  String get unable_to_read_the_selected_image_the_selection_was_kept =>
      '선택한 이미지를 읽을 수 없습니다. 선택 항목은 유지되었습니다.';

  @override
  String get unassigned => '미할당';

  @override
  String get unassigned_chats => '미할당 채팅';

  @override
  String get untitled_chat => '제목 없는 채팅';

  @override
  String get untitled_session => '제목 없는 세션';

  @override
  String get update_api_key => 'API 키 업데이트';

  @override
  String get upload_failed => '업로드 실패';

  @override
  String get upload_failed_tap_retry => '업로드 실패 • 탭하여 재시도';

  @override
  String uploading(Object index, Object name, Object total) {
    return '업로드 중 $index/$total: $name';
  }

  @override
  String get use_as_is => '있는 그대로 사용';

  @override
  String get use_at_least_8_characters => '8자 이상 사용하세요.';

  @override
  String get use_for_cron_jobs_backed_by_scripts => '스크립트 기반 Cron 작업에 사용하세요.';

  @override
  String get use_on_device => '기기 내 사용';

  @override
  String get use_the_attached_content_to_identify_and_fill_the_relevant =>
      '첨부된 콘텐츠를 사용하여 관련 문서 또는 양식 필드를 식별하고 채우세요. 제출하기 전에 확인하세요.';

  @override
  String use_this_content_to_identify_and_fill_the_relevant_document(
    Object text,
  ) {
    return '이 콘텐츠를 사용하여 관련 문서 또는 양식 필드를 식별하고 채우세요. 제출하기 전에 확인하세요:\n\n$text';
  }

  @override
  String get used_for_hosted_path_prefixes_and_for_the_settings_memory =>
      '호스팅된 경로 접두사와 설정, 메모리, 스킬 및 Cron 탭에 사용됩니다. 대시보드를 공개하려면 사용자 이름/비밀번호를 비워두거나, 리버스 프록시가 대시보드 인증을 주입할 때 프록시 모드를 활성화하세요.';

  @override
  String get username_optional => '사용자 이름 (선택 사항)';

  @override
  String using(Object displayName) {
    return '$displayName 사용 중…';
  }

  @override
  String get verbose_mode => '상세 모드';

  @override
  String get message_metadata => '메시지 세부 정보';

  @override
  String get voice => '음성';

  @override
  String voice_setup_failed(Object error) {
    return '음성 설정 실패: $error';
  }

  @override
  String get waiting_for_your_input => '입력을 기다리는 중';

  @override
  String get what_hermes_knows_how_to_do => 'Hermes가 할 수 있는 작업';

  @override
  String get what_should_the_agent_do => '에이전트가 무엇을 해야 하나요?';

  @override
  String get whatsapp_messages => 'WhatsApp 메시지';

  @override
  String get which_project => '어떤 프로젝트인가요?';

  @override
  String get workspace => '워크스페이스';

  @override
  String get wrap_lines => '줄 바꿈';

  @override
  String you_can_attach_up_to_items(Object maxRemoteAttachmentDrafts) {
    return '최대 $maxRemoteAttachmentDrafts개까지 첨부할 수 있습니다.';
  }

  @override
  String get your_answer => '답변';

  @override
  String get e_g_dashboard => '예: /dashboard';

  @override
  String get e_g_dashboard_proxy_path_before_api =>
      '예: /dashboard (/api/ 이전의 프록시 경로)';

  @override
  String get e_g_profile_peter => '예: /profile/peter';

  @override
  String get e_g_sol => '예: sol';

  @override
  String get e_g_0_9_or_every_2h => '예: 0 9 * * * 또는 every 2h';

  @override
  String get e_g_daily_backup => '예: 일일 백업';

  @override
  String downloaded(Object filename) {
    return '$filename 다운로드 완료';
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
      '192.168.1.50, 100.x.y.z 또는 hermes-machine.tailnet.ts.net';

  @override
  String get example_profile_prefix_hint_full =>
      '예: /profile/peter (/api/ 및 /v1/ 이전의 프록시 경로)';

  @override
  String and_more(Object count) {
    return '외 $count개';
  }

  @override
  String chats_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '채팅 $count개',
    );
    return '$_temp0';
  }

  @override
  String on_this_device_only(Object chats) {
    return '$chats · 이 기기에서만';
  }

  @override
  String spaces_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '스페이스 $count개',
    );
    return '$_temp0';
  }

  @override
  String get no_new_projects_needed => '새 프로젝트 불필요';

  @override
  String projects_to_create(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '생성할 프로젝트 $count개',
    );
    return '$_temp0';
  }

  @override
  String chats_migrated_projects_created(
    Object createdProjects,
    Object linkedSessions,
  ) {
    return '채팅 $linkedSessions개 마이그레이션됨 · 프로젝트 $createdProjects개 생성됨';
  }

  @override
  String chats_stayed_in_local_spaces(Object unlinkedSessions) {
    return '채팅 $unlinkedSessions개가 로컬 스페이스에 유지되었으며 안전하게 재시도할 수 있습니다.';
  }

  @override
  String model_recommended(Object provider) {
    return '$provider • 추천: 작고 저렴함';
  }

  @override
  String session_meta(Object count, Object model, Object time) {
    return '메시지 $count개 • $model • $time';
  }

  @override
  String model_scope_label(Object model, Object scope) {
    return '$model • $scope';
  }

  @override
  String get this_chat => '현재 채팅';

  @override
  String get profile_default => '프로필 기본값';

  @override
  String minutes_ago(Object count) {
    return '$count분 전';
  }

  @override
  String hours_ago(Object count) {
    return '$count시간 전';
  }

  @override
  String days_ago(Object count) {
    return '$count일 전';
  }

  @override
  String get now_label => '지금';

  @override
  String get latest_label => '최신';

  @override
  String new_count_indicator(Object count) {
    return '새 항목 $count개';
  }

  @override
  String new_messages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '새 메시지 $count개',
    );
    return '$_temp0';
  }

  @override
  String activity_failed_summary(Object failures, Object total) {
    return '$failures개 실패 • 총 $total개';
  }

  @override
  String activity_completed_summary(Object count) {
    return '$count개 완료';
  }

  @override
  String tool_start_observed(Object time) {
    return '시작 관측 $time (현지 시간)';
  }

  @override
  String tool_last_observed(Object time) {
    return '마지막 관측 $time (현지 시간)';
  }

  @override
  String tool_result_recorded(Object time) {
    return '결과 기록 $time (현지 시간)';
  }

  @override
  String get tool_time_unavailable => '시간 정보 없음';

  @override
  String get hermes_is_using_a_tool => 'Hermes가 도구를 사용 중입니다';

  @override
  String hermes_is_using_tools(Object count) {
    return 'Hermes가 $count개의 도구를 사용 중입니다';
  }

  @override
  String delegated_tasks_completed(Object count) {
    return '위임된 작업 $count개 완료';
  }

  @override
  String delegated_tasks_active(Object count) {
    return '위임된 작업 $count개 진행 중';
  }

  @override
  String branch_main(Object label) {
    return '$label · main';
  }

  @override
  String get you_heading => '## 사용자';

  @override
  String get hermes_heading => '## Hermes';

  @override
  String get action_label => '작업';

  @override
  String get destination_label => '대상';

  @override
  String get markdown_source => '원문';

  @override
  String get preview_label => '미리보기';

  @override
  String get share_action_summarize => '요약';

  @override
  String get share_action_explain => '설명';

  @override
  String get share_action_research => '조사';

  @override
  String get share_action_remember => '기억';

  @override
  String get text_size_small => '작게';

  @override
  String get text_size_default => '기본';

  @override
  String get text_size_large => '크게';

  @override
  String get text_size_extra_large => '아주 크게';

  @override
  String get text_size_use_system_description =>
      'Android 접근성 텍스트 크기를 그대로 사용합니다.';

  @override
  String text_size_percent_description(Object percent) {
    return 'Android 텍스트 크기의 $percent%.';
  }

  @override
  String text_size_label_description(Object description, Object label) {
    return '$label — $description';
  }

  @override
  String files_skipped(Object count) {
    return '파일 $count개를 건너뛰었습니다: 제한 초과, 크기, 읽을 수 없음 또는 민감한 파일명.';
  }

  @override
  String model_scope_applied(Object effort, Object model) {
    return '$model • $effort 이 채팅에만 적용됩니다.';
  }

  @override
  String get reasoning_minimal => '최소';

  @override
  String get reasoning_low => '낮음';

  @override
  String get reasoning_medium => '보통';

  @override
  String get reasoning_high => '높음';

  @override
  String get reasoning_max => '최대';

  @override
  String get reasoning_ultra => '울트라';

  @override
  String get status_running => '실행 중';

  @override
  String get status_failed => '실패';

  @override
  String get status_done => '완료';

  @override
  String get status_idle => '대기 중';

  @override
  String get upload_status_uploading => '업로드 중';

  @override
  String get upload_status_uploaded => '업로드 완료';

  @override
  String attachment_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '첨부 파일 $count개',
    );
    return '$_temp0';
  }

  @override
  String get action_create => '생성';

  @override
  String get action_rename => '이름 변경';

  @override
  String get action_archive => '보관';

  @override
  String get action_restore => '복원';

  @override
  String get action_delete => '삭제';

  @override
  String get migrate => '마이그레이션';

  @override
  String assigned_chats(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '할당된 채팅 $count개',
    );
    return '$_temp0';
  }

  @override
  String get date_today => '오늘';

  @override
  String get date_yesterday => '어제';

  @override
  String get date_earlier => '이전';

  @override
  String get nav_home => '홈';

  @override
  String get nav_more => '더 보기';

  @override
  String get status_completed => '완료됨';

  @override
  String get filter_all => '전체';

  @override
  String get filter_recent => '최근';

  @override
  String connection_address_key(Object address, Object status) {
    return '$address  •  키: $status';
  }

  @override
  String model_via_provider(Object model, Object provider) {
    return '$model  \n`$provider` 경유';
  }

  @override
  String get deny => '거부';

  @override
  String get connect => '연결';

  @override
  String get appearance => '모양';

  @override
  String get connection_section => '연결';

  @override
  String get about => '정보';

  @override
  String version_label(Object version) {
    return '버전 $version';
  }

  @override
  String get matched => '일치함';

  @override
  String get search => '검색';

  @override
  String get on => '켜짐';

  @override
  String get off => '꺼짐';

  @override
  String get reasoning_off => '꺼짐';

  @override
  String get hermes_response_ready => 'Hermes 응답 준비 완료';

  @override
  String get admin_password_needed => '관리자 비밀번호 필요';

  @override
  String get hermes_needs_a_sudo_password_for_the_pending_terminal_command =>
      '대기 중인 터미널 명령을 실행하려면 Hermes에 sudo 비밀번호가 필요합니다.';

  @override
  String get sudo_password => 'sudo 비밀번호';

  @override
  String get secret_needed => '시크릿 필요';

  @override
  String get hermes_needs_a_secret_for_the_pending_skill =>
      'Hermes가 보류 중인 스킬을 위해 시크릿이 필요합니다.';

  @override
  String get secret_value => '시크릿 값';

  @override
  String get attached_file => '첨부 파일';

  @override
  String get pin_chat => '채팅 고정';

  @override
  String get unpin_chat => '채팅 고정 해제';

  @override
  String get pinned_chats => '고정됨';

  @override
  String could_not_update_chat_pin(Object error) {
    return '채팅 고정을 변경할 수 없습니다: $error';
  }

  @override
  String get could_not_save_chat_spaces => '이 기기에 채팅 공간을 저장할 수 없습니다';

  @override
  String get chat_density => '채팅 밀도';

  @override
  String chat_density_2(Object label) {
    return '채팅 밀도: $label';
  }

  @override
  String get chat_density_comfortable => '여유';

  @override
  String get chat_density_compact => '컴팩트';

  @override
  String get chat_density_comfortable_description =>
      '각 메시지 위에 발신자 라벨이 있는 넉넉한 말풍선.';

  @override
  String get chat_density_compact_description =>
      '라벨이 없는 촘촘한 말풍선으로 더 많은 메시지를 볼 수 있습니다.';

  @override
  String chat_density_label_description(Object description, Object label) {
    return '$label — $description';
  }

  @override
  String
  get compact_removes_the_you_and_hermes_labels_and_trims_bubble_padding_spacing_and_side_margins =>
      '컴팩트는 You 및 Hermes 라벨을 없애고 말풍선 여백, 간격, 좌우 여백을 줄입니다.';

  @override
  String get client_certificate_mtls => '클라이언트 인증서 (mTLS)';

  @override
  String get client_certificate_mtls_description =>
      'HTTPS 프록시에서 상호 TLS를 요구할 때 인증서를 제시합니다.';

  @override
  String get client_certificate_https_only => '클라이언트 인증서는 HTTPS 연결에서만 사용됩니다.';

  @override
  String get choose_certificate => '인증서 선택';

  @override
  String get certificate_password => '인증서 비밀번호';

  @override
  String get this_certificate_is_password_protected =>
      '이 인증서는 비밀번호로 보호되어 있습니다. 입력하면 열립니다.';

  @override
  String get enter_the_certificate_password_to_finish_loading_it =>
      '선택한 인증서를 모두 불러오려면 인증서 비밀번호를 입력하세요.';

  @override
  String get client_certificate_required =>
      '클라이언트 인증서를 불러오거나 클라이언트 인증서 옵션을 끄세요.';

  @override
  String client_certificate_loaded(String label) {
    return '불러옴: $label';
  }

  @override
  String get remove_certificate => '인증서 제거';

  @override
  String get certificate_import_failed => '해당 인증서를 불러올 수 없습니다.';

  @override
  String get background_work => '백그라운드 작업';

  @override
  String get keep_chats_active_in_background => '백그라운드에서 채팅 연결 유지';

  @override
  String get background_work_description =>
      '앱이 백그라운드에 있는 동안 사용자가 시작한 채팅의 연결을 유지합니다. 유휴 연결은 끊어질 수 있습니다. 배터리와 데이터 사용량이 늘어납니다. 꺼도 서버의 작업은 중단되지 않습니다.';

  @override
  String get background_work_limits =>
      'Android는 Doze 모드에서 연결을 일시 중지하거나 앱 프로세스를 종료할 수 있습니다. 프로세스 종료 후 알림을 받으려면 별도로 푸시를 설정해야 합니다. 강제 종료는 지원하지 않습니다.';

  @override
  String get background_work_disclosure =>
      '백그라운드 보호가 활성화된 동안에는 선택적 채팅 알림을 꺼도 필수 서비스 알림이 표시됩니다.';

  @override
  String get battery_optimisation_settings => '배터리 최적화 설정';

  @override
  String get battery_optimisation_description =>
      'Android 설정을 열어 배터리 제한을 확인합니다. 최적화 예외를 자동으로 요청하지 않으며 설정 변경이 알림 전달을 보장하지는 않습니다.';

  @override
  String get battery_settings_unavailable => '이 기기에서 배터리 설정을 열 수 없습니다.';

  @override
  String get background_work_save_failed => '백그라운드 작업 설정을 저장하지 못했습니다.';

  @override
  String get ongoing_chat_channel_name => '진행 중인 채팅';

  @override
  String get ongoing_chat_channel_description => '사용자가 시작한 미완료 채팅의 조용한 상태 알림';

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
  String get activity_status_unconfirmed => '상태 미확인';

  @override
  String get activity_recently_updated => '최근 업데이트됨';

  @override
  String get activity_reconnecting => '다시 연결 중 — 턴 상태 확인 중';

  @override
  String get activity_outcome_unknown => '턴의 결과를 확인할 수 없었습니다. 채팅을 열어 확인하세요.';

  @override
  String get activity_chat_updated_detail =>
      '게이트웨이에 기록된 채팅 활동입니다. 턴의 실시간 상태는 확인할 수 없습니다.';

  @override
  String get activity_updated => '업데이트됨';

  @override
  String get activity_empty_title => '최근 활동 없음';

  @override
  String get activity_empty_detail =>
      '이 앱에서 시작한 턴과 지난 7일 동안 업데이트된 게이트웨이 채팅이 여기에 표시됩니다.';

  @override
  String get activity_read_error =>
      '활동에서 턴 기록이나 게이트웨이 채팅을 읽을 수 없었습니다. 연결을 확인한 후 다시 시도하세요.';

  @override
  String get activity_chat_unavailable =>
      '이 채팅은 더 이상 사용할 수 없거나 게이트웨이에 연결할 수 없습니다.';

  @override
  String get activity_partial_title => '활동이 일부만 로드됨';

  @override
  String get activity_partial_detail =>
      '게이트웨이 활동의 제한된 범위가 표시됩니다. 다른 채팅이 더 있을 수 있습니다. 아래로 당겨 새로고침하세요.';

  @override
  String get provider_usage => '기록된 사용량';

  @override
  String get provider_usage_notice =>
      '최근 30일간의 Hermes 사용량이며 계정 잔액이나 모델 가격이 아닙니다. 인증 정보는 Hermes 서버에서 설정하세요. 이 앱은 공급자 API 키를 저장하지 않습니다.';

  @override
  String get provider_usage_failed => '기록된 사용량을 불러올 수 없습니다.';

  @override
  String get provider_usage_empty => '이 공급자의 사용 기록이 없습니다.';

  @override
  String provider_usage_counts(String sessions, String input, String output) {
    return '세션 $sessions개 · 입력: $input · 출력: $output';
  }

  @override
  String provider_usage_costs(String estimated, String actual) {
    return '예상: $estimated · 보고: $actual';
  }

  @override
  String get provider_quota_codex => 'OpenAI Codex 구독';

  @override
  String get provider_quota_claude => 'Claude 구독';

  @override
  String get provider_quota_openai_api => 'OpenAI API 기록된 사용량';

  @override
  String get provider_quota_notice =>
      '제공업체가 보고한 구독 사용 구간으로, Hermes에 기록된 사용량 및 API 청구와는 별개입니다. 계정은 개별적으로 표시되며, 모델 한도에 도달했다고 해서 계정 전체의 할당량을 소진한 것은 아닙니다.';

  @override
  String get provider_quota_windows_notice =>
      'Codex 및 Claude 구독에는 5시간 세션별 한도와 주간 한도가 있습니다. 제공업체가 보고한 구간만 표시되며, 보고되지 않은 한도와 초기화 시간은 확인할 수 없습니다. 주간 한도는 계정 전체 또는 특정 모델에 적용될 수 있습니다.';

  @override
  String get provider_quota_five_hour_session => '5시간 세션';

  @override
  String get provider_quota_unavailable => '구독 할당량을 확인할 수 없습니다.';

  @override
  String get provider_quota_failed =>
      '구독 할당량을 새로고침하지 못했습니다. 유지된 값은 이전 조회 결과입니다.';

  @override
  String get provider_quota_account => '계정';

  @override
  String get provider_quota_unknown => '알 수 없음';

  @override
  String provider_quota_state(String state) {
    return '계정 상태: $state';
  }

  @override
  String provider_quota_scope(String scope) {
    return '적용 범위: $scope';
  }

  @override
  String provider_quota_percent(String used, String remaining) {
    return '$used% 사용 · $remaining% 남음';
  }

  @override
  String provider_quota_reset(String reset) {
    return '초기화: $reset';
  }

  @override
  String get provider_quota_reset_unknown => '초기화 시간을 확인할 수 없습니다.';

  @override
  String get auxiliary_models => '보조 모델';

  @override
  String get auxiliary_notice =>
      '작업별 모델을 선택합니다. 사용자 지정 엔드포인트는 서버에서 관리하세요. 자동은 작업의 상속 규칙을 따릅니다.';

  @override
  String get auxiliary_inherit => '자동 (상속)';

  @override
  String get auxiliary_unavailable => '보조 설정을 사용할 수 없습니다.';

  @override
  String get provider_oauth_title => '제공업체 로그인';

  @override
  String get provider_oauth_more_subtitle => 'Hermes 호스트에서 제공업체 로그인 관리';

  @override
  String get provider_oauth_settings_subtitle =>
      'Hermes 호스트에 로그인합니다. 제공업체 토큰은 이 기기에 저장되지 않습니다';

  @override
  String get provider_oauth_intro =>
      '외부 브라우저에서 제공업체에 로그인하세요. 토큰은 이 기기가 아닌 Hermes 호스트에만 저장됩니다. 로그인해도 이 앱의 채팅 모델은 선택되지 않습니다.';

  @override
  String get provider_oauth_defaults_notice =>
      'Nous 무료 계정 교체를 비롯한 일부 호스트 절차는 호스트 기본값을 변경할 수 있습니다. 로그인 후 호스트 설정을 확인하세요.';

  @override
  String get provider_oauth_transport_init_failed =>
      '선택한 보안 대시보드 연결을 초기화할 수 없습니다. TLS ID와 연결 설정을 확인하세요.';

  @override
  String get provider_oauth_https_required =>
      '제공업체 로그인에는 Hermes 대시보드에 대한 HTTPS 연결이 필요합니다.';

  @override
  String get provider_oauth_auth_required =>
      '로그인하기 전에 대시보드 비밀번호 인증 또는 신뢰할 수 있는 프록시를 설정하세요.';

  @override
  String get provider_oauth_catalog_failed =>
      '이 호스트에서는 제공업체 로그인을 사용할 수 없습니다. 대시보드 인증을 확인하고 제공업체 OAuth를 지원하지 않는 경우 호스트를 업데이트하세요.';

  @override
  String get provider_oauth_expired => '로그인이 만료되었습니다. 다시 시작하세요.';

  @override
  String get provider_oauth_start_failed =>
      '보안 제공업체 로그인을 시작할 수 없습니다. 다시 시도하세요.';

  @override
  String get provider_oauth_denied => '로그인이 거부되었습니다. 다시 시작하세요.';

  @override
  String get provider_oauth_cancelled => '로그인이 취소되었습니다.';

  @override
  String get provider_oauth_host_failed => '호스트가 로그인을 완료하지 못했습니다. 다시 시작하세요.';

  @override
  String get provider_oauth_poll_failed => '로그인 상태를 확인할 수 없습니다. 다시 시작하세요.';

  @override
  String provider_oauth_cancellation_unconfirmed(String message) {
    return '$message 취소를 확인할 수 없습니다. 호스트 세션은 만료될 때까지 계속될 수 있습니다.';
  }

  @override
  String get provider_oauth_browser_failed =>
      '외부 브라우저를 열 수 없습니다. 다시 시도하거나 로그인을 취소하세요.';

  @override
  String get provider_oauth_retry => '다시 시도';

  @override
  String provider_oauth_complete(String provider) {
    return '$provider 로그인 완료';
  }

  @override
  String get provider_oauth_code_instruction => '제공업체 페이지에 다음 임시 코드를 입력하세요:';

  @override
  String get provider_oauth_waiting => '승인을 기다리는 중입니다. 이 세션은 자동으로 만료됩니다.';

  @override
  String get provider_oauth_open_browser => '브라우저에서 제공업체 열기';

  @override
  String get provider_oauth_cancel => '로그인 취소';

  @override
  String get provider_oauth_signed_out => '호스트에 로그인되지 않음';

  @override
  String get provider_oauth_sign_in_again => '다시 로그인';

  @override
  String get provider_oauth_sign_in => '로그인';

  @override
  String get provider_oauth_cli_required =>
      'Hermes 호스트에서 제공업체 CLI를 사용하여 로그인하세요. 이 호스트는 이 제공업체의 앱 내 로그인을 지원하지 않습니다.';

  @override
  String get provider_oauth_checking_account => '승인을 받았습니다. 호스트 계정 확인 중…';

  @override
  String get provider_oauth_verification_unavailable =>
      '승인을 받았지만 계정을 검증할 수 없습니다. 사용량을 열어 계정 사용량을 새로고침하세요.';

  @override
  String provider_oauth_verified_account(String email) {
    return 'Hermes 호스트에 $email 계정으로 로그인했습니다. 사용량을 열어 계정 사용량을 새로고침하세요.';
  }

  @override
  String get provider_oauth_credentials_unverified =>
      '호스트에서 인증 정보를 사용할 수 있다고 보고했지만 계정 신원은 검증되지 않았습니다.';

  @override
  String get provider_oauth_account_status_unknown => '호스트 계정 상태를 확인할 수 없습니다.';

  @override
  String get app_language => '앱 언어';

  @override
  String get app_language_system => '휴대전화와 동일';

  @override
  String get auto_archives_after_72_hours => '72시간 후 자동 보관';

  @override
  String get automation => '자동화';

  @override
  String get voice_recording_start => '음성 메시지 녹음';

  @override
  String get voice_recording_pause => '녹음 일시 정지';

  @override
  String get voice_recording_preview => '녹음 재생';

  @override
  String get voice_recording_resume => '녹음 계속하기';

  @override
  String get voice_recording_send => '음성 메시지 보내기';

  @override
  String get voice_recording_discard => '녹음 폐기';

  @override
  String get voice_recording_processing => '음성 메시지 준비 중…';

  @override
  String voice_recording_elapsed(String time) {
    return '녹음 중 $time';
  }

  @override
  String voice_recording_draft(String time) {
    return '음성 메시지 $time';
  }

  @override
  String get voice_recording_permission => '음성 메시지를 녹음하려면 마이크 접근을 허용하세요.';

  @override
  String get voice_recording_limit => '녹음이 최대 길이인 10분에 도달했습니다.';

  @override
  String get voice_recording_empty => '녹음된 소리가 없습니다. 다시 시도하세요.';

  @override
  String get voice_recording_failed =>
      '녹음을 처리할 수 없습니다. 저장된 녹음 조각은 모두 보관되어 있습니다.';

  @override
  String get voice_recording_unconfirmed =>
      '전달 여부가 확인되지 않았습니다. 녹음은 저장되어 있습니다. 다시 시도하기 전에 채팅을 확인하세요.';

  @override
  String get voice_recording_submit_failed =>
      '음성 메시지를 보낼 수 없습니다. 녹음은 저장되어 있습니다. 연결, 대시보드 접근 및 서버의 음성 텍스트 변환 설정을 확인하세요.';

  @override
  String get voice_recording_pause_playback => '재생 일시 정지';

  @override
  String get projects_root_title => '서버의 프로젝트 폴더';

  @override
  String get projects_root_more_subtitle => '서버에서 새 프로젝트 폴더가 생성되는 위치';

  @override
  String get projects_root_description =>
      '이 휴대폰에서 만든 프로젝트의 폴더가 여기에 생성됩니다. Hermes가 직접 사용하는 폴더로 지정하면 휴대폰과 서버가 같은 프로젝트를 공유합니다.';

  @override
  String get projects_root_label => '프로젝트 루트 경로';

  @override
  String projects_root_default_hint(String path) {
    return '서버 기본값: $path';
  }

  @override
  String get projects_root_locked_title => '서버에서 설정됨';

  @override
  String get projects_root_locked_explanation =>
      '이 서버는 파일 접근을 하나의 루트로 제한하므로 앱에서 프로젝트 폴더를 변경할 수 없습니다.';

  @override
  String get projects_root_saved => '프로젝트 폴더를 저장했습니다.';

  @override
  String get projects_root_reset => '서버 기본값 사용';

  @override
  String get projects_root_invalid_empty => '폴더 경로를 입력하세요.';

  @override
  String get projects_root_invalid_absolute => '슬래시로 시작하는 절대 경로를 입력하세요.';

  @override
  String get projects_root_invalid_segments => '경로에서 점 세그먼트와 제어 문자를 제거하세요.';

  @override
  String get projects_root_unsupported =>
      '이 연결에서는 지원되지 않습니다. 서버의 프로젝트 폴더를 읽거나 변경하려면 대시보드에 접근할 수 있는 Desktop Gateway 연결이 필요합니다.';

  @override
  String get projects_root_unavailable =>
      '서버의 프로젝트 폴더를 읽을 수 없습니다. 대시보드 연결을 확인한 후 다시 시도하세요.';

  @override
  String get adopt_folder_action => '기존 폴더 추가';

  @override
  String adopt_folder_description(String root) {
    return '$root 아래에 있으며 아직 프로젝트로 등록되지 않은 폴더입니다.';
  }

  @override
  String adopt_folder_registered(String name) {
    return '이미 프로젝트입니다: $name';
  }

  @override
  String get adopt_folder_none => '이 경로 아래의 모든 폴더가 이미 프로젝트입니다.';

  @override
  String get adopt_folder_unsupported =>
      '이 연결에서는 서버 폴더를 나열할 수 없습니다. 대신 기존 폴더의 절대 경로를 입력하세요.';

  @override
  String adopt_folder_failed(String error) {
    return '서버 폴더를 나열할 수 없습니다: $error';
  }

  @override
  String get adopt_folder_manual_label => '기존 폴더 경로';

  @override
  String get adopt_folder_name_label => '프로젝트 이름';

  @override
  String get adopt_folder_add => '프로젝트로 추가';

  @override
  String adopt_folder_added(String name, String path) {
    return '$name이(가) 이제 $path을(를) 사용합니다';
  }

  @override
  String adopt_folder_error(String error) {
    return '폴더를 추가할 수 없습니다: $error';
  }

  @override
  String adopt_folder_folderless(String name) {
    return '$name이(가) 생성되었지만 폴더가 연결되지 않았습니다. 서버의 Hermes에서 폴더를 연결하세요.';
  }

  @override
  String get slash_commands => 'Slash commands';

  @override
  String get slash_commands_loading => 'Loading commands…';

  @override
  String get slash_commands_empty => 'No matching commands';

  @override
  String slash_command_info_alias(String alias, String command) {
    return '$alias은(는) $command의 별칭입니다';
  }

  @override
  String get slash_command_info_no_description => '설명이 없습니다.';

  @override
  String get slash_command_info_arguments_options => '정해진 옵션 중 하나를 받습니다.';

  @override
  String get slash_command_info_arguments_text => '명령 뒤에 텍스트를 받습니다.';

  @override
  String get slash_command_info_arguments_mixed => '명령 뒤에 옵션이나 텍스트를 받습니다.';

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
  String get slash_command_unsupported => '이 명령은 이 서버에서 사용할 수 없습니다.';

  @override
  String get slash_sessions_inline => '세션 목록을 열어 채팅을 선택하세요. 초안은 보관되었습니다.';

  @override
  String get composer_snippets => '프롬프트 스니펫';

  @override
  String get composer_snippets_description => '입력란에 넣을 시작 프롬프트를 선택하세요.';

  @override
  String get composer_snippet_review => '코드 검토';

  @override
  String get composer_snippet_review_body =>
      '현재 변경 사항에 회귀 오류, 놓친 경계 사례 및 누락된 테스트가 있는지 점검합니다.';

  @override
  String get composer_snippet_review_text =>
      '버그, 회귀 오류 및 누락된 테스트가 있는지 검토해 주세요.';

  @override
  String get composer_snippet_plan => '구현 계획';

  @override
  String get composer_snippet_plan_body =>
      '변경 범위를 집중시키도록 코드를 수정하기 전에 접근 방식을 정리합니다.';

  @override
  String get composer_snippet_plan_text => '코드를 변경하기 전에 간결한 구현 계획을 세워 주세요.';

  @override
  String get composer_snippet_explain => '설명 요청';

  @override
  String get composer_snippet_explain_body =>
      '선택한 코드가 어떻게 동작하는지 차례로 설명하고 핵심 파일을 알려 줍니다.';

  @override
  String get composer_snippet_explain_text =>
      '이것이 어떻게 동작하는지 설명하고 핵심 파일을 알려 주세요.';

  @override
  String get composer_status => '상태';

  @override
  String get composer_status_context => '컨텍스트';

  @override
  String get composer_status_cache => '캐시 적중';

  @override
  String get composer_status_throughput => '초당 출력 토큰';

  @override
  String get composer_status_running => '실행 중';

  @override
  String get composer_status_session => '세션';

  @override
  String get composer_status_not_reported => '보고되지 않음';

  @override
  String get composer_status_empty => '컨텍스트 세부 내역이 보고되지 않았습니다.';

  @override
  String get composer_status_loading => '컨텍스트 세부 내역 불러오는 중';

  @override
  String get composer_status_reset => '상태 표시줄 초기화';

  @override
  String get composer_resume_title => '채팅 재개';

  @override
  String get composer_resume_search => '제목 및 ID 검색';

  @override
  String get composer_resume_empty => '일치하는 채팅이 없습니다.';

  @override
  String get composer_resume_unavailable => '이 창에는 검색할 채팅 목록이 없습니다.';

  @override
  String get composer_failure_retry => '다시 시도';

  @override
  String composer_failure_retry_at(String time) {
    return '$time에 다시 시도';
  }

  @override
  String get composer_failure_compress => '압축';

  @override
  String get composer_failure_switch_model => '모델 전환';

  @override
  String composer_failure_switch_to(String model) {
    return '$model(으)로 전환';
  }

  @override
  String get composer_failure_new_chat => '새 채팅';

  @override
  String get composer_failure_edit => '메시지 편집';

  @override
  String get composer_failure_details => '세부 정보';

  @override
  String get composer_failure_hide_details => '세부 정보 숨기기';

  @override
  String get composer_failure_copy => '진단 정보 복사';

  @override
  String get composer_failure_account =>
      '다른 해결 방법은 게이트웨이 계정에서 조치하는 것입니다. 이 채팅에서는 처리할 수 없습니다.';

  @override
  String get composer_failure_account_only =>
      '게이트웨이 계정에서 해결해야 합니다. 이 채팅에서는 처리할 수 없습니다.';

  @override
  String get composer_failure_confirm_compress =>
      '이 채팅을 압축할까요? 게이트웨이가 대화 기록을 줄입니다.';

  @override
  String composer_failure_confirm_model(String model) {
    return '이 채팅을 $model(으)로 전환할까요?';
  }

  @override
  String get composer_drop_attach => '놓아서 첨부';

  @override
  String get composer_drop_folder_unsupported => '폴더는 첨부할 수 없습니다. 대신 파일을 놓으세요.';

  @override
  String get composer_drop_reference => '놓아서 참조 추가';

  @override
  String get composer_reference_copy => '참조 복사';

  @override
  String get composer_reference_remove => '참조 제거';

  @override
  String get composer_btw_usage =>
      '사용법: /btw <question> — 이 대화를 중단하지 않고 대화의 스냅샷을 바탕으로 답합니다.';

  @override
  String get composer_background_usage =>
      '사용법: /background <prompt> — 작업을 별도로 실행하고 결과를 여기로 돌려줍니다.';

  @override
  String get composer_handoff_usage =>
      '사용법: /handoff <platform> — 이 채팅을 해당 메시징 플랫폼으로 넘깁니다.';

  @override
  String get composer_command_needs_session => '이 명령에는 열려 있는 채팅이 필요합니다.';

  @override
  String get composer_retry_not_found =>
      '이 턴은 저장된 기록에 없어 다시 시도로 대체할 수 없습니다. 아무것도 재전송되지 않았습니다. 다시 시도하려면 메시지를 편집하여 보내세요.';

  @override
  String get composer_retry_unavailable =>
      '이 연결에서는 다시 시도로 턴을 대체할 수 없어 아무것도 재전송되지 않았습니다. 다시 시도하려면 메시지를 편집하여 보내세요.';

  @override
  String get composer_failure_switch_no_retry =>
      '전환하면 모델만 바뀝니다. 이 연결에서는 실패한 턴을 다시 실행할 수 없습니다. 전환한 뒤 다시 보내세요.';

  @override
  String get composer_command_needs_gateway_session =>
      '이 채팅에는 아직 게이트웨이 세션이 없습니다. 먼저 메시지를 보낸 다음 명령을 다시 실행하세요.';

  @override
  String get composer_side_question => 'btw — 대화 스냅샷을 바탕으로 답변 중';

  @override
  String composer_side_question_id(String id) {
    return 'btw $id — 대화 스냅샷을 바탕으로 답변 중';
  }

  @override
  String get composer_background_started =>
      '백그라운드 작업이 시작되었습니다. 채팅을 계속할 수 있습니다. 결과가 여기에 표시됩니다.';

  @override
  String composer_background_started_id(String id) {
    return '백그라운드 작업 $id이(가) 시작되었습니다. 채팅을 계속할 수 있습니다. 결과가 여기에 표시됩니다.';
  }

  @override
  String composer_handoff_requested(String platform) {
    return '$platform(으)로 넘기기를 요청했습니다.';
  }

  @override
  String composer_handoff_done(String platform) {
    return '이 채팅을 $platform(으)로 넘겼습니다.';
  }

  @override
  String get composer_handoff_failed => '넘기기에 실패했습니다.';

  @override
  String get composer_handoff_timeout =>
      '넘기기가 완료되지 않았습니다. 게이트웨이에서 아직 실행 중일 수 있습니다.';

  @override
  String get composer_compress_done => '이 채팅을 압축했습니다.';

  @override
  String get composer_file_missing => '해당 파일이 이 기기에 없습니다.';

  @override
  String get composer_attach_busy => '이 응답이 완료되면 첨부 파일을 추가할 수 있습니다.';

  @override
  String get nextgen_toggle => 'NextGen 인터페이스';

  @override
  String get nextgen_toggle_subtitle =>
      '한 번의 로그인, 실시간 채팅, 네트워크 검색을 갖춘 새로운 디자인입니다. 게이트웨이와 채팅은 이 인터페이스와 공유됩니다.';

  @override
  String get nextgen_single_login => '하나의 로그인으로 연결';

  @override
  String get nextgen_single_login_subtitle =>
      '대시보드 주소와 한 번의 로그인만으로 게이트웨이를 추가합니다.';

  @override
  String get ng_allow_this_command => '이 명령을 허용할까요?';

  @override
  String ng_hermes_wants_to_run_this_with(Object tool) {
    return 'Hermes가 $tool로 실행하려고 합니다.';
  }

  @override
  String get ng_hermes_wants_to_run_this => 'Hermes가 실행하려고 합니다.';

  @override
  String get ng_hermes_has_a_question => 'Hermes가 질문이 있습니다';

  @override
  String get ng_hermes_has_questions => 'Hermes가 질문이 있습니다';

  @override
  String get ng_password_for_sudo => 'sudo 비밀번호';

  @override
  String get ng_hermes_needs_your_sudo_password_to =>
      '이 명령을 실행하려면 sudo 비밀번호가 필요합니다.';

  @override
  String get ng_a_secret_value => '비밀 값';

  @override
  String ng_value_for(Object variable) {
    return '$variable 값';
  }

  @override
  String get ng_your_password_manager => '비밀번호 관리자';

  @override
  String ng_unlock(Object name) {
    return '$name 잠금 해제';
  }

  @override
  String ng_hermes_needs_unlocked_to_sign_in(Object name) {
    return '대신 로그인하려면 $name의 잠금을 해제해야 합니다.';
  }

  @override
  String get ng_sign_in_code => '로그인 코드';

  @override
  String get ng_enter_the_sign_in_code => '로그인 코드를 입력하세요.';

  @override
  String ng_enter_the_sign_in_code_for(Object site) {
    return '$site의 로그인 코드를 입력하세요.';
  }

  @override
  String get ng_save_a_login => '로그인 정보를 저장할까요?';

  @override
  String ng_save_your_login(Object site) {
    return '$site 로그인 정보를 저장할까요?';
  }

  @override
  String ng_couldn_t_load_this_chat(Object error) {
    return '이 채팅을 불러오지 못했습니다: $error';
  }

  @override
  String ng_live_updates_are_unavailable(Object error) {
    return '실시간 업데이트를 사용할 수 없습니다: $error';
  }

  @override
  String ng_preparing(Object name) {
    return '$name 준비 중…';
  }

  @override
  String get ng_the_turn_failed => '응답 생성에 실패했습니다.';

  @override
  String get ng_turn_changed => '해당 응답이 이미 끝났거나 새 응답이 시작되었습니다';

  @override
  String get ng_steer_rejected => '진행 중인 응답이 받아들이지 않았습니다';

  @override
  String get ng_turn_not_known_yet => '진행 중인 응답을 아직 확인할 수 없습니다. 잠시 후 다시 시도하세요';

  @override
  String ng_couldn_t_stop(Object error) {
    return '중지하지 못했습니다: $error';
  }

  @override
  String get ng_server_access => '서버 액세스';

  @override
  String get ng_sign_in => '로그인';

  @override
  String get ng_live_connection => '실시간 연결';

  @override
  String get ng_check_that_tailscale_is_on_on =>
      '이 휴대폰과 서버에서 Tailscale이 켜져 있는지 확인하세요.';

  @override
  String get ng_check_the_address_and_that_the =>
      '주소가 올바른지, 프록시가 대시보드로 연결되도록 설정되어 있는지 확인하세요.';

  @override
  String get ng_use_the_same_network_as_the =>
      '서버와 같은 네트워크를 사용하고, 다른 기기에서 접속할 수 있도록 대시보드를 --host 0.0.0.0으로 실행하세요.';

  @override
  String get ng_check_the_address_vpn_or_tailscale =>
      '주소, VPN 또는 Tailscale 연결을 확인하세요.';

  @override
  String get ng_not_checked_yet => '아직 확인하지 않았습니다.';

  @override
  String get ng_checking => '확인 중…';

  @override
  String ng_hermes_answers_at(Object version, Object address) {
    return 'Hermes $version가 $address에서 응답합니다.';
  }

  @override
  String get ng_something_answered_but_not_a_hermes =>
      '응답은 있지만 Hermes 대시보드가 아닙니다.';

  @override
  String ng_something_answered_http_but_not_a(Object status) {
    return '응답은 있지만 Hermes 대시보드가 아닙니다(HTTP $status).';
  }

  @override
  String get ng_use_the_dashboard_s_address_and =>
      'API 서버 주소가 아닌 대시보드 주소와 포트를 사용하세요(기본값 9119).';

  @override
  String get ng_cloudflare_access_turned_the_service_token =>
      'Cloudflare Access에서 서비스 토큰을 거부했습니다.';

  @override
  String get ng_cloudflare_access_is_in_front_of =>
      '이 주소 앞에 Cloudflare Access가 있습니다.';

  @override
  String get ng_check_the_service_token_and_its =>
      '서비스 토큰과 Service Auth 정책을 확인하세요.';

  @override
  String get ng_add_a_cloudflare_access_service_token =>
      '이 주소에 Cloudflare Access 서비스 토큰을 추가하세요.';

  @override
  String get ng_the_server_asks_for_a_client => '서버에서 클라이언트 인증서를 요청합니다.';

  @override
  String get ng_pick_the_client_certificate_for_this =>
      '이 게이트웨이에 사용할 클라이언트 인증서를 선택한 다음 다시 테스트하세요.';

  @override
  String get ng_needs_server_access_first => '먼저 서버에 연결해야 합니다.';

  @override
  String get ng_needs_a_sign_in_first => '먼저 로그인해야 합니다.';

  @override
  String ng_signed_in_as(Object name) {
    return '$name(으)로 로그인했습니다.';
  }

  @override
  String get ng_this_dashboard_doesn_t_need_a => '이 대시보드에는 로그인이 필요하지 않습니다.';

  @override
  String get ng_the_saved_sign_in_has_expired => '저장된 로그인 정보가 만료되었습니다.';

  @override
  String get ng_sign_in_again => '다시 로그인하세요.';

  @override
  String get ng_too_many_sign_in_attempts => '로그인 시도가 너무 많습니다.';

  @override
  String get ng_wait_a_minute_then_check_again => '잠시 기다린 후 다시 확인하세요.';

  @override
  String ng_the_gateway_answered(Object message) {
    return '게이트웨이 응답: $message.';
  }

  @override
  String get ng_sign_in_again_or_update_hermes => '다시 로그인하거나 Hermes를 업데이트하세요.';

  @override
  String ng_couldn_t_check_the_sign_in(Object error) {
    return '로그인 상태를 확인하지 못했습니다: $error';
  }

  @override
  String ng_the_gateway_wouldn_t_issue_a(Object message) {
    return '게이트웨이에서 채팅 티켓을 발급하지 않았습니다($message).';
  }

  @override
  String get ng_the_chat_connection_opened_and_the =>
      '채팅 연결이 열렸고 게이트웨이가 준비되었다고 알렸습니다.';

  @override
  String get ng_the_gateway_never_said_it_was => '게이트웨이에서 준비되었다는 응답이 없습니다.';

  @override
  String get ng_check_that_the_agent_is_running => '서버에서 에이전트가 실행 중인지 확인하세요.';

  @override
  String get ng_the_gateway_refused_the_chat_connection =>
      '게이트웨이에서 채팅 연결을 거부했습니다(HTTP 403).';

  @override
  String get ng_this_dashboard_has_no_chat_endpoint =>
      '이 대시보드에는 채팅 엔드포인트(/api/ws)가 없습니다.';

  @override
  String ng_the_chat_connection_failed(Object detail) {
    return '채팅 연결에 실패했습니다: $detail';
  }

  @override
  String get ng_use_the_exact_address_the_dashboard =>
      '대시보드에 설정된 정확한 주소를 사용하세요.';

  @override
  String get ng_update_hermes => 'Hermes를 업데이트하세요.';

  @override
  String get ng_make_sure_the_proxy_allows_websocket =>
      '프록시에서 /api/ws의 WebSocket 업그레이드를 허용하는지 확인하세요.';

  @override
  String get ng_offline => '오프라인';

  @override
  String get ng_connecting => '연결 중…';

  @override
  String get ng_connected => '연결됨';

  @override
  String get ng_reconnecting => '다시 연결 중…';

  @override
  String get ng_signed_out => '로그아웃됨';

  @override
  String get ng_connection_failed => '연결 실패';

  @override
  String get ng_rate_limited_by_gateway => '게이트웨이에서 요청이 제한됨';

  @override
  String ng_couldn_t_open_the_chat_connection(Object message) {
    return '채팅 연결을 열 수 없습니다: $message';
  }

  @override
  String get ng_the_gateway_returned_no_websocket_ticket =>
      '게이트웨이가 WebSocket 티켓을 반환하지 않았습니다.';

  @override
  String get ng_connection_lost => '연결 끊김';

  @override
  String get ng_this_dashboard_has_no_chat_endpoint_2 =>
      '이 대시보드에 채팅 엔드포인트(/api/ws)가 없습니다. Hermes를 업데이트하세요.';

  @override
  String get ng_the_gateway_refused_the_chat_connection_2 =>
      '게이트웨이가 채팅 연결을 거부했습니다. 주소가 대시보드에 설정된 호스트와 일치하는지, 임베디드 채팅이 활성화되어 있는지 확인하세요.';

  @override
  String ng_the_gateway_refused(Object method) {
    return '게이트웨이가 $method 요청을 거부했습니다.';
  }

  @override
  String ng_couldn_t_read_your_saved_gateways(Object error) {
    return '저장된 게이트웨이를 읽을 수 없습니다: $error';
  }

  @override
  String get ng_applies_to_new_chats => '새 채팅부터 적용';

  @override
  String ng_couldn_t_change(Object label, Object error) {
    return '$label을(를) 변경할 수 없습니다: $error';
  }

  @override
  String get ng_capabilities => '기능';

  @override
  String get ng_skills => '스킬';

  @override
  String get ng_toolsets => '도구 모음';

  @override
  String get ng_search => '검색';

  @override
  String get ng_couldn_t_load => '불러오지 못했습니다';

  @override
  String get ng_try_again => '다시 시도';

  @override
  String get ng_no_skills => '스킬 없음';

  @override
  String get ng_no_toolsets => '도구 모음 없음';

  @override
  String get ng_no_mcp_servers => 'MCP 서버 없음';

  @override
  String get ng_that_file_is_too_large_to => '인증서 파일로 사용하기에는 너무 큽니다.';

  @override
  String ng_the_certificate_couldn_t_be_imported(Object error) {
    return '인증서를 가져오지 못했습니다: $error';
  }

  @override
  String get ng_now_pick_its_private_key => '이제 개인 키를 선택하세요.';

  @override
  String get ng_now_pick_its_certificate => '이제 인증서를 선택하세요.';

  @override
  String get ng_that_file_isn_t_a_certificate => '인증서 또는 개인 키 파일이 아닙니다.';

  @override
  String get ng_if_a_proxy_in_front_of =>
      '이 주소 앞의 프록시가 클라이언트 인증서를 요청하면, 테스트와 로그인, 채팅에서 인증서를 사용할 수 있도록 여기서 선택하세요.';

  @override
  String get ng_client_certificates_are_only_used_with =>
      '클라이언트 인증서는 https:// 주소에서만 사용됩니다.';

  @override
  String get ng_remove => '삭제';

  @override
  String get ng_certificate_password => '인증서 비밀번호';

  @override
  String get ng_importing => '가져오는 중…';

  @override
  String get ng_pick_certificate => '인증서 선택';

  @override
  String get ng_pick_a_different_certificate => '다른 인증서 선택';

  @override
  String get ng_accepts_p12_pfx_or_pem_certificate =>
      '.p12/.pfx 파일 또는 PEM 인증서와 키 파일을 지원합니다. 키는 이 앱의 비공개 저장소에 보관됩니다.';

  @override
  String get ng_photos => '사진';

  @override
  String get ng_camera => '카메라';

  @override
  String get ng_files => '파일';

  @override
  String ng_you_can_attach_up_to_files(Object count) {
    return '파일을 최대 $count개 첨부할 수 있습니다.';
  }

  @override
  String ng_couldn_t_read(Object name) {
    return '$name을(를) 읽을 수 없습니다.';
  }

  @override
  String ng_couldn_t_prepare_that_file(Object error) {
    return '파일을 준비할 수 없습니다: $error';
  }

  @override
  String get ng_hermes_is_still_working => 'Hermes가 아직 작업 중입니다';

  @override
  String get ng_steer => '지시';

  @override
  String get ng_adds_this_to_the_running_turn => '진행 중인 작업의 다음 단계에 추가합니다';

  @override
  String get ng_queue => '대기열';

  @override
  String get ng_sends_it_when_the_turn_finishes => '작업이 끝나면 전송합니다';

  @override
  String get ng_stop_and_send => '중단 후 보내기';

  @override
  String get ng_stops_the_turn_then_sends_this => '작업을 중단한 뒤 전송합니다';

  @override
  String ng_dictation_stopped(Object message) {
    return '받아쓰기가 중지되었습니다: $message';
  }

  @override
  String get ng_speech_recognition_isn_t_available => '음성 인식을 사용할 수 없습니다.';

  @override
  String get ng_working => '작업 중';

  @override
  String get ng_ready => '준비됨';

  @override
  String get ng_chats => '채팅';

  @override
  String get ng_new_chat => '새 채팅';

  @override
  String get ng_usage => '사용량';

  @override
  String get ng_rename_chat => '채팅 이름 변경';

  @override
  String ng_couldn_t_rename(Object error) {
    return '이름을 변경할 수 없습니다: $error';
  }

  @override
  String get ng_this_chat => '이 채팅';

  @override
  String get ng_input_tokens => '입력 토큰';

  @override
  String get ng_output_tokens => '출력 토큰';

  @override
  String get ng_reasoning_tokens => '추론 토큰';

  @override
  String get ng_cache_reads => '캐시 읽기';

  @override
  String get ng_api_calls => 'API 호출';

  @override
  String get ng_cost => '비용';

  @override
  String get ng_context => '컨텍스트';

  @override
  String get ng_your_sign_in_expired => '로그인이 만료됐어요.';

  @override
  String get ng_sign_in_2 => '로그인';

  @override
  String get ng_retry => '다시 시도';

  @override
  String get ng_project_home => '홈';

  @override
  String get ng_choose_project => '프로젝트 선택';

  @override
  String ng_project_cwd_fallback(String path) {
    return '프로젝트 폴더를 사용할 수 없어 이 채팅은 $path에서 실행됩니다.';
  }

  @override
  String get ng_project_create_uncertain =>
      '게이트웨이가 채팅을 만들었을 수 있지만 확인하지 못했습니다. 새 채팅을 시작하기 전에 채팅 목록을 확인하세요. 이 요청은 자동으로 재시도되지 않습니다.';

  @override
  String get ng_what_should_we_work_on => '무엇을 해볼까요?';

  @override
  String get ng_ask_hermes_anything_it_can_run =>
      'Hermes에 무엇이든 물어보세요. 도구를 실행하고, 웹을 탐색하고, 서버의 파일을 다룰 수 있어요.';

  @override
  String ng_working_2(Object frame) {
    return '작업 중 · $frame';
  }

  @override
  String get ng_default_model => '기본 모델';

  @override
  String get ng_listening => '듣는 중…';

  @override
  String get ng_steer_or_queue_a_message => '메시지를 지시하거나 대기열에 추가하세요';

  @override
  String get ng_message_hermes => 'Hermes에 메시지 보내기';

  @override
  String get ng_attach => '첨부';

  @override
  String get ng_stop_dictation => '받아쓰기 중지';

  @override
  String get ng_dictate => '받아쓰기';

  @override
  String get ng_stop => '중지';

  @override
  String get ng_send => '보내기';

  @override
  String ng_slash_command_alias(String alias, String command) {
    return '$alias은(는) $command의 별칭입니다';
  }

  @override
  String get ng_slash_command_no_description => '설명이 없습니다.';

  @override
  String get ng_slash_command_arguments_options => '정해진 옵션 중 하나를 받습니다.';

  @override
  String get ng_slash_command_arguments_text => '명령 뒤에 텍스트를 받습니다.';

  @override
  String get ng_slash_command_arguments_mixed => '명령 뒤에 옵션이나 텍스트를 받습니다.';

  @override
  String get ng_slash_command_sent_as_message =>
      'NextGen에서는 이 내용이 일반 메시지로 Hermes에 전송되며, 명령 자체는 실행되지 않습니다.';

  @override
  String get ng_slash_command_output => '명령 출력';

  @override
  String get ng_slash_command_running => '명령 실행 중…';

  @override
  String get ng_slash_command_done => '완료되었습니다.';

  @override
  String ng_slash_command_failed(Object error) {
    return '명령을 실행하지 못했습니다: $error';
  }

  @override
  String get ng_slash_command_refused => 'Hermes는 여기에서 이 명령을 실행할 수 없습니다.';

  @override
  String get ng_slash_command_delivery_unknown =>
      '명령을 보냈지만 응답이 오지 않았습니다. 게이트웨이에서 아직 실행 중일 수 있으므로 다시 보내지 않았고 초안은 그대로 두었습니다.';

  @override
  String get ng_slash_command_nothing_running => '실행 중인 작업이 없습니다.';

  @override
  String get ng_steered => '지시 반영됨';

  @override
  String get ng_copied => '복사됨';

  @override
  String ng_not_sent(Object reason) {
    return '전송되지 않음: $reason';
  }

  @override
  String get ng_thinking => '생각 중…';

  @override
  String get ng_thought => '생각';

  @override
  String ng_used(Object name) {
    return '$name 사용함';
  }

  @override
  String ng_used_tools(Object count) {
    return '도구 $count개 사용함';
  }

  @override
  String get ng_copy => '복사';

  @override
  String get ng_read_aloud => '소리 내어 읽기';

  @override
  String get ng_the_gateway_connection_dropped_try_again =>
      '게이트웨이 연결이 끊겼어요. 다시 시도해 주세요.';

  @override
  String get ng_allow_once => '한 번 허용';

  @override
  String get ng_allow_until_sandbox_off => '샌드박스가 꺼질 때까지';

  @override
  String get ng_folder_access => '폴더 접근';

  @override
  String get ng_folder_access_unspecified =>
      '게이트웨이가 읽기 전용인지 읽기 및 쓰기인지 알려 주지 않았습니다.';

  @override
  String get ng_folder_read_only => '읽기 전용';

  @override
  String get ng_folder_read_write => '읽기 및 쓰기';

  @override
  String get ng_website_access => '웹사이트 접근';

  @override
  String get ng_allow_for_this_chat => '이 채팅에서 허용';

  @override
  String get ng_always_allow => '항상 허용';

  @override
  String get ng_deny => '거부';

  @override
  String get ng_your_answer => '내 답변';

  @override
  String get ng_or_type_an_answer => '또는 답변 입력';

  @override
  String get ng_skip => '건너뛰기';

  @override
  String get ng_answer => '답변';

  @override
  String get ng_cancel => '취소';

  @override
  String get ng_username_or_email => '사용자 이름 또는 이메일';

  @override
  String get ng_password => '비밀번호';

  @override
  String get ng_not_now => '나중에';

  @override
  String get ng_save => '저장';

  @override
  String get ng_enter_both_the_client_id_and =>
      'Client ID와 Client Secret을 모두 입력하거나, 둘 다 입력하지 마세요.';

  @override
  String get ng_enter_your_username_and_password => '사용자 이름과 비밀번호를 입력하세요.';

  @override
  String ng_couldn_t_save_the_sign_in(Object error) {
    return '로그인 정보를 저장하지 못했어요: $error';
  }

  @override
  String get ng_wrong_username_or_password => '사용자 이름 또는 비밀번호가 올바르지 않아요.';

  @override
  String get ng_too_many_attempts_wait_a_moment =>
      '시도 횟수가 너무 많아요. 잠시 후 다시 시도하세요.';

  @override
  String get ng_welcome_to_hermes => 'Ares에 오신 것을 환영해요';

  @override
  String get ng_add_a_gateway => '게이트웨이 추가';

  @override
  String get ng_connect_to_your_hermes_agent_dashboard =>
      'Hermes Agent 대시보드에 연결하세요. 주소 하나와 로그인 한 번으로 채팅, 도구, 설정을 이용할 수 있어요. 로그인하기 전에는 아무것도 전송되지 않아요.';

  @override
  String get ng_connect_to_another_hermes_agent_dashboard =>
      '다른 Hermes Agent 대시보드에 연결하세요. 저장한 대시보드에는 계속 로그인된 상태로 유지돼요.';

  @override
  String get ng_dashboard_address => '대시보드 주소';

  @override
  String get ng_testing => '테스트 중…';

  @override
  String get ng_test => '테스트';

  @override
  String get ng_where_your_hermes_dashboard_runs_lan =>
      'Hermes 대시보드가 실행되는 주소예요. LAN, Tailscale 또는 HTTPS를 사용하세요.';

  @override
  String get ng_find_on_my_network => '내 네트워크에서 찾기';

  @override
  String get ng_which_address_do_i_use => '어떤 주소를 사용해야 하나요?';

  @override
  String get ng_behind_cloudflare_access => 'Cloudflare Access를 사용 중인가요?';

  @override
  String get ng_need_a_client_certificate => '클라이언트 인증서가 필요한가요?';

  @override
  String get ng_this_address_isn_t_private_and =>
      '이 주소는 비공개가 아니고 https://도 사용하지 않아 비밀번호와 채팅 내용이 암호화되지 않은 채 인터넷을 통해 전송돼요. https://, Tailscale 또는 자체 네트워크를 사용하세요.';

  @override
  String get ng_continue_to_sign_in => '로그인 계속하기';

  @override
  String get ng_use_the_classic_interface_instead => '대신 클래식 인터페이스 사용';

  @override
  String get ng_if_cloudflare_access_protects_this_address =>
      '이 주소가 Cloudflare Access로 보호되는 경우, Cloudflare Zero Trust에서 서비스 토큰(Access, Service credentials)을 만들고 Access 애플리케이션에 해당 토큰용 Service Auth 정책을 추가하세요.';

  @override
  String get ng_a_service_token_is_saved_for => '이 주소의 서비스 토큰이 저장되어 있어요';

  @override
  String get ng_forget => '삭제';

  @override
  String get ng_client_id => 'Client ID';

  @override
  String get ng_client_secret => 'Client Secret';

  @override
  String get ng_stored_encrypted_on_this_phone_and =>
      '이 휴대폰에 암호화되어 저장되며, 이 주소로만 전송돼요.';

  @override
  String get ng_hermes_is_reachable => 'Hermes에 연결할 수 있어요';

  @override
  String ng_hermes_is_reachable_2(Object version) {
    return 'Hermes $version에 연결할 수 있어요';
  }

  @override
  String get ng_sign_in_is_tested_next_then => '먼저 로그인 테스트를 진행한 다음 채팅합니다';

  @override
  String get ng_agent_gateway => '에이전트 게이트웨이';

  @override
  String get ng_running => '실행 중';

  @override
  String get ng_stopped => '중지됨';

  @override
  String get ng_username_password => '사용자 이름 및 비밀번호';

  @override
  String get ng_browser => '브라우저';

  @override
  String get ng_in_the_browser_sso => '브라우저에서 (SSO)';

  @override
  String get ng_profiles => '프로필';

  @override
  String get ng_this_dashboard_offers_neither_a_username =>
      '이 대시보드는 사용자 이름/비밀번호 로그인과 브라우저 로그인을 모두 지원하지 않습니다. Hermes를 업데이트하거나 서버에서 사용자 이름/비밀번호 로그인을 설정하세요.';

  @override
  String get ng_the_auth_gate_is_off_on =>
      '이 대시보드의 인증이 꺼져 있습니다. 대시보드에 접속할 수 있는 누구나 에이전트를 사용할 수 있습니다.';

  @override
  String get ng_couldn_t_reach_the_dashboard => '대시보드에 연결할 수 없습니다';

  @override
  String ng_check_the_address_and_port_9119(Object reason) {
    return '$reason\n\n주소와 포트를 확인하세요 (기본값: 9119). 대시보드가 아직 실행 중이 아니라면 서버에서 다음 명령을 실행하세요:\nhermes dashboard --host 0.0.0.0';
  }

  @override
  String get ng_that_isn_t_a_hermes_dashboard => 'Hermes 대시보드가 아닙니다';

  @override
  String get ng_something_answered_but_not_a_hermes_2 =>
      '응답은 있었지만 Hermes 대시보드가 아닙니다. API 서버 주소(포트 8642)가 아닌 대시보드 주소를 사용하세요.';

  @override
  String ng_something_answered_http_but_not_a_2(Object status) {
    return '응답은 있었지만 (HTTP $status) Hermes 대시보드가 아닙니다. API 서버 주소(포트 8642)가 아닌 대시보드 주소를 사용하세요.';
  }

  @override
  String get ng_cloudflare_access_stopped_the_request =>
      'Cloudflare Access가 요청을 차단했습니다';

  @override
  String ng_cloudflare_access_turned_down_the_service(Object status) {
    return 'Cloudflare Access에서 서비스 토큰을 거부했습니다 (HTTP $status). Client ID와 Secret, Service Auth 정책을 확인하세요.';
  }

  @override
  String get ng_add_a_cloudflare_access_service_token_2 =>
      '아래에 Cloudflare Access 서비스 토큰을 추가한 뒤 다시 테스트하세요.';

  @override
  String get ng_a_client_certificate_is_needed => '클라이언트 인증서가 필요합니다';

  @override
  String get ng_this_server_asks_for_a_client =>
      '이 서버는 통신 전에 클라이언트 인증서를 요구합니다. 아래에서 발급받은 인증서를 선택한 뒤 다시 테스트하세요.';

  @override
  String get ng_this_dashboard_doesn_t_ask_for => '이 대시보드는 로그인을 요구하지 않습니다.';

  @override
  String ng_use_the_dashboard_username_and_password(Object address) {
    return '$address에 설정된 대시보드 사용자 이름과 비밀번호를 사용하거나 브라우저에서 로그인하세요.';
  }

  @override
  String ng_use_the_dashboard_username_and_password_2(Object address) {
    return '$address에 설정된 대시보드 사용자 이름과 비밀번호를 사용하세요.';
  }

  @override
  String ng_sign_in_to_in_your_browser(Object address) {
    return '브라우저에서 $address에 접속해 대시보드 계정으로 로그인하세요.';
  }

  @override
  String ng_gateway(Object address) {
    return '게이트웨이 $address';
  }

  @override
  String get ng_profile => '프로필';

  @override
  String get ng_server_default => '서버 기본값';

  @override
  String get ng_continue => '계속';

  @override
  String get ng_username => '사용자 이름';

  @override
  String get ng_signing_in => '로그인 중…';

  @override
  String get ng_waiting_for_the_browser => '브라우저를 기다리는 중…';

  @override
  String get ng_sign_in_with_browser => '브라우저로 로그인';

  @override
  String get ng_finish_signing_in_on_the_page =>
      '열린 페이지에서 로그인을 완료하세요. 완료되면 Hermes가 자동으로 돌아옵니다.';

  @override
  String get ng_use_a_different_gateway => '다른 게이트웨이 사용';

  @override
  String get ng_same_wi_fi_or_local_network => '같은 Wi-Fi 또는 로컬 네트워크';

  @override
  String get ng_use_the_server_s_local_address =>
      '서버의 로컬 주소와 포트를 입력하세요. 예: 192.168.1.20:9119. 다른 기기에서 접속할 수 있도록 --host 0.0.0.0 옵션으로 대시보드를 시작하세요.';

  @override
  String get ng_tailscale => 'Tailscale';

  @override
  String get ng_turn_on_tailscale_on_this_phone =>
      '이 휴대폰에서 Tailscale을 켜고 서버의 Tailscale 주소를 사용하세요. 예: 100.64.0.1:9119 또는 .ts.net 이름. 집 밖에서도 사용할 수 있습니다.';

  @override
  String get ng_use_your_https_address_when_the =>
      '인증서가 있는 프록시 뒤에서 대시보드를 실행한다면 https:// 주소를 사용하세요. 프록시는 /api/ws의 WebSocket 업그레이드도 전달해야 합니다.';

  @override
  String get ng_start_the_dashboard_on_the_server => '서버에서 대시보드를 시작하세요:';

  @override
  String get ng_enter_a_port_from_1_to => '1~65535 사이의 포트를 입력하세요.';

  @override
  String get ng_looks_for_hermes_dashboards_on_port =>
      '이 Wi-Fi 네트워크에서 포트 9119의 Hermes 대시보드를 찾고, 저장된 컴퓨터도 확인합니다.';

  @override
  String ng_looks_for_hermes_dashboards_on_ports(Object port) {
    return '이 Wi-Fi 네트워크에서 포트 9119 및 $port의 Hermes 대시보드를 찾고, 저장된 컴퓨터도 확인합니다.';
  }

  @override
  String get ng_other_port_optional => '다른 포트 (선택사항)';

  @override
  String get ng_no_dashboards_answered_start_one_with =>
      '응답한 대시보드가 없습니다. hermes dashboard --host 0.0.0.0으로 시작하거나 주소를 입력하세요.';

  @override
  String get ng_using_tailscale_or_a_vpn_those =>
      'Tailscale 또는 VPN을 사용 중인가요? 해당 네트워크는 검색할 수 없습니다. 컴퓨터의 100.x 주소나 .ts.net 이름을 입력하세요.';

  @override
  String get ng_search_again => '다시 검색';

  @override
  String get ng_insights => '인사이트';

  @override
  String get ng_couldn_t_load_insights => '인사이트를 불러올 수 없습니다';

  @override
  String get ng_sessions => '세션';

  @override
  String get ng_tokens => '토큰';

  @override
  String get ng_est_cost => '예상 비용';

  @override
  String get ng_daily_tokens => '일일 토큰';

  @override
  String get ng_models => '모델';

  @override
  String get ng_tools => '도구';

  @override
  String get ng_hermes_is_waiting_for_you => 'Hermes가 기다리고 있습니다.';

  @override
  String get ng_hermes_replied => 'Hermes가 답변했습니다';

  @override
  String get ng_the_turn_finished => '응답이 완료되었습니다.';

  @override
  String get ng_off => '끔';

  @override
  String get ng_minimal => '최소';

  @override
  String get ng_low => '낮음';

  @override
  String get ng_medium => '보통';

  @override
  String get ng_high => '높음';

  @override
  String get ng_extra_high => '매우 높음';

  @override
  String get ng_max => '최대';

  @override
  String get ng_ultra => '울트라';

  @override
  String get ng_default => '기본값';

  @override
  String ng_couldn_t_switch_model(Object error) {
    return '모델을 전환할 수 없어요: $error';
  }

  @override
  String get ng_model => '모델';

  @override
  String get ng_thinking_2 => '생각 중';

  @override
  String get ng_search_models => '모델 검색';

  @override
  String get ng_no_models_match => '이 필터와 일치하는 모델이 없습니다.';

  @override
  String get privacy_policy => '개인정보 처리방침';

  @override
  String get report_ai_output => 'AI 응답 신고';

  @override
  String ng_couldn_t_load_models(Object error) {
    return '모델을 불러올 수 없어요: $error';
  }

  @override
  String get ng_no_providers_are_set_up_on => '이 게이트웨이에 설정된 제공업체가 아직 없어요.';

  @override
  String get ng_starred => '즐겨찾기';

  @override
  String get ng_recent => '최근 항목';

  @override
  String get ng_more => '더 보기';

  @override
  String get ng_archived_chats => '보관된 채팅';

  @override
  String get ng_projects => '프로젝트';

  @override
  String get ng_chats_grouped_by_project_and_workspace => '프로젝트 및 워크스페이스별 채팅';

  @override
  String get ng_agent => '에이전트';

  @override
  String get ng_memory => '메모리';

  @override
  String get ng_what_hermes_remembers_about_you => 'Hermes가 기억하는 내용';

  @override
  String get ng_skills_library => '스킬 라이브러리';

  @override
  String get ng_browse_and_read_installed_skills => '설치된 스킬 둘러보기 및 읽기';

  @override
  String get ng_cron_editor => '크론 편집기';

  @override
  String get ng_edit_schedules_prompts_and_delivery => '일정, 프롬프트 및 전달 설정 편집';

  @override
  String get ng_config_file => '설정 파일';

  @override
  String get ng_edit_config_yaml_on_the_gateway => '게이트웨이의 config.yaml 편집';

  @override
  String get ng_models_and_providers => '모델 및 제공업체';

  @override
  String get ng_model_management => '모델 관리';

  @override
  String get ng_default_fallback_and_auxiliary_models => '기본, 대체 및 보조 모델';

  @override
  String get ng_provider_sign_in => '제공업체 로그인';

  @override
  String get ng_connect_provider_accounts_with_oauth => 'OAuth로 제공업체 계정 연결';

  @override
  String get ng_nous_portal => 'Nous Portal';

  @override
  String get ng_subscription_credits_and_usage => '구독, 크레딧 및 사용량';

  @override
  String get ng_interface => '인터페이스';

  @override
  String get ng_switch_to_the_classic_interface => '클래식 인터페이스로 전환';

  @override
  String get ng_turns_nextgen_off_you_can_turn =>
      'NextGen을 끕니다. 설정에서 다시 켤 수 있어요.';

  @override
  String get ng_restored => '복원됨';

  @override
  String get ng_archived => '보관됨';

  @override
  String get ng_couldn_t_load_archived_chats => '보관된 채팅을 불러올 수 없어요';

  @override
  String get ng_nothing_archived => '보관된 항목이 없어요';

  @override
  String get ng_restore => '복원';

  @override
  String get ng_saved_new_chats_use_it => '저장했어요. 새 채팅부터 적용돼요.';

  @override
  String ng_couldn_t_save(Object error) {
    return '저장할 수 없어요: $error';
  }

  @override
  String get ng_saving => '저장 중…';

  @override
  String ng_today(Object time) {
    return '오늘 $time';
  }

  @override
  String get ng_mon => '월';

  @override
  String get ng_tue => '화';

  @override
  String get ng_wed => '수';

  @override
  String get ng_thu => '목';

  @override
  String get ng_fri => '금';

  @override
  String get ng_sat => '토';

  @override
  String get ng_sun => '일';

  @override
  String get ng_scheduled => '예약됨';

  @override
  String get ng_new_job => '새 작업';

  @override
  String get ng_couldn_t_load_scheduled_jobs => '예약된 작업을 불러올 수 없어요';

  @override
  String get ng_nothing_scheduled => '예약된 작업이 없어요';

  @override
  String get ng_ask_hermes_to_do_something_on =>
      'Hermes에게 정기 작업을 요청하거나 여기서 작업을 추가하세요.';

  @override
  String get ng_active => '활성';

  @override
  String get ng_paused => '일시 정지됨';

  @override
  String ng_next(Object when) {
    return '다음 $when';
  }

  @override
  String ng_last(Object when) {
    return '마지막 $when';
  }

  @override
  String ng_last_2(Object when, Object result) {
    return '마지막 $when · $result';
  }

  @override
  String ng_job(Object id) {
    return '작업 $id';
  }

  @override
  String get ng_delete => '삭제';

  @override
  String get ng_delete_this_job => '이 작업을 삭제할까요?';

  @override
  String get ng_it_stops_running_past_runs_stay =>
      '작업 실행이 중지돼요. 이전 실행 기록은 채팅에 남아요.';

  @override
  String ng_next_run(Object when) {
    return '다음 실행 $when';
  }

  @override
  String ng_delivers_to(Object target) {
    return '$target에 전달';
  }

  @override
  String get ng_run_now => '지금 실행';

  @override
  String get ng_started => '시작됨';

  @override
  String get ng_pause => '일시중지';

  @override
  String get ng_resume => '재개';

  @override
  String get ng_resumed => '재개됨';

  @override
  String get ng_prompt => '프롬프트';

  @override
  String get ng_runs => '실행 기록';

  @override
  String get ng_no_runs_yet => '아직 실행 기록이 없습니다.';

  @override
  String get ng_enter_a_schedule_and_a_prompt => '일정과 프롬프트를 입력하세요.';

  @override
  String get ng_name_optional => '이름 (선택 사항)';

  @override
  String get ng_schedule => '일정';

  @override
  String get ng_every_1h_0_9_or_30m => 'every 1h, 0 9 * * *, or 30m';

  @override
  String get ng_create => '만들기';

  @override
  String get ng_unpin => '고정 해제';

  @override
  String get ng_pin => '고정';

  @override
  String get ng_rename => '이름 변경';

  @override
  String get ng_archive => '보관';

  @override
  String get ng_delete_this_chat => '이 채팅을 삭제할까요?';

  @override
  String get ng_it_is_removed_from_the_gateway => '모든 기기의 게이트웨이에서 삭제됩니다.';

  @override
  String get ng_search_chats => '채팅 검색';

  @override
  String get ng_pinned => '고정됨';

  @override
  String get ng_no_chats_match => '일치하는 채팅이 없습니다.';

  @override
  String get ng_no_chats_yet => '아직 채팅이 없습니다.';

  @override
  String get ng_nothing_is_running => '실행 중인 항목이 없습니다.';

  @override
  String get ng_nothing_is_waiting_on_you => '확인할 항목이 없습니다.';

  @override
  String get ng_settings => '설정';

  @override
  String get ng_all => '전체';

  @override
  String ng_needs_you(Object count) {
    return '확인 필요 · $count';
  }

  @override
  String get ng_needs_you_2 => '확인 필요';

  @override
  String get ng_gateways => '게이트웨이';

  @override
  String ng_classic_connection(Object address) {
    return '$address · 클래식 연결';
  }

  @override
  String get ng_gateway_2 => '게이트웨이';

  @override
  String get ng_signed_in => '로그인됨';

  @override
  String get ng_classic_connection_2 => '클래식 연결';

  @override
  String get ng_in_the_browser => '브라우저에서';

  @override
  String ng_in_the_browser_as(Object name) {
    return '브라우저에서 $name(으)로';
  }

  @override
  String get ng_not_required => '필요 없음';

  @override
  String get ng_test_connection => '연결 테스트';

  @override
  String get ng_sign_in_again_2 => '다시 로그인';

  @override
  String get ng_sign_out => '로그아웃';

  @override
  String get ng_saved_gateways => '저장된 게이트웨이';

  @override
  String get ng_in_use => '사용 중';

  @override
  String get ng_appearance => '모양';

  @override
  String get ng_theme => '테마';

  @override
  String get ng_system => '시스템';

  @override
  String get ng_light => '라이트';

  @override
  String get ng_dark => '다크';

  @override
  String get ng_accent => '강조색';

  @override
  String get ng_pure_black => '순수 검정';

  @override
  String get ng_dark_theme_uses_true_black_oled =>
      '다크 테마에서 OLED용 완전한 검은색을 사용합니다.';

  @override
  String get ng_glow => '글로우';

  @override
  String get ng_soft_accent_light_behind_each_screen =>
      '화면 뒤에 은은한 강조색 조명을 표시합니다.';

  @override
  String get ng_the_new_interface_turn_off_to =>
      '새 인터페이스입니다. 끄면 클래식 인터페이스로 돌아갑니다. 게이트웨이와 채팅은 두 인터페이스에서 공유됩니다.';

  @override
  String get ng_more_settings => '추가 설정';

  @override
  String get ng_voice_notifications_language_backups_and_the =>
      '음성, 알림, 언어, 백업 및 게이트웨이 설정';

  @override
  String get ng_licences => '라이선스';

  @override
  String ng_sign_out_of(Object name) {
    return '$name에서 로그아웃할까요?';
  }

  @override
  String get ng_this_gateway_and_its_saved_sign =>
      '이 게이트웨이와 저장된 로그인 정보가 두 인터페이스 모두에서 이 휴대폰에서 삭제됩니다. 채팅은 게이트웨이에 남아 있습니다.';

  @override
  String get ng_password_or_browser => '비밀번호 또는 브라우저';

  @override
  String get ng_unsupported => '지원되지 않음';

  @override
  String get ng_background_task_finished => '백그라운드 작업 완료';

  @override
  String get ng_background_process_finished => '백그라운드 프로세스 완료';

  @override
  String get ng_system_message => '시스템 메시지';

  @override
  String get ng_summary => '요약';

  @override
  String get classic_interface_only => '클래식 인터페이스 전용';

  @override
  String get classic_only_settings_hint =>
      '클래식 인터페이스 전용으로 표시된 섹션은 클래식 화면과 채팅만 변경하며 NextGen에는 적용되지 않습니다. NextGen에는 설정에 별도의 화면 옵션이 있습니다.';

  @override
  String get attachment_preview_too_large =>
      '여기에서 미리보기에는 파일이 너무 큽니다. 저장 또는 공유를 누르면 휴대폰에 다운로드됩니다(최대 1GB).';

  @override
  String get attachment_over_phone_limit =>
      '이 파일은 1GB를 초과하여 다운로드할 수 없습니다. 대시보드를 열어 다운로드하세요.';

  @override
  String attachment_downloading_percent(int percent) {
    return '다운로드 중… $percent%';
  }

  @override
  String attachment_downloading_mb(int megabytes) {
    return '다운로드 중… ${megabytes}MB';
  }

  @override
  String ng_attachment_too_large_for_gateway(String name) {
    return '$name 파일은 이 게이트웨이의 최대 용량인 12MB를 초과합니다. Hermes를 업데이트하면 최대 100MB의 파일을 전송할 수 있습니다.';
  }

  @override
  String ng_couldn_t_upload(String name) {
    return '$name 파일을 업로드할 수 없습니다.';
  }

  @override
  String ng_uploading_percent(int percent) {
    return '업로드 중… $percent%';
  }

  @override
  String get ng_show_tasks => '작업 표시';

  @override
  String get ng_hide_tasks => '작업 숨기기';

  @override
  String get ng_goal => '목표';

  @override
  String get ng_loop => '반복';

  @override
  String get ng_heartbeat => '하트비트';

  @override
  String get ng_goal_working => '진행 중';

  @override
  String get ng_goal_waiting => '대기 중';

  @override
  String get ng_goal_blocked => '차단됨';

  @override
  String get ng_goal_done => '완료';

  @override
  String ng_goal_turns_of(int used, int max) {
    return '$used/$max턴';
  }

  @override
  String ng_goal_turn(int used) {
    return '$used번째 턴';
  }

  @override
  String get ng_loop_held => '목표 진행 중 보류';

  @override
  String get ng_loop_finished => '완료됨';

  @override
  String get ng_loop_running => '실행 중';

  @override
  String ng_loop_runs_of(int fired, int times) {
    return '$fired/$times회 실행';
  }

  @override
  String ng_loop_runs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count회 실행',
      one: '1회 실행',
    );
    return '$_temp0';
  }

  @override
  String ng_loop_next(String time) {
    return '다음 $time';
  }

  @override
  String get ng_loop_due_now => '지금 실행 예정';

  @override
  String ng_every_seconds(int seconds) {
    return '$seconds초마다';
  }

  @override
  String ng_every_minutes(int minutes) {
    return '$minutes분마다';
  }

  @override
  String ng_every_hours(int hours) {
    return '$hours시간마다';
  }

  @override
  String ng_every_hours_minutes(int hours, int minutes) {
    return '$hours시간 $minutes분마다';
  }

  @override
  String ng_heartbeat_fired(int count) {
    return '$count회 실행됨';
  }

  @override
  String ng_heartbeat_last_fired(String time) {
    return '마지막 실행 시각: $time';
  }

  @override
  String ng_wait_until(String time) {
    return '$time까지 대기 중';
  }

  @override
  String get ng_wait_resume => '재개 대기 중';

  @override
  String get ng_wait_other_chat => '다른 채팅 대기 중';

  @override
  String ng_wait_process(String pid) {
    return '프로세스 $pid 대기 중';
  }

  @override
  String get ng_control_open => '목표 및 자동화 열기';

  @override
  String get ng_control_title => '목표 및 자동화';

  @override
  String get ng_control_subtitle => '이 채팅이 이루려는 목표와 자동으로 실행되는 작업입니다.';

  @override
  String get ng_contract_outcome => '결과';

  @override
  String get ng_contract_verification => '검증';

  @override
  String get ng_contract_constraints => '제약 조건';

  @override
  String get ng_contract_boundaries => '경계';

  @override
  String get ng_contract_stop_when => '중단 조건';

  @override
  String get ng_subgoals => '하위 목표';

  @override
  String get ng_subgoal_add_placeholder => '하위 목표 추가';

  @override
  String get ng_add => '추가';

  @override
  String get ng_subgoal_remove => '하위 목표 삭제';

  @override
  String get ng_goal_checks => '검증 항목';

  @override
  String get ng_gate_not_run => '아직 실행되지 않음';

  @override
  String ng_gate_attempts(int attempts, int tries) {
    return '$attempts/$tries회 시도';
  }

  @override
  String ng_gate_exit(int code) {
    return '종료 코드 $code';
  }

  @override
  String get ng_resume_now => '지금 재개';

  @override
  String get ng_goal_clear => '목표 지우기';

  @override
  String get ng_goal_clear_title => '이 목표를 지울까요?';

  @override
  String get ng_goal_clear_message =>
      '에이전트가 이 목표를 향한 작업을 중단합니다. 하위 목표와 검증 항목도 함께 삭제됩니다.';

  @override
  String get ng_subgoal_remove_title => '이 하위 목표를 삭제할까요?';

  @override
  String ng_subgoal_remove_message(String text) {
    return '\"$text\" 항목이 목표에서 삭제됩니다.';
  }

  @override
  String get ng_subgoals_clear_title => '하위 목표를 모두 지울까요?';

  @override
  String get ng_subgoals_clear_message => '목표 제목은 유지되고 하위 목표만 모두 삭제됩니다.';

  @override
  String get ng_clear_all => '모두 지우기';

  @override
  String get ng_clear => '지우기';

  @override
  String get ng_dismiss => '닫기';

  @override
  String get ng_loop_stop_title => '이 반복을 중지할까요?';

  @override
  String get ng_heartbeat_clear_title => '이 하트비트를 지울까요?';

  @override
  String get ng_wont_fire_again => '다시 실행되지 않습니다.';

  @override
  String get ng_loop_self_paced => '자율 실행';

  @override
  String ng_loop_until(String condition) {
    return '종료 조건: $condition';
  }

  @override
  String get ng_loop_waits_for_goal => '목표 진행 중에는 대기합니다.';

  @override
  String get ng_loop_awaiting_reply => '에이전트의 답변을 기다리는 중입니다.';

  @override
  String ng_loop_stopped_reason(String reason) {
    return '중지됨: $reason';
  }

  @override
  String get ng_hide_subagents => '하위 에이전트 숨기기';

  @override
  String get ng_show_subagents => '하위 에이전트 표시';

  @override
  String get ng_subagent => '하위 에이전트';

  @override
  String get ng_subagent_queued => '대기 중';

  @override
  String get ng_subagent_starting => '시작 중…';

  @override
  String get ng_subagent_running => '실행 중';

  @override
  String get ng_subagent_done => '완료';

  @override
  String get ng_subagent_failed => '실패';

  @override
  String get ng_subagent_stopped => '중지됨';

  @override
  String get ng_subagent_stop => '하위 에이전트 중지';

  @override
  String ng_subagent_tools(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '도구 $count개',
      one: '도구 1개',
    );
    return '$_temp0';
  }

  @override
  String get ng_mark_as_read => '읽음으로 표시';

  @override
  String get ng_mark_as_unread => '읽지 않음으로 표시';

  @override
  String ng_chats_unread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '채팅, 읽지 않은 대화 $count개',
      one: '채팅, 읽지 않은 대화 1개',
    );
    return '$_temp0';
  }

  @override
  String get ng_unread_finished => '완료됨, 읽지 않은 답변';

  @override
  String get ng_unread_updates => '실행 중, 읽지 않은 업데이트';

  @override
  String get ng_notifications => '알림';

  @override
  String get ng_notifications_hint => 'Ares가 백그라운드에 있을 때 응답과 요청을 알려줍니다';

  @override
  String get ng_notify_replies => '응답';

  @override
  String get ng_notify_replies_hint => '열려 있는 채팅에서 응답이 완료되거나 실패하면 알립니다';

  @override
  String get ng_notify_requests => '승인 및 질문';

  @override
  String get ng_notify_requests_hint =>
      '에이전트가 사용자의 응답을 기다리면 한 번 허용 또는 거부할 수 있도록 알립니다';

  @override
  String get ng_keep_running => '응답이 진행되는 동안 연결 유지';

  @override
  String get ng_keep_running_hint =>
      '응답이 완료될 때까지 백그라운드에서 연결을 유지하며 조용한 알림을 표시합니다';

  @override
  String get ng_battery_settings => '배터리 최적화';

  @override
  String get ng_battery_settings_hint =>
      '알림을 제때 받을 수 있도록 Ares가 백그라운드에서 실행되게 합니다';

  @override
  String get ng_send_test_notification => '테스트 알림 보내기';

  @override
  String get ng_test_notification_title => 'Ares 알림이 작동합니다';

  @override
  String get ng_test_notification_body => '응답과 요청이 이런 방식으로 표시됩니다.';

  @override
  String get ng_test_notification_sent => '테스트 알림을 보냈습니다';

  @override
  String get ng_notifications_blocked => '알림이 차단되어 있습니다. Android 설정에서 허용하세요.';

  @override
  String get ng_notifications_off_hint =>
      '알림이 꺼져 있어 Ares가 백그라운드에 있을 때 알림이 표시되지 않습니다.';

  @override
  String get ng_insights_building =>
      '보고서를 생성하고 있습니다. 처음 생성할 때는 기간이 길면 최대 1분까지 걸릴 수 있습니다.';

  @override
  String get ng_insights_timed_out =>
      '게이트웨이에서 보고서를 생성하는 데 시간이 너무 오래 걸렸습니다. 다시 시도하거나 더 짧은 기간을 선택하세요.';

  @override
  String get ng_dock_goal_active => '목표 진행 중';

  @override
  String get ng_dock_goal_paused => '목표 일시 중지';

  @override
  String get ng_dock_goal_waiting => '목표 대기 중';

  @override
  String get ng_dock_goal_blocked => '목표 차단됨';

  @override
  String get ng_dock_goal_done => '목표 완료';

  @override
  String ng_dock_turn_of(int used, int max) {
    return '턴 $used/$max';
  }

  @override
  String ng_dock_turn(int used) {
    return '턴 $used';
  }

  @override
  String ng_dock_subagents(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '하위 에이전트 $count개',
      one: '하위 에이전트 1개',
    );
    return '$_temp0';
  }

  @override
  String ng_dock_subagents_done(int count) {
    return '$count개 완료';
  }

  @override
  String ng_dock_tasks(int done, int total) {
    return '작업 $done/$total';
  }

  @override
  String ng_dock_previous_tasks(int done, int total) {
    return '이전 작업 $done/$total';
  }

  @override
  String get ng_dock_manage => '관리';

  @override
  String get ng_recent_notifications => '최근 알림';

  @override
  String get ng_recent_notifications_hint =>
      'Ares가 게시하려 한 내용과 Android에 표시되었는지 여부';

  @override
  String get ng_recent_notifications_empty =>
      '아직 없습니다. 답변, 질문 또는 실패로 알림이 발생하면 시도가 여기에 표시됩니다.';

  @override
  String get ng_notify_permission_granted => '권한 허용됨';

  @override
  String get ng_notify_permission_denied => '권한 거부됨';

  @override
  String get ng_notify_master_on => '알림 켜짐';

  @override
  String get ng_notify_master_off => '알림 꺼짐';

  @override
  String get ng_models_default => '기본 모델';

  @override
  String get ng_models_change => '변경';

  @override
  String get ng_models_custom_endpoint => '사용자 지정 엔드포인트를 사용합니다. 게이트웨이에서 변경하세요.';

  @override
  String get ng_models_context_window => '컨텍스트 창';

  @override
  String ng_models_token_count(String count) {
    return '$count 토큰';
  }

  @override
  String ng_models_context_override(String count) {
    return '게이트웨이에서 설정되었습니다. 자동 감지: $count 토큰.';
  }

  @override
  String get ng_models_max_output => '최대 출력';

  @override
  String get ng_models_input_price => '입력 요금';

  @override
  String get ng_models_output_price => '출력 요금';

  @override
  String get ng_models_cache_price => '캐시된 입력 요금';

  @override
  String ng_models_per_million(String price) {
    return '100만 토큰당 $price';
  }

  @override
  String ng_models_price_pair(String input, String output) {
    return '100만 토큰당 입력 $input · 출력 $output';
  }

  @override
  String get ng_models_free => '무료';

  @override
  String get ng_models_vision => '이미지 인식';

  @override
  String get ng_models_reasoning => '추론';

  @override
  String get ng_models_fast => '빠른 모드';

  @override
  String get ng_models_in_use => '사용 중';

  @override
  String ng_models_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '모델 $count개',
    );
    return '$_temp0';
  }

  @override
  String get ng_models_rate_limited => '사용량 제한됨';

  @override
  String get ng_models_plan_locked => '현재 요금제에서 사용 불가';

  @override
  String get ng_models_unsaved => '저장되지 않은 변경 사항';

  @override
  String get ng_models_discard => '되돌리기';

  @override
  String get ng_models_aux_hint => '보조 작업은 별도로 모델을 지정하지 않으면 기본 모델을 사용합니다.';

  @override
  String get ng_models_uses_default => '기본 모델 사용';

  @override
  String get ng_models_thinking_level => '사고 수준';

  @override
  String get ng_models_providers => '제공자';

  @override
  String get ng_models_saved => '저장했어요';

  @override
  String get ng_aux_vision => '비전';

  @override
  String get ng_aux_vision_hint => '이미지와 스크린샷을 읽습니다';

  @override
  String get ng_aux_compression => '압축';

  @override
  String get ng_aux_compression_hint => '긴 채팅을 컨텍스트 창에 맞게 줄입니다';

  @override
  String get ng_aux_approval => '승인';

  @override
  String get ng_aux_approval_hint => '명령을 묻지 않고 실행해도 안전한지 판단합니다';

  @override
  String get ng_aux_mcp => 'MCP';

  @override
  String get ng_aux_mcp_hint => '사용할 MCP 도구를 선택합니다';

  @override
  String get ng_aux_title_generation => '채팅 제목';

  @override
  String get ng_aux_title_generation_hint => '새 채팅의 이름을 정합니다';

  @override
  String get ng_aux_review => '검토';

  @override
  String get ng_aux_review_hint => '/review 실행 시 작업을 검토합니다';

  @override
  String get ng_aux_voice_chat => '음성 채팅';

  @override
  String get ng_aux_voice_chat_hint => '음성 모드에서 응답합니다';

  @override
  String get ng_aux_triage_specifier => '분류';

  @override
  String get ng_aux_triage_specifier_hint => '한 줄짜리 칸반 카드를 명세로 확장합니다';

  @override
  String get ng_aux_kanban_decomposer => '칸반 분해';

  @override
  String get ng_aux_kanban_decomposer_hint => '칸반 카드를 더 작은 작업으로 나눕니다';

  @override
  String get ng_aux_profile_describer => '프로필 설명';

  @override
  String get ng_aux_profile_describer_hint => '각 프로필의 짧은 설명을 작성합니다';

  @override
  String get ng_aux_curator => '큐레이터';

  @override
  String get ng_aux_curator_hint => '스킬 사용 현황을 검토합니다';

  @override
  String get appearance_save_failed => '이 변경 사항을 저장할 수 없습니다.';

  @override
  String get appearance_keep_which_theme => '어떤 테마를 유지할까요?';

  @override
  String get appearance_tour_back => '뒤로';

  @override
  String get appearance_tour_finish => '완료';

  @override
  String get appearance_tour_next => '다음';

  @override
  String get appearance_tour_close => '둘러보기 닫기';

  @override
  String get appearance_dismiss_tip => '팁 닫기';

  @override
  String get appearance_search_settings => '설정 검색';

  @override
  String get appearance_search_show => '표시';

  @override
  String get appearance_no_matching_setting => '일치하는 설정이 없습니다.';

  @override
  String get appearance_replay_tour => '둘러보기 다시 시작';

  @override
  String get appearance_show_tips_again => '팁 다시 표시';

  @override
  String get appearance_window_translucency_unavailable =>
      '이 호스트에서는 창 반투명 효과를 사용할 수 없습니다. Linux에서는 지원하지 않으며, Apple 및 Windows 러너는 불투명한 Flutter 뷰를 그립니다.';

  @override
  String get appearance_imported_themes => '가져온 테마';

  @override
  String get appearance_import_theme_file => '테마 파일 가져오기';

  @override
  String get appearance_remove_theme => '테마 제거';

  @override
  String get appearance_chat_font => '채팅 글꼴';

  @override
  String get appearance_terminal_font => '터미널 글꼴';

  @override
  String get appearance_font_platform => '플랫폼';

  @override
  String get appearance_automatic => '자동';

  @override
  String get appearance_force_left_to_right => '왼쪽에서 오른쪽으로 고정';

  @override
  String get appearance_force_right_to_left => '오른쪽에서 왼쪽으로 고정';

  @override
  String get appearance_user_bubble_opacity => '사용자 말풍선 불투명도';

  @override
  String get appearance_inline_embeds => '인라인 임베드';

  @override
  String get appearance_inline_embeds_hint =>
      '풍부한 미리보기는 외부 사이트(YouTube, X 등)에서 불러옵니다. ‘묻기’는 하나씩 허용할 때까지 자리표시자를 보여 주고, ‘항상’은 자동으로 불러오며, ‘끄기’는 일반 링크로 둡니다.';

  @override
  String get appearance_embeds_ask => '묻기';

  @override
  String get appearance_embeds_always => '항상';

  @override
  String get appearance_embeds_off => '끄기';

  @override
  String appearance_embeds_reset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '허용된 서비스 $count개 초기화',
      one: '허용된 서비스 1개 초기화',
    );
    return '$_temp0';
  }

  @override
  String get appearance_embed_load => '불러오기';

  @override
  String appearance_embed_always_allow(String service) {
    return '$service 항상 허용';
  }

  @override
  String get appearance_embed_loading => '미리보기 불러오는 중…';

  @override
  String appearance_embed_image_failed(String host) {
    return '$host에서 이미지를 불러오지 못했습니다. 탭하여 여세요.';
  }

  @override
  String get appearance_embed_preview_unavailable => '미리보기를 사용할 수 없음';

  @override
  String get appearance_emoji_reactions => '이모지 반응';

  @override
  String get appearance_celebration_hearts => '축하 하트';

  @override
  String get appearance_celebration_hearts_hint =>
      '자리를 비운 동안 응답이 도착하면 하트 애니메이션이 재생됩니다.';

  @override
  String get appearance_pop_out_companion => '친구를 별도 창으로 열기';

  @override
  String get appearance_mosskip => 'Mosskip';

  @override
  String get appearance_emberbun => 'Emberbun';

  @override
  String get appearance_tideling => 'Tideling';

  @override
  String get appearance_my_hatchling => '내 아기 펫';

  @override
  String get appearance_at_rest => '쉬는 중';

  @override
  String get appearance_working => '작업 중';

  @override
  String get appearance_thinking => '생각 중';

  @override
  String get appearance_waiting_for_you => '기다리고 있어요';

  @override
  String get appearance_reply_ready => '응답 준비 완료';

  @override
  String get appearance_turn_failed => '턴 실패';

  @override
  String get appearance_small => '작게';

  @override
  String get appearance_medium => '중간';

  @override
  String get appearance_large => '크게';

  @override
  String get appearance_hello => '안녕하세요!';

  @override
  String get appearance_unread_reply => '읽지 않은 응답';

  @override
  String get appearance_compose => '작성';

  @override
  String get appearance_say_hello => '인사하기';

  @override
  String get appearance_pet_image_failed =>
      '해당 이미지를 열 수 없습니다. 더 작은 PNG 또는 JPEG를 선택하세요.';

  @override
  String get appearance_pet_companion => '펫 친구';

  @override
  String get appearance_pet_companion_hint => '채팅하는 동안 친구를 표시합니다.';

  @override
  String get appearance_adopt_a_companion => '친구 입양하기';

  @override
  String get appearance_roam_when_idle => '대기 중 돌아다니기';

  @override
  String get appearance_pet_size => '펫 크기';

  @override
  String get appearance_hatch_from_a_local_picture => '기기의 사진에서 부화시키기';

  @override
  String get appearance_pet_image_limits =>
      'PNG 또는 JPEG를 선택하세요(최대 4 MiB, 한 변 4096 px, 8 MP). 먼저 미리 보세요. 부화시키면 24 × 24픽셀 초상화 한 장을 저장하고 이전 아기 펫을 대체합니다.';

  @override
  String get appearance_choose_picture => '사진 선택';

  @override
  String get appearance_hatchling_preview => '아기 펫 미리보기';

  @override
  String get appearance_hatch_and_adopt => '부화시켜 입양하기';

  @override
  String get appearance_discard_draft => '초안 폐기';

  @override
  String get appearance_forget_saved_hatchling => '저장된 아기 펫 삭제';

  @override
  String get appearance_radio => '라디오';

  @override
  String appearance_radio_hint(String stations) {
    return '스트림은 $stations에서 직접 전달되며 재생을 눌러야 시작됩니다. 방송국 검색은 이 기기 안에서만 이루어집니다.';
  }

  @override
  String get appearance_radio_save_failed => '라디오 설정을 저장할 수 없습니다.';

  @override
  String get appearance_choose_a_station => '방송국 선택';

  @override
  String get appearance_pause_radio => '라디오 일시 정지';

  @override
  String get appearance_play_radio => '라디오 재생';

  @override
  String get appearance_next_station => '다음 방송국';

  @override
  String get appearance_radio_trace_semantics =>
      '스트림 활동. 오디오 레벨을 알 수 없어 이 선은 평평하게 유지됩니다.';

  @override
  String get appearance_radio_is_off => '라디오가 꺼져 있습니다';

  @override
  String get appearance_paused => '일시 정지됨';

  @override
  String get appearance_connecting => '연결 중…';

  @override
  String get appearance_live => '실시간';

  @override
  String get appearance_stream_unavailable => '스트림을 사용할 수 없습니다';

  @override
  String appearance_now_playing(String credit) {
    return '현재 재생 중: $credit';
  }

  @override
  String get appearance_audio_only_waveform_unavailable => '오디오만 제공 · 파형 사용 불가';

  @override
  String get appearance_volume => '음량';

  @override
  String get appearance_search_presets => '프리셋 검색';

  @override
  String get appearance_no_stations_found => '방송국을 찾을 수 없습니다';

  @override
  String appearance_unpin_station(String station) {
    return '방송국 고정 해제: $station';
  }

  @override
  String appearance_pin_station(String station) {
    return '방송국 고정: $station';
  }

  @override
  String get appearance_radio_picker_metadata_notice =>
      '이 선택 창이 열려 있는 동안 재생 중인 방송국에서 곡 정보를 직접 제공할 수 있습니다.';

  @override
  String get appearance_message_from_your_companion => '친구가 보내는 메시지';

  @override
  String get appearance_send_to_the_open_chat => '열려 있는 채팅으로 보내기';

  @override
  String get appearance_tour_theme_body =>
      '이 기기의 파일에서 VS Code 색 테마를 가져온 다음 유지할 변형을 선택하세요.';

  @override
  String get appearance_tour_fonts_title => '읽기용 글꼴';

  @override
  String get appearance_tour_fonts_body =>
      '채팅의 본문과 터미널의 코드는 Ares에 포함된 서로 다른 글꼴을 사용합니다.';

  @override
  String get appearance_tour_direction_title => '대화 기록 방향';

  @override
  String get appearance_tour_direction_body =>
      '자동으로 두거나 대화 기록을 왼쪽에서 오른쪽 또는 오른쪽에서 왼쪽으로 고정하세요.';

  @override
  String get appearance_tour_pet_title => '친구';

  @override
  String get appearance_tour_pet_body =>
      '친구는 입양하기 전까지 꺼져 있습니다. 별도 창으로 열면 작은 입력란이 추가됩니다.';

  @override
  String get appearance_tour_radio_body =>
      '라디오는 활성화하기 전까지 꺼져 있습니다. 재생을 눌러야 스트림이 열립니다.';

  @override
  String get appearance_tip_theme =>
      '선택을 해제할 때까지 가져온 테마가 기본 팔레트를 대체합니다. 색상만 유지됩니다.';

  @override
  String get appearance_tip_pet =>
      '친구는 이 기기에 작은 초상화 한 장을 저장합니다. 부화에 사용한 사진은 업로드하지 않습니다.';

  @override
  String get appearance_theme_import_failed =>
      '해당 테마를 가져올 수 없습니다. .vsix, .json 또는 .jsonc 파일로 저장된 VS Code 색 테마를 선택하세요.';

  @override
  String get render_widget_file_truncated =>
      '이 파일의 앞부분만 읽었으므로 위젯이 불완전할 수 있습니다.';

  @override
  String get setup_beat_title => '설정';

  @override
  String setup_beat_use_name(String name) {
    return '$name 사용';
  }

  @override
  String get setup_beat_name_hint => 'Hermes가 어떻게 불러 드릴까요?';

  @override
  String get setup_beat_on_computer =>
      '이 단계는 Hermes가 실행 중인 컴퓨터에서 진행합니다. 계속하면 그곳에 설정된 내용이 유지됩니다.';

  @override
  String get setup_beat_not_waiting => '이 설정 카드는 더 이상 응답을 기다리지 않습니다.';

  @override
  String get catalog_kind_plugin => '플러그인';

  @override
  String get catalog_kind_skill => '스킬';

  @override
  String get catalog_tier_official => '공식';

  @override
  String get catalog_tier_verified => '검증됨';

  @override
  String get catalog_tier_community => '커뮤니티';

  @override
  String get catalog_install => '설치';

  @override
  String get catalog_waiting => '선택을 기다리는 중';

  @override
  String get catalog_installed => '설치됨';

  @override
  String get catalog_installed_off => '설치됨, 켜지지 않음';

  @override
  String get catalog_skipped => '건너뜀';

  @override
  String get catalog_not_installed => '설치되지 않음';

  @override
  String catalog_target_profile(String profile) {
    return '$profile 프로필에 설치됩니다';
  }

  @override
  String catalog_source(String repo, String sha) {
    return '$repo ($sha)';
  }

  @override
  String catalog_scan(String status, String summary) {
    return '보안 검사: $status. $summary';
  }

  @override
  String catalog_requires_hermes(String range) {
    return 'Hermes $range 필요';
  }

  @override
  String catalog_skill_ready(String name) {
    return '스킬 $name을(를) 사용할 수 있습니다';
  }

  @override
  String catalog_missing_env(String names) {
    return '아직 필요: $names';
  }

  @override
  String catalog_server_error(String name, String error) {
    return '$name 연결 실패: $error';
  }

  @override
  String get catalog_send_failed => '선택이 전송되지 않았습니다. 다시 시도하세요.';

  @override
  String get attachment_video_speed => '재생 속도';

  @override
  String get catalog_installing => '설치 중…';

  @override
  String get catalog_phase_downloading => '다운로드 중…';

  @override
  String get catalog_phase_python_packages => 'Python 패키지 설치 중…';

  @override
  String get catalog_phase_loading_tools => '도구를 불러오는 중…';

  @override
  String get setup_beat_send_failed => '답변이 전송되지 않았습니다. 다시 시도하세요.';

  @override
  String catalog_tool_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '도구 $count개',
      one: '도구 1개',
    );
    return '$_temp0';
  }

  @override
  String get render_svg_not_drawn => '이 SVG는 그려지지 않았습니다.';

  @override
  String get render_notes_directive => '메모 지시문';

  @override
  String get render_maths_source => '수식 원문';

  @override
  String get render_inline_maths_source => '인라인 수식 원문';

  @override
  String get render_sequence_outline => '시퀀스 개요';

  @override
  String get render_diagram_outline => '다이어그램 개요';

  @override
  String render_revision_of(int index, int count) {
    return '리비전 $index/$count';
  }

  @override
  String get render_previous_revision => '이전 리비전';

  @override
  String get render_next_revision => '다음 리비전';

  @override
  String get render_show_rendered => '렌더링';

  @override
  String get render_show_source => '소스';

  @override
  String render_copied_file(String name) {
    return '$name을(를) 복사했습니다';
  }

  @override
  String render_copy_file(String name) {
    return '$name 복사';
  }

  @override
  String get render_artifact_too_long => '이 결과물은 너무 길어 여기서 페이지로 표시할 수 없습니다.';

  @override
  String get render_active_content_removed => '스크립트, 프레임, 외부 주소가 제거되었습니다.';

  @override
  String render_widget_file(String file) {
    return '위젯 $file';
  }

  @override
  String get render_widget_runs_as_text =>
      '이 채팅에서 텍스트로 실행됩니다. 스크립트와 외부 프레임은 제거됩니다.';

  @override
  String get render_load_widget => '위젯 불러오기';

  @override
  String get render_not_html_widget => '이 파일은 HTML 위젯이 아닙니다.';

  @override
  String get render_widget_sent => '이 채팅으로 보냈습니다';

  @override
  String get render_widget_not_sent => '이 채팅으로 보내지 않았습니다';

  @override
  String get render_widget_throttled => '잠시 후 다시 보내세요';

  @override
  String get render_widget_too_long => '이 요청은 너무 길어 보낼 수 없습니다';

  @override
  String get render_widget_no_gesture => '보내려면 위젯의 컨트롤을 탭하세요';

  @override
  String get render_widget_invalid => '이 요청을 보낼 수 없습니다';

  @override
  String get render_inspected_image => '검사한 이미지';

  @override
  String get render_contributions => '기여 항목';

  @override
  String get render_contributions_intro =>
      'Ares에 포함된 기여 항목만 답장에 내용을 추가할 수 있습니다. 채팅 텍스트로는 등록할 수 없으며, 허용은 이 연결에만 적용됩니다.';

  @override
  String render_grant_plugin(String name) {
    return '$name 허용';
  }

  @override
  String render_revoke_plugin(String name) {
    return '$name 허용 취소';
  }

  @override
  String render_plugin_slots(String directive) {
    return '::$directive 답장 카드';
  }

  @override
  String get render_plugin_notes => '메모';

  @override
  String get catalog_scan_passed => '통과';

  @override
  String get catalog_scan_warnings => '경고 발견';

  @override
  String get catalog_scan_failed => '실패';

  @override
  String get deployment_token_label => '배포 토큰(선택 사항)';

  @override
  String get deployment_token_helper =>
      'X-Hermes-Session-Token으로 전송되는 Hermes Dashboard 세션 토큰용입니다. 일반 텍스트 환경설정에 저장되지 않습니다.';

  @override
  String get deployment_token_hint => '대시보드 세션 토큰';

  @override
  String get custom_headers_label => '사용자 지정 헤더(선택 사항)';

  @override
  String get custom_headers_helper =>
      '한 줄에 하나씩, 예: X-Custom: 값. 금지된 헤더는 거부됩니다.';

  @override
  String get custom_headers_hint => '예: X-Custom-Header: 값';

  @override
  String get desktop_tray_open => 'Ares 열기';

  @override
  String get desktop_tray_new_chat => '새 채팅';

  @override
  String get desktop_tray_quick_entry => '빠른 입력…';

  @override
  String get desktop_tray_pause_notifications => '알림 일시 중지';

  @override
  String get desktop_tray_quit => 'Ares 종료';

  @override
  String get desktop_integration_title => '데스크톱 통합';

  @override
  String get desktop_tray_setting => '시스템 트레이 또는 메뉴 막대에 Ares 표시';

  @override
  String get desktop_tray_setting_help =>
      '아이콘에서 Ares 열기, 채팅 시작, 빠른 입력 열기, 알림 일시 중지 또는 종료를 할 수 있습니다.';

  @override
  String get desktop_close_to_tray_setting => '창을 닫아도 트레이에서 계속 실행';

  @override
  String get desktop_tray_unsupported =>
      '이 데스크톱에는 Ares가 사용할 수 있는 시스템 트레이가 없습니다.';

  @override
  String get quick_entry_title => '빠른 입력';

  @override
  String get quick_entry_hint => 'Ares에 보낼 프롬프트 입력…';

  @override
  String get quick_entry_submit => '입력란에 넣기';

  @override
  String get quick_entry_never_sends =>
      'Enter를 누르면 텍스트가 채팅 입력란에 들어갑니다. 보내기를 누르기 전에는 아무것도 전송되지 않습니다.';

  @override
  String get quick_entry_unavailable => '빠른 입력을 열 수 없습니다. 다시 시도하세요.';

  @override
  String get desktop_hotkey_setting => '빠른 입력 단축키';

  @override
  String desktop_hotkey_help(String shortcut) {
    return '어디서나 $shortcut을(를) 누르면 빠른 입력이 열립니다.';
  }

  @override
  String desktop_hotkey_conflict(String shortcut) {
    return '다른 앱이 이미 $shortcut을(를) 사용 중입니다. 다른 단축키를 선택하세요.';
  }

  @override
  String get desktop_hotkey_unsupported =>
      '이 데스크톱에서는 앱이 전역 단축키를 등록할 수 없습니다(예: Wayland).';

  @override
  String get desktop_hotkey_no_modifier => 'Cmd, Ctrl 또는 Alt를 포함하세요.';

  @override
  String get desktop_hotkey_super_key =>
      'Windows 키 또는 Super 키는 시스템용으로 예약되어 있습니다.';

  @override
  String get desktop_hotkey_reserved => '시스템에서 이미 이 단축키를 사용합니다.';

  @override
  String desktop_hotkey_in_app(String action) {
    return 'Ares에서 이미 $action에 이 단축키를 사용합니다.';
  }

  @override
  String get desktop_hotkey_change => '변경';

  @override
  String get desktop_hotkey_reset => '기본값 사용';

  @override
  String get capture_screen_action => '화면 캡처';

  @override
  String get capture_screen_help =>
      '스크린샷을 메시지에 초안으로 추가합니다. 보내기를 누르기 전에는 아무것도 전송되지 않습니다.';

  @override
  String get capture_screen_unavailable => '이 데스크톱에서는 화면 캡처를 사용할 수 없습니다.';

  @override
  String get capture_screen_failed => '화면을 캡처할 수 없습니다. 다시 시도하세요.';

  @override
  String get capture_permission_title => '화면 기록 허용';

  @override
  String get capture_permission_body =>
      '창을 캡처하려면 Ares에 화면 기록 권한이 필요합니다. 시스템 설정 > 개인정보 보호 및 보안 > 화면 기록에서 Ares를 켠 다음 다시 시도하세요.';

  @override
  String get capture_open_settings => '시스템 설정 열기';

  @override
  String get keep_awake_title => '컴퓨터 깨어 있게 유지';

  @override
  String get keep_awake_title_mobile => '화면 켜 두기';

  @override
  String get keep_awake_mode_off => '끔';

  @override
  String get keep_awake_mode_while_working => '작업 중';

  @override
  String get keep_awake_mode_always => '항상';

  @override
  String get keep_awake_off_help => '시스템 절전을 막지 않습니다(기본값).';

  @override
  String get keep_awake_while_working_help => '에이전트 턴이 실행 중일 때만 유휴 절전을 막습니다.';

  @override
  String get keep_awake_always_help => '이 기기에서 Ares가 열려 있는 동안 유휴 절전을 막습니다.';

  @override
  String get keep_awake_off_help_mobile => '평소처럼 화면이 꺼지도록 둡니다(기본값).';

  @override
  String get keep_awake_while_working_help_mobile =>
      '에이전트 턴이 실행 중이고 Ares가 열려 있는 동안 화면을 켜 둡니다.';

  @override
  String get keep_awake_always_help_mobile => 'Ares가 열려 있는 동안 화면을 켜 둡니다.';

  @override
  String get ng_token_gateway_has_no_sign_in =>
      '이 게이트웨이에는 로그인이 없어 배포 토큰을 확인할 수 없습니다. 호스트에서 대시보드 인증을 켜거나 Hermes를 업데이트한 뒤 다시 시도하세요.';

  @override
  String get palette_open => '앱 명령 팔레트';

  @override
  String get palette_no_matches => '일치하는 작업이 없습니다';

  @override
  String get palette_filter_hint => '입력하여 작업 필터링…';

  @override
  String get palette_keys_move => '↑↓ 이동';

  @override
  String get palette_keys_run => 'Enter 실행';

  @override
  String get palette_keys_close => 'Esc 닫기';

  @override
  String get palette_search_sessions => '세션 검색';

  @override
  String get palette_scheduled_crons => '예약됨 / Cron';

  @override
  String get palette_capabilities_skills => '기능 및 스킬';

  @override
  String get palette_insights_usage => '인사이트 및 사용량';

  @override
  String get palette_more_projects => '더 보기 및 프로젝트';

  @override
  String get deeplink_chat_not_found =>
      '목록에서 채팅을 찾을 수 없습니다. 아직 로드되지 않았을 수 있습니다.';

  @override
  String get keyboard_shortcuts_title => '키보드 단축키';

  @override
  String get shortcuts_reset_all => '모두 재설정';

  @override
  String get shortcuts_reset_to_default => '기본값으로 재설정';

  @override
  String get shortcut_action_command_palette => '명령 팔레트';

  @override
  String get shortcut_action_new_chat => '새 채팅';

  @override
  String get shortcut_action_search => '검색';

  @override
  String get shortcut_action_settings => '설정';

  @override
  String shortcut_action_go_to_tab(int number) {
    return '탭 $number(으)로 이동';
  }

  @override
  String shortcuts_conflict(String first, String second, String chord) {
    return '충돌: \"$first\"와 \"$second\"가 모두 $chord을(를) 사용합니다. 둘 중 하나를 바꿀 때까지 사용자 지정 단축키는 기본값을 유지합니다.';
  }

  @override
  String shortcuts_editor_title(String action) {
    return '단축키: $action';
  }

  @override
  String get shortcuts_editor_help => '키 조합을 누르거나 아래에서 보조 키와 키를 선택하세요:';

  @override
  String get shortcuts_editor_needs_modifier =>
      '입력란의 타이핑에 영향이 없도록 Cmd/Meta, Ctrl, Alt 중 하나 이상을 선택하세요.';

  @override
  String shortcuts_text_editing_warning(String chord) {
    return '$chord은(는) 텍스트 편집 단축키입니다(복사, 붙여넣기, 잘라내기, 실행 취소, 다시 실행, 모두 선택). 여기에 지정하면 텍스트 필드에서 사용할 수 없습니다.';
  }

  @override
  String shortcuts_text_editing_in_use(String action, String chord) {
    return '\"$action\"이(가) 텍스트 편집 단축키 $chord을(를) 사용합니다. 여기에 지정되어 있는 동안 텍스트 필드에서 사용할 수 없습니다.';
  }

  @override
  String custom_headers_problem_format(int line) {
    return '$line번째 줄: \"이름: 값\" 형식이어야 합니다';
  }

  @override
  String custom_headers_problem_missing_name(int line) {
    return '$line번째 줄: 헤더 이름이 없습니다';
  }

  @override
  String custom_headers_problem_invalid_name(int line, String name) {
    return '$line번째 줄: 잘못된 헤더 이름 \"$name\"';
  }

  @override
  String custom_headers_problem_reserved(int line, String name) {
    return '$line번째 줄: \"$name\"은(는) 예약되어 전달할 수 없습니다';
  }

  @override
  String custom_headers_problem_empty_value(int line) {
    return '$line번째 줄: 헤더 값이 비어 있습니다';
  }

  @override
  String get ng_enter_a_deployment_token => '배포 세션 토큰을 입력하세요.';

  @override
  String get ng_custom_headers => '사용자 지정 헤더';

  @override
  String get ng_custom_headers_help =>
      '이 게이트웨이의 추가 HTTP 헤더(이름: 값, 한 줄에 하나)로, REST 및 WebSocket 호출에 전송됩니다. 보안 자격 증명 저장소에 보관됩니다. 인증 헤더와 홉별 헤더는 거부됩니다.';

  @override
  String get ng_use_a_deployment_token => '배포 세션 토큰 사용';

  @override
  String get ng_sign_in_with_deployment_token => '배포 토큰으로 로그인';

  @override
  String get ng_signed_in_with_deployment_token => '배포 토큰으로 로그인했습니다.';

  @override
  String get auto_speak_replies_title => '답변을 자동으로 읽기';

  @override
  String get auto_speak_replies_subtitle =>
      '턴이 완료될 때마다 새 답변을 읽어줍니다. 기본적으로 꺼짐; 채팅 내 말하기 토글이 계속 적용됩니다.';

  @override
  String get ng_auto_read_replies_title => '답변 자동 읽기';

  @override
  String get ng_auto_read_replies_subtitle =>
      '턴이 완료될 때마다 새 답변을 읽어줍니다. 기본적으로 꺼짐.';

  @override
  String get barge_in_title => '말 끊기';

  @override
  String get barge_in_subtitle =>
      '답변을 읽는 중에 말하면 멈출 수 있습니다. 답변을 소리 내어 읽는 동안 마이크가 켜져 있습니다.';

  @override
  String get barge_in_mic_live => '마이크 켜짐: 말하면 답변 읽기가 멈춥니다';

  @override
  String get ng_barge_in_title => '말 끊기';

  @override
  String get ng_barge_in_subtitle =>
      '답변을 읽는 중에 말하면 멈출 수 있습니다. 답변을 소리 내어 읽는 동안 마이크가 켜져 있습니다.';

  @override
  String get ng_barge_in_mic_live => '마이크 켜짐: 말하면 답변 읽기가 멈춥니다';

  @override
  String get wake_word_title => '호출어';

  @override
  String get wake_word_subtitle =>
      '게이트웨이의 핸즈프리 호출어 감지입니다. 기본값은 꺼짐이며 클라이언트 캡처가 활성화된 경우에만 마이크 오디오를 전송합니다.';

  @override
  String wake_word_listening(String phrase) {
    return '호출어 \"$phrase\" 듣는 중';
  }

  @override
  String wake_word_paused(String phrase) {
    return '호출어 \"$phrase\" — 일시 중지됨';
  }

  @override
  String wake_word_off(String phrase) {
    return '호출어 \"$phrase\" — 꺼짐';
  }

  @override
  String get wake_word_arming => '호출어 준비 중…';

  @override
  String get wake_word_stop => '호출어 중지';

  @override
  String get wake_word_rearm => '다시 대기';

  @override
  String get wake_word_capture_mode => '캡처 모드';

  @override
  String get wake_word_capture_auto => '자동';

  @override
  String get wake_word_capture_client => '이 기기의 마이크';

  @override
  String get wake_word_capture_local => '게이트웨이 호스트 마이크';

  @override
  String get wake_word_capture_unavailable =>
      '이 게이트웨이에서는 앱이 캡처 모드를 변경할 수 없습니다. 게이트웨이 호스트의 Hermes 설정에서 wake_word.capture를 지정하세요.';

  @override
  String get wake_word_input_device => '입력 마이크';

  @override
  String get wake_word_default_device => '시스템 기본값';

  @override
  String get ng_wake_word_title => '호출어';

  @override
  String get ng_wake_word_subtitle => '게이트웨이의 핸즈프리 호출어 감지입니다. 기본값은 꺼짐입니다.';

  @override
  String get voice_engine_title => '음성 대화 엔진';

  @override
  String get voice_engine_subtitle =>
      '이 게이트웨이 프로필에서 핸즈프리 음성 대화를 실행할 방식을 선택하세요.';

  @override
  String get voice_engine_chained => '연결형 (음성 인식 → Hermes → 음성 합성)';

  @override
  String get voice_engine_chained_short => '연결형';

  @override
  String get voice_engine_live => 'GPT-Live (실시간 음성)';

  @override
  String get voice_engine_live_short => 'GPT-Live';

  @override
  String get voice_engine_live_needs_key =>
      'GPT-Live를 사용하려면 게이트웨이 호스트에 OpenAI API 키를 설정하세요.';

  @override
  String voice_engine_fallback_chained(String reason) {
    return 'GPT-Live를 사용할 수 없음($reason) — 연결형 음성을 사용합니다.';
  }

  @override
  String get voice_live_start => '음성 대화 시작';

  @override
  String get voice_live_stop => '음성 대화 종료';

  @override
  String get voice_live_mute => '마이크 음소거';

  @override
  String get voice_live_unmute => '마이크 음소거 해제';

  @override
  String get voice_live_interrupt => '끼어들기 또는 지금 응답';

  @override
  String get voice_live_listening => '듣는 중';

  @override
  String get voice_live_speaking => '말하는 중';

  @override
  String get voice_live_thinking => '생각하는 중';

  @override
  String get voice_live_muted => '음소거됨';

  @override
  String get voice_live_ended_connection_lost => '실시간 음성 세션의 연결이 끊어졌습니다.';

  @override
  String get voice_live_ended_closed => '서비스에서 실시간 음성 세션을 종료했습니다.';

  @override
  String wake_word_other_profile(String profile) {
    return '이 호출어는 프로필 \"$profile\"의 것입니다. 응답하려면 해당 프로필에 대한 연결을 여세요.';
  }

  @override
  String get wake_word_reason_disabled => '꺼짐 — 탭하여 켜기';

  @override
  String get wake_word_reason_surface => '다른 화면으로 제한됨(설정 wake_word.surface)';

  @override
  String get wake_word_reason_owned => '다른 화면이 호출어 수신을 맡고 있습니다';

  @override
  String wake_word_reason_owned_by(String surface) {
    return '다른 화면($surface)이 호출어 수신을 맡고 있습니다';
  }

  @override
  String get wake_word_reason_unavailable => '이 게이트웨이에서는 호출어를 사용할 수 없습니다';

  @override
  String get wake_word_reason_permission_denied => '마이크 권한이 거부되었습니다';

  @override
  String get wake_word_reason_permission_required => '마이크 권한이 필요합니다 — 탭하여 켜기';

  @override
  String get voice_live_not_enabled => '이 프로필에서 GPT-Live가 켜져 있지 않습니다.';

  @override
  String get voice_live_not_available => 'GPT-Live를 사용할 수 없습니다';

  @override
  String voice_live_start_failed(String error) {
    return 'GPT-Live를 시작할 수 없습니다: $error';
  }

  @override
  String voice_direct_stt_timeout(String seconds, String provider) {
    return '$seconds초 후 받아쓰기 시간이 초과되었습니다($provider 응답 없음)';
  }

  @override
  String voice_direct_stt_error(String provider, String status) {
    return '$provider STT 오류(HTTP $status)';
  }

  @override
  String voice_direct_tts_failed(String provider) {
    return '$provider TTS 요청 실패';
  }

  @override
  String voice_direct_tts_error(String provider, String status) {
    return '$provider TTS 오류(HTTP $status)';
  }

  @override
  String ng_wake_status_listening(String phrase) {
    return '듣는 중(\"$phrase\")';
  }

  @override
  String ng_wake_status_off(String phrase) {
    return '꺼짐(\"$phrase\")';
  }

  @override
  String ng_wire_setting_unavailable(Object setting) {
    return '$setting 변경은 공유 게이트웨이에서 아직 사용할 수 없습니다';
  }

  @override
  String ng_wire_method_unavailable(Object method) {
    return '$method 요청은 공유 게이트웨이에서 아직 사용할 수 없습니다';
  }

  @override
  String ng_wire_session_options_unsupported(Object options) {
    return '표준 게이트웨이는 다음 명시적 세션 옵션을 지원하지 않습니다: $options';
  }

  @override
  String get ng_wire_prompt_stale => '요청이 오래되었거나 사용할 수 없습니다. 다시 연결한 후 응답하세요';

  @override
  String get ng_wire_revision_unavailable =>
      '세션 리비전을 확인할 수 없습니다. 세션을 다시 연 후 메타데이터를 편집하세요';

  @override
  String get ng_wire_generation_unavailable =>
      '세션 실행 ID를 확인할 수 없습니다. 다시 연결한 후 이 명령을 사용하세요';

  @override
  String get ng_wire_message_not_saved =>
      '이 메시지는 아직 저장되지 않았습니다. 완료될 때까지 기다린 후 다시 분기하세요';

  @override
  String get ng_wire_not_available => '공유 게이트웨이에서 아직 사용할 수 없습니다';

  @override
  String get edit_turn_title => '이 프롬프트를 편집할까요?';

  @override
  String get edit_turn_body => '여기서부터 프롬프트를 다시 실행합니다. 이후 대화 차례는 보관됩니다.';

  @override
  String get edit_turn_send => '보내기';

  @override
  String get restore_turn_title => '이 체크포인트로 복원할까요?';

  @override
  String get restore_turn_body => '이 프롬프트 이후의 대화 내용을 제거하고 여기서부터 다시 실행합니다.';

  @override
  String get restore_turn_confirm => '복원 및 다시 실행';

  @override
  String get edit_turn_later_turns_body => '이후 대화 차례가 보관 처리됩니다. 계속할까요?';

  @override
  String get session_history => '세션 기록';

  @override
  String get import_claude_or_codex => 'Claude 또는 Codex 가져오기';

  @override
  String get ng_session_history => '세션 기록';

  @override
  String get ng_import_claude_or_codex => 'Claude 또는 Codex 가져오기';

  @override
  String get ng_edit_and_resend => '편집 후 다시 보내기';

  @override
  String get ng_restore_turn_confirm => '복원 및 다시 실행';

  @override
  String get rewind_target_unsaved =>
      '이 메시지는 아직 저장되지 않았습니다. 완료될 때까지 기다린 후 다시 편집하세요.';

  @override
  String get rewind_turn_busy =>
      '현재 응답이 아직 중지되지 않아 아무것도 전송되지 않았습니다. 잠시 후 다시 시도하세요.';

  @override
  String get rewind_session_changed =>
      '이 채팅은 여기에서 연 이후 변경되어 아무것도 삭제되거나 전송되지 않았습니다. 다시 연 후 다시 시도하세요.';

  @override
  String get history_lineage => '관련 채팅';

  @override
  String get history_lineage_none => '이 채팅에는 분기나 형제 브랜치가 없습니다.';

  @override
  String get history_lineage_unavailable => '이 게이트웨이에서 관련 채팅을 읽을 수 없습니다.';

  @override
  String get history_lineage_parent => '상위';

  @override
  String get history_lineage_sibling => '형제';

  @override
  String get history_lineage_fork => '분기';

  @override
  String get history_messages => '메시지';

  @override
  String get history_messages_hint => '저장된 메시지를 선택하면 그 지점에서 분기하거나 되감을 수 있습니다.';

  @override
  String get history_messages_none => '저장된 메시지가 아직 없습니다.';

  @override
  String get history_messages_unavailable =>
      '저장된 메시지를 읽을 수 없습니다. 이 채팅을 연 후 새로 고치세요.';

  @override
  String get history_role_user => '나';

  @override
  String get history_role_assistant => 'Hermes';

  @override
  String get history_branch_here => '여기서 분기';

  @override
  String get history_rewind_here => '여기까지 되감기';

  @override
  String get history_branch_title => '이 메시지에서 분기';

  @override
  String get history_branch_body =>
      '선택한 메시지까지의 기록을 담은 새 채팅을 만듭니다. 현재 채팅은 그대로 유지됩니다.';

  @override
  String get history_rewind_title => '이 메시지까지 되감기';

  @override
  String get history_rewind_body =>
      '선택한 메시지부터 이후 메시지가 이 채팅에서 삭제됩니다. 컴퓨터의 파일은 변경되지 않습니다. 파일 복원은 체크포인트에서 따로 합니다.';

  @override
  String history_branched(String id) {
    return '$id(으)로 분기됨';
  }

  @override
  String get history_open_chat => '채팅 열기';

  @override
  String get history_mutate_unsupported =>
      '분기와 되감기는 이 게이트웨이에 Hermes 0.23 이상이 필요합니다.';

  @override
  String get history_checkpoints => '체크포인트';

  @override
  String get history_checkpoints_none => '이 세션에는 파일 체크포인트가 없습니다.';

  @override
  String get history_checkpoints_unavailable => '이 게이트웨이에서는 체크포인트를 사용할 수 없습니다.';

  @override
  String get history_diff_none => '차이가 없습니다.';

  @override
  String get history_diff_loading => '변경 사항을 불러오는 중…';

  @override
  String get history_diff_failed => '변경 사항을 불러오지 못해 이 체크포인트를 아직 복원할 수 없습니다.';

  @override
  String get history_restore_checkpoint => '체크포인트 복원';

  @override
  String get history_restore_title => '이 체크포인트 복원';

  @override
  String get history_restore_body =>
      '이 체크포인트 이후 에이전트가 변경한 파일이 당시 상태로 돌아갑니다. 직접 변경한 내용은 유지됩니다. 이후 채팅 메시지도 삭제될 수 있습니다. 대화는 분기되지 않습니다.';

  @override
  String get history_restore_body_all =>
      '세션 폴더의 모든 파일이 직접 변경한 내용까지 포함해 이 체크포인트로 돌아갑니다. 이후 채팅 메시지도 삭제될 수 있습니다. 대화는 분기되지 않습니다.';

  @override
  String get history_restore_own_edits => '내가 편집한 내용도 되돌리기';

  @override
  String get history_restored => '체크포인트를 복원했습니다.';

  @override
  String history_restored_removed(int count) {
    return '체크포인트를 복원했습니다. 채팅 메시지 $count개가 삭제되었습니다.';
  }

  @override
  String get history_export => '내보내기';

  @override
  String get history_export_redact => '토큰 가리기';

  @override
  String get history_export_action => '대화 기록 내보내기';

  @override
  String get history_export_saved => '대화 기록을 저장했습니다.';

  @override
  String get history_export_unsupported =>
      '내보내기는 이 게이트웨이에 Hermes 0.23 이상이 필요합니다.';

  @override
  String get history_import_unsupported =>
      '이 게이트웨이는 Claude 및 Codex 가져오기를 지원하지 않습니다.';

  @override
  String history_import_destination(String profile) {
    return '대상 프로필: $profile.';
  }

  @override
  String history_import_reading(String host, String profile, int count) {
    return '$host에서 읽는 중 · 대상 프로필: $profile. 읽지 못한 로그: $count개.';
  }

  @override
  String get history_import_all => '전체';

  @override
  String history_import_scan_failed(String reason) {
    return '호스트 세션을 검색할 수 없습니다: $reason';
  }

  @override
  String get history_import_none =>
      '이 호스트에서 Claude Code 또는 Codex 세션을 찾지 못했습니다.';

  @override
  String get history_import_no_match => '일치하는 호스트 세션이 없습니다.';

  @override
  String history_import_preview_failed(String reason) {
    return '세션을 미리 볼 수 없습니다: $reason';
  }

  @override
  String get history_import_open => '가져온 세션 열기';

  @override
  String get history_import_action => '선택한 세션 가져오기';

  @override
  String get history_import_title => '이 세션 가져오기';

  @override
  String history_import_body(String profile) {
    return '이 Claude 또는 Codex 세션을 이 게이트웨이의 프로필 \"$profile\"(으)로 복사합니다.';
  }

  @override
  String history_import_body_existing(String profile) {
    return '이 세션은 이미 \"$profile\"(으)로 가져왔습니다. 기존 사본으로 계속합니다.';
  }

  @override
  String history_imported(String id) {
    return '$id(으)로 가져옴';
  }

  @override
  String history_imported_already(String id) {
    return '이미 $id(으)로 가져옴';
  }

  @override
  String history_import_directory(String path) {
    return '디렉터리: $path';
  }

  @override
  String history_import_preview_partial(int shown, int total) {
    return '미리보기는 $total개 중 $shown개를 표시합니다.';
  }

  @override
  String history_failed(String reason) {
    return '완료할 수 없습니다: $reason';
  }

  @override
  String get history_error_unavailable =>
      '게이트웨이가 지금 이 작업을 수행할 수 없습니다. 다시 시도하세요.';

  @override
  String get history_error_unsupported => '이 게이트웨이는 이 작업을 지원하지 않습니다.';

  @override
  String get history_error_denied => '이 게이트웨이가 요청을 거부했습니다.';

  @override
  String get history_error_changed =>
      '이 페이지가 열려 있는 동안 채팅이 변경되었습니다. 새로 고친 후 다시 시도하세요.';

  @override
  String get history_error_unbound => '이 채팅이 게이트웨이에서 열려 있지 않습니다. 연 후 다시 시도하세요.';

  @override
  String get history_error_invalid => '게이트웨이가 이 앱에서 읽을 수 없는 응답을 보냈습니다.';

  @override
  String ng_dock_kanban(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '칸반 카드 $count개',
      one: '칸반 카드 1개',
    );
    return '$_temp0';
  }

  @override
  String ng_dock_kanban_done(int count) {
    return '$count개 완료';
  }

  @override
  String get ng_show_kanban => '칸반 카드 표시';

  @override
  String get ng_hide_kanban => '칸반 카드 숨기기';

  @override
  String get ng_kanban_status_triage => '분류';

  @override
  String get ng_kanban_status_todo => '할 일';

  @override
  String get ng_kanban_status_scheduled => '예약됨';

  @override
  String get ng_kanban_status_ready => '준비됨';

  @override
  String get ng_kanban_status_running => '실행 중';

  @override
  String get ng_kanban_status_blocked => '차단됨';

  @override
  String get ng_kanban_status_review => '검토 중';

  @override
  String get ng_kanban_status_done => '완료';

  @override
  String get ng_kanban_status_archived => '보관됨';

  @override
  String ng_kanban_open_card(String title) {
    return '칸반에서 $title 열기';
  }

  @override
  String ng_kanban_show_all(int count) {
    return '$count개 모두 표시';
  }

  @override
  String ng_kanban_this_chat(int count) {
    return '이 채팅($count)';
  }

  @override
  String get ng_kanban_close => '칸반 닫기';

  @override
  String get ng_kanban_block_no_dashboard =>
      '이 연결에는 대시보드 접근 권한이 없어 카드 상태가 실시간으로 표시되지 않으며 보드를 열 수 없습니다.';

  @override
  String get ng_kanban_block_unsupported =>
      '이 게이트웨이에서 칸반이 켜져 있지 않습니다. 칸반 플러그인을 사용 설정하면 실시간 상태를 보고 보드를 열 수 있습니다.';

  @override
  String get ng_kanban_block_denied => '카드의 실시간 상태를 보고 보드를 열려면 대시보드에 로그인하세요.';

  @override
  String get ng_kanban_block_insecure =>
      '칸반에는 HTTPS 또는 로컬 연결이 필요하므로 카드 상태가 실시간으로 표시되지 않으며 보드를 열 수 없습니다.';

  @override
  String get ng_kanban_block_unreachable =>
      '이 게이트웨이의 칸반에 연결할 수 없습니다. 카드 상태가 최신이 아닐 수 있습니다.';

  @override
  String get ng_kanban_block_stale =>
      '연결이 변경되었습니다. 카드의 실시간 상태를 보려면 이 채팅을 다시 여세요.';

  @override
  String get ng_bots_tab_roster => '봇 목록';

  @override
  String get ng_bots_tab_rooms => '룸';

  @override
  String get ng_bots_tab_screen => '화면';

  @override
  String get ng_bots_tab_routines => '루틴';

  @override
  String ng_bots_rooms_load_failed(String error) {
    return '룸을 불러올 수 없습니다: $error';
  }

  @override
  String ng_bots_routines_load_failed(String error) {
    return '루틴을 불러올 수 없습니다: $error';
  }

  @override
  String ng_bots_desktop_failed(String error) {
    return 'Bot Desktop: $error';
  }

  @override
  String get ng_bots_install_not_started => '게이트웨이가 설치를 시작하지 않았습니다.';

  @override
  String ng_bots_install_failed_error(String error) {
    return '설치 실패: $error';
  }

  @override
  String get ng_bots_install_cancelled => '설치가 취소되었습니다.';

  @override
  String get ng_bots_install_no_sudo =>
      '게이트웨이 호스트에서 sudo를 사용할 수 없습니다. 위 명령을 해당 호스트에서 실행한 다음 새로 고침하세요.';

  @override
  String ng_bots_install_exit_code(String code) {
    return '설치에 실패했습니다(종료 코드 $code).';
  }

  @override
  String ng_bots_install_done(String bot) {
    return '$bot에 Bot Desktop을 설치했습니다';
  }

  @override
  String get ng_bots_start_failed => '시작 실패';

  @override
  String ng_bots_stop_title(String bot) {
    return '$bot의 Bot Desktop을 중지할까요?';
  }

  @override
  String get ng_bots_stop_human_held =>
      '누군가 이 화면을 제어하고 있습니다. 중지하면 해당 세션이 종료되고 화면에 열려 있는 모든 항목이 닫힙니다.';

  @override
  String get ng_bots_stop_body => '봇 화면에 열려 있는 모든 항목이 닫힙니다.';

  @override
  String get ng_bots_stop_refused => '중지가 거부되었습니다';

  @override
  String get ng_bots_take_over_reason => 'Ares에서 제어권 가져오기';

  @override
  String ng_bots_take_over_failed(String error) {
    return '제어권 가져오기 실패: $error';
  }

  @override
  String ng_bots_force_hand_back_title(String bot) {
    return '$bot의 화면을 봇에게 돌려줄까요?';
  }

  @override
  String get ng_bots_force_hand_back_body =>
      '사람이 이 화면을 제어하고 있습니다. 아직 사용 중이라면 제어권을 잃게 됩니다.';

  @override
  String get ng_bots_hand_back => '제어권 돌려주기';

  @override
  String get ng_bots_hand_back_failed => '제어권 반환 실패';

  @override
  String get ng_bots_adopt_title => '새 샌드박스 이미지를 적용할까요?';

  @override
  String ng_bots_adopt_body(String bot, String current, String target) {
    return '$bot의 이미지가 $current에서 $target(으)로 변경됩니다. 다음 터미널 호출 시 컨테이너가 다시 생성되며, 현재 컨테이너에만 보관된 항목은 손실됩니다.';
  }

  @override
  String get ng_bots_adopt_image => '이미지 적용';

  @override
  String get ng_bots_image_switch_failed => '이미지 전환 실패';

  @override
  String get ng_bots_keep_refused => '유지가 거부되었습니다';

  @override
  String ng_bots_chat_open_failed(String error) {
    return 'Bot Chat을 열 수 없습니다: $error';
  }

  @override
  String ng_bots_title(String connection) {
    return '봇 · $connection';
  }

  @override
  String get ng_bots_protocol_tooltip =>
      '게이트웨이가 팀원 메시징 프로토콜을 직접 주입합니다 — 추가 SOUL.md 프로토콜은 전송되지 않습니다.';

  @override
  String ng_bots_unavailable(String reason) {
    return '봇을 사용할 수 없습니다($reason)';
  }

  @override
  String get ng_bots_account_changed => '계정이 변경되었습니다. 다시 연결하거나 새로 고침하세요.';

  @override
  String get ng_bots_try_refresh =>
      '새로 고침해 보세요. 문제가 계속되면 게이트웨이가 봇을 지원하지 않을 수 있습니다.';

  @override
  String get ng_bots_search => '봇 검색';

  @override
  String get ng_bots_none_found => '봇을 찾을 수 없습니다.';

  @override
  String get ng_bots_no_model => '모델 없음';

  @override
  String ng_bots_skill_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '스킬 $count개',
      one: '스킬 $count개',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_bot_chat => 'Bot Chat';

  @override
  String ng_bots_install_id(String id, String protocol) {
    return '게이트웨이가 보고한 설치 ID: $id · bot_mode_protocol: $protocol';
  }

  @override
  String get ng_bots_protocol_note =>
      'bot_mode_protocol이 설정되면 게이트웨이가 팀원 메시징 프로토콜을 주입합니다. 핸들: default→hermes, 그 외에는 프로필 이름입니다.';

  @override
  String get ng_bots_no_rooms => '아직 룸이 없습니다. 봇 목록에서 만드세요.';

  @override
  String ng_bots_member_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '멤버 $count명',
      one: '멤버 $count명',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_room_disbanded => '해산됨';

  @override
  String get ng_bots_room_adopted => '채택됨';

  @override
  String get ng_bots_rooms_gateway => '게이트웨이 룸';

  @override
  String get ng_bots_rooms_desktop => '데스크톱 주도 룸';

  @override
  String ng_bots_rooms_gateway_body(String methods) {
    return '룸은 게이트웨이가 소유합니다. 메서드: $methods.';
  }

  @override
  String get ng_bots_rooms_no_seat =>
      '이 게이트웨이에서는 룸을 운영하지 못할 수 있습니다(상주 프로세스 필요).';

  @override
  String get ng_bots_rooms_fallback =>
      '기존 폴백: 데스크톱이 그룹 라운드를 진행합니다(여기서 새로 만들지 않음).';

  @override
  String get ng_bots_create_room => '룸 만들기';

  @override
  String get ng_bots_refresh_rooms => '룸 새로 고침';

  @override
  String get ng_bots_room_created => '룸을 만들었습니다';

  @override
  String ng_bots_room_refused(String reason) {
    return '룸 만들기가 거부되었습니다($reason)';
  }

  @override
  String ng_bots_room_failed(String error) {
    return '룸 만들기 실패: $error';
  }

  @override
  String get ng_bots_bot => '봇';

  @override
  String get ng_bots_screen_unavailable => '화면 상태를 사용할 수 없음';

  @override
  String get ng_bots_screen_unavailable_body =>
      '봇 화면을 시작하면 썸네일을 볼 수 있고, 직접 사용하려면 제어권을 가져오세요.';

  @override
  String get ng_bots_take_over_note =>
      '제어권 가져오기를 누르면 실시간 화면이 열리고 화면 제어권이 사용자에게 넘어옵니다. 실시간 화면을 닫거나, 이 페이지를 나가거나, 앱을 백그라운드로 보내면 제어권이 봇에게 돌아갑니다.';

  @override
  String get ng_bots_not_installed => '설치되지 않음';

  @override
  String get ng_bots_unsupported_host => '지원되지 않는 호스트';

  @override
  String ng_bots_pid(String pid) {
    return 'pid $pid';
  }

  @override
  String ng_bots_missing(String items) {
    return '누락: $items';
  }

  @override
  String ng_bots_blocked(String reason) {
    return '차단됨: $reason';
  }

  @override
  String get ng_bots_no_switch => '대기 중인 샌드박스 이미지 전환이 없습니다.';

  @override
  String ng_bots_switch_image(String current, String target) {
    return '이미지 전환: $current → $target';
  }

  @override
  String get ng_bots_bot_in_control => '봇이 제어 중';

  @override
  String get ng_bots_person_in_control => '사람이 제어 중';

  @override
  String get ng_bots_installing => '게이트웨이 호스트에 Bot Desktop을 설치하는 중…';

  @override
  String get ng_bots_install_unfinished => '설치가 완료되지 않았습니다';

  @override
  String get ng_bots_install => '설치';

  @override
  String get ng_bots_start => '시작';

  @override
  String get ng_bots_take_over => '제어권 가져오기';

  @override
  String get ng_bots_keep_image => '현재 이미지 유지';

  @override
  String ng_bots_missing_pieces(String items) {
    return '게이트웨이에서 누락된 구성 요소를 보고했습니다: $items';
  }

  @override
  String get ng_bots_install_missing => '누락된 구성 요소 설치';

  @override
  String get ng_bots_thumbnail_unavailable => '썸네일을 사용할 수 없음';

  @override
  String get ng_bots_thumbnail_title => '화면 썸네일(실시간)';

  @override
  String get ng_bots_thumbnail_suppressed =>
      '사람이 화면을 제어하는 동안에는 썸네일이 표시되지 않습니다.';

  @override
  String get ng_bots_thumbnail_pending => '썸네일을 아직 사용할 수 없습니다.';

  @override
  String ng_bots_routines_of(String bot) {
    return '$bot · 루틴';
  }

  @override
  String get ng_bots_add_routine => '루틴 추가';

  @override
  String get ng_bots_no_routines => '이 봇에는 루틴이 없습니다.';

  @override
  String get ng_bots_routines_note =>
      '루틴은 봇의 프로필 저장소가 소유하는 [bot:<name>] 태그가 지정된 작업입니다. 기존 위임 루틴은 로드 시 강제로 일시 중지됩니다.';

  @override
  String ng_bots_routine_last(String status) {
    return '마지막: $status';
  }

  @override
  String ng_bots_routine_next(String time) {
    return '다음: $time';
  }

  @override
  String ng_bots_routine_error(String error) {
    return '오류: $error';
  }

  @override
  String ng_bots_remove_routine_title(String routine) {
    return '루틴 $routine을(를) 삭제할까요?';
  }

  @override
  String ng_bots_remove_routine_body(String bot) {
    return '이 루틴이 $bot의 일정에서 삭제됩니다. 이 작업은 되돌릴 수 없습니다.';
  }

  @override
  String ng_bots_routine_action_failed(String action, String error) {
    return '$action 실패: $error';
  }

  @override
  String get ng_bots_not_connected => '연결되지 않았습니다.';

  @override
  String ng_bots_add_failed(String error) {
    return '추가 실패: $error';
  }

  @override
  String get ng_bots_routine_added => '루틴을 추가했습니다';

  @override
  String get ng_bots_routine_enabled => '사용 중';

  @override
  String get ng_bots_routine_paused => '일시 중지됨';

  @override
  String ng_bots_path(String path) {
    return '경로: $path';
  }

  @override
  String get ng_bots_chat_present => 'Bot Chat 있음';

  @override
  String get ng_bots_chat_missing => 'Bot Chat 없음';

  @override
  String ng_bots_last_session(String preview) {
    return '마지막 세션: $preview';
  }

  @override
  String get ng_bots_open_chat => 'Bot Chat 열기';

  @override
  String get ng_bots_desktop => 'Bot Desktop';

  @override
  String get ng_bots_room_name => '룸 이름';

  @override
  String get ng_bots_select_member => '멤버를 한 명 이상 선택하세요.';

  @override
  String get ng_bots_sudo_title => '관리자 암호';

  @override
  String ng_bots_sudo_body(String bot) {
    return '$bot에 Bot Desktop을 설치하려면 게이트웨이 호스트에서 sudo가 필요합니다. 암호는 이번 설치를 위해 해당 게이트웨이에만 전송되며 저장되지 않습니다.';
  }

  @override
  String get ng_bots_sudo_password => 'sudo 암호';

  @override
  String get ng_bots_new_routine => '새 루틴';

  @override
  String get ng_bots_routine_title => '제목';

  @override
  String get ng_bots_routine_instruction => '지시 사항';

  @override
  String get ng_bots_cron => 'cron 표현식';

  @override
  String get ng_bots_interval => '간격';

  @override
  String get ng_bots_cron_help => '0 9 * * *: 매일 09:00에 실행됩니다';

  @override
  String get ng_bots_every => '반복 주기';

  @override
  String get ng_bots_unit_minutes => '분';

  @override
  String get ng_bots_unit_hours => '시간';

  @override
  String get ng_bots_unit_days => '일';

  @override
  String get ng_bots_stop_after => '중지 전 실행 횟수';

  @override
  String get ng_bots_stop_after_help => '계속 실행하려면 비워 두세요';

  @override
  String get ng_bots_send_results => '결과 보낼 곳';

  @override
  String get ng_bots_run_history => '실행 기록만';

  @override
  String get ng_bots_continuity => '이전 실행에서 이어서 진행';

  @override
  String get ng_bots_account_changed_refresh =>
      '계정이 변경되었습니다. 계속하기 전에 새로 고침하세요.';

  @override
  String ng_bots_room_load_failed(String error) {
    return '룸을 불러올 수 없습니다: $error';
  }

  @override
  String ng_bots_send_failed(String error) {
    return '전송 실패: $error';
  }

  @override
  String ng_bots_stop_failed(String error) {
    return '중지 실패: $error';
  }

  @override
  String get ng_bots_stop_room => '룸 중지';

  @override
  String get ng_bots_send_message => '메시지 보내기';

  @override
  String get ng_bots_room_hint => '룸에 메시지 보내기(@handle로 멤버 멘션)';

  @override
  String get ng_bots_history => '기록';

  @override
  String ng_bots_revision(String revision) {
    return '리비전 $revision';
  }

  @override
  String ng_bots_last_error(String error) {
    return '마지막 오류: $error';
  }

  @override
  String get ng_bots_members => '멤버';

  @override
  String get ng_bots_room_context => '룸 컨텍스트';

  @override
  String ng_bots_purpose(String purpose) {
    return '목적: $purpose';
  }

  @override
  String ng_bots_notes(String notes) {
    return '메모: $notes';
  }

  @override
  String ng_bots_routing(String routing) {
    return '라우팅: $routing';
  }

  @override
  String ng_bots_lead(String member) {
    return '리더 $member';
  }

  @override
  String get ng_bots_viewer_you_control =>
      '이 화면을 직접 제어하고 있습니다. 제어권을 돌려줄 때까지 봇은 대기합니다.';

  @override
  String get ng_bots_viewer_handed_back => '제어권이 봇에게 돌아갔습니다.';

  @override
  String get ng_bots_viewer_background => '앱이 포그라운드를 벗어나 제어권이 봇에게 돌아갔습니다.';

  @override
  String get ng_bots_viewer_taken => '다른 사람이 이 화면의 제어권을 가져갔습니다.';

  @override
  String get ng_bots_viewer_lost => '실시간 보기 연결이 끊어져 제어권이 봇에게 돌아갔습니다.';

  @override
  String ng_bots_viewer_title(String bot) {
    return 'Bot Desktop · $bot';
  }

  @override
  String get ng_bots_viewer_type_hint => '봇 화면에 입력';

  @override
  String get ng_bots_viewer_type => '입력';

  @override
  String get ng_bots_viewer_enter => 'Enter';

  @override
  String get ng_bots_viewer_backspace => 'Backspace';

  @override
  String get ng_more_kanban => '칸반';

  @override
  String get ng_more_kanban_subtitle => '보드, 작업 종속성, 워커 할당 및 로그';

  @override
  String get ng_more_bots => '봇';

  @override
  String get ng_more_bots_subtitle => '봇 목록, 룸, 루틴 및 Bot Desktop';

  @override
  String get ng_slash_kanban => '칸반 보드 열기';

  @override
  String get ng_slash_bots => '봇 열기';

  @override
  String ng_board_card_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '카드 $count개',
      one: '카드 $count개',
    );
    return '$_temp0';
  }

  @override
  String ng_board_event_toast(String task, String event) {
    return '칸반 $task: $event';
  }

  @override
  String get ng_board_task => '작업';

  @override
  String ng_board_refused_http(String status) {
    return '작업이 거부되었습니다(HTTP $status).';
  }

  @override
  String get ng_board_err_unsupported => '이 게이트웨이에서 칸반 플러그인이 활성화되어 있지 않습니다.';

  @override
  String get ng_board_err_denied => '이 게이트웨이에서 로그인 또는 권한이 필요합니다.';

  @override
  String get ng_board_err_stale => '게이트웨이 소유자가 변경되었습니다. 계속하기 전에 새로 고침하세요.';

  @override
  String get ng_board_err_insecure => '칸반 작업 공간 작업에는 HTTPS(또는 루프백)가 필요합니다.';

  @override
  String get ng_board_err_unreachable => '이 게이트웨이의 칸반 서비스에 연결할 수 없습니다.';

  @override
  String get ng_board_err_failed => '작업에 실패했습니다. 새로 고침한 후 다시 시도하세요.';

  @override
  String ng_board_block_title(String task) {
    return '$task 차단';
  }

  @override
  String get ng_board_block_reason => '차단 사유';

  @override
  String get ng_board_block_hint => '이 카드를 막고 있는 것은 무엇인가요?';

  @override
  String ng_board_review_title(String task) {
    return '$task 검토 요청';
  }

  @override
  String get ng_board_review_summary => '검토 요약';

  @override
  String get ng_board_review_hint => '무엇을 구현하고 검증했나요?';

  @override
  String ng_board_move_title(String cards, String column) {
    return '$cards를 $column(으)로 이동할까요?';
  }

  @override
  String ng_board_move_body(String board) {
    return '$board에서 선택한 모든 카드의 열이 변경됩니다. 실행 중인 카드는 실행이 중지됩니다.';
  }

  @override
  String get ng_board_move => '이동';

  @override
  String ng_board_moved(String column) {
    return '카드를 $column(으)로 이동했습니다';
  }

  @override
  String ng_board_unassign_title(String cards) {
    return '$cards의 할당을 해제할까요?';
  }

  @override
  String ng_board_assign_title(String cards, String profile) {
    return '$cards를 @$profile에게 할당할까요?';
  }

  @override
  String get ng_board_assign_body => '실행 중인 카드는 먼저 회수되며, 해당 워커는 중지됩니다.';

  @override
  String get ng_board_unassign => '할당 해제';

  @override
  String get ng_board_assign => '할당';

  @override
  String get ng_board_unassigned_done => '선택한 카드의 할당을 해제했습니다';

  @override
  String ng_board_assigned_done(String profile) {
    return '@$profile에게 할당했습니다';
  }

  @override
  String ng_board_archive_title(String cards) {
    return '$cards를 보관할까요?';
  }

  @override
  String ng_board_archive_body(String board) {
    return '보관된 카드는 $board에서 제외됩니다. 다시 보려면 보관됨을 켜세요.';
  }

  @override
  String get ng_board_archived_done => '선택한 카드를 보관했습니다';

  @override
  String ng_board_delete_title(String cards) {
    return '$cards를 삭제할까요?';
  }

  @override
  String ng_board_delete_body(String board) {
    return '선택한 카드가 $board에서 영구적으로 삭제됩니다.';
  }

  @override
  String ng_board_deleted(String cards) {
    return '$cards를 삭제했습니다.';
  }

  @override
  String ng_board_partial_failure(String failed, String total, String reason) {
    return '$total개 중 $failed개 실패: $reason';
  }

  @override
  String get ng_board_refused => '거부됨';

  @override
  String ng_board_dispatched(
    String spawned,
    String promoted,
    String reclaimed,
  ) {
    return '디스패치 완료: $spawned개 생성, $promoted개 승격, $reclaimed개 회수.';
  }

  @override
  String ng_board_board_archived(String board) {
    return '$board 보드를 보관했습니다';
  }

  @override
  String ng_board_board_archived_to(String path) {
    return '$path에 보관했습니다';
  }

  @override
  String ng_board_exported(String board, String archive) {
    return '$board 보드를 $archive(으)로 내보냈습니다';
  }

  @override
  String ng_board_imported(String board, String warnings) {
    return '$board 보드를 가져왔습니다$warnings';
  }

  @override
  String ng_board_created(String task) {
    return '$task을(를) 만들었습니다';
  }

  @override
  String get ng_board_orchestration_saved => '칸반 오케스트레이션을 저장했습니다';

  @override
  String get ng_board_auto_describe_unavailable => '자동 설명을 사용할 수 없음';

  @override
  String ng_board_description_updated(String profile) {
    return '@$profile 설명을 업데이트했습니다';
  }

  @override
  String ng_board_title(String board) {
    return '칸반 · $board';
  }

  @override
  String ng_board_active(String count) {
    return '$count개 활성';
  }

  @override
  String get ng_board_dispatch => '준비된 작업 지금 디스패치';

  @override
  String get ng_board_orchestration => '오케스트레이션 및 워커';

  @override
  String get ng_board_new_task => '새 작업';

  @override
  String get ng_board_enable_plugin =>
      '보드 라우터를 활성화하려면 이 게이트웨이의 기능 → 플러그인에서 번들 \"kanban\" 플러그인을 사용 설정하세요.';

  @override
  String get ng_board_filter => '작업 필터…';

  @override
  String get ng_board_all_assignees => '모든 담당자';

  @override
  String get ng_board_unassigned => '미할당';

  @override
  String get ng_board_running_by_profile => '프로필별 실행 중';

  @override
  String get ng_board_select => '선택';

  @override
  String ng_board_selected_chip(String count) {
    return '선택됨($count)';
  }

  @override
  String get ng_board_locked_column => '관리되는 열 — 끌어서 놓기 비활성화됨';

  @override
  String ng_board_add_to(String column) {
    return '$column에 추가';
  }

  @override
  String ng_board_collapse(String column) {
    return '$column 접기';
  }

  @override
  String ng_board_column_empty(String column) {
    return '$column 작업 없음';
  }

  @override
  String get ng_board_drop_here => '놓기 또는 + 작업';

  @override
  String get ng_board_card_actions => '카드 작업';

  @override
  String get ng_board_open_details => '세부 정보 열기';

  @override
  String get ng_board_select_card => '카드 선택';

  @override
  String ng_board_move_to(String column) {
    return '$column(으)로 이동';
  }

  @override
  String get ng_board_parked => '보류됨';

  @override
  String ng_board_blocked_by(String count) {
    return '$count개 항목에 의해 차단됨';
  }

  @override
  String get ng_board_goal_loop => '목표 루프';

  @override
  String ng_board_selected(String count) {
    return '$count개 선택됨';
  }

  @override
  String get ng_board_move_menu => '이동…';

  @override
  String get ng_board_assign_menu => '할당…';

  @override
  String get ng_board_new_board_title => '새 칸반 보드';

  @override
  String get ng_board_slug => '슬러그(소문자, 예: release-v5)';

  @override
  String get ng_board_display_name => '표시 이름';

  @override
  String get ng_board_linked_project => '연결된 프로젝트(선택 사항)';

  @override
  String get ng_board_none => '없음';

  @override
  String get ng_board_default_workdir => '호스트의 기본 작업 디렉터리(선택 사항)';

  @override
  String get ng_board_import_title => '보드 아카이브 가져오기';

  @override
  String get ng_board_import_path => '호스트의 .tar.gz 아카이브 경로';

  @override
  String get ng_board_import => '가져오기';

  @override
  String ng_board_edit_board(String board) {
    return '$board 편집';
  }

  @override
  String get ng_board_name => '이름';

  @override
  String get ng_board_description => '설명';

  @override
  String get ng_board_workdir_clear => '기본 작업 디렉터리(비워 두면 지워짐)';

  @override
  String get ng_board_boards => '칸반 보드';

  @override
  String get ng_board_new_board => '새 보드';

  @override
  String get ng_board_search_boards => '보드 검색…';

  @override
  String get ng_board_unpin => '탭 고정 해제';

  @override
  String get ng_board_pin => '탭 고정';

  @override
  String ng_board_archive_board_title(String board) {
    return '$board 보드를 보관할까요?';
  }

  @override
  String ng_board_archive_board_body(String cards) {
    return '보드와 해당 $cards가 보드 목록에서 제외됩니다. 게이트웨이는 호스트에 아카이브를 보관합니다.';
  }

  @override
  String get ng_board_edit_metadata => '메타데이터 편집';

  @override
  String get ng_board_export => '호스트에 .tar.gz 내보내기';

  @override
  String get ng_board_move_pin_left => '고정 탭을 왼쪽으로 이동';

  @override
  String get ng_board_archive_board => '보드 보관';

  @override
  String get ng_board_new_task_title => '새 칸반 작업';

  @override
  String get ng_board_title_required => '제목 *';

  @override
  String get ng_board_spec => '사양 및 인수 기준';

  @override
  String get ng_board_estimate => '추정';

  @override
  String ng_board_estimate_draft(String complexity, String tokens) {
    return '복잡도 $complexity(~$tokens 토큰 — 토큰 추정치일 뿐이며 달러 비용 산정이 아닙니다)';
  }

  @override
  String get ng_board_estimate_unavailable => '추정을 사용할 수 없음';

  @override
  String get ng_board_initial_column => '초기 열';

  @override
  String get ng_board_worker_assignee => '담당 워커';

  @override
  String get ng_board_parked_unassigned => '보류됨(미할당)';

  @override
  String get ng_board_priority => '우선순위';

  @override
  String get ng_board_workspace => '작업 공간';

  @override
  String get ng_board_scratch => '스크래치';

  @override
  String get ng_board_worktree => 'Git 워크트리';

  @override
  String get ng_board_shared_dir => '공유 디렉터리';

  @override
  String get ng_board_workspace_path => '호스트 작업 공간 경로';

  @override
  String get ng_board_parent => '상위 종속성(선택 사항)';

  @override
  String get ng_board_skills => '고정 스킬(쉼표로 구분, 선택 사항)';

  @override
  String get ng_board_provider_override => '제공자 재정의';

  @override
  String get ng_board_model_override => '모델 재정의';

  @override
  String get ng_board_reasoning => '추론 강도';

  @override
  String get ng_board_profile_default => '프로필 기본값';

  @override
  String get ng_board_xhigh => '매우 높음';

  @override
  String get ng_board_goal_mode => '목표 루프 모드';

  @override
  String get ng_board_goal_turns => '목표 최대 턴 수(빈칸 = 기본값)';

  @override
  String get ng_board_create_task => '작업 만들기';

  @override
  String get ng_board_orchestration_title => '오케스트레이션 및 워커 프로필';

  @override
  String ng_board_orchestrator(String profile) {
    return '오케스트레이터 프로필(확인됨: $profile)';
  }

  @override
  String get ng_board_inherit_default => '활성 기본값 상속';

  @override
  String ng_board_default_assignee(String profile) {
    return '기본 담당자(확인됨: $profile)';
  }

  @override
  String get ng_board_auto_decompose => '분류 카드 자동 분해';

  @override
  String get ng_board_auto_decompose_help =>
      '분류 작업에 설정된 kanban_decomposer 모델을 사용합니다';

  @override
  String get ng_board_save_orchestration => '오케스트레이션 저장';

  @override
  String get ng_board_worker_descriptions => '워커 전문 분야 설명';

  @override
  String ng_board_worker_label(String profile, String model, String skills) {
    return '@$profile($model · $skills)';
  }

  @override
  String get ng_board_default_model => '기본 모델';

  @override
  String get ng_board_save_description => '설명 저장';

  @override
  String get ng_board_auto_describe => '스킬 및 페르소나에서 자동 설명';

  @override
  String get ng_board_manual_block => '운영자 수동 차단';

  @override
  String get ng_board_requested_review => '검토 요청됨';

  @override
  String ng_board_requeue_title(String task) {
    return '$task을(를) 다시 대기열에 넣을까요?';
  }

  @override
  String get ng_board_requeue_body => '이 카드를 실행 중인 워커가 중지되고 카드는 대기열로 돌아갑니다.';

  @override
  String get ng_board_requeue => '다시 대기열에 추가';

  @override
  String ng_board_reassign_title(String task, String profile) {
    return '$task을(를) @$profile에게 재할당할까요?';
  }

  @override
  String get ng_board_reassign_body => '이 카드는 실행 중이므로 먼저 해당 워커가 중지됩니다.';

  @override
  String get ng_board_reassign => '재할당';

  @override
  String ng_board_saved_task(String task) {
    return '작업 $task을(를) 저장했습니다';
  }

  @override
  String get ng_board_commented_requeued => '댓글을 게시하고 작업을 다시 대기열에 추가했습니다';

  @override
  String get ng_board_commented => '댓글을 게시했습니다';

  @override
  String ng_board_requeued(String task) {
    return '$task을(를) 다시 대기열에 추가했습니다';
  }

  @override
  String get ng_board_decompose_failed => '분해에 실패했습니다.';

  @override
  String ng_board_decompose_failed_reason(String reason) {
    return '분해 실패: $reason';
  }

  @override
  String ng_board_decomposed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '하위 작업 $count개로 분해했습니다',
      one: '하위 작업 $count개로 분해했습니다',
    );
    return '$_temp0';
  }

  @override
  String get ng_board_no_children => '하위 작업이 생성되지 않았습니다.';

  @override
  String ng_board_no_children_reason(String reason) {
    return '하위 작업이 생성되지 않았습니다: $reason';
  }

  @override
  String ng_board_uploaded(String file) {
    return '$file을(를) 업로드했습니다';
  }

  @override
  String ng_board_linked_parent(String task) {
    return '상위 작업 $task을(를) 연결했습니다';
  }

  @override
  String ng_board_unlinked_parent(String task) {
    return '상위 작업 $task 연결을 제거했습니다';
  }

  @override
  String get ng_board_task_load_failed => '작업을 불러올 수 없습니다';

  @override
  String get ng_board_refresh_task => '작업 새로 고침';

  @override
  String get ng_board_tab_overview => '개요';

  @override
  String get ng_board_tab_comments => '댓글 및 링크';

  @override
  String get ng_board_tab_runs => '실행 및 로그';

  @override
  String get ng_board_tab_events => '이벤트';

  @override
  String get ng_board_decompose => '분해';

  @override
  String get ng_board_attach => '파일 첨부';

  @override
  String ng_board_estimate_task(
    String complexity,
    String tokens,
    String rationale,
  ) {
    return '추정: $complexity · ~$tokens 토큰($rationale) — 달러 비용 산정이 아닙니다.';
  }

  @override
  String get ng_board_no_rationale => '근거 없음';

  @override
  String get ng_board_status => '상태';

  @override
  String get ng_board_assignee => '담당자';

  @override
  String get ng_board_title_label => '제목';

  @override
  String get ng_board_body => '본문 / 사양';

  @override
  String get ng_board_save_changes => '변경 사항 저장';

  @override
  String get ng_board_clear_model => '모델 재정의 지우기';

  @override
  String ng_board_blocked_reason(String reason) {
    return '차단 사유: $reason';
  }

  @override
  String ng_board_result(String result) {
    return '결과: $result';
  }

  @override
  String ng_board_parents(String count) {
    return '차단 원인(상위 · $count)';
  }

  @override
  String get ng_board_add_parent => '+ 상위 작업 추가';

  @override
  String ng_board_children(String count) {
    return '차단 대상(하위 · $count)';
  }

  @override
  String ng_board_attachments(String count) {
    return '첨부 파일($count)';
  }

  @override
  String get ng_board_worker => '워커';

  @override
  String ng_board_comments(String count) {
    return '댓글($count)';
  }

  @override
  String get ng_board_comment_hint => '댓글 / 워커 지침 추가';

  @override
  String get ng_board_post_comment => '댓글 게시';

  @override
  String get ng_board_comment_requeue => '댓글 달고 다시 대기열에 추가';

  @override
  String ng_board_runs(String count) {
    return '실행($count)';
  }

  @override
  String get ng_board_no_runs => '아직 기록된 워커 실행이 없습니다.';

  @override
  String ng_board_run_error(String error) {
    return '오류: $error';
  }

  @override
  String ng_board_log_tail_truncated(String bytes) {
    return '워커 로그 끝부분($bytes B, 잘림)';
  }

  @override
  String ng_board_log_tail(String bytes) {
    return '워커 로그 끝부분($bytes B)';
  }

  @override
  String get ng_board_refresh_log => '로그 새로 고침';

  @override
  String get ng_board_no_log => '워커 로그 출력이 없습니다.';

  @override
  String get ng_board_no_events => '기록된 이벤트가 없습니다.';

  @override
  String get ng_bots_room_unknown => '알 수 없음';

  @override
  String get ng_bots_room_blocked => '차단됨';

  @override
  String get ng_bots_room_working => '작업 중';

  @override
  String get ng_bots_room_running => '실행 중';

  @override
  String get ng_bots_room_idle => '대기 중';

  @override
  String ng_board_run_title(String id, String profile, String outcome) {
    return '실행 #$id · @$profile · $outcome';
  }

  @override
  String get ng_bots_new_bot => '새 봇';

  @override
  String get ng_bots_new_bot_hint =>
      '자체 메모리, 스킬, 채팅을 가진 이름 있는 팀원입니다. 다른 에이전트에게 메시지를 보낼 수 있습니다.';

  @override
  String get ng_bots_field_name => '이름';

  @override
  String get ng_bots_field_title => '제목';

  @override
  String get ng_bots_field_description => '설명';

  @override
  String get ng_bots_description_hint => '이 봇이 무엇을 도와야 하나요?';

  @override
  String get ng_bots_name_invalid =>
      '소문자, 숫자, 하이픈, 밑줄을 사용하고 문자나 숫자로 시작하세요(최대 64자).';

  @override
  String ng_bots_name_taken(String name) {
    return '“$name”이라는 에이전트가 이미 있습니다.';
  }

  @override
  String ng_bots_profile_id(String id) {
    return '프로필 ID: $id';
  }

  @override
  String get ng_bots_advanced => '고급 — 모델, 스킬, 도구 세트, SOUL.md';

  @override
  String get ng_bots_clone_from => '복제할 프로필';

  @override
  String get ng_bots_clone_main => '기본 프로필(default)';

  @override
  String get ng_bots_fresh_profile => '새 프로필(기본 제공 스킬)';

  @override
  String get ng_bots_create_empty => '비어 있는 상태로 만들기(기본 제공 스킬 건너뛰기)';

  @override
  String get ng_bots_share_keys => '키와 계정을 기본 프로필과 공유';

  @override
  String get ng_bots_provider => '공급자';

  @override
  String get ng_bots_model => '모델';

  @override
  String get ng_bots_model_pair => '공급자와 모델을 모두 입력하세요.';

  @override
  String get ng_bots_soul => 'SOUL.md(선택 — 생성된 페르소나를 대체)';

  @override
  String get ng_bots_soul_edit => 'SOUL.md';

  @override
  String get ng_bots_creating => '만드는 중…';

  @override
  String get ng_bots_create_bot => '봇 만들기';

  @override
  String ng_bots_created(String name) {
    return '봇 “$name”을(를) 만들었습니다';
  }

  @override
  String get ng_bots_look_failed => '모양이 게이트웨이에 저장되지 않았습니다. 프로필 편집에서 설정하세요.';

  @override
  String ng_bots_request_failed(String reason) {
    return '게이트웨이가 받아들이지 않았습니다($reason).';
  }

  @override
  String get ng_bots_avatar_shape => '모양';

  @override
  String ng_bots_avatar_shape_n(int n) {
    return '모양 $n';
  }

  @override
  String get ng_bots_avatar_colour => '색상';

  @override
  String ng_bots_avatar_colour_n(int n) {
    return '색상 $n';
  }

  @override
  String get ng_bots_avatar_match_name => '이름에 맞추기';

  @override
  String get ng_bots_avatar_upload => '이미지 선택…';

  @override
  String get ng_bots_avatar_remove => '이미지 제거 — 모양 사용';

  @override
  String get ng_bots_avatar_too_large => '이미지가 너무 큽니다(최대 15MB).';

  @override
  String get ng_bots_avatar_unreadable => '이미지를 읽을 수 없습니다.';

  @override
  String get ng_bots_edit_profile => '프로필 편집';

  @override
  String ng_bots_edit_description(String name, String profile) {
    return '$name($profile)의 모양과 역할.';
  }

  @override
  String ng_bots_advanced_failed(String reason) {
    return '프로필 설정을 불러오지 못했습니다($reason).';
  }

  @override
  String get ng_bots_skills => '스킬';

  @override
  String get ng_bots_toolsets => '도구 세트';

  @override
  String get ng_bots_toolsets_hint => '모두(또는 하나도) 선택하지 않으면 기본 도구 세트 동작이 유지됩니다.';

  @override
  String get ng_bots_mcp_servers => 'MCP 서버';

  @override
  String get ng_bots_saving => '저장 중…';

  @override
  String get ng_bots_confirm_changes_title => '이 변경 사항을 저장할까요?';

  @override
  String get ng_bots_change_remove_image => '봇 이미지 제거';

  @override
  String get ng_bots_change_soul => 'SOUL.md 교체';

  @override
  String ng_bots_change_turn_off(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '스킬, 도구 세트 또는 MCP 서버 $count개 끄기',
    );
    return '$_temp0';
  }

  @override
  String ng_bots_updated(String name) {
    return '$name을(를) 업데이트했습니다';
  }

  @override
  String ng_bots_sections_failed(String sections) {
    return '일부 항목이 실패했습니다: $sections';
  }

  @override
  String get ng_bots_model_confirm_title => '모델을 전환할까요?';

  @override
  String get ng_bots_model_confirm_ok => '전환';

  @override
  String get ng_bots_model_not_switched => '모델이 전환되지 않았습니다.';

  @override
  String get ng_bots_section_new => '새 섹션';

  @override
  String get ng_bots_section_new_ellipsis => '새 섹션…';

  @override
  String get ng_bots_section_name => '섹션 이름';

  @override
  String get ng_bots_section_name_hint => '예: 고객';

  @override
  String get ng_bots_section_create => '만들기';

  @override
  String get ng_bots_section_rename => '섹션 이름 바꾸기';

  @override
  String get ng_bots_section_delete => '섹션 삭제';

  @override
  String get ng_bots_section_move_up => '위로 이동';

  @override
  String get ng_bots_section_move_down => '아래로 이동';

  @override
  String get ng_bots_section_unassigned => '미지정';

  @override
  String ng_bots_section_options(String name) {
    return '$name 섹션 옵션';
  }

  @override
  String get ng_bots_section_empty => '아직 봇이 없습니다. 봇에서 섹션으로 이동을 사용하세요.';

  @override
  String get ng_bots_section_move_to => '섹션으로 이동';

  @override
  String get ng_bots_section_remove => '섹션에서 제거';

  @override
  String ng_bots_section_deleted(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '“$name” 삭제됨 — 봇 $count개를 미지정으로 이동',
      zero: '“$name” 삭제됨',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_undo => '실행 취소';

  @override
  String ng_bots_section_move_failed(String reason) {
    return '봇을 이동하지 못했습니다($reason).';
  }

  @override
  String ng_bots_bot_actions(String name) {
    return '$name 작업';
  }

  @override
  String ng_bots_section_toggle(String name) {
    return '$name 표시 또는 숨기기';
  }

  @override
  String
  get release_core_transcript_reader_this_passage_is_no_longer_in_the_loaded =>
      '이 구절은 더 이상 불러온 범위에 포함되어 있지 않습니다.';

  @override
  String get release_core_transcript_reader_loaded_prompts => '불러온 프롬프트';

  @override
  String get release_core_transcript_reader_jump_to_latest => '최신으로 이동';

  @override
  String get release_core_transcript_reader_no_prompts_loaded =>
      '불러온 프롬프트가 없습니다';

  @override
  String get release_core_transcript_reader_find_in_loaded_messages =>
      '불러온 메시지에서 찾기';

  @override
  String get release_core_transcript_reader_previous_match => '이전 일치 항목';

  @override
  String get release_core_transcript_reader_next_match => '다음 일치 항목';

  @override
  String get release_core_transcript_reader_prompt_timeline => '프롬프트 타임라인';

  @override
  String get release_core_transcript_reader_close_find => '찾기 닫기';

  @override
  String get release_core_session_organisation_organise_chats => '채팅 정리';

  @override
  String get release_core_session_organisation_show_model_and_usage =>
      '모델 및 사용량 표시';

  @override
  String
  get release_core_session_files_view_connection_changed_reopen_files_on_the_new_connection =>
      '연결이 변경되었습니다. 새 연결에서 파일을 다시 여세요.';

  @override
  String
  get release_core_session_files_view_the_connection_or_session_changed_reopen_this_pane =>
      '연결 또는 세션이 변경되었습니다. 이 패널을 다시 여세요.';

  @override
  String
  get release_core_session_files_view_no_verified_host_working_directory_for_this_session =>
      '이 세션에 대해 확인된 호스트 작업 디렉터리가 없습니다.';

  @override
  String
  get release_core_session_files_view_the_gateway_denied_this_operation =>
      '게이트웨이가 이 작업을 거부했습니다.';

  @override
  String
  get release_core_session_files_view_this_gateway_does_not_support_this_operation =>
      '이 게이트웨이는 이 작업을 지원하지 않습니다.';

  @override
  String
  get release_core_session_files_view_the_file_owner_or_working_directory_changed_reload =>
      '파일, 소유자 또는 작업 디렉터리가 변경되었습니다. 다시 불러와 검토하세요.';

  @override
  String
  get release_core_session_files_view_the_gateway_returned_an_unsafe_path_or_invalid =>
      '게이트웨이가 안전하지 않은 경로 또는 잘못된 파일 응답을 반환했습니다.';

  @override
  String
  get release_core_session_files_view_workspace_access_requires_a_secure_gateway_connection =>
      '워크스페이스에 액세스하려면 보안 게이트웨이 연결이 필요합니다.';

  @override
  String
  get release_core_session_files_view_gateway_unavailable_refresh_to_check_the_current_state =>
      '게이트웨이를 사용할 수 없습니다. 새로고침하여 현재 상태를 확인하세요.';

  @override
  String
  get release_core_session_files_view_gateway_operation_could_not_be_confirmed =>
      '게이트웨이 작업을 확인할 수 없습니다.';

  @override
  String get release_core_session_files_view_git_status_unavailable =>
      'Git 상태를 확인할 수 없습니다.';

  @override
  String
  get release_core_session_files_view_change_this_chat_s_working_directory =>
      '이 채팅의 작업 디렉터리를 변경하시겠습니까?';

  @override
  String get release_core_session_files_view_absolute_gateway_directory =>
      '게이트웨이 디렉터리의 절대 경로';

  @override
  String get release_core_session_files_view_change_directory => '디렉터리 변경';

  @override
  String get release_core_session_files_view_replace_gateway_file =>
      '게이트웨이 파일을 교체하시겠습니까?';

  @override
  String
  release_core_session_files_view_only_if_the_file_still_matches_the_version(
    String path,
  ) {
    return '$path\n\n파일이 검토한 버전과 여전히 일치할 때만 교체합니다. 호환되는 호스트는 교체 전 파일을 복구용으로 보관합니다.';
  }

  @override
  String get release_core_session_files_view_save_changes => '변경 사항 저장';

  @override
  String
  get release_core_session_files_view_saved_and_verified_on_the_gateway =>
      '게이트웨이에 저장하고 확인했습니다.';

  @override
  String
  get release_core_session_files_view_guarded_saving_is_unavailable_on_this_gateway_your =>
      '이 게이트웨이에서는 충돌 방지 저장을 사용할 수 없습니다. 초안은 여전히 여기에 있습니다.';

  @override
  String
  release_core_session_files_view_save_was_not_confirmed_your_draft_is_still(
    String reason,
  ) {
    return '$reason 저장을 확인할 수 없습니다. 초안은 여전히 여기에 있습니다.';
  }

  @override
  String get release_core_session_files_view_review_current_gateway_version =>
      '현재 게이트웨이 버전 검토';

  @override
  String get release_core_session_files_view_discard_draft_and_reload =>
      '초안 버리고 다시 불러오기';

  @override
  String get release_core_session_files_view_keep_draft_against_this_version =>
      '이 버전을 기준으로 초안 유지';

  @override
  String get release_core_session_files_view_discard_unsaved_edits =>
      '저장하지 않은 편집 내용을 버리시겠습니까?';

  @override
  String get release_core_session_files_view_keep_editing => '계속 편집';

  @override
  String get release_core_session_files_view_discard_edits => '편집 내용 버리기';

  @override
  String get release_core_session_files_view_remote_working_directory =>
      '원격 작업 디렉터리';

  @override
  String get release_core_session_files_view_change_working_directory =>
      '작업 디렉터리 변경';

  @override
  String get release_core_session_files_view_show_ignored_files => '무시된 파일 표시';

  @override
  String
  get release_core_session_files_view_gateway_does_not_report_ignored_status =>
      '게이트웨이가 무시 상태를 보고하지 않습니다.';

  @override
  String get release_core_session_files_view_no_visible_entries =>
      '표시할 항목이 없습니다';

  @override
  String get release_core_session_files_view_changed => '변경됨';

  @override
  String get release_core_session_files_view_ignored => '무시됨';

  @override
  String release_core_session_files_view_actions_for(String name) {
    return '$name 작업';
  }

  @override
  String get release_core_session_files_view_copy_relative_path => '상대 경로 복사';

  @override
  String get release_core_session_files_view_copy_gateway_path => '게이트웨이 경로 복사';

  @override
  String get release_core_session_files_view_attach_folder_reference =>
      '폴더 참조 첨부';

  @override
  String get release_core_session_files_view_attach_file_reference =>
      '파일 참조 첨부';

  @override
  String
  get release_core_session_files_view_preview_truncated_editing_disabled =>
      '미리보기가 잘려 편집할 수 없습니다.';

  @override
  String get release_core_session_files_view_select_lines => '줄 선택';

  @override
  String get release_core_session_files_view_review_gateway_version =>
      '게이트웨이 버전 검토';

  @override
  String get release_core_session_files_view_attach_selected_lines =>
      '선택한 줄 첨부';

  @override
  String get release_core_session_files_view_binary_file_no_text_preview =>
      '바이너리 파일이므로 텍스트 미리보기가 없습니다.';

  @override
  String get release_core_session_files_view_file_source => '파일 소스';

  @override
  String get release_core_session_files_view_close_session_files => '세션 파일 닫기';

  @override
  String get release_core_session_files_view_back_to_tree => '트리로 돌아가기';

  @override
  String get release_core_session_files_view_session_files => '세션 파일';

  @override
  String get release_core_session_files_view_git_review => 'Git 검토';

  @override
  String get release_core_session_files_view_refresh_tree => '트리 새로고침';

  @override
  String
  get release_core_gateway_queue_screen_this_connection_changed_reopen_its_chat =>
      '이 연결이 변경되었습니다. 해당 채팅을 다시 여세요.';

  @override
  String
  get release_core_gateway_queue_screen_disconnected_reconnect_the_chat_then_refresh =>
      '연결이 끊어졌습니다. 채팅에 다시 연결한 후 새로고침하세요.';

  @override
  String release_core_gateway_queue_screen_gateway_queue_unavailable(
    String reason,
  ) {
    return '게이트웨이 대기열을 사용할 수 없습니다: $reason.';
  }

  @override
  String release_core_gateway_queue_screen_not_confirmed_nothing_was_resent(
    String reason,
  ) {
    return '확인되지 않았습니다($reason). 아무것도 다시 보내지 않았습니다.';
  }

  @override
  String get release_core_gateway_queue_screen_gateway_confirmed_admission =>
      '게이트웨이가 접수를 확인했습니다.';

  @override
  String
  get release_core_gateway_queue_screen_edited_entry_admitted_at_the_end_of_the =>
      '편집한 항목이 대기열 끝에 접수되었습니다.';

  @override
  String get release_core_gateway_queue_screen_discard_unknown_outcome =>
      '결과를 알 수 없는 항목을 버리시겠습니까?';

  @override
  String get release_core_gateway_queue_screen_remove_this_entry =>
      '이 항목을 제거하시겠습니까?';

  @override
  String
  get release_core_gateway_queue_screen_the_lost_turn_will_not_be_retried_waiting =>
      '결과를 확인하지 못한 턴은 재시도하지 않습니다. 이제 대기 중인 턴이 실행될 수 있습니다.';

  @override
  String
  get release_core_gateway_queue_screen_if_the_gateway_has_just_started_this_entry =>
      '게이트웨이가 이 항목을 막 시작했다면 항목을 제거할 때 해당 턴이 중지될 수 있습니다.';

  @override
  String get release_core_gateway_queue_screen_keep => '유지';

  @override
  String get release_core_gateway_queue_screen_discard_and_resume => '버리고 재개';

  @override
  String get release_core_gateway_queue_screen_remove_entry => '항목 제거';

  @override
  String
  get release_core_gateway_queue_screen_lost_admission_resolved_it_was_not_resent =>
      '접수 결과가 불명확했던 항목이 해결되었습니다. 다시 보내지 않았습니다.';

  @override
  String get release_core_gateway_queue_screen_gateway_acknowledged_removal =>
      '게이트웨이가 제거 요청을 수락했습니다.';

  @override
  String get release_core_gateway_queue_screen_gateway_queue => '게이트웨이 대기열';

  @override
  String get release_core_gateway_queue_screen_refresh_queue => '대기열 새로고침';

  @override
  String get release_core_gateway_queue_screen_queue_paused_unknown_outcome =>
      '대기열 일시 중지: 결과 알 수 없음';

  @override
  String
  get release_core_gateway_queue_screen_review_the_lost_admission_before_resuming_nothing_is =>
      '재개하기 전에 접수 결과가 불명확한 항목을 검토하세요. 아무것도 다시 보내지 않습니다.';

  @override
  String get release_core_gateway_queue_screen_no_pending_admissions =>
      '접수 대기 중인 항목이 없습니다';

  @override
  String get release_core_gateway_queue_screen_discard => '버리기…';

  @override
  String
  get release_core_gateway_queue_screen_gateway_acknowledged_the_steering_request =>
      '게이트웨이가 추가 지시 요청을 수락했습니다.';

  @override
  String get release_core_gateway_queue_screen_steer_running_turn =>
      '실행 중인 턴에 추가 지시';

  @override
  String get release_core_gateway_queue_screen_remove => '제거…';

  @override
  String get release_core_gateway_queue_screen_next_prompt => '다음 프롬프트';

  @override
  String get release_core_gateway_queue_screen_edit_queued_prompt =>
      '대기 중인 프롬프트 편집';

  @override
  String get release_core_gateway_queue_screen_submit_to_gateway_queue =>
      '게이트웨이 대기열에 제출';

  @override
  String get release_core_gateway_queue_screen_save_at_queue_end => '대기열 끝에 저장';

  @override
  String get release_core_gateway_queue_screen_cancel_edit => '편집 취소';

  @override
  String get release_core_git_review_pane_the_git_operation_did_not_complete =>
      'Git 작업이 완료되지 않았습니다.';

  @override
  String get release_core_git_review_pane_close_git_review => 'Git 검토 닫기';

  @override
  String get release_core_git_review_pane_pin_lane => '레인 고정';

  @override
  String get release_core_git_review_pane_refresh_git_review => 'Git 검토 새로고침';

  @override
  String get release_core_git_review_pane_uncommitted => '커밋되지 않음';

  @override
  String get release_core_git_review_pane_last_turn => '마지막 턴';

  @override
  String
  get release_core_git_review_pane_branch_and_last_turn_views_are_read_only =>
      '브랜치 및 마지막 턴 보기는 읽기 전용입니다.';

  @override
  String get release_core_git_review_pane_mark_head_as_the_turn_baseline =>
      'HEAD를 턴 기준점으로 설정';

  @override
  String get release_core_git_review_pane_stage_all => '모두 스테이징';

  @override
  String get release_core_git_review_pane_discard_every_uncommitted_change =>
      '커밋하지 않은 변경 사항을 모두 버리시겠습니까?';

  @override
  String
  get release_core_git_review_pane_tracked_files_return_to_head_and_untracked_files =>
      '추적 중인 파일을 HEAD로 되돌리고 이 세션 디렉터리의 추적되지 않은 파일을 제거합니다.';

  @override
  String get release_core_git_review_pane_discard => '버리기';

  @override
  String get release_core_git_review_pane_discard_all => '모두 버리기';

  @override
  String get release_core_git_review_pane_unstage => '스테이징 해제';

  @override
  String get release_core_git_review_pane_stage => '스테이징';

  @override
  String get release_core_git_review_pane_discard_file => '파일 변경 사항 버리기';

  @override
  String release_core_git_review_pane_discard_2(String path) {
    return '$path의 변경 사항을 버리시겠습니까?';
  }

  @override
  String
  get release_core_git_review_pane_this_restores_the_committed_copy_or_removes_the =>
      '커밋된 사본을 복원하거나 추적되지 않은 파일을 제거합니다.';

  @override
  String get release_core_git_review_pane_commit_message => '커밋 메시지';

  @override
  String get release_core_git_review_pane_nothing_in_the_diff_to_summarise =>
      '차이 내역에 요약할 내용이 없습니다.';

  @override
  String get release_core_git_review_pane_generate_message => '메시지 생성';

  @override
  String get release_core_git_review_pane_commit => '커밋';

  @override
  String get release_core_git_review_pane_commit_and_push => '커밋 후 푸시';

  @override
  String get release_core_git_review_pane_push => '푸시';

  @override
  String get release_core_git_review_pane_create_pull_request => '풀 리퀘스트 만들기';

  @override
  String get release_core_git_review_pane_pull_request_ready => '풀 리퀘스트 준비 완료';

  @override
  String get release_core_git_review_pane_ask_hermes_to_ship => 'Hermes에 배포 요청';

  @override
  String get release_core_git_review_pane_gh_is_authenticated_on_this_gateway =>
      '이 게이트웨이에서 gh가 인증되어 있습니다.';

  @override
  String
  get release_core_git_review_pane_install_the_github_cli_gh_and_sign_in =>
      'PR을 열려면 GitHub CLI(gh)를 설치하고 로그인하세요';

  @override
  String get release_core_git_review_pane_worktrees => '워크트리';

  @override
  String get release_core_git_review_pane_main => '메인';

  @override
  String release_core_git_review_pane_follow(String branch) {
    return '$branch을(를) 따라가시겠습니까?';
  }

  @override
  String
  get release_core_git_review_pane_the_session_working_directory_becomes_this_worktree_unless =>
      '레인이 고정되어 있지 않으면 세션 작업 디렉터리가 이 워크트리로 바뀝니다.';

  @override
  String get release_core_git_review_pane_follow_2 => '따라가기';

  @override
  String release_core_git_review_pane_remove(String branch) {
    return '$branch을(를) 제거하시겠습니까?';
  }

  @override
  String get release_core_git_review_pane_the_worktree_directory_is_removed =>
      '워크트리 디렉터리가 제거됩니다.';

  @override
  String get release_core_git_review_pane_remove_2 => '제거';

  @override
  String get release_core_git_review_pane_new_worktree_name => '새 워크트리 이름';

  @override
  String get release_core_git_review_pane_new_branch => '새 브랜치';

  @override
  String get release_core_git_review_pane_base_branch => '기준 브랜치';

  @override
  String get release_core_git_review_pane_create_worktree => '워크트리 만들기';

  @override
  String get release_core_git_review_pane_existing_branch => '기존 브랜치';

  @override
  String get release_core_git_review_pane_convert_branch_to_worktree =>
      '브랜치를 워크트리로 변환';

  @override
  String get release_core_git_review_pane_switch_branch => '브랜치 전환';

  @override
  String
  get release_core_git_review_pane_this_gateway_does_not_support_that_git_operation =>
      '이 게이트웨이는 해당 Git 작업을 지원하지 않습니다.';

  @override
  String
  get release_core_git_review_pane_git_needs_the_session_directory_on_the_local =>
      'Git을 사용하려면 로컬 터미널 백엔드에 세션 디렉터리가 있어야 합니다.';

  @override
  String
  get release_core_git_review_pane_the_gateway_refused_the_git_operation =>
      '게이트웨이가 Git 작업을 거부했습니다.';

  @override
  String
  get release_core_git_review_pane_the_session_changed_refresh_and_try_again =>
      '세션이 변경되었습니다. 새로고침한 후 다시 시도하세요.';

  @override
  String
  get release_core_git_review_pane_this_review_is_no_longer_the_selected_session =>
      '이 검토는 더 이상 선택된 세션의 검토가 아닙니다.';

  @override
  String
  get release_core_git_review_pane_the_gateway_returned_an_unexpected_git_result =>
      '게이트웨이가 예상하지 못한 Git 결과를 반환했습니다.';

  @override
  String
  get release_core_git_review_pane_git_review_requires_the_gateway_transport =>
      'Git 검토에는 게이트웨이 전송 방식이 필요합니다.';

  @override
  String get release_core_client_held_queue_bar_resume => '재개';

  @override
  String get release_core_client_held_queue_bar_send_queued_prompt =>
      '대기 중인 프롬프트 보내기';

  @override
  String get release_core_client_held_queue_bar_edit_unsent_prompt =>
      '보내지 않은 프롬프트 편집';

  @override
  String get release_core_client_held_queue_bar_remove_unsent_prompt =>
      '보내지 않은 프롬프트 제거';

  @override
  String get release_core_workspace_discovery_view_repository_discovery =>
      '저장소 검색';

  @override
  String get release_core_workspace_discovery_view_refresh_results => '결과 새로고침';

  @override
  String release_core_workspace_discovery_view_hide(String path) {
    return '$path 숨기기';
  }

  @override
  String
  get release_core_workspace_discovery_view_invalid_path_or_discovery_data_use_absolute_server =>
      '경로 또는 검색 데이터가 잘못되었습니다. . 또는 .. 구성 요소가 없는 서버 절대 경로를 사용하세요.';

  @override
  String
  get release_core_workspace_discovery_view_this_gateway_does_not_support_repository_discovery =>
      '이 게이트웨이는 저장소 검색을 지원하지 않습니다.';

  @override
  String
  get release_core_workspace_discovery_view_the_gateway_denied_access_to_repository_discovery =>
      '게이트웨이가 저장소 검색에 대한 액세스를 거부했습니다.';

  @override
  String
  get release_core_workspace_discovery_view_the_connection_changed_reopen_discovery_on_the_current =>
      '연결이 변경되었습니다. 현재 게이트웨이에서 검색 화면을 다시 여세요.';

  @override
  String
  get release_core_workspace_discovery_view_the_displayed_settings_have_changed_refresh_before_trying =>
      '표시된 설정이 변경되었습니다. 다시 시도하기 전에 새로고침하세요.';

  @override
  String
  get release_core_workspace_discovery_view_could_not_load_or_verify_discovery_settings_refresh =>
      '검색 설정을 불러오거나 확인할 수 없습니다. 새로고침하여 다시 시도하세요.';

  @override
  String release_core_workspace_discovery_view_repositories_shown_of(
    int visible,
    int total,
  ) {
    return '표시된 저장소: $total개 중 $visible개';
  }

  @override
  String
  get release_core_workspace_discovery_view_the_gateway_returned_no_repositories =>
      '게이트웨이가 저장소를 반환하지 않았습니다.';

  @override
  String
  get release_core_workspace_discovery_view_no_repositories_match_your_device_filters =>
      '기기 필터와 일치하는 저장소가 없습니다.';

  @override
  String get release_core_workspace_discovery_view_gateway_scan_policy =>
      '게이트웨이 스캔 정책';

  @override
  String
  get release_core_workspace_discovery_view_this_gateway_did_not_report_a_scan_policy =>
      '이 게이트웨이가 스캔 정책을 보고하지 않았습니다.';

  @override
  String
  get release_core_workspace_discovery_view_to_scan_folders_configure_repository_scanning_in_the =>
      '폴더를 스캔하려면 게이트웨이 프로필의 Desktop 설정에서 저장소 스캔을 구성하세요.';

  @override
  String
  get release_core_workspace_discovery_view_results_can_include_cached_repositories_and_repositories_with =>
      '결과에는 캐시된 저장소와 세션이 있는 저장소가 포함될 수 있습니다. 스캔이 모든 폴더에 도달했음을 보장하지는 않습니다.';

  @override
  String get release_core_workspace_discovery_view_scan_gateway_roots =>
      '게이트웨이 루트 스캔';

  @override
  String
  get release_core_workspace_discovery_view_filter_results_on_this_device =>
      '이 기기에서 결과 필터링';

  @override
  String
  get release_core_workspace_discovery_view_only_this_discovery_list_changes_not_the_gateway =>
      '이 검색 목록만 변경되며 게이트웨이 스캔은 변경되지 않습니다.';

  @override
  String get release_core_workspace_discovery_view_include_subtrees_empty_all =>
      '포함할 하위 트리(비워 두면 모두 포함)';

  @override
  String get release_core_workspace_discovery_view_exclude_subtrees =>
      '제외할 하위 트리';

  @override
  String get release_core_workspace_discovery_view_apply_filters => '필터 적용';

  @override
  String release_core_workspace_discovery_view_hidden_repositories(int count) {
    return '숨긴 저장소($count)';
  }

  @override
  String get release_core_workspace_discovery_view_undo_hide => '숨기기 취소';

  @override
  String
  get release_core_workspace_discovery_view_one_absolute_server_path_per_line =>
      '한 줄에 서버 절대 경로 하나씩 입력';

  @override
  String get release_core_project_settings_view_project_settings => '프로젝트 설정';

  @override
  String
  get release_core_project_settings_view_the_gateway_did_not_confirm_the_selected_project =>
      '게이트웨이가 선택한 프로젝트 또는 변경 사항을 확인하지 않았습니다. 다시 시도하기 전에 설정을 검토하세요.';

  @override
  String
  get release_core_project_settings_view_could_not_verify_these_settings_use_one_absolute =>
      '이 설정을 확인할 수 없습니다. . 또는 .. 구성 요소가 없는 서버 폴더 절대 경로를 한 줄에 하나씩 입력하세요.';

  @override
  String get release_core_project_settings_view_set_active => '활성으로 설정';

  @override
  String get release_core_project_settings_view_icon => '아이콘';

  @override
  String get release_core_project_settings_view_folder => '폴더';

  @override
  String get release_core_project_settings_view_repository => '저장소';

  @override
  String get release_core_project_settings_view_rocket => '로켓';

  @override
  String get release_core_project_settings_view_star => '별';

  @override
  String get release_core_project_settings_view_book => '책';

  @override
  String get release_core_project_settings_view_terminal => '터미널';

  @override
  String get release_core_project_settings_view_colour => '색상';

  @override
  String get release_core_project_settings_view_primary_folder => '기본 폴더';

  @override
  String get release_core_project_settings_view_server_folder_paths =>
      '서버 폴더 경로';

  @override
  String
  get release_core_project_settings_view_one_absolute_path_per_line_existing_folders_are =>
      '한 줄에 절대 경로 하나씩 입력하세요. 기존 폴더는 유지됩니다.';

  @override
  String get release_core_project_settings_view_add_folders => '폴더 추가';

  @override
  String release_core_project_settings_view_choose(String label) {
    return '$label 선택';
  }

  @override
  String
  get release_core_prepared_image_recovery_wait_for_an_empty_draft_before_restoring =>
      '초안이 비워진 후 복원하세요.';

  @override
  String
  get release_core_prepared_image_recovery_no_unacknowledged_image_drafts_in_this_chat =>
      '이 채팅에는 수신이 확인되지 않은 이미지 초안이 없습니다.';

  @override
  String get release_core_prepared_image_recovery_unacknowledged_image_drafts =>
      '수신이 확인되지 않은 이미지 초안';

  @override
  String
  get release_core_prepared_image_recovery_the_gateway_may_already_have_received_these_restore =>
      '게이트웨이가 이미 수신했을 수 있습니다. 복원하여 검토하세요. 아무것도 전송되지 않습니다.';

  @override
  String get release_core_prepared_image_recovery_image_draft => '이미지 초안';

  @override
  String get release_core_prepared_image_recovery_discard_local_copy =>
      '로컬 사본 버리기';

  @override
  String
  get release_core_prepared_image_recovery_discard_this_local_image_draft =>
      '이 로컬 이미지 초안을 버리시겠습니까?';

  @override
  String
  get release_core_prepared_image_recovery_image_draft_recovery_is_unavailable =>
      '이미지 초안 복구를 사용할 수 없습니다.';

  @override
  String get release_core_prepared_image_recovery_recover_image_draft =>
      '이미지 초안 복구…';

  @override
  String get release_core_session_search_mode_menu_could_not_save_search_mode =>
      '검색 모드를 저장할 수 없습니다.';

  @override
  String get release_core_projects_pane_discover_repositories => '저장소 검색';

  @override
  String
  get release_core_projects_pane_project_created_but_the_gateway_did_not_confirm =>
      '프로젝트가 생성되었지만 게이트웨이가 프로젝트 아이디어를 확인하지 않았습니다.';

  @override
  String get release_core_projects_pane_project_idea_optional =>
      '프로젝트 아이디어(선택 사항)';

  @override
  String
  get release_core_projects_pane_saved_in_the_project_description_not_a_file =>
      '파일이 아닌 프로젝트 설명에 저장됩니다.';

  @override
  String get release_core_project_detail_screen_new_chat_in_this_lane =>
      '이 레인에서 새 채팅';

  @override
  String get release_core_project_detail_screen_review_git => 'Git 검토';

  @override
  String get release_core_more_pane_gateway_fleet => '게이트웨이 플릿';

  @override
  String
  get release_core_more_pane_connected_sessions_hermes_cloud_and_desktop_webapp =>
      '연결된 세션, Hermes Cloud 및 Desktop 웹 앱';

  @override
  String get release_core_more_pane_use_dashboard_sign_in_for_a_named_profile =>
      '이름이 지정된 프로필에는 대시보드 로그인을 사용하세요. 이 레거시 API는 어떤 프로필이 채팅 기록을 소유하는지 확인할 수 없습니다.';

  @override
  String get release_core_more_pane_capabilities => '기능';

  @override
  String
  get release_core_more_pane_install_and_govern_skills_plugins_connectors_and_tool =>
      '스킬, 플러그인, 커넥터 및 도구 백엔드 설치와 관리';

  @override
  String get release_core_more_pane_browser_vault => '브라우저 보관함';

  @override
  String
  get release_core_more_pane_site_logins_addresses_cards_and_credential_sources =>
      '사이트 로그인, 주소, 카드 및 자격 증명 소스';

  @override
  String get release_core_more_pane_agent_policy => '에이전트 정책';

  @override
  String
  get release_core_more_pane_approvals_checkpoints_browser_access_and_shared_metrics =>
      '승인, 체크포인트, 브라우저 액세스 및 공유 지표';

  @override
  String get release_core_more_pane_remote_logs_health_maintenance_and_update =>
      '원격 로그, 상태, 유지보수 및 업데이트';

  @override
  String get release_core_more_pane_schedules => '일정';

  @override
  String get release_core_more_pane_all_profiles_blueprints_catch_up_and_stop =>
      '모든 프로필, 블루프린트, 누락 실행 및 중지';

  @override
  String get release_core_more_pane_memory_graph => '메모리 그래프';

  @override
  String get release_core_more_pane_timeline_edits_and_memory_providers =>
      '타임라인, 편집 및 메모리 제공업체';

  @override
  String get release_core_more_pane_providers_and_routes => '제공업체 및 경로';

  @override
  String get release_core_more_pane_keys_endpoints_delegation_and_mixtures =>
      '키, 엔드포인트, 위임 및 모델 조합';

  @override
  String get release_core_more_pane_credits_and_plans => '크레딧 및 요금제';

  @override
  String
  get release_core_more_pane_consented_nous_billing_when_the_account_allows_it =>
      '계정이 허용하는 경우 동의에 따른 Nous 결제';

  @override
  String
  get release_core_fleet_screen_this_gateway_does_not_offer_this_service =>
      '이 게이트웨이는 이 서비스를 제공하지 않습니다.';

  @override
  String
  get release_core_fleet_screen_sign_in_or_permission_required_on_this_gateway =>
      '이 게이트웨이에서 로그인 또는 권한이 필요합니다.';

  @override
  String get release_core_fleet_screen_a_secure_gateway_address_is_required =>
      '보안 게이트웨이 주소가 필요합니다.';

  @override
  String
  get release_core_fleet_screen_the_owner_changed_refresh_before_continuing =>
      '소유자가 변경되었습니다. 계속하기 전에 새로고침하세요.';

  @override
  String
  get release_core_fleet_screen_could_not_verify_the_operation_check_the_gateway =>
      '작업을 확인할 수 없습니다. 게이트웨이를 확인하고 새로고침하세요.';

  @override
  String get release_core_fleet_screen_verified_ssh => '검증된 SSH';

  @override
  String
  get release_core_fleet_screen_confirm_a_host_key_inspect_a_remote_service =>
      '호스트 키 확인, 원격 서비스 점검 또는 셸 열기';

  @override
  String get release_core_fleet_screen_cloud_and_desktop_webapp =>
      '클라우드 및 Desktop 웹 앱';

  @override
  String get release_core_fleet_screen_register_an_existing_gateway_or_webapp =>
      '기존 게이트웨이 또는 웹 앱 등록';

  @override
  String
  get release_core_fleet_screen_sign_in_to_its_address_nothing_is_hosted =>
      '해당 주소에 로그인하세요. 이 기기에서는 아무것도 호스팅하지 않습니다.';

  @override
  String get release_core_fleet_screen_fleet_updates => '플릿 업데이트';

  @override
  String get release_core_fleet_screen_refresh_roster => '등록 목록 새로고침';

  @override
  String release_core_fleet_screen_disconnect(String gateway) {
    return '$gateway 연결 해제';
  }

  @override
  String get release_core_fleet_screen_open_this_gateway_on_launch =>
      '시작 시 이 게이트웨이 열기';

  @override
  String
  get release_core_fleet_screen_primary_for_ares_does_not_change_the_last =>
      'Ares의 기본 게이트웨이로 사용하며, 마지막으로 사용한 게이트웨이는 변경하지 않습니다.';

  @override
  String get release_core_fleet_screen_reconnect_in_fleet_on_launch =>
      '시작 시 플릿에서 다시 연결';

  @override
  String get release_core_fleet_screen_no_sessions_for_this_profile =>
      '이 프로필에 세션이 없습니다.';

  @override
  String get release_core_fleet_screen_more_sessions => '세션 더 보기';

  @override
  String get release_core_fleet_screen_this_gateway_was_disconnected =>
      '이 게이트웨이의 연결이 해제되었습니다.';

  @override
  String
  get release_core_fleet_screen_some_conversation_data_could_not_be_loaded =>
      '일부 대화 데이터를 불러올 수 없습니다.';

  @override
  String get release_core_fleet_screen_message_this_session => '이 세션에 메시지 보내기';

  @override
  String get release_core_fleet_screen_send_to_this_session => '이 세션으로 보내기';

  @override
  String get release_core_fleet_updates_screen_update_these_remote_gateways =>
      '이 원격 게이트웨이들을 업데이트하시겠습니까?';

  @override
  String
  release_core_fleet_updates_screen_this_can_restart_the_backend_and_interrupt_other(
    String gateways,
  ) {
    return '백엔드가 다시 시작되어 다른 사용자의 작업이 중단될 수 있습니다. Ares는 업데이트되지 않습니다.\n\n$gateways';
  }

  @override
  String get release_core_fleet_updates_screen_update_listed_gateways =>
      '나열된 게이트웨이 업데이트';

  @override
  String
  get release_core_fleet_updates_screen_checks_connected_gateways_cloud_is_platform_managed_entries =>
      '연결된 게이트웨이를 확인합니다. 클라우드는 플랫폼에서 관리하며, 등록 출처를 확인할 수 없는 항목은 제외됩니다.';

  @override
  String get release_core_fleet_updates_screen_check_connected_gateways =>
      '연결된 게이트웨이 확인';

  @override
  String get release_core_fleet_updates_screen_read_update_receipt =>
      '업데이트 처리 기록 읽기';

  @override
  String get release_core_fleet_updates_screen_review_eligible_updates =>
      '업데이트 가능한 항목 검토';

  @override
  String
  get release_core_fleet_webapp_screen_account_changed_reopen_this_page =>
      '계정이 변경되었습니다. 이 페이지를 다시 여세요.';

  @override
  String
  get release_core_fleet_webapp_screen_set_the_webapp_s_primary_gateway =>
      '웹 앱의 기본 게이트웨이를 설정하시겠습니까?';

  @override
  String
  release_core_fleet_webapp_screen_this_changes_the_shared_registry_not_the_last(
    String webapp,
    String gateway,
    String id,
  ) {
    return '$webapp → $gateway ($id)\n공유 레지스트리가 변경되며, 마지막으로 사용한 게이트웨이는 변경되지 않습니다.';
  }

  @override
  String get release_core_fleet_webapp_screen_set_primary => '기본으로 설정';

  @override
  String get release_core_fleet_webapp_screen_serving_profile => '서비스 중인 프로필';

  @override
  String get release_core_fleet_webapp_screen_hermes_cloud => 'Hermes Cloud';

  @override
  String get release_core_fleet_webapp_screen_discover_signed_in_agents =>
      '로그인한 에이전트 검색';

  @override
  String release_core_fleet_webapp_screen_organisation(String organisation) {
    return '조직: $organisation';
  }

  @override
  String get release_core_fleet_webapp_screen_no_agents_available =>
      '사용 가능한 에이전트가 없습니다.';

  @override
  String get release_core_fleet_webapp_screen_existing_desktop_webapp =>
      '기존 Desktop 웹 앱';

  @override
  String
  get release_core_fleet_webapp_screen_check_gateway_and_web_access_status =>
      '게이트웨이 및 웹 액세스 상태 확인';

  @override
  String
  get release_core_fleet_webapp_screen_these_settings_belong_to_the_machine_serving_this =>
      '이 설정은 이 웹 앱을 제공하는 컴퓨터의 설정입니다. 게시 및 다시 시작은 원격 작업이 아닙니다.';

  @override
  String get release_core_fleet_webapp_screen_read_webapp_gateway_registry =>
      '웹 앱 게이트웨이 레지스트리 읽기';

  @override
  String get release_core_fleet_webapp_screen_last_used => '마지막 사용';

  @override
  String get release_core_fleet_webapp_screen_primary => '기본';

  @override
  String release_core_fleet_webapp_screen_set_primary_2(String gateway) {
    return '기본으로 설정: $gateway';
  }

  @override
  String get release_core_fleet_webapp_screen_read_shared_display_preferences =>
      '공유 표시 환경설정 읽기';

  @override
  String
  get release_core_fleet_webapp_screen_chat_text_direction_on_this_webapp_and_desktop =>
      '이 웹 앱 및 Desktop의 채팅 텍스트 방향';

  @override
  String release_core_schedule_desk_screen_created_on(
    String job,
    String profile,
  ) {
    return '$profile에 $job을(를) 만들었습니다.';
  }

  @override
  String
  get release_core_schedule_desk_screen_the_list_covers_every_profile_on_this_gateway =>
      '목록에는 이 게이트웨이의 모든 프로필이 포함됩니다. 중지, 일시 중지, 누락 실행, 전달 및 블루프린트 작업은 해당 작업을 소유한 프로필로 전송됩니다.';

  @override
  String get release_core_schedule_desk_screen_a_run_is_in_progress =>
      '실행 중입니다';

  @override
  String get release_core_schedule_desk_screen_no_current_run =>
      '현재 실행 중인 항목이 없습니다';

  @override
  String release_core_schedule_desk_screen_stop_requested_for(String job) {
    return '$job의 중지를 요청했습니다.';
  }

  @override
  String release_core_schedule_desk_screen_no_run_was_in_flight_for(
    String job,
  ) {
    return '$job에 진행 중인 실행이 없었습니다.';
  }

  @override
  String get release_core_schedule_desk_screen_stop_current_run => '현재 실행 중지';

  @override
  String get release_core_schedule_desk_screen_pause_future_runs =>
      '향후 실행 일시 중지';

  @override
  String get release_core_schedule_desk_screen_resume_future_runs => '향후 실행 재개';

  @override
  String get release_core_schedule_desk_screen_catch_up_default => '누락 실행 기본값';

  @override
  String get release_core_schedule_desk_screen_run_one_missed =>
      '누락된 실행 한 번 수행';

  @override
  String get release_core_schedule_desk_screen_skip_missed => '누락된 실행 건너뛰기';

  @override
  String get release_core_schedule_desk_screen_blueprint_recipes => '블루프린트 레시피';

  @override
  String get release_core_schedule_desk_screen_profile_for_the_new_job =>
      '새 작업의 프로필';

  @override
  String release_core_schedule_desk_screen_create(String blueprint) {
    return '$blueprint 만들기';
  }

  @override
  String get release_core_schedule_desk_screen_loading_delivery_targets =>
      '전달 대상 불러오는 중';

  @override
  String release_core_schedule_desk_screen_no_home_channel(String target) {
    return '$target(홈 채널 없음)';
  }

  @override
  String release_core_memory_graph_screen_edit(String label) {
    return '$label 편집';
  }

  @override
  String get release_core_memory_graph_screen_content => '내용';

  @override
  String get release_core_memory_graph_screen_archive_skill => '스킬 보관';

  @override
  String get release_core_memory_graph_screen_delete_memory => '메모리 삭제';

  @override
  String release_core_memory_graph_screen_archive_on_it_can_be_restored_on_the(
    String label,
    String profile,
  ) {
    return '$profile의 $label을(를) 보관하시겠습니까? 호스트의 Curator로 복원할 수 있습니다.';
  }

  @override
  String release_core_memory_graph_screen_delete_from_this_removes_that_memory(
    String label,
    String profile,
  ) {
    return '$profile에서 $label을(를) 삭제하시겠습니까? 해당 메모리가 제거됩니다.';
  }

  @override
  String get release_core_memory_graph_screen_filter => '필터';

  @override
  String get release_core_memory_graph_screen_timeline => '타임라인';

  @override
  String get release_core_memory_graph_screen_play_timeline => '타임라인 재생';

  @override
  String get release_core_memory_graph_screen_layout_code => '레이아웃 코드';

  @override
  String get release_core_memory_graph_screen_external_memory_providers =>
      '외부 메모리 제공업체';

  @override
  String
  get release_core_memory_graph_screen_a_value_is_stored_leave_blank_to_keep =>
      '저장된 값이 있습니다. 유지하려면 비워 두세요.';

  @override
  String get release_core_memory_graph_screen_save_provider => '제공업체 저장';

  @override
  String release_core_workspace_profiles_screen_applies_to(String profile) {
    return '적용 대상: $profile';
  }

  @override
  String get release_core_workspace_profiles_screen_choose_another_profile =>
      '다른 프로필 선택';

  @override
  String
  get release_core_workspace_profiles_screen_could_not_verify_the_selected_profile_on_this =>
      '이 게이트웨이에서 선택한 프로필을 확인할 수 없습니다.';

  @override
  String get release_core_workspace_profiles_screen_create_profile => '프로필 만들기';

  @override
  String get release_core_workspace_profiles_screen_new_profile_id =>
      '새 프로필 ID';

  @override
  String get release_core_assets_screen_links => '링크';

  @override
  String get release_core_workspace_picker_no_matching_items =>
      '일치하는 항목이 없습니다.';

  @override
  String get release_core_workspace_picker_save_layout => '레이아웃 저장';

  @override
  String get release_core_workspace_picker_layout_name => '레이아웃 이름';

  @override
  String
  get release_core_workspace_popout_this_chat_already_has_a_pop_out_window =>
      '이 채팅에는 이미 팝아웃 창이 있습니다.';

  @override
  String
  get release_core_workspace_popout_could_not_open_this_saved_chat_check_the =>
      '이 저장된 채팅을 열 수 없습니다. 연결을 확인하고 다시 시도하세요.';

  @override
  String
  get release_core_popout_bootstrap_use_the_main_window_to_change_your_connection =>
      '연결을 변경하려면 기본 창을 사용하세요.';

  @override
  String get release_core_guarded_save_refused => '이 파일은 게이트웨이에서 저장할 수 없습니다';

  @override
  String get release_core_guarded_save_unavailable =>
      '이 게이트웨이에서는 충돌 방지 저장을 사용할 수 없습니다';

  @override
  String release_core_git_files_changed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '이 턴에서 파일 $count개 변경됨',
      one: '이 턴에서 파일 1개 변경됨',
    );
    return '$_temp0';
  }

  @override
  String release_core_git_entries_omitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '안전하게 표시할 수 없어 Git 항목 $count개를 제외했습니다.',
      one: '안전하게 표시할 수 없어 Git 항목 1개를 제외했습니다.',
    );
    return '$_temp0';
  }

  @override
  String get release_core_git_staged => '스테이징됨';

  @override
  String get release_core_session_sort_recent => '최근 활동';

  @override
  String get release_core_session_sort_created => '최근 생성순';

  @override
  String get release_core_session_sort_status => '실행 중인 항목 우선';

  @override
  String get release_core_session_sort_tokens => '토큰 수 많은 순';

  @override
  String get release_core_session_sort_cost => '비용 높은 순';

  @override
  String get release_core_session_group_standard => '기본 그룹화';

  @override
  String get release_core_session_group_status => '상태별 그룹화';

  @override
  String get release_core_session_group_project => '프로젝트별 그룹화';

  @override
  String release_core_session_tokens(int count) {
    return '토큰 $count개';
  }

  @override
  String release_core_search_gateway_mode(String mode) {
    return '$mode(게이트웨이)';
  }

  @override
  String release_core_search_mode_tooltip(String label, String mode) {
    return '$label: $mode';
  }

  @override
  String get release_core_image_recovery_new_turn => '보내면 새 턴이 생성됩니다';

  @override
  String release_core_image_recovery_metadata(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '이미지 $count개 · $date',
      one: '이미지 1개 · $date',
    );
    return '$_temp0';
  }

  @override
  String release_core_discovery_scanning(String state) {
    return '스캔: $state';
  }

  @override
  String get release_core_discovery_enabled => '활성화됨';

  @override
  String get release_core_discovery_disabled => '비활성화됨';

  @override
  String get release_core_discovery_none => '없음';

  @override
  String release_core_discovery_roots(String paths) {
    return '스캔 루트: $paths';
  }

  @override
  String release_core_discovery_excluded(String paths) {
    return '제외할 하위 트리: $paths';
  }

  @override
  String release_core_discovery_repository_sessions(String path, int count) {
    return '$path\n세션: $count';
  }

  @override
  String get release_core_projects_local_only =>
      '이 Hermes 게이트웨이는 서버 측 프로젝트보다 구버전이므로 채팅 그룹화가 이 기기에만 유지됩니다. 기기 간에 동일한 프로젝트를 공유하려면 Hermes를 업데이트하세요.';

  @override
  String get release_core_fleet_no_address => '아직 게이트웨이 주소가 없습니다';

  @override
  String release_core_fleet_diagnostics(String version, String access) {
    return '게이트웨이 $version · $access';
  }

  @override
  String get release_core_schedule_builtin => '기본 제공';

  @override
  String get release_core_memory_gateway_profile => '게이트웨이';

  @override
  String release_core_memory_profile_summary(String profile, String gateway) {
    return '$gateway의 프로필 $profile. 공유 코드에는 확대/축소, 시간 및 필터만 저장됩니다.';
  }

  @override
  String release_core_memory_layers_summary(
    int memoryBytes,
    int userBytes,
    String provider,
  ) {
    return '기본 제공 메모리 $memoryBytes바이트, 사용자 메모리 $userBytes바이트. 활성 제공업체: $provider.';
  }

  @override
  String get release_core_memory_kind_all => '모두';

  @override
  String get release_core_memory_kind_skill => '스킬';

  @override
  String get release_core_memory_kind_memory => '메모리';

  @override
  String get release_core_workspace_failure_stale => '연결 변경됨';

  @override
  String get release_core_workspace_failure_unbound => '확인된 작업 디렉터리 없음';

  @override
  String get release_core_workspace_failure_denied => '권한 거부됨';

  @override
  String get release_core_workspace_failure_ineligible => '이 파일에 허용되지 않는 작업';

  @override
  String get release_core_workspace_failure_unsupported => '이 게이트웨이에서 지원하지 않음';

  @override
  String get release_core_workspace_failure_mismatch => '원격 상태 변경됨';

  @override
  String get release_core_workspace_failure_invalid => '잘못된 게이트웨이 응답';

  @override
  String get release_core_workspace_failure_insecure => '보안 연결 필요';

  @override
  String get release_core_workspace_failure_unavailable => '게이트웨이 사용 불가';

  @override
  String get release_core_queue_state_queued => '대기 중';

  @override
  String get release_core_queue_state_started => '시작됨';

  @override
  String get release_core_queue_state_unknown => '결과 알 수 없음';

  @override
  String get release_core_unknown_state => '알 수 없음';

  @override
  String get release_core_fleet_state_idle => '오프라인';

  @override
  String get release_core_fleet_state_connected => '연결됨';

  @override
  String get release_core_fleet_state_reconnecting => '다시 연결 중…';

  @override
  String get release_core_fleet_state_sessionExpired => '로그아웃됨';

  @override
  String get release_core_fleet_state_failed => '연결 실패';

  @override
  String release_core_workspace_operation_failed(String reason) {
    return '게이트웨이 작업을 확인할 수 없습니다: $reason.';
  }

  @override
  String get release_core_workspace_invalid_data =>
      '데이터 또는 입력을 확인할 수 없습니다. 검토한 후 다시 시도하세요.';

  @override
  String
  get release_core_parallel_workspace_layout_changed_in_this_window_but_could_not =>
      '이 창의 레이아웃이 변경되었지만 저장할 수 없습니다.';

  @override
  String get release_core_parallel_workspace_first_pane => '첫 번째 패널';

  @override
  String get release_core_parallel_workspace_second_pane => '두 번째 패널';

  @override
  String get release_core_parallel_workspace_unavailable_page => '사용할 수 없는 페이지';

  @override
  String release_core_parallel_workspace_close_a_tab_first_maximum(
    String maximum,
  ) {
    return '먼저 탭을 닫으세요(최대 $maximum개).';
  }

  @override
  String get release_core_parallel_workspace_dock_beside_current_pane =>
      '현재 패널 옆에 도킹';

  @override
  String get release_core_parallel_workspace_add_chat => '채팅 추가';

  @override
  String
  get release_core_parallel_workspace_action_failed_check_the_connection_and_try_again =>
      '작업에 실패했습니다. 연결을 확인하고 다시 시도하세요.';

  @override
  String
  get release_core_parallel_workspace_close_a_tab_before_reopening_another =>
      '다른 탭을 다시 열기 전에 탭을 닫으세요.';

  @override
  String release_core_parallel_workspace_replace_layout(String name) {
    return '레이아웃 “$name”을(를) 교체하시겠습니까?';
  }

  @override
  String
  get release_core_parallel_workspace_layout_limit_reached_replace_an_existing_layout =>
      '레이아웃 개수 한도에 도달했습니다. 기존 레이아웃을 교체하세요.';

  @override
  String get release_core_parallel_workspace_restore_layout => '레이아웃 복원';

  @override
  String get release_core_parallel_workspace_workspace_options => '워크스페이스 옵션';

  @override
  String get release_core_parallel_workspace_dock_another_pane => '다른 패널 도킹';

  @override
  String get release_core_parallel_workspace_swap_panes => '패널 맞바꾸기';

  @override
  String get release_core_parallel_workspace_undock_second_pane =>
      '두 번째 패널 도킹 해제';

  @override
  String get release_core_parallel_workspace_arrange_side_by_side => '좌우로 배치';

  @override
  String get release_core_parallel_workspace_arrange_top_to_bottom => '위아래로 배치';

  @override
  String release_core_parallel_workspace_change_split_size(String percent) {
    return '분할 크기 변경($percent%)';
  }

  @override
  String get release_core_parallel_workspace_focus_pane_full_screen =>
      '패널을 전체 화면으로 표시';

  @override
  String get release_core_parallel_workspace_open_chat_in_new_window =>
      '새 창에서 채팅 열기';

  @override
  String get release_core_parallel_workspace_hide_pane_keep_running =>
      '패널 숨기기(실행 유지)';

  @override
  String get release_core_parallel_workspace_previous_tab => '이전 탭';

  @override
  String get release_core_parallel_workspace_next_tab => '다음 탭';

  @override
  String get release_core_parallel_workspace_move_tab_left => '탭을 왼쪽으로 이동';

  @override
  String get release_core_parallel_workspace_move_tab_right => '탭을 오른쪽으로 이동';

  @override
  String get release_core_parallel_workspace_reload_current_tab =>
      '현재 탭 다시 불러오기';

  @override
  String get release_core_parallel_workspace_close_tab => '탭 닫기';

  @override
  String get release_core_parallel_workspace_close_other_tabs => '다른 탭 닫기';

  @override
  String get release_core_parallel_workspace_close_tabs_to_the_right =>
      '오른쪽 탭 닫기';

  @override
  String get release_core_parallel_workspace_close_all_tabs => '모든 탭 닫기';

  @override
  String get release_core_parallel_workspace_reopen_closed_tab => '닫은 탭 다시 열기';

  @override
  String get release_core_parallel_workspace_save_named_layout =>
      '이름을 지정하여 레이아웃 저장';

  @override
  String get release_core_parallel_workspace_restore_named_layout =>
      '이름이 지정된 레이아웃 복원';

  @override
  String get release_core_parallel_workspace_refresh_chat_list => '채팅 목록 새로고침';

  @override
  String get release_core_parallel_workspace_workspace_tools => '워크스페이스 도구';

  @override
  String get release_core_parallel_workspace_choose_a_chat_for_this_pane =>
      '이 패널의 채팅 선택';

  @override
  String release_core_parallel_workspace_choose_chat_for(String pane) {
    return '$pane의 채팅 선택';
  }

  @override
  String get release_core_parallel_workspace_add_a_chat_to_start_a_workspace =>
      '워크스페이스를 시작하려면 채팅을 추가하세요.';

  @override
  String get release_core_parallel_workspace_select_a_tab_to_show_its_pane =>
      '탭을 선택하면 해당 패널이 표시됩니다.';

  @override
  String get release_core_parallel_workspace_parallel_workspace => '병렬 워크스페이스';

  @override
  String get release_core_parallel_workspace_show_workspace => '워크스페이스 표시';

  @override
  String get release_core_parallel_workspace_could_not_load_chats_retry =>
      '채팅을 불러올 수 없습니다. 다시 시도';

  @override
  String release_core_parallel_workspace_close(String pane) {
    return '$pane 닫기';
  }

  @override
  String release_core_parallel_workspace_switch_pane(String pane) {
    return '패널 전환: $pane';
  }

  @override
  String get release_core_workspace_registry_session_id_copied =>
      '세션 ID를 복사했습니다.';

  @override
  String get release_core_workspace_registry_chat_details => '채팅 세부 정보';

  @override
  String get release_core_workspace_registry_server_default => '서버 기본값';

  @override
  String get release_core_workspace_registry_session_id => '세션 ID';

  @override
  String get release_core_workspace_registry_title => '제목';

  @override
  String get release_core_workspace_label_terminals => '터미널';

  @override
  String get release_core_workspace_label_copy_id => '세션 ID 복사';

  @override
  String get release_core_workspace_label_contributions => '기여 항목';

  @override
  String get release_core_workspace_owner_inactive =>
      '이 워크스페이스의 소유자가 더 이상 활성 상태가 아닙니다.';

  @override
  String get release_core_workspace_select_chat => '먼저 채팅을 선택하세요.';

  @override
  String get release_core_workspace_chat_unavailable =>
      '이 연결에서는 이 채팅을 사용할 수 없습니다.';

  @override
  String get release_core_workspace_page_unavailable =>
      '이 연결에서는 이 페이지를 사용할 수 없습니다.';

  @override
  String release_core_client_queue_count(int count) {
    return '$count개 대기 중';
  }

  @override
  String release_core_client_queue_paused_count(int count) {
    return '$count개 대기 중 — 일시 중지됨';
  }

  @override
  String release_core_git_diff_truncated(String diff) {
    return '$diff\n… 잘림';
  }

  @override
  String get release_core_search_no_models =>
      'Hermes가 구성된 선택 가능 모델을 반환하지 않았습니다.';

  @override
  String get release_core_chat_archive_unavailable => '채팅 보관 작업을 사용할 수 없습니다.';

  @override
  String get release_core_chat_pin_unconfirmed => '고정 상태가 확인되지 않았습니다.';

  @override
  String get release_core_chat_archive_unconfirmed => '보관 상태가 확인되지 않았습니다.';

  @override
  String get release_core_chat_archive_history_unavailable =>
      '보관된 기록을 사용할 수 없습니다';

  @override
  String get release_core_quick_chat_history_unavailable =>
      '빠른 채팅 기록을 사용할 수 없습니다';

  @override
  String get release_core_chat_project_ownership_unavailable =>
      '프로젝트 소유 정보를 사용할 수 없습니다';

  @override
  String get release_core_chat_unknown_project => '알 수 없는 프로젝트';

  @override
  String get release_core_chat_local_search_fallback =>
      '메시지 검색을 사용할 수 없습니다. 로컬 일치 항목을 표시합니다.';

  @override
  String release_core_fleet_update_eligible(String version) {
    return '업데이트 가능 · $version';
  }

  @override
  String get release_core_fleet_update_state_1 => '건너뜀: 동일한 설치';

  @override
  String get release_core_fleet_update_state_2 => '확인하지 않음';

  @override
  String get release_core_fleet_update_state_3 => '건너뜀: 클라우드에서 관리됨';

  @override
  String get release_core_fleet_update_state_4 => '건너뜀: 직접 연결 게이트웨이로 등록되지 않음';

  @override
  String get release_core_fleet_update_state_5 => '건너뜀: 연결 끊김 또는 사용 중';

  @override
  String get release_core_fleet_update_state_6 => '적용 가능한 업데이트 없음';

  @override
  String get release_core_fleet_update_state_7 => '업데이트 가능 여부를 확인할 수 없음';

  @override
  String get release_core_fleet_update_state_8 => '건너뜀: 오래된 정보, 사용 중 또는 이미 요청됨';

  @override
  String get release_core_fleet_update_state_9 => '요청 중';

  @override
  String get release_core_fleet_update_state_10 => '수락됨. 처리 기록을 사용할 수 없음';

  @override
  String get release_core_fleet_update_state_11 => '수락됨. 처리 기록 대기 중';

  @override
  String get release_core_fleet_update_state_12 => '건너뜀: 이 설치에서 채팅 실행 중';

  @override
  String get release_core_fleet_update_state_13 => '확인되지 않음. 자동으로 다시 보내지 마세요';

  @override
  String get release_core_fleet_update_state_14 => '처리 기록을 확인하려면 다시 연결하세요';

  @override
  String get release_core_fleet_update_state_15 => '처리 기록을 사용할 수 없음';

  @override
  String get release_core_fleet_update_state_16 => '일치하는 처리 기록 대기 중';

  @override
  String get release_core_fleet_update_state_17 => '업데이트됨. 후속 조치 필요';

  @override
  String get release_core_fleet_update_state_19 => '일부 업데이트됨';

  @override
  String get release_core_fleet_update_state_20 => '업데이트 실패';

  @override
  String get release_core_fleet_update_state_21 => '확인되지 않음';

  @override
  String get release_core_cloud_status_ready => '준비됨';

  @override
  String get release_core_cloud_status_online => '온라인';

  @override
  String get release_core_cloud_status_stopped => '중지됨';

  @override
  String get release_core_cloud_status_error => '오류';

  @override
  String get ng_release_more_contributions_subtitle => '이 연결의 검토된 응답 카드';

  @override
  String get ng_release_more_gateway_fleet => '게이트웨이 플릿';

  @override
  String get ng_release_more_memory_graph => '메모리 그래프';

  @override
  String get ng_release_more_memory_graph_subtitle => '타임라인, 편집 및 메모리 제공업체';

  @override
  String get ng_release_more_capabilities_subtitle =>
      '스킬, 플러그인, 커넥터 및 도구 백엔드 설치와 관리';

  @override
  String get ng_release_more_browser_vault => '브라우저 보관함';

  @override
  String get ng_release_more_browser_vault_subtitle =>
      '사이트 로그인, 주소, 카드 및 자격 증명 소스';

  @override
  String get ng_release_more_agent_policy => '에이전트 정책';

  @override
  String get ng_release_more_agent_policy_subtitle =>
      '승인, 체크포인트, 브라우저 액세스 및 공유 지표';

  @override
  String get ng_release_more_schedules => '일정';

  @override
  String get ng_release_more_schedules_subtitle => '모든 프로필, 블루프린트, 누락 실행 및 중지';

  @override
  String get ng_release_more_host_subtitle => '원격 로그, 상태, 유지보수 및 업데이트';

  @override
  String get ng_release_more_providers_routes => '제공업체 및 경로';

  @override
  String get ng_release_more_providers_routes_subtitle =>
      '키, 엔드포인트, 위임 및 모델 조합';

  @override
  String get ng_release_more_credits_plans => '크레딧 및 요금제';

  @override
  String get ng_release_more_credits_plans_subtitle =>
      '계정이 허용하는 경우 동의에 따른 Nous 결제';

  @override
  String get ng_release_sign_in_or => '또는';

  @override
  String ng_release_deployment_sign_in_hint(String message) {
    return '$message 다음 단계에서 배포 세션 토큰으로 로그인할 수도 있습니다.';
  }

  @override
  String get ng_release_message_search_unavailable =>
      '메시지 검색을 사용할 수 없습니다. 로컬 일치 항목을 표시합니다.';

  @override
  String ng_release_insights_days(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days일',
      one: '$days일',
    );
    return '$_temp0';
  }

  @override
  String get ng_release_signed_in_you => '사용자';

  @override
  String get release_chat_unsent_prompt_gone => '해당 미전송 프롬프트는 더 이상 대기열에 없습니다.';

  @override
  String ng_release_attachment_not_attached(String name) {
    return '게이트웨이가 $name의 첨부를 확인하지 않았습니다.';
  }

  @override
  String get ng_release_gateway_not_connected => '아직 게이트웨이에 연결되지 않았습니다.';

  @override
  String get ng_release_gateway_unreachable => '게이트웨이에 연결할 수 없습니다.';

  @override
  String get ng_release_projects_scope_changed => '프로젝트 범위가 더 이상 선택되어 있지 않습니다';

  @override
  String get ng_release_missing_providers => '제공업체 누락';

  @override
  String get ng_release_missing_tasks => '작업 누락';

  @override
  String ng_release_age_minutes(int count) {
    return '$count분';
  }

  @override
  String ng_release_age_hours(int count) {
    return '$count시간';
  }

  @override
  String ng_release_age_days(int count) {
    return '$count일';
  }

  @override
  String ng_release_age_weeks(int count) {
    return '$count주';
  }

  @override
  String ng_release_age_years(int count) {
    return '$count년';
  }

  @override
  String ng_release_compact_billions(String count) {
    return '$count십억';
  }

  @override
  String ng_release_compact_millions(String count) {
    return '$count백만';
  }

  @override
  String ng_release_compact_thousands(String count) {
    return '$count천';
  }

  @override
  String ng_release_token_thousands(String count) {
    return '$count천';
  }

  @override
  String ng_release_elapsed_minutes_seconds(int minutes, int seconds) {
    return '$minutes분 $seconds초';
  }

  @override
  String ng_release_elapsed_seconds(int seconds) {
    return '$seconds초';
  }

  @override
  String get ng_release_notification_foreground => 'Ares가 화면에 표시되어 있었습니다';

  @override
  String get ng_release_notification_stopped => '턴이 중지되었습니다';

  @override
  String get ng_release_more_parallel_workspace => '병렬 워크스페이스';

  @override
  String get ng_release_more_parallel_workspace_subtitle =>
      '여러 채팅을 탭이나 나란히 배치하여 엽니다.';

  @override
  String get release_chat_unknown_model => '알 수 없음';

  @override
  String release_chat_profile_default(String model) {
    return '프로필 기본값: $model';
  }

  @override
  String release_chat_profile_default_provider(String model, String provider) {
    return '프로필 기본값: $model • $provider';
  }

  @override
  String get release_chat_choose_provider =>
      '이 모델은 여러 제공업체에서 사용할 수 있습니다. 계속하려면 제공업체를 선택하세요.';

  @override
  String get release_chat_slash_needs_gateway =>
      '슬래시 명령에는 Desktop 게이트웨이가 필요합니다';

  @override
  String get release_chat_recovering_without_resending => '다시 보내지 않고 복구 중';

  @override
  String get release_chat_live_request_unreachable =>
      '죄송합니다. 해당 요청을 위해 Hermes에 연결할 수 없었습니다.';

  @override
  String release_chat_live_working(String tool) {
    return 'Hermes가 작업 중입니다: $tool. 아직 완료되지 않았습니다.';
  }

  @override
  String get release_chat_live_finished_without_spoken_result =>
      'Hermes가 음성 결과 없이 해당 요청을 완료했습니다.';

  @override
  String get release_chat_reply_language_unavailable => '선택한 응답 언어를 사용할 수 없습니다';

  @override
  String get release_chat_reply_voice_unavailable => '선택한 응답 음성을 사용할 수 없습니다';

  @override
  String get release_chat_reply_voice_configuration_unavailable =>
      '응답 음성 설정을 사용할 수 없습니다';

  @override
  String get release_chat_notification_review_action => '채팅을 열어 요청된 작업을 검토하세요.';

  @override
  String get release_chat_notification_respond => '채팅을 열어 응답하세요.';

  @override
  String get release_chat_start_new_main_window => '기본 창에서 새 채팅을 시작하세요.';

  @override
  String get release_chat_no_desktop_gateway => 'Desktop 게이트웨이 없음';

  @override
  String get release_chat_attachment_preparation_cancelled =>
      '첨부 파일 준비가 취소되었습니다.';

  @override
  String get release_chat_approval_authority_revoked => '승인 권한이 취소되었습니다.';

  @override
  String get release_chat_gateway_session_disconnected =>
      'Desktop 게이트웨이 세션의 연결이 끊어졌습니다';

  @override
  String get release_chat_stop_requested =>
      '중지를 요청했습니다. Hermes가 마칠 때까지 기다리고 있습니다.';

  @override
  String release_chat_stop_request_failed(String error) {
    return '중지를 요청할 수 없습니다: $error';
  }

  @override
  String get release_chat_queued_prompt_not_sent => '대기 중인 프롬프트가 전송되지 않았습니다.';

  @override
  String get release_chat_running_turn_unreachable =>
      '실행 중인 턴에 연결할 수 없습니다. 다시 보내지 않고 다시 연결하고 있습니다.';

  @override
  String get release_chat_wait_for_composer => '입력창을 사용할 수 있을 때까지 기다리세요.';

  @override
  String get release_chat_find_in_transcript => '대화 기록에서 찾기';

  @override
  String get release_chat_open_browser_preview => '브라우저 미리보기 열기';

  @override
  String get release_chat_more_tools => '채팅 도구 더 보기';

  @override
  String get release_chat_queue_until_finished => '이 턴이 끝날 때까지 대기열에 보관';

  @override
  String get release_chat_format_bold => '굵게';

  @override
  String get release_chat_format_italic => '기울임꼴';

  @override
  String get ng_release_chat_gateway_queue_requirements =>
      '게이트웨이 대기열에는 연결된 채팅과 텍스트 전용 프롬프트가 필요합니다.';

  @override
  String get ng_release_chat_start_new_main_screen => '기본 채팅 화면에서 새 채팅을 시작하세요.';

  @override
  String get ng_release_chat_image => '이미지';

  @override
  String ng_release_chat_tool_seconds(String seconds) {
    return '$seconds초';
  }

  @override
  String get release_preview_chat_changed =>
      '채팅이 변경되었습니다. 계속하려면 미리보기를 다시 연결하세요.';

  @override
  String get release_preview_authenticating_chat => '채팅 인증 중…';

  @override
  String release_preview_unavailable_reason(String reason) {
    return '미리보기를 사용할 수 없습니다: $reason';
  }

  @override
  String get release_preview_operation_failed => '미리보기 작업에 실패했습니다.';

  @override
  String get release_preview_added_to_draft => '초안에 추가했습니다. 아무것도 보내지 않았습니다.';

  @override
  String get release_preview_open_site_title => '이 사이트를 여시겠습니까?';

  @override
  String release_preview_open_site_body(String origin) {
    return '$origin\n\n읽기 모드는 이 문서만 불러옵니다. 쿠키, 로그인 정보 또는 페이지를 Hermes와 공유하지 않습니다.';
  }

  @override
  String get release_preview_open_site => '사이트 열기';

  @override
  String get release_preview_discard_pins_title => '초안에 추가하지 않은 핀을 버리시겠습니까?';

  @override
  String get release_preview_keep_pins => '핀 유지';

  @override
  String get release_preview_share_page_title => '이 페이지를 이 채팅과 공유하시겠습니까?';

  @override
  String release_preview_share_page_body(String origin) {
    return 'Hermes는 $origin에 표시된 텍스트와 요소 목록을 읽고 이 패널을 스크롤할 수 있습니다. 다른 페이지로 이동하면 공유가 종료됩니다. 양식과 자격 증명은 공유되지 않습니다.';
  }

  @override
  String get release_preview_share_page => '페이지 공유';

  @override
  String release_preview_comment_number(int number) {
    return '댓글 #$number';
  }

  @override
  String get release_preview_note => '메모';

  @override
  String get release_preview_keep_pin => '핀 유지';

  @override
  String get release_preview_title => '브라우저 미리보기';

  @override
  String get release_preview_hide => '미리보기 숨기기';

  @override
  String get release_preview_close_and_forget => '닫고 페이지 지우기';

  @override
  String get release_preview_site_address => '사이트 주소';

  @override
  String get release_preview_go_to_address => '주소로 이동';

  @override
  String get release_preview_forward => '앞으로';

  @override
  String get release_preview_reload => '다시 불러오기';

  @override
  String get release_preview_share_with_hermes => 'Hermes와 페이지 공유';

  @override
  String get release_preview_stop_sharing => '페이지 공유 중지';

  @override
  String get release_preview_annotate => '요소 또는 영역에 주석 추가';

  @override
  String get release_preview_reader_console => '읽기 모드 콘솔';

  @override
  String get release_preview_reconnect => '미리보기 다시 연결';

  @override
  String get release_preview_reader_mode_help =>
      '읽기 모드: HTML 및 텍스트만 지원합니다. 스크립트, 내장 리소스 또는 로그인된 브라우저 프로필은 사용하지 않습니다.';

  @override
  String release_preview_sharing_origin(String origin) {
    return '이 채팅과 읽기 모드 공유 중: $origin';
  }

  @override
  String get release_preview_annotation_help => '요소를 누르거나 영역을 드래그하여 댓글을 작성하세요.';

  @override
  String get release_preview_reader_requests => '읽기 모드 요청(JavaScript 꺼짐)';

  @override
  String release_preview_selected_requests(int count) {
    return '$count개 선택됨 · JavaScript 꺼짐';
  }

  @override
  String get release_preview_copy_all => '모두 복사';

  @override
  String get release_preview_copy_selected => '선택 항목 복사';

  @override
  String get release_preview_add_log_to_draft => '초안에 로그 추가';

  @override
  String release_preview_requests_draft(String log) {
    return '읽기 모드 요청:\n$log';
  }

  @override
  String release_preview_add_pins_to_draft(int count) {
    return '초안에 $count개 추가';
  }

  @override
  String release_preview_request_loaded(String origin, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '읽기 모드 요소 $count개',
      one: '읽기 모드 요소 $count개',
    );
    return 'HTTP 200 · $origin · $_temp0';
  }

  @override
  String release_preview_annotation_intro(String origin) {
    return '$origin 미리보기에 달린 이 댓글들을 검토하세요. 첨부된 잘라낸 이미지에는 같은 순서로 번호가 매겨져 있습니다.';
  }

  @override
  String get release_preview_reader_region => '읽기 모드 영역';

  @override
  String get release_preview_capture_failed => '이 영역의 이미지를 캡처할 수 없습니다.';

  @override
  String get release_preview_address_not_approved =>
      '이 주소는 승인된 미리보기 출처 밖에 있습니다.';

  @override
  String get release_preview_page_limit => '페이지가 읽기 모드 한도를 초과합니다.';

  @override
  String get release_preview_page_unreadable => '페이지를 읽을 수 없습니다.';

  @override
  String get release_preview_page_complex => '이 페이지는 읽기 모드로 처리하기에 너무 복잡합니다.';

  @override
  String release_preview_http_failed(int statusCode) {
    return 'HTTP $statusCode. 리디렉션을 따르거나 로그인을 진행하지 않았습니다.';
  }

  @override
  String get release_preview_unsupported_type =>
      '읽기 모드에서는 HTML과 일반 텍스트만 열 수 있습니다.';

  @override
  String get release_preview_load_insecure => '사이트를 안전하게 불러올 수 없습니다.';

  @override
  String get release_preview_crop_limit => '잘라낸 미리보기 이미지가 한도를 초과합니다.';

  @override
  String get release_preview_image_unreadable => '선택한 이미지가 비어 있거나 읽을 수 없습니다.';

  @override
  String get release_preview_image_budget =>
      '선택한 이미지가 초안 용량 한도인 64 MiB를 초과합니다.';

  @override
  String get release_preview_image_format =>
      '지원되지 않는 이미지 형식입니다. JPEG, PNG 또는 WebP 이미지를 선택하세요.';

  @override
  String get release_preview_image_decode =>
      '선택한 JPEG, PNG 또는 WebP 이미지를 안전하게 디코딩할 수 없습니다.';

  @override
  String get release_preview_image_sanitize =>
      '이 이미지를 안전하게 정리할 수 없습니다. 유효한 JPEG, PNG 또는 WebP 이미지를 선택하세요.';

  @override
  String get release_preview_draft_budget => '첨부 파일은 초안당 총 64 MiB로 제한됩니다.';

  @override
  String get release_preview_generic_file_limit => '일반 파일은 각각 16 MiB로 제한됩니다.';

  @override
  String get release_preview_image_not_sanitized =>
      '원격 이미지는 업로드 전에 안전하게 정리해야 합니다.';

  @override
  String get release_preview_stage_failed =>
      '미리보기 자료를 초안에 추가할 수 없습니다. 다시 시도하세요.';

  @override
  String get release_misc_find_hermes_on_lan => 'LAN에서 Hermes 찾기';

  @override
  String release_misc_discovery_failed(String error) {
    return '검색 실패: $error';
  }

  @override
  String get release_misc_no_lan_servers => '로컬 네트워크에서 Hermes 서버를 찾지 못했습니다.';

  @override
  String release_misc_api_key_rejected(String endpoint, int statusCode) {
    return '$endpoint에서 API 키를 거부했습니다(HTTP $statusCode).';
  }

  @override
  String get release_misc_api_key_required =>
      '서버에 API 키가 필요합니다. API_SERVER_KEY를 입력하세요.';

  @override
  String release_misc_gateway_not_found(String endpoint) {
    return '게이트웨이 엔드포인트 $endpoint에서 HTTP 404를 반환했습니다. 게이트웨이 경로 접두사와 리버스 프록시 경로를 확인하세요.';
  }

  @override
  String release_misc_gateway_http_error(String endpoint, int statusCode) {
    return '게이트웨이 엔드포인트 $endpoint에서 HTTP $statusCode를 반환했습니다.';
  }

  @override
  String release_misc_gateway_unreachable(String endpoint) {
    return '게이트웨이 엔드포인트 $endpoint에 연결할 수 없습니다.';
  }

  @override
  String get release_core_schedule_invalid_delivery_target =>
      '전송 대상이 올바르지 않습니다';

  @override
  String get release_core_file_save_direct_only =>
      '작업 디렉터리 바로 아래에 있는 파일만 저장할 수 있습니다.';

  @override
  String get release_core_file_save_hidden => '게이트웨이는 숨김 파일을 저장할 수 없습니다.';

  @override
  String get rel_admin_choose_provider => '공급자와 모델을 선택하세요.';

  @override
  String get rel_admin_known_effort => '알려진 추론 수준을 선택하세요.';

  @override
  String get rel_admin_endpoint_name_required => '이 엔드포인트의 이름을 입력하세요.';

  @override
  String get rel_admin_endpoint_model_required => '이 엔드포인트가 제공하는 모델을 입력하세요.';

  @override
  String get rel_admin_known_api_mode => '자동 또는 알려진 API 모드를 선택하세요.';

  @override
  String get rel_admin_endpoint_id_invalid => '이 엔드포인트 식별자는 사용할 수 없습니다.';

  @override
  String get rel_admin_endpoint_https =>
      '원격 엔드포인트에는 HTTPS를, localhost에는 HTTP를 사용하세요.';

  @override
  String get rel_admin_key_invalid => '해당 API 키를 저장할 수 없습니다.';

  @override
  String get rel_admin_response_shape => '게이트웨이 응답이 예상한 구조와 일치하지 않았습니다.';

  @override
  String get rel_admin_limits_required => '저장하기 전에 반복, 동시 실행 및 시간 제한을 입력하세요.';

  @override
  String get rel_admin_route_required => '각 경로를 저장하려면 이름과 모델이 필요합니다.';

  @override
  String get rel_admin_route_unique => '경로 이름은 고유해야 합니다.';

  @override
  String get rel_admin_route_default_invalid => '기본 경로는 저장된 경로 중 하나여야 합니다.';

  @override
  String get rel_admin_policy_required => '참조 모델 성능 저하 정책으로 알림 또는 무음을 선택하세요.';

  @override
  String get rel_admin_mixture_missing => '게이트웨이가 활성 혼합 구성을 반환하지 않았습니다.';

  @override
  String get rel_admin_mixture_slots_required =>
      '집계 모델과 모든 참조 모델의 공급자 및 모델을 지정하세요.';

  @override
  String get rel_admin_chat_id_required => '이 변경을 적용할 채팅 ID를 입력하세요.';

  @override
  String rel_admin_http_error(String status) {
    return '게이트웨이가 HTTP $status를 반환했습니다.';
  }

  @override
  String get rel_admin_response_unreadable => '게이트웨이 응답을 읽을 수 없습니다.';

  @override
  String get rel_admin_connect_before_change =>
      '결제 또는 채팅을 변경하기 전에 실시간 게이트웨이 세션에 연결하세요.';

  @override
  String get rel_admin_operation_unavailable => '이 게이트웨이는 해당 작업을 제공하지 않습니다.';

  @override
  String get rel_admin_key_required => '저장할 키를 입력하세요.';

  @override
  String get rel_admin_key_save_failed => '게이트웨이가 해당 키를 저장하지 않았습니다.';

  @override
  String get rel_admin_key_clear_required => '지울 공급자 키를 선택하세요.';

  @override
  String get rel_admin_key_clear_failed => '게이트웨이가 해당 키를 지우지 않았습니다.';

  @override
  String get rel_admin_endpoint_save_failed => '게이트웨이가 해당 엔드포인트를 저장하지 않았습니다.';

  @override
  String get rel_admin_endpoint_activate_failed =>
      '게이트웨이가 해당 엔드포인트를 활성화하지 않았습니다.';

  @override
  String get rel_admin_accounts_secure_required =>
      '공급자 계정에는 인증된 HTTPS 게이트웨이 또는 localhost가 필요합니다.';

  @override
  String get rel_admin_accounts_read_failed => '공급자 계정을 읽을 수 없습니다.';

  @override
  String get rel_admin_account_disconnect_failed =>
      '게이트웨이가 해당 계정을 연결 해제하지 않았습니다.';

  @override
  String get rel_admin_account_not_disconnectable =>
      '해당 공급자 계정은 연결 해제할 수 없습니다.';

  @override
  String get rel_admin_backend_required => '사용 가능한 위임 백엔드 중 하나를 선택하세요.';

  @override
  String get rel_admin_backend_save_failed => '게이트웨이가 해당 백엔드를 선택하지 않았습니다.';

  @override
  String get rel_admin_routes_save_failed => '게이트웨이가 해당 경로를 저장하지 않았습니다.';

  @override
  String get rel_admin_profile_route_required => '각 프로필 경로에는 프로필 이름이 필요합니다.';

  @override
  String get rel_admin_profile_route_unique => '프로필 경로는 고유해야 합니다.';

  @override
  String get rel_admin_profile_route_default_invalid =>
      '기본 프로필 경로는 허용된 프로필 중 하나여야 합니다.';

  @override
  String get rel_admin_profile_routes_save_failed =>
      '게이트웨이가 해당 프로필 경로를 저장하지 않았습니다.';

  @override
  String get rel_admin_limits_save_failed => '게이트웨이가 해당 제한을 저장하지 않았습니다.';

  @override
  String get rel_admin_mixture_save_failed => '게이트웨이가 해당 혼합 구성을 저장하지 않았습니다.';

  @override
  String get rel_admin_credit_amount_required => '제공된 크레딧 금액 중 하나를 선택하세요.';

  @override
  String get rel_admin_charge_check_failed => '해당 결제를 확인할 수 없습니다.';

  @override
  String get rel_admin_reload_amounts_missing =>
      '자동 충전 금액이 제공되지 않아 변경되지 않았습니다.';

  @override
  String get rel_admin_plan_required => '먼저 요금제를 선택하세요.';

  @override
  String get rel_admin_plan_scheduled_only => '여기서는 예약된 요금제 변경만 확정할 수 있습니다.';

  @override
  String get rel_admin_billing_refused => '게이트웨이가 이 결제 요청을 거부했습니다.';

  @override
  String get rel_admin_request_refused => '게이트웨이가 이 요청을 거부했습니다.';

  @override
  String get rel_admin_endpoint_answered => '엔드포인트가 응답했습니다.';

  @override
  String get rel_admin_endpoint_no_answer => '엔드포인트가 응답하지 않았습니다.';

  @override
  String get rel_admin_charge_unknown =>
      '결제 결과를 알 수 없습니다. 아직 정산될 수 있습니다. 재시도 전에 포털을 확인하세요.';

  @override
  String get rel_admin_connect_before_billing =>
      '결제 정보를 읽기 전에 실시간 게이트웨이 세션에 연결하세요. 이 페이지에서는 청구되지 않습니다.';

  @override
  String get rel_admin_preset_required => '프리셋을 적용하기 전에 저장하세요.';

  @override
  String get rel_admin_cancel => '취소';

  @override
  String get rel_admin_refresh => '새로고침';

  @override
  String get rel_admin_credits_and_plans => '크레딧 및 요금제';

  @override
  String get rel_admin_saved => '저장했어요';

  @override
  String get rel_admin_name => '이름';

  @override
  String get rel_admin_base_url => '기본 URL';

  @override
  String get rel_admin_model => '모델';

  @override
  String get rel_admin_signed_in => '로그인됨';

  @override
  String get rel_admin_not_signed_in => '로그인되지 않음';

  @override
  String get rel_admin_provider => '공급자';

  @override
  String get rel_admin_apply_to_this_chat => '이 채팅에 적용';

  @override
  String get rel_admin_auto => '자동';

  @override
  String get rel_admin_chat_completions => '채팅 완성';

  @override
  String get rel_admin_codex_responses => 'Codex 응답';

  @override
  String get rel_admin_anthropic_messages => 'Anthropic 메시지';

  @override
  String get rel_admin_could_not_complete_that_request => '해당 요청을 완료할 수 없습니다.';

  @override
  String get rel_admin_confirm => '확인';

  @override
  String get rel_admin_providers_and_billing => '공급자 및 결제';

  @override
  String get rel_admin_api_keys => 'API 키';

  @override
  String get rel_admin_custom_endpoints => '사용자 지정 엔드포인트';

  @override
  String get rel_admin_provider_accounts => '공급자 계정';

  @override
  String get rel_admin_effort_and_speed_presets => '추론 수준 및 속도 프리셋';

  @override
  String get rel_admin_delegation => '위임';

  @override
  String get rel_admin_mixture_of_agents => '에이전트 혼합';

  @override
  String get rel_admin_no_provider_keys_were_reported_for_this_profile =>
      '이 프로필에 보고된 공급자 키가 없습니다.';

  @override
  String get rel_admin_not_saved => '저장되지 않음';

  @override
  String get rel_admin_new_key_value => '새 키 값';

  @override
  String get rel_admin_provider_key_saved => '공급자 키를 저장했습니다.';

  @override
  String get rel_admin_save_key => '키 저장';

  @override
  String get rel_admin_clear_provider_key => '공급자 키 지우기';

  @override
  String get rel_admin_provider_key_cleared => '공급자 키를 지웠습니다.';

  @override
  String get rel_admin_clear_key => '키 지우기';

  @override
  String get rel_admin_new_endpoint => '새 엔드포인트';

  @override
  String get rel_admin_api_key => 'API 키';

  @override
  String get rel_admin_leave_blank_to_keep_a_key_this_endpoint_already_has =>
      '이 엔드포인트의 기존 키를 유지하려면 비워 두세요.';

  @override
  String get rel_admin_reachable => '연결 가능';

  @override
  String get rel_admin_unreachable => '연결 불가';

  @override
  String get rel_admin_test_endpoint => '엔드포인트 테스트';

  @override
  String get rel_admin_endpoint_saved => '엔드포인트를 저장했습니다.';

  @override
  String get rel_admin_save_endpoint => '엔드포인트 저장';

  @override
  String get rel_admin_use_this_endpoint => '이 엔드포인트 사용';

  @override
  String
  get rel_admin_make_this_named_endpoint_the_current_model_for_this_profile =>
      '이 명명된 엔드포인트를 이 프로필의 현재 모델로 설정할까요?';

  @override
  String get rel_admin_endpoint_is_now_current => '엔드포인트가 현재 설정으로 지정되었습니다.';

  @override
  String get rel_admin_use_endpoint => '엔드포인트 사용';

  @override
  String get rel_admin_delete_endpoint => '엔드포인트 삭제';

  @override
  String get rel_admin_delete_this_named_endpoint_from_the_profile =>
      '이 명명된 엔드포인트를 프로필에서 삭제할까요?';

  @override
  String get rel_admin_endpoint_deleted => '엔드포인트를 삭제했습니다.';

  @override
  String get rel_admin_signing_in_stays_on_the_provider_sign_in_screen =>
      '로그인은 공급자 로그인 화면에서 진행합니다. 이 게이트웨이가 계정을 제거할 수 있다고 알릴 때만 연결 해제가 실행됩니다.';

  @override
  String get rel_admin_disconnect_this_provider_account_on_the_gateway =>
      '게이트웨이에서 이 공급자 계정의 연결을 해제할까요?';

  @override
  String get rel_admin_provider_account_disconnected => '공급자 계정의 연결을 해제했습니다.';

  @override
  String get rel_admin_disconnect => '연결 해제';

  @override
  String get rel_admin_not_disconnectable => '연결 해제 불가';

  @override
  String get rel_admin_fast => '빠름';

  @override
  String get rel_admin_preset_saved_for_this_model => '이 모델의 프리셋을 저장했습니다.';

  @override
  String get rel_admin_save_preset => '프리셋 저장';

  @override
  String get rel_admin_chat_id => '채팅 ID';

  @override
  String get rel_admin_apply_preset => '프리셋 적용';

  @override
  String get rel_admin_set_this_chat_s_effort_and_speed_from_the_saved_preset =>
      '저장된 프리셋으로 이 채팅의 추론 수준과 속도를 설정할까요?';

  @override
  String get rel_admin_preset_applied_to_this_chat => '이 채팅에 프리셋을 적용했습니다.';

  @override
  String get rel_admin_this_route_sends_the_picked_effort_unchanged =>
      '이 경로는 선택한 추론 수준을 변경 없이 전송합니다.';

  @override
  String get rel_admin_show_route_clamp => '경로 제한 표시';

  @override
  String get rel_admin_delegation_backend => '위임 백엔드';

  @override
  String get rel_admin_delegation_backend_saved => '위임 백엔드를 저장했습니다.';

  @override
  String get rel_admin_save_backend => '백엔드 저장';

  @override
  String get rel_admin_max_iterations => '최대 반복 횟수';

  @override
  String get rel_admin_max_concurrent_children => '최대 동시 하위 에이전트 수';

  @override
  String get rel_admin_child_timeout_seconds => '하위 에이전트 시간 제한(초)';

  @override
  String get rel_admin_delegation_effort_leave_unchanged => '위임 추론 수준, 변경하지 않음';

  @override
  String get rel_admin_delegation_limits_saved => '위임 제한을 저장했습니다.';

  @override
  String get rel_admin_save_limits => '제한 저장';

  @override
  String get rel_admin_remove_route => '경로 제거';

  @override
  String get rel_admin_route_name => '경로 이름';

  @override
  String get rel_admin_route_provider => '경로 공급자';

  @override
  String get rel_admin_route_model => '경로 모델';

  @override
  String get rel_admin_route_effort_unchanged => '경로 추론 수준 변경 없음';

  @override
  String get rel_admin_add_route => '경로 추가';

  @override
  String get rel_admin_default_route => '기본 경로';

  @override
  String get rel_admin_delegation_routes_saved => '위임 경로를 저장했습니다.';

  @override
  String get rel_admin_save_routes => '경로 저장';

  @override
  String get rel_admin_profile_routes_saved => '프로필 경로를 저장했습니다.';

  @override
  String get rel_admin_save_profile_routes => '프로필 경로 저장';

  @override
  String get rel_admin_no_mixture_is_loaded => '로드된 혼합 구성이 없습니다.';

  @override
  String get rel_admin_mixture_enabled => '혼합 구성 활성화';

  @override
  String get rel_admin_loud_degraded_references => '참조 모델 성능 저하 알림';

  @override
  String get rel_admin_silent_degraded_references => '참조 모델 성능 저하 무음';

  @override
  String get rel_admin_aggregator => '집계 모델';

  @override
  String get rel_admin_aggregator_provider => '집계 모델 공급자';

  @override
  String get rel_admin_aggregator_model => '집계 모델';

  @override
  String get rel_admin_reference_provider => '참조 모델 공급자';

  @override
  String get rel_admin_reference_model => '참조 모델';

  @override
  String get rel_admin_add_reference_model => '참조 모델 추가';

  @override
  String get rel_admin_mixture_saved => '혼합 구성을 저장했습니다.';

  @override
  String get rel_admin_save_mixture => '혼합 구성 저장';

  @override
  String get rel_admin_credit_purchase_submitted => '크레딧 구매를 제출했습니다.';

  @override
  String get rel_admin_credit_purchase_settled => '크레딧 구매가 정산되었습니다.';

  @override
  String get rel_admin_credit_and_plan_changes_wait_for_confirmation_a_plan =>
      '크레딧 및 요금제 변경은 확인을 기다립니다. 즉시 청구되는 요금제는 표시되지만 여기서 확정되지 않습니다.';

  @override
  String get rel_admin_buy_credits => '크레딧 구매';

  @override
  String get rel_admin_retry_same_charge => '동일 결제 재시도';

  @override
  String get rel_admin_retry_the_same_credit_charge_this_does_not_start =>
      '동일한 크레딧 결제를 재시도합니다. 두 번째 구매를 시작하지 않습니다.';

  @override
  String get rel_admin_credit_purchases_are_not_available_for_this_account =>
      '이 계정에서는 크레딧을 구매할 수 없습니다.';

  @override
  String get rel_admin_auto_reload => '자동 충전';

  @override
  String get rel_admin_read_only_until_this_account_can_charge =>
      '이 계정에서 결제할 수 있을 때까지 읽기 전용입니다.';

  @override
  String get rel_admin_auto_reload_updated => '자동 충전을 업데이트했습니다.';

  @override
  String get rel_admin_keep_going_on_credits => '크레딧으로 계속';

  @override
  String get rel_admin_continue_on_credits_when_the_plan_window_is_used_up =>
      '요금제 기간의 할당량을 다 쓰면 크레딧으로 계속할까요?';

  @override
  String
  get rel_admin_stop_continuing_on_credits_when_the_plan_window_is_used_up =>
      '요금제 기간의 할당량을 다 쓰면 크레딧으로 계속하는 것을 중지할까요?';

  @override
  String get rel_admin_credit_continuation_updated => '크레딧 계속 사용 설정을 업데이트했습니다.';

  @override
  String get rel_admin_this_plan_change_is_not_confirmed_from_ares =>
      '이 요금제 변경은 Ares에서 확정되지 않습니다.';

  @override
  String get rel_admin_this_change_is_scheduled_confirm_to_apply_it =>
      '이 변경은 예약되어 있습니다. 적용하려면 확인하세요.';

  @override
  String get rel_admin_preview_plan => '요금제 미리 보기';

  @override
  String get rel_admin_schedule_plan_change => '요금제 변경 예약';

  @override
  String get rel_admin_plan_change_scheduled => '요금제 변경을 예약했습니다.';

  @override
  String get rel_admin_confirm_scheduled_plan_change => '예약된 요금제 변경 확정';

  @override
  String rel_admin_remove_key_confirm(String key) {
    return '이 프로필에서 저장된 $key 값을 제거할까요?';
  }

  @override
  String rel_admin_current_endpoint(String name) {
    return '$name · 현재';
  }

  @override
  String rel_admin_endpoint_result(
    String status,
    String transport,
    String count,
    String message,
  ) {
    return '$status · $transport · 모델 $count개. $message';
  }

  @override
  String rel_admin_disconnect_account(String name) {
    return '$name 연결 해제';
  }

  @override
  String rel_admin_delegation_blocked(String reason) {
    return '위임이 차단되었습니다: $reason';
  }

  @override
  String rel_admin_backend_unavailable(String name) {
    return '$name · 사용 불가';
  }

  @override
  String rel_admin_reference_number(String number) {
    return '참조 $number';
  }

  @override
  String rel_admin_reload_enable_confirm(String amount, String threshold) {
    return '자동 충전을 켜고 잔액이 $threshold 미만이 되면 $amount를 청구할까요?';
  }

  @override
  String rel_admin_reload_disable_confirm(String amount, String threshold) {
    return '자동 충전을 끌까요? 현재 잔액이 $threshold 미만이 되면 $amount가 청구됩니다.';
  }

  @override
  String get rel_admin_this_plan => '이 요금제';

  @override
  String rel_admin_plan_confirm(String name) {
    return '$name을(를) 예약합니다. 현재 기간이 끝날 때 적용됩니다. 지금은 청구되지 않습니다.';
  }

  @override
  String rel_admin_plan_confirm_price(String name, String price) {
    return '$name을(를) $price에 예약합니다. 현재 기간이 끝날 때 적용됩니다. 지금은 청구되지 않습니다.';
  }

  @override
  String rel_admin_plan_confirm_when(String name, String when) {
    return '$name을(를) 예약합니다. $when에 적용됩니다. 지금은 청구되지 않습니다.';
  }

  @override
  String rel_admin_plan_confirm_price_when(
    String name,
    String price,
    String when,
  ) {
    return '$name을(를) $price에 예약합니다. $when에 적용됩니다. 지금은 청구되지 않습니다.';
  }

  @override
  String rel_admin_balance(String amount) {
    return '잔액 $amount';
  }

  @override
  String rel_admin_buy_confirm(String amount) {
    return '이 Nous 계정의 결제 수단으로 \$$amount를 청구합니다. 실제 돈이 지출됩니다.';
  }

  @override
  String rel_admin_reload_portal(String url) {
    return '포털에서 자동 충전 변경: $url';
  }

  @override
  String rel_admin_team_portal(String url) {
    return '팀 구독은 포털에서 변경합니다: $url';
  }

  @override
  String get rel_admin_effort_none => '없음';

  @override
  String get rel_admin_effort_minimal => '최소';

  @override
  String get rel_admin_effort_low => '낮음';

  @override
  String get rel_admin_effort_medium => '중간';

  @override
  String get rel_admin_effort_high => '높음';

  @override
  String get rel_admin_effort_xhigh => '매우 높음';

  @override
  String get rel_admin_effort_max => '최대';

  @override
  String get rel_admin_effort_ultra => '초고';

  @override
  String get rel_admin_auto_lower => '자동';

  @override
  String get rel_admin_create => '만들기';

  @override
  String get rel_admin_prompt => '프롬프트';

  @override
  String get rel_admin_new_profile_id => '새 프로필 ID';

  @override
  String get rel_admin_this_operation_is_unavailable_on_this_gateway =>
      '이 게이트웨이에서는 이 작업을 사용할 수 없습니다.';

  @override
  String get rel_admin_access_denied_by_the_gateway => '게이트웨이가 접근을 거부했습니다.';

  @override
  String get rel_admin_connection_changed_reopen_profiles =>
      '연결이 변경되었습니다. 프로필을 다시 여세요.';

  @override
  String
  get rel_admin_invalid_input_or_gateway_response_check_the_target_before =>
      '입력 또는 게이트웨이 응답이 잘못되었습니다. 재시도 전에 대상을 확인하세요.';

  @override
  String get rel_admin_could_not_verify_the_result_refresh_the_target_before =>
      '결과를 확인할 수 없습니다. 다시 시도하기 전에 대상을 새로 고치세요.';

  @override
  String get rel_admin_edit_soul_md => 'SOUL.md 편집';

  @override
  String get rel_admin_persona => '페르소나';

  @override
  String get rel_admin_persona_saved => '페르소나를 저장했습니다.';

  @override
  String get rel_admin_not_set => '설정되지 않음';

  @override
  String get rel_admin_enabled => '활성화됨';

  @override
  String get rel_admin_keys_to_remove_comma_separated => '제거할 키(쉼표로 구분)';

  @override
  String get rel_admin_saved_and_applied_by_the_gateway =>
      '게이트웨이가 저장하고 적용했습니다.';

  @override
  String get rel_admin_saved_a_gateway_restart_may_be_required =>
      '저장했습니다. 게이트웨이를 다시 시작해야 할 수 있습니다.';

  @override
  String get rel_admin_create_signed_route => '서명된 경로 만들기';

  @override
  String get rel_admin_route_id => '경로 ID';

  @override
  String get rel_admin_signature => '서명';

  @override
  String get rel_admin_events_comma_separated => '이벤트(쉼표로 구분)';

  @override
  String get rel_admin_delivery_target => '전달 대상';

  @override
  String get rel_admin_skills_comma_separated => '스킬(쉼표로 구분)';

  @override
  String get rel_admin_delivery_mode => '전달 모드';

  @override
  String get rel_admin_delivery_chat_id_optional => '전달 채팅 ID(선택 사항)';

  @override
  String get rel_admin_hide_signing_secret => '서명 비밀키 숨기기';

  @override
  String get rel_admin_reveal_signing_secret => '서명 비밀키 표시';

  @override
  String get rel_admin_edit_persona => '페르소나 편집';

  @override
  String get rel_admin_portable_profile_bundle => '이동식 프로필 번들';

  @override
  String get rel_admin_clone_profile => '프로필 복제';

  @override
  String get rel_admin_rename_display_label => '표시 이름 바꾸기';

  @override
  String get rel_admin_rename_profile => '프로필 이름 바꾸기';

  @override
  String get rel_admin_new_name => '새 이름';

  @override
  String get rel_admin_rename_verified => '이름 변경을 확인했습니다.';

  @override
  String get rel_admin_delete_profile => '프로필 삭제';

  @override
  String get rel_admin_profile_id_to_delete => '삭제할 프로필 ID';

  @override
  String get rel_admin_profile_deleted => '프로필을 삭제했습니다.';

  @override
  String
  get rel_admin_profile_deleted_server_identity_cleanup_is_still_pending =>
      '프로필을 삭제했습니다. 서버 ID 정리는 아직 대기 중입니다.';

  @override
  String get rel_admin_export_profile_archive => '프로필 압축 파일 내보내기';

  @override
  String get rel_admin_import_profile_archive => '프로필 압축 파일 가져오기';

  @override
  String get rel_admin_import_a_trusted_profile => '신뢰할 수 있는 프로필 가져오기';

  @override
  String get rel_admin_absolute_archive_path_on_gateway => '게이트웨이의 압축 파일 절대 경로';

  @override
  String get rel_admin_messaging_channels => '메시징 채널';

  @override
  String get rel_admin_dm_pairing_requests => 'DM 페어링 요청';

  @override
  String get rel_admin_no_pending_or_approved_users => '대기 중이거나 승인된 사용자가 없습니다.';

  @override
  String get rel_admin_legacy_pairing_no_verifiable_request_id_ask_the_user =>
      '이전 페어링: 확인 가능한 요청 ID가 없습니다. 사용자에게 다시 페어링하도록 요청하세요.';

  @override
  String get rel_admin_pairing_change_verified => '페어링 변경을 확인했습니다.';

  @override
  String get rel_admin_create_telegram_bot_by_qr => 'QR로 Telegram 봇 만들기';

  @override
  String get rel_admin_create_telegram_bot => 'Telegram 봇 만들기';

  @override
  String get rel_admin_bot_name => '봇 이름';

  @override
  String get rel_admin_telegram_bot_creation_qr_code => 'Telegram 봇 생성 QR 코드';

  @override
  String get rel_admin_check_telegram_pairing => 'Telegram 페어링 확인';

  @override
  String get rel_admin_waiting_for_telegram => 'Telegram 대기 중.';

  @override
  String get rel_admin_apply_telegram_bot => 'Telegram 봇 적용';

  @override
  String get rel_admin_allowed_numeric_user_ids => '허용된 숫자 사용자 ID';

  @override
  String get rel_admin_saved_restart_still_required =>
      '저장했습니다. 여전히 다시 시작해야 합니다.';

  @override
  String get rel_admin_saved_gateway_restart_requested =>
      '저장했습니다. 게이트웨이 다시 시작을 요청했습니다.';

  @override
  String get rel_admin_cancel_telegram_setup => 'Telegram 설정 취소';

  @override
  String get rel_admin_inbound_webhooks => '수신 웹훅';

  @override
  String get rel_admin_enable_webhook_service => '웹훅 서비스 활성화';

  @override
  String get rel_admin_enable_webhooks => '웹훅 활성화';

  @override
  String get rel_admin_enabled_restart_still_required =>
      '활성화했습니다. 여전히 다시 시작해야 합니다.';

  @override
  String get rel_admin_enabled_restart_requested => '활성화했습니다. 다시 시작을 요청했습니다.';

  @override
  String get rel_admin_route_change_verified => '경로 변경을 확인했습니다.';

  @override
  String get rel_admin_delete_route => '경로 삭제';

  @override
  String get rel_admin_disable_route => '경로 비활성화';

  @override
  String get rel_admin_enable_route => '경로 활성화';

  @override
  String get rel_admin_back_up_entire_agent_home => '전체 에이전트 홈 백업';

  @override
  String get rel_admin_transfer_to_a_cloud_agent => 'Cloud 에이전트로 전송';

  @override
  String get rel_admin_check_backup_progress => '백업 진행 상황 확인';

  @override
  String get rel_admin_save_backup_to_this_device => '이 기기에 백업 저장';

  @override
  String get rel_admin_save_sensitive_full_home_archive => '민감한 전체 홈 압축 파일 저장';

  @override
  String get rel_admin_save_cancelled => '저장을 취소했습니다.';

  @override
  String get rel_admin_backup_saved => '백업을 저장했습니다.';

  @override
  String get rel_admin_up_to_32_mib_larger_archives_remain_on_the_gateway =>
      '최대 32 MiB. 더 큰 압축 파일은 게이트웨이에 남습니다.';

  @override
  String rel_admin_persona_scope(String scope) {
    return '$scope의 페르소나를 저장합니다.';
  }

  @override
  String rel_admin_configure_channel(String name) {
    return '$name 설정';
  }

  @override
  String rel_admin_channel_warning(String scope) {
    return '$scope에 적용됩니다. 비워 두면 기존 값이 유지됩니다. 값을 제거하려면 아래에 해당 키를 나열하세요.';
  }

  @override
  String rel_admin_hook_warning(String scope) {
    return '$scope에 적용됩니다. 고유한 이름을 사용하세요. 게이트웨이가 서명 비밀키를 만듭니다. 다른 운영자가 동시에 같은 이름을 만들면 호스트가 해당 경로를 대체할 수 있습니다.';
  }

  @override
  String rel_admin_hook_created(String url) {
    return '$url을(를) 만들었습니다. 떠나기 전에 서명 비밀키를 보관하세요.';
  }

  @override
  String rel_admin_clone_warning(String scope) {
    return '$scope에서 설정, 스킬, 페르소나 및 공급자 자격 증명을 복사할 수 있습니다. 메시징 토큰은 요청하지 않습니다.';
  }

  @override
  String rel_admin_cloned(String source, String destination) {
    return '$source을(를) $destination(으)로 복제했습니다.';
  }

  @override
  String rel_admin_rename_target(String name) {
    return '$name 이름 바꾸기';
  }

  @override
  String rel_admin_rename_label_warning(String scope) {
    return '$scope의 표시 이름을 변경합니다. ID는 default로 유지됩니다.';
  }

  @override
  String rel_admin_rename_warning(String scope) {
    return '서버에서 $scope의 이름을 변경합니다. 실행 중인 게이트웨이가 중지될 수 있습니다.';
  }

  @override
  String rel_admin_delete_target(String name) {
    return '$name 삭제';
  }

  @override
  String rel_admin_delete_profile_warning(String scope) {
    return '세션과 자격 증명을 포함한 $scope을(를) 영구 삭제합니다. 정확한 프로필 ID를 입력하세요.';
  }

  @override
  String rel_admin_export_target(String name) {
    return '$name 내보내기';
  }

  @override
  String rel_admin_export_warning(String scope) {
    return '$scope에 .tar.gz를 만듭니다. 알려진 자격 증명 저장소는 제외되지만 개인 데이터가 남을 수 있습니다. 공유하기 전에 검토하세요.';
  }

  @override
  String rel_admin_archive_on(String gateway, String path) {
    return '$gateway의 압축 파일: $path';
  }

  @override
  String rel_admin_import_warning(String gateway) {
    return '$gateway에 이미 있는 검토된 .tar.gz를 사용하세요. 플러그인, 스크립트 및 일정이 포함될 수 있습니다. 새 프로필 ID가 필요합니다.';
  }

  @override
  String rel_admin_imported(String name) {
    return '$name을(를) 가져왔습니다.';
  }

  @override
  String rel_admin_approve_user(String user) {
    return '$user 승인';
  }

  @override
  String rel_admin_revoke_user(String user) {
    return '$user 철회';
  }

  @override
  String rel_admin_allow_pair(String platform, String scope) {
    return '$scope의 $platform: 이 사용자의 메시징 접근을 허용합니다.';
  }

  @override
  String rel_admin_remove_pair(String platform, String scope) {
    return '$scope의 $platform: 이 사용자의 메시징 접근을 제거합니다.';
  }

  @override
  String rel_admin_telegram_start(String scope) {
    return '게이트웨이 설정 서비스를 사용하여 $scope에서 Telegram 페어링을 시작합니다.';
  }

  @override
  String rel_admin_expires(String time) {
    return '만료: $time';
  }

  @override
  String rel_admin_telegram_apply(String bot, String scope) {
    return '$scope에서 @$bot을(를) 활성화하고 게이트웨이 다시 시작을 시도합니다. 나열된 사용자만 메시지를 보낼 수 있습니다.';
  }

  @override
  String rel_admin_hooks_enable(String scope) {
    return '$scope에서 수신 웹훅을 활성화하고 게이트웨이 다시 시작을 시도합니다.';
  }

  @override
  String rel_admin_disable_target(String name) {
    return '$name 비활성화';
  }

  @override
  String rel_admin_enable_target(String name) {
    return '$name 활성화';
  }

  @override
  String rel_admin_hook_change(String name, String scope) {
    return '$scope의 $name만 변경합니다.';
  }

  @override
  String rel_admin_backup_warning(String gateway) {
    return 'Ares 설정 백업이 아닙니다. $gateway의 모든 프로필, 세션 및 자격 증명을 저장합니다. 압축 파일에는 민감한 정보가 있습니다.';
  }

  @override
  String rel_admin_backup_started(String gateway) {
    return '$gateway에서 백업을 시작했습니다.';
  }

  @override
  String rel_admin_backup_verified(String gateway, String path) {
    return '$gateway에서 백업을 확인했습니다: $path';
  }

  @override
  String rel_admin_backup_running(String gateway) {
    return '$gateway에서 백업이 아직 실행 중입니다.';
  }

  @override
  String get rel_admin_choice_yes => '예';

  @override
  String get rel_admin_choice_no => '아니요';

  @override
  String get rel_admin_choice_generic => '일반';

  @override
  String get rel_admin_choice_log => '로그';

  @override
  String get rel_admin_choice_email => '이메일';

  @override
  String get rel_admin_choice_github_comment => 'GitHub 댓글';

  @override
  String get rel_admin_choice_agent => '에이전트가 이벤트 처리';

  @override
  String get rel_admin_choice_direct => '직접 전달';

  @override
  String get rel_admin_configured => '구성됨';

  @override
  String get rel_admin_state_pending_restart => '다시 시작 대기 중';

  @override
  String get rel_admin_state_unknown => '알 수 없음';

  @override
  String get rel_admin_state_connected => '연결됨';

  @override
  String get rel_admin_state_disconnected => '연결 해제됨';

  @override
  String get rel_admin_state_disabled => '비활성화됨';

  @override
  String get rel_admin_state_enabled => '활성화됨';

  @override
  String get rel_admin_state_running => '실행 중';

  @override
  String get rel_admin_state_stopped => '중지됨';

  @override
  String get rel_admin_state_error => '오류';

  @override
  String get rel_admin_state_not_configured => '구성되지 않음';

  @override
  String get rel_admin_state_startup_failed => '시작 실패';

  @override
  String get rel_admin_state_gateway_stopped => '게이트웨이 중지됨';

  @override
  String get rel_admin_state_connecting => '연결 중';

  @override
  String get rel_admin_state_retrying => '재시도 중';

  @override
  String get rel_admin_state_fatal => '치명적 오류';

  @override
  String get rel_admin_unsupported_or_oversized_profile_archive =>
      '지원되지 않거나 너무 큰 프로필 압축 파일입니다.';

  @override
  String get rel_admin_current_layout => '현재 레이아웃';

  @override
  String get rel_admin_one_pane => '패널 하나';

  @override
  String get rel_admin_stacked => '위아래로';

  @override
  String get rel_admin_side_by_side => '나란히';

  @override
  String get rel_admin_no_supported_appearance_in_this_profile =>
      '이 프로필에 지원되는 모양이 없습니다.';

  @override
  String get rel_admin_review_appearance_saved_with_this_profile =>
      '이 프로필에 저장된 모양 검토';

  @override
  String get rel_admin_applies_only_to_this_named_profile_on_this_device =>
      '이 기기의 이 명명된 프로필에만 적용됩니다. 가져온 배치는 빈 패널로 시작하며 채팅은 직접 선택해야 합니다.';

  @override
  String get rel_admin_apply_to_this_profile_on_this_device =>
      '이 기기의 이 프로필에 적용';

  @override
  String get rel_admin_export_prepares_a_tar_gz_on_the_gateway_review =>
      '내보내기는 게이트웨이에 .tar.gz를 준비합니다. 여기에 사본을 저장하기 전에 이동 가능한 파일을 검토하세요. 가져오기는 검토를 위해 로컬 압축 파일을 열며, 열기만으로는 아무것도 업로드하지 않습니다.';

  @override
  String get rel_admin_prepare_profile_export => '프로필 내보내기 준비';

  @override
  String get rel_admin_open_tar_gz_from_this_device => '이 기기에서 .tar.gz 열기';

  @override
  String get rel_admin_only_selected_text_files_travel_review_for_secrets_and =>
      '선택한 텍스트 파일만 전송됩니다. 비밀 정보와 개인 정보가 있는지 검토하세요. 설정, 스킬 및 일정은 새 프로필의 동작을 바꿀 수 있습니다.';

  @override
  String get rel_admin_include_this_reviewed_file => '검토한 이 파일 포함';

  @override
  String get rel_admin_apply_appearance_to_the_new_profile_on_this_device =>
      '이 기기의 새 프로필에 모양 적용';

  @override
  String
  get rel_admin_imports_colours_and_pane_sizes_never_chats_tools_or_session_ids =>
      '색상과 패널 크기를 가져오며 채팅, 도구 또는 세션 ID는 가져오지 않습니다.';

  @override
  String
  get rel_admin_the_gateway_retains_a_private_staged_copy_import_creates =>
      '게이트웨이는 비공개 임시 사본을 보관합니다. 가져오기는 새 프로필을 만들며 기존 프로필을 대체하지 않습니다.';

  @override
  String get rel_admin_appearance_not_applied_the_gateway_did_not_confirm_the =>
      ' 모양을 적용하지 않았습니다. 게이트웨이가 검토한 오버레이를 확인하지 않았습니다.';

  @override
  String get rel_admin_appearance_applied_on_this_device =>
      ' 이 기기에 모양을 적용했습니다.';

  @override
  String get rel_admin_appearance_was_not_saved_on_this_device =>
      ' 이 기기에 모양을 저장하지 못했습니다.';

  @override
  String get rel_admin_save_reviewed_profile_bundle => '검토한 프로필 번들 저장';

  @override
  String get rel_admin_profile_bundle_saved => '프로필 번들을 저장했습니다.';

  @override
  String get rel_admin_import_selected_files => '선택한 파일 가져오기';

  @override
  String get rel_admin_save_selected_files_to_device => '선택한 파일을 기기에 저장';

  @override
  String rel_admin_layout_first_pane(String layout, String percent) {
    return '$layout · 첫 패널 $percent%';
  }

  @override
  String rel_admin_appearance_summary(String skin, String mode, String layout) {
    return '스킨: $skin · 모드: $mode · $layout';
  }

  @override
  String rel_admin_appearance_applied(String gateway, String profile) {
    return '$gateway / $profile에 모양을 적용했습니다.';
  }

  @override
  String rel_admin_bundle_summary(
    String profile,
    String count,
    String omitted,
  ) {
    return '번들: $profile · 검토 가능한 파일 $count개 · 제외 $omitted개';
  }

  @override
  String rel_admin_imported_on(String name, String gateway) {
    return '$gateway에서 $name을(를) 가져왔습니다.';
  }

  @override
  String get rel_admin_unchanged => '변경 없음';

  @override
  String get rel_admin_mode_system => '시스템';

  @override
  String get rel_admin_mode_light => '밝게';

  @override
  String get rel_admin_mode_dark => '어둡게';

  @override
  String get rel_admin_skin_classic => '클래식';

  @override
  String get rel_admin_skin_midnight => '한밤중';

  @override
  String get rel_admin_skin_ember => '불씨';

  @override
  String get rel_admin_skin_mono => '단색';

  @override
  String get rel_admin_skin_cyberpunk => '사이버펑크';

  @override
  String get rel_admin_skin_slate => '슬레이트';

  @override
  String get rel_admin_no_available_cloud_agents_in_this_account =>
      '이 계정에 사용 가능한 Cloud 에이전트가 없습니다.';

  @override
  String get rel_admin_the_previous_undo_receipt_could_not_be_verified_no =>
      '이전 실행 취소 확인서를 검증할 수 없습니다. 변경 사항이 없습니다.';

  @override
  String get rel_admin_transfer_to_cloud => 'Cloud로 전송';

  @override
  String
  get rel_admin_connection_changed_leave_this_page_a_restore_already_submitted =>
      '연결이 변경되었습니다. 이 페이지를 떠나세요. 이미 제출된 복원은 계속될 수 있습니다.';

  @override
  String get rel_admin_find_my_cloud_agents => '내 Cloud 에이전트 찾기';

  @override
  String
  get rel_admin_undo_replaces_the_destination_with_its_pre_transfer_backup =>
      '실행 취소는 대상을 전송 전 백업으로 대체합니다.';

  @override
  String get rel_admin_replace_this_cloud_agent_with_the_entire_source_home =>
      '이 Cloud 에이전트를 자격 증명, 대화 및 파일을 포함한 전체 원본 홈으로 대체합니다. 원본은 삭제되지 않습니다. 수신 메시징 봇은 꺼집니다.';

  @override
  String get rel_admin_type_destination_agent_id => '대상 에이전트 ID 입력';

  @override
  String
  get rel_admin_could_not_retain_the_local_undo_receipt_keep_this_page_open =>
      '로컬 실행 취소 확인서를 보관할 수 없습니다. 이 페이지를 열어 두세요.';

  @override
  String get rel_admin_undo_transfer => '전송 실행 취소';

  @override
  String get rel_admin_replace_cloud_agent => 'Cloud 에이전트 대체';

  @override
  String
  get rel_admin_local_undo_receipt_forgotten_no_remote_backup_was_removed =>
      '로컬 실행 취소 확인서를 삭제했습니다. 원격 백업은 제거되지 않았습니다.';

  @override
  String get rel_admin_forget_local_undo_receipt_only => '로컬 실행 취소 확인서만 삭제';

  @override
  String get rel_admin_stop_before_restore => '복원 전 중지';

  @override
  String get rel_admin_do_not_close_this_page_restore_runs_on_the =>
      '이 페이지를 닫지 마세요. 복원은 대상에서 실행되며 취소할 수 없습니다.';

  @override
  String get rel_admin_files_restored_destination_gateway_needs_attention =>
      '파일을 복원했습니다. 대상 게이트웨이를 확인해야 합니다.';

  @override
  String rel_admin_transfer_sign_in(String origin) {
    return '$origin에 대해 저장된 Ares 연결 중 정확히 하나에 로그인한 후 여기로 돌아오세요.';
  }

  @override
  String rel_admin_transfer_source(String gateway, String profile) {
    return '원본: $gateway / $profile';
  }

  @override
  String rel_admin_transfer_destination(String name, String origin) {
    return '대상: $name · $origin / default';
  }

  @override
  String rel_admin_agent_id(String id) {
    return '에이전트 ID: $id';
  }

  @override
  String rel_admin_transfer_status(String phase) {
    return '상태: $phase';
  }

  @override
  String rel_admin_copied_percent(String percent) {
    return '$percent% 복사됨';
  }

  @override
  String rel_admin_undo_point(String path) {
    return '대상의 실행 취소 지점: $path';
  }

  @override
  String rel_admin_messaging_disabled(String channels) {
    return '메시징 비활성화됨: $channels';
  }

  @override
  String get rel_admin_phase_prepared => '준비됨';

  @override
  String get rel_admin_phase_backup => '백업';

  @override
  String get rel_admin_phase_upload => '업로드';

  @override
  String get rel_admin_phase_restore => '복원';

  @override
  String get rel_admin_phase_finished => '완료됨';

  @override
  String get rel_admin_phase_failed => '실패';

  @override
  String get rel_admin_phase_undo => '실행 취소';

  @override
  String get rel_admin_phase_undone => '실행 취소됨';

  @override
  String rel_ops_cap_install_blocked(String verdict, String detail) {
    return '설치 차단됨($verdict): $detail';
  }

  @override
  String rel_ops_cap_scan_confirm(String verdict, String requested) {
    return '검사 결과: $verdict. 설치하기 전에 $requested을(를) 확인하세요.';
  }

  @override
  String rel_ops_cap_install_unconfirmed(String requested) {
    return '게이트웨이에서 $requested의 설치를 아직 확인하지 않았습니다.';
  }

  @override
  String rel_ops_cap_edit_skill(String name) {
    return '$name 편집';
  }

  @override
  String rel_ops_cap_archive_skill(String name) {
    return '$name을(를) 보관할까요?';
  }

  @override
  String rel_ops_cap_archive_explanation(String command) {
    return '스킬이 보관되며 $command 명령으로 복원할 수 있습니다.';
  }

  @override
  String rel_ops_cap_install_anyway(String name) {
    return '그래도 $name 설치';
  }

  @override
  String rel_ops_cap_install_despite_scan(String name) {
    return '검사 결과에도 불구하고 $name을(를) 설치할까요?';
  }

  @override
  String rel_ops_cap_scan_warning(String name) {
    return '보안 검사에서 $name을(를) 차단했습니다. 이 확인은 $name에만 적용됩니다.';
  }

  @override
  String rel_ops_cap_accept_scan_warning(String name) {
    return '기능 권한을 수락해도 $name의 검사 결과를 무시할 수 없습니다.';
  }

  @override
  String rel_ops_cap_review_scan(String name) {
    return '$name 검사 결과 검토';
  }

  @override
  String rel_ops_cap_desktop_grants(String description) {
    return '$description\n폴더 및 미리 보기 스크립트 권한은 해당 컴퓨터의 Desktop 앱에 유지됩니다. 여기서 플러그인을 제거해도 해당 로컬 권한은 취소되지 않습니다.';
  }

  @override
  String rel_ops_cap_remove_plugin(String name) {
    return '$name을(를) 제거할까요?';
  }

  @override
  String rel_ops_cap_probe_result(String name, String tools) {
    return '$name 연결 테스트: $tools';
  }

  @override
  String rel_ops_cap_save_tool_grants_for(String connector) {
    return '$connector의 도구 권한 저장';
  }

  @override
  String rel_ops_cap_backends_for(String name) {
    return '$name의 백엔드';
  }

  @override
  String rel_ops_cap_use_backend_confirmation(String name) {
    return '$name을(를) 사용할까요?';
  }

  @override
  String rel_ops_cap_unlock_source(String name) {
    return '$name 잠금 해제';
  }

  @override
  String get rel_ops_cap_capabilities => '기능';

  @override
  String get rel_ops_cap_plugins => '플러그인';

  @override
  String get rel_ops_cap_connectors => '커넥터';

  @override
  String get rel_ops_cap_backends => '백엔드';

  @override
  String get rel_ops_cap_save_skill => '스킬 저장';

  @override
  String get rel_ops_cap_archive => '보관';

  @override
  String get rel_ops_cap_hub_identifier => 'Hub 식별자';

  @override
  String get rel_ops_cap_install => '설치';

  @override
  String get rel_ops_cap_update_all => '모두 업데이트';

  @override
  String get rel_ops_cap_unlock => '잠금 해제';

  @override
  String get rel_ops_cap_lock => '잠금';

  @override
  String get rel_ops_cap_this_update_adds_capabilities_nothing_changed_yet =>
      '이 업데이트는 기능을 추가합니다. 아직 변경된 사항은 없습니다.';

  @override
  String get rel_ops_cap_the_scan_blocked_this_plugin => '검사에서 이 플러그인을 차단했습니다.';

  @override
  String get rel_ops_cap_the_plugin_was_not_changed => '플러그인이 변경되지 않았습니다.';

  @override
  String get rel_ops_cap_repository => '저장소';

  @override
  String get rel_ops_cap_install_plugin => '플러그인 설치';

  @override
  String get rel_ops_cap_update_plugins => '플러그인 업데이트';

  @override
  String get rel_ops_cap_accept_capabilities => '기능 권한 수락';

  @override
  String get rel_ops_cap_update => '업데이트';

  @override
  String get rel_ops_cap_remove_desktop_half => '데스크톱 구성 요소 제거';

  @override
  String get rel_ops_cap_server_name => '서버 이름';

  @override
  String get rel_ops_cap_command => '명령';

  @override
  String get rel_ops_cap_http_url => 'HTTP URL';

  @override
  String get rel_ops_cap_add_server => '서버 추가';

  @override
  String get rel_ops_cap_probe => '연결 테스트';

  @override
  String get rel_ops_cap_probe_failed => '연결 테스트에 실패했습니다.';

  @override
  String get rel_ops_cap_logs => '로그';

  @override
  String get rel_ops_cap_mcp_log => 'MCP 로그';

  @override
  String get rel_ops_cap_connector => '커넥터';

  @override
  String get rel_ops_cap_account_alias => '계정 별칭';

  @override
  String get rel_ops_cap_link_account => '계정 연결';

  @override
  String get rel_ops_cap_remove_account => '계정 제거';

  @override
  String get rel_ops_cap_tool_connector => '도구 커넥터';

  @override
  String get rel_ops_cap_load_tools => '도구 불러오기';

  @override
  String get rel_ops_cap_save_tool_grants => '도구 권한 저장';

  @override
  String
  get rel_ops_cap_this_policy_has_no_member_revision_so_tool_grants_stay_unchanged =>
      '이 정책에는 멤버 리비전이 없으므로 도구 권한이 변경되지 않습니다.';

  @override
  String get rel_ops_cap_active => '사용 중';

  @override
  String get rel_ops_cap_use => '사용';

  @override
  String get rel_ops_cap_run_setup => '설정 실행';

  @override
  String get rel_ops_cap_terminal_backends => '터미널 백엔드';

  @override
  String get rel_ops_cap_this_changes_the_terminal_backend_for_this_profile =>
      '이 프로필의 터미널 백엔드가 변경됩니다.';

  @override
  String get rel_ops_cap_use_backend => '백엔드 사용';

  @override
  String get rel_ops_cap_select => '선택';

  @override
  String get rel_ops_cap_browser_vault => '브라우저 보관함';

  @override
  String
  get rel_ops_cap_saved_site_logins_addresses_and_cards_passwords_stay_in_the_secure_fields_and_are_not_listed_here =>
      '저장된 사이트 로그인, 주소 및 카드입니다. 비밀번호는 보안 필드에 유지되며 여기에 표시되지 않습니다.';

  @override
  String get rel_ops_cap_remove_saved_item => '저장된 항목 제거';

  @override
  String get rel_ops_cap_delete_this_item => '이 항목을 삭제할까요?';

  @override
  String get rel_ops_cap_unlocked => '잠금 해제됨';

  @override
  String get rel_ops_cap_locked => '잠김';

  @override
  String get rel_ops_cap_not_detected => '감지되지 않음';

  @override
  String get rel_ops_cap_master_password => '마스터 비밀번호';

  @override
  String get rel_ops_cap_login => '로그인 정보';

  @override
  String get rel_ops_cap_address => '주소';

  @override
  String get rel_ops_cap_card => '카드';

  @override
  String get rel_ops_cap_label => '라벨';

  @override
  String get rel_ops_cap_site_origin => '사이트 출처';

  @override
  String get rel_ops_cap_identifier => '식별자';

  @override
  String get rel_ops_cap_password => '비밀번호';

  @override
  String get rel_ops_cap_authenticator_key => '인증 키';

  @override
  String get rel_ops_cap_street => '도로명 주소';

  @override
  String get rel_ops_cap_city => '도시';

  @override
  String get rel_ops_cap_postal_code => '우편번호';

  @override
  String get rel_ops_cap_country => '국가';

  @override
  String get rel_ops_cap_name_on_card => '카드 소유자 이름';

  @override
  String get rel_ops_cap_card_number => '카드 번호';

  @override
  String get rel_ops_cap_expiry_month => '만료 월';

  @override
  String get rel_ops_cap_expiry_year => '만료 연도';

  @override
  String get rel_ops_cap_security_code => '보안 코드';

  @override
  String get rel_ops_cap_this_gateway_has_no_shared_metrics_consent_method =>
      '이 게이트웨이에는 공유 지표 동의 메서드가 없습니다.';

  @override
  String get rel_ops_cap_agent_policy => '에이전트 정책';

  @override
  String get rel_ops_cap_loading_policy => '정책 불러오는 중';

  @override
  String get rel_ops_cap_approval_timeout => '승인 대기 시간 제한';

  @override
  String get rel_ops_cap_confirm_mcp_reloads => 'MCP 새로고침 확인';

  @override
  String get rel_ops_cap_command_allowlist => '명령 허용 목록';

  @override
  String get rel_ops_cap_file_checkpoints => '파일 체크포인트';

  @override
  String get rel_ops_cap_checkpoint_limit => '체크포인트 한도';

  @override
  String get rel_ops_cap_browser_private_urls => '브라우저 비공개 URL';

  @override
  String get rel_ops_cap_use_my_real_browser_profile => '내 실제 브라우저 프로필 사용';

  @override
  String get rel_ops_cap_save_policy => '정책 저장';

  @override
  String get rel_ops_cap_shared_metrics_for_this_profile => '이 프로필의 공유 지표';

  @override
  String get rel_ops_cap_send_shared_metrics => '공유 지표 전송';

  @override
  String get rel_ops_cap_error_enter_a_label => '라벨을 입력하세요.';

  @override
  String get rel_ops_cap_error_enter_a_valid_url_like_https_example_com =>
      'https://example.com과 같은 올바른 URL을 입력하세요.';

  @override
  String get rel_ops_cap_error_enter_the_identifier_and_password =>
      '식별자와 비밀번호를 입력하세요.';

  @override
  String
  get rel_ops_cap_error_enter_the_card_name_number_expiry_and_security_code =>
      '카드 소유자 이름, 번호, 만료일 및 보안 코드를 입력하세요.';

  @override
  String get rel_ops_cap_error_enter_the_street_city_postal_code_and_country =>
      '도로명 주소, 도시, 우편번호 및 국가를 입력하세요.';

  @override
  String
  get rel_ops_cap_error_the_gateway_returned_a_response_that_could_not_be_read =>
      '게이트웨이가 읽을 수 없는 응답을 반환했습니다.';

  @override
  String rel_ops_cap_error_the_gateway_refused_the_request_status(
    int statusCode,
  ) {
    return '게이트웨이가 요청을 거부했습니다($statusCode).';
  }

  @override
  String
  rel_ops_cap_error_this_connection_has_no_gateway_socket_so_method_is_unavailable(
    String method,
  ) {
    return '이 연결에는 게이트웨이 소켓이 없으므로 $method을(를) 사용할 수 없습니다.';
  }

  @override
  String get rel_ops_cap_error_choose_a_skill => '스킬을 선택하세요.';

  @override
  String get rel_ops_cap_error_the_skill_text_was_not_returned =>
      '스킬 텍스트가 반환되지 않았습니다.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_saved => '스킬이 저장되지 않았습니다.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_archived => '스킬이 보관되지 않았습니다.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_installed => '스킬이 설치되지 않았습니다.';

  @override
  String get rel_ops_cap_error_skill_updates_did_not_start =>
      '스킬 업데이트가 시작되지 않았습니다.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_removed => '스킬이 제거되지 않았습니다.';

  @override
  String get rel_ops_cap_error_enter_a_skill_or_plugin_identifier =>
      '스킬 또는 플러그인 식별자를 입력하세요.';

  @override
  String get rel_ops_cap_error_choose_a_plugin => '플러그인을 선택하세요.';

  @override
  String get rel_ops_cap_error_the_plugin_was_not_removed =>
      '플러그인이 제거되지 않았습니다.';

  @override
  String get rel_ops_cap_error_the_desktop_half_was_not_removed =>
      '데스크톱 구성 요소가 제거되지 않았습니다.';

  @override
  String
  get rel_ops_cap_error_this_gateway_did_not_give_the_plugin_a_stable_key =>
      '이 게이트웨이는 플러그인에 안정적인 키를 부여하지 않았습니다.';

  @override
  String get rel_ops_cap_error_the_plugin_was_not_changed =>
      '플러그인이 변경되지 않았습니다.';

  @override
  String get rel_ops_cap_error_choose_a_server => '서버를 선택하세요.';

  @override
  String get rel_ops_cap_error_name_the_server => '서버 이름을 지정하세요.';

  @override
  String get rel_ops_cap_error_give_the_server_a_command_or_an_http_s_url =>
      '서버에 명령 또는 http(s) URL을 지정하세요.';

  @override
  String get rel_ops_cap_error_choose_a_toolset => '도구 모음을 선택하세요.';

  @override
  String get rel_ops_cap_error_tool_backend_status_was_not_returned =>
      '도구 백엔드 상태가 반환되지 않았습니다.';

  @override
  String get rel_ops_cap_error_choose_a_provider => '제공업체를 선택하세요.';

  @override
  String get rel_ops_cap_error_this_provider_has_no_setup_action =>
      '이 제공업체에는 설정 작업이 없습니다.';

  @override
  String get rel_ops_cap_error_setup_did_not_start => '설정이 시작되지 않았습니다.';

  @override
  String get rel_ops_cap_error_choose_a_terminal_backend => '터미널 백엔드를 선택하세요.';

  @override
  String get rel_ops_cap_error_name_the_connector => '커넥터 이름을 지정하세요.';

  @override
  String get rel_ops_cap_error_choose_an_account => '계정을 선택하세요.';

  @override
  String
  get rel_ops_cap_error_reload_the_connector_policy_before_changing_tool_grants =>
      '도구 권한을 변경하기 전에 커넥터 정책을 새로고침하세요.';

  @override
  String get rel_ops_cap_error_choose_an_item => '항목을 선택하세요.';

  @override
  String get rel_ops_cap_error_choose_a_source => '소스를 선택하세요.';

  @override
  String get rel_ops_cap_error_enter_the_master_password => '마스터 비밀번호를 입력하세요.';

  @override
  String get rel_ops_cap_error_gateway_config_was_not_returned =>
      '게이트웨이 구성이 반환되지 않았습니다.';

  @override
  String get rel_ops_cap_error_choose_a_known_approval_mode =>
      '알려진 승인 모드를 선택하세요.';

  @override
  String get rel_ops_cap_error_use_a_positive_limit => '양수인 한도를 사용하세요.';

  @override
  String get rel_ops_cap_error_the_policy_was_not_saved => '정책이 저장되지 않았습니다.';

  @override
  String get rel_ops_cap_value_manual => '수동';

  @override
  String get rel_ops_cap_value_smart => '스마트';

  @override
  String get rel_ops_cap_value_off => '꺼짐';

  @override
  String get rel_ops_cap_value_safe => '안전';

  @override
  String get rel_ops_cap_value_caution => '주의';

  @override
  String get rel_ops_cap_value_dangerous => '위험';

  @override
  String get rel_ops_cap_value_blocked => '차단됨';

  @override
  String get rel_ops_cap_value_clean => '위협 없음';

  @override
  String get rel_ops_cap_value_ready => '준비됨';

  @override
  String get rel_ops_cap_value_available => '사용 가능';

  @override
  String get rel_ops_cap_value_unavailable => '사용 불가';

  @override
  String get rel_ops_cap_value_enabled => '활성화됨';

  @override
  String get rel_ops_cap_value_disabled => '비활성화됨';

  @override
  String get rel_ops_cap_value_active => '사용 중';

  @override
  String get rel_ops_cap_value_inactive => '사용하지 않음';

  @override
  String get rel_ops_cap_value_installed => '설치됨';

  @override
  String get rel_ops_cap_value_missing => '없음';

  @override
  String get rel_ops_cap_value_configured => '구성됨';

  @override
  String get rel_ops_cap_value_not_configured => '구성되지 않음';

  @override
  String get rel_ops_cap_value_error => '오류';

  @override
  String get rel_ops_cap_value_unknown => '알 수 없음';

  @override
  String get rel_ops_cap_value_login => '로그인 정보';

  @override
  String get rel_ops_cap_value_address => '주소';

  @override
  String get rel_ops_cap_value_payment => '결제';

  @override
  String get rel_ops_term_connecting => '연결 중…';

  @override
  String get rel_ops_term_unbound =>
      '일치하는 활성 세션이나 호스트 작업 디렉터리가 없습니다. 먼저 해당 채팅을 여세요.';

  @override
  String get rel_ops_term_unsupported =>
      '이 게이트웨이는 이 터미널 기능을 제공하지 않습니다. 로컬 셸은 시작되지 않았습니다.';

  @override
  String get rel_ops_term_local_pty_unavailable =>
      '포함된 로컬 PTY를 이 기기에서 사용할 수 없습니다.';

  @override
  String get rel_ops_term_operation_failed =>
      '터미널을 열거나 제어할 수 없습니다. 호스트, 인증 정보, 지문을 확인하세요. 대체 셸은 시작되지 않았습니다.';

  @override
  String get rel_ops_term_input_refused => '입력이 거부되었습니다. 원래 채팅을 다시 여세요.';

  @override
  String get rel_ops_term_cancel => '취소';

  @override
  String get rel_ops_term_confirm => '확인';

  @override
  String get rel_ops_term_open_device_title => '이 기기에서 셸을 열까요?';

  @override
  String get rel_ops_term_ssh_shell => 'SSH 셸';

  @override
  String get rel_ops_term_local_shell => '로컬 셸';

  @override
  String get rel_ops_term_connection_lost => '연결이 끊어졌습니다';

  @override
  String get rel_ops_term_shell_ended => '셸이 종료되었습니다';

  @override
  String get rel_ops_term_no_owner =>
      '이 채팅에는 인증된 게이트웨이 터미널 소유자가 없습니다. URL이나 클라우드 로그인만으로는 셸 액세스 권한이 부여되지 않습니다.';

  @override
  String get rel_ops_term_open_gateway_title => '게이트웨이 셸을 열까요?';

  @override
  String get rel_ops_term_shell_expired => '셸이 종료되었거나 만료되었습니다';

  @override
  String get rel_ops_term_disconnected => '연결 해제됨';

  @override
  String get rel_ops_term_gateway_shell => '게이트웨이 셸';

  @override
  String get rel_ops_term_close_body => '이 셸을 종료합니다. 계속 실행하려면 대신 창을 숨기세요.';

  @override
  String get rel_ops_term_closing => '닫는 중…';

  @override
  String get rel_ops_term_close_unconfirmed => '닫힘이 확인되지 않았습니다';

  @override
  String get rel_ops_term_processes_require_chat =>
      '에이전트 프로세스에는 인증된 해당 채팅이 필요합니다.';

  @override
  String get rel_ops_term_watching_processes =>
      '이 채팅의 에이전트 프로세스를 모니터링하고 있습니다. 미러 보기를 닫아도 해당 프로세스는 중지되지 않습니다.';

  @override
  String get rel_ops_term_paste_limit => '붙여넣기는 16 KiB로 제한됩니다.';

  @override
  String get rel_ops_term_paste => '붙여넣기';

  @override
  String get rel_ops_term_select_first => '먼저 터미널 출력을 선택하세요.';

  @override
  String get rel_ops_term_open_chat_to_insert => '출력을 삽입하기 전에 원래 채팅을 여세요.';

  @override
  String get rel_ops_term_added_to_draft => '원래 채팅의 초안에 추가했습니다. 전송된 내용은 없습니다.';

  @override
  String get rel_ops_term_close => '닫기';

  @override
  String get rel_ops_term_add_selection => '선택 항목을 채팅 초안에 추가';

  @override
  String get rel_ops_term_new_terminal => '새 터미널';

  @override
  String get rel_ops_term_gateway_terminal => '게이트웨이 호스트 터미널';

  @override
  String get rel_ops_term_verified_ssh_terminal => '검증된 SSH 터미널';

  @override
  String get rel_ops_term_device_local_shell => '이 기기 (로컬 셸)';

  @override
  String get rel_ops_term_local_unavailable_mobile => '모바일에서는 로컬 셸을 사용할 수 없습니다';

  @override
  String get rel_ops_term_watch_processes => '에이전트 프로세스 모니터링';

  @override
  String get rel_ops_term_select_output => '출력 선택 또는 복사';

  @override
  String get rel_ops_term_add_selected_output => '선택한 출력을 채팅 초안에 추가';

  @override
  String get rel_ops_term_review_paste => '클립보드 붙여넣기 검토';

  @override
  String get rel_ops_term_reconnect => '동일한 셸에 다시 연결';

  @override
  String get rel_ops_term_close_mirror => '미러 보기 닫기';

  @override
  String get rel_ops_term_close_shell => '셸 닫기';

  @override
  String get rel_ops_term_empty => '+를 선택하여 터미널을 여세요. 셸은 자동으로 시작되지 않습니다.';

  @override
  String get rel_ops_term_reason_stale => '오래된 상태';

  @override
  String get rel_ops_term_reason_mismatch => '불일치';

  @override
  String get rel_ops_term_reason_unbound => '연결 대상 없음';

  @override
  String get rel_ops_term_reason_unsupported => '지원되지 않음';

  @override
  String get rel_ops_term_reason_denied => '거부됨';

  @override
  String get rel_ops_term_reason_ineligible => '자격 없음';

  @override
  String get rel_ops_term_reason_unavailable => '사용할 수 없음';

  @override
  String get rel_ops_term_reason_invalid => '유효하지 않음';

  @override
  String get rel_ops_term_reason_insecure => '안전하지 않음';

  @override
  String rel_ops_term_refused(String reason) {
    return '게이트웨이가 이 터미널 작업을 거부했습니다 ($reason).';
  }

  @override
  String rel_ops_term_open_device_body(String connection) {
    return '이것은 $connection이(가) 아닌 Ares 기기입니다. 셸은 앱 권한을 사용하며 앱 저장소에서 시작됩니다.';
  }

  @override
  String rel_ops_term_open_gateway_body(String host) {
    return '$host에서 채팅의 검증된 작업 디렉터리에 셸을 시작합니다. 기기 셸이 아닙니다.';
  }

  @override
  String rel_ops_term_close_tab_title(String label) {
    return '$label을(를) 닫을까요?';
  }

  @override
  String rel_ops_term_read_only_status(String status) {
    return '읽기 전용 · $status';
  }

  @override
  String rel_ops_term_paste_title(String label) {
    return '$label에 붙여넣을까요?';
  }

  @override
  String rel_ops_term_output_title(String label) {
    return '출력 · $label';
  }

  @override
  String rel_ops_term_mirror_status(String label) {
    return '읽기 전용 프로세스 미러 · $label';
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
    return '이 기기 · $number';
  }

  @override
  String rel_ops_term_gateway_tab(String host, int number) {
    return '게이트웨이 $host · $number';
  }

  @override
  String get rel_ops_term_earlier_output_trimmed => '[이전 출력이 잘렸습니다]';

  @override
  String get rel_ops_term_ssh_dialog_title => '검증된 SSH 터미널 열기';

  @override
  String get rel_ops_term_ssh_dialog_body =>
      '호스트 관리자로부터 독립적인 경로로 얻은 지문을 사용하세요. 게이트웨이나 로컬 셸이 아닌 새 원격 로그인 세션을 엽니다.';

  @override
  String get rel_ops_term_ssh_host => 'SSH 호스트';

  @override
  String get rel_ops_term_ssh_port => '포트';

  @override
  String get rel_ops_term_ssh_user => '사용자';

  @override
  String get rel_ops_term_ssh_fingerprint => '호스트 키 지문 (SHA256:…)';

  @override
  String get rel_ops_term_ssh_password => 'SSH 비밀번호 (저장되지 않음)';

  @override
  String get rel_ops_term_connect => '연결';

  @override
  String get rel_ops_ssh_invalid_destination =>
      'SSH 호스트, 포트 또는 사용자가 올바르지 않습니다.';

  @override
  String get rel_ops_ssh_public_key_required =>
      'OpenSSH Ed25519 형식의 호스트 공개 키가 필요합니다.';

  @override
  String get rel_ops_ssh_invalid_public_key => 'Ed25519 호스트 키가 올바르지 않습니다.';

  @override
  String get rel_ops_ssh_invalid_saved_key => '저장된 호스트 키가 올바르지 않습니다.';

  @override
  String get rel_ops_ssh_enrollment_unverified => '호스트 키 등록을 검증할 수 없습니다.';

  @override
  String get rel_ops_ssh_different_key_pinned =>
      '다른 키가 이미 고정되어 있습니다. 변경 사항을 별도로 검증하세요.';

  @override
  String get rel_ops_ssh_open_ssh_unavailable => '시스템 OpenSSH를 사용할 수 없습니다.';

  @override
  String get rel_ops_ssh_confirm_host_key => '연결하기 전에 호스트 키를 확인하세요.';

  @override
  String get rel_ops_ssh_absolute_identity_required =>
      '절대 경로로 지정된 인증 키 파일을 선택하세요.';

  @override
  String get rel_ops_ssh_invalid_remote_port => '원격 포트가 올바르지 않습니다.';

  @override
  String get rel_ops_ssh_preview_too_large => '미리보기가 64 KiB 제한을 초과합니다.';

  @override
  String get rel_ops_ssh_connection_refused =>
      'SSH 연결이 거부되었습니다. 등록된 호스트 키, 인증 정보 및 서비스를 확인하세요.';

  @override
  String get rel_ops_ssh_http_not_ok => '원격 서비스가 HTTP 200을 반환하지 않았습니다.';

  @override
  String get rel_ops_ssh_encoded_response => '이 미리보기는 인코딩된 응답을 지원하지 않습니다.';

  @override
  String get rel_ops_ssh_preview_type_unsupported =>
      '텍스트와 HTML 소스만 미리 볼 수 있습니다.';

  @override
  String get rel_ops_ssh_health_unconfirmed =>
      '서비스가 게이트웨이의 정상 작동 상태를 확인해 주지 않았습니다.';

  @override
  String get rel_ops_ssh_enroll_host_key_first => '먼저 호스트의 공개 키를 등록하세요.';

  @override
  String get rel_ops_ssh_cancel => '취소';

  @override
  String get rel_ops_ssh_confirm => '확인';

  @override
  String get rel_ops_ssh_pin_title => '이 SSH 호스트 키를 고정하시겠습니까?';

  @override
  String rel_ops_ssh_pin_detail(String destination, String fingerprint) {
    return '$destination\n$fingerprint\n독립적인 채널을 통해 호스트 관리자와 이 지문을 대조하세요. 연결은 이루어지지 않습니다.';
  }

  @override
  String get rel_ops_ssh_host_key_pinned => '호스트 키가 고정되었습니다.';

  @override
  String get rel_ops_ssh_shell_detail => '대화형 로그인 셸을 엽니다.';

  @override
  String rel_ops_ssh_read_detail(String path, int port) {
    return 'SSH 채널을 통해 원격 127.0.0.1:$port의 $path를 읽습니다.';
  }

  @override
  String rel_ops_ssh_connect_title(String destination) {
    return '$destination에 연결하시겠습니까?';
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
  String get rel_ops_ssh_agent_auth => 'SSH 에이전트로 인증합니다.';

  @override
  String get rel_ops_ssh_identity_auth => '선택한 인증 키 파일을 사용합니다.';

  @override
  String rel_ops_ssh_gateway_responding(int port) {
    return '게이트웨이가 원격 루프백 포트 $port에서 응답하고 있습니다.';
  }

  @override
  String get rel_ops_ssh_session_closed => 'SSH 세션이 닫혔습니다.';

  @override
  String get rel_ops_ssh_session_unclean => 'SSH 세션이 정상적으로 종료되지 않았습니다.';

  @override
  String get rel_ops_ssh_operation_failed =>
      'SSH 작업에 실패했습니다. 대상과 인증 정보를 확인하세요.';

  @override
  String get rel_ops_ssh_title => '검증된 SSH';

  @override
  String get rel_ops_ssh_unsupported =>
      '이 기기에는 지원되는 시스템 OpenSSH 전송 수단이 없습니다. 고정된 게이트웨이 릴레이는 새 키를 자동으로 수락하므로 검증된 등록에 사용할 수 없습니다.';

  @override
  String get rel_ops_ssh_host => 'SSH 호스트';

  @override
  String get rel_ops_ssh_port => 'SSH 포트';

  @override
  String get rel_ops_ssh_user => 'SSH 사용자';

  @override
  String get rel_ops_ssh_identity => '인증 키 파일(선택 사항, 지정하지 않으면 SSH 에이전트 사용)';

  @override
  String get rel_ops_ssh_public_key => '관리자가 제공한 호스트 공개 키(ssh-ed25519)';

  @override
  String get rel_ops_ssh_review_key => '호스트 키 검토';

  @override
  String get rel_ops_ssh_remote_port => '원격 루프백 서비스 포트';

  @override
  String get rel_ops_ssh_check_gateway => 'SSH로 게이트웨이 확인';

  @override
  String get rel_ops_ssh_preview_source => 'SSH로 소스 미리보기';

  @override
  String get rel_ops_ssh_open_shell => 'SSH 셸 열기';

  @override
  String get rel_ops_ssh_shell_line => '원격 셸로 보낼 줄';

  @override
  String get rel_ops_ssh_disconnect => '셸 연결 해제';

  @override
  String get rel_ops_host_cancel => '취소';

  @override
  String get rel_ops_host_confirm => '확인';

  @override
  String get rel_ops_host_title => '호스트';

  @override
  String get rel_ops_host_refresh => '새로고침';

  @override
  String get rel_ops_host_update => '원격 Hermes 업데이트';

  @override
  String rel_ops_host_update_confirmation(String profile) {
    return '$profile의 게이트웨이 호스트에서 기존 설치를 업데이트합니다. 이 기기의 Ares는 업데이트되지 않습니다. 성공 여부는 일치하는 업데이트 처리 기록으로 확인하며, 호스트에 계속 연결할 수 있다는 것만으로는 성공을 의미하지 않습니다.';
  }

  @override
  String get rel_ops_host_update_awaiting =>
      '일치하는 처리 기록을 기다리는 중입니다. 업데이트가 아직 실행 중입니다.';

  @override
  String get rel_ops_host_receipt_success => '업데이트 처리 기록에 성공으로 표시되어 있습니다.';

  @override
  String get rel_ops_host_receipt_partial => '업데이트가 적용되었지만 후속 단계가 아직 남아 있습니다.';

  @override
  String get rel_ops_host_receipt_failed => '업데이트 처리 기록에 실패로 표시되어 있습니다.';

  @override
  String get rel_ops_host_receipt_refused => '업데이트 처리 기록에 거부로 표시되어 있습니다.';

  @override
  String get rel_ops_host_update_running => '업데이트가 아직 실행 중입니다.';

  @override
  String get rel_ops_host_update_unknown =>
      '업데이트 결과를 알 수 없습니다. 게이트웨이가 실행 중이라고 해서 업데이트가 성공한 것은 아닙니다.';

  @override
  String get rel_ops_host_default_profile => '게이트웨이 기본 프로필';

  @override
  String get rel_ops_host_restart => '원격 게이트웨이 다시 시작';

  @override
  String rel_ops_host_restart_shared_confirmation(String profiles) {
    return '$profiles에서 공유하는 게이트웨이를 다시 시작합니다. 이 게이트웨이에서 진행 중인 턴이 중단됩니다. 이후 다시 연결하세요. 연결할 수 있다는 것만으로 다시 시작이 완료되었다고 볼 수는 없습니다.';
  }

  @override
  String rel_ops_host_restart_confirmation(String profile) {
    return '$profile의 원격 게이트웨이를 다시 시작합니다. 이 게이트웨이에서 진행 중인 턴이 중단됩니다. 이후 다시 연결하세요.';
  }

  @override
  String get rel_ops_host_restart_running => '다시 시작 명령이 아직 실행 중입니다.';

  @override
  String get rel_ops_host_restart_finished =>
      '다시 시작 명령이 완료되었습니다. 호스트에 직접 다시 연결하세요.';

  @override
  String get rel_ops_host_restart_failed => '다시 시작 명령이 실패했습니다.';

  @override
  String rel_ops_host_maintenance_running(String name) {
    return '$name이(가) 아직 실행 중입니다';
  }

  @override
  String rel_ops_host_maintenance_finished(String name) {
    return '$name 완료';
  }

  @override
  String rel_ops_host_maintenance_failed(String name) {
    return '$name 실패';
  }

  @override
  String get rel_ops_host_curator_paused_result => '큐레이터가 일시 중지되었습니다.';

  @override
  String get rel_ops_host_curator_resumed_result => '큐레이터가 재개되었습니다.';

  @override
  String get rel_ops_host_reset => '원격 메모리 파일 초기화';

  @override
  String rel_ops_host_reset_confirmation(String targetName, String profile) {
    return '$profile의 $targetName 메모리 파일을 삭제할까요? Ares에서는 이 작업을 되돌릴 수 없습니다.';
  }

  @override
  String rel_ops_host_reset_result(String targetName, int count) {
    return '$targetName을(를) 초기화했습니다. 원격 파일 $count개를 삭제했습니다.';
  }

  @override
  String get rel_ops_host_share_not_redacted =>
      '호스트에서 진단 묶음의 민감 정보가 가려졌는지 확인하지 않았습니다. 링크가 표시되지 않습니다.';

  @override
  String rel_ops_host_scope(String connection, String profile) {
    return '이 컨트롤은 $profile의 원격 게이트웨이 $connection을(를) 조작합니다. 이 기기나 Ares 클라이언트 업데이트에는 적용되지 않습니다.';
  }

  @override
  String rel_ops_host_health_running(String version, int count) {
    return '게이트웨이 프로세스 실행 중 $version · 세션 $count개';
  }

  @override
  String rel_ops_host_health_stopped(String version, int count) {
    return '게이트웨이 프로세스 중지됨 $version · 세션 $count개';
  }

  @override
  String rel_ops_host_heartbeat_stale(num seconds) {
    return '호스트의 하트비트가 오래되었습니다($seconds초).';
  }

  @override
  String get rel_ops_host_doctor => 'Doctor 실행';

  @override
  String get rel_ops_host_security_audit => '보안 감사';

  @override
  String get rel_ops_host_check_receipt => '업데이트 처리 기록 확인';

  @override
  String get rel_ops_host_logs => '원격 호스트 로그';

  @override
  String get rel_ops_host_search_logs => '호스트 로그 검색';

  @override
  String get rel_ops_host_driver => '원격 호스트 드라이버';

  @override
  String get rel_ops_host_driver_scope =>
      '컴퓨터 제어 준비 상태는 이 기기가 아니라 게이트웨이 컴퓨터의 드라이버 및 운영 체제 권한에 관한 것입니다.';

  @override
  String rel_ops_host_computer_status(
    String platform,
    String installed,
    String ready,
  ) {
    return '$platform · 설치됨 $installed · 준비됨 $ready';
  }

  @override
  String get rel_ops_host_null => '확인 불가';

  @override
  String get rel_ops_host_true => '예';

  @override
  String get rel_ops_host_false => '아니요';

  @override
  String get rel_ops_host_curator => '큐레이터';

  @override
  String get rel_ops_host_curator_paused => '큐레이터 일시 중지됨';

  @override
  String get rel_ops_host_curator_running => '큐레이터 실행 중';

  @override
  String get rel_ops_host_no_run => '완료된 실행 없음';

  @override
  String get rel_ops_host_run_curator => '지금 큐레이터 실행';

  @override
  String get rel_ops_host_reset_memory => '메모리 파일 초기화';

  @override
  String get rel_ops_host_reset_user => '사용자 파일 초기화';

  @override
  String get rel_ops_host_reset_both => '두 파일 모두 초기화';

  @override
  String get rel_ops_host_share_consent =>
      '원격 호스트에서 민감 정보를 가린 진단 묶음을 업로드하는 데 동의합니다';

  @override
  String get rel_ops_host_share => '민감 정보를 가린 진단 정보 공유';

  @override
  String get rel_ops_host_update_unknown_installation =>
      '이 설치를 식별할 수 없어 업데이트를 보내지 않았습니다';

  @override
  String get rel_ops_host_update_busy_installation => '이 설치에서 채팅이 실행 중입니다';

  @override
  String get rel_ops_host_update_refused => '원격 업데이트 거부됨';

  @override
  String get rel_ops_host_error_stale => '원격 작업 공간: 오래된 상태';

  @override
  String get rel_ops_host_error_mismatch => '원격 작업 공간: 불일치';

  @override
  String get rel_ops_host_error_unbound => '원격 작업 공간: 연결 대상 미지정';

  @override
  String get rel_ops_host_error_unsupported => '원격 작업 공간: 지원되지 않음';

  @override
  String get rel_ops_host_error_denied => '원격 작업 공간: 접근 거부됨';

  @override
  String get rel_ops_host_error_ineligible => '원격 작업 공간: 작업 대상 부적격';

  @override
  String get rel_ops_host_error_unavailable => '원격 작업 공간: 사용 불가';

  @override
  String get rel_ops_host_error_invalid => '원격 작업 공간: 유효하지 않음';

  @override
  String get rel_ops_host_error_insecure => '원격 작업 공간: 안전하지 않음';

  @override
  String get rel_ops_host_error_request => '요청을 완료하지 못했습니다.';

  @override
  String get rel_svc_push_api_select_sessions =>
      '영구 세션 ID를 1~128개 선택하세요. 각 ID는 1~200자의 ASCII로, 문자, 숫자, _ . : @ 또는 -만 사용할 수 있습니다. 빈 ID와 공백을 제거하세요.';

  @override
  String get rel_svc_push_api_unavailable => '이 서버에서는 모바일 푸시를 사용할 수 없습니다.';

  @override
  String get rel_svc_push_api_invalid_vapid => '서버 VAPID 공개 키가 올바르지 않습니다.';

  @override
  String get rel_svc_push_api_update_plugin =>
      '자동 구독을 사용하려면 이 서버의 mobile-push 플러그인을 업데이트해야 합니다.';

  @override
  String get rel_svc_push_status_android_only => 'Android 전용';

  @override
  String get rel_svc_push_native_prefs_sync_failed =>
      '네이티브 알림 환경설정을 동기화할 수 없습니다.';

  @override
  String get rel_svc_push_choose_android_connection =>
      '먼저 Android에서 저장된 연결을 선택하세요.';

  @override
  String get rel_svc_push_status_checking_authorization => '서버 권한 확인 중';

  @override
  String get rel_svc_push_revoke_persist_failed =>
      '철회를 저장할 수 없습니다. 앱을 종료하기 전에 다시 비활성화하세요.';

  @override
  String get rel_svc_push_status_off_api_ready => '꺼짐, 서버 API 준비됨';

  @override
  String get rel_svc_push_status_off_revoke_pending => '꺼짐, 서버 철회 대기 중';

  @override
  String get rel_svc_push_status_off_connection_changed => '꺼짐, 저장된 연결 변경됨';

  @override
  String get rel_svc_push_status_pending_endpoint => '배포자 엔드포인트 대기 중';

  @override
  String get rel_svc_push_status_registering => '등록 중';

  @override
  String get rel_svc_push_status_pending_challenge =>
      '암호화된 챌린지 대기 중(자동 서버 확인 푸시 대기 중)';

  @override
  String get rel_svc_push_allow_android_notifications_retry =>
      '시스템 설정에서 Android 알림을 허용한 다음 다시 시도하세요.';

  @override
  String get rel_svc_push_plugin_invalid =>
      '서버 mobile-push 플러그인을 사용할 수 없거나 오래되었거나 잘못된 구독 응답을 반환했습니다. 운영자에게 업데이트를 요청한 다음 다시 시도하세요.';

  @override
  String get rel_svc_push_transport_unavailable =>
      '사용 가능한 푸시 전송 수단이 없습니다. 기본 제공 전송에는 정상 작동하는 Google Play 서비스가 필요합니다. 또는 UnifiedPush 배포자를 설치한 후 다시 시도하세요.';

  @override
  String get rel_svc_push_transport_choice =>
      '여러 UnifiedPush 배포자를 사용할 수 있습니다. 고급 전송에서 하나를 선택한 후 다시 시도하세요.';

  @override
  String get rel_svc_push_transport_missing =>
      '선택한 UnifiedPush 배포자를 사용할 수 없습니다. 복원하거나 고급 전송에서 다른 배포자를 선택하세요.';

  @override
  String get rel_svc_push_companion_unavailable =>
      '서버 mobile-push 컴패니언을 사용할 수 없습니다. 설치되지 않았거나 비활성화되었거나 이 연결이 잘못된 대시보드를 가리킬 수 있습니다. 서버에서 컴패니언을 설치 또는 활성화하고 대시보드 연결을 확인한 다음 새로 고치세요. 위의 서버 설정 가이드를 참조하세요.';

  @override
  String get rel_svc_push_server_denied =>
      '서버가 모바일 푸시를 거부했습니다. 운영자에게 이 주체와 세션을 승인해 달라고 요청하세요.';

  @override
  String get rel_svc_push_not_ready =>
      '모바일 푸시가 준비되지 않았습니다. 서버 플러그인 권한, 배포자, 네트워크를 확인한 후 다시 시도하세요.';

  @override
  String get rel_svc_push_availability_read_failed =>
      'Android 푸시 사용 가능 여부를 확인할 수 없습니다. 아래에서 다시 시도하세요.';

  @override
  String get rel_svc_push_setup_failed =>
      '푸시 설정에 실패했습니다. Android 권한, 서버 권한 및 전송 수단을 확인한 후 다시 시도하세요.';

  @override
  String rel_svc_push_status(String status) {
    return '상태: $status';
  }

  @override
  String rel_svc_push_status_bound(
    String bound,
    String connection,
    String status,
  ) {
    return '상태: $bound에 바인딩됨($connection에는 비활성, 핸드셰이크: $status)';
  }

  @override
  String get rel_svc_push_another_saved_connection => '다른 저장된 연결';

  @override
  String get rel_svc_push_background_notifications => '백그라운드 알림';

  @override
  String rel_svc_push_bound_subtitle(String bound, String connection) {
    return '$bound에 바인딩됨 — $connection에 사용 설정하기 전에 아래에서 이 바인딩을 철회하세요';
  }

  @override
  String rel_svc_push_private_activity(String connection) {
    return '$connection의 비공개 서버 활동';
  }

  @override
  String rel_svc_push_bound_warning_named(String bound) {
    return '다른 저장된 연결($bound)에 바인딩되어 있습니다. 이 연결에 사용 설정하기 전에 해당 바인딩을 비활성화하고 철회하세요.';
  }

  @override
  String get rel_svc_push_bound_warning =>
      '다른 저장된 연결에 바인딩되어 있습니다. 이 연결에 사용 설정하기 전에 해당 바인딩을 비활성화하고 철회하세요.';

  @override
  String get rel_svc_push_local_notifications_muted =>
      '위에서 로컬 알림이 꺼져 있습니다. 백그라운드 알림 동의는 유지되지만 \"알림 사용\"을 켤 때까지 일반 백그라운드 활동 알림은 음소거됩니다.';

  @override
  String rel_svc_push_legacy_subscription(int count) {
    return '레거시 구독: 선택된 세션 $count개만 포함됩니다. 자동으로 확장되지 않습니다. 서버 승인 세션에 동의하려면 껐다가 다시 켜세요.';
  }

  @override
  String get rel_svc_push_authorized_binding =>
      '이 저장된 연결과 프로필에만 바인딩됩니다. 세션 액세스는 현재 서버 권한을 따릅니다.';

  @override
  String get rel_svc_push_revocation_pending =>
      '서버 철회 대기 중입니다. 로컬 전송은 꺼져 있습니다. 원래 저장된 로그인을 사용할 수 있을 때 다시 시도하세요.';

  @override
  String get rel_svc_push_refresh_retry => '새로고침 / 다시 시도';

  @override
  String rel_svc_push_disable_named(String bound) {
    return '$bound 비활성화 및 철회';
  }

  @override
  String get rel_svc_push_other_connection => '다른 연결';

  @override
  String get rel_svc_push_disable => '비활성화 및 철회';

  @override
  String get rel_svc_push_refresh_explanation =>
      '새로고침 / 다시 시도는 서버 설정 후 사용 가능 여부를 다시 확인하지만 컴패니언을 설치할 수는 없습니다. 알림 활성화는 별도의 선택입니다.';

  @override
  String get rel_svc_push_companion_required =>
      '백그라운드 알림에는 서버 측 mobile-push 컴패니언을 별도로 설치하고 활성화해야 합니다. Android에서는 설치할 수 없습니다. APK 업데이트만으로는 서버가 설정되지 않습니다.';

  @override
  String get rel_svc_push_server_setup_guide => '서버 설정 가이드';

  @override
  String get rel_svc_push_enable_disclosure =>
      '사용 설정하면 Android 알림 권한을 요청하고 이 설치의 엔드포인트와 암호화 키를 이 서버와 공유합니다. 암호화된 활동 알림에는 채팅 내용이 포함되지 않습니다. 서버 로그인으로 승인된 세션만 포함됩니다.';

  @override
  String get rel_svc_push_transport_disclosure =>
      '기본 제공 전송은 Google 푸시 전송과 Google Play 서비스를 사용하지만 Firebase SDK는 포함하지 않습니다. 대신 선택적 UnifiedPush 배포자를 사용할 수 있습니다. 전송은 최선형이며 Hermes를 다시 열어 조정하세요.';

  @override
  String get rel_svc_push_advanced_transport => '고급 전송';

  @override
  String get rel_svc_push_automatic_explanation =>
      '자동은 기존 배포자 선택을 유지하고, 없으면 사용 가능한 기본 제공 Google 전송을 사용합니다. 전송을 변경하기 전에 비활성화하세요.';

  @override
  String get rel_svc_push_transport_label => '푸시 전송';

  @override
  String get rel_svc_push_automatic_recommended => '자동(권장)';

  @override
  String get rel_svc_push_selected_unavailable => '선택한 배포자(사용 불가)';

  @override
  String get rel_svc_push_no_transport_detected =>
      '사용 가능한 전송 수단이 감지되지 않았습니다. 기본 제공 전송에는 Google Play 서비스가 필요합니다. 없다면 UnifiedPush 배포자를 설치하고 구성한 후 새로 고치세요.';

  @override
  String get rel_svc_push_channel_turns_name => 'Ares 턴';

  @override
  String get rel_svc_push_channel_turns_description => '백그라운드에서 완료된 턴 알림';

  @override
  String get rel_svc_push_channel_attention_name => 'Ares 주의 필요';

  @override
  String get rel_svc_push_channel_attention_description =>
      '사용자가 필요한 승인 및 입력 요청';

  @override
  String get rel_svc_push_channel_background_name => 'Ares 백그라운드';

  @override
  String get rel_svc_push_channel_background_description => '백그라운드 작업 완료';

  @override
  String get rel_svc_push_channel_notices_name => 'Ares 알림';

  @override
  String get rel_svc_push_channel_notices_description => '크레딧 및 플러그인 알림';

  @override
  String get rel_svc_push_diag_not_initialised => '초기화되지 않음';

  @override
  String get rel_svc_push_diag_replies_off => '답변 알림이 꺼져 있음';

  @override
  String get rel_svc_push_diag_conversation => '대화';

  @override
  String get rel_svc_push_diag_conversation_permission_denied => '대화, 권한 거부됨';

  @override
  String rel_svc_push_diag_conversation_error(String error) {
    return '대화: $error';
  }

  @override
  String get rel_svc_push_diag_failures_off => '실패 알림이 꺼져 있음';

  @override
  String rel_svc_push_diag_kind_off(String kind) {
    return '$kind 꺼짐';
  }

  @override
  String get rel_svc_push_diag_windows_setting_unknown =>
      'Windows에서 알림 설정을 보고하지 않음';

  @override
  String get rel_svc_backup_not_hermes_configuration_backup =>
      '이 파일은 Hermes 구성 백업이 아닙니다.';

  @override
  String get rel_svc_backup_newer_version_cannot_import =>
      '이 백업은 더 최신 버전의 앱에서 만들어져 가져올 수 없습니다.';

  @override
  String get rel_svc_backup_missing_client_certificate =>
      '이 백업은 연결의 클라이언트 인증서를 지정하지만 포함하고 있지 않아 완전히 복원할 수 없습니다.';

  @override
  String get rel_svc_backup_damaged_unreadable => '이 백업 파일은 손상되어 읽을 수 없습니다.';

  @override
  String get rel_svc_backup_unsupported_preference_type =>
      '저장된 환경설정의 형식이 지원되지 않아 내보낼 수 없습니다.';

  @override
  String get rel_svc_backup_choose_passphrase_api_keys =>
      '암호를 선택하세요. 백업에 API 키가 포함되어 있습니다.';

  @override
  String get rel_svc_backup_could_not_protect_safely => '백업을 안전하게 보호할 수 없습니다.';

  @override
  String get rel_svc_backup_unsupported_encryption =>
      '이 백업은 지원되지 않는 암호화 방식을 사용합니다.';

  @override
  String get rel_svc_backup_wrong_passphrase_or_altered =>
      '암호가 잘못되었거나 이 백업 파일이 변경되었습니다.';

  @override
  String get rel_svc_backup_share_subject => 'Hermes 구성 백업';

  @override
  String get rel_svc_backup_selected_file_unreadable => '해당 파일을 읽을 수 없습니다.';

  @override
  String rel_svc_backup_connections_added(int count) {
    return '$count개 추가됨';
  }

  @override
  String rel_svc_backup_connections_updated(int count) {
    return '$count개 업데이트됨';
  }

  @override
  String rel_svc_backup_connections_removed(int count) {
    return '$count개 삭제됨';
  }

  @override
  String get rel_svc_backup_no_connection_changes => '연결 변경 없음';

  @override
  String rel_svc_backup_connections_summary(String changes) {
    return '연결: $changes';
  }

  @override
  String rel_svc_backup_restore_summary(String connections, int count) {
    return '$connections · 설정 $count개 복원됨';
  }

  @override
  String rel_svc_backup_certificate_not_included(String label, String error) {
    return '\"$label\"의 클라이언트 인증서를 이 백업에 포함할 수 없습니다: $error';
  }

  @override
  String get rel_svc_backup_certificate_password_needed =>
      '이 인증서에는 암호가 필요합니다. 아래에 입력하면 자동으로 열립니다.';

  @override
  String get rel_svc_backup_certificate_password_or_corrupt =>
      '인증서 암호가 잘못되었거나 파일이 손상되었습니다.';

  @override
  String get rel_svc_backup_certificate_password_incorrect =>
      '인증서 암호가 잘못되었습니다.';

  @override
  String get rel_svc_backup_certificate_unsupported_encryption =>
      '이 인증서는 앱에서 읽을 수 없는 암호화 방식을 사용합니다.';

  @override
  String get rel_svc_backup_certificate_unreadable_pkcs12 =>
      '선택한 파일은 읽을 수 있는 PKCS#12(.p12/.pfx) 인증서가 아닙니다.';

  @override
  String get rel_svc_backup_certificate_unreadable => '선택한 인증서를 읽을 수 없습니다.';

  @override
  String get rel_svc_backup_not_certificate_file =>
      '해당 파일은 인증서가 아닙니다. .p12/.pfx 컨테이너 또는 PEM 인증서와 키 파일을 선택하세요.';

  @override
  String get rel_svc_backup_not_pem_certificate => '선택한 인증서는 PEM 인증서가 아닙니다.';

  @override
  String get rel_svc_backup_not_pem_private_key => '선택한 개인 키는 PEM 개인 키가 아닙니다.';

  @override
  String get rel_svc_backup_certificate_pair_unloadable =>
      '선택한 인증서와 개인 키를 로드할 수 없습니다.';

  @override
  String get rel_svc_backup_saved_certificate_files_unreadable =>
      '저장된 클라이언트 인증서 파일을 읽을 수 없습니다.';

  @override
  String get rel_svc_backup_client_certificate_storage_failed =>
      '클라이언트 인증서를 이 기기에 안전하게 저장할 수 없습니다.';

  @override
  String get rel_svc_backup_certificate_storage_failed =>
      '인증서를 이 기기에 안전하게 저장할 수 없습니다.';

  @override
  String get rel_svc_backup_client_certificate_label => '클라이언트 인증서';

  @override
  String rel_svc_backup_search_dashboard_unreachable(String error) {
    return '대시보드에 연결할 수 없습니다: $error';
  }

  @override
  String get rel_svc_backup_search_credentials_rejected =>
      '대시보드가 저장된 자격 증명을 거부했습니다. 이 연결의 대시보드 사용자 이름과 암호를 확인하세요.';

  @override
  String get rel_svc_backup_search_not_supported =>
      '이 대시보드는 세션 검색을 제공하지 않습니다. 호스트의 Hermes를 업데이트하거나 기기 내 검색으로 전환하세요.';

  @override
  String rel_svc_backup_search_redirected(int statusCode) {
    return '대시보드가 세션 검색을 리디렉션했습니다(HTTP $statusCode). Ares는 저장된 자격 증명을 사용하는 리디렉션을 따르지 않습니다. 연결 주소를 확인하세요.';
  }

  @override
  String rel_svc_backup_search_http_failed(int statusCode) {
    return '세션 검색이 HTTP $statusCode(으)로 실패했습니다.';
  }

  @override
  String get rel_svc_backup_search_malformed_response =>
      '대시보드가 잘못된 형식의 검색 응답을 반환했습니다.';

  @override
  String get rel_svc_backup_search_unexpected_response =>
      '대시보드가 예상치 못한 검색 응답을 반환했습니다.';

  @override
  String get rel_svc_backup_search_too_many_results =>
      '대시보드가 요청한 것보다 많은 검색 결과를 반환했습니다.';

  @override
  String get rel_svc_backup_message_search_unexpected_response =>
      '예상치 못한 메시지 검색 응답입니다.';

  @override
  String get rel_svc_backup_message_search_unexpected_result =>
      '예상치 못한 메시지 검색 결과입니다.';

  @override
  String get rel_svc_backup_ai_search_api_key_rejected =>
      'Hermes API가 저장된 API 키를 거부했습니다.';

  @override
  String rel_svc_backup_ai_search_http_failed(int statusCode) {
    return 'AI 쿼리 재작성에 HTTP $statusCode 오류가 발생했습니다.';
  }

  @override
  String get rel_svc_backup_ai_search_no_usable_query =>
      '선택한 모델이 사용 가능한 검색 쿼리를 반환하지 않았습니다.';

  @override
  String get rel_svc_backup_ai_search_malformed_response =>
      'Hermes가 잘못된 형식의 AI 재작성 응답을 반환했습니다.';

  @override
  String get rel_svc_backup_space_name_already_exists => '이 이름의 스페이스가 이미 있습니다';

  @override
  String get rel_svc_backup_space_name_length_invalid => '스페이스 이름은 1~80자여야 합니다';

  @override
  String get ng_rel_svc_backup_gateway_address_required =>
      'Hermes 대시보드 주소를 입력하세요.';

  @override
  String ng_rel_svc_backup_gateway_address_scheme(String scheme) {
    return '주소는 http:// 또는 https://로 시작해야 합니다(입력: $scheme).';
  }

  @override
  String get ng_rel_svc_backup_gateway_address_invalid => '해당 주소가 올바르지 않습니다.';

  @override
  String get ng_rel_svc_backup_gateway_address_no_host => '주소에 호스트 이름이 없습니다.';

  @override
  String get ng_rel_svc_backup_sign_in_main_window => '기본 창에서 로그인하세요.';

  @override
  String get rel_svc_backup_sign_in_renewal_failed =>
      '게이트웨이가 지금 로그인을 갱신할 수 없습니다.';

  @override
  String get rel_svc_backup_sign_in_provider_unreachable =>
      '게이트웨이가 로그인을 갱신할 수 없습니다. 로그인 공급자에 연결할 수 없습니다.';

  @override
  String get rel_svc_backup_sign_in_renewal_timed_out => '로그인 갱신 시간이 초과되었습니다.';

  @override
  String get rel_svc_backup_sign_in_no_tokens => '게이트웨이가 로그인 토큰을 반환하지 않았습니다.';

  @override
  String get ng_rel_svc_backup_probe_timed_out =>
      '시간이 초과되었습니다. 주소, VPN 또는 Tailscale 연결을 확인하세요.';

  @override
  String ng_rel_svc_backup_probe_tls_failed(String error) {
    return 'TLS 핸드셰이크 실패: $error';
  }

  @override
  String ng_rel_svc_backup_gateway_answered_http(int statusCode) {
    return '게이트웨이가 HTTP $statusCode(으)로 응답했습니다.';
  }

  @override
  String get ng_rel_svc_backup_gateway_answer_timed_out =>
      '게이트웨이 응답이 너무 오래 걸렸습니다.';

  @override
  String ng_rel_svc_backup_browser_callback_not_ready(String error) {
    return '브라우저가 돌아올 준비를 할 수 없습니다: $error';
  }

  @override
  String get ng_rel_svc_backup_browser_signed_in_body => '이제 Hermes로 돌아가도 됩니다.';

  @override
  String get ng_rel_svc_backup_browser_waiting_title => '로그인 대기 중';

  @override
  String get ng_rel_svc_backup_browser_not_current =>
      '이 페이지는 현재 로그인에 속하지 않습니다.';

  @override
  String get ng_rel_svc_backup_browser_open_failed => '로그인할 브라우저를 열 수 없습니다.';

  @override
  String get ng_rel_svc_backup_browser_sign_in_timed_out =>
      '로그인 시간이 너무 오래 걸렸습니다. 다시 시도하세요.';

  @override
  String ng_rel_svc_backup_gateway_refused_sign_in(int statusCode) {
    return '게이트웨이가 로그인을 거부했습니다(HTTP $statusCode).';
  }

  @override
  String get rel_svc_misc_alert_caution => '주의';

  @override
  String get rel_svc_misc_alert_important => '중요';

  @override
  String get rel_svc_misc_alert_tip => '팁';

  @override
  String get rel_svc_misc_alert_warning => '경고';

  @override
  String get rel_svc_misc_allow_folder_session => '세션이 끝날 때까지 이 폴더를 허용합니다.';

  @override
  String get rel_svc_misc_allow_website_session => '세션이 끝날 때까지 이 웹사이트를 허용합니다.';

  @override
  String rel_svc_misc_approval_needed_title(String title) {
    return '승인 필요 — $title';
  }

  @override
  String get rel_svc_misc_attach_file_reference => '파일 참조 첨부';

  @override
  String get rel_svc_misc_attach_folder_reference => '폴더 참조 첨부';

  @override
  String get rel_svc_misc_attach_git_context => 'git 컨텍스트 첨부';

  @override
  String get rel_svc_misc_attach_image_reference => '이미지 참조 첨부';

  @override
  String get rel_svc_misc_attach_staged_diff => '스테이징된 diff 첨부';

  @override
  String get rel_svc_misc_attach_tool_reference => '도구 참조 첨부';

  @override
  String get rel_svc_misc_attach_unstaged_diff => '스테이징되지 않은 diff 첨부';

  @override
  String get rel_svc_misc_attach_url_reference => 'URL 참조 첨부';

  @override
  String get rel_svc_misc_background_task_completed => '백그라운드 작업 완료';

  @override
  String rel_svc_misc_background_task_named_completed(String taskId) {
    return '백그라운드 작업 $taskId 완료';
  }

  @override
  String get rel_svc_misc_chat => '채팅';

  @override
  String get rel_svc_misc_compacting_context => '대화 컨텍스트 압축 중…';

  @override
  String rel_svc_misc_completed_in(String duration) {
    return '$duration 만에 완료';
  }

  @override
  String get rel_svc_misc_context_compacted => '대화 컨텍스트 압축 완료';

  @override
  String get rel_svc_misc_cron_readback_mismatch => 'Cron 모델 다시 읽기가 일치하지 않았습니다';

  @override
  String get rel_svc_misc_cron_update_rejected => 'Cron 업데이트가 거부되었습니다';

  @override
  String get rel_svc_misc_deny_folder_grant => '이 폴더에 권한을 부여하지 않습니다.';

  @override
  String get rel_svc_misc_deny_website_grant => '이 웹사이트에 권한을 부여하지 않습니다.';

  @override
  String rel_svc_misc_failed_after(String duration) {
    return '$duration 후 실패';
  }

  @override
  String get rel_svc_misc_gateway_folder_unnamed => '게이트웨이가 폴더를 지정하지 않았습니다.';

  @override
  String get rel_svc_misc_gateway_idle_unconfirmed =>
      '게이트웨이가 유휴 상태입니다. 이전 턴의 결과를 확인할 수 없습니다.';

  @override
  String get rel_svc_misc_gateway_turn_failed => '게이트웨이 턴 실패';

  @override
  String rel_svc_misc_gateway_turn_status(String status) {
    return '게이트웨이 턴: $status';
  }

  @override
  String get rel_svc_misc_gateway_website_unnamed => '게이트웨이가 웹사이트를 지정하지 않았습니다.';

  @override
  String get rel_svc_misc_hermes_review => 'Hermes 검토';

  @override
  String get rel_svc_misc_hermes_turn_failed => 'Hermes 턴 실패';

  @override
  String get rel_svc_misc_image_recovery_companion_gap =>
      '컴패니언 복구에서는 이미지 및 텍스트 복구를 사용할 수 없습니다. 이 연결에서는 확인되지 않은 이미지 전송을 복원할 수 없으며 자동으로 다시 전송되지 않습니다.';

  @override
  String get rel_svc_misc_image_recovery_rest_gap =>
      'Classic REST/SSE에서는 이미지 및 텍스트 복구를 사용할 수 없습니다. 이 연결에서는 확인되지 않은 이미지 전송을 복원할 수 없으며 자동으로 다시 전송되지 않습니다.';

  @override
  String rel_svc_misc_input_needed_title(String title) {
    return '입력 필요 — $title';
  }

  @override
  String get rel_svc_misc_parallel_workspace_connection_changed =>
      '연결이 변경되었습니다. 작업 공간을 사용하려면 다시 여세요.';

  @override
  String get rel_svc_misc_preparing => '준비 중';

  @override
  String get rel_svc_misc_save_folder_grant =>
      '이 폴더 권한을 이후 요청에 사용할 수 있도록 저장합니다.';

  @override
  String get rel_svc_misc_save_website_grant =>
      '이 웹사이트 권한을 이후 요청에 사용할 수 있도록 저장합니다.';

  @override
  String get rel_svc_misc_stored_identity_turn_conflict =>
      '다른 턴이 허용된 동안 이 채팅이 저장된 ID를 통해 열렸습니다. 전송되지 않은 프롬프트는 보내지지 않았습니다. 해당 턴이 끝난 후 명시적으로 다시 시도하세요.';

  @override
  String get rel_svc_misc_untitled => '제목 없음';

  @override
  String get rel_svc_misc_wake_capture_silent =>
      '클라이언트 깨우기 캡처에서 무음만 감지됩니다. OS 마이크 접근 권한을 확인하고 깨우기 단어를 껐다가 다시 켜세요.';

  @override
  String get rel_svc_misc_wake_capture_stalled =>
      '클라이언트 깨우기 캡처가 멈췄습니다. 마이크 오디오 콜백이 도착하지 않았습니다.';

  @override
  String rel_svc_misc_wake_feed_refused(int count, String detail) {
    return '깨우기 단어 피드가 연속된 프레임 $count개를 거부했습니다$detail. 깨우기 단어를 껐다가 다시 켜세요.';
  }

  @override
  String rel_svc_misc_wake_microphone_failed(String error) {
    return '클라이언트 깨우기 마이크 스트림 실패: $error';
  }

  @override
  String get rel_svc_misc_wake_track_ended =>
      '깨우기 단어 캡처 중 마이크 트랙이 종료되었습니다. 깨우기 단어를 껐다가 다시 켜세요.';

  @override
  String get rel_svc_misc_website => '웹사이트';

  @override
  String get rel_svc_lan_timeout => 'LAN 검색 시간이 초과되었습니다';

  @override
  String get rel_svc_notification_permission_denied => '권한이 거부됨';

  @override
  String get rel_svc_notifications_off => '알림이 꺼져 있음';

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
  String get fleet_managed_ssh_title => '게이트웨이 관리 SSH';

  @override
  String get fleet_managed_ssh_intro =>
      '이 게이트웨이에 이미 저장된 SSH 호스트를 모든 기기에서 관리하세요. 원격 호스트에 Hermes가 이미 설치되어 있어야 합니다. 이 작업은 게이트웨이가 소유한 원격 서비스를 시작하거나 해당 서비스에 연결하며, Ares 채팅 연결이 아닙니다. 관리형 업데이트 및 복구는 네이티브 데스크톱 앱에서만 사용할 수 있습니다.';

  @override
  String get fleet_managed_ssh_read => '저장된 SSH 호스트 읽기';

  @override
  String get fleet_managed_ssh_trust =>
      '이 첫 연결에서 게이트웨이는 이 호스트의 SSH 키를 신뢰하고 기억합니다. 이후 키가 변경되면 이를 감지하고 연결을 차단합니다. 게이트웨이는 키 지문을 제공하지 않으므로 Ares는 이를 표시하거나 저장할 수 없습니다. 이 첫 연결을 신뢰하는 경우에만 계속하세요.';

  @override
  String get fleet_managed_ssh_changed =>
      '이 호스트의 SSH 키가 변경되었습니다. 연결이 차단되었습니다. 게이트웨이 호스트에 접근할 수 있는 사람이 새 키의 지문을 독립적으로 확인하고 해당 호스트에서 기존의 신뢰된 키를 제거해야 합니다. 확인 및 복구가 완료된 후에만 다시 시도하세요. Ares는 신뢰된 키를 교체하지 않습니다.';

  @override
  String get fleet_managed_ssh_disconnect_warning =>
      'SSH 터널 연결을 끊고 이 게이트웨이가 소유한 원격 서비스를 중지할까요? 해당 서비스를 사용하는 다른 클라이언트의 작동이 중단될 수 있습니다.';

  @override
  String get fleet_managed_ssh_verify => '대신 직접 키 확인';

  @override
  String fleet_managed_ssh_pending(int seconds) {
    return '게이트웨이 대기 중: $seconds초. 이 페이지를 떠나도 초기 설정은 취소되지 않습니다. 요청이 실패하면 다시 시도하기 전에 상태를 확인하세요.';
  }

  @override
  String fleet_managed_ssh_status(
    String host,
    int localPort,
    int remotePort,
    String version,
    String reused,
  ) {
    return '호스트: $host\n게이트웨이 루프백 포트: $localPort\n원격 루프백 포트: $remotePort\nHermes: $version\n재사용: $reused';
  }

  @override
  String get fleet_managed_ssh_disconnect => '연결 끊기';

  @override
  String get ng_slash_suggestions_loading => '명령을 불러오는 중…';

  @override
  String get ng_slash_suggestions_empty => '일치하는 명령이 없습니다';

  @override
  String get ng_slash_suggestions_label => '명령 제안';

  @override
  String get ng_slash_suggestions_skill => '스킬';

  @override
  String get settings_classic_title => 'Classic 설정';

  @override
  String get settings_nextgen_title => 'NextGen 설정';

  @override
  String get settings_category_general => '일반 및 언어';

  @override
  String get settings_category_chat => '채팅 및 세션';

  @override
  String get settings_category_device => '기기 및 단축키';

  @override
  String get settings_category_connections => '연결 및 모델';

  @override
  String get settings_category_security => '개인정보 및 백업';

  @override
  String get settings_category_about => '정보 및 도움말';

  @override
  String get settings_reopen_chat => '게이트웨이로 돌아갈 때 마지막 채팅 복원';

  @override
  String get settings_reopen_chat_hint =>
      '앱을 새로 시작하면 환영 화면이 열립니다. 링크와 알림은 요청된 채팅을 엽니다.';

  @override
  String get settings_danger => '위험 구역';
}
