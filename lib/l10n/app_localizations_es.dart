// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get attachment_audio_failed =>
      'No se pudo reproducir este audio. Puede que el formato o códec no sea compatible o que se haya superado el límite de tamaño de la vista previa. Reintenta, guarda o comparte el archivo original.';

  @override
  String get attachment_audio_seek => 'Posición del audio';

  @override
  String get workspace_workers => 'Subagentes activos';

  @override
  String get workers_unattached =>
      'Solo se muestran cantidades. Para dirigir un subagente, elige Subagentes activos en el chat principal conectado.';

  @override
  String get slash_local_arguments =>
      'Este atajo no admite argumentos aquí. Usa los controles de la aplicación; se conservó tu borrador.';

  @override
  String get fallback_title => 'Modelos de respaldo';

  @override
  String get fallback_notice =>
      'Se prueban en orden cuando el modelo principal no está disponible. Los cambios solo afectan a este perfil; guarda explícitamente la lista completa.';

  @override
  String get fallback_unavailable =>
      'La configuración de respaldo no está disponible o no es válida. Revisa la conexión, el perfil seleccionado y la versión del servidor e inténtalo de nuevo.';

  @override
  String get fallback_discovery_unavailable =>
      'No se pueden obtener los proveedores. Se conservan las entradas existentes; reintenta para elegir proveedores y modelos.';

  @override
  String get fallback_empty => 'No hay entradas en esta lista de respaldo.';

  @override
  String get fallback_incomplete =>
      'Elige un proveedor y un modelo para cada entrada o elimina las entradas incompletas antes de guardar.';

  @override
  String get fallback_add => 'Añadir respaldo';

  @override
  String get fallback_save => 'Guardar lista de respaldo';

  @override
  String get fallback_save_failed =>
      'No se pudo verificar la lista guardada. Se conserva el borrador. Vuelve a guardar o actualiza para cargar la configuración del servidor.';

  @override
  String get fallback_saved => 'Lista de respaldo guardada y verificada.';

  @override
  String get fallback_legacy_title => 'Respaldos antiguos (solo lectura)';

  @override
  String get fallback_legacy_notice =>
      'El servidor también usa fallback_model después de esta lista y omite rutas duplicadas. Estas entradas antiguas se conservan aunque la lista de arriba esté vacía. Edítalas en el servidor.';

  @override
  String fallback_priority(String position) {
    return 'Prioridad $position';
  }

  @override
  String get fallback_move_up => 'Subir';

  @override
  String get fallback_move_down => 'Bajar';

  @override
  String get fallback_routing_read_only =>
      'Se conservan los detalles de enrutamiento o un proveedor no listado. Edita este proveedor/modelo en el servidor; aquí puedes reordenar o eliminar la entrada.';

  @override
  String get cron_model_default => 'Seguir valor predeterminado';

  @override
  String get cron_model_notice =>
      'Solo se aplica a esta tarea cron. Sin fijar un modelo, Hermes usa el predeterminado de cron y luego el principal. Gestiona los modelos personalizados en el servidor.';

  @override
  String get model_management_unavailable =>
      'No se pudieron cargar o guardar los ajustes del modelo. Actualiza e inténtalo de nuevo.';

  @override
  String get model_management_subtitle =>
      'Modelos principal, de respaldo y auxiliares de este perfil';

  @override
  String get usage => 'Uso';

  @override
  String get nous_portal => 'Nous Portal';

  @override
  String get portal_menu_subtitle => 'Estado del gateway y uso registrado';

  @override
  String get portal_read_only =>
      'Datos de solo lectura del gateway. Gestiona la autenticación de Nous en el host de Hermes. Estos endpoints no proporcionan saldos de suscripción ni créditos.';

  @override
  String get portal_status => 'Estado del Portal en el gateway';

  @override
  String get portal_free_tier => 'Acceso gratuito (sin cuenta iniciada)';

  @override
  String get portal_signed_in => 'Sesión iniciada';

  @override
  String get portal_signed_out => 'Sesión no iniciada';

  @override
  String get portal_account_tier => 'Nivel de cuenta';

  @override
  String get portal_recorded_usage => 'Uso registrado';

  @override
  String get portal_all_providers =>
      'Todos los proveedores del perfil seleccionado del gateway. Un coste registrado de cero no significa que el modelo sea gratuito.';

  @override
  String portal_period(String days) {
    return 'Últimos $days días';
  }

  @override
  String get portal_sessions => 'Sesiones';

  @override
  String get portal_input => 'Tokens de entrada';

  @override
  String get portal_output => 'Tokens de salida';

  @override
  String get portal_estimated => 'Coste estimado registrado';

  @override
  String get portal_actual => 'Coste real registrado';

  @override
  String get portal_recorded_models => 'Modelos registrados';

  @override
  String get portal_no_models => 'No hay modelos registrados.';

  @override
  String get portal_unavailable =>
      'No disponible. Comprueba la conexión, el perfil seleccionado y la versión del gateway e inténtalo de nuevo.';

  @override
  String get paste_attachment_failed_text_kept =>
      'No se pudo adjuntar el texto pegado. El texto se ha conservado en el mensaje.';

  @override
  String get background_task_report => 'Tarea en segundo plano';

  @override
  String get background_process_report => 'Proceso en segundo plano';

  @override
  String get background_report_issues =>
      'Se notificaron problemas; expande para ver los detalles.';

  @override
  String get background_report_expand => 'Expandir informe';

  @override
  String get background_report_collapse => 'Contraer informe';

  @override
  String get ng_brand_open_chat => 'Abrir un chat';

  @override
  String get ng_brand_recent => 'Recientes';

  @override
  String get ng_brand_sidebar_hint => 'o elige un chat de la barra lateral';

  @override
  String get copy_session_id => 'Copiar ID de sesión';

  @override
  String get copy_session_id_failed => 'No se pudo copiar el ID de sesión.';

  @override
  String get setup_interface_title => 'Elige tu interfaz';

  @override
  String get setup_interface_classic => 'Classic';

  @override
  String get setup_interface_nextgen => 'NextGen';

  @override
  String get setup_interface_classic_description =>
      'El espacio de trabajo original de Ares, con todos los controles de conexión y ajustes de Classic.';

  @override
  String get setup_interface_nextgen_description =>
      'Un aspecto nuevo con un solo inicio de sesión en el dashboard, planes en vivo, subagentes y notificaciones.';

  @override
  String get setup_interface_switch_later =>
      'Puedes cambiar en cualquier momento en Ajustes.';

  @override
  String get ng_confirm_model_switch => '¿Cambiar de modelo?';

  @override
  String get ng_switch => 'Cambiar';

  @override
  String get ng_model_confirmation_required =>
      'Este modelo necesita confirmación antes de seleccionarlo.';

  @override
  String ng_model_switches_next_turn(String model) {
    return 'Cambia a $model en el próximo turno.';
  }

  @override
  String get ng_model_switch_not_connected =>
      'El chat no está listo para cambiar de modelo. Vuelve a abrirlo e inténtalo de nuevo.';

  @override
  String ng_gateway_kept_default_model(String model) {
    return 'El gateway mantuvo $model en este chat. Vuelve a elegir el modelo antes de enviar.';
  }

  @override
  String get hands_free_title => 'Manos libres';

  @override
  String get hands_free_start => 'Iniciar manos libres';

  @override
  String get hands_free_stop => 'Detener manos libres';

  @override
  String get hands_free_preparing => 'Preparando voz — espera';

  @override
  String get hands_free_listening => 'Di Hey Hermes';

  @override
  String get hands_free_recording => 'Listo — habla ahora';

  @override
  String get hands_free_waiting => 'Esperando a Hermes';

  @override
  String get hands_free_speaking => 'Hablando — micrófono apagado';

  @override
  String hands_free_followup(int seconds) {
    return 'Escuchar hasta $seconds segundos';
  }

  @override
  String get hands_free_error => 'Manos libres detenido';

  @override
  String get hands_free_setup => 'Configurar manos libres';

  @override
  String hands_free_preview(String transcript) {
    return 'Vista previa: $transcript';
  }

  @override
  String get hands_free_short_disclosure =>
      'Solo con este chat abierto en primer plano. Activación sin conexión; la voz puede usar la red. Consume batería.';

  @override
  String get hands_free_error_action =>
      'Revisa permiso de micrófono, servicio de voz, voz de respuesta y conexión. Pulsa Detener e Iniciar. No se reenvía nada.';

  @override
  String get hands_free_disclosure =>
      'La activación funciona sin conexión en la CPU. El reconocimiento de Android, la voz elegida y el gateway pueden usar redes. Escuchar consume batería y puede haber activaciones falsas. Se detiene al cubrir o cerrar el chat o salir del primer plano; nunca se reinicia solo. El dictado manual sigue siendo un borrador editable.';

  @override
  String get hands_free_ready_cue =>
      'Di «Hey Hermes», espera a «Listo» y habla. Sin captura en la misma frase ni audio previo. Si el permiso te saca de la app, pulsa Iniciar otra vez tras concederlo.';

  @override
  String get hands_free_settings_title => 'Voz manos libres';

  @override
  String get hands_free_settings_subtitle =>
      'Muestra el control de inicio «Hey Hermes» en los chats. Desactivarlo detiene cualquier sesión de manos libres en curso.';

  @override
  String get hands_free_timing_limit =>
      'La ventana de seguimiento es un máximo, no un mínimo. Android puede detenerse antes. El silencio vuelve a la activación local sin reiniciar repetidamente el reconocimiento.';

  @override
  String get hands_free_followup_off =>
      'Seguimiento desactivado — di Hey Hermes para cada mensaje';

  @override
  String get hands_free_start_blocked =>
      'Se requiere borrador vacío, sin adjuntos, chat conectado sin actividad y respuestas habladas activadas. Termina primero cualquier acción de voz manual.';

  @override
  String get hands_free_setup_complete =>
      'Configuración de micrófono terminada. Pulsa Iniciar otra vez.';

  @override
  String message_time_recorded(String time) {
    return 'Registrado por el servidor: $time (hora local)';
  }

  @override
  String message_time_sent(String time) {
    return 'Envío observado en este dispositivo: $time (hora local)';
  }

  @override
  String message_time_received(String time) {
    return 'Primera recepción en este dispositivo: $time (hora local)';
  }

  @override
  String get stop_and_send => 'Detener y enviar';

  @override
  String get message_queued_for_running_turn =>
      'Mensaje en cola para la ejecución actual.';

  @override
  String get running_message_not_accepted =>
      'Hermes no pudo aceptar este mensaje. Se conservó tu borrador; detén la respuesta o espera y vuelve a enviarlo.';

  @override
  String get running_message_delivery_unknown =>
      'No se pudo confirmar la entrega. Se conservó tu borrador. Revisa el chat antes de volver a intentarlo.';

  @override
  String get attachment_tap_to_preview => 'Toca para ver la vista previa';

  @override
  String get attachment_save => 'Guardar';

  @override
  String get attachment_share => 'Compartir';

  @override
  String get attachment_saved => 'Archivo guardado';

  @override
  String get attachment_save_cancelled => 'Guardado cancelado';

  @override
  String get attachment_save_failed =>
      'No se pudo guardar este archivo. Inténtalo de nuevo.';

  @override
  String get attachment_share_failed =>
      'No se pudo compartir este archivo. Inténtalo de nuevo.';

  @override
  String get attachment_download_failed =>
      'No se pudo cargar este archivo. Comprueba la conexión e inténtalo de nuevo.';

  @override
  String get attachment_no_inline_preview =>
      'No hay vista previa para este tipo de archivo. Guarda o comparte el archivo original para abrirlo en otra aplicación.';

  @override
  String get attachment_image_failed =>
      'No se pudo decodificar esta imagen. Aún puedes guardar o compartir el archivo original.';

  @override
  String get attachment_text_truncated =>
      'Vista previa recortada. Guarda o comparte el archivo para leerlo completo.';

  @override
  String get attachment_text_unavailable =>
      'No se pudo mostrar este archivo como texto. Guarda o comparte el archivo original.';

  @override
  String get attachment_pdf_failed =>
      'No se pudo mostrar la vista previa de este PDF. Guarda o comparte el archivo original.';

  @override
  String get attachment_pdf_unavailable =>
      'Las vistas previas de PDF están disponibles en Android. Aún puedes guardar o compartir este archivo.';

  @override
  String attachment_pdf_page(int page, int total) {
    return 'Página $page de $total';
  }

  @override
  String get attachment_previous_page => 'Página anterior';

  @override
  String get attachment_next_page => 'Página siguiente';

  @override
  String get attachment_loading => 'Cargando vista previa…';

  @override
  String get attachment_document_text_notice =>
      'Vista previa de texto. El diseño, las imágenes y el formato pueden diferir del original.';

  @override
  String get attachment_document_failed =>
      'No se pudo mostrar la vista previa de este documento. Guarda o comparte el archivo original.';

  @override
  String get attachment_document_empty =>
      'No se encontró texto legible en este documento.';

  @override
  String get attachment_video_failed =>
      'No se pudo reproducir este vídeo. Es posible que su formato o códec no sea compatible. Guarda o comparte el archivo original.';

  @override
  String get attachment_video_play => 'Reproducir';

  @override
  String get attachment_video_pause => 'Pausar';

  @override
  String get attachment_video_mute => 'Silenciar';

  @override
  String get attachment_video_unmute => 'Activar sonido';

  @override
  String get attachment_video_seek => 'Posición del vídeo';

  @override
  String get attachment_close => 'Cerrar vista previa';

  @override
  String get attachment_retry => 'Reintentar';

  @override
  String get saved_history_heading => 'Historial guardado';

  @override
  String get received_output_heading =>
      'Salida recibida — coincidencia con el historial guardado sin confirmar';

  @override
  String get received_output_details => 'Acerca de la salida recibida';

  @override
  String get received_output_explanation =>
      'Esto también puede aparecer en el historial guardado. La aplicación no puede confirmar que coincida.';

  @override
  String get local_prompt_context => 'Contexto local del prompt';

  @override
  String get received_output_badge => 'Recibido · coincidencia sin confirmar';

  @override
  String get received_output_lifetime =>
      'La salida recibida se conserva temporalmente durante esta sesión de la aplicación y puede acortarse o eliminarse al alcanzar los límites. Puede dejar de estar disponible al cerrar la aplicación o la conexión.';

  @override
  String get theme_palette => 'Tema de color';

  @override
  String get theme_palette_gold => 'Dorado';

  @override
  String get theme_palette_purple => 'Morado';

  @override
  String get theme_palette_orange => 'Naranja';

  @override
  String get theme_palette_green => 'Verde';

  @override
  String get theme_palette_blue => 'Azul';

  @override
  String get theme_palette_red => 'Rojo';

  @override
  String get theme_palette_teal => 'Verde azulado';

  @override
  String get theme_palette_pink => 'Rosa';

  @override
  String get theme_palette_indigo => 'Índigo';

  @override
  String get theme_palette_cyan => 'Cian';

  @override
  String get assets_recent_subtitle =>
      'Encuentra archivos compartidos por Hermes en chats guardados';

  @override
  String get assets_scope_notice =>
      'Archivos generados que Hermes ha compartido explícitamente en respuestas guardadas. Esta es una vista parcial del historial de chats, no un catálogo completo de archivos o adjuntos. Es posible que los archivos referenciados ya no existan.';

  @override
  String get assets_download_limit =>
      'Los archivos solo se cargan al tocarlos. Las vistas previas y las descargas tienen un límite de 25 MiB por archivo; usa el panel para archivos más grandes.';

  @override
  String get assets_search_hint =>
      'Buscar en los archivos encontrados o en los chats de origen';

  @override
  String get assets_all => 'Todos';

  @override
  String get assets_images => 'Imágenes';

  @override
  String get assets_audio => 'Audio';

  @override
  String get assets_video => 'Vídeo';

  @override
  String get assets_documents => 'Documentos y otros archivos';

  @override
  String get assets_empty =>
      'No se encontraron recursos en los mensajes analizados';

  @override
  String get assets_empty_detail =>
      'Analiza más chats o mensajes más antiguos para consultar un periodo anterior. Los adjuntos normales y los archivos sin enlace no se indexan aquí.';

  @override
  String get assets_no_matches => 'No hay recursos que coincidan';

  @override
  String get assets_load_more_chats => 'Analizar más chats';

  @override
  String get assets_load_older_messages => 'Analizar mensajes más antiguos';

  @override
  String get assets_load_failed =>
      'No se pudo leer parte del historial. Los resultados están incompletos. Comprueba la conexión del panel y vuelve a intentarlo.';

  @override
  String get assets_retry_failed =>
      'Reintentar las lecturas fallidas del historial';

  @override
  String get assets_partial =>
      'El servidor ha indicado que el historial está incompleto. Comprueba el panel y actualiza después.';

  @override
  String assets_scan_summary(int files, int chats) {
    return 'Referencias a archivos encontradas: $files · Chats analizados: $chats';
  }

  @override
  String assets_open_chat(String title) {
    return 'Abrir chat: $title';
  }

  @override
  String get assets_file_too_large =>
      'Este archivo supera el límite de descarga. Abre el panel para descargarlo.';

  @override
  String get a_one_off_question_archives_itself_after_72_hours_anything =>
      'Una pregunta puntual. Se archiva sola a las 72 horas; lo que valga la pena conservar seguirá en la memoria.';

  @override
  String get archive_chat => 'Archivar chat';

  @override
  String get unarchive_chat => 'Desarchivar chat';

  @override
  String get chat_archived => 'Chat archivado';

  @override
  String get chat_unarchived => 'Chat desarchivado';

  @override
  String could_not_update_chat_archive(Object error) {
    return 'No se pudo actualizar el archivo del chat: $error';
  }

  @override
  String get quick_chat_description => 'Una pregunta puntual.';

  @override
  String get ai_full_text => 'IA + texto completo';

  @override
  String get ai_search_model => 'Modelo de búsqueda con IA';

  @override
  String ai_searched_for(Object aiRewrittenQuery) {
    return 'La IA buscó: $aiRewrittenQuery';
  }

  @override
  String get ai_assisted_filing => 'Archivado asistido por IA';

  @override
  String get api_key => 'Clave de API';

  @override
  String get api_server_key_from_hermes_env =>
      'API_SERVER_KEY de ~/.hermes/.env';

  @override
  String get active => 'Activo';

  @override
  String get activity => 'Actividad';

  @override
  String get activity_reads_the_durable_turn_journal_to_know_what_hermes =>
      'La actividad lee el diario de turnos persistente para saber qué está haciendo Hermes. Comprueba que el Gateway sea accesible y vuelve a intentarlo.';

  @override
  String get add => 'Agregar';

  @override
  String get add_connection => 'Agregar conexión';

  @override
  String get add_cron_job => 'Agregar tarea de Cron';

  @override
  String get add_gateway_connection => 'Agregar conexión de Gateway';

  @override
  String get add_and_update_connections_from_the_backup_keep_the_rest =>
      'Agregar y actualizar conexiones desde la copia de seguridad; conservar las demás.';

  @override
  String get add_attachment => 'Agregar adjunto';

  @override
  String get add_new_cron_job => 'Agregar nueva tarea de Cron';

  @override
  String get add_to_chat => 'Agregar al chat';

  @override
  String get all_chats => 'Todos los chats';

  @override
  String get all_stored_message_content =>
      'Todo el contenido de mensajes almacenado';

  @override
  String get allow_for_this_session => 'Permitir durante esta sesión';

  @override
  String get allow_matching_commands_until_this_hermes_session_ends =>
      'Permitir los comandos coincidentes hasta que finalice esta sesión de Hermes.';

  @override
  String get allow_folder_until_sandbox_off =>
      'Permitir esta carpeta hasta que se desactive el sandbox.';

  @override
  String get allow_once => 'Permitir una vez';

  @override
  String get allow_website_until_sandbox_off =>
      'Permitir este sitio web hasta que se desactive el sandbox.';

  @override
  String get always_allow => 'Permitir siempre';

  @override
  String get apply_to_this_chat => 'Aplicar a este chat';

  @override
  String get approval_needed => 'Se requiere aprobación';

  @override
  String get approval_needed_description =>
      'Un comando espera tu aprobación o rechazo.';

  @override
  String get approve => 'Aprobar';

  @override
  String get archive => 'Archivar';

  @override
  String get archive_project => 'Archivar proyecto';

  @override
  String archive_2(Object projectName) {
    return '¿Archivar $projectName?';
  }

  @override
  String archive_3(Object name) {
    return '¿Archivar $name?';
  }

  @override
  String get archived => 'Archivado';

  @override
  String get archived_conversations_appear_here =>
      'Aquí solo aparecen conversaciones archivadas. Los chats antiguos siguen en Todos los chats.';

  @override
  String get archived_quick_chats => 'Chats rápidos archivados';

  @override
  String get artifacts_attachments_and_generated_media =>
      'Artefactos, adjuntos y contenido generado';

  @override
  String get ask_ai_to_find_a_conversation =>
      'Pedir a la IA que busque una conversación';

  @override
  String get assets => 'Recursos';

  @override
  String get assets_need_a_server_authoritative_assets_index_in_the_hermes =>
      'Los recursos necesitan un índice autoritativo del servidor en el Gateway de Hermes para poder mostrarse por proyecto.';

  @override
  String get assets_unavailable => 'Recursos no disponibles';

  @override
  String get attach_image_or_file => 'Adjuntar imagen o archivo';

  @override
  String get attachment_drafts => 'Borradores de adjuntos';

  @override
  String get recover_text_draft => 'Recuperar un borrador de texto';

  @override
  String get undo_draft_recovery => 'Deshacer';

  @override
  String get draft_session_exists =>
      'Este chat aún existe. Ábrelo para continuar con el borrador.';

  @override
  String get draft_recovery_unavailable =>
      'No se pudo verificar el borrador. No se ha cambiado nada.';

  @override
  String attachment_of(Object index, Object total) {
    return 'Adjunto $index de $total';
  }

  @override
  String get auto_device_default =>
      'Automático (predeterminado del dispositivo)';

  @override
  String get agent => 'Agente';

  @override
  String get autonomous_agents => 'Agentes autónomos';

  @override
  String get background_recovery_unavailable_legacy_transport =>
      'Recuperación en segundo plano no disponible: transporte heredado';

  @override
  String get background_task_completed => 'Tarea en segundo plano completada';

  @override
  String get background_task_completed_description =>
      'Un comando de terminal en segundo plano ha terminado.';

  @override
  String get backup_restore => 'Copia de seguridad y restauración';

  @override
  String backup_exported(Object destination) {
    return 'Copia de seguridad exportada: $destination';
  }

  @override
  String get base_url => 'URL base';

  @override
  String get binary_preview_is_unavailable_download_the_file_to_open_it =>
      'La vista previa binaria no está disponible. Descarga el archivo para abrirlo.';

  @override
  String get branch => 'Rama';

  @override
  String get branch_chat => 'Bifurcar chat';

  @override
  String get branch_created_in_hermes_history =>
      'Rama creada en el historial de Hermes.';

  @override
  String get browse_and_manage_your_hermes_agent_sessions_from_your_phone =>
      'Explora y administra tus sesiones de Hermes Agent desde el teléfono. Se conecta a un panel de Hermes que se ejecuta en tu red local.';

  @override
  String get browse_server_files => 'Explorar archivos del servidor';

  @override
  String get browse_the_miniserver_folders_behind_your_projects =>
      'Explora las carpetas de miniserver detrás de tus proyectos';

  @override
  String get cancel => 'Cancelar';

  @override
  String get cancel_voice_input => 'Cancelar entrada de voz';

  @override
  String cannot_reach(Object host, Object port) {
    return 'No se puede conectar con $host:$port.';
  }

  @override
  String cannot_reach_check_the_host_and_port(Object host, Object port) {
    return 'No se puede conectar con $host:$port. Comprueba el host y el puerto.';
  }

  @override
  String get change_ai_search_model => 'Cambiar el modelo de búsqueda con IA';

  @override
  String changes_the_default_for_use_the_selector_in_a_chat(Object label) {
    return 'Cambia el valor predeterminado de $label. Usa el selector dentro de un chat para anularlo solo en esa conversación.';
  }

  @override
  String get chat_actions => 'Acciones del chat';

  @override
  String get chats => 'Chats';

  @override
  String get chats_from_this_gateway_are_not_grouped_yet_grouping_stays =>
      'Los chats de este Gateway aún no se agrupan. La agrupación permanece en este teléfono hasta que el Gateway pueda alojar proyectos.';

  @override
  String get chats_in_this_project_will_show_their_state_and_last =>
      'Los chats de este proyecto mostrarán aquí su estado y su última actividad.';

  @override
  String get chats_that_are_not_assigned_to_a_project =>
      'Chats que no están asignados a un proyecto';

  @override
  String get chats_you_start_in_this_project_will_appear_here_on =>
      'Los chats que inicies en este proyecto aparecerán aquí, en todos los dispositivos conectados a este Hermes.';

  @override
  String get check_that_the_gateway_is_running_and_reachable_then_try =>
      'Comprueba que el Gateway esté en ejecución y sea accesible, y vuelve a intentarlo.';

  @override
  String get check_the_dashboard_connection_and_try_again =>
      'Comprueba la conexión del panel y vuelve a intentarlo.';

  @override
  String get check_the_connection_and_try_again =>
      'Comprueba la conexión y vuelve a intentarlo.';

  @override
  String get choose_a_small_model_to_rewrite_queries =>
      'Elige un modelo pequeño para reescribir las consultas';

  @override
  String get choose_an_ai_search_model_before_using_ai_search =>
      'Elige un modelo de búsqueda con IA antes de usar la búsqueda con IA.';

  @override
  String get choose_an_active_project_next =>
      'A continuación, elige un proyecto activo';

  @override
  String get choose_chat_model => 'Elegir modelo del chat';

  @override
  String get choose_files => 'Elegir archivos';

  @override
  String get choose_image => 'Elegir imagen';

  @override
  String get choose_images => 'Elegir imágenes';

  @override
  String get choose_its_destination_space => 'Elige su espacio de destino';

  @override
  String get clear_search => 'Borrar búsqueda';

  @override
  String get close => 'Cerrar';

  @override
  String get code_copied => 'Código copiado';

  @override
  String get code_format => 'Código';

  @override
  String get coming_next => 'Próximamente';

  @override
  String get command => 'Comando';

  @override
  String get command_palette => 'Paleta de comandos';

  @override
  String get command_palette_hint => 'Escribe un comando';

  @override
  String get command_palette_no_results => 'No se encontraron comandos';

  @override
  String get command_palette_new_chat => 'Nuevo chat';

  @override
  String get command_palette_search_chats => 'Buscar chats';

  @override
  String get command_palette_toggle_theme => 'Alternar tema';

  @override
  String get command_palette_copy_last_code => 'Copiar último bloque de código';

  @override
  String get command_line_chats => 'Chats de línea de comandos';

  @override
  String get compatibility_mode => 'Modo de compatibilidad';

  @override
  String get configure_a_valid_desktop_gateway_url_before_attaching_files =>
      'Configura una URL válida del Desktop Gateway antes de adjuntar archivos.';

  @override
  String get confirm_always_allow => 'Confirmar permitir siempre';

  @override
  String get confirm_passphrase => 'Confirmar frase de contraseña';

  @override
  String connecting_to(Object baseUrl) {
    return 'Conectando con $baseUrl...';
  }

  @override
  String get connection_issue => 'Problema de conexión';

  @override
  String
  get connection_switched_the_running_reply_continues_on_the_server_and =>
      'Conexión cambiada: la respuesta en curso continúa en el servidor y se volverá a adjuntar automáticamente.';

  @override
  String get connection_appearance_and_device_preferences =>
      'Conexión, apariencia y preferencias del dispositivo';

  @override
  String context_tokens(Object effectiveContextLength) {
    return 'Contexto: $effectiveContextLength tokens';
  }

  @override
  String get continue_label => 'Continuar';

  @override
  String get continue_working => 'Seguir trabajando';

  @override
  String get conversations_in_this_project => 'Conversaciones en este proyecto';

  @override
  String get copy_code => 'Copiar código';

  @override
  String get copy_message => 'Copiar mensaje';

  @override
  String could_not_branch_chat(Object error) {
    return 'No se pudo bifurcar el chat: $error';
  }

  @override
  String could_not_delete_session(Object error) {
    return 'No se pudo eliminar la sesión: $error';
  }

  @override
  String could_not_deny_the_command(Object error) {
    return 'No se pudo denegar el comando: $error';
  }

  @override
  String could_not_load_ai_search_models(Object error) {
    return 'No se pudieron cargar los modelos de búsqueda con IA: $error';
  }

  @override
  String get could_not_load_conversations =>
      'No se pudieron cargar las conversaciones';

  @override
  String get could_not_load_files => 'No se pudieron cargar los archivos';

  @override
  String could_not_load_models_for_this_profile(Object error) {
    return 'No se pudieron cargar los modelos de este perfil: $error';
  }

  @override
  String could_not_load_more_chats(Object error) {
    return 'No se pudieron cargar más chats: $error';
  }

  @override
  String get could_not_open_link => 'No se pudo abrir este enlace.';

  @override
  String get could_not_open_the_hermes_dashboard =>
      'No se pudo abrir el panel de Hermes.';

  @override
  String get could_not_open_this_project => 'No se pudo abrir este proyecto';

  @override
  String get could_not_preview_file => 'No se pudo previsualizar el archivo';

  @override
  String get could_not_reach_hermes => 'No se pudo conectar con Hermes';

  @override
  String could_not_reach_authenticate_the_dashboard_at_check_the_port(
    Object dashboardPort,
    Object host,
  ) {
    return 'No se pudo conectar o autenticar con el panel en $host:$dashboardPort. Comprueba el puerto y las credenciales.';
  }

  @override
  String get could_not_read_activity => 'No se pudo leer la actividad';

  @override
  String could_not_rename_chat(Object error) {
    return 'No se pudo cambiar el nombre del chat: $error';
  }

  @override
  String could_not_send_the_approval(Object error) {
    return 'No se pudo enviar la aprobación: $error';
  }

  @override
  String get could_not_skip_the_hermes_question =>
      'No se pudo omitir la pregunta de Hermes.';

  @override
  String could_not_the_project(Object action, Object error) {
    return 'No se pudo $action el proyecto: $error';
  }

  @override
  String get couldn_t_delete_project => 'No se pudo eliminar el proyecto';

  @override
  String couldn_t_load_runs(Object error) {
    return 'No se pudieron cargar las ejecuciones: $error';
  }

  @override
  String get couldn_t_move_conversation => 'No se pudo mover la conversación';

  @override
  String couldn_t_move_to(Object label, Object reason) {
    return 'No se pudo mover a $label: $reason';
  }

  @override
  String get couldn_t_prepare_the_shared_files =>
      'No se pudieron preparar los archivos compartidos.';

  @override
  String get couldn_t_promote_conversation =>
      'No se pudo promover la conversación';

  @override
  String couldn_t_project(Object action) {
    return 'No se pudo $action el proyecto';
  }

  @override
  String get create => 'Crear';

  @override
  String get create_a_project => 'Crear un proyecto';

  @override
  String get create_a_project_first_then_chats_can_live_inside_it =>
      'Crea primero un proyecto; los chats podrán vivir dentro de él.';

  @override
  String get create_a_space_to_separate_related_conversations =>
      'Crea un espacio para separar conversaciones relacionadas.';

  @override
  String get create_branch => 'Crear rama';

  @override
  String get credit_notifications => 'Notificaciones de crédito';

  @override
  String get credit_notifications_description =>
      'El uso de crédito se detuvo o se restableció.';

  @override
  String get cron => 'Cron';

  @override
  String get crons => 'Tareas cron';

  @override
  String get cron_conversations_empty =>
      'Las conversaciones de tareas programadas aparecen aquí, incluidas las ejecuciones anteriores.';

  @override
  String get search_cron_conversations => 'Buscar conversaciones de cron';

  @override
  String get cron_jobs => 'Tareas de Cron';

  @override
  String cron_schedule_timezone(Object zone) {
    return 'Zona horaria de la programación: $zone';
  }

  @override
  String get crons_upcoming => 'Próximas';

  @override
  String get crons_history => 'Historial';

  @override
  String cron_time_with_zone(Object time, Object zone) {
    return '$time ($zone)';
  }

  @override
  String cron_time_zone_unknown(Object time) {
    return '$time (zona horaria desconocida)';
  }

  @override
  String get cron_no_next_run => 'Sin próxima ejecución programada';

  @override
  String get cron_status_scheduled => 'Programada';

  @override
  String get cron_status_paused => 'En pausa';

  @override
  String cron_delivers_to(Object target) {
    return 'Se entrega en $target';
  }

  @override
  String get cron_upcoming_empty_title => 'No hay tareas programadas';

  @override
  String get cron_upcoming_empty_message =>
      'No hay nada programado para ejecutarse. Crea una tarea en Tareas de Cron o pide al agente que programe una.';

  @override
  String get cron_upcoming_unavailable => 'Tareas programadas no disponibles';

  @override
  String get cron_upcoming_needs_dashboard =>
      'Las tareas programadas necesitan una conexión con el panel. Esta dirección no expone la programación de Cron. Comprueba la dirección del panel y la compatibilidad del servidor.';

  @override
  String get cron_upcoming_needs_dashboard_auth =>
      'Las tareas programadas necesitan autenticación del panel. Añade el usuario y la contraseña del panel a esta conexión o activa el modo con proxy.';

  @override
  String get cron_upcoming_dashboard_unreachable =>
      'No se pudo conectar con el panel. Comprueba el host, el puerto del panel y la red, y vuelve a intentarlo.';

  @override
  String get cron_upcoming_load_failed =>
      'No se pudieron leer las tareas programadas. Comprueba la conexión del panel y vuelve a intentarlo.';

  @override
  String get cron_upcoming_refresh_failed =>
      'No se pudo actualizar la programación. Se muestra la última lectura correcta.';

  @override
  String get cron_job_added => 'Tarea de Cron agregada';

  @override
  String get cron_job_updated => 'Tarea de Cron actualizada';

  @override
  String get cron_run => 'Ejecución de Cron';

  @override
  String get cross_device_ordering_and_reversible_bulk_organization =>
      'Ordenación entre dispositivos y organización masiva reversible';

  @override
  String get current_profile_default =>
      'Valor predeterminado del perfil actual';

  @override
  String get custom_proxy_and_dashboard_details =>
      'Detalles personalizados de proxy y panel';

  @override
  String get dark => 'Oscuro';

  @override
  String get dashboard_proxy_settings => 'Configuración del panel / proxy';

  @override
  String get dashboard_password_optional => 'Contraseña del panel (opcional)';

  @override
  String get dashboard_port => 'Puerto del panel';

  @override
  String get dashboard_username_optional =>
      'Nombre de usuario del panel (opcional)';

  @override
  String get dashboard_behind_proxy => 'Panel detrás de un proxy';

  @override
  String get dashboard_path_prefix => 'Prefijo de ruta del panel';

  @override
  String delegated_task(Object goal) {
    return 'Tarea delegada: $goal';
  }

  @override
  String get delete => 'Eliminar';

  @override
  String delete_2(Object name) {
    return '¿Eliminar «$name»?';
  }

  @override
  String delete_from_the_remote_hermes_history_this_cannot_be_undone(
    Object title,
  ) {
    return '¿Eliminar «$title» del historial remoto de Hermes? Esta acción no se puede deshacer.';
  }

  @override
  String get delete_cron_job => 'Eliminar tarea de Cron';

  @override
  String get delete_connections_that_are_not_in_the_backup =>
      'Eliminar las conexiones que no estén en la copia de seguridad.';

  @override
  String delete_failed(Object error) {
    return 'Error al eliminar: $error';
  }

  @override
  String get delete_project => 'Eliminar proyecto';

  @override
  String get delete_session => '¿Eliminar la sesión?';

  @override
  String delete_3(Object projectName) {
    return '¿Eliminar $projectName?';
  }

  @override
  String deleted(Object name) {
    return 'Se eliminó «$name»';
  }

  @override
  String get delivery_is_uncertain_recovering_without_resending =>
      'La entrega es incierta; se está recuperando sin reenviar…';

  @override
  String get desktop_gateway_url_optional =>
      'URL del Desktop Gateway (opcional)';

  @override
  String get desktop_gateway_is_not_configured_for_this_connection =>
      'Desktop Gateway no está configurado para esta conexión.';

  @override
  String get desktop_app => 'Aplicación de escritorio';

  @override
  String get developer_tool_calls =>
      'Llamadas a herramientas del desarrollador';

  @override
  String get discord_chats => 'Chats de Discord';

  @override
  String get dismiss => 'Descartar';

  @override
  String get do_not_run_this_command => 'No ejecutes este comando.';

  @override
  String get documents_archives_audio_video_or_data =>
      'Documentos, archivos comprimidos, audio, vídeo o datos';

  @override
  String get download => 'Descargar';

  @override
  String download_failed(Object error) {
    return 'Error de descarga: $error';
  }

  @override
  String get durable_facts_hermes_keeps_about_you =>
      'Datos duraderos que Hermes guarda sobre ti';

  @override
  String get durable_work_inside_one_of_your_projects_shared_with_desktop =>
      'Trabajo duradero dentro de uno de tus proyectos, compartido con Desktop.';

  @override
  String get edit => 'Editar';

  @override
  String get edit_connection => 'Editar conexión';

  @override
  String get edit_cron_job => 'Editar tarea de Cron';

  @override
  String get edit_gateway_connection => 'Editar conexión de Gateway';

  @override
  String get edit_and_resend => 'Editar y reenviar';

  @override
  String get enable_notifications => 'Activar notificaciones';

  @override
  String get enable_notifications_description =>
      'Si lo desactivas, se desactivan todas las notificaciones siguientes.';

  @override
  String get enables_file_attachments_through_the_desktop_remote_gateway =>
      'Habilita los archivos adjuntos a través del Gateway remoto de Desktop.';

  @override
  String get enter_a_name => 'Escribe un nombre';

  @override
  String get enter_a_passphrase => 'Escribe una frase de contraseña.';

  @override
  String get enter_the_passphrase_for_this_backup =>
      'Escribe la frase de contraseña de esta copia de seguridad.';

  @override
  String get every_conversation_is_already_assigned_to_a_project =>
      'Todas las conversaciones ya están asignadas a un proyecto.';

  @override
  String get everything_not_yet_native_in_the_authenticated_web_dashboard =>
      'Todo lo que aún no es nativo, en el panel web autenticado';

  @override
  String get explain_the_attached_content_clearly =>
      'Explica claramente el contenido adjunto.';

  @override
  String explain_this_content_clearly(Object text) {
    return 'Explica claramente este contenido:\n\n$text';
  }

  @override
  String
  get explicit_choices_adjust_android_accessibility_text_size_system_leaves_it =>
      'Las opciones explícitas ajustan el tamaño de texto de accesibilidad de Android; «Sistema» lo deja sin cambios.';

  @override
  String get export_label => 'Exportar';

  @override
  String get export_share => 'Exportar / compartir';

  @override
  String get external_api_clients => 'Clientes externos de la API';

  @override
  String get extra_high => 'Muy alto';

  @override
  String get extract_tasks => 'Extraer tareas';

  @override
  String
  get extract_the_decisions_deadlines_owners_and_actionable_action_items_from =>
      'Extrae del contenido adjunto las decisiones, los plazos, los responsables y las tareas accionables.';

  @override
  String
  extract_the_decisions_deadlines_owners_and_actionable_action_items_from_2(
    Object text,
  ) {
    return 'Extrae de este contenido las decisiones, los plazos, los responsables y las tareas accionables:\n\n$text';
  }

  @override
  String failed_to_add_job(Object error) {
    return 'No se pudo agregar la tarea: $error';
  }

  @override
  String get failed_to_load_cron_jobs =>
      'No se pudieron cargar las tareas de Cron';

  @override
  String get failed_to_load_memory => 'No se pudo cargar la memoria';

  @override
  String get failed_to_load_messages => 'No se pudieron cargar los mensajes';

  @override
  String get failed_to_load_settings => 'No se pudieron cargar los ajustes';

  @override
  String get failed_to_load_skills => 'No se pudieron cargar las habilidades';

  @override
  String failed_to_update_job(Object error) {
    return 'No se pudo actualizar la tarea: $error';
  }

  @override
  String failed(Object error) {
    return 'Error: $error';
  }

  @override
  String get file_attached_document_catalog_registration_is_pending =>
      'Archivo adjuntado; el registro en el catálogo de documentos está pendiente.';

  @override
  String get file_reference_added_to_chat =>
      'Referencia de archivo agregada al chat';

  @override
  String get files => 'Archivos';

  @override
  String get fill_from_document => 'Rellenar desde el documento';

  @override
  String get folder_is_empty => 'La carpeta está vacía';

  @override
  String get folders => 'Carpetas';

  @override
  String get full_text => 'Texto completo';

  @override
  String get gateway_api_access => 'Acceso a la API del Gateway';

  @override
  String get gateway_connected_but_the_dashboard_could_not_be_reached_or =>
      'Gateway conectado, pero no se pudo alcanzar o autenticar el panel. Revisa los detalles del panel o bórralos para omitirlo.';

  @override
  String get gateway_path_prefix => 'Prefijo de ruta del Gateway';

  @override
  String get go_to_end => 'Ir al final';

  @override
  String get hermes_agent => 'Ares - formerly Hermes Android';

  @override
  String get hermes_agent_for_android => 'Ares - formerly Hermes Android';

  @override
  String get hermes_could_not_accept_the_answer_please_try_again =>
      'Hermes no pudo aceptar la respuesta. Inténtalo de nuevo.';

  @override
  String get hermes_could_not_load_your_saved_connections =>
      'Hermes no pudo cargar tus conexiones guardadas';

  @override
  String get hermes_did_not_accept_the_response_please_try_again =>
      'Hermes no aceptó la respuesta. Inténtalo de nuevo.';

  @override
  String get hermes_is_responding => 'Hermes está respondiendo…';

  @override
  String get hermes_is_waiting_for_input => 'Hermes está esperando tu entrada…';

  @override
  String get hermes_keeps_android_accessibility_text_scaling_active =>
      'Ares mantiene activo el escalado de texto de accesibilidad de Android.';

  @override
  String get hermes_needs_your_input => 'Hermes necesita tu entrada';

  @override
  String get hermes_profile_optional => 'Perfil de Hermes (opcional)';

  @override
  String get hermes_profile_must_be_a_plain_profile_name_such_as =>
      'El perfil de Hermes debe ser un nombre de perfil simple como «sol», no una ruta.';

  @override
  String get hermes_reasoning_details => 'Detalles de razonamiento de Hermes';

  @override
  String hermes_recovery_is_unavailable(Object error) {
    return 'La recuperación de Hermes no está disponible: $error';
  }

  @override
  String get hermes_stopped_recovery_safely_no_prompt_was_resent =>
      'Hermes detuvo la recuperación de forma segura. No se reenvió ningún prompt.';

  @override
  String get hide_passphrase => 'Ocultar frase de contraseña';

  @override
  String get home_needs_your_recent_chats_to_know_what_deserves_your =>
      'El inicio necesita tus chats recientes para saber qué merece tu atención. Comprueba que el Gateway sea accesible y vuelve a intentarlo.';

  @override
  String get host => 'Host';

  @override
  String get image_selection_was_interrupted_try_again =>
      'La selección de imagen se interrumpió. Inténtalo de nuevo.';

  @override
  String get import_label => 'Importar';

  @override
  String get inbox => 'Bandeja de entrada';

  @override
  String get inbox_is_clear => 'La bandeja de entrada está vacía';

  @override
  String get input_needed => 'Se necesita tu respuesta';

  @override
  String get input_needed_description =>
      'Hermes hizo una pregunta o necesita una contraseña o secreto.';

  @override
  String get insert_a_remote_file_reference =>
      'Insertar una referencia remota a @file';

  @override
  String get invalid_port_number => 'Número de puerto no válido.';

  @override
  String get job_paused => 'Tarea en pausa';

  @override
  String get job_resumed => 'Tarea reanudada';

  @override
  String get job_triggered => 'Tarea activada';

  @override
  String get label => 'Etiqueta';

  @override
  String last_activity(Object day, Object month, Object year) {
    return 'Última actividad $day/$month/$year';
  }

  @override
  String last(Object lastRun) {
    return 'Última: $lastRun';
  }

  @override
  String get leave_blank_for_default_8642_443_with_https =>
      'Déjalo en blanco para usar el valor predeterminado (8642; 443 con https)';

  @override
  String get leave_blank_for_default_9119 =>
      'Déjalo en blanco para usar el valor predeterminado (9119)';

  @override
  String get light => 'Claro';

  @override
  String listening(Object elapsed) {
    return 'Escuchando • $elapsed';
  }

  @override
  String listening_elapsed(Object elapsed) {
    return 'Escuchando, tiempo transcurrido: $elapsed';
  }

  @override
  String get load_more => 'Cargar más…';

  @override
  String get loading => 'Cargando';

  @override
  String get location => 'Ubicación';

  @override
  String get make_sure_the_gateway_api_server_is_running_hermes_gateway =>
      'Asegúrate de que el servidor de la API del Gateway esté en ejecución\n(hermes gateway status)';

  @override
  String matches(Object assigned, Object name) {
    return 'Coincide con $name · $assigned';
  }

  @override
  String get memory => 'Memoria';

  @override
  String get memory_about_you => 'Sobre ti';

  @override
  String get memory_agent_notes => 'Notas del agente';

  @override
  String get memory_builtin_scope =>
      'Datos guardados en USER.md y MEMORY.md de este perfil. Los proveedores de memoria externos (incluido MemPalace) no se muestran aquí.';

  @override
  String get memory_read_only =>
      'Solo lectura. Pide a Hermes en el chat que corrija u olvide un dato.';

  @override
  String get memory_unavailable =>
      'Este servidor o perfil no puede proporcionar datos guardados. Comprueba el perfil seleccionado y actualiza Hermes si es necesario.';

  @override
  String get memory_load_error =>
      'Comprueba la conexión y la autenticación del panel e inténtalo de nuevo.';

  @override
  String get memory_read_full_fact => 'Leer el dato completo';

  @override
  String get memory_full_fact_requires_update =>
      'Los datos completos requieren un servidor Hermes más reciente. Actualiza Hermes y recarga la lista.';

  @override
  String get memory_fact_detail_error =>
      'No se pudo cargar el dato completo. Puede haber cambiado; actualiza la lista e inténtalo de nuevo.';

  @override
  String get memory_entries_are_cross_session_facts_the_agent_remembers_they =>
      'Los datos guardados aparecerán aquí cuando Hermes los recuerde.';

  @override
  String get merge => 'Combinar';

  @override
  String get message => 'Mensaje';

  @override
  String get message_hermes => 'Enviar un mensaje a Hermes…';

  @override
  String get message_actions => 'Acciones del mensaje';

  @override
  String get message_copied => 'Mensaje copiado';

  @override
  String get migrating => 'Migrando…';

  @override
  String get migration_complete => 'Migración completada';

  @override
  String get migration_failed_local_spaces_were_kept_unchanged =>
      'La migración falló. Los espacios locales no se modificaron.';

  @override
  String get migration_incomplete => 'Migración incompleta';

  @override
  String get migration_preview => 'Vista previa de la migración';

  @override
  String get model => 'Modelo';

  @override
  String get model_and_thinking_for_this_chat =>
      'Modelo y razonamiento para este chat';

  @override
  String model_was_not_changed(Object error) {
    return 'El modelo no cambió: $error';
  }

  @override
  String get move_attachment_next => 'Mover el adjunto al siguiente';

  @override
  String get move_attachment_previous => 'Mover el adjunto al anterior';

  @override
  String get move_chat => 'Mover chat';

  @override
  String get move_conversation => 'Mover conversación';

  @override
  String get move_to_project => 'Mover a un proyecto';

  @override
  String get move_to_space => 'Mover a un espacio';

  @override
  String get moved_to_a_project => 'Movido a un proyecto';

  @override
  String moved_to(Object label) {
    return 'Movido a $label';
  }

  @override
  String get name => 'Nombre';

  @override
  String get name_prompt_and_schedule_are_required =>
      'El nombre, el prompt y la programación son obligatorios';

  @override
  String get nav_activity => 'Actividad';

  @override
  String get nav_projects => 'Proyectos';

  @override
  String get needs_a_correction_aware_filing_contract_in_the_hermes_gateway =>
      'Requiere un contrato de archivado con corrección de errores en el Gateway de Hermes.';

  @override
  String get needs_a_reachable_hermes_dashboard_check_the_host_port_and =>
      'Requiere un panel de Hermes accesible. Comprueba el host, el puerto y las credenciales de esta conexión.';

  @override
  String get needs_a_server_authoritative_assets_index_in_the_hermes_gateway =>
      'Requiere un índice de recursos autoritativo del servidor en el Gateway de Hermes.';

  @override
  String get needs_durable_pin_ordering_batch_mutation_and_undo_contracts_in =>
      'Requiere contratos de orden de fijados, mutación por lotes y deshacer en el Gateway de Hermes.';

  @override
  String get needs_you => 'Te necesita';

  @override
  String get new_label => 'Nuevo';

  @override
  String get new_chat => 'Nuevo chat';

  @override
  String get new_chat_2 => 'Nuevo chat';

  @override
  String new_chat_3(Object projectName) {
    return 'Nuevo chat · $projectName';
  }

  @override
  String get new_project => 'Nuevo proyecto';

  @override
  String get new_space => 'Nuevo espacio';

  @override
  String next(Object nextRun) {
    return 'Próxima: $nextRun';
  }

  @override
  String get nginx_injects_auth_app_sends_clean_requests =>
      'Nginx inyecta la autenticación; la aplicación envía solicitudes limpias';

  @override
  String get no_tts_voices_found_ninstall_google_text_to_speech_and =>
      'No se encontraron voces de TTS.\nInstala Google Text-to-Speech y descarga los datos de voz.';

  @override
  String get no_active_projects_on_this_gateway =>
      'No hay proyectos activos en este Gateway';

  @override
  String get no_activity_yet => 'Aún no hay actividad';

  @override
  String get no_chat_is_blocked_running_or_waiting_to_be_resumed =>
      'Ningún chat está bloqueado, en ejecución o esperando reanudarse. Inicia uno nuevo cuando quieras.';

  @override
  String no_chats_in_this_project_match(Object searchQuery) {
    return 'Ningún chat de este proyecto coincide con «$searchQuery».';
  }

  @override
  String get no_chats_in_this_space_yet_tap_to_start_one =>
      'Aún no hay chats en este espacio. Toca + para iniciar uno.';

  @override
  String get no_chats_yet => 'Aún no hay chats';

  @override
  String get no_connections => 'Sin conexiones';

  @override
  String get no_conversation_matches_this_view =>
      'Ninguna conversación coincide con esta vista.';

  @override
  String get no_cron_jobs => 'No hay tareas de Cron';

  @override
  String get no_folders_yet => 'Aún no hay carpetas';

  @override
  String get no_local_spaces_were_found_for_this_connection_so_projects =>
      'No se encontraron espacios locales para esta conexión, así que los proyectos ya son la única forma de organización en uso.';

  @override
  String get no_matches => 'Sin coincidencias';

  @override
  String get no_memory_entries => 'No hay entradas de memoria';

  @override
  String get no_message_content_matches =>
      'No hay coincidencias en el contenido de los mensajes';

  @override
  String get no_new_messages => 'No hay mensajes nuevos';

  @override
  String get no_projects_yet => 'Aún no hay proyectos';

  @override
  String get no_runs_yet => 'Aún no hay ejecuciones.';

  @override
  String no_server_project_matches_this_name(Object assigned) {
    return 'Ningún proyecto del servidor coincide con este nombre · $assigned';
  }

  @override
  String get no_sessions_yet => 'Aún no hay sesiones';

  @override
  String get no_skills_found => 'No se encontraron habilidades';

  @override
  String get no_spaces_on_this_device => 'No hay espacios en este dispositivo';

  @override
  String get no_text_shared => 'No se compartió texto';

  @override
  String get no_turn_is_blocked_in_flight_or_recently_finished_work =>
      'Ningún turno está bloqueado, en curso o finalizado recientemente. El trabajo que inicies aparecerá aquí.';

  @override
  String get no_turn_needs_your_input_or_has_failed =>
      'Ningún turno necesita tu entrada ni ha fallado.';

  @override
  String get no_unassigned_chats => 'No hay chats sin asignar.';

  @override
  String get nothing_changed_in_the_last_seven_days =>
      'Nada cambió en los últimos siete días.';

  @override
  String get nothing_has_moved_yet_this_is_only_what_a_migration =>
      'Todavía no se ha movido nada; esto es solo lo que haría una migración.';

  @override
  String get nothing_here => 'No hay nada aquí';

  @override
  String get nothing_is_running => 'No hay nada en ejecución';

  @override
  String get nothing_needs_you => 'Nada te necesita';

  @override
  String get nothing_to_migrate => 'Nada que migrar';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get windows_notifications_blocked =>
      'Las notificaciones no están disponibles. Usa la aplicación Ares instalada y revisa Configuración → Sistema → Notificaciones en Windows.';

  @override
  String get windows_notification_diagnostics => 'Lo que Ares envió a Windows';

  @override
  String get chat_activity_share => 'Compartir actividad del chat';

  @override
  String get chat_activity_share_hint =>
      'Indica a un gateway compatible conectado cuándo usas este chat para que su complemento de notificaciones del teléfono evite alertas duplicadas. No se envían claves ni texto de mensajes.';

  @override
  String get completion_sound => 'Sonido de finalización';

  @override
  String get completion_sound_system => 'Predeterminado del sistema';

  @override
  String get completion_sound_mail => 'Correo';

  @override
  String get completion_sound_reminder => 'Recordatorio';

  @override
  String get completion_sound_silent => 'Silencio';

  @override
  String get completion_sound_scope =>
      'Suena al finalizar respuestas, en la notificación de prueba y dentro de la aplicación. Las aprobaciones y otras alertas conservan su sonido habitual.';

  @override
  String get completion_sound_scope_android =>
      'Suena al finalizar respuestas, en la notificación de prueba y dentro de la aplicación. Las aprobaciones, otras alertas, las notificaciones en segundo plano del servidor y los mensajes de Android Auto conservan su sonido habitual.';

  @override
  String get notification_open_action => 'Abrir';

  @override
  String get app_sounds_mute => 'Silenciar sonidos de la aplicación';

  @override
  String get app_sounds_mute_hint =>
      'Desactiva el sonido de finalización que Ares reproduce mientras está abierto. Las notificaciones conservan su propio sonido.';

  @override
  String get notifications_permission_denied =>
      'Las notificaciones están bloqueadas por el sistema. Actívalas para esta app en los ajustes de Android.';

  @override
  String get off_no_thinking => 'Desactivado (sin razonamiento)';

  @override
  String get offline_showing_the_last_known_activity =>
      'Sin conexión: se muestra la última actividad conocida.';

  @override
  String get offline_showing_the_last_known_chats =>
      'Sin conexión: se muestran los últimos chats conocidos';

  @override
  String get offline_showing_the_last_known_projects =>
      'Sin conexión: se muestran los últimos proyectos conocidos.';

  @override
  String get on_this_device => 'En este dispositivo';

  @override
  String get on_device => 'En el dispositivo';

  @override
  String get open_inbox => 'Abrir bandeja de entrada';

  @override
  String open_inbox_2(Object count) {
    return 'Abrir bandeja de entrada ($count)';
  }

  @override
  String get open_the_hermes_dashboard => 'Abrir el panel de Hermes';

  @override
  String get optional_for_the_memory_cron_skills_settings_tabs_leave_blank =>
      'Opcional. Para las pestañas Memoria/Cron/Habilidades/Ajustes. Déjalo en blanco para usar el puerto predeterminado del panel (9119) sin inicio de sesión.';

  @override
  String get organization => 'Organización';

  @override
  String get other_answer => 'Otra respuesta';

  @override
  String get overview => 'Resumen';

  @override
  String get passphrase => 'Frase de contraseña';

  @override
  String get password_optional => 'Contraseña (opcional)';

  @override
  String get phone_or_tablet => 'Teléfono o tableta';

  @override
  String get pin_batch_and_undo => 'Fijar, por lotes y deshacer';

  @override
  String get plugin_notifications => 'Notificaciones de complementos';

  @override
  String get plugin_notifications_description =>
      'La puerta de enlace envió un aviso mientras la app estaba en segundo plano.';

  @override
  String get port => 'Puerto';

  @override
  String get preparing_attachments => 'Preparando adjuntos…';

  @override
  String get preview_truncated => 'Vista previa truncada';

  @override
  String get preview_unavailable => 'Vista previa no disponible';

  @override
  String get profile => 'Perfil';

  @override
  String get profile_default_model => 'Modelo predeterminado del perfil';

  @override
  String profile_default_set_to_chats_with_their_own_model_keep(
    Object selectedModel,
  ) {
    return 'Valor predeterminado del perfil establecido en $selectedModel. Los chats con su propio modelo conservan esa anulación.';
  }

  @override
  String
  get profile_this_connection_chats_as_when_the_dashboard_serves_several =>
      'Perfil con el que chatea esta conexión cuando el panel sirve varios perfiles. Déjalo en blanco para un panel aislado por perfil.';

  @override
  String get project => 'Proyecto';

  @override
  String get project_actions => 'Acciones del proyecto';

  @override
  String get project_chat => 'Chat del proyecto';

  @override
  String get project_chats_unavailable => 'Chats del proyecto no disponibles';

  @override
  String get projects => 'Proyectos';

  @override
  String get projects_group_related_chats_files_and_activity_and_stay_in =>
      'Los proyectos agrupan chats, archivos y actividad relacionados, y se mantienen sincronizados con Hermes en tu computadora.';

  @override
  String
  get projects_need_a_desktop_gateway_connection_add_the_desktop_gateway =>
      'Los proyectos necesitan una conexión con Desktop Gateway. Agrega la URL del Desktop Gateway a esta conexión para organizar chats en todos tus dispositivos.';

  @override
  String get projects_unavailable => 'Proyectos no disponibles';

  @override
  String get projects_activity_new_navigation =>
      'Proyectos, Actividad: nueva navegación';

  @override
  String get promote_to_project => 'Promover a proyecto';

  @override
  String get prompt => 'Prompt';

  @override
  String get protect_this_backup => 'Protege esta copia de seguridad';

  @override
  String get provider => 'Proveedor';

  @override
  String get proxy_injects_auth_app_sends_clean_requests =>
      'El proxy inyecta la autenticación; la aplicación envía solicitudes limpias';

  @override
  String get quick_chat => 'Chat rápido';

  @override
  String get quick_chats_appear_here_after_their_retention_period =>
      'Los chats rápidos aparecen aquí después de su período de retención.';

  @override
  String get read_aloud => 'Leer en voz alta';

  @override
  String get read_aloud_is_unavailable_on_this_device =>
      'Leer en voz alta no está disponible en este dispositivo';

  @override
  String get reading_response_aloud => 'Leyendo la respuesta en voz alta';

  @override
  String get ready_to_upload => 'Listo para subir';

  @override
  String get reasoning => 'Razonamiento';

  @override
  String get recently_completed => 'Completado recientemente';

  @override
  String get recently_active => 'Actividad reciente';

  @override
  String get recovering_hermes => 'Recuperando Hermes…';

  @override
  String get refresh => 'Actualizar';

  @override
  String get regenerate_response => 'Regenerar respuesta';

  @override
  String get remove_attachment => 'Quitar adjunto';

  @override
  String get rename => 'Cambiar nombre';

  @override
  String get rename_chat => 'Cambiar nombre del chat';

  @override
  String get rename_project => 'Cambiar nombre del proyecto';

  @override
  String get rename_space => 'Cambiar nombre del espacio';

  @override
  String rename_2(Object projectName) {
    return 'Cambiar nombre de $projectName';
  }

  @override
  String rename_3(Object name) {
    return 'Cambiar nombre de $name';
  }

  @override
  String get replace => 'Reemplazar';

  @override
  String get repositories => 'Repositorios';

  @override
  String
  get research_the_attached_content_verify_the_important_claims_and_cite =>
      'Investiga el contenido adjunto, verifica las afirmaciones importantes y cita las fuentes.';

  @override
  String research_this_content_verify_the_important_claims_and_cite_sources(
    Object text,
  ) {
    return 'Investiga este contenido, verifica las afirmaciones importantes y cita las fuentes:\n\n$text';
  }

  @override
  String reset_failed_the_secure_storage_may_need_reinstall(Object retryError) {
    return 'Error al restablecer: $retryError. Es posible que haya que reinstalar el almacenamiento seguro.';
  }

  @override
  String get reset_saved_connections => 'Restablecer conexiones guardadas';

  @override
  String get responding => 'Respondiendo…';

  @override
  String response_closed_locally_gateway_stop_failed(Object error) {
    return 'Respuesta cerrada localmente; error al detener el Gateway: $error';
  }

  @override
  String get response_closed_locally_no_active_gateway_turn_was_found =>
      'Respuesta cerrada localmente; no se encontró ningún turno activo del Gateway.';

  @override
  String get response_complete => 'Respuesta completada';

  @override
  String get response_complete_description =>
      'Un turno se completó mientras la app estaba en segundo plano.';

  @override
  String get response_ready => 'Respuesta lista';

  @override
  String get response_stopped => 'Respuesta detenida.';

  @override
  String get restore => 'Restaurar';

  @override
  String get restore_configuration => 'Restaurar configuración';

  @override
  String get restore_project => 'Restaurar proyecto';

  @override
  String get retry => 'Reintentar';

  @override
  String retry_failed_for_the_draft_and_prompt_were_kept(Object name) {
    return 'Error al reintentar $name. El borrador y el prompt se conservaron.';
  }

  @override
  String get retry_upload => 'Reintentar subida';

  @override
  String retrying(Object name) {
    return 'Reintentando $name…';
  }

  @override
  String get review_local_spaces => 'Revisar espacios locales';

  @override
  String get review_or_promote_quick_chats_past_their_retention_period =>
      'Revisar o promover chats rápidos que superaron su período de retención';

  @override
  String get review_the_attached_content => 'Revisa el contenido adjunto.';

  @override
  String get run_only_this_command => 'Ejecuta solo este comando.';

  @override
  String get running_now => 'En ejecución';

  @override
  String get save => 'Guardar';

  @override
  String get save_changes => 'Guardar cambios';

  @override
  String get save_a_permanent_rule_in_the_hermes_configuration =>
      'Guarda una regla permanente en la configuración de Hermes.';

  @override
  String get save_the_durable_facts_from_the_attached_content_to_memory =>
      'Guarda los datos duraderos del contenido adjunto en la memoria y confirma qué se conservó.';

  @override
  String save_the_durable_facts_from_this_content_to_memory_then(Object text) {
    return 'Guarda los datos duraderos de este contenido en la memoria y confirma qué se conservó:\n\n$text';
  }

  @override
  String get save_your_connections_and_settings_to_an_encrypted_file_then =>
      'Guarda tus conexiones y ajustes en un archivo cifrado y restáuralos tras reinstalar o en otro dispositivo.';

  @override
  String save_2(Object filename) {
    return 'Guardar $filename';
  }

  @override
  String get schedule => 'Programación';

  @override
  String get scheduled_jobs_and_their_last_runs =>
      'Tareas programadas y sus últimas ejecuciones';

  @override
  String get scheduled_tasks => 'Tareas programadas';

  @override
  String get script_only_no_agent => 'Solo script (sin agente)';

  @override
  String get scroll_horizontally => 'Desplazar horizontalmente';

  @override
  String get search_all_chats => 'Buscar en todos los chats';

  @override
  String get search_all_message_content =>
      'Buscar en todo el contenido de los mensajes';

  @override
  String get search_chats => 'Buscar chats';

  @override
  String get search_conversations => 'Buscar conversaciones';

  @override
  String get search_loaded_chats => 'Buscar en los chats cargados';

  @override
  String get search_mode => 'Modo de búsqueda';

  @override
  String get select_one_option_or_enter_another_answer =>
      'Selecciona una opción o escribe otra respuesta.';

  @override
  String get select_one_or_more_options_then_continue =>
      'Selecciona una o más opciones y continúa.';

  @override
  String get select_text => 'Seleccionar texto';

  @override
  String get send => 'Enviar';

  @override
  String send_failed(Object error) {
    return 'Error de envío: $error';
  }

  @override
  String send_failed_api_only_permission_denied(Object error) {
    return 'Error de envío: $error. El servidor rechazó esta escritura para el principal de la clave de API. Si este chat pertenece al Dashboard, añadir el usuario y la contraseña del Dashboard de esta conexión podría permitir el envío; el servidor también puede estar rechazándolo de forma deliberada.';
  }

  @override
  String get send_message => 'Enviar mensaje';

  @override
  String get send_test_notification => 'Enviar notificación de prueba';

  @override
  String get session_sources => 'Fuentes de sesiones';

  @override
  String get session_deleted_from_remote_hermes =>
      'Sesión eliminada del Hermes remoto.';

  @override
  String session_search_failed(Object error) {
    return 'Error en la búsqueda de sesiones: $error';
  }

  @override
  String get set_profile_default => 'Establecer como predeterminado del perfil';

  @override
  String get settings => 'Ajustes';

  @override
  String get share_to_hermes => 'Compartir con Hermes';

  @override
  String get show_passphrase => 'Mostrar frase de contraseña';

  @override
  String get show_tool_calls_thinking_and_message_metadata =>
      'Mostrar llamadas a herramientas, razonamiento y metadatos de mensajes';

  @override
  String get signal_messages => 'Mensajes de Signal';

  @override
  String get skills => 'Habilidades';

  @override
  String skills_2(Object count) {
    return 'Habilidades ($count)';
  }

  @override
  String get skills_and_tools => 'Habilidades y herramientas';

  @override
  String get skip => 'Omitir';

  @override
  String get slack_chats => 'Chats de Slack';

  @override
  String source(Object source) {
    return 'Origen: $source';
  }

  @override
  String get space_actions => 'Acciones del espacio';

  @override
  String get spaces => 'Espacios';

  @override
  String get speak_to_hermes => 'Habla con Hermes';

  @override
  String get speech_recognition_is_unavailable =>
      'El reconocimiento de voz no está disponible';

  @override
  String get spoken_replies => 'Respuestas habladas';

  @override
  String get spoken_replies_off => 'Respuestas habladas desactivadas';

  @override
  String get spoken_replies_on => 'Respuestas habladas activadas';

  @override
  String get stalled_no_update_from_hermes =>
      'Estancado: sin actualizaciones de Hermes';

  @override
  String get start_something_new => 'Empezar algo nuevo';

  @override
  String get start_voice_input => 'Iniciar entrada de voz';

  @override
  String get starting_hermes => 'Iniciando Hermes…';

  @override
  String get media_card_download => 'Descargar archivo';

  @override
  String get media_card_tap_to_download => 'Toca para descargar';

  @override
  String get still_loading_your_projects => 'Todavía cargando tus proyectos.';

  @override
  String get stop => 'Detener';

  @override
  String get stop_response => 'Detener respuesta';

  @override
  String get stop_voice_input => 'Detener entrada de voz';

  @override
  String get submitted_waiting_for_hermes => 'Enviado, esperando a Hermes';

  @override
  String get suggest_projects_and_learn_from_your_corrections =>
      'Sugerir proyectos y aprender de tus correcciones';

  @override
  String get summarize_the_attached_content => 'Resume el contenido adjunto.';

  @override
  String summarize_this_content(Object text) {
    return 'Resume este contenido:\n\n$text';
  }

  @override
  String get switch_profile => 'Cambiar de perfil';

  @override
  String get system => 'Sistema';

  @override
  String get take_photo => 'Tomar foto';

  @override
  String get tap_to_add_a_remote_hermes_gateway_api_server_port =>
      'Toca + para agregar un Gateway de Hermes remoto\n(servidor de API, puerto 8642)';

  @override
  String get tap_the_button_to_start_a_new_chat =>
      'Toca el botón + para iniciar un chat nuevo';

  @override
  String get telegram_messages => 'Mensajes de Telegram';

  @override
  String get terminal_sessions => 'Sesiones de terminal';

  @override
  String get test_notification_body =>
      'Si ves esto, las notificaciones funcionan correctamente.';

  @override
  String get test_notification_sent => 'Notificación de prueba enviada.';

  @override
  String get test_notification_title => 'Prueba de notificaciones de Hermes';

  @override
  String get test_notification_unsupported =>
      'No se pudo enviar la notificación; comprueba que el sistema permita notificaciones.';

  @override
  String get text_size => 'Tamaño del texto';

  @override
  String get text_size_preview => 'Vista previa del tamaño del texto';

  @override
  String text_size_2(Object label) {
    return 'Tamaño del texto: $label';
  }

  @override
  String get the_api_key_could_not_be_stored_securely =>
      'No se pudo almacenar la clave de API de forma segura.';

  @override
  String get the_project_will_move_to_archived_its_chats_and_files =>
      'El proyecto pasará a «Archivado». Sus chats y archivos se conservarán intactos y podrás restaurarlo cuando quieras.';

  @override
  String get the_project_will_move_to_archived_its_chats_and_files_2 =>
      'El proyecto pasará a «Archivado». Sus chats y archivos se conservarán intactos y podrás restaurarlo más adelante.';

  @override
  String get the_active_profile_did_not_return_any_selectable_models =>
      'El perfil activo no devolvió ningún modelo seleccionable.';

  @override
  String get the_backup_could_not_be_exported =>
      'No se pudo exportar la copia de seguridad.';

  @override
  String get the_backup_could_not_be_restored =>
      'No se pudo restaurar la copia de seguridad.';

  @override
  String get the_connection_could_not_be_deleted_safely =>
      'No se pudo eliminar la conexión de forma segura.';

  @override
  String get the_connection_could_not_be_stored_securely =>
      'No se pudo almacenar la conexión de forma segura.';

  @override
  String get the_dashboard_credentials_could_not_be_stored_securely =>
      'No se pudieron almacenar las credenciales del panel de forma segura.';

  @override
  String get the_detached_reply_failed => 'La respuesta desacoplada falló.';

  @override
  String the_detached_reply_failed_2(Object error) {
    return 'La respuesta desacoplada falló: $error';
  }

  @override
  String get the_file_contains_your_api_keys_and_dashboard_password_so =>
      'El archivo contiene tus claves de API y la contraseña del panel, por lo que está cifrado. Sin esta frase de contraseña no se puede restaurar la copia de seguridad.';

  @override
  String get the_last_turn_failed => 'El último turno falló';

  @override
  String the_local_connection_store_looks_damaged_you_can_reset_the(
    Object errorType,
  ) {
    return 'El almacén local de conexiones parece dañado ($errorType). Puedes restablecer las conexiones guardadas y empezar de cero. Los chats de tu Gateway no se ven afectados.';
  }

  @override
  String get the_model_only_rewrites_your_question_into_a_short_full =>
      'El modelo solo reescribe tu pregunta como una consulta breve de texto completo. Hermes usa las credenciales del proveedor ya configuradas en el host.';

  @override
  String get the_server_has_not_reported_folders_for_this_project_yet =>
      'El servidor aún no ha informado carpetas para este proyecto. Archivos globales sigue disponible en Más.';

  @override
  String get the_turn_failed => 'El turno falló';

  @override
  String get the_two_passphrases_do_not_match =>
      'Las dos frases de contraseña no coinciden.';

  @override
  String get the_value_is_sent_directly_to_the_active_hermes_gateway =>
      'El valor se envía directamente al Gateway de Hermes activo y esta aplicación de Android no lo guarda.';

  @override
  String get there_are_no_visible_files_in_this_server_folder =>
      'No hay archivos visibles en esta carpeta del servidor.';

  @override
  String get thinking_effort => 'Esfuerzo de razonamiento';

  @override
  String get this_hermes_gateway_does_not_support_opening_a_project_yet =>
      'Este Gateway de Hermes aún no admite abrir proyectos. Actualiza Hermes en el servidor para explorar un proyecto desde el teléfono.';

  @override
  String get this_hermes_gateway_is_older_than_server_side_projects_so =>
      'Este Gateway de Hermes es anterior a los proyectos del servidor, por lo que los chats se agrupan solo en este dispositivo. Actualiza Hermes para compartir los mismos proyectos entre tus dispositivos.';

  @override
  String get this_project_has_no_folder_to_open_the_chat_in =>
      'Este proyecto necesita una carpeta antes de iniciar un chat en él. Agrega una carpeta e inténtalo de nuevo.';

  @override
  String get this_chat_has_no_messages_available_in_the_desktop_session =>
      'Este chat aún no tiene mensajes disponibles en la sesión de Desktop.';

  @override
  String get this_creates_a_permanent_rule_in_hermes_review_the_full =>
      'Esto crea una regla permanente en Hermes. Revisa el comando completo antes de confirmar.';

  @override
  String get this_gateway_does_not_host_projects_yet_update_the_gateway =>
      'Este Gateway aún no aloja proyectos. Actualiza el Gateway para organizar chats en todos tus dispositivos.';

  @override
  String get this_permanently_deletes_the_project_chats_will_not_be_deleted =>
      'Esto elimina el proyecto de forma permanente. Los chats no se eliminarán; volverán a «Sin asignar».';

  @override
  String get this_server_doesn_t_offer_background_recovery_chats_run_live =>
      'Este servidor no ofrece recuperación en segundo plano; los chats se ejecutan en vivo';

  @override
  String get this_week => 'Esta semana';

  @override
  String get titles_previews_and_models => 'Títulos, vistas previas y modelos';

  @override
  String get tool_activity => 'Actividad de herramientas';

  @override
  String get trigger_now => 'Ejecutar ahora';

  @override
  String get received_outcome_unknown =>
      'Turno finalizado — resultado sin confirmar';

  @override
  String get turn_completed => 'Turno completado';

  @override
  String get turn_failed => 'Turno fallido';

  @override
  String get turn_failed_description =>
      'Un turno en segundo plano terminó con un error.';

  @override
  String get turn_recovery_failed => 'Error en la recuperación del turno';

  @override
  String get unable_to_prepare_this_file_try_another_one =>
      'No se pudo preparar este archivo. Prueba con otro.';

  @override
  String get unable_to_prepare_this_image_try_another_one =>
      'No se pudo preparar esta imagen. Prueba con otra.';

  @override
  String unable_to_prepare(Object name) {
    return 'No se pudo preparar $name.';
  }

  @override
  String get unable_to_read_the_selected_image_the_selection_was_kept =>
      'No se pudo leer la imagen seleccionada. La selección se conservó.';

  @override
  String get unassigned => 'Sin asignar';

  @override
  String get unassigned_chats => 'Chats sin asignar';

  @override
  String get untitled_chat => 'Chat sin título';

  @override
  String get untitled_session => 'Sesión sin título';

  @override
  String get update_api_key => 'Actualizar clave de API';

  @override
  String get upload_failed => 'Error de subida';

  @override
  String get upload_failed_tap_retry =>
      'Error de subida • toca para reintentar';

  @override
  String uploading(Object index, Object name, Object total) {
    return 'Subiendo $index/$total: $name';
  }

  @override
  String get use_as_is => 'Usar tal cual';

  @override
  String get use_at_least_8_characters => 'Usa al menos 8 caracteres.';

  @override
  String get use_for_cron_jobs_backed_by_scripts =>
      'Úsalo para tareas de Cron respaldadas por scripts.';

  @override
  String get use_on_device => 'Usar en el dispositivo';

  @override
  String get use_the_attached_content_to_identify_and_fill_the_relevant =>
      'Usa el contenido adjunto para identificar y rellenar los campos relevantes del documento o formulario. Pregunta antes de enviar cualquier cosa.';

  @override
  String use_this_content_to_identify_and_fill_the_relevant_document(
    Object text,
  ) {
    return 'Usa este contenido para identificar y rellenar los campos relevantes del documento o formulario. Pregunta antes de enviar cualquier cosa:\n\n$text';
  }

  @override
  String get used_for_hosted_path_prefixes_and_for_the_settings_memory =>
      'Se usa para prefijos de rutas alojadas y para las pestañas Ajustes, Memoria, Habilidades y Cron. Deja el usuario y la contraseña en blanco para un panel abierto, o activa el modo de proxy cuando tu proxy inverso inyecte la autenticación del panel.';

  @override
  String get username_optional => 'Nombre de usuario (opcional)';

  @override
  String using(Object displayName) {
    return 'Usando $displayName…';
  }

  @override
  String get verbose_mode => 'Modo detallado';

  @override
  String get message_metadata => 'Detalles del mensaje';

  @override
  String get voice => 'Voz';

  @override
  String voice_setup_failed(Object error) {
    return 'Error al configurar la voz: $error';
  }

  @override
  String get waiting_for_your_input => 'Esperando tu entrada';

  @override
  String get what_hermes_knows_how_to_do => 'Lo que Hermes sabe hacer';

  @override
  String get what_should_the_agent_do => '¿Qué debe hacer el agente?';

  @override
  String get whatsapp_messages => 'Mensajes de WhatsApp';

  @override
  String get which_project => '¿Qué proyecto?';

  @override
  String get workspace => 'Espacio de trabajo';

  @override
  String get wrap_lines => 'Ajustar líneas';

  @override
  String you_can_attach_up_to_items(Object maxRemoteAttachmentDrafts) {
    return 'Puedes adjuntar hasta $maxRemoteAttachmentDrafts elementos.';
  }

  @override
  String get your_answer => 'Tu respuesta';

  @override
  String get e_g_dashboard => 'p. ej., /dashboard';

  @override
  String get e_g_dashboard_proxy_path_before_api =>
      'p. ej., /dashboard (ruta del proxy antes de /api/)';

  @override
  String get e_g_profile_peter => 'p. ej., /profile/peter';

  @override
  String get e_g_sol => 'p. ej., sol';

  @override
  String get e_g_0_9_or_every_2h => 'p. ej., 0 9 * * * o every 2h';

  @override
  String get e_g_daily_backup => 'p. ej., copia diaria';

  @override
  String downloaded(Object filename) {
    return '$filename descargado';
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
      '192.168.1.50, 100.x.y.z o hermes-machine.tailnet.ts.net';

  @override
  String get example_profile_prefix_hint_full =>
      'p. ej., /profile/peter (ruta del proxy antes de /api/ y /v1/)';

  @override
  String and_more(Object count) {
    return 'y $count más';
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
    return '$chats · solo en este dispositivo';
  }

  @override
  String spaces_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count espacios',
      one: '$count espacio',
    );
    return '$_temp0';
  }

  @override
  String get no_new_projects_needed => 'no se necesitan proyectos nuevos';

  @override
  String projects_to_create(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count proyectos por crear',
      one: '$count proyecto por crear',
    );
    return '$_temp0';
  }

  @override
  String chats_migrated_projects_created(
    Object createdProjects,
    Object linkedSessions,
  ) {
    return '$linkedSessions chats migrados · $createdProjects proyectos creados';
  }

  @override
  String chats_stayed_in_local_spaces(Object unlinkedSessions) {
    return '$unlinkedSessions chats permanecieron en espacios locales y se pueden reintentar sin riesgo.';
  }

  @override
  String model_recommended(Object provider) {
    return '$provider • Recomendado: pequeño y económico';
  }

  @override
  String session_meta(Object count, Object model, Object time) {
    return '$count mensajes • $model • $time';
  }

  @override
  String model_scope_label(Object model, Object scope) {
    return '$model • $scope';
  }

  @override
  String get this_chat => 'este chat';

  @override
  String get profile_default => 'predeterminado del perfil';

  @override
  String minutes_ago(Object count) {
    return 'hace $count min';
  }

  @override
  String hours_ago(Object count) {
    return 'hace $count h';
  }

  @override
  String days_ago(Object count) {
    return 'hace $count d';
  }

  @override
  String get now_label => 'ahora';

  @override
  String get latest_label => 'Último';

  @override
  String new_count_indicator(Object count) {
    return '$count nuevos';
  }

  @override
  String new_messages(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count mensajes nuevos',
      one: '$count mensaje nuevo',
    );
    return '$_temp0';
  }

  @override
  String activity_failed_summary(Object failures, Object total) {
    return '$failures fallidos • $total en total';
  }

  @override
  String activity_completed_summary(Object count) {
    return '$count completados';
  }

  @override
  String tool_start_observed(Object time) {
    return 'Inicio observado $time (hora local)';
  }

  @override
  String tool_last_observed(Object time) {
    return 'Última observación $time (hora local)';
  }

  @override
  String tool_result_recorded(Object time) {
    return 'Resultado registrado $time (hora local)';
  }

  @override
  String get tool_time_unavailable => 'Hora no disponible';

  @override
  String get hermes_is_using_a_tool => 'Hermes está usando una herramienta';

  @override
  String hermes_is_using_tools(Object count) {
    return 'Hermes está usando $count herramientas';
  }

  @override
  String delegated_tasks_completed(Object count) {
    return '$count tarea(s) delegada(s) completada(s)';
  }

  @override
  String delegated_tasks_active(Object count) {
    return '$count tarea(s) delegada(s) activa(s)';
  }

  @override
  String branch_main(Object label) {
    return '$label · main';
  }

  @override
  String get you_heading => '## Tú';

  @override
  String get hermes_heading => '## Hermes';

  @override
  String get action_label => 'Acción';

  @override
  String get destination_label => 'Destino';

  @override
  String get markdown_source => 'Código fuente';

  @override
  String get preview_label => 'Vista previa';

  @override
  String get share_action_summarize => 'Resumir';

  @override
  String get share_action_explain => 'Explicar';

  @override
  String get share_action_research => 'Investigar';

  @override
  String get share_action_remember => 'Recordar';

  @override
  String get text_size_small => 'Pequeño';

  @override
  String get text_size_default => 'Predeterminado';

  @override
  String get text_size_large => 'Grande';

  @override
  String get text_size_extra_large => 'Muy grande';

  @override
  String get text_size_use_system_description =>
      'Usar exactamente el tamaño de texto de accesibilidad de Android.';

  @override
  String text_size_percent_description(Object percent) {
    return '$percent% del tamaño de texto de Android.';
  }

  @override
  String text_size_label_description(Object description, Object label) {
    return '$label — $description';
  }

  @override
  String files_skipped(Object count) {
    return '$count archivo(s) omitido(s): límite, tamaño, ilegible o nombre de archivo sensible.';
  }

  @override
  String model_scope_applied(Object effort, Object model) {
    return '$model • $effort ahora se aplican solo a este chat.';
  }

  @override
  String get reasoning_minimal => 'Mínimo';

  @override
  String get reasoning_low => 'Bajo';

  @override
  String get reasoning_medium => 'Medio';

  @override
  String get reasoning_high => 'Alto';

  @override
  String get reasoning_max => 'Máximo';

  @override
  String get reasoning_ultra => 'Ultra';

  @override
  String get status_running => 'En ejecución';

  @override
  String get status_failed => 'Fallido';

  @override
  String get status_done => 'Listo';

  @override
  String get status_idle => 'Inactivo';

  @override
  String get upload_status_uploading => 'Subiendo';

  @override
  String get upload_status_uploaded => 'Subido';

  @override
  String attachment_count(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count adjuntos',
      one: '$count adjunto',
    );
    return '$_temp0';
  }

  @override
  String get action_create => 'crear';

  @override
  String get action_rename => 'cambiar el nombre de';

  @override
  String get action_archive => 'archivar';

  @override
  String get action_restore => 'restaurar';

  @override
  String get action_delete => 'eliminar';

  @override
  String get migrate => 'Migrar';

  @override
  String assigned_chats(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chats asignados',
      one: '$count chat asignado',
    );
    return '$_temp0';
  }

  @override
  String get date_today => 'Hoy';

  @override
  String get date_yesterday => 'Ayer';

  @override
  String get date_earlier => 'Anterior';

  @override
  String get nav_home => 'Inicio';

  @override
  String get nav_more => 'Más';

  @override
  String get status_completed => 'Completado';

  @override
  String get filter_all => 'Todos';

  @override
  String get filter_recent => 'Recientes';

  @override
  String connection_address_key(Object address, Object status) {
    return '$address  •  Clave: $status';
  }

  @override
  String model_via_provider(Object model, Object provider) {
    return '$model  \nmediante `$provider`';
  }

  @override
  String get deny => 'Denegar';

  @override
  String get connect => 'Conectar';

  @override
  String get appearance => 'Apariencia';

  @override
  String get connection_section => 'Conexión';

  @override
  String get about => 'Acerca de';

  @override
  String version_label(Object version) {
    return 'Versión $version';
  }

  @override
  String get matched => 'Coincidencia';

  @override
  String get search => 'Buscar';

  @override
  String get on => 'Activado';

  @override
  String get off => 'Desactivado';

  @override
  String get reasoning_off => 'Desactivado';

  @override
  String get hermes_response_ready => 'Respuesta de Hermes lista';

  @override
  String get admin_password_needed =>
      'Se necesita la contraseña de administrador';

  @override
  String get hermes_needs_a_sudo_password_for_the_pending_terminal_command =>
      'Hermes necesita una contraseña de sudo para el comando de terminal pendiente.';

  @override
  String get sudo_password => 'Contraseña de sudo';

  @override
  String get secret_needed => 'Se necesita un secreto';

  @override
  String get hermes_needs_a_secret_for_the_pending_skill =>
      'Hermes necesita un secreto para la habilidad pendiente.';

  @override
  String get secret_value => 'Valor del secreto';

  @override
  String get attached_file => 'Archivo adjunto';

  @override
  String get pin_chat => 'Fijar chat';

  @override
  String get unpin_chat => 'Dejar de fijar chat';

  @override
  String get pinned_chats => 'Fijados';

  @override
  String could_not_update_chat_pin(Object error) {
    return 'No se pudo actualizar el chat fijado: $error';
  }

  @override
  String get could_not_save_chat_spaces =>
      'No se pudieron guardar los espacios de chat en este dispositivo';

  @override
  String get chat_density => 'Densidad del chat';

  @override
  String chat_density_2(Object label) {
    return 'Densidad del chat: $label';
  }

  @override
  String get chat_density_comfortable => 'Cómoda';

  @override
  String get chat_density_compact => 'Compacta';

  @override
  String get chat_density_comfortable_description =>
      'Burbujas más amplias con una etiqueta de remitente sobre cada mensaje.';

  @override
  String get chat_density_compact_description =>
      'Burbujas más ajustadas y sin etiqueta para que quepan más mensajes en pantalla.';

  @override
  String chat_density_label_description(Object description, Object label) {
    return '$label — $description';
  }

  @override
  String
  get compact_removes_the_you_and_hermes_labels_and_trims_bubble_padding_spacing_and_side_margins =>
      'Compacta quita las etiquetas «You» y «Hermes» y reduce el relleno, el espaciado y los márgenes laterales de las burbujas.';

  @override
  String get client_certificate_mtls => 'Certificado de cliente (mTLS)';

  @override
  String get client_certificate_mtls_description =>
      'Presentar un certificado cuando un proxy HTTPS requiera TLS mutuo.';

  @override
  String get client_certificate_https_only =>
      'Los certificados de cliente solo se usan en conexiones HTTPS.';

  @override
  String get choose_certificate => 'Elegir certificado';

  @override
  String get certificate_password => 'Contraseña del certificado';

  @override
  String get this_certificate_is_password_protected =>
      'Este certificado está protegido por contraseña. Se abre mientras escribes.';

  @override
  String get enter_the_certificate_password_to_finish_loading_it =>
      'Introduce la contraseña del certificado para terminar de cargar el certificado elegido.';

  @override
  String get client_certificate_required =>
      'Carga un certificado de cliente o desactiva la opción de certificado de cliente.';

  @override
  String client_certificate_loaded(String label) {
    return 'Cargado: $label';
  }

  @override
  String get remove_certificate => 'Eliminar certificado';

  @override
  String get certificate_import_failed => 'No se pudo cargar ese certificado.';

  @override
  String get background_work => 'Trabajo en segundo plano';

  @override
  String get keep_chats_active_in_background =>
      'Mantener los chats activos en segundo plano';

  @override
  String get background_work_description =>
      'Mantiene conectados los chats iniciados por el usuario mientras la app está en segundo plano. Las conexiones inactivas pueden desconectarse. Consume más batería y datos. Desactivarlo no detiene el trabajo en el servidor.';

  @override
  String get background_work_limits =>
      'Android aún puede suspender las conexiones durante Doze o finalizar el proceso de la app. Las notificaciones tras finalizar el proceso requieren configurar push por separado. No se admite Forzar detención.';

  @override
  String get background_work_disclosure =>
      'Mientras la protección en segundo plano esté activa, se muestra una notificación obligatoria del servicio, aunque las notificaciones opcionales de chat estén desactivadas.';

  @override
  String get battery_optimisation_settings =>
      'Ajustes de optimización de batería';

  @override
  String get battery_optimisation_description =>
      'Abre los ajustes de Android para revisar las restricciones de batería. No se solicita ninguna excepción automáticamente y cambiar los ajustes no garantiza la entrega.';

  @override
  String get battery_settings_unavailable =>
      'No se pudieron abrir los ajustes de batería en este dispositivo.';

  @override
  String get background_work_save_failed =>
      'No se pudo guardar el ajuste de trabajo en segundo plano.';

  @override
  String get ongoing_chat_channel_name => 'Chats activos';

  @override
  String get ongoing_chat_channel_description =>
      'Actualizaciones silenciosas de chats iniciados por el usuario aún sin resolver';

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
  String get activity_status_unconfirmed => 'Estado sin confirmar';

  @override
  String get activity_recently_updated => 'Actualizado recientemente';

  @override
  String get activity_reconnecting =>
      'Reconectando — comprobando el estado del turno';

  @override
  String get activity_outcome_unknown =>
      'No se pudo confirmar el resultado del turno. Abre el chat para comprobarlo.';

  @override
  String get activity_chat_updated_detail =>
      'Actividad del chat registrada por el Gateway; el estado del turno en tiempo real no está disponible.';

  @override
  String get activity_updated => 'Actualizado';

  @override
  String get activity_empty_title => 'No hay actividad reciente';

  @override
  String get activity_empty_detail =>
      'Aquí aparecen los turnos iniciados en esta app y los chats del Gateway actualizados en los últimos 7 días.';

  @override
  String get activity_read_error =>
      'Actividad no pudo leer sus registros de turnos o los chats del Gateway. Comprueba la conexión y vuelve a intentarlo.';

  @override
  String get activity_chat_unavailable =>
      'Este chat ya no está disponible o no se pudo acceder al Gateway.';

  @override
  String get activity_partial_title => 'Actividad cargada parcialmente';

  @override
  String get activity_partial_detail =>
      'Se muestra un intervalo limitado de actividad de la pasarela. Puede haber más chats; desliza hacia abajo para actualizar.';

  @override
  String get provider_usage => 'Uso registrado';

  @override
  String get provider_usage_notice =>
      'Uso de Hermes de los últimos 30 días, no saldo ni precios. Configura las credenciales en el servidor Hermes; esta app no almacena claves API de proveedores.';

  @override
  String get provider_usage_failed => 'No se pudo cargar el uso registrado.';

  @override
  String get provider_usage_empty => 'No hay uso registrado de este proveedor.';

  @override
  String provider_usage_counts(String sessions, String input, String output) {
    return '$sessions sesiones · Entrada: $input · Salida: $output';
  }

  @override
  String provider_usage_costs(String estimated, String actual) {
    return 'Estimado: $estimated · Declarado: $actual';
  }

  @override
  String get provider_quota_codex => 'Suscripción a OpenAI Codex';

  @override
  String get provider_quota_claude => 'Suscripción a Claude';

  @override
  String get provider_quota_openai_api => 'Uso registrado de la API de OpenAI';

  @override
  String get provider_quota_notice =>
      'Periodos de la suscripción informados por el proveedor, separados del uso registrado en Hermes y de la facturación de la API. Las cuentas se muestran por separado; los límites de un modelo no significan que se haya agotado toda la cuota de la cuenta.';

  @override
  String get provider_quota_windows_notice =>
      'Las suscripciones a Codex y Claude tienen límites por sesión de cinco horas y por semana. Solo se muestran los periodos informados por el proveedor; los límites y las horas de restablecimiento no informados siguen sin estar disponibles. Los límites semanales pueden aplicarse a la cuenta o a modelos específicos.';

  @override
  String get provider_quota_five_hour_session => 'Sesión de 5 horas';

  @override
  String get provider_quota_unavailable =>
      'Cuota de la suscripción no disponible.';

  @override
  String get provider_quota_failed =>
      'No se pudo actualizar la cuota de la suscripción. Los valores conservados proceden de la consulta anterior.';

  @override
  String get provider_quota_account => 'Cuenta';

  @override
  String get provider_quota_unknown => 'desconocido';

  @override
  String provider_quota_state(String state) {
    return 'Estado de la cuenta: $state';
  }

  @override
  String provider_quota_scope(String scope) {
    return 'Ámbito: $scope';
  }

  @override
  String provider_quota_percent(String used, String remaining) {
    return '$used% utilizado · $remaining% restante';
  }

  @override
  String provider_quota_reset(String reset) {
    return 'Se restablece: $reset';
  }

  @override
  String get provider_quota_reset_unknown =>
      'Hora de restablecimiento no disponible.';

  @override
  String get auxiliary_models => 'Modelos auxiliares';

  @override
  String get auxiliary_notice =>
      'Elige modelos para cada tarea. Los endpoints personalizados se gestionan en el servidor. Auto sigue las reglas de herencia de la tarea.';

  @override
  String get auxiliary_inherit => 'Auto (heredar)';

  @override
  String get auxiliary_unavailable =>
      'Los ajustes auxiliares no están disponibles.';

  @override
  String get provider_oauth_title => 'Inicio de sesión con proveedores';

  @override
  String get provider_oauth_more_subtitle =>
      'Gestiona el inicio de sesión con proveedores en tu servidor Hermes';

  @override
  String get provider_oauth_settings_subtitle =>
      'Inicia sesión en tu servidor Hermes; los tokens del proveedor no se guardan en este dispositivo';

  @override
  String get provider_oauth_intro =>
      'Inicia sesión con tu proveedor en un navegador externo. Los tokens se guardan solo en tu servidor Hermes, no en este dispositivo. Iniciar sesión no selecciona un modelo de chat en esta aplicación.';

  @override
  String get provider_oauth_defaults_notice =>
      'Algunos procesos del servidor, incluido el reemplazo de cuentas gratuitas de Nous, pueden cambiar los valores predeterminados del servidor. Revisa los ajustes del servidor después de iniciar sesión.';

  @override
  String get provider_oauth_transport_init_failed =>
      'No se pudo inicializar la conexión segura seleccionada del panel. Comprueba su identidad TLS y los ajustes de conexión.';

  @override
  String get provider_oauth_https_required =>
      'El inicio de sesión con proveedores requiere una conexión HTTPS al panel de Hermes.';

  @override
  String get provider_oauth_auth_required =>
      'Configura la autenticación por contraseña del panel o un proxy de confianza antes de iniciar sesión.';

  @override
  String get provider_oauth_catalog_failed =>
      'El inicio de sesión con proveedores no está disponible en este servidor. Comprueba la autenticación del panel y actualiza el servidor si no admite OAuth de proveedores.';

  @override
  String get provider_oauth_expired =>
      'El inicio de sesión ha caducado. Vuelve a empezar.';

  @override
  String get provider_oauth_start_failed =>
      'No se pudo iniciar el acceso seguro al proveedor. Inténtalo de nuevo.';

  @override
  String get provider_oauth_denied =>
      'Se denegó el inicio de sesión. Vuelve a empezar.';

  @override
  String get provider_oauth_cancelled => 'Inicio de sesión cancelado.';

  @override
  String get provider_oauth_host_failed =>
      'El servidor no pudo completar el inicio de sesión. Vuelve a empezar.';

  @override
  String get provider_oauth_poll_failed =>
      'No se pudo comprobar el estado del inicio de sesión. Vuelve a empezar.';

  @override
  String provider_oauth_cancellation_unconfirmed(String message) {
    return '$message No se pudo confirmar la cancelación; la sesión del servidor puede continuar hasta que caduque.';
  }

  @override
  String get provider_oauth_browser_failed =>
      'No se pudo abrir el navegador externo. Inténtalo de nuevo o cancela el inicio de sesión.';

  @override
  String get provider_oauth_retry => 'Reintentar';

  @override
  String provider_oauth_complete(String provider) {
    return 'Completa el inicio de sesión de $provider';
  }

  @override
  String get provider_oauth_code_instruction =>
      'Introduce este código temporal en la página del proveedor:';

  @override
  String get provider_oauth_waiting =>
      'Esperando aprobación. Esta sesión caduca automáticamente.';

  @override
  String get provider_oauth_open_browser => 'Abrir proveedor en el navegador';

  @override
  String get provider_oauth_cancel => 'Cancelar inicio de sesión';

  @override
  String get provider_oauth_signed_out => 'Sin sesión iniciada en el servidor';

  @override
  String get provider_oauth_sign_in_again => 'Volver a iniciar sesión';

  @override
  String get provider_oauth_sign_in => 'Iniciar sesión';

  @override
  String get provider_oauth_cli_required =>
      'Inicia sesión con la CLI del proveedor en tu servidor Hermes. Este servidor no ofrece inicio de sesión en la aplicación para este proveedor.';

  @override
  String get provider_oauth_checking_account =>
      'Autorización recibida. Comprobando la cuenta del servidor…';

  @override
  String get provider_oauth_verification_unavailable =>
      'Autorización recibida; no se puede verificar la cuenta. Abre Uso para actualizar el uso de la cuenta.';

  @override
  String provider_oauth_verified_account(String email) {
    return 'Sesión iniciada en el servidor Hermes como $email. Abre Uso para actualizar el uso de la cuenta.';
  }

  @override
  String get provider_oauth_credentials_unverified =>
      'El servidor informa que hay credenciales disponibles; la identidad de la cuenta no está verificada.';

  @override
  String get provider_oauth_account_status_unknown =>
      'Estado de la cuenta del servidor no disponible.';

  @override
  String get app_language => 'Idioma de la aplicación';

  @override
  String get app_language_system => 'El del teléfono';

  @override
  String get auto_archives_after_72_hours =>
      'Se archiva automáticamente tras 72 horas';

  @override
  String get automation => 'Automatización';

  @override
  String get voice_recording_start => 'Grabar mensaje de voz';

  @override
  String get voice_recording_pause => 'Pausar grabación';

  @override
  String get voice_recording_preview => 'Reproducir grabación';

  @override
  String get voice_recording_resume => 'Continuar grabación';

  @override
  String get voice_recording_send => 'Enviar mensaje de voz';

  @override
  String get voice_recording_discard => 'Descartar grabación';

  @override
  String get voice_recording_processing => 'Preparando mensaje de voz…';

  @override
  String voice_recording_elapsed(String time) {
    return 'Grabando $time';
  }

  @override
  String voice_recording_draft(String time) {
    return 'Mensaje de voz $time';
  }

  @override
  String get voice_recording_permission =>
      'Permite el acceso al micrófono para grabar un mensaje de voz.';

  @override
  String get voice_recording_limit =>
      'Esta grabación ha alcanzado el límite de diez minutos.';

  @override
  String get voice_recording_empty => 'No se grabó audio. Inténtalo de nuevo.';

  @override
  String get voice_recording_failed =>
      'No se pudo procesar la grabación. Se han conservado los fragmentos guardados.';

  @override
  String get voice_recording_unconfirmed =>
      'No se confirmó la entrega. Tu grabación está guardada. Revisa el chat antes de volver a intentarlo.';

  @override
  String get voice_recording_submit_failed =>
      'No se pudo enviar el mensaje de voz. Tu grabación está guardada. Comprueba la conexión, el acceso al panel y los ajustes de transcripción del servidor.';

  @override
  String get voice_recording_pause_playback => 'Pausar reproducción';

  @override
  String get projects_root_title => 'Carpeta de Proyectos en el servidor';

  @override
  String get projects_root_more_subtitle =>
      'Dónde se crean las carpetas de Proyecto nuevas en el servidor';

  @override
  String get projects_root_description =>
      'Los Proyectos que crees en este teléfono reciben su carpeta aquí. Apúntala a la carpeta que usa Hermes para que el teléfono y el servidor compartan los mismos Proyectos.';

  @override
  String get projects_root_label => 'Ruta raíz de Proyectos';

  @override
  String projects_root_default_hint(String path) {
    return 'Predeterminado del servidor: $path';
  }

  @override
  String get projects_root_locked_title => 'Definido por el servidor';

  @override
  String get projects_root_locked_explanation =>
      'Este servidor limita el acceso a archivos a una sola raíz, así que la carpeta de Proyectos no se puede cambiar desde la aplicación.';

  @override
  String get projects_root_saved => 'Carpeta de Proyectos guardada.';

  @override
  String get projects_root_reset => 'Usar el valor predeterminado del servidor';

  @override
  String get projects_root_invalid_empty => 'Introduce una ruta de carpeta.';

  @override
  String get projects_root_invalid_absolute =>
      'Introduce una ruta absoluta que empiece por una barra.';

  @override
  String get projects_root_invalid_segments =>
      'Elimina los segmentos con puntos y los caracteres de control de la ruta.';

  @override
  String get projects_root_unsupported =>
      'No se admite en esta conexión. Se necesita una conexión Desktop Gateway con acceso al Panel para leer o cambiar la carpeta de Proyectos del servidor.';

  @override
  String get projects_root_unavailable =>
      'No se pudo leer la carpeta de Proyectos del servidor. Comprueba la conexión con el Panel y vuelve a intentarlo.';

  @override
  String get adopt_folder_action => 'Añadir una carpeta existente';

  @override
  String adopt_folder_description(String root) {
    return 'Carpetas en $root que aún no están registradas como Proyecto.';
  }

  @override
  String adopt_folder_registered(String name) {
    return 'Ya es un Proyecto: $name';
  }

  @override
  String get adopt_folder_none =>
      'Todas las carpetas de esta ruta ya son Proyectos.';

  @override
  String get adopt_folder_unsupported =>
      'Esta conexión no puede listar las carpetas del servidor. Introduce la ruta absoluta de una carpeta existente.';

  @override
  String adopt_folder_failed(String error) {
    return 'No se pudieron listar las carpetas del servidor: $error';
  }

  @override
  String get adopt_folder_manual_label => 'Ruta de la carpeta existente';

  @override
  String get adopt_folder_name_label => 'Nombre del Proyecto';

  @override
  String get adopt_folder_add => 'Añadir como Proyecto';

  @override
  String adopt_folder_added(String name, String path) {
    return '$name ahora usa $path';
  }

  @override
  String adopt_folder_error(String error) {
    return 'No se pudo añadir la carpeta: $error';
  }

  @override
  String adopt_folder_folderless(String name) {
    return 'Se creó $name, pero la carpeta no se adjuntó. Adjúntala desde Hermes en el servidor.';
  }

  @override
  String get slash_commands => 'Slash commands';

  @override
  String get slash_commands_loading => 'Loading commands…';

  @override
  String get slash_commands_empty => 'No matching commands';

  @override
  String slash_command_info_alias(String alias, String command) {
    return '$alias es un alias de $command';
  }

  @override
  String get slash_command_info_no_description =>
      'No hay descripción disponible.';

  @override
  String get slash_command_info_arguments_options =>
      'Admite una opción de una lista fija.';

  @override
  String get slash_command_info_arguments_text =>
      'Admite texto después del comando.';

  @override
  String get slash_command_info_arguments_mixed =>
      'Admite una opción o texto después del comando.';

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
      'Este comando no está disponible en este servidor.';

  @override
  String get slash_sessions_inline =>
      'Abre la lista de sesiones para elegir un chat. Se conservó tu borrador.';

  @override
  String get composer_snippets => 'Fragmentos de prompts';

  @override
  String get composer_snippets_description =>
      'Elige un prompt inicial para insertarlo en el editor.';

  @override
  String get composer_snippet_review => 'Revisión de código';

  @override
  String get composer_snippet_review_body =>
      'Revisa el cambio actual en busca de regresiones, casos límite olvidados y pruebas que falten.';

  @override
  String get composer_snippet_review_text =>
      'Revisa esto en busca de errores, regresiones y pruebas que falten.';

  @override
  String get composer_snippet_plan => 'Plan de implementación';

  @override
  String get composer_snippet_plan_body =>
      'Esboza un enfoque antes de tocar el código para limitar los cambios al objetivo.';

  @override
  String get composer_snippet_plan_text =>
      'Haz un plan de implementación conciso antes de cambiar el código.';

  @override
  String get composer_snippet_explain => 'Explicar esto';

  @override
  String get composer_snippet_explain_body =>
      'Explica cómo funciona el código seleccionado e indica los archivos clave.';

  @override
  String get composer_snippet_explain_text =>
      'Explica cómo funciona esto e indícame los archivos clave.';

  @override
  String get composer_status => 'Estado';

  @override
  String get composer_status_context => 'Contexto';

  @override
  String get composer_status_cache => 'Acierto de caché';

  @override
  String get composer_status_throughput => 'Tokens de salida/s';

  @override
  String get composer_status_running => 'En ejecución';

  @override
  String get composer_status_session => 'Sesión';

  @override
  String get composer_status_not_reported => 'Sin datos';

  @override
  String get composer_status_empty =>
      'No se proporcionó un desglose del contexto.';

  @override
  String get composer_status_loading => 'Cargando desglose del contexto';

  @override
  String get composer_status_reset => 'Restablecer barra de estado';

  @override
  String get composer_resume_title => 'Retomar un chat';

  @override
  String get composer_resume_search => 'Buscar títulos e ID';

  @override
  String get composer_resume_empty => 'No hay chats que coincidan.';

  @override
  String get composer_resume_unavailable =>
      'Este panel no tiene una lista de chats en la que buscar.';

  @override
  String get composer_failure_retry => 'Reintentar';

  @override
  String composer_failure_retry_at(String time) {
    return 'Reintentar a las $time';
  }

  @override
  String get composer_failure_compress => 'Comprimir';

  @override
  String get composer_failure_switch_model => 'Cambiar de modelo';

  @override
  String composer_failure_switch_to(String model) {
    return 'Cambiar a $model';
  }

  @override
  String get composer_failure_new_chat => 'Nuevo chat';

  @override
  String get composer_failure_edit => 'Editar mensaje';

  @override
  String get composer_failure_details => 'Detalles';

  @override
  String get composer_failure_hide_details => 'Ocultar detalles';

  @override
  String get composer_failure_copy => 'Copiar diagnóstico';

  @override
  String get composer_failure_account =>
      'La otra solución requiere actuar en la cuenta del gateway. No se puede aplicar desde este chat.';

  @override
  String get composer_failure_account_only =>
      'Esto debe solucionarse en la cuenta del gateway. No se puede hacer desde este chat.';

  @override
  String get composer_failure_confirm_compress =>
      '¿Comprimir este chat? El gateway acortará la transcripción.';

  @override
  String composer_failure_confirm_model(String model) {
    return '¿Cambiar este chat a $model?';
  }

  @override
  String get composer_drop_attach => 'Suelta para adjuntar';

  @override
  String get composer_drop_folder_unsupported =>
      'No se pueden adjuntar carpetas. Suelta los archivos en su lugar.';

  @override
  String get composer_drop_reference => 'Suelta para referenciar';

  @override
  String get composer_reference_copy => 'Copiar referencia';

  @override
  String get composer_reference_remove => 'Eliminar referencia';

  @override
  String get composer_btw_usage =>
      'Uso: /btw <question> — se responde desde una instantánea de esta conversación sin interrumpirla.';

  @override
  String get composer_background_usage =>
      'Uso: /background <prompt> — la tarea se ejecuta por separado y el resultado vuelve aquí.';

  @override
  String get composer_handoff_usage =>
      'Uso: /handoff <platform> — transfiere este chat a esa plataforma de mensajería.';

  @override
  String get composer_command_needs_session =>
      'Este comando necesita un chat abierto.';

  @override
  String get composer_retry_not_found =>
      'Este turno no está en el historial guardado, por lo que Reintentar no puede reemplazarlo. No se ha reenviado nada. Edita el mensaje y envíalo para volver a intentarlo.';

  @override
  String get composer_retry_unavailable =>
      'Reintentar no puede reemplazar un turno en esta conexión, por lo que no se ha reenviado nada. Edita el mensaje y envíalo para volver a intentarlo.';

  @override
  String get composer_failure_switch_no_retry =>
      'Cambiar solo cambia el modelo: esta conexión no puede volver a ejecutar el turno fallido. Envíalo de nuevo después de cambiar.';

  @override
  String get composer_command_needs_gateway_session =>
      'Este chat aún no tiene una sesión en el gateway. Envía primero un mensaje y vuelve a ejecutar el comando.';

  @override
  String get composer_side_question =>
      'btw — respondiendo desde una instantánea de la conversación';

  @override
  String composer_side_question_id(String id) {
    return 'btw $id — respondiendo desde una instantánea de la conversación';
  }

  @override
  String get composer_background_started =>
      'Tarea en segundo plano iniciada. Puedes seguir chateando. El resultado aparecerá aquí.';

  @override
  String composer_background_started_id(String id) {
    return 'Tarea en segundo plano $id iniciada. Puedes seguir chateando. El resultado aparecerá aquí.';
  }

  @override
  String composer_handoff_requested(String platform) {
    return 'Transferencia a $platform solicitada.';
  }

  @override
  String composer_handoff_done(String platform) {
    return 'Este chat se ha transferido a $platform.';
  }

  @override
  String get composer_handoff_failed => 'La transferencia ha fallado.';

  @override
  String get composer_handoff_timeout =>
      'La transferencia no terminó. Puede que siga en curso en el gateway.';

  @override
  String get composer_compress_done => 'Este chat se ha comprimido.';

  @override
  String get composer_file_missing =>
      'Ese archivo no está en este dispositivo.';

  @override
  String get composer_attach_busy =>
      'Podrás añadir adjuntos cuando termine esta respuesta.';

  @override
  String get nextgen_toggle => 'Interfaz NextGen';

  @override
  String get nextgen_toggle_subtitle =>
      'Un diseño nuevo con un solo inicio de sesión, chats en directo y búsqueda en la red. Tus gateways y chats se comparten con esta interfaz.';

  @override
  String get nextgen_single_login => 'Conectar con un solo inicio de sesión';

  @override
  String get nextgen_single_login_subtitle =>
      'Añade un gateway solo con la dirección de su panel y un inicio de sesión.';

  @override
  String get ng_allow_this_command => '¿Permitir este comando?';

  @override
  String ng_hermes_wants_to_run_this_with(Object tool) {
    return 'Hermes quiere ejecutarlo con $tool.';
  }

  @override
  String get ng_hermes_wants_to_run_this => 'Hermes quiere ejecutar esto.';

  @override
  String get ng_hermes_has_a_question => 'Hermes tiene una pregunta';

  @override
  String get ng_hermes_has_questions => 'Hermes tiene preguntas';

  @override
  String get ng_password_for_sudo => 'Contraseña de sudo';

  @override
  String get ng_hermes_needs_your_sudo_password_to =>
      'Hermes necesita tu contraseña de sudo para ejecutar este comando.';

  @override
  String get ng_a_secret_value => 'Un valor secreto';

  @override
  String ng_value_for(Object variable) {
    return 'Valor de $variable';
  }

  @override
  String get ng_your_password_manager => 'tu gestor de contraseñas';

  @override
  String ng_unlock(Object name) {
    return 'Desbloquear $name';
  }

  @override
  String ng_hermes_needs_unlocked_to_sign_in(Object name) {
    return 'Hermes necesita que $name esté desbloqueado para iniciar sesión por ti.';
  }

  @override
  String get ng_sign_in_code => 'Código de inicio de sesión';

  @override
  String get ng_enter_the_sign_in_code =>
      'Introduce el código de inicio de sesión.';

  @override
  String ng_enter_the_sign_in_code_for(Object site) {
    return 'Introduce el código de inicio de sesión de $site.';
  }

  @override
  String get ng_save_a_login => '¿Guardar el inicio de sesión?';

  @override
  String ng_save_your_login(Object site) {
    return '¿Guardar tu inicio de sesión de $site?';
  }

  @override
  String ng_couldn_t_load_this_chat(Object error) {
    return 'No se ha podido cargar este chat: $error';
  }

  @override
  String ng_live_updates_are_unavailable(Object error) {
    return 'Las actualizaciones en tiempo real no están disponibles: $error';
  }

  @override
  String ng_preparing(Object name) {
    return 'preparando $name…';
  }

  @override
  String get ng_the_turn_failed => 'La respuesta ha fallado.';

  @override
  String get ng_turn_changed =>
      'esa respuesta ya terminó o empezó una más reciente';

  @override
  String get ng_steer_rejected => 'la respuesta en curso no lo aceptó';

  @override
  String get ng_turn_not_known_yet =>
      'aún no se conoce la respuesta en curso; inténtalo de nuevo en un momento';

  @override
  String ng_couldn_t_stop(Object error) {
    return 'No se ha podido detener: $error';
  }

  @override
  String get ng_server_access => 'Acceso al servidor';

  @override
  String get ng_sign_in => 'Inicio de sesión';

  @override
  String get ng_live_connection => 'Conexión en tiempo real';

  @override
  String get ng_check_that_tailscale_is_on_on =>
      'Comprueba que Tailscale esté activado tanto en este teléfono como en el servidor.';

  @override
  String get ng_check_the_address_and_that_the =>
      'Comprueba la dirección y que el proxy redirija al panel.';

  @override
  String get ng_use_the_same_network_as_the =>
      'Conéctate a la misma red que el servidor e inicia el panel con --host 0.0.0.0 para que otros dispositivos puedan acceder.';

  @override
  String get ng_check_the_address_vpn_or_tailscale =>
      'Comprueba la dirección y la conexión VPN o Tailscale.';

  @override
  String get ng_not_checked_yet => 'Aún no se ha comprobado.';

  @override
  String get ng_checking => 'Comprobando…';

  @override
  String ng_hermes_answers_at(Object version, Object address) {
    return 'Hermes $version responde en $address.';
  }

  @override
  String get ng_something_answered_but_not_a_hermes =>
      'Algo ha respondido, pero no es un panel de Hermes.';

  @override
  String ng_something_answered_http_but_not_a(Object status) {
    return 'Algo ha respondido (HTTP $status), pero no es un panel de Hermes.';
  }

  @override
  String get ng_use_the_dashboard_s_address_and =>
      'Usa la dirección y el puerto del panel (9119 de forma predeterminada), no los del servidor API.';

  @override
  String get ng_cloudflare_access_turned_the_service_token =>
      'Cloudflare Access ha rechazado el token de servicio.';

  @override
  String get ng_cloudflare_access_is_in_front_of =>
      'Cloudflare Access está delante de esta dirección.';

  @override
  String get ng_check_the_service_token_and_its =>
      'Comprueba el token de servicio y su política Service Auth.';

  @override
  String get ng_add_a_cloudflare_access_service_token =>
      'Añade un token de servicio de Cloudflare Access para esta dirección.';

  @override
  String get ng_the_server_asks_for_a_client =>
      'El servidor solicita un certificado de cliente.';

  @override
  String get ng_pick_the_client_certificate_for_this =>
      'Selecciona el certificado de cliente para esta pasarela y vuelve a probar.';

  @override
  String get ng_needs_server_access_first =>
      'Primero necesitas acceder al servidor.';

  @override
  String get ng_needs_a_sign_in_first => 'Primero tienes que iniciar sesión.';

  @override
  String ng_signed_in_as(Object name) {
    return 'Has iniciado sesión como $name.';
  }

  @override
  String get ng_this_dashboard_doesn_t_need_a =>
      'Este panel no requiere iniciar sesión.';

  @override
  String get ng_the_saved_sign_in_has_expired =>
      'La sesión guardada ha caducado.';

  @override
  String get ng_sign_in_again => 'Vuelve a iniciar sesión.';

  @override
  String get ng_too_many_sign_in_attempts =>
      'Demasiados intentos de inicio de sesión.';

  @override
  String get ng_wait_a_minute_then_check_again =>
      'Espera un minuto y vuelve a comprobarlo.';

  @override
  String ng_the_gateway_answered(Object message) {
    return 'La pasarela ha respondido: $message.';
  }

  @override
  String get ng_sign_in_again_or_update_hermes =>
      'Vuelve a iniciar sesión o actualiza Hermes.';

  @override
  String ng_couldn_t_check_the_sign_in(Object error) {
    return 'No se ha podido comprobar el inicio de sesión: $error';
  }

  @override
  String ng_the_gateway_wouldn_t_issue_a(Object message) {
    return 'La pasarela no ha emitido un ticket de chat ($message).';
  }

  @override
  String get ng_the_chat_connection_opened_and_the =>
      'Se ha establecido la conexión del chat y la pasarela indica que está lista.';

  @override
  String get ng_the_gateway_never_said_it_was =>
      'La pasarela nunca indicó que estuviera lista.';

  @override
  String get ng_check_that_the_agent_is_running =>
      'Comprueba que el agente esté en ejecución en el servidor.';

  @override
  String get ng_the_gateway_refused_the_chat_connection =>
      'La pasarela ha rechazado la conexión del chat (HTTP 403).';

  @override
  String get ng_this_dashboard_has_no_chat_endpoint =>
      'Este panel no tiene un endpoint de chat (/api/ws).';

  @override
  String ng_the_chat_connection_failed(Object detail) {
    return 'La conexión del chat ha fallado: $detail';
  }

  @override
  String get ng_use_the_exact_address_the_dashboard =>
      'Usa la dirección exacta configurada para el panel.';

  @override
  String get ng_update_hermes => 'Actualiza Hermes.';

  @override
  String get ng_make_sure_the_proxy_allows_websocket =>
      'Asegúrate de que el proxy permita las actualizaciones de WebSocket en /api/ws.';

  @override
  String get ng_offline => 'Sin conexión';

  @override
  String get ng_connecting => 'Conectando…';

  @override
  String get ng_connected => 'Conectado';

  @override
  String get ng_reconnecting => 'Reconectando…';

  @override
  String get ng_signed_out => 'Sesión cerrada';

  @override
  String get ng_connection_failed => 'Error de conexión';

  @override
  String get ng_rate_limited_by_gateway =>
      'La pasarela ha limitado las solicitudes';

  @override
  String ng_couldn_t_open_the_chat_connection(Object message) {
    return 'No se pudo abrir la conexión del chat: $message';
  }

  @override
  String get ng_the_gateway_returned_no_websocket_ticket =>
      'La pasarela no ha devuelto ningún ticket de WebSocket.';

  @override
  String get ng_connection_lost => 'Conexión perdida';

  @override
  String get ng_this_dashboard_has_no_chat_endpoint_2 =>
      'Este panel no tiene un endpoint de chat (/api/ws). Actualiza Hermes.';

  @override
  String get ng_the_gateway_refused_the_chat_connection_2 =>
      'La pasarela ha rechazado la conexión del chat. Comprueba que la dirección coincida con el host configurado en el panel y que el chat integrado esté activado.';

  @override
  String ng_the_gateway_refused(Object method) {
    return 'La pasarela ha rechazado $method.';
  }

  @override
  String ng_couldn_t_read_your_saved_gateways(Object error) {
    return 'No se pudieron leer las pasarelas guardadas: $error';
  }

  @override
  String get ng_applies_to_new_chats => 'Se aplica a los chats nuevos';

  @override
  String ng_couldn_t_change(Object label, Object error) {
    return 'No se pudo cambiar $label: $error';
  }

  @override
  String get ng_capabilities => 'Capacidades';

  @override
  String get ng_skills => 'Habilidades';

  @override
  String get ng_toolsets => 'Conjuntos de herramientas';

  @override
  String get ng_search => 'Buscar';

  @override
  String get ng_couldn_t_load => 'No se pudo cargar';

  @override
  String get ng_try_again => 'Reintentar';

  @override
  String get ng_no_skills => 'No hay habilidades';

  @override
  String get ng_no_toolsets => 'No hay conjuntos de herramientas';

  @override
  String get ng_no_mcp_servers => 'No hay servidores MCP';

  @override
  String get ng_that_file_is_too_large_to =>
      'El archivo es demasiado grande para ser un certificado.';

  @override
  String ng_the_certificate_couldn_t_be_imported(Object error) {
    return 'No se pudo importar el certificado: $error';
  }

  @override
  String get ng_now_pick_its_private_key =>
      'Ahora selecciona su clave privada.';

  @override
  String get ng_now_pick_its_certificate => 'Ahora selecciona su certificado.';

  @override
  String get ng_that_file_isn_t_a_certificate =>
      'El archivo no es un certificado ni una clave privada.';

  @override
  String get ng_if_a_proxy_in_front_of =>
      'Si un proxy situado delante de esta dirección solicita un certificado de cliente, selecciónalo aquí para que la prueba, el inicio de sesión y el chat lo presenten.';

  @override
  String get ng_client_certificates_are_only_used_with =>
      'Los certificados de cliente solo se usan con direcciones https://.';

  @override
  String get ng_remove => 'Eliminar';

  @override
  String get ng_certificate_password => 'Contraseña del certificado';

  @override
  String get ng_importing => 'Importando…';

  @override
  String get ng_pick_certificate => 'Seleccionar certificado';

  @override
  String get ng_pick_a_different_certificate => 'Seleccionar otro certificado';

  @override
  String get ng_accepts_p12_pfx_or_pem_certificate =>
      'Admite archivos .p12/.pfx o archivos PEM de certificado y clave. La clave se guarda en el almacenamiento privado de esta aplicación.';

  @override
  String get ng_photos => 'Fotos';

  @override
  String get ng_camera => 'Cámara';

  @override
  String get ng_files => 'Archivos';

  @override
  String ng_you_can_attach_up_to_files(Object count) {
    return 'Puedes adjuntar hasta $count archivos.';
  }

  @override
  String ng_couldn_t_read(Object name) {
    return 'No se pudo leer $name.';
  }

  @override
  String ng_couldn_t_prepare_that_file(Object error) {
    return 'No se pudo preparar el archivo: $error';
  }

  @override
  String get ng_hermes_is_still_working => 'Hermes sigue trabajando';

  @override
  String get ng_steer => 'Guiar';

  @override
  String get ng_adds_this_to_the_running_turn =>
      'Añade esto al turno en curso en el siguiente paso';

  @override
  String get ng_queue => 'Encolar';

  @override
  String get ng_sends_it_when_the_turn_finishes =>
      'Lo envía cuando termina el turno';

  @override
  String get ng_stop_and_send => 'Detener y enviar';

  @override
  String get ng_stops_the_turn_then_sends_this =>
      'Detiene el turno y luego envía esto';

  @override
  String ng_dictation_stopped(Object message) {
    return 'Dictado detenido: $message';
  }

  @override
  String get ng_speech_recognition_isn_t_available =>
      'El reconocimiento de voz no está disponible.';

  @override
  String get ng_working => 'En curso';

  @override
  String get ng_ready => 'Listo';

  @override
  String get ng_chats => 'Chats';

  @override
  String get ng_new_chat => 'Nuevo chat';

  @override
  String get ng_usage => 'Uso';

  @override
  String get ng_rename_chat => 'Cambiar nombre del chat';

  @override
  String ng_couldn_t_rename(Object error) {
    return 'No se pudo cambiar el nombre: $error';
  }

  @override
  String get ng_this_chat => 'Este chat';

  @override
  String get ng_input_tokens => 'Tokens de entrada';

  @override
  String get ng_output_tokens => 'Tokens de salida';

  @override
  String get ng_reasoning_tokens => 'Tokens de razonamiento';

  @override
  String get ng_cache_reads => 'Lecturas de caché';

  @override
  String get ng_api_calls => 'Llamadas a la API';

  @override
  String get ng_cost => 'Coste';

  @override
  String get ng_context => 'Contexto';

  @override
  String get ng_your_sign_in_expired => 'Tu sesión ha caducado.';

  @override
  String get ng_sign_in_2 => 'Iniciar sesión';

  @override
  String get ng_retry => 'Reintentar';

  @override
  String get ng_project_home => 'Inicio';

  @override
  String get ng_choose_project => 'Elegir un proyecto';

  @override
  String ng_project_cwd_fallback(String path) {
    return 'La carpeta del proyecto no estaba disponible, así que este chat se ejecuta en $path.';
  }

  @override
  String get ng_project_create_uncertain =>
      'Es posible que la pasarela haya creado este chat, pero no lo confirmó. Revisa los chats antes de iniciar otro; esta solicitud no se reintentará automáticamente.';

  @override
  String get ng_what_should_we_work_on => '¿En qué trabajamos?';

  @override
  String get ng_ask_hermes_anything_it_can_run =>
      'Pregúntale lo que quieras a Hermes. Puede usar herramientas, navegar y trabajar con tus archivos en el servidor.';

  @override
  String ng_working_2(Object frame) {
    return 'En curso · $frame';
  }

  @override
  String get ng_default_model => 'Modelo predeterminado';

  @override
  String get ng_listening => 'Escuchando…';

  @override
  String get ng_steer_or_queue_a_message =>
      'Envía una indicación o pon un mensaje en cola';

  @override
  String get ng_message_hermes => 'Escribe a Hermes';

  @override
  String get ng_attach => 'Adjuntar';

  @override
  String get ng_stop_dictation => 'Detener dictado';

  @override
  String get ng_dictate => 'Dictar';

  @override
  String get ng_stop => 'Detener';

  @override
  String get ng_send => 'Enviar';

  @override
  String ng_slash_command_alias(String alias, String command) {
    return '$alias es un alias de $command';
  }

  @override
  String get ng_slash_command_no_description =>
      'No hay descripción disponible.';

  @override
  String get ng_slash_command_arguments_options =>
      'Admite una opción de una lista fija.';

  @override
  String get ng_slash_command_arguments_text =>
      'Admite texto después del comando.';

  @override
  String get ng_slash_command_arguments_mixed =>
      'Admite una opción o texto después del comando.';

  @override
  String get ng_slash_command_sent_as_message =>
      'NextGen envía esto a Hermes como un mensaje normal; el comando en sí no se ejecuta.';

  @override
  String get ng_slash_command_output => 'Salida del comando';

  @override
  String get ng_slash_command_running => 'Ejecutando el comando…';

  @override
  String get ng_slash_command_done => 'Hecho.';

  @override
  String ng_slash_command_failed(Object error) {
    return 'No se ha podido ejecutar el comando: $error';
  }

  @override
  String get ng_slash_command_refused =>
      'Hermes no puede ejecutar este comando aquí.';

  @override
  String get ng_slash_command_delivery_unknown =>
      'El comando se envió, pero no llegó ninguna respuesta. Puede que siga ejecutándose en el gateway, así que no se ha vuelto a enviar y se ha conservado tu borrador.';

  @override
  String get ng_slash_command_nothing_running => 'No hay nada en ejecución.';

  @override
  String get ng_steered => 'Indicación enviada';

  @override
  String get ng_copied => 'Copiado';

  @override
  String ng_not_sent(Object reason) {
    return 'No se ha enviado: $reason';
  }

  @override
  String get ng_thinking => 'Pensando…';

  @override
  String get ng_thought => 'Razonamiento';

  @override
  String ng_used(Object name) {
    return 'Usó $name';
  }

  @override
  String ng_used_tools(Object count) {
    return 'Usó $count herramientas';
  }

  @override
  String get ng_copy => 'Copiar';

  @override
  String get ng_read_aloud => 'Leer en voz alta';

  @override
  String get ng_the_gateway_connection_dropped_try_again =>
      'Se ha perdido la conexión con la pasarela. Inténtalo de nuevo.';

  @override
  String get ng_allow_once => 'Permitir una vez';

  @override
  String get ng_allow_until_sandbox_off => 'Hasta que se desactive el sandbox';

  @override
  String get ng_folder_access => 'Acceso a carpetas';

  @override
  String get ng_folder_access_unspecified =>
      'El gateway no indicó si es de solo lectura o de lectura y escritura.';

  @override
  String get ng_folder_read_only => 'Solo lectura';

  @override
  String get ng_folder_read_write => 'Lectura y escritura';

  @override
  String get ng_website_access => 'Acceso a sitios web';

  @override
  String get ng_allow_for_this_chat => 'Permitir en este chat';

  @override
  String get ng_always_allow => 'Permitir siempre';

  @override
  String get ng_deny => 'Denegar';

  @override
  String get ng_your_answer => 'Tu respuesta';

  @override
  String get ng_or_type_an_answer => 'O escribe una respuesta';

  @override
  String get ng_skip => 'Omitir';

  @override
  String get ng_answer => 'Responder';

  @override
  String get ng_cancel => 'Cancelar';

  @override
  String get ng_username_or_email => 'Nombre de usuario o correo electrónico';

  @override
  String get ng_password => 'Contraseña';

  @override
  String get ng_not_now => 'Ahora no';

  @override
  String get ng_save => 'Guardar';

  @override
  String get ng_enter_both_the_client_id_and =>
      'Introduce el ID y el secreto del cliente, o ninguno de los dos.';

  @override
  String get ng_enter_your_username_and_password =>
      'Introduce tu nombre de usuario y contraseña.';

  @override
  String ng_couldn_t_save_the_sign_in(Object error) {
    return 'No se ha podido guardar el inicio de sesión: $error';
  }

  @override
  String get ng_wrong_username_or_password =>
      'El nombre de usuario o la contraseña no son correctos.';

  @override
  String get ng_too_many_attempts_wait_a_moment =>
      'Demasiados intentos. Espera un momento y vuelve a intentarlo.';

  @override
  String get ng_welcome_to_hermes => 'Te damos la bienvenida a Ares';

  @override
  String get ng_add_a_gateway => 'Añadir una pasarela';

  @override
  String get ng_connect_to_your_hermes_agent_dashboard =>
      'Conéctate al panel de Hermes Agent. Una dirección y un inicio de sesión te dan acceso a tus chats, herramientas y ajustes. No se envía nada hasta que inicies sesión.';

  @override
  String get ng_connect_to_another_hermes_agent_dashboard =>
      'Conéctate a otro panel de Hermes Agent. Seguirás teniendo la sesión iniciada en los que ya guardaste.';

  @override
  String get ng_dashboard_address => 'Dirección del panel';

  @override
  String get ng_testing => 'Comprobando…';

  @override
  String get ng_test => 'Comprobar';

  @override
  String get ng_where_your_hermes_dashboard_runs_lan =>
      'Dónde se ejecuta tu panel de Hermes: en tu red local, Tailscale o HTTPS.';

  @override
  String get ng_find_on_my_network => 'Buscar en mi red';

  @override
  String get ng_which_address_do_i_use => '¿Qué dirección debo usar?';

  @override
  String get ng_behind_cloudflare_access =>
      '¿Está protegido por Cloudflare Access?';

  @override
  String get ng_need_a_client_certificate =>
      '¿Necesitas un certificado de cliente?';

  @override
  String get ng_this_address_isn_t_private_and =>
      'Esta dirección no es privada y no usa https://, por lo que tu contraseña y tus chats viajarían por Internet sin cifrar. Usa https://, Tailscale o tu propia red.';

  @override
  String get ng_continue_to_sign_in => 'Continuar para iniciar sesión';

  @override
  String get ng_use_the_classic_interface_instead => 'Usar la interfaz clásica';

  @override
  String get ng_if_cloudflare_access_protects_this_address =>
      'Si Cloudflare Access protege esta dirección, crea un token de servicio en Cloudflare Zero Trust (Access, Service credentials) y añade una política Service Auth a la aplicación de Access.';

  @override
  String get ng_a_service_token_is_saved_for =>
      'Hay un token de servicio guardado para esta dirección';

  @override
  String get ng_forget => 'Olvidar';

  @override
  String get ng_client_id => 'ID de cliente';

  @override
  String get ng_client_secret => 'Secreto de cliente';

  @override
  String get ng_stored_encrypted_on_this_phone_and =>
      'Se guarda cifrado en este teléfono y solo se envía a esta dirección.';

  @override
  String get ng_hermes_is_reachable => 'Hermes está disponible';

  @override
  String ng_hermes_is_reachable_2(Object version) {
    return 'Hermes $version está disponible';
  }

  @override
  String get ng_sign_in_is_tested_next_then =>
      'A continuación se prueba el inicio de sesión y después el chat';

  @override
  String get ng_agent_gateway => 'Pasarela del agente';

  @override
  String get ng_running => 'En ejecución';

  @override
  String get ng_stopped => 'Detenido';

  @override
  String get ng_username_password => 'Usuario y contraseña';

  @override
  String get ng_browser => 'Navegador';

  @override
  String get ng_in_the_browser_sso => 'En el navegador (SSO)';

  @override
  String get ng_profiles => 'Perfiles';

  @override
  String get ng_this_dashboard_offers_neither_a_username =>
      'Este panel no ofrece inicio de sesión con usuario y contraseña ni en el navegador. Actualiza Hermes o configura el proveedor de usuario y contraseña en el servidor.';

  @override
  String get ng_the_auth_gate_is_off_on =>
      'El control de acceso está desactivado en este panel. Cualquiera que pueda acceder a él puede usar tu agente.';

  @override
  String get ng_couldn_t_reach_the_dashboard => 'No se pudo acceder al panel';

  @override
  String ng_check_the_address_and_port_9119(Object reason) {
    return '$reason\n\nComprueba la dirección y el puerto (9119 de forma predeterminada). Si el panel aún no está en ejecución, ejecuta esto en el servidor:\nhermes dashboard --host 0.0.0.0';
  }

  @override
  String get ng_that_isn_t_a_hermes_dashboard => 'Eso no es un panel de Hermes';

  @override
  String get ng_something_answered_but_not_a_hermes_2 =>
      'Hubo respuesta, pero no era un panel de Hermes. Usa la dirección del panel, no la del servidor de API (puerto 8642).';

  @override
  String ng_something_answered_http_but_not_a_2(Object status) {
    return 'Hubo respuesta (HTTP $status), pero no era un panel de Hermes. Usa la dirección del panel, no la del servidor de API (puerto 8642).';
  }

  @override
  String get ng_cloudflare_access_stopped_the_request =>
      'Cloudflare Access bloqueó la solicitud';

  @override
  String ng_cloudflare_access_turned_down_the_service(Object status) {
    return 'Cloudflare Access rechazó el token de servicio (HTTP $status). Comprueba el Client ID, el Secret y la política Service Auth.';
  }

  @override
  String get ng_add_a_cloudflare_access_service_token_2 =>
      'Añade un token de servicio de Cloudflare Access abajo y vuelve a probar.';

  @override
  String get ng_a_client_certificate_is_needed =>
      'Se necesita un certificado de cliente';

  @override
  String get ng_this_server_asks_for_a_client =>
      'Este servidor solicita un certificado de cliente antes de comunicarse. Selecciona abajo el certificado que te proporcionó y vuelve a probar.';

  @override
  String get ng_this_dashboard_doesn_t_ask_for =>
      'Este panel no requiere iniciar sesión.';

  @override
  String ng_use_the_dashboard_username_and_password(Object address) {
    return 'Usa el usuario y la contraseña del panel configurados en $address, o inicia sesión en el navegador.';
  }

  @override
  String ng_use_the_dashboard_username_and_password_2(Object address) {
    return 'Usa el usuario y la contraseña del panel configurados en $address.';
  }

  @override
  String ng_sign_in_to_in_your_browser(Object address) {
    return 'Inicia sesión en $address desde el navegador con la cuenta que usa el panel.';
  }

  @override
  String ng_gateway(Object address) {
    return 'Pasarela $address';
  }

  @override
  String get ng_profile => 'Perfil';

  @override
  String get ng_server_default => 'Valor predeterminado del servidor';

  @override
  String get ng_continue => 'Continuar';

  @override
  String get ng_username => 'Usuario';

  @override
  String get ng_signing_in => 'Iniciando sesión…';

  @override
  String get ng_waiting_for_the_browser => 'Esperando al navegador…';

  @override
  String get ng_sign_in_with_browser => 'Iniciar sesión con el navegador';

  @override
  String get ng_finish_signing_in_on_the_page =>
      'Termina de iniciar sesión en la página que se ha abierto. Hermes volverá automáticamente cuando hayas terminado.';

  @override
  String get ng_use_a_different_gateway => 'Usar otra pasarela';

  @override
  String get ng_same_wi_fi_or_local_network => 'La misma red Wi-Fi o red local';

  @override
  String get ng_use_the_server_s_local_address =>
      'Usa la dirección local y el puerto del servidor, como 192.168.1.20:9119. Inicia el panel con --host 0.0.0.0 para que otros dispositivos puedan acceder.';

  @override
  String get ng_tailscale => 'Tailscale';

  @override
  String get ng_turn_on_tailscale_on_this_phone =>
      'Activa Tailscale en este teléfono y usa la dirección de Tailscale del servidor, como 100.64.0.1:9119 o su nombre .ts.net. También funciona fuera de casa.';

  @override
  String get ng_use_your_https_address_when_the =>
      'Usa tu dirección https:// si el panel está detrás de un proxy con certificado. El proxy también debe permitir las actualizaciones de WebSocket en /api/ws.';

  @override
  String get ng_start_the_dashboard_on_the_server =>
      'Inicia el panel en el servidor:';

  @override
  String get ng_enter_a_port_from_1_to => 'Introduce un puerto del 1 al 65535.';

  @override
  String get ng_looks_for_hermes_dashboards_on_port =>
      'Busca paneles de Hermes en el puerto 9119 de esta red Wi-Fi y comprueba los equipos que ya has guardado.';

  @override
  String ng_looks_for_hermes_dashboards_on_ports(Object port) {
    return 'Busca paneles de Hermes en los puertos 9119 y $port de esta red Wi-Fi y comprueba los equipos que ya has guardado.';
  }

  @override
  String get ng_other_port_optional => 'Otro puerto (opcional)';

  @override
  String get ng_no_dashboards_answered_start_one_with =>
      'Ningún panel respondió. Inicia uno con hermes dashboard --host 0.0.0.0 o introduce su dirección.';

  @override
  String get ng_using_tailscale_or_a_vpn_those =>
      '¿Usas Tailscale o una VPN? No se pueden buscar esas redes. Introduce la dirección 100.x del equipo o su nombre .ts.net.';

  @override
  String get ng_search_again => 'Buscar de nuevo';

  @override
  String get ng_insights => 'Estadísticas';

  @override
  String get ng_couldn_t_load_insights =>
      'No se pudieron cargar las estadísticas';

  @override
  String get ng_sessions => 'Sesiones';

  @override
  String get ng_tokens => 'Tokens';

  @override
  String get ng_est_cost => 'Coste estimado';

  @override
  String get ng_daily_tokens => 'Tokens diarios';

  @override
  String get ng_models => 'Modelos';

  @override
  String get ng_tools => 'Herramientas';

  @override
  String get ng_hermes_is_waiting_for_you => 'Hermes te está esperando.';

  @override
  String get ng_hermes_replied => 'Hermes ha respondido';

  @override
  String get ng_the_turn_finished => 'El turno ha terminado.';

  @override
  String get ng_off => 'Desactivado';

  @override
  String get ng_minimal => 'Mínimo';

  @override
  String get ng_low => 'Bajo';

  @override
  String get ng_medium => 'Medio';

  @override
  String get ng_high => 'Alto';

  @override
  String get ng_extra_high => 'Muy alto';

  @override
  String get ng_max => 'Máximo';

  @override
  String get ng_ultra => 'Ultra';

  @override
  String get ng_default => 'Predeterminado';

  @override
  String ng_couldn_t_switch_model(Object error) {
    return 'No se pudo cambiar de modelo: $error';
  }

  @override
  String get ng_model => 'Modelo';

  @override
  String get ng_thinking_2 => 'Pensando';

  @override
  String get ng_search_models => 'Buscar modelos';

  @override
  String get ng_no_models_match => 'Ningún modelo coincide con estos filtros.';

  @override
  String get privacy_policy => 'Política de privacidad';

  @override
  String get report_ai_output => 'Informar sobre una respuesta de IA';

  @override
  String ng_couldn_t_load_models(Object error) {
    return 'No se pudieron cargar los modelos: $error';
  }

  @override
  String get ng_no_providers_are_set_up_on =>
      'Aún no hay proveedores configurados en esta pasarela.';

  @override
  String get ng_starred => 'Destacados';

  @override
  String get ng_recent => 'Recientes';

  @override
  String get ng_more => 'Más';

  @override
  String get ng_archived_chats => 'Chats archivados';

  @override
  String get ng_projects => 'Proyectos';

  @override
  String get ng_chats_grouped_by_project_and_workspace =>
      'Chats agrupados por proyecto y espacio de trabajo';

  @override
  String get ng_agent => 'Agente';

  @override
  String get ng_memory => 'Memoria';

  @override
  String get ng_what_hermes_remembers_about_you =>
      'Lo que Hermes recuerda sobre ti';

  @override
  String get ng_skills_library => 'Biblioteca de habilidades';

  @override
  String get ng_browse_and_read_installed_skills =>
      'Explora y lee las habilidades instaladas';

  @override
  String get ng_cron_editor => 'Editor de cron';

  @override
  String get ng_edit_schedules_prompts_and_delivery =>
      'Edita horarios, instrucciones y entregas';

  @override
  String get ng_config_file => 'Archivo de configuración';

  @override
  String get ng_edit_config_yaml_on_the_gateway =>
      'Edita config.yaml en la pasarela';

  @override
  String get ng_models_and_providers => 'Modelos y proveedores';

  @override
  String get ng_model_management => 'Gestión de modelos';

  @override
  String get ng_default_fallback_and_auxiliary_models =>
      'Modelos predeterminados, de reserva y auxiliares';

  @override
  String get ng_provider_sign_in => 'Inicio de sesión del proveedor';

  @override
  String get ng_connect_provider_accounts_with_oauth =>
      'Conecta cuentas de proveedores con OAuth';

  @override
  String get ng_nous_portal => 'Nous Portal';

  @override
  String get ng_subscription_credits_and_usage => 'Suscripción, créditos y uso';

  @override
  String get ng_interface => 'Interfaz';

  @override
  String get ng_switch_to_the_classic_interface =>
      'Cambiar a la interfaz clásica';

  @override
  String get ng_turns_nextgen_off_you_can_turn =>
      'Desactiva NextGen. Puedes volver a activarlo en Ajustes.';

  @override
  String get ng_restored => 'Restaurado';

  @override
  String get ng_archived => 'Archivado';

  @override
  String get ng_couldn_t_load_archived_chats =>
      'No se pudieron cargar los chats archivados';

  @override
  String get ng_nothing_archived => 'No hay nada archivado';

  @override
  String get ng_restore => 'Restaurar';

  @override
  String get ng_saved_new_chats_use_it =>
      'Guardado. Los chats nuevos lo usarán.';

  @override
  String ng_couldn_t_save(Object error) {
    return 'No se pudo guardar: $error';
  }

  @override
  String get ng_saving => 'Guardando…';

  @override
  String ng_today(Object time) {
    return 'Hoy $time';
  }

  @override
  String get ng_mon => 'lun';

  @override
  String get ng_tue => 'mar';

  @override
  String get ng_wed => 'mié';

  @override
  String get ng_thu => 'jue';

  @override
  String get ng_fri => 'vie';

  @override
  String get ng_sat => 'sáb';

  @override
  String get ng_sun => 'dom';

  @override
  String get ng_scheduled => 'Programado';

  @override
  String get ng_new_job => 'Nueva tarea';

  @override
  String get ng_couldn_t_load_scheduled_jobs =>
      'No se pudieron cargar las tareas programadas';

  @override
  String get ng_nothing_scheduled => 'No hay nada programado';

  @override
  String get ng_ask_hermes_to_do_something_on =>
      'Pide a Hermes que haga algo según un horario o añade una tarea aquí.';

  @override
  String get ng_active => 'Activa';

  @override
  String get ng_paused => 'En pausa';

  @override
  String ng_next(Object when) {
    return 'Siguiente $when';
  }

  @override
  String ng_last(Object when) {
    return 'Anterior $when';
  }

  @override
  String ng_last_2(Object when, Object result) {
    return 'Anterior $when · $result';
  }

  @override
  String ng_job(Object id) {
    return 'Tarea $id';
  }

  @override
  String get ng_delete => 'Eliminar';

  @override
  String get ng_delete_this_job => '¿Eliminar esta tarea?';

  @override
  String get ng_it_stops_running_past_runs_stay =>
      'Dejará de ejecutarse. Las ejecuciones anteriores seguirán en tus chats.';

  @override
  String ng_next_run(Object when) {
    return 'Próxima ejecución $when';
  }

  @override
  String ng_delivers_to(Object target) {
    return 'Se envía a $target';
  }

  @override
  String get ng_run_now => 'Ejecutar ahora';

  @override
  String get ng_started => 'Iniciado';

  @override
  String get ng_pause => 'Pausar';

  @override
  String get ng_resume => 'Reanudar';

  @override
  String get ng_resumed => 'Reanudado';

  @override
  String get ng_prompt => 'Instrucción';

  @override
  String get ng_runs => 'Ejecuciones';

  @override
  String get ng_no_runs_yet => 'Aún no hay ejecuciones.';

  @override
  String get ng_enter_a_schedule_and_a_prompt =>
      'Introduce una programación y una instrucción.';

  @override
  String get ng_name_optional => 'Nombre (opcional)';

  @override
  String get ng_schedule => 'Programación';

  @override
  String get ng_every_1h_0_9_or_30m => 'every 1h, 0 9 * * *, or 30m';

  @override
  String get ng_create => 'Crear';

  @override
  String get ng_unpin => 'Desfijar';

  @override
  String get ng_pin => 'Fijar';

  @override
  String get ng_rename => 'Cambiar nombre';

  @override
  String get ng_archive => 'Archivar';

  @override
  String get ng_delete_this_chat => '¿Eliminar este chat?';

  @override
  String get ng_it_is_removed_from_the_gateway =>
      'Se eliminará de la pasarela en todos los dispositivos.';

  @override
  String get ng_search_chats => 'Buscar chats';

  @override
  String get ng_pinned => 'Fijados';

  @override
  String get ng_no_chats_match => 'Ningún chat coincide.';

  @override
  String get ng_no_chats_yet => 'Aún no hay chats.';

  @override
  String get ng_nothing_is_running => 'No hay nada en ejecución.';

  @override
  String get ng_nothing_is_waiting_on_you => 'No tienes nada pendiente.';

  @override
  String get ng_settings => 'Configuración';

  @override
  String get ng_all => 'Todo';

  @override
  String ng_needs_you(Object count) {
    return 'Requiere tu atención · $count';
  }

  @override
  String get ng_needs_you_2 => 'Requiere tu atención';

  @override
  String get ng_gateways => 'Pasarelas';

  @override
  String ng_classic_connection(Object address) {
    return '$address · conexión clásica';
  }

  @override
  String get ng_gateway_2 => 'Pasarela';

  @override
  String get ng_signed_in => 'Sesión iniciada';

  @override
  String get ng_classic_connection_2 => 'Conexión clásica';

  @override
  String get ng_in_the_browser => 'En el navegador';

  @override
  String ng_in_the_browser_as(Object name) {
    return 'En el navegador como $name';
  }

  @override
  String get ng_not_required => 'No es necesario';

  @override
  String get ng_test_connection => 'Probar conexión';

  @override
  String get ng_sign_in_again_2 => 'Volver a iniciar sesión';

  @override
  String get ng_sign_out => 'Cerrar sesión';

  @override
  String get ng_saved_gateways => 'Pasarelas guardadas';

  @override
  String get ng_in_use => 'En uso';

  @override
  String get ng_appearance => 'Apariencia';

  @override
  String get ng_theme => 'Tema';

  @override
  String get ng_system => 'Sistema';

  @override
  String get ng_light => 'Claro';

  @override
  String get ng_dark => 'Oscuro';

  @override
  String get ng_accent => 'Color de acento';

  @override
  String get ng_pure_black => 'Negro puro';

  @override
  String get ng_dark_theme_uses_true_black_oled =>
      'El tema oscuro usa negro puro (OLED)';

  @override
  String get ng_glow => 'Resplandor';

  @override
  String get ng_soft_accent_light_behind_each_screen =>
      'Luz de acento tenue detrás de cada pantalla';

  @override
  String get ng_the_new_interface_turn_off_to =>
      'La nueva interfaz. Desactívala para volver a la clásica; tus pasarelas y chats se comparten.';

  @override
  String get ng_more_settings => 'Más ajustes';

  @override
  String get ng_voice_notifications_language_backups_and_the =>
      'Voz, notificaciones, idioma, copias de seguridad y configuración de la pasarela';

  @override
  String get ng_licences => 'Licencias';

  @override
  String ng_sign_out_of(Object name) {
    return '¿Cerrar sesión en $name?';
  }

  @override
  String get ng_this_gateway_and_its_saved_sign =>
      'Esta pasarela y sus credenciales guardadas se eliminarán de este teléfono, en ambas interfaces. Tus chats seguirán en la pasarela.';

  @override
  String get ng_password_or_browser => 'Contraseña o navegador';

  @override
  String get ng_unsupported => 'No compatible';

  @override
  String get ng_background_task_finished => 'Tarea en segundo plano finalizada';

  @override
  String get ng_background_process_finished =>
      'Proceso en segundo plano finalizado';

  @override
  String get ng_system_message => 'Mensaje del sistema';

  @override
  String get ng_summary => 'Resumen';

  @override
  String get classic_interface_only => 'Solo para la interfaz clásica';

  @override
  String get classic_only_settings_hint =>
      'Las secciones marcadas como «Solo para la interfaz clásica» cambian el aspecto y el chat clásicos, no NextGen. NextGen tiene sus propias opciones de apariencia en Ajustes.';

  @override
  String get attachment_preview_too_large =>
      'Demasiado grande para previsualizar aquí. Guardar o Compartir lo descarga en tu teléfono (hasta 1 GB).';

  @override
  String get attachment_over_phone_limit =>
      'Este archivo supera 1 GB y excede el límite de descarga. Abre el panel para descargarlo.';

  @override
  String attachment_downloading_percent(int percent) {
    return 'Descargando… $percent%';
  }

  @override
  String attachment_downloading_mb(int megabytes) {
    return 'Descargando… $megabytes MB';
  }

  @override
  String ng_attachment_too_large_for_gateway(String name) {
    return '$name supera los 12 MB, el tamaño máximo que admite esta pasarela. Actualiza Hermes para enviar archivos de hasta 100 MB.';
  }

  @override
  String ng_couldn_t_upload(String name) {
    return 'No se pudo subir $name.';
  }

  @override
  String ng_uploading_percent(int percent) {
    return 'Subiendo… $percent%';
  }

  @override
  String get ng_show_tasks => 'Mostrar tareas';

  @override
  String get ng_hide_tasks => 'Ocultar tareas';

  @override
  String get ng_goal => 'Objetivo';

  @override
  String get ng_loop => 'Ciclo';

  @override
  String get ng_heartbeat => 'Pulso';

  @override
  String get ng_goal_working => 'En curso';

  @override
  String get ng_goal_waiting => 'En espera';

  @override
  String get ng_goal_blocked => 'Bloqueado';

  @override
  String get ng_goal_done => 'Completado';

  @override
  String ng_goal_turns_of(int used, int max) {
    return '$used de $max turnos';
  }

  @override
  String ng_goal_turn(int used) {
    return 'turno $used';
  }

  @override
  String get ng_loop_held => 'En espera del objetivo';

  @override
  String get ng_loop_finished => 'Finalizado';

  @override
  String get ng_loop_running => 'En ejecución';

  @override
  String ng_loop_runs_of(int fired, int times) {
    return '$fired de $times ejecuciones';
  }

  @override
  String ng_loop_runs(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ejecuciones',
      one: '1 ejecución',
    );
    return '$_temp0';
  }

  @override
  String ng_loop_next(String time) {
    return 'siguiente $time';
  }

  @override
  String get ng_loop_due_now => 'toca ahora';

  @override
  String ng_every_seconds(int seconds) {
    return 'cada $seconds s';
  }

  @override
  String ng_every_minutes(int minutes) {
    return 'cada $minutes min';
  }

  @override
  String ng_every_hours(int hours) {
    return 'cada $hours h';
  }

  @override
  String ng_every_hours_minutes(int hours, int minutes) {
    return 'cada $hours h $minutes min';
  }

  @override
  String ng_heartbeat_fired(int count) {
    return 'Ejecutado $count veces';
  }

  @override
  String ng_heartbeat_last_fired(String time) {
    return 'Última ejecución a las $time';
  }

  @override
  String ng_wait_until(String time) {
    return 'En espera hasta $time';
  }

  @override
  String get ng_wait_resume => 'En espera para reanudar';

  @override
  String get ng_wait_other_chat => 'En espera en otro chat';

  @override
  String ng_wait_process(String pid) {
    return 'En espera del proceso $pid';
  }

  @override
  String get ng_control_open => 'Abrir objetivos y automatización';

  @override
  String get ng_control_title => 'Objetivos y automatización';

  @override
  String get ng_control_subtitle =>
      'En qué trabaja este chat y qué se ejecuta automáticamente.';

  @override
  String get ng_contract_outcome => 'Resultado';

  @override
  String get ng_contract_verification => 'Verificación';

  @override
  String get ng_contract_constraints => 'Restricciones';

  @override
  String get ng_contract_boundaries => 'Límites';

  @override
  String get ng_contract_stop_when => 'Detener cuando';

  @override
  String get ng_subgoals => 'Subobjetivos';

  @override
  String get ng_subgoal_add_placeholder => 'Añadir un subobjetivo';

  @override
  String get ng_add => 'Añadir';

  @override
  String get ng_subgoal_remove => 'Quitar subobjetivo';

  @override
  String get ng_goal_checks => 'Comprobaciones';

  @override
  String get ng_gate_not_run => 'Aún no ejecutado';

  @override
  String ng_gate_attempts(int attempts, int tries) {
    return '$attempts de $tries intentos';
  }

  @override
  String ng_gate_exit(int code) {
    return 'salida $code';
  }

  @override
  String get ng_resume_now => 'Reanudar ahora';

  @override
  String get ng_goal_clear => 'Borrar objetivo';

  @override
  String get ng_goal_clear_title => '¿Borrar este objetivo?';

  @override
  String get ng_goal_clear_message =>
      'El agente dejará de trabajar en él. También se borrarán sus subobjetivos y comprobaciones.';

  @override
  String get ng_subgoal_remove_title => '¿Quitar este subobjetivo?';

  @override
  String ng_subgoal_remove_message(String text) {
    return '«$text» dejará de formar parte del objetivo.';
  }

  @override
  String get ng_subgoals_clear_title => '¿Borrar todos los subobjetivos?';

  @override
  String get ng_subgoals_clear_message =>
      'El objetivo conservará el título, pero perderá todos sus subobjetivos.';

  @override
  String get ng_clear_all => 'Borrar todo';

  @override
  String get ng_clear => 'Borrar';

  @override
  String get ng_dismiss => 'Descartar';

  @override
  String get ng_loop_stop_title => '¿Detener este ciclo?';

  @override
  String get ng_heartbeat_clear_title => '¿Borrar este pulso?';

  @override
  String get ng_wont_fire_again => 'No volverá a ejecutarse.';

  @override
  String get ng_loop_self_paced => 'A ritmo propio';

  @override
  String ng_loop_until(String condition) {
    return 'Hasta: $condition';
  }

  @override
  String get ng_loop_waits_for_goal =>
      'Espera mientras el objetivo está en curso.';

  @override
  String get ng_loop_awaiting_reply => 'En espera de la respuesta del agente.';

  @override
  String ng_loop_stopped_reason(String reason) {
    return 'Detenido: $reason';
  }

  @override
  String get ng_hide_subagents => 'Ocultar subagentes';

  @override
  String get ng_show_subagents => 'Mostrar subagentes';

  @override
  String get ng_subagent => 'Subagente';

  @override
  String get ng_subagent_queued => 'En cola';

  @override
  String get ng_subagent_starting => 'Iniciando…';

  @override
  String get ng_subagent_running => 'En ejecución';

  @override
  String get ng_subagent_done => 'Completado';

  @override
  String get ng_subagent_failed => 'Fallido';

  @override
  String get ng_subagent_stopped => 'Detenido';

  @override
  String get ng_subagent_stop => 'Detener subagente';

  @override
  String ng_subagent_tools(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count herramientas',
      one: '1 herramienta',
    );
    return '$_temp0';
  }

  @override
  String get ng_mark_as_read => 'Marcar como leído';

  @override
  String get ng_mark_as_unread => 'Marcar como no leído';

  @override
  String ng_chats_unread(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Chats, $count sin leer',
      one: 'Chats, 1 sin leer',
    );
    return '$_temp0';
  }

  @override
  String get ng_unread_finished => 'Finalizado, respuesta sin leer';

  @override
  String get ng_unread_updates => 'En curso, actualizaciones sin leer';

  @override
  String get ng_notifications => 'Notificaciones';

  @override
  String get ng_notifications_hint =>
      'Respuestas y solicitudes mientras Ares está en segundo plano';

  @override
  String get ng_notify_replies => 'Respuestas';

  @override
  String get ng_notify_replies_hint =>
      'Cuando termina o falla una respuesta en el chat abierto';

  @override
  String get ng_notify_requests => 'Aprobaciones y preguntas';

  @override
  String get ng_notify_requests_hint =>
      'Un aviso cuando el agente esté esperando tu respuesta, con las opciones «Permitir una vez» y «Denegar»';

  @override
  String get ng_keep_running =>
      'Mantener la conexión mientras se genera una respuesta';

  @override
  String get ng_keep_running_hint =>
      'Mantiene la conexión abierta en segundo plano hasta que termine la respuesta, con una notificación silenciosa';

  @override
  String get ng_battery_settings => 'Optimización de batería';

  @override
  String get ng_battery_settings_hint =>
      'Permite que Ares siga funcionando en segundo plano para que las notificaciones lleguen a tiempo';

  @override
  String get ng_send_test_notification => 'Enviar una notificación de prueba';

  @override
  String get ng_test_notification_title =>
      'Las notificaciones de Ares funcionan';

  @override
  String get ng_test_notification_body =>
      'Las respuestas y solicitudes aparecerán así.';

  @override
  String get ng_test_notification_sent => 'Notificación de prueba enviada';

  @override
  String get ng_notifications_blocked =>
      'Las notificaciones están bloqueadas. Permítelas en los ajustes de Android.';

  @override
  String get ng_notifications_off_hint =>
      'Las notificaciones están desactivadas, así que no se mostrarán cuando Ares esté en segundo plano.';

  @override
  String get ng_insights_building =>
      'Generando el informe. La primera vez, un período largo puede tardar hasta un minuto.';

  @override
  String get ng_insights_timed_out =>
      'La pasarela tardó demasiado en generar este informe. Vuelve a intentarlo o elige un período más corto.';

  @override
  String get ng_dock_goal_active => 'Objetivo activo';

  @override
  String get ng_dock_goal_paused => 'Objetivo pausado';

  @override
  String get ng_dock_goal_waiting => 'Objetivo en espera';

  @override
  String get ng_dock_goal_blocked => 'Objetivo bloqueado';

  @override
  String get ng_dock_goal_done => 'Objetivo completado';

  @override
  String ng_dock_turn_of(int used, int max) {
    return 'Turno $used/$max';
  }

  @override
  String ng_dock_turn(int used) {
    return 'Turno $used';
  }

  @override
  String ng_dock_subagents(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count subagentes',
      one: '1 subagente',
    );
    return '$_temp0';
  }

  @override
  String ng_dock_subagents_done(int count) {
    return '$count completados';
  }

  @override
  String ng_dock_tasks(int done, int total) {
    return 'Tareas $done/$total';
  }

  @override
  String ng_dock_previous_tasks(int done, int total) {
    return 'Tareas previas $done/$total';
  }

  @override
  String get ng_dock_manage => 'Gestionar';

  @override
  String get ng_recent_notifications => 'Notificaciones recientes';

  @override
  String get ng_recent_notifications_hint =>
      'Qué intentó publicar Ares y si Android lo mostró';

  @override
  String get ng_recent_notifications_empty =>
      'Todavía no hay nada. Los intentos aparecerán aquí cuando una respuesta, pregunta o fallo vaya a enviarte una notificación.';

  @override
  String get ng_notify_permission_granted => 'Permiso concedido';

  @override
  String get ng_notify_permission_denied => 'Permiso denegado';

  @override
  String get ng_notify_master_on => 'Notificaciones activadas';

  @override
  String get ng_notify_master_off => 'Notificaciones desactivadas';

  @override
  String get ng_models_default => 'Modelo predeterminado';

  @override
  String get ng_models_change => 'Cambiar';

  @override
  String get ng_models_custom_endpoint =>
      'Usa un endpoint personalizado. Cámbialo en la pasarela.';

  @override
  String get ng_models_context_window => 'Ventana de contexto';

  @override
  String ng_models_token_count(String count) {
    return '$count tokens';
  }

  @override
  String ng_models_context_override(String count) {
    return 'Definido en la pasarela. Detectado automáticamente: $count tokens.';
  }

  @override
  String get ng_models_max_output => 'Salida máxima';

  @override
  String get ng_models_input_price => 'Precio de entrada';

  @override
  String get ng_models_output_price => 'Precio de salida';

  @override
  String get ng_models_cache_price => 'Precio de entrada en caché';

  @override
  String ng_models_per_million(String price) {
    return '$price por 1 M de tokens';
  }

  @override
  String ng_models_price_pair(String input, String output) {
    return '$input entrada · $output salida por 1 M de tokens';
  }

  @override
  String get ng_models_free => 'Gratis';

  @override
  String get ng_models_vision => 'Visión';

  @override
  String get ng_models_reasoning => 'Razonamiento';

  @override
  String get ng_models_fast => 'Modo rápido';

  @override
  String get ng_models_in_use => 'En uso';

  @override
  String ng_models_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count modelos',
      one: '$count modelo',
    );
    return '$_temp0';
  }

  @override
  String get ng_models_rate_limited => 'Límite alcanzado';

  @override
  String get ng_models_plan_locked => 'No incluido en tu plan';

  @override
  String get ng_models_unsaved => 'Cambios sin guardar';

  @override
  String get ng_models_discard => 'Descartar';

  @override
  String get ng_models_aux_hint =>
      'Las tareas auxiliares usan el modelo predeterminado salvo que les asignes uno propio.';

  @override
  String get ng_models_uses_default => 'Usa el modelo predeterminado';

  @override
  String get ng_models_thinking_level => 'Nivel de razonamiento';

  @override
  String get ng_models_providers => 'Proveedores';

  @override
  String get ng_models_saved => 'Guardado';

  @override
  String get ng_aux_vision => 'Visión';

  @override
  String get ng_aux_vision_hint => 'Lee imágenes y capturas de pantalla';

  @override
  String get ng_aux_compression => 'Compresión';

  @override
  String get ng_aux_compression_hint =>
      'Resume un chat largo para que quepa en la ventana de contexto';

  @override
  String get ng_aux_approval => 'Aprobación';

  @override
  String get ng_aux_approval_hint =>
      'Decide si un comando se puede ejecutar sin preguntar';

  @override
  String get ng_aux_mcp => 'MCP';

  @override
  String get ng_aux_mcp_hint => 'Elige qué herramientas MCP usar';

  @override
  String get ng_aux_title_generation => 'Títulos de chat';

  @override
  String get ng_aux_title_generation_hint => 'Pone nombre a los chats nuevos';

  @override
  String get ng_aux_review => 'Revisión';

  @override
  String get ng_aux_review_hint => 'Revisa el trabajo cuando ejecutas /review';

  @override
  String get ng_aux_voice_chat => 'Chat de voz';

  @override
  String get ng_aux_voice_chat_hint => 'Responde en el modo de voz';

  @override
  String get ng_aux_triage_specifier => 'Triaje';

  @override
  String get ng_aux_triage_specifier_hint =>
      'Convierte una tarjeta Kanban de una línea en una especificación';

  @override
  String get ng_aux_kanban_decomposer => 'Desglose de Kanban';

  @override
  String get ng_aux_kanban_decomposer_hint =>
      'Divide una tarjeta Kanban en tareas más pequeñas';

  @override
  String get ng_aux_profile_describer => 'Descripciones de perfil';

  @override
  String get ng_aux_profile_describer_hint =>
      'Escribe la descripción breve de cada perfil';

  @override
  String get ng_aux_curator => 'Curador';

  @override
  String get ng_aux_curator_hint => 'Revisa cómo se usan las habilidades';

  @override
  String get appearance_save_failed => 'No se pudo guardar este cambio.';

  @override
  String get appearance_keep_which_theme => '¿Qué tema quieres conservar?';

  @override
  String get appearance_tour_back => 'Atrás';

  @override
  String get appearance_tour_finish => 'Finalizar';

  @override
  String get appearance_tour_next => 'Siguiente';

  @override
  String get appearance_tour_close => 'Cerrar recorrido';

  @override
  String get appearance_dismiss_tip => 'Descartar consejo';

  @override
  String get appearance_search_settings => 'Buscar ajustes';

  @override
  String get appearance_search_show => 'Mostrar';

  @override
  String get appearance_no_matching_setting => 'Ningún ajuste coincide.';

  @override
  String get appearance_replay_tour => 'Repetir recorrido';

  @override
  String get appearance_show_tips_again => 'Volver a mostrar consejos';

  @override
  String get appearance_window_translucency_unavailable =>
      'La translucidez de la ventana no está disponible en este equipo. Linux no la admite y los ejecutables de Apple y Windows dibujan una vista opaca de Flutter.';

  @override
  String get appearance_imported_themes => 'Temas importados';

  @override
  String get appearance_import_theme_file => 'Importar archivo de tema';

  @override
  String get appearance_remove_theme => 'Eliminar tema';

  @override
  String get appearance_chat_font => 'Fuente del chat';

  @override
  String get appearance_terminal_font => 'Fuente del terminal';

  @override
  String get appearance_font_platform => 'Plataforma';

  @override
  String get appearance_automatic => 'Automático';

  @override
  String get appearance_force_left_to_right => 'Forzar de izquierda a derecha';

  @override
  String get appearance_force_right_to_left => 'Forzar de derecha a izquierda';

  @override
  String get appearance_user_bubble_opacity =>
      'Opacidad de la burbuja del usuario';

  @override
  String get appearance_inline_embeds => 'Contenido insertado';

  @override
  String get appearance_inline_embeds_hint =>
      'Las vistas previas enriquecidas se cargan desde sitios de terceros (YouTube, X, …). Preguntar muestra un marcador hasta que permitas cada una; Siempre las carga automáticamente; Desactivado mantiene enlaces simples.';

  @override
  String get appearance_embeds_ask => 'Preguntar';

  @override
  String get appearance_embeds_always => 'Siempre';

  @override
  String get appearance_embeds_off => 'Desactivado';

  @override
  String appearance_embeds_reset(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Restablecer $count servicios permitidos',
      one: 'Restablecer 1 servicio permitido',
    );
    return '$_temp0';
  }

  @override
  String get appearance_embed_load => 'Cargar';

  @override
  String appearance_embed_always_allow(String service) {
    return 'Permitir siempre $service';
  }

  @override
  String get appearance_embed_loading => 'Cargando vista previa…';

  @override
  String appearance_embed_image_failed(String host) {
    return 'No se pudo cargar la imagen de $host. Toca para abrirla.';
  }

  @override
  String get appearance_embed_preview_unavailable =>
      'Vista previa no disponible';

  @override
  String get appearance_emoji_reactions => 'Reacciones con emojis';

  @override
  String get appearance_celebration_hearts => 'Corazones de celebración';

  @override
  String get appearance_celebration_hearts_hint =>
      'Se anima un corazón cuando llega una respuesta mientras no estás.';

  @override
  String get appearance_pop_out_companion =>
      'Abrir compañero en ventana independiente';

  @override
  String get appearance_mosskip => 'Mosskip';

  @override
  String get appearance_emberbun => 'Emberbun';

  @override
  String get appearance_tideling => 'Tideling';

  @override
  String get appearance_my_hatchling => 'Mi cría';

  @override
  String get appearance_at_rest => 'En reposo';

  @override
  String get appearance_working => 'Trabajando';

  @override
  String get appearance_thinking => 'Pensando';

  @override
  String get appearance_waiting_for_you => 'Esperándote';

  @override
  String get appearance_reply_ready => 'Respuesta lista';

  @override
  String get appearance_turn_failed => 'Turno fallido';

  @override
  String get appearance_small => 'Pequeño';

  @override
  String get appearance_medium => 'Mediano';

  @override
  String get appearance_large => 'Grande';

  @override
  String get appearance_hello => '¡Hola!';

  @override
  String get appearance_unread_reply => 'Respuesta sin leer';

  @override
  String get appearance_compose => 'Redactar';

  @override
  String get appearance_say_hello => 'Saludar';

  @override
  String get appearance_pet_image_failed =>
      'No se pudo abrir esa imagen. Elige un PNG o JPEG más pequeño.';

  @override
  String get appearance_pet_companion => 'Mascota de compañía';

  @override
  String get appearance_pet_companion_hint =>
      'Muestra un compañero mientras chateas.';

  @override
  String get appearance_adopt_a_companion => 'Adoptar un compañero';

  @override
  String get appearance_roam_when_idle => 'Pasear al estar inactivo';

  @override
  String get appearance_pet_size => 'Tamaño de la mascota';

  @override
  String get appearance_hatch_from_a_local_picture =>
      'Crear una cría a partir de una imagen local';

  @override
  String get appearance_pet_image_limits =>
      'Elige un PNG o JPEG (hasta 4 MiB, 4096 px por lado y 8 MP). Previsualízalo primero. Al crear la cría se guarda un retrato de 24 × 24 píxeles y se reemplaza la cría anterior.';

  @override
  String get appearance_choose_picture => 'Elegir imagen';

  @override
  String get appearance_hatchling_preview => 'Vista previa de la cría';

  @override
  String get appearance_hatch_and_adopt => 'Crear y adoptar';

  @override
  String get appearance_discard_draft => 'Descartar borrador';

  @override
  String get appearance_forget_saved_hatchling => 'Olvidar cría guardada';

  @override
  String get appearance_radio => 'Radio';

  @override
  String appearance_radio_hint(String stations) {
    return 'Las emisiones vienen directamente de $stations y solo se inician al pulsar Reproducir. La búsqueda de emisoras se realiza en este dispositivo.';
  }

  @override
  String get appearance_radio_save_failed =>
      'No se pudieron guardar los ajustes de la radio.';

  @override
  String get appearance_choose_a_station => 'Elegir una emisora';

  @override
  String get appearance_pause_radio => 'Pausar radio';

  @override
  String get appearance_play_radio => 'Reproducir radio';

  @override
  String get appearance_next_station => 'Siguiente emisora';

  @override
  String get appearance_radio_trace_semantics =>
      'Actividad de la emisión. Los niveles de audio no están disponibles, por lo que esta línea permanece plana.';

  @override
  String get appearance_radio_is_off => 'La radio está apagada';

  @override
  String get appearance_paused => 'En pausa';

  @override
  String get appearance_connecting => 'Conectando…';

  @override
  String get appearance_live => 'En directo';

  @override
  String get appearance_stream_unavailable => 'Emisión no disponible';

  @override
  String appearance_now_playing(String credit) {
    return 'Reproduciendo: $credit';
  }

  @override
  String get appearance_audio_only_waveform_unavailable =>
      'Solo audio · forma de onda no disponible';

  @override
  String get appearance_volume => 'Volumen';

  @override
  String get appearance_search_presets => 'Buscar emisoras predefinidas';

  @override
  String get appearance_no_stations_found => 'No se encontraron emisoras';

  @override
  String appearance_unpin_station(String station) {
    return 'Desfijar emisora: $station';
  }

  @override
  String appearance_pin_station(String station) {
    return 'Fijar emisora: $station';
  }

  @override
  String get appearance_radio_picker_metadata_notice =>
      'Mientras este selector esté abierto, las emisoras en reproducción pueden compartir detalles de las pistas directamente desde la emisora.';

  @override
  String get appearance_message_from_your_companion =>
      'Mensaje de tu compañero';

  @override
  String get appearance_send_to_the_open_chat => 'Enviar al chat abierto';

  @override
  String get appearance_tour_theme_body =>
      'Importa un tema de color de VS Code desde un archivo de este dispositivo y elige qué variante conservar.';

  @override
  String get appearance_tour_fonts_title => 'Fuentes de lectura';

  @override
  String get appearance_tour_fonts_body =>
      'El texto del chat y el código del terminal usan fuentes distintas incluidas en Ares.';

  @override
  String get appearance_tour_direction_title => 'Dirección de la transcripción';

  @override
  String get appearance_tour_direction_body =>
      'Déjalo en automático o fuerza la transcripción de izquierda a derecha o de derecha a izquierda.';

  @override
  String get appearance_tour_pet_title => 'Compañero';

  @override
  String get appearance_tour_pet_body =>
      'El compañero está desactivado hasta que adoptes uno. La ventana independiente añade un pequeño editor.';

  @override
  String get appearance_tour_radio_body =>
      'La radio permanece apagada hasta que la actives. Pulsar Reproducir es lo que abre una emisión.';

  @override
  String get appearance_tip_theme =>
      'Los temas importados sustituyen la paleta integrada hasta que borres la selección. Solo se conservan los colores.';

  @override
  String get appearance_tip_pet =>
      'El compañero guarda un pequeño retrato en este dispositivo. No sube la imagen a partir de la que creas la cría.';

  @override
  String get appearance_theme_import_failed =>
      'No se pudo importar ese tema. Elige un tema de color de VS Code guardado como archivo .vsix, .json o .jsonc.';

  @override
  String get render_widget_file_truncated =>
      'Solo se leyó el principio de este archivo, así que el widget puede estar incompleto.';

  @override
  String get setup_beat_title => 'Configuración';

  @override
  String setup_beat_use_name(String name) {
    return 'Usar $name';
  }

  @override
  String get setup_beat_name_hint => '¿Cómo debe llamarte Hermes?';

  @override
  String get setup_beat_on_computer =>
      'Este paso se hace en Hermes, en el ordenador donde se ejecuta. Continuar mantiene lo que ya está configurado allí.';

  @override
  String get setup_beat_not_waiting =>
      'Esta tarjeta de configuración ya no espera respuesta.';

  @override
  String get catalog_kind_plugin => 'Plugin';

  @override
  String get catalog_kind_skill => 'Habilidad';

  @override
  String get catalog_tier_official => 'Oficial';

  @override
  String get catalog_tier_verified => 'Verificado';

  @override
  String get catalog_tier_community => 'Comunidad';

  @override
  String get catalog_install => 'Instalar';

  @override
  String get catalog_waiting => 'Esperando tu elección';

  @override
  String get catalog_installed => 'Instalado';

  @override
  String get catalog_installed_off => 'Instalado, sin activar';

  @override
  String get catalog_skipped => 'Omitido';

  @override
  String get catalog_not_installed => 'No instalado';

  @override
  String catalog_target_profile(String profile) {
    return 'Se instala en el perfil $profile';
  }

  @override
  String catalog_source(String repo, String sha) {
    return '$repo en $sha';
  }

  @override
  String catalog_scan(String status, String summary) {
    return 'Análisis de seguridad: $status. $summary';
  }

  @override
  String catalog_requires_hermes(String range) {
    return 'Requiere Hermes $range';
  }

  @override
  String catalog_skill_ready(String name) {
    return 'La habilidad $name está lista';
  }

  @override
  String catalog_missing_env(String names) {
    return 'Aún necesita: $names';
  }

  @override
  String catalog_server_error(String name, String error) {
    return '$name no se conectó: $error';
  }

  @override
  String get catalog_send_failed =>
      'No se envió tu elección. Inténtalo de nuevo.';

  @override
  String get attachment_video_speed => 'Velocidad de reproducción';

  @override
  String get catalog_installing => 'Instalando…';

  @override
  String get catalog_phase_downloading => 'Descargando…';

  @override
  String get catalog_phase_python_packages => 'Instalando paquetes de Python…';

  @override
  String get catalog_phase_loading_tools => 'Cargando sus herramientas…';

  @override
  String get setup_beat_send_failed =>
      'No se envió tu respuesta. Inténtalo de nuevo.';

  @override
  String catalog_tool_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count herramientas',
      one: '1 herramienta',
    );
    return '$_temp0';
  }

  @override
  String get render_svg_not_drawn => 'Este SVG no se dibujó.';

  @override
  String get render_notes_directive => 'Directiva de notas';

  @override
  String get render_maths_source => 'Fuente de la fórmula';

  @override
  String get render_inline_maths_source => 'Fuente de la fórmula en línea';

  @override
  String get render_sequence_outline => 'Esquema de secuencia';

  @override
  String get render_diagram_outline => 'Esquema del diagrama';

  @override
  String render_revision_of(int index, int count) {
    return 'Revisión $index de $count';
  }

  @override
  String get render_previous_revision => 'Revisión anterior';

  @override
  String get render_next_revision => 'Revisión siguiente';

  @override
  String get render_show_rendered => 'Renderizado';

  @override
  String get render_show_source => 'Código fuente';

  @override
  String render_copied_file(String name) {
    return 'Se copió $name';
  }

  @override
  String render_copy_file(String name) {
    return 'Copiar $name';
  }

  @override
  String get render_artifact_too_long =>
      'Este artefacto es demasiado largo para mostrarlo aquí como página.';

  @override
  String get render_active_content_removed =>
      'Se quitaron los scripts, los marcos y las direcciones externas.';

  @override
  String render_widget_file(String file) {
    return 'Archivo de widget $file';
  }

  @override
  String get render_widget_runs_as_text =>
      'Se ejecuta como texto en este chat. Se quitan los scripts y los marcos externos.';

  @override
  String get render_load_widget => 'Cargar widget';

  @override
  String get render_not_html_widget => 'Este archivo no es un widget HTML.';

  @override
  String get render_widget_sent => 'Enviado a este chat';

  @override
  String get render_widget_not_sent => 'No se envió a este chat';

  @override
  String get render_widget_throttled =>
      'Espera un momento antes de volver a enviar';

  @override
  String get render_widget_too_long =>
      'Esta solicitud es demasiado larga para enviarla';

  @override
  String get render_widget_no_gesture =>
      'Toca un control del widget para enviar';

  @override
  String get render_widget_invalid => 'No se pudo enviar esta solicitud';

  @override
  String get render_inspected_image => 'Imagen inspeccionada';

  @override
  String get render_contributions => 'Contribuciones';

  @override
  String get render_contributions_intro =>
      'Solo las contribuciones compiladas en Ares pueden añadir algo a una respuesta. El texto del chat no puede registrar ninguna y un permiso solo se aplica a esta conexión.';

  @override
  String render_grant_plugin(String name) {
    return 'Permitir $name';
  }

  @override
  String render_revoke_plugin(String name) {
    return 'Revocar $name';
  }

  @override
  String render_plugin_slots(String directive) {
    return 'tarjetas de respuesta para ::$directive';
  }

  @override
  String get render_plugin_notes => 'Notas';

  @override
  String get catalog_scan_passed => 'superado';

  @override
  String get catalog_scan_warnings => 'encontró advertencias';

  @override
  String get catalog_scan_failed => 'falló';

  @override
  String get deployment_token_label => 'Token de despliegue (opcional)';

  @override
  String get deployment_token_helper =>
      'Para tokens de sesión de Hermes Dashboard enviados como X-Hermes-Session-Token. No se guarda en texto plano en las preferencias.';

  @override
  String get deployment_token_hint => 'Token de sesión del panel';

  @override
  String get custom_headers_label => 'Encabezados personalizados (opcional)';

  @override
  String get custom_headers_helper =>
      'Uno por línea, p. ej. X-Custom: valor. Se rechazan los encabezados prohibidos.';

  @override
  String get custom_headers_hint => 'p. ej. X-Custom-Header: valor';

  @override
  String get desktop_tray_open => 'Abrir Ares';

  @override
  String get desktop_tray_new_chat => 'Nuevo chat';

  @override
  String get desktop_tray_quick_entry => 'Entrada rápida…';

  @override
  String get desktop_tray_pause_notifications => 'Pausar notificaciones';

  @override
  String get desktop_tray_quit => 'Salir de Ares';

  @override
  String get desktop_integration_title => 'Integración con el escritorio';

  @override
  String get desktop_tray_setting =>
      'Mostrar Ares en la bandeja del sistema o la barra de menús';

  @override
  String get desktop_tray_setting_help =>
      'Desde el icono puedes abrir Ares, iniciar un chat, abrir la entrada rápida, pausar las notificaciones o salir.';

  @override
  String get desktop_close_to_tray_setting =>
      'Seguir ejecutándose en la bandeja al cerrar la ventana';

  @override
  String get desktop_tray_unsupported =>
      'Este escritorio no tiene una bandeja del sistema que Ares pueda usar.';

  @override
  String get quick_entry_title => 'Entrada rápida';

  @override
  String get quick_entry_hint => 'Escribe una instrucción para Ares…';

  @override
  String get quick_entry_submit => 'Poner en el editor';

  @override
  String get quick_entry_never_sends =>
      'Enter coloca el texto en el editor del chat. No se envía nada hasta que pulses Enviar.';

  @override
  String get quick_entry_unavailable =>
      'No se pudo abrir la entrada rápida. Inténtalo de nuevo.';

  @override
  String get desktop_hotkey_setting => 'Atajo de entrada rápida';

  @override
  String desktop_hotkey_help(String shortcut) {
    return 'Pulsa $shortcut en cualquier lugar para abrir la entrada rápida.';
  }

  @override
  String desktop_hotkey_conflict(String shortcut) {
    return 'Otra app ya usa $shortcut. Elige un atajo diferente.';
  }

  @override
  String get desktop_hotkey_unsupported =>
      'Este escritorio no permite que las apps registren un atajo global (por ejemplo, en Wayland).';

  @override
  String get desktop_hotkey_no_modifier => 'Incluye Cmd, Ctrl o Alt.';

  @override
  String get desktop_hotkey_super_key =>
      'La tecla Windows o Super está reservada para el sistema.';

  @override
  String get desktop_hotkey_reserved => 'El sistema ya usa este atajo.';

  @override
  String desktop_hotkey_in_app(String action) {
    return 'Ares ya usa este atajo para $action.';
  }

  @override
  String get desktop_hotkey_change => 'Cambiar';

  @override
  String get desktop_hotkey_reset => 'Usar predeterminado';

  @override
  String get capture_screen_action => 'Capturar pantalla';

  @override
  String get capture_screen_help =>
      'Añade una captura al mensaje como borrador. No se envía nada hasta que pulses Enviar.';

  @override
  String get capture_screen_unavailable =>
      'La captura de pantalla no está disponible en este escritorio.';

  @override
  String get capture_screen_failed =>
      'No se pudo capturar la pantalla. Inténtalo de nuevo.';

  @override
  String get capture_permission_title => 'Permitir la grabación de pantalla';

  @override
  String get capture_permission_body =>
      'Para capturar una ventana, Ares necesita el permiso de grabación de pantalla. Activa Ares en Ajustes del Sistema > Privacidad y seguridad > Grabación de pantalla y vuelve a intentarlo.';

  @override
  String get capture_open_settings => 'Abrir Ajustes del Sistema';

  @override
  String get keep_awake_title => 'Mantener el equipo activo';

  @override
  String get keep_awake_title_mobile => 'Mantener la pantalla encendida';

  @override
  String get keep_awake_mode_off => 'Desactivado';

  @override
  String get keep_awake_mode_while_working => 'Mientras trabaja';

  @override
  String get keep_awake_mode_always => 'Siempre';

  @override
  String get keep_awake_off_help =>
      'No bloquear nunca la suspensión del sistema (predeterminado).';

  @override
  String get keep_awake_while_working_help =>
      'Evitar la suspensión por inactividad solo mientras se ejecuta un turno del agente.';

  @override
  String get keep_awake_always_help =>
      'Evitar la suspensión por inactividad mientras Ares esté abierto en este dispositivo.';

  @override
  String get keep_awake_off_help_mobile =>
      'Dejar que la pantalla se apague como siempre (predeterminado).';

  @override
  String get keep_awake_while_working_help_mobile =>
      'Mantener la pantalla encendida mientras se ejecuta un turno del agente y Ares está abierto.';

  @override
  String get keep_awake_always_help_mobile =>
      'Mantener la pantalla encendida mientras Ares esté abierto.';

  @override
  String get ng_token_gateway_has_no_sign_in =>
      'Este gateway no tiene inicio de sesión, así que no puede comprobar un token de despliegue. Activa la autenticación del panel en el host (o actualiza Hermes) y vuelve a intentarlo.';

  @override
  String get palette_open => 'Paleta de comandos de la app';

  @override
  String get palette_no_matches => 'No hay acciones que coincidan';

  @override
  String get palette_filter_hint => 'Escribe para filtrar acciones…';

  @override
  String get palette_keys_move => '↑↓ para moverte';

  @override
  String get palette_keys_run => 'Intro para ejecutar';

  @override
  String get palette_keys_close => 'Esc para cerrar';

  @override
  String get palette_search_sessions => 'Buscar sesiones';

  @override
  String get palette_scheduled_crons => 'Programadas / Crons';

  @override
  String get palette_capabilities_skills => 'Capacidades y habilidades';

  @override
  String get palette_insights_usage => 'Información y uso';

  @override
  String get palette_more_projects => 'Más y proyectos';

  @override
  String get deeplink_chat_not_found =>
      'No se encontró el chat en la lista. Puede que aún no se haya cargado.';

  @override
  String get keyboard_shortcuts_title => 'Atajos de teclado';

  @override
  String get shortcuts_reset_all => 'Restablecer todo';

  @override
  String get shortcuts_reset_to_default => 'Restablecer valor predeterminado';

  @override
  String get shortcut_action_command_palette => 'Paleta de comandos';

  @override
  String get shortcut_action_new_chat => 'Nuevo chat';

  @override
  String get shortcut_action_search => 'Buscar';

  @override
  String get shortcut_action_settings => 'Ajustes';

  @override
  String shortcut_action_go_to_tab(int number) {
    return 'Ir a la pestaña $number';
  }

  @override
  String shortcuts_conflict(String first, String second, String chord) {
    return 'Conflicto: «$first» y «$second» usan $chord. El atajo personalizado mantiene su valor predeterminado hasta que cambies uno de ellos.';
  }

  @override
  String shortcuts_editor_title(String action) {
    return 'Atajo: $action';
  }

  @override
  String get shortcuts_editor_help =>
      'Pulsa una combinación de teclas o elige modificadores y una tecla abajo:';

  @override
  String get shortcuts_editor_needs_modifier =>
      'Elige al menos Cmd/Meta, Ctrl o Alt para que escribir en el editor no se vea afectado.';

  @override
  String shortcuts_text_editing_warning(String chord) {
    return '$chord es un atajo de edición de texto (copiar, pegar, cortar, deshacer, rehacer o seleccionar todo). Si lo asignas aquí, los campos de texto lo pierden.';
  }

  @override
  String shortcuts_text_editing_in_use(String action, String chord) {
    return '«$action» usa $chord, un atajo de edición de texto. Los campos de texto lo pierden mientras esté asignado aquí.';
  }

  @override
  String custom_headers_problem_format(int line) {
    return 'Línea $line: se esperaba «Nombre: Valor»';
  }

  @override
  String custom_headers_problem_missing_name(int line) {
    return 'Línea $line: falta el nombre del encabezado';
  }

  @override
  String custom_headers_problem_invalid_name(int line, String name) {
    return 'Línea $line: nombre de encabezado no válido «$name»';
  }

  @override
  String custom_headers_problem_reserved(int line, String name) {
    return 'Línea $line: «$name» está reservado y no se puede reenviar';
  }

  @override
  String custom_headers_problem_empty_value(int line) {
    return 'Línea $line: valor de encabezado vacío';
  }

  @override
  String get ng_enter_a_deployment_token =>
      'Introduce un token de sesión de despliegue.';

  @override
  String get ng_custom_headers => 'Encabezados personalizados';

  @override
  String get ng_custom_headers_help =>
      'Encabezados HTTP adicionales para este gateway (Nombre: Valor, uno por línea), enviados en sus llamadas REST y WebSocket. Se guardan en el almacén seguro de credenciales. Se rechazan los encabezados de autenticación y de salto a salto.';

  @override
  String get ng_use_a_deployment_token =>
      'Usar un token de sesión de despliegue';

  @override
  String get ng_sign_in_with_deployment_token =>
      'Iniciar sesión con token de despliegue';

  @override
  String get ng_signed_in_with_deployment_token =>
      'Sesión iniciada con el token de despliegue.';

  @override
  String get auto_speak_replies_title => 'Leer respuestas en voz alta';

  @override
  String get auto_speak_replies_subtitle =>
      'Lee cada nueva respuesta en voz alta al finalizar un turno. Desactivado por defecto; el control de respuestas habladas sigue aplicando.';

  @override
  String get ng_auto_read_replies_title => 'Leer respuestas automáticamente';

  @override
  String get ng_auto_read_replies_subtitle =>
      'Lee cada nueva respuesta en voz alta al finalizar un turno. Desactivado por defecto.';

  @override
  String get barge_in_title => 'Interrumpir';

  @override
  String get barge_in_subtitle =>
      'Hable durante una respuesta para interrumpirla. El micrófono permanece encendido mientras se leen las respuestas en voz alta.';

  @override
  String get barge_in_mic_live =>
      'Micrófono activado: hable para interrumpir la respuesta';

  @override
  String get ng_barge_in_title => 'Interrumpir';

  @override
  String get ng_barge_in_subtitle =>
      'Hable durante una respuesta para interrumpirla. El micrófono permanece encendido mientras se leen las respuestas en voz alta.';

  @override
  String get ng_barge_in_mic_live =>
      'Micrófono activado: hable para interrumpir la respuesta';

  @override
  String get wake_word_title => 'Palabra de activación';

  @override
  String get wake_word_subtitle =>
      'Detección manos libres en la pasarela. Desactivada por defecto; solo transmite audio cuando la captura del dispositivo está activa.';

  @override
  String wake_word_listening(String phrase) {
    return 'Escuchando la palabra de activación \"$phrase\"';
  }

  @override
  String wake_word_paused(String phrase) {
    return 'Palabra de activación \"$phrase\" — en pausa';
  }

  @override
  String wake_word_off(String phrase) {
    return 'Palabra de activación \"$phrase\" — desactivada';
  }

  @override
  String get wake_word_arming => 'Activando palabra de activación…';

  @override
  String get wake_word_stop => 'Detener palabra de activación';

  @override
  String get wake_word_rearm => 'Reactivar';

  @override
  String get wake_word_capture_mode => 'Modo de captura';

  @override
  String get wake_word_capture_auto => 'Automático';

  @override
  String get wake_word_capture_client => 'Micrófono de este dispositivo';

  @override
  String get wake_word_capture_local => 'Micrófono del host de la pasarela';

  @override
  String get wake_word_capture_unavailable =>
      'Esta pasarela no permite que las aplicaciones cambien el modo de captura. Configura wake_word.capture en la configuración de Hermes del host de la pasarela.';

  @override
  String get wake_word_input_device => 'Micrófono de entrada';

  @override
  String get wake_word_default_device => 'Predeterminado del sistema';

  @override
  String get ng_wake_word_title => 'Palabra de activación';

  @override
  String get ng_wake_word_subtitle =>
      'Detección manos libres en la pasarela. Desactivada por defecto.';

  @override
  String get voice_engine_title => 'Motor de conversación por voz';

  @override
  String get voice_engine_subtitle =>
      'Elija cómo se ejecutan las conversaciones de voz manos libres en este perfil de la pasarela.';

  @override
  String get voice_engine_chained => 'Encadenado (voz a texto → Hermes → voz)';

  @override
  String get voice_engine_chained_short => 'Encadenado';

  @override
  String get voice_engine_live => 'GPT-Live (voz en tiempo real)';

  @override
  String get voice_engine_live_short => 'GPT-Live';

  @override
  String get voice_engine_live_needs_key =>
      'Configure una clave de API de OpenAI en el host de la pasarela para activar GPT-Live.';

  @override
  String voice_engine_fallback_chained(String reason) {
    return 'GPT-Live no disponible ($reason) — se usa la voz encadenada.';
  }

  @override
  String get voice_live_start => 'Iniciar conversación de voz';

  @override
  String get voice_live_stop => 'Finalizar conversación de voz';

  @override
  String get voice_live_mute => 'Silenciar micrófono';

  @override
  String get voice_live_unmute => 'Activar micrófono';

  @override
  String get voice_live_interrupt => 'Interrumpir o responder ahora';

  @override
  String get voice_live_listening => 'Escuchando';

  @override
  String get voice_live_speaking => 'Hablando';

  @override
  String get voice_live_thinking => 'Pensando';

  @override
  String get voice_live_muted => 'Silenciado';

  @override
  String get voice_live_ended_connection_lost =>
      'La sesión de voz en vivo perdió la conexión.';

  @override
  String get voice_live_ended_closed =>
      'El servicio cerró la sesión de voz en vivo.';

  @override
  String wake_word_other_profile(String profile) {
    return 'Esa palabra de activación pertenece al perfil «$profile». Abre una conexión con ese perfil para responder.';
  }

  @override
  String get wake_word_reason_disabled => 'Desactivada — toque para activar';

  @override
  String get wake_word_reason_surface =>
      'Limitada a otra superficie (configuración wake_word.surface)';

  @override
  String get wake_word_reason_owned =>
      'Otra superficie controla la escucha de la palabra de activación';

  @override
  String wake_word_reason_owned_by(String surface) {
    return 'Otra superficie ($surface) controla la escucha de la palabra de activación';
  }

  @override
  String get wake_word_reason_unavailable =>
      'Palabra de activación no disponible en esta pasarela';

  @override
  String get wake_word_reason_permission_denied =>
      'Permiso de micrófono denegado';

  @override
  String get wake_word_reason_permission_required =>
      'Se necesita permiso de micrófono — toque para activar';

  @override
  String get voice_live_not_enabled =>
      'GPT-Live no está activado para este perfil.';

  @override
  String get voice_live_not_available => 'GPT-Live no está disponible';

  @override
  String voice_live_start_failed(String error) {
    return 'No se pudo iniciar GPT-Live: $error';
  }

  @override
  String voice_direct_stt_timeout(String seconds, String provider) {
    return 'La transcripción agotó el tiempo tras $seconds s ($provider no respondió)';
  }

  @override
  String voice_direct_stt_error(String provider, String status) {
    return 'Error de STT de $provider (HTTP $status)';
  }

  @override
  String voice_direct_tts_failed(String provider) {
    return 'Falló la solicitud de TTS a $provider';
  }

  @override
  String voice_direct_tts_error(String provider, String status) {
    return 'Error de TTS de $provider (HTTP $status)';
  }

  @override
  String ng_wake_status_listening(String phrase) {
    return 'Escuchando (\"$phrase\")';
  }

  @override
  String ng_wake_status_off(String phrase) {
    return 'Desactivada (\"$phrase\")';
  }

  @override
  String ng_wire_setting_unavailable(Object setting) {
    return 'Cambiar $setting aún no está disponible en la pasarela compartida';
  }

  @override
  String ng_wire_method_unavailable(Object method) {
    return '$method aún no está disponible en la pasarela compartida';
  }

  @override
  String ng_wire_session_options_unsupported(Object options) {
    return 'La pasarela canónica no admite estas opciones de sesión explícitas: $options';
  }

  @override
  String get ng_wire_prompt_stale =>
      'La solicitud está obsoleta o no disponible; vuelve a conectarte antes de responder';

  @override
  String get ng_wire_revision_unavailable =>
      'La revisión de la sesión no está disponible; vuelve a abrir la sesión antes de editar los metadatos';

  @override
  String get ng_wire_generation_unavailable =>
      'La identidad de ejecución de la sesión no está disponible; vuelve a conectarte antes de usar este comando';

  @override
  String get ng_wire_message_not_saved =>
      'Este mensaje aún no se ha guardado; espera a que termine y vuelve a bifurcar desde él';

  @override
  String get ng_wire_not_available =>
      'Aún no disponible en la pasarela compartida';

  @override
  String get edit_turn_title => '¿Editar este mensaje?';

  @override
  String get edit_turn_body =>
      'El mensaje se volverá a ejecutar desde aquí. Los turnos posteriores se archivan.';

  @override
  String get edit_turn_send => 'Enviar';

  @override
  String get restore_turn_title => '¿Restaurar a este punto de control?';

  @override
  String get restore_turn_body =>
      'Se eliminará de la conversación todo lo posterior a este mensaje y volverá a ejecutarse desde aquí.';

  @override
  String get restore_turn_confirm => 'Restaurar y reejecutar';

  @override
  String get edit_turn_later_turns_body =>
      'Esto archivará los turnos posteriores de la conversación. ¿Continuar?';

  @override
  String get session_history => 'Historial de la sesión';

  @override
  String get import_claude_or_codex => 'Importar Claude o Codex';

  @override
  String get ng_session_history => 'Historial de la sesión';

  @override
  String get ng_import_claude_or_codex => 'Importar Claude o Codex';

  @override
  String get ng_edit_and_resend => 'Editar y reenviar';

  @override
  String get ng_restore_turn_confirm => 'Restaurar y reejecutar';

  @override
  String get rewind_target_unsaved =>
      'Este mensaje aún no está guardado. Espera a que termine y vuelve a editarlo.';

  @override
  String get rewind_turn_busy =>
      'La respuesta actual aún no se ha detenido, así que no se envió nada. Inténtalo de nuevo en un momento.';

  @override
  String get rewind_session_changed =>
      'Este chat ha cambiado desde que se abrió aquí, así que no se eliminó ni se envió nada. Vuelve a abrirlo e inténtalo de nuevo.';

  @override
  String get history_lineage => 'Chats relacionados';

  @override
  String get history_lineage_none =>
      'Este chat no tiene bifurcaciones ni ramas hermanas.';

  @override
  String get history_lineage_unavailable =>
      'No se pudieron leer los chats relacionados de este gateway.';

  @override
  String get history_lineage_parent => 'Origen';

  @override
  String get history_lineage_sibling => 'Hermano';

  @override
  String get history_lineage_fork => 'Bifurcación';

  @override
  String get history_messages => 'Mensajes';

  @override
  String get history_messages_hint =>
      'Selecciona un mensaje guardado para bifurcar o rebobinar ahí.';

  @override
  String get history_messages_none => 'Aún no hay mensajes guardados.';

  @override
  String get history_messages_unavailable =>
      'No se pudieron leer los mensajes guardados. Abre este chat y actualiza.';

  @override
  String get history_role_user => 'Tú';

  @override
  String get history_role_assistant => 'Hermes';

  @override
  String get history_branch_here => 'Bifurcar desde aquí';

  @override
  String get history_rewind_here => 'Rebobinar hasta aquí';

  @override
  String get history_branch_title => 'Bifurcar desde este mensaje';

  @override
  String get history_branch_body =>
      'Esto crea un chat nuevo con el historial hasta el mensaje seleccionado. El chat actual se queda como está.';

  @override
  String get history_rewind_title => 'Rebobinar hasta este mensaje';

  @override
  String get history_rewind_body =>
      'Los mensajes desde el seleccionado en adelante se eliminan de este chat. Los archivos del equipo no cambian. Restaurarlos es una acción aparte con puntos de control.';

  @override
  String history_branched(String id) {
    return 'Bifurcado como $id';
  }

  @override
  String get history_open_chat => 'Abrir chat';

  @override
  String get history_mutate_unsupported =>
      'Bifurcar y rebobinar requieren Hermes 0.23 o posterior en este gateway.';

  @override
  String get history_checkpoints => 'Puntos de control';

  @override
  String get history_checkpoints_none =>
      'Esta sesión no tiene puntos de control de archivos.';

  @override
  String get history_checkpoints_unavailable =>
      'Los puntos de control no están disponibles en este gateway.';

  @override
  String get history_diff_none => 'Sin diferencias.';

  @override
  String get history_diff_loading => 'Cargando los cambios…';

  @override
  String get history_diff_failed =>
      'No se pudieron cargar los cambios, así que este punto de control aún no se puede restaurar.';

  @override
  String get history_restore_checkpoint => 'Restaurar punto de control';

  @override
  String get history_restore_title => 'Restaurar este punto de control';

  @override
  String get history_restore_body =>
      'Los archivos que el agente cambió desde este punto de control vuelven a como estaban. Tus propios cambios se conservan. También pueden eliminarse mensajes posteriores del chat. La conversación no se bifurca.';

  @override
  String get history_restore_body_all =>
      'Todos los archivos de la carpeta de la sesión vuelven a este punto de control, incluidos tus propios cambios. También pueden eliminarse mensajes posteriores del chat. La conversación no se bifurca.';

  @override
  String get history_restore_own_edits =>
      'Revertir también mis propios cambios';

  @override
  String get history_restored => 'Punto de control restaurado.';

  @override
  String history_restored_removed(int count) {
    return 'Punto de control restaurado. Se eliminaron $count mensajes del chat.';
  }

  @override
  String get history_export => 'Exportar';

  @override
  String get history_export_redact => 'Ocultar tokens';

  @override
  String get history_export_action => 'Exportar transcripción';

  @override
  String get history_export_saved => 'Transcripción guardada.';

  @override
  String get history_export_unsupported =>
      'Exportar requiere Hermes 0.23 o posterior en este gateway.';

  @override
  String get history_import_unsupported =>
      'Este gateway no admite la importación de Claude y Codex.';

  @override
  String history_import_destination(String profile) {
    return 'Perfil de destino: $profile.';
  }

  @override
  String history_import_reading(String host, String profile, int count) {
    return 'Leyendo de $host · Perfil de destino: $profile. No se pudieron leer $count registros.';
  }

  @override
  String get history_import_all => 'Todos';

  @override
  String history_import_scan_failed(String reason) {
    return 'No se pudieron buscar las sesiones del host: $reason';
  }

  @override
  String get history_import_none =>
      'No se encontraron sesiones de Claude Code ni de Codex en este host.';

  @override
  String get history_import_no_match =>
      'No hay sesiones del host que coincidan.';

  @override
  String history_import_preview_failed(String reason) {
    return 'No se pudo previsualizar la sesión: $reason';
  }

  @override
  String get history_import_open => 'Abrir sesión importada';

  @override
  String get history_import_action => 'Importar sesión seleccionada';

  @override
  String get history_import_title => 'Importar esta sesión';

  @override
  String history_import_body(String profile) {
    return 'Copiar esta sesión de Claude o Codex al perfil «$profile» de este gateway.';
  }

  @override
  String history_import_body_existing(String profile) {
    return 'Esta sesión ya se importó en «$profile». Continúa con la copia existente.';
  }

  @override
  String history_imported(String id) {
    return 'Importado como $id';
  }

  @override
  String history_imported_already(String id) {
    return 'Ya importado como $id';
  }

  @override
  String history_import_directory(String path) {
    return 'Directorio: $path';
  }

  @override
  String history_import_preview_partial(int shown, int total) {
    return 'La vista previa muestra $shown de $total.';
  }

  @override
  String history_failed(String reason) {
    return 'No se pudo completar: $reason';
  }

  @override
  String get history_error_unavailable =>
      'El gateway no pudo hacerlo ahora. Inténtalo de nuevo.';

  @override
  String get history_error_unsupported => 'Este gateway no admite esta acción.';

  @override
  String get history_error_denied => 'Este gateway rechazó la solicitud.';

  @override
  String get history_error_changed =>
      'Este chat cambió mientras esta página estaba abierta. Actualiza y vuelve a intentarlo.';

  @override
  String get history_error_unbound =>
      'Este chat no está abierto en el gateway. Ábrelo y vuelve a intentarlo.';

  @override
  String get history_error_invalid =>
      'El gateway envió una respuesta que esta app no pudo leer.';

  @override
  String ng_dock_kanban(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tarjetas Kanban',
      one: '1 tarjeta Kanban',
    );
    return '$_temp0';
  }

  @override
  String ng_dock_kanban_done(int count) {
    return '$count completadas';
  }

  @override
  String get ng_show_kanban => 'Mostrar tarjetas Kanban';

  @override
  String get ng_hide_kanban => 'Ocultar tarjetas Kanban';

  @override
  String get ng_kanban_status_triage => 'Clasificación';

  @override
  String get ng_kanban_status_todo => 'Por hacer';

  @override
  String get ng_kanban_status_scheduled => 'Programada';

  @override
  String get ng_kanban_status_ready => 'Lista';

  @override
  String get ng_kanban_status_running => 'En ejecución';

  @override
  String get ng_kanban_status_blocked => 'Bloqueada';

  @override
  String get ng_kanban_status_review => 'En revisión';

  @override
  String get ng_kanban_status_done => 'Completada';

  @override
  String get ng_kanban_status_archived => 'Archivada';

  @override
  String ng_kanban_open_card(String title) {
    return 'Abrir $title en Kanban';
  }

  @override
  String ng_kanban_show_all(int count) {
    return 'Mostrar las $count';
  }

  @override
  String ng_kanban_this_chat(int count) {
    return 'Este chat ($count)';
  }

  @override
  String get ng_kanban_close => 'Cerrar Kanban';

  @override
  String get ng_kanban_block_no_dashboard =>
      'Esta conexión no tiene acceso al panel, así que el estado de las tarjetas no se actualiza en vivo y el tablero no se puede abrir.';

  @override
  String get ng_kanban_block_unsupported =>
      'Kanban no está activado en este gateway. Activa su plugin kanban para ver el estado en vivo y abrir el tablero.';

  @override
  String get ng_kanban_block_denied =>
      'Inicia sesión en el panel para ver el estado en vivo de las tarjetas y abrir el tablero.';

  @override
  String get ng_kanban_block_insecure =>
      'Kanban necesita HTTPS o una conexión local, así que el estado de las tarjetas no se actualiza en vivo y el tablero no se puede abrir.';

  @override
  String get ng_kanban_block_unreachable =>
      'No se pudo conectar con Kanban en este gateway. El estado de las tarjetas puede estar desactualizado.';

  @override
  String get ng_kanban_block_stale =>
      'La conexión ha cambiado. Vuelve a abrir este chat para ver el estado en vivo de las tarjetas.';

  @override
  String get ng_bots_tab_roster => 'Equipo';

  @override
  String get ng_bots_tab_rooms => 'Salas';

  @override
  String get ng_bots_tab_screen => 'Pantalla';

  @override
  String get ng_bots_tab_routines => 'Rutinas';

  @override
  String ng_bots_rooms_load_failed(String error) {
    return 'No se pudieron cargar las salas: $error';
  }

  @override
  String ng_bots_routines_load_failed(String error) {
    return 'No se pudieron cargar las rutinas: $error';
  }

  @override
  String ng_bots_desktop_failed(String error) {
    return 'Bot Desktop: $error';
  }

  @override
  String get ng_bots_install_not_started =>
      'El gateway no inició la instalación.';

  @override
  String ng_bots_install_failed_error(String error) {
    return 'Error en la instalación: $error';
  }

  @override
  String get ng_bots_install_cancelled => 'Se canceló la instalación.';

  @override
  String get ng_bots_install_no_sudo =>
      'sudo no está disponible en el host del gateway. Ejecuta allí el comando anterior y luego actualiza.';

  @override
  String ng_bots_install_exit_code(String code) {
    return 'La instalación falló (código de salida $code).';
  }

  @override
  String ng_bots_install_done(String bot) {
    return 'Bot Desktop instalado para $bot';
  }

  @override
  String get ng_bots_start_failed => 'Error al iniciar';

  @override
  String ng_bots_stop_title(String bot) {
    return '¿Detener Bot Desktop para $bot?';
  }

  @override
  String get ng_bots_stop_human_held =>
      'Alguien está controlando esta pantalla. Si la detienes, su sesión termina y se cierra todo lo que esté abierto en ella.';

  @override
  String get ng_bots_stop_body =>
      'Se cerrará todo lo que esté abierto en la pantalla del bot.';

  @override
  String get ng_bots_stop_refused => 'Detención rechazada';

  @override
  String get ng_bots_take_over_reason => 'Toma de control desde Ares';

  @override
  String ng_bots_take_over_failed(String error) {
    return 'Error al tomar el control: $error';
  }

  @override
  String ng_bots_force_hand_back_title(String bot) {
    return '¿Devolver la pantalla de $bot al bot?';
  }

  @override
  String get ng_bots_force_hand_back_body =>
      'Una persona tiene el control de esta pantalla. Si todavía la está usando, perderá el control.';

  @override
  String get ng_bots_hand_back => 'Devolver el control';

  @override
  String get ng_bots_hand_back_failed => 'Error al devolver el control';

  @override
  String get ng_bots_adopt_title => '¿Adoptar la nueva imagen de sandbox?';

  @override
  String ng_bots_adopt_body(String bot, String current, String target) {
    return '$bot pasa de $current a $target. Su contenedor se recreará en la próxima llamada al terminal; se perderá todo lo que solo esté en el contenedor actual.';
  }

  @override
  String get ng_bots_adopt_image => 'Adoptar imagen';

  @override
  String get ng_bots_image_switch_failed => 'Error al cambiar la imagen';

  @override
  String get ng_bots_keep_refused => 'Conservación rechazada';

  @override
  String ng_bots_chat_open_failed(String error) {
    return 'No se pudo abrir Bot Chat: $error';
  }

  @override
  String ng_bots_title(String connection) {
    return 'Bots · $connection';
  }

  @override
  String get ng_bots_protocol_tooltip =>
      'El gateway inyecta por sí mismo el protocolo de mensajería entre compañeros — no se envía ningún protocolo SOUL.md adicional.';

  @override
  String ng_bots_unavailable(String reason) {
    return 'Bots no disponibles ($reason)';
  }

  @override
  String get ng_bots_account_changed =>
      'La cuenta cambió. Vuelve a conectarte o actualiza.';

  @override
  String get ng_bots_try_refresh =>
      'Prueba a actualizar. Si el problema persiste, es posible que el gateway no admita bots.';

  @override
  String get ng_bots_search => 'Buscar bots';

  @override
  String get ng_bots_none_found => 'No se encontraron bots.';

  @override
  String get ng_bots_no_model => 'sin modelo';

  @override
  String ng_bots_skill_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count habilidades',
      one: '1 habilidad',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_bot_chat => 'Bot Chat';

  @override
  String ng_bots_install_id(String id, String protocol) {
    return 'El gateway informa el ID de instalación $id · bot_mode_protocol: $protocol';
  }

  @override
  String get ng_bots_protocol_note =>
      'El gateway inyecta el protocolo de mensajería entre compañeros cuando bot_mode_protocol está definido. Identificador: default→hermes; si no, el nombre del perfil.';

  @override
  String get ng_bots_no_rooms => 'Aún no hay salas. Crea una desde tu equipo.';

  @override
  String ng_bots_member_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miembros',
      one: '1 miembro',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_room_disbanded => 'disuelta';

  @override
  String get ng_bots_room_adopted => 'adoptada';

  @override
  String get ng_bots_rooms_gateway => 'Salas del gateway';

  @override
  String get ng_bots_rooms_desktop => 'Salas dirigidas por el Desktop';

  @override
  String ng_bots_rooms_gateway_body(String methods) {
    return 'Las salas pertenecen al gateway. Métodos: $methods.';
  }

  @override
  String get ng_bots_rooms_no_seat =>
      'Es posible que este gateway no pueda alojar salas (se requiere un proceso persistente).';

  @override
  String get ng_bots_rooms_fallback =>
      'Alternativa clásica: el Desktop dirige las rondas del grupo (no se crean aquí).';

  @override
  String get ng_bots_create_room => 'Crear sala';

  @override
  String get ng_bots_refresh_rooms => 'Actualizar salas';

  @override
  String get ng_bots_room_created => 'Sala creada';

  @override
  String ng_bots_room_refused(String reason) {
    return 'Creación de la sala rechazada ($reason)';
  }

  @override
  String ng_bots_room_failed(String error) {
    return 'Error al crear la sala: $error';
  }

  @override
  String get ng_bots_bot => 'Bot';

  @override
  String get ng_bots_screen_unavailable =>
      'Estado de la pantalla no disponible';

  @override
  String get ng_bots_screen_unavailable_body =>
      'Inicia la pantalla del bot para ver su miniatura o toma el control para usarla tú.';

  @override
  String get ng_bots_take_over_note =>
      'Tomar el control abre la pantalla en vivo y te da el control. El control vuelve al bot cuando cierras la pantalla en vivo, sales de esta página o pasas la app a segundo plano.';

  @override
  String get ng_bots_not_installed => 'No instalado';

  @override
  String get ng_bots_unsupported_host => 'Host no compatible';

  @override
  String ng_bots_pid(String pid) {
    return 'pid $pid';
  }

  @override
  String ng_bots_missing(String items) {
    return 'falta: $items';
  }

  @override
  String ng_bots_blocked(String reason) {
    return 'bloqueado: $reason';
  }

  @override
  String get ng_bots_no_switch =>
      'No hay ningún cambio de imagen de sandbox pendiente.';

  @override
  String ng_bots_switch_image(String current, String target) {
    return 'cambio de imagen: $current → $target';
  }

  @override
  String get ng_bots_bot_in_control => 'el bot tiene el control';

  @override
  String get ng_bots_person_in_control => 'una persona tiene el control';

  @override
  String get ng_bots_installing =>
      'Instalando Bot Desktop en el host del gateway…';

  @override
  String get ng_bots_install_unfinished => 'La instalación no terminó';

  @override
  String get ng_bots_install => 'Instalar';

  @override
  String get ng_bots_start => 'Iniciar';

  @override
  String get ng_bots_take_over => 'Tomar el control';

  @override
  String get ng_bots_keep_image => 'Mantener imagen actual';

  @override
  String ng_bots_missing_pieces(String items) {
    return 'El gateway informa de componentes que faltan: $items';
  }

  @override
  String get ng_bots_install_missing => 'Instalar componentes que faltan';

  @override
  String get ng_bots_thumbnail_unavailable => 'Miniatura no disponible';

  @override
  String get ng_bots_thumbnail_title => 'Miniatura de la pantalla (en vivo)';

  @override
  String get ng_bots_thumbnail_suppressed =>
      'Miniatura oculta mientras una persona controla la pantalla.';

  @override
  String get ng_bots_thumbnail_pending =>
      'La miniatura aún no está disponible.';

  @override
  String ng_bots_routines_of(String bot) {
    return '$bot · rutinas';
  }

  @override
  String get ng_bots_add_routine => 'Agregar rutina';

  @override
  String get ng_bots_no_routines => 'No hay rutinas para este bot.';

  @override
  String get ng_bots_routines_note =>
      'Las rutinas son tareas etiquetadas con [bot:<name>] que pertenecen al almacén del perfil del bot. Las rutinas delegadas heredadas se pausan forzosamente al cargarse.';

  @override
  String ng_bots_routine_last(String status) {
    return 'última: $status';
  }

  @override
  String ng_bots_routine_next(String time) {
    return 'próxima: $time';
  }

  @override
  String ng_bots_routine_error(String error) {
    return 'error: $error';
  }

  @override
  String ng_bots_remove_routine_title(String routine) {
    return '¿Eliminar la rutina $routine?';
  }

  @override
  String ng_bots_remove_routine_body(String bot) {
    return 'La rutina se eliminará de la programación de $bot. Esta acción no se puede deshacer.';
  }

  @override
  String ng_bots_routine_action_failed(String action, String error) {
    return 'Error en la acción $action: $error';
  }

  @override
  String get ng_bots_not_connected => 'No conectado.';

  @override
  String ng_bots_add_failed(String error) {
    return 'Error al agregar: $error';
  }

  @override
  String get ng_bots_routine_added => 'Rutina agregada';

  @override
  String get ng_bots_routine_enabled => 'activada';

  @override
  String get ng_bots_routine_paused => 'en pausa';

  @override
  String ng_bots_path(String path) {
    return 'Ruta: $path';
  }

  @override
  String get ng_bots_chat_present => 'Bot Chat presente';

  @override
  String get ng_bots_chat_missing => 'Falta Bot Chat';

  @override
  String ng_bots_last_session(String preview) {
    return 'Última sesión: $preview';
  }

  @override
  String get ng_bots_open_chat => 'Abrir Bot Chat';

  @override
  String get ng_bots_desktop => 'Bot Desktop';

  @override
  String get ng_bots_room_name => 'Nombre de la sala';

  @override
  String get ng_bots_select_member => 'Selecciona al menos un miembro.';

  @override
  String get ng_bots_sudo_title => 'Contraseña de administrador';

  @override
  String ng_bots_sudo_body(String bot) {
    return 'Instalar Bot Desktop para $bot requiere sudo en el host del gateway. La contraseña solo se envía a ese gateway, para esta instalación, y no se guarda.';
  }

  @override
  String get ng_bots_sudo_password => 'Contraseña de sudo';

  @override
  String get ng_bots_new_routine => 'Nueva rutina';

  @override
  String get ng_bots_routine_title => 'Título';

  @override
  String get ng_bots_routine_instruction => 'Instrucción';

  @override
  String get ng_bots_cron => 'Expresión cron';

  @override
  String get ng_bots_interval => 'Intervalo';

  @override
  String get ng_bots_cron_help =>
      '0 9 * * * se ejecuta todos los días a las 09:00';

  @override
  String get ng_bots_every => 'Cada';

  @override
  String get ng_bots_unit_minutes => 'minutos';

  @override
  String get ng_bots_unit_hours => 'horas';

  @override
  String get ng_bots_unit_days => 'días';

  @override
  String get ng_bots_stop_after => 'Detener tras (ejecuciones)';

  @override
  String get ng_bots_stop_after_help =>
      'Déjalo vacío para que siga ejecutándose';

  @override
  String get ng_bots_send_results => 'Enviar resultados a';

  @override
  String get ng_bots_run_history => 'Solo historial de ejecuciones';

  @override
  String get ng_bots_continuity => 'Continuar desde la ejecución anterior';

  @override
  String get ng_bots_account_changed_refresh =>
      'La cuenta cambió. Actualiza antes de continuar.';

  @override
  String ng_bots_room_load_failed(String error) {
    return 'No se pudo cargar la sala: $error';
  }

  @override
  String ng_bots_send_failed(String error) {
    return 'Error al enviar: $error';
  }

  @override
  String ng_bots_stop_failed(String error) {
    return 'Error al detener: $error';
  }

  @override
  String get ng_bots_stop_room => 'Detener sala';

  @override
  String get ng_bots_send_message => 'Enviar un mensaje';

  @override
  String get ng_bots_room_hint =>
      'Escribe a la sala (menciona miembros con @handle)';

  @override
  String get ng_bots_history => 'Historial';

  @override
  String ng_bots_revision(String revision) {
    return 'revisión $revision';
  }

  @override
  String ng_bots_last_error(String error) {
    return 'último error: $error';
  }

  @override
  String get ng_bots_members => 'Miembros';

  @override
  String get ng_bots_room_context => 'Contexto de la sala';

  @override
  String ng_bots_purpose(String purpose) {
    return 'Propósito: $purpose';
  }

  @override
  String ng_bots_notes(String notes) {
    return 'Notas: $notes';
  }

  @override
  String ng_bots_routing(String routing) {
    return 'Enrutamiento: $routing';
  }

  @override
  String ng_bots_lead(String member) {
    return 'líder $member';
  }

  @override
  String get ng_bots_viewer_you_control =>
      'Controlas esta pantalla. El bot espera hasta que le devuelvas el control.';

  @override
  String get ng_bots_viewer_handed_back => 'El control ha vuelto al bot.';

  @override
  String get ng_bots_viewer_background =>
      'El control volvió al bot porque la app dejó de estar en primer plano.';

  @override
  String get ng_bots_viewer_taken =>
      'Otra persona tomó el control de esta pantalla.';

  @override
  String get ng_bots_viewer_lost =>
      'Se perdió la vista en vivo, así que el control volvió al bot.';

  @override
  String ng_bots_viewer_title(String bot) {
    return 'Bot Desktop · $bot';
  }

  @override
  String get ng_bots_viewer_type_hint => 'Escribe en la pantalla del bot';

  @override
  String get ng_bots_viewer_type => 'Escribir';

  @override
  String get ng_bots_viewer_enter => 'Intro';

  @override
  String get ng_bots_viewer_backspace => 'Retroceso';

  @override
  String get ng_more_kanban => 'Kanban';

  @override
  String get ng_more_kanban_subtitle =>
      'Tableros, dependencias de tareas, asignación de workers y registros';

  @override
  String get ng_more_bots => 'Bots';

  @override
  String get ng_more_bots_subtitle => 'Equipo, salas, rutinas y Bot Desktop';

  @override
  String get ng_slash_kanban => 'Abrir el tablero Kanban';

  @override
  String get ng_slash_bots => 'Abrir tus bots';

  @override
  String ng_board_card_count(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tarjetas',
      one: '1 tarjeta',
    );
    return '$_temp0';
  }

  @override
  String ng_board_event_toast(String task, String event) {
    return 'Kanban $task: $event';
  }

  @override
  String get ng_board_task => 'tarea';

  @override
  String ng_board_refused_http(String status) {
    return 'Acción rechazada (HTTP $status).';
  }

  @override
  String get ng_board_err_unsupported =>
      'El plugin Kanban no está activado en este gateway.';

  @override
  String get ng_board_err_denied =>
      'Se requiere inicio de sesión o permiso en este gateway.';

  @override
  String get ng_board_err_stale =>
      'El propietario del gateway cambió. Actualiza antes de continuar.';

  @override
  String get ng_board_err_insecure =>
      'Se requiere HTTPS (o loopback) para las operaciones del espacio de trabajo de Kanban.';

  @override
  String get ng_board_err_unreachable =>
      'No se pudo conectar con el servicio Kanban de este gateway.';

  @override
  String get ng_board_err_failed =>
      'La operación falló. Actualiza y vuelve a intentarlo.';

  @override
  String ng_board_block_title(String task) {
    return 'Bloquear $task';
  }

  @override
  String get ng_board_block_reason => 'Motivo del bloqueo';

  @override
  String get ng_board_block_hint => '¿Qué bloquea esta tarjeta?';

  @override
  String ng_board_review_title(String task) {
    return 'Solicitar revisión de $task';
  }

  @override
  String get ng_board_review_summary => 'Resumen de la revisión';

  @override
  String get ng_board_review_hint => '¿Qué se implementó y verificó?';

  @override
  String ng_board_move_title(String cards, String column) {
    return '¿Mover $cards a $column?';
  }

  @override
  String ng_board_move_body(String board) {
    return 'Todas las tarjetas seleccionadas de $board cambian de columna. Una tarjeta en ejecución se detiene.';
  }

  @override
  String get ng_board_move => 'Mover';

  @override
  String ng_board_moved(String column) {
    return 'Tarjetas movidas a $column';
  }

  @override
  String ng_board_unassign_title(String cards) {
    return '¿Quitar la asignación de $cards?';
  }

  @override
  String ng_board_assign_title(String cards, String profile) {
    return '¿Asignar $cards a @$profile?';
  }

  @override
  String get ng_board_assign_body =>
      'Las tarjetas en ejecución se recuperan primero: sus workers se detienen.';

  @override
  String get ng_board_unassign => 'Quitar asignación';

  @override
  String get ng_board_assign => 'Asignar';

  @override
  String get ng_board_unassigned_done =>
      'Se quitó la asignación de las tarjetas seleccionadas';

  @override
  String ng_board_assigned_done(String profile) {
    return '@$profile asignado';
  }

  @override
  String ng_board_archive_title(String cards) {
    return '¿Archivar $cards?';
  }

  @override
  String ng_board_archive_body(String board) {
    return 'Las tarjetas archivadas salen de $board. Activa Archivadas para volver a verlas.';
  }

  @override
  String get ng_board_archived_done => 'Tarjetas seleccionadas archivadas';

  @override
  String ng_board_delete_title(String cards) {
    return '¿Eliminar $cards?';
  }

  @override
  String ng_board_delete_body(String board) {
    return 'Esto elimina permanentemente las tarjetas seleccionadas de $board.';
  }

  @override
  String ng_board_deleted(String cards) {
    return 'Eliminación completada: $cards.';
  }

  @override
  String ng_board_partial_failure(String failed, String total, String reason) {
    return '$failed de $total fallaron: $reason';
  }

  @override
  String get ng_board_refused => 'rechazado';

  @override
  String ng_board_dispatched(
    String spawned,
    String promoted,
    String reclaimed,
  ) {
    return 'Despacho: $spawned iniciados, $promoted promovidos, $reclaimed recuperados.';
  }

  @override
  String ng_board_board_archived(String board) {
    return 'Tablero $board archivado';
  }

  @override
  String ng_board_board_archived_to(String path) {
    return 'Archivado en $path';
  }

  @override
  String ng_board_exported(String board, String archive) {
    return '$board exportado a $archive';
  }

  @override
  String ng_board_imported(String board, String warnings) {
    return 'Tablero $board importado$warnings';
  }

  @override
  String ng_board_created(String task) {
    return 'Tarea $task creada';
  }

  @override
  String get ng_board_orchestration_saved => 'Orquestación de Kanban guardada';

  @override
  String get ng_board_auto_describe_unavailable =>
      'Descripción automática no disponible';

  @override
  String ng_board_description_updated(String profile) {
    return 'Descripción de @$profile actualizada';
  }

  @override
  String ng_board_title(String board) {
    return 'Kanban · $board';
  }

  @override
  String ng_board_active(String count) {
    return 'Activas: $count';
  }

  @override
  String get ng_board_dispatch => 'Despachar ahora las tareas listas';

  @override
  String get ng_board_orchestration => 'Orquestación y workers';

  @override
  String get ng_board_new_task => 'Nueva tarea';

  @override
  String get ng_board_enable_plugin =>
      'Activa el plugin \"kanban\" incluido en Capacidades → Plugins de este gateway para activar su enrutador de tableros.';

  @override
  String get ng_board_filter => 'Filtrar tareas…';

  @override
  String get ng_board_all_assignees => 'Todos los asignados';

  @override
  String get ng_board_unassigned => 'Sin asignar';

  @override
  String get ng_board_running_by_profile => 'En ejecución por perfil';

  @override
  String get ng_board_select => 'Seleccionar';

  @override
  String ng_board_selected_chip(String count) {
    return 'Seleccionadas ($count)';
  }

  @override
  String get ng_board_locked_column =>
      'Columna gestionada — arrastrar y soltar desactivado';

  @override
  String ng_board_add_to(String column) {
    return 'Agregar a $column';
  }

  @override
  String ng_board_collapse(String column) {
    return 'Contraer $column';
  }

  @override
  String ng_board_column_empty(String column) {
    return 'No hay tareas en $column';
  }

  @override
  String get ng_board_drop_here => 'Suelta o + tarea';

  @override
  String get ng_board_card_actions => 'Acciones de la tarjeta';

  @override
  String get ng_board_open_details => 'Abrir detalles';

  @override
  String get ng_board_select_card => 'Seleccionar tarjeta';

  @override
  String ng_board_move_to(String column) {
    return 'Mover a $column';
  }

  @override
  String get ng_board_parked => 'En espera';

  @override
  String ng_board_blocked_by(String count) {
    return 'Bloqueada por $count';
  }

  @override
  String get ng_board_goal_loop => 'Bucle de objetivo';

  @override
  String ng_board_selected(String count) {
    return 'Seleccionadas: $count';
  }

  @override
  String get ng_board_move_menu => 'Mover…';

  @override
  String get ng_board_assign_menu => 'Asignar…';

  @override
  String get ng_board_new_board_title => 'Nuevo tablero Kanban';

  @override
  String get ng_board_slug => 'Slug (minúsculas, p. ej., release-v5)';

  @override
  String get ng_board_display_name => 'Nombre visible';

  @override
  String get ng_board_linked_project => 'Proyecto vinculado (opcional)';

  @override
  String get ng_board_none => 'Ninguno';

  @override
  String get ng_board_default_workdir =>
      'Directorio de trabajo predeterminado en el host (opcional)';

  @override
  String get ng_board_import_title => 'Importar archivo de tablero';

  @override
  String get ng_board_import_path => 'Ruta del archivo .tar.gz en el host';

  @override
  String get ng_board_import => 'Importar';

  @override
  String ng_board_edit_board(String board) {
    return 'Editar $board';
  }

  @override
  String get ng_board_name => 'Nombre';

  @override
  String get ng_board_description => 'Descripción';

  @override
  String get ng_board_workdir_clear =>
      'Directorio de trabajo predeterminado (vacío para borrar)';

  @override
  String get ng_board_boards => 'Tableros Kanban';

  @override
  String get ng_board_new_board => 'Nuevo tablero';

  @override
  String get ng_board_search_boards => 'Buscar tableros…';

  @override
  String get ng_board_unpin => 'Desanclar pestaña';

  @override
  String get ng_board_pin => 'Anclar pestaña';

  @override
  String ng_board_archive_board_title(String board) {
    return '¿Archivar el tablero $board?';
  }

  @override
  String ng_board_archive_board_body(String cards) {
    return 'El tablero y sus tarjetas ($cards) salen de la lista de tableros. El gateway guarda un archivo en su host.';
  }

  @override
  String get ng_board_edit_metadata => 'Editar metadatos';

  @override
  String get ng_board_export => 'Exportar .tar.gz en el host';

  @override
  String get ng_board_move_pin_left =>
      'Mover la pestaña anclada a la izquierda';

  @override
  String get ng_board_archive_board => 'Archivar tablero';

  @override
  String get ng_board_new_task_title => 'Nueva tarea Kanban';

  @override
  String get ng_board_title_required => 'Título *';

  @override
  String get ng_board_spec => 'Especificación y criterios de aceptación';

  @override
  String get ng_board_estimate => 'Estimación';

  @override
  String ng_board_estimate_draft(String complexity, String tokens) {
    return 'Complejidad $complexity (~$tokens tok — solo estimación de tokens, no un coste en dólares)';
  }

  @override
  String get ng_board_estimate_unavailable => 'Estimación no disponible';

  @override
  String get ng_board_initial_column => 'Columna inicial';

  @override
  String get ng_board_worker_assignee => 'Worker asignado';

  @override
  String get ng_board_parked_unassigned => 'En espera (sin asignar)';

  @override
  String get ng_board_priority => 'Prioridad';

  @override
  String get ng_board_workspace => 'Espacio de trabajo';

  @override
  String get ng_board_scratch => 'Temporal';

  @override
  String get ng_board_worktree => 'Worktree de Git';

  @override
  String get ng_board_shared_dir => 'Directorio compartido';

  @override
  String get ng_board_workspace_path =>
      'Ruta del espacio de trabajo en el host';

  @override
  String get ng_board_parent => 'Dependencia principal (opcional)';

  @override
  String get ng_board_skills =>
      'Habilidades fijadas (separadas por comas, opcional)';

  @override
  String get ng_board_provider_override => 'Forzar proveedor';

  @override
  String get ng_board_model_override => 'Forzar modelo';

  @override
  String get ng_board_reasoning => 'Esfuerzo de razonamiento';

  @override
  String get ng_board_profile_default => 'Predeterminado del perfil';

  @override
  String get ng_board_xhigh => 'Muy alto';

  @override
  String get ng_board_goal_mode => 'Modo de bucle de objetivo';

  @override
  String get ng_board_goal_turns =>
      'Turnos máx. del objetivo (vacío = predeterminado)';

  @override
  String get ng_board_create_task => 'Crear tarea';

  @override
  String get ng_board_orchestration_title =>
      'Orquestación y perfiles de workers';

  @override
  String ng_board_orchestrator(String profile) {
    return 'Perfil del orquestador (resuelto: $profile)';
  }

  @override
  String get ng_board_inherit_default => 'Heredar el predeterminado activo';

  @override
  String ng_board_default_assignee(String profile) {
    return 'Asignado predeterminado (resuelto: $profile)';
  }

  @override
  String get ng_board_auto_decompose =>
      'Descomponer automáticamente las tarjetas de triaje';

  @override
  String get ng_board_auto_decompose_help =>
      'Usa el modelo kanban_decomposer configurado en las tareas de triaje';

  @override
  String get ng_board_save_orchestration => 'Guardar orquestación';

  @override
  String get ng_board_worker_descriptions =>
      'Descripciones de especialización de los workers';

  @override
  String ng_board_worker_label(String profile, String model, String skills) {
    return '@$profile ($model · $skills)';
  }

  @override
  String get ng_board_default_model => 'modelo predeterminado';

  @override
  String get ng_board_save_description => 'Guardar descripción';

  @override
  String get ng_board_auto_describe =>
      'Describir automáticamente a partir de habilidades y personalidad';

  @override
  String get ng_board_manual_block => 'Bloqueo manual del operador';

  @override
  String get ng_board_requested_review => 'Revisión solicitada';

  @override
  String ng_board_requeue_title(String task) {
    return '¿Devolver $task a la cola?';
  }

  @override
  String get ng_board_requeue_body =>
      'Se detiene el worker que ejecuta esta tarjeta y la tarjeta vuelve a la cola.';

  @override
  String get ng_board_requeue => 'Devolver a la cola';

  @override
  String ng_board_reassign_title(String task, String profile) {
    return '¿Reasignar $task a @$profile?';
  }

  @override
  String get ng_board_reassign_body =>
      'Esta tarjeta está en ejecución: primero se detiene su worker.';

  @override
  String get ng_board_reassign => 'Reasignar';

  @override
  String ng_board_saved_task(String task) {
    return 'Tarea $task guardada';
  }

  @override
  String get ng_board_commented_requeued =>
      'Comentario publicado y tarea devuelta a la cola';

  @override
  String get ng_board_commented => 'Comentario publicado';

  @override
  String ng_board_requeued(String task) {
    return 'Tarea $task devuelta a la cola';
  }

  @override
  String get ng_board_decompose_failed => 'Error al descomponer.';

  @override
  String ng_board_decompose_failed_reason(String reason) {
    return 'Error al descomponer: $reason';
  }

  @override
  String ng_board_decomposed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Descompuesta en $count subtareas',
      one: 'Descompuesta en 1 subtarea',
    );
    return '$_temp0';
  }

  @override
  String get ng_board_no_children => 'No se creó ninguna subtarea.';

  @override
  String ng_board_no_children_reason(String reason) {
    return 'No se creó ninguna subtarea: $reason';
  }

  @override
  String ng_board_uploaded(String file) {
    return 'Se subió $file';
  }

  @override
  String ng_board_linked_parent(String task) {
    return 'Tarea principal $task vinculada';
  }

  @override
  String ng_board_unlinked_parent(String task) {
    return 'Vínculo con la tarea principal $task eliminado';
  }

  @override
  String get ng_board_task_load_failed => 'No se pudo cargar la tarea';

  @override
  String get ng_board_refresh_task => 'Actualizar tarea';

  @override
  String get ng_board_tab_overview => 'Resumen';

  @override
  String get ng_board_tab_comments => 'Comentarios y vínculos';

  @override
  String get ng_board_tab_runs => 'Ejecuciones y registro';

  @override
  String get ng_board_tab_events => 'Eventos';

  @override
  String get ng_board_decompose => 'Descomponer';

  @override
  String get ng_board_attach => 'Adjuntar archivo';

  @override
  String ng_board_estimate_task(
    String complexity,
    String tokens,
    String rationale,
  ) {
    return 'Estimación: $complexity · ~$tokens tokens ($rationale) — no es un coste en dólares.';
  }

  @override
  String get ng_board_no_rationale => 'sin justificación';

  @override
  String get ng_board_status => 'Estado';

  @override
  String get ng_board_assignee => 'Asignado a';

  @override
  String get ng_board_title_label => 'Título';

  @override
  String get ng_board_body => 'Cuerpo / especificación';

  @override
  String get ng_board_save_changes => 'Guardar cambios';

  @override
  String get ng_board_clear_model => 'Quitar el modelo forzado';

  @override
  String ng_board_blocked_reason(String reason) {
    return 'Motivo del bloqueo: $reason';
  }

  @override
  String ng_board_result(String result) {
    return 'Resultado: $result';
  }

  @override
  String ng_board_parents(String count) {
    return 'Bloqueada por (principales · $count)';
  }

  @override
  String get ng_board_add_parent => '+ Agregar principal';

  @override
  String ng_board_children(String count) {
    return 'Bloquea a (dependientes · $count)';
  }

  @override
  String ng_board_attachments(String count) {
    return 'Adjuntos ($count)';
  }

  @override
  String get ng_board_worker => 'worker';

  @override
  String ng_board_comments(String count) {
    return 'Comentarios ($count)';
  }

  @override
  String get ng_board_comment_hint =>
      'Agregar comentario / indicaciones para el worker';

  @override
  String get ng_board_post_comment => 'Publicar comentario';

  @override
  String get ng_board_comment_requeue => 'Comentar y devolver a la cola';

  @override
  String ng_board_runs(String count) {
    return 'Ejecuciones ($count)';
  }

  @override
  String get ng_board_no_runs =>
      'Aún no hay ejecuciones de workers registradas.';

  @override
  String ng_board_run_error(String error) {
    return 'Error: $error';
  }

  @override
  String ng_board_log_tail_truncated(String bytes) {
    return 'Final del registro del worker ($bytes B, truncado)';
  }

  @override
  String ng_board_log_tail(String bytes) {
    return 'Final del registro del worker ($bytes B)';
  }

  @override
  String get ng_board_refresh_log => 'Actualizar registro';

  @override
  String get ng_board_no_log => 'No hay salida en el registro del worker.';

  @override
  String get ng_board_no_events => 'No hay eventos registrados.';

  @override
  String get ng_bots_room_unknown => 'desconocido';

  @override
  String get ng_bots_room_blocked => 'bloqueado';

  @override
  String get ng_bots_room_working => 'trabajando';

  @override
  String get ng_bots_room_running => 'en marcha';

  @override
  String get ng_bots_room_idle => 'inactivo';

  @override
  String ng_board_run_title(String id, String profile, String outcome) {
    return 'Ejecución n.º $id · @$profile · $outcome';
  }

  @override
  String get ng_bots_new_bot => 'Nuevo bot';

  @override
  String get ng_bots_new_bot_hint =>
      'Un compañero con nombre, con su propia memoria, habilidades y chat. Puede escribir a tus otros agentes.';

  @override
  String get ng_bots_field_name => 'Nombre';

  @override
  String get ng_bots_field_title => 'Título';

  @override
  String get ng_bots_field_description => 'Descripción';

  @override
  String get ng_bots_description_hint => '¿En qué debería ayudar este bot?';

  @override
  String get ng_bots_name_invalid =>
      'Usa minúsculas, números, guiones o guiones bajos, empezando por una letra o un número (64 caracteres como máximo).';

  @override
  String ng_bots_name_taken(String name) {
    return 'Ya existe un agente llamado «$name».';
  }

  @override
  String ng_bots_profile_id(String id) {
    return 'ID de perfil: $id';
  }

  @override
  String get ng_bots_advanced =>
      'Avanzado — modelo, habilidades, conjuntos de herramientas, SOUL.md';

  @override
  String get ng_bots_clone_from => 'Clonar del perfil';

  @override
  String get ng_bots_clone_main => 'Perfil principal (default)';

  @override
  String get ng_bots_fresh_profile => 'Perfil nuevo (habilidades incluidas)';

  @override
  String get ng_bots_create_empty => 'Crear vacío (sin habilidades incluidas)';

  @override
  String get ng_bots_share_keys =>
      'Compartir claves y cuentas con el perfil principal';

  @override
  String get ng_bots_provider => 'Proveedor';

  @override
  String get ng_bots_model => 'Modelo';

  @override
  String get ng_bots_model_pair => 'Indica un proveedor y un modelo.';

  @override
  String get ng_bots_soul =>
      'SOUL.md (opcional — sustituye la persona generada)';

  @override
  String get ng_bots_soul_edit => 'SOUL.md';

  @override
  String get ng_bots_creating => 'Creando…';

  @override
  String get ng_bots_create_bot => 'Crear bot';

  @override
  String ng_bots_created(String name) {
    return 'Bot «$name» creado';
  }

  @override
  String get ng_bots_look_failed =>
      'Su aspecto no se guardó en la pasarela; configúralo en Editar perfil.';

  @override
  String ng_bots_request_failed(String reason) {
    return 'La pasarela no lo aceptó ($reason).';
  }

  @override
  String get ng_bots_avatar_shape => 'Forma';

  @override
  String ng_bots_avatar_shape_n(int n) {
    return 'Forma $n';
  }

  @override
  String get ng_bots_avatar_colour => 'Color';

  @override
  String ng_bots_avatar_colour_n(int n) {
    return 'Color $n';
  }

  @override
  String get ng_bots_avatar_match_name => 'Según el nombre';

  @override
  String get ng_bots_avatar_upload => 'Elegir una imagen…';

  @override
  String get ng_bots_avatar_remove => 'Quitar imagen — usar forma';

  @override
  String get ng_bots_avatar_too_large =>
      'Imagen demasiado grande (máx. 15 MB).';

  @override
  String get ng_bots_avatar_unreadable => 'No se pudo leer esa imagen.';

  @override
  String get ng_bots_edit_profile => 'Editar perfil';

  @override
  String ng_bots_edit_description(String name, String profile) {
    return 'Aspecto y función de $name ($profile).';
  }

  @override
  String ng_bots_advanced_failed(String reason) {
    return 'No se pudo cargar la configuración del perfil ($reason).';
  }

  @override
  String get ng_bots_skills => 'Habilidades';

  @override
  String get ng_bots_toolsets => 'Conjuntos de herramientas';

  @override
  String get ng_bots_toolsets_hint =>
      'Dejar todos (o ninguno) marcados mantiene el comportamiento predeterminado.';

  @override
  String get ng_bots_mcp_servers => 'Servidores MCP';

  @override
  String get ng_bots_saving => 'Guardando…';

  @override
  String get ng_bots_confirm_changes_title => '¿Guardar estos cambios?';

  @override
  String get ng_bots_change_remove_image => 'Quitar la imagen del bot';

  @override
  String get ng_bots_change_soul => 'Sustituir su SOUL.md';

  @override
  String ng_bots_change_turn_off(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Desactivar $count habilidades, conjuntos o servidores MCP',
      one: 'Desactivar 1 habilidad, conjunto o servidor MCP',
    );
    return '$_temp0';
  }

  @override
  String ng_bots_updated(String name) {
    return '$name actualizado';
  }

  @override
  String ng_bots_sections_failed(String sections) {
    return 'Algunas secciones fallaron: $sections';
  }

  @override
  String get ng_bots_model_confirm_title => '¿Cambiar el modelo?';

  @override
  String get ng_bots_model_confirm_ok => 'Cambiar';

  @override
  String get ng_bots_model_not_switched => 'No se cambió el modelo.';

  @override
  String get ng_bots_section_new => 'Nueva sección';

  @override
  String get ng_bots_section_new_ellipsis => 'Nueva sección…';

  @override
  String get ng_bots_section_name => 'Nombre de la sección';

  @override
  String get ng_bots_section_name_hint => 'p. ej., Clientes';

  @override
  String get ng_bots_section_create => 'Crear';

  @override
  String get ng_bots_section_rename => 'Cambiar nombre de la sección';

  @override
  String get ng_bots_section_delete => 'Eliminar sección';

  @override
  String get ng_bots_section_move_up => 'Subir';

  @override
  String get ng_bots_section_move_down => 'Bajar';

  @override
  String get ng_bots_section_unassigned => 'Sin asignar';

  @override
  String ng_bots_section_options(String name) {
    return 'Opciones de la sección $name';
  }

  @override
  String get ng_bots_section_empty =>
      'Aún no hay bots aquí. Usa Mover a sección en un bot.';

  @override
  String get ng_bots_section_move_to => 'Mover a sección';

  @override
  String get ng_bots_section_remove => 'Quitar de la sección';

  @override
  String ng_bots_section_deleted(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se eliminó «$name»: $count bots pasaron a Sin asignar',
      one: 'Se eliminó «$name»: 1 bot pasó a Sin asignar',
      zero: 'Se eliminó «$name»',
    );
    return '$_temp0';
  }

  @override
  String get ng_bots_undo => 'Deshacer';

  @override
  String ng_bots_section_move_failed(String reason) {
    return 'No se pudo mover el bot ($reason).';
  }

  @override
  String ng_bots_bot_actions(String name) {
    return 'Acciones de $name';
  }

  @override
  String ng_bots_section_toggle(String name) {
    return 'Mostrar u ocultar $name';
  }

  @override
  String
  get release_core_transcript_reader_this_passage_is_no_longer_in_the_loaded =>
      'Este pasaje ya no está en la ventana cargada.';

  @override
  String get release_core_transcript_reader_loaded_prompts =>
      'Prompts cargados';

  @override
  String get release_core_transcript_reader_jump_to_latest =>
      'Ir a lo más reciente';

  @override
  String get release_core_transcript_reader_no_prompts_loaded =>
      'No hay prompts cargados';

  @override
  String get release_core_transcript_reader_find_in_loaded_messages =>
      'Buscar en los mensajes cargados';

  @override
  String get release_core_transcript_reader_previous_match =>
      'Coincidencia anterior';

  @override
  String get release_core_transcript_reader_next_match =>
      'Coincidencia siguiente';

  @override
  String get release_core_transcript_reader_prompt_timeline =>
      'Cronología de prompts';

  @override
  String get release_core_transcript_reader_close_find => 'Cerrar búsqueda';

  @override
  String get release_core_session_organisation_organise_chats =>
      'Organizar chats';

  @override
  String get release_core_session_organisation_show_model_and_usage =>
      'Mostrar modelo y uso';

  @override
  String
  get release_core_session_files_view_connection_changed_reopen_files_on_the_new_connection =>
      'La conexión ha cambiado. Vuelve a abrir los archivos en la nueva conexión.';

  @override
  String
  get release_core_session_files_view_the_connection_or_session_changed_reopen_this_pane =>
      'La conexión o la sesión ha cambiado. Vuelve a abrir este panel.';

  @override
  String
  get release_core_session_files_view_no_verified_host_working_directory_for_this_session =>
      'No hay un directorio de trabajo verificado en el host para esta sesión.';

  @override
  String
  get release_core_session_files_view_the_gateway_denied_this_operation =>
      'La pasarela ha denegado esta operación.';

  @override
  String
  get release_core_session_files_view_this_gateway_does_not_support_this_operation =>
      'Esta pasarela no admite esta operación.';

  @override
  String
  get release_core_session_files_view_the_file_owner_or_working_directory_changed_reload =>
      'El archivo, el propietario o el directorio de trabajo ha cambiado. Vuelve a cargar y revisa.';

  @override
  String
  get release_core_session_files_view_the_gateway_returned_an_unsafe_path_or_invalid =>
      'La pasarela ha devuelto una ruta insegura o una respuesta de archivo no válida.';

  @override
  String
  get release_core_session_files_view_workspace_access_requires_a_secure_gateway_connection =>
      'El acceso al espacio de trabajo requiere una conexión segura con la pasarela.';

  @override
  String
  get release_core_session_files_view_gateway_unavailable_refresh_to_check_the_current_state =>
      'Pasarela no disponible. Actualiza para comprobar el estado actual.';

  @override
  String
  get release_core_session_files_view_gateway_operation_could_not_be_confirmed =>
      'No se pudo confirmar la operación de la pasarela.';

  @override
  String get release_core_session_files_view_git_status_unavailable =>
      'Estado de Git no disponible.';

  @override
  String
  get release_core_session_files_view_change_this_chat_s_working_directory =>
      '¿Cambiar el directorio de trabajo de este chat?';

  @override
  String get release_core_session_files_view_absolute_gateway_directory =>
      'Ruta absoluta del directorio en la pasarela';

  @override
  String get release_core_session_files_view_change_directory =>
      'Cambiar directorio';

  @override
  String get release_core_session_files_view_replace_gateway_file =>
      '¿Reemplazar el archivo de la pasarela?';

  @override
  String
  release_core_session_files_view_only_if_the_file_still_matches_the_version(
    String path,
  ) {
    return '$path\n\nSolo si el archivo sigue coincidiendo con la versión que has revisado. Un host compatible conserva el archivo reemplazado para poder recuperarlo.';
  }

  @override
  String get release_core_session_files_view_save_changes => 'Guardar cambios';

  @override
  String
  get release_core_session_files_view_saved_and_verified_on_the_gateway =>
      'Guardado y verificado en la pasarela.';

  @override
  String
  get release_core_session_files_view_guarded_saving_is_unavailable_on_this_gateway_your =>
      'El guardado con protección no está disponible en esta pasarela. Tu borrador sigue aquí.';

  @override
  String
  release_core_session_files_view_save_was_not_confirmed_your_draft_is_still(
    String reason,
  ) {
    return '$reason No se ha confirmado el guardado. Tu borrador sigue aquí.';
  }

  @override
  String get release_core_session_files_view_review_current_gateway_version =>
      'Revisar la versión actual de la pasarela';

  @override
  String get release_core_session_files_view_discard_draft_and_reload =>
      'Descartar borrador y volver a cargar';

  @override
  String get release_core_session_files_view_keep_draft_against_this_version =>
      'Conservar el borrador sobre esta versión';

  @override
  String get release_core_session_files_view_discard_unsaved_edits =>
      '¿Descartar los cambios sin guardar?';

  @override
  String get release_core_session_files_view_keep_editing => 'Seguir editando';

  @override
  String get release_core_session_files_view_discard_edits =>
      'Descartar cambios';

  @override
  String get release_core_session_files_view_remote_working_directory =>
      'Directorio de trabajo remoto';

  @override
  String get release_core_session_files_view_change_working_directory =>
      'Cambiar directorio de trabajo';

  @override
  String get release_core_session_files_view_show_ignored_files =>
      'Mostrar archivos ignorados';

  @override
  String
  get release_core_session_files_view_gateway_does_not_report_ignored_status =>
      'La pasarela no informa de qué archivos están ignorados.';

  @override
  String get release_core_session_files_view_no_visible_entries =>
      'No hay entradas visibles';

  @override
  String get release_core_session_files_view_changed => 'Modificado';

  @override
  String get release_core_session_files_view_ignored => 'Ignorado';

  @override
  String release_core_session_files_view_actions_for(String name) {
    return 'Acciones para $name';
  }

  @override
  String get release_core_session_files_view_copy_relative_path =>
      'Copiar ruta relativa';

  @override
  String get release_core_session_files_view_copy_gateway_path =>
      'Copiar ruta de la pasarela';

  @override
  String get release_core_session_files_view_attach_folder_reference =>
      'Adjuntar referencia a la carpeta';

  @override
  String get release_core_session_files_view_attach_file_reference =>
      'Adjuntar referencia al archivo';

  @override
  String
  get release_core_session_files_view_preview_truncated_editing_disabled =>
      'Vista previa truncada: edición deshabilitada.';

  @override
  String get release_core_session_files_view_select_lines =>
      'Seleccionar líneas';

  @override
  String get release_core_session_files_view_review_gateway_version =>
      'Revisar versión de la pasarela';

  @override
  String get release_core_session_files_view_attach_selected_lines =>
      'Adjuntar líneas seleccionadas';

  @override
  String get release_core_session_files_view_binary_file_no_text_preview =>
      'Archivo binario: sin vista previa de texto.';

  @override
  String get release_core_session_files_view_file_source =>
      'Origen del archivo';

  @override
  String get release_core_session_files_view_close_session_files =>
      'Cerrar archivos de la sesión';

  @override
  String get release_core_session_files_view_back_to_tree => 'Volver al árbol';

  @override
  String get release_core_session_files_view_session_files =>
      'Archivos de la sesión';

  @override
  String get release_core_session_files_view_git_review => 'Revisión de Git';

  @override
  String get release_core_session_files_view_refresh_tree => 'Actualizar árbol';

  @override
  String
  get release_core_gateway_queue_screen_this_connection_changed_reopen_its_chat =>
      'Esta conexión ha cambiado. Vuelve a abrir su chat.';

  @override
  String
  get release_core_gateway_queue_screen_disconnected_reconnect_the_chat_then_refresh =>
      'Sin conexión. Vuelve a conectar el chat y después actualiza.';

  @override
  String release_core_gateway_queue_screen_gateway_queue_unavailable(
    String reason,
  ) {
    return 'Cola de la pasarela no disponible: $reason.';
  }

  @override
  String release_core_gateway_queue_screen_not_confirmed_nothing_was_resent(
    String reason,
  ) {
    return 'Sin confirmar ($reason). No se ha reenviado nada.';
  }

  @override
  String get release_core_gateway_queue_screen_gateway_confirmed_admission =>
      'La pasarela ha confirmado la admisión.';

  @override
  String
  get release_core_gateway_queue_screen_edited_entry_admitted_at_the_end_of_the =>
      'La entrada editada se ha admitido al final de la cola.';

  @override
  String get release_core_gateway_queue_screen_discard_unknown_outcome =>
      '¿Descartar el resultado desconocido?';

  @override
  String get release_core_gateway_queue_screen_remove_this_entry =>
      '¿Eliminar esta entrada?';

  @override
  String
  get release_core_gateway_queue_screen_the_lost_turn_will_not_be_retried_waiting =>
      'No se volverá a intentar el turno perdido. Los turnos en espera ya pueden ejecutarse.';

  @override
  String
  get release_core_gateway_queue_screen_if_the_gateway_has_just_started_this_entry =>
      'Si la pasarela acaba de iniciar esta entrada, eliminarla puede detener ese turno.';

  @override
  String get release_core_gateway_queue_screen_keep => 'Conservar';

  @override
  String get release_core_gateway_queue_screen_discard_and_resume =>
      'Descartar y reanudar';

  @override
  String get release_core_gateway_queue_screen_remove_entry =>
      'Eliminar entrada';

  @override
  String
  get release_core_gateway_queue_screen_lost_admission_resolved_it_was_not_resent =>
      'Se ha resuelto la admisión perdida; no se ha reenviado.';

  @override
  String get release_core_gateway_queue_screen_gateway_acknowledged_removal =>
      'La pasarela ha confirmado la eliminación.';

  @override
  String get release_core_gateway_queue_screen_gateway_queue =>
      'Cola de la pasarela';

  @override
  String get release_core_gateway_queue_screen_refresh_queue =>
      'Actualizar cola';

  @override
  String get release_core_gateway_queue_screen_queue_paused_unknown_outcome =>
      'Cola en pausa: resultado desconocido';

  @override
  String
  get release_core_gateway_queue_screen_review_the_lost_admission_before_resuming_nothing_is =>
      'Revisa la admisión perdida antes de reanudar. No se vuelve a enviar nada.';

  @override
  String get release_core_gateway_queue_screen_no_pending_admissions =>
      'No hay admisiones pendientes';

  @override
  String get release_core_gateway_queue_screen_discard => 'Descartar…';

  @override
  String
  get release_core_gateway_queue_screen_gateway_acknowledged_the_steering_request =>
      'La pasarela ha confirmado la recepción de la solicitud de reorientación.';

  @override
  String get release_core_gateway_queue_screen_steer_running_turn =>
      'Reorientar el turno en curso';

  @override
  String get release_core_gateway_queue_screen_remove => 'Eliminar…';

  @override
  String get release_core_gateway_queue_screen_next_prompt =>
      'Siguiente prompt';

  @override
  String get release_core_gateway_queue_screen_edit_queued_prompt =>
      'Editar prompt en cola';

  @override
  String get release_core_gateway_queue_screen_submit_to_gateway_queue =>
      'Enviar a la cola de la pasarela';

  @override
  String get release_core_gateway_queue_screen_save_at_queue_end =>
      'Guardar al final de la cola';

  @override
  String get release_core_gateway_queue_screen_cancel_edit =>
      'Cancelar edición';

  @override
  String get release_core_git_review_pane_the_git_operation_did_not_complete =>
      'La operación de Git no se ha completado.';

  @override
  String get release_core_git_review_pane_close_git_review =>
      'Cerrar revisión de Git';

  @override
  String get release_core_git_review_pane_pin_lane => 'Fijar carril';

  @override
  String get release_core_git_review_pane_refresh_git_review =>
      'Actualizar revisión de Git';

  @override
  String get release_core_git_review_pane_uncommitted => 'Sin confirmar';

  @override
  String get release_core_git_review_pane_last_turn => 'Último turno';

  @override
  String
  get release_core_git_review_pane_branch_and_last_turn_views_are_read_only =>
      'Las vistas de la rama y del último turno son de solo lectura.';

  @override
  String get release_core_git_review_pane_mark_head_as_the_turn_baseline =>
      'Marcar HEAD como referencia inicial del turno';

  @override
  String get release_core_git_review_pane_stage_all => 'Preparar todo';

  @override
  String get release_core_git_review_pane_discard_every_uncommitted_change =>
      '¿Descartar todos los cambios sin confirmar?';

  @override
  String
  get release_core_git_review_pane_tracked_files_return_to_head_and_untracked_files =>
      'Los archivos bajo seguimiento vuelven a HEAD y se eliminan los archivos sin seguimiento de este directorio de sesión.';

  @override
  String get release_core_git_review_pane_discard => 'Descartar';

  @override
  String get release_core_git_review_pane_discard_all => 'Descartar todo';

  @override
  String get release_core_git_review_pane_unstage =>
      'Quitar del área de preparación';

  @override
  String get release_core_git_review_pane_stage => 'Preparar';

  @override
  String get release_core_git_review_pane_discard_file => 'Descartar archivo';

  @override
  String release_core_git_review_pane_discard_2(String path) {
    return '¿Descartar $path?';
  }

  @override
  String
  get release_core_git_review_pane_this_restores_the_committed_copy_or_removes_the =>
      'Esto restaura la copia confirmada o elimina el archivo sin seguimiento.';

  @override
  String get release_core_git_review_pane_commit_message =>
      'Mensaje del commit';

  @override
  String get release_core_git_review_pane_nothing_in_the_diff_to_summarise =>
      'No hay nada que resumir en el diff.';

  @override
  String get release_core_git_review_pane_generate_message => 'Generar mensaje';

  @override
  String get release_core_git_review_pane_commit => 'Crear commit';

  @override
  String get release_core_git_review_pane_commit_and_push =>
      'Crear commit y enviar';

  @override
  String get release_core_git_review_pane_push => 'Enviar cambios';

  @override
  String get release_core_git_review_pane_create_pull_request =>
      'Crear solicitud de incorporación';

  @override
  String get release_core_git_review_pane_pull_request_ready =>
      'Solicitud de incorporación lista';

  @override
  String get release_core_git_review_pane_ask_hermes_to_ship =>
      'Pedir a Hermes que publique los cambios';

  @override
  String get release_core_git_review_pane_gh_is_authenticated_on_this_gateway =>
      'gh está autenticado en esta pasarela.';

  @override
  String
  get release_core_git_review_pane_install_the_github_cli_gh_and_sign_in =>
      'Instala la CLI de GitHub (gh) e inicia sesión para abrir solicitudes de incorporación';

  @override
  String get release_core_git_review_pane_worktrees => 'Árboles de trabajo';

  @override
  String get release_core_git_review_pane_main => 'Principal';

  @override
  String release_core_git_review_pane_follow(String branch) {
    return '¿Seguir $branch?';
  }

  @override
  String
  get release_core_git_review_pane_the_session_working_directory_becomes_this_worktree_unless =>
      'El directorio de trabajo de la sesión pasa a ser este árbol de trabajo, salvo que el carril esté fijado.';

  @override
  String get release_core_git_review_pane_follow_2 => 'Seguir';

  @override
  String release_core_git_review_pane_remove(String branch) {
    return '¿Eliminar $branch?';
  }

  @override
  String get release_core_git_review_pane_the_worktree_directory_is_removed =>
      'Se elimina el directorio del árbol de trabajo.';

  @override
  String get release_core_git_review_pane_remove_2 => 'Eliminar';

  @override
  String get release_core_git_review_pane_new_worktree_name =>
      'Nombre del nuevo árbol de trabajo';

  @override
  String get release_core_git_review_pane_new_branch => 'Nueva rama';

  @override
  String get release_core_git_review_pane_base_branch => 'Rama base';

  @override
  String get release_core_git_review_pane_create_worktree =>
      'Crear árbol de trabajo';

  @override
  String get release_core_git_review_pane_existing_branch => 'Rama existente';

  @override
  String get release_core_git_review_pane_convert_branch_to_worktree =>
      'Convertir rama en árbol de trabajo';

  @override
  String get release_core_git_review_pane_switch_branch => 'Cambiar de rama';

  @override
  String
  get release_core_git_review_pane_this_gateway_does_not_support_that_git_operation =>
      'Esta pasarela no admite esa operación de Git.';

  @override
  String
  get release_core_git_review_pane_git_needs_the_session_directory_on_the_local =>
      'Git necesita que el directorio de la sesión esté en el backend de terminal local.';

  @override
  String
  get release_core_git_review_pane_the_gateway_refused_the_git_operation =>
      'La pasarela ha rechazado la operación de Git.';

  @override
  String
  get release_core_git_review_pane_the_session_changed_refresh_and_try_again =>
      'La sesión ha cambiado. Actualiza e inténtalo de nuevo.';

  @override
  String
  get release_core_git_review_pane_this_review_is_no_longer_the_selected_session =>
      'Esta revisión ya no corresponde a la sesión seleccionada.';

  @override
  String
  get release_core_git_review_pane_the_gateway_returned_an_unexpected_git_result =>
      'La pasarela ha devuelto un resultado de Git inesperado.';

  @override
  String
  get release_core_git_review_pane_git_review_requires_the_gateway_transport =>
      'La revisión de Git requiere el transporte de la pasarela.';

  @override
  String get release_core_client_held_queue_bar_resume => 'Reanudar';

  @override
  String get release_core_client_held_queue_bar_send_queued_prompt =>
      'Enviar prompt en cola';

  @override
  String get release_core_client_held_queue_bar_edit_unsent_prompt =>
      'Editar prompt sin enviar';

  @override
  String get release_core_client_held_queue_bar_remove_unsent_prompt =>
      'Eliminar prompt sin enviar';

  @override
  String get release_core_workspace_discovery_view_repository_discovery =>
      'Detección de repositorios';

  @override
  String get release_core_workspace_discovery_view_refresh_results =>
      'Actualizar resultados';

  @override
  String release_core_workspace_discovery_view_hide(String path) {
    return 'Ocultar $path';
  }

  @override
  String
  get release_core_workspace_discovery_view_invalid_path_or_discovery_data_use_absolute_server =>
      'Ruta o datos de detección no válidos. Usa rutas absolutas del servidor sin componentes «.» ni «..».';

  @override
  String
  get release_core_workspace_discovery_view_this_gateway_does_not_support_repository_discovery =>
      'Esta pasarela no admite la detección de repositorios.';

  @override
  String
  get release_core_workspace_discovery_view_the_gateway_denied_access_to_repository_discovery =>
      'La pasarela ha denegado el acceso a la detección de repositorios.';

  @override
  String
  get release_core_workspace_discovery_view_the_connection_changed_reopen_discovery_on_the_current =>
      'La conexión ha cambiado. Vuelve a abrir la detección en la pasarela actual.';

  @override
  String
  get release_core_workspace_discovery_view_the_displayed_settings_have_changed_refresh_before_trying =>
      'Los ajustes mostrados han cambiado. Actualiza antes de volver a intentarlo.';

  @override
  String
  get release_core_workspace_discovery_view_could_not_load_or_verify_discovery_settings_refresh =>
      'No se pudieron cargar o verificar los ajustes de detección. Actualiza para volver a intentarlo.';

  @override
  String release_core_workspace_discovery_view_repositories_shown_of(
    int visible,
    int total,
  ) {
    return 'Repositorios mostrados: $visible de $total';
  }

  @override
  String
  get release_core_workspace_discovery_view_the_gateway_returned_no_repositories =>
      'La pasarela no ha devuelto ningún repositorio.';

  @override
  String
  get release_core_workspace_discovery_view_no_repositories_match_your_device_filters =>
      'Ningún repositorio coincide con los filtros de tu dispositivo.';

  @override
  String get release_core_workspace_discovery_view_gateway_scan_policy =>
      'Política de exploración de la pasarela';

  @override
  String
  get release_core_workspace_discovery_view_this_gateway_did_not_report_a_scan_policy =>
      'Esta pasarela no ha indicado una política de exploración.';

  @override
  String
  get release_core_workspace_discovery_view_to_scan_folders_configure_repository_scanning_in_the =>
      'Para explorar carpetas, configura la exploración de repositorios en los ajustes de Desktop del perfil de la pasarela.';

  @override
  String
  get release_core_workspace_discovery_view_results_can_include_cached_repositories_and_repositories_with =>
      'Los resultados pueden incluir repositorios en caché y repositorios con sesiones. Una exploración no garantiza que se haya accedido a todas las carpetas.';

  @override
  String get release_core_workspace_discovery_view_scan_gateway_roots =>
      'Explorar las raíces de la pasarela';

  @override
  String
  get release_core_workspace_discovery_view_filter_results_on_this_device =>
      'Filtrar resultados en este dispositivo';

  @override
  String
  get release_core_workspace_discovery_view_only_this_discovery_list_changes_not_the_gateway =>
      'Solo cambia esta lista de detección, no la exploración de la pasarela.';

  @override
  String get release_core_workspace_discovery_view_include_subtrees_empty_all =>
      'Incluir subárboles (vacío = todos)';

  @override
  String get release_core_workspace_discovery_view_exclude_subtrees =>
      'Excluir subárboles';

  @override
  String get release_core_workspace_discovery_view_apply_filters =>
      'Aplicar filtros';

  @override
  String release_core_workspace_discovery_view_hidden_repositories(int count) {
    return 'Repositorios ocultos ($count)';
  }

  @override
  String get release_core_workspace_discovery_view_undo_hide =>
      'Deshacer ocultación';

  @override
  String
  get release_core_workspace_discovery_view_one_absolute_server_path_per_line =>
      'Una ruta absoluta del servidor por línea';

  @override
  String get release_core_project_settings_view_project_settings =>
      'Ajustes del proyecto';

  @override
  String
  get release_core_project_settings_view_the_gateway_did_not_confirm_the_selected_project =>
      'La pasarela no ha confirmado el proyecto seleccionado o el cambio. Revisa los ajustes antes de volver a intentarlo.';

  @override
  String
  get release_core_project_settings_view_could_not_verify_these_settings_use_one_absolute =>
      'No se pudieron verificar estos ajustes. Usa una ruta absoluta de carpeta del servidor por línea, sin componentes «.» ni «..».';

  @override
  String get release_core_project_settings_view_set_active => 'Activar';

  @override
  String get release_core_project_settings_view_icon => 'Icono';

  @override
  String get release_core_project_settings_view_folder => 'Carpeta';

  @override
  String get release_core_project_settings_view_repository => 'Repositorio';

  @override
  String get release_core_project_settings_view_rocket => 'Cohete';

  @override
  String get release_core_project_settings_view_star => 'Estrella';

  @override
  String get release_core_project_settings_view_book => 'Libro';

  @override
  String get release_core_project_settings_view_terminal => 'Terminal';

  @override
  String get release_core_project_settings_view_colour => 'Color';

  @override
  String get release_core_project_settings_view_primary_folder =>
      'Carpeta principal';

  @override
  String get release_core_project_settings_view_server_folder_paths =>
      'Rutas de carpetas del servidor';

  @override
  String
  get release_core_project_settings_view_one_absolute_path_per_line_existing_folders_are =>
      'Una ruta absoluta por línea. Se conservan las carpetas existentes.';

  @override
  String get release_core_project_settings_view_add_folders =>
      'Añadir carpetas';

  @override
  String release_core_project_settings_view_choose(String label) {
    return 'Elegir $label';
  }

  @override
  String
  get release_core_prepared_image_recovery_wait_for_an_empty_draft_before_restoring =>
      'Espera a que el borrador esté vacío antes de restaurar.';

  @override
  String
  get release_core_prepared_image_recovery_no_unacknowledged_image_drafts_in_this_chat =>
      'No hay borradores de imágenes sin acuse de recibo en este chat.';

  @override
  String get release_core_prepared_image_recovery_unacknowledged_image_drafts =>
      'Borradores de imágenes sin acuse de recibo';

  @override
  String
  get release_core_prepared_image_recovery_the_gateway_may_already_have_received_these_restore =>
      'Es posible que la pasarela ya los haya recibido. Restáuralos para revisarlos; no se envía nada.';

  @override
  String get release_core_prepared_image_recovery_image_draft =>
      'Borrador de imagen';

  @override
  String get release_core_prepared_image_recovery_discard_local_copy =>
      'Descartar copia local';

  @override
  String
  get release_core_prepared_image_recovery_discard_this_local_image_draft =>
      '¿Descartar este borrador de imagen local?';

  @override
  String
  get release_core_prepared_image_recovery_image_draft_recovery_is_unavailable =>
      'La recuperación de borradores de imágenes no está disponible.';

  @override
  String get release_core_prepared_image_recovery_recover_image_draft =>
      'Recuperar borrador de imagen…';

  @override
  String get release_core_session_search_mode_menu_could_not_save_search_mode =>
      'No se pudo guardar el modo de búsqueda.';

  @override
  String get release_core_projects_pane_discover_repositories =>
      'Detectar repositorios';

  @override
  String
  get release_core_projects_pane_project_created_but_the_gateway_did_not_confirm =>
      'Se ha creado el proyecto, pero la pasarela no ha confirmado su idea.';

  @override
  String get release_core_projects_pane_project_idea_optional =>
      'Idea del proyecto (opcional)';

  @override
  String
  get release_core_projects_pane_saved_in_the_project_description_not_a_file =>
      'Se guarda en la descripción del proyecto, no en un archivo.';

  @override
  String get release_core_project_detail_screen_new_chat_in_this_lane =>
      'Nuevo chat en este carril';

  @override
  String get release_core_project_detail_screen_review_git => 'Revisar Git';

  @override
  String get release_core_more_pane_gateway_fleet => 'Flota de pasarelas';

  @override
  String
  get release_core_more_pane_connected_sessions_hermes_cloud_and_desktop_webapp =>
      'Sesiones conectadas, Hermes Cloud y aplicación web de Desktop';

  @override
  String get release_core_more_pane_use_dashboard_sign_in_for_a_named_profile =>
      'Usa el inicio de sesión del panel para un perfil con nombre. Esta API heredada no puede confirmar a qué perfil pertenece el historial de chat.';

  @override
  String get release_core_more_pane_capabilities => 'Capacidades';

  @override
  String
  get release_core_more_pane_install_and_govern_skills_plugins_connectors_and_tool =>
      'Instala y administra habilidades, plugins, conectores y backends de herramientas';

  @override
  String get release_core_more_pane_browser_vault => 'Bóveda del navegador';

  @override
  String
  get release_core_more_pane_site_logins_addresses_cards_and_credential_sources =>
      'Inicios de sesión en sitios, direcciones, tarjetas y fuentes de credenciales';

  @override
  String get release_core_more_pane_agent_policy => 'Política del agente';

  @override
  String
  get release_core_more_pane_approvals_checkpoints_browser_access_and_shared_metrics =>
      'Aprobaciones, puntos de control, acceso al navegador y métricas compartidas';

  @override
  String get release_core_more_pane_remote_logs_health_maintenance_and_update =>
      'Registros remotos, estado, mantenimiento y actualización';

  @override
  String get release_core_more_pane_schedules => 'Programaciones';

  @override
  String get release_core_more_pane_all_profiles_blueprints_catch_up_and_stop =>
      'Todos los perfiles, plantillas, recuperación de ejecuciones omitidas y detención';

  @override
  String get release_core_more_pane_memory_graph => 'Grafo de memoria';

  @override
  String get release_core_more_pane_timeline_edits_and_memory_providers =>
      'Cronología, ediciones y proveedores de memoria';

  @override
  String get release_core_more_pane_providers_and_routes =>
      'Proveedores y rutas';

  @override
  String get release_core_more_pane_keys_endpoints_delegation_and_mixtures =>
      'Claves, endpoints, delegación y mezclas';

  @override
  String get release_core_more_pane_credits_and_plans => 'Créditos y planes';

  @override
  String
  get release_core_more_pane_consented_nous_billing_when_the_account_allows_it =>
      'Facturación de Nous con consentimiento cuando la cuenta lo permite';

  @override
  String
  get release_core_fleet_screen_this_gateway_does_not_offer_this_service =>
      'Esta pasarela no ofrece este servicio.';

  @override
  String
  get release_core_fleet_screen_sign_in_or_permission_required_on_this_gateway =>
      'Esta pasarela requiere iniciar sesión o disponer de permiso.';

  @override
  String get release_core_fleet_screen_a_secure_gateway_address_is_required =>
      'Se requiere una dirección segura de la pasarela.';

  @override
  String
  get release_core_fleet_screen_the_owner_changed_refresh_before_continuing =>
      'El propietario ha cambiado. Actualiza antes de continuar.';

  @override
  String
  get release_core_fleet_screen_could_not_verify_the_operation_check_the_gateway =>
      'No se pudo verificar la operación. Comprueba la pasarela y actualiza.';

  @override
  String get release_core_fleet_screen_verified_ssh => 'SSH verificado';

  @override
  String
  get release_core_fleet_screen_confirm_a_host_key_inspect_a_remote_service =>
      'Confirma una clave de host, inspecciona un servicio remoto o abre su shell';

  @override
  String get release_core_fleet_screen_cloud_and_desktop_webapp =>
      'Cloud y aplicación web de Desktop';

  @override
  String get release_core_fleet_screen_register_an_existing_gateway_or_webapp =>
      'Registrar una pasarela o aplicación web existente';

  @override
  String
  get release_core_fleet_screen_sign_in_to_its_address_nothing_is_hosted =>
      'Inicia sesión en su dirección. No se aloja nada en este dispositivo.';

  @override
  String get release_core_fleet_screen_fleet_updates =>
      'Actualizaciones de la flota';

  @override
  String get release_core_fleet_screen_refresh_roster =>
      'Actualizar lista de pasarelas';

  @override
  String release_core_fleet_screen_disconnect(String gateway) {
    return 'Desconectar $gateway';
  }

  @override
  String get release_core_fleet_screen_open_this_gateway_on_launch =>
      'Abrir esta pasarela al iniciar';

  @override
  String
  get release_core_fleet_screen_primary_for_ares_does_not_change_the_last =>
      'Principal para Ares; no cambia la última pasarela utilizada.';

  @override
  String get release_core_fleet_screen_reconnect_in_fleet_on_launch =>
      'Volver a conectar en la flota al iniciar';

  @override
  String get release_core_fleet_screen_no_sessions_for_this_profile =>
      'No hay sesiones para este perfil.';

  @override
  String get release_core_fleet_screen_more_sessions => 'Más sesiones';

  @override
  String get release_core_fleet_screen_this_gateway_was_disconnected =>
      'Esta pasarela se ha desconectado.';

  @override
  String
  get release_core_fleet_screen_some_conversation_data_could_not_be_loaded =>
      'No se pudieron cargar algunos datos de la conversación.';

  @override
  String get release_core_fleet_screen_message_this_session =>
      'Enviar un mensaje a esta sesión';

  @override
  String get release_core_fleet_screen_send_to_this_session =>
      'Enviar a esta sesión';

  @override
  String get release_core_fleet_updates_screen_update_these_remote_gateways =>
      '¿Actualizar estas pasarelas remotas?';

  @override
  String
  release_core_fleet_updates_screen_this_can_restart_the_backend_and_interrupt_other(
    String gateways,
  ) {
    return 'Esto puede reiniciar el backend e interrumpir a otros usuarios. No actualizará Ares.\n\n$gateways';
  }

  @override
  String get release_core_fleet_updates_screen_update_listed_gateways =>
      'Actualizar las pasarelas de la lista';

  @override
  String
  get release_core_fleet_updates_screen_checks_connected_gateways_cloud_is_platform_managed_entries =>
      'Comprueba las pasarelas conectadas. Cloud está gestionado por la plataforma; se excluyen las entradas cuya procedencia de registro no consta.';

  @override
  String get release_core_fleet_updates_screen_check_connected_gateways =>
      'Comprobar pasarelas conectadas';

  @override
  String get release_core_fleet_updates_screen_read_update_receipt =>
      'Consultar comprobante de actualización';

  @override
  String get release_core_fleet_updates_screen_review_eligible_updates =>
      'Revisar actualizaciones aplicables';

  @override
  String
  get release_core_fleet_webapp_screen_account_changed_reopen_this_page =>
      'La cuenta ha cambiado. Vuelve a abrir esta página.';

  @override
  String
  get release_core_fleet_webapp_screen_set_the_webapp_s_primary_gateway =>
      '¿Establecer la pasarela principal de la aplicación web?';

  @override
  String
  release_core_fleet_webapp_screen_this_changes_the_shared_registry_not_the_last(
    String webapp,
    String gateway,
    String id,
  ) {
    return '$webapp → $gateway ($id)\nEsto cambia el registro compartido, no la última pasarela utilizada.';
  }

  @override
  String get release_core_fleet_webapp_screen_set_primary =>
      'Establecer como principal';

  @override
  String get release_core_fleet_webapp_screen_serving_profile =>
      'Perfil que presta el servicio';

  @override
  String get release_core_fleet_webapp_screen_hermes_cloud => 'Hermes Cloud';

  @override
  String get release_core_fleet_webapp_screen_discover_signed_in_agents =>
      'Detectar agentes con sesión iniciada';

  @override
  String release_core_fleet_webapp_screen_organisation(String organisation) {
    return 'Organización: $organisation';
  }

  @override
  String get release_core_fleet_webapp_screen_no_agents_available =>
      'No hay agentes disponibles.';

  @override
  String get release_core_fleet_webapp_screen_existing_desktop_webapp =>
      'Aplicación web de Desktop existente';

  @override
  String
  get release_core_fleet_webapp_screen_check_gateway_and_web_access_status =>
      'Comprobar el estado de la pasarela y del acceso web';

  @override
  String
  get release_core_fleet_webapp_screen_these_settings_belong_to_the_machine_serving_this =>
      'Estos ajustes pertenecen al equipo que sirve esta aplicación web. La publicación y los reinicios no son acciones remotas.';

  @override
  String get release_core_fleet_webapp_screen_read_webapp_gateway_registry =>
      'Consultar el registro de pasarelas de la aplicación web';

  @override
  String get release_core_fleet_webapp_screen_last_used => 'Última utilizada';

  @override
  String get release_core_fleet_webapp_screen_primary => 'Principal';

  @override
  String release_core_fleet_webapp_screen_set_primary_2(String gateway) {
    return 'Establecer como principal: $gateway';
  }

  @override
  String get release_core_fleet_webapp_screen_read_shared_display_preferences =>
      'Consultar preferencias de visualización compartidas';

  @override
  String
  get release_core_fleet_webapp_screen_chat_text_direction_on_this_webapp_and_desktop =>
      'Dirección del texto del chat en esta aplicación web y en Desktop';

  @override
  String release_core_schedule_desk_screen_created_on(
    String job,
    String profile,
  ) {
    return 'Se ha creado $job en $profile.';
  }

  @override
  String
  get release_core_schedule_desk_screen_the_list_covers_every_profile_on_this_gateway =>
      'La lista incluye todos los perfiles de esta pasarela. Las acciones de detener, pausar, recuperar ejecuciones omitidas, entrega y plantillas se envían al perfil al que pertenece la tarea.';

  @override
  String get release_core_schedule_desk_screen_a_run_is_in_progress =>
      'Hay una ejecución en curso';

  @override
  String get release_core_schedule_desk_screen_no_current_run =>
      'No hay ninguna ejecución en curso';

  @override
  String release_core_schedule_desk_screen_stop_requested_for(String job) {
    return 'Se ha solicitado detener $job.';
  }

  @override
  String release_core_schedule_desk_screen_no_run_was_in_flight_for(
    String job,
  ) {
    return 'No había ninguna ejecución en curso para $job.';
  }

  @override
  String get release_core_schedule_desk_screen_stop_current_run =>
      'Detener ejecución actual';

  @override
  String get release_core_schedule_desk_screen_pause_future_runs =>
      'Pausar futuras ejecuciones';

  @override
  String get release_core_schedule_desk_screen_resume_future_runs =>
      'Reanudar futuras ejecuciones';

  @override
  String get release_core_schedule_desk_screen_catch_up_default =>
      'Recuperación predeterminada de ejecuciones omitidas';

  @override
  String get release_core_schedule_desk_screen_run_one_missed =>
      'Ejecutar una omitida';

  @override
  String get release_core_schedule_desk_screen_skip_missed =>
      'Saltar ejecuciones omitidas';

  @override
  String get release_core_schedule_desk_screen_blueprint_recipes =>
      'Recetas de plantillas';

  @override
  String get release_core_schedule_desk_screen_profile_for_the_new_job =>
      'Perfil para la nueva tarea';

  @override
  String release_core_schedule_desk_screen_create(String blueprint) {
    return 'Crear $blueprint';
  }

  @override
  String get release_core_schedule_desk_screen_loading_delivery_targets =>
      'Cargando destinos de entrega';

  @override
  String release_core_schedule_desk_screen_no_home_channel(String target) {
    return '$target (sin canal principal)';
  }

  @override
  String release_core_memory_graph_screen_edit(String label) {
    return 'Editar $label';
  }

  @override
  String get release_core_memory_graph_screen_content => 'Contenido';

  @override
  String get release_core_memory_graph_screen_archive_skill =>
      'Archivar habilidad';

  @override
  String get release_core_memory_graph_screen_delete_memory =>
      'Eliminar recuerdo';

  @override
  String release_core_memory_graph_screen_archive_on_it_can_be_restored_on_the(
    String label,
    String profile,
  ) {
    return '¿Archivar $label en $profile? Se puede restaurar en el host con Curator.';
  }

  @override
  String release_core_memory_graph_screen_delete_from_this_removes_that_memory(
    String label,
    String profile,
  ) {
    return '¿Eliminar $label de $profile? Esto elimina ese recuerdo.';
  }

  @override
  String get release_core_memory_graph_screen_filter => 'Filtrar';

  @override
  String get release_core_memory_graph_screen_timeline => 'Cronología';

  @override
  String get release_core_memory_graph_screen_play_timeline =>
      'Reproducir cronología';

  @override
  String get release_core_memory_graph_screen_layout_code =>
      'Código de disposición';

  @override
  String get release_core_memory_graph_screen_external_memory_providers =>
      'Proveedores de memoria externos';

  @override
  String
  get release_core_memory_graph_screen_a_value_is_stored_leave_blank_to_keep =>
      'Hay un valor guardado. Déjalo en blanco para conservarlo.';

  @override
  String get release_core_memory_graph_screen_save_provider =>
      'Guardar proveedor';

  @override
  String release_core_workspace_profiles_screen_applies_to(String profile) {
    return 'Se aplica a: $profile';
  }

  @override
  String get release_core_workspace_profiles_screen_choose_another_profile =>
      'Elegir otro perfil';

  @override
  String
  get release_core_workspace_profiles_screen_could_not_verify_the_selected_profile_on_this =>
      'No se pudo verificar el perfil seleccionado en esta pasarela.';

  @override
  String get release_core_workspace_profiles_screen_create_profile =>
      'Crear perfil';

  @override
  String get release_core_workspace_profiles_screen_new_profile_id =>
      'ID del nuevo perfil';

  @override
  String get release_core_assets_screen_links => 'Enlaces';

  @override
  String get release_core_workspace_picker_no_matching_items =>
      'No hay elementos coincidentes.';

  @override
  String get release_core_workspace_picker_save_layout => 'Guardar disposición';

  @override
  String get release_core_workspace_picker_layout_name =>
      'Nombre de la disposición';

  @override
  String
  get release_core_workspace_popout_this_chat_already_has_a_pop_out_window =>
      'Este chat ya tiene una ventana independiente.';

  @override
  String
  get release_core_workspace_popout_could_not_open_this_saved_chat_check_the =>
      'No se pudo abrir este chat guardado. Comprueba la conexión e inténtalo de nuevo.';

  @override
  String
  get release_core_popout_bootstrap_use_the_main_window_to_change_your_connection =>
      'Usa la ventana principal para cambiar la conexión.';

  @override
  String get release_core_guarded_save_refused =>
      'La pasarela no puede guardar este archivo';

  @override
  String get release_core_guarded_save_unavailable =>
      'El guardado con protección no está disponible en esta pasarela';

  @override
  String release_core_git_files_changed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count archivos modificados en este turno',
      one: '1 archivo modificado en este turno',
    );
    return '$_temp0';
  }

  @override
  String release_core_git_entries_omitted(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Se han omitido $count entradas de Git porque no era seguro mostrarlas.',
      one: 'Se ha omitido 1 entrada de Git porque no era seguro mostrarla.',
    );
    return '$_temp0';
  }

  @override
  String get release_core_git_staged => 'Preparado';

  @override
  String get release_core_session_sort_recent => 'Actividad reciente';

  @override
  String get release_core_session_sort_created => 'Creados más recientemente';

  @override
  String get release_core_session_sort_status => 'En ejecución primero';

  @override
  String get release_core_session_sort_tokens => 'Más tokens';

  @override
  String get release_core_session_sort_cost => 'Mayor coste';

  @override
  String get release_core_session_group_standard => 'Agrupación predeterminada';

  @override
  String get release_core_session_group_status => 'Agrupar por estado';

  @override
  String get release_core_session_group_project => 'Agrupar por proyecto';

  @override
  String release_core_session_tokens(int count) {
    return '$count tokens';
  }

  @override
  String release_core_search_gateway_mode(String mode) {
    return '$mode (pasarela)';
  }

  @override
  String release_core_search_mode_tooltip(String label, String mode) {
    return '$label: $mode';
  }

  @override
  String get release_core_image_recovery_new_turn =>
      'El envío crea un nuevo turno';

  @override
  String release_core_image_recovery_metadata(int count, String date) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count imágenes · $date',
      one: '1 imagen · $date',
    );
    return '$_temp0';
  }

  @override
  String release_core_discovery_scanning(String state) {
    return 'Exploración: $state';
  }

  @override
  String get release_core_discovery_enabled => 'habilitada';

  @override
  String get release_core_discovery_disabled => 'deshabilitada';

  @override
  String get release_core_discovery_none => 'ninguna';

  @override
  String release_core_discovery_roots(String paths) {
    return 'Raíces de exploración: $paths';
  }

  @override
  String release_core_discovery_excluded(String paths) {
    return 'Subárboles excluidos: $paths';
  }

  @override
  String release_core_discovery_repository_sessions(String path, int count) {
    return '$path\nSesiones: $count';
  }

  @override
  String get release_core_projects_local_only =>
      'Esta pasarela de Hermes es anterior a los proyectos del servidor, por lo que los chats solo se agrupan en este dispositivo. Actualiza Hermes para compartir los mismos proyectos entre tus dispositivos.';

  @override
  String get release_core_fleet_no_address =>
      'Aún no hay dirección de la pasarela';

  @override
  String release_core_fleet_diagnostics(String version, String access) {
    return 'Pasarela $version · $access';
  }

  @override
  String get release_core_schedule_builtin => 'integrada';

  @override
  String get release_core_memory_gateway_profile => 'pasarela';

  @override
  String release_core_memory_profile_summary(String profile, String gateway) {
    return 'Perfil $profile en $gateway. El código para compartir solo guarda el zoom, el tiempo y los filtros.';
  }

  @override
  String release_core_memory_layers_summary(
    int memoryBytes,
    int userBytes,
    String provider,
  ) {
    return 'Memoria integrada: $memoryBytes bytes; usuario: $userBytes bytes. Proveedor activo: $provider.';
  }

  @override
  String get release_core_memory_kind_all => 'Todos';

  @override
  String get release_core_memory_kind_skill => 'Habilidades';

  @override
  String get release_core_memory_kind_memory => 'Memoria';

  @override
  String get release_core_workspace_failure_stale => 'la conexión ha cambiado';

  @override
  String get release_core_workspace_failure_unbound =>
      'sin directorio de trabajo verificado';

  @override
  String get release_core_workspace_failure_denied => 'permiso denegado';

  @override
  String get release_core_workspace_failure_ineligible =>
      'operación no permitida para este archivo';

  @override
  String get release_core_workspace_failure_unsupported =>
      'no compatible con esta pasarela';

  @override
  String get release_core_workspace_failure_mismatch =>
      'el estado remoto ha cambiado';

  @override
  String get release_core_workspace_failure_invalid =>
      'respuesta de la pasarela no válida';

  @override
  String get release_core_workspace_failure_insecure =>
      'se requiere una conexión segura';

  @override
  String get release_core_workspace_failure_unavailable =>
      'pasarela no disponible';

  @override
  String get release_core_queue_state_queued => 'En cola';

  @override
  String get release_core_queue_state_started => 'Iniciado';

  @override
  String get release_core_queue_state_unknown => 'Resultado desconocido';

  @override
  String get release_core_unknown_state => 'Desconocido';

  @override
  String get release_core_fleet_state_idle => 'Sin conexión';

  @override
  String get release_core_fleet_state_connected => 'Conectado';

  @override
  String get release_core_fleet_state_reconnecting => 'Volviendo a conectar…';

  @override
  String get release_core_fleet_state_sessionExpired => 'Sesión cerrada';

  @override
  String get release_core_fleet_state_failed => 'Error de conexión';

  @override
  String release_core_workspace_operation_failed(String reason) {
    return 'No se pudo confirmar la operación de la pasarela: $reason.';
  }

  @override
  String get release_core_workspace_invalid_data =>
      'No se pudieron verificar los datos o la entrada. Revísalos e inténtalo de nuevo.';

  @override
  String
  get release_core_parallel_workspace_layout_changed_in_this_window_but_could_not =>
      'La disposición ha cambiado en esta ventana, pero no se pudo guardar.';

  @override
  String get release_core_parallel_workspace_first_pane => 'Primer panel';

  @override
  String get release_core_parallel_workspace_second_pane => 'Segundo panel';

  @override
  String get release_core_parallel_workspace_unavailable_page =>
      'Página no disponible';

  @override
  String release_core_parallel_workspace_close_a_tab_first_maximum(
    String maximum,
  ) {
    return 'Cierra primero una pestaña (máximo $maximum).';
  }

  @override
  String get release_core_parallel_workspace_dock_beside_current_pane =>
      'Acoplar junto al panel actual';

  @override
  String get release_core_parallel_workspace_add_chat => 'Añadir chat';

  @override
  String
  get release_core_parallel_workspace_action_failed_check_the_connection_and_try_again =>
      'La acción ha fallado. Comprueba la conexión e inténtalo de nuevo.';

  @override
  String
  get release_core_parallel_workspace_close_a_tab_before_reopening_another =>
      'Cierra una pestaña antes de volver a abrir otra.';

  @override
  String release_core_parallel_workspace_replace_layout(String name) {
    return '¿Reemplazar la disposición «$name»?';
  }

  @override
  String
  get release_core_parallel_workspace_layout_limit_reached_replace_an_existing_layout =>
      'Se ha alcanzado el límite de disposiciones. Reemplaza una existente.';

  @override
  String get release_core_parallel_workspace_restore_layout =>
      'Restaurar disposición';

  @override
  String get release_core_parallel_workspace_workspace_options =>
      'Opciones del espacio de trabajo';

  @override
  String get release_core_parallel_workspace_dock_another_pane =>
      'Acoplar otro panel';

  @override
  String get release_core_parallel_workspace_swap_panes =>
      'Intercambiar paneles';

  @override
  String get release_core_parallel_workspace_undock_second_pane =>
      'Desacoplar segundo panel';

  @override
  String get release_core_parallel_workspace_arrange_side_by_side =>
      'Colocar uno al lado del otro';

  @override
  String get release_core_parallel_workspace_arrange_top_to_bottom =>
      'Colocar uno encima del otro';

  @override
  String release_core_parallel_workspace_change_split_size(String percent) {
    return 'Cambiar proporción de división ($percent%)';
  }

  @override
  String get release_core_parallel_workspace_focus_pane_full_screen =>
      'Enfocar panel a pantalla completa';

  @override
  String get release_core_parallel_workspace_open_chat_in_new_window =>
      'Abrir chat en una ventana nueva';

  @override
  String get release_core_parallel_workspace_hide_pane_keep_running =>
      'Ocultar panel (mantener en ejecución)';

  @override
  String get release_core_parallel_workspace_previous_tab => 'Pestaña anterior';

  @override
  String get release_core_parallel_workspace_next_tab => 'Pestaña siguiente';

  @override
  String get release_core_parallel_workspace_move_tab_left =>
      'Mover pestaña a la izquierda';

  @override
  String get release_core_parallel_workspace_move_tab_right =>
      'Mover pestaña a la derecha';

  @override
  String get release_core_parallel_workspace_reload_current_tab =>
      'Volver a cargar la pestaña actual';

  @override
  String get release_core_parallel_workspace_close_tab => 'Cerrar pestaña';

  @override
  String get release_core_parallel_workspace_close_other_tabs =>
      'Cerrar las demás pestañas';

  @override
  String get release_core_parallel_workspace_close_tabs_to_the_right =>
      'Cerrar pestañas a la derecha';

  @override
  String get release_core_parallel_workspace_close_all_tabs =>
      'Cerrar todas las pestañas';

  @override
  String get release_core_parallel_workspace_reopen_closed_tab =>
      'Volver a abrir pestaña cerrada';

  @override
  String get release_core_parallel_workspace_save_named_layout =>
      'Guardar disposición con nombre';

  @override
  String get release_core_parallel_workspace_restore_named_layout =>
      'Restaurar disposición con nombre';

  @override
  String get release_core_parallel_workspace_refresh_chat_list =>
      'Actualizar lista de chats';

  @override
  String get release_core_parallel_workspace_workspace_tools =>
      'Herramientas del espacio de trabajo';

  @override
  String get release_core_parallel_workspace_choose_a_chat_for_this_pane =>
      'Elige un chat para este panel';

  @override
  String release_core_parallel_workspace_choose_chat_for(String pane) {
    return 'Elegir chat para $pane';
  }

  @override
  String get release_core_parallel_workspace_add_a_chat_to_start_a_workspace =>
      'Añade un chat para iniciar un espacio de trabajo.';

  @override
  String get release_core_parallel_workspace_select_a_tab_to_show_its_pane =>
      'Selecciona una pestaña para mostrar su panel.';

  @override
  String get release_core_parallel_workspace_parallel_workspace =>
      'Espacio de trabajo en paralelo';

  @override
  String get release_core_parallel_workspace_show_workspace =>
      'Mostrar espacio de trabajo';

  @override
  String get release_core_parallel_workspace_could_not_load_chats_retry =>
      'No se pudieron cargar los chats. Reintentar';

  @override
  String release_core_parallel_workspace_close(String pane) {
    return 'Cerrar $pane';
  }

  @override
  String release_core_parallel_workspace_switch_pane(String pane) {
    return 'Cambiar de panel: $pane';
  }

  @override
  String get release_core_workspace_registry_session_id_copied =>
      'ID de sesión copiado.';

  @override
  String get release_core_workspace_registry_chat_details =>
      'Detalles del chat';

  @override
  String get release_core_workspace_registry_server_default =>
      'Predeterminado del servidor';

  @override
  String get release_core_workspace_registry_session_id => 'ID de sesión';

  @override
  String get release_core_workspace_registry_title => 'Título';

  @override
  String get release_core_workspace_label_terminals => 'Terminales';

  @override
  String get release_core_workspace_label_copy_id => 'Copiar ID de sesión';

  @override
  String get release_core_workspace_label_contributions => 'Contribuciones';

  @override
  String get release_core_workspace_owner_inactive =>
      'El propietario de este espacio de trabajo ya no está activo.';

  @override
  String get release_core_workspace_select_chat =>
      'Selecciona primero un chat.';

  @override
  String get release_core_workspace_chat_unavailable =>
      'Este chat no está disponible para esta conexión.';

  @override
  String get release_core_workspace_page_unavailable =>
      'Esta página no está disponible para esta conexión.';

  @override
  String release_core_client_queue_count(int count) {
    return '$count en cola';
  }

  @override
  String release_core_client_queue_paused_count(int count) {
    return '$count en cola — en pausa';
  }

  @override
  String release_core_git_diff_truncated(String diff) {
    return '$diff\n… truncado';
  }

  @override
  String get release_core_search_no_models =>
      'Hermes no ha devuelto ningún modelo configurado que se pueda seleccionar.';

  @override
  String get release_core_chat_archive_unavailable =>
      'La acción de archivar el chat no está disponible.';

  @override
  String get release_core_chat_pin_unconfirmed =>
      'No se ha confirmado el estado de fijación.';

  @override
  String get release_core_chat_archive_unconfirmed =>
      'No se ha confirmado el estado de archivo.';

  @override
  String get release_core_chat_archive_history_unavailable =>
      'Historial archivado no disponible';

  @override
  String get release_core_quick_chat_history_unavailable =>
      'Historial del chat rápido no disponible';

  @override
  String get release_core_chat_project_ownership_unavailable =>
      'Propiedad del proyecto no disponible';

  @override
  String get release_core_chat_unknown_project => 'Proyecto desconocido';

  @override
  String get release_core_chat_local_search_fallback =>
      'Búsqueda de mensajes no disponible. Se muestran las coincidencias locales.';

  @override
  String release_core_fleet_update_eligible(String version) {
    return 'Apta · $version';
  }

  @override
  String get release_core_fleet_update_state_1 => 'Omitida: misma instalación';

  @override
  String get release_core_fleet_update_state_2 => 'Sin comprobar';

  @override
  String get release_core_fleet_update_state_3 =>
      'Omitida: gestionada por Cloud';

  @override
  String get release_core_fleet_update_state_4 =>
      'Omitida: no registrada como pasarela directa';

  @override
  String get release_core_fleet_update_state_5 =>
      'Omitida: desconectada u ocupada';

  @override
  String get release_core_fleet_update_state_6 =>
      'No hay ninguna actualización aplicable';

  @override
  String get release_core_fleet_update_state_7 =>
      'No se pudo verificar si es apta';

  @override
  String get release_core_fleet_update_state_8 =>
      'Omitida: desactualizada, ocupada o ya solicitada';

  @override
  String get release_core_fleet_update_state_9 => 'Solicitando';

  @override
  String get release_core_fleet_update_state_10 =>
      'Aceptada; comprobante no disponible';

  @override
  String get release_core_fleet_update_state_11 =>
      'Aceptada; esperando comprobante';

  @override
  String get release_core_fleet_update_state_12 =>
      'Omitida: hay un chat en ejecución en esta instalación';

  @override
  String get release_core_fleet_update_state_13 =>
      'Sin confirmar; no reenviar automáticamente';

  @override
  String get release_core_fleet_update_state_14 =>
      'Vuelve a conectar para comprobar el comprobante';

  @override
  String get release_core_fleet_update_state_15 => 'Comprobante no disponible';

  @override
  String get release_core_fleet_update_state_16 =>
      'Esperando comprobante coincidente';

  @override
  String get release_core_fleet_update_state_17 =>
      'Actualizada; se requiere seguimiento';

  @override
  String get release_core_fleet_update_state_19 => 'Actualizada parcialmente';

  @override
  String get release_core_fleet_update_state_20 =>
      'La actualización ha fallado';

  @override
  String get release_core_fleet_update_state_21 => 'Sin confirmar';

  @override
  String get release_core_cloud_status_ready => 'Listo';

  @override
  String get release_core_cloud_status_online => 'En línea';

  @override
  String get release_core_cloud_status_stopped => 'Detenido';

  @override
  String get release_core_cloud_status_error => 'Error';

  @override
  String get ng_release_more_contributions_subtitle =>
      'Tarjetas de respuesta revisadas para esta conexión';

  @override
  String get ng_release_more_gateway_fleet => 'Flota de pasarelas';

  @override
  String get ng_release_more_memory_graph => 'Grafo de memoria';

  @override
  String get ng_release_more_memory_graph_subtitle =>
      'Cronología, ediciones y proveedores de memoria';

  @override
  String get ng_release_more_capabilities_subtitle =>
      'Instala y administra habilidades, plugins, conectores y backends de herramientas';

  @override
  String get ng_release_more_browser_vault => 'Bóveda del navegador';

  @override
  String get ng_release_more_browser_vault_subtitle =>
      'Inicios de sesión en sitios, direcciones, tarjetas y fuentes de credenciales';

  @override
  String get ng_release_more_agent_policy => 'Política del agente';

  @override
  String get ng_release_more_agent_policy_subtitle =>
      'Aprobaciones, puntos de control, acceso al navegador y métricas compartidas';

  @override
  String get ng_release_more_schedules => 'Programaciones';

  @override
  String get ng_release_more_schedules_subtitle =>
      'Todos los perfiles, plantillas, recuperación de ejecuciones omitidas y detención';

  @override
  String get ng_release_more_host_subtitle =>
      'Registros remotos, estado, mantenimiento y actualización';

  @override
  String get ng_release_more_providers_routes => 'Proveedores y rutas';

  @override
  String get ng_release_more_providers_routes_subtitle =>
      'Claves, endpoints, delegación y mezclas';

  @override
  String get ng_release_more_credits_plans => 'Créditos y planes';

  @override
  String get ng_release_more_credits_plans_subtitle =>
      'Facturación de Nous con consentimiento cuando la cuenta lo permite';

  @override
  String get ng_release_sign_in_or => 'o';

  @override
  String ng_release_deployment_sign_in_hint(String message) {
    return '$message Aún puedes iniciar sesión con un token de sesión del despliegue en el siguiente paso.';
  }

  @override
  String get ng_release_message_search_unavailable =>
      'Búsqueda de mensajes no disponible. Se muestran las coincidencias locales.';

  @override
  String ng_release_insights_days(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '$days día',
    );
    return '$_temp0';
  }

  @override
  String get ng_release_signed_in_you => 'tú';

  @override
  String get release_chat_unsent_prompt_gone =>
      'Ese prompt sin enviar ya no está en la cola.';

  @override
  String ng_release_attachment_not_attached(String name) {
    return 'La pasarela no ha adjuntado $name.';
  }

  @override
  String get ng_release_gateway_not_connected =>
      'Aún no hay conexión con la pasarela.';

  @override
  String get ng_release_gateway_unreachable =>
      'No se pudo acceder a la pasarela.';

  @override
  String get ng_release_projects_scope_changed =>
      'El ámbito de proyectos ya no está seleccionado';

  @override
  String get ng_release_missing_providers => 'Faltan proveedores';

  @override
  String get ng_release_missing_tasks => 'Faltan tareas';

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
    return '${count}sem';
  }

  @override
  String ng_release_age_years(int count) {
    return '${count}a';
  }

  @override
  String ng_release_compact_billions(String count) {
    return '$count mil M';
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
  String get ng_release_notification_foreground => 'Ares estaba en pantalla';

  @override
  String get ng_release_notification_stopped => 'se detuvo el turno';

  @override
  String get ng_release_more_parallel_workspace =>
      'Espacio de trabajo en paralelo';

  @override
  String get ng_release_more_parallel_workspace_subtitle =>
      'Abre varios chats en pestañas o uno al lado del otro.';

  @override
  String get release_chat_unknown_model => 'desconocido';

  @override
  String release_chat_profile_default(String model) {
    return 'Predeterminado del perfil: $model';
  }

  @override
  String release_chat_profile_default_provider(String model, String provider) {
    return 'Predeterminado del perfil: $model • $provider';
  }

  @override
  String get release_chat_choose_provider =>
      'Este modelo está disponible a través de varios proveedores. Elige uno para continuar.';

  @override
  String get release_chat_slash_needs_gateway =>
      'Los comandos con barra requieren la pasarela de Desktop';

  @override
  String get release_chat_recovering_without_resending =>
      'Recuperando sin reenviar';

  @override
  String get release_chat_live_request_unreachable =>
      'Lo siento, no he podido contactar con Hermes para esa solicitud.';

  @override
  String release_chat_live_working(String tool) {
    return 'Hermes está trabajando: $tool. Aún no ha terminado.';
  }

  @override
  String get release_chat_live_finished_without_spoken_result =>
      'Hermes ha terminado esa solicitud sin un resultado hablado.';

  @override
  String get release_chat_reply_language_unavailable =>
      'El idioma de respuesta seleccionado no está disponible';

  @override
  String get release_chat_reply_voice_unavailable =>
      'La voz de respuesta seleccionada no está disponible';

  @override
  String get release_chat_reply_voice_configuration_unavailable =>
      'La configuración de la voz de respuesta no está disponible';

  @override
  String get release_chat_notification_review_action =>
      'Abre el chat para revisar la acción solicitada.';

  @override
  String get release_chat_notification_respond =>
      'Abre el chat para responder.';

  @override
  String get release_chat_start_new_main_window =>
      'Inicia un nuevo chat en la ventana principal.';

  @override
  String get release_chat_no_desktop_gateway => 'No hay pasarela de Desktop';

  @override
  String get release_chat_attachment_preparation_cancelled =>
      'Se ha cancelado la preparación del archivo adjunto.';

  @override
  String get release_chat_approval_authority_revoked =>
      'Se ha revocado la autoridad de aprobación.';

  @override
  String get release_chat_gateway_session_disconnected =>
      'La sesión de la pasarela de Desktop ya no está conectada';

  @override
  String get release_chat_stop_requested =>
      'Se ha solicitado la detención. Esperando a que Hermes termine.';

  @override
  String release_chat_stop_request_failed(String error) {
    return 'No se pudo solicitar la detención: $error';
  }

  @override
  String get release_chat_queued_prompt_not_sent =>
      'El prompt en cola no se ha enviado.';

  @override
  String get release_chat_running_turn_unreachable =>
      'No se pudo acceder al turno en curso. Volviendo a conectar sin reenviar.';

  @override
  String get release_chat_wait_for_composer =>
      'Espera a que el editor de mensajes esté disponible.';

  @override
  String get release_chat_find_in_transcript => 'Buscar en la transcripción';

  @override
  String get release_chat_open_browser_preview =>
      'Abrir vista previa del navegador';

  @override
  String get release_chat_more_tools => 'Más herramientas del chat';

  @override
  String get release_chat_queue_until_finished =>
      'Poner en cola hasta que termine este turno';

  @override
  String get release_chat_format_bold => 'Negrita';

  @override
  String get release_chat_format_italic => 'Cursiva';

  @override
  String get ng_release_chat_gateway_queue_requirements =>
      'La cola de la pasarela requiere un chat vinculado y un prompt solo de texto.';

  @override
  String get ng_release_chat_start_new_main_screen =>
      'Inicia un nuevo chat desde la pantalla principal de chats.';

  @override
  String get ng_release_chat_image => 'imagen';

  @override
  String ng_release_chat_tool_seconds(String seconds) {
    return '${seconds}s';
  }

  @override
  String get release_preview_chat_changed =>
      'El chat ha cambiado. Vuelve a conectar la vista previa para continuar.';

  @override
  String get release_preview_authenticating_chat => 'Autenticando chat…';

  @override
  String release_preview_unavailable_reason(String reason) {
    return 'Vista previa no disponible: $reason';
  }

  @override
  String get release_preview_operation_failed =>
      'La operación de vista previa ha fallado.';

  @override
  String get release_preview_added_to_draft =>
      'Añadido al borrador. No se ha enviado nada.';

  @override
  String get release_preview_open_site_title => '¿Abrir este sitio?';

  @override
  String release_preview_open_site_body(String origin) {
    return '$origin\n\nEl modo de lectura solo carga este documento. No comparte cookies, datos de inicio de sesión ni la página con Hermes.';
  }

  @override
  String get release_preview_open_site => 'Abrir sitio';

  @override
  String get release_preview_discard_pins_title =>
      '¿Descartar los marcadores aún no añadidos al borrador?';

  @override
  String get release_preview_keep_pins => 'Conservar marcadores';

  @override
  String get release_preview_share_page_title =>
      '¿Compartir esta página con este chat?';

  @override
  String release_preview_share_page_body(String origin) {
    return 'Hermes puede leer el texto mostrado y la lista de elementos de $origin, y desplazarse por este panel. Al navegar se deja de compartir. No se comparten formularios ni credenciales.';
  }

  @override
  String get release_preview_share_page => 'Compartir página';

  @override
  String release_preview_comment_number(int number) {
    return 'Comentario n.º $number';
  }

  @override
  String get release_preview_note => 'Nota';

  @override
  String get release_preview_keep_pin => 'Conservar marcador';

  @override
  String get release_preview_title => 'Vista previa del navegador';

  @override
  String get release_preview_hide => 'Ocultar vista previa';

  @override
  String get release_preview_close_and_forget => 'Cerrar y olvidar página';

  @override
  String get release_preview_site_address => 'Dirección del sitio';

  @override
  String get release_preview_go_to_address => 'Ir a la dirección';

  @override
  String get release_preview_forward => 'Adelante';

  @override
  String get release_preview_reload => 'Volver a cargar';

  @override
  String get release_preview_share_with_hermes => 'Compartir página con Hermes';

  @override
  String get release_preview_stop_sharing => 'Dejar de compartir página';

  @override
  String get release_preview_annotate => 'Anotar elemento o región';

  @override
  String get release_preview_reader_console => 'Consola del lector';

  @override
  String get release_preview_reconnect => 'Volver a conectar vista previa';

  @override
  String get release_preview_reader_mode_help =>
      'Modo de lectura: HTML y texto. Sin scripts, recursos incrustados ni perfil de navegador con sesión iniciada.';

  @override
  String release_preview_sharing_origin(String origin) {
    return 'Compartiendo el lector con este chat: $origin';
  }

  @override
  String get release_preview_annotation_help =>
      'Toca un elemento o arrastra para delimitar una región y comentarla.';

  @override
  String get release_preview_reader_requests =>
      'Solicitudes del lector (JavaScript está desactivado)';

  @override
  String release_preview_selected_requests(int count) {
    return '$count seleccionadas · JavaScript está desactivado';
  }

  @override
  String get release_preview_copy_all => 'Copiar todo';

  @override
  String get release_preview_copy_selected => 'Copiar selección';

  @override
  String get release_preview_add_log_to_draft => 'Añadir registro al borrador';

  @override
  String release_preview_requests_draft(String log) {
    return 'Solicitudes del lector:\n$log';
  }

  @override
  String release_preview_add_pins_to_draft(int count) {
    return 'Añadir $count al borrador';
  }

  @override
  String release_preview_request_loaded(String origin, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos del lector',
      one: '$count elemento del lector',
    );
    return 'HTTP 200 · $origin · $_temp0';
  }

  @override
  String release_preview_annotation_intro(String origin) {
    return 'Revisa estos comentarios sobre la vista previa de $origin. Los recortes adjuntos están numerados en el mismo orden.';
  }

  @override
  String get release_preview_reader_region => 'región del lector';

  @override
  String get release_preview_capture_failed =>
      'No se pudieron capturar estos píxeles.';

  @override
  String get release_preview_address_not_approved =>
      'Esta dirección está fuera del origen aprobado para la vista previa.';

  @override
  String get release_preview_page_limit =>
      'La página supera el límite del lector.';

  @override
  String get release_preview_page_unreadable => 'No se pudo leer la página.';

  @override
  String get release_preview_page_complex =>
      'Esta página es demasiado compleja para el modo de lectura.';

  @override
  String release_preview_http_failed(int statusCode) {
    return 'HTTP $statusCode. No se ha seguido ninguna redirección ni inicio de sesión.';
  }

  @override
  String get release_preview_unsupported_type =>
      'En el modo de lectura solo se pueden abrir HTML y texto sin formato.';

  @override
  String get release_preview_load_insecure =>
      'No se pudo cargar el sitio de forma segura.';

  @override
  String get release_preview_crop_limit =>
      'El recorte de la vista previa supera su límite.';

  @override
  String get release_preview_image_unreadable =>
      'La imagen seleccionada está vacía o no se puede leer.';

  @override
  String get release_preview_image_budget =>
      'La imagen seleccionada supera el límite de 64 MiB del borrador.';

  @override
  String get release_preview_image_format =>
      'Formato de imagen no compatible. Elige una imagen JPEG, PNG o WebP.';

  @override
  String get release_preview_image_decode =>
      'No se pudo descodificar de forma segura la imagen JPEG, PNG o WebP seleccionada.';

  @override
  String get release_preview_image_sanitize =>
      'No se pudo sanear esta imagen. Elige una imagen JPEG, PNG o WebP válida.';

  @override
  String get release_preview_draft_budget =>
      'Los archivos adjuntos tienen un límite total de 64 MiB por borrador.';

  @override
  String get release_preview_generic_file_limit =>
      'Los archivos genéricos tienen un límite de 16 MiB cada uno.';

  @override
  String get release_preview_image_not_sanitized =>
      'Las imágenes remotas deben sanearse antes de subirlas.';

  @override
  String get release_preview_stage_failed =>
      'No se pudieron añadir las pruebas de la vista previa al borrador. Inténtalo de nuevo.';

  @override
  String get release_misc_find_hermes_on_lan => 'Buscar Hermes en la LAN';

  @override
  String release_misc_discovery_failed(String error) {
    return 'La detección ha fallado: $error';
  }

  @override
  String get release_misc_no_lan_servers =>
      'No se han encontrado servidores de Hermes en la red local.';

  @override
  String release_misc_api_key_rejected(String endpoint, int statusCode) {
    return '$endpoint ha rechazado la clave de API (HTTP $statusCode).';
  }

  @override
  String get release_misc_api_key_required =>
      'El servidor requiere una clave de API. Introduce tu API_SERVER_KEY.';

  @override
  String release_misc_gateway_not_found(String endpoint) {
    return 'El endpoint $endpoint de la pasarela ha devuelto HTTP 404. Comprueba el prefijo de ruta de la pasarela y las rutas del proxy inverso.';
  }

  @override
  String release_misc_gateway_http_error(String endpoint, int statusCode) {
    return 'El endpoint $endpoint de la pasarela ha devuelto HTTP $statusCode.';
  }

  @override
  String release_misc_gateway_unreachable(String endpoint) {
    return 'No se puede acceder al endpoint $endpoint de la pasarela.';
  }

  @override
  String get release_core_schedule_invalid_delivery_target =>
      'Destino de entrega no válido';

  @override
  String get release_core_file_save_direct_only =>
      'Solo se puede guardar un archivo situado directamente en el directorio de trabajo.';

  @override
  String get release_core_file_save_hidden =>
      'La puerta de enlace no puede guardar archivos ocultos.';

  @override
  String get rel_admin_choose_provider => 'Elige un proveedor y un modelo.';

  @override
  String get rel_admin_known_effort => 'Elige un nivel de esfuerzo conocido.';

  @override
  String get rel_admin_endpoint_name_required =>
      'Introduce un nombre para este punto de conexión.';

  @override
  String get rel_admin_endpoint_model_required =>
      'Introduce el modelo que ofrece este punto de conexión.';

  @override
  String get rel_admin_known_api_mode =>
      'Elige Automático o un modo de API conocido.';

  @override
  String get rel_admin_endpoint_id_invalid =>
      'Este identificador de punto de conexión no se puede usar.';

  @override
  String get rel_admin_endpoint_https =>
      'Usa HTTPS para un punto de conexión remoto o HTTP en localhost.';

  @override
  String get rel_admin_key_invalid => 'No se puede guardar esa clave de API.';

  @override
  String get rel_admin_response_shape =>
      'La respuesta de la puerta de enlace no tenía la estructura esperada.';

  @override
  String get rel_admin_limits_required =>
      'Introduce los límites de iteraciones, concurrencia y tiempo de espera antes de guardar.';

  @override
  String get rel_admin_route_required =>
      'Cada ruta necesita un nombre y un modelo para poder guardarse.';

  @override
  String get rel_admin_route_unique =>
      'Los nombres de las rutas deben ser únicos.';

  @override
  String get rel_admin_route_default_invalid =>
      'La ruta predeterminada debe ser una de las rutas guardadas.';

  @override
  String get rel_admin_policy_required =>
      'Elige una política con avisos o silenciosa para referencias degradadas.';

  @override
  String get rel_admin_mixture_missing =>
      'La puerta de enlace no devolvió una mezcla activa.';

  @override
  String get rel_admin_mixture_slots_required =>
      'Indica un proveedor y un modelo para el agregador y cada referencia.';

  @override
  String get rel_admin_chat_id_required =>
      'Introduce el ID del chat al que se aplica este cambio.';

  @override
  String rel_admin_http_error(String status) {
    return 'La puerta de enlace devolvió HTTP $status.';
  }

  @override
  String get rel_admin_response_unreadable =>
      'No se pudo leer la respuesta de la puerta de enlace.';

  @override
  String get rel_admin_connect_before_change =>
      'Conecta la sesión en vivo de la puerta de enlace antes de cambiar la facturación o un chat.';

  @override
  String get rel_admin_operation_unavailable =>
      'Esta puerta de enlace no ofrece esa operación.';

  @override
  String get rel_admin_key_required =>
      'Introduce la clave que quieres guardar.';

  @override
  String get rel_admin_key_save_failed =>
      'La puerta de enlace no guardó esa clave.';

  @override
  String get rel_admin_key_clear_required =>
      'Elige una clave de proveedor para borrarla.';

  @override
  String get rel_admin_key_clear_failed =>
      'La puerta de enlace no borró esa clave.';

  @override
  String get rel_admin_endpoint_save_failed =>
      'La puerta de enlace no guardó ese punto de conexión.';

  @override
  String get rel_admin_endpoint_activate_failed =>
      'La puerta de enlace no activó ese punto de conexión.';

  @override
  String get rel_admin_accounts_secure_required =>
      'Las cuentas de proveedores necesitan una puerta de enlace HTTPS autenticada o localhost.';

  @override
  String get rel_admin_accounts_read_failed =>
      'No se pudieron leer las cuentas de proveedores.';

  @override
  String get rel_admin_account_disconnect_failed =>
      'La puerta de enlace no desconectó esa cuenta.';

  @override
  String get rel_admin_account_not_disconnectable =>
      'No se puede desconectar esa cuenta de proveedor.';

  @override
  String get rel_admin_backend_required =>
      'Elige uno de los motores de delegación disponibles.';

  @override
  String get rel_admin_backend_save_failed =>
      'La puerta de enlace no seleccionó ese motor.';

  @override
  String get rel_admin_routes_save_failed =>
      'La puerta de enlace no guardó esas rutas.';

  @override
  String get rel_admin_profile_route_required =>
      'Cada ruta de perfil necesita un nombre de perfil.';

  @override
  String get rel_admin_profile_route_unique =>
      'Las rutas de perfil deben ser únicas.';

  @override
  String get rel_admin_profile_route_default_invalid =>
      'La ruta de perfil predeterminada debe ser uno de los perfiles permitidos.';

  @override
  String get rel_admin_profile_routes_save_failed =>
      'La puerta de enlace no guardó esas rutas de perfil.';

  @override
  String get rel_admin_limits_save_failed =>
      'La puerta de enlace no guardó esos límites.';

  @override
  String get rel_admin_mixture_save_failed =>
      'La puerta de enlace no guardó esa mezcla.';

  @override
  String get rel_admin_credit_amount_required =>
      'Elige uno de los importes de crédito ofrecidos.';

  @override
  String get rel_admin_charge_check_failed => 'No se pudo comprobar ese cargo.';

  @override
  String get rel_admin_reload_amounts_missing =>
      'No se proporcionaron los importes de recarga automática, por lo que no se cambiaron.';

  @override
  String get rel_admin_plan_required => 'Elige primero un plan.';

  @override
  String get rel_admin_plan_scheduled_only =>
      'Desde aquí solo se puede confirmar un cambio de plan programado.';

  @override
  String get rel_admin_billing_refused =>
      'La puerta de enlace rechazó esta solicitud de facturación.';

  @override
  String get rel_admin_request_refused =>
      'La puerta de enlace rechazó esta solicitud.';

  @override
  String get rel_admin_endpoint_answered => 'El punto de conexión respondió.';

  @override
  String get rel_admin_endpoint_no_answer =>
      'El punto de conexión no respondió.';

  @override
  String get rel_admin_charge_unknown =>
      'Se desconoce el resultado del cargo. Aún podría liquidarse. Consulta el portal antes de reintentar.';

  @override
  String get rel_admin_connect_before_billing =>
      'Conecta la sesión en vivo de la puerta de enlace antes de consultar la facturación. No se cobra nada desde esta página.';

  @override
  String get rel_admin_preset_required =>
      'Guarda un preajuste antes de aplicarlo.';

  @override
  String get rel_admin_cancel => 'Cancelar';

  @override
  String get rel_admin_refresh => 'Actualizar';

  @override
  String get rel_admin_credits_and_plans => 'Créditos y planes';

  @override
  String get rel_admin_saved => 'Guardado';

  @override
  String get rel_admin_name => 'Nombre';

  @override
  String get rel_admin_base_url => 'URL base';

  @override
  String get rel_admin_model => 'Modelo';

  @override
  String get rel_admin_signed_in => 'Sesión iniciada';

  @override
  String get rel_admin_not_signed_in => 'Sesión no iniciada';

  @override
  String get rel_admin_provider => 'Proveedor';

  @override
  String get rel_admin_apply_to_this_chat => 'Aplicar a este chat';

  @override
  String get rel_admin_auto => 'Automático';

  @override
  String get rel_admin_chat_completions => 'Completados de chat';

  @override
  String get rel_admin_codex_responses => 'Respuestas de Codex';

  @override
  String get rel_admin_anthropic_messages => 'Mensajes de Anthropic';

  @override
  String get rel_admin_could_not_complete_that_request =>
      'No se pudo completar esa solicitud.';

  @override
  String get rel_admin_confirm => 'Confirmar';

  @override
  String get rel_admin_providers_and_billing => 'Proveedores y facturación';

  @override
  String get rel_admin_api_keys => 'Claves de API';

  @override
  String get rel_admin_custom_endpoints => 'Puntos de conexión personalizados';

  @override
  String get rel_admin_provider_accounts => 'Cuentas de proveedores';

  @override
  String get rel_admin_effort_and_speed_presets =>
      'Preajustes de esfuerzo y velocidad';

  @override
  String get rel_admin_delegation => 'Delegación';

  @override
  String get rel_admin_mixture_of_agents => 'Mezcla de agentes';

  @override
  String get rel_admin_no_provider_keys_were_reported_for_this_profile =>
      'No se notificaron claves de proveedores para este perfil.';

  @override
  String get rel_admin_not_saved => 'Sin guardar';

  @override
  String get rel_admin_new_key_value => 'Nuevo valor de clave';

  @override
  String get rel_admin_provider_key_saved => 'Clave del proveedor guardada.';

  @override
  String get rel_admin_save_key => 'Guardar clave';

  @override
  String get rel_admin_clear_provider_key => 'Borrar clave del proveedor';

  @override
  String get rel_admin_provider_key_cleared => 'Clave del proveedor borrada.';

  @override
  String get rel_admin_clear_key => 'Borrar clave';

  @override
  String get rel_admin_new_endpoint => 'Nuevo punto de conexión';

  @override
  String get rel_admin_api_key => 'Clave de API';

  @override
  String get rel_admin_leave_blank_to_keep_a_key_this_endpoint_already_has =>
      'Déjalo en blanco para conservar la clave que ya tiene este punto de conexión.';

  @override
  String get rel_admin_reachable => 'Accesible';

  @override
  String get rel_admin_unreachable => 'Inaccesible';

  @override
  String get rel_admin_test_endpoint => 'Probar punto de conexión';

  @override
  String get rel_admin_endpoint_saved => 'Punto de conexión guardado.';

  @override
  String get rel_admin_save_endpoint => 'Guardar punto de conexión';

  @override
  String get rel_admin_use_this_endpoint => 'Usar este punto de conexión';

  @override
  String
  get rel_admin_make_this_named_endpoint_the_current_model_for_this_profile =>
      '¿Establecer este punto de conexión con nombre como modelo actual de este perfil?';

  @override
  String get rel_admin_endpoint_is_now_current =>
      'El punto de conexión es ahora el actual.';

  @override
  String get rel_admin_use_endpoint => 'Usar punto de conexión';

  @override
  String get rel_admin_delete_endpoint => 'Eliminar punto de conexión';

  @override
  String get rel_admin_delete_this_named_endpoint_from_the_profile =>
      '¿Eliminar este punto de conexión con nombre del perfil?';

  @override
  String get rel_admin_endpoint_deleted => 'Punto de conexión eliminado.';

  @override
  String get rel_admin_signing_in_stays_on_the_provider_sign_in_screen =>
      'El inicio de sesión se realiza en la pantalla del proveedor. La desconexión solo se ejecuta cuando esta puerta de enlace indica que la cuenta se puede eliminar.';

  @override
  String get rel_admin_disconnect_this_provider_account_on_the_gateway =>
      '¿Desconectar esta cuenta de proveedor en la puerta de enlace?';

  @override
  String get rel_admin_provider_account_disconnected =>
      'Cuenta del proveedor desconectada.';

  @override
  String get rel_admin_disconnect => 'Desconectar';

  @override
  String get rel_admin_not_disconnectable => 'No se puede desconectar';

  @override
  String get rel_admin_fast => 'Rápido';

  @override
  String get rel_admin_preset_saved_for_this_model =>
      'Preajuste guardado para este modelo.';

  @override
  String get rel_admin_save_preset => 'Guardar preajuste';

  @override
  String get rel_admin_chat_id => 'ID del chat';

  @override
  String get rel_admin_apply_preset => 'Aplicar preajuste';

  @override
  String get rel_admin_set_this_chat_s_effort_and_speed_from_the_saved_preset =>
      '¿Establecer el esfuerzo y la velocidad de este chat según el preajuste guardado?';

  @override
  String get rel_admin_preset_applied_to_this_chat =>
      'Preajuste aplicado a este chat.';

  @override
  String get rel_admin_this_route_sends_the_picked_effort_unchanged =>
      'Esta ruta envía el esfuerzo elegido sin cambios.';

  @override
  String get rel_admin_show_route_clamp => 'Mostrar límite de la ruta';

  @override
  String get rel_admin_delegation_backend => 'Motor de delegación';

  @override
  String get rel_admin_delegation_backend_saved =>
      'Motor de delegación guardado.';

  @override
  String get rel_admin_save_backend => 'Guardar motor';

  @override
  String get rel_admin_max_iterations => 'Máximo de iteraciones';

  @override
  String get rel_admin_max_concurrent_children =>
      'Máximo de agentes secundarios simultáneos';

  @override
  String get rel_admin_child_timeout_seconds =>
      'Tiempo de espera del agente secundario en segundos';

  @override
  String get rel_admin_delegation_effort_leave_unchanged =>
      'Esfuerzo de delegación, dejar sin cambios';

  @override
  String get rel_admin_delegation_limits_saved =>
      'Límites de delegación guardados.';

  @override
  String get rel_admin_save_limits => 'Guardar límites';

  @override
  String get rel_admin_remove_route => 'Quitar ruta';

  @override
  String get rel_admin_route_name => 'Nombre de ruta';

  @override
  String get rel_admin_route_provider => 'Proveedor de ruta';

  @override
  String get rel_admin_route_model => 'Modelo de ruta';

  @override
  String get rel_admin_route_effort_unchanged => 'Esfuerzo de ruta sin cambios';

  @override
  String get rel_admin_add_route => 'Añadir ruta';

  @override
  String get rel_admin_default_route => 'Ruta predeterminada';

  @override
  String get rel_admin_delegation_routes_saved =>
      'Rutas de delegación guardadas.';

  @override
  String get rel_admin_save_routes => 'Guardar rutas';

  @override
  String get rel_admin_profile_routes_saved => 'Rutas de perfil guardadas.';

  @override
  String get rel_admin_save_profile_routes => 'Guardar rutas de perfil';

  @override
  String get rel_admin_no_mixture_is_loaded => 'No hay ninguna mezcla cargada.';

  @override
  String get rel_admin_mixture_enabled => 'Mezcla activada';

  @override
  String get rel_admin_loud_degraded_references =>
      'Referencias degradadas con avisos';

  @override
  String get rel_admin_silent_degraded_references =>
      'Referencias degradadas sin avisos';

  @override
  String get rel_admin_aggregator => 'Agregador';

  @override
  String get rel_admin_aggregator_provider => 'Proveedor del agregador';

  @override
  String get rel_admin_aggregator_model => 'Modelo del agregador';

  @override
  String get rel_admin_reference_provider => 'Proveedor de referencia';

  @override
  String get rel_admin_reference_model => 'Modelo de referencia';

  @override
  String get rel_admin_add_reference_model => 'Añadir modelo de referencia';

  @override
  String get rel_admin_mixture_saved => 'Mezcla guardada.';

  @override
  String get rel_admin_save_mixture => 'Guardar mezcla';

  @override
  String get rel_admin_credit_purchase_submitted =>
      'Compra de créditos enviada.';

  @override
  String get rel_admin_credit_purchase_settled =>
      'Compra de créditos liquidada.';

  @override
  String get rel_admin_credit_and_plan_changes_wait_for_confirmation_a_plan =>
      'Los cambios de créditos y planes requieren confirmación. Un plan con cobro inmediato se muestra aquí, pero no se confirma.';

  @override
  String get rel_admin_buy_credits => 'Comprar créditos';

  @override
  String get rel_admin_retry_same_charge => 'Reintentar el mismo cargo';

  @override
  String get rel_admin_retry_the_same_credit_charge_this_does_not_start =>
      'Reintenta el mismo cargo de créditos. Esto no inicia una segunda compra.';

  @override
  String get rel_admin_credit_purchases_are_not_available_for_this_account =>
      'La compra de créditos no está disponible para esta cuenta.';

  @override
  String get rel_admin_auto_reload => 'Recarga automática';

  @override
  String get rel_admin_read_only_until_this_account_can_charge =>
      'Solo lectura hasta que esta cuenta pueda realizar cargos.';

  @override
  String get rel_admin_auto_reload_updated => 'Recarga automática actualizada.';

  @override
  String get rel_admin_keep_going_on_credits => 'Continuar con créditos';

  @override
  String get rel_admin_continue_on_credits_when_the_plan_window_is_used_up =>
      '¿Continuar con créditos cuando se agote la cuota del período del plan?';

  @override
  String
  get rel_admin_stop_continuing_on_credits_when_the_plan_window_is_used_up =>
      '¿Dejar de continuar con créditos cuando se agote la cuota del período del plan?';

  @override
  String get rel_admin_credit_continuation_updated =>
      'Continuación con créditos actualizada.';

  @override
  String get rel_admin_this_plan_change_is_not_confirmed_from_ares =>
      'Este cambio de plan no se confirma desde Ares.';

  @override
  String get rel_admin_this_change_is_scheduled_confirm_to_apply_it =>
      'Este cambio está programado. Confirma para aplicarlo.';

  @override
  String get rel_admin_preview_plan => 'Vista previa del plan';

  @override
  String get rel_admin_schedule_plan_change => 'Programar cambio de plan';

  @override
  String get rel_admin_plan_change_scheduled => 'Cambio de plan programado.';

  @override
  String get rel_admin_confirm_scheduled_plan_change =>
      'Confirmar cambio de plan programado';

  @override
  String rel_admin_remove_key_confirm(String key) {
    return '¿Quitar el valor guardado de $key de este perfil?';
  }

  @override
  String rel_admin_current_endpoint(String name) {
    return '$name · actual';
  }

  @override
  String rel_admin_endpoint_result(
    String status,
    String transport,
    String count,
    String message,
  ) {
    return '$status · $transport · $count modelos. $message';
  }

  @override
  String rel_admin_disconnect_account(String name) {
    return 'Desconectar $name';
  }

  @override
  String rel_admin_delegation_blocked(String reason) {
    return 'La delegación está bloqueada: $reason';
  }

  @override
  String rel_admin_backend_unavailable(String name) {
    return '$name · no disponible';
  }

  @override
  String rel_admin_reference_number(String number) {
    return 'Referencia $number';
  }

  @override
  String rel_admin_reload_enable_confirm(String amount, String threshold) {
    return '¿Activar la recarga automática y cobrar $amount cuando el saldo baje de $threshold?';
  }

  @override
  String rel_admin_reload_disable_confirm(String amount, String threshold) {
    return '¿Desactivar la recarga automática? Actualmente cobra $amount cuando el saldo baja de $threshold.';
  }

  @override
  String get rel_admin_this_plan => 'este plan';

  @override
  String rel_admin_plan_confirm(String name) {
    return 'Programar $name. Se programa para el final del período actual. No se realiza ningún cargo ahora.';
  }

  @override
  String rel_admin_plan_confirm_price(String name, String price) {
    return 'Programar $name por $price. Se programa para el final del período actual. No se realiza ningún cargo ahora.';
  }

  @override
  String rel_admin_plan_confirm_when(String name, String when) {
    return 'Programar $name. Entra en vigor $when. No se realiza ningún cargo ahora.';
  }

  @override
  String rel_admin_plan_confirm_price_when(
    String name,
    String price,
    String when,
  ) {
    return 'Programar $name por $price. Entra en vigor $when. No se realiza ningún cargo ahora.';
  }

  @override
  String rel_admin_balance(String amount) {
    return 'Saldo $amount';
  }

  @override
  String rel_admin_buy_confirm(String amount) {
    return 'Cargar \$$amount al método de pago de esta cuenta de Nous. Esto gasta dinero real.';
  }

  @override
  String rel_admin_reload_portal(String url) {
    return 'Cambia la recarga automática en el portal: $url';
  }

  @override
  String rel_admin_team_portal(String url) {
    return 'Las suscripciones de equipo se cambian en el portal: $url';
  }

  @override
  String get rel_admin_effort_none => 'ninguno';

  @override
  String get rel_admin_effort_minimal => 'minimal';

  @override
  String get rel_admin_effort_low => 'bajo';

  @override
  String get rel_admin_effort_medium => 'medio';

  @override
  String get rel_admin_effort_high => 'alto';

  @override
  String get rel_admin_effort_xhigh => 'muy alto';

  @override
  String get rel_admin_effort_max => 'máximo';

  @override
  String get rel_admin_effort_ultra => 'ultraalto';

  @override
  String get rel_admin_auto_lower => 'Automático';

  @override
  String get rel_admin_create => 'Crear';

  @override
  String get rel_admin_prompt => 'Instrucción';

  @override
  String get rel_admin_new_profile_id => 'ID del nuevo perfil';

  @override
  String get rel_admin_this_operation_is_unavailable_on_this_gateway =>
      'Esta operación no está disponible en esta puerta de enlace.';

  @override
  String get rel_admin_access_denied_by_the_gateway =>
      'Acceso denegado por la puerta de enlace.';

  @override
  String get rel_admin_connection_changed_reopen_profiles =>
      'La conexión cambió. Vuelve a abrir Perfiles.';

  @override
  String
  get rel_admin_invalid_input_or_gateway_response_check_the_target_before =>
      'Entrada o respuesta de la puerta de enlace no válida. Comprueba el destino antes de reintentar.';

  @override
  String get rel_admin_could_not_verify_the_result_refresh_the_target_before =>
      'No se pudo verificar el resultado. Actualiza el destino antes de volver a intentarlo.';

  @override
  String get rel_admin_edit_soul_md => 'Editar SOUL.md';

  @override
  String get rel_admin_persona => 'Personalidad';

  @override
  String get rel_admin_persona_saved => 'Personalidad guardada.';

  @override
  String get rel_admin_not_set => 'sin establecer';

  @override
  String get rel_admin_enabled => 'Activado';

  @override
  String get rel_admin_keys_to_remove_comma_separated =>
      'Claves que quitar (separadas por comas)';

  @override
  String get rel_admin_saved_and_applied_by_the_gateway =>
      'Guardado y aplicado por la puerta de enlace.';

  @override
  String get rel_admin_saved_a_gateway_restart_may_be_required =>
      'Guardado. Puede ser necesario reiniciar la puerta de enlace.';

  @override
  String get rel_admin_create_signed_route => 'Crear ruta firmada';

  @override
  String get rel_admin_route_id => 'ID de ruta';

  @override
  String get rel_admin_signature => 'Firma';

  @override
  String get rel_admin_events_comma_separated =>
      'Eventos (separados por comas)';

  @override
  String get rel_admin_delivery_target => 'Destino de entrega';

  @override
  String get rel_admin_skills_comma_separated =>
      'Habilidades (separadas por comas)';

  @override
  String get rel_admin_delivery_mode => 'Modo de entrega';

  @override
  String get rel_admin_delivery_chat_id_optional =>
      'ID del chat de entrega (opcional)';

  @override
  String get rel_admin_hide_signing_secret => 'Ocultar secreto de firma';

  @override
  String get rel_admin_reveal_signing_secret => 'Mostrar secreto de firma';

  @override
  String get rel_admin_edit_persona => 'Editar personalidad';

  @override
  String get rel_admin_portable_profile_bundle => 'Paquete de perfil portátil';

  @override
  String get rel_admin_clone_profile => 'Clonar perfil';

  @override
  String get rel_admin_rename_display_label => 'Cambiar etiqueta visible';

  @override
  String get rel_admin_rename_profile => 'Renombrar perfil';

  @override
  String get rel_admin_new_name => 'Nuevo nombre';

  @override
  String get rel_admin_rename_verified => 'Cambio de nombre verificado.';

  @override
  String get rel_admin_delete_profile => 'Eliminar perfil';

  @override
  String get rel_admin_profile_id_to_delete => 'ID del perfil que eliminar';

  @override
  String get rel_admin_profile_deleted => 'Perfil eliminado.';

  @override
  String
  get rel_admin_profile_deleted_server_identity_cleanup_is_still_pending =>
      'Perfil eliminado. La limpieza de identidad del servidor sigue pendiente.';

  @override
  String get rel_admin_export_profile_archive => 'Exportar archivo de perfil';

  @override
  String get rel_admin_import_profile_archive => 'Importar archivo de perfil';

  @override
  String get rel_admin_import_a_trusted_profile =>
      'Importar un perfil de confianza';

  @override
  String get rel_admin_absolute_archive_path_on_gateway =>
      'Ruta absoluta del archivo en la puerta de enlace';

  @override
  String get rel_admin_messaging_channels => 'Canales de mensajería';

  @override
  String get rel_admin_dm_pairing_requests =>
      'Solicitudes de vinculación por mensaje directo';

  @override
  String get rel_admin_no_pending_or_approved_users =>
      'No hay usuarios pendientes ni aprobados.';

  @override
  String get rel_admin_legacy_pairing_no_verifiable_request_id_ask_the_user =>
      'Vinculación antigua: no hay un ID de solicitud verificable. Pide al usuario que se vincule de nuevo.';

  @override
  String get rel_admin_pairing_change_verified =>
      'Cambio de vinculación verificado.';

  @override
  String get rel_admin_create_telegram_bot_by_qr =>
      'Crear bot de Telegram por QR';

  @override
  String get rel_admin_create_telegram_bot => 'Crear bot de Telegram';

  @override
  String get rel_admin_bot_name => 'Nombre del bot';

  @override
  String get rel_admin_telegram_bot_creation_qr_code =>
      'Código QR de creación de bot de Telegram';

  @override
  String get rel_admin_check_telegram_pairing =>
      'Comprobar vinculación de Telegram';

  @override
  String get rel_admin_waiting_for_telegram => 'Esperando a Telegram.';

  @override
  String get rel_admin_apply_telegram_bot => 'Aplicar bot de Telegram';

  @override
  String get rel_admin_allowed_numeric_user_ids =>
      'ID numéricos de usuarios permitidos';

  @override
  String get rel_admin_saved_restart_still_required =>
      'Guardado. Aún se requiere reiniciar.';

  @override
  String get rel_admin_saved_gateway_restart_requested =>
      'Guardado; se solicitó reiniciar la puerta de enlace.';

  @override
  String get rel_admin_cancel_telegram_setup =>
      'Cancelar configuración de Telegram';

  @override
  String get rel_admin_inbound_webhooks => 'Webhooks entrantes';

  @override
  String get rel_admin_enable_webhook_service => 'Activar servicio de webhooks';

  @override
  String get rel_admin_enable_webhooks => 'Activar webhooks';

  @override
  String get rel_admin_enabled_restart_still_required =>
      'Activado. Aún se requiere reiniciar.';

  @override
  String get rel_admin_enabled_restart_requested =>
      'Activado; se solicitó reiniciar.';

  @override
  String get rel_admin_route_change_verified => 'Cambio de ruta verificado.';

  @override
  String get rel_admin_delete_route => 'Eliminar ruta';

  @override
  String get rel_admin_disable_route => 'Desactivar ruta';

  @override
  String get rel_admin_enable_route => 'Activar ruta';

  @override
  String get rel_admin_back_up_entire_agent_home =>
      'Crear copia de todo el directorio del agente';

  @override
  String get rel_admin_transfer_to_a_cloud_agent =>
      'Transferir a un agente de Cloud';

  @override
  String get rel_admin_check_backup_progress =>
      'Comprobar progreso de copia de seguridad';

  @override
  String get rel_admin_save_backup_to_this_device =>
      'Guardar copia de seguridad en este dispositivo';

  @override
  String get rel_admin_save_sensitive_full_home_archive =>
      'Guardar archivo confidencial de todo el directorio personal';

  @override
  String get rel_admin_save_cancelled => 'Guardado cancelado.';

  @override
  String get rel_admin_backup_saved => 'Copia de seguridad guardada.';

  @override
  String get rel_admin_up_to_32_mib_larger_archives_remain_on_the_gateway =>
      'Hasta 32 MiB. Los archivos mayores permanecen en la puerta de enlace.';

  @override
  String rel_admin_persona_scope(String scope) {
    return 'Guarda la personalidad de $scope.';
  }

  @override
  String rel_admin_configure_channel(String name) {
    return 'Configurar $name';
  }

  @override
  String rel_admin_channel_warning(String scope) {
    return 'Se aplica a $scope. Dejarlo en blanco conserva el valor existente. Para quitar un valor, indica su clave abajo.';
  }

  @override
  String rel_admin_hook_warning(String scope) {
    return 'Se aplica a $scope. Usa un nombre único. La puerta de enlace crea un secreto de firma. Si otro operador crea el nombre simultáneamente, el host puede sustituir esa ruta.';
  }

  @override
  String rel_admin_hook_created(String url) {
    return 'Se creó $url. Guarda el secreto de firma antes de salir.';
  }

  @override
  String rel_admin_clone_warning(String scope) {
    return 'Copia ajustes, habilidades, personalidad y posiblemente credenciales de proveedores de $scope. No se solicitan tokens de mensajería.';
  }

  @override
  String rel_admin_cloned(String source, String destination) {
    return 'Se clonó $source a $destination.';
  }

  @override
  String rel_admin_rename_target(String name) {
    return 'Renombrar $name';
  }

  @override
  String rel_admin_rename_label_warning(String scope) {
    return 'Cambia la etiqueta visible de $scope. Su ID sigue siendo default.';
  }

  @override
  String rel_admin_rename_warning(String scope) {
    return 'Renombra $scope en el servidor. Una puerta de enlace en ejecución puede detenerse.';
  }

  @override
  String rel_admin_delete_target(String name) {
    return 'Eliminar $name';
  }

  @override
  String rel_admin_delete_profile_warning(String scope) {
    return 'Elimina permanentemente $scope, incluidas sesiones y credenciales. Escribe el ID exacto del perfil.';
  }

  @override
  String rel_admin_export_target(String name) {
    return 'Exportar $name';
  }

  @override
  String rel_admin_export_warning(String scope) {
    return 'Crea un .tar.gz en $scope. Se excluyen los almacenes de credenciales conocidos, pero pueden quedar datos privados. Revisa antes de compartir.';
  }

  @override
  String rel_admin_archive_on(String gateway, String path) {
    return 'Archivo en $gateway: $path';
  }

  @override
  String rel_admin_import_warning(String gateway) {
    return 'Usa un .tar.gz revisado que ya esté en $gateway. Puede contener complementos, scripts y programaciones. Se requiere un ID de perfil nuevo.';
  }

  @override
  String rel_admin_imported(String name) {
    return 'Se importó $name.';
  }

  @override
  String rel_admin_approve_user(String user) {
    return 'Aprobar a $user';
  }

  @override
  String rel_admin_revoke_user(String user) {
    return 'Revocar a $user';
  }

  @override
  String rel_admin_allow_pair(String platform, String scope) {
    return '$platform en $scope: permitir el acceso de mensajería de este usuario.';
  }

  @override
  String rel_admin_remove_pair(String platform, String scope) {
    return '$platform en $scope: quitar el acceso de mensajería de este usuario.';
  }

  @override
  String rel_admin_telegram_start(String scope) {
    return 'Inicia una vinculación de Telegram en $scope con el servicio de configuración de la puerta de enlace.';
  }

  @override
  String rel_admin_expires(String time) {
    return 'Caduca: $time';
  }

  @override
  String rel_admin_telegram_apply(String bot, String scope) {
    return 'Activa @$bot en $scope e intenta reiniciar la puerta de enlace. Solo los usuarios indicados pueden enviarle mensajes.';
  }

  @override
  String rel_admin_hooks_enable(String scope) {
    return 'Activa los webhooks entrantes en $scope e intenta reiniciar la puerta de enlace.';
  }

  @override
  String rel_admin_disable_target(String name) {
    return 'Desactivar $name';
  }

  @override
  String rel_admin_enable_target(String name) {
    return 'Activar $name';
  }

  @override
  String rel_admin_hook_change(String name, String scope) {
    return 'Cambia exactamente $name en $scope.';
  }

  @override
  String rel_admin_backup_warning(String gateway) {
    return 'Esto no es una copia de los ajustes de Ares. Guarda todos los perfiles, sesiones y credenciales de $gateway. El archivo es confidencial.';
  }

  @override
  String rel_admin_backup_started(String gateway) {
    return 'Copia de seguridad iniciada en $gateway.';
  }

  @override
  String rel_admin_backup_verified(String gateway, String path) {
    return 'Copia de seguridad verificada en $gateway: $path';
  }

  @override
  String rel_admin_backup_running(String gateway) {
    return 'La copia de seguridad sigue en curso en $gateway.';
  }

  @override
  String get rel_admin_choice_yes => 'sí';

  @override
  String get rel_admin_choice_no => 'no';

  @override
  String get rel_admin_choice_generic => 'genérico';

  @override
  String get rel_admin_choice_log => 'registro';

  @override
  String get rel_admin_choice_email => 'correo electrónico';

  @override
  String get rel_admin_choice_github_comment => 'comentario de GitHub';

  @override
  String get rel_admin_choice_agent => 'El agente procesa el evento';

  @override
  String get rel_admin_choice_direct => 'Entrega directa';

  @override
  String get rel_admin_configured => 'configurado';

  @override
  String get rel_admin_state_pending_restart => 'reinicio pendiente';

  @override
  String get rel_admin_state_unknown => 'desconocido';

  @override
  String get rel_admin_state_connected => 'conectado';

  @override
  String get rel_admin_state_disconnected => 'desconectado';

  @override
  String get rel_admin_state_disabled => 'desactivado';

  @override
  String get rel_admin_state_enabled => 'activado';

  @override
  String get rel_admin_state_running => 'en ejecución';

  @override
  String get rel_admin_state_stopped => 'detenido';

  @override
  String get rel_admin_state_error => 'error';

  @override
  String get rel_admin_state_not_configured => 'sin configurar';

  @override
  String get rel_admin_state_startup_failed => 'inicio fallido';

  @override
  String get rel_admin_state_gateway_stopped => 'puerta de enlace detenida';

  @override
  String get rel_admin_state_connecting => 'conectando';

  @override
  String get rel_admin_state_retrying => 'reintentando';

  @override
  String get rel_admin_state_fatal => 'error fatal';

  @override
  String get rel_admin_unsupported_or_oversized_profile_archive =>
      'Archivo de perfil no compatible o demasiado grande.';

  @override
  String get rel_admin_current_layout => 'Diseño actual';

  @override
  String get rel_admin_one_pane => 'Un panel';

  @override
  String get rel_admin_stacked => 'Apilado';

  @override
  String get rel_admin_side_by_side => 'Lado a lado';

  @override
  String get rel_admin_no_supported_appearance_in_this_profile =>
      'No hay una apariencia compatible en este perfil.';

  @override
  String get rel_admin_review_appearance_saved_with_this_profile =>
      'Revisar apariencia guardada con este perfil';

  @override
  String get rel_admin_applies_only_to_this_named_profile_on_this_device =>
      'Solo se aplica a este perfil con nombre en este dispositivo. Una disposición importada empieza con paneles vacíos; elige sus chats tú mismo.';

  @override
  String get rel_admin_apply_to_this_profile_on_this_device =>
      'Aplicar a este perfil en este dispositivo';

  @override
  String get rel_admin_export_prepares_a_tar_gz_on_the_gateway_review =>
      'La exportación prepara un .tar.gz en la puerta de enlace. Revisa sus archivos portátiles antes de guardar una copia aquí. La importación abre un archivo local para revisarlo; abrirlo no sube nada.';

  @override
  String get rel_admin_prepare_profile_export =>
      'Preparar exportación de perfil';

  @override
  String get rel_admin_open_tar_gz_from_this_device =>
      'Abrir .tar.gz de este dispositivo';

  @override
  String get rel_admin_only_selected_text_files_travel_review_for_secrets_and =>
      'Solo se transfieren los archivos de texto seleccionados. Comprueba si contienen secretos o información privada. La configuración, habilidades y programaciones pueden cambiar lo que hace el nuevo perfil.';

  @override
  String get rel_admin_include_this_reviewed_file =>
      'Incluir este archivo revisado';

  @override
  String get rel_admin_apply_appearance_to_the_new_profile_on_this_device =>
      'Aplicar apariencia al nuevo perfil en este dispositivo';

  @override
  String
  get rel_admin_imports_colours_and_pane_sizes_never_chats_tools_or_session_ids =>
      'Importa colores y tamaños de paneles, nunca chats, herramientas ni ID de sesión.';

  @override
  String
  get rel_admin_the_gateway_retains_a_private_staged_copy_import_creates =>
      'La puerta de enlace conserva una copia privada preparada. La importación crea un perfil nuevo; no sustituye uno existente.';

  @override
  String get rel_admin_appearance_not_applied_the_gateway_did_not_confirm_the =>
      ' Apariencia no aplicada: la puerta de enlace no confirmó la capa revisada.';

  @override
  String get rel_admin_appearance_applied_on_this_device =>
      ' Apariencia aplicada en este dispositivo.';

  @override
  String get rel_admin_appearance_was_not_saved_on_this_device =>
      ' La apariencia no se guardó en este dispositivo.';

  @override
  String get rel_admin_save_reviewed_profile_bundle =>
      'Guardar paquete de perfil revisado';

  @override
  String get rel_admin_profile_bundle_saved => 'Paquete de perfil guardado.';

  @override
  String get rel_admin_import_selected_files =>
      'Importar archivos seleccionados';

  @override
  String get rel_admin_save_selected_files_to_device =>
      'Guardar archivos seleccionados en el dispositivo';

  @override
  String rel_admin_layout_first_pane(String layout, String percent) {
    return '$layout · $percent% primer panel';
  }

  @override
  String rel_admin_appearance_summary(String skin, String mode, String layout) {
    return 'Tema: $skin · Modo: $mode · $layout';
  }

  @override
  String rel_admin_appearance_applied(String gateway, String profile) {
    return 'Apariencia aplicada a $gateway / $profile.';
  }

  @override
  String rel_admin_bundle_summary(
    String profile,
    String count,
    String omitted,
  ) {
    return 'Paquete: $profile · $count archivos revisables · $omitted omitidos';
  }

  @override
  String rel_admin_imported_on(String name, String gateway) {
    return 'Se importó $name en $gateway.';
  }

  @override
  String get rel_admin_unchanged => 'sin cambios';

  @override
  String get rel_admin_mode_system => 'sistema';

  @override
  String get rel_admin_mode_light => 'claro';

  @override
  String get rel_admin_mode_dark => 'oscuro';

  @override
  String get rel_admin_skin_classic => 'clásico';

  @override
  String get rel_admin_skin_midnight => 'medianoche';

  @override
  String get rel_admin_skin_ember => 'brasa';

  @override
  String get rel_admin_skin_mono => 'monocromo';

  @override
  String get rel_admin_skin_cyberpunk => 'ciberpunk';

  @override
  String get rel_admin_skin_slate => 'pizarra';

  @override
  String get rel_admin_no_available_cloud_agents_in_this_account =>
      'No hay agentes de Cloud disponibles en esta cuenta.';

  @override
  String get rel_admin_the_previous_undo_receipt_could_not_be_verified_no =>
      'No se pudo verificar el recibo anterior para deshacer. No se realizó ningún cambio.';

  @override
  String get rel_admin_transfer_to_cloud => 'Transferir a Cloud';

  @override
  String
  get rel_admin_connection_changed_leave_this_page_a_restore_already_submitted =>
      'La conexión cambió. Sal de esta página. Una restauración ya enviada puede continuar.';

  @override
  String get rel_admin_find_my_cloud_agents => 'Buscar mis agentes de Cloud';

  @override
  String
  get rel_admin_undo_replaces_the_destination_with_its_pre_transfer_backup =>
      'Deshacer sustituye el destino por su copia de seguridad anterior a la transferencia.';

  @override
  String get rel_admin_replace_this_cloud_agent_with_the_entire_source_home =>
      'Sustituye este agente de Cloud por todo el directorio de origen, incluidas credenciales, conversaciones y archivos. El origen no se elimina. Los bots de mensajería entrante se desactivan.';

  @override
  String get rel_admin_type_destination_agent_id =>
      'Escribe el ID del agente de destino';

  @override
  String
  get rel_admin_could_not_retain_the_local_undo_receipt_keep_this_page_open =>
      'No se pudo conservar el recibo local para deshacer. Mantén esta página abierta.';

  @override
  String get rel_admin_undo_transfer => 'Deshacer transferencia';

  @override
  String get rel_admin_replace_cloud_agent => 'Sustituir agente de Cloud';

  @override
  String
  get rel_admin_local_undo_receipt_forgotten_no_remote_backup_was_removed =>
      'Se olvidó el recibo local para deshacer. No se eliminó ninguna copia de seguridad remota.';

  @override
  String get rel_admin_forget_local_undo_receipt_only =>
      'Olvidar solo el recibo local para deshacer';

  @override
  String get rel_admin_stop_before_restore => 'Detener antes de restaurar';

  @override
  String get rel_admin_do_not_close_this_page_restore_runs_on_the =>
      'No cierres esta página. La restauración se ejecuta en el destino y no se puede cancelar.';

  @override
  String get rel_admin_files_restored_destination_gateway_needs_attention =>
      'Archivos restaurados; la puerta de enlace de destino requiere atención.';

  @override
  String rel_admin_transfer_sign_in(String origin) {
    return 'Inicia sesión en exactamente una conexión guardada de Ares para $origin y vuelve aquí.';
  }

  @override
  String rel_admin_transfer_source(String gateway, String profile) {
    return 'Origen: $gateway / $profile';
  }

  @override
  String rel_admin_transfer_destination(String name, String origin) {
    return 'Destino: $name · $origin / default';
  }

  @override
  String rel_admin_agent_id(String id) {
    return 'ID del agente: $id';
  }

  @override
  String rel_admin_transfer_status(String phase) {
    return 'Estado: $phase';
  }

  @override
  String rel_admin_copied_percent(String percent) {
    return 'Copiado $percent%';
  }

  @override
  String rel_admin_undo_point(String path) {
    return 'Punto para deshacer en el destino: $path';
  }

  @override
  String rel_admin_messaging_disabled(String channels) {
    return 'Mensajería desactivada: $channels';
  }

  @override
  String get rel_admin_phase_prepared => 'preparado';

  @override
  String get rel_admin_phase_backup => 'copia de seguridad';

  @override
  String get rel_admin_phase_upload => 'subida';

  @override
  String get rel_admin_phase_restore => 'restauración';

  @override
  String get rel_admin_phase_finished => 'finalizado';

  @override
  String get rel_admin_phase_failed => 'fallido';

  @override
  String get rel_admin_phase_undo => 'deshacer';

  @override
  String get rel_admin_phase_undone => 'deshecho';

  @override
  String rel_ops_cap_install_blocked(String verdict, String detail) {
    return 'Instalación bloqueada ($verdict): $detail';
  }

  @override
  String rel_ops_cap_scan_confirm(String verdict, String requested) {
    return 'Resultado del análisis: $verdict. Confirma $requested antes de instalar.';
  }

  @override
  String rel_ops_cap_install_unconfirmed(String requested) {
    return 'La puerta de enlace no ha confirmado que $requested esté instalado.';
  }

  @override
  String rel_ops_cap_edit_skill(String name) {
    return 'Editar $name';
  }

  @override
  String rel_ops_cap_archive_skill(String name) {
    return '¿Archivar $name?';
  }

  @override
  String rel_ops_cap_archive_explanation(String command) {
    return 'La habilidad se archivará y podrá restaurarse con $command.';
  }

  @override
  String rel_ops_cap_install_anyway(String name) {
    return 'Instalar $name de todos modos';
  }

  @override
  String rel_ops_cap_install_despite_scan(String name) {
    return '¿Instalar $name a pesar del análisis?';
  }

  @override
  String rel_ops_cap_scan_warning(String name) {
    return 'El análisis de seguridad bloqueó $name. Esta confirmación solo se aplica a $name.';
  }

  @override
  String rel_ops_cap_accept_scan_warning(String name) {
    return 'Aceptar capacidades no anula el análisis de $name.';
  }

  @override
  String rel_ops_cap_review_scan(String name) {
    return 'Revisar el análisis de $name';
  }

  @override
  String rel_ops_cap_desktop_grants(String description) {
    return '$description\nLos permisos de carpetas y scripts de vista previa permanecen en la aplicación Desktop de ese equipo. Eliminar el plugin aquí no revoca esos permisos locales.';
  }

  @override
  String rel_ops_cap_remove_plugin(String name) {
    return '¿Eliminar $name?';
  }

  @override
  String rel_ops_cap_probe_result(String name, String tools) {
    return 'Prueba de $name: $tools';
  }

  @override
  String rel_ops_cap_save_tool_grants_for(String connector) {
    return 'Guardar permisos de herramientas para $connector';
  }

  @override
  String rel_ops_cap_backends_for(String name) {
    return 'Motores para $name';
  }

  @override
  String rel_ops_cap_use_backend_confirmation(String name) {
    return '¿Usar $name?';
  }

  @override
  String rel_ops_cap_unlock_source(String name) {
    return 'Desbloquear $name';
  }

  @override
  String get rel_ops_cap_capabilities => 'Capacidades';

  @override
  String get rel_ops_cap_plugins => 'Plugins';

  @override
  String get rel_ops_cap_connectors => 'Conectores';

  @override
  String get rel_ops_cap_backends => 'Motores';

  @override
  String get rel_ops_cap_save_skill => 'Guardar habilidad';

  @override
  String get rel_ops_cap_archive => 'Archivar';

  @override
  String get rel_ops_cap_hub_identifier => 'Identificador del Hub';

  @override
  String get rel_ops_cap_install => 'Instalar';

  @override
  String get rel_ops_cap_update_all => 'Actualizar todo';

  @override
  String get rel_ops_cap_unlock => 'Desbloquear';

  @override
  String get rel_ops_cap_lock => 'Bloquear';

  @override
  String get rel_ops_cap_this_update_adds_capabilities_nothing_changed_yet =>
      'Esta actualización añade capacidades. Aún no ha cambiado nada.';

  @override
  String get rel_ops_cap_the_scan_blocked_this_plugin =>
      'El análisis bloqueó este plugin.';

  @override
  String get rel_ops_cap_the_plugin_was_not_changed =>
      'El plugin no se modificó.';

  @override
  String get rel_ops_cap_repository => 'Repositorio';

  @override
  String get rel_ops_cap_install_plugin => 'Instalar plugin';

  @override
  String get rel_ops_cap_update_plugins => 'Actualizar plugins';

  @override
  String get rel_ops_cap_accept_capabilities => 'Aceptar capacidades';

  @override
  String get rel_ops_cap_update => 'Actualizar';

  @override
  String get rel_ops_cap_remove_desktop_half =>
      'Eliminar el componente de escritorio';

  @override
  String get rel_ops_cap_server_name => 'Nombre del servidor';

  @override
  String get rel_ops_cap_command => 'Comando';

  @override
  String get rel_ops_cap_http_url => 'URL HTTP';

  @override
  String get rel_ops_cap_add_server => 'Añadir servidor';

  @override
  String get rel_ops_cap_probe => 'Probar';

  @override
  String get rel_ops_cap_probe_failed => 'La prueba falló.';

  @override
  String get rel_ops_cap_logs => 'Registros';

  @override
  String get rel_ops_cap_mcp_log => 'Registro MCP';

  @override
  String get rel_ops_cap_connector => 'Conector';

  @override
  String get rel_ops_cap_account_alias => 'Alias de la cuenta';

  @override
  String get rel_ops_cap_link_account => 'Vincular cuenta';

  @override
  String get rel_ops_cap_remove_account => 'Eliminar cuenta';

  @override
  String get rel_ops_cap_tool_connector => 'Conector de herramientas';

  @override
  String get rel_ops_cap_load_tools => 'Cargar herramientas';

  @override
  String get rel_ops_cap_save_tool_grants => 'Guardar permisos de herramientas';

  @override
  String
  get rel_ops_cap_this_policy_has_no_member_revision_so_tool_grants_stay_unchanged =>
      'Esta política no tiene revisión de miembro, por lo que los permisos de herramientas no cambian.';

  @override
  String get rel_ops_cap_active => 'Activo';

  @override
  String get rel_ops_cap_use => 'Usar';

  @override
  String get rel_ops_cap_run_setup => 'Iniciar configuración';

  @override
  String get rel_ops_cap_terminal_backends => 'Motores de terminal';

  @override
  String get rel_ops_cap_this_changes_the_terminal_backend_for_this_profile =>
      'Esto cambia el motor de terminal de este perfil.';

  @override
  String get rel_ops_cap_use_backend => 'Usar motor';

  @override
  String get rel_ops_cap_select => 'Seleccionar';

  @override
  String get rel_ops_cap_browser_vault => 'Bóveda del navegador';

  @override
  String
  get rel_ops_cap_saved_site_logins_addresses_and_cards_passwords_stay_in_the_secure_fields_and_are_not_listed_here =>
      'Credenciales de sitios, direcciones y tarjetas guardadas. Las contraseñas permanecen en los campos seguros y no se muestran aquí.';

  @override
  String get rel_ops_cap_remove_saved_item => 'Eliminar elemento guardado';

  @override
  String get rel_ops_cap_delete_this_item => '¿Eliminar este elemento?';

  @override
  String get rel_ops_cap_unlocked => 'Desbloqueado';

  @override
  String get rel_ops_cap_locked => 'Bloqueado';

  @override
  String get rel_ops_cap_not_detected => 'No detectado';

  @override
  String get rel_ops_cap_master_password => 'Contraseña maestra';

  @override
  String get rel_ops_cap_login => 'Credenciales de acceso';

  @override
  String get rel_ops_cap_address => 'Dirección';

  @override
  String get rel_ops_cap_card => 'Tarjeta';

  @override
  String get rel_ops_cap_label => 'Etiqueta';

  @override
  String get rel_ops_cap_site_origin => 'Origen del sitio';

  @override
  String get rel_ops_cap_identifier => 'Identificador';

  @override
  String get rel_ops_cap_password => 'Contraseña';

  @override
  String get rel_ops_cap_authenticator_key => 'Clave de autenticación';

  @override
  String get rel_ops_cap_street => 'Calle';

  @override
  String get rel_ops_cap_city => 'Ciudad';

  @override
  String get rel_ops_cap_postal_code => 'Código postal';

  @override
  String get rel_ops_cap_country => 'País';

  @override
  String get rel_ops_cap_name_on_card => 'Nombre en la tarjeta';

  @override
  String get rel_ops_cap_card_number => 'Número de tarjeta';

  @override
  String get rel_ops_cap_expiry_month => 'Mes de caducidad';

  @override
  String get rel_ops_cap_expiry_year => 'Año de caducidad';

  @override
  String get rel_ops_cap_security_code => 'Código de seguridad';

  @override
  String get rel_ops_cap_this_gateway_has_no_shared_metrics_consent_method =>
      'Esta puerta de enlace no dispone de un método de consentimiento para compartir métricas.';

  @override
  String get rel_ops_cap_agent_policy => 'Política del agente';

  @override
  String get rel_ops_cap_loading_policy => 'Cargando política';

  @override
  String get rel_ops_cap_approval_timeout => 'Tiempo de espera de aprobación';

  @override
  String get rel_ops_cap_confirm_mcp_reloads => 'Confirmar recargas de MCP';

  @override
  String get rel_ops_cap_command_allowlist => 'Lista de comandos permitidos';

  @override
  String get rel_ops_cap_file_checkpoints =>
      'Puntos de restauración de archivos';

  @override
  String get rel_ops_cap_checkpoint_limit => 'Límite de puntos de restauración';

  @override
  String get rel_ops_cap_browser_private_urls => 'URL privadas en el navegador';

  @override
  String get rel_ops_cap_use_my_real_browser_profile =>
      'Usar mi perfil real del navegador';

  @override
  String get rel_ops_cap_save_policy => 'Guardar política';

  @override
  String get rel_ops_cap_shared_metrics_for_this_profile =>
      'Métricas compartidas de este perfil';

  @override
  String get rel_ops_cap_send_shared_metrics => 'Enviar métricas compartidas';

  @override
  String get rel_ops_cap_error_enter_a_label => 'Introduce una etiqueta.';

  @override
  String get rel_ops_cap_error_enter_a_valid_url_like_https_example_com =>
      'Introduce una URL válida, como https://example.com.';

  @override
  String get rel_ops_cap_error_enter_the_identifier_and_password =>
      'Introduce el identificador y la contraseña.';

  @override
  String
  get rel_ops_cap_error_enter_the_card_name_number_expiry_and_security_code =>
      'Introduce el nombre de la tarjeta, el número, la caducidad y el código de seguridad.';

  @override
  String get rel_ops_cap_error_enter_the_street_city_postal_code_and_country =>
      'Introduce la calle, la ciudad, el código postal y el país.';

  @override
  String
  get rel_ops_cap_error_the_gateway_returned_a_response_that_could_not_be_read =>
      'La puerta de enlace devolvió una respuesta que no se pudo leer.';

  @override
  String rel_ops_cap_error_the_gateway_refused_the_request_status(
    int statusCode,
  ) {
    return 'La puerta de enlace rechazó la solicitud ($statusCode).';
  }

  @override
  String
  rel_ops_cap_error_this_connection_has_no_gateway_socket_so_method_is_unavailable(
    String method,
  ) {
    return 'Esta conexión no tiene un socket de puerta de enlace, por lo que $method no está disponible.';
  }

  @override
  String get rel_ops_cap_error_choose_a_skill => 'Elige una habilidad.';

  @override
  String get rel_ops_cap_error_the_skill_text_was_not_returned =>
      'No se recibió el texto de la habilidad.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_saved =>
      'La habilidad no se guardó.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_archived =>
      'La habilidad no se archivó.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_installed =>
      'La habilidad no se instaló.';

  @override
  String get rel_ops_cap_error_skill_updates_did_not_start =>
      'Las actualizaciones de habilidades no se iniciaron.';

  @override
  String get rel_ops_cap_error_the_skill_was_not_removed =>
      'La habilidad no se eliminó.';

  @override
  String get rel_ops_cap_error_enter_a_skill_or_plugin_identifier =>
      'Introduce un identificador de habilidad o plugin.';

  @override
  String get rel_ops_cap_error_choose_a_plugin => 'Elige un plugin.';

  @override
  String get rel_ops_cap_error_the_plugin_was_not_removed =>
      'El plugin no se eliminó.';

  @override
  String get rel_ops_cap_error_the_desktop_half_was_not_removed =>
      'El componente de escritorio no se eliminó.';

  @override
  String
  get rel_ops_cap_error_this_gateway_did_not_give_the_plugin_a_stable_key =>
      'Esta puerta de enlace no asignó una clave estable al plugin.';

  @override
  String get rel_ops_cap_error_the_plugin_was_not_changed =>
      'El plugin no se modificó.';

  @override
  String get rel_ops_cap_error_choose_a_server => 'Elige un servidor.';

  @override
  String get rel_ops_cap_error_name_the_server =>
      'Asigna un nombre al servidor.';

  @override
  String get rel_ops_cap_error_give_the_server_a_command_or_an_http_s_url =>
      'Indica un comando o una URL http(s) para el servidor.';

  @override
  String get rel_ops_cap_error_choose_a_toolset =>
      'Elige un conjunto de herramientas.';

  @override
  String get rel_ops_cap_error_tool_backend_status_was_not_returned =>
      'No se recibió el estado del motor de herramientas.';

  @override
  String get rel_ops_cap_error_choose_a_provider => 'Elige un proveedor.';

  @override
  String get rel_ops_cap_error_this_provider_has_no_setup_action =>
      'Este proveedor no tiene una acción de configuración.';

  @override
  String get rel_ops_cap_error_setup_did_not_start =>
      'La configuración no se inició.';

  @override
  String get rel_ops_cap_error_choose_a_terminal_backend =>
      'Elige un motor de terminal.';

  @override
  String get rel_ops_cap_error_name_the_connector =>
      'Asigna un nombre al conector.';

  @override
  String get rel_ops_cap_error_choose_an_account => 'Elige una cuenta.';

  @override
  String
  get rel_ops_cap_error_reload_the_connector_policy_before_changing_tool_grants =>
      'Recarga la política del conector antes de cambiar los permisos de herramientas.';

  @override
  String get rel_ops_cap_error_choose_an_item => 'Elige un elemento.';

  @override
  String get rel_ops_cap_error_choose_a_source => 'Elige una fuente.';

  @override
  String get rel_ops_cap_error_enter_the_master_password =>
      'Introduce la contraseña maestra.';

  @override
  String get rel_ops_cap_error_gateway_config_was_not_returned =>
      'No se recibió la configuración de la puerta de enlace.';

  @override
  String get rel_ops_cap_error_choose_a_known_approval_mode =>
      'Elige un modo de aprobación conocido.';

  @override
  String get rel_ops_cap_error_use_a_positive_limit =>
      'Usa un límite positivo.';

  @override
  String get rel_ops_cap_error_the_policy_was_not_saved =>
      'La política no se guardó.';

  @override
  String get rel_ops_cap_value_manual => 'manual';

  @override
  String get rel_ops_cap_value_smart => 'inteligente';

  @override
  String get rel_ops_cap_value_off => 'desactivado';

  @override
  String get rel_ops_cap_value_safe => 'seguro';

  @override
  String get rel_ops_cap_value_caution => 'precaución';

  @override
  String get rel_ops_cap_value_dangerous => 'peligroso';

  @override
  String get rel_ops_cap_value_blocked => 'bloqueado';

  @override
  String get rel_ops_cap_value_clean => 'sin amenazas';

  @override
  String get rel_ops_cap_value_ready => 'listo';

  @override
  String get rel_ops_cap_value_available => 'disponible';

  @override
  String get rel_ops_cap_value_unavailable => 'no disponible';

  @override
  String get rel_ops_cap_value_enabled => 'habilitado';

  @override
  String get rel_ops_cap_value_disabled => 'deshabilitado';

  @override
  String get rel_ops_cap_value_active => 'activo';

  @override
  String get rel_ops_cap_value_inactive => 'inactivo';

  @override
  String get rel_ops_cap_value_installed => 'instalado';

  @override
  String get rel_ops_cap_value_missing => 'ausente';

  @override
  String get rel_ops_cap_value_configured => 'configurado';

  @override
  String get rel_ops_cap_value_not_configured => 'sin configurar';

  @override
  String get rel_ops_cap_value_error => 'error';

  @override
  String get rel_ops_cap_value_unknown => 'desconocido';

  @override
  String get rel_ops_cap_value_login => 'acceso';

  @override
  String get rel_ops_cap_value_address => 'dirección';

  @override
  String get rel_ops_cap_value_payment => 'pago';

  @override
  String get rel_ops_term_connecting => 'Conectando…';

  @override
  String get rel_ops_term_unbound =>
      'No hay ninguna sesión activa ni directorio de trabajo del host que coincidan. Abre primero el chat al que pertenece.';

  @override
  String get rel_ops_term_unsupported =>
      'Este Gateway no ofrece esta función de terminal. No se ha iniciado ningún intérprete de comandos local.';

  @override
  String get rel_ops_term_local_pty_unavailable =>
      'La PTY local incluida no está disponible en este dispositivo.';

  @override
  String get rel_ops_term_operation_failed =>
      'No se pudo abrir ni controlar el terminal. Comprueba el host, las credenciales y la huella digital. No se ha iniciado ningún intérprete de comandos alternativo.';

  @override
  String get rel_ops_term_input_refused =>
      'Entrada rechazada. Vuelve a abrir el chat de origen.';

  @override
  String get rel_ops_term_cancel => 'Cancelar';

  @override
  String get rel_ops_term_confirm => 'Confirmar';

  @override
  String get rel_ops_term_open_device_title =>
      '¿Abrir un intérprete de comandos en este dispositivo?';

  @override
  String get rel_ops_term_ssh_shell => 'Intérprete de comandos SSH';

  @override
  String get rel_ops_term_local_shell => 'Intérprete de comandos local';

  @override
  String get rel_ops_term_connection_lost => 'Conexión perdida';

  @override
  String get rel_ops_term_shell_ended => 'Intérprete de comandos finalizado';

  @override
  String get rel_ops_term_no_owner =>
      'Este chat no tiene un propietario autenticado del terminal del Gateway. Una URL o un inicio de sesión en la nube por sí solos no dan acceso a un intérprete de comandos.';

  @override
  String get rel_ops_term_open_gateway_title =>
      '¿Abrir un intérprete de comandos del Gateway?';

  @override
  String get rel_ops_term_shell_expired =>
      'El intérprete de comandos ha finalizado o caducado';

  @override
  String get rel_ops_term_disconnected => 'Desconectado';

  @override
  String get rel_ops_term_gateway_shell => 'Intérprete de comandos del Gateway';

  @override
  String get rel_ops_term_close_body =>
      'Finaliza este intérprete de comandos. Para mantenerlo en ejecución, oculta el panel en su lugar.';

  @override
  String get rel_ops_term_closing => 'Cerrando…';

  @override
  String get rel_ops_term_close_unconfirmed => 'Cierre no confirmado';

  @override
  String get rel_ops_term_processes_require_chat =>
      'Los procesos del agente requieren el chat autenticado al que pertenecen.';

  @override
  String get rel_ops_term_watching_processes =>
      'Supervisando los procesos del agente de este chat. Cerrar una vista espejo nunca detiene su proceso.';

  @override
  String get rel_ops_term_paste_limit => 'El pegado está limitado a 16 KiB.';

  @override
  String get rel_ops_term_paste => 'Pegar';

  @override
  String get rel_ops_term_select_first =>
      'Selecciona primero la salida del terminal.';

  @override
  String get rel_ops_term_open_chat_to_insert =>
      'Abre el chat de origen antes de insertar la salida.';

  @override
  String get rel_ops_term_added_to_draft =>
      'Se ha añadido al borrador del chat de origen. No se ha enviado nada.';

  @override
  String get rel_ops_term_close => 'Cerrar';

  @override
  String get rel_ops_term_add_selection =>
      'Añadir selección al borrador del chat';

  @override
  String get rel_ops_term_new_terminal => 'Nuevo terminal';

  @override
  String get rel_ops_term_gateway_terminal => 'Terminal del host del Gateway';

  @override
  String get rel_ops_term_verified_ssh_terminal => 'Terminal SSH verificado';

  @override
  String get rel_ops_term_device_local_shell =>
      'Este dispositivo (intérprete de comandos local)';

  @override
  String get rel_ops_term_local_unavailable_mobile =>
      'Intérprete de comandos local no disponible en móviles';

  @override
  String get rel_ops_term_watch_processes => 'Supervisar procesos del agente';

  @override
  String get rel_ops_term_select_output => 'Seleccionar o copiar la salida';

  @override
  String get rel_ops_term_add_selected_output =>
      'Añadir la salida seleccionada al borrador del chat';

  @override
  String get rel_ops_term_review_paste => 'Revisar el pegado del portapapeles';

  @override
  String get rel_ops_term_reconnect =>
      'Reconectar al mismo intérprete de comandos';

  @override
  String get rel_ops_term_close_mirror => 'Cerrar vista espejo';

  @override
  String get rel_ops_term_close_shell => 'Cerrar intérprete de comandos';

  @override
  String get rel_ops_term_empty =>
      'Selecciona + para abrir un terminal. No se inicia ningún intérprete de comandos automáticamente.';

  @override
  String get rel_ops_term_reason_stale => 'obsoleto';

  @override
  String get rel_ops_term_reason_mismatch => 'no coincide';

  @override
  String get rel_ops_term_reason_unbound => 'sin vincular';

  @override
  String get rel_ops_term_reason_unsupported => 'no compatible';

  @override
  String get rel_ops_term_reason_denied => 'denegado';

  @override
  String get rel_ops_term_reason_ineligible => 'no apto';

  @override
  String get rel_ops_term_reason_unavailable => 'no disponible';

  @override
  String get rel_ops_term_reason_invalid => 'no válido';

  @override
  String get rel_ops_term_reason_insecure => 'no seguro';

  @override
  String rel_ops_term_refused(String reason) {
    return 'El Gateway ha rechazado esta operación de terminal ($reason).';
  }

  @override
  String rel_ops_term_open_device_body(String connection) {
    return 'Este es el dispositivo de Ares, no $connection. El intérprete de comandos usa los permisos de la aplicación y se inicia en su almacenamiento.';
  }

  @override
  String rel_ops_term_open_gateway_body(String host) {
    return 'Inicia un intérprete de comandos en $host, en el directorio de trabajo verificado del chat. No es un intérprete de comandos del dispositivo.';
  }

  @override
  String rel_ops_term_close_tab_title(String label) {
    return '¿Cerrar $label?';
  }

  @override
  String rel_ops_term_read_only_status(String status) {
    return 'Solo lectura · $status';
  }

  @override
  String rel_ops_term_paste_title(String label) {
    return '¿Pegar en $label?';
  }

  @override
  String rel_ops_term_output_title(String label) {
    return 'Salida · $label';
  }

  @override
  String rel_ops_term_mirror_status(String label) {
    return 'Vista espejo del proceso de solo lectura · $label';
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
    return 'Este dispositivo · $number';
  }

  @override
  String rel_ops_term_gateway_tab(String host, int number) {
    return 'Gateway $host · $number';
  }

  @override
  String get rel_ops_term_earlier_output_trimmed =>
      '[Salida anterior recortada]';

  @override
  String get rel_ops_term_ssh_dialog_title =>
      'Abrir un terminal SSH verificado';

  @override
  String get rel_ops_term_ssh_dialog_body =>
      'Usa una huella digital obtenida de forma independiente del administrador del host. Esto abre una nueva sesión remota, no el Gateway ni un intérprete de comandos local.';

  @override
  String get rel_ops_term_ssh_host => 'Host SSH';

  @override
  String get rel_ops_term_ssh_port => 'Puerto';

  @override
  String get rel_ops_term_ssh_user => 'Usuario';

  @override
  String get rel_ops_term_ssh_fingerprint =>
      'Huella digital de la clave del host (SHA256:…)';

  @override
  String get rel_ops_term_ssh_password => 'Contraseña SSH (no se guarda)';

  @override
  String get rel_ops_term_connect => 'Conectar';

  @override
  String get rel_ops_ssh_invalid_destination =>
      'Host, puerto o usuario SSH no válido.';

  @override
  String get rel_ops_ssh_public_key_required =>
      'Se requiere una clave pública de host OpenSSH Ed25519.';

  @override
  String get rel_ops_ssh_invalid_public_key =>
      'Clave de host Ed25519 no válida.';

  @override
  String get rel_ops_ssh_invalid_saved_key =>
      'La clave de host guardada no es válida.';

  @override
  String get rel_ops_ssh_enrollment_unverified =>
      'No se ha podido verificar el registro de la clave de host.';

  @override
  String get rel_ops_ssh_different_key_pinned =>
      'Ya hay otra clave fijada. Verifica el cambio por separado.';

  @override
  String get rel_ops_ssh_open_ssh_unavailable =>
      'OpenSSH no está disponible en el sistema.';

  @override
  String get rel_ops_ssh_confirm_host_key =>
      'Confirma la clave de host antes de conectar.';

  @override
  String get rel_ops_ssh_absolute_identity_required =>
      'Selecciona un archivo de identidad con una ruta absoluta.';

  @override
  String get rel_ops_ssh_invalid_remote_port => 'Puerto remoto no válido.';

  @override
  String get rel_ops_ssh_preview_too_large =>
      'La vista previa supera el límite de 64 KiB.';

  @override
  String get rel_ops_ssh_connection_refused =>
      'Conexión SSH rechazada. Comprueba la clave de host registrada, la identidad y el servicio.';

  @override
  String get rel_ops_ssh_http_not_ok =>
      'El servicio remoto no ha devuelto HTTP 200.';

  @override
  String get rel_ops_ssh_encoded_response =>
      'Esta vista previa no admite respuestas codificadas.';

  @override
  String get rel_ops_ssh_preview_type_unsupported =>
      'Solo se pueden previsualizar texto y código fuente HTML.';

  @override
  String get rel_ops_ssh_health_unconfirmed =>
      'El servicio no ha confirmado el buen estado de la pasarela.';

  @override
  String get rel_ops_ssh_enroll_host_key_first =>
      'Registra primero la clave pública del host.';

  @override
  String get rel_ops_ssh_cancel => 'Cancelar';

  @override
  String get rel_ops_ssh_confirm => 'Confirmar';

  @override
  String get rel_ops_ssh_pin_title => '¿Fijar esta clave de host SSH?';

  @override
  String rel_ops_ssh_pin_detail(String destination, String fingerprint) {
    return '$destination\n$fingerprint\nCompara esta huella con el administrador del host por un canal independiente. No se establecerá ninguna conexión.';
  }

  @override
  String get rel_ops_ssh_host_key_pinned => 'Clave de host fijada.';

  @override
  String get rel_ops_ssh_shell_detail =>
      'Abrir una shell de inicio de sesión interactiva.';

  @override
  String rel_ops_ssh_read_detail(String path, int port) {
    return 'Leer $path en 127.0.0.1:$port del equipo remoto a través de un canal SSH.';
  }

  @override
  String rel_ops_ssh_connect_title(String destination) {
    return '¿Conectar con $destination?';
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
  String get rel_ops_ssh_agent_auth => 'Autentícate con tu agente SSH.';

  @override
  String get rel_ops_ssh_identity_auth =>
      'Usar el archivo de identidad seleccionado.';

  @override
  String rel_ops_ssh_gateway_responding(int port) {
    return 'La pasarela responde en el puerto de bucle local remoto $port.';
  }

  @override
  String get rel_ops_ssh_session_closed => 'Sesión SSH cerrada.';

  @override
  String get rel_ops_ssh_session_unclean =>
      'La sesión SSH ha terminado sin una salida correcta.';

  @override
  String get rel_ops_ssh_operation_failed =>
      'La operación SSH ha fallado. Comprueba el destino y la identidad.';

  @override
  String get rel_ops_ssh_title => 'SSH verificado';

  @override
  String get rel_ops_ssh_unsupported =>
      'Este dispositivo no dispone de un transporte OpenSSH del sistema compatible. El relé de la pasarela fijada acepta automáticamente claves nuevas y no puede usarse para un registro verificado.';

  @override
  String get rel_ops_ssh_host => 'Host SSH';

  @override
  String get rel_ops_ssh_port => 'Puerto SSH';

  @override
  String get rel_ops_ssh_user => 'Usuario SSH';

  @override
  String get rel_ops_ssh_identity =>
      'Archivo de identidad (opcional; de lo contrario, usar el agente SSH)';

  @override
  String get rel_ops_ssh_public_key =>
      'Clave pública de host del administrador (ssh-ed25519)';

  @override
  String get rel_ops_ssh_review_key => 'Revisar clave de host';

  @override
  String get rel_ops_ssh_remote_port =>
      'Puerto del servicio de bucle local remoto';

  @override
  String get rel_ops_ssh_check_gateway => 'Comprobar pasarela por SSH';

  @override
  String get rel_ops_ssh_preview_source =>
      'Previsualizar código fuente por SSH';

  @override
  String get rel_ops_ssh_open_shell => 'Abrir shell SSH';

  @override
  String get rel_ops_ssh_shell_line => 'Línea para la shell remota';

  @override
  String get rel_ops_ssh_disconnect => 'Desconectar shell';

  @override
  String get rel_ops_host_cancel => 'Cancelar';

  @override
  String get rel_ops_host_confirm => 'Confirmar';

  @override
  String get rel_ops_host_title => 'Host';

  @override
  String get rel_ops_host_refresh => 'Actualizar';

  @override
  String get rel_ops_host_update => 'Actualizar Hermes remoto';

  @override
  String rel_ops_host_update_confirmation(String profile) {
    return 'Esto inicia una actualización de la instalación existente en el host de la pasarela para $profile. No actualiza Ares en este dispositivo. El éxito se acredita con el comprobante de actualización correspondiente, no con que el host siga accesible.';
  }

  @override
  String get rel_ops_host_update_awaiting =>
      'Esperando el comprobante correspondiente. La actualización sigue en curso.';

  @override
  String get rel_ops_host_receipt_success =>
      'El comprobante de actualización indica que se completó correctamente.';

  @override
  String get rel_ops_host_receipt_partial =>
      'La actualización se ha aplicado, pero aún quedan pasos pendientes.';

  @override
  String get rel_ops_host_receipt_failed =>
      'El comprobante de actualización indica un fallo.';

  @override
  String get rel_ops_host_receipt_refused =>
      'El comprobante de actualización indica un rechazo.';

  @override
  String get rel_ops_host_update_running => 'La actualización sigue en curso.';

  @override
  String get rel_ops_host_update_unknown =>
      'Se desconoce el resultado de la actualización. Que la pasarela esté activa no significa que la actualización haya tenido éxito.';

  @override
  String get rel_ops_host_default_profile =>
      'el perfil predeterminado de la pasarela';

  @override
  String get rel_ops_host_restart => 'Reiniciar pasarela remota';

  @override
  String rel_ops_host_restart_shared_confirmation(String profiles) {
    return 'Esto reinicia la pasarela compartida por $profiles. Se interrumpirán los turnos en curso en esta pasarela. Vuelve a conectarte después. Que sea accesible no demuestra que haya finalizado el reinicio.';
  }

  @override
  String rel_ops_host_restart_confirmation(String profile) {
    return 'Esto reinicia la pasarela remota para $profile. Se interrumpirán los turnos en curso en esta pasarela. Vuelve a conectarte después.';
  }

  @override
  String get rel_ops_host_restart_running =>
      'El comando de reinicio sigue en ejecución.';

  @override
  String get rel_ops_host_restart_finished =>
      'El comando de reinicio ha finalizado. Vuelve a conectarte al host manualmente.';

  @override
  String get rel_ops_host_restart_failed =>
      'El comando de reinicio ha fallado.';

  @override
  String rel_ops_host_maintenance_running(String name) {
    return '$name sigue en ejecución';
  }

  @override
  String rel_ops_host_maintenance_finished(String name) {
    return '$name ha finalizado';
  }

  @override
  String rel_ops_host_maintenance_failed(String name) {
    return '$name ha fallado';
  }

  @override
  String get rel_ops_host_curator_paused_result => 'Curador en pausa.';

  @override
  String get rel_ops_host_curator_resumed_result => 'Curador reanudado.';

  @override
  String get rel_ops_host_reset => 'Restablecer archivos de memoria remotos';

  @override
  String rel_ops_host_reset_confirmation(String targetName, String profile) {
    return '¿Eliminar el archivo de memoria $targetName en $profile? Esta acción no se puede deshacer desde Ares.';
  }

  @override
  String rel_ops_host_reset_result(String targetName, int count) {
    return 'Se ha restablecido $targetName. Se han eliminado $count archivo(s) remoto(s).';
  }

  @override
  String get rel_ops_host_share_not_redacted =>
      'El host no confirmó que se hubieran ocultado los datos sensibles del paquete. No se muestra ningún enlace.';

  @override
  String rel_ops_host_scope(String connection, String profile) {
    return 'Estos controles operan sobre la pasarela remota $connection para $profile, no sobre este dispositivo ni sobre la actualización del cliente Ares.';
  }

  @override
  String rel_ops_host_health_running(String version, int count) {
    return 'Proceso de la pasarela en ejecución $version · $count sesiones';
  }

  @override
  String rel_ops_host_health_stopped(String version, int count) {
    return 'Proceso de la pasarela detenido $version · $count sesiones';
  }

  @override
  String rel_ops_host_heartbeat_stale(num seconds) {
    return 'La señal de actividad del host está desactualizada ($seconds s).';
  }

  @override
  String get rel_ops_host_doctor => 'Ejecutar Doctor';

  @override
  String get rel_ops_host_security_audit => 'Auditoría de seguridad';

  @override
  String get rel_ops_host_check_receipt =>
      'Comprobar el comprobante de actualización';

  @override
  String get rel_ops_host_logs => 'Registros del host remoto';

  @override
  String get rel_ops_host_search_logs => 'Buscar en los registros del host';

  @override
  String get rel_ops_host_driver => 'Controlador del host remoto';

  @override
  String get rel_ops_host_driver_scope =>
      'La disponibilidad del control del ordenador depende del controlador y de los permisos del sistema operativo del equipo de la pasarela, no de este dispositivo.';

  @override
  String rel_ops_host_computer_status(
    String platform,
    String installed,
    String ready,
  ) {
    return '$platform · instalado $installed · listo $ready';
  }

  @override
  String get rel_ops_host_null => 'no disponible';

  @override
  String get rel_ops_host_true => 'sí';

  @override
  String get rel_ops_host_false => 'no';

  @override
  String get rel_ops_host_curator => 'Curador';

  @override
  String get rel_ops_host_curator_paused => 'Curador en pausa';

  @override
  String get rel_ops_host_curator_running => 'Curador en ejecución';

  @override
  String get rel_ops_host_no_run => 'Ninguna ejecución completada';

  @override
  String get rel_ops_host_run_curator => 'Ejecutar Curador ahora';

  @override
  String get rel_ops_host_reset_memory => 'Restablecer archivo de memoria';

  @override
  String get rel_ops_host_reset_user => 'Restablecer archivo de usuario';

  @override
  String get rel_ops_host_reset_both => 'Restablecer ambos archivos';

  @override
  String get rel_ops_host_share_consent =>
      'Acepto subir un paquete de diagnóstico del host remoto con los datos sensibles ocultos';

  @override
  String get rel_ops_host_share =>
      'Compartir diagnósticos con datos sensibles ocultos';

  @override
  String get rel_ops_host_update_unknown_installation =>
      'Se desconoce esta instalación, por lo que no se envió la actualización';

  @override
  String get rel_ops_host_update_busy_installation =>
      'Hay un chat en curso en esta instalación';

  @override
  String get rel_ops_host_update_refused => 'Actualización remota rechazada';

  @override
  String get rel_ops_host_error_stale =>
      'Espacio de trabajo remoto: desactualizado';

  @override
  String get rel_ops_host_error_mismatch =>
      'Espacio de trabajo remoto: no coincide';

  @override
  String get rel_ops_host_error_unbound =>
      'Espacio de trabajo remoto: sin vincular';

  @override
  String get rel_ops_host_error_unsupported =>
      'Espacio de trabajo remoto: no compatible';

  @override
  String get rel_ops_host_error_denied =>
      'Espacio de trabajo remoto: acceso denegado';

  @override
  String get rel_ops_host_error_ineligible =>
      'Espacio de trabajo remoto: no apto';

  @override
  String get rel_ops_host_error_unavailable =>
      'Espacio de trabajo remoto: no disponible';

  @override
  String get rel_ops_host_error_invalid =>
      'Espacio de trabajo remoto: no válido';

  @override
  String get rel_ops_host_error_insecure =>
      'Espacio de trabajo remoto: no seguro';

  @override
  String get rel_ops_host_error_request => 'No se pudo completar la solicitud.';

  @override
  String get rel_svc_push_api_select_sessions =>
      'Selecciona entre 1 y 128 ID de sesión duraderos, de 1 a 200 caracteres ASCII cada uno, usando solo letras, dígitos, _ . : @ o -. Elimina los ID vacíos y los espacios.';

  @override
  String get rel_svc_push_api_unavailable =>
      'Las notificaciones push móviles no están disponibles en este servidor.';

  @override
  String get rel_svc_push_api_invalid_vapid =>
      'La clave pública VAPID del servidor no es válida.';

  @override
  String get rel_svc_push_api_update_plugin =>
      'Este servidor necesita un complemento mobile-push actualizado para las suscripciones automáticas.';

  @override
  String get rel_svc_push_status_android_only => 'Solo Android';

  @override
  String get rel_svc_push_native_prefs_sync_failed =>
      'No se pudieron sincronizar las preferencias de notificaciones nativas.';

  @override
  String get rel_svc_push_choose_android_connection =>
      'Elige primero una conexión guardada en Android.';

  @override
  String get rel_svc_push_status_checking_authorization =>
      'Comprobando autorización del servidor';

  @override
  String get rel_svc_push_revoke_persist_failed =>
      'No se pudo guardar la revocación. Vuelve a intentar desactivar antes de salir de la aplicación.';

  @override
  String get rel_svc_push_status_off_api_ready =>
      'Desactivado; API del servidor lista';

  @override
  String get rel_svc_push_status_off_revoke_pending =>
      'Desactivado; revocación del servidor pendiente';

  @override
  String get rel_svc_push_status_off_connection_changed =>
      'Desactivado; la conexión guardada cambió';

  @override
  String get rel_svc_push_status_pending_endpoint =>
      'Esperando endpoint del distribuidor';

  @override
  String get rel_svc_push_status_registering => 'Registrando';

  @override
  String get rel_svc_push_status_pending_challenge =>
      'Desafío cifrado pendiente (esperando una notificación push silenciosa de verificación del servidor)';

  @override
  String get rel_svc_push_allow_android_notifications_retry =>
      'Permite las notificaciones de Android en los ajustes del sistema y vuelve a intentarlo.';

  @override
  String get rel_svc_push_plugin_invalid =>
      'El complemento mobile-push del servidor no está disponible, está obsoleto o devolvió una respuesta de suscripción no válida. Pide al operador que lo actualice y vuelve a intentarlo.';

  @override
  String get rel_svc_push_transport_unavailable =>
      'No hay ningún transporte push disponible. La entrega integrada necesita que Google Play Services funcione; también puedes instalar un distribuidor UnifiedPush y volver a intentarlo.';

  @override
  String get rel_svc_push_transport_choice =>
      'Hay varios distribuidores UnifiedPush disponibles. Elige uno en Transporte avanzado y vuelve a intentarlo.';

  @override
  String get rel_svc_push_transport_missing =>
      'El distribuidor UnifiedPush seleccionado no está disponible. Restáuralo o elige otro en Transporte avanzado.';

  @override
  String get rel_svc_push_companion_unavailable =>
      'El componente mobile-push del servidor no está disponible. Puede faltar, estar desactivado o esta conexión puede apuntar al panel equivocado. Instálalo o actívalo en el servidor, comprueba la conexión del panel y actualiza. Consulta la guía de configuración del servidor anterior.';

  @override
  String get rel_svc_push_server_denied =>
      'El servidor rechazó las notificaciones push móviles. Pide al operador que autorice a esta identidad y estas sesiones.';

  @override
  String get rel_svc_push_not_ready =>
      'Las notificaciones push móviles no están listas. Comprueba la autorización del complemento del servidor, el distribuidor y la red, y vuelve a intentarlo.';

  @override
  String get rel_svc_push_availability_read_failed =>
      'No se pudo consultar la disponibilidad de push en Android. Vuelve a intentarlo abajo.';

  @override
  String get rel_svc_push_setup_failed =>
      'La configuración push falló. Comprueba el permiso de Android, la autorización del servidor y el transporte, y vuelve a intentarlo.';

  @override
  String rel_svc_push_status(String status) {
    return 'Estado: $status';
  }

  @override
  String rel_svc_push_status_bound(
    String bound,
    String connection,
    String status,
  ) {
    return 'Estado: Vinculado a $bound (no activo para $connection; negociación: $status)';
  }

  @override
  String get rel_svc_push_another_saved_connection => 'otra conexión guardada';

  @override
  String get rel_svc_push_background_notifications =>
      'Notificaciones en segundo plano';

  @override
  String rel_svc_push_bound_subtitle(String bound, String connection) {
    return 'Vinculado a $bound; revoca esa vinculación abajo antes de activarlo para $connection';
  }

  @override
  String rel_svc_push_private_activity(String connection) {
    return 'Actividad privada del servidor para $connection';
  }

  @override
  String rel_svc_push_bound_warning_named(String bound) {
    return 'Vinculado a otra conexión guardada ($bound). Desactiva y revoca esa vinculación antes de activarlo para esta conexión.';
  }

  @override
  String get rel_svc_push_bound_warning =>
      'Vinculado a otra conexión guardada. Desactiva y revoca esa vinculación antes de activarlo para esta conexión.';

  @override
  String get rel_svc_push_local_notifications_muted =>
      'Las notificaciones locales están desactivadas arriba. El consentimiento para notificaciones en segundo plano no cambia, pero los avisos de actividad normales se silencian hasta activar \"Activar notificaciones\".';

  @override
  String rel_svc_push_legacy_subscription(int count) {
    return 'Suscripción antigua: solo $count sesión(es) seleccionada(s). No se ampliará automáticamente. Desactiva y activa para aceptar las sesiones autorizadas por el servidor.';
  }

  @override
  String get rel_svc_push_authorized_binding =>
      'Vinculado solo a esta conexión guardada y perfil. El acceso a las sesiones sigue la autorización actual del servidor.';

  @override
  String get rel_svc_push_revocation_pending =>
      'Revocación del servidor pendiente. La entrega local está desactivada; reinténtalo mientras esté disponible el inicio de sesión guardado original.';

  @override
  String get rel_svc_push_refresh_retry => 'Actualizar / reintentar';

  @override
  String rel_svc_push_disable_named(String bound) {
    return 'Desactivar y revocar $bound';
  }

  @override
  String get rel_svc_push_other_connection => 'otra conexión';

  @override
  String get rel_svc_push_disable => 'Desactivar y revocar';

  @override
  String get rel_svc_push_refresh_explanation =>
      'Actualizar / reintentar vuelve a comprobar la disponibilidad tras configurar el servidor; no puede instalar el componente. Activar las notificaciones sigue siendo una elección aparte.';

  @override
  String get rel_svc_push_companion_required =>
      'Las notificaciones en segundo plano necesitan un componente mobile-push del servidor instalado y activado por separado. Android no puede instalarlo. Actualizar solo el APK no configura el servidor.';

  @override
  String get rel_svc_push_server_setup_guide =>
      'Guía de configuración del servidor';

  @override
  String get rel_svc_push_enable_disclosure =>
      'Activa para solicitar permiso de notificaciones de Android y compartir con este servidor el endpoint y las claves de cifrado de esta instalación. Los avisos de actividad cifrados no contienen contenido del chat. Solo se incluyen sesiones autorizadas por tu inicio de sesión del servidor.';

  @override
  String get rel_svc_push_transport_disclosure =>
      'La entrega integrada usa el transporte push de Google y necesita Google Play Services, pero no incluye el SDK de Firebase. Puede usarse un distribuidor UnifiedPush opcional. La entrega no está garantizada; vuelve a abrir Hermes para conciliar.';

  @override
  String get rel_svc_push_advanced_transport => 'Transporte avanzado';

  @override
  String get rel_svc_push_automatic_explanation =>
      'Automático conserva el distribuidor existente; si no, usa la entrega integrada de Google cuando esté disponible. Desactiva antes de cambiar el transporte.';

  @override
  String get rel_svc_push_transport_label => 'Transporte push';

  @override
  String get rel_svc_push_automatic_recommended => 'Automático (recomendado)';

  @override
  String get rel_svc_push_selected_unavailable =>
      'Distribuidor seleccionado (no disponible)';

  @override
  String get rel_svc_push_no_transport_detected =>
      'No se detectó ningún transporte disponible. La entrega integrada necesita Google Play Services; sin él, instala y configura un distribuidor UnifiedPush y actualiza.';

  @override
  String get rel_svc_push_channel_turns_name => 'Turnos de Ares';

  @override
  String get rel_svc_push_channel_turns_description =>
      'Notificaciones de turnos completados en segundo plano';

  @override
  String get rel_svc_push_channel_attention_name => 'Atención de Ares';

  @override
  String get rel_svc_push_channel_attention_description =>
      'Aprobaciones y solicitudes de entrada que te necesitan';

  @override
  String get rel_svc_push_channel_background_name => 'Ares en segundo plano';

  @override
  String get rel_svc_push_channel_background_description =>
      'Finalizaciones de tareas en segundo plano';

  @override
  String get rel_svc_push_channel_notices_name => 'Avisos de Ares';

  @override
  String get rel_svc_push_channel_notices_description =>
      'Avisos de créditos y complementos';

  @override
  String get rel_svc_push_diag_not_initialised => 'sin inicializar';

  @override
  String get rel_svc_push_diag_replies_off =>
      'las respuestas están desactivadas';

  @override
  String get rel_svc_push_diag_conversation => 'conversación';

  @override
  String get rel_svc_push_diag_conversation_permission_denied =>
      'conversación; permiso denegado';

  @override
  String rel_svc_push_diag_conversation_error(String error) {
    return 'conversación: $error';
  }

  @override
  String get rel_svc_push_diag_failures_off => 'los fallos están desactivados';

  @override
  String rel_svc_push_diag_kind_off(String kind) {
    return '$kind está desactivado';
  }

  @override
  String get rel_svc_push_diag_windows_setting_unknown =>
      'Windows no informó de su ajuste de notificaciones';

  @override
  String get rel_svc_backup_not_hermes_configuration_backup =>
      'Este archivo no es una copia de seguridad de la configuración de Hermes.';

  @override
  String get rel_svc_backup_newer_version_cannot_import =>
      'Esta copia de seguridad se creó con una versión más reciente de la aplicación y no se puede importar.';

  @override
  String get rel_svc_backup_missing_client_certificate =>
      'Esta copia indica un certificado de cliente para una conexión, pero no lo contiene, por lo que no se puede restaurar por completo.';

  @override
  String get rel_svc_backup_damaged_unreadable =>
      'Este archivo de copia de seguridad está dañado y no se pudo leer.';

  @override
  String get rel_svc_backup_unsupported_preference_type =>
      'Una preferencia guardada tiene un tipo no compatible y no se puede exportar.';

  @override
  String get rel_svc_backup_choose_passphrase_api_keys =>
      'Elige una frase de contraseña: la copia de seguridad contiene tus claves de API.';

  @override
  String get rel_svc_backup_could_not_protect_safely =>
      'No se pudo proteger la copia de seguridad de forma segura.';

  @override
  String get rel_svc_backup_unsupported_encryption =>
      'Esta copia de seguridad usa un esquema de cifrado no compatible.';

  @override
  String get rel_svc_backup_wrong_passphrase_or_altered =>
      'La frase de contraseña es incorrecta o este archivo de copia de seguridad se ha modificado.';

  @override
  String get rel_svc_backup_share_subject =>
      'Copia de seguridad de la configuración de Hermes';

  @override
  String get rel_svc_backup_selected_file_unreadable =>
      'No se pudo leer ese archivo.';

  @override
  String rel_svc_backup_connections_added(int count) {
    return '$count añadidas';
  }

  @override
  String rel_svc_backup_connections_updated(int count) {
    return '$count actualizadas';
  }

  @override
  String rel_svc_backup_connections_removed(int count) {
    return '$count eliminadas';
  }

  @override
  String get rel_svc_backup_no_connection_changes =>
      'Sin cambios en las conexiones';

  @override
  String rel_svc_backup_connections_summary(String changes) {
    return 'Conexiones: $changes';
  }

  @override
  String rel_svc_backup_restore_summary(String connections, int count) {
    return '$connections · $count ajustes restaurados';
  }

  @override
  String rel_svc_backup_certificate_not_included(String label, String error) {
    return 'No se pudo incluir el certificado de cliente de «$label» en esta copia de seguridad: $error';
  }

  @override
  String get rel_svc_backup_certificate_password_needed =>
      'Este certificado necesita su contraseña. Introdúcela abajo y se abrirá automáticamente.';

  @override
  String get rel_svc_backup_certificate_password_or_corrupt =>
      'La contraseña del certificado es incorrecta o el archivo está dañado.';

  @override
  String get rel_svc_backup_certificate_password_incorrect =>
      'La contraseña del certificado es incorrecta.';

  @override
  String get rel_svc_backup_certificate_unsupported_encryption =>
      'Este certificado usa un método de cifrado que la aplicación no puede leer.';

  @override
  String get rel_svc_backup_certificate_unreadable_pkcs12 =>
      'El archivo seleccionado no es un certificado PKCS#12 (.p12/.pfx) legible.';

  @override
  String get rel_svc_backup_certificate_unreadable =>
      'No se pudo leer el certificado seleccionado.';

  @override
  String get rel_svc_backup_not_certificate_file =>
      'Ese archivo no es un certificado: elige un contenedor .p12/.pfx o archivos de certificado y clave PEM.';

  @override
  String get rel_svc_backup_not_pem_certificate =>
      'El certificado seleccionado no es un certificado PEM.';

  @override
  String get rel_svc_backup_not_pem_private_key =>
      'La clave privada seleccionada no es una clave privada PEM.';

  @override
  String get rel_svc_backup_certificate_pair_unloadable =>
      'No se pudieron cargar el certificado y la clave privada seleccionados.';

  @override
  String get rel_svc_backup_saved_certificate_files_unreadable =>
      'No se pudieron leer los archivos guardados del certificado de cliente.';

  @override
  String get rel_svc_backup_client_certificate_storage_failed =>
      'No se pudo guardar de forma segura el certificado de cliente en este dispositivo.';

  @override
  String get rel_svc_backup_certificate_storage_failed =>
      'No se pudo guardar de forma segura el certificado en este dispositivo.';

  @override
  String get rel_svc_backup_client_certificate_label =>
      'Certificado de cliente';

  @override
  String rel_svc_backup_search_dashboard_unreachable(String error) {
    return 'No se pudo acceder al panel: $error';
  }

  @override
  String get rel_svc_backup_search_credentials_rejected =>
      'El panel rechazó las credenciales guardadas. Comprueba el nombre de usuario y la contraseña del panel para esta conexión.';

  @override
  String get rel_svc_backup_search_not_supported =>
      'Este panel no ofrece búsqueda de sesiones. Actualiza Hermes en el host o vuelve a la búsqueda en el dispositivo.';

  @override
  String rel_svc_backup_search_redirected(int statusCode) {
    return 'El panel redirigió la búsqueda de sesiones (HTTP $statusCode). Ares no sigue redirecciones con credenciales guardadas; comprueba la dirección de conexión.';
  }

  @override
  String rel_svc_backup_search_http_failed(int statusCode) {
    return 'La búsqueda de sesiones falló con HTTP $statusCode.';
  }

  @override
  String get rel_svc_backup_search_malformed_response =>
      'El panel devolvió una respuesta de búsqueda con formato incorrecto.';

  @override
  String get rel_svc_backup_search_unexpected_response =>
      'El panel devolvió una respuesta de búsqueda inesperada.';

  @override
  String get rel_svc_backup_search_too_many_results =>
      'El panel devolvió más resultados de búsqueda de los solicitados.';

  @override
  String get rel_svc_backup_message_search_unexpected_response =>
      'Respuesta inesperada de búsqueda de mensajes.';

  @override
  String get rel_svc_backup_message_search_unexpected_result =>
      'Resultado inesperado de búsqueda de mensajes.';

  @override
  String get rel_svc_backup_ai_search_api_key_rejected =>
      'La API de Hermes rechazó la clave de API guardada.';

  @override
  String rel_svc_backup_ai_search_http_failed(int statusCode) {
    return 'La reformulación de la consulta con IA falló con HTTP $statusCode.';
  }

  @override
  String get rel_svc_backup_ai_search_no_usable_query =>
      'El modelo seleccionado no devolvió ninguna consulta de búsqueda utilizable.';

  @override
  String get rel_svc_backup_ai_search_malformed_response =>
      'Hermes devolvió una respuesta de reformulación con IA con formato incorrecto.';

  @override
  String get rel_svc_backup_space_name_already_exists =>
      'Ya existe un espacio con este nombre';

  @override
  String get rel_svc_backup_space_name_length_invalid =>
      'El nombre del espacio debe tener entre 1 y 80 caracteres';

  @override
  String get ng_rel_svc_backup_gateway_address_required =>
      'Introduce la dirección de tu panel de Hermes.';

  @override
  String ng_rel_svc_backup_gateway_address_scheme(String scheme) {
    return 'La dirección debe empezar por http:// o https:// (se obtuvo $scheme).';
  }

  @override
  String get ng_rel_svc_backup_gateway_address_invalid =>
      'Esa dirección no es válida.';

  @override
  String get ng_rel_svc_backup_gateway_address_no_host =>
      'La dirección no tiene nombre de host.';

  @override
  String get ng_rel_svc_backup_sign_in_main_window =>
      'Inicia sesión en la ventana principal.';

  @override
  String get rel_svc_backup_sign_in_renewal_failed =>
      'La puerta de enlace no pudo renovar el inicio de sesión ahora mismo.';

  @override
  String get rel_svc_backup_sign_in_provider_unreachable =>
      'La puerta de enlace no pudo renovar el inicio de sesión: no se puede acceder al proveedor de inicio de sesión.';

  @override
  String get rel_svc_backup_sign_in_renewal_timed_out =>
      'Se agotó el tiempo para renovar el inicio de sesión.';

  @override
  String get rel_svc_backup_sign_in_no_tokens =>
      'La puerta de enlace no devolvió tokens de inicio de sesión.';

  @override
  String get ng_rel_svc_backup_probe_timed_out =>
      'Se agotó el tiempo. Comprueba la dirección y la conexión VPN o Tailscale.';

  @override
  String ng_rel_svc_backup_probe_tls_failed(String error) {
    return 'Falló el protocolo de enlace TLS: $error';
  }

  @override
  String ng_rel_svc_backup_gateway_answered_http(int statusCode) {
    return 'La puerta de enlace respondió con HTTP $statusCode.';
  }

  @override
  String get ng_rel_svc_backup_gateway_answer_timed_out =>
      'La puerta de enlace tardó demasiado en responder.';

  @override
  String ng_rel_svc_backup_browser_callback_not_ready(String error) {
    return 'No se pudo preparar el regreso del navegador: $error';
  }

  @override
  String get ng_rel_svc_backup_browser_signed_in_body =>
      'Ya puedes volver a Hermes.';

  @override
  String get ng_rel_svc_backup_browser_waiting_title =>
      'Esperando el inicio de sesión';

  @override
  String get ng_rel_svc_backup_browser_not_current =>
      'Esta página no forma parte del inicio de sesión actual.';

  @override
  String get ng_rel_svc_backup_browser_open_failed =>
      'No se pudo abrir el navegador para iniciar sesión.';

  @override
  String get ng_rel_svc_backup_browser_sign_in_timed_out =>
      'El inicio de sesión tardó demasiado. Inténtalo de nuevo.';

  @override
  String ng_rel_svc_backup_gateway_refused_sign_in(int statusCode) {
    return 'La puerta de enlace rechazó el inicio de sesión (HTTP $statusCode).';
  }

  @override
  String get rel_svc_misc_alert_caution => 'Precaución';

  @override
  String get rel_svc_misc_alert_important => 'Importante';

  @override
  String get rel_svc_misc_alert_tip => 'Consejo';

  @override
  String get rel_svc_misc_alert_warning => 'Advertencia';

  @override
  String get rel_svc_misc_allow_folder_session =>
      'Permitir esta carpeta hasta que termine la sesión.';

  @override
  String get rel_svc_misc_allow_website_session =>
      'Permitir este sitio web hasta que termine la sesión.';

  @override
  String rel_svc_misc_approval_needed_title(String title) {
    return 'Se necesita aprobación — $title';
  }

  @override
  String get rel_svc_misc_attach_file_reference =>
      'Adjuntar una referencia de archivo';

  @override
  String get rel_svc_misc_attach_folder_reference =>
      'Adjuntar una referencia de carpeta';

  @override
  String get rel_svc_misc_attach_git_context => 'Adjuntar contexto de git';

  @override
  String get rel_svc_misc_attach_image_reference =>
      'Adjuntar una referencia de imagen';

  @override
  String get rel_svc_misc_attach_staged_diff => 'Adjuntar el diff preparado';

  @override
  String get rel_svc_misc_attach_tool_reference =>
      'Adjuntar una referencia de herramienta';

  @override
  String get rel_svc_misc_attach_unstaged_diff =>
      'Adjuntar el diff sin preparar';

  @override
  String get rel_svc_misc_attach_url_reference =>
      'Adjuntar una referencia de URL';

  @override
  String get rel_svc_misc_background_task_completed =>
      'Tarea en segundo plano completada';

  @override
  String rel_svc_misc_background_task_named_completed(String taskId) {
    return 'Tarea en segundo plano $taskId completada';
  }

  @override
  String get rel_svc_misc_chat => 'Chat';

  @override
  String get rel_svc_misc_compacting_context =>
      'Compactando el contexto de la conversación…';

  @override
  String rel_svc_misc_completed_in(String duration) {
    return 'Completado en $duration';
  }

  @override
  String get rel_svc_misc_context_compacted =>
      'Contexto de la conversación compactado';

  @override
  String get rel_svc_misc_cron_readback_mismatch =>
      'La lectura del modelo de Cron no coincidió';

  @override
  String get rel_svc_misc_cron_update_rejected =>
      'Actualización de Cron rechazada';

  @override
  String get rel_svc_misc_deny_folder_grant =>
      'No conceder acceso a esta carpeta.';

  @override
  String get rel_svc_misc_deny_website_grant =>
      'No conceder acceso a este sitio web.';

  @override
  String rel_svc_misc_failed_after(String duration) {
    return 'Falló después de $duration';
  }

  @override
  String get rel_svc_misc_gateway_folder_unnamed =>
      'La puerta de enlace no indicó una carpeta.';

  @override
  String get rel_svc_misc_gateway_idle_unconfirmed =>
      'La puerta de enlace está inactiva. No se pudo confirmar el resultado del turno anterior.';

  @override
  String get rel_svc_misc_gateway_turn_failed =>
      'Falló el turno de la puerta de enlace';

  @override
  String rel_svc_misc_gateway_turn_status(String status) {
    return 'Turno de la puerta de enlace: $status';
  }

  @override
  String get rel_svc_misc_gateway_website_unnamed =>
      'La puerta de enlace no indicó un sitio web.';

  @override
  String get rel_svc_misc_hermes_review => 'Revisión de Hermes';

  @override
  String get rel_svc_misc_hermes_turn_failed => 'Falló el turno de Hermes';

  @override
  String get rel_svc_misc_image_recovery_companion_gap =>
      'La recuperación de imágenes y texto no está disponible en la recuperación complementaria. Un envío de imagen sin confirmar no se puede restaurar en esta conexión y nada se vuelve a enviar automáticamente.';

  @override
  String get rel_svc_misc_image_recovery_rest_gap =>
      'La recuperación de imágenes y texto no está disponible en Classic REST/SSE. Un envío de imagen sin confirmar no se puede restaurar en esta conexión y nada se vuelve a enviar automáticamente.';

  @override
  String rel_svc_misc_input_needed_title(String title) {
    return 'Se necesita una respuesta — $title';
  }

  @override
  String get rel_svc_misc_parallel_workspace_connection_changed =>
      'La conexión cambió. Vuelve a abrirla para usar el espacio de trabajo.';

  @override
  String get rel_svc_misc_preparing => 'Preparando';

  @override
  String get rel_svc_misc_save_folder_grant =>
      'Guardar este permiso de carpeta para solicitudes posteriores.';

  @override
  String get rel_svc_misc_save_website_grant =>
      'Guardar este permiso del sitio web para solicitudes posteriores.';

  @override
  String get rel_svc_misc_stored_identity_turn_conflict =>
      'Este chat se abrió mediante su identidad almacenada mientras se admitía otro turno. La instrucción pendiente no se envió; vuelve a intentarlo expresamente cuando termine ese turno.';

  @override
  String get rel_svc_misc_untitled => 'Sin título';

  @override
  String get rel_svc_misc_wake_capture_silent =>
      'La captura de activación del cliente solo detecta silencio; comprueba el acceso al micrófono del sistema operativo y vuelve a activar la palabra de activación.';

  @override
  String get rel_svc_misc_wake_capture_stalled =>
      'La captura de activación del cliente se ha detenido: no llegaron devoluciones de audio del micrófono.';

  @override
  String rel_svc_misc_wake_feed_refused(int count, String detail) {
    return 'El flujo de la palabra de activación rechazó $count fotogramas consecutivos$detail; vuelve a activar la palabra de activación.';
  }

  @override
  String rel_svc_misc_wake_microphone_failed(String error) {
    return 'Falló el flujo del micrófono de activación del cliente: $error';
  }

  @override
  String get rel_svc_misc_wake_track_ended =>
      'La pista del micrófono terminó durante la captura de la palabra de activación; vuelve a activar la palabra de activación.';

  @override
  String get rel_svc_misc_website => 'Sitio web';

  @override
  String get rel_svc_lan_timeout => 'Se agotó el tiempo de detección en la LAN';

  @override
  String get rel_svc_notification_permission_denied => 'permiso denegado';

  @override
  String get rel_svc_notifications_off =>
      'las notificaciones están desactivadas';

  @override
  String rel_chat_preview_pin_label(int number, String note) {
    return 'n.º $number $note';
  }

  @override
  String rel_chat_preview_pin_number(int number) {
    return 'n.º $number';
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
  String get fleet_managed_ssh_title => 'SSH gestionado por la pasarela';

  @override
  String get fleet_managed_ssh_intro =>
      'Gestiona desde cualquier dispositivo los hosts SSH ya guardados en esta pasarela. Hermes debe estar instalado en el host remoto. Esto inicia un servicio remoto propiedad de la pasarela o se conecta a él, no establece una conexión de chat de Ares. Las actualizaciones gestionadas y la recuperación solo están disponibles en la aplicación nativa de escritorio.';

  @override
  String get fleet_managed_ssh_read => 'Leer hosts SSH guardados';

  @override
  String get fleet_managed_ssh_trust =>
      'En esta primera conexión, la pasarela confiará en la clave SSH de este host y la recordará. Cualquier cambio posterior de la clave se detectará y bloqueará. La pasarela no comunica la huella digital de la clave, por lo que Ares no puede mostrarla ni guardarla. Continúa solo si confías en esta primera conexión.';

  @override
  String get fleet_managed_ssh_changed =>
      'La clave SSH de este host ha cambiado. Conexión bloqueada. Alguien con acceso al host de la pasarela debe verificar de forma independiente la huella digital de la nueva clave y eliminar allí la antigua clave de confianza. Vuelve a intentarlo solo después de esa verificación y reparación. Ares no sustituye la clave de confianza.';

  @override
  String get fleet_managed_ssh_disconnect_warning =>
      '¿Desconectar el túnel SSH y detener el servicio remoto propiedad de esta pasarela? Esto puede interrumpir a otros clientes que utilicen ese servicio.';

  @override
  String get fleet_managed_ssh_verify =>
      'Verificar la clave personalmente en su lugar';

  @override
  String fleet_managed_ssh_pending(int seconds) {
    return 'Esperando a la pasarela: $seconds s. Salir de esta página no cancela la puesta en marcha. Si la solicitud falla, comprueba el estado antes de volver a intentarlo.';
  }

  @override
  String fleet_managed_ssh_status(
    String host,
    int localPort,
    int remotePort,
    String version,
    String reused,
  ) {
    return 'Host: $host\nPuerto de bucle local de la pasarela: $localPort\nPuerto de bucle local remoto: $remotePort\nHermes: $version\nReutilizado: $reused';
  }

  @override
  String get fleet_managed_ssh_disconnect => 'Desconectar';

  @override
  String get ng_slash_suggestions_loading => 'Cargando comandos…';

  @override
  String get ng_slash_suggestions_empty => 'No hay comandos que coincidan';

  @override
  String get ng_slash_suggestions_label => 'Sugerencias de comandos';

  @override
  String get ng_slash_suggestions_skill => 'Habilidad';

  @override
  String get settings_classic_title => 'Ajustes de Classic';

  @override
  String get settings_nextgen_title => 'Ajustes de NextGen';

  @override
  String get settings_category_general => 'General e idioma';

  @override
  String get settings_category_chat => 'Chat y sesiones';

  @override
  String get settings_category_device => 'Dispositivo y atajos';

  @override
  String get settings_category_connections => 'Conexiones y modelos';

  @override
  String get settings_category_security => 'Privacidad y copias de seguridad';

  @override
  String get settings_category_about => 'Acerca de y ayuda';

  @override
  String get settings_reopen_chat =>
      'Restaurar el último chat al volver a una puerta de enlace';

  @override
  String get settings_reopen_chat_hint =>
      'Al iniciar desde cero se abre la bienvenida. Los enlaces y las notificaciones abren el chat solicitado.';

  @override
  String get settings_danger => 'Zona de peligro';
}
