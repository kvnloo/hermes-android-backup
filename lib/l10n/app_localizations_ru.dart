// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get attachment_audio_failed =>
      'Не удалось воспроизвести аудио. Возможно, формат или кодек не поддерживается либо превышен размер предпросмотра. Повторите попытку, сохраните исходный файл или поделитесь им.';

  @override
  String get attachment_audio_seek => 'Позиция аудио';

  @override
  String get workspace_workers => 'Активные субагенты';

  @override
  String get workers_unattached =>
      'Показано только количество. Чтобы дать указание, выберите «Активные субагенты» в подключённом родительском чате.';

  @override
  String get slash_local_arguments =>
      'Этот ярлык здесь не поддерживает аргументы. Используйте элементы управления приложения; черновик сохранён.';

  @override
  String get fallback_title => 'Резервные модели';

  @override
  String get fallback_notice =>
      'Используются по порядку, если основная модель недоступна. Изменения касаются только этого профиля; сохраните весь список явно.';

  @override
  String get fallback_unavailable =>
      'Настройки резервных моделей недоступны или некорректны. Проверьте соединение, выбранный профиль и версию хоста и повторите попытку.';

  @override
  String get fallback_discovery_unavailable =>
      'Не удалось загрузить поставщиков. Существующие записи сохранены; повторите попытку, чтобы выбрать поставщиков и модели.';

  @override
  String get fallback_empty => 'В этом резервном списке нет записей.';

  @override
  String get fallback_incomplete =>
      'Выберите поставщика и модель для каждой записи или удалите незаполненные записи перед сохранением.';

  @override
  String get fallback_add => 'Добавить резервную модель';

  @override
  String get fallback_save => 'Сохранить резервный список';

  @override
  String get fallback_save_failed =>
      'Не удалось проверить сохранённый список. Черновик сохранён. Повторите сохранение или обновите настройки с хоста.';

  @override
  String get fallback_saved => 'Резервный список сохранён и проверен.';

  @override
  String get fallback_legacy_title =>
      'Устаревшие резервные модели (только чтение)';

  @override
  String get fallback_legacy_notice =>
      'После этого списка хост также использует fallback_model, пропуская повторяющиеся маршруты. Эти устаревшие записи сохраняются, даже если список выше пуст. Изменяйте их на хосте.';

  @override
  String fallback_priority(String position) {
    return 'Приоритет $position';
  }

  @override
  String get fallback_move_up => 'Переместить вверх';

  @override
  String get fallback_move_down => 'Переместить вниз';

  @override
  String get fallback_routing_read_only =>
      'Параметры маршрутизации или поставщик вне каталога сохранены. Изменяйте поставщика/модель на хосте; здесь можно менять порядок и удалять запись.';

  @override
  String get cron_model_default => 'Следовать настройкам по умолчанию';

  @override
  String get cron_model_notice =>
      'Только для этого задания cron. Без закрепления Hermes использует модель cron по умолчанию, затем основную модель. Настраивайте собственные модели на сервере.';

  @override
  String get model_management_unavailable =>
      'Не удалось загрузить или сохранить настройки модели. Обновите и повторите попытку.';

  @override
  String get model_management_subtitle =>
      'Основная, резервные и вспомогательные модели этого профиля';

  @override
  String get usage => 'Использование';

  @override
  String get nous_portal => 'Nous Portal';

  @override
  String get portal_menu_subtitle =>
      'Состояние шлюза и записанное использование';

  @override
  String get portal_read_only =>
      'Данные шлюза только для чтения. Управляйте авторизацией Nous на хосте Hermes. Эти конечные точки не предоставляют баланс подписки или кредиты.';

  @override
  String get portal_status => 'Состояние Portal на шлюзе';

  @override
  String get portal_free_tier => 'Бесплатный доступ (без входа в аккаунт)';

  @override
  String get portal_signed_in => 'Вход выполнен';

  @override
  String get portal_signed_out => 'Вход не выполнен';

  @override
  String get portal_account_tier => 'Уровень аккаунта';

  @override
  String get portal_recorded_usage => 'Записанное использование';

  @override
  String get portal_all_providers =>
      'Все провайдеры выбранного профиля шлюза. Нулевая записанная стоимость не означает, что модель бесплатна.';

  @override
  String portal_period(String days) {
    return 'Последние $days дней';
  }

  @override
  String get portal_sessions => 'Сессии';

  @override
  String get portal_input => 'Входные токены';

  @override
  String get portal_output => 'Выходные токены';

  @override
  String get portal_estimated => 'Записанная оценочная стоимость';

  @override
  String get portal_actual => 'Записанная фактическая стоимость';

  @override
  String get portal_recorded_models => 'Записанные модели';

  @override
  String get portal_no_models => 'Нет записанных моделей.';

  @override
  String get portal_unavailable =>
      'Недоступно. Проверьте соединение, выбранный профиль и версию шлюза, затем повторите попытку.';

  @override
  String get paste_attachment_failed_text_kept =>
      'Не удалось прикрепить вставленный текст. Текст сохранён в сообщении.';

  @override
  String get background_task_report => 'Фоновая задача';

  @override
  String get background_process_report => 'Фоновый процесс';

  @override
  String get background_report_issues =>
      'Обнаружены проблемы — разверните для подробностей.';

  @override
  String get background_report_expand => 'Развернуть отчёт';

  @override
  String get background_report_collapse => 'Свернуть отчёт';

  @override
  String get ng_brand_open_chat => 'Открыть чат';

  @override
  String get ng_brand_recent => 'Недавние';

  @override
  String get ng_brand_sidebar_hint => 'или выберите чат на боковой панели';

  @override
  String get copy_session_id => 'Скопировать ID сеанса';

  @override
  String get copy_session_id_failed => 'Не удалось скопировать ID сеанса.';

  @override
  String get setup_interface_title => 'Выберите интерфейс';

  @override
  String get setup_interface_classic => 'Classic';

  @override
  String get setup_interface_nextgen => 'NextGen';

  @override
  String get setup_interface_classic_description =>
      'Первоначальное рабочее пространство Ares со всеми параметрами подключения и настройками Classic.';

  @override
  String get setup_interface_nextgen_description =>
      'Новый интерфейс с одним входом в панель управления, планами в реальном времени, субагентами и уведомлениями.';

  @override
  String get setup_interface_switch_later =>
      'Переключиться можно в любой момент в настройках.';

  @override
  String get ng_confirm_model_switch => 'Сменить модель?';

  @override
  String get ng_switch => 'Сменить';

  @override
  String get ng_model_confirmation_required =>
      'Перед выбором этой модели требуется подтверждение.';

  @override
  String ng_model_switches_next_turn(String model) {
    return 'Модель сменится на $model в следующем ходе.';
  }

  @override
  String get ng_model_switch_not_connected =>
      'Чат ещё не готов к смене модели. Откройте его снова и повторите попытку.';

  @override
  String ng_gateway_kept_default_model(String model) {
    return 'Шлюз оставил $model для этого чата. Выберите модель ещё раз перед отправкой.';
  }

  @override
  String get hands_free_title => 'Голосовой диалог';

  @override
  String get hands_free_start => 'Начать диалог';

  @override
  String get hands_free_stop => 'Остановить диалог';

  @override
  String get hands_free_preparing => 'Подготовка — подождите';

  @override
  String get hands_free_listening => 'Скажите Hey Hermes';

  @override
  String get hands_free_recording => 'Готово — говорите';

  @override
  String get hands_free_waiting => 'Ожидание Hermes';

  @override
  String get hands_free_speaking => 'Озвучивание — микрофон выключен';

  @override
  String hands_free_followup(int seconds) {
    return 'Слушать до $seconds секунд';
  }

  @override
  String get hands_free_error => 'Диалог остановлен';

  @override
  String get hands_free_setup => 'Настройка диалога';

  @override
  String hands_free_preview(String transcript) {
    return 'Распознано: $transcript';
  }

  @override
  String get hands_free_short_disclosure =>
      'Только в открытом чате на переднем плане. Активация офлайн; речь может использовать сеть. Расходует батарею.';

  @override
  String get hands_free_error_action =>
      'Проверьте доступ к микрофону, речевой сервис, голос и соединение. Нажмите Стоп и Начать. Повторной отправки нет.';

  @override
  String get hands_free_disclosure =>
      'Активация работает офлайн на процессоре. Распознавание Android, выбранный голос и шлюз могут использовать сеть. Прослушивание расходует батарею; возможны ложные срабатывания. При закрытии, перекрытии чата или уходе в фон всё останавливается без автозапуска. Ручная диктовка остаётся редактируемым черновиком.';

  @override
  String get hands_free_ready_cue =>
      'Скажите «Hey Hermes», дождитесь «Готово», затем говорите. Нет захвата одной фразой или предзаписи. После выдачи разрешения вне приложения нажмите Начать снова.';

  @override
  String get hands_free_settings_title => 'Голосовой режим без рук';

  @override
  String get hands_free_settings_subtitle =>
      'Показывает кнопку запуска «Hey Hermes» в чатах. Отключение останавливает текущий сеанс.';

  @override
  String get hands_free_timing_limit =>
      'Окно продолжения — максимум, не минимум. Android может остановиться раньше. Тишина возвращает локальную активацию без повторных запусков распознавания.';

  @override
  String get hands_free_followup_off =>
      'Продолжение выключено — говорите Hey Hermes перед каждым запросом';

  @override
  String get hands_free_start_blocked =>
      'Нужны пустой черновик, отсутствие вложений, свободный подключённый чат и включённая озвучка. Сначала завершите ручные голосовые действия.';

  @override
  String get hands_free_setup_complete =>
      'Настройка микрофона завершена. Нажмите Начать снова.';

  @override
  String message_time_recorded(String time) {
    return 'Записано сервером: $time (местное время)';
  }

  @override
  String message_time_sent(String time) {
    return 'Отправка зафиксирована на этом устройстве: $time (местное время)';
  }

  @override
  String message_time_received(String time) {
    return 'Впервые получено на этом устройстве: $time (местное время)';
  }

  @override
  String get stop_and_send => 'Остановить и отправить';

  @override
  String get message_queued_for_running_turn =>
      'Сообщение добавлено в очередь текущего запуска.';

  @override
  String get running_message_not_accepted =>
      'Hermes не смог принять это сообщение. Черновик сохранён. Остановите ответ или подождите, затем отправьте снова.';

  @override
  String get running_message_delivery_unknown =>
      'Не удалось подтвердить доставку. Черновик сохранён. Проверьте чат перед повторной отправкой.';

  @override
  String get attachment_tap_to_preview => 'Нажмите для просмотра';

  @override
  String get attachment_save => 'Сохранить';

  @override
  String get attachment_share => 'Поделиться';

  @override
  String get attachment_saved => 'Файл сохранён';

  @override
  String get attachment_save_cancelled => 'Сохранение отменено';

  @override
  String get attachment_save_failed =>
      'Не удалось сохранить файл. Повторите попытку.';

  @override
  String get attachment_share_failed =>
      'Не удалось поделиться файлом. Повторите попытку.';

  @override
  String get attachment_download_failed =>
      'Не удалось загрузить файл. Проверьте подключение и повторите попытку.';

  @override
  String get attachment_no_inline_preview =>
      'Предпросмотр этого типа файлов недоступен. Сохраните исходный файл или поделитесь им, чтобы открыть в другом приложении.';

  @override
  String get attachment_image_failed =>
      'Не удалось декодировать изображение. Исходный файл по-прежнему можно сохранить или отправить.';

  @override
  String get attachment_text_truncated =>
      'Предпросмотр сокращён. Сохраните файл или поделитесь им, чтобы прочитать его целиком.';

  @override
  String get attachment_text_unavailable =>
      'Не удалось отобразить файл как текст. Сохраните исходный файл или поделитесь им.';

  @override
  String get attachment_pdf_failed =>
      'Не удалось открыть предпросмотр PDF. Сохраните исходный файл или поделитесь им.';

  @override
  String get attachment_pdf_unavailable =>
      'Предпросмотр PDF доступен на Android. Этот файл по-прежнему можно сохранить или отправить.';

  @override
  String attachment_pdf_page(int page, int total) {
    return 'Страница $page из $total';
  }

  @override
  String get attachment_previous_page => 'Предыдущая страница';

  @override
  String get attachment_next_page => 'Следующая страница';

  @override
  String get attachment_loading => 'Загрузка предпросмотра…';

  @override
  String get attachment_document_text_notice =>
      'Предпросмотр текста. Макет, изображения и форматирование могут отличаться от оригинала.';

  @override
  String get attachment_document_failed =>
      'Не удалось открыть предпросмотр документа. Сохраните исходный файл или поделитесь им.';

  @override
  String get attachment_document_empty =>
      'В этом документе не найден читаемый текст.';

  @override
  String get attachment_video_failed =>
      'Не удалось воспроизвести видео. Возможно, формат или кодек не поддерживается. Сохраните исходный файл или поделитесь им.';

  @override
  String get attachment_video_play => 'Воспроизвести';

  @override
  String get attachment_video_pause => 'Пауза';

  @override
  String get attachment_video_mute => 'Выключить звук';

  @override
  String get attachment_video_unmute => 'Включить звук';

  @override
  String get attachment_video_seek => 'Позиция видео';

  @override
  String get attachment_close => 'Закрыть предпросмотр';

  @override
  String get attachment_retry => 'Повторить';

  @override
  String get saved_history_heading => 'Сохранённая история';

  @override
  String get received_output_heading =>
      'Полученный вывод — совпадение с сохранённой историей не подтверждено';

  @override
  String get received_output_details => 'О полученном выводе';

  @override
  String get received_output_explanation =>
      'Этот вывод может быть и в сохранённой истории. Приложение не может подтвердить совпадение.';

  @override
  String get local_prompt_context => 'Локальный контекст промпта';

  @override
  String get received_output_badge => 'Получено · совпадение не подтверждено';

  @override
  String get received_output_lifetime =>
      'Полученный вывод временно хранится в этой сессии приложения и может быть сокращён или удалён при достижении лимитов. После закрытия приложения или подключения он может стать недоступен.';

  @override
  String get theme_palette => 'Цветовая тема';

  @override
  String get theme_palette_gold => 'Золотой';

  @override
  String get theme_palette_purple => 'Фиолетовый';

  @override
  String get theme_palette_orange => 'Оранжевый';

  @override
  String get theme_palette_green => 'Зелёный';

  @override
  String get theme_palette_blue => 'Синий';

  @override
  String get theme_palette_red => 'Красный';

  @override
  String get theme_palette_teal => 'Бирюзовый';

  @override
  String get theme_palette_pink => 'Розовый';

  @override
  String get theme_palette_indigo => 'Индиго';

  @override
  String get theme_palette_cyan => 'Циан';

  @override
  String get assets_recent_subtitle =>
      'Находите файлы, которыми Hermes поделился в сохранённых чатах';

  @override
  String get assets_scope_notice =>
      'Созданные файлы, которыми Hermes явно поделился в сохранённых ответах. Здесь показана лишь часть истории чатов, а не полный каталог файлов или вложений. Файлы по найденным ссылкам могут больше не существовать.';

  @override
  String get assets_download_limit =>
      'Файлы загружаются только по нажатию. Для предпросмотра и скачивания действует ограничение в 25 MiB на файл; для файлов большего размера используйте панель управления.';

  @override
  String get assets_search_hint =>
      'Поиск среди найденных файлов или исходных чатов';

  @override
  String get assets_all => 'Все';

  @override
  String get assets_images => 'Изображения';

  @override
  String get assets_audio => 'Аудио';

  @override
  String get assets_video => 'Видео';

  @override
  String get assets_documents => 'Документы и другие файлы';

  @override
  String get assets_empty => 'В проверенных сообщениях ресурсы не найдены';

  @override
  String get assets_empty_detail =>
      'Проверьте другие чаты или более старые сообщения, чтобы просмотреть более раннюю историю. Обычные вложения и файлы без ссылок здесь не индексируются.';

  @override
  String get assets_no_matches => 'Нет подходящих ресурсов';

  @override
  String get assets_load_more_chats => 'Проверить другие чаты';

  @override
  String get assets_load_older_messages => 'Проверить более старые сообщения';

  @override
  String get assets_load_failed =>
      'Не удалось прочитать часть истории. Результаты неполные. Проверьте подключение к панели управления и повторите попытку.';

  @override
  String get assets_retry_failed =>
      'Повторить неудачные попытки чтения истории';

  @override
  String get assets_partial =>
      'Сервер сообщил о неполной истории. Проверьте панель управления, затем обновите данные.';

  @override
  String assets_scan_summary(int files, int chats) {
    return 'Найдено ссылок на файлы: $files · Проверено чатов: $chats';
  }

  @override
  String assets_open_chat(String title) {
    return 'Открыть чат: $title';
  }

  @override
  String get assets_file_too_large =>
      'Размер этого файла превышает лимит скачивания. Откройте панель управления, чтобы скачать его.';

  @override
  String get a_one_off_question_archives_itself_after_72_hours_anything =>
      'Разовый вопрос. Автоматически архивируется через 72 часа; всё, что стоит сохранить, останется в памяти.';

  @override
  String get archive_chat => 'Архивировать чат';

  @override
  String get unarchive_chat => 'Разархивировать чат';

  @override
  String get chat_archived => 'Чат архивирован';

  @override
  String get chat_unarchived => 'Чат разархивирован';

  @override
  String could_not_update_chat_archive(Object error) {
    return 'Не удалось изменить статус архивации чата: $error';
  }

  @override
  String get quick_chat_description => 'Разовый вопрос.';

  @override
  String get ai_full_text => 'ИИ + полный текст';

  @override
  String get ai_search_model => 'Модель ИИ-поиска';

  @override
  String ai_searched_for(Object aiRewrittenQuery) {
    return 'ИИ искал: $aiRewrittenQuery';
  }

  @override
  String get ai_assisted_filing => 'Сортировка с помощью ИИ';

  @override
  String get api_key => 'Ключ API';

  @override
  String get api_server_key_from_hermes_env =>
      'API_SERVER_KEY из ~/.hermes/.env';

  @override
  String get active => 'Активно';

  @override
  String get activity => 'Активность';

  @override
  String get activity_reads_the_durable_turn_journal_to_know_what_hermes =>
      'Активность читает долговременный журнал ходов, чтобы знать, что делает Hermes. Проверьте доступность шлюза и повторите попытку.';

  @override
  String get add => 'Добавить';

  @override
  String get add_connection => 'Добавить подключение';

  @override
  String get add_cron_job => 'Добавить задачу Cron';

  @override
  String get add_gateway_connection => 'Добавить подключение к шлюзу';

  @override
  String get add_and_update_connections_from_the_backup_keep_the_rest =>
      'Добавить и обновить подключения из резервной копии, остальные сохранить.';

  @override
  String get add_attachment => 'Добавить вложение';

  @override
  String get add_new_cron_job => 'Добавить новую задачу Cron';

  @override
  String get add_to_chat => 'Добавить в чат';

  @override
  String get all_chats => 'Все чаты';

  @override
  String get all_stored_message_content =>
      'Всё сохранённое содержимое сообщений';

  @override
  String get allow_for_this_session => 'Разрешить в этой сессии';

  @override
  String get allow_matching_commands_until_this_hermes_session_ends =>
      'Разрешать совпадающие команды до конца этой сессии Hermes.';

  @override
  String get allow_folder_until_sandbox_off =>
      'Разрешить эту папку до отключения песочницы.';

  @override
  String get allow_once => 'Разрешить один раз';

  @override
  String get allow_website_until_sandbox_off =>
      'Разрешить этот сайт до отключения песочницы.';

  @override
  String get always_allow => 'Всегда разрешать';

  @override
  String get apply_to_this_chat => 'Применить к этому чату';

  @override
  String get approval_needed => 'Требуется подтверждение';

  @override
  String get approval_needed_description =>
      'Команда ждёт вашего одобрения или отклонения.';

  @override
  String get approve => 'Одобрить';

  @override
  String get archive => 'Архивировать';

  @override
  String get archive_project => 'Архивировать проект';

  @override
  String archive_2(Object projectName) {
    return 'Архивировать $projectName?';
  }

  @override
  String archive_3(Object name) {
    return 'Архивировать $name?';
  }

  @override
  String get archived => 'В архиве';

  @override
  String get archived_conversations_appear_here =>
      'Здесь отображаются только архивированные диалоги. Старые чаты остаются в разделе «Все чаты».';

  @override
  String get archived_quick_chats => 'Архивированные быстрые чаты';

  @override
  String get artifacts_attachments_and_generated_media =>
      'Артефакты, вложения и созданные медиа';

  @override
  String get ask_ai_to_find_a_conversation => 'Попросить ИИ найти диалог';

  @override
  String get assets => 'Ресурсы';

  @override
  String get assets_need_a_server_authoritative_assets_index_in_the_hermes =>
      'Ресурсам нужен серверный авторитетный индекс в шлюзе Hermes, прежде чем их можно будет показывать по проектам.';

  @override
  String get assets_unavailable => 'Ресурсы недоступны';

  @override
  String get attach_image_or_file => 'Прикрепить изображение или файл';

  @override
  String get attachment_drafts => 'Черновики вложений';

  @override
  String get recover_text_draft => 'Восстановить черновик';

  @override
  String get undo_draft_recovery => 'Отменить';

  @override
  String get draft_session_exists =>
      'Этот чат ещё существует. Откройте его, чтобы продолжить работу с черновиком.';

  @override
  String get draft_recovery_unavailable =>
      'Не удалось проверить черновик. Ничего не изменено.';

  @override
  String attachment_of(Object index, Object total) {
    return 'Вложение $index из $total';
  }

  @override
  String get auto_device_default => 'Автоматически (по умолчанию устройства)';

  @override
  String get agent => 'Агент';

  @override
  String get autonomous_agents => 'Автономные агенты';

  @override
  String get background_recovery_unavailable_legacy_transport =>
      'Восстановление в фоне недоступно — устаревший транспорт';

  @override
  String get background_task_completed => 'Фоновая задача завершена';

  @override
  String get background_task_completed_description =>
      'Команда терминала в фоне завершена.';

  @override
  String get backup_restore => 'Резервное копирование и восстановление';

  @override
  String backup_exported(Object destination) {
    return 'Резервная копия экспортирована — $destination';
  }

  @override
  String get base_url => 'Базовый URL';

  @override
  String get binary_preview_is_unavailable_download_the_file_to_open_it =>
      'Предпросмотр двоичных файлов недоступен. Скачайте файл, чтобы открыть его.';

  @override
  String get branch => 'Ветка';

  @override
  String get branch_chat => 'Создать ветку чата';

  @override
  String get branch_created_in_hermes_history =>
      'Ветка создана в истории Hermes.';

  @override
  String get browse_and_manage_your_hermes_agent_sessions_from_your_phone =>
      'Просматривайте сессии Hermes Agent и управляйте ими с телефона. Подключается к панели управления Hermes в вашей локальной сети.';

  @override
  String get browse_server_files => 'Просмотр файлов сервера';

  @override
  String get browse_the_miniserver_folders_behind_your_projects =>
      'Просмотр папок miniserver за вашими проектами';

  @override
  String get cancel => 'Отмена';

  @override
  String get cancel_voice_input => 'Отменить голосовой ввод';

  @override
  String cannot_reach(Object host, Object port) {
    return 'Не удаётся подключиться к $host:$port.';
  }

  @override
  String cannot_reach_check_the_host_and_port(Object host, Object port) {
    return 'Не удаётся подключиться к $host:$port. Проверьте хост и порт.';
  }

  @override
  String get change_ai_search_model => 'Сменить модель ИИ-поиска';

  @override
  String changes_the_default_for_use_the_selector_in_a_chat(Object label) {
    return 'Меняет значение по умолчанию для $label. Используйте селектор в чате, чтобы переопределить только этот диалог.';
  }

  @override
  String get chat_actions => 'Действия с чатом';

  @override
  String get chats => 'Чаты';

  @override
  String get chats_from_this_gateway_are_not_grouped_yet_grouping_stays =>
      'Чаты этого шлюза пока не группируются. Группировка остаётся на этом телефоне, пока шлюз не сможет размещать проекты.';

  @override
  String get chats_in_this_project_will_show_their_state_and_last =>
      'Чаты этого проекта будут показывать здесь своё состояние и последнюю активность.';

  @override
  String get chats_that_are_not_assigned_to_a_project =>
      'Чаты, не назначенные проекту';

  @override
  String get chats_you_start_in_this_project_will_appear_here_on =>
      'Чаты, начатые в этом проекте, появятся здесь на всех устройствах, где выполнен вход в этот Hermes.';

  @override
  String get check_that_the_gateway_is_running_and_reachable_then_try =>
      'Проверьте, что шлюз запущен и доступен, и повторите попытку.';

  @override
  String get check_the_dashboard_connection_and_try_again =>
      'Проверьте подключение к панели управления и повторите попытку.';

  @override
  String get check_the_connection_and_try_again =>
      'Проверьте подключение и повторите попытку.';

  @override
  String get choose_a_small_model_to_rewrite_queries =>
      'Выберите небольшую модель для переписывания запросов';

  @override
  String get choose_an_ai_search_model_before_using_ai_search =>
      'Выберите модель ИИ-поиска перед использованием ИИ-поиска.';

  @override
  String get choose_an_active_project_next => 'Затем выберите активный проект';

  @override
  String get choose_chat_model => 'Выбрать модель чата';

  @override
  String get choose_files => 'Выбрать файлы';

  @override
  String get choose_image => 'Выбрать изображение';

  @override
  String get choose_images => 'Выбрать изображения';

  @override
  String get choose_its_destination_space => 'Выберите пространство назначения';

  @override
  String get clear_search => 'Очистить поиск';

  @override
  String get close => 'Закрыть';

  @override
  String get code_copied => 'Код скопирован';

  @override
  String get code_format => 'Код';

  @override
  String get coming_next => 'Скоро';

  @override
  String get command => 'Команда';

  @override
  String get command_palette => 'Палитра команд';

  @override
  String get command_palette_hint => 'Введите команду';

  @override
  String get command_palette_no_results => 'Команды не найдены';

  @override
  String get command_palette_new_chat => 'Новый чат';

  @override
  String get command_palette_search_chats => 'Поиск чатов';

  @override
  String get command_palette_toggle_theme => 'Переключить тему';

  @override
  String get command_palette_copy_last_code =>
      'Скопировать последний блок кода';

  @override
  String get command_line_chats => 'Чаты в командной строке';

  @override
  String get compatibility_mode => 'Режим совместимости';

  @override
  String get configure_a_valid_desktop_gateway_url_before_attaching_files =>
      'Настройте корректный URL Desktop Gateway, прежде чем прикреплять файлы.';

  @override
  String get confirm_always_allow => 'Подтвердить «Всегда разрешать»';

  @override
  String get confirm_passphrase => 'Подтвердите парольную фразу';

  @override
  String connecting_to(Object baseUrl) {
    return 'Подключение к $baseUrl...';
  }

  @override
  String get connection_issue => 'Проблема с подключением';

  @override
  String
  get connection_switched_the_running_reply_continues_on_the_server_and =>
      'Подключение переключено — текущий ответ продолжится на сервере и автоматически переподключится.';

  @override
  String get connection_appearance_and_device_preferences =>
      'Подключение, внешний вид и настройки устройства';

  @override
  String context_tokens(Object effectiveContextLength) {
    return 'Контекст: $effectiveContextLength токенов';
  }

  @override
  String get continue_label => 'Продолжить';

  @override
  String get continue_working => 'Продолжить работу';

  @override
  String get conversations_in_this_project => 'Диалоги в этом проекте';

  @override
  String get copy_code => 'Копировать код';

  @override
  String get copy_message => 'Копировать сообщение';

  @override
  String could_not_branch_chat(Object error) {
    return 'Не удалось создать ветку чата: $error';
  }

  @override
  String could_not_delete_session(Object error) {
    return 'Не удалось удалить сессию: $error';
  }

  @override
  String could_not_deny_the_command(Object error) {
    return 'Не удалось отклонить команду: $error';
  }

  @override
  String could_not_load_ai_search_models(Object error) {
    return 'Не удалось загрузить модели ИИ-поиска: $error';
  }

  @override
  String get could_not_load_conversations => 'Не удалось загрузить диалоги';

  @override
  String get could_not_load_files => 'Не удалось загрузить файлы';

  @override
  String could_not_load_models_for_this_profile(Object error) {
    return 'Не удалось загрузить модели для этого профиля: $error';
  }

  @override
  String could_not_load_more_chats(Object error) {
    return 'Не удалось загрузить больше чатов: $error';
  }

  @override
  String get could_not_open_link => 'Не удалось открыть эту ссылку.';

  @override
  String get could_not_open_the_hermes_dashboard =>
      'Не удалось открыть панель управления Hermes.';

  @override
  String get could_not_open_this_project => 'Не удалось открыть этот проект';

  @override
  String get could_not_preview_file => 'Не удалось показать предпросмотр файла';

  @override
  String get could_not_reach_hermes => 'Не удалось подключиться к Hermes';

  @override
  String could_not_reach_authenticate_the_dashboard_at_check_the_port(
    Object dashboardPort,
    Object host,
  ) {
    return 'Не удалось подключиться к панели управления $host:$dashboardPort или пройти аутентификацию. Проверьте порт и учётные данные.';
  }

  @override
  String get could_not_read_activity => 'Не удалось прочитать активность';

  @override
  String could_not_rename_chat(Object error) {
    return 'Не удалось переименовать чат: $error';
  }

  @override
  String could_not_send_the_approval(Object error) {
    return 'Не удалось отправить подтверждение: $error';
  }

  @override
  String get could_not_skip_the_hermes_question =>
      'Не удалось пропустить вопрос Hermes.';

  @override
  String could_not_the_project(Object action, Object error) {
    return 'Не удалось $action проект: $error';
  }

  @override
  String get couldn_t_delete_project => 'Не удалось удалить проект';

  @override
  String couldn_t_load_runs(Object error) {
    return 'Не удалось загрузить запуски: $error';
  }

  @override
  String get couldn_t_move_conversation => 'Не удалось переместить диалог';

  @override
  String couldn_t_move_to(Object label, Object reason) {
    return 'Не удалось переместить в $label: $reason';
  }

  @override
  String get couldn_t_prepare_the_shared_files =>
      'Не удалось подготовить общие файлы.';

  @override
  String get couldn_t_promote_conversation => 'Не удалось повысить диалог';

  @override
  String couldn_t_project(Object action) {
    return 'Не удалось $action проект';
  }

  @override
  String get create => 'Создать';

  @override
  String get create_a_project => 'Создать проект';

  @override
  String get create_a_project_first_then_chats_can_live_inside_it =>
      'Сначала создайте проект — потом в нём смогут жить чаты.';

  @override
  String get create_a_space_to_separate_related_conversations =>
      'Создайте пространство, чтобы разделить связанные диалоги.';

  @override
  String get create_branch => 'Создать ветку';

  @override
  String get credit_notifications => 'Уведомления о кредитах';

  @override
  String get credit_notifications_description =>
      'Использование кредитов остановлено или возобновлено.';

  @override
  String get cron => 'Cron';

  @override
  String get crons => 'Крон';

  @override
  String get cron_conversations_empty =>
      'Здесь появятся чаты запланированных заданий, включая предыдущие запуски.';

  @override
  String get search_cron_conversations => 'Поиск чатов cron';

  @override
  String get cron_jobs => 'Задачи Cron';

  @override
  String cron_schedule_timezone(Object zone) {
    return 'Часовой пояс расписания: $zone';
  }

  @override
  String get crons_upcoming => 'Предстоящие';

  @override
  String get crons_history => 'История';

  @override
  String cron_time_with_zone(Object time, Object zone) {
    return '$time ($zone)';
  }

  @override
  String cron_time_zone_unknown(Object time) {
    return '$time (часовой пояс неизвестен)';
  }

  @override
  String get cron_no_next_run => 'Следующий запуск не запланирован';

  @override
  String get cron_status_scheduled => 'Запланировано';

  @override
  String get cron_status_paused => 'Приостановлено';

  @override
  String cron_delivers_to(Object target) {
    return 'Доставка в $target';
  }

  @override
  String get cron_upcoming_empty_title => 'Нет запланированных задач';

  @override
  String get cron_upcoming_empty_message =>
      'Ничего не запланировано к запуску. Создайте задачу в разделе «Задачи Cron» или попросите агента запланировать её.';

  @override
  String get cron_upcoming_unavailable => 'Запланированные задачи недоступны';

  @override
  String get cron_upcoming_needs_dashboard =>
      'Для запланированных задач нужно подключение к панели управления. Этот адрес не предоставляет расписание Cron. Проверьте адрес панели и поддержку этой функции на сервере.';

  @override
  String get cron_upcoming_needs_dashboard_auth =>
      'Для запланированных задач нужна аутентификация в панели управления. Добавьте имя пользователя и пароль панели к этому подключению или включите режим через прокси.';

  @override
  String get cron_upcoming_dashboard_unreachable =>
      'Не удалось подключиться к панели управления. Проверьте узел, порт панели и сеть, затем повторите попытку.';

  @override
  String get cron_upcoming_load_failed =>
      'Не удалось прочитать запланированные задачи. Проверьте подключение к панели управления и повторите попытку.';

  @override
  String get cron_upcoming_refresh_failed =>
      'Не удалось обновить расписание. Показан последний успешный результат.';

  @override
  String get cron_job_added => 'Задача Cron добавлена';

  @override
  String get cron_job_updated => 'Задача Cron обновлена';

  @override
  String get cron_run => 'Запуск Cron';

  @override
  String get cross_device_ordering_and_reversible_bulk_organization =>
      'Упорядочивание между устройствами и обратимая массовая организация';

  @override
  String get current_profile_default => 'Текущее значение профиля по умолчанию';

  @override
  String get custom_proxy_and_dashboard_details =>
      'Пользовательские параметры прокси и панели управления';

  @override
  String get dark => 'Тёмная';

  @override
  String get dashboard_proxy_settings => 'Настройки панели управления / прокси';

  @override
  String get dashboard_password_optional =>
      'Пароль панели управления (необязательно)';

  @override
  String get dashboard_port => 'Порт панели управления';

  @override
  String get dashboard_username_optional =>
      'Имя пользователя панели управления (необязательно)';

  @override
  String get dashboard_behind_proxy => 'Панель управления за прокси';

  @override
  String get dashboard_path_prefix => 'Префикс пути панели управления';

  @override
  String delegated_task(Object goal) {
    return 'Делегированная задача: $goal';
  }

  @override
  String get delete => 'Удалить';

  @override
  String delete_2(Object name) {
    return 'Удалить «$name»?';
  }

  @override
  String delete_from_the_remote_hermes_history_this_cannot_be_undone(
    Object title,
  ) {
    return 'Удалить «$title» из удалённой истории Hermes? Это действие нельзя отменить.';
  }

  @override
  String get delete_cron_job => 'Удалить задачу Cron';

  @override
  String get delete_connections_that_are_not_in_the_backup =>
      'Удалить подключения, которых нет в резервной копии.';

  @override
  String delete_failed(Object error) {
    return 'Не удалось удалить: $error';
  }

  @override
  String get delete_project => 'Удалить проект';

  @override
  String get delete_session => 'Удалить сессию?';

  @override
  String delete_3(Object projectName) {
    return 'Удалить $projectName?';
  }

  @override
  String deleted(Object name) {
    return 'Удалено: «$name»';
  }

  @override
  String get delivery_is_uncertain_recovering_without_resending =>
      'Доставка не подтверждена; восстановление без повторной отправки…';

  @override
  String get desktop_gateway_url_optional =>
      'URL Desktop Gateway (необязательно)';

  @override
  String get desktop_gateway_is_not_configured_for_this_connection =>
      'Desktop Gateway не настроен для этого подключения.';

  @override
  String get desktop_app => 'Приложение для компьютера';

  @override
  String get developer_tool_calls => 'Вызовы инструментов разработчика';

  @override
  String get discord_chats => 'Чаты Discord';

  @override
  String get dismiss => 'Скрыть';

  @override
  String get do_not_run_this_command => 'Не выполняйте эту команду.';

  @override
  String get documents_archives_audio_video_or_data =>
      'Документы, архивы, аудио, видео или данные';

  @override
  String get download => 'Скачать';

  @override
  String download_failed(Object error) {
    return 'Ошибка скачивания: $error';
  }

  @override
  String get durable_facts_hermes_keeps_about_you =>
      'Долговременные факты, которые Hermes хранит о вас';

  @override
  String get durable_work_inside_one_of_your_projects_shared_with_desktop =>
      'Долговременная работа в одном из ваших проектов, общая с Desktop.';

  @override
  String get edit => 'Редактировать';

  @override
  String get edit_connection => 'Изменить подключение';

  @override
  String get edit_cron_job => 'Редактировать задачу Cron';

  @override
  String get edit_gateway_connection => 'Изменить подключение к шлюзу';

  @override
  String get edit_and_resend => 'Изменить и отправить снова';

  @override
  String get enable_notifications => 'Включить уведомления';

  @override
  String get enable_notifications_description =>
      'Если выключить, все уведомления ниже отключатся.';

  @override
  String get enables_file_attachments_through_the_desktop_remote_gateway =>
      'Включает вложения файлов через удалённый шлюз Desktop.';

  @override
  String get enter_a_name => 'Введите имя';

  @override
  String get enter_a_passphrase => 'Введите парольную фразу.';

  @override
  String get enter_the_passphrase_for_this_backup =>
      'Введите парольную фразу для этой резервной копии.';

  @override
  String get every_conversation_is_already_assigned_to_a_project =>
      'Все диалоги уже назначены проекту.';

  @override
  String get everything_not_yet_native_in_the_authenticated_web_dashboard =>
      'Всё, что ещё не реализовано нативно, — в веб-панели управления с аутентификацией';

  @override
  String get explain_the_attached_content_clearly =>
      'Объясните прикреплённое содержимое понятно.';

  @override
  String explain_this_content_clearly(Object text) {
    return 'Объясните это содержимое понятно:\n\n$text';
  }

  @override
  String
  get explicit_choices_adjust_android_accessibility_text_size_system_leaves_it =>
      'Явный выбор меняет размер текста специальных возможностей Android; «Система» оставляет его без изменений.';

  @override
  String get export_label => 'Экспорт';

  @override
  String get export_share => 'Экспорт / поделиться';

  @override
  String get external_api_clients => 'Внешние клиенты API';

  @override
  String get extra_high => 'Очень высокий';

  @override
  String get extract_tasks => 'Извлечь задачи';

  @override
  String
  get extract_the_decisions_deadlines_owners_and_actionable_action_items_from =>
      'Извлеките из прикреплённого содержимого решения, сроки, ответственных и выполнимые задачи.';

  @override
  String
  extract_the_decisions_deadlines_owners_and_actionable_action_items_from_2(
    Object text,
  ) {
    return 'Извлеките из этого содержимого решения, сроки, ответственных и выполнимые задачи:\n\n$text';
  }

  @override
  String failed_to_add_job(Object error) {
    return 'Не удалось добавить задачу: $error';
  }

  @override
  String get failed_to_load_cron_jobs => 'Не удалось загрузить задачи Cron';

  @override
  String get failed_to_load_memory => 'Не удалось загрузить память';

  @override
  String get failed_to_load_messages => 'Не удалось загрузить сообщения';

  @override
  String get failed_to_load_settings => 'Не удалось загрузить настройки';

  @override
  String get failed_to_load_skills => 'Не удалось загрузить навыки';

  @override
  String failed_to_update_job(Object error) {
    return 'Не удалось обновить задачу: $error';
  }

  @override
  String failed(Object error) {
    return 'Ошибка: $error';
  }

  @override
  String get file_attached_document_catalog_registration_is_pending =>
      'Файл прикреплён; регистрация в каталоге документов ожидается.';

  @override
  String get file_reference_added_to_chat => 'Ссылка на файл добавлена в чат';

  @override
  String get files => 'Файлы';

  @override
  String get fill_from_document => 'Заполнить из документа';

  @override
  String get folder_is_empty => 'Папка пуста';

  @override
  String get folders => 'Папки';

  @override
  String get full_text => 'Полный текст';

  @override
  String get gateway_api_access => 'Доступ к API шлюза';

  @override
  String get gateway_connected_but_the_dashboard_could_not_be_reached_or =>
      'Шлюз подключён, но панель управления недоступна или не прошла аутентификацию. Проверьте данные панели или очистите их, чтобы пропустить.';

  @override
  String get gateway_path_prefix => 'Префикс пути шлюза';

  @override
  String get go_to_end => 'В конец';

  @override
  String get hermes_agent => 'Ares - formerly Hermes Android';

  @override
  String get hermes_agent_for_android => 'Ares - formerly Hermes Android';

  @override
  String get hermes_could_not_accept_the_answer_please_try_again =>
      'Hermes не смог принять ответ. Повторите попытку.';

  @override
  String get hermes_could_not_load_your_saved_connections =>
      'Hermes не смог загрузить ваши сохранённые подключения';

  @override
  String get hermes_did_not_accept_the_response_please_try_again =>
      'Hermes не принял ответ. Повторите попытку.';

  @override
  String get hermes_is_responding => 'Hermes отвечает…';

  @override
  String get hermes_is_waiting_for_input => 'Hermes ждёт вашего ввода…';

  @override
  String get hermes_keeps_android_accessibility_text_scaling_active =>
      'Ares сохраняет активным масштабирование текста специальных возможностей Android.';

  @override
  String get hermes_needs_your_input => 'Hermes нужен ваш ввод';

  @override
  String get hermes_profile_optional => 'Профиль Hermes (необязательно)';

  @override
  String get hermes_profile_must_be_a_plain_profile_name_such_as =>
      'Профиль Hermes должен быть простым именем профиля, например «sol», а не путём.';

  @override
  String get hermes_reasoning_details => 'Детали рассуждений Hermes';

  @override
  String hermes_recovery_is_unavailable(Object error) {
    return 'Восстановление Hermes недоступно: $error';
  }

  @override
  String get hermes_stopped_recovery_safely_no_prompt_was_resent =>
      'Hermes безопасно остановил восстановление. Промпт не отправлялся повторно.';

  @override
  String get hide_passphrase => 'Скрыть парольную фразу';

  @override
  String get home_needs_your_recent_chats_to_know_what_deserves_your =>
      'Главной странице нужны ваши недавние чаты, чтобы знать, что заслуживает внимания. Проверьте доступность шлюза и повторите попытку.';

  @override
  String get host => 'Хост';

  @override
  String get image_selection_was_interrupted_try_again =>
      'Выбор изображения был прерван. Повторите попытку.';

  @override
  String get import_label => 'Импорт';

  @override
  String get inbox => 'Входящие';

  @override
  String get inbox_is_clear => 'Входящие пусты';

  @override
  String get input_needed => 'Требуется ввод';

  @override
  String get input_needed_description =>
      'Hermes задал вопрос или запрашивает пароль либо секрет.';

  @override
  String get insert_a_remote_file_reference =>
      'Вставить удалённую ссылку @file';

  @override
  String get invalid_port_number => 'Недопустимый номер порта.';

  @override
  String get job_paused => 'Задача приостановлена';

  @override
  String get job_resumed => 'Задача возобновлена';

  @override
  String get job_triggered => 'Задача запущена';

  @override
  String get label => 'Метка';

  @override
  String last_activity(Object day, Object month, Object year) {
    return 'Последняя активность $day.$month.$year';
  }

  @override
  String last(Object lastRun) {
    return 'Последний: $lastRun';
  }

  @override
  String get leave_blank_for_default_8642_443_with_https =>
      'Оставьте пустым для значения по умолчанию (8642; 443 с https)';

  @override
  String get leave_blank_for_default_9119 =>
      'Оставьте пустым для значения по умолчанию (9119)';

  @override
  String get light => 'Светлая';

  @override
  String listening(Object elapsed) {
    return 'Слушаю • $elapsed';
  }

  @override
  String listening_elapsed(Object elapsed) {
    return 'Слушаю, прошло: $elapsed';
  }

  @override
  String get load_more => 'Загрузить ещё…';

  @override
  String get loading => 'Загрузка';

  @override
  String get location => 'Местоположение';

  @override
  String get make_sure_the_gateway_api_server_is_running_hermes_gateway =>
      'Убедитесь, что сервер API шлюза запущен\n(hermes gateway status)';

  @override
  String matches(Object assigned, Object name) {
    return 'Совпадение: $name · $assigned';
  }

  @override
  String get memory => 'Память';

  @override
  String get memory_about_you => 'О вас';

  @override
  String get memory_agent_notes => 'Заметки агента';

  @override
  String get memory_builtin_scope =>
      'Факты из USER.md и MEMORY.md этого профиля. Внешние хранилища памяти (включая MemPalace) здесь не отображаются.';

  @override
  String get memory_read_only =>
      'Только чтение. Попросите Hermes в чате исправить или забыть факт.';

  @override
  String get memory_unavailable =>
      'Этот шлюз или профиль не может предоставить сохранённые факты. Проверьте выбранный профиль и при необходимости обновите Hermes.';

  @override
  String get memory_load_error =>
      'Проверьте подключение и авторизацию панели управления и повторите попытку.';

  @override
  String get memory_read_full_fact => 'Прочитать факт целиком';

  @override
  String get memory_full_fact_requires_update =>
      'Для полных фактов нужен более новый шлюз Hermes. Обновите Hermes и список.';

  @override
  String get memory_fact_detail_error =>
      'Не удалось загрузить полный факт. Возможно, он изменился; обновите список и повторите попытку.';

  @override
  String get memory_entries_are_cross_session_facts_the_agent_remembers_they =>
      'Сохранённые факты появятся здесь, когда Hermes их запомнит.';

  @override
  String get merge => 'Объединить';

  @override
  String get message => 'Сообщение';

  @override
  String get message_hermes => 'Написать Hermes…';

  @override
  String get message_actions => 'Действия с сообщением';

  @override
  String get message_copied => 'Сообщение скопировано';

  @override
  String get migrating => 'Миграция…';

  @override
  String get migration_complete => 'Миграция завершена';

  @override
  String get migration_failed_local_spaces_were_kept_unchanged =>
      'Миграция не удалась. Локальные пространства остались без изменений.';

  @override
  String get migration_incomplete => 'Миграция не завершена';

  @override
  String get migration_preview => 'Предпросмотр миграции';

  @override
  String get model => 'Модель';

  @override
  String get model_and_thinking_for_this_chat =>
      'Модель и рассуждения для этого чата';

  @override
  String model_was_not_changed(Object error) {
    return 'Модель не изменена: $error';
  }

  @override
  String get move_attachment_next => 'Переместить вложение вперёд';

  @override
  String get move_attachment_previous => 'Переместить вложение назад';

  @override
  String get move_chat => 'Переместить чат';

  @override
  String get move_conversation => 'Переместить диалог';

  @override
  String get move_to_project => 'Переместить в проект';

  @override
  String get move_to_space => 'Переместить в пространство';

  @override
  String get moved_to_a_project => 'Перемещено в проект';

  @override
  String moved_to(Object label) {
    return 'Перемещено в $label';
  }

  @override
  String get name => 'Имя';

  @override
  String get name_prompt_and_schedule_are_required =>
      'Имя, промпт и расписание обязательны';

  @override
  String get nav_activity => 'Актив';

  @override
  String get nav_projects => 'Проект';

  @override
  String get needs_a_correction_aware_filing_contract_in_the_hermes_gateway =>
      'Требуется контракт сортировки с учётом исправлений в шлюзе Hermes.';

  @override
  String get needs_a_reachable_hermes_dashboard_check_the_host_port_and =>
      'Требуется доступная панель управления Hermes. Проверьте хост, порт и учётные данные этого подключения.';

  @override
  String get needs_a_server_authoritative_assets_index_in_the_hermes_gateway =>
      'Требуется серверный авторитетный индекс ресурсов в шлюзе Hermes.';

  @override
  String get needs_durable_pin_ordering_batch_mutation_and_undo_contracts_in =>
      'Требуются контракты порядка закрепления, массовых изменений и отмены в шлюзе Hermes.';

  @override
  String get needs_you => 'Требует внимания';

  @override
  String get new_label => 'Новое';

  @override
  String get new_chat => 'Новый чат';

  @override
  String get new_chat_2 => 'Новый чат';

  @override
  String new_chat_3(Object projectName) {
    return 'Новый чат · $projectName';
  }

  @override
  String get new_project => 'Новый проект';

  @override
  String get new_space => 'Новое пространство';

  @override
  String next(Object nextRun) {
    return 'Следующий: $nextRun';
  }

  @override
  String get nginx_injects_auth_app_sends_clean_requests =>
      'Nginx внедряет аутентификацию — приложение отправляет чистые запросы';

  @override
  String get no_tts_voices_found_ninstall_google_text_to_speech_and =>
      'Голоса TTS не найдены.\nУстановите Google Text-to-Speech и скачайте голосовые данные.';

  @override
  String get no_active_projects_on_this_gateway =>
      'Нет активных проектов на этом шлюзе';

  @override
  String get no_activity_yet => 'Пока нет активности';

  @override
  String get no_chat_is_blocked_running_or_waiting_to_be_resumed =>
      'Нет чатов, которые заблокированы, выполняются или ждут возобновления. Начните новый, когда будете готовы.';

  @override
  String no_chats_in_this_project_match(Object searchQuery) {
    return 'Ни один чат в этом проекте не соответствует «$searchQuery».';
  }

  @override
  String get no_chats_in_this_space_yet_tap_to_start_one =>
      'В этом пространстве пока нет чатов. Нажмите +, чтобы начать.';

  @override
  String get no_chats_yet => 'Пока нет чатов';

  @override
  String get no_connections => 'Нет подключений';

  @override
  String get no_conversation_matches_this_view =>
      'Ни один диалог не соответствует этому представлению.';

  @override
  String get no_cron_jobs => 'Нет задач Cron';

  @override
  String get no_folders_yet => 'Пока нет папок';

  @override
  String get no_local_spaces_were_found_for_this_connection_so_projects =>
      'Для этого подключения не найдено локальных пространств, поэтому проекты уже являются единственной используемой организацией.';

  @override
  String get no_matches => 'Нет совпадений';

  @override
  String get no_memory_entries => 'Нет записей памяти';

  @override
  String get no_message_content_matches =>
      'Нет совпадений в содержимом сообщений';

  @override
  String get no_new_messages => 'Нет новых сообщений';

  @override
  String get no_projects_yet => 'Пока нет проектов';

  @override
  String get no_runs_yet => 'Пока нет запусков.';

  @override
  String no_server_project_matches_this_name(Object assigned) {
    return 'Ни один серверный проект не соответствует этому имени · $assigned';
  }

  @override
  String get no_sessions_yet => 'Пока нет сессий';

  @override
  String get no_skills_found => 'Навыки не найдены';

  @override
  String get no_spaces_on_this_device => 'На этом устройстве нет пространств';

  @override
  String get no_text_shared => 'Текст не передан';

  @override
  String get no_turn_is_blocked_in_flight_or_recently_finished_work =>
      'Ни один ход не заблокирован, не выполняется и не завершён недавно. Начатая работа появится здесь.';

  @override
  String get no_turn_needs_your_input_or_has_failed =>
      'Ни один ход не требует вашего ввода и не завершился ошибкой.';

  @override
  String get no_unassigned_chats => 'Нет неназначенных чатов.';

  @override
  String get nothing_changed_in_the_last_seven_days =>
      'За последние семь дней ничего не изменилось.';

  @override
  String get nothing_has_moved_yet_this_is_only_what_a_migration =>
      'Пока ничего не перемещено — это лишь то, что сделала бы миграция.';

  @override
  String get nothing_here => 'Здесь ничего нет';

  @override
  String get nothing_is_running => 'Ничего не выполняется';

  @override
  String get nothing_needs_you => 'Ничего не требует вашего внимания';

  @override
  String get nothing_to_migrate => 'Нечего переносить';

  @override
  String get notifications => 'Уведомления';

  @override
  String get windows_notifications_blocked =>
      'Уведомления недоступны. Используйте установленное приложение Ares и проверьте Параметры → Система → Уведомления в Windows.';

  @override
  String get windows_notification_diagnostics => 'Что Ares передал в Windows';

  @override
  String get chat_activity_share => 'Делиться активностью в чате';

  @override
  String get chat_activity_share_hint =>
      'Сообщать совместимому подключённому шлюзу, когда вы пользуетесь этим чатом, чтобы его плагин уведомлений для телефона не отправлял повторные оповещения. Ключи и текст сообщений не передаются.';

  @override
  String get completion_sound => 'Звук завершения';

  @override
  String get completion_sound_system => 'Системный по умолчанию';

  @override
  String get completion_sound_mail => 'Почта';

  @override
  String get completion_sound_reminder => 'Напоминание';

  @override
  String get completion_sound_silent => 'Без звука';

  @override
  String get completion_sound_scope =>
      'Звучит при завершении ответов, для тестового уведомления и внутри приложения. Запросы разрешений и другие оповещения сохраняют обычный звук.';

  @override
  String get completion_sound_scope_android =>
      'Звучит при завершении ответов, для тестового уведомления и внутри приложения. Запросы разрешений, другие оповещения, фоновые уведомления сервера и сообщения Android Auto сохраняют обычный звук.';

  @override
  String get notification_open_action => 'Открыть';

  @override
  String get app_sounds_mute => 'Отключить звуки приложения';

  @override
  String get app_sounds_mute_hint =>
      'Отключает звук завершения, который Ares воспроизводит, пока приложение открыто. Уведомления сохраняют свой звук.';

  @override
  String get notifications_permission_denied =>
      'Уведомления заблокированы на уровне системы. Разрешите их для этого приложения в настройках Android.';

  @override
  String get off_no_thinking => 'Выключено (без рассуждений)';

  @override
  String get offline_showing_the_last_known_activity =>
      'Не в сети — показана последняя известная активность.';

  @override
  String get offline_showing_the_last_known_chats =>
      'Не в сети — показаны последние известные чаты';

  @override
  String get offline_showing_the_last_known_projects =>
      'Не в сети — показаны последние известные проекты.';

  @override
  String get on_this_device => 'На этом устройстве';

  @override
  String get on_device => 'На устройстве';

  @override
  String get open_inbox => 'Открыть входящие';

  @override
  String open_inbox_2(Object count) {
    return 'Открыть входящие ($count)';
  }

  @override
  String get open_the_hermes_dashboard => 'Открыть панель управления Hermes';

  @override
  String get optional_for_the_memory_cron_skills_settings_tabs_leave_blank =>
      'Необязательно. Для вкладок «Память», «Cron», «Навыки» и «Настройки». Оставьте пустым, чтобы использовать стандартный порт панели (9119) без входа.';

  @override
  String get organization => 'Организация';

  @override
  String get other_answer => 'Другой ответ';

  @override
  String get overview => 'Обзор';

  @override
  String get passphrase => 'Парольная фраза';

  @override
  String get password_optional => 'Пароль (необязательно)';

  @override
  String get phone_or_tablet => 'Телефон или планшет';

  @override
  String get pin_batch_and_undo => 'Закрепление, массовые операции и отмена';

  @override
  String get plugin_notifications => 'Уведомления плагинов';

  @override
  String get plugin_notifications_description =>
      'Шлюз отправил уведомление, пока приложение было в фоне.';

  @override
  String get port => 'Порт';

  @override
  String get preparing_attachments => 'Подготовка вложений…';

  @override
  String get preview_truncated => 'Предпросмотр усечён';

  @override
  String get preview_unavailable => 'Предпросмотр недоступен';

  @override
  String get profile => 'Профиль';

  @override
  String get profile_default_model => 'Модель профиля по умолчанию';

  @override
  String profile_default_set_to_chats_with_their_own_model_keep(
    Object selectedModel,
  ) {
    return 'Значение профиля по умолчанию: $selectedModel. Чаты с собственной моделью сохраняют это переопределение.';
  }

  @override
  String
  get profile_this_connection_chats_as_when_the_dashboard_serves_several =>
      'Профиль, от имени которого работает это подключение, когда панель обслуживает несколько профилей. Оставьте пустым для изолированной панели для каждого профиля.';

  @override
  String get project => 'Проект';

  @override
  String get project_actions => 'Действия с проектом';

  @override
  String get project_chat => 'Чат проекта';

  @override
  String get project_chats_unavailable => 'Чаты проекта недоступны';

  @override
  String get projects => 'Проекты';

  @override
  String get projects_group_related_chats_files_and_activity_and_stay_in =>
      'Проекты объединяют связанные чаты, файлы и активность и синхронизируются с Hermes на вашем компьютере.';

  @override
  String
  get projects_need_a_desktop_gateway_connection_add_the_desktop_gateway =>
      'Проектам нужно подключение к Desktop Gateway. Добавьте URL Desktop Gateway к этому подключению, чтобы упорядочить чаты на всех устройствах.';

  @override
  String get projects_unavailable => 'Проекты недоступны';

  @override
  String get projects_activity_new_navigation =>
      'Проекты, Активность — новая навигация';

  @override
  String get promote_to_project => 'Повысить до проекта';

  @override
  String get prompt => 'Промпт';

  @override
  String get protect_this_backup => 'Защитить эту резервную копию';

  @override
  String get provider => 'Провайдер';

  @override
  String get proxy_injects_auth_app_sends_clean_requests =>
      'Прокси внедряет аутентификацию; приложение отправляет чистые запросы';

  @override
  String get quick_chat => 'Быстрый чат';

  @override
  String get quick_chats_appear_here_after_their_retention_period =>
      'Быстрые чаты появляются здесь после окончания срока хранения.';

  @override
  String get read_aloud => 'Читать вслух';

  @override
  String get read_aloud_is_unavailable_on_this_device =>
      'Чтение вслух недоступно на этом устройстве';

  @override
  String get reading_response_aloud => 'Чтение ответа вслух';

  @override
  String get ready_to_upload => 'Готово к отправке';

  @override
  String get reasoning => 'Рассуждения';

  @override
  String get recently_completed => 'Недавно завершено';

  @override
  String get recently_active => 'Недавно активен';

  @override
  String get recovering_hermes => 'Восстановление Hermes…';

  @override
  String get refresh => 'Обновить';

  @override
  String get regenerate_response => 'Сгенерировать ответ заново';

  @override
  String get remove_attachment => 'Убрать вложение';

  @override
  String get rename => 'Переименовать';

  @override
  String get rename_chat => 'Переименовать чат';

  @override
  String get rename_project => 'Переименовать проект';

  @override
  String get rename_space => 'Переименовать пространство';

  @override
  String rename_2(Object projectName) {
    return 'Переименовать $projectName';
  }

  @override
  String rename_3(Object name) {
    return 'Переименовать $name';
  }

  @override
  String get replace => 'Заменить';

  @override
  String get repositories => 'Репозитории';

  @override
  String
  get research_the_attached_content_verify_the_important_claims_and_cite =>
      'Изучите прикреплённое содержимое, проверьте важные утверждения и укажите источники.';

  @override
  String research_this_content_verify_the_important_claims_and_cite_sources(
    Object text,
  ) {
    return 'Изучите это содержимое, проверьте важные утверждения и укажите источники:\n\n$text';
  }

  @override
  String reset_failed_the_secure_storage_may_need_reinstall(Object retryError) {
    return 'Сброс не удался: $retryError. Возможно, потребуется переустановить защищённое хранилище.';
  }

  @override
  String get reset_saved_connections => 'Сбросить сохранённые подключения';

  @override
  String get responding => 'Отвечает…';

  @override
  String response_closed_locally_gateway_stop_failed(Object error) {
    return 'Ответ закрыт локально; не удалось остановить шлюз: $error';
  }

  @override
  String get response_closed_locally_no_active_gateway_turn_was_found =>
      'Ответ закрыт локально; активный ход шлюза не найден.';

  @override
  String get response_complete => 'Ответ готов';

  @override
  String get response_complete_description =>
      'Ход завершился, пока приложение было в фоне.';

  @override
  String get response_ready => 'Ответ готов';

  @override
  String get response_stopped => 'Ответ остановлен.';

  @override
  String get restore => 'Восстановить';

  @override
  String get restore_configuration => 'Восстановить конфигурацию';

  @override
  String get restore_project => 'Восстановить проект';

  @override
  String get retry => 'Повторить';

  @override
  String retry_failed_for_the_draft_and_prompt_were_kept(Object name) {
    return 'Не удалось повторить для $name. Черновик и промпт сохранены.';
  }

  @override
  String get retry_upload => 'Повторить отправку';

  @override
  String retrying(Object name) {
    return 'Повторная попытка: $name…';
  }

  @override
  String get review_local_spaces => 'Проверить локальные пространства';

  @override
  String get review_or_promote_quick_chats_past_their_retention_period =>
      'Проверить или повысить быстрые чаты с истёкшим сроком хранения';

  @override
  String get review_the_attached_content =>
      'Проверьте прикреплённое содержимое.';

  @override
  String get run_only_this_command => 'Выполните только эту команду.';

  @override
  String get running_now => 'Выполняется';

  @override
  String get save => 'Сохранить';

  @override
  String get save_changes => 'Сохранить изменения';

  @override
  String get save_a_permanent_rule_in_the_hermes_configuration =>
      'Сохраните постоянное правило в конфигурации Hermes.';

  @override
  String get save_the_durable_facts_from_the_attached_content_to_memory =>
      'Сохраните долговременные факты из прикреплённого содержимого в память и подтвердите, что сохранено.';

  @override
  String save_the_durable_facts_from_this_content_to_memory_then(Object text) {
    return 'Сохраните долговременные факты из этого содержимого в память и подтвердите, что сохранено:\n\n$text';
  }

  @override
  String get save_your_connections_and_settings_to_an_encrypted_file_then =>
      'Сохраните подключения и настройки в зашифрованный файл, а затем восстановите их после переустановки или на другом устройстве.';

  @override
  String save_2(Object filename) {
    return 'Сохранить $filename';
  }

  @override
  String get schedule => 'Расписание';

  @override
  String get scheduled_jobs_and_their_last_runs =>
      'Запланированные задачи и их последние запуски';

  @override
  String get scheduled_tasks => 'Запланированные задачи';

  @override
  String get script_only_no_agent => 'Только скрипт (без агента)';

  @override
  String get scroll_horizontally => 'Прокрутить по горизонтали';

  @override
  String get search_all_chats => 'Искать во всех чатах';

  @override
  String get search_all_message_content =>
      'Искать во всём содержимом сообщений';

  @override
  String get search_chats => 'Искать чаты';

  @override
  String get search_conversations => 'Искать диалоги';

  @override
  String get search_loaded_chats => 'Искать в загруженных чатах';

  @override
  String get search_mode => 'Режим поиска';

  @override
  String get select_one_option_or_enter_another_answer =>
      'Выберите один вариант или введите другой ответ.';

  @override
  String get select_one_or_more_options_then_continue =>
      'Выберите один или несколько вариантов и продолжите.';

  @override
  String get select_text => 'Выделить текст';

  @override
  String get send => 'Отправить';

  @override
  String send_failed(Object error) {
    return 'Ошибка отправки: $error';
  }

  @override
  String send_failed_api_only_permission_denied(Object error) {
    return 'Ошибка отправки: $error. Сервер отклонил эту запись для ключа API. Если этот чат принадлежит Dashboard, добавление имени пользователя и пароля Dashboard для этого подключения может разрешить отправку; сервер также может отклонять её намеренно.';
  }

  @override
  String get send_message => 'Отправить сообщение';

  @override
  String get send_test_notification => 'Отправить тестовое уведомление';

  @override
  String get session_sources => 'Источники сессий';

  @override
  String get session_deleted_from_remote_hermes =>
      'Сессия удалена из удалённого Hermes.';

  @override
  String session_search_failed(Object error) {
    return 'Ошибка поиска сессий: $error';
  }

  @override
  String get set_profile_default => 'Сделать значением профиля по умолчанию';

  @override
  String get settings => 'Настройки';

  @override
  String get share_to_hermes => 'Поделиться с Hermes';

  @override
  String get show_passphrase => 'Показать парольную фразу';

  @override
  String get show_tool_calls_thinking_and_message_metadata =>
      'Показывать вызовы инструментов, рассуждения и метаданные сообщений';

  @override
  String get signal_messages => 'Сообщения Signal';

  @override
  String get skills => 'Навыки';

  @override
  String skills_2(Object count) {
    return 'Навыки ($count)';
  }

  @override
  String get skills_and_tools => 'Навыки и инструменты';

  @override
  String get skip => 'Пропустить';

  @override
  String get slack_chats => 'Чаты Slack';

  @override
  String source(Object source) {
    return 'Источник: $source';
  }

  @override
  String get space_actions => 'Действия с пространством';

  @override
  String get spaces => 'Пространства';

  @override
  String get speak_to_hermes => 'Поговорить с Hermes';

  @override
  String get speech_recognition_is_unavailable =>
      'Распознавание речи недоступно';

  @override
  String get spoken_replies => 'Голосовые ответы';

  @override
  String get spoken_replies_off => 'Голосовые ответы выключены';

  @override
  String get spoken_replies_on => 'Голосовые ответы включены';

  @override
  String get stalled_no_update_from_hermes =>
      'Застряло — нет обновлений от Hermes';

  @override
  String get start_something_new => 'Начать что-то новое';

  @override
  String get start_voice_input => 'Начать голосовой ввод';

  @override
  String get starting_hermes => 'Запуск Hermes…';

  @override
  String get media_card_download => 'Скачать файл';

  @override
  String get media_card_tap_to_download => 'Нажмите, чтобы скачать';

  @override
  String get still_loading_your_projects => 'Ваши проекты всё ещё загружаются.';

  @override
  String get stop => 'Стоп';

  @override
  String get stop_response => 'Остановить ответ';

  @override
  String get stop_voice_input => 'Остановить голосовой ввод';

  @override
  String get submitted_waiting_for_hermes => 'Отправлено, ожидание Hermes';

  @override
  String get suggest_projects_and_learn_from_your_corrections =>
      'Предлагать проекты и учиться на ваших исправлениях';

  @override
  String get summarize_the_attached_content =>
      'Суммируйте прикреплённое содержимое.';

  @override
  String summarize_this_content(Object text) {
    return 'Суммируйте это содержимое:\n\n$text';
  }

  @override
  String get switch_profile => 'Сменить профиль';

  @override
  String get system => 'Системная';

  @override
  String get take_photo => 'Сделать фото';

  @override
  String get tap_to_add_a_remote_hermes_gateway_api_server_port =>
      'Нажмите +, чтобы добавить удалённый шлюз Hermes\n(сервер API, порт 8642)';

  @override
  String get tap_the_button_to_start_a_new_chat =>
      'Нажмите кнопку +, чтобы начать новый чат';

  @override
  String get telegram_messages => 'Сообщения Telegram';

  @override
  String get terminal_sessions => 'Сессии терминала';

  @override
  String get test_notification_body =>
      'Если вы это видите, уведомления работают.';

  @override
  String get test_notification_sent => 'Тестовое уведомление отправлено.';

  @override
  String get test_notification_title => 'Тест уведомлений Hermes';

  @override
  String get test_notification_unsupported =>
      'Не удалось отправить уведомление — проверьте, разрешены ли уведомления в системе.';

  @override
  String get text_size => 'Размер текста';

  @override
  String get text_size_preview => 'Предпросмотр размера текста';

  @override
  String text_size_2(Object label) {
    return 'Размер текста: $label';
  }

  @override
  String get the_api_key_could_not_be_stored_securely =>
      'Ключ API не удалось сохранить безопасно.';

  @override
  String get the_project_will_move_to_archived_its_chats_and_files =>
      'Проект переместится в «Архив». Его чаты и файлы останутся нетронутыми, и вы сможете восстановить его в любое время.';

  @override
  String get the_project_will_move_to_archived_its_chats_and_files_2 =>
      'Проект переместится в «Архив». Его чаты и файлы останутся нетронутыми, и вы сможете восстановить его позже.';

  @override
  String get the_active_profile_did_not_return_any_selectable_models =>
      'Активный профиль не вернул ни одной доступной модели.';

  @override
  String get the_backup_could_not_be_exported =>
      'Резервную копию не удалось экспортировать.';

  @override
  String get the_backup_could_not_be_restored =>
      'Резервную копию не удалось восстановить.';

  @override
  String get the_connection_could_not_be_deleted_safely =>
      'Подключение не удалось безопасно удалить.';

  @override
  String get the_connection_could_not_be_stored_securely =>
      'Подключение не удалось безопасно сохранить.';

  @override
  String get the_dashboard_credentials_could_not_be_stored_securely =>
      'Учётные данные панели управления не удалось безопасно сохранить.';

  @override
  String get the_detached_reply_failed =>
      'Отсоединённый ответ завершился ошибкой.';

  @override
  String the_detached_reply_failed_2(Object error) {
    return 'Отсоединённый ответ завершился ошибкой: $error';
  }

  @override
  String get the_file_contains_your_api_keys_and_dashboard_password_so =>
      'Файл содержит ваши ключи API и пароль панели управления, поэтому он зашифрован. Без этой парольной фразы резервную копию нельзя восстановить.';

  @override
  String get the_last_turn_failed => 'Последний ход завершился ошибкой';

  @override
  String the_local_connection_store_looks_damaged_you_can_reset_the(
    Object errorType,
  ) {
    return 'Локальное хранилище подключений повреждено ($errorType). Вы можете сбросить сохранённые подключения и начать заново. Чаты на вашем шлюзе не затронуты.';
  }

  @override
  String get the_model_only_rewrites_your_question_into_a_short_full =>
      'Модель лишь переписывает ваш вопрос в короткий полнотекстовый запрос. Hermes использует учётные данные провайдера, уже настроенные на хосте.';

  @override
  String get the_server_has_not_reported_folders_for_this_project_yet =>
      'Сервер ещё не сообщил папки для этого проекта. «Файлы» остаются доступными в разделе «Ещё».';

  @override
  String get the_turn_failed => 'Ход завершился ошибкой';

  @override
  String get the_two_passphrases_do_not_match =>
      'Парольные фразы не совпадают.';

  @override
  String get the_value_is_sent_directly_to_the_active_hermes_gateway =>
      'Значение отправляется напрямую активному шлюзу Hermes и не сохраняется этим приложением Android.';

  @override
  String get there_are_no_visible_files_in_this_server_folder =>
      'В этой папке сервера нет видимых файлов.';

  @override
  String get thinking_effort => 'Усилие рассуждений';

  @override
  String get this_hermes_gateway_does_not_support_opening_a_project_yet =>
      'Этот шлюз Hermes пока не поддерживает открытие проектов. Обновите Hermes на сервере, чтобы просматривать проект с телефона.';

  @override
  String get this_hermes_gateway_is_older_than_server_side_projects_so =>
      'Этот шлюз Hermes старее серверных проектов, поэтому чаты группируются только на этом устройстве. Обновите Hermes, чтобы одни и те же проекты были на всех устройствах.';

  @override
  String get this_project_has_no_folder_to_open_the_chat_in =>
      'Чтобы начать чат в этом проекте, сначала добавьте в него папку. Затем попробуйте ещё раз.';

  @override
  String get this_chat_has_no_messages_available_in_the_desktop_session =>
      'В этом чате пока нет сообщений в сессии Desktop.';

  @override
  String get this_creates_a_permanent_rule_in_hermes_review_the_full =>
      'Это создаст постоянное правило в Hermes. Проверьте полную команду перед подтверждением.';

  @override
  String get this_gateway_does_not_host_projects_yet_update_the_gateway =>
      'Этот шлюз пока не размещает проекты. Обновите шлюз, чтобы упорядочивать чаты на всех устройствах.';

  @override
  String get this_permanently_deletes_the_project_chats_will_not_be_deleted =>
      'Это навсегда удалит проект. Чаты не будут удалены — они вернутся в «Неназначенные».';

  @override
  String get this_server_doesn_t_offer_background_recovery_chats_run_live =>
      'Этот сервер не поддерживает фоновое восстановление — чаты работают в реальном времени';

  @override
  String get this_week => 'На этой неделе';

  @override
  String get titles_previews_and_models => 'Заголовки, предпросмотры и модели';

  @override
  String get tool_activity => 'Активность инструментов';

  @override
  String get trigger_now => 'Запустить сейчас';

  @override
  String get received_outcome_unknown =>
      'Ход завершён — результат не подтверждён';

  @override
  String get turn_completed => 'Ход завершён';

  @override
  String get turn_failed => 'Ход не удался';

  @override
  String get turn_failed_description => 'Фоновый ход завершился с ошибкой.';

  @override
  String get turn_recovery_failed => 'Не удалось восстановить ход';

  @override
  String get unable_to_prepare_this_file_try_another_one =>
      'Не удалось подготовить этот файл. Попробуйте другой.';

  @override
  String get unable_to_prepare_this_image_try_another_one =>
      'Не удалось подготовить это изображение. Попробуйте другое.';

  @override
  String unable_to_prepare(Object name) {
    return 'Не удалось подготовить $name.';
  }

  @override
  String get unable_to_read_the_selected_image_the_selection_was_kept =>
      'Не удалось прочитать выбранное изображение. Выбор сохранён.';

  @override
  String get unassigned => 'Неназначенные';

  @override
  String get unassigned_chats => 'Неназначенные чаты';

  @override
  String get untitled_chat => 'Чат без названия';

  @override
  String get untitled_session => 'Сессия без названия';

  @override
  String get update_api_key => 'Обновить ключ API';

  @override
  String get upload_failed => 'Ошибка отправки';

  @override
  String get upload_failed_tap_retry =>
      'Ошибка отправки • нажмите, чтобы повторить';

  @override
  String uploading(Object index, Object name, Object total) {
    return 'Отправка $index/$total: $name';
  }

  @override
  String get use_as_is => 'Использовать как есть';

  @override
  String get use_at_least_8_characters => 'Используйте не менее 8 символов.';

  @override
  String get use_for_cron_jobs_backed_by_scripts =>
      'Для задач Cron на основе скриптов.';

  @override
  String get use_on_device => 'Использовать на устройстве';

  @override
  String get use_the_attached_content_to_identify_and_fill_the_relevant =>
      'Используйте прикреплённое содержимое, чтобы определить и заполнить нужные поля документа или формы. Спрашивайте перед отправкой.';

  @override
  String use_this_content_to_identify_and_fill_the_relevant_document(
    Object text,
  ) {
    return 'Используйте это содержимое, чтобы определить и заполнить нужные поля документа или формы. Спрашивайте перед отправкой:\n\n$text';
  }

  @override
  String get used_for_hosted_path_prefixes_and_for_the_settings_memory =>
      'Используется для префиксов размещённых путей и для вкладок «Настройки», «Память», «Навыки» и «Cron». Оставьте имя пользователя и пароль пустыми для открытой панели или включите режим прокси, если обратный прокси внедряет аутентификацию панели.';

  @override
  String get username_optional => 'Имя пользователя (необязательно)';

  @override
  String using(Object displayName) {
    return 'Используется $displayName…';
  }

  @override
  String get verbose_mode => 'Подробный режим';

  @override
  String get message_metadata => 'Сведения о сообщении';

  @override
  String get voice => 'Голос';

  @override
  String voice_setup_failed(Object error) {
    return 'Ошибка настройки голоса: $error';
  }

  @override
  String get waiting_for_your_input => 'Ожидание вашего ввода';

  @override
  String get what_hermes_knows_how_to_do => 'Что Hermes умеет делать';

  @override
  String get what_should_the_agent_do => 'Что должен сделать агент?';

  @override
  String get whatsapp_messages => 'Сообщения WhatsApp';

  @override
  String get which_project => 'Какой проект?';

  @override
  String get workspace => 'Рабочая область';

  @override
  String get wrap_lines => 'Переносить строки';

  @override
  String you_can_attach_up_to_items(Object maxRemoteAttachmentDrafts) {
    return 'Можно прикрепить до $maxRemoteAttachmentDrafts элементов.';
  }

  @override
  String get your_answer => 'Ваш ответ';

  @override
  String get e_g_dashboard => 'напр. /dashboard';

  @override
  String get e_g_dashboard_proxy_path_before_api =>
      'напр. /dashboard (путь прокси перед /api/)';

  @override
  String get e_g_profile_peter => 'напр. /profile/peter';

  @override
  String get e_g_sol => 'напр. sol';

  @override
  String get e_g_0_9_or_every_2h => 'напр. 0 9 * * * или every 2h';

  @override
  String get e_g_daily_backup => 'напр. Ежедневная резервная копия';

  @override
  String downloaded(Object filename) {
    return '$filename скачан';
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
      '192.168.1.50, 100.x.y.z или hermes-machine.tailnet.ts.net';

  @override
  String get example_profile_prefix_hint_full =>
      'напр. /profile/peter (путь прокси перед /api/ и /v1/)';

  @override
  String and_more(Object count) {
    return 'и ещё $count';
  }

  @override
  String chats_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count чата',
      many: '$count чатов',
      few: '$count чата',
      one: '$count чат',
    );
    return '$_temp0';
  }

  @override
  String on_this_device_only(Object chats) {
    return '$chats · только на этом устройстве';
  }

  @override
  String spaces_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count пространства',
      many: '$count пространств',
      few: '$count пространства',
      one: '$count пространство',
    );
    return '$_temp0';
  }

  @override
  String get no_new_projects_needed => 'новые проекты не нужны';

  @override
  String projects_to_create(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count проекта для создания',
      many: '$count проектов для создания',
      few: '$count проекта для создания',
      one: '$count проект для создания',
    );
    return '$_temp0';
  }

  @override
  String chats_migrated_projects_created(
    Object createdProjects,
    Object linkedSessions,
  ) {
    return '$linkedSessions чатов перенесено · $createdProjects проектов создано';
  }

  @override
  String chats_stayed_in_local_spaces(Object unlinkedSessions) {
    return '$unlinkedSessions чатов остались в локальных пространствах, можно безопасно повторить.';
  }

  @override
  String model_recommended(Object provider) {
    return '$provider • Рекомендуется: маленькая и недорогая';
  }

  @override
  String session_meta(Object count, Object model, Object time) {
    return '$count сообщ. • $model • $time';
  }

  @override
  String model_scope_label(Object model, Object scope) {
    return '$model • $scope';
  }

  @override
  String get this_chat => 'этот чат';

  @override
  String get profile_default => 'профиль по умолчанию';

  @override
  String minutes_ago(Object count) {
    return '$count мин назад';
  }

  @override
  String hours_ago(Object count) {
    return '$count ч назад';
  }

  @override
  String days_ago(Object count) {
    return '$count дн назад';
  }

  @override
  String get now_label => 'сейчас';

  @override
  String get latest_label => 'Последнее';

  @override
  String new_count_indicator(Object count) {
    return '$count новых';
  }

  @override
  String new_messages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count нового сообщения',
      many: '$count новых сообщений',
      few: '$count новых сообщения',
      one: '$count новое сообщение',
    );
    return '$_temp0';
  }

  @override
  String activity_failed_summary(Object failures, Object total) {
    return '$failures с ошибкой • всего $total';
  }

  @override
  String activity_completed_summary(Object count) {
    return '$count завершено';
  }

  @override
  String tool_start_observed(Object time) {
    return 'Начало замечено в $time (местное время)';
  }

  @override
  String tool_last_observed(Object time) {
    return 'Последнее наблюдение в $time (местное время)';
  }

  @override
  String tool_result_recorded(Object time) {
    return 'Результат записан в $time (местное время)';
  }

  @override
  String get tool_time_unavailable => 'Время неизвестно';

  @override
  String get hermes_is_using_a_tool => 'Hermes использует инструмент';

  @override
  String hermes_is_using_tools(Object count) {
    return 'Hermes использует $count инструментов';
  }

  @override
  String delegated_tasks_completed(Object count) {
    return '$count делегированных задач выполнено';
  }

  @override
  String delegated_tasks_active(Object count) {
    return '$count делегированных задач активно';
  }

  @override
  String branch_main(Object label) {
    return '$label · main';
  }

  @override
  String get you_heading => '## Вы';

  @override
  String get hermes_heading => '## Hermes';

  @override
  String get action_label => 'Действие';

  @override
  String get destination_label => 'Назначение';

  @override
  String get markdown_source => 'Исходный текст';

  @override
  String get preview_label => 'Предпросмотр';

  @override
  String get share_action_summarize => 'Суммировать';

  @override
  String get share_action_explain => 'Объяснить';

  @override
  String get share_action_research => 'Исследовать';

  @override
  String get share_action_remember => 'Запомнить';

  @override
  String get text_size_small => 'Маленький';

  @override
  String get text_size_default => 'По умолчанию';

  @override
  String get text_size_large => 'Большой';

  @override
  String get text_size_extra_large => 'Очень большой';

  @override
  String get text_size_use_system_description =>
      'Использовать точно размер текста специальных возможностей Android.';

  @override
  String text_size_percent_description(Object percent) {
    return '$percent% от размера текста Android.';
  }

  @override
  String text_size_label_description(Object description, Object label) {
    return '$label — $description';
  }

  @override
  String files_skipped(Object count) {
    return '$count файл(ов) пропущено: лимит, размер, нечитаемый файл или конфиденциальное имя файла.';
  }

  @override
  String model_scope_applied(Object effort, Object model) {
    return '$model • $effort теперь применяются только к этому чату.';
  }

  @override
  String get reasoning_minimal => 'Минимальный';

  @override
  String get reasoning_low => 'Низкий';

  @override
  String get reasoning_medium => 'Средний';

  @override
  String get reasoning_high => 'Высокий';

  @override
  String get reasoning_max => 'Максимальный';

  @override
  String get reasoning_ultra => 'Ультра';

  @override
  String get status_running => 'Выполняется';

  @override
  String get status_failed => 'Ошибка';

  @override
  String get status_done => 'Готово';

  @override
  String get status_idle => 'Ожидание';

  @override
  String get upload_status_uploading => 'Отправка';

  @override
  String get upload_status_uploaded => 'Отправлено';

  @override
  String attachment_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вложения',
      many: '$count вложений',
      few: '$count вложения',
      one: '$count вложение',
    );
    return '$_temp0';
  }

  @override
  String get action_create => 'создать';

  @override
  String get action_rename => 'переименовать';

  @override
  String get action_archive => 'архивировать';

  @override
  String get action_restore => 'восстановить';

  @override
  String get action_delete => 'удалить';

  @override
  String get migrate => 'Перенести';

  @override
  String assigned_chats(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count назначенного чата',
      many: '$count назначенных чатов',
      few: '$count назначенных чата',
      one: '$count назначенный чат',
    );
    return '$_temp0';
  }

  @override
  String get date_today => 'Сегодня';

  @override
  String get date_yesterday => 'Вчера';

  @override
  String get date_earlier => 'Ранее';

  @override
  String get nav_home => 'Дом';

  @override
  String get nav_more => 'Ещё';

  @override
  String get status_completed => 'Завершено';

  @override
  String get filter_all => 'Все';

  @override
  String get filter_recent => 'Недавние';

  @override
  String connection_address_key(Object address, Object status) {
    return '$address  •  Ключ: $status';
  }

  @override
  String model_via_provider(Object model, Object provider) {
    return '$model  \nчерез `$provider`';
  }

  @override
  String get deny => 'Отклонить';

  @override
  String get connect => 'Подключиться';

  @override
  String get appearance => 'Внешний вид';

  @override
  String get connection_section => 'Подключение';

  @override
  String get about => 'О приложении';

  @override
  String version_label(Object version) {
    return 'Версия $version';
  }

  @override
  String get matched => 'Совпадение';

  @override
  String get search => 'Поиск';

  @override
  String get on => 'Вкл.';

  @override
  String get off => 'Выкл.';

  @override
  String get reasoning_off => 'Выкл.';

  @override
  String get hermes_response_ready => 'Ответ Hermes готов';

  @override
  String get admin_password_needed => 'Требуется пароль администратора';

  @override
  String get hermes_needs_a_sudo_password_for_the_pending_terminal_command =>
      'Hermes требует пароль sudo для ожидающей команды терминала.';

  @override
  String get sudo_password => 'Пароль sudo';

  @override
  String get secret_needed => 'Требуется секрет';

  @override
  String get hermes_needs_a_secret_for_the_pending_skill =>
      'Hermes требует секрет для ожидающего навыка.';

  @override
  String get secret_value => 'Значение секрета';

  @override
  String get attached_file => 'Прикреплённый файл';

  @override
  String get pin_chat => 'Закрепить чат';

  @override
  String get unpin_chat => 'Открепить чат';

  @override
  String get pinned_chats => 'Закреплённые';

  @override
  String could_not_update_chat_pin(Object error) {
    return 'Не удалось изменить закрепление чата: $error';
  }

  @override
  String get could_not_save_chat_spaces =>
      'Не удалось сохранить пространства чатов на этом устройстве';

  @override
  String get chat_density => 'Плотность чата';

  @override
  String chat_density_2(Object label) {
    return 'Плотность чата: $label';
  }

  @override
  String get chat_density_comfortable => 'Просторная';

  @override
  String get chat_density_compact => 'Компактная';

  @override
  String get chat_density_comfortable_description =>
      'Более просторные пузыри с подписью отправителя над каждым сообщением.';

  @override
  String get chat_density_compact_description =>
      'Более плотные пузыри без подписи — на экран помещается больше сообщений.';

  @override
  String chat_density_label_description(Object description, Object label) {
    return '$label — $description';
  }

  @override
  String
  get compact_removes_the_you_and_hermes_labels_and_trims_bubble_padding_spacing_and_side_margins =>
      'Компактный режим убирает подписи You и Hermes и уменьшает внутренние отступы, промежутки и боковые поля пузырей.';

  @override
  String get client_certificate_mtls => 'Клиентский сертификат (mTLS)';

  @override
  String get client_certificate_mtls_description =>
      'Предъявлять сертификат, если HTTPS-прокси требует взаимной аутентификации TLS.';

  @override
  String get client_certificate_https_only =>
      'Клиентские сертификаты используются только для подключений HTTPS.';

  @override
  String get choose_certificate => 'Выбрать сертификат';

  @override
  String get certificate_password => 'Пароль сертификата';

  @override
  String get this_certificate_is_password_protected =>
      'Этот сертификат защищён паролем. Он открывается по мере ввода.';

  @override
  String get enter_the_certificate_password_to_finish_loading_it =>
      'Введите пароль сертификата, чтобы завершить загрузку выбранного сертификата.';

  @override
  String get client_certificate_required =>
      'Загрузите клиентский сертификат или отключите использование клиентского сертификата.';

  @override
  String client_certificate_loaded(String label) {
    return 'Загружен: $label';
  }

  @override
  String get remove_certificate => 'Удалить сертификат';

  @override
  String get certificate_import_failed =>
      'Не удалось загрузить этот сертификат.';

  @override
  String get background_work => 'Фоновая работа';

  @override
  String get keep_chats_active_in_background =>
      'Поддерживать чаты в фоновом режиме';

  @override
  String get background_work_description =>
      'Поддерживает соединение в начатых вами чатах, пока приложение работает в фоне. Неактивные соединения могут отключаться. Увеличивает расход батареи и трафика. Отключение не останавливает работу на сервере.';

  @override
  String get background_work_limits =>
      'Android всё равно может приостановить соединения в режиме Doze или завершить процесс приложения. Для уведомлений после завершения процесса нужна отдельная настройка push. Принудительная остановка не поддерживается.';

  @override
  String get background_work_disclosure =>
      'Пока фоновая защита активна, обязательное уведомление службы остаётся видимым, даже если необязательные уведомления чатов отключены.';

  @override
  String get battery_optimisation_settings => 'Настройки оптимизации батареи';

  @override
  String get battery_optimisation_description =>
      'Открывает настройки Android для проверки ограничений батареи. Исключение не запрашивается автоматически, а изменение настроек не гарантирует доставку.';

  @override
  String get battery_settings_unavailable =>
      'Не удалось открыть настройки батареи на этом устройстве.';

  @override
  String get background_work_save_failed =>
      'Не удалось сохранить настройку фоновой работы.';

  @override
  String get ongoing_chat_channel_name => 'Активные чаты';

  @override
  String get ongoing_chat_channel_description =>
      'Тихие обновления состояния незавершённых чатов, начатых вами';

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
  String get activity_status_unconfirmed => 'Статус не подтверждён';

  @override
  String get activity_recently_updated => 'Недавно обновлено';

  @override
  String get activity_reconnecting => 'Переподключение — проверка статуса хода';

  @override
  String get activity_outcome_unknown =>
      'Не удалось подтвердить результат хода. Откройте чат для проверки.';

  @override
  String get activity_chat_updated_detail =>
      'Активность чата записана шлюзом; текущий статус хода недоступен.';

  @override
  String get activity_updated => 'Обновлено';

  @override
  String get activity_empty_title => 'Нет недавней активности';

  @override
  String get activity_empty_detail =>
      'Здесь отображаются ходы, начатые в этом приложении, и чаты шлюза, обновлённые за последние 7 дней.';

  @override
  String get activity_read_error =>
      'Раздел «Активность» не смог прочитать записи ходов или чаты шлюза. Проверьте подключение и повторите попытку.';

  @override
  String get activity_chat_unavailable =>
      'Этот чат больше недоступен или не удалось связаться со шлюзом.';

  @override
  String get activity_partial_title => 'Активность загружена частично';

  @override
  String get activity_partial_detail =>
      'Показана ограниченная часть активности шлюза. Могут существовать другие чаты; потяните вниз для обновления.';

  @override
  String get provider_usage => 'Записанное использование';

  @override
  String get provider_usage_notice =>
      'Использование Hermes за 30 дней, не баланс и не цены. Настройте учётные данные на сервере Hermes: приложение не хранит API-ключи провайдеров.';

  @override
  String get provider_usage_failed => 'Не удалось загрузить использование.';

  @override
  String get provider_usage_empty =>
      'Нет записанного использования этого провайдера.';

  @override
  String provider_usage_counts(String sessions, String input, String output) {
    return 'Сеансов: $sessions · Ввод: $input · Вывод: $output';
  }

  @override
  String provider_usage_costs(String estimated, String actual) {
    return 'Оценка: $estimated · Отчёт: $actual';
  }

  @override
  String get provider_quota_codex => 'Подписка OpenAI Codex';

  @override
  String get provider_quota_claude => 'Подписка Claude';

  @override
  String get provider_quota_openai_api => 'Учтённое использование API OpenAI';

  @override
  String get provider_quota_notice =>
      'Периоды подписки, указанные провайдером, отдельно от использования, учтённого Hermes, и оплаты API. Аккаунты отображаются отдельно; достижение лимита модели не означает исчерпания всей квоты аккаунта.';

  @override
  String get provider_quota_windows_notice =>
      'Для подписок Codex и Claude действуют лимиты на пятичасовой сеанс и на неделю. Отображаются только периоды, указанные провайдером; отсутствующие лимиты и время сброса остаются недоступными. Недельные лимиты могут относиться ко всему аккаунту или к отдельным моделям.';

  @override
  String get provider_quota_five_hour_session => '5-часовой сеанс';

  @override
  String get provider_quota_unavailable => 'Квота подписки недоступна.';

  @override
  String get provider_quota_failed =>
      'Не удалось обновить квоту подписки. Сохранённые значения получены при предыдущем запросе.';

  @override
  String get provider_quota_account => 'Аккаунт';

  @override
  String get provider_quota_unknown => 'неизвестно';

  @override
  String provider_quota_state(String state) {
    return 'Состояние аккаунта: $state';
  }

  @override
  String provider_quota_scope(String scope) {
    return 'Область действия: $scope';
  }

  @override
  String provider_quota_percent(String used, String remaining) {
    return '$used% использовано · $remaining% осталось';
  }

  @override
  String provider_quota_reset(String reset) {
    return 'Сброс: $reset';
  }

  @override
  String get provider_quota_reset_unknown => 'Время сброса недоступно.';

  @override
  String get auxiliary_models => 'Вспомогательные модели';

  @override
  String get auxiliary_notice =>
      'Выберите модели для задач. Пользовательские адреса настраиваются на сервере. Авто следует правилам наследования задачи.';

  @override
  String get auxiliary_inherit => 'Авто (наследовать)';

  @override
  String get auxiliary_unavailable => 'Вспомогательные настройки недоступны.';

  @override
  String get provider_oauth_title => 'Вход у провайдера';

  @override
  String get provider_oauth_more_subtitle =>
      'Управление входом у провайдеров на хосте Hermes';

  @override
  String get provider_oauth_settings_subtitle =>
      'Войдите на хосте Hermes; токены провайдера не сохраняются на этом устройстве';

  @override
  String get provider_oauth_intro =>
      'Войдите у провайдера во внешнем браузере. Токены сохраняются только на хосте Hermes, а не на этом устройстве. Вход не выбирает модель чата в этом приложении.';

  @override
  String get provider_oauth_defaults_notice =>
      'Некоторые процессы на хосте, включая замену бесплатного аккаунта Nous, могут менять настройки хоста по умолчанию. Проверьте настройки хоста после входа.';

  @override
  String get provider_oauth_transport_init_failed =>
      'Не удалось инициализировать выбранное защищённое соединение с панелью. Проверьте идентификатор TLS и настройки подключения.';

  @override
  String get provider_oauth_https_required =>
      'Для входа у провайдера требуется HTTPS-соединение с панелью Hermes.';

  @override
  String get provider_oauth_auth_required =>
      'Перед входом настройте аутентификацию паролем панели или доверенный прокси.';

  @override
  String get provider_oauth_catalog_failed =>
      'Вход у провайдера недоступен на этом хосте. Проверьте аутентификацию панели и обновите хост, если он не поддерживает OAuth провайдеров.';

  @override
  String get provider_oauth_expired =>
      'Время для входа истекло. Начните заново.';

  @override
  String get provider_oauth_start_failed =>
      'Не удалось начать защищённый вход у провайдера. Повторите попытку.';

  @override
  String get provider_oauth_denied => 'Вход отклонён. Начните заново.';

  @override
  String get provider_oauth_cancelled => 'Вход отменён.';

  @override
  String get provider_oauth_host_failed =>
      'Хост не смог завершить вход. Начните заново.';

  @override
  String get provider_oauth_poll_failed =>
      'Не удалось проверить состояние входа. Начните заново.';

  @override
  String provider_oauth_cancellation_unconfirmed(String message) {
    return '$message Не удалось подтвердить отмену; сеанс на хосте может продолжаться до истечения срока действия.';
  }

  @override
  String get provider_oauth_browser_failed =>
      'Не удалось открыть внешний браузер. Повторите попытку или отмените вход.';

  @override
  String get provider_oauth_retry => 'Повторить';

  @override
  String provider_oauth_complete(String provider) {
    return 'Завершите вход в $provider';
  }

  @override
  String get provider_oauth_code_instruction =>
      'Введите этот временный код на странице провайдера:';

  @override
  String get provider_oauth_waiting =>
      'Ожидание подтверждения. Срок действия этого сеанса истечёт автоматически.';

  @override
  String get provider_oauth_open_browser => 'Открыть провайдера в браузере';

  @override
  String get provider_oauth_cancel => 'Отменить вход';

  @override
  String get provider_oauth_signed_out => 'Вход на хосте не выполнен';

  @override
  String get provider_oauth_sign_in_again => 'Войти снова';

  @override
  String get provider_oauth_sign_in => 'Войти';

  @override
  String get provider_oauth_cli_required =>
      'Войдите через CLI провайдера на хосте Hermes. Этот хост не поддерживает вход в приложении для данного провайдера.';

  @override
  String get provider_oauth_checking_account =>
      'Одобрение получено. Проверяем аккаунт на хосте…';

  @override
  String get provider_oauth_verification_unavailable =>
      'Одобрение получено; проверка аккаунта недоступна. Откройте раздел использования, чтобы обновить данные аккаунта.';

  @override
  String provider_oauth_verified_account(String email) {
    return 'Вход на хосте Hermes выполнен как $email. Откройте раздел использования, чтобы обновить данные аккаунта.';
  }

  @override
  String get provider_oauth_credentials_unverified =>
      'Хост сообщает о наличии учётных данных; личность владельца аккаунта не проверена.';

  @override
  String get provider_oauth_account_status_unknown =>
      'Статус аккаунта на хосте недоступен.';

  @override
  String get app_language => 'Язык приложения';

  @override
  String get app_language_system => 'Как на телефоне';

  @override
  String get auto_archives_after_72_hours =>
      'Автоматически архивируется через 72 часа';

  @override
  String get automation => 'Автоматизация';

  @override
  String get voice_recording_start => 'Записать голосовое сообщение';

  @override
  String get voice_recording_pause => 'Приостановить запись';

  @override
  String get voice_recording_preview => 'Воспроизвести запись';

  @override
  String get voice_recording_resume => 'Продолжить запись';

  @override
  String get voice_recording_send => 'Отправить голосовое сообщение';

  @override
  String get voice_recording_discard => 'Удалить запись';

  @override
  String get voice_recording_processing => 'Подготовка голосового сообщения…';

  @override
  String voice_recording_elapsed(String time) {
    return 'Запись $time';
  }

  @override
  String voice_recording_draft(String time) {
    return 'Голосовое сообщение $time';
  }

  @override
  String get voice_recording_permission =>
      'Разрешите доступ к микрофону для записи голосового сообщения.';

  @override
  String get voice_recording_limit => 'Достигнут лимит записи в десять минут.';

  @override
  String get voice_recording_empty => 'Звук не записан. Попробуйте ещё раз.';

  @override
  String get voice_recording_failed =>
      'Не удалось обработать запись. Все сохранённые фрагменты оставлены.';

  @override
  String get voice_recording_unconfirmed =>
      'Доставка не подтверждена. Запись сохранена. Проверьте чат, прежде чем повторять попытку.';

  @override
  String get voice_recording_submit_failed =>
      'Не удалось отправить голосовое сообщение. Запись сохранена. Проверьте подключение, доступ к панели управления и настройки расшифровки на сервере.';

  @override
  String get voice_recording_pause_playback => 'Приостановить воспроизведение';

  @override
  String get projects_root_title => 'Папка проектов на сервере';

  @override
  String get projects_root_more_subtitle =>
      'Где на сервере создаются новые папки проектов';

  @override
  String get projects_root_description =>
      'Проекты, созданные на этом телефоне, получают папку здесь. Укажите папку, которую использует сам Hermes, чтобы телефон и сервер видели одни и те же проекты.';

  @override
  String get projects_root_label => 'Корневой путь проектов';

  @override
  String projects_root_default_hint(String path) {
    return 'По умолчанию на сервере: $path';
  }

  @override
  String get projects_root_locked_title => 'Задано сервером';

  @override
  String get projects_root_locked_explanation =>
      'Этот сервер ограничивает доступ к файлам одним корнем, поэтому папку проектов нельзя изменить из приложения.';

  @override
  String get projects_root_saved => 'Папка проектов сохранена.';

  @override
  String get projects_root_reset =>
      'Использовать значение сервера по умолчанию';

  @override
  String get projects_root_invalid_empty => 'Введите путь к папке.';

  @override
  String get projects_root_invalid_absolute =>
      'Введите абсолютный путь, начинающийся с косой черты.';

  @override
  String get projects_root_invalid_segments =>
      'Удалите из пути точечные сегменты и управляющие символы.';

  @override
  String get projects_root_unsupported =>
      'Не поддерживается для этого подключения. Чтобы прочитать или изменить папку проектов на сервере, нужно подключение Desktop Gateway с доступом к панели управления.';

  @override
  String get projects_root_unavailable =>
      'Не удалось прочитать папку проектов на сервере. Проверьте подключение к панели управления и повторите попытку.';

  @override
  String get adopt_folder_action => 'Добавить существующую папку';

  @override
  String adopt_folder_description(String root) {
    return 'Папки в $root, которые ещё не зарегистрированы как проект.';
  }

  @override
  String adopt_folder_registered(String name) {
    return 'Уже проект: $name';
  }

  @override
  String get adopt_folder_none =>
      'Все папки по этому пути уже являются проектами.';

  @override
  String get adopt_folder_unsupported =>
      'Это подключение не может получить список папок на сервере. Введите абсолютный путь к существующей папке.';

  @override
  String adopt_folder_failed(String error) {
    return 'Не удалось получить список папок на сервере: $error';
  }

  @override
  String get adopt_folder_manual_label => 'Путь к существующей папке';

  @override
  String get adopt_folder_name_label => 'Название проекта';

  @override
  String get adopt_folder_add => 'Добавить как проект';

  @override
  String adopt_folder_added(String name, String path) {
    return '$name теперь использует $path';
  }

  @override
  String adopt_folder_error(String error) {
    return 'Не удалось добавить папку: $error';
  }

  @override
  String adopt_folder_folderless(String name) {
    return 'Проект $name создан, но папка не была прикреплена. Прикрепите её в Hermes на сервере.';
  }

  @override
  String get slash_commands => 'Slash commands';

  @override
  String get slash_commands_loading => 'Loading commands…';

  @override
  String get slash_commands_empty => 'No matching commands';

  @override
  String slash_command_info_alias(String alias, String command) {
    return '$alias — псевдоним для $command';
  }

  @override
  String get slash_command_info_no_description => 'Описание недоступно.';

  @override
  String get slash_command_info_arguments_options =>
      'Принимает один из фиксированных вариантов.';

  @override
  String get slash_command_info_arguments_text =>
      'Принимает текст после команды.';

  @override
  String get slash_command_info_arguments_mixed =>
      'Принимает вариант или текст после команды.';

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
      'Эта команда недоступна на этом сервере.';

  @override
  String get slash_sessions_inline =>
      'Откройте список сессий, чтобы выбрать чат. Черновик сохранён.';

  @override
  String get composer_snippets => 'Шаблоны промптов';

  @override
  String get composer_snippets_description =>
      'Выберите начальный промпт для вставки в поле ввода.';

  @override
  String get composer_snippet_review => 'Ревью кода';

  @override
  String get composer_snippet_review_body =>
      'Проверьте текущее изменение на регрессии, упущенные граничные случаи и недостающие тесты.';

  @override
  String get composer_snippet_review_text =>
      'Проверь, пожалуйста, этот код на ошибки, регрессии и недостающие тесты.';

  @override
  String get composer_snippet_plan => 'План реализации';

  @override
  String get composer_snippet_plan_body =>
      'Наметьте подход до изменения кода, чтобы не выходить за рамки задачи.';

  @override
  String get composer_snippet_plan_text =>
      'Составь, пожалуйста, краткий план реализации перед изменением кода.';

  @override
  String get composer_snippet_explain => 'Объяснить это';

  @override
  String get composer_snippet_explain_body =>
      'Разберите, как работает выбранный код, и укажите ключевые файлы.';

  @override
  String get composer_snippet_explain_text =>
      'Объясни, пожалуйста, как это работает, и укажи ключевые файлы.';

  @override
  String get composer_status => 'Статус';

  @override
  String get composer_status_context => 'Контекст';

  @override
  String get composer_status_cache => 'Попадание в кэш';

  @override
  String get composer_status_throughput => 'Выходных токенов/с';

  @override
  String get composer_status_running => 'Выполняется';

  @override
  String get composer_status_session => 'Сессия';

  @override
  String get composer_status_not_reported => 'Не сообщается';

  @override
  String get composer_status_empty => 'Разбивка контекста не получена.';

  @override
  String get composer_status_loading => 'Загрузка разбивки контекста';

  @override
  String get composer_status_reset => 'Сбросить строку состояния';

  @override
  String get composer_resume_title => 'Продолжить чат';

  @override
  String get composer_resume_search => 'Поиск по названиям и ID';

  @override
  String get composer_resume_empty => 'Подходящих чатов нет.';

  @override
  String get composer_resume_unavailable =>
      'В этой панели нет списка чатов для поиска.';

  @override
  String get composer_failure_retry => 'Повторить';

  @override
  String composer_failure_retry_at(String time) {
    return 'Повторить в $time';
  }

  @override
  String get composer_failure_compress => 'Сжать';

  @override
  String get composer_failure_switch_model => 'Сменить модель';

  @override
  String composer_failure_switch_to(String model) {
    return 'Переключиться на $model';
  }

  @override
  String get composer_failure_new_chat => 'Новый чат';

  @override
  String get composer_failure_edit => 'Изменить сообщение';

  @override
  String get composer_failure_details => 'Подробности';

  @override
  String get composer_failure_hide_details => 'Скрыть подробности';

  @override
  String get composer_failure_copy => 'Скопировать диагностику';

  @override
  String get composer_failure_account =>
      'Другой способ исправления требует действий в учётной записи шлюза. В этом чате это сделать нельзя.';

  @override
  String get composer_failure_account_only =>
      'Это нужно исправить в учётной записи шлюза. В этом чате это сделать нельзя.';

  @override
  String get composer_failure_confirm_compress =>
      'Сжать этот чат? Шлюз сократит переписку.';

  @override
  String composer_failure_confirm_model(String model) {
    return 'Переключить этот чат на $model?';
  }

  @override
  String get composer_drop_attach => 'Перетащите, чтобы прикрепить';

  @override
  String get composer_drop_folder_unsupported =>
      'Папки прикреплять нельзя. Перетащите файлы из них.';

  @override
  String get composer_drop_reference => 'Перетащите, чтобы добавить ссылку';

  @override
  String get composer_reference_copy => 'Скопировать ссылку';

  @override
  String get composer_reference_remove => 'Удалить ссылку';

  @override
  String get composer_btw_usage =>
      'Использование: /btw <question> — ответ по снимку этой беседы без её прерывания.';

  @override
  String get composer_background_usage =>
      'Использование: /background <prompt> — задача выполняется отдельно, а результат возвращается сюда.';

  @override
  String get composer_handoff_usage =>
      'Использование: /handoff <platform> — передать этот чат на указанную платформу обмена сообщениями.';

  @override
  String get composer_command_needs_session =>
      'Для этой команды нужен открытый чат.';

  @override
  String get composer_retry_not_found =>
      'Этого хода нет в сохранённой истории, поэтому действие «Повторить» не может его заменить. Ничего не отправлено повторно. Измените сообщение и отправьте его для новой попытки.';

  @override
  String get composer_retry_unavailable =>
      'Действие «Повторить» не может заменить ход при этом подключении, поэтому ничего не отправлено повторно. Измените сообщение и отправьте его для новой попытки.';

  @override
  String get composer_failure_switch_no_retry =>
      'Переключение меняет только модель: это подключение не может повторить неудавшийся ход. Отправьте его снова после переключения.';

  @override
  String get composer_command_needs_gateway_session =>
      'У этого чата ещё нет сессии на шлюзе. Сначала отправьте сообщение, затем повторите команду.';

  @override
  String get composer_side_question => 'btw — ответ по снимку беседы';

  @override
  String composer_side_question_id(String id) {
    return 'btw $id — ответ по снимку беседы';
  }

  @override
  String get composer_background_started =>
      'Фоновая задача запущена. Можно продолжать чат. Результат появится здесь.';

  @override
  String composer_background_started_id(String id) {
    return 'Фоновая задача $id запущена. Можно продолжать чат. Результат появится здесь.';
  }

  @override
  String composer_handoff_requested(String platform) {
    return 'Запрошена передача на $platform.';
  }

  @override
  String composer_handoff_done(String platform) {
    return 'Этот чат передан на $platform.';
  }

  @override
  String get composer_handoff_failed => 'Не удалось передать чат.';

  @override
  String get composer_handoff_timeout =>
      'Передача не завершена. Возможно, она ещё выполняется на шлюзе.';

  @override
  String get composer_compress_done => 'Этот чат сжат.';

  @override
  String get composer_file_missing => 'Этого файла нет на устройстве.';

  @override
  String get composer_attach_busy =>
      'Вложения можно будет добавить после завершения этого ответа.';

  @override
  String get nextgen_toggle => 'Интерфейс NextGen';

  @override
  String get nextgen_toggle_subtitle =>
      'Новый дизайн с единым входом, живыми чатами и поиском в сети. Шлюзы и чаты общие с этим интерфейсом.';

  @override
  String get nextgen_single_login => 'Войти с одним логином';

  @override
  String get nextgen_single_login_subtitle =>
      'Добавьте шлюз, указав только адрес панели и выполнив один вход.';

  @override
  String get ng_allow_this_command => 'Разрешить эту команду?';

  @override
  String ng_hermes_wants_to_run_this_with(Object tool) {
    return 'Hermes хочет выполнить это с помощью $tool.';
  }

  @override
  String get ng_hermes_wants_to_run_this => 'Hermes хочет выполнить это.';

  @override
  String get ng_hermes_has_a_question => 'У Hermes есть вопрос';

  @override
  String get ng_hermes_has_questions => 'У Hermes есть вопросы';

  @override
  String get ng_password_for_sudo => 'Пароль для sudo';

  @override
  String get ng_hermes_needs_your_sudo_password_to =>
      'Hermes нужен ваш пароль sudo, чтобы выполнить эту команду.';

  @override
  String get ng_a_secret_value => 'Секретное значение';

  @override
  String ng_value_for(Object variable) {
    return 'Значение для $variable';
  }

  @override
  String get ng_your_password_manager => 'ваш менеджер паролей';

  @override
  String ng_unlock(Object name) {
    return 'Разблокировать $name';
  }

  @override
  String ng_hermes_needs_unlocked_to_sign_in(Object name) {
    return 'Чтобы войти за вас, Hermes нужно разблокировать $name.';
  }

  @override
  String get ng_sign_in_code => 'Код для входа';

  @override
  String get ng_enter_the_sign_in_code => 'Введите код для входа.';

  @override
  String ng_enter_the_sign_in_code_for(Object site) {
    return 'Введите код для входа на сайт $site.';
  }

  @override
  String get ng_save_a_login => 'Сохранить данные для входа?';

  @override
  String ng_save_your_login(Object site) {
    return 'Сохранить данные для входа на сайт $site?';
  }

  @override
  String ng_couldn_t_load_this_chat(Object error) {
    return 'Не удалось загрузить этот чат: $error';
  }

  @override
  String ng_live_updates_are_unavailable(Object error) {
    return 'Обновления в реальном времени недоступны: $error';
  }

  @override
  String ng_preparing(Object name) {
    return 'Подготовка $name…';
  }

  @override
  String get ng_the_turn_failed => 'Не удалось выполнить запрос.';

  @override
  String get ng_turn_changed =>
      'этот запрос уже завершился или начался более новый';

  @override
  String get ng_steer_rejected => 'выполняющийся запрос не принял это';

  @override
  String get ng_turn_not_known_yet =>
      'выполняющийся запрос пока неизвестен; повторите попытку через мгновение';

  @override
  String ng_couldn_t_stop(Object error) {
    return 'Не удалось остановить: $error';
  }

  @override
  String get ng_server_access => 'Доступ к серверу';

  @override
  String get ng_sign_in => 'Вход';

  @override
  String get ng_live_connection => 'Подключение в реальном времени';

  @override
  String get ng_check_that_tailscale_is_on_on =>
      'Убедитесь, что Tailscale включён и на этом телефоне, и на сервере.';

  @override
  String get ng_check_the_address_and_that_the =>
      'Проверьте адрес и убедитесь, что прокси перенаправляет запросы на панель управления.';

  @override
  String get ng_use_the_same_network_as_the =>
      'Подключитесь к той же сети, что и сервер, и запустите панель управления с параметром --host 0.0.0.0, чтобы другие устройства могли к ней подключиться.';

  @override
  String get ng_check_the_address_vpn_or_tailscale =>
      'Проверьте адрес, VPN или подключение Tailscale.';

  @override
  String get ng_not_checked_yet => 'Ещё не проверено.';

  @override
  String get ng_checking => 'Проверка…';

  @override
  String ng_hermes_answers_at(Object version, Object address) {
    return 'Hermes $version доступен по адресу $address.';
  }

  @override
  String get ng_something_answered_but_not_a_hermes =>
      'Сервер ответил, но это не панель управления Hermes.';

  @override
  String ng_something_answered_http_but_not_a(Object status) {
    return 'Сервер ответил (HTTP $status), но это не панель управления Hermes.';
  }

  @override
  String get ng_use_the_dashboard_s_address_and =>
      'Укажите адрес и порт панели управления (по умолчанию 9119), а не API-сервера.';

  @override
  String get ng_cloudflare_access_turned_the_service_token =>
      'Cloudflare Access отклонил сервисный токен.';

  @override
  String get ng_cloudflare_access_is_in_front_of =>
      'Перед этим адресом настроен Cloudflare Access.';

  @override
  String get ng_check_the_service_token_and_its =>
      'Проверьте сервисный токен и политику Service Auth.';

  @override
  String get ng_add_a_cloudflare_access_service_token =>
      'Добавьте сервисный токен Cloudflare Access для этого адреса.';

  @override
  String get ng_the_server_asks_for_a_client =>
      'Сервер запрашивает клиентский сертификат.';

  @override
  String get ng_pick_the_client_certificate_for_this =>
      'Выберите клиентский сертификат для этого шлюза и проверьте подключение ещё раз.';

  @override
  String get ng_needs_server_access_first => 'Сначала нужен доступ к серверу.';

  @override
  String get ng_needs_a_sign_in_first => 'Сначала нужно войти.';

  @override
  String ng_signed_in_as(Object name) {
    return 'Вы вошли как $name.';
  }

  @override
  String get ng_this_dashboard_doesn_t_need_a =>
      'Для этой панели управления вход не требуется.';

  @override
  String get ng_the_saved_sign_in_has_expired =>
      'Срок действия сохранённого входа истёк.';

  @override
  String get ng_sign_in_again => 'Войдите ещё раз.';

  @override
  String get ng_too_many_sign_in_attempts => 'Слишком много попыток входа.';

  @override
  String get ng_wait_a_minute_then_check_again =>
      'Подождите минуту и проверьте ещё раз.';

  @override
  String ng_the_gateway_answered(Object message) {
    return 'Ответ шлюза: $message.';
  }

  @override
  String get ng_sign_in_again_or_update_hermes =>
      'Войдите ещё раз или обновите Hermes.';

  @override
  String ng_couldn_t_check_the_sign_in(Object error) {
    return 'Не удалось проверить вход: $error';
  }

  @override
  String ng_the_gateway_wouldn_t_issue_a(Object message) {
    return 'Шлюз не выдал токен для чата ($message).';
  }

  @override
  String get ng_the_chat_connection_opened_and_the =>
      'Подключение к чату установлено, шлюз сообщил о готовности.';

  @override
  String get ng_the_gateway_never_said_it_was =>
      'Шлюз так и не сообщил о готовности.';

  @override
  String get ng_check_that_the_agent_is_running =>
      'Убедитесь, что агент запущен на сервере.';

  @override
  String get ng_the_gateway_refused_the_chat_connection =>
      'Шлюз отклонил подключение к чату (HTTP 403).';

  @override
  String get ng_this_dashboard_has_no_chat_endpoint =>
      'В этой панели управления нет конечной точки чата (/api/ws).';

  @override
  String ng_the_chat_connection_failed(Object detail) {
    return 'Не удалось подключиться к чату: $detail';
  }

  @override
  String get ng_use_the_exact_address_the_dashboard =>
      'Используйте точный адрес, настроенный для панели управления.';

  @override
  String get ng_update_hermes => 'Обновите Hermes.';

  @override
  String get ng_make_sure_the_proxy_allows_websocket =>
      'Убедитесь, что прокси поддерживает обновление соединения WebSocket на /api/ws.';

  @override
  String get ng_offline => 'Не в сети';

  @override
  String get ng_connecting => 'Подключение…';

  @override
  String get ng_connected => 'Подключено';

  @override
  String get ng_reconnecting => 'Повторное подключение…';

  @override
  String get ng_signed_out => 'Вы вышли из системы';

  @override
  String get ng_connection_failed => 'Не удалось подключиться';

  @override
  String get ng_rate_limited_by_gateway => 'Шлюз ограничил частоту запросов';

  @override
  String ng_couldn_t_open_the_chat_connection(Object message) {
    return 'Не удалось открыть подключение к чату: $message';
  }

  @override
  String get ng_the_gateway_returned_no_websocket_ticket =>
      'Шлюз не вернул билет WebSocket.';

  @override
  String get ng_connection_lost => 'Соединение потеряно';

  @override
  String get ng_this_dashboard_has_no_chat_endpoint_2 =>
      'У этой панели нет конечной точки чата (/api/ws). Обновите Hermes.';

  @override
  String get ng_the_gateway_refused_the_chat_connection_2 =>
      'Шлюз отклонил подключение к чату. Проверьте, совпадает ли адрес с настроенным адресом панели и включён ли встроенный чат.';

  @override
  String ng_the_gateway_refused(Object method) {
    return 'Шлюз отклонил запрос $method.';
  }

  @override
  String ng_couldn_t_read_your_saved_gateways(Object error) {
    return 'Не удалось прочитать сохранённые шлюзы: $error';
  }

  @override
  String get ng_applies_to_new_chats => 'Применяется к новым чатам';

  @override
  String ng_couldn_t_change(Object label, Object error) {
    return 'Не удалось изменить $label: $error';
  }

  @override
  String get ng_capabilities => 'Возможности';

  @override
  String get ng_skills => 'Навыки';

  @override
  String get ng_toolsets => 'Наборы инструментов';

  @override
  String get ng_search => 'Поиск';

  @override
  String get ng_couldn_t_load => 'Не удалось загрузить';

  @override
  String get ng_try_again => 'Повторить';

  @override
  String get ng_no_skills => 'Нет навыков';

  @override
  String get ng_no_toolsets => 'Нет наборов инструментов';

  @override
  String get ng_no_mcp_servers => 'Нет серверов MCP';

  @override
  String get ng_that_file_is_too_large_to =>
      'Этот файл слишком велик, чтобы быть сертификатом.';

  @override
  String ng_the_certificate_couldn_t_be_imported(Object error) {
    return 'Не удалось импортировать сертификат: $error';
  }

  @override
  String get ng_now_pick_its_private_key => 'Теперь выберите закрытый ключ.';

  @override
  String get ng_now_pick_its_certificate => 'Теперь выберите сертификат.';

  @override
  String get ng_that_file_isn_t_a_certificate =>
      'Этот файл не является сертификатом или закрытым ключом.';

  @override
  String get ng_if_a_proxy_in_front_of =>
      'Если прокси перед этим адресом запрашивает клиентский сертификат, выберите его здесь — он будет использоваться при проверке, входе в систему и подключении к чату.';

  @override
  String get ng_client_certificates_are_only_used_with =>
      'Клиентские сертификаты используются только с адресами https://.';

  @override
  String get ng_remove => 'Удалить';

  @override
  String get ng_certificate_password => 'Пароль сертификата';

  @override
  String get ng_importing => 'Импорт…';

  @override
  String get ng_pick_certificate => 'Выбрать сертификат';

  @override
  String get ng_pick_a_different_certificate => 'Выбрать другой сертификат';

  @override
  String get ng_accepts_p12_pfx_or_pem_certificate =>
      'Поддерживаются файлы .p12/.pfx или сертификат и ключ в формате PEM. Ключ хранится в защищённом хранилище приложения.';

  @override
  String get ng_photos => 'Фото';

  @override
  String get ng_camera => 'Камера';

  @override
  String get ng_files => 'Файлы';

  @override
  String ng_you_can_attach_up_to_files(Object count) {
    return 'Можно прикрепить до $count файлов.';
  }

  @override
  String ng_couldn_t_read(Object name) {
    return 'Не удалось прочитать $name.';
  }

  @override
  String ng_couldn_t_prepare_that_file(Object error) {
    return 'Не удалось подготовить файл: $error';
  }

  @override
  String get ng_hermes_is_still_working => 'Hermes ещё работает';

  @override
  String get ng_steer => 'Направить';

  @override
  String get ng_adds_this_to_the_running_turn =>
      'Добавляет это в текущий ответ на следующем шаге';

  @override
  String get ng_queue => 'В очередь';

  @override
  String get ng_sends_it_when_the_turn_finishes =>
      'Отправляет это после завершения текущего ответа';

  @override
  String get ng_stop_and_send => 'Остановить и отправить';

  @override
  String get ng_stops_the_turn_then_sends_this =>
      'Останавливает текущий ответ и отправляет это';

  @override
  String ng_dictation_stopped(Object message) {
    return 'Диктовка остановлена: $message';
  }

  @override
  String get ng_speech_recognition_isn_t_available =>
      'Распознавание речи недоступно.';

  @override
  String get ng_working => 'Работает';

  @override
  String get ng_ready => 'Готово';

  @override
  String get ng_chats => 'Чаты';

  @override
  String get ng_new_chat => 'Новый чат';

  @override
  String get ng_usage => 'Использование';

  @override
  String get ng_rename_chat => 'Переименовать чат';

  @override
  String ng_couldn_t_rename(Object error) {
    return 'Не удалось переименовать: $error';
  }

  @override
  String get ng_this_chat => 'Этот чат';

  @override
  String get ng_input_tokens => 'Входные токены';

  @override
  String get ng_output_tokens => 'Выходные токены';

  @override
  String get ng_reasoning_tokens => 'Токены рассуждений';

  @override
  String get ng_cache_reads => 'Чтения из кэша';

  @override
  String get ng_api_calls => 'Вызовы API';

  @override
  String get ng_cost => 'Стоимость';

  @override
  String get ng_context => 'Контекст';

  @override
  String get ng_your_sign_in_expired => 'Срок действия входа истёк.';

  @override
  String get ng_sign_in_2 => 'Войти';

  @override
  String get ng_retry => 'Повторить';

  @override
  String get ng_project_home => 'Главная';

  @override
  String get ng_choose_project => 'Выбрать проект';

  @override
  String ng_project_cwd_fallback(String path) {
    return 'Папка проекта недоступна, поэтому этот чат работает в $path.';
  }

  @override
  String get ng_project_create_uncertain =>
      'Шлюз мог создать этот чат, но не подтвердил это. Проверьте список чатов, прежде чем начинать новый. Запрос не будет повторён автоматически.';

  @override
  String get ng_what_should_we_work_on => 'Над чем поработаем?';

  @override
  String get ng_ask_hermes_anything_it_can_run =>
      'Спросите Hermes о чём угодно. Он умеет запускать инструменты, просматривать сайты и работать с файлами на сервере.';

  @override
  String ng_working_2(Object frame) {
    return 'Работает · $frame';
  }

  @override
  String get ng_default_model => 'Модель по умолчанию';

  @override
  String get ng_listening => 'Слушаю…';

  @override
  String get ng_steer_or_queue_a_message =>
      'Направьте ответ или добавьте сообщение в очередь';

  @override
  String get ng_message_hermes => 'Сообщение для Hermes';

  @override
  String get ng_attach => 'Прикрепить';

  @override
  String get ng_stop_dictation => 'Остановить диктовку';

  @override
  String get ng_dictate => 'Диктовать';

  @override
  String get ng_stop => 'Остановить';

  @override
  String get ng_send => 'Отправить';

  @override
  String ng_slash_command_alias(String alias, String command) {
    return '$alias — псевдоним для $command';
  }

  @override
  String get ng_slash_command_no_description => 'Описание недоступно.';

  @override
  String get ng_slash_command_arguments_options =>
      'Принимает один из фиксированных вариантов.';

  @override
  String get ng_slash_command_arguments_text =>
      'Принимает текст после команды.';

  @override
  String get ng_slash_command_arguments_mixed =>
      'Принимает вариант или текст после команды.';

  @override
  String get ng_slash_command_sent_as_message =>
      'NextGen отправляет это Hermes как обычное сообщение; сама команда не выполняется.';

  @override
  String get ng_slash_command_output => 'Вывод команды';

  @override
  String get ng_slash_command_running => 'Выполняется команда…';

  @override
  String get ng_slash_command_done => 'Готово.';

  @override
  String ng_slash_command_failed(Object error) {
    return 'Не удалось выполнить команду: $error';
  }

  @override
  String get ng_slash_command_refused =>
      'Hermes не может выполнить эту команду здесь.';

  @override
  String get ng_slash_command_delivery_unknown =>
      'Команда отправлена, но ответ не пришёл. Возможно, она ещё выполняется на шлюзе, поэтому повторно не отправлялась, а черновик сохранён.';

  @override
  String get ng_slash_command_nothing_running => 'Ничего не выполняется.';

  @override
  String get ng_steered => 'Направлено';

  @override
  String get ng_copied => 'Скопировано';

  @override
  String ng_not_sent(Object reason) {
    return 'Не отправлено: $reason';
  }

  @override
  String get ng_thinking => 'Думаю…';

  @override
  String get ng_thought => 'Размышление';

  @override
  String ng_used(Object name) {
    return 'Использовано: $name';
  }

  @override
  String ng_used_tools(Object count) {
    return 'Использовано инструментов: $count';
  }

  @override
  String get ng_copy => 'Копировать';

  @override
  String get ng_read_aloud => 'Читать вслух';

  @override
  String get ng_the_gateway_connection_dropped_try_again =>
      'Соединение со шлюзом прервалось. Попробуйте ещё раз.';

  @override
  String get ng_allow_once => 'Разрешить один раз';

  @override
  String get ng_allow_until_sandbox_off => 'Пока песочница не будет отключена';

  @override
  String get ng_folder_access => 'Доступ к папке';

  @override
  String get ng_folder_access_unspecified =>
      'Шлюз не сообщил, доступ только для чтения или для чтения и записи.';

  @override
  String get ng_folder_read_only => 'Только чтение';

  @override
  String get ng_folder_read_write => 'Чтение и запись';

  @override
  String get ng_website_access => 'Доступ к сайту';

  @override
  String get ng_allow_for_this_chat => 'Разрешить в этом чате';

  @override
  String get ng_always_allow => 'Всегда разрешать';

  @override
  String get ng_deny => 'Запретить';

  @override
  String get ng_your_answer => 'Ваш ответ';

  @override
  String get ng_or_type_an_answer => 'Или введите ответ';

  @override
  String get ng_skip => 'Пропустить';

  @override
  String get ng_answer => 'Ответить';

  @override
  String get ng_cancel => 'Отмена';

  @override
  String get ng_username_or_email => 'Имя пользователя или эл. почта';

  @override
  String get ng_password => 'Пароль';

  @override
  String get ng_not_now => 'Не сейчас';

  @override
  String get ng_save => 'Сохранить';

  @override
  String get ng_enter_both_the_client_id_and =>
      'Введите Client ID и Client Secret или оставьте оба поля пустыми.';

  @override
  String get ng_enter_your_username_and_password =>
      'Введите имя пользователя и пароль.';

  @override
  String ng_couldn_t_save_the_sign_in(Object error) {
    return 'Не удалось сохранить данные для входа: $error';
  }

  @override
  String get ng_wrong_username_or_password =>
      'Неверное имя пользователя или пароль.';

  @override
  String get ng_too_many_attempts_wait_a_moment =>
      'Слишком много попыток. Подождите немного и попробуйте ещё раз.';

  @override
  String get ng_welcome_to_hermes => 'Добро пожаловать в Ares';

  @override
  String get ng_add_a_gateway => 'Добавить шлюз';

  @override
  String get ng_connect_to_your_hermes_agent_dashboard =>
      'Подключитесь к панели управления Hermes Agent. Один адрес и один вход — и вам доступны чаты, инструменты и настройки. Данные не отправляются, пока вы не войдёте.';

  @override
  String get ng_connect_to_another_hermes_agent_dashboard =>
      'Подключитесь к другой панели управления Hermes Agent. Вы останетесь в системе на всех сохранённых панелях.';

  @override
  String get ng_dashboard_address => 'Адрес панели управления';

  @override
  String get ng_testing => 'Проверка…';

  @override
  String get ng_test => 'Проверить';

  @override
  String get ng_where_your_hermes_dashboard_runs_lan =>
      'Адрес, по которому доступна панель Hermes: в локальной сети, через Tailscale или HTTPS.';

  @override
  String get ng_find_on_my_network => 'Найти в моей сети';

  @override
  String get ng_which_address_do_i_use => 'Какой адрес использовать?';

  @override
  String get ng_behind_cloudflare_access => 'За Cloudflare Access?';

  @override
  String get ng_need_a_client_certificate => 'Нужен клиентский сертификат?';

  @override
  String get ng_this_address_isn_t_private_and =>
      'Этот адрес не является приватным и не использует https://, поэтому ваш пароль и чаты будут передаваться через интернет без шифрования. Используйте https://, Tailscale или собственную сеть.';

  @override
  String get ng_continue_to_sign_in => 'Перейти ко входу';

  @override
  String get ng_use_the_classic_interface_instead =>
      'Вместо этого использовать классический интерфейс';

  @override
  String get ng_if_cloudflare_access_protects_this_address =>
      'Если этот адрес защищён Cloudflare Access, создайте сервисный токен в Cloudflare Zero Trust (Access, Service credentials) и добавьте для него политику Service Auth в приложение Access.';

  @override
  String get ng_a_service_token_is_saved_for =>
      'Для этого адреса сохранён сервисный токен';

  @override
  String get ng_forget => 'Забыть';

  @override
  String get ng_client_id => 'Client ID';

  @override
  String get ng_client_secret => 'Client Secret';

  @override
  String get ng_stored_encrypted_on_this_phone_and =>
      'Хранится в зашифрованном виде на этом телефоне и отправляется только на этот адрес.';

  @override
  String get ng_hermes_is_reachable => 'Hermes доступен';

  @override
  String ng_hermes_is_reachable_2(Object version) {
    return 'Hermes $version доступен';
  }

  @override
  String get ng_sign_in_is_tested_next_then =>
      'Сначала проверяется вход, затем чат';

  @override
  String get ng_agent_gateway => 'Шлюз агента';

  @override
  String get ng_running => 'Работает';

  @override
  String get ng_stopped => 'Остановлен';

  @override
  String get ng_username_password => 'Имя пользователя и пароль';

  @override
  String get ng_browser => 'Браузер';

  @override
  String get ng_in_the_browser_sso => 'В браузере (SSO)';

  @override
  String get ng_profiles => 'Профили';

  @override
  String get ng_this_dashboard_offers_neither_a_username =>
      'На этой панели нет ни входа по имени пользователя и паролю, ни входа через браузер. Обновите Hermes или настройте на сервере вход по имени пользователя и паролю.';

  @override
  String get ng_the_auth_gate_is_off_on =>
      'На этой панели отключена авторизация. Ею может пользоваться любой, у кого есть к ней доступ.';

  @override
  String get ng_couldn_t_reach_the_dashboard =>
      'Не удалось подключиться к панели';

  @override
  String ng_check_the_address_and_port_9119(Object reason) {
    return '$reason\n\nПроверьте адрес и порт (по умолчанию 9119). Если панель ещё не запущена, выполните на сервере:\nhermes dashboard --host 0.0.0.0';
  }

  @override
  String get ng_that_isn_t_a_hermes_dashboard => 'Это не панель Hermes';

  @override
  String get ng_something_answered_but_not_a_hermes_2 =>
      'Сервер ответил, но это не панель Hermes. Укажите адрес панели, а не API-сервера (порт 8642).';

  @override
  String ng_something_answered_http_but_not_a_2(Object status) {
    return 'Сервер ответил (HTTP $status), но это не панель Hermes. Укажите адрес панели, а не API-сервера (порт 8642).';
  }

  @override
  String get ng_cloudflare_access_stopped_the_request =>
      'Cloudflare Access заблокировал запрос';

  @override
  String ng_cloudflare_access_turned_down_the_service(Object status) {
    return 'Cloudflare Access отклонил токен службы (HTTP $status). Проверьте Client ID и Secret, а также политику Service Auth.';
  }

  @override
  String get ng_add_a_cloudflare_access_service_token_2 =>
      'Добавьте ниже токен службы Cloudflare Access и проверьте ещё раз.';

  @override
  String get ng_a_client_certificate_is_needed =>
      'Требуется сертификат клиента';

  @override
  String get ng_this_server_asks_for_a_client =>
      'Для подключения к этому серверу нужен сертификат клиента. Выберите его ниже и проверьте ещё раз.';

  @override
  String get ng_this_dashboard_doesn_t_ask_for =>
      'Для входа на эту панель пароль не требуется.';

  @override
  String ng_use_the_dashboard_username_and_password(Object address) {
    return 'Используйте имя пользователя и пароль для панели на $address или войдите через браузер.';
  }

  @override
  String ng_use_the_dashboard_username_and_password_2(Object address) {
    return 'Используйте имя пользователя и пароль для панели на $address.';
  }

  @override
  String ng_sign_in_to_in_your_browser(Object address) {
    return 'Войдите в $address через браузер с учётной записью для этой панели.';
  }

  @override
  String ng_gateway(Object address) {
    return 'Шлюз $address';
  }

  @override
  String get ng_profile => 'Профиль';

  @override
  String get ng_server_default => 'По умолчанию на сервере';

  @override
  String get ng_continue => 'Продолжить';

  @override
  String get ng_username => 'Имя пользователя';

  @override
  String get ng_signing_in => 'Выполняется вход…';

  @override
  String get ng_waiting_for_the_browser => 'Ожидание браузера…';

  @override
  String get ng_sign_in_with_browser => 'Войти через браузер';

  @override
  String get ng_finish_signing_in_on_the_page =>
      'Завершите вход на открывшейся странице. Hermes вернётся автоматически.';

  @override
  String get ng_use_a_different_gateway => 'Выбрать другой шлюз';

  @override
  String get ng_same_wi_fi_or_local_network =>
      'Одна сеть Wi-Fi или локальная сеть';

  @override
  String get ng_use_the_server_s_local_address =>
      'Укажите локальный адрес и порт сервера, например 192.168.1.20:9119. Запустите панель с параметром --host 0.0.0.0, чтобы другие устройства могли подключиться.';

  @override
  String get ng_tailscale => 'Tailscale';

  @override
  String get ng_turn_on_tailscale_on_this_phone =>
      'Включите Tailscale на этом телефоне и укажите адрес сервера в Tailscale, например 100.64.0.1:9119 или его имя .ts.net. Работает и вне дома.';

  @override
  String get ng_use_your_https_address_when_the =>
      'Используйте адрес https://, если панель работает за прокси с сертификатом. Прокси также должен поддерживать обновление соединения WebSocket на /api/ws.';

  @override
  String get ng_start_the_dashboard_on_the_server =>
      'Запустите панель на сервере:';

  @override
  String get ng_enter_a_port_from_1_to => 'Укажите порт от 1 до 65535.';

  @override
  String get ng_looks_for_hermes_dashboards_on_port =>
      'Ищет панели Hermes на порту 9119 в этой сети Wi-Fi и проверяет уже сохранённые компьютеры.';

  @override
  String ng_looks_for_hermes_dashboards_on_ports(Object port) {
    return 'Ищет панели Hermes на портах 9119 и $port в этой сети Wi-Fi и проверяет уже сохранённые компьютеры.';
  }

  @override
  String get ng_other_port_optional => 'Другой порт (необязательно)';

  @override
  String get ng_no_dashboards_answered_start_one_with =>
      'Панели не ответили. Запустите её командой hermes dashboard --host 0.0.0.0 или введите адрес.';

  @override
  String get ng_using_tailscale_or_a_vpn_those =>
      'Используете Tailscale или VPN? Такие сети нельзя просканировать. Введите адрес компьютера 100.x или его имя .ts.net.';

  @override
  String get ng_search_again => 'Искать снова';

  @override
  String get ng_insights => 'Статистика';

  @override
  String get ng_couldn_t_load_insights => 'Не удалось загрузить статистику';

  @override
  String get ng_sessions => 'Сеансы';

  @override
  String get ng_tokens => 'Токены';

  @override
  String get ng_est_cost => 'Примерная стоимость';

  @override
  String get ng_daily_tokens => 'Токены за день';

  @override
  String get ng_models => 'Модели';

  @override
  String get ng_tools => 'Инструменты';

  @override
  String get ng_hermes_is_waiting_for_you => 'Hermes ждёт вас.';

  @override
  String get ng_hermes_replied => 'Hermes ответил';

  @override
  String get ng_the_turn_finished => 'Ответ готов.';

  @override
  String get ng_off => 'Выкл.';

  @override
  String get ng_minimal => 'Минимальный';

  @override
  String get ng_low => 'Низкий';

  @override
  String get ng_medium => 'Средний';

  @override
  String get ng_high => 'Высокий';

  @override
  String get ng_extra_high => 'Очень высокий';

  @override
  String get ng_max => 'Максимум';

  @override
  String get ng_ultra => 'Ультра';

  @override
  String get ng_default => 'По умолчанию';

  @override
  String ng_couldn_t_switch_model(Object error) {
    return 'Не удалось переключить модель: $error';
  }

  @override
  String get ng_model => 'Модель';

  @override
  String get ng_thinking_2 => 'Размышление';

  @override
  String get ng_search_models => 'Поиск моделей';

  @override
  String get ng_no_models_match =>
      'Нет моделей, соответствующих этим фильтрам.';

  @override
  String get privacy_policy => 'Политика конфиденциальности';

  @override
  String get report_ai_output => 'Пожаловаться на ответ ИИ';

  @override
  String ng_couldn_t_load_models(Object error) {
    return 'Не удалось загрузить модели: $error';
  }

  @override
  String get ng_no_providers_are_set_up_on =>
      'На этом шлюзе пока не настроены провайдеры.';

  @override
  String get ng_starred => 'Избранное';

  @override
  String get ng_recent => 'Недавние';

  @override
  String get ng_more => 'Ещё';

  @override
  String get ng_archived_chats => 'Архивные чаты';

  @override
  String get ng_projects => 'Проекты';

  @override
  String get ng_chats_grouped_by_project_and_workspace =>
      'Чаты, сгруппированные по проектам и рабочим пространствам';

  @override
  String get ng_agent => 'Агент';

  @override
  String get ng_memory => 'Память';

  @override
  String get ng_what_hermes_remembers_about_you => 'Что Hermes помнит о вас';

  @override
  String get ng_skills_library => 'Библиотека навыков';

  @override
  String get ng_browse_and_read_installed_skills =>
      'Просмотр установленных навыков';

  @override
  String get ng_cron_editor => 'Редактор cron';

  @override
  String get ng_edit_schedules_prompts_and_delivery =>
      'Настройка расписаний, запросов и доставки';

  @override
  String get ng_config_file => 'Файл конфигурации';

  @override
  String get ng_edit_config_yaml_on_the_gateway =>
      'Редактирование config.yaml на шлюзе';

  @override
  String get ng_models_and_providers => 'Модели и провайдеры';

  @override
  String get ng_model_management => 'Управление моделями';

  @override
  String get ng_default_fallback_and_auxiliary_models =>
      'Модели по умолчанию, резервные и вспомогательные';

  @override
  String get ng_provider_sign_in => 'Вход в аккаунт провайдера';

  @override
  String get ng_connect_provider_accounts_with_oauth =>
      'Подключение аккаунтов провайдеров через OAuth';

  @override
  String get ng_nous_portal => 'Nous Portal';

  @override
  String get ng_subscription_credits_and_usage =>
      'Подписка, кредиты и использование';

  @override
  String get ng_interface => 'Интерфейс';

  @override
  String get ng_switch_to_the_classic_interface =>
      'Переключиться на классический интерфейс';

  @override
  String get ng_turns_nextgen_off_you_can_turn =>
      'Отключает NextGen. Снова включить его можно в настройках.';

  @override
  String get ng_restored => 'Восстановлено';

  @override
  String get ng_archived => 'В архиве';

  @override
  String get ng_couldn_t_load_archived_chats =>
      'Не удалось загрузить архивные чаты';

  @override
  String get ng_nothing_archived => 'В архиве пусто';

  @override
  String get ng_restore => 'Восстановить';

  @override
  String get ng_saved_new_chats_use_it =>
      'Сохранено. Новые чаты будут использовать этот вариант.';

  @override
  String ng_couldn_t_save(Object error) {
    return 'Не удалось сохранить: $error';
  }

  @override
  String get ng_saving => 'Сохранение…';

  @override
  String ng_today(Object time) {
    return 'Сегодня $time';
  }

  @override
  String get ng_mon => 'Пн';

  @override
  String get ng_tue => 'Вт';

  @override
  String get ng_wed => 'Ср';

  @override
  String get ng_thu => 'Чт';

  @override
  String get ng_fri => 'Пт';

  @override
  String get ng_sat => 'Сб';

  @override
  String get ng_sun => 'Вс';

  @override
  String get ng_scheduled => 'Запланировано';

  @override
  String get ng_new_job => 'Новая задача';

  @override
  String get ng_couldn_t_load_scheduled_jobs =>
      'Не удалось загрузить запланированные задачи';

  @override
  String get ng_nothing_scheduled => 'Нет запланированных задач';

  @override
  String get ng_ask_hermes_to_do_something_on =>
      'Попросите Hermes выполнить задачу по расписанию или добавьте её здесь.';

  @override
  String get ng_active => 'Активна';

  @override
  String get ng_paused => 'Приостановлена';

  @override
  String ng_next(Object when) {
    return 'Следующая: $when';
  }

  @override
  String ng_last(Object when) {
    return 'Последняя: $when';
  }

  @override
  String ng_last_2(Object when, Object result) {
    return 'Последняя: $when · $result';
  }

  @override
  String ng_job(Object id) {
    return 'Задача $id';
  }

  @override
  String get ng_delete => 'Удалить';

  @override
  String get ng_delete_this_job => 'Удалить эту задачу?';

  @override
  String get ng_it_stops_running_past_runs_stay =>
      'Задача перестанет выполняться. Прошлые запуски останутся в чатах.';

  @override
  String ng_next_run(Object when) {
    return 'Следующий запуск: $when';
  }

  @override
  String ng_delivers_to(Object target) {
    return 'Доставка: $target';
  }

  @override
  String get ng_run_now => 'Запустить сейчас';

  @override
  String get ng_started => 'Запущено';

  @override
  String get ng_pause => 'Пауза';

  @override
  String get ng_resume => 'Возобновить';

  @override
  String get ng_resumed => 'Возобновлено';

  @override
  String get ng_prompt => 'Промпт';

  @override
  String get ng_runs => 'Запуски';

  @override
  String get ng_no_runs_yet => 'Пока нет запусков.';

  @override
  String get ng_enter_a_schedule_and_a_prompt => 'Укажите расписание и промпт.';

  @override
  String get ng_name_optional => 'Имя (необязательно)';

  @override
  String get ng_schedule => 'Расписание';

  @override
  String get ng_every_1h_0_9_or_30m => 'every 1h, 0 9 * * *, or 30m';

  @override
  String get ng_create => 'Создать';

  @override
  String get ng_unpin => 'Открепить';

  @override
  String get ng_pin => 'Закрепить';

  @override
  String get ng_rename => 'Переименовать';

  @override
  String get ng_archive => 'В архив';

  @override
  String get ng_delete_this_chat => 'Удалить этот чат?';

  @override
  String get ng_it_is_removed_from_the_gateway =>
      'Он будет удалён со шлюза на всех устройствах.';

  @override
  String get ng_search_chats => 'Поиск чатов';

  @override
  String get ng_pinned => 'Закреплённые';

  @override
  String get ng_no_chats_match => 'Совпадений не найдено.';

  @override
  String get ng_no_chats_yet => 'Пока нет чатов.';

  @override
  String get ng_nothing_is_running => 'Сейчас ничего не запущено.';

  @override
  String get ng_nothing_is_waiting_on_you =>
      'Сейчас ничего не ждёт вашего внимания.';

  @override
  String get ng_settings => 'Настройки';

  @override
  String get ng_all => 'Все';

  @override
  String ng_needs_you(Object count) {
    return 'Требуют вашего внимания · $count';
  }

  @override
  String get ng_needs_you_2 => 'Требуют вашего внимания';

  @override
  String get ng_gateways => 'Шлюзы';

  @override
  String ng_classic_connection(Object address) {
    return '$address · классическое подключение';
  }

  @override
  String get ng_gateway_2 => 'Шлюз';

  @override
  String get ng_signed_in => 'Вход выполнен';

  @override
  String get ng_classic_connection_2 => 'Классическое подключение';

  @override
  String get ng_in_the_browser => 'В браузере';

  @override
  String ng_in_the_browser_as(Object name) {
    return 'В браузере: $name';
  }

  @override
  String get ng_not_required => 'Не требуется';

  @override
  String get ng_test_connection => 'Проверить подключение';

  @override
  String get ng_sign_in_again_2 => 'Войти снова';

  @override
  String get ng_sign_out => 'Выйти';

  @override
  String get ng_saved_gateways => 'Сохранённые шлюзы';

  @override
  String get ng_in_use => 'Используется';

  @override
  String get ng_appearance => 'Внешний вид';

  @override
  String get ng_theme => 'Тема';

  @override
  String get ng_system => 'Системная';

  @override
  String get ng_light => 'Светлая';

  @override
  String get ng_dark => 'Тёмная';

  @override
  String get ng_accent => 'Акцент';

  @override
  String get ng_pure_black => 'Чистый чёрный';

  @override
  String get ng_dark_theme_uses_true_black_oled =>
      'В тёмной теме используется настоящий чёрный цвет (OLED)';

  @override
  String get ng_glow => 'Свечение';

  @override
  String get ng_soft_accent_light_behind_each_screen =>
      'Мягкое акцентное свечение за каждым экраном';

  @override
  String get ng_the_new_interface_turn_off_to =>
      'Новый интерфейс. Отключите его, чтобы вернуться к классическому. Шлюзы и чаты общие.';

  @override
  String get ng_more_settings => 'Дополнительные настройки';

  @override
  String get ng_voice_notifications_language_backups_and_the =>
      'Голос, уведомления, язык, резервные копии и конфигурация шлюза';

  @override
  String get ng_licences => 'Лицензии';

  @override
  String ng_sign_out_of(Object name) {
    return 'Выйти из $name?';
  }

  @override
  String get ng_this_gateway_and_its_saved_sign =>
      'Этот шлюз и сохранённые данные для входа будут удалены с телефона в обоих интерфейсах. Чаты останутся на шлюзе.';

  @override
  String get ng_password_or_browser => 'Пароль или браузер';

  @override
  String get ng_unsupported => 'Не поддерживается';

  @override
  String get ng_background_task_finished => 'Фоновая задача завершена';

  @override
  String get ng_background_process_finished => 'Фоновый процесс завершён';

  @override
  String get ng_system_message => 'Системное сообщение';

  @override
  String get ng_summary => 'Сводка';

  @override
  String get classic_interface_only => 'Только классический интерфейс';

  @override
  String get classic_only_settings_hint =>
      'Разделы с пометкой «Только классический интерфейс» изменяют классический внешний вид и чат, но не NextGen. В NextGen есть собственные настройки внешнего вида.';

  @override
  String get attachment_preview_too_large =>
      'Файл слишком большой для предварительного просмотра. Нажмите «Сохранить» или «Поделиться», чтобы скачать его на телефон (до 1 ГБ).';

  @override
  String get attachment_over_phone_limit =>
      'Размер файла превышает 1 ГБ — это больше допустимого для скачивания. Откройте панель управления, чтобы скачать его.';

  @override
  String attachment_downloading_percent(int percent) {
    return 'Скачивание… $percent%';
  }

  @override
  String attachment_downloading_mb(int megabytes) {
    return 'Скачивание… $megabytes МБ';
  }

  @override
  String ng_attachment_too_large_for_gateway(String name) {
    return 'Файл $name превышает 12 МБ — максимальный размер для этого шлюза. Обновите Hermes, чтобы отправлять файлы размером до 100 МБ.';
  }

  @override
  String ng_couldn_t_upload(String name) {
    return 'Не удалось загрузить $name.';
  }

  @override
  String ng_uploading_percent(int percent) {
    return 'Загрузка… $percent%';
  }

  @override
  String get ng_show_tasks => 'Показать задачи';

  @override
  String get ng_hide_tasks => 'Скрыть задачи';

  @override
  String get ng_goal => 'Цель';

  @override
  String get ng_loop => 'Цикл';

  @override
  String get ng_heartbeat => 'Пульс';

  @override
  String get ng_goal_working => 'В работе';

  @override
  String get ng_goal_waiting => 'Ожидание';

  @override
  String get ng_goal_blocked => 'Заблокировано';

  @override
  String get ng_goal_done => 'Готово';

  @override
  String ng_goal_turns_of(int used, int max) {
    return '$used из $max ходов';
  }

  @override
  String ng_goal_turn(int used) {
    return 'ход $used';
  }

  @override
  String get ng_loop_held => 'Приостановлен из-за цели';

  @override
  String get ng_loop_finished => 'Завершён';

  @override
  String get ng_loop_running => 'Выполняется';

  @override
  String ng_loop_runs_of(int fired, int times) {
    return '$fired из $times запусков';
  }

  @override
  String ng_loop_runs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count запуска',
      many: '$count запусков',
      few: '$count запуска',
      one: '$count запуск',
    );
    return '$_temp0';
  }

  @override
  String ng_loop_next(String time) {
    return 'следующий $time';
  }

  @override
  String get ng_loop_due_now => 'пора запускать';

  @override
  String ng_every_seconds(int seconds) {
    return 'каждые $seconds с';
  }

  @override
  String ng_every_minutes(int minutes) {
    return 'каждые $minutes мин';
  }

  @override
  String ng_every_hours(int hours) {
    return 'каждые $hours ч';
  }

  @override
  String ng_every_hours_minutes(int hours, int minutes) {
    return 'каждые $hours ч $minutes мин';
  }

  @override
  String ng_heartbeat_fired(int count) {
    return 'Сработал: $count';
  }

  @override
  String ng_heartbeat_last_fired(String time) {
    return 'Последнее срабатывание: $time';
  }

  @override
  String ng_wait_until(String time) {
    return 'Ожидание до $time';
  }

  @override
  String get ng_wait_resume => 'Ожидание возобновления';

  @override
  String get ng_wait_other_chat => 'Ожидание в другом чате';

  @override
  String ng_wait_process(String pid) {
    return 'Ожидание процесса $pid';
  }

  @override
  String get ng_control_open => 'Открыть цель и автоматизацию';

  @override
  String get ng_control_title => 'Цель и автоматизация';

  @override
  String get ng_control_subtitle =>
      'К чему стремится этот чат и что выполняется автоматически.';

  @override
  String get ng_contract_outcome => 'Результат';

  @override
  String get ng_contract_verification => 'Проверка';

  @override
  String get ng_contract_constraints => 'Ограничения';

  @override
  String get ng_contract_boundaries => 'Границы';

  @override
  String get ng_contract_stop_when => 'Остановить, когда';

  @override
  String get ng_subgoals => 'Подцели';

  @override
  String get ng_subgoal_add_placeholder => 'Добавить подцель';

  @override
  String get ng_add => 'Добавить';

  @override
  String get ng_subgoal_remove => 'Удалить подцель';

  @override
  String get ng_goal_checks => 'Проверки';

  @override
  String get ng_gate_not_run => 'Ещё не запускалась';

  @override
  String ng_gate_attempts(int attempts, int tries) {
    return '$attempts из $tries попыток';
  }

  @override
  String ng_gate_exit(int code) {
    return 'код завершения $code';
  }

  @override
  String get ng_resume_now => 'Возобновить сейчас';

  @override
  String get ng_goal_clear => 'Очистить цель';

  @override
  String get ng_goal_clear_title => 'Очистить эту цель?';

  @override
  String get ng_goal_clear_message =>
      'Агент перестанет работать над ней. Её подцели и проверки тоже будут удалены.';

  @override
  String get ng_subgoal_remove_title => 'Удалить эту подцель?';

  @override
  String ng_subgoal_remove_message(String text) {
    return '«$text» больше не будет частью цели.';
  }

  @override
  String get ng_subgoals_clear_title => 'Удалить все подцели?';

  @override
  String get ng_subgoals_clear_message =>
      'Название цели останется, но все подцели будут удалены.';

  @override
  String get ng_clear_all => 'Удалить всё';

  @override
  String get ng_clear => 'Очистить';

  @override
  String get ng_dismiss => 'Закрыть';

  @override
  String get ng_loop_stop_title => 'Остановить этот цикл?';

  @override
  String get ng_heartbeat_clear_title => 'Отключить этот пульс?';

  @override
  String get ng_wont_fire_again => 'Он больше не будет срабатывать.';

  @override
  String get ng_loop_self_paced => 'В собственном темпе';

  @override
  String ng_loop_until(String condition) {
    return 'До: $condition';
  }

  @override
  String get ng_loop_waits_for_goal => 'Ждёт, пока выполняется цель.';

  @override
  String get ng_loop_awaiting_reply => 'Ожидает ответа агента.';

  @override
  String ng_loop_stopped_reason(String reason) {
    return 'Остановлен: $reason';
  }

  @override
  String get ng_hide_subagents => 'Скрыть субагентов';

  @override
  String get ng_show_subagents => 'Показать субагентов';

  @override
  String get ng_subagent => 'Субагент';

  @override
  String get ng_subagent_queued => 'В очереди';

  @override
  String get ng_subagent_starting => 'Запускается…';

  @override
  String get ng_subagent_running => 'Работает';

  @override
  String get ng_subagent_done => 'Готово';

  @override
  String get ng_subagent_failed => 'Не удалось';

  @override
  String get ng_subagent_stopped => 'Остановлен';

  @override
  String get ng_subagent_stop => 'Остановить субагента';

  @override
  String ng_subagent_tools(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count инструмента',
      many: '$count инструментов',
      few: '$count инструмента',
      one: '$count инструмент',
    );
    return '$_temp0';
  }

  @override
  String get ng_mark_as_read => 'Отметить как прочитанное';

  @override
  String get ng_mark_as_unread => 'Отметить как непрочитанное';

  @override
  String ng_chats_unread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Чаты, $count непрочитанных',
      one: 'Чаты, 1 непрочитанный',
    );
    return '$_temp0';
  }

  @override
  String get ng_unread_finished => 'Завершено, непрочитанный ответ';

  @override
  String get ng_unread_updates => 'Выполняется, есть непрочитанные обновления';

  @override
  String get ng_notifications => 'Уведомления';

  @override
  String get ng_notifications_hint =>
      'Ответы и запросы, пока Ares работает в фоновом режиме';

  @override
  String get ng_notify_replies => 'Ответы';

  @override
  String get ng_notify_replies_hint =>
      'Когда ответ в открытом чате готов или возникает ошибка';

  @override
  String get ng_notify_requests => 'Подтверждения и вопросы';

  @override
  String get ng_notify_requests_hint =>
      'Уведомление, когда агент ждёт вашего ответа, с кнопками «Разрешить один раз» и «Отклонить»';

  @override
  String get ng_keep_running => 'Оставаться на связи, пока готовится ответ';

  @override
  String get ng_keep_running_hint =>
      'Поддерживает соединение в фоновом режиме, пока не будет готов ответ, и показывает тихое уведомление';

  @override
  String get ng_battery_settings => 'Оптимизация батареи';

  @override
  String get ng_battery_settings_hint =>
      'Разрешите Ares работать в фоновом режиме, чтобы уведомления приходили вовремя';

  @override
  String get ng_send_test_notification => 'Отправить тестовое уведомление';

  @override
  String get ng_test_notification_title => 'Уведомления Ares работают';

  @override
  String get ng_test_notification_body =>
      'Здесь будут появляться ответы и запросы.';

  @override
  String get ng_test_notification_sent => 'Тестовое уведомление отправлено';

  @override
  String get ng_notifications_blocked =>
      'Уведомления заблокированы. Разрешите их в настройках Android.';

  @override
  String get ng_notifications_off_hint =>
      'Уведомления выключены, поэтому, когда Ares работает в фоновом режиме, они не появляются.';

  @override
  String get ng_insights_building =>
      'Формируем отчет. При первом построении отчета за длительный период это может занять до минуты.';

  @override
  String get ng_insights_timed_out =>
      'Шлюзу не удалось сформировать отчет вовремя. Попробуйте еще раз или выберите более короткий период.';

  @override
  String get ng_dock_goal_active => 'Цель активна';

  @override
  String get ng_dock_goal_paused => 'Цель приостановлена';

  @override
  String get ng_dock_goal_waiting => 'Цель ожидает';

  @override
  String get ng_dock_goal_blocked => 'Цель заблокирована';

  @override
  String get ng_dock_goal_done => 'Цель завершена';

  @override
  String ng_dock_turn_of(int used, int max) {
    return 'Ход $used/$max';
  }

  @override
  String ng_dock_turn(int used) {
    return 'Ход $used';
  }

  @override
  String ng_dock_subagents(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count субагента',
      many: '$count субагентов',
      few: '$count субагента',
      one: '$count субагент',
    );
    return '$_temp0';
  }

  @override
  String ng_dock_subagents_done(int count) {
    return '$count завершено';
  }

  @override
  String ng_dock_tasks(int done, int total) {
    return 'Задачи $done/$total';
  }

  @override
  String ng_dock_previous_tasks(int done, int total) {
    return 'Предыдущие задачи $done/$total';
  }

  @override
  String get ng_dock_manage => 'Управление';

  @override
  String get ng_recent_notifications => 'Недавние уведомления';

  @override
  String get ng_recent_notifications_hint =>
      'Что Ares пытался отправить и показал ли это Android';

  @override
  String get ng_recent_notifications_empty =>
      'Пока ничего. Здесь появляются попытки, которые должны были вызвать уведомление об ответе, вопросе или сбое.';

  @override
  String get ng_notify_permission_granted => 'Разрешение предоставлено';

  @override
  String get ng_notify_permission_denied => 'В разрешении отказано';

  @override
  String get ng_notify_master_on => 'Уведомления включены';

  @override
  String get ng_notify_master_off => 'Уведомления выключены';

  @override
  String get ng_models_default => 'Модель по умолчанию';

  @override
  String get ng_models_change => 'Изменить';

  @override
  String get ng_models_custom_endpoint =>
      'Работает через пользовательский адрес. Измените его на шлюзе.';

  @override
  String get ng_models_context_window => 'Контекстное окно';

  @override
  String ng_models_token_count(String count) {
    return '$count токенов';
  }

  @override
  String ng_models_context_override(String count) {
    return 'Задано на шлюзе. Определено автоматически: $count токенов.';
  }

  @override
  String get ng_models_max_output => 'Макс. вывод';

  @override
  String get ng_models_input_price => 'Цена ввода';

  @override
  String get ng_models_output_price => 'Цена вывода';

  @override
  String get ng_models_cache_price => 'Цена кэшированного ввода';

  @override
  String ng_models_per_million(String price) {
    return '$price за 1 млн токенов';
  }

  @override
  String ng_models_price_pair(String input, String output) {
    return 'Ввод $input · вывод $output за 1 млн токенов';
  }

  @override
  String get ng_models_free => 'Бесплатно';

  @override
  String get ng_models_vision => 'Зрение';

  @override
  String get ng_models_reasoning => 'Рассуждение';

  @override
  String get ng_models_fast => 'Быстрый режим';

  @override
  String get ng_models_in_use => 'Используется';

  @override
  String ng_models_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count модели',
      many: '$count моделей',
      few: '$count модели',
      one: '$count модель',
    );
    return '$_temp0';
  }

  @override
  String get ng_models_rate_limited => 'Лимит исчерпан';

  @override
  String get ng_models_plan_locked => 'Недоступно в вашем тарифе';

  @override
  String get ng_models_unsaved => 'Несохранённые изменения';

  @override
  String get ng_models_discard => 'Сбросить';

  @override
  String get ng_models_aux_hint =>
      'Вспомогательные задачи используют модель по умолчанию, пока вы не назначите им свою.';

  @override
  String get ng_models_uses_default => 'Использует модель по умолчанию';

  @override
  String get ng_models_thinking_level => 'Уровень размышления';

  @override
  String get ng_models_providers => 'Провайдеры';

  @override
  String get ng_models_saved => 'Сохранено';

  @override
  String get ng_aux_vision => 'Зрение';

  @override
  String get ng_aux_vision_hint => 'Читает изображения и снимки экрана';

  @override
  String get ng_aux_compression => 'Сжатие';

  @override
  String get ng_aux_compression_hint =>
      'Сокращает длинный чат, чтобы он помещался в контекстное окно';

  @override
  String get ng_aux_approval => 'Одобрение';

  @override
  String get ng_aux_approval_hint =>
      'Решает, можно ли безопасно выполнить команду без запроса';

  @override
  String get ng_aux_mcp => 'MCP';

  @override
  String get ng_aux_mcp_hint => 'Выбирает, какие инструменты MCP использовать';

  @override
  String get ng_aux_title_generation => 'Названия чатов';

  @override
  String get ng_aux_title_generation_hint => 'Даёт названия новым чатам';

  @override
  String get ng_aux_review => 'Ревью';

  @override
  String get ng_aux_review_hint =>
      'Проверяет работу, когда вы запускаете /review';

  @override
  String get ng_aux_voice_chat => 'Голосовой чат';

  @override
  String get ng_aux_voice_chat_hint => 'Отвечает в голосовом режиме';

  @override
  String get ng_aux_triage_specifier => 'Триаж';

  @override
  String get ng_aux_triage_specifier_hint =>
      'Разворачивает однострочную карточку Kanban в спецификацию';

  @override
  String get ng_aux_kanban_decomposer => 'Разбиение Kanban';

  @override
  String get ng_aux_kanban_decomposer_hint =>
      'Делит карточку Kanban на более мелкие задачи';

  @override
  String get ng_aux_profile_describer => 'Описания профилей';

  @override
  String get ng_aux_profile_describer_hint =>
      'Пишет краткое описание каждого профиля';

  @override
  String get ng_aux_curator => 'Куратор';

  @override
  String get ng_aux_curator_hint => 'Проверяет, как используются навыки';

  @override
  String get appearance_save_failed => 'Не удалось сохранить это изменение.';

  @override
  String get appearance_keep_which_theme => 'Какую тему оставить?';

  @override
  String get appearance_tour_back => 'Назад';

  @override
  String get appearance_tour_finish => 'Завершить';

  @override
  String get appearance_tour_next => 'Далее';

  @override
  String get appearance_tour_close => 'Закрыть обзор';

  @override
  String get appearance_dismiss_tip => 'Скрыть подсказку';

  @override
  String get appearance_search_settings => 'Поиск настроек';

  @override
  String get appearance_search_show => 'Показать';

  @override
  String get appearance_no_matching_setting =>
      'Подходящая настройка не найдена.';

  @override
  String get appearance_replay_tour => 'Повторить обзор';

  @override
  String get appearance_show_tips_again => 'Снова показывать подсказки';

  @override
  String get appearance_window_translucency_unavailable =>
      'Полупрозрачность окна недоступна на этом хосте. Linux её не поддерживает, а приложения для Apple и Windows отрисовывают непрозрачную область Flutter.';

  @override
  String get appearance_imported_themes => 'Импортированные темы';

  @override
  String get appearance_import_theme_file => 'Импортировать файл темы';

  @override
  String get appearance_remove_theme => 'Удалить тему';

  @override
  String get appearance_chat_font => 'Шрифт чата';

  @override
  String get appearance_terminal_font => 'Шрифт терминала';

  @override
  String get appearance_font_platform => 'Платформа';

  @override
  String get appearance_automatic => 'Автоматически';

  @override
  String get appearance_force_left_to_right => 'Принудительно слева направо';

  @override
  String get appearance_force_right_to_left => 'Принудительно справа налево';

  @override
  String get appearance_user_bubble_opacity =>
      'Непрозрачность сообщений пользователя';

  @override
  String get appearance_inline_embeds => 'Встроенный контент';

  @override
  String get appearance_inline_embeds_hint =>
      'Расширенные превью загружаются со сторонних сайтов (YouTube, X, …). «Спрашивать» показывает заглушку, пока вы не разрешите каждое; «Всегда» загружает их автоматически; «Выкл.» оставляет обычные ссылки.';

  @override
  String get appearance_embeds_ask => 'Спрашивать';

  @override
  String get appearance_embeds_always => 'Всегда';

  @override
  String get appearance_embeds_off => 'Выкл.';

  @override
  String appearance_embeds_reset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Сбросить $count разрешённого сервиса',
      many: 'Сбросить $count разрешённых сервисов',
      few: 'Сбросить $count разрешённых сервиса',
      one: 'Сбросить $count разрешённый сервис',
    );
    return '$_temp0';
  }

  @override
  String get appearance_embed_load => 'Загрузить';

  @override
  String appearance_embed_always_allow(String service) {
    return 'Всегда разрешать $service';
  }

  @override
  String get appearance_embed_loading => 'Загрузка превью…';

  @override
  String appearance_embed_image_failed(String host) {
    return 'Не удалось загрузить изображение с $host. Нажмите, чтобы открыть.';
  }

  @override
  String get appearance_embed_preview_unavailable => 'Превью недоступно';

  @override
  String get appearance_emoji_reactions => 'Реакции эмодзи';

  @override
  String get appearance_celebration_hearts => 'Праздничные сердечки';

  @override
  String get appearance_celebration_hearts_hint =>
      'Анимация сердечка появляется, когда ответ приходит в ваше отсутствие.';

  @override
  String get appearance_pop_out_companion =>
      'Вынести компаньона в отдельное окно';

  @override
  String get appearance_mosskip => 'Mosskip';

  @override
  String get appearance_emberbun => 'Emberbun';

  @override
  String get appearance_tideling => 'Tideling';

  @override
  String get appearance_my_hatchling => 'Мой питомец';

  @override
  String get appearance_at_rest => 'Отдыхает';

  @override
  String get appearance_working => 'Работает';

  @override
  String get appearance_thinking => 'Думает';

  @override
  String get appearance_waiting_for_you => 'Ждёт вас';

  @override
  String get appearance_reply_ready => 'Ответ готов';

  @override
  String get appearance_turn_failed => 'Ошибка хода';

  @override
  String get appearance_small => 'Маленький';

  @override
  String get appearance_medium => 'Средний';

  @override
  String get appearance_large => 'Большой';

  @override
  String get appearance_hello => 'Привет!';

  @override
  String get appearance_unread_reply => 'Непрочитанный ответ';

  @override
  String get appearance_compose => 'Написать';

  @override
  String get appearance_say_hello => 'Поздороваться';

  @override
  String get appearance_pet_image_failed =>
      'Не удалось открыть это изображение. Выберите PNG или JPEG меньшего размера.';

  @override
  String get appearance_pet_companion => 'Питомец-компаньон';

  @override
  String get appearance_pet_companion_hint =>
      'Показывать компаньона во время чата.';

  @override
  String get appearance_adopt_a_companion => 'Завести компаньона';

  @override
  String get appearance_roam_when_idle => 'Гулять во время простоя';

  @override
  String get appearance_pet_size => 'Размер питомца';

  @override
  String get appearance_hatch_from_a_local_picture =>
      'Вылупить питомца из локального изображения';

  @override
  String get appearance_pet_image_limits =>
      'Выберите PNG или JPEG (до 4 МиБ, 4096 пикселей по каждой стороне и 8 Мп). Сначала просмотрите его. При вылуплении сохраняется один портрет размером 24 × 24 пикселя, заменяющий предыдущего питомца.';

  @override
  String get appearance_choose_picture => 'Выбрать изображение';

  @override
  String get appearance_hatchling_preview => 'Предпросмотр питомца';

  @override
  String get appearance_hatch_and_adopt => 'Вылупить и приютить';

  @override
  String get appearance_discard_draft => 'Удалить черновик';

  @override
  String get appearance_forget_saved_hatchling => 'Забыть сохранённого питомца';

  @override
  String get appearance_radio => 'Радио';

  @override
  String appearance_radio_hint(String stations) {
    return 'Трансляции поступают напрямую от $stations и начинаются только при нажатии «Воспроизвести». Поиск станций остаётся на этом устройстве.';
  }

  @override
  String get appearance_radio_save_failed =>
      'Не удалось сохранить настройки радио.';

  @override
  String get appearance_choose_a_station => 'Выбрать станцию';

  @override
  String get appearance_pause_radio => 'Приостановить радио';

  @override
  String get appearance_play_radio => 'Включить радио';

  @override
  String get appearance_next_station => 'Следующая станция';

  @override
  String get appearance_radio_trace_semantics =>
      'Активность трансляции. Уровни звука недоступны, поэтому линия остаётся ровной.';

  @override
  String get appearance_radio_is_off => 'Радио выключено';

  @override
  String get appearance_paused => 'На паузе';

  @override
  String get appearance_connecting => 'Подключение…';

  @override
  String get appearance_live => 'В эфире';

  @override
  String get appearance_stream_unavailable => 'Трансляция недоступна';

  @override
  String appearance_now_playing(String credit) {
    return 'Сейчас играет: $credit';
  }

  @override
  String get appearance_audio_only_waveform_unavailable =>
      'Только аудио · звуковая волна недоступна';

  @override
  String get appearance_volume => 'Громкость';

  @override
  String get appearance_search_presets => 'Поиск предустановок';

  @override
  String get appearance_no_stations_found => 'Станции не найдены';

  @override
  String appearance_unpin_station(String station) {
    return 'Открепить станцию: $station';
  }

  @override
  String appearance_pin_station(String station) {
    return 'Закрепить станцию: $station';
  }

  @override
  String get appearance_radio_picker_metadata_notice =>
      'Пока это окно выбора открыто, проигрываемые станции могут передавать сведения о треках напрямую от вещателя.';

  @override
  String get appearance_message_from_your_companion =>
      'Сообщение от вашего компаньона';

  @override
  String get appearance_send_to_the_open_chat => 'Отправить в открытый чат';

  @override
  String get appearance_tour_theme_body =>
      'Импортируйте цветовую тему VS Code из файла на этом устройстве, затем выберите вариант, который хотите оставить.';

  @override
  String get appearance_tour_fonts_title => 'Шрифты для чтения';

  @override
  String get appearance_tour_fonts_body =>
      'Для текста чата и кода терминала используются разные шрифты из комплекта Ares.';

  @override
  String get appearance_tour_direction_title => 'Направление переписки';

  @override
  String get appearance_tour_direction_body =>
      'Оставьте автоматический выбор или задайте направление переписки слева направо либо справа налево.';

  @override
  String get appearance_tour_pet_title => 'Компаньон';

  @override
  String get appearance_tour_pet_body =>
      'Компаньон выключен, пока вы его не заведёте. В отдельном окне есть небольшое поле ввода.';

  @override
  String get appearance_tour_radio_body =>
      'Радио выключено, пока вы его не включите. Трансляция открывается при нажатии «Воспроизвести».';

  @override
  String get appearance_tip_theme =>
      'Импортированные темы заменяют встроенную палитру, пока вы не сбросите выбор. Сохраняются только цвета.';

  @override
  String get appearance_tip_pet =>
      'Компаньон хранит один маленький портрет на этом устройстве. Исходное изображение питомца никуда не загружается.';

  @override
  String get appearance_theme_import_failed =>
      'Не удалось импортировать эту тему. Выберите цветовую тему VS Code в файле .vsix, .json или .jsonc.';

  @override
  String get render_widget_file_truncated =>
      'Прочитано только начало этого файла, поэтому виджет может быть неполным.';

  @override
  String get setup_beat_title => 'Настройка';

  @override
  String setup_beat_use_name(String name) {
    return 'Использовать $name';
  }

  @override
  String get setup_beat_name_hint => 'Как Hermes должен вас называть?';

  @override
  String get setup_beat_on_computer =>
      'Этот шаг выполняется в Hermes на компьютере, где он работает. «Продолжить» сохраняет то, что там уже настроено.';

  @override
  String get setup_beat_not_waiting =>
      'Эта карточка настройки больше не ждёт ответа.';

  @override
  String get catalog_kind_plugin => 'Плагин';

  @override
  String get catalog_kind_skill => 'Навык';

  @override
  String get catalog_tier_official => 'Официальный';

  @override
  String get catalog_tier_verified => 'Проверенный';

  @override
  String get catalog_tier_community => 'Сообщество';

  @override
  String get catalog_install => 'Установить';

  @override
  String get catalog_waiting => 'Ждёт вашего решения';

  @override
  String get catalog_installed => 'Установлено';

  @override
  String get catalog_installed_off => 'Установлено, не включено';

  @override
  String get catalog_skipped => 'Пропущено';

  @override
  String get catalog_not_installed => 'Не установлено';

  @override
  String catalog_target_profile(String profile) {
    return 'Устанавливается в профиль $profile';
  }

  @override
  String catalog_source(String repo, String sha) {
    return '$repo, коммит $sha';
  }

  @override
  String catalog_scan(String status, String summary) {
    return 'Проверка безопасности: $status. $summary';
  }

  @override
  String catalog_requires_hermes(String range) {
    return 'Нужен Hermes $range';
  }

  @override
  String catalog_skill_ready(String name) {
    return 'Навык $name готов';
  }

  @override
  String catalog_missing_env(String names) {
    return 'Ещё нужно: $names';
  }

  @override
  String catalog_server_error(String name, String error) {
    return '$name не подключился: $error';
  }

  @override
  String get catalog_send_failed =>
      'Ваш выбор не отправлен. Попробуйте ещё раз.';

  @override
  String get attachment_video_speed => 'Скорость воспроизведения';

  @override
  String get catalog_installing => 'Установка…';

  @override
  String get catalog_phase_downloading => 'Загрузка…';

  @override
  String get catalog_phase_python_packages => 'Установка пакетов Python…';

  @override
  String get catalog_phase_loading_tools => 'Загрузка инструментов…';

  @override
  String get setup_beat_send_failed =>
      'Ваш ответ не отправлен. Попробуйте ещё раз.';

  @override
  String catalog_tool_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count инструмента',
      many: '$count инструментов',
      few: '$count инструмента',
      one: '$count инструмент',
    );
    return '$_temp0';
  }

  @override
  String get render_svg_not_drawn => 'Этот SVG не отрисован.';

  @override
  String get render_notes_directive => 'Директива заметок';

  @override
  String get render_maths_source => 'Исходный текст формулы';

  @override
  String get render_inline_maths_source => 'Исходный текст встроенной формулы';

  @override
  String get render_sequence_outline => 'Схема последовательности';

  @override
  String get render_diagram_outline => 'Схема диаграммы';

  @override
  String render_revision_of(int index, int count) {
    return 'Версия $index из $count';
  }

  @override
  String get render_previous_revision => 'Предыдущая версия';

  @override
  String get render_next_revision => 'Следующая версия';

  @override
  String get render_show_rendered => 'Отображение';

  @override
  String get render_show_source => 'Исходный код';

  @override
  String render_copied_file(String name) {
    return '$name скопирован';
  }

  @override
  String render_copy_file(String name) {
    return 'Копировать $name';
  }

  @override
  String get render_artifact_too_long =>
      'Этот артефакт слишком длинный, чтобы показать его здесь как страницу.';

  @override
  String get render_active_content_removed =>
      'Скрипты, фреймы и внешние адреса удалены.';

  @override
  String render_widget_file(String file) {
    return 'Виджет $file';
  }

  @override
  String get render_widget_runs_as_text =>
      'Работает как текст в этом чате. Скрипты и внешние фреймы удаляются.';

  @override
  String get render_load_widget => 'Загрузить виджет';

  @override
  String get render_not_html_widget => 'Этот файл не является HTML-виджетом.';

  @override
  String get render_widget_sent => 'Отправлено в этот чат';

  @override
  String get render_widget_not_sent => 'Не отправлено в этот чат';

  @override
  String get render_widget_throttled =>
      'Подождите немного перед повторной отправкой';

  @override
  String get render_widget_too_long =>
      'Этот запрос слишком длинный для отправки';

  @override
  String get render_widget_no_gesture =>
      'Чтобы отправить, нажмите элемент управления в виджете';

  @override
  String get render_widget_invalid => 'Не удалось отправить этот запрос';

  @override
  String get render_inspected_image => 'Просмотренное изображение';

  @override
  String get render_contributions => 'Дополнения';

  @override
  String get render_contributions_intro =>
      'Дополнять ответ могут только дополнения, встроенные в Ares. Текст чата не может их зарегистрировать, а разрешение действует только для этого подключения.';

  @override
  String render_grant_plugin(String name) {
    return 'Разрешить $name';
  }

  @override
  String render_revoke_plugin(String name) {
    return 'Отозвать $name';
  }

  @override
  String render_plugin_slots(String directive) {
    return 'карточки ответа для ::$directive';
  }

  @override
  String get render_plugin_notes => 'Заметки';

  @override
  String get catalog_scan_passed => 'пройдена';

  @override
  String get catalog_scan_warnings => 'найдены предупреждения';

  @override
  String get catalog_scan_failed => 'не пройдена';

  @override
  String get deployment_token_label => 'Токен развёртывания (необязательно)';

  @override
  String get deployment_token_helper =>
      'Для токенов сеанса Hermes Dashboard, отправляемых как X-Hermes-Session-Token. Не хранится открытым текстом в настройках.';

  @override
  String get deployment_token_hint => 'Токен сеанса панели';

  @override
  String get custom_headers_label => 'Свои заголовки (необязательно)';

  @override
  String get custom_headers_helper =>
      'По одному в строке, например X-Custom: значение. Запрещённые заголовки отклоняются.';

  @override
  String get custom_headers_hint => 'например X-Custom-Header: значение';

  @override
  String get desktop_tray_open => 'Открыть Ares';

  @override
  String get desktop_tray_new_chat => 'Новый чат';

  @override
  String get desktop_tray_quick_entry => 'Быстрый ввод…';

  @override
  String get desktop_tray_pause_notifications => 'Приостановить уведомления';

  @override
  String get desktop_tray_quit => 'Выйти из Ares';

  @override
  String get desktop_integration_title => 'Интеграция с рабочим столом';

  @override
  String get desktop_tray_setting =>
      'Показывать Ares в системном трее или строке меню';

  @override
  String get desktop_tray_setting_help =>
      'Через значок можно открыть Ares, начать чат, открыть быстрый ввод, приостановить уведомления или выйти.';

  @override
  String get desktop_close_to_tray_setting =>
      'Продолжать работу в трее после закрытия окна';

  @override
  String get desktop_tray_unsupported =>
      'В этой среде нет системного трея, доступного для Ares.';

  @override
  String get quick_entry_title => 'Быстрый ввод';

  @override
  String get quick_entry_hint => 'Введите запрос для Ares…';

  @override
  String get quick_entry_submit => 'Вставить в поле ввода';

  @override
  String get quick_entry_never_sends =>
      'Enter вставляет текст в поле ввода чата. Ничего не отправляется, пока вы не нажмёте «Отправить».';

  @override
  String get quick_entry_unavailable =>
      'Не удалось открыть быстрый ввод. Попробуйте ещё раз.';

  @override
  String get desktop_hotkey_setting => 'Сочетание клавиш для быстрого ввода';

  @override
  String desktop_hotkey_help(String shortcut) {
    return 'Нажмите $shortcut где угодно, чтобы открыть быстрый ввод.';
  }

  @override
  String desktop_hotkey_conflict(String shortcut) {
    return '$shortcut уже использует другое приложение. Выберите другое сочетание.';
  }

  @override
  String get desktop_hotkey_unsupported =>
      'Эта среда не позволяет приложениям регистрировать глобальные сочетания клавиш (например, Wayland).';

  @override
  String get desktop_hotkey_no_modifier => 'Добавьте Cmd, Ctrl или Alt.';

  @override
  String get desktop_hotkey_super_key =>
      'Клавиша Windows или Super зарезервирована системой.';

  @override
  String get desktop_hotkey_reserved => 'Это сочетание уже использует система.';

  @override
  String desktop_hotkey_in_app(String action) {
    return 'Ares уже использует это сочетание для действия «$action».';
  }

  @override
  String get desktop_hotkey_change => 'Изменить';

  @override
  String get desktop_hotkey_reset => 'По умолчанию';

  @override
  String get capture_screen_action => 'Снимок экрана';

  @override
  String get capture_screen_help =>
      'Добавляет снимок экрана в сообщение как черновик. Ничего не отправляется, пока вы не нажмёте «Отправить».';

  @override
  String get capture_screen_unavailable =>
      'Снимок экрана недоступен в этой среде.';

  @override
  String get capture_screen_failed =>
      'Не удалось сделать снимок экрана. Попробуйте ещё раз.';

  @override
  String get capture_permission_title => 'Разрешите запись экрана';

  @override
  String get capture_permission_body =>
      'Чтобы сделать снимок окна, Ares нужно разрешение на запись экрана. Включите Ares в разделе «Системные настройки» > «Конфиденциальность и безопасность» > «Запись экрана» и повторите попытку.';

  @override
  String get capture_open_settings => 'Открыть Системные настройки';

  @override
  String get keep_awake_title => 'Не давать компьютеру засыпать';

  @override
  String get keep_awake_title_mobile => 'Не выключать экран';

  @override
  String get keep_awake_mode_off => 'Выкл.';

  @override
  String get keep_awake_mode_while_working => 'Во время работы';

  @override
  String get keep_awake_mode_always => 'Всегда';

  @override
  String get keep_awake_off_help =>
      'Никогда не мешать переходу в сон (по умолчанию).';

  @override
  String get keep_awake_while_working_help =>
      'Не давать засыпать от бездействия, только пока идёт ход агента.';

  @override
  String get keep_awake_always_help =>
      'Не давать засыпать от бездействия, пока Ares открыт на этом устройстве.';

  @override
  String get keep_awake_off_help_mobile =>
      'Экран выключается как обычно (по умолчанию).';

  @override
  String get keep_awake_while_working_help_mobile =>
      'Не выключать экран, пока идёт ход агента и Ares открыт.';

  @override
  String get keep_awake_always_help_mobile =>
      'Не выключать экран, пока Ares открыт.';

  @override
  String get ng_token_gateway_has_no_sign_in =>
      'У этого шлюза нет входа, поэтому он не может проверить токен развёртывания. Включите аутентификацию панели на хосте (или обновите Hermes) и повторите попытку.';

  @override
  String get palette_open => 'Палитра команд приложения';

  @override
  String get palette_no_matches => 'Нет подходящих действий';

  @override
  String get palette_filter_hint =>
      'Введите текст, чтобы отфильтровать действия…';

  @override
  String get palette_keys_move => '↑↓ — перемещение';

  @override
  String get palette_keys_run => 'Enter — выполнить';

  @override
  String get palette_keys_close => 'Esc — закрыть';

  @override
  String get palette_search_sessions => 'Поиск сеансов';

  @override
  String get palette_scheduled_crons => 'Запланированные / Cron';

  @override
  String get palette_capabilities_skills => 'Возможности и навыки';

  @override
  String get palette_insights_usage => 'Аналитика и использование';

  @override
  String get palette_more_projects => 'Ещё и проекты';

  @override
  String get deeplink_chat_not_found =>
      'Чат не найден в списке. Возможно, он ещё не загрузился.';

  @override
  String get keyboard_shortcuts_title => 'Сочетания клавиш';

  @override
  String get shortcuts_reset_all => 'Сбросить все';

  @override
  String get shortcuts_reset_to_default => 'Вернуть по умолчанию';

  @override
  String get shortcut_action_command_palette => 'Палитра команд';

  @override
  String get shortcut_action_new_chat => 'Новый чат';

  @override
  String get shortcut_action_search => 'Поиск';

  @override
  String get shortcut_action_settings => 'Настройки';

  @override
  String shortcut_action_go_to_tab(int number) {
    return 'Перейти на вкладку $number';
  }

  @override
  String shortcuts_conflict(String first, String second, String chord) {
    return 'Конфликт: «$first» и «$second» используют $chord. Своё сочетание остаётся по умолчанию, пока вы не измените одно из них.';
  }

  @override
  String shortcuts_editor_title(String action) {
    return 'Сочетание: $action';
  }

  @override
  String get shortcuts_editor_help =>
      'Нажмите сочетание клавиш или выберите ниже модификаторы и клавишу:';

  @override
  String get shortcuts_editor_needs_modifier =>
      'Выберите хотя бы Cmd/Meta, Ctrl или Alt, чтобы не мешать вводу в поле сообщения.';

  @override
  String shortcuts_text_editing_warning(String chord) {
    return '$chord — сочетание для редактирования текста (копировать, вставить, вырезать, отменить, повторить или выделить всё). Если назначить его здесь, текстовые поля его потеряют.';
  }

  @override
  String shortcuts_text_editing_in_use(String action, String chord) {
    return '«$action» использует $chord — сочетание для редактирования текста. Пока оно назначено здесь, текстовые поля его теряют.';
  }

  @override
  String custom_headers_problem_format(int line) {
    return 'Строка $line: ожидается «Имя: Значение»';
  }

  @override
  String custom_headers_problem_missing_name(int line) {
    return 'Строка $line: нет имени заголовка';
  }

  @override
  String custom_headers_problem_invalid_name(int line, String name) {
    return 'Строка $line: недопустимое имя заголовка «$name»';
  }

  @override
  String custom_headers_problem_reserved(int line, String name) {
    return 'Строка $line: «$name» зарезервирован и не может передаваться';
  }

  @override
  String custom_headers_problem_empty_value(int line) {
    return 'Строка $line: пустое значение заголовка';
  }

  @override
  String get ng_enter_a_deployment_token =>
      'Введите токен сеанса развёртывания.';

  @override
  String get ng_custom_headers => 'Свои заголовки';

  @override
  String get ng_custom_headers_help =>
      'Дополнительные HTTP-заголовки для этого шлюза (Имя: Значение, по одному в строке), отправляются в его вызовах REST и WebSocket. Хранятся в защищённом хранилище учётных данных. Заголовки аутентификации и hop-by-hop отклоняются.';

  @override
  String get ng_use_a_deployment_token =>
      'Использовать токен сеанса развёртывания';

  @override
  String get ng_sign_in_with_deployment_token =>
      'Войти с токеном развёртывания';

  @override
  String get ng_signed_in_with_deployment_token =>
      'Вход выполнен с токеном развёртывания.';

  @override
  String get auto_speak_replies_title => 'Читать ответы вслух';

  @override
  String get auto_speak_replies_subtitle =>
      'Читает каждую новую реплику вслух после завершения хода. По умолчанию выключено; тоггл «Spoken replies» в чате по-прежнему действует.';

  @override
  String get ng_auto_read_replies_title => 'Читать ответы автоматически';

  @override
  String get ng_auto_read_replies_subtitle =>
      'Читает каждую новую реплику вслух после завершения хода. По умолчанию выключено.';

  @override
  String get barge_in_title => 'Перебить';

  @override
  String get barge_in_subtitle =>
      'Говорите во время ответа, чтобы прервать чтение. Микрофон остаётся включённым, пока ответы читаются вслух.';

  @override
  String get barge_in_mic_live =>
      'Микрофон включён: говорите, чтобы прервать ответ';

  @override
  String get ng_barge_in_title => 'Перебить';

  @override
  String get ng_barge_in_subtitle =>
      'Говорите во время ответа, чтобы прервать чтение. Микрофон остаётся включённым, пока ответы читаются вслух.';

  @override
  String get ng_barge_in_mic_live =>
      'Микрофон включён: говорите, чтобы прервать ответ';

  @override
  String get wake_word_title => 'Кодовая фраза';

  @override
  String get wake_word_subtitle =>
      'Распознавание кодовой фразы на шлюзе. По умолчанию выключено; передаёт звук с микрофона только при захвате на устройстве.';

  @override
  String wake_word_listening(String phrase) {
    return 'Ожидание кодовой фразы «$phrase»';
  }

  @override
  String wake_word_paused(String phrase) {
    return 'Кодовая фраза «$phrase» — пауза';
  }

  @override
  String wake_word_off(String phrase) {
    return 'Кодовая фраза «$phrase» — выкл.';
  }

  @override
  String get wake_word_arming => 'Включение кодовой фразы…';

  @override
  String get wake_word_stop => 'Остановить кодовую фразу';

  @override
  String get wake_word_rearm => 'Перезапустить';

  @override
  String get wake_word_capture_mode => 'Режим захвата';

  @override
  String get wake_word_capture_auto => 'Автоматически';

  @override
  String get wake_word_capture_client => 'Микрофон этого устройства';

  @override
  String get wake_word_capture_local => 'Микрофон хоста шлюза';

  @override
  String get wake_word_capture_unavailable =>
      'Этот шлюз не позволяет приложениям менять режим захвата. Задайте wake_word.capture в конфигурации Hermes на хосте шлюза.';

  @override
  String get wake_word_input_device => 'Входной микрофон';

  @override
  String get wake_word_default_device => 'По умолчанию системы';

  @override
  String get ng_wake_word_title => 'Кодовая фраза';

  @override
  String get ng_wake_word_subtitle =>
      'Распознавание кодовой фразы на шлюзе. По умолчанию выключено.';

  @override
  String get voice_engine_title => 'Движок голосового диалога';

  @override
  String get voice_engine_subtitle =>
      'Выберите, как работают голосовые диалоги без рук в этом профиле шлюза.';

  @override
  String get voice_engine_chained => 'Цепочка (речь в текст → Hermes → речь)';

  @override
  String get voice_engine_chained_short => 'Цепочка';

  @override
  String get voice_engine_live => 'GPT-Live (голос в реальном времени)';

  @override
  String get voice_engine_live_short => 'GPT-Live';

  @override
  String get voice_engine_live_needs_key =>
      'Укажите ключ OpenAI API на хосте шлюза, чтобы включить GPT-Live.';

  @override
  String voice_engine_fallback_chained(String reason) {
    return 'GPT-Live недоступен ($reason) — используется голос по цепочке.';
  }

  @override
  String get voice_live_start => 'Начать голосовой диалог';

  @override
  String get voice_live_stop => 'Завершить голосовой диалог';

  @override
  String get voice_live_mute => 'Выключить микрофон';

  @override
  String get voice_live_unmute => 'Включить микрофон';

  @override
  String get voice_live_interrupt => 'Прервать или ответить сейчас';

  @override
  String get voice_live_listening => 'Слушает';

  @override
  String get voice_live_speaking => 'Говорит';

  @override
  String get voice_live_thinking => 'Думает';

  @override
  String get voice_live_muted => 'Микрофон выключен';

  @override
  String get voice_live_ended_connection_lost =>
      'Сеанс живого голоса потерял соединение.';

  @override
  String get voice_live_ended_closed =>
      'Сеанс живого голоса был закрыт сервисом.';

  @override
  String wake_word_other_profile(String profile) {
    return 'Это слово активации относится к профилю «$profile». Откройте подключение к этому профилю, чтобы ответить.';
  }

  @override
  String get wake_word_reason_disabled => 'Выкл. — нажмите, чтобы включить';

  @override
  String get wake_word_reason_surface =>
      'Ограничено другим интерфейсом (настройка wake_word.surface)';

  @override
  String get wake_word_reason_owned =>
      'Прослушивание кодовой фразы занято другим интерфейсом';

  @override
  String wake_word_reason_owned_by(String surface) {
    return 'Прослушивание кодовой фразы занято другим интерфейсом ($surface)';
  }

  @override
  String get wake_word_reason_unavailable =>
      'Кодовая фраза недоступна на этом шлюзе';

  @override
  String get wake_word_reason_permission_denied =>
      'Доступ к микрофону запрещён';

  @override
  String get wake_word_reason_permission_required =>
      'Нужен доступ к микрофону — нажмите, чтобы включить';

  @override
  String get voice_live_not_enabled => 'GPT-Live не включён для этого профиля.';

  @override
  String get voice_live_not_available => 'GPT-Live недоступен';

  @override
  String voice_live_start_failed(String error) {
    return 'Не удалось запустить GPT-Live: $error';
  }

  @override
  String voice_direct_stt_timeout(String seconds, String provider) {
    return 'Распознавание речи не завершилось за $seconds с ($provider не ответил)';
  }

  @override
  String voice_direct_stt_error(String provider, String status) {
    return 'Ошибка STT $provider (HTTP $status)';
  }

  @override
  String voice_direct_tts_failed(String provider) {
    return 'Запрос TTS к $provider не выполнен';
  }

  @override
  String voice_direct_tts_error(String provider, String status) {
    return 'Ошибка TTS $provider (HTTP $status)';
  }

  @override
  String ng_wake_status_listening(String phrase) {
    return 'Слушает («$phrase»)';
  }

  @override
  String ng_wake_status_off(String phrase) {
    return 'Выкл. («$phrase»)';
  }

  @override
  String ng_wire_setting_unavailable(Object setting) {
    return 'Изменение параметра $setting пока недоступно на общем шлюзе';
  }

  @override
  String ng_wire_method_unavailable(Object method) {
    return 'Запрос $method пока недоступен на общем шлюзе';
  }

  @override
  String ng_wire_session_options_unsupported(Object options) {
    return 'Канонический шлюз не поддерживает явные параметры сеанса: $options';
  }

  @override
  String get ng_wire_prompt_stale =>
      'Запрос устарел или недоступен; переподключитесь, прежде чем отвечать';

  @override
  String get ng_wire_revision_unavailable =>
      'Ревизия сеанса недоступна; откройте сеанс заново, прежде чем изменять метаданные';

  @override
  String get ng_wire_generation_unavailable =>
      'Идентификатор выполнения сеанса недоступен; переподключитесь перед этой командой';

  @override
  String get ng_wire_message_not_saved =>
      'Это сообщение ещё не сохранено; дождитесь его завершения и создайте ветку от него снова';

  @override
  String get ng_wire_not_available => 'Пока недоступно на общем шлюзе';

  @override
  String get edit_turn_title => 'Изменить этот запрос?';

  @override
  String get edit_turn_body =>
      'Запрос будет выполнен заново с этого места. Последующие ходы будут архивированы.';

  @override
  String get edit_turn_send => 'Отправить';

  @override
  String get restore_turn_title => 'Восстановить до этой контрольной точки?';

  @override
  String get restore_turn_body =>
      'Всё после этого запроса будет удалено из диалога, и запрос выполнится заново с этого места.';

  @override
  String get restore_turn_confirm => 'Восстановить и повторить';

  @override
  String get edit_turn_later_turns_body =>
      'Последующие ходы диалога будут архивированы. Продолжить?';

  @override
  String get session_history => 'История сессии';

  @override
  String get import_claude_or_codex => 'Импорт из Claude или Codex';

  @override
  String get ng_session_history => 'История сессии';

  @override
  String get ng_import_claude_or_codex => 'Импорт из Claude или Codex';

  @override
  String get ng_edit_and_resend => 'Изменить и отправить снова';

  @override
  String get ng_restore_turn_confirm => 'Восстановить и повторить';

  @override
  String get rewind_target_unsaved =>
      'Это сообщение ещё не сохранено. Дождитесь завершения и отредактируйте его снова.';

  @override
  String get rewind_turn_busy =>
      'Текущий ответ ещё не остановлен, поэтому ничего не отправлено. Повторите попытку через мгновение.';

  @override
  String get rewind_session_changed =>
      'Этот чат изменился с момента открытия здесь, поэтому ничего не удалено и не отправлено. Откройте его заново и повторите попытку.';

  @override
  String get history_lineage => 'Связанные чаты';

  @override
  String get history_lineage_none =>
      'У этого чата нет ответвлений и соседних веток.';

  @override
  String get history_lineage_unavailable =>
      'Не удалось прочитать связанные чаты с этого шлюза.';

  @override
  String get history_lineage_parent => 'Родитель';

  @override
  String get history_lineage_sibling => 'Соседняя ветка';

  @override
  String get history_lineage_fork => 'Ответвление';

  @override
  String get history_messages => 'Сообщения';

  @override
  String get history_messages_hint =>
      'Выберите сохранённое сообщение, чтобы создать ветку или откатиться к нему.';

  @override
  String get history_messages_none => 'Сохранённых сообщений пока нет.';

  @override
  String get history_messages_unavailable =>
      'Не удалось прочитать сохранённые сообщения. Откройте этот чат и обновите.';

  @override
  String get history_role_user => 'Вы';

  @override
  String get history_role_assistant => 'Hermes';

  @override
  String get history_branch_here => 'Создать ветку отсюда';

  @override
  String get history_rewind_here => 'Откатить сюда';

  @override
  String get history_branch_title => 'Создать ветку от этого сообщения';

  @override
  String get history_branch_body =>
      'Будет создан новый чат с историей до выбранного сообщения. Текущий чат останется без изменений.';

  @override
  String get history_rewind_title => 'Откатить к этому сообщению';

  @override
  String get history_rewind_body =>
      'Сообщения начиная с выбранного будут удалены из этого чата. Файлы на компьютере не изменятся. Их восстановление выполняется отдельно через контрольные точки.';

  @override
  String history_branched(String id) {
    return 'Создана ветка $id';
  }

  @override
  String get history_open_chat => 'Открыть чат';

  @override
  String get history_mutate_unsupported =>
      'Для веток и отката на этом шлюзе нужен Hermes 0.23 или новее.';

  @override
  String get history_checkpoints => 'Контрольные точки';

  @override
  String get history_checkpoints_none =>
      'В этой сессии нет контрольных точек файлов.';

  @override
  String get history_checkpoints_unavailable =>
      'Контрольные точки недоступны на этом шлюзе.';

  @override
  String get history_diff_none => 'Различий нет.';

  @override
  String get history_diff_loading => 'Загрузка изменений…';

  @override
  String get history_diff_failed =>
      'Не удалось загрузить изменения, поэтому эту контрольную точку пока нельзя восстановить.';

  @override
  String get history_restore_checkpoint => 'Восстановить контрольную точку';

  @override
  String get history_restore_title => 'Восстановить эту контрольную точку';

  @override
  String get history_restore_body =>
      'Файлы, изменённые агентом после этой контрольной точки, вернутся к тогдашнему состоянию. Ваши собственные изменения сохранятся. Более поздние сообщения чата тоже могут быть удалены. Ветка разговора не создаётся.';

  @override
  String get history_restore_body_all =>
      'Все файлы в папке сессии вернутся к этой контрольной точке, включая ваши собственные изменения. Более поздние сообщения чата тоже могут быть удалены. Ветка разговора не создаётся.';

  @override
  String get history_restore_own_edits => 'Отменить и мои собственные правки';

  @override
  String get history_restored => 'Контрольная точка восстановлена.';

  @override
  String history_restored_removed(int count) {
    return 'Контрольная точка восстановлена. Удалено сообщений чата: $count.';
  }

  @override
  String get history_export => 'Экспорт';

  @override
  String get history_export_redact => 'Скрывать токены';

  @override
  String get history_export_action => 'Экспортировать расшифровку';

  @override
  String get history_export_saved => 'Расшифровка сохранена.';

  @override
  String get history_export_unsupported =>
      'Для экспорта на этом шлюзе нужен Hermes 0.23 или новее.';

  @override
  String get history_import_unsupported =>
      'Этот шлюз не поддерживает импорт из Claude и Codex.';

  @override
  String history_import_destination(String profile) {
    return 'Профиль назначения: $profile.';
  }

  @override
  String history_import_reading(String host, String profile, int count) {
    return 'Чтение с $host · Профиль назначения: $profile. Не удалось прочитать журналов: $count.';
  }

  @override
  String get history_import_all => 'Все';

  @override
  String history_import_scan_failed(String reason) {
    return 'Не удалось просмотреть сессии хоста: $reason';
  }

  @override
  String get history_import_none =>
      'На этом хосте не найдено сессий Claude Code или Codex.';

  @override
  String get history_import_no_match => 'Подходящих сессий хоста нет.';

  @override
  String history_import_preview_failed(String reason) {
    return 'Не удалось показать сессию: $reason';
  }

  @override
  String get history_import_open => 'Открыть импортированную сессию';

  @override
  String get history_import_action => 'Импортировать выбранную сессию';

  @override
  String get history_import_title => 'Импортировать эту сессию';

  @override
  String history_import_body(String profile) {
    return 'Скопировать эту сессию Claude или Codex в профиль «$profile» на этом шлюзе.';
  }

  @override
  String history_import_body_existing(String profile) {
    return 'Эта сессия уже импортирована в «$profile». Продолжить с существующей копией.';
  }

  @override
  String history_imported(String id) {
    return 'Импортировано как $id';
  }

  @override
  String history_imported_already(String id) {
    return 'Уже импортировано как $id';
  }

  @override
  String history_import_directory(String path) {
    return 'Каталог: $path';
  }

  @override
  String history_import_preview_partial(int shown, int total) {
    return 'Показано $shown из $total.';
  }

  @override
  String history_failed(String reason) {
    return 'Не удалось завершить: $reason';
  }

  @override
  String get history_error_unavailable =>
      'Шлюз не смог выполнить это сейчас. Повторите попытку.';

  @override
  String get history_error_unsupported => 'Этот шлюз это не поддерживает.';

  @override
  String get history_error_denied => 'Этот шлюз отклонил запрос.';

  @override
  String get history_error_changed =>
      'Этот чат изменился, пока страница была открыта. Обновите и повторите попытку.';

  @override
  String get history_error_unbound =>
      'Этот чат не открыт на шлюзе. Откройте его и повторите попытку.';

  @override
  String get history_error_invalid =>
      'Шлюз прислал ответ, который приложение не смогло прочитать.';

  @override
  String ng_dock_kanban(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count карточки Kanban',
      many: '$count карточек Kanban',
      few: '$count карточки Kanban',
      one: '$count карточка Kanban',
    );
    return '$_temp0';
  }

  @override
  String ng_dock_kanban_done(int count) {
    return '$count завершено';
  }

  @override
  String get ng_show_kanban => 'Показать карточки Kanban';

  @override
  String get ng_hide_kanban => 'Скрыть карточки Kanban';

  @override
  String get ng_kanban_status_triage => 'Разбор';

  @override
  String get ng_kanban_status_todo => 'К выполнению';

  @override
  String get ng_kanban_status_scheduled => 'Запланировано';

  @override
  String get ng_kanban_status_ready => 'Готово к работе';

  @override
  String get ng_kanban_status_running => 'Выполняется';

  @override
  String get ng_kanban_status_blocked => 'Заблокировано';

  @override
  String get ng_kanban_status_review => 'На проверке';

  @override
  String get ng_kanban_status_done => 'Завершено';

  @override
  String get ng_kanban_status_archived => 'В архиве';

  @override
  String ng_kanban_open_card(String title) {
    return 'Открыть «$title» в Kanban';
  }

  @override
  String ng_kanban_show_all(int count) {
    return 'Показать все ($count)';
  }

  @override
  String ng_kanban_this_chat(int count) {
    return 'Этот чат ($count)';
  }

  @override
  String get ng_kanban_close => 'Закрыть Kanban';

  @override
  String get ng_kanban_block_no_dashboard =>
      'У этого подключения нет доступа к панели управления, поэтому статус карточек не обновляется в реальном времени, а доску открыть нельзя.';

  @override
  String get ng_kanban_block_unsupported =>
      'Kanban не включён на этом шлюзе. Включите плагин kanban, чтобы видеть статус в реальном времени и открывать доску.';

  @override
  String get ng_kanban_block_denied =>
      'Войдите в панель управления, чтобы видеть статус карточек в реальном времени и открывать доску.';

  @override
  String get ng_kanban_block_insecure =>
      'Для Kanban нужен HTTPS или локальное подключение, поэтому статус карточек не обновляется в реальном времени, а доску открыть нельзя.';

  @override
  String get ng_kanban_block_unreachable =>
      'Не удалось связаться с Kanban на этом шлюзе. Статус карточек может быть устаревшим.';

  @override
  String get ng_kanban_block_stale =>
      'Подключение изменилось. Откройте этот чат заново, чтобы видеть статус карточек в реальном времени.';

  @override
  String get ng_bots_tab_roster => 'Состав';

  @override
  String get ng_bots_tab_rooms => 'Комнаты';

  @override
  String get ng_bots_tab_screen => 'Экран';

  @override
  String get ng_bots_tab_routines => 'Рутины';

  @override
  String ng_bots_rooms_load_failed(String error) {
    return 'Не удалось загрузить комнаты: $error';
  }

  @override
  String ng_bots_routines_load_failed(String error) {
    return 'Не удалось загрузить рутины: $error';
  }

  @override
  String ng_bots_desktop_failed(String error) {
    return 'Bot Desktop: $error';
  }

  @override
  String get ng_bots_install_not_started => 'Шлюз не запустил установку.';

  @override
  String ng_bots_install_failed_error(String error) {
    return 'Ошибка установки: $error';
  }

  @override
  String get ng_bots_install_cancelled => 'Установка отменена.';

  @override
  String get ng_bots_install_no_sudo =>
      'sudo недоступен на хосте шлюза. Выполните там команду выше, затем обновите.';

  @override
  String ng_bots_install_exit_code(String code) {
    return 'Установка не удалась (код выхода $code).';
  }

  @override
  String ng_bots_install_done(String bot) {
    return 'Bot Desktop установлен для $bot';
  }

  @override
  String get ng_bots_start_failed => 'Не удалось запустить';

  @override
  String ng_bots_stop_title(String bot) {
    return 'Остановить Bot Desktop для $bot?';
  }

  @override
  String get ng_bots_stop_human_held =>
      'Кто-то управляет этим экраном. Остановка завершит сеанс этого человека и закроет всё, что открыто на экране.';

  @override
  String get ng_bots_stop_body =>
      'Всё, что открыто на экране бота, будет закрыто.';

  @override
  String get ng_bots_stop_refused => 'Остановка отклонена';

  @override
  String get ng_bots_take_over_reason => 'Управление взято из Ares';

  @override
  String ng_bots_take_over_failed(String error) {
    return 'Не удалось взять управление: $error';
  }

  @override
  String ng_bots_force_hand_back_title(String bot) {
    return 'Вернуть экран $bot боту?';
  }

  @override
  String get ng_bots_force_hand_back_body =>
      'Этим экраном управляет человек. Если он ещё работает с ним, управление будет потеряно.';

  @override
  String get ng_bots_hand_back => 'Вернуть управление';

  @override
  String get ng_bots_hand_back_failed => 'Не удалось вернуть управление';

  @override
  String get ng_bots_adopt_title => 'Перейти на новый образ песочницы?';

  @override
  String ng_bots_adopt_body(String bot, String current, String target) {
    return '$bot переходит с $current на $target. Контейнер будет пересоздан при следующем вызове терминала; всё, что хранится только в текущем контейнере, будет потеряно.';
  }

  @override
  String get ng_bots_adopt_image => 'Перейти на образ';

  @override
  String get ng_bots_image_switch_failed => 'Не удалось сменить образ';

  @override
  String get ng_bots_keep_refused => 'Запрос на сохранение образа отклонён';

  @override
  String ng_bots_chat_open_failed(String error) {
    return 'Не удалось открыть Bot Chat: $error';
  }

  @override
  String ng_bots_title(String connection) {
    return 'Боты · $connection';
  }

  @override
  String get ng_bots_protocol_tooltip =>
      'Шлюз сам добавляет протокол обмена сообщениями между участниками команды — дополнительный протокол SOUL.md не отправляется.';

  @override
  String ng_bots_unavailable(String reason) {
    return 'Боты недоступны ($reason)';
  }

  @override
  String get ng_bots_account_changed =>
      'Аккаунт изменился. Переподключитесь или обновите.';

  @override
  String get ng_bots_try_refresh =>
      'Попробуйте обновить. Если проблема сохранится, возможно, шлюз не поддерживает ботов.';

  @override
  String get ng_bots_search => 'Поиск ботов';

  @override
  String get ng_bots_none_found => 'Боты не найдены.';

  @override
  String get ng_bots_no_model => 'нет модели';

  @override
  String ng_bots_skill_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count навыка',
      many: '$count навыков',
      few: '$count навыка',
      one: '$count навык',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_bot_chat => 'Bot Chat';

  @override
  String ng_bots_install_id(String id, String protocol) {
    return 'Шлюз сообщает ID установки $id · bot_mode_protocol: $protocol';
  }

  @override
  String get ng_bots_protocol_note =>
      'Шлюз добавляет протокол обмена сообщениями между участниками команды, если задан bot_mode_protocol. Идентификатор: default→hermes, в остальных случаях — имя профиля.';

  @override
  String get ng_bots_no_rooms =>
      'Комнат пока нет. Создайте комнату из состава ботов.';

  @override
  String ng_bots_member_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count участника',
      many: '$count участников',
      few: '$count участника',
      one: '$count участник',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_room_disbanded => 'расформирована';

  @override
  String get ng_bots_room_adopted => 'принята';

  @override
  String get ng_bots_rooms_gateway => 'Комнаты шлюза';

  @override
  String get ng_bots_rooms_desktop => 'Комнаты под управлением Desktop';

  @override
  String ng_bots_rooms_gateway_body(String methods) {
    return 'Комнаты принадлежат шлюзу. Методы: $methods.';
  }

  @override
  String get ng_bots_rooms_no_seat =>
      'Этот шлюз, возможно, не может размещать комнаты (требуется постоянный процесс).';

  @override
  String get ng_bots_rooms_fallback =>
      'Классический резервный режим: Desktop ведёт раунды группы (здесь новые не создаются).';

  @override
  String get ng_bots_create_room => 'Создать комнату';

  @override
  String get ng_bots_refresh_rooms => 'Обновить комнаты';

  @override
  String get ng_bots_room_created => 'Комната создана';

  @override
  String ng_bots_room_refused(String reason) {
    return 'Создание комнаты отклонено ($reason)';
  }

  @override
  String ng_bots_room_failed(String error) {
    return 'Не удалось создать комнату: $error';
  }

  @override
  String get ng_bots_bot => 'Бот';

  @override
  String get ng_bots_screen_unavailable => 'Состояние экрана недоступно';

  @override
  String get ng_bots_screen_unavailable_body =>
      'Запустите экран бота, чтобы видеть миниатюру, или возьмите управление, чтобы работать с ним самостоятельно.';

  @override
  String get ng_bots_take_over_note =>
      '«Взять управление» открывает экран в реальном времени и передаёт вам управление им. Управление возвращается боту, когда вы закрываете экран, покидаете эту страницу или переводите приложение в фоновый режим.';

  @override
  String get ng_bots_not_installed => 'Не установлен';

  @override
  String get ng_bots_unsupported_host => 'Неподдерживаемый хост';

  @override
  String ng_bots_pid(String pid) {
    return 'pid $pid';
  }

  @override
  String ng_bots_missing(String items) {
    return 'не хватает: $items';
  }

  @override
  String ng_bots_blocked(String reason) {
    return 'заблокировано: $reason';
  }

  @override
  String get ng_bots_no_switch => 'Нет ожидающей смены образа песочницы.';

  @override
  String ng_bots_switch_image(String current, String target) {
    return 'смена образа: $current → $target';
  }

  @override
  String get ng_bots_bot_in_control => 'управляет бот';

  @override
  String get ng_bots_person_in_control => 'управляет человек';

  @override
  String get ng_bots_installing => 'Установка Bot Desktop на хост шлюза…';

  @override
  String get ng_bots_install_unfinished => 'Установка не завершена';

  @override
  String get ng_bots_install => 'Установить';

  @override
  String get ng_bots_start => 'Запустить';

  @override
  String get ng_bots_take_over => 'Взять управление';

  @override
  String get ng_bots_keep_image => 'Оставить текущий образ';

  @override
  String ng_bots_missing_pieces(String items) {
    return 'Шлюз сообщил об отсутствующих компонентах: $items';
  }

  @override
  String get ng_bots_install_missing => 'Установить недостающие компоненты';

  @override
  String get ng_bots_thumbnail_unavailable => 'Миниатюра недоступна';

  @override
  String get ng_bots_thumbnail_title => 'Миниатюра экрана (в реальном времени)';

  @override
  String get ng_bots_thumbnail_suppressed =>
      'Миниатюра скрыта, пока экраном управляет человек.';

  @override
  String get ng_bots_thumbnail_pending => 'Миниатюра пока недоступна.';

  @override
  String ng_bots_routines_of(String bot) {
    return '$bot · рутины';
  }

  @override
  String get ng_bots_add_routine => 'Добавить рутину';

  @override
  String get ng_bots_no_routines => 'У этого бота нет рутин.';

  @override
  String get ng_bots_routines_note =>
      'Рутины — это задания с тегом [bot:<name>], принадлежащие хранилищу профиля бота. Устаревшие делегированные рутины при загрузке принудительно приостанавливаются.';

  @override
  String ng_bots_routine_last(String status) {
    return 'последний: $status';
  }

  @override
  String ng_bots_routine_next(String time) {
    return 'следующий: $time';
  }

  @override
  String ng_bots_routine_error(String error) {
    return 'ошибка: $error';
  }

  @override
  String ng_bots_remove_routine_title(String routine) {
    return 'Удалить рутину $routine?';
  }

  @override
  String ng_bots_remove_routine_body(String bot) {
    return 'Рутина будет удалена из расписания $bot. Это действие нельзя отменить.';
  }

  @override
  String ng_bots_routine_action_failed(String action, String error) {
    return 'Не удалось выполнить «$action»: $error';
  }

  @override
  String get ng_bots_not_connected => 'Нет подключения.';

  @override
  String ng_bots_add_failed(String error) {
    return 'Не удалось добавить: $error';
  }

  @override
  String get ng_bots_routine_added => 'Рутина добавлена';

  @override
  String get ng_bots_routine_enabled => 'включена';

  @override
  String get ng_bots_routine_paused => 'приостановлена';

  @override
  String ng_bots_path(String path) {
    return 'Путь: $path';
  }

  @override
  String get ng_bots_chat_present => 'Bot Chat присутствует';

  @override
  String get ng_bots_chat_missing => 'Bot Chat отсутствует';

  @override
  String ng_bots_last_session(String preview) {
    return 'Последний сеанс: $preview';
  }

  @override
  String get ng_bots_open_chat => 'Открыть Bot Chat';

  @override
  String get ng_bots_desktop => 'Bot Desktop';

  @override
  String get ng_bots_room_name => 'Название комнаты';

  @override
  String get ng_bots_select_member => 'Выберите хотя бы одного участника.';

  @override
  String get ng_bots_sudo_title => 'Пароль администратора';

  @override
  String ng_bots_sudo_body(String bot) {
    return 'Для установки Bot Desktop для $bot нужен sudo на хосте шлюза. Пароль отправляется только на этот шлюз, только для этой установки, и не сохраняется.';
  }

  @override
  String get ng_bots_sudo_password => 'Пароль sudo';

  @override
  String get ng_bots_new_routine => 'Новая рутина';

  @override
  String get ng_bots_routine_title => 'Название';

  @override
  String get ng_bots_routine_instruction => 'Инструкция';

  @override
  String get ng_bots_cron => 'Выражение cron';

  @override
  String get ng_bots_interval => 'Интервал';

  @override
  String get ng_bots_cron_help => '0 9 * * * — запуск каждый день в 09:00';

  @override
  String get ng_bots_every => 'Каждые';

  @override
  String get ng_bots_unit_minutes => 'минуты';

  @override
  String get ng_bots_unit_hours => 'часы';

  @override
  String get ng_bots_unit_days => 'дни';

  @override
  String get ng_bots_stop_after => 'Остановить после (запусков)';

  @override
  String get ng_bots_stop_after_help =>
      'Оставьте пустым, чтобы выполнять без ограничений';

  @override
  String get ng_bots_send_results => 'Отправлять результаты в';

  @override
  String get ng_bots_run_history => 'Только история запусков';

  @override
  String get ng_bots_continuity => 'Продолжать с предыдущего запуска';

  @override
  String get ng_bots_account_changed_refresh =>
      'Аккаунт изменился. Обновите, прежде чем продолжить.';

  @override
  String ng_bots_room_load_failed(String error) {
    return 'Не удалось загрузить комнату: $error';
  }

  @override
  String ng_bots_send_failed(String error) {
    return 'Не удалось отправить: $error';
  }

  @override
  String ng_bots_stop_failed(String error) {
    return 'Не удалось остановить: $error';
  }

  @override
  String get ng_bots_stop_room => 'Остановить комнату';

  @override
  String get ng_bots_send_message => 'Отправить сообщение';

  @override
  String get ng_bots_room_hint =>
      'Сообщение в комнату (упоминайте участников через @handle)';

  @override
  String get ng_bots_history => 'История';

  @override
  String ng_bots_revision(String revision) {
    return 'ревизия $revision';
  }

  @override
  String ng_bots_last_error(String error) {
    return 'последняя ошибка: $error';
  }

  @override
  String get ng_bots_members => 'Участники';

  @override
  String get ng_bots_room_context => 'Контекст комнаты';

  @override
  String ng_bots_purpose(String purpose) {
    return 'Цель: $purpose';
  }

  @override
  String ng_bots_notes(String notes) {
    return 'Заметки: $notes';
  }

  @override
  String ng_bots_routing(String routing) {
    return 'Маршрутизация: $routing';
  }

  @override
  String ng_bots_lead(String member) {
    return 'ведущий $member';
  }

  @override
  String get ng_bots_viewer_you_control =>
      'Вы управляете этим экраном. Бот ждёт, пока вы не вернёте управление.';

  @override
  String get ng_bots_viewer_handed_back => 'Управление возвращено боту.';

  @override
  String get ng_bots_viewer_background =>
      'Управление возвращено боту, так как приложение ушло в фон.';

  @override
  String get ng_bots_viewer_taken =>
      'Кто-то другой взял управление этим экраном.';

  @override
  String get ng_bots_viewer_lost =>
      'Трансляция экрана прервалась, поэтому управление возвращено боту.';

  @override
  String ng_bots_viewer_title(String bot) {
    return 'Bot Desktop · $bot';
  }

  @override
  String get ng_bots_viewer_type_hint => 'Ввод на экране бота';

  @override
  String get ng_bots_viewer_type => 'Ввести';

  @override
  String get ng_bots_viewer_enter => 'Enter';

  @override
  String get ng_bots_viewer_backspace => 'Backspace';

  @override
  String get ng_more_kanban => 'Kanban';

  @override
  String get ng_more_kanban_subtitle =>
      'Доски, зависимости задач, назначение исполнителей и журналы';

  @override
  String get ng_more_bots => 'Боты';

  @override
  String get ng_more_bots_subtitle => 'Состав, комнаты, рутины и Bot Desktop';

  @override
  String get ng_slash_kanban => 'Открыть доску Kanban';

  @override
  String get ng_slash_bots => 'Открыть ваших ботов';

  @override
  String ng_board_card_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count карточки',
      many: '$count карточек',
      few: '$count карточки',
      one: '$count карточка',
    );
    return '$_temp0';
  }

  @override
  String ng_board_event_toast(String task, String event) {
    return 'Kanban $task: $event';
  }

  @override
  String get ng_board_task => 'задача';

  @override
  String ng_board_refused_http(String status) {
    return 'Действие отклонено (HTTP $status).';
  }

  @override
  String get ng_board_err_unsupported =>
      'Плагин Kanban не включён на этом шлюзе.';

  @override
  String get ng_board_err_denied =>
      'На этом шлюзе требуется вход или разрешение.';

  @override
  String get ng_board_err_stale =>
      'Владелец шлюза изменился. Обновите, прежде чем продолжить.';

  @override
  String get ng_board_err_insecure =>
      'Для операций с рабочим пространством Kanban требуется HTTPS (или loopback).';

  @override
  String get ng_board_err_unreachable =>
      'Не удалось связаться со службой Kanban на этом шлюзе.';

  @override
  String get ng_board_err_failed =>
      'Операция не выполнена. Обновите и повторите попытку.';

  @override
  String ng_board_block_title(String task) {
    return 'Заблокировать $task';
  }

  @override
  String get ng_board_block_reason => 'Причина блокировки';

  @override
  String get ng_board_block_hint => 'Что блокирует эту карточку?';

  @override
  String ng_board_review_title(String task) {
    return 'Запросить проверку $task';
  }

  @override
  String get ng_board_review_summary => 'Сводка для проверки';

  @override
  String get ng_board_review_hint => 'Что было реализовано и проверено?';

  @override
  String ng_board_move_title(String cards, String column) {
    return 'Переместить в $column: $cards?';
  }

  @override
  String ng_board_move_body(String board) {
    return 'Все выбранные карточки на доске $board сменят колонку. Выполняющиеся карточки будут остановлены.';
  }

  @override
  String get ng_board_move => 'Переместить';

  @override
  String ng_board_moved(String column) {
    return 'Карточки перемещены в $column';
  }

  @override
  String ng_board_unassign_title(String cards) {
    return 'Снять исполнителя: $cards?';
  }

  @override
  String ng_board_assign_title(String cards, String profile) {
    return 'Назначить @$profile исполнителем: $cards?';
  }

  @override
  String get ng_board_assign_body =>
      'Выполняющиеся карточки сначала возвращаются: их исполнители останавливаются.';

  @override
  String get ng_board_unassign => 'Снять назначение';

  @override
  String get ng_board_assign => 'Назначить';

  @override
  String get ng_board_unassigned_done =>
      'С выбранных карточек снято назначение';

  @override
  String ng_board_assigned_done(String profile) {
    return 'Назначен @$profile';
  }

  @override
  String ng_board_archive_title(String cards) {
    return 'Отправить в архив: $cards?';
  }

  @override
  String ng_board_archive_body(String board) {
    return 'Архивированные карточки исчезнут с доски $board. Включите «Архивные», чтобы снова их увидеть.';
  }

  @override
  String get ng_board_archived_done => 'Выбранные карточки архивированы';

  @override
  String ng_board_delete_title(String cards) {
    return 'Удалить: $cards?';
  }

  @override
  String ng_board_delete_body(String board) {
    return 'Выбранные карточки будут безвозвратно удалены с доски $board.';
  }

  @override
  String ng_board_deleted(String cards) {
    return 'Удалено: $cards.';
  }

  @override
  String ng_board_partial_failure(String failed, String total, String reason) {
    return 'Не выполнено $failed из $total: $reason';
  }

  @override
  String get ng_board_refused => 'отклонено';

  @override
  String ng_board_dispatched(
    String spawned,
    String promoted,
    String reclaimed,
  ) {
    return 'Диспетчеризация: запущено $spawned, продвинуто $promoted, возвращено $reclaimed.';
  }

  @override
  String ng_board_board_archived(String board) {
    return 'Доска $board архивирована';
  }

  @override
  String ng_board_board_archived_to(String path) {
    return 'Архивировано в $path';
  }

  @override
  String ng_board_exported(String board, String archive) {
    return 'Доска $board экспортирована в $archive';
  }

  @override
  String ng_board_imported(String board, String warnings) {
    return 'Доска $board импортирована$warnings';
  }

  @override
  String ng_board_created(String task) {
    return 'Создана задача $task';
  }

  @override
  String get ng_board_orchestration_saved => 'Оркестрация Kanban сохранена';

  @override
  String get ng_board_auto_describe_unavailable => 'Автоописание недоступно';

  @override
  String ng_board_description_updated(String profile) {
    return 'Описание @$profile обновлено';
  }

  @override
  String ng_board_title(String board) {
    return 'Kanban · $board';
  }

  @override
  String ng_board_active(String count) {
    return 'активно: $count';
  }

  @override
  String get ng_board_dispatch => 'Запустить готовые задачи сейчас';

  @override
  String get ng_board_orchestration => 'Оркестрация и исполнители';

  @override
  String get ng_board_new_task => 'Новая задача';

  @override
  String get ng_board_enable_plugin =>
      'Включите встроенный плагин «kanban» в разделе «Возможности → Плагины» на этом шлюзе, чтобы активировать его маршрутизатор досок.';

  @override
  String get ng_board_filter => 'Фильтр задач…';

  @override
  String get ng_board_all_assignees => 'Все исполнители';

  @override
  String get ng_board_unassigned => 'Без исполнителя';

  @override
  String get ng_board_running_by_profile => 'Выполняется по профилям';

  @override
  String get ng_board_select => 'Выбрать';

  @override
  String ng_board_selected_chip(String count) {
    return 'Выбрано ($count)';
  }

  @override
  String get ng_board_locked_column =>
      'Управляемая колонка — перетаскивание отключено';

  @override
  String ng_board_add_to(String column) {
    return 'Добавить в $column';
  }

  @override
  String ng_board_collapse(String column) {
    return 'Свернуть $column';
  }

  @override
  String ng_board_column_empty(String column) {
    return 'Нет задач в $column';
  }

  @override
  String get ng_board_drop_here => 'Перетащите сюда или + задача';

  @override
  String get ng_board_card_actions => 'Действия с карточкой';

  @override
  String get ng_board_open_details => 'Открыть подробности';

  @override
  String get ng_board_select_card => 'Выбрать карточку';

  @override
  String ng_board_move_to(String column) {
    return 'Переместить в $column';
  }

  @override
  String get ng_board_parked => 'Отложено';

  @override
  String ng_board_blocked_by(String count) {
    return 'Блокируют: $count';
  }

  @override
  String get ng_board_goal_loop => 'Целевой цикл';

  @override
  String ng_board_selected(String count) {
    return 'Выбрано: $count';
  }

  @override
  String get ng_board_move_menu => 'Переместить…';

  @override
  String get ng_board_assign_menu => 'Назначить…';

  @override
  String get ng_board_new_board_title => 'Новая доска Kanban';

  @override
  String get ng_board_slug => 'Slug (строчные буквы, например release-v5)';

  @override
  String get ng_board_display_name => 'Отображаемое имя';

  @override
  String get ng_board_linked_project => 'Связанный проект (необязательно)';

  @override
  String get ng_board_none => 'Нет';

  @override
  String get ng_board_default_workdir =>
      'Рабочий каталог по умолчанию на хосте (необязательно)';

  @override
  String get ng_board_import_title => 'Импорт архива доски';

  @override
  String get ng_board_import_path => 'Путь к архиву .tar.gz на хосте';

  @override
  String get ng_board_import => 'Импортировать';

  @override
  String ng_board_edit_board(String board) {
    return 'Изменить $board';
  }

  @override
  String get ng_board_name => 'Название';

  @override
  String get ng_board_description => 'Описание';

  @override
  String get ng_board_workdir_clear =>
      'Рабочий каталог по умолчанию (пусто — очистить)';

  @override
  String get ng_board_boards => 'Доски Kanban';

  @override
  String get ng_board_new_board => 'Новая доска';

  @override
  String get ng_board_search_boards => 'Поиск досок…';

  @override
  String get ng_board_unpin => 'Открепить вкладку';

  @override
  String get ng_board_pin => 'Закрепить вкладку';

  @override
  String ng_board_archive_board_title(String board) {
    return 'Архивировать доску $board?';
  }

  @override
  String ng_board_archive_board_body(String cards) {
    return 'Доска и её карточки ($cards) исчезнут из списка досок. Шлюз сохранит архив на своём хосте.';
  }

  @override
  String get ng_board_edit_metadata => 'Изменить метаданные';

  @override
  String get ng_board_export => 'Экспорт .tar.gz на хосте';

  @override
  String get ng_board_move_pin_left => 'Переместить закреплённую вкладку влево';

  @override
  String get ng_board_archive_board => 'Архивировать доску';

  @override
  String get ng_board_new_task_title => 'Новая задача Kanban';

  @override
  String get ng_board_title_required => 'Название *';

  @override
  String get ng_board_spec => 'Спецификация и критерии приёмки';

  @override
  String get ng_board_estimate => 'Оценить';

  @override
  String ng_board_estimate_draft(String complexity, String tokens) {
    return 'Сложность $complexity (~$tokens ток. — только оценка токенов, а не стоимости в долларах)';
  }

  @override
  String get ng_board_estimate_unavailable => 'Оценка недоступна';

  @override
  String get ng_board_initial_column => 'Начальная колонка';

  @override
  String get ng_board_worker_assignee => 'Назначенный исполнитель';

  @override
  String get ng_board_parked_unassigned => 'Отложено (без исполнителя)';

  @override
  String get ng_board_priority => 'Приоритет';

  @override
  String get ng_board_workspace => 'Рабочее пространство';

  @override
  String get ng_board_scratch => 'Временное';

  @override
  String get ng_board_worktree => 'Git worktree';

  @override
  String get ng_board_shared_dir => 'Общий каталог';

  @override
  String get ng_board_workspace_path => 'Путь к рабочему пространству на хосте';

  @override
  String get ng_board_parent => 'Родительская зависимость (необязательно)';

  @override
  String get ng_board_skills =>
      'Закреплённые навыки (через запятую, необязательно)';

  @override
  String get ng_board_provider_override => 'Переопределение провайдера';

  @override
  String get ng_board_model_override => 'Переопределение модели';

  @override
  String get ng_board_reasoning => 'Глубина рассуждений';

  @override
  String get ng_board_profile_default => 'По умолчанию для профиля';

  @override
  String get ng_board_xhigh => 'Очень высокая';

  @override
  String get ng_board_goal_mode => 'Режим целевого цикла';

  @override
  String get ng_board_goal_turns =>
      'Макс. число ходов цикла (пусто = по умолчанию)';

  @override
  String get ng_board_create_task => 'Создать задачу';

  @override
  String get ng_board_orchestration_title =>
      'Оркестрация и профили исполнителей';

  @override
  String ng_board_orchestrator(String profile) {
    return 'Профиль оркестратора (фактически: $profile)';
  }

  @override
  String get ng_board_inherit_default =>
      'Наследовать текущий профиль по умолчанию';

  @override
  String ng_board_default_assignee(String profile) {
    return 'Исполнитель по умолчанию (фактически: $profile)';
  }

  @override
  String get ng_board_auto_decompose =>
      'Автоматически разбивать карточки из сортировки';

  @override
  String get ng_board_auto_decompose_help =>
      'Применяет настроенную модель kanban_decomposer к задачам из сортировки';

  @override
  String get ng_board_save_orchestration => 'Сохранить оркестрацию';

  @override
  String get ng_board_worker_descriptions =>
      'Описания специализаций исполнителей';

  @override
  String ng_board_worker_label(String profile, String model, String skills) {
    return '@$profile ($model · $skills)';
  }

  @override
  String get ng_board_default_model => 'модель по умолчанию';

  @override
  String get ng_board_save_description => 'Сохранить описание';

  @override
  String get ng_board_auto_describe => 'Автоописание по навыкам и персоне';

  @override
  String get ng_board_manual_block => 'Ручная блокировка оператором';

  @override
  String get ng_board_requested_review => 'Запрошена проверка';

  @override
  String ng_board_requeue_title(String task) {
    return 'Вернуть $task в очередь?';
  }

  @override
  String get ng_board_requeue_body =>
      'Исполнитель, работающий над этой карточкой, будет остановлен, а карточка вернётся в очередь.';

  @override
  String get ng_board_requeue => 'Вернуть в очередь';

  @override
  String ng_board_reassign_title(String task, String profile) {
    return 'Переназначить $task на @$profile?';
  }

  @override
  String get ng_board_reassign_body =>
      'Эта карточка выполняется: сначала будет остановлен её исполнитель.';

  @override
  String get ng_board_reassign => 'Переназначить';

  @override
  String ng_board_saved_task(String task) {
    return 'Задача $task сохранена';
  }

  @override
  String get ng_board_commented_requeued =>
      'Комментарий опубликован, задача возвращена в очередь';

  @override
  String get ng_board_commented => 'Комментарий опубликован';

  @override
  String ng_board_requeued(String task) {
    return 'Задача $task возвращена в очередь';
  }

  @override
  String get ng_board_decompose_failed => 'Не удалось разбить задачу.';

  @override
  String ng_board_decompose_failed_reason(String reason) {
    return 'Не удалось разбить задачу: $reason';
  }

  @override
  String ng_board_decomposed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Разбито на $count дочерней задачи',
      many: 'Разбито на $count дочерних задач',
      few: 'Разбито на $count дочерние задачи',
      one: 'Разбито на $count дочернюю задачу',
    );
    return '$_temp0';
  }

  @override
  String get ng_board_no_children => 'Дочерние задачи не созданы.';

  @override
  String ng_board_no_children_reason(String reason) {
    return 'Дочерние задачи не созданы: $reason';
  }

  @override
  String ng_board_uploaded(String file) {
    return 'Файл $file загружен';
  }

  @override
  String ng_board_linked_parent(String task) {
    return 'Родительская задача $task связана';
  }

  @override
  String ng_board_unlinked_parent(String task) {
    return 'Связь с родительской задачей $task удалена';
  }

  @override
  String get ng_board_task_load_failed => 'Не удалось загрузить задачу';

  @override
  String get ng_board_refresh_task => 'Обновить задачу';

  @override
  String get ng_board_tab_overview => 'Обзор';

  @override
  String get ng_board_tab_comments => 'Комментарии и ссылки';

  @override
  String get ng_board_tab_runs => 'Запуски и журнал';

  @override
  String get ng_board_tab_events => 'События';

  @override
  String get ng_board_decompose => 'Разбить';

  @override
  String get ng_board_attach => 'Прикрепить файл';

  @override
  String ng_board_estimate_task(
    String complexity,
    String tokens,
    String rationale,
  ) {
    return 'Оценка: $complexity · ~$tokens токенов ($rationale) — это не оценка стоимости в долларах.';
  }

  @override
  String get ng_board_no_rationale => 'без обоснования';

  @override
  String get ng_board_status => 'Статус';

  @override
  String get ng_board_assignee => 'Исполнитель';

  @override
  String get ng_board_title_label => 'Название';

  @override
  String get ng_board_body => 'Текст / спецификация';

  @override
  String get ng_board_save_changes => 'Сохранить изменения';

  @override
  String get ng_board_clear_model => 'Сбросить переопределение модели';

  @override
  String ng_board_blocked_reason(String reason) {
    return 'Причина блокировки: $reason';
  }

  @override
  String ng_board_result(String result) {
    return 'Результат: $result';
  }

  @override
  String ng_board_parents(String count) {
    return 'Блокируется (родительские · $count)';
  }

  @override
  String get ng_board_add_parent => '+ Добавить родительскую';

  @override
  String ng_board_children(String count) {
    return 'Блокирует (дочерние · $count)';
  }

  @override
  String ng_board_attachments(String count) {
    return 'Вложения ($count)';
  }

  @override
  String get ng_board_worker => 'исполнитель';

  @override
  String ng_board_comments(String count) {
    return 'Комментарии ($count)';
  }

  @override
  String get ng_board_comment_hint =>
      'Добавить комментарий / указания исполнителю';

  @override
  String get ng_board_post_comment => 'Опубликовать комментарий';

  @override
  String get ng_board_comment_requeue => 'Комментировать и вернуть в очередь';

  @override
  String ng_board_runs(String count) {
    return 'Запуски ($count)';
  }

  @override
  String get ng_board_no_runs => 'Запусков исполнителей пока нет.';

  @override
  String ng_board_run_error(String error) {
    return 'Ошибка: $error';
  }

  @override
  String ng_board_log_tail_truncated(String bytes) {
    return 'Конец журнала исполнителя ($bytes Б, обрезано)';
  }

  @override
  String ng_board_log_tail(String bytes) {
    return 'Конец журнала исполнителя ($bytes Б)';
  }

  @override
  String get ng_board_refresh_log => 'Обновить журнал';

  @override
  String get ng_board_no_log => 'Журнал исполнителя пуст.';

  @override
  String get ng_board_no_events => 'События не зарегистрированы.';

  @override
  String get ng_bots_room_unknown => 'неизвестно';

  @override
  String get ng_bots_room_blocked => 'заблокировано';

  @override
  String get ng_bots_room_working => 'работает';

  @override
  String get ng_bots_room_running => 'запущено';

  @override
  String get ng_bots_room_idle => 'простаивает';

  @override
  String ng_board_run_title(String id, String profile, String outcome) {
    return 'Запуск №$id · @$profile · $outcome';
  }

  @override
  String get ng_bots_new_bot => 'Новый бот';

  @override
  String get ng_bots_new_bot_hint =>
      'Именованный напарник со своей памятью, навыками и чатом. Может писать другим вашим агентам.';

  @override
  String get ng_bots_field_name => 'Имя';

  @override
  String get ng_bots_field_title => 'Заголовок';

  @override
  String get ng_bots_field_description => 'Описание';

  @override
  String get ng_bots_description_hint => 'С чем должен помогать этот бот?';

  @override
  String get ng_bots_name_invalid =>
      'Используйте строчные буквы, цифры, дефисы или подчёркивания; начинайте с буквы или цифры (не более 64 символов).';

  @override
  String ng_bots_name_taken(String name) {
    return 'Агент с именем «$name» уже существует.';
  }

  @override
  String ng_bots_profile_id(String id) {
    return 'ID профиля: $id';
  }

  @override
  String get ng_bots_advanced =>
      'Дополнительно — модель, навыки, наборы инструментов, SOUL.md';

  @override
  String get ng_bots_clone_from => 'Клонировать профиль';

  @override
  String get ng_bots_clone_main => 'Основной профиль (default)';

  @override
  String get ng_bots_fresh_profile => 'Новый профиль (встроенные навыки)';

  @override
  String get ng_bots_create_empty => 'Создать пустым (без встроенных навыков)';

  @override
  String get ng_bots_share_keys => 'Общие ключи и аккаунты с основным профилем';

  @override
  String get ng_bots_provider => 'Провайдер';

  @override
  String get ng_bots_model => 'Модель';

  @override
  String get ng_bots_model_pair => 'Укажите и провайдера, и модель.';

  @override
  String get ng_bots_soul =>
      'SOUL.md (необязательно — заменяет созданную персону)';

  @override
  String get ng_bots_soul_edit => 'SOUL.md';

  @override
  String get ng_bots_creating => 'Создание…';

  @override
  String get ng_bots_create_bot => 'Создать бота';

  @override
  String ng_bots_created(String name) {
    return 'Бот «$name» создан';
  }

  @override
  String get ng_bots_look_failed =>
      'Внешний вид не сохранён на шлюзе; задайте его в «Изменить профиль».';

  @override
  String ng_bots_request_failed(String reason) {
    return 'Шлюз не принял запрос ($reason).';
  }

  @override
  String get ng_bots_avatar_shape => 'Форма';

  @override
  String ng_bots_avatar_shape_n(int n) {
    return 'Форма $n';
  }

  @override
  String get ng_bots_avatar_colour => 'Цвет';

  @override
  String ng_bots_avatar_colour_n(int n) {
    return 'Цвет $n';
  }

  @override
  String get ng_bots_avatar_match_name => 'По имени';

  @override
  String get ng_bots_avatar_upload => 'Выбрать изображение…';

  @override
  String get ng_bots_avatar_remove => 'Убрать изображение — использовать форму';

  @override
  String get ng_bots_avatar_too_large =>
      'Изображение слишком большое (до 15 МБ).';

  @override
  String get ng_bots_avatar_unreadable => 'Не удалось прочитать изображение.';

  @override
  String get ng_bots_edit_profile => 'Изменить профиль';

  @override
  String ng_bots_edit_description(String name, String profile) {
    return 'Внешний вид и роль $name ($profile).';
  }

  @override
  String ng_bots_advanced_failed(String reason) {
    return 'Не удалось загрузить настройки профиля ($reason).';
  }

  @override
  String get ng_bots_skills => 'Навыки';

  @override
  String get ng_bots_toolsets => 'Наборы инструментов';

  @override
  String get ng_bots_toolsets_hint =>
      'Если отмечены все (или ни одного), действует набор по умолчанию.';

  @override
  String get ng_bots_mcp_servers => 'MCP-серверы';

  @override
  String get ng_bots_saving => 'Сохранение…';

  @override
  String get ng_bots_confirm_changes_title => 'Сохранить эти изменения?';

  @override
  String get ng_bots_change_remove_image => 'Удалить изображение бота';

  @override
  String get ng_bots_change_soul => 'Заменить его SOUL.md';

  @override
  String ng_bots_change_turn_off(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Отключить навыки, наборы или MCP-серверы: $count',
    );
    return '$_temp0';
  }

  @override
  String ng_bots_updated(String name) {
    return '$name: обновлено';
  }

  @override
  String ng_bots_sections_failed(String sections) {
    return 'Не удалось сохранить: $sections';
  }

  @override
  String get ng_bots_model_confirm_title => 'Сменить модель?';

  @override
  String get ng_bots_model_confirm_ok => 'Сменить';

  @override
  String get ng_bots_model_not_switched => 'Модель не изменена.';

  @override
  String get ng_bots_section_new => 'Новый раздел';

  @override
  String get ng_bots_section_new_ellipsis => 'Новый раздел…';

  @override
  String get ng_bots_section_name => 'Название раздела';

  @override
  String get ng_bots_section_name_hint => 'например, Клиенты';

  @override
  String get ng_bots_section_create => 'Создать';

  @override
  String get ng_bots_section_rename => 'Переименовать раздел';

  @override
  String get ng_bots_section_delete => 'Удалить раздел';

  @override
  String get ng_bots_section_move_up => 'Выше';

  @override
  String get ng_bots_section_move_down => 'Ниже';

  @override
  String get ng_bots_section_unassigned => 'Без раздела';

  @override
  String ng_bots_section_options(String name) {
    return 'Параметры раздела «$name»';
  }

  @override
  String get ng_bots_section_empty =>
      'Здесь пока нет ботов. Используйте «Переместить в раздел» у бота.';

  @override
  String get ng_bots_section_move_to => 'Переместить в раздел';

  @override
  String get ng_bots_section_remove => 'Убрать из раздела';

  @override
  String ng_bots_section_deleted(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Раздел «$name» удалён — ботов перемещено в «Без раздела»: $count',
      zero: 'Раздел «$name» удалён',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_undo => 'Отменить';

  @override
  String ng_bots_section_move_failed(String reason) {
    return 'Не удалось переместить бота ($reason).';
  }

  @override
  String ng_bots_bot_actions(String name) {
    return 'Действия: $name';
  }

  @override
  String ng_bots_section_toggle(String name) {
    return 'Показать или скрыть «$name»';
  }

  @override
  String
  get release_core_transcript_reader_this_passage_is_no_longer_in_the_loaded =>
      'Этот фрагмент больше не входит в загруженную часть переписки.';

  @override
  String get release_core_transcript_reader_loaded_prompts =>
      'Загруженные промпты';

  @override
  String get release_core_transcript_reader_jump_to_latest =>
      'К последним сообщениям';

  @override
  String get release_core_transcript_reader_no_prompts_loaded =>
      'Нет загруженных промптов';

  @override
  String get release_core_transcript_reader_find_in_loaded_messages =>
      'Поиск в загруженных сообщениях';

  @override
  String get release_core_transcript_reader_previous_match =>
      'Предыдущее совпадение';

  @override
  String get release_core_transcript_reader_next_match =>
      'Следующее совпадение';

  @override
  String get release_core_transcript_reader_prompt_timeline =>
      'Хронология промптов';

  @override
  String get release_core_transcript_reader_close_find => 'Закрыть поиск';

  @override
  String get release_core_session_organisation_organise_chats =>
      'Упорядочить чаты';

  @override
  String get release_core_session_organisation_show_model_and_usage =>
      'Показывать модель и использование';

  @override
  String
  get release_core_session_files_view_connection_changed_reopen_files_on_the_new_connection =>
      'Подключение изменилось. Откройте файлы заново в новом подключении.';

  @override
  String
  get release_core_session_files_view_the_connection_or_session_changed_reopen_this_pane =>
      'Подключение или сессия изменились. Откройте эту панель заново.';

  @override
  String
  get release_core_session_files_view_no_verified_host_working_directory_for_this_session =>
      'Для этой сессии нет подтверждённой рабочей папки на хосте.';

  @override
  String
  get release_core_session_files_view_the_gateway_denied_this_operation =>
      'Шлюз запретил эту операцию.';

  @override
  String
  get release_core_session_files_view_this_gateway_does_not_support_this_operation =>
      'Этот шлюз не поддерживает эту операцию.';

  @override
  String
  get release_core_session_files_view_the_file_owner_or_working_directory_changed_reload =>
      'Файл, владелец или рабочая папка изменились. Перезагрузите и проверьте.';

  @override
  String
  get release_core_session_files_view_the_gateway_returned_an_unsafe_path_or_invalid =>
      'Шлюз вернул небезопасный путь или некорректный ответ с файлом.';

  @override
  String
  get release_core_session_files_view_workspace_access_requires_a_secure_gateway_connection =>
      'Для доступа к рабочей области нужно защищённое подключение к шлюзу.';

  @override
  String
  get release_core_session_files_view_gateway_unavailable_refresh_to_check_the_current_state =>
      'Шлюз недоступен. Обновите, чтобы проверить текущее состояние.';

  @override
  String
  get release_core_session_files_view_gateway_operation_could_not_be_confirmed =>
      'Не удалось подтвердить выполнение операции на шлюзе.';

  @override
  String get release_core_session_files_view_git_status_unavailable =>
      'Статус Git недоступен.';

  @override
  String
  get release_core_session_files_view_change_this_chat_s_working_directory =>
      'Изменить рабочую папку этого чата?';

  @override
  String get release_core_session_files_view_absolute_gateway_directory =>
      'Абсолютный путь к папке на шлюзе';

  @override
  String get release_core_session_files_view_change_directory =>
      'Изменить папку';

  @override
  String get release_core_session_files_view_replace_gateway_file =>
      'Заменить файл на шлюзе?';

  @override
  String
  release_core_session_files_view_only_if_the_file_still_matches_the_version(
    String path,
  ) {
    return '$path\n\nТолько если файл по-прежнему совпадает с проверенной вами версией. Совместимый хост сохраняет заменённый файл для восстановления.';
  }

  @override
  String get release_core_session_files_view_save_changes =>
      'Сохранить изменения';

  @override
  String
  get release_core_session_files_view_saved_and_verified_on_the_gateway =>
      'Сохранено и проверено на шлюзе.';

  @override
  String
  get release_core_session_files_view_guarded_saving_is_unavailable_on_this_gateway_your =>
      'Сохранение с проверкой версии недоступно на этом шлюзе. Ваш черновик остался здесь.';

  @override
  String
  release_core_session_files_view_save_was_not_confirmed_your_draft_is_still(
    String reason,
  ) {
    return '$reason Сохранение не подтверждено. Ваш черновик остался здесь.';
  }

  @override
  String get release_core_session_files_view_review_current_gateway_version =>
      'Проверить текущую версию на шлюзе';

  @override
  String get release_core_session_files_view_discard_draft_and_reload =>
      'Удалить черновик и перезагрузить';

  @override
  String get release_core_session_files_view_keep_draft_against_this_version =>
      'Считать эту версию основой черновика';

  @override
  String get release_core_session_files_view_discard_unsaved_edits =>
      'Отменить несохранённые изменения?';

  @override
  String get release_core_session_files_view_keep_editing =>
      'Продолжить редактирование';

  @override
  String get release_core_session_files_view_discard_edits =>
      'Отменить изменения';

  @override
  String get release_core_session_files_view_remote_working_directory =>
      'Удалённая рабочая папка';

  @override
  String get release_core_session_files_view_change_working_directory =>
      'Изменить рабочую папку';

  @override
  String get release_core_session_files_view_show_ignored_files =>
      'Показывать игнорируемые файлы';

  @override
  String
  get release_core_session_files_view_gateway_does_not_report_ignored_status =>
      'Шлюз не сообщает, какие файлы игнорируются.';

  @override
  String get release_core_session_files_view_no_visible_entries =>
      'Нет видимых элементов';

  @override
  String get release_core_session_files_view_changed => 'Изменён';

  @override
  String get release_core_session_files_view_ignored => 'Игнорируется';

  @override
  String release_core_session_files_view_actions_for(String name) {
    return 'Действия для $name';
  }

  @override
  String get release_core_session_files_view_copy_relative_path =>
      'Скопировать относительный путь';

  @override
  String get release_core_session_files_view_copy_gateway_path =>
      'Скопировать путь на шлюзе';

  @override
  String get release_core_session_files_view_attach_folder_reference =>
      'Прикрепить ссылку на папку';

  @override
  String get release_core_session_files_view_attach_file_reference =>
      'Прикрепить ссылку на файл';

  @override
  String
  get release_core_session_files_view_preview_truncated_editing_disabled =>
      'Предпросмотр обрезан — редактирование отключено.';

  @override
  String get release_core_session_files_view_select_lines => 'Выбрать строки';

  @override
  String get release_core_session_files_view_review_gateway_version =>
      'Проверить версию на шлюзе';

  @override
  String get release_core_session_files_view_attach_selected_lines =>
      'Прикрепить выбранные строки';

  @override
  String get release_core_session_files_view_binary_file_no_text_preview =>
      'Двоичный файл — текстовый предпросмотр недоступен.';

  @override
  String get release_core_session_files_view_file_source =>
      'Исходный текст файла';

  @override
  String get release_core_session_files_view_close_session_files =>
      'Закрыть файлы сессии';

  @override
  String get release_core_session_files_view_back_to_tree =>
      'Вернуться к дереву';

  @override
  String get release_core_session_files_view_session_files => 'Файлы сессии';

  @override
  String get release_core_session_files_view_git_review => 'Обзор Git';

  @override
  String get release_core_session_files_view_refresh_tree => 'Обновить дерево';

  @override
  String
  get release_core_gateway_queue_screen_this_connection_changed_reopen_its_chat =>
      'Это подключение изменилось. Откройте его чат заново.';

  @override
  String
  get release_core_gateway_queue_screen_disconnected_reconnect_the_chat_then_refresh =>
      'Соединение разорвано. Подключите чат заново, затем обновите.';

  @override
  String release_core_gateway_queue_screen_gateway_queue_unavailable(
    String reason,
  ) {
    return 'Очередь шлюза недоступна: $reason.';
  }

  @override
  String release_core_gateway_queue_screen_not_confirmed_nothing_was_resent(
    String reason,
  ) {
    return 'Не подтверждено ($reason). Повторная отправка не выполнялась.';
  }

  @override
  String get release_core_gateway_queue_screen_gateway_confirmed_admission =>
      'Шлюз подтвердил принятие запроса.';

  @override
  String
  get release_core_gateway_queue_screen_edited_entry_admitted_at_the_end_of_the =>
      'Изменённая запись принята в конец очереди.';

  @override
  String get release_core_gateway_queue_screen_discard_unknown_outcome =>
      'Отбросить запрос с неизвестным результатом?';

  @override
  String get release_core_gateway_queue_screen_remove_this_entry =>
      'Удалить эту запись?';

  @override
  String
  get release_core_gateway_queue_screen_the_lost_turn_will_not_be_retried_waiting =>
      'Потерянный ход не будет повторён. Ожидающие ходы теперь могут выполняться.';

  @override
  String
  get release_core_gateway_queue_screen_if_the_gateway_has_just_started_this_entry =>
      'Если шлюз только что начал обработку этой записи, её удаление может остановить этот ход.';

  @override
  String get release_core_gateway_queue_screen_keep => 'Оставить';

  @override
  String get release_core_gateway_queue_screen_discard_and_resume =>
      'Отбросить и возобновить';

  @override
  String get release_core_gateway_queue_screen_remove_entry => 'Удалить запись';

  @override
  String
  get release_core_gateway_queue_screen_lost_admission_resolved_it_was_not_resent =>
      'Ситуация с потерянным подтверждением принятия разрешена; повторной отправки не было.';

  @override
  String get release_core_gateway_queue_screen_gateway_acknowledged_removal =>
      'Шлюз подтвердил удаление.';

  @override
  String get release_core_gateway_queue_screen_gateway_queue => 'Очередь шлюза';

  @override
  String get release_core_gateway_queue_screen_refresh_queue =>
      'Обновить очередь';

  @override
  String get release_core_gateway_queue_screen_queue_paused_unknown_outcome =>
      'Очередь приостановлена: результат неизвестен';

  @override
  String
  get release_core_gateway_queue_screen_review_the_lost_admission_before_resuming_nothing_is =>
      'Проверьте запрос с потерянным подтверждением принятия перед возобновлением. Повторная отправка не выполняется.';

  @override
  String get release_core_gateway_queue_screen_no_pending_admissions =>
      'Нет запросов, ожидающих принятия';

  @override
  String get release_core_gateway_queue_screen_discard => 'Отбросить…';

  @override
  String
  get release_core_gateway_queue_screen_gateway_acknowledged_the_steering_request =>
      'Шлюз подтвердил запрос на корректировку хода.';

  @override
  String get release_core_gateway_queue_screen_steer_running_turn =>
      'Скорректировать текущий ход';

  @override
  String get release_core_gateway_queue_screen_remove => 'Удалить…';

  @override
  String get release_core_gateway_queue_screen_next_prompt =>
      'Следующий промпт';

  @override
  String get release_core_gateway_queue_screen_edit_queued_prompt =>
      'Изменить промпт в очереди';

  @override
  String get release_core_gateway_queue_screen_submit_to_gateway_queue =>
      'Отправить в очередь шлюза';

  @override
  String get release_core_gateway_queue_screen_save_at_queue_end =>
      'Сохранить в конце очереди';

  @override
  String get release_core_gateway_queue_screen_cancel_edit =>
      'Отменить редактирование';

  @override
  String get release_core_git_review_pane_the_git_operation_did_not_complete =>
      'Операция Git не была завершена.';

  @override
  String get release_core_git_review_pane_close_git_review =>
      'Закрыть обзор Git';

  @override
  String get release_core_git_review_pane_pin_lane => 'Закрепить дорожку';

  @override
  String get release_core_git_review_pane_refresh_git_review =>
      'Обновить обзор Git';

  @override
  String get release_core_git_review_pane_uncommitted =>
      'Незакоммиченные изменения';

  @override
  String get release_core_git_review_pane_last_turn => 'Последний ход';

  @override
  String
  get release_core_git_review_pane_branch_and_last_turn_views_are_read_only =>
      'Обзоры ветки и последнего хода доступны только для чтения.';

  @override
  String get release_core_git_review_pane_mark_head_as_the_turn_baseline =>
      'Отметить HEAD как исходное состояние хода';

  @override
  String get release_core_git_review_pane_stage_all => 'Добавить всё в индекс';

  @override
  String get release_core_git_review_pane_discard_every_uncommitted_change =>
      'Отменить все незакоммиченные изменения?';

  @override
  String
  get release_core_git_review_pane_tracked_files_return_to_head_and_untracked_files =>
      'Отслеживаемые файлы вернутся к состоянию HEAD, а неотслеживаемые файлы в папке этой сессии будут удалены.';

  @override
  String get release_core_git_review_pane_discard => 'Отменить изменения';

  @override
  String get release_core_git_review_pane_discard_all => 'Отменить всё';

  @override
  String get release_core_git_review_pane_unstage => 'Убрать из индекса';

  @override
  String get release_core_git_review_pane_stage => 'Добавить в индекс';

  @override
  String get release_core_git_review_pane_discard_file =>
      'Отменить изменения файла';

  @override
  String release_core_git_review_pane_discard_2(String path) {
    return 'Отменить изменения в $path?';
  }

  @override
  String
  get release_core_git_review_pane_this_restores_the_committed_copy_or_removes_the =>
      'Это восстановит закоммиченную копию или удалит неотслеживаемый файл.';

  @override
  String get release_core_git_review_pane_commit_message => 'Сообщение коммита';

  @override
  String get release_core_git_review_pane_nothing_in_the_diff_to_summarise =>
      'В изменениях нечего обобщать.';

  @override
  String get release_core_git_review_pane_generate_message =>
      'Сгенерировать сообщение';

  @override
  String get release_core_git_review_pane_commit => 'Создать коммит';

  @override
  String get release_core_git_review_pane_commit_and_push =>
      'Создать коммит и отправить';

  @override
  String get release_core_git_review_pane_push => 'Отправить';

  @override
  String get release_core_git_review_pane_create_pull_request =>
      'Создать запрос на слияние';

  @override
  String get release_core_git_review_pane_pull_request_ready =>
      'Запрос на слияние готов';

  @override
  String get release_core_git_review_pane_ask_hermes_to_ship =>
      'Попросить Hermes выпустить изменения';

  @override
  String get release_core_git_review_pane_gh_is_authenticated_on_this_gateway =>
      'gh авторизован на этом шлюзе.';

  @override
  String
  get release_core_git_review_pane_install_the_github_cli_gh_and_sign_in =>
      'Установите GitHub CLI (gh) и войдите в аккаунт, чтобы открывать запросы на слияние';

  @override
  String get release_core_git_review_pane_worktrees => 'Рабочие деревья';

  @override
  String get release_core_git_review_pane_main => 'Основное';

  @override
  String release_core_git_review_pane_follow(String branch) {
    return 'Следовать за веткой $branch?';
  }

  @override
  String
  get release_core_git_review_pane_the_session_working_directory_becomes_this_worktree_unless =>
      'Рабочая папка сессии сменится на это рабочее дерево, если дорожка не закреплена.';

  @override
  String get release_core_git_review_pane_follow_2 => 'Следовать';

  @override
  String release_core_git_review_pane_remove(String branch) {
    return 'Удалить $branch?';
  }

  @override
  String get release_core_git_review_pane_the_worktree_directory_is_removed =>
      'Папка рабочего дерева будет удалена.';

  @override
  String get release_core_git_review_pane_remove_2 => 'Удалить';

  @override
  String get release_core_git_review_pane_new_worktree_name =>
      'Имя нового рабочего дерева';

  @override
  String get release_core_git_review_pane_new_branch => 'Новая ветка';

  @override
  String get release_core_git_review_pane_base_branch => 'Базовая ветка';

  @override
  String get release_core_git_review_pane_create_worktree =>
      'Создать рабочее дерево';

  @override
  String get release_core_git_review_pane_existing_branch =>
      'Существующая ветка';

  @override
  String get release_core_git_review_pane_convert_branch_to_worktree =>
      'Преобразовать ветку в рабочее дерево';

  @override
  String get release_core_git_review_pane_switch_branch => 'Сменить ветку';

  @override
  String
  get release_core_git_review_pane_this_gateway_does_not_support_that_git_operation =>
      'Этот шлюз не поддерживает эту операцию Git.';

  @override
  String
  get release_core_git_review_pane_git_needs_the_session_directory_on_the_local =>
      'Для Git нужна папка сессии в локальной среде выполнения терминала.';

  @override
  String
  get release_core_git_review_pane_the_gateway_refused_the_git_operation =>
      'Шлюз отклонил операцию Git.';

  @override
  String
  get release_core_git_review_pane_the_session_changed_refresh_and_try_again =>
      'Сессия изменилась. Обновите и повторите попытку.';

  @override
  String
  get release_core_git_review_pane_this_review_is_no_longer_the_selected_session =>
      'Этот обзор больше не относится к выбранной сессии.';

  @override
  String
  get release_core_git_review_pane_the_gateway_returned_an_unexpected_git_result =>
      'Шлюз вернул неожиданный результат Git.';

  @override
  String
  get release_core_git_review_pane_git_review_requires_the_gateway_transport =>
      'Для обзора Git требуется транспорт шлюза.';

  @override
  String get release_core_client_held_queue_bar_resume => 'Возобновить';

  @override
  String get release_core_client_held_queue_bar_send_queued_prompt =>
      'Отправить промпт из очереди';

  @override
  String get release_core_client_held_queue_bar_edit_unsent_prompt =>
      'Изменить неотправленный промпт';

  @override
  String get release_core_client_held_queue_bar_remove_unsent_prompt =>
      'Удалить неотправленный промпт';

  @override
  String get release_core_workspace_discovery_view_repository_discovery =>
      'Поиск репозиториев';

  @override
  String get release_core_workspace_discovery_view_refresh_results =>
      'Обновить результаты';

  @override
  String release_core_workspace_discovery_view_hide(String path) {
    return 'Скрыть $path';
  }

  @override
  String
  get release_core_workspace_discovery_view_invalid_path_or_discovery_data_use_absolute_server =>
      'Некорректный путь или данные поиска. Используйте абсолютные серверные пути без компонентов «.» и «..».';

  @override
  String
  get release_core_workspace_discovery_view_this_gateway_does_not_support_repository_discovery =>
      'Этот шлюз не поддерживает поиск репозиториев.';

  @override
  String
  get release_core_workspace_discovery_view_the_gateway_denied_access_to_repository_discovery =>
      'Шлюз запретил доступ к поиску репозиториев.';

  @override
  String
  get release_core_workspace_discovery_view_the_connection_changed_reopen_discovery_on_the_current =>
      'Подключение изменилось. Откройте поиск заново на текущем шлюзе.';

  @override
  String
  get release_core_workspace_discovery_view_the_displayed_settings_have_changed_refresh_before_trying =>
      'Отображаемые настройки изменились. Обновите перед повторной попыткой.';

  @override
  String
  get release_core_workspace_discovery_view_could_not_load_or_verify_discovery_settings_refresh =>
      'Не удалось загрузить или проверить настройки поиска. Обновите, чтобы повторить попытку.';

  @override
  String release_core_workspace_discovery_view_repositories_shown_of(
    int visible,
    int total,
  ) {
    return 'Показано репозиториев: $visible из $total';
  }

  @override
  String
  get release_core_workspace_discovery_view_the_gateway_returned_no_repositories =>
      'Шлюз не вернул ни одного репозитория.';

  @override
  String
  get release_core_workspace_discovery_view_no_repositories_match_your_device_filters =>
      'Ни один репозиторий не соответствует фильтрам на вашем устройстве.';

  @override
  String get release_core_workspace_discovery_view_gateway_scan_policy =>
      'Политика сканирования шлюза';

  @override
  String
  get release_core_workspace_discovery_view_this_gateway_did_not_report_a_scan_policy =>
      'Этот шлюз не сообщил политику сканирования.';

  @override
  String
  get release_core_workspace_discovery_view_to_scan_folders_configure_repository_scanning_in_the =>
      'Чтобы сканировать папки, настройте сканирование репозиториев в настройках Desktop профиля шлюза.';

  @override
  String
  get release_core_workspace_discovery_view_results_can_include_cached_repositories_and_repositories_with =>
      'Результаты могут включать кэшированные репозитории и репозитории с сессиями. Сканирование не гарантирует, что удалось проверить каждую папку.';

  @override
  String get release_core_workspace_discovery_view_scan_gateway_roots =>
      'Сканировать корневые папки шлюза';

  @override
  String
  get release_core_workspace_discovery_view_filter_results_on_this_device =>
      'Фильтровать результаты на этом устройстве';

  @override
  String
  get release_core_workspace_discovery_view_only_this_discovery_list_changes_not_the_gateway =>
      'Меняется только этот список результатов, а не сканирование на шлюзе.';

  @override
  String get release_core_workspace_discovery_view_include_subtrees_empty_all =>
      'Включить поддеревья (пусто = все)';

  @override
  String get release_core_workspace_discovery_view_exclude_subtrees =>
      'Исключить поддеревья';

  @override
  String get release_core_workspace_discovery_view_apply_filters =>
      'Применить фильтры';

  @override
  String release_core_workspace_discovery_view_hidden_repositories(int count) {
    return 'Скрытые репозитории ($count)';
  }

  @override
  String get release_core_workspace_discovery_view_undo_hide =>
      'Отменить скрытие';

  @override
  String
  get release_core_workspace_discovery_view_one_absolute_server_path_per_line =>
      'Один абсолютный серверный путь в строке';

  @override
  String get release_core_project_settings_view_project_settings =>
      'Настройки проекта';

  @override
  String
  get release_core_project_settings_view_the_gateway_did_not_confirm_the_selected_project =>
      'Шлюз не подтвердил выбранный проект или изменение. Проверьте настройки перед повторной попыткой.';

  @override
  String
  get release_core_project_settings_view_could_not_verify_these_settings_use_one_absolute =>
      'Не удалось проверить эти настройки. Укажите по одному абсолютному пути к серверной папке в строке, без компонентов «.» и «..».';

  @override
  String get release_core_project_settings_view_set_active =>
      'Сделать активным';

  @override
  String get release_core_project_settings_view_icon => 'Значок';

  @override
  String get release_core_project_settings_view_folder => 'Папка';

  @override
  String get release_core_project_settings_view_repository => 'Репозиторий';

  @override
  String get release_core_project_settings_view_rocket => 'Ракета';

  @override
  String get release_core_project_settings_view_star => 'Звезда';

  @override
  String get release_core_project_settings_view_book => 'Книга';

  @override
  String get release_core_project_settings_view_terminal => 'Терминал';

  @override
  String get release_core_project_settings_view_colour => 'Цвет';

  @override
  String get release_core_project_settings_view_primary_folder =>
      'Основная папка';

  @override
  String get release_core_project_settings_view_server_folder_paths =>
      'Пути к папкам на сервере';

  @override
  String
  get release_core_project_settings_view_one_absolute_path_per_line_existing_folders_are =>
      'Один абсолютный путь в строке. Существующие папки сохраняются.';

  @override
  String get release_core_project_settings_view_add_folders => 'Добавить папки';

  @override
  String release_core_project_settings_view_choose(String label) {
    return 'Выбрать: $label';
  }

  @override
  String
  get release_core_prepared_image_recovery_wait_for_an_empty_draft_before_restoring =>
      'Перед восстановлением дождитесь, пока черновик станет пустым.';

  @override
  String
  get release_core_prepared_image_recovery_no_unacknowledged_image_drafts_in_this_chat =>
      'В этом чате нет черновиков изображений без подтверждения получения.';

  @override
  String get release_core_prepared_image_recovery_unacknowledged_image_drafts =>
      'Черновики изображений без подтверждения получения';

  @override
  String
  get release_core_prepared_image_recovery_the_gateway_may_already_have_received_these_restore =>
      'Возможно, шлюз уже получил их. Восстановите для проверки; ничего не будет отправлено.';

  @override
  String get release_core_prepared_image_recovery_image_draft =>
      'Черновик изображения';

  @override
  String get release_core_prepared_image_recovery_discard_local_copy =>
      'Удалить локальную копию';

  @override
  String
  get release_core_prepared_image_recovery_discard_this_local_image_draft =>
      'Удалить этот локальный черновик изображения?';

  @override
  String
  get release_core_prepared_image_recovery_image_draft_recovery_is_unavailable =>
      'Восстановление черновиков изображений недоступно.';

  @override
  String get release_core_prepared_image_recovery_recover_image_draft =>
      'Восстановить черновик изображения…';

  @override
  String get release_core_session_search_mode_menu_could_not_save_search_mode =>
      'Не удалось сохранить режим поиска.';

  @override
  String get release_core_projects_pane_discover_repositories =>
      'Найти репозитории';

  @override
  String
  get release_core_projects_pane_project_created_but_the_gateway_did_not_confirm =>
      'Проект создан, но шлюз не подтвердил его идею.';

  @override
  String get release_core_projects_pane_project_idea_optional =>
      'Идея проекта (необязательно)';

  @override
  String
  get release_core_projects_pane_saved_in_the_project_description_not_a_file =>
      'Сохраняется в описании проекта, а не в файле.';

  @override
  String get release_core_project_detail_screen_new_chat_in_this_lane =>
      'Новый чат в этой дорожке';

  @override
  String get release_core_project_detail_screen_review_git =>
      'Открыть обзор Git';

  @override
  String get release_core_more_pane_gateway_fleet => 'Парк шлюзов';

  @override
  String
  get release_core_more_pane_connected_sessions_hermes_cloud_and_desktop_webapp =>
      'Подключённые сессии, Hermes Cloud и веб-приложение Desktop';

  @override
  String get release_core_more_pane_use_dashboard_sign_in_for_a_named_profile =>
      'Для именованного профиля используйте вход через панель управления. Этот устаревший API не может подтвердить, какому профилю принадлежит история чата.';

  @override
  String get release_core_more_pane_capabilities => 'Возможности';

  @override
  String
  get release_core_more_pane_install_and_govern_skills_plugins_connectors_and_tool =>
      'Установка и управление навыками, плагинами, коннекторами и средами выполнения инструментов';

  @override
  String get release_core_more_pane_browser_vault => 'Хранилище браузера';

  @override
  String
  get release_core_more_pane_site_logins_addresses_cards_and_credential_sources =>
      'Данные входа на сайты, адреса, карты и источники учётных данных';

  @override
  String get release_core_more_pane_agent_policy => 'Политика агента';

  @override
  String
  get release_core_more_pane_approvals_checkpoints_browser_access_and_shared_metrics =>
      'Разрешения, контрольные точки, доступ к браузеру и общие метрики';

  @override
  String get release_core_more_pane_remote_logs_health_maintenance_and_update =>
      'Удалённые журналы, состояние, обслуживание и обновление';

  @override
  String get release_core_more_pane_schedules => 'Расписания';

  @override
  String get release_core_more_pane_all_profiles_blueprints_catch_up_and_stop =>
      'Все профили, шаблоны, пропущенные запуски и остановка';

  @override
  String get release_core_more_pane_memory_graph => 'Граф памяти';

  @override
  String get release_core_more_pane_timeline_edits_and_memory_providers =>
      'Хронология, правки и провайдеры памяти';

  @override
  String get release_core_more_pane_providers_and_routes =>
      'Провайдеры и маршруты';

  @override
  String get release_core_more_pane_keys_endpoints_delegation_and_mixtures =>
      'Ключи, конечные точки, делегирование и смеси моделей';

  @override
  String get release_core_more_pane_credits_and_plans => 'Кредиты и тарифы';

  @override
  String
  get release_core_more_pane_consented_nous_billing_when_the_account_allows_it =>
      'Управление оплатой Nous с вашего согласия, если это разрешено аккаунтом';

  @override
  String
  get release_core_fleet_screen_this_gateway_does_not_offer_this_service =>
      'Этот шлюз не предоставляет эту службу.';

  @override
  String
  get release_core_fleet_screen_sign_in_or_permission_required_on_this_gateway =>
      'На этом шлюзе требуется вход или разрешение.';

  @override
  String get release_core_fleet_screen_a_secure_gateway_address_is_required =>
      'Требуется защищённый адрес шлюза.';

  @override
  String
  get release_core_fleet_screen_the_owner_changed_refresh_before_continuing =>
      'Владелец изменился. Обновите перед продолжением.';

  @override
  String
  get release_core_fleet_screen_could_not_verify_the_operation_check_the_gateway =>
      'Не удалось проверить выполнение операции. Проверьте шлюз и обновите.';

  @override
  String get release_core_fleet_screen_verified_ssh => 'Проверенный SSH';

  @override
  String
  get release_core_fleet_screen_confirm_a_host_key_inspect_a_remote_service =>
      'Подтвердить ключ хоста, проверить удалённую службу или открыть её оболочку';

  @override
  String get release_core_fleet_screen_cloud_and_desktop_webapp =>
      'Облако и веб-приложение Desktop';

  @override
  String get release_core_fleet_screen_register_an_existing_gateway_or_webapp =>
      'Зарегистрировать существующий шлюз или веб-приложение';

  @override
  String
  get release_core_fleet_screen_sign_in_to_its_address_nothing_is_hosted =>
      'Войдите по его адресу. На этом устройстве ничего не размещается.';

  @override
  String get release_core_fleet_screen_fleet_updates =>
      'Обновления парка шлюзов';

  @override
  String get release_core_fleet_screen_refresh_roster =>
      'Обновить список шлюзов';

  @override
  String release_core_fleet_screen_disconnect(String gateway) {
    return 'Отключить $gateway';
  }

  @override
  String get release_core_fleet_screen_open_this_gateway_on_launch =>
      'Открывать этот шлюз при запуске';

  @override
  String
  get release_core_fleet_screen_primary_for_ares_does_not_change_the_last =>
      'Основной шлюз для Ares; не меняет последний использованный шлюз.';

  @override
  String get release_core_fleet_screen_reconnect_in_fleet_on_launch =>
      'Переподключать в парке шлюзов при запуске';

  @override
  String get release_core_fleet_screen_no_sessions_for_this_profile =>
      'У этого профиля нет сессий.';

  @override
  String get release_core_fleet_screen_more_sessions => 'Другие сессии';

  @override
  String get release_core_fleet_screen_this_gateway_was_disconnected =>
      'Этот шлюз был отключён.';

  @override
  String
  get release_core_fleet_screen_some_conversation_data_could_not_be_loaded =>
      'Не удалось загрузить часть данных переписки.';

  @override
  String get release_core_fleet_screen_message_this_session =>
      'Написать в эту сессию';

  @override
  String get release_core_fleet_screen_send_to_this_session =>
      'Отправить в эту сессию';

  @override
  String get release_core_fleet_updates_screen_update_these_remote_gateways =>
      'Обновить эти удалённые шлюзы?';

  @override
  String
  release_core_fleet_updates_screen_this_can_restart_the_backend_and_interrupt_other(
    String gateways,
  ) {
    return 'Это может перезапустить серверную часть и прервать работу других пользователей. Ares не будет обновлён.\n\n$gateways';
  }

  @override
  String get release_core_fleet_updates_screen_update_listed_gateways =>
      'Обновить перечисленные шлюзы';

  @override
  String
  get release_core_fleet_updates_screen_checks_connected_gateways_cloud_is_platform_managed_entries =>
      'Проверяются подключённые шлюзы. Облако управляется платформой; записи без подтверждённого происхождения регистрации исключены.';

  @override
  String get release_core_fleet_updates_screen_check_connected_gateways =>
      'Проверить подключённые шлюзы';

  @override
  String get release_core_fleet_updates_screen_read_update_receipt =>
      'Прочитать отчёт об обновлении';

  @override
  String get release_core_fleet_updates_screen_review_eligible_updates =>
      'Проверить доступные для установки обновления';

  @override
  String
  get release_core_fleet_webapp_screen_account_changed_reopen_this_page =>
      'Аккаунт изменился. Откройте эту страницу заново.';

  @override
  String
  get release_core_fleet_webapp_screen_set_the_webapp_s_primary_gateway =>
      'Назначить основной шлюз веб-приложения?';

  @override
  String
  release_core_fleet_webapp_screen_this_changes_the_shared_registry_not_the_last(
    String webapp,
    String gateway,
    String id,
  ) {
    return '$webapp → $gateway ($id)\nЭто меняет общий реестр, а не последний использованный шлюз.';
  }

  @override
  String get release_core_fleet_webapp_screen_set_primary => 'Сделать основным';

  @override
  String get release_core_fleet_webapp_screen_serving_profile =>
      'Обслуживающий профиль';

  @override
  String get release_core_fleet_webapp_screen_hermes_cloud => 'Hermes Cloud';

  @override
  String get release_core_fleet_webapp_screen_discover_signed_in_agents =>
      'Найти агентов, вошедших в аккаунт';

  @override
  String release_core_fleet_webapp_screen_organisation(String organisation) {
    return 'Организация: $organisation';
  }

  @override
  String get release_core_fleet_webapp_screen_no_agents_available =>
      'Нет доступных агентов.';

  @override
  String get release_core_fleet_webapp_screen_existing_desktop_webapp =>
      'Существующее веб-приложение Desktop';

  @override
  String
  get release_core_fleet_webapp_screen_check_gateway_and_web_access_status =>
      'Проверить состояние шлюза и веб-доступа';

  @override
  String
  get release_core_fleet_webapp_screen_these_settings_belong_to_the_machine_serving_this =>
      'Эти настройки относятся к компьютеру, обслуживающему это веб-приложение. Публикация и перезапуски не выполняются удалённо.';

  @override
  String get release_core_fleet_webapp_screen_read_webapp_gateway_registry =>
      'Прочитать реестр шлюзов веб-приложения';

  @override
  String get release_core_fleet_webapp_screen_last_used =>
      'Последний использованный';

  @override
  String get release_core_fleet_webapp_screen_primary => 'Основной';

  @override
  String release_core_fleet_webapp_screen_set_primary_2(String gateway) {
    return 'Сделать основным: $gateway';
  }

  @override
  String get release_core_fleet_webapp_screen_read_shared_display_preferences =>
      'Прочитать общие настройки отображения';

  @override
  String
  get release_core_fleet_webapp_screen_chat_text_direction_on_this_webapp_and_desktop =>
      'Направление текста чата в этом веб-приложении и Desktop';

  @override
  String release_core_schedule_desk_screen_created_on(
    String job,
    String profile,
  ) {
    return 'Задание $job создано в профиле $profile.';
  }

  @override
  String
  get release_core_schedule_desk_screen_the_list_covers_every_profile_on_this_gateway =>
      'Список охватывает все профили этого шлюза. Команды остановки, приостановки, обработки пропущенных запусков, доставки и шаблонов отправляются профилю, которому принадлежит задание.';

  @override
  String get release_core_schedule_desk_screen_a_run_is_in_progress =>
      'Выполняется запуск';

  @override
  String get release_core_schedule_desk_screen_no_current_run =>
      'Нет текущего запуска';

  @override
  String release_core_schedule_desk_screen_stop_requested_for(String job) {
    return 'Запрошена остановка задания $job.';
  }

  @override
  String release_core_schedule_desk_screen_no_run_was_in_flight_for(
    String job,
  ) {
    return 'У задания $job не было выполняющегося запуска.';
  }

  @override
  String get release_core_schedule_desk_screen_stop_current_run =>
      'Остановить текущий запуск';

  @override
  String get release_core_schedule_desk_screen_pause_future_runs =>
      'Приостановить будущие запуски';

  @override
  String get release_core_schedule_desk_screen_resume_future_runs =>
      'Возобновить будущие запуски';

  @override
  String get release_core_schedule_desk_screen_catch_up_default =>
      'Обработка пропущенных запусков по умолчанию';

  @override
  String get release_core_schedule_desk_screen_run_one_missed =>
      'Выполнить один пропущенный запуск';

  @override
  String get release_core_schedule_desk_screen_skip_missed =>
      'Пропускать пропущенные запуски';

  @override
  String get release_core_schedule_desk_screen_blueprint_recipes =>
      'Готовые шаблоны';

  @override
  String get release_core_schedule_desk_screen_profile_for_the_new_job =>
      'Профиль для нового задания';

  @override
  String release_core_schedule_desk_screen_create(String blueprint) {
    return 'Создать: $blueprint';
  }

  @override
  String get release_core_schedule_desk_screen_loading_delivery_targets =>
      'Загрузка получателей';

  @override
  String release_core_schedule_desk_screen_no_home_channel(String target) {
    return '$target (нет основного канала)';
  }

  @override
  String release_core_memory_graph_screen_edit(String label) {
    return 'Изменить: $label';
  }

  @override
  String get release_core_memory_graph_screen_content => 'Содержимое';

  @override
  String get release_core_memory_graph_screen_archive_skill =>
      'Архивировать навык';

  @override
  String get release_core_memory_graph_screen_delete_memory =>
      'Удалить запись памяти';

  @override
  String release_core_memory_graph_screen_archive_on_it_can_be_restored_on_the(
    String label,
    String profile,
  ) {
    return 'Архивировать $label в профиле $profile? Восстановить можно на хосте с помощью Куратора.';
  }

  @override
  String release_core_memory_graph_screen_delete_from_this_removes_that_memory(
    String label,
    String profile,
  ) {
    return 'Удалить $label из профиля $profile? Эта запись памяти будет удалена.';
  }

  @override
  String get release_core_memory_graph_screen_filter => 'Фильтр';

  @override
  String get release_core_memory_graph_screen_timeline => 'Хронология';

  @override
  String get release_core_memory_graph_screen_play_timeline =>
      'Воспроизвести хронологию';

  @override
  String get release_core_memory_graph_screen_layout_code => 'Код раскладки';

  @override
  String get release_core_memory_graph_screen_external_memory_providers =>
      'Внешние провайдеры памяти';

  @override
  String
  get release_core_memory_graph_screen_a_value_is_stored_leave_blank_to_keep =>
      'Значение сохранено. Оставьте поле пустым, чтобы его сохранить.';

  @override
  String get release_core_memory_graph_screen_save_provider =>
      'Сохранить провайдера';

  @override
  String release_core_workspace_profiles_screen_applies_to(String profile) {
    return 'Применяется к: $profile';
  }

  @override
  String get release_core_workspace_profiles_screen_choose_another_profile =>
      'Выбрать другой профиль';

  @override
  String
  get release_core_workspace_profiles_screen_could_not_verify_the_selected_profile_on_this =>
      'Не удалось проверить выбранный профиль на этом шлюзе.';

  @override
  String get release_core_workspace_profiles_screen_create_profile =>
      'Создать профиль';

  @override
  String get release_core_workspace_profiles_screen_new_profile_id =>
      'ID нового профиля';

  @override
  String get release_core_assets_screen_links => 'Ссылки';

  @override
  String get release_core_workspace_picker_no_matching_items =>
      'Совпадений не найдено.';

  @override
  String get release_core_workspace_picker_save_layout => 'Сохранить раскладку';

  @override
  String get release_core_workspace_picker_layout_name => 'Название раскладки';

  @override
  String
  get release_core_workspace_popout_this_chat_already_has_a_pop_out_window =>
      'Для этого чата уже открыто отдельное окно.';

  @override
  String
  get release_core_workspace_popout_could_not_open_this_saved_chat_check_the =>
      'Не удалось открыть этот сохранённый чат. Проверьте подключение и повторите попытку.';

  @override
  String
  get release_core_popout_bootstrap_use_the_main_window_to_change_your_connection =>
      'Измените подключение в главном окне.';

  @override
  String get release_core_guarded_save_refused =>
      'Шлюз не может сохранить этот файл';

  @override
  String get release_core_guarded_save_unavailable =>
      'Сохранение с проверкой версии недоступно на этом шлюзе';

  @override
  String release_core_git_files_changed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Изменено файлов за этот ход: $count',
      one: 'За этот ход изменён 1 файл',
    );
    return '$_temp0';
  }

  @override
  String release_core_git_entries_omitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Записей Git, пропущенных из соображений безопасности: $count.',
      one: '1 запись Git пропущена, так как её небезопасно показывать.',
    );
    return '$_temp0';
  }

  @override
  String get release_core_git_staged => 'В индексе';

  @override
  String get release_core_session_sort_recent => 'Недавняя активность';

  @override
  String get release_core_session_sort_created => 'Сначала недавно созданные';

  @override
  String get release_core_session_sort_status => 'Сначала выполняющиеся';

  @override
  String get release_core_session_sort_tokens => 'Больше всего токенов';

  @override
  String get release_core_session_sort_cost => 'Наибольшая стоимость';

  @override
  String get release_core_session_group_standard => 'Группировка по умолчанию';

  @override
  String get release_core_session_group_status => 'Группировать по статусу';

  @override
  String get release_core_session_group_project => 'Группировать по проекту';

  @override
  String release_core_session_tokens(int count) {
    return 'Токенов: $count';
  }

  @override
  String release_core_search_gateway_mode(String mode) {
    return '$mode (шлюз)';
  }

  @override
  String release_core_search_mode_tooltip(String label, String mode) {
    return '$label: $mode';
  }

  @override
  String get release_core_image_recovery_new_turn =>
      'Отправка создаст новый ход';

  @override
  String release_core_image_recovery_metadata(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Изображений: $count · $date',
      one: '1 изображение · $date',
    );
    return '$_temp0';
  }

  @override
  String release_core_discovery_scanning(String state) {
    return 'Сканирование: $state';
  }

  @override
  String get release_core_discovery_enabled => 'включено';

  @override
  String get release_core_discovery_disabled => 'отключено';

  @override
  String get release_core_discovery_none => 'нет';

  @override
  String release_core_discovery_roots(String paths) {
    return 'Корневые папки сканирования: $paths';
  }

  @override
  String release_core_discovery_excluded(String paths) {
    return 'Исключённые поддеревья: $paths';
  }

  @override
  String release_core_discovery_repository_sessions(String path, int count) {
    return '$path\nСессий: $count';
  }

  @override
  String get release_core_projects_local_only =>
      'Этот шлюз Hermes старее серверных проектов, поэтому чаты группируются только на этом устройстве. Обновите Hermes, чтобы использовать одни и те же проекты на всех устройствах.';

  @override
  String get release_core_fleet_no_address => 'Адрес шлюза ещё не задан';

  @override
  String release_core_fleet_diagnostics(String version, String access) {
    return 'Шлюз $version · $access';
  }

  @override
  String get release_core_schedule_builtin => 'встроенный';

  @override
  String get release_core_memory_gateway_profile => 'шлюз';

  @override
  String release_core_memory_profile_summary(String profile, String gateway) {
    return 'Профиль $profile на шлюзе $gateway. Код для обмена хранит только масштаб, время и фильтры.';
  }

  @override
  String release_core_memory_layers_summary(
    int memoryBytes,
    int userBytes,
    String provider,
  ) {
    return 'Встроенная память: $memoryBytes байт, пользовательская: $userBytes байт. Активный провайдер: $provider.';
  }

  @override
  String get release_core_memory_kind_all => 'Все';

  @override
  String get release_core_memory_kind_skill => 'Навыки';

  @override
  String get release_core_memory_kind_memory => 'Память';

  @override
  String get release_core_workspace_failure_stale => 'подключение изменилось';

  @override
  String get release_core_workspace_failure_unbound =>
      'нет подтверждённой рабочей папки';

  @override
  String get release_core_workspace_failure_denied => 'доступ запрещён';

  @override
  String get release_core_workspace_failure_ineligible =>
      'операция не разрешена для этого файла';

  @override
  String get release_core_workspace_failure_unsupported =>
      'не поддерживается этим шлюзом';

  @override
  String get release_core_workspace_failure_mismatch =>
      'удалённое состояние изменилось';

  @override
  String get release_core_workspace_failure_invalid =>
      'некорректный ответ шлюза';

  @override
  String get release_core_workspace_failure_insecure =>
      'требуется защищённое подключение';

  @override
  String get release_core_workspace_failure_unavailable => 'шлюз недоступен';

  @override
  String get release_core_queue_state_queued => 'В очереди';

  @override
  String get release_core_queue_state_started => 'Запущено';

  @override
  String get release_core_queue_state_unknown => 'Результат неизвестен';

  @override
  String get release_core_unknown_state => 'Неизвестно';

  @override
  String get release_core_fleet_state_idle => 'Не в сети';

  @override
  String get release_core_fleet_state_connected => 'Подключено';

  @override
  String get release_core_fleet_state_reconnecting => 'Переподключение…';

  @override
  String get release_core_fleet_state_sessionExpired => 'Выполнен выход';

  @override
  String get release_core_fleet_state_failed => 'Не удалось подключиться';

  @override
  String release_core_workspace_operation_failed(String reason) {
    return 'Не удалось подтвердить выполнение операции на шлюзе: $reason.';
  }

  @override
  String get release_core_workspace_invalid_data =>
      'Не удалось проверить данные или ввод. Проверьте их и повторите попытку.';

  @override
  String
  get release_core_parallel_workspace_layout_changed_in_this_window_but_could_not =>
      'Раскладка изменена в этом окне, но сохранить её не удалось.';

  @override
  String get release_core_parallel_workspace_first_pane => 'Первая панель';

  @override
  String get release_core_parallel_workspace_second_pane => 'Вторая панель';

  @override
  String get release_core_parallel_workspace_unavailable_page =>
      'Страница недоступна';

  @override
  String release_core_parallel_workspace_close_a_tab_first_maximum(
    String maximum,
  ) {
    return 'Сначала закройте вкладку (максимум: $maximum).';
  }

  @override
  String get release_core_parallel_workspace_dock_beside_current_pane =>
      'Закрепить рядом с текущей панелью';

  @override
  String get release_core_parallel_workspace_add_chat => 'Добавить чат';

  @override
  String
  get release_core_parallel_workspace_action_failed_check_the_connection_and_try_again =>
      'Не удалось выполнить действие. Проверьте подключение и повторите попытку.';

  @override
  String
  get release_core_parallel_workspace_close_a_tab_before_reopening_another =>
      'Закройте вкладку, прежде чем открывать другую заново.';

  @override
  String release_core_parallel_workspace_replace_layout(String name) {
    return 'Заменить раскладку «$name»?';
  }

  @override
  String
  get release_core_parallel_workspace_layout_limit_reached_replace_an_existing_layout =>
      'Достигнут лимит раскладок. Замените одну из существующих.';

  @override
  String get release_core_parallel_workspace_restore_layout =>
      'Восстановить раскладку';

  @override
  String get release_core_parallel_workspace_workspace_options =>
      'Параметры рабочей области';

  @override
  String get release_core_parallel_workspace_dock_another_pane =>
      'Закрепить ещё одну панель';

  @override
  String get release_core_parallel_workspace_swap_panes =>
      'Поменять панели местами';

  @override
  String get release_core_parallel_workspace_undock_second_pane =>
      'Открепить вторую панель';

  @override
  String get release_core_parallel_workspace_arrange_side_by_side =>
      'Расположить рядом';

  @override
  String get release_core_parallel_workspace_arrange_top_to_bottom =>
      'Расположить сверху вниз';

  @override
  String release_core_parallel_workspace_change_split_size(String percent) {
    return 'Изменить пропорции разделения ($percent%)';
  }

  @override
  String get release_core_parallel_workspace_focus_pane_full_screen =>
      'Развернуть панель на весь экран';

  @override
  String get release_core_parallel_workspace_open_chat_in_new_window =>
      'Открыть чат в новом окне';

  @override
  String get release_core_parallel_workspace_hide_pane_keep_running =>
      'Скрыть панель (продолжить работу)';

  @override
  String get release_core_parallel_workspace_previous_tab =>
      'Предыдущая вкладка';

  @override
  String get release_core_parallel_workspace_next_tab => 'Следующая вкладка';

  @override
  String get release_core_parallel_workspace_move_tab_left =>
      'Переместить вкладку влево';

  @override
  String get release_core_parallel_workspace_move_tab_right =>
      'Переместить вкладку вправо';

  @override
  String get release_core_parallel_workspace_reload_current_tab =>
      'Перезагрузить текущую вкладку';

  @override
  String get release_core_parallel_workspace_close_tab => 'Закрыть вкладку';

  @override
  String get release_core_parallel_workspace_close_other_tabs =>
      'Закрыть другие вкладки';

  @override
  String get release_core_parallel_workspace_close_tabs_to_the_right =>
      'Закрыть вкладки справа';

  @override
  String get release_core_parallel_workspace_close_all_tabs =>
      'Закрыть все вкладки';

  @override
  String get release_core_parallel_workspace_reopen_closed_tab =>
      'Открыть закрытую вкладку';

  @override
  String get release_core_parallel_workspace_save_named_layout =>
      'Сохранить именованную раскладку';

  @override
  String get release_core_parallel_workspace_restore_named_layout =>
      'Восстановить именованную раскладку';

  @override
  String get release_core_parallel_workspace_refresh_chat_list =>
      'Обновить список чатов';

  @override
  String get release_core_parallel_workspace_workspace_tools =>
      'Инструменты рабочей области';

  @override
  String get release_core_parallel_workspace_choose_a_chat_for_this_pane =>
      'Выберите чат для этой панели';

  @override
  String release_core_parallel_workspace_choose_chat_for(String pane) {
    return 'Выбрать чат для панели «$pane»';
  }

  @override
  String get release_core_parallel_workspace_add_a_chat_to_start_a_workspace =>
      'Добавьте чат, чтобы создать рабочую область.';

  @override
  String get release_core_parallel_workspace_select_a_tab_to_show_its_pane =>
      'Выберите вкладку, чтобы показать её панель.';

  @override
  String get release_core_parallel_workspace_parallel_workspace =>
      'Параллельная рабочая область';

  @override
  String get release_core_parallel_workspace_show_workspace =>
      'Показать рабочую область';

  @override
  String get release_core_parallel_workspace_could_not_load_chats_retry =>
      'Не удалось загрузить чаты. Повторить';

  @override
  String release_core_parallel_workspace_close(String pane) {
    return 'Закрыть панель «$pane»';
  }

  @override
  String release_core_parallel_workspace_switch_pane(String pane) {
    return 'Переключить панель: $pane';
  }

  @override
  String get release_core_workspace_registry_session_id_copied =>
      'ID сессии скопирован.';

  @override
  String get release_core_workspace_registry_chat_details => 'Сведения о чате';

  @override
  String get release_core_workspace_registry_server_default =>
      'По умолчанию на сервере';

  @override
  String get release_core_workspace_registry_session_id => 'ID сессии';

  @override
  String get release_core_workspace_registry_title => 'Название';

  @override
  String get release_core_workspace_label_terminals => 'Терминалы';

  @override
  String get release_core_workspace_label_copy_id => 'Скопировать ID сессии';

  @override
  String get release_core_workspace_label_contributions => 'Дополнения';

  @override
  String get release_core_workspace_owner_inactive =>
      'Владелец этой рабочей области больше не активен.';

  @override
  String get release_core_workspace_select_chat => 'Сначала выберите чат.';

  @override
  String get release_core_workspace_chat_unavailable =>
      'Этот чат недоступен для этого подключения.';

  @override
  String get release_core_workspace_page_unavailable =>
      'Эта страница недоступна для этого подключения.';

  @override
  String release_core_client_queue_count(int count) {
    return 'В очереди: $count';
  }

  @override
  String release_core_client_queue_paused_count(int count) {
    return 'В очереди: $count — приостановлено';
  }

  @override
  String release_core_git_diff_truncated(String diff) {
    return '$diff\n… обрезано';
  }

  @override
  String get release_core_search_no_models =>
      'Hermes не вернул ни одной настроенной модели, доступной для выбора.';

  @override
  String get release_core_chat_archive_unavailable =>
      'Архивация чата недоступна.';

  @override
  String get release_core_chat_pin_unconfirmed =>
      'Состояние закрепления не подтверждено.';

  @override
  String get release_core_chat_archive_unconfirmed =>
      'Состояние архивации не подтверждено.';

  @override
  String get release_core_chat_archive_history_unavailable =>
      'Архивная история недоступна';

  @override
  String get release_core_quick_chat_history_unavailable =>
      'История быстрых чатов недоступна';

  @override
  String get release_core_chat_project_ownership_unavailable =>
      'Сведения о принадлежности проекта недоступны';

  @override
  String get release_core_chat_unknown_project => 'Неизвестный проект';

  @override
  String get release_core_chat_local_search_fallback =>
      'Поиск по сообщениям недоступен. Показаны локальные совпадения.';

  @override
  String release_core_fleet_update_eligible(String version) {
    return 'Подходит для обновления · $version';
  }

  @override
  String get release_core_fleet_update_state_1 => 'Пропущено: та же установка';

  @override
  String get release_core_fleet_update_state_2 => 'Не проверено';

  @override
  String get release_core_fleet_update_state_3 =>
      'Пропущено: управляется облаком';

  @override
  String get release_core_fleet_update_state_4 =>
      'Пропущено: не зарегистрирован как прямой шлюз';

  @override
  String get release_core_fleet_update_state_5 =>
      'Пропущено: отключён или занят';

  @override
  String get release_core_fleet_update_state_6 => 'Нет подходящего обновления';

  @override
  String get release_core_fleet_update_state_7 =>
      'Не удалось проверить возможность обновления';

  @override
  String get release_core_fleet_update_state_8 =>
      'Пропущено: данные устарели, шлюз занят или запрос уже отправлен';

  @override
  String get release_core_fleet_update_state_9 => 'Отправка запроса';

  @override
  String get release_core_fleet_update_state_10 => 'Принято; отчёт недоступен';

  @override
  String get release_core_fleet_update_state_11 => 'Принято; ожидание отчёта';

  @override
  String get release_core_fleet_update_state_12 =>
      'Пропущено: в этой установке выполняется чат';

  @override
  String get release_core_fleet_update_state_13 =>
      'Не подтверждено; не отправлять повторно автоматически';

  @override
  String get release_core_fleet_update_state_14 =>
      'Подключитесь заново, чтобы проверить отчёт';

  @override
  String get release_core_fleet_update_state_15 => 'Отчёт недоступен';

  @override
  String get release_core_fleet_update_state_16 =>
      'Ожидание соответствующего отчёта';

  @override
  String get release_core_fleet_update_state_17 =>
      'Обновлено; требуются дальнейшие действия';

  @override
  String get release_core_fleet_update_state_19 => 'Обновлено частично';

  @override
  String get release_core_fleet_update_state_20 => 'Ошибка обновления';

  @override
  String get release_core_fleet_update_state_21 => 'Не подтверждено';

  @override
  String get release_core_cloud_status_ready => 'Готово';

  @override
  String get release_core_cloud_status_online => 'В сети';

  @override
  String get release_core_cloud_status_stopped => 'Остановлено';

  @override
  String get release_core_cloud_status_error => 'Ошибка';

  @override
  String get ng_release_more_contributions_subtitle =>
      'Проверенные карточки ответов для этого подключения';

  @override
  String get ng_release_more_gateway_fleet => 'Парк шлюзов';

  @override
  String get ng_release_more_memory_graph => 'Граф памяти';

  @override
  String get ng_release_more_memory_graph_subtitle =>
      'Хронология, правки и провайдеры памяти';

  @override
  String get ng_release_more_capabilities_subtitle =>
      'Установка и управление навыками, плагинами, коннекторами и средами выполнения инструментов';

  @override
  String get ng_release_more_browser_vault => 'Хранилище браузера';

  @override
  String get ng_release_more_browser_vault_subtitle =>
      'Данные входа на сайты, адреса, карты и источники учётных данных';

  @override
  String get ng_release_more_agent_policy => 'Политика агента';

  @override
  String get ng_release_more_agent_policy_subtitle =>
      'Разрешения, контрольные точки, доступ к браузеру и общие метрики';

  @override
  String get ng_release_more_schedules => 'Расписания';

  @override
  String get ng_release_more_schedules_subtitle =>
      'Все профили, шаблоны, пропущенные запуски и остановка';

  @override
  String get ng_release_more_host_subtitle =>
      'Удалённые журналы, состояние, обслуживание и обновление';

  @override
  String get ng_release_more_providers_routes => 'Провайдеры и маршруты';

  @override
  String get ng_release_more_providers_routes_subtitle =>
      'Ключи, конечные точки, делегирование и смеси моделей';

  @override
  String get ng_release_more_credits_plans => 'Кредиты и тарифы';

  @override
  String get ng_release_more_credits_plans_subtitle =>
      'Управление оплатой Nous с вашего согласия, если это разрешено аккаунтом';

  @override
  String get ng_release_sign_in_or => 'или';

  @override
  String ng_release_deployment_sign_in_hint(String message) {
    return '$message На следующем шаге вы всё ещё можете войти с токеном сессии развёртывания.';
  }

  @override
  String get ng_release_message_search_unavailable =>
      'Поиск по сообщениям недоступен. Показаны локальные совпадения.';

  @override
  String ng_release_insights_days(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дн.',
      one: '$days дн.',
    );
    return '$_temp0';
  }

  @override
  String get ng_release_signed_in_you => 'вы';

  @override
  String get release_chat_unsent_prompt_gone =>
      'Этого неотправленного промпта больше нет в очереди.';

  @override
  String ng_release_attachment_not_attached(String name) {
    return 'Шлюз не прикрепил $name.';
  }

  @override
  String get ng_release_gateway_not_connected =>
      'Подключение к шлюзу ещё не установлено.';

  @override
  String get ng_release_gateway_unreachable =>
      'Не удалось связаться со шлюзом.';

  @override
  String get ng_release_projects_scope_changed =>
      'Область проектов больше не выбрана';

  @override
  String get ng_release_missing_providers => 'Отсутствующие провайдеры';

  @override
  String get ng_release_missing_tasks => 'Отсутствующие задачи';

  @override
  String ng_release_age_minutes(int count) {
    return '$count мин';
  }

  @override
  String ng_release_age_hours(int count) {
    return '$count ч';
  }

  @override
  String ng_release_age_days(int count) {
    return '$count дн';
  }

  @override
  String ng_release_age_weeks(int count) {
    return '$count нед';
  }

  @override
  String ng_release_age_years(int count) {
    return '$count г';
  }

  @override
  String ng_release_compact_billions(String count) {
    return '$count млрд';
  }

  @override
  String ng_release_compact_millions(String count) {
    return '$count млн';
  }

  @override
  String ng_release_compact_thousands(String count) {
    return '$count тыс.';
  }

  @override
  String ng_release_token_thousands(String count) {
    return '$count тыс.';
  }

  @override
  String ng_release_elapsed_minutes_seconds(int minutes, int seconds) {
    return '$minutes мин $seconds с';
  }

  @override
  String ng_release_elapsed_seconds(int seconds) {
    return '$seconds с';
  }

  @override
  String get ng_release_notification_foreground => 'Ares был открыт на экране';

  @override
  String get ng_release_notification_stopped => 'ход был остановлен';

  @override
  String get ng_release_more_parallel_workspace =>
      'Параллельная рабочая область';

  @override
  String get ng_release_more_parallel_workspace_subtitle =>
      'Открывайте несколько чатов во вкладках или рядом друг с другом.';

  @override
  String get release_chat_unknown_model => 'неизвестно';

  @override
  String release_chat_profile_default(String model) {
    return 'По умолчанию для профиля: $model';
  }

  @override
  String release_chat_profile_default_provider(String model, String provider) {
    return 'По умолчанию для профиля: $model • $provider';
  }

  @override
  String get release_chat_choose_provider =>
      'Эта модель доступна у нескольких провайдеров. Выберите провайдера, чтобы продолжить.';

  @override
  String get release_chat_slash_needs_gateway =>
      'Для слеш-команд нужен шлюз Desktop';

  @override
  String get release_chat_recovering_without_resending =>
      'Восстановление без повторной отправки';

  @override
  String get release_chat_live_request_unreachable =>
      'Извините, не удалось связаться с Hermes для выполнения этого запроса.';

  @override
  String release_chat_live_working(String tool) {
    return 'Hermes работает: $tool. Ещё не завершено.';
  }

  @override
  String get release_chat_live_finished_without_spoken_result =>
      'Hermes завершил этот запрос без озвученного результата.';

  @override
  String get release_chat_reply_language_unavailable =>
      'Выбранный язык ответа недоступен';

  @override
  String get release_chat_reply_voice_unavailable =>
      'Выбранный голос ответа недоступен';

  @override
  String get release_chat_reply_voice_configuration_unavailable =>
      'Настройка голоса ответа недоступна';

  @override
  String get release_chat_notification_review_action =>
      'Откройте чат, чтобы проверить запрошенное действие.';

  @override
  String get release_chat_notification_respond =>
      'Откройте чат, чтобы ответить.';

  @override
  String get release_chat_start_new_main_window =>
      'Начните новый чат в главном окне.';

  @override
  String get release_chat_no_desktop_gateway => 'Нет шлюза Desktop';

  @override
  String get release_chat_attachment_preparation_cancelled =>
      'Подготовка вложения отменена.';

  @override
  String get release_chat_approval_authority_revoked =>
      'Полномочия на одобрение отозваны.';

  @override
  String get release_chat_gateway_session_disconnected =>
      'Сессия шлюза Desktop больше не подключена';

  @override
  String get release_chat_stop_requested =>
      'Запрошена остановка. Ожидание завершения работы Hermes.';

  @override
  String release_chat_stop_request_failed(String error) {
    return 'Не удалось запросить остановку: $error';
  }

  @override
  String get release_chat_queued_prompt_not_sent =>
      'Промпт из очереди не был отправлен.';

  @override
  String get release_chat_running_turn_unreachable =>
      'Не удалось связаться с выполняющимся ходом. Переподключение без повторной отправки.';

  @override
  String get release_chat_wait_for_composer =>
      'Дождитесь, пока поле ввода станет доступно.';

  @override
  String get release_chat_find_in_transcript => 'Поиск в переписке';

  @override
  String get release_chat_open_browser_preview =>
      'Открыть предпросмотр браузера';

  @override
  String get release_chat_more_tools => 'Другие инструменты чата';

  @override
  String get release_chat_queue_until_finished =>
      'В очередь до завершения этого хода';

  @override
  String get release_chat_format_bold => 'Полужирный';

  @override
  String get release_chat_format_italic => 'Курсив';

  @override
  String get ng_release_chat_gateway_queue_requirements =>
      'Для очереди шлюза нужен подключённый чат и промпт только с текстом.';

  @override
  String get ng_release_chat_start_new_main_screen =>
      'Начните новый чат на главном экране чатов.';

  @override
  String get ng_release_chat_image => 'изображение';

  @override
  String ng_release_chat_tool_seconds(String seconds) {
    return '$seconds с';
  }

  @override
  String get release_preview_chat_changed =>
      'Чат изменился. Подключите предпросмотр заново, чтобы продолжить.';

  @override
  String get release_preview_authenticating_chat =>
      'Проверка подлинности чата…';

  @override
  String release_preview_unavailable_reason(String reason) {
    return 'Предпросмотр недоступен: $reason';
  }

  @override
  String get release_preview_operation_failed =>
      'Не удалось выполнить операцию предпросмотра.';

  @override
  String get release_preview_added_to_draft =>
      'Добавлено в черновик. Ничего не отправлено.';

  @override
  String get release_preview_open_site_title => 'Открыть этот сайт?';

  @override
  String release_preview_open_site_body(String origin) {
    return '$origin\n\nРежим чтения загружает только этот документ. Он не передаёт Hermes файлы cookie, данные входа или страницу.';
  }

  @override
  String get release_preview_open_site => 'Открыть сайт';

  @override
  String get release_preview_discard_pins_title =>
      'Отбросить пометки, не добавленные в черновик?';

  @override
  String get release_preview_keep_pins => 'Оставить пометки';

  @override
  String get release_preview_share_page_title =>
      'Поделиться этой страницей с этим чатом?';

  @override
  String release_preview_share_page_body(String origin) {
    return 'Hermes сможет читать отображаемый текст и список элементов с $origin, а также прокручивать эту панель. При переходе на другую страницу доступ прекращается. Формы и учётные данные не передаются.';
  }

  @override
  String get release_preview_share_page => 'Поделиться страницей';

  @override
  String release_preview_comment_number(int number) {
    return 'Комментарий №$number';
  }

  @override
  String get release_preview_note => 'Заметка';

  @override
  String get release_preview_keep_pin => 'Оставить пометку';

  @override
  String get release_preview_title => 'Предпросмотр браузера';

  @override
  String get release_preview_hide => 'Скрыть предпросмотр';

  @override
  String get release_preview_close_and_forget => 'Закрыть и забыть страницу';

  @override
  String get release_preview_site_address => 'Адрес сайта';

  @override
  String get release_preview_go_to_address => 'Перейти по адресу';

  @override
  String get release_preview_forward => 'Вперёд';

  @override
  String get release_preview_reload => 'Перезагрузить';

  @override
  String get release_preview_share_with_hermes =>
      'Поделиться страницей с Hermes';

  @override
  String get release_preview_stop_sharing => 'Прекратить доступ к странице';

  @override
  String get release_preview_annotate =>
      'Добавить комментарий к элементу или области';

  @override
  String get release_preview_reader_console => 'Консоль режима чтения';

  @override
  String get release_preview_reconnect => 'Переподключить предпросмотр';

  @override
  String get release_preview_reader_mode_help =>
      'Режим чтения: HTML и текст. Без скриптов, встроенных ресурсов и профиля браузера с выполненным входом.';

  @override
  String release_preview_sharing_origin(String origin) {
    return 'Режим чтения доступен этому чату: $origin';
  }

  @override
  String get release_preview_annotation_help =>
      'Нажмите на элемент или выделите область перетаскиванием, чтобы добавить комментарий.';

  @override
  String get release_preview_reader_requests =>
      'Запросы режима чтения (JavaScript отключён)';

  @override
  String release_preview_selected_requests(int count) {
    return 'Выбрано: $count · JavaScript отключён';
  }

  @override
  String get release_preview_copy_all => 'Скопировать всё';

  @override
  String get release_preview_copy_selected => 'Скопировать выбранное';

  @override
  String get release_preview_add_log_to_draft => 'Добавить журнал в черновик';

  @override
  String release_preview_requests_draft(String log) {
    return 'Запросы режима чтения:\n$log';
  }

  @override
  String release_preview_add_pins_to_draft(int count) {
    return 'Добавить в черновик: $count';
  }

  @override
  String release_preview_request_loaded(String origin, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Элементов режима чтения: $count',
      one: '$count элемент режима чтения',
    );
    return 'HTTP 200 · $origin · $_temp0';
  }

  @override
  String release_preview_annotation_intro(String origin) {
    return 'Проверьте эти комментарии к предпросмотру $origin. Прикреплённые фрагменты изображений пронумерованы в том же порядке.';
  }

  @override
  String get release_preview_reader_region => 'область режима чтения';

  @override
  String get release_preview_capture_failed =>
      'Не удалось захватить эти пиксели.';

  @override
  String get release_preview_address_not_approved =>
      'Этот адрес находится за пределами разрешённого источника предпросмотра.';

  @override
  String get release_preview_page_limit =>
      'Страница превышает лимит режима чтения.';

  @override
  String get release_preview_page_unreadable =>
      'Не удалось прочитать страницу.';

  @override
  String get release_preview_page_complex =>
      'Эта страница слишком сложна для режима чтения.';

  @override
  String release_preview_http_failed(int statusCode) {
    return 'HTTP $statusCode. Переходы по перенаправлениям и вход не выполнялись.';
  }

  @override
  String get release_preview_unsupported_type =>
      'В режиме чтения можно открывать только HTML и обычный текст.';

  @override
  String get release_preview_load_insecure =>
      'Не удалось безопасно загрузить сайт.';

  @override
  String get release_preview_crop_limit =>
      'Фрагмент предпросмотра превышает допустимый лимит.';

  @override
  String get release_preview_image_unreadable =>
      'Выбранное изображение пусто или не читается.';

  @override
  String get release_preview_image_budget =>
      'Выбранное изображение превышает лимит черновика в 64 МиБ.';

  @override
  String get release_preview_image_format =>
      'Неподдерживаемый формат изображения. Выберите изображение JPEG, PNG или WebP.';

  @override
  String get release_preview_image_decode =>
      'Не удалось безопасно декодировать выбранное изображение JPEG, PNG или WebP.';

  @override
  String get release_preview_image_sanitize =>
      'Не удалось выполнить безопасную очистку изображения. Выберите корректное изображение JPEG, PNG или WebP.';

  @override
  String get release_preview_draft_budget =>
      'Общий размер вложений в одном черновике ограничен 64 МиБ.';

  @override
  String get release_preview_generic_file_limit =>
      'Размер каждого файла общего типа ограничен 16 МиБ.';

  @override
  String get release_preview_image_not_sanitized =>
      'Удалённые изображения необходимо безопасно очистить перед отправкой.';

  @override
  String get release_preview_stage_failed =>
      'Не удалось добавить материалы предпросмотра в черновик. Повторите попытку.';

  @override
  String get release_misc_find_hermes_on_lan => 'Найти Hermes в локальной сети';

  @override
  String release_misc_discovery_failed(String error) {
    return 'Ошибка поиска: $error';
  }

  @override
  String get release_misc_no_lan_servers =>
      'В локальной сети не найдены серверы Hermes.';

  @override
  String release_misc_api_key_rejected(String endpoint, int statusCode) {
    return 'Конечная точка $endpoint отклонила ключ API (HTTP $statusCode).';
  }

  @override
  String get release_misc_api_key_required =>
      'Серверу требуется ключ API. Введите свой API_SERVER_KEY.';

  @override
  String release_misc_gateway_not_found(String endpoint) {
    return 'Конечная точка шлюза $endpoint вернула HTTP 404. Проверьте префикс пути шлюза и маршруты обратного прокси.';
  }

  @override
  String release_misc_gateway_http_error(String endpoint, int statusCode) {
    return 'Конечная точка шлюза $endpoint вернула HTTP $statusCode.';
  }

  @override
  String release_misc_gateway_unreachable(String endpoint) {
    return 'Не удалось связаться с конечной точкой шлюза $endpoint.';
  }

  @override
  String get release_core_schedule_invalid_delivery_target =>
      'Недопустимая цель доставки';

  @override
  String get release_core_file_save_direct_only =>
      'Можно сохранить только файл непосредственно в рабочем каталоге.';

  @override
  String get release_core_file_save_hidden =>
      'Шлюз не может сохранять скрытые файлы.';

  @override
  String get rel_admin_choose_provider => 'Выберите провайдера и модель.';

  @override
  String get rel_admin_known_effort => 'Выберите известный уровень усилий.';

  @override
  String get rel_admin_endpoint_name_required =>
      'Введите имя этой конечной точки.';

  @override
  String get rel_admin_endpoint_model_required =>
      'Введите модель, которую обслуживает эта конечная точка.';

  @override
  String get rel_admin_known_api_mode =>
      'Выберите автоматический или известный режим API.';

  @override
  String get rel_admin_endpoint_id_invalid =>
      'Этот идентификатор конечной точки нельзя использовать.';

  @override
  String get rel_admin_endpoint_https =>
      'Используйте HTTPS для удалённой конечной точки или HTTP на localhost.';

  @override
  String get rel_admin_key_invalid => 'Этот ключ API нельзя сохранить.';

  @override
  String get rel_admin_response_shape =>
      'Ответ шлюза не соответствует ожидаемой структуре.';

  @override
  String get rel_admin_limits_required =>
      'Перед сохранением укажите ограничения итераций, параллелизма и времени ожидания.';

  @override
  String get rel_admin_route_required =>
      'Для сохранения каждого маршрута нужны имя и модель.';

  @override
  String get rel_admin_route_unique =>
      'Имена маршрутов должны быть уникальными.';

  @override
  String get rel_admin_route_default_invalid =>
      'Маршрут по умолчанию должен быть одним из сохранённых маршрутов.';

  @override
  String get rel_admin_policy_required =>
      'Выберите политику уведомления или молчания при деградации референсных моделей.';

  @override
  String get rel_admin_mixture_missing => 'Шлюз не вернул активную смесь.';

  @override
  String get rel_admin_mixture_slots_required =>
      'Укажите провайдера и модель для агрегатора и каждой референсной модели.';

  @override
  String get rel_admin_chat_id_required =>
      'Введите ID чата, к которому применяется это изменение.';

  @override
  String rel_admin_http_error(String status) {
    return 'Шлюз вернул HTTP $status.';
  }

  @override
  String get rel_admin_response_unreadable =>
      'Не удалось прочитать ответ шлюза.';

  @override
  String get rel_admin_connect_before_change =>
      'Подключите активный сеанс шлюза перед изменением оплаты или чата.';

  @override
  String get rel_admin_operation_unavailable =>
      'Этот шлюз не поддерживает данную операцию.';

  @override
  String get rel_admin_key_required => 'Введите ключ для сохранения.';

  @override
  String get rel_admin_key_save_failed => 'Шлюз не сохранил этот ключ.';

  @override
  String get rel_admin_key_clear_required =>
      'Выберите ключ провайдера для удаления.';

  @override
  String get rel_admin_key_clear_failed => 'Шлюз не удалил этот ключ.';

  @override
  String get rel_admin_endpoint_save_failed =>
      'Шлюз не сохранил эту конечную точку.';

  @override
  String get rel_admin_endpoint_activate_failed =>
      'Шлюз не активировал эту конечную точку.';

  @override
  String get rel_admin_accounts_secure_required =>
      'Для аккаунтов провайдеров нужен аутентифицированный шлюз HTTPS или localhost.';

  @override
  String get rel_admin_accounts_read_failed =>
      'Не удалось прочитать аккаунты провайдеров.';

  @override
  String get rel_admin_account_disconnect_failed =>
      'Шлюз не отключил этот аккаунт.';

  @override
  String get rel_admin_account_not_disconnectable =>
      'Этот аккаунт провайдера нельзя отключить.';

  @override
  String get rel_admin_backend_required =>
      'Выберите один из доступных бэкендов делегирования.';

  @override
  String get rel_admin_backend_save_failed => 'Шлюз не выбрал этот бэкенд.';

  @override
  String get rel_admin_routes_save_failed => 'Шлюз не сохранил эти маршруты.';

  @override
  String get rel_admin_profile_route_required =>
      'Для каждого маршрута профиля нужно имя профиля.';

  @override
  String get rel_admin_profile_route_unique =>
      'Маршруты профилей должны быть уникальными.';

  @override
  String get rel_admin_profile_route_default_invalid =>
      'Маршрут профиля по умолчанию должен быть одним из разрешённых профилей.';

  @override
  String get rel_admin_profile_routes_save_failed =>
      'Шлюз не сохранил эти маршруты профилей.';

  @override
  String get rel_admin_limits_save_failed =>
      'Шлюз не сохранил эти ограничения.';

  @override
  String get rel_admin_mixture_save_failed => 'Шлюз не сохранил эту смесь.';

  @override
  String get rel_admin_credit_amount_required =>
      'Выберите одну из предложенных сумм пополнения.';

  @override
  String get rel_admin_charge_check_failed =>
      'Не удалось проверить это списание.';

  @override
  String get rel_admin_reload_amounts_missing =>
      'Суммы автопополнения не указаны, поэтому они не изменены.';

  @override
  String get rel_admin_plan_required => 'Сначала выберите план.';

  @override
  String get rel_admin_plan_scheduled_only =>
      'Здесь можно подтвердить только запланированную смену плана.';

  @override
  String get rel_admin_billing_refused => 'Шлюз отклонил этот запрос оплаты.';

  @override
  String get rel_admin_request_refused => 'Шлюз отклонил этот запрос.';

  @override
  String get rel_admin_endpoint_answered => 'Конечная точка ответила.';

  @override
  String get rel_admin_endpoint_no_answer => 'Конечная точка не ответила.';

  @override
  String get rel_admin_charge_unknown =>
      'Результат списания неизвестен. Оно ещё может завершиться. Проверьте портал перед повторной попыткой.';

  @override
  String get rel_admin_connect_before_billing =>
      'Подключите активный сеанс шлюза перед просмотром оплаты. На этой странице ничего не списывается.';

  @override
  String get rel_admin_preset_required =>
      'Сохраните предустановку перед применением.';

  @override
  String get rel_admin_cancel => 'Отмена';

  @override
  String get rel_admin_refresh => 'Обновить';

  @override
  String get rel_admin_credits_and_plans => 'Кредиты и тарифы';

  @override
  String get rel_admin_saved => 'Сохранено';

  @override
  String get rel_admin_name => 'Имя';

  @override
  String get rel_admin_base_url => 'Базовый URL';

  @override
  String get rel_admin_model => 'Модель';

  @override
  String get rel_admin_signed_in => 'Вход выполнен';

  @override
  String get rel_admin_not_signed_in => 'Вход не выполнен';

  @override
  String get rel_admin_provider => 'Провайдер';

  @override
  String get rel_admin_apply_to_this_chat => 'Применить к этому чату';

  @override
  String get rel_admin_auto => 'Авто';

  @override
  String get rel_admin_chat_completions => 'Дополнения чата';

  @override
  String get rel_admin_codex_responses => 'Ответы Codex';

  @override
  String get rel_admin_anthropic_messages => 'Сообщения Anthropic';

  @override
  String get rel_admin_could_not_complete_that_request =>
      'Не удалось выполнить этот запрос.';

  @override
  String get rel_admin_confirm => 'Подтвердить';

  @override
  String get rel_admin_providers_and_billing => 'Провайдеры и оплата';

  @override
  String get rel_admin_api_keys => 'Ключи API';

  @override
  String get rel_admin_custom_endpoints => 'Пользовательские конечные точки';

  @override
  String get rel_admin_provider_accounts => 'Аккаунты провайдеров';

  @override
  String get rel_admin_effort_and_speed_presets =>
      'Предустановки усилий и скорости';

  @override
  String get rel_admin_delegation => 'Делегирование';

  @override
  String get rel_admin_mixture_of_agents => 'Смесь агентов';

  @override
  String get rel_admin_no_provider_keys_were_reported_for_this_profile =>
      'Для этого профиля не сообщено о ключах провайдеров.';

  @override
  String get rel_admin_not_saved => 'Не сохранено';

  @override
  String get rel_admin_new_key_value => 'Новое значение ключа';

  @override
  String get rel_admin_provider_key_saved => 'Ключ провайдера сохранён.';

  @override
  String get rel_admin_save_key => 'Сохранить ключ';

  @override
  String get rel_admin_clear_provider_key => 'Удалить ключ провайдера';

  @override
  String get rel_admin_provider_key_cleared => 'Ключ провайдера удалён.';

  @override
  String get rel_admin_clear_key => 'Удалить ключ';

  @override
  String get rel_admin_new_endpoint => 'Новая конечная точка';

  @override
  String get rel_admin_api_key => 'Ключ API';

  @override
  String get rel_admin_leave_blank_to_keep_a_key_this_endpoint_already_has =>
      'Оставьте пустым, чтобы сохранить существующий ключ этой конечной точки.';

  @override
  String get rel_admin_reachable => 'Доступна';

  @override
  String get rel_admin_unreachable => 'Недоступна';

  @override
  String get rel_admin_test_endpoint => 'Проверить конечную точку';

  @override
  String get rel_admin_endpoint_saved => 'Конечная точка сохранена.';

  @override
  String get rel_admin_save_endpoint => 'Сохранить конечную точку';

  @override
  String get rel_admin_use_this_endpoint => 'Использовать эту конечную точку';

  @override
  String
  get rel_admin_make_this_named_endpoint_the_current_model_for_this_profile =>
      'Сделать эту именованную конечную точку текущей моделью этого профиля?';

  @override
  String get rel_admin_endpoint_is_now_current =>
      'Конечная точка теперь текущая.';

  @override
  String get rel_admin_use_endpoint => 'Использовать конечную точку';

  @override
  String get rel_admin_delete_endpoint => 'Удалить конечную точку';

  @override
  String get rel_admin_delete_this_named_endpoint_from_the_profile =>
      'Удалить эту именованную конечную точку из профиля?';

  @override
  String get rel_admin_endpoint_deleted => 'Конечная точка удалена.';

  @override
  String get rel_admin_signing_in_stays_on_the_provider_sign_in_screen =>
      'Вход выполняется на экране провайдера. Отключение возможно только когда шлюз сообщает, что аккаунт можно удалить.';

  @override
  String get rel_admin_disconnect_this_provider_account_on_the_gateway =>
      'Отключить этот аккаунт провайдера на шлюзе?';

  @override
  String get rel_admin_provider_account_disconnected =>
      'Аккаунт провайдера отключён.';

  @override
  String get rel_admin_disconnect => 'Отключить';

  @override
  String get rel_admin_not_disconnectable => 'Нельзя отключить';

  @override
  String get rel_admin_fast => 'Быстро';

  @override
  String get rel_admin_preset_saved_for_this_model =>
      'Предустановка для этой модели сохранена.';

  @override
  String get rel_admin_save_preset => 'Сохранить предустановку';

  @override
  String get rel_admin_chat_id => 'ID чата';

  @override
  String get rel_admin_apply_preset => 'Применить предустановку';

  @override
  String get rel_admin_set_this_chat_s_effort_and_speed_from_the_saved_preset =>
      'Установить усилие и скорость этого чата из сохранённой предустановки?';

  @override
  String get rel_admin_preset_applied_to_this_chat =>
      'Предустановка применена к этому чату.';

  @override
  String get rel_admin_this_route_sends_the_picked_effort_unchanged =>
      'Этот маршрут передаёт выбранное усилие без изменений.';

  @override
  String get rel_admin_show_route_clamp => 'Показать ограничение маршрута';

  @override
  String get rel_admin_delegation_backend => 'Бэкенд делегирования';

  @override
  String get rel_admin_delegation_backend_saved =>
      'Бэкенд делегирования сохранён.';

  @override
  String get rel_admin_save_backend => 'Сохранить бэкенд';

  @override
  String get rel_admin_max_iterations => 'Максимум итераций';

  @override
  String get rel_admin_max_concurrent_children =>
      'Максимум параллельных дочерних агентов';

  @override
  String get rel_admin_child_timeout_seconds =>
      'Тайм-аут дочернего агента в секундах';

  @override
  String get rel_admin_delegation_effort_leave_unchanged =>
      'Усилие делегирования, оставить без изменений';

  @override
  String get rel_admin_delegation_limits_saved =>
      'Ограничения делегирования сохранены.';

  @override
  String get rel_admin_save_limits => 'Сохранить ограничения';

  @override
  String get rel_admin_remove_route => 'Убрать маршрут';

  @override
  String get rel_admin_route_name => 'Имя маршрута';

  @override
  String get rel_admin_route_provider => 'Провайдер маршрута';

  @override
  String get rel_admin_route_model => 'Модель маршрута';

  @override
  String get rel_admin_route_effort_unchanged =>
      'Усилие маршрута без изменений';

  @override
  String get rel_admin_add_route => 'Добавить маршрут';

  @override
  String get rel_admin_default_route => 'Маршрут по умолчанию';

  @override
  String get rel_admin_delegation_routes_saved =>
      'Маршруты делегирования сохранены.';

  @override
  String get rel_admin_save_routes => 'Сохранить маршруты';

  @override
  String get rel_admin_profile_routes_saved => 'Маршруты профилей сохранены.';

  @override
  String get rel_admin_save_profile_routes => 'Сохранить маршруты профилей';

  @override
  String get rel_admin_no_mixture_is_loaded => 'Смесь не загружена.';

  @override
  String get rel_admin_mixture_enabled => 'Смесь включена';

  @override
  String get rel_admin_loud_degraded_references =>
      'Уведомлять о деградации референсных моделей';

  @override
  String get rel_admin_silent_degraded_references =>
      'Не уведомлять о деградации референсных моделей';

  @override
  String get rel_admin_aggregator => 'Агрегатор';

  @override
  String get rel_admin_aggregator_provider => 'Провайдер агрегатора';

  @override
  String get rel_admin_aggregator_model => 'Модель агрегатора';

  @override
  String get rel_admin_reference_provider => 'Провайдер референсной модели';

  @override
  String get rel_admin_reference_model => 'Референсная модель';

  @override
  String get rel_admin_add_reference_model => 'Добавить референсную модель';

  @override
  String get rel_admin_mixture_saved => 'Смесь сохранена.';

  @override
  String get rel_admin_save_mixture => 'Сохранить смесь';

  @override
  String get rel_admin_credit_purchase_submitted =>
      'Покупка кредитов отправлена.';

  @override
  String get rel_admin_credit_purchase_settled => 'Покупка кредитов завершена.';

  @override
  String get rel_admin_credit_and_plan_changes_wait_for_confirmation_a_plan =>
      'Изменения кредитов и планов ожидают подтверждения. План с немедленным списанием отображается, но здесь не подтверждается.';

  @override
  String get rel_admin_buy_credits => 'Купить кредиты';

  @override
  String get rel_admin_retry_same_charge => 'Повторить то же списание';

  @override
  String get rel_admin_retry_the_same_credit_charge_this_does_not_start =>
      'Повторите то же списание за кредиты. Это не начинает вторую покупку.';

  @override
  String get rel_admin_credit_purchases_are_not_available_for_this_account =>
      'Покупка кредитов недоступна для этого аккаунта.';

  @override
  String get rel_admin_auto_reload => 'Автопополнение';

  @override
  String get rel_admin_read_only_until_this_account_can_charge =>
      'Только чтение, пока аккаунт не сможет оплачивать.';

  @override
  String get rel_admin_auto_reload_updated => 'Автопополнение обновлено.';

  @override
  String get rel_admin_keep_going_on_credits => 'Продолжать за кредиты';

  @override
  String get rel_admin_continue_on_credits_when_the_plan_window_is_used_up =>
      'Продолжать за кредиты после исчерпания квоты периода плана?';

  @override
  String
  get rel_admin_stop_continuing_on_credits_when_the_plan_window_is_used_up =>
      'Прекратить продолжение за кредиты после исчерпания квоты периода плана?';

  @override
  String get rel_admin_credit_continuation_updated =>
      'Продолжение за кредиты обновлено.';

  @override
  String get rel_admin_this_plan_change_is_not_confirmed_from_ares =>
      'Эта смена плана не подтверждается из Ares.';

  @override
  String get rel_admin_this_change_is_scheduled_confirm_to_apply_it =>
      'Это изменение запланировано. Подтвердите, чтобы применить его.';

  @override
  String get rel_admin_preview_plan => 'Предпросмотр плана';

  @override
  String get rel_admin_schedule_plan_change => 'Запланировать смену плана';

  @override
  String get rel_admin_plan_change_scheduled => 'Смена плана запланирована.';

  @override
  String get rel_admin_confirm_scheduled_plan_change =>
      'Подтвердить запланированную смену плана';

  @override
  String rel_admin_remove_key_confirm(String key) {
    return 'Удалить сохранённое значение $key из этого профиля?';
  }

  @override
  String rel_admin_current_endpoint(String name) {
    return '$name · текущая';
  }

  @override
  String rel_admin_endpoint_result(
    String status,
    String transport,
    String count,
    String message,
  ) {
    return '$status · $transport · моделей: $count. $message';
  }

  @override
  String rel_admin_disconnect_account(String name) {
    return 'Отключить $name';
  }

  @override
  String rel_admin_delegation_blocked(String reason) {
    return 'Делегирование заблокировано: $reason';
  }

  @override
  String rel_admin_backend_unavailable(String name) {
    return '$name · недоступен';
  }

  @override
  String rel_admin_reference_number(String number) {
    return 'Референсная модель $number';
  }

  @override
  String rel_admin_reload_enable_confirm(String amount, String threshold) {
    return 'Включить автопополнение и списывать $amount, когда баланс опускается ниже $threshold?';
  }

  @override
  String rel_admin_reload_disable_confirm(String amount, String threshold) {
    return 'Выключить автопополнение? Сейчас списывается $amount, когда баланс опускается ниже $threshold.';
  }

  @override
  String get rel_admin_this_plan => 'этот план';

  @override
  String rel_admin_plan_confirm(String name) {
    return 'Запланировать $name. Изменение назначено на конец текущего периода. Сейчас списания не будет.';
  }

  @override
  String rel_admin_plan_confirm_price(String name, String price) {
    return 'Запланировать $name за $price. Изменение назначено на конец текущего периода. Сейчас списания не будет.';
  }

  @override
  String rel_admin_plan_confirm_when(String name, String when) {
    return 'Запланировать $name. Вступает в силу $when. Сейчас списания не будет.';
  }

  @override
  String rel_admin_plan_confirm_price_when(
    String name,
    String price,
    String when,
  ) {
    return 'Запланировать $name за $price. Вступает в силу $when. Сейчас списания не будет.';
  }

  @override
  String rel_admin_balance(String amount) {
    return 'Баланс $amount';
  }

  @override
  String rel_admin_buy_confirm(String amount) {
    return 'Списать \$$amount через способ оплаты этого аккаунта Nous. Будут потрачены реальные деньги.';
  }

  @override
  String rel_admin_reload_portal(String url) {
    return 'Измените автопополнение на портале: $url';
  }

  @override
  String rel_admin_team_portal(String url) {
    return 'Подписки команды меняются на портале: $url';
  }

  @override
  String get rel_admin_effort_none => 'нет';

  @override
  String get rel_admin_effort_minimal => 'минимальный';

  @override
  String get rel_admin_effort_low => 'низкий';

  @override
  String get rel_admin_effort_medium => 'средний';

  @override
  String get rel_admin_effort_high => 'высокий';

  @override
  String get rel_admin_effort_xhigh => 'очень высокий';

  @override
  String get rel_admin_effort_max => 'максимальный';

  @override
  String get rel_admin_effort_ultra => 'сверхвысокий';

  @override
  String get rel_admin_auto_lower => 'Авто';

  @override
  String get rel_admin_create => 'Создать';

  @override
  String get rel_admin_prompt => 'Промпт';

  @override
  String get rel_admin_new_profile_id => 'ID нового профиля';

  @override
  String get rel_admin_this_operation_is_unavailable_on_this_gateway =>
      'Эта операция недоступна на этом шлюзе.';

  @override
  String get rel_admin_access_denied_by_the_gateway =>
      'Шлюз отказал в доступе.';

  @override
  String get rel_admin_connection_changed_reopen_profiles =>
      'Подключение изменилось. Откройте профили заново.';

  @override
  String
  get rel_admin_invalid_input_or_gateway_response_check_the_target_before =>
      'Недопустимый ввод или ответ шлюза. Проверьте цель перед повторной попыткой.';

  @override
  String get rel_admin_could_not_verify_the_result_refresh_the_target_before =>
      'Не удалось проверить результат. Обновите цель перед повторной попыткой.';

  @override
  String get rel_admin_edit_soul_md => 'Изменить SOUL.md';

  @override
  String get rel_admin_persona => 'Персона';

  @override
  String get rel_admin_persona_saved => 'Персона сохранена.';

  @override
  String get rel_admin_not_set => 'не задано';

  @override
  String get rel_admin_enabled => 'Включено';

  @override
  String get rel_admin_keys_to_remove_comma_separated =>
      'Ключи для удаления (через запятую)';

  @override
  String get rel_admin_saved_and_applied_by_the_gateway =>
      'Сохранено и применено шлюзом.';

  @override
  String get rel_admin_saved_a_gateway_restart_may_be_required =>
      'Сохранено. Может потребоваться перезапуск шлюза.';

  @override
  String get rel_admin_create_signed_route => 'Создать подписанный маршрут';

  @override
  String get rel_admin_route_id => 'ID маршрута';

  @override
  String get rel_admin_signature => 'Подпись';

  @override
  String get rel_admin_events_comma_separated => 'События (через запятую)';

  @override
  String get rel_admin_delivery_target => 'Цель доставки';

  @override
  String get rel_admin_skills_comma_separated => 'Навыки (через запятую)';

  @override
  String get rel_admin_delivery_mode => 'Режим доставки';

  @override
  String get rel_admin_delivery_chat_id_optional =>
      'ID чата доставки (необязательно)';

  @override
  String get rel_admin_hide_signing_secret => 'Скрыть секрет подписи';

  @override
  String get rel_admin_reveal_signing_secret => 'Показать секрет подписи';

  @override
  String get rel_admin_edit_persona => 'Изменить персону';

  @override
  String get rel_admin_portable_profile_bundle => 'Переносимый пакет профиля';

  @override
  String get rel_admin_clone_profile => 'Клонировать профиль';

  @override
  String get rel_admin_rename_display_label =>
      'Переименовать отображаемую метку';

  @override
  String get rel_admin_rename_profile => 'Переименовать профиль';

  @override
  String get rel_admin_new_name => 'Новое имя';

  @override
  String get rel_admin_rename_verified => 'Переименование проверено.';

  @override
  String get rel_admin_delete_profile => 'Удалить профиль';

  @override
  String get rel_admin_profile_id_to_delete => 'ID профиля для удаления';

  @override
  String get rel_admin_profile_deleted => 'Профиль удалён.';

  @override
  String
  get rel_admin_profile_deleted_server_identity_cleanup_is_still_pending =>
      'Профиль удалён. Очистка идентификационных данных сервера ещё ожидается.';

  @override
  String get rel_admin_export_profile_archive => 'Экспортировать архив профиля';

  @override
  String get rel_admin_import_profile_archive => 'Импортировать архив профиля';

  @override
  String get rel_admin_import_a_trusted_profile =>
      'Импортировать доверенный профиль';

  @override
  String get rel_admin_absolute_archive_path_on_gateway =>
      'Абсолютный путь к архиву на шлюзе';

  @override
  String get rel_admin_messaging_channels => 'Каналы сообщений';

  @override
  String get rel_admin_dm_pairing_requests =>
      'Запросы сопряжения в личных сообщениях';

  @override
  String get rel_admin_no_pending_or_approved_users =>
      'Нет ожидающих или одобренных пользователей.';

  @override
  String get rel_admin_legacy_pairing_no_verifiable_request_id_ask_the_user =>
      'Устаревшее сопряжение: нет проверяемого ID запроса. Попросите пользователя выполнить сопряжение снова.';

  @override
  String get rel_admin_pairing_change_verified =>
      'Изменение сопряжения проверено.';

  @override
  String get rel_admin_create_telegram_bot_by_qr =>
      'Создать бота Telegram по QR';

  @override
  String get rel_admin_create_telegram_bot => 'Создать бота Telegram';

  @override
  String get rel_admin_bot_name => 'Имя бота';

  @override
  String get rel_admin_telegram_bot_creation_qr_code =>
      'QR-код создания бота Telegram';

  @override
  String get rel_admin_check_telegram_pairing =>
      'Проверить сопряжение Telegram';

  @override
  String get rel_admin_waiting_for_telegram => 'Ожидание Telegram.';

  @override
  String get rel_admin_apply_telegram_bot => 'Применить бота Telegram';

  @override
  String get rel_admin_allowed_numeric_user_ids =>
      'Разрешённые числовые ID пользователей';

  @override
  String get rel_admin_saved_restart_still_required =>
      'Сохранено. Перезапуск всё ещё требуется.';

  @override
  String get rel_admin_saved_gateway_restart_requested =>
      'Сохранено; запрошен перезапуск шлюза.';

  @override
  String get rel_admin_cancel_telegram_setup => 'Отменить настройку Telegram';

  @override
  String get rel_admin_inbound_webhooks => 'Входящие вебхуки';

  @override
  String get rel_admin_enable_webhook_service => 'Включить службу вебхуков';

  @override
  String get rel_admin_enable_webhooks => 'Включить вебхуки';

  @override
  String get rel_admin_enabled_restart_still_required =>
      'Включено. Перезапуск всё ещё требуется.';

  @override
  String get rel_admin_enabled_restart_requested =>
      'Включено; запрошен перезапуск.';

  @override
  String get rel_admin_route_change_verified => 'Изменение маршрута проверено.';

  @override
  String get rel_admin_delete_route => 'Удалить маршрут';

  @override
  String get rel_admin_disable_route => 'Отключить маршрут';

  @override
  String get rel_admin_enable_route => 'Включить маршрут';

  @override
  String get rel_admin_back_up_entire_agent_home =>
      'Создать резервную копию всего домашнего каталога агента';

  @override
  String get rel_admin_transfer_to_a_cloud_agent => 'Перенести в агента Cloud';

  @override
  String get rel_admin_check_backup_progress =>
      'Проверить ход резервного копирования';

  @override
  String get rel_admin_save_backup_to_this_device =>
      'Сохранить резервную копию на этом устройстве';

  @override
  String get rel_admin_save_sensitive_full_home_archive =>
      'Сохранить конфиденциальный архив всего домашнего каталога';

  @override
  String get rel_admin_save_cancelled => 'Сохранение отменено.';

  @override
  String get rel_admin_backup_saved => 'Резервная копия сохранена.';

  @override
  String get rel_admin_up_to_32_mib_larger_archives_remain_on_the_gateway =>
      'До 32 MiB. Архивы большего размера остаются на шлюзе.';

  @override
  String rel_admin_persona_scope(String scope) {
    return 'Сохранить персону для $scope.';
  }

  @override
  String rel_admin_configure_channel(String name) {
    return 'Настроить $name';
  }

  @override
  String rel_admin_channel_warning(String scope) {
    return 'Применяется к $scope. Пустое поле сохраняет текущее значение. Для удаления значения укажите его ключ ниже.';
  }

  @override
  String rel_admin_hook_warning(String scope) {
    return 'Применяется к $scope. Используйте уникальное имя. Шлюз создаёт секрет подписи. Если другой оператор одновременно создаст это имя, хост может заменить этот маршрут.';
  }

  @override
  String rel_admin_hook_created(String url) {
    return 'Создано: $url. Сохраните секрет подписи перед выходом.';
  }

  @override
  String rel_admin_clone_warning(String scope) {
    return 'Скопировать настройки, навыки, персону и, возможно, учётные данные провайдеров из $scope. Токены сообщений не запрашиваются.';
  }

  @override
  String rel_admin_cloned(String source, String destination) {
    return '$source клонирован в $destination.';
  }

  @override
  String rel_admin_rename_target(String name) {
    return 'Переименовать $name';
  }

  @override
  String rel_admin_rename_label_warning(String scope) {
    return 'Изменить отображаемую метку $scope. ID останется default.';
  }

  @override
  String rel_admin_rename_warning(String scope) {
    return 'Переименовать $scope на сервере. Работающий шлюз может остановиться.';
  }

  @override
  String rel_admin_delete_target(String name) {
    return 'Удалить $name';
  }

  @override
  String rel_admin_delete_profile_warning(String scope) {
    return 'Безвозвратно удалить $scope, включая сеансы и учётные данные. Введите точный ID профиля.';
  }

  @override
  String rel_admin_export_target(String name) {
    return 'Экспортировать $name';
  }

  @override
  String rel_admin_export_warning(String scope) {
    return 'Создать .tar.gz на $scope. Известные хранилища учётных данных исключаются, но личные данные могут остаться. Проверьте перед отправкой.';
  }

  @override
  String rel_admin_archive_on(String gateway, String path) {
    return 'Архив на $gateway: $path';
  }

  @override
  String rel_admin_import_warning(String gateway) {
    return 'Используйте проверенный .tar.gz, уже находящийся на $gateway. Он может содержать плагины, скрипты и расписания. Нужен новый ID профиля.';
  }

  @override
  String rel_admin_imported(String name) {
    return 'Импортировано: $name.';
  }

  @override
  String rel_admin_approve_user(String user) {
    return 'Одобрить $user';
  }

  @override
  String rel_admin_revoke_user(String user) {
    return 'Отозвать $user';
  }

  @override
  String rel_admin_allow_pair(String platform, String scope) {
    return '$platform на $scope: разрешить этому пользователю доступ к сообщениям.';
  }

  @override
  String rel_admin_remove_pair(String platform, String scope) {
    return '$platform на $scope: удалить доступ этого пользователя к сообщениям.';
  }

  @override
  String rel_admin_telegram_start(String scope) {
    return 'Начать сопряжение Telegram на $scope через службу настройки шлюза.';
  }

  @override
  String rel_admin_expires(String time) {
    return 'Истекает: $time';
  }

  @override
  String rel_admin_telegram_apply(String bot, String scope) {
    return 'Включить @$bot на $scope и попытаться перезапустить шлюз. Только перечисленные пользователи смогут писать ему.';
  }

  @override
  String rel_admin_hooks_enable(String scope) {
    return 'Включить входящие вебхуки на $scope и попытаться перезапустить шлюз.';
  }

  @override
  String rel_admin_disable_target(String name) {
    return 'Отключить $name';
  }

  @override
  String rel_admin_enable_target(String name) {
    return 'Включить $name';
  }

  @override
  String rel_admin_hook_change(String name, String scope) {
    return 'Изменить именно $name на $scope.';
  }

  @override
  String rel_admin_backup_warning(String gateway) {
    return 'Это не резервная копия настроек Ares. Сохраните все профили, сеансы и учётные данные на $gateway. Архив содержит конфиденциальные данные.';
  }

  @override
  String rel_admin_backup_started(String gateway) {
    return 'Резервное копирование начато на $gateway.';
  }

  @override
  String rel_admin_backup_verified(String gateway, String path) {
    return 'Резервная копия проверена на $gateway: $path';
  }

  @override
  String rel_admin_backup_running(String gateway) {
    return 'Резервное копирование ещё идёт на $gateway.';
  }

  @override
  String get rel_admin_choice_yes => 'да';

  @override
  String get rel_admin_choice_no => 'нет';

  @override
  String get rel_admin_choice_generic => 'общая';

  @override
  String get rel_admin_choice_log => 'журнал';

  @override
  String get rel_admin_choice_email => 'электронная почта';

  @override
  String get rel_admin_choice_github_comment => 'комментарий GitHub';

  @override
  String get rel_admin_choice_agent => 'Агент обрабатывает событие';

  @override
  String get rel_admin_choice_direct => 'Прямая доставка';

  @override
  String get rel_admin_configured => 'настроено';

  @override
  String get rel_admin_state_pending_restart => 'ожидает перезапуска';

  @override
  String get rel_admin_state_unknown => 'неизвестно';

  @override
  String get rel_admin_state_connected => 'подключено';

  @override
  String get rel_admin_state_disconnected => 'отключено';

  @override
  String get rel_admin_state_disabled => 'отключено';

  @override
  String get rel_admin_state_enabled => 'включено';

  @override
  String get rel_admin_state_running => 'работает';

  @override
  String get rel_admin_state_stopped => 'остановлено';

  @override
  String get rel_admin_state_error => 'ошибка';

  @override
  String get rel_admin_state_not_configured => 'не настроено';

  @override
  String get rel_admin_state_startup_failed => 'ошибка запуска';

  @override
  String get rel_admin_state_gateway_stopped => 'шлюз остановлен';

  @override
  String get rel_admin_state_connecting => 'подключение';

  @override
  String get rel_admin_state_retrying => 'повторная попытка';

  @override
  String get rel_admin_state_fatal => 'критическая ошибка';

  @override
  String get rel_admin_unsupported_or_oversized_profile_archive =>
      'Неподдерживаемый или слишком большой архив профиля.';

  @override
  String get rel_admin_current_layout => 'Текущая компоновка';

  @override
  String get rel_admin_one_pane => 'Одна панель';

  @override
  String get rel_admin_stacked => 'Вертикально';

  @override
  String get rel_admin_side_by_side => 'Рядом';

  @override
  String get rel_admin_no_supported_appearance_in_this_profile =>
      'В этом профиле нет поддерживаемого оформления.';

  @override
  String get rel_admin_review_appearance_saved_with_this_profile =>
      'Проверить оформление, сохранённое с этим профилем';

  @override
  String get rel_admin_applies_only_to_this_named_profile_on_this_device =>
      'Применяется только к этому именованному профилю на этом устройстве. Импортированная компоновка начинается с пустых панелей; выберите чаты сами.';

  @override
  String get rel_admin_apply_to_this_profile_on_this_device =>
      'Применить к этому профилю на этом устройстве';

  @override
  String get rel_admin_export_prepares_a_tar_gz_on_the_gateway_review =>
      'Экспорт подготавливает .tar.gz на шлюзе. Проверьте переносимые файлы перед сохранением копии здесь. Импорт открывает локальный архив для проверки; само открытие ничего не загружает.';

  @override
  String get rel_admin_prepare_profile_export => 'Подготовить экспорт профиля';

  @override
  String get rel_admin_open_tar_gz_from_this_device =>
      'Открыть .tar.gz с этого устройства';

  @override
  String get rel_admin_only_selected_text_files_travel_review_for_secrets_and =>
      'Переносятся только выбранные текстовые файлы. Проверьте их на секреты и личные данные. Конфигурация, навыки и расписания могут изменить поведение нового профиля.';

  @override
  String get rel_admin_include_this_reviewed_file =>
      'Включить этот проверенный файл';

  @override
  String get rel_admin_apply_appearance_to_the_new_profile_on_this_device =>
      'Применить оформление к новому профилю на этом устройстве';

  @override
  String
  get rel_admin_imports_colours_and_pane_sizes_never_chats_tools_or_session_ids =>
      'Импортирует цвета и размеры панелей, но не чаты, инструменты или ID сеансов.';

  @override
  String
  get rel_admin_the_gateway_retains_a_private_staged_copy_import_creates =>
      'Шлюз сохраняет закрытую промежуточную копию. Импорт создаёт новый профиль и не заменяет существующий.';

  @override
  String get rel_admin_appearance_not_applied_the_gateway_did_not_confirm_the =>
      ' Оформление не применено: шлюз не подтвердил проверенное наложение.';

  @override
  String get rel_admin_appearance_applied_on_this_device =>
      ' Оформление применено на этом устройстве.';

  @override
  String get rel_admin_appearance_was_not_saved_on_this_device =>
      ' Оформление не сохранено на этом устройстве.';

  @override
  String get rel_admin_save_reviewed_profile_bundle =>
      'Сохранить проверенный пакет профиля';

  @override
  String get rel_admin_profile_bundle_saved => 'Пакет профиля сохранён.';

  @override
  String get rel_admin_import_selected_files => 'Импортировать выбранные файлы';

  @override
  String get rel_admin_save_selected_files_to_device =>
      'Сохранить выбранные файлы на устройство';

  @override
  String rel_admin_layout_first_pane(String layout, String percent) {
    return '$layout · $percent% первая панель';
  }

  @override
  String rel_admin_appearance_summary(String skin, String mode, String layout) {
    return 'Тема: $skin · Режим: $mode · $layout';
  }

  @override
  String rel_admin_appearance_applied(String gateway, String profile) {
    return 'Оформление применено к $gateway / $profile.';
  }

  @override
  String rel_admin_bundle_summary(
    String profile,
    String count,
    String omitted,
  ) {
    return 'Пакет: $profile · файлов для проверки: $count · пропущено: $omitted';
  }

  @override
  String rel_admin_imported_on(String name, String gateway) {
    return '$name импортирован на $gateway.';
  }

  @override
  String get rel_admin_unchanged => 'без изменений';

  @override
  String get rel_admin_mode_system => 'системный';

  @override
  String get rel_admin_mode_light => 'светлый';

  @override
  String get rel_admin_mode_dark => 'тёмный';

  @override
  String get rel_admin_skin_classic => 'классическая';

  @override
  String get rel_admin_skin_midnight => 'полночь';

  @override
  String get rel_admin_skin_ember => 'угли';

  @override
  String get rel_admin_skin_mono => 'монохромная';

  @override
  String get rel_admin_skin_cyberpunk => 'киберпанк';

  @override
  String get rel_admin_skin_slate => 'сланец';

  @override
  String get rel_admin_no_available_cloud_agents_in_this_account =>
      'В этом аккаунте нет доступных агентов Cloud.';

  @override
  String get rel_admin_the_previous_undo_receipt_could_not_be_verified_no =>
      'Не удалось проверить предыдущую квитанцию отмены. Изменений не было.';

  @override
  String get rel_admin_transfer_to_cloud => 'Перенести в Cloud';

  @override
  String
  get rel_admin_connection_changed_leave_this_page_a_restore_already_submitted =>
      'Подключение изменилось. Покиньте эту страницу. Уже отправленное восстановление может продолжаться.';

  @override
  String get rel_admin_find_my_cloud_agents => 'Найти моих агентов Cloud';

  @override
  String
  get rel_admin_undo_replaces_the_destination_with_its_pre_transfer_backup =>
      'Отмена заменяет содержимое назначения резервной копией до переноса.';

  @override
  String get rel_admin_replace_this_cloud_agent_with_the_entire_source_home =>
      'Замените этого агента Cloud всем домашним каталогом источника, включая учётные данные, разговоры и файлы. Источник не удаляется. Боты входящих сообщений отключаются.';

  @override
  String get rel_admin_type_destination_agent_id =>
      'Введите ID агента назначения';

  @override
  String
  get rel_admin_could_not_retain_the_local_undo_receipt_keep_this_page_open =>
      'Не удалось сохранить локальную квитанцию отмены. Оставьте страницу открытой.';

  @override
  String get rel_admin_undo_transfer => 'Отменить перенос';

  @override
  String get rel_admin_replace_cloud_agent => 'Заменить агента Cloud';

  @override
  String
  get rel_admin_local_undo_receipt_forgotten_no_remote_backup_was_removed =>
      'Локальная квитанция отмены забыта. Удалённые резервные копии не удалены.';

  @override
  String get rel_admin_forget_local_undo_receipt_only =>
      'Забыть только локальную квитанцию отмены';

  @override
  String get rel_admin_stop_before_restore => 'Остановить до восстановления';

  @override
  String get rel_admin_do_not_close_this_page_restore_runs_on_the =>
      'Не закрывайте страницу. Восстановление выполняется на стороне назначения, его нельзя отменить.';

  @override
  String get rel_admin_files_restored_destination_gateway_needs_attention =>
      'Файлы восстановлены; шлюз назначения требует внимания.';

  @override
  String rel_admin_transfer_sign_in(String origin) {
    return 'Войдите ровно в одно сохранённое подключение Ares для $origin, затем вернитесь сюда.';
  }

  @override
  String rel_admin_transfer_source(String gateway, String profile) {
    return 'Источник: $gateway / $profile';
  }

  @override
  String rel_admin_transfer_destination(String name, String origin) {
    return 'Назначение: $name · $origin / default';
  }

  @override
  String rel_admin_agent_id(String id) {
    return 'ID агента: $id';
  }

  @override
  String rel_admin_transfer_status(String phase) {
    return 'Статус: $phase';
  }

  @override
  String rel_admin_copied_percent(String percent) {
    return 'Скопировано $percent%';
  }

  @override
  String rel_admin_undo_point(String path) {
    return 'Точка отмены на стороне назначения: $path';
  }

  @override
  String rel_admin_messaging_disabled(String channels) {
    return 'Сообщения отключены: $channels';
  }

  @override
  String get rel_admin_phase_prepared => 'подготовлено';

  @override
  String get rel_admin_phase_backup => 'резервное копирование';

  @override
  String get rel_admin_phase_upload => 'загрузка';

  @override
  String get rel_admin_phase_restore => 'восстановление';

  @override
  String get rel_admin_phase_finished => 'завершено';

  @override
  String get rel_admin_phase_failed => 'ошибка';

  @override
  String get rel_admin_phase_undo => 'отмена';

  @override
  String get rel_admin_phase_undone => 'отменено';

  @override
  String rel_ops_cap_install_blocked(String verdict, String detail) {
    return 'Установка заблокирована ($verdict): $detail';
  }

  @override
  String rel_ops_cap_scan_confirm(String verdict, String requested) {
    return 'Результат проверки: $verdict. Подтвердите $requested перед установкой.';
  }

  @override
  String rel_ops_cap_install_unconfirmed(String requested) {
    return 'Шлюз не подтвердил установку $requested.';
  }

  @override
  String rel_ops_cap_edit_skill(String name) {
    return 'Изменить $name';
  }

  @override
  String rel_ops_cap_archive_skill(String name) {
    return 'Архивировать $name?';
  }

  @override
  String rel_ops_cap_archive_explanation(String command) {
    return 'Навык будет архивирован, и его можно будет восстановить командой $command.';
  }

  @override
  String rel_ops_cap_install_anyway(String name) {
    return 'Всё равно установить $name';
  }

  @override
  String rel_ops_cap_install_despite_scan(String name) {
    return 'Установить $name вопреки результату проверки?';
  }

  @override
  String rel_ops_cap_scan_warning(String name) {
    return 'Проверка безопасности заблокировала $name. Это подтверждение действует только для $name.';
  }

  @override
  String rel_ops_cap_accept_scan_warning(String name) {
    return 'Принятие возможностей не отменяет результат проверки $name.';
  }

  @override
  String rel_ops_cap_review_scan(String name) {
    return 'Просмотреть результат проверки $name';
  }

  @override
  String rel_ops_cap_desktop_grants(String description) {
    return '$description\nРазрешения на папки и скрипты предпросмотра остаются в приложении Desktop на том компьютере. Удаление плагина здесь не отзывает эти локальные разрешения.';
  }

  @override
  String rel_ops_cap_remove_plugin(String name) {
    return 'Удалить $name?';
  }

  @override
  String rel_ops_cap_probe_result(String name, String tools) {
    return 'Проверка подключения $name: $tools';
  }

  @override
  String rel_ops_cap_save_tool_grants_for(String connector) {
    return 'Сохранить разрешения инструментов для $connector';
  }

  @override
  String rel_ops_cap_backends_for(String name) {
    return 'Серверные модули для $name';
  }

  @override
  String rel_ops_cap_use_backend_confirmation(String name) {
    return 'Использовать $name?';
  }

  @override
  String rel_ops_cap_unlock_source(String name) {
    return 'Разблокировать $name';
  }

  @override
  String get rel_ops_cap_capabilities => 'Возможности';

  @override
  String get rel_ops_cap_plugins => 'Плагины';

  @override
  String get rel_ops_cap_connectors => 'Коннекторы';

  @override
  String get rel_ops_cap_backends => 'Серверные модули';

  @override
  String get rel_ops_cap_save_skill => 'Сохранить навык';

  @override
  String get rel_ops_cap_archive => 'Архивировать';

  @override
  String get rel_ops_cap_hub_identifier => 'Идентификатор Hub';

  @override
  String get rel_ops_cap_install => 'Установить';

  @override
  String get rel_ops_cap_update_all => 'Обновить всё';

  @override
  String get rel_ops_cap_unlock => 'Разблокировать';

  @override
  String get rel_ops_cap_lock => 'Заблокировать';

  @override
  String get rel_ops_cap_this_update_adds_capabilities_nothing_changed_yet =>
      'Это обновление добавляет возможности. Пока ничего не изменено.';

  @override
  String get rel_ops_cap_the_scan_blocked_this_plugin =>
      'Проверка заблокировала этот плагин.';

  @override
  String get rel_ops_cap_the_plugin_was_not_changed => 'Плагин не изменён.';

  @override
  String get rel_ops_cap_repository => 'Репозиторий';

  @override
  String get rel_ops_cap_install_plugin => 'Установить плагин';

  @override
  String get rel_ops_cap_update_plugins => 'Обновить плагины';

  @override
  String get rel_ops_cap_accept_capabilities => 'Принять возможности';

  @override
  String get rel_ops_cap_update => 'Обновить';

  @override
  String get rel_ops_cap_remove_desktop_half => 'Удалить настольный компонент';

  @override
  String get rel_ops_cap_server_name => 'Имя сервера';

  @override
  String get rel_ops_cap_command => 'Команда';

  @override
  String get rel_ops_cap_http_url => 'HTTP URL';

  @override
  String get rel_ops_cap_add_server => 'Добавить сервер';

  @override
  String get rel_ops_cap_probe => 'Проверить подключение';

  @override
  String get rel_ops_cap_probe_failed => 'Проверка подключения не удалась.';

  @override
  String get rel_ops_cap_logs => 'Журналы';

  @override
  String get rel_ops_cap_mcp_log => 'Журнал MCP';

  @override
  String get rel_ops_cap_connector => 'Коннектор';

  @override
  String get rel_ops_cap_account_alias => 'Псевдоним учётной записи';

  @override
  String get rel_ops_cap_link_account => 'Привязать учётную запись';

  @override
  String get rel_ops_cap_remove_account => 'Удалить учётную запись';

  @override
  String get rel_ops_cap_tool_connector => 'Коннектор инструментов';

  @override
  String get rel_ops_cap_load_tools => 'Загрузить инструменты';

  @override
  String get rel_ops_cap_save_tool_grants =>
      'Сохранить разрешения инструментов';

  @override
  String
  get rel_ops_cap_this_policy_has_no_member_revision_so_tool_grants_stay_unchanged =>
      'В этой политике нет ревизии участника, поэтому разрешения инструментов остаются без изменений.';

  @override
  String get rel_ops_cap_active => 'Активен';

  @override
  String get rel_ops_cap_use => 'Использовать';

  @override
  String get rel_ops_cap_run_setup => 'Запустить настройку';

  @override
  String get rel_ops_cap_terminal_backends => 'Серверные модули терминала';

  @override
  String get rel_ops_cap_this_changes_the_terminal_backend_for_this_profile =>
      'Это изменит серверный модуль терминала для этого профиля.';

  @override
  String get rel_ops_cap_use_backend => 'Использовать модуль';

  @override
  String get rel_ops_cap_select => 'Выбрать';

  @override
  String get rel_ops_cap_browser_vault => 'Хранилище браузера';

  @override
  String
  get rel_ops_cap_saved_site_logins_addresses_and_cards_passwords_stay_in_the_secure_fields_and_are_not_listed_here =>
      'Сохранённые данные входа на сайты, адреса и карты. Пароли остаются в защищённых полях и здесь не отображаются.';

  @override
  String get rel_ops_cap_remove_saved_item => 'Удалить сохранённый элемент';

  @override
  String get rel_ops_cap_delete_this_item => 'Удалить этот элемент?';

  @override
  String get rel_ops_cap_unlocked => 'Разблокировано';

  @override
  String get rel_ops_cap_locked => 'Заблокировано';

  @override
  String get rel_ops_cap_not_detected => 'Не обнаружено';

  @override
  String get rel_ops_cap_master_password => 'Мастер-пароль';

  @override
  String get rel_ops_cap_login => 'Данные входа';

  @override
  String get rel_ops_cap_address => 'Адрес';

  @override
  String get rel_ops_cap_card => 'Карта';

  @override
  String get rel_ops_cap_label => 'Метка';

  @override
  String get rel_ops_cap_site_origin => 'Источник сайта';

  @override
  String get rel_ops_cap_identifier => 'Идентификатор';

  @override
  String get rel_ops_cap_password => 'Пароль';

  @override
  String get rel_ops_cap_authenticator_key => 'Ключ аутентификатора';

  @override
  String get rel_ops_cap_street => 'Улица';

  @override
  String get rel_ops_cap_city => 'Город';

  @override
  String get rel_ops_cap_postal_code => 'Почтовый индекс';

  @override
  String get rel_ops_cap_country => 'Страна';

  @override
  String get rel_ops_cap_name_on_card => 'Имя на карте';

  @override
  String get rel_ops_cap_card_number => 'Номер карты';

  @override
  String get rel_ops_cap_expiry_month => 'Месяц окончания срока действия';

  @override
  String get rel_ops_cap_expiry_year => 'Год окончания срока действия';

  @override
  String get rel_ops_cap_security_code => 'Код безопасности';

  @override
  String get rel_ops_cap_this_gateway_has_no_shared_metrics_consent_method =>
      'У этого шлюза нет метода получения согласия на передачу общих метрик.';

  @override
  String get rel_ops_cap_agent_policy => 'Политика агента';

  @override
  String get rel_ops_cap_loading_policy => 'Загрузка политики';

  @override
  String get rel_ops_cap_approval_timeout => 'Время ожидания одобрения';

  @override
  String get rel_ops_cap_confirm_mcp_reloads => 'Подтверждать перезагрузки MCP';

  @override
  String get rel_ops_cap_command_allowlist => 'Список разрешённых команд';

  @override
  String get rel_ops_cap_file_checkpoints => 'Контрольные точки файлов';

  @override
  String get rel_ops_cap_checkpoint_limit => 'Лимит контрольных точек';

  @override
  String get rel_ops_cap_browser_private_urls => 'Частные URL в браузере';

  @override
  String get rel_ops_cap_use_my_real_browser_profile =>
      'Использовать мой настоящий профиль браузера';

  @override
  String get rel_ops_cap_save_policy => 'Сохранить политику';

  @override
  String get rel_ops_cap_shared_metrics_for_this_profile =>
      'Общие метрики этого профиля';

  @override
  String get rel_ops_cap_send_shared_metrics => 'Отправлять общие метрики';

  @override
  String get rel_ops_cap_error_enter_a_label => 'Введите метку.';

  @override
  String get rel_ops_cap_error_enter_a_valid_url_like_https_example_com =>
      'Введите корректный URL, например https://example.com.';

  @override
  String get rel_ops_cap_error_enter_the_identifier_and_password =>
      'Введите идентификатор и пароль.';

  @override
  String
  get rel_ops_cap_error_enter_the_card_name_number_expiry_and_security_code =>
      'Введите имя на карте, номер, срок действия и код безопасности.';

  @override
  String get rel_ops_cap_error_enter_the_street_city_postal_code_and_country =>
      'Введите улицу, город, почтовый индекс и страну.';

  @override
  String
  get rel_ops_cap_error_the_gateway_returned_a_response_that_could_not_be_read =>
      'Шлюз вернул ответ, который не удалось прочитать.';

  @override
  String rel_ops_cap_error_the_gateway_refused_the_request_status(
    int statusCode,
  ) {
    return 'Шлюз отклонил запрос ($statusCode).';
  }

  @override
  String
  rel_ops_cap_error_this_connection_has_no_gateway_socket_so_method_is_unavailable(
    String method,
  ) {
    return 'У этого подключения нет сокета шлюза, поэтому $method недоступен.';
  }

  @override
  String get rel_ops_cap_error_choose_a_skill => 'Выберите навык.';

  @override
  String get rel_ops_cap_error_the_skill_text_was_not_returned =>
      'Текст навыка не получен.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_saved => 'Навык не сохранён.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_archived =>
      'Навык не архивирован.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_installed =>
      'Навык не установлен.';

  @override
  String get rel_ops_cap_error_skill_updates_did_not_start =>
      'Обновление навыков не запущено.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_removed => 'Навык не удалён.';

  @override
  String get rel_ops_cap_error_enter_a_skill_or_plugin_identifier =>
      'Введите идентификатор навыка или плагина.';

  @override
  String get rel_ops_cap_error_choose_a_plugin => 'Выберите плагин.';

  @override
  String get rel_ops_cap_error_the_plugin_was_not_removed =>
      'Плагин не удалён.';

  @override
  String get rel_ops_cap_error_the_desktop_half_was_not_removed =>
      'Настольный компонент не удалён.';

  @override
  String
  get rel_ops_cap_error_this_gateway_did_not_give_the_plugin_a_stable_key =>
      'Этот шлюз не назначил плагину стабильный ключ.';

  @override
  String get rel_ops_cap_error_the_plugin_was_not_changed =>
      'Плагин не изменён.';

  @override
  String get rel_ops_cap_error_choose_a_server => 'Выберите сервер.';

  @override
  String get rel_ops_cap_error_name_the_server => 'Укажите имя сервера.';

  @override
  String get rel_ops_cap_error_give_the_server_a_command_or_an_http_s_url =>
      'Укажите для сервера команду или URL http(s).';

  @override
  String get rel_ops_cap_error_choose_a_toolset =>
      'Выберите набор инструментов.';

  @override
  String get rel_ops_cap_error_tool_backend_status_was_not_returned =>
      'Состояние серверного модуля инструментов не получено.';

  @override
  String get rel_ops_cap_error_choose_a_provider => 'Выберите провайдера.';

  @override
  String get rel_ops_cap_error_this_provider_has_no_setup_action =>
      'У этого провайдера нет действия настройки.';

  @override
  String get rel_ops_cap_error_setup_did_not_start => 'Настройка не запущена.';

  @override
  String get rel_ops_cap_error_choose_a_terminal_backend =>
      'Выберите серверный модуль терминала.';

  @override
  String get rel_ops_cap_error_name_the_connector => 'Укажите имя коннектора.';

  @override
  String get rel_ops_cap_error_choose_an_account => 'Выберите учётную запись.';

  @override
  String
  get rel_ops_cap_error_reload_the_connector_policy_before_changing_tool_grants =>
      'Перезагрузите политику коннектора перед изменением разрешений инструментов.';

  @override
  String get rel_ops_cap_error_choose_an_item => 'Выберите элемент.';

  @override
  String get rel_ops_cap_error_choose_a_source => 'Выберите источник.';

  @override
  String get rel_ops_cap_error_enter_the_master_password =>
      'Введите мастер-пароль.';

  @override
  String get rel_ops_cap_error_gateway_config_was_not_returned =>
      'Конфигурация шлюза не получена.';

  @override
  String get rel_ops_cap_error_choose_a_known_approval_mode =>
      'Выберите известный режим одобрения.';

  @override
  String get rel_ops_cap_error_use_a_positive_limit =>
      'Укажите положительный лимит.';

  @override
  String get rel_ops_cap_error_the_policy_was_not_saved =>
      'Политика не сохранена.';

  @override
  String get rel_ops_cap_value_manual => 'вручную';

  @override
  String get rel_ops_cap_value_smart => 'интеллектуальный';

  @override
  String get rel_ops_cap_value_off => 'выкл.';

  @override
  String get rel_ops_cap_value_safe => 'безопасно';

  @override
  String get rel_ops_cap_value_caution => 'осторожно';

  @override
  String get rel_ops_cap_value_dangerous => 'опасно';

  @override
  String get rel_ops_cap_value_blocked => 'заблокировано';

  @override
  String get rel_ops_cap_value_clean => 'угроз нет';

  @override
  String get rel_ops_cap_value_ready => 'готово';

  @override
  String get rel_ops_cap_value_available => 'доступно';

  @override
  String get rel_ops_cap_value_unavailable => 'недоступно';

  @override
  String get rel_ops_cap_value_enabled => 'включено';

  @override
  String get rel_ops_cap_value_disabled => 'отключено';

  @override
  String get rel_ops_cap_value_active => 'активно';

  @override
  String get rel_ops_cap_value_inactive => 'неактивно';

  @override
  String get rel_ops_cap_value_installed => 'установлено';

  @override
  String get rel_ops_cap_value_missing => 'отсутствует';

  @override
  String get rel_ops_cap_value_configured => 'настроено';

  @override
  String get rel_ops_cap_value_not_configured => 'не настроено';

  @override
  String get rel_ops_cap_value_error => 'ошибка';

  @override
  String get rel_ops_cap_value_unknown => 'неизвестно';

  @override
  String get rel_ops_cap_value_login => 'данные входа';

  @override
  String get rel_ops_cap_value_address => 'адрес';

  @override
  String get rel_ops_cap_value_payment => 'платёж';

  @override
  String get rel_ops_term_connecting => 'Подключение…';

  @override
  String get rel_ops_term_unbound =>
      'Нет подходящего активного сеанса или рабочего каталога на хосте. Сначала откройте связанный чат.';

  @override
  String get rel_ops_term_unsupported =>
      'Этот шлюз не предоставляет такую возможность терминала. Локальная оболочка не была запущена.';

  @override
  String get rel_ops_term_local_pty_unavailable =>
      'Встроенный локальный псевдотерминал (PTY) недоступен на этом устройстве.';

  @override
  String get rel_ops_term_operation_failed =>
      'Не удалось открыть терминал или управлять им. Проверьте хост, учётные данные и отпечаток. Запасная оболочка не была запущена.';

  @override
  String get rel_ops_term_input_refused =>
      'Ввод отклонён. Снова откройте исходный чат.';

  @override
  String get rel_ops_term_cancel => 'Отмена';

  @override
  String get rel_ops_term_confirm => 'Подтвердить';

  @override
  String get rel_ops_term_open_device_title =>
      'Открыть оболочку на этом устройстве?';

  @override
  String get rel_ops_term_ssh_shell => 'Оболочка SSH';

  @override
  String get rel_ops_term_local_shell => 'Локальная оболочка';

  @override
  String get rel_ops_term_connection_lost => 'Соединение потеряно';

  @override
  String get rel_ops_term_shell_ended => 'Оболочка завершена';

  @override
  String get rel_ops_term_no_owner =>
      'У этого чата нет аутентифицированного владельца терминала шлюза. Одного URL или входа в облако недостаточно для доступа к оболочке.';

  @override
  String get rel_ops_term_open_gateway_title => 'Открыть оболочку шлюза?';

  @override
  String get rel_ops_term_shell_expired =>
      'Оболочка завершена или срок её действия истёк';

  @override
  String get rel_ops_term_disconnected => 'Отключено';

  @override
  String get rel_ops_term_gateway_shell => 'Оболочка шлюза';

  @override
  String get rel_ops_term_close_body =>
      'Завершить эту оболочку. Чтобы оставить её работающей, вместо этого скройте панель.';

  @override
  String get rel_ops_term_closing => 'Закрытие…';

  @override
  String get rel_ops_term_close_unconfirmed => 'Закрытие не подтверждено';

  @override
  String get rel_ops_term_processes_require_chat =>
      'Для процессов агента требуется аутентифицированный чат, которому они принадлежат.';

  @override
  String get rel_ops_term_watching_processes =>
      'Наблюдение за процессами агента этого чата. Закрытие зеркального представления никогда не останавливает его процесс.';

  @override
  String get rel_ops_term_paste_limit => 'Размер вставки ограничен 16 KiB.';

  @override
  String get rel_ops_term_paste => 'Вставить';

  @override
  String get rel_ops_term_select_first => 'Сначала выделите вывод терминала.';

  @override
  String get rel_ops_term_open_chat_to_insert =>
      'Откройте исходный чат перед вставкой вывода.';

  @override
  String get rel_ops_term_added_to_draft =>
      'Добавлено в черновик исходного чата. Ничего не отправлено.';

  @override
  String get rel_ops_term_close => 'Закрыть';

  @override
  String get rel_ops_term_add_selection =>
      'Добавить выделенное в черновик чата';

  @override
  String get rel_ops_term_new_terminal => 'Новый терминал';

  @override
  String get rel_ops_term_gateway_terminal => 'Терминал хоста шлюза';

  @override
  String get rel_ops_term_verified_ssh_terminal => 'Проверенный терминал SSH';

  @override
  String get rel_ops_term_device_local_shell =>
      'Это устройство (локальная оболочка)';

  @override
  String get rel_ops_term_local_unavailable_mobile =>
      'Локальная оболочка недоступна на мобильных устройствах';

  @override
  String get rel_ops_term_watch_processes => 'Наблюдать за процессами агента';

  @override
  String get rel_ops_term_select_output => 'Выделить или скопировать вывод';

  @override
  String get rel_ops_term_add_selected_output =>
      'Добавить выделенный вывод в черновик чата';

  @override
  String get rel_ops_term_review_paste => 'Проверить вставку из буфера обмена';

  @override
  String get rel_ops_term_reconnect => 'Подключиться к той же оболочке заново';

  @override
  String get rel_ops_term_close_mirror => 'Закрыть зеркальное представление';

  @override
  String get rel_ops_term_close_shell => 'Закрыть оболочку';

  @override
  String get rel_ops_term_empty =>
      'Нажмите +, чтобы открыть терминал. Ни одна оболочка не запускается автоматически.';

  @override
  String get rel_ops_term_reason_stale => 'устарело';

  @override
  String get rel_ops_term_reason_mismatch => 'несоответствие';

  @override
  String get rel_ops_term_reason_unbound => 'не привязано';

  @override
  String get rel_ops_term_reason_unsupported => 'не поддерживается';

  @override
  String get rel_ops_term_reason_denied => 'отказано';

  @override
  String get rel_ops_term_reason_ineligible => 'не соответствует условиям';

  @override
  String get rel_ops_term_reason_unavailable => 'недоступно';

  @override
  String get rel_ops_term_reason_invalid => 'недопустимо';

  @override
  String get rel_ops_term_reason_insecure => 'небезопасно';

  @override
  String rel_ops_term_refused(String reason) {
    return 'Шлюз отклонил эту операцию терминала ($reason).';
  }

  @override
  String rel_ops_term_open_device_body(String connection) {
    return 'Это устройство с Ares, а не $connection. Оболочка использует разрешения приложения и запускается в его хранилище.';
  }

  @override
  String rel_ops_term_open_gateway_body(String host) {
    return 'Запустите оболочку на $host в проверенном рабочем каталоге чата. Это не оболочка устройства.';
  }

  @override
  String rel_ops_term_close_tab_title(String label) {
    return 'Закрыть $label?';
  }

  @override
  String rel_ops_term_read_only_status(String status) {
    return 'Только чтение · $status';
  }

  @override
  String rel_ops_term_paste_title(String label) {
    return 'Вставить в $label?';
  }

  @override
  String rel_ops_term_output_title(String label) {
    return 'Вывод · $label';
  }

  @override
  String rel_ops_term_mirror_status(String label) {
    return 'Зеркальное представление процесса только для чтения · $label';
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
    return 'Это устройство · $number';
  }

  @override
  String rel_ops_term_gateway_tab(String host, int number) {
    return 'Шлюз $host · $number';
  }

  @override
  String get rel_ops_term_earlier_output_trimmed =>
      '[Предыдущий вывод обрезан]';

  @override
  String get rel_ops_term_ssh_dialog_title =>
      'Открыть проверенный терминал SSH';

  @override
  String get rel_ops_term_ssh_dialog_body =>
      'Используйте отпечаток, полученный по независимому каналу от администратора хоста. Будет открыт новый удалённый сеанс входа, а не шлюз или локальная оболочка.';

  @override
  String get rel_ops_term_ssh_host => 'Хост SSH';

  @override
  String get rel_ops_term_ssh_port => 'Порт';

  @override
  String get rel_ops_term_ssh_user => 'Пользователь';

  @override
  String get rel_ops_term_ssh_fingerprint => 'Отпечаток ключа хоста (SHA256:…)';

  @override
  String get rel_ops_term_ssh_password => 'Пароль SSH (не сохраняется)';

  @override
  String get rel_ops_term_connect => 'Подключиться';

  @override
  String get rel_ops_ssh_invalid_destination =>
      'Недопустимый хост, порт или пользователь SSH.';

  @override
  String get rel_ops_ssh_public_key_required =>
      'Требуется открытый ключ хоста OpenSSH Ed25519.';

  @override
  String get rel_ops_ssh_invalid_public_key =>
      'Недопустимый ключ хоста Ed25519.';

  @override
  String get rel_ops_ssh_invalid_saved_key =>
      'Недопустимый сохранённый ключ хоста.';

  @override
  String get rel_ops_ssh_enrollment_unverified =>
      'Не удалось проверить регистрацию ключа хоста.';

  @override
  String get rel_ops_ssh_different_key_pinned =>
      'Уже закреплён другой ключ. Проверьте изменение отдельно.';

  @override
  String get rel_ops_ssh_open_ssh_unavailable =>
      'Системный OpenSSH недоступен.';

  @override
  String get rel_ops_ssh_confirm_host_key =>
      'Подтвердите ключ хоста перед подключением.';

  @override
  String get rel_ops_ssh_absolute_identity_required =>
      'Выберите файл идентификации с абсолютным путём.';

  @override
  String get rel_ops_ssh_invalid_remote_port => 'Недопустимый удалённый порт.';

  @override
  String get rel_ops_ssh_preview_too_large =>
      'Предпросмотр превышает ограничение в 64 KiB.';

  @override
  String get rel_ops_ssh_connection_refused =>
      'SSH-подключение отклонено. Проверьте зарегистрированный ключ хоста, данные идентификации и службу.';

  @override
  String get rel_ops_ssh_http_not_ok => 'Удалённая служба не вернула HTTP 200.';

  @override
  String get rel_ops_ssh_encoded_response =>
      'Этот предпросмотр не поддерживает закодированные ответы.';

  @override
  String get rel_ops_ssh_preview_type_unsupported =>
      'Предпросмотр доступен только для текста и исходного кода HTML.';

  @override
  String get rel_ops_ssh_health_unconfirmed =>
      'Служба не подтвердила работоспособность шлюза.';

  @override
  String get rel_ops_ssh_enroll_host_key_first =>
      'Сначала зарегистрируйте открытый ключ хоста.';

  @override
  String get rel_ops_ssh_cancel => 'Отмена';

  @override
  String get rel_ops_ssh_confirm => 'Подтвердить';

  @override
  String get rel_ops_ssh_pin_title => 'Закрепить этот ключ хоста SSH?';

  @override
  String rel_ops_ssh_pin_detail(String destination, String fingerprint) {
    return '$destination\n$fingerprint\nСверьте этот отпечаток с администратором хоста по независимому каналу. Подключение установлено не будет.';
  }

  @override
  String get rel_ops_ssh_host_key_pinned => 'Ключ хоста закреплён.';

  @override
  String get rel_ops_ssh_shell_detail =>
      'Открыть интерактивную оболочку входа в систему.';

  @override
  String rel_ops_ssh_read_detail(String path, int port) {
    return 'Прочитать $path на удалённом адресе 127.0.0.1:$port через канал SSH.';
  }

  @override
  String rel_ops_ssh_connect_title(String destination) {
    return 'Подключиться к $destination?';
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
      'Пройти аутентификацию с помощью вашего агента SSH.';

  @override
  String get rel_ops_ssh_identity_auth =>
      'Использовать выбранный файл идентификации.';

  @override
  String rel_ops_ssh_gateway_responding(int port) {
    return 'Шлюз отвечает на удалённом порту петлевого интерфейса $port.';
  }

  @override
  String get rel_ops_ssh_session_closed => 'Сессия SSH закрыта.';

  @override
  String get rel_ops_ssh_session_unclean =>
      'Сессия SSH завершилась некорректно.';

  @override
  String get rel_ops_ssh_operation_failed =>
      'Сбой операции SSH. Проверьте адрес назначения и данные идентификации.';

  @override
  String get rel_ops_ssh_title => 'Проверенный SSH';

  @override
  String get rel_ops_ssh_unsupported =>
      'На этом устройстве нет поддерживаемого системного транспорта OpenSSH. Ретранслятор закреплённого шлюза автоматически принимает новые ключи и не может использоваться для проверенной регистрации.';

  @override
  String get rel_ops_ssh_host => 'Хост SSH';

  @override
  String get rel_ops_ssh_port => 'Порт SSH';

  @override
  String get rel_ops_ssh_user => 'Пользователь SSH';

  @override
  String get rel_ops_ssh_identity =>
      'Файл идентификации (необязательно; иначе используется агент SSH)';

  @override
  String get rel_ops_ssh_public_key =>
      'Открытый ключ хоста от администратора (ssh-ed25519)';

  @override
  String get rel_ops_ssh_review_key => 'Проверить ключ хоста';

  @override
  String get rel_ops_ssh_remote_port =>
      'Удалённый порт службы на петлевом интерфейсе';

  @override
  String get rel_ops_ssh_check_gateway => 'Проверить шлюз через SSH';

  @override
  String get rel_ops_ssh_preview_source =>
      'Предпросмотр исходного кода через SSH';

  @override
  String get rel_ops_ssh_open_shell => 'Открыть оболочку SSH';

  @override
  String get rel_ops_ssh_shell_line => 'Строка для удалённой оболочки';

  @override
  String get rel_ops_ssh_disconnect => 'Отключить оболочку';

  @override
  String get rel_ops_host_cancel => 'Отмена';

  @override
  String get rel_ops_host_confirm => 'Подтвердить';

  @override
  String get rel_ops_host_title => 'Хост';

  @override
  String get rel_ops_host_refresh => 'Обновить';

  @override
  String get rel_ops_host_update => 'Обновить Hermes на удалённом хосте';

  @override
  String rel_ops_host_update_confirmation(String profile) {
    return 'Это запустит обновление существующей установки на хосте шлюза для $profile. Ares на этом устройстве обновлён не будет. Успех подтверждается соответствующим отчётом об обновлении, а не тем, что хост остаётся доступным.';
  }

  @override
  String get rel_ops_host_update_awaiting =>
      'Ожидание соответствующего отчёта. Обновление ещё выполняется.';

  @override
  String get rel_ops_host_receipt_success =>
      'Отчёт об обновлении подтверждает успех.';

  @override
  String get rel_ops_host_receipt_partial =>
      'Обновление применено, но ещё требуются дополнительные действия.';

  @override
  String get rel_ops_host_receipt_failed =>
      'Отчёт об обновлении указывает на сбой.';

  @override
  String get rel_ops_host_receipt_refused =>
      'Отчёт об обновлении указывает на отказ.';

  @override
  String get rel_ops_host_update_running => 'Обновление ещё выполняется.';

  @override
  String get rel_ops_host_update_unknown =>
      'Результат обновления неизвестен. Работающий шлюз не означает успешного обновления.';

  @override
  String get rel_ops_host_default_profile => 'профиль шлюза по умолчанию';

  @override
  String get rel_ops_host_restart => 'Перезапустить удалённый шлюз';

  @override
  String rel_ops_host_restart_shared_confirmation(String profiles) {
    return 'Это перезапустит шлюз, общий для $profiles. Выполняемые на этом шлюзе ходы будут прерваны. Затем подключитесь заново. Доступность не доказывает, что перезапуск завершён.';
  }

  @override
  String rel_ops_host_restart_confirmation(String profile) {
    return 'Это перезапустит удалённый шлюз для $profile. Выполняемые на этом шлюзе ходы будут прерваны. Затем подключитесь заново.';
  }

  @override
  String get rel_ops_host_restart_running =>
      'Команда перезапуска ещё выполняется.';

  @override
  String get rel_ops_host_restart_finished =>
      'Команда перезапуска завершена. Подключитесь к хосту заново вручную.';

  @override
  String get rel_ops_host_restart_failed =>
      'Команда перезапуска завершилась с ошибкой.';

  @override
  String rel_ops_host_maintenance_running(String name) {
    return '$name ещё выполняется';
  }

  @override
  String rel_ops_host_maintenance_finished(String name) {
    return '$name: выполнение завершено';
  }

  @override
  String rel_ops_host_maintenance_failed(String name) {
    return '$name: сбой выполнения';
  }

  @override
  String get rel_ops_host_curator_paused_result => 'Куратор приостановлен.';

  @override
  String get rel_ops_host_curator_resumed_result =>
      'Работа Куратора возобновлена.';

  @override
  String get rel_ops_host_reset => 'Сбросить удалённые файлы памяти';

  @override
  String rel_ops_host_reset_confirmation(String targetName, String profile) {
    return 'Удалить файл памяти $targetName в $profile? Это действие нельзя отменить из Ares.';
  }

  @override
  String rel_ops_host_reset_result(String targetName, int count) {
    return 'Выполнен сброс $targetName. Удалено файлов на удалённом хосте: $count.';
  }

  @override
  String get rel_ops_host_share_not_redacted =>
      'Хост не подтвердил удаление конфиденциальных данных из пакета. Ссылка не отображается.';

  @override
  String rel_ops_host_scope(String connection, String profile) {
    return 'Эти элементы управления действуют на удалённый шлюз $connection для $profile, а не на это устройство и не на обновление клиента Ares.';
  }

  @override
  String rel_ops_host_health_running(String version, int count) {
    return 'Процесс шлюза работает $version · Сеансов: $count';
  }

  @override
  String rel_ops_host_health_stopped(String version, int count) {
    return 'Процесс шлюза остановлен $version · Сеансов: $count';
  }

  @override
  String rel_ops_host_heartbeat_stale(num seconds) {
    return 'Сигнал активности хоста устарел ($seconds с).';
  }

  @override
  String get rel_ops_host_doctor => 'Запустить Doctor';

  @override
  String get rel_ops_host_security_audit => 'Аудит безопасности';

  @override
  String get rel_ops_host_check_receipt => 'Проверить отчёт об обновлении';

  @override
  String get rel_ops_host_logs => 'Журналы удалённого хоста';

  @override
  String get rel_ops_host_search_logs => 'Поиск в журналах хоста';

  @override
  String get rel_ops_host_driver => 'Драйвер удалённого хоста';

  @override
  String get rel_ops_host_driver_scope =>
      'Готовность управления компьютером определяется драйвером и разрешениями ОС на машине шлюза, а не на этом устройстве.';

  @override
  String rel_ops_host_computer_status(
    String platform,
    String installed,
    String ready,
  ) {
    return '$platform · установлен: $installed · готов: $ready';
  }

  @override
  String get rel_ops_host_null => 'нет данных';

  @override
  String get rel_ops_host_true => 'да';

  @override
  String get rel_ops_host_false => 'нет';

  @override
  String get rel_ops_host_curator => 'Куратор';

  @override
  String get rel_ops_host_curator_paused => 'Куратор приостановлен';

  @override
  String get rel_ops_host_curator_running => 'Куратор работает';

  @override
  String get rel_ops_host_no_run => 'Нет завершённых запусков';

  @override
  String get rel_ops_host_run_curator => 'Запустить Куратора сейчас';

  @override
  String get rel_ops_host_reset_memory => 'Сбросить файл памяти';

  @override
  String get rel_ops_host_reset_user => 'Сбросить файл пользователя';

  @override
  String get rel_ops_host_reset_both => 'Сбросить оба файла';

  @override
  String get rel_ops_host_share_consent =>
      'Я соглашаюсь загрузить диагностический пакет с удалённого хоста с удалёнными конфиденциальными данными';

  @override
  String get rel_ops_host_share =>
      'Поделиться диагностикой без конфиденциальных данных';

  @override
  String get rel_ops_host_update_unknown_installation =>
      'Эта установка неизвестна, поэтому запрос на обновление не был отправлен';

  @override
  String get rel_ops_host_update_busy_installation =>
      'На этой установке выполняется чат';

  @override
  String get rel_ops_host_update_refused => 'Удалённое обновление отклонено';

  @override
  String get rel_ops_host_error_stale => 'Удалённая рабочая область: устарела';

  @override
  String get rel_ops_host_error_mismatch =>
      'Удалённая рабочая область: несоответствие';

  @override
  String get rel_ops_host_error_unbound =>
      'Удалённая рабочая область: не привязана';

  @override
  String get rel_ops_host_error_unsupported =>
      'Удалённая рабочая область: не поддерживается';

  @override
  String get rel_ops_host_error_denied =>
      'Удалённая рабочая область: доступ запрещён';

  @override
  String get rel_ops_host_error_ineligible =>
      'Удалённая рабочая область: не подходит для операции';

  @override
  String get rel_ops_host_error_unavailable =>
      'Удалённая рабочая область: недоступна';

  @override
  String get rel_ops_host_error_invalid =>
      'Удалённая рабочая область: недопустимые данные';

  @override
  String get rel_ops_host_error_insecure =>
      'Удалённая рабочая область: небезопасное соединение';

  @override
  String get rel_ops_host_error_request => 'Не удалось выполнить запрос.';

  @override
  String get rel_svc_push_api_select_sessions =>
      'Выберите от 1 до 128 постоянных идентификаторов сеансов длиной 1–200 символов ASCII. Допустимы только буквы, цифры, _ . : @ и -. Удалите пустые идентификаторы и пробелы.';

  @override
  String get rel_svc_push_api_unavailable =>
      'Мобильные push-уведомления недоступны на этом сервере.';

  @override
  String get rel_svc_push_api_invalid_vapid =>
      'Недопустимый открытый ключ VAPID сервера.';

  @override
  String get rel_svc_push_api_update_plugin =>
      'Для автоматических подписок на этом сервере требуется обновлённый плагин mobile-push.';

  @override
  String get rel_svc_push_status_android_only => 'Только Android';

  @override
  String get rel_svc_push_native_prefs_sync_failed =>
      'Не удалось синхронизировать системные настройки уведомлений.';

  @override
  String get rel_svc_push_choose_android_connection =>
      'Сначала выберите сохранённое подключение на Android.';

  @override
  String get rel_svc_push_status_checking_authorization =>
      'Проверка авторизации сервера';

  @override
  String get rel_svc_push_revoke_persist_failed =>
      'Не удалось сохранить отзыв. Перед выходом из приложения ещё раз попробуйте отключить функцию.';

  @override
  String get rel_svc_push_status_off_api_ready =>
      'Отключено; API сервера готов';

  @override
  String get rel_svc_push_status_off_revoke_pending =>
      'Отключено; отзыв на сервере ожидается';

  @override
  String get rel_svc_push_status_off_connection_changed =>
      'Отключено; сохранённое подключение изменено';

  @override
  String get rel_svc_push_status_pending_endpoint =>
      'Ожидание конечной точки распространителя';

  @override
  String get rel_svc_push_status_registering => 'Регистрация';

  @override
  String get rel_svc_push_status_pending_challenge =>
      'Ожидается зашифрованная проверка (ожидание тихого push-сообщения для проверки сервера)';

  @override
  String get rel_svc_push_allow_android_notifications_retry =>
      'Разрешите уведомления Android в настройках системы и повторите попытку.';

  @override
  String get rel_svc_push_plugin_invalid =>
      'Плагин mobile-push на сервере недоступен, устарел или вернул недопустимый ответ подписки. Попросите оператора обновить его и повторите попытку.';

  @override
  String get rel_svc_push_transport_unavailable =>
      'Нет доступного транспорта push. Для встроенной доставки нужны работающие сервисы Google Play; либо установите распространитель UnifiedPush и повторите попытку.';

  @override
  String get rel_svc_push_transport_choice =>
      'Доступно несколько распространителей UnifiedPush. Выберите один в разделе «Расширенный транспорт» и повторите попытку.';

  @override
  String get rel_svc_push_transport_missing =>
      'Выбранный распространитель UnifiedPush недоступен. Восстановите его или выберите другой в разделе «Расширенный транспорт».';

  @override
  String get rel_svc_push_companion_unavailable =>
      'Серверный компонент mobile-push недоступен. Он может отсутствовать, быть отключён или подключение может указывать не на ту панель. Установите или включите компонент на сервере, проверьте подключение панели и обновите. См. руководство по настройке сервера выше.';

  @override
  String get rel_svc_push_server_denied =>
      'Сервер отклонил мобильные push-уведомления. Попросите оператора авторизовать этого субъекта и эти сеансы.';

  @override
  String get rel_svc_push_not_ready =>
      'Мобильные push-уведомления не готовы. Проверьте авторизацию серверного плагина, распространитель и сеть, затем повторите попытку.';

  @override
  String get rel_svc_push_availability_read_failed =>
      'Не удалось проверить доступность push на Android. Повторите попытку ниже.';

  @override
  String get rel_svc_push_setup_failed =>
      'Не удалось настроить push. Проверьте разрешение Android, авторизацию сервера и транспорт, затем повторите попытку.';

  @override
  String rel_svc_push_status(String status) {
    return 'Состояние: $status';
  }

  @override
  String rel_svc_push_status_bound(
    String bound,
    String connection,
    String status,
  ) {
    return 'Состояние: привязано к $bound (не активно для $connection; согласование: $status)';
  }

  @override
  String get rel_svc_push_another_saved_connection =>
      'другое сохранённое подключение';

  @override
  String get rel_svc_push_background_notifications => 'Фоновые уведомления';

  @override
  String rel_svc_push_bound_subtitle(String bound, String connection) {
    return 'Привязано к $bound — отзовите эту привязку ниже, прежде чем включать для $connection';
  }

  @override
  String rel_svc_push_private_activity(String connection) {
    return 'Частная активность сервера для $connection';
  }

  @override
  String rel_svc_push_bound_warning_named(String bound) {
    return 'Привязано к другому сохранённому подключению ($bound). Отключите и отзовите эту привязку, прежде чем включать для данного подключения.';
  }

  @override
  String get rel_svc_push_bound_warning =>
      'Привязано к другому сохранённому подключению. Отключите и отзовите эту привязку, прежде чем включать для данного подключения.';

  @override
  String get rel_svc_push_local_notifications_muted =>
      'Локальные уведомления отключены выше. Согласие на фоновые уведомления не изменено, но обычные подсказки активности заглушены до включения «Включить уведомления».';

  @override
  String rel_svc_push_legacy_subscription(int count) {
    return 'Устаревшая подписка: только $count выбранных сеансов. Она не расширится автоматически. Выключите и включите её, чтобы согласиться на авторизованные сервером сеансы.';
  }

  @override
  String get rel_svc_push_authorized_binding =>
      'Привязано только к этому сохранённому подключению и профилю. Доступ к сеансам определяется текущей авторизацией сервера.';

  @override
  String get rel_svc_push_revocation_pending =>
      'Ожидается отзыв на сервере. Локальная доставка отключена; повторите попытку, пока доступна исходная сохранённая учётная запись.';

  @override
  String get rel_svc_push_refresh_retry => 'Обновить / повторить';

  @override
  String rel_svc_push_disable_named(String bound) {
    return 'Отключить и отозвать $bound';
  }

  @override
  String get rel_svc_push_other_connection => 'другое подключение';

  @override
  String get rel_svc_push_disable => 'Отключить и отозвать';

  @override
  String get rel_svc_push_refresh_explanation =>
      '«Обновить / повторить» снова проверяет доступность после настройки сервера, но не устанавливает компонент. Включение уведомлений остаётся отдельным выбором.';

  @override
  String get rel_svc_push_companion_required =>
      'Для фоновых уведомлений нужен отдельно установленный и включённый серверный компонент mobile-push. Android не может его установить. Обновление одного APK не настраивает сервер.';

  @override
  String get rel_svc_push_server_setup_guide =>
      'Руководство по настройке сервера';

  @override
  String get rel_svc_push_enable_disclosure =>
      'Включите, чтобы запросить разрешение Android на уведомления и передать этому серверу конечную точку и ключи шифрования этой установки. Зашифрованные подсказки активности не содержат содержимого чатов. Включаются только сеансы, разрешённые вашей серверной учётной записью.';

  @override
  String get rel_svc_push_transport_disclosure =>
      'Встроенная доставка использует push-транспорт Google и сервисы Google Play, но не содержит Firebase SDK. Вместо неё можно использовать распространитель UnifiedPush. Доставка выполняется по возможности; откройте Hermes снова для сверки.';

  @override
  String get rel_svc_push_advanced_transport => 'Расширенный транспорт';

  @override
  String get rel_svc_push_automatic_explanation =>
      'Автовыбор сохраняет выбранный распространитель, иначе использует встроенную доставку Google, если она доступна. Перед сменой транспорта отключите функцию.';

  @override
  String get rel_svc_push_transport_label => 'Push-транспорт';

  @override
  String get rel_svc_push_automatic_recommended =>
      'Автоматически (рекомендуется)';

  @override
  String get rel_svc_push_selected_unavailable =>
      'Выбранный распространитель (недоступен)';

  @override
  String get rel_svc_push_no_transport_detected =>
      'Доступный транспорт не найден. Для встроенной доставки нужны сервисы Google Play; без них установите и настройте распространитель UnifiedPush, затем обновите.';

  @override
  String get rel_svc_push_channel_turns_name => 'Ходы Ares';

  @override
  String get rel_svc_push_channel_turns_description =>
      'Уведомления о завершённых фоновых ходах';

  @override
  String get rel_svc_push_channel_attention_name => 'Внимание Ares';

  @override
  String get rel_svc_push_channel_attention_description =>
      'Запросы на одобрение и ввод, требующие вашего участия';

  @override
  String get rel_svc_push_channel_background_name => 'Ares в фоне';

  @override
  String get rel_svc_push_channel_background_description =>
      'Завершение фоновых задач';

  @override
  String get rel_svc_push_channel_notices_name => 'Извещения Ares';

  @override
  String get rel_svc_push_channel_notices_description =>
      'Извещения о кредитах и плагинах';

  @override
  String get rel_svc_push_diag_not_initialised => 'не инициализировано';

  @override
  String get rel_svc_push_diag_replies_off =>
      'уведомления об ответах отключены';

  @override
  String get rel_svc_push_diag_conversation => 'разговор';

  @override
  String get rel_svc_push_diag_conversation_permission_denied =>
      'разговор; разрешение отклонено';

  @override
  String rel_svc_push_diag_conversation_error(String error) {
    return 'разговор: $error';
  }

  @override
  String get rel_svc_push_diag_failures_off =>
      'уведомления об ошибках отключены';

  @override
  String rel_svc_push_diag_kind_off(String kind) {
    return '$kind отключено';
  }

  @override
  String get rel_svc_push_diag_windows_setting_unknown =>
      'Windows не сообщил настройку уведомлений';

  @override
  String get rel_svc_backup_not_hermes_configuration_backup =>
      'Этот файл не является резервной копией конфигурации Hermes.';

  @override
  String get rel_svc_backup_newer_version_cannot_import =>
      'Эта резервная копия создана более новой версией приложения и не может быть импортирована.';

  @override
  String get rel_svc_backup_missing_client_certificate =>
      'В резервной копии заявлен клиентский сертификат для подключения, но самого сертификата нет, поэтому полное восстановление невозможно.';

  @override
  String get rel_svc_backup_damaged_unreadable =>
      'Файл резервной копии повреждён, и его не удалось прочитать.';

  @override
  String get rel_svc_backup_unsupported_preference_type =>
      'Сохранённая настройка имеет неподдерживаемый тип и не может быть экспортирована.';

  @override
  String get rel_svc_backup_choose_passphrase_api_keys =>
      'Выберите парольную фразу — резервная копия содержит ваши ключи API.';

  @override
  String get rel_svc_backup_could_not_protect_safely =>
      'Не удалось безопасно защитить резервную копию.';

  @override
  String get rel_svc_backup_unsupported_encryption =>
      'В этой резервной копии используется неподдерживаемая схема шифрования.';

  @override
  String get rel_svc_backup_wrong_passphrase_or_altered =>
      'Неверная парольная фраза или файл резервной копии был изменён.';

  @override
  String get rel_svc_backup_share_subject =>
      'Резервная копия конфигурации Hermes';

  @override
  String get rel_svc_backup_selected_file_unreadable =>
      'Не удалось прочитать этот файл.';

  @override
  String rel_svc_backup_connections_added(int count) {
    return 'добавлено: $count';
  }

  @override
  String rel_svc_backup_connections_updated(int count) {
    return 'обновлено: $count';
  }

  @override
  String rel_svc_backup_connections_removed(int count) {
    return 'удалено: $count';
  }

  @override
  String get rel_svc_backup_no_connection_changes => 'Подключения не изменены';

  @override
  String rel_svc_backup_connections_summary(String changes) {
    return 'Подключения: $changes';
  }

  @override
  String rel_svc_backup_restore_summary(String connections, int count) {
    return '$connections · восстановлено настроек: $count';
  }

  @override
  String rel_svc_backup_certificate_not_included(String label, String error) {
    return 'Не удалось включить клиентский сертификат для «$label» в эту резервную копию: $error';
  }

  @override
  String get rel_svc_backup_certificate_password_needed =>
      'Для этого сертификата нужен пароль. Введите его ниже, и сертификат откроется автоматически.';

  @override
  String get rel_svc_backup_certificate_password_or_corrupt =>
      'Пароль сертификата неверен или файл повреждён.';

  @override
  String get rel_svc_backup_certificate_password_incorrect =>
      'Пароль сертификата неверен.';

  @override
  String get rel_svc_backup_certificate_unsupported_encryption =>
      'В этом сертификате используется метод шифрования, который приложение не может прочитать.';

  @override
  String get rel_svc_backup_certificate_unreadable_pkcs12 =>
      'Выбранный файл не является читаемым сертификатом PKCS#12 (.p12/.pfx).';

  @override
  String get rel_svc_backup_certificate_unreadable =>
      'Не удалось прочитать выбранный сертификат.';

  @override
  String get rel_svc_backup_not_certificate_file =>
      'Этот файл не является сертификатом: выберите контейнер .p12/.pfx либо файлы сертификата и ключа PEM.';

  @override
  String get rel_svc_backup_not_pem_certificate =>
      'Выбранный сертификат не является сертификатом PEM.';

  @override
  String get rel_svc_backup_not_pem_private_key =>
      'Выбранный закрытый ключ не является закрытым ключом PEM.';

  @override
  String get rel_svc_backup_certificate_pair_unloadable =>
      'Не удалось загрузить выбранные сертификат и закрытый ключ.';

  @override
  String get rel_svc_backup_saved_certificate_files_unreadable =>
      'Не удалось прочитать сохранённые файлы клиентского сертификата.';

  @override
  String get rel_svc_backup_client_certificate_storage_failed =>
      'Не удалось безопасно сохранить клиентский сертификат на этом устройстве.';

  @override
  String get rel_svc_backup_certificate_storage_failed =>
      'Не удалось безопасно сохранить сертификат на этом устройстве.';

  @override
  String get rel_svc_backup_client_certificate_label => 'Клиентский сертификат';

  @override
  String rel_svc_backup_search_dashboard_unreachable(String error) {
    return 'Не удалось подключиться к панели управления: $error';
  }

  @override
  String get rel_svc_backup_search_credentials_rejected =>
      'Панель управления отклонила сохранённые учётные данные. Проверьте имя пользователя и пароль панели для этого подключения.';

  @override
  String get rel_svc_backup_search_not_supported =>
      'Эта панель не поддерживает поиск сеансов. Обновите Hermes на хосте или вернитесь к поиску на устройстве.';

  @override
  String rel_svc_backup_search_redirected(int statusCode) {
    return 'Панель перенаправила поиск сеансов (HTTP $statusCode). Ares не следует перенаправлениям с сохранёнными учётными данными; проверьте адрес подключения.';
  }

  @override
  String rel_svc_backup_search_http_failed(int statusCode) {
    return 'Поиск сеансов завершился ошибкой HTTP $statusCode.';
  }

  @override
  String get rel_svc_backup_search_malformed_response =>
      'Панель вернула некорректный ответ поиска.';

  @override
  String get rel_svc_backup_search_unexpected_response =>
      'Панель вернула неожиданный ответ поиска.';

  @override
  String get rel_svc_backup_search_too_many_results =>
      'Панель вернула больше результатов поиска, чем запрошено.';

  @override
  String get rel_svc_backup_message_search_unexpected_response =>
      'Неожиданный ответ поиска сообщений.';

  @override
  String get rel_svc_backup_message_search_unexpected_result =>
      'Неожиданный результат поиска сообщений.';

  @override
  String get rel_svc_backup_ai_search_api_key_rejected =>
      'API Hermes отклонил сохранённый ключ API.';

  @override
  String rel_svc_backup_ai_search_http_failed(int statusCode) {
    return 'Переформулирование запроса с помощью ИИ завершилось ошибкой HTTP $statusCode.';
  }

  @override
  String get rel_svc_backup_ai_search_no_usable_query =>
      'Выбранная модель не вернула пригодный поисковый запрос.';

  @override
  String get rel_svc_backup_ai_search_malformed_response =>
      'Hermes вернул некорректный ответ переформулирования с помощью ИИ.';

  @override
  String get rel_svc_backup_space_name_already_exists =>
      'Пространство с таким названием уже существует';

  @override
  String get rel_svc_backup_space_name_length_invalid =>
      'Название пространства должно содержать от 1 до 80 символов';

  @override
  String get ng_rel_svc_backup_gateway_address_required =>
      'Введите адрес панели управления Hermes.';

  @override
  String ng_rel_svc_backup_gateway_address_scheme(String scheme) {
    return 'Адрес должен начинаться с http:// или https:// (получено: $scheme).';
  }

  @override
  String get ng_rel_svc_backup_gateway_address_invalid =>
      'Этот адрес недействителен.';

  @override
  String get ng_rel_svc_backup_gateway_address_no_host =>
      'В адресе отсутствует имя хоста.';

  @override
  String get ng_rel_svc_backup_sign_in_main_window =>
      'Войдите в систему в главном окне.';

  @override
  String get rel_svc_backup_sign_in_renewal_failed =>
      'Шлюз сейчас не смог обновить вход.';

  @override
  String get rel_svc_backup_sign_in_provider_unreachable =>
      'Шлюз не смог обновить вход: поставщик входа недоступен.';

  @override
  String get rel_svc_backup_sign_in_renewal_timed_out =>
      'Истекло время ожидания обновления входа.';

  @override
  String get rel_svc_backup_sign_in_no_tokens => 'Шлюз не вернул токены входа.';

  @override
  String get ng_rel_svc_backup_probe_timed_out =>
      'Время ожидания истекло. Проверьте адрес, VPN или подключение Tailscale.';

  @override
  String ng_rel_svc_backup_probe_tls_failed(String error) {
    return 'Ошибка рукопожатия TLS: $error';
  }

  @override
  String ng_rel_svc_backup_gateway_answered_http(int statusCode) {
    return 'Шлюз ответил кодом HTTP $statusCode.';
  }

  @override
  String get ng_rel_svc_backup_gateway_answer_timed_out =>
      'Шлюз слишком долго не отвечал.';

  @override
  String ng_rel_svc_backup_browser_callback_not_ready(String error) {
    return 'Не удалось подготовиться к возврату из браузера: $error';
  }

  @override
  String get ng_rel_svc_backup_browser_signed_in_body =>
      'Теперь можно вернуться в Hermes.';

  @override
  String get ng_rel_svc_backup_browser_waiting_title => 'Ожидание входа';

  @override
  String get ng_rel_svc_backup_browser_not_current =>
      'Эта страница не относится к текущему входу.';

  @override
  String get ng_rel_svc_backup_browser_open_failed =>
      'Не удалось открыть браузер для входа.';

  @override
  String get ng_rel_svc_backup_browser_sign_in_timed_out =>
      'Вход занял слишком много времени. Повторите попытку.';

  @override
  String ng_rel_svc_backup_gateway_refused_sign_in(int statusCode) {
    return 'Шлюз отклонил вход (HTTP $statusCode).';
  }

  @override
  String get rel_svc_misc_alert_caution => 'Осторожно';

  @override
  String get rel_svc_misc_alert_important => 'Важно';

  @override
  String get rel_svc_misc_alert_tip => 'Совет';

  @override
  String get rel_svc_misc_alert_warning => 'Предупреждение';

  @override
  String get rel_svc_misc_allow_folder_session =>
      'Разрешить эту папку до завершения сеанса.';

  @override
  String get rel_svc_misc_allow_website_session =>
      'Разрешить этот сайт до завершения сеанса.';

  @override
  String rel_svc_misc_approval_needed_title(String title) {
    return 'Требуется подтверждение — $title';
  }

  @override
  String get rel_svc_misc_attach_file_reference => 'Прикрепить ссылку на файл';

  @override
  String get rel_svc_misc_attach_folder_reference =>
      'Прикрепить ссылку на папку';

  @override
  String get rel_svc_misc_attach_git_context => 'Прикрепить контекст git';

  @override
  String get rel_svc_misc_attach_image_reference =>
      'Прикрепить ссылку на изображение';

  @override
  String get rel_svc_misc_attach_staged_diff =>
      'Прикрепить индексированные изменения';

  @override
  String get rel_svc_misc_attach_tool_reference =>
      'Прикрепить ссылку на инструмент';

  @override
  String get rel_svc_misc_attach_unstaged_diff =>
      'Прикрепить неиндексированные изменения';

  @override
  String get rel_svc_misc_attach_url_reference => 'Прикрепить ссылку URL';

  @override
  String get rel_svc_misc_background_task_completed =>
      'Фоновая задача завершена';

  @override
  String rel_svc_misc_background_task_named_completed(String taskId) {
    return 'Фоновая задача $taskId завершена';
  }

  @override
  String get rel_svc_misc_chat => 'Чат';

  @override
  String get rel_svc_misc_compacting_context => 'Сжатие контекста разговора…';

  @override
  String rel_svc_misc_completed_in(String duration) {
    return 'Завершено за $duration';
  }

  @override
  String get rel_svc_misc_context_compacted => 'Контекст разговора сжат';

  @override
  String get rel_svc_misc_cron_readback_mismatch =>
      'Повторно прочитанная модель Cron не совпала';

  @override
  String get rel_svc_misc_cron_update_rejected => 'Обновление Cron отклонено';

  @override
  String get rel_svc_misc_deny_folder_grant =>
      'Не предоставлять доступ к этой папке.';

  @override
  String get rel_svc_misc_deny_website_grant =>
      'Не предоставлять доступ к этому сайту.';

  @override
  String rel_svc_misc_failed_after(String duration) {
    return 'Ошибка через $duration';
  }

  @override
  String get rel_svc_misc_gateway_folder_unnamed => 'Шлюз не указал папку.';

  @override
  String get rel_svc_misc_gateway_idle_unconfirmed =>
      'Шлюз бездействует. Не удалось подтвердить результат предыдущего хода.';

  @override
  String get rel_svc_misc_gateway_turn_failed => 'Сбой хода шлюза';

  @override
  String rel_svc_misc_gateway_turn_status(String status) {
    return 'Ход шлюза: $status';
  }

  @override
  String get rel_svc_misc_gateway_website_unnamed => 'Шлюз не указал сайт.';

  @override
  String get rel_svc_misc_hermes_review => 'Проверка Hermes';

  @override
  String get rel_svc_misc_hermes_turn_failed => 'Сбой хода Hermes';

  @override
  String get rel_svc_misc_image_recovery_companion_gap =>
      'Восстановление изображений и текста недоступно при сопутствующем восстановлении. Неподтверждённую отправку изображения нельзя восстановить в этом соединении, и ничего не отправляется повторно автоматически.';

  @override
  String get rel_svc_misc_image_recovery_rest_gap =>
      'Восстановление изображений и текста недоступно в Classic REST/SSE. Неподтверждённую отправку изображения нельзя восстановить в этом соединении, и ничего не отправляется повторно автоматически.';

  @override
  String rel_svc_misc_input_needed_title(String title) {
    return 'Требуется ввод — $title';
  }

  @override
  String get rel_svc_misc_parallel_workspace_connection_changed =>
      'Подключение изменилось. Откройте его снова, чтобы использовать рабочее пространство.';

  @override
  String get rel_svc_misc_preparing => 'Подготовка';

  @override
  String get rel_svc_misc_save_folder_grant =>
      'Сохранить это разрешение для папки для последующих запросов.';

  @override
  String get rel_svc_misc_save_website_grant =>
      'Сохранить это разрешение для сайта для последующих запросов.';

  @override
  String get rel_svc_misc_stored_identity_turn_conflict =>
      'Этот чат был открыт по сохранённому идентификатору, когда уже был принят другой ход. Неотправленный запрос не был отправлен; явно повторите попытку после завершения того хода.';

  @override
  String get rel_svc_misc_untitled => 'Без названия';

  @override
  String get rel_svc_misc_wake_capture_silent =>
      'Клиентская запись активации слышит только тишину — проверьте доступ ОС к микрофону и снова включите ключевую фразу.';

  @override
  String get rel_svc_misc_wake_capture_stalled =>
      'Клиентская запись активации остановилась: обратные вызовы аудио с микрофона не поступили.';

  @override
  String rel_svc_misc_wake_feed_refused(int count, String detail) {
    return 'Поток ключевой фразы отклонил $count последовательных кадров$detail — снова включите ключевую фразу.';
  }

  @override
  String rel_svc_misc_wake_microphone_failed(String error) {
    return 'Сбой клиентского потока микрофона активации: $error';
  }

  @override
  String get rel_svc_misc_wake_track_ended =>
      'Дорожка микрофона завершилась во время записи ключевой фразы — снова включите ключевую фразу.';

  @override
  String get rel_svc_misc_website => 'Сайт';

  @override
  String get rel_svc_lan_timeout => 'Время поиска в локальной сети истекло';

  @override
  String get rel_svc_notification_permission_denied => 'разрешение отклонено';

  @override
  String get rel_svc_notifications_off => 'уведомления отключены';

  @override
  String rel_chat_preview_pin_label(int number, String note) {
    return '№$number $note';
  }

  @override
  String rel_chat_preview_pin_number(int number) {
    return '№$number';
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
  String get fleet_managed_ssh_title => 'SSH под управлением шлюза';

  @override
  String get fleet_managed_ssh_intro =>
      'Управляйте SSH-хостами, уже сохранёнными на этом шлюзе, с любого устройства. На удалённом хосте уже должен быть установлен Hermes. Эта операция запускает удалённый сервис, принадлежащий шлюзу, или подключается к нему, а не создаёт подключение к чату Ares. Управляемые обновления и восстановление доступны только в нативном настольном приложении.';

  @override
  String get fleet_managed_ssh_read => 'Прочитать сохранённые SSH-хосты';

  @override
  String get fleet_managed_ssh_trust =>
      'При этом первом подключении шлюз доверится SSH-ключу этого хоста и запомнит его. Последующее изменение ключа будет обнаружено, а подключение заблокировано. Шлюз не сообщает отпечаток ключа, поэтому Ares не может его отобразить или сохранить. Продолжайте, только если доверяете этому первому подключению.';

  @override
  String get fleet_managed_ssh_changed =>
      'SSH-ключ этого хоста изменился. Подключение заблокировано. Человек с доступом к хосту шлюза должен независимо проверить отпечаток нового ключа и удалить там старый доверенный ключ. Повторяйте попытку только после этой проверки и исправления. Ares не заменяет доверенный ключ.';

  @override
  String get fleet_managed_ssh_disconnect_warning =>
      'Отключить SSH-туннель и остановить удалённый сервис, принадлежащий этому шлюзу? Это может прервать работу других клиентов, использующих этот сервис.';

  @override
  String get fleet_managed_ssh_verify =>
      'Вместо этого проверить ключ самостоятельно';

  @override
  String fleet_managed_ssh_pending(int seconds) {
    return 'Ожидание шлюза: $seconds с. Уход с этой страницы не отменяет начальную настройку. Если запрос завершится ошибкой, проверьте состояние перед повторной попыткой.';
  }

  @override
  String fleet_managed_ssh_status(
    String host,
    int localPort,
    int remotePort,
    String version,
    String reused,
  ) {
    return 'Хост: $host\nПорт петлевого интерфейса шлюза: $localPort\nПорт удалённого петлевого интерфейса: $remotePort\nHermes: $version\nПовторное использование: $reused';
  }

  @override
  String get fleet_managed_ssh_disconnect => 'Отключить';

  @override
  String get ng_slash_suggestions_loading => 'Загрузка команд…';

  @override
  String get ng_slash_suggestions_empty => 'Нет подходящих команд';

  @override
  String get ng_slash_suggestions_label => 'Предлагаемые команды';

  @override
  String get ng_slash_suggestions_skill => 'Навык';

  @override
  String get settings_classic_title => 'Настройки Classic';

  @override
  String get settings_nextgen_title => 'Настройки NextGen';

  @override
  String get settings_category_general => 'Общие настройки и язык';

  @override
  String get settings_category_chat => 'Чаты и сеансы';

  @override
  String get settings_category_device => 'Устройство и сочетания клавиш';

  @override
  String get settings_category_connections => 'Подключения и модели';

  @override
  String get settings_category_security =>
      'Конфиденциальность и резервные копии';

  @override
  String get settings_category_about => 'О приложении и справка';

  @override
  String get settings_reopen_chat =>
      'Восстанавливать последний чат при возврате к шлюзу';

  @override
  String get settings_reopen_chat_hint =>
      'При холодном запуске открывается экран приветствия. Ссылки и уведомления открывают запрошенный чат.';

  @override
  String get settings_danger => 'Опасные действия';
}
