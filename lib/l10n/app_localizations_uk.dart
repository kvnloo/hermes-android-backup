// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get attachment_audio_failed =>
      'Не вдалося відтворити аудіо. Можливо, формат або кодек не підтримується чи перевищено розмір попереднього перегляду. Спробуйте ще раз, збережіть оригінальний файл або поділіться ним.';

  @override
  String get attachment_audio_seek => 'Позиція аудіо';

  @override
  String get workspace_workers => 'Активні субагенти';

  @override
  String get workers_unattached =>
      'Показано лише кількість. Щоб дати вказівку, виберіть «Активні субагенти» в підключеному батьківському чаті.';

  @override
  String get slash_local_arguments =>
      'Цей ярлик тут не підтримує аргументи. Скористайтеся елементами керування застосунку; чернетку збережено.';

  @override
  String get fallback_title => 'Резервні моделі';

  @override
  String get fallback_notice =>
      'Використовуються по черзі, коли основна модель недоступна. Зміни застосовуються лише до цього профілю; збережіть повний список явно.';

  @override
  String get fallback_unavailable =>
      'Параметри резерву недоступні або недійсні. Перевірте з’єднання, вибраний профіль і версію хоста, потім повторіть спробу.';

  @override
  String get fallback_discovery_unavailable =>
      'Виявлення провайдерів недоступне. Наявні записи збережено; повторіть спробу, щоб вибрати провайдерів і моделі.';

  @override
  String get fallback_empty => 'У цьому списку резерву немає записів.';

  @override
  String get fallback_incomplete =>
      'Виберіть провайдера і модель для кожного запису або видаліть незавершені записи перед збереженням.';

  @override
  String get fallback_add => 'Додати резерв';

  @override
  String get fallback_save => 'Зберегти список резерву';

  @override
  String get fallback_save_failed =>
      'Не вдалося перевірити збережений список резерву. Ваш чернетку збережено. Повторіть спробу збереження або оновіть, щоб перезавантажити параметри хоста.';

  @override
  String get fallback_saved => 'Список резерву збережено і перевірено.';

  @override
  String get fallback_legacy_title => 'Застарілі резерви (лише для читання)';

  @override
  String get fallback_legacy_notice =>
      'Хост також використовує fallback_model після цього списку, пропускаючи дублікати маршрутів. Ці застарілі записи зберігаються, навіть коли список вище порожній. Редагуйте їх на хості.';

  @override
  String fallback_priority(String position) {
    return 'Пріоритет $position';
  }

  @override
  String get fallback_move_up => 'Перемістити вгору';

  @override
  String get fallback_move_down => 'Перемістити вниз';

  @override
  String get fallback_routing_read_only =>
      'Деталі маршрутизації або неперерахований провайдер зберігаються. Редагуйте цього провайдера/модель на хості; ви все ще можете перевпорядкувати або видалити запис.';

  @override
  String get cron_model_default => 'За замовчуванням';

  @override
  String get cron_model_notice =>
      'Лише для цього завдання за розкладом. Без закріпленої моделі Hermes використовує типову модель розкладу, а потім основну. Власними моделями керуйте на сервері.';

  @override
  String get model_management_unavailable =>
      'Не вдалося завантажити або зберегти налаштування моделей. Оновіть і спробуйте ще раз.';

  @override
  String get model_management_subtitle =>
      'Основна та допоміжні моделі цього профілю';

  @override
  String get usage => 'Використання';

  @override
  String get nous_portal => 'Nous Portal';

  @override
  String get portal_menu_subtitle => 'Стан шлюзу й облік використання';

  @override
  String get portal_read_only =>
      'Дані шлюзу доступні лише для читання. Входом до Nous керуйте на сервері Hermes. Ці запити не надають залишок передплати чи кредитів.';

  @override
  String get portal_status => 'Стан порталу шлюзу';

  @override
  String get portal_free_tier =>
      'Безкоштовний доступ без входу в обліковий запис';

  @override
  String get portal_signed_in => 'Вхід виконано';

  @override
  String get portal_signed_out => 'Вхід не виконано';

  @override
  String get portal_account_tier => 'Рівень облікового запису';

  @override
  String get portal_recorded_usage => 'Облік використання';

  @override
  String get portal_all_providers =>
      'Усі провайдери вибраного профілю шлюзу. Нульова записана вартість не означає, що модель безкоштовна.';

  @override
  String portal_period(String days) {
    return 'Останні $days днів';
  }

  @override
  String get portal_sessions => 'Сесії';

  @override
  String get portal_input => 'Вхідні токени';

  @override
  String get portal_output => 'Вихідні токени';

  @override
  String get portal_estimated => 'Орієнтовна записана вартість';

  @override
  String get portal_actual => 'Фактична записана вартість';

  @override
  String get portal_recorded_models => 'Використані моделі';

  @override
  String get portal_no_models => 'Записів про моделі немає.';

  @override
  String get portal_unavailable =>
      'Недоступно. Перевірте підключення, вибраний профіль і версію шлюзу та повторіть спробу.';

  @override
  String get paste_attachment_failed_text_kept =>
      'Не вдалося додати вставлений текст як вкладення. Текст залишено в повідомленні.';

  @override
  String get background_task_report => 'Фонове завдання';

  @override
  String get background_process_report => 'Фоновий процес';

  @override
  String get background_report_issues =>
      'Виявлено проблеми — розгорніть подробиці.';

  @override
  String get background_report_expand => 'Розгорнути звіт';

  @override
  String get background_report_collapse => 'Згорнути звіт';

  @override
  String get ng_brand_open_chat => 'Відкрити чат';

  @override
  String get ng_brand_recent => 'Нещодавні';

  @override
  String get ng_brand_sidebar_hint => 'або виберіть чат на бічній панелі';

  @override
  String get copy_session_id => 'Копіювати ID сеансу';

  @override
  String get copy_session_id_failed => 'Не вдалося скопіювати ID сеансу.';

  @override
  String get setup_interface_title => 'Виберіть інтерфейс';

  @override
  String get setup_interface_classic => 'Classic';

  @override
  String get setup_interface_nextgen => 'NextGen';

  @override
  String get setup_interface_classic_description =>
      'Початковий робочий простір Ares з усіма елементами керування підключенням та налаштуваннями Classic.';

  @override
  String get setup_interface_nextgen_description =>
      'Новий вигляд з одним входом до панелі, планами в реальному часі, субагентами та сповіщеннями.';

  @override
  String get setup_interface_switch_later =>
      'Перемкнутися можна будь-коли в Налаштуваннях.';

  @override
  String get ng_confirm_model_switch => 'Змінити модель?';

  @override
  String get ng_switch => 'Змінити';

  @override
  String get ng_model_confirmation_required =>
      'Перед вибором цієї моделі потрібне підтвердження.';

  @override
  String ng_model_switches_next_turn(String model) {
    return 'Модель буде змінено на $model у наступному ході.';
  }

  @override
  String get ng_model_switch_not_connected =>
      'Чат ще не готовий до зміни моделі. Відкрийте його знову та повторіть спробу.';

  @override
  String ng_gateway_kept_default_model(String model) {
    return 'Шлюз залишив $model для цього чату. Виберіть модель ще раз перед надсиланням.';
  }

  @override
  String get hands_free_title => 'Голос без рук';

  @override
  String get hands_free_start => 'Увімкнути голос без рук';

  @override
  String get hands_free_stop => 'Вимкнути голос без рук';

  @override
  String get hands_free_preparing => 'Підготовка голосу — зачекайте сигналу';

  @override
  String get hands_free_listening => 'Скажіть Hey Hermes';

  @override
  String get hands_free_recording => 'Готово — говоріть';

  @override
  String get hands_free_waiting => 'Очікування Hermes';

  @override
  String get hands_free_speaking => 'Відтворення відповіді — мікрофон вимкнено';

  @override
  String hands_free_followup(int seconds) {
    return 'Слухати до $seconds секунд';
  }

  @override
  String get hands_free_error => 'Голос без рук зупинено';

  @override
  String get hands_free_setup => 'Налаштування голосу без рук';

  @override
  String hands_free_preview(String transcript) {
    return 'Розпізнаний текст: $transcript';
  }

  @override
  String get hands_free_short_disclosure =>
      'Лише поки цей чат відкритий на екрані. Активація працює локально; розпізнавання мовлення може використовувати мережу. Витрачає заряд.';

  @override
  String get hands_free_error_action =>
      'Перевірте дозвіл мікрофона, службу розпізнавання, голос відповідей і підключення. Для повторної спроби натисніть «Зупинити», а потім «Почати». Повторного надсилання немає.';

  @override
  String get hands_free_disclosure =>
      'Активація голосом працює локально на процесорі. Розпізнавання Android, вибраний голос відповіді та шлюз можуть використовувати мережу. Слухання витрачає заряд; можливі хибні спрацювання. Зупиняється, коли чат перекритий, закритий або застосунок у фоні; повторне відкриття не запускає його. Звичайне диктування залишається редагованою чернеткою.';

  @override
  String get hands_free_ready_cue =>
      'Скажіть «Hey Hermes», дочекайтеся «Готово — говоріть» і починайте. Початок фрази до сигналу не записується. Якщо для дозволів довелося вийти із застосунку, після повернення знову натисніть «Почати».';

  @override
  String get hands_free_settings_title => 'Голосове керування без рук';

  @override
  String get hands_free_settings_subtitle =>
      'Показувати кнопку запуску «Hey Hermes» у чатах. Вимкнення зупиняє поточне голосове керування.';

  @override
  String get hands_free_timing_limit =>
      'Час для продовження — максимальний, а не мінімальний. Android може завершити запис раніше. Після тиші повертається локальне очікування активації без повторних запусків розпізнавання.';

  @override
  String get hands_free_followup_off =>
      'Продовження вимкнено — кажіть Hey Hermes перед кожним запитом';

  @override
  String get hands_free_start_blocked =>
      'Для запуску потрібні порожня чернетка, відсутність вкладень, підключений вільний чат і ввімкнені голосові відповіді. Спершу завершіть ручний запис.';

  @override
  String get hands_free_setup_complete =>
      'Мікрофон налаштовано. Знову натисніть «Почати».';

  @override
  String message_time_recorded(String time) {
    return 'Збережено сервером: $time (місцевий час)';
  }

  @override
  String message_time_sent(String time) {
    return 'Надсилання зафіксовано на цьому пристрої: $time (місцевий час)';
  }

  @override
  String message_time_received(String time) {
    return 'Уперше отримано на цьому пристрої: $time (місцевий час)';
  }

  @override
  String get stop_and_send => 'Зупинити й надіслати';

  @override
  String get message_queued_for_running_turn =>
      'Повідомлення додано в чергу поточного запуску.';

  @override
  String get running_message_not_accepted =>
      'Hermes не зміг прийняти повідомлення. Чернетку збережено; зупиніть відповідь або дочекайтеся завершення й надішліть знову.';

  @override
  String get running_message_delivery_unknown =>
      'Не вдалося підтвердити доставку. Чернетку збережено. Перед повторним надсиланням перевірте чат.';

  @override
  String get attachment_tap_to_preview => 'Торкніться для перегляду';

  @override
  String get attachment_save => 'Зберегти';

  @override
  String get attachment_share => 'Поділитися';

  @override
  String get attachment_saved => 'Файл збережено';

  @override
  String get attachment_save_cancelled => 'Збереження скасовано';

  @override
  String get attachment_save_failed =>
      'Не вдалося зберегти файл. Спробуйте ще раз.';

  @override
  String get attachment_share_failed =>
      'Не вдалося поділитися файлом. Спробуйте ще раз.';

  @override
  String get attachment_download_failed =>
      'Не вдалося завантажити файл. Перевірте підключення й повторіть спробу.';

  @override
  String get attachment_no_inline_preview =>
      'Для цього типу файлу попередній перегляд недоступний. Збережіть оригінал або поділіться ним, щоб відкрити в іншому застосунку.';

  @override
  String get attachment_image_failed =>
      'Не вдалося прочитати зображення. Ви можете зберегти оригінал або поділитися ним.';

  @override
  String get attachment_text_truncated =>
      'Перегляд скорочено. Збережіть файл або поділіться ним, щоб прочитати повністю.';

  @override
  String get attachment_text_unavailable =>
      'Не вдалося показати файл як текст. Збережіть оригінал або поділіться ним.';

  @override
  String get attachment_pdf_failed =>
      'Не вдалося показати PDF. Збережіть оригінал або поділіться ним.';

  @override
  String get attachment_pdf_unavailable =>
      'Попередній перегляд PDF доступний на Android. Ви можете зберегти цей файл або поділитися ним.';

  @override
  String attachment_pdf_page(int page, int total) {
    return 'Сторінка $page з $total';
  }

  @override
  String get attachment_previous_page => 'Попередня сторінка';

  @override
  String get attachment_next_page => 'Наступна сторінка';

  @override
  String get attachment_loading => 'Завантаження перегляду…';

  @override
  String get attachment_document_text_notice =>
      'Текстовий перегляд. Розташування, зображення та форматування можуть відрізнятися від оригіналу.';

  @override
  String get attachment_document_failed =>
      'Не вдалося показати документ. Збережіть оригінал або поділіться ним.';

  @override
  String get attachment_document_empty =>
      'У документі не знайдено читабельного тексту.';

  @override
  String get attachment_video_failed =>
      'Не вдалося відтворити відео. Формат або кодек може не підтримуватися. Збережіть оригінал або поділіться ним.';

  @override
  String get attachment_video_play => 'Відтворити';

  @override
  String get attachment_video_pause => 'Пауза';

  @override
  String get attachment_video_mute => 'Вимкнути звук';

  @override
  String get attachment_video_unmute => 'Увімкнути звук';

  @override
  String get attachment_video_seek => 'Позиція відео';

  @override
  String get attachment_close => 'Закрити перегляд';

  @override
  String get attachment_retry => 'Повторити';

  @override
  String get saved_history_heading => 'Збережена історія';

  @override
  String get received_output_heading =>
      'Отримана відповідь — збіг зі збереженою історією не підтверджено';

  @override
  String get received_output_details => 'Про отриману відповідь';

  @override
  String get received_output_explanation =>
      'Це також може бути у збереженій історії. Застосунок не може підтвердити збіг.';

  @override
  String get local_prompt_context => 'Локальний контекст запиту';

  @override
  String get received_output_badge => 'Отримано · збіг не підтверджено';

  @override
  String get received_output_lifetime =>
      'Отримана відповідь тимчасово зберігається в цій сесії застосунку. Після досягнення обмежень її можуть скоротити або видалити. Після закриття застосунку чи підключення вона може бути недоступною.';

  @override
  String get theme_palette => 'Колірна тема';

  @override
  String get theme_palette_gold => 'Золота';

  @override
  String get theme_palette_purple => 'Фіолетова';

  @override
  String get theme_palette_orange => 'Оранжева';

  @override
  String get theme_palette_green => 'Зелена';

  @override
  String get theme_palette_blue => 'Синя';

  @override
  String get theme_palette_red => 'Червона';

  @override
  String get theme_palette_teal => 'Бірюзова';

  @override
  String get theme_palette_pink => 'Рожева';

  @override
  String get theme_palette_indigo => 'Індиго';

  @override
  String get theme_palette_cyan => 'Блакитна';

  @override
  String get assets_recent_subtitle =>
      'Файли, якими Hermes поділився у збережених чатах';

  @override
  String get assets_scope_notice =>
      'Створені файли, на які Hermes явно послався у збережених відповідях. Це частковий перегляд історії, а не повний каталог файлів чи вкладень. Файли за посиланнями вже можуть не існувати.';

  @override
  String get assets_download_limit =>
      'Файли завантажуються лише після натискання. Межа перегляду й завантаження — 25 МіБ на файл; для більших файлів використовуйте вебпанель.';

  @override
  String get assets_search_hint =>
      'Пошук серед знайдених файлів і чатів-джерел';

  @override
  String get assets_all => 'Усі';

  @override
  String get assets_images => 'Зображення';

  @override
  String get assets_audio => 'Аудіо';

  @override
  String get assets_video => 'Відео';

  @override
  String get assets_documents => 'Документи та інші файли';

  @override
  String get assets_empty => 'У перевірених повідомленнях файлів не знайдено';

  @override
  String get assets_empty_detail =>
      'Перевірте більше чатів або старіші повідомлення. Звичайні вкладення й файли без посилань тут не індексуються.';

  @override
  String get assets_no_matches => 'Відповідних файлів немає';

  @override
  String get assets_load_more_chats => 'Перевірити більше чатів';

  @override
  String get assets_load_older_messages => 'Перевірити старіші повідомлення';

  @override
  String get assets_load_failed =>
      'Частину історії не вдалося прочитати. Результати неповні. Перевірте підключення до вебпанелі й повторіть спробу.';

  @override
  String get assets_retry_failed => 'Повторити невдалі читання історії';

  @override
  String get assets_partial =>
      'Сервер повідомив про неповну історію. Перевірте вебпанель і оновіть.';

  @override
  String assets_scan_summary(int files, int chats) {
    return 'Знайдено $files посилань на файли в $chats перевірених чатах';
  }

  @override
  String assets_open_chat(String title) {
    return 'Відкрити чат: $title';
  }

  @override
  String get assets_file_too_large =>
      'Файл перевищує межу завантаження. Відкрийте вебпанель, щоб завантажити його.';

  @override
  String get a_one_off_question_archives_itself_after_72_hours_anything =>
      'Разове запитання. Через 72 години чат автоматично архівується; важливе залишається в пам’яті.';

  @override
  String get archive_chat => 'Архівувати чат';

  @override
  String get unarchive_chat => 'Повернути чат з архіву';

  @override
  String get chat_archived => 'Чат архівовано';

  @override
  String get chat_unarchived => 'Чат повернуто з архіву';

  @override
  String could_not_update_chat_archive(Object error) {
    return 'Не вдалося змінити архівний стан чату: $error';
  }

  @override
  String get quick_chat_description => 'Разове запитання.';

  @override
  String get ai_full_text => 'ШІ + повнотекстовий';

  @override
  String get ai_search_model => 'Модель ШІ для пошуку';

  @override
  String ai_searched_for(Object aiRewrittenQuery) {
    return 'ШІ шукав: $aiRewrittenQuery';
  }

  @override
  String get ai_assisted_filing => 'Упорядкування за допомогою ШІ';

  @override
  String get api_key => 'Ключ API';

  @override
  String get api_server_key_from_hermes_env =>
      'API_SERVER_KEY із ~/.hermes/.env';

  @override
  String get active => 'Активний';

  @override
  String get activity => 'Активність';

  @override
  String get activity_reads_the_durable_turn_journal_to_know_what_hermes =>
      'Вкладка активності читає збережений журнал ходів, щоб показувати роботу Hermes. Перевірте доступність шлюзу й повторіть спробу.';

  @override
  String get add => 'Додати';

  @override
  String get add_connection => 'Додати підключення';

  @override
  String get add_cron_job => 'Додати завдання за розкладом';

  @override
  String get add_gateway_connection => 'Додати підключення до шлюзу';

  @override
  String get add_and_update_connections_from_the_backup_keep_the_rest =>
      'Додати й оновити підключення з резервної копії, решту залишити.';

  @override
  String get add_attachment => 'Додати вкладення';

  @override
  String get add_new_cron_job => 'Додати нове завдання за розкладом';

  @override
  String get add_to_chat => 'Додати до чату';

  @override
  String get all_chats => 'Усі чати';

  @override
  String get all_stored_message_content => 'Увесь збережений вміст повідомлень';

  @override
  String get allow_for_this_session => 'Дозволити на цю сесію';

  @override
  String get allow_matching_commands_until_this_hermes_session_ends =>
      'Дозволяти відповідні команди до завершення цієї сесії Hermes.';

  @override
  String get allow_folder_until_sandbox_off =>
      'Дозволити цю папку, доки пісочницю не буде вимкнено.';

  @override
  String get allow_once => 'Дозволити один раз';

  @override
  String get allow_website_until_sandbox_off =>
      'Дозволити цей сайт, доки пісочницю не буде вимкнено.';

  @override
  String get always_allow => 'Завжди дозволяти';

  @override
  String get apply_to_this_chat => 'Застосувати до цього чату';

  @override
  String get approval_needed => 'Потрібне підтвердження';

  @override
  String get approval_needed_description =>
      'Команда очікує вашого дозволу або відмови.';

  @override
  String get approve => 'Дозволити';

  @override
  String get archive => 'Архівувати';

  @override
  String get archive_project => 'Архівувати проєкт';

  @override
  String archive_2(Object projectName) {
    return 'Архівувати $projectName?';
  }

  @override
  String archive_3(Object name) {
    return 'Архівувати $name?';
  }

  @override
  String get archived => 'Архів';

  @override
  String get archived_conversations_appear_here =>
      'Тут лише архівні розмови. Старіші чати залишаються в розділі «Усі чати».';

  @override
  String get archived_quick_chats => 'Архівні швидкі чати';

  @override
  String get artifacts_attachments_and_generated_media =>
      'Артефакти, вкладення та створені медіафайли';

  @override
  String get ask_ai_to_find_a_conversation => 'Попросити ШІ знайти розмову';

  @override
  String get assets => 'Файли';

  @override
  String get assets_need_a_server_authoritative_assets_index_in_the_hermes =>
      'Для показу файлів за проєктами потрібен серверний індекс файлів у шлюзі Hermes.';

  @override
  String get assets_unavailable => 'Файли недоступні';

  @override
  String get attach_image_or_file => 'Додати зображення або файл';

  @override
  String get attachment_drafts => 'Чернетки вкладень';

  @override
  String get recover_text_draft => 'Відновити чернетку';

  @override
  String get undo_draft_recovery => 'Скасувати';

  @override
  String get draft_session_exists =>
      'Цей чат ще існує. Відкрийте його, щоб продовжити роботу з чернеткою.';

  @override
  String get draft_recovery_unavailable =>
      'Не вдалося перевірити чернетку. Нічого не змінено.';

  @override
  String attachment_of(Object index, Object total) {
    return 'Вкладення $index з $total';
  }

  @override
  String get auto_device_default => 'Автоматично (як на пристрої)';

  @override
  String get agent => 'Агент';

  @override
  String get autonomous_agents => 'Автономні агенти';

  @override
  String get background_recovery_unavailable_legacy_transport =>
      'Фонове відновлення недоступне — застаріле підключення';

  @override
  String get background_task_completed => 'Фонове завдання завершено';

  @override
  String get background_task_completed_description =>
      'Фонова команда термінала завершилася.';

  @override
  String get backup_restore => 'Резервна копія та відновлення';

  @override
  String backup_exported(Object destination) {
    return 'Резервну копію експортовано — $destination';
  }

  @override
  String get base_url => 'Базова адреса';

  @override
  String get binary_preview_is_unavailable_download_the_file_to_open_it =>
      'Попередній перегляд двійкових файлів недоступний. Завантажте файл, щоб відкрити його.';

  @override
  String get branch => 'Гілка';

  @override
  String get branch_chat => 'Створити відгалуження чату';

  @override
  String get branch_created_in_hermes_history =>
      'Відгалуження створено в історії Hermes.';

  @override
  String get browse_and_manage_your_hermes_agent_sessions_from_your_phone =>
      'Переглядайте сесії Hermes Agent і керуйте ними з телефона. Підключається до вебпанелі Hermes у вашій локальній мережі.';

  @override
  String get browse_server_files => 'Перегляд файлів сервера';

  @override
  String get browse_the_miniserver_folders_behind_your_projects =>
      'Переглядайте серверні папки ваших проєктів';

  @override
  String get cancel => 'Скасувати';

  @override
  String get cancel_voice_input => 'Скасувати голосовий ввід';

  @override
  String cannot_reach(Object host, Object port) {
    return 'Немає зв’язку з $host:$port.';
  }

  @override
  String cannot_reach_check_the_host_and_port(Object host, Object port) {
    return 'Немає зв’язку з $host:$port. Перевірте адресу й порт.';
  }

  @override
  String get change_ai_search_model => 'Змінити модель пошуку ШІ';

  @override
  String changes_the_default_for_use_the_selector_in_a_chat(Object label) {
    return 'Змінює типову модель для $label. Щоб змінити лише одну розмову, скористайтеся вибором моделі в чаті.';
  }

  @override
  String get chat_actions => 'Дії чату';

  @override
  String get chats => 'Чати';

  @override
  String get chats_from_this_gateway_are_not_grouped_yet_grouping_stays =>
      'Чати цього шлюзу ще не згруповані. Групування залишатиметься на телефоні, доки шлюз не підтримуватиме проєкти.';

  @override
  String get chats_in_this_project_will_show_their_state_and_last =>
      'Тут відображатимуться стан і остання активність чатів цього проєкту.';

  @override
  String get chats_that_are_not_assigned_to_a_project =>
      'Чати, що не належать до жодного проєкту';

  @override
  String get chats_you_start_in_this_project_will_appear_here_on =>
      'Створені в цьому проєкті чати відображатимуться тут на всіх пристроях, підключених до цього Hermes.';

  @override
  String get check_that_the_gateway_is_running_and_reachable_then_try =>
      'Перевірте, чи шлюз запущений і доступний, та повторіть спробу.';

  @override
  String get check_the_dashboard_connection_and_try_again =>
      'Перевірте підключення до вебпанелі й повторіть спробу.';

  @override
  String get check_the_connection_and_try_again =>
      'Перевірте підключення й повторіть спробу.';

  @override
  String get choose_a_small_model_to_rewrite_queries =>
      'Виберіть невелику модель для переформулювання запитів';

  @override
  String get choose_an_ai_search_model_before_using_ai_search =>
      'Перед використанням пошуку ШІ виберіть його модель.';

  @override
  String get choose_an_active_project_next => 'Далі виберіть активний проєкт';

  @override
  String get choose_chat_model => 'Вибрати модель чату';

  @override
  String get choose_files => 'Вибрати файли';

  @override
  String get choose_image => 'Вибрати зображення';

  @override
  String get choose_images => 'Вибрати зображення';

  @override
  String get choose_its_destination_space => 'Виберіть розділ призначення';

  @override
  String get clear_search => 'Очистити пошук';

  @override
  String get close => 'Закрити';

  @override
  String get code_copied => 'Код скопійовано';

  @override
  String get code_format => 'Код';

  @override
  String get coming_next => 'Незабаром';

  @override
  String get command => 'Команда';

  @override
  String get command_palette => 'Палітра команд';

  @override
  String get command_palette_hint => 'Введіть команду';

  @override
  String get command_palette_no_results => 'Команд не знайдено';

  @override
  String get command_palette_new_chat => 'Новий чат';

  @override
  String get command_palette_search_chats => 'Пошук чатів';

  @override
  String get command_palette_toggle_theme => 'Змінити тему';

  @override
  String get command_palette_copy_last_code => 'Копіювати останній блок коду';

  @override
  String get command_line_chats => 'Чати командного рядка';

  @override
  String get compatibility_mode => 'Режим сумісності';

  @override
  String get configure_a_valid_desktop_gateway_url_before_attaching_files =>
      'Перед додаванням файлів налаштуйте правильну адресу серверного Desktop Gateway.';

  @override
  String get confirm_always_allow => 'Підтвердити постійний дозвіл';

  @override
  String get confirm_passphrase => 'Підтвердьте парольну фразу';

  @override
  String connecting_to(Object baseUrl) {
    return 'Підключення до $baseUrl…';
  }

  @override
  String get connection_issue => 'Проблема підключення';

  @override
  String
  get connection_switched_the_running_reply_continues_on_the_server_and =>
      'Підключення змінено — відповідь продовжує формуватися на сервері й автоматично під’єднається знову.';

  @override
  String get connection_appearance_and_device_preferences =>
      'Підключення, вигляд і налаштування пристрою';

  @override
  String context_tokens(Object effectiveContextLength) {
    return 'Контекст: $effectiveContextLength токенів';
  }

  @override
  String get continue_label => 'Продовжити';

  @override
  String get continue_working => 'Продовжити роботу';

  @override
  String get conversations_in_this_project => 'Розмови цього проєкту';

  @override
  String get copy_code => 'Копіювати код';

  @override
  String get copy_message => 'Копіювати повідомлення';

  @override
  String could_not_branch_chat(Object error) {
    return 'Не вдалося створити відгалуження чату: $error';
  }

  @override
  String could_not_delete_session(Object error) {
    return 'Не вдалося видалити сесію: $error';
  }

  @override
  String could_not_deny_the_command(Object error) {
    return 'Не вдалося відхилити команду: $error';
  }

  @override
  String could_not_load_ai_search_models(Object error) {
    return 'Не вдалося завантажити моделі пошуку ШІ: $error';
  }

  @override
  String get could_not_load_conversations => 'Не вдалося завантажити розмови';

  @override
  String get could_not_load_files => 'Не вдалося завантажити файли';

  @override
  String could_not_load_models_for_this_profile(Object error) {
    return 'Не вдалося завантажити моделі цього профілю: $error';
  }

  @override
  String could_not_load_more_chats(Object error) {
    return 'Не вдалося завантажити інші чати: $error';
  }

  @override
  String get could_not_open_link => 'Не вдалося відкрити посилання.';

  @override
  String get could_not_open_the_hermes_dashboard =>
      'Не вдалося відкрити вебпанель Hermes.';

  @override
  String get could_not_open_this_project => 'Не вдалося відкрити проєкт';

  @override
  String get could_not_preview_file => 'Не вдалося переглянути файл';

  @override
  String get could_not_reach_hermes => 'Не вдалося підключитися до Hermes';

  @override
  String could_not_reach_authenticate_the_dashboard_at_check_the_port(
    Object dashboardPort,
    Object host,
  ) {
    return 'Не вдалося підключитися або увійти до вебпанелі за адресою $host:$dashboardPort. Перевірте порт і облікові дані.';
  }

  @override
  String get could_not_read_activity => 'Не вдалося прочитати активність';

  @override
  String could_not_rename_chat(Object error) {
    return 'Не вдалося перейменувати чат: $error';
  }

  @override
  String could_not_send_the_approval(Object error) {
    return 'Не вдалося надіслати підтвердження: $error';
  }

  @override
  String get could_not_skip_the_hermes_question =>
      'Не вдалося пропустити запитання Hermes.';

  @override
  String could_not_the_project(Object action, Object error) {
    return 'Не вдалося виконати дію «$action» для проєкту: $error';
  }

  @override
  String get couldn_t_delete_project => 'Не вдалося видалити проєкт';

  @override
  String couldn_t_load_runs(Object error) {
    return 'Не вдалося завантажити запуски: $error';
  }

  @override
  String get couldn_t_move_conversation => 'Не вдалося перемістити розмову';

  @override
  String couldn_t_move_to(Object label, Object reason) {
    return 'Не вдалося перемістити до $label: $reason';
  }

  @override
  String get couldn_t_prepare_the_shared_files =>
      'Не вдалося підготувати файли для поширення.';

  @override
  String get couldn_t_promote_conversation =>
      'Не вдалося перенести розмову до проєкту';

  @override
  String couldn_t_project(Object action) {
    return 'Не вдалося виконати дію «$action» для проєкту';
  }

  @override
  String get create => 'Створити';

  @override
  String get create_a_project => 'Створити проєкт';

  @override
  String get create_a_project_first_then_chats_can_live_inside_it =>
      'Спершу створіть проєкт, потім додайте до нього чати.';

  @override
  String get create_a_space_to_separate_related_conversations =>
      'Створіть розділ, щоб відокремити пов’язані розмови.';

  @override
  String get create_branch => 'Створити відгалуження';

  @override
  String get credit_notifications => 'Сповіщення про кредити';

  @override
  String get credit_notifications_description =>
      'Використання кредитів зупинено або відновлено.';

  @override
  String get cron => 'Розклад';

  @override
  String get crons => 'Розклади';

  @override
  String get cron_conversations_empty =>
      'Тут розмови із завдань за розкладом, зокрема попередні запуски.';

  @override
  String get search_cron_conversations => 'Пошук розмов за розкладом';

  @override
  String get cron_jobs => 'Завдання за розкладом';

  @override
  String cron_schedule_timezone(Object zone) {
    return 'Часовий пояс розкладу: $zone';
  }

  @override
  String get crons_upcoming => 'Майбутні';

  @override
  String get crons_history => 'Історія';

  @override
  String cron_time_with_zone(Object time, Object zone) {
    return '$time ($zone)';
  }

  @override
  String cron_time_zone_unknown(Object time) {
    return '$time (часовий пояс невідомий)';
  }

  @override
  String get cron_no_next_run => 'Наступний запуск не заплановано';

  @override
  String get cron_status_scheduled => 'Заплановано';

  @override
  String get cron_status_paused => 'Призупинено';

  @override
  String cron_delivers_to(Object target) {
    return 'Доставка до $target';
  }

  @override
  String get cron_upcoming_empty_title => 'Немає запланованих завдань';

  @override
  String get cron_upcoming_empty_message =>
      'До запуску нічого не заплановано. Створіть завдання в розділі «Завдання за розкладом» або попросіть агента запланувати його.';

  @override
  String get cron_upcoming_unavailable => 'Заплановані завдання недоступні';

  @override
  String get cron_upcoming_needs_dashboard =>
      'Для запланованих завдань потрібне підключення до вебпанелі. Ця адреса не надає розклад Cron. Перевірте адресу вебпанелі та підтримку цієї функції на сервері.';

  @override
  String get cron_upcoming_needs_dashboard_auth =>
      'Для запланованих завдань потрібна автентифікація вебпанелі. Додайте ім’я користувача та пароль вебпанелі до цього підключення або увімкніть режим через проксі.';

  @override
  String get cron_upcoming_dashboard_unreachable =>
      'Не вдалося підключитися до вебпанелі. Перевірте вузол, порт вебпанелі та мережу, потім повторіть спробу.';

  @override
  String get cron_upcoming_load_failed =>
      'Не вдалося прочитати заплановані завдання. Перевірте підключення до вебпанелі й повторіть спробу.';

  @override
  String get cron_upcoming_refresh_failed =>
      'Не вдалося оновити розклад. Показано останній успішний результат.';

  @override
  String get cron_job_added => 'Завдання за розкладом додано';

  @override
  String get cron_job_updated => 'Завдання за розкладом оновлено';

  @override
  String get cron_run => 'Запуск за розкладом';

  @override
  String get cross_device_ordering_and_reversible_bulk_organization =>
      'Порядок на всіх пристроях і зворотне масове впорядкування';

  @override
  String get current_profile_default => 'Типова модель поточного профілю';

  @override
  String get custom_proxy_and_dashboard_details =>
      'Додаткові параметри проксі та вебпанелі';

  @override
  String get dark => 'Темна';

  @override
  String get dashboard_proxy_settings => 'Налаштування вебпанелі та проксі';

  @override
  String get dashboard_password_optional => 'Пароль вебпанелі (необов’язково)';

  @override
  String get dashboard_port => 'Порт вебпанелі';

  @override
  String get dashboard_username_optional =>
      'Ім’я користувача вебпанелі (необов’язково)';

  @override
  String get dashboard_behind_proxy => 'Вебпанель за проксі';

  @override
  String get dashboard_path_prefix => 'Префікс шляху вебпанелі';

  @override
  String delegated_task(Object goal) {
    return 'Делеговане завдання: $goal';
  }

  @override
  String get delete => 'Видалити';

  @override
  String delete_2(Object name) {
    return 'Видалити «$name»?';
  }

  @override
  String delete_from_the_remote_hermes_history_this_cannot_be_undone(
    Object title,
  ) {
    return 'Видалити «$title» з історії на сервері Hermes? Цю дію неможливо скасувати.';
  }

  @override
  String get delete_cron_job => 'Видалити завдання за розкладом';

  @override
  String get delete_connections_that_are_not_in_the_backup =>
      'Видалити підключення, яких немає в резервній копії.';

  @override
  String delete_failed(Object error) {
    return 'Не вдалося видалити: $error';
  }

  @override
  String get delete_project => 'Видалити проєкт';

  @override
  String get delete_session => 'Видалити сесію?';

  @override
  String delete_3(Object projectName) {
    return 'Видалити $projectName?';
  }

  @override
  String deleted(Object name) {
    return '«$name» видалено';
  }

  @override
  String get delivery_is_uncertain_recovering_without_resending =>
      'Доставка не підтверджена; відновлення без повторного надсилання…';

  @override
  String get desktop_gateway_url_optional =>
      'Адреса серверного Desktop Gateway (необов’язково)';

  @override
  String get desktop_gateway_is_not_configured_for_this_connection =>
      'Для цього підключення серверний Desktop Gateway не налаштовано.';

  @override
  String get desktop_app => 'Десктопний застосунок';

  @override
  String get developer_tool_calls => 'Виклики інструментів розробника';

  @override
  String get discord_chats => 'Чати Discord';

  @override
  String get dismiss => 'Приховати';

  @override
  String get do_not_run_this_command => 'Не виконувати цю команду.';

  @override
  String get documents_archives_audio_video_or_data =>
      'Документи, архіви, аудіо, відео або дані';

  @override
  String get download => 'Завантажити';

  @override
  String download_failed(Object error) {
    return 'Не вдалося завантажити: $error';
  }

  @override
  String get durable_facts_hermes_keeps_about_you =>
      'Відомості про вас, які Hermes зберігає надовго';

  @override
  String get durable_work_inside_one_of_your_projects_shared_with_desktop =>
      'Тривала робота в одному з ваших проєктів, спільна з Desktop.';

  @override
  String get edit => 'Редагувати';

  @override
  String get edit_connection => 'Редагувати підключення';

  @override
  String get edit_cron_job => 'Редагувати завдання за розкладом';

  @override
  String get edit_gateway_connection => 'Редагувати підключення до шлюзу';

  @override
  String get edit_and_resend => 'Редагувати й надіслати знову';

  @override
  String get enable_notifications => 'Увімкнути сповіщення';

  @override
  String get enable_notifications_description =>
      'Вимкнення заблокує всі наведені нижче сповіщення.';

  @override
  String get enables_file_attachments_through_the_desktop_remote_gateway =>
      'Дозволяє додавати файли через серверний Desktop Gateway.';

  @override
  String get enter_a_name => 'Введіть назву';

  @override
  String get enter_a_passphrase => 'Введіть парольну фразу.';

  @override
  String get enter_the_passphrase_for_this_backup =>
      'Введіть парольну фразу цієї резервної копії.';

  @override
  String get every_conversation_is_already_assigned_to_a_project =>
      'Усі розмови вже належать до проєктів.';

  @override
  String get everything_not_yet_native_in_the_authenticated_web_dashboard =>
      'Функції без вбудованого екрана доступні у вебпанелі після входу';

  @override
  String get explain_the_attached_content_clearly =>
      'Зрозуміло поясни вміст вкладення.';

  @override
  String explain_this_content_clearly(Object text) {
    return 'Зрозуміло поясни цей вміст:\n\n$text';
  }

  @override
  String
  get explicit_choices_adjust_android_accessibility_text_size_system_leaves_it =>
      'Явний вибір змінює масштаб доступності тексту Android; варіант «Системний» залишає його без змін.';

  @override
  String get export_label => 'Експорт';

  @override
  String get export_share => 'Експортувати / поділитися';

  @override
  String get external_api_clients => 'Зовнішні клієнти API';

  @override
  String get extra_high => 'Дуже високий';

  @override
  String get extract_tasks => 'Виділити завдання';

  @override
  String
  get extract_the_decisions_deadlines_owners_and_actionable_action_items_from =>
      'Виділи рішення, строки, відповідальних і конкретні дії зі вмісту вкладення.';

  @override
  String
  extract_the_decisions_deadlines_owners_and_actionable_action_items_from_2(
    Object text,
  ) {
    return 'Виділи рішення, строки, відповідальних і конкретні дії з цього вмісту:\n\n$text';
  }

  @override
  String failed_to_add_job(Object error) {
    return 'Не вдалося додати завдання: $error';
  }

  @override
  String get failed_to_load_cron_jobs =>
      'Не вдалося завантажити завдання за розкладом';

  @override
  String get failed_to_load_memory => 'Не вдалося завантажити пам’ять';

  @override
  String get failed_to_load_messages => 'Не вдалося завантажити повідомлення';

  @override
  String get failed_to_load_settings => 'Не вдалося завантажити налаштування';

  @override
  String get failed_to_load_skills => 'Не вдалося завантажити навички';

  @override
  String failed_to_update_job(Object error) {
    return 'Не вдалося оновити завдання: $error';
  }

  @override
  String failed(Object error) {
    return 'Помилка: $error';
  }

  @override
  String get file_attached_document_catalog_registration_is_pending =>
      'Файл додано; реєстрація в каталозі документів очікується.';

  @override
  String get file_reference_added_to_chat => 'Посилання на файл додано до чату';

  @override
  String get files => 'Файли';

  @override
  String get fill_from_document => 'Заповнити з документа';

  @override
  String get folder_is_empty => 'Папка порожня';

  @override
  String get folders => 'Папки';

  @override
  String get full_text => 'Повнотекстовий';

  @override
  String get gateway_api_access => 'Доступ до API шлюзу';

  @override
  String get gateway_connected_but_the_dashboard_could_not_be_reached_or =>
      'Шлюз підключено, але вебпанель недоступна або вхід не виконано. Перевірте її параметри або очистьте їх, щоб пропустити.';

  @override
  String get gateway_path_prefix => 'Префікс шляху шлюзу';

  @override
  String get go_to_end => 'До останнього повідомлення';

  @override
  String get hermes_agent => 'Ares - formerly Hermes Android';

  @override
  String get hermes_agent_for_android => 'Ares - formerly Hermes Android';

  @override
  String get hermes_could_not_accept_the_answer_please_try_again =>
      'Hermes не зміг прийняти відповідь. Спробуйте ще раз.';

  @override
  String get hermes_could_not_load_your_saved_connections =>
      'Hermes не зміг завантажити збережені підключення';

  @override
  String get hermes_did_not_accept_the_response_please_try_again =>
      'Hermes не прийняв відповідь. Спробуйте ще раз.';

  @override
  String get hermes_is_responding => 'Hermes відповідає…';

  @override
  String get hermes_is_waiting_for_input => 'Hermes очікує введення…';

  @override
  String get hermes_keeps_android_accessibility_text_scaling_active =>
      'Ares зберігає системне масштабування тексту Android.';

  @override
  String get hermes_needs_your_input => 'Hermes потребує вашої відповіді';

  @override
  String get hermes_profile_optional => 'Профіль Hermes (необов’язково)';

  @override
  String get hermes_profile_must_be_a_plain_profile_name_such_as =>
      'Профіль Hermes має бути простою назвою, наприклад «sol», а не шляхом.';

  @override
  String get hermes_reasoning_details => 'Подробиці міркувань Hermes';

  @override
  String hermes_recovery_is_unavailable(Object error) {
    return 'Відновлення Hermes недоступне: $error';
  }

  @override
  String get hermes_stopped_recovery_safely_no_prompt_was_resent =>
      'Hermes безпечно зупинив відновлення. Повторного надсилання запиту не було.';

  @override
  String get hide_passphrase => 'Приховати парольну фразу';

  @override
  String get home_needs_your_recent_chats_to_know_what_deserves_your =>
      'Для визначення важливих подій головному екрану потрібні ваші останні чати. Перевірте доступність шлюзу й повторіть спробу.';

  @override
  String get host => 'Адреса сервера';

  @override
  String get image_selection_was_interrupted_try_again =>
      'Вибір зображення перервано. Спробуйте ще раз.';

  @override
  String get import_label => 'Імпорт';

  @override
  String get inbox => 'Вхідні';

  @override
  String get inbox_is_clear => 'Вхідних дій немає';

  @override
  String get input_needed => 'Потрібна відповідь';

  @override
  String get input_needed_description =>
      'Hermes поставив запитання або запитує пароль чи секрет.';

  @override
  String get insert_a_remote_file_reference =>
      'Вставити посилання @file на серверний файл';

  @override
  String get invalid_port_number => 'Некоректний номер порту.';

  @override
  String get job_paused => 'Завдання призупинено';

  @override
  String get job_resumed => 'Завдання відновлено';

  @override
  String get job_triggered => 'Завдання запущено';

  @override
  String get label => 'Назва';

  @override
  String last_activity(Object day, Object month, Object year) {
    return 'Остання активність $day/$month/$year';
  }

  @override
  String last(Object lastRun) {
    return 'Востаннє: $lastRun';
  }

  @override
  String get leave_blank_for_default_8642_443_with_https =>
      'Залиште порожнім для типового порту (8642; для HTTPS — 443)';

  @override
  String get leave_blank_for_default_9119 =>
      'Залиште порожнім для типового порту (9119)';

  @override
  String get light => 'Світла';

  @override
  String listening(Object elapsed) {
    return 'Слухаю • $elapsed';
  }

  @override
  String listening_elapsed(Object elapsed) {
    return 'Слухаю, минуло $elapsed';
  }

  @override
  String get load_more => 'Завантажити ще…';

  @override
  String get loading => 'Завантаження';

  @override
  String get location => 'Розташування';

  @override
  String get make_sure_the_gateway_api_server_is_running_hermes_gateway =>
      'Переконайтеся, що API-сервер шлюзу працює\n(hermes gateway status)';

  @override
  String matches(Object assigned, Object name) {
    return 'Збіг: $name · $assigned';
  }

  @override
  String get memory => 'Пам’ять';

  @override
  String get memory_about_you => 'Про вас';

  @override
  String get memory_agent_notes => 'Нотатки агента';

  @override
  String get memory_builtin_scope =>
      'Збережені відомості з USER.md і MEMORY.md цього профілю. Дані зовнішніх сховищ пам’яті, зокрема MemPalace, тут не показуються.';

  @override
  String get memory_read_only =>
      'Лише для читання. Попросіть Hermes у чаті виправити або забути відомості.';

  @override
  String get memory_unavailable =>
      'Цей шлюз або профіль не надає збережених відомостей пам’яті. Перевірте вибраний профіль і за потреби оновіть Hermes.';

  @override
  String get memory_load_error =>
      'Перевірте підключення та вхід до вебпанелі й повторіть спробу.';

  @override
  String get memory_read_full_fact => 'Прочитати повністю';

  @override
  String get memory_full_fact_requires_update =>
      'Для повних записів потрібна новіша версія шлюзу Hermes. Оновіть Hermes і цей список.';

  @override
  String get memory_fact_detail_error =>
      'Не вдалося завантажити повний запис. Можливо, він змінився; оновіть список і повторіть спробу.';

  @override
  String get memory_entries_are_cross_session_facts_the_agent_remembers_they =>
      'Збережені відомості з’являться тут, коли Hermes їх запам’ятає.';

  @override
  String get merge => 'Об’єднати';

  @override
  String get message => 'Повідомлення';

  @override
  String get message_hermes => 'Повідомлення Hermes…';

  @override
  String get message_actions => 'Дії повідомлення';

  @override
  String get message_copied => 'Повідомлення скопійовано';

  @override
  String get migrating => 'Перенесення…';

  @override
  String get migration_complete => 'Перенесення завершено';

  @override
  String get migration_failed_local_spaces_were_kept_unchanged =>
      'Перенесення не вдалося. Локальні розділи залишено без змін.';

  @override
  String get migration_incomplete => 'Перенесення не завершено';

  @override
  String get migration_preview => 'Попередній перегляд перенесення';

  @override
  String get model => 'Модель';

  @override
  String get model_and_thinking_for_this_chat =>
      'Модель і міркування для цього чату';

  @override
  String model_was_not_changed(Object error) {
    return 'Модель не змінено: $error';
  }

  @override
  String get move_attachment_next => 'Перемістити вкладення далі';

  @override
  String get move_attachment_previous => 'Перемістити вкладення раніше';

  @override
  String get move_chat => 'Перемістити чат';

  @override
  String get move_conversation => 'Перемістити розмову';

  @override
  String get move_to_project => 'Перемістити до проєкту';

  @override
  String get move_to_space => 'Перемістити до розділу';

  @override
  String get moved_to_a_project => 'Переміщено до проєкту';

  @override
  String moved_to(Object label) {
    return 'Переміщено до $label';
  }

  @override
  String get name => 'Назва';

  @override
  String get name_prompt_and_schedule_are_required =>
      'Назва, запит і розклад обов’язкові';

  @override
  String get nav_activity => 'Активність';

  @override
  String get nav_projects => 'Проєкти';

  @override
  String get needs_a_correction_aware_filing_contract_in_the_hermes_gateway =>
      'Потрібна підтримка впорядкування з виправленнями у шлюзі Hermes.';

  @override
  String get needs_a_reachable_hermes_dashboard_check_the_host_port_and =>
      'Потрібна доступна вебпанель Hermes. Перевірте адресу, порт і облікові дані підключення.';

  @override
  String get needs_a_server_authoritative_assets_index_in_the_hermes_gateway =>
      'Потрібен серверний індекс файлів у шлюзі Hermes.';

  @override
  String get needs_durable_pin_ordering_batch_mutation_and_undo_contracts_in =>
      'Потрібна підтримка збереження порядку закріплень, масових змін і скасування у шлюзі Hermes.';

  @override
  String get needs_you => 'Потрібна ваша дія';

  @override
  String get new_label => 'Нове';

  @override
  String get new_chat => 'Новий чат';

  @override
  String get new_chat_2 => 'Новий чат';

  @override
  String new_chat_3(Object projectName) {
    return 'Новий чат · $projectName';
  }

  @override
  String get new_project => 'Новий проєкт';

  @override
  String get new_space => 'Новий розділ';

  @override
  String next(Object nextRun) {
    return 'Далі: $nextRun';
  }

  @override
  String get nginx_injects_auth_app_sends_clean_requests =>
      'Nginx додає авторизацію — застосунок надсилає запити без неї';

  @override
  String get no_tts_voices_found_ninstall_google_text_to_speech_and =>
      'Голоси озвучення не знайдено.\nУстановіть Google Text-to-Speech і завантажте голосові дані.';

  @override
  String get no_active_projects_on_this_gateway =>
      'На цьому шлюзі немає активних проєктів';

  @override
  String get no_activity_yet => 'Активності ще немає';

  @override
  String get no_chat_is_blocked_running_or_waiting_to_be_resumed =>
      'Немає чатів, що заблоковані, виконуються або очікують відновлення. Почніть новий, коли будете готові.';

  @override
  String no_chats_in_this_project_match(Object searchQuery) {
    return 'У цьому проєкті немає чатів за запитом «$searchQuery».';
  }

  @override
  String get no_chats_in_this_space_yet_tap_to_start_one =>
      'У цьому розділі ще немає чатів. Натисніть +, щоб почати.';

  @override
  String get no_chats_yet => 'Чатів ще немає';

  @override
  String get no_connections => 'Підключень немає';

  @override
  String get no_conversation_matches_this_view =>
      'Цьому перегляду не відповідає жодна розмова.';

  @override
  String get no_cron_jobs => 'Завдань за розкладом немає';

  @override
  String get no_folders_yet => 'Папок ще немає';

  @override
  String get no_local_spaces_were_found_for_this_connection_so_projects =>
      'Для цього підключення немає локальних розділів; тут уже використовуються лише проєкти.';

  @override
  String get no_matches => 'Збігів немає';

  @override
  String get no_memory_entries => 'Записів пам’яті немає';

  @override
  String get no_message_content_matches => 'Збігів у вмісті повідомлень немає';

  @override
  String get no_new_messages => 'Нових повідомлень немає';

  @override
  String get no_projects_yet => 'Проєктів ще немає';

  @override
  String get no_runs_yet => 'Запусків ще немає.';

  @override
  String no_server_project_matches_this_name(Object assigned) {
    return 'Немає серверного проєкту з такою назвою · $assigned';
  }

  @override
  String get no_sessions_yet => 'Сесій ще немає';

  @override
  String get no_skills_found => 'Навичок не знайдено';

  @override
  String get no_spaces_on_this_device => 'На цьому пристрої немає розділів';

  @override
  String get no_text_shared => 'Текст не передано';

  @override
  String get no_turn_is_blocked_in_flight_or_recently_finished_work =>
      'Немає заблокованих, поточних або нещодавно завершених ходів. Розпочата робота з’явиться тут.';

  @override
  String get no_turn_needs_your_input_or_has_failed =>
      'Немає ходів, які потребують відповіді або завершилися помилкою.';

  @override
  String get no_unassigned_chats => 'Чатів без проєкту немає.';

  @override
  String get nothing_changed_in_the_last_seven_days =>
      'За останні сім днів змін не було.';

  @override
  String get nothing_has_moved_yet_this_is_only_what_a_migration =>
      'Ще нічого не переміщено — це лише попередній перегляд майбутнього перенесення.';

  @override
  String get nothing_here => 'Тут порожньо';

  @override
  String get nothing_is_running => 'Зараз нічого не виконується';

  @override
  String get nothing_needs_you => 'Немає дій, що потребують вашої уваги';

  @override
  String get nothing_to_migrate => 'Немає даних для перенесення';

  @override
  String get notifications => 'Сповіщення';

  @override
  String get windows_notifications_blocked =>
      'Сповіщення недоступні. Використовуйте встановлений застосунок Ares і перевірте Параметри → Система → Сповіщення у Windows.';

  @override
  String get windows_notification_diagnostics => 'Що Ares передав до Windows';

  @override
  String get chat_activity_share => 'Повідомляти про активність у чаті';

  @override
  String get chat_activity_share_hint =>
      'Повідомляйте сумісний підключений шлюз, коли користуєтеся цим чатом, щоб його плагін сповіщень на телефоні уникав повторних сповіщень. Ключі й текст повідомлень не надсилаються.';

  @override
  String get completion_sound => 'Звук завершення';

  @override
  String get completion_sound_system => 'Типовий системний';

  @override
  String get completion_sound_mail => 'Пошта';

  @override
  String get completion_sound_reminder => 'Нагадування';

  @override
  String get completion_sound_silent => 'Без звуку';

  @override
  String get completion_sound_scope =>
      'Лунає для завершених відповідей, тестового сповіщення та всередині застосунку. Запити на схвалення й інші сповіщення зберігають звичний звук.';

  @override
  String get completion_sound_scope_android =>
      'Лунає для завершених відповідей, тестового сповіщення та всередині застосунку. Запити на схвалення, інші сповіщення, фонові сповіщення сервера й повідомлення Android Auto зберігають звичний звук.';

  @override
  String get notification_open_action => 'Відкрити';

  @override
  String get app_sounds_mute => 'Вимкнути звуки застосунку';

  @override
  String get app_sounds_mute_hint =>
      'Вимикає звук завершення, який Ares відтворює, поки відкритий. Сповіщення зберігають власний звук.';

  @override
  String get notifications_permission_denied =>
      'Сповіщення заблоковані системою. Увімкніть їх для цього застосунку в налаштуваннях Android.';

  @override
  String get off_no_thinking => 'Вимкнено (без міркувань)';

  @override
  String get offline_showing_the_last_known_activity =>
      'Немає зв’язку — показано останній відомий стан активності.';

  @override
  String get offline_showing_the_last_known_chats =>
      'Немає зв’язку — показано останні відомі чати';

  @override
  String get offline_showing_the_last_known_projects =>
      'Немає зв’язку — показано останні відомі проєкти.';

  @override
  String get on_this_device => 'На цьому пристрої';

  @override
  String get on_device => 'На пристрої';

  @override
  String get open_inbox => 'Відкрити вхідні';

  @override
  String open_inbox_2(Object count) {
    return 'Відкрити вхідні ($count)';
  }

  @override
  String get open_the_hermes_dashboard => 'Відкрити вебпанель Hermes';

  @override
  String get optional_for_the_memory_cron_skills_settings_tabs_leave_blank =>
      'Необов’язково. Для вкладок пам’яті, розкладу, навичок і налаштувань. Порожнє значення використовує типовий порт вебпанелі (9119) без входу.';

  @override
  String get organization => 'Упорядкування';

  @override
  String get other_answer => 'Інша відповідь';

  @override
  String get overview => 'Огляд';

  @override
  String get passphrase => 'Парольна фраза';

  @override
  String get password_optional => 'Пароль (необов’язково)';

  @override
  String get phone_or_tablet => 'Телефон або планшет';

  @override
  String get pin_batch_and_undo => 'Закріплення, масові дії та скасування';

  @override
  String get plugin_notifications => 'Сповіщення плагінів';

  @override
  String get plugin_notifications_description =>
      'Шлюз надіслав сповіщення, поки застосунок був у фоні.';

  @override
  String get port => 'Порт';

  @override
  String get preparing_attachments => 'Підготовка вкладень…';

  @override
  String get preview_truncated => 'Перегляд скорочено';

  @override
  String get preview_unavailable => 'Перегляд недоступний';

  @override
  String get profile => 'Профіль';

  @override
  String get profile_default_model => 'Типова модель профілю';

  @override
  String profile_default_set_to_chats_with_their_own_model_keep(
    Object selectedModel,
  ) {
    return 'Типову модель профілю змінено на $selectedModel. Чати з власною моделлю зберігають свій вибір.';
  }

  @override
  String
  get profile_this_connection_chats_as_when_the_dashboard_serves_several =>
      'Профіль для чатів цього підключення, якщо вебпанель обслуговує кілька профілів. Для окремої вебпанелі одного профілю залиште порожнім.';

  @override
  String get project => 'Проєкт';

  @override
  String get project_actions => 'Дії проєкту';

  @override
  String get project_chat => 'Чат проєкту';

  @override
  String get project_chats_unavailable => 'Чати проєкту недоступні';

  @override
  String get projects => 'Проєкти';

  @override
  String get projects_group_related_chats_files_and_activity_and_stay_in =>
      'Проєкти об’єднують пов’язані чати, файли й активність та синхронізуються з Hermes на комп’ютері.';

  @override
  String
  get projects_need_a_desktop_gateway_connection_add_the_desktop_gateway =>
      'Потрібна підтримка проєктів у серверному підключенні. Перевірте доступність сервера та підтримку API проєктів.';

  @override
  String get projects_unavailable => 'Проєкти недоступні';

  @override
  String get projects_activity_new_navigation =>
      'Проєкти й активність — нова навігація';

  @override
  String get promote_to_project => 'Перенести до проєкту';

  @override
  String get prompt => 'Запит';

  @override
  String get protect_this_backup => 'Захистити резервну копію';

  @override
  String get provider => 'Провайдер';

  @override
  String get proxy_injects_auth_app_sends_clean_requests =>
      'Проксі додає авторизацію; застосунок надсилає запити без неї';

  @override
  String get quick_chat => 'Швидкий чат';

  @override
  String get quick_chats_appear_here_after_their_retention_period =>
      'Швидкі чати з’являються тут після завершення строку зберігання.';

  @override
  String get read_aloud => 'Прочитати вголос';

  @override
  String get read_aloud_is_unavailable_on_this_device =>
      'Озвучення недоступне на цьому пристрої';

  @override
  String get reading_response_aloud => 'Озвучення відповіді';

  @override
  String get ready_to_upload => 'Готово до надсилання';

  @override
  String get reasoning => 'Міркування';

  @override
  String get recently_completed => 'Нещодавно завершено';

  @override
  String get recently_active => 'Нещодавня активність';

  @override
  String get recovering_hermes => 'Відновлення Hermes…';

  @override
  String get refresh => 'Оновити';

  @override
  String get regenerate_response => 'Згенерувати відповідь знову';

  @override
  String get remove_attachment => 'Прибрати вкладення';

  @override
  String get rename => 'Перейменувати';

  @override
  String get rename_chat => 'Перейменувати чат';

  @override
  String get rename_project => 'Перейменувати проєкт';

  @override
  String get rename_space => 'Перейменувати розділ';

  @override
  String rename_2(Object projectName) {
    return 'Перейменувати $projectName';
  }

  @override
  String rename_3(Object name) {
    return 'Перейменувати $name';
  }

  @override
  String get replace => 'Замінити';

  @override
  String get repositories => 'Репозиторії';

  @override
  String
  get research_the_attached_content_verify_the_important_claims_and_cite =>
      'Досліди вміст вкладення, перевір важливі твердження й наведи джерела.';

  @override
  String research_this_content_verify_the_important_claims_and_cite_sources(
    Object text,
  ) {
    return 'Досліди цей вміст, перевір важливі твердження й наведи джерела:\n\n$text';
  }

  @override
  String reset_failed_the_secure_storage_may_need_reinstall(Object retryError) {
    return 'Скидання не вдалося: $retryError. Можливо, потрібно перевстановити захищене сховище.';
  }

  @override
  String get reset_saved_connections => 'Скинути збережені підключення';

  @override
  String get responding => 'Відповідає…';

  @override
  String response_closed_locally_gateway_stop_failed(Object error) {
    return 'Відповідь закрито локально; зупинка на шлюзі не вдалася: $error';
  }

  @override
  String get response_closed_locally_no_active_gateway_turn_was_found =>
      'Відповідь закрито локально; активного ходу на шлюзі не знайдено.';

  @override
  String get response_complete => 'Відповідь завершено';

  @override
  String get response_complete_description =>
      'Хід завершився, поки застосунок був у фоні.';

  @override
  String get response_ready => 'Відповідь готова';

  @override
  String get response_stopped => 'Відповідь зупинено.';

  @override
  String get restore => 'Відновити';

  @override
  String get restore_configuration => 'Відновити конфігурацію';

  @override
  String get restore_project => 'Відновити проєкт';

  @override
  String get retry => 'Повторити';

  @override
  String retry_failed_for_the_draft_and_prompt_were_kept(Object name) {
    return 'Повторна спроба для $name не вдалася. Чернетку й запит збережено.';
  }

  @override
  String get retry_upload => 'Повторити надсилання';

  @override
  String retrying(Object name) {
    return 'Повторне надсилання $name…';
  }

  @override
  String get review_local_spaces => 'Переглянути локальні розділи';

  @override
  String get review_or_promote_quick_chats_past_their_retention_period =>
      'Перегляньте швидкі чати після завершення строку зберігання або перенесіть їх до проєкту';

  @override
  String get review_the_attached_content => 'Переглянь вміст вкладення.';

  @override
  String get run_only_this_command => 'Виконати лише цю команду.';

  @override
  String get running_now => 'Зараз виконується';

  @override
  String get save => 'Зберегти';

  @override
  String get save_changes => 'Зберегти зміни';

  @override
  String get save_a_permanent_rule_in_the_hermes_configuration =>
      'Зберегти постійне правило в конфігурації Hermes.';

  @override
  String get save_the_durable_facts_from_the_attached_content_to_memory =>
      'Збережи важливі довготривалі відомості зі вкладення в пам’яті й підтвердь, що саме збережено.';

  @override
  String save_the_durable_facts_from_this_content_to_memory_then(Object text) {
    return 'Збережи важливі довготривалі відомості з цього вмісту в пам’яті й підтвердь, що саме збережено:\n\n$text';
  }

  @override
  String get save_your_connections_and_settings_to_an_encrypted_file_then =>
      'Збережіть підключення й налаштування в зашифрованому файлі, щоб відновити їх після перевстановлення або на іншому пристрої.';

  @override
  String save_2(Object filename) {
    return 'Зберегти $filename';
  }

  @override
  String get schedule => 'Розклад';

  @override
  String get scheduled_jobs_and_their_last_runs =>
      'Завдання за розкладом та останні запуски';

  @override
  String get scheduled_tasks => 'Заплановані завдання';

  @override
  String get script_only_no_agent => 'Лише скрипт (без агента)';

  @override
  String get scroll_horizontally => 'Прокручувати горизонтально';

  @override
  String get search_all_chats => 'Пошук усіх чатів';

  @override
  String get search_all_message_content => 'Пошук у всьому вмісті повідомлень';

  @override
  String get search_chats => 'Пошук чатів';

  @override
  String get search_conversations => 'Пошук розмов';

  @override
  String get search_loaded_chats => 'Пошук завантажених чатів';

  @override
  String get search_mode => 'Режим пошуку';

  @override
  String get select_one_option_or_enter_another_answer =>
      'Виберіть один варіант або введіть іншу відповідь.';

  @override
  String get select_one_or_more_options_then_continue =>
      'Виберіть один чи кілька варіантів і продовжуйте.';

  @override
  String get select_text => 'Виділити текст';

  @override
  String get send => 'Надіслати';

  @override
  String send_failed(Object error) {
    return 'Не вдалося надіслати: $error';
  }

  @override
  String send_failed_api_only_permission_denied(Object error) {
    return 'Не вдалося надіслати: $error. Сервер відхилив цей запис для ключа API. Якщо цей чат належить Dashboard, додавання імені користувача та пароля Dashboard для цього підключення може дозволити надсилання; сервер також може відхиляти його навмисно.';
  }

  @override
  String get send_message => 'Надіслати повідомлення';

  @override
  String get send_test_notification => 'Надіслати тестове сповіщення';

  @override
  String get session_sources => 'Джерела сесій';

  @override
  String get session_deleted_from_remote_hermes =>
      'Сесію видалено з історії на сервері Hermes.';

  @override
  String session_search_failed(Object error) {
    return 'Помилка пошуку сесій: $error';
  }

  @override
  String get set_profile_default => 'Зробити типовою для профілю';

  @override
  String get settings => 'Налаштування';

  @override
  String get share_to_hermes => 'Поділитися з Hermes';

  @override
  String get show_passphrase => 'Показати парольну фразу';

  @override
  String get show_tool_calls_thinking_and_message_metadata =>
      'Показувати інструменти, міркування, завдання та подробиці повідомлень у згорнутих блоках. Якщо вимкнено, видно лише розмову.';

  @override
  String get signal_messages => 'Повідомлення Signal';

  @override
  String get skills => 'Навички';

  @override
  String skills_2(Object count) {
    return 'Навички ($count)';
  }

  @override
  String get skills_and_tools => 'Навички й інструменти';

  @override
  String get skip => 'Пропустити';

  @override
  String get slack_chats => 'Чати Slack';

  @override
  String source(Object source) {
    return 'Джерело: $source';
  }

  @override
  String get space_actions => 'Дії розділу';

  @override
  String get spaces => 'Розділи';

  @override
  String get speak_to_hermes => 'Говорити до Hermes';

  @override
  String get speech_recognition_is_unavailable =>
      'Розпізнавання мовлення недоступне';

  @override
  String get spoken_replies => 'Голосові відповіді';

  @override
  String get spoken_replies_off => 'Голосові відповіді вимкнено';

  @override
  String get spoken_replies_on => 'Голосові відповіді ввімкнено';

  @override
  String get stalled_no_update_from_hermes =>
      'Очікування затягнулося — немає оновлень від Hermes';

  @override
  String get start_something_new => 'Почати щось нове';

  @override
  String get start_voice_input => 'Почати голосовий ввід';

  @override
  String get starting_hermes => 'Hermes починає відповідь…';

  @override
  String get media_card_download => 'Завантажити файл';

  @override
  String get media_card_tap_to_download => 'Торкніться, щоб завантажити';

  @override
  String get still_loading_your_projects => 'Проєкти ще завантажуються.';

  @override
  String get stop => 'Зупинити';

  @override
  String get stop_response => 'Зупинити відповідь';

  @override
  String get stop_voice_input => 'Зупинити голосовий ввід';

  @override
  String get submitted_waiting_for_hermes => 'Надіслано, очікування Hermes';

  @override
  String get suggest_projects_and_learn_from_your_corrections =>
      'Пропонувати проєкти й навчатися на ваших виправленнях';

  @override
  String get summarize_the_attached_content => 'Підсумуй вміст вкладення.';

  @override
  String summarize_this_content(Object text) {
    return 'Підсумуй цей вміст:\n\n$text';
  }

  @override
  String get switch_profile => 'Змінити профіль';

  @override
  String get system => 'Системний';

  @override
  String get take_photo => 'Зробити фото';

  @override
  String get tap_to_add_a_remote_hermes_gateway_api_server_port =>
      'Натисніть +, щоб додати віддалений шлюз Hermes\n(API-сервер, порт 8642)';

  @override
  String get tap_the_button_to_start_a_new_chat =>
      'Натисніть +, щоб почати новий чат';

  @override
  String get telegram_messages => 'Повідомлення Telegram';

  @override
  String get terminal_sessions => 'Сесії термінала';

  @override
  String get test_notification_body =>
      'Якщо ви це бачите, системні сповіщення працюють.';

  @override
  String get test_notification_sent => 'Тестове сповіщення надіслано.';

  @override
  String get test_notification_title => 'Перевірка сповіщень Hermes';

  @override
  String get test_notification_unsupported =>
      'Не вдалося надіслати сповіщення — перевірте системний дозвіл сповіщень.';

  @override
  String get text_size => 'Розмір тексту';

  @override
  String get text_size_preview => 'Попередній перегляд розміру тексту';

  @override
  String text_size_2(Object label) {
    return 'Розмір тексту: $label';
  }

  @override
  String get the_api_key_could_not_be_stored_securely =>
      'Не вдалося безпечно зберегти ключ API.';

  @override
  String get the_project_will_move_to_archived_its_chats_and_files =>
      'Проєкт переміститься до архіву. Чати й файли збережуться; відновити проєкт можна будь-коли.';

  @override
  String get the_project_will_move_to_archived_its_chats_and_files_2 =>
      'Проєкт переміститься до архіву. Чати й файли збережуться; відновити проєкт можна пізніше.';

  @override
  String get the_active_profile_did_not_return_any_selectable_models =>
      'Активний профіль не повернув моделей для вибору.';

  @override
  String get the_backup_could_not_be_exported =>
      'Не вдалося експортувати резервну копію.';

  @override
  String get the_backup_could_not_be_restored =>
      'Не вдалося відновити резервну копію.';

  @override
  String get the_connection_could_not_be_deleted_safely =>
      'Не вдалося безпечно видалити підключення.';

  @override
  String get the_connection_could_not_be_stored_securely =>
      'Не вдалося безпечно зберегти підключення.';

  @override
  String get the_dashboard_credentials_could_not_be_stored_securely =>
      'Не вдалося безпечно зберегти облікові дані вебпанелі.';

  @override
  String get the_detached_reply_failed =>
      'Фонова відповідь завершилася помилкою.';

  @override
  String the_detached_reply_failed_2(Object error) {
    return 'Фонова відповідь завершилася помилкою: $error';
  }

  @override
  String get the_file_contains_your_api_keys_and_dashboard_password_so =>
      'Файл містить ключі API та пароль вебпанелі, тому його зашифровано. Без цієї парольної фрази відновлення неможливе.';

  @override
  String get the_last_turn_failed => 'Останній хід завершився помилкою';

  @override
  String the_local_connection_store_looks_damaged_you_can_reset_the(
    Object errorType,
  ) {
    return 'Локальне сховище підключень виглядає пошкодженим ($errorType). Можна скинути збережені підключення й налаштувати їх заново. Чати на шлюзі не постраждають.';
  }

  @override
  String get the_model_only_rewrites_your_question_into_a_short_full =>
      'Модель лише переформульовує ваше запитання в короткий повнотекстовий запит. Hermes використовує облікові дані провайдера, уже налаштовані на сервері.';

  @override
  String get the_server_has_not_reported_folders_for_this_project_yet =>
      'Сервер ще не надав папок цього проєкту. Загальний перегляд файлів доступний у розділі «Ще».';

  @override
  String get the_turn_failed => 'Хід завершився помилкою';

  @override
  String get the_two_passphrases_do_not_match =>
      'Парольні фрази не збігаються.';

  @override
  String get the_value_is_sent_directly_to_the_active_hermes_gateway =>
      'Значення надсилається безпосередньо до активного шлюзу Hermes і не зберігається цим Android-застосунком.';

  @override
  String get there_are_no_visible_files_in_this_server_folder =>
      'У цій папці сервера немає видимих файлів.';

  @override
  String get thinking_effort => 'Рівень міркувань';

  @override
  String get this_hermes_gateway_does_not_support_opening_a_project_yet =>
      'Цей шлюз Hermes ще не підтримує відкриття проєктів. Оновіть Hermes на сервері для перегляду проєктів із телефона.';

  @override
  String get this_hermes_gateway_is_older_than_server_side_projects_so =>
      'Цей шлюз Hermes не підтримує серверні проєкти, тому групування чатів зберігається лише на цьому пристрої. Оновіть Hermes для спільних проєктів на всіх пристроях.';

  @override
  String get this_project_has_no_folder_to_open_the_chat_in =>
      'Для створення чату в цьому проєкті потрібна папка. Додайте її та повторіть спробу.';

  @override
  String get this_chat_has_no_messages_available_in_the_desktop_session =>
      'У цій серверній сесії ще немає доступних повідомлень.';

  @override
  String get this_creates_a_permanent_rule_in_hermes_review_the_full =>
      'Ця дія створює постійне правило Hermes. Перед підтвердженням перегляньте повну команду.';

  @override
  String get this_gateway_does_not_host_projects_yet_update_the_gateway =>
      'Цей шлюз ще не підтримує проєкти. Оновіть його для впорядкування чатів на всіх пристроях.';

  @override
  String get this_permanently_deletes_the_project_chats_will_not_be_deleted =>
      'Проєкт буде видалено назавжди. Чати залишаться та повернуться до розділу «Без проєкту».';

  @override
  String get this_server_doesn_t_offer_background_recovery_chats_run_live =>
      'Цей сервер не підтримує фонове відновлення — чати працюють у живому режимі';

  @override
  String get this_week => 'Цього тижня';

  @override
  String get titles_previews_and_models => 'Назви, прев’ю й моделі';

  @override
  String get tool_activity => 'Інструменти';

  @override
  String get trigger_now => 'Запустити зараз';

  @override
  String get received_outcome_unknown =>
      'Хід завершено — результат не підтверджено';

  @override
  String get turn_completed => 'Хід завершено';

  @override
  String get turn_failed => 'Хід завершився помилкою';

  @override
  String get turn_failed_description => 'Фоновий хід завершився помилкою.';

  @override
  String get turn_recovery_failed => 'Не вдалося відновити хід';

  @override
  String get unable_to_prepare_this_file_try_another_one =>
      'Не вдалося підготувати файл. Спробуйте інший.';

  @override
  String get unable_to_prepare_this_image_try_another_one =>
      'Не вдалося підготувати зображення. Спробуйте інше.';

  @override
  String unable_to_prepare(Object name) {
    return 'Не вдалося підготувати $name.';
  }

  @override
  String get unable_to_read_the_selected_image_the_selection_was_kept =>
      'Не вдалося прочитати вибране зображення. Вибір збережено.';

  @override
  String get unassigned => 'Без проєкту';

  @override
  String get unassigned_chats => 'Чати без проєкту';

  @override
  String get untitled_chat => 'Чат без назви';

  @override
  String get untitled_session => 'Сесія без назви';

  @override
  String get update_api_key => 'Оновити ключ API';

  @override
  String get upload_failed => 'Надсилання не вдалося';

  @override
  String get upload_failed_tap_retry =>
      'Надсилання не вдалося • торкніться для повтору';

  @override
  String uploading(Object index, Object name, Object total) {
    return 'Надсилання $index/$total: $name';
  }

  @override
  String get use_as_is => 'Використати як є';

  @override
  String get use_at_least_8_characters => 'Використайте щонайменше 8 символів.';

  @override
  String get use_for_cron_jobs_backed_by_scripts =>
      'Для завдань за розкладом на основі скриптів.';

  @override
  String get use_on_device => 'Використати локально';

  @override
  String get use_the_attached_content_to_identify_and_fill_the_relevant =>
      'Використай вкладення, щоб визначити та заповнити відповідні поля документа чи форми. Перед будь-яким надсиланням запитай.';

  @override
  String use_this_content_to_identify_and_fill_the_relevant_document(
    Object text,
  ) {
    return 'Використай цей вміст, щоб визначити та заповнити відповідні поля документа чи форми. Перед будь-яким надсиланням запитай:\n\n$text';
  }

  @override
  String get used_for_hosted_path_prefixes_and_for_the_settings_memory =>
      'Для префіксів шляхів і вкладок налаштувань, пам’яті, навичок та розкладу. Для відкритої вебпанелі залиште ім’я й пароль порожніми; якщо авторизацію додає проксі, увімкніть відповідний режим.';

  @override
  String get username_optional => 'Ім’я користувача (необов’язково)';

  @override
  String using(Object displayName) {
    return 'Використовується $displayName…';
  }

  @override
  String get verbose_mode => 'Розширений режим';

  @override
  String get message_metadata => 'Подробиці повідомлення';

  @override
  String get voice => 'Голос';

  @override
  String voice_setup_failed(Object error) {
    return 'Не вдалося налаштувати голос: $error';
  }

  @override
  String get waiting_for_your_input => 'Очікує вашої відповіді';

  @override
  String get what_hermes_knows_how_to_do => 'Що вміє Hermes';

  @override
  String get what_should_the_agent_do => 'Що має зробити агент?';

  @override
  String get whatsapp_messages => 'Повідомлення WhatsApp';

  @override
  String get which_project => 'Який проєкт?';

  @override
  String get workspace => 'Робочий простір';

  @override
  String get wrap_lines => 'Переносити рядки';

  @override
  String you_can_attach_up_to_items(Object maxRemoteAttachmentDrafts) {
    return 'Можна додати до $maxRemoteAttachmentDrafts вкладень.';
  }

  @override
  String get your_answer => 'Ваша відповідь';

  @override
  String get e_g_dashboard => 'наприклад, /dashboard';

  @override
  String get e_g_dashboard_proxy_path_before_api =>
      'наприклад, /dashboard (шлях проксі перед /api/)';

  @override
  String get e_g_profile_peter => 'наприклад, /profile/peter';

  @override
  String get e_g_sol => 'наприклад, sol';

  @override
  String get e_g_0_9_or_every_2h => 'наприклад, 0 9 * * * або every 2h';

  @override
  String get e_g_daily_backup => 'наприклад, Щоденна резервна копія';

  @override
  String downloaded(Object filename) {
    return '$filename завантажено';
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
      '192.168.1.50, 100.x.y.z або hermes-machine.tailnet.ts.net';

  @override
  String get example_profile_prefix_hint_full =>
      'наприклад, /profile/peter (шлях проксі перед /api/ та /v1/)';

  @override
  String and_more(Object count) {
    return 'та ще $count';
  }

  @override
  String chats_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count чату',
      many: '$count чатів',
      few: '$count чати',
      one: '$count чат',
    );
    return '$_temp0';
  }

  @override
  String on_this_device_only(Object chats) {
    return '$chats · лише на цьому пристрої';
  }

  @override
  String spaces_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count розділу',
      many: '$count розділів',
      few: '$count розділи',
      one: '$count розділ',
    );
    return '$_temp0';
  }

  @override
  String get no_new_projects_needed => 'нові проєкти не потрібні';

  @override
  String projects_to_create(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count проєкту для створення',
      many: '$count проєктів для створення',
      few: '$count проєкти для створення',
      one: '$count проєкт для створення',
    );
    return '$_temp0';
  }

  @override
  String chats_migrated_projects_created(
    Object createdProjects,
    Object linkedSessions,
  ) {
    return 'Перенесено чатів: $linkedSessions · створено проєктів: $createdProjects';
  }

  @override
  String chats_stayed_in_local_spaces(Object unlinkedSessions) {
    return '$unlinkedSessions чатів залишилися в локальних розділах; повторна спроба безпечна.';
  }

  @override
  String model_recommended(Object provider) {
    return '$provider • Рекомендовано: невелика й недорога';
  }

  @override
  String session_meta(Object count, Object model, Object time) {
    return '$count повід. • $model • $time';
  }

  @override
  String model_scope_label(Object model, Object scope) {
    return '$model • $scope';
  }

  @override
  String get this_chat => 'цей чат';

  @override
  String get profile_default => 'типова для профілю';

  @override
  String minutes_ago(Object count) {
    return '$count хв тому';
  }

  @override
  String hours_ago(Object count) {
    return '$count год тому';
  }

  @override
  String days_ago(Object count) {
    return '$count дн тому';
  }

  @override
  String get now_label => 'зараз';

  @override
  String get latest_label => 'Останнє';

  @override
  String new_count_indicator(Object count) {
    return '$count нових';
  }

  @override
  String new_messages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count нового повідомлення',
      many: '$count нових повідомлень',
      few: '$count нові повідомлення',
      one: '$count нове повідомлення',
    );
    return '$_temp0';
  }

  @override
  String activity_failed_summary(Object failures, Object total) {
    return 'Помилок: $failures • усього: $total';
  }

  @override
  String activity_completed_summary(Object count) {
    return 'Завершено: $count';
  }

  @override
  String tool_start_observed(Object time) {
    return 'Початок зафіксовано о $time (місцевий час)';
  }

  @override
  String tool_last_observed(Object time) {
    return 'Востаннє зафіксовано о $time (місцевий час)';
  }

  @override
  String tool_result_recorded(Object time) {
    return 'Результат записано о $time (місцевий час)';
  }

  @override
  String get tool_time_unavailable => 'Час недоступний';

  @override
  String get hermes_is_using_a_tool => 'Hermes використовує інструмент';

  @override
  String hermes_is_using_tools(Object count) {
    return 'Hermes використовує інструменти: $count';
  }

  @override
  String delegated_tasks_completed(Object count) {
    return 'Завершено делегованих завдань: $count';
  }

  @override
  String delegated_tasks_active(Object count) {
    return 'Активних делегованих завдань: $count';
  }

  @override
  String branch_main(Object label) {
    return '$label · основна';
  }

  @override
  String get you_heading => '## Ви';

  @override
  String get hermes_heading => '## Hermes';

  @override
  String get action_label => 'Дія';

  @override
  String get destination_label => 'Призначення';

  @override
  String get markdown_source => 'Вихідний текст';

  @override
  String get preview_label => 'Перегляд';

  @override
  String get share_action_summarize => 'Підсумувати';

  @override
  String get share_action_explain => 'Пояснити';

  @override
  String get share_action_research => 'Дослідити';

  @override
  String get share_action_remember => 'Запам’ятати';

  @override
  String get text_size_small => 'Малий';

  @override
  String get text_size_default => 'Типовий';

  @override
  String get text_size_large => 'Великий';

  @override
  String get text_size_extra_large => 'Дуже великий';

  @override
  String get text_size_use_system_description =>
      'Використовувати системний розмір тексту Android без змін.';

  @override
  String text_size_percent_description(Object percent) {
    return '$percent% від системного розміру тексту Android.';
  }

  @override
  String text_size_label_description(Object description, Object label) {
    return '$label — $description';
  }

  @override
  String files_skipped(Object count) {
    return 'Пропущено файлів: $count. Причина: кількість, розмір, неможливість читання або чутлива назва.';
  }

  @override
  String model_scope_applied(Object effort, Object model) {
    return '$model • $effort тепер діють лише для цього чату.';
  }

  @override
  String get reasoning_minimal => 'Мінімальний';

  @override
  String get reasoning_low => 'Низький';

  @override
  String get reasoning_medium => 'Середній';

  @override
  String get reasoning_high => 'Високий';

  @override
  String get reasoning_max => 'Максимальний';

  @override
  String get reasoning_ultra => 'Ультра';

  @override
  String get status_running => 'Виконується';

  @override
  String get status_failed => 'Помилка';

  @override
  String get status_done => 'Готово';

  @override
  String get status_idle => 'Очікує';

  @override
  String get upload_status_uploading => 'Надсилання';

  @override
  String get upload_status_uploaded => 'Надіслано';

  @override
  String attachment_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count вкладення',
      many: '$count вкладень',
      few: '$count вкладення',
      one: '$count вкладення',
    );
    return '$_temp0';
  }

  @override
  String get action_create => 'створити';

  @override
  String get action_rename => 'перейменувати';

  @override
  String get action_archive => 'архівувати';

  @override
  String get action_restore => 'відновити';

  @override
  String get action_delete => 'видалити';

  @override
  String get migrate => 'Перенести';

  @override
  String assigned_chats(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count чату в проєкті',
      many: '$count чатів у проєкті',
      few: '$count чати в проєкті',
      one: '$count чат у проєкті',
    );
    return '$_temp0';
  }

  @override
  String get date_today => 'Сьогодні';

  @override
  String get date_yesterday => 'Учора';

  @override
  String get date_earlier => 'Раніше';

  @override
  String get nav_home => 'Головна';

  @override
  String get nav_more => 'Ще';

  @override
  String get status_completed => 'Завершено';

  @override
  String get filter_all => 'Усі';

  @override
  String get filter_recent => 'Нещодавні';

  @override
  String connection_address_key(Object address, Object status) {
    return '$address  •  Ключ: $status';
  }

  @override
  String model_via_provider(Object model, Object provider) {
    return '$model\nчерез `$provider`';
  }

  @override
  String get deny => 'Відхилити';

  @override
  String get connect => 'Підключити';

  @override
  String get appearance => 'Вигляд';

  @override
  String get connection_section => 'Підключення';

  @override
  String get about => 'Про застосунок';

  @override
  String version_label(Object version) {
    return 'Версія $version';
  }

  @override
  String get matched => 'Збігається';

  @override
  String get search => 'Пошук';

  @override
  String get on => 'Увімкнено';

  @override
  String get off => 'Вимкнено';

  @override
  String get reasoning_off => 'Вимкнено';

  @override
  String get hermes_response_ready => 'Відповідь Hermes готова';

  @override
  String get admin_password_needed => 'Потрібен пароль адміністратора';

  @override
  String get hermes_needs_a_sudo_password_for_the_pending_terminal_command =>
      'Hermes потрібен пароль sudo для очікуваної команди термінала.';

  @override
  String get sudo_password => 'Пароль sudo';

  @override
  String get secret_needed => 'Потрібен секрет';

  @override
  String get hermes_needs_a_secret_for_the_pending_skill =>
      'Hermes потрібен секрет для очікуваної навички.';

  @override
  String get secret_value => 'Значення секрету';

  @override
  String get attached_file => 'Прикріплений файл';

  @override
  String get pin_chat => 'Закріпити чат';

  @override
  String get unpin_chat => 'Відкріпити чат';

  @override
  String get pinned_chats => 'Закріплені';

  @override
  String could_not_update_chat_pin(Object error) {
    return 'Не вдалося змінити закріплення чату: $error';
  }

  @override
  String get could_not_save_chat_spaces =>
      'Не вдалося зберегти розділи чатів на цьому пристрої';

  @override
  String get chat_density => 'Щільність чату';

  @override
  String chat_density_2(Object label) {
    return 'Щільність чату: $label';
  }

  @override
  String get chat_density_comfortable => 'Зручна';

  @override
  String get chat_density_compact => 'Компактна';

  @override
  String get chat_density_comfortable_description =>
      'Просторіші повідомлення з підписом автора над кожним.';

  @override
  String get chat_density_compact_description =>
      'Щільніші повідомлення без підписів, щоб більше тексту вміщалося на екрані.';

  @override
  String chat_density_label_description(Object description, Object label) {
    return '$label — $description';
  }

  @override
  String
  get compact_removes_the_you_and_hermes_labels_and_trims_bubble_padding_spacing_and_side_margins =>
      'Компактний режим прибирає підписи «Ви» й «Hermes» та зменшує внутрішні, міжрядкові й бічні відступи повідомлень.';

  @override
  String get client_certificate_mtls => 'Клієнтський сертифікат (mTLS)';

  @override
  String get client_certificate_mtls_description =>
      'Надавати сертифікат, коли HTTPS-проксі вимагає взаємного TLS.';

  @override
  String get client_certificate_https_only =>
      'Клієнтські сертифікати використовуються лише для HTTPS-підключень.';

  @override
  String get choose_certificate => 'Вибрати сертифікат';

  @override
  String get certificate_password => 'Пароль сертифіката';

  @override
  String get this_certificate_is_password_protected =>
      'Цей сертифікат захищений паролем. Він відкривається під час введення.';

  @override
  String get enter_the_certificate_password_to_finish_loading_it =>
      'Введіть пароль сертифіката, щоб завершити завантаження.';

  @override
  String get client_certificate_required =>
      'Завантажте клієнтський сертифікат або вимкніть його використання.';

  @override
  String client_certificate_loaded(String label) {
    return 'Завантажено: $label';
  }

  @override
  String get remove_certificate => 'Прибрати сертифікат';

  @override
  String get certificate_import_failed => 'Не вдалося завантажити сертифікат.';

  @override
  String get background_work => 'Фонова робота';

  @override
  String get keep_chats_active_in_background => 'Підтримувати чати у фоні';

  @override
  String get background_work_description =>
      'Зберігати підключення розпочатих вами чатів, поки застосунок у фоні. Неактивні підключення можуть закриватися. Витрачає більше заряду й трафіку. Вимкнення не зупиняє роботу сервера.';

  @override
  String get background_work_limits =>
      'Android може призупинити підключення в режимі Doze або завершити процес застосунку. Для сповіщень після завершення процесу потрібне окреме налаштування push. Примусова зупинка не підтримується.';

  @override
  String get background_work_disclosure =>
      'Поки захист фонової роботи активний, обов’язкове службове сповіщення залишається видимим, навіть якщо сповіщення чатів вимкнено.';

  @override
  String get battery_optimisation_settings => 'Налаштування економії заряду';

  @override
  String get battery_optimisation_description =>
      'Відкрити налаштування Android для перегляду обмежень батареї. Автоматичного запиту винятків немає; зміна налаштувань не гарантує доставку.';

  @override
  String get battery_settings_unavailable =>
      'Не вдалося відкрити налаштування батареї на цьому пристрої.';

  @override
  String get background_work_save_failed =>
      'Не вдалося зберегти налаштування фонової роботи.';

  @override
  String get ongoing_chat_channel_name => 'Активні чати';

  @override
  String get ongoing_chat_channel_description =>
      'Тихі оновлення стану незавершених чатів, розпочатих користувачем';

  @override
  String get task_timeline => 'Хронологія завдання';

  @override
  String get task_refresh_history => 'Оновити історію завдання';

  @override
  String get task_live_preview =>
      'Поточний перегляд із подій батьківського чату';

  @override
  String get task_preview_explanation =>
      'Лише останнє доступне прев’ю; це не збережений рядок історії.';

  @override
  String get task_preview => 'Перегляд';

  @override
  String get task_recorded_history => 'Збережена історія завдання';

  @override
  String get task_loading_history => 'Завантаження історії завдання…';

  @override
  String get task_empty_history =>
      'Збережених повідомлень ще немає. Завдання могло ще не записати історію; це не означає, що воно нічого не зробило.';

  @override
  String get task_load_older => 'Завантажити старіші';

  @override
  String get task_default_goal => 'Делеговане завдання';

  @override
  String task_status(Object status) {
    return 'Стан: $status';
  }

  @override
  String task_identity(Object id) {
    return 'Завдання: $id';
  }

  @override
  String task_stored_session(Object id) {
    return 'Збережена сесія: $id';
  }

  @override
  String task_delegation(Object id) {
    return 'Делегування: $id';
  }

  @override
  String get task_read_only_notice =>
      'Лише для читання · історія може з’явитися після запису завданням. Оновіть для перевірки.';

  @override
  String task_row_label(Object id, Object role) {
    return '$role · рядок $id';
  }

  @override
  String get task_role_assistant => 'Асистент';

  @override
  String get task_role_user => 'Користувач';

  @override
  String get task_role_tool => 'Інструмент';

  @override
  String task_tool_call(Object name) {
    return 'Виклик інструмента · $name';
  }

  @override
  String task_tool_result(Object name) {
    return 'Результат інструмента · $name';
  }

  @override
  String task_call_details(Object arguments, Object id) {
    return 'ID виклику: $id\nАргументи\n$arguments';
  }

  @override
  String task_result_details(Object id, Object result) {
    return 'ID виклику: $id\nРезультат\n$result';
  }

  @override
  String get task_not_supplied => 'Не надано';

  @override
  String get task_missing_arguments => 'Сервер не зберіг аргументи.';

  @override
  String get task_image_placeholder => '[зображення]';

  @override
  String get task_invalid_reference =>
      'Історія завдання недоступна: некоректне посилання на збережену сесію.';

  @override
  String get task_auth_required =>
      'Історія завдання недоступна: налаштуйте вхід до вебпанелі цього шлюзу. Ключ API-сервера не дає доступу до міркувань завдання.';

  @override
  String get task_auth_rejected =>
      'Історія завдання недоступна: вебпанель відхилила авторизацію. Перевірте налаштування вебпанелі цього шлюзу.';

  @override
  String get task_incompatible_history =>
      'Історія завдання недоступна: вебпанель не надає сумісної обмеженої історії для вибраного профілю.';

  @override
  String get task_identity_unproven =>
      'Історія завдання недоступна: вебпанель не підтвердила точну збережену сесію чи її ланцюжок стискання. Історія іншої сесії не показується.';

  @override
  String get task_partial_compression =>
      'Неповна історія: завдання продовжилося після стискання, але шлюз не надав перевірюваного нового посилання. Останньої відповіді може бракувати. Автоматичне оновлення призупинено; натисніть «Оновити» для повтору.';

  @override
  String get task_partial_ancestors =>
      'Неповна історія: шлюз не надає попередні частини завдання до стискання. Відомі рядки збережено; натисніть «Оновити» для повтору.';

  @override
  String get task_missing_reference =>
      'Історія завдання недоступна: сервер не зберіг посилання на сесію.';

  @override
  String get task_missing_row_identity =>
      'Історія завдання недоступна: сервер не надав постійних ідентифікаторів рядків повідомлень.';

  @override
  String get task_history_not_ready =>
      'Історія завдання ще недоступна (HTTP 404). Можливо, завдання ще не записало історію або вебпанель не підтримує її. Повторіть спробу.';

  @override
  String get task_refresh_failed =>
      'Не вдалося оновити історію завдання. Перевірте підключення й повторіть спробу.';

  @override
  String get task_status_interrupted => 'Перервано';

  @override
  String get task_status_cancelled => 'Скасовано';

  @override
  String get task_status_requested => 'Запитано';

  @override
  String get task_status_thinking => 'Міркує';

  @override
  String get task_status_tool => 'Використовує інструмент';

  @override
  String get task_status_pending => 'Очікує';

  @override
  String get task_status_dispatched => 'Передано';

  @override
  String task_status_unknown(Object status) {
    return 'Невідомий стан: $status';
  }

  @override
  String task_tasks_finished(Object count) {
    return 'Завершено делегованих завдань: $count';
  }

  @override
  String get activity_status_unconfirmed => 'Стан не підтверджено';

  @override
  String get activity_recently_updated => 'Нещодавно оновлено';

  @override
  String get activity_reconnecting => 'Перепідключення — перевірка стану ходу';

  @override
  String get activity_outcome_unknown =>
      'Не вдалося підтвердити результат ходу. Відкрийте чат для перевірки.';

  @override
  String get activity_chat_updated_detail =>
      'Шлюз зафіксував активність чату; поточний стан роботи недоступний.';

  @override
  String get activity_updated => 'Оновлено';

  @override
  String get activity_empty_title => 'Нещодавньої активності немає';

  @override
  String get activity_empty_detail =>
      'Тут відображаються ходи, розпочаті в цьому застосунку, та чати шлюзу, оновлені за останні 7 днів.';

  @override
  String get activity_read_error =>
      'Не вдалося прочитати записи ходів або чати шлюзу. Перевірте підключення й повторіть спробу.';

  @override
  String get activity_chat_unavailable =>
      'Чат більше недоступний або немає зв’язку зі шлюзом.';

  @override
  String get activity_partial_title => 'Активність завантажено частково';

  @override
  String get activity_partial_detail =>
      'Показано обмежену частину активності шлюзу. Можуть існувати інші чати; потягніть для оновлення.';

  @override
  String get provider_usage => 'Облік використання';

  @override
  String get provider_usage_notice =>
      'Використання Hermes за останні 30 днів, а не баланс кредитів чи ціни моделей. Облікові дані провайдерів налаштовуються на сервері Hermes; застосунок не зберігає їхніх ключів API.';

  @override
  String get provider_usage_failed =>
      'Не вдалося завантажити облік використання.';

  @override
  String get provider_usage_empty =>
      'Для цього провайдера немає записів використання.';

  @override
  String provider_usage_counts(String sessions, String input, String output) {
    return 'Сесій: $sessions · Вхід: $input · Вихід: $output';
  }

  @override
  String provider_usage_costs(String estimated, String actual) {
    return 'Орієнтовно: $estimated · За звітом: $actual';
  }

  @override
  String get provider_quota_codex => 'Передплата OpenAI Codex';

  @override
  String get provider_quota_claude => 'Передплата Claude';

  @override
  String get provider_quota_openai_api => 'Облік використання OpenAI API';

  @override
  String get provider_quota_notice =>
      'Вікна передплати за даними провайдера, окремо від обліку Hermes та оплати API. Облікові записи показуються окремо; обмеження моделі не означає вичерпання всього облікового запису.';

  @override
  String get provider_quota_windows_notice =>
      'Передплати Codex і Claude мають п’ятигодинні та тижневі обмеження. Показуються лише дані провайдера; відсутні межі й час скидання лишаються невідомими. Тижневі межі можуть стосуватися облікового запису або окремих моделей.';

  @override
  String get provider_quota_five_hour_session => 'П’ятигодинна сесія';

  @override
  String get provider_quota_unavailable => 'Залишок передплати недоступний.';

  @override
  String get provider_quota_failed =>
      'Не вдалося оновити залишок передплати. Збережені значення належать до попередньої перевірки.';

  @override
  String get provider_quota_account => 'Обліковий запис';

  @override
  String get provider_quota_unknown => 'невідомо';

  @override
  String provider_quota_state(String state) {
    return 'Стан облікового запису: $state';
  }

  @override
  String provider_quota_scope(String scope) {
    return 'Область: $scope';
  }

  @override
  String provider_quota_percent(String used, String remaining) {
    return 'Використано $used% · залишилось $remaining%';
  }

  @override
  String provider_quota_reset(String reset) {
    return 'Скидання: $reset';
  }

  @override
  String get provider_quota_reset_unknown => 'Час скидання невідомий.';

  @override
  String get auxiliary_models => 'Допоміжні моделі';

  @override
  String get auxiliary_notice =>
      'Виберіть моделі для окремих завдань. Власними адресами сервісів керуйте на сервері. Автоматичний режим дотримується правил успадкування завдання.';

  @override
  String get auxiliary_inherit => 'Автоматично (успадкувати)';

  @override
  String get auxiliary_unavailable =>
      'Налаштування допоміжних моделей недоступні.';

  @override
  String get provider_oauth_title => 'Вхід до провайдера';

  @override
  String get provider_oauth_more_subtitle =>
      'Керування входом до провайдера на сервері Hermes';

  @override
  String get provider_oauth_settings_subtitle =>
      'Вхід виконується на сервері Hermes; токени не зберігаються на цьому пристрої';

  @override
  String get provider_oauth_intro =>
      'Увійдіть до провайдера в зовнішньому браузері. Токени зберігаються лише на сервері Hermes. Вхід не змінює модель чату в цьому застосунку.';

  @override
  String get provider_oauth_defaults_notice =>
      'Деякі серверні сценарії, зокрема заміна безкоштовного облікового запису Nous, можуть змінити типові налаштування. Перевірте їх на сервері після входу.';

  @override
  String get provider_oauth_transport_init_failed =>
      'Не вдалося ініціалізувати вибране захищене підключення до вебпанелі. Перевірте TLS і налаштування підключення.';

  @override
  String get provider_oauth_https_required =>
      'Для входу до провайдера потрібне HTTPS-підключення до вебпанелі Hermes.';

  @override
  String get provider_oauth_auth_required =>
      'Перед входом налаштуйте авторизацію вебпанелі паролем або довіреним проксі.';

  @override
  String get provider_oauth_catalog_failed =>
      'Вхід до провайдера недоступний на цьому сервері. Перевірте авторизацію вебпанелі й оновіть сервер, якщо він не підтримує OAuth провайдера.';

  @override
  String get provider_oauth_expired => 'Час входу минув. Почніть знову.';

  @override
  String get provider_oauth_start_failed =>
      'Не вдалося почати захищений вхід до провайдера. Спробуйте ще раз.';

  @override
  String get provider_oauth_denied => 'Вхід відхилено. Почніть знову.';

  @override
  String get provider_oauth_cancelled => 'Вхід скасовано.';

  @override
  String get provider_oauth_host_failed =>
      'Сервер не зміг завершити вхід. Почніть знову.';

  @override
  String get provider_oauth_poll_failed =>
      'Не вдалося перевірити стан входу. Почніть знову.';

  @override
  String provider_oauth_cancellation_unconfirmed(String message) {
    return '$message Скасування не підтверджено; серверна сесія може тривати до завершення строку дії.';
  }

  @override
  String get provider_oauth_browser_failed =>
      'Не вдалося відкрити зовнішній браузер. Повторіть спробу або скасуйте вхід.';

  @override
  String get provider_oauth_retry => 'Повторити';

  @override
  String provider_oauth_complete(String provider) {
    return 'Завершити вхід до $provider';
  }

  @override
  String get provider_oauth_code_instruction =>
      'Введіть цей тимчасовий код на сторінці провайдера:';

  @override
  String get provider_oauth_waiting =>
      'Очікування дозволу. Сесія завершиться автоматично.';

  @override
  String get provider_oauth_open_browser => 'Відкрити провайдера в браузері';

  @override
  String get provider_oauth_cancel => 'Скасувати вхід';

  @override
  String get provider_oauth_signed_out => 'Вхід на сервері не виконано';

  @override
  String get provider_oauth_sign_in_again => 'Увійти знову';

  @override
  String get provider_oauth_sign_in => 'Увійти';

  @override
  String get provider_oauth_cli_required =>
      'Увійдіть через CLI провайдера на сервері Hermes. Цей сервер не надає входу до цього провайдера із застосунку.';

  @override
  String get provider_oauth_checking_account =>
      'Дозвіл отримано. Перевірка облікового запису на сервері…';

  @override
  String get provider_oauth_verification_unavailable =>
      'Дозвіл отримано; перевірка облікового запису недоступна. Відкрийте «Використання», щоб оновити дані.';

  @override
  String provider_oauth_verified_account(String email) {
    return 'Вхід на сервері Hermes виконано як $email. Відкрийте «Використання», щоб оновити дані.';
  }

  @override
  String get provider_oauth_credentials_unverified =>
      'Сервер повідомляє про наявність облікових даних; особу облікового запису не підтверджено.';

  @override
  String get provider_oauth_account_status_unknown =>
      'Стан облікового запису на сервері недоступний.';

  @override
  String get app_language => 'Мова застосунку';

  @override
  String get app_language_system => 'Як на телефоні';

  @override
  String get auto_archives_after_72_hours =>
      'Автоматично архівується через 72 години';

  @override
  String get automation => 'Автоматизація';

  @override
  String get voice_recording_start => 'Записати голосове повідомлення';

  @override
  String get voice_recording_pause => 'Призупинити запис';

  @override
  String get voice_recording_preview => 'Відтворити запис';

  @override
  String get voice_recording_resume => 'Продовжити запис';

  @override
  String get voice_recording_send => 'Надіслати голосове повідомлення';

  @override
  String get voice_recording_discard => 'Відкинути запис';

  @override
  String get voice_recording_processing =>
      'Підготовка голосового повідомлення…';

  @override
  String voice_recording_elapsed(String time) {
    return 'Запис $time';
  }

  @override
  String voice_recording_draft(String time) {
    return 'Голосове повідомлення $time';
  }

  @override
  String get voice_recording_permission =>
      'Дозвольте доступ до мікрофона, щоб записати голосове повідомлення.';

  @override
  String get voice_recording_limit => 'Цей запис досяг межі в десять хвилин.';

  @override
  String get voice_recording_empty => 'Звук не записано. Спробуйте ще раз.';

  @override
  String get voice_recording_failed =>
      'Не вдалося обробити запис. Усі збережені фрагменти залишено.';

  @override
  String get voice_recording_unconfirmed =>
      'Доставку не підтверджено. Ваш запис збережено. Перевірте чат, перш ніж повторювати спробу.';

  @override
  String get voice_recording_submit_failed =>
      'Не вдалося надіслати голосове повідомлення. Ваш запис збережено. Перевірте підключення, доступ до вебпанелі й налаштування розпізнавання мовлення на сервері.';

  @override
  String get voice_recording_pause_playback => 'Призупинити відтворення';

  @override
  String get projects_root_title => 'Папка проєктів на сервері';

  @override
  String get projects_root_more_subtitle =>
      'Де на сервері створюються нові папки проєктів';

  @override
  String get projects_root_description =>
      'Проєкти, створені на цьому телефоні, отримують папку тут. Укажіть папку, яку використовує сам Hermes, щоб телефон і сервер бачили ті самі проєкти.';

  @override
  String get projects_root_label => 'Кореневий шлях проєктів';

  @override
  String projects_root_default_hint(String path) {
    return 'Типове значення сервера: $path';
  }

  @override
  String get projects_root_locked_title => 'Задано сервером';

  @override
  String get projects_root_locked_explanation =>
      'Цей сервер обмежує доступ до файлів одним коренем, тому папку проєктів неможливо змінити з програми.';

  @override
  String get projects_root_saved => 'Папку проєктів збережено.';

  @override
  String get projects_root_reset => 'Використовувати типове значення сервера';

  @override
  String get projects_root_invalid_empty => 'Введіть шлях до папки.';

  @override
  String get projects_root_invalid_absolute =>
      'Введіть абсолютний шлях, що починається з косої риски.';

  @override
  String get projects_root_invalid_segments =>
      'Видаліть зі шляху точкові сегменти та керуючі символи.';

  @override
  String get projects_root_unsupported =>
      'Не підтримується для цього підключення. Щоб прочитати або змінити папку проєктів на сервері, потрібне підключення Desktop Gateway з доступом до панелі керування.';

  @override
  String get projects_root_unavailable =>
      'Не вдалося прочитати папку проєктів на сервері. Перевірте підключення до панелі керування та повторіть спробу.';

  @override
  String get adopt_folder_action => 'Додати наявну папку';

  @override
  String adopt_folder_description(String root) {
    return 'Папки в $root, які ще не зареєстровані як проєкт.';
  }

  @override
  String adopt_folder_registered(String name) {
    return 'Уже проєкт: $name';
  }

  @override
  String get adopt_folder_none => 'Усі папки за цим шляхом уже є проєктами.';

  @override
  String get adopt_folder_unsupported =>
      'Це підключення не може отримати список папок сервера. Введіть абсолютний шлях до наявної папки.';

  @override
  String adopt_folder_failed(String error) {
    return 'Не вдалося отримати список папок сервера: $error';
  }

  @override
  String get adopt_folder_manual_label => 'Шлях до наявної папки';

  @override
  String get adopt_folder_name_label => 'Назва проєкту';

  @override
  String get adopt_folder_add => 'Додати як проєкт';

  @override
  String adopt_folder_added(String name, String path) {
    return '$name тепер використовує $path';
  }

  @override
  String adopt_folder_error(String error) {
    return 'Не вдалося додати папку: $error';
  }

  @override
  String adopt_folder_folderless(String name) {
    return 'Проєкт $name створено, але папку не прикріплено. Прикріпіть її в Hermes на сервері.';
  }

  @override
  String get slash_commands => 'Slash commands';

  @override
  String get slash_commands_loading => 'Loading commands…';

  @override
  String get slash_commands_empty => 'No matching commands';

  @override
  String slash_command_info_alias(String alias, String command) {
    return '$alias — псевдонім для $command';
  }

  @override
  String get slash_command_info_no_description => 'Опис недоступний.';

  @override
  String get slash_command_info_arguments_options =>
      'Приймає один із фіксованих варіантів.';

  @override
  String get slash_command_info_arguments_text =>
      'Приймає текст після команди.';

  @override
  String get slash_command_info_arguments_mixed =>
      'Приймає варіант або текст після команди.';

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
      'Ця команда недоступна на цьому сервері.';

  @override
  String get slash_sessions_inline =>
      'Відкрийте список сесій, щоб вибрати чат. Чернетку збережено.';

  @override
  String get composer_snippets => 'Шаблони запитів';

  @override
  String get composer_snippets_description =>
      'Виберіть початковий запит для вставлення в поле введення.';

  @override
  String get composer_snippet_review => 'Перевірка коду';

  @override
  String get composer_snippet_review_body =>
      'Перевірте поточні зміни на регресії, пропущені крайові випадки й відсутні тести.';

  @override
  String get composer_snippet_review_text =>
      'Будь ласка, перевір це на помилки, регресії та відсутні тести.';

  @override
  String get composer_snippet_plan => 'План реалізації';

  @override
  String get composer_snippet_plan_body =>
      'Окресліть підхід перед редагуванням коду, щоб зміни залишалися цілеспрямованими.';

  @override
  String get composer_snippet_plan_text =>
      'Будь ласка, склади стислий план реалізації перед зміною коду.';

  @override
  String get composer_snippet_explain => 'Поясни це';

  @override
  String get composer_snippet_explain_body =>
      'Поясніть, як працює вибраний код, і вкажіть основні файли.';

  @override
  String get composer_snippet_explain_text =>
      'Будь ласка, поясни, як це працює, і вкажи основні файли.';

  @override
  String get composer_status => 'Стан';

  @override
  String get composer_status_context => 'Контекст';

  @override
  String get composer_status_cache => 'Влучання в кеш';

  @override
  String get composer_status_throughput => 'Вихідних токенів/с';

  @override
  String get composer_status_running => 'Виконується';

  @override
  String get composer_status_session => 'Сесія';

  @override
  String get composer_status_not_reported => 'Не повідомлено';

  @override
  String get composer_status_empty => 'Деталізацію контексту не надано.';

  @override
  String get composer_status_loading => 'Завантаження деталізації контексту';

  @override
  String get composer_status_reset => 'Скинути рядок стану';

  @override
  String get composer_resume_title => 'Продовжити чат';

  @override
  String get composer_resume_search => 'Пошук за назвами й ідентифікаторами';

  @override
  String get composer_resume_empty => 'Відповідних чатів немає.';

  @override
  String get composer_resume_unavailable =>
      'Ця панель не має списку чатів для пошуку.';

  @override
  String get composer_failure_retry => 'Повторити';

  @override
  String composer_failure_retry_at(String time) {
    return 'Повторити о $time';
  }

  @override
  String get composer_failure_compress => 'Стиснути';

  @override
  String get composer_failure_switch_model => 'Змінити модель';

  @override
  String composer_failure_switch_to(String model) {
    return 'Перемкнути на $model';
  }

  @override
  String get composer_failure_new_chat => 'Новий чат';

  @override
  String get composer_failure_edit => 'Редагувати повідомлення';

  @override
  String get composer_failure_details => 'Подробиці';

  @override
  String get composer_failure_hide_details => 'Приховати подробиці';

  @override
  String get composer_failure_copy => 'Копіювати діагностику';

  @override
  String get composer_failure_account =>
      'Інше виправлення потрібно виконати в обліковому записі шлюзу. У цьому чаті це неможливо.';

  @override
  String get composer_failure_account_only =>
      'Це потрібно виправити в обліковому записі шлюзу. У цьому чаті це неможливо.';

  @override
  String get composer_failure_confirm_compress =>
      'Стиснути цей чат? Шлюз скоротить історію розмови.';

  @override
  String composer_failure_confirm_model(String model) {
    return 'Перемкнути цей чат на $model?';
  }

  @override
  String get composer_drop_attach => 'Перетягніть сюди, щоб прикріпити';

  @override
  String get composer_drop_folder_unsupported =>
      'Папки не можна прикріплювати. Натомість перетягніть файли.';

  @override
  String get composer_drop_reference =>
      'Перетягніть сюди, щоб додати посилання';

  @override
  String get composer_reference_copy => 'Копіювати посилання';

  @override
  String get composer_reference_remove => 'Вилучити посилання';

  @override
  String get composer_btw_usage =>
      'Використання: /btw <question> — відповідь на основі знімка цієї розмови без її переривання.';

  @override
  String get composer_background_usage =>
      'Використання: /background <prompt> — завдання виконується окремо, а результат надходить сюди.';

  @override
  String get composer_handoff_usage =>
      'Використання: /handoff <platform> — перенести цей чат на вказану платформу обміну повідомленнями.';

  @override
  String get composer_command_needs_session =>
      'Для цієї команди потрібен відкритий чат.';

  @override
  String get composer_retry_not_found =>
      'Цього ходу немає у збереженій історії, тому дія «Повторити» не може його замінити. Нічого не надіслано повторно. Відредагуйте й надішліть повідомлення для нової спроби.';

  @override
  String get composer_retry_unavailable =>
      'Дія «Повторити» не може замінити хід через це підключення, тому нічого не надіслано повторно. Відредагуйте й надішліть повідомлення для нової спроби.';

  @override
  String get composer_failure_switch_no_retry =>
      'Перемикання змінює лише модель: це з’єднання не може повторити невдалий хід. Надішліть його знову після перемикання.';

  @override
  String get composer_command_needs_gateway_session =>
      'Цей чат ще не має сесії на шлюзі. Спершу надішліть повідомлення, потім виконайте команду ще раз.';

  @override
  String get composer_side_question =>
      'btw — відповідь на основі знімка розмови';

  @override
  String composer_side_question_id(String id) {
    return 'btw $id — відповідь на основі знімка розмови';
  }

  @override
  String get composer_background_started =>
      'Фонове завдання запущено. Можете продовжувати спілкування. Результат з’явиться тут.';

  @override
  String composer_background_started_id(String id) {
    return 'Фонове завдання $id запущено. Можете продовжувати спілкування. Результат з’явиться тут.';
  }

  @override
  String composer_handoff_requested(String platform) {
    return 'Запитано перенесення до $platform.';
  }

  @override
  String composer_handoff_done(String platform) {
    return 'Цей чат перенесено до $platform.';
  }

  @override
  String get composer_handoff_failed => 'Не вдалося перенести чат.';

  @override
  String get composer_handoff_timeout =>
      'Перенесення не завершилося. Воно ще може тривати на шлюзі.';

  @override
  String get composer_compress_done => 'Цей чат стиснуто.';

  @override
  String get composer_file_missing => 'Цього файла немає на цьому пристрої.';

  @override
  String get composer_attach_busy =>
      'Вкладення можна додати після завершення цієї відповіді.';

  @override
  String get nextgen_toggle => 'Інтерфейс NextGen';

  @override
  String get nextgen_toggle_subtitle =>
      'Новий дизайн з єдиним входом, живими чатами та пошуком у мережі. Шлюзи й чати спільні з цим інтерфейсом.';

  @override
  String get nextgen_single_login => 'Увійти з одним логіном';

  @override
  String get nextgen_single_login_subtitle =>
      'Додайте шлюз лише за адресою панелі та одним входом.';

  @override
  String get ng_allow_this_command => 'Дозволити цю команду?';

  @override
  String ng_hermes_wants_to_run_this_with(Object tool) {
    return 'Hermes хоче запустити це за допомогою $tool.';
  }

  @override
  String get ng_hermes_wants_to_run_this => 'Hermes хоче запустити це.';

  @override
  String get ng_hermes_has_a_question => 'У Hermes є запитання';

  @override
  String get ng_hermes_has_questions => 'У Hermes є запитання';

  @override
  String get ng_password_for_sudo => 'Пароль для sudo';

  @override
  String get ng_hermes_needs_your_sudo_password_to =>
      'Hermes потрібен ваш пароль sudo, щоб виконати цю команду.';

  @override
  String get ng_a_secret_value => 'Конфіденційне значення';

  @override
  String ng_value_for(Object variable) {
    return 'Значення для $variable';
  }

  @override
  String get ng_your_password_manager => 'ваш менеджер паролів';

  @override
  String ng_unlock(Object name) {
    return 'Розблокувати $name';
  }

  @override
  String ng_hermes_needs_unlocked_to_sign_in(Object name) {
    return 'Щоб увійти за вас, Hermes потрібно розблокувати $name.';
  }

  @override
  String get ng_sign_in_code => 'Код входу';

  @override
  String get ng_enter_the_sign_in_code => 'Введіть код входу.';

  @override
  String ng_enter_the_sign_in_code_for(Object site) {
    return 'Введіть код входу для $site.';
  }

  @override
  String get ng_save_a_login => 'Зберегти дані для входу?';

  @override
  String ng_save_your_login(Object site) {
    return 'Зберегти дані входу для $site?';
  }

  @override
  String ng_couldn_t_load_this_chat(Object error) {
    return 'Не вдалося завантажити цей чат: $error';
  }

  @override
  String ng_live_updates_are_unavailable(Object error) {
    return 'Оновлення в реальному часі недоступні: $error';
  }

  @override
  String ng_preparing(Object name) {
    return 'Підготовка $name…';
  }

  @override
  String get ng_the_turn_failed => 'Не вдалося виконати цей запит.';

  @override
  String get ng_turn_changed => 'цей запит уже завершився або почався новіший';

  @override
  String get ng_steer_rejected => 'запит, що виконується, цього не прийняв';

  @override
  String get ng_turn_not_known_yet =>
      'запит, що виконується, ще невідомий; спробуйте ще раз за мить';

  @override
  String ng_couldn_t_stop(Object error) {
    return 'Не вдалося зупинити: $error';
  }

  @override
  String get ng_server_access => 'Доступ до сервера';

  @override
  String get ng_sign_in => 'Вхід';

  @override
  String get ng_live_connection => 'З’єднання в реальному часі';

  @override
  String get ng_check_that_tailscale_is_on_on =>
      'Переконайтеся, що Tailscale увімкнено і на цьому телефоні, і на сервері.';

  @override
  String get ng_check_the_address_and_that_the =>
      'Перевірте адресу та переконайтеся, що проксі перенаправляє запити на панель керування.';

  @override
  String get ng_use_the_same_network_as_the =>
      'Під’єднайтеся до тієї самої мережі, що й сервер, і запустіть панель керування з --host 0.0.0.0, щоб інші пристрої могли підключитися.';

  @override
  String get ng_check_the_address_vpn_or_tailscale =>
      'Перевірте адресу, VPN або з’єднання Tailscale.';

  @override
  String get ng_not_checked_yet => 'Ще не перевірено.';

  @override
  String get ng_checking => 'Перевірка…';

  @override
  String ng_hermes_answers_at(Object version, Object address) {
    return 'Hermes $version доступний за адресою $address.';
  }

  @override
  String get ng_something_answered_but_not_a_hermes =>
      'Отримано відповідь, але це не панель керування Hermes.';

  @override
  String ng_something_answered_http_but_not_a(Object status) {
    return 'Отримано відповідь (HTTP $status), але це не панель керування Hermes.';
  }

  @override
  String get ng_use_the_dashboard_s_address_and =>
      'Використовуйте адресу й порт панелі керування (9119 за замовчуванням), а не API-сервера.';

  @override
  String get ng_cloudflare_access_turned_the_service_token =>
      'Cloudflare Access відхилив токен сервісу.';

  @override
  String get ng_cloudflare_access_is_in_front_of =>
      'Перед цією адресою встановлено Cloudflare Access.';

  @override
  String get ng_check_the_service_token_and_its =>
      'Перевірте токен сервісу та політику Service Auth.';

  @override
  String get ng_add_a_cloudflare_access_service_token =>
      'Додайте токен сервісу Cloudflare Access для цієї адреси.';

  @override
  String get ng_the_server_asks_for_a_client =>
      'Сервер запитує сертифікат клієнта.';

  @override
  String get ng_pick_the_client_certificate_for_this =>
      'Виберіть сертифікат клієнта для цього шлюзу й перевірте ще раз.';

  @override
  String get ng_needs_server_access_first =>
      'Спочатку потрібен доступ до сервера.';

  @override
  String get ng_needs_a_sign_in_first => 'Спочатку потрібно увійти.';

  @override
  String ng_signed_in_as(Object name) {
    return 'Ви увійшли як $name.';
  }

  @override
  String get ng_this_dashboard_doesn_t_need_a =>
      'Для цієї панелі керування вхід не потрібен.';

  @override
  String get ng_the_saved_sign_in_has_expired =>
      'Термін дії збереженого входу минув.';

  @override
  String get ng_sign_in_again => 'Увійдіть знову.';

  @override
  String get ng_too_many_sign_in_attempts => 'Забагато спроб входу.';

  @override
  String get ng_wait_a_minute_then_check_again =>
      'Зачекайте хвилину й перевірте ще раз.';

  @override
  String ng_the_gateway_answered(Object message) {
    return 'Шлюз відповів: $message.';
  }

  @override
  String get ng_sign_in_again_or_update_hermes =>
      'Увійдіть знову або оновіть Hermes.';

  @override
  String ng_couldn_t_check_the_sign_in(Object error) {
    return 'Не вдалося перевірити вхід: $error';
  }

  @override
  String ng_the_gateway_wouldn_t_issue_a(Object message) {
    return 'Шлюз не видав квиток для чату ($message).';
  }

  @override
  String get ng_the_chat_connection_opened_and_the =>
      'З’єднання чату встановлено, шлюз повідомив, що готовий.';

  @override
  String get ng_the_gateway_never_said_it_was =>
      'Шлюз так і не повідомив про готовність.';

  @override
  String get ng_check_that_the_agent_is_running =>
      'Переконайтеся, що агент запущено на сервері.';

  @override
  String get ng_the_gateway_refused_the_chat_connection =>
      'Шлюз відхилив з’єднання чату (HTTP 403).';

  @override
  String get ng_this_dashboard_has_no_chat_endpoint =>
      'У цієї панелі керування немає кінцевої точки чату (/api/ws).';

  @override
  String ng_the_chat_connection_failed(Object detail) {
    return 'Не вдалося встановити з’єднання чату: $detail';
  }

  @override
  String get ng_use_the_exact_address_the_dashboard =>
      'Використовуйте точну адресу, налаштовану для панелі керування.';

  @override
  String get ng_update_hermes => 'Оновіть Hermes.';

  @override
  String get ng_make_sure_the_proxy_allows_websocket =>
      'Переконайтеся, що проксі дозволяє оновлення WebSocket на /api/ws.';

  @override
  String get ng_offline => 'Офлайн';

  @override
  String get ng_connecting => 'Підключення…';

  @override
  String get ng_connected => 'Підключено';

  @override
  String get ng_reconnecting => 'Повторне підключення…';

  @override
  String get ng_signed_out => 'Ви вийшли з облікового запису';

  @override
  String get ng_connection_failed => 'Не вдалося підключитися';

  @override
  String get ng_rate_limited_by_gateway => 'Шлюз обмежив частоту запитів';

  @override
  String ng_couldn_t_open_the_chat_connection(Object message) {
    return 'Не вдалося відкрити з’єднання з чатом: $message';
  }

  @override
  String get ng_the_gateway_returned_no_websocket_ticket =>
      'Шлюз не надав квиток WebSocket.';

  @override
  String get ng_connection_lost => 'З’єднання втрачено';

  @override
  String get ng_this_dashboard_has_no_chat_endpoint_2 =>
      'У цій панелі немає кінцевої точки чату (/api/ws). Оновіть Hermes.';

  @override
  String get ng_the_gateway_refused_the_chat_connection_2 =>
      'Шлюз відхилив з’єднання з чатом. Перевірте, чи адреса відповідає налаштованому хосту панелі та чи ввімкнено вбудований чат.';

  @override
  String ng_the_gateway_refused(Object method) {
    return 'Шлюз відхилив $method.';
  }

  @override
  String ng_couldn_t_read_your_saved_gateways(Object error) {
    return 'Не вдалося прочитати збережені шлюзи: $error';
  }

  @override
  String get ng_applies_to_new_chats => 'Застосовується до нових чатів';

  @override
  String ng_couldn_t_change(Object label, Object error) {
    return 'Не вдалося змінити $label: $error';
  }

  @override
  String get ng_capabilities => 'Можливості';

  @override
  String get ng_skills => 'Навички';

  @override
  String get ng_toolsets => 'Набори інструментів';

  @override
  String get ng_search => 'Пошук';

  @override
  String get ng_couldn_t_load => 'Не вдалося завантажити';

  @override
  String get ng_try_again => 'Спробувати ще раз';

  @override
  String get ng_no_skills => 'Немає навичок';

  @override
  String get ng_no_toolsets => 'Немає наборів інструментів';

  @override
  String get ng_no_mcp_servers => 'Немає серверів MCP';

  @override
  String get ng_that_file_is_too_large_to =>
      'Цей файл завеликий, щоб бути сертифікатом.';

  @override
  String ng_the_certificate_couldn_t_be_imported(Object error) {
    return 'Не вдалося імпортувати сертифікат: $error';
  }

  @override
  String get ng_now_pick_its_private_key =>
      'Тепер виберіть відповідний приватний ключ.';

  @override
  String get ng_now_pick_its_certificate =>
      'Тепер виберіть відповідний сертифікат.';

  @override
  String get ng_that_file_isn_t_a_certificate =>
      'Цей файл не є сертифікатом або приватним ключем.';

  @override
  String get ng_if_a_proxy_in_front_of =>
      'Якщо проксі перед цією адресою запитує сертифікат клієнта, виберіть його тут, щоб перевірка, вхід і чат використовували його.';

  @override
  String get ng_client_certificates_are_only_used_with =>
      'Сертифікати клієнта використовуються лише з адресами https://.';

  @override
  String get ng_remove => 'Видалити';

  @override
  String get ng_certificate_password => 'Пароль сертифіката';

  @override
  String get ng_importing => 'Імпорт…';

  @override
  String get ng_pick_certificate => 'Вибрати сертифікат';

  @override
  String get ng_pick_a_different_certificate => 'Вибрати інший сертифікат';

  @override
  String get ng_accepts_p12_pfx_or_pem_certificate =>
      'Підтримуються файли .p12/.pfx або файли сертифіката й ключа PEM. Ключ зберігається у приватному сховищі цього застосунку.';

  @override
  String get ng_photos => 'Фотографії';

  @override
  String get ng_camera => 'Камера';

  @override
  String get ng_files => 'Файли';

  @override
  String ng_you_can_attach_up_to_files(Object count) {
    return 'Можна прикріпити до $count файлів.';
  }

  @override
  String ng_couldn_t_read(Object name) {
    return 'Не вдалося прочитати $name.';
  }

  @override
  String ng_couldn_t_prepare_that_file(Object error) {
    return 'Не вдалося підготувати цей файл: $error';
  }

  @override
  String get ng_hermes_is_still_working => 'Hermes ще працює';

  @override
  String get ng_steer => 'Скерувати';

  @override
  String get ng_adds_this_to_the_running_turn =>
      'Додає це до поточного ходу на наступному кроці';

  @override
  String get ng_queue => 'У чергу';

  @override
  String get ng_sends_it_when_the_turn_finishes =>
      'Надсилає це після завершення ходу';

  @override
  String get ng_stop_and_send => 'Зупинити й надіслати';

  @override
  String get ng_stops_the_turn_then_sends_this =>
      'Зупиняє хід, а потім надсилає це';

  @override
  String ng_dictation_stopped(Object message) {
    return 'Диктування зупинено: $message';
  }

  @override
  String get ng_speech_recognition_isn_t_available =>
      'Розпізнавання мовлення недоступне.';

  @override
  String get ng_working => 'Працює';

  @override
  String get ng_ready => 'Готово';

  @override
  String get ng_chats => 'Чати';

  @override
  String get ng_new_chat => 'Новий чат';

  @override
  String get ng_usage => 'Використання';

  @override
  String get ng_rename_chat => 'Перейменувати чат';

  @override
  String ng_couldn_t_rename(Object error) {
    return 'Не вдалося перейменувати: $error';
  }

  @override
  String get ng_this_chat => 'Цей чат';

  @override
  String get ng_input_tokens => 'Вхідні токени';

  @override
  String get ng_output_tokens => 'Вихідні токени';

  @override
  String get ng_reasoning_tokens => 'Токени міркування';

  @override
  String get ng_cache_reads => 'Читання з кешу';

  @override
  String get ng_api_calls => 'Виклики API';

  @override
  String get ng_cost => 'Вартість';

  @override
  String get ng_context => 'Контекст';

  @override
  String get ng_your_sign_in_expired => 'Термін дії входу завершився.';

  @override
  String get ng_sign_in_2 => 'Увійти';

  @override
  String get ng_retry => 'Повторити';

  @override
  String get ng_project_home => 'Головна';

  @override
  String get ng_choose_project => 'Вибрати проєкт';

  @override
  String ng_project_cwd_fallback(String path) {
    return 'Папка проєкту недоступна, тому цей чат працює в $path.';
  }

  @override
  String get ng_project_create_uncertain =>
      'Шлюз міг створити цей чат, але не підтвердив це. Перевірте список чатів, перш ніж починати новий. Запит не буде повторено автоматично.';

  @override
  String get ng_what_should_we_work_on => 'Над чим попрацюємо?';

  @override
  String get ng_ask_hermes_anything_it_can_run =>
      'Запитайте Hermes про що завгодно. Він може запускати інструменти, переглядати вебсторінки й працювати з файлами на сервері.';

  @override
  String ng_working_2(Object frame) {
    return 'Працює · $frame';
  }

  @override
  String get ng_default_model => 'Модель за замовчуванням';

  @override
  String get ng_listening => 'Слухаю…';

  @override
  String get ng_steer_or_queue_a_message =>
      'Спрямуйте розмову або додайте повідомлення в чергу';

  @override
  String get ng_message_hermes => 'Повідомлення для Hermes';

  @override
  String get ng_attach => 'Додати файл';

  @override
  String get ng_stop_dictation => 'Зупинити диктування';

  @override
  String get ng_dictate => 'Диктувати';

  @override
  String get ng_stop => 'Зупинити';

  @override
  String get ng_send => 'Надіслати';

  @override
  String ng_slash_command_alias(String alias, String command) {
    return '$alias — псевдонім для $command';
  }

  @override
  String get ng_slash_command_no_description => 'Опис недоступний.';

  @override
  String get ng_slash_command_arguments_options =>
      'Приймає один із фіксованих варіантів.';

  @override
  String get ng_slash_command_arguments_text => 'Приймає текст після команди.';

  @override
  String get ng_slash_command_arguments_mixed =>
      'Приймає варіант або текст після команди.';

  @override
  String get ng_slash_command_sent_as_message =>
      'NextGen надсилає це Hermes як звичайне повідомлення; сама команда не виконується.';

  @override
  String get ng_slash_command_output => 'Вивід команди';

  @override
  String get ng_slash_command_running => 'Виконується команда…';

  @override
  String get ng_slash_command_done => 'Готово.';

  @override
  String ng_slash_command_failed(Object error) {
    return 'Не вдалося виконати команду: $error';
  }

  @override
  String get ng_slash_command_refused =>
      'Hermes не може виконати цю команду тут.';

  @override
  String get ng_slash_command_delivery_unknown =>
      'Команду надіслано, але відповідь не надійшла. Можливо, вона ще виконується на шлюзі, тому її не надіслано повторно, а чернетку збережено.';

  @override
  String get ng_slash_command_nothing_running => 'Нічого не виконується.';

  @override
  String get ng_steered => 'Спрямовано';

  @override
  String get ng_copied => 'Скопійовано';

  @override
  String ng_not_sent(Object reason) {
    return 'Не надіслано: $reason';
  }

  @override
  String get ng_thinking => 'Думаю…';

  @override
  String get ng_thought => 'Міркування';

  @override
  String ng_used(Object name) {
    return 'Використано: $name';
  }

  @override
  String ng_used_tools(Object count) {
    return 'Використано інструментів: $count';
  }

  @override
  String get ng_copy => 'Копіювати';

  @override
  String get ng_read_aloud => 'Прочитати вголос';

  @override
  String get ng_the_gateway_connection_dropped_try_again =>
      'З’єднання зі шлюзом втрачено. Спробуйте ще раз.';

  @override
  String get ng_allow_once => 'Дозволити один раз';

  @override
  String get ng_allow_until_sandbox_off => 'Доки пісочницю не буде вимкнено';

  @override
  String get ng_folder_access => 'Доступ до теки';

  @override
  String get ng_folder_access_unspecified =>
      'Шлюз не повідомив, чи доступ лише для читання, чи для читання й запису.';

  @override
  String get ng_folder_read_only => 'Лише для читання';

  @override
  String get ng_folder_read_write => 'Читання й запис';

  @override
  String get ng_website_access => 'Доступ до вебсайту';

  @override
  String get ng_allow_for_this_chat => 'Дозволити в цьому чаті';

  @override
  String get ng_always_allow => 'Дозволяти завжди';

  @override
  String get ng_deny => 'Заборонити';

  @override
  String get ng_your_answer => 'Ваша відповідь';

  @override
  String get ng_or_type_an_answer => 'Або введіть відповідь';

  @override
  String get ng_skip => 'Пропустити';

  @override
  String get ng_answer => 'Відповісти';

  @override
  String get ng_cancel => 'Скасувати';

  @override
  String get ng_username_or_email => 'Ім’я користувача або електронна пошта';

  @override
  String get ng_password => 'Пароль';

  @override
  String get ng_not_now => 'Не зараз';

  @override
  String get ng_save => 'Зберегти';

  @override
  String get ng_enter_both_the_client_id_and =>
      'Введіть ідентифікатор клієнта й секрет клієнта або не вводьте жодного.';

  @override
  String get ng_enter_your_username_and_password =>
      'Введіть ім’я користувача й пароль.';

  @override
  String ng_couldn_t_save_the_sign_in(Object error) {
    return 'Не вдалося зберегти дані для входу: $error';
  }

  @override
  String get ng_wrong_username_or_password =>
      'Неправильне ім’я користувача або пароль.';

  @override
  String get ng_too_many_attempts_wait_a_moment =>
      'Забагато спроб. Зачекайте трохи й повторіть.';

  @override
  String get ng_welcome_to_hermes => 'Ласкаво просимо до Ares';

  @override
  String get ng_add_a_gateway => 'Додати шлюз';

  @override
  String get ng_connect_to_your_hermes_agent_dashboard =>
      'Під’єднайтеся до панелі Hermes Agent. Одна адреса й один вхід дають доступ до чатів, інструментів і налаштувань. Дані не надсилаються, доки ви не ввійдете.';

  @override
  String get ng_connect_to_another_hermes_agent_dashboard =>
      'Під’єднайтеся до іншої панелі Hermes Agent. Ви залишатиметеся в системі на збережених панелях.';

  @override
  String get ng_dashboard_address => 'Адреса панелі';

  @override
  String get ng_testing => 'Перевірка…';

  @override
  String get ng_test => 'Перевірити';

  @override
  String get ng_where_your_hermes_dashboard_runs_lan =>
      'Адреса панелі Hermes у вашій мережі: LAN, Tailscale або HTTPS.';

  @override
  String get ng_find_on_my_network => 'Знайти в моїй мережі';

  @override
  String get ng_which_address_do_i_use => 'Яку адресу використовувати?';

  @override
  String get ng_behind_cloudflare_access => 'За Cloudflare Access?';

  @override
  String get ng_need_a_client_certificate => 'Потрібен сертифікат клієнта?';

  @override
  String get ng_this_address_isn_t_private_and =>
      'Ця адреса не є приватною та не використовує https://, тож ваш пароль і чати передаватимуться інтернетом без шифрування. Натомість використайте https://, Tailscale або власну мережу.';

  @override
  String get ng_continue_to_sign_in => 'Перейти до входу';

  @override
  String get ng_use_the_classic_interface_instead =>
      'Натомість скористатися класичним інтерфейсом';

  @override
  String get ng_if_cloudflare_access_protects_this_address =>
      'Якщо цю адресу захищає Cloudflare Access, створіть сервісний токен у Cloudflare Zero Trust (Access, Service credentials) і додайте для нього політику Service Auth у застосунку Access.';

  @override
  String get ng_a_service_token_is_saved_for =>
      'Для цієї адреси збережено сервісний токен';

  @override
  String get ng_forget => 'Забути';

  @override
  String get ng_client_id => 'Ідентифікатор клієнта';

  @override
  String get ng_client_secret => 'Секрет клієнта';

  @override
  String get ng_stored_encrypted_on_this_phone_and =>
      'Зберігається в зашифрованому вигляді на цьому телефоні й надсилається лише на цю адресу.';

  @override
  String get ng_hermes_is_reachable => 'Hermes доступний';

  @override
  String ng_hermes_is_reachable_2(Object version) {
    return 'Hermes $version доступний';
  }

  @override
  String get ng_sign_in_is_tested_next_then =>
      'Спочатку перевіряється вхід, потім чат';

  @override
  String get ng_agent_gateway => 'Шлюз агента';

  @override
  String get ng_running => 'Працює';

  @override
  String get ng_stopped => 'Зупинено';

  @override
  String get ng_username_password => 'Ім’я користувача й пароль';

  @override
  String get ng_browser => 'Браузер';

  @override
  String get ng_in_the_browser_sso => 'У браузері (SSO)';

  @override
  String get ng_profiles => 'Профілі';

  @override
  String get ng_this_dashboard_offers_neither_a_username =>
      'Ця панель керування не підтримує вхід ні за ім’ям користувача й паролем, ні через браузер. Оновіть Hermes або налаштуйте на сервері провайдера входу за ім’ям користувача й паролем.';

  @override
  String get ng_the_auth_gate_is_off_on =>
      'Захист входу на цій панелі вимкнено. Будь-хто, хто має до неї доступ, може користуватися вашим агентом.';

  @override
  String get ng_couldn_t_reach_the_dashboard =>
      'Не вдалося підключитися до панелі керування';

  @override
  String ng_check_the_address_and_port_9119(Object reason) {
    return '$reason\n\nПеревірте адресу й порт (9119 за замовчуванням). Якщо панель ще не запущена, виконайте на сервері:\nhermes dashboard --host 0.0.0.0';
  }

  @override
  String get ng_that_isn_t_a_hermes_dashboard =>
      'Це не панель керування Hermes';

  @override
  String get ng_something_answered_but_not_a_hermes_2 =>
      'Відповідь отримано, але це не панель керування Hermes. Використовуйте адресу панелі, а не API-сервера (порт 8642).';

  @override
  String ng_something_answered_http_but_not_a_2(Object status) {
    return 'Отримано відповідь (HTTP $status), але це не панель керування Hermes. Використовуйте адресу панелі, а не API-сервера (порт 8642).';
  }

  @override
  String get ng_cloudflare_access_stopped_the_request =>
      'Cloudflare Access заблокував запит';

  @override
  String ng_cloudflare_access_turned_down_the_service(Object status) {
    return 'Cloudflare Access відхилив токен служби (HTTP $status). Перевірте Client ID і Secret, а також політику Service Auth.';
  }

  @override
  String get ng_add_a_cloudflare_access_service_token_2 =>
      'Додайте нижче токен служби Cloudflare Access і перевірте ще раз.';

  @override
  String get ng_a_client_certificate_is_needed =>
      'Потрібен клієнтський сертифікат';

  @override
  String get ng_this_server_asks_for_a_client =>
      'Цей сервер запитує клієнтський сертифікат для підключення. Виберіть нижче сертифікат, який вам видали, і спробуйте ще раз.';

  @override
  String get ng_this_dashboard_doesn_t_ask_for =>
      'На цій панелі не потрібно входити.';

  @override
  String ng_use_the_dashboard_username_and_password(Object address) {
    return 'Використовуйте ім’я користувача й пароль панелі, налаштовані для $address, або увійдіть у браузері.';
  }

  @override
  String ng_use_the_dashboard_username_and_password_2(Object address) {
    return 'Використовуйте ім’я користувача й пароль панелі, налаштовані для $address.';
  }

  @override
  String ng_sign_in_to_in_your_browser(Object address) {
    return 'Увійдіть у $address у браузері за допомогою облікового запису, який використовується для панелі.';
  }

  @override
  String ng_gateway(Object address) {
    return 'Шлюз $address';
  }

  @override
  String get ng_profile => 'Профіль';

  @override
  String get ng_server_default => 'За замовчуванням сервера';

  @override
  String get ng_continue => 'Продовжити';

  @override
  String get ng_username => 'Ім’я користувача';

  @override
  String get ng_signing_in => 'Вхід…';

  @override
  String get ng_waiting_for_the_browser => 'Очікування браузера…';

  @override
  String get ng_sign_in_with_browser => 'Увійти через браузер';

  @override
  String get ng_finish_signing_in_on_the_page =>
      'Завершіть вхід на відкритій сторінці. Hermes повернеться автоматично, коли ви закінчите.';

  @override
  String get ng_use_a_different_gateway => 'Використати інший шлюз';

  @override
  String get ng_same_wi_fi_or_local_network =>
      'Та сама мережа Wi-Fi або локальна мережа';

  @override
  String get ng_use_the_server_s_local_address =>
      'Використовуйте локальну адресу й порт сервера, наприклад 192.168.1.20:9119. Запустіть панель із --host 0.0.0.0, щоб інші пристрої могли підключитися.';

  @override
  String get ng_tailscale => 'Tailscale';

  @override
  String get ng_turn_on_tailscale_on_this_phone =>
      'Увімкніть Tailscale на цьому телефоні й використовуйте адресу Tailscale сервера, наприклад 100.64.0.1:9119 або його ім’я .ts.net. Працює і поза домом.';

  @override
  String get ng_use_your_https_address_when_the =>
      'Використовуйте адресу https://, якщо панель розміщена за проксі із сертифікатом. Проксі також має підтримувати оновлення WebSocket на /api/ws.';

  @override
  String get ng_start_the_dashboard_on_the_server =>
      'Запустіть панель на сервері:';

  @override
  String get ng_enter_a_port_from_1_to => 'Введіть порт від 1 до 65535.';

  @override
  String get ng_looks_for_hermes_dashboards_on_port =>
      'Шукає панелі Hermes на порту 9119 у цій мережі Wi-Fi та перевіряє комп’ютери, які ви вже зберегли.';

  @override
  String ng_looks_for_hermes_dashboards_on_ports(Object port) {
    return 'Шукає панелі Hermes на портах 9119 і $port у цій мережі Wi-Fi та перевіряє комп’ютери, які ви вже зберегли.';
  }

  @override
  String get ng_other_port_optional => 'Інший порт (необов’язково)';

  @override
  String get ng_no_dashboards_answered_start_one_with =>
      'Жодна панель не відповіла. Запустіть її командою hermes dashboard --host 0.0.0.0 або введіть її адресу.';

  @override
  String get ng_using_tailscale_or_a_vpn_those =>
      'Користуєтеся Tailscale або VPN? Такі мережі не можна просканувати. Введіть адресу комп’ютера 100.x або його ім’я .ts.net.';

  @override
  String get ng_search_again => 'Шукати знову';

  @override
  String get ng_insights => 'Статистика';

  @override
  String get ng_couldn_t_load_insights => 'Не вдалося завантажити статистику';

  @override
  String get ng_sessions => 'Сеанси';

  @override
  String get ng_tokens => 'Токени';

  @override
  String get ng_est_cost => 'Орієнт. вартість';

  @override
  String get ng_daily_tokens => 'Щоденні токени';

  @override
  String get ng_models => 'Моделі';

  @override
  String get ng_tools => 'Інструменти';

  @override
  String get ng_hermes_is_waiting_for_you => 'Hermes чекає на вас.';

  @override
  String get ng_hermes_replied => 'Hermes відповів';

  @override
  String get ng_the_turn_finished => 'Хід завершено.';

  @override
  String get ng_off => 'Вимкнено';

  @override
  String get ng_minimal => 'Мінімальний';

  @override
  String get ng_low => 'Низький';

  @override
  String get ng_medium => 'Середній';

  @override
  String get ng_high => 'Високий';

  @override
  String get ng_extra_high => 'Дуже високий';

  @override
  String get ng_max => 'Максимальний';

  @override
  String get ng_ultra => 'Ультра';

  @override
  String get ng_default => 'За замовчуванням';

  @override
  String ng_couldn_t_switch_model(Object error) {
    return 'Не вдалося змінити модель: $error';
  }

  @override
  String get ng_model => 'Модель';

  @override
  String get ng_thinking_2 => 'Думає';

  @override
  String get ng_search_models => 'Пошук моделей';

  @override
  String get ng_no_models_match =>
      'Немає моделей, що відповідають цим фільтрам.';

  @override
  String get privacy_policy => 'Політика конфіденційності';

  @override
  String get report_ai_output => 'Поскаржитися на відповідь ШІ';

  @override
  String ng_couldn_t_load_models(Object error) {
    return 'Не вдалося завантажити моделі: $error';
  }

  @override
  String get ng_no_providers_are_set_up_on =>
      'На цьому шлюзі ще не налаштовано жодного провайдера.';

  @override
  String get ng_starred => 'Обране';

  @override
  String get ng_recent => 'Нещодавні';

  @override
  String get ng_more => 'Ще';

  @override
  String get ng_archived_chats => 'Архівовані чати';

  @override
  String get ng_projects => 'Проєкти';

  @override
  String get ng_chats_grouped_by_project_and_workspace =>
      'Чати згруповано за проєктом і робочим простором';

  @override
  String get ng_agent => 'Агент';

  @override
  String get ng_memory => 'Пам’ять';

  @override
  String get ng_what_hermes_remembers_about_you => 'Що Hermes пам’ятає про вас';

  @override
  String get ng_skills_library => 'Бібліотека навичок';

  @override
  String get ng_browse_and_read_installed_skills =>
      'Переглядайте й читайте встановлені навички';

  @override
  String get ng_cron_editor => 'Редактор Cron';

  @override
  String get ng_edit_schedules_prompts_and_delivery =>
      'Редагуйте розклади, запити й доставлення';

  @override
  String get ng_config_file => 'Файл конфігурації';

  @override
  String get ng_edit_config_yaml_on_the_gateway =>
      'Редагуйте config.yaml на шлюзі';

  @override
  String get ng_models_and_providers => 'Моделі й провайдери';

  @override
  String get ng_model_management => 'Керування моделями';

  @override
  String get ng_default_fallback_and_auxiliary_models =>
      'Моделі за замовчуванням, резервні й допоміжні';

  @override
  String get ng_provider_sign_in => 'Вхід у провайдера';

  @override
  String get ng_connect_provider_accounts_with_oauth =>
      'Під’єднайте облікові записи провайдерів через OAuth';

  @override
  String get ng_nous_portal => 'Nous Portal';

  @override
  String get ng_subscription_credits_and_usage =>
      'Підписка, кредити й використання';

  @override
  String get ng_interface => 'Інтерфейс';

  @override
  String get ng_switch_to_the_classic_interface =>
      'Перейти до класичного інтерфейсу';

  @override
  String get ng_turns_nextgen_off_you_can_turn =>
      'Вимикає NextGen. Ви можете знову ввімкнути його в налаштуваннях.';

  @override
  String get ng_restored => 'Відновлено';

  @override
  String get ng_archived => 'Заархівовано';

  @override
  String get ng_couldn_t_load_archived_chats =>
      'Не вдалося завантажити архівовані чати';

  @override
  String get ng_nothing_archived => 'Немає архівованих чатів';

  @override
  String get ng_restore => 'Відновити';

  @override
  String get ng_saved_new_chats_use_it =>
      'Збережено. У нових чатах використовуватиметься цей варіант.';

  @override
  String ng_couldn_t_save(Object error) {
    return 'Не вдалося зберегти: $error';
  }

  @override
  String get ng_saving => 'Збереження…';

  @override
  String ng_today(Object time) {
    return 'Сьогодні $time';
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
  String get ng_sun => 'Нд';

  @override
  String get ng_scheduled => 'Заплановано';

  @override
  String get ng_new_job => 'Нове завдання';

  @override
  String get ng_couldn_t_load_scheduled_jobs =>
      'Не вдалося завантажити заплановані завдання';

  @override
  String get ng_nothing_scheduled => 'Нічого не заплановано';

  @override
  String get ng_ask_hermes_to_do_something_on =>
      'Попросіть Hermes виконувати щось за розкладом або додайте завдання тут.';

  @override
  String get ng_active => 'Активне';

  @override
  String get ng_paused => 'Призупинене';

  @override
  String ng_next(Object when) {
    return 'Наступне: $when';
  }

  @override
  String ng_last(Object when) {
    return 'Останнє: $when';
  }

  @override
  String ng_last_2(Object when, Object result) {
    return 'Останнє: $when · $result';
  }

  @override
  String ng_job(Object id) {
    return 'Завдання $id';
  }

  @override
  String get ng_delete => 'Видалити';

  @override
  String get ng_delete_this_job => 'Видалити це завдання?';

  @override
  String get ng_it_stops_running_past_runs_stay =>
      'Воно більше не запускатиметься. Попередні запуски залишаться у ваших чатах.';

  @override
  String ng_next_run(Object when) {
    return 'Наступний запуск: $when';
  }

  @override
  String ng_delivers_to(Object target) {
    return 'Надсилає до $target';
  }

  @override
  String get ng_run_now => 'Запустити зараз';

  @override
  String get ng_started => 'Запущено';

  @override
  String get ng_pause => 'Призупинити';

  @override
  String get ng_resume => 'Продовжити';

  @override
  String get ng_resumed => 'Відновлено';

  @override
  String get ng_prompt => 'Запит';

  @override
  String get ng_runs => 'Запуски';

  @override
  String get ng_no_runs_yet => 'Поки що запусків немає.';

  @override
  String get ng_enter_a_schedule_and_a_prompt => 'Укажіть розклад і запит.';

  @override
  String get ng_name_optional => 'Назва (необов’язково)';

  @override
  String get ng_schedule => 'Розклад';

  @override
  String get ng_every_1h_0_9_or_30m => 'every 1h, 0 9 * * *, or 30m';

  @override
  String get ng_create => 'Створити';

  @override
  String get ng_unpin => 'Відкріпити';

  @override
  String get ng_pin => 'Закріпити';

  @override
  String get ng_rename => 'Перейменувати';

  @override
  String get ng_archive => 'Архівувати';

  @override
  String get ng_delete_this_chat => 'Видалити цей чат?';

  @override
  String get ng_it_is_removed_from_the_gateway =>
      'Його буде видалено зі шлюзу на всіх пристроях.';

  @override
  String get ng_search_chats => 'Шукати чати';

  @override
  String get ng_pinned => 'Закріплені';

  @override
  String get ng_no_chats_match => 'Чатів не знайдено.';

  @override
  String get ng_no_chats_yet => 'Поки що чатів немає.';

  @override
  String get ng_nothing_is_running => 'Нічого не виконується.';

  @override
  String get ng_nothing_is_waiting_on_you =>
      'Немає запитів, що чекають на вас.';

  @override
  String get ng_settings => 'Налаштування';

  @override
  String get ng_all => 'Усі';

  @override
  String ng_needs_you(Object count) {
    return 'Потрібна ваша увага · $count';
  }

  @override
  String get ng_needs_you_2 => 'Потрібна ваша увага';

  @override
  String get ng_gateways => 'Шлюзи';

  @override
  String ng_classic_connection(Object address) {
    return '$address · класичне підключення';
  }

  @override
  String get ng_gateway_2 => 'Шлюз';

  @override
  String get ng_signed_in => 'Ви ввійшли';

  @override
  String get ng_classic_connection_2 => 'Класичне підключення';

  @override
  String get ng_in_the_browser => 'У браузері';

  @override
  String ng_in_the_browser_as(Object name) {
    return 'У браузері як $name';
  }

  @override
  String get ng_not_required => 'Не потрібно';

  @override
  String get ng_test_connection => 'Перевірити з’єднання';

  @override
  String get ng_sign_in_again_2 => 'Увійти знову';

  @override
  String get ng_sign_out => 'Вийти';

  @override
  String get ng_saved_gateways => 'Збережені шлюзи';

  @override
  String get ng_in_use => 'Використовується';

  @override
  String get ng_appearance => 'Вигляд';

  @override
  String get ng_theme => 'Тема';

  @override
  String get ng_system => 'Системна';

  @override
  String get ng_light => 'Світла';

  @override
  String get ng_dark => 'Темна';

  @override
  String get ng_accent => 'Акцент';

  @override
  String get ng_pure_black => 'Чистий чорний';

  @override
  String get ng_dark_theme_uses_true_black_oled =>
      'Темна тема використовує справжній чорний (OLED)';

  @override
  String get ng_glow => 'Світіння';

  @override
  String get ng_soft_accent_light_behind_each_screen =>
      'М’яке акцентне підсвічування за кожним екраном';

  @override
  String get ng_the_new_interface_turn_off_to =>
      'Новий інтерфейс. Вимкніть, щоб повернутися до класичного; шлюзи й чати спільні.';

  @override
  String get ng_more_settings => 'Інші налаштування';

  @override
  String get ng_voice_notifications_language_backups_and_the =>
      'Голос, сповіщення, мова, резервні копії та конфігурація шлюзу';

  @override
  String get ng_licences => 'Ліцензії';

  @override
  String ng_sign_out_of(Object name) {
    return 'Вийти з $name?';
  }

  @override
  String get ng_this_gateway_and_its_saved_sign =>
      'Цей шлюз і збережені дані для входу буде видалено з цього телефона в обох інтерфейсах. Ваші чати залишаться на шлюзі.';

  @override
  String get ng_password_or_browser => 'Пароль або браузер';

  @override
  String get ng_unsupported => 'Не підтримується';

  @override
  String get ng_background_task_finished => 'Фонове завдання завершено';

  @override
  String get ng_background_process_finished => 'Фоновий процес завершився';

  @override
  String get ng_system_message => 'Системне повідомлення';

  @override
  String get ng_summary => 'Підсумок';

  @override
  String get classic_interface_only => 'Лише класичний інтерфейс';

  @override
  String get classic_only_settings_hint =>
      'Розділи з позначкою «Лише класичний інтерфейс» змінюють класичний вигляд і чат, але не NextGen. У NextGen є власні параметри оформлення в налаштуваннях.';

  @override
  String get attachment_preview_too_large =>
      'Завеликий для попереднього перегляду. Збережіть файл або поділіться ним, щоб завантажити на телефон (до 1 ГБ).';

  @override
  String get attachment_over_phone_limit =>
      'Розмір цього файла перевищує ліміт завантаження на телефон — 1 ГБ. Відкрийте панель керування, щоб завантажити його.';

  @override
  String attachment_downloading_percent(int percent) {
    return 'Завантаження… $percent%';
  }

  @override
  String attachment_downloading_mb(int megabytes) {
    return 'Завантаження… $megabytes МБ';
  }

  @override
  String ng_attachment_too_large_for_gateway(String name) {
    return 'Файл $name завеликий для цього шлюзу (понад 12 МБ). Оновіть Hermes, щоб надсилати файли розміром до 100 МБ.';
  }

  @override
  String ng_couldn_t_upload(String name) {
    return 'Не вдалося завантажити файл $name.';
  }

  @override
  String ng_uploading_percent(int percent) {
    return 'Надсилання… $percent%';
  }

  @override
  String get ng_show_tasks => 'Показати завдання';

  @override
  String get ng_hide_tasks => 'Приховати завдання';

  @override
  String get ng_goal => 'Ціль';

  @override
  String get ng_loop => 'Цикл';

  @override
  String get ng_heartbeat => 'Пульс';

  @override
  String get ng_goal_working => 'У роботі';

  @override
  String get ng_goal_waiting => 'Очікує';

  @override
  String get ng_goal_blocked => 'Заблоковано';

  @override
  String get ng_goal_done => 'Виконано';

  @override
  String ng_goal_turns_of(int used, int max) {
    return '$used із $max ходів';
  }

  @override
  String ng_goal_turn(int used) {
    return 'хід $used';
  }

  @override
  String get ng_loop_held => 'Призупинено через ціль';

  @override
  String get ng_loop_finished => 'Завершено';

  @override
  String get ng_loop_running => 'Виконується';

  @override
  String ng_loop_runs_of(int fired, int times) {
    return '$fired із $times запусків';
  }

  @override
  String ng_loop_runs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count запуску',
      many: '$count запусків',
      few: '$count запуски',
      one: '$count запуск',
    );
    return '$_temp0';
  }

  @override
  String ng_loop_next(String time) {
    return 'наступний запуск $time';
  }

  @override
  String get ng_loop_due_now => 'час запуску настав';

  @override
  String ng_every_seconds(int seconds) {
    return 'кожні $seconds с';
  }

  @override
  String ng_every_minutes(int minutes) {
    return 'кожні $minutes хв';
  }

  @override
  String ng_every_hours(int hours) {
    return 'кожні $hours год';
  }

  @override
  String ng_every_hours_minutes(int hours, int minutes) {
    return 'кожні $hours год $minutes хв';
  }

  @override
  String ng_heartbeat_fired(int count) {
    return 'Спрацював $count разів';
  }

  @override
  String ng_heartbeat_last_fired(String time) {
    return 'Востаннє спрацював о $time';
  }

  @override
  String ng_wait_until(String time) {
    return 'Очікування до $time';
  }

  @override
  String get ng_wait_resume => 'Очікування відновлення';

  @override
  String get ng_wait_other_chat => 'Очікування в іншому чаті';

  @override
  String ng_wait_process(String pid) {
    return 'Очікування процесу $pid';
  }

  @override
  String get ng_control_open => 'Відкрити ціль і автоматизацію';

  @override
  String get ng_control_title => 'Ціль і автоматизація';

  @override
  String get ng_control_subtitle =>
      'Над чим працює цей чат і що запускається автоматично.';

  @override
  String get ng_contract_outcome => 'Результат';

  @override
  String get ng_contract_verification => 'Перевірка';

  @override
  String get ng_contract_constraints => 'Обмеження';

  @override
  String get ng_contract_boundaries => 'Межі';

  @override
  String get ng_contract_stop_when => 'Зупинитися, коли';

  @override
  String get ng_subgoals => 'Підцілі';

  @override
  String get ng_subgoal_add_placeholder => 'Додати підціль';

  @override
  String get ng_add => 'Додати';

  @override
  String get ng_subgoal_remove => 'Видалити підціль';

  @override
  String get ng_goal_checks => 'Перевірки';

  @override
  String get ng_gate_not_run => 'Ще не виконано';

  @override
  String ng_gate_attempts(int attempts, int tries) {
    return '$attempts із $tries спроб';
  }

  @override
  String ng_gate_exit(int code) {
    return 'код завершення $code';
  }

  @override
  String get ng_resume_now => 'Відновити зараз';

  @override
  String get ng_goal_clear => 'Очистити ціль';

  @override
  String get ng_goal_clear_title => 'Очистити цю ціль?';

  @override
  String get ng_goal_clear_message =>
      'Агент припинить працювати над нею. Її підцілі та перевірки також буде видалено.';

  @override
  String get ng_subgoal_remove_title => 'Видалити цю підціль?';

  @override
  String ng_subgoal_remove_message(String text) {
    return '«$text» більше не буде частиною цілі.';
  }

  @override
  String get ng_subgoals_clear_title => 'Очистити всі підцілі?';

  @override
  String get ng_subgoals_clear_message =>
      'Назва цілі залишиться, але всі її підцілі буде видалено.';

  @override
  String get ng_clear_all => 'Очистити все';

  @override
  String get ng_clear => 'Очистити';

  @override
  String get ng_dismiss => 'Закрити';

  @override
  String get ng_loop_stop_title => 'Зупинити цей цикл?';

  @override
  String get ng_heartbeat_clear_title => 'Очистити цей пульс?';

  @override
  String get ng_wont_fire_again => 'Він більше не спрацьовуватиме.';

  @override
  String get ng_loop_self_paced => 'За власним графіком';

  @override
  String ng_loop_until(String condition) {
    return 'До: $condition';
  }

  @override
  String get ng_loop_waits_for_goal => 'Очікує, поки ціль у роботі.';

  @override
  String get ng_loop_awaiting_reply => 'Очікування відповіді агента.';

  @override
  String ng_loop_stopped_reason(String reason) {
    return 'Зупинено: $reason';
  }

  @override
  String get ng_hide_subagents => 'Приховати субагентів';

  @override
  String get ng_show_subagents => 'Показати субагентів';

  @override
  String get ng_subagent => 'Субагент';

  @override
  String get ng_subagent_queued => 'У черзі';

  @override
  String get ng_subagent_starting => 'Запускається…';

  @override
  String get ng_subagent_running => 'Виконується';

  @override
  String get ng_subagent_done => 'Завершено';

  @override
  String get ng_subagent_failed => 'Не вдалося';

  @override
  String get ng_subagent_stopped => 'Зупинено';

  @override
  String get ng_subagent_stop => 'Зупинити субагента';

  @override
  String ng_subagent_tools(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count інструмента',
      many: '$count інструментів',
      few: '$count інструменти',
      one: '$count інструмент',
    );
    return '$_temp0';
  }

  @override
  String get ng_mark_as_read => 'Позначити як прочитану';

  @override
  String get ng_mark_as_unread => 'Позначити як непрочитану';

  @override
  String ng_chats_unread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Чати: $count непрочитаного чату',
      many: 'Чати: $count непрочитаних чатів',
      few: 'Чати: $count непрочитані чати',
      one: 'Чати: $count непрочитаний чат',
    );
    return '$_temp0';
  }

  @override
  String get ng_unread_finished => 'Завершено, є непрочитана відповідь';

  @override
  String get ng_unread_updates => 'Виконується, є непрочитані оновлення';

  @override
  String get ng_notifications => 'Сповіщення';

  @override
  String get ng_notifications_hint =>
      'Відповіді та запити, коли Ares працює у фоновому режимі';

  @override
  String get ng_notify_replies => 'Відповіді';

  @override
  String get ng_notify_replies_hint =>
      'Коли відповідь у відкритому чаті буде готова або не вдасться її надіслати';

  @override
  String get ng_notify_requests => 'Підтвердження та запитання';

  @override
  String get ng_notify_requests_hint =>
      'Сповіщення, коли агент чекає на вас. Кнопки «Дозволити один раз» і «Відхилити»';

  @override
  String get ng_keep_running =>
      'Залишатися на зв’язку, поки готується відповідь';

  @override
  String get ng_keep_running_hint =>
      'Підтримує з’єднання у фоновому режимі, доки відповідь не буде готова, і показує тихе сповіщення';

  @override
  String get ng_battery_settings => 'Оптимізація акумулятора';

  @override
  String get ng_battery_settings_hint =>
      'Дозвольте Ares працювати у фоновому режимі, щоб сповіщення надходили вчасно';

  @override
  String get ng_send_test_notification => 'Надіслати тестове сповіщення';

  @override
  String get ng_test_notification_title => 'Сповіщення Ares працюють';

  @override
  String get ng_test_notification_body =>
      'Відповіді та запити матимуть такий вигляд.';

  @override
  String get ng_test_notification_sent => 'Тестове сповіщення надіслано';

  @override
  String get ng_notifications_blocked =>
      'Сповіщення заблоковано. Дозвольте їх у налаштуваннях Android.';

  @override
  String get ng_notifications_off_hint =>
      'Сповіщення вимкнено, тому Ares не надсилатиме їх у фоновому режимі.';

  @override
  String get ng_insights_building =>
      'Формуємо звіт. Під час першого створення звіту за тривалий період це може тривати до хвилини.';

  @override
  String get ng_insights_timed_out =>
      'Шлюзу не вдалося вчасно сформувати цей звіт. Спробуйте ще раз або виберіть коротший період.';

  @override
  String get ng_dock_goal_active => 'Ціль активна';

  @override
  String get ng_dock_goal_paused => 'Ціль призупинена';

  @override
  String get ng_dock_goal_waiting => 'Ціль очікує';

  @override
  String get ng_dock_goal_blocked => 'Ціль заблокована';

  @override
  String get ng_dock_goal_done => 'Ціль виконана';

  @override
  String ng_dock_turn_of(int used, int max) {
    return 'Хід $used/$max';
  }

  @override
  String ng_dock_turn(int used) {
    return 'Хід $used';
  }

  @override
  String ng_dock_subagents(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count дочірнього агента',
      many: '$count дочірніх агентів',
      few: '$count дочірні агенти',
      one: '1 дочірній агент',
    );
    return '$_temp0';
  }

  @override
  String ng_dock_subagents_done(int count) {
    return '$count завершено';
  }

  @override
  String ng_dock_tasks(int done, int total) {
    return 'Завдання $done/$total';
  }

  @override
  String ng_dock_previous_tasks(int done, int total) {
    return 'Попередні завдання $done/$total';
  }

  @override
  String get ng_dock_manage => 'Керувати';

  @override
  String get ng_recent_notifications => 'Останні сповіщення';

  @override
  String get ng_recent_notifications_hint =>
      'Що Ares намагався опублікувати та чи показав це Android';

  @override
  String get ng_recent_notifications_empty =>
      'Поки що нічого. Спроби з’являться тут, щойно відповідь, запитання або збій мали б надіслати вам сповіщення.';

  @override
  String get ng_notify_permission_granted => 'Дозвіл надано';

  @override
  String get ng_notify_permission_denied => 'У дозволі відмовлено';

  @override
  String get ng_notify_master_on => 'Сповіщення ввімкнено';

  @override
  String get ng_notify_master_off => 'Сповіщення вимкнено';

  @override
  String get ng_models_default => 'Типова модель';

  @override
  String get ng_models_change => 'Змінити';

  @override
  String get ng_models_custom_endpoint =>
      'Працює через власну адресу сервісу. Змініть її на шлюзі.';

  @override
  String get ng_models_context_window => 'Контекстне вікно';

  @override
  String ng_models_token_count(String count) {
    return '$count токенів';
  }

  @override
  String ng_models_context_override(String count) {
    return 'Задано на шлюзі. Визначено автоматично: $count токенів.';
  }

  @override
  String get ng_models_max_output => 'Макс. вивід';

  @override
  String get ng_models_input_price => 'Ціна вводу';

  @override
  String get ng_models_output_price => 'Ціна виводу';

  @override
  String get ng_models_cache_price => 'Ціна кешованого вводу';

  @override
  String ng_models_per_million(String price) {
    return '$price за 1 млн токенів';
  }

  @override
  String ng_models_price_pair(String input, String output) {
    return 'Ввід $input · вивід $output за 1 млн токенів';
  }

  @override
  String get ng_models_free => 'Безкоштовно';

  @override
  String get ng_models_vision => 'Зір';

  @override
  String get ng_models_reasoning => 'Міркування';

  @override
  String get ng_models_fast => 'Швидкий режим';

  @override
  String get ng_models_in_use => 'Використовується';

  @override
  String ng_models_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count моделі',
      many: '$count моделей',
      few: '$count моделі',
      one: '$count модель',
    );
    return '$_temp0';
  }

  @override
  String get ng_models_rate_limited => 'Ліміт вичерпано';

  @override
  String get ng_models_plan_locked => 'Недоступно у вашому тарифі';

  @override
  String get ng_models_unsaved => 'Незбережені зміни';

  @override
  String get ng_models_discard => 'Скинути';

  @override
  String get ng_models_aux_hint =>
      'Допоміжні завдання використовують типову модель, доки ви не призначите їм власну.';

  @override
  String get ng_models_uses_default => 'Використовує типову модель';

  @override
  String get ng_models_thinking_level => 'Рівень міркування';

  @override
  String get ng_models_providers => 'Провайдери';

  @override
  String get ng_models_saved => 'Збережено';

  @override
  String get ng_aux_vision => 'Зір';

  @override
  String get ng_aux_vision_hint => 'Читає зображення та знімки екрана';

  @override
  String get ng_aux_compression => 'Стиснення';

  @override
  String get ng_aux_compression_hint =>
      'Скорочує довгий чат, щоб він уміщався в контекстне вікно';

  @override
  String get ng_aux_approval => 'Схвалення';

  @override
  String get ng_aux_approval_hint =>
      'Вирішує, чи можна безпечно виконати команду без запиту';

  @override
  String get ng_aux_mcp => 'MCP';

  @override
  String get ng_aux_mcp_hint => 'Вибирає, які інструменти MCP використовувати';

  @override
  String get ng_aux_title_generation => 'Назви чатів';

  @override
  String get ng_aux_title_generation_hint => 'Дає назви новим чатам';

  @override
  String get ng_aux_review => 'Рев’ю';

  @override
  String get ng_aux_review_hint =>
      'Перевіряє роботу, коли ви запускаєте /review';

  @override
  String get ng_aux_voice_chat => 'Голосовий чат';

  @override
  String get ng_aux_voice_chat_hint => 'Відповідає в голосовому режимі';

  @override
  String get ng_aux_triage_specifier => 'Тріаж';

  @override
  String get ng_aux_triage_specifier_hint =>
      'Розгортає однорядкову картку Kanban у специфікацію';

  @override
  String get ng_aux_kanban_decomposer => 'Розбиття Kanban';

  @override
  String get ng_aux_kanban_decomposer_hint =>
      'Ділить картку Kanban на менші завдання';

  @override
  String get ng_aux_profile_describer => 'Описи профілів';

  @override
  String get ng_aux_profile_describer_hint =>
      'Пише короткий опис кожного профілю';

  @override
  String get ng_aux_curator => 'Куратор';

  @override
  String get ng_aux_curator_hint => 'Перевіряє, як використовуються навички';

  @override
  String get appearance_save_failed => 'Не вдалося зберегти цю зміну.';

  @override
  String get appearance_keep_which_theme => 'Яку тему залишити?';

  @override
  String get appearance_tour_back => 'Назад';

  @override
  String get appearance_tour_finish => 'Завершити';

  @override
  String get appearance_tour_next => 'Далі';

  @override
  String get appearance_tour_close => 'Закрити огляд';

  @override
  String get appearance_dismiss_tip => 'Приховати підказку';

  @override
  String get appearance_search_settings => 'Пошук налаштувань';

  @override
  String get appearance_search_show => 'Показати';

  @override
  String get appearance_no_matching_setting =>
      'Відповідного налаштування немає.';

  @override
  String get appearance_replay_tour => 'Повторити огляд';

  @override
  String get appearance_show_tips_again => 'Знову показувати підказки';

  @override
  String get appearance_window_translucency_unavailable =>
      'Напівпрозорість вікна недоступна на цьому хості. Linux її не забезпечує, а оболонки Apple і Windows малюють непрозоре подання Flutter.';

  @override
  String get appearance_imported_themes => 'Імпортовані теми';

  @override
  String get appearance_import_theme_file => 'Імпортувати файл теми';

  @override
  String get appearance_remove_theme => 'Вилучити тему';

  @override
  String get appearance_chat_font => 'Шрифт чату';

  @override
  String get appearance_terminal_font => 'Шрифт термінала';

  @override
  String get appearance_font_platform => 'Платформа';

  @override
  String get appearance_automatic => 'Автоматично';

  @override
  String get appearance_force_left_to_right => 'Примусово зліва направо';

  @override
  String get appearance_force_right_to_left => 'Примусово справа наліво';

  @override
  String get appearance_user_bubble_opacity =>
      'Непрозорість бульбашки користувача';

  @override
  String get appearance_inline_embeds => 'Вбудований вміст';

  @override
  String get appearance_inline_embeds_hint =>
      'Розширені попередні перегляди завантажуються зі сторонніх сайтів (YouTube, X, …). «Запитувати» показує заповнювач, доки ви не дозволите кожен; «Завжди» завантажує їх автоматично; «Вимк.» залишає звичайні посилання.';

  @override
  String get appearance_embeds_ask => 'Запитувати';

  @override
  String get appearance_embeds_always => 'Завжди';

  @override
  String get appearance_embeds_off => 'Вимк.';

  @override
  String appearance_embeds_reset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Скинути $count дозволеного сервісу',
      many: 'Скинути $count дозволених сервісів',
      few: 'Скинути $count дозволені сервіси',
      one: 'Скинути $count дозволений сервіс',
    );
    return '$_temp0';
  }

  @override
  String get appearance_embed_load => 'Завантажити';

  @override
  String appearance_embed_always_allow(String service) {
    return 'Завжди дозволяти $service';
  }

  @override
  String get appearance_embed_loading => 'Завантаження попереднього перегляду…';

  @override
  String appearance_embed_image_failed(String host) {
    return 'Не вдалося завантажити зображення з $host. Торкніться, щоб відкрити.';
  }

  @override
  String get appearance_embed_preview_unavailable =>
      'Попередній перегляд недоступний';

  @override
  String get appearance_emoji_reactions => 'Реакції емодзі';

  @override
  String get appearance_celebration_hearts => 'Святкові сердечка';

  @override
  String get appearance_celebration_hearts_hint =>
      'Сердечко анімується, коли відповідь надходить за вашої відсутності.';

  @override
  String get appearance_pop_out_companion => 'Відкрити компаньйона окремо';

  @override
  String get appearance_mosskip => 'Mosskip';

  @override
  String get appearance_emberbun => 'Emberbun';

  @override
  String get appearance_tideling => 'Tideling';

  @override
  String get appearance_my_hatchling => 'Моє маля';

  @override
  String get appearance_at_rest => 'Відпочиває';

  @override
  String get appearance_working => 'Працює';

  @override
  String get appearance_thinking => 'Думає';

  @override
  String get appearance_waiting_for_you => 'Чекає на вас';

  @override
  String get appearance_reply_ready => 'Відповідь готова';

  @override
  String get appearance_turn_failed => 'Хід завершився помилкою';

  @override
  String get appearance_small => 'Малий';

  @override
  String get appearance_medium => 'Середній';

  @override
  String get appearance_large => 'Великий';

  @override
  String get appearance_hello => 'Привіт!';

  @override
  String get appearance_unread_reply => 'Непрочитана відповідь';

  @override
  String get appearance_compose => 'Написати';

  @override
  String get appearance_say_hello => 'Привітатися';

  @override
  String get appearance_pet_image_failed =>
      'Не вдалося відкрити це зображення. Виберіть менший PNG або JPEG.';

  @override
  String get appearance_pet_companion => 'Тваринка-компаньйон';

  @override
  String get appearance_pet_companion_hint =>
      'Показувати компаньйона під час спілкування.';

  @override
  String get appearance_adopt_a_companion => 'Прихистити компаньйона';

  @override
  String get appearance_roam_when_idle => 'Блукати під час бездіяльності';

  @override
  String get appearance_pet_size => 'Розмір тваринки';

  @override
  String get appearance_hatch_from_a_local_picture =>
      'Вивести з локального зображення';

  @override
  String get appearance_pet_image_limits =>
      'Виберіть PNG або JPEG (до 4 MiB, 4096 px на сторону та 8 MP). Спершу перегляньте результат. Виведення зберігає один портрет 24 × 24 пікселі й замінює попереднє маля.';

  @override
  String get appearance_choose_picture => 'Вибрати зображення';

  @override
  String get appearance_hatchling_preview => 'Попередній перегляд маляти';

  @override
  String get appearance_hatch_and_adopt => 'Вивести й прихистити';

  @override
  String get appearance_discard_draft => 'Відкинути чернетку';

  @override
  String get appearance_forget_saved_hatchling => 'Забути збережене маля';

  @override
  String get appearance_radio => 'Радіо';

  @override
  String appearance_radio_hint(String stations) {
    return 'Трансляції надходять безпосередньо від $stations і починаються лише після натискання «Відтворити». Пошук станцій залишається на цьому пристрої.';
  }

  @override
  String get appearance_radio_save_failed =>
      'Не вдалося зберегти налаштування радіо.';

  @override
  String get appearance_choose_a_station => 'Вибрати станцію';

  @override
  String get appearance_pause_radio => 'Призупинити радіо';

  @override
  String get appearance_play_radio => 'Увімкнути радіо';

  @override
  String get appearance_next_station => 'Наступна станція';

  @override
  String get appearance_radio_trace_semantics =>
      'Активність трансляції. Рівні звуку недоступні, тому ця лінія залишається рівною.';

  @override
  String get appearance_radio_is_off => 'Радіо вимкнено';

  @override
  String get appearance_paused => 'Призупинено';

  @override
  String get appearance_connecting => 'Підключення…';

  @override
  String get appearance_live => 'Наживо';

  @override
  String get appearance_stream_unavailable => 'Трансляція недоступна';

  @override
  String appearance_now_playing(String credit) {
    return 'Зараз відтворюється: $credit';
  }

  @override
  String get appearance_audio_only_waveform_unavailable =>
      'Лише аудіо · хвильова форма недоступна';

  @override
  String get appearance_volume => 'Гучність';

  @override
  String get appearance_search_presets => 'Пошук серед заданих станцій';

  @override
  String get appearance_no_stations_found => 'Станцій не знайдено';

  @override
  String appearance_unpin_station(String station) {
    return 'Відкріпити станцію: $station';
  }

  @override
  String appearance_pin_station(String station) {
    return 'Закріпити станцію: $station';
  }

  @override
  String get appearance_radio_picker_metadata_notice =>
      'Поки цей засіб вибору відкритий, станції, що відтворюються, можуть передавати дані про композиції безпосередньо від мовника.';

  @override
  String get appearance_message_from_your_companion =>
      'Повідомлення від вашого компаньйона';

  @override
  String get appearance_send_to_the_open_chat => 'Надіслати у відкритий чат';

  @override
  String get appearance_tour_theme_body =>
      'Імпортуйте колірну тему VS Code з файла на цьому пристрої, а потім виберіть варіант, який хочете залишити.';

  @override
  String get appearance_tour_fonts_title => 'Шрифти для читання';

  @override
  String get appearance_tour_fonts_body =>
      'Текст чату й код термінала використовують окремі гарнітури зі складу Ares.';

  @override
  String get appearance_tour_direction_title => 'Напрямок історії розмови';

  @override
  String get appearance_tour_direction_body =>
      'Залиште автоматичний вибір або примусово задайте напрямок історії розмови зліва направо чи справа наліво.';

  @override
  String get appearance_tour_pet_title => 'Компаньйон';

  @override
  String get appearance_tour_pet_body =>
      'Компаньйон вимкнений, доки ви його не прихистите. Окреме вікно додає невелике поле введення.';

  @override
  String get appearance_tour_radio_body =>
      'Радіо залишається вимкненим, доки ви його не ввімкнете. Саме натискання «Відтворити» відкриває трансляцію.';

  @override
  String get appearance_tip_theme =>
      'Імпортовані теми замінюють вбудовану палітру, доки ви не очистите вибір. Зберігаються лише кольори.';

  @override
  String get appearance_tip_pet =>
      'Компаньйон зберігає один невеликий портрет на цьому пристрої. Зображення, з якого ви виводите маля, не завантажується на сервер.';

  @override
  String get appearance_theme_import_failed =>
      'Не вдалося імпортувати цю тему. Виберіть колірну тему VS Code, збережену як файл .vsix, .json або .jsonc.';

  @override
  String get render_widget_file_truncated =>
      'Прочитано лише початок цього файлу, тому віджет може бути неповним.';

  @override
  String get setup_beat_title => 'Налаштування';

  @override
  String setup_beat_use_name(String name) {
    return 'Використати $name';
  }

  @override
  String get setup_beat_name_hint => 'Як Hermes має вас називати?';

  @override
  String get setup_beat_on_computer =>
      'Цей крок виконується в Hermes на комп’ютері, де він працює. «Продовжити» зберігає те, що там уже налаштовано.';

  @override
  String get setup_beat_not_waiting =>
      'Ця картка налаштування більше не чекає на відповідь.';

  @override
  String get catalog_kind_plugin => 'Плагін';

  @override
  String get catalog_kind_skill => 'Навичка';

  @override
  String get catalog_tier_official => 'Офіційний';

  @override
  String get catalog_tier_verified => 'Перевірений';

  @override
  String get catalog_tier_community => 'Спільнота';

  @override
  String get catalog_install => 'Встановити';

  @override
  String get catalog_waiting => 'Чекає на ваш вибір';

  @override
  String get catalog_installed => 'Встановлено';

  @override
  String get catalog_installed_off => 'Встановлено, не ввімкнено';

  @override
  String get catalog_skipped => 'Пропущено';

  @override
  String get catalog_not_installed => 'Не встановлено';

  @override
  String catalog_target_profile(String profile) {
    return 'Встановлюється в профіль $profile';
  }

  @override
  String catalog_source(String repo, String sha) {
    return '$repo, коміт $sha';
  }

  @override
  String catalog_scan(String status, String summary) {
    return 'Перевірка безпеки: $status. $summary';
  }

  @override
  String catalog_requires_hermes(String range) {
    return 'Потрібен Hermes $range';
  }

  @override
  String catalog_skill_ready(String name) {
    return 'Навичка $name готова';
  }

  @override
  String catalog_missing_env(String names) {
    return 'Ще потрібно: $names';
  }

  @override
  String catalog_server_error(String name, String error) {
    return '$name не під’єднався: $error';
  }

  @override
  String get catalog_send_failed => 'Ваш вибір не надіслано. Спробуйте ще раз.';

  @override
  String get attachment_video_speed => 'Швидкість відтворення';

  @override
  String get catalog_installing => 'Встановлення…';

  @override
  String get catalog_phase_downloading => 'Завантаження…';

  @override
  String get catalog_phase_python_packages => 'Встановлення пакетів Python…';

  @override
  String get catalog_phase_loading_tools => 'Завантаження інструментів…';

  @override
  String get setup_beat_send_failed =>
      'Вашу відповідь не надіслано. Спробуйте ще раз.';

  @override
  String catalog_tool_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count інструмента',
      many: '$count інструментів',
      few: '$count інструменти',
      one: '$count інструмент',
    );
    return '$_temp0';
  }

  @override
  String get render_svg_not_drawn => 'Цей SVG не намальовано.';

  @override
  String get render_notes_directive => 'Директива нотаток';

  @override
  String get render_maths_source => 'Вихідний текст формули';

  @override
  String get render_inline_maths_source => 'Вихідний текст вбудованої формули';

  @override
  String get render_sequence_outline => 'Схема послідовності';

  @override
  String get render_diagram_outline => 'Схема діаграми';

  @override
  String render_revision_of(int index, int count) {
    return 'Версія $index з $count';
  }

  @override
  String get render_previous_revision => 'Попередня версія';

  @override
  String get render_next_revision => 'Наступна версія';

  @override
  String get render_show_rendered => 'Відображення';

  @override
  String get render_show_source => 'Вихідний код';

  @override
  String render_copied_file(String name) {
    return '$name скопійовано';
  }

  @override
  String render_copy_file(String name) {
    return 'Копіювати $name';
  }

  @override
  String get render_artifact_too_long =>
      'Цей артефакт задовгий, щоб показати його тут як сторінку.';

  @override
  String get render_active_content_removed =>
      'Скрипти, фрейми та зовнішні адреси видалено.';

  @override
  String render_widget_file(String file) {
    return 'Віджет $file';
  }

  @override
  String get render_widget_runs_as_text =>
      'Працює як текст у цьому чаті. Скрипти та зовнішні фрейми видаляються.';

  @override
  String get render_load_widget => 'Завантажити віджет';

  @override
  String get render_not_html_widget => 'Цей файл не є HTML-віджетом.';

  @override
  String get render_widget_sent => 'Надіслано в цей чат';

  @override
  String get render_widget_not_sent => 'Не надіслано в цей чат';

  @override
  String get render_widget_throttled =>
      'Зачекайте трохи перед повторним надсиланням';

  @override
  String get render_widget_too_long => 'Цей запит задовгий для надсилання';

  @override
  String get render_widget_no_gesture =>
      'Щоб надіслати, торкніться елемента керування у віджеті';

  @override
  String get render_widget_invalid => 'Не вдалося надіслати цей запит';

  @override
  String get render_inspected_image => 'Переглянуте зображення';

  @override
  String get render_contributions => 'Доповнення';

  @override
  String get render_contributions_intro =>
      'Доповнювати відповідь можуть лише доповнення, вбудовані в Ares. Текст чату не може їх зареєструвати, а дозвіл діє лише для цього підключення.';

  @override
  String render_grant_plugin(String name) {
    return 'Дозволити $name';
  }

  @override
  String render_revoke_plugin(String name) {
    return 'Відкликати $name';
  }

  @override
  String render_plugin_slots(String directive) {
    return 'картки відповіді для ::$directive';
  }

  @override
  String get render_plugin_notes => 'Нотатки';

  @override
  String get catalog_scan_passed => 'пройдено';

  @override
  String get catalog_scan_warnings => 'знайдено попередження';

  @override
  String get catalog_scan_failed => 'не пройдено';

  @override
  String get deployment_token_label => 'Токен розгортання (необов’язково)';

  @override
  String get deployment_token_helper =>
      'Для токенів сеансу Hermes Dashboard, що надсилаються як X-Hermes-Session-Token. Не зберігається відкритим текстом у налаштуваннях.';

  @override
  String get deployment_token_hint => 'Токен сеансу панелі';

  @override
  String get custom_headers_label => 'Власні заголовки (необов’язково)';

  @override
  String get custom_headers_helper =>
      'По одному в рядку, напр. X-Custom: значення. Заборонені заголовки відхиляються.';

  @override
  String get custom_headers_hint => 'напр. X-Custom-Header: значення';

  @override
  String get desktop_tray_open => 'Відкрити Ares';

  @override
  String get desktop_tray_new_chat => 'Новий чат';

  @override
  String get desktop_tray_quick_entry => 'Швидке введення…';

  @override
  String get desktop_tray_pause_notifications => 'Призупинити сповіщення';

  @override
  String get desktop_tray_quit => 'Вийти з Ares';

  @override
  String get desktop_integration_title => 'Інтеграція з робочим столом';

  @override
  String get desktop_tray_setting =>
      'Показувати Ares у системному треї або рядку меню';

  @override
  String get desktop_tray_setting_help =>
      'Через значок можна відкрити Ares, почати чат, відкрити швидке введення, призупинити сповіщення або вийти.';

  @override
  String get desktop_close_to_tray_setting =>
      'Продовжувати роботу в треї після закриття вікна';

  @override
  String get desktop_tray_unsupported =>
      'У цьому середовищі немає системного трею, доступного для Ares.';

  @override
  String get quick_entry_title => 'Швидке введення';

  @override
  String get quick_entry_hint => 'Введіть запит для Ares…';

  @override
  String get quick_entry_submit => 'Вставити в поле введення';

  @override
  String get quick_entry_never_sends =>
      'Enter вставляє текст у поле введення чату. Нічого не надсилається, доки ви не натиснете «Надіслати».';

  @override
  String get quick_entry_unavailable =>
      'Не вдалося відкрити швидке введення. Спробуйте ще раз.';

  @override
  String get desktop_hotkey_setting =>
      'Комбінація клавіш для швидкого введення';

  @override
  String desktop_hotkey_help(String shortcut) {
    return 'Натисніть $shortcut будь-де, щоб відкрити швидке введення.';
  }

  @override
  String desktop_hotkey_conflict(String shortcut) {
    return '$shortcut уже використовує інший застосунок. Виберіть іншу комбінацію.';
  }

  @override
  String get desktop_hotkey_unsupported =>
      'Це середовище не дозволяє застосункам реєструвати глобальні комбінації клавіш (наприклад, Wayland).';

  @override
  String get desktop_hotkey_no_modifier => 'Додайте Cmd, Ctrl або Alt.';

  @override
  String get desktop_hotkey_super_key =>
      'Клавіша Windows або Super зарезервована системою.';

  @override
  String get desktop_hotkey_reserved =>
      'Цю комбінацію вже використовує система.';

  @override
  String desktop_hotkey_in_app(String action) {
    return 'Ares уже використовує цю комбінацію для дії «$action».';
  }

  @override
  String get desktop_hotkey_change => 'Змінити';

  @override
  String get desktop_hotkey_reset => 'За замовчуванням';

  @override
  String get capture_screen_action => 'Знімок екрана';

  @override
  String get capture_screen_help =>
      'Додає знімок екрана до повідомлення як чернетку. Нічого не надсилається, доки ви не натиснете «Надіслати».';

  @override
  String get capture_screen_unavailable =>
      'Знімок екрана недоступний у цьому середовищі.';

  @override
  String get capture_screen_failed =>
      'Не вдалося зробити знімок екрана. Спробуйте ще раз.';

  @override
  String get capture_permission_title => 'Дозвольте запис екрана';

  @override
  String get capture_permission_body =>
      'Щоб зробити знімок вікна, Ares потрібен дозвіл на запис екрана. Увімкніть Ares у «Системні параметри» > «Приватність і безпека» > «Запис екрана», а потім спробуйте ще раз.';

  @override
  String get capture_open_settings => 'Відкрити Системні параметри';

  @override
  String get keep_awake_title => 'Не давати комп’ютеру засинати';

  @override
  String get keep_awake_title_mobile => 'Не вимикати екран';

  @override
  String get keep_awake_mode_off => 'Вимк.';

  @override
  String get keep_awake_mode_while_working => 'Під час роботи';

  @override
  String get keep_awake_mode_always => 'Завжди';

  @override
  String get keep_awake_off_help =>
      'Ніколи не заважати переходу в сон (типово).';

  @override
  String get keep_awake_while_working_help =>
      'Не давати засинати від бездіяльності, лише поки триває хід агента.';

  @override
  String get keep_awake_always_help =>
      'Не давати засинати від бездіяльності, поки Ares відкрито на цьому пристрої.';

  @override
  String get keep_awake_off_help_mobile =>
      'Екран вимикається як зазвичай (типово).';

  @override
  String get keep_awake_while_working_help_mobile =>
      'Не вимикати екран, поки триває хід агента й Ares відкрито.';

  @override
  String get keep_awake_always_help_mobile =>
      'Не вимикати екран, поки Ares відкрито.';

  @override
  String get ng_token_gateway_has_no_sign_in =>
      'Цей шлюз не має входу, тому не може перевірити токен розгортання. Увімкніть автентифікацію панелі на хості (або оновіть Hermes) і спробуйте ще раз.';

  @override
  String get palette_open => 'Палітра команд застосунку';

  @override
  String get palette_no_matches => 'Немає відповідних дій';

  @override
  String get palette_filter_hint => 'Введіть текст, щоб відфільтрувати дії…';

  @override
  String get palette_keys_move => '↑↓ — переміщення';

  @override
  String get palette_keys_run => 'Enter — виконати';

  @override
  String get palette_keys_close => 'Esc — закрити';

  @override
  String get palette_search_sessions => 'Пошук сеансів';

  @override
  String get palette_scheduled_crons => 'Заплановані / Cron';

  @override
  String get palette_capabilities_skills => 'Можливості та навички';

  @override
  String get palette_insights_usage => 'Аналітика та використання';

  @override
  String get palette_more_projects => 'Більше та проєкти';

  @override
  String get deeplink_chat_not_found =>
      'Чат не знайдено у списку. Можливо, він ще не завантажився.';

  @override
  String get keyboard_shortcuts_title => 'Сполучення клавіш';

  @override
  String get shortcuts_reset_all => 'Скинути все';

  @override
  String get shortcuts_reset_to_default => 'Повернути типове';

  @override
  String get shortcut_action_command_palette => 'Палітра команд';

  @override
  String get shortcut_action_new_chat => 'Новий чат';

  @override
  String get shortcut_action_search => 'Пошук';

  @override
  String get shortcut_action_settings => 'Налаштування';

  @override
  String shortcut_action_go_to_tab(int number) {
    return 'Перейти на вкладку $number';
  }

  @override
  String shortcuts_conflict(String first, String second, String chord) {
    return 'Конфлікт: «$first» і «$second» використовують $chord. Власне сполучення лишається типовим, доки ви не зміните одне з них.';
  }

  @override
  String shortcuts_editor_title(String action) {
    return 'Сполучення: $action';
  }

  @override
  String get shortcuts_editor_help =>
      'Натисніть сполучення клавіш або виберіть нижче модифікатори та клавішу:';

  @override
  String get shortcuts_editor_needs_modifier =>
      'Виберіть принаймні Cmd/Meta, Ctrl або Alt, щоб не заважати введенню в полі повідомлення.';

  @override
  String shortcuts_text_editing_warning(String chord) {
    return '$chord — сполучення для редагування тексту (копіювати, вставити, вирізати, скасувати, повторити або виділити все). Якщо призначити його тут, текстові поля його втратять.';
  }

  @override
  String shortcuts_text_editing_in_use(String action, String chord) {
    return '«$action» використовує $chord — сполучення для редагування тексту. Поки воно призначене тут, текстові поля його втрачають.';
  }

  @override
  String custom_headers_problem_format(int line) {
    return 'Рядок $line: очікується «Назва: Значення»';
  }

  @override
  String custom_headers_problem_missing_name(int line) {
    return 'Рядок $line: немає назви заголовка';
  }

  @override
  String custom_headers_problem_invalid_name(int line, String name) {
    return 'Рядок $line: неприпустима назва заголовка «$name»';
  }

  @override
  String custom_headers_problem_reserved(int line, String name) {
    return 'Рядок $line: «$name» зарезервовано, його не можна передавати';
  }

  @override
  String custom_headers_problem_empty_value(int line) {
    return 'Рядок $line: порожнє значення заголовка';
  }

  @override
  String get ng_enter_a_deployment_token => 'Введіть токен сеансу розгортання.';

  @override
  String get ng_custom_headers => 'Власні заголовки';

  @override
  String get ng_custom_headers_help =>
      'Додаткові HTTP-заголовки для цього шлюзу (Назва: Значення, по одному в рядку), надсилаються в його викликах REST і WebSocket. Зберігаються в захищеному сховищі облікових даних. Заголовки автентифікації та hop-by-hop відхиляються.';

  @override
  String get ng_use_a_deployment_token =>
      'Використати токен сеансу розгортання';

  @override
  String get ng_sign_in_with_deployment_token => 'Увійти з токеном розгортання';

  @override
  String get ng_signed_in_with_deployment_token =>
      'Вхід виконано з токеном розгортання.';

  @override
  String get auto_speak_replies_title => 'Читати відповіді вголос';

  @override
  String get auto_speak_replies_subtitle =>
      'Читає кожен новий відгук уголос після завершення ходу. За замовчуванням вимкнено; перемикач «Spoken replies» у чаті все ще застосовується.';

  @override
  String get ng_auto_read_replies_title => 'Читати відповіді автоматично';

  @override
  String get ng_auto_read_replies_subtitle =>
      'Читає кожен новий відгук уголос після завершення ходу. За замовчуванням вимкнено.';

  @override
  String get barge_in_title => 'Перервати';

  @override
  String get barge_in_subtitle =>
      'Говоріть під час відповіді, щоб перервати читання. Мікрофон залишається увімкненим, поки відповіді читаються вголос.';

  @override
  String get barge_in_mic_live =>
      'Мікрофон увімкнено: говоріть, щоб перервати відповідь';

  @override
  String get ng_barge_in_title => 'Перервати';

  @override
  String get ng_barge_in_subtitle =>
      'Говоріть під час відповіді, щоб перервати читання. Мікрофон залишається увімкненим, поки відповіді читаються вголос.';

  @override
  String get ng_barge_in_mic_live =>
      'Мікрофон увімкнено: говоріть, щоб перервати відповідь';

  @override
  String get wake_word_title => 'Ключова фраза';

  @override
  String get wake_word_subtitle =>
      'Розпізнавання ключової фрази на шлюзі. За замовчуванням вимкнено; передає аудіо лише під час клієнтського захоплення.';

  @override
  String wake_word_listening(String phrase) {
    return 'Очікування ключової фрази «$phrase»';
  }

  @override
  String wake_word_paused(String phrase) {
    return 'Ключова фраза «$phrase» — призупинено';
  }

  @override
  String wake_word_off(String phrase) {
    return 'Ключова фраза «$phrase» — вимкнено';
  }

  @override
  String get wake_word_arming => 'Увімкнення ключової фрази…';

  @override
  String get wake_word_stop => 'Зупинити ключову фразу';

  @override
  String get wake_word_rearm => 'Перезапустити';

  @override
  String get wake_word_capture_mode => 'Режим захоплення';

  @override
  String get wake_word_capture_auto => 'Автоматично';

  @override
  String get wake_word_capture_client => 'Мікрофон цього пристрою';

  @override
  String get wake_word_capture_local => 'Мікрофон хоста шлюзу';

  @override
  String get wake_word_capture_unavailable =>
      'Цей шлюз не дозволяє застосункам змінювати режим захоплення. Задайте wake_word.capture у конфігурації Hermes на хості шлюзу.';

  @override
  String get wake_word_input_device => 'Вхідний мікрофон';

  @override
  String get wake_word_default_device => 'Системний за замовчуванням';

  @override
  String get ng_wake_word_title => 'Ключова фраза';

  @override
  String get ng_wake_word_subtitle =>
      'Розпізнавання ключової фрази на шлюзі. За замовчуванням вимкнено.';

  @override
  String get voice_engine_title => 'Рушій голосової розмови';

  @override
  String get voice_engine_subtitle =>
      'Виберіть, як працюють голосові розмови без рук у цьому профілі шлюзу.';

  @override
  String get voice_engine_chained =>
      'Ланцюжок (мовлення в текст → Hermes → мовлення)';

  @override
  String get voice_engine_chained_short => 'Ланцюжок';

  @override
  String get voice_engine_live => 'GPT-Live (голос у реальному часі)';

  @override
  String get voice_engine_live_short => 'GPT-Live';

  @override
  String get voice_engine_live_needs_key =>
      'Укажіть ключ OpenAI API на хості шлюзу, щоб увімкнути GPT-Live.';

  @override
  String voice_engine_fallback_chained(String reason) {
    return 'GPT-Live недоступний ($reason) — використовується голос ланцюжком.';
  }

  @override
  String get voice_live_start => 'Почати голосову розмову';

  @override
  String get voice_live_stop => 'Завершити голосову розмову';

  @override
  String get voice_live_mute => 'Вимкнути мікрофон';

  @override
  String get voice_live_unmute => 'Увімкнути мікрофон';

  @override
  String get voice_live_interrupt => 'Перервати або відповісти зараз';

  @override
  String get voice_live_listening => 'Слухає';

  @override
  String get voice_live_speaking => 'Говорить';

  @override
  String get voice_live_thinking => 'Думає';

  @override
  String get voice_live_muted => 'Мікрофон вимкнено';

  @override
  String get voice_live_ended_connection_lost =>
      'Сеанс живого голосу втратив з’єднання.';

  @override
  String get voice_live_ended_closed => 'Сеанс живого голосу закрито сервісом.';

  @override
  String wake_word_other_profile(String profile) {
    return 'Це слово активації належить профілю «$profile». Відкрийте підключення до цього профілю, щоб відповісти.';
  }

  @override
  String get wake_word_reason_disabled =>
      'Вимкнено — торкніться, щоб увімкнути';

  @override
  String get wake_word_reason_surface =>
      'Обмежено іншим інтерфейсом (налаштування wake_word.surface)';

  @override
  String get wake_word_reason_owned =>
      'Прослуховування ключової фрази зайняте іншим інтерфейсом';

  @override
  String wake_word_reason_owned_by(String surface) {
    return 'Прослуховування ключової фрази зайняте іншим інтерфейсом ($surface)';
  }

  @override
  String get wake_word_reason_unavailable =>
      'Ключова фраза недоступна на цьому шлюзі';

  @override
  String get wake_word_reason_permission_denied =>
      'Доступ до мікрофона заборонено';

  @override
  String get wake_word_reason_permission_required =>
      'Потрібен доступ до мікрофона — торкніться, щоб увімкнути';

  @override
  String get voice_live_not_enabled =>
      'GPT-Live не ввімкнено для цього профілю.';

  @override
  String get voice_live_not_available => 'GPT-Live недоступний';

  @override
  String voice_live_start_failed(String error) {
    return 'Не вдалося запустити GPT-Live: $error';
  }

  @override
  String voice_direct_stt_timeout(String seconds, String provider) {
    return 'Розпізнавання мовлення не завершилося за $seconds с ($provider не відповів)';
  }

  @override
  String voice_direct_stt_error(String provider, String status) {
    return 'Помилка STT $provider (HTTP $status)';
  }

  @override
  String voice_direct_tts_failed(String provider) {
    return 'Запит TTS до $provider не виконано';
  }

  @override
  String voice_direct_tts_error(String provider, String status) {
    return 'Помилка TTS $provider (HTTP $status)';
  }

  @override
  String ng_wake_status_listening(String phrase) {
    return 'Слухає («$phrase»)';
  }

  @override
  String ng_wake_status_off(String phrase) {
    return 'Вимкнено («$phrase»)';
  }

  @override
  String ng_wire_setting_unavailable(Object setting) {
    return 'Зміна параметра $setting поки недоступна на спільному шлюзі';
  }

  @override
  String ng_wire_method_unavailable(Object method) {
    return 'Запит $method поки недоступний на спільному шлюзі';
  }

  @override
  String ng_wire_session_options_unsupported(Object options) {
    return 'Канонічний шлюз не підтримує явні параметри сеансу: $options';
  }

  @override
  String get ng_wire_prompt_stale =>
      'Запит застарів або недоступний; під’єднайтеся знову, перш ніж відповідати';

  @override
  String get ng_wire_revision_unavailable =>
      'Ревізія сеансу недоступна; відкрийте сеанс знову, перш ніж редагувати метадані';

  @override
  String get ng_wire_generation_unavailable =>
      'Ідентифікатор виконання сеансу недоступний; під’єднайтеся знову перед цією командою';

  @override
  String get ng_wire_message_not_saved =>
      'Це повідомлення ще не збережено; дочекайтеся його завершення і створіть гілку від нього ще раз';

  @override
  String get ng_wire_not_available => 'Поки недоступно на спільному шлюзі';

  @override
  String get edit_turn_title => 'Редагувати цей запит?';

  @override
  String get edit_turn_body =>
      'Запит буде повторно виконано звідси. Наступні ходи буде заархівовано.';

  @override
  String get edit_turn_send => 'Надіслати';

  @override
  String get restore_turn_title => 'Відновити до цієї контрольної точки?';

  @override
  String get restore_turn_body =>
      'Усе після цього запиту буде вилучено з розмови, а запит виконається знову звідси.';

  @override
  String get restore_turn_confirm => 'Відновити й запустити знову';

  @override
  String get edit_turn_later_turns_body =>
      'Це заархівує наступні ходи розмови. Продовжити?';

  @override
  String get session_history => 'Історія сесії';

  @override
  String get import_claude_or_codex => 'Імпортувати Claude або Codex';

  @override
  String get ng_session_history => 'Історія сесії';

  @override
  String get ng_import_claude_or_codex => 'Імпортувати Claude або Codex';

  @override
  String get ng_edit_and_resend => 'Редагувати й надіслати знову';

  @override
  String get ng_restore_turn_confirm => 'Відновити й запустити знову';

  @override
  String get rewind_target_unsaved =>
      'Це повідомлення ще не збережено. Дочекайтеся завершення й відредагуйте його знову.';

  @override
  String get rewind_turn_busy =>
      'Поточну відповідь ще не зупинено, тому нічого не надіслано. Спробуйте ще раз за мить.';

  @override
  String get rewind_session_changed =>
      'Цей чат змінився відтоді, як його відкрили тут, тому нічого не вилучено й не надіслано. Відкрийте його знову та повторіть спробу.';

  @override
  String get history_lineage => 'Пов’язані чати';

  @override
  String get history_lineage_none =>
      'Цей чат не має відгалужень чи сусідніх гілок.';

  @override
  String get history_lineage_unavailable =>
      'Не вдалося прочитати пов’язані чати з цього шлюзу.';

  @override
  String get history_lineage_parent => 'Батьківський';

  @override
  String get history_lineage_sibling => 'Сусідня гілка';

  @override
  String get history_lineage_fork => 'Відгалуження';

  @override
  String get history_messages => 'Повідомлення';

  @override
  String get history_messages_hint =>
      'Виберіть збережене повідомлення, щоб створити гілку або відкотитися до нього.';

  @override
  String get history_messages_none => 'Збережених повідомлень ще немає.';

  @override
  String get history_messages_unavailable =>
      'Не вдалося прочитати збережені повідомлення. Відкрийте цей чат і оновіть.';

  @override
  String get history_role_user => 'Ви';

  @override
  String get history_role_assistant => 'Hermes';

  @override
  String get history_branch_here => 'Створити гілку звідси';

  @override
  String get history_rewind_here => 'Відкотити сюди';

  @override
  String get history_branch_title => 'Створити гілку від цього повідомлення';

  @override
  String get history_branch_body =>
      'Буде створено новий чат з історією до вибраного повідомлення. Поточний чат залишиться без змін.';

  @override
  String get history_rewind_title => 'Відкотити до цього повідомлення';

  @override
  String get history_rewind_body =>
      'Повідомлення, починаючи з вибраного, буде вилучено з цього чату. Файли на комп’ютері не зміняться. Їх відновлення виконується окремо через контрольні точки.';

  @override
  String history_branched(String id) {
    return 'Створено гілку $id';
  }

  @override
  String get history_open_chat => 'Відкрити чат';

  @override
  String get history_mutate_unsupported =>
      'Для гілок і відкату на цьому шлюзі потрібен Hermes 0.23 або новіший.';

  @override
  String get history_checkpoints => 'Контрольні точки';

  @override
  String get history_checkpoints_none =>
      'У цій сесії немає контрольних точок файлів.';

  @override
  String get history_checkpoints_unavailable =>
      'Контрольні точки недоступні на цьому шлюзі.';

  @override
  String get history_diff_none => 'Відмінностей немає.';

  @override
  String get history_diff_loading => 'Завантаження змін…';

  @override
  String get history_diff_failed =>
      'Не вдалося завантажити зміни, тому цю контрольну точку поки не можна відновити.';

  @override
  String get history_restore_checkpoint => 'Відновити контрольну точку';

  @override
  String get history_restore_title => 'Відновити цю контрольну точку';

  @override
  String get history_restore_body =>
      'Файли, які агент змінив після цієї контрольної точки, повернуться до тодішнього стану. Ваші власні зміни збережуться. Пізніші повідомлення чату також можуть бути вилучені. Гілка розмови не створюється.';

  @override
  String get history_restore_body_all =>
      'Усі файли в теці сесії повернуться до цієї контрольної точки, включно з вашими власними змінами. Пізніші повідомлення чату також можуть бути вилучені. Гілка розмови не створюється.';

  @override
  String get history_restore_own_edits => 'Скасувати й мої власні зміни';

  @override
  String get history_restored => 'Контрольну точку відновлено.';

  @override
  String history_restored_removed(int count) {
    return 'Контрольну точку відновлено. Вилучено повідомлень чату: $count.';
  }

  @override
  String get history_export => 'Експорт';

  @override
  String get history_export_redact => 'Приховувати токени';

  @override
  String get history_export_action => 'Експортувати розшифровку';

  @override
  String get history_export_saved => 'Розшифровку збережено.';

  @override
  String get history_export_unsupported =>
      'Для експорту на цьому шлюзі потрібен Hermes 0.23 або новіший.';

  @override
  String get history_import_unsupported =>
      'Цей шлюз не підтримує імпорт із Claude та Codex.';

  @override
  String history_import_destination(String profile) {
    return 'Профіль призначення: $profile.';
  }

  @override
  String history_import_reading(String host, String profile, int count) {
    return 'Читання з $host · Профіль призначення: $profile. Не вдалося прочитати журналів: $count.';
  }

  @override
  String get history_import_all => 'Усі';

  @override
  String history_import_scan_failed(String reason) {
    return 'Не вдалося переглянути сесії хоста: $reason';
  }

  @override
  String get history_import_none =>
      'На цьому хості не знайдено сесій Claude Code чи Codex.';

  @override
  String get history_import_no_match => 'Відповідних сесій хоста немає.';

  @override
  String history_import_preview_failed(String reason) {
    return 'Не вдалося показати сесію: $reason';
  }

  @override
  String get history_import_open => 'Відкрити імпортовану сесію';

  @override
  String get history_import_action => 'Імпортувати вибрану сесію';

  @override
  String get history_import_title => 'Імпортувати цю сесію';

  @override
  String history_import_body(String profile) {
    return 'Скопіювати цю сесію Claude чи Codex у профіль «$profile» на цьому шлюзі.';
  }

  @override
  String history_import_body_existing(String profile) {
    return 'Цю сесію вже імпортовано в «$profile». Продовжити з наявною копією.';
  }

  @override
  String history_imported(String id) {
    return 'Імпортовано як $id';
  }

  @override
  String history_imported_already(String id) {
    return 'Уже імпортовано як $id';
  }

  @override
  String history_import_directory(String path) {
    return 'Каталог: $path';
  }

  @override
  String history_import_preview_partial(int shown, int total) {
    return 'Показано $shown із $total.';
  }

  @override
  String history_failed(String reason) {
    return 'Не вдалося завершити: $reason';
  }

  @override
  String get history_error_unavailable =>
      'Шлюз не зміг виконати це зараз. Спробуйте ще раз.';

  @override
  String get history_error_unsupported => 'Цей шлюз цього не підтримує.';

  @override
  String get history_error_denied => 'Цей шлюз відхилив запит.';

  @override
  String get history_error_changed =>
      'Цей чат змінився, поки сторінка була відкрита. Оновіть і спробуйте ще раз.';

  @override
  String get history_error_unbound =>
      'Цей чат не відкрито на шлюзі. Відкрийте його і спробуйте ще раз.';

  @override
  String get history_error_invalid =>
      'Шлюз надіслав відповідь, яку застосунок не зміг прочитати.';

  @override
  String ng_dock_kanban(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count картки Kanban',
      many: '$count карток Kanban',
      few: '$count картки Kanban',
      one: '1 картка Kanban',
    );
    return '$_temp0';
  }

  @override
  String ng_dock_kanban_done(int count) {
    return '$count завершено';
  }

  @override
  String get ng_show_kanban => 'Показати картки Kanban';

  @override
  String get ng_hide_kanban => 'Приховати картки Kanban';

  @override
  String get ng_kanban_status_triage => 'Розбір';

  @override
  String get ng_kanban_status_todo => 'До виконання';

  @override
  String get ng_kanban_status_scheduled => 'Заплановано';

  @override
  String get ng_kanban_status_ready => 'Готово до роботи';

  @override
  String get ng_kanban_status_running => 'Виконується';

  @override
  String get ng_kanban_status_blocked => 'Заблоковано';

  @override
  String get ng_kanban_status_review => 'На перевірці';

  @override
  String get ng_kanban_status_done => 'Завершено';

  @override
  String get ng_kanban_status_archived => 'В архіві';

  @override
  String ng_kanban_open_card(String title) {
    return 'Відкрити «$title» у Kanban';
  }

  @override
  String ng_kanban_show_all(int count) {
    return 'Показати всі ($count)';
  }

  @override
  String ng_kanban_this_chat(int count) {
    return 'Цей чат ($count)';
  }

  @override
  String get ng_kanban_close => 'Закрити Kanban';

  @override
  String get ng_kanban_block_no_dashboard =>
      'Це підключення не має доступу до панелі керування, тому стан карток не оновлюється наживо, а дошку відкрити не можна.';

  @override
  String get ng_kanban_block_unsupported =>
      'Kanban не ввімкнено на цьому шлюзі. Увімкніть плагін kanban, щоб бачити стан наживо й відкривати дошку.';

  @override
  String get ng_kanban_block_denied =>
      'Увійдіть до панелі керування, щоб бачити стан карток наживо й відкривати дошку.';

  @override
  String get ng_kanban_block_insecure =>
      'Для Kanban потрібен HTTPS або локальне підключення, тому стан карток не оновлюється наживо, а дошку відкрити не можна.';

  @override
  String get ng_kanban_block_unreachable =>
      'Не вдалося зв’язатися з Kanban на цьому шлюзі. Стан карток може бути застарілим.';

  @override
  String get ng_kanban_block_stale =>
      'Підключення змінилося. Відкрийте цей чат знову, щоб бачити стан карток наживо.';

  @override
  String get ng_bots_tab_roster => 'Склад';

  @override
  String get ng_bots_tab_rooms => 'Кімнати';

  @override
  String get ng_bots_tab_screen => 'Екран';

  @override
  String get ng_bots_tab_routines => 'Рутини';

  @override
  String ng_bots_rooms_load_failed(String error) {
    return 'Не вдалося завантажити кімнати: $error';
  }

  @override
  String ng_bots_routines_load_failed(String error) {
    return 'Не вдалося завантажити рутини: $error';
  }

  @override
  String ng_bots_desktop_failed(String error) {
    return 'Bot Desktop: $error';
  }

  @override
  String get ng_bots_install_not_started => 'Шлюз не запустив встановлення.';

  @override
  String ng_bots_install_failed_error(String error) {
    return 'Помилка встановлення: $error';
  }

  @override
  String get ng_bots_install_cancelled => 'Встановлення скасовано.';

  @override
  String get ng_bots_install_no_sudo =>
      'sudo недоступний на хості шлюзу. Виконайте там команду вище, потім оновіть.';

  @override
  String ng_bots_install_exit_code(String code) {
    return 'Встановлення не вдалося (код виходу $code).';
  }

  @override
  String ng_bots_install_done(String bot) {
    return 'Bot Desktop встановлено для $bot';
  }

  @override
  String get ng_bots_start_failed => 'Не вдалося запустити';

  @override
  String ng_bots_stop_title(String bot) {
    return 'Зупинити Bot Desktop для $bot?';
  }

  @override
  String get ng_bots_stop_human_held =>
      'Хтось керує цим екраном. Зупинка завершить сеанс цієї людини й закриє все, що відкрито на екрані.';

  @override
  String get ng_bots_stop_body =>
      'Усе, що відкрито на екрані бота, буде закрито.';

  @override
  String get ng_bots_stop_refused => 'Зупинку відхилено';

  @override
  String get ng_bots_take_over_reason => 'Керування взято з Ares';

  @override
  String ng_bots_take_over_failed(String error) {
    return 'Не вдалося взяти керування: $error';
  }

  @override
  String ng_bots_force_hand_back_title(String bot) {
    return 'Повернути екран $bot боту?';
  }

  @override
  String get ng_bots_force_hand_back_body =>
      'Цим екраном керує людина. Якщо вона ще працює з ним, то втратить керування.';

  @override
  String get ng_bots_hand_back => 'Повернути керування';

  @override
  String get ng_bots_hand_back_failed => 'Не вдалося повернути керування';

  @override
  String get ng_bots_adopt_title => 'Перейти на новий образ пісочниці?';

  @override
  String ng_bots_adopt_body(String bot, String current, String target) {
    return '$bot переходить з $current на $target. Контейнер буде перестворено під час наступного виклику термінала; усе, що зберігається лише в поточному контейнері, буде втрачено.';
  }

  @override
  String get ng_bots_adopt_image => 'Перейти на образ';

  @override
  String get ng_bots_image_switch_failed => 'Не вдалося змінити образ';

  @override
  String get ng_bots_keep_refused => 'Запит на збереження образу відхилено';

  @override
  String ng_bots_chat_open_failed(String error) {
    return 'Не вдалося відкрити Bot Chat: $error';
  }

  @override
  String ng_bots_title(String connection) {
    return 'Боти · $connection';
  }

  @override
  String get ng_bots_protocol_tooltip =>
      'Шлюз сам додає протокол обміну повідомленнями між учасниками команди — додатковий протокол SOUL.md не надсилається.';

  @override
  String ng_bots_unavailable(String reason) {
    return 'Боти недоступні ($reason)';
  }

  @override
  String get ng_bots_account_changed =>
      'Обліковий запис змінився. Перепідключіться або оновіть.';

  @override
  String get ng_bots_try_refresh =>
      'Спробуйте оновити. Якщо проблема не зникне, можливо, шлюз не підтримує ботів.';

  @override
  String get ng_bots_search => 'Пошук ботів';

  @override
  String get ng_bots_none_found => 'Ботів не знайдено.';

  @override
  String get ng_bots_no_model => 'немає моделі';

  @override
  String ng_bots_skill_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count навички',
      many: '$count навичок',
      few: '$count навички',
      one: '$count навичка',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_bot_chat => 'Bot Chat';

  @override
  String ng_bots_install_id(String id, String protocol) {
    return 'Шлюз повідомляє ID встановлення $id · bot_mode_protocol: $protocol';
  }

  @override
  String get ng_bots_protocol_note =>
      'Шлюз додає протокол обміну повідомленнями між учасниками команди, якщо задано bot_mode_protocol. Ідентифікатор: default→hermes, в інших випадках — назва профілю.';

  @override
  String get ng_bots_no_rooms =>
      'Кімнат поки немає. Створіть кімнату зі складу ботів.';

  @override
  String ng_bots_member_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count учасника',
      many: '$count учасників',
      few: '$count учасники',
      one: '$count учасник',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_room_disbanded => 'розформована';

  @override
  String get ng_bots_room_adopted => 'прийнята';

  @override
  String get ng_bots_rooms_gateway => 'Кімнати шлюзу';

  @override
  String get ng_bots_rooms_desktop => 'Кімнати під керуванням Desktop';

  @override
  String ng_bots_rooms_gateway_body(String methods) {
    return 'Кімнати належать шлюзу. Методи: $methods.';
  }

  @override
  String get ng_bots_rooms_no_seat =>
      'Цей шлюз, можливо, не може розміщувати кімнати (потрібен постійний процес).';

  @override
  String get ng_bots_rooms_fallback =>
      'Класичний резервний режим: Desktop веде раунди групи (тут нові не створюються).';

  @override
  String get ng_bots_create_room => 'Створити кімнату';

  @override
  String get ng_bots_refresh_rooms => 'Оновити кімнати';

  @override
  String get ng_bots_room_created => 'Кімнату створено';

  @override
  String ng_bots_room_refused(String reason) {
    return 'Створення кімнати відхилено ($reason)';
  }

  @override
  String ng_bots_room_failed(String error) {
    return 'Не вдалося створити кімнату: $error';
  }

  @override
  String get ng_bots_bot => 'Бот';

  @override
  String get ng_bots_screen_unavailable => 'Стан екрана недоступний';

  @override
  String get ng_bots_screen_unavailable_body =>
      'Запустіть екран бота, щоб бачити мініатюру, або візьміть керування, щоб працювати з ним самостійно.';

  @override
  String get ng_bots_take_over_note =>
      '«Взяти керування» відкриває екран у реальному часі й передає вам керування ним. Керування повертається боту, коли ви закриваєте екран, залишаєте цю сторінку або переводите застосунок у фоновий режим.';

  @override
  String get ng_bots_not_installed => 'Не встановлено';

  @override
  String get ng_bots_unsupported_host => 'Непідтримуваний хост';

  @override
  String ng_bots_pid(String pid) {
    return 'pid $pid';
  }

  @override
  String ng_bots_missing(String items) {
    return 'бракує: $items';
  }

  @override
  String ng_bots_blocked(String reason) {
    return 'заблоковано: $reason';
  }

  @override
  String get ng_bots_no_switch => 'Немає очікуваної зміни образу пісочниці.';

  @override
  String ng_bots_switch_image(String current, String target) {
    return 'зміна образу: $current → $target';
  }

  @override
  String get ng_bots_bot_in_control => 'керує бот';

  @override
  String get ng_bots_person_in_control => 'керує людина';

  @override
  String get ng_bots_installing => 'Встановлення Bot Desktop на хост шлюзу…';

  @override
  String get ng_bots_install_unfinished => 'Встановлення не завершено';

  @override
  String get ng_bots_install => 'Встановити';

  @override
  String get ng_bots_start => 'Запустити';

  @override
  String get ng_bots_take_over => 'Взяти керування';

  @override
  String get ng_bots_keep_image => 'Залишити поточний образ';

  @override
  String ng_bots_missing_pieces(String items) {
    return 'Шлюз повідомив про відсутні компоненти: $items';
  }

  @override
  String get ng_bots_install_missing => 'Встановити відсутні компоненти';

  @override
  String get ng_bots_thumbnail_unavailable => 'Мініатюра недоступна';

  @override
  String get ng_bots_thumbnail_title => 'Мініатюра екрана (у реальному часі)';

  @override
  String get ng_bots_thumbnail_suppressed =>
      'Мініатюру приховано, поки екраном керує людина.';

  @override
  String get ng_bots_thumbnail_pending => 'Мініатюра ще недоступна.';

  @override
  String ng_bots_routines_of(String bot) {
    return '$bot · рутини';
  }

  @override
  String get ng_bots_add_routine => 'Додати рутину';

  @override
  String get ng_bots_no_routines => 'У цього бота немає рутин.';

  @override
  String get ng_bots_routines_note =>
      'Рутини — це завдання з тегом [bot:<name>], що належать сховищу профілю бота. Застарілі делеговані рутини під час завантаження примусово призупиняються.';

  @override
  String ng_bots_routine_last(String status) {
    return 'останній: $status';
  }

  @override
  String ng_bots_routine_next(String time) {
    return 'наступний: $time';
  }

  @override
  String ng_bots_routine_error(String error) {
    return 'помилка: $error';
  }

  @override
  String ng_bots_remove_routine_title(String routine) {
    return 'Видалити рутину $routine?';
  }

  @override
  String ng_bots_remove_routine_body(String bot) {
    return 'Рутину буде видалено з розкладу $bot. Цю дію не можна скасувати.';
  }

  @override
  String ng_bots_routine_action_failed(String action, String error) {
    return 'Не вдалося виконати «$action»: $error';
  }

  @override
  String get ng_bots_not_connected => 'Немає підключення.';

  @override
  String ng_bots_add_failed(String error) {
    return 'Не вдалося додати: $error';
  }

  @override
  String get ng_bots_routine_added => 'Рутину додано';

  @override
  String get ng_bots_routine_enabled => 'увімкнена';

  @override
  String get ng_bots_routine_paused => 'призупинена';

  @override
  String ng_bots_path(String path) {
    return 'Шлях: $path';
  }

  @override
  String get ng_bots_chat_present => 'Bot Chat наявний';

  @override
  String get ng_bots_chat_missing => 'Bot Chat відсутній';

  @override
  String ng_bots_last_session(String preview) {
    return 'Останній сеанс: $preview';
  }

  @override
  String get ng_bots_open_chat => 'Відкрити Bot Chat';

  @override
  String get ng_bots_desktop => 'Bot Desktop';

  @override
  String get ng_bots_room_name => 'Назва кімнати';

  @override
  String get ng_bots_select_member => 'Виберіть принаймні одного учасника.';

  @override
  String get ng_bots_sudo_title => 'Пароль адміністратора';

  @override
  String ng_bots_sudo_body(String bot) {
    return 'Для встановлення Bot Desktop для $bot потрібен sudo на хості шлюзу. Пароль надсилається лише на цей шлюз, лише для цього встановлення, і не зберігається.';
  }

  @override
  String get ng_bots_sudo_password => 'Пароль sudo';

  @override
  String get ng_bots_new_routine => 'Нова рутина';

  @override
  String get ng_bots_routine_title => 'Назва';

  @override
  String get ng_bots_routine_instruction => 'Інструкція';

  @override
  String get ng_bots_cron => 'Вираз cron';

  @override
  String get ng_bots_interval => 'Інтервал';

  @override
  String get ng_bots_cron_help => '0 9 * * * — запуск щодня о 09:00';

  @override
  String get ng_bots_every => 'Кожні';

  @override
  String get ng_bots_unit_minutes => 'хвилини';

  @override
  String get ng_bots_unit_hours => 'години';

  @override
  String get ng_bots_unit_days => 'дні';

  @override
  String get ng_bots_stop_after => 'Зупинити після (запусків)';

  @override
  String get ng_bots_stop_after_help =>
      'Залиште порожнім, щоб виконувати без обмежень';

  @override
  String get ng_bots_send_results => 'Надсилати результати до';

  @override
  String get ng_bots_run_history => 'Лише історія запусків';

  @override
  String get ng_bots_continuity => 'Продовжувати з попереднього запуску';

  @override
  String get ng_bots_account_changed_refresh =>
      'Обліковий запис змінився. Оновіть, перш ніж продовжити.';

  @override
  String ng_bots_room_load_failed(String error) {
    return 'Не вдалося завантажити кімнату: $error';
  }

  @override
  String ng_bots_send_failed(String error) {
    return 'Не вдалося надіслати: $error';
  }

  @override
  String ng_bots_stop_failed(String error) {
    return 'Не вдалося зупинити: $error';
  }

  @override
  String get ng_bots_stop_room => 'Зупинити кімнату';

  @override
  String get ng_bots_send_message => 'Надіслати повідомлення';

  @override
  String get ng_bots_room_hint =>
      'Повідомлення в кімнату (згадуйте учасників через @handle)';

  @override
  String get ng_bots_history => 'Історія';

  @override
  String ng_bots_revision(String revision) {
    return 'ревізія $revision';
  }

  @override
  String ng_bots_last_error(String error) {
    return 'остання помилка: $error';
  }

  @override
  String get ng_bots_members => 'Учасники';

  @override
  String get ng_bots_room_context => 'Контекст кімнати';

  @override
  String ng_bots_purpose(String purpose) {
    return 'Мета: $purpose';
  }

  @override
  String ng_bots_notes(String notes) {
    return 'Нотатки: $notes';
  }

  @override
  String ng_bots_routing(String routing) {
    return 'Маршрутизація: $routing';
  }

  @override
  String ng_bots_lead(String member) {
    return 'ведучий $member';
  }

  @override
  String get ng_bots_viewer_you_control =>
      'Ви керуєте цим екраном. Бот чекає, доки ви не повернете керування.';

  @override
  String get ng_bots_viewer_handed_back => 'Керування повернуто боту.';

  @override
  String get ng_bots_viewer_background =>
      'Керування повернуто боту, оскільки застосунок перейшов у фоновий режим.';

  @override
  String get ng_bots_viewer_taken => 'Хтось інший узяв керування цим екраном.';

  @override
  String get ng_bots_viewer_lost =>
      'Трансляцію екрана втрачено, тому керування повернуто боту.';

  @override
  String ng_bots_viewer_title(String bot) {
    return 'Bot Desktop · $bot';
  }

  @override
  String get ng_bots_viewer_type_hint => 'Введення на екрані бота';

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
      'Дошки, залежності завдань, призначення виконавців і журнали';

  @override
  String get ng_more_bots => 'Боти';

  @override
  String get ng_more_bots_subtitle => 'Склад, кімнати, рутини та Bot Desktop';

  @override
  String get ng_slash_kanban => 'Відкрити дошку Kanban';

  @override
  String get ng_slash_bots => 'Відкрити ваших ботів';

  @override
  String ng_board_card_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count картки',
      many: '$count карток',
      few: '$count картки',
      one: '$count картка',
    );
    return '$_temp0';
  }

  @override
  String ng_board_event_toast(String task, String event) {
    return 'Kanban $task: $event';
  }

  @override
  String get ng_board_task => 'завдання';

  @override
  String ng_board_refused_http(String status) {
    return 'Дію відхилено (HTTP $status).';
  }

  @override
  String get ng_board_err_unsupported =>
      'Плагін Kanban не ввімкнено на цьому шлюзі.';

  @override
  String get ng_board_err_denied => 'На цьому шлюзі потрібен вхід або дозвіл.';

  @override
  String get ng_board_err_stale =>
      'Власник шлюзу змінився. Оновіть, перш ніж продовжити.';

  @override
  String get ng_board_err_insecure =>
      'Для операцій із робочим простором Kanban потрібен HTTPS (або loopback).';

  @override
  String get ng_board_err_unreachable =>
      'Не вдалося зв’язатися зі службою Kanban на цьому шлюзі.';

  @override
  String get ng_board_err_failed =>
      'Операцію не виконано. Оновіть і спробуйте ще раз.';

  @override
  String ng_board_block_title(String task) {
    return 'Заблокувати $task';
  }

  @override
  String get ng_board_block_reason => 'Причина блокування';

  @override
  String get ng_board_block_hint => 'Що блокує цю картку?';

  @override
  String ng_board_review_title(String task) {
    return 'Запросити перевірку $task';
  }

  @override
  String get ng_board_review_summary => 'Підсумок для перевірки';

  @override
  String get ng_board_review_hint => 'Що було реалізовано й перевірено?';

  @override
  String ng_board_move_title(String cards, String column) {
    return 'Перемістити до $column: $cards?';
  }

  @override
  String ng_board_move_body(String board) {
    return 'Усі вибрані картки на дошці $board змінять колонку. Картки, що виконуються, буде зупинено.';
  }

  @override
  String get ng_board_move => 'Перемістити';

  @override
  String ng_board_moved(String column) {
    return 'Картки переміщено до $column';
  }

  @override
  String ng_board_unassign_title(String cards) {
    return 'Зняти виконавця: $cards?';
  }

  @override
  String ng_board_assign_title(String cards, String profile) {
    return 'Призначити @$profile виконавцем: $cards?';
  }

  @override
  String get ng_board_assign_body =>
      'Картки, що виконуються, спершу повертаються: їхні виконавці зупиняються.';

  @override
  String get ng_board_unassign => 'Зняти призначення';

  @override
  String get ng_board_assign => 'Призначити';

  @override
  String get ng_board_unassigned_done => 'З вибраних карток знято призначення';

  @override
  String ng_board_assigned_done(String profile) {
    return 'Призначено @$profile';
  }

  @override
  String ng_board_archive_title(String cards) {
    return 'Архівувати: $cards?';
  }

  @override
  String ng_board_archive_body(String board) {
    return 'Архівовані картки зникнуть із дошки $board. Увімкніть «Архівні», щоб знову їх побачити.';
  }

  @override
  String get ng_board_archived_done => 'Вибрані картки архівовано';

  @override
  String ng_board_delete_title(String cards) {
    return 'Видалити: $cards?';
  }

  @override
  String ng_board_delete_body(String board) {
    return 'Вибрані картки буде остаточно видалено з дошки $board.';
  }

  @override
  String ng_board_deleted(String cards) {
    return 'Видалено: $cards.';
  }

  @override
  String ng_board_partial_failure(String failed, String total, String reason) {
    return 'Не виконано $failed з $total: $reason';
  }

  @override
  String get ng_board_refused => 'відхилено';

  @override
  String ng_board_dispatched(
    String spawned,
    String promoted,
    String reclaimed,
  ) {
    return 'Диспетчеризація: запущено $spawned, просунуто $promoted, повернуто $reclaimed.';
  }

  @override
  String ng_board_board_archived(String board) {
    return 'Дошку $board архівовано';
  }

  @override
  String ng_board_board_archived_to(String path) {
    return 'Архівовано в $path';
  }

  @override
  String ng_board_exported(String board, String archive) {
    return 'Дошку $board експортовано в $archive';
  }

  @override
  String ng_board_imported(String board, String warnings) {
    return 'Дошку $board імпортовано$warnings';
  }

  @override
  String ng_board_created(String task) {
    return 'Створено завдання $task';
  }

  @override
  String get ng_board_orchestration_saved => 'Оркестрацію Kanban збережено';

  @override
  String get ng_board_auto_describe_unavailable => 'Автоопис недоступний';

  @override
  String ng_board_description_updated(String profile) {
    return 'Опис @$profile оновлено';
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
  String get ng_board_dispatch => 'Запустити готові завдання зараз';

  @override
  String get ng_board_orchestration => 'Оркестрація та виконавці';

  @override
  String get ng_board_new_task => 'Нове завдання';

  @override
  String get ng_board_enable_plugin =>
      'Увімкніть вбудований плагін «kanban» у розділі «Можливості → Плагіни» на цьому шлюзі, щоб активувати його маршрутизатор дошок.';

  @override
  String get ng_board_filter => 'Фільтр завдань…';

  @override
  String get ng_board_all_assignees => 'Усі виконавці';

  @override
  String get ng_board_unassigned => 'Без виконавця';

  @override
  String get ng_board_running_by_profile => 'Виконується за профілями';

  @override
  String get ng_board_select => 'Вибрати';

  @override
  String ng_board_selected_chip(String count) {
    return 'Вибрано ($count)';
  }

  @override
  String get ng_board_locked_column =>
      'Керована колонка — перетягування вимкнено';

  @override
  String ng_board_add_to(String column) {
    return 'Додати до $column';
  }

  @override
  String ng_board_collapse(String column) {
    return 'Згорнути $column';
  }

  @override
  String ng_board_column_empty(String column) {
    return 'Немає завдань у $column';
  }

  @override
  String get ng_board_drop_here => 'Перетягніть сюди або + завдання';

  @override
  String get ng_board_card_actions => 'Дії з карткою';

  @override
  String get ng_board_open_details => 'Відкрити подробиці';

  @override
  String get ng_board_select_card => 'Вибрати картку';

  @override
  String ng_board_move_to(String column) {
    return 'Перемістити до $column';
  }

  @override
  String get ng_board_parked => 'Відкладено';

  @override
  String ng_board_blocked_by(String count) {
    return 'Блокують: $count';
  }

  @override
  String get ng_board_goal_loop => 'Цільовий цикл';

  @override
  String ng_board_selected(String count) {
    return 'Вибрано: $count';
  }

  @override
  String get ng_board_move_menu => 'Перемістити…';

  @override
  String get ng_board_assign_menu => 'Призначити…';

  @override
  String get ng_board_new_board_title => 'Нова дошка Kanban';

  @override
  String get ng_board_slug => 'Slug (малі літери, наприклад release-v5)';

  @override
  String get ng_board_display_name => 'Відображувана назва';

  @override
  String get ng_board_linked_project => 'Пов’язаний проєкт (необов’язково)';

  @override
  String get ng_board_none => 'Немає';

  @override
  String get ng_board_default_workdir =>
      'Робочий каталог за замовчуванням на хості (необов’язково)';

  @override
  String get ng_board_import_title => 'Імпорт архіву дошки';

  @override
  String get ng_board_import_path => 'Шлях до архіву .tar.gz на хості';

  @override
  String get ng_board_import => 'Імпортувати';

  @override
  String ng_board_edit_board(String board) {
    return 'Редагувати $board';
  }

  @override
  String get ng_board_name => 'Назва';

  @override
  String get ng_board_description => 'Опис';

  @override
  String get ng_board_workdir_clear =>
      'Робочий каталог за замовчуванням (порожньо — очистити)';

  @override
  String get ng_board_boards => 'Дошки Kanban';

  @override
  String get ng_board_new_board => 'Нова дошка';

  @override
  String get ng_board_search_boards => 'Пошук дошок…';

  @override
  String get ng_board_unpin => 'Відкріпити вкладку';

  @override
  String get ng_board_pin => 'Закріпити вкладку';

  @override
  String ng_board_archive_board_title(String board) {
    return 'Архівувати дошку $board?';
  }

  @override
  String ng_board_archive_board_body(String cards) {
    return 'Дошка та її картки ($cards) зникнуть зі списку дошок. Шлюз збереже архів на своєму хості.';
  }

  @override
  String get ng_board_edit_metadata => 'Редагувати метадані';

  @override
  String get ng_board_export => 'Експорт .tar.gz на хості';

  @override
  String get ng_board_move_pin_left => 'Перемістити закріплену вкладку ліворуч';

  @override
  String get ng_board_archive_board => 'Архівувати дошку';

  @override
  String get ng_board_new_task_title => 'Нове завдання Kanban';

  @override
  String get ng_board_title_required => 'Назва *';

  @override
  String get ng_board_spec => 'Специфікація та критерії приймання';

  @override
  String get ng_board_estimate => 'Оцінити';

  @override
  String ng_board_estimate_draft(String complexity, String tokens) {
    return 'Складність $complexity (~$tokens ток. — лише оцінка токенів, а не вартості в доларах)';
  }

  @override
  String get ng_board_estimate_unavailable => 'Оцінка недоступна';

  @override
  String get ng_board_initial_column => 'Початкова колонка';

  @override
  String get ng_board_worker_assignee => 'Призначений виконавець';

  @override
  String get ng_board_parked_unassigned => 'Відкладено (без виконавця)';

  @override
  String get ng_board_priority => 'Пріоритет';

  @override
  String get ng_board_workspace => 'Робочий простір';

  @override
  String get ng_board_scratch => 'Тимчасовий';

  @override
  String get ng_board_worktree => 'Git worktree';

  @override
  String get ng_board_shared_dir => 'Спільний каталог';

  @override
  String get ng_board_workspace_path => 'Шлях до робочого простору на хості';

  @override
  String get ng_board_parent => 'Батьківська залежність (необов’язково)';

  @override
  String get ng_board_skills =>
      'Закріплені навички (через кому, необов’язково)';

  @override
  String get ng_board_provider_override => 'Перевизначення провайдера';

  @override
  String get ng_board_model_override => 'Перевизначення моделі';

  @override
  String get ng_board_reasoning => 'Глибина міркувань';

  @override
  String get ng_board_profile_default => 'За замовчуванням для профілю';

  @override
  String get ng_board_xhigh => 'Дуже висока';

  @override
  String get ng_board_goal_mode => 'Режим цільового циклу';

  @override
  String get ng_board_goal_turns =>
      'Макс. кількість ходів циклу (порожньо = за замовчуванням)';

  @override
  String get ng_board_create_task => 'Створити завдання';

  @override
  String get ng_board_orchestration_title =>
      'Оркестрація та профілі виконавців';

  @override
  String ng_board_orchestrator(String profile) {
    return 'Профіль оркестратора (фактично: $profile)';
  }

  @override
  String get ng_board_inherit_default =>
      'Успадкувати поточний профіль за замовчуванням';

  @override
  String ng_board_default_assignee(String profile) {
    return 'Виконавець за замовчуванням (фактично: $profile)';
  }

  @override
  String get ng_board_auto_decompose =>
      'Автоматично розбивати картки із сортування';

  @override
  String get ng_board_auto_decompose_help =>
      'Застосовує налаштовану модель kanban_decomposer до завдань із сортування';

  @override
  String get ng_board_save_orchestration => 'Зберегти оркестрацію';

  @override
  String get ng_board_worker_descriptions => 'Описи спеціалізацій виконавців';

  @override
  String ng_board_worker_label(String profile, String model, String skills) {
    return '@$profile ($model · $skills)';
  }

  @override
  String get ng_board_default_model => 'модель за замовчуванням';

  @override
  String get ng_board_save_description => 'Зберегти опис';

  @override
  String get ng_board_auto_describe => 'Автоопис за навичками та персоною';

  @override
  String get ng_board_manual_block => 'Ручне блокування оператором';

  @override
  String get ng_board_requested_review => 'Запитано перевірку';

  @override
  String ng_board_requeue_title(String task) {
    return 'Повернути $task у чергу?';
  }

  @override
  String get ng_board_requeue_body =>
      'Виконавця, що працює над цією карткою, буде зупинено, а картка повернеться в чергу.';

  @override
  String get ng_board_requeue => 'Повернути в чергу';

  @override
  String ng_board_reassign_title(String task, String profile) {
    return 'Перепризначити $task на @$profile?';
  }

  @override
  String get ng_board_reassign_body =>
      'Ця картка виконується: спершу буде зупинено її виконавця.';

  @override
  String get ng_board_reassign => 'Перепризначити';

  @override
  String ng_board_saved_task(String task) {
    return 'Завдання $task збережено';
  }

  @override
  String get ng_board_commented_requeued =>
      'Коментар опубліковано, завдання повернуто в чергу';

  @override
  String get ng_board_commented => 'Коментар опубліковано';

  @override
  String ng_board_requeued(String task) {
    return 'Завдання $task повернуто в чергу';
  }

  @override
  String get ng_board_decompose_failed => 'Не вдалося розбити завдання.';

  @override
  String ng_board_decompose_failed_reason(String reason) {
    return 'Не вдалося розбити завдання: $reason';
  }

  @override
  String ng_board_decomposed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Розбито на $count дочірнього завдання',
      many: 'Розбито на $count дочірніх завдань',
      few: 'Розбито на $count дочірні завдання',
      one: 'Розбито на $count дочірнє завдання',
    );
    return '$_temp0';
  }

  @override
  String get ng_board_no_children => 'Дочірні завдання не створено.';

  @override
  String ng_board_no_children_reason(String reason) {
    return 'Дочірні завдання не створено: $reason';
  }

  @override
  String ng_board_uploaded(String file) {
    return 'Файл $file завантажено';
  }

  @override
  String ng_board_linked_parent(String task) {
    return 'Батьківське завдання $task пов’язано';
  }

  @override
  String ng_board_unlinked_parent(String task) {
    return 'Зв’язок із батьківським завданням $task видалено';
  }

  @override
  String get ng_board_task_load_failed => 'Не вдалося завантажити завдання';

  @override
  String get ng_board_refresh_task => 'Оновити завдання';

  @override
  String get ng_board_tab_overview => 'Огляд';

  @override
  String get ng_board_tab_comments => 'Коментарі та посилання';

  @override
  String get ng_board_tab_runs => 'Запуски та журнал';

  @override
  String get ng_board_tab_events => 'Події';

  @override
  String get ng_board_decompose => 'Розбити';

  @override
  String get ng_board_attach => 'Прикріпити файл';

  @override
  String ng_board_estimate_task(
    String complexity,
    String tokens,
    String rationale,
  ) {
    return 'Оцінка: $complexity · ~$tokens токенів ($rationale) — це не оцінка вартості в доларах.';
  }

  @override
  String get ng_board_no_rationale => 'без обґрунтування';

  @override
  String get ng_board_status => 'Статус';

  @override
  String get ng_board_assignee => 'Виконавець';

  @override
  String get ng_board_title_label => 'Назва';

  @override
  String get ng_board_body => 'Текст / специфікація';

  @override
  String get ng_board_save_changes => 'Зберегти зміни';

  @override
  String get ng_board_clear_model => 'Скинути перевизначення моделі';

  @override
  String ng_board_blocked_reason(String reason) {
    return 'Причина блокування: $reason';
  }

  @override
  String ng_board_result(String result) {
    return 'Результат: $result';
  }

  @override
  String ng_board_parents(String count) {
    return 'Блокується (батьківські · $count)';
  }

  @override
  String get ng_board_add_parent => '+ Додати батьківське';

  @override
  String ng_board_children(String count) {
    return 'Блокує (дочірні · $count)';
  }

  @override
  String ng_board_attachments(String count) {
    return 'Вкладення ($count)';
  }

  @override
  String get ng_board_worker => 'виконавець';

  @override
  String ng_board_comments(String count) {
    return 'Коментарі ($count)';
  }

  @override
  String get ng_board_comment_hint => 'Додати коментар / вказівки виконавцю';

  @override
  String get ng_board_post_comment => 'Опублікувати коментар';

  @override
  String get ng_board_comment_requeue => 'Коментувати й повернути в чергу';

  @override
  String ng_board_runs(String count) {
    return 'Запуски ($count)';
  }

  @override
  String get ng_board_no_runs => 'Запусків виконавців поки немає.';

  @override
  String ng_board_run_error(String error) {
    return 'Помилка: $error';
  }

  @override
  String ng_board_log_tail_truncated(String bytes) {
    return 'Кінець журналу виконавця ($bytes Б, обрізано)';
  }

  @override
  String ng_board_log_tail(String bytes) {
    return 'Кінець журналу виконавця ($bytes Б)';
  }

  @override
  String get ng_board_refresh_log => 'Оновити журнал';

  @override
  String get ng_board_no_log => 'Журнал виконавця порожній.';

  @override
  String get ng_board_no_events => 'Подій не зареєстровано.';

  @override
  String get ng_bots_room_unknown => 'невідомо';

  @override
  String get ng_bots_room_blocked => 'заблоковано';

  @override
  String get ng_bots_room_working => 'працює';

  @override
  String get ng_bots_room_running => 'запущено';

  @override
  String get ng_bots_room_idle => 'простоює';

  @override
  String ng_board_run_title(String id, String profile, String outcome) {
    return 'Запуск №$id · @$profile · $outcome';
  }

  @override
  String get ng_bots_new_bot => 'Новий бот';

  @override
  String get ng_bots_new_bot_hint =>
      'Іменований напарник із власною пам’яттю, навичками й чатом. Може писати іншим вашим агентам.';

  @override
  String get ng_bots_field_name => 'Ім’я';

  @override
  String get ng_bots_field_title => 'Заголовок';

  @override
  String get ng_bots_field_description => 'Опис';

  @override
  String get ng_bots_description_hint => 'З чим має допомагати цей бот?';

  @override
  String get ng_bots_name_invalid =>
      'Використовуйте малі літери, цифри, дефіси або підкреслення; починайте з літери чи цифри (не більше 64 символів).';

  @override
  String ng_bots_name_taken(String name) {
    return 'Агент з іменем «$name» уже існує.';
  }

  @override
  String ng_bots_profile_id(String id) {
    return 'ID профілю: $id';
  }

  @override
  String get ng_bots_advanced =>
      'Додатково — модель, навички, набори інструментів, SOUL.md';

  @override
  String get ng_bots_clone_from => 'Клонувати профіль';

  @override
  String get ng_bots_clone_main => 'Основний профіль (default)';

  @override
  String get ng_bots_fresh_profile => 'Новий профіль (вбудовані навички)';

  @override
  String get ng_bots_create_empty =>
      'Створити порожнім (без вбудованих навичок)';

  @override
  String get ng_bots_share_keys =>
      'Спільні ключі й облікові записи з основним профілем';

  @override
  String get ng_bots_provider => 'Провайдер';

  @override
  String get ng_bots_model => 'Модель';

  @override
  String get ng_bots_model_pair => 'Укажіть і провайдера, і модель.';

  @override
  String get ng_bots_soul =>
      'SOUL.md (необов’язково — замінює створену персону)';

  @override
  String get ng_bots_soul_edit => 'SOUL.md';

  @override
  String get ng_bots_creating => 'Створення…';

  @override
  String get ng_bots_create_bot => 'Створити бота';

  @override
  String ng_bots_created(String name) {
    return 'Бота «$name» створено';
  }

  @override
  String get ng_bots_look_failed =>
      'Зовнішній вигляд не збережено на шлюзі; задайте його в «Редагувати профіль».';

  @override
  String ng_bots_request_failed(String reason) {
    return 'Шлюз не прийняв запит ($reason).';
  }

  @override
  String get ng_bots_avatar_shape => 'Форма';

  @override
  String ng_bots_avatar_shape_n(int n) {
    return 'Форма $n';
  }

  @override
  String get ng_bots_avatar_colour => 'Колір';

  @override
  String ng_bots_avatar_colour_n(int n) {
    return 'Колір $n';
  }

  @override
  String get ng_bots_avatar_match_name => 'За ім’ям';

  @override
  String get ng_bots_avatar_upload => 'Вибрати зображення…';

  @override
  String get ng_bots_avatar_remove => 'Прибрати зображення — використати форму';

  @override
  String get ng_bots_avatar_too_large => 'Зображення завелике (до 15 МБ).';

  @override
  String get ng_bots_avatar_unreadable => 'Не вдалося прочитати зображення.';

  @override
  String get ng_bots_edit_profile => 'Редагувати профіль';

  @override
  String ng_bots_edit_description(String name, String profile) {
    return 'Вигляд і роль $name ($profile).';
  }

  @override
  String ng_bots_advanced_failed(String reason) {
    return 'Не вдалося завантажити налаштування профілю ($reason).';
  }

  @override
  String get ng_bots_skills => 'Навички';

  @override
  String get ng_bots_toolsets => 'Набори інструментів';

  @override
  String get ng_bots_toolsets_hint =>
      'Якщо позначено всі (або жодного), діє типовий набір.';

  @override
  String get ng_bots_mcp_servers => 'MCP-сервери';

  @override
  String get ng_bots_saving => 'Збереження…';

  @override
  String get ng_bots_confirm_changes_title => 'Зберегти ці зміни?';

  @override
  String get ng_bots_change_remove_image => 'Видалити зображення бота';

  @override
  String get ng_bots_change_soul => 'Замінити його SOUL.md';

  @override
  String ng_bots_change_turn_off(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Вимкнути навички, набори чи MCP-сервери: $count',
    );
    return '$_temp0';
  }

  @override
  String ng_bots_updated(String name) {
    return '$name: оновлено';
  }

  @override
  String ng_bots_sections_failed(String sections) {
    return 'Не вдалося зберегти: $sections';
  }

  @override
  String get ng_bots_model_confirm_title => 'Змінити модель?';

  @override
  String get ng_bots_model_confirm_ok => 'Змінити';

  @override
  String get ng_bots_model_not_switched => 'Модель не змінено.';

  @override
  String get ng_bots_section_new => 'Новий розділ';

  @override
  String get ng_bots_section_new_ellipsis => 'Новий розділ…';

  @override
  String get ng_bots_section_name => 'Назва розділу';

  @override
  String get ng_bots_section_name_hint => 'наприклад, Клієнти';

  @override
  String get ng_bots_section_create => 'Створити';

  @override
  String get ng_bots_section_rename => 'Перейменувати розділ';

  @override
  String get ng_bots_section_delete => 'Видалити розділ';

  @override
  String get ng_bots_section_move_up => 'Вище';

  @override
  String get ng_bots_section_move_down => 'Нижче';

  @override
  String get ng_bots_section_unassigned => 'Без розділу';

  @override
  String ng_bots_section_options(String name) {
    return 'Параметри розділу «$name»';
  }

  @override
  String get ng_bots_section_empty =>
      'Тут поки немає ботів. Скористайтеся «Перемістити в розділ» у бота.';

  @override
  String get ng_bots_section_move_to => 'Перемістити в розділ';

  @override
  String get ng_bots_section_remove => 'Прибрати з розділу';

  @override
  String ng_bots_section_deleted(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Розділ «$name» видалено — ботів переміщено в «Без розділу»: $count',
      zero: 'Розділ «$name» видалено',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_undo => 'Скасувати';

  @override
  String ng_bots_section_move_failed(String reason) {
    return 'Не вдалося перемістити бота ($reason).';
  }

  @override
  String ng_bots_bot_actions(String name) {
    return 'Дії: $name';
  }

  @override
  String ng_bots_section_toggle(String name) {
    return 'Показати або сховати «$name»';
  }

  @override
  String
  get release_core_transcript_reader_this_passage_is_no_longer_in_the_loaded =>
      'Цього уривка більше немає в завантаженому фрагменті.';

  @override
  String get release_core_transcript_reader_loaded_prompts =>
      'Завантажені запити';

  @override
  String get release_core_transcript_reader_jump_to_latest =>
      'Перейти до найновішого';

  @override
  String get release_core_transcript_reader_no_prompts_loaded =>
      'Немає завантажених запитів';

  @override
  String get release_core_transcript_reader_find_in_loaded_messages =>
      'Знайти в завантажених повідомленнях';

  @override
  String get release_core_transcript_reader_previous_match => 'Попередній збіг';

  @override
  String get release_core_transcript_reader_next_match => 'Наступний збіг';

  @override
  String get release_core_transcript_reader_prompt_timeline =>
      'Хронологія запитів';

  @override
  String get release_core_transcript_reader_close_find => 'Закрити пошук';

  @override
  String get release_core_session_organisation_organise_chats =>
      'Упорядкувати чати';

  @override
  String get release_core_session_organisation_show_model_and_usage =>
      'Показувати модель і використання';

  @override
  String
  get release_core_session_files_view_connection_changed_reopen_files_on_the_new_connection =>
      'Підключення змінено. Відкрийте файли знову через нове підключення.';

  @override
  String
  get release_core_session_files_view_the_connection_or_session_changed_reopen_this_pane =>
      'Підключення або сесію змінено. Відкрийте цю панель знову.';

  @override
  String
  get release_core_session_files_view_no_verified_host_working_directory_for_this_session =>
      'Для цієї сесії немає перевіреного робочого каталогу на хості.';

  @override
  String
  get release_core_session_files_view_the_gateway_denied_this_operation =>
      'Шлюз відхилив цю операцію.';

  @override
  String
  get release_core_session_files_view_this_gateway_does_not_support_this_operation =>
      'Цей шлюз не підтримує цю операцію.';

  @override
  String
  get release_core_session_files_view_the_file_owner_or_working_directory_changed_reload =>
      'Файл, власника або робочий каталог змінено. Перезавантажте й перевірте.';

  @override
  String
  get release_core_session_files_view_the_gateway_returned_an_unsafe_path_or_invalid =>
      'Шлюз повернув небезпечний шлях або некоректну відповідь щодо файлу.';

  @override
  String
  get release_core_session_files_view_workspace_access_requires_a_secure_gateway_connection =>
      'Для доступу до робочого простору потрібне захищене підключення до шлюзу.';

  @override
  String
  get release_core_session_files_view_gateway_unavailable_refresh_to_check_the_current_state =>
      'Шлюз недоступний. Оновіть, щоб перевірити поточний стан.';

  @override
  String
  get release_core_session_files_view_gateway_operation_could_not_be_confirmed =>
      'Не вдалося підтвердити операцію шлюзу.';

  @override
  String get release_core_session_files_view_git_status_unavailable =>
      'Стан Git недоступний.';

  @override
  String
  get release_core_session_files_view_change_this_chat_s_working_directory =>
      'Змінити робочий каталог цього чату?';

  @override
  String get release_core_session_files_view_absolute_gateway_directory =>
      'Абсолютний шлях до каталогу на шлюзі';

  @override
  String get release_core_session_files_view_change_directory =>
      'Змінити каталог';

  @override
  String get release_core_session_files_view_replace_gateway_file =>
      'Замінити файл на шлюзі?';

  @override
  String
  release_core_session_files_view_only_if_the_file_still_matches_the_version(
    String path,
  ) {
    return '$path\n\nЛише якщо файл досі відповідає перевіреній вами версії. Сумісний хост зберігає замінений файл для відновлення.';
  }

  @override
  String get release_core_session_files_view_save_changes => 'Зберегти зміни';

  @override
  String
  get release_core_session_files_view_saved_and_verified_on_the_gateway =>
      'Збережено й перевірено на шлюзі.';

  @override
  String
  get release_core_session_files_view_guarded_saving_is_unavailable_on_this_gateway_your =>
      'Захищене збереження недоступне на цьому шлюзі. Ваша чернетка залишається тут.';

  @override
  String
  release_core_session_files_view_save_was_not_confirmed_your_draft_is_still(
    String reason,
  ) {
    return '$reason Збереження не підтверджено. Ваша чернетка залишається тут.';
  }

  @override
  String get release_core_session_files_view_review_current_gateway_version =>
      'Перевірити поточну версію на шлюзі';

  @override
  String get release_core_session_files_view_discard_draft_and_reload =>
      'Відкинути чернетку й перезавантажити';

  @override
  String get release_core_session_files_view_keep_draft_against_this_version =>
      'Залишити чернетку на основі цієї версії';

  @override
  String get release_core_session_files_view_discard_unsaved_edits =>
      'Відкинути незбережені зміни?';

  @override
  String get release_core_session_files_view_keep_editing =>
      'Продовжити редагування';

  @override
  String get release_core_session_files_view_discard_edits => 'Відкинути зміни';

  @override
  String get release_core_session_files_view_remote_working_directory =>
      'Віддалений робочий каталог';

  @override
  String get release_core_session_files_view_change_working_directory =>
      'Змінити робочий каталог';

  @override
  String get release_core_session_files_view_show_ignored_files =>
      'Показувати ігноровані файли';

  @override
  String
  get release_core_session_files_view_gateway_does_not_report_ignored_status =>
      'Шлюз не повідомляє, які файли ігноруються.';

  @override
  String get release_core_session_files_view_no_visible_entries =>
      'Немає видимих елементів';

  @override
  String get release_core_session_files_view_changed => 'Змінено';

  @override
  String get release_core_session_files_view_ignored => 'Ігнорується';

  @override
  String release_core_session_files_view_actions_for(String name) {
    return 'Дії для $name';
  }

  @override
  String get release_core_session_files_view_copy_relative_path =>
      'Копіювати відносний шлях';

  @override
  String get release_core_session_files_view_copy_gateway_path =>
      'Копіювати шлях на шлюзі';

  @override
  String get release_core_session_files_view_attach_folder_reference =>
      'Додати посилання на папку';

  @override
  String get release_core_session_files_view_attach_file_reference =>
      'Додати посилання на файл';

  @override
  String
  get release_core_session_files_view_preview_truncated_editing_disabled =>
      'Попередній перегляд обрізано — редагування вимкнено.';

  @override
  String get release_core_session_files_view_select_lines => 'Вибрати рядки';

  @override
  String get release_core_session_files_view_review_gateway_version =>
      'Перевірити версію на шлюзі';

  @override
  String get release_core_session_files_view_attach_selected_lines =>
      'Додати вибрані рядки';

  @override
  String get release_core_session_files_view_binary_file_no_text_preview =>
      'Двійковий файл — попередній перегляд тексту недоступний.';

  @override
  String get release_core_session_files_view_file_source => 'Джерело файлу';

  @override
  String get release_core_session_files_view_close_session_files =>
      'Закрити файли сесії';

  @override
  String get release_core_session_files_view_back_to_tree =>
      'Повернутися до дерева';

  @override
  String get release_core_session_files_view_session_files => 'Файли сесії';

  @override
  String get release_core_session_files_view_git_review => 'Перегляд Git';

  @override
  String get release_core_session_files_view_refresh_tree => 'Оновити дерево';

  @override
  String
  get release_core_gateway_queue_screen_this_connection_changed_reopen_its_chat =>
      'Це підключення змінено. Відкрийте його чат знову.';

  @override
  String
  get release_core_gateway_queue_screen_disconnected_reconnect_the_chat_then_refresh =>
      'Підключення втрачено. Підключіть чат знову й оновіть.';

  @override
  String release_core_gateway_queue_screen_gateway_queue_unavailable(
    String reason,
  ) {
    return 'Черга шлюзу недоступна: $reason.';
  }

  @override
  String release_core_gateway_queue_screen_not_confirmed_nothing_was_resent(
    String reason,
  ) {
    return 'Не підтверджено ($reason). Нічого не надіслано повторно.';
  }

  @override
  String get release_core_gateway_queue_screen_gateway_confirmed_admission =>
      'Шлюз підтвердив додавання до черги.';

  @override
  String
  get release_core_gateway_queue_screen_edited_entry_admitted_at_the_end_of_the =>
      'Відредагований елемент додано в кінець черги.';

  @override
  String get release_core_gateway_queue_screen_discard_unknown_outcome =>
      'Відкинути елемент із невідомим результатом?';

  @override
  String get release_core_gateway_queue_screen_remove_this_entry =>
      'Вилучити цей елемент?';

  @override
  String
  get release_core_gateway_queue_screen_the_lost_turn_will_not_be_retried_waiting =>
      'Втрачений хід не буде повторено. Ходи в черзі тепер можуть виконуватися.';

  @override
  String
  get release_core_gateway_queue_screen_if_the_gateway_has_just_started_this_entry =>
      'Якщо шлюз щойно почав виконувати цей елемент, його вилучення може зупинити цей хід.';

  @override
  String get release_core_gateway_queue_screen_keep => 'Залишити';

  @override
  String get release_core_gateway_queue_screen_discard_and_resume =>
      'Відкинути й відновити';

  @override
  String get release_core_gateway_queue_screen_remove_entry =>
      'Вилучити елемент';

  @override
  String
  get release_core_gateway_queue_screen_lost_admission_resolved_it_was_not_resent =>
      'Проблему з втраченим додаванням до черги вирішено; повторного надсилання не було.';

  @override
  String get release_core_gateway_queue_screen_gateway_acknowledged_removal =>
      'Шлюз підтвердив вилучення.';

  @override
  String get release_core_gateway_queue_screen_gateway_queue => 'Черга шлюзу';

  @override
  String get release_core_gateway_queue_screen_refresh_queue => 'Оновити чергу';

  @override
  String get release_core_gateway_queue_screen_queue_paused_unknown_outcome =>
      'Чергу призупинено: невідомий результат';

  @override
  String
  get release_core_gateway_queue_screen_review_the_lost_admission_before_resuming_nothing_is =>
      'Перевірте втрачене додавання до черги перед відновленням. Нічого не надсилається повторно.';

  @override
  String get release_core_gateway_queue_screen_no_pending_admissions =>
      'Немає елементів, що очікують прийняття';

  @override
  String get release_core_gateway_queue_screen_discard => 'Відкинути…';

  @override
  String
  get release_core_gateway_queue_screen_gateway_acknowledged_the_steering_request =>
      'Шлюз підтвердив запит на коригування ходу.';

  @override
  String get release_core_gateway_queue_screen_steer_running_turn =>
      'Скоригувати поточний хід';

  @override
  String get release_core_gateway_queue_screen_remove => 'Вилучити…';

  @override
  String get release_core_gateway_queue_screen_next_prompt => 'Наступний запит';

  @override
  String get release_core_gateway_queue_screen_edit_queued_prompt =>
      'Редагувати запит у черзі';

  @override
  String get release_core_gateway_queue_screen_submit_to_gateway_queue =>
      'Надіслати до черги шлюзу';

  @override
  String get release_core_gateway_queue_screen_save_at_queue_end =>
      'Зберегти в кінці черги';

  @override
  String get release_core_gateway_queue_screen_cancel_edit =>
      'Скасувати редагування';

  @override
  String get release_core_git_review_pane_the_git_operation_did_not_complete =>
      'Операцію Git не завершено.';

  @override
  String get release_core_git_review_pane_close_git_review =>
      'Закрити перегляд Git';

  @override
  String get release_core_git_review_pane_pin_lane => 'Закріпити робочу смугу';

  @override
  String get release_core_git_review_pane_refresh_git_review =>
      'Оновити перегляд Git';

  @override
  String get release_core_git_review_pane_uncommitted => 'Без коміту';

  @override
  String get release_core_git_review_pane_last_turn => 'Останній хід';

  @override
  String
  get release_core_git_review_pane_branch_and_last_turn_views_are_read_only =>
      'Перегляди гілки й останнього ходу доступні лише для читання.';

  @override
  String get release_core_git_review_pane_mark_head_as_the_turn_baseline =>
      'Позначити HEAD як початкову точку ходу';

  @override
  String get release_core_git_review_pane_stage_all => 'Додати все до індексу';

  @override
  String get release_core_git_review_pane_discard_every_uncommitted_change =>
      'Відкинути всі зміни без коміту?';

  @override
  String
  get release_core_git_review_pane_tracked_files_return_to_head_and_untracked_files =>
      'Відстежувані файли буде повернуто до стану HEAD, а невідстежувані файли в каталозі цієї сесії — видалено.';

  @override
  String get release_core_git_review_pane_discard => 'Відкинути';

  @override
  String get release_core_git_review_pane_discard_all => 'Відкинути все';

  @override
  String get release_core_git_review_pane_unstage => 'Вилучити з індексу';

  @override
  String get release_core_git_review_pane_stage => 'Додати до індексу';

  @override
  String get release_core_git_review_pane_discard_file => 'Відкинути файл';

  @override
  String release_core_git_review_pane_discard_2(String path) {
    return 'Відкинути $path?';
  }

  @override
  String
  get release_core_git_review_pane_this_restores_the_committed_copy_or_removes_the =>
      'Це відновить копію з коміту або видалить невідстежуваний файл.';

  @override
  String get release_core_git_review_pane_commit_message =>
      'Повідомлення коміту';

  @override
  String get release_core_git_review_pane_nothing_in_the_diff_to_summarise =>
      'У різниці немає нічого для підсумку.';

  @override
  String get release_core_git_review_pane_generate_message =>
      'Згенерувати повідомлення';

  @override
  String get release_core_git_review_pane_commit => 'Створити коміт';

  @override
  String get release_core_git_review_pane_commit_and_push =>
      'Створити коміт і надіслати';

  @override
  String get release_core_git_review_pane_push => 'Надіслати';

  @override
  String get release_core_git_review_pane_create_pull_request =>
      'Створити запит на злиття';

  @override
  String get release_core_git_review_pane_pull_request_ready =>
      'Запит на злиття готовий';

  @override
  String get release_core_git_review_pane_ask_hermes_to_ship =>
      'Попросити Hermes опублікувати';

  @override
  String get release_core_git_review_pane_gh_is_authenticated_on_this_gateway =>
      'gh автентифіковано на цьому шлюзі.';

  @override
  String
  get release_core_git_review_pane_install_the_github_cli_gh_and_sign_in =>
      'Установіть GitHub CLI (gh) і ввійдіть, щоб відкривати PR';

  @override
  String get release_core_git_review_pane_worktrees => 'Робочі дерева';

  @override
  String get release_core_git_review_pane_main => 'Основне';

  @override
  String release_core_git_review_pane_follow(String branch) {
    return 'Перейти до $branch?';
  }

  @override
  String
  get release_core_git_review_pane_the_session_working_directory_becomes_this_worktree_unless =>
      'Це робоче дерево стане робочим каталогом сесії, якщо робочу смугу не закріплено.';

  @override
  String get release_core_git_review_pane_follow_2 => 'Перейти';

  @override
  String release_core_git_review_pane_remove(String branch) {
    return 'Видалити $branch?';
  }

  @override
  String get release_core_git_review_pane_the_worktree_directory_is_removed =>
      'Каталог робочого дерева буде видалено.';

  @override
  String get release_core_git_review_pane_remove_2 => 'Видалити';

  @override
  String get release_core_git_review_pane_new_worktree_name =>
      'Назва нового робочого дерева';

  @override
  String get release_core_git_review_pane_new_branch => 'Нова гілка';

  @override
  String get release_core_git_review_pane_base_branch => 'Базова гілка';

  @override
  String get release_core_git_review_pane_create_worktree =>
      'Створити робоче дерево';

  @override
  String get release_core_git_review_pane_existing_branch => 'Наявна гілка';

  @override
  String get release_core_git_review_pane_convert_branch_to_worktree =>
      'Перетворити гілку на робоче дерево';

  @override
  String get release_core_git_review_pane_switch_branch => 'Перемкнути гілку';

  @override
  String
  get release_core_git_review_pane_this_gateway_does_not_support_that_git_operation =>
      'Цей шлюз не підтримує цю операцію Git.';

  @override
  String
  get release_core_git_review_pane_git_needs_the_session_directory_on_the_local =>
      'Git потребує каталогу сесії на локальному сервері термінала.';

  @override
  String
  get release_core_git_review_pane_the_gateway_refused_the_git_operation =>
      'Шлюз відхилив операцію Git.';

  @override
  String
  get release_core_git_review_pane_the_session_changed_refresh_and_try_again =>
      'Сесію змінено. Оновіть і повторіть спробу.';

  @override
  String
  get release_core_git_review_pane_this_review_is_no_longer_the_selected_session =>
      'Цей перегляд більше не відповідає вибраній сесії.';

  @override
  String
  get release_core_git_review_pane_the_gateway_returned_an_unexpected_git_result =>
      'Шлюз повернув неочікуваний результат Git.';

  @override
  String
  get release_core_git_review_pane_git_review_requires_the_gateway_transport =>
      'Для перегляду Git потрібен транспорт шлюзу.';

  @override
  String get release_core_client_held_queue_bar_resume => 'Відновити';

  @override
  String get release_core_client_held_queue_bar_send_queued_prompt =>
      'Надіслати запит із черги';

  @override
  String get release_core_client_held_queue_bar_edit_unsent_prompt =>
      'Редагувати ненадісланий запит';

  @override
  String get release_core_client_held_queue_bar_remove_unsent_prompt =>
      'Вилучити ненадісланий запит';

  @override
  String get release_core_workspace_discovery_view_repository_discovery =>
      'Виявлення репозиторіїв';

  @override
  String get release_core_workspace_discovery_view_refresh_results =>
      'Оновити результати';

  @override
  String release_core_workspace_discovery_view_hide(String path) {
    return 'Приховати $path';
  }

  @override
  String
  get release_core_workspace_discovery_view_invalid_path_or_discovery_data_use_absolute_server =>
      'Некоректний шлях або дані виявлення. Використовуйте абсолютні шляхи сервера без компонентів «.» або «..».';

  @override
  String
  get release_core_workspace_discovery_view_this_gateway_does_not_support_repository_discovery =>
      'Цей шлюз не підтримує виявлення репозиторіїв.';

  @override
  String
  get release_core_workspace_discovery_view_the_gateway_denied_access_to_repository_discovery =>
      'Шлюз заборонив доступ до виявлення репозиторіїв.';

  @override
  String
  get release_core_workspace_discovery_view_the_connection_changed_reopen_discovery_on_the_current =>
      'Підключення змінено. Відкрийте виявлення знову на поточному шлюзі.';

  @override
  String
  get release_core_workspace_discovery_view_the_displayed_settings_have_changed_refresh_before_trying =>
      'Відображені налаштування змінено. Оновіть перед повторною спробою.';

  @override
  String
  get release_core_workspace_discovery_view_could_not_load_or_verify_discovery_settings_refresh =>
      'Не вдалося завантажити або перевірити налаштування виявлення. Оновіть, щоб повторити спробу.';

  @override
  String release_core_workspace_discovery_view_repositories_shown_of(
    int visible,
    int total,
  ) {
    return 'Показано репозиторіїв: $visible із $total';
  }

  @override
  String
  get release_core_workspace_discovery_view_the_gateway_returned_no_repositories =>
      'Шлюз не повернув жодного репозиторію.';

  @override
  String
  get release_core_workspace_discovery_view_no_repositories_match_your_device_filters =>
      'Жоден репозиторій не відповідає фільтрам на вашому пристрої.';

  @override
  String get release_core_workspace_discovery_view_gateway_scan_policy =>
      'Політика сканування шлюзу';

  @override
  String
  get release_core_workspace_discovery_view_this_gateway_did_not_report_a_scan_policy =>
      'Цей шлюз не повідомив політику сканування.';

  @override
  String
  get release_core_workspace_discovery_view_to_scan_folders_configure_repository_scanning_in_the =>
      'Щоб сканувати папки, налаштуйте сканування репозиторіїв у налаштуваннях Desktop профілю шлюзу.';

  @override
  String
  get release_core_workspace_discovery_view_results_can_include_cached_repositories_and_repositories_with =>
      'Результати можуть містити кешовані репозиторії та репозиторії із сесіями. Сканування не гарантує, що кожну папку вдалося перевірити.';

  @override
  String get release_core_workspace_discovery_view_scan_gateway_roots =>
      'Сканувати кореневі каталоги шлюзу';

  @override
  String
  get release_core_workspace_discovery_view_filter_results_on_this_device =>
      'Фільтрувати результати на цьому пристрої';

  @override
  String
  get release_core_workspace_discovery_view_only_this_discovery_list_changes_not_the_gateway =>
      'Змінюється лише цей список виявлення, а не сканування шлюзу.';

  @override
  String get release_core_workspace_discovery_view_include_subtrees_empty_all =>
      'Включити піддерева (порожньо = усі)';

  @override
  String get release_core_workspace_discovery_view_exclude_subtrees =>
      'Виключити піддерева';

  @override
  String get release_core_workspace_discovery_view_apply_filters =>
      'Застосувати фільтри';

  @override
  String release_core_workspace_discovery_view_hidden_repositories(int count) {
    return 'Приховані репозиторії ($count)';
  }

  @override
  String get release_core_workspace_discovery_view_undo_hide =>
      'Скасувати приховування';

  @override
  String
  get release_core_workspace_discovery_view_one_absolute_server_path_per_line =>
      'Один абсолютний шлях сервера на рядок';

  @override
  String get release_core_project_settings_view_project_settings =>
      'Налаштування проєкту';

  @override
  String
  get release_core_project_settings_view_the_gateway_did_not_confirm_the_selected_project =>
      'Шлюз не підтвердив вибраний проєкт або зміну. Перевірте налаштування перед повторною спробою.';

  @override
  String
  get release_core_project_settings_view_could_not_verify_these_settings_use_one_absolute =>
      'Не вдалося перевірити ці налаштування. Укажіть один абсолютний шлях до папки сервера на рядок, без компонентів «.» або «..».';

  @override
  String get release_core_project_settings_view_set_active =>
      'Зробити активним';

  @override
  String get release_core_project_settings_view_icon => 'Піктограма';

  @override
  String get release_core_project_settings_view_folder => 'Папка';

  @override
  String get release_core_project_settings_view_repository => 'Репозиторій';

  @override
  String get release_core_project_settings_view_rocket => 'Ракета';

  @override
  String get release_core_project_settings_view_star => 'Зірка';

  @override
  String get release_core_project_settings_view_book => 'Книга';

  @override
  String get release_core_project_settings_view_terminal => 'Термінал';

  @override
  String get release_core_project_settings_view_colour => 'Колір';

  @override
  String get release_core_project_settings_view_primary_folder =>
      'Основна папка';

  @override
  String get release_core_project_settings_view_server_folder_paths =>
      'Шляхи до папок сервера';

  @override
  String
  get release_core_project_settings_view_one_absolute_path_per_line_existing_folders_are =>
      'Один абсолютний шлях на рядок. Наявні папки зберігаються.';

  @override
  String get release_core_project_settings_view_add_folders => 'Додати папки';

  @override
  String release_core_project_settings_view_choose(String label) {
    return 'Вибрати $label';
  }

  @override
  String
  get release_core_prepared_image_recovery_wait_for_an_empty_draft_before_restoring =>
      'Перед відновленням дочекайтеся, поки чернетка буде порожньою.';

  @override
  String
  get release_core_prepared_image_recovery_no_unacknowledged_image_drafts_in_this_chat =>
      'У цьому чаті немає непідтверджених чернеток із зображеннями.';

  @override
  String get release_core_prepared_image_recovery_unacknowledged_image_drafts =>
      'Непідтверджені чернетки із зображеннями';

  @override
  String
  get release_core_prepared_image_recovery_the_gateway_may_already_have_received_these_restore =>
      'Можливо, шлюз уже отримав їх. Відновіть для перевірки; нічого не надсилається.';

  @override
  String get release_core_prepared_image_recovery_image_draft =>
      'Чернетка із зображенням';

  @override
  String get release_core_prepared_image_recovery_discard_local_copy =>
      'Відкинути локальну копію';

  @override
  String
  get release_core_prepared_image_recovery_discard_this_local_image_draft =>
      'Відкинути цю локальну чернетку із зображенням?';

  @override
  String
  get release_core_prepared_image_recovery_image_draft_recovery_is_unavailable =>
      'Відновлення чернеток із зображеннями недоступне.';

  @override
  String get release_core_prepared_image_recovery_recover_image_draft =>
      'Відновити чернетку із зображенням…';

  @override
  String get release_core_session_search_mode_menu_could_not_save_search_mode =>
      'Не вдалося зберегти режим пошуку.';

  @override
  String get release_core_projects_pane_discover_repositories =>
      'Виявити репозиторії';

  @override
  String
  get release_core_projects_pane_project_created_but_the_gateway_did_not_confirm =>
      'Проєкт створено, але шлюз не підтвердив його ідею.';

  @override
  String get release_core_projects_pane_project_idea_optional =>
      'Ідея проєкту (необов’язково)';

  @override
  String
  get release_core_projects_pane_saved_in_the_project_description_not_a_file =>
      'Збережено в описі проєкту, а не у файлі.';

  @override
  String get release_core_project_detail_screen_new_chat_in_this_lane =>
      'Новий чат у цій робочій смузі';

  @override
  String get release_core_project_detail_screen_review_git => 'Переглянути Git';

  @override
  String get release_core_more_pane_gateway_fleet => 'Парк шлюзів';

  @override
  String
  get release_core_more_pane_connected_sessions_hermes_cloud_and_desktop_webapp =>
      'Підключені сесії, Hermes Cloud і вебзастосунок Desktop';

  @override
  String get release_core_more_pane_use_dashboard_sign_in_for_a_named_profile =>
      'Для іменованого профілю ввійдіть через вебпанель. Цей застарілий API не може підтвердити, якому профілю належить історія чатів.';

  @override
  String get release_core_more_pane_capabilities => 'Можливості';

  @override
  String
  get release_core_more_pane_install_and_govern_skills_plugins_connectors_and_tool =>
      'Установлюйте й керуйте навичками, плагінами, конекторами та серверними компонентами інструментів';

  @override
  String get release_core_more_pane_browser_vault => 'Сховище браузера';

  @override
  String
  get release_core_more_pane_site_logins_addresses_cards_and_credential_sources =>
      'Облікові дані сайтів, адреси, картки й джерела облікових даних';

  @override
  String get release_core_more_pane_agent_policy => 'Політика агента';

  @override
  String
  get release_core_more_pane_approvals_checkpoints_browser_access_and_shared_metrics =>
      'Схвалення, контрольні точки, доступ до браузера й спільні метрики';

  @override
  String get release_core_more_pane_remote_logs_health_maintenance_and_update =>
      'Віддалені журнали, стан, обслуговування й оновлення';

  @override
  String get release_core_more_pane_schedules => 'Розклади';

  @override
  String get release_core_more_pane_all_profiles_blueprints_catch_up_and_stop =>
      'Усі профілі, шаблони, надолуження пропущених запусків і зупинка';

  @override
  String get release_core_more_pane_memory_graph => 'Граф пам’яті';

  @override
  String get release_core_more_pane_timeline_edits_and_memory_providers =>
      'Хронологія, зміни й провайдери пам’яті';

  @override
  String get release_core_more_pane_providers_and_routes =>
      'Провайдери й маршрути';

  @override
  String get release_core_more_pane_keys_endpoints_delegation_and_mixtures =>
      'Ключі, кінцеві точки, делегування й суміші';

  @override
  String get release_core_more_pane_credits_and_plans =>
      'Кредити й тарифні плани';

  @override
  String
  get release_core_more_pane_consented_nous_billing_when_the_account_allows_it =>
      'Оплата Nous за вашою згодою, якщо це дозволяє обліковий запис';

  @override
  String
  get release_core_fleet_screen_this_gateway_does_not_offer_this_service =>
      'Цей шлюз не надає цієї послуги.';

  @override
  String
  get release_core_fleet_screen_sign_in_or_permission_required_on_this_gateway =>
      'На цьому шлюзі потрібен вхід або дозвіл.';

  @override
  String get release_core_fleet_screen_a_secure_gateway_address_is_required =>
      'Потрібна захищена адреса шлюзу.';

  @override
  String
  get release_core_fleet_screen_the_owner_changed_refresh_before_continuing =>
      'Власника змінено. Оновіть перед продовженням.';

  @override
  String
  get release_core_fleet_screen_could_not_verify_the_operation_check_the_gateway =>
      'Не вдалося перевірити операцію. Перевірте шлюз і оновіть.';

  @override
  String get release_core_fleet_screen_verified_ssh => 'Перевірений SSH';

  @override
  String
  get release_core_fleet_screen_confirm_a_host_key_inspect_a_remote_service =>
      'Підтвердьте ключ хоста, перевірте віддалену службу або відкрийте її оболонку';

  @override
  String get release_core_fleet_screen_cloud_and_desktop_webapp =>
      'Cloud і вебзастосунок Desktop';

  @override
  String get release_core_fleet_screen_register_an_existing_gateway_or_webapp =>
      'Зареєструвати наявний шлюз або вебзастосунок';

  @override
  String
  get release_core_fleet_screen_sign_in_to_its_address_nothing_is_hosted =>
      'Увійдіть за його адресою. На цьому пристрої нічого не розміщується.';

  @override
  String get release_core_fleet_screen_fleet_updates => 'Оновлення парку';

  @override
  String get release_core_fleet_screen_refresh_roster => 'Оновити список';

  @override
  String release_core_fleet_screen_disconnect(String gateway) {
    return 'Відключити $gateway';
  }

  @override
  String get release_core_fleet_screen_open_this_gateway_on_launch =>
      'Відкривати цей шлюз під час запуску';

  @override
  String
  get release_core_fleet_screen_primary_for_ares_does_not_change_the_last =>
      'Основний для Ares; не змінює останній використаний шлюз.';

  @override
  String get release_core_fleet_screen_reconnect_in_fleet_on_launch =>
      'Повторно підключати в парку під час запуску';

  @override
  String get release_core_fleet_screen_no_sessions_for_this_profile =>
      'Для цього профілю немає сесій.';

  @override
  String get release_core_fleet_screen_more_sessions => 'Більше сесій';

  @override
  String get release_core_fleet_screen_this_gateway_was_disconnected =>
      'Цей шлюз відключено.';

  @override
  String
  get release_core_fleet_screen_some_conversation_data_could_not_be_loaded =>
      'Не вдалося завантажити частину даних розмови.';

  @override
  String get release_core_fleet_screen_message_this_session =>
      'Написати в цю сесію';

  @override
  String get release_core_fleet_screen_send_to_this_session =>
      'Надіслати в цю сесію';

  @override
  String get release_core_fleet_updates_screen_update_these_remote_gateways =>
      'Оновити ці віддалені шлюзи?';

  @override
  String
  release_core_fleet_updates_screen_this_can_restart_the_backend_and_interrupt_other(
    String gateways,
  ) {
    return 'Це може перезапустити серверну частину й перервати роботу інших користувачів. Ares не буде оновлено.\n\n$gateways';
  }

  @override
  String get release_core_fleet_updates_screen_update_listed_gateways =>
      'Оновити перелічені шлюзи';

  @override
  String
  get release_core_fleet_updates_screen_checks_connected_gateways_cloud_is_platform_managed_entries =>
      'Перевіряє підключені шлюзи. Cloud керується платформою; записи без відомостей про походження реєстрації не враховуються.';

  @override
  String get release_core_fleet_updates_screen_check_connected_gateways =>
      'Перевірити підключені шлюзи';

  @override
  String get release_core_fleet_updates_screen_read_update_receipt =>
      'Прочитати підтвердження оновлення';

  @override
  String get release_core_fleet_updates_screen_review_eligible_updates =>
      'Переглянути оновлення, доступні для застосування';

  @override
  String
  get release_core_fleet_webapp_screen_account_changed_reopen_this_page =>
      'Обліковий запис змінено. Відкрийте цю сторінку знову.';

  @override
  String
  get release_core_fleet_webapp_screen_set_the_webapp_s_primary_gateway =>
      'Установити основний шлюз вебзастосунку?';

  @override
  String
  release_core_fleet_webapp_screen_this_changes_the_shared_registry_not_the_last(
    String webapp,
    String gateway,
    String id,
  ) {
    return '$webapp → $gateway ($id)\nЦе змінює спільний реєстр, а не останній використаний шлюз.';
  }

  @override
  String get release_core_fleet_webapp_screen_set_primary => 'Зробити основним';

  @override
  String get release_core_fleet_webapp_screen_serving_profile =>
      'Профіль обслуговування';

  @override
  String get release_core_fleet_webapp_screen_hermes_cloud => 'Hermes Cloud';

  @override
  String get release_core_fleet_webapp_screen_discover_signed_in_agents =>
      'Виявити агентів, що ввійшли в обліковий запис';

  @override
  String release_core_fleet_webapp_screen_organisation(String organisation) {
    return 'Організація: $organisation';
  }

  @override
  String get release_core_fleet_webapp_screen_no_agents_available =>
      'Немає доступних агентів.';

  @override
  String get release_core_fleet_webapp_screen_existing_desktop_webapp =>
      'Наявний вебзастосунок Desktop';

  @override
  String
  get release_core_fleet_webapp_screen_check_gateway_and_web_access_status =>
      'Перевірити стан шлюзу й вебдоступу';

  @override
  String
  get release_core_fleet_webapp_screen_these_settings_belong_to_the_machine_serving_this =>
      'Ці налаштування належать машині, що обслуговує цей вебзастосунок. Публікація й перезапуски не є віддаленими діями.';

  @override
  String get release_core_fleet_webapp_screen_read_webapp_gateway_registry =>
      'Прочитати реєстр шлюзів вебзастосунку';

  @override
  String get release_core_fleet_webapp_screen_last_used =>
      'Останній використаний';

  @override
  String get release_core_fleet_webapp_screen_primary => 'Основний';

  @override
  String release_core_fleet_webapp_screen_set_primary_2(String gateway) {
    return 'Зробити основним: $gateway';
  }

  @override
  String get release_core_fleet_webapp_screen_read_shared_display_preferences =>
      'Прочитати спільні налаштування відображення';

  @override
  String
  get release_core_fleet_webapp_screen_chat_text_direction_on_this_webapp_and_desktop =>
      'Напрямок тексту чату в цьому вебзастосунку й Desktop';

  @override
  String release_core_schedule_desk_screen_created_on(
    String job,
    String profile,
  ) {
    return 'Створено $job у профілі $profile.';
  }

  @override
  String
  get release_core_schedule_desk_screen_the_list_covers_every_profile_on_this_gateway =>
      'Список охоплює всі профілі на цьому шлюзі. Команди зупинки, паузи, надолуження пропущених запусків, доставлення й шаблони надсилаються до профілю, якому належить завдання.';

  @override
  String get release_core_schedule_desk_screen_a_run_is_in_progress =>
      'Виконується запуск';

  @override
  String get release_core_schedule_desk_screen_no_current_run =>
      'Поточного запуску немає';

  @override
  String release_core_schedule_desk_screen_stop_requested_for(String job) {
    return 'Надіслано запит на зупинку $job.';
  }

  @override
  String release_core_schedule_desk_screen_no_run_was_in_flight_for(
    String job,
  ) {
    return 'Для $job не було активного запуску.';
  }

  @override
  String get release_core_schedule_desk_screen_stop_current_run =>
      'Зупинити поточний запуск';

  @override
  String get release_core_schedule_desk_screen_pause_future_runs =>
      'Призупинити майбутні запуски';

  @override
  String get release_core_schedule_desk_screen_resume_future_runs =>
      'Відновити майбутні запуски';

  @override
  String get release_core_schedule_desk_screen_catch_up_default =>
      'Типове надолуження пропущених запусків';

  @override
  String get release_core_schedule_desk_screen_run_one_missed =>
      'Виконати один пропущений запуск';

  @override
  String get release_core_schedule_desk_screen_skip_missed =>
      'Пропускати пропущені запуски';

  @override
  String get release_core_schedule_desk_screen_blueprint_recipes =>
      'Рецепти шаблонів';

  @override
  String get release_core_schedule_desk_screen_profile_for_the_new_job =>
      'Профіль для нового завдання';

  @override
  String release_core_schedule_desk_screen_create(String blueprint) {
    return 'Створити $blueprint';
  }

  @override
  String get release_core_schedule_desk_screen_loading_delivery_targets =>
      'Завантаження адресатів доставлення';

  @override
  String release_core_schedule_desk_screen_no_home_channel(String target) {
    return '$target (без основного каналу)';
  }

  @override
  String release_core_memory_graph_screen_edit(String label) {
    return 'Редагувати $label';
  }

  @override
  String get release_core_memory_graph_screen_content => 'Вміст';

  @override
  String get release_core_memory_graph_screen_archive_skill =>
      'Архівувати навичку';

  @override
  String get release_core_memory_graph_screen_delete_memory =>
      'Видалити запис пам’яті';

  @override
  String release_core_memory_graph_screen_archive_on_it_can_be_restored_on_the(
    String label,
    String profile,
  ) {
    return 'Архівувати $label у профілі $profile? Це можна відновити на хості за допомогою Curator.';
  }

  @override
  String release_core_memory_graph_screen_delete_from_this_removes_that_memory(
    String label,
    String profile,
  ) {
    return 'Видалити $label із профілю $profile? Цей запис пам’яті буде видалено.';
  }

  @override
  String get release_core_memory_graph_screen_filter => 'Фільтр';

  @override
  String get release_core_memory_graph_screen_timeline => 'Хронологія';

  @override
  String get release_core_memory_graph_screen_play_timeline =>
      'Відтворити хронологію';

  @override
  String get release_core_memory_graph_screen_layout_code => 'Код компонування';

  @override
  String get release_core_memory_graph_screen_external_memory_providers =>
      'Зовнішні провайдери пам’яті';

  @override
  String
  get release_core_memory_graph_screen_a_value_is_stored_leave_blank_to_keep =>
      'Значення вже збережено. Залиште поле порожнім, щоб зберегти його.';

  @override
  String get release_core_memory_graph_screen_save_provider =>
      'Зберегти провайдера';

  @override
  String release_core_workspace_profiles_screen_applies_to(String profile) {
    return 'Застосовується до: $profile';
  }

  @override
  String get release_core_workspace_profiles_screen_choose_another_profile =>
      'Вибрати інший профіль';

  @override
  String
  get release_core_workspace_profiles_screen_could_not_verify_the_selected_profile_on_this =>
      'Не вдалося перевірити вибраний профіль на цьому шлюзі.';

  @override
  String get release_core_workspace_profiles_screen_create_profile =>
      'Створити профіль';

  @override
  String get release_core_workspace_profiles_screen_new_profile_id =>
      'ID нового профілю';

  @override
  String get release_core_assets_screen_links => 'Посилання';

  @override
  String get release_core_workspace_picker_no_matching_items =>
      'Немає відповідних елементів.';

  @override
  String get release_core_workspace_picker_save_layout =>
      'Зберегти компонування';

  @override
  String get release_core_workspace_picker_layout_name => 'Назва компонування';

  @override
  String
  get release_core_workspace_popout_this_chat_already_has_a_pop_out_window =>
      'Цей чат уже має окреме вікно.';

  @override
  String
  get release_core_workspace_popout_could_not_open_this_saved_chat_check_the =>
      'Не вдалося відкрити цей збережений чат. Перевірте підключення й повторіть спробу.';

  @override
  String
  get release_core_popout_bootstrap_use_the_main_window_to_change_your_connection =>
      'Щоб змінити підключення, скористайтеся головним вікном.';

  @override
  String get release_core_guarded_save_refused =>
      'Шлюз не може зберегти цей файл';

  @override
  String get release_core_guarded_save_unavailable =>
      'Захищене збереження недоступне на цьому шлюзі';

  @override
  String release_core_git_files_changed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'За цей хід змінено файлів: $count',
      one: 'За цей хід змінено 1 файл',
    );
    return '$_temp0';
  }

  @override
  String release_core_git_entries_omitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Записів Git, прихованих через небезпеку показу: $count.',
      one: '1 запис Git приховано, оскільки його показ був небезпечним.',
    );
    return '$_temp0';
  }

  @override
  String get release_core_git_staged => 'В індексі';

  @override
  String get release_core_session_sort_recent => 'Остання активність';

  @override
  String get release_core_session_sort_created => 'Найновіші за створенням';

  @override
  String get release_core_session_sort_status => 'Спершу активні';

  @override
  String get release_core_session_sort_tokens => 'Найбільше токенів';

  @override
  String get release_core_session_sort_cost => 'Найвища вартість';

  @override
  String get release_core_session_group_standard => 'Типове групування';

  @override
  String get release_core_session_group_status => 'Групувати за станом';

  @override
  String get release_core_session_group_project => 'Групувати за проєктом';

  @override
  String release_core_session_tokens(int count) {
    return 'Токенів: $count';
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
      'Надсилання створює новий хід';

  @override
  String release_core_image_recovery_metadata(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Зображень: $count · $date',
      one: '1 зображення · $date',
    );
    return '$_temp0';
  }

  @override
  String release_core_discovery_scanning(String state) {
    return 'Сканування: $state';
  }

  @override
  String get release_core_discovery_enabled => 'увімкнено';

  @override
  String get release_core_discovery_disabled => 'вимкнено';

  @override
  String get release_core_discovery_none => 'немає';

  @override
  String release_core_discovery_roots(String paths) {
    return 'Кореневі каталоги сканування: $paths';
  }

  @override
  String release_core_discovery_excluded(String paths) {
    return 'Виключені піддерева: $paths';
  }

  @override
  String release_core_discovery_repository_sessions(String path, int count) {
    return '$path\nСесії: $count';
  }

  @override
  String get release_core_projects_local_only =>
      'Цей шлюз Hermes не підтримує серверні проєкти, тому групування чатів зберігається лише на цьому пристрої. Оновіть Hermes для спільних проєктів на всіх пристроях.';

  @override
  String get release_core_fleet_no_address => 'Адреси шлюзу ще немає';

  @override
  String release_core_fleet_diagnostics(String version, String access) {
    return 'Шлюз $version · $access';
  }

  @override
  String get release_core_schedule_builtin => 'вбудований';

  @override
  String get release_core_memory_gateway_profile => 'шлюз';

  @override
  String release_core_memory_profile_summary(String profile, String gateway) {
    return 'Профіль $profile на $gateway. Код поширення зберігає лише масштаб, час і фільтри.';
  }

  @override
  String release_core_memory_layers_summary(
    int memoryBytes,
    int userBytes,
    String provider,
  ) {
    return 'Пам’ять у байтах: вбудована — $memoryBytes, користувацька — $userBytes. Активний провайдер: $provider.';
  }

  @override
  String get release_core_memory_kind_all => 'Усі';

  @override
  String get release_core_memory_kind_skill => 'Навички';

  @override
  String get release_core_memory_kind_memory => 'Пам’ять';

  @override
  String get release_core_workspace_failure_stale => 'підключення змінено';

  @override
  String get release_core_workspace_failure_unbound =>
      'немає перевіреного робочого каталогу';

  @override
  String get release_core_workspace_failure_denied => 'доступ заборонено';

  @override
  String get release_core_workspace_failure_ineligible =>
      'операція не дозволена для цього файлу';

  @override
  String get release_core_workspace_failure_unsupported =>
      'не підтримується цим шлюзом';

  @override
  String get release_core_workspace_failure_mismatch =>
      'віддалений стан змінено';

  @override
  String get release_core_workspace_failure_invalid =>
      'некоректна відповідь шлюзу';

  @override
  String get release_core_workspace_failure_insecure =>
      'потрібне захищене підключення';

  @override
  String get release_core_workspace_failure_unavailable => 'шлюз недоступний';

  @override
  String get release_core_queue_state_queued => 'У черзі';

  @override
  String get release_core_queue_state_started => 'Розпочато';

  @override
  String get release_core_queue_state_unknown => 'Невідомий результат';

  @override
  String get release_core_unknown_state => 'Невідомо';

  @override
  String get release_core_fleet_state_idle => 'Немає зв’язку';

  @override
  String get release_core_fleet_state_connected => 'Підключено';

  @override
  String get release_core_fleet_state_reconnecting => 'Повторне підключення…';

  @override
  String get release_core_fleet_state_sessionExpired =>
      'Вихід з облікового запису виконано';

  @override
  String get release_core_fleet_state_failed => 'Помилка підключення';

  @override
  String release_core_workspace_operation_failed(String reason) {
    return 'Не вдалося підтвердити операцію шлюзу: $reason.';
  }

  @override
  String get release_core_workspace_invalid_data =>
      'Не вдалося перевірити дані або введення. Перевірте їх і повторіть спробу.';

  @override
  String
  get release_core_parallel_workspace_layout_changed_in_this_window_but_could_not =>
      'Компонування змінено в цьому вікні, але зберегти його не вдалося.';

  @override
  String get release_core_parallel_workspace_first_pane => 'Перша панель';

  @override
  String get release_core_parallel_workspace_second_pane => 'Друга панель';

  @override
  String get release_core_parallel_workspace_unavailable_page =>
      'Недоступна сторінка';

  @override
  String release_core_parallel_workspace_close_a_tab_first_maximum(
    String maximum,
  ) {
    return 'Спершу закрийте вкладку (максимум $maximum).';
  }

  @override
  String get release_core_parallel_workspace_dock_beside_current_pane =>
      'Прикріпити поруч із поточною панеллю';

  @override
  String get release_core_parallel_workspace_add_chat => 'Додати чат';

  @override
  String
  get release_core_parallel_workspace_action_failed_check_the_connection_and_try_again =>
      'Не вдалося виконати дію. Перевірте підключення й повторіть спробу.';

  @override
  String
  get release_core_parallel_workspace_close_a_tab_before_reopening_another =>
      'Закрийте вкладку, перш ніж відкривати іншу знову.';

  @override
  String release_core_parallel_workspace_replace_layout(String name) {
    return 'Замінити компонування «$name»?';
  }

  @override
  String
  get release_core_parallel_workspace_layout_limit_reached_replace_an_existing_layout =>
      'Досягнуто ліміту компонувань. Замініть наявне компонування.';

  @override
  String get release_core_parallel_workspace_restore_layout =>
      'Відновити компонування';

  @override
  String get release_core_parallel_workspace_workspace_options =>
      'Параметри робочого простору';

  @override
  String get release_core_parallel_workspace_dock_another_pane =>
      'Прикріпити ще одну панель';

  @override
  String get release_core_parallel_workspace_swap_panes =>
      'Поміняти панелі місцями';

  @override
  String get release_core_parallel_workspace_undock_second_pane =>
      'Відкріпити другу панель';

  @override
  String get release_core_parallel_workspace_arrange_side_by_side =>
      'Розташувати поруч';

  @override
  String get release_core_parallel_workspace_arrange_top_to_bottom =>
      'Розташувати одну під одною';

  @override
  String release_core_parallel_workspace_change_split_size(String percent) {
    return 'Змінити пропорції поділу ($percent%)';
  }

  @override
  String get release_core_parallel_workspace_focus_pane_full_screen =>
      'Показати активну панель на весь екран';

  @override
  String get release_core_parallel_workspace_open_chat_in_new_window =>
      'Відкрити чат у новому вікні';

  @override
  String get release_core_parallel_workspace_hide_pane_keep_running =>
      'Приховати панель (залишити працювати)';

  @override
  String get release_core_parallel_workspace_previous_tab =>
      'Попередня вкладка';

  @override
  String get release_core_parallel_workspace_next_tab => 'Наступна вкладка';

  @override
  String get release_core_parallel_workspace_move_tab_left =>
      'Перемістити вкладку ліворуч';

  @override
  String get release_core_parallel_workspace_move_tab_right =>
      'Перемістити вкладку праворуч';

  @override
  String get release_core_parallel_workspace_reload_current_tab =>
      'Перезавантажити поточну вкладку';

  @override
  String get release_core_parallel_workspace_close_tab => 'Закрити вкладку';

  @override
  String get release_core_parallel_workspace_close_other_tabs =>
      'Закрити інші вкладки';

  @override
  String get release_core_parallel_workspace_close_tabs_to_the_right =>
      'Закрити вкладки праворуч';

  @override
  String get release_core_parallel_workspace_close_all_tabs =>
      'Закрити всі вкладки';

  @override
  String get release_core_parallel_workspace_reopen_closed_tab =>
      'Відкрити закриту вкладку знову';

  @override
  String get release_core_parallel_workspace_save_named_layout =>
      'Зберегти іменоване компонування';

  @override
  String get release_core_parallel_workspace_restore_named_layout =>
      'Відновити іменоване компонування';

  @override
  String get release_core_parallel_workspace_refresh_chat_list =>
      'Оновити список чатів';

  @override
  String get release_core_parallel_workspace_workspace_tools =>
      'Інструменти робочого простору';

  @override
  String get release_core_parallel_workspace_choose_a_chat_for_this_pane =>
      'Виберіть чат для цієї панелі';

  @override
  String release_core_parallel_workspace_choose_chat_for(String pane) {
    return 'Вибрати чат для $pane';
  }

  @override
  String get release_core_parallel_workspace_add_a_chat_to_start_a_workspace =>
      'Додайте чат, щоб почати робочий простір.';

  @override
  String get release_core_parallel_workspace_select_a_tab_to_show_its_pane =>
      'Виберіть вкладку, щоб показати її панель.';

  @override
  String get release_core_parallel_workspace_parallel_workspace =>
      'Паралельний робочий простір';

  @override
  String get release_core_parallel_workspace_show_workspace =>
      'Показати робочий простір';

  @override
  String get release_core_parallel_workspace_could_not_load_chats_retry =>
      'Не вдалося завантажити чати. Повторити спробу';

  @override
  String release_core_parallel_workspace_close(String pane) {
    return 'Закрити $pane';
  }

  @override
  String release_core_parallel_workspace_switch_pane(String pane) {
    return 'Перемкнути панель: $pane';
  }

  @override
  String get release_core_workspace_registry_session_id_copied =>
      'ID сесії скопійовано.';

  @override
  String get release_core_workspace_registry_chat_details =>
      'Відомості про чат';

  @override
  String get release_core_workspace_registry_server_default =>
      'Типове значення сервера';

  @override
  String get release_core_workspace_registry_session_id => 'ID сесії';

  @override
  String get release_core_workspace_registry_title => 'Назва';

  @override
  String get release_core_workspace_label_terminals => 'Термінали';

  @override
  String get release_core_workspace_label_copy_id => 'Копіювати ID сесії';

  @override
  String get release_core_workspace_label_contributions => 'Внески';

  @override
  String get release_core_workspace_owner_inactive =>
      'Власник цього робочого простору більше не активний.';

  @override
  String get release_core_workspace_select_chat => 'Спершу виберіть чат.';

  @override
  String get release_core_workspace_chat_unavailable =>
      'Цей чат недоступний для цього підключення.';

  @override
  String get release_core_workspace_page_unavailable =>
      'Ця сторінка недоступна для цього підключення.';

  @override
  String release_core_client_queue_count(int count) {
    return 'У черзі: $count';
  }

  @override
  String release_core_client_queue_paused_count(int count) {
    return 'У черзі: $count — призупинено';
  }

  @override
  String release_core_git_diff_truncated(String diff) {
    return '$diff\n… обрізано';
  }

  @override
  String get release_core_search_no_models =>
      'Hermes не повернув налаштованих моделей, доступних для вибору.';

  @override
  String get release_core_chat_archive_unavailable =>
      'Дія архівування чату недоступна.';

  @override
  String get release_core_chat_pin_unconfirmed =>
      'Стан закріплення не підтверджено.';

  @override
  String get release_core_chat_archive_unconfirmed =>
      'Архівний стан не підтверджено.';

  @override
  String get release_core_chat_archive_history_unavailable =>
      'Архівна історія недоступна';

  @override
  String get release_core_quick_chat_history_unavailable =>
      'Історія швидких чатів недоступна';

  @override
  String get release_core_chat_project_ownership_unavailable =>
      'Відомості про власника проєкту недоступні';

  @override
  String get release_core_chat_unknown_project => 'Невідомий проєкт';

  @override
  String get release_core_chat_local_search_fallback =>
      'Пошук повідомлень недоступний. Показано локальні збіги.';

  @override
  String release_core_fleet_update_eligible(String version) {
    return 'Можна оновити · $version';
  }

  @override
  String get release_core_fleet_update_state_1 =>
      'Пропущено: та сама інсталяція';

  @override
  String get release_core_fleet_update_state_2 => 'Не перевірено';

  @override
  String get release_core_fleet_update_state_3 => 'Пропущено: керується Cloud';

  @override
  String get release_core_fleet_update_state_4 =>
      'Пропущено: не зареєстровано як прямий шлюз';

  @override
  String get release_core_fleet_update_state_5 =>
      'Пропущено: відключено або зайнято';

  @override
  String get release_core_fleet_update_state_6 =>
      'Немає застосовного оновлення';

  @override
  String get release_core_fleet_update_state_7 =>
      'Не вдалося перевірити можливість оновлення';

  @override
  String get release_core_fleet_update_state_8 =>
      'Пропущено: дані застаріли, зайнято або вже запитано';

  @override
  String get release_core_fleet_update_state_9 => 'Надсилання запиту';

  @override
  String get release_core_fleet_update_state_10 =>
      'Прийнято; підтвердження недоступне';

  @override
  String get release_core_fleet_update_state_11 =>
      'Прийнято; очікування підтвердження';

  @override
  String get release_core_fleet_update_state_12 =>
      'Пропущено: в цій інсталяції виконується чат';

  @override
  String get release_core_fleet_update_state_13 =>
      'Не підтверджено; не надсилати повторно автоматично';

  @override
  String get release_core_fleet_update_state_14 =>
      'Підключіться знову, щоб перевірити підтвердження';

  @override
  String get release_core_fleet_update_state_15 => 'Підтвердження недоступне';

  @override
  String get release_core_fleet_update_state_16 =>
      'Очікування відповідного підтвердження';

  @override
  String get release_core_fleet_update_state_17 =>
      'Оновлено; потрібні подальші дії';

  @override
  String get release_core_fleet_update_state_19 => 'Частково оновлено';

  @override
  String get release_core_fleet_update_state_20 => 'Помилка оновлення';

  @override
  String get release_core_fleet_update_state_21 => 'Не підтверджено';

  @override
  String get release_core_cloud_status_ready => 'Готово';

  @override
  String get release_core_cloud_status_online => 'На зв’язку';

  @override
  String get release_core_cloud_status_stopped => 'Зупинено';

  @override
  String get release_core_cloud_status_error => 'Помилка';

  @override
  String get ng_release_more_contributions_subtitle =>
      'Перевірені картки відповідей для цього підключення';

  @override
  String get ng_release_more_gateway_fleet => 'Парк шлюзів';

  @override
  String get ng_release_more_memory_graph => 'Граф пам’яті';

  @override
  String get ng_release_more_memory_graph_subtitle =>
      'Хронологія, зміни й провайдери пам’яті';

  @override
  String get ng_release_more_capabilities_subtitle =>
      'Установлюйте й керуйте навичками, плагінами, конекторами та серверними компонентами інструментів';

  @override
  String get ng_release_more_browser_vault => 'Сховище браузера';

  @override
  String get ng_release_more_browser_vault_subtitle =>
      'Облікові дані сайтів, адреси, картки й джерела облікових даних';

  @override
  String get ng_release_more_agent_policy => 'Політика агента';

  @override
  String get ng_release_more_agent_policy_subtitle =>
      'Схвалення, контрольні точки, доступ до браузера й спільні метрики';

  @override
  String get ng_release_more_schedules => 'Розклади';

  @override
  String get ng_release_more_schedules_subtitle =>
      'Усі профілі, шаблони, надолуження пропущених запусків і зупинка';

  @override
  String get ng_release_more_host_subtitle =>
      'Віддалені журнали, стан, обслуговування й оновлення';

  @override
  String get ng_release_more_providers_routes => 'Провайдери й маршрути';

  @override
  String get ng_release_more_providers_routes_subtitle =>
      'Ключі, кінцеві точки, делегування й суміші';

  @override
  String get ng_release_more_credits_plans => 'Кредити й тарифні плани';

  @override
  String get ng_release_more_credits_plans_subtitle =>
      'Оплата Nous за вашою згодою, якщо це дозволяє обліковий запис';

  @override
  String get ng_release_sign_in_or => 'або';

  @override
  String ng_release_deployment_sign_in_hint(String message) {
    return '$message На наступному кроці ви все ще можете ввійти за допомогою токена сесії розгортання.';
  }

  @override
  String get ng_release_message_search_unavailable =>
      'Пошук повідомлень недоступний. Показано локальні збіги.';

  @override
  String ng_release_insights_days(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Днів: $days',
      one: '$days день',
    );
    return '$_temp0';
  }

  @override
  String get ng_release_signed_in_you => 'ви';

  @override
  String get release_chat_unsent_prompt_gone =>
      'Цього ненадісланого запиту більше немає в черзі.';

  @override
  String ng_release_attachment_not_attached(String name) {
    return 'Шлюз не додав вкладення $name.';
  }

  @override
  String get ng_release_gateway_not_connected =>
      'Підключення до шлюзу ще не встановлено.';

  @override
  String get ng_release_gateway_unreachable =>
      'Не вдалося зв’язатися зі шлюзом.';

  @override
  String get ng_release_projects_scope_changed =>
      'Область проєктів більше не вибрана';

  @override
  String get ng_release_missing_providers => 'Відсутні провайдери';

  @override
  String get ng_release_missing_tasks => 'Відсутні завдання';

  @override
  String ng_release_age_minutes(int count) {
    return '$count хв';
  }

  @override
  String ng_release_age_hours(int count) {
    return '$count год';
  }

  @override
  String ng_release_age_days(int count) {
    return '$count дн.';
  }

  @override
  String ng_release_age_weeks(int count) {
    return '$count тиж.';
  }

  @override
  String ng_release_age_years(int count) {
    return '$count р.';
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
    return '$count тис.';
  }

  @override
  String ng_release_token_thousands(String count) {
    return '$count тис.';
  }

  @override
  String ng_release_elapsed_minutes_seconds(int minutes, int seconds) {
    return '$minutes хв $seconds с';
  }

  @override
  String ng_release_elapsed_seconds(int seconds) {
    return '$seconds с';
  }

  @override
  String get ng_release_notification_foreground => 'Ares був на екрані';

  @override
  String get ng_release_notification_stopped => 'хід було зупинено';

  @override
  String get ng_release_more_parallel_workspace =>
      'Паралельний робочий простір';

  @override
  String get ng_release_more_parallel_workspace_subtitle =>
      'Відкривайте кілька чатів у вкладках або поруч.';

  @override
  String get release_chat_unknown_model => 'невідомо';

  @override
  String release_chat_profile_default(String model) {
    return 'Типова модель профілю: $model';
  }

  @override
  String release_chat_profile_default_provider(String model, String provider) {
    return 'Типова модель профілю: $model • $provider';
  }

  @override
  String get release_chat_choose_provider =>
      'Ця модель доступна в кількох провайдерів. Виберіть провайдера, щоб продовжити.';

  @override
  String get release_chat_slash_needs_gateway =>
      'Для команд із косою рискою потрібен шлюз Desktop';

  @override
  String get release_chat_recovering_without_resending =>
      'Відновлення без повторного надсилання';

  @override
  String get release_chat_live_request_unreachable =>
      'Перепрошую, не вдалося зв’язатися з Hermes для цього запиту.';

  @override
  String release_chat_live_working(String tool) {
    return 'Hermes працює: $tool. Ще не завершено.';
  }

  @override
  String get release_chat_live_finished_without_spoken_result =>
      'Hermes завершив цей запит без голосового результату.';

  @override
  String get release_chat_reply_language_unavailable =>
      'Вибрана мова відповіді недоступна';

  @override
  String get release_chat_reply_voice_unavailable =>
      'Вибраний голос відповіді недоступний';

  @override
  String get release_chat_reply_voice_configuration_unavailable =>
      'Налаштування голосу відповіді недоступне';

  @override
  String get release_chat_notification_review_action =>
      'Відкрийте чат, щоб переглянути запитану дію.';

  @override
  String get release_chat_notification_respond =>
      'Відкрийте чат, щоб відповісти.';

  @override
  String get release_chat_start_new_main_window =>
      'Почніть новий чат у головному вікні.';

  @override
  String get release_chat_no_desktop_gateway => 'Немає шлюзу Desktop';

  @override
  String get release_chat_attachment_preparation_cancelled =>
      'Підготовку вкладення скасовано.';

  @override
  String get release_chat_approval_authority_revoked =>
      'Повноваження на схвалення відкликано.';

  @override
  String get release_chat_gateway_session_disconnected =>
      'Сесія шлюзу Desktop більше не підключена';

  @override
  String get release_chat_stop_requested =>
      'Зупинку запитано. Очікування завершення роботи Hermes.';

  @override
  String release_chat_stop_request_failed(String error) {
    return 'Не вдалося запитати зупинку: $error';
  }

  @override
  String get release_chat_queued_prompt_not_sent =>
      'Запит із черги не надіслано.';

  @override
  String get release_chat_running_turn_unreachable =>
      'Не вдалося зв’язатися з поточним ходом. Повторне підключення без повторного надсилання.';

  @override
  String get release_chat_wait_for_composer =>
      'Зачекайте, поки поле повідомлення стане доступним.';

  @override
  String get release_chat_find_in_transcript => 'Знайти в транскрипті';

  @override
  String get release_chat_open_browser_preview =>
      'Відкрити попередній перегляд у браузері';

  @override
  String get release_chat_more_tools => 'Інші інструменти чату';

  @override
  String get release_chat_queue_until_finished =>
      'Додати до черги до завершення цього ходу';

  @override
  String get release_chat_format_bold => 'Жирний';

  @override
  String get release_chat_format_italic => 'Курсив';

  @override
  String get ng_release_chat_gateway_queue_requirements =>
      'Для черги шлюзу потрібні приєднаний чат і суто текстовий запит.';

  @override
  String get ng_release_chat_start_new_main_screen =>
      'Почніть новий чат із головного екрана чатів.';

  @override
  String get ng_release_chat_image => 'зображення';

  @override
  String ng_release_chat_tool_seconds(String seconds) {
    return '$seconds с';
  }

  @override
  String get release_preview_chat_changed =>
      'Чат змінено. Підключіть попередній перегляд знову, щоб продовжити.';

  @override
  String get release_preview_authenticating_chat => 'Автентифікація чату…';

  @override
  String release_preview_unavailable_reason(String reason) {
    return 'Попередній перегляд недоступний: $reason';
  }

  @override
  String get release_preview_operation_failed =>
      'Помилка операції попереднього перегляду.';

  @override
  String get release_preview_added_to_draft =>
      'Додано до чернетки. Нічого не надіслано.';

  @override
  String get release_preview_open_site_title => 'Відкрити цей сайт?';

  @override
  String release_preview_open_site_body(String origin) {
    return '$origin\n\nРежим читання завантажує лише цей документ. Він не передає Hermes файли cookie, дані входу чи сторінку.';
  }

  @override
  String get release_preview_open_site => 'Відкрити сайт';

  @override
  String get release_preview_discard_pins_title =>
      'Відкинути позначки, не додані до чернетки?';

  @override
  String get release_preview_keep_pins => 'Залишити позначки';

  @override
  String get release_preview_share_page_title =>
      'Поділитися цією сторінкою з цим чатом?';

  @override
  String release_preview_share_page_body(String origin) {
    return 'Hermes зможе читати показаний текст і список елементів із $origin, а також прокручувати цю панель. Перехід на іншу сторінку припиняє спільний доступ. Форми й облікові дані не передаються.';
  }

  @override
  String get release_preview_share_page => 'Поділитися сторінкою';

  @override
  String release_preview_comment_number(int number) {
    return 'Коментар № $number';
  }

  @override
  String get release_preview_note => 'Нотатка';

  @override
  String get release_preview_keep_pin => 'Залишити позначку';

  @override
  String get release_preview_title => 'Попередній перегляд у браузері';

  @override
  String get release_preview_hide => 'Приховати попередній перегляд';

  @override
  String get release_preview_close_and_forget => 'Закрити й забути сторінку';

  @override
  String get release_preview_site_address => 'Адреса сайту';

  @override
  String get release_preview_go_to_address => 'Перейти за адресою';

  @override
  String get release_preview_forward => 'Уперед';

  @override
  String get release_preview_reload => 'Перезавантажити';

  @override
  String get release_preview_share_with_hermes =>
      'Поділитися сторінкою з Hermes';

  @override
  String get release_preview_stop_sharing =>
      'Припинити спільний доступ до сторінки';

  @override
  String get release_preview_annotate =>
      'Додати коментар до елемента або області';

  @override
  String get release_preview_reader_console => 'Консоль режиму читання';

  @override
  String get release_preview_reconnect =>
      'Підключити попередній перегляд знову';

  @override
  String get release_preview_reader_mode_help =>
      'Режим читання: HTML і текст. Без скриптів, вбудованих ресурсів або профілю браузера з виконаним входом.';

  @override
  String release_preview_sharing_origin(String origin) {
    return 'Спільний доступ до режиму читання для цього чату: $origin';
  }

  @override
  String get release_preview_annotation_help =>
      'Торкніться елемента або виділіть область перетягуванням, щоб додати коментар.';

  @override
  String get release_preview_reader_requests =>
      'Запити режиму читання (JavaScript вимкнено)';

  @override
  String release_preview_selected_requests(int count) {
    return 'Вибрано: $count · JavaScript вимкнено';
  }

  @override
  String get release_preview_copy_all => 'Копіювати все';

  @override
  String get release_preview_copy_selected => 'Копіювати вибране';

  @override
  String get release_preview_add_log_to_draft => 'Додати журнал до чернетки';

  @override
  String release_preview_requests_draft(String log) {
    return 'Запити режиму читання:\n$log';
  }

  @override
  String release_preview_add_pins_to_draft(int count) {
    return 'Додати до чернетки: $count';
  }

  @override
  String release_preview_request_loaded(String origin, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Елементів режиму читання: $count',
      one: '$count елемент режиму читання',
    );
    return 'HTTP 200 · $origin · $_temp0';
  }

  @override
  String release_preview_annotation_intro(String origin) {
    return 'Перегляньте ці коментарі до попереднього перегляду $origin. Додані фрагменти зображень пронумеровано в тому самому порядку.';
  }

  @override
  String get release_preview_reader_region => 'область режиму читання';

  @override
  String get release_preview_capture_failed =>
      'Не вдалося захопити ці пікселі.';

  @override
  String get release_preview_address_not_approved =>
      'Ця адреса поза межами дозволеного джерела попереднього перегляду.';

  @override
  String get release_preview_page_limit =>
      'Сторінка перевищує ліміт режиму читання.';

  @override
  String get release_preview_page_unreadable =>
      'Не вдалося прочитати сторінку.';

  @override
  String get release_preview_page_complex =>
      'Ця сторінка надто складна для режиму читання.';

  @override
  String release_preview_http_failed(int statusCode) {
    return 'HTTP $statusCode. Перенаправлення й вхід не виконувалися.';
  }

  @override
  String get release_preview_unsupported_type =>
      'У режимі читання можна відкривати лише HTML і звичайний текст.';

  @override
  String get release_preview_load_insecure =>
      'Не вдалося безпечно завантажити сайт.';

  @override
  String get release_preview_crop_limit =>
      'Фрагмент попереднього перегляду перевищує ліміт.';

  @override
  String get release_preview_image_unreadable =>
      'Вибране зображення порожнє або нечитабельне.';

  @override
  String get release_preview_image_budget =>
      'Вибране зображення перевищує ліміт чернетки в 64 MiB.';

  @override
  String get release_preview_image_format =>
      'Непідтримуваний формат зображення. Виберіть зображення JPEG, PNG або WebP.';

  @override
  String get release_preview_image_decode =>
      'Не вдалося безпечно декодувати вибране зображення JPEG, PNG або WebP.';

  @override
  String get release_preview_image_sanitize =>
      'Не вдалося безпечно очистити метадані цього зображення. Виберіть коректне зображення JPEG, PNG або WebP.';

  @override
  String get release_preview_draft_budget =>
      'Загальний розмір вкладень обмежено 64 MiB на чернетку.';

  @override
  String get release_preview_generic_file_limit =>
      'Розмір кожного звичайного файлу обмежено 16 MiB.';

  @override
  String get release_preview_image_not_sanitized =>
      'Перед завантаженням віддалені зображення потрібно очистити від метаданих.';

  @override
  String get release_preview_stage_failed =>
      'Не вдалося додати матеріали попереднього перегляду до чернетки. Повторіть спробу.';

  @override
  String get release_misc_find_hermes_on_lan => 'Знайти Hermes у LAN';

  @override
  String release_misc_discovery_failed(String error) {
    return 'Помилка виявлення: $error';
  }

  @override
  String get release_misc_no_lan_servers =>
      'У локальній мережі не знайдено серверів Hermes.';

  @override
  String release_misc_api_key_rejected(String endpoint, int statusCode) {
    return '$endpoint відхилив ключ API (HTTP $statusCode).';
  }

  @override
  String get release_misc_api_key_required =>
      'Сервер потребує ключа API. Уведіть свій API_SERVER_KEY.';

  @override
  String release_misc_gateway_not_found(String endpoint) {
    return 'Кінцева точка шлюзу $endpoint повернула HTTP 404. Перевірте префікс шляху шлюзу й маршрути зворотного проксі.';
  }

  @override
  String release_misc_gateway_http_error(String endpoint, int statusCode) {
    return 'Кінцева точка шлюзу $endpoint повернула HTTP $statusCode.';
  }

  @override
  String release_misc_gateway_unreachable(String endpoint) {
    return 'Не вдається зв’язатися з кінцевою точкою шлюзу $endpoint.';
  }

  @override
  String get release_core_schedule_invalid_delivery_target =>
      'Недійсне місце доставки';

  @override
  String get release_core_file_save_direct_only =>
      'Можна зберегти лише файл безпосередньо в робочому каталозі.';

  @override
  String get release_core_file_save_hidden =>
      'Шлюз не може зберігати приховані файли.';

  @override
  String get rel_admin_choose_provider => 'Виберіть постачальника й модель.';

  @override
  String get rel_admin_known_effort => 'Виберіть відомий рівень зусиль.';

  @override
  String get rel_admin_endpoint_name_required =>
      'Введіть назву цієї кінцевої точки.';

  @override
  String get rel_admin_endpoint_model_required =>
      'Введіть модель, яку обслуговує ця кінцева точка.';

  @override
  String get rel_admin_known_api_mode =>
      'Виберіть автоматичний або відомий режим API.';

  @override
  String get rel_admin_endpoint_id_invalid =>
      'Цей ідентифікатор кінцевої точки не можна використати.';

  @override
  String get rel_admin_endpoint_https =>
      'Використовуйте HTTPS для віддаленої кінцевої точки або HTTP на localhost.';

  @override
  String get rel_admin_key_invalid => 'Цей ключ API неможливо зберегти.';

  @override
  String get rel_admin_response_shape =>
      'Відповідь шлюзу не відповідає очікуваній структурі.';

  @override
  String get rel_admin_limits_required =>
      'Перед збереженням укажіть обмеження ітерацій, паралельності та часу очікування.';

  @override
  String get rel_admin_route_required =>
      'Для збереження кожного маршруту потрібні назва й модель.';

  @override
  String get rel_admin_route_unique =>
      'Назви маршрутів мають бути унікальними.';

  @override
  String get rel_admin_route_default_invalid =>
      'Маршрут за замовчуванням має бути одним зі збережених маршрутів.';

  @override
  String get rel_admin_policy_required =>
      'Виберіть політику сповіщення або мовчання при погіршенні роботи референсних моделей.';

  @override
  String get rel_admin_mixture_missing => 'Шлюз не повернув активну суміш.';

  @override
  String get rel_admin_mixture_slots_required =>
      'Укажіть постачальника й модель для агрегатора та кожної референсної моделі.';

  @override
  String get rel_admin_chat_id_required =>
      'Введіть ID чату, до якого застосовується ця зміна.';

  @override
  String rel_admin_http_error(String status) {
    return 'Шлюз повернув HTTP $status.';
  }

  @override
  String get rel_admin_response_unreadable =>
      'Не вдалося прочитати відповідь шлюзу.';

  @override
  String get rel_admin_connect_before_change =>
      'Підключіть активний сеанс шлюзу перед зміною оплати або чату.';

  @override
  String get rel_admin_operation_unavailable =>
      'Цей шлюз не підтримує цю операцію.';

  @override
  String get rel_admin_key_required => 'Введіть ключ для збереження.';

  @override
  String get rel_admin_key_save_failed => 'Шлюз не зберіг цей ключ.';

  @override
  String get rel_admin_key_clear_required =>
      'Виберіть ключ постачальника для видалення.';

  @override
  String get rel_admin_key_clear_failed => 'Шлюз не видалив цей ключ.';

  @override
  String get rel_admin_endpoint_save_failed =>
      'Шлюз не зберіг цю кінцеву точку.';

  @override
  String get rel_admin_endpoint_activate_failed =>
      'Шлюз не активував цю кінцеву точку.';

  @override
  String get rel_admin_accounts_secure_required =>
      'Для облікових записів постачальників потрібен автентифікований шлюз HTTPS або localhost.';

  @override
  String get rel_admin_accounts_read_failed =>
      'Не вдалося прочитати облікові записи постачальників.';

  @override
  String get rel_admin_account_disconnect_failed =>
      'Шлюз не відключив цей обліковий запис.';

  @override
  String get rel_admin_account_not_disconnectable =>
      'Цей обліковий запис постачальника неможливо відключити.';

  @override
  String get rel_admin_backend_required =>
      'Виберіть один із доступних бекендів делегування.';

  @override
  String get rel_admin_backend_save_failed => 'Шлюз не вибрав цей бекенд.';

  @override
  String get rel_admin_routes_save_failed => 'Шлюз не зберіг ці маршрути.';

  @override
  String get rel_admin_profile_route_required =>
      'Для кожного маршруту профілю потрібна назва профілю.';

  @override
  String get rel_admin_profile_route_unique =>
      'Маршрути профілів мають бути унікальними.';

  @override
  String get rel_admin_profile_route_default_invalid =>
      'Маршрут профілю за замовчуванням має бути одним із дозволених профілів.';

  @override
  String get rel_admin_profile_routes_save_failed =>
      'Шлюз не зберіг ці маршрути профілів.';

  @override
  String get rel_admin_limits_save_failed => 'Шлюз не зберіг ці обмеження.';

  @override
  String get rel_admin_mixture_save_failed => 'Шлюз не зберіг цю суміш.';

  @override
  String get rel_admin_credit_amount_required =>
      'Виберіть одну із запропонованих сум поповнення.';

  @override
  String get rel_admin_charge_check_failed =>
      'Не вдалося перевірити це списання.';

  @override
  String get rel_admin_reload_amounts_missing =>
      'Суми автопоповнення не вказані, тому їх не змінено.';

  @override
  String get rel_admin_plan_required => 'Спочатку виберіть план.';

  @override
  String get rel_admin_plan_scheduled_only =>
      'Тут можна підтвердити лише заплановану зміну плану.';

  @override
  String get rel_admin_billing_refused => 'Шлюз відхилив цей запит оплати.';

  @override
  String get rel_admin_request_refused => 'Шлюз відхилив цей запит.';

  @override
  String get rel_admin_endpoint_answered => 'Кінцева точка відповіла.';

  @override
  String get rel_admin_endpoint_no_answer => 'Кінцева точка не відповіла.';

  @override
  String get rel_admin_charge_unknown =>
      'Результат списання невідомий. Воно ще може завершитися. Перевірте портал перед повторною спробою.';

  @override
  String get rel_admin_connect_before_billing =>
      'Підключіть активний сеанс шлюзу перед переглядом оплати. На цій сторінці нічого не списується.';

  @override
  String get rel_admin_preset_required =>
      'Збережіть попереднє налаштування перед застосуванням.';

  @override
  String get rel_admin_cancel => 'Скасувати';

  @override
  String get rel_admin_refresh => 'Оновити';

  @override
  String get rel_admin_credits_and_plans => 'Кредити й тарифні плани';

  @override
  String get rel_admin_saved => 'Збережено';

  @override
  String get rel_admin_name => 'Ім’я';

  @override
  String get rel_admin_base_url => 'Базова адреса';

  @override
  String get rel_admin_model => 'Модель';

  @override
  String get rel_admin_signed_in => 'Ви ввійшли';

  @override
  String get rel_admin_not_signed_in => 'Вхід не виконано';

  @override
  String get rel_admin_provider => 'Провайдер';

  @override
  String get rel_admin_apply_to_this_chat => 'Застосувати до цього чату';

  @override
  String get rel_admin_auto => 'Авто';

  @override
  String get rel_admin_chat_completions => 'Доповнення чату';

  @override
  String get rel_admin_codex_responses => 'Відповіді Codex';

  @override
  String get rel_admin_anthropic_messages => 'Повідомлення Anthropic';

  @override
  String get rel_admin_could_not_complete_that_request =>
      'Не вдалося виконати цей запит.';

  @override
  String get rel_admin_confirm => 'Підтвердити';

  @override
  String get rel_admin_providers_and_billing => 'Постачальники й оплата';

  @override
  String get rel_admin_api_keys => 'Ключі API';

  @override
  String get rel_admin_custom_endpoints => 'Власні кінцеві точки';

  @override
  String get rel_admin_provider_accounts => 'Облікові записи постачальників';

  @override
  String get rel_admin_effort_and_speed_presets =>
      'Попередні налаштування зусиль і швидкості';

  @override
  String get rel_admin_delegation => 'Делегування';

  @override
  String get rel_admin_mixture_of_agents => 'Суміш агентів';

  @override
  String get rel_admin_no_provider_keys_were_reported_for_this_profile =>
      'Для цього профілю не повідомлено про ключі постачальників.';

  @override
  String get rel_admin_not_saved => 'Не збережено';

  @override
  String get rel_admin_new_key_value => 'Нове значення ключа';

  @override
  String get rel_admin_provider_key_saved => 'Ключ постачальника збережено.';

  @override
  String get rel_admin_save_key => 'Зберегти ключ';

  @override
  String get rel_admin_clear_provider_key => 'Видалити ключ постачальника';

  @override
  String get rel_admin_provider_key_cleared => 'Ключ постачальника видалено.';

  @override
  String get rel_admin_clear_key => 'Видалити ключ';

  @override
  String get rel_admin_new_endpoint => 'Нова кінцева точка';

  @override
  String get rel_admin_api_key => 'Ключ API';

  @override
  String get rel_admin_leave_blank_to_keep_a_key_this_endpoint_already_has =>
      'Залиште порожнім, щоб зберегти наявний ключ цієї кінцевої точки.';

  @override
  String get rel_admin_reachable => 'Доступна';

  @override
  String get rel_admin_unreachable => 'Недоступна';

  @override
  String get rel_admin_test_endpoint => 'Перевірити кінцеву точку';

  @override
  String get rel_admin_endpoint_saved => 'Кінцеву точку збережено.';

  @override
  String get rel_admin_save_endpoint => 'Зберегти кінцеву точку';

  @override
  String get rel_admin_use_this_endpoint => 'Використати цю кінцеву точку';

  @override
  String
  get rel_admin_make_this_named_endpoint_the_current_model_for_this_profile =>
      'Зробити цю іменовану кінцеву точку поточною моделлю цього профілю?';

  @override
  String get rel_admin_endpoint_is_now_current =>
      'Кінцева точка тепер поточна.';

  @override
  String get rel_admin_use_endpoint => 'Використати кінцеву точку';

  @override
  String get rel_admin_delete_endpoint => 'Видалити кінцеву точку';

  @override
  String get rel_admin_delete_this_named_endpoint_from_the_profile =>
      'Видалити цю іменовану кінцеву точку з профілю?';

  @override
  String get rel_admin_endpoint_deleted => 'Кінцеву точку видалено.';

  @override
  String get rel_admin_signing_in_stays_on_the_provider_sign_in_screen =>
      'Вхід виконується на екрані постачальника. Відключення можливе лише коли шлюз повідомляє, що обліковий запис можна видалити.';

  @override
  String get rel_admin_disconnect_this_provider_account_on_the_gateway =>
      'Відключити цей обліковий запис постачальника на шлюзі?';

  @override
  String get rel_admin_provider_account_disconnected =>
      'Обліковий запис постачальника відключено.';

  @override
  String get rel_admin_disconnect => 'Відключити';

  @override
  String get rel_admin_not_disconnectable => 'Неможливо відключити';

  @override
  String get rel_admin_fast => 'Швидко';

  @override
  String get rel_admin_preset_saved_for_this_model =>
      'Попереднє налаштування для цієї моделі збережено.';

  @override
  String get rel_admin_save_preset => 'Зберегти попереднє налаштування';

  @override
  String get rel_admin_chat_id => 'ID чату';

  @override
  String get rel_admin_apply_preset => 'Застосувати попереднє налаштування';

  @override
  String get rel_admin_set_this_chat_s_effort_and_speed_from_the_saved_preset =>
      'Установити зусилля й швидкість цього чату зі збереженого попереднього налаштування?';

  @override
  String get rel_admin_preset_applied_to_this_chat =>
      'Попереднє налаштування застосовано до цього чату.';

  @override
  String get rel_admin_this_route_sends_the_picked_effort_unchanged =>
      'Цей маршрут передає вибране зусилля без змін.';

  @override
  String get rel_admin_show_route_clamp => 'Показати обмеження маршруту';

  @override
  String get rel_admin_delegation_backend => 'Бекенд делегування';

  @override
  String get rel_admin_delegation_backend_saved =>
      'Бекенд делегування збережено.';

  @override
  String get rel_admin_save_backend => 'Зберегти бекенд';

  @override
  String get rel_admin_max_iterations => 'Максимум ітерацій';

  @override
  String get rel_admin_max_concurrent_children =>
      'Максимум паралельних дочірніх агентів';

  @override
  String get rel_admin_child_timeout_seconds =>
      'Час очікування дочірнього агента в секундах';

  @override
  String get rel_admin_delegation_effort_leave_unchanged =>
      'Зусилля делегування, залишити без змін';

  @override
  String get rel_admin_delegation_limits_saved =>
      'Обмеження делегування збережено.';

  @override
  String get rel_admin_save_limits => 'Зберегти обмеження';

  @override
  String get rel_admin_remove_route => 'Прибрати маршрут';

  @override
  String get rel_admin_route_name => 'Назва маршруту';

  @override
  String get rel_admin_route_provider => 'Постачальник маршруту';

  @override
  String get rel_admin_route_model => 'Модель маршруту';

  @override
  String get rel_admin_route_effort_unchanged => 'Зусилля маршруту без змін';

  @override
  String get rel_admin_add_route => 'Додати маршрут';

  @override
  String get rel_admin_default_route => 'Маршрут за замовчуванням';

  @override
  String get rel_admin_delegation_routes_saved =>
      'Маршрути делегування збережено.';

  @override
  String get rel_admin_save_routes => 'Зберегти маршрути';

  @override
  String get rel_admin_profile_routes_saved => 'Маршрути профілів збережено.';

  @override
  String get rel_admin_save_profile_routes => 'Зберегти маршрути профілів';

  @override
  String get rel_admin_no_mixture_is_loaded => 'Суміш не завантажено.';

  @override
  String get rel_admin_mixture_enabled => 'Суміш увімкнено';

  @override
  String get rel_admin_loud_degraded_references =>
      'Сповіщати про погіршення референсних моделей';

  @override
  String get rel_admin_silent_degraded_references =>
      'Не сповіщати про погіршення референсних моделей';

  @override
  String get rel_admin_aggregator => 'Агрегатор';

  @override
  String get rel_admin_aggregator_provider => 'Постачальник агрегатора';

  @override
  String get rel_admin_aggregator_model => 'Модель агрегатора';

  @override
  String get rel_admin_reference_provider => 'Постачальник референсної моделі';

  @override
  String get rel_admin_reference_model => 'Референсна модель';

  @override
  String get rel_admin_add_reference_model => 'Додати референсну модель';

  @override
  String get rel_admin_mixture_saved => 'Суміш збережено.';

  @override
  String get rel_admin_save_mixture => 'Зберегти суміш';

  @override
  String get rel_admin_credit_purchase_submitted =>
      'Купівлю кредитів надіслано.';

  @override
  String get rel_admin_credit_purchase_settled => 'Купівлю кредитів завершено.';

  @override
  String get rel_admin_credit_and_plan_changes_wait_for_confirmation_a_plan =>
      'Зміни кредитів і планів очікують підтвердження. План із негайним списанням відображається, але тут не підтверджується.';

  @override
  String get rel_admin_buy_credits => 'Купити кредити';

  @override
  String get rel_admin_retry_same_charge => 'Повторити те саме списання';

  @override
  String get rel_admin_retry_the_same_credit_charge_this_does_not_start =>
      'Повторіть те саме списання за кредити. Це не починає другу купівлю.';

  @override
  String get rel_admin_credit_purchases_are_not_available_for_this_account =>
      'Купівля кредитів недоступна для цього облікового запису.';

  @override
  String get rel_admin_auto_reload => 'Автопоповнення';

  @override
  String get rel_admin_read_only_until_this_account_can_charge =>
      'Лише читання, доки обліковий запис не зможе оплачувати.';

  @override
  String get rel_admin_auto_reload_updated => 'Автопоповнення оновлено.';

  @override
  String get rel_admin_keep_going_on_credits => 'Продовжувати за кредити';

  @override
  String get rel_admin_continue_on_credits_when_the_plan_window_is_used_up =>
      'Продовжувати за кредити після вичерпання квоти періоду плану?';

  @override
  String
  get rel_admin_stop_continuing_on_credits_when_the_plan_window_is_used_up =>
      'Припинити продовження за кредити після вичерпання квоти періоду плану?';

  @override
  String get rel_admin_credit_continuation_updated =>
      'Продовження за кредити оновлено.';

  @override
  String get rel_admin_this_plan_change_is_not_confirmed_from_ares =>
      'Ця зміна плану не підтверджується з Ares.';

  @override
  String get rel_admin_this_change_is_scheduled_confirm_to_apply_it =>
      'Цю зміну заплановано. Підтвердьте, щоб застосувати її.';

  @override
  String get rel_admin_preview_plan => 'Попередній перегляд плану';

  @override
  String get rel_admin_schedule_plan_change => 'Запланувати зміну плану';

  @override
  String get rel_admin_plan_change_scheduled => 'Зміну плану заплановано.';

  @override
  String get rel_admin_confirm_scheduled_plan_change =>
      'Підтвердити заплановану зміну плану';

  @override
  String rel_admin_remove_key_confirm(String key) {
    return 'Видалити збережене значення $key із цього профілю?';
  }

  @override
  String rel_admin_current_endpoint(String name) {
    return '$name · поточна';
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
    return 'Відключити $name';
  }

  @override
  String rel_admin_delegation_blocked(String reason) {
    return 'Делегування заблоковано: $reason';
  }

  @override
  String rel_admin_backend_unavailable(String name) {
    return '$name · недоступний';
  }

  @override
  String rel_admin_reference_number(String number) {
    return 'Референсна модель $number';
  }

  @override
  String rel_admin_reload_enable_confirm(String amount, String threshold) {
    return 'Увімкнути автопоповнення та списувати $amount, коли баланс опускається нижче $threshold?';
  }

  @override
  String rel_admin_reload_disable_confirm(String amount, String threshold) {
    return 'Вимкнути автопоповнення? Зараз списується $amount, коли баланс опускається нижче $threshold.';
  }

  @override
  String get rel_admin_this_plan => 'цей план';

  @override
  String rel_admin_plan_confirm(String name) {
    return 'Запланувати $name. Зміну призначено на кінець поточного періоду. Зараз списання не буде.';
  }

  @override
  String rel_admin_plan_confirm_price(String name, String price) {
    return 'Запланувати $name за $price. Зміну призначено на кінець поточного періоду. Зараз списання не буде.';
  }

  @override
  String rel_admin_plan_confirm_when(String name, String when) {
    return 'Запланувати $name. Набуває чинності $when. Зараз списання не буде.';
  }

  @override
  String rel_admin_plan_confirm_price_when(
    String name,
    String price,
    String when,
  ) {
    return 'Запланувати $name за $price. Набуває чинності $when. Зараз списання не буде.';
  }

  @override
  String rel_admin_balance(String amount) {
    return 'Баланс $amount';
  }

  @override
  String rel_admin_buy_confirm(String amount) {
    return 'Списати \$$amount через спосіб оплати цього облікового запису Nous. Будуть витрачені реальні гроші.';
  }

  @override
  String rel_admin_reload_portal(String url) {
    return 'Змініть автопоповнення на порталі: $url';
  }

  @override
  String rel_admin_team_portal(String url) {
    return 'Підписки команди змінюються на порталі: $url';
  }

  @override
  String get rel_admin_effort_none => 'немає';

  @override
  String get rel_admin_effort_minimal => 'мінімальний';

  @override
  String get rel_admin_effort_low => 'низький';

  @override
  String get rel_admin_effort_medium => 'середній';

  @override
  String get rel_admin_effort_high => 'високий';

  @override
  String get rel_admin_effort_xhigh => 'дуже високий';

  @override
  String get rel_admin_effort_max => 'максимальний';

  @override
  String get rel_admin_effort_ultra => 'надвисокий';

  @override
  String get rel_admin_auto_lower => 'Авто';

  @override
  String get rel_admin_create => 'Створити';

  @override
  String get rel_admin_prompt => 'Запит';

  @override
  String get rel_admin_new_profile_id => 'ID нового профілю';

  @override
  String get rel_admin_this_operation_is_unavailable_on_this_gateway =>
      'Ця операція недоступна на цьому шлюзі.';

  @override
  String get rel_admin_access_denied_by_the_gateway =>
      'Шлюз відмовив у доступі.';

  @override
  String get rel_admin_connection_changed_reopen_profiles =>
      'Підключення змінилося. Відкрийте профілі знову.';

  @override
  String
  get rel_admin_invalid_input_or_gateway_response_check_the_target_before =>
      'Неприпустиме введення або відповідь шлюзу. Перевірте ціль перед повторною спробою.';

  @override
  String get rel_admin_could_not_verify_the_result_refresh_the_target_before =>
      'Не вдалося перевірити результат. Оновіть ціль перед повторною спробою.';

  @override
  String get rel_admin_edit_soul_md => 'Редагувати SOUL.md';

  @override
  String get rel_admin_persona => 'Персона';

  @override
  String get rel_admin_persona_saved => 'Персону збережено.';

  @override
  String get rel_admin_not_set => 'не задано';

  @override
  String get rel_admin_enabled => 'Увімкнено';

  @override
  String get rel_admin_keys_to_remove_comma_separated =>
      'Ключі для видалення (через кому)';

  @override
  String get rel_admin_saved_and_applied_by_the_gateway =>
      'Збережено й застосовано шлюзом.';

  @override
  String get rel_admin_saved_a_gateway_restart_may_be_required =>
      'Збережено. Може знадобитися перезапуск шлюзу.';

  @override
  String get rel_admin_create_signed_route => 'Створити підписаний маршрут';

  @override
  String get rel_admin_route_id => 'ID маршруту';

  @override
  String get rel_admin_signature => 'Підпис';

  @override
  String get rel_admin_events_comma_separated => 'Події (через кому)';

  @override
  String get rel_admin_delivery_target => 'Ціль доставки';

  @override
  String get rel_admin_skills_comma_separated => 'Навички (через кому)';

  @override
  String get rel_admin_delivery_mode => 'Режим доставки';

  @override
  String get rel_admin_delivery_chat_id_optional =>
      'ID чату доставки (необов’язково)';

  @override
  String get rel_admin_hide_signing_secret => 'Приховати секрет підпису';

  @override
  String get rel_admin_reveal_signing_secret => 'Показати секрет підпису';

  @override
  String get rel_admin_edit_persona => 'Редагувати персону';

  @override
  String get rel_admin_portable_profile_bundle => 'Переносний пакет профілю';

  @override
  String get rel_admin_clone_profile => 'Клонувати профіль';

  @override
  String get rel_admin_rename_display_label =>
      'Перейменувати відображувану мітку';

  @override
  String get rel_admin_rename_profile => 'Перейменувати профіль';

  @override
  String get rel_admin_new_name => 'Нова назва';

  @override
  String get rel_admin_rename_verified => 'Перейменування перевірено.';

  @override
  String get rel_admin_delete_profile => 'Видалити профіль';

  @override
  String get rel_admin_profile_id_to_delete => 'ID профілю для видалення';

  @override
  String get rel_admin_profile_deleted => 'Профіль видалено.';

  @override
  String
  get rel_admin_profile_deleted_server_identity_cleanup_is_still_pending =>
      'Профіль видалено. Очищення ідентифікаційних даних сервера ще очікується.';

  @override
  String get rel_admin_export_profile_archive => 'Експортувати архів профілю';

  @override
  String get rel_admin_import_profile_archive => 'Імпортувати архів профілю';

  @override
  String get rel_admin_import_a_trusted_profile =>
      'Імпортувати довірений профіль';

  @override
  String get rel_admin_absolute_archive_path_on_gateway =>
      'Абсолютний шлях до архіву на шлюзі';

  @override
  String get rel_admin_messaging_channels => 'Канали повідомлень';

  @override
  String get rel_admin_dm_pairing_requests =>
      'Запити сполучення в особистих повідомленнях';

  @override
  String get rel_admin_no_pending_or_approved_users =>
      'Немає користувачів, що очікують або схвалені.';

  @override
  String get rel_admin_legacy_pairing_no_verifiable_request_id_ask_the_user =>
      'Застаріле сполучення: немає перевірного ID запиту. Попросіть користувача виконати сполучення знову.';

  @override
  String get rel_admin_pairing_change_verified =>
      'Зміну сполучення перевірено.';

  @override
  String get rel_admin_create_telegram_bot_by_qr =>
      'Створити бота Telegram через QR';

  @override
  String get rel_admin_create_telegram_bot => 'Створити бота Telegram';

  @override
  String get rel_admin_bot_name => 'Назва бота';

  @override
  String get rel_admin_telegram_bot_creation_qr_code =>
      'QR-код створення бота Telegram';

  @override
  String get rel_admin_check_telegram_pairing =>
      'Перевірити сполучення Telegram';

  @override
  String get rel_admin_waiting_for_telegram => 'Очікування Telegram.';

  @override
  String get rel_admin_apply_telegram_bot => 'Застосувати бота Telegram';

  @override
  String get rel_admin_allowed_numeric_user_ids =>
      'Дозволені числові ID користувачів';

  @override
  String get rel_admin_saved_restart_still_required =>
      'Збережено. Перезапуск усе ще потрібен.';

  @override
  String get rel_admin_saved_gateway_restart_requested =>
      'Збережено; запитано перезапуск шлюзу.';

  @override
  String get rel_admin_cancel_telegram_setup =>
      'Скасувати налаштування Telegram';

  @override
  String get rel_admin_inbound_webhooks => 'Вхідні вебхуки';

  @override
  String get rel_admin_enable_webhook_service => 'Увімкнути службу вебхуків';

  @override
  String get rel_admin_enable_webhooks => 'Увімкнути вебхуки';

  @override
  String get rel_admin_enabled_restart_still_required =>
      'Увімкнено. Перезапуск усе ще потрібен.';

  @override
  String get rel_admin_enabled_restart_requested =>
      'Увімкнено; запитано перезапуск.';

  @override
  String get rel_admin_route_change_verified => 'Зміну маршруту перевірено.';

  @override
  String get rel_admin_delete_route => 'Видалити маршрут';

  @override
  String get rel_admin_disable_route => 'Вимкнути маршрут';

  @override
  String get rel_admin_enable_route => 'Увімкнути маршрут';

  @override
  String get rel_admin_back_up_entire_agent_home =>
      'Створити резервну копію всього домашнього каталогу агента';

  @override
  String get rel_admin_transfer_to_a_cloud_agent => 'Перенести до агента Cloud';

  @override
  String get rel_admin_check_backup_progress =>
      'Перевірити хід резервного копіювання';

  @override
  String get rel_admin_save_backup_to_this_device =>
      'Зберегти резервну копію на цьому пристрої';

  @override
  String get rel_admin_save_sensitive_full_home_archive =>
      'Зберегти конфіденційний архів усього домашнього каталогу';

  @override
  String get rel_admin_save_cancelled => 'Збереження скасовано.';

  @override
  String get rel_admin_backup_saved => 'Резервну копію збережено.';

  @override
  String get rel_admin_up_to_32_mib_larger_archives_remain_on_the_gateway =>
      'До 32 MiB. Більші архіви залишаються на шлюзі.';

  @override
  String rel_admin_persona_scope(String scope) {
    return 'Зберегти персону для $scope.';
  }

  @override
  String rel_admin_configure_channel(String name) {
    return 'Налаштувати $name';
  }

  @override
  String rel_admin_channel_warning(String scope) {
    return 'Застосовується до $scope. Порожнє поле зберігає поточне значення. Для видалення значення вкажіть його ключ нижче.';
  }

  @override
  String rel_admin_hook_warning(String scope) {
    return 'Застосовується до $scope. Використовуйте унікальну назву. Шлюз створює секрет підпису. Якщо інший оператор одночасно створить цю назву, хост може замінити цей маршрут.';
  }

  @override
  String rel_admin_hook_created(String url) {
    return 'Створено: $url. Збережіть секрет підпису перед виходом.';
  }

  @override
  String rel_admin_clone_warning(String scope) {
    return 'Скопіювати налаштування, навички, персону та, можливо, облікові дані постачальників із $scope. Токени повідомлень не запитуються.';
  }

  @override
  String rel_admin_cloned(String source, String destination) {
    return '$source клоновано в $destination.';
  }

  @override
  String rel_admin_rename_target(String name) {
    return 'Перейменувати $name';
  }

  @override
  String rel_admin_rename_label_warning(String scope) {
    return 'Змінити відображувану мітку $scope. ID залишиться default.';
  }

  @override
  String rel_admin_rename_warning(String scope) {
    return 'Перейменувати $scope на сервері. Запущений шлюз може зупинитися.';
  }

  @override
  String rel_admin_delete_target(String name) {
    return 'Видалити $name';
  }

  @override
  String rel_admin_delete_profile_warning(String scope) {
    return 'Назавжди видалити $scope, включно із сеансами й обліковими даними. Введіть точний ID профілю.';
  }

  @override
  String rel_admin_export_target(String name) {
    return 'Експортувати $name';
  }

  @override
  String rel_admin_export_warning(String scope) {
    return 'Створити .tar.gz на $scope. Відомі сховища облікових даних виключаються, але приватні дані можуть залишитися. Перевірте перед поширенням.';
  }

  @override
  String rel_admin_archive_on(String gateway, String path) {
    return 'Архів на $gateway: $path';
  }

  @override
  String rel_admin_import_warning(String gateway) {
    return 'Використовуйте перевірений .tar.gz, що вже є на $gateway. Він може містити плагіни, скрипти й розклади. Потрібен новий ID профілю.';
  }

  @override
  String rel_admin_imported(String name) {
    return 'Імпортовано: $name.';
  }

  @override
  String rel_admin_approve_user(String user) {
    return 'Схвалити $user';
  }

  @override
  String rel_admin_revoke_user(String user) {
    return 'Відкликати $user';
  }

  @override
  String rel_admin_allow_pair(String platform, String scope) {
    return '$platform на $scope: дозволити цьому користувачу доступ до повідомлень.';
  }

  @override
  String rel_admin_remove_pair(String platform, String scope) {
    return '$platform на $scope: видалити доступ цього користувача до повідомлень.';
  }

  @override
  String rel_admin_telegram_start(String scope) {
    return 'Почати сполучення Telegram на $scope через службу налаштування шлюзу.';
  }

  @override
  String rel_admin_expires(String time) {
    return 'Спливає: $time';
  }

  @override
  String rel_admin_telegram_apply(String bot, String scope) {
    return 'Увімкнути @$bot на $scope і спробувати перезапустити шлюз. Лише перелічені користувачі зможуть писати йому.';
  }

  @override
  String rel_admin_hooks_enable(String scope) {
    return 'Увімкнути вхідні вебхуки на $scope і спробувати перезапустити шлюз.';
  }

  @override
  String rel_admin_disable_target(String name) {
    return 'Вимкнути $name';
  }

  @override
  String rel_admin_enable_target(String name) {
    return 'Увімкнути $name';
  }

  @override
  String rel_admin_hook_change(String name, String scope) {
    return 'Змінити саме $name на $scope.';
  }

  @override
  String rel_admin_backup_warning(String gateway) {
    return 'Це не резервна копія налаштувань Ares. Збережіть усі профілі, сеанси й облікові дані на $gateway. Архів містить конфіденційні дані.';
  }

  @override
  String rel_admin_backup_started(String gateway) {
    return 'Резервне копіювання розпочато на $gateway.';
  }

  @override
  String rel_admin_backup_verified(String gateway, String path) {
    return 'Резервну копію перевірено на $gateway: $path';
  }

  @override
  String rel_admin_backup_running(String gateway) {
    return 'Резервне копіювання ще триває на $gateway.';
  }

  @override
  String get rel_admin_choice_yes => 'так';

  @override
  String get rel_admin_choice_no => 'ні';

  @override
  String get rel_admin_choice_generic => 'загальна';

  @override
  String get rel_admin_choice_log => 'журнал';

  @override
  String get rel_admin_choice_email => 'електронна пошта';

  @override
  String get rel_admin_choice_github_comment => 'коментар GitHub';

  @override
  String get rel_admin_choice_agent => 'Агент обробляє подію';

  @override
  String get rel_admin_choice_direct => 'Пряма доставка';

  @override
  String get rel_admin_configured => 'налаштовано';

  @override
  String get rel_admin_state_pending_restart => 'очікує перезапуску';

  @override
  String get rel_admin_state_unknown => 'невідомо';

  @override
  String get rel_admin_state_connected => 'підключено';

  @override
  String get rel_admin_state_disconnected => 'відключено';

  @override
  String get rel_admin_state_disabled => 'вимкнено';

  @override
  String get rel_admin_state_enabled => 'увімкнено';

  @override
  String get rel_admin_state_running => 'працює';

  @override
  String get rel_admin_state_stopped => 'зупинено';

  @override
  String get rel_admin_state_error => 'помилка';

  @override
  String get rel_admin_state_not_configured => 'не налаштовано';

  @override
  String get rel_admin_state_startup_failed => 'помилка запуску';

  @override
  String get rel_admin_state_gateway_stopped => 'шлюз зупинено';

  @override
  String get rel_admin_state_connecting => 'підключення';

  @override
  String get rel_admin_state_retrying => 'повторна спроба';

  @override
  String get rel_admin_state_fatal => 'критична помилка';

  @override
  String get rel_admin_unsupported_or_oversized_profile_archive =>
      'Непідтримуваний або завеликий архів профілю.';

  @override
  String get rel_admin_current_layout => 'Поточне компонування';

  @override
  String get rel_admin_one_pane => 'Одна панель';

  @override
  String get rel_admin_stacked => 'Вертикально';

  @override
  String get rel_admin_side_by_side => 'Поруч';

  @override
  String get rel_admin_no_supported_appearance_in_this_profile =>
      'У цьому профілі немає підтримуваного оформлення.';

  @override
  String get rel_admin_review_appearance_saved_with_this_profile =>
      'Переглянути оформлення, збережене з цим профілем';

  @override
  String get rel_admin_applies_only_to_this_named_profile_on_this_device =>
      'Застосовується лише до цього іменованого профілю на цьому пристрої. Імпортоване компонування починається з порожніх панелей; виберіть чати самі.';

  @override
  String get rel_admin_apply_to_this_profile_on_this_device =>
      'Застосувати до цього профілю на цьому пристрої';

  @override
  String get rel_admin_export_prepares_a_tar_gz_on_the_gateway_review =>
      'Експорт готує .tar.gz на шлюзі. Перегляньте переносні файли перед збереженням копії тут. Імпорт відкриває локальний архів для перевірки; саме відкриття нічого не завантажує.';

  @override
  String get rel_admin_prepare_profile_export => 'Підготувати експорт профілю';

  @override
  String get rel_admin_open_tar_gz_from_this_device =>
      'Відкрити .tar.gz із цього пристрою';

  @override
  String get rel_admin_only_selected_text_files_travel_review_for_secrets_and =>
      'Переносяться лише вибрані текстові файли. Перевірте їх на секрети й приватні дані. Конфігурація, навички й розклади можуть змінити поведінку нового профілю.';

  @override
  String get rel_admin_include_this_reviewed_file =>
      'Додати цей перевірений файл';

  @override
  String get rel_admin_apply_appearance_to_the_new_profile_on_this_device =>
      'Застосувати оформлення до нового профілю на цьому пристрої';

  @override
  String
  get rel_admin_imports_colours_and_pane_sizes_never_chats_tools_or_session_ids =>
      'Імпортує кольори й розміри панелей, але не чати, інструменти чи ID сеансів.';

  @override
  String
  get rel_admin_the_gateway_retains_a_private_staged_copy_import_creates =>
      'Шлюз зберігає приватну проміжну копію. Імпорт створює новий профіль і не замінює наявний.';

  @override
  String get rel_admin_appearance_not_applied_the_gateway_did_not_confirm_the =>
      ' Оформлення не застосовано: шлюз не підтвердив перевірене накладання.';

  @override
  String get rel_admin_appearance_applied_on_this_device =>
      ' Оформлення застосовано на цьому пристрої.';

  @override
  String get rel_admin_appearance_was_not_saved_on_this_device =>
      ' Оформлення не збережено на цьому пристрої.';

  @override
  String get rel_admin_save_reviewed_profile_bundle =>
      'Зберегти перевірений пакет профілю';

  @override
  String get rel_admin_profile_bundle_saved => 'Пакет профілю збережено.';

  @override
  String get rel_admin_import_selected_files => 'Імпортувати вибрані файли';

  @override
  String get rel_admin_save_selected_files_to_device =>
      'Зберегти вибрані файли на пристрій';

  @override
  String rel_admin_layout_first_pane(String layout, String percent) {
    return '$layout · $percent% перша панель';
  }

  @override
  String rel_admin_appearance_summary(String skin, String mode, String layout) {
    return 'Тема: $skin · Режим: $mode · $layout';
  }

  @override
  String rel_admin_appearance_applied(String gateway, String profile) {
    return 'Оформлення застосовано до $gateway / $profile.';
  }

  @override
  String rel_admin_bundle_summary(
    String profile,
    String count,
    String omitted,
  ) {
    return 'Пакет: $profile · файлів для перевірки: $count · пропущено: $omitted';
  }

  @override
  String rel_admin_imported_on(String name, String gateway) {
    return '$name імпортовано на $gateway.';
  }

  @override
  String get rel_admin_unchanged => 'без змін';

  @override
  String get rel_admin_mode_system => 'системний';

  @override
  String get rel_admin_mode_light => 'світлий';

  @override
  String get rel_admin_mode_dark => 'темний';

  @override
  String get rel_admin_skin_classic => 'класична';

  @override
  String get rel_admin_skin_midnight => 'північ';

  @override
  String get rel_admin_skin_ember => 'жар';

  @override
  String get rel_admin_skin_mono => 'монохромна';

  @override
  String get rel_admin_skin_cyberpunk => 'кіберпанк';

  @override
  String get rel_admin_skin_slate => 'сланець';

  @override
  String get rel_admin_no_available_cloud_agents_in_this_account =>
      'У цьому обліковому записі немає доступних агентів Cloud.';

  @override
  String get rel_admin_the_previous_undo_receipt_could_not_be_verified_no =>
      'Не вдалося перевірити попередню квитанцію скасування. Змін не було.';

  @override
  String get rel_admin_transfer_to_cloud => 'Перенести до Cloud';

  @override
  String
  get rel_admin_connection_changed_leave_this_page_a_restore_already_submitted =>
      'Підключення змінилося. Залиште цю сторінку. Уже надіслане відновлення може тривати.';

  @override
  String get rel_admin_find_my_cloud_agents => 'Знайти моїх агентів Cloud';

  @override
  String
  get rel_admin_undo_replaces_the_destination_with_its_pre_transfer_backup =>
      'Скасування замінює вміст призначення резервною копією до перенесення.';

  @override
  String get rel_admin_replace_this_cloud_agent_with_the_entire_source_home =>
      'Замініть цього агента Cloud усім домашнім каталогом джерела, включно з обліковими даними, розмовами й файлами. Джерело не видаляється. Боти вхідних повідомлень вимикаються.';

  @override
  String get rel_admin_type_destination_agent_id =>
      'Введіть ID агента призначення';

  @override
  String
  get rel_admin_could_not_retain_the_local_undo_receipt_keep_this_page_open =>
      'Не вдалося зберегти локальну квитанцію скасування. Залиште сторінку відкритою.';

  @override
  String get rel_admin_undo_transfer => 'Скасувати перенесення';

  @override
  String get rel_admin_replace_cloud_agent => 'Замінити агента Cloud';

  @override
  String
  get rel_admin_local_undo_receipt_forgotten_no_remote_backup_was_removed =>
      'Локальну квитанцію скасування забуто. Віддалені резервні копії не видалено.';

  @override
  String get rel_admin_forget_local_undo_receipt_only =>
      'Забути лише локальну квитанцію скасування';

  @override
  String get rel_admin_stop_before_restore => 'Зупинити до відновлення';

  @override
  String get rel_admin_do_not_close_this_page_restore_runs_on_the =>
      'Не закривайте сторінку. Відновлення виконується на боці призначення, його не можна скасувати.';

  @override
  String get rel_admin_files_restored_destination_gateway_needs_attention =>
      'Файли відновлено; шлюз призначення потребує уваги.';

  @override
  String rel_admin_transfer_sign_in(String origin) {
    return 'Увійдіть рівно в одне збережене підключення Ares для $origin, потім поверніться сюди.';
  }

  @override
  String rel_admin_transfer_source(String gateway, String profile) {
    return 'Джерело: $gateway / $profile';
  }

  @override
  String rel_admin_transfer_destination(String name, String origin) {
    return 'Призначення: $name · $origin / default';
  }

  @override
  String rel_admin_agent_id(String id) {
    return 'ID агента: $id';
  }

  @override
  String rel_admin_transfer_status(String phase) {
    return 'Стан: $phase';
  }

  @override
  String rel_admin_copied_percent(String percent) {
    return 'Скопійовано $percent%';
  }

  @override
  String rel_admin_undo_point(String path) {
    return 'Точка скасування на боці призначення: $path';
  }

  @override
  String rel_admin_messaging_disabled(String channels) {
    return 'Повідомлення вимкнено: $channels';
  }

  @override
  String get rel_admin_phase_prepared => 'підготовлено';

  @override
  String get rel_admin_phase_backup => 'резервне копіювання';

  @override
  String get rel_admin_phase_upload => 'завантаження';

  @override
  String get rel_admin_phase_restore => 'відновлення';

  @override
  String get rel_admin_phase_finished => 'завершено';

  @override
  String get rel_admin_phase_failed => 'помилка';

  @override
  String get rel_admin_phase_undo => 'скасування';

  @override
  String get rel_admin_phase_undone => 'скасовано';

  @override
  String rel_ops_cap_install_blocked(String verdict, String detail) {
    return 'Встановлення заблоковано ($verdict): $detail';
  }

  @override
  String rel_ops_cap_scan_confirm(String verdict, String requested) {
    return 'Результат перевірки: $verdict. Підтвердьте $requested перед встановленням.';
  }

  @override
  String rel_ops_cap_install_unconfirmed(String requested) {
    return 'Шлюз не підтвердив встановлення $requested.';
  }

  @override
  String rel_ops_cap_edit_skill(String name) {
    return 'Редагувати $name';
  }

  @override
  String rel_ops_cap_archive_skill(String name) {
    return 'Архівувати $name?';
  }

  @override
  String rel_ops_cap_archive_explanation(String command) {
    return 'Навичку буде архівовано, і її можна буде відновити командою $command.';
  }

  @override
  String rel_ops_cap_install_anyway(String name) {
    return 'Усе одно встановити $name';
  }

  @override
  String rel_ops_cap_install_despite_scan(String name) {
    return 'Встановити $name попри результат перевірки?';
  }

  @override
  String rel_ops_cap_scan_warning(String name) {
    return 'Перевірка безпеки заблокувала $name. Це підтвердження стосується лише $name.';
  }

  @override
  String rel_ops_cap_accept_scan_warning(String name) {
    return 'Прийняття можливостей не скасовує результат перевірки $name.';
  }

  @override
  String rel_ops_cap_review_scan(String name) {
    return 'Переглянути результат перевірки $name';
  }

  @override
  String rel_ops_cap_desktop_grants(String description) {
    return '$description\nДозволи на папки та скрипти попереднього перегляду залишаються в застосунку Desktop на тому комп’ютері. Видалення плагіна тут не відкликає ці локальні дозволи.';
  }

  @override
  String rel_ops_cap_remove_plugin(String name) {
    return 'Видалити $name?';
  }

  @override
  String rel_ops_cap_probe_result(String name, String tools) {
    return 'Перевірка з’єднання $name: $tools';
  }

  @override
  String rel_ops_cap_save_tool_grants_for(String connector) {
    return 'Зберегти дозволи інструментів для $connector';
  }

  @override
  String rel_ops_cap_backends_for(String name) {
    return 'Серверні модулі для $name';
  }

  @override
  String rel_ops_cap_use_backend_confirmation(String name) {
    return 'Використовувати $name?';
  }

  @override
  String rel_ops_cap_unlock_source(String name) {
    return 'Розблокувати $name';
  }

  @override
  String get rel_ops_cap_capabilities => 'Можливості';

  @override
  String get rel_ops_cap_plugins => 'Плагіни';

  @override
  String get rel_ops_cap_connectors => 'Конектори';

  @override
  String get rel_ops_cap_backends => 'Серверні модулі';

  @override
  String get rel_ops_cap_save_skill => 'Зберегти навичку';

  @override
  String get rel_ops_cap_archive => 'Архівувати';

  @override
  String get rel_ops_cap_hub_identifier => 'Ідентифікатор Hub';

  @override
  String get rel_ops_cap_install => 'Встановити';

  @override
  String get rel_ops_cap_update_all => 'Оновити все';

  @override
  String get rel_ops_cap_unlock => 'Розблокувати';

  @override
  String get rel_ops_cap_lock => 'Заблокувати';

  @override
  String get rel_ops_cap_this_update_adds_capabilities_nothing_changed_yet =>
      'Це оновлення додає можливості. Поки що нічого не змінено.';

  @override
  String get rel_ops_cap_the_scan_blocked_this_plugin =>
      'Перевірка заблокувала цей плагін.';

  @override
  String get rel_ops_cap_the_plugin_was_not_changed => 'Плагін не змінено.';

  @override
  String get rel_ops_cap_repository => 'Репозиторій';

  @override
  String get rel_ops_cap_install_plugin => 'Встановити плагін';

  @override
  String get rel_ops_cap_update_plugins => 'Оновити плагіни';

  @override
  String get rel_ops_cap_accept_capabilities => 'Прийняти можливості';

  @override
  String get rel_ops_cap_update => 'Оновити';

  @override
  String get rel_ops_cap_remove_desktop_half => 'Видалити настільний компонент';

  @override
  String get rel_ops_cap_server_name => 'Назва сервера';

  @override
  String get rel_ops_cap_command => 'Команда';

  @override
  String get rel_ops_cap_http_url => 'HTTP URL';

  @override
  String get rel_ops_cap_add_server => 'Додати сервер';

  @override
  String get rel_ops_cap_probe => 'Перевірити з’єднання';

  @override
  String get rel_ops_cap_probe_failed => 'Не вдалося перевірити з’єднання.';

  @override
  String get rel_ops_cap_logs => 'Журнали';

  @override
  String get rel_ops_cap_mcp_log => 'Журнал MCP';

  @override
  String get rel_ops_cap_connector => 'Конектор';

  @override
  String get rel_ops_cap_account_alias => 'Псевдонім облікового запису';

  @override
  String get rel_ops_cap_link_account => 'Прив’язати обліковий запис';

  @override
  String get rel_ops_cap_remove_account => 'Видалити обліковий запис';

  @override
  String get rel_ops_cap_tool_connector => 'Конектор інструментів';

  @override
  String get rel_ops_cap_load_tools => 'Завантажити інструменти';

  @override
  String get rel_ops_cap_save_tool_grants => 'Зберегти дозволи інструментів';

  @override
  String
  get rel_ops_cap_this_policy_has_no_member_revision_so_tool_grants_stay_unchanged =>
      'Ця політика не має ревізії учасника, тому дозволи інструментів залишаються незмінними.';

  @override
  String get rel_ops_cap_active => 'Активний';

  @override
  String get rel_ops_cap_use => 'Використовувати';

  @override
  String get rel_ops_cap_run_setup => 'Запустити налаштування';

  @override
  String get rel_ops_cap_terminal_backends => 'Серверні модулі термінала';

  @override
  String get rel_ops_cap_this_changes_the_terminal_backend_for_this_profile =>
      'Це змінить серверний модуль термінала для цього профілю.';

  @override
  String get rel_ops_cap_use_backend => 'Використовувати модуль';

  @override
  String get rel_ops_cap_select => 'Вибрати';

  @override
  String get rel_ops_cap_browser_vault => 'Сховище браузера';

  @override
  String
  get rel_ops_cap_saved_site_logins_addresses_and_cards_passwords_stay_in_the_secure_fields_and_are_not_listed_here =>
      'Збережені дані входу на сайти, адреси й картки. Паролі залишаються в захищених полях і тут не відображаються.';

  @override
  String get rel_ops_cap_remove_saved_item => 'Видалити збережений елемент';

  @override
  String get rel_ops_cap_delete_this_item => 'Видалити цей елемент?';

  @override
  String get rel_ops_cap_unlocked => 'Розблоковано';

  @override
  String get rel_ops_cap_locked => 'Заблоковано';

  @override
  String get rel_ops_cap_not_detected => 'Не виявлено';

  @override
  String get rel_ops_cap_master_password => 'Майстер-пароль';

  @override
  String get rel_ops_cap_login => 'Дані входу';

  @override
  String get rel_ops_cap_address => 'Адреса';

  @override
  String get rel_ops_cap_card => 'Картка';

  @override
  String get rel_ops_cap_label => 'Мітка';

  @override
  String get rel_ops_cap_site_origin => 'Джерело сайту';

  @override
  String get rel_ops_cap_identifier => 'Ідентифікатор';

  @override
  String get rel_ops_cap_password => 'Пароль';

  @override
  String get rel_ops_cap_authenticator_key => 'Ключ автентифікатора';

  @override
  String get rel_ops_cap_street => 'Вулиця';

  @override
  String get rel_ops_cap_city => 'Місто';

  @override
  String get rel_ops_cap_postal_code => 'Поштовий індекс';

  @override
  String get rel_ops_cap_country => 'Країна';

  @override
  String get rel_ops_cap_name_on_card => 'Ім’я на картці';

  @override
  String get rel_ops_cap_card_number => 'Номер картки';

  @override
  String get rel_ops_cap_expiry_month => 'Місяць завершення дії';

  @override
  String get rel_ops_cap_expiry_year => 'Рік завершення дії';

  @override
  String get rel_ops_cap_security_code => 'Код безпеки';

  @override
  String get rel_ops_cap_this_gateway_has_no_shared_metrics_consent_method =>
      'Цей шлюз не має методу отримання згоди на передавання спільних метрик.';

  @override
  String get rel_ops_cap_agent_policy => 'Політика агента';

  @override
  String get rel_ops_cap_loading_policy => 'Завантаження політики';

  @override
  String get rel_ops_cap_approval_timeout => 'Час очікування схвалення';

  @override
  String get rel_ops_cap_confirm_mcp_reloads =>
      'Підтверджувати перезавантаження MCP';

  @override
  String get rel_ops_cap_command_allowlist => 'Список дозволених команд';

  @override
  String get rel_ops_cap_file_checkpoints => 'Контрольні точки файлів';

  @override
  String get rel_ops_cap_checkpoint_limit => 'Ліміт контрольних точок';

  @override
  String get rel_ops_cap_browser_private_urls => 'Приватні URL у браузері';

  @override
  String get rel_ops_cap_use_my_real_browser_profile =>
      'Використовувати мій справжній профіль браузера';

  @override
  String get rel_ops_cap_save_policy => 'Зберегти політику';

  @override
  String get rel_ops_cap_shared_metrics_for_this_profile =>
      'Спільні метрики цього профілю';

  @override
  String get rel_ops_cap_send_shared_metrics => 'Надсилати спільні метрики';

  @override
  String get rel_ops_cap_error_enter_a_label => 'Введіть мітку.';

  @override
  String get rel_ops_cap_error_enter_a_valid_url_like_https_example_com =>
      'Введіть коректний URL, наприклад https://example.com.';

  @override
  String get rel_ops_cap_error_enter_the_identifier_and_password =>
      'Введіть ідентифікатор і пароль.';

  @override
  String
  get rel_ops_cap_error_enter_the_card_name_number_expiry_and_security_code =>
      'Введіть ім’я на картці, номер, термін дії та код безпеки.';

  @override
  String get rel_ops_cap_error_enter_the_street_city_postal_code_and_country =>
      'Введіть вулицю, місто, поштовий індекс і країну.';

  @override
  String
  get rel_ops_cap_error_the_gateway_returned_a_response_that_could_not_be_read =>
      'Шлюз повернув відповідь, яку не вдалося прочитати.';

  @override
  String rel_ops_cap_error_the_gateway_refused_the_request_status(
    int statusCode,
  ) {
    return 'Шлюз відхилив запит ($statusCode).';
  }

  @override
  String
  rel_ops_cap_error_this_connection_has_no_gateway_socket_so_method_is_unavailable(
    String method,
  ) {
    return 'Це з’єднання не має сокета шлюзу, тому $method недоступний.';
  }

  @override
  String get rel_ops_cap_error_choose_a_skill => 'Виберіть навичку.';

  @override
  String get rel_ops_cap_error_the_skill_text_was_not_returned =>
      'Текст навички не отримано.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_saved =>
      'Навичку не збережено.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_archived =>
      'Навичку не архівовано.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_installed =>
      'Навичку не встановлено.';

  @override
  String get rel_ops_cap_error_skill_updates_did_not_start =>
      'Оновлення навичок не розпочалося.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_removed =>
      'Навичку не видалено.';

  @override
  String get rel_ops_cap_error_enter_a_skill_or_plugin_identifier =>
      'Введіть ідентифікатор навички або плагіна.';

  @override
  String get rel_ops_cap_error_choose_a_plugin => 'Виберіть плагін.';

  @override
  String get rel_ops_cap_error_the_plugin_was_not_removed =>
      'Плагін не видалено.';

  @override
  String get rel_ops_cap_error_the_desktop_half_was_not_removed =>
      'Настільний компонент не видалено.';

  @override
  String
  get rel_ops_cap_error_this_gateway_did_not_give_the_plugin_a_stable_key =>
      'Цей шлюз не призначив плагіну стабільний ключ.';

  @override
  String get rel_ops_cap_error_the_plugin_was_not_changed =>
      'Плагін не змінено.';

  @override
  String get rel_ops_cap_error_choose_a_server => 'Виберіть сервер.';

  @override
  String get rel_ops_cap_error_name_the_server => 'Укажіть назву сервера.';

  @override
  String get rel_ops_cap_error_give_the_server_a_command_or_an_http_s_url =>
      'Укажіть для сервера команду або URL http(s).';

  @override
  String get rel_ops_cap_error_choose_a_toolset =>
      'Виберіть набір інструментів.';

  @override
  String get rel_ops_cap_error_tool_backend_status_was_not_returned =>
      'Стан серверного модуля інструментів не отримано.';

  @override
  String get rel_ops_cap_error_choose_a_provider => 'Виберіть постачальника.';

  @override
  String get rel_ops_cap_error_this_provider_has_no_setup_action =>
      'Цей постачальник не має дії налаштування.';

  @override
  String get rel_ops_cap_error_setup_did_not_start =>
      'Налаштування не розпочалося.';

  @override
  String get rel_ops_cap_error_choose_a_terminal_backend =>
      'Виберіть серверний модуль термінала.';

  @override
  String get rel_ops_cap_error_name_the_connector => 'Укажіть назву конектора.';

  @override
  String get rel_ops_cap_error_choose_an_account => 'Виберіть обліковий запис.';

  @override
  String
  get rel_ops_cap_error_reload_the_connector_policy_before_changing_tool_grants =>
      'Перезавантажте політику конектора перед зміною дозволів інструментів.';

  @override
  String get rel_ops_cap_error_choose_an_item => 'Виберіть елемент.';

  @override
  String get rel_ops_cap_error_choose_a_source => 'Виберіть джерело.';

  @override
  String get rel_ops_cap_error_enter_the_master_password =>
      'Введіть майстер-пароль.';

  @override
  String get rel_ops_cap_error_gateway_config_was_not_returned =>
      'Конфігурацію шлюзу не отримано.';

  @override
  String get rel_ops_cap_error_choose_a_known_approval_mode =>
      'Виберіть відомий режим схвалення.';

  @override
  String get rel_ops_cap_error_use_a_positive_limit =>
      'Використовуйте додатний ліміт.';

  @override
  String get rel_ops_cap_error_the_policy_was_not_saved =>
      'Політику не збережено.';

  @override
  String get rel_ops_cap_value_manual => 'вручну';

  @override
  String get rel_ops_cap_value_smart => 'інтелектуальний';

  @override
  String get rel_ops_cap_value_off => 'вимкнено';

  @override
  String get rel_ops_cap_value_safe => 'безпечно';

  @override
  String get rel_ops_cap_value_caution => 'обережно';

  @override
  String get rel_ops_cap_value_dangerous => 'небезпечно';

  @override
  String get rel_ops_cap_value_blocked => 'заблоковано';

  @override
  String get rel_ops_cap_value_clean => 'загроз немає';

  @override
  String get rel_ops_cap_value_ready => 'готово';

  @override
  String get rel_ops_cap_value_available => 'доступно';

  @override
  String get rel_ops_cap_value_unavailable => 'недоступно';

  @override
  String get rel_ops_cap_value_enabled => 'увімкнено';

  @override
  String get rel_ops_cap_value_disabled => 'вимкнено';

  @override
  String get rel_ops_cap_value_active => 'активно';

  @override
  String get rel_ops_cap_value_inactive => 'неактивно';

  @override
  String get rel_ops_cap_value_installed => 'встановлено';

  @override
  String get rel_ops_cap_value_missing => 'відсутнє';

  @override
  String get rel_ops_cap_value_configured => 'налаштовано';

  @override
  String get rel_ops_cap_value_not_configured => 'не налаштовано';

  @override
  String get rel_ops_cap_value_error => 'помилка';

  @override
  String get rel_ops_cap_value_unknown => 'невідомо';

  @override
  String get rel_ops_cap_value_login => 'дані входу';

  @override
  String get rel_ops_cap_value_address => 'адреса';

  @override
  String get rel_ops_cap_value_payment => 'платіж';

  @override
  String get rel_ops_term_connecting => 'Підключення…';

  @override
  String get rel_ops_term_unbound =>
      'Немає відповідного активного сеансу або робочого каталогу на хості. Спочатку відкрийте пов’язаний чат.';

  @override
  String get rel_ops_term_unsupported =>
      'Цей шлюз не надає такої можливості термінала. Локальну оболонку не було запущено.';

  @override
  String get rel_ops_term_local_pty_unavailable =>
      'Вбудований локальний псевдотермінал (PTY) недоступний на цьому пристрої.';

  @override
  String get rel_ops_term_operation_failed =>
      'Не вдалося відкрити термінал або керувати ним. Перевірте хост, облікові дані та відбиток. Запасну оболонку не було запущено.';

  @override
  String get rel_ops_term_input_refused =>
      'Введення відхилено. Знову відкрийте початковий чат.';

  @override
  String get rel_ops_term_cancel => 'Скасувати';

  @override
  String get rel_ops_term_confirm => 'Підтвердити';

  @override
  String get rel_ops_term_open_device_title =>
      'Відкрити оболонку на цьому пристрої?';

  @override
  String get rel_ops_term_ssh_shell => 'Оболонка SSH';

  @override
  String get rel_ops_term_local_shell => 'Локальна оболонка';

  @override
  String get rel_ops_term_connection_lost => 'З’єднання втрачено';

  @override
  String get rel_ops_term_shell_ended => 'Оболонку завершено';

  @override
  String get rel_ops_term_no_owner =>
      'Цей чат не має автентифікованого власника термінала шлюзу. Самої URL-адреси або входу в хмару недостатньо для доступу до оболонки.';

  @override
  String get rel_ops_term_open_gateway_title => 'Відкрити оболонку шлюзу?';

  @override
  String get rel_ops_term_shell_expired =>
      'Оболонку завершено або термін її дії минув';

  @override
  String get rel_ops_term_disconnected => 'Відключено';

  @override
  String get rel_ops_term_gateway_shell => 'Оболонка шлюзу';

  @override
  String get rel_ops_term_close_body =>
      'Завершити цю оболонку. Щоб залишити її працювати, натомість приховайте панель.';

  @override
  String get rel_ops_term_closing => 'Закриття…';

  @override
  String get rel_ops_term_close_unconfirmed => 'Закриття не підтверджено';

  @override
  String get rel_ops_term_processes_require_chat =>
      'Для процесів агента потрібен автентифікований чат, якому вони належать.';

  @override
  String get rel_ops_term_watching_processes =>
      'Спостереження за процесами агента цього чату. Закриття дзеркального подання ніколи не зупиняє його процес.';

  @override
  String get rel_ops_term_paste_limit => 'Розмір вставлення обмежено 16 KiB.';

  @override
  String get rel_ops_term_paste => 'Вставити';

  @override
  String get rel_ops_term_select_first => 'Спочатку виділіть вивід термінала.';

  @override
  String get rel_ops_term_open_chat_to_insert =>
      'Відкрийте початковий чат перед вставленням виводу.';

  @override
  String get rel_ops_term_added_to_draft =>
      'Додано до чернетки початкового чату. Нічого не надіслано.';

  @override
  String get rel_ops_term_close => 'Закрити';

  @override
  String get rel_ops_term_add_selection => 'Додати виділене до чернетки чату';

  @override
  String get rel_ops_term_new_terminal => 'Новий термінал';

  @override
  String get rel_ops_term_gateway_terminal => 'Термінал хоста шлюзу';

  @override
  String get rel_ops_term_verified_ssh_terminal => 'Перевірений термінал SSH';

  @override
  String get rel_ops_term_device_local_shell =>
      'Цей пристрій (локальна оболонка)';

  @override
  String get rel_ops_term_local_unavailable_mobile =>
      'Локальна оболонка недоступна на мобільних пристроях';

  @override
  String get rel_ops_term_watch_processes => 'Спостерігати за процесами агента';

  @override
  String get rel_ops_term_select_output => 'Виділити або скопіювати вивід';

  @override
  String get rel_ops_term_add_selected_output =>
      'Додати виділений вивід до чернетки чату';

  @override
  String get rel_ops_term_review_paste =>
      'Перевірити вставлення з буфера обміну';

  @override
  String get rel_ops_term_reconnect =>
      'Повторно підключитися до тієї самої оболонки';

  @override
  String get rel_ops_term_close_mirror => 'Закрити дзеркальне подання';

  @override
  String get rel_ops_term_close_shell => 'Закрити оболонку';

  @override
  String get rel_ops_term_empty =>
      'Натисніть +, щоб відкрити термінал. Жодна оболонка не запускається автоматично.';

  @override
  String get rel_ops_term_reason_stale => 'застаріле';

  @override
  String get rel_ops_term_reason_mismatch => 'невідповідність';

  @override
  String get rel_ops_term_reason_unbound => 'не прив’язано';

  @override
  String get rel_ops_term_reason_unsupported => 'не підтримується';

  @override
  String get rel_ops_term_reason_denied => 'відмовлено';

  @override
  String get rel_ops_term_reason_ineligible => 'не відповідає умовам';

  @override
  String get rel_ops_term_reason_unavailable => 'недоступно';

  @override
  String get rel_ops_term_reason_invalid => 'некоректне';

  @override
  String get rel_ops_term_reason_insecure => 'небезпечно';

  @override
  String rel_ops_term_refused(String reason) {
    return 'Шлюз відхилив цю операцію термінала ($reason).';
  }

  @override
  String rel_ops_term_open_device_body(String connection) {
    return 'Це пристрій з Ares, а не $connection. Оболонка використовує дозволи застосунку та запускається в його сховищі.';
  }

  @override
  String rel_ops_term_open_gateway_body(String host) {
    return 'Запустіть оболонку на $host у перевіреному робочому каталозі чату. Це не оболонка пристрою.';
  }

  @override
  String rel_ops_term_close_tab_title(String label) {
    return 'Закрити $label?';
  }

  @override
  String rel_ops_term_read_only_status(String status) {
    return 'Лише читання · $status';
  }

  @override
  String rel_ops_term_paste_title(String label) {
    return 'Вставити в $label?';
  }

  @override
  String rel_ops_term_output_title(String label) {
    return 'Вивід · $label';
  }

  @override
  String rel_ops_term_mirror_status(String label) {
    return 'Дзеркальне подання процесу лише для читання · $label';
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
    return 'Цей пристрій · $number';
  }

  @override
  String rel_ops_term_gateway_tab(String host, int number) {
    return 'Шлюз $host · $number';
  }

  @override
  String get rel_ops_term_earlier_output_trimmed =>
      '[Попередній вивід обрізано]';

  @override
  String get rel_ops_term_ssh_dialog_title =>
      'Відкрити перевірений термінал SSH';

  @override
  String get rel_ops_term_ssh_dialog_body =>
      'Використовуйте відбиток, отриманий незалежним шляхом від адміністратора хоста. Буде відкрито новий віддалений сеанс входу, а не шлюз чи локальну оболонку.';

  @override
  String get rel_ops_term_ssh_host => 'Хост SSH';

  @override
  String get rel_ops_term_ssh_port => 'Порт';

  @override
  String get rel_ops_term_ssh_user => 'Користувач';

  @override
  String get rel_ops_term_ssh_fingerprint => 'Відбиток ключа хоста (SHA256:…)';

  @override
  String get rel_ops_term_ssh_password => 'Пароль SSH (не зберігається)';

  @override
  String get rel_ops_term_connect => 'Підключитися';

  @override
  String get rel_ops_ssh_invalid_destination =>
      'Недійсний хост, порт або користувач SSH.';

  @override
  String get rel_ops_ssh_public_key_required =>
      'Потрібен відкритий ключ хоста OpenSSH Ed25519.';

  @override
  String get rel_ops_ssh_invalid_public_key => 'Недійсний ключ хоста Ed25519.';

  @override
  String get rel_ops_ssh_invalid_saved_key =>
      'Недійсний збережений ключ хоста.';

  @override
  String get rel_ops_ssh_enrollment_unverified =>
      'Не вдалося перевірити реєстрацію ключа хоста.';

  @override
  String get rel_ops_ssh_different_key_pinned =>
      'Уже закріплено інший ключ. Перевірте зміну окремо.';

  @override
  String get rel_ops_ssh_open_ssh_unavailable =>
      'Системний OpenSSH недоступний.';

  @override
  String get rel_ops_ssh_confirm_host_key =>
      'Підтвердьте ключ хоста перед підключенням.';

  @override
  String get rel_ops_ssh_absolute_identity_required =>
      'Виберіть файл ідентифікації з абсолютним шляхом.';

  @override
  String get rel_ops_ssh_invalid_remote_port => 'Недійсний віддалений порт.';

  @override
  String get rel_ops_ssh_preview_too_large =>
      'Попередній перегляд перевищує обмеження в 64 KiB.';

  @override
  String get rel_ops_ssh_connection_refused =>
      'Підключення SSH відхилено. Перевірте зареєстрований ключ хоста, дані ідентифікації та службу.';

  @override
  String get rel_ops_ssh_http_not_ok =>
      'Віддалена служба не повернула HTTP 200.';

  @override
  String get rel_ops_ssh_encoded_response =>
      'Цей попередній перегляд не підтримує закодовані відповіді.';

  @override
  String get rel_ops_ssh_preview_type_unsupported =>
      'Попередній перегляд доступний лише для тексту й вихідного коду HTML.';

  @override
  String get rel_ops_ssh_health_unconfirmed =>
      'Служба не підтвердила справність шлюзу.';

  @override
  String get rel_ops_ssh_enroll_host_key_first =>
      'Спочатку зареєструйте відкритий ключ хоста.';

  @override
  String get rel_ops_ssh_cancel => 'Скасувати';

  @override
  String get rel_ops_ssh_confirm => 'Підтвердити';

  @override
  String get rel_ops_ssh_pin_title => 'Закріпити цей ключ хоста SSH?';

  @override
  String rel_ops_ssh_pin_detail(String destination, String fingerprint) {
    return '$destination\n$fingerprint\nЗвірте цей відбиток з адміністратором хоста через незалежний канал. Підключення не буде встановлено.';
  }

  @override
  String get rel_ops_ssh_host_key_pinned => 'Ключ хоста закріплено.';

  @override
  String get rel_ops_ssh_shell_detail =>
      'Відкрити інтерактивну оболонку входу в систему.';

  @override
  String rel_ops_ssh_read_detail(String path, int port) {
    return 'Прочитати $path за віддаленою адресою 127.0.0.1:$port через канал SSH.';
  }

  @override
  String rel_ops_ssh_connect_title(String destination) {
    return 'Підключитися до $destination?';
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
      'Пройти автентифікацію за допомогою вашого агента SSH.';

  @override
  String get rel_ops_ssh_identity_auth =>
      'Використати вибраний файл ідентифікації.';

  @override
  String rel_ops_ssh_gateway_responding(int port) {
    return 'Шлюз відповідає на віддаленому порту петльового інтерфейсу $port.';
  }

  @override
  String get rel_ops_ssh_session_closed => 'Сесію SSH закрито.';

  @override
  String get rel_ops_ssh_session_unclean => 'Сесія SSH завершилася некоректно.';

  @override
  String get rel_ops_ssh_operation_failed =>
      'Помилка операції SSH. Перевірте адресу призначення й дані ідентифікації.';

  @override
  String get rel_ops_ssh_title => 'Перевірений SSH';

  @override
  String get rel_ops_ssh_unsupported =>
      'На цьому пристрої немає підтримуваного системного транспорту OpenSSH. Ретранслятор закріпленого шлюзу автоматично приймає нові ключі й не може використовуватися для перевіреної реєстрації.';

  @override
  String get rel_ops_ssh_host => 'Хост SSH';

  @override
  String get rel_ops_ssh_port => 'Порт SSH';

  @override
  String get rel_ops_ssh_user => 'Користувач SSH';

  @override
  String get rel_ops_ssh_identity =>
      'Файл ідентифікації (необов’язково; інакше використовується агент SSH)';

  @override
  String get rel_ops_ssh_public_key =>
      'Відкритий ключ хоста від адміністратора (ssh-ed25519)';

  @override
  String get rel_ops_ssh_review_key => 'Переглянути ключ хоста';

  @override
  String get rel_ops_ssh_remote_port =>
      'Віддалений порт служби на петльовому інтерфейсі';

  @override
  String get rel_ops_ssh_check_gateway => 'Перевірити шлюз через SSH';

  @override
  String get rel_ops_ssh_preview_source =>
      'Попередній перегляд вихідного коду через SSH';

  @override
  String get rel_ops_ssh_open_shell => 'Відкрити оболонку SSH';

  @override
  String get rel_ops_ssh_shell_line => 'Рядок для віддаленої оболонки';

  @override
  String get rel_ops_ssh_disconnect => 'Відключити оболонку';

  @override
  String get rel_ops_host_cancel => 'Скасувати';

  @override
  String get rel_ops_host_confirm => 'Підтвердити';

  @override
  String get rel_ops_host_title => 'Хост';

  @override
  String get rel_ops_host_refresh => 'Оновити';

  @override
  String get rel_ops_host_update => 'Оновити Hermes на віддаленому хості';

  @override
  String rel_ops_host_update_confirmation(String profile) {
    return 'Це запустить оновлення наявного встановлення на хості шлюзу для $profile. Ares на цьому пристрої не буде оновлено. Успіх засвідчує відповідне підтвердження оновлення, а не те, що хост залишається доступним.';
  }

  @override
  String get rel_ops_host_update_awaiting =>
      'Очікування відповідного підтвердження. Оновлення ще триває.';

  @override
  String get rel_ops_host_receipt_success =>
      'Підтвердження оновлення вказує на успіх.';

  @override
  String get rel_ops_host_receipt_partial =>
      'Оновлення застосовано, але ще потрібні подальші дії.';

  @override
  String get rel_ops_host_receipt_failed =>
      'Підтвердження оновлення вказує на збій.';

  @override
  String get rel_ops_host_receipt_refused =>
      'Підтвердження оновлення вказує на відмову.';

  @override
  String get rel_ops_host_update_running => 'Оновлення ще триває.';

  @override
  String get rel_ops_host_update_unknown =>
      'Результат оновлення невідомий. Робота шлюзу не означає успішного оновлення.';

  @override
  String get rel_ops_host_default_profile => 'типовий профіль шлюзу';

  @override
  String get rel_ops_host_restart => 'Перезапустити віддалений шлюз';

  @override
  String rel_ops_host_restart_shared_confirmation(String profiles) {
    return 'Це перезапустить шлюз, спільний для $profiles. Поточні ходи на цьому шлюзі буде перервано. Потім підключіться знову. Доступність не доводить, що перезапуск завершився.';
  }

  @override
  String rel_ops_host_restart_confirmation(String profile) {
    return 'Це перезапустить віддалений шлюз для $profile. Поточні ходи на цьому шлюзі буде перервано. Потім підключіться знову.';
  }

  @override
  String get rel_ops_host_restart_running =>
      'Команда перезапуску ще виконується.';

  @override
  String get rel_ops_host_restart_finished =>
      'Команду перезапуску завершено. Підключіться до хоста знову вручну.';

  @override
  String get rel_ops_host_restart_failed =>
      'Команда перезапуску завершилася помилкою.';

  @override
  String rel_ops_host_maintenance_running(String name) {
    return '$name ще виконується';
  }

  @override
  String rel_ops_host_maintenance_finished(String name) {
    return '$name: виконання завершено';
  }

  @override
  String rel_ops_host_maintenance_failed(String name) {
    return '$name: збій виконання';
  }

  @override
  String get rel_ops_host_curator_paused_result => 'Куратора призупинено.';

  @override
  String get rel_ops_host_curator_resumed_result =>
      'Роботу Куратора відновлено.';

  @override
  String get rel_ops_host_reset => 'Скинути віддалені файли пам’яті';

  @override
  String rel_ops_host_reset_confirmation(String targetName, String profile) {
    return 'Видалити файл пам’яті $targetName у $profile? Цю дію не можна скасувати з Ares.';
  }

  @override
  String rel_ops_host_reset_result(String targetName, int count) {
    return 'Виконано скидання $targetName. Видалено віддалених файлів: $count.';
  }

  @override
  String get rel_ops_host_share_not_redacted =>
      'Хост не підтвердив вилучення конфіденційних даних із пакета. Посилання не відображається.';

  @override
  String rel_ops_host_scope(String connection, String profile) {
    return 'Ці елементи керування діють на віддалений шлюз $connection для $profile, а не на цей пристрій чи оновлення клієнта Ares.';
  }

  @override
  String rel_ops_host_health_running(String version, int count) {
    return 'Процес шлюзу працює $version · Сеансів: $count';
  }

  @override
  String rel_ops_host_health_stopped(String version, int count) {
    return 'Процес шлюзу зупинено $version · Сеансів: $count';
  }

  @override
  String rel_ops_host_heartbeat_stale(num seconds) {
    return 'Сигнал активності хоста застарів ($seconds с).';
  }

  @override
  String get rel_ops_host_doctor => 'Запустити Doctor';

  @override
  String get rel_ops_host_security_audit => 'Аудит безпеки';

  @override
  String get rel_ops_host_check_receipt => 'Перевірити підтвердження оновлення';

  @override
  String get rel_ops_host_logs => 'Журнали віддаленого хоста';

  @override
  String get rel_ops_host_search_logs => 'Пошук у журналах хоста';

  @override
  String get rel_ops_host_driver => 'Драйвер віддаленого хоста';

  @override
  String get rel_ops_host_driver_scope =>
      'Готовність керування комп’ютером визначають драйвер і дозволи ОС на машині шлюзу, а не на цьому пристрої.';

  @override
  String rel_ops_host_computer_status(
    String platform,
    String installed,
    String ready,
  ) {
    return '$platform · встановлено: $installed · готово: $ready';
  }

  @override
  String get rel_ops_host_null => 'немає даних';

  @override
  String get rel_ops_host_true => 'так';

  @override
  String get rel_ops_host_false => 'ні';

  @override
  String get rel_ops_host_curator => 'Куратор';

  @override
  String get rel_ops_host_curator_paused => 'Куратора призупинено';

  @override
  String get rel_ops_host_curator_running => 'Куратор працює';

  @override
  String get rel_ops_host_no_run => 'Немає завершених запусків';

  @override
  String get rel_ops_host_run_curator => 'Запустити Куратора зараз';

  @override
  String get rel_ops_host_reset_memory => 'Скинути файл пам’яті';

  @override
  String get rel_ops_host_reset_user => 'Скинути файл користувача';

  @override
  String get rel_ops_host_reset_both => 'Скинути обидва файли';

  @override
  String get rel_ops_host_share_consent =>
      'Я погоджуюся завантажити діагностичний пакет із віддаленого хоста з вилученими конфіденційними даними';

  @override
  String get rel_ops_host_share =>
      'Поділитися діагностикою без конфіденційних даних';

  @override
  String get rel_ops_host_update_unknown_installation =>
      'Це встановлення невідоме, тому запит на оновлення не надіслано';

  @override
  String get rel_ops_host_update_busy_installation =>
      'На цьому встановленні виконується чат';

  @override
  String get rel_ops_host_update_refused => 'Віддалене оновлення відхилено';

  @override
  String get rel_ops_host_error_stale => 'Віддалена робоча область: застаріла';

  @override
  String get rel_ops_host_error_mismatch =>
      'Віддалена робоча область: невідповідність';

  @override
  String get rel_ops_host_error_unbound =>
      'Віддалена робоча область: не прив’язана';

  @override
  String get rel_ops_host_error_unsupported =>
      'Віддалена робоча область: не підтримується';

  @override
  String get rel_ops_host_error_denied =>
      'Віддалена робоча область: доступ заборонено';

  @override
  String get rel_ops_host_error_ineligible =>
      'Віддалена робоча область: не підходить для операції';

  @override
  String get rel_ops_host_error_unavailable =>
      'Віддалена робоча область: недоступна';

  @override
  String get rel_ops_host_error_invalid =>
      'Віддалена робоча область: некоректні дані';

  @override
  String get rel_ops_host_error_insecure =>
      'Віддалена робоча область: незахищене з’єднання';

  @override
  String get rel_ops_host_error_request => 'Не вдалося виконати запит.';

  @override
  String get rel_svc_push_api_select_sessions =>
      'Виберіть від 1 до 128 постійних ідентифікаторів сеансів завдовжки 1–200 символів ASCII. Дозволено лише літери, цифри, _ . : @ та -. Видаліть порожні ідентифікатори й пробіли.';

  @override
  String get rel_svc_push_api_unavailable =>
      'Мобільні push-сповіщення недоступні на цьому сервері.';

  @override
  String get rel_svc_push_api_invalid_vapid =>
      'Недійсний відкритий ключ VAPID сервера.';

  @override
  String get rel_svc_push_api_update_plugin =>
      'Для автоматичних підписок на цьому сервері потрібен оновлений плагін mobile-push.';

  @override
  String get rel_svc_push_status_android_only => 'Лише Android';

  @override
  String get rel_svc_push_native_prefs_sync_failed =>
      'Не вдалося синхронізувати системні налаштування сповіщень.';

  @override
  String get rel_svc_push_choose_android_connection =>
      'Спочатку виберіть збережене підключення на Android.';

  @override
  String get rel_svc_push_status_checking_authorization =>
      'Перевірка авторизації сервера';

  @override
  String get rel_svc_push_revoke_persist_failed =>
      'Не вдалося зберегти відкликання. Перед виходом із застосунку ще раз спробуйте вимкнути функцію.';

  @override
  String get rel_svc_push_status_off_api_ready =>
      'Вимкнено; API сервера готовий';

  @override
  String get rel_svc_push_status_off_revoke_pending =>
      'Вимкнено; відкликання на сервері очікується';

  @override
  String get rel_svc_push_status_off_connection_changed =>
      'Вимкнено; збережене підключення змінено';

  @override
  String get rel_svc_push_status_pending_endpoint =>
      'Очікування кінцевої точки розповсюджувача';

  @override
  String get rel_svc_push_status_registering => 'Реєстрація';

  @override
  String get rel_svc_push_status_pending_challenge =>
      'Очікується зашифрована перевірка (очікування тихого push-повідомлення для перевірки сервера)';

  @override
  String get rel_svc_push_allow_android_notifications_retry =>
      'Дозвольте сповіщення Android у налаштуваннях системи та повторіть спробу.';

  @override
  String get rel_svc_push_plugin_invalid =>
      'Плагін mobile-push на сервері недоступний, застарів або повернув недійсну відповідь підписки. Попросіть оператора оновити його та повторіть спробу.';

  @override
  String get rel_svc_push_transport_unavailable =>
      'Немає доступного транспорту push. Для вбудованої доставки потрібні справні сервіси Google Play; або встановіть розповсюджувач UnifiedPush і повторіть спробу.';

  @override
  String get rel_svc_push_transport_choice =>
      'Доступно кілька розповсюджувачів UnifiedPush. Виберіть один у розділі «Розширений транспорт» і повторіть спробу.';

  @override
  String get rel_svc_push_transport_missing =>
      'Вибраний розповсюджувач UnifiedPush недоступний. Відновіть його або виберіть інший у розділі «Розширений транспорт».';

  @override
  String get rel_svc_push_companion_unavailable =>
      'Серверний компонент mobile-push недоступний. Він може бути відсутній, вимкнений або підключення може вказувати не на ту панель. Установіть або ввімкніть компонент на сервері, перевірте підключення панелі й оновіть. Див. посібник із налаштування сервера вище.';

  @override
  String get rel_svc_push_server_denied =>
      'Сервер відхилив мобільні push-сповіщення. Попросіть оператора авторизувати цього суб’єкта й ці сеанси.';

  @override
  String get rel_svc_push_not_ready =>
      'Мобільні push-сповіщення не готові. Перевірте авторизацію серверного плагіна, розповсюджувач і мережу, а потім повторіть спробу.';

  @override
  String get rel_svc_push_availability_read_failed =>
      'Не вдалося перевірити доступність push на Android. Повторіть спробу нижче.';

  @override
  String get rel_svc_push_setup_failed =>
      'Не вдалося налаштувати push. Перевірте дозвіл Android, авторизацію сервера й транспорт, а потім повторіть спробу.';

  @override
  String rel_svc_push_status(String status) {
    return 'Стан: $status';
  }

  @override
  String rel_svc_push_status_bound(
    String bound,
    String connection,
    String status,
  ) {
    return 'Стан: прив’язано до $bound (неактивно для $connection; узгодження: $status)';
  }

  @override
  String get rel_svc_push_another_saved_connection =>
      'інше збережене підключення';

  @override
  String get rel_svc_push_background_notifications => 'Фонові сповіщення';

  @override
  String rel_svc_push_bound_subtitle(String bound, String connection) {
    return 'Прив’язано до $bound — відкличте цю прив’язку нижче, перш ніж вмикати для $connection';
  }

  @override
  String rel_svc_push_private_activity(String connection) {
    return 'Приватна активність сервера для $connection';
  }

  @override
  String rel_svc_push_bound_warning_named(String bound) {
    return 'Прив’язано до іншого збереженого підключення ($bound). Вимкніть і відкличте цю прив’язку, перш ніж вмикати для цього підключення.';
  }

  @override
  String get rel_svc_push_bound_warning =>
      'Прив’язано до іншого збереженого підключення. Вимкніть і відкличте цю прив’язку, перш ніж вмикати для цього підключення.';

  @override
  String get rel_svc_push_local_notifications_muted =>
      'Локальні сповіщення вимкнено вище. Згода на фонові сповіщення не змінилася, але звичайні підказки активності приглушені до ввімкнення «Увімкнути сповіщення».';

  @override
  String rel_svc_push_legacy_subscription(int count) {
    return 'Застаріла підписка: лише $count вибраних сеансів. Вона не розшириться автоматично. Вимкніть і ввімкніть її, щоб погодитися на авторизовані сервером сеанси.';
  }

  @override
  String get rel_svc_push_authorized_binding =>
      'Прив’язано лише до цього збереженого підключення та профілю. Доступ до сеансів визначається поточною авторизацією сервера.';

  @override
  String get rel_svc_push_revocation_pending =>
      'Очікується відкликання на сервері. Локальну доставку вимкнено; повторіть спробу, доки доступний початковий збережений обліковий запис.';

  @override
  String get rel_svc_push_refresh_retry => 'Оновити / повторити';

  @override
  String rel_svc_push_disable_named(String bound) {
    return 'Вимкнути й відкликати $bound';
  }

  @override
  String get rel_svc_push_other_connection => 'інше підключення';

  @override
  String get rel_svc_push_disable => 'Вимкнути й відкликати';

  @override
  String get rel_svc_push_refresh_explanation =>
      '«Оновити / повторити» знову перевіряє доступність після налаштування сервера, але не встановлює компонент. Увімкнення сповіщень залишається окремим вибором.';

  @override
  String get rel_svc_push_companion_required =>
      'Для фонових сповіщень потрібен окремо встановлений і ввімкнений серверний компонент mobile-push. Android не може його встановити. Оновлення лише APK не налаштовує сервер.';

  @override
  String get rel_svc_push_server_setup_guide =>
      'Посібник із налаштування сервера';

  @override
  String get rel_svc_push_enable_disclosure =>
      'Увімкніть, щоб запитати дозвіл Android на сповіщення й передати цьому серверу кінцеву точку та ключі шифрування цієї інсталяції. Зашифровані підказки активності не містять вмісту чатів. Додаються лише сеанси, дозволені вашим серверним обліковим записом.';

  @override
  String get rel_svc_push_transport_disclosure =>
      'Вбудована доставка використовує push-транспорт Google і сервіси Google Play, але не містить Firebase SDK. Натомість можна використовувати розповсюджувач UnifiedPush. Доставка виконується за можливості; знову відкрийте Hermes для звірки.';

  @override
  String get rel_svc_push_advanced_transport => 'Розширений транспорт';

  @override
  String get rel_svc_push_automatic_explanation =>
      'Автовибір зберігає вибраний розповсюджувач, інакше використовує вбудовану доставку Google, якщо вона доступна. Перед зміною транспорту вимкніть функцію.';

  @override
  String get rel_svc_push_transport_label => 'Push-транспорт';

  @override
  String get rel_svc_push_automatic_recommended =>
      'Автоматично (рекомендовано)';

  @override
  String get rel_svc_push_selected_unavailable =>
      'Вибраний розповсюджувач (недоступний)';

  @override
  String get rel_svc_push_no_transport_detected =>
      'Доступний транспорт не знайдено. Для вбудованої доставки потрібні сервіси Google Play; без них установіть і налаштуйте розповсюджувач UnifiedPush, а потім оновіть.';

  @override
  String get rel_svc_push_channel_turns_name => 'Ходи Ares';

  @override
  String get rel_svc_push_channel_turns_description =>
      'Сповіщення про завершені фонові ходи';

  @override
  String get rel_svc_push_channel_attention_name => 'Увага Ares';

  @override
  String get rel_svc_push_channel_attention_description =>
      'Запити на схвалення та введення, що потребують вашої участі';

  @override
  String get rel_svc_push_channel_background_name => 'Ares у фоні';

  @override
  String get rel_svc_push_channel_background_description =>
      'Завершення фонових завдань';

  @override
  String get rel_svc_push_channel_notices_name => 'Сповіщення Ares';

  @override
  String get rel_svc_push_channel_notices_description =>
      'Сповіщення про кредити та плагіни';

  @override
  String get rel_svc_push_diag_not_initialised => 'не ініціалізовано';

  @override
  String get rel_svc_push_diag_replies_off =>
      'сповіщення про відповіді вимкнено';

  @override
  String get rel_svc_push_diag_conversation => 'розмова';

  @override
  String get rel_svc_push_diag_conversation_permission_denied =>
      'розмова; дозвіл відхилено';

  @override
  String rel_svc_push_diag_conversation_error(String error) {
    return 'розмова: $error';
  }

  @override
  String get rel_svc_push_diag_failures_off =>
      'сповіщення про помилки вимкнено';

  @override
  String rel_svc_push_diag_kind_off(String kind) {
    return '$kind вимкнено';
  }

  @override
  String get rel_svc_push_diag_windows_setting_unknown =>
      'Windows не повідомив налаштування сповіщень';

  @override
  String get rel_svc_backup_not_hermes_configuration_backup =>
      'Цей файл не є резервною копією конфігурації Hermes.';

  @override
  String get rel_svc_backup_newer_version_cannot_import =>
      'Цю резервну копію створено новішою версією застосунку, тому її не можна імпортувати.';

  @override
  String get rel_svc_backup_missing_client_certificate =>
      'У резервній копії заявлено клієнтський сертифікат для підключення, але його немає, тому повне відновлення неможливе.';

  @override
  String get rel_svc_backup_damaged_unreadable =>
      'Файл резервної копії пошкоджено, тому його не вдалося прочитати.';

  @override
  String get rel_svc_backup_unsupported_preference_type =>
      'Збережене налаштування має непідтримуваний тип і не може бути експортоване.';

  @override
  String get rel_svc_backup_choose_passphrase_api_keys =>
      'Виберіть парольну фразу — резервна копія містить ваші ключі API.';

  @override
  String get rel_svc_backup_could_not_protect_safely =>
      'Не вдалося безпечно захистити резервну копію.';

  @override
  String get rel_svc_backup_unsupported_encryption =>
      'У цій резервній копії використано непідтримувану схему шифрування.';

  @override
  String get rel_svc_backup_wrong_passphrase_or_altered =>
      'Неправильна парольна фраза або файл резервної копії було змінено.';

  @override
  String get rel_svc_backup_share_subject =>
      'Резервна копія конфігурації Hermes';

  @override
  String get rel_svc_backup_selected_file_unreadable =>
      'Не вдалося прочитати цей файл.';

  @override
  String rel_svc_backup_connections_added(int count) {
    return 'додано: $count';
  }

  @override
  String rel_svc_backup_connections_updated(int count) {
    return 'оновлено: $count';
  }

  @override
  String rel_svc_backup_connections_removed(int count) {
    return 'видалено: $count';
  }

  @override
  String get rel_svc_backup_no_connection_changes => 'Підключення не змінено';

  @override
  String rel_svc_backup_connections_summary(String changes) {
    return 'Підключення: $changes';
  }

  @override
  String rel_svc_backup_restore_summary(String connections, int count) {
    return '$connections · відновлено налаштувань: $count';
  }

  @override
  String rel_svc_backup_certificate_not_included(String label, String error) {
    return 'Не вдалося включити клієнтський сертифікат для «$label» до цієї резервної копії: $error';
  }

  @override
  String get rel_svc_backup_certificate_password_needed =>
      'Для цього сертифіката потрібен пароль. Введіть його нижче, і сертифікат відкриється автоматично.';

  @override
  String get rel_svc_backup_certificate_password_or_corrupt =>
      'Пароль сертифіката неправильний або файл пошкоджено.';

  @override
  String get rel_svc_backup_certificate_password_incorrect =>
      'Пароль сертифіката неправильний.';

  @override
  String get rel_svc_backup_certificate_unsupported_encryption =>
      'У цьому сертифікаті використано метод шифрування, який застосунок не може прочитати.';

  @override
  String get rel_svc_backup_certificate_unreadable_pkcs12 =>
      'Вибраний файл не є придатним для читання сертифікатом PKCS#12 (.p12/.pfx).';

  @override
  String get rel_svc_backup_certificate_unreadable =>
      'Не вдалося прочитати вибраний сертифікат.';

  @override
  String get rel_svc_backup_not_certificate_file =>
      'Цей файл не є сертифікатом: виберіть контейнер .p12/.pfx або файли сертифіката й ключа PEM.';

  @override
  String get rel_svc_backup_not_pem_certificate =>
      'Вибраний сертифікат не є сертифікатом PEM.';

  @override
  String get rel_svc_backup_not_pem_private_key =>
      'Вибраний закритий ключ не є закритим ключем PEM.';

  @override
  String get rel_svc_backup_certificate_pair_unloadable =>
      'Не вдалося завантажити вибрані сертифікат і закритий ключ.';

  @override
  String get rel_svc_backup_saved_certificate_files_unreadable =>
      'Не вдалося прочитати збережені файли клієнтського сертифіката.';

  @override
  String get rel_svc_backup_client_certificate_storage_failed =>
      'Не вдалося безпечно зберегти клієнтський сертифікат на цьому пристрої.';

  @override
  String get rel_svc_backup_certificate_storage_failed =>
      'Не вдалося безпечно зберегти сертифікат на цьому пристрої.';

  @override
  String get rel_svc_backup_client_certificate_label =>
      'Клієнтський сертифікат';

  @override
  String rel_svc_backup_search_dashboard_unreachable(String error) {
    return 'Не вдалося підключитися до панелі керування: $error';
  }

  @override
  String get rel_svc_backup_search_credentials_rejected =>
      'Панель керування відхилила збережені облікові дані. Перевірте ім’я користувача й пароль панелі для цього підключення.';

  @override
  String get rel_svc_backup_search_not_supported =>
      'Ця панель не підтримує пошук сеансів. Оновіть Hermes на хості або поверніться до пошуку на пристрої.';

  @override
  String rel_svc_backup_search_redirected(int statusCode) {
    return 'Панель переспрямувала пошук сеансів (HTTP $statusCode). Ares не переходить за переспрямуваннями зі збереженими обліковими даними; перевірте адресу підключення.';
  }

  @override
  String rel_svc_backup_search_http_failed(int statusCode) {
    return 'Пошук сеансів завершився помилкою HTTP $statusCode.';
  }

  @override
  String get rel_svc_backup_search_malformed_response =>
      'Панель повернула некоректну відповідь пошуку.';

  @override
  String get rel_svc_backup_search_unexpected_response =>
      'Панель повернула неочікувану відповідь пошуку.';

  @override
  String get rel_svc_backup_search_too_many_results =>
      'Панель повернула більше результатів пошуку, ніж було запитано.';

  @override
  String get rel_svc_backup_message_search_unexpected_response =>
      'Неочікувана відповідь пошуку повідомлень.';

  @override
  String get rel_svc_backup_message_search_unexpected_result =>
      'Неочікуваний результат пошуку повідомлень.';

  @override
  String get rel_svc_backup_ai_search_api_key_rejected =>
      'API Hermes відхилив збережений ключ API.';

  @override
  String rel_svc_backup_ai_search_http_failed(int statusCode) {
    return 'Переформулювання запиту за допомогою ШІ завершилося помилкою HTTP $statusCode.';
  }

  @override
  String get rel_svc_backup_ai_search_no_usable_query =>
      'Вибрана модель не повернула придатний пошуковий запит.';

  @override
  String get rel_svc_backup_ai_search_malformed_response =>
      'Hermes повернув некоректну відповідь переформулювання за допомогою ШІ.';

  @override
  String get rel_svc_backup_space_name_already_exists =>
      'Простір із такою назвою вже існує';

  @override
  String get rel_svc_backup_space_name_length_invalid =>
      'Назва простору має містити від 1 до 80 символів';

  @override
  String get ng_rel_svc_backup_gateway_address_required =>
      'Введіть адресу панелі керування Hermes.';

  @override
  String ng_rel_svc_backup_gateway_address_scheme(String scheme) {
    return 'Адреса має починатися з http:// або https:// (отримано: $scheme).';
  }

  @override
  String get ng_rel_svc_backup_gateway_address_invalid => 'Ця адреса недійсна.';

  @override
  String get ng_rel_svc_backup_gateway_address_no_host =>
      'В адресі немає імені хоста.';

  @override
  String get ng_rel_svc_backup_sign_in_main_window =>
      'Увійдіть у систему в головному вікні.';

  @override
  String get rel_svc_backup_sign_in_renewal_failed =>
      'Шлюз зараз не зміг оновити вхід.';

  @override
  String get rel_svc_backup_sign_in_provider_unreachable =>
      'Шлюз не зміг оновити вхід: постачальник входу недоступний.';

  @override
  String get rel_svc_backup_sign_in_renewal_timed_out =>
      'Минув час очікування оновлення входу.';

  @override
  String get rel_svc_backup_sign_in_no_tokens =>
      'Шлюз не повернув токени входу.';

  @override
  String get ng_rel_svc_backup_probe_timed_out =>
      'Час очікування минув. Перевірте адресу, VPN або підключення Tailscale.';

  @override
  String ng_rel_svc_backup_probe_tls_failed(String error) {
    return 'Помилка рукостискання TLS: $error';
  }

  @override
  String ng_rel_svc_backup_gateway_answered_http(int statusCode) {
    return 'Шлюз відповів кодом HTTP $statusCode.';
  }

  @override
  String get ng_rel_svc_backup_gateway_answer_timed_out =>
      'Шлюз надто довго не відповідав.';

  @override
  String ng_rel_svc_backup_browser_callback_not_ready(String error) {
    return 'Не вдалося підготуватися до повернення з браузера: $error';
  }

  @override
  String get ng_rel_svc_backup_browser_signed_in_body =>
      'Тепер можна повернутися до Hermes.';

  @override
  String get ng_rel_svc_backup_browser_waiting_title => 'Очікування входу';

  @override
  String get ng_rel_svc_backup_browser_not_current =>
      'Ця сторінка не стосується поточного входу.';

  @override
  String get ng_rel_svc_backup_browser_open_failed =>
      'Не вдалося відкрити браузер для входу.';

  @override
  String get ng_rel_svc_backup_browser_sign_in_timed_out =>
      'Вхід тривав надто довго. Спробуйте ще раз.';

  @override
  String ng_rel_svc_backup_gateway_refused_sign_in(int statusCode) {
    return 'Шлюз відхилив вхід (HTTP $statusCode).';
  }

  @override
  String get rel_svc_misc_alert_caution => 'Обережно';

  @override
  String get rel_svc_misc_alert_important => 'Важливо';

  @override
  String get rel_svc_misc_alert_tip => 'Порада';

  @override
  String get rel_svc_misc_alert_warning => 'Попередження';

  @override
  String get rel_svc_misc_allow_folder_session =>
      'Дозволити цю папку до завершення сеансу.';

  @override
  String get rel_svc_misc_allow_website_session =>
      'Дозволити цей вебсайт до завершення сеансу.';

  @override
  String rel_svc_misc_approval_needed_title(String title) {
    return 'Потрібне схвалення — $title';
  }

  @override
  String get rel_svc_misc_attach_file_reference => 'Додати посилання на файл';

  @override
  String get rel_svc_misc_attach_folder_reference =>
      'Додати посилання на папку';

  @override
  String get rel_svc_misc_attach_git_context => 'Додати контекст git';

  @override
  String get rel_svc_misc_attach_image_reference =>
      'Додати посилання на зображення';

  @override
  String get rel_svc_misc_attach_staged_diff => 'Додати індексовані зміни';

  @override
  String get rel_svc_misc_attach_tool_reference =>
      'Додати посилання на інструмент';

  @override
  String get rel_svc_misc_attach_unstaged_diff => 'Додати неіндексовані зміни';

  @override
  String get rel_svc_misc_attach_url_reference => 'Додати посилання URL';

  @override
  String get rel_svc_misc_background_task_completed =>
      'Фонове завдання завершено';

  @override
  String rel_svc_misc_background_task_named_completed(String taskId) {
    return 'Фонове завдання $taskId завершено';
  }

  @override
  String get rel_svc_misc_chat => 'Чат';

  @override
  String get rel_svc_misc_compacting_context => 'Стиснення контексту розмови…';

  @override
  String rel_svc_misc_completed_in(String duration) {
    return 'Завершено за $duration';
  }

  @override
  String get rel_svc_misc_context_compacted => 'Контекст розмови стиснуто';

  @override
  String get rel_svc_misc_cron_readback_mismatch =>
      'Повторно прочитана модель Cron не збіглася';

  @override
  String get rel_svc_misc_cron_update_rejected => 'Оновлення Cron відхилено';

  @override
  String get rel_svc_misc_deny_folder_grant =>
      'Не надавати доступ до цієї папки.';

  @override
  String get rel_svc_misc_deny_website_grant =>
      'Не надавати доступ до цього вебсайту.';

  @override
  String rel_svc_misc_failed_after(String duration) {
    return 'Помилка через $duration';
  }

  @override
  String get rel_svc_misc_gateway_folder_unnamed => 'Шлюз не вказав папку.';

  @override
  String get rel_svc_misc_gateway_idle_unconfirmed =>
      'Шлюз неактивний. Не вдалося підтвердити результат попереднього ходу.';

  @override
  String get rel_svc_misc_gateway_turn_failed => 'Помилка ходу шлюзу';

  @override
  String rel_svc_misc_gateway_turn_status(String status) {
    return 'Хід шлюзу: $status';
  }

  @override
  String get rel_svc_misc_gateway_website_unnamed => 'Шлюз не вказав вебсайт.';

  @override
  String get rel_svc_misc_hermes_review => 'Перевірка Hermes';

  @override
  String get rel_svc_misc_hermes_turn_failed => 'Помилка ходу Hermes';

  @override
  String get rel_svc_misc_image_recovery_companion_gap =>
      'Відновлення зображень і тексту недоступне під час супровідного відновлення. Непідтверджене надсилання зображення не можна відновити в цьому з’єднанні, і нічого не надсилається повторно автоматично.';

  @override
  String get rel_svc_misc_image_recovery_rest_gap =>
      'Відновлення зображень і тексту недоступне в Classic REST/SSE. Непідтверджене надсилання зображення не можна відновити в цьому з’єднанні, і нічого не надсилається повторно автоматично.';

  @override
  String rel_svc_misc_input_needed_title(String title) {
    return 'Потрібне введення — $title';
  }

  @override
  String get rel_svc_misc_parallel_workspace_connection_changed =>
      'З’єднання змінилося. Відкрийте його знову, щоб використовувати робочий простір.';

  @override
  String get rel_svc_misc_preparing => 'Підготовка';

  @override
  String get rel_svc_misc_save_folder_grant =>
      'Зберегти цей дозвіл для папки для наступних запитів.';

  @override
  String get rel_svc_misc_save_website_grant =>
      'Зберегти цей дозвіл для вебсайту для наступних запитів.';

  @override
  String get rel_svc_misc_stored_identity_turn_conflict =>
      'Цей чат було відкрито за збереженим ідентифікатором, коли вже було прийнято інший хід. Ненадісланий запит не було надіслано; явно повторіть спробу після завершення того ходу.';

  @override
  String get rel_svc_misc_untitled => 'Без назви';

  @override
  String get rel_svc_misc_wake_capture_silent =>
      'Клієнтський запис активації чує лише тишу — перевірте доступ ОС до мікрофона та знову ввімкніть ключову фразу.';

  @override
  String get rel_svc_misc_wake_capture_stalled =>
      'Клієнтський запис активації зупинився: зворотні виклики аудіо з мікрофона не надійшли.';

  @override
  String rel_svc_misc_wake_feed_refused(int count, String detail) {
    return 'Потік ключової фрази відхилив $count послідовних кадрів$detail — знову ввімкніть ключову фразу.';
  }

  @override
  String rel_svc_misc_wake_microphone_failed(String error) {
    return 'Помилка клієнтського потоку мікрофона активації: $error';
  }

  @override
  String get rel_svc_misc_wake_track_ended =>
      'Доріжка мікрофона завершилася під час запису ключової фрази — знову ввімкніть ключову фразу.';

  @override
  String get rel_svc_misc_website => 'Вебсайт';

  @override
  String get rel_svc_lan_timeout =>
      'Час виявлення в локальній мережі вичерпано';

  @override
  String get rel_svc_notification_permission_denied => 'дозвіл відхилено';

  @override
  String get rel_svc_notifications_off => 'сповіщення вимкнено';

  @override
  String rel_chat_preview_pin_label(int number, String note) {
    return '№ $number $note';
  }

  @override
  String rel_chat_preview_pin_number(int number) {
    return '№ $number';
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
  String get fleet_managed_ssh_title => 'SSH під керуванням шлюзу';

  @override
  String get fleet_managed_ssh_intro =>
      'Керуйте SSH-хостами, уже збереженими на цьому шлюзі, з будь-якого пристрою. На віддаленому хості вже має бути встановлено Hermes. Ця операція запускає віддалений сервіс, що належить шлюзу, або під’єднується до нього, а не створює з’єднання з чатом Ares. Керовані оновлення та відновлення доступні лише в нативному настільному застосунку.';

  @override
  String get fleet_managed_ssh_read => 'Прочитати збережені SSH-хости';

  @override
  String get fleet_managed_ssh_trust =>
      'Під час цього першого з’єднання шлюз довірятиме SSH-ключу цього хоста та запам’ятає його. Подальшу зміну ключа буде виявлено, а з’єднання заблоковано. Шлюз не повідомляє відбиток ключа, тому Ares не може його показати чи зберегти. Продовжуйте, лише якщо довіряєте цьому першому з’єднанню.';

  @override
  String get fleet_managed_ssh_changed =>
      'SSH-ключ цього хоста змінився. З’єднання заблоковано. Людина з доступом до хоста шлюзу має незалежно перевірити відбиток нового ключа та видалити там старий довірений ключ. Повторюйте спробу лише після цієї перевірки та виправлення. Ares не замінює довірений ключ.';

  @override
  String get fleet_managed_ssh_disconnect_warning =>
      'Від’єднати SSH-тунель і зупинити віддалений сервіс, що належить цьому шлюзу? Це може перервати роботу інших клієнтів, які використовують цей сервіс.';

  @override
  String get fleet_managed_ssh_verify => 'Натомість перевірити ключ самостійно';

  @override
  String fleet_managed_ssh_pending(int seconds) {
    return 'Очікування шлюзу: $seconds с. Вихід із цієї сторінки не скасовує початкове налаштування. Якщо запит завершиться помилкою, перевірте стан перед повторною спробою.';
  }

  @override
  String fleet_managed_ssh_status(
    String host,
    int localPort,
    int remotePort,
    String version,
    String reused,
  ) {
    return 'Хост: $host\nПорт петльового інтерфейсу шлюзу: $localPort\nПорт віддаленого петльового інтерфейсу: $remotePort\nHermes: $version\nПовторне використання: $reused';
  }

  @override
  String get fleet_managed_ssh_disconnect => 'Від’єднати';

  @override
  String get ng_slash_suggestions_loading => 'Завантаження команд…';

  @override
  String get ng_slash_suggestions_empty => 'Немає відповідних команд';

  @override
  String get ng_slash_suggestions_label => 'Запропоновані команди';

  @override
  String get ng_slash_suggestions_skill => 'Навичка';

  @override
  String get settings_classic_title => 'Налаштування Classic';

  @override
  String get settings_nextgen_title => 'Налаштування NextGen';

  @override
  String get settings_category_general => 'Загальні налаштування й мова';

  @override
  String get settings_category_chat => 'Чати й сеанси';

  @override
  String get settings_category_device => 'Пристрій і сполучення клавіш';

  @override
  String get settings_category_connections => 'Підключення й моделі';

  @override
  String get settings_category_security => 'Конфіденційність і резервні копії';

  @override
  String get settings_category_about => 'Про застосунок і довідка';

  @override
  String get settings_reopen_chat =>
      'Відновлювати останній чат після повернення до шлюзу';

  @override
  String get settings_reopen_chat_hint =>
      'За холодного запуску відкривається екран привітання. Посилання та сповіщення відкривають запитаний чат.';

  @override
  String get settings_danger => 'Небезпечні дії';
}
