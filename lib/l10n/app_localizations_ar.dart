// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get attachment_audio_failed =>
      'تعذر تشغيل هذا الصوت. قد يكون التنسيق أو الترميز غير مدعوم، أو تم تجاوز حد حجم المعاينة. أعد المحاولة أو احفظ الملف الأصلي أو شاركه.';

  @override
  String get attachment_audio_seek => 'موضع الصوت';

  @override
  String get workspace_workers => 'العمّال النشطون';

  @override
  String get workers_unattached =>
      'أعداد فقط. لتوجيه عامل، اختر «العمّال النشطون» في المحادثة الأم المرتبط بها.';

  @override
  String get slash_local_arguments =>
      'لا يقبل هذا الاختصار معاملات هنا. استخدم عناصر التحكم في التطبيق. لم تتغير مسودتك.';

  @override
  String get fallback_title => 'النماذج الاحتياطية';

  @override
  String get fallback_notice =>
      'عندما لا يتوفر النموذج الرئيسي، تُجرَّب النماذج الاحتياطية بالترتيب. تخص التغييرات هذا الملف الشخصي فقط. اضغط على زر الحفظ لحفظ القائمة كاملة.';

  @override
  String get fallback_unavailable =>
      'إعدادات النماذج الاحتياطية غير متاحة أو غير صالحة. تحقق من الاتصال والملف الشخصي المحدد وإصدار المضيف، ثم أعد المحاولة.';

  @override
  String get fallback_discovery_unavailable =>
      'يتعذر اكتشاف المزوّدين حاليًا. ما زالت الإدخالات الحالية محفوظة. أعد المحاولة لاختيار المزوّدين والنماذج.';

  @override
  String get fallback_empty => 'قائمة النماذج الاحتياطية فارغة.';

  @override
  String get fallback_incomplete =>
      'اختر مزوّدًا ونموذجًا لكل إدخال، أو أزل الإدخالات غير المكتملة قبل الحفظ.';

  @override
  String get fallback_add => 'إضافة نموذج احتياطي';

  @override
  String get fallback_save => 'حفظ قائمة النماذج الاحتياطية';

  @override
  String get fallback_save_failed =>
      'تعذّر التحقق من قائمة النماذج الاحتياطية المحفوظة. ما زالت مسودتك محفوظة. أعد محاولة الحفظ أو حدّث الصفحة لإعادة تحميل إعدادات المضيف.';

  @override
  String get fallback_saved =>
      'حُفظت قائمة النماذج الاحتياطية وتم التحقق منها.';

  @override
  String get fallback_legacy_title =>
      'النماذج الاحتياطية القديمة (للقراءة فقط)';

  @override
  String get fallback_legacy_notice =>
      'يستخدم المضيف أيضًا fallback_model بعد هذه القائمة، ويتخطى المسارات المكررة. تظل الإدخالات القديمة محفوظة حتى لو كانت القائمة أعلاه فارغة. يمكنك تعديلها على المضيف.';

  @override
  String fallback_priority(String position) {
    return 'الأولوية: $position';
  }

  @override
  String get fallback_move_up => 'نقل لأعلى';

  @override
  String get fallback_move_down => 'نقل لأسفل';

  @override
  String get fallback_routing_read_only =>
      'يحتفظ التطبيق بتفاصيل التوجيه أو بالمزوّد غير المدرج. عدّل المزوّد أو النموذج على المضيف. لا يزال بإمكانك تغيير ترتيب الإدخال أو إزالته.';

  @override
  String get cron_model_default => 'استخدام النموذج الافتراضي';

  @override
  String get cron_model_notice =>
      'ينطبق هذا الاختيار على مهمة cron هذه فقط. إذا لم تحدد لها نموذجًا بعينه، يستخدم Hermes نموذج cron الافتراضي، ثم النموذج الرئيسي. يمكنك إدارة النماذج المخصصة على المضيف.';

  @override
  String get model_management_unavailable =>
      'تعذّر تحميل إعدادات النماذج أو حفظها. حدّث الصفحة وحاول مجددًا.';

  @override
  String get model_management_subtitle =>
      'النموذج الرئيسي والنماذج الاحتياطية والمساعدة لهذا الملف الشخصي';

  @override
  String get usage => 'الاستخدام';

  @override
  String get nous_portal => 'بوابة Nous';

  @override
  String get portal_menu_subtitle => 'حالة البوابة والاستخدام المسجّل';

  @override
  String get portal_read_only =>
      'بيانات البوابة للقراءة فقط. يمكنك إدارة مصادقة Nous على مضيف Hermes. لا تتيح نقاط النهاية هذه معرفة رصيد الاشتراك أو الرصيد الائتماني.';

  @override
  String get portal_status => 'حالة اتصال البوابة بخدمة Nous Portal';

  @override
  String get portal_free_tier =>
      'وصول ضمن الباقة المجانية (من دون تسجيل الدخول إلى حساب)';

  @override
  String get portal_signed_in => 'تم تسجيل الدخول';

  @override
  String get portal_signed_out => 'لم يتم تسجيل الدخول';

  @override
  String get portal_account_tier => 'فئة الحساب';

  @override
  String get portal_recorded_usage => 'الاستخدام المسجّل';

  @override
  String get portal_all_providers =>
      'يشمل جميع المزوّدين في الملف الشخصي المحدد للبوابة. تسجيل تكلفة قدرها صفر لا يعني أن النموذج مجاني.';

  @override
  String portal_period(String days) {
    return 'آخر $days يومًا';
  }

  @override
  String get portal_sessions => 'الجلسات';

  @override
  String get portal_input => 'رموز الإدخال';

  @override
  String get portal_output => 'رموز الإخراج';

  @override
  String get portal_estimated => 'التكلفة التقديرية المسجّلة';

  @override
  String get portal_actual => 'التكلفة الفعلية المسجّلة';

  @override
  String get portal_recorded_models => 'النماذج المسجّلة';

  @override
  String get portal_no_models => 'لا توجد نماذج مسجّلة.';

  @override
  String get portal_unavailable =>
      'البيانات غير متاحة. تحقق من الاتصال والملف الشخصي المحدد وإصدار البوابة، ثم أعد المحاولة.';

  @override
  String get paste_attachment_failed_text_kept =>
      'تعذّر إرفاق المحتوى الملصق. بقي النص في الرسالة.';

  @override
  String get background_task_report => 'مهمة في الخلفية';

  @override
  String get background_process_report => 'عملية في الخلفية';

  @override
  String get background_report_issues =>
      'أُبلغ عن مشكلات. وسّع التقرير لعرض التفاصيل.';

  @override
  String get background_report_expand => 'توسيع التقرير';

  @override
  String get background_report_collapse => 'طيّ التقرير';

  @override
  String get ng_brand_open_chat => 'فتح محادثة';

  @override
  String get ng_brand_recent => 'الأخيرة';

  @override
  String get ng_brand_sidebar_hint => 'أو اختر محادثة من الشريط الجانبي';

  @override
  String get copy_session_id => 'نسخ معرّف الجلسة';

  @override
  String get copy_session_id_failed => 'تعذّر نسخ معرّف الجلسة.';

  @override
  String get setup_interface_title => 'اختر واجهتك';

  @override
  String get setup_interface_classic => 'Classic';

  @override
  String get setup_interface_nextgen => 'NextGen';

  @override
  String get setup_interface_classic_description =>
      'مساحة عمل Ares الأصلية، مع جميع أدوات التحكم في الاتصال وإعدادات واجهة Classic.';

  @override
  String get setup_interface_nextgen_description =>
      'واجهة أحدث تتيح تسجيل الدخول مرة واحدة إلى لوحة التحكم، ومتابعة الخطط مباشرة، واستخدام الوكلاء الفرعيين والإشعارات.';

  @override
  String get setup_interface_switch_later =>
      'يمكنك تبديل الواجهة في أي وقت من الإعدادات.';

  @override
  String get ng_confirm_model_switch => 'هل تريد تبديل النموذج؟';

  @override
  String get ng_switch => 'تبديل';

  @override
  String get ng_model_confirmation_required =>
      'يلزم التأكيد قبل اختيار هذا النموذج.';

  @override
  String ng_model_switches_next_turn(String model) {
    return 'سيُستخدم $model في الجولة التالية.';
  }

  @override
  String get ng_model_switch_not_connected =>
      'الدردشة غير جاهزة لتبديل النموذج. افتحها مجددًا وأعد المحاولة.';

  @override
  String ng_gateway_kept_default_model(String model) {
    return 'أبقت البوابة على $model لهذه الدردشة. أعد اختيار النموذج قبل الإرسال.';
  }

  @override
  String get hands_free_title => 'الاستخدام دون لمس';

  @override
  String get hands_free_start => 'بدء الاستخدام دون لمس';

  @override
  String get hands_free_stop => 'إيقاف الاستخدام دون لمس';

  @override
  String get hands_free_preparing => 'جارٍ تجهيز الصوت. انتظر إشارة الجاهزية';

  @override
  String get hands_free_listening => 'قل «Hey Hermes»';

  @override
  String get hands_free_recording => 'جاهز — تحدث الآن';

  @override
  String get hands_free_waiting => 'في انتظار Hermes';

  @override
  String get hands_free_speaking => 'جارٍ نطق الرد — الميكروفون مغلق';

  @override
  String hands_free_followup(int seconds) {
    return 'الاستماع لمدة تصل إلى $seconds ثانية';
  }

  @override
  String get hands_free_error => 'توقف وضع الاستخدام دون لمس';

  @override
  String get hands_free_setup => 'إعداد الاستخدام دون لمس';

  @override
  String hands_free_preview(String transcript) {
    return 'معاينة الإملاء الصوتي: $transcript';
  }

  @override
  String get hands_free_short_disclosure =>
      'يعمل هذا الوضع فقط عندما تكون هذه الدردشة مفتوحة في الواجهة. لا يتطلب رصد عبارة التنبيه اتصالًا، لكن الخدمات الصوتية قد تستخدم الشبكة. يستهلك الاستماع طاقة البطارية.';

  @override
  String get hands_free_error_action =>
      'تحقق من إذن الميكروفون وخدمة الكلام وصوت الرد والاتصال، ثم اضغط على زر الإيقاف يليه زر البدء لإعادة المحاولة. لن يُعاد إرسال أي شيء.';

  @override
  String get hands_free_disclosure =>
      'تُرصد عبارة التنبيه على وحدة المعالجة المركزية (CPU) دون اتصال. قد تستخدم خدمة التعرّف على الكلام في Android وصوت الرد المحدد والبوابة اتصالات الشبكة. يستهلك الاستماع طاقة البطارية وقد يتنشط الميكروفون بالخطأ. يتوقف الوضع إذا غطّت شاشة أخرى الدردشة أو أُغلقت أو انتقلت إلى الخلفية. لا يُستأنف تلقائيًا عند فتحها مجددًا. يبقى النص الذي تمليه يدويًا مسودة قابلة للتعديل.';

  @override
  String get hands_free_ready_cue =>
      'قل «Hey Hermes»، وانتظر إشارة «جاهز — تحدث الآن»، ثم تحدث. لا يُسجَّل الكلام المتصل بعبارة التنبيه، ولا ما سبق الإشارة. إذا انتقلت خارج التطبيق لضبط الإذن، فاضغط على زر البدء مجددًا بعد منحه.';

  @override
  String get hands_free_settings_title => 'التحكم الصوتي دون لمس';

  @override
  String get hands_free_settings_subtitle =>
      'إظهار زر بدء الاستماع لعبارة «Hey Hermes» في الدردشات. يؤدي تعطيل هذا الخيار إلى إيقاف أي جلسة نشطة للاستخدام دون لمس.';

  @override
  String get hands_free_timing_limit =>
      'مهلة انتظار المتابعة حد أقصى، وليست حدًا أدنى. قد يتوقف Android عن الاستماع قبل انتهائها. عند الصمت يعود التطبيق إلى رصد عبارة التنبيه محليًا دون تكرار تشغيل خدمة التعرّف على الكلام.';

  @override
  String get hands_free_followup_off =>
      'المتابعة معطّلة — قل «Hey Hermes» قبل كل طلب';

  @override
  String get hands_free_start_blocked =>
      'للبدء، يجب أن تكون المسودة فارغة وبلا مرفقات، وأن تكون الدردشة متصلة ولا تنفذ أي طلب، وأن تكون الردود المنطوقة مفعّلة. أنهِ أولًا أي إجراء صوتي بدأته يدويًا.';

  @override
  String get hands_free_setup_complete =>
      'اكتمل إعداد الميكروفون. اضغط على زر البدء مجددًا.';

  @override
  String message_time_recorded(String time) {
    return 'وقت التسجيل على الخادم: $time (بالتوقيت المحلي)';
  }

  @override
  String message_time_sent(String time) {
    return 'وقت رصد الإرسال على هذا الجهاز: $time (بالتوقيت المحلي)';
  }

  @override
  String message_time_received(String time) {
    return 'وقت أول استلام على هذا الجهاز: $time (بالتوقيت المحلي)';
  }

  @override
  String get stop_and_send => 'إيقاف وإرسال';

  @override
  String get message_queued_for_running_turn =>
      'أُضيفت الرسالة إلى قائمة انتظار التنفيذ الجاري.';

  @override
  String get running_message_not_accepted =>
      'تعذّر على Hermes قبول هذه الرسالة. ما زالت مسودتك محفوظة. أوقف الرد أو انتظر انتهاءه، ثم أعد الإرسال.';

  @override
  String get running_message_delivery_unknown =>
      'تعذّر تأكيد تسليم الرسالة. ما زالت مسودتك محفوظة. تحقق من الدردشة قبل إعادة المحاولة.';

  @override
  String get attachment_tap_to_preview => 'اضغط للمعاينة';

  @override
  String get attachment_save => 'حفظ';

  @override
  String get attachment_share => 'مشاركة';

  @override
  String get attachment_saved => 'حُفظ الملف';

  @override
  String get attachment_save_cancelled => 'أُلغي الحفظ';

  @override
  String get attachment_save_failed => 'تعذّر حفظ هذا الملف. حاول مجددًا.';

  @override
  String get attachment_share_failed => 'تعذّرت مشاركة هذا الملف. حاول مجددًا.';

  @override
  String get attachment_download_failed =>
      'تعذّر تحميل هذا الملف. تحقق من الاتصال وحاول مجددًا.';

  @override
  String get attachment_no_inline_preview =>
      'لا تتوفر معاينة داخل التطبيق لهذا النوع من الملفات. احفظ الملف الأصلي أو شاركه لفتحه في تطبيق آخر.';

  @override
  String get attachment_image_failed =>
      'تعذّر فك ترميز هذه الصورة. لا يزال بإمكانك حفظ الملف الأصلي أو مشاركته.';

  @override
  String get attachment_text_truncated =>
      'المعاينة مختصرة. احفظ الملف أو شاركه لقراءته كاملًا.';

  @override
  String get attachment_text_unavailable =>
      'تعذّر عرض هذا الملف كنص. احفظ الملف الأصلي أو شاركه.';

  @override
  String get attachment_pdf_failed =>
      'تعذّرت معاينة ملف PDF هذا. احفظ الملف الأصلي أو شاركه.';

  @override
  String get attachment_pdf_unavailable =>
      'تتوفر معاينة ملفات PDF على Android. لا يزال بإمكانك حفظ هذا الملف أو مشاركته.';

  @override
  String attachment_pdf_page(int page, int total) {
    return 'الصفحة $page من $total';
  }

  @override
  String get attachment_previous_page => 'الصفحة السابقة';

  @override
  String get attachment_next_page => 'الصفحة التالية';

  @override
  String get attachment_loading => 'جارٍ تحميل المعاينة…';

  @override
  String get attachment_document_text_notice =>
      'هذه معاينة نصية. قد يختلف تخطيط المستند وصوره وتنسيقه عن الأصل.';

  @override
  String get attachment_document_failed =>
      'تعذّرت معاينة هذا المستند. احفظ الملف الأصلي أو شاركه.';

  @override
  String get attachment_document_empty =>
      'لم يُعثر على نص قابل للقراءة في هذا المستند.';

  @override
  String get attachment_video_failed =>
      'تعذّر تشغيل هذا الفيديو. قد لا يكون تنسيقه أو برنامج الترميز المستخدم مدعومًا. احفظ الملف الأصلي أو شاركه.';

  @override
  String get attachment_video_play => 'تشغيل';

  @override
  String get attachment_video_pause => 'إيقاف مؤقت';

  @override
  String get attachment_video_mute => 'كتم الصوت';

  @override
  String get attachment_video_unmute => 'إلغاء كتم الصوت';

  @override
  String get attachment_video_seek => 'موضع التشغيل في الفيديو';

  @override
  String get attachment_close => 'إغلاق المعاينة';

  @override
  String get attachment_retry => 'إعادة المحاولة';

  @override
  String get saved_history_heading => 'السجل المحفوظ';

  @override
  String get received_output_heading =>
      'المخرجات المستلَمة — لم تتأكد مطابقتها للسجل المحفوظ';

  @override
  String get received_output_details => 'حول المخرجات المستلَمة';

  @override
  String get received_output_explanation =>
      'قد تظهر هذه المخرجات أيضًا في السجل المحفوظ. لا يستطيع التطبيق تأكيد تطابقها معه.';

  @override
  String get local_prompt_context => 'السياق المحلي للطلب';

  @override
  String get received_output_badge => 'مستلَم · لم يتأكد التطابق';

  @override
  String get received_output_lifetime =>
      'تُحفظ المخرجات المستلَمة مؤقتًا خلال جلسة التطبيق هذه، وقد تُختصر أو تُزال عند بلوغ حدود التخزين. وقد لا تبقى متاحة بعد إغلاق التطبيق أو قطع الاتصال.';

  @override
  String get theme_palette => 'نَسق الألوان';

  @override
  String get theme_palette_gold => 'ذهبي';

  @override
  String get theme_palette_purple => 'بنفسجي';

  @override
  String get theme_palette_orange => 'برتقالي';

  @override
  String get theme_palette_green => 'أخضر';

  @override
  String get theme_palette_blue => 'أزرق';

  @override
  String get theme_palette_red => 'أحمر';

  @override
  String get theme_palette_teal => 'أخضر مزرقّ';

  @override
  String get theme_palette_pink => 'وردي';

  @override
  String get theme_palette_indigo => 'نيلي';

  @override
  String get theme_palette_cyan => 'سماوي';

  @override
  String get assets_recent_subtitle =>
      'اعثر على الملفات التي شاركها Hermes في الدردشات المحفوظة';

  @override
  String get assets_scope_notice =>
      'تظهر هنا الملفات التي أُنشئت وشاركها Hermes صراحةً في الردود المحفوظة. هذه نظرة جزئية على سجل الدردشة وليست قائمة شاملة بالملفات أو المرفقات. قد لا تعود الملفات المشار إليها موجودة.';

  @override
  String get assets_download_limit =>
      'لا تُحمّل الملفات إلا عند الضغط عليها. الحد الأقصى لكل معاينة أو تنزيل هو 25 MiB. استخدم لوحة التحكم للملفات الأكبر.';

  @override
  String get assets_search_hint =>
      'ابحث في الملفات التي عُثر عليها أو في دردشاتها الأصلية';

  @override
  String get assets_all => 'الكل';

  @override
  String get assets_images => 'الصور';

  @override
  String get assets_audio => 'الصوتيات';

  @override
  String get assets_video => 'الفيديو';

  @override
  String get assets_documents => 'المستندات والملفات الأخرى';

  @override
  String get assets_empty => 'لم يُعثر على ملفات في الرسائل المفحوصة';

  @override
  String get assets_empty_detail =>
      'افحص مزيدًا من الدردشات أو رسائل أقدم لتوسيع نطاق البحث. لا تشمل الفهرسة هنا المرفقات العادية ولا الملفات التي لا توجد روابط لها.';

  @override
  String get assets_no_matches => 'لا توجد ملفات مطابقة';

  @override
  String get assets_load_more_chats => 'فحص مزيد من الدردشات';

  @override
  String get assets_load_older_messages => 'فحص رسائل أقدم';

  @override
  String get assets_load_failed =>
      'تعذّرت قراءة جزء من السجل، لذا فالنتائج غير مكتملة. تحقق من الاتصال بلوحة التحكم وأعد المحاولة.';

  @override
  String get assets_retry_failed =>
      'إعادة محاولة قراءة الأجزاء المتعذّرة من السجل';

  @override
  String get assets_partial =>
      'أفاد الخادم بأن السجل غير مكتمل. تحقق من لوحة التحكم ثم حدّث النتائج.';

  @override
  String assets_scan_summary(int files, int chats) {
    return 'عدد الإشارات إلى الملفات: $files، وعدد الدردشات المفحوصة: $chats';
  }

  @override
  String assets_open_chat(String title) {
    return 'فتح الدردشة: $title';
  }

  @override
  String get assets_file_too_large =>
      'يتجاوز هذا الملف حد التنزيل. افتح لوحة التحكم لتنزيله.';

  @override
  String get a_one_off_question_archives_itself_after_72_hours_anything =>
      'دردشة لسؤال واحد تُؤرشف تلقائيًا بعد 72 ساعة، ويظل ما يستحق الاحتفاظ به في الذاكرة.';

  @override
  String get archive_chat => 'أرشفة الدردشة';

  @override
  String get unarchive_chat => 'إلغاء أرشفة الدردشة';

  @override
  String get chat_archived => 'أُرشفت الدردشة';

  @override
  String get chat_unarchived => 'أُعيدت الدردشة من الأرشيف';

  @override
  String could_not_update_chat_archive(Object error) {
    return 'تعذّر تحديث حالة أرشفة الدردشة: $error';
  }

  @override
  String get quick_chat_description => 'دردشة لسؤال واحد.';

  @override
  String get ai_full_text => 'الذكاء الاصطناعي والبحث في النص الكامل';

  @override
  String get ai_search_model => 'نموذج البحث بالذكاء الاصطناعي';

  @override
  String ai_searched_for(Object aiRewrittenQuery) {
    return 'بحث الذكاء الاصطناعي عن: $aiRewrittenQuery';
  }

  @override
  String get ai_assisted_filing => 'التصنيف بمساعدة الذكاء الاصطناعي';

  @override
  String get api_key => 'مفتاح API';

  @override
  String get api_server_key_from_hermes_env =>
      'قيمة API_SERVER_KEY من الملف ~/.hermes/.env';

  @override
  String get active => 'نشط';

  @override
  String get activity => 'النشاط';

  @override
  String get activity_reads_the_durable_turn_journal_to_know_what_hermes =>
      'يعرض قسم النشاط ما يفعله Hermes استنادًا إلى سجل الجولات الدائم. تحقق من إمكانية الوصول إلى البوابة، ثم أعد المحاولة.';

  @override
  String get add => 'إضافة';

  @override
  String get add_connection => 'إضافة اتصال';

  @override
  String get add_cron_job => 'إضافة مهمة cron';

  @override
  String get add_gateway_connection => 'إضافة اتصال ببوابة';

  @override
  String get add_and_update_connections_from_the_backup_keep_the_rest =>
      'إضافة الاتصالات وتحديثها من النسخة الاحتياطية مع إبقاء بقية الاتصالات كما هي.';

  @override
  String get add_attachment => 'إضافة مرفق';

  @override
  String get add_new_cron_job => 'إضافة مهمة cron جديدة';

  @override
  String get add_to_chat => 'إضافة إلى الدردشة';

  @override
  String get all_chats => 'كل الدردشات';

  @override
  String get all_stored_message_content => 'جميع محتويات الرسائل المخزّنة';

  @override
  String get allow_for_this_session => 'السماح لهذه الجلسة';

  @override
  String get allow_matching_commands_until_this_hermes_session_ends =>
      'السماح بالأوامر المطابقة حتى انتهاء جلسة Hermes هذه.';

  @override
  String get allow_folder_until_sandbox_off =>
      'السماح بهذا المجلد حتى إيقاف بيئة العزل.';

  @override
  String get allow_once => 'السماح مرة واحدة';

  @override
  String get allow_website_until_sandbox_off =>
      'السماح بهذا الموقع حتى إيقاف بيئة العزل.';

  @override
  String get always_allow => 'السماح دائمًا';

  @override
  String get apply_to_this_chat => 'تطبيق على هذه الدردشة';

  @override
  String get approval_needed => 'الموافقة مطلوبة';

  @override
  String get approval_needed_description => 'هناك أمر ينتظر موافقتك أو رفضك.';

  @override
  String get approve => 'موافقة';

  @override
  String get archive => 'أرشفة';

  @override
  String get archive_project => 'أرشفة المشروع';

  @override
  String archive_2(Object projectName) {
    return 'هل تريد أرشفة $projectName؟';
  }

  @override
  String archive_3(Object name) {
    return 'هل تريد أرشفة $name؟';
  }

  @override
  String get archived => 'مؤرشف';

  @override
  String get archived_conversations_appear_here =>
      'تظهر هنا المحادثات المؤرشفة فقط. تبقى الدردشات القديمة ضمن «كل الدردشات».';

  @override
  String get archived_quick_chats => 'الدردشات السريعة المؤرشفة';

  @override
  String get artifacts_attachments_and_generated_media =>
      'الملفات الناتجة والمرفقات والوسائط المُولَّدة';

  @override
  String get ask_ai_to_find_a_conversation =>
      'اطلب من الذكاء الاصطناعي العثور على محادثة';

  @override
  String get assets => 'الملفات';

  @override
  String get assets_need_a_server_authoritative_assets_index_in_the_hermes =>
      'لعرض الملفات حسب المشروع، يجب أن توفر بوابة Hermes فهرسًا للملفات يديره الخادم ويُعتمد عليه مرجعًا.';

  @override
  String get assets_unavailable => 'الملفات غير متاحة';

  @override
  String get attach_image_or_file => 'إرفاق صورة أو ملف';

  @override
  String get attachment_drafts => 'مسودات المرفقات';

  @override
  String get recover_text_draft => 'استعادة مسودة نصية';

  @override
  String get undo_draft_recovery => 'تراجع';

  @override
  String get draft_session_exists =>
      'لا تزال هذه المحادثة موجودة. افتحها لمتابعة مسودتك.';

  @override
  String get draft_recovery_unavailable =>
      'تعذّر التحقق من هذه المسودة. لم يتغيّر أي شيء.';

  @override
  String attachment_of(Object index, Object total) {
    return 'المرفق $index من $total';
  }

  @override
  String get auto_device_default => 'تلقائي (إعداد الجهاز الافتراضي)';

  @override
  String get agent => 'الوكيل';

  @override
  String get autonomous_agents => 'الوكلاء المستقلون';

  @override
  String get background_recovery_unavailable_legacy_transport =>
      'الاستعادة في الخلفية غير متاحة بسبب استخدام آلية اتصال قديمة';

  @override
  String get background_task_completed => 'اكتملت المهمة في الخلفية';

  @override
  String get background_task_completed_description =>
      'اكتمل تنفيذ أمر في الطرفية كان يعمل في الخلفية.';

  @override
  String get backup_restore => 'النسخ الاحتياطي والاستعادة';

  @override
  String backup_exported(Object destination) {
    return 'صُدّرت النسخة الاحتياطية إلى $destination';
  }

  @override
  String get base_url => 'عنوان URL الأساسي';

  @override
  String get binary_preview_is_unavailable_download_the_file_to_open_it =>
      'لا تتوفر معاينة للملف الثنائي. نزّل الملف لفتحه.';

  @override
  String get branch => 'إنشاء فرع';

  @override
  String get branch_chat => 'إنشاء فرع من الدردشة';

  @override
  String get branch_created_in_hermes_history => 'أُنشئ فرع في سجل Hermes.';

  @override
  String get browse_and_manage_your_hermes_agent_sessions_from_your_phone =>
      'تصفّح جلسات Hermes Agent وأدرها من هاتفك. يتصل التطبيق بلوحة تحكم Hermes التي تعمل على شبكتك المحلية.';

  @override
  String get browse_server_files => 'تصفّح ملفات الخادم';

  @override
  String get browse_the_miniserver_folders_behind_your_projects =>
      'تصفّح مجلدات الخادم المصغّر التي تستند إليها مشاريعك';

  @override
  String get cancel => 'إلغاء';

  @override
  String get cancel_voice_input => 'إلغاء الإدخال الصوتي';

  @override
  String cannot_reach(Object host, Object port) {
    return 'تعذّر الوصول إلى $host:$port.';
  }

  @override
  String cannot_reach_check_the_host_and_port(Object host, Object port) {
    return 'تعذّر الوصول إلى $host:$port. تحقق من المضيف والمنفذ.';
  }

  @override
  String get change_ai_search_model => 'تغيير نموذج البحث بالذكاء الاصطناعي';

  @override
  String changes_the_default_for_use_the_selector_in_a_chat(Object label) {
    return 'يغيّر الإعداد الافتراضي لـ $label. لتغييره لمحادثة واحدة فقط، استخدم أداة الاختيار داخل تلك الدردشة.';
  }

  @override
  String get chat_actions => 'إجراءات الدردشة';

  @override
  String get chats => 'الدردشات';

  @override
  String get chats_from_this_gateway_are_not_grouped_yet_grouping_stays =>
      'لم تُجمع دردشات هذه البوابة في مشاريع بعد. يبقى تنظيمها محليًا على هذا الهاتف إلى أن تدعم البوابة استضافة المشاريع.';

  @override
  String get chats_in_this_project_will_show_their_state_and_last =>
      'تظهر هنا حالة كل دردشة في هذا المشروع وآخر نشاط فيها.';

  @override
  String get chats_that_are_not_assigned_to_a_project =>
      'الدردشات التي لا تنتمي إلى أي مشروع';

  @override
  String get chats_you_start_in_this_project_will_appear_here_on =>
      'ستظهر هنا الدردشات التي تبدأها في هذا المشروع، على كل جهاز سجّلت دخوله إلى خادم Hermes هذا.';

  @override
  String get check_that_the_gateway_is_running_and_reachable_then_try =>
      'تحقق من أن البوابة تعمل ويمكن الوصول إليها، ثم أعد المحاولة.';

  @override
  String get check_the_dashboard_connection_and_try_again =>
      'تحقق من الاتصال بلوحة التحكم وحاول مجددًا.';

  @override
  String get check_the_connection_and_try_again =>
      'تحقق من الاتصال وحاول مجددًا.';

  @override
  String get choose_a_small_model_to_rewrite_queries =>
      'اختر نموذجًا صغيرًا لإعادة صياغة استعلامات البحث';

  @override
  String get choose_an_ai_search_model_before_using_ai_search =>
      'اختر نموذجًا للبحث بالذكاء الاصطناعي قبل استخدامه.';

  @override
  String get choose_an_active_project_next =>
      'اختر مشروعًا نشطًا في الخطوة التالية';

  @override
  String get choose_chat_model => 'اختيار نموذج الدردشة';

  @override
  String get choose_files => 'اختيار ملفات';

  @override
  String get choose_image => 'اختيار صورة';

  @override
  String get choose_images => 'اختيار صور';

  @override
  String get choose_its_destination_space =>
      'اختر المساحة التي تريد نقله إليها';

  @override
  String get clear_search => 'مسح البحث';

  @override
  String get close => 'إغلاق';

  @override
  String get code_copied => 'نُسخت الشيفرة';

  @override
  String get code_format => 'شيفرة';

  @override
  String get coming_next => 'قريبًا';

  @override
  String get command => 'الأمر';

  @override
  String get command_palette => 'لوحة الأوامر';

  @override
  String get command_palette_hint => 'اكتب أمرًا';

  @override
  String get command_palette_no_results => 'لم يُعثر على أوامر';

  @override
  String get command_palette_new_chat => 'دردشة جديدة';

  @override
  String get command_palette_search_chats => 'البحث في الدردشات';

  @override
  String get command_palette_toggle_theme => 'تبديل المظهر';

  @override
  String get command_palette_copy_last_code => 'نسخ آخر كتلة شيفرة';

  @override
  String get command_line_chats => 'دردشات سطر الأوامر';

  @override
  String get compatibility_mode => 'وضع التوافق';

  @override
  String get configure_a_valid_desktop_gateway_url_before_attaching_files =>
      'أدخل عنوان URL صالحًا لبوابة سطح المكتب قبل إرفاق الملفات.';

  @override
  String get confirm_always_allow => 'تأكيد السماح الدائم';

  @override
  String get confirm_passphrase => 'تأكيد عبارة المرور';

  @override
  String connecting_to(Object baseUrl) {
    return 'جارٍ الاتصال بـ $baseUrl...';
  }

  @override
  String get connection_issue => 'مشكلة في الاتصال';

  @override
  String
  get connection_switched_the_running_reply_continues_on_the_server_and =>
      'تبدّل الاتصال. يستمر إنشاء الرد على الخادم، وسيتصل التطبيق به مجددًا بشكل تلقائي.';

  @override
  String get connection_appearance_and_device_preferences =>
      'الاتصال والمظهر وتفضيلات الجهاز';

  @override
  String context_tokens(Object effectiveContextLength) {
    return 'طول السياق بالرموز: $effectiveContextLength';
  }

  @override
  String get continue_label => 'متابعة';

  @override
  String get continue_working => 'متابعة العمل';

  @override
  String get conversations_in_this_project => 'المحادثات في هذا المشروع';

  @override
  String get copy_code => 'نسخ الشيفرة';

  @override
  String get copy_message => 'نسخ الرسالة';

  @override
  String could_not_branch_chat(Object error) {
    return 'تعذّر إنشاء فرع من الدردشة: $error';
  }

  @override
  String could_not_delete_session(Object error) {
    return 'تعذّر حذف الجلسة: $error';
  }

  @override
  String could_not_deny_the_command(Object error) {
    return 'تعذّر رفض الأمر: $error';
  }

  @override
  String could_not_load_ai_search_models(Object error) {
    return 'تعذّر تحميل نماذج البحث بالذكاء الاصطناعي: $error';
  }

  @override
  String get could_not_load_conversations => 'تعذّر تحميل المحادثات';

  @override
  String get could_not_load_files => 'تعذّر تحميل الملفات';

  @override
  String could_not_load_models_for_this_profile(Object error) {
    return 'تعذّر تحميل نماذج هذا الملف الشخصي: $error';
  }

  @override
  String could_not_load_more_chats(Object error) {
    return 'تعذّر تحميل مزيد من الدردشات: $error';
  }

  @override
  String get could_not_open_link => 'تعذّر فتح هذا الرابط.';

  @override
  String get could_not_open_the_hermes_dashboard =>
      'تعذّر فتح لوحة تحكم Hermes.';

  @override
  String get could_not_open_this_project => 'تعذّر فتح هذا المشروع';

  @override
  String get could_not_preview_file => 'تعذّرت معاينة الملف';

  @override
  String get could_not_reach_hermes => 'تعذّر الوصول إلى Hermes';

  @override
  String could_not_reach_authenticate_the_dashboard_at_check_the_port(
    Object dashboardPort,
    Object host,
  ) {
    return 'تعذّر الوصول إلى لوحة التحكم على $host:$dashboardPort أو إتمام المصادقة. تحقق من المنفذ وبيانات الاعتماد.';
  }

  @override
  String get could_not_read_activity => 'تعذّرت قراءة سجل النشاط';

  @override
  String could_not_rename_chat(Object error) {
    return 'تعذّر تغيير اسم الدردشة: $error';
  }

  @override
  String could_not_send_the_approval(Object error) {
    return 'تعذّر إرسال الموافقة: $error';
  }

  @override
  String get could_not_skip_the_hermes_question => 'تعذّر تخطي سؤال Hermes.';

  @override
  String could_not_the_project(Object action, Object error) {
    return 'تعذّر تنفيذ الإجراء «$action» على المشروع: $error';
  }

  @override
  String get couldn_t_delete_project => 'تعذّر حذف المشروع';

  @override
  String couldn_t_load_runs(Object error) {
    return 'تعذّر تحميل سجل التشغيل: $error';
  }

  @override
  String get couldn_t_move_conversation => 'تعذّر نقل المحادثة';

  @override
  String couldn_t_move_to(Object label, Object reason) {
    return 'تعذّر النقل إلى $label: $reason';
  }

  @override
  String get couldn_t_prepare_the_shared_files =>
      'تعذّر تجهيز الملفات المشتركة.';

  @override
  String get couldn_t_promote_conversation => 'تعذّرت إضافة المحادثة إلى مشروع';

  @override
  String couldn_t_project(Object action) {
    return 'تعذّر تنفيذ الإجراء «$action» على المشروع';
  }

  @override
  String get create => 'إنشاء';

  @override
  String get create_a_project => 'إنشاء مشروع';

  @override
  String get create_a_project_first_then_chats_can_live_inside_it =>
      'أنشئ مشروعًا أولًا لتتمكن من جمع الدردشات فيه.';

  @override
  String get create_a_space_to_separate_related_conversations =>
      'أنشئ مساحة تجمع المحادثات المرتبطة ببعضها بعيدًا عن غيرها.';

  @override
  String get create_branch => 'إنشاء فرع';

  @override
  String get credit_notifications => 'إشعارات الرصيد';

  @override
  String get credit_notifications_description =>
      'تنبيهات عند إيقاف استخدام الرصيد أو استئنافه.';

  @override
  String get cron => 'Cron';

  @override
  String get crons => 'الجدولة';

  @override
  String get cron_conversations_empty =>
      'تظهر هنا محادثات المهام المجدولة، بما فيها محادثات مرات التشغيل السابقة.';

  @override
  String get search_cron_conversations => 'البحث في محادثات مهام cron';

  @override
  String get cron_jobs => 'مهام cron';

  @override
  String cron_schedule_timezone(Object zone) {
    return 'المنطقة الزمنية للجدول: $zone';
  }

  @override
  String get crons_upcoming => 'القادمة';

  @override
  String get crons_history => 'السجل';

  @override
  String cron_time_with_zone(Object time, Object zone) {
    return '$time ($zone)';
  }

  @override
  String cron_time_zone_unknown(Object time) {
    return '$time (المنطقة الزمنية غير معروفة)';
  }

  @override
  String get cron_no_next_run => 'لا يوجد موعد تشغيل تالٍ';

  @override
  String get cron_status_scheduled => 'مجدولة';

  @override
  String get cron_status_paused => 'متوقفة مؤقتًا';

  @override
  String cron_delivers_to(Object target) {
    return 'وجهة التسليم: $target';
  }

  @override
  String get cron_upcoming_empty_title => 'لا توجد مهام مجدولة';

  @override
  String get cron_upcoming_empty_message =>
      'لا توجد مهام بانتظار التشغيل. أنشئ مهمة في «مهام cron» أو اطلب من الوكيل جدولة مهمة.';

  @override
  String get cron_upcoming_unavailable => 'المهام المجدولة غير متاحة';

  @override
  String get cron_upcoming_needs_dashboard =>
      'تتطلب المهام المجدولة اتصالًا بلوحة التحكم. لا يتيح هذا العنوان الاطلاع على جدول cron. تحقق من عنوان لوحة التحكم ومن دعم المضيف لهذه الميزة.';

  @override
  String get cron_upcoming_needs_dashboard_auth =>
      'تتطلب المهام المجدولة المصادقة لدى لوحة التحكم. أضف اسم المستخدم وكلمة المرور للوحة التحكم الخاصة بهذا الاتصال، أو فعّل وضع الاتصال عبر وكيل الشبكة.';

  @override
  String get cron_upcoming_dashboard_unreachable =>
      'تعذّر الوصول إلى لوحة التحكم. تحقق من المضيف ومنفذ لوحة التحكم والشبكة، ثم أعد المحاولة.';

  @override
  String get cron_upcoming_load_failed =>
      'تعذّرت قراءة المهام المجدولة. تحقق من الاتصال بلوحة التحكم، ثم أعد المحاولة.';

  @override
  String get cron_upcoming_refresh_failed =>
      'تعذّر تحديث الجدول. المعروض هو آخر جدول أمكن تحميله.';

  @override
  String get cron_job_added => 'أُضيفت مهمة cron';

  @override
  String get cron_job_updated => 'حُدّثت مهمة cron';

  @override
  String get cron_run => 'تشغيل مهمة cron';

  @override
  String get cross_device_ordering_and_reversible_bulk_organization =>
      'ترتيب موحّد عبر الأجهزة وتنظيم جماعي يمكن التراجع عنه';

  @override
  String get current_profile_default => 'الإعداد الافتراضي للملف الشخصي الحالي';

  @override
  String get custom_proxy_and_dashboard_details =>
      'تفاصيل وكيل الشبكة ولوحة التحكم المخصّصة';

  @override
  String get dark => 'داكن';

  @override
  String get dashboard_proxy_settings => 'إعدادات لوحة التحكم ووكيل الشبكة';

  @override
  String get dashboard_password_optional => 'كلمة مرور لوحة التحكم (اختيارية)';

  @override
  String get dashboard_port => 'منفذ لوحة التحكم';

  @override
  String get dashboard_username_optional => 'اسم مستخدم لوحة التحكم (اختياري)';

  @override
  String get dashboard_behind_proxy => 'لوحة التحكم خلف وكيل شبكة';

  @override
  String get dashboard_path_prefix => 'بادئة مسار لوحة التحكم';

  @override
  String delegated_task(Object goal) {
    return 'المهمة المفوّضة: $goal';
  }

  @override
  String get delete => 'حذف';

  @override
  String delete_2(Object name) {
    return 'هل تريد حذف «$name»؟';
  }

  @override
  String delete_from_the_remote_hermes_history_this_cannot_be_undone(
    Object title,
  ) {
    return 'هل تريد حذف «$title» من سجل Hermes البعيد؟ لا يمكن التراجع عن الحذف.';
  }

  @override
  String get delete_cron_job => 'حذف مهمة Cron';

  @override
  String get delete_connections_that_are_not_in_the_backup =>
      'احذف الاتصالات غير الموجودة في النسخة الاحتياطية.';

  @override
  String delete_failed(Object error) {
    return 'تعذّر الحذف: $error';
  }

  @override
  String get delete_project => 'حذف المشروع';

  @override
  String get delete_session => 'هل تريد حذف الجلسة؟';

  @override
  String delete_3(Object projectName) {
    return 'هل تريد حذف $projectName؟';
  }

  @override
  String deleted(Object name) {
    return 'حُذف «$name»';
  }

  @override
  String get delivery_is_uncertain_recovering_without_resending =>
      'لم يتأكد التسليم؛ تجري محاولة الاستعادة دون إعادة الإرسال…';

  @override
  String get desktop_gateway_url_optional =>
      'عنوان URL لبوابة Desktop Gateway (اختياري)';

  @override
  String get desktop_gateway_is_not_configured_for_this_connection =>
      'لم تُضبط بوابة سطح المكتب (Desktop Gateway) لهذا الاتصال.';

  @override
  String get desktop_app => 'تطبيق سطح المكتب';

  @override
  String get developer_tool_calls => 'استدعاءات الأدوات للمطوّرين';

  @override
  String get discord_chats => 'محادثات Discord';

  @override
  String get dismiss => 'إغلاق';

  @override
  String get do_not_run_this_command => 'لا تشغّل هذا الأمر.';

  @override
  String get documents_archives_audio_video_or_data =>
      'مستندات أو أرشيفات أو ملفات صوت أو فيديو أو بيانات';

  @override
  String get download => 'تنزيل';

  @override
  String download_failed(Object error) {
    return 'تعذّر التنزيل: $error';
  }

  @override
  String get durable_facts_hermes_keeps_about_you =>
      'معلومات يحتفظ بها Hermes عنك على المدى الطويل';

  @override
  String get durable_work_inside_one_of_your_projects_shared_with_desktop =>
      'عمل محفوظ ضمن أحد مشاريعك ومشترك مع تطبيق سطح المكتب.';

  @override
  String get edit => 'تعديل';

  @override
  String get edit_connection => 'تعديل الاتصال';

  @override
  String get edit_cron_job => 'تعديل مهمة Cron';

  @override
  String get edit_gateway_connection => 'تعديل الاتصال بالبوابة';

  @override
  String get edit_and_resend => 'تعديل وإعادة إرسال';

  @override
  String get enable_notifications => 'تفعيل الإشعارات';

  @override
  String get enable_notifications_description =>
      'يؤدي إيقاف هذا الخيار إلى تعطيل جميع الإشعارات أدناه.';

  @override
  String get enables_file_attachments_through_the_desktop_remote_gateway =>
      'يتيح إرفاق الملفات عبر بوابة سطح المكتب البعيدة.';

  @override
  String get enter_a_name => 'أدخل اسمًا';

  @override
  String get enter_a_passphrase => 'أدخل عبارة مرور.';

  @override
  String get enter_the_passphrase_for_this_backup =>
      'أدخل عبارة المرور لهذه النسخة الاحتياطية.';

  @override
  String get every_conversation_is_already_assigned_to_a_project =>
      'كل محادثة مرتبطة بمشروع بالفعل.';

  @override
  String get everything_not_yet_native_in_the_authenticated_web_dashboard =>
      'الميزات التي لم تُدمج بعد في التطبيق متاحة في لوحة تحكم الويب بعد تسجيل الدخول';

  @override
  String get explain_the_attached_content_clearly =>
      'اشرح المحتوى المرفق بوضوح.';

  @override
  String explain_this_content_clearly(Object text) {
    return 'اشرح هذا المحتوى بوضوح:\n\n$text';
  }

  @override
  String
  get explicit_choices_adjust_android_accessibility_text_size_system_leaves_it =>
      'يؤدي اختيار حجم محدد إلى تغيير حجم النص في إعدادات تسهيل الاستخدام على Android. أما خيار «النظام» فيُبقي الحجم كما هو.';

  @override
  String get export_label => 'تصدير';

  @override
  String get export_share => 'تصدير / مشاركة';

  @override
  String get external_api_clients => 'تطبيقات خارجية تستخدم واجهة API';

  @override
  String get extra_high => 'مرتفع جدًا';

  @override
  String get extract_tasks => 'استخراج المهام';

  @override
  String
  get extract_the_decisions_deadlines_owners_and_actionable_action_items_from =>
      'استخرج من المحتوى المرفق القرارات والمواعيد النهائية وأسماء المسؤولين والخطوات المطلوب تنفيذها.';

  @override
  String
  extract_the_decisions_deadlines_owners_and_actionable_action_items_from_2(
    Object text,
  ) {
    return 'استخرج من المحتوى التالي القرارات والمواعيد النهائية وأسماء المسؤولين والخطوات المطلوب تنفيذها:\n\n$text';
  }

  @override
  String failed_to_add_job(Object error) {
    return 'تعذّرت إضافة المهمة: $error';
  }

  @override
  String get failed_to_load_cron_jobs => 'تعذّر تحميل مهام cron';

  @override
  String get failed_to_load_memory => 'تعذّر تحميل الذاكرة';

  @override
  String get failed_to_load_messages => 'تعذّر تحميل الرسائل';

  @override
  String get failed_to_load_settings => 'تعذّر تحميل الإعدادات';

  @override
  String get failed_to_load_skills => 'تعذّر تحميل المهارات';

  @override
  String failed_to_update_job(Object error) {
    return 'تعذّر تحديث المهمة: $error';
  }

  @override
  String failed(Object error) {
    return 'فشلت العملية: $error';
  }

  @override
  String get file_attached_document_catalog_registration_is_pending =>
      'أُرفق الملف، ولم يُسجّل بعد في فهرس المستندات.';

  @override
  String get file_reference_added_to_chat => 'أُضيف مرجع الملف إلى المحادثة';

  @override
  String get files => 'الملفات';

  @override
  String get fill_from_document => 'تعبئة من مستند';

  @override
  String get folder_is_empty => 'المجلد فارغ';

  @override
  String get folders => 'المجلدات';

  @override
  String get full_text => 'النص الكامل';

  @override
  String get gateway_api_access => 'الوصول إلى واجهة API للبوابة';

  @override
  String get gateway_connected_but_the_dashboard_could_not_be_reached_or =>
      'تم الاتصال بالبوابة، لكن تعذّر الوصول إلى لوحة التحكم أو التحقق من الهوية. تحقّق من بيانات لوحة التحكم، أو امسحها لتخطّي هذه الخطوة.';

  @override
  String get gateway_path_prefix => 'بادئة مسار البوابة';

  @override
  String get go_to_end => 'الانتقال إلى النهاية';

  @override
  String get hermes_agent => 'Ares - المعروف سابقًا باسم Hermes Android';

  @override
  String get hermes_agent_for_android =>
      'Ares - المعروف سابقًا باسم Hermes Android';

  @override
  String get hermes_could_not_accept_the_answer_please_try_again =>
      'تعذّر على Hermes قبول الإجابة. حاول مجددًا.';

  @override
  String get hermes_could_not_load_your_saved_connections =>
      'تعذّر على Hermes تحميل اتصالاتك المحفوظة';

  @override
  String get hermes_did_not_accept_the_response_please_try_again =>
      'لم يقبل Hermes الرد. حاول مجددًا.';

  @override
  String get hermes_is_responding => 'يكتب Hermes ردًا…';

  @override
  String get hermes_is_waiting_for_input => 'ينتظر Hermes ردّك…';

  @override
  String get hermes_keeps_android_accessibility_text_scaling_active =>
      'يحافظ Ares على تفعيل تحجيم النص وفق إعدادات تسهيل الاستخدام في Android.';

  @override
  String get hermes_needs_your_input => 'يحتاج Hermes إلى ردّك';

  @override
  String get hermes_profile_optional => 'ملف Hermes الشخصي (اختياري)';

  @override
  String get hermes_profile_must_be_a_plain_profile_name_such_as =>
      'أدخل اسم ملف Hermes الشخصي فقط، مثل \"sol\"، وليس مسارًا.';

  @override
  String get hermes_reasoning_details => 'تفاصيل استدلال Hermes';

  @override
  String hermes_recovery_is_unavailable(Object error) {
    return 'استعادة Hermes غير متاحة: $error';
  }

  @override
  String get hermes_stopped_recovery_safely_no_prompt_was_resent =>
      'أوقف Hermes الاستعادة بأمان. لم يُعَد إرسال أي طلب.';

  @override
  String get hide_passphrase => 'إخفاء عبارة المرور';

  @override
  String get home_needs_your_recent_chats_to_know_what_deserves_your =>
      'تحتاج الصفحة الرئيسية إلى محادثاتك الأخيرة لتعرض ما يستحق انتباهك. تأكّد من إمكانية الوصول إلى البوابة، ثم حاول مجددًا.';

  @override
  String get host => 'المضيف';

  @override
  String get image_selection_was_interrupted_try_again =>
      'توقفت عملية اختيار الصورة قبل اكتمالها. حاول مجددًا.';

  @override
  String get import_label => 'استيراد';

  @override
  String get inbox => 'صندوق الوارد';

  @override
  String get inbox_is_clear => 'صندوق الوارد فارغ';

  @override
  String get input_needed => 'مطلوب ردّ منك';

  @override
  String get input_needed_description =>
      'طرح Hermes سؤالًا أو يحتاج إلى كلمة مرور أو معلومة سرية.';

  @override
  String get insert_a_remote_file_reference => 'إدراج مرجع @file لملف بعيد';

  @override
  String get invalid_port_number => 'رقم المنفذ غير صالح.';

  @override
  String get job_paused => 'أُوقفت المهمة مؤقتًا';

  @override
  String get job_resumed => 'استُؤنفت المهمة';

  @override
  String get job_triggered => 'طُلب تشغيل المهمة';

  @override
  String get label => 'التسمية';

  @override
  String last_activity(Object day, Object month, Object year) {
    return 'آخر نشاط: $day/$month/$year';
  }

  @override
  String last(Object lastRun) {
    return 'آخر تشغيل: $lastRun';
  }

  @override
  String get leave_blank_for_default_8642_443_with_https =>
      'اتركه فارغًا لاستخدام المنفذ الافتراضي (8642؛ أو 443 مع https)';

  @override
  String get leave_blank_for_default_9119 =>
      'اتركه فارغًا لاستخدام المنفذ الافتراضي (9119)';

  @override
  String get light => 'فاتح';

  @override
  String listening(Object elapsed) {
    return 'جارٍ الاستماع • $elapsed';
  }

  @override
  String listening_elapsed(Object elapsed) {
    return 'جارٍ الاستماع، الوقت المنقضي: $elapsed';
  }

  @override
  String get load_more => 'تحميل المزيد…';

  @override
  String get loading => 'جارٍ التحميل';

  @override
  String get location => 'الموقع';

  @override
  String get make_sure_the_gateway_api_server_is_running_hermes_gateway =>
      'تأكّد من تشغيل خادم واجهة API للبوابة\n(hermes gateway status)';

  @override
  String matches(Object assigned, Object name) {
    return 'يطابق $name · $assigned';
  }

  @override
  String get memory => 'الذاكرة';

  @override
  String get memory_about_you => 'عنك';

  @override
  String get memory_agent_notes => 'ملاحظات الوكيل';

  @override
  String get memory_builtin_scope =>
      'معلومات محفوظة من ملفّي USER.md وMEMORY.md لهذا الملف الشخصي. لا يظهر هنا مزوّدو الذاكرة الخارجيون، بما فيهم MemPalace.';

  @override
  String get memory_read_only =>
      'للقراءة فقط. اطلب من Hermes في المحادثة تصحيح معلومة أو نسيانها.';

  @override
  String get memory_unavailable =>
      'لا توفّر هذه البوابة أو هذا الملف الشخصي معلومات الذاكرة المحفوظة. تحقّق من الملف الشخصي المحدد وحدّث Hermes عند الحاجة.';

  @override
  String get memory_load_error =>
      'تحقّق من الاتصال بلوحة التحكم ومن بيانات تسجيل الدخول، ثم حاول مجددًا.';

  @override
  String get memory_read_full_fact => 'قراءة المعلومة كاملة';

  @override
  String get memory_full_fact_requires_update =>
      'يتطلب عرض المعلومات كاملةً إصدارًا أحدث من بوابة Hermes. حدّث Hermes ثم أعد تحميل القائمة.';

  @override
  String get memory_fact_detail_error =>
      'تعذّر تحميل المعلومة كاملةً. ربما تغيّرت؛ حدّث القائمة ثم حاول مجددًا.';

  @override
  String get memory_entries_are_cross_session_facts_the_agent_remembers_they =>
      'ستظهر المعلومات المحفوظة هنا بعد أن يتذكّرها Hermes.';

  @override
  String get merge => 'دمج';

  @override
  String get message => 'رسالة';

  @override
  String get message_hermes => 'راسل Hermes…';

  @override
  String get message_actions => 'إجراءات الرسالة';

  @override
  String get message_copied => 'نُسخت الرسالة';

  @override
  String get migrating => 'جارٍ الترحيل…';

  @override
  String get migration_complete => 'اكتمل الترحيل';

  @override
  String get migration_failed_local_spaces_were_kept_unchanged =>
      'فشل الترحيل. بقيت المساحات المحلية دون تغيير.';

  @override
  String get migration_incomplete => 'لم يكتمل الترحيل';

  @override
  String get migration_preview => 'معاينة الترحيل';

  @override
  String get model => 'النموذج';

  @override
  String get model_and_thinking_for_this_chat =>
      'النموذج ومستوى التفكير لهذه المحادثة';

  @override
  String model_was_not_changed(Object error) {
    return 'لم يتغيّر النموذج: $error';
  }

  @override
  String get move_attachment_next => 'نقل المرفق إلى الموضع التالي';

  @override
  String get move_attachment_previous => 'نقل المرفق إلى الموضع السابق';

  @override
  String get move_chat => 'نقل المحادثة';

  @override
  String get move_conversation => 'نقل المحادثة';

  @override
  String get move_to_project => 'نقل إلى مشروع';

  @override
  String get move_to_space => 'نقل إلى مساحة';

  @override
  String get moved_to_a_project => 'نُقلت المحادثة إلى مشروع';

  @override
  String moved_to(Object label) {
    return 'نُقلت إلى $label';
  }

  @override
  String get name => 'الاسم';

  @override
  String get name_prompt_and_schedule_are_required =>
      'يجب إدخال الاسم والطلب والجدول الزمني';

  @override
  String get nav_activity => 'النشاط';

  @override
  String get nav_projects => 'المشاريع';

  @override
  String get needs_a_correction_aware_filing_contract_in_the_hermes_gateway =>
      'يتطلب ذلك آلية تصنيف تراعي التصحيحات في بوابة Hermes.';

  @override
  String get needs_a_reachable_hermes_dashboard_check_the_host_port_and =>
      'يجب أن تكون لوحة تحكم Hermes متاحة. تحقّق من المضيف والمنفذ وبيانات الاعتماد لهذا الاتصال.';

  @override
  String get needs_a_server_authoritative_assets_index_in_the_hermes_gateway =>
      'يتطلب ذلك فهرسًا للأصول في بوابة Hermes يكون الخادم مرجعه المعتمد.';

  @override
  String get needs_durable_pin_ordering_batch_mutation_and_undo_contracts_in =>
      'يتطلب ذلك دعم بوابة Hermes لحفظ ترتيب العناصر المثبّتة وإجراء تغييرات جماعية والتراجع عنها.';

  @override
  String get needs_you => 'يحتاج إلى تدخّلك';

  @override
  String get new_label => 'جديد';

  @override
  String get new_chat => 'محادثة جديدة';

  @override
  String get new_chat_2 => 'محادثة جديدة';

  @override
  String new_chat_3(Object projectName) {
    return 'محادثة جديدة · $projectName';
  }

  @override
  String get new_project => 'مشروع جديد';

  @override
  String get new_space => 'مساحة جديدة';

  @override
  String next(Object nextRun) {
    return 'التشغيل التالي: $nextRun';
  }

  @override
  String get nginx_injects_auth_app_sends_clean_requests =>
      'يضيف Nginx بيانات المصادقة؛ يرسل التطبيق الطلبات دونها';

  @override
  String get no_tts_voices_found_ninstall_google_text_to_speech_and =>
      'لم يُعثر على أصوات لتحويل النص إلى كلام (TTS).\nثبّت Google Text-to-Speech ونزّل بيانات الأصوات.';

  @override
  String get no_active_projects_on_this_gateway =>
      'لا توجد مشاريع نشطة على هذه البوابة';

  @override
  String get no_activity_yet => 'لا يوجد نشاط بعد';

  @override
  String get no_chat_is_blocked_running_or_waiting_to_be_resumed =>
      'لا توجد محادثة متوقفة أو جارية أو بانتظار الاستئناف. ابدأ محادثة جديدة متى شئت.';

  @override
  String no_chats_in_this_project_match(Object searchQuery) {
    return 'لا توجد محادثات في هذا المشروع تطابق «$searchQuery».';
  }

  @override
  String get no_chats_in_this_space_yet_tap_to_start_one =>
      'لا توجد محادثات في هذه المساحة بعد. اضغط على + لبدء محادثة.';

  @override
  String get no_chats_yet => 'لا توجد محادثات بعد';

  @override
  String get no_connections => 'لا توجد اتصالات';

  @override
  String get no_conversation_matches_this_view =>
      'لا توجد محادثة تطابق معايير العرض الحالية.';

  @override
  String get no_cron_jobs => 'لا توجد مهام cron';

  @override
  String get no_folders_yet => 'لا توجد مجلدات بعد';

  @override
  String get no_local_spaces_were_found_for_this_connection_so_projects =>
      'لم يُعثر على مساحات محلية لهذا الاتصال، لذا فالمشاريع هي بالفعل الوسيلة الوحيدة للتنظيم هنا.';

  @override
  String get no_matches => 'لا توجد نتائج مطابقة';

  @override
  String get no_memory_entries => 'لا توجد معلومات محفوظة في الذاكرة';

  @override
  String get no_message_content_matches =>
      'لا توجد نتائج مطابقة في نصوص الرسائل';

  @override
  String get no_new_messages => 'لا توجد رسائل جديدة';

  @override
  String get no_projects_yet => 'لا توجد مشاريع بعد';

  @override
  String get no_runs_yet => 'لم تُشغّل المهمة بعد.';

  @override
  String no_server_project_matches_this_name(Object assigned) {
    return 'لا يوجد مشروع على الخادم يطابق هذا الاسم · $assigned';
  }

  @override
  String get no_sessions_yet => 'لا توجد جلسات بعد';

  @override
  String get no_skills_found => 'لم يُعثر على مهارات';

  @override
  String get no_spaces_on_this_device => 'لا توجد مساحات على هذا الجهاز';

  @override
  String get no_text_shared => 'لم يُشارَك أي نص';

  @override
  String get no_turn_is_blocked_in_flight_or_recently_finished_work =>
      'لا يوجد طلب متعثر أو قيد التنفيذ أو اكتمل مؤخرًا. سيظهر هنا أي عمل تبدأه.';

  @override
  String get no_turn_needs_your_input_or_has_failed =>
      'لا توجد طلبات فشلت أو تنتظر ردّك.';

  @override
  String get no_unassigned_chats => 'لا توجد محادثات بلا مشروع.';

  @override
  String get nothing_changed_in_the_last_seven_days =>
      'لم يتغيّر شيء خلال الأيام السبعة الماضية.';

  @override
  String get nothing_has_moved_yet_this_is_only_what_a_migration =>
      'لم يُنقل أي شيء بعد. هذه مجرد معاينة لما سيحدث عند الترحيل.';

  @override
  String get nothing_here => 'لا يوجد شيء هنا';

  @override
  String get nothing_is_running => 'لا شيء قيد التشغيل';

  @override
  String get nothing_needs_you => 'لا شيء يتطلّب تدخّلك';

  @override
  String get nothing_to_migrate => 'لا يوجد ما يمكن ترحيله';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get windows_notifications_blocked =>
      'الإشعارات غير متاحة. استخدم تطبيق Ares المثبّت وتحقق من الإعدادات ← النظام ← الإشعارات في Windows.';

  @override
  String get windows_notification_diagnostics => 'ما أرسله Ares إلى Windows';

  @override
  String get chat_activity_share => 'مشاركة نشاط المحادثة';

  @override
  String get chat_activity_share_hint =>
      'أبلِغ البوابة المتصلة المتوافقة عندما تستخدم هذه المحادثة، حتى يتجنّب ملحق إشعارات الهاتف فيها التنبيهات المكررة. لا تُرسَل أي مفاتيح أو نصوص رسائل.';

  @override
  String get completion_sound => 'صوت الاكتمال';

  @override
  String get completion_sound_system => 'الافتراضي للنظام';

  @override
  String get completion_sound_mail => 'البريد';

  @override
  String get completion_sound_reminder => 'تذكير';

  @override
  String get completion_sound_silent => 'صامت';

  @override
  String get completion_sound_scope =>
      'يُشغَّل للردود المكتملة والإشعار التجريبي وداخل التطبيق. تحتفظ الموافقات والتنبيهات الأخرى بصوتها المعتاد.';

  @override
  String get completion_sound_scope_android =>
      'يُشغَّل للردود المكتملة والإشعار التجريبي وداخل التطبيق. تحتفظ الموافقات والتنبيهات الأخرى وإشعارات الخلفية من الخادم ورسائل Android Auto بصوتها المعتاد.';

  @override
  String get notification_open_action => 'فتح';

  @override
  String get app_sounds_mute => 'كتم أصوات التطبيق';

  @override
  String get app_sounds_mute_hint =>
      'يوقف صوت الاكتمال الذي يشغّله Ares أثناء فتحه. تحتفظ الإشعارات بصوتها الخاص.';

  @override
  String get notifications_permission_denied =>
      'يحظر نظام التشغيل الإشعارات. فعّل إشعارات هذا التطبيق في إعدادات Android.';

  @override
  String get off_no_thinking => 'متوقف (دون تفكير)';

  @override
  String get offline_showing_the_last_known_activity =>
      'غير متصل — يُعرض آخر نشاط معروف.';

  @override
  String get offline_showing_the_last_known_chats =>
      'غير متصل — تُعرض آخر المحادثات المعروفة';

  @override
  String get offline_showing_the_last_known_projects =>
      'غير متصل — تُعرض آخر المشاريع المعروفة.';

  @override
  String get on_this_device => 'على هذا الجهاز';

  @override
  String get on_device => 'على الجهاز';

  @override
  String get open_inbox => 'فتح صندوق الوارد';

  @override
  String open_inbox_2(Object count) {
    return 'فتح صندوق الوارد ($count)';
  }

  @override
  String get open_the_hermes_dashboard => 'فتح لوحة تحكم Hermes';

  @override
  String get optional_for_the_memory_cron_skills_settings_tabs_leave_blank =>
      'اختياري. يُستخدم لتبويبات الذاكرة وCron والمهارات والإعدادات. اتركه فارغًا لاستخدام منفذ لوحة التحكم الافتراضي (9119) دون تسجيل الدخول.';

  @override
  String get organization => 'التنظيم';

  @override
  String get other_answer => 'إجابة أخرى';

  @override
  String get overview => 'نظرة عامة';

  @override
  String get passphrase => 'عبارة المرور';

  @override
  String get password_optional => 'كلمة المرور (اختياري)';

  @override
  String get phone_or_tablet => 'هاتف أو جهاز لوحي';

  @override
  String get pin_batch_and_undo => 'التثبيت والإجراءات الجماعية والتراجع';

  @override
  String get plugin_notifications => 'إشعارات الإضافات';

  @override
  String get plugin_notifications_description =>
      'أرسلت البوابة إشعارًا أثناء عمل التطبيق في الخلفية.';

  @override
  String get port => 'المنفذ';

  @override
  String get preparing_attachments => 'جارٍ تحضير المرفقات…';

  @override
  String get preview_truncated => 'المعاينة مختصرة';

  @override
  String get preview_unavailable => 'المعاينة غير متاحة';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get profile_default_model => 'النموذج الافتراضي للملف الشخصي';

  @override
  String profile_default_set_to_chats_with_their_own_model_keep(
    Object selectedModel,
  ) {
    return 'أصبح $selectedModel النموذج الافتراضي للملف الشخصي. تحتفظ المحادثات التي اخترت لها نموذجًا محددًا بنموذجها.';
  }

  @override
  String
  get profile_this_connection_chats_as_when_the_dashboard_serves_several =>
      'الملف الشخصي المستخدم للمحادثات عبر هذا الاتصال عندما تدعم لوحة التحكم عدة ملفات شخصية. اتركه فارغًا إذا كانت لكل ملف شخصي لوحة تحكم مستقلة.';

  @override
  String get project => 'مشروع';

  @override
  String get project_actions => 'إجراءات المشروع';

  @override
  String get project_chat => 'محادثة المشروع';

  @override
  String get project_chats_unavailable => 'محادثات المشروع غير متاحة';

  @override
  String get projects => 'المشاريع';

  @override
  String get projects_group_related_chats_files_and_activity_and_stay_in =>
      'تجمع المشاريع المحادثات والملفات والأنشطة ذات الصلة، وتظل متزامنة مع Hermes على حاسوبك.';

  @override
  String
  get projects_need_a_desktop_gateway_connection_add_the_desktop_gateway =>
      'تتطلب المشاريع اتصالًا ببوابة سطح المكتب (Desktop Gateway). أضف عنوان URL الخاص ببوابة Desktop Gateway إلى إعدادات هذا الاتصال لتنظيم محادثاتك عبر أجهزتك.';

  @override
  String get projects_unavailable => 'المشاريع غير متاحة';

  @override
  String get projects_activity_new_navigation =>
      'المشاريع والنشاط — طريقة جديدة للتنقّل';

  @override
  String get promote_to_project => 'تحويل إلى مشروع';

  @override
  String get prompt => 'الطلب';

  @override
  String get protect_this_backup => 'حماية هذه النسخة الاحتياطية';

  @override
  String get provider => 'المزوّد';

  @override
  String get proxy_injects_auth_app_sends_clean_requests =>
      'يضيف الوكيل الوسيط بيانات المصادقة؛ يرسل التطبيق الطلبات دونها';

  @override
  String get quick_chat => 'محادثة سريعة';

  @override
  String get quick_chats_appear_here_after_their_retention_period =>
      'تظهر المحادثات السريعة هنا بعد انتهاء مدة الاحتفاظ بها.';

  @override
  String get read_aloud => 'قراءة بصوت عالٍ';

  @override
  String get read_aloud_is_unavailable_on_this_device =>
      'القراءة بصوت عالٍ غير متاحة على هذا الجهاز';

  @override
  String get reading_response_aloud => 'جارٍ قراءة الرد بصوت عالٍ';

  @override
  String get ready_to_upload => 'جاهز للرفع';

  @override
  String get reasoning => 'الاستدلال';

  @override
  String get recently_completed => 'اكتمل مؤخرًا';

  @override
  String get recently_active => 'نشط مؤخرًا';

  @override
  String get recovering_hermes => 'جارٍ استعادة Hermes…';

  @override
  String get refresh => 'تحديث';

  @override
  String get regenerate_response => 'توليد الرد مجددًا';

  @override
  String get remove_attachment => 'إزالة المرفق';

  @override
  String get rename => 'إعادة تسمية';

  @override
  String get rename_chat => 'إعادة تسمية المحادثة';

  @override
  String get rename_project => 'إعادة تسمية المشروع';

  @override
  String get rename_space => 'إعادة تسمية المساحة';

  @override
  String rename_2(Object projectName) {
    return 'إعادة تسمية $projectName';
  }

  @override
  String rename_3(Object name) {
    return 'إعادة تسمية $name';
  }

  @override
  String get replace => 'استبدال';

  @override
  String get repositories => 'المستودعات';

  @override
  String
  get research_the_attached_content_verify_the_important_claims_and_cite =>
      'ابحث في موضوع المحتوى المرفق، وتحقّق من الادعاءات المهمة، واذكر المصادر.';

  @override
  String research_this_content_verify_the_important_claims_and_cite_sources(
    Object text,
  ) {
    return 'ابحث في موضوع المحتوى التالي، وتحقّق من الادعاءات المهمة، واذكر المصادر:\n\n$text';
  }

  @override
  String reset_failed_the_secure_storage_may_need_reinstall(Object retryError) {
    return 'تعذّرت إعادة الضبط: $retryError. قد يلزم إعادة تثبيت مكوّن التخزين الآمن.';
  }

  @override
  String get reset_saved_connections => 'إعادة ضبط الاتصالات المحفوظة';

  @override
  String get responding => 'جارٍ الرد…';

  @override
  String response_closed_locally_gateway_stop_failed(Object error) {
    return 'أُغلق الرد محليًا، لكن تعذّر إيقافه على البوابة: $error';
  }

  @override
  String get response_closed_locally_no_active_gateway_turn_was_found =>
      'أُغلق الرد محليًا؛ لم يُعثر على طلب نشط في البوابة.';

  @override
  String get response_complete => 'اكتمل الرد';

  @override
  String get response_complete_description =>
      'اكتمل الرد على طلب أثناء عمل التطبيق في الخلفية.';

  @override
  String get response_ready => 'الرد جاهز';

  @override
  String get response_stopped => 'أُوقف الرد.';

  @override
  String get restore => 'استعادة';

  @override
  String get restore_configuration => 'استعادة التكوين';

  @override
  String get restore_project => 'استعادة المشروع';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String retry_failed_for_the_draft_and_prompt_were_kept(Object name) {
    return 'تعذّرت إعادة المحاولة لـ $name. احتُفظ بالمسودة والطلب.';
  }

  @override
  String get retry_upload => 'إعادة محاولة الرفع';

  @override
  String retrying(Object name) {
    return 'جارٍ إعادة المحاولة لـ $name…';
  }

  @override
  String get review_local_spaces => 'مراجعة المساحات المحلية';

  @override
  String get review_or_promote_quick_chats_past_their_retention_period =>
      'راجع المحادثات السريعة التي انتهت مدة الاحتفاظ بها أو حوّلها إلى محادثات مشروع';

  @override
  String get review_the_attached_content => 'راجع المحتوى المرفق.';

  @override
  String get run_only_this_command => 'شغّل هذا الأمر فقط.';

  @override
  String get running_now => 'قيد التشغيل الآن';

  @override
  String get save => 'حفظ';

  @override
  String get save_changes => 'حفظ التغييرات';

  @override
  String get save_a_permanent_rule_in_the_hermes_configuration =>
      'احفظ قاعدة دائمة في إعدادات Hermes.';

  @override
  String get save_the_durable_facts_from_the_attached_content_to_memory =>
      'احفظ في الذاكرة المعلومات المفيدة على المدى الطويل من المحتوى المرفق، ثم أكّد ما احتفظت به.';

  @override
  String save_the_durable_facts_from_this_content_to_memory_then(Object text) {
    return 'احفظ في الذاكرة المعلومات المفيدة على المدى الطويل من المحتوى التالي، ثم أكّد ما احتفظت به:\n\n$text';
  }

  @override
  String get save_your_connections_and_settings_to_an_encrypted_file_then =>
      'احفظ اتصالاتك وإعداداتك في ملف مشفّر لتستعيدها بعد إعادة التثبيت أو على جهاز آخر.';

  @override
  String save_2(Object filename) {
    return 'حفظ $filename';
  }

  @override
  String get schedule => 'الجدول الزمني';

  @override
  String get scheduled_jobs_and_their_last_runs =>
      'المهام المجدولة وآخر تشغيل لكل منها';

  @override
  String get scheduled_tasks => 'المهام المجدولة';

  @override
  String get script_only_no_agent => 'برنامج نصي فقط (دون وكيل)';

  @override
  String get scroll_horizontally => 'تمرير أفقي';

  @override
  String get search_all_chats => 'البحث في جميع المحادثات';

  @override
  String get search_all_message_content => 'البحث في محتوى جميع الرسائل';

  @override
  String get search_chats => 'البحث في المحادثات';

  @override
  String get search_conversations => 'البحث في المحادثات';

  @override
  String get search_loaded_chats => 'البحث في المحادثات المحمّلة';

  @override
  String get search_mode => 'وضع البحث';

  @override
  String get select_one_option_or_enter_another_answer =>
      'اختر أحد الخيارات، أو أدخل إجابة أخرى.';

  @override
  String get select_one_or_more_options_then_continue =>
      'اختر خيارًا واحدًا أو أكثر، ثم تابع.';

  @override
  String get select_text => 'تحديد النص';

  @override
  String get send => 'إرسال';

  @override
  String send_failed(Object error) {
    return 'تعذّر الإرسال: $error';
  }

  @override
  String send_failed_api_only_permission_denied(Object error) {
    return 'تعذّر الإرسال: $error. رفض الخادم عملية الكتابة هذه للهوية المرتبطة بمفتاح API. إذا كانت المحادثة مملوكة للوحة التحكم، فقد تتيح إضافة اسم المستخدم وكلمة المرور الخاصّين بلوحة التحكم إلى هذا الاتصال إرسال الرسائل. وقد يكون الخادم يرفض الإرسال عن قصد.';
  }

  @override
  String get send_message => 'إرسال رسالة';

  @override
  String get send_test_notification => 'إرسال إشعار تجريبي';

  @override
  String get session_sources => 'مصادر الجلسات';

  @override
  String get session_deleted_from_remote_hermes =>
      'حُذفت الجلسة من Hermes البعيد.';

  @override
  String session_search_failed(Object error) {
    return 'تعذّر البحث في الجلسات: $error';
  }

  @override
  String get set_profile_default => 'تعيين كخيار افتراضي للملف الشخصي';

  @override
  String get settings => 'الإعدادات';

  @override
  String get share_to_hermes => 'مشاركة مع Hermes';

  @override
  String get show_passphrase => 'إظهار عبارة المرور';

  @override
  String get show_tool_calls_thinking_and_message_metadata =>
      'اعرض الأدوات والاستدلال والمهام وتفاصيل الرسائل في أقسام مطوية. عند تعطيل هذا الخيار، لا تظهر سوى المحادثة.';

  @override
  String get signal_messages => 'رسائل Signal';

  @override
  String get skills => 'المهارات';

  @override
  String skills_2(Object count) {
    return 'المهارات ($count)';
  }

  @override
  String get skills_and_tools => 'المهارات والأدوات';

  @override
  String get skip => 'تخطّي';

  @override
  String get slack_chats => 'محادثات Slack';

  @override
  String source(Object source) {
    return 'المصدر: $source';
  }

  @override
  String get space_actions => 'إجراءات المساحة';

  @override
  String get spaces => 'المساحات';

  @override
  String get speak_to_hermes => 'تحدّث إلى Hermes';

  @override
  String get speech_recognition_is_unavailable => 'التعرّف على الكلام غير متاح';

  @override
  String get spoken_replies => 'الردود الصوتية';

  @override
  String get spoken_replies_off => 'الردود الصوتية معطّلة';

  @override
  String get spoken_replies_on => 'الردود الصوتية مفعّلة';

  @override
  String get stalled_no_update_from_hermes =>
      'توقّف التقدّم — لا تحديث من Hermes';

  @override
  String get start_something_new => 'ابدأ شيئًا جديدًا';

  @override
  String get start_voice_input => 'بدء الإدخال الصوتي';

  @override
  String get starting_hermes => 'جارٍ بدء تشغيل Hermes…';

  @override
  String get media_card_download => 'تنزيل الملف';

  @override
  String get media_card_tap_to_download => 'اضغط للتنزيل';

  @override
  String get still_loading_your_projects => 'لا يزال تحميل مشاريعك جاريًا.';

  @override
  String get stop => 'إيقاف';

  @override
  String get stop_response => 'إيقاف الرد';

  @override
  String get stop_voice_input => 'إيقاف الإدخال الصوتي';

  @override
  String get submitted_waiting_for_hermes => 'أُرسل الطلب، بانتظار Hermes';

  @override
  String get suggest_projects_and_learn_from_your_corrections =>
      'اقتراح مشاريع والتعلّم من تصحيحاتك';

  @override
  String get summarize_the_attached_content => 'لخّص المحتوى المرفق.';

  @override
  String summarize_this_content(Object text) {
    return 'لخّص هذا المحتوى:\n\n$text';
  }

  @override
  String get switch_profile => 'تبديل الملف الشخصي';

  @override
  String get system => 'النظام';

  @override
  String get take_photo => 'التقاط صورة';

  @override
  String get tap_to_add_a_remote_hermes_gateway_api_server_port =>
      'اضغط على + لإضافة بوابة Hermes بعيدة\n(API Server، المنفذ 8642)';

  @override
  String get tap_the_button_to_start_a_new_chat =>
      'اضغط على زر + لبدء محادثة جديدة';

  @override
  String get telegram_messages => 'رسائل Telegram';

  @override
  String get terminal_sessions => 'جلسات الطرفية';

  @override
  String get test_notification_body =>
      'إذا ظهر لك هذا الإشعار، فإشعارات النظام تعمل.';

  @override
  String get test_notification_sent => 'أُرسل إشعار الاختبار.';

  @override
  String get test_notification_title => 'اختبار إشعارات Hermes';

  @override
  String get test_notification_unsupported =>
      'تعذّر إرسال الإشعار. تأكد من أن نظام التشغيل (OS) يسمح بالإشعارات.';

  @override
  String get text_size => 'حجم النص';

  @override
  String get text_size_preview => 'معاينة حجم النص';

  @override
  String text_size_2(Object label) {
    return 'حجم النص: $label';
  }

  @override
  String get the_api_key_could_not_be_stored_securely =>
      'تعذّر تخزين مفتاح API بأمان.';

  @override
  String get the_project_will_move_to_archived_its_chats_and_files =>
      'سينتقل المشروع إلى الأرشيف. ستبقى محادثاته وملفاته كما هي، ويمكنك استعادته في أي وقت.';

  @override
  String get the_project_will_move_to_archived_its_chats_and_files_2 =>
      'سينتقل المشروع إلى الأرشيف. ستبقى محادثاته وملفاته كما هي، ويمكنك استعادته لاحقًا.';

  @override
  String get the_active_profile_did_not_return_any_selectable_models =>
      'لم يعرض ملف التعريف النشط أي نماذج يمكن اختيارها.';

  @override
  String get the_backup_could_not_be_exported =>
      'تعذّر تصدير النسخة الاحتياطية.';

  @override
  String get the_backup_could_not_be_restored =>
      'تعذّرت استعادة النسخة الاحتياطية.';

  @override
  String get the_connection_could_not_be_deleted_safely =>
      'تعذّر حذف الاتصال بأمان.';

  @override
  String get the_connection_could_not_be_stored_securely =>
      'تعذّر تخزين الاتصال بأمان.';

  @override
  String get the_dashboard_credentials_could_not_be_stored_securely =>
      'تعذّر تخزين بيانات اعتماد لوحة التحكم بأمان.';

  @override
  String get the_detached_reply_failed => 'فشل الرد الذي كان يعمل في الخلفية.';

  @override
  String the_detached_reply_failed_2(Object error) {
    return 'فشل الرد الذي كان يعمل في الخلفية: $error';
  }

  @override
  String get the_file_contains_your_api_keys_and_dashboard_password_so =>
      'الملف مشفّر لأنه يحتوي على مفاتيح API وكلمة مرور لوحة التحكم. لا يمكن استعادة النسخة الاحتياطية من دون عبارة المرور هذه.';

  @override
  String get the_last_turn_failed => 'فشلت الجولة الأخيرة';

  @override
  String the_local_connection_store_looks_damaged_you_can_reset_the(
    Object errorType,
  ) {
    return 'يبدو أن مخزن الاتصالات المحلي تالف ($errorType). يمكنك إعادة ضبط الاتصالات المحفوظة والبدء من جديد. لن تتأثر المحادثات الموجودة على البوابة.';
  }

  @override
  String get the_model_only_rewrites_your_question_into_a_short_full =>
      'يقتصر دور النموذج على إعادة صياغة سؤالك في عبارة قصيرة للبحث في النص الكامل. يستخدم Hermes بيانات اعتماد المزوّد التي سبق إعدادها على المضيف.';

  @override
  String get the_server_has_not_reported_folders_for_this_project_yet =>
      'لم يُبلغ الخادم عن أي مجلدات لهذا المشروع بعد. ما زال بإمكانك فتح «الملفات العامة» من «المزيد».';

  @override
  String get the_turn_failed => 'فشلت الجولة';

  @override
  String get the_two_passphrases_do_not_match => 'عبارتا المرور غير متطابقتين.';

  @override
  String get the_value_is_sent_directly_to_the_active_hermes_gateway =>
      'تُرسل القيمة مباشرة إلى بوابة Hermes النشطة ولا يحفظها تطبيق Android هذا.';

  @override
  String get there_are_no_visible_files_in_this_server_folder =>
      'لا توجد ملفات ظاهرة في هذا المجلد على الخادم.';

  @override
  String get thinking_effort => 'مستوى جهد التفكير';

  @override
  String get this_hermes_gateway_does_not_support_opening_a_project_yet =>
      'لا تدعم بوابة Hermes هذه فتح المشاريع بعد. حدّث Hermes على الخادم لتتمكن من تصفّح مشروع من هاتفك.';

  @override
  String get this_hermes_gateway_is_older_than_server_side_projects_so =>
      'إصدار بوابة Hermes هذه أقدم من ميزة المشاريع على الخادم، لذا يقتصر تجميع المحادثات على هذا الجهاز. حدّث Hermes لاستخدام المشاريع نفسها على جميع أجهزتك.';

  @override
  String get this_project_has_no_folder_to_open_the_chat_in =>
      'يحتاج هذا المشروع إلى مجلد قبل أن تتمكن من بدء محادثة فيه. أضف مجلدًا ثم حاول مجددًا.';

  @override
  String get this_chat_has_no_messages_available_in_the_desktop_session =>
      'لا تتوفر أي رسائل لهذه المحادثة في جلسة سطح المكتب بعد.';

  @override
  String get this_creates_a_permanent_rule_in_hermes_review_the_full =>
      'سيؤدي هذا إلى إنشاء قاعدة دائمة في Hermes. راجع الأمر كاملًا قبل التأكيد.';

  @override
  String get this_gateway_does_not_host_projects_yet_update_the_gateway =>
      'لا تستضيف هذه البوابة مشاريع بعد. حدّث البوابة لتنظيم المحادثات عبر أجهزتك.';

  @override
  String get this_permanently_deletes_the_project_chats_will_not_be_deleted =>
      'سيُحذف المشروع نهائيًا. لن تُحذف محادثاته، بل ستعود إلى قسم «غير معيّنة».';

  @override
  String get this_server_doesn_t_offer_background_recovery_chats_run_live =>
      'لا يدعم هذا الخادم استئناف المحادثات في الخلفية، لذا تجري المحادثات مباشرة فقط';

  @override
  String get this_week => 'هذا الأسبوع';

  @override
  String get titles_previews_and_models => 'العناوين والمعاينات والنماذج';

  @override
  String get tool_activity => 'نشاط الأدوات';

  @override
  String get trigger_now => 'تشغيل الآن';

  @override
  String get received_outcome_unknown => 'انتهت الجولة ولم تتأكد نتيجتها';

  @override
  String get turn_completed => 'اكتملت الجولة';

  @override
  String get turn_failed => 'فشلت الجولة';

  @override
  String get turn_failed_description => 'انتهت جولة في الخلفية بخطأ.';

  @override
  String get turn_recovery_failed => 'تعذّر استئناف الجولة';

  @override
  String get unable_to_prepare_this_file_try_another_one =>
      'تعذّر تجهيز هذا الملف. جرّب ملفًا آخر.';

  @override
  String get unable_to_prepare_this_image_try_another_one =>
      'تعذّر تجهيز هذه الصورة. جرّب صورة أخرى.';

  @override
  String unable_to_prepare(Object name) {
    return 'تعذّر تجهيز $name.';
  }

  @override
  String get unable_to_read_the_selected_image_the_selection_was_kept =>
      'تعذّرت قراءة الصورة المحددة. لم يتغيّر اختيارك.';

  @override
  String get unassigned => 'غير معيّنة';

  @override
  String get unassigned_chats => 'محادثات غير معيّنة';

  @override
  String get untitled_chat => 'محادثة بلا عنوان';

  @override
  String get untitled_session => 'جلسة بلا عنوان';

  @override
  String get update_api_key => 'تحديث مفتاح API';

  @override
  String get upload_failed => 'فشل الرفع';

  @override
  String get upload_failed_tap_retry => 'فشل الرفع • اضغط لإعادة المحاولة';

  @override
  String uploading(Object index, Object name, Object total) {
    return 'جارٍ رفع $index/$total: $name';
  }

  @override
  String get use_as_is => 'استخدام النص كما هو';

  @override
  String get use_at_least_8_characters => 'استخدم 8 أحرف على الأقل.';

  @override
  String get use_for_cron_jobs_backed_by_scripts =>
      'استخدم هذا الخيار لمهام cron التي تشغّل نصوصًا برمجية.';

  @override
  String get use_on_device => 'البحث على الجهاز';

  @override
  String get use_the_attached_content_to_identify_and_fill_the_relevant =>
      'استخدم المحتوى المرفق لتحديد الحقول المناسبة في المستند أو النموذج وتعبئتها. اطلب الإذن قبل إرسال أي شيء.';

  @override
  String use_this_content_to_identify_and_fill_the_relevant_document(
    Object text,
  ) {
    return 'استخدم هذا المحتوى لتحديد الحقول المناسبة في المستند أو النموذج وتعبئتها. اطلب الإذن قبل إرسال أي شيء:\n\n$text';
  }

  @override
  String get used_for_hosted_path_prefixes_and_for_the_settings_memory =>
      'تُستخدم هذه الإعدادات لبادئات مسارات الاستضافة ولتبويبات الإعدادات والذاكرة والمهارات وCron. إذا كانت لوحة التحكم متاحة بلا مصادقة، فاترك اسم المستخدم وكلمة المرور فارغين. وإذا كان الوكيل العكسي يضيف بيانات المصادقة للوحة التحكم، ففعّل وضع الوكيل.';

  @override
  String get username_optional => 'اسم المستخدم (اختياري)';

  @override
  String using(Object displayName) {
    return 'جارٍ استخدام $displayName…';
  }

  @override
  String get verbose_mode => 'الوضع المفصّل';

  @override
  String get message_metadata => 'تفاصيل الرسالة';

  @override
  String get voice => 'الصوت';

  @override
  String voice_setup_failed(Object error) {
    return 'تعذّر إعداد الصوت: $error';
  }

  @override
  String get waiting_for_your_input => 'بانتظار ردّك';

  @override
  String get what_hermes_knows_how_to_do => 'ما يستطيع Hermes فعله';

  @override
  String get what_should_the_agent_do => 'ماذا تريد من الوكيل أن يفعل؟';

  @override
  String get whatsapp_messages => 'رسائل WhatsApp';

  @override
  String get which_project => 'أي مشروع؟';

  @override
  String get workspace => 'مساحة العمل';

  @override
  String get wrap_lines => 'التفاف الأسطر';

  @override
  String you_can_attach_up_to_items(Object maxRemoteAttachmentDrafts) {
    return 'الحد الأقصى للعناصر التي يمكنك إرفاقها هو $maxRemoteAttachmentDrafts.';
  }

  @override
  String get your_answer => 'إجابتك';

  @override
  String get e_g_dashboard => 'مثل: /dashboard';

  @override
  String get e_g_dashboard_proxy_path_before_api =>
      'مثل: /dashboard (مسار الوكيل قبل /api/)';

  @override
  String get e_g_profile_peter => 'مثل: /profile/peter';

  @override
  String get e_g_sol => 'مثل: sol';

  @override
  String get e_g_0_9_or_every_2h => 'مثل: 0 9 * * * أو every 2h';

  @override
  String get e_g_daily_backup => 'مثل: نسخ احتياطي يومي';

  @override
  String downloaded(Object filename) {
    return 'اكتمل تنزيل $filename';
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
      '192.168.1.50 أو 100.x.y.z أو hermes-machine.tailnet.ts.net';

  @override
  String get example_profile_prefix_hint_full =>
      'مثل: /profile/peter (مسار الوكيل قبل /api/ و/v1/)';

  @override
  String and_more(Object count) {
    return 'والمزيد ($count)';
  }

  @override
  String chats_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عدد المحادثات: $count',
      one: '$count محادثة',
    );
    return '$_temp0';
  }

  @override
  String on_this_device_only(Object chats) {
    return '$chats · على هذا الجهاز فقط';
  }

  @override
  String spaces_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عدد المساحات: $count',
      one: '$count مساحة',
    );
    return '$_temp0';
  }

  @override
  String get no_new_projects_needed => 'لا حاجة إلى مشاريع جديدة';

  @override
  String projects_to_create(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عدد المشاريع التي ستُنشأ: $count',
      one: '$count مشروع سيُنشأ',
    );
    return '$_temp0';
  }

  @override
  String chats_migrated_projects_created(
    Object createdProjects,
    Object linkedSessions,
  ) {
    return 'المحادثات التي نُقلت: $linkedSessions · المشاريع التي أُنشئت: $createdProjects';
  }

  @override
  String chats_stayed_in_local_spaces(Object unlinkedSessions) {
    return 'بقيت بعض المحادثات في المساحات المحلية (عددها: $unlinkedSessions). يمكنك إعادة محاولة نقلها بأمان.';
  }

  @override
  String model_recommended(Object provider) {
    return '$provider • موصى به: نموذج صغير ومنخفض التكلفة';
  }

  @override
  String session_meta(Object count, Object model, Object time) {
    return 'الرسائل: $count • $model • $time';
  }

  @override
  String model_scope_label(Object model, Object scope) {
    return '$model • $scope';
  }

  @override
  String get this_chat => 'هذه المحادثة';

  @override
  String get profile_default => 'الإعداد الافتراضي لملف التعريف';

  @override
  String minutes_ago(Object count) {
    return 'منذ $count د';
  }

  @override
  String hours_ago(Object count) {
    return 'منذ $count س';
  }

  @override
  String days_ago(Object count) {
    return 'منذ $count ي';
  }

  @override
  String get now_label => 'الآن';

  @override
  String get latest_label => 'الأحدث';

  @override
  String new_count_indicator(Object count) {
    return 'رسائل جديدة: $count';
  }

  @override
  String new_messages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'الرسائل الجديدة: $count',
      one: '$count رسالة جديدة',
    );
    return '$_temp0';
  }

  @override
  String activity_failed_summary(Object failures, Object total) {
    return 'حالات الفشل: $failures • الإجمالي: $total';
  }

  @override
  String activity_completed_summary(Object count) {
    return 'المكتمل: $count';
  }

  @override
  String tool_start_observed(Object time) {
    return 'رُصد البدء في $time (بالتوقيت المحلي)';
  }

  @override
  String tool_last_observed(Object time) {
    return 'آخر رصد في $time (بالتوقيت المحلي)';
  }

  @override
  String tool_result_recorded(Object time) {
    return 'سُجّلت النتيجة في $time (بالتوقيت المحلي)';
  }

  @override
  String get tool_time_unavailable => 'الوقت غير متاح';

  @override
  String get hermes_is_using_a_tool => 'يستخدم Hermes أداة';

  @override
  String hermes_is_using_tools(Object count) {
    return 'عدد الأدوات التي يستخدمها Hermes: $count';
  }

  @override
  String delegated_tasks_completed(Object count) {
    return 'المهام المفوّضة المكتملة: $count';
  }

  @override
  String delegated_tasks_active(Object count) {
    return 'المهام المفوّضة النشطة: $count';
  }

  @override
  String branch_main(Object label) {
    return '$label · الفرع الرئيسي';
  }

  @override
  String get you_heading => '## أنت';

  @override
  String get hermes_heading => '## Hermes';

  @override
  String get action_label => 'الإجراء';

  @override
  String get destination_label => 'الوجهة';

  @override
  String get markdown_source => 'المصدر';

  @override
  String get preview_label => 'معاينة';

  @override
  String get share_action_summarize => 'تلخيص';

  @override
  String get share_action_explain => 'شرح';

  @override
  String get share_action_research => 'بحث';

  @override
  String get share_action_remember => 'تذكّر';

  @override
  String get text_size_small => 'صغير';

  @override
  String get text_size_default => 'افتراضي';

  @override
  String get text_size_large => 'كبير';

  @override
  String get text_size_extra_large => 'كبير جدًا';

  @override
  String get text_size_use_system_description =>
      'استخدام حجم النص المحدد في إعدادات تسهيل الاستخدام في Android دون تغيير.';

  @override
  String text_size_percent_description(Object percent) {
    return '$percent% من حجم النص في Android.';
  }

  @override
  String text_size_label_description(Object description, Object label) {
    return '$label — $description';
  }

  @override
  String files_skipped(Object count) {
    return 'عدد الملفات التي جرى تخطّيها: $count. السبب: تجاوز حدّ العدد أو الحجم، أو تعذّر القراءة، أو حساسية اسم الملف.';
  }

  @override
  String model_scope_applied(Object effort, Object model) {
    return '$model • $effort — تسري هذه الإعدادات الآن على هذه المحادثة فقط.';
  }

  @override
  String get reasoning_minimal => 'أدنى';

  @override
  String get reasoning_low => 'منخفض';

  @override
  String get reasoning_medium => 'متوسط';

  @override
  String get reasoning_high => 'مرتفع';

  @override
  String get reasoning_max => 'أقصى';

  @override
  String get reasoning_ultra => 'فائق';

  @override
  String get status_running => 'قيد التشغيل';

  @override
  String get status_failed => 'فشل';

  @override
  String get status_done => 'تمّ';

  @override
  String get status_idle => 'خامل';

  @override
  String get upload_status_uploading => 'جارٍ الرفع';

  @override
  String get upload_status_uploaded => 'اكتمل الرفع';

  @override
  String attachment_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عدد المرفقات: $count',
      one: '$count مرفق',
    );
    return '$_temp0';
  }

  @override
  String get action_create => 'إنشاء';

  @override
  String get action_rename => 'إعادة تسمية';

  @override
  String get action_archive => 'أرشفة';

  @override
  String get action_restore => 'استعادة';

  @override
  String get action_delete => 'حذف';

  @override
  String get migrate => 'نقل';

  @override
  String assigned_chats(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عدد المحادثات المعيّنة: $count',
      one: '$count محادثة معيّنة',
    );
    return '$_temp0';
  }

  @override
  String get date_today => 'اليوم';

  @override
  String get date_yesterday => 'أمس';

  @override
  String get date_earlier => 'في وقت سابق';

  @override
  String get nav_home => 'الرئيسية';

  @override
  String get nav_more => 'المزيد';

  @override
  String get status_completed => 'مكتمل';

  @override
  String get filter_all => 'الكل';

  @override
  String get filter_recent => 'الأحدث';

  @override
  String connection_address_key(Object address, Object status) {
    return '$address  •  المفتاح: $status';
  }

  @override
  String model_via_provider(Object model, Object provider) {
    return '$model  \nعبر `$provider`';
  }

  @override
  String get deny => 'رفض';

  @override
  String get connect => 'اتصال';

  @override
  String get appearance => 'المظهر';

  @override
  String get connection_section => 'الاتصال';

  @override
  String get about => 'حول التطبيق';

  @override
  String version_label(Object version) {
    return 'الإصدار $version';
  }

  @override
  String get matched => 'مطابق';

  @override
  String get search => 'بحث';

  @override
  String get on => 'مفعّل';

  @override
  String get off => 'معطّل';

  @override
  String get reasoning_off => 'معطّل';

  @override
  String get hermes_response_ready => 'ردّ Hermes جاهز';

  @override
  String get admin_password_needed => 'كلمة مرور المسؤول مطلوبة';

  @override
  String get hermes_needs_a_sudo_password_for_the_pending_terminal_command =>
      'يحتاج Hermes إلى كلمة مرور sudo لتنفيذ أمر الطرفية المعلّق.';

  @override
  String get sudo_password => 'كلمة مرور sudo';

  @override
  String get secret_needed => 'يلزم إدخال قيمة سرّية';

  @override
  String get hermes_needs_a_secret_for_the_pending_skill =>
      'يحتاج Hermes إلى قيمة سرّية لتشغيل المهارة المعلّقة.';

  @override
  String get secret_value => 'القيمة السرّية';

  @override
  String get attached_file => 'ملف مرفق';

  @override
  String get pin_chat => 'تثبيت المحادثة';

  @override
  String get unpin_chat => 'إلغاء تثبيت المحادثة';

  @override
  String get pinned_chats => 'المحادثات المثبّتة';

  @override
  String could_not_update_chat_pin(Object error) {
    return 'تعذّر تحديث حالة تثبيت المحادثة: $error';
  }

  @override
  String get could_not_save_chat_spaces =>
      'تعذّر حفظ مساحات المحادثات على هذا الجهاز';

  @override
  String get chat_density => 'كثافة عرض المحادثة';

  @override
  String chat_density_2(Object label) {
    return 'كثافة عرض المحادثة: $label';
  }

  @override
  String get chat_density_comfortable => 'مريح';

  @override
  String get chat_density_compact => 'مضغوط';

  @override
  String get chat_density_comfortable_description =>
      'فقاعات أوسع يظهر فوق كلّ منها اسم المُرسِل.';

  @override
  String get chat_density_compact_description =>
      'فقاعات أصغر بلا أسماء للمرسلين، لتتسع الشاشة لعدد أكبر من الرسائل.';

  @override
  String chat_density_label_description(Object description, Object label) {
    return '$label — $description';
  }

  @override
  String
  get compact_removes_the_you_and_hermes_labels_and_trims_bubble_padding_spacing_and_side_margins =>
      'يخفي العرض المضغوط التسميتين «أنت» و«Hermes»، ويقلّل المساحة داخل الفقاعات والمسافات بينها والهوامش الجانبية.';

  @override
  String get client_certificate_mtls => 'شهادة العميل (mTLS)';

  @override
  String get client_certificate_mtls_description =>
      'قدّم شهادة عندما يتطلب وكيل HTTPS مصادقة متبادلة باستخدام TLS.';

  @override
  String get client_certificate_https_only =>
      'لا تُستخدم شهادات العميل إلا مع اتصالات HTTPS.';

  @override
  String get choose_certificate => 'اختيار شهادة';

  @override
  String get certificate_password => 'كلمة مرور الشهادة';

  @override
  String get this_certificate_is_password_protected =>
      'هذه الشهادة محمية بكلمة مرور. ستُفتح بمجرد كتابة كلمة المرور الصحيحة.';

  @override
  String get enter_the_certificate_password_to_finish_loading_it =>
      'أدخل كلمة مرور الشهادة التي اخترتها لإكمال تحميلها.';

  @override
  String get client_certificate_required =>
      'حمّل شهادة عميل أو عطّل خيار شهادة العميل.';

  @override
  String client_certificate_loaded(String label) {
    return 'الشهادة المحمّلة: $label';
  }

  @override
  String get remove_certificate => 'إزالة الشهادة';

  @override
  String get certificate_import_failed => 'تعذّر تحميل تلك الشهادة.';

  @override
  String get background_work => 'العمل في الخلفية';

  @override
  String get keep_chats_active_in_background =>
      'إبقاء المحادثات نشطة في الخلفية';

  @override
  String get background_work_description =>
      'يُبقي هذا الخيار المحادثات التي بدأتها متصلة أثناء عمل التطبيق في الخلفية. قد تنقطع الاتصالات الخاملة. يزيد تفعيل هذا الخيار من استهلاك البطارية والبيانات، ولا يؤدي تعطيله إلى إيقاف العمل على الخادم.';

  @override
  String get background_work_limits =>
      'قد يعلّق Android الاتصالات في وضع السكون (Doze) أو ينهي عملية التطبيق. لتلقّي الإشعارات بعد انتهاء العملية، يجب إعداد الإشعارات الفورية بشكل منفصل. الإيقاف الإجباري غير مدعوم.';

  @override
  String get background_work_disclosure =>
      'يبقى إشعار الخدمة الإلزامي ظاهرًا ما دامت الحماية في الخلفية مفعّلة، حتى عند إيقاف إشعارات المحادثة الاختيارية.';

  @override
  String get battery_optimisation_settings => 'إعدادات تحسين استهلاك البطارية';

  @override
  String get battery_optimisation_description =>
      'افتح إعدادات Android لمراجعة قيود البطارية. لا يطلب التطبيق إعفاءً تلقائيًا، وتغيير الإعدادات لا يضمن وصول الإشعارات.';

  @override
  String get battery_settings_unavailable =>
      'تعذّر فتح إعدادات البطارية على هذا الجهاز.';

  @override
  String get background_work_save_failed => 'تعذّر حفظ إعداد العمل في الخلفية.';

  @override
  String get ongoing_chat_channel_name => 'المحادثات النشطة';

  @override
  String get ongoing_chat_channel_description =>
      'إشعارات صامتة بحالة المحادثات التي بدأتها ولم تنتهِ بعد';

  @override
  String get task_timeline => 'التسلسل الزمني للمهمة';

  @override
  String get task_refresh_history => 'تحديث سجل المهمة';

  @override
  String get task_live_preview => 'معاينة مباشرة من أحداث المهمة الأم';

  @override
  String get task_preview_explanation =>
      'تعرض المعاينة آخر ما أُتيح فقط، وليست جزءًا من السجل المحفوظ.';

  @override
  String get task_preview => 'معاينة';

  @override
  String get task_recorded_history => 'سجل المهمة المحفوظ';

  @override
  String get task_loading_history => 'جارٍ تحميل سجل المهمة…';

  @override
  String get task_empty_history =>
      'لا توجد رسائل مسجّلة بعد. ربما لم تحفظ المهمة سجلها بعد، وهذا لا يعني أنها لم تنجز أي عمل.';

  @override
  String get task_load_older => 'تحميل السجلات الأقدم';

  @override
  String get task_default_goal => 'مهمة مفوّضة';

  @override
  String task_status(Object status) {
    return 'الحالة: $status';
  }

  @override
  String task_identity(Object id) {
    return 'المهمة: $id';
  }

  @override
  String task_stored_session(Object id) {
    return 'الجلسة المحفوظة: $id';
  }

  @override
  String task_delegation(Object id) {
    return 'التفويض: $id';
  }

  @override
  String get task_read_only_notice =>
      'للقراءة فقط · قد يظهر السجل بعد أن تحفظه المهمة. حدّث الصفحة للتحقق مجددًا.';

  @override
  String task_row_label(Object id, Object role) {
    return '$role · السطر $id';
  }

  @override
  String get task_role_assistant => 'المساعد';

  @override
  String get task_role_user => 'المستخدم';

  @override
  String get task_role_tool => 'الأداة';

  @override
  String task_tool_call(Object name) {
    return 'استدعاء أداة · $name';
  }

  @override
  String task_tool_result(Object name) {
    return 'نتيجة الأداة · $name';
  }

  @override
  String task_call_details(Object arguments, Object id) {
    return 'معرّف الاستدعاء: $id\nالوسائط\n$arguments';
  }

  @override
  String task_result_details(Object id, Object result) {
    return 'معرّف الاستدعاء: $id\nالنتيجة\n$result';
  }

  @override
  String get task_not_supplied => 'غير متوفر';

  @override
  String get task_missing_arguments => 'لم يحتفظ الخادم بوسائط الاستدعاء.';

  @override
  String get task_image_placeholder => '[صورة]';

  @override
  String get task_invalid_reference =>
      'نصّ المهمة غير متاح: المرجع المحفوظ للجلسة غير صالح.';

  @override
  String get task_auth_required =>
      'نصّ المهمة غير متاح: اضبط إعدادات مصادقة لوحة التحكم لهذه البوابة. لا يتيح مفتاح خادم API الاطّلاع على خطوات تفكير المهمة.';

  @override
  String get task_auth_rejected =>
      'نصّ المهمة غير متاح: رفضت لوحة التحكم المصادقة. تحقّق من إعدادات لوحة التحكم لهذه البوابة.';

  @override
  String get task_incompatible_history =>
      'نصّ المهمة غير متاح: لا تتيح لوحة التحكم هذه قراءة جزء محدود من السجل بصيغته الأصلية بطريقة متوافقة مع ملف التعريف المحدد.';

  @override
  String get task_identity_unproven =>
      'نصّ المهمة غير متاح: لم تتمكن لوحة التحكم من التحقق من هوية الجلسة المحفوظة أو تتبّع أصلها عبر عمليات الضغط. لم يُعرض نصّ من أي جلسة أخرى.';

  @override
  String get task_partial_compression =>
      'السجل غير مكتمل: استمرّت المهمة بعد الضغط، لكن البوابة لم تُتح مرجعًا أحدث يمكن التحقق منه. قد لا يظهر الرد الأخير. أُوقف التحديث التلقائي مؤقتًا؛ اضغط على «تحديث» للمحاولة مجددًا.';

  @override
  String get task_partial_ancestors =>
      'السجل غير مكتمل: لا تعرض البوابة السجلات السابقة التي استُخدمت في ضغط سجل هذه المهمة، لذا قد تغيب بعض أجزائه الأولى. تبقى السطور المتاحة محفوظة؛ اضغط على «تحديث» للمحاولة مجددًا.';

  @override
  String get task_missing_reference =>
      'نصّ المهمة غير متاح: لم يحتفظ الخادم بمرجع الجلسة الخاصة بها.';

  @override
  String get task_missing_row_identity =>
      'نصّ المهمة غير متاح: لم يوفّر الخادم معرّفات ثابتة لسطور الرسائل.';

  @override
  String get task_history_not_ready =>
      'سجل المهمة غير متاح بعد (HTTP 404). ربما لم تحفظ المهمة سجلها بعد، أو ربما لا تدعم لوحة التحكم سجل المهام. حاول مجددًا للتحقق.';

  @override
  String get task_refresh_failed =>
      'تعذّر تحديث سجل المهمة. تحقّق من الاتصال ثم حاول مجددًا.';

  @override
  String get task_status_interrupted => 'انقطعت';

  @override
  String get task_status_cancelled => 'أُلغيت';

  @override
  String get task_status_requested => 'طُلِبت';

  @override
  String get task_status_thinking => 'جارٍ التفكير';

  @override
  String get task_status_tool => 'جارٍ استخدام أداة';

  @override
  String get task_status_pending => 'قيد الانتظار';

  @override
  String get task_status_dispatched => 'أُرسلت للتنفيذ';

  @override
  String task_status_unknown(Object status) {
    return 'حالة غير معروفة: $status';
  }

  @override
  String task_tasks_finished(Object count) {
    return 'المهام المفوّضة التي انتهت: $count';
  }

  @override
  String get activity_status_unconfirmed => 'الحالة غير مؤكدة';

  @override
  String get activity_recently_updated => 'حُدّث مؤخرًا';

  @override
  String get activity_reconnecting =>
      'جارٍ إعادة الاتصال للتحقق من حالة الجولة';

  @override
  String get activity_outcome_unknown =>
      'تعذّر تأكيد نتيجة الجولة. افتح المحادثة للتحقق.';

  @override
  String get activity_chat_updated_detail =>
      'سجّلت البوابة نشاطًا في المحادثة، لكن الحالة المباشرة للجولة غير متاحة.';

  @override
  String get activity_updated => 'حُدّث';

  @override
  String get activity_empty_title => 'لا يوجد نشاط حديث';

  @override
  String get activity_empty_detail =>
      'تظهر هنا الجولات التي بدأتَها في هذا التطبيق ومحادثات البوابة التي حُدّثت خلال آخر 7 أيام.';

  @override
  String get activity_read_error =>
      'تعذّرت قراءة سجلات الجولات أو محادثات البوابة لعرض النشاط. تحقّق من الاتصال وحاول مجددًا.';

  @override
  String get activity_chat_unavailable =>
      'لم تعد هذه المحادثة متاحة، أو تعذّر الاتصال بالبوابة.';

  @override
  String get activity_partial_title => 'لم يُحمَّل النشاط بالكامل';

  @override
  String get activity_partial_detail =>
      'يظهر جزء فقط من نشاط البوابة. قد تكون هناك محادثات أخرى؛ اسحب لأسفل للتحديث.';

  @override
  String get provider_usage => 'الاستخدام المسجّل';

  @override
  String get provider_usage_notice =>
      'هذه بيانات استخدام Hermes خلال آخر 30 يومًا، وليست رصيد الحساب أو أسعار النماذج. اضبط بيانات اعتماد المزوّد على خادم Hermes؛ فهذا التطبيق لا يخزّن مفاتيح API الخاصة بالمزوّد.';

  @override
  String get provider_usage_failed => 'تعذّر تحميل بيانات الاستخدام المسجّل.';

  @override
  String get provider_usage_empty => 'لا يوجد استخدام مسجّل لهذا المزوّد.';

  @override
  String provider_usage_counts(String sessions, String input, String output) {
    return 'الجلسات: $sessions · المدخلات: $input · المخرجات: $output';
  }

  @override
  String provider_usage_costs(String estimated, String actual) {
    return 'التكلفة المقدّرة: $estimated · التكلفة المُبلّغ عنها: $actual';
  }

  @override
  String get provider_quota_codex => 'اشتراك OpenAI Codex';

  @override
  String get provider_quota_claude => 'اشتراك Claude';

  @override
  String get provider_quota_openai_api => 'الاستخدام المسجّل لواجهة OpenAI API';

  @override
  String get provider_quota_notice =>
      'يعرض المزوّد حدود الاشتراك لكل فترة، وهي منفصلة عن الاستخدام الذي يسجّله Hermes وعن فواتير API. يُعرض كل حساب على حدة؛ وبلوغ حدّ نموذج معيّن لا يعني استنفاد حصة الحساب بالكامل.';

  @override
  String get provider_quota_windows_notice =>
      'لاشتراكات Codex وClaude حدود لكل جلسة مدتها خمس ساعات وحدود أسبوعية. لا تظهر إلا الفترات التي يُبلغ عنها المزوّد. إذا لم يذكر حدًا أو موعدًا لتجديد الحصة، تظل هذه المعلومة غير متاحة. قد تسري الحدود الأسبوعية على الحساب أو على نماذج معيّنة.';

  @override
  String get provider_quota_five_hour_session => 'جلسة مدتها 5 ساعات';

  @override
  String get provider_quota_unavailable => 'حصة الاشتراك غير متاحة.';

  @override
  String get provider_quota_failed =>
      'تعذّر تحديث حصة الاشتراك. أي قيم محفوظة تعود إلى آخر قراءة.';

  @override
  String get provider_quota_account => 'الحساب';

  @override
  String get provider_quota_unknown => 'غير معروف';

  @override
  String provider_quota_state(String state) {
    return 'حالة الحساب: $state';
  }

  @override
  String provider_quota_scope(String scope) {
    return 'النطاق: $scope';
  }

  @override
  String provider_quota_percent(String used, String remaining) {
    return 'المُستخدَم: $used% · المتبقي: $remaining%';
  }

  @override
  String provider_quota_reset(String reset) {
    return 'موعد تجديد الحصة: $reset';
  }

  @override
  String get provider_quota_reset_unknown => 'موعد تجديد الحصة غير متاح.';

  @override
  String get auxiliary_models => 'النماذج المساعدة';

  @override
  String get auxiliary_notice =>
      'اختر نموذجًا لكل مهمة. يجب إدارة نقاط الاتصال المخصّصة على الخادم. يتّبع الخيار «تلقائي» قواعد توارث الإعدادات الخاصة بالمهمة.';

  @override
  String get auxiliary_inherit => 'تلقائي (توارث الإعدادات)';

  @override
  String get auxiliary_unavailable => 'إعدادات النماذج المساعدة غير متاحة.';

  @override
  String get provider_oauth_title => 'تسجيل الدخول لدى المزوّد';

  @override
  String get provider_oauth_more_subtitle =>
      'إدارة تسجيل الدخول لدى المزوّد على مضيف Hermes';

  @override
  String get provider_oauth_settings_subtitle =>
      'سجّل الدخول على مضيف Hermes؛ لا تُخزَّن رموز المزوّد على هذا الجهاز';

  @override
  String get provider_oauth_intro =>
      'سجّل الدخول إلى حسابك لدى المزوّد في متصفح خارجي. تُحفظ رموز الوصول على مضيف Hermes فقط، وليس على هذا الجهاز. لا يؤدي تسجيل الدخول إلى اختيار نموذج للمحادثة في هذا التطبيق.';

  @override
  String get provider_oauth_defaults_notice =>
      'قد تؤدي بعض إجراءات المضيف، مثل استبدال حساب الباقة المجانية لدى Nous، إلى تغيير إعداداته الافتراضية. راجع إعدادات المضيف بعد تسجيل الدخول.';

  @override
  String get provider_oauth_transport_init_failed =>
      'تعذّر تهيئة وسيلة الاتصال الآمن المحددة للوحة التحكم. تحقّق من هوية TLS وإعدادات الاتصال.';

  @override
  String get provider_oauth_https_required =>
      'يتطلب تسجيل الدخول لدى المزوّد اتصالًا بلوحة تحكم Hermes عبر HTTPS.';

  @override
  String get provider_oauth_auth_required =>
      'أعدّ المصادقة بكلمة مرور للوحة التحكم أو اضبط وكيلًا موثوقًا قبل تسجيل الدخول.';

  @override
  String get provider_oauth_catalog_failed =>
      'تسجيل الدخول لدى المزوّد غير متاح على هذا المضيف. تحقّق من مصادقة لوحة التحكم، وحدّث المضيف إن لم يكن يدعم OAuth للمزوّد.';

  @override
  String get provider_oauth_expired =>
      'انتهت صلاحية طلب تسجيل الدخول. ابدأ من جديد.';

  @override
  String get provider_oauth_start_failed =>
      'تعذّر بدء تسجيل الدخول الآمن لدى المزوّد. حاول مجددًا.';

  @override
  String get provider_oauth_denied => 'رُفض طلب تسجيل الدخول. ابدأ من جديد.';

  @override
  String get provider_oauth_cancelled => 'أُلغي تسجيل الدخول.';

  @override
  String get provider_oauth_host_failed =>
      'تعذّر على المضيف إكمال تسجيل الدخول. ابدأ من جديد.';

  @override
  String get provider_oauth_poll_failed =>
      'تعذّر التحقق من حالة تسجيل الدخول. ابدأ من جديد.';

  @override
  String provider_oauth_cancellation_unconfirmed(String message) {
    return '$message تعذّر تأكيد الإلغاء؛ قد تبقى الجلسة نشطة على المضيف حتى تنتهي صلاحيتها.';
  }

  @override
  String get provider_oauth_browser_failed =>
      'تعذّر فتح المتصفح الخارجي. أعد المحاولة أو ألغِ تسجيل الدخول.';

  @override
  String get provider_oauth_retry => 'إعادة المحاولة';

  @override
  String provider_oauth_complete(String provider) {
    return 'إكمال تسجيل الدخول إلى $provider';
  }

  @override
  String get provider_oauth_code_instruction =>
      'أدخل هذا الرمز المؤقت في صفحة المزوّد:';

  @override
  String get provider_oauth_waiting =>
      'بانتظار الموافقة. تنتهي صلاحية هذه الجلسة تلقائيًا.';

  @override
  String get provider_oauth_open_browser => 'فتح صفحة المزوّد في المتصفح';

  @override
  String get provider_oauth_cancel => 'إلغاء تسجيل الدخول';

  @override
  String get provider_oauth_signed_out => 'لم تسجّل الدخول على المضيف';

  @override
  String get provider_oauth_sign_in_again => 'تسجيل الدخول مجددًا';

  @override
  String get provider_oauth_sign_in => 'تسجيل الدخول';

  @override
  String get provider_oauth_cli_required =>
      'سجّل الدخول باستخدام واجهة سطر الأوامر (CLI) الخاصة بالمزوّد على مضيف Hermes. لا يتيح هذا المضيف تسجيل الدخول إلى هذا المزوّد من داخل التطبيق.';

  @override
  String get provider_oauth_checking_account =>
      'وصلت الموافقة. جارٍ التحقق من الحساب على المضيف…';

  @override
  String get provider_oauth_verification_unavailable =>
      'وصلت الموافقة، لكن التحقق من الحساب غير متاح. افتح «الاستخدام» لتحديث بيانات استخدام الحساب.';

  @override
  String provider_oauth_verified_account(String email) {
    return 'سجّلت الدخول إلى مضيف Hermes بالحساب $email. افتح «الاستخدام» لتحديث بيانات استخدام الحساب.';
  }

  @override
  String get provider_oauth_credentials_unverified =>
      'يشير المضيف إلى توفّر بيانات الاعتماد، لكن لم يجرِ التحقق من هوية الحساب.';

  @override
  String get provider_oauth_account_status_unknown =>
      'حالة الحساب على المضيف غير متاحة.';

  @override
  String get app_language => 'لغة التطبيق';

  @override
  String get app_language_system => 'لغة الهاتف';

  @override
  String get auto_archives_after_72_hours => 'يُؤرشف تلقائيًا بعد 72 ساعة';

  @override
  String get automation => 'الأتمتة';

  @override
  String get voice_recording_start => 'تسجيل رسالة صوتية';

  @override
  String get voice_recording_pause => 'إيقاف التسجيل مؤقتًا';

  @override
  String get voice_recording_preview => 'تشغيل التسجيل';

  @override
  String get voice_recording_resume => 'متابعة التسجيل';

  @override
  String get voice_recording_send => 'إرسال الرسالة الصوتية';

  @override
  String get voice_recording_discard => 'تجاهل التسجيل';

  @override
  String get voice_recording_processing => 'جارٍ تجهيز الرسالة الصوتية…';

  @override
  String voice_recording_elapsed(String time) {
    return 'جارٍ التسجيل: $time';
  }

  @override
  String voice_recording_draft(String time) {
    return 'رسالة صوتية: $time';
  }

  @override
  String get voice_recording_permission =>
      'اسمح بالوصول إلى الميكروفون لتسجيل رسالة صوتية.';

  @override
  String get voice_recording_limit => 'بلغ التسجيل مدته القصوى وهي عشر دقائق.';

  @override
  String get voice_recording_empty => 'لم يُسجَّل أي صوت. أعد المحاولة.';

  @override
  String get voice_recording_failed =>
      'تعذّرت معالجة التسجيل. احتفظ التطبيق بكل المقاطع المحفوظة.';

  @override
  String get voice_recording_unconfirmed =>
      'لم يتأكد وصول الرسالة. تسجيلك محفوظ. تحقّق من المحادثة قبل إعادة المحاولة.';

  @override
  String get voice_recording_submit_failed =>
      'تعذّر إرسال الرسالة الصوتية. تسجيلك محفوظ. تحقّق من الاتصال وإمكانية الوصول إلى لوحة التحكم وإعدادات تحويل الصوت إلى نص على الخادم.';

  @override
  String get voice_recording_pause_playback => 'إيقاف التشغيل مؤقتًا';

  @override
  String get projects_root_title => 'مجلد المشاريع على الخادم';

  @override
  String get projects_root_more_subtitle =>
      'المكان الذي تُنشأ فيه مجلدات المشاريع الجديدة على الخادم';

  @override
  String get projects_root_description =>
      'يُنشأ هنا مجلد لكل مشروع تنشئه على هذا الهاتف. حدّد المجلد الذي يستخدمه Hermes نفسه لتتمكن من الوصول إلى المشاريع نفسها من الهاتف والخادم.';

  @override
  String get projects_root_label => 'مسار المجلد الجذر للمشاريع';

  @override
  String projects_root_default_hint(String path) {
    return 'المسار الافتراضي للخادم: $path';
  }

  @override
  String get projects_root_locked_title => 'يحدّده الخادم';

  @override
  String get projects_root_locked_explanation =>
      'يقصر هذا الخادم الوصول إلى الملفات على مجلد جذر واحد، لذا لا يمكنك تغيير مجلد المشاريع من التطبيق.';

  @override
  String get projects_root_saved => 'حُفظ مجلد المشاريع.';

  @override
  String get projects_root_reset => 'استخدام المسار الافتراضي للخادم';

  @override
  String get projects_root_invalid_empty => 'أدخل مسار مجلد.';

  @override
  String get projects_root_invalid_absolute =>
      'أدخل مسارًا مطلقًا يبدأ بشرطة مائلة (/).';

  @override
  String get projects_root_invalid_segments =>
      'أزل مقاطع النقاط ومحارف التحكم من المسار.';

  @override
  String get projects_root_unsupported =>
      'هذا الاتصال لا يدعم هذه الميزة. تحتاج إلى اتصال ببوابة سطح المكتب (Desktop Gateway) يتيح الوصول إلى لوحة التحكم لقراءة مجلد المشاريع على الخادم أو تغييره.';

  @override
  String get projects_root_unavailable =>
      'تعذّرت قراءة مجلد المشاريع على الخادم. تحقّق من الاتصال بلوحة التحكم، ثم أعد المحاولة.';

  @override
  String get adopt_folder_action => 'إضافة مجلد موجود';

  @override
  String adopt_folder_description(String root) {
    return 'المجلدات الموجودة ضمن $root التي لم تُسجَّل كمشاريع بعد.';
  }

  @override
  String adopt_folder_registered(String name) {
    return 'مسجّل بالفعل كمشروع: $name';
  }

  @override
  String get adopt_folder_none => 'كل مجلد ضمن هذا المسار مسجّل بالفعل كمشروع.';

  @override
  String get adopt_folder_unsupported =>
      'لا يتيح هذا الاتصال عرض مجلدات الخادم. أدخل بدلًا من ذلك المسار المطلق لمجلد موجود.';

  @override
  String adopt_folder_failed(String error) {
    return 'تعذّر عرض مجلدات الخادم: $error';
  }

  @override
  String get adopt_folder_manual_label => 'مسار المجلد الموجود';

  @override
  String get adopt_folder_name_label => 'اسم المشروع';

  @override
  String get adopt_folder_add => 'إضافة كمشروع';

  @override
  String adopt_folder_added(String name, String path) {
    return 'يستخدم $name الآن المسار $path';
  }

  @override
  String adopt_folder_error(String error) {
    return 'تعذّرت إضافة المجلد: $error';
  }

  @override
  String adopt_folder_folderless(String name) {
    return 'أُنشئ المشروع $name، لكن لم يُربط به المجلد. اربطه من خلال Hermes على الخادم.';
  }

  @override
  String get slash_commands => 'أوامر الشرطة المائلة';

  @override
  String get slash_commands_loading => 'جارٍ تحميل الأوامر…';

  @override
  String get slash_commands_empty => 'لا توجد أوامر مطابقة';

  @override
  String slash_command_info_alias(String alias, String command) {
    return '$alias اسم بديل للأمر $command';
  }

  @override
  String get slash_command_info_no_description => 'لا يوجد وصف متاح.';

  @override
  String get slash_command_info_arguments_options =>
      'يقبل خيارًا واحدًا من قائمة محدّدة.';

  @override
  String get slash_command_info_arguments_text => 'يقبل نصًا بعد الأمر.';

  @override
  String get slash_command_info_arguments_mixed =>
      'يقبل خيارًا أو نصًا بعد الأمر.';

  @override
  String get slash_command_output => 'مخرجات الأمر';

  @override
  String get slash_command_no_output => 'اكتمل تنفيذ الأمر دون مخرجات.';

  @override
  String get slash_command_delivery_unknown =>
      'أُرسل الأمر لكن لم يصل ردّ. قد يظلّ قيد التنفيذ على البوابة، لذا احتفظنا بمسودتك. تحقّق من البوابة قبل إعادة المحاولة.';

  @override
  String get slash_command_failed => 'تعذّر تنفيذ الأمر.';

  @override
  String get slash_command_unsupported => 'هذا الأمر غير متاح على هذا الخادم.';

  @override
  String get slash_sessions_inline =>
      'افتح قائمة الجلسات لاختيار محادثة. مسودتك محفوظة.';

  @override
  String get composer_snippets => 'مقتطفات الطلبات';

  @override
  String get composer_snippets_description =>
      'اختر طلبًا مبدئيًا لإدراجه في محرّر الرسائل.';

  @override
  String get composer_snippet_review => 'مراجعة الشيفرة';

  @override
  String get composer_snippet_review_body =>
      'راجع التغيير الحالي بحثًا عن تراجعات وحالات طرفية أُغفلت واختبارات ناقصة.';

  @override
  String get composer_snippet_review_text =>
      'يرجى مراجعة هذا بحثًا عن أخطاء وتراجعات واختبارات ناقصة.';

  @override
  String get composer_snippet_plan => 'خطة التنفيذ';

  @override
  String get composer_snippet_plan_body =>
      'حدّد نهجًا قبل تعديل الشيفرة لإبقاء التغييرات مركّزة.';

  @override
  String get composer_snippet_plan_text =>
      'يرجى وضع خطة تنفيذ موجزة قبل تعديل الشيفرة.';

  @override
  String get composer_snippet_explain => 'اشرح هذا';

  @override
  String get composer_snippet_explain_body =>
      'اشرح طريقة عمل الشيفرة المحددة وأشِر إلى الملفات الأساسية.';

  @override
  String get composer_snippet_explain_text =>
      'يرجى شرح طريقة عمل هذا وإرشادي إلى الملفات الأساسية.';

  @override
  String get composer_status => 'الحالة';

  @override
  String get composer_status_context => 'السياق';

  @override
  String get composer_status_cache => 'إصابة الذاكرة المؤقتة';

  @override
  String get composer_status_throughput => 'رموز الإخراج/ثانية';

  @override
  String get composer_status_running => 'قيد التشغيل';

  @override
  String get composer_status_session => 'الجلسة';

  @override
  String get composer_status_not_reported => 'لم يُبلّغ عنه';

  @override
  String get composer_status_empty => 'لم تُرسل تفاصيل توزيع السياق.';

  @override
  String get composer_status_loading => 'جارٍ تحميل تفاصيل توزيع السياق';

  @override
  String get composer_status_reset => 'إعادة ضبط شريط الحالة';

  @override
  String get composer_resume_title => 'استئناف دردشة';

  @override
  String get composer_resume_search => 'البحث في العناوين والمعرّفات';

  @override
  String get composer_resume_empty => 'لا توجد دردشات مطابقة.';

  @override
  String get composer_resume_unavailable =>
      'لا تتضمن هذه اللوحة قائمة دردشات للبحث فيها.';

  @override
  String get composer_failure_retry => 'إعادة المحاولة';

  @override
  String composer_failure_retry_at(String time) {
    return 'إعادة المحاولة عند $time';
  }

  @override
  String get composer_failure_compress => 'ضغط';

  @override
  String get composer_failure_switch_model => 'تبديل النموذج';

  @override
  String composer_failure_switch_to(String model) {
    return 'التبديل إلى $model';
  }

  @override
  String get composer_failure_new_chat => 'محادثة جديدة';

  @override
  String get composer_failure_edit => 'تعديل الرسالة';

  @override
  String get composer_failure_details => 'التفاصيل';

  @override
  String get composer_failure_hide_details => 'إخفاء التفاصيل';

  @override
  String get composer_failure_copy => 'نسخ بيانات التشخيص';

  @override
  String get composer_failure_account =>
      'الحل الآخر يتطلب إجراءً في حساب البوابة. لا يمكن تنفيذه من هذه الدردشة.';

  @override
  String get composer_failure_account_only =>
      'يجب إصلاح هذا في حساب البوابة. لا يمكن تنفيذه من هذه الدردشة.';

  @override
  String get composer_failure_confirm_compress =>
      'هل تريد ضغط هذه الدردشة؟ ستختصر البوابة سجل المحادثة.';

  @override
  String composer_failure_confirm_model(String model) {
    return 'هل تريد تبديل هذه الدردشة إلى $model؟';
  }

  @override
  String get composer_drop_attach => 'أفلت للإرفاق';

  @override
  String get composer_drop_folder_unsupported =>
      'لا يمكن إرفاق المجلدات. أفلت الملفات بدلًا منها.';

  @override
  String get composer_drop_reference => 'أفلت لإضافة مرجع';

  @override
  String get composer_reference_copy => 'نسخ المرجع';

  @override
  String get composer_reference_remove => 'إزالة المرجع';

  @override
  String get composer_btw_usage =>
      'الاستخدام: /btw <question> — إجابة من لقطة لهذه المحادثة دون مقاطعتها.';

  @override
  String get composer_background_usage =>
      'الاستخدام: /background <prompt> — تعمل المهمة بشكل منفصل وتعود النتيجة إلى هنا.';

  @override
  String get composer_handoff_usage =>
      'الاستخدام: /handoff <platform> — نقل هذه الدردشة إلى منصة المراسلة المحددة.';

  @override
  String get composer_command_needs_session => 'يتطلب هذا الأمر دردشة مفتوحة.';

  @override
  String get composer_retry_not_found =>
      'هذا التبادل غير موجود في السجل المحفوظ، لذا لا يمكن لخيار «إعادة المحاولة» استبداله. لم يُرسل شيء مجددًا. عدّل الرسالة وأرسلها للمحاولة من جديد.';

  @override
  String get composer_retry_unavailable =>
      'لا يمكن لخيار «إعادة المحاولة» استبدال تبادل عبر هذا الاتصال، لذا لم يُرسل شيء مجددًا. عدّل الرسالة وأرسلها للمحاولة من جديد.';

  @override
  String get composer_failure_switch_no_retry =>
      'يغيّر التبديل النموذج فقط: لا يمكن لهذا الاتصال إعادة تشغيل الدور الفاشل. أرسله مجددًا بعد التبديل.';

  @override
  String get composer_command_needs_gateway_session =>
      'ليس لهذه الدردشة جلسة على البوابة بعد. أرسل رسالة أولًا، ثم شغّل الأمر مجددًا.';

  @override
  String get composer_side_question => 'btw — إجابة من لقطة للمحادثة';

  @override
  String composer_side_question_id(String id) {
    return 'btw $id — إجابة من لقطة للمحادثة';
  }

  @override
  String get composer_background_started =>
      'بدأت المهمة في الخلفية. يمكنك متابعة الدردشة. ستظهر النتيجة هنا.';

  @override
  String composer_background_started_id(String id) {
    return 'بدأت المهمة $id في الخلفية. يمكنك متابعة الدردشة. ستظهر النتيجة هنا.';
  }

  @override
  String composer_handoff_requested(String platform) {
    return 'طُلب النقل إلى $platform.';
  }

  @override
  String composer_handoff_done(String platform) {
    return 'نُقلت هذه الدردشة إلى $platform.';
  }

  @override
  String get composer_handoff_failed => 'تعذّر النقل.';

  @override
  String get composer_handoff_timeout =>
      'لم يكتمل النقل. قد يكون لا يزال قيد التنفيذ على البوابة.';

  @override
  String get composer_compress_done => 'ضُغطت هذه الدردشة.';

  @override
  String get composer_file_missing => 'هذا الملف غير موجود على هذا الجهاز.';

  @override
  String get composer_attach_busy => 'يمكن إضافة المرفقات بعد اكتمال هذا الرد.';

  @override
  String get nextgen_toggle => 'واجهة NextGen';

  @override
  String get nextgen_toggle_subtitle =>
      'تصميم جديد يتيح تسجيل الدخول مرة واحدة والمحادثات المباشرة واكتشاف الأجهزة على الشبكة. بواباتك ومحادثاتك متاحة في هذه الواجهة أيضًا.';

  @override
  String get nextgen_single_login => 'تسجيل الدخول مرة واحدة';

  @override
  String get nextgen_single_login_subtitle =>
      'لإضافة بوابة، يكفي إدخال عنوان لوحة التحكم وتسجيل الدخول مرة واحدة.';

  @override
  String get ng_allow_this_command => 'هل تسمح بتنفيذ هذا الأمر؟';

  @override
  String ng_hermes_wants_to_run_this_with(Object tool) {
    return 'يريد Hermes تنفيذ هذا الأمر باستخدام $tool.';
  }

  @override
  String get ng_hermes_wants_to_run_this => 'يريد Hermes تنفيذ هذا الأمر.';

  @override
  String get ng_hermes_has_a_question => 'لدى Hermes سؤال';

  @override
  String get ng_hermes_has_questions => 'لدى Hermes أسئلة';

  @override
  String get ng_password_for_sudo => 'كلمة مرور sudo';

  @override
  String get ng_hermes_needs_your_sudo_password_to =>
      'يحتاج Hermes إلى كلمة مرور sudo الخاصة بك لتنفيذ هذا الأمر.';

  @override
  String get ng_a_secret_value => 'قيمة سرية';

  @override
  String ng_value_for(Object variable) {
    return 'قيمة $variable';
  }

  @override
  String get ng_your_password_manager => 'مدير كلمات المرور لديك';

  @override
  String ng_unlock(Object name) {
    return 'فتح قفل $name';
  }

  @override
  String ng_hermes_needs_unlocked_to_sign_in(Object name) {
    return 'يحتاج Hermes إلى فتح قفل $name لتسجيل الدخول نيابةً عنك.';
  }

  @override
  String get ng_sign_in_code => 'رمز تسجيل الدخول';

  @override
  String get ng_enter_the_sign_in_code => 'أدخل رمز تسجيل الدخول.';

  @override
  String ng_enter_the_sign_in_code_for(Object site) {
    return 'أدخل رمز تسجيل الدخول إلى $site.';
  }

  @override
  String get ng_save_a_login => 'هل تريد حفظ بيانات تسجيل الدخول؟';

  @override
  String ng_save_your_login(Object site) {
    return 'هل تريد حفظ بيانات تسجيل دخولك إلى $site؟';
  }

  @override
  String ng_couldn_t_load_this_chat(Object error) {
    return 'تعذّر تحميل هذه المحادثة: $error';
  }

  @override
  String ng_live_updates_are_unavailable(Object error) {
    return 'التحديثات المباشرة غير متاحة: $error';
  }

  @override
  String ng_preparing(Object name) {
    return 'جارٍ تجهيز $name…';
  }

  @override
  String get ng_the_turn_failed => 'فشلت معالجة الطلب.';

  @override
  String get ng_turn_changed =>
      'انتهت معالجة ذلك الطلب أو بدأت معالجة طلب أحدث';

  @override
  String get ng_steer_rejected => 'لم تُقبل الرسالة أثناء معالجة الطلب الحالي';

  @override
  String get ng_turn_not_known_yet =>
      'لم يُحدَّد الطلب الجاري بعد؛ أعد المحاولة بعد قليل';

  @override
  String ng_couldn_t_stop(Object error) {
    return 'تعذّر الإيقاف: $error';
  }

  @override
  String get ng_server_access => 'الوصول إلى الخادم';

  @override
  String get ng_sign_in => 'تسجيل الدخول';

  @override
  String get ng_live_connection => 'الاتصال المباشر';

  @override
  String get ng_check_that_tailscale_is_on_on =>
      'تأكّد من تشغيل Tailscale على هذا الهاتف وعلى الخادم.';

  @override
  String get ng_check_the_address_and_that_the =>
      'تحقّق من العنوان وتأكّد من أن الوكيل يعيد توجيه الطلبات إلى لوحة التحكم.';

  @override
  String get ng_use_the_same_network_as_the =>
      'اتصل بالشبكة نفسها التي يتصل بها الخادم، وشغّل لوحة التحكم باستخدام --host 0.0.0.0 لتتمكن الأجهزة الأخرى من الوصول إليها.';

  @override
  String get ng_check_the_address_vpn_or_tailscale =>
      'تحقّق من العنوان أو من اتصال VPN أو Tailscale.';

  @override
  String get ng_not_checked_yet => 'لم يجرِ التحقق بعد.';

  @override
  String get ng_checking => 'جارٍ التحقق…';

  @override
  String ng_hermes_answers_at(Object version, Object address) {
    return 'يستجيب Hermes $version على العنوان $address.';
  }

  @override
  String get ng_something_answered_but_not_a_hermes =>
      'وصل ردّ، لكنه ليس من لوحة تحكم Hermes.';

  @override
  String ng_something_answered_http_but_not_a(Object status) {
    return 'وصل ردّ (HTTP $status)، لكنه ليس من لوحة تحكم Hermes.';
  }

  @override
  String get ng_use_the_dashboard_s_address_and =>
      'استخدم عنوان لوحة التحكم ومنفذها (9119 افتراضيًا)، وليس عنوان خادم API ومنفذه.';

  @override
  String get ng_cloudflare_access_turned_the_service_token =>
      'رفضت Cloudflare Access رمز الخدمة.';

  @override
  String get ng_cloudflare_access_is_in_front_of =>
      'هذا العنوان محميّ بواسطة Cloudflare Access.';

  @override
  String get ng_check_the_service_token_and_its =>
      'تحقّق من رمز الخدمة وسياسة Service Auth الخاصة به.';

  @override
  String get ng_add_a_cloudflare_access_service_token =>
      'أضف رمز خدمة Cloudflare Access لهذا العنوان.';

  @override
  String get ng_the_server_asks_for_a_client => 'يطلب الخادم شهادة عميل.';

  @override
  String get ng_pick_the_client_certificate_for_this =>
      'اختر شهادة العميل لهذه البوابة، ثم أعد الاختبار.';

  @override
  String get ng_needs_server_access_first => 'يلزم الوصول إلى الخادم أولًا.';

  @override
  String get ng_needs_a_sign_in_first => 'يلزم تسجيل الدخول أولًا.';

  @override
  String ng_signed_in_as(Object name) {
    return 'سجّلت الدخول باسم $name.';
  }

  @override
  String get ng_this_dashboard_doesn_t_need_a =>
      'لا تتطلب لوحة التحكم هذه تسجيل الدخول.';

  @override
  String get ng_the_saved_sign_in_has_expired =>
      'انتهت صلاحية جلسة الدخول المحفوظة.';

  @override
  String get ng_sign_in_again => 'سجّل الدخول مجددًا.';

  @override
  String get ng_too_many_sign_in_attempts =>
      'تجاوزت الحد المسموح به لمحاولات تسجيل الدخول.';

  @override
  String get ng_wait_a_minute_then_check_again =>
      'انتظر دقيقة ثم تحقّق مجددًا.';

  @override
  String ng_the_gateway_answered(Object message) {
    return 'ردّت البوابة: $message.';
  }

  @override
  String get ng_sign_in_again_or_update_hermes =>
      'سجّل الدخول مجددًا أو حدّث Hermes.';

  @override
  String ng_couldn_t_check_the_sign_in(Object error) {
    return 'تعذّر التحقق من تسجيل الدخول: $error';
  }

  @override
  String ng_the_gateway_wouldn_t_issue_a(Object message) {
    return 'رفضت البوابة إصدار تذكرة اتصال بالمحادثة ($message).';
  }

  @override
  String get ng_the_chat_connection_opened_and_the =>
      'فُتح اتصال المحادثة وأكّدت البوابة جاهزيتها.';

  @override
  String get ng_the_gateway_never_said_it_was => 'لم تؤكّد البوابة جاهزيتها.';

  @override
  String get ng_check_that_the_agent_is_running =>
      'تأكّد من أن الوكيل يعمل على الخادم.';

  @override
  String get ng_the_gateway_refused_the_chat_connection =>
      'رفضت البوابة اتصال المحادثة (HTTP 403).';

  @override
  String get ng_this_dashboard_has_no_chat_endpoint =>
      'لا توفّر لوحة التحكم هذه نقطة اتصال للمحادثة (/api/ws).';

  @override
  String ng_the_chat_connection_failed(Object detail) {
    return 'فشل اتصال المحادثة: $detail';
  }

  @override
  String get ng_use_the_exact_address_the_dashboard =>
      'استخدم العنوان المحدّد في إعدادات لوحة التحكم كما هو.';

  @override
  String get ng_update_hermes => 'حدّث Hermes.';

  @override
  String get ng_make_sure_the_proxy_allows_websocket =>
      'تأكّد من أن الوكيل يسمح بترقية الاتصال إلى WebSocket على المسار /api/ws.';

  @override
  String get ng_offline => 'غير متصل';

  @override
  String get ng_connecting => 'جارٍ الاتصال…';

  @override
  String get ng_connected => 'متصل';

  @override
  String get ng_reconnecting => 'جارٍ إعادة الاتصال…';

  @override
  String get ng_signed_out => 'لم تسجّل الدخول';

  @override
  String get ng_connection_failed => 'فشل الاتصال';

  @override
  String get ng_rate_limited_by_gateway =>
      'فرضت البوابة حدًّا على معدل الطلبات';

  @override
  String ng_couldn_t_open_the_chat_connection(Object message) {
    return 'تعذّر فتح اتصال المحادثة: $message';
  }

  @override
  String get ng_the_gateway_returned_no_websocket_ticket =>
      'لم تُرسل البوابة تذكرة WebSocket.';

  @override
  String get ng_connection_lost => 'انقطع الاتصال';

  @override
  String get ng_this_dashboard_has_no_chat_endpoint_2 =>
      'لا توفّر لوحة التحكم هذه نقطة اتصال للمحادثة (/api/ws). حدّث Hermes.';

  @override
  String get ng_the_gateway_refused_the_chat_connection_2 =>
      'رفضت البوابة اتصال المحادثة. تأكّد من أن العنوان يطابق المضيف المحدّد في إعدادات لوحة التحكم وأن المحادثة المضمّنة مفعّلة.';

  @override
  String ng_the_gateway_refused(Object method) {
    return 'رفضت البوابة $method.';
  }

  @override
  String ng_couldn_t_read_your_saved_gateways(Object error) {
    return 'تعذّرت قراءة بواباتك المحفوظة: $error';
  }

  @override
  String get ng_applies_to_new_chats => 'يسري على المحادثات الجديدة';

  @override
  String ng_couldn_t_change(Object label, Object error) {
    return 'تعذّر تغيير $label: $error';
  }

  @override
  String get ng_capabilities => 'الإمكانات';

  @override
  String get ng_skills => 'المهارات';

  @override
  String get ng_toolsets => 'مجموعات الأدوات';

  @override
  String get ng_search => 'بحث';

  @override
  String get ng_couldn_t_load => 'تعذّر التحميل';

  @override
  String get ng_try_again => 'إعادة المحاولة';

  @override
  String get ng_no_skills => 'لا توجد مهارات';

  @override
  String get ng_no_toolsets => 'لا توجد مجموعات أدوات';

  @override
  String get ng_no_mcp_servers => 'لا توجد خوادم MCP';

  @override
  String get ng_that_file_is_too_large_to =>
      'هذا الملف أكبر من الحجم المتوقع لملف شهادة.';

  @override
  String ng_the_certificate_couldn_t_be_imported(Object error) {
    return 'تعذّر استيراد الشهادة: $error';
  }

  @override
  String get ng_now_pick_its_private_key => 'اختر الآن المفتاح الخاص بالشهادة.';

  @override
  String get ng_now_pick_its_certificate =>
      'اختر الآن الشهادة المرتبطة بالمفتاح.';

  @override
  String get ng_that_file_isn_t_a_certificate =>
      'هذا الملف ليس شهادة ولا مفتاحًا خاصًا.';

  @override
  String get ng_if_a_proxy_in_front_of =>
      'إذا كان الوكيل الذي يحمي هذا العنوان يطلب شهادة عميل، فاخترها هنا لتُقدَّم عند اختبار الاتصال وتسجيل الدخول واستخدام المحادثة.';

  @override
  String get ng_client_certificates_are_only_used_with =>
      'تُستخدم شهادات العميل فقط مع العناوين التي تبدأ بـ https://.';

  @override
  String get ng_remove => 'إزالة';

  @override
  String get ng_certificate_password => 'كلمة مرور الشهادة';

  @override
  String get ng_importing => 'جارٍ الاستيراد…';

  @override
  String get ng_pick_certificate => 'اختيار شهادة';

  @override
  String get ng_pick_a_different_certificate => 'اختيار شهادة أخرى';

  @override
  String get ng_accepts_p12_pfx_or_pem_certificate =>
      'يُقبل ملف بصيغة .p12/.pfx أو ملفا شهادة ومفتاح بصيغة PEM. يبقى المفتاح في مساحة التخزين الخاصة بالتطبيق.';

  @override
  String get ng_photos => 'الصور';

  @override
  String get ng_camera => 'الكاميرا';

  @override
  String get ng_files => 'الملفات';

  @override
  String ng_you_can_attach_up_to_files(Object count) {
    return 'الحد الأقصى لعدد الملفات التي يمكنك إرفاقها هو $count.';
  }

  @override
  String ng_couldn_t_read(Object name) {
    return 'تعذّرت قراءة $name.';
  }

  @override
  String ng_couldn_t_prepare_that_file(Object error) {
    return 'تعذّر تجهيز الملف: $error';
  }

  @override
  String get ng_hermes_is_still_working => 'لا يزال Hermes يعمل';

  @override
  String get ng_steer => 'توجيه';

  @override
  String get ng_adds_this_to_the_running_turn =>
      'يضيف هذه الرسالة إلى الطلب الجاري عند خطوته التالية';

  @override
  String get ng_queue => 'إضافة إلى قائمة الانتظار';

  @override
  String get ng_sends_it_when_the_turn_finishes =>
      'يرسل الرسالة بعد اكتمال معالجة الطلب الجاري';

  @override
  String get ng_stop_and_send => 'إيقاف وإرسال';

  @override
  String get ng_stops_the_turn_then_sends_this =>
      'يوقف معالجة الطلب الجاري ثم يرسل هذه الرسالة';

  @override
  String ng_dictation_stopped(Object message) {
    return 'توقّف الإملاء: $message';
  }

  @override
  String get ng_speech_recognition_isn_t_available =>
      'التعرّف على الكلام غير متاح.';

  @override
  String get ng_working => 'جارٍ العمل';

  @override
  String get ng_ready => 'جاهز';

  @override
  String get ng_chats => 'المحادثات';

  @override
  String get ng_new_chat => 'محادثة جديدة';

  @override
  String get ng_usage => 'الاستخدام';

  @override
  String get ng_rename_chat => 'إعادة تسمية المحادثة';

  @override
  String ng_couldn_t_rename(Object error) {
    return 'تعذّرت إعادة التسمية: $error';
  }

  @override
  String get ng_this_chat => 'هذه المحادثة';

  @override
  String get ng_input_tokens => 'رموز الإدخال';

  @override
  String get ng_output_tokens => 'رموز الإخراج';

  @override
  String get ng_reasoning_tokens => 'رموز الاستدلال';

  @override
  String get ng_cache_reads => 'عمليات القراءة من ذاكرة التخزين المؤقت';

  @override
  String get ng_api_calls => 'استدعاءات API';

  @override
  String get ng_cost => 'التكلفة';

  @override
  String get ng_context => 'السياق';

  @override
  String get ng_your_sign_in_expired => 'انتهت صلاحية جلسة دخولك.';

  @override
  String get ng_sign_in_2 => 'تسجيل الدخول';

  @override
  String get ng_retry => 'إعادة المحاولة';

  @override
  String get ng_project_home => 'الرئيسية';

  @override
  String get ng_choose_project => 'اختيار مشروع';

  @override
  String ng_project_cwd_fallback(String path) {
    return 'مجلد المشروع غير متاح، لذا تعمل هذه المحادثة في $path.';
  }

  @override
  String get ng_project_create_uncertain =>
      'ربما أنشأت البوابة هذه المحادثة، لكنها لم تؤكّد ذلك. تحقّق من «المحادثات» قبل بدء محادثة أخرى. لن يُعاد إرسال الطلب تلقائيًا.';

  @override
  String get ng_what_should_we_work_on => 'ما الذي تودّ أن نعمل عليه؟';

  @override
  String get ng_ask_hermes_anything_it_can_run =>
      'اسأل Hermes عمّا تشاء. يمكنه تشغيل الأدوات والتصفّح والعمل على ملفاتك الموجودة على الخادم.';

  @override
  String ng_working_2(Object frame) {
    return 'جارٍ العمل · $frame';
  }

  @override
  String get ng_default_model => 'النموذج الافتراضي';

  @override
  String get ng_listening => 'جارٍ الاستماع…';

  @override
  String get ng_steer_or_queue_a_message =>
      'أرسل توجيهًا أو أضف رسالة إلى قائمة الانتظار';

  @override
  String get ng_message_hermes => 'راسل Hermes';

  @override
  String get ng_attach => 'إرفاق';

  @override
  String get ng_stop_dictation => 'إيقاف الإملاء';

  @override
  String get ng_dictate => 'إملاء';

  @override
  String get ng_stop => 'إيقاف';

  @override
  String get ng_send => 'إرسال';

  @override
  String ng_slash_command_alias(String alias, String command) {
    return '$alias اسم بديل للأمر $command';
  }

  @override
  String get ng_slash_command_no_description => 'لا يوجد وصف متاح.';

  @override
  String get ng_slash_command_arguments_options =>
      'يقبل خيارًا واحدًا من قائمة محدّدة.';

  @override
  String get ng_slash_command_arguments_text => 'يقبل نصًا بعد الأمر.';

  @override
  String get ng_slash_command_arguments_mixed =>
      'يقبل خيارًا أو نصًا بعد الأمر.';

  @override
  String get ng_slash_command_sent_as_message =>
      'ترسل واجهة NextGen هذا النص إلى Hermes كرسالة عادية، ولا يُنفَّذ الأمر نفسه.';

  @override
  String get ng_slash_command_output => 'مخرجات الأمر';

  @override
  String get ng_slash_command_running => 'جارٍ تنفيذ الأمر…';

  @override
  String get ng_slash_command_done => 'تمّ.';

  @override
  String ng_slash_command_failed(Object error) {
    return 'تعذّر تنفيذ الأمر: $error';
  }

  @override
  String get ng_slash_command_refused =>
      'لا يستطيع Hermes تنفيذ هذا الأمر هنا.';

  @override
  String get ng_slash_command_delivery_unknown =>
      'أُرسل الأمر لكن لم يصل ردّ. قد يظلّ قيد التنفيذ على البوابة، لذا لم يُرسَل مجددًا واحتفظنا بمسودتك.';

  @override
  String get ng_slash_command_nothing_running => 'لا شيء قيد التنفيذ.';

  @override
  String get ng_steered => 'أُرسل التوجيه';

  @override
  String get ng_copied => 'نُسخ';

  @override
  String ng_not_sent(Object reason) {
    return 'لم يُرسَل: $reason';
  }

  @override
  String get ng_thinking => 'جارٍ التفكير…';

  @override
  String get ng_thought => 'التفكير';

  @override
  String ng_used(Object name) {
    return 'استخدم $name';
  }

  @override
  String ng_used_tools(Object count) {
    return 'عدد الأدوات المستخدمة: $count';
  }

  @override
  String get ng_copy => 'نسخ';

  @override
  String get ng_read_aloud => 'قراءة بصوت عالٍ';

  @override
  String get ng_the_gateway_connection_dropped_try_again =>
      'انقطع الاتصال بالبوابة. أعد المحاولة.';

  @override
  String get ng_allow_once => 'السماح مرة واحدة';

  @override
  String get ng_allow_until_sandbox_off => 'حتى إيقاف بيئة العزل';

  @override
  String get ng_folder_access => 'الوصول إلى المجلد';

  @override
  String get ng_folder_access_unspecified =>
      'لم تحدّد البوابة ما إذا كان الوصول للقراءة فقط أم للقراءة والكتابة.';

  @override
  String get ng_folder_read_only => 'للقراءة فقط';

  @override
  String get ng_folder_read_write => 'قراءة وكتابة';

  @override
  String get ng_website_access => 'الوصول إلى الموقع';

  @override
  String get ng_allow_for_this_chat => 'السماح لهذه المحادثة';

  @override
  String get ng_always_allow => 'السماح دائمًا';

  @override
  String get ng_deny => 'رفض';

  @override
  String get ng_your_answer => 'إجابتك';

  @override
  String get ng_or_type_an_answer => 'أو اكتب إجابة';

  @override
  String get ng_skip => 'تخطّي';

  @override
  String get ng_answer => 'إجابة';

  @override
  String get ng_cancel => 'إلغاء';

  @override
  String get ng_username_or_email => 'اسم المستخدم أو البريد الإلكتروني';

  @override
  String get ng_password => 'كلمة المرور';

  @override
  String get ng_not_now => 'ليس الآن';

  @override
  String get ng_save => 'حفظ';

  @override
  String get ng_enter_both_the_client_id_and =>
      'أدخل معرّف العميل (Client ID) وسرّ العميل (Client Secret) معًا، أو اترك الحقلين فارغين.';

  @override
  String get ng_enter_your_username_and_password =>
      'أدخل اسم المستخدم وكلمة المرور.';

  @override
  String ng_couldn_t_save_the_sign_in(Object error) {
    return 'تعذّر حفظ بيانات تسجيل الدخول: $error';
  }

  @override
  String get ng_wrong_username_or_password =>
      'اسم المستخدم أو كلمة المرور غير صحيحة.';

  @override
  String get ng_too_many_attempts_wait_a_moment =>
      'تجاوزت الحد المسموح به للمحاولات. انتظر قليلًا ثم أعد المحاولة.';

  @override
  String get ng_welcome_to_hermes => 'مرحبًا بك في Ares';

  @override
  String get ng_add_a_gateway => 'إضافة بوابة';

  @override
  String get ng_connect_to_your_hermes_agent_dashboard =>
      'اتصل بلوحة تحكم Hermes Agent. يكفي عنوان واحد وتسجيل الدخول مرة واحدة للوصول إلى محادثاتك وأدواتك وإعداداتك. لن يُرسل أي شيء حتى تسجّل الدخول.';

  @override
  String get ng_connect_to_another_hermes_agent_dashboard =>
      'اتصل بلوحة تحكم أخرى لـ Hermes Agent. ستبقى مسجّل الدخول إلى لوحات التحكم التي حفظتها.';

  @override
  String get ng_dashboard_address => 'عنوان لوحة التحكم';

  @override
  String get ng_testing => 'جارٍ الاختبار…';

  @override
  String get ng_test => 'اختبار';

  @override
  String get ng_where_your_hermes_dashboard_runs_lan =>
      'مكان تشغيل لوحة تحكم Hermes: عبر LAN أو Tailscale أو HTTPS.';

  @override
  String get ng_find_on_my_network => 'بحث في شبكتي';

  @override
  String get ng_which_address_do_i_use => 'أي عنوان أستخدم؟';

  @override
  String get ng_behind_cloudflare_access =>
      'هل يحمي Cloudflare Access هذا العنوان؟';

  @override
  String get ng_need_a_client_certificate => 'هل تحتاج إلى شهادة عميل؟';

  @override
  String get ng_this_address_isn_t_private_and =>
      'هذا العنوان ليس خاصًا ولا يستخدم https://، لذا ستنتقل كلمة مرورك ومحادثاتك عبر الإنترنت دون تشفير. استخدم https:// أو Tailscale أو شبكتك الخاصة بدلًا من ذلك.';

  @override
  String get ng_continue_to_sign_in => 'المتابعة لتسجيل الدخول';

  @override
  String get ng_use_the_classic_interface_instead =>
      'استخدام الواجهة التقليدية بدلًا من ذلك';

  @override
  String get ng_if_cloudflare_access_protects_this_address =>
      'إذا كان Cloudflare Access يحمي هذا العنوان، فأنشئ رمز خدمة في Cloudflare Zero Trust (Access، ثم Service credentials)، وأضف إلى تطبيق Access سياسة Service Auth لهذا الرمز.';

  @override
  String get ng_a_service_token_is_saved_for =>
      'يوجد رمز خدمة محفوظ لهذا العنوان';

  @override
  String get ng_forget => 'إزالة من المحفوظات';

  @override
  String get ng_client_id => 'معرّف العميل (Client ID)';

  @override
  String get ng_client_secret => 'سرّ العميل (Client Secret)';

  @override
  String get ng_stored_encrypted_on_this_phone_and =>
      'تُحفظ هذه البيانات مشفّرة على هذا الهاتف ولا تُرسَل إلا إلى هذا العنوان.';

  @override
  String get ng_hermes_is_reachable => 'يمكن الوصول إلى Hermes';

  @override
  String ng_hermes_is_reachable_2(Object version) {
    return 'يمكن الوصول إلى Hermes $version';
  }

  @override
  String get ng_sign_in_is_tested_next_then =>
      'الخطوة التالية هي اختبار تسجيل الدخول، ثم المحادثة';

  @override
  String get ng_agent_gateway => 'بوابة الوكيل';

  @override
  String get ng_running => 'قيد التشغيل';

  @override
  String get ng_stopped => 'متوقف';

  @override
  String get ng_username_password => 'اسم المستخدم وكلمة المرور';

  @override
  String get ng_browser => 'المتصفح';

  @override
  String get ng_in_the_browser_sso => 'في المتصفح (SSO)';

  @override
  String get ng_profiles => 'الملفات الشخصية';

  @override
  String get ng_this_dashboard_offers_neither_a_username =>
      'لا توفّر لوحة التحكم هذه مزوّدًا للمصادقة باسم المستخدم وكلمة المرور، ولا تتيح تسجيل الدخول عبر المتصفح. حدّث Hermes أو اضبط مزوّد المصادقة باسم المستخدم وكلمة المرور على الخادم.';

  @override
  String get ng_the_auth_gate_is_off_on =>
      'التحقق من الهوية معطّل في لوحة التحكم هذه. يمكن لأي شخص يصل إليها استخدام وكيلك.';

  @override
  String get ng_couldn_t_reach_the_dashboard => 'تعذّر الوصول إلى لوحة التحكم';

  @override
  String ng_check_the_address_and_port_9119(Object reason) {
    return '$reason\n\nتحقّق من العنوان والمنفذ (9119 افتراضيًا). إذا لم تكن لوحة التحكم قيد التشغيل بعد، فنفّذ هذا الأمر على الخادم:\nhermes dashboard --host 0.0.0.0';
  }

  @override
  String get ng_that_isn_t_a_hermes_dashboard => 'هذه ليست لوحة تحكم Hermes';

  @override
  String get ng_something_answered_but_not_a_hermes_2 =>
      'وصل ردّ، لكنه ليس من لوحة تحكم Hermes. استخدم عنوان لوحة التحكم، لا عنوان خادم API (المنفذ 8642).';

  @override
  String ng_something_answered_http_but_not_a_2(Object status) {
    return 'وصل ردّ (HTTP $status)، لكنه ليس من لوحة تحكم Hermes. استخدم عنوان لوحة التحكم، لا عنوان خادم API (المنفذ 8642).';
  }

  @override
  String get ng_cloudflare_access_stopped_the_request =>
      'أوقف Cloudflare Access الطلب';

  @override
  String ng_cloudflare_access_turned_down_the_service(Object status) {
    return 'رفض Cloudflare Access رمز الخدمة (HTTP $status). تحقّق من معرّف العميل (Client ID) وسرّه (Client Secret) ومن سياسة Service Auth.';
  }

  @override
  String get ng_add_a_cloudflare_access_service_token_2 =>
      'أضف رمز خدمة Cloudflare Access أدناه، ثم أعد الاختبار.';

  @override
  String get ng_a_client_certificate_is_needed => 'يلزم تقديم شهادة عميل';

  @override
  String get ng_this_server_asks_for_a_client =>
      'يطلب هذا الخادم شهادة عميل قبل أن يستجيب. اختر أدناه الشهادة التي منحك إياها، ثم أعد الاختبار.';

  @override
  String get ng_this_dashboard_doesn_t_ask_for =>
      'لا تطلب لوحة التحكم هذه تسجيل الدخول.';

  @override
  String ng_use_the_dashboard_username_and_password(Object address) {
    return 'استخدم اسم المستخدم وكلمة المرور المحدّدين للوحة التحكم على $address، أو سجّل الدخول عبر المتصفح.';
  }

  @override
  String ng_use_the_dashboard_username_and_password_2(Object address) {
    return 'استخدم اسم المستخدم وكلمة المرور المحدّدين للوحة التحكم على $address.';
  }

  @override
  String ng_sign_in_to_in_your_browser(Object address) {
    return 'سجّل الدخول إلى $address عبر المتصفح باستخدام الحساب الذي تستخدمه لوحة التحكم هناك.';
  }

  @override
  String ng_gateway(Object address) {
    return 'البوابة: $address';
  }

  @override
  String get ng_profile => 'الملف الشخصي';

  @override
  String get ng_server_default => 'الإعداد الافتراضي للخادم';

  @override
  String get ng_continue => 'متابعة';

  @override
  String get ng_username => 'اسم المستخدم';

  @override
  String get ng_signing_in => 'جارٍ تسجيل الدخول…';

  @override
  String get ng_waiting_for_the_browser => 'بانتظار المتصفح…';

  @override
  String get ng_sign_in_with_browser => 'تسجيل الدخول عبر المتصفح';

  @override
  String get ng_finish_signing_in_on_the_page =>
      'أكمل تسجيل الدخول في الصفحة التي فُتحت. ستعود تلقائيًا إلى Hermes عند الانتهاء.';

  @override
  String get ng_use_a_different_gateway => 'استخدام بوابة أخرى';

  @override
  String get ng_same_wi_fi_or_local_network =>
      'شبكة Wi-Fi نفسها أو الشبكة المحلية نفسها';

  @override
  String get ng_use_the_server_s_local_address =>
      'استخدم العنوان المحلي للخادم ومنفذه، مثل 192.168.1.20:9119. شغّل لوحة التحكم باستخدام --host 0.0.0.0 لتتمكن الأجهزة الأخرى من الوصول إليها.';

  @override
  String get ng_tailscale => 'Tailscale';

  @override
  String get ng_turn_on_tailscale_on_this_phone =>
      'شغّل Tailscale على هذا الهاتف واستخدم عنوان الخادم على Tailscale، مثل 100.64.0.1:9119، أو اسمه المنتهي بـ .ts.net. يعمل هذا الاتصال خارج المنزل أيضًا.';

  @override
  String get ng_use_your_https_address_when_the =>
      'استخدم عنوان https:// عندما تكون لوحة التحكم خلف وكيل مزوّد بشهادة. يجب أن يسمح الوكيل أيضًا بتمرير طلبات ترقية الاتصال إلى WebSocket على المسار /api/ws.';

  @override
  String get ng_start_the_dashboard_on_the_server =>
      'شغّل لوحة التحكم على الخادم:';

  @override
  String get ng_enter_a_port_from_1_to => 'أدخل رقم منفذ من 1 إلى 65535.';

  @override
  String get ng_looks_for_hermes_dashboards_on_port =>
      'يبحث عن لوحات تحكم Hermes على المنفذ 9119 في شبكة Wi-Fi هذه، ويفحص أيضًا أجهزة الكمبيوتر التي حفظتها سابقًا.';

  @override
  String ng_looks_for_hermes_dashboards_on_ports(Object port) {
    return 'يبحث عن لوحات تحكم Hermes على المنفذين 9119 و$port في شبكة Wi-Fi هذه، ويتحقق أيضًا من أجهزة الكمبيوتر التي حفظتها سابقًا.';
  }

  @override
  String get ng_other_port_optional => 'منفذ آخر (اختياري)';

  @override
  String get ng_no_dashboards_answered_start_one_with =>
      'لم تستجب أي لوحة تحكم. شغّل إحداها بالأمر hermes dashboard --host 0.0.0.0، أو أدخل عنوانها.';

  @override
  String get ng_using_tailscale_or_a_vpn_those =>
      'هل تستخدم Tailscale أو شبكة VPN؟ لا يمكن البحث في هذه الشبكات. أدخل بدلًا من ذلك عنوان جهاز الكمبيوتر الذي يبدأ بـ 100.x أو اسمه المنتهي بـ .ts.net.';

  @override
  String get ng_search_again => 'البحث مجددًا';

  @override
  String get ng_insights => 'إحصاءات الاستخدام';

  @override
  String get ng_couldn_t_load_insights => 'تعذّر تحميل إحصاءات الاستخدام';

  @override
  String get ng_sessions => 'الجلسات';

  @override
  String get ng_tokens => 'الرموز النصية';

  @override
  String get ng_est_cost => 'التكلفة التقديرية';

  @override
  String get ng_daily_tokens => 'استهلاك الرموز اليومي';

  @override
  String get ng_models => 'النماذج';

  @override
  String get ng_tools => 'الأدوات';

  @override
  String get ng_hermes_is_waiting_for_you => 'ينتظر Hermes ردّك.';

  @override
  String get ng_hermes_replied => 'ردّ Hermes';

  @override
  String get ng_the_turn_finished => 'انتهت الجولة.';

  @override
  String get ng_off => 'متوقف';

  @override
  String get ng_minimal => 'أدنى مستوى';

  @override
  String get ng_low => 'منخفض';

  @override
  String get ng_medium => 'متوسط';

  @override
  String get ng_high => 'مرتفع';

  @override
  String get ng_extra_high => 'مرتفع جدًا';

  @override
  String get ng_max => 'أقصى مستوى';

  @override
  String get ng_ultra => 'فائق';

  @override
  String get ng_default => 'افتراضي';

  @override
  String ng_couldn_t_switch_model(Object error) {
    return 'تعذّر تبديل النموذج: $error';
  }

  @override
  String get ng_model => 'النموذج';

  @override
  String get ng_thinking_2 => 'التفكير';

  @override
  String get ng_search_models => 'البحث عن نموذج';

  @override
  String get ng_no_models_match => 'لا توجد نماذج تطابق عوامل التصفية هذه.';

  @override
  String get privacy_policy => 'سياسة الخصوصية';

  @override
  String get report_ai_output => 'الإبلاغ عن محتوى أنشأه الذكاء الاصطناعي';

  @override
  String ng_couldn_t_load_models(Object error) {
    return 'تعذّر تحميل النماذج: $error';
  }

  @override
  String get ng_no_providers_are_set_up_on =>
      'لم يُضبط أي مزوّد على هذه البوابة بعد.';

  @override
  String get ng_starred => 'المميّزة بنجمة';

  @override
  String get ng_recent => 'الأخيرة';

  @override
  String get ng_more => 'المزيد';

  @override
  String get ng_archived_chats => 'المحادثات المؤرشفة';

  @override
  String get ng_projects => 'المشاريع';

  @override
  String get ng_chats_grouped_by_project_and_workspace =>
      'المحادثات مرتبة حسب المشروع ومساحة العمل';

  @override
  String get ng_agent => 'الوكيل';

  @override
  String get ng_memory => 'الذاكرة';

  @override
  String get ng_what_hermes_remembers_about_you => 'ما يتذكّره Hermes عنك';

  @override
  String get ng_skills_library => 'مكتبة المهارات';

  @override
  String get ng_browse_and_read_installed_skills =>
      'تصفّح المهارات المثبّتة واقرأها';

  @override
  String get ng_cron_editor => 'محرّر Cron';

  @override
  String get ng_edit_schedules_prompts_and_delivery =>
      'تعديل مواعيد التشغيل والتعليمات ووجهات الإرسال';

  @override
  String get ng_config_file => 'ملف الإعدادات';

  @override
  String get ng_edit_config_yaml_on_the_gateway =>
      'تعديل ملف config.yaml على البوابة';

  @override
  String get ng_models_and_providers => 'النماذج والمزوّدون';

  @override
  String get ng_model_management => 'إدارة النماذج';

  @override
  String get ng_default_fallback_and_auxiliary_models =>
      'النماذج الافتراضية والاحتياطية والمساعدة';

  @override
  String get ng_provider_sign_in => 'تسجيل الدخول إلى المزوّد';

  @override
  String get ng_connect_provider_accounts_with_oauth =>
      'ربط حسابات المزوّدين باستخدام OAuth';

  @override
  String get ng_nous_portal => 'Nous Portal';

  @override
  String get ng_subscription_credits_and_usage => 'الاشتراك والرصيد والاستخدام';

  @override
  String get ng_interface => 'الواجهة';

  @override
  String get ng_switch_to_the_classic_interface =>
      'التبديل إلى الواجهة الكلاسيكية';

  @override
  String get ng_turns_nextgen_off_you_can_turn =>
      'يُوقف واجهة NextGen. يمكنك تفعيلها مجددًا من الإعدادات.';

  @override
  String get ng_restored => 'تمت الاستعادة';

  @override
  String get ng_archived => 'تمت الأرشفة';

  @override
  String get ng_couldn_t_load_archived_chats =>
      'تعذّر تحميل المحادثات المؤرشفة';

  @override
  String get ng_nothing_archived => 'لا توجد محادثات مؤرشفة';

  @override
  String get ng_restore => 'استعادة';

  @override
  String get ng_saved_new_chats_use_it =>
      'حُفظ الإعداد. ستستخدمه المحادثات الجديدة.';

  @override
  String ng_couldn_t_save(Object error) {
    return 'تعذّر الحفظ: $error';
  }

  @override
  String get ng_saving => 'جارٍ الحفظ…';

  @override
  String ng_today(Object time) {
    return 'اليوم، $time';
  }

  @override
  String get ng_mon => 'الاثنين';

  @override
  String get ng_tue => 'الثلاثاء';

  @override
  String get ng_wed => 'الأربعاء';

  @override
  String get ng_thu => 'الخميس';

  @override
  String get ng_fri => 'الجمعة';

  @override
  String get ng_sat => 'السبت';

  @override
  String get ng_sun => 'الأحد';

  @override
  String get ng_scheduled => 'المهام المجدولة';

  @override
  String get ng_new_job => 'مهمة جديدة';

  @override
  String get ng_couldn_t_load_scheduled_jobs => 'تعذّر تحميل المهام المجدولة';

  @override
  String get ng_nothing_scheduled => 'لا توجد مهام مجدولة';

  @override
  String get ng_ask_hermes_to_do_something_on =>
      'اطلب من Hermes جدولة مهمة، أو أضف مهمة هنا.';

  @override
  String get ng_active => 'نشطة';

  @override
  String get ng_paused => 'متوقفة مؤقتًا';

  @override
  String ng_next(Object when) {
    return 'التشغيل التالي: $when';
  }

  @override
  String ng_last(Object when) {
    return 'آخر تشغيل: $when';
  }

  @override
  String ng_last_2(Object when, Object result) {
    return 'آخر تشغيل: $when · $result';
  }

  @override
  String ng_job(Object id) {
    return 'المهمة $id';
  }

  @override
  String get ng_delete => 'حذف';

  @override
  String get ng_delete_this_job => 'هل تريد حذف هذه المهمة؟';

  @override
  String get ng_it_stops_running_past_runs_stay =>
      'لن تُشغّل هذه المهمة مجددًا. تبقى نتائج التشغيل السابقة في محادثاتك.';

  @override
  String ng_next_run(Object when) {
    return 'التشغيل التالي: $when';
  }

  @override
  String ng_delivers_to(Object target) {
    return 'تُرسَل النتائج إلى $target';
  }

  @override
  String get ng_run_now => 'تشغيل الآن';

  @override
  String get ng_started => 'بدأ التشغيل';

  @override
  String get ng_pause => 'إيقاف مؤقت';

  @override
  String get ng_resume => 'استئناف';

  @override
  String get ng_resumed => 'استُؤنف التشغيل';

  @override
  String get ng_prompt => 'التعليمات';

  @override
  String get ng_runs => 'سجلّ التشغيل';

  @override
  String get ng_no_runs_yet => 'لم تُشغّل المهمة بعد.';

  @override
  String get ng_enter_a_schedule_and_a_prompt =>
      'حدّد موعد التشغيل وأدخل التعليمات.';

  @override
  String get ng_name_optional => 'الاسم (اختياري)';

  @override
  String get ng_schedule => 'جدول التشغيل';

  @override
  String get ng_every_1h_0_9_or_30m => 'every 1h، أو 0 9 * * *، أو 30m';

  @override
  String get ng_create => 'إنشاء';

  @override
  String get ng_unpin => 'إلغاء التثبيت';

  @override
  String get ng_pin => 'تثبيت';

  @override
  String get ng_rename => 'إعادة تسمية';

  @override
  String get ng_archive => 'أرشفة';

  @override
  String get ng_delete_this_chat => 'هل تريد حذف هذه المحادثة؟';

  @override
  String get ng_it_is_removed_from_the_gateway =>
      'ستُحذف المحادثة من البوابة ولن تظهر على أي جهاز.';

  @override
  String get ng_search_chats => 'البحث في المحادثات';

  @override
  String get ng_pinned => 'المحادثات المثبّتة';

  @override
  String get ng_no_chats_match => 'لا توجد محادثات تطابق بحثك.';

  @override
  String get ng_no_chats_yet => 'لا توجد محادثات بعد.';

  @override
  String get ng_nothing_is_running => 'لا شيء قيد التشغيل.';

  @override
  String get ng_nothing_is_waiting_on_you => 'لا شيء ينتظر تدخّلك.';

  @override
  String get ng_settings => 'الإعدادات';

  @override
  String get ng_all => 'الكل';

  @override
  String ng_needs_you(Object count) {
    return 'بانتظار تدخّلك · $count';
  }

  @override
  String get ng_needs_you_2 => 'بانتظار تدخّلك';

  @override
  String get ng_gateways => 'البوابات';

  @override
  String ng_classic_connection(Object address) {
    return '$address · اتصال كلاسيكي';
  }

  @override
  String get ng_gateway_2 => 'البوابة';

  @override
  String get ng_signed_in => 'تم تسجيل الدخول';

  @override
  String get ng_classic_connection_2 => 'اتصال كلاسيكي';

  @override
  String get ng_in_the_browser => 'في المتصفّح';

  @override
  String ng_in_the_browser_as(Object name) {
    return 'في المتصفّح باسم $name';
  }

  @override
  String get ng_not_required => 'غير مطلوب';

  @override
  String get ng_test_connection => 'اختبار الاتصال';

  @override
  String get ng_sign_in_again_2 => 'تسجيل الدخول مجددًا';

  @override
  String get ng_sign_out => 'تسجيل الخروج';

  @override
  String get ng_saved_gateways => 'البوابات المحفوظة';

  @override
  String get ng_in_use => 'قيد الاستخدام';

  @override
  String get ng_appearance => 'المظهر';

  @override
  String get ng_theme => 'السمة';

  @override
  String get ng_system => 'حسب النظام';

  @override
  String get ng_light => 'فاتحة';

  @override
  String get ng_dark => 'داكنة';

  @override
  String get ng_accent => 'لون التمييز';

  @override
  String get ng_pure_black => 'أسود خالص';

  @override
  String get ng_dark_theme_uses_true_black_oled =>
      'تستخدم السمة الداكنة الأسود الخالص لشاشات OLED';

  @override
  String get ng_glow => 'التوهّج';

  @override
  String get ng_soft_accent_light_behind_each_screen =>
      'توهّج خافت بلون التمييز خلف كل شاشة';

  @override
  String get ng_the_new_interface_turn_off_to =>
      'هذه هي الواجهة الجديدة. عطّلها للعودة إلى الواجهة الكلاسيكية. بواباتك ومحادثاتك متاحة في كلتا الواجهتين.';

  @override
  String get ng_more_settings => 'المزيد من الإعدادات';

  @override
  String get ng_voice_notifications_language_backups_and_the =>
      'الصوت والإشعارات واللغة والنُسخ الاحتياطية وإعدادات البوابة';

  @override
  String get ng_licences => 'التراخيص';

  @override
  String ng_sign_out_of(Object name) {
    return 'هل تريد تسجيل الخروج من $name؟';
  }

  @override
  String get ng_this_gateway_and_its_saved_sign =>
      'ستُزال هذه البوابة وبيانات الدخول المحفوظة لها من هذا الهاتف في كلتا الواجهتين. ستبقى محادثاتك على البوابة.';

  @override
  String get ng_password_or_browser => 'كلمة المرور أو المتصفّح';

  @override
  String get ng_unsupported => 'غير مدعوم';

  @override
  String get ng_background_task_finished =>
      'انتهت المهمة التي كانت تعمل في الخلفية';

  @override
  String get ng_background_process_finished =>
      'انتهت العملية التي كانت تعمل في الخلفية';

  @override
  String get ng_system_message => 'رسالة من النظام';

  @override
  String get ng_summary => 'الملخّص';

  @override
  String get classic_interface_only => 'للواجهة الكلاسيكية فقط';

  @override
  String get classic_only_settings_hint =>
      'الأقسام التي تحمل علامة «للواجهة الكلاسيكية فقط» تغيّر مظهر الواجهة الكلاسيكية ومحادثاتها، ولا تؤثّر في NextGen. يمكنك تخصيص مظهر NextGen من إعداداتها.';

  @override
  String get attachment_preview_too_large =>
      'الملف أكبر من أن يُعايَن هنا. اختر «حفظ» أو «مشاركة» لتنزيله على هاتفك (حتى 1 GB).';

  @override
  String get attachment_over_phone_limit =>
      'يتجاوز حجم الملف حدّ التنزيل البالغ 1 GB. افتح لوحة التحكم لتنزيله.';

  @override
  String attachment_downloading_percent(int percent) {
    return 'جارٍ التنزيل… $percent%';
  }

  @override
  String attachment_downloading_mb(int megabytes) {
    return 'جارٍ التنزيل… $megabytes MB';
  }

  @override
  String ng_attachment_too_large_for_gateway(String name) {
    return 'يتجاوز حجم $name حدّ هذه البوابة البالغ 12 MB. حدّث Hermes لإرسال ملفات يصل حجمها إلى 100 MB.';
  }

  @override
  String ng_couldn_t_upload(String name) {
    return 'تعذّر رفع $name.';
  }

  @override
  String ng_uploading_percent(int percent) {
    return 'جارٍ الرفع… $percent%';
  }

  @override
  String get ng_show_tasks => 'إظهار المهام';

  @override
  String get ng_hide_tasks => 'إخفاء المهام';

  @override
  String get ng_goal => 'الهدف';

  @override
  String get ng_loop => 'حلقة التكرار';

  @override
  String get ng_heartbeat => 'النبض الدوري';

  @override
  String get ng_goal_working => 'العمل جارٍ';

  @override
  String get ng_goal_waiting => 'قيد الانتظار';

  @override
  String get ng_goal_blocked => 'متعذّر التقدّم';

  @override
  String get ng_goal_done => 'مكتمل';

  @override
  String ng_goal_turns_of(int used, int max) {
    return 'الجولات: $used من $max';
  }

  @override
  String ng_goal_turn(int used) {
    return 'الجولة $used';
  }

  @override
  String get ng_loop_held => 'معلّقة بانتظار الهدف';

  @override
  String get ng_loop_finished => 'انتهت';

  @override
  String get ng_loop_running => 'قيد التشغيل';

  @override
  String ng_loop_runs_of(int fired, int times) {
    return 'مرّات التشغيل: $fired من $times';
  }

  @override
  String ng_loop_runs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عدد مرّات التشغيل: $count',
      one: 'تشغيل واحد',
    );
    return '$_temp0';
  }

  @override
  String ng_loop_next(String time) {
    return 'الموعد التالي: $time';
  }

  @override
  String get ng_loop_due_now => 'حان موعد التشغيل';

  @override
  String ng_every_seconds(int seconds) {
    return 'كل $seconds s';
  }

  @override
  String ng_every_minutes(int minutes) {
    return 'كل $minutes min';
  }

  @override
  String ng_every_hours(int hours) {
    return 'كل $hours h';
  }

  @override
  String ng_every_hours_minutes(int hours, int minutes) {
    return 'كل $hours h و$minutes min';
  }

  @override
  String ng_heartbeat_fired(int count) {
    return 'عدد النبضات: $count';
  }

  @override
  String ng_heartbeat_last_fired(String time) {
    return 'آخر نبضة: $time';
  }

  @override
  String ng_wait_until(String time) {
    return 'بانتظار حلول $time';
  }

  @override
  String get ng_wait_resume => 'بانتظار الاستئناف';

  @override
  String get ng_wait_other_chat => 'بانتظار محادثة أخرى';

  @override
  String ng_wait_process(String pid) {
    return 'بانتظار العملية $pid';
  }

  @override
  String get ng_control_open => 'فتح لوحة الهدف والأتمتة';

  @override
  String get ng_control_title => 'الهدف والأتمتة';

  @override
  String get ng_control_subtitle =>
      'الهدف الذي تسعى إليه هذه المحادثة والمهام التي تعمل تلقائيًا.';

  @override
  String get ng_contract_outcome => 'النتيجة المطلوبة';

  @override
  String get ng_contract_verification => 'التحقّق';

  @override
  String get ng_contract_constraints => 'القيود';

  @override
  String get ng_contract_boundaries => 'الحدود';

  @override
  String get ng_contract_stop_when => 'شروط التوقّف';

  @override
  String get ng_subgoals => 'الأهداف الفرعية';

  @override
  String get ng_subgoal_add_placeholder => 'أضف هدفًا فرعيًا';

  @override
  String get ng_add => 'إضافة';

  @override
  String get ng_subgoal_remove => 'إزالة الهدف الفرعي';

  @override
  String get ng_goal_checks => 'الفحوصات';

  @override
  String get ng_gate_not_run => 'لم يُنفّذ بعد';

  @override
  String ng_gate_attempts(int attempts, int tries) {
    return 'المحاولات: $attempts من $tries';
  }

  @override
  String ng_gate_exit(int code) {
    return 'رمز الخروج: $code';
  }

  @override
  String get ng_resume_now => 'استئناف الآن';

  @override
  String get ng_goal_clear => 'مسح الهدف';

  @override
  String get ng_goal_clear_title => 'هل تريد مسح هذا الهدف؟';

  @override
  String get ng_goal_clear_message =>
      'سيتوقّف الوكيل عن العمل على هذا الهدف، وستُحذف أهدافه الفرعية وفحوصاته أيضًا.';

  @override
  String get ng_subgoal_remove_title => 'هل تريد إزالة هذا الهدف الفرعي؟';

  @override
  String ng_subgoal_remove_message(String text) {
    return 'لن يعود «$text» جزءًا من الهدف.';
  }

  @override
  String get ng_subgoals_clear_title => 'هل تريد مسح كل الأهداف الفرعية؟';

  @override
  String get ng_subgoals_clear_message =>
      'سيبقى عنوان الهدف، لكن ستُحذف كل أهدافه الفرعية.';

  @override
  String get ng_clear_all => 'مسح الكل';

  @override
  String get ng_clear => 'مسح';

  @override
  String get ng_dismiss => 'إغلاق';

  @override
  String get ng_loop_stop_title => 'هل تريد إيقاف حلقة التكرار هذه؟';

  @override
  String get ng_heartbeat_clear_title => 'هل تريد مسح هذا النبض الدوري؟';

  @override
  String get ng_wont_fire_again => 'لن يتكرّر التشغيل.';

  @override
  String get ng_loop_self_paced => 'بوتيرة تلقائية';

  @override
  String ng_loop_until(String condition) {
    return 'حتى يتحقّق الشرط: $condition';
  }

  @override
  String get ng_loop_waits_for_goal =>
      'تنتظر الحلقة ما دام العمل على الهدف جاريًا.';

  @override
  String get ng_loop_awaiting_reply => 'بانتظار ردّ الوكيل.';

  @override
  String ng_loop_stopped_reason(String reason) {
    return 'توقّفت: $reason';
  }

  @override
  String get ng_hide_subagents => 'إخفاء الوكلاء الفرعيين';

  @override
  String get ng_show_subagents => 'إظهار الوكلاء الفرعيين';

  @override
  String get ng_subagent => 'وكيل فرعي';

  @override
  String get ng_subagent_queued => 'في قائمة الانتظار';

  @override
  String get ng_subagent_starting => 'جارٍ البدء…';

  @override
  String get ng_subagent_running => 'قيد التشغيل';

  @override
  String get ng_subagent_done => 'أنهى عمله';

  @override
  String get ng_subagent_failed => 'فشل';

  @override
  String get ng_subagent_stopped => 'متوقّف';

  @override
  String get ng_subagent_stop => 'إيقاف الوكيل الفرعي';

  @override
  String ng_subagent_tools(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عدد الأدوات: $count',
      one: 'أداة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get ng_mark_as_read => 'وضع علامة «مقروءة»';

  @override
  String get ng_mark_as_unread => 'وضع علامة «غير مقروءة»';

  @override
  String ng_chats_unread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'المحادثات، عدد المحادثات غير المقروءة: $count',
      one: 'المحادثات، محادثة واحدة غير مقروءة',
    );
    return '$_temp0';
  }

  @override
  String get ng_unread_finished => 'انتهى التشغيل، وهناك ردّ غير مقروء';

  @override
  String get ng_unread_updates => 'التشغيل جارٍ، وهناك تحديثات غير مقروءة';

  @override
  String get ng_notifications => 'الإشعارات';

  @override
  String get ng_notifications_hint =>
      'الردود والطلبات أثناء عمل Ares في الخلفية';

  @override
  String get ng_notify_replies => 'الردود';

  @override
  String get ng_notify_replies_hint =>
      'عند اكتمال جولة أو فشلها في المحادثة المفتوحة';

  @override
  String get ng_notify_requests => 'طلبات الموافقة والأسئلة';

  @override
  String get ng_notify_requests_hint =>
      'تنبيه عندما ينتظر الوكيل تدخّلك، مع خياري «السماح مرة واحدة» و«رفض»';

  @override
  String get ng_keep_running => 'إبقاء الاتصال مفتوحًا أثناء إعداد الردّ';

  @override
  String get ng_keep_running_hint =>
      'يبقى الاتصال مفتوحًا في الخلفية حتى يكتمل الردّ، ويظهر إشعار صامت خلال ذلك';

  @override
  String get ng_battery_settings => 'تحسين استهلاك البطارية';

  @override
  String get ng_battery_settings_hint =>
      'اسمح بتشغيل Ares في الخلفية لتصلك الإشعارات في وقتها';

  @override
  String get ng_send_test_notification => 'إرسال إشعار تجريبي';

  @override
  String get ng_test_notification_title => 'إشعارات Ares تعمل';

  @override
  String get ng_test_notification_body => 'ستظهر الردود والطلبات بهذا الشكل.';

  @override
  String get ng_test_notification_sent => 'أُرسل الإشعار التجريبي';

  @override
  String get ng_notifications_blocked =>
      'الإشعارات محظورة. اسمح بها في إعدادات Android.';

  @override
  String get ng_notifications_off_hint =>
      'الإشعارات معطّلة، لذا لن يرسل Ares أي إشعار أثناء عمله في الخلفية.';

  @override
  String get ng_insights_building =>
      'جارٍ إعداد التقرير. إذا كانت الفترة طويلة، فقد يستغرق إعداده دقيقة عند طلبه أول مرة.';

  @override
  String get ng_insights_timed_out =>
      'استغرقت البوابة وقتًا أطول من اللازم لإعداد التقرير. حاول مجددًا أو اختر فترة أقصر.';

  @override
  String get ng_dock_goal_active => 'الهدف نشط';

  @override
  String get ng_dock_goal_paused => 'الهدف متوقّف مؤقتًا';

  @override
  String get ng_dock_goal_waiting => 'الهدف قيد الانتظار';

  @override
  String get ng_dock_goal_blocked => 'تعذّر التقدّم نحو الهدف';

  @override
  String get ng_dock_goal_done => 'اكتمل الهدف';

  @override
  String ng_dock_turn_of(int used, int max) {
    return 'الجولة $used/$max';
  }

  @override
  String ng_dock_turn(int used) {
    return 'الجولة $used';
  }

  @override
  String ng_dock_subagents(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عدد الوكلاء الفرعيين: $count',
      one: 'وكيل فرعي واحد',
    );
    return '$_temp0';
  }

  @override
  String ng_dock_subagents_done(int count) {
    return 'عدد من أنهوا العمل: $count';
  }

  @override
  String ng_dock_tasks(int done, int total) {
    return 'المهام: $done/$total';
  }

  @override
  String ng_dock_previous_tasks(int done, int total) {
    return 'المهام السابقة: $done/$total';
  }

  @override
  String get ng_dock_manage => 'إدارة';

  @override
  String get ng_recent_notifications => 'الإشعارات الأخيرة';

  @override
  String get ng_recent_notifications_hint =>
      'الإشعارات التي حاول Ares إرسالها وما إذا كان Android قد عرضها';

  @override
  String get ng_recent_notifications_empty =>
      'لا توجد إشعارات بعد. ستظهر المحاولات هنا عند وجود ردّ أو سؤال أو إخفاق يستدعي إشعارك.';

  @override
  String get ng_notify_permission_granted => 'مُنح الإذن';

  @override
  String get ng_notify_permission_denied => 'رُفض الإذن';

  @override
  String get ng_notify_master_on => 'الإشعارات مفعّلة';

  @override
  String get ng_notify_master_off => 'الإشعارات معطّلة';

  @override
  String get ng_models_default => 'النموذج الافتراضي';

  @override
  String get ng_models_change => 'تغيير';

  @override
  String get ng_models_custom_endpoint =>
      'يعمل عبر نقطة اتصال مخصّصة. يمكنك تغييرها على البوابة.';

  @override
  String get ng_models_context_window => 'نافذة السياق';

  @override
  String ng_models_token_count(String count) {
    return 'عدد الرموز النصية: $count';
  }

  @override
  String ng_models_context_override(String count) {
    return 'ضُبطت نافذة السياق على البوابة. عدد الرموز المكتشف تلقائيًا: $count.';
  }

  @override
  String get ng_models_max_output => 'الحدّ الأقصى للمخرجات';

  @override
  String get ng_models_input_price => 'سعر الإدخال';

  @override
  String get ng_models_output_price => 'سعر الإخراج';

  @override
  String get ng_models_cache_price => 'سعر المدخلات المخزّنة مؤقتًا';

  @override
  String ng_models_per_million(String price) {
    return '$price لكل مليون رمز نصي';
  }

  @override
  String ng_models_price_pair(String input, String output) {
    return '$input للإدخال · $output للإخراج لكل مليون رمز نصي';
  }

  @override
  String get ng_models_free => 'مجاني';

  @override
  String get ng_models_vision => 'الرؤية';

  @override
  String get ng_models_reasoning => 'الاستدلال';

  @override
  String get ng_models_fast => 'الوضع السريع';

  @override
  String get ng_models_in_use => 'قيد الاستخدام';

  @override
  String ng_models_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عدد النماذج: $count',
      one: 'عدد النماذج: $count',
    );
    return '$_temp0';
  }

  @override
  String get ng_models_rate_limited => 'معدّل الطلبات مقيّد';

  @override
  String get ng_models_plan_locked => 'غير مشمول في خطتك';

  @override
  String get ng_models_unsaved => 'تغييرات غير محفوظة';

  @override
  String get ng_models_discard => 'تجاهل';

  @override
  String get ng_models_aux_hint =>
      'تستخدم المهام المساعدة النموذج الافتراضي ما لم تحدّد لها نموذجًا خاصًا.';

  @override
  String get ng_models_uses_default => 'يستخدم النموذج الافتراضي';

  @override
  String get ng_models_thinking_level => 'مستوى التفكير';

  @override
  String get ng_models_providers => 'المزوّدون';

  @override
  String get ng_models_saved => 'تم الحفظ';

  @override
  String get ng_aux_vision => 'الرؤية';

  @override
  String get ng_aux_vision_hint => 'يقرأ الصور ولقطات الشاشة';

  @override
  String get ng_aux_compression => 'الضغط';

  @override
  String get ng_aux_compression_hint =>
      'يختصر المحادثات الطويلة لتلائم نافذة السياق';

  @override
  String get ng_aux_approval => 'الموافقة';

  @override
  String get ng_aux_approval_hint =>
      'يقرّر ما إذا كان يمكن تنفيذ الأمر بأمان دون طلب موافقتك';

  @override
  String get ng_aux_mcp => 'MCP';

  @override
  String get ng_aux_mcp_hint => 'يختار أدوات MCP المناسبة للاستخدام';

  @override
  String get ng_aux_title_generation => 'عناوين المحادثات';

  @override
  String get ng_aux_title_generation_hint => 'يضع عناوين للمحادثات الجديدة';

  @override
  String get ng_aux_review => 'المراجعة';

  @override
  String get ng_aux_review_hint => 'يراجع العمل عند تشغيل الأمر /review';

  @override
  String get ng_aux_voice_chat => 'المحادثة الصوتية';

  @override
  String get ng_aux_voice_chat_hint => 'يردّ في وضع المحادثة الصوتية';

  @override
  String get ng_aux_triage_specifier => 'فرز المهام';

  @override
  String get ng_aux_triage_specifier_hint =>
      'يحوّل بطاقة Kanban من سطر واحد إلى مواصفات مفصّلة';

  @override
  String get ng_aux_kanban_decomposer => 'تقسيم مهام Kanban';

  @override
  String get ng_aux_kanban_decomposer_hint =>
      'يقسّم بطاقة Kanban إلى مهام أصغر';

  @override
  String get ng_aux_profile_describer => 'أوصاف الملفات الشخصية';

  @override
  String get ng_aux_profile_describer_hint => 'يكتب وصفًا موجزًا لكل ملف شخصي';

  @override
  String get ng_aux_curator => 'منسّق المهارات';

  @override
  String get ng_aux_curator_hint => 'يراجع كيفية استخدام المهارات';

  @override
  String get appearance_save_failed => 'تعذّر حفظ هذا التغيير.';

  @override
  String get appearance_keep_which_theme => 'أي سمة نُبقي؟';

  @override
  String get appearance_tour_back => 'رجوع';

  @override
  String get appearance_tour_finish => 'إنهاء';

  @override
  String get appearance_tour_next => 'التالي';

  @override
  String get appearance_tour_close => 'إغلاق الجولة';

  @override
  String get appearance_dismiss_tip => 'إخفاء التلميح';

  @override
  String get appearance_search_settings => 'البحث في الإعدادات';

  @override
  String get appearance_search_show => 'إظهار';

  @override
  String get appearance_no_matching_setting => 'لا يوجد إعداد مطابق.';

  @override
  String get appearance_replay_tour => 'إعادة الجولة';

  @override
  String get appearance_show_tips_again => 'أظهر التلميحات مجددًا';

  @override
  String get appearance_window_translucency_unavailable =>
      'شفافية النافذة غير متاحة على هذا الجهاز. لا يدعمها لينكس، وترسم إصدارات آبل وويندوز نافذة Flutter معتمة.';

  @override
  String get appearance_imported_themes => 'السمات المستوردة';

  @override
  String get appearance_import_theme_file => 'استيراد ملف سمة';

  @override
  String get appearance_remove_theme => 'حذف السمة';

  @override
  String get appearance_chat_font => 'خط الدردشة';

  @override
  String get appearance_terminal_font => 'خط الطرفية';

  @override
  String get appearance_font_platform => 'خط الجهاز';

  @override
  String get appearance_automatic => 'تلقائي';

  @override
  String get appearance_force_left_to_right => 'إجبار من اليسار';

  @override
  String get appearance_force_right_to_left => 'إجبار من اليمين';

  @override
  String get appearance_user_bubble_opacity => 'شفافية فقاعة رسائلك';

  @override
  String get appearance_inline_embeds => 'المحتوى المضمّن';

  @override
  String get appearance_inline_embeds_hint =>
      'تُحمَّل المعاينات الغنية من مواقع خارجية (YouTube وX و…). يعرض «اسأل» عنصرًا نائبًا حتى تسمح بكل واحدة؛ ويحمّلها «دائمًا» تلقائيًا؛ ويُبقي «إيقاف» الروابط عادية.';

  @override
  String get appearance_embeds_ask => 'اسأل';

  @override
  String get appearance_embeds_always => 'دائمًا';

  @override
  String get appearance_embeds_off => 'إيقاف';

  @override
  String appearance_embeds_reset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'إعادة تعيين الخدمات المسموح بها: $count',
      one: 'إعادة تعيين خدمة واحدة مسموح بها',
    );
    return '$_temp0';
  }

  @override
  String get appearance_embed_load => 'تحميل';

  @override
  String appearance_embed_always_allow(String service) {
    return 'السماح دائمًا بـ $service';
  }

  @override
  String get appearance_embed_loading => 'جارٍ تحميل المعاينة…';

  @override
  String appearance_embed_image_failed(String host) {
    return 'تعذّر تحميل الصورة من $host. اضغط لفتحها.';
  }

  @override
  String get appearance_embed_preview_unavailable => 'المعاينة غير متاحة';

  @override
  String get appearance_emoji_reactions => 'تفاعلات الإيموجي';

  @override
  String get appearance_celebration_hearts => 'قلوب الاحتفال';

  @override
  String get appearance_celebration_hearts_hint =>
      'يظهر قلب عندما يصل رد وأنت بعيد.';

  @override
  String get appearance_pop_out_companion => 'افتح الرفيق في نافذة';

  @override
  String get appearance_mosskip => 'موسكيب';

  @override
  String get appearance_emberbun => 'إمبربن';

  @override
  String get appearance_tideling => 'تايدلينغ';

  @override
  String get appearance_my_hatchling => 'رفيقي الصغير';

  @override
  String get appearance_at_rest => 'يستريح';

  @override
  String get appearance_working => 'يعمل';

  @override
  String get appearance_thinking => 'يفكّر';

  @override
  String get appearance_waiting_for_you => 'ينتظرك';

  @override
  String get appearance_reply_ready => 'الرد جاهز';

  @override
  String get appearance_turn_failed => 'تعذّر إكمال الدور';

  @override
  String get appearance_small => 'صغير';

  @override
  String get appearance_medium => 'متوسط';

  @override
  String get appearance_large => 'كبير';

  @override
  String get appearance_hello => 'مرحبًا!';

  @override
  String get appearance_unread_reply => 'رد غير مقروء';

  @override
  String get appearance_compose => 'كتابة رسالة';

  @override
  String get appearance_say_hello => 'إلقاء التحية';

  @override
  String get appearance_pet_image_failed =>
      'تعذّر فتح الصورة. اختر صورة PNG أو JPEG أصغر.';

  @override
  String get appearance_pet_companion => 'الرفيق الصغير';

  @override
  String get appearance_pet_companion_hint => 'أظهر رفيقًا أثناء الدردشة.';

  @override
  String get appearance_adopt_a_companion => 'تبنَّ رفيقًا';

  @override
  String get appearance_roam_when_idle => 'التجوّل أثناء الراحة';

  @override
  String get appearance_pet_size => 'حجم الرفيق';

  @override
  String get appearance_hatch_from_a_local_picture => 'فقس رفيق من صورة محلية';

  @override
  String get appearance_pet_image_limits =>
      'اختر صورة PNG أو JPEG (حتى ٤ ميبيبايت و٤٠٩٦ بكسل للضلع و٨ ميغابكسل). عاينها أولًا. يحفظ الفقس صورة ٢٤ × ٢٤ بكسل بدلًا من رفيقك المُفقس السابق.';

  @override
  String get appearance_choose_picture => 'اختيار صورة';

  @override
  String get appearance_hatchling_preview => 'معاينة الرفيق';

  @override
  String get appearance_hatch_and_adopt => 'فقس وتبنٍّ';

  @override
  String get appearance_discard_draft => 'تجاهل المسودة';

  @override
  String get appearance_forget_saved_hatchling => 'حذف الرفيق المُفقس المحفوظ';

  @override
  String get appearance_radio => 'الراديو';

  @override
  String appearance_radio_hint(String stations) {
    return 'يأتي البث مباشرةً من $stations، ولا يبدأ إلا عند الضغط على تشغيل. يبقى البحث عن المحطات على هذا الجهاز.';
  }

  @override
  String get appearance_radio_save_failed => 'تعذّر حفظ إعدادات الراديو.';

  @override
  String get appearance_choose_a_station => 'اختيار محطة';

  @override
  String get appearance_pause_radio => 'إيقاف الراديو مؤقتًا';

  @override
  String get appearance_play_radio => 'تشغيل الراديو';

  @override
  String get appearance_next_station => 'المحطة التالية';

  @override
  String get appearance_radio_trace_semantics =>
      'نشاط البث. مستويات الصوت غير متاحة، لذا يبقى الخط مستويًا.';

  @override
  String get appearance_radio_is_off => 'الراديو متوقف';

  @override
  String get appearance_paused => 'متوقف مؤقتًا';

  @override
  String get appearance_connecting => 'جارٍ الاتصال…';

  @override
  String get appearance_live => 'بث مباشر';

  @override
  String get appearance_stream_unavailable => 'البث غير متاح';

  @override
  String appearance_now_playing(String credit) {
    return 'يُبث الآن: $credit';
  }

  @override
  String get appearance_audio_only_waveform_unavailable =>
      'صوت فقط · شكل الموجة غير متاح';

  @override
  String get appearance_volume => 'مستوى الصوت';

  @override
  String get appearance_search_presets => 'البحث في المحطات المحفوظة مسبقًا';

  @override
  String get appearance_no_stations_found => 'لم يُعثر على محطات';

  @override
  String appearance_unpin_station(String station) {
    return 'إلغاء تثبيت المحطة: $station';
  }

  @override
  String appearance_pin_station(String station) {
    return 'تثبيت المحطة: $station';
  }

  @override
  String get appearance_radio_picker_metadata_notice =>
      'عندما تكون هذه القائمة مفتوحة، قد تُعرض معلومات المقطع من جهة البث مباشرةً أثناء التشغيل.';

  @override
  String get appearance_message_from_your_companion => 'رسالة من رفيقك';

  @override
  String get appearance_send_to_the_open_chat => 'أرسل إلى الدردشة المفتوحة';

  @override
  String get appearance_tour_theme_body =>
      'استورد سمة ألوان من ملف على هذا الجهاز، ثم اختر النسخة التي تريد إبقاءها.';

  @override
  String get appearance_tour_fonts_title => 'خطوط القراءة';

  @override
  String get appearance_tour_fonts_body =>
      'يستخدم نص الدردشة وشفرة الطرفية خطين منفصلين مدمجين مع آريس.';

  @override
  String get appearance_tour_direction_title => 'اتجاه النص';

  @override
  String get appearance_tour_direction_body =>
      'اتركه تلقائيًا، أو أجبر نص المحادثة من اليسار أو من اليمين.';

  @override
  String get appearance_tour_pet_title => 'الرفيق';

  @override
  String get appearance_tour_pet_body =>
      'يبقى الرفيق متوقفًا حتى تتبناه. النافذة المنبثقة تضيف مربع كتابة صغيرًا.';

  @override
  String get appearance_tour_radio_body =>
      'يبقى الراديو متوقفًا حتى تفعّله. زر التشغيل هو ما يفتح البث.';

  @override
  String get appearance_tip_theme =>
      'تحل السمات المستوردة محل لوحة الألوان المدمجة حتى تلغي الاختيار. تُحفظ الألوان فقط.';

  @override
  String get appearance_tip_pet =>
      'يحفظ الرفيق صورة صغيرة واحدة على هذا الجهاز. لا يرفع الصورة التي تفقس منها.';

  @override
  String get appearance_theme_import_failed =>
      'تعذّر استيراد هذه السمة. اختر سمة ألوان من VS Code محفوظة في ملف بامتداد vsix أو json أو jsonc.';

  @override
  String get render_widget_file_truncated =>
      'قُرئت بداية هذا الملف فقط، لذا قد يكون عنصر الواجهة غير مكتمل.';

  @override
  String get setup_beat_title => 'الإعداد';

  @override
  String setup_beat_use_name(String name) {
    return 'استخدام $name';
  }

  @override
  String get setup_beat_name_hint => 'بأي اسم تريد أن يناديك Hermes؟';

  @override
  String get setup_beat_on_computer =>
      'تُنفّذ هذه الخطوة في Hermes على الحاسوب الذي يعمل عليه. يحافظ خيار «متابعة» على الإعدادات الموجودة هناك.';

  @override
  String get setup_beat_not_waiting => 'لم تعد بطاقة الإعداد هذه تنتظر إجابة.';

  @override
  String get catalog_kind_plugin => 'إضافة';

  @override
  String get catalog_kind_skill => 'مهارة';

  @override
  String get catalog_tier_official => 'رسمي';

  @override
  String get catalog_tier_verified => 'تم التحقق منه';

  @override
  String get catalog_tier_community => 'مجتمعي';

  @override
  String get catalog_install => 'تثبيت';

  @override
  String get catalog_waiting => 'بانتظار اختيارك';

  @override
  String get catalog_installed => 'مثبّت';

  @override
  String get catalog_installed_off => 'مثبّت، غير مفعّل';

  @override
  String get catalog_skipped => 'تم التخطي';

  @override
  String get catalog_not_installed => 'غير مثبّت';

  @override
  String catalog_target_profile(String profile) {
    return 'يُثبّت في الملف الشخصي $profile';
  }

  @override
  String catalog_source(String repo, String sha) {
    return '$repo عند المراجعة $sha';
  }

  @override
  String catalog_scan(String status, String summary) {
    return 'الفحص الأمني: $status. $summary';
  }

  @override
  String catalog_requires_hermes(String range) {
    return 'يتطلب Hermes $range';
  }

  @override
  String catalog_skill_ready(String name) {
    return 'المهارة $name جاهزة للاستخدام';
  }

  @override
  String catalog_missing_env(String names) {
    return 'لا يزال يتطلب: $names';
  }

  @override
  String catalog_server_error(String name, String error) {
    return 'لم يتصل $name: $error';
  }

  @override
  String get catalog_send_failed => 'لم يُرسل اختيارك. حاول مجددًا.';

  @override
  String get attachment_video_speed => 'سرعة التشغيل';

  @override
  String get catalog_installing => 'جارٍ التثبيت…';

  @override
  String get catalog_phase_downloading => 'جارٍ التنزيل…';

  @override
  String get catalog_phase_python_packages => 'جارٍ تثبيت حزم Python…';

  @override
  String get catalog_phase_loading_tools => 'جارٍ تحميل أدواته…';

  @override
  String get setup_beat_send_failed => 'لم تُرسل إجابتك. حاول مجددًا.';

  @override
  String catalog_tool_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count أداة',
      one: 'أداة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get render_svg_not_drawn => 'لم تُرسَم صورة SVG هذه.';

  @override
  String get render_notes_directive => 'توجيه الملاحظات';

  @override
  String get render_maths_source => 'مصدر الرياضيات';

  @override
  String get render_inline_maths_source => 'مصدر الرياضيات المضمّنة';

  @override
  String get render_sequence_outline => 'مخطط التسلسل';

  @override
  String get render_diagram_outline => 'مخطط الرسم البياني';

  @override
  String render_revision_of(int index, int count) {
    return 'المراجعة $index من $count';
  }

  @override
  String get render_previous_revision => 'المراجعة السابقة';

  @override
  String get render_next_revision => 'المراجعة التالية';

  @override
  String get render_show_rendered => 'المعروض';

  @override
  String get render_show_source => 'المصدر';

  @override
  String render_copied_file(String name) {
    return 'تم نسخ $name';
  }

  @override
  String render_copy_file(String name) {
    return 'نسخ $name';
  }

  @override
  String get render_artifact_too_long =>
      'هذا المحتوى أطول من أن يُعرض كصفحة هنا.';

  @override
  String get render_active_content_removed =>
      'أُزيلت النصوص البرمجية والإطارات والعناوين الخارجية.';

  @override
  String render_widget_file(String file) {
    return 'الأداة $file';
  }

  @override
  String get render_widget_runs_as_text =>
      'تعمل كنص في هذه الدردشة. تُزال النصوص البرمجية والإطارات الخارجية.';

  @override
  String get render_load_widget => 'تحميل الأداة';

  @override
  String get render_not_html_widget => 'هذا الملف ليس أداة HTML.';

  @override
  String get render_widget_sent => 'أُرسل إلى هذه الدردشة';

  @override
  String get render_widget_not_sent => 'لم يُرسل إلى هذه الدردشة';

  @override
  String get render_widget_throttled => 'انتظر قليلًا قبل الإرسال مرة أخرى';

  @override
  String get render_widget_too_long => 'هذا الطلب أطول من أن يُرسل';

  @override
  String get render_widget_no_gesture => 'اضغط على عنصر تحكم في الأداة للإرسال';

  @override
  String get render_widget_invalid => 'تعذّر إرسال هذا الطلب';

  @override
  String get render_inspected_image => 'الصورة المفحوصة';

  @override
  String get render_contributions => 'المساهمات';

  @override
  String get render_contributions_intro =>
      'يمكن فقط للمساهمات المضمّنة في Ares أن تضيف إلى الرد. لا يمكن لنص الدردشة تسجيل مساهمة، والإذن يسري على هذا الاتصال فقط.';

  @override
  String render_grant_plugin(String name) {
    return 'منح $name';
  }

  @override
  String render_revoke_plugin(String name) {
    return 'إلغاء $name';
  }

  @override
  String render_plugin_slots(String directive) {
    return 'بطاقات الرد لـ ::$directive';
  }

  @override
  String get render_plugin_notes => 'الملاحظات';

  @override
  String get catalog_scan_passed => 'نجح';

  @override
  String get catalog_scan_warnings => 'وُجدت تحذيرات';

  @override
  String get catalog_scan_failed => 'فشل';

  @override
  String get deployment_token_label => 'رمز النشر (اختياري)';

  @override
  String get deployment_token_helper =>
      'لرموز جلسات Hermes Dashboard المرسلة بصفة X-Hermes-Session-Token. لا يُخزَّن كنص عادي في التفضيلات.';

  @override
  String get deployment_token_hint => 'رمز جلسة لوحة التحكم';

  @override
  String get custom_headers_label => 'ترويسات مخصصة (اختياري)';

  @override
  String get custom_headers_helper =>
      'واحدة في كل سطر، مثل X-Custom: value. تُرفض الترويسات المحظورة.';

  @override
  String get custom_headers_hint => 'مثال: X-Custom-Header: value';

  @override
  String get desktop_tray_open => 'فتح Ares';

  @override
  String get desktop_tray_new_chat => 'دردشة جديدة';

  @override
  String get desktop_tray_quick_entry => 'إدخال سريع…';

  @override
  String get desktop_tray_pause_notifications => 'إيقاف الإشعارات مؤقتًا';

  @override
  String get desktop_tray_quit => 'إنهاء Ares';

  @override
  String get desktop_integration_title => 'التكامل مع سطح المكتب';

  @override
  String get desktop_tray_setting =>
      'إظهار Ares في علبة النظام أو شريط القوائم';

  @override
  String get desktop_tray_setting_help =>
      'افتح Ares أو ابدأ دردشة أو افتح الإدخال السريع أو أوقف الإشعارات مؤقتًا أو أنهِ التطبيق من الأيقونة.';

  @override
  String get desktop_close_to_tray_setting =>
      'استمر في العمل في علبة النظام عند إغلاق النافذة';

  @override
  String get desktop_tray_unsupported =>
      'لا يوفّر سطح المكتب هذا علبة نظام يمكن لـ Ares استخدامها.';

  @override
  String get quick_entry_title => 'إدخال سريع';

  @override
  String get quick_entry_hint => 'اكتب طلبًا لـ Ares…';

  @override
  String get quick_entry_submit => 'ضعه في مربع الكتابة';

  @override
  String get quick_entry_never_sends =>
      'يضع Enter النص في مربع كتابة الدردشة. لا يُرسَل شيء حتى تضغط إرسال.';

  @override
  String get quick_entry_unavailable =>
      'تعذّر فتح الإدخال السريع. حاول مرة أخرى.';

  @override
  String get desktop_hotkey_setting => 'اختصار الإدخال السريع';

  @override
  String desktop_hotkey_help(String shortcut) {
    return 'اضغط $shortcut في أي مكان لفتح الإدخال السريع.';
  }

  @override
  String desktop_hotkey_conflict(String shortcut) {
    return 'يستخدم تطبيق آخر $shortcut بالفعل. اختر اختصارًا مختلفًا.';
  }

  @override
  String get desktop_hotkey_unsupported =>
      'لا يسمح سطح المكتب هذا للتطبيقات بتسجيل اختصار عام (مثل Wayland).';

  @override
  String get desktop_hotkey_no_modifier => 'أضف Cmd أو Ctrl أو Alt.';

  @override
  String get desktop_hotkey_super_key => 'مفتاح Windows أو Super محجوز للنظام.';

  @override
  String get desktop_hotkey_reserved => 'يستخدم النظام هذا الاختصار بالفعل.';

  @override
  String desktop_hotkey_in_app(String action) {
    return 'يستخدم Ares هذا الاختصار بالفعل لـ $action.';
  }

  @override
  String get desktop_hotkey_change => 'تغيير';

  @override
  String get desktop_hotkey_reset => 'استخدام الافتراضي';

  @override
  String get capture_screen_action => 'التقاط الشاشة';

  @override
  String get capture_screen_help =>
      'يضيف لقطة شاشة إلى الرسالة كمسودة. لا يُرسَل شيء حتى تضغط إرسال.';

  @override
  String get capture_screen_unavailable =>
      'التقاط الشاشة غير متاح على سطح المكتب هذا.';

  @override
  String get capture_screen_failed => 'تعذّر التقاط الشاشة. حاول مرة أخرى.';

  @override
  String get capture_permission_title => 'السماح بتسجيل الشاشة';

  @override
  String get capture_permission_body =>
      'يحتاج Ares إلى إذن تسجيل الشاشة لالتقاط نافذة. فعّل Ares في إعدادات النظام > الخصوصية والأمن > تسجيل الشاشة، ثم حاول مرة أخرى.';

  @override
  String get capture_open_settings => 'فتح إعدادات النظام';

  @override
  String get keep_awake_title => 'إبقاء الحاسوب مستيقظًا';

  @override
  String get keep_awake_title_mobile => 'إبقاء الشاشة قيد التشغيل';

  @override
  String get keep_awake_mode_off => 'إيقاف';

  @override
  String get keep_awake_mode_while_working => 'أثناء العمل';

  @override
  String get keep_awake_mode_always => 'دائمًا';

  @override
  String get keep_awake_off_help => 'لا تمنع سكون النظام أبدًا (الافتراضي).';

  @override
  String get keep_awake_while_working_help =>
      'منع السكون بسبب الخمول فقط أثناء تشغيل دور الوكيل.';

  @override
  String get keep_awake_always_help =>
      'منع السكون بسبب الخمول ما دام Ares مفتوحًا على هذا الجهاز.';

  @override
  String get keep_awake_off_help_mobile =>
      'دع الشاشة تنطفئ كالمعتاد (الافتراضي).';

  @override
  String get keep_awake_while_working_help_mobile =>
      'إبقاء الشاشة قيد التشغيل أثناء تشغيل دور الوكيل وما دام Ares مفتوحًا.';

  @override
  String get keep_awake_always_help_mobile =>
      'إبقاء الشاشة قيد التشغيل ما دام Ares مفتوحًا.';

  @override
  String get ng_token_gateway_has_no_sign_in =>
      'لا تحتوي هذه البوابة على تسجيل دخول، لذا لا يمكنها التحقق من رمز النشر. فعّل مصادقة لوحة التحكم على المضيف (أو حدّث Hermes)، ثم حاول مرة أخرى.';

  @override
  String get palette_open => 'لوحة أوامر التطبيق';

  @override
  String get palette_no_matches => 'لا توجد إجراءات مطابقة';

  @override
  String get palette_filter_hint => 'اكتب لتصفية الإجراءات…';

  @override
  String get palette_keys_move => '↑↓ للتنقل';

  @override
  String get palette_keys_run => 'Enter للتشغيل';

  @override
  String get palette_keys_close => 'Esc للإغلاق';

  @override
  String get palette_search_sessions => 'البحث في الجلسات';

  @override
  String get palette_scheduled_crons => 'المجدولة / Cron';

  @override
  String get palette_capabilities_skills => 'القدرات والمهارات';

  @override
  String get palette_insights_usage => 'الرؤى والاستخدام';

  @override
  String get palette_more_projects => 'المزيد والمشاريع';

  @override
  String get deeplink_chat_not_found =>
      'لم يُعثر على المحادثة في القائمة. ربما لم تُحمَّل بعد.';

  @override
  String get keyboard_shortcuts_title => 'اختصارات لوحة المفاتيح';

  @override
  String get shortcuts_reset_all => 'إعادة تعيين الكل';

  @override
  String get shortcuts_reset_to_default => 'استعادة الافتراضي';

  @override
  String get shortcut_action_command_palette => 'لوحة الأوامر';

  @override
  String get shortcut_action_new_chat => 'محادثة جديدة';

  @override
  String get shortcut_action_search => 'بحث';

  @override
  String get shortcut_action_settings => 'الإعدادات';

  @override
  String shortcut_action_go_to_tab(int number) {
    return 'الانتقال إلى علامة التبويب $number';
  }

  @override
  String shortcuts_conflict(String first, String second, String chord) {
    return 'تعارض: يستخدم «$first» و«$second» كلاهما $chord. يبقى الاختصار المخصص على قيمته الافتراضية حتى تغيّر أحدهما.';
  }

  @override
  String shortcuts_editor_title(String action) {
    return 'الاختصار: $action';
  }

  @override
  String get shortcuts_editor_help =>
      'اضغط مجموعة مفاتيح، أو اختر مفاتيح التعديل ومفتاحًا أدناه:';

  @override
  String get shortcuts_editor_needs_modifier =>
      'اختر على الأقل Cmd/Meta أو Ctrl أو Alt حتى لا تتأثر الكتابة في حقل الرسالة.';

  @override
  String shortcuts_text_editing_warning(String chord) {
    return '$chord اختصار لتحرير النص (نسخ أو لصق أو قص أو تراجع أو إعادة أو تحديد الكل). ربطه هنا يحرم حقول النص منه.';
  }

  @override
  String shortcuts_text_editing_in_use(String action, String chord) {
    return 'يستخدم «$action» الاختصار $chord الخاص بتحرير النص. تفقده حقول النص ما دام مربوطًا هنا.';
  }

  @override
  String custom_headers_problem_format(int line) {
    return 'السطر $line: المتوقع «الاسم: القيمة»';
  }

  @override
  String custom_headers_problem_missing_name(int line) {
    return 'السطر $line: اسم الترويسة مفقود';
  }

  @override
  String custom_headers_problem_invalid_name(int line, String name) {
    return 'السطر $line: اسم ترويسة غير صالح «$name»';
  }

  @override
  String custom_headers_problem_reserved(int line, String name) {
    return 'السطر $line: «$name» محجوز ولا يمكن تمريره';
  }

  @override
  String custom_headers_problem_empty_value(int line) {
    return 'السطر $line: قيمة الترويسة فارغة';
  }

  @override
  String get ng_enter_a_deployment_token => 'أدخل رمز جلسة النشر.';

  @override
  String get ng_custom_headers => 'ترويسات مخصصة';

  @override
  String get ng_custom_headers_help =>
      'ترويسات HTTP إضافية لهذه البوابة (الاسم: القيمة، واحدة في كل سطر)، تُرسل مع استدعاءات REST وWebSocket الخاصة بها، وتُحفظ في مخزن بيانات الاعتماد الآمن. تُرفض ترويسات المصادقة والترويسات بين القفزات.';

  @override
  String get ng_use_a_deployment_token => 'استخدام رمز جلسة النشر';

  @override
  String get ng_sign_in_with_deployment_token => 'تسجيل الدخول برمز النشر';

  @override
  String get ng_signed_in_with_deployment_token =>
      'تم تسجيل الدخول برمز النشر.';

  @override
  String get auto_speak_replies_title => 'قراءة الردود تلقائيًا بصوت عالٍ';

  @override
  String get auto_speak_replies_subtitle =>
      'يقرأ كل رد جديد بصوت عالٍ عند اكتمال الدور. متوقف افتراضيًا؛ يظل مفتاح الردود المنطوقة لكل محادثة ساريًا.';

  @override
  String get ng_auto_read_replies_title => 'قراءة الردود تلقائيًا';

  @override
  String get ng_auto_read_replies_subtitle =>
      'يقرأ كل رد جديد بصوت عالٍ عند اكتمال الدور. متوقف افتراضيًا.';

  @override
  String get barge_in_title => 'المقاطعة بالحديث';

  @override
  String get barge_in_subtitle =>
      'تحدّث أثناء قراءة الرد لإيقافها فورًا. يبقى الميكروفون قيد التشغيل أثناء قراءة الردود بصوت عالٍ.';

  @override
  String get barge_in_mic_live => 'الميكروفون قيد التشغيل: تحدّث لإيقاف الرد';

  @override
  String get ng_barge_in_title => 'المقاطعة بالحديث';

  @override
  String get ng_barge_in_subtitle =>
      'تحدّث أثناء قراءة الرد لإيقافها فورًا. يبقى الميكروفون قيد التشغيل أثناء قراءة الردود بصوت عالٍ.';

  @override
  String get ng_barge_in_mic_live =>
      'الميكروفون قيد التشغيل: تحدّث لإيقاف الرد';

  @override
  String get wake_word_title => 'كلمة التنبيه';

  @override
  String get wake_word_subtitle =>
      'اكتشاف كلمة التنبيه عبر البوابة بدون استخدام اليدين. متوقف افتراضيًا؛ يبث صوت الميكروفون فقط عند تفعيل التقاط الجهاز.';

  @override
  String wake_word_listening(String phrase) {
    return 'جارٍ الاستماع لكلمة التنبيه \"$phrase\"';
  }

  @override
  String wake_word_paused(String phrase) {
    return 'كلمة التنبيه \"$phrase\" — متوقفة مؤقتًا';
  }

  @override
  String wake_word_off(String phrase) {
    return 'كلمة التنبيه \"$phrase\" — متوقفة';
  }

  @override
  String get wake_word_arming => 'جارٍ تفعيل كلمة التنبيه…';

  @override
  String get wake_word_stop => 'إيقاف كلمة التنبيه';

  @override
  String get wake_word_rearm => 'إعادة التفعيل';

  @override
  String get wake_word_capture_mode => 'وضع الالتقاط';

  @override
  String get wake_word_capture_auto => 'تلقائي';

  @override
  String get wake_word_capture_client => 'ميكروفون هذا الجهاز';

  @override
  String get wake_word_capture_local => 'ميكروفون مضيف البوابة';

  @override
  String get wake_word_capture_unavailable =>
      'لا تسمح هذه البوابة للتطبيقات بتغيير وضع الالتقاط. اضبط wake_word.capture في إعدادات Hermes على مضيف البوابة.';

  @override
  String get wake_word_input_device => 'ميكروفون الإدخال';

  @override
  String get wake_word_default_device => 'الافتراضي للنظام';

  @override
  String get ng_wake_word_title => 'كلمة التنبيه';

  @override
  String get ng_wake_word_subtitle =>
      'اكتشاف كلمة التنبيه عبر البوابة بدون استخدام اليدين. متوقف افتراضيًا.';

  @override
  String get voice_engine_title => 'محرك المحادثة الصوتية';

  @override
  String get voice_engine_subtitle =>
      'اختر طريقة تشغيل المحادثات الصوتية دون لمس في ملف تعريف البوابة هذا.';

  @override
  String get voice_engine_chained =>
      'متسلسل (تحويل الكلام إلى نص → Hermes → كلام)';

  @override
  String get voice_engine_chained_short => 'متسلسل';

  @override
  String get voice_engine_live => 'GPT-Live (صوت في الوقت الفعلي)';

  @override
  String get voice_engine_live_short => 'GPT-Live';

  @override
  String get voice_engine_live_needs_key =>
      'اضبط مفتاح OpenAI API على مضيف البوابة لتفعيل GPT-Live.';

  @override
  String voice_engine_fallback_chained(String reason) {
    return 'GPT-Live غير متاح ($reason) — يتم استخدام الصوت المتسلسل.';
  }

  @override
  String get voice_live_start => 'بدء محادثة صوتية';

  @override
  String get voice_live_stop => 'إنهاء المحادثة الصوتية';

  @override
  String get voice_live_mute => 'كتم الميكروفون';

  @override
  String get voice_live_unmute => 'إلغاء كتم الميكروفون';

  @override
  String get voice_live_interrupt => 'المقاطعة أو الرد الآن';

  @override
  String get voice_live_listening => 'جارٍ الاستماع';

  @override
  String get voice_live_speaking => 'يتحدث';

  @override
  String get voice_live_thinking => 'يفكر';

  @override
  String get voice_live_muted => 'مكتوم';

  @override
  String get voice_live_ended_connection_lost =>
      'انقطع اتصال جلسة الصوت المباشرة.';

  @override
  String get voice_live_ended_closed => 'أغلقت الخدمة جلسة الصوت المباشرة.';

  @override
  String wake_word_other_profile(String profile) {
    return 'كلمة التنبيه هذه تخص الملف الشخصي \"$profile\". افتح اتصالاً بهذا الملف الشخصي للرد عليها.';
  }

  @override
  String get wake_word_reason_disabled => 'متوقفة — انقر للتفعيل';

  @override
  String get wake_word_reason_surface =>
      'مقصورة على واجهة أخرى (الإعداد wake_word.surface)';

  @override
  String get wake_word_reason_owned => 'واجهة أخرى تملك مستمع كلمة التنبيه';

  @override
  String wake_word_reason_owned_by(String surface) {
    return 'الواجهة ($surface) تملك مستمع كلمة التنبيه';
  }

  @override
  String get wake_word_reason_unavailable =>
      'كلمة التنبيه غير متاحة على هذه البوابة';

  @override
  String get wake_word_reason_permission_denied => 'تم رفض إذن الميكروفون';

  @override
  String get wake_word_reason_permission_required =>
      'إذن الميكروفون مطلوب — انقر للتفعيل';

  @override
  String get voice_live_not_enabled => 'GPT-Live غير مفعّل لملف التعريف هذا.';

  @override
  String get voice_live_not_available => 'GPT-Live غير متاح';

  @override
  String voice_live_start_failed(String error) {
    return 'تعذّر بدء GPT-Live: $error';
  }

  @override
  String voice_direct_stt_timeout(String seconds, String provider) {
    return 'انتهت مهلة التفريغ النصي بعد $seconds ث (لم يستجب $provider)';
  }

  @override
  String voice_direct_stt_error(String provider, String status) {
    return 'خطأ في تحويل الكلام إلى نص من $provider (HTTP $status)';
  }

  @override
  String voice_direct_tts_failed(String provider) {
    return 'فشل طلب تحويل النص إلى كلام من $provider';
  }

  @override
  String voice_direct_tts_error(String provider, String status) {
    return 'خطأ في تحويل النص إلى كلام من $provider (HTTP $status)';
  }

  @override
  String ng_wake_status_listening(String phrase) {
    return 'جارٍ الاستماع (\"$phrase\")';
  }

  @override
  String ng_wake_status_off(String phrase) {
    return 'متوقفة (\"$phrase\")';
  }

  @override
  String ng_wire_setting_unavailable(Object setting) {
    return 'تغيير $setting غير متاح بعد على البوابة المشتركة';
  }

  @override
  String ng_wire_method_unavailable(Object method) {
    return '$method غير متاح بعد على البوابة المشتركة';
  }

  @override
  String ng_wire_session_options_unsupported(Object options) {
    return 'لا تدعم البوابة القياسية خيارات الجلسة الصريحة التالية: $options';
  }

  @override
  String get ng_wire_prompt_stale =>
      'الطلب قديم أو غير متاح؛ أعد الاتصال قبل الرد';

  @override
  String get ng_wire_revision_unavailable =>
      'مراجعة الجلسة غير متاحة؛ أعد فتح الجلسة قبل تعديل البيانات الوصفية';

  @override
  String get ng_wire_generation_unavailable =>
      'معرّف تنفيذ الجلسة غير متاح؛ أعد الاتصال قبل استخدام هذا الأمر';

  @override
  String get ng_wire_message_not_saved =>
      'لم تُحفظ هذه الرسالة بعد؛ انتظر حتى تكتمل ثم أنشئ فرعًا منها مرة أخرى';

  @override
  String get ng_wire_not_available => 'غير متاح بعد على البوابة المشتركة';

  @override
  String get edit_turn_title => 'هل تريد تعديل هذه الرسالة؟';

  @override
  String get edit_turn_body =>
      'سيُعاد تشغيل الرسالة من هنا، وتُؤرشف الأدوار اللاحقة.';

  @override
  String get edit_turn_send => 'إرسال';

  @override
  String get restore_turn_title => 'الاستعادة إلى نقطة الحفظ هذه؟';

  @override
  String get restore_turn_body =>
      'سيُزال كل ما يلي هذه الرسالة من المحادثة، وتُشغَّل الرسالة من جديد بدءًا من هنا.';

  @override
  String get restore_turn_confirm => 'استعادة وإعادة تشغيل';

  @override
  String get edit_turn_later_turns_body =>
      'سيؤدي هذا إلى أرشفة الأدوار اللاحقة من المحادثة. هل تريد المتابعة؟';

  @override
  String get session_history => 'سجل الجلسة';

  @override
  String get import_claude_or_codex => 'استيراد Claude أو Codex';

  @override
  String get ng_session_history => 'سجل الجلسة';

  @override
  String get ng_import_claude_or_codex => 'استيراد Claude أو Codex';

  @override
  String get ng_edit_and_resend => 'تعديل وإعادة إرسال';

  @override
  String get ng_restore_turn_confirm => 'استعادة وإعادة تشغيل';

  @override
  String get rewind_target_unsaved =>
      'لم تُحفظ هذه الرسالة بعد. انتظر حتى تستقر ثم عدّلها مرة أخرى.';

  @override
  String get rewind_turn_busy =>
      'لم يتوقف الرد الحالي بعد، لذلك لم يُرسل شيء. حاول مرة أخرى بعد لحظة.';

  @override
  String get rewind_session_changed =>
      'تغيّرت هذه المحادثة منذ فتحها هنا، لذلك لم يُحذف أو يُرسل شيء. أعد فتحها ثم حاول مرة أخرى.';

  @override
  String get history_lineage => 'المحادثات المرتبطة';

  @override
  String get history_lineage_none =>
      'لا توجد تفرعات أو فروع شقيقة لهذه المحادثة.';

  @override
  String get history_lineage_unavailable =>
      'تعذّرت قراءة المحادثات المرتبطة من هذه البوابة.';

  @override
  String get history_lineage_parent => 'الأصل';

  @override
  String get history_lineage_sibling => 'شقيق';

  @override
  String get history_lineage_fork => 'تفرع';

  @override
  String get history_messages => 'الرسائل';

  @override
  String get history_messages_hint =>
      'اختر رسالة محفوظة للتفرع منها أو الرجوع إليها.';

  @override
  String get history_messages_none => 'لا توجد رسائل محفوظة بعد.';

  @override
  String get history_messages_unavailable =>
      'تعذّرت قراءة الرسائل المحفوظة. افتح هذه المحادثة ثم حدّث.';

  @override
  String get history_role_user => 'أنت';

  @override
  String get history_role_assistant => 'Hermes';

  @override
  String get history_branch_here => 'تفرع من هنا';

  @override
  String get history_rewind_here => 'الرجوع إلى هنا';

  @override
  String get history_branch_title => 'تفرع من هذه الرسالة';

  @override
  String get history_branch_body =>
      'ينشئ هذا محادثة جديدة تحتوي السجل حتى الرسالة المحددة. تبقى المحادثة الحالية كما هي.';

  @override
  String get history_rewind_title => 'الرجوع إلى هذه الرسالة';

  @override
  String get history_rewind_body =>
      'تُزال الرسائل من الرسالة المحددة فصاعدًا من هذه المحادثة. لا تتغير الملفات على الحاسوب. استعادتها إجراء منفصل عبر نقاط الحفظ.';

  @override
  String history_branched(String id) {
    return 'تم التفرع باسم $id';
  }

  @override
  String get history_open_chat => 'فتح المحادثة';

  @override
  String get history_mutate_unsupported =>
      'يتطلب التفرع والرجوع Hermes 0.23 أو أحدث على هذه البوابة.';

  @override
  String get history_checkpoints => 'نقاط الحفظ';

  @override
  String get history_checkpoints_none =>
      'لا توجد نقاط حفظ للملفات في هذه الجلسة.';

  @override
  String get history_checkpoints_unavailable =>
      'نقاط الحفظ غير متاحة على هذه البوابة.';

  @override
  String get history_diff_none => 'لا توجد اختلافات.';

  @override
  String get history_diff_loading => 'جارٍ تحميل التغييرات…';

  @override
  String get history_diff_failed =>
      'تعذّر تحميل التغييرات، لذا لا يمكن استعادة نقطة الحفظ هذه بعد.';

  @override
  String get history_restore_checkpoint => 'استعادة نقطة الحفظ';

  @override
  String get history_restore_title => 'استعادة نقطة الحفظ هذه';

  @override
  String get history_restore_body =>
      'تعود الملفات التي غيّرها الوكيل منذ نقطة الحفظ هذه إلى حالتها حينها. تبقى تغييراتك أنت. قد تُزال أيضًا رسائل المحادثة اللاحقة. لا يتم تفريع المحادثة.';

  @override
  String get history_restore_body_all =>
      'يعود كل ملف في مجلد الجلسة إلى نقطة الحفظ هذه، بما في ذلك تغييراتك أنت. قد تُزال أيضًا رسائل المحادثة اللاحقة. لا يتم تفريع المحادثة.';

  @override
  String get history_restore_own_edits => 'التراجع عن تعديلاتي أيضًا';

  @override
  String get history_restored => 'تمت استعادة نقطة الحفظ.';

  @override
  String history_restored_removed(int count) {
    return 'تمت استعادة نقطة الحفظ. أُزيلت $count من رسائل المحادثة.';
  }

  @override
  String get history_export => 'تصدير';

  @override
  String get history_export_redact => 'إخفاء الرموز السرية';

  @override
  String get history_export_action => 'تصدير النص';

  @override
  String get history_export_saved => 'تم حفظ النص.';

  @override
  String get history_export_unsupported =>
      'يتطلب التصدير Hermes 0.23 أو أحدث على هذه البوابة.';

  @override
  String get history_import_unsupported =>
      'استيراد Claude و Codex غير مدعوم على هذه البوابة.';

  @override
  String history_import_destination(String profile) {
    return 'ملف التعريف الوجهة: $profile.';
  }

  @override
  String history_import_reading(String host, String profile, int count) {
    return 'القراءة من $host · ملف التعريف الوجهة: $profile. تعذّرت قراءة $count من السجلات.';
  }

  @override
  String get history_import_all => 'الكل';

  @override
  String history_import_scan_failed(String reason) {
    return 'تعذّر فحص جلسات المضيف: $reason';
  }

  @override
  String get history_import_none =>
      'لم يُعثر على جلسات Claude Code أو Codex على هذا المضيف.';

  @override
  String get history_import_no_match => 'لا توجد جلسات مضيف مطابقة.';

  @override
  String history_import_preview_failed(String reason) {
    return 'تعذّرت معاينة الجلسة: $reason';
  }

  @override
  String get history_import_open => 'فتح الجلسة المستوردة';

  @override
  String get history_import_action => 'استيراد الجلسة المحددة';

  @override
  String get history_import_title => 'استيراد هذه الجلسة';

  @override
  String history_import_body(String profile) {
    return 'نسخ جلسة Claude أو Codex هذه إلى ملف التعريف \"$profile\" على هذه البوابة.';
  }

  @override
  String history_import_body_existing(String profile) {
    return 'سبق استيراد هذه الجلسة إلى \"$profile\". تابع بالنسخة الموجودة.';
  }

  @override
  String history_imported(String id) {
    return 'تم الاستيراد باسم $id';
  }

  @override
  String history_imported_already(String id) {
    return 'سبق الاستيراد باسم $id';
  }

  @override
  String history_import_directory(String path) {
    return 'المجلد: $path';
  }

  @override
  String history_import_preview_partial(int shown, int total) {
    return 'تعرض المعاينة $shown من $total.';
  }

  @override
  String history_failed(String reason) {
    return 'تعذّر الإكمال: $reason';
  }

  @override
  String get history_error_unavailable =>
      'تعذّر على البوابة تنفيذ ذلك الآن. حاول مرة أخرى.';

  @override
  String get history_error_unsupported => 'هذه البوابة لا تدعم ذلك.';

  @override
  String get history_error_denied => 'رفضت هذه البوابة الطلب.';

  @override
  String get history_error_changed =>
      'تغيّرت هذه المحادثة أثناء فتح هذه الصفحة. حدّث ثم حاول مرة أخرى.';

  @override
  String get history_error_unbound =>
      'هذه المحادثة غير مفتوحة على البوابة. افتحها ثم حاول مرة أخرى.';

  @override
  String get history_error_invalid =>
      'أرسلت البوابة ردًا تعذّر على التطبيق قراءته.';

  @override
  String ng_dock_kanban(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عدد بطاقات Kanban: $count',
      one: 'بطاقة Kanban واحدة',
    );
    return '$_temp0';
  }

  @override
  String ng_dock_kanban_done(int count) {
    return 'عدد المكتملة: $count';
  }

  @override
  String get ng_show_kanban => 'إظهار بطاقات Kanban';

  @override
  String get ng_hide_kanban => 'إخفاء بطاقات Kanban';

  @override
  String get ng_kanban_status_triage => 'الفرز';

  @override
  String get ng_kanban_status_todo => 'للتنفيذ';

  @override
  String get ng_kanban_status_scheduled => 'مجدولة';

  @override
  String get ng_kanban_status_ready => 'جاهزة';

  @override
  String get ng_kanban_status_running => 'قيد التشغيل';

  @override
  String get ng_kanban_status_blocked => 'متعذّر التقدّم';

  @override
  String get ng_kanban_status_review => 'قيد المراجعة';

  @override
  String get ng_kanban_status_done => 'مكتملة';

  @override
  String get ng_kanban_status_archived => 'مؤرشفة';

  @override
  String ng_kanban_open_card(String title) {
    return 'فتح $title في Kanban';
  }

  @override
  String ng_kanban_show_all(int count) {
    return 'إظهار الكل ($count)';
  }

  @override
  String ng_kanban_this_chat(int count) {
    return 'هذه المحادثة ($count)';
  }

  @override
  String get ng_kanban_close => 'إغلاق Kanban';

  @override
  String get ng_kanban_block_no_dashboard =>
      'لا يملك هذا الاتصال صلاحية الوصول إلى لوحة التحكم، لذا لا تُحدَّث حالة البطاقات مباشرةً ولا يمكن فتح اللوحة.';

  @override
  String get ng_kanban_block_unsupported =>
      'Kanban غير مفعّل على هذه البوابة. فعّل إضافة kanban لعرض الحالة المباشرة وفتح اللوحة.';

  @override
  String get ng_kanban_block_denied =>
      'سجّل الدخول إلى لوحة التحكم لعرض الحالة المباشرة للبطاقات وفتح اللوحة.';

  @override
  String get ng_kanban_block_insecure =>
      'يتطلب Kanban اتصال HTTPS أو اتصالًا محليًا، لذا لا تُحدَّث حالة البطاقات مباشرةً ولا يمكن فتح اللوحة.';

  @override
  String get ng_kanban_block_unreachable =>
      'تعذّر الوصول إلى Kanban على هذه البوابة. قد تكون حالة البطاقات قديمة.';

  @override
  String get ng_kanban_block_stale =>
      'تغيّر الاتصال. أعد فتح هذه المحادثة لعرض الحالة المباشرة للبطاقات.';

  @override
  String get ng_bots_tab_roster => 'قائمة البوتات';

  @override
  String get ng_bots_tab_rooms => 'الغرف';

  @override
  String get ng_bots_tab_screen => 'الشاشة';

  @override
  String get ng_bots_tab_routines => 'المهام المجدولة';

  @override
  String ng_bots_rooms_load_failed(String error) {
    return 'تعذّر تحميل الغرف: $error';
  }

  @override
  String ng_bots_routines_load_failed(String error) {
    return 'تعذّر تحميل المهام المجدولة: $error';
  }

  @override
  String ng_bots_desktop_failed(String error) {
    return 'Bot Desktop: $error';
  }

  @override
  String get ng_bots_install_not_started => 'لم تبدأ البوابة عملية التثبيت.';

  @override
  String ng_bots_install_failed_error(String error) {
    return 'فشل التثبيت: $error';
  }

  @override
  String get ng_bots_install_cancelled => 'تم إلغاء التثبيت.';

  @override
  String get ng_bots_install_no_sudo =>
      'الأمر sudo غير متاح على مضيف البوابة. شغّل الأمر أعلاه هناك، ثم حدّث.';

  @override
  String ng_bots_install_exit_code(String code) {
    return 'فشل التثبيت (رمز الخروج $code).';
  }

  @override
  String ng_bots_install_done(String bot) {
    return 'تم تثبيت Bot Desktop للبوت $bot';
  }

  @override
  String get ng_bots_start_failed => 'فشل التشغيل';

  @override
  String ng_bots_stop_title(String bot) {
    return 'هل تريد إيقاف Bot Desktop للبوت $bot؟';
  }

  @override
  String get ng_bots_stop_human_held =>
      'هناك شخص يتحكم في هذه الشاشة. سيؤدي الإيقاف إلى إنهاء جلسته وإغلاق كل ما هو مفتوح عليها.';

  @override
  String get ng_bots_stop_body => 'سيتم إغلاق كل ما هو مفتوح على شاشة البوت.';

  @override
  String get ng_bots_stop_refused => 'رُفض الإيقاف';

  @override
  String get ng_bots_take_over_reason => 'تولي التحكم من Ares';

  @override
  String ng_bots_take_over_failed(String error) {
    return 'فشل تولي التحكم: $error';
  }

  @override
  String ng_bots_force_hand_back_title(String bot) {
    return 'هل تريد إعادة شاشة $bot إلى البوت؟';
  }

  @override
  String get ng_bots_force_hand_back_body =>
      'هناك شخص يتحكم في هذه الشاشة. إذا كان لا يزال يستخدمها، فسيفقد التحكم.';

  @override
  String get ng_bots_hand_back => 'إعادة التحكم';

  @override
  String get ng_bots_hand_back_failed => 'فشلت إعادة التحكم';

  @override
  String get ng_bots_adopt_title =>
      'هل تريد اعتماد صورة صندوق الحماية الجديدة؟';

  @override
  String ng_bots_adopt_body(String bot, String current, String target) {
    return 'سينتقل $bot من $current إلى $target. ستُعاد إنشاء حاويته عند استدعاء الطرفية التالي، وسيُفقد أي شيء محفوظ في الحاوية الحالية فقط.';
  }

  @override
  String get ng_bots_adopt_image => 'اعتماد الصورة';

  @override
  String get ng_bots_image_switch_failed => 'فشل تبديل الصورة';

  @override
  String get ng_bots_keep_refused => 'رُفض الإبقاء على الصورة';

  @override
  String ng_bots_chat_open_failed(String error) {
    return 'تعذّر فتح Bot Chat: $error';
  }

  @override
  String ng_bots_title(String connection) {
    return 'البوتات · $connection';
  }

  @override
  String get ng_bots_protocol_tooltip =>
      'تحقن البوابة بروتوكول المراسلة بين الزملاء بنفسها — لا يُرسل أي بروتوكول SOUL.md إضافي.';

  @override
  String ng_bots_unavailable(String reason) {
    return 'البوتات غير متاحة ($reason)';
  }

  @override
  String get ng_bots_account_changed => 'تغيّر الحساب. أعد الاتصال أو حدّث.';

  @override
  String get ng_bots_try_refresh =>
      'حاول التحديث. إذا استمرت المشكلة، فقد لا تدعم البوابة البوتات.';

  @override
  String get ng_bots_search => 'البحث عن البوتات';

  @override
  String get ng_bots_none_found => 'لم يتم العثور على بوتات.';

  @override
  String get ng_bots_no_model => 'لا يوجد نموذج';

  @override
  String ng_bots_skill_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عدد المهارات: $count',
      one: 'مهارة واحدة',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_bot_chat => 'Bot Chat';

  @override
  String ng_bots_install_id(String id, String protocol) {
    return 'تُبلغ البوابة عن معرّف التثبيت $id · bot_mode_protocol: $protocol';
  }

  @override
  String get ng_bots_protocol_note =>
      'تحقن البوابة بروتوكول المراسلة بين الزملاء عند تعيين bot_mode_protocol. المعرّف: default→hermes، وإلا فاسم الملف الشخصي.';

  @override
  String get ng_bots_no_rooms => 'لا توجد غرف بعد. أنشئ غرفة من قائمة البوتات.';

  @override
  String ng_bots_member_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عدد الأعضاء: $count',
      one: 'عضو واحد',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_room_disbanded => 'مُنحلّة';

  @override
  String get ng_bots_room_adopted => 'مُعتمدة';

  @override
  String get ng_bots_rooms_gateway => 'غرف البوابة';

  @override
  String get ng_bots_rooms_desktop => 'غرف يديرها تطبيق سطح المكتب';

  @override
  String ng_bots_rooms_gateway_body(String methods) {
    return 'الغرف مملوكة للبوابة. الطرق: $methods.';
  }

  @override
  String get ng_bots_rooms_no_seat =>
      'قد لا تتمكن هذه البوابة من استضافة الغرف (تتطلب عملية دائمة التشغيل).';

  @override
  String get ng_bots_rooms_fallback =>
      'الوضع الاحتياطي التقليدي: يدير تطبيق سطح المكتب جولات المجموعة (لا يتم إنشاؤها هنا).';

  @override
  String get ng_bots_create_room => 'إنشاء غرفة';

  @override
  String get ng_bots_refresh_rooms => 'تحديث الغرف';

  @override
  String get ng_bots_room_created => 'تم إنشاء الغرفة';

  @override
  String ng_bots_room_refused(String reason) {
    return 'رُفض إنشاء الغرفة ($reason)';
  }

  @override
  String ng_bots_room_failed(String error) {
    return 'فشل إنشاء الغرفة: $error';
  }

  @override
  String get ng_bots_bot => 'البوت';

  @override
  String get ng_bots_screen_unavailable => 'حالة الشاشة غير متاحة';

  @override
  String get ng_bots_screen_unavailable_body =>
      'شغّل شاشة البوت لمشاهدة صورتها المصغّرة، أو تولَّ التحكم لاستخدامها بنفسك.';

  @override
  String get ng_bots_take_over_note =>
      'يفتح تولي التحكم الشاشة المباشرة ويمنحك التحكم فيها. يعود التحكم إلى البوت عند إغلاق الشاشة المباشرة أو مغادرة هذه الصفحة أو نقل التطبيق إلى الخلفية.';

  @override
  String get ng_bots_not_installed => 'غير مثبّت';

  @override
  String get ng_bots_unsupported_host => 'مضيف غير مدعوم';

  @override
  String ng_bots_pid(String pid) {
    return 'pid $pid';
  }

  @override
  String ng_bots_missing(String items) {
    return 'مفقود: $items';
  }

  @override
  String ng_bots_blocked(String reason) {
    return 'محظور: $reason';
  }

  @override
  String get ng_bots_no_switch => 'لا يوجد تبديل معلّق لصورة صندوق الحماية.';

  @override
  String ng_bots_switch_image(String current, String target) {
    return 'تبديل الصورة: $current → $target';
  }

  @override
  String get ng_bots_bot_in_control => 'البوت يتحكم';

  @override
  String get ng_bots_person_in_control => 'شخص يتحكم';

  @override
  String get ng_bots_installing => 'جارٍ تثبيت Bot Desktop على مضيف البوابة…';

  @override
  String get ng_bots_install_unfinished => 'لم يكتمل التثبيت';

  @override
  String get ng_bots_install => 'تثبيت';

  @override
  String get ng_bots_start => 'تشغيل';

  @override
  String get ng_bots_take_over => 'تولي التحكم';

  @override
  String get ng_bots_keep_image => 'الإبقاء على الصورة الحالية';

  @override
  String ng_bots_missing_pieces(String items) {
    return 'أبلغت البوابة عن مكوّنات مفقودة: $items';
  }

  @override
  String get ng_bots_install_missing => 'تثبيت المكوّنات المفقودة';

  @override
  String get ng_bots_thumbnail_unavailable => 'الصورة المصغّرة غير متاحة';

  @override
  String get ng_bots_thumbnail_title => 'الصورة المصغّرة للشاشة (مباشر)';

  @override
  String get ng_bots_thumbnail_suppressed =>
      'الصورة المصغّرة مخفية أثناء تحكم شخص في الشاشة.';

  @override
  String get ng_bots_thumbnail_pending => 'الصورة المصغّرة غير متاحة بعد.';

  @override
  String ng_bots_routines_of(String bot) {
    return '$bot · المهام المجدولة';
  }

  @override
  String get ng_bots_add_routine => 'إضافة مهمة مجدولة';

  @override
  String get ng_bots_no_routines => 'لا توجد مهام مجدولة لهذا البوت.';

  @override
  String get ng_bots_routines_note =>
      'المهام المجدولة هي وظائف موسومة بـ [bot:<name>] يملكها مخزن الملف الشخصي للبوت. يتم إيقاف المهام المجدولة المفوّضة القديمة مؤقتًا بشكل إجباري عند التحميل.';

  @override
  String ng_bots_routine_last(String status) {
    return 'آخر تشغيل: $status';
  }

  @override
  String ng_bots_routine_next(String time) {
    return 'التشغيل التالي: $time';
  }

  @override
  String ng_bots_routine_error(String error) {
    return 'خطأ: $error';
  }

  @override
  String ng_bots_remove_routine_title(String routine) {
    return 'هل تريد إزالة المهمة المجدولة $routine؟';
  }

  @override
  String ng_bots_remove_routine_body(String bot) {
    return 'سيتم حذف المهمة المجدولة من جدول $bot. لا يمكن التراجع عن ذلك.';
  }

  @override
  String ng_bots_routine_action_failed(String action, String error) {
    return 'فشل $action: $error';
  }

  @override
  String get ng_bots_not_connected => 'غير متصل.';

  @override
  String ng_bots_add_failed(String error) {
    return 'فشلت الإضافة: $error';
  }

  @override
  String get ng_bots_routine_added => 'تمت إضافة المهمة المجدولة';

  @override
  String get ng_bots_routine_enabled => 'مفعّلة';

  @override
  String get ng_bots_routine_paused => 'متوقفة مؤقتًا';

  @override
  String ng_bots_path(String path) {
    return 'المسار: $path';
  }

  @override
  String get ng_bots_chat_present => 'Bot Chat موجود';

  @override
  String get ng_bots_chat_missing => 'Bot Chat مفقود';

  @override
  String ng_bots_last_session(String preview) {
    return 'آخر جلسة: $preview';
  }

  @override
  String get ng_bots_open_chat => 'فتح Bot Chat';

  @override
  String get ng_bots_desktop => 'Bot Desktop';

  @override
  String get ng_bots_room_name => 'اسم الغرفة';

  @override
  String get ng_bots_select_member => 'اختر عضوًا واحدًا على الأقل.';

  @override
  String get ng_bots_sudo_title => 'كلمة مرور المسؤول';

  @override
  String ng_bots_sudo_body(String bot) {
    return 'يتطلب تثبيت Bot Desktop للبوت $bot صلاحية sudo على مضيف البوابة. تُرسل كلمة المرور إلى تلك البوابة فقط، لهذا التثبيت، ولا يتم حفظها.';
  }

  @override
  String get ng_bots_sudo_password => 'كلمة مرور sudo';

  @override
  String get ng_bots_new_routine => 'مهمة مجدولة جديدة';

  @override
  String get ng_bots_routine_title => 'العنوان';

  @override
  String get ng_bots_routine_instruction => 'التعليمات';

  @override
  String get ng_bots_cron => 'تعبير cron';

  @override
  String get ng_bots_interval => 'الفاصل الزمني';

  @override
  String get ng_bots_cron_help => '0 9 * * * يعمل كل يوم في الساعة 09:00';

  @override
  String get ng_bots_every => 'كل';

  @override
  String get ng_bots_unit_minutes => 'دقائق';

  @override
  String get ng_bots_unit_hours => 'ساعات';

  @override
  String get ng_bots_unit_days => 'أيام';

  @override
  String get ng_bots_stop_after => 'الإيقاف بعد (عدد مرات التشغيل)';

  @override
  String get ng_bots_stop_after_help => 'اتركه فارغًا للاستمرار في التشغيل';

  @override
  String get ng_bots_send_results => 'إرسال النتائج إلى';

  @override
  String get ng_bots_run_history => 'سجل التشغيل فقط';

  @override
  String get ng_bots_continuity => 'المتابعة من التشغيل السابق';

  @override
  String get ng_bots_account_changed_refresh =>
      'تغيّر الحساب. حدّث قبل المتابعة.';

  @override
  String ng_bots_room_load_failed(String error) {
    return 'تعذّر تحميل الغرفة: $error';
  }

  @override
  String ng_bots_send_failed(String error) {
    return 'فشل الإرسال: $error';
  }

  @override
  String ng_bots_stop_failed(String error) {
    return 'فشل الإيقاف: $error';
  }

  @override
  String get ng_bots_stop_room => 'إيقاف الغرفة';

  @override
  String get ng_bots_send_message => 'إرسال رسالة';

  @override
  String get ng_bots_room_hint => 'راسل الغرفة (اذكر الأعضاء باستخدام @handle)';

  @override
  String get ng_bots_history => 'السجل';

  @override
  String ng_bots_revision(String revision) {
    return 'المراجعة $revision';
  }

  @override
  String ng_bots_last_error(String error) {
    return 'آخر خطأ: $error';
  }

  @override
  String get ng_bots_members => 'الأعضاء';

  @override
  String get ng_bots_room_context => 'سياق الغرفة';

  @override
  String ng_bots_purpose(String purpose) {
    return 'الغرض: $purpose';
  }

  @override
  String ng_bots_notes(String notes) {
    return 'ملاحظات: $notes';
  }

  @override
  String ng_bots_routing(String routing) {
    return 'التوجيه: $routing';
  }

  @override
  String ng_bots_lead(String member) {
    return 'القائد $member';
  }

  @override
  String get ng_bots_viewer_you_control =>
      'أنت تتحكم في هذه الشاشة. ينتظر البوت حتى تعيد إليه التحكم.';

  @override
  String get ng_bots_viewer_handed_back => 'عاد التحكم إلى البوت.';

  @override
  String get ng_bots_viewer_background =>
      'عاد التحكم إلى البوت لأن التطبيق لم يعد في المقدمة.';

  @override
  String get ng_bots_viewer_taken => 'تولى شخص آخر التحكم في هذه الشاشة.';

  @override
  String get ng_bots_viewer_lost =>
      'فُقد العرض المباشر، لذا عاد التحكم إلى البوت.';

  @override
  String ng_bots_viewer_title(String bot) {
    return 'Bot Desktop · $bot';
  }

  @override
  String get ng_bots_viewer_type_hint => 'اكتب على شاشة البوت';

  @override
  String get ng_bots_viewer_type => 'كتابة';

  @override
  String get ng_bots_viewer_enter => 'إدخال';

  @override
  String get ng_bots_viewer_backspace => 'مسح للخلف';

  @override
  String get ng_more_kanban => 'Kanban';

  @override
  String get ng_more_kanban_subtitle =>
      'اللوحات وتبعيات المهام وتعيين العمّال والسجلات';

  @override
  String get ng_more_bots => 'البوتات';

  @override
  String get ng_more_bots_subtitle =>
      'قائمة البوتات والغرف والمهام المجدولة و Bot Desktop';

  @override
  String get ng_slash_kanban => 'فتح لوحة Kanban';

  @override
  String get ng_slash_bots => 'فتح البوتات';

  @override
  String ng_board_card_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count من البطاقات',
      one: 'بطاقة واحدة',
    );
    return '$_temp0';
  }

  @override
  String ng_board_event_toast(String task, String event) {
    return 'Kanban $task: $event';
  }

  @override
  String get ng_board_task => 'مهمة';

  @override
  String ng_board_refused_http(String status) {
    return 'رُفض الإجراء (HTTP $status).';
  }

  @override
  String get ng_board_err_unsupported =>
      'إضافة Kanban غير مفعّلة على هذه البوابة.';

  @override
  String get ng_board_err_denied =>
      'يلزم تسجيل الدخول أو الحصول على إذن على هذه البوابة.';

  @override
  String get ng_board_err_stale => 'تغيّر مالك البوابة. حدّث قبل المتابعة.';

  @override
  String get ng_board_err_insecure =>
      'يلزم HTTPS (أو عنوان الاسترجاع المحلي) لعمليات مساحة عمل Kanban.';

  @override
  String get ng_board_err_unreachable =>
      'تعذّر الوصول إلى خدمة Kanban على هذه البوابة.';

  @override
  String get ng_board_err_failed => 'فشلت العملية. حدّث وحاول مرة أخرى.';

  @override
  String ng_board_block_title(String task) {
    return 'حظر $task';
  }

  @override
  String get ng_board_block_reason => 'سبب الحظر';

  @override
  String get ng_board_block_hint => 'ما الذي يعيق هذه البطاقة؟';

  @override
  String ng_board_review_title(String task) {
    return 'طلب مراجعة $task';
  }

  @override
  String get ng_board_review_summary => 'ملخص المراجعة';

  @override
  String get ng_board_review_hint => 'ما الذي تم تنفيذه والتحقق منه؟';

  @override
  String ng_board_move_title(String cards, String column) {
    return 'هل تريد نقل $cards إلى $column؟';
  }

  @override
  String ng_board_move_body(String board) {
    return 'ستنتقل كل بطاقة محددة في $board إلى عمود آخر. وستتوقف أي بطاقة قيد التشغيل.';
  }

  @override
  String get ng_board_move => 'نقل';

  @override
  String ng_board_moved(String column) {
    return 'تم نقل البطاقات إلى $column';
  }

  @override
  String ng_board_unassign_title(String cards) {
    return 'هل تريد إلغاء تعيين $cards؟';
  }

  @override
  String ng_board_assign_title(String cards, String profile) {
    return 'هل تريد تعيين $cards إلى @$profile؟';
  }

  @override
  String get ng_board_assign_body =>
      'تُستعاد البطاقات قيد التشغيل أولًا: يتم إيقاف العمّال الخاصين بها.';

  @override
  String get ng_board_unassign => 'إلغاء التعيين';

  @override
  String get ng_board_assign => 'تعيين';

  @override
  String get ng_board_unassigned_done => 'تم إلغاء تعيين البطاقات المحددة';

  @override
  String ng_board_assigned_done(String profile) {
    return 'تم التعيين إلى @$profile';
  }

  @override
  String ng_board_archive_title(String cards) {
    return 'هل تريد أرشفة $cards؟';
  }

  @override
  String ng_board_archive_body(String board) {
    return 'تُزال البطاقات المؤرشفة من $board. فعّل «المؤرشفة» لرؤيتها مجددًا.';
  }

  @override
  String get ng_board_archived_done => 'تمت أرشفة البطاقات المحددة';

  @override
  String ng_board_delete_title(String cards) {
    return 'هل تريد حذف $cards؟';
  }

  @override
  String ng_board_delete_body(String board) {
    return 'سيؤدي هذا إلى حذف البطاقات المحددة نهائيًا من $board.';
  }

  @override
  String ng_board_deleted(String cards) {
    return 'تم حذف $cards.';
  }

  @override
  String ng_board_partial_failure(String failed, String total, String reason) {
    return 'فشل $failed من أصل $total: $reason';
  }

  @override
  String get ng_board_refused => 'مرفوض';

  @override
  String ng_board_dispatched(
    String spawned,
    String promoted,
    String reclaimed,
  ) {
    return 'تم التوزيع: أُطلق $spawned، ورُقّي $promoted، واستُعيد $reclaimed.';
  }

  @override
  String ng_board_board_archived(String board) {
    return 'تمت أرشفة اللوحة $board';
  }

  @override
  String ng_board_board_archived_to(String path) {
    return 'تمت الأرشفة إلى $path';
  }

  @override
  String ng_board_exported(String board, String archive) {
    return 'تم تصدير $board إلى $archive';
  }

  @override
  String ng_board_imported(String board, String warnings) {
    return 'تم استيراد اللوحة $board$warnings';
  }

  @override
  String ng_board_created(String task) {
    return 'تم إنشاء $task';
  }

  @override
  String get ng_board_orchestration_saved => 'تم حفظ تنسيق Kanban';

  @override
  String get ng_board_auto_describe_unavailable => 'الوصف التلقائي غير متاح';

  @override
  String ng_board_description_updated(String profile) {
    return 'تم تحديث وصف @$profile';
  }

  @override
  String ng_board_title(String board) {
    return 'Kanban · $board';
  }

  @override
  String ng_board_active(String count) {
    return 'النشطة: $count';
  }

  @override
  String get ng_board_dispatch => 'توزيع المهام الجاهزة الآن';

  @override
  String get ng_board_orchestration => 'التنسيق والعمّال';

  @override
  String get ng_board_new_task => 'مهمة جديدة';

  @override
  String get ng_board_enable_plugin =>
      'فعّل الإضافة المضمّنة \"kanban\" من الإمكانات → الإضافات على هذه البوابة لتنشيط موجّه اللوحات الخاص بها.';

  @override
  String get ng_board_filter => 'تصفية المهام…';

  @override
  String get ng_board_all_assignees => 'جميع المكلّفين';

  @override
  String get ng_board_unassigned => 'غير معيّنة';

  @override
  String get ng_board_running_by_profile => 'قيد التشغيل حسب الملف الشخصي';

  @override
  String get ng_board_select => 'تحديد';

  @override
  String ng_board_selected_chip(String count) {
    return 'المحددة ($count)';
  }

  @override
  String get ng_board_locked_column => 'عمود مُدار — السحب والإفلات معطّل';

  @override
  String ng_board_add_to(String column) {
    return 'إضافة إلى $column';
  }

  @override
  String ng_board_collapse(String column) {
    return 'طيّ $column';
  }

  @override
  String ng_board_column_empty(String column) {
    return 'لا توجد مهام في $column';
  }

  @override
  String get ng_board_drop_here => 'أفلِت هنا أو + مهمة';

  @override
  String get ng_board_card_actions => 'إجراءات البطاقة';

  @override
  String get ng_board_open_details => 'فتح التفاصيل';

  @override
  String get ng_board_select_card => 'تحديد البطاقة';

  @override
  String ng_board_move_to(String column) {
    return 'نقل إلى $column';
  }

  @override
  String get ng_board_parked => 'مركونة';

  @override
  String ng_board_blocked_by(String count) {
    return 'محظورة بواسطة $count';
  }

  @override
  String get ng_board_goal_loop => 'حلقة الهدف';

  @override
  String ng_board_selected(String count) {
    return 'المحددة: $count';
  }

  @override
  String get ng_board_move_menu => 'نقل…';

  @override
  String get ng_board_assign_menu => 'تعيين…';

  @override
  String get ng_board_new_board_title => 'لوحة Kanban جديدة';

  @override
  String get ng_board_slug => 'المعرّف المختصر (أحرف صغيرة، مثل release-v5)';

  @override
  String get ng_board_display_name => 'الاسم المعروض';

  @override
  String get ng_board_linked_project => 'المشروع المرتبط (اختياري)';

  @override
  String get ng_board_none => 'لا شيء';

  @override
  String get ng_board_default_workdir =>
      'دليل العمل الافتراضي على المضيف (اختياري)';

  @override
  String get ng_board_import_title => 'استيراد أرشيف لوحة';

  @override
  String get ng_board_import_path => 'مسار أرشيف .tar.gz على المضيف';

  @override
  String get ng_board_import => 'استيراد';

  @override
  String ng_board_edit_board(String board) {
    return 'تعديل $board';
  }

  @override
  String get ng_board_name => 'الاسم';

  @override
  String get ng_board_description => 'الوصف';

  @override
  String get ng_board_workdir_clear =>
      'دليل العمل الافتراضي (اتركه فارغًا للمسح)';

  @override
  String get ng_board_boards => 'لوحات Kanban';

  @override
  String get ng_board_new_board => 'لوحة جديدة';

  @override
  String get ng_board_search_boards => 'البحث في اللوحات…';

  @override
  String get ng_board_unpin => 'إلغاء تثبيت علامة التبويب';

  @override
  String get ng_board_pin => 'تثبيت علامة التبويب';

  @override
  String ng_board_archive_board_title(String board) {
    return 'هل تريد أرشفة اللوحة $board؟';
  }

  @override
  String ng_board_archive_board_body(String cards) {
    return 'ستُزال اللوحة مع $cards التابعة لها من قائمة اللوحات. تحتفظ البوابة بأرشيف على مضيفها.';
  }

  @override
  String get ng_board_edit_metadata => 'تعديل البيانات الوصفية';

  @override
  String get ng_board_export => 'تصدير .tar.gz على المضيف';

  @override
  String get ng_board_move_pin_left => 'نقل علامة التبويب المثبّتة إلى اليسار';

  @override
  String get ng_board_archive_board => 'أرشفة اللوحة';

  @override
  String get ng_board_new_task_title => 'مهمة Kanban جديدة';

  @override
  String get ng_board_title_required => 'العنوان *';

  @override
  String get ng_board_spec => 'المواصفات ومعايير القبول';

  @override
  String get ng_board_estimate => 'التقدير';

  @override
  String ng_board_estimate_draft(String complexity, String tokens) {
    return 'التعقيد $complexity (~$tokens رمز — تقدير لعدد الرموز فقط، وليس تقديرًا للتكلفة بالدولار)';
  }

  @override
  String get ng_board_estimate_unavailable => 'التقدير غير متاح';

  @override
  String get ng_board_initial_column => 'العمود الأولي';

  @override
  String get ng_board_worker_assignee => 'العامل المكلّف';

  @override
  String get ng_board_parked_unassigned => 'مركونة (غير معيّنة)';

  @override
  String get ng_board_priority => 'الأولوية';

  @override
  String get ng_board_workspace => 'مساحة العمل';

  @override
  String get ng_board_scratch => 'مساحة مؤقتة';

  @override
  String get ng_board_worktree => 'شجرة عمل Git';

  @override
  String get ng_board_shared_dir => 'دليل مشترك';

  @override
  String get ng_board_workspace_path => 'مسار مساحة العمل على المضيف';

  @override
  String get ng_board_parent => 'التبعية الأم (اختياري)';

  @override
  String get ng_board_skills => 'المهارات المثبّتة (مفصولة بفواصل، اختياري)';

  @override
  String get ng_board_provider_override => 'تجاوز المزوّد';

  @override
  String get ng_board_model_override => 'تجاوز النموذج';

  @override
  String get ng_board_reasoning => 'مستوى الاستدلال';

  @override
  String get ng_board_profile_default => 'الافتراضي للملف الشخصي';

  @override
  String get ng_board_xhigh => 'عالٍ جدًا';

  @override
  String get ng_board_goal_mode => 'وضع حلقة الهدف';

  @override
  String get ng_board_goal_turns =>
      'الحد الأقصى لأدوار الهدف (فارغ = الافتراضي)';

  @override
  String get ng_board_create_task => 'إنشاء مهمة';

  @override
  String get ng_board_orchestration_title => 'التنسيق وملفات العمّال الشخصية';

  @override
  String ng_board_orchestrator(String profile) {
    return 'الملف الشخصي للمنسّق (المحدَّد: $profile)';
  }

  @override
  String get ng_board_inherit_default => 'وراثة الافتراضي النشط';

  @override
  String ng_board_default_assignee(String profile) {
    return 'المكلّف الافتراضي (المحدَّد: $profile)';
  }

  @override
  String get ng_board_auto_decompose => 'تقسيم بطاقات الفرز تلقائيًا';

  @override
  String get ng_board_auto_decompose_help =>
      'يستخدم نموذج kanban_decomposer المُهيّأ على مهام الفرز';

  @override
  String get ng_board_save_orchestration => 'حفظ التنسيق';

  @override
  String get ng_board_worker_descriptions => 'أوصاف تخصص العمّال';

  @override
  String ng_board_worker_label(String profile, String model, String skills) {
    return '@$profile ($model · $skills)';
  }

  @override
  String get ng_board_default_model => 'النموذج الافتراضي';

  @override
  String get ng_board_save_description => 'حفظ الوصف';

  @override
  String get ng_board_auto_describe => 'وصف تلقائي من المهارات والشخصية';

  @override
  String get ng_board_manual_block => 'حظر يدوي من المشغّل';

  @override
  String get ng_board_requested_review => 'طُلبت المراجعة';

  @override
  String ng_board_requeue_title(String task) {
    return 'هل تريد إعادة $task إلى قائمة الانتظار؟';
  }

  @override
  String get ng_board_requeue_body =>
      'سيتم إيقاف العامل الذي يشغّل هذه البطاقة، وستعود البطاقة إلى قائمة الانتظار.';

  @override
  String get ng_board_requeue => 'إعادة إلى قائمة الانتظار';

  @override
  String ng_board_reassign_title(String task, String profile) {
    return 'هل تريد إعادة تعيين $task إلى @$profile؟';
  }

  @override
  String get ng_board_reassign_body =>
      'هذه البطاقة قيد التشغيل: سيتم إيقاف العامل الخاص بها أولًا.';

  @override
  String get ng_board_reassign => 'إعادة التعيين';

  @override
  String ng_board_saved_task(String task) {
    return 'تم حفظ المهمة $task';
  }

  @override
  String get ng_board_commented_requeued =>
      'تم نشر التعليق وإعادة المهمة إلى قائمة الانتظار';

  @override
  String get ng_board_commented => 'تم نشر التعليق';

  @override
  String ng_board_requeued(String task) {
    return 'تمت إعادة $task إلى قائمة الانتظار';
  }

  @override
  String get ng_board_decompose_failed => 'فشل التقسيم.';

  @override
  String ng_board_decompose_failed_reason(String reason) {
    return 'فشل التقسيم: $reason';
  }

  @override
  String ng_board_decomposed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم التقسيم إلى $count من المهام الفرعية',
      one: 'تم التقسيم إلى مهمة فرعية واحدة',
    );
    return '$_temp0';
  }

  @override
  String get ng_board_no_children => 'لم يتم إنشاء أي مهام فرعية.';

  @override
  String ng_board_no_children_reason(String reason) {
    return 'لم يتم إنشاء أي مهام فرعية: $reason';
  }

  @override
  String ng_board_uploaded(String file) {
    return 'تم رفع $file';
  }

  @override
  String ng_board_linked_parent(String task) {
    return 'تم ربط المهمة الأم $task';
  }

  @override
  String ng_board_unlinked_parent(String task) {
    return 'تمت إزالة الربط بالمهمة الأم $task';
  }

  @override
  String get ng_board_task_load_failed => 'تعذّر تحميل المهمة';

  @override
  String get ng_board_refresh_task => 'تحديث المهمة';

  @override
  String get ng_board_tab_overview => 'نظرة عامة';

  @override
  String get ng_board_tab_comments => 'التعليقات والروابط';

  @override
  String get ng_board_tab_runs => 'عمليات التشغيل والسجل';

  @override
  String get ng_board_tab_events => 'الأحداث';

  @override
  String get ng_board_decompose => 'تقسيم';

  @override
  String get ng_board_attach => 'إرفاق ملف';

  @override
  String ng_board_estimate_task(
    String complexity,
    String tokens,
    String rationale,
  ) {
    return 'التقدير: $complexity · ~$tokens رمز ($rationale) — ليس تقديرًا للتكلفة بالدولار.';
  }

  @override
  String get ng_board_no_rationale => 'بلا مبرر';

  @override
  String get ng_board_status => 'الحالة';

  @override
  String get ng_board_assignee => 'المكلّف';

  @override
  String get ng_board_title_label => 'العنوان';

  @override
  String get ng_board_body => 'النص / المواصفات';

  @override
  String get ng_board_save_changes => 'حفظ التغييرات';

  @override
  String get ng_board_clear_model => 'مسح تجاوز النموذج';

  @override
  String ng_board_blocked_reason(String reason) {
    return 'سبب الحظر: $reason';
  }

  @override
  String ng_board_result(String result) {
    return 'النتيجة: $result';
  }

  @override
  String ng_board_parents(String count) {
    return 'محظورة بواسطة (المهام الأم · $count)';
  }

  @override
  String get ng_board_add_parent => '+ إضافة مهمة أم';

  @override
  String ng_board_children(String count) {
    return 'تحظر (المهام الفرعية · $count)';
  }

  @override
  String ng_board_attachments(String count) {
    return 'المرفقات ($count)';
  }

  @override
  String get ng_board_worker => 'العامل';

  @override
  String ng_board_comments(String count) {
    return 'التعليقات ($count)';
  }

  @override
  String get ng_board_comment_hint => 'أضف تعليقًا / إرشادات للعامل';

  @override
  String get ng_board_post_comment => 'نشر التعليق';

  @override
  String get ng_board_comment_requeue => 'تعليق وإعادة إلى قائمة الانتظار';

  @override
  String ng_board_runs(String count) {
    return 'عمليات التشغيل ($count)';
  }

  @override
  String get ng_board_no_runs => 'لم تُسجَّل أي عمليات تشغيل للعمّال بعد.';

  @override
  String ng_board_run_error(String error) {
    return 'خطأ: $error';
  }

  @override
  String ng_board_log_tail_truncated(String bytes) {
    return 'نهاية سجل العامل ($bytes بايت، مقتطع)';
  }

  @override
  String ng_board_log_tail(String bytes) {
    return 'نهاية سجل العامل ($bytes بايت)';
  }

  @override
  String get ng_board_refresh_log => 'تحديث السجل';

  @override
  String get ng_board_no_log => 'لا توجد مخرجات لسجل العامل.';

  @override
  String get ng_board_no_events => 'لم تُسجَّل أي أحداث.';

  @override
  String get ng_bots_room_unknown => 'غير معروف';

  @override
  String get ng_bots_room_blocked => 'محظورة';

  @override
  String get ng_bots_room_working => 'قيد العمل';

  @override
  String get ng_bots_room_running => 'قيد التشغيل';

  @override
  String get ng_bots_room_idle => 'خاملة';

  @override
  String ng_board_run_title(String id, String profile, String outcome) {
    return 'التشغيل رقم $id · @$profile · $outcome';
  }

  @override
  String get ng_bots_new_bot => 'بوت جديد';

  @override
  String get ng_bots_new_bot_hint =>
      'زميل فريق مُسمّى له ذاكرته ومهاراته ومحادثته الخاصة، ويمكنه مراسلة وكلائك الآخرين.';

  @override
  String get ng_bots_field_name => 'الاسم';

  @override
  String get ng_bots_field_title => 'العنوان';

  @override
  String get ng_bots_field_description => 'الوصف';

  @override
  String get ng_bots_description_hint => 'بمَ يجب أن يساعد هذا البوت؟';

  @override
  String get ng_bots_name_invalid =>
      'استخدم أحرفًا صغيرة أو أرقامًا أو شرطات أو شرطات سفلية، وابدأ بحرف أو رقم (64 حرفًا على الأكثر).';

  @override
  String ng_bots_name_taken(String name) {
    return 'يوجد وكيل باسم “$name” بالفعل.';
  }

  @override
  String ng_bots_profile_id(String id) {
    return 'معرّف الملف الشخصي: $id';
  }

  @override
  String get ng_bots_advanced =>
      'متقدم — النموذج والمهارات ومجموعات الأدوات وSOUL.md';

  @override
  String get ng_bots_clone_from => 'استنساخ من ملف شخصي';

  @override
  String get ng_bots_clone_main => 'الملف الرئيسي (default)';

  @override
  String get ng_bots_fresh_profile => 'ملف جديد (مهارات مضمّنة)';

  @override
  String get ng_bots_create_empty => 'إنشاء فارغ (تخطي المهارات المضمّنة)';

  @override
  String get ng_bots_share_keys => 'مشاركة المفاتيح والحسابات مع الملف الرئيسي';

  @override
  String get ng_bots_provider => 'المزوّد';

  @override
  String get ng_bots_model => 'النموذج';

  @override
  String get ng_bots_model_pair => 'أدخل المزوّد والنموذج معًا.';

  @override
  String get ng_bots_soul => 'SOUL.md (اختياري — يستبدل الشخصية المُنشأة)';

  @override
  String get ng_bots_soul_edit => 'SOUL.md';

  @override
  String get ng_bots_creating => 'جارٍ الإنشاء…';

  @override
  String get ng_bots_create_bot => 'إنشاء البوت';

  @override
  String ng_bots_created(String name) {
    return 'تم إنشاء البوت “$name”';
  }

  @override
  String get ng_bots_look_failed =>
      'لم يُحفظ مظهره على البوابة؛ اضبطه من تعديل الملف الشخصي.';

  @override
  String ng_bots_request_failed(String reason) {
    return 'لم تقبل البوابة الطلب ($reason).';
  }

  @override
  String get ng_bots_avatar_shape => 'الشكل';

  @override
  String ng_bots_avatar_shape_n(int n) {
    return 'الشكل $n';
  }

  @override
  String get ng_bots_avatar_colour => 'اللون';

  @override
  String ng_bots_avatar_colour_n(int n) {
    return 'اللون $n';
  }

  @override
  String get ng_bots_avatar_match_name => 'حسب الاسم';

  @override
  String get ng_bots_avatar_upload => 'اختر صورة…';

  @override
  String get ng_bots_avatar_remove => 'إزالة الصورة — استخدام الشكل';

  @override
  String get ng_bots_avatar_too_large =>
      'الصورة كبيرة جدًا (الحد الأقصى 15 ميغابايت).';

  @override
  String get ng_bots_avatar_unreadable => 'تعذّرت قراءة تلك الصورة.';

  @override
  String get ng_bots_edit_profile => 'تعديل الملف الشخصي';

  @override
  String ng_bots_edit_description(String name, String profile) {
    return 'مظهر $name ودوره ($profile).';
  }

  @override
  String ng_bots_advanced_failed(String reason) {
    return 'تعذّر تحميل إعدادات الملف الشخصي ($reason).';
  }

  @override
  String get ng_bots_skills => 'المهارات';

  @override
  String get ng_bots_toolsets => 'مجموعات الأدوات';

  @override
  String get ng_bots_toolsets_hint =>
      'ترك الكل (أو لا شيء) محددًا يُبقي السلوك الافتراضي لمجموعات الأدوات.';

  @override
  String get ng_bots_mcp_servers => 'خوادم MCP';

  @override
  String get ng_bots_saving => 'جارٍ الحفظ…';

  @override
  String get ng_bots_confirm_changes_title => 'حفظ هذه التغييرات؟';

  @override
  String get ng_bots_change_remove_image => 'إزالة صورة البوت';

  @override
  String get ng_bots_change_soul => 'استبدال ملف SOUL.md الخاص به';

  @override
  String ng_bots_change_turn_off(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'إيقاف المهارات أو مجموعات الأدوات أو خوادم MCP: $count',
    );
    return '$_temp0';
  }

  @override
  String ng_bots_updated(String name) {
    return 'تم تحديث $name';
  }

  @override
  String ng_bots_sections_failed(String sections) {
    return 'فشلت بعض الأقسام: $sections';
  }

  @override
  String get ng_bots_model_confirm_title => 'تبديل النموذج؟';

  @override
  String get ng_bots_model_confirm_ok => 'تبديل';

  @override
  String get ng_bots_model_not_switched => 'لم يتم تبديل النموذج.';

  @override
  String get ng_bots_section_new => 'قسم جديد';

  @override
  String get ng_bots_section_new_ellipsis => 'قسم جديد…';

  @override
  String get ng_bots_section_name => 'اسم القسم';

  @override
  String get ng_bots_section_name_hint => 'مثلًا: العملاء';

  @override
  String get ng_bots_section_create => 'إنشاء';

  @override
  String get ng_bots_section_rename => 'إعادة تسمية القسم';

  @override
  String get ng_bots_section_delete => 'حذف القسم';

  @override
  String get ng_bots_section_move_up => 'نقل لأعلى';

  @override
  String get ng_bots_section_move_down => 'نقل لأسفل';

  @override
  String get ng_bots_section_unassigned => 'غير مُصنّف';

  @override
  String ng_bots_section_options(String name) {
    return 'خيارات القسم $name';
  }

  @override
  String get ng_bots_section_empty =>
      'لا بوتات هنا بعد. استخدم «النقل إلى قسم» على أحد البوتات.';

  @override
  String get ng_bots_section_move_to => 'النقل إلى قسم';

  @override
  String get ng_bots_section_remove => 'إزالة من القسم';

  @override
  String ng_bots_section_deleted(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'تم حذف “$name” — نُقل $count من البوتات إلى غير مُصنّف',
      zero: 'تم حذف “$name”',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_undo => 'تراجع';

  @override
  String ng_bots_section_move_failed(String reason) {
    return 'تعذّر نقل البوت ($reason).';
  }

  @override
  String ng_bots_bot_actions(String name) {
    return 'إجراءات $name';
  }

  @override
  String ng_bots_section_toggle(String name) {
    return 'إظهار $name أو إخفاؤه';
  }

  @override
  String
  get release_core_transcript_reader_this_passage_is_no_longer_in_the_loaded =>
      'لم يعد هذا المقطع ضمن الجزء المحمّل من المحادثة.';

  @override
  String get release_core_transcript_reader_loaded_prompts =>
      'الطلبات المحمّلة';

  @override
  String get release_core_transcript_reader_jump_to_latest =>
      'الانتقال إلى أحدث الرسائل';

  @override
  String get release_core_transcript_reader_no_prompts_loaded =>
      'لا توجد طلبات محمّلة';

  @override
  String get release_core_transcript_reader_find_in_loaded_messages =>
      'البحث في الرسائل المحمّلة';

  @override
  String get release_core_transcript_reader_previous_match => 'النتيجة السابقة';

  @override
  String get release_core_transcript_reader_next_match => 'النتيجة التالية';

  @override
  String get release_core_transcript_reader_prompt_timeline =>
      'التسلسل الزمني للطلبات';

  @override
  String get release_core_transcript_reader_close_find => 'إغلاق البحث';

  @override
  String get release_core_session_organisation_organise_chats =>
      'تنظيم المحادثات';

  @override
  String get release_core_session_organisation_show_model_and_usage =>
      'عرض النموذج والاستخدام';

  @override
  String
  get release_core_session_files_view_connection_changed_reopen_files_on_the_new_connection =>
      'تغيّر الاتصال. أعد فتح الملفات عبر الاتصال الجديد.';

  @override
  String
  get release_core_session_files_view_the_connection_or_session_changed_reopen_this_pane =>
      'تغيّر الاتصال أو الجلسة. أعد فتح هذه اللوحة.';

  @override
  String
  get release_core_session_files_view_no_verified_host_working_directory_for_this_session =>
      'لا يوجد مجلد عمل مؤكّد على المضيف لهذه الجلسة.';

  @override
  String
  get release_core_session_files_view_the_gateway_denied_this_operation =>
      'رفضت البوابة هذه العملية.';

  @override
  String
  get release_core_session_files_view_this_gateway_does_not_support_this_operation =>
      'لا تدعم هذه البوابة هذه العملية.';

  @override
  String
  get release_core_session_files_view_the_file_owner_or_working_directory_changed_reload =>
      'تغيّر الملف أو المالك أو مجلد العمل. أعد التحميل والمراجعة.';

  @override
  String
  get release_core_session_files_view_the_gateway_returned_an_unsafe_path_or_invalid =>
      'أعادت البوابة مسارًا غير آمن أو استجابة ملف غير صالحة.';

  @override
  String
  get release_core_session_files_view_workspace_access_requires_a_secure_gateway_connection =>
      'يتطلب الوصول إلى مساحة العمل اتصالًا آمنًا بالبوابة.';

  @override
  String
  get release_core_session_files_view_gateway_unavailable_refresh_to_check_the_current_state =>
      'البوابة غير متاحة. حدّث للتحقق من الحالة الحالية.';

  @override
  String
  get release_core_session_files_view_gateway_operation_could_not_be_confirmed =>
      'تعذّر تأكيد تنفيذ العملية على البوابة.';

  @override
  String get release_core_session_files_view_git_status_unavailable =>
      'حالة Git غير متاحة.';

  @override
  String
  get release_core_session_files_view_change_this_chat_s_working_directory =>
      'هل تريد تغيير مجلد العمل لهذه المحادثة؟';

  @override
  String get release_core_session_files_view_absolute_gateway_directory =>
      'المسار المطلق للمجلد على البوابة';

  @override
  String get release_core_session_files_view_change_directory => 'تغيير المجلد';

  @override
  String get release_core_session_files_view_replace_gateway_file =>
      'هل تريد استبدال الملف على البوابة؟';

  @override
  String
  release_core_session_files_view_only_if_the_file_still_matches_the_version(
    String path,
  ) {
    return '$path\n\nفقط إذا ظل الملف مطابقًا للنسخة التي راجعتها. يحتفظ المضيف المتوافق بالملف المستبدَل لإتاحة استعادته.';
  }

  @override
  String get release_core_session_files_view_save_changes => 'حفظ التغييرات';

  @override
  String
  get release_core_session_files_view_saved_and_verified_on_the_gateway =>
      'تم الحفظ والتحقق على البوابة.';

  @override
  String
  get release_core_session_files_view_guarded_saving_is_unavailable_on_this_gateway_your =>
      'لا يتوفر الحفظ مع التحقق من النسخة على هذه البوابة. ما زالت مسودتك هنا.';

  @override
  String
  release_core_session_files_view_save_was_not_confirmed_your_draft_is_still(
    String reason,
  ) {
    return '$reason لم يُؤكَّد الحفظ. ما زالت مسودتك هنا.';
  }

  @override
  String get release_core_session_files_view_review_current_gateway_version =>
      'مراجعة النسخة الحالية على البوابة';

  @override
  String get release_core_session_files_view_discard_draft_and_reload =>
      'تجاهل المسودة وإعادة التحميل';

  @override
  String get release_core_session_files_view_keep_draft_against_this_version =>
      'الاحتفاظ بالمسودة مع اعتماد هذه النسخة أساسًا';

  @override
  String get release_core_session_files_view_discard_unsaved_edits =>
      'هل تريد تجاهل التعديلات غير المحفوظة؟';

  @override
  String get release_core_session_files_view_keep_editing => 'متابعة التعديل';

  @override
  String get release_core_session_files_view_discard_edits => 'تجاهل التعديلات';

  @override
  String get release_core_session_files_view_remote_working_directory =>
      'مجلد العمل البعيد';

  @override
  String get release_core_session_files_view_change_working_directory =>
      'تغيير مجلد العمل';

  @override
  String get release_core_session_files_view_show_ignored_files =>
      'عرض الملفات المتجاهَلة';

  @override
  String
  get release_core_session_files_view_gateway_does_not_report_ignored_status =>
      'لا توضح البوابة الملفات المتجاهَلة.';

  @override
  String get release_core_session_files_view_no_visible_entries =>
      'لا توجد عناصر ظاهرة';

  @override
  String get release_core_session_files_view_changed => 'معدَّل';

  @override
  String get release_core_session_files_view_ignored => 'متجاهَل';

  @override
  String release_core_session_files_view_actions_for(String name) {
    return 'إجراءات $name';
  }

  @override
  String get release_core_session_files_view_copy_relative_path =>
      'نسخ المسار النسبي';

  @override
  String get release_core_session_files_view_copy_gateway_path =>
      'نسخ المسار على البوابة';

  @override
  String get release_core_session_files_view_attach_folder_reference =>
      'إرفاق مرجع المجلد';

  @override
  String get release_core_session_files_view_attach_file_reference =>
      'إرفاق مرجع الملف';

  @override
  String
  get release_core_session_files_view_preview_truncated_editing_disabled =>
      'المعاينة مقتطعة — التعديل معطّل.';

  @override
  String get release_core_session_files_view_select_lines => 'تحديد أسطر';

  @override
  String get release_core_session_files_view_review_gateway_version =>
      'مراجعة النسخة على البوابة';

  @override
  String get release_core_session_files_view_attach_selected_lines =>
      'إرفاق الأسطر المحدّدة';

  @override
  String get release_core_session_files_view_binary_file_no_text_preview =>
      'ملف ثنائي — لا تتوفر معاينة نصية.';

  @override
  String get release_core_session_files_view_file_source => 'مصدر الملف';

  @override
  String get release_core_session_files_view_close_session_files =>
      'إغلاق ملفات الجلسة';

  @override
  String get release_core_session_files_view_back_to_tree =>
      'العودة إلى الشجرة';

  @override
  String get release_core_session_files_view_session_files => 'ملفات الجلسة';

  @override
  String get release_core_session_files_view_git_review => 'مراجعة Git';

  @override
  String get release_core_session_files_view_refresh_tree => 'تحديث الشجرة';

  @override
  String
  get release_core_gateway_queue_screen_this_connection_changed_reopen_its_chat =>
      'تغيّر هذا الاتصال. أعد فتح محادثته.';

  @override
  String
  get release_core_gateway_queue_screen_disconnected_reconnect_the_chat_then_refresh =>
      'انقطع الاتصال. أعد توصيل المحادثة، ثم حدّث.';

  @override
  String release_core_gateway_queue_screen_gateway_queue_unavailable(
    String reason,
  ) {
    return 'قائمة انتظار البوابة غير متاحة: $reason.';
  }

  @override
  String release_core_gateway_queue_screen_not_confirmed_nothing_was_resent(
    String reason,
  ) {
    return 'لم يُؤكَّد ($reason). لم يُعَد إرسال أي شيء.';
  }

  @override
  String get release_core_gateway_queue_screen_gateway_confirmed_admission =>
      'أكّدت البوابة قبول الطلب.';

  @override
  String
  get release_core_gateway_queue_screen_edited_entry_admitted_at_the_end_of_the =>
      'أُضيف العنصر المعدَّل إلى نهاية قائمة الانتظار.';

  @override
  String get release_core_gateway_queue_screen_discard_unknown_outcome =>
      'هل تريد تجاهل الطلب ذي النتيجة غير المعروفة؟';

  @override
  String get release_core_gateway_queue_screen_remove_this_entry =>
      'هل تريد إزالة هذا العنصر؟';

  @override
  String
  get release_core_gateway_queue_screen_the_lost_turn_will_not_be_retried_waiting =>
      'لن تُعاد محاولة الجولة المفقودة. يمكن الآن تنفيذ الجولات المنتظرة.';

  @override
  String
  get release_core_gateway_queue_screen_if_the_gateway_has_just_started_this_entry =>
      'إذا كانت البوابة قد بدأت للتو معالجة هذا العنصر، فقد تؤدي إزالته إلى إيقاف تلك الجولة.';

  @override
  String get release_core_gateway_queue_screen_keep => 'إبقاء';

  @override
  String get release_core_gateway_queue_screen_discard_and_resume =>
      'تجاهل واستئناف';

  @override
  String get release_core_gateway_queue_screen_remove_entry => 'إزالة العنصر';

  @override
  String
  get release_core_gateway_queue_screen_lost_admission_resolved_it_was_not_resent =>
      'حُسمت حالة القبول التي فُقد تأكيدها؛ لم يُعَد إرسال الطلب.';

  @override
  String get release_core_gateway_queue_screen_gateway_acknowledged_removal =>
      'أكّدت البوابة الإزالة.';

  @override
  String get release_core_gateway_queue_screen_gateway_queue =>
      'قائمة انتظار البوابة';

  @override
  String get release_core_gateway_queue_screen_refresh_queue =>
      'تحديث قائمة الانتظار';

  @override
  String get release_core_gateway_queue_screen_queue_paused_unknown_outcome =>
      'قائمة الانتظار متوقفة مؤقتًا: النتيجة غير معروفة';

  @override
  String
  get release_core_gateway_queue_screen_review_the_lost_admission_before_resuming_nothing_is =>
      'راجع الطلب الذي فُقد تأكيد قبوله قبل الاستئناف. لن يُعَد إرسال أي شيء.';

  @override
  String get release_core_gateway_queue_screen_no_pending_admissions =>
      'لا توجد طلبات بانتظار القبول';

  @override
  String get release_core_gateway_queue_screen_discard => 'تجاهل…';

  @override
  String
  get release_core_gateway_queue_screen_gateway_acknowledged_the_steering_request =>
      'أكّدت البوابة استلام طلب توجيه الجولة.';

  @override
  String get release_core_gateway_queue_screen_steer_running_turn =>
      'توجيه الجولة الجارية';

  @override
  String get release_core_gateway_queue_screen_remove => 'إزالة…';

  @override
  String get release_core_gateway_queue_screen_next_prompt => 'الطلب التالي';

  @override
  String get release_core_gateway_queue_screen_edit_queued_prompt =>
      'تعديل الطلب في قائمة الانتظار';

  @override
  String get release_core_gateway_queue_screen_submit_to_gateway_queue =>
      'الإرسال إلى قائمة انتظار البوابة';

  @override
  String get release_core_gateway_queue_screen_save_at_queue_end =>
      'الحفظ في نهاية قائمة الانتظار';

  @override
  String get release_core_gateway_queue_screen_cancel_edit => 'إلغاء التعديل';

  @override
  String get release_core_git_review_pane_the_git_operation_did_not_complete =>
      'لم تكتمل عملية Git.';

  @override
  String get release_core_git_review_pane_close_git_review =>
      'إغلاق مراجعة Git';

  @override
  String get release_core_git_review_pane_pin_lane => 'تثبيت المسار';

  @override
  String get release_core_git_review_pane_refresh_git_review =>
      'تحديث مراجعة Git';

  @override
  String get release_core_git_review_pane_uncommitted => 'تغييرات غير مثبّتة';

  @override
  String get release_core_git_review_pane_last_turn => 'الجولة الأخيرة';

  @override
  String
  get release_core_git_review_pane_branch_and_last_turn_views_are_read_only =>
      'عرض الفرع والجولة الأخيرة متاح للقراءة فقط.';

  @override
  String get release_core_git_review_pane_mark_head_as_the_turn_baseline =>
      'تعيين HEAD كحالة مرجعية للجولة';

  @override
  String get release_core_git_review_pane_stage_all =>
      'إضافة الكل إلى منطقة التجهيز';

  @override
  String get release_core_git_review_pane_discard_every_uncommitted_change =>
      'هل تريد تجاهل كل التغييرات غير المثبّتة؟';

  @override
  String
  get release_core_git_review_pane_tracked_files_return_to_head_and_untracked_files =>
      'ستعود الملفات المتتبَّعة إلى حالة HEAD، وستُحذف الملفات غير المتتبَّعة في مجلد هذه الجلسة.';

  @override
  String get release_core_git_review_pane_discard => 'تجاهل التغييرات';

  @override
  String get release_core_git_review_pane_discard_all => 'تجاهل الكل';

  @override
  String get release_core_git_review_pane_unstage => 'إزالة من منطقة التجهيز';

  @override
  String get release_core_git_review_pane_stage => 'إضافة إلى منطقة التجهيز';

  @override
  String get release_core_git_review_pane_discard_file => 'تجاهل تغييرات الملف';

  @override
  String release_core_git_review_pane_discard_2(String path) {
    return 'هل تريد تجاهل التغييرات في $path؟';
  }

  @override
  String
  get release_core_git_review_pane_this_restores_the_committed_copy_or_removes_the =>
      'سيؤدي هذا إلى استعادة النسخة المثبّتة أو حذف الملف غير المتتبَّع.';

  @override
  String get release_core_git_review_pane_commit_message => 'رسالة التثبيت';

  @override
  String get release_core_git_review_pane_nothing_in_the_diff_to_summarise =>
      'لا توجد تغييرات في الفروق لتلخيصها.';

  @override
  String get release_core_git_review_pane_generate_message => 'توليد رسالة';

  @override
  String get release_core_git_review_pane_commit => 'تثبيت التغييرات';

  @override
  String get release_core_git_review_pane_commit_and_push =>
      'تثبيت التغييرات ودفعها';

  @override
  String get release_core_git_review_pane_push => 'دفع التغييرات';

  @override
  String get release_core_git_review_pane_create_pull_request =>
      'إنشاء طلب دمج';

  @override
  String get release_core_git_review_pane_pull_request_ready =>
      'طلب الدمج جاهز';

  @override
  String get release_core_git_review_pane_ask_hermes_to_ship =>
      'اطلب من Hermes نشر التغييرات';

  @override
  String get release_core_git_review_pane_gh_is_authenticated_on_this_gateway =>
      'تم تسجيل الدخول إلى gh على هذه البوابة.';

  @override
  String
  get release_core_git_review_pane_install_the_github_cli_gh_and_sign_in =>
      'ثبّت GitHub CLI ‏(gh) وسجّل الدخول لفتح طلبات الدمج';

  @override
  String get release_core_git_review_pane_worktrees => 'أشجار العمل';

  @override
  String get release_core_git_review_pane_main => 'الرئيسية';

  @override
  String release_core_git_review_pane_follow(String branch) {
    return 'هل تريد متابعة الفرع $branch؟';
  }

  @override
  String
  get release_core_git_review_pane_the_session_working_directory_becomes_this_worktree_unless =>
      'سيصبح مجلد عمل الجلسة هو شجرة العمل هذه، ما لم يكن المسار مثبّتًا.';

  @override
  String get release_core_git_review_pane_follow_2 => 'متابعة';

  @override
  String release_core_git_review_pane_remove(String branch) {
    return 'هل تريد إزالة $branch؟';
  }

  @override
  String get release_core_git_review_pane_the_worktree_directory_is_removed =>
      'سيُحذف مجلد شجرة العمل.';

  @override
  String get release_core_git_review_pane_remove_2 => 'إزالة';

  @override
  String get release_core_git_review_pane_new_worktree_name =>
      'اسم شجرة العمل الجديدة';

  @override
  String get release_core_git_review_pane_new_branch => 'فرع جديد';

  @override
  String get release_core_git_review_pane_base_branch => 'الفرع الأساس';

  @override
  String get release_core_git_review_pane_create_worktree => 'إنشاء شجرة عمل';

  @override
  String get release_core_git_review_pane_existing_branch => 'فرع موجود';

  @override
  String get release_core_git_review_pane_convert_branch_to_worktree =>
      'تحويل الفرع إلى شجرة عمل';

  @override
  String get release_core_git_review_pane_switch_branch => 'تبديل الفرع';

  @override
  String
  get release_core_git_review_pane_this_gateway_does_not_support_that_git_operation =>
      'لا تدعم هذه البوابة عملية Git هذه.';

  @override
  String
  get release_core_git_review_pane_git_needs_the_session_directory_on_the_local =>
      'يتطلب Git وجود مجلد الجلسة على محرّك الطرفية المحلي.';

  @override
  String
  get release_core_git_review_pane_the_gateway_refused_the_git_operation =>
      'رفضت البوابة عملية Git.';

  @override
  String
  get release_core_git_review_pane_the_session_changed_refresh_and_try_again =>
      'تغيّرت الجلسة. حدّث ثم حاول مجددًا.';

  @override
  String
  get release_core_git_review_pane_this_review_is_no_longer_the_selected_session =>
      'لم تعد هذه المراجعة تخص الجلسة المحدّدة.';

  @override
  String
  get release_core_git_review_pane_the_gateway_returned_an_unexpected_git_result =>
      'أعادت البوابة نتيجة غير متوقعة من Git.';

  @override
  String
  get release_core_git_review_pane_git_review_requires_the_gateway_transport =>
      'تتطلب مراجعة Git قناة النقل الخاصة بالبوابة.';

  @override
  String get release_core_client_held_queue_bar_resume => 'استئناف';

  @override
  String get release_core_client_held_queue_bar_send_queued_prompt =>
      'إرسال الطلب من قائمة الانتظار';

  @override
  String get release_core_client_held_queue_bar_edit_unsent_prompt =>
      'تعديل الطلب غير المرسَل';

  @override
  String get release_core_client_held_queue_bar_remove_unsent_prompt =>
      'إزالة الطلب غير المرسَل';

  @override
  String get release_core_workspace_discovery_view_repository_discovery =>
      'اكتشاف المستودعات';

  @override
  String get release_core_workspace_discovery_view_refresh_results =>
      'تحديث النتائج';

  @override
  String release_core_workspace_discovery_view_hide(String path) {
    return 'إخفاء $path';
  }

  @override
  String
  get release_core_workspace_discovery_view_invalid_path_or_discovery_data_use_absolute_server =>
      'المسار أو بيانات الاكتشاف غير صالحة. استخدم مسارات مطلقة على الخادم لا تتضمن المكوّنين . أو ..';

  @override
  String
  get release_core_workspace_discovery_view_this_gateway_does_not_support_repository_discovery =>
      'لا تدعم هذه البوابة اكتشاف المستودعات.';

  @override
  String
  get release_core_workspace_discovery_view_the_gateway_denied_access_to_repository_discovery =>
      'رفضت البوابة الوصول إلى اكتشاف المستودعات.';

  @override
  String
  get release_core_workspace_discovery_view_the_connection_changed_reopen_discovery_on_the_current =>
      'تغيّر الاتصال. أعد فتح الاكتشاف على البوابة الحالية.';

  @override
  String
  get release_core_workspace_discovery_view_the_displayed_settings_have_changed_refresh_before_trying =>
      'تغيّرت الإعدادات المعروضة. حدّث قبل المحاولة مجددًا.';

  @override
  String
  get release_core_workspace_discovery_view_could_not_load_or_verify_discovery_settings_refresh =>
      'تعذّر تحميل إعدادات الاكتشاف أو التحقق منها. حدّث للمحاولة مجددًا.';

  @override
  String release_core_workspace_discovery_view_repositories_shown_of(
    int visible,
    int total,
  ) {
    return 'المستودعات المعروضة: $visible من $total';
  }

  @override
  String
  get release_core_workspace_discovery_view_the_gateway_returned_no_repositories =>
      'لم تُرجع البوابة أي مستودعات.';

  @override
  String
  get release_core_workspace_discovery_view_no_repositories_match_your_device_filters =>
      'لا توجد مستودعات تطابق عوامل التصفية على جهازك.';

  @override
  String get release_core_workspace_discovery_view_gateway_scan_policy =>
      'سياسة الفحص على البوابة';

  @override
  String
  get release_core_workspace_discovery_view_this_gateway_did_not_report_a_scan_policy =>
      'لم توضح هذه البوابة سياسة الفحص.';

  @override
  String
  get release_core_workspace_discovery_view_to_scan_folders_configure_repository_scanning_in_the =>
      'لفحص المجلدات، اضبط فحص المستودعات في إعدادات سطح المكتب للملف الشخصي للبوابة.';

  @override
  String
  get release_core_workspace_discovery_view_results_can_include_cached_repositories_and_repositories_with =>
      'قد تتضمن النتائج مستودعات مخزّنة مؤقتًا ومستودعات لها جلسات. لا يضمن الفحص الوصول إلى كل مجلد.';

  @override
  String get release_core_workspace_discovery_view_scan_gateway_roots =>
      'فحص المجلدات الجذرية للبوابة';

  @override
  String
  get release_core_workspace_discovery_view_filter_results_on_this_device =>
      'تصفية النتائج على هذا الجهاز';

  @override
  String
  get release_core_workspace_discovery_view_only_this_discovery_list_changes_not_the_gateway =>
      'يتغيّر فقط هذا السرد لنتائج الاكتشاف، وليس فحص البوابة.';

  @override
  String get release_core_workspace_discovery_view_include_subtrees_empty_all =>
      'تضمين الأشجار الفرعية (فارغ = الكل)';

  @override
  String get release_core_workspace_discovery_view_exclude_subtrees =>
      'استبعاد الأشجار الفرعية';

  @override
  String get release_core_workspace_discovery_view_apply_filters =>
      'تطبيق عوامل التصفية';

  @override
  String release_core_workspace_discovery_view_hidden_repositories(int count) {
    return 'المستودعات المخفية ($count)';
  }

  @override
  String get release_core_workspace_discovery_view_undo_hide =>
      'التراجع عن الإخفاء';

  @override
  String
  get release_core_workspace_discovery_view_one_absolute_server_path_per_line =>
      'مسار مطلق واحد على الخادم في كل سطر';

  @override
  String get release_core_project_settings_view_project_settings =>
      'إعدادات المشروع';

  @override
  String
  get release_core_project_settings_view_the_gateway_did_not_confirm_the_selected_project =>
      'لم تؤكّد البوابة المشروع المحدّد أو التغيير. راجع الإعدادات قبل المحاولة مجددًا.';

  @override
  String
  get release_core_project_settings_view_could_not_verify_these_settings_use_one_absolute =>
      'تعذّر التحقق من هذه الإعدادات. أدخل مسارًا مطلقًا واحدًا لمجلد على الخادم في كل سطر، من دون المكوّنين . أو ..';

  @override
  String get release_core_project_settings_view_set_active => 'تعيين كنشط';

  @override
  String get release_core_project_settings_view_icon => 'الأيقونة';

  @override
  String get release_core_project_settings_view_folder => 'مجلد';

  @override
  String get release_core_project_settings_view_repository => 'مستودع';

  @override
  String get release_core_project_settings_view_rocket => 'صاروخ';

  @override
  String get release_core_project_settings_view_star => 'نجمة';

  @override
  String get release_core_project_settings_view_book => 'كتاب';

  @override
  String get release_core_project_settings_view_terminal => 'طرفية';

  @override
  String get release_core_project_settings_view_colour => 'اللون';

  @override
  String get release_core_project_settings_view_primary_folder =>
      'المجلد الرئيسي';

  @override
  String get release_core_project_settings_view_server_folder_paths =>
      'مسارات المجلدات على الخادم';

  @override
  String
  get release_core_project_settings_view_one_absolute_path_per_line_existing_folders_are =>
      'مسار مطلق واحد في كل سطر. تُحفَظ المجلدات الموجودة.';

  @override
  String get release_core_project_settings_view_add_folders => 'إضافة مجلدات';

  @override
  String release_core_project_settings_view_choose(String label) {
    return 'اختيار $label';
  }

  @override
  String
  get release_core_prepared_image_recovery_wait_for_an_empty_draft_before_restoring =>
      'انتظر حتى تصبح المسودة فارغة قبل الاستعادة.';

  @override
  String
  get release_core_prepared_image_recovery_no_unacknowledged_image_drafts_in_this_chat =>
      'لا توجد في هذه المحادثة مسودات صور لم يُؤكَّد استلامها.';

  @override
  String get release_core_prepared_image_recovery_unacknowledged_image_drafts =>
      'مسودات صور لم يُؤكَّد استلامها';

  @override
  String
  get release_core_prepared_image_recovery_the_gateway_may_already_have_received_these_restore =>
      'ربما استلمتها البوابة بالفعل. استعدها للمراجعة؛ لن يُرسَل أي شيء.';

  @override
  String get release_core_prepared_image_recovery_image_draft => 'مسودة صورة';

  @override
  String get release_core_prepared_image_recovery_discard_local_copy =>
      'تجاهل النسخة المحلية';

  @override
  String
  get release_core_prepared_image_recovery_discard_this_local_image_draft =>
      'هل تريد تجاهل مسودة الصورة المحلية هذه؟';

  @override
  String
  get release_core_prepared_image_recovery_image_draft_recovery_is_unavailable =>
      'استعادة مسودات الصور غير متاحة.';

  @override
  String get release_core_prepared_image_recovery_recover_image_draft =>
      'استعادة مسودة صورة…';

  @override
  String get release_core_session_search_mode_menu_could_not_save_search_mode =>
      'تعذّر حفظ وضع البحث.';

  @override
  String get release_core_projects_pane_discover_repositories =>
      'اكتشاف المستودعات';

  @override
  String
  get release_core_projects_pane_project_created_but_the_gateway_did_not_confirm =>
      'أُنشئ المشروع، لكن البوابة لم تؤكّد فكرته.';

  @override
  String get release_core_projects_pane_project_idea_optional =>
      'فكرة المشروع (اختياري)';

  @override
  String
  get release_core_projects_pane_saved_in_the_project_description_not_a_file =>
      'تُحفَظ في وصف المشروع، وليس في ملف.';

  @override
  String get release_core_project_detail_screen_new_chat_in_this_lane =>
      'محادثة جديدة في هذا المسار';

  @override
  String get release_core_project_detail_screen_review_git => 'مراجعة Git';

  @override
  String get release_core_more_pane_gateway_fleet => 'مجموعة البوابات';

  @override
  String
  get release_core_more_pane_connected_sessions_hermes_cloud_and_desktop_webapp =>
      'الجلسات المتصلة وHermes Cloud وتطبيق سطح المكتب على الويب';

  @override
  String get release_core_more_pane_use_dashboard_sign_in_for_a_named_profile =>
      'استخدم تسجيل الدخول عبر لوحة التحكم لملف شخصي مسمّى. لا تستطيع واجهة API القديمة هذه تأكيد الملف الشخصي الذي يملك سجل المحادثة.';

  @override
  String get release_core_more_pane_capabilities => 'الإمكانات';

  @override
  String
  get release_core_more_pane_install_and_govern_skills_plugins_connectors_and_tool =>
      'تثبيت المهارات والملحقات والموصّلات ومحرّكات الأدوات وإدارتها';

  @override
  String get release_core_more_pane_browser_vault => 'خزنة المتصفح';

  @override
  String
  get release_core_more_pane_site_logins_addresses_cards_and_credential_sources =>
      'بيانات الدخول إلى المواقع والعناوين والبطاقات ومصادر بيانات الاعتماد';

  @override
  String get release_core_more_pane_agent_policy => 'سياسة الوكيل';

  @override
  String
  get release_core_more_pane_approvals_checkpoints_browser_access_and_shared_metrics =>
      'الموافقات ونقاط التحقق والوصول إلى المتصفح والمقاييس المشتركة';

  @override
  String get release_core_more_pane_remote_logs_health_maintenance_and_update =>
      'السجلات البعيدة والحالة والصيانة والتحديث';

  @override
  String get release_core_more_pane_schedules => 'الجداول';

  @override
  String get release_core_more_pane_all_profiles_blueprints_catch_up_and_stop =>
      'جميع الملفات الشخصية والقوالب وتعويض التشغيل الفائت والإيقاف';

  @override
  String get release_core_more_pane_memory_graph => 'رسم الذاكرة البياني';

  @override
  String get release_core_more_pane_timeline_edits_and_memory_providers =>
      'التسلسل الزمني والتعديلات ومزوّدو الذاكرة';

  @override
  String get release_core_more_pane_providers_and_routes =>
      'المزوّدون والمسارات';

  @override
  String get release_core_more_pane_keys_endpoints_delegation_and_mixtures =>
      'المفاتيح ونقاط الاتصال والتفويض ومزيج النماذج';

  @override
  String get release_core_more_pane_credits_and_plans => 'الأرصدة والخطط';

  @override
  String
  get release_core_more_pane_consented_nous_billing_when_the_account_allows_it =>
      'إدارة فوترة Nous بموافقتك عندما يسمح الحساب بذلك';

  @override
  String
  get release_core_fleet_screen_this_gateway_does_not_offer_this_service =>
      'لا توفّر هذه البوابة هذه الخدمة.';

  @override
  String
  get release_core_fleet_screen_sign_in_or_permission_required_on_this_gateway =>
      'يلزم تسجيل الدخول أو الحصول على إذن على هذه البوابة.';

  @override
  String get release_core_fleet_screen_a_secure_gateway_address_is_required =>
      'يلزم عنوان آمن للبوابة.';

  @override
  String
  get release_core_fleet_screen_the_owner_changed_refresh_before_continuing =>
      'تغيّر المالك. حدّث قبل المتابعة.';

  @override
  String
  get release_core_fleet_screen_could_not_verify_the_operation_check_the_gateway =>
      'تعذّر التحقق من تنفيذ العملية. تحقّق من البوابة ثم حدّث.';

  @override
  String get release_core_fleet_screen_verified_ssh => 'SSH موثَّق';

  @override
  String
  get release_core_fleet_screen_confirm_a_host_key_inspect_a_remote_service =>
      'تأكيد مفتاح المضيف أو فحص خدمة بعيدة أو فتح صدفتها';

  @override
  String get release_core_fleet_screen_cloud_and_desktop_webapp =>
      'السحابة وتطبيق سطح المكتب على الويب';

  @override
  String get release_core_fleet_screen_register_an_existing_gateway_or_webapp =>
      'تسجيل بوابة أو تطبيق ويب موجود';

  @override
  String
  get release_core_fleet_screen_sign_in_to_its_address_nothing_is_hosted =>
      'سجّل الدخول عبر عنوانه. لا يُستضاف أي شيء على هذا الجهاز.';

  @override
  String get release_core_fleet_screen_fleet_updates =>
      'تحديثات مجموعة البوابات';

  @override
  String get release_core_fleet_screen_refresh_roster => 'تحديث قائمة البوابات';

  @override
  String release_core_fleet_screen_disconnect(String gateway) {
    return 'قطع الاتصال بـ $gateway';
  }

  @override
  String get release_core_fleet_screen_open_this_gateway_on_launch =>
      'فتح هذه البوابة عند بدء التشغيل';

  @override
  String
  get release_core_fleet_screen_primary_for_ares_does_not_change_the_last =>
      'البوابة الرئيسية لـ Ares؛ لا يغيّر ذلك آخر بوابة مستخدمة.';

  @override
  String get release_core_fleet_screen_reconnect_in_fleet_on_launch =>
      'إعادة الاتصال ضمن مجموعة البوابات عند بدء التشغيل';

  @override
  String get release_core_fleet_screen_no_sessions_for_this_profile =>
      'لا توجد جلسات لهذا الملف الشخصي.';

  @override
  String get release_core_fleet_screen_more_sessions => 'مزيد من الجلسات';

  @override
  String get release_core_fleet_screen_this_gateway_was_disconnected =>
      'قُطع الاتصال بهذه البوابة.';

  @override
  String
  get release_core_fleet_screen_some_conversation_data_could_not_be_loaded =>
      'تعذّر تحميل بعض بيانات المحادثة.';

  @override
  String get release_core_fleet_screen_message_this_session =>
      'مراسلة هذه الجلسة';

  @override
  String get release_core_fleet_screen_send_to_this_session =>
      'الإرسال إلى هذه الجلسة';

  @override
  String get release_core_fleet_updates_screen_update_these_remote_gateways =>
      'هل تريد تحديث هذه البوابات البعيدة؟';

  @override
  String
  release_core_fleet_updates_screen_this_can_restart_the_backend_and_interrupt_other(
    String gateways,
  ) {
    return 'قد يؤدي هذا إلى إعادة تشغيل الخدمة الخلفية ومقاطعة المستخدمين الآخرين. لن يُحدَّث Ares.\n\n$gateways';
  }

  @override
  String get release_core_fleet_updates_screen_update_listed_gateways =>
      'تحديث البوابات المدرجة';

  @override
  String
  get release_core_fleet_updates_screen_checks_connected_gateways_cloud_is_platform_managed_entries =>
      'يفحص البوابات المتصلة. تتولى المنصة إدارة السحابة؛ تُستبعد العناصر التي لا يتوفر توثيق لمصدر تسجيلها.';

  @override
  String get release_core_fleet_updates_screen_check_connected_gateways =>
      'فحص البوابات المتصلة';

  @override
  String get release_core_fleet_updates_screen_read_update_receipt =>
      'قراءة إيصال التحديث';

  @override
  String get release_core_fleet_updates_screen_review_eligible_updates =>
      'مراجعة التحديثات المؤهَّلة';

  @override
  String
  get release_core_fleet_webapp_screen_account_changed_reopen_this_page =>
      'تغيّر الحساب. أعد فتح هذه الصفحة.';

  @override
  String
  get release_core_fleet_webapp_screen_set_the_webapp_s_primary_gateway =>
      'هل تريد تعيين البوابة الرئيسية لتطبيق الويب؟';

  @override
  String
  release_core_fleet_webapp_screen_this_changes_the_shared_registry_not_the_last(
    String webapp,
    String gateway,
    String id,
  ) {
    return '$webapp → $gateway ($id)\nيغيّر هذا السجل المشترك، وليس آخر بوابة مستخدمة.';
  }

  @override
  String get release_core_fleet_webapp_screen_set_primary => 'تعيين كرئيسي';

  @override
  String get release_core_fleet_webapp_screen_serving_profile =>
      'الملف الشخصي الذي يقدّم الخدمة';

  @override
  String get release_core_fleet_webapp_screen_hermes_cloud => 'Hermes Cloud';

  @override
  String get release_core_fleet_webapp_screen_discover_signed_in_agents =>
      'اكتشاف الوكلاء المسجّلين دخولهم';

  @override
  String release_core_fleet_webapp_screen_organisation(String organisation) {
    return 'المؤسسة: $organisation';
  }

  @override
  String get release_core_fleet_webapp_screen_no_agents_available =>
      'لا يوجد وكلاء متاحون.';

  @override
  String get release_core_fleet_webapp_screen_existing_desktop_webapp =>
      'تطبيق سطح مكتب موجود على الويب';

  @override
  String
  get release_core_fleet_webapp_screen_check_gateway_and_web_access_status =>
      'فحص حالة البوابة والوصول عبر الويب';

  @override
  String
  get release_core_fleet_webapp_screen_these_settings_belong_to_the_machine_serving_this =>
      'تخص هذه الإعدادات الجهاز الذي يقدّم تطبيق الويب هذا. النشر وإعادة التشغيل ليسا إجراءين عن بُعد.';

  @override
  String get release_core_fleet_webapp_screen_read_webapp_gateway_registry =>
      'قراءة سجل بوابات تطبيق الويب';

  @override
  String get release_core_fleet_webapp_screen_last_used => 'آخر استخدام';

  @override
  String get release_core_fleet_webapp_screen_primary => 'الرئيسي';

  @override
  String release_core_fleet_webapp_screen_set_primary_2(String gateway) {
    return 'تعيين كرئيسي: $gateway';
  }

  @override
  String get release_core_fleet_webapp_screen_read_shared_display_preferences =>
      'قراءة تفضيلات العرض المشتركة';

  @override
  String
  get release_core_fleet_webapp_screen_chat_text_direction_on_this_webapp_and_desktop =>
      'اتجاه نص المحادثة في تطبيق الويب هذا وتطبيق سطح المكتب';

  @override
  String release_core_schedule_desk_screen_created_on(
    String job,
    String profile,
  ) {
    return 'أُنشئت المهمة $job في الملف الشخصي $profile.';
  }

  @override
  String
  get release_core_schedule_desk_screen_the_list_covers_every_profile_on_this_gateway =>
      'تشمل القائمة جميع الملفات الشخصية على هذه البوابة. تُرسَل إجراءات الإيقاف والإيقاف المؤقت وتعويض التشغيل الفائت والتسليم والقوالب إلى الملف الشخصي المالك للمهمة.';

  @override
  String get release_core_schedule_desk_screen_a_run_is_in_progress =>
      'هناك تشغيل جارٍ';

  @override
  String get release_core_schedule_desk_screen_no_current_run =>
      'لا يوجد تشغيل حالي';

  @override
  String release_core_schedule_desk_screen_stop_requested_for(String job) {
    return 'طُلب إيقاف المهمة $job.';
  }

  @override
  String release_core_schedule_desk_screen_no_run_was_in_flight_for(
    String job,
  ) {
    return 'لم يكن هناك تشغيل جارٍ للمهمة $job.';
  }

  @override
  String get release_core_schedule_desk_screen_stop_current_run =>
      'إيقاف التشغيل الحالي';

  @override
  String get release_core_schedule_desk_screen_pause_future_runs =>
      'إيقاف عمليات التشغيل المستقبلية مؤقتًا';

  @override
  String get release_core_schedule_desk_screen_resume_future_runs =>
      'استئناف عمليات التشغيل المستقبلية';

  @override
  String get release_core_schedule_desk_screen_catch_up_default =>
      'الإعداد الافتراضي لتعويض التشغيل الفائت';

  @override
  String get release_core_schedule_desk_screen_run_one_missed =>
      'تنفيذ تشغيل فائت واحد';

  @override
  String get release_core_schedule_desk_screen_skip_missed =>
      'تجاوز عمليات التشغيل الفائتة';

  @override
  String get release_core_schedule_desk_screen_blueprint_recipes =>
      'وصفات القوالب';

  @override
  String get release_core_schedule_desk_screen_profile_for_the_new_job =>
      'الملف الشخصي للمهمة الجديدة';

  @override
  String release_core_schedule_desk_screen_create(String blueprint) {
    return 'إنشاء $blueprint';
  }

  @override
  String get release_core_schedule_desk_screen_loading_delivery_targets =>
      'جارٍ تحميل وجهات التسليم';

  @override
  String release_core_schedule_desk_screen_no_home_channel(String target) {
    return '$target (لا توجد قناة رئيسية)';
  }

  @override
  String release_core_memory_graph_screen_edit(String label) {
    return 'تعديل $label';
  }

  @override
  String get release_core_memory_graph_screen_content => 'المحتوى';

  @override
  String get release_core_memory_graph_screen_archive_skill => 'أرشفة المهارة';

  @override
  String get release_core_memory_graph_screen_delete_memory =>
      'حذف معلومة من الذاكرة';

  @override
  String release_core_memory_graph_screen_archive_on_it_can_be_restored_on_the(
    String label,
    String profile,
  ) {
    return 'هل تريد أرشفة $label في الملف الشخصي $profile؟ يمكن استعادته على المضيف باستخدام منسّق المهارات.';
  }

  @override
  String release_core_memory_graph_screen_delete_from_this_removes_that_memory(
    String label,
    String profile,
  ) {
    return 'هل تريد حذف $label من الملف الشخصي $profile؟ ستُحذف هذه المعلومة من الذاكرة.';
  }

  @override
  String get release_core_memory_graph_screen_filter => 'تصفية';

  @override
  String get release_core_memory_graph_screen_timeline => 'التسلسل الزمني';

  @override
  String get release_core_memory_graph_screen_play_timeline =>
      'تشغيل التسلسل الزمني';

  @override
  String get release_core_memory_graph_screen_layout_code => 'رمز التخطيط';

  @override
  String get release_core_memory_graph_screen_external_memory_providers =>
      'مزوّدو الذاكرة الخارجيون';

  @override
  String
  get release_core_memory_graph_screen_a_value_is_stored_leave_blank_to_keep =>
      'توجد قيمة محفوظة. اترك الحقل فارغًا للإبقاء عليها.';

  @override
  String get release_core_memory_graph_screen_save_provider => 'حفظ المزوّد';

  @override
  String release_core_workspace_profiles_screen_applies_to(String profile) {
    return 'يسري على: $profile';
  }

  @override
  String get release_core_workspace_profiles_screen_choose_another_profile =>
      'اختيار ملف شخصي آخر';

  @override
  String
  get release_core_workspace_profiles_screen_could_not_verify_the_selected_profile_on_this =>
      'تعذّر التحقق من الملف الشخصي المحدّد على هذه البوابة.';

  @override
  String get release_core_workspace_profiles_screen_create_profile =>
      'إنشاء ملف شخصي';

  @override
  String get release_core_workspace_profiles_screen_new_profile_id =>
      'معرّف الملف الشخصي الجديد';

  @override
  String get release_core_assets_screen_links => 'الروابط';

  @override
  String get release_core_workspace_picker_no_matching_items =>
      'لا توجد عناصر مطابقة.';

  @override
  String get release_core_workspace_picker_save_layout => 'حفظ التخطيط';

  @override
  String get release_core_workspace_picker_layout_name => 'اسم التخطيط';

  @override
  String
  get release_core_workspace_popout_this_chat_already_has_a_pop_out_window =>
      'توجد بالفعل نافذة مستقلة لهذه المحادثة.';

  @override
  String
  get release_core_workspace_popout_could_not_open_this_saved_chat_check_the =>
      'تعذّر فتح هذه المحادثة المحفوظة. تحقّق من الاتصال ثم حاول مجددًا.';

  @override
  String
  get release_core_popout_bootstrap_use_the_main_window_to_change_your_connection =>
      'استخدم النافذة الرئيسية لتغيير الاتصال.';

  @override
  String get release_core_guarded_save_refused =>
      'لا يمكن للبوابة حفظ هذا الملف';

  @override
  String get release_core_guarded_save_unavailable =>
      'لا يتوفر الحفظ مع التحقق من النسخة على هذه البوابة';

  @override
  String release_core_git_files_changed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عدد الملفات المعدَّلة في هذه الجولة: $count',
      one: 'عُدّل ملف واحد في هذه الجولة',
    );
    return '$_temp0';
  }

  @override
  String release_core_git_entries_omitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عدد عناصر Git المستبعَدة لأن عرضها غير آمن: $count.',
      one: 'حُذف عنصر واحد من Git من العرض لأن عرضه غير آمن.',
    );
    return '$_temp0';
  }

  @override
  String get release_core_git_staged => 'في منطقة التجهيز';

  @override
  String get release_core_session_sort_recent => 'النشاط الأخير';

  @override
  String get release_core_session_sort_created => 'الأحدث إنشاءً';

  @override
  String get release_core_session_sort_status => 'الجارية أولًا';

  @override
  String get release_core_session_sort_tokens => 'الأكثر استهلاكًا للرموز';

  @override
  String get release_core_session_sort_cost => 'الأعلى تكلفة';

  @override
  String get release_core_session_group_standard => 'التجميع الافتراضي';

  @override
  String get release_core_session_group_status => 'التجميع حسب الحالة';

  @override
  String get release_core_session_group_project => 'التجميع حسب المشروع';

  @override
  String release_core_session_tokens(int count) {
    return 'عدد الرموز: $count';
  }

  @override
  String release_core_search_gateway_mode(String mode) {
    return '$mode (البوابة)';
  }

  @override
  String release_core_search_mode_tooltip(String label, String mode) {
    return '$label: $mode';
  }

  @override
  String get release_core_image_recovery_new_turn =>
      'يؤدي الإرسال إلى إنشاء جولة جديدة';

  @override
  String release_core_image_recovery_metadata(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عدد الصور: $count · $date',
      one: 'صورة واحدة · $date',
    );
    return '$_temp0';
  }

  @override
  String release_core_discovery_scanning(String state) {
    return 'الفحص: $state';
  }

  @override
  String get release_core_discovery_enabled => 'مفعّل';

  @override
  String get release_core_discovery_disabled => 'معطّل';

  @override
  String get release_core_discovery_none => 'لا شيء';

  @override
  String release_core_discovery_roots(String paths) {
    return 'المجلدات الجذرية للفحص: $paths';
  }

  @override
  String release_core_discovery_excluded(String paths) {
    return 'الأشجار الفرعية المستبعَدة: $paths';
  }

  @override
  String release_core_discovery_repository_sessions(String path, int count) {
    return '$path\nالجلسات: $count';
  }

  @override
  String get release_core_projects_local_only =>
      'إصدار بوابة Hermes هذه أقدم من ميزة المشاريع على الخادم، لذا يقتصر تجميع المحادثات على هذا الجهاز. حدّث Hermes لاستخدام المشاريع نفسها على جميع أجهزتك.';

  @override
  String get release_core_fleet_no_address => 'لم يُحدَّد عنوان للبوابة بعد';

  @override
  String release_core_fleet_diagnostics(String version, String access) {
    return 'البوابة $version · $access';
  }

  @override
  String get release_core_schedule_builtin => 'مدمج';

  @override
  String get release_core_memory_gateway_profile => 'البوابة';

  @override
  String release_core_memory_profile_summary(String profile, String gateway) {
    return 'الملف الشخصي $profile على البوابة $gateway. لا يحفظ رمز المشاركة سوى التكبير والوقت وعوامل التصفية.';
  }

  @override
  String release_core_memory_layers_summary(
    int memoryBytes,
    int userBytes,
    String provider,
  ) {
    return 'الذاكرة المدمجة: $memoryBytes بايت، وذاكرة المستخدم: $userBytes بايت. المزوّد النشط: $provider.';
  }

  @override
  String get release_core_memory_kind_all => 'الكل';

  @override
  String get release_core_memory_kind_skill => 'المهارات';

  @override
  String get release_core_memory_kind_memory => 'الذاكرة';

  @override
  String get release_core_workspace_failure_stale => 'تغيّر الاتصال';

  @override
  String get release_core_workspace_failure_unbound => 'لا يوجد مجلد عمل مؤكّد';

  @override
  String get release_core_workspace_failure_denied => 'رُفض الإذن';

  @override
  String get release_core_workspace_failure_ineligible =>
      'العملية غير مسموحة لهذا الملف';

  @override
  String get release_core_workspace_failure_unsupported =>
      'غير مدعوم على هذه البوابة';

  @override
  String get release_core_workspace_failure_mismatch => 'تغيّرت الحالة البعيدة';

  @override
  String get release_core_workspace_failure_invalid =>
      'استجابة غير صالحة من البوابة';

  @override
  String get release_core_workspace_failure_insecure => 'يلزم اتصال آمن';

  @override
  String get release_core_workspace_failure_unavailable => 'البوابة غير متاحة';

  @override
  String get release_core_queue_state_queued => 'في قائمة الانتظار';

  @override
  String get release_core_queue_state_started => 'بدأ التنفيذ';

  @override
  String get release_core_queue_state_unknown => 'النتيجة غير معروفة';

  @override
  String get release_core_unknown_state => 'غير معروف';

  @override
  String get release_core_fleet_state_idle => 'غير متصل';

  @override
  String get release_core_fleet_state_connected => 'متصل';

  @override
  String get release_core_fleet_state_reconnecting => 'جارٍ إعادة الاتصال…';

  @override
  String get release_core_fleet_state_sessionExpired => 'تم تسجيل الخروج';

  @override
  String get release_core_fleet_state_failed => 'فشل الاتصال';

  @override
  String release_core_workspace_operation_failed(String reason) {
    return 'تعذّر تأكيد تنفيذ العملية على البوابة: $reason.';
  }

  @override
  String get release_core_workspace_invalid_data =>
      'تعذّر التحقق من البيانات أو المدخلات. راجعها ثم حاول مجددًا.';

  @override
  String
  get release_core_parallel_workspace_layout_changed_in_this_window_but_could_not =>
      'تغيّر التخطيط في هذه النافذة، لكن تعذّر حفظه.';

  @override
  String get release_core_parallel_workspace_first_pane => 'اللوحة الأولى';

  @override
  String get release_core_parallel_workspace_second_pane => 'اللوحة الثانية';

  @override
  String get release_core_parallel_workspace_unavailable_page =>
      'صفحة غير متاحة';

  @override
  String release_core_parallel_workspace_close_a_tab_first_maximum(
    String maximum,
  ) {
    return 'أغلق علامة تبويب أولًا (الحد الأقصى: $maximum).';
  }

  @override
  String get release_core_parallel_workspace_dock_beside_current_pane =>
      'إرساء بجوار اللوحة الحالية';

  @override
  String get release_core_parallel_workspace_add_chat => 'إضافة محادثة';

  @override
  String
  get release_core_parallel_workspace_action_failed_check_the_connection_and_try_again =>
      'فشل الإجراء. تحقّق من الاتصال ثم حاول مجددًا.';

  @override
  String
  get release_core_parallel_workspace_close_a_tab_before_reopening_another =>
      'أغلق علامة تبويب قبل إعادة فتح أخرى.';

  @override
  String release_core_parallel_workspace_replace_layout(String name) {
    return 'هل تريد استبدال التخطيط «$name»؟';
  }

  @override
  String
  get release_core_parallel_workspace_layout_limit_reached_replace_an_existing_layout =>
      'بلغت الحد الأقصى للتخطيطات. استبدل تخطيطًا موجودًا.';

  @override
  String get release_core_parallel_workspace_restore_layout =>
      'استعادة التخطيط';

  @override
  String get release_core_parallel_workspace_workspace_options =>
      'خيارات مساحة العمل';

  @override
  String get release_core_parallel_workspace_dock_another_pane =>
      'إرساء لوحة أخرى';

  @override
  String get release_core_parallel_workspace_swap_panes =>
      'تبديل موضعي اللوحتين';

  @override
  String get release_core_parallel_workspace_undock_second_pane =>
      'فك إرساء اللوحة الثانية';

  @override
  String get release_core_parallel_workspace_arrange_side_by_side =>
      'ترتيب جنبًا إلى جنب';

  @override
  String get release_core_parallel_workspace_arrange_top_to_bottom =>
      'ترتيب من أعلى إلى أسفل';

  @override
  String release_core_parallel_workspace_change_split_size(String percent) {
    return 'تغيير نسبة التقسيم ($percent٪)';
  }

  @override
  String get release_core_parallel_workspace_focus_pane_full_screen =>
      'عرض اللوحة بملء الشاشة';

  @override
  String get release_core_parallel_workspace_open_chat_in_new_window =>
      'فتح المحادثة في نافذة جديدة';

  @override
  String get release_core_parallel_workspace_hide_pane_keep_running =>
      'إخفاء اللوحة (مع استمرار التشغيل)';

  @override
  String get release_core_parallel_workspace_previous_tab =>
      'علامة التبويب السابقة';

  @override
  String get release_core_parallel_workspace_next_tab =>
      'علامة التبويب التالية';

  @override
  String get release_core_parallel_workspace_move_tab_left =>
      'نقل علامة التبويب إلى اليسار';

  @override
  String get release_core_parallel_workspace_move_tab_right =>
      'نقل علامة التبويب إلى اليمين';

  @override
  String get release_core_parallel_workspace_reload_current_tab =>
      'إعادة تحميل علامة التبويب الحالية';

  @override
  String get release_core_parallel_workspace_close_tab => 'إغلاق علامة التبويب';

  @override
  String get release_core_parallel_workspace_close_other_tabs =>
      'إغلاق علامات التبويب الأخرى';

  @override
  String get release_core_parallel_workspace_close_tabs_to_the_right =>
      'إغلاق علامات التبويب إلى اليمين';

  @override
  String get release_core_parallel_workspace_close_all_tabs =>
      'إغلاق جميع علامات التبويب';

  @override
  String get release_core_parallel_workspace_reopen_closed_tab =>
      'إعادة فتح علامة التبويب المغلقة';

  @override
  String get release_core_parallel_workspace_save_named_layout =>
      'حفظ تخطيط باسم';

  @override
  String get release_core_parallel_workspace_restore_named_layout =>
      'استعادة تخطيط مسمّى';

  @override
  String get release_core_parallel_workspace_refresh_chat_list =>
      'تحديث قائمة المحادثات';

  @override
  String get release_core_parallel_workspace_workspace_tools =>
      'أدوات مساحة العمل';

  @override
  String get release_core_parallel_workspace_choose_a_chat_for_this_pane =>
      'اختر محادثة لهذه اللوحة';

  @override
  String release_core_parallel_workspace_choose_chat_for(String pane) {
    return 'اختيار محادثة للوحة $pane';
  }

  @override
  String get release_core_parallel_workspace_add_a_chat_to_start_a_workspace =>
      'أضف محادثة لبدء مساحة عمل.';

  @override
  String get release_core_parallel_workspace_select_a_tab_to_show_its_pane =>
      'حدّد علامة تبويب لعرض لوحتها.';

  @override
  String get release_core_parallel_workspace_parallel_workspace =>
      'مساحة عمل متوازية';

  @override
  String get release_core_parallel_workspace_show_workspace =>
      'عرض مساحة العمل';

  @override
  String get release_core_parallel_workspace_could_not_load_chats_retry =>
      'تعذّر تحميل المحادثات. إعادة المحاولة';

  @override
  String release_core_parallel_workspace_close(String pane) {
    return 'إغلاق $pane';
  }

  @override
  String release_core_parallel_workspace_switch_pane(String pane) {
    return 'تبديل اللوحة: $pane';
  }

  @override
  String get release_core_workspace_registry_session_id_copied =>
      'نُسخ معرّف الجلسة.';

  @override
  String get release_core_workspace_registry_chat_details => 'تفاصيل المحادثة';

  @override
  String get release_core_workspace_registry_server_default =>
      'الإعداد الافتراضي للخادم';

  @override
  String get release_core_workspace_registry_session_id => 'معرّف الجلسة';

  @override
  String get release_core_workspace_registry_title => 'العنوان';

  @override
  String get release_core_workspace_label_terminals => 'الطرفيات';

  @override
  String get release_core_workspace_label_copy_id => 'نسخ معرّف الجلسة';

  @override
  String get release_core_workspace_label_contributions => 'المساهمات';

  @override
  String get release_core_workspace_owner_inactive =>
      'لم يعد مالك مساحة العمل هذه نشطًا.';

  @override
  String get release_core_workspace_select_chat => 'حدّد محادثة أولًا.';

  @override
  String get release_core_workspace_chat_unavailable =>
      'هذه المحادثة غير متاحة لهذا الاتصال.';

  @override
  String get release_core_workspace_page_unavailable =>
      'هذه الصفحة غير متاحة لهذا الاتصال.';

  @override
  String release_core_client_queue_count(int count) {
    return 'في قائمة الانتظار: $count';
  }

  @override
  String release_core_client_queue_paused_count(int count) {
    return 'في قائمة الانتظار: $count — متوقفة مؤقتًا';
  }

  @override
  String release_core_git_diff_truncated(String diff) {
    return '$diff\n… مقتطع';
  }

  @override
  String get release_core_search_no_models =>
      'لم يُرجع Hermes أي نماذج مضبوطة يمكن اختيارها.';

  @override
  String get release_core_chat_archive_unavailable =>
      'إجراء أرشفة المحادثة غير متاح.';

  @override
  String get release_core_chat_pin_unconfirmed => 'لم تُؤكَّد حالة التثبيت.';

  @override
  String get release_core_chat_archive_unconfirmed =>
      'لم تُؤكَّد حالة الأرشفة.';

  @override
  String get release_core_chat_archive_history_unavailable =>
      'السجل المؤرشف غير متاح';

  @override
  String get release_core_quick_chat_history_unavailable =>
      'سجل المحادثات السريعة غير متاح';

  @override
  String get release_core_chat_project_ownership_unavailable =>
      'معلومات ملكية المشروع غير متاحة';

  @override
  String get release_core_chat_unknown_project => 'مشروع غير معروف';

  @override
  String get release_core_chat_local_search_fallback =>
      'البحث في الرسائل غير متاح. تُعرض النتائج المحلية المطابقة.';

  @override
  String release_core_fleet_update_eligible(String version) {
    return 'مؤهَّل للتحديث · $version';
  }

  @override
  String get release_core_fleet_update_state_1 => 'تم التجاوز: التثبيت نفسه';

  @override
  String get release_core_fleet_update_state_2 => 'لم يُفحص';

  @override
  String get release_core_fleet_update_state_3 => 'تم التجاوز: تديره السحابة';

  @override
  String get release_core_fleet_update_state_4 =>
      'تم التجاوز: غير مسجّل كبوابة مباشرة';

  @override
  String get release_core_fleet_update_state_5 =>
      'تم التجاوز: غير متصل أو مشغول';

  @override
  String get release_core_fleet_update_state_6 => 'لا يوجد تحديث مناسب';

  @override
  String get release_core_fleet_update_state_7 =>
      'تعذّر التحقق من أهلية التحديث';

  @override
  String get release_core_fleet_update_state_8 =>
      'تم التجاوز: البيانات قديمة أو البوابة مشغولة أو أُرسل الطلب بالفعل';

  @override
  String get release_core_fleet_update_state_9 => 'جارٍ إرسال الطلب';

  @override
  String get release_core_fleet_update_state_10 => 'مقبول؛ الإيصال غير متاح';

  @override
  String get release_core_fleet_update_state_11 => 'مقبول؛ بانتظار الإيصال';

  @override
  String get release_core_fleet_update_state_12 =>
      'تم التجاوز: هناك محادثة جارية على هذا التثبيت';

  @override
  String get release_core_fleet_update_state_13 =>
      'غير مؤكَّد؛ لا تُعِد الإرسال تلقائيًا';

  @override
  String get release_core_fleet_update_state_14 =>
      'أعد الاتصال للتحقق من الإيصال';

  @override
  String get release_core_fleet_update_state_15 => 'الإيصال غير متاح';

  @override
  String get release_core_fleet_update_state_16 => 'بانتظار الإيصال المطابق';

  @override
  String get release_core_fleet_update_state_17 => 'تم التحديث؛ تلزم متابعة';

  @override
  String get release_core_fleet_update_state_19 => 'تم التحديث جزئيًا';

  @override
  String get release_core_fleet_update_state_20 => 'فشل التحديث';

  @override
  String get release_core_fleet_update_state_21 => 'غير مؤكَّد';

  @override
  String get release_core_cloud_status_ready => 'جاهز';

  @override
  String get release_core_cloud_status_online => 'متصل';

  @override
  String get release_core_cloud_status_stopped => 'متوقف';

  @override
  String get release_core_cloud_status_error => 'خطأ';

  @override
  String get ng_release_more_contributions_subtitle =>
      'بطاقات الردود المراجَعة لهذا الاتصال';

  @override
  String get ng_release_more_gateway_fleet => 'مجموعة البوابات';

  @override
  String get ng_release_more_memory_graph => 'رسم الذاكرة البياني';

  @override
  String get ng_release_more_memory_graph_subtitle =>
      'التسلسل الزمني والتعديلات ومزوّدو الذاكرة';

  @override
  String get ng_release_more_capabilities_subtitle =>
      'تثبيت المهارات والملحقات والموصّلات ومحرّكات الأدوات وإدارتها';

  @override
  String get ng_release_more_browser_vault => 'خزنة المتصفح';

  @override
  String get ng_release_more_browser_vault_subtitle =>
      'بيانات الدخول إلى المواقع والعناوين والبطاقات ومصادر بيانات الاعتماد';

  @override
  String get ng_release_more_agent_policy => 'سياسة الوكيل';

  @override
  String get ng_release_more_agent_policy_subtitle =>
      'الموافقات ونقاط التحقق والوصول إلى المتصفح والمقاييس المشتركة';

  @override
  String get ng_release_more_schedules => 'الجداول';

  @override
  String get ng_release_more_schedules_subtitle =>
      'جميع الملفات الشخصية والقوالب وتعويض التشغيل الفائت والإيقاف';

  @override
  String get ng_release_more_host_subtitle =>
      'السجلات البعيدة والحالة والصيانة والتحديث';

  @override
  String get ng_release_more_providers_routes => 'المزوّدون والمسارات';

  @override
  String get ng_release_more_providers_routes_subtitle =>
      'المفاتيح ونقاط الاتصال والتفويض ومزيج النماذج';

  @override
  String get ng_release_more_credits_plans => 'الأرصدة والخطط';

  @override
  String get ng_release_more_credits_plans_subtitle =>
      'إدارة فوترة Nous بموافقتك عندما يسمح الحساب بذلك';

  @override
  String get ng_release_sign_in_or => 'أو';

  @override
  String ng_release_deployment_sign_in_hint(String message) {
    return '$message لا يزال بإمكانك تسجيل الدخول برمز جلسة النشر في الخطوة التالية.';
  }

  @override
  String get ng_release_message_search_unavailable =>
      'البحث في الرسائل غير متاح. تُعرض النتائج المحلية المطابقة.';

  @override
  String ng_release_insights_days(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'عدد الأيام: $days',
      one: '$days يوم',
    );
    return '$_temp0';
  }

  @override
  String get ng_release_signed_in_you => 'أنت';

  @override
  String get release_chat_unsent_prompt_gone =>
      'لم يعد ذلك الطلب غير المرسَل في قائمة الانتظار.';

  @override
  String ng_release_attachment_not_attached(String name) {
    return 'لم تُرفق البوابة $name.';
  }

  @override
  String get ng_release_gateway_not_connected => 'لم يتم الاتصال بالبوابة بعد.';

  @override
  String get ng_release_gateway_unreachable => 'تعذّر الوصول إلى البوابة.';

  @override
  String get ng_release_projects_scope_changed =>
      'لم يعد نطاق المشاريع محدّدًا';

  @override
  String get ng_release_missing_providers => 'مزوّدون مفقودون';

  @override
  String get ng_release_missing_tasks => 'مهام مفقودة';

  @override
  String ng_release_age_minutes(int count) {
    return '$count د';
  }

  @override
  String ng_release_age_hours(int count) {
    return '$count س';
  }

  @override
  String ng_release_age_days(int count) {
    return '$count ي';
  }

  @override
  String ng_release_age_weeks(int count) {
    return '$count أ';
  }

  @override
  String ng_release_age_years(int count) {
    return '$count سنة';
  }

  @override
  String ng_release_compact_billions(String count) {
    return '$count مليار';
  }

  @override
  String ng_release_compact_millions(String count) {
    return '$count مليون';
  }

  @override
  String ng_release_compact_thousands(String count) {
    return '$count ألف';
  }

  @override
  String ng_release_token_thousands(String count) {
    return '$count ألف';
  }

  @override
  String ng_release_elapsed_minutes_seconds(int minutes, int seconds) {
    return '$minutes د $seconds ث';
  }

  @override
  String ng_release_elapsed_seconds(int seconds) {
    return '$seconds ث';
  }

  @override
  String get ng_release_notification_foreground => 'كان Ares ظاهرًا على الشاشة';

  @override
  String get ng_release_notification_stopped => 'أُوقفت الجولة';

  @override
  String get ng_release_more_parallel_workspace => 'مساحة عمل متوازية';

  @override
  String get ng_release_more_parallel_workspace_subtitle =>
      'افتح عدة محادثات في علامات تبويب أو جنبًا إلى جنب.';

  @override
  String get release_chat_unknown_model => 'غير معروف';

  @override
  String release_chat_profile_default(String model) {
    return 'الإعداد الافتراضي للملف الشخصي: $model';
  }

  @override
  String release_chat_profile_default_provider(String model, String provider) {
    return 'الإعداد الافتراضي للملف الشخصي: $model • $provider';
  }

  @override
  String get release_chat_choose_provider =>
      'يتوفر هذا النموذج لدى عدة مزوّدين. اختر مزوّدًا للمتابعة.';

  @override
  String get release_chat_slash_needs_gateway =>
      'تتطلب أوامر الشرطة المائلة بوابة سطح المكتب';

  @override
  String get release_chat_recovering_without_resending =>
      'جارٍ الاستعادة من دون إعادة الإرسال';

  @override
  String get release_chat_live_request_unreachable =>
      'عذرًا، تعذّر عليّ الوصول إلى Hermes لتنفيذ هذا الطلب.';

  @override
  String release_chat_live_working(String tool) {
    return 'يعمل Hermes الآن: $tool. لم ينتهِ بعد.';
  }

  @override
  String get release_chat_live_finished_without_spoken_result =>
      'أكمل Hermes هذا الطلب من دون نتيجة منطوقة.';

  @override
  String get release_chat_reply_language_unavailable =>
      'لغة الرد المحدّدة غير متاحة';

  @override
  String get release_chat_reply_voice_unavailable =>
      'الصوت المحدّد للرد غير متاح';

  @override
  String get release_chat_reply_voice_configuration_unavailable =>
      'إعداد صوت الرد غير متاح';

  @override
  String get release_chat_notification_review_action =>
      'افتح المحادثة لمراجعة الإجراء المطلوب.';

  @override
  String get release_chat_notification_respond => 'افتح المحادثة للرد.';

  @override
  String get release_chat_start_new_main_window =>
      'ابدأ محادثة جديدة في النافذة الرئيسية.';

  @override
  String get release_chat_no_desktop_gateway => 'لا توجد بوابة سطح مكتب';

  @override
  String get release_chat_attachment_preparation_cancelled =>
      'أُلغي تجهيز المرفق.';

  @override
  String get release_chat_approval_authority_revoked =>
      'سُحبت صلاحية الموافقة.';

  @override
  String get release_chat_gateway_session_disconnected =>
      'لم تعد جلسة بوابة سطح المكتب متصلة';

  @override
  String get release_chat_stop_requested =>
      'طُلب الإيقاف. بانتظار انتهاء Hermes.';

  @override
  String release_chat_stop_request_failed(String error) {
    return 'تعذّر طلب الإيقاف: $error';
  }

  @override
  String get release_chat_queued_prompt_not_sent =>
      'لم يُرسَل الطلب من قائمة الانتظار.';

  @override
  String get release_chat_running_turn_unreachable =>
      'تعذّر الوصول إلى الجولة الجارية. جارٍ إعادة الاتصال من دون إعادة الإرسال.';

  @override
  String get release_chat_wait_for_composer =>
      'انتظر حتى يصبح محرّر الرسائل متاحًا.';

  @override
  String get release_chat_find_in_transcript => 'البحث في نص المحادثة';

  @override
  String get release_chat_open_browser_preview => 'فتح معاينة المتصفح';

  @override
  String get release_chat_more_tools => 'مزيد من أدوات المحادثة';

  @override
  String get release_chat_queue_until_finished =>
      'إضافة إلى قائمة الانتظار حتى تنتهي هذه الجولة';

  @override
  String get release_chat_format_bold => 'عريض';

  @override
  String get release_chat_format_italic => 'مائل';

  @override
  String get ng_release_chat_gateway_queue_requirements =>
      'تتطلب قائمة انتظار البوابة محادثة مرتبطة وطلبًا نصيًا فقط.';

  @override
  String get ng_release_chat_start_new_main_screen =>
      'ابدأ محادثة جديدة من شاشة المحادثات الرئيسية.';

  @override
  String get ng_release_chat_image => 'صورة';

  @override
  String ng_release_chat_tool_seconds(String seconds) {
    return '$seconds ث';
  }

  @override
  String get release_preview_chat_changed =>
      'تغيّرت المحادثة. أعد توصيل المعاينة للمتابعة.';

  @override
  String get release_preview_authenticating_chat =>
      'جارٍ التحقق من هوية المحادثة…';

  @override
  String release_preview_unavailable_reason(String reason) {
    return 'المعاينة غير متاحة: $reason';
  }

  @override
  String get release_preview_operation_failed => 'فشلت عملية المعاينة.';

  @override
  String get release_preview_added_to_draft =>
      'أُضيف إلى المسودة. لم يُرسَل أي شيء.';

  @override
  String get release_preview_open_site_title => 'هل تريد فتح هذا الموقع؟';

  @override
  String release_preview_open_site_body(String origin) {
    return '$origin\n\nيحمّل وضع القراءة هذا المستند فقط. ولا يشارك ملفات تعريف الارتباط أو بيانات الدخول أو الصفحة مع Hermes.';
  }

  @override
  String get release_preview_open_site => 'فتح الموقع';

  @override
  String get release_preview_discard_pins_title =>
      'هل تريد تجاهل العلامات غير المضافة إلى المسودة؟';

  @override
  String get release_preview_keep_pins => 'إبقاء العلامات';

  @override
  String get release_preview_share_page_title =>
      'هل تريد مشاركة هذه الصفحة مع هذه المحادثة؟';

  @override
  String release_preview_share_page_body(String origin) {
    return 'يمكن لـ Hermes قراءة النص المعروض وقائمة العناصر من $origin، وتمرير هذه اللوحة. ينتهي الإذن بالمشاركة عند الانتقال إلى صفحة أخرى. لا تُشارَك النماذج ولا بيانات الاعتماد.';
  }

  @override
  String get release_preview_share_page => 'مشاركة الصفحة';

  @override
  String release_preview_comment_number(int number) {
    return 'تعليق رقم $number';
  }

  @override
  String get release_preview_note => 'ملاحظة';

  @override
  String get release_preview_keep_pin => 'إبقاء العلامة';

  @override
  String get release_preview_title => 'معاينة المتصفح';

  @override
  String get release_preview_hide => 'إخفاء المعاينة';

  @override
  String get release_preview_close_and_forget => 'إغلاق الصفحة ونسيانها';

  @override
  String get release_preview_site_address => 'عنوان الموقع';

  @override
  String get release_preview_go_to_address => 'الانتقال إلى العنوان';

  @override
  String get release_preview_forward => 'إلى الأمام';

  @override
  String get release_preview_reload => 'إعادة التحميل';

  @override
  String get release_preview_share_with_hermes => 'مشاركة الصفحة مع Hermes';

  @override
  String get release_preview_stop_sharing => 'إيقاف مشاركة الصفحة';

  @override
  String get release_preview_annotate => 'إضافة تعليق على عنصر أو منطقة';

  @override
  String get release_preview_reader_console => 'وحدة تحكم وضع القراءة';

  @override
  String get release_preview_reconnect => 'إعادة توصيل المعاينة';

  @override
  String get release_preview_reader_mode_help =>
      'وضع القراءة: HTML ونص. بلا نصوص برمجية أو موارد مضمّنة أو ملف متصفح مسجّل الدخول.';

  @override
  String release_preview_sharing_origin(String origin) {
    return 'وضع القراءة مشارَك مع هذه المحادثة: $origin';
  }

  @override
  String get release_preview_annotation_help =>
      'اضغط على عنصر أو اسحب لتحديد منطقة لإضافة تعليق.';

  @override
  String get release_preview_reader_requests =>
      'طلبات وضع القراءة (JavaScript معطّل)';

  @override
  String release_preview_selected_requests(int count) {
    return 'المحدّد: $count · JavaScript معطّل';
  }

  @override
  String get release_preview_copy_all => 'نسخ الكل';

  @override
  String get release_preview_copy_selected => 'نسخ المحدّد';

  @override
  String get release_preview_add_log_to_draft => 'إضافة السجل إلى المسودة';

  @override
  String release_preview_requests_draft(String log) {
    return 'طلبات وضع القراءة:\n$log';
  }

  @override
  String release_preview_add_pins_to_draft(int count) {
    return 'إضافة $count إلى المسودة';
  }

  @override
  String release_preview_request_loaded(String origin, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عدد عناصر وضع القراءة: $count',
      one: '$count عنصر في وضع القراءة',
    );
    return 'HTTP 200 · $origin · $_temp0';
  }

  @override
  String release_preview_annotation_intro(String origin) {
    return 'راجع هذه التعليقات على معاينة $origin. رُقّمت اللقطات المقتطعة المرفقة بالترتيب نفسه.';
  }

  @override
  String get release_preview_reader_region => 'منطقة وضع القراءة';

  @override
  String get release_preview_capture_failed => 'تعذّر التقاط هذه البكسلات.';

  @override
  String get release_preview_address_not_approved =>
      'هذا العنوان خارج نطاق المصدر المسموح به للمعاينة.';

  @override
  String get release_preview_page_limit =>
      'تتجاوز الصفحة الحد المسموح به لوضع القراءة.';

  @override
  String get release_preview_page_unreadable => 'تعذّرت قراءة الصفحة.';

  @override
  String get release_preview_page_complex =>
      'هذه الصفحة معقّدة جدًا لوضع القراءة.';

  @override
  String release_preview_http_failed(int statusCode) {
    return 'HTTP $statusCode. لم يُتَّبع أي تحويل ولم يُسجَّل الدخول.';
  }

  @override
  String get release_preview_unsupported_type =>
      'يمكن فتح HTML والنص العادي فقط في وضع القراءة.';

  @override
  String get release_preview_load_insecure => 'تعذّر تحميل الموقع بأمان.';

  @override
  String get release_preview_crop_limit =>
      'تتجاوز لقطة المعاينة المقتطعة الحد المسموح به.';

  @override
  String get release_preview_image_unreadable =>
      'الصورة المحدّدة فارغة أو غير قابلة للقراءة.';

  @override
  String get release_preview_image_budget =>
      'تتجاوز الصورة المحدّدة الحد المسموح به للمسودة والبالغ 64 ميبيبايت.';

  @override
  String get release_preview_image_format =>
      'تنسيق الصورة غير مدعوم. اختر صورة JPEG أو PNG أو WebP.';

  @override
  String get release_preview_image_decode =>
      'تعذّر فك ترميز صورة JPEG أو PNG أو WebP المحدّدة بأمان.';

  @override
  String get release_preview_image_sanitize =>
      'تعذّر تنقية هذه الصورة من المحتوى غير الآمن. اختر صورة JPEG أو PNG أو WebP صالحة.';

  @override
  String get release_preview_draft_budget =>
      'يقتصر الحجم الإجمالي للمرفقات في كل مسودة على 64 ميبيبايت.';

  @override
  String get release_preview_generic_file_limit =>
      'يقتصر حجم كل ملف عام على 16 ميبيبايت.';

  @override
  String get release_preview_image_not_sanitized =>
      'يجب تنقية الصور البعيدة من المحتوى غير الآمن قبل رفعها.';

  @override
  String get release_preview_stage_failed =>
      'تعذّرت إضافة شواهد المعاينة إلى المسودة. حاول مجددًا.';

  @override
  String get release_misc_find_hermes_on_lan =>
      'البحث عن Hermes في الشبكة المحلية';

  @override
  String release_misc_discovery_failed(String error) {
    return 'فشل الاكتشاف: $error';
  }

  @override
  String get release_misc_no_lan_servers =>
      'لم يُعثر على خوادم Hermes في الشبكة المحلية.';

  @override
  String release_misc_api_key_rejected(String endpoint, int statusCode) {
    return 'رفضت نقطة الاتصال $endpoint مفتاح API ‏(HTTP $statusCode).';
  }

  @override
  String get release_misc_api_key_required =>
      'يتطلب الخادم مفتاح API. أدخل قيمة API_SERVER_KEY الخاصة بك.';

  @override
  String release_misc_gateway_not_found(String endpoint) {
    return 'أعادت نقطة اتصال البوابة $endpoint رمز HTTP 404. تحقّق من بادئة مسار البوابة ومسارات الوكيل العكسي.';
  }

  @override
  String release_misc_gateway_http_error(String endpoint, int statusCode) {
    return 'أعادت نقطة اتصال البوابة $endpoint رمز HTTP $statusCode.';
  }

  @override
  String release_misc_gateway_unreachable(String endpoint) {
    return 'يتعذّر الوصول إلى نقطة اتصال البوابة $endpoint.';
  }

  @override
  String get release_core_schedule_invalid_delivery_target =>
      'وجهة التسليم غير صالحة';

  @override
  String get release_core_file_save_direct_only =>
      'لا يمكن حفظ إلا ملف موجود مباشرة في دليل العمل.';

  @override
  String get release_core_file_save_hidden =>
      'لا يمكن للبوابة حفظ الملفات المخفية.';

  @override
  String get rel_admin_choose_provider => 'اختر موفرًا ونموذجًا.';

  @override
  String get rel_admin_known_effort => 'اختر مستوى جهد معروفًا.';

  @override
  String get rel_admin_endpoint_name_required =>
      'أدخل اسمًا لنقطة النهاية هذه.';

  @override
  String get rel_admin_endpoint_model_required =>
      'أدخل النموذج الذي تقدمه نقطة النهاية هذه.';

  @override
  String get rel_admin_known_api_mode =>
      'اختر الوضع التلقائي أو وضع API معروفًا.';

  @override
  String get rel_admin_endpoint_id_invalid =>
      'معرّف نقطة النهاية هذا غير قابل للاستخدام.';

  @override
  String get rel_admin_endpoint_https =>
      'استخدم HTTPS لنقطة نهاية بعيدة، أو HTTP على localhost.';

  @override
  String get rel_admin_key_invalid => 'لا يمكن حفظ مفتاح API هذا.';

  @override
  String get rel_admin_response_shape =>
      'لم تتطابق استجابة البوابة مع البنية المتوقعة.';

  @override
  String get rel_admin_limits_required =>
      'أدخل حدود التكرار والتزامن والمهلة قبل الحفظ.';

  @override
  String get rel_admin_route_required =>
      'تحتاج كل قاعدة توجيه إلى اسم ونموذج قبل حفظها.';

  @override
  String get rel_admin_route_unique => 'يجب أن تكون أسماء قواعد التوجيه فريدة.';

  @override
  String get rel_admin_route_default_invalid =>
      'يجب أن تكون قاعدة التوجيه الافتراضية إحدى القواعد المحفوظة.';

  @override
  String get rel_admin_policy_required =>
      'اختر سياسة مرجعية متدهورة مع تنبيه أو صامتة.';

  @override
  String get rel_admin_mixture_missing => 'لم تُرجع البوابة مزيجًا نشطًا.';

  @override
  String get rel_admin_mixture_slots_required =>
      'حدد موفرًا ونموذجًا للمجمّع ولكل مرجع.';

  @override
  String get rel_admin_chat_id_required =>
      'أدخل معرّف المحادثة التي ينطبق عليها هذا التغيير.';

  @override
  String rel_admin_http_error(String status) {
    return 'أرجعت البوابة HTTP $status.';
  }

  @override
  String get rel_admin_response_unreadable => 'تعذّرت قراءة استجابة البوابة.';

  @override
  String get rel_admin_connect_before_change =>
      'صِل جلسة البوابة المباشرة قبل تغيير الفوترة أو المحادثة.';

  @override
  String get rel_admin_operation_unavailable =>
      'هذه البوابة لا توفر هذه العملية.';

  @override
  String get rel_admin_key_required => 'أدخل المفتاح المراد حفظه.';

  @override
  String get rel_admin_key_save_failed => 'لم تحفظ البوابة هذا المفتاح.';

  @override
  String get rel_admin_key_clear_required => 'اختر مفتاح موفر لمسحه.';

  @override
  String get rel_admin_key_clear_failed => 'لم تمسح البوابة هذا المفتاح.';

  @override
  String get rel_admin_endpoint_save_failed =>
      'لم تحفظ البوابة نقطة النهاية هذه.';

  @override
  String get rel_admin_endpoint_activate_failed =>
      'لم تُفعّل البوابة نقطة النهاية هذه.';

  @override
  String get rel_admin_accounts_secure_required =>
      'تحتاج حسابات الموفر إلى بوابة HTTPS موثّقة أو localhost.';

  @override
  String get rel_admin_accounts_read_failed => 'تعذّرت قراءة حسابات الموفر.';

  @override
  String get rel_admin_account_disconnect_failed =>
      'لم تفصل البوابة هذا الحساب.';

  @override
  String get rel_admin_account_not_disconnectable =>
      'لا يمكن فصل حساب الموفر هذا.';

  @override
  String get rel_admin_backend_required =>
      'اختر إحدى واجهات التفويض الخلفية المتاحة.';

  @override
  String get rel_admin_backend_save_failed =>
      'لم تحدد البوابة تلك الواجهة الخلفية.';

  @override
  String get rel_admin_routes_save_failed =>
      'لم تحفظ البوابة قواعد التوجيه تلك.';

  @override
  String get rel_admin_profile_route_required =>
      'تحتاج كل قاعدة توجيه لملف تعريف إلى اسم ملف التعريف.';

  @override
  String get rel_admin_profile_route_unique =>
      'يجب أن تكون قواعد توجيه ملفات التعريف فريدة.';

  @override
  String get rel_admin_profile_route_default_invalid =>
      'يجب أن تكون قاعدة توجيه ملف التعريف الافتراضية أحد ملفات التعريف المسموح بها.';

  @override
  String get rel_admin_profile_routes_save_failed =>
      'لم تحفظ البوابة قواعد توجيه ملفات التعريف تلك.';

  @override
  String get rel_admin_limits_save_failed => 'لم تحفظ البوابة تلك الحدود.';

  @override
  String get rel_admin_mixture_save_failed => 'لم تحفظ البوابة ذلك المزيج.';

  @override
  String get rel_admin_credit_amount_required =>
      'اختر أحد مبالغ الرصيد المعروضة.';

  @override
  String get rel_admin_charge_check_failed => 'تعذّر التحقق من تلك الرسوم.';

  @override
  String get rel_admin_reload_amounts_missing =>
      'لم تُقدَّم مبالغ إعادة الشحن التلقائي، لذا لم تُغيَّر.';

  @override
  String get rel_admin_plan_required => 'اختر خطة أولًا.';

  @override
  String get rel_admin_plan_scheduled_only =>
      'يمكن تأكيد تغيير خطة مجدول فقط من هنا.';

  @override
  String get rel_admin_billing_refused => 'رفضت البوابة طلب الفوترة هذا.';

  @override
  String get rel_admin_request_refused => 'رفضت البوابة هذا الطلب.';

  @override
  String get rel_admin_endpoint_answered => 'استجابت نقطة النهاية.';

  @override
  String get rel_admin_endpoint_no_answer => 'لم تستجب نقطة النهاية.';

  @override
  String get rel_admin_charge_unknown =>
      'نتيجة الرسوم غير معروفة. قد تُسوّى لاحقًا. تحقّق من البوابة الإلكترونية قبل إعادة المحاولة.';

  @override
  String get rel_admin_connect_before_billing =>
      'صِل جلسة البوابة المباشرة قبل قراءة الفوترة. لا تُفرض أي رسوم من هذه الصفحة.';

  @override
  String get rel_admin_preset_required => 'احفظ إعدادًا مسبقًا قبل تطبيقه.';

  @override
  String get rel_admin_cancel => 'إلغاء';

  @override
  String get rel_admin_refresh => 'تحديث';

  @override
  String get rel_admin_credits_and_plans => 'الأرصدة والخطط';

  @override
  String get rel_admin_saved => 'تم الحفظ';

  @override
  String get rel_admin_name => 'الاسم';

  @override
  String get rel_admin_base_url => 'عنوان URL الأساسي';

  @override
  String get rel_admin_model => 'النموذج';

  @override
  String get rel_admin_signed_in => 'تم تسجيل الدخول';

  @override
  String get rel_admin_not_signed_in => 'لم يتم تسجيل الدخول';

  @override
  String get rel_admin_provider => 'المزوّد';

  @override
  String get rel_admin_apply_to_this_chat => 'تطبيق على هذه الدردشة';

  @override
  String get rel_admin_auto => 'تلقائي';

  @override
  String get rel_admin_chat_completions => 'إكمالات المحادثة';

  @override
  String get rel_admin_codex_responses => 'استجابات Codex';

  @override
  String get rel_admin_anthropic_messages => 'رسائل Anthropic';

  @override
  String get rel_admin_could_not_complete_that_request =>
      'تعذّر إكمال ذلك الطلب.';

  @override
  String get rel_admin_confirm => 'تأكيد';

  @override
  String get rel_admin_providers_and_billing => 'الموفرون والفوترة';

  @override
  String get rel_admin_api_keys => 'مفاتيح API';

  @override
  String get rel_admin_custom_endpoints => 'نقاط نهاية مخصصة';

  @override
  String get rel_admin_provider_accounts => 'حسابات الموفرين';

  @override
  String get rel_admin_effort_and_speed_presets =>
      'إعدادات الجهد والسرعة المسبقة';

  @override
  String get rel_admin_delegation => 'التفويض';

  @override
  String get rel_admin_mixture_of_agents => 'مزيج الوكلاء';

  @override
  String get rel_admin_no_provider_keys_were_reported_for_this_profile =>
      'لم يُبلّغ عن مفاتيح موفر لهذا الملف التعريفي.';

  @override
  String get rel_admin_not_saved => 'غير محفوظ';

  @override
  String get rel_admin_new_key_value => 'قيمة المفتاح الجديدة';

  @override
  String get rel_admin_provider_key_saved => 'حُفظ مفتاح الموفر.';

  @override
  String get rel_admin_save_key => 'حفظ المفتاح';

  @override
  String get rel_admin_clear_provider_key => 'مسح مفتاح الموفر';

  @override
  String get rel_admin_provider_key_cleared => 'مُسح مفتاح الموفر.';

  @override
  String get rel_admin_clear_key => 'مسح المفتاح';

  @override
  String get rel_admin_new_endpoint => 'نقطة نهاية جديدة';

  @override
  String get rel_admin_api_key => 'مفتاح API';

  @override
  String get rel_admin_leave_blank_to_keep_a_key_this_endpoint_already_has =>
      'اتركه فارغًا للاحتفاظ بالمفتاح الموجود لنقطة النهاية هذه.';

  @override
  String get rel_admin_reachable => 'يمكن الوصول إليه';

  @override
  String get rel_admin_unreachable => 'يتعذّر الوصول إليه';

  @override
  String get rel_admin_test_endpoint => 'اختبار نقطة النهاية';

  @override
  String get rel_admin_endpoint_saved => 'حُفظت نقطة النهاية.';

  @override
  String get rel_admin_save_endpoint => 'حفظ نقطة النهاية';

  @override
  String get rel_admin_use_this_endpoint => 'استخدام نقطة النهاية هذه';

  @override
  String
  get rel_admin_make_this_named_endpoint_the_current_model_for_this_profile =>
      'هل تريد جعل نقطة النهاية المسماة هذه النموذج الحالي لهذا الملف التعريفي؟';

  @override
  String get rel_admin_endpoint_is_now_current =>
      'أصبحت نقطة النهاية هي الحالية.';

  @override
  String get rel_admin_use_endpoint => 'استخدام نقطة النهاية';

  @override
  String get rel_admin_delete_endpoint => 'حذف نقطة النهاية';

  @override
  String get rel_admin_delete_this_named_endpoint_from_the_profile =>
      'هل تريد حذف نقطة النهاية المسماة هذه من الملف التعريفي؟';

  @override
  String get rel_admin_endpoint_deleted => 'حُذفت نقطة النهاية.';

  @override
  String get rel_admin_signing_in_stays_on_the_provider_sign_in_screen =>
      'يبقى تسجيل الدخول في شاشة تسجيل دخول الموفر. لا يُنفَّذ الفصل إلا عندما تؤكد هذه البوابة إمكانية إزالة الحساب.';

  @override
  String get rel_admin_disconnect_this_provider_account_on_the_gateway =>
      'هل تريد فصل حساب الموفر هذا على البوابة؟';

  @override
  String get rel_admin_provider_account_disconnected => 'فُصل حساب الموفر.';

  @override
  String get rel_admin_disconnect => 'قطع الاتصال';

  @override
  String get rel_admin_not_disconnectable => 'غير قابل للفصل';

  @override
  String get rel_admin_fast => 'سريع';

  @override
  String get rel_admin_preset_saved_for_this_model =>
      'حُفظ الإعداد المسبق لهذا النموذج.';

  @override
  String get rel_admin_save_preset => 'حفظ الإعداد المسبق';

  @override
  String get rel_admin_chat_id => 'معرّف المحادثة';

  @override
  String get rel_admin_apply_preset => 'تطبيق الإعداد المسبق';

  @override
  String get rel_admin_set_this_chat_s_effort_and_speed_from_the_saved_preset =>
      'هل تريد ضبط جهد هذه المحادثة وسرعتها من الإعداد المسبق المحفوظ؟';

  @override
  String get rel_admin_preset_applied_to_this_chat =>
      'طُبّق الإعداد المسبق على هذه المحادثة.';

  @override
  String get rel_admin_this_route_sends_the_picked_effort_unchanged =>
      'ترسل قاعدة التوجيه هذه الجهد المحدد دون تغيير.';

  @override
  String get rel_admin_show_route_clamp => 'عرض تقييد الجهد للمسار';

  @override
  String get rel_admin_delegation_backend => 'واجهة التفويض الخلفية';

  @override
  String get rel_admin_delegation_backend_saved =>
      'حُفظت واجهة التفويض الخلفية.';

  @override
  String get rel_admin_save_backend => 'حفظ الواجهة الخلفية';

  @override
  String get rel_admin_max_iterations => 'الحد الأقصى للتكرارات';

  @override
  String get rel_admin_max_concurrent_children =>
      'الحد الأقصى للوكلاء الفرعيين المتزامنين';

  @override
  String get rel_admin_child_timeout_seconds => 'مهلة الوكيل الفرعي بالثواني';

  @override
  String get rel_admin_delegation_effort_leave_unchanged =>
      'جهد التفويض، اتركه دون تغيير';

  @override
  String get rel_admin_delegation_limits_saved => 'حُفظت حدود التفويض.';

  @override
  String get rel_admin_save_limits => 'حفظ الحدود';

  @override
  String get rel_admin_remove_route => 'إزالة قاعدة التوجيه';

  @override
  String get rel_admin_route_name => 'اسم قاعدة التوجيه';

  @override
  String get rel_admin_route_provider => 'موفر قاعدة التوجيه';

  @override
  String get rel_admin_route_model => 'نموذج قاعدة التوجيه';

  @override
  String get rel_admin_route_effort_unchanged => 'جهد قاعدة التوجيه دون تغيير';

  @override
  String get rel_admin_add_route => 'إضافة قاعدة توجيه';

  @override
  String get rel_admin_default_route => 'قاعدة التوجيه الافتراضية';

  @override
  String get rel_admin_delegation_routes_saved => 'حُفظت قواعد توجيه التفويض.';

  @override
  String get rel_admin_save_routes => 'حفظ قواعد التوجيه';

  @override
  String get rel_admin_profile_routes_saved =>
      'حُفظت قواعد توجيه ملفات التعريف.';

  @override
  String get rel_admin_save_profile_routes => 'حفظ قواعد توجيه ملفات التعريف';

  @override
  String get rel_admin_no_mixture_is_loaded => 'لم يُحمَّل أي مزيج.';

  @override
  String get rel_admin_mixture_enabled => 'المزيج مفعّل';

  @override
  String get rel_admin_loud_degraded_references => 'تنبيه عند تدهور المراجع';

  @override
  String get rel_admin_silent_degraded_references => 'صمت عند تدهور المراجع';

  @override
  String get rel_admin_aggregator => 'المجمّع';

  @override
  String get rel_admin_aggregator_provider => 'موفر المجمّع';

  @override
  String get rel_admin_aggregator_model => 'نموذج المجمّع';

  @override
  String get rel_admin_reference_provider => 'موفر المرجع';

  @override
  String get rel_admin_reference_model => 'النموذج المرجعي';

  @override
  String get rel_admin_add_reference_model => 'إضافة نموذج مرجعي';

  @override
  String get rel_admin_mixture_saved => 'حُفظ المزيج.';

  @override
  String get rel_admin_save_mixture => 'حفظ المزيج';

  @override
  String get rel_admin_credit_purchase_submitted => 'أُرسل طلب شراء الرصيد.';

  @override
  String get rel_admin_credit_purchase_settled => 'سُوّيت عملية شراء الرصيد.';

  @override
  String get rel_admin_credit_and_plan_changes_wait_for_confirmation_a_plan =>
      'تنتظر تغييرات الرصيد والخطة التأكيد. تُعرض الخطة التي ستفرض رسومًا فورية ولا تُؤكَّد هنا.';

  @override
  String get rel_admin_buy_credits => 'شراء رصيد';

  @override
  String get rel_admin_retry_same_charge => 'إعادة محاولة الرسوم نفسها';

  @override
  String get rel_admin_retry_the_same_credit_charge_this_does_not_start =>
      'أعِد محاولة رسوم الرصيد نفسها. لا يبدأ هذا عملية شراء ثانية.';

  @override
  String get rel_admin_credit_purchases_are_not_available_for_this_account =>
      'شراء الرصيد غير متاح لهذا الحساب.';

  @override
  String get rel_admin_auto_reload => 'إعادة الشحن التلقائي';

  @override
  String get rel_admin_read_only_until_this_account_can_charge =>
      'للقراءة فقط حتى يتمكن هذا الحساب من الدفع.';

  @override
  String get rel_admin_auto_reload_updated => 'حُدّثت إعادة الشحن التلقائي.';

  @override
  String get rel_admin_keep_going_on_credits => 'المتابعة باستخدام الرصيد';

  @override
  String get rel_admin_continue_on_credits_when_the_plan_window_is_used_up =>
      'هل تريد المتابعة باستخدام الرصيد عند استنفاد حصة فترة الخطة؟';

  @override
  String
  get rel_admin_stop_continuing_on_credits_when_the_plan_window_is_used_up =>
      'هل تريد إيقاف المتابعة باستخدام الرصيد عند استنفاد حصة فترة الخطة؟';

  @override
  String get rel_admin_credit_continuation_updated =>
      'حُدّثت المتابعة باستخدام الرصيد.';

  @override
  String get rel_admin_this_plan_change_is_not_confirmed_from_ares =>
      'لا يُؤكَّد تغيير الخطة هذا من Ares.';

  @override
  String get rel_admin_this_change_is_scheduled_confirm_to_apply_it =>
      'هذا التغيير مجدول. أكّد لتطبيقه.';

  @override
  String get rel_admin_preview_plan => 'معاينة الخطة';

  @override
  String get rel_admin_schedule_plan_change => 'جدولة تغيير الخطة';

  @override
  String get rel_admin_plan_change_scheduled => 'جُدول تغيير الخطة.';

  @override
  String get rel_admin_confirm_scheduled_plan_change =>
      'تأكيد تغيير الخطة المجدول';

  @override
  String rel_admin_remove_key_confirm(String key) {
    return 'هل تريد إزالة قيمة $key المحفوظة من هذا الملف التعريفي؟';
  }

  @override
  String rel_admin_current_endpoint(String name) {
    return '$name · الحالي';
  }

  @override
  String rel_admin_endpoint_result(
    String status,
    String transport,
    String count,
    String message,
  ) {
    return '$status · $transport · $count نماذج. $message';
  }

  @override
  String rel_admin_disconnect_account(String name) {
    return 'فصل $name';
  }

  @override
  String rel_admin_delegation_blocked(String reason) {
    return 'التفويض محظور: $reason';
  }

  @override
  String rel_admin_backend_unavailable(String name) {
    return '$name · غير متاح';
  }

  @override
  String rel_admin_reference_number(String number) {
    return 'المرجع $number';
  }

  @override
  String rel_admin_reload_enable_confirm(String amount, String threshold) {
    return 'هل تريد تشغيل إعادة الشحن التلقائي وفرض رسوم $amount عندما ينخفض الرصيد عن $threshold؟';
  }

  @override
  String rel_admin_reload_disable_confirm(String amount, String threshold) {
    return 'هل تريد إيقاف إعادة الشحن التلقائي؟ تُفرض حاليًا رسوم $amount عندما ينخفض الرصيد عن $threshold.';
  }

  @override
  String get rel_admin_this_plan => 'هذه الخطة';

  @override
  String rel_admin_plan_confirm(String name) {
    return 'جدولة $name. يُجدول لنهاية الفترة الحالية. لا تُفرض رسوم الآن.';
  }

  @override
  String rel_admin_plan_confirm_price(String name, String price) {
    return 'جدولة $name بسعر $price. يُجدول لنهاية الفترة الحالية. لا تُفرض رسوم الآن.';
  }

  @override
  String rel_admin_plan_confirm_when(String name, String when) {
    return 'جدولة $name. يسري $when. لا تُفرض رسوم الآن.';
  }

  @override
  String rel_admin_plan_confirm_price_when(
    String name,
    String price,
    String when,
  ) {
    return 'جدولة $name بسعر $price. يسري $when. لا تُفرض رسوم الآن.';
  }

  @override
  String rel_admin_balance(String amount) {
    return 'الرصيد $amount';
  }

  @override
  String rel_admin_buy_confirm(String amount) {
    return 'فرض رسوم \$$amount على وسيلة الدفع في حساب Nous هذا. هذا ينفق أموالًا حقيقية.';
  }

  @override
  String rel_admin_reload_portal(String url) {
    return 'غيّر إعادة الشحن التلقائي على البوابة الإلكترونية: $url';
  }

  @override
  String rel_admin_team_portal(String url) {
    return 'تُغيَّر اشتراكات الفريق على البوابة الإلكترونية: $url';
  }

  @override
  String get rel_admin_effort_none => 'بلا';

  @override
  String get rel_admin_effort_minimal => 'أدنى';

  @override
  String get rel_admin_effort_low => 'منخفض';

  @override
  String get rel_admin_effort_medium => 'متوسط';

  @override
  String get rel_admin_effort_high => 'مرتفع';

  @override
  String get rel_admin_effort_xhigh => 'مرتفع جدًا';

  @override
  String get rel_admin_effort_max => 'أقصى';

  @override
  String get rel_admin_effort_ultra => 'فائق';

  @override
  String get rel_admin_auto_lower => 'تلقائي';

  @override
  String get rel_admin_create => 'إنشاء';

  @override
  String get rel_admin_prompt => 'التعليمات';

  @override
  String get rel_admin_new_profile_id => 'معرّف الملف الشخصي الجديد';

  @override
  String get rel_admin_this_operation_is_unavailable_on_this_gateway =>
      'هذه العملية غير متاحة على هذه البوابة.';

  @override
  String get rel_admin_access_denied_by_the_gateway => 'رفضت البوابة الوصول.';

  @override
  String get rel_admin_connection_changed_reopen_profiles =>
      'تغيّر الاتصال. أعِد فتح ملفات التعريف.';

  @override
  String
  get rel_admin_invalid_input_or_gateway_response_check_the_target_before =>
      'إدخال أو استجابة بوابة غير صالحة. تحقّق من الهدف قبل إعادة المحاولة.';

  @override
  String get rel_admin_could_not_verify_the_result_refresh_the_target_before =>
      'تعذّر التحقق من النتيجة. حدّث الهدف قبل المحاولة مرة أخرى.';

  @override
  String get rel_admin_edit_soul_md => 'تحرير SOUL.md';

  @override
  String get rel_admin_persona => 'الشخصية';

  @override
  String get rel_admin_persona_saved => 'حُفظت الشخصية.';

  @override
  String get rel_admin_not_set => 'غير معيّن';

  @override
  String get rel_admin_enabled => 'مفعّل';

  @override
  String get rel_admin_keys_to_remove_comma_separated =>
      'المفاتيح المراد إزالتها (مفصولة بفواصل)';

  @override
  String get rel_admin_saved_and_applied_by_the_gateway =>
      'حُفظ وطُبّق بواسطة البوابة.';

  @override
  String get rel_admin_saved_a_gateway_restart_may_be_required =>
      'حُفظ. قد تلزم إعادة تشغيل البوابة.';

  @override
  String get rel_admin_create_signed_route => 'إنشاء قاعدة توجيه موقّعة';

  @override
  String get rel_admin_route_id => 'معرّف قاعدة التوجيه';

  @override
  String get rel_admin_signature => 'التوقيع';

  @override
  String get rel_admin_events_comma_separated => 'الأحداث (مفصولة بفواصل)';

  @override
  String get rel_admin_delivery_target => 'وجهة التسليم';

  @override
  String get rel_admin_skills_comma_separated => 'المهارات (مفصولة بفواصل)';

  @override
  String get rel_admin_delivery_mode => 'وضع التسليم';

  @override
  String get rel_admin_delivery_chat_id_optional =>
      'معرّف محادثة التسليم (اختياري)';

  @override
  String get rel_admin_hide_signing_secret => 'إخفاء سر التوقيع';

  @override
  String get rel_admin_reveal_signing_secret => 'إظهار سر التوقيع';

  @override
  String get rel_admin_edit_persona => 'تحرير الشخصية';

  @override
  String get rel_admin_portable_profile_bundle => 'حزمة ملف تعريف محمولة';

  @override
  String get rel_admin_clone_profile => 'استنساخ الملف التعريفي';

  @override
  String get rel_admin_rename_display_label => 'إعادة تسمية تسمية العرض';

  @override
  String get rel_admin_rename_profile => 'إعادة تسمية الملف التعريفي';

  @override
  String get rel_admin_new_name => 'الاسم الجديد';

  @override
  String get rel_admin_rename_verified => 'تم التحقق من إعادة التسمية.';

  @override
  String get rel_admin_delete_profile => 'حذف الملف التعريفي';

  @override
  String get rel_admin_profile_id_to_delete =>
      'معرّف الملف التعريفي المراد حذفه';

  @override
  String get rel_admin_profile_deleted => 'حُذف الملف التعريفي.';

  @override
  String
  get rel_admin_profile_deleted_server_identity_cleanup_is_still_pending =>
      'حُذف الملف التعريفي. لا يزال تنظيف هوية الخادم معلقًا.';

  @override
  String get rel_admin_export_profile_archive => 'تصدير أرشيف الملف التعريفي';

  @override
  String get rel_admin_import_profile_archive => 'استيراد أرشيف الملف التعريفي';

  @override
  String get rel_admin_import_a_trusted_profile => 'استيراد ملف تعريف موثوق';

  @override
  String get rel_admin_absolute_archive_path_on_gateway =>
      'مسار الأرشيف المطلق على البوابة';

  @override
  String get rel_admin_messaging_channels => 'قنوات المراسلة';

  @override
  String get rel_admin_dm_pairing_requests => 'طلبات إقران الرسائل المباشرة';

  @override
  String get rel_admin_no_pending_or_approved_users =>
      'لا يوجد مستخدمون معلقون أو معتمدون.';

  @override
  String get rel_admin_legacy_pairing_no_verifiable_request_id_ask_the_user =>
      'إقران قديم: لا يوجد معرّف طلب قابل للتحقق. اطلب من المستخدم الإقران مجددًا.';

  @override
  String get rel_admin_pairing_change_verified => 'تم التحقق من تغيير الإقران.';

  @override
  String get rel_admin_create_telegram_bot_by_qr => 'إنشاء بوت Telegram عبر QR';

  @override
  String get rel_admin_create_telegram_bot => 'إنشاء بوت Telegram';

  @override
  String get rel_admin_bot_name => 'اسم البوت';

  @override
  String get rel_admin_telegram_bot_creation_qr_code =>
      'رمز QR لإنشاء بوت Telegram';

  @override
  String get rel_admin_check_telegram_pairing => 'التحقق من إقران Telegram';

  @override
  String get rel_admin_waiting_for_telegram => 'بانتظار Telegram.';

  @override
  String get rel_admin_apply_telegram_bot => 'تطبيق بوت Telegram';

  @override
  String get rel_admin_allowed_numeric_user_ids =>
      'معرّفات المستخدمين الرقمية المسموح بها';

  @override
  String get rel_admin_saved_restart_still_required =>
      'حُفظ. لا تزال إعادة التشغيل مطلوبة.';

  @override
  String get rel_admin_saved_gateway_restart_requested =>
      'حُفظ؛ طُلبت إعادة تشغيل البوابة.';

  @override
  String get rel_admin_cancel_telegram_setup => 'إلغاء إعداد Telegram';

  @override
  String get rel_admin_inbound_webhooks => 'خطافات الويب الواردة';

  @override
  String get rel_admin_enable_webhook_service => 'تفعيل خدمة خطافات الويب';

  @override
  String get rel_admin_enable_webhooks => 'تفعيل خطافات الويب';

  @override
  String get rel_admin_enabled_restart_still_required =>
      'فُعّل. لا تزال إعادة التشغيل مطلوبة.';

  @override
  String get rel_admin_enabled_restart_requested =>
      'فُعّل؛ طُلبت إعادة التشغيل.';

  @override
  String get rel_admin_route_change_verified =>
      'تم التحقق من تغيير قاعدة التوجيه.';

  @override
  String get rel_admin_delete_route => 'حذف قاعدة التوجيه';

  @override
  String get rel_admin_disable_route => 'تعطيل قاعدة التوجيه';

  @override
  String get rel_admin_enable_route => 'تفعيل قاعدة التوجيه';

  @override
  String get rel_admin_back_up_entire_agent_home =>
      'نسخ مجلد الوكيل الرئيسي بالكامل احتياطيًا';

  @override
  String get rel_admin_transfer_to_a_cloud_agent => 'النقل إلى وكيل Cloud';

  @override
  String get rel_admin_check_backup_progress =>
      'التحقق من تقدم النسخ الاحتياطي';

  @override
  String get rel_admin_save_backup_to_this_device =>
      'حفظ النسخة الاحتياطية على هذا الجهاز';

  @override
  String get rel_admin_save_sensitive_full_home_archive =>
      'حفظ أرشيف المجلد الرئيسي الكامل الحساس';

  @override
  String get rel_admin_save_cancelled => 'أُلغي الحفظ.';

  @override
  String get rel_admin_backup_saved => 'حُفظت النسخة الاحتياطية.';

  @override
  String get rel_admin_up_to_32_mib_larger_archives_remain_on_the_gateway =>
      'حتى 32 MiB. تبقى الأرشيفات الأكبر على البوابة.';

  @override
  String rel_admin_persona_scope(String scope) {
    return 'احفظ الشخصية لـ $scope.';
  }

  @override
  String rel_admin_configure_channel(String name) {
    return 'إعداد $name';
  }

  @override
  String rel_admin_channel_warning(String scope) {
    return 'ينطبق على $scope. يترك الفراغ القيمة الحالية. لإزالة قيمة، أدرج مفتاحها أدناه.';
  }

  @override
  String rel_admin_hook_warning(String scope) {
    return 'ينطبق على $scope. استخدم اسمًا فريدًا. تنشئ البوابة سر توقيع. إذا أنشأ مشغّل آخر الاسم في الوقت نفسه، فقد يستبدل المضيف قاعدة التوجيه تلك.';
  }

  @override
  String rel_admin_hook_created(String url) {
    return 'أُنشئ $url. احفظ سر التوقيع قبل المغادرة.';
  }

  @override
  String rel_admin_clone_warning(String scope) {
    return 'انسخ الإعدادات والمهارات والشخصية وربما بيانات اعتماد الموفر من $scope. لا تُطلب رموز المراسلة.';
  }

  @override
  String rel_admin_cloned(String source, String destination) {
    return 'استُنسخ $source إلى $destination.';
  }

  @override
  String rel_admin_rename_target(String name) {
    return 'إعادة تسمية $name';
  }

  @override
  String rel_admin_rename_label_warning(String scope) {
    return 'غيّر تسمية العرض لـ $scope. يبقى معرّفه default.';
  }

  @override
  String rel_admin_rename_warning(String scope) {
    return 'أعِد تسمية $scope على الخادم. قد تتوقف بوابة قيد التشغيل.';
  }

  @override
  String rel_admin_delete_target(String name) {
    return 'حذف $name';
  }

  @override
  String rel_admin_delete_profile_warning(String scope) {
    return 'احذف $scope نهائيًا، بما في ذلك الجلسات وبيانات الاعتماد. اكتب معرّف الملف التعريفي بالضبط.';
  }

  @override
  String rel_admin_export_target(String name) {
    return 'تصدير $name';
  }

  @override
  String rel_admin_export_warning(String scope) {
    return 'أنشئ .tar.gz على $scope. تُستبعد مخازن بيانات الاعتماد المعروفة، لكن قد تبقى بيانات خاصة. راجع قبل المشاركة.';
  }

  @override
  String rel_admin_archive_on(String gateway, String path) {
    return 'الأرشيف على $gateway: $path';
  }

  @override
  String rel_admin_import_warning(String gateway) {
    return 'استخدم .tar.gz تمت مراجعته وموجودًا بالفعل على $gateway. قد يحتوي على إضافات وبرامج نصية وجداول. يلزم معرّف ملف تعريف جديد.';
  }

  @override
  String rel_admin_imported(String name) {
    return 'استُورد $name.';
  }

  @override
  String rel_admin_approve_user(String user) {
    return 'اعتماد $user';
  }

  @override
  String rel_admin_revoke_user(String user) {
    return 'إلغاء صلاحية $user';
  }

  @override
  String rel_admin_allow_pair(String platform, String scope) {
    return '$platform على $scope: السماح لهذا المستخدم بالوصول إلى المراسلة.';
  }

  @override
  String rel_admin_remove_pair(String platform, String scope) {
    return '$platform على $scope: إزالة وصول هذا المستخدم إلى المراسلة.';
  }

  @override
  String rel_admin_telegram_start(String scope) {
    return 'ابدأ إقران Telegram على $scope باستخدام خدمة إعداد البوابة.';
  }

  @override
  String rel_admin_expires(String time) {
    return 'تنتهي الصلاحية: $time';
  }

  @override
  String rel_admin_telegram_apply(String bot, String scope) {
    return 'فعّل @$bot على $scope وحاول إعادة تشغيل البوابة. لا يجوز مراسلته إلا للمستخدمين المدرجين.';
  }

  @override
  String rel_admin_hooks_enable(String scope) {
    return 'فعّل خطافات الويب الواردة على $scope وحاول إعادة تشغيل البوابة.';
  }

  @override
  String rel_admin_disable_target(String name) {
    return 'تعطيل $name';
  }

  @override
  String rel_admin_enable_target(String name) {
    return 'تفعيل $name';
  }

  @override
  String rel_admin_hook_change(String name, String scope) {
    return 'غيّر $name تحديدًا على $scope.';
  }

  @override
  String rel_admin_backup_warning(String gateway) {
    return 'هذه ليست نسخة احتياطية لإعدادات Ares. احفظ جميع ملفات التعريف والجلسات وبيانات الاعتماد على $gateway. الأرشيف حساس.';
  }

  @override
  String rel_admin_backup_started(String gateway) {
    return 'بدأ النسخ الاحتياطي على $gateway.';
  }

  @override
  String rel_admin_backup_verified(String gateway, String path) {
    return 'تم التحقق من النسخة الاحتياطية على $gateway: $path';
  }

  @override
  String rel_admin_backup_running(String gateway) {
    return 'لا يزال النسخ الاحتياطي جاريًا على $gateway.';
  }

  @override
  String get rel_admin_choice_yes => 'نعم';

  @override
  String get rel_admin_choice_no => 'لا';

  @override
  String get rel_admin_choice_generic => 'عام';

  @override
  String get rel_admin_choice_log => 'سجل';

  @override
  String get rel_admin_choice_email => 'بريد إلكتروني';

  @override
  String get rel_admin_choice_github_comment => 'تعليق GitHub';

  @override
  String get rel_admin_choice_agent => 'يعالج الوكيل الحدث';

  @override
  String get rel_admin_choice_direct => 'تسليم مباشر';

  @override
  String get rel_admin_configured => 'مُعدّ';

  @override
  String get rel_admin_state_pending_restart => 'بانتظار إعادة التشغيل';

  @override
  String get rel_admin_state_unknown => 'غير معروف';

  @override
  String get rel_admin_state_connected => 'متصل';

  @override
  String get rel_admin_state_disconnected => 'غير متصل';

  @override
  String get rel_admin_state_disabled => 'معطّل';

  @override
  String get rel_admin_state_enabled => 'مفعّل';

  @override
  String get rel_admin_state_running => 'قيد التشغيل';

  @override
  String get rel_admin_state_stopped => 'متوقف';

  @override
  String get rel_admin_state_error => 'خطأ';

  @override
  String get rel_admin_state_not_configured => 'غير مُعدّ';

  @override
  String get rel_admin_state_startup_failed => 'فشل بدء التشغيل';

  @override
  String get rel_admin_state_gateway_stopped => 'البوابة متوقفة';

  @override
  String get rel_admin_state_connecting => 'جارٍ الاتصال';

  @override
  String get rel_admin_state_retrying => 'إعادة المحاولة';

  @override
  String get rel_admin_state_fatal => 'خطأ فادح';

  @override
  String get rel_admin_unsupported_or_oversized_profile_archive =>
      'أرشيف ملف تعريف غير مدعوم أو كبير جدًا.';

  @override
  String get rel_admin_current_layout => 'التخطيط الحالي';

  @override
  String get rel_admin_one_pane => 'لوحة واحدة';

  @override
  String get rel_admin_stacked => 'مكدّس';

  @override
  String get rel_admin_side_by_side => 'جنبًا إلى جنب';

  @override
  String get rel_admin_no_supported_appearance_in_this_profile =>
      'لا يوجد مظهر مدعوم في هذا الملف التعريفي.';

  @override
  String get rel_admin_review_appearance_saved_with_this_profile =>
      'مراجعة المظهر المحفوظ مع هذا الملف التعريفي';

  @override
  String get rel_admin_applies_only_to_this_named_profile_on_this_device =>
      'ينطبق فقط على هذا الملف التعريفي المسمى على هذا الجهاز. يبدأ الترتيب المستورد بلوحات فارغة؛ اختر محادثاته بنفسك.';

  @override
  String get rel_admin_apply_to_this_profile_on_this_device =>
      'تطبيق على هذا الملف التعريفي على هذا الجهاز';

  @override
  String get rel_admin_export_prepares_a_tar_gz_on_the_gateway_review =>
      'يُجهّز التصدير ملف .tar.gz على البوابة. راجع ملفاته المحمولة قبل حفظ نسخة هنا. يفتح الاستيراد أرشيفًا محليًا للمراجعة؛ الفتح وحده لا يرفع أي شيء.';

  @override
  String get rel_admin_prepare_profile_export => 'تجهيز تصدير الملف التعريفي';

  @override
  String get rel_admin_open_tar_gz_from_this_device =>
      'فتح .tar.gz من هذا الجهاز';

  @override
  String get rel_admin_only_selected_text_files_travel_review_for_secrets_and =>
      'تُنقل الملفات النصية المحددة فقط. راجعها بحثًا عن الأسرار والمعلومات الخاصة. قد تغيّر الإعدادات والمهارات والجداول ما يفعله الملف التعريفي الجديد.';

  @override
  String get rel_admin_include_this_reviewed_file =>
      'تضمين هذا الملف الذي تمت مراجعته';

  @override
  String get rel_admin_apply_appearance_to_the_new_profile_on_this_device =>
      'تطبيق المظهر على الملف التعريفي الجديد على هذا الجهاز';

  @override
  String
  get rel_admin_imports_colours_and_pane_sizes_never_chats_tools_or_session_ids =>
      'يستورد الألوان وأحجام اللوحات، وليس المحادثات أو الأدوات أو معرّفات الجلسات.';

  @override
  String
  get rel_admin_the_gateway_retains_a_private_staged_copy_import_creates =>
      'تحتفظ البوابة بنسخة مرحلية خاصة. ينشئ الاستيراد ملف تعريف جديدًا؛ ولا يستبدل ملفًا موجودًا.';

  @override
  String get rel_admin_appearance_not_applied_the_gateway_did_not_confirm_the =>
      ' لم يُطبّق المظهر: لم تؤكد البوابة التراكب الذي تمت مراجعته.';

  @override
  String get rel_admin_appearance_applied_on_this_device =>
      ' طُبّق المظهر على هذا الجهاز.';

  @override
  String get rel_admin_appearance_was_not_saved_on_this_device =>
      ' لم يُحفظ المظهر على هذا الجهاز.';

  @override
  String get rel_admin_save_reviewed_profile_bundle =>
      'حفظ حزمة الملف التعريفي التي تمت مراجعتها';

  @override
  String get rel_admin_profile_bundle_saved => 'حُفظت حزمة الملف التعريفي.';

  @override
  String get rel_admin_import_selected_files => 'استيراد الملفات المحددة';

  @override
  String get rel_admin_save_selected_files_to_device =>
      'حفظ الملفات المحددة على الجهاز';

  @override
  String rel_admin_layout_first_pane(String layout, String percent) {
    return '$layout · $percent% للوحة الأولى';
  }

  @override
  String rel_admin_appearance_summary(String skin, String mode, String layout) {
    return 'السمة: $skin · الوضع: $mode · $layout';
  }

  @override
  String rel_admin_appearance_applied(String gateway, String profile) {
    return 'طُبّق المظهر على $gateway / $profile.';
  }

  @override
  String rel_admin_bundle_summary(
    String profile,
    String count,
    String omitted,
  ) {
    return 'الحزمة: $profile · $count ملفات قابلة للمراجعة · $omitted مستبعدة';
  }

  @override
  String rel_admin_imported_on(String name, String gateway) {
    return 'استُورد $name على $gateway.';
  }

  @override
  String get rel_admin_unchanged => 'دون تغيير';

  @override
  String get rel_admin_mode_system => 'النظام';

  @override
  String get rel_admin_mode_light => 'فاتح';

  @override
  String get rel_admin_mode_dark => 'داكن';

  @override
  String get rel_admin_skin_classic => 'كلاسيكي';

  @override
  String get rel_admin_skin_midnight => 'منتصف الليل';

  @override
  String get rel_admin_skin_ember => 'جمر';

  @override
  String get rel_admin_skin_mono => 'أحادي اللون';

  @override
  String get rel_admin_skin_cyberpunk => 'سايبربانك';

  @override
  String get rel_admin_skin_slate => 'أردوازي';

  @override
  String get rel_admin_no_available_cloud_agents_in_this_account =>
      'لا يوجد وكلاء Cloud متاحون في هذا الحساب.';

  @override
  String get rel_admin_the_previous_undo_receipt_could_not_be_verified_no =>
      'تعذّر التحقق من إيصال التراجع السابق. لم يُجرَ أي تغيير.';

  @override
  String get rel_admin_transfer_to_cloud => 'النقل إلى Cloud';

  @override
  String
  get rel_admin_connection_changed_leave_this_page_a_restore_already_submitted =>
      'تغيّر الاتصال. غادر هذه الصفحة. قد تستمر عملية استعادة سبق إرسالها.';

  @override
  String get rel_admin_find_my_cloud_agents =>
      'العثور على وكلاء Cloud الخاصين بي';

  @override
  String
  get rel_admin_undo_replaces_the_destination_with_its_pre_transfer_backup =>
      'يستبدل التراجع الوجهة بنسختها الاحتياطية السابقة للنقل.';

  @override
  String get rel_admin_replace_this_cloud_agent_with_the_entire_source_home =>
      'استبدل وكيل Cloud هذا بالمجلد الرئيسي للمصدر بالكامل، بما في ذلك بيانات الاعتماد والمحادثات والملفات. لا يُحذف المصدر. تُعطّل بوتات المراسلة الواردة.';

  @override
  String get rel_admin_type_destination_agent_id => 'اكتب معرّف وكيل الوجهة';

  @override
  String
  get rel_admin_could_not_retain_the_local_undo_receipt_keep_this_page_open =>
      'تعذّر الاحتفاظ بإيصال التراجع المحلي. أبقِ هذه الصفحة مفتوحة.';

  @override
  String get rel_admin_undo_transfer => 'التراجع عن النقل';

  @override
  String get rel_admin_replace_cloud_agent => 'استبدال وكيل Cloud';

  @override
  String
  get rel_admin_local_undo_receipt_forgotten_no_remote_backup_was_removed =>
      'نُسي إيصال التراجع المحلي. لم تُزل أي نسخة احتياطية بعيدة.';

  @override
  String get rel_admin_forget_local_undo_receipt_only =>
      'نسيان إيصال التراجع المحلي فقط';

  @override
  String get rel_admin_stop_before_restore => 'الإيقاف قبل الاستعادة';

  @override
  String get rel_admin_do_not_close_this_page_restore_runs_on_the =>
      'لا تغلق هذه الصفحة. تعمل الاستعادة على الوجهة ولا يمكن إلغاؤها.';

  @override
  String get rel_admin_files_restored_destination_gateway_needs_attention =>
      'استُعيدت الملفات؛ تحتاج بوابة الوجهة إلى عناية.';

  @override
  String rel_admin_transfer_sign_in(String origin) {
    return 'سجّل الدخول إلى اتصال Ares محفوظ واحد فقط لـ $origin، ثم عُد إلى هنا.';
  }

  @override
  String rel_admin_transfer_source(String gateway, String profile) {
    return 'المصدر: $gateway / $profile';
  }

  @override
  String rel_admin_transfer_destination(String name, String origin) {
    return 'الوجهة: $name · $origin / default';
  }

  @override
  String rel_admin_agent_id(String id) {
    return 'معرّف الوكيل: $id';
  }

  @override
  String rel_admin_transfer_status(String phase) {
    return 'الحالة: $phase';
  }

  @override
  String rel_admin_copied_percent(String percent) {
    return 'نُسخ $percent%';
  }

  @override
  String rel_admin_undo_point(String path) {
    return 'نقطة التراجع على الوجهة: $path';
  }

  @override
  String rel_admin_messaging_disabled(String channels) {
    return 'المراسلة معطّلة: $channels';
  }

  @override
  String get rel_admin_phase_prepared => 'جاهز';

  @override
  String get rel_admin_phase_backup => 'نسخ احتياطي';

  @override
  String get rel_admin_phase_upload => 'رفع';

  @override
  String get rel_admin_phase_restore => 'استعادة';

  @override
  String get rel_admin_phase_finished => 'مكتمل';

  @override
  String get rel_admin_phase_failed => 'فشل';

  @override
  String get rel_admin_phase_undo => 'تراجع';

  @override
  String get rel_admin_phase_undone => 'تم التراجع';

  @override
  String rel_ops_cap_install_blocked(String verdict, String detail) {
    return 'حُظر التثبيت ($verdict): $detail';
  }

  @override
  String rel_ops_cap_scan_confirm(String verdict, String requested) {
    return 'نتيجة الفحص: $verdict. أكّد $requested قبل التثبيت.';
  }

  @override
  String rel_ops_cap_install_unconfirmed(String requested) {
    return 'لم تؤكد البوابة تثبيت $requested.';
  }

  @override
  String rel_ops_cap_edit_skill(String name) {
    return 'تعديل $name';
  }

  @override
  String rel_ops_cap_archive_skill(String name) {
    return 'أرشفة $name؟';
  }

  @override
  String rel_ops_cap_archive_explanation(String command) {
    return 'ستتم أرشفة المهارة ويمكن استعادتها باستخدام $command.';
  }

  @override
  String rel_ops_cap_install_anyway(String name) {
    return 'تثبيت $name على أي حال';
  }

  @override
  String rel_ops_cap_install_despite_scan(String name) {
    return 'تثبيت $name رغم نتيجة الفحص؟';
  }

  @override
  String rel_ops_cap_scan_warning(String name) {
    return 'حظر فحص الأمان $name. يسري هذا التأكيد على $name فقط.';
  }

  @override
  String rel_ops_cap_accept_scan_warning(String name) {
    return 'قبول الإمكانات لا يتجاوز فحص $name.';
  }

  @override
  String rel_ops_cap_review_scan(String name) {
    return 'مراجعة فحص $name';
  }

  @override
  String rel_ops_cap_desktop_grants(String description) {
    return '$description\nتبقى أذونات المجلدات وسكربتات المعاينة في تطبيق Desktop على ذلك الحاسوب. إزالة الملحق هنا لا تلغي تلك الأذونات المحلية.';
  }

  @override
  String rel_ops_cap_remove_plugin(String name) {
    return 'إزالة $name؟';
  }

  @override
  String rel_ops_cap_probe_result(String name, String tools) {
    return 'اختبار اتصال $name: $tools';
  }

  @override
  String rel_ops_cap_save_tool_grants_for(String connector) {
    return 'حفظ أذونات الأدوات للموصّل $connector';
  }

  @override
  String rel_ops_cap_backends_for(String name) {
    return 'محرّكات $name';
  }

  @override
  String rel_ops_cap_use_backend_confirmation(String name) {
    return 'استخدام $name؟';
  }

  @override
  String rel_ops_cap_unlock_source(String name) {
    return 'فتح قفل $name';
  }

  @override
  String get rel_ops_cap_capabilities => 'الإمكانات';

  @override
  String get rel_ops_cap_plugins => 'الملحقات';

  @override
  String get rel_ops_cap_connectors => 'الموصّلات';

  @override
  String get rel_ops_cap_backends => 'المحرّكات';

  @override
  String get rel_ops_cap_save_skill => 'حفظ المهارة';

  @override
  String get rel_ops_cap_archive => 'أرشفة';

  @override
  String get rel_ops_cap_hub_identifier => 'معرّف Hub';

  @override
  String get rel_ops_cap_install => 'تثبيت';

  @override
  String get rel_ops_cap_update_all => 'تحديث الكل';

  @override
  String get rel_ops_cap_unlock => 'فتح القفل';

  @override
  String get rel_ops_cap_lock => 'قفل';

  @override
  String get rel_ops_cap_this_update_adds_capabilities_nothing_changed_yet =>
      'يضيف هذا التحديث إمكانات. لم يتغير شيء بعد.';

  @override
  String get rel_ops_cap_the_scan_blocked_this_plugin =>
      'حظر الفحص هذا الملحق.';

  @override
  String get rel_ops_cap_the_plugin_was_not_changed => 'لم يتغير الملحق.';

  @override
  String get rel_ops_cap_repository => 'المستودع';

  @override
  String get rel_ops_cap_install_plugin => 'تثبيت ملحق';

  @override
  String get rel_ops_cap_update_plugins => 'تحديث الملحقات';

  @override
  String get rel_ops_cap_accept_capabilities => 'قبول الإمكانات';

  @override
  String get rel_ops_cap_update => 'تحديث';

  @override
  String get rel_ops_cap_remove_desktop_half => 'إزالة مكوّن سطح المكتب';

  @override
  String get rel_ops_cap_server_name => 'اسم الخادم';

  @override
  String get rel_ops_cap_command => 'الأمر';

  @override
  String get rel_ops_cap_http_url => 'عنوان HTTP URL';

  @override
  String get rel_ops_cap_add_server => 'إضافة خادم';

  @override
  String get rel_ops_cap_probe => 'اختبار الاتصال';

  @override
  String get rel_ops_cap_probe_failed => 'فشل اختبار الاتصال.';

  @override
  String get rel_ops_cap_logs => 'السجلات';

  @override
  String get rel_ops_cap_mcp_log => 'سجل MCP';

  @override
  String get rel_ops_cap_connector => 'الموصّل';

  @override
  String get rel_ops_cap_account_alias => 'الاسم المستعار للحساب';

  @override
  String get rel_ops_cap_link_account => 'ربط حساب';

  @override
  String get rel_ops_cap_remove_account => 'إزالة الحساب';

  @override
  String get rel_ops_cap_tool_connector => 'موصّل الأدوات';

  @override
  String get rel_ops_cap_load_tools => 'تحميل الأدوات';

  @override
  String get rel_ops_cap_save_tool_grants => 'حفظ أذونات الأدوات';

  @override
  String
  get rel_ops_cap_this_policy_has_no_member_revision_so_tool_grants_stay_unchanged =>
      'لا تتضمن هذه السياسة مراجعة للعضو، لذا تبقى أذونات الأدوات دون تغيير.';

  @override
  String get rel_ops_cap_active => 'نشط';

  @override
  String get rel_ops_cap_use => 'استخدام';

  @override
  String get rel_ops_cap_run_setup => 'تشغيل الإعداد';

  @override
  String get rel_ops_cap_terminal_backends => 'محرّكات الطرفية';

  @override
  String get rel_ops_cap_this_changes_the_terminal_backend_for_this_profile =>
      'يغيّر هذا محرّك الطرفية لهذا الملف الشخصي.';

  @override
  String get rel_ops_cap_use_backend => 'استخدام المحرّك';

  @override
  String get rel_ops_cap_select => 'اختيار';

  @override
  String get rel_ops_cap_browser_vault => 'خزنة المتصفح';

  @override
  String
  get rel_ops_cap_saved_site_logins_addresses_and_cards_passwords_stay_in_the_secure_fields_and_are_not_listed_here =>
      'بيانات الدخول إلى المواقع والعناوين والبطاقات المحفوظة. تبقى كلمات المرور في الحقول الآمنة ولا تُعرض هنا.';

  @override
  String get rel_ops_cap_remove_saved_item => 'إزالة العنصر المحفوظ';

  @override
  String get rel_ops_cap_delete_this_item => 'حذف هذا العنصر؟';

  @override
  String get rel_ops_cap_unlocked => 'مفتوح القفل';

  @override
  String get rel_ops_cap_locked => 'مقفل';

  @override
  String get rel_ops_cap_not_detected => 'لم يُكتشف';

  @override
  String get rel_ops_cap_master_password => 'كلمة المرور الرئيسية';

  @override
  String get rel_ops_cap_login => 'بيانات الدخول';

  @override
  String get rel_ops_cap_address => 'العنوان';

  @override
  String get rel_ops_cap_card => 'البطاقة';

  @override
  String get rel_ops_cap_label => 'التسمية';

  @override
  String get rel_ops_cap_site_origin => 'أصل الموقع';

  @override
  String get rel_ops_cap_identifier => 'المعرّف';

  @override
  String get rel_ops_cap_password => 'كلمة المرور';

  @override
  String get rel_ops_cap_authenticator_key => 'مفتاح المصادقة';

  @override
  String get rel_ops_cap_street => 'الشارع';

  @override
  String get rel_ops_cap_city => 'المدينة';

  @override
  String get rel_ops_cap_postal_code => 'الرمز البريدي';

  @override
  String get rel_ops_cap_country => 'البلد';

  @override
  String get rel_ops_cap_name_on_card => 'الاسم على البطاقة';

  @override
  String get rel_ops_cap_card_number => 'رقم البطاقة';

  @override
  String get rel_ops_cap_expiry_month => 'شهر انتهاء الصلاحية';

  @override
  String get rel_ops_cap_expiry_year => 'سنة انتهاء الصلاحية';

  @override
  String get rel_ops_cap_security_code => 'رمز الأمان';

  @override
  String get rel_ops_cap_this_gateway_has_no_shared_metrics_consent_method =>
      'لا تتضمن هذه البوابة طريقة للموافقة على مشاركة المقاييس.';

  @override
  String get rel_ops_cap_agent_policy => 'سياسة الوكيل';

  @override
  String get rel_ops_cap_loading_policy => 'جارٍ تحميل السياسة';

  @override
  String get rel_ops_cap_approval_timeout => 'مهلة الموافقة';

  @override
  String get rel_ops_cap_confirm_mcp_reloads => 'تأكيد إعادة تحميل MCP';

  @override
  String get rel_ops_cap_command_allowlist => 'قائمة الأوامر المسموح بها';

  @override
  String get rel_ops_cap_file_checkpoints => 'نقاط استعادة الملفات';

  @override
  String get rel_ops_cap_checkpoint_limit => 'الحد الأقصى لنقاط الاستعادة';

  @override
  String get rel_ops_cap_browser_private_urls => 'عناوين URL الخاصة في المتصفح';

  @override
  String get rel_ops_cap_use_my_real_browser_profile =>
      'استخدام ملفي الشخصي الحقيقي للمتصفح';

  @override
  String get rel_ops_cap_save_policy => 'حفظ السياسة';

  @override
  String get rel_ops_cap_shared_metrics_for_this_profile =>
      'المقاييس المشتركة لهذا الملف الشخصي';

  @override
  String get rel_ops_cap_send_shared_metrics => 'إرسال المقاييس المشتركة';

  @override
  String get rel_ops_cap_error_enter_a_label => 'أدخل تسمية.';

  @override
  String get rel_ops_cap_error_enter_a_valid_url_like_https_example_com =>
      'أدخل عنوان URL صالحًا مثل https://example.com.';

  @override
  String get rel_ops_cap_error_enter_the_identifier_and_password =>
      'أدخل المعرّف وكلمة المرور.';

  @override
  String
  get rel_ops_cap_error_enter_the_card_name_number_expiry_and_security_code =>
      'أدخل الاسم على البطاقة ورقمها وتاريخ انتهاء صلاحيتها ورمز الأمان.';

  @override
  String get rel_ops_cap_error_enter_the_street_city_postal_code_and_country =>
      'أدخل الشارع والمدينة والرمز البريدي والبلد.';

  @override
  String
  get rel_ops_cap_error_the_gateway_returned_a_response_that_could_not_be_read =>
      'أعادت البوابة استجابة تعذّرت قراءتها.';

  @override
  String rel_ops_cap_error_the_gateway_refused_the_request_status(
    int statusCode,
  ) {
    return 'رفضت البوابة الطلب ($statusCode).';
  }

  @override
  String
  rel_ops_cap_error_this_connection_has_no_gateway_socket_so_method_is_unavailable(
    String method,
  ) {
    return 'لا يتضمن هذا الاتصال مقبسًا للبوابة، لذا فإن $method غير متاح.';
  }

  @override
  String get rel_ops_cap_error_choose_a_skill => 'اختر مهارة.';

  @override
  String get rel_ops_cap_error_the_skill_text_was_not_returned =>
      'لم يُرجع نص المهارة.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_saved => 'لم تُحفظ المهارة.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_archived =>
      'لم تُؤرشف المهارة.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_installed =>
      'لم تُثبّت المهارة.';

  @override
  String get rel_ops_cap_error_skill_updates_did_not_start =>
      'لم تبدأ تحديثات المهارات.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_removed => 'لم تُزل المهارة.';

  @override
  String get rel_ops_cap_error_enter_a_skill_or_plugin_identifier =>
      'أدخل معرّف مهارة أو ملحق.';

  @override
  String get rel_ops_cap_error_choose_a_plugin => 'اختر ملحقًا.';

  @override
  String get rel_ops_cap_error_the_plugin_was_not_removed => 'لم يُزل الملحق.';

  @override
  String get rel_ops_cap_error_the_desktop_half_was_not_removed =>
      'لم يُزل مكوّن سطح المكتب.';

  @override
  String
  get rel_ops_cap_error_this_gateway_did_not_give_the_plugin_a_stable_key =>
      'لم تمنح هذه البوابة الملحق مفتاحًا ثابتًا.';

  @override
  String get rel_ops_cap_error_the_plugin_was_not_changed => 'لم يتغير الملحق.';

  @override
  String get rel_ops_cap_error_choose_a_server => 'اختر خادمًا.';

  @override
  String get rel_ops_cap_error_name_the_server => 'أدخل اسمًا للخادم.';

  @override
  String get rel_ops_cap_error_give_the_server_a_command_or_an_http_s_url =>
      'حدّد أمرًا أو عنوان http(s) URL للخادم.';

  @override
  String get rel_ops_cap_error_choose_a_toolset => 'اختر مجموعة أدوات.';

  @override
  String get rel_ops_cap_error_tool_backend_status_was_not_returned =>
      'لم تُرجع حالة محرّك الأدوات.';

  @override
  String get rel_ops_cap_error_choose_a_provider => 'اختر مزوّدًا.';

  @override
  String get rel_ops_cap_error_this_provider_has_no_setup_action =>
      'لا يتضمن هذا المزوّد إجراء إعداد.';

  @override
  String get rel_ops_cap_error_setup_did_not_start => 'لم يبدأ الإعداد.';

  @override
  String get rel_ops_cap_error_choose_a_terminal_backend => 'اختر محرّك طرفية.';

  @override
  String get rel_ops_cap_error_name_the_connector => 'أدخل اسمًا للموصّل.';

  @override
  String get rel_ops_cap_error_choose_an_account => 'اختر حسابًا.';

  @override
  String
  get rel_ops_cap_error_reload_the_connector_policy_before_changing_tool_grants =>
      'أعد تحميل سياسة الموصّل قبل تغيير أذونات الأدوات.';

  @override
  String get rel_ops_cap_error_choose_an_item => 'اختر عنصرًا.';

  @override
  String get rel_ops_cap_error_choose_a_source => 'اختر مصدرًا.';

  @override
  String get rel_ops_cap_error_enter_the_master_password =>
      'أدخل كلمة المرور الرئيسية.';

  @override
  String get rel_ops_cap_error_gateway_config_was_not_returned =>
      'لم تُرجع إعدادات البوابة.';

  @override
  String get rel_ops_cap_error_choose_a_known_approval_mode =>
      'اختر وضع موافقة معروفًا.';

  @override
  String get rel_ops_cap_error_use_a_positive_limit => 'استخدم حدًا موجبًا.';

  @override
  String get rel_ops_cap_error_the_policy_was_not_saved => 'لم تُحفظ السياسة.';

  @override
  String get rel_ops_cap_value_manual => 'يدوي';

  @override
  String get rel_ops_cap_value_smart => 'ذكي';

  @override
  String get rel_ops_cap_value_off => 'متوقف';

  @override
  String get rel_ops_cap_value_safe => 'آمن';

  @override
  String get rel_ops_cap_value_caution => 'حذر';

  @override
  String get rel_ops_cap_value_dangerous => 'خطير';

  @override
  String get rel_ops_cap_value_blocked => 'محظور';

  @override
  String get rel_ops_cap_value_clean => 'خالٍ من التهديدات';

  @override
  String get rel_ops_cap_value_ready => 'جاهز';

  @override
  String get rel_ops_cap_value_available => 'متاح';

  @override
  String get rel_ops_cap_value_unavailable => 'غير متاح';

  @override
  String get rel_ops_cap_value_enabled => 'مفعّل';

  @override
  String get rel_ops_cap_value_disabled => 'معطّل';

  @override
  String get rel_ops_cap_value_active => 'نشط';

  @override
  String get rel_ops_cap_value_inactive => 'غير نشط';

  @override
  String get rel_ops_cap_value_installed => 'مثبّت';

  @override
  String get rel_ops_cap_value_missing => 'مفقود';

  @override
  String get rel_ops_cap_value_configured => 'مُعدّ';

  @override
  String get rel_ops_cap_value_not_configured => 'غير مُعدّ';

  @override
  String get rel_ops_cap_value_error => 'خطأ';

  @override
  String get rel_ops_cap_value_unknown => 'غير معروف';

  @override
  String get rel_ops_cap_value_login => 'بيانات الدخول';

  @override
  String get rel_ops_cap_value_address => 'عنوان';

  @override
  String get rel_ops_cap_value_payment => 'دفع';

  @override
  String get rel_ops_term_connecting => 'جارٍ الاتصال…';

  @override
  String get rel_ops_term_unbound =>
      'لا توجد جلسة نشطة مطابقة أو مجلد عمل مطابق على المضيف. افتح الدردشة المرتبطة أولًا.';

  @override
  String get rel_ops_term_unsupported =>
      'لا توفر هذه البوابة إمكانية الطرفية هذه. لم تُشغَّل أي صدفة محلية.';

  @override
  String get rel_ops_term_local_pty_unavailable =>
      'الطرفية الزائفة المحلية (PTY) المضمّنة غير متاحة على هذا الجهاز.';

  @override
  String get rel_ops_term_operation_failed =>
      'تعذّر فتح الطرفية أو التحكم بها. تحقّق من المضيف وبيانات الاعتماد والبصمة. لم تُشغَّل أي صدفة بديلة.';

  @override
  String get rel_ops_term_input_refused =>
      'رُفض الإدخال. أعد فتح الدردشة الأصلية.';

  @override
  String get rel_ops_term_cancel => 'إلغاء';

  @override
  String get rel_ops_term_confirm => 'تأكيد';

  @override
  String get rel_ops_term_open_device_title =>
      'هل تريد فتح صدفة على هذا الجهاز؟';

  @override
  String get rel_ops_term_ssh_shell => 'صدفة SSH';

  @override
  String get rel_ops_term_local_shell => 'صدفة محلية';

  @override
  String get rel_ops_term_connection_lost => 'فُقد الاتصال';

  @override
  String get rel_ops_term_shell_ended => 'انتهت الصدفة';

  @override
  String get rel_ops_term_no_owner =>
      'لا تملك هذه الدردشة جهة مصادَقًا عليها مسؤولة عن طرفية البوابة. لا يكفي عنوان URL أو تسجيل الدخول إلى السحابة وحده لإتاحة صدفة.';

  @override
  String get rel_ops_term_open_gateway_title => 'هل تريد فتح صدفة على البوابة؟';

  @override
  String get rel_ops_term_shell_expired => 'انتهت الصدفة أو انتهت صلاحيتها';

  @override
  String get rel_ops_term_disconnected => 'غير متصل';

  @override
  String get rel_ops_term_gateway_shell => 'صدفة البوابة';

  @override
  String get rel_ops_term_close_body =>
      'إنهاء هذه الصدفة. لإبقائها قيد التشغيل، أخفِ اللوحة بدلًا من ذلك.';

  @override
  String get rel_ops_term_closing => 'جارٍ الإغلاق…';

  @override
  String get rel_ops_term_close_unconfirmed => 'لم يُؤكَّد الإغلاق';

  @override
  String get rel_ops_term_processes_require_chat =>
      'تتطلب عمليات الوكيل الدردشة المرتبطة التي تمّت المصادقة عليها.';

  @override
  String get rel_ops_term_watching_processes =>
      'تجري مراقبة عمليات الوكيل في هذه الدردشة. إغلاق عرض المرآة لا يوقف العملية أبدًا.';

  @override
  String get rel_ops_term_paste_limit => 'اللصق محدود بـ 16 KiB.';

  @override
  String get rel_ops_term_paste => 'لصق';

  @override
  String get rel_ops_term_select_first => 'حدّد مخرجات الطرفية أولًا.';

  @override
  String get rel_ops_term_open_chat_to_insert =>
      'افتح الدردشة الأصلية قبل إدراج المخرجات.';

  @override
  String get rel_ops_term_added_to_draft =>
      'أُضيفت إلى مسودة الدردشة الأصلية. لم يُرسَل شيء.';

  @override
  String get rel_ops_term_close => 'إغلاق';

  @override
  String get rel_ops_term_add_selection => 'إضافة التحديد إلى مسودة الدردشة';

  @override
  String get rel_ops_term_new_terminal => 'طرفية جديدة';

  @override
  String get rel_ops_term_gateway_terminal => 'طرفية مضيف البوابة';

  @override
  String get rel_ops_term_verified_ssh_terminal => 'طرفية SSH متحقق منها';

  @override
  String get rel_ops_term_device_local_shell => 'هذا الجهاز (صدفة محلية)';

  @override
  String get rel_ops_term_local_unavailable_mobile =>
      'الصدفة المحلية غير متاحة على الأجهزة المحمولة';

  @override
  String get rel_ops_term_watch_processes => 'مراقبة عمليات الوكيل';

  @override
  String get rel_ops_term_select_output => 'تحديد المخرجات أو نسخها';

  @override
  String get rel_ops_term_add_selected_output =>
      'إضافة المخرجات المحددة إلى مسودة الدردشة';

  @override
  String get rel_ops_term_review_paste => 'مراجعة اللصق من الحافظة';

  @override
  String get rel_ops_term_reconnect => 'إعادة الاتصال بالصدفة نفسها';

  @override
  String get rel_ops_term_close_mirror => 'إغلاق عرض المرآة';

  @override
  String get rel_ops_term_close_shell => 'إغلاق الصدفة';

  @override
  String get rel_ops_term_empty =>
      'اختر + لفتح طرفية. لا تبدأ أي صدفة تلقائيًا.';

  @override
  String get rel_ops_term_reason_stale => 'متقادم';

  @override
  String get rel_ops_term_reason_mismatch => 'عدم تطابق';

  @override
  String get rel_ops_term_reason_unbound => 'غير مرتبط';

  @override
  String get rel_ops_term_reason_unsupported => 'غير مدعوم';

  @override
  String get rel_ops_term_reason_denied => 'مرفوض';

  @override
  String get rel_ops_term_reason_ineligible => 'غير مؤهل';

  @override
  String get rel_ops_term_reason_unavailable => 'غير متاح';

  @override
  String get rel_ops_term_reason_invalid => 'غير صالح';

  @override
  String get rel_ops_term_reason_insecure => 'غير آمن';

  @override
  String rel_ops_term_refused(String reason) {
    return 'رفضت البوابة عملية الطرفية هذه ($reason).';
  }

  @override
  String rel_ops_term_open_device_body(String connection) {
    return 'هذا هو الجهاز الذي يشغّل Ares، وليس $connection. تستخدم الصدفة أذونات التطبيق وتبدأ في مساحة تخزينه.';
  }

  @override
  String rel_ops_term_open_gateway_body(String host) {
    return 'ابدأ صدفة على $host في مجلد العمل المتحقق منه للدردشة. هذه ليست صدفة على الجهاز المحلي.';
  }

  @override
  String rel_ops_term_close_tab_title(String label) {
    return 'هل تريد إغلاق $label؟';
  }

  @override
  String rel_ops_term_read_only_status(String status) {
    return 'للقراءة فقط · $status';
  }

  @override
  String rel_ops_term_paste_title(String label) {
    return 'هل تريد اللصق في $label؟';
  }

  @override
  String rel_ops_term_output_title(String label) {
    return 'المخرجات · $label';
  }

  @override
  String rel_ops_term_mirror_status(String label) {
    return 'عرض مرآة للعملية للقراءة فقط · $label';
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
    return 'هذا الجهاز · $number';
  }

  @override
  String rel_ops_term_gateway_tab(String host, int number) {
    return 'البوابة $host · $number';
  }

  @override
  String get rel_ops_term_earlier_output_trimmed =>
      '[اقتُطعت المخرجات السابقة]';

  @override
  String get rel_ops_term_ssh_dialog_title => 'فتح طرفية SSH متحقق منها';

  @override
  String get rel_ops_term_ssh_dialog_body =>
      'استخدم بصمة حصلت عليها بشكل مستقل من مسؤول المضيف. يفتح هذا جلسة دخول بعيدة جديدة، وليس البوابة أو صدفة محلية.';

  @override
  String get rel_ops_term_ssh_host => 'مضيف SSH';

  @override
  String get rel_ops_term_ssh_port => 'المنفذ';

  @override
  String get rel_ops_term_ssh_user => 'المستخدم';

  @override
  String get rel_ops_term_ssh_fingerprint => 'بصمة مفتاح المضيف (SHA256:…)';

  @override
  String get rel_ops_term_ssh_password => 'كلمة مرور SSH (لا تُحفظ)';

  @override
  String get rel_ops_term_connect => 'اتصال';

  @override
  String get rel_ops_ssh_invalid_destination =>
      'مضيف SSH أو المنفذ أو المستخدم غير صالح.';

  @override
  String get rel_ops_ssh_public_key_required =>
      'يلزم مفتاح مضيف عام بصيغة OpenSSH Ed25519.';

  @override
  String get rel_ops_ssh_invalid_public_key => 'مفتاح مضيف Ed25519 غير صالح.';

  @override
  String get rel_ops_ssh_invalid_saved_key => 'مفتاح المضيف المحفوظ غير صالح.';

  @override
  String get rel_ops_ssh_enrollment_unverified =>
      'تعذّر التحقق من تسجيل مفتاح المضيف.';

  @override
  String get rel_ops_ssh_different_key_pinned =>
      'هناك مفتاح مختلف مثبّت بالفعل. تحقّق من التغيير بشكل منفصل.';

  @override
  String get rel_ops_ssh_open_ssh_unavailable => 'لا يتوفر OpenSSH على النظام.';

  @override
  String get rel_ops_ssh_confirm_host_key => 'أكّد مفتاح المضيف قبل الاتصال.';

  @override
  String get rel_ops_ssh_absolute_identity_required =>
      'اختر ملف هوية ذا مسار مطلق.';

  @override
  String get rel_ops_ssh_invalid_remote_port => 'المنفذ البعيد غير صالح.';

  @override
  String get rel_ops_ssh_preview_too_large =>
      'تتجاوز المعاينة الحد الأقصى البالغ 64 KiB.';

  @override
  String get rel_ops_ssh_connection_refused =>
      'رُفض اتصال SSH. تحقّق من مفتاح المضيف المسجّل والهوية والخدمة.';

  @override
  String get rel_ops_ssh_http_not_ok => 'لم تُرجع الخدمة البعيدة HTTP 200.';

  @override
  String get rel_ops_ssh_encoded_response =>
      'لا تدعم هذه المعاينة الاستجابات المرمّزة.';

  @override
  String get rel_ops_ssh_preview_type_unsupported =>
      'يمكن معاينة النصوص وشيفرة HTML المصدرية فقط.';

  @override
  String get rel_ops_ssh_health_unconfirmed => 'لم تؤكّد الخدمة سلامة البوابة.';

  @override
  String get rel_ops_ssh_enroll_host_key_first =>
      'سجّل المفتاح العام للمضيف أولًا.';

  @override
  String get rel_ops_ssh_cancel => 'إلغاء';

  @override
  String get rel_ops_ssh_confirm => 'تأكيد';

  @override
  String get rel_ops_ssh_pin_title => 'هل تريد تثبيت مفتاح مضيف SSH هذا؟';

  @override
  String rel_ops_ssh_pin_detail(String destination, String fingerprint) {
    return '$destination\n$fingerprint\nقارن هذه البصمة مع مسؤول المضيف عبر قناة مستقلة. لن يتم إجراء أي اتصال.';
  }

  @override
  String get rel_ops_ssh_host_key_pinned => 'تم تثبيت مفتاح المضيف.';

  @override
  String get rel_ops_ssh_shell_detail => 'افتح صدفة تسجيل دخول تفاعلية.';

  @override
  String rel_ops_ssh_read_detail(String path, int port) {
    return 'اقرأ $path على العنوان البعيد 127.0.0.1:$port عبر قناة SSH.';
  }

  @override
  String rel_ops_ssh_connect_title(String destination) {
    return 'هل تريد الاتصال بـ $destination؟';
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
  String get rel_ops_ssh_agent_auth => 'صادِق باستخدام وكيل SSH الخاص بك.';

  @override
  String get rel_ops_ssh_identity_auth => 'استخدم ملف الهوية المحدّد.';

  @override
  String rel_ops_ssh_gateway_responding(int port) {
    return 'تستجيب البوابة على منفذ الاسترجاع البعيد $port.';
  }

  @override
  String get rel_ops_ssh_session_closed => 'أُغلقت جلسة SSH.';

  @override
  String get rel_ops_ssh_session_unclean => 'انتهت جلسة SSH دون خروج سليم.';

  @override
  String get rel_ops_ssh_operation_failed =>
      'فشلت عملية SSH. تحقّق من الوجهة والهوية.';

  @override
  String get rel_ops_ssh_title => 'SSH متحقَّق منه';

  @override
  String get rel_ops_ssh_unsupported =>
      'لا تتوفر على هذا الجهاز وسيلة نقل مدعومة عبر OpenSSH الخاص بالنظام. يقبل مرحّل البوابة المثبّت مفاتيح جديدة تلقائيًا ولا يمكن استخدامه للتسجيل المتحقَّق منه.';

  @override
  String get rel_ops_ssh_host => 'مضيف SSH';

  @override
  String get rel_ops_ssh_port => 'منفذ SSH';

  @override
  String get rel_ops_ssh_user => 'مستخدم SSH';

  @override
  String get rel_ops_ssh_identity =>
      'ملف الهوية (اختياري؛ يُستخدم وكيل SSH بخلاف ذلك)';

  @override
  String get rel_ops_ssh_public_key =>
      'مفتاح المضيف العام من المسؤول (ssh-ed25519)';

  @override
  String get rel_ops_ssh_review_key => 'مراجعة مفتاح المضيف';

  @override
  String get rel_ops_ssh_remote_port => 'منفذ خدمة الاسترجاع البعيدة';

  @override
  String get rel_ops_ssh_check_gateway => 'فحص البوابة عبر SSH';

  @override
  String get rel_ops_ssh_preview_source => 'معاينة الشيفرة المصدرية عبر SSH';

  @override
  String get rel_ops_ssh_open_shell => 'فتح صدفة SSH';

  @override
  String get rel_ops_ssh_shell_line => 'سطر لإرساله إلى الصدفة البعيدة';

  @override
  String get rel_ops_ssh_disconnect => 'قطع اتصال الصدفة';

  @override
  String get rel_ops_host_cancel => 'إلغاء';

  @override
  String get rel_ops_host_confirm => 'تأكيد';

  @override
  String get rel_ops_host_title => 'المضيف';

  @override
  String get rel_ops_host_refresh => 'تحديث';

  @override
  String get rel_ops_host_update => 'تحديث Hermes البعيد';

  @override
  String rel_ops_host_update_confirmation(String profile) {
    return 'سيبدأ هذا تحديثًا موضعيًا على مضيف البوابة للملف الشخصي $profile. لن يُحدّث Ares على هذا الجهاز. يُثبت النجاح إيصال التحديث المطابق، وليس استمرار إمكانية الوصول إلى المضيف.';
  }

  @override
  String get rel_ops_host_update_awaiting =>
      'بانتظار الإيصال المطابق. ما زال التحديث جاريًا.';

  @override
  String get rel_ops_host_receipt_success => 'يشير إيصال التحديث إلى النجاح.';

  @override
  String get rel_ops_host_receipt_partial =>
      'تم تطبيق التحديث، ولا تزال هناك خطوات متابعة مطلوبة.';

  @override
  String get rel_ops_host_receipt_failed => 'يشير إيصال التحديث إلى الفشل.';

  @override
  String get rel_ops_host_receipt_refused => 'يشير إيصال التحديث إلى الرفض.';

  @override
  String get rel_ops_host_update_running => 'ما زال التحديث جاريًا.';

  @override
  String get rel_ops_host_update_unknown =>
      'نتيجة التحديث غير معروفة. عمل البوابة لا يعني نجاح التحديث.';

  @override
  String get rel_ops_host_default_profile => 'الملف الشخصي الافتراضي للبوابة';

  @override
  String get rel_ops_host_restart => 'إعادة تشغيل البوابة البعيدة';

  @override
  String rel_ops_host_restart_shared_confirmation(String profiles) {
    return 'سيؤدي هذا إلى إعادة تشغيل البوابة المشتركة بين $profiles. ستنقطع الجولات الجارية على هذه البوابة. أعد الاتصال بعد ذلك. إمكانية الوصول لا تثبت اكتمال إعادة التشغيل.';
  }

  @override
  String rel_ops_host_restart_confirmation(String profile) {
    return 'سيؤدي هذا إلى إعادة تشغيل البوابة البعيدة للملف الشخصي $profile. ستنقطع الجولات الجارية على هذه البوابة. أعد الاتصال بعد ذلك.';
  }

  @override
  String get rel_ops_host_restart_running => 'ما زال أمر إعادة التشغيل جاريًا.';

  @override
  String get rel_ops_host_restart_finished =>
      'اكتمل أمر إعادة التشغيل. أعد الاتصال بالمضيف بنفسك.';

  @override
  String get rel_ops_host_restart_failed => 'فشل أمر إعادة التشغيل.';

  @override
  String rel_ops_host_maintenance_running(String name) {
    return 'ما زال $name جاريًا';
  }

  @override
  String rel_ops_host_maintenance_finished(String name) {
    return 'اكتمل $name';
  }

  @override
  String rel_ops_host_maintenance_failed(String name) {
    return 'فشل $name';
  }

  @override
  String get rel_ops_host_curator_paused_result =>
      'تم إيقاف منسّق المهارات مؤقتًا.';

  @override
  String get rel_ops_host_curator_resumed_result =>
      'تم استئناف منسّق المهارات.';

  @override
  String get rel_ops_host_reset => 'إعادة ضبط ملفات الذاكرة البعيدة';

  @override
  String rel_ops_host_reset_confirmation(String targetName, String profile) {
    return 'هل تريد حذف ملف الذاكرة $targetName على $profile؟ لا يمكن التراجع عن هذا من Ares.';
  }

  @override
  String rel_ops_host_reset_result(String targetName, int count) {
    return 'تمت إعادة ضبط $targetName. عدد الملفات البعيدة المحذوفة: $count.';
  }

  @override
  String get rel_ops_host_share_not_redacted =>
      'لم يؤكّد المضيف إخفاء المعلومات الحساسة في الحزمة. لن يُعرض أي رابط.';

  @override
  String rel_ops_host_scope(String connection, String profile) {
    return 'تتحكم هذه الأدوات في البوابة البعيدة $connection للملف الشخصي $profile، وليس في هذا الجهاز أو تحديث تطبيق Ares.';
  }

  @override
  String rel_ops_host_health_running(String version, int count) {
    return 'عملية البوابة قيد التشغيل $version · عدد الجلسات: $count';
  }

  @override
  String rel_ops_host_health_stopped(String version, int count) {
    return 'عملية البوابة متوقفة $version · عدد الجلسات: $count';
  }

  @override
  String rel_ops_host_heartbeat_stale(num seconds) {
    return 'إشارة نبض المضيف قديمة ($seconds ث).';
  }

  @override
  String get rel_ops_host_doctor => 'تشغيل Doctor';

  @override
  String get rel_ops_host_security_audit => 'تدقيق الأمان';

  @override
  String get rel_ops_host_check_receipt => 'التحقق من إيصال التحديث';

  @override
  String get rel_ops_host_logs => 'سجلات المضيف البعيد';

  @override
  String get rel_ops_host_search_logs => 'البحث في سجلات المضيف';

  @override
  String get rel_ops_host_driver => 'برنامج تشغيل المضيف البعيد';

  @override
  String get rel_ops_host_driver_scope =>
      'تعتمد جاهزية استخدام الحاسوب على برنامج التشغيل وأذونات نظام التشغيل على جهاز البوابة، وليس هذا الجهاز.';

  @override
  String rel_ops_host_computer_status(
    String platform,
    String installed,
    String ready,
  ) {
    return '$platform · مثبّت: $installed · جاهز: $ready';
  }

  @override
  String get rel_ops_host_null => 'غير متاح';

  @override
  String get rel_ops_host_true => 'نعم';

  @override
  String get rel_ops_host_false => 'لا';

  @override
  String get rel_ops_host_curator => 'منسّق المهارات';

  @override
  String get rel_ops_host_curator_paused => 'منسّق المهارات متوقف مؤقتًا';

  @override
  String get rel_ops_host_curator_running => 'منسّق المهارات قيد التشغيل';

  @override
  String get rel_ops_host_no_run => 'لا توجد عملية تشغيل مكتملة';

  @override
  String get rel_ops_host_run_curator => 'تشغيل منسّق المهارات الآن';

  @override
  String get rel_ops_host_reset_memory => 'إعادة ضبط ملف الذاكرة';

  @override
  String get rel_ops_host_reset_user => 'إعادة ضبط ملف المستخدم';

  @override
  String get rel_ops_host_reset_both => 'إعادة ضبط الملفين';

  @override
  String get rel_ops_host_share_consent =>
      'أوافق على رفع حزمة تشخيصية بعد إخفاء معلوماتها الحساسة من المضيف البعيد';

  @override
  String get rel_ops_host_share =>
      'مشاركة بيانات تشخيصية بعد إخفاء المعلومات الحساسة';

  @override
  String get rel_ops_host_update_unknown_installation =>
      'هذا التثبيت غير معروف، لذا لم يُرسَل طلب التحديث';

  @override
  String get rel_ops_host_update_busy_installation =>
      'توجد محادثة جارية على هذا التثبيت';

  @override
  String get rel_ops_host_update_refused => 'رُفض التحديث البعيد';

  @override
  String get rel_ops_host_error_stale => 'مساحة العمل البعيدة: قديمة';

  @override
  String get rel_ops_host_error_mismatch => 'مساحة العمل البعيدة: غير متطابقة';

  @override
  String get rel_ops_host_error_unbound => 'مساحة العمل البعيدة: غير مرتبطة';

  @override
  String get rel_ops_host_error_unsupported =>
      'مساحة العمل البعيدة: غير مدعومة';

  @override
  String get rel_ops_host_error_denied => 'مساحة العمل البعيدة: رُفض الوصول';

  @override
  String get rel_ops_host_error_ineligible => 'مساحة العمل البعيدة: غير مؤهلة';

  @override
  String get rel_ops_host_error_unavailable => 'مساحة العمل البعيدة: غير متاحة';

  @override
  String get rel_ops_host_error_invalid => 'مساحة العمل البعيدة: غير صالحة';

  @override
  String get rel_ops_host_error_insecure => 'مساحة العمل البعيدة: غير آمنة';

  @override
  String get rel_ops_host_error_request => 'تعذّر إكمال هذا الطلب.';

  @override
  String get rel_svc_push_api_select_sessions =>
      'اختر من 1 إلى 128 معرّف جلسة دائمًا، بطول 1–200 حرف ASCII لكل منها، باستخدام الحروف والأرقام و _ . : @ أو - فقط. أزل المعرّفات الفارغة والمسافات البيضاء.';

  @override
  String get rel_svc_push_api_unavailable =>
      'الدفع إلى الهاتف غير متاح على هذا الخادم.';

  @override
  String get rel_svc_push_api_invalid_vapid =>
      'مفتاح VAPID العام للخادم غير صالح.';

  @override
  String get rel_svc_push_api_update_plugin =>
      'يحتاج هذا الخادم إلى إصدار محدّث من إضافة mobile-push للاشتراكات التلقائية.';

  @override
  String get rel_svc_push_status_android_only => 'Android فقط';

  @override
  String get rel_svc_push_native_prefs_sync_failed =>
      'تعذّرت مزامنة تفضيلات الإشعارات الأصلية.';

  @override
  String get rel_svc_push_choose_android_connection =>
      'اختر اتصالًا محفوظًا على Android أولًا.';

  @override
  String get rel_svc_push_status_checking_authorization =>
      'جارٍ التحقق من تفويض الخادم';

  @override
  String get rel_svc_push_revoke_persist_failed =>
      'تعذّر حفظ الإلغاء. أعد محاولة التعطيل قبل مغادرة التطبيق.';

  @override
  String get rel_svc_push_status_off_api_ready =>
      'متوقف؛ واجهة API للخادم جاهزة';

  @override
  String get rel_svc_push_status_off_revoke_pending =>
      'متوقف؛ إلغاء الخادم معلّق';

  @override
  String get rel_svc_push_status_off_connection_changed =>
      'متوقف؛ تغيّر الاتصال المحفوظ';

  @override
  String get rel_svc_push_status_pending_endpoint =>
      'في انتظار نقطة نهاية الموزّع';

  @override
  String get rel_svc_push_status_registering => 'جارٍ التسجيل';

  @override
  String get rel_svc_push_status_pending_challenge =>
      'تحدٍ مشفّر معلّق (في انتظار دفع صامت للتحقق من الخادم)';

  @override
  String get rel_svc_push_allow_android_notifications_retry =>
      'اسمح بإشعارات Android في إعدادات النظام، ثم أعد المحاولة.';

  @override
  String get rel_svc_push_plugin_invalid =>
      'إضافة mobile-push على الخادم غير متاحة أو قديمة أو أعادت استجابة اشتراك غير صالحة. اطلب من المشغّل تحديثها، ثم أعد المحاولة.';

  @override
  String get rel_svc_push_transport_unavailable =>
      'لا تتوفر وسيلة نقل للدفع. يحتاج التسليم المضمّن إلى Google Play Services عاملة؛ أو ثبّت موزّع UnifiedPush وأعد المحاولة.';

  @override
  String get rel_svc_push_transport_choice =>
      'يتوفر عدة موزّعين لـ UnifiedPush. اختر واحدًا في النقل المتقدم، ثم أعد المحاولة.';

  @override
  String get rel_svc_push_transport_missing =>
      'موزّع UnifiedPush المحدد غير متاح. استعده أو اختر موزّعًا آخر في النقل المتقدم.';

  @override
  String get rel_svc_push_companion_unavailable =>
      'مرافق mobile-push على الخادم غير متاح. قد يكون مفقودًا أو معطلًا، أو قد يشير هذا الاتصال إلى لوحة معلومات خاطئة. ثبّت المرافق أو فعّله على الخادم، وتحقق من اتصال لوحة المعلومات، ثم حدّث. راجع دليل إعداد الخادم أعلاه.';

  @override
  String get rel_svc_push_server_denied =>
      'رفض الخادم الدفع إلى الهاتف. اطلب من المشغّل تفويض هذا المستخدم وهذه الجلسات.';

  @override
  String get rel_svc_push_not_ready =>
      'الدفع إلى الهاتف غير جاهز. تحقق من تفويض إضافة الخادم والموزّع والشبكة، ثم أعد المحاولة.';

  @override
  String get rel_svc_push_availability_read_failed =>
      'تعذّرت قراءة توفر دفع Android. أعد المحاولة أدناه.';

  @override
  String get rel_svc_push_setup_failed =>
      'فشل إعداد الدفع. تحقق من إذن Android وتفويض الخادم والنقل، ثم أعد المحاولة.';

  @override
  String rel_svc_push_status(String status) {
    return 'الحالة: $status';
  }

  @override
  String rel_svc_push_status_bound(
    String bound,
    String connection,
    String status,
  ) {
    return 'الحالة: مرتبط بـ $bound (غير نشط لـ $connection؛ المصافحة: $status)';
  }

  @override
  String get rel_svc_push_another_saved_connection => 'اتصال محفوظ آخر';

  @override
  String get rel_svc_push_background_notifications => 'إشعارات الخلفية';

  @override
  String rel_svc_push_bound_subtitle(String bound, String connection) {
    return 'مرتبط بـ $bound — ألغِ هذا الارتباط أدناه قبل التفعيل لـ $connection';
  }

  @override
  String rel_svc_push_private_activity(String connection) {
    return 'نشاط خادم خاص لـ $connection';
  }

  @override
  String rel_svc_push_bound_warning_named(String bound) {
    return 'مرتبط باتصال محفوظ آخر ($bound). عطّل هذا الارتباط وألغِه قبل التفعيل لهذا الاتصال.';
  }

  @override
  String get rel_svc_push_bound_warning =>
      'مرتبط باتصال محفوظ آخر. عطّل هذا الارتباط وألغِه قبل التفعيل لهذا الاتصال.';

  @override
  String get rel_svc_push_local_notifications_muted =>
      'الإشعارات المحلية متوقفة أعلاه. لم تتغير موافقة إشعارات الخلفية، لكن تلميحات النشاط العادية مكتومة حتى تفعيل \"تفعيل الإشعارات\".';

  @override
  String rel_svc_push_legacy_subscription(int count) {
    return 'اشتراك قديم: $count جلسة محددة فقط. لن يتوسع تلقائيًا. أوقفه ثم شغّله للاشتراك في الجلسات التي يفوضها الخادم.';
  }

  @override
  String get rel_svc_push_authorized_binding =>
      'مرتبط فقط بهذا الاتصال المحفوظ والملف الشخصي. يتبع الوصول إلى الجلسات تفويض الخادم الحالي.';

  @override
  String get rel_svc_push_revocation_pending =>
      'إلغاء الخادم معلّق. التسليم المحلي متوقف؛ أعد المحاولة أثناء توفر تسجيل الدخول المحفوظ الأصلي.';

  @override
  String get rel_svc_push_refresh_retry => 'تحديث / إعادة المحاولة';

  @override
  String rel_svc_push_disable_named(String bound) {
    return 'تعطيل وإلغاء $bound';
  }

  @override
  String get rel_svc_push_other_connection => 'اتصال آخر';

  @override
  String get rel_svc_push_disable => 'تعطيل وإلغاء';

  @override
  String get rel_svc_push_refresh_explanation =>
      'يعيد التحديث / المحاولة التحقق من التوفر بعد إعداد الخادم؛ ولا يمكنه تثبيت المرافق. يظل تفعيل الإشعارات خيارًا منفصلًا.';

  @override
  String get rel_svc_push_companion_required =>
      'تتطلب إشعارات الخلفية مرافق mobile-push على الخادم مثبّتًا ومفعّلًا بشكل منفصل. لا يستطيع Android تثبيته. تحديث APK وحده لا يعدّ الخادم.';

  @override
  String get rel_svc_push_server_setup_guide => 'دليل إعداد الخادم';

  @override
  String get rel_svc_push_enable_disclosure =>
      'فعّل لطلب إذن إشعارات Android ومشاركة نقطة نهاية هذا التثبيت ومفاتيح التشفير مع هذا الخادم. لا تحتوي تلميحات النشاط المشفرة على محتوى دردشة. لا تُضمّن إلا الجلسات التي يفوضها تسجيل دخولك إلى الخادم.';

  @override
  String get rel_svc_push_transport_disclosure =>
      'يستخدم التسليم المضمّن نقل الدفع من Google ويحتاج إلى Google Play Services، لكنه لا يتضمن Firebase SDK. يمكن استخدام موزّع UnifiedPush اختياري بدلًا منه. التسليم بأفضل جهد؛ أعد فتح Hermes للمزامنة.';

  @override
  String get rel_svc_push_advanced_transport => 'النقل المتقدم';

  @override
  String get rel_svc_push_automatic_explanation =>
      'يحافظ الوضع التلقائي على اختيار الموزّع الحالي، وإلا يستخدم تسليم Google المضمّن عند توفره. عطّل قبل تغيير النقل.';

  @override
  String get rel_svc_push_transport_label => 'نقل الدفع';

  @override
  String get rel_svc_push_automatic_recommended => 'تلقائي (موصى به)';

  @override
  String get rel_svc_push_selected_unavailable => 'الموزّع المحدد (غير متاح)';

  @override
  String get rel_svc_push_no_transport_detected =>
      'لم يُكتشف نقل متاح. يحتاج التسليم المضمّن إلى Google Play Services؛ وبدونها ثبّت موزّع UnifiedPush واضبطه، ثم حدّث.';

  @override
  String get rel_svc_push_channel_turns_name => 'جولات Ares';

  @override
  String get rel_svc_push_channel_turns_description =>
      'إشعارات الجولات المكتملة في الخلفية';

  @override
  String get rel_svc_push_channel_attention_name => 'تنبيهات Ares';

  @override
  String get rel_svc_push_channel_attention_description =>
      'الموافقات وطلبات الإدخال التي تحتاج إليك';

  @override
  String get rel_svc_push_channel_background_name => 'خلفية Ares';

  @override
  String get rel_svc_push_channel_background_description =>
      'اكتمال مهام الخلفية';

  @override
  String get rel_svc_push_channel_notices_name => 'إشعارات Ares';

  @override
  String get rel_svc_push_channel_notices_description =>
      'إشعارات الرصيد والإضافات';

  @override
  String get rel_svc_push_diag_not_initialised => 'لم تتم التهيئة';

  @override
  String get rel_svc_push_diag_replies_off => 'إشعارات الردود متوقفة';

  @override
  String get rel_svc_push_diag_conversation => 'محادثة';

  @override
  String get rel_svc_push_diag_conversation_permission_denied =>
      'محادثة؛ الإذن مرفوض';

  @override
  String rel_svc_push_diag_conversation_error(String error) {
    return 'محادثة: $error';
  }

  @override
  String get rel_svc_push_diag_failures_off => 'إشعارات الفشل متوقفة';

  @override
  String rel_svc_push_diag_kind_off(String kind) {
    return '$kind متوقف';
  }

  @override
  String get rel_svc_push_diag_windows_setting_unknown =>
      'لم يبلغ Windows عن إعداد الإشعارات';

  @override
  String get rel_svc_backup_not_hermes_configuration_backup =>
      'هذا الملف ليس نسخة احتياطية لإعدادات Hermes.';

  @override
  String get rel_svc_backup_newer_version_cannot_import =>
      'أُنشئت هذه النسخة الاحتياطية بإصدار أحدث من التطبيق ولا يمكن استيرادها.';

  @override
  String get rel_svc_backup_missing_client_certificate =>
      'تشير هذه النسخة الاحتياطية إلى شهادة عميل لاتصال لكنها لا تحتوي عليها، لذا لا يمكن إجراء استعادة كاملة.';

  @override
  String get rel_svc_backup_damaged_unreadable =>
      'ملف النسخة الاحتياطية هذا تالف وتعذرت قراءته.';

  @override
  String get rel_svc_backup_unsupported_preference_type =>
      'لأحد التفضيلات المحفوظة نوع غير مدعوم ولا يمكن تصديره.';

  @override
  String get rel_svc_backup_choose_passphrase_api_keys =>
      'اختر عبارة مرور — تحتوي النسخة الاحتياطية على مفاتيح API الخاصة بك.';

  @override
  String get rel_svc_backup_could_not_protect_safely =>
      'تعذرت حماية النسخة الاحتياطية بأمان.';

  @override
  String get rel_svc_backup_unsupported_encryption =>
      'تستخدم هذه النسخة الاحتياطية نظام تشفير غير مدعوم.';

  @override
  String get rel_svc_backup_wrong_passphrase_or_altered =>
      'عبارة المرور غير صحيحة، أو تم تعديل ملف النسخة الاحتياطية هذا.';

  @override
  String get rel_svc_backup_share_subject => 'نسخة احتياطية لإعدادات Hermes';

  @override
  String get rel_svc_backup_selected_file_unreadable =>
      'تعذرت قراءة هذا الملف.';

  @override
  String rel_svc_backup_connections_added(int count) {
    return 'تمت إضافة $count';
  }

  @override
  String rel_svc_backup_connections_updated(int count) {
    return 'تم تحديث $count';
  }

  @override
  String rel_svc_backup_connections_removed(int count) {
    return 'تمت إزالة $count';
  }

  @override
  String get rel_svc_backup_no_connection_changes => 'لا تغييرات في الاتصالات';

  @override
  String rel_svc_backup_connections_summary(String changes) {
    return 'الاتصالات: $changes';
  }

  @override
  String rel_svc_backup_restore_summary(String connections, int count) {
    return '$connections · تمت استعادة $count من الإعدادات';
  }

  @override
  String rel_svc_backup_certificate_not_included(String label, String error) {
    return 'تعذر تضمين شهادة العميل لـ \"$label\" في هذه النسخة الاحتياطية: $error';
  }

  @override
  String get rel_svc_backup_certificate_password_needed =>
      'تحتاج هذه الشهادة إلى كلمة مرورها. أدخلها أدناه وستُفتح تلقائيًا.';

  @override
  String get rel_svc_backup_certificate_password_or_corrupt =>
      'كلمة مرور الشهادة غير صحيحة، أو أن الملف تالف.';

  @override
  String get rel_svc_backup_certificate_password_incorrect =>
      'كلمة مرور الشهادة غير صحيحة.';

  @override
  String get rel_svc_backup_certificate_unsupported_encryption =>
      'تستخدم هذه الشهادة طريقة تشفير لا يستطيع التطبيق قراءتها.';

  @override
  String get rel_svc_backup_certificate_unreadable_pkcs12 =>
      'الملف المحدد ليس شهادة PKCS#12 ‏(.p12/.pfx) قابلة للقراءة.';

  @override
  String get rel_svc_backup_certificate_unreadable =>
      'تعذرت قراءة الشهادة المحددة.';

  @override
  String get rel_svc_backup_not_certificate_file =>
      'هذا الملف ليس شهادة: اختر حاوية .p12/.pfx أو ملفات شهادة ومفتاح PEM.';

  @override
  String get rel_svc_backup_not_pem_certificate =>
      'الشهادة المحددة ليست شهادة PEM.';

  @override
  String get rel_svc_backup_not_pem_private_key =>
      'المفتاح الخاص المحدد ليس مفتاح PEM خاصًا.';

  @override
  String get rel_svc_backup_certificate_pair_unloadable =>
      'تعذر تحميل الشهادة والمفتاح الخاص المحددين.';

  @override
  String get rel_svc_backup_saved_certificate_files_unreadable =>
      'تعذرت قراءة ملفات شهادة العميل المحفوظة.';

  @override
  String get rel_svc_backup_client_certificate_storage_failed =>
      'تعذر تخزين شهادة العميل بأمان على هذا الجهاز.';

  @override
  String get rel_svc_backup_certificate_storage_failed =>
      'تعذر تخزين الشهادة بأمان على هذا الجهاز.';

  @override
  String get rel_svc_backup_client_certificate_label => 'شهادة العميل';

  @override
  String rel_svc_backup_search_dashboard_unreachable(String error) {
    return 'تعذر الوصول إلى لوحة التحكم: $error';
  }

  @override
  String get rel_svc_backup_search_credentials_rejected =>
      'رفضت لوحة التحكم بيانات الاعتماد المحفوظة. تحقق من اسم المستخدم وكلمة المرور للوحة التحكم لهذا الاتصال.';

  @override
  String get rel_svc_backup_search_not_supported =>
      'لا توفر لوحة التحكم هذه البحث في الجلسات. حدّث Hermes على المضيف أو عُد إلى البحث على الجهاز.';

  @override
  String rel_svc_backup_search_redirected(int statusCode) {
    return 'أعادت لوحة التحكم توجيه بحث الجلسات (HTTP $statusCode). لا يتبع Ares عمليات إعادة التوجيه مع بيانات الاعتماد المحفوظة؛ تحقق من عنوان الاتصال.';
  }

  @override
  String rel_svc_backup_search_http_failed(int statusCode) {
    return 'فشل بحث الجلسات مع HTTP $statusCode.';
  }

  @override
  String get rel_svc_backup_search_malformed_response =>
      'أعادت لوحة التحكم استجابة بحث مشوهة.';

  @override
  String get rel_svc_backup_search_unexpected_response =>
      'أعادت لوحة التحكم استجابة بحث غير متوقعة.';

  @override
  String get rel_svc_backup_search_too_many_results =>
      'أعادت لوحة التحكم نتائج بحث أكثر من المطلوب.';

  @override
  String get rel_svc_backup_message_search_unexpected_response =>
      'استجابة بحث رسائل غير متوقعة.';

  @override
  String get rel_svc_backup_message_search_unexpected_result =>
      'نتيجة بحث رسائل غير متوقعة.';

  @override
  String get rel_svc_backup_ai_search_api_key_rejected =>
      'رفضت واجهة Hermes API مفتاح API المحفوظ.';

  @override
  String rel_svc_backup_ai_search_http_failed(int statusCode) {
    return 'فشلت إعادة صياغة استعلام الذكاء الاصطناعي مع HTTP $statusCode.';
  }

  @override
  String get rel_svc_backup_ai_search_no_usable_query =>
      'لم يُرجع النموذج المحدد استعلام بحث صالحًا للاستخدام.';

  @override
  String get rel_svc_backup_ai_search_malformed_response =>
      'أعاد Hermes استجابة إعادة صياغة بالذكاء الاصطناعي مشوهة.';

  @override
  String get rel_svc_backup_space_name_already_exists =>
      'توجد بالفعل مساحة بهذا الاسم';

  @override
  String get rel_svc_backup_space_name_length_invalid =>
      'يجب أن يتكون اسم المساحة من 1 إلى 80 حرفًا';

  @override
  String get ng_rel_svc_backup_gateway_address_required =>
      'أدخل عنوان لوحة تحكم Hermes.';

  @override
  String ng_rel_svc_backup_gateway_address_scheme(String scheme) {
    return 'يجب أن يبدأ العنوان بـ http:// أو https:// (تم إدخال $scheme).';
  }

  @override
  String get ng_rel_svc_backup_gateway_address_invalid =>
      'هذا العنوان غير صالح.';

  @override
  String get ng_rel_svc_backup_gateway_address_no_host =>
      'لا يحتوي العنوان على اسم مضيف.';

  @override
  String get ng_rel_svc_backup_sign_in_main_window =>
      'سجّل الدخول في النافذة الرئيسية.';

  @override
  String get rel_svc_backup_sign_in_renewal_failed =>
      'تعذر على البوابة تجديد تسجيل الدخول الآن.';

  @override
  String get rel_svc_backup_sign_in_provider_unreachable =>
      'تعذر على البوابة تجديد تسجيل الدخول: موفر تسجيل الدخول غير قابل للوصول.';

  @override
  String get rel_svc_backup_sign_in_renewal_timed_out =>
      'انتهت مهلة تجديد تسجيل الدخول.';

  @override
  String get rel_svc_backup_sign_in_no_tokens =>
      'لم تُرجع البوابة رموز تسجيل دخول.';

  @override
  String get ng_rel_svc_backup_probe_timed_out =>
      'انتهت المهلة. تحقق من العنوان أو اتصال VPN أو Tailscale.';

  @override
  String ng_rel_svc_backup_probe_tls_failed(String error) {
    return 'فشلت مصافحة TLS: $error';
  }

  @override
  String ng_rel_svc_backup_gateway_answered_http(int statusCode) {
    return 'استجابت البوابة برمز HTTP $statusCode.';
  }

  @override
  String get ng_rel_svc_backup_gateway_answer_timed_out =>
      'استغرقت البوابة وقتًا أطول من اللازم للاستجابة.';

  @override
  String ng_rel_svc_backup_browser_callback_not_ready(String error) {
    return 'تعذر الاستعداد لعودة المتصفح: $error';
  }

  @override
  String get ng_rel_svc_backup_browser_signed_in_body =>
      'يمكنك العودة إلى Hermes الآن.';

  @override
  String get ng_rel_svc_backup_browser_waiting_title =>
      'في انتظار تسجيل الدخول';

  @override
  String get ng_rel_svc_backup_browser_not_current =>
      'هذه الصفحة ليست جزءًا من تسجيل الدخول الحالي.';

  @override
  String get ng_rel_svc_backup_browser_open_failed =>
      'تعذر فتح المتصفح لتسجيل الدخول.';

  @override
  String get ng_rel_svc_backup_browser_sign_in_timed_out =>
      'استغرق تسجيل الدخول وقتًا أطول من اللازم. حاول مرة أخرى.';

  @override
  String ng_rel_svc_backup_gateway_refused_sign_in(int statusCode) {
    return 'رفضت البوابة تسجيل الدخول (HTTP $statusCode).';
  }

  @override
  String get rel_svc_misc_alert_caution => 'تنبيه';

  @override
  String get rel_svc_misc_alert_important => 'مهم';

  @override
  String get rel_svc_misc_alert_tip => 'تلميح';

  @override
  String get rel_svc_misc_alert_warning => 'تحذير';

  @override
  String get rel_svc_misc_allow_folder_session =>
      'اسمح بهذا المجلد حتى تنتهي الجلسة.';

  @override
  String get rel_svc_misc_allow_website_session =>
      'اسمح بهذا الموقع حتى تنتهي الجلسة.';

  @override
  String rel_svc_misc_approval_needed_title(String title) {
    return 'الموافقة مطلوبة — $title';
  }

  @override
  String get rel_svc_misc_attach_file_reference => 'إرفاق مرجع ملف';

  @override
  String get rel_svc_misc_attach_folder_reference => 'إرفاق مرجع مجلد';

  @override
  String get rel_svc_misc_attach_git_context => 'إرفاق سياق git';

  @override
  String get rel_svc_misc_attach_image_reference => 'إرفاق مرجع صورة';

  @override
  String get rel_svc_misc_attach_staged_diff => 'إرفاق الفروقات المرحّلة';

  @override
  String get rel_svc_misc_attach_tool_reference => 'إرفاق مرجع أداة';

  @override
  String get rel_svc_misc_attach_unstaged_diff => 'إرفاق الفروقات غير المرحّلة';

  @override
  String get rel_svc_misc_attach_url_reference => 'إرفاق مرجع URL';

  @override
  String get rel_svc_misc_background_task_completed =>
      'اكتملت المهمة في الخلفية';

  @override
  String rel_svc_misc_background_task_named_completed(String taskId) {
    return 'اكتملت المهمة $taskId في الخلفية';
  }

  @override
  String get rel_svc_misc_chat => 'دردشة';

  @override
  String get rel_svc_misc_compacting_context => 'جارٍ ضغط سياق المحادثة…';

  @override
  String rel_svc_misc_completed_in(String duration) {
    return 'اكتمل خلال $duration';
  }

  @override
  String get rel_svc_misc_context_compacted => 'تم ضغط سياق المحادثة';

  @override
  String get rel_svc_misc_cron_readback_mismatch =>
      'لم تتطابق قراءة نموذج Cron';

  @override
  String get rel_svc_misc_cron_update_rejected => 'رُفض تحديث Cron';

  @override
  String get rel_svc_misc_deny_folder_grant => 'لا تمنح صلاحية لهذا المجلد.';

  @override
  String get rel_svc_misc_deny_website_grant => 'لا تمنح صلاحية لهذا الموقع.';

  @override
  String rel_svc_misc_failed_after(String duration) {
    return 'فشل بعد $duration';
  }

  @override
  String get rel_svc_misc_gateway_folder_unnamed => 'لم تحدد البوابة مجلدًا.';

  @override
  String get rel_svc_misc_gateway_idle_unconfirmed =>
      'البوابة خاملة. تعذر تأكيد نتيجة الجولة السابقة.';

  @override
  String get rel_svc_misc_gateway_turn_failed => 'فشلت جولة البوابة';

  @override
  String rel_svc_misc_gateway_turn_status(String status) {
    return 'جولة البوابة: $status';
  }

  @override
  String get rel_svc_misc_gateway_website_unnamed => 'لم تحدد البوابة موقعًا.';

  @override
  String get rel_svc_misc_hermes_review => 'مراجعة Hermes';

  @override
  String get rel_svc_misc_hermes_turn_failed => 'فشلت جولة Hermes';

  @override
  String get rel_svc_misc_image_recovery_companion_gap =>
      'استعادة الصور والنصوص غير متاحة في الاستعادة المصاحبة. لا يمكن استعادة إرسال صورة غير مؤكَّد على هذا الاتصال، ولا يُعاد إرسال أي شيء تلقائيًا.';

  @override
  String get rel_svc_misc_image_recovery_rest_gap =>
      'استعادة الصور والنصوص غير متاحة على Classic REST/SSE. لا يمكن استعادة إرسال صورة غير مؤكَّد على هذا الاتصال، ولا يُعاد إرسال أي شيء تلقائيًا.';

  @override
  String rel_svc_misc_input_needed_title(String title) {
    return 'الإدخال مطلوب — $title';
  }

  @override
  String get rel_svc_misc_parallel_workspace_connection_changed =>
      'تغيّر الاتصال. أعد فتحه لاستخدام مساحة العمل.';

  @override
  String get rel_svc_misc_preparing => 'جارٍ التحضير';

  @override
  String get rel_svc_misc_save_folder_grant =>
      'احفظ صلاحية هذا المجلد للطلبات اللاحقة.';

  @override
  String get rel_svc_misc_save_website_grant =>
      'احفظ صلاحية هذا الموقع للطلبات اللاحقة.';

  @override
  String get rel_svc_misc_stored_identity_turn_conflict =>
      'فُتحت هذه الدردشة عبر هويتها المخزنة بينما قُبلت جولة أخرى. لم تُرسل المطالبة غير المرسلة؛ أعد المحاولة بوضوح بعد انتهاء تلك الجولة.';

  @override
  String get rel_svc_misc_untitled => 'بلا عنوان';

  @override
  String get rel_svc_misc_wake_capture_silent =>
      'لا يلتقط العميل سوى الصمت — تحقق من وصول نظام التشغيل إلى الميكروفون ثم أوقف كلمة التنبيه وشغّلها مجددًا.';

  @override
  String get rel_svc_misc_wake_capture_stalled =>
      'توقف التقاط التنبيه على العميل: لم تصل أي استدعاءات صوتية من الميكروفون.';

  @override
  String rel_svc_misc_wake_feed_refused(int count, String detail) {
    return 'رفض موجز كلمة التنبيه $count إطارًا متتاليًا$detail — أوقف كلمة التنبيه وشغّلها مجددًا لإعادة التسليح.';
  }

  @override
  String rel_svc_misc_wake_microphone_failed(String error) {
    return 'فشل تدفق ميكروفون التنبيه على العميل: $error';
  }

  @override
  String get rel_svc_misc_wake_track_ended =>
      'انتهى مسار الميكروفون أثناء التقاط كلمة التنبيه — أوقف كلمة التنبيه وشغّلها مجددًا لإعادة التسليح.';

  @override
  String get rel_svc_misc_website => 'الموقع الإلكتروني';

  @override
  String get rel_svc_lan_timeout => 'انتهت مهلة الاكتشاف في الشبكة المحلية';

  @override
  String get rel_svc_notification_permission_denied => 'رُفض الإذن';

  @override
  String get rel_svc_notifications_off => 'الإشعارات متوقفة';

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
  String get fleet_managed_ssh_title => 'SSH بإدارة البوابة';

  @override
  String get fleet_managed_ssh_intro =>
      'أدِر مضيفي SSH المحفوظين بالفعل على هذه البوابة من أي جهاز. يجب أن يكون Hermes مثبتًا مسبقًا على المضيف البعيد. يؤدي هذا إلى بدء خدمة بعيدة مملوكة للبوابة أو الاتصال بها، وليس إلى إنشاء اتصال دردشة Ares. لا تتوفر التحديثات المُدارة والاسترداد إلا في تطبيق سطح المكتب الأصلي.';

  @override
  String get fleet_managed_ssh_read => 'قراءة مضيفي SSH المحفوظين';

  @override
  String get fleet_managed_ssh_trust =>
      'عند هذا الاتصال الأول، ستثق البوابة بمفتاح SSH لهذا المضيف وتتذكره. سيُكتشف أي تغيير لاحق في المفتاح ويُحظر الاتصال. لا تُبلغ البوابة عن بصمة المفتاح، لذا لا يستطيع Ares عرضها أو تخزينها. لا تتابع إلا إذا كنت تثق بهذا الاتصال الأول.';

  @override
  String get fleet_managed_ssh_changed =>
      'تغيّر مفتاح SSH لهذا المضيف. تم حظر الاتصال. يجب على شخص لديه صلاحية الوصول إلى مضيف البوابة التحقق بشكل مستقل من بصمة المفتاح الجديد وإزالة المفتاح القديم الموثوق به هناك. لا تُعِد المحاولة إلا بعد هذا التحقق والإصلاح. لا يستبدل Ares المفتاح الموثوق به.';

  @override
  String get fleet_managed_ssh_disconnect_warning =>
      'هل تريد قطع نفق SSH وإيقاف الخدمة البعيدة المملوكة لهذه البوابة؟ قد يؤدي ذلك إلى مقاطعة عملاء آخرين يستخدمون هذه الخدمة.';

  @override
  String get fleet_managed_ssh_verify => 'التحقق من المفتاح بنفسك بدلًا من ذلك';

  @override
  String fleet_managed_ssh_pending(int seconds) {
    return 'في انتظار البوابة: $seconds ث. مغادرة هذه الصفحة لا تلغي التهيئة. إذا فشل الطلب، فتحقق من الحالة قبل إعادة المحاولة.';
  }

  @override
  String fleet_managed_ssh_status(
    String host,
    int localPort,
    int remotePort,
    String version,
    String reused,
  ) {
    return 'المضيف: $host\nمنفذ الاسترجاع المحلي للبوابة: $localPort\nمنفذ الاسترجاع المحلي البعيد: $remotePort\nHermes: $version\nأُعيد استخدامه: $reused';
  }

  @override
  String get fleet_managed_ssh_disconnect => 'قطع الاتصال';

  @override
  String get ng_slash_suggestions_loading => 'جارٍ تحميل الأوامر…';

  @override
  String get ng_slash_suggestions_empty => 'لا توجد أوامر مطابقة';

  @override
  String get ng_slash_suggestions_label => 'اقتراحات الأوامر';

  @override
  String get ng_slash_suggestions_skill => 'مهارة';

  @override
  String get settings_classic_title => 'إعدادات Classic';

  @override
  String get settings_nextgen_title => 'إعدادات NextGen';

  @override
  String get settings_category_general => 'عام واللغة';

  @override
  String get settings_category_chat => 'الدردشة والجلسات';

  @override
  String get settings_category_device => 'الجهاز والاختصارات';

  @override
  String get settings_category_connections => 'الاتصالات والنماذج';

  @override
  String get settings_category_security => 'الخصوصية والنسخ الاحتياطي';

  @override
  String get settings_category_about => 'حول التطبيق والمساعدة';

  @override
  String get settings_reopen_chat => 'استعادة آخر دردشة عند العودة إلى بوابة';

  @override
  String get settings_reopen_chat_hint =>
      'يفتح التشغيل الأول شاشة الترحيب. تفتح الروابط والإشعارات الدردشة المطلوبة.';

  @override
  String get settings_danger => 'إجراءات حساسة';
}
